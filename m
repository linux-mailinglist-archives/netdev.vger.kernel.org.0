Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC76C115870
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 22:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfLFVL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 16:11:28 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42677 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfLFVL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 16:11:27 -0500
Received: by mail-lj1-f194.google.com with SMTP id e28so9089507ljo.9
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 13:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DcswDcKmSJyRQPJcgySZXuflqUPk7eZxT2PzLNE9GK4=;
        b=JtQOlrwql30oDmwlAc2rnFU7v4rBy5XkWHDPXhKogi11H96M/hyW96LMNrBwW7s2vD
         kKU7SVAXtx0RZKeKRRjFytbOOk0dc1of+NRJ9cs+91xzXtHGjHuS1jI7R31IxVt8iqH0
         T59gaJZS6Qewx2PpgAKRWaPLTG4MmO0VtNW1JWz6DRnl2ejsfcGmhjG2xgmtTSeY3A56
         T1IfbtXl++A7Rhr+5aPNvGmHaiFi3EaTwT0+aNeEr4FVgyWer1cMlJgbfaD5Cz4k0j8Z
         n9HNu6SGHONqOW9YxN8HwD1iQSyJsunCLVFQZ9BCzZJtkn+/FcJgLMR4fB19tLM/BI95
         XB/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DcswDcKmSJyRQPJcgySZXuflqUPk7eZxT2PzLNE9GK4=;
        b=DoVSEl6gXxivVh3JAc2keJ9hjujVRicflWT1y6CxliUcBint/eAA5hSEqd6SZXuI4n
         LMDcF1oe40o5gYC0VzONZvzoiJmjj7QuFaZja/jzHG3b0LU8ZXicfFyrztfDyq4Uqszq
         taX6abtWeGdpjMTCUI5/xmWDwMe+cW0zDlQn26MBbtSal7porRVDQ4FvFvSEbZ4ek8ax
         Th/Q5LCURX+8PYBFyiGKp97zEfJGKYLsKmrHSmlgKeVO8zPiTnfyQA+to6zkV/w4DZjG
         4kUUAWjLRN/rxOmsb2l946FMvbWrFIbTdkvM2pzIRDOfs34qqnPBpF08//6VLeBLbKm/
         a/+A==
X-Gm-Message-State: APjAAAWG1aF+nAWsUB4k4rvzKIXFDBCxEZwd28Be79Rw/nKMYlOos/F7
        auKWbSobpvy+/k4JAzvlzYijA+eYcuXskpmas/Sz
X-Google-Smtp-Source: APXvYqzILr1spmyw4/Oebtijvj5znSLSPO2cXZu0/HOjsfYWmq8Uhm0oa2QneWLTlf5JKMACZvEWWvbzE0Ys5lczSiQ=
X-Received: by 2002:a2e:85d5:: with SMTP id h21mr9726075ljj.243.1575666684955;
 Fri, 06 Dec 2019 13:11:24 -0800 (PST)
MIME-Version: 1.0
References: <20191205102552.19407-1-jolsa@kernel.org>
In-Reply-To: <20191205102552.19407-1-jolsa@kernel.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 6 Dec 2019 16:11:13 -0500
Message-ID: <CAHC9VhTWnNvfMAPz-WhD9Wqv6UZZDBdMxF9VuS3UeTLHLtfhHw@mail.gmail.com>
Subject: Re: [PATCHv2] bpf: Emit audit messages upon successful prog load and unload
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-audit@redhat.com,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 5, 2019 at 5:26 AM Jiri Olsa <jolsa@kernel.org> wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
>
> Allow for audit messages to be emitted upon BPF program load and
> unload for having a timeline of events. The load itself is in
> syscall context, so additional info about the process initiating
> the BPF prog creation can be logged and later directly correlated
> to the unload event.
>
> The only info really needed from BPF side is the globally unique
> prog ID where then audit user space tooling can query / dump all
> info needed about the specific BPF program right upon load event
> and enrich the record, thus these changes needed here can be kept
> small and non-intrusive to the core.
>
> Raw example output:
>
>   # auditctl -D
>   # auditctl -a always,exit -F arch=x86_64 -S bpf
>   # ausearch --start recent -m 1334
>   ...
>   ----
>   time->Wed Nov 27 16:04:13 2019
>   type=PROCTITLE msg=audit(1574867053.120:84664): proctitle="./bpf"
>   type=SYSCALL msg=audit(1574867053.120:84664): arch=c000003e syscall=321   \
>     success=yes exit=3 a0=5 a1=7ffea484fbe0 a2=70 a3=0 items=0 ppid=7477    \
>     pid=12698 auid=1001 uid=1001 gid=1001 euid=1001 suid=1001 fsuid=1001    \
>     egid=1001 sgid=1001 fsgid=1001 tty=pts2 ses=4 comm="bpf"                \
>     exe="/home/jolsa/auditd/audit-testsuite/tests/bpf/bpf"                  \
>     subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
>   type=UNKNOWN[1334] msg=audit(1574867053.120:84664): prog-id=76 op=LOAD
>   ----
>   time->Wed Nov 27 16:04:13 2019
>   type=UNKNOWN[1334] msg=audit(1574867053.120:84665): prog-id=76 op=UNLOAD
>   ...
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Co-developed-by: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/uapi/linux/audit.h |  1 +
>  kernel/bpf/syscall.c       | 33 +++++++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+)
>
> v2 changes:
>   addressed Paul's comments from audit side:
>     - change 'event' field to 'op'
>     - change audit context passing
>     - check on 'op' value is within the limit
>
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index c89c6495983d..32a5db900f47 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -116,6 +116,7 @@
>  #define AUDIT_FANOTIFY         1331    /* Fanotify access decision */
>  #define AUDIT_TIME_INJOFFSET   1332    /* Timekeeping offset injected */
>  #define AUDIT_TIME_ADJNTPVAL   1333    /* NTP value adjustment */
> +#define AUDIT_BPF              1334    /* BPF subsystem */
>
>  #define AUDIT_AVC              1400    /* SE Linux avc denial or grant */
>  #define AUDIT_SELINUX_ERR      1401    /* Internal SE Linux Errors */
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index e3461ec59570..6536665f562c 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -23,6 +23,7 @@
>  #include <linux/timekeeping.h>
>  #include <linux/ctype.h>
>  #include <linux/nospec.h>
> +#include <linux/audit.h>
>  #include <uapi/linux/btf.h>
>
>  #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
> @@ -1306,6 +1307,36 @@ static int find_prog_type(enum bpf_prog_type type, struct bpf_prog *prog)
>         return 0;
>  }
>
> +enum bpf_audit {
> +       BPF_AUDIT_LOAD,
> +       BPF_AUDIT_UNLOAD,
> +       BPF_AUDIT_MAX,
> +};
> +
> +static const char * const bpf_audit_str[BPF_AUDIT_MAX] = {
> +       [BPF_AUDIT_LOAD]   = "LOAD",
> +       [BPF_AUDIT_UNLOAD] = "UNLOAD",
> +};
> +
> +static void bpf_audit_prog(const struct bpf_prog *prog, unsigned int op)
> +{
> +       struct audit_context *ctx = NULL;
> +       struct audit_buffer *ab;
> +
> +       if (audit_enabled == AUDIT_OFF)
> +               return;
> +       if (WARN_ON_ONCE(op >= BPF_AUDIT_MAX))
> +               return;

I feel bad saying this given the number of revisions we are at with
this patch, but since we aren't even at -rc1 yet (although it will be
here soon), I'm going to mention it anyway ;)

... if we move the "op >= BPF_AUDIT_MAX" above the audit_enabled check
we will catch problems sooner in development, which is a very good
thing as far as I'm concerned.

Other than that, this looks good to me, and I see Steve has already
given the userspace portion a thumbs-up.  Have you started on the
audit-testsuite test for this yet?

> +       if (op == BPF_AUDIT_LOAD)
> +               ctx = audit_context();
> +       ab = audit_log_start(ctx, GFP_ATOMIC, AUDIT_BPF);
> +       if (unlikely(!ab))
> +               return;
> +       audit_log_format(ab, "prog-id=%u op=%s",
> +                        prog->aux->id, bpf_audit_str[op]);
> +       audit_log_end(ab);
> +}
> +
>  int __bpf_prog_charge(struct user_struct *user, u32 pages)
>  {
>         unsigned long memlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> @@ -1421,6 +1452,7 @@ static void __bpf_prog_put(struct bpf_prog *prog, bool do_idr_lock)
>  {
>         if (atomic64_dec_and_test(&prog->aux->refcnt)) {
>                 perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_UNLOAD, 0);
> +               bpf_audit_prog(prog, BPF_AUDIT_UNLOAD);
>                 /* bpf_prog_free_id() must be called first */
>                 bpf_prog_free_id(prog, do_idr_lock);
>                 __bpf_prog_put_noref(prog, true);
> @@ -1830,6 +1862,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
>          */
>         bpf_prog_kallsyms_add(prog);
>         perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_LOAD, 0);
> +       bpf_audit_prog(prog, BPF_AUDIT_LOAD);
>
>         err = bpf_prog_new_fd(prog);
>         if (err < 0)
> --
> 2.21.0

-- 
paul moore
www.paul-moore.com
