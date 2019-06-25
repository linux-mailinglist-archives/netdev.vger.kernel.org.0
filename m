Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 204B0555C7
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbfFYRVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfFYRVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 13:21:20 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F311A20883;
        Tue, 25 Jun 2019 17:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561483279;
        bh=y3gHH2+O9Ql5mg2OLCYxLt0FlNiFmTJg7bWVV64XY6A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l0X8y69GjzACRoWboU+YWIzW7at90jv3ub3xnAcXiI2AY8/5/o+s3FRVzpgcgow0s
         qZmJE2x8/1tEeCUA18QS4W+Yz1mC+61cO3nOBUjQHVQcXFkkCUKwIEfAS1tx+d6aG5
         CA/HKhKBrcyp62GzhIdzWDjDAQIaPUIBh0JBfMOI=
Date:   Tue, 25 Jun 2019 18:21:07 +0100
From:   Will Deacon <will@kernel.org>
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
        linux-samsung-soc@vger.kernel.org, linux@armlinux.org.uk,
        liviu.dudau@arm.com, lkundrak@v3.sk, lorenzo.pieralisi@arm.com,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, nsekhar@ti.com, peterz@infradead.org,
        robert.jarzmik@free.fr, s.hauer@pengutronix.de,
        sebastian.hesselbarth@gmail.com, shawnguo@kernel.org,
        songliubraving@fb.com, sudeep.holla@arm.com, swinslow@gmail.com,
        tglx@linutronix.de, tony@atomide.com, yhs@fb.com
Subject: Re: [PATCH V3 01/15] arm: perf: cleanup cppcheck shifting error
Message-ID: <20190625172106.26xxbeiwpn4avykh@willie-the-truck>
References: <20190624135105.15579-1-tranmanphong@gmail.com>
 <20190625040356.27473-1-tranmanphong@gmail.com>
 <20190625040356.27473-2-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625040356.27473-2-tranmanphong@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 11:03:42AM +0700, Phong Tran wrote:
> There is error from cppcheck tool
> "Shifting signed 32-bit value by 31 bits is undefined behaviour errors"
> change to use BIT() marco for improvement.

s/marco/macro/

As Peter pointed out, this "error" is also a false positive also for the
kernel.

> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
>  arch/arm/kernel/perf_event_v7.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
> index a4fb0f8b8f84..2924d7910b10 100644
> --- a/arch/arm/kernel/perf_event_v7.c
> +++ b/arch/arm/kernel/perf_event_v7.c
> @@ -697,9 +697,9 @@ static struct attribute_group armv7_pmuv2_events_attr_group = {
>  /*
>   * Event filters for PMUv2
>   */
> -#define	ARMV7_EXCLUDE_PL1	(1 << 31)
> -#define	ARMV7_EXCLUDE_USER	(1 << 30)
> -#define	ARMV7_INCLUDE_HYP	(1 << 27)
> +#define	ARMV7_EXCLUDE_PL1	BIT(31)
> +#define	ARMV7_EXCLUDE_USER	BIT(30)
> +#define	ARMV7_INCLUDE_HYP	BIT(27)

Acked-by: Will Deacon <will.deacon@arm.com>

You can drop this into Russell's patch system[1].

Will

[1] https://www.arm.linux.org.uk/developer/patches/
