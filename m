Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B55AF50D33
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbfFXOCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:02:36 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35196 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbfFXOCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:02:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zZSxwVvfCril3he0j5sVVnq9Oums5ivrZ078cOx8kAU=; b=T1kGrnSSYrMNPlLFuiEIzBqNx
        rS2N5cBpI30qrO9Oq02nPbzVZPV48XXtXtAO8PYzmgSVdD1duTRlScBD/3WxhXcQUVVbgs6h6f2cg
        k6E3rCHcqypJyRJX8kPVVDhX8dfNr9kkMNtCVDS3xJfapvb1rixKwuiPGSEyeEsfy824ZXthgg2rw
        6YcJij50Pp1ffta9EeCAneztN+8M2gJQW60gx/G7ZexA9CZqPV93lQb9ZcGvJwua4EGrw+iSdvXO/
        y8h5UvoRXRpXNzE7XxtVh/IAZ+FmE/EwDRUIxkVPtzeBbnQF4LCupNMk3rj+9qAY8Vj22BbwN8Bji
        VGTUcDTiw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59944)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfPY3-0008Uf-6a; Mon, 24 Jun 2019 15:02:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfPXx-0006Lb-0M; Mon, 24 Jun 2019 15:02:13 +0100
Date:   Mon, 24 Jun 2019 15:02:12 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        alexander.sverdlin@gmail.com, allison@lohutok.net, andrew@lunn.ch,
        ast@kernel.org, bgolaszewski@baylibre.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, daniel@zonque.org, dmg@turingmachine.org,
        festevam@gmail.com, gerg@uclinux.org, gregkh@linuxfoundation.org,
        gregory.clement@bootlin.com, haojian.zhuang@gmail.com,
        hsweeten@visionengravers.com, illusionist.neo@gmail.com,
        info@metux.net, jason@lakedaemon.net, jolsa@redhat.com,
        kafai@fb.com, kernel@pengutronix.de, kgene@kernel.org,
        krzk@kernel.org, kstewart@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, liviu.dudau@arm.com,
        lkundrak@v3.sk, lorenzo.pieralisi@arm.com, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        nsekhar@ti.com, peterz@infradead.org, robert.jarzmik@free.fr,
        s.hauer@pengutronix.de, sebastian.hesselbarth@gmail.com,
        shawnguo@kernel.org, songliubraving@fb.com, sudeep.holla@arm.com,
        swinslow@gmail.com, tglx@linutronix.de, tony@atomide.com,
        will@kernel.org, yhs@fb.com
Subject: Re: [PATCH V2 00/15] cleanup cppcheck signed shifting errors
Message-ID: <20190624140212.p6xvcg5lhtgeeogc@shell.armlinux.org.uk>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 08:50:50PM +0700, Phong Tran wrote:
> There are errors with cppcheck 
> 
> "Shifting signed 32-bit value by 31 bits is undefined behaviour errors"
> 
> This is just a mirror changing. 

"mirror" ?

Apart from that and the extra unnecessary parens (which ought to be
cleaned up) this looks fine to me.

When there's too many parens next to each other, it makes reading
the expression more difficult - and that is definitely bad, so please
avoid unecessary parens where possible.

Thanks.

> 
> V2: Using BIT() macro instead of (1UL << nr) 
> 
> Phong Tran (15):
>   arm: perf: cleanup cppcheck shifting error
>   ARM: davinci: cleanup cppcheck shifting errors
>   ARM: ep93xx: cleanup cppcheck shifting errors
>   ARM: exynos: cleanup cppcheck shifting error
>   ARM: footbridge: cleanup cppcheck shifting error
>   ARM: imx: cleanup cppcheck shifting errors
>   ARM: ks8695: cleanup cppcheck shifting error
>   ARM: mmp: cleanup cppcheck shifting errors
>   ARM: omap2: cleanup cppcheck shifting error
>   ARM: orion5x: cleanup cppcheck shifting errors
>   ARM: pxa: cleanup cppcheck shifting errors
>   ARM: vexpress: cleanup cppcheck shifting error
>   ARM: mm: cleanup cppcheck shifting errors
>   ARM: bpf: cleanup cppcheck shifting error
>   ARM: vfp: cleanup cppcheck shifting errors
> 
>  arch/arm/kernel/perf_event_v7.c    |   6 +-
>  arch/arm/mach-davinci/ddr2.h       |   6 +-
>  arch/arm/mach-ep93xx/soc.h         | 132 ++++++++++++++++++-------------------
>  arch/arm/mach-exynos/suspend.c     |   2 +-
>  arch/arm/mach-footbridge/dc21285.c |   2 +-
>  arch/arm/mach-imx/iomux-mx3.h      |  64 +++++++++---------
>  arch/arm/mach-ks8695/regs-pci.h    |   4 +-
>  arch/arm/mach-mmp/pm-mmp2.h        |  40 +++++------
>  arch/arm/mach-mmp/pm-pxa910.h      |  76 ++++++++++-----------
>  arch/arm/mach-omap2/powerdomain.c  |   2 +-
>  arch/arm/mach-orion5x/pci.c        |   8 +--
>  arch/arm/mach-pxa/irq.c            |   4 +-
>  arch/arm/mach-vexpress/spc.c       |  12 ++--
>  arch/arm/mm/fault.h                |   6 +-
>  arch/arm/net/bpf_jit_32.c          |   2 +-
>  arch/arm/vfp/vfpinstr.h            |   8 +--
>  16 files changed, 187 insertions(+), 187 deletions(-)
> 
> -- 
> 2.11.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
