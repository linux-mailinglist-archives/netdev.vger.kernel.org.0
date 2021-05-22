Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDB538D76C
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 22:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhEVUrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 16:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhEVUrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 16:47:45 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F747C061574
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 13:46:19 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id lz27so35650985ejb.11
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 13:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UzMmyceO3Q/ZlHgmxpgCoi1VldstNjhJayiNr3tNQRk=;
        b=NpUnqKMPK2JsZ7Q6Ba6TXg9/RWU81TnevSpOcK0UdkAV5WUKb0EbLQiUi/ZTGfSror
         4qlDgf+EpGsbwNsCXaGF8FyIoiHjLNtIvcy0wwRFP8sfXWkUhDyZ+bfahDTCA3rYum/q
         QMSYpM77bV2Lwym+AX33A4EOAxeJgNCWPFS1aJCTNXijgLRhy1pKfzKb+Hh1iipmbK3l
         BYORJtYS1vHbsrq2AwUFQ+CJ0yJl2jbbMq1Y2CwQyKRApsy6+yuIO+jlzgN5KL+WA6AT
         /J4NboAf4EYOPZQgCcFmSmETGnRlmktLVvCFqxrXQkuKc4Y2YydqqX9hHiyQhSgX/B2A
         IM8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UzMmyceO3Q/ZlHgmxpgCoi1VldstNjhJayiNr3tNQRk=;
        b=SnSKwFx9MqL8LqDXISfQS0g/ovPoXMgaVvjcTT4RfoM/iqxpZM0Zeh5K+oY75rQA8h
         11+//bJYWC1fvuQBt4cBJpx1PGVzuEXLb+8djZQw4ZKCEpDUFhb1HF6UAGtfAMqBl3jO
         AoXQKtJwnOg+Gkk822Lc+C3EAvXVQYjax+cr708peGe1alBNE+ZZgDitrWmivI/id0Zr
         z5UyTCEOA6Dz/0NPWmwSC9UfqUFKVGdfn09JBiHj4Xf4lRVssfFK2TtKGAy0xDde3CvE
         py0X9PP0auLlTPe4CA2ObaaG6FDTSg9Kf9Vm4jH7BpmSphpHUkri/nnz6OndfWgP1nlY
         GCJg==
X-Gm-Message-State: AOAM531lwyk6C65vjkVDTcWzBPm2at47Q1eRjLTFUBm7qdDDm3NbPDiE
        iB2fLI2z1Jvl4YVRi/0Suss=
X-Google-Smtp-Source: ABdhPJxyE80Dkrd3qshMDHh2/F9uKhsJlqfq/lYt8yRPIp4dAzEj41RQz2dZRyYuT+qaD2PjBp7rMw==
X-Received: by 2002:a17:906:46d1:: with SMTP id k17mr15887691ejs.77.1621716376728;
        Sat, 22 May 2021 13:46:16 -0700 (PDT)
Received: from [192.168.0.129] ([82.137.32.75])
        by smtp.gmail.com with ESMTPSA id v8sm5729082ejq.62.2021.05.22.13.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 May 2021 13:46:16 -0700 (PDT)
Subject: Re: [net-next, v2, 7/7] enetc: support PTP domain timestamp
 conversion
To:     Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-8-yangbo.lu@nxp.com>
From:   Claudiu Manoil <claudiu.manoil@gmail.com>
Message-ID: <206a857a-625c-e604-9916-7f73f79d191c@gmail.com>
Date:   Sat, 22 May 2021 23:46:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210521043619.44694-8-yangbo.lu@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Yangbo,

On 21.05.2021 07:36, Yangbo Lu wrote:
> Support timestamp conversion to specified PTP domain in PTP packet.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
> Changes for v2:
> 	- Fixed build waring.
> 	- Updated copyright.
> ---
>   drivers/net/ethernet/freescale/enetc/enetc.c | 39 ++++++++++++++++++--
>   1 file changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
> index 3ca93adb9662..cd0429c73999 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -1,5 +1,5 @@
>   // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> -/* Copyright 2017-2019 NXP */
> +/* Copyright 2017-2021 NXP */
>   
>   #include "enetc.h"
>   #include <linux/bpf_trace.h>
> @@ -7,6 +7,7 @@
>   #include <linux/udp.h>
>   #include <linux/vmalloc.h>
>   #include <linux/ptp_classify.h>
> +#include <linux/ptp_clock_kernel.h>
>   #include <net/pkt_sched.h>
>   
>   static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
> @@ -472,13 +473,36 @@ static void enetc_get_tx_tstamp(struct enetc_hw *hw, union enetc_tx_bd *txbd,
>   	*tstamp = (u64)hi << 32 | tstamp_lo;
>   }
>   
> -static void enetc_tstamp_tx(struct sk_buff *skb, u64 tstamp)
> +static int enetc_ptp_parse_domain(struct sk_buff *skb, u8 *domain)
> +{
> +	unsigned int ptp_class;
> +	struct ptp_header *hdr;
> +
> +	ptp_class = ptp_classify_raw(skb);
> +	if (ptp_class == PTP_CLASS_NONE)
> +		return -EINVAL;
> +
> +	hdr = ptp_parse_header(skb, ptp_class);
> +	if (!hdr)
> +		return -EINVAL;
> +
> +	*domain = hdr->domain_number;
> +	return 0;
> +}
> +

Why is this function defined inside the enetc driver? I don't see 
anything enetc specific to it, but it looks like another generic ptp 
procedure, similar to ptp_parse_header() or ptp_clock_domain_tstamp().
