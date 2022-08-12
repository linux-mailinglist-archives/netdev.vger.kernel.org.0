Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C35591041
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 13:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbiHLLn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 07:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238128AbiHLLnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 07:43:06 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B359AF0D9
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 04:43:04 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M41ts6FJNzlW04;
        Fri, 12 Aug 2022 19:40:05 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 12 Aug
 2022 19:43:02 +0800
Subject: Re: [RFCv7 PATCH net-next 36/36] net: redefine the prototype of
 netdev_features_t
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <ecree.xilinx@gmail.com>,
        <hkallweit1@gmail.com>, <saeed@kernel.org>, <leon@kernel.org>,
        <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20220810030624.34711-1-shenjian15@huawei.com>
 <20220810030624.34711-37-shenjian15@huawei.com>
 <20220810113547.1308711-1-alexandr.lobakin@intel.com>
 <3df89822-7dec-c01e-0df9-15b8e6f7d4e5@huawei.com>
 <20220811130757.9904-1-alexandr.lobakin@intel.com>
 <20220811081311.0f549b39@kernel.org>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <9ee936ee-ae94-6c71-2ca5-e8d349bc9b97@huawei.com>
Date:   Fri, 12 Aug 2022 19:43:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220811081311.0f549b39@kernel.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2022/8/11 23:13, Jakub Kicinski Ð´µÀ:
> On Thu, 11 Aug 2022 15:07:57 +0200 Alexander Lobakin wrote:
>
>>> Yes, Jakub also mentioned this.
>>>
>>> But there are many existed features interfaces(e.g. ndo_fix_features,
>>> ndo_features_check), use netdev_features_t as return value. Then we
>>> have to change their prototype.
>> We have to do 12k lines of changes already :D
>> You know, 16 bytes is probably fine to return directly and it will
>> be enough for up to 128 features (+64 more comparing to the
>> mainline). OTOH, using pointers removes that "what if/when", so
>> it's more flexible in that term. So that's why I asked for other
>> folks' opinions -- 2 PoVs doesn't seem enough here.
> >From a quick grep it seems like the and() is mostly used in some form
> of:
>
> 	features = and(features, mask);
>
> and we already have netdev_features_clear() which modifies its first
> argument. I'd also have and() update its first arg rather than return
> the result as a value.
ok, I will follow the behaviour of bitmap_and().

> It will require changing the prototype of
> ndo_features_check() :( But yeah, I reckon we shouldn't be putting of
> refactoring, best if we make all the changes at once than have to
> revisit this once the flags grow again and return by value starts to
> be a problem.
> .
>



Thanks,
Jian
