Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C4464C2EB
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 04:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237133AbiLNDzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 22:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiLNDzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 22:55:42 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AACD2631
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 19:55:41 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NX1cp2NpyzqT5R;
        Wed, 14 Dec 2022 11:51:22 +0800 (CST)
Received: from [10.67.110.176] (10.67.110.176) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 14 Dec 2022 11:55:27 +0800
Subject: Re: [PATCH v2] net: stmmac: fix possible memory leak in
 stmmac_dvr_probe()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <mcoquelin.stm32@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <boon.leong.ong@intel.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <20221212021350.3066631-1-cuigaosheng1@huawei.com>
 <20221213191528.75cd2ff0@kernel.org>
From:   cuigaosheng <cuigaosheng1@huawei.com>
Message-ID: <ae0f5e46-afb2-e103-0c24-2310ad326e55@huawei.com>
Date:   Wed, 14 Dec 2022 11:55:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20221213191528.75cd2ff0@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.176]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for taking time to review this patch.

I am sorry I missed the errno, and I have submit a new patch to fix it.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20221214034205.3449908-1-cuigaosheng1@huawei.com/

On 2022/12/14 11:15, Jakub Kicinski wrote:
> On Mon, 12 Dec 2022 10:13:50 +0800 Gaosheng Cui wrote:
>> The bitmap_free() should be called to free priv->af_xdp_zc_qps
>> when create_singlethread_workqueue() fails, otherwise there will
>> be a memory leak, so we add the err path error_wq_init to fix it.
>>
>> Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
>> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> The previous version has already been applied and we can't remove it.
> Could you send an incremental change to just add the errno?
> .
