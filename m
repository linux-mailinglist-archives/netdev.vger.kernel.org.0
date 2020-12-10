Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FD22D6B39
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 00:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388996AbgLJW5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 17:57:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729324AbgLJW5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 17:57:16 -0500
X-Gm-Message-State: AOAM531VI4K5ScDHtgx08n2sIxdeOym6/PE+oGo/QaMpVCk+Ldwct148
        wrC2B2QpSGaMXBVb6ICV60v6FdcIMXBZx27ZTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607640995;
        bh=HILNalL3GlPRV+ztE2WnCsMQWzjgnQh5F8d+VjxfhHA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DkCyyeuvJy4iU5hGrhY5rvXdNF/XDEltkcaXCK6XvpomHZn/eMfi17cIpcRiI5UTN
         kSgVM0+4jjhPCNQ75+n/cgaon9liXs7woUDnE8yttzk1aQDmv4io7aucoYzyAtdNG0
         I2wUawkxulB5pG6A0oOdXuJ1alyYKqoFx6TvAWl9grEpRA2evfntb2Y6XvyL5UXgjx
         TzZURk/yteTpMNwsMgcPKMcKwqol/ljrllpmoEMc4onPQTbPEpHiroGdwkcCe99aWN
         MqaDFHEFOoTW4rWfDNURprjhGlC5XlkkOBsq9Gva6ntmAVZmR6ksXaR9lV2TA1APi2
         jOgUDjBhrO9bg==
X-Google-Smtp-Source: ABdhPJxCdEkGcUPgqgCmU+hGdc9mjJz2mo+m7nRBlZJj4NBRvD8ZfcoTXioyfo8/Gn48VrKyiwGC/1HmZUK4DbzvCWk=
X-Received: by 2002:a17:906:d784:: with SMTP id pj4mr8261525ejb.360.1607640993261;
 Thu, 10 Dec 2020 14:56:33 -0800 (PST)
MIME-Version: 1.0
References: <20201210192536.118432146@linutronix.de> <20201210194044.364211860@linutronix.de>
In-Reply-To: <20201210194044.364211860@linutronix.de>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 10 Dec 2020 16:56:21 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKCGkyk9whiGQ0hPyWjSYXnC-TSbot85k7=bwVd0rwC=A@mail.gmail.com>
Message-ID: <CAL_JsqKCGkyk9whiGQ0hPyWjSYXnC-TSbot85k7=bwVd0rwC=A@mail.gmail.com>
Subject: Re: [patch 18/30] PCI: xilinx-nwl: Use irq_data_get_irq_chip_data()
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        PCI <linux-pci@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
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
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
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
> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Michal Simek <michal.simek@xilinx.com>
> Cc: linux-pci@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  drivers/pci/controller/pcie-xilinx-nwl.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>
