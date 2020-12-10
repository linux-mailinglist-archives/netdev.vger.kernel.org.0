Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F832D6B4D
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388518AbgLJW6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 17:58:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387782AbgLJW5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 17:57:49 -0500
X-Gm-Message-State: AOAM5300VO9rbiSmIm4FekveiHzSSL8IjCfyZjJ8pYgSRuW45jWqTCFH
        bUsDMRhiVpglneUKcnyPHByEGU5qd8+lNiK8Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607641028;
        bh=CumYBB9xVU4mI+ysFQ9GC3xvipGC4R7OnFI2Gfa5FNQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IENA755C1/rgN0w8w2Z2W86pSCNpqQVdsIn6hGM3SHpMOEjpkwGZtsgL0hRxLES5J
         GN69vLvpVngVt+noJivc35dT928cbXAlG4h3cswLCydXRYUgIxoqvWvZqpS8aiOmMt
         05Ld+Z78+akIY5HGQHCAOlr0AaROFROMPYtjN+KD7+S/KXuaWg0xL6AO0iLiPlice4
         iZANjFb7GSIlf67hQvw0Y9hSU5e2T/JFuteUXmOg3uHY1Ii/HhED2bYqVL2OdaPsEh
         TPV4vxeX7oyFvjtBzj9WAWsfNEkX/EEF2pxlVmb7f9vuUC3ehG96CfByyDyOuWBqr1
         447X7kFWCVCJA==
X-Google-Smtp-Source: ABdhPJyKMB0fAO5ccR1ON7eKp3wop/g844H0Em6KIAw65vcwOioEZudsqFxyo2xMX2ascC0HxcRxz5ivmcQz5wtwB24=
X-Received: by 2002:a17:906:c20f:: with SMTP id d15mr8477099ejz.341.1607641026526;
 Thu, 10 Dec 2020 14:57:06 -0800 (PST)
MIME-Version: 1.0
References: <20201210192536.118432146@linutronix.de> <20201210194044.473308721@linutronix.de>
In-Reply-To: <20201210194044.473308721@linutronix.de>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 10 Dec 2020 16:56:55 -0600
X-Gmail-Original-Message-ID: <CAL_JsqK4bVyqyT9ip9A5P7gQQwDt1HMksjkCe6bwHrBCGrZYug@mail.gmail.com>
Message-ID: <CAL_JsqK4bVyqyT9ip9A5P7gQQwDt1HMksjkCe6bwHrBCGrZYug@mail.gmail.com>
Subject: Re: [patch 19/30] PCI: mobiveil: Use irq_data_get_irq_chip_data()
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        PCI <linux-pci@vger.kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Wambui Karuga <wambui.karugax@gmail.com>,
        Intel Graphics <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>, linux-ntb@googlegroups.com,
        Michal Simek <michal.simek@xilinx.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 1:42 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Going through a full irq descriptor lookup instead of just using the proper
> helper function which provides direct access is suboptimal.
>
> In fact it _is_ wrong because the chip callback needs to get the chip data
> which is relevant for the chip while using the irq descriptor variant
> returns the irq chip data of the top level chip of a hierarchy. It does not
> matter in this case because the chip is the top level chip, but that
> doesn't make it more correct.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>
> Cc: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/pci/controller/mobiveil/pcie-mobiveil-host.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>
