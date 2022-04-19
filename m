Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8AD3506273
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 05:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345994AbiDSDFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 23:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbiDSDFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 23:05:33 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A75E0D1
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 20:02:51 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id bx5so14582603pjb.3
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 20:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5i7Ln21JKUUci5KZ3NRFOosNgGv+lh6PXeaEInDMuRY=;
        b=j5CCpxPOh2xxT7d61jpkkHseGA5ShPEluFdDMksvvY8mUUyXA3xfppLsKvwH6cj3yj
         U6bRwM6AFVATWk0gChgVcFs5ankcBDH3NtRYwMBRIKSu4JdF/iefju3FeWohO6DwzGjD
         hGKKpD8kkcg6b5w8oWKxwERGTtkP4MTDlRLpKGF9s7PiVBSGscOhrVpGeMCfPteELtJG
         +HpACn9TJ8ySlCj2bnb55YvJuh7ldsqpPA4EQqYuE4mKks1TPbFcPFvvNidRnpK2hFH2
         sp5QTKTycqGlPhuLPs3nvyGnAkHT1ySbNmQxbN/4EzImNNKLWkmdxxw2ERzarGTbh+hL
         U8zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5i7Ln21JKUUci5KZ3NRFOosNgGv+lh6PXeaEInDMuRY=;
        b=3394o2M9uk4M1kKM70uPa93SRn6EHsNl/egkEiNxgToGJWeY5aOl1LX+r3rfZTEfZf
         LzK3RxfncAQ4+Y/0WZ/QAhNqIyGAfDI0wZk/iFSVj6rNBDlGi2MHJdqjI9P+1hbLnQ0u
         46ReHUrwKiJzncZ9PB9OSThq7d+7Wee9eSIpxYwKVX00HiqGxM3GVQeayalCUZ+L5mNT
         KeWW4/gRvTLyW2o/OVbI9/d0ObjbEgFghzy4M/gI3YKAoQRxQTzjJxhYcMX+SpqPdIwW
         WlGIBlTV4PCKTgwc3+VR/FZEclYVzIp3d6oqotfTj4W7pxSkqNCUV5H7AH1bp/JGQLFn
         PBgQ==
X-Gm-Message-State: AOAM532cHG1VMrLGmJe04WyT7MY0x41MuzQ59l2bBmWWMI7VUk2A6TZW
        t3nnQPjhpBWkbS0prOkWG+Y=
X-Google-Smtp-Source: ABdhPJwttfUwgseTl+7ZUSrGLbIpSkEb/bbT5yCp+5LNDaKuxa6MzpdX/Kmhg9RTNq4LlAGo3hyBVQ==
X-Received: by 2002:a17:902:b684:b0:156:80b4:db03 with SMTP id c4-20020a170902b68400b0015680b4db03mr13999480pls.16.1650337371277;
        Mon, 18 Apr 2022 20:02:51 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i11-20020a654d0b000000b0039d82c3e68csm14398933pgt.55.2022.04.18.20.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 20:02:50 -0700 (PDT)
Date:   Tue, 19 Apr 2022 11:02:43 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Mike Pattrick <mpattric@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Flavio Leitner <fbl@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 1/2] net/af_packet: adjust network header position
 for VLAN tagged packets
Message-ID: <Yl4mU0XLmPukG0WO@Laptop-X1>
References: <20220418044339.127545-1-liuhangbin@gmail.com>
 <20220418044339.127545-2-liuhangbin@gmail.com>
 <CA+FuTScQ=tP=cr5f2S97Z7ex1HMX5R-C0W6JE2Bx5UWgiGknZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTScQ=tP=cr5f2S97Z7ex1HMX5R-C0W6JE2Bx5UWgiGknZA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 18, 2022 at 11:38:14AM -0400, Willem de Bruijn wrote:
> Strictly speaking VLAN tagged GSO packets have never been supported.

OK, I thought we just forgot to handle the VLAN header for RAW af socket.
As in the later path skb_mac_gso_segment() deal with VLAN correctly.

If you think this should be a new feature instead of fixes. I can remove the
fixes tag and re-post it to net-next, as you said.

> The only defined types are TCP and UDP over IPv4 and IPv6:
> 
>   define VIRTIO_NET_HDR_GSO_TCPV4        1       /* GSO frame, IPv4 TCP (TSO) */
>   define VIRTIO_NET_HDR_GSO_UDP          3       /* GSO frame, IPv4 UDP (UFO) */
>   define VIRTIO_NET_HDR_GSO_TCPV6        4       /* GSO frame, IPv6 TCP */
> 
> I don't think this is a bug, more a stretching of the definition of those flags.

I think VLAN is a L2 header, so I just reset the network header position.

I'm not familiar with virtio coded. Do you mean to add a new flag like VIRTIO_NET_HDR_GSO_VLAN?
> > @@ -3055,11 +3068,6 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
> >                 virtio_net_hdr_set_proto(skb, &vnet_hdr);
> >         }
> >
> > -       packet_parse_headers(skb, sock);
> > -
> > -       if (unlikely(extra_len == 4))
> > -               skb->no_fcs = 1;
> > -
> 
> Moving packet_parse_headers before or after virtio_net_hdr_to_skb may
> have additional subtle effects on protocol detection.
> 
> I think it's probably okay, as tpacket_snd also calls in the inverse
> order. But there have been many issues in this codepath.

Yes

> 
> We should also maintain feature consistency between packet_snd,
> tpacket_snd and to the limitations of its feature set to
> packet_sendmsg_spkt. The no_fcs is already lacking in tpacket_snd as
> far as I can tell. But packet_sendmsg_spkt also sets it and calls
> packet_parse_headers.

Yes, I think we could fix the tpacket_snd() in another patch.

There are also some duplicated codes in these *_snd functions.
I think we can move them out to one single function.

> Because this patch touches many other packets besides the ones
> intended, I am a bit concerned about unintended consequences. Perhaps

Yes, makes sense.

> stretching the definition of the flags to include VLAN is acceptable
> (unlike outright tunnels), but even then I would suggest for net-next.

As I asked, I'm not familiar with virtio code. Do you think if I should
add a new VIRTIO_NET_HDR_GSO_VLAN flag? It's only a L2 flag without any L3
info. If I add something like VIRTIO_NET_HDR_GSO_VLAN_TCPV4/TCPV6/UDP. That
would add more combinations. Which doesn't like a good idea.

Thanks
Hangbin
