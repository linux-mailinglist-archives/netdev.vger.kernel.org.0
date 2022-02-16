Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0004B89AC
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbiBPNVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:21:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbiBPNVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:21:12 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04C22AE071
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:19:45 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id u16so3300623ljk.2
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LmcqWXwseeG4I4bS/aEDRBMabNjMhuU+WWEWJ2QVP0A=;
        b=ZKF01vsC92N6eCOjhBPsAWtAZrJ2+kiOfO1gXjHOH2Ud6qWy/xyX1OTnnvoRGaIwbP
         5n9+MOk4PuipHjTueQ6wblFJ7cr9DYnfRB7Es3RhOPNWzroAoT+w0M0ea8XP/bRvHeJg
         XX/xgFRS3/Ug6VnlsVKbpczbKHnaSo2spijefK0lldXkNMN4Ujsw0IL/BTKq07CiN4fp
         ceQ4MUf3VjH1KIZ87BWGsYxp8SBqEkbEVc0ZjYjJiHezLvFbyVPmaI76doac6fvirQjd
         jh9PDq42+MR90ozXBIP8ajeTx5uWQKohaF8G+HPze6qab35QaWxpb5/bYp9vEgx+iWNS
         CFJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LmcqWXwseeG4I4bS/aEDRBMabNjMhuU+WWEWJ2QVP0A=;
        b=IxYzlOWSitK3vu4izjXqck6pQPp57z0F6EVUPSPw+xLCJea71nqJo8QuBZB4gc8jea
         NQui+0G0S/njke6V+q6plFOWBUvKzD2OYoa2sx+noLSpM+NbnB5GIOBvTbLh46Z/tZ4E
         isSCeQJ7BTU0+6Zz6VX2Syne0B/uTuTYrGfuBx5bEXnujSqs42bszI2HL9La365WB7CT
         NBODONjDdOzhFqF2xuIn8uNgamThKTcYf88ExlugdrfyoyY2EbaRvIQZev/ppEoHm1l4
         4an4t8VV+ZKG+DxkXBioQt17RTtJToavQHYbyYQsr1SEJ+JmdognZel0yiQ7pAhZUdKt
         KGLQ==
X-Gm-Message-State: AOAM532L+7svZhUPqPDRbQ/pODfprCbWSQt27aZAQY3WkY5wIHAseSOz
        bjp+bql2owF4dszQErD2w3oSo7J1ZpyxBcqfCfCh7w==
X-Google-Smtp-Source: ABdhPJxijRjk2lC5l4XjkBcyRT5s/WpbO7OJ6wpNxbl47IfggP5IdHDdkzo4ug2pd8POaIvsmFBXc+LYvngmKOmQJ+E=
X-Received: by 2002:a05:651c:549:b0:245:6f1:8584 with SMTP id
 q9-20020a05651c054900b0024506f18584mr2068100ljp.474.1645017584253; Wed, 16
 Feb 2022 05:19:44 -0800 (PST)
MIME-Version: 1.0
References: <20220216090845.1278114-1-maz@kernel.org>
In-Reply-To: <20220216090845.1278114-1-maz@kernel.org>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Wed, 16 Feb 2022 14:19:30 +0100
Message-ID: <CAPv3WKf4RFeTDCsW+cY-Rp=2rZt1HuZSVQcmcB3oKQKNbvBtDA@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: mvpp2: Survive CPU hotplug events
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Garry <john.garry@huawei.com>, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

=C5=9Br., 16 lut 2022 o 10:08 Marc Zyngier <maz@kernel.org> napisa=C5=82(a)=
:
>
> I recently realised that playing with CPU hotplug on a system equiped
> with a set of MVPP2 devices (Marvell 8040) was fraught with danger and
> would result in a rapid lockup or panic.
>
> As it turns out, the per-CPU nature of the MVPP2 interrupts are
> getting in the way. A good solution for this seems to rely on the
> kernel's managed interrupt approach, where the core kernel will not
> move interrupts around as the CPUs for down, but will simply disable
> the corresponding interrupt.
>
> Converting the driver to this requires a bit of refactoring in the IRQ
> subsystem to expose the required primitive, as well as a bit of
> surgery in the driver itself.
>
> Note that although the system now survives such event, the driver
> seems to assume that all queues are always active and doesn't inform
> the device that a CPU has gone away. Someout who actually understand
> this driver should have a look at it.
>
> Patches on top of 5.17-rc3, lightly tested on a McBin.
>

Thank you for the patches. Can you, please, share the commands you
used? I'd like to test it more.

Best regards,
Marcin

> Marc Zyngier (2):
>   genirq: Extract irq_set_affinity_masks() from
>     devm_platform_get_irqs_affinity()
>   net: mvpp2: Convert to managed interrupts to fix CPU HP issues
>
>  drivers/base/platform.c                       | 20 +-----
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  1 -
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 67 ++++++++++---------
>  include/linux/interrupt.h                     |  8 +++
>  kernel/irq/affinity.c                         | 27 ++++++++
>  5 files changed, 72 insertions(+), 51 deletions(-)
>
> --
> 2.30.2
>
