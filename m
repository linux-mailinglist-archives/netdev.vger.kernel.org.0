Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEB859D552
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 11:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240197AbiHWIrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 04:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348405AbiHWIq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 04:46:27 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAB46EF27;
        Tue, 23 Aug 2022 01:21:33 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MBhtG2Cq6zlW6Y;
        Tue, 23 Aug 2022 16:17:42 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 23 Aug 2022 16:20:54 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 23 Aug
 2022 16:20:54 +0800
Subject: Re: [PATCH net-next 0/2] net: ethtool add VxLAN to the NFC API
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <idosch@nvidia.com>,
        <linux@rempel-privat.de>, <mkubecek@suse.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>
References: <20220817143538.43717-1-huangguangbin2@huawei.com>
 <20220817111656.7f4afaf3@kernel.org>
 <5062c7ae-3415-adf6-6488-f9a05177d2c2@huawei.com>
 <20220822095327.00b4ebd5@kernel.org>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <1371811b-2dca-7e99-6076-8090ee93616e@huawei.com>
Date:   Tue, 23 Aug 2022 16:20:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20220822095327.00b4ebd5@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/8/23 0:53, Jakub Kicinski wrote:
> On Mon, 22 Aug 2022 22:46:14 +0800 huangguangbin (A) wrote:
>> 1. I check the manual and implement of TC flower, it doesn't seems
>>      to support configuring flows steering to a specific queue.
> 
> We got an answer from Sridhar on that one (thanks!)
> I know it was discussed so it's a SMOC.
> 
>> 2. Our hns3 driver has supported configuring some type of flows
>>      steering to a specific queue by ethtool -U command, many users
>>      have already use ethtool way.
>> 3. In addition, if our driver supports TC flower to configure flows
>>      steering to a specific queue, can we allow user to simultaneously
>>      use TC flower and ethtool to configure flow rules? Could the rules
>>      configured by TC flower be queried by ethtool -u?
>>      If two ways can be existing, I think it is more complicated for
>>      driver to manage flow rules.
> 
> I understand your motivation and these are very valid points.
> However, we have to draw the line somewhere. We have at least
> three ways of configuring flow offloads (ethtool, nft, tc).
> Supporting all of them is a lot of work for the drivers, leading
> to a situation where there's no "standard Linux API" because each
> vendor picks a slightly different approach :(
> TC seems the most popular because of the OVS offload, so my preference
> is to pick it over the other APIs.
> .
> 
Ok.
