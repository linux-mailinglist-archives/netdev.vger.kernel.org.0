Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477AC3A1B9C
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 19:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhFIRUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 13:20:33 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:58946 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbhFIRU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 13:20:27 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 159HILJ6126249;
        Wed, 9 Jun 2021 12:18:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1623259101;
        bh=msVLVZG0CgVTC8C90E1q2rYU+c929NvK/sY0LT7l5HA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=e6wQ+V+QWTryRvGqW35cn35YyN6E7kiaagNtcEm+j5gTBRq6P7lLHtuEYSqpuznrd
         viJaqBZx6WnhDHtDePt20EDZIRechQEY+3Vw720Tcw/wx2eNr7r7UsI2po5CKxmLXG
         QhwQ9CURsspE0w6ErGDZNPTCy3UXx3EJc7/SKdiM=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 159HILxw023347
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 9 Jun 2021 12:18:21 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 9 Jun
 2021 12:18:21 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Wed, 9 Jun 2021 12:18:21 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 159HIJEL047861;
        Wed, 9 Jun 2021 12:18:20 -0500
Subject: Re: [PATCH net-next] net: ethernet: ti: cpsw: Use
 devm_platform_get_and_ioremap_resource()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
References: <20210609140152.3198309-1-yangyingliang@huawei.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <457bcc88-00a1-61fd-7a1d-1c8dfaaf56d6@ti.com>
Date:   Wed, 9 Jun 2021 20:18:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210609140152.3198309-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/06/2021 17:01, Yang Yingliang wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   drivers/net/ethernet/ti/cpsw.c     | 3 +--
>   drivers/net/ethernet/ti/cpsw_new.c | 3 +--
>   2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index c0cd7de88316..b1e80cc96f56 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -1532,8 +1532,7 @@ static int cpsw_probe(struct platform_device *pdev)
>   	}
>   	cpsw->bus_freq_mhz = clk_get_rate(clk) / 1000000;
>   
> -	ss_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	ss_regs = devm_ioremap_resource(dev, ss_res);
> +	ss_regs = devm_platform_get_and_ioremap_resource(pdev, 0, &ss_res);
>   	if (IS_ERR(ss_regs))
>   		return PTR_ERR(ss_regs);
>   	cpsw->regs = ss_regs;
> diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
> index 69b7a4e0220a..8d4f3c53385d 100644
> --- a/drivers/net/ethernet/ti/cpsw_new.c
> +++ b/drivers/net/ethernet/ti/cpsw_new.c
> @@ -1883,8 +1883,7 @@ static int cpsw_probe(struct platform_device *pdev)
>   	}
>   	cpsw->bus_freq_mhz = clk_get_rate(clk) / 1000000;
>   
> -	ss_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	ss_regs = devm_ioremap_resource(dev, ss_res);
> +	ss_regs = devm_platform_get_and_ioremap_resource(pdev, 0, &ss_res);
>   	if (IS_ERR(ss_regs)) {
>   		ret = PTR_ERR(ss_regs);
>   		return ret;
> 

Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
grygorii
