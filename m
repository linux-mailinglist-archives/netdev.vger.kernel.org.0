Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F59D543EBE
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 23:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbiFHVlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 17:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiFHVlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 17:41:39 -0400
X-Greylist: delayed 216 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Jun 2022 14:41:36 PDT
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F472FCB55;
        Wed,  8 Jun 2022 14:41:35 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id B12DC5048B3;
        Thu,  9 Jun 2022 00:40:16 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru B12DC5048B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1654724418; bh=J6wgd6h+yO4aYKw8SmBVZQ46x2TJ8dmCurBnhwlHQpU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IlYXTG6Q6wboLJYGUXbzB9tdRe/5rvSR8p1/n8UbG6ab2Wd7AP2eqFSwqkHf6BOgi
         8XiJE9OnZ15H3Vdh8GorNELmZlXtIsEzd7wFsThTBhtzJDxlswNEws7Wo9enKy5K3u
         5hcMJSBEa8xc5FX++P6WCht2pqcaWoRtKGk1uLx0=
Message-ID: <b71b0463-cb8b-2c1a-62a9-8be5b14ff1f2@novek.ru>
Date:   Wed, 8 Jun 2022 22:41:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v1 net-next 2/5] ptp_ocp: use bits.h macros for all masks
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
 <20220608120358.81147-3-andriy.shevchenko@linux.intel.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220608120358.81147-3-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.06.2022 13:03, Andy Shevchenko wrote:
> Currently we are using BIT(), but GENMASK(). Make use of the latter one
> as well (far less error-prone, far more concise).
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

LGTM

Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>   drivers/ptp/ptp_ocp.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> index 17930762fde9..926add7be9a2 100644
> --- a/drivers/ptp/ptp_ocp.c
> +++ b/drivers/ptp/ptp_ocp.c
> @@ -1,6 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0-only
>   /* Copyright (c) 2020 Facebook */
>   
> +#include <linux/bits.h>
>   #include <linux/err.h>
>   #include <linux/kernel.h>
>   #include <linux/module.h>
> @@ -88,10 +89,10 @@ struct tod_reg {
>   #define TOD_CTRL_DISABLE_FMT_A	BIT(17)
>   #define TOD_CTRL_DISABLE_FMT_B	BIT(16)
>   #define TOD_CTRL_ENABLE		BIT(0)
> -#define TOD_CTRL_GNSS_MASK	((1U << 4) - 1)
> +#define TOD_CTRL_GNSS_MASK	GENMASK(3, 0)
>   #define TOD_CTRL_GNSS_SHIFT	24
>   
> -#define TOD_STATUS_UTC_MASK		0xff
> +#define TOD_STATUS_UTC_MASK		GENMASK(7, 0)
>   #define TOD_STATUS_UTC_VALID		BIT(8)
>   #define TOD_STATUS_LEAP_ANNOUNCE	BIT(12)
>   #define TOD_STATUS_LEAP_VALID		BIT(16)
> @@ -205,7 +206,7 @@ struct frequency_reg {
>   #define FREQ_STATUS_VALID	BIT(31)
>   #define FREQ_STATUS_ERROR	BIT(30)
>   #define FREQ_STATUS_OVERRUN	BIT(29)
> -#define FREQ_STATUS_MASK	(BIT(24) - 1)
> +#define FREQ_STATUS_MASK	GENMASK(23, 0)
>   
>   struct ptp_ocp_flash_info {
>   	const char *name;
> @@ -674,9 +675,9 @@ static const struct ocp_selector ptp_ocp_clock[] = {
>   	{ }
>   };
>   
> +#define SMA_DISABLE		BIT(16)
>   #define SMA_ENABLE		BIT(15)
> -#define SMA_SELECT_MASK		((1U << 15) - 1)
> -#define SMA_DISABLE		0x10000
> +#define SMA_SELECT_MASK		GENMASK(14, 0)
>   
>   static const struct ocp_selector ptp_ocp_sma_in[] = {
>   	{ .name = "10Mhz",	.value = 0x0000 },
> @@ -3440,7 +3441,7 @@ ptp_ocp_tod_status_show(struct seq_file *s, void *data)
>   
>   	val = ioread32(&bp->tod->utc_status);
>   	seq_printf(s, "UTC status register: 0x%08X\n", val);
> -	seq_printf(s, "UTC offset: %d  valid:%d\n",
> +	seq_printf(s, "UTC offset: %ld  valid:%d\n",
>   		val & TOD_STATUS_UTC_MASK, val & TOD_STATUS_UTC_VALID ? 1 : 0);
>   	seq_printf(s, "Leap second info valid:%d, Leap second announce %d\n",
>   		val & TOD_STATUS_LEAP_VALID ? 1 : 0,

