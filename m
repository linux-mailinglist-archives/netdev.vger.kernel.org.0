Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396075BD98D
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiITBlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiITBl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:41:29 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898B354C80;
        Mon, 19 Sep 2022 18:40:42 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MWkfV3z39zlW2D;
        Tue, 20 Sep 2022 09:36:34 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 09:40:39 +0800
Received: from [10.174.178.31] (10.174.178.31) by
 kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 09:40:38 +0800
Subject: Re: [PATCH v2] net: ethernet: altera: TSE: fix error return code in
 altera_tse_probe()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <joyce.ooi@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20220909024617.2584200-1-sunke32@huawei.com>
 <20220919140951.3dcdcba7@kernel.org>
From:   Sun Ke <sunke32@huawei.com>
Message-ID: <9e8cbda4-2c9e-4c7a-e336-2926cecaab0a@huawei.com>
Date:   Tue, 20 Sep 2022 09:40:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20220919140951.3dcdcba7@kernel.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.31]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2022/9/20 5:09, Jakub Kicinski Ð´µÀ:
> On Fri, 9 Sep 2022 10:46:17 +0800 Sun Ke wrote:
>> Fix to return a negative error code from the error handling
>> case instead of 0, as done elsewhere in this function.
>>
>> Fixes: fef2998203e1 ("net: altera: tse: convert to phylink")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Sun Ke <sunke32@huawei.com>
> 
> You must CC Maxime, who authored the change under Fixes,
> and is most likely the best person to give us a review.
> Please repost with the CC fixed.

OK.

Thanks,
Sun Ke
> 
>> diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
>> index 89ae6d1623aa..3cf409bdb283 100644
>> --- a/drivers/net/ethernet/altera/altera_tse_main.c
>> +++ b/drivers/net/ethernet/altera/altera_tse_main.c
>> @@ -1411,6 +1411,7 @@ static int altera_tse_probe(struct platform_device *pdev)
>>   				       priv->phy_iface, &alt_tse_phylink_ops);
>>   	if (IS_ERR(priv->phylink)) {
>>   		dev_err(&pdev->dev, "failed to create phylink\n");
>> +		ret = PTR_ERR(priv->phylink);
>>   		goto err_init_phy;
>>   	}
>>   
> 
> .
> 
