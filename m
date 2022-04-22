Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB59450AD99
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 04:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbiDVCLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 22:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiDVCLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 22:11:45 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2664A93B
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 19:08:53 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d15so7681597pll.10
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 19:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tGU0K/EJxxDbBmweff8atM832lgytSb9he/rkce3zvQ=;
        b=YVQ7kSICEskADr8JmScGWjcxFjG1JvTOzuYgzSypS+vzYcdjYUJup1k/Q2btFW+pyF
         4dCaa+qvhnsPGC2w8yOKHZwkpSwWZpDuwUF54gdQd2OAF1YZ9ns5MqMLimCtUgonbPFY
         nkwztCavLkFkUhKFu5GukZwGUoU0lcuCc2q1cMZlochUqP6paWGslVcA0xhmbISzBwqJ
         dT4zlOzP+aKmLJz3uCDXHOPlHeMkegjLbHu4hZ1UcfDEKLeH4vuhd3b9ZcOctZqDP16t
         OkHGnJys4Jr9/pqcgTbJiWfdSjX8KAjq4ygU/i8bwN9AIWn0phMUjJEA9CfrvckMua/w
         nYLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tGU0K/EJxxDbBmweff8atM832lgytSb9he/rkce3zvQ=;
        b=nKMZUEY0cJGSpMd3db8Z8KPMQ6GSarAZMNhYtVOr7tREzUO9zqYQaruGORRYe0yiYg
         xY31ZNRKFTf0pasH1fxMvEhMovlZQphr5eWFs0hV8Qryncj7mGLgvX6pG9jmo/eLEe58
         vcTvw7UVSKu5udwZyKxXA5mtO1JPZ0em69uP2ImBGm4FWsNKrYEH7+S2JWOMXOwzZYdO
         X4vDNRiGF757VRjEysHlOfyMANKI/1khwfGhsTr+bhP6OuOlUxo6Q3jk42aQBPS5ZCib
         4MCoOn1BEj8edMquonTaXOHzknRPJ+IbitNdTSzR64tzGf3TOGIiRl+IexOy53JHMtS7
         cYkg==
X-Gm-Message-State: AOAM532TZLGJ4b/OH45HhW5KA+0FXV43TgF2JAoosEMRW9pKfA7Qes1q
        oIbd0v7GX6S6s6X5DABGKoI=
X-Google-Smtp-Source: ABdhPJydAt6ziMUyapUSN9sMwvtT577wOrAWRKB7gUzSncqG9jt7o9+kSZslaZHcT68AtgrosbGYzA==
X-Received: by 2002:a17:902:d709:b0:155:d473:2be0 with SMTP id w9-20020a170902d70900b00155d4732be0mr2155735ply.151.1650593332643;
        Thu, 21 Apr 2022 19:08:52 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v16-20020a62a510000000b0050759c9a891sm433737pfm.6.2022.04.21.19.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 19:08:51 -0700 (PDT)
Date:   Fri, 22 Apr 2022 10:08:44 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Mike Pattrick <mpattric@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net/af_packet: add VLAN support for AF_PACKET
 SOCK_RAW GSO
Message-ID: <YmIOLBihyeLy+PCS@Laptop-X1>
References: <20220420082758.581245-1-liuhangbin@gmail.com>
 <CA+FuTScyF4BKEcNSCYOv8SBA_EmB806YtKA17jb3F+fymVF-Pg@mail.gmail.com>
 <YmDCHI330AUfcYKa@Laptop-X1>
 <CA+FuTSckEJVUH1Q2vBxGbfPgVteyDVmTfjJC6hBj=qRP+JcAxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSckEJVUH1Q2vBxGbfPgVteyDVmTfjJC6hBj=qRP+JcAxA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,
On Thu, Apr 21, 2022 at 10:15:16AM -0400, Willem de Bruijn wrote:
> Your approach does sound simpler than the above. Thanks for looking
> into that alternative, though.

Sorry I have to bring this topic back. I just remembered that
tpacket_snd() already called skb_probe_transport_header() before calling
virtio_net_hdr_* functions. e.g.

- tpacket_snd()
  - tpacket_fill_skb()
    - packet_parse_headers()
      - skb_probe_transport_header()
  - if (po->has_vnet_hdr)
    - virtio_net_hdr_to_skb()
    - virtio_net_hdr_set_proto()

While for packet_snd()

- packet_snd()
  - if (has_vnet_hdr)
    - virtio_net_hdr_to_skb()
    - virtio_net_hdr_set_proto()
  - packet_parse_headers()
    - skb_probe_transport_header()

If we split skb_probe_transport_header() from packet_parse_headers() and
move it before calling virtio_net_hdr_* function in packet_snd(). Should
we do the same for tpacket_snd(), i.e. move skb_probe_transport_header()
after the virtio_net_hdr_* function?

I think it really doesn't matter whether calls skb_probe_transport_header()
before or after virtio_net_hdr_* functions if we could set the skb->protocol
and network header correctly. Because

- skb_probe_transport_header()
  - skb_flow_dissect_flow_keys_basic()
    - __skb_flow_dissect()

In __skb_flow_dissect()
```
 * @data: raw buffer pointer to the packet, if NULL use skb->data
 * @proto: protocol for which to get the flow, if @data is NULL use skb->protocol
 * @nhoff: network header offset, if @data is NULL use skb_network_offset(skb)
 * @hlen: packet header length, if @data is NULL use skb_headlen(skb)
```

So when data is NULL, we need to make sure the protocol, network header offset,
packet header length are correct.

Before this patch, the VLAN packet network header offset is incorrect when calls
skb_probe_transport_header(). After the fix, this issue should be gone
and we can call skb_probe_transport_header() safely.

So my conclusion is. There is no need to split packet_parse_headers(). Move
packet_parse_headers() before calling virtio_net_hdr_* function in packet_snd()
should be safe.

Please pardon me if I didn't make something clear.
Let's me know what do you think.

Thanks
Hangbin
