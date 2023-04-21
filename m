Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DA56EAECC
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 18:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjDUQKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 12:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjDUQKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 12:10:15 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988338A43
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:10:14 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-187b70ab997so11895130fac.0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682093414; x=1684685414;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NBePyn25viGDoOG5HrFxceJj5wNKi3/RVmmeBJcbiso=;
        b=miiYjKc69DXPqucFdhTiOD6lfcGyUt42oVU0tgyRpVtZ26kvgIHzkM42Znc9fGz5cN
         YlViVxb13QHSnUfCc1cjRQ2yiQcZQSRPh//1CWS5XNCGVcutkTofFD1LWSq1G3rMefgX
         o9ZOaeFSIp0gq3jk6Wt3upct9gEqtOpxzP98swo5Q3f7MlkiAIiF5bZWu/3yn8dyRP1l
         RaRrf1yr7cHRSsKhfWRYS8tqo/xBZc3LwAGOYjhiYHSA+fCgLvBUv+iBduwKpkKGtzjN
         YOnfREo3wt1T+02XkIRqf6lvJ5KAUkUyHYtXwP8eeJe069ZH3FaCjkHJXSRminWN9/1o
         wFjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682093414; x=1684685414;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NBePyn25viGDoOG5HrFxceJj5wNKi3/RVmmeBJcbiso=;
        b=BWVQFD/8i4gWHpBPQbfFJIDwRGTlx0DVHCd/i8G8wNWgdkbfHtljKaKMc9+knJwpCG
         uqpyvDs6buXnMgoh/nyvXn12J8VJZ9UeawKkUZR+C1kwAXA7D4VT0zro6wPhSAtqUytn
         lPJANdIx2M0/7yzIAjO9QJWLLc3Ec87YEYk8Wvh248UaUVVSC+TzeFy0ioEFbm5xqxLQ
         m0p7olCSrtTTRQnrq79I8Xuog7CQQnMTv3xt4DtUCm3ySBxLWT1nDNPlHaMaag8AGBFW
         Jcerg4FpdSI9By/sLkdFOLpqP8fSSTb4xJPsHW7o7fwSAvJcQQUpAG8eNRKpqHlYWNsr
         odXQ==
X-Gm-Message-State: AAQBX9dCqYFo+U/739WXbEXo0eJBjbyVMoc77veumlh/P1X97CVWdFMz
        Jkv4vCOtS/Qx1qG+XOuGfB7bWw==
X-Google-Smtp-Source: AKy350apsTa6nhP7QRHQPWafXjVeuPjZxXID2kLuy+vUfX/QvBOGzTwrzMnF3E8UxU5w3hXBoZ26Aw==
X-Received: by 2002:a05:6830:448:b0:693:d7bf:dc26 with SMTP id d8-20020a056830044800b00693d7bfdc26mr3781666otc.6.1682093413826;
        Fri, 21 Apr 2023 09:10:13 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:7380:c348:a30c:7e82? ([2804:14d:5c5e:44fb:7380:c348:a30c:7e82])
        by smtp.gmail.com with ESMTPSA id g7-20020a9d6c47000000b006a64043ed69sm288232otq.56.2023.04.21.09.10.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 09:10:13 -0700 (PDT)
Message-ID: <e730e848-22e7-cd01-e6d5-b428acb434f6@mojatatu.com>
Date:   Fri, 21 Apr 2023 13:10:09 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v4 3/5] net/sched: act_pedit: check static
 offsets a priori
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, simon.horman@corigine.com
References: <20230418234354.582693-1-pctammela@mojatatu.com>
 <20230418234354.582693-4-pctammela@mojatatu.com>
 <20230420194134.1b2b4fc8@kernel.org>
 <6297e31c-2f0b-a364-ca5c-d5d02b640466@mojatatu.com>
 <20230421081536.656febc3@kernel.org>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230421081536.656febc3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/04/2023 12:15, Jakub Kicinski wrote:
> On Fri, 21 Apr 2023 12:12:54 -0300 Pedro Tammela wrote:
>> On 20/04/2023 23:41, Jakub Kicinski wrote:
>>> On Tue, 18 Apr 2023 20:43:52 -0300 Pedro Tammela wrote:
>>>> @@ -414,12 +420,12 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
>>>>    					       sizeof(_d), &_d);
>>>>    			if (!d)
>>>>    				goto bad;
>>>> -			offset += (*d & tkey->offmask) >> tkey->shift;
>>>> -		}
>>>>    
>>>> -		if (offset % 4) {
>>>> -			pr_info("tc action pedit offset must be on 32 bit boundaries\n");
>>>> -			goto bad;
>>>> +			offset += (*d & tkey->offmask) >> tkey->shift;
>>>
>>> this line loads part of the offset from packet data, so it's not
>>> exactly equivalent to the init time check.
>>
>> The code uses 'tkey->offmask' as a check for static offsets vs packet
>> derived offsets, which have different handling.
>> By checking the static offsets at init we can move the datapath
>> 'offset % 4' check for the packet derived offsets only.
>>
>> Note that this change only affects the offsets defined in 'tkey->off',
>> the 'at' offset logic stays the same.
>> My intention was to keep the code semantically the same.
>> Did I miss anything?
> 
> You are now erroring out if the static offset is not divisible by 4,
> and technically it was possible to construct a case where that'd work
> previously - if static offset was 2 and we load another 2 from the
> packet, no?
> 

True!

It seems though that the iproute2 packing broke this feature:
tc action add action pedit ex munge offset 2 u16 at 128 ff 0 clear

offset will be rounded down to 0 in iproute2, so if in the datapath at 
128 sums 2, it will fail the offset check since 2 % 4 != 0.

Let me check with Jamal what he thinks about this change since netlink 
could do it still.
This slipped under our radar, thanks for catching it!

> If so it needs to be mentioned in the commit msg.

