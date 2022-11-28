Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FA463A1C4
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 08:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiK1HIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 02:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiK1HIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 02:08:09 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857EEBF6D;
        Sun, 27 Nov 2022 23:08:06 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VVqYIHI_1669619281;
Received: from 30.27.90.133(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VVqYIHI_1669619281)
          by smtp.aliyun-inc.com;
          Mon, 28 Nov 2022 15:08:03 +0800
Message-ID: <b7c327e8-63a7-20a5-dc33-9ba7df1efe4f@linux.alibaba.com>
Date:   Mon, 28 Nov 2022 15:08:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH] selftests/tls: Fix tls selftests dependency to correct
 algorithm
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221125121905.88292-1-tianjia.zhang@linux.alibaba.com>
 <Y4DAosu+ahAWpqrr@debian.me>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <Y4DAosu+ahAWpqrr@debian.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bagas,

On 11/25/22 9:18 PM, Bagas Sanjaya wrote:
> On Fri, Nov 25, 2022 at 08:19:05PM +0800, Tianjia Zhang wrote:
>> Commit d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory") moves
>> the SM3 and SM4 stand-alone library and the algorithm implementation for
>> the Crypto API into the same directory, and the corresponding relationship
>> of Kconfig is modified, CONFIG_CRYPTO_SM3/4 corresponds to the stand-alone
>> library of SM3/4, and CONFIG_CRYPTO_SM3/4_GENERIC corresponds to the
>> algorithm implementation for the Crypto API. Therefore, it is necessary
>> for this module to depend on the correct algorithm.
>>
> 
> I feel a rather confused. What about below?
> 
> ```
> Commit <commit> moves SM3 and SM4 algorithm implementations from
> stand-alone library to crypto API. The corresponding configuration
> options for the API version (generic) are CONFIG_CRYPTO_SM3_GENERIC and
> CONFIG_CRYPTO_SM4_GENERIC, respectively.
> 
> Replace option selected in selftests configuration from the library version
> to the API version.
> ```
> 

Thanks, this is great, I will pick it up.

>> Fixes: d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory")
>> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
>> Cc: stable@vger.kernel.org # v5.19+
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> ---
>>   tools/testing/selftests/net/config | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
>> index ead7963b9bf0..bd89198cd817 100644
>> --- a/tools/testing/selftests/net/config
>> +++ b/tools/testing/selftests/net/config
>> @@ -43,5 +43,5 @@ CONFIG_NET_ACT_TUNNEL_KEY=m
>>   CONFIG_NET_ACT_MIRRED=m
>>   CONFIG_BAREUDP=m
>>   CONFIG_IPV6_IOAM6_LWTUNNEL=y
>> -CONFIG_CRYPTO_SM4=y
>> +CONFIG_CRYPTO_SM4_GENERIC=y
>>   CONFIG_AMT=m
> 
> You mean the correct algo option is CONFIG_CRYPTO_SM4_GENERIC, right?
> 

Yes, CONFIG_CRYPTO_SM4_GENERIC is the correct algo option.

Best regards,
Tianjia
