Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBB56B288A
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 16:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjCIPS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 10:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjCIPS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 10:18:26 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A74448E13
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 07:18:25 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id l13so2311587qtv.3
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 07:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678375104;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oa0YsgxOzK+EtELm8WC1Gq5wZ/vYVP3Zcld1xQlct6Q=;
        b=fGIj3hGH16ZdX0t5tV6ov59DTaH54hTXRtxi9Sx8cvv1U8IZxovns/ppFZ3WAv9lxU
         9p3/2ukismrGicrr95JwJb1AGctELpBlbWVTwQxs13Rzd6L7XujQOD1jcG67ORkxIN6O
         BpcWNX15RCkLWKZyOYNteMuJSJU8O5878QypEM5tLqVOoG8ZhUHPDuPG7K/MBfzVaZoI
         NrUS5mmK5zXfJV+uCjBsICDwCJNqrk7JdJcDrxFMFvSgKJzjCIr2m4KXhvwElGxveUSg
         VVIH4ZD64nP9Y+HSMLprJw4Sd8rbly+RxeORASzkTId87YcH3XRqX0DY66QZ/1vpf5Td
         n+aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678375104;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Oa0YsgxOzK+EtELm8WC1Gq5wZ/vYVP3Zcld1xQlct6Q=;
        b=NqAriX3HFtZ465zkBPD1vv7ftBq3w15crJc2cOA6yhMWZxWlQsE/bBtlBuX3v4N02T
         sESA5Qdk3n/Dt9JHEF+Pq3PkP7lrvriKBLDi6NiWGRlVz7gdZlwKZWlYMXWm1Ceh8gsI
         +7iAY0Gey5uGhIkE3pOMca2FqAAnTeeeMgnisoQ1C42/LWZ3gcMoJ88F0VgBQarVOOjM
         a0DxPfJD/vFOdQkupEBAOeh+dssJnVs5IhTn/lM5PnUWAMpJ4XtIHVWLNv7azU0TJ01z
         UtYBZ+MxEdBfGfO6s+zbO0Ir3DzPl82pTuGOc6ruH/8rlX5vTbTM7i5RwSTEze9nWyXx
         JE6Q==
X-Gm-Message-State: AO0yUKVlTDKQ/9tqoI5e00AUV1okNVASMBRopFXkMGwfpk0G/Leu+7wf
        KoeIae9npVukgEQ18j+2Zs6rbT3moRo=
X-Google-Smtp-Source: AK7set9EmZI+k9gip99vczTmrtlZ0WxAFeHAmOrBV+YPwOEnyLXROPLYClX+h6HaIbVmR3usTNQ2Zg==
X-Received: by 2002:a05:622a:24b:b0:3b9:b422:4d69 with SMTP id c11-20020a05622a024b00b003b9b4224d69mr40463792qtx.39.1678375104105;
        Thu, 09 Mar 2023 07:18:24 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id f13-20020ac87f0d000000b003b9b48cdbe8sm10406404qtk.58.2023.03.09.07.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 07:18:23 -0800 (PST)
Date:   Thu, 09 Mar 2023 10:18:23 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     mst@redhat.com, davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Message-ID: <6409f8bf71c9e_1abbab2088e@willemb.c.googlers.com.notmuch>
In-Reply-To: <a55816a9-073b-c030-f7f8-19588124e08b@antgroup.com>
References: <1678168911-337042-1-git-send-email-amy.saq@antgroup.com>
 <64075d1f7ccfc_efd1020865@willemb.c.googlers.com.notmuch>
 <a55816a9-073b-c030-f7f8-19588124e08b@antgroup.com>
Subject: Re: [PATCH v3] net/packet: support mergeable feature of virtio
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E6=B2=88=E5=AE=89=E7=90=AA(=E5=87=9B=E7=8E=A5) wrote:
> =

> =E5=9C=A8 2023/3/7 =E4=B8=8B=E5=8D=8811:49, Willem de Bruijn =E5=86=99=E9=
=81=93:
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
> >> With this mergeable feature enabled by virtio-user, packet sockets w=
ith
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
> >> Besides, has_vnet_hdr field in struct packet_sock is removed since a=
ll
> >> the information it provides is covered by vnet_hdr_sz field: a packe=
t
> >> socket has a vnet header if and only if its vnet_hdr_sz is not zero.=

> >>
> >> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> >> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> >> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> >> ---
> >> diff --git a/net/packet/internal.h b/net/packet/internal.h
> >> index 48af35b..9b52d93 100644
> >> --- a/net/packet/internal.h
> >> +++ b/net/packet/internal.h
> >> @@ -119,9 +119,9 @@ struct packet_sock {
> >>   	unsigned int		running;	/* bind_lock must be held */
> >>   	unsigned int		auxdata:1,	/* writer must hold sock lock */
> >>   				origdev:1,
> >> -				has_vnet_hdr:1,
> >>   				tp_loss:1,
> >> -				tp_tx_has_off:1;
> >> +				tp_tx_has_off:1,
> >> +				vnet_hdr_sz:8;
> > just a separate u8 variable , rather than 8 bits in a u32.
> >
> >>   	int			pressure;
> >>   	int			ifindex;	/* bound device		*/
> =

> =

> We plan to add
> =

> +	   u8	vnet_hdr_sz:8;
> =

> here.
> Is this a proper place to add this field to make sure the cacheline wil=
l not be broken?

When in doubt, use pahole (`pahole -C packet_sock net/packet/af_packet.o`=
).

There currently is a 27-bit hole before pressure. That would be a good sp=
ot. =

> =

> >>   	__be16			num;
> >> -- =

> >> 1.8.3.1
> >>


