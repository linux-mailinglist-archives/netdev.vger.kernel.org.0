Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1C46384CE
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 08:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiKYHxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 02:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKYHxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 02:53:16 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B2829826;
        Thu, 24 Nov 2022 23:53:16 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NJRt05jbgzmW9R;
        Fri, 25 Nov 2022 15:52:40 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 15:53:14 +0800
Subject: Re: [PATCH net] net: hsr: Fix potential use-after-free
To:     Paolo Abeni <pabeni@redhat.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <arvid.brodin@alten.se>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221123063057.25952-1-yuehaibing@huawei.com>
 <cf297dd17750f988128df88c824f956f2a4bb719.camel@redhat.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <250b2e18-13bd-b0d5-8117-112ffc42b55a@huawei.com>
Date:   Fri, 25 Nov 2022 15:53:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <cf297dd17750f988128df88c824f956f2a4bb719.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/24 16:53, Paolo Abeni wrote:
> Hello,
> 
> On Wed, 2022-11-23 at 14:30 +0800, YueHaibing wrote:
>> The skb is delivered to netif_rx() which may free it, after calling this,
>> dereferencing skb may trigger use-after-free.
>>
>> Fixes: f266a683a480 ("net/hsr: Better frame dispatch")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> The code looks good, but the above is not the commit introducing the
> issue, it just move the netif_rx() and later skb access from somewhere
> else.
> 
> Please go deeper in git history and find the change that originated the> issue.

Ok, will dig it.

> 
> Thanks,
> 
> Paolo
> 
> .
> 
