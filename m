Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02740601C16
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 00:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiJQWLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 18:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiJQWLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 18:11:44 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBF46C96A
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 15:11:43 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so15545497pjq.3
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 15:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yKXEn3BHCUa8FLEFKfOVUMorMrQv6lBr8VXQMwu2VLw=;
        b=J3mvcXVenYARhzDd5dr39z47OLSGLkwIyDPaAzy50rCEs3s+dRZd7+u831UtcJt5cL
         Ca0FlQo/UVTpNAnVOCDwlzPyAbuG2KGx8w/Eq3l4LNZX8kdxWY+ralRvS7NU49dblxY/
         jeJmrQ3YRS8n7sWN0N73ilt8NvLmvQxRdoSVav2NK54auafIGL/+Aaezwj1pz/ObowAl
         EXGKQ3+RXXjpJH2LUw7bUuN4fzGGYD/Pg+v/fiM5KErgeSgXMsg4+uuU394EOHXhsUTW
         KiSUP6cavK21wuOoE5jb0nxZ1EbdQwjs45wKkDU8/uXLWBjjEfPFvOSmgrVdbbzrSTQr
         shZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yKXEn3BHCUa8FLEFKfOVUMorMrQv6lBr8VXQMwu2VLw=;
        b=Jk35bRHv6ro3fSSuQmZHT7jKN9PmANPBTMVfXw921NMhNxgdN85cKtZ6D+hD2aWUvB
         dRgYJXoYiobkOfudThvjxo0akT4STOyHePsGck04Ybbb7ArO6M+8wTbtrSDqeu3lRKs+
         KEdB35wQ0r3vHWtjPIVpQkFmp7n68mqGP+12+zZZKc+okkgbFX/EOsksWcJgvIFOxpeB
         QNglEnD5iSZc7KSCsYufF5prSZJmfwZ32IdkPf6wlkCrbiq9vVLw1jCkqLJJs1s18vcx
         nhGT7Bovh9S1AAGi58JJDiSVfktjRnjPczpSMGwlS4LK9S7bg8jX3qmkhMljEPcigaCC
         yD4g==
X-Gm-Message-State: ACrzQf1A5kL/RB0f9vHSNjQq+hE4ESqbmq9eXO4yOWJE5yIWozOyIeNT
        yZZnBKn7IyeYNWOEWQ0rIcg=
X-Google-Smtp-Source: AMsMyM7EyeWtx9JOCApzWLptHKxXNWhfA+pzxpOcTLmTlnZhapjh4xcJpe4x4OFpw0QWyeirRL2cPw==
X-Received: by 2002:a17:90b:1e04:b0:20d:90b3:45e5 with SMTP id pg4-20020a17090b1e0400b0020d90b345e5mr33487730pjb.113.1666044702754;
        Mon, 17 Oct 2022 15:11:42 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:2103:475:ef07:bb37:8b7b? ([2620:10d:c090:400::5:6fcd])
        by smtp.gmail.com with ESMTPSA id w14-20020a170902a70e00b0017c7376ac9csm7087093plq.206.2022.10.17.15.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 15:11:41 -0700 (PDT)
Message-ID: <cd67d53e-bf1b-ae33-108d-975391feb5c3@gmail.com>
Date:   Mon, 17 Oct 2022 15:11:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [PATCH net-next 2/5] ptp: ocp: add Orolia timecard support
Content-Language: en-US
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>,
        Charles Parent <charles.parent@orolia2s.com>
References: <20221017215947.7438-1-vfedorenko@novek.ru>
 <20221017215947.7438-3-vfedorenko@novek.ru>
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
In-Reply-To: <20221017215947.7438-3-vfedorenko@novek.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/17/22 2:59 PM, Vadim Fedorenko wrote:
> From: Vadim Fedorenko <vadfed@fb.com>
> 
> This brings in the Orolia timecard support from the GitHub repository.
> The card uses different drivers to provide access to i2c EEPROM and
> firmware SPI flash. And it also has a bit different EEPROM map, but
> other parts of the code are the same and could be reused.
> 
> Co-developed-by: Charles Parent <charles.parent@orolia2s.com>
> Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
> ---
>   drivers/ptp/ptp_ocp.c | 296 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 296 insertions(+)
> 
> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> index e5b28f89c8dd..cd4f3860d72a 100644
> --- a/drivers/ptp/ptp_ocp.c
> +++ b/drivers/ptp/ptp_ocp.c
> @@ -13,9 +13,11 @@
>   #include <linux/clk-provider.h>
>   #include <linux/platform_device.h>
>   #include <linux/platform_data/i2c-xiic.h>
> +#include <linux/platform_data/i2c-ocores.h>
>   #include <linux/ptp_clock_kernel.h>
>   #include <linux/spi/spi.h>
>   #include <linux/spi/xilinx_spi.h>
> +#include <linux/spi/altera.h>
>   #include <net/devlink.h>
>   #include <linux/i2c.h>
>   #include <linux/mtd/mtd.h>
> @@ -28,6 +30,14 @@
>   #define PCI_VENDOR_ID_CELESTICA			0x18d4
>   #define PCI_DEVICE_ID_CELESTICA_TIMECARD	0x1008
>   
> +#ifndef PCI_VENDOR_ID_OROLIA
> +#define PCI_VENDOR_ID_OROLIA 0x1ad7
> +#endif
> +
> +#ifndef PCI_DEVICE_ID_OROLIA_ARTCARD
> +#define PCI_DEVICE_ID_OROLIA_ARTCARD 0xa000
> +#endif
Remove the #ifndef #endif pairs here.

Also, you're missing my SOB on these patches.
--
Jonathan

