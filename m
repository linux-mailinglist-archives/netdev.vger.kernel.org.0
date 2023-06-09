Return-Path: <netdev+bounces-9530-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D770729A1D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:34:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D03BD1C21024
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90672C2D8;
	Fri,  9 Jun 2023 12:34:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F718256D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:34:39 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F745358E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 05:34:20 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f6e4554453so13197905e9.3
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 05:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=incline.eu; s=google; t=1686314058; x=1688906058;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u9/7isQjKyfFSUwnG644NZPZ33UevoCIqQyj3Drd/QQ=;
        b=BGQAtV7VeGOzX2HMNp9A73zPbKUqaBN0gSexAWOXUVxWLSMhSahIs670j+bS60F02D
         pwFaX2h1pq08peBv3LBWottwKFmZvClcGVOiKHEetrYGfT/6eUw+OzhjMch6reI1/OhF
         uVWT6drC6VCVQHIwFOJHhkIywm0SEGviZARmyS1lT3dAyTRXOyziosmpJu8PvJqnqu7U
         SE7a1JlidE5j9JK/VJ8m0+fbAnSTiOQywt3JPabmtNy8CxjpLT59DNnu4ah+uJVCWLfR
         6hK6IEU54VVyxPSLc2FNE558zi2ob2RJZvBeIQe+5CLDYu46RNBSDrotTz/Co18BgxVM
         uIew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686314058; x=1688906058;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u9/7isQjKyfFSUwnG644NZPZ33UevoCIqQyj3Drd/QQ=;
        b=Zf1z5SfAcPdboqFKQIT3GsUtDoukoGEd5kwOdqZNfGbqnuLV+Tx2WYrv64VrU0h8oW
         OX5dAZyBC5Kx2gHYUth2WpXVR+g4WKmRatemMrafbYMB6n8gejvS+jaDeGBLxL4s7Ndp
         Gd+GuFzr33ZU4iCSiPD7w4Rfhvq28EhQuX+oVt0nE9i4DtCZOf+mQkZcsINLkLvjLuGF
         EXdZ9Fgyz6XGEvVeqOwklLruimdC1Qxltl+BV1g6x2xwf8lMlVYQlXt4GOT59cUud1Bs
         hvkUuh2Z9SrED8QMeVTF8IodTkjNDPc54JUoi6/JyGbrlGhrdipWsVc49Y6Ob/SiSf/k
         pENw==
X-Gm-Message-State: AC+VfDwwW53XjZg/oiDoy23fP0B0Ktca79oO0T+zT6eLKv2e4NUiGd6J
	wB+fofUGbN9mMULTVNxO7tyaGw==
X-Google-Smtp-Source: ACHHUZ6osCyz631+DWAi52/gI7yArcW4Tv8aK/v2B5xli1jJ27HtyoBaWFOH01HwxxrDRa+ps+MYnw==
X-Received: by 2002:a7b:cb9a:0:b0:3f7:38e2:d87a with SMTP id m26-20020a7bcb9a000000b003f738e2d87amr1032839wmi.37.1686314058489;
        Fri, 09 Jun 2023 05:34:18 -0700 (PDT)
Received: from ?IPV6:2a02:1811:50b:7ef2:8cc2:7436:93d1:c4bc? (ptr-7tz51s5gyc8f8ib2wn0.18120a2.ip6.access.telenet.be. [2a02:1811:50b:7ef2:8cc2:7436:93d1:c4bc])
        by smtp.gmail.com with ESMTPSA id a7-20020a05600c224700b003f60a9ccd34sm2547805wmm.37.2023.06.09.05.34.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 05:34:18 -0700 (PDT)
Message-ID: <1a73a1b9-c72a-de81-4fce-7ba4fb6d7900@incline.eu>
Date: Fri, 9 Jun 2023 14:34:16 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
Content-Language: en-US
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Stanislav Fomichev <sdf@google.com>,
 Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
 razor@blackwall.org, john.fastabend@gmail.com, kuba@kernel.org,
 dxu@dxuuu.xyz, joe@cilium.io, davem@davemloft.net, bpf@vger.kernel.org,
 netdev@vger.kernel.org
References: <20230607192625.22641-1-daniel@iogearbox.net>
 <20230607192625.22641-2-daniel@iogearbox.net> <ZIIOr1zvdRNTFKR7@google.com>
 <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com>
 <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
 <ZIJe5Ml6ILFa6tKP@google.com> <87a5x91nr8.fsf@toke.dk>
 <3a315a0d-52dd-7671-f6c1-bb681604c815@iogearbox.net> <874jng28xk.fsf@toke.dk>
From: Timo Beckers <timo@incline.eu>
In-Reply-To: <874jng28xk.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/9/23 13:04, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
>
>>>>>>>> I'm still not sure whether the hard semantics of first/last is really
>>>>>>>> useful. My worry is that some prog will just use BPF_F_FIRST which
>>>>>>>> would prevent the rest of the users.. (starting with only
>>>>>>>> F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if we really
>>>>>>>> need first/laste).
>>>>>>> Without FIRST/LAST some scenarios cannot be guaranteed to be safely
>>>>>>> implemented. E.g., if I have some hard audit requirements and I need
>>>>>>> to guarantee that my program runs first and observes each event, I'll
>>>>>>> enforce BPF_F_FIRST when attaching it. And if that attachment fails,
>>>>>>> then server setup is broken and my application cannot function.
>>>>>>>
>>>>>>> In a setup where we expect multiple applications to co-exist, it
>>>>>>> should be a rule that no one is using FIRST/LAST (unless it's
>>>>>>> absolutely required). And if someone doesn't comply, then that's a bug
>>>>>>> and has to be reported to application owners.
>>>>>>>
>>>>>>> But it's not up to the kernel to enforce this cooperation by
>>>>>>> disallowing FIRST/LAST semantics, because that semantics is critical
>>>>>>> for some applications, IMO.
>>>>>> Maybe that's something that should be done by some other mechanism?
>>>>>> (and as a follow up, if needed) Something akin to what Toke
>>>>>> mentioned with another program doing sorting or similar.
>>>>> The goal of this API is to avoid needing some extra special program to
>>>>> do this sorting
>>>>>
>>>>>> Otherwise, those first/last are just plain simple old priority bands;
>>>>>> only we have two now, not u16.
>>>>> I think it's different. FIRST/LAST has to be used judiciously, of
>>>>> course, but when they are needed, they will have no alternative.
>>>>>
>>>>> Also, specifying FIRST + LAST is the way to say "I want my program to
>>>>> be the only one attached". Should we encourage such use cases? No, of
>>>>> course. But I think it's fair  for users to be able to express this.
>>>>>
>>>>>> I'm mostly coming from the observability point: imagine I have my fancy
>>>>>> tc_ingress_tcpdump program that I want to attach as a first program to debug
>>>>>> some issue, but it won't work because there is already a 'first' program
>>>>>> installed.. Or the assumption that I'd do F_REPLACE | F_FIRST ?
>>>>> If your production setup requires that some important program has to
>>>>> be FIRST, then yeah, your "let me debug something" program shouldn't
>>>>> interfere with it (assuming that FIRST requirement is a real
>>>>> requirement and not someone just thinking they need to be first; but
>>>>> that's up to user space to decide). Maybe the solution for you in that
>>>>> case would be freplace program installed on top of that stubborn FIRST
>>>>> program? And if we are talking about local debugging and development,
>>>>> then you are a sysadmin and you should be able to force-detach that
>>>>> program that is getting in the way.
>>>> I'm not really concerned about our production environment. It's pretty
>>>> controlled and restricted and I'm pretty certain we can avoid doing
>>>> something stupid. Probably the same for your env.
>>>>
>>>> I'm mostly fantasizing about upstream world where different users don't
>>>> know about each other and start doing stupid things like F_FIRST where
>>>> they don't really have to be first. It's that "used judiciously" part
>>>> that I'm a bit skeptical about :-D
>> But in the end how is that different from just attaching themselves blindly
>> into the first position (e.g. with before and relative_fd as 0 or the fd/id
>> of the current first program) - same, they don't really have to be first.
>> How would that not result in doing something stupid? ;) To add to Andrii's
>> earlier DDoS mitigation example ... think of K8s environment: one project
>> is implementing DDoS mitigation with BPF, another one wants to monitor/
>> sample traffic to user space with BPF. Both install as first position by
>> default (before + 0). In K8s, there is no built-in Pod dependency management
>> so you cannot guarantee whether Pod A comes up before Pod B. So you'll end
>> up in a situation where sometimes the monitor runs before the DDoS mitigation
>> and on some other nodes it's vice versa. The other case where this gets
>> broken (assuming a node where we get first the DDoS mitigation, then the
>> monitoring) is when you need to upgrade one of the Pods: monitoring Pod
>> gets a new stable update and is being re-rolled out, then it inserts
>> itself before the DDoS mitigation mechanism, potentially causing outage.
>> With the first/last mechanism these two situations cannot happen. The DDoS
>> mitigation software uses first and the monitoring uses before + 0, then no
>> matter the re-rollouts or the ordering in which Pods come up, it's always
>> at the expected/correct location.
> I'm not disputing that these kinds of policy issues need to be solved
> somehow. But adding the first/last pinning as part of the kernel hooks
> doesn't solve the policy problem, it just hard-codes a solution for one
> particular instance of the problem.
>
> Taking your example from above, what happens when someone wants to
> deploy those tools in reverse order? Say the monitoring tool counts
> packets and someone wants to also count the DDOS traffic; but the DDOS
> protection tool has decided for itself (by setting the FIRST) flag that
> it can *only* run as the first program, so there is no way to achieve
> this without modifying the application itself.
>
>>>> Because even with this new ordering scheme, there still should be
>>>> some entity to do relative ordering (systemd-style, maybe CNI?).
>>>> And if it does the ordering, I don't really see why we need
>>>> F_FIRST/F_LAST.
>>> I can see I'm a bit late to the party, but FWIW I agree with this:
>>> FIRST/LAST will definitely be abused if we add it. It also seems to me
It's in the prisoners' best interest to collaborate (and they do! see
https://www.youtube.com/watch?v=YK7GyEJdJGo), except the current
prio system is limiting and turns out to be really fragile in practice.

If your tool wants to attach to tc prio 1 and there's already a prog 
attached,
the most reliable option is basically to blindly replace the attachment, 
unless
you have the possibility to inspect the attached prog and try to figure 
out if it
belongs to another tool. This is fragile in and of itself, and only 
possible on
more recent kernels iirc.

With tcx, Cilium could make an initial attachment using F_FIRST and simply
update a link at well-known path on subsequent startups. If there's no 
existing
link, and F_FIRST is taken, bail out with an error. The owner of the 
existing
F_FIRST program can be queried and logged; we know for sure the program
doesn't belong to Cilium, and we have no interest in detaching it.
>> See above on the issues w/o the first/last. How would you work around them
>> in practice so they cannot happen?
> By having an ordering configuration that is deterministic. Enforced by
> the system-wide management daemon by whichever mechanism suits it. We
> could implement a minimal reference policy agent that just reads a
> config file in /etc somewhere, and *that* could implement FIRST/LAST
> semantics.
I think this particular perspective is what's deadlocking this discussion.
To me, it looks like distros and hyperscalers are in the same boat with
regards to the possibility of coordination between tools. Distros are only
responsible for the tools they package themselves, and hyperscalers
run a tight ship with mostly in-house tooling already. When it comes to
projects out in the wild, that all goes out the window.

Regardless of merit or feasability of a system-wide bpf management
daemon for k8s, there _is no ordering configuration possible_. K8s is not
a distro where package maintainers (or anyone else, really) can coordinate
on correctly defining priority of each of the tools they ship. This is 
effectively
the prisoner's dilemma. I feel like most of the discussion so far has been
very hand-wavy in 'user space should solve it'. Well, we are user space, and
we're here trying to solve it. :)

A hypothetical policy/gatekeeper/ordering daemon doesn't possess
implicit knowledge about which program needs to go where in the chain,
nor is there an obvious heuristic about how to order things. Maintaining
such a configuration for all cloud-native tooling out there that possibly
uses bpf is simply impossible, as even a tool like Cilium can change
dramatically from one release to the next. Having to manage this too
would put a significant burden on velocity and flexibility for arguably
little benefit to the user.

So, daemon/kernel will need to be told how to order things, preferably by
the tools (Cilium/datadog-agent) themselves, since the user/admin of the
system cannot be expected to know where to position the hundreds of progs
loaded by Cilium and how they might interfere with other tools. Figuring
this out is the job of the tool, daemon or not.

The prisoners _must_ communicate (so, not abuse F_FIRST) for things to
work correctly, and it's 100% in their best interest in doing so. Let's not
pretend like we're able to solve game theory on this mailing list. :)
We'll have to settle for the next-best thing: give user space a safe and 
clear
API to allow it to coordinate and make the right decisions.

To circle back to the observability case: in offline discussions with 
Daniel,
I've mentioned the need for 'shadow' progs that only collect data and
pump it to user space, attached at specific points in the chain (still 
within tcx!).
Their retcodes would be ignored, and context modifications would be
rejected, so attaching multiple to the same hook can always succeed,
much like cgroup multi. Consider the following:

To attach a shadow prog before F_FIRST, a caller could use F_BEFORE | 
F_FIRST |
F_RDONLY. Attaching between first and the 'relative' section: F_AFTER | 
F_FIRST |
F_RDONLY, etc. The rdonly flag could even be made redundant if a new prog/
attach type is added for progs like these.

This is still perfectly possible to implement on top of Daniel's 
proposal, and
to me looks like it could address many of the concerns around ordering of
progs I've seen in this thread, many mention data exfiltration.

Please give this some consideration; we've been trying to figure out a way
forward for years at this point. Try not to defer to a daemon too much, it
won't actually address any of the pain points with developing k8s tooling.

Thanks,

T
>>> to be policy in the kernel, which would be much better handled in
>>> userspace like we do for so many other things. So we should rather
>>> expose a hook to allow userspace to set the policy, as we've discussed
>>> before; I definitely think we should add that at some point! Although
>>> obviously it doesn't have to be part of this series...
>> Imo, it would be better if we could avoid that.. it feels like we're
>> trying to shoot sparrows with cannon, e.g. when this API gets reused
>> for other attach hooks, then for each of them you need yet another
>> policy program.
> Or a single one that understands multiple program types. Sharing the
> multi-prog implementation is helpful here.
>
>> I don't think that's a good user experience, and I presume this is
>> then single-user program, thus you'll run into the same race in the
>> end - whichever management daemon or application gets to install this
>> policy program first wins. This is potentially just shifting the same
>> issue one level higher, imo.
> Sure, we're shifting the problem one level higher, i.e., out of the
> kernel. That's the point: this is better solved in userspace, so
> different environments can solve it according to their needs :)
>
> I'm not against having one policy agent on the system, I just don't
> think the kernel should hard-code one particular solution to the policy
> problem. Much better to merge this without it, and then iterate on
> different options (and happy to help with this!), instead of locking the
> UAPI into a single solution straight away.
>
> -Toke
>


