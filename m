Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E70162D8C7
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 12:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234787AbiKQLF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 06:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239668AbiKQLFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 06:05:13 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC83DC23;
        Thu, 17 Nov 2022 03:04:35 -0800 (PST)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NCcVf1jQQzmW4f;
        Thu, 17 Nov 2022 19:04:10 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 19:04:33 +0800
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 19:04:33 +0800
Subject: Re: [PATCH wireless] brcmfmac: fix potential memory leak in
 brcmf_netdev_start_xmit()
To:     Kalle Valo <kvalo@kernel.org>
CC:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1668657281-28480-1-git-send-email-zhangchangzhong@huawei.com>
 <87bkp5sxj2.fsf@kernel.org>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <05b2af86-2354-74b0-27b6-7c20be7d035d@huawei.com>
Date:   Thu, 17 Nov 2022 19:04:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <87bkp5sxj2.fsf@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/17 18:09, Kalle Valo wrote:
> Zhang Changzhong <zhangchangzhong@huawei.com> writes:
> 
>> The brcmf_netdev_start_xmit() returns NETDEV_TX_OK without freeing skb
>> in case of pskb_expand_head() fails, add dev_kfree_skb() to fix it.
>>
>> Fixes: 270a6c1f65fe ("brcmfmac: rework headroom check in .start_xmit()")
>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> I assume you have not tested this on a real device? Then it would be
> really important to add "Compile tested only" to the commit log so that
> we know it's untested.
> 

OK, I'll add "Compile tested only" to the next version and other untested
patches.

Thanks,
Changzhong
