Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE6752B954
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbiERMEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbiERMD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:03:57 -0400
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33B41A388;
        Wed, 18 May 2022 05:03:49 -0700 (PDT)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-2f83983782fso21677217b3.6;
        Wed, 18 May 2022 05:03:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rVPPyUegoVxSn5lsEO7BZkKqB32kOawffPYWcQzsvL0=;
        b=XaNRNOZ69M2vaLJExMWrSNe+ugNqvvdpc4XlReOVVb6n6oMWmN3QUWJQcOmsgvUuJq
         f6A+XuhS/+28N3anL7n+FU4W3Ondx5iQPS4NqJ3WPPK9Z8XDelz6DxEu3/vQnZbJ4RiE
         Dt+DMdYWp8sLrUOFWAUlpyyutMjMq3Vw0mBjbMyUs2a5IxRhEeFhVI3J0yo5ZZaYRTYk
         u+ODZr8DkDEngPj9gZzbsNnBFa8Y+5I7yjomBTPiB+kUqOxLQVoDgWxZzRQri9lUXkq6
         whblbEov4YMKG5ErhcS2jcBHwO1hQlMSggfRsgHF5v0KmS7wEetdLQ2CwiWLP87OL9LV
         jb/Q==
X-Gm-Message-State: AOAM530KsobcEPKoYEqKfnbrqA8chUglFx0zVhb+0WgTRE3aw350rm47
        +oPXiSSnfcCwiAjez0EyrpwQXyXOyDkLbGF/qEeu20RvVcyhfg==
X-Google-Smtp-Source: ABdhPJwcAzjvbo5MkFqDUW1g4+joKN2IALSfdlPaNkIMABQRvJUwQXlnD/3SF5HCILLiSo7DV1OA+ONdEfNlzZicS/0=
X-Received: by 2002:a81:140e:0:b0:2fe:c3a3:5b19 with SMTP id
 14-20020a81140e000000b002fec3a35b19mr25432713ywu.392.1652875428925; Wed, 18
 May 2022 05:03:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr> <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
 <7b1644ad-c117-881e-a64f-35b8d8b40ef7@hartkopp.net> <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
 <20220517060821.akuqbqxro34tj7x6@pengutronix.de> <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
 <20220517104545.eslountqjppvcnz2@pengutronix.de> <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
 <20220517141404.578d188a.max@enpas.org> <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
 <20220517143921.08458f2c.max@enpas.org> <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
In-Reply-To: <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 18 May 2022 21:03:37 +0900
Message-ID: <CAMZ6RqJ0iCsHT-D5VuYQ9fk42ZEjHStU1yW0RfX1zuJpk5rVtQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Max Staudt <max@enpas.org>, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I didn't think this would trigger such a passionate discussion!

On Tue. 17 mai 2022 at 22:35, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> On 5/17/22 14:39, Max Staudt wrote:
> > On Tue, 17 May 2022 14:21:53 +0200
> > Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> >
> >> On 17.05.2022 14:14:04, Max Staudt wrote:
> >>>> After looking through drivers/net/can/Kconfig I would probably
> >>>> phrase it like this:
> >>>>
> >>>> Select CAN devices (hw/sw) -> we compile a can_dev module. E.g.
> >>>> to handle the skb stuff for vcan's.
> >>>>
> >>>> Select hardware CAN devices -> we compile the netlink stuff into
> >>>> can_dev and offer CAN_CALC_BITTIMING and CAN_LEDS to be compiled
> >>>> into can_dev too.
> >>>>
> >>>> In the latter case: The selection of flexcan, ti_hecc and
> >>>> mcp251xfd automatically selects CAN_RX_OFFLOAD which is then also
> >>>> compiled into can_dev.
> >>>>
> >>>> Would that fit in terms of complexity?
> >>>
> >>> IMHO these should always be compiled into can-dev. Out of tree
> >>> drivers are fairly common here, and having to determine which kind
> >>> of can-dev (stripped or not) the user has on their system is a
> >>> nightmare waiting to happen.
> >>
> >> I personally don't care about out-of-tree drivers.
> >
> > I know that this is the official stance in the kernel.
> >
> > But out-of-tree drivers do happen on a regular basis, even when
> > developing with the aim of upstreaming. And if a developer builds a
> > minimal kernel to host a CAN driver, without building in-tree hardware
> > CAN drivers, then can-dev will be there but behave differently from
> > can-dev in a full distro. Leading to heisenbugs and wasting time. The
> > source of heisenbugs really are the suggested *hidden* Kconfigs.
> >
> >
> > On another note, is the module accounting overhead in the kernel for
> > two new modules with relatively little code in each, code that almost
> > always is loaded when CAN is used, really worth it?
>
> Oh, I didn't want to introduce two new kernel modules but to have
> can_dev in different 'feature levels'.
>
> I would assume a distro kernel to have everything enabled with a full
> featured can_dev - which is likely the base for out-of-tree drivers too.
>
> But e.g. the people that are running Linux instances in a cloud only
> using vcan and vxcan would not need to carry the entire infrastructure
> of CAN hardware support and rx-offload.

Are there really some people running custom builds of the Linux kernel
in a cloud environment? The benefit of saving a few kilobytes by not
having to carry the entire CAN hardware infrastructure is blown away
by the cost of having to maintain a custom build.

I perfectly follow the idea to split rx-offload. Integrators building
some custom firmware for an embedded device might want to strip out
any unneeded piece. But I am not convinced by this same argument when
applied to v(x)can.
A two level split (with or without rx-offload) is what makes the most
sense to me.

Regardless, having the three level split is not harmful. And because
there seems to be a consensus on that, I am fine to continue in this
direction.

On a different topic, why are all the CAN devices
under "Networking support" and not "Device Drivers" in menuconfig
like everything else? Would it make sense to move our devices
under the "Device Drivers" section?
