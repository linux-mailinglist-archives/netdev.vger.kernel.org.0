Return-Path: <netdev+bounces-9778-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D90D072A88B
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 04:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B1EB1C20D39
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 02:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 478F91C37;
	Sat, 10 Jun 2023 02:53:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CC61847;
	Sat, 10 Jun 2023 02:53:13 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409152733;
	Fri,  9 Jun 2023 19:53:10 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.west.internal (Postfix) with ESMTP id EB0C33200958;
	Fri,  9 Jun 2023 22:53:06 -0400 (EDT)
Received: from imap42 ([10.202.2.92])
  by compute1.internal (MEProxy); Fri, 09 Jun 2023 22:53:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm3; t=
	1686365586; x=1686451986; bh=AkQD7k4UePISznzhe6akvVmrU+fZyYsD1Ch
	HMlOviMo=; b=K/d9FqObUYosadrQdww/Jm6Ko8r21079rj/Kh/iHswObKm7lB1H
	fIjUYptyI2Pj+oJX/uurNKTfaTaPPAhMlnkVXZphv3Xl5xv3OUSktFxZo2Q3Z2zM
	edasb6c8lspT1Y11qYCrW1K7fWmt9SrHHwgwylMd5EFk5j8+9cFH4tA46Tj2QHSG
	lFQr+tDT8nctlCqKd2WRL9BfN5cZg1gEYQuDlLcVdc2hUqLA9qL18o9K2B5NlGVs
	MCvkCEQhlPGxWBds9mBOdIm9JlZGv3VJwko8C/R9CwtPZZBJJFyB1aEZDs3GZUqR
	anzr/f1P1df4CuWcD6vdZRzEKaSUFZ/9n2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1686365586; x=1686451986; bh=AkQD7k4UePISznzhe6akvVmrU+fZyYsD1Ch
	HMlOviMo=; b=EhJ4f6YHsDuRiTlJI0ucwLaz3CsfA95x2BtifgMM3uBqtP3OrSA
	xHKKGCJYSV1JaL6vykMBFuJM6WhohSflRtN0WAlAdNhO+xzmym2xHfsN0KxFdxm2
	iNOoo/+hJO+mDwpsA6NG6XkBKhqdPHmL6bBJoN221OnUo3NU2Jh4fHgGF6b+fTWH
	E+qHNw950LZJ+u7Nw+gsZhTYrQcoxyxnNKIMMyUUhRrAIGQ2aaKHm4kue++VHHLI
	A/jgaaKDTCIhsQeFRcXnbzp3Z5LdYWyCaO19FT7cAyCUxV/d5bmL2FuB0HSKpxyo
	hNFaz0bbzkRr5ejXGizxpKl89ssBHLCXSuA==
X-ME-Sender: <xms:keWDZKAhnZ7ohX1PVGJJEmuAeip0gQJBJ7fR8wv-g4JqJq9yPtnigw>
    <xme:keWDZEgtk7zIHcSdxp0uS3wes_DHJrhYPZo1hmyzjRqeeV8dZgueQow4rfzsxWX-L
    Z1y-WHb0VgbBpczlQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtledgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdludejmdenucfjughrpefofgggkfgjfhffhffvvefutgfgsehtqher
    tderreejnecuhfhrohhmpedfffgrnhhivghlucgiuhdfuceougiguhesugiguhhuuhdrgi
    ihiieqnecuggftrfgrthhtvghrnhepudehfedvkeeiheeggeevleejledtieekfeduveeg
    hedvfeeujedtudefkeegveeknecuffhomhgrihhnpeihohhuthhusggvrdgtohhmnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugig
    uhhuuhdrgiihii
X-ME-Proxy: <xmx:keWDZNlPGauNhJ9S5Q7tCiGmTHx30jEtWhHRRiQnDEYe_1_7JkNiLQ>
    <xmx:keWDZIxhc6ZAj4PWNfMdWUkO8LKwOGqMOoKs3s6GoP_4YReYVHmXXg>
    <xmx:keWDZPQUGBplm6Icfs-jCDNVeIh1tcym_kmh59DBzl8Dmh5CmnYkMQ>
    <xmx:kuWDZOIV2nVZrQMcpwMJO7r0ihZjk04rHBEiG25XiET8puVS91D9fw>
Feedback-ID: i6a694271:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id C8052BC0078; Fri,  9 Jun 2023 22:53:05 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-447-ge2460e13b3-fm-20230525.001-ge2460e13
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <6d76aed1-5bc8-42e1-9d50-277d2d66d57f@app.fastmail.com>
In-Reply-To: 
 <CAEf4Bzbs3Aujx_7YwisGs6-+Qdu+QuFUohKH-az24c6NciPhow@mail.gmail.com>
References: <20230607192625.22641-1-daniel@iogearbox.net>
 <20230607192625.22641-2-daniel@iogearbox.net> <ZIIOr1zvdRNTFKR7@google.com>
 <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com>
 <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
 <ZIJe5Ml6ILFa6tKP@google.com> <87a5x91nr8.fsf@toke.dk>
 <3a315a0d-52dd-7671-f6c1-bb681604c815@iogearbox.net> <874jng28xk.fsf@toke.dk>
 <1a73a1b9-c72a-de81-4fce-7ba4fb6d7900@incline.eu> <87sfb0zsok.fsf@toke.dk>
 <d0cf9a4f-c111-b594-7a12-84914419789e@iogearbox.net>
 <CAKH8qBuCug8HVxXF5hq00FxNtuyFbjJExJsrA+FCAfEmg36n3g@mail.gmail.com>
 <CAEf4Bzbs3Aujx_7YwisGs6-+Qdu+QuFUohKH-az24c6NciPhow@mail.gmail.com>
Date: Sat, 10 Jun 2023 08:22:39 +0530
From: "Daniel Xu" <dxu@dxuuu.xyz>
To: "Andrii Nakryiko" <andrii.nakryiko@gmail.com>,
 "Stanislav Fomichev" <sdf@google.com>
Cc: "Daniel Borkmann" <daniel@iogearbox.net>,
 =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
 "Timo Beckers" <timo@incline.eu>, "Alexei Starovoitov" <ast@kernel.org>,
 "Andrii Nakryiko" <andrii@kernel.org>, martin.lau@linux.dev,
 razor@blackwall.org, john.fastabend@gmail.com,
 "Jakub Kicinski" <kuba@kernel.org>, joe@cilium.io, davem@davemloft.net,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API for
 multi-progs
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi all,

On Sat, Jun 10, 2023, at 12:33 AM, Andrii Nakryiko wrote:
> On Fri, Jun 9, 2023 at 9:41=E2=80=AFAM Stanislav Fomichev <sdf@google.=
com> wrote:
>>
>> On Fri, Jun 9, 2023 at 7:15=E2=80=AFAM Daniel Borkmann <daniel@iogear=
box.net> wrote:
>> >
>> > On 6/9/23 3:11 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> > > Timo Beckers <timo@incline.eu> writes:
>> > >> On 6/9/23 13:04, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> > >>> Daniel Borkmann <daniel@iogearbox.net> writes:
>> > [...]
>> > >>>>>>>>>> I'm still not sure whether the hard semantics of first/l=
ast is really
>> > >>>>>>>>>> useful. My worry is that some prog will just use BPF_F_F=
IRST which
>> > >>>>>>>>>> would prevent the rest of the users.. (starting with only
>> > >>>>>>>>>> F_BEFORE/F_AFTER feels 'safer'; we can iterate later on =
if we really
>> > >>>>>>>>>> need first/laste).
>> > >>>>>>>>> Without FIRST/LAST some scenarios cannot be guaranteed to=
 be safely
>> > >>>>>>>>> implemented. E.g., if I have some hard audit requirements=
 and I need
>> > >>>>>>>>> to guarantee that my program runs first and observes each=
 event, I'll
>> > >>>>>>>>> enforce BPF_F_FIRST when attaching it. And if that attach=
ment fails,
>> > >>>>>>>>> then server setup is broken and my application cannot fun=
ction.
>> > >>>>>>>>>
>> > >>>>>>>>> In a setup where we expect multiple applications to co-ex=
ist, it
>> > >>>>>>>>> should be a rule that no one is using FIRST/LAST (unless =
it's
>> > >>>>>>>>> absolutely required). And if someone doesn't comply, then=
 that's a bug
>> > >>>>>>>>> and has to be reported to application owners.
>> > >>>>>>>>>
>> > >>>>>>>>> But it's not up to the kernel to enforce this cooperation=
 by
>> > >>>>>>>>> disallowing FIRST/LAST semantics, because that semantics =
is critical
>> > >>>>>>>>> for some applications, IMO.
>> > >>>>>>>> Maybe that's something that should be done by some other m=
echanism?
>> > >>>>>>>> (and as a follow up, if needed) Something akin to what Toke
>> > >>>>>>>> mentioned with another program doing sorting or similar.
>> > >>>>>>> The goal of this API is to avoid needing some extra special=
 program to
>> > >>>>>>> do this sorting
>> > >>>>>>>
>> > >>>>>>>> Otherwise, those first/last are just plain simple old prio=
rity bands;
>> > >>>>>>>> only we have two now, not u16.
>> > >>>>>>> I think it's different. FIRST/LAST has to be used judicious=
ly, of
>> > >>>>>>> course, but when they are needed, they will have no alterna=
tive.
>> > >>>>>>>
>> > >>>>>>> Also, specifying FIRST + LAST is the way to say "I want my =
program to
>> > >>>>>>> be the only one attached". Should we encourage such use cas=
es? No, of
>> > >>>>>>> course. But I think it's fair  for users to be able to expr=
ess this.
>> > >>>>>>>
>> > >>>>>>>> I'm mostly coming from the observability point: imagine I =
have my fancy
>> > >>>>>>>> tc_ingress_tcpdump program that I want to attach as a firs=
t program to debug
>> > >>>>>>>> some issue, but it won't work because there is already a '=
first' program
>> > >>>>>>>> installed.. Or the assumption that I'd do F_REPLACE | F_FI=
RST ?
>> > >>>>>>> If your production setup requires that some important progr=
am has to
>> > >>>>>>> be FIRST, then yeah, your "let me debug something" program =
shouldn't
>> > >>>>>>> interfere with it (assuming that FIRST requirement is a real
>> > >>>>>>> requirement and not someone just thinking they need to be f=
irst; but
>> > >>>>>>> that's up to user space to decide). Maybe the solution for =
you in that
>> > >>>>>>> case would be freplace program installed on top of that stu=
bborn FIRST
>> > >>>>>>> program? And if we are talking about local debugging and de=
velopment,
>> > >>>>>>> then you are a sysadmin and you should be able to force-det=
ach that
>> > >>>>>>> program that is getting in the way.
>> > >>>>>> I'm not really concerned about our production environment. I=
t's pretty
>> > >>>>>> controlled and restricted and I'm pretty certain we can avoi=
d doing
>> > >>>>>> something stupid. Probably the same for your env.
>> > >>>>>>
>> > >>>>>> I'm mostly fantasizing about upstream world where different =
users don't
>> > >>>>>> know about each other and start doing stupid things like F_F=
IRST where
>> > >>>>>> they don't really have to be first. It's that "used judiciou=
sly" part
>> > >>>>>> that I'm a bit skeptical about :-D
>> > >>>> But in the end how is that different from just attaching thems=
elves blindly
>> > >>>> into the first position (e.g. with before and relative_fd as 0=
 or the fd/id
>> > >>>> of the current first program) - same, they don't really have t=
o be first.
>> > >>>> How would that not result in doing something stupid? ;) To add=
 to Andrii's
>> > >>>> earlier DDoS mitigation example ... think of K8s environment: =
one project
>> > >>>> is implementing DDoS mitigation with BPF, another one wants to=
 monitor/
>> > >>>> sample traffic to user space with BPF. Both install as first p=
osition by
>> > >>>> default (before + 0). In K8s, there is no built-in Pod depende=
ncy management
>> > >>>> so you cannot guarantee whether Pod A comes up before Pod B. S=
o you'll end
>> > >>>> up in a situation where sometimes the monitor runs before the =
DDoS mitigation
>> > >>>> and on some other nodes it's vice versa. The other case where =
this gets
>> > >>>> broken (assuming a node where we get first the DDoS mitigation=
, then the
>> > >>>> monitoring) is when you need to upgrade one of the Pods: monit=
oring Pod
>> > >>>> gets a new stable update and is being re-rolled out, then it i=
nserts
>> > >>>> itself before the DDoS mitigation mechanism, potentially causi=
ng outage.
>> > >>>> With the first/last mechanism these two situations cannot happ=
en. The DDoS
>> > >>>> mitigation software uses first and the monitoring uses before =
+ 0, then no
>> > >>>> matter the re-rollouts or the ordering in which Pods come up, =
it's always
>> > >>>> at the expected/correct location.
>> > >>> I'm not disputing that these kinds of policy issues need to be =
solved
>> > >>> somehow. But adding the first/last pinning as part of the kerne=
l hooks
>> > >>> doesn't solve the policy problem, it just hard-codes a solution=
 for one
>> > >>> particular instance of the problem.
>> > >>>
>> > >>> Taking your example from above, what happens when someone wants=
 to
>> > >>> deploy those tools in reverse order? Say the monitoring tool co=
unts
>> > >>> packets and someone wants to also count the DDOS traffic; but t=
he DDOS
>> > >>> protection tool has decided for itself (by setting the FIRST) f=
lag that
>> > >>> it can *only* run as the first program, so there is no way to a=
chieve
>> > >>> this without modifying the application itself.
>> > >>>
>> > >>>>>> Because even with this new ordering scheme, there still shou=
ld be
>> > >>>>>> some entity to do relative ordering (systemd-style, maybe CN=
I?).
>> > >>>>>> And if it does the ordering, I don't really see why we need
>> > >>>>>> F_FIRST/F_LAST.
>> > >>>>> I can see I'm a bit late to the party, but FWIW I agree with =
this:
>> > >>>>> FIRST/LAST will definitely be abused if we add it. It also se=
ems to me
>> > >> It's in the prisoners' best interest to collaborate (and they do=
! see
>> > >> https://www.youtube.com/watch?v=3DYK7GyEJdJGo), except the curre=
nt
>> > >> prio system is limiting and turns out to be really fragile in pr=
actice.
>> > >>
>> > >> If your tool wants to attach to tc prio 1 and there's already a =
prog
>> > >> attached,
>> > >> the most reliable option is basically to blindly replace the att=
achment,
>> > >> unless
>> > >> you have the possibility to inspect the attached prog and try to=
 figure
>> > >> out if it
>> > >> belongs to another tool. This is fragile in and of itself, and o=
nly
>> > >> possible on
>> > >> more recent kernels iirc.
>> > >>
>> > >> With tcx, Cilium could make an initial attachment using F_FIRST =
and simply
>> > >> update a link at well-known path on subsequent startups. If ther=
e's no
>> > >> existing
>> > >> link, and F_FIRST is taken, bail out with an error. The owner of=
 the
>> > >> existing
>> > >> F_FIRST program can be queried and logged; we know for sure the =
program
>> > >> doesn't belong to Cilium, and we have no interest in detaching i=
t.
>> > >
>> > > That's conflating the benefit of F_FIRST with that of bpf_link, t=
hough;
>> > > you can have the replace thing without the exclusive locking.
>> > >
>> > >>>> See above on the issues w/o the first/last. How would you work=
 around them
>> > >>>> in practice so they cannot happen?
>> > >>> By having an ordering configuration that is deterministic. Enfo=
rced by
>> > >>> the system-wide management daemon by whichever mechanism suits =
it. We
>> > >>> could implement a minimal reference policy agent that just read=
s a
>> > >>> config file in /etc somewhere, and *that* could implement FIRST=
/LAST
>> > >>> semantics.
>> > >> I think this particular perspective is what's deadlocking this d=
iscussion.
>> > >> To me, it looks like distros and hyperscalers are in the same bo=
at with
>> > >> regards to the possibility of coordination between tools. Distro=
s are only
>> > >> responsible for the tools they package themselves, and hyperscal=
ers
>> > >> run a tight ship with mostly in-house tooling already. When it c=
omes to
>> > >> projects out in the wild, that all goes out the window.
>> > >
>> > > Not really: from the distro PoV we absolutely care about arbitrary
>> > > combinations of programs with different authors. Which is why I'm
>> > > arguing against putting anything into the kernel where the first =
program
>> > > to come along can just grab a hook and lock everyone out.
>> > >
>> > > My assumption is basically this: A system administrator installs
>> > > packages A and B that both use the TC hook. The developers of A a=
nd B
>> > > have never heard about each other. It should be possible for that=
 admin
>> > > to run A and B in whichever order they like, without making any c=
hanges
>> > > to A and B themselves.
>> >
>> > I would come with the point of view of the K8s cluster operator or =
platform
>> > engineer, if you will. Someone deeply familiar with K8s, but not ne=
cessarily
>> > knowing about kernel internals. I know my org needs to run containe=
r A and
>> > container B, so I'll deploy the daemon-sets for both and they get d=
eployed
>> > into my cluster. That platform engineer might have never heard of B=
PF or might
>> > not even know that container A or container B ships software with B=
PF. As
>> > mentioned, K8s itself has no concept of Pod ordering as its paradig=
m is that
>> > everything is loosely coupled. We are now expecting from that perso=
n to make
>> > a concrete decision about some BPF kernel internals on various hook=
s in which
>> > order they should be executed given if they don't then the system b=
ecomes
>> > non-deterministic. I think that is quite a big burden and ask to un=
derstand.
>> > Eventually that person will say that he/she cannot make this techni=
cal decision
>> > and that only one of the two containers can be deployed. I agree wi=
th you that
>> > there should be an option for a technically versed person to be abl=
e to change
>> > ordering to avoid lock out, but I don't think it will fly asking us=
ers to come
>> > up on their own with policies of BPF software in the wild ... simil=
ar as you
>> > probably don't want having to deal with writing systemd unit files =
for software
>> > xyz before you can use your laptop. It's a burden. You expect this =
to magically
>> > work by default and only if needed for good reasons to make custom =
changes.
>> > Just the one difference is that the latter ships with the OS (a pri=
ori known /
>> > tight-ship analogy).
>> >
>> > >> Regardless of merit or feasability of a system-wide bpf manageme=
nt
>> > >> daemon for k8s, there _is no ordering configuration possible_. K=
8s is not
>> > >> a distro where package maintainers (or anyone else, really) can =
coordinate
>> > >> on correctly defining priority of each of the tools they ship. T=
his is
>> > >> effectively
>> > >> the prisoner's dilemma. I feel like most of the discussion so fa=
r has been
>> > >> very hand-wavy in 'user space should solve it'. Well, we are use=
r space, and
>> > >> we're here trying to solve it. :)
>> > >>
>> > >> A hypothetical policy/gatekeeper/ordering daemon doesn't possess
>> > >> implicit knowledge about which program needs to go where in the =
chain,
>> > >> nor is there an obvious heuristic about how to order things. Mai=
ntaining
>> > >> such a configuration for all cloud-native tooling out there that=
 possibly
>> > >> uses bpf is simply impossible, as even a tool like Cilium can ch=
ange
>> > >> dramatically from one release to the next. Having to manage this=
 too
>> > >> would put a significant burden on velocity and flexibility for a=
rguably
>> > >> little benefit to the user.
>> > >>
>> > >> So, daemon/kernel will need to be told how to order things, pref=
erably by
>> > >> the tools (Cilium/datadog-agent) themselves, since the user/admi=
n of the
>> > >> system cannot be expected to know where to position the hundreds=
 of progs
>> > >> loaded by Cilium and how they might interfere with other tools. =
Figuring
>> > >> this out is the job of the tool, daemon or not.
>> > >>
>> > >> The prisoners _must_ communicate (so, not abuse F_FIRST) for thi=
ngs to
>> > >> work correctly, and it's 100% in their best interest in doing so=
. Let's not
>> > >> pretend like we're able to solve game theory on this mailing lis=
t. :)
>> > >> We'll have to settle for the next-best thing: give user space a =
safe and
>> > >> clear
>> > >> API to allow it to coordinate and make the right decisions.
>> > >
>> > > But "always first" is not a meaningful concept. It's just what we=
 have
>> > > today (everyone picks priority 1), except now if there are two pr=
ograms
>> > > that want the same hook, it will be the first program that wins t=
he
>> > > contest (by locking the second one out), instead of the second pr=
ogram
>> > > winning (by overriding the first one) as is the case with the sil=
ent
>> > > override semantics we have with TC today. So we haven't solved the
>> > > problem, we've just shifted the breakage.
>> >
>> > Fwiw, it's deterministic, and I think this 1000x better than silent=
ly
>> > having a non-deterministic deployment where the two programs ship w=
ith
>> > before + 0. That is much harder to debug.
>> >
>> > >> To circle back to the observability case: in offline discussions=
 with
>> > >> Daniel,
>> > >> I've mentioned the need for 'shadow' progs that only collect dat=
a and
>> > >> pump it to user space, attached at specific points in the chain =
(still
>> > >> within tcx!).
>> > >> Their retcodes would be ignored, and context modifications would=
 be
>> > >> rejected, so attaching multiple to the same hook can always succ=
eed,
>> > >> much like cgroup multi. Consider the following:
>> > >>
>> > >> To attach a shadow prog before F_FIRST, a caller could use F_BEF=
ORE |
>> > >> F_FIRST |
>> > >> F_RDONLY. Attaching between first and the 'relative' section: F_=
AFTER |
>> > >> F_FIRST |
>> > >> F_RDONLY, etc. The rdonly flag could even be made redundant if a=
 new prog/
>> > >> attach type is added for progs like these.
>> > >>
>> > >> This is still perfectly possible to implement on top of Daniel's
>> > >> proposal, and
>> > >> to me looks like it could address many of the concerns around or=
dering of
>> > >> progs I've seen in this thread, many mention data exfiltration.
>> > >
>> > > It may well be that semantics like this will turn out to be enoug=
h. Or
>> > > it may not (I personally believe we'll need something more expres=
sive
>> > > still, and where the system admin has the option to override thin=
gs; but
>> > > I may turn out to be wrong). Ultimately, my main point wrt this s=
eries
>> > > is that this kind of policy decision can be added later, and it's=
 better
>> > > to merge the TCX infrastructure without it, instead of locking ou=
rselves
>> > > into an API that is way too limited today. TCX (and in-kernel XDP
>> > > multiprog) has value without it, so let's merge that first and it=
erate
>> > > on the policy aspects.
>> >
>> > That's okay and I'll do that for v3 to move on.
>> >
>> > I feel we might repeat the same discussion with no good solution fo=
r K8s
>> > users once we come back to this point again.
>>
>> With your cilium vs ddos example, maybe all we really need is for the
>> program to have some signal about whether it's ok to have somebody
>> modify/drop the packets before it?
>> For example, the verifier, depending on whether it sees that the
>> program writes to the data, uses some helpers, or returns
>> TC_ACT_SHOT/etc can classify the program as readonly or non-readonly.
>> And then, we'll have some extra flag during program load/attach that
>> cilium will pass to express "I'm not ok with having a non-readonly
>> program before me".
>
> So this is what Timo is proposing with F_READONLY. And I agree, that
> makes sense and we've discussed the need for something like this
> internally. Specific use case was setsockopt programs. Sometimes they
> should just observe, and we'd like to enforce that.
>
> Once we have this F_READONLY flag support and enforce that during BPF
> program validation, then "I'm not ok with having a non-readonly
> program before me" is exactly F_FIRST. We just say that the F_READONLY
> program can be inserted anywhere because it has no effect on the state
> of the system.

I have a different use case for something like F_READONLY. Basically I w=
ould
like to be able to accept precompiled BPF progs from semi-trusted sources
and run / attach the prog in a trusted context. Example could be telling=
 the customer:
"give me a prog that you'd like to run against every packet that enters =
your network
and I will orchestrate / distribute it across your infrastructure". F_RE=
ADONLY could be
used as one of the mechanisms to uphold invariants like not being able t=
o bring
down the network.

Thanks,
Daniel

