Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3DD54B557
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356931AbiFNQGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354455AbiFNQGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:06:46 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85C93EB89
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:06:27 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id y69so12147690oia.7
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=X4xRWyF9vr8qnasqfhsd+VAGIzL+N4al4cfXIWCdc0g=;
        b=NLNTK/3yOlui/8PDUrYDNIdgpprrS90aWM+WjqJ+L2bMU+1Ozbmg2rD4fkMgfuWnpm
         aMGJEYfd5nogbWyMEV3d9AdrsFTbd/ai3JvhNvWmxQgkmSCNpEsOoNznE37pK/knJYQu
         8Aw2b9wKcBroceGAhUyVkpxk3cOL+KGNAnLUM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=X4xRWyF9vr8qnasqfhsd+VAGIzL+N4al4cfXIWCdc0g=;
        b=KbQisCdmFYRbiT/DYKwdd9toDvenas8u0gKVX8vnK4UorIALqwmHVw1RDfpUqdgSZQ
         MLpKCHjkZoGAbXvbW+hcaBmw6n+oMcApWlFQKliQWDT4yzoQojw8USpWKe9KzTxnS1Sk
         xSoPaBrTwgOMjzlpsq3X5YoUYKAqwtdhcWA6tYLZzBajkpEdueiw5IMhFcOXKhqkWh9m
         sn8CMYhlWWmT9f9hxWUVzFg6jB3AGJp7EyMSYt+8gSJmmcZQAAI87UdwQKi5ApFAY/1y
         8pME2jGpPd3RoRGX9S0mjd9m7765/iw7JLXfwLgJzqa2REOIcTplYplGsW4MhQD+9oPt
         Pwsg==
X-Gm-Message-State: AOAM533AsVAIe7pvRxAxs+eV3p4p6Nq1yU7yr9WXbSd1Ub6++ViPN/tM
        JjspquJIFJIvqBfhwtfK/yq2lw==
X-Google-Smtp-Source: ABdhPJz9B/kSdK+3GB7ULQc4BQgTDB3yrng0XI1+iE7DuZFwNplTTKpOWFeQG4wG0wSczvdmVlxS5A==
X-Received: by 2002:aca:3945:0:b0:32b:3a61:35d6 with SMTP id g66-20020aca3945000000b0032b3a6135d6mr2484880oia.293.1655222787108;
        Tue, 14 Jun 2022 09:06:27 -0700 (PDT)
Received: from [192.168.0.41] ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id d1-20020a0568301b6100b0060bec21ffcdsm4939272ote.22.2022.06.14.09.06.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 09:06:26 -0700 (PDT)
Message-ID: <859cb593-9e96-5846-2191-6613677b07c5@cloudflare.com>
Date:   Tue, 14 Jun 2022 11:06:24 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3] cred: Propagate security_prepare_creds() error code
Content-Language: en-US
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, selinux@vger.kernel.org,
        serge@hallyn.com, amir73il@gmail.com, kernel-team@cloudflare.com,
        Jeff Moyer <jmoyer@redhat.com>,
        Paul Moore <paul@paul-moore.com>
References: <20220608150942.776446-1-fred@cloudflare.com>
 <87tu8oze94.fsf@email.froward.int.ebiederm.org>
 <e1b62234-9b8a-e7c2-2946-5ef9f6f23a08@cloudflare.com>
 <87y1xzyhub.fsf@email.froward.int.ebiederm.org>
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <87y1xzyhub.fsf@email.froward.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/22 11:44 PM, Eric W. Biederman wrote:
> Frederick Lawler <fred@cloudflare.com> writes:
> 
>> Hi Eric,
>>
>> On 6/13/22 12:04 PM, Eric W. Biederman wrote:
>>> Frederick Lawler <fred@cloudflare.com> writes:
>>>
>>>> While experimenting with the security_prepare_creds() LSM hook, we
>>>> noticed that our EPERM error code was not propagated up the callstack.
>>>> Instead ENOMEM is always returned.  As a result, some tools may send a
>>>> confusing error message to the user:
>>>>
>>>> $ unshare -rU
>>>> unshare: unshare failed: Cannot allocate memory
>>>>
>>>> A user would think that the system didn't have enough memory, when
>>>> instead the action was denied.
>>>>
>>>> This problem occurs because prepare_creds() and prepare_kernel_cred()
>>>> return NULL when security_prepare_creds() returns an error code. Later,
>>>> functions calling prepare_creds() and prepare_kernel_cred() return
>>>> ENOMEM because they assume that a NULL meant there was no memory
>>>> allocated.
>>>>
>>>> Fix this by propagating an error code from security_prepare_creds() up
>>>> the callstack.
>>> Why would it make sense for security_prepare_creds to return an error
>>> code other than ENOMEM?
>>>   > That seems a bit of a violation of what that function is supposed to do
>>>
>>
>> The API allows LSM authors to decide what error code is returned from the
>> cred_prepare hook. security_task_alloc() is a similar hook, and has its return
>> code propagated.
> 
> It is not an api.  It is an implementation detail of the linux kernel.
> It is a set of convenient functions that do a job.
> 
> The general rule is we don't support cases without an in-tree user.  I
> don't see an in-tree user.
> 
>> I'm proposing we follow security_task_allocs() pattern, and add visibility for
>> failure cases in prepare_creds().
> 
> I am asking why we would want to.  Especially as it is not an API, and I
> don't see any good reason for anything but an -ENOMEM failure to be
> supported.
>
We're writing a LSM BPF policy, and not a new LSM. Our policy aims to 
solve unprivileged unshare, similar to Debian's patch [1]. We're in a 
position such that we can't use that patch because we can't block _all_ 
of our applications from performing an unshare. We prefer a granular 
approach. LSM BPF seems like a good choice.

Because LSM BPF exposes these hooks, we should probably treat them as an 
API. From that perspective, userspace expects unshare to return a EPERM 
when the call is denied permissions.

> Without an in-tree user that cares it is probably better to go the
> opposite direction and remove the possibility of return anything but
> memory allocation failure.  That will make it clearer to implementors
> that a general error code is not supported and this is not a location
> to implement policy, this is only a hook to allocate state for the LSM.
> 

That's a good point, and it's possible we're using the wrong hook for 
the policy. Do you know of other hooks we can look into?

>>> I have probably missed a very interesting discussion where that was
>>> mentioned but I don't see link to the discussion or anything explaining
>>> why we want to do that in this change.
>>>
>>
>> AFAIK, this is the start of the discussion.
> 
> You were on v3 and had an out of tree piece of code so I assumed someone
> had at least thought about why you want to implement policy in a piece
> of code whose only purpose is to allocate memory to store state.
> 

No worries.

> Eric
> 
> 
> 

Links:
1: 
https://sources.debian.org/patches/linux/3.16.56-1+deb8u1/debian/add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by-default.patch/
