Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82846E60D5
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjDRMMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjDRMLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:11:51 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A42019B9
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 05:11:45 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [7.185.36.74])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q12jj6pRXzSsLm;
        Tue, 18 Apr 2023 20:07:37 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 18 Apr
 2023 20:11:43 +0800
Subject: Re: [PATCH net-next v2 1/5] net: wangxun: libwx add tx offload
 functions
To:     "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
CC:     <netdev@vger.kernel.org>, Jiawen Wu <jiawenwu@trustnetic.com>
References: <20230417105457.82127-1-mengyuanlou@net-swift.com>
 <20230417105457.82127-2-mengyuanlou@net-swift.com>
 <630e590e-fac3-5f69-688e-ac140ab3464e@huawei.com>
 <4E862584-755D-4EC4-9588-DB0B14D64CD5@net-swift.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <82c37bb4-b2b0-037a-7f63-71324f493e1d@huawei.com>
Date:   Tue, 18 Apr 2023 20:11:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <4E862584-755D-4EC4-9588-DB0B14D64CD5@net-swift.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/18 15:00, mengyuanlou@net-swift.com wrote:
>>> + goto exit;
>>> + case htons(ETH_P_ARP):
>>> + ptype = WX_PTYPE_L2_ARP;
>>> + goto exit;
>>> + default:
>>> + ptype = WX_PTYPE_L2_MAC;
>>
>> Is it ok to set ptype to WX_PTYPE_L2_MAC for first->protocol != ETH_P_IP
>> && first->protocol != ETH_P_IPV6? Does hw need to do checksum/tso or other thing
>> about those packet? if not, setting WX_PTYPE_L2_MAC seems enough?
>>
>     • The hardware needs to parse these packets with these ptype bits.

What does hw do after parsing these packets? Updating some stats according to
the protocol type?
It seems really related to hw implementation, I am just curious if it is worth
the added overhead for driver.
