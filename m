Return-Path: <netdev+bounces-9906-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2A872B1EE
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 15:02:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33825281302
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 13:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E390479DF;
	Sun, 11 Jun 2023 13:02:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FEA33F1;
	Sun, 11 Jun 2023 13:02:24 +0000 (UTC)
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470A0BB;
	Sun, 11 Jun 2023 06:02:22 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2b1fe3a1a73so37063691fa.1;
        Sun, 11 Jun 2023 06:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686488540; x=1689080540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RBBrW5e2QtMVykFYqcWXhI/R9wVX4PFf+M1Y3B94BEQ=;
        b=eqe1ata29VcfFAl5TUCVwhMQX5JqXV+n9HdwK9SgDCWUdbeIUHeGCD5JvIMHv81tWv
         6YWiRpfbE0GfGzyAAyvDRzLuzKKLjyMW0PJo5ubmtjTH6XSa5Sh5Uvfy4lyvPuW+pQDe
         7cLD49VpU7SjGl3NJAE7cXvtDdXfHW0UGy1po+uvm4KNLVR7o8Er+8CKYoeC5i00MC8H
         YXnM5Ye4f8WS2D69bsV57KMcEAthVW9rGnsq+M9xls88eIjQlp2PaATRGku1bDFUJG6Q
         Z2LWQk+F46CyWbdRy/hxuKWi9MjFhfn7OfbDgtwMTTlQn/5cE8rHQK/Zni7HphtXuHWc
         n+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686488540; x=1689080540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RBBrW5e2QtMVykFYqcWXhI/R9wVX4PFf+M1Y3B94BEQ=;
        b=fPxWqzpkWUahF8RhvB6ewq6CazoYBWdpMBoCl7y026pTWw7LgllLNVMvcZVOVZLEu+
         8UOS2nhbDlk1EAX4cF2HPB+zoify4elf1zkBbdPFRF4QZfAbFMcGkE4i8gdH9Ai3idAh
         n8QmNKwG9x+X+CMakanxxbwT3kddi0lpmVDndia+kAwYY73rAdjHrHn2aSjxpefummkX
         /3JvaNlkp3UsQAWLnARQNpeIpcXn1XHMzumEoQe26AmFiCWQbqhA9uqvZEMpnVUMqtiM
         JXjU8xxX4EDbV2WtiHwvkB7+V5IQI0u3JiEvQqXD8Je733K00pHnlx62R+EGCPx3ADIj
         7uhA==
X-Gm-Message-State: AC+VfDz1ppTRxq1oSv0NIzeGz40P1DSbDsiLtFZmd3N/LwwcNycj+rXa
	gD0E/wT/ou4LLDHlaoWRt//x7mEaQ88gRTuBmiQ=
X-Google-Smtp-Source: ACHHUZ4bA3Nn3O0kmEvA+LhZgXowuKE2CQ8uqNRCuH9POvNLHOSa3nsEJkL/OXag1RIcawLjabNNBg0lkvf/D5R9Y5I=
X-Received: by 2002:a2e:6e18:0:b0:2b1:c751:e570 with SMTP id
 j24-20020a2e6e18000000b002b1c751e570mr1206976ljc.16.1686488539619; Sun, 11
 Jun 2023 06:02:19 -0700 (PDT)
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
 <113dc8c1-0840-9ee3-2840-28246731604c@meta.com>
In-Reply-To: <113dc8c1-0840-9ee3-2840-28246731604c@meta.com>
From: Teng Qi <starmiku1207184332@gmail.com>
Date: Sun, 11 Jun 2023 21:02:07 +0800
Message-ID: <CALyQVaxFKisZ_4DjofVE9PH+nFcOKSMJG4XDkn1znsqU+EnYHw@mail.gmail.com>
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
> BTW, please do create a test case, e.g, sockmap test case which
> can show the problem with existing code base.

I add a printk in bpf_prog_put_deferred():
static void bpf_prog_put_deferred(struct work_struct *work)
{
        // . . .
        int inIrq =3D in_irq();
        int irqsDisabled =3D irqs_disabled();
        int preemptBits =3D preempt_count();
        int inAtomic =3D in_atomic();
        int rcuHeld =3D rcu_read_lock_held();
        printk("bpf_prog_put: in_irq() %d, irqs_disabled() %d, preempt_coun=
t()
         %d, in_atomic() %d, rcu_read_lock_held() %d",
        inIrq, irqsDisabled, preemptBits, inAtomic, rcuHeld);
        // . . .
}

When running the selftest, I see the following output:
[255340.388339] bpf_prog_put: in_irq() 0, irqs_disabled() 0,
        preempt_count() 256, in_atomic() 1, rcu_read_lock_held() 1
[255393.237632] bpf_prog_put: in_irq() 0, irqs_disabled() 0,
        preempt_count() 0, in_atomic() 0, rcu_read_lock_held() 1

Based on this output, I believe it is sufficient to construct a self-test c=
ase
for bpf_prog_put_deferred() called under preempt disabled or rcu read lock
region. However, I'm a bit confused about what I should do to build the
self-test case. Are we looking to create a checker that verifies the
context of bpf_prog_put_deferred() is valid? Or do we need a test case that
can trigger this bug?

Could you show me more ideas to construct a self test case? I am not famili=
ar
with it and have no idea.

-- Teng Qi

On Thu, May 25, 2023 at 3:34=E2=80=AFAM Yonghong Song <yhs@meta.com> wrote:
>
>
>
> On 5/24/23 5:42 AM, Teng Qi wrote:
> > Thank you.
> >
> >> We cannot use rcu_read_lock_held() in the 'if' statement. The return
> >> value rcu_read_lock_held() could be 1 for some configurations regardle=
ss
> >> whether rcu_read_lock() is really held or not. In most cases,
> >> rcu_read_lock_held() is used in issuing potential warnings.
> >> Maybe there are other ways to record whether rcu_read_lock() is held o=
r not?
> >
> > Sorry. I was not aware of the dependency of configurations of
> > rcu_read_lock_held().
> >
> >> If we cannot resolve rcu_read_lock() presence issue, maybe the conditi=
on
> >> can be !in_interrupt(), so any process-context will go to a workqueue.
> >
> > I agree that using !in_interrupt() as a condition is an acceptable solu=
tion.
>
> This should work although it could be conservative.
>
> >
> >> Alternatively, we could have another solution. We could add another
> >> function e.g., bpf_prog_put_rcu(), which indicates that bpf_prog_put()
> >> will be done in rcu context.
> >
> > Implementing a new function like bpf_prog_put_rcu() is a solution that =
involves
> > more significant changes.
>
> Maybe we can change signature of bpf_prog_put instead? Like
>     void bpf_prog_put(struct bpf_prog *prog, bool in_rcu)
> and inside bpf_prog_put we can add
>     WARN_ON_ONCE(in_rcu && !bpf_rcu_lock_held());
>
> >
> >> So if in_interrupt(), do kvfree, otherwise,
> >> put into a workqueue.
> >
> > Shall we proceed with submitting a patch following this approach?
>
> You could choose either of the above although I think with newer
> bpf_prog_put() is better.
>
> BTW, please do create a test case, e.g, sockmap test case which
> can show the problem with existing code base.
>
> >
> > I would like to mention something unrelated to the possible bug. At thi=
s
> > moment, things seem to be more puzzling. vfree() is safe under in_inter=
rupt()
> > but not safe under other atomic contexts.
> > This disorder challenges our conventional belief, a monotonic increment=
ation
> > of limitations of the hierarchical atomic contexts, that programer need=
s
> > to be more and more careful to write code under rcu read lock, spin loc=
k,
> > bh disable, interrupt...
> > This disorder can lead to unexpected consequences, such as code being s=
afe
> > under interrupts but not safe under spin locks.
> > The disorder makes kernel programming more complex and may result in mo=
re bugs.
> > Even though we find a way to resolve the possible bug about the bpf_pro=
g_put(),
> > I feel sad for undermining of kernel`s maintainability and disorder of
> > hierarchy of atomic contexts.
> >
> > -- Teng Qi
> >
> > On Tue, May 23, 2023 at 12:33=E2=80=AFPM Yonghong Song <yhs@meta.com> w=
rote:
> >>
> >>
> >>
> >> On 5/21/23 6:39 AM, Teng Qi wrote:
> >>> Thank you.
> >>>
> >>>   > Your above analysis makes sense if indeed that kvfree cannot appe=
ar
> >>>   > inside a spin lock region or RCU read lock region. But is it true=
?
> >>>   > I checked a few code paths in kvfree/kfree. It is either guarded
> >>>   > with local_irq_save/restore or by
> >>>   > spin_lock_irqsave/spin_unlock_
> >>>   > irqrestore, etc. Did I miss
> >>>   > anything? Are you talking about RT kernel here?
> >>>
> >>> To see the sleepable possibility of kvfree, it is important to analyz=
e the
> >>> following calling stack:
> >>> mm/util.c: 645 kvfree()
> >>> mm/vmalloc.c: 2763 vfree()
> >>>
> >>> In kvfree(), to call vfree, if the pointer addr points to memory
> >>> allocated by
> >>> vmalloc(), it calls vfree().
> >>> void kvfree(const void *addr)
> >>> {
> >>>           if (is_vmalloc_addr(addr))
> >>>                   vfree(addr);
> >>>           else
> >>>                   kfree(addr);
> >>> }
> >>>
> >>> In vfree(), in_interrupt() and might_sleep() need to be considered.
> >>> void vfree(const void *addr)
> >>> {
> >>>           // ...
> >>>           if (unlikely(in_interrupt()))
> >>>           {
> >>>                   vfree_atomic(addr);
> >>>                   return;
> >>>           }
> >>>           // ...
> >>>           might_sleep();
> >>>           // ...
> >>> }
> >>
> >> Sorry. I didn't check vfree path. So it does look like that
> >> we need to pay special attention to non interrupt part.
> >>
> >>>
> >>> The vfree() may sleep if in_interrupt() =3D=3D false. The RCU read lo=
ck region
> >>> could have in_interrupt() =3D=3D false and spin lock region which onl=
y disables
> >>> preemption also has in_interrupt() =3D=3D false. So the kvfree() cann=
ot appear
> >>> inside a spin lock region or RCU read lock region if the pointer addr=
 points
> >>> to memory allocated by vmalloc().
> >>>
> >>>   > > Therefore, we propose modifying the condition to include
> >>>   > > in_atomic(). Could we
> >>>   > > update the condition as follows: "in_irq() || irqs_disabled() |=
|
> >>>   > > in_atomic()"?
> >>>   > Thank you! We look forward to your feedback.
> >>>
> >>> We now think that =E2=80=98irqs_disabled() || in_atomic() ||
> >>> rcu_read_lock_held()=E2=80=99 is
> >>> more proper. irqs_disabled() is for irq flag reg, in_atomic() is for
> >>> preempt count and rcu_read_lock_held() is for RCU read lock region.
> >>
> >> We cannot use rcu_read_lock_held() in the 'if' statement. The return
> >> value rcu_read_lock_held() could be 1 for some configuraitons regardle=
ss
> >> whether rcu_read_lock() is really held or not. In most cases,
> >> rcu_read_lock_held() is used in issuing potential warnings.
> >> Maybe there are other ways to record whether rcu_read_lock() is held o=
r not?
> >>
> >> I agree with your that 'irqs_disabled() || in_atomic()' makes sense
> >> since it covers process context local_irq_save() and spin_lock() cases=
.
> >>
> >> If we cannot resolve rcu_read_lock() presence issue, maybe the conditi=
on
> >> can be !in_interrupt(), so any process-context will go to a workqueue.
> >>
> >> Alternatively, we could have another solution. We could add another
> >> function e.g., bpf_prog_put_rcu(), which indicates that bpf_prog_put()
> >> will be done in rcu context. So if in_interrupt(), do kvfree, otherwis=
e,
> >> put into a workqueue.
> >>
> >>
> >>>
> >>> -- Teng Qi
> >>>
> >>> On Sun, May 21, 2023 at 11:45=E2=80=AFAM Yonghong Song <yhs@meta.com
> >>> <mailto:yhs@meta.com>> wrote:
> >>>
> >>>
> >>>
> >>>      On 5/19/23 7:18 AM, Teng Qi wrote:
> >>>       > Thank you for your response.
> >>>       >  > Looks like you only have suspicion here. Could you find a =
real
> >>>      violation
> >>>       >  > here where __bpf_prog_put() is called with !in_irq() &&
> >>>       >  > !irqs_disabled(), but inside spin_lock or rcu read lock? I
> >>>      have not seen
> >>>       >  > things like that.
> >>>       >
> >>>       > For the complex conditions to call bpf_prog_put() with 1 refc=
nt,
> >>>      we have
> >>>       > been
> >>>       > unable to really trigger this atomic violation after trying t=
o
> >>>      construct
> >>>       > test cases manually. But we found that it is possible to show
> >>>      cases with
> >>>       > !in_irq() && !irqs_disabled(), but inside spin_lock or rcu re=
ad lock.
> >>>       > For example, even a failed case, one of selftest cases of bpf=
,
> >>>      netns_cookie,
> >>>       > calls bpf_sock_map_update() and may indirectly call bpf_prog_=
put()
> >>>       > only inside rcu read lock: The possible call stack is:
> >>>       > net/core/sock_map.c: 615 bpf_sock_map_update()
> >>>       > net/core/sock_map.c: 468 sock_map_update_common()
> >>>       > net/core/sock_map.c:  217 sock_map_link()
> >>>       > kernel/bpf/syscall.c: 2111 bpf_prog_put()
> >>>       >
> >>>       > The files about netns_cookie include
> >>>       > tools/testing/selftests/bpf/progs/netns_cookie_prog.c and
> >>>       > tools/testing/selftests/bpf/prog_tests/netns_cookie.c. We
> >>>      inserted the
> >>>       > following code in
> >>>       > =E2=80=98net/core/sock_map.c: 468 sock_map_update_common()=E2=
=80=99:
> >>>       > static int sock_map_update_common(..)
> >>>       > {
> >>>       >          int inIrq =3D in_irq();
> >>>       >          int irqsDisabled =3D irqs_disabled();
> >>>       >          int preemptBits =3D preempt_count();
> >>>       >          int inAtomic =3D in_atomic();
> >>>       >          int rcuHeld =3D rcu_read_lock_held();
> >>>       >          printk("in_irq() %d, irqs_disabled() %d, preempt_cou=
nt() %d,
> >>>       >            in_atomic() %d, rcu_read_lock_held() %d", inIrq,
> >>>      irqsDisabled,
> >>>       >            preemptBits, inAtomic, rcuHeld);
> >>>       > }
> >>>       >
> >>>       > The output message is as follows:
> >>>       > root@(none):/root/bpf# ./test_progs -t netns_cookie
> >>>       > [  137.639188] in_irq() 0, irqs_disabled() 0, preempt_count()=
 0,
> >>>       > in_atomic() 0,
> >>>       >          rcu_read_lock_held() 1
> >>>       > #113     netns_cookie:OK
> >>>       > Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
> >>>       >
> >>>       > We notice that there are numerous callers in kernel/, net/ an=
d
> >>>      drivers/,
> >>>       > so we
> >>>       > highly suggest modifying __bpf_prog_put() to address this gap=
.
> >>>      The gap
> >>>       > exists
> >>>       > because __bpf_prog_put() is only safe under in_irq() ||
> >>>      irqs_disabled()
> >>>       > but not in_atomic() || rcu_read_lock_held(). The following co=
de
> >>>      snippet may
> >>>       > mislead developers into thinking that bpf_prog_put() is safe =
in all
> >>>       > contexts.
> >>>       > if (in_irq() || irqs_disabled()) {
> >>>       >          INIT_WORK(&aux->work, bpf_prog_put_deferred);
> >>>       >          schedule_work(&aux->work);
> >>>       > } else {
> >>>       >          bpf_prog_put_deferred(&aux->work);
> >>>       > }
> >>>       >
> >>>       > Implicit dependency may lead to issues.
> >>>       >
> >>>       >  > Any problem here?
> >>>       > We mentioned it to demonstrate the possibility of kvfree() be=
ing
> >>>       > called by __bpf_prog_put_noref().
> >>>       >
> >>>       > Thanks.
> >>>       > -- Teng Qi
> >>>       >
> >>>       > On Wed, May 17, 2023 at 1:08=E2=80=AFAM Yonghong Song <yhs@me=
ta.com
> >>>      <mailto:yhs@meta.com>
> >>>       > <mailto:yhs@meta.com <mailto:yhs@meta.com>>> wrote:
> >>>       >
> >>>       >
> >>>       >
> >>>       >     On 5/16/23 4:18 AM, starmiku1207184332@gmail.com
> >>>      <mailto:starmiku1207184332@gmail.com>
> >>>       >     <mailto:starmiku1207184332@gmail.com
> >>>      <mailto:starmiku1207184332@gmail.com>> wrote:
> >>>       >      > From: Teng Qi <starmiku1207184332@gmail.com
> >>>      <mailto:starmiku1207184332@gmail.com>
> >>>       >     <mailto:starmiku1207184332@gmail.com
> >>>      <mailto:starmiku1207184332@gmail.com>>>
> >>>       >      >
> >>>       >      > Hi, bpf developers,
> >>>       >      >
> >>>       >      > We are developing a static tool to check the matching =
between
> >>>       >     helpers and the
> >>>       >      > context of hooks. During our analysis, we have discove=
red some
> >>>       >     important
> >>>       >      > findings that we would like to report.
> >>>       >      >
> >>>       >      > =E2=80=98kernel/bpf/syscall.c: 2097 __bpf_prog_put()=
=E2=80=99 shows that
> >>>      function
> >>>       >      > bpf_prog_put_deferred() won`t be called in the conditi=
on of
> >>>       >      > =E2=80=98in_irq() || irqs_disabled()=E2=80=99.
> >>>       >      > if (in_irq() || irqs_disabled()) {
> >>>       >      >      INIT_WORK(&aux->work, bpf_prog_put_deferred);
> >>>       >      >      schedule_work(&aux->work);
> >>>       >      > } else {
> >>>       >      >
> >>>       >      >      bpf_prog_put_deferred(&aux->work);
> >>>       >      > }
> >>>       >      >
> >>>       >      > We suspect this condition exists because there might b=
e
> >>>      sleepable
> >>>       >     operations
> >>>       >      > in the callees of the bpf_prog_put_deferred() function=
:
> >>>       >      > kernel/bpf/syscall.c: 2097 __bpf_prog_put()
> >>>       >      > kernel/bpf/syscall.c: 2084 bpf_prog_put_deferred()
> >>>       >      > kernel/bpf/syscall.c: 2063 __bpf_prog_put_noref()
> >>>       >      > kvfree(prog->aux->jited_linfo);
> >>>       >      > kvfree(prog->aux->linfo);
> >>>       >
> >>>       >     Looks like you only have suspicion here. Could you find a=
 real
> >>>       >     violation
> >>>       >     here where __bpf_prog_put() is called with !in_irq() &&
> >>>       >     !irqs_disabled(), but inside spin_lock or rcu read lock? =
I
> >>>      have not seen
> >>>       >     things like that.
> >>>       >
> >>>       >      >
> >>>       >      > Additionally, we found that array prog->aux->jited_lin=
fo is
> >>>       >     initialized in
> >>>       >      > =E2=80=98kernel/bpf/core.c: 157 bpf_prog_alloc_jited_l=
info()=E2=80=99:
> >>>       >      > prog->aux->jited_linfo =3D kvcalloc(prog->aux->nr_linf=
o,
> >>>       >      >    sizeof(*prog->aux->jited_linfo),
> >>>      bpf_memcg_flags(GFP_KERNEL |
> >>>       >     __GFP_NOWARN));
> >>>       >
> >>>       >     Any problem here?
> >>>       >
> >>>       >      >
> >>>       >      > Our question is whether the condition 'in_irq() ||
> >>>       >     irqs_disabled() =3D=3D false' is
> >>>       >      > sufficient for calling 'kvfree'. We are aware that cal=
ling
> >>>       >     'kvfree' within the
> >>>       >      > context of a spin lock or an RCU lock is unsafe.
> >>>
> >>>      Your above analysis makes sense if indeed that kvfree cannot app=
ear
> >>>      inside a spin lock region or RCU read lock region. But is it tru=
e?
> >>>      I checked a few code paths in kvfree/kfree. It is either guarded
> >>>      with local_irq_save/restore or by
> >>>      spin_lock_irqsave/spin_unlock_irqrestore, etc. Did I miss
> >>>      anything? Are you talking about RT kernel here?
> >>>
> >>>
> >>>       >      >
> >>>       >      > Therefore, we propose modifying the condition to inclu=
de
> >>>       >     in_atomic(). Could we
> >>>       >      > update the condition as follows: "in_irq() ||
> >>>      irqs_disabled() ||
> >>>       >     in_atomic()"?
> >>>       >      >
> >>>       >      > Thank you! We look forward to your feedback.
> >>>       >      >
> >>>       >      > Signed-off-by: Teng Qi <starmiku1207184332@gmail.com
> >>>      <mailto:starmiku1207184332@gmail.com>
> >>>       >     <mailto:starmiku1207184332@gmail.com
> >>>      <mailto:starmiku1207184332@gmail.com>>>
> >>>       >
> >>>

