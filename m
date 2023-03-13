Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA4E6B79D3
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjCMOCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjCMOCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:02:46 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F9F23C79
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 07:02:23 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id e26-20020a9d6e1a000000b00694274b5d3aso6722886otr.5
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 07:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678716141;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0L40SZLaj7Hvmq0Ss0WSKCvwP/Pr2STg0OdyBb95p0g=;
        b=BOOTPuX9xP4jMCnS2VSSv/70lByp1TyEv2uH23WlMF/qxPYjbJF7yLtN3YmOGl3jin
         yTgtFmGWl8FT94tm+uZtM+D8Zq3SFn9Bp4zRwZY+ANUalMQqIXPbFmotIT+UGb3ebKZ0
         vs/c8Dn1Ye0HKePOTUhQejh5l5skrvkbW5aRAF1Cn01s/XSOW3jKByCGwlv1ZXAaSLvE
         bkFt5qj25cNFvcNyyNhRMMaqEvLV3DH/Yam5Ob4mf7EEjVodg79cAHWK22FOaOBt/0Pg
         EhxCS4lEcsGkxZfxUEGotsDYymp6wwN6GMupRPuxkEv8YkYyV9SEKRxjzKuoQbnl18Ae
         e9/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678716141;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0L40SZLaj7Hvmq0Ss0WSKCvwP/Pr2STg0OdyBb95p0g=;
        b=gjhM1uq2bcZ1oSt4ZaE8bFSR1giDeVSzqu5Rx0KCta4ayRAqWo7n2MMyAeTTIvv3vQ
         uRROofxQUvnvUJxZlrOzhiDgMFU1nZ0wL/unFcm91O5rHhuJV8R9XCRfKpO9o5aU+DoK
         A2QC58z6hoG9ODL+GMQCMY9WucKMongSWpFXCdWnmYmSQWlqgmop+d0cQljg3hTitNgY
         rlpxHu7Anqd54TKbPYo1vHOMRCteIoL9wtM2rT8QJux0MEu7MTjIa+cWEQOe9pN+vIeB
         BjlommtSKf1iGCrYRBwZhUN50HKeCT6AljB4dpnnkjme1vmUKAVjRfZU3aM4DKuaoe5w
         rYtQ==
X-Gm-Message-State: AO0yUKUXvuZjfaC27P2UnERErjXTe5638h8ffQDX2+bWrRoV7IK+sReT
        L0TKUHttsH4feC4kBrDDz6Q=
X-Google-Smtp-Source: AK7set/nycrq5RJOGAuzm87vilGbtdlm0kXpT1bv4Ef6CxD9G/p59rjH1CVRrwIrJ+fOjd95qqIxCA==
X-Received: by 2002:a05:6830:43a1:b0:684:e812:caf with SMTP id s33-20020a05683043a100b00684e8120cafmr25808545otv.13.1678716140711;
        Mon, 13 Mar 2023 07:02:20 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id 196-20020a3703cd000000b00729a26e836esm5364073qkd.84.2023.03.13.07.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 07:01:50 -0700 (PDT)
Date:   Mon, 13 Mar 2023 10:01:18 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Message-ID: <640f2cae6b7de_28b1eb208ed@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230313090729-mutt-send-email-mst@kernel.org>
References: <1678689073-101893-1-git-send-email-amy.saq@antgroup.com>
 <20230313024705-mutt-send-email-mst@kernel.org>
 <17bc8313-7217-a2c9-cb12-fd0777c0d20d@antgroup.com>
 <20230313062610-mutt-send-email-mst@kernel.org>
 <32404b2b-d8df-930a-3813-c016ee3d5137@antgroup.com>
 <20230313090729-mutt-send-email-mst@kernel.org>
Subject: Re: [PATCH v4] net/packet: support mergeable feature of virtio
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

Michael S. Tsirkin wrote:
> On Mon, Mar 13, 2023 at 07:58:25PM +0800, =E6=B2=88=E5=AE=89=E7=90=AA(=E5=
=87=9B=E7=8E=A5) wrote:
> > =

> > =E5=9C=A8 2023/3/13 =E4=B8=8B=E5=8D=886:27, Michael S. Tsirkin =E5=86=
=99=E9=81=93:
> > > On Mon, Mar 13, 2023 at 04:00:06PM +0800, =E6=B2=88=E5=AE=89=E7=90=AA=
(=E5=87=9B=E7=8E=A5) wrote:
> > > > =E5=9C=A8 2023/3/13 =E4=B8=8B=E5=8D=882:51, Michael S. Tsirkin =E5=
=86=99=E9=81=93:
> > > > > On Mon, Mar 13, 2023 at 02:31:13PM +0800, =E6=B2=88=E5=AE=89=E7=
=90=AA(=E5=87=9B=E7=8E=A5) wrote:
> > > > > > From: Jianfeng Tan <henry.tjf@antgroup.com>
> > > > > > =

> > > > > > Packet sockets, like tap, can be used as the backend for kern=
el vhost.
> > > > > > In packet sockets, virtio net header size is currently hardco=
ded to be
> > > > > > the size of struct virtio_net_hdr, which is 10 bytes; however=
, it is not
> > > > > > always the case: some virtio features, such as mrg_rxbuf, nee=
d virtio
> > > > > > net headers to be 12-byte long.
> > > > > > =

> > > > > > Mergeable buffers, as a virtio feature, is worthy of supporti=
ng: packets
> > > > > > that are larger than one-mbuf size will be dropped in vhost w=
orker's
> > > > > > handle_rx if mrg_rxbuf feature is not used, but large packets=

> > > > > > cannot be avoided and increasing mbuf's size is not economica=
l.
> > > > > > =

> > > > > > With this virtio feature enabled by virtio-user, packet socke=
ts with
> > > > > > hardcoded 10-byte virtio net header will parse mac head incor=
rectly in
> > > > > > packet_snd by taking the last two bytes of virtio net header =
as part of
> > > > > > mac header.
> > > > > > This incorrect mac header parsing will cause packet to be dro=
pped due to
> > > > > > invalid ether head checking in later under-layer device packe=
t receiving.
> > > > > > =

> > > > > > By adding extra field vnet_hdr_sz with utilizing holes in str=
uct
> > > > > > packet_sock to record currently used virtio net header size a=
nd supporting
> > > > > > extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz=
, packet
> > > > > > sockets can know the exact length of virtio net header that v=
irtio user
> > > > > > gives.
> > > > > > In packet_snd, tpacket_snd and packet_recvmsg, instead of usi=
ng
> > > > > > hardcoded virtio net header size, it can get the exact vnet_h=
dr_sz from
> > > > > > corresponding packet_sock, and parse mac header correctly bas=
ed on this
> > > > > > information to avoid the packets being mistakenly dropped.
> > > > > > =

> > > > > > Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> > > > > > Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> > > > > > Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> > > > > > ---
> > > > > > =

> > > > > > V3 -> V4:
> > > > > > * read po->vnet_hdr_sz once during vnet_hdr_sz and use vnet_h=
dr_sz locally
> > > > > > to avoid race condition;
> > > > > Wait a second. What kind of race condition? And what happens if=

> > > > > it does trigger? By once do you mean this:
> > > > > 	int vnet_hdr_sz =3D po->vnet_hdr_sz;
> > > > > ?  This is not guaranteed to read the value once, compiler is f=
ree
> > > > > to read as many times as it likes.
> > > > > =

> > > > > See e.g. memory barriers doc:
> > > > > =

> > > > >    (*) It _must_not_ be assumed that the compiler will do what =
you want
> > > > >        with memory references that are not protected by READ_ON=
CE() and
> > > > >        WRITE_ONCE().  Without them, the compiler is within its =
rights to
> > > > >        do all sorts of "creative" transformations, which are co=
vered in
> > > > >        the COMPILER BARRIER section.
> > > > > =

> > > > The expression "read once" may be a little confused here. The rac=
e condition
> > > > we want to avoid is:
> > > > =

> > > > if (po->vnet_hdr_sz !=3D 0) {
> > > > 	vnet_hdr_sz =3D po->vnet_hdr_sz;
> > > > 	...
> > > > }
> > > > =

> > > > Here we read po->vnet_hdr_sz for if condition first and then read=
 it again to assign the value of vnet_hdr_sz; according to Willem's comme=
nt here, it might be a race condition with an update to virtio net header=
 length, causing the vnet header size we used to check in if condition is=
 not exactly the value we use as vnet_hdr_sz later.
> > > > =

> > > Above comment seems to apply.

Good point. This should use READ_ONCE to be sure.

The suggestion was based on a similar need in has_vnet_hdr itself.
da7c9561015e ("packet: only test po->has_vnet_hdr once in packet_snd").=
