Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409FF1CA6A2
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 10:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgEHIyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 04:54:24 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:50522 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgEHIyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 04:54:24 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0488sBTb045458;
        Fri, 8 May 2020 03:54:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588928051;
        bh=ZrBzU2NvJVBdusFAfOPLzRcXzk6CIzk04r5ERKP1Z2k=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=E4aLPdYXjfqVKd7rQKdcTvuwjZWnEJQcMnTlnn5Y0g7pK7WMCp0EPWkk8JBzi+/S3
         bkWkV0XU3uNSzWB9mWfvr2gI8M6RwYyRVtm6IT/Cv2TzDINFYdOGU06F7hsDcVb0M3
         XKFdznCN/lwxF9zbtq4A7ZYuoO8JaXc664aWYEQM=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0488sBAo129398;
        Fri, 8 May 2020 03:54:11 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 8 May
 2020 03:54:11 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 8 May 2020 03:54:11 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0488s8mO073269;
        Fri, 8 May 2020 03:54:09 -0500
Subject: Re: [PATCH net-next] net: ethernet: ti: fix error return code in
 am65_cpsw_nuss_probe()
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
References: <20200508021059.172001-1-weiyongjun1@huawei.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <4440e1fc-2749-cf36-b5d0-fa252789d37c@ti.com>
Date:   Fri, 8 May 2020 11:54:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200508021059.172001-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08/05/2020 05:10, Wei Yongjun wrote:
> Fix to return negative error code -ENOMEM from the cpsw_ale_create()
> error handling case instead of 0, as done elsewhere in this function.
> 
> Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>   drivers/net/ethernet/ti/am65-cpsw-nuss.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index f8c589929308..066ba52f57cb 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -2065,6 +2065,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
>   	common->ale = cpsw_ale_create(&ale_params);
>   	if (!common->ale) {
>   		dev_err(dev, "error initializing ale engine\n");
> +		ret = -ENOMEM;
>   		goto err_of_clear;
>   	}
> 
> 
> 

It seems not enough.

For consistency, Could you update it as below?
- cpsw_ale_create() to return PTR_ERR() in all places
- users to use IS_ERR() and ret = PTR_ERR()


-- 
Best regards,
grygorii
