Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE017227268
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 00:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgGTWbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 18:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGTWa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 18:30:59 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4ABFC061794;
        Mon, 20 Jul 2020 15:30:59 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id 72so9362863ple.0;
        Mon, 20 Jul 2020 15:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L1zpBGcsOgE5mLQjm2oHm3qmaUw51/j3bZeaEGstA+0=;
        b=mtTJ4q9FN3gAzWKXPSfev+myHVhSieNuM1LS1EynDGZkMIpMkmooY+/bCIyzntOg0L
         UIRqxql2ORAhRqpzXQiAGMyVDRiRS0SSwV31yk+qo4oiJWzqzRE/FZsNYeYy3/wI7qit
         yh8I7aXtFOe9hAnObJrq6E0sqJoGpGT4V4GWv1VCy1wh/7OpeL4glQhm+uJym9DGf3ec
         sh5LMJpE7sRiYWKY5CyvGosflNL2XLrbcu6+J/d1fCg3TrOK4/ueL+ywpdgMhkFmaxqS
         7srK0BgHO01xm0GWg/0s6WjdF22e8xxagWusL+56RBXHojXCcbWwbGfyTItYXAjAqA1C
         VKSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L1zpBGcsOgE5mLQjm2oHm3qmaUw51/j3bZeaEGstA+0=;
        b=sH2cnx0xnAE1sDyseOYkfbxc2azmlN4JSXIyka0wM8FI+VEe/ekmChIsA8BEkJAzGP
         Y5AcxImnrOT6guiyJiK6lBg//txRb4vnTPmTYv7UT9XWZmMNKgFv48DTYdUG70qlNKK4
         f3UlJAS/VhkqxIMLyvwB9jrXPqjZVfFxg/LOsBAJTjws2KKfP2ey3wzVTDx8FoWWLMSd
         1KvdWVjQgo623k2K67SkLEYBQI+rqc6KaPo2RKNL1esc+30OjIkW8VJ5+adXDvysPjmW
         LhiMQvGmlqX52RLjER0h7XwUIPZ61rMNfM+a5oLiySEJQVj03IwbCBHidAd+whxavPV3
         ZNSA==
X-Gm-Message-State: AOAM531vtsNNCpM3784YHWy2zudXpSvJcwsAoIEz25hD2oc8b80nLNcf
        uhViUgGTcDnKgqZ/VuKXxLw=
X-Google-Smtp-Source: ABdhPJwu0PNRi6FDkyYjXmnCl88H0p9+/qSp/g9vxqrt12b2rhK304sRhGwd5vf+eWQ/1ryllQLASA==
X-Received: by 2002:a17:902:aa91:: with SMTP id d17mr19580570plr.93.1595284259118;
        Mon, 20 Jul 2020 15:30:59 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e3b])
        by smtp.gmail.com with ESMTPSA id g18sm17471238pfi.141.2020.07.20.15.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 15:30:58 -0700 (PDT)
Date:   Mon, 20 Jul 2020 15:30:55 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Blake Matheny <bmatheny@fb.com>
Subject: Re: BPF logging infrastructure. Was: [PATCH bpf-next 4/6] tools: add
 new members to bpf_attr.raw_tracepoint in bpf.h
Message-ID: <20200720223055.zoad5vw6tx4sqqpj@ast-mbp.dhcp.thefacebook.com>
References: <CAEf4BzYAoetyfyofTX45RQjtz3M-c9=YNeH1uRDbYgK4Ae0TwA@mail.gmail.com>
 <87d04xg2p4.fsf@toke.dk>
 <20200714231133.ap5qnalf6moptvfk@ast-mbp.dhcp.thefacebook.com>
 <874kq9ey2j.fsf@toke.dk>
 <20200715234123.rr7oj74t5hflzmsn@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbodR-+=Q3wRE2UaiouBexvqfwpE-zJGm4Rr1cV2dgZHQ@mail.gmail.com>
 <20200716054408.so34cuc2g2iqcppr@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzbiD9Cuqip2=FGHGHLZs-7b8AziS-hJOpX1HuONTM4udQ@mail.gmail.com>
 <20200717030920.6kxs6kyvisuvoqnt@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZyGJGork=fDEAp+SmkzHs1+ydqVwZmYt8QeCZzf-yyvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZyGJGork=fDEAp+SmkzHs1+ydqVwZmYt8QeCZzf-yyvA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 08:54:45PM -0700, Andrii Nakryiko wrote:
> 
> > Only libbpf can do it. Kernel is helpless here.
> > Say we change the kernel errno for all unsuported prog types and maps
> > it would return ENOTSUPP or something.
> > Would it really help the situation?
> 
> IMO, if the kernel just prints out "Unknown BPF command 123" or
> "Unknown map type 345" that would be already a nice improvement.
...
> log_buf can't help existing kernels. Period. No one is arguing or
> expecting that. But moving forward, just having that "unknown command
> 123" would be great.
> 
> But yeah, of course libbpf can create a probing map and try to do
> BATCH_LOOKUP, to detect BATCH_LOOKUP support.

Also with BTF the kernel is self documented.
The following will print all commands that kernel supports:
bpftool btf dump file ./bld_x64/vmlinux |grep -A40 bpf_cmd
and with 'grep BPF_MAP_TYPE_' all supported maps.
For older kernels there is 'bpftool feature probe'.
Since libbpf reads vmlinux BTF anyway it could have got a knowledge
of all the features it supports based on BTF.

But let's continue this thought experiment for augmenting error
reporting with a string.
For 'Unknown BPF command 123' to work log_buf needs to passed
outside of 'union bpf_attr'. Probably as 4th argument to sys_bpf ?
and then a bit in 'int cmd' would need to be burned to indicate
that 4th arg is there. Probably size of the arg needs to be passed
either as 5th arg or as part of the 'struct bpf_log_buf' so it can
be extensible.
Using that log_buf directly in
SYSCALL_DEFINE[45](bpf, int cmd, ... struct bpf_log_buf *log_buf)
will be trivial.
But to pass it into any of first level functions (bpf_iter_create,
bpf_prog_attach, etc) they would need to gain an extra argument.
To pass it all the way into hierarchy_allows_attach() it needs to be added to:
__cgroup_bpf_attach 
cgroup_bpf_attach
cgroup_bpf_link_attach
link_create

Another case of ambiguous 'return -EINVAL' would cause another change
to a bunch of function prototypes.
So it's better to integrate it into current task_struct to avoid huge code churn.

But if we do so what stops us from generalizing log_buf reporting to
other syscalls? perf_event_open is in the same category.

> This one is for perf subsystem, actually, it's its
> PERF_EVENT_IOC_SET_BPF ioctl (until we add bpf_link for perf_event
> attachment).

clearly not only sys_bpf and sys_perf_event_open, but sys_ioctl would need
string support to be a full answer to ambiguous einval-s.

> My proposal was about adding the ability to emit something to log_buf
> from any of the BPF commands, if that BPF command chooses to provide
> extra error information. The whole point of this was to avoid adding
> log_buf in command-specific ways (as Toke was doing in the patch that
> I used to initiate the discussion) and do it once for entire syscall,
> so that we can gradually utilize it where it makes most sense.

I don't think that works due to code churn. Whether we pay that price
once or 'gradually' it doesn't make it any better.
When log_buf is added to an existing command the 'union bpf_attr' is there
in the function proto and nothing new needs to passed to a lot of functions.
So I certainly prefer Toke's approach of adding log_buf to one specific
command if it's really needed there.

The alternative is to solve it for all syscalls.

> I agree that if such diagnostics are reliable and the situation itself
> is common and experienced by multiple users, then it might make sense
> to add such checks to libbpf. 

'experienced by multiple users' is going to be a judgement call
either for libbpf or for kernel.
I'm saying let's improve libbpf user-friendlyness everywhere we can.
We can always drop these hints later. Unlike kernel messages that
might become stable api.
One thing is log_buf that the verifier is dumping. It's huge and not parsable.
Whereas a string next to return EINVAL may become an uapi.
I wouldn't be surprised if some of netlink extack strings got to this
level of stability and changing the string may cause somebody to notice
and the commit would get reverted.

> But I also don't think it's always
> possible to diagnose something automatically with 100% confidence. We
> can give hints, but misdiagnosing the problem can just further confuse
> things instead.

I think the possible confusion is fine.
The libbpf has an opportunity to try them and remove if things don't work out.
The kernel strings would be much more scrutinized and harder to change.

> Also quite often such problems are one-offs, which
> doesn't make them any less confusing and frustrating, but custom
> diagnostics for every such case has a potential of bloating libbpf
> beyond recognition

bloating libbpf with strings is imo better way to figure out how to
improve user experience than bloating kernel.

> of them. That's what I meant that this is not a scalable approach to
> just say "fix libbpf to be more user friendly, kernel does its best
> already".

Ok. I will take it back. The kernel can be improved with extra strings
here and there, but only if it's done without huge code churn.
If current task_struct approach can work and the changes would be
limited to something like:
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index ac53102e244a..244df18728c2 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -196,8 +196,12 @@ static bool hierarchy_allows_attach(struct cgroup *cgrp,
                        return true;
                cnt = prog_list_length(&p->bpf.progs[type]);
                WARN_ON_ONCE(cnt > 1);
-               if (cnt == 1)
-                       return !!(flags & BPF_F_ALLOW_OVERRIDE);
+               if (cnt == 1) {
+                       ret = !!(flags & BPF_F_ALLOW_OVERRIDE);
+                       if (!ret)
+                               syscall_string("cgroup has non-overridable program in the parent");
+                       return ret;
+               }

Then such syscall_string reporting mechanism would be solid addition to the
kernel. Otherwise the cost of passing explicit log_buf everywhere is not worth
it.

I think such syscall_string can probably piggy back on "socket local storage
into generic local storage" work. Sooner or later we will have
per task_struct storage. If that's a single pointer in task_struct that will
be used by both task local storage from inside tracing bpf program and
by this syscall_string() reporting mechanism then we can land it.
May be all syscalls will become stateful. sys_bpf, sys_perf_event_open, sys_ioctl
followed by new syscall "give me back the error string".
Or may be we can do some asm magic and pass both errno and a string from
a syscall at the same time.
