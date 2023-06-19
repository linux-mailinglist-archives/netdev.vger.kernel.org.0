Return-Path: <netdev+bounces-11863-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42BA1734F12
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02552280FDC
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D88BE47;
	Mon, 19 Jun 2023 09:05:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766615250;
	Mon, 19 Jun 2023 09:05:26 +0000 (UTC)
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC2598;
	Mon, 19 Jun 2023 02:05:23 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2b46f5f4d79so17049201fa.1;
        Mon, 19 Jun 2023 02:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687165522; x=1689757522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eJJKca4tPMA3l0zwgqCHcv2YL2D4mtsbDzrjIEUgm6g=;
        b=iZptSveC11F42LeEGdiaAxo7uJm8MruaNiLPpzZ20NIvuYQ+aO2pHPC3jUko3cnM6J
         GHaB+O3PYUtebQ2tMTZAfK5sxpzF+wUs/brUrF+rePAMbOPBJLuC/gozrkCqowr9lVwq
         q/Zm7opoxaZgbFOxPN83X/j9UAUoc4YovUnGxZiDD2XdHMHYfbQ7PSaFyUr2k66y4t8s
         qAmA7L65cx2rm4FmOuyYLw2tsXQ96KYFrKxB3eAl+dlR6eANX8U2y3mBd6dZlsG2AYkj
         MxAW4J+nHL7AVWpA1m+yxjn9JOnplPpLXuvBff56JBh7FtpwOnR9A6LUOR462KFWJ5T1
         siHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687165522; x=1689757522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eJJKca4tPMA3l0zwgqCHcv2YL2D4mtsbDzrjIEUgm6g=;
        b=HwmD1A+vhfkeMX99bMI9+le3akytBWbFovGG2SpgRJ0yEHN4MR/KgWAG6jCpe6vyFH
         OUMcEMAJBvJPgbbY/OqWvYXLSn+O/6Pj4owJDCclM5KlfwmSFVt3mYWr9A2X+iVhObtb
         Hu19TYVNN6Baoc0QV2ZFNaGc6jTcDolZjsseVJjh49qGGQ4b3peZz3H3iXGZgRCgeKJd
         sbLrxvHWGLv5e1HnMTU1Kwa71uB2z3/Pk38Ud+5Rx0XMTfcK2PctHgFGOZsUAskhFDLb
         kGBXnC2vfdra6RmDR8Qb4uXGxv5hGqEncgkePsZTUltQkgm6E9mZdZZ2vtM+9v53OkfR
         fXPw==
X-Gm-Message-State: AC+VfDzXgmz4MftZ2At6r0BCc2uXKSFBOgsacqgj2vWFsHuyKcg4OwTb
	9MHSvEC2L2C4xlQh+r3nhWe3gQke435iVzUaLgA=
X-Google-Smtp-Source: ACHHUZ5bWbXwUwgONA9maayLmw+LDtLF0CuxNgnejJ4LOMS6xOiH5coyrWNrzO6tBz1BshSD/ukKvJ2KNlFtuJkRK8s=
X-Received: by 2002:a2e:958e:0:b0:2b4:788d:a36e with SMTP id
 w14-20020a2e958e000000b002b4788da36emr757128ljh.20.1687165521677; Mon, 19 Jun
 2023 02:05:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230516111823.2103536-1-starmiku1207184332@gmail.com>
 <e37c0a65-a3f6-e2e6-c2ad-367db20253a0@meta.com> <CALyQVax8X63qekZVhvRTmZFFs+ucPKRkBB7UnRZk6Hu3ggi7Og@mail.gmail.com>
 <57dc6a0e-6ba9-e77c-80ac-6bb0a6e2650a@meta.com> <CALyQVazb=D1ejapiFdTnan6JbjFJA2q9ifhSsmF4OC9MDz3oAw@mail.gmail.com>
 <d027cb6b-e32c-36ad-3aba-9a7b1177f89f@meta.com> <CALyQVayW7e4FPbaMNNuOmYGYt5pcd47zsx2xVkrekEDaVm7H2g@mail.gmail.com>
 <113dc8c1-0840-9ee3-2840-28246731604c@meta.com> <CALyQVaxFKisZ_4DjofVE9PH+nFcOKSMJG4XDkn1znsqU+EnYHw@mail.gmail.com>
 <c6e4aa90-aa35-fa42-1196-a71c88994620@meta.com>
In-Reply-To: <c6e4aa90-aa35-fa42-1196-a71c88994620@meta.com>
From: Teng Qi <starmiku1207184332@gmail.com>
Date: Mon, 19 Jun 2023 17:05:07 +0800
Message-ID: <CALyQVayjJ_q5su8fXgx-UCtZi4+ig6OUm0jXhNdoqkYnXSy9RA@mail.gmail.com>
Subject: Re: [bug] kernel: bpf: syscall: a possible sleep-in-atomic bug in __bpf_prog_put()
To: Yonghong Song <yhs@meta.com>
Cc: ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com, 
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, 
	kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, 
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello!

> It would be great if you also print out in_interrupt() value, so we know
> whether softirq or nmi is enabled or not.

After adding the in_interrupt(), the interesting output cases are as follow=
s:
[ 38.596580] bpf_prog_put: in_irq() 0, irqs_disabled() 0, in_interrupt() 25=
6,
        preempt_count() 256, in_atomic() 1, rcu_read_lock_held() 0
[ 62.300608] bpf_prog_put: in_irq() 0, irqs_disabled() 0, in_interrupt() 25=
6,
        preempt_count() 256, in_atomic() 1, rcu_read_lock_held() 1
[ 62.301179] bpf_prog_put: in_irq() 0, irqs_disabled() 0, in_interrupt() 0,
        preempt_count() 0, in_atomic() 0, rcu_read_lock_held() 1

Based on these cases, the current code is safe for the first two cases, bec=
ause
        in_interrupt() in vfree() prevents sleeping.
However, the rcu_read_lock_held() is not reliable, so we cannot rely on it.
Considering all the discussions so far, I think the best plan now is to cha=
nge
the condition in __bpf_prog_put() to =E2=80=98irqs_disabled() || in_atomic(=
)=E2=80=99 and
provide examples for possible issues. This plan effectively addresses
more possible atomic contexts of __bpf_prog_put() without incurring
any additional cost.
-- Teng Qi

On Mon, Jun 12, 2023 at 8:02=E2=80=AFAM Yonghong Song <yhs@meta.com> wrote:
>
>
>
> On 6/11/23 6:02 AM, Teng Qi wrote:
> > Hello!
> >> BTW, please do create a test case, e.g, sockmap test case which
> >> can show the problem with existing code base.
> >
> > I add a printk in bpf_prog_put_deferred():
> > static void bpf_prog_put_deferred(struct work_struct *work)
> > {
> >          // . . .
> >          int inIrq =3D in_irq();
> >          int irqsDisabled =3D irqs_disabled();
> >          int preemptBits =3D preempt_count();
> >          int inAtomic =3D in_atomic();
> >          int rcuHeld =3D rcu_read_lock_held();
> >          printk("bpf_prog_put: in_irq() %d, irqs_disabled() %d, preempt=
_count()
> >           %d, in_atomic() %d, rcu_read_lock_held() %d",
> >          inIrq, irqsDisabled, preemptBits, inAtomic, rcuHeld);
> >          // . . .
> > }
> >
> > When running the selftest, I see the following output:
> > [255340.388339] bpf_prog_put: in_irq() 0, irqs_disabled() 0,
> >          preempt_count() 256, in_atomic() 1, rcu_read_lock_held() 1
> > [255393.237632] bpf_prog_put: in_irq() 0, irqs_disabled() 0,
> >          preempt_count() 0, in_atomic() 0, rcu_read_lock_held() 1
>
> It would be great if you also print out in_interrupt() value, so we know
> whether softirq or nmi is enabled or not.
>
> We cannot really WARN with !rcu_read_lock_held() since the
> __bpf_prog_put funciton is called in different contexts.
>
> Also, note that rcu_read_lock_held() may not be reliable. rcu subsystem
> will return 1 if not tracked or not sure about the result.
>
> >
> > Based on this output, I believe it is sufficient to construct a self-te=
st case
> > for bpf_prog_put_deferred() called under preempt disabled or rcu read l=
ock
> > region. However, I'm a bit confused about what I should do to build the
> > self-test case. Are we looking to create a checker that verifies the
> > context of bpf_prog_put_deferred() is valid? Or do we need a test case =
that
> > can trigger this bug?
> >
> > Could you show me more ideas to construct a self test case? I am not fa=
miliar
> > with it and have no idea.
>
> Okay, I see. It seems hard to create a test case with warnings since
> bpf_prog_put_deferred is called in different context. So some
> examples for possible issues (through code analysis) should be good enoug=
h.
>
> >
> > -- Teng Qi
> >
> > On Thu, May 25, 2023 at 3:34=E2=80=AFAM Yonghong Song <yhs@meta.com> wr=
ote:
> >>
> >>
> >>
> >> On 5/24/23 5:42 AM, Teng Qi wrote:
> >>> Thank you.
> >>>
> >>>> We cannot use rcu_read_lock_held() in the 'if' statement. The return
> >>>> value rcu_read_lock_held() could be 1 for some configurations regard=
less
> >>>> whether rcu_read_lock() is really held or not. In most cases,
> >>>> rcu_read_lock_held() is used in issuing potential warnings.
> >>>> Maybe there are other ways to record whether rcu_read_lock() is held=
 or not?
> >>>
> >>> Sorry. I was not aware of the dependency of configurations of
> >>> rcu_read_lock_held().
> >>>
> >>>> If we cannot resolve rcu_read_lock() presence issue, maybe the condi=
tion
> >>>> can be !in_interrupt(), so any process-context will go to a workqueu=
e.
> >>>
> >>> I agree that using !in_interrupt() as a condition is an acceptable so=
lution.
> >>
> >> This should work although it could be conservative.
> >>
> >>>
> >>>> Alternatively, we could have another solution. We could add another
> >>>> function e.g., bpf_prog_put_rcu(), which indicates that bpf_prog_put=
()
> >>>> will be done in rcu context.
> >>>
> >>> Implementing a new function like bpf_prog_put_rcu() is a solution tha=
t involves
> >>> more significant changes.
> >>
> >> Maybe we can change signature of bpf_prog_put instead? Like
> >>      void bpf_prog_put(struct bpf_prog *prog, bool in_rcu)
> >> and inside bpf_prog_put we can add
> >>      WARN_ON_ONCE(in_rcu && !bpf_rcu_lock_held());
> >>
> >>>
> >>>> So if in_interrupt(), do kvfree, otherwise,
> >>>> put into a workqueue.
> >>>
> >>> Shall we proceed with submitting a patch following this approach?
> >>
> >> You could choose either of the above although I think with newer
> >> bpf_prog_put() is better.
> >>
> >> BTW, please do create a test case, e.g, sockmap test case which
> >> can show the problem with existing code base.
> >>
> >>>
> >>> I would like to mention something unrelated to the possible bug. At t=
his
> >>> moment, things seem to be more puzzling. vfree() is safe under in_int=
errupt()
> >>> but not safe under other atomic contexts.
> >>> This disorder challenges our conventional belief, a monotonic increme=
ntation
> >>> of limitations of the hierarchical atomic contexts, that programer ne=
eds
> >>> to be more and more careful to write code under rcu read lock, spin l=
ock,
> >>> bh disable, interrupt...
> >>> This disorder can lead to unexpected consequences, such as code being=
 safe
> >>> under interrupts but not safe under spin locks.
> >>> The disorder makes kernel programming more complex and may result in =
more bugs.
> >>> Even though we find a way to resolve the possible bug about the bpf_p=
rog_put(),
> >>> I feel sad for undermining of kernel`s maintainability and disorder o=
f
> >>> hierarchy of atomic contexts.
> >>>
> >>> -- Teng Qi
> >>>
> >>> On Tue, May 23, 2023 at 12:33=E2=80=AFPM Yonghong Song <yhs@meta.com>=
 wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 5/21/23 6:39 AM, Teng Qi wrote:
> >>>>> Thank you.
> >>>>>
> >>>>>    > Your above analysis makes sense if indeed that kvfree cannot a=
ppear
> >>>>>    > inside a spin lock region or RCU read lock region. But is it t=
rue?
> >>>>>    > I checked a few code paths in kvfree/kfree. It is either guard=
ed
> >>>>>    > with local_irq_save/restore or by
> >>>>>    > spin_lock_irqsave/spin_unlock_
> >>>>>    > irqrestore, etc. Did I miss
> >>>>>    > anything? Are you talking about RT kernel here?
> >>>>>
> >>>>> To see the sleepable possibility of kvfree, it is important to anal=
yze the
> >>>>> following calling stack:
> >>>>> mm/util.c: 645 kvfree()
> >>>>> mm/vmalloc.c: 2763 vfree()
> >>>>>
> >>>>> In kvfree(), to call vfree, if the pointer addr points to memory
> >>>>> allocated by
> >>>>> vmalloc(), it calls vfree().
> >>>>> void kvfree(const void *addr)
> >>>>> {
> >>>>>            if (is_vmalloc_addr(addr))
> >>>>>                    vfree(addr);
> >>>>>            else
> >>>>>                    kfree(addr);
> >>>>> }
> >>>>>
> >>>>> In vfree(), in_interrupt() and might_sleep() need to be considered.
> >>>>> void vfree(const void *addr)
> >>>>> {
> >>>>>            // ...
> >>>>>            if (unlikely(in_interrupt()))
> >>>>>            {
> >>>>>                    vfree_atomic(addr);
> >>>>>                    return;
> >>>>>            }
> >>>>>            // ...
> >>>>>            might_sleep();
> >>>>>            // ...
> >>>>> }
> >>>>
> >>>> Sorry. I didn't check vfree path. So it does look like that
> >>>> we need to pay special attention to non interrupt part.
> >>>>
> >>>>>
> >>>>> The vfree() may sleep if in_interrupt() =3D=3D false. The RCU read =
lock region
> >>>>> could have in_interrupt() =3D=3D false and spin lock region which o=
nly disables
> >>>>> preemption also has in_interrupt() =3D=3D false. So the kvfree() ca=
nnot appear
> >>>>> inside a spin lock region or RCU read lock region if the pointer ad=
dr points
> >>>>> to memory allocated by vmalloc().
> >>>>>
> >>>>>    > > Therefore, we propose modifying the condition to include
> >>>>>    > > in_atomic(). Could we
> >>>>>    > > update the condition as follows: "in_irq() || irqs_disabled(=
) ||
> >>>>>    > > in_atomic()"?
> >>>>>    > Thank you! We look forward to your feedback.
> >>>>>
> >>>>> We now think that =E2=80=98irqs_disabled() || in_atomic() ||
> >>>>> rcu_read_lock_held()=E2=80=99 is
> >>>>> more proper. irqs_disabled() is for irq flag reg, in_atomic() is fo=
r
> >>>>> preempt count and rcu_read_lock_held() is for RCU read lock region.
> >>>>
> >>>> We cannot use rcu_read_lock_held() in the 'if' statement. The return
> >>>> value rcu_read_lock_held() could be 1 for some configuraitons regard=
less
> >>>> whether rcu_read_lock() is really held or not. In most cases,
> >>>> rcu_read_lock_held() is used in issuing potential warnings.
> >>>> Maybe there are other ways to record whether rcu_read_lock() is held=
 or not?
> >>>>
> >>>> I agree with your that 'irqs_disabled() || in_atomic()' makes sense
> >>>> since it covers process context local_irq_save() and spin_lock() cas=
es.
> >>>>
> >>>> If we cannot resolve rcu_read_lock() presence issue, maybe the condi=
tion
> >>>> can be !in_interrupt(), so any process-context will go to a workqueu=
e.
> >>>>
> >>>> Alternatively, we could have another solution. We could add another
> >>>> function e.g., bpf_prog_put_rcu(), which indicates that bpf_prog_put=
()
> >>>> will be done in rcu context. So if in_interrupt(), do kvfree, otherw=
ise,
> >>>> put into a workqueue.
> >>>>
> >>>>
> >>>>>
> >>>>> -- Teng Qi
> >>>>>
> >>>>> On Sun, May 21, 2023 at 11:45=E2=80=AFAM Yonghong Song <yhs@meta.co=
m
> >>>>> <mailto:yhs@meta.com>> wrote:
> >>>>>
> >>>>>
> >>>>>
> >>>>>       On 5/19/23 7:18 AM, Teng Qi wrote:
> >>>>>        > Thank you for your response.
> >>>>>        >  > Looks like you only have suspicion here. Could you find=
 a real
> >>>>>       violation
> >>>>>        >  > here where __bpf_prog_put() is called with !in_irq() &&
> >>>>>        >  > !irqs_disabled(), but inside spin_lock or rcu read lock=
? I
> >>>>>       have not seen
> >>>>>        >  > things like that.
> >>>>>        >
> >>>>>        > For the complex conditions to call bpf_prog_put() with 1 r=
efcnt,
> >>>>>       we have
> >>>>>        > been
> >>>>>        > unable to really trigger this atomic violation after tryin=
g to
> >>>>>       construct
> >>>>>        > test cases manually. But we found that it is possible to s=
how
> >>>>>       cases with
> >>>>>        > !in_irq() && !irqs_disabled(), but inside spin_lock or rcu=
 read lock.
> >>>>>        > For example, even a failed case, one of selftest cases of =
bpf,
> >>>>>       netns_cookie,
> >>>>>        > calls bpf_sock_map_update() and may indirectly call bpf_pr=
og_put()
> >>>>>        > only inside rcu read lock: The possible call stack is:
> >>>>>        > net/core/sock_map.c: 615 bpf_sock_map_update()
> >>>>>        > net/core/sock_map.c: 468 sock_map_update_common()
> >>>>>        > net/core/sock_map.c:  217 sock_map_link()
> >>>>>        > kernel/bpf/syscall.c: 2111 bpf_prog_put()
> >>>>>        >
> >>>>>        > The files about netns_cookie include
> >>>>>        > tools/testing/selftests/bpf/progs/netns_cookie_prog.c and
> >>>>>        > tools/testing/selftests/bpf/prog_tests/netns_cookie.c. We
> >>>>>       inserted the
> >>>>>        > following code in
> >>>>>        > =E2=80=98net/core/sock_map.c: 468 sock_map_update_common()=
=E2=80=99:
> >>>>>        > static int sock_map_update_common(..)
> >>>>>        > {
> >>>>>        >          int inIrq =3D in_irq();
> >>>>>        >          int irqsDisabled =3D irqs_disabled();
> >>>>>        >          int preemptBits =3D preempt_count();
> >>>>>        >          int inAtomic =3D in_atomic();
> >>>>>        >          int rcuHeld =3D rcu_read_lock_held();
> >>>>>        >          printk("in_irq() %d, irqs_disabled() %d, preempt_=
count() %d,
> >>>>>        >            in_atomic() %d, rcu_read_lock_held() %d", inIrq=
,
> >>>>>       irqsDisabled,
> >>>>>        >            preemptBits, inAtomic, rcuHeld);
> >>>>>        > }
> >>>>>        >
> >>>>>        > The output message is as follows:
> >>>>>        > root@(none):/root/bpf# ./test_progs -t netns_cookie
> >>>>>        > [  137.639188] in_irq() 0, irqs_disabled() 0, preempt_coun=
t() 0,
> >>>>>        > in_atomic() 0,
> >>>>>        >          rcu_read_lock_held() 1
> >>>>>        > #113     netns_cookie:OK
> >>>>>        > Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
> >>>>>        >
> >>>>>        > We notice that there are numerous callers in kernel/, net/=
 and
> >>>>>       drivers/,
> >>>>>        > so we
> >>>>>        > highly suggest modifying __bpf_prog_put() to address this =
gap.
> >>>>>       The gap
> >>>>>        > exists
> >>>>>        > because __bpf_prog_put() is only safe under in_irq() ||
> >>>>>       irqs_disabled()
> >>>>>        > but not in_atomic() || rcu_read_lock_held(). The following=
 code
> >>>>>       snippet may
> >>>>>        > mislead developers into thinking that bpf_prog_put() is sa=
fe in all
> >>>>>        > contexts.
> >>>>>        > if (in_irq() || irqs_disabled()) {
> >>>>>        >          INIT_WORK(&aux->work, bpf_prog_put_deferred);
> >>>>>        >          schedule_work(&aux->work);
> >>>>>        > } else {
> >>>>>        >          bpf_prog_put_deferred(&aux->work);
> >>>>>        > }
> >>>>>        >
> >>>>>        > Implicit dependency may lead to issues.
> >>>>>        >
> >>>>>        >  > Any problem here?
> >>>>>        > We mentioned it to demonstrate the possibility of kvfree()=
 being
> >>>>>        > called by __bpf_prog_put_noref().
> >>>>>        >
> >>>>>        > Thanks.
> >>>>>        > -- Teng Qi
> >>>>>        >
> >>>>>        > On Wed, May 17, 2023 at 1:08=E2=80=AFAM Yonghong Song <yhs=
@meta.com
> >>>>>       <mailto:yhs@meta.com>
> >>>>>        > <mailto:yhs@meta.com <mailto:yhs@meta.com>>> wrote:
> >>>>>        >
> >>>>>        >
> >>>>>        >
> >>>>>        >     On 5/16/23 4:18 AM, starmiku1207184332@gmail.com
> >>>>>       <mailto:starmiku1207184332@gmail.com>
> >>>>>        >     <mailto:starmiku1207184332@gmail.com
> >>>>>       <mailto:starmiku1207184332@gmail.com>> wrote:
> >>>>>        >      > From: Teng Qi <starmiku1207184332@gmail.com
> >>>>>       <mailto:starmiku1207184332@gmail.com>
> >>>>>        >     <mailto:starmiku1207184332@gmail.com
> >>>>>       <mailto:starmiku1207184332@gmail.com>>>
> >>>>>        >      >
> >>>>>        >      > Hi, bpf developers,
> >>>>>        >      >
> >>>>>        >      > We are developing a static tool to check the matchi=
ng between
> >>>>>        >     helpers and the
> >>>>>        >      > context of hooks. During our analysis, we have disc=
overed some
> >>>>>        >     important
> >>>>>        >      > findings that we would like to report.
> >>>>>        >      >
> >>>>>        >      > =E2=80=98kernel/bpf/syscall.c: 2097 __bpf_prog_put(=
)=E2=80=99 shows that
> >>>>>       function
> >>>>>        >      > bpf_prog_put_deferred() won`t be called in the cond=
ition of
> >>>>>        >      > =E2=80=98in_irq() || irqs_disabled()=E2=80=99.
> >>>>>        >      > if (in_irq() || irqs_disabled()) {
> >>>>>        >      >      INIT_WORK(&aux->work, bpf_prog_put_deferred);
> >>>>>        >      >      schedule_work(&aux->work);
> >>>>>        >      > } else {
> >>>>>        >      >
> >>>>>        >      >      bpf_prog_put_deferred(&aux->work);
> >>>>>        >      > }
> >>>>>        >      >
> >>>>>        >      > We suspect this condition exists because there migh=
t be
> >>>>>       sleepable
> >>>>>        >     operations
> >>>>>        >      > in the callees of the bpf_prog_put_deferred() funct=
ion:
> >>>>>        >      > kernel/bpf/syscall.c: 2097 __bpf_prog_put()
> >>>>>        >      > kernel/bpf/syscall.c: 2084 bpf_prog_put_deferred()
> >>>>>        >      > kernel/bpf/syscall.c: 2063 __bpf_prog_put_noref()
> >>>>>        >      > kvfree(prog->aux->jited_linfo);
> >>>>>        >      > kvfree(prog->aux->linfo);
> >>>>>        >
> >>>>>        >     Looks like you only have suspicion here. Could you fin=
d a real
> >>>>>        >     violation
> >>>>>        >     here where __bpf_prog_put() is called with !in_irq() &=
&
> >>>>>        >     !irqs_disabled(), but inside spin_lock or rcu read loc=
k? I
> >>>>>       have not seen
> >>>>>        >     things like that.
> >>>>>        >
> >>>>>        >      >
> >>>>>        >      > Additionally, we found that array prog->aux->jited_=
linfo is
> >>>>>        >     initialized in
> >>>>>        >      > =E2=80=98kernel/bpf/core.c: 157 bpf_prog_alloc_jite=
d_linfo()=E2=80=99:
> >>>>>        >      > prog->aux->jited_linfo =3D kvcalloc(prog->aux->nr_l=
info,
> >>>>>        >      >    sizeof(*prog->aux->jited_linfo),
> >>>>>       bpf_memcg_flags(GFP_KERNEL |
> >>>>>        >     __GFP_NOWARN));
> >>>>>        >
> >>>>>        >     Any problem here?
> >>>>>        >
> >>>>>        >      >
> >>>>>        >      > Our question is whether the condition 'in_irq() ||
> >>>>>        >     irqs_disabled() =3D=3D false' is
> >>>>>        >      > sufficient for calling 'kvfree'. We are aware that =
calling
> >>>>>        >     'kvfree' within the
> >>>>>        >      > context of a spin lock or an RCU lock is unsafe.
> >>>>>
> >>>>>       Your above analysis makes sense if indeed that kvfree cannot =
appear
> >>>>>       inside a spin lock region or RCU read lock region. But is it =
true?
> >>>>>       I checked a few code paths in kvfree/kfree. It is either guar=
ded
> >>>>>       with local_irq_save/restore or by
> >>>>>       spin_lock_irqsave/spin_unlock_irqrestore, etc. Did I miss
> >>>>>       anything? Are you talking about RT kernel here?
> >>>>>
> >>>>>
> >>>>>        >      >
> >>>>>        >      > Therefore, we propose modifying the condition to in=
clude
> >>>>>        >     in_atomic(). Could we
> >>>>>        >      > update the condition as follows: "in_irq() ||
> >>>>>       irqs_disabled() ||
> >>>>>        >     in_atomic()"?
> >>>>>        >      >
> >>>>>        >      > Thank you! We look forward to your feedback.
> >>>>>        >      >
> >>>>>        >      > Signed-off-by: Teng Qi <starmiku1207184332@gmail.co=
m
> >>>>>       <mailto:starmiku1207184332@gmail.com>
> >>>>>        >     <mailto:starmiku1207184332@gmail.com
> >>>>>       <mailto:starmiku1207184332@gmail.com>>>
> >>>>>        >
> >>>>>

