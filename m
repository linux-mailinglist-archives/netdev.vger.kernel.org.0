Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853254BEF61
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiBVCGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:06:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiBVCGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:06:32 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAAF240B2;
        Mon, 21 Feb 2022 18:06:06 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4K2jD55nzbzdZPq;
        Tue, 22 Feb 2022 10:04:53 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 22 Feb 2022 10:06:03 +0800
Subject: Re: [PATCH net] net: vlan: allow vlan device MTU change follow real
 device from smaller to bigger
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <edumazet@google.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220221124644.1146105-1-william.xuanziyang@huawei.com>
 <CANn89iKyWWCbAdv8W26HwGpM9q5+6rrk9E-Lbd2aujFkD3GMaQ@mail.gmail.com>
 <YhQ1KrtpEr3TgCwA@gondor.apana.org.au>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <8248d662-8ea5-7937-6e34-5f1f8e19190f@huawei.com>
Date:   Tue, 22 Feb 2022 10:06:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YhQ1KrtpEr3TgCwA@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Feb 21, 2022 at 07:43:18AM -0800, Eric Dumazet wrote:
>>
>> Herbert, do you recall why only a decrease was taken into consideration ?
> 
> Because we shouldn't override administrative settings of the MTU
> on the vlan device, unless we have to because of an MTU reduction
> on the underlying device.
> 
> Yes this is not perfect if the admin never set an MTU to start with
> but as we don't have a way of telling whether the admin has or has
> not changed the MTU setting, the safest course of action is to do
> nothing in that case.
If the admin has changed the vlan device MTU smaller than the underlying
device MTU firstly, then changed the underlying device MTU smaller than
the vlan device MTU secondly. The admin's configuration has been overridden.
Can we consider that the admin's configuration for the vlan device MTU has
been invalid and disappeared after the second change? I think so.

> 
> Thanks,
> 
