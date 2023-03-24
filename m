Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369ED6C8286
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 17:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjCXQkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 12:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjCXQkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 12:40:15 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73CD1ACD9
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 09:40:13 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id ga7so1999096qtb.2
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 09:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679676013;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v/uBefpvFBU8pEZvkC7U2ZcYtxD6zZGiyRiO1UMGqLE=;
        b=VIbg2hbMgHJMnIh19Bl7+xgPhTzxJQgdKjRgdRivla2z+jNHuhm0LyWg0Nsj2C+h3R
         h/c0j0TgOZ/73+Cj6xwsb7DJ7z5aQ2EirfK7pTUfNQ4k70jMERH9MGIjJO0z4lpzbGIx
         JSi7c+OEj1jjPTKXmo5hxO+y+gXMpucOXUShV3e8EPjFks64JBzT99O6h4rnPzHAXywm
         dm+Sd7CTmcAkd8UVE/9ufCaYdI27OI6J2+IO/M76/qCs5KT3QsBQx9pYhMsaaKwG3QTg
         8QPlsP1cuo8vL7CCbf0gKRlVtrrAviD7xbNN+rzcGWClvw0Whu3caww0hq6QkusBFklT
         B+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679676013;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v/uBefpvFBU8pEZvkC7U2ZcYtxD6zZGiyRiO1UMGqLE=;
        b=DFB1pw18LmUMoXxbcf5LgJOgNkxPoovMV6iR71+Pvg+EbuoDgDDNYiGK0O144YedL6
         Jn6uUzCl68UV2lZnZrHMzKZW8nOjKnl376JWMDDdiXLnxks0+XFX+udAz5Jb1Z/JNeDU
         Q/VM9F+ghM+7R49834b/qxCTFAovEBjuG/OG/shzvivs4+4xeJgMn//WG6W8vQQzFvRk
         s0Yg/0CqCEe7OmnYsncqoDXgNQLaSh4EInZ/XvWFqOTLDFXomU14SzIR4jDghyL3+EIF
         XM0PuQh9wAywBIMxXjO2tqsDsqTbcYWX/SkiSKGdHU1RWLqs7aPyiYyHR0Mew/ce1nJA
         P3Xg==
X-Gm-Message-State: AO0yUKWupB4H33r2VLtURqfY0LxdywZ/MHwRb77jnnVy0vTDS0t+wFn3
        w6bu4C6Btqp4OnnCp1w7WmPR8bD2msw=
X-Google-Smtp-Source: AK7set/tihSOAN8c8uIO7IkFPcKJAZkAZUx03sXkSfCPIvEOuUPV2Tyfuz2KiSbdxKOpeFiGE/GUjg==
X-Received: by 2002:ac8:5f0b:0:b0:3e3:89b0:231b with SMTP id x11-20020ac85f0b000000b003e389b0231bmr6188609qta.53.1679676012924;
        Fri, 24 Mar 2023 09:40:12 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id 66-20020a370b45000000b0071eddd3bebbsm6079275qkl.81.2023.03.24.09.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 09:40:12 -0700 (PDT)
Date:   Fri, 24 Mar 2023 12:40:12 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     mst@redhat.com, davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Message-ID: <641dd26c30a9b_f8c982085a@willemb.c.googlers.com.notmuch>
In-Reply-To: <6fc5ed03-5872-0d9f-ea5a-48857b5cc7c1@antgroup.com>
References: <20230317074304.275598-1-amy.saq@antgroup.com>
 <641474b7cf005_36045220894@willemb.c.googlers.com.notmuch>
 <6fc5ed03-5872-0d9f-ea5a-48857b5cc7c1@antgroup.com>
Subject: Re: [PATCH v5] net/packet: support mergeable feature of virtio
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E6=B2=88=E5=AE=89=E7=90=AA(=E5=87=9B=E7=8E=A5) wrote:
> =

> =E5=9C=A8 2023/3/17 =E4=B8=8B=E5=8D=8810:09, Willem de Bruijn =E5=86=99=
=E9=81=93:
> > =E6=B2=88=E5=AE=89=E7=90=AA(=E5=87=9B=E7=8E=A5) wrote:
> >> From: Jianfeng Tan <henry.tjf@antgroup.com>
> >>
> >> Packet sockets, like tap, can be used as the backend for kernel vhos=
t.
> >> In packet sockets, virtio net header size is currently hardcoded to =
be
> >> the size of struct virtio_net_hdr, which is 10 bytes; however, it is=
 not
> >> always the case: some virtio features, such as mrg_rxbuf, need virti=
o
> >> net header to be 12-byte long.
> >>
> >> Mergeable buffers, as a virtio feature, is worthy of supporting: pac=
kets
> >> that are larger than one-mbuf size will be dropped in vhost worker's=

> >> handle_rx if mrg_rxbuf feature is not used, but large packets
> >> cannot be avoided and increasing mbuf's size is not economical.
> >>
> >> With this virtio feature enabled by virtio-user, packet sockets with=

> >> hardcoded 10-byte virtio net header will parse mac head incorrectly =
in
> >> packet_snd by taking the last two bytes of virtio net header as part=
 of
> >> mac header.
> >> This incorrect mac header parsing will cause packet to be dropped du=
e to
> >> invalid ether head checking in later under-layer device packet recei=
ving.
> >>
> >> By adding extra field vnet_hdr_sz with utilizing holes in struct
> >> packet_sock to record currently used virtio net header size and supp=
orting
> >> extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packe=
t
> >> sockets can know the exact length of virtio net header that virtio u=
ser
> >> gives.
> >> In packet_snd, tpacket_snd and packet_recvmsg, instead of using
> >> hardcoded virtio net header size, it can get the exact vnet_hdr_sz f=
rom
> >> corresponding packet_sock, and parse mac header correctly based on t=
his
> >> information to avoid the packets being mistakenly dropped.
> >>
> >> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> >> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> >> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> > Another patch set was just merged that this will have merge conflicts=

> > with. Please respin.
> >
> > https://lore.kernel.org/netdev/20230316011014.992179-4-edumazet@googl=
e.com/T/
> =

> =

> Sure thing. We are going to rebase it. The recently-merged patch =

> compacted all bit flags into one long flags field and getting the bit =

> information through the helper function.
> =

> Since our patch removes has_vnet_hdr bit and uses vnet_hdr_sz, which =

> cannot fit in one bit, to indicate whether the packet sock has vnet =

> header or not, we plan to remove PACKET_SOCK_HAS_VNET_HDR from =

> packet_sock_flags and keep the u8 field vnet_hdr_sz in struct =

> packet_sock. After modification, the packet_sock struct will be followi=
ng:
> =

> @@ -119,9 +119,9 @@ struct packet_sock {
>   	unsigned long		flags;
>   	int			ifindex;	/* bound device		*/
> +	u8			vnet_hdr_sz;
>   	__be16			num;
> =

> =

> I wonder whether this rebase plan looks appropriate for you and am =

> looking forward to your advice here.
> =

> If we are good on the rebasing plan, we will soon send out next version=
 =

> with conflicts resolved. :) Thanks a lot.

Makes sense to me. =



