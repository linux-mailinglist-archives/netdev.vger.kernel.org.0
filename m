Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1BD543EC3
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 23:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbiFHVmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 17:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiFHVmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 17:42:21 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2635A093;
        Wed,  8 Jun 2022 14:42:20 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 61E305048B3;
        Thu,  9 Jun 2022 00:41:02 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 61E305048B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1654724463; bh=a9HRTmEUMbJXnRGdvTfjdyQcEfe9/TsPFII6KPdLTRQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=RdEG4Mc5o5qMjYyV/xbZg4dVqzLn55jwUUDyttk/Egv1lhdLzfWtcInRQfiC+65Dz
         4AQRtzHR5OxIW1P4ogoQ/PyAF/q0tWqCXD+cK2ls1FjBtQTahPKblyTsSu8XIu84bw
         sfwWJ1HuwSnrrg6s+FShOf8sIif+sfrPE30CGwTw=
Message-ID: <15b5c61e-8884-940c-4df9-647bce078e29@novek.ru>
Date:   Wed, 8 Jun 2022 22:42:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v1 net-next 3/5] ptp_ocp: drop duplicate NULL check in
 ptp_ocp_detach()
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
 <20220608120358.81147-4-andriy.shevchenko@linux.intel.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220608120358.81147-4-andriy.shevchenko@linux.intel.com>
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
> Since platform_device_unregister() is NULL-aware, we don't need to duplicate
> this check. Remove it and fold the rest of the code.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>   drivers/ptp/ptp_ocp.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> index 926add7be9a2..4e237f806085 100644
> --- a/drivers/ptp/ptp_ocp.c
> +++ b/drivers/ptp/ptp_ocp.c
> @@ -3701,10 +3701,8 @@ ptp_ocp_detach(struct ptp_ocp *bp)
>   		serial8250_unregister_port(bp->mac_port);
>   	if (bp->nmea_port != -1)
>   		serial8250_unregister_port(bp->nmea_port);
> -	if (bp->spi_flash)
> -		platform_device_unregister(bp->spi_flash);
> -	if (bp->i2c_ctrl)
> -		platform_device_unregister(bp->i2c_ctrl);
> +	platform_device_unregister(bp->spi_flash);
> +	platform_device_unregister(bp->i2c_ctrl);
>   	if (bp->i2c_clk)
>   		clk_hw_unregister_fixed_rate(bp->i2c_clk);
>   	if (bp->n_irqs)

