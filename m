Return-Path: <netdev+bounces-9674-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA58972A2B2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:59:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F8DC281A15
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34973408EE;
	Fri,  9 Jun 2023 18:58:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7EC408E2;
	Fri,  9 Jun 2023 18:58:58 +0000 (UTC)
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B14430F1;
	Fri,  9 Jun 2023 11:58:55 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b1afe57bdfso24266021fa.0;
        Fri, 09 Jun 2023 11:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686337133; x=1688929133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SBlQFS7myrw5XTwGrauTCWsOeKTmg7ck5FQEMRXT0Q8=;
        b=s4i3q726UR48Kid7J7NaD9teh6pSQIP7gbJl8ntoxytFrGrrqnv3RC50yFQ285booh
         7cs1Zvl/P1pVdyLcCxAif/EAwMBL/oBg1McnBqd8Aeqf9oOa23JeisLjqkNx0DwL5njN
         +xruPz4axvtPbcGT+m8Ha21yPqpMlK2tfRlyVP3nYonp3lj49EuHlUvi7ULOEf8NQTxu
         d6JJbW0JhqZ3j5O78HT3tIplpW/GDacFoNES1kzyJQOUJ+y1IBqjZ2WhMdNBudcgaJXL
         Xc2kgCKfmvE31TkpVMVGnb+emmylGROLRAT5p0S18+vjceOuwJgFGIImZKn5QIIqLgW8
         4D6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686337133; x=1688929133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SBlQFS7myrw5XTwGrauTCWsOeKTmg7ck5FQEMRXT0Q8=;
        b=Bj12J9AIqZaqV35tzxUcW20BPDUdsJlCaTAiwDsRgzoWZlT5za3eNvEeW3ghelorNq
         xpJs/17ERcErzeu0RW4JSOUMmKP4VbxedBqUV/hUv7qKvoy/nnYLozbNU9pewaxeVCS5
         duDF9r4td7IrXYyXEgWNWBbLZ4kVubxbltTKDPlgqnemdTsxBiGMRlDy2akVk9U/vNfk
         mJw6jpCGPVJ+yDlR/9YRnQMTt9rzzHAnVdFErgpcA1sFjlvIgBsqLKHzbzKiK7Or498C
         CixjWOHkd9UZcB2G1i0nMP4/0/hbnHdrP4aAnMYDSNTkS+61AXYrNeNZQJEF7uYg5uVv
         CrdA==
X-Gm-Message-State: AC+VfDzmQmcUHopyS091ibfbgkuLok3vkSjH+H/EmAUCAzrBJkOtRq6H
	C501g7ZJgGPx1TfsEQfu+WwBNSA9DaJLdAjl9SM=
X-Google-Smtp-Source: ACHHUZ4yyn+2nsax2p3YeX5L8Lr+8LgLZ+0L1TfzG/IKC87MjPS0h2WrksO8RqiPBoRwxA8VvWbkm9p9YwJ47G/ps/Q=
X-Received: by 2002:a2e:80c9:0:b0:2b1:be84:5496 with SMTP id
 r9-20020a2e80c9000000b002b1be845496mr1701460ljg.12.1686337132924; Fri, 09 Jun
 2023 11:58:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-2-daniel@iogearbox.net>
 <ZIIOr1zvdRNTFKR7@google.com> <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com> <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
 <ZIJe5Ml6ILFa6tKP@google.com> <87a5x91nr8.fsf@toke.dk> <3a315a0d-52dd-7671-f6c1-bb681604c815@iogearbox.net>
 <874jng28xk.fsf@toke.dk> <1a73a1b9-c72a-de81-4fce-7ba4fb6d7900@incline.eu>
 <87sfb0zsok.fsf@toke.dk> <d0cf9a4f-c111-b594-7a12-84914419789e@iogearbox.net>
In-Reply-To: <d0cf9a4f-c111-b594-7a12-84914419789e@iogearbox.net>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 9 Jun 2023 11:58:41 -0700
Message-ID: <CAEf4BzZpEi0PQwn6oMs+fHf51VhpSvXZsNLV6Rf=9Kaqyyqy=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>, 
	Timo Beckers <timo@incline.eu>, Stanislav Fomichev <sdf@google.com>, ast@kernel.org, andrii@kernel.org, 
	martin.lau@linux.dev, razor@blackwall.org, john.fastabend@gmail.com, 
	kuba@kernel.org, dxu@dxuuu.xyz, joe@cilium.io, davem@davemloft.net, 
	bpf@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 7:15=E2=80=AFAM Daniel Borkmann <daniel@iogearbox.ne=
t> wrote:
>
> On 6/9/23 3:11 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Timo Beckers <timo@incline.eu> writes:
> >> On 6/9/23 13:04, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >>> Daniel Borkmann <daniel@iogearbox.net> writes:
> [...]
> >>>>>>>>>> I'm still not sure whether the hard semantics of first/last is=
 really
> >>>>>>>>>> useful. My worry is that some prog will just use BPF_F_FIRST w=
hich
> >>>>>>>>>> would prevent the rest of the users.. (starting with only
> >>>>>>>>>> F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if we =
really
> >>>>>>>>>> need first/laste).
> >>>>>>>>> Without FIRST/LAST some scenarios cannot be guaranteed to be sa=
fely
> >>>>>>>>> implemented. E.g., if I have some hard audit requirements and I=
 need
> >>>>>>>>> to guarantee that my program runs first and observes each event=
, I'll
> >>>>>>>>> enforce BPF_F_FIRST when attaching it. And if that attachment f=
ails,
> >>>>>>>>> then server setup is broken and my application cannot function.
> >>>>>>>>>
> >>>>>>>>> In a setup where we expect multiple applications to co-exist, i=
t
> >>>>>>>>> should be a rule that no one is using FIRST/LAST (unless it's
> >>>>>>>>> absolutely required). And if someone doesn't comply, then that'=
s a bug
> >>>>>>>>> and has to be reported to application owners.
> >>>>>>>>>
> >>>>>>>>> But it's not up to the kernel to enforce this cooperation by
> >>>>>>>>> disallowing FIRST/LAST semantics, because that semantics is cri=
tical
> >>>>>>>>> for some applications, IMO.
> >>>>>>>> Maybe that's something that should be done by some other mechani=
sm?
> >>>>>>>> (and as a follow up, if needed) Something akin to what Toke
> >>>>>>>> mentioned with another program doing sorting or similar.
> >>>>>>> The goal of this API is to avoid needing some extra special progr=
am to
> >>>>>>> do this sorting
> >>>>>>>
> >>>>>>>> Otherwise, those first/last are just plain simple old priority b=
ands;
> >>>>>>>> only we have two now, not u16.
> >>>>>>> I think it's different. FIRST/LAST has to be used judiciously, of
> >>>>>>> course, but when they are needed, they will have no alternative.
> >>>>>>>
> >>>>>>> Also, specifying FIRST + LAST is the way to say "I want my progra=
m to
> >>>>>>> be the only one attached". Should we encourage such use cases? No=
, of
> >>>>>>> course. But I think it's fair  for users to be able to express th=
is.
> >>>>>>>
> >>>>>>>> I'm mostly coming from the observability point: imagine I have m=
y fancy
> >>>>>>>> tc_ingress_tcpdump program that I want to attach as a first prog=
ram to debug
> >>>>>>>> some issue, but it won't work because there is already a 'first'=
 program
> >>>>>>>> installed.. Or the assumption that I'd do F_REPLACE | F_FIRST ?
> >>>>>>> If your production setup requires that some important program has=
 to
> >>>>>>> be FIRST, then yeah, your "let me debug something" program should=
n't
> >>>>>>> interfere with it (assuming that FIRST requirement is a real
> >>>>>>> requirement and not someone just thinking they need to be first; =
but
> >>>>>>> that's up to user space to decide). Maybe the solution for you in=
 that
> >>>>>>> case would be freplace program installed on top of that stubborn =
FIRST
> >>>>>>> program? And if we are talking about local debugging and developm=
ent,
> >>>>>>> then you are a sysadmin and you should be able to force-detach th=
at
> >>>>>>> program that is getting in the way.
> >>>>>> I'm not really concerned about our production environment. It's pr=
etty
> >>>>>> controlled and restricted and I'm pretty certain we can avoid doin=
g
> >>>>>> something stupid. Probably the same for your env.
> >>>>>>
> >>>>>> I'm mostly fantasizing about upstream world where different users =
don't
> >>>>>> know about each other and start doing stupid things like F_FIRST w=
here
> >>>>>> they don't really have to be first. It's that "used judiciously" p=
art
> >>>>>> that I'm a bit skeptical about :-D
> >>>> But in the end how is that different from just attaching themselves =
blindly
> >>>> into the first position (e.g. with before and relative_fd as 0 or th=
e fd/id
> >>>> of the current first program) - same, they don't really have to be f=
irst.
> >>>> How would that not result in doing something stupid? ;) To add to An=
drii's
> >>>> earlier DDoS mitigation example ... think of K8s environment: one pr=
oject
> >>>> is implementing DDoS mitigation with BPF, another one wants to monit=
or/
> >>>> sample traffic to user space with BPF. Both install as first positio=
n by
> >>>> default (before + 0). In K8s, there is no built-in Pod dependency ma=
nagement
> >>>> so you cannot guarantee whether Pod A comes up before Pod B. So you'=
ll end
> >>>> up in a situation where sometimes the monitor runs before the DDoS m=
itigation
> >>>> and on some other nodes it's vice versa. The other case where this g=
ets
> >>>> broken (assuming a node where we get first the DDoS mitigation, then=
 the
> >>>> monitoring) is when you need to upgrade one of the Pods: monitoring =
Pod
> >>>> gets a new stable update and is being re-rolled out, then it inserts
> >>>> itself before the DDoS mitigation mechanism, potentially causing out=
age.
> >>>> With the first/last mechanism these two situations cannot happen. Th=
e DDoS
> >>>> mitigation software uses first and the monitoring uses before + 0, t=
hen no
> >>>> matter the re-rollouts or the ordering in which Pods come up, it's a=
lways
> >>>> at the expected/correct location.
> >>> I'm not disputing that these kinds of policy issues need to be solved
> >>> somehow. But adding the first/last pinning as part of the kernel hook=
s
> >>> doesn't solve the policy problem, it just hard-codes a solution for o=
ne
> >>> particular instance of the problem.
> >>>
> >>> Taking your example from above, what happens when someone wants to
> >>> deploy those tools in reverse order? Say the monitoring tool counts
> >>> packets and someone wants to also count the DDOS traffic; but the DDO=
S
> >>> protection tool has decided for itself (by setting the FIRST) flag th=
at
> >>> it can *only* run as the first program, so there is no way to achieve
> >>> this without modifying the application itself.
> >>>
> >>>>>> Because even with this new ordering scheme, there still should be
> >>>>>> some entity to do relative ordering (systemd-style, maybe CNI?).
> >>>>>> And if it does the ordering, I don't really see why we need
> >>>>>> F_FIRST/F_LAST.
> >>>>> I can see I'm a bit late to the party, but FWIW I agree with this:
> >>>>> FIRST/LAST will definitely be abused if we add it. It also seems to=
 me
> >> It's in the prisoners' best interest to collaborate (and they do! see
> >> https://www.youtube.com/watch?v=3DYK7GyEJdJGo), except the current
> >> prio system is limiting and turns out to be really fragile in practice=
.
> >>
> >> If your tool wants to attach to tc prio 1 and there's already a prog
> >> attached,
> >> the most reliable option is basically to blindly replace the attachmen=
t,
> >> unless
> >> you have the possibility to inspect the attached prog and try to figur=
e
> >> out if it
> >> belongs to another tool. This is fragile in and of itself, and only
> >> possible on
> >> more recent kernels iirc.
> >>
> >> With tcx, Cilium could make an initial attachment using F_FIRST and si=
mply
> >> update a link at well-known path on subsequent startups. If there's no
> >> existing
> >> link, and F_FIRST is taken, bail out with an error. The owner of the
> >> existing
> >> F_FIRST program can be queried and logged; we know for sure the progra=
m
> >> doesn't belong to Cilium, and we have no interest in detaching it.
> >
> > That's conflating the benefit of F_FIRST with that of bpf_link, though;
> > you can have the replace thing without the exclusive locking.
> >
> >>>> See above on the issues w/o the first/last. How would you work aroun=
d them
> >>>> in practice so they cannot happen?
> >>> By having an ordering configuration that is deterministic. Enforced b=
y
> >>> the system-wide management daemon by whichever mechanism suits it. We
> >>> could implement a minimal reference policy agent that just reads a
> >>> config file in /etc somewhere, and *that* could implement FIRST/LAST
> >>> semantics.
> >> I think this particular perspective is what's deadlocking this discuss=
ion.
> >> To me, it looks like distros and hyperscalers are in the same boat wit=
h
> >> regards to the possibility of coordination between tools. Distros are =
only
> >> responsible for the tools they package themselves, and hyperscalers
> >> run a tight ship with mostly in-house tooling already. When it comes t=
o
> >> projects out in the wild, that all goes out the window.
> >
> > Not really: from the distro PoV we absolutely care about arbitrary
> > combinations of programs with different authors. Which is why I'm
> > arguing against putting anything into the kernel where the first progra=
m
> > to come along can just grab a hook and lock everyone out.
> >
> > My assumption is basically this: A system administrator installs
> > packages A and B that both use the TC hook. The developers of A and B
> > have never heard about each other. It should be possible for that admin
> > to run A and B in whichever order they like, without making any changes
> > to A and B themselves.
>
> I would come with the point of view of the K8s cluster operator or platfo=
rm
> engineer, if you will. Someone deeply familiar with K8s, but not necessar=
ily
> knowing about kernel internals. I know my org needs to run container A an=
d
> container B, so I'll deploy the daemon-sets for both and they get deploye=
d
> into my cluster. That platform engineer might have never heard of BPF or =
might
> not even know that container A or container B ships software with BPF. As
> mentioned, K8s itself has no concept of Pod ordering as its paradigm is t=
hat
> everything is loosely coupled. We are now expecting from that person to m=
ake
> a concrete decision about some BPF kernel internals on various hooks in w=
hich
> order they should be executed given if they don't then the system becomes
> non-deterministic. I think that is quite a big burden and ask to understa=
nd.
> Eventually that person will say that he/she cannot make this technical de=
cision
> and that only one of the two containers can be deployed. I agree with you=
 that
> there should be an option for a technically versed person to be able to c=
hange
> ordering to avoid lock out, but I don't think it will fly asking users to=
 come
> up on their own with policies of BPF software in the wild ... similar as =
you
> probably don't want having to deal with writing systemd unit files for so=
ftware
> xyz before you can use your laptop. It's a burden. You expect this to mag=
ically
> work by default and only if needed for good reasons to make custom change=
s.
> Just the one difference is that the latter ships with the OS (a priori kn=
own /
> tight-ship analogy).
>
> >> Regardless of merit or feasability of a system-wide bpf management
> >> daemon for k8s, there _is no ordering configuration possible_. K8s is =
not
> >> a distro where package maintainers (or anyone else, really) can coordi=
nate
> >> on correctly defining priority of each of the tools they ship. This is
> >> effectively
> >> the prisoner's dilemma. I feel like most of the discussion so far has =
been
> >> very hand-wavy in 'user space should solve it'. Well, we are user spac=
e, and
> >> we're here trying to solve it. :)
> >>
> >> A hypothetical policy/gatekeeper/ordering daemon doesn't possess
> >> implicit knowledge about which program needs to go where in the chain,
> >> nor is there an obvious heuristic about how to order things. Maintaini=
ng
> >> such a configuration for all cloud-native tooling out there that possi=
bly
> >> uses bpf is simply impossible, as even a tool like Cilium can change
> >> dramatically from one release to the next. Having to manage this too
> >> would put a significant burden on velocity and flexibility for arguabl=
y
> >> little benefit to the user.
> >>
> >> So, daemon/kernel will need to be told how to order things, preferably=
 by
> >> the tools (Cilium/datadog-agent) themselves, since the user/admin of t=
he
> >> system cannot be expected to know where to position the hundreds of pr=
ogs
> >> loaded by Cilium and how they might interfere with other tools. Figuri=
ng
> >> this out is the job of the tool, daemon or not.
> >>
> >> The prisoners _must_ communicate (so, not abuse F_FIRST) for things to
> >> work correctly, and it's 100% in their best interest in doing so. Let'=
s not
> >> pretend like we're able to solve game theory on this mailing list. :)
> >> We'll have to settle for the next-best thing: give user space a safe a=
nd
> >> clear
> >> API to allow it to coordinate and make the right decisions.
> >
> > But "always first" is not a meaningful concept. It's just what we have
> > today (everyone picks priority 1), except now if there are two programs
> > that want the same hook, it will be the first program that wins the
> > contest (by locking the second one out), instead of the second program
> > winning (by overriding the first one) as is the case with the silent
> > override semantics we have with TC today. So we haven't solved the
> > problem, we've just shifted the breakage.
>
> Fwiw, it's deterministic, and I think this 1000x better than silently
> having a non-deterministic deployment where the two programs ship with
> before + 0. That is much harder to debug.
>

Totally agree. Silent overriding of the BPF program while user-space
is still running (and completely unaware) is MUCH WORSE than not being
able to start if your spot is taken.

The latter is explicit and gives a lot of signal early on. The former
is confusing and results in hours of painful guessing on what's going
on.

How is this even controversial?


> >> To circle back to the observability case: in offline discussions with
> >> Daniel,
> >> I've mentioned the need for 'shadow' progs that only collect data and
> >> pump it to user space, attached at specific points in the chain (still
> >> within tcx!).
> >> Their retcodes would be ignored, and context modifications would be
> >> rejected, so attaching multiple to the same hook can always succeed,
> >> much like cgroup multi. Consider the following:
> >>
> >> To attach a shadow prog before F_FIRST, a caller could use F_BEFORE |
> >> F_FIRST |
> >> F_RDONLY. Attaching between first and the 'relative' section: F_AFTER =
|
> >> F_FIRST |
> >> F_RDONLY, etc. The rdonly flag could even be made redundant if a new p=
rog/
> >> attach type is added for progs like these.
> >>
> >> This is still perfectly possible to implement on top of Daniel's
> >> proposal, and
> >> to me looks like it could address many of the concerns around ordering=
 of
> >> progs I've seen in this thread, many mention data exfiltration.
> >
> > It may well be that semantics like this will turn out to be enough. Or
> > it may not (I personally believe we'll need something more expressive
> > still, and where the system admin has the option to override things; bu=
t
> > I may turn out to be wrong). Ultimately, my main point wrt this series
> > is that this kind of policy decision can be added later, and it's bette=
r
> > to merge the TCX infrastructure without it, instead of locking ourselve=
s
> > into an API that is way too limited today. TCX (and in-kernel XDP
> > multiprog) has value without it, so let's merge that first and iterate
> > on the policy aspects.
>
> That's okay and I'll do that for v3 to move on.
>
> I feel we might repeat the same discussion with no good solution for K8s
> users once we come back to this point again.
>
> Thanks,
> Daniel

