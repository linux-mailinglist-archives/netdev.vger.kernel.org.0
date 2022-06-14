Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C26054B9F9
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 21:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345455AbiFNTB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 15:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357198AbiFNTBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 15:01:11 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C66D64
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 11:59:13 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1011df6971aso11234342fac.1
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 11:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=P/zvL47bzMX9zv6R9Iu19Vam9aHyZ/GbOGpqtXAWqMc=;
        b=YbrS1rTCXkBCIbh142yEwubaBQ2XkSJH/0xKf0lf6tUumEJSdjOkNie1Nx61lojoXo
         7ghRJ4k9WRR4jECQ0Dr2ZPBq/WU7t6xV2yqW0HATlcT/2Yl8k5zRPz4Fct1kN9ZfM/ig
         wiY+zF/49Otr9jZ/sUBro5DEDVmoThVwMV6c4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P/zvL47bzMX9zv6R9Iu19Vam9aHyZ/GbOGpqtXAWqMc=;
        b=u6cxFd+EpVsrFXwRqD30iGsdvh6fqX81DJ+zp4OVNJeji1c/T4t6BOo9O7+fYkHwmp
         Ci6V3hSJgWxklDqxZhDpWBMAuS26nz4e8rrNfMWuUrHLYrunXr/g3xT3H6D9h5lbtpT5
         +p8Lf1qqd765V/4DYU6U5C1L2HcevGw0bo0mRE/gUMq/MT8Ns8NhA4DPIaEPjDmYQeV3
         hlq+/a//4BRbblfzNWhgFz7CTSGKgYupo0Rxry3eDC7DMVOrT3szIiiRH6rsBR0KWzLX
         4YH/yrdfZDEA6lehRWUgAxeExjLVmC+8tiQrqLpLMaB2E3mXK5Vs6DR1obzUr5TOWJRR
         CIaw==
X-Gm-Message-State: AJIora+gYyNyfe8ogMD1o7I53uSNj0mcWBMmd73PRjuCvk2b3iqLORfc
        6av/Ppbo/9ZFzt7VIRP+nnjCqw==
X-Google-Smtp-Source: AGRyM1ufL5MDqjvHIo4wa13zoHeLqce3gwGBqjZkT/cfGeJacNorGFZd87ZD1rOQxbOuCm8UywPhnQ==
X-Received: by 2002:a05:6870:c151:b0:fe:251b:804c with SMTP id g17-20020a056870c15100b000fe251b804cmr3187763oad.15.1655233152767;
        Tue, 14 Jun 2022 11:59:12 -0700 (PDT)
Received: from [192.168.0.41] ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id x64-20020acae043000000b0032ecb7370ffsm5017316oig.41.2022.06.14.11.59.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 11:59:10 -0700 (PDT)
Message-ID: <9ed91f15-420c-3db6-8b3b-85438b02bf97@cloudflare.com>
Date:   Tue, 14 Jun 2022 13:59:08 -0500
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
 <859cb593-9e96-5846-2191-6613677b07c5@cloudflare.com>
 <87o7yvxl4x.fsf@email.froward.int.ebiederm.org>
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <87o7yvxl4x.fsf@email.froward.int.ebiederm.org>
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

On 6/14/22 11:30 AM, Eric W. Biederman wrote:
> Frederick Lawler <fred@cloudflare.com> writes:
> 
>> On 6/13/22 11:44 PM, Eric W. Biederman wrote:
>>> Frederick Lawler <fred@cloudflare.com> writes:
>>>
>>>> Hi Eric,
>>>>
>>>> On 6/13/22 12:04 PM, Eric W. Biederman wrote:
>>>>> Frederick Lawler <fred@cloudflare.com> writes:
>>>>>
>>>>>> While experimenting with the security_prepare_creds() LSM hook, we
>>>>>> noticed that our EPERM error code was not propagated up the callstack.
>>>>>> Instead ENOMEM is always returned.  As a result, some tools may send a
>>>>>> confusing error message to the user:
>>>>>>
>>>>>> $ unshare -rU
>>>>>> unshare: unshare failed: Cannot allocate memory
>>>>>>
>>>>>> A user would think that the system didn't have enough memory, when
>>>>>> instead the action was denied.
>>>>>>
>>>>>> This problem occurs because prepare_creds() and prepare_kernel_cred()
>>>>>> return NULL when security_prepare_creds() returns an error code. Later,
>>>>>> functions calling prepare_creds() and prepare_kernel_cred() return
>>>>>> ENOMEM because they assume that a NULL meant there was no memory
>>>>>> allocated.
>>>>>>
>>>>>> Fix this by propagating an error code from security_prepare_creds() up
>>>>>> the callstack.
>>>>> Why would it make sense for security_prepare_creds to return an error
>>>>> code other than ENOMEM?
>>>>>    > That seems a bit of a violation of what that function is supposed to do
>>>>>
>>>>
>>>> The API allows LSM authors to decide what error code is returned from the
>>>> cred_prepare hook. security_task_alloc() is a similar hook, and has its return
>>>> code propagated.
>>> It is not an api.  It is an implementation detail of the linux kernel.
>>> It is a set of convenient functions that do a job.
>>> The general rule is we don't support cases without an in-tree user.  I
>>> don't see an in-tree user.
>>>
>>>> I'm proposing we follow security_task_allocs() pattern, and add visibility for
>>>> failure cases in prepare_creds().
>>> I am asking why we would want to.  Especially as it is not an API, and I
>>> don't see any good reason for anything but an -ENOMEM failure to be
>>> supported.
>>>
>> We're writing a LSM BPF policy, and not a new LSM. Our policy aims to solve
>> unprivileged unshare, similar to Debian's patch [1]. We're in a position such
>> that we can't use that patch because we can't block _all_ of our applications
>> from performing an unshare. We prefer a granular approach. LSM BPF seems like a
>> good choice.
> 
> I am quite puzzled why doesn't /proc/sys/user/max_user_namespaces work
> for you?
> 

We have the following requirements:

1. Allow list criteria
2. root user must be able to create namespaces whenever
3. Everything else not in 1 & 2 must be denied

We use per task attributes to determine whether or not we allow/deny the 
current call to unshare().

/proc/sys/user/max_user_namespaces limits are a bit broad for this level 
of detail.

>> Because LSM BPF exposes these hooks, we should probably treat them as an
>> API. From that perspective, userspace expects unshare to return a EPERM
>> when the call is denied permissions.
> 
> The BPF code gets to be treated as a out of tree kernel module.
> 
>>> Without an in-tree user that cares it is probably better to go the
>>> opposite direction and remove the possibility of return anything but
>>> memory allocation failure.  That will make it clearer to implementors
>>> that a general error code is not supported and this is not a location
>>> to implement policy, this is only a hook to allocate state for the LSM.
>>>
>>
>> That's a good point, and it's possible we're using the wrong hook for the
>> policy. Do you know of other hooks we can look into?
> 
> Not off the top of my head.
> 
>>>>> I have probably missed a very interesting discussion where that was
>>>>> mentioned but I don't see link to the discussion or anything explaining
>>>>> why we want to do that in this change.
>>>>>
>>>>
>>>> AFAIK, this is the start of the discussion.
>>> You were on v3 and had an out of tree piece of code so I assumed someone
>>> had at least thought about why you want to implement policy in a piece
>>> of code whose only purpose is to allocate memory to store state.
>>>
>>
>> No worries.
>>
>>> Eric
>>>
>>>
>>
>> Links:
>> 1:
>> https://sources.debian.org/patches/linux/3.16.56-1+deb8u1/debian/add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by-default.patch/
> 
> Eric

