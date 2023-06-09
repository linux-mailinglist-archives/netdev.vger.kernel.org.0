Return-Path: <netdev+bounces-9672-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7B9B72A2AB
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:56:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A57E28198F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93274408E6;
	Fri,  9 Jun 2023 18:56:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765A1408C0;
	Fri,  9 Jun 2023 18:56:42 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8113C3592;
	Fri,  9 Jun 2023 11:56:39 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-51494659d49so3567824a12.3;
        Fri, 09 Jun 2023 11:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686336998; x=1688928998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4sS+5ZwLhZ8NfXRhex5Uf0bsyqsbPtXqZLLRo+Ppwv0=;
        b=X+Fo5dodJ/OKHcdq6TkSeShU/wlEfwyZkx8lidTbwih6SwJhp13oWzySf5Yuv+6sNI
         PJEF3vQu+snCtyc1X+itKUn6Abo0x7eS92gAL3dvtWCnqrNdIPjLtsqFGIqM7UHByUo9
         RHEcntcURP114pNLTAn+j+0kPgCB8yhP+Tns2rWGgfuDD4LNdtevOo6E1XOpQvsz89bk
         ZY6pReoDPZOhIam1+NCHO0V7JUj3MpPdJm/cVtXpSVDC02MKjnN7RjPmpxxtjyWKrnhf
         yW1i/E5y0t27+nxs6Ns4jX7KGwtdHSffk0CV8ersxVcifyHUn/un+EroVtKAwWas32wV
         VE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686336998; x=1688928998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4sS+5ZwLhZ8NfXRhex5Uf0bsyqsbPtXqZLLRo+Ppwv0=;
        b=glhs/61GB3XjSEJexOxC6yHkAqg730T6LjQV6yLtXfzH6CmBt4xn8bfUu8iXLwJfLT
         Szwy5yEvUtcMR+IjhOKmx0mytdckAXK4YjXhsrDs4JBwMVfuWpuDvFbvGzA32+vUzF2C
         bvyjtyv1naVls25s/4c3numGO+OzWuGTluJQ80gtHYBrhXu6puXIyjIPZUYAhnaSZeET
         SkyzxKWEffCNCGmSytxxiFUFFFgXfBsEDrRV66SqBYZNjf0mUnHxpTbvfK47W7MjeK3r
         lGNV5G1sCcZkHikJmJTRCDIl3T1MYJQ5LJIt43kb+s2vGjxj12ogX4oeci8CKQ2zLbTd
         vebQ==
X-Gm-Message-State: AC+VfDweZQhxUZGc/qzwFxpwvCdOgKDljT3NixeEaRvnoazsfJBZKjHW
	X/7kNQqc1yx4bYqfd9v1rATKlh/zHGxXIrqD5+o=
X-Google-Smtp-Source: ACHHUZ4EBqYn3k/EFZ4AZN/3nA6tyn5ujey1SdDxMrDovzAvIH+/kkPK+E2xp34tFGC8QbqYFF495RF63TQtQUH29Is=
X-Received: by 2002:a17:906:fe0c:b0:977:e310:1ce7 with SMTP id
 wy12-20020a170906fe0c00b00977e3101ce7mr2537274ejb.38.1686336997757; Fri, 09
 Jun 2023 11:56:37 -0700 (PDT)
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
 <874jng28xk.fsf@toke.dk> <1a73a1b9-c72a-de81-4fce-7ba4fb6d7900@incline.eu> <87sfb0zsok.fsf@toke.dk>
In-Reply-To: <87sfb0zsok.fsf@toke.dk>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 9 Jun 2023 11:56:25 -0700
Message-ID: <CAEf4BzYnZ0XoTY=JHEq3iicP8OVPDHfziJ=q_7_F5O=B0pX6tw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Cc: Timo Beckers <timo@incline.eu>, Daniel Borkmann <daniel@iogearbox.net>, 
	Stanislav Fomichev <sdf@google.com>, ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev, 
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

On Fri, Jun 9, 2023 at 6:11=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@kernel.org> wrote:
>
> Timo Beckers <timo@incline.eu> writes:
>
> > On 6/9/23 13:04, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> Daniel Borkmann <daniel@iogearbox.net> writes:
> >>
> >>>>>>>>> I'm still not sure whether the hard semantics of first/last is =
really
> >>>>>>>>> useful. My worry is that some prog will just use BPF_F_FIRST wh=
ich
> >>>>>>>>> would prevent the rest of the users.. (starting with only
> >>>>>>>>> F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if we r=
eally
> >>>>>>>>> need first/laste).
> >>>>>>>> Without FIRST/LAST some scenarios cannot be guaranteed to be saf=
ely
> >>>>>>>> implemented. E.g., if I have some hard audit requirements and I =
need
> >>>>>>>> to guarantee that my program runs first and observes each event,=
 I'll
> >>>>>>>> enforce BPF_F_FIRST when attaching it. And if that attachment fa=
ils,
> >>>>>>>> then server setup is broken and my application cannot function.
> >>>>>>>>
> >>>>>>>> In a setup where we expect multiple applications to co-exist, it
> >>>>>>>> should be a rule that no one is using FIRST/LAST (unless it's
> >>>>>>>> absolutely required). And if someone doesn't comply, then that's=
 a bug
> >>>>>>>> and has to be reported to application owners.
> >>>>>>>>
> >>>>>>>> But it's not up to the kernel to enforce this cooperation by
> >>>>>>>> disallowing FIRST/LAST semantics, because that semantics is crit=
ical
> >>>>>>>> for some applications, IMO.
> >>>>>>> Maybe that's something that should be done by some other mechanis=
m?
> >>>>>>> (and as a follow up, if needed) Something akin to what Toke
> >>>>>>> mentioned with another program doing sorting or similar.
> >>>>>> The goal of this API is to avoid needing some extra special progra=
m to
> >>>>>> do this sorting
> >>>>>>
> >>>>>>> Otherwise, those first/last are just plain simple old priority ba=
nds;
> >>>>>>> only we have two now, not u16.
> >>>>>> I think it's different. FIRST/LAST has to be used judiciously, of
> >>>>>> course, but when they are needed, they will have no alternative.
> >>>>>>
> >>>>>> Also, specifying FIRST + LAST is the way to say "I want my program=
 to
> >>>>>> be the only one attached". Should we encourage such use cases? No,=
 of
> >>>>>> course. But I think it's fair  for users to be able to express thi=
s.
> >>>>>>
> >>>>>>> I'm mostly coming from the observability point: imagine I have my=
 fancy
> >>>>>>> tc_ingress_tcpdump program that I want to attach as a first progr=
am to debug
> >>>>>>> some issue, but it won't work because there is already a 'first' =
program
> >>>>>>> installed.. Or the assumption that I'd do F_REPLACE | F_FIRST ?
> >>>>>> If your production setup requires that some important program has =
to
> >>>>>> be FIRST, then yeah, your "let me debug something" program shouldn=
't
> >>>>>> interfere with it (assuming that FIRST requirement is a real
> >>>>>> requirement and not someone just thinking they need to be first; b=
ut
> >>>>>> that's up to user space to decide). Maybe the solution for you in =
that
> >>>>>> case would be freplace program installed on top of that stubborn F=
IRST
> >>>>>> program? And if we are talking about local debugging and developme=
nt,
> >>>>>> then you are a sysadmin and you should be able to force-detach tha=
t
> >>>>>> program that is getting in the way.
> >>>>> I'm not really concerned about our production environment. It's pre=
tty
> >>>>> controlled and restricted and I'm pretty certain we can avoid doing
> >>>>> something stupid. Probably the same for your env.
> >>>>>
> >>>>> I'm mostly fantasizing about upstream world where different users d=
on't
> >>>>> know about each other and start doing stupid things like F_FIRST wh=
ere
> >>>>> they don't really have to be first. It's that "used judiciously" pa=
rt
> >>>>> that I'm a bit skeptical about :-D
> >>> But in the end how is that different from just attaching themselves b=
lindly
> >>> into the first position (e.g. with before and relative_fd as 0 or the=
 fd/id
> >>> of the current first program) - same, they don't really have to be fi=
rst.
> >>> How would that not result in doing something stupid? ;) To add to And=
rii's
> >>> earlier DDoS mitigation example ... think of K8s environment: one pro=
ject
> >>> is implementing DDoS mitigation with BPF, another one wants to monito=
r/
> >>> sample traffic to user space with BPF. Both install as first position=
 by
> >>> default (before + 0). In K8s, there is no built-in Pod dependency man=
agement
> >>> so you cannot guarantee whether Pod A comes up before Pod B. So you'l=
l end
> >>> up in a situation where sometimes the monitor runs before the DDoS mi=
tigation
> >>> and on some other nodes it's vice versa. The other case where this ge=
ts
> >>> broken (assuming a node where we get first the DDoS mitigation, then =
the
> >>> monitoring) is when you need to upgrade one of the Pods: monitoring P=
od
> >>> gets a new stable update and is being re-rolled out, then it inserts
> >>> itself before the DDoS mitigation mechanism, potentially causing outa=
ge.
> >>> With the first/last mechanism these two situations cannot happen. The=
 DDoS
> >>> mitigation software uses first and the monitoring uses before + 0, th=
en no
> >>> matter the re-rollouts or the ordering in which Pods come up, it's al=
ways
> >>> at the expected/correct location.
> >> I'm not disputing that these kinds of policy issues need to be solved
> >> somehow. But adding the first/last pinning as part of the kernel hooks
> >> doesn't solve the policy problem, it just hard-codes a solution for on=
e
> >> particular instance of the problem.
> >>
> >> Taking your example from above, what happens when someone wants to
> >> deploy those tools in reverse order? Say the monitoring tool counts
> >> packets and someone wants to also count the DDOS traffic; but the DDOS
> >> protection tool has decided for itself (by setting the FIRST) flag tha=
t
> >> it can *only* run as the first program, so there is no way to achieve
> >> this without modifying the application itself.
> >>
> >>>>> Because even with this new ordering scheme, there still should be
> >>>>> some entity to do relative ordering (systemd-style, maybe CNI?).
> >>>>> And if it does the ordering, I don't really see why we need
> >>>>> F_FIRST/F_LAST.
> >>>> I can see I'm a bit late to the party, but FWIW I agree with this:
> >>>> FIRST/LAST will definitely be abused if we add it. It also seems to =
me
> > It's in the prisoners' best interest to collaborate (and they do! see
> > https://www.youtube.com/watch?v=3DYK7GyEJdJGo), except the current
> > prio system is limiting and turns out to be really fragile in practice.
> >
> > If your tool wants to attach to tc prio 1 and there's already a prog
> > attached,
> > the most reliable option is basically to blindly replace the attachment=
,
> > unless
> > you have the possibility to inspect the attached prog and try to figure
> > out if it
> > belongs to another tool. This is fragile in and of itself, and only
> > possible on
> > more recent kernels iirc.
> >
> > With tcx, Cilium could make an initial attachment using F_FIRST and sim=
ply
> > update a link at well-known path on subsequent startups. If there's no
> > existing
> > link, and F_FIRST is taken, bail out with an error. The owner of the
> > existing
> > F_FIRST program can be queried and logged; we know for sure the program
> > doesn't belong to Cilium, and we have no interest in detaching it.
>
> That's conflating the benefit of F_FIRST with that of bpf_link, though;
> you can have the replace thing without the exclusive locking.

I think Timo says that he wants to install his bpf_link as the very
first decision-making BPF program (with F_FIRST) and make sure that
that spot stays the very first decision-making BPF program. And then
he can just do LINK_UPDATE to upgrade the underlying program.

I don't see anything being conflated here.

>
> >>> See above on the issues w/o the first/last. How would you work around=
 them
> >>> in practice so they cannot happen?
> >> By having an ordering configuration that is deterministic. Enforced by
> >> the system-wide management daemon by whichever mechanism suits it. We
> >> could implement a minimal reference policy agent that just reads a
> >> config file in /etc somewhere, and *that* could implement FIRST/LAST
> >> semantics.
> > I think this particular perspective is what's deadlocking this discussi=
on.
> > To me, it looks like distros and hyperscalers are in the same boat with
> > regards to the possibility of coordination between tools. Distros are o=
nly
> > responsible for the tools they package themselves, and hyperscalers
> > run a tight ship with mostly in-house tooling already. When it comes to
> > projects out in the wild, that all goes out the window.
>
> Not really: from the distro PoV we absolutely care about arbitrary
> combinations of programs with different authors. Which is why I'm
> arguing against putting anything into the kernel where the first program
> to come along can just grab a hook and lock everyone out.

What if some combinations of programs just cannot co-exist?


Me, Daniel, Timo are arguing that there are real situations where you
have to be first or need to die. And the counter argument we are
getting is "but someone can accidentally or in bad faith overuse
F_FIRST". The former is causing real problems and silent failures. The
latter is about fixing bugs and/or fighting bad actors. We don't
propose any real solution for the real first problem, because we are
afraid of hypothetical bad actors. The former has a technical solution
(F_FIRST/F_LAST), the latter is a matter of bug fixing and pushing
back on bad actors. This is where distros can actually help by making
sure that bad actors that don't really need F_FIRST/F_LAST are not
using them.

It's disturbing that we use the hypothetical "but users can be bad"
argument to prevent a solution to a technical problem that already
happened and will keep happening because there is no solution
available.

And the mythical user-space daemon that will solve all these problems
is not a convincing argument. I haven't seen any concrete proposals
beyond hand-wavy arguments.

>
> My assumption is basically this: A system administrator installs
> packages A and B that both use the TC hook. The developers of A and B
> have never heard about each other. It should be possible for that admin
> to run A and B in whichever order they like, without making any changes
> to A and B themselves.

That's impossible if A and B just cannot co-exist. E.g., if both A and
B are setting some socket options that are fundamentally in conflict.
You will have to either choose A or B, but not both. Or make sure A
and B somehow don't step on each other's toe. But it's not an ordering
problem. It's something that developers of A and B have to coordinate
between each other outside of the kernel.

>
> > Regardless of merit or feasability of a system-wide bpf management
> > daemon for k8s, there _is no ordering configuration possible_. K8s is n=
ot
> > a distro where package maintainers (or anyone else, really) can coordin=
ate
> > on correctly defining priority of each of the tools they ship. This is
> > effectively
> > the prisoner's dilemma. I feel like most of the discussion so far has b=
een
> > very hand-wavy in 'user space should solve it'. Well, we are user space=
, and
> > we're here trying to solve it. :)
> >
> > A hypothetical policy/gatekeeper/ordering daemon doesn't possess
> > implicit knowledge about which program needs to go where in the chain,
> > nor is there an obvious heuristic about how to order things. Maintainin=
g
> > such a configuration for all cloud-native tooling out there that possib=
ly
> > uses bpf is simply impossible, as even a tool like Cilium can change
> > dramatically from one release to the next. Having to manage this too
> > would put a significant burden on velocity and flexibility for arguably
> > little benefit to the user.
> >
> > So, daemon/kernel will need to be told how to order things, preferably =
by
> > the tools (Cilium/datadog-agent) themselves, since the user/admin of th=
e
> > system cannot be expected to know where to position the hundreds of pro=
gs
> > loaded by Cilium and how they might interfere with other tools. Figurin=
g
> > this out is the job of the tool, daemon or not.
> >
> > The prisoners _must_ communicate (so, not abuse F_FIRST) for things to
> > work correctly, and it's 100% in their best interest in doing so. Let's=
 not
> > pretend like we're able to solve game theory on this mailing list. :)
> > We'll have to settle for the next-best thing: give user space a safe an=
d
> > clear
> > API to allow it to coordinate and make the right decisions.
>
> But "always first" is not a meaningful concept. It's just what we have
> today (everyone picks priority 1), except now if there are two programs
> that want the same hook, it will be the first program that wins the
> contest (by locking the second one out), instead of the second program
> winning (by overriding the first one) as is the case with the silent
> override semantics we have with TC today. So we haven't solved the
> problem, we've just shifted the breakage.
>
> > To circle back to the observability case: in offline discussions with
> > Daniel,
> > I've mentioned the need for 'shadow' progs that only collect data and
> > pump it to user space, attached at specific points in the chain (still
> > within tcx!).
> > Their retcodes would be ignored, and context modifications would be
> > rejected, so attaching multiple to the same hook can always succeed,
> > much like cgroup multi. Consider the following:
> >
> > To attach a shadow prog before F_FIRST, a caller could use F_BEFORE |
> > F_FIRST |
> > F_RDONLY. Attaching between first and the 'relative' section: F_AFTER |
> > F_FIRST |
> > F_RDONLY, etc. The rdonly flag could even be made redundant if a new pr=
og/
> > attach type is added for progs like these.
> >
> > This is still perfectly possible to implement on top of Daniel's
> > proposal, and
> > to me looks like it could address many of the concerns around ordering =
of
> > progs I've seen in this thread, many mention data exfiltration.
>
> It may well be that semantics like this will turn out to be enough. Or
> it may not (I personally believe we'll need something more expressive
> still, and where the system admin has the option to override things; but
> I may turn out to be wrong). Ultimately, my main point wrt this series
> is that this kind of policy decision can be added later, and it's better
> to merge the TCX infrastructure without it, instead of locking ourselves
> into an API that is way too limited today. TCX (and in-kernel XDP
> multiprog) has value without it, so let's merge that first and iterate
> on the policy aspects.
>
> -Toke

