Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310A861EC23
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiKGHfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiKGHfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:35:34 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1839D5F51;
        Sun,  6 Nov 2022 23:35:34 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d20so9243961plr.10;
        Sun, 06 Nov 2022 23:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G/umIMIn7QwrlwD2FDIhmw1+/5xDnupaEF2D59WiIPc=;
        b=l+EtDMmHV9cHEOQG0c94ZKw1JCVIHlaQzH3tZnG8YAVl75UUfldCWY3V2KLqE6VYQF
         SmmeA4ZBFO72tKpyDtSp3yacShaOOT93R1tjnMnHTymYP3zZBRf9xuvlLEQs965aY0Wn
         ADVG28tv8/Dvde//Wnioboh8llwH28Bs/S6v603EQ6zTCXFlsOzvJJPSIhmdFt6NjJOI
         UncThvRnXAMCz30Qwv0pq/jOq0+OshbqO+YZXPv/ZfjP1JtPzmwmid3gKBfRhAvqfjez
         x3Glna43AtzxUaUMlFsh9zVGvIvJFtGvERvujei3rLTCcwI/nCAZ0tap6jBHAx0VTAxW
         y4uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/umIMIn7QwrlwD2FDIhmw1+/5xDnupaEF2D59WiIPc=;
        b=rgm/9gLAkAuxXNpBDW3Z86PiXaR+//hOyuHABBbt7ErOMjugU7BRmOmkxRgUojSYjF
         GRvSy6TWbOsvB135aOkxgzK69p3wTbXp8NS1GCaKNuG7L7ok2i/gKoKE2DZ+fHGJ8U/U
         oOpzioa22+UmrpcI8NUdOubcDW6h4r/A8ESqOEb07rhwA6fJNual7zVybXKmoh1UPD9t
         C2l+gIZa1BhoN/plX4NzCeh1BsNquqgbb0rNmgm+Sfob8WKExJf/pw8VlzvcubvrFKIy
         GDOEiLnVa5nSskzwuH1BIOhFuEXKWzUIoh2IHIu+BqcSTyTX+ds1PwZDkjEVvO3B6smp
         gD5w==
X-Gm-Message-State: ACrzQf3I6DJw10TZk1P7UWz3z/ALLGkKLykDj7+7V6bOLqLQGJhAPY0A
        e4dV6Wy/t2fA0QeJ97mRrjrSFhUz2G5++aRqAik=
X-Google-Smtp-Source: AMsMyM6xKgw+vKXJCoghoQ+HXi896+DWoxDySzItVnIlbxn5ugc3K5czAuc9isXXRTPyt0vnobJLsR7RiifajHHc9MU=
X-Received: by 2002:a17:90b:4ac3:b0:213:3918:f276 with SMTP id
 mh3-20020a17090b4ac300b002133918f276mr65419929pjb.19.1667806533470; Sun, 06
 Nov 2022 23:35:33 -0800 (PST)
MIME-Version: 1.0
References: <20221104172421.8271-1-Harald.Mommer@opensynergy.com>
 <20221104172421.8271-2-Harald.Mommer@opensynergy.com> <4782632.31r3eYUQgx@steina-w>
In-Reply-To: <4782632.31r3eYUQgx@steina-w>
From:   Vincent Mailhol <vincent.mailhol@gmail.com>
Date:   Mon, 7 Nov 2022 16:35:22 +0900
Message-ID: <CAMZ6RqLALOYFWQJ4C4HTaRw7y-waUbqOX0WzrWVNiQG51QexHw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/2] can: virtio: Initial virtio CAN driver.
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harald Mommer <Harald.Mommer@opensynergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 7 Nov. 2022 at 16:15, Alexander Stein
<alexander.stein@ew.tq-group.com> wrote:
> Am Freitag, 4. November 2022, 18:24:20 CET schrieb Harald Mommer:
> > From: Harald Mommer <harald.mommer@opensynergy.com>
> >
> > - CAN Control
> >
> >   - "ip link set up can0" starts the virtual CAN controller,
> >   - "ip link set up can0" stops the virtual CAN controller
> >
> > - CAN RX
> >
> >   Receive CAN frames. CAN frames can be standard or extended, classic or
> >   CAN FD. Classic CAN RTR frames are supported.
> >
> > - CAN TX
> >
> >   Send CAN frames. CAN frames can be standard or extended, classic or
> >   CAN FD. Classic CAN RTR frames are supported.
> >
> > - CAN Event indication (BusOff)
> >
> >   The bus off handling is considered code complete but until now bus off
> >   handling is largely untested.
> >
> > This is version 2 of the driver after having gotten review comments.
> >
> > Signed-off-by: Harald Mommer <Harald.Mommer@opensynergy.com>
> > Cc: Damir Shaikhutdinov <Damir.Shaikhutdinov@opensynergy.com>

[...]

> > diff --git a/include/uapi/linux/virtio_can.h
> > b/include/uapi/linux/virtio_can.h new file mode 100644
> > index 000000000000..0ca75c7a98ee
> > --- /dev/null
> > +++ b/include/uapi/linux/virtio_can.h
> > @@ -0,0 +1,69 @@
> > +/* SPDX-License-Identifier: BSD-3-Clause */
> > +/*
> > + * Copyright (C) 2021 OpenSynergy GmbH
> > + */
> > +#ifndef _LINUX_VIRTIO_VIRTIO_CAN_H
> > +#define _LINUX_VIRTIO_VIRTIO_CAN_H
> > +
> > +#include <linux/types.h>
> > +#include <linux/virtio_types.h>
> > +#include <linux/virtio_ids.h>
> > +#include <linux/virtio_config.h>
> > +
> > +/* Feature bit numbers */
> > +#define VIRTIO_CAN_F_CAN_CLASSIC        0u
> > +#define VIRTIO_CAN_F_CAN_FD             1u
> > +#define VIRTIO_CAN_F_LATE_TX_ACK        2u
> > +#define VIRTIO_CAN_F_RTR_FRAMES         3u
> > +
> > +/* CAN Result Types */
> > +#define VIRTIO_CAN_RESULT_OK            0u
> > +#define VIRTIO_CAN_RESULT_NOT_OK        1u
> > +
> > +/* CAN flags to determine type of CAN Id */
> > +#define VIRTIO_CAN_FLAGS_EXTENDED       0x8000u
> > +#define VIRTIO_CAN_FLAGS_FD             0x4000u
> > +#define VIRTIO_CAN_FLAGS_RTR            0x2000u
> > +
> > +/* TX queue message types */
> > +struct virtio_can_tx_out {
> > +#define VIRTIO_CAN_TX                   0x0001u
> > +     __le16 msg_type;
> > +     __le16 reserved;
> > +     __le32 flags;
> > +     __le32 can_id;
> > +     __u8 sdu[64u];
>
> 64u is CANFD_MAX_DLEN, right? Is it sensible to use that define instead?
> I guess if CAN XL support is to be added at some point, a dedicated struct is
> needed, to fit for CANXL_MAX_DLEN (2048 [1]).
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
> commit/?id=1a3e3034c049503ec6992a4a7d573e7fff31fac4

To add to Alexander's comment, what is the reason to have the msg_type
flag? The struct can_frame, canfd_frame and canxl_frame are done such
that it is feasible to decide the type (Classic, FD, XL) from the
content of the structure. Why not just reusing the current structures?

> > +};
> > +
> > +struct virtio_can_tx_in {
> > +     __u8 result;
> > +};
> > +
> > +/* RX queue message types */
> > +struct virtio_can_rx {
> > +#define VIRTIO_CAN_RX                   0x0101u
> > +     __le16 msg_type;
> > +     __le16 reserved;
> > +     __le32 flags;
> > +     __le32 can_id;
> > +     __u8 sdu[64u];
> > +};
>
> I have no experience with virtio drivers, but is there a need for dedicated
> structs for Tx and Rx? They are identical anyway.
>
> Best regards,
> Alexander
>
> > +
> > +/* Control queue message types */
> > +struct virtio_can_control_out {
> > +#define VIRTIO_CAN_SET_CTRL_MODE_START  0x0201u
> > +#define VIRTIO_CAN_SET_CTRL_MODE_STOP   0x0202u
> > +     __le16 msg_type;
> > +};
> > +
> > +struct virtio_can_control_in {
> > +     __u8 result;
> > +};
> > +
> > +/* Indication queue message types */
> > +struct virtio_can_event_ind {
> > +#define VIRTIO_CAN_BUSOFF_IND           0x0301u
> > +     __le16 msg_type;
> > +};
> > +
> > +#endif /* #ifndef _LINUX_VIRTIO_VIRTIO_CAN_H */
