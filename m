Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0F76F0B1A
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 19:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244243AbjD0RlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 13:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244351AbjD0RlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 13:41:19 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D944EF8;
        Thu, 27 Apr 2023 10:40:58 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-555d2b43a23so101790777b3.2;
        Thu, 27 Apr 2023 10:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682617258; x=1685209258;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4YiPlscKcsFpiAIVg/QnmX/Efo3gqXjg0Osgaqylhwg=;
        b=JQz16BzFR4nnFHk5Pa2pPodKSGzZ19hbsAurXVI9KEmuFf8ytmMU9iLwf7JIPsGAGH
         V22dOexPE38Pc9Dwfnm3MTigg8DpinHNOtZYcChaF5a+k32uYRVmdt60x3teUr+cnJW3
         AABAwGOveZT2GZCrEHI4oDLc8F7y8BWcNaGkizn2l+lbjTgvV+WhggOfLAx8g850gxya
         l6CRGjqBVT97SAof/vb9alwveBaG5vV3AVNPD9jGWb3kAWE78ifWDAKVisPLqE6Nv7+X
         W/SCfZNpxgYORSJee6O0CMmvrOPZNCAEP8FqcmbkuUIq6TK5c04sicAlL6IqBrr2Mn9q
         Oueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682617258; x=1685209258;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4YiPlscKcsFpiAIVg/QnmX/Efo3gqXjg0Osgaqylhwg=;
        b=N4idp+4BkBBv38tb9lBiiprxHLEkBomsGs5wtwagJEZC9Dqn/YIypbJdpRfHkM/tBs
         FD+WxRfrmD+FeAxWsdGT5fkOoNku5HP1FvXHZ8otYHeiS8rHi2z0ey7bQ+TKU4GFijiI
         irMjDlSGA0qrNZDJh1ec+9rGWkwpJyh4xhwRBJcHTyltXVacX/mfmcba3MO58JgIj/lN
         9J6jreFwOBn3Y6a63B58g7jaKtvnaZjn5dA4soFs3qN9O2bOYk96Hg3VR2eOJJ0xId4h
         /QgJA8LYJSFvzCbNBTp8AcZxPVRcJ5CZ4VHs5bFzqgYOWnmP6DscMUrCzddS3jcDVxj2
         E7FQ==
X-Gm-Message-State: AC+VfDySWE22H4G2CKmx12RWs3YXJZzCEWjBmtYMoG+GSigGldb55X3j
        gbiDTUCsyknHYW9QlA5spg4=
X-Google-Smtp-Source: ACHHUZ5c+S2ZdsL2LjiDk1VOZ+W7MfAcFL25cTJI7lA7YQYD24M6VE0Lr0C1tmKDiaH779KOhRm8rQ==
X-Received: by 2002:a0d:dec1:0:b0:54f:8b56:bb2 with SMTP id h184-20020a0ddec1000000b0054f8b560bb2mr1722145ywe.9.1682617257902;
        Thu, 27 Apr 2023 10:40:57 -0700 (PDT)
Received: from ?IPV6:2600:1700:6cf8:1240:81b0:ce95:be9e:c5c9? ([2600:1700:6cf8:1240:81b0:ce95:be9e:c5c9])
        by smtp.gmail.com with ESMTPSA id r2-20020a815d02000000b0054f97b52934sm4987285ywb.54.2023.04.27.10.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 10:40:57 -0700 (PDT)
Message-ID: <a6ca62a4-d7e6-cdae-b763-fa52ff26a14f@gmail.com>
Date:   Thu, 27 Apr 2023 10:40:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH bpf-next 2/5] net/smc: allow smc to negotiate protocols on
 policies
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        pabeni@redhat.com, song@kernel.org, sdf@google.com,
        haoluo@google.com, yhs@fb.com, edumazet@google.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        guwen@linux.alibaba.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
References: <1682501055-4736-1-git-send-email-alibuda@linux.alibaba.com>
 <1682501055-4736-3-git-send-email-alibuda@linux.alibaba.com>
 <8e1694ec-9acf-a4bd-4dd2-28a258e1436b@gmail.com>
 <a8555236-2bef-b0fb-d8a8-dde3058a2271@linux.alibaba.com>
From:   Kui-Feng Lee <sinquersw@gmail.com>
In-Reply-To: <a8555236-2bef-b0fb-d8a8-dde3058a2271@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/26/23 20:30, D. Wythe wrote:
> 
> Hi Lee,
> 
> 
> On 4/27/23 12:47 AM, Kui-Feng Lee wrote:
>>
>>
>> On 4/26/23 02:24, D. Wythe wrote:
>>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>> diff --git a/net/smc/bpf_smc.c b/net/smc/bpf_smc.c
>>> new file mode 100644
>>> index 0000000..0c0ec05
>>> --- /dev/null
>>> +++ b/net/smc/bpf_smc.c
>>> @@ -0,0 +1,201 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>> ... cut ...
> 
> Will fix it, Thanks.
> 
>>> +
>>> +/* register ops */
>>> +int smc_sock_register_negotiator_ops(struct smc_sock_negotiator_ops 
>>> *ops)
>>> +{
>>> +    int ret;
>>> +
>>> +    ret = smc_sock_validate_negotiator_ops(ops);
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    /* calt key by name hash */
>>> +    ops->key = jhash(ops->name, sizeof(ops->name), strlen(ops->name));
>>> +
>>> +    spin_lock(&smc_sock_negotiator_list_lock);
>>> +    if (smc_negotiator_ops_get_by_key(ops->key)) {
>>> +        pr_notice("smc: %s negotiator already registered\n", 
>>> ops->name);
>>> +        ret = -EEXIST;
>>> +    } else {
>>> +        list_add_tail_rcu(&ops->list, &smc_sock_negotiator_list);
>>> +    }
>>> +    spin_unlock(&smc_sock_negotiator_list_lock);
>>> +    return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(smc_sock_register_negotiator_ops);
>>
>> This and following functions are not specific to BPF, right?
>> I found you have more BPF specific code in this file in following
>> patches.  But, I feel these function should not in this file since
>> they are not BPF specific because file name "bpf_smc.c" hints.
> 
> Yes. Logically those functions are not suitable for being placed in 
> "bpf_smc.c".
> However, since SMC is compiled as modules by default, and currently
> struct ops needs to be built in, or specific symbols will not be found 
> during linking.
> 
> Of course, I can separate those this function in another new file, which 
> can also be built in.
> I may have to introduce a new KConfig likes SMC_NEGOTIATOR. But this 
> feature is  only effective
> when eBPF exists, so from the perspective of SMC, it would also be kind 
> of weird.
On the other hand, this feature is only effective when SMC exists.
Even without BPF, you still can implement a negotiator in a module.
Since you have exported these symbols, I suspect that you expect
negotiators in modules or builtin, right?  If I am wrong about exports,
perhaps you should stop exporting since they are used locally only.

> 
> But whatever, if you do think it's necessary, I can split it into two 
> files.
> 
> Besh wishes.
> D. Wythe
> 
> 
> 
