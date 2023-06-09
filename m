Return-Path: <netdev+bounces-9676-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68BBA72A2BC
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:03:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E03B1C21040
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB45408F2;
	Fri,  9 Jun 2023 19:03:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B0F18C0F;
	Fri,  9 Jun 2023 19:03:39 +0000 (UTC)
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCE43592;
	Fri,  9 Jun 2023 12:03:36 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4f629ccb8ebso2679401e87.1;
        Fri, 09 Jun 2023 12:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686337415; x=1688929415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u9SMD1vjEZu2R3K3jVWlFJX/d0zNkYBwo8ESMyRIdVo=;
        b=aIp1Ih8/QEY2eygtZ6pGitcJH5I81m821Z6+sQ6ePZc0k+UibwdqgQdsrwfj3Qj/Xw
         +kfCbRJ2hcx5WRVieTDWhBF/JuyKAW91zHP4pK41J5RFf3flo+F5o98z7+TzA6NLHL0H
         Ed2NeC0mSJ2fvzKFicxcuFyIT1Mu36Dls5oboMS82XZik+uM6ouOx6MMFd4YSTLd2MP7
         B4KxxxGV8KzW991SjQq/QUJUBn92/w9RjoLi6UBCpq7y12N+FP1TUxKN1jZOZH2Ix3Yg
         nyoqy0ma34hoJpLF9PaRnEFeZ2/bRnW11rmTtduE+HZ0OYWMaXdsSJYOwIvwXJ+XoWaE
         YNkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686337415; x=1688929415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u9SMD1vjEZu2R3K3jVWlFJX/d0zNkYBwo8ESMyRIdVo=;
        b=gYlIYxkXL2KQSgfmBmzebxmtBoOa8umh62Xpgy3Z7RSWr6QV5MYlOEGJuHE1SuL843
         r5MQPRx1XUiY34AUOXfwA2tjoInRU8iNxhkVoN6PcJVKyInVm5qALObbRVGZv9u2PiJF
         s5PE582EXJas2KTQym1xXBUVJydel4PFsdIICSKVfwUldljQKQGkxn0V0Gh5y30qbS8e
         nvPzVsj2de3m/Zx4T9PMAO3hhXPWnpqn6rEyCjWGWo0NyD7sXWYGIaC2ZXoRyEzAy1KT
         ZYuQUBC4zT2zlZ/z8xeuWLJOOGi44iTi7tF039pfs+YfYUikI4HsyXh4NNVviscY+wzL
         0wYg==
X-Gm-Message-State: AC+VfDzZopSqpM+J1G/39Q+90Qevy6DPJZ3dM9jIpBpi77iyTg8YlCKl
	Xf95YwrJYyGuWuR2c3bOi2sFRpcvxed1+rBmA38=
X-Google-Smtp-Source: ACHHUZ7PNlSGADdEDvvz31QdZaYm3STnsk+HwhDvGzeK73nKdssiMcB5i1pUjv2KjLpVV9rMGAgBenUIMjZ9rFePFTs=
X-Received: by 2002:a2e:86cf:0:b0:2a7:8150:82c1 with SMTP id
 n15-20020a2e86cf000000b002a7815082c1mr1654788ljj.38.1686337414350; Fri, 09
 Jun 2023 12:03:34 -0700 (PDT)
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
 <87sfb0zsok.fsf@toke.dk> <d0cf9a4f-c111-b594-7a12-84914419789e@iogearbox.net> <CAKH8qBuCug8HVxXF5hq00FxNtuyFbjJExJsrA+FCAfEmg36n3g@mail.gmail.com>
In-Reply-To: <CAKH8qBuCug8HVxXF5hq00FxNtuyFbjJExJsrA+FCAfEmg36n3g@mail.gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 9 Jun 2023 12:03:21 -0700
Message-ID: <CAEf4Bzbs3Aujx_7YwisGs6-+Qdu+QuFUohKH-az24c6NciPhow@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
To: Stanislav Fomichev <sdf@google.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>, 
	Timo Beckers <timo@incline.eu>, ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev, 
	razor@blackwall.org, john.fastabend@gmail.com, kuba@kernel.org, dxu@dxuuu.xyz, 
	joe@cilium.io, davem@davemloft.net, bpf@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 9:41=E2=80=AFAM Stanislav Fomichev <sdf@google.com> =
wrote:
>
> On Fri, Jun 9, 2023 at 7:15=E2=80=AFAM Daniel Borkmann <daniel@iogearbox.=
net> wrote:
> >
> > On 6/9/23 3:11 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > > Timo Beckers <timo@incline.eu> writes:
> > >> On 6/9/23 13:04, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > >>> Daniel Borkmann <daniel@iogearbox.net> writes:
> > [...]
> > >>>>>>>>>> I'm still not sure whether the hard semantics of first/last =
is really
> > >>>>>>>>>> useful. My worry is that some prog will just use BPF_F_FIRST=
 which
> > >>>>>>>>>> would prevent the rest of the users.. (starting with only
> > >>>>>>>>>> F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if w=
e really
> > >>>>>>>>>> need first/laste).
> > >>>>>>>>> Without FIRST/LAST some scenarios cannot be guaranteed to be =
safely
> > >>>>>>>>> implemented. E.g., if I have some hard audit requirements and=
 I need
> > >>>>>>>>> to guarantee that my program runs first and observes each eve=
nt, I'll
> > >>>>>>>>> enforce BPF_F_FIRST when attaching it. And if that attachment=
 fails,
> > >>>>>>>>> then server setup is broken and my application cannot functio=
n.
> > >>>>>>>>>
> > >>>>>>>>> In a setup where we expect multiple applications to co-exist,=
 it
> > >>>>>>>>> should be a rule that no one is using FIRST/LAST (unless it's
> > >>>>>>>>> absolutely required). And if someone doesn't comply, then tha=
t's a bug
> > >>>>>>>>> and has to be reported to application owners.
> > >>>>>>>>>
> > >>>>>>>>> But it's not up to the kernel to enforce this cooperation by
> > >>>>>>>>> disallowing FIRST/LAST semantics, because that semantics is c=
ritical
> > >>>>>>>>> for some applications, IMO.
> > >>>>>>>> Maybe that's something that should be done by some other mecha=
nism?
> > >>>>>>>> (and as a follow up, if needed) Something akin to what Toke
> > >>>>>>>> mentioned with another program doing sorting or similar.
> > >>>>>>> The goal of this API is to avoid needing some extra special pro=
gram to
> > >>>>>>> do this sorting
> > >>>>>>>
> > >>>>>>>> Otherwise, those first/last are just plain simple old priority=
 bands;
> > >>>>>>>> only we have two now, not u16.
> > >>>>>>> I think it's different. FIRST/LAST has to be used judiciously, =
of
> > >>>>>>> course, but when they are needed, they will have no alternative=
.
> > >>>>>>>
> > >>>>>>> Also, specifying FIRST + LAST is the way to say "I want my prog=
ram to
> > >>>>>>> be the only one attached". Should we encourage such use cases? =
No, of
> > >>>>>>> course. But I think it's fair  for users to be able to express =
this.
> > >>>>>>>
> > >>>>>>>> I'm mostly coming from the observability point: imagine I have=
 my fancy
> > >>>>>>>> tc_ingress_tcpdump program that I want to attach as a first pr=
ogram to debug
> > >>>>>>>> some issue, but it won't work because there is already a 'firs=
t' program
> > >>>>>>>> installed.. Or the assumption that I'd do F_REPLACE | F_FIRST =
?
> > >>>>>>> If your production setup requires that some important program h=
as to
> > >>>>>>> be FIRST, then yeah, your "let me debug something" program shou=
ldn't
> > >>>>>>> interfere with it (assuming that FIRST requirement is a real
> > >>>>>>> requirement and not someone just thinking they need to be first=
; but
> > >>>>>>> that's up to user space to decide). Maybe the solution for you =
in that
> > >>>>>>> case would be freplace program installed on top of that stubbor=
n FIRST
> > >>>>>>> program? And if we are talking about local debugging and develo=
pment,
> > >>>>>>> then you are a sysadmin and you should be able to force-detach =
that
> > >>>>>>> program that is getting in the way.
> > >>>>>> I'm not really concerned about our production environment. It's =
pretty
> > >>>>>> controlled and restricted and I'm pretty certain we can avoid do=
ing
> > >>>>>> something stupid. Probably the same for your env.
> > >>>>>>
> > >>>>>> I'm mostly fantasizing about upstream world where different user=
s don't
> > >>>>>> know about each other and start doing stupid things like F_FIRST=
 where
> > >>>>>> they don't really have to be first. It's that "used judiciously"=
 part
> > >>>>>> that I'm a bit skeptical about :-D
> > >>>> But in the end how is that different from just attaching themselve=
s blindly
> > >>>> into the first position (e.g. with before and relative_fd as 0 or =
the fd/id
> > >>>> of the current first program) - same, they don't really have to be=
 first.
> > >>>> How would that not result in doing something stupid? ;) To add to =
Andrii's
> > >>>> earlier DDoS mitigation example ... think of K8s environment: one =
project
> > >>>> is implementing DDoS mitigation with BPF, another one wants to mon=
itor/
> > >>>> sample traffic to user space with BPF. Both install as first posit=
ion by
> > >>>> default (before + 0). In K8s, there is no built-in Pod dependency =
management
> > >>>> so you cannot guarantee whether Pod A comes up before Pod B. So yo=
u'll end
> > >>>> up in a situation where sometimes the monitor runs before the DDoS=
 mitigation
> > >>>> and on some other nodes it's vice versa. The other case where this=
 gets
> > >>>> broken (assuming a node where we get first the DDoS mitigation, th=
en the
> > >>>> monitoring) is when you need to upgrade one of the Pods: monitorin=
g Pod
> > >>>> gets a new stable update and is being re-rolled out, then it inser=
ts
> > >>>> itself before the DDoS mitigation mechanism, potentially causing o=
utage.
> > >>>> With the first/last mechanism these two situations cannot happen. =
The DDoS
> > >>>> mitigation software uses first and the monitoring uses before + 0,=
 then no
> > >>>> matter the re-rollouts or the ordering in which Pods come up, it's=
 always
> > >>>> at the expected/correct location.
> > >>> I'm not disputing that these kinds of policy issues need to be solv=
ed
> > >>> somehow. But adding the first/last pinning as part of the kernel ho=
oks
> > >>> doesn't solve the policy problem, it just hard-codes a solution for=
 one
> > >>> particular instance of the problem.
> > >>>
> > >>> Taking your example from above, what happens when someone wants to
> > >>> deploy those tools in reverse order? Say the monitoring tool counts
> > >>> packets and someone wants to also count the DDOS traffic; but the D=
DOS
> > >>> protection tool has decided for itself (by setting the FIRST) flag =
that
> > >>> it can *only* run as the first program, so there is no way to achie=
ve
> > >>> this without modifying the application itself.
> > >>>
> > >>>>>> Because even with this new ordering scheme, there still should b=
e
> > >>>>>> some entity to do relative ordering (systemd-style, maybe CNI?).
> > >>>>>> And if it does the ordering, I don't really see why we need
> > >>>>>> F_FIRST/F_LAST.
> > >>>>> I can see I'm a bit late to the party, but FWIW I agree with this=
:
> > >>>>> FIRST/LAST will definitely be abused if we add it. It also seems =
to me
> > >> It's in the prisoners' best interest to collaborate (and they do! se=
e
> > >> https://www.youtube.com/watch?v=3DYK7GyEJdJGo), except the current
> > >> prio system is limiting and turns out to be really fragile in practi=
ce.
> > >>
> > >> If your tool wants to attach to tc prio 1 and there's already a prog
> > >> attached,
> > >> the most reliable option is basically to blindly replace the attachm=
ent,
> > >> unless
> > >> you have the possibility to inspect the attached prog and try to fig=
ure
> > >> out if it
> > >> belongs to another tool. This is fragile in and of itself, and only
> > >> possible on
> > >> more recent kernels iirc.
> > >>
> > >> With tcx, Cilium could make an initial attachment using F_FIRST and =
simply
> > >> update a link at well-known path on subsequent startups. If there's =
no
> > >> existing
> > >> link, and F_FIRST is taken, bail out with an error. The owner of the
> > >> existing
> > >> F_FIRST program can be queried and logged; we know for sure the prog=
ram
> > >> doesn't belong to Cilium, and we have no interest in detaching it.
> > >
> > > That's conflating the benefit of F_FIRST with that of bpf_link, thoug=
h;
> > > you can have the replace thing without the exclusive locking.
> > >
> > >>>> See above on the issues w/o the first/last. How would you work aro=
und them
> > >>>> in practice so they cannot happen?
> > >>> By having an ordering configuration that is deterministic. Enforced=
 by
> > >>> the system-wide management daemon by whichever mechanism suits it. =
We
> > >>> could implement a minimal reference policy agent that just reads a
> > >>> config file in /etc somewhere, and *that* could implement FIRST/LAS=
T
> > >>> semantics.
> > >> I think this particular perspective is what's deadlocking this discu=
ssion.
> > >> To me, it looks like distros and hyperscalers are in the same boat w=
ith
> > >> regards to the possibility of coordination between tools. Distros ar=
e only
> > >> responsible for the tools they package themselves, and hyperscalers
> > >> run a tight ship with mostly in-house tooling already. When it comes=
 to
> > >> projects out in the wild, that all goes out the window.
> > >
> > > Not really: from the distro PoV we absolutely care about arbitrary
> > > combinations of programs with different authors. Which is why I'm
> > > arguing against putting anything into the kernel where the first prog=
ram
> > > to come along can just grab a hook and lock everyone out.
> > >
> > > My assumption is basically this: A system administrator installs
> > > packages A and B that both use the TC hook. The developers of A and B
> > > have never heard about each other. It should be possible for that adm=
in
> > > to run A and B in whichever order they like, without making any chang=
es
> > > to A and B themselves.
> >
> > I would come with the point of view of the K8s cluster operator or plat=
form
> > engineer, if you will. Someone deeply familiar with K8s, but not necess=
arily
> > knowing about kernel internals. I know my org needs to run container A =
and
> > container B, so I'll deploy the daemon-sets for both and they get deplo=
yed
> > into my cluster. That platform engineer might have never heard of BPF o=
r might
> > not even know that container A or container B ships software with BPF. =
As
> > mentioned, K8s itself has no concept of Pod ordering as its paradigm is=
 that
> > everything is loosely coupled. We are now expecting from that person to=
 make
> > a concrete decision about some BPF kernel internals on various hooks in=
 which
> > order they should be executed given if they don't then the system becom=
es
> > non-deterministic. I think that is quite a big burden and ask to unders=
tand.
> > Eventually that person will say that he/she cannot make this technical =
decision
> > and that only one of the two containers can be deployed. I agree with y=
ou that
> > there should be an option for a technically versed person to be able to=
 change
> > ordering to avoid lock out, but I don't think it will fly asking users =
to come
> > up on their own with policies of BPF software in the wild ... similar a=
s you
> > probably don't want having to deal with writing systemd unit files for =
software
> > xyz before you can use your laptop. It's a burden. You expect this to m=
agically
> > work by default and only if needed for good reasons to make custom chan=
ges.
> > Just the one difference is that the latter ships with the OS (a priori =
known /
> > tight-ship analogy).
> >
> > >> Regardless of merit or feasability of a system-wide bpf management
> > >> daemon for k8s, there _is no ordering configuration possible_. K8s i=
s not
> > >> a distro where package maintainers (or anyone else, really) can coor=
dinate
> > >> on correctly defining priority of each of the tools they ship. This =
is
> > >> effectively
> > >> the prisoner's dilemma. I feel like most of the discussion so far ha=
s been
> > >> very hand-wavy in 'user space should solve it'. Well, we are user sp=
ace, and
> > >> we're here trying to solve it. :)
> > >>
> > >> A hypothetical policy/gatekeeper/ordering daemon doesn't possess
> > >> implicit knowledge about which program needs to go where in the chai=
n,
> > >> nor is there an obvious heuristic about how to order things. Maintai=
ning
> > >> such a configuration for all cloud-native tooling out there that pos=
sibly
> > >> uses bpf is simply impossible, as even a tool like Cilium can change
> > >> dramatically from one release to the next. Having to manage this too
> > >> would put a significant burden on velocity and flexibility for argua=
bly
> > >> little benefit to the user.
> > >>
> > >> So, daemon/kernel will need to be told how to order things, preferab=
ly by
> > >> the tools (Cilium/datadog-agent) themselves, since the user/admin of=
 the
> > >> system cannot be expected to know where to position the hundreds of =
progs
> > >> loaded by Cilium and how they might interfere with other tools. Figu=
ring
> > >> this out is the job of the tool, daemon or not.
> > >>
> > >> The prisoners _must_ communicate (so, not abuse F_FIRST) for things =
to
> > >> work correctly, and it's 100% in their best interest in doing so. Le=
t's not
> > >> pretend like we're able to solve game theory on this mailing list. :=
)
> > >> We'll have to settle for the next-best thing: give user space a safe=
 and
> > >> clear
> > >> API to allow it to coordinate and make the right decisions.
> > >
> > > But "always first" is not a meaningful concept. It's just what we hav=
e
> > > today (everyone picks priority 1), except now if there are two progra=
ms
> > > that want the same hook, it will be the first program that wins the
> > > contest (by locking the second one out), instead of the second progra=
m
> > > winning (by overriding the first one) as is the case with the silent
> > > override semantics we have with TC today. So we haven't solved the
> > > problem, we've just shifted the breakage.
> >
> > Fwiw, it's deterministic, and I think this 1000x better than silently
> > having a non-deterministic deployment where the two programs ship with
> > before + 0. That is much harder to debug.
> >
> > >> To circle back to the observability case: in offline discussions wit=
h
> > >> Daniel,
> > >> I've mentioned the need for 'shadow' progs that only collect data an=
d
> > >> pump it to user space, attached at specific points in the chain (sti=
ll
> > >> within tcx!).
> > >> Their retcodes would be ignored, and context modifications would be
> > >> rejected, so attaching multiple to the same hook can always succeed,
> > >> much like cgroup multi. Consider the following:
> > >>
> > >> To attach a shadow prog before F_FIRST, a caller could use F_BEFORE =
|
> > >> F_FIRST |
> > >> F_RDONLY. Attaching between first and the 'relative' section: F_AFTE=
R |
> > >> F_FIRST |
> > >> F_RDONLY, etc. The rdonly flag could even be made redundant if a new=
 prog/
> > >> attach type is added for progs like these.
> > >>
> > >> This is still perfectly possible to implement on top of Daniel's
> > >> proposal, and
> > >> to me looks like it could address many of the concerns around orderi=
ng of
> > >> progs I've seen in this thread, many mention data exfiltration.
> > >
> > > It may well be that semantics like this will turn out to be enough. O=
r
> > > it may not (I personally believe we'll need something more expressive
> > > still, and where the system admin has the option to override things; =
but
> > > I may turn out to be wrong). Ultimately, my main point wrt this serie=
s
> > > is that this kind of policy decision can be added later, and it's bet=
ter
> > > to merge the TCX infrastructure without it, instead of locking oursel=
ves
> > > into an API that is way too limited today. TCX (and in-kernel XDP
> > > multiprog) has value without it, so let's merge that first and iterat=
e
> > > on the policy aspects.
> >
> > That's okay and I'll do that for v3 to move on.
> >
> > I feel we might repeat the same discussion with no good solution for K8=
s
> > users once we come back to this point again.
>
> With your cilium vs ddos example, maybe all we really need is for the
> program to have some signal about whether it's ok to have somebody
> modify/drop the packets before it?
> For example, the verifier, depending on whether it sees that the
> program writes to the data, uses some helpers, or returns
> TC_ACT_SHOT/etc can classify the program as readonly or non-readonly.
> And then, we'll have some extra flag during program load/attach that
> cilium will pass to express "I'm not ok with having a non-readonly
> program before me".

So this is what Timo is proposing with F_READONLY. And I agree, that
makes sense and we've discussed the need for something like this
internally. Specific use case was setsockopt programs. Sometimes they
should just observe, and we'd like to enforce that.

Once we have this F_READONLY flag support and enforce that during BPF
program validation, then "I'm not ok with having a non-readonly
program before me" is exactly F_FIRST. We just say that the F_READONLY
program can be inserted anywhere because it has no effect on the state
of the system.

>
> Seems doable? If it makes sense, we can try to do this as a follow up.
> It should solve some simple cases without an external arbiter.

Yes, and we can add that on top of current F_FIRST/F_LAST. Currently
we have to pessimistically assume that every program is non-readonly
and F_FIRST/F_LAST applies to just non-readonly programs.

