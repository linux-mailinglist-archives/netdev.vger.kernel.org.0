Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996DF6EACFB
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbjDUOcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjDUOce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:32:34 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AC314449
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:32:01 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id 006d021491bc7-547303fccefso1640035eaf.3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682087520; x=1684679520;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v9rhLNghVmxPqeq/HSFt816S91MIyibhWElNZOICunQ=;
        b=4tLqZh/YWMchsZ87aHeqJnFJlt+n4okm5TFuLOaj+GhgWy4JIxg6U+WzRNf7sgM3qR
         2uUi0cIYaAcH1tDlg3pxLnJND0beyL9KnUlgbt7X2QTPI2ToIg2ksY1cX58e+1j31hGZ
         tj6GYSLN+gl4dAZI4I2cjH+ZOGnW/dTJ6kZgyYvuA4QcLXdVUGFeAAl9wDcPeYCzUKXA
         LvMGGm7wR/vLSeufj4N+vFi6bXLz/lVzPTOEedrCXSVYex1scVgBYcYjM+KH9DcU2boD
         g/9uqFysaJhPKWClE8sN1q61RvCWRLdb5EoW4E/2DkAagkNX6iAzzWVihD+EdOt9walk
         YqVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087520; x=1684679520;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v9rhLNghVmxPqeq/HSFt816S91MIyibhWElNZOICunQ=;
        b=BTkpa7gDn9NY/PoB/YY5xO7FzNyLToLfis4ILeRAfiftnXfkhVbAUYTccF3/kGCzpG
         /eTgd+6L8u5hd7djXu3iSqP6S2ThRYHcaeSRfna5mLesZJEwZI18ljoMdfVUdxt4DyDW
         pkC3pmF4LRSfmMkSdIzxQ+LfZ5aqT1wB6F4UznR07KpHumB7az8YAIdCaRhzSyh1iETY
         cJBzMyYkLXLyFyQD4V0hGAw5SvUpqH0rYRPmIA3OvevbE4xApzU68DZ3Zghyp0OSsz/5
         ezePb4DeXd6u4igTt6FN01s/vTOaWuPMn1IOxe1T1/P7MrWM1QVdjYCnqoN7+SGhBSsd
         jNgQ==
X-Gm-Message-State: AAQBX9fRlqa4kC3R+p2A/ZuYwWj7XbJDeF0HYzFJgmD279qc9pQP2g0F
        J9saylCSevwtNpTN1+blYhBquA==
X-Google-Smtp-Source: AKy350a0ep3e+NCmkPCl5hxir4zHqtlmWV1AXQK2TX7l5Byjyu9d9i41xPLrpee6appHdgg2CIGsNA==
X-Received: by 2002:a4a:e910:0:b0:541:fc88:3aac with SMTP id bx16-20020a4ae910000000b00541fc883aacmr1372789oob.5.1682087520555;
        Fri, 21 Apr 2023 07:32:00 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:7380:c348:a30c:7e82? ([2804:14d:5c5e:44fb:7380:c348:a30c:7e82])
        by smtp.gmail.com with ESMTPSA id i20-20020a4a8d94000000b0052a77e38722sm1796315ook.26.2023.04.21.07.31.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 07:32:00 -0700 (PDT)
Message-ID: <5785632a-b112-ad84-6355-2febe52f375a@mojatatu.com>
Date:   Fri, 21 Apr 2023 11:31:56 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v3 5/5] net/sched: sch_qfq: BITify two bound
 definitions
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
References: <20230420164928.237235-1-pctammela@mojatatu.com>
 <20230420164928.237235-6-pctammela@mojatatu.com>
 <CANn89iJsn1Xj8Y4tL69FA5a0y21R4-qBjMddH5rGOBD_iQ0qmw@mail.gmail.com>
 <ZEJXzN5FtXMUioFF@corigine.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <ZEJXzN5FtXMUioFF@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/04/2023 06:30, Simon Horman wrote:
> On Fri, Apr 21, 2023 at 11:17:23AM +0200, Eric Dumazet wrote:
>> On Thu, Apr 20, 2023 at 6:50 PM Pedro Tammela <pctammela@mojatatu.com> wrote:
>>>
>>> For the sake of readability, change these two definitions to BIT()
>>> macros.
>>>
>>> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
>>> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
>>> ---
>>>   net/sched/sch_qfq.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
>>> index dfd9a99e6257..4b9cc8a46e2a 100644
>>> --- a/net/sched/sch_qfq.c
>>> +++ b/net/sched/sch_qfq.c
>>> @@ -105,7 +105,7 @@
>>>   #define QFQ_MAX_INDEX          24
>>>   #define QFQ_MAX_WSHIFT         10
>>>
>>> -#define        QFQ_MAX_WEIGHT          (1<<QFQ_MAX_WSHIFT) /* see qfq_slot_insert */
>>> +#define        QFQ_MAX_WEIGHT          BIT(QFQ_MAX_WSHIFT) /* see qfq_slot_insert */
>>
>> I am not sure I find BIT(X) more readable in this context.
>>
>> Say MAX_WEIGHT was 0xF000, should we then use
>>
>> #define MAX_WEIGHT (BIT(15) | BIT(14) |BIT(13) | BIT(12))
> 
> Thanks Eric,
> 
> I think this is my mistake for suggesting this change.
> I agree BIT() is not so good here after all.

Fair enough,
Will remove it and repost.
Thanks for the reviews.
