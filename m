Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774A6697DB5
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 14:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjBONnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 08:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjBONnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 08:43:06 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6417839CEA
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 05:42:42 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id y11-20020a05683009cb00b0068dbf908574so5675615ott.8
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 05:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k0XYXu1XitU/zm/0zdqiavr6qNzupzyrrDn2PE0nimo=;
        b=ZP+LOiiNWMN6TH+vHsZ4Qz104ZRMpi9Ns+2Rx+0iqKsSDmzmgLo3gryERyCc1+VTPS
         WYtcTdTduKr6C2Z00Cqv9UdxH/slPJH0T2PK48q02AiwmhobIZui5oIBNx51L+aPoJnI
         jCxs03MaTEC5YxzlnIrclTlXZF1nqfUrI/CJAjxwkfRPYSs/yb4ZMYMmCN9IPQn6XN4B
         0LeYIYVODYZy0LCupqwKdfPo/DeWy7kTCpMnAJwuoVJi98/fQh2GDfQRYFObCLzXoc+Y
         SDJRWCRxoVZXT6wsnMa7BQ9KjO3xXOsjKZ+THnOVAFD6MYhcoCbMzqR+qxcHuNYyS35g
         ce3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k0XYXu1XitU/zm/0zdqiavr6qNzupzyrrDn2PE0nimo=;
        b=W17MzLBgwD4Eg/kBkR1pZmPZcbbcHC/MYJxZunxyIAu3ABwK/AJ3TIoogFVeiRU3C6
         7rQyLt602omE6WDzTEyScNaV1cBaKdbg6oqUVfHz/ydH9ZQjK62LGMEQpP5aGX5tNyRR
         lPTi/xULNd7eOX5xeaadDVNTH2eAms8m8/Q54VdjlVKL+lXAcPSqN3IDdH1fITqljLJ9
         2p9LYf7g/tzktRKre4FBXPqlwNpGPmnR+dT83/nPgUWCzqeotPDY42ioT0eKawcNLitj
         TQImCM9WquWsDnHThshGUlCL1kztWnE1nhaKorw7Qy2BoLasomTYfOsBqu/Zi92nW+CE
         SAGw==
X-Gm-Message-State: AO0yUKXUAFbSae/LVHRub4vaMf/bIsol8ia5t3xryGxCgP1it1LVzOuo
        4x3xBDVNwHkVd6yD8vjsUs9IQw==
X-Google-Smtp-Source: AK7set9SAr/k6k3/vyojItZ62UWfI7tSWOzk3AJjYVr3PNhInH7+gFCMs08mXvFSl91G7ztUMAIc7Q==
X-Received: by 2002:a9d:7dd5:0:b0:68f:24f4:6247 with SMTP id k21-20020a9d7dd5000000b0068f24f46247mr918279otn.34.1676468561342;
        Wed, 15 Feb 2023 05:42:41 -0800 (PST)
Received: from ?IPV6:2804:14d:5c5e:4698:5993:7db7:8aad:e28d? ([2804:14d:5c5e:4698:5993:7db7:8aad:e28d])
        by smtp.gmail.com with ESMTPSA id p16-20020a056830131000b0068bbaf7a1b0sm7434575otq.34.2023.02.15.05.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 05:42:40 -0800 (PST)
Message-ID: <4bb0d7d2-1793-ef57-bebc-11b4867ac158@mojatatu.com>
Date:   Wed, 15 Feb 2023 10:42:36 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 0/5] net/sched: Retire some tc qdiscs and
 classifiers
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, stephen@networkplumber.org, dsahern@gmail.com
References: <20230214134915.199004-1-jhs@mojatatu.com>
 <Y+uZ5LLX8HugO/5+@nanopsycho> <20230214134013.0ad390dd@kernel.org>
 <20230214134101.702e9cdf@kernel.org>
 <CAM0EoM=gOFgSufjrX=+Qwe6x9KN=PkBaDLBZqxeKDktCy=R=sw@mail.gmail.com>
 <Y+yOsYSRSZV1kwpq@nanopsycho>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <Y+yOsYSRSZV1kwpq@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/02/2023 04:50, Jiri Pirko wrote:
> Wed, Feb 15, 2023 at 12:05:23AM CET, jhs@mojatatu.com wrote:
>> On Tue, Feb 14, 2023 at 4:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>>
>>> On Tue, 14 Feb 2023 13:40:13 -0800 Jakub Kicinski wrote:
>>>>> I think we have to let the UAPI there to rot in order not to break
>>>>> compilation of apps that use those (no relation to iproute2).
>>>>
>>>> Yeah, I was hoping there's no other users but this is the first match
>>>> on GitHub:
>>>>
>>>> https://github.com/t2mune/nield/blob/0c0848d1d1e6c006185465ee96aeb5a13a1589e6/src/tcmsg_qdisc_dsmark.c
>>>>
>>>> :(
>>>
>>> I mean that in the context of deleting the uAPI, not the support,
>>> to be clear.
>>
>> Looking at that code - the user is keeping their own copy of the uapi
>> and listening to generated events from the kernel.
>> With new kernels those events will never come, so they wont be able to
>> print them. IOW, there's no dependency on the uapi being in the kernel
>> - but maybe worth keeping.
>> Note, even if they were to send queries - they will just get a failure back.
> 
> Guys. I don't think that matters. There might be some non-public code
> using this headers and we don't want to break them either. I believe we
> have to stick with it. But perhaps we can include some note there.
> 

I don't know the compilation requirements for uapi, but it could 
leverage the deprecated attribute, when available as a compiler 
extension (it's queued for C23 as well[0]).

E.g. https://godbolt.org/z/d535jh9j8

Essentially anytime someone uses one of the Netlink attributes they will 
get a harmless warning like:
<source>:22:18: warning: 'TCA_TCINDEX_CLASSID' is deprecated 
[-Wdeprecated-declarations]

[0] https://en.cppreference.com/w/c/language/attributes/deprecated

