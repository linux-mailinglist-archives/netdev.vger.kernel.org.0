Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACE814B31F
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 11:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgA1K6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 05:58:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbgA1K6c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 05:58:32 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 022272467B;
        Tue, 28 Jan 2020 10:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580209111;
        bh=fPIGD7bZiuPsICx66b+4r7EJxaT51+ZFDK7Fnb9seEk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1ctD0lburdWt3ZOtVj5XjYkEhuGI8R5O7+QvVol5aKA4A/kVC5guTaNEXrw4S+q7C
         ROcM5bCZuKIpf1xHbcixgP2r6MHVi4yBvKGo9D46PITetF2dNVQ29fOpZ1T4os+5tm
         1AAyEH+The9/aovJDctEl2W6zefngSGCDwPsxEhU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1iwOZh-001naq-9h; Tue, 28 Jan 2020 10:58:29 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 28 Jan 2020 10:58:29 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Makarand Pawagi <makarand.pawagi@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux@armlinux.org.uk, jon@solid-run.com,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, calvin.johnson@nxp.com,
        pankaj.bansal@nxp.com, lorenzo.pieralisi@arm.com,
        guohanjun@huawei.com, sudeep.holla@arm.com, rjw@rjwysocki.net,
        lenb@kernel.org, stuyoder@gmail.com, tglx@linutronix.de,
        jason@lakedaemon.net, shameerali.kolothum.thodi@huawei.com,
        will@kernel.org, robin.murphy@arm.com, nleeder@codeaurora.org
Subject: Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
In-Reply-To: <1580198925-50411-1-git-send-email-makarand.pawagi@nxp.com>
References: <1580198925-50411-1-git-send-email-makarand.pawagi@nxp.com>
Message-ID: <d8aa6658f8f3763e28bb5d4884b9b686@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: makarand.pawagi@nxp.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org, linux@armlinux.org.uk, jon@solid-run.com, cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com, ioana.ciornei@nxp.com, V.Sethi@nxp.com, calvin.johnson@nxp.com, pankaj.bansal@nxp.com, lorenzo.pieralisi@arm.com, guohanjun@huawei.com, sudeep.holla@arm.com, rjw@rjwysocki.net, lenb@kernel.org, stuyoder@gmail.com, tglx@linutronix.de, jason@lakedaemon.net, shameerali.kolothum.thodi@huawei.com, will@kernel.org, robin.murphy@arm.com, nleeder@codeaurora.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-28 08:08, Makarand Pawagi wrote:
> ACPI support is added in the fsl-mc driver. Driver will parse
> MC DSDT table to extract memory and other resorces.
> 
> Interrupt (GIC ITS) information will be extracted from MADT table
> by drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c.
> 
> IORT table will be parsed to configure DMA.
> 
> Signed-off-by: Makarand Pawagi <makarand.pawagi@nxp.com>
> ---
>  drivers/acpi/arm64/iort.c                   | 53 +++++++++++++++++++++
>  drivers/bus/fsl-mc/dprc-driver.c            |  3 +-
>  drivers/bus/fsl-mc/fsl-mc-bus.c             | 48 +++++++++++++------
>  drivers/bus/fsl-mc/fsl-mc-msi.c             | 10 +++-
>  drivers/bus/fsl-mc/fsl-mc-private.h         |  4 +-
>  drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c | 71 
> ++++++++++++++++++++++++++++-
>  include/linux/acpi_iort.h                   |  5 ++
>  7 files changed, 174 insertions(+), 20 deletions(-)

A general comment when you do this kind of work:

Do not write a single patch that impacts at least three different
subsystems. As it is, it is unmergeable.

Now the real question is *WHY* we need this kind of monstruosity?
ACPI deals with PCI, not with exotic busses and whatnot. If you want
to be creative, DT is your space. ACPI is designed to be plain and
boring, and that's how we like it.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
