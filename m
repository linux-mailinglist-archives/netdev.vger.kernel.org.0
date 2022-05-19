Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B2B52CACF
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 06:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbiESEUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 00:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbiESEUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 00:20:19 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA49B9859D
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 21:20:13 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L3c7q3KvvzhZFt;
        Thu, 19 May 2022 12:19:35 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 19 May 2022 12:20:11 +0800
Subject: Re: [PATCH net-next v2] net: wwan: t7xx: fix GFP_KERNEL usage in
 spin_lock context
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC:     <chandrashekar.devegowda@intel.com>, <linuxwwan@intel.com>,
        <chiranjeevi.rapolu@linux.intel.com>, <haijun.liu@mediatek.com>,
        <m.chetan.kumar@linux.intel.com>,
        <ricardo.martinez@linux.intel.com>, <loic.poulain@linaro.org>,
        <ryazanov.s.a@gmail.com>, <johannes@sipsolutions.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, Netdev <netdev@vger.kernel.org>
References: <20220517064821.3966990-1-william.xuanziyang@huawei.com>
 <d04ffa5b-13f6-5f4d-98e4-1a4550d6f69@linux.intel.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <4e6405fa-2939-20ea-dcec-5041c5e1f2f3@huawei.com>
Date:   Thu, 19 May 2022 12:20:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d04ffa5b-13f6-5f4d-98e4-1a4550d6f69@linux.intel.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, 17 May 2022, Ziyang Xuan wrote:
> 
>> t7xx_cldma_clear_rxq() call t7xx_cldma_alloc_and_map_skb() in spin_lock
>> context, But __dev_alloc_skb() in t7xx_cldma_alloc_and_map_skb() uses
>> GFP_KERNEL, that will introduce scheduling factor in spin_lock context.
>>
>> Because t7xx_cldma_clear_rxq() is called after stopping CLDMA, so we can
>> remove the spin_lock from t7xx_cldma_clear_rxq().
>>
> 
> Perhaps Suggested-by: ... would have been appropriate too.

Yes£¬I will send the v3 patch.

> 
>> Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> 
