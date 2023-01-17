Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B23A66E310
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 17:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjAQQGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 11:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjAQQGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 11:06:09 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFDD59DC
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 08:06:04 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id s66so25622985oib.7
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 08:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4EfAchFh2XqfMOv5AF2Sfa5iQg29dDmyouMrbdYKJR0=;
        b=Evh4xGotkD8K7/YI0wKm8LM4Bm1q9bxjAviJg6SXzmcPYwVIFvYspgAf+EiJ8JpdK2
         +icEBqN5gdrXJSc7kJSmmI+4m7KzoG/vIhs9X+jRo+H+JXFu69KruiGH2gN+FMlWUYl3
         JDMjpdeWohnVxTRBoeU4W+D/WRlq1k0YlC36ahRxFci3ttgSQPdxw+NpVrXpTTPZ4TJE
         /ikn2hHuaPWDfvmSM8wN5oT99L8XAl4MK1zQVXJGrvWo5ueIfAaPxP3CFx/WNyT3qV6H
         TcKp/fGF9wf2djy2JJPsVuVuviPvVNwlEKqyw///y8287ZmtlxJnnAm02L688c2rebm6
         S+vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4EfAchFh2XqfMOv5AF2Sfa5iQg29dDmyouMrbdYKJR0=;
        b=uX9knnrGSb8P1/+h5UZDcgHrl/4FlPQS0sc/0z1i5TcqCgPwisemmwnzgS3gL+7FXc
         7TpRAMjEXeCXm2MDQz8LeZJ50RK6ZrW/8++nk+Gl7xz/dVq9Nw2n0aA3BaVYU+ACX3bf
         CpBk5gxkcN/AWWSkCTYEn1WwcrxjAByDml+TC43dQmK+DGxFRj7Pdvp+H/ZAqjq87JX5
         dvEfaJ3kpm9goB7+u+mksC03uIpNEEa2FDrAsQmNInwdw2Y+OV6cNkwiA97oCA6pFKFH
         qnWY2lCdi+jFmPapPj32mdrbJbkQw3rdp9ncl4tmirF2+xA1wm3jGJpKK6jmV3SRGKR3
         1m5A==
X-Gm-Message-State: AFqh2koXNSvBvmbm46yqDNtqB/zn7eY2NFhPLmDuvRvTrdxbmBTEYZpC
        UtBJmJJhmELo7+0e7zCtHQT03AmkrIN2FQLJGEjUMg==
X-Google-Smtp-Source: AMrXdXsrU0YdklNgBFboFkySo1rRevrkr0ofh47b+nLvVnnSnTEMZtKONOxGleKBt40RWI++MDGBklSCZNeSVCNjAjI=
X-Received: by 2002:a05:6808:124f:b0:35e:18a6:10ea with SMTP id
 o15-20020a056808124f00b0035e18a610eamr239009oiv.239.1673971564010; Tue, 17
 Jan 2023 08:06:04 -0800 (PST)
MIME-Version: 1.0
References: <20230116173420.1278704-1-mw@semihalf.com> <20230116173420.1278704-3-mw@semihalf.com>
 <Y8WOVVnFInEoXLVX@shell.armlinux.org.uk> <20230116181618.2iz54jywj7rqzygu@skbuf>
 <Y8XJ3WoP+YKCjTlF@lunn.ch>
In-Reply-To: <Y8XJ3WoP+YKCjTlF@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 17 Jan 2023 17:05:53 +0100
Message-ID: <CAPv3WKc8gfBb7BDf5kwyPCNRxmS_H8AgQKRitbsqvL7ihbP1DA@mail.gmail.com>
Subject: Re: [net-next: PATCH v4 2/8] net: mdio: switch fixed-link PHYs API to fwnode_
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, linus.walleij@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hkallweit1@gmail.com, jaz@semihalf.com,
        tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew and Vladimir,

pon., 16 sty 2023 o 23:04 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> On Mon, Jan 16, 2023 at 08:16:18PM +0200, Vladimir Oltean wrote:
> > On Mon, Jan 16, 2023 at 05:50:13PM +0000, Russell King (Oracle) wrote:
> > > On Mon, Jan 16, 2023 at 06:34:14PM +0100, Marcin Wojtas wrote:
> > > > fixed-link PHYs API is used by DSA and a number of drivers
> > > > and was depending on of_. Switch to fwnode_ so to make it
> > > > hardware description agnostic and allow to be used in ACPI
> > > > world as well.
> > >
> > > Would it be better to let the fixed-link PHY die, and have everyone u=
se
> > > the more flexible fixed link implementation in phylink?
> >
> > Would it be even better if DSA had some driver-level prerequisites to
> > impose for ACPI support - like phylink support rather than adjust_link =
-
> > and we would simply branch off to a dsa_shared_port_link_register_acpi(=
)
> > function, leaving the current dsa_shared_port_link_register_of() alone,
> > with all its workarounds and hacks? I don't believe that carrying all
> > that logic over to a common fwnode based API is the proper way forward.

In the past couple of years, a number of subsystems have migrated to a
more generic HW description abstraction (e.g. a big chunk of network,
pinctrl, gpio). ACPI aside, with this patchset one can even try to
describe the switch topology with the swnode (I haven't tried that
though). I fully agree that there should be no 0-day baggage in the
DSA ACPI binding (FYI the more fwnode- version of the
dsa_shared_port_validate_of() cought one issue in the WIP ACPI
description in my setup). On the other hand, I find fwnode_/device_
APIs really helpful for most of the cases - ACPI/OF/swnode differences
can be hidden to a generic layer and the need of maintaining separate
code paths related to the hardware description on the driver/subsystem
level is minimized. An example could be found in v1 of this series,
the last 4 patches in [1] show that it can be done in a simple /
seamless way, especially given the ACPI (fwnode) PHY description in
phylink is already settled and widely used. I am aware at the end of
the day, after final review all this can be more complex.

I expect that the actual DSA ACPI support acceptance will require a
lot of discussions and decisions, on whether certain solutions are
worth migrating from OF world or require spec modification. For now my
goal was to migrate to a more generic HW description API, and so to
allow possible follow-up ACPI-related modifications, and additions to
be extracted and better tracked.

>
> I agree with you there, here is little attempt to make a clean ACPI
> binding. Most of the attempts to add ACPI support seem to try to take
> the short cut for just search/replace of_ with fwnode_. And we then
> have to push back and say no, and generally it then goes quiet.

In most cases, the devices' description is pretty straightforward:
* a node (single or with some children), resources (mem, irqs), mmio
address space, optionally address on a bus and a couple of properties
The DSDT/SSDT tables are very well suited for this. In case of
separate, contained drivers that is also really easy to maintain.

However, I fully understand your concerns and caution before blessing
any change related to subsystem/generic code. Therefore ACPI support
addition was split after v1 (refer to discussion in [1]) and will
require ACPI maintainers' input and guidelines.

>
> Marcin, please approach this from the other end. Please document in
> Documentation/firmware-guide/acpi/dsd what a clean binding should look
> like, and then try to implement it.
>

This is how I initially approached this (original submission: [2]; a
bit updated version, working on top of the current patchset: [3]). We
then agreed that in order to remove a bit hacky mitigation of the
double ACPI scan problem, an MDIOSerialBus _CRS method should be
defined in the ACPI spec, similar to the
I2CSerialBus/SPISerialBus/UARTSerialBus. I am going to submit the
first version for review in the coming days. The DSA purely
ACPI-related changes would be updated and submitted, once the method
is accepted.

Best regards,
Marcin

[1] https://www.spinics.net/lists/netdev/msg827337.html
[2] https://www.spinics.net/lists/netdev/msg827345.html
[3] https://github.com/semihalf-wojtas-marcin/Linux-Kernel/commit/e017e69c0=
eda18747029bfe0c335df204670ba59
