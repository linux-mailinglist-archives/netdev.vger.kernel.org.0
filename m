Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5FB6BC34E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCPB34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjCPB3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:29:55 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D503C410B1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:29:54 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id s41so314677oiw.13
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678930194;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dksNuAcLmL0vyw2Uv7crzjxq0Bd1DvBnhus7x4gGyF8=;
        b=bdkMueClMNREaQqXoNM3HfBUjbCPbEaRKqNwPVkKZbSxYUrI+/Gy+UAlFauDRFqM6Q
         vm2r7ruzBNlVVKuwJqeQvN4aNKVF7PFEBnV7nni7jl8ert0Bl+95XMr/xbEfNpoTdOBz
         xJl3K0sC86JPfRJ0Q22qNbUADaH3kOqWwQ5udvoigIJc9t+uYAPyBtdezb56/mMHrSJZ
         DlAsv11KwXXoGmidAek7M+r/gZlvKFS8IEeqJuslDjC4jDtfrPmWmr3nR/C6OQdHCFbm
         Ov+sh/OuO41bv6Aa4tYNrkroJsZL550irk0LnarGQPlnolx+b3q6k/mCqFkMAl9O5DaE
         4xOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678930194;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dksNuAcLmL0vyw2Uv7crzjxq0Bd1DvBnhus7x4gGyF8=;
        b=efvqCm33ErkFqq7+4y0QVYMHbN9dH0/mS52PCifWgacGS4NtUN1I+HsbBewGT405pa
         gzYHY+WhZBOZaaEKz+pdIsD+VGR72nLN22sDQW3YcBw9FYgzPB/OeUJf3ResjqhcxJvn
         k0ECc9LOyzdMHzx/USyy+0UuOtFpIv+fqUcTQMBWep+RZw6i4vLQ4jTFPTsgm5P4FruJ
         dWn86Rtl1TpnpBDeE0JkdCDqyiRAHIacJkm0mElDHSdzk0PX2De3AzrFlaoamhJi5HJg
         +6ZK8JglFB1UOtJkLeM4M4uLOr81jyFoZjWhRWsrW4Ac/xcueIf/kvyqXWuDchYmLuPm
         onfg==
X-Gm-Message-State: AO0yUKUpR436D8OGnoyqxew7hosBZA2JaeKpLlytHqNDUCEHHziRI7aC
        p93NxFZY0bLdAJScADNoJTKDdA==
X-Google-Smtp-Source: AK7set9rMjdEYGlsSbYvzHNN7X5EXnGsL+BOG0dwxxkSx3buKQ5Mr8R+5JPjogITsXjI35uHamDlJQ==
X-Received: by 2002:a05:6808:1407:b0:386:a87b:ec3e with SMTP id w7-20020a056808140700b00386a87bec3emr1892765oiv.47.1678930194220;
        Wed, 15 Mar 2023 18:29:54 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:4698:379:3d0d:770:f7b1? ([2804:14d:5c5e:4698:379:3d0d:770:f7b1])
        by smtp.gmail.com with ESMTPSA id s9-20020a0568080b0900b003845f4991c7sm1264126oij.11.2023.03.15.18.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 18:29:53 -0700 (PDT)
Message-ID: <5d76595f-6af5-2a5a-e56f-ce81bb29dfaf@mojatatu.com>
Date:   Wed, 15 Mar 2023 22:29:49 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next] net/sched: act_api: use the correct TCA_ACT
 attributes in dump
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Hangbin Liu <haliu@redhat.com>
References: <20230314193321.554475-1-pctammela@mojatatu.com>
 <ZBGivb7ve9LThAX1@corigine.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <ZBGivb7ve9LThAX1@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2023 07:49, Simon Horman wrote:
> On Tue, Mar 14, 2023 at 04:33:21PM -0300, Pedro Tammela wrote:
>> 3 places in the act api code are using 'TCA_' definitions where they should be using
>> 'TCA_ACT_', which is confusing for the reader, although functionaly wise they are equivalent.
>>
>> Cc: Hangbin Liu <haliu@redhat.com>
>> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
>> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> 
> Hi Pedro,
> 
> this looks good, but should the instance of TCA_KIND in tcf_del_walker()
> also be updated?

Correct, I will add it in v2.
