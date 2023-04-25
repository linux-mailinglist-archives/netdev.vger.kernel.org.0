Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE206EE9B0
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236386AbjDYV2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbjDYV2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:28:35 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADFD729A;
        Tue, 25 Apr 2023 14:28:27 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 3f1490d57ef6-b99f374179bso1896036276.3;
        Tue, 25 Apr 2023 14:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682458106; x=1685050106;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KN4OwG7Q8S0Ej2HKI/K8Bzq4Vn4sob6zcbuKi/+SBdk=;
        b=Oz4UbWpnj6Eh8d8V1VZ88IAXj/GUdzOFDQ7w7bab738unz4j94g2KIoScKa+JBOCee
         6AnhR9ro+G/dg6bIlF2wDf9EwKsttEkhVZE4qfSu1PAFYXABo2gReoNJ9t29CBk03uNK
         WIzhAM11FzK7JQ6v7Dg6EJm6hIrI0Ya4Wmn/Rji2zbxmmJXSTWwOKuszPUH6UmJy61do
         I16qnR2ojZu0deWpR74s3SB0w9bl8DfCbf/z0dnpeQclzEMH4Srg6RnMUQK9E8ud6W4b
         TEylmunEnL3QI+CN6gagBCfpGDHnuxJpIC9iHTZv69VdTqdBgfItR3wsUuyqYHmjR+9Z
         axBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682458106; x=1685050106;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KN4OwG7Q8S0Ej2HKI/K8Bzq4Vn4sob6zcbuKi/+SBdk=;
        b=RX+z1QSUhFzsvtf9CiKILQAyLWJRsJgJmKHlO7qlDhqCLoJT7Ny1H3Gcim0WcPODxE
         kvFgXTWPFK2ovF46NlCwTvHWUzppRfZymaE/eo4dOsnObxEayAuQ2XrRBws4rMnFQwLs
         k9sCCeM5WRVMTwCdfcsBir6HFd1ofjsvgMmEjuiUd28fF9F+1oGkl0UlcPgEholimjlt
         E12M0NV2qsRIxx5x63w8dnrkJ/h/LTC/wxGtEXPmtbEEcTajcq9g/g7EoOwcY9kmPoF7
         GvPCX1IzE0Z4tLJgvJFzYir3+/L7r/N89JzsDPVvbmbqklxVSMzgKUUSci3l9c7U72le
         wZvw==
X-Gm-Message-State: AAQBX9evgEDI+8da7VbesvOM8wgPn/jDzQGSdQ/N9FmW6zsHHSsAa5eL
        PImpV5utL6mnpqIQsvadKmk=
X-Google-Smtp-Source: AKy350ZVCFaWXkFzYXnWip3LB4JLnKNxWp2+EpTCsvVEqE0yp6pu7FPsDxWtnMNKoFBSatYHM/lYuw==
X-Received: by 2002:a25:4243:0:b0:b75:9a44:5342 with SMTP id p64-20020a254243000000b00b759a445342mr13550844yba.4.1682458106526;
        Tue, 25 Apr 2023 14:28:26 -0700 (PDT)
Received: from ?IPV6:2600:1700:6cf8:1240:ba8:150e:68:30f0? ([2600:1700:6cf8:1240:ba8:150e:68:30f0])
        by smtp.gmail.com with ESMTPSA id d134-20020a25e68c000000b00b9949799ce3sm2639289ybh.32.2023.04.25.14.28.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 14:28:26 -0700 (PDT)
Message-ID: <927ddd10-ae5b-886c-6725-3daf04456e52@gmail.com>
Date:   Tue, 25 Apr 2023 14:28:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: handling unsupported optlen in cgroup bpf getsockopt: (was [PATCH
 net-next v4 2/4] net: socket: add sockopts blacklist for BPF cgroup hook)
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <brauner@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-arch@vger.kernel.org,
        Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        bpf <bpf@vger.kernel.org>
References: <20230413133355.350571-1-aleksandr.mikhalitsyn@canonical.com>
 <20230413133355.350571-3-aleksandr.mikhalitsyn@canonical.com>
 <CANn89iLuLkUvX-dDC=rJhtFcxjnVmfn_-crOevbQe+EjaEDGbg@mail.gmail.com>
 <CAEivzxcEhfLttf0VK=NmHdQxF7CRYXNm6NwUVx6jx=-u2k-T6w@mail.gmail.com>
 <CAKH8qBt+xPygUVPMUuzbi1HCJuxc4gYOdU6JkrFmSouRQgoG6g@mail.gmail.com>
 <ZDoEG0VF6fb9y0EC@google.com>
 <a4591e85-d58b-0efd-c8a4-2652dc69ff68@linux.dev>
 <ZD7Js4fj5YyI2oLd@google.com>
 <b453462a-3d98-8d0f-9cc0-543032de5a5f@gmail.com>
 <CAKH8qBusi0AWpo_iDaFkLFPUhgZy7-p6JwhimCkpYMhWnToE7g@mail.gmail.com>
From:   Kui-Feng Lee <sinquersw@gmail.com>
In-Reply-To: <CAKH8qBusi0AWpo_iDaFkLFPUhgZy7-p6JwhimCkpYMhWnToE7g@mail.gmail.com>
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



On 4/25/23 11:42, Stanislav Fomichev wrote:
> On Tue, Apr 25, 2023 at 10:59 AM Kui-Feng Lee <sinquersw@gmail.com> wrote:
>>
>>
>>
>> On 4/18/23 09:47, Stanislav Fomichev wrote:
>>> On 04/17, Martin KaFai Lau wrote:
>>>> On 4/14/23 6:55 PM, Stanislav Fomichev wrote:
>>>>> On 04/13, Stanislav Fomichev wrote:
>>>>>> On Thu, Apr 13, 2023 at 7:38 AM Aleksandr Mikhalitsyn
>>>>>> <aleksandr.mikhalitsyn@canonical.com> wrote:
>>>>>>>
>>>>>>> On Thu, Apr 13, 2023 at 4:22 PM Eric Dumazet <edumazet@google.com> wrote:
>>>>>>>>
>>>>>>>> On Thu, Apr 13, 2023 at 3:35 PM Alexander Mikhalitsyn
>>>>>>>> <aleksandr.mikhalitsyn@canonical.com> wrote:
>>>>>>>>>
>>>>>>>>> During work on SO_PEERPIDFD, it was discovered (thanks to Christian),
>>>>>>>>> that bpf cgroup hook can cause FD leaks when used with sockopts which
>>>>>>>>> install FDs into the process fdtable.
>>>>>>>>>
>>>>>>>>> After some offlist discussion it was proposed to add a blacklist of
>>>>>>>>
>>>>>>>> We try to replace this word by either denylist or blocklist, even in changelogs.
>>>>>>>
>>>>>>> Hi Eric,
>>>>>>>
>>>>>>> Oh, I'm sorry about that. :( Sure.
>>>>>>>
>>>>>>>>
>>>>>>>>> socket options those can cause troubles when BPF cgroup hook is enabled.
>>>>>>>>>
>>>>>>>>
>>>>>>>> Can we find the appropriate Fixes: tag to help stable teams ?
>>>>>>>
>>>>>>> Sure, I will add next time.
>>>>>>>
>>>>>>> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
>>>>>>>
>>>>>>> I think it's better to add Stanislav Fomichev to CC.
>>>>>>
>>>>>> Can we use 'struct proto' bpf_bypass_getsockopt instead? We already
>>>>>> use it for tcp zerocopy, I'm assuming it should work in this case as
>>>>>> well?
>>>>>
>>>>> Jakub reminded me of the other things I wanted to ask here bug forgot:
>>>>>
>>>>> - setsockopt is probably not needed, right? setsockopt hook triggers
>>>>>      before the kernel and shouldn't leak anything
>>>>> - for getsockopt, instead of bypassing bpf completely, should we instead
>>>>>      ignore the error from the bpf program? that would still preserve
>>>>>      the observability aspect
>>>>
>>>> stealing this thread to discuss the optlen issue which may make sense to
>>>> bypass also.
>>>>
>>>> There has been issue with optlen. Other than this older post related to
>>>> optlen > PAGE_SIZE:
>>>> https://lore.kernel.org/bpf/5c8b7d59-1f28-2284-f7b9-49d946f2e982@linux.dev/,
>>>> the recent one related to optlen that we have seen is
>>>> NETLINK_LIST_MEMBERSHIPS. The userspace passed in optlen == 0 and the kernel
>>>> put the expected optlen (> 0) and 'return 0;' to userspace. The userspace
>>>> intention is to learn the expected optlen. This makes 'ctx.optlen >
>>>> max_optlen' and __cgroup_bpf_run_filter_getsockopt() ends up returning
>>>> -EFAULT to the userspace even the bpf prog has not changed anything.
>>>
>>> (ignoring -EFAULT issue) this seems like it needs to be
>>>
>>>        if (optval && (ctx.optlen > max_optlen || ctx.optlen < 0)) {
>>>                /* error */
>>>        }
>>>
>>> ?
>>>
>>>> Does it make sense to also bypass the bpf prog when 'ctx.optlen >
>>>> max_optlen' for now (and this can use a separate patch which as usual
>>>> requires a bpf selftests)?
>>>
>>> Yeah, makes sense. Replacing this -EFAULT with WARN_ON_ONCE or something
>>> seems like the way to go. It caused too much trouble already :-(
>>>
>>> Should I prepare a patch or do you want to take a stab at it?
>>>
>>>> In the future, does it make sense to have a specific cgroup-bpf-prog (a
>>>> specific attach type?) that only uses bpf_dynptr kfunc to access the optval
>>>> such that it can enforce read-only for some optname and potentially also
>>>> track if bpf-prog has written a new optval? The bpf-prog can only return 1
>>>> (OK) and only allows using bpf_set_retval() instead. Likely there is still
>>>> holes but could be a seed of thought to continue polishing the idea.
>>>
>>> Ack, let's think about it.
>>>
>>> Maybe we should re-evaluate 'getsockopt-happens-after-the-kernel' idea
>>> as well? If we can have a sleepable hook that can copy_from_user/copy_to_user,
>>> and we have a mostly working bpf_getsockopt (after your refactoring),
>>> I don't see why we need to continue the current scheme of triggering
>>> after the kernel?
>>
>> Since a sleepable hook would cause some restrictions, perhaps, we could
>> introduce something like the promise pattern.  In our case here, BPF
>> program call an async version of copy_from_user()/copy_to_user() to
>> return a promise.
> 
> Having a promise might work. This is essentially what we already do
> with sockets/etc with acquire/release pattern.

Would you mind to give me some context of the socket things?

> 
> What are the sleepable restrictions you're hinting about? I feel like
> with the sleepable bpf, we can also remove all the temporary buffer
> management / extra copies which sounds like a win to me. (we have this
> ugly heuristics with BPF_SOCKOPT_KERN_BUF_SIZE) The program can
> allocate temporary buffers if needed..
> 
>>>>> - or maybe we can even have a per-proto bpf_getsockopt_cleanup call that
>>>>>      gets called whenever bpf returns an error to make sure protocols have
>>>>>      a chance to handle that condition (and free the fd)
>>>>>
>>>>
>>>>
