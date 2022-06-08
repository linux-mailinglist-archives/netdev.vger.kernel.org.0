Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482D5543ED5
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 23:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbiFHVsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 17:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbiFHVsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 17:48:12 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0AD25CE;
        Wed,  8 Jun 2022 14:48:06 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 5A3B450488D;
        Thu,  9 Jun 2022 00:46:48 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 5A3B450488D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1654724809; bh=GxGNd4aTkt0CqHPWrf7RQ35OdEpc/lp9ryqSi3+QDZQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=m1rJNnG2NEXbbLp57P590G5lweGbec6gqMJMwE5YJmBBkGpF0Il7JKvSwhgraOMZg
         R0qONK0ktCFRHtYW2Kbv5iIBHScUtHwZQTyQM51Ti6Bo8sTLsCTMobjvBlfQ+3QIZW
         Oi+kz3IZ/4c+Blc4/mKM2Jnd6hNN/FIjxt4l7gVs=
Message-ID: <a209f16b-0de0-9c67-8bce-96a91a2a5732@novek.ru>
Date:   Wed, 8 Jun 2022 22:48:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v1 net-next 5/5] ptp_ocp: replace kzalloc(x*y) by
 kcalloc(y, x)
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
 <20220608120358.81147-6-andriy.shevchenko@linux.intel.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220608120358.81147-6-andriy.shevchenko@linux.intel.com>
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
> While here it may be no difference, the kcalloc() has some checks
> against overflow and it's logically correct to call it for an array.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>

> ---
>   drivers/ptp/ptp_ocp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> index 857e35c68a04..83da36e69361 100644
> --- a/drivers/ptp/ptp_ocp.c
> +++ b/drivers/ptp/ptp_ocp.c
> @@ -2155,7 +2155,7 @@ ptp_ocp_fb_set_pins(struct ptp_ocp *bp)
>   	struct ptp_pin_desc *config;
>   	int i;
>   
> -	config = kzalloc(sizeof(*config) * 4, GFP_KERNEL);
> +	config = kcalloc(4, sizeof(*config), GFP_KERNEL);
>   	if (!config)
>   		return -ENOMEM;
>   

