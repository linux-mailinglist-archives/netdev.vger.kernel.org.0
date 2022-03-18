Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7DB4DD75B
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 10:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbiCRJve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 05:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbiCRJvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 05:51:33 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A4F11788C6;
        Fri, 18 Mar 2022 02:50:14 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:60254.308099466
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-10.133.11.244 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 9A0EE2800A3;
        Fri, 18 Mar 2022 17:50:06 +0800 (CST)
X-189-SAVE-TO-SEND: sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 45b732299e52413c94b77503edb2fa0c for dsahern@kernel.org;
        Fri, 18 Mar 2022 17:50:13 CST
X-Transaction-ID: 45b732299e52413c94b77503edb2fa0c
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
Message-ID: <eed6ba63-9e49-5351-215c-a70573e4c79a@chinatelecom.cn>
Date:   Fri, 18 Mar 2022 17:50:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4] net:bonding:Add support for IPV6 RLB to balance-alb
 mode
To:     David Ahern <dsahern@kernel.org>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, oliver@neukum.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn
References: <20220317061521.23985-1-sunshouxin@chinatelecom.cn>
 <eff0021c-5a9b-5c44-3fb7-24387cf13e16@kernel.org>
From:   =?UTF-8?B?5a2Z5a6I6ZGr?= <sunshouxin@chinatelecom.cn>
In-Reply-To: <eff0021c-5a9b-5c44-3fb7-24387cf13e16@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/18 2:49, David Ahern 写道:
> On 3/17/22 12:15 AM, Sun Shouxin wrote:
>> This patch is implementing IPV6 RLB for balance-alb mode.
>>
>> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
>> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
>> ---
>> changelog:
>> v1-->v2:
>> -Remove ndisc_bond_send_na and refactor ndisc_send_na.
>> -In rlb_nd_xmit, if the lladdr is not local, return curr_active_slave.
>> -Don't send neighbor advertisement message when receiving
>>   neighbor advertisement message in rlb6_update_entry_from_na.
>>
>> v2-->v3:
>> -Don't export ndisc_send_na.
>> -Use ipv6_stub->ndisc_send_na to replace ndisc_send_na
>>   in rlb6_update_client.
>>
>> v3-->v4:
>> -Submit all code at a whole patch.
> you misunderstood Jakub's comment. The code should evolve with small,
> focused patches and each patch needs to compile and function correctly
> (ie., no breakage).
>
> You need to respond to Jiri's question about why this feature is needed.
> After that:
>
> 1. patch 1 adds void *data to ndisc_send_na stub function and
> ndisc_send_na direct function. Update all places that use both
> ndisc_send_na to pass NULL as the data parameter.
>
> 2. patch 2 refactors ndisc_send_na to handle the new data argument
>
> 3. patch 3 exports any IPv6 functions. explain why each needs to be
> exported.
>
> 4. patch 4 .... bonding changes. (bonding folks can respond on how to
> introduce that change).


Thanks your warmly instruction for newbee, I'll resend soon.
Thanks again.


