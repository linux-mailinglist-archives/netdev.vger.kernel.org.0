Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D558503A8
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 09:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfFXHgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 03:36:02 -0400
Received: from shell.v3.sk ([90.176.6.54]:35940 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfFXHgC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 03:36:02 -0400
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 02ABCCCF81;
        Mon, 24 Jun 2019 09:35:55 +0200 (CEST)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id HKPnnqSdM2iD; Mon, 24 Jun 2019 09:35:43 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 6E2C3CCDAD;
        Mon, 24 Jun 2019 09:35:42 +0200 (CEST)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tZx8IZ03Lk4D; Mon, 24 Jun 2019 09:35:39 +0200 (CEST)
Received: from belphegor (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 14B84CCD44;
        Mon, 24 Jun 2019 09:35:37 +0200 (CEST)
Message-ID: <8aabdf0675f0ee74c21c18d819710a0929c61e2c.camel@v3.sk>
Subject: Re: [PATCH 08/15] ARM: mmp: cleanup cppcheck shifting errors
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Phong Tran <tranmanphong@gmail.com>, mark.rutland@arm.com,
        kstewart@linuxfoundation.org, songliubraving@fb.com,
        andrew@lunn.ch, peterz@infradead.org, nsekhar@ti.com,
        ast@kernel.org, jolsa@redhat.com, netdev@vger.kernel.org,
        gerg@uclinux.org, lorenzo.pieralisi@arm.com, will@kernel.org,
        linux-samsung-soc@vger.kernel.org, daniel@iogearbox.net,
        festevam@gmail.com, gregory.clement@bootlin.com,
        allison@lohutok.net, linux@armlinux.org.uk, krzk@kernel.org,
        haojian.zhuang@gmail.com, bgolaszewski@baylibre.com,
        tony@atomide.com, mingo@redhat.com, linux-imx@nxp.com, yhs@fb.com,
        sebastian.hesselbarth@gmail.com, illusionist.neo@gmail.com,
        jason@lakedaemon.net, liviu.dudau@arm.com, s.hauer@pengutronix.de,
        acme@kernel.org, robert.jarzmik@free.fr, dmg@turingmachine.org,
        swinslow@gmail.com, namhyung@kernel.org, tglx@linutronix.de,
        linux-omap@vger.kernel.org, alexander.sverdlin@gmail.com,
        linux-arm-kernel@lists.infradead.org, info@metux.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        alexander.shishkin@linux.intel.com, hsweeten@visionengravers.com,
        kgene@kernel.org, kernel@pengutronix.de, sudeep.holla@arm.com,
        bpf@vger.kernel.org, shawnguo@kernel.org, kafai@fb.com,
        daniel@zonque.org
Date:   Mon, 24 Jun 2019 09:35:35 +0200
In-Reply-To: <20190623151313.970-9-tranmanphong@gmail.com>
References: <20190623151313.970-1-tranmanphong@gmail.com>
         <20190623151313.970-9-tranmanphong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2019-06-23 at 22:13 +0700, Phong Tran wrote:
> [arch/arm/mach-mmp/pm-mmp2.c:121]: (error) Shifting signed 32-bit value
> by 31 bits is undefined behaviour
> [arch/arm/mach-mmp/pm-mmp2.c:136]: (error) Shifting signed 32-bit value
> by 31 bits is undefined behaviour
> [arch/arm/mach-mmp/pm-mmp2.c:244]: (error) Shifting signed 32-bit value
> by 31 bits is undefined behaviour
> [arch/arm/mach-mmp/pm-pxa910.c:141]: (error) Shifting signed 32-bit
> value by 31 bits is undefined behaviour
> [arch/arm/mach-mmp/pm-pxa910.c:159]: (error) Shifting signed 32-bit
> value by 31 bits is undefined behaviour
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>

Like others already pointed out, you may want to send out a v2 that
would use the BIT() macro. Either way works for me:

Acked-by: Lubomir Rintel <lkundrak@v3.sk> [mmp]

Thank you
Lubo


> ---
>  arch/arm/mach-mmp/pm-mmp2.h   | 40 +++++++++++------------
>  arch/arm/mach-mmp/pm-pxa910.h | 76 +++++++++++++++++++++----------------------
>  2 files changed, 58 insertions(+), 58 deletions(-)
> 
> diff --git a/arch/arm/mach-mmp/pm-mmp2.h b/arch/arm/mach-mmp/pm-mmp2.h
> index 70299a9450d3..87fd1c81547d 100644
> --- a/arch/arm/mach-mmp/pm-mmp2.h
> +++ b/arch/arm/mach-mmp/pm-mmp2.h
> @@ -12,37 +12,37 @@
>  #include "addr-map.h"
>  
>  #define APMU_PJ_IDLE_CFG			APMU_REG(0x018)
> -#define APMU_PJ_IDLE_CFG_PJ_IDLE		(1 << 1)
> -#define APMU_PJ_IDLE_CFG_PJ_PWRDWN		(1 << 5)
> +#define APMU_PJ_IDLE_CFG_PJ_IDLE		(1U << 1)
> +#define APMU_PJ_IDLE_CFG_PJ_PWRDWN		(1U << 5)
>  #define APMU_PJ_IDLE_CFG_PWR_SW(x)		((x) << 16)
> -#define APMU_PJ_IDLE_CFG_L2_PWR_SW		(1 << 19)
> +#define APMU_PJ_IDLE_CFG_L2_PWR_SW		(1U << 19)
>  #define APMU_PJ_IDLE_CFG_ISO_MODE_CNTRL_MASK	(3 << 28)
>  
>  #define APMU_SRAM_PWR_DWN			APMU_REG(0x08c)
>  
>  #define MPMU_SCCR				MPMU_REG(0x038)
>  #define MPMU_PCR_PJ				MPMU_REG(0x1000)
> -#define MPMU_PCR_PJ_AXISD			(1 << 31)
> -#define MPMU_PCR_PJ_SLPEN			(1 << 29)
> -#define MPMU_PCR_PJ_SPSD			(1 << 28)
> -#define MPMU_PCR_PJ_DDRCORSD			(1 << 27)
> -#define MPMU_PCR_PJ_APBSD			(1 << 26)
> -#define MPMU_PCR_PJ_INTCLR			(1 << 24)
> -#define MPMU_PCR_PJ_SLPWP0			(1 << 23)
> -#define MPMU_PCR_PJ_SLPWP1			(1 << 22)
> -#define MPMU_PCR_PJ_SLPWP2			(1 << 21)
> -#define MPMU_PCR_PJ_SLPWP3			(1 << 20)
> -#define MPMU_PCR_PJ_VCTCXOSD			(1 << 19)
> -#define MPMU_PCR_PJ_SLPWP4			(1 << 18)
> -#define MPMU_PCR_PJ_SLPWP5			(1 << 17)
> -#define MPMU_PCR_PJ_SLPWP6			(1 << 16)
> -#define MPMU_PCR_PJ_SLPWP7			(1 << 15)
> +#define MPMU_PCR_PJ_AXISD			(1U << 31)
> +#define MPMU_PCR_PJ_SLPEN			(1U << 29)
> +#define MPMU_PCR_PJ_SPSD			(1U << 28)
> +#define MPMU_PCR_PJ_DDRCORSD			(1U << 27)
> +#define MPMU_PCR_PJ_APBSD			(1U << 26)
> +#define MPMU_PCR_PJ_INTCLR			(1U << 24)
> +#define MPMU_PCR_PJ_SLPWP0			(1U << 23)
> +#define MPMU_PCR_PJ_SLPWP1			(1U << 22)
> +#define MPMU_PCR_PJ_SLPWP2			(1U << 21)
> +#define MPMU_PCR_PJ_SLPWP3			(1U << 20)
> +#define MPMU_PCR_PJ_VCTCXOSD			(1U << 19)
> +#define MPMU_PCR_PJ_SLPWP4			(1U << 18)
> +#define MPMU_PCR_PJ_SLPWP5			(1U << 17)
> +#define MPMU_PCR_PJ_SLPWP6			(1U << 16)
> +#define MPMU_PCR_PJ_SLPWP7			(1U << 15)
>  
>  #define MPMU_PLL2_CTRL1				MPMU_REG(0x0414)
>  #define MPMU_CGR_PJ				MPMU_REG(0x1024)
>  #define MPMU_WUCRM_PJ				MPMU_REG(0x104c)
> -#define MPMU_WUCRM_PJ_WAKEUP(x)			(1 << (x))
> -#define MPMU_WUCRM_PJ_RTC_ALARM			(1 << 17)
> +#define MPMU_WUCRM_PJ_WAKEUP(x)			(1U << (x))
> +#define MPMU_WUCRM_PJ_RTC_ALARM			(1U << 17)
>  
>  enum {
>  	POWER_MODE_ACTIVE = 0,
> diff --git a/arch/arm/mach-mmp/pm-pxa910.h b/arch/arm/mach-mmp/pm-pxa910.h
> index 8e6344adaf51..0958cde1ca6e 100644
> --- a/arch/arm/mach-mmp/pm-pxa910.h
> +++ b/arch/arm/mach-mmp/pm-pxa910.h
> @@ -10,54 +10,54 @@
>  #define __PXA910_PM_H__
>  
>  #define APMU_MOH_IDLE_CFG			APMU_REG(0x0018)
> -#define APMU_MOH_IDLE_CFG_MOH_IDLE		(1 << 1)
> -#define APMU_MOH_IDLE_CFG_MOH_PWRDWN		(1 << 5)
> -#define APMU_MOH_IDLE_CFG_MOH_SRAM_PWRDWN	(1 << 6)
> +#define APMU_MOH_IDLE_CFG_MOH_IDLE		(1U << 1)
> +#define APMU_MOH_IDLE_CFG_MOH_PWRDWN		(1U << 5)
> +#define APMU_MOH_IDLE_CFG_MOH_SRAM_PWRDWN	(1U << 6)
>  #define APMU_MOH_IDLE_CFG_MOH_PWR_SW(x)		(((x) & 0x3) << 16)
>  #define APMU_MOH_IDLE_CFG_MOH_L2_PWR_SW(x)	(((x) & 0x3) << 18)
> -#define APMU_MOH_IDLE_CFG_MOH_DIS_MC_SW_REQ	(1 << 21)
> -#define APMU_MOH_IDLE_CFG_MOH_MC_WAKE_EN	(1 << 20)
> +#define APMU_MOH_IDLE_CFG_MOH_DIS_MC_SW_REQ	(1U << 21)
> +#define APMU_MOH_IDLE_CFG_MOH_MC_WAKE_EN	(1U << 20)
>  
>  #define APMU_SQU_CLK_GATE_CTRL			APMU_REG(0x001c)
>  #define APMU_MC_HW_SLP_TYPE			APMU_REG(0x00b0)
>  
>  #define MPMU_FCCR				MPMU_REG(0x0008)
>  #define MPMU_APCR				MPMU_REG(0x1000)
> -#define MPMU_APCR_AXISD				(1 << 31)
> -#define MPMU_APCR_DSPSD				(1 << 30)
> -#define MPMU_APCR_SLPEN				(1 << 29)
> -#define MPMU_APCR_DTCMSD			(1 << 28)
> -#define MPMU_APCR_DDRCORSD			(1 << 27)
> -#define MPMU_APCR_APBSD				(1 << 26)
> -#define MPMU_APCR_BBSD				(1 << 25)
> -#define MPMU_APCR_SLPWP0			(1 << 23)
> -#define MPMU_APCR_SLPWP1			(1 << 22)
> -#define MPMU_APCR_SLPWP2			(1 << 21)
> -#define MPMU_APCR_SLPWP3			(1 << 20)
> -#define MPMU_APCR_VCTCXOSD			(1 << 19)
> -#define MPMU_APCR_SLPWP4			(1 << 18)
> -#define MPMU_APCR_SLPWP5			(1 << 17)
> -#define MPMU_APCR_SLPWP6			(1 << 16)
> -#define MPMU_APCR_SLPWP7			(1 << 15)
> -#define MPMU_APCR_MSASLPEN			(1 << 14)
> -#define MPMU_APCR_STBYEN			(1 << 13)
> +#define MPMU_APCR_AXISD				(1U << 31)
> +#define MPMU_APCR_DSPSD				(1U << 30)
> +#define MPMU_APCR_SLPEN				(1U << 29)
> +#define MPMU_APCR_DTCMSD			(1U << 28)
> +#define MPMU_APCR_DDRCORSD			(1U << 27)
> +#define MPMU_APCR_APBSD				(1U << 26)
> +#define MPMU_APCR_BBSD				(1U << 25)
> +#define MPMU_APCR_SLPWP0			(1U << 23)
> +#define MPMU_APCR_SLPWP1			(1U << 22)
> +#define MPMU_APCR_SLPWP2			(1U << 21)
> +#define MPMU_APCR_SLPWP3			(1U << 20)
> +#define MPMU_APCR_VCTCXOSD			(1U << 19)
> +#define MPMU_APCR_SLPWP4			(1U << 18)
> +#define MPMU_APCR_SLPWP5			(1U << 17)
> +#define MPMU_APCR_SLPWP6			(1U << 16)
> +#define MPMU_APCR_SLPWP7			(1U << 15)
> +#define MPMU_APCR_MSASLPEN			(1U << 14)
> +#define MPMU_APCR_STBYEN			(1U << 13)
>  
>  #define MPMU_AWUCRM				MPMU_REG(0x104c)
> -#define MPMU_AWUCRM_AP_ASYNC_INT		(1 << 25)
> -#define MPMU_AWUCRM_AP_FULL_IDLE		(1 << 24)
> -#define MPMU_AWUCRM_SDH1			(1 << 23)
> -#define MPMU_AWUCRM_SDH2			(1 << 22)
> -#define MPMU_AWUCRM_KEYPRESS			(1 << 21)
> -#define MPMU_AWUCRM_TRACKBALL			(1 << 20)
> -#define MPMU_AWUCRM_NEWROTARY			(1 << 19)
> -#define MPMU_AWUCRM_RTC_ALARM			(1 << 17)
> -#define MPMU_AWUCRM_AP2_TIMER_3			(1 << 13)
> -#define MPMU_AWUCRM_AP2_TIMER_2			(1 << 12)
> -#define MPMU_AWUCRM_AP2_TIMER_1			(1 << 11)
> -#define MPMU_AWUCRM_AP1_TIMER_3			(1 << 10)
> -#define MPMU_AWUCRM_AP1_TIMER_2			(1 << 9)
> -#define MPMU_AWUCRM_AP1_TIMER_1			(1 << 8)
> -#define MPMU_AWUCRM_WAKEUP(x)			(1 << ((x) & 0x7))
> +#define MPMU_AWUCRM_AP_ASYNC_INT		(1U << 25)
> +#define MPMU_AWUCRM_AP_FULL_IDLE		(1U << 24)
> +#define MPMU_AWUCRM_SDH1			(1U << 23)
> +#define MPMU_AWUCRM_SDH2			(1U << 22)
> +#define MPMU_AWUCRM_KEYPRESS			(1U << 21)
> +#define MPMU_AWUCRM_TRACKBALL			(1U << 20)
> +#define MPMU_AWUCRM_NEWROTARY			(1U << 19)
> +#define MPMU_AWUCRM_RTC_ALARM			(1U << 17)
> +#define MPMU_AWUCRM_AP2_TIMER_3			(1U << 13)
> +#define MPMU_AWUCRM_AP2_TIMER_2			(1U << 12)
> +#define MPMU_AWUCRM_AP2_TIMER_1			(1U << 11)
> +#define MPMU_AWUCRM_AP1_TIMER_3			(1U << 10)
> +#define MPMU_AWUCRM_AP1_TIMER_2			(1U << 9)
> +#define MPMU_AWUCRM_AP1_TIMER_1			(1U << 8)
> +#define MPMU_AWUCRM_WAKEUP(x)			(1U << ((x) & 0x7))
>  
>  enum {
>  	POWER_MODE_ACTIVE = 0,

