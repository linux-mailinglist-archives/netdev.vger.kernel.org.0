Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D6063A230
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 08:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiK1HkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 02:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiK1Hju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 02:39:50 -0500
Received: from out199-7.us.a.mail.aliyun.com (out199-7.us.a.mail.aliyun.com [47.90.199.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F9315807;
        Sun, 27 Nov 2022 23:39:43 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VVqYS-k_1669621178;
Received: from 30.27.90.133(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VVqYS-k_1669621178)
          by smtp.aliyun-inc.com;
          Mon, 28 Nov 2022 15:39:40 +0800
Message-ID: <aa008510-2c12-03ba-cd61-1ad450c43588@linux.alibaba.com>
Date:   Mon, 28 Nov 2022 15:39:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH] selftests/tls: Fix tls selftests dependency to correct
 algorithm
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221125121905.88292-1-tianjia.zhang@linux.alibaba.com>
 <Y4NVcV1D/MhFJpOc@Laptop-X1>
 <4f84f23e-2835-c1b7-93f5-2730ec8b94fc@linux.alibaba.com>
 <Y4RiaNlXlaHK55Ih@Laptop-X1>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <Y4RiaNlXlaHK55Ih@Laptop-X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/28/22 3:25 PM, Hangbin Liu wrote:
> On Mon, Nov 28, 2022 at 03:14:16PM +0800, Tianjia Zhang wrote:
>> Hi Hangbin,
>>
>> On 11/27/22 8:17 PM, Hangbin Liu wrote:
>>> On Fri, Nov 25, 2022 at 08:19:05PM +0800, Tianjia Zhang wrote:
>>>> Commit d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory") moves
>>>> the SM3 and SM4 stand-alone library and the algorithm implementation for
>>>> the Crypto API into the same directory, and the corresponding relationship
>>>> of Kconfig is modified, CONFIG_CRYPTO_SM3/4 corresponds to the stand-alone
>>>> library of SM3/4, and CONFIG_CRYPTO_SM3/4_GENERIC corresponds to the
>>>> algorithm implementation for the Crypto API. Therefore, it is necessary
>>>> for this module to depend on the correct algorithm.
>>>>
>>>> Fixes: d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory")
>>>> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
>>>> Cc: stable@vger.kernel.org # v5.19+
>>>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>>>> ---
>>>>    tools/testing/selftests/net/config | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
>>>> index ead7963b9bf0..bd89198cd817 100644
>>>> --- a/tools/testing/selftests/net/config
>>>> +++ b/tools/testing/selftests/net/config
>>>> @@ -43,5 +43,5 @@ CONFIG_NET_ACT_TUNNEL_KEY=m
>>>>    CONFIG_NET_ACT_MIRRED=m
>>>>    CONFIG_BAREUDP=m
>>>>    CONFIG_IPV6_IOAM6_LWTUNNEL=y
>>>> -CONFIG_CRYPTO_SM4=y
>>>> +CONFIG_CRYPTO_SM4_GENERIC=y
>>>>    CONFIG_AMT=m
>>>> -- 
>>>> 2.24.3 (Apple Git-128)
>>>>
>>>
>>> Looks the issue in this discuss
>>> https://lore.kernel.org/netdev/Y3c9zMbKsR+tcLHk@Laptop-X1/
>>> related to your fix.
>>>
>>
>> Thanks for your information, it is indeed the same issue.I don’t know if
>> there is a patch to fix it. If not, can this patch solve this issue? If
>> so, can I add Reported-by or Tested-by tag?
>>
> 
> Feel free to add Reported-by flag. I can't test this unless the patch merged
> to upstream.
> 

Thanks, I will send a v2 patch as soon as possible.

Tianjia
