Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410C56058FA
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 09:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiJTHtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 03:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbiJTHtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 03:49:02 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCD11757B3
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 00:49:00 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MtKRG5K8NzJn6C;
        Thu, 20 Oct 2022 15:46:18 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 15:48:38 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 15:48:38 +0800
Subject: Re: [PATCH net] net: hns: fix possible memory leak in
 hnae_ae_register()
To:     Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>
References: <20221018122451.1749171-1-yangyingliang@huawei.com>
 <Y06i/kWwJNT5mbj8@unreal> <20221019172832.712eb056@kernel.org>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <3e9539a9-e3b9-1418-cd3b-426d2efeaef1@huawei.com>
Date:   Thu, 20 Oct 2022 15:48:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20221019172832.712eb056@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/10/20 8:28, Jakub Kicinski wrote:
> On Tue, 18 Oct 2022 15:58:38 +0300 Leon Romanovsky wrote:
>> The change itself is ok.
> Also the .release function is empty which is another bad smell?
The upper device (struct dsaf_device *dsaf_dev) is allocated by 
devm_kzalloc(),
so it's no need to free it in ->release().

Thanks,
Yang
>
>> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Thanks!
> .
