Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EA86EE736
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 19:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbjDYR7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 13:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbjDYR7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 13:59:41 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76DFCC0B;
        Tue, 25 Apr 2023 10:59:39 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-5529f3b8623so44818607b3.2;
        Tue, 25 Apr 2023 10:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682445579; x=1685037579;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G10AbqH9A8yLMlZ4uDYvgRAVXXBbjLY0pdUrDrvotf4=;
        b=Oe/1g57mmKfa64jDv7SaR9SSzOeXaZ2DJchfdo3e85HANVRNwTbQ+KahrusCfhRzOd
         NHdTUZ1RWBPyYaqA6OIlTxyKRZ3UYiuXB5amFKa+bTAhNPWtsGepdPZAGGD467Dhoi/8
         VNBQVc01LmcxNwne/Pw9jwixWBN963mowkv3YrqX7YGvQAao6UvhYD+P0J62Bc2O/99s
         yfzrhMXlcPAEAhpNQVFx/4kUQzjT7zbgck8c489AI9VMvVQCuZ7QdNUmXbOsGGTSGZdM
         tsVLw7sO/uY4gYiG2CPQXecGUiOzSzIMk308GvPLuF5r4qlrBUm4cZmGob+1nmhCob0c
         dl3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682445579; x=1685037579;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G10AbqH9A8yLMlZ4uDYvgRAVXXBbjLY0pdUrDrvotf4=;
        b=mDiczdxREcSqFz1olYIHyzLi5MnqXQsPTNef3VHe7tpWKlUVktxERNrhMLw5ehon1R
         rqGzbMVFO0S/gUXcodVxOcYU0i3IKCrGhLkl4aH/lp6mqPvwkYZRLu9/yKqtHqXG526a
         vy4eQ21i9pFNsyG7KXymBxXfUdCaUq8dFh37LE58snrJ2Df4nPRfX4aNpMVWBaSjb1Zo
         ZHQpb+I0Fo6+nNYUouLU5KX4+LylbV+q4ro2rN3XeYgHrHUvpkYzfpgNWU/j69s5L5l3
         1agJdFzV4Xe7jJRVpiOgGu+JvcxpJAwdPgnTIDptHuTYG6hlcD5MJaJfEwdscUnaHd40
         xjMQ==
X-Gm-Message-State: AAQBX9c0lKBF7nM2cCzaaUpW9Wqe7rgzIz3gUDOypbQCAcCt26Np+ld0
        MYOuuMGhyWgNmla/3o2Ac1o=
X-Google-Smtp-Source: AKy350bH8WwHS64vfKjRR5dbnq9kswVNGhOJG7iHj3VMeyl3g3ykb9s2H4H3acyHO26bSJvDUBPDdw==
X-Received: by 2002:a81:48cb:0:b0:54f:881e:75bb with SMTP id v194-20020a8148cb000000b0054f881e75bbmr11951172ywa.45.1682445579042;
        Tue, 25 Apr 2023 10:59:39 -0700 (PDT)
Received: from ?IPV6:2600:1700:6cf8:1240:21b2:7d86:e505:fcbc? ([2600:1700:6cf8:1240:21b2:7d86:e505:fcbc])
        by smtp.gmail.com with ESMTPSA id c134-20020a814e8c000000b00555abba6ff7sm3720045ywb.113.2023.04.25.10.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 10:59:38 -0700 (PDT)
Message-ID: <b453462a-3d98-8d0f-9cc0-543032de5a5f@gmail.com>
Date:   Tue, 25 Apr 2023 10:59:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: handling unsupported optlen in cgroup bpf getsockopt: (was [PATCH
 net-next v4 2/4] net: socket: add sockopts blacklist for BPF cgroup hook)
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
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
From:   Kui-Feng Lee <sinquersw@gmail.com>
In-Reply-To: <ZD7Js4fj5YyI2oLd@google.com>
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



On 4/18/23 09:47, Stanislav Fomichev wrote:
> On 04/17, Martin KaFai Lau wrote:
>> On 4/14/23 6:55 PM, Stanislav Fomichev wrote:
>>> On 04/13, Stanislav Fomichev wrote:
>>>> On Thu, Apr 13, 2023 at 7:38 AM Aleksandr Mikhalitsyn
>>>> <aleksandr.mikhalitsyn@canonical.com> wrote:
>>>>>
>>>>> On Thu, Apr 13, 2023 at 4:22 PM Eric Dumazet <edumazet@google.com> wrote:
>>>>>>
>>>>>> On Thu, Apr 13, 2023 at 3:35 PM Alexander Mikhalitsyn
>>>>>> <aleksandr.mikhalitsyn@canonical.com> wrote:
>>>>>>>
>>>>>>> During work on SO_PEERPIDFD, it was discovered (thanks to Christian),
>>>>>>> that bpf cgroup hook can cause FD leaks when used with sockopts which
>>>>>>> install FDs into the process fdtable.
>>>>>>>
>>>>>>> After some offlist discussion it was proposed to add a blacklist of
>>>>>>
>>>>>> We try to replace this word by either denylist or blocklist, even in changelogs.
>>>>>
>>>>> Hi Eric,
>>>>>
>>>>> Oh, I'm sorry about that. :( Sure.
>>>>>
>>>>>>
>>>>>>> socket options those can cause troubles when BPF cgroup hook is enabled.
>>>>>>>
>>>>>>
>>>>>> Can we find the appropriate Fixes: tag to help stable teams ?
>>>>>
>>>>> Sure, I will add next time.
>>>>>
>>>>> Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
>>>>>
>>>>> I think it's better to add Stanislav Fomichev to CC.
>>>>
>>>> Can we use 'struct proto' bpf_bypass_getsockopt instead? We already
>>>> use it for tcp zerocopy, I'm assuming it should work in this case as
>>>> well?
>>>
>>> Jakub reminded me of the other things I wanted to ask here bug forgot:
>>>
>>> - setsockopt is probably not needed, right? setsockopt hook triggers
>>>     before the kernel and shouldn't leak anything
>>> - for getsockopt, instead of bypassing bpf completely, should we instead
>>>     ignore the error from the bpf program? that would still preserve
>>>     the observability aspect
>>
>> stealing this thread to discuss the optlen issue which may make sense to
>> bypass also.
>>
>> There has been issue with optlen. Other than this older post related to
>> optlen > PAGE_SIZE:
>> https://lore.kernel.org/bpf/5c8b7d59-1f28-2284-f7b9-49d946f2e982@linux.dev/,
>> the recent one related to optlen that we have seen is
>> NETLINK_LIST_MEMBERSHIPS. The userspace passed in optlen == 0 and the kernel
>> put the expected optlen (> 0) and 'return 0;' to userspace. The userspace
>> intention is to learn the expected optlen. This makes 'ctx.optlen >
>> max_optlen' and __cgroup_bpf_run_filter_getsockopt() ends up returning
>> -EFAULT to the userspace even the bpf prog has not changed anything.
> 
> (ignoring -EFAULT issue) this seems like it needs to be
> 
> 	if (optval && (ctx.optlen > max_optlen || ctx.optlen < 0)) {
> 		/* error */
> 	}
> 
> ?
> 
>> Does it make sense to also bypass the bpf prog when 'ctx.optlen >
>> max_optlen' for now (and this can use a separate patch which as usual
>> requires a bpf selftests)?
> 
> Yeah, makes sense. Replacing this -EFAULT with WARN_ON_ONCE or something
> seems like the way to go. It caused too much trouble already :-(
> 
> Should I prepare a patch or do you want to take a stab at it?
> 
>> In the future, does it make sense to have a specific cgroup-bpf-prog (a
>> specific attach type?) that only uses bpf_dynptr kfunc to access the optval
>> such that it can enforce read-only for some optname and potentially also
>> track if bpf-prog has written a new optval? The bpf-prog can only return 1
>> (OK) and only allows using bpf_set_retval() instead. Likely there is still
>> holes but could be a seed of thought to continue polishing the idea.
> 
> Ack, let's think about it.
> 
> Maybe we should re-evaluate 'getsockopt-happens-after-the-kernel' idea
> as well? If we can have a sleepable hook that can copy_from_user/copy_to_user,
> and we have a mostly working bpf_getsockopt (after your refactoring),
> I don't see why we need to continue the current scheme of triggering
> after the kernel?

Since a sleepable hook would cause some restrictions, perhaps, we could 
introduce something like the promise pattern.  In our case here, BPF 
program call an async version of copy_from_user()/copy_to_user() to 
return a promise.

> 
>>> - or maybe we can even have a per-proto bpf_getsockopt_cleanup call that
>>>     gets called whenever bpf returns an error to make sure protocols have
>>>     a chance to handle that condition (and free the fd)
>>>
>>
>>
