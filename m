Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287F257A7E1
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbiGSUAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239930AbiGSUAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:00:03 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01E75FAFD
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 12:59:47 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-10bd4812c29so33387218fac.11
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 12:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aGGVmINUCSfsk250AOJFB90sOOysp1l6u1HPvFdfWvo=;
        b=ByN/WIZ20Mym344bNDca0YyD6ieOFhDy2+cjjAn7+bgOD4umhohA8AY6fW8GUKxF/E
         JXtuTSxOeVL8xaQ92eweEBfjCUimNWVPS3L/6yTzIK1dwKqcDg1CRZXgYE92y009O6k5
         MPHJi4Y6gMZzc4PyDtZlv3BdZ5+mVVA+yx4hc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aGGVmINUCSfsk250AOJFB90sOOysp1l6u1HPvFdfWvo=;
        b=m/4gfeo45R1LSVeqX6qbqeqUMVF8+cotyQikJM8hFr38FGRftK7eklWSEhaoeTDoUg
         hwMMwQDDSiivtI9m2GbFzma2pK6Lx8Q5A5Vl9J3wSulVWw1G3bBG0v5Svk1aXWFD+SbZ
         trtq6pCEVB+3+MGp1IhCP4ct4Gnl9SVGzr8J2pxwD+d8OX9WIZXb/cMsGo8N8d3gfjKp
         QTuGB5r0oCN//GFNZWyqA5GRbF+jnYTrxZC2F7TZFr6nr9ucP4AL+82IPMUxiRrEXgSU
         e+T/H6zh+F830HQt1AJaWEpaBPOVmeiK6P+4v7+1duo1xZOJwWGGtsUbfDhOi9fe+5KK
         Vgzw==
X-Gm-Message-State: AJIora/qm6fyjjmKBqUPwWymPXkaXOXbvvFkDPbVDQaKnEHJMrrQfD6k
        368nLrafI5SHEfmFwrlTY6qTGg==
X-Google-Smtp-Source: AGRyM1vz38JlwdypV+2Kw3t+SJQfxVmBJbWv7CQJcjGO2llN++Gpadp4l+cZxasrvtmR2oIYwSNQ9g==
X-Received: by 2002:a05:6870:2195:b0:10d:596:40c3 with SMTP id l21-20020a056870219500b0010d059640c3mr654876oae.228.1658260787018;
        Tue, 19 Jul 2022 12:59:47 -0700 (PDT)
Received: from [192.168.0.41] ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id h24-20020a9d6418000000b00618ecbca69asm6504625otl.74.2022.07.19.12.59.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 12:59:46 -0700 (PDT)
Message-ID: <305d165d-0a29-390c-f424-284333c78c38@cloudflare.com>
Date:   Tue, 19 Jul 2022 14:59:44 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 0/4] Introduce security_create_user_ns()
Content-Language: en-US
To:     "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     =?UTF-8?Q?Christian_G=c3=b6ttsche?= <cgzones@googlemail.com>,
        KP Singh <kpsingh@kernel.org>, revest@chromium.org,
        jackmanb@chromium.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, shuah@kernel.org,
        Christian Brauner <brauner@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        SElinux list <selinux@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, kernel-team@cloudflare.com
References: <20220707223228.1940249-1-fred@cloudflare.com>
 <CAJ2a_DezgSpc28jvJuU_stT7V7et-gD7qjy409oy=ZFaUxJneg@mail.gmail.com>
 <3dbd5b30-f869-b284-1383-309ca6994557@cloudflare.com>
 <84fbd508-65da-1930-9ed3-f53f16679043@schaufler-ca.com>
 <20220714142740.GA10621@mail.hallyn.com>
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <20220714142740.GA10621@mail.hallyn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/22 9:27 AM, Serge E. Hallyn wrote:
> On Fri, Jul 08, 2022 at 09:11:15AM -0700, Casey Schaufler wrote:
>> On 7/8/2022 7:01 AM, Frederick Lawler wrote:
>>> On 7/8/22 7:10 AM, Christian Göttsche wrote:
>>>> ,On Fri, 8 Jul 2022 at 00:32, Frederick Lawler <fred@cloudflare.com>
>>>> wrote:
>>>>>
>>>>> While creating a LSM BPF MAC policy to block user namespace
>>>>> creation, we
>>>>> used the LSM cred_prepare hook because that is the closest hook to
>>>>> prevent
>>>>> a call to create_user_ns().
>>>>>
>>>>> The calls look something like this:
>>>>>
>>>>>       cred = prepare_creds()
>>>>>           security_prepare_creds()
>>>>>               call_int_hook(cred_prepare, ...
>>>>>       if (cred)
>>>>>           create_user_ns(cred)
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
>>>>> This patch set first introduces a new security_create_user_ns()
>>>>> function
>>>>> and create_user_ns LSM hook, then marks the hook as sleepable in BPF.
>>>>
>>>> Some thoughts:
>>>>
>>>> I.
>>>>
>>>> Why not make the hook more generic, e.g. support all other existing
>>>> and potential future namespaces?
>>>
>>> The main issue with a generic hook is that different namespaces have
>>> different calling contexts. We decided in a previous discussion to
>>> opt-out of a generic hook for this reason. [1]
>>>
>>>> Also I think the naming scheme is <object>_<verb>.
>>>
>>> That's a good call out. I was originally hoping to keep the
>>> security_*() match with the hook name matched with the caller function
>>> to keep things all aligned. If no one objects to renaming the hook, I
>>> can rename the hook for v3.
>>>
>>>>
>>>>       LSM_HOOK(int, 0, namespace_create, const struct cred *cred,
>>>> unsigned int flags)
>>>>
>>>> where flags is a bitmap of CLONE flags from include/uapi/linux/sched.h
>>>> (like CLONE_NEWUSER).
>>>>
>>>> II.
>>>>
>>>> While adding policing for namespaces maybe also add a new hook for
>>>> setns(2)
>>>>
>>>>       LSM_HOOK(int, 0, namespace_join, const struct cred *subj,  const
>>>> struct cred *obj, unsigned int flags)
>>>>
>>>
>>> IIUC, setns() will create a new namespace for the other namespaces
>>> except for user namespace. If we add a security hook for the other
>>> create_*_ns() functions, then we can catch setns() at that point.
>>>
>>>> III.
>>>>
>>>> Maybe even attach a security context to namespaces so they can be
>>>> further governed?
>>
>> That would likely add confusion to the existing security module namespace
>> efforts. SELinux, Smack and AppArmor have all developed namespace models.
>> That, or it could replace the various independent efforts with a single,
> 
> I feel like you're attaching more meaning to this than there needs to be.
> I *think* he's just talking about a user_namespace->u_security void*.
> So that for instance while deciding whether to allow some transition,
> selinux could check whether the caller's user namespace was created by
> a task in an selinux context authorized to create user namespaces.
> 
> The "user namespaces are DAC and orthogonal to MAC" is of course true
> (where the LSM does not itself tie them together), except that we all
> know that a process running as root in a user namespace gains access to
> often-less-trustworthy code gated under CAP_SYS_ADMIN.
> 
>> unified security module namespace effort. There's more work to that than
>> adding a context to a namespace. Treating namespaces as objects is almost,
>> but not quite, solidifying containers as a kernel construct. We know we
>> can't do that.
> 
> What we "can't do" (imo) is to create a "full container" construct which
> ties together the various namespaces and other concepts in a restrictive
> way.
> 

Is this the direction we want to go with the SELinux implementation? If 
so, where can I find a similar implementation to make the userns_create 
work with this? If not, I have a v3 with the hook name change ready to post.

>>>> SELinux example:
>>>>
>>>>       type domainA_userns_t;
>>>>       type_transition domainA_t domainA_t : namespace domainA_userns_t
>>>> "user";
>>>>       allow domainA_t domainA_userns_t:namespace create;
>>>>
>>>>       # domainB calling setns(2) with domainA as target
>>>>       allow domainB_t domainA_userns_t:namespace join;
>>
>> While I'm not an expert on SELinux policy, I'd bet a refreshing beverage
>> that there's already a way to achieve this with existing constructs.
>> Smack, which is subject+object MAC couldn't care less about the user
>> namespace configuration. User namespaces are DAC constructs.
>>
>>>>
>>>
>>> Links:
>>> 1.
>>> https://lore.kernel.org/all/CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com/
>>>
>>>>>
>>>>> Links:
>>>>> 1.
>>>>> https://lore.kernel.org/all/20220608150942.776446-1-fred@cloudflare.com/
>>>>>
>>>>> 2.
>>>>> https://lore.kernel.org/all/87y1xzyhub.fsf@email.froward.int.ebiederm.org/
>>>>> 3.
>>>>> https://lore.kernel.org/all/9fe9cd9f-1ded-a179-8ded-5fde8960a586@cloudflare.com/
>>>>>
>>>>> Changes since v1:
>>>>> - Add selftests/bpf: Add tests verifying bpf lsm create_user_ns hook
>>>>> patch
>>>>> - Add selinux: Implement create_user_ns hook patch
>>>>> - Change function signature of security_create_user_ns() to only take
>>>>>     struct cred
>>>>> - Move security_create_user_ns() call after id mapping check in
>>>>>     create_user_ns()
>>>>> - Update documentation to reflect changes
>>>>>
>>>>> Frederick Lawler (4):
>>>>>     security, lsm: Introduce security_create_user_ns()
>>>>>     bpf-lsm: Make bpf_lsm_create_user_ns() sleepable
>>>>>     selftests/bpf: Add tests verifying bpf lsm create_user_ns hook
>>>>>     selinux: Implement create_user_ns hook
>>>>>
>>>>>    include/linux/lsm_hook_defs.h                 |  1 +
>>>>>    include/linux/lsm_hooks.h                     |  4 +
>>>>>    include/linux/security.h                      |  6 ++
>>>>>    kernel/bpf/bpf_lsm.c                          |  1 +
>>>>>    kernel/user_namespace.c                       |  5 ++
>>>>>    security/security.c                           |  5 ++
>>>>>    security/selinux/hooks.c                      |  9 ++
>>>>>    security/selinux/include/classmap.h           |  2 +
>>>>>    .../selftests/bpf/prog_tests/deny_namespace.c | 88
>>>>> +++++++++++++++++++
>>>>>    .../selftests/bpf/progs/test_deny_namespace.c | 39 ++++++++
>>>>>    10 files changed, 160 insertions(+)
>>>>>    create mode 100644
>>>>> tools/testing/selftests/bpf/prog_tests/deny_namespace.c
>>>>>    create mode 100644
>>>>> tools/testing/selftests/bpf/progs/test_deny_namespace.c
>>>>>
>>>>> -- 
>>>>> 2.30.2
>>>>>
>>>

