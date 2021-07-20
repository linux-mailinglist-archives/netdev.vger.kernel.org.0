Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A4A3D0110
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhGTRRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 13:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbhGTRPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 13:15:45 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154D6C0613E3
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 10:56:12 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id z11so25026976iow.0
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 10:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t3kbL79HkQbr8SQI1UHiSGzq+L5suTboTcn144AJ/6w=;
        b=LEYeclM+rNMU+3qnkdCCFKtxgBk+kXpUiezwgkGXV+QtB/384e2tfLKp/QFksPGAIR
         IFJO1/45+z8IpQdL+WuCZgwK50Sq9nYmLSXy1++MHl77GwzqGfSqJIgXGf2iI2uX2EW+
         MW89vr/pCqF1zO+IJBJ3fLz+ey5YVv9a8hDWHHDO+LnPHGP1fnFU+/KAjPFrChDv5gBt
         HYEmJdd6wi+uOVc7w3Kfdm5HJksl8C4Bjp8hnjEuxiq1dB30tVFKE8ZvCTQQOirrEk/1
         +HjkvTGfXKyaGsNScwtGLRAYfe6S+t0Jj0uTny1NUdipHlHMPhq4aB+EOSIXuvn9+Py7
         1ESg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t3kbL79HkQbr8SQI1UHiSGzq+L5suTboTcn144AJ/6w=;
        b=PVz+xjXYsWcXs+7+EJlrfcHWSULLbw7102BSPmkmDVXMBO79hVef5sowaXyq8wB52l
         kwHtnsUxPJtkWIVa7YMz5QE3Ia29JE7a0aJY/ErdNy4JN4oiMLh+q2GnTHjftUlqROPJ
         2/c1sgbTJ6Ld4g2ByEeCAseYj6G5/i/tQSW3h9EKauLrVzYZE5FFPFntz3AnWDBqHQdZ
         YnBCrCTUOiRjBp56IBBcBZ8U9+aoiZMHHVDe55VVBXEzFUU2vvOArHYn1kGSd5J60xPi
         WyM58p2zZduDQIHOs5WB307IzlEJpTmxJPL3UfVu1suZE/daU9dvTWzaNJV/0KfCiCHv
         fdxw==
X-Gm-Message-State: AOAM5305+aN61kXGzSvWA3vW3vtpnnbsZtui385laKnJ3laih08zVSof
        ojNFDUm1X3iZhedb8Qt4U97d28PAVdl/KKMVHG0=
X-Google-Smtp-Source: ABdhPJydG1Md9ULF3MLsBQBD2gicayIRyQwZGImNrhG4x99ETb1tWE7qASAFOUykW4dfrAokVaj4h8q6K3WJBpWAxWg=
X-Received: by 2002:a02:a80f:: with SMTP id f15mr27556542jaj.142.1626803771577;
 Tue, 20 Jul 2021 10:56:11 -0700 (PDT)
MIME-Version: 1.0
References: <1626685174-4766-1-git-send-email-sbhatta@marvell.com>
 <1626685174-4766-4-git-send-email-sbhatta@marvell.com> <20210720135133.3873fb4e@cakuba>
In-Reply-To: <20210720135133.3873fb4e@cakuba>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Tue, 20 Jul 2021 23:26:00 +0530
Message-ID: <CALHRZuqqJgOz4NR1sAYYU+OJcze_x2Yg3bDuYrr8O4sFjEOOOg@mail.gmail.com>
Subject: Re: [net-next PATCH 3/3] octeontx2-af: Introduce internal packet switching
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Jul 20, 2021 at 5:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 19 Jul 2021 14:29:34 +0530, Subbaraya Sundeep wrote:
> > +static int rvu_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
> > +                                     struct netlink_ext_ack *extack)
> > +{
> > +     struct rvu_devlink *rvu_dl = devlink_priv(devlink);
> > +     struct rvu *rvu = rvu_dl->rvu;
> > +     struct rvu_switch *rswitch;
> > +
> > +     rswitch = &rvu->rswitch;
> > +     switch (mode) {
> > +     case DEVLINK_ESWITCH_MODE_LEGACY:
> > +     case DEVLINK_ESWITCH_MODE_SWITCHDEV:
> > +             if (rswitch->mode == mode)
> > +                     return 0;
> > +             rswitch->mode = mode;
> > +             if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV)
> > +                     rvu_switch_enable(rvu);
> > +             else
> > +                     rvu_switch_disable(rvu);
>
> I don't see the code handle creation and tearing down of representors.
>
> How do things work in this driver? Does AF have a representor netdev
> for each VF (that's separate from the VF netdev itself)? Those should
> only exist in switchdev mode, while legacy mode should use DMAC
> switching.
>
> I think what you want is a textbook VEPA vs VEB switch. Please take a
> look at drivers implementing .ndo_bridge_getlink/.ndo_bridge_setlink.

MCAM used for switching is present in AF and AF is not a netdev to
use ndo_bridge_setlink. Currently VF->VF/ PF->VF switching is possible
only with an external switch in hairpin mode (like VEPA), what we want to
achieve is switching based on DMAC in MCAM itself(internally).
We used DEVLINK_ESWITCH_MODE_SWITCHDEV as a trigger to
allocate MCAM rules. I understand now that it can be used to create
VF representors only. Can you please suggest any appropriate devlink
command we can use here so that new rules are created. Having these
rules by default will waste MCAM space.

Thanks,
Sundeep
