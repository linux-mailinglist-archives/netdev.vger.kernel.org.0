Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EB25628AD
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 04:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiGACDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 22:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGACDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 22:03:22 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD5F175A0;
        Thu, 30 Jun 2022 19:03:19 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VHvCiPi_1656640996;
Received: from 30.43.104.202(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0VHvCiPi_1656640996)
          by smtp.aliyun-inc.com;
          Fri, 01 Jul 2022 10:03:17 +0800
Message-ID: <3e801eb5-6305-aa87-43a6-98f591d7d55c@linux.alibaba.com>
Date:   Fri, 1 Jul 2022 10:03:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2] net/smc: align the connect behaviour with TCP
Content-Language: en-US
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     davem@davemloft.net, Karsten Graul <kgraul@linux.ibm.com>,
        liuyacan@corp.netease.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
References: <26d43c65-1f23-5b83-6377-3327854387c4@linux.ibm.com>
 <20220524125725.951315-1-liuyacan@corp.netease.com>
 <3bb9366d-f271-a603-a280-b70ae2d59c00@linux.ibm.com>
 <8a15e288-4534-501c-8b3d-c235ae93238f@linux.ibm.com>
 <d2195919-1cae-b667-c137-8398848fa43b@linux.alibaba.com>
 <fcac3b0c-db51-7221-d41a-0207144f131c@linux.ibm.com>
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
In-Reply-To: <fcac3b0c-db51-7221-d41a-0207144f131c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/7/1 04:16, Wenjia Zhang wrote:
> 
> 
> On 30.06.22 16:29, Guangguan Wang wrote:
>> I'm so sorry I missed the last emails for this discussion.
>>
>> Yes, commit (86434744) is the trigger of the problem described in
>> https://lore.kernel.org/linux-s390/45a19f8b-1b64-3459-c28c-aebab4fd8f1e@linux.alibaba.com/#t  .
>>
>> And I have tested just remove the following lines from smc_connection() can solve the above problem.
>> if (smc->use_fallback)
>>       goto out;
>>
>> I aggree that partly reverting the commit (86434744) is a better solution.
>>
>> Thanks,
>> Guangguan Wang
> Thank you for your effort!
> Would you like to revert this patch? We'll revert the commit (86434744) partly.

Did you mean revert commit (3aba1030)?
Sorry, I think I led to a misunderstanding. I mean commit (86434744) is the trigger of the problem I replied
in email https://lore.kernel.org/linux-s390/45a19f8b-1b64-3459-c28c-aebab4fd8f1e@linux.alibaba.com/#t, not 
the problem that commit (3aba1030) resolved for.

So I think the final solution is to remove the following lines from smc_connection() based on the current code.
if (smc->use_fallback) {
	sock->state = rc ? SS_CONNECTING : SS_CONNECTED;
	goto out;
}

Thanks,
Guangguan Wang
