Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2619054307A
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbiFHMdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239463AbiFHMdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:33:02 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E042A140E;
        Wed,  8 Jun 2022 05:33:00 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id fd25so26892611edb.3;
        Wed, 08 Jun 2022 05:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gEYLkOOLDctdTPMR+YigdS12KbIsPITqR8JOgmzwgxc=;
        b=NqWuaULH3mm1djgGSHveSqZcJz1500qH3xtQs8FyugtJJoosBOk/c98XLnSTkG8D6i
         c8O8mNcs+ziYJLJJhJMrPYQR312u9QcX/fJx6DnaNyiZjeG2kKHsptbAMdHdxlxOnMae
         aSsDNdHfec/T2IsNe4/qb9U/EH4mHiT8gJOJLOqTPpYnRB0oPAZKd6kCKWlvPKPEO5jH
         0TL+8cVVWcRGW5JEgPKD1jrQHEhnTXDjweer4m5qr+tSHWeoN78pkteetpAiqoMVNOVQ
         CFl/cd3Wy73QQKqdaKxkRvBgg8FHkATIWMzpUT1AKbMxoyB5MfPwKDc5Uq0PC6rwOAMq
         OaoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gEYLkOOLDctdTPMR+YigdS12KbIsPITqR8JOgmzwgxc=;
        b=Dy0E0uuNE2tVmv82hTQIa1DkxMaJH6ki2iBQgTbCd8xsjXmDYm78WfzPJqPBw/F9+W
         kHOTEBbYkDvFutDhzUiWk65x0IXMvR7HVHiMyDiwgfHI6L8yPnNX9Afk3VUGMabOysOF
         Y+JKyl/wkCnkB+n0YWJYxXplRdZzObgB7K81HQFQTFPjXHx4dHCvvcreZ8VUzo14oIsl
         GWngNNdAv9gtTXMr+LVkPyklTAmleB85+T74YO4Z9Ric68BN2CXytgnf64dWY5BDG+AP
         XjQ4QteMGzLzl9fPRaWODNiJspYExgOTHzlwZOjMKKHSHsI2cwIYDTdc5i94Qk/WNYMs
         j4jQ==
X-Gm-Message-State: AOAM533hz0eBux2TBONYR5TEi4XKzbdXHKJzas+aP+Q0jvk2fOcXOG8p
        w+N/y1VfTPUCXkrCwZtRlq4=
X-Google-Smtp-Source: ABdhPJy1ReLBwHgnvMBJOBrZzS9kkJ3+aK/d1vuTJfuvurHQN6mMGZk2g1mHiXFh9ufPM4q5asWN2A==
X-Received: by 2002:a05:6402:23a2:b0:42d:d5f1:d470 with SMTP id j34-20020a05640223a200b0042dd5f1d470mr25925665eda.365.1654691578551;
        Wed, 08 Jun 2022 05:32:58 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id y3-20020a170906524300b006fee16142b9sm8997111ejm.110.2022.06.08.05.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 05:32:58 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 8 Jun 2022 14:32:56 +0200
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next] bpf: Use prog->active instead of bpf_prog_active
 for kprobe_multi
Message-ID: <YqCW+EgPjQ+fS0WW@krava>
References: <20220525114003.61890-1-jolsa@kernel.org>
 <CAEf4BzZ-xe-zSjbBpKLHfQKPnTRTBMA2Eg382+_4kQoTLnj4eQ@mail.gmail.com>
 <CAADnVQJcDKVAOeJ8LX9j-cUKdkptuFWFDnB3o9C_o0bSScGnsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJcDKVAOeJ8LX9j-cUKdkptuFWFDnB3o9C_o0bSScGnsQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 09:29:30PM -0700, Alexei Starovoitov wrote:
> On Tue, May 31, 2022 at 4:24 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, May 25, 2022 at 4:40 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > hi,
> > > Alexei suggested to use prog->active instead global bpf_prog_active
> > > for programs attached with kprobe multi [1].
> > >
> > > AFAICS this will bypass bpf_disable_instrumentation, which seems to be
> > > ok for some places like hash map update, but I'm not sure about other
> > > places, hence this is RFC post.
> > >
> > > I'm not sure how are kprobes different to trampolines in this regard,
> > > because trampolines use prog->active and it's not a problem.
> > >
> > > thoughts?
> > >
> >
> > Let's say we have two kernel functions A and B? B can be called from
> > BPF program though some BPF helper, ok? Now let's say I have two BPF
> > programs kprobeX and kretprobeX, both are attached to A and B. With
> > using prog->active instead of per-cpu bpf_prog_active, what would be
> > the behavior when A is called somewhere in the kernel.
> >
> > 1. A is called
> > 2. kprobeX is activated for A, calls some helper which eventually calls B
> >   3. kprobeX is attempted to be called for B, but is skipped due to prog->active
> >   4. B runs
> >   5. kretprobeX is activated for B, calls some helper which eventually calls B
> >     6. kprobeX is ignored (prog->active > 0)
> >     7. B runs
> >     8. kretprobeX is ignored (prog->active > 0)
> > 9. kretprobeX is activated for A, calls helper which calls B
> >   10. kprobeX is activated for B
> >     11. kprobeX is ignored (prog->active > 0)
> 
> not correct. kprobeX actually runs.
> but the end result is correct.
> 
> >     12. B runs
> >     13. kretprobeX is ignored (prog->active > 0)
> >   14. B runs
> >   15. kretprobeX is ignored (prog->active > 0)
> >
> >
> > If that's correct, we get:
> >
> > 1. kprobeX for A
> > 2. kretprobeX for B
> > 3. kretprobeX for A
> > 4. kprobeX for B
> 
> Here it's correct.
> 
> > It's quite mind-boggling and annoying in practice. I'd very much
> > prefer just kprobeX for A followed by kretprobeX for A. That's it.
> >
> > I'm trying to protect against this in retsnoop with custom per-cpu
> > logic in each program, but I so much more prefer bpf_prog_active,
> > which basically says "no nested kprobe calls while kprobe program is
> > running", which makes a lot of sense in practice.
> 
> It makes sense for retsnoop, but does not make sense in general.
> 
> > Given kprobe already used global bpf_prog_active I'd say multi-kprobe
> > should stick to bpf_prog_active as well.
> 
> I strongly disagree.
> Both multi kprobe and kprobe should move to per prog counter
> plus some other protection
> (we cannot just move to per-prog due to syscalls).
> It's true that the above order is mind-boggling,
> but it's much better than
> missing kprobe invocation completely just because
> another kprobe is running on the same cpu.
> People complained numerous times about this kprobe behavior.
> kprobeX attached to A
> kprobeY attached to B.
> If kprobeX calls B kprobeY is not going to be called.
> Means that anything that bpf is using is lost.
> spin locks, lists, rcu, etc.
> Sleepable uprobes are coming.
> iirc Delyan's patch correctly.
> We will do migrate_disable and inc bpf_prog_active.
> Now random kprobes on that cpu will be lost.
> It's awful. We have to fix it.

how about using bpf_prog_active just to disable instrumentation,
and only check it before running bpf prog

plus adding prog->active check for both kprobe and kprobe_multi
to bpf_prog_run function, like in the patch below

jirka


---
diff --git a/include/linux/filter.h b/include/linux/filter.h
index ed0c0ff42ad5..a27e947f8749 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -632,7 +632,12 @@ static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
 
 static __always_inline u32 bpf_prog_run(const struct bpf_prog *prog, const void *ctx)
 {
-	return __bpf_prog_run(prog, ctx, bpf_dispatcher_nop_func);
+	u32 ret = 0;
+
+	if (likely(__this_cpu_inc_return(*(prog->active)) == 1))
+		ret = __bpf_prog_run(prog, ctx, bpf_dispatcher_nop_func);
+	__this_cpu_dec(*(prog->active));
+	return ret;
 }
 
 /*
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 10b157a6d73e..62389ff0f15a 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -103,16 +103,8 @@ unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx)
 
 	cant_sleep();
 
-	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
-		/*
-		 * since some bpf program is already running on this cpu,
-		 * don't call into another bpf program (same or different)
-		 * and don't send kprobe event into ring-buffer,
-		 * so return zero here
-		 */
-		ret = 0;
-		goto out;
-	}
+	if (unlikely(this_cpu_read(bpf_prog_active)))
+		return 0;
 
 	/*
 	 * Instead of moving rcu_read_lock/rcu_dereference/rcu_read_unlock
@@ -133,10 +125,6 @@ unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx)
 	ret = bpf_prog_run_array(rcu_dereference(call->prog_array),
 				 ctx, bpf_prog_run);
 	rcu_read_unlock();
-
- out:
-	__this_cpu_dec(bpf_prog_active);
-
 	return ret;
 }
 
@@ -2395,10 +2383,8 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 	struct bpf_run_ctx *old_run_ctx;
 	int err;
 
-	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
-		err = 0;
-		goto out;
-	}
+	if (unlikely(this_cpu_read(bpf_prog_active)))
+		return 0;
 
 	migrate_disable();
 	rcu_read_lock();
@@ -2407,9 +2393,6 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 	bpf_reset_run_ctx(old_run_ctx);
 	rcu_read_unlock();
 	migrate_enable();
-
- out:
-	__this_cpu_dec(bpf_prog_active);
 	return err;
 }
 

