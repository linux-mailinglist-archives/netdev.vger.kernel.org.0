Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578A7549CB8
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346080AbiFMTDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346888AbiFMTC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:02:56 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132CFA26FF;
        Mon, 13 Jun 2022 09:38:34 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id m20so12200490ejj.10;
        Mon, 13 Jun 2022 09:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vBiRUZCaUFh1bxErkc0s3g1NzHjtPwcGxqqDUf1ieFg=;
        b=pDvKPqeZ4B3uprvaLolYqLk1UqKH19EYq3jlXWMvu07M/x32H57/VwqkeEVFc8jKA8
         KGhVYz4itVvoGSr58xlYkkeLOqSsgyBfjaVnmb6KAZ+yZe3VlnR3FKSQ+Vkq4JqsufRg
         9F3fApoBEhmBVcuVW44KzhwruMbn/ED3muYEMBnwzLwZ/yqjr5PPfTsUM4iyD+Rm4AQX
         aYW8WMUSINND+jNrkgfgMEnEIXNSmItIXmz09kJvBNXmbprdUgZGoVeODSsEgaioNxWK
         Tnkx80T73LSn7evfC2Z9cuRhsUuk1QoXWg+vzJn7lDR0OMVj1Aohcv0ZNmTBg2jpf47k
         qrZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vBiRUZCaUFh1bxErkc0s3g1NzHjtPwcGxqqDUf1ieFg=;
        b=nsH/zwavryew+6tHIhv7qQ+NMBdjR6kgYErG23smonrZxblFgBmk8v15MGBBFw+jfi
         6/kxCwJIieLwZsW1ZKeD3KYQgYhk9ckD/VTPIVHEUFjUTtE4Bk1gu8cUunRg8JNa+j+/
         IUDMVN+//qGxnzF49ae4oCNfLUuD1bIAvs7iqrCb5NFuCshxeyLNlI+PZcjXjdjZOWNr
         sh/QoHUEH+wynOp0u6oJ4FVNXbRGWYTuIhJkB8SS4UBe9d6LCkN8734SZqNs9egUYYHn
         z/hVu5iRmMAtE5ShTdrrX+IzLkvEb3PIkrXM+uqn8G1KZDi8PY3f4k3eGOIocMzQ5IOW
         iTZQ==
X-Gm-Message-State: AJIora/NHhmH4N2rNGgh2nxpL3KOU72TEtrt++lx32v3n0jLjDAofzSy
        rZ+YZxbRs58X07YfUFUw/3yHzl9hSKGG+W02TnY=
X-Google-Smtp-Source: AGRyM1sfgmsE/9lYJPZoSlFhzYQ+SjIxrglf2pWD73IgwDc+d0sNn6NRXwFhykP+MEjo52yf+pK0Q1DQEe0WV+YrizE=
X-Received: by 2002:a17:906:610:b0:715:79ac:7db9 with SMTP id
 s16-20020a170906061000b0071579ac7db9mr609253ejb.226.1655138312491; Mon, 13
 Jun 2022 09:38:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220525114003.61890-1-jolsa@kernel.org> <CAEf4BzZ-xe-zSjbBpKLHfQKPnTRTBMA2Eg382+_4kQoTLnj4eQ@mail.gmail.com>
 <CAADnVQJcDKVAOeJ8LX9j-cUKdkptuFWFDnB3o9C_o0bSScGnsQ@mail.gmail.com>
 <CAEf4Bzay1-pRLw+zHG1TjHRTRpqQdtmpmDvNdq=ef-0OUQD0QQ@mail.gmail.com>
 <CAADnVQJtJEzsr4a+brn4n65Pt1dP-3WTSHZe23_AetxWRTm0Tg@mail.gmail.com>
 <CAEf4BzafJ8wThrsaYgn_WtmCau_VFDXB9enp-FiYhnzb==tsMQ@mail.gmail.com> <20220611205326.7ladtowtvt3ap6z3@macbook-pro-3.dhcp.thefacebook.com>
In-Reply-To: <20220611205326.7ladtowtvt3ap6z3@macbook-pro-3.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Jun 2022 09:38:21 -0700
Message-ID: <CAEf4BzYLUsiQd05f_v1KXq6wqmrrZqbiKRrJEQ_J5k7pj95-2g@mail.gmail.com>
Subject: Re: [RFC bpf-next] bpf: Use prog->active instead of bpf_prog_active
 for kprobe_multi
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 11, 2022 at 1:53 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jun 10, 2022 at 10:58:50AM -0700, Andrii Nakryiko wrote:
> > On Thu, Jun 9, 2022 at 3:03 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Thu, Jun 9, 2022 at 11:27 AM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Tue, Jun 7, 2022 at 9:29 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Tue, May 31, 2022 at 4:24 PM Andrii Nakryiko
> > > > > <andrii.nakryiko@gmail.com> wrote:
> > > > > >
> > > > > > On Wed, May 25, 2022 at 4:40 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > > > > > >
> > > > > > > hi,
> > > > > > > Alexei suggested to use prog->active instead global bpf_prog_active
> > > > > > > for programs attached with kprobe multi [1].
> > > > > > >
> > > > > > > AFAICS this will bypass bpf_disable_instrumentation, which seems to be
> > > > > > > ok for some places like hash map update, but I'm not sure about other
> > > > > > > places, hence this is RFC post.
> > > > > > >
> > > > > > > I'm not sure how are kprobes different to trampolines in this regard,
> > > > > > > because trampolines use prog->active and it's not a problem.
> > > > > > >
> > > > > > > thoughts?
> > > > > > >
> > > > > >
> > > > > > Let's say we have two kernel functions A and B? B can be called from
> > > > > > BPF program though some BPF helper, ok? Now let's say I have two BPF
> > > > > > programs kprobeX and kretprobeX, both are attached to A and B. With
> > > > > > using prog->active instead of per-cpu bpf_prog_active, what would be
> > > > > > the behavior when A is called somewhere in the kernel.
> > > > > >
> > > > > > 1. A is called
> > > > > > 2. kprobeX is activated for A, calls some helper which eventually calls B
> > > > > >   3. kprobeX is attempted to be called for B, but is skipped due to prog->active
> > > > > >   4. B runs
> > > > > >   5. kretprobeX is activated for B, calls some helper which eventually calls B
> > > > > >     6. kprobeX is ignored (prog->active > 0)
> > > > > >     7. B runs
> > > > > >     8. kretprobeX is ignored (prog->active > 0)
> > > > > > 9. kretprobeX is activated for A, calls helper which calls B
> > > > > >   10. kprobeX is activated for B
> > > > > >     11. kprobeX is ignored (prog->active > 0)
> > > > >
> > > > > not correct. kprobeX actually runs.
> > > > > but the end result is correct.
> > > > >
> > > >
> > > > Right, it was a long sequence, but you got the idea :)
>
> The above analysis was actually incorrect.
> There are three kprobe flavors: int3, opt, ftrace.
> while multi-kprobe is based on fprobe.
> kretprobe can be traditional and rethook based.
> In all of these mechanisms there is at least ftrace_test_recursion_trylock()
> and for kprobes there is kprobe_running (per-cpu current_kprobe) filter
> that acts as bpf_prog_active.
>
> So this:
> 1. kprobeX for A
> 2. kretprobeX for B
> 3. kretprobeX for A
> 4. kprobeX for B
> doesn't seem possible.
> Unless there is reproducer of above behavior there is no point using above
> as a design argument.
>

Cool, seems like Jiri confirmed this can't in fact happen for kprobes,
so I'm good, this behavior was the one I was worried about, not global
vs per-prog active flag, per se.

> > > > > It's awful. We have to fix it.
> > > >
> > > > You can call it "a fix" if you'd like, but it's changing a very
> > > > user-visible behavior and guarantees on which users relied for a
> > > > while. So even if we switch to per-prog protection it will have to be
> > > > some sort of opt-in (flag, new program type, whatever).
> > >
> > > No opt-in allowed for fixes and it's a bug fix.
> > > No one should rely on broken kernel behavior.
> > > If retsnoop rely on that it's really retsnoop's fault.
> >
> > No point in arguing if we can't even agree on whether this is a bug or
> > not, sorry.
> >
> > Getting kretprobe invocation out of the blue without getting
> > corresponding kprobe invocation first (both of which were successfully
> > attached) seems like more of a bug to me. But perhaps that's a matter
> > of subjective opinion.
>
> The issue of kprobe/kretprobe mismatch was known for long time.
> First maxactive was an issue. It should be solved by rethook now.
> Then kprobe/kretprobe attach is not atomic.
> bpf prog attaching kprobe and kretprobe to the same func cannot assume
> that they will always pair. bcc scripts had to deal with this.
>
> Say, kprobe/kretprobe will become fentry/fexit like with prog->active only.
> If retsnoop wants to do its own per-cpu prog_active counter it will
> prevent out-of-order fentry/fexit for the case when the same prog
> is attached to before-bpf-func and during-bpf-func. Only retsnoop's progs
> will miss during-bpf-func events. Such policy decisions is localized to one tool.
> All other users will see the events they care about.
> kprobe/kretprobe/fprobe run handlers with preemption disabled which makes
> these mechanisms unfriendly to RT. Their design shows that they're not suitable
> for always-on running. When bpf+kprobe was introduced 7 years ago it wasn't
> meant to be 24-7 either. bpf_prog_active is modeled like current_kprobe.
> It was addressing the deadlock issue with spinlocks in maps.
> Recursion was not an issue.
> Sadly kprobe/kretprobe/fprobe look unfixable in this form. Too much work
> needs to be done to enable something like:
> user A attaches prog A to func X. X runs, prog A runs with migration disabled.
> Preemption. Something else starts on this cpu. Another user B attaching prog B
> to func Y should see its prog being executed.
> With kprobes it looks impossible. While fentry was designed with this use case
> in mind. Note it's not about sleepable progs. Normal bpf progs can be preempted.
>
> Back to Jiri's question whether we can remove bpf_prog_active from
> trace_call_bpf.  Yes. We can and we should. It will allow bperf to collect
> stack traces that include bpf progs. It's an important fix. Incorrect retsnoop
> assumptions about kprobes will not be affected.
