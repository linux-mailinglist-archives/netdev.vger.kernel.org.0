Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFB8538B67
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 08:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243547AbiEaG2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 02:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbiEaG2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 02:28:03 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF15D3FDBF;
        Mon, 30 May 2022 23:28:01 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LC2Lm3XT0zBrnj;
        Tue, 31 May 2022 14:24:48 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 14:27:53 +0800
Subject: Re: [PATCH net] macsec: fix UAF bug for real_dev
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ap420073@gmail.com>
References: <20220528093659.3186312-1-william.xuanziyang@huawei.com>
 <20220530212338.7a7d4145@kernel.org>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <71f44378-3961-b751-1ae9-f9c4bc4b061a@huawei.com>
Date:   Tue, 31 May 2022 14:27:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20220530212338.7a7d4145@kernel.org>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Sat, 28 May 2022 17:36:59 +0800 Ziyang Xuan wrote:
>> --- a/drivers/net/macsec.c
>> +++ b/drivers/net/macsec.c
>> @@ -107,6 +107,7 @@ struct pcpu_secy_stats {
>>  struct macsec_dev {
>>  	struct macsec_secy secy;
>>  	struct net_device *real_dev;
>> +	netdevice_tracker dev_tracker;
> 
> You need to add kdoc for @dev_tracker.

Yes, it's right. I will give v2 later.

Thank you!
> .
> 
