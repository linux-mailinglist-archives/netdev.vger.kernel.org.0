Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AB76055BF
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 05:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiJTDE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 23:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiJTDEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 23:04:51 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8D24621D
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 20:04:44 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MtC4t0PCgzmVFc;
        Thu, 20 Oct 2022 10:59:58 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 11:04:23 +0800
Received: from [10.174.176.230] (10.174.176.230) by
 kwepemm600008.china.huawei.com (7.193.23.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 11:04:22 +0800
Message-ID: <1635b9b0-f5c7-b7ed-34d9-bdfc67b2c3f9@huawei.com>
Date:   Thu, 20 Oct 2022 11:04:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH] mm/slub: Fix memory leak in sysfs_slab_add()
To:     <bongsu.jeon@samsung.com>, <krzysztof.kozlowski@linaro.org>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20221020030035.30075-1-shangxiaojing@huawei.com>
From:   shangxiaojing <shangxiaojing@huawei.com>
In-Reply-To: <20221020030035.30075-1-shangxiaojing@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.230]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600008.china.huawei.com (7.193.23.88)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/10/20 11:00, Shang XiaoJing wrote:
> From: Liu Shixin <liushixin2@huawei.com>
> 
> temporary scheme
> 
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> ---
>   mm/slub.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 4b98dff9be8e..3e19320aa162 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5980,6 +5980,10 @@ static int sysfs_slab_add(struct kmem_cache *s)
>   out:
>   	if (!unmergeable)
>   		kfree(name);
> +	if (err && s->kobj.name) {
> +		pr_err("need free kobject.name\n");
> +		kfree_const(s->kobj.name);
> +	}
>   	return err;
>   out_del_kobj:
>   	kobject_del(&s->kobj);


Sorry, please ignore, I made a wrong git operation.

Sorry,
-- 
Shang XiaoJing
