Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189F555C7C5
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238715AbiF0PwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 11:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbiF0Pv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 11:51:59 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B820F193CB
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 08:51:51 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id u9so13336688oiv.12
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 08:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ACMt+3gd0WeWEO4zAvKHfGmdHNjeEgmzzRorzEO8OBw=;
        b=S7vVltqVFyPWDgkx3urxeq1fSYIanMWU4w04IcHnhHvCGKwOiPMCcyAoZ8OFeW4aH1
         B7o+UTCQwppWEWXf4LHepEqnFLG4WccrbFGj0fRvklp8EppWd/sYMtRZjCDcmK0cjs7H
         zItnJRRbfNHiPy5vEgpYSUuVqJ6exRelij9i4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ACMt+3gd0WeWEO4zAvKHfGmdHNjeEgmzzRorzEO8OBw=;
        b=0VQvsPrPNfzAtZflYUvwvwa0cjtmBCtWMKUI2BLN4p6WN6ONAdqkmb8hxEJqd5NsYW
         mvMx14KfqCnVR+qZc3iQQRtSqALeurPymLQuxC952/JvJo3purNGhLywDrFT8yuRLf8H
         W4KD3lfgBKDPENbDhL/lpvwGYLVKPVGXP9NFYu95aSRMGC8mtVrsKHjigzBylUGEcuuw
         5YZ+RpmsOcmOgtyixEJ/3gs90uofCCPsroh8koIshI8YZccg25CkNdm/4ii1fvEMu7pq
         Ig9WQaKBcem9656cfdygswMivypuT/uFwr/Y2Ol+tEkOIykr8cnImnE8hK+lp+vrLKBF
         /fPQ==
X-Gm-Message-State: AJIora8xWMiFNYCA7OwvWXKCsVtJohyp6vUIGW7quPMYOuTp3BxtNvGn
        WtvULMnVPC0BZLpwIw/xFLnEjw==
X-Google-Smtp-Source: AGRyM1uSg9BhGhCGEiFsNutZIatJeC/ZQ2GnuNnGjCpkQC5Pjilq3I5ke+gQ5cagxZwppjlJtdZF9g==
X-Received: by 2002:aca:170b:0:b0:335:6ee0:cd2a with SMTP id j11-20020aca170b000000b003356ee0cd2amr4067799oii.198.1656345110972;
        Mon, 27 Jun 2022 08:51:50 -0700 (PDT)
Received: from [192.168.0.41] ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id i1-20020a4addc1000000b0041b768b58basm6085091oov.22.2022.06.27.08.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 08:51:50 -0700 (PDT)
Message-ID: <b7c23d54-d196-98d1-8187-605f6d4dca4d@cloudflare.com>
Date:   Mon, 27 Jun 2022 10:51:48 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>,
        Paul Moore <paul@paul-moore.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
References: <20220621233939.993579-1-fred@cloudflare.com>
 <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
 <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com>
 <CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com>
 <20220627121137.cnmctlxxtcgzwrws@wittgenstein>
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <20220627121137.cnmctlxxtcgzwrws@wittgenstein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/27/22 7:11 AM, Christian Brauner wrote:
> On Thu, Jun 23, 2022 at 11:21:37PM -0400, Paul Moore wrote:
>> On Wed, Jun 22, 2022 at 10:24 AM Frederick Lawler <fred@cloudflare.com> wrote:
>>> On 6/21/22 7:19 PM, Casey Schaufler wrote:
>>>> On 6/21/2022 4:39 PM, Frederick Lawler wrote:
>>>>> While creating a LSM BPF MAC policy to block user namespace creation, we
>>>>> used the LSM cred_prepare hook because that is the closest hook to
>>>>> prevent
>>>>> a call to create_user_ns().
>>>>>
>>>>> The calls look something like this:
>>>>>
>>>>>       cred = prepare_creds()
>>>>>           security_prepare_creds()
>>>>>               call_int_hook(cred_prepare, ...
>>>>>       if (cred)
>>>>>           create_user_ns(cred)
>>>>>
>>>>> We noticed that error codes were not propagated from this hook and
>>>>> introduced a patch [1] to propagate those errors.
>>>>>
>>>>> The discussion notes that security_prepare_creds()
>>>>> is not appropriate for MAC policies, and instead the hook is
>>>>> meant for LSM authors to prepare credentials for mutation. [2]
>>>>>
>>>>> Ultimately, we concluded that a better course of action is to introduce
>>>>> a new security hook for LSM authors. [3]
>>>>>
>>>>> This patch set first introduces a new security_create_user_ns() function
>>>>> and create_user_ns LSM hook, then marks the hook as sleepable in BPF.
>>>>
>>>> Why restrict this hook to user namespaces? It seems that an LSM that
>>>> chooses to preform controls on user namespaces may want to do so for
>>>> network namespaces as well.
>>>
>>> IIRC, CLONE_NEWUSER is the only namespace flag that does not require
>>> CAP_SYS_ADMIN. There is a security use case to prevent this namespace
>>> from being created within an unprivileged environment. I'm not opposed
>>> to a more generic hook, but I don't currently have a use case to block
>>> any others. We can also say the same is true for the other namespaces:
>>> add this generic security function to these too.
>>>
>>> I'm curious what others think about this too.
>>
>> While user namespaces are obviously one of the more significant
>> namespaces from a security perspective, I do think it seems reasonable
>> that the LSMs could benefit from additional namespace creation hooks.
>> However, I don't think we need to do all of them at once, starting
>> with a userns hook seems okay to me.
>>
>> I also think that using the same LSM hook as an access control point
>> for all of the different namespaces would be a mistake.  At the very
> 
> Agreed. >
>> least we would need to pass a flag or some form of context to the hook
>> to indicate which new namespace(s) are being requested and I fear that
>> is a problem waiting to happen.  That isn't to say someone couldn't
>> mistakenly call the security_create_user_ns(...) from the mount
>> namespace code, but I suspect that is much easier to identify as wrong
>> than the equivalent security_create_ns(USER, ...).
> 
> Yeah, I think that's a pretty unlikely scenario.
> 
>>
>> We also should acknowledge that while in most cases the current task's
>> credentials are probably sufficient to make any LSM access control
>> decisions around namespace creation, it's possible that for some
>> namespaces we would need to pass additional, namespace specific info
>> to the LSM.  With a shared LSM hook this could become rather awkward.
> 
> Agreed.
> 
>>
>>>> Also, the hook seems backwards. You should
>>>> decide if the creation of the namespace is allowed before you create it.
>>>> Passing the new namespace to a function that checks to see creating a
>>>> namespace is allowed doesn't make a lot off sense.
>>>
>>> I think having more context to a security hook is a good thing.
>>
>> This is one of the reasons why I usually like to see at least one LSM
>> implementation to go along with every new/modified hook.  The
>> implementation forces you to think about what information is necessary
>> to perform a basic access control decision; sometimes it isn't always
>> obvious until you have to write the access control :)
> 
> I spoke to Frederick at length during LSS and as I've been given to
> understand there's a eBPF program that would immediately use this new
> hook. Now I don't want to get into the whole "Is the eBPF LSM hook
> infrastructure an LSM" but I think we can let this count as a legitimate
> first user of this hook/code.
> 
>>
>> [aside: If you would like to explore the SELinux implementation let me
>> know, I'm happy to work with you on this.  I suspect Casey and the
>> other LSM maintainers would also be willing to do the same for their
>> LSMs.]
>>

I can take a shot at making a SELinux implementation, but the question 
becomes: is that for v2 or a later patch? I don't think the 
implementation for SELinux would be too complicated (i.e. make a call to 
avc_has_perm()?) but, testing and revisions might take a bit longer.

>> In this particular case I think the calling task's credentials are
>> generally all that is needed.  You mention that the newly created
> 
> Agreed.
> 
>> namespace would be helpful, so I'll ask: what info in the new ns do
>> you believe would be helpful in making an access decision about its
>> creation?
>>

In the other thread [1], there was mention of xattr mapping support. As 
I understand Caseys response to this thread [2], that feature is no 
longer requested for this hook.

Users can still access the older parent ns from the passed in cred, but 
I was thinking of handling the transition point here. There's probably 
more suitable hooks for that case.


>> Once we've sorted that we can make a better decision about the hook
>> placement, but right now my gut feeling is that we only need to pass
>> the task's creds, and I think placing the hook right after the UID/GID
>> mapping check (before the new ns allocation) would be the best spot.
> 

I don't specifically have a use case to pass the new user namespace for 
this hook at this time. I'll move the hook in v2.

> When I toyed with this I placed it directly into create_user_ns() and
> only relied on the calling task's cred. I just created an eBPF program
> that verifies the caller is capable(CAP_SYS_ADMIN). Since both the
> chrooted and mapping check return EPERM it doesn't really matter that
> much where exactly. Conceptually it makes more sense to me to place it
> after the mapping check because then all the preliminaries are done.
> 

Agreed.

> Christian

Links:
1. 
https://lore.kernel.org/all/4ae12ee6-959c-51cb-9d7a-54adb3a0ea53@schaufler-ca.com/
2. 
https://lore.kernel.org/all/4b62f0c5-9f3c-e0bc-d836-1b7cdea429da@schaufler-ca.com/

