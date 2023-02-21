Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D962969E2FE
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 16:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbjBUPDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 10:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbjBUPDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 10:03:44 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15E85FC3
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:03:25 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id w23so4563772qtn.6
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 07:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SXaKdXKdhNzQiu+aS8WC/URdWhGoNF4xzZPy0eiJK5c=;
        b=GqOITOkGFpBMPqnR+X8TRk+3hZAYkzx37jQmU/PEBWExDrcJRod15NUndXcyJJv8Ua
         Y8T4BG7TxkTVin9fSiQKi5HmvXM7uj0ujWGPV6G0x4DRT3YlNQw5VwkTz9WBCOXxbjV1
         Rd+Ce9HmJyQjUO3tfnc8wRwx2eIhHrZSoFEy0rt4Gq4ztIBZVL/K1j9BJYa60ZT0MGv2
         15IjbKBnqWV4khmF4FWIcCXz9yd7F0J7YchoXfp4rql+9HTSUbw0f06cY0BaL4nFtrr2
         Jwrc4fSeT9M7XEA4/rA+3ig2phhClhMDoE34sh7IaLbyTmHTEyU0D86As4X61tcK5j2b
         wvdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SXaKdXKdhNzQiu+aS8WC/URdWhGoNF4xzZPy0eiJK5c=;
        b=0EI5KoyT1V29/6R0s3vdoLrAeJUETL1MI80QuTEdlqHAcdMt8xiOySh00k0ZSFej4D
         /x39YxyN/XdlFdp+0XDjf7O4TC/rgHB3Z10+A0FDbAFx0b+q/KT46dg+1C+2N8n6zG0n
         xstjEjlYt9Dv7IiA/5Yeq0YkvvKkmxSJsUTr7qGdadROf3idNwTlxyy5FsFXi2nayp+4
         KQeDJCN2AKRij54kOt9EfuRAB0YflZD0bCThQ02IaDgthfcrVArKmHzQ3uT2X3BLFg7M
         9zfFxdT1Zo3xSt+0/SkoF4P/eLm4gT+gpibuy8xo0RXsnicFGdcb+AwGtriSgiP/Dz2c
         o8OQ==
X-Gm-Message-State: AO0yUKVmlo/Ax/vK7Co6jpWm0j6dhVaC8LeOOzesRklAUV5rA2PttPfM
        tmbQT4K/4BplP/xh+viyDxA=
X-Google-Smtp-Source: AK7set8sngH3qxnUMYJ/gFbmXehIFVPqMPtfQ9e9vgwGWlviSZCALgrPoroO/7FdndiOhj4a2Tf/vg==
X-Received: by 2002:a05:622a:5:b0:3bf:a72f:d0bd with SMTP id x5-20020a05622a000500b003bfa72fd0bdmr749643qtw.3.1676991804401;
        Tue, 21 Feb 2023 07:03:24 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id s2-20020ac85282000000b003b9a73cd120sm2811117qtn.17.2023.02.21.07.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 07:03:23 -0800 (PST)
Date:   Tue, 21 Feb 2023 10:03:23 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     =?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?= <amy.saq@antgroup.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jasowang@redhat.com,
        =?UTF-8?B?6LCI6Ym06ZSL?= <henry.tjf@antgroup.com>
Message-ID: <63f4dd3b98f0c_cdc03208ea@willemb.c.googlers.com.notmuch>
In-Reply-To: <a737c617-6722-7002-1ead-4c5bed452595@antgroup.com>
References: <1675946595-103034-1-git-send-email-amy.saq@antgroup.com>
 <1675946595-103034-3-git-send-email-amy.saq@antgroup.com>
 <20230209080612-mutt-send-email-mst@kernel.org>
 <858f8db1-c107-1ac5-bcbc-84e0d36c981d@antgroup.com>
 <20230210030710-mutt-send-email-mst@kernel.org>
 <63e665348b566_1b03a820873@willemb.c.googlers.com.notmuch>
 <d759d787-4d76-c8e1-a5e2-233a097679b1@antgroup.com>
 <63eb9a7fe973e_310218208b4@willemb.c.googlers.com.notmuch>
 <a737c617-6722-7002-1ead-4c5bed452595@antgroup.com>
Subject: Re: [PATCH 2/2] net/packet: send and receive pkt with given
 vnet_hdr_sz
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

> =E5=9C=A8 2023/2/14 =E4=B8=8B=E5=8D=8810:28, Willem de Bruijn =E5=86=99=
=E9=81=93:
> > =E6=B2=88=E5=AE=89=E7=90=AA(=E5=87=9B=E7=8E=A5) wrote:
> >> =E5=9C=A8 2023/2/10 =E4=B8=8B=E5=8D=8811:39, Willem de Bruijn =E5=86=
=99=E9=81=93:
> >>> Michael S. Tsirkin wrote:
> >>>> On Fri, Feb 10, 2023 at 12:01:03PM +0800, =E6=B2=88=E5=AE=89=E7=90=
=AA(=E5=87=9B=E7=8E=A5) wrote:
> >>>>> =E5=9C=A8 2023/2/9 =E4=B8=8B=E5=8D=889:07, Michael S. Tsirkin =E5=
=86=99=E9=81=93:
> >>>>>> On Thu, Feb 09, 2023 at 08:43:15PM +0800, =E6=B2=88=E5=AE=89=E7=90=
=AA(=E5=87=9B=E7=8E=A5) wrote:
> >>>>>>> From: "Jianfeng Tan" <henry.tjf@antgroup.com>
> >>>>>>>
> >>>>>>> When raw socket is used as the backend for kernel vhost, curren=
tly it
> >>>>>>> will regard the virtio net header as 10-byte, which is not alwa=
ys the
> >>>>>>> case since some virtio features need virtio net header other th=
an
> >>>>>>> 10-byte, such as mrg_rxbuf and VERSION_1 that both need 12-byte=
 virtio
> >>>>>>> net header.
> >>>>>>>
> >>>>>>> Instead of hardcoding virtio net header length to 10 bytes, tpa=
cket_snd,
> >>>>>>> tpacket_rcv, packet_snd and packet_recvmsg now get the virtio n=
et header
> >>>>>>> size that is recorded in packet_sock to indicate the exact virt=
io net
> >>>>>>> header size that virtio user actually prepares in the packets. =
By doing
> >>>>>>> so, it can fix the issue of incorrect mac header parsing when t=
hese
> >>>>>>> virtio features that need virtio net header other than 10-byte =
are
> >>>>>>> enable.
> >>>>>>>
> >>>>>>> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
> >>>>>>> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
> >>>>>>> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> >>>>>> Does it handle VERSION_1 though? That one is also LE.
> >>>>>> Would it be better to pass a features bitmap instead?
> >>>>> Thanks for quick reply!
> >>>>>
> >>>>> I am a little confused abot what "LE" presents here?
> >>>> LE =3D=3D little_endian.
> >>>> Little endian format.
> >>>>
> >>>>> For passing a features bitmap to af_packet here, our consideratio=
n is
> >>>>> whether it will be too complicated for af_packet to understand th=
e virtio
> >>>>> features bitmap in order to get the vnet header size. For now, al=
l the
> >>>>> virtio features stuff is handled by vhost worker and af_packet ac=
tually does
> >>>>> not need to know much about virtio features. Would it be better i=
f we keep
> >>>>> the virtio feature stuff in user-level and let user-level tell af=
_packet how
> >>>>> much space it should reserve?
> >>>> Presumably, we'd add an API in include/linux/virtio_net.h ?
> >>> Better leave this opaque to packet sockets if they won't act on thi=
s
> >>> type info.
> >>>    =

> >>> This patch series probably should be a single patch btw. As else th=
e
> >>> socket option introduced in the first is broken at that commit, sin=
ce
> >>> the behavior is only introduced in patch 2.
> >>
> >> Good point, will merge this patch series into one patch.
> >>
> >>
> >> Thanks for Michael's enlightening advice, we plan to modify current =
UAPI
> >> change of adding an extra socketopt from only setting vnet header si=
ze
> >> only to setting a bit-map of virtio features, and implement another
> >> helper function in include/linux/virtio_net.h to parse the feature
> >> bit-map. In this case, packet sockets have no need to understand the=

> >> feature bit-map but only pass this bit-map to virtio_net helper and =
get
> >> back the information, such as vnet header size, it needs.
> >>
> >> This change will make the new UAPI more general and avoid further
> >> modification if there are more virtio features to support in the fut=
ure.
> >>
> > Please also comment how these UAPI extension are intended to be used.=

> > As that use is not included in this initial patch series.
> >
> > If the only intended user is vhost-net, we can consider not exposing
> > outside the kernel at all. That makes it easier to iterate if
> > necessary (no stable ABI) and avoids accidentally opening up new
> > avenues for bugs and exploits (syzkaller has a history with
> > virtio_net_header options).
> =

> =

> Our concern is, it seems there is no other solution than uapi to let =

> packet sockets know the vnet header size they should use.
> =

> Receiving packets in vhost driver, implemented in drivers/vhost/net.c: =

> 1109 handle_rx(), will abstract the backend device it uses and directly=
 =

> invoke the corresponding socket ops with no extra information indicatin=
g =

> it is invoked by vhost worker. Vhost worker actually does not know the =

> type of backend device it is using; only virito-user knows what type of=
 =

> backend device it uses. Therefore, it seems impossible to let vhost set=
 =

> the vnet header information to the target backend device.
> =

> Tap, another kind of backend device vhost may use, lets virtio-user set=
 =

> whether it needs vnet header and how long the vnet header is through =

> ioctl. (implemented in drivers/net/tap.c:1066)
> =

> In this case, we wonder whether we should align with what tap does and =

> set vnet hdr size through setsockopt for packet_sockets.
> =

> We really appreciate suggestions on if any, potential approachs to pass=
 =

> this vnet header size information from virtio-user to packet-socket.

You're right. This is configured from userspace before the FD is passed
to vhost-net, so indeed this will require packet socket UAPI support.=
