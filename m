Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A4E10F30F
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 00:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfLBXA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 18:00:29 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45921 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfLBXA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 18:00:28 -0500
Received: by mail-lf1-f68.google.com with SMTP id 203so1189884lfa.12
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 15:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PwQrFv0qE39Z6AMGqk24ch6f5YGVUIl38q/H8NtbwdQ=;
        b=kPEQ9RtrQFLj2nDevpnPo4B3ffEGEwMaciO2htuuC3xiLLjLo9hcBfn0+9zYld9vTz
         5P4FgXqwaJmAxUPaIHPuHT5uIjYPD7DCK2ihxBMLoWhKVbtS1Itncz9k8B74yB6xcDaz
         zFHvFw3M6+NM/jlrtDSqhs538zTwOIgRm4Z6t9clTwH/Scc+khmyAp8zuDz0OM5b6sTG
         vWTAHpjjDMf5hn1VxHGfPoWVBT1aQNYEPKJ37FYiFEBM1frtx1LKok3OgciItxyD96Gm
         3mmKsfshTQm9Ge/SnVKN4nqjLwSKOLSh05p4Uw/5I9r5tG0vIy0fPIbVPnEfMU/QuCgC
         7f1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PwQrFv0qE39Z6AMGqk24ch6f5YGVUIl38q/H8NtbwdQ=;
        b=Dt9qHWRur4CVIOy9WxnRQXBpfPqN3s03nrCdQmVcqbghz/huulPmRetpv7XdwQ1sEH
         Fn5U3Pxy6G2puwA6DKtQNDEzEvxdT7CN+9oWQLPqycDaNcjAyNGy33cO6sZJWD6WHUN/
         XmgKrez/wISX5fRp0RjSWzyM0sGDJkDBgoQfZCVTYVELTKUAmPK1OFR5CBRBXFgBych+
         B/5fkopA3KAhDGXce76ydxvZlB0OaWsGMnYn4sRBmR16X+JVWw4VrSFp0TLd/uK8i4Ey
         5BwbLBF6zFm3jx/+PRvPizPb/frhTYxBUmYUjjzOzYxPddzon+E0205VzPgqHnGlkheT
         VO/g==
X-Gm-Message-State: APjAAAXygYFY433/9zH3L94bddPmTt/WTWsKy5ZTYKSax4jhY3vNtSOZ
        V8f9pPclNQGHBQfaujYaRGtw3/Mf6cZ2zHhTFpSM
X-Google-Smtp-Source: APXvYqwAASv9sx4uk88WgOrQWrHIZ31Yso3wS72CLdnuEcxMBTfmJk88MCa1DSZFQTcUxhuzuTB9D+Axh2H2Qpd0vkk=
X-Received: by 2002:a19:6553:: with SMTP id c19mr837129lfj.158.1575327625976;
 Mon, 02 Dec 2019 15:00:25 -0800 (PST)
MIME-Version: 1.0
References: <20191128091633.29275-1-jolsa@kernel.org>
In-Reply-To: <20191128091633.29275-1-jolsa@kernel.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 2 Dec 2019 18:00:14 -0500
Message-ID: <CAHC9VhQ7zkXdz1V5hQ8PN68-NnCn56TjKA0wCL6ZjHy9Up8fuQ@mail.gmail.com>
Subject: Re: [RFC] bpf: Emit audit messages upon successful prog load and unload
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

On Thu, Nov 28, 2019 at 4:16 AM Jiri Olsa <jolsa@kernel.org> wrote:
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
>  kernel/bpf/syscall.c       | 27 +++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+)

Hi all, sorry for the delay; the merge window in combination with the
holiday in the US bumped this back a bit.  Small comments inline below
...

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
> @@ -1306,6 +1307,30 @@ static int find_prog_type(enum bpf_prog_type type, struct bpf_prog *prog)
>         return 0;
>  }
>
> +enum bpf_audit {
> +       BPF_AUDIT_LOAD,
> +       BPF_AUDIT_UNLOAD,
> +};
> +
> +static const char * const bpf_audit_str[] = {
> +       [BPF_AUDIT_LOAD]   = "LOAD",
> +       [BPF_AUDIT_UNLOAD] = "UNLOAD",
> +};
> +
> +static void bpf_audit_prog(const struct bpf_prog *prog, enum bpf_audit op)
> +{
> +       struct audit_buffer *ab;
> +
> +       if (audit_enabled == AUDIT_OFF)
> +               return;

I think you would probably also want to check the results of
audit_dummy_context() here as well, see all the various audit_XXX()
functions in include/linux/audit.h as an example.  You'll see a
pattern similar to the following:

static inline void audit_foo(...)
{
  if (unlikely(!audit_dummy_context()))
    __audit_foo(...)
}

> +       ab = audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_BPF);
> +       if (unlikely(!ab))
> +               return;
> +       audit_log_format(ab, "prog-id=%u op=%s",
> +                        prog->aux->id, bpf_audit_str[op]);

Is it worth putting some checks in here to make sure that you don't
blow past the end of the bpf_audit_str array?

> +       audit_log_end(ab);
> +}

The audit record format looks much better now, thank you.  Although I
do wonder if you want bpf_audit_prog() to live in kernel/bpf/syscall.c
or in kernel/auditsc.c?  There is plenty of precedence for moving it
into auditsc.c and defining a no-op version for when
CONFIG_AUDITSYSCALL is not enabled, but I personally don't feel that
strongly about either option.  I just wanted to mention this in case
you weren't already aware.

If you do keep it in syscall.c, I don't think there is a need to
implement a no-op version dependent on CONFIG_AUDITSYSCALL; that will
just clutter the code.

If you do move it to auditsc.c please change the name to
audit_bpf()/__audit_bpf() so it matches the other functions; if you
keep it in syscall.c you can name it whatever you like :)

--
paul moore
www.paul-moore.com
