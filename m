Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B7D4AC922
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 20:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238378AbiBGTDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 14:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235289AbiBGS7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:59:41 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C245C0401DA;
        Mon,  7 Feb 2022 10:59:40 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id d188so18103707iof.7;
        Mon, 07 Feb 2022 10:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vCjZeNRcMberIdKYc/1uI6XuGgsV9pq+8Qq35xVVQKg=;
        b=nhN5MK/rg4pc++rSewICR5bIXm+UYggB9K/lnC3GjhqOKdlEOt6RrcvtgMQpIVcOz7
         EmIcpVVCwGlqjfxSNHWabAlLGsFENbb3dTPyRlezl0Sse9FtCqzfJcqiMzRi2HPggda4
         OEOWt1tEY65l01EA6VwkbcMGeMzXb+LCpGV4WIvxN6yqHHejCyV0p9HRU8AkqzBa4aLX
         ysGFrGuniFzz3SwsMhkswqXxqCfXrGi1M+JKwqgycLQ8J1mFb1zvqATa0PR9/lBy37Z0
         GIz6KQrqZ0U+S0GFeIm4WMRlWslNb0wn5oiJRt7Ymv6vBxlIDZ6gJ893nCErcyXkWvCF
         TNbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vCjZeNRcMberIdKYc/1uI6XuGgsV9pq+8Qq35xVVQKg=;
        b=r/mN84HKDqPzjP6ktBAYJc4nt+t/axQ1ANn6mEPVR8X1J979Zrq7g5RAep1kN+bMny
         yLv0D45WRrIxE6L5omAXdMDp/6iSnBEe0QjngtjKY8JbZXEvazMMsHMCxw6wNWDKMI8A
         7tblCnbYXu2jPhJswlqCo8lAfybx0EIxHsU5mTCm0giMO1jxe1v3AB7RAQK16KZ7TqNX
         +rqzrlB6CofKp2lDiiTdFUVQ+Qbj4CHVcaHKRhRs7u8wXycYo4VzuL77kz+95ywoH0y0
         Gw/JgMazdiCdKFa4gF35VRE/aYCWZb59/3o6em4A7+1L1RmLJuAbrTltS6w+8dRyuKPr
         mWAg==
X-Gm-Message-State: AOAM5300EPF2N4Atmw09ubAF2FgDZAw/1rNwbPtjOb0jylEnfvxaRCyV
        ubXLTWY2Fbe9e1V43hzo6yGIZDBh17H8Byn48bI=
X-Google-Smtp-Source: ABdhPJx2VykWB8J5wszsXjRiLgluBPf/jOQHOtQGbi2HYek/PsfZqpfKwXoVBCNh3kCpEXrCrV3XQTwhMygZ1Y1P+e0=
X-Received: by 2002:a5d:88c1:: with SMTP id i1mr443974iol.154.1644260380036;
 Mon, 07 Feb 2022 10:59:40 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org> <20220202135333.190761-7-jolsa@kernel.org>
In-Reply-To: <20220202135333.190761-7-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Feb 2022 10:59:29 -0800
Message-ID: <CAEf4BzZPSYzyoxrPC4uNHedhTr_75b2Qa8h3OC7GCK-n6mYrdg@mail.gmail.com>
Subject: Re: [PATCH 6/8] libbpf: Add bpf_program__attach_kprobe_opts for multi kprobes
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
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

On Wed, Feb 2, 2022 at 5:54 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding support to bpf_program__attach_kprobe_opts to load kprobes
> to multiple functions.
>
> If the kprobe program has BPF_TRACE_FPROBE as expected_attach_type
> it will use the new fprobe link to attach the program. In this case
> it will use 'func_name' as pattern for functions to attach.
>
> Adding also support to use '*' wildcard in 'kprobe/kretprobe' section
> name by SEC macro, like:
>
>   SEC("kprobe/bpf_fentry_test*")
>   SEC("kretprobe/bpf_fentry_test*")
>
> This will set kprobe's expected_attach_type to BPF_TRACE_FPROBE,
> and attach it to provided functions pattern.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 136 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 133 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7d595cfd03bc..6b343ef77ed8 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8607,13 +8607,15 @@ static struct bpf_link *attach_trace(const struct bpf_program *prog, long cookie
>  static struct bpf_link *attach_lsm(const struct bpf_program *prog, long cookie);
>  static struct bpf_link *attach_iter(const struct bpf_program *prog, long cookie);
>
> +static int init_kprobe(struct bpf_program *prog, long cookie);
> +
>  static const struct bpf_sec_def section_defs[] = {
>         SEC_DEF("socket",               SOCKET_FILTER, 0, SEC_NONE | SEC_SLOPPY_PFX),
>         SEC_DEF("sk_reuseport/migrate", SK_REUSEPORT, BPF_SK_REUSEPORT_SELECT_OR_MIGRATE, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
>         SEC_DEF("sk_reuseport",         SK_REUSEPORT, BPF_SK_REUSEPORT_SELECT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
> -       SEC_DEF("kprobe/",              KPROBE, 0, SEC_NONE, attach_kprobe),
> +       SEC_DEF("kprobe/",              KPROBE, 0, SEC_NONE, attach_kprobe, .init_fn = init_kprobe),
>         SEC_DEF("uprobe/",              KPROBE, 0, SEC_NONE),
> -       SEC_DEF("kretprobe/",           KPROBE, 0, SEC_NONE, attach_kprobe),
> +       SEC_DEF("kretprobe/",           KPROBE, 0, SEC_NONE, attach_kprobe, .init_fn = init_kprobe),
>         SEC_DEF("uretprobe/",           KPROBE, 0, SEC_NONE),
>         SEC_DEF("tc",                   SCHED_CLS, 0, SEC_NONE),
>         SEC_DEF("classifier",           SCHED_CLS, 0, SEC_NONE | SEC_SLOPPY_PFX | SEC_DEPRECATED),
> @@ -10031,6 +10033,123 @@ static int perf_event_kprobe_open_legacy(const char *probe_name, bool retprobe,
>         return pfd;
>  }
>
> +struct fprobe_resolve {
> +       const char *name;
> +       __u64 *addrs;
> +       __u32 alloc;
> +       __u32 cnt;
> +};
> +
> +static bool glob_matches(const char *glob, const char *s)

we've since added more generic glob_match() implementation (see
test_progs.c), let's copy/paste that one (it's actually shorter and
doesn't do hacky input args modification). Let's maybe also add '?'
handling (it's trivial). Both original code in perf and the one in
test_progs.c are GPL-2.0-only, so let's also get acks from original
authors.

> +{
> +       int n = strlen(glob);
> +
> +       if (n == 1 && glob[0] == '*')
> +               return true;
> +
> +       if (glob[0] == '*' && glob[n - 1] == '*') {
> +               const char *subs;
> +               /* substring match */
> +
> +               /* this is hacky, but we don't want to allocate
> +                * for no good reason
> +                */
> +               ((char *)glob)[n - 1] = '\0';
> +               subs = strstr(s, glob + 1);
> +               ((char *)glob)[n - 1] = '*';
> +
> +               return subs != NULL;
> +       } else if (glob[0] == '*') {
> +               size_t nn = strlen(s);
> +               /* suffix match */
> +
> +               /* too short for a given suffix */
> +               if (nn < n - 1)
> +                       return false;
> +               return strcmp(s + nn - (n - 1), glob + 1) == 0;
> +       } else if (glob[n - 1] == '*') {
> +               /* prefix match */
> +               return strncmp(s, glob, n - 1) == 0;
> +       } else {
> +               /* exact match */
> +               return strcmp(glob, s) == 0;
> +       }
> +}
> +
> +static int resolve_fprobe_cb(void *arg, unsigned long long sym_addr,
> +                            char sym_type, const char *sym_name)
> +{
> +       struct fprobe_resolve *res = arg;
> +       __u64 *p;
> +
> +       if (!glob_matches(res->name, sym_name))
> +               return 0;
> +
> +       if (res->cnt == res->alloc) {
> +               res->alloc = max((__u32) 16, res->alloc * 3 / 2);
> +               p = libbpf_reallocarray(res->addrs, res->alloc, sizeof(__u32));
> +               if (!p)
> +                       return -ENOMEM;
> +               res->addrs = p;
> +       }

please use libbpf_ensure_mem() instead


> +       res->addrs[res->cnt++] = sym_addr;
> +       return 0;
> +}
> +
> +static struct bpf_link *
> +attach_fprobe_opts(const struct bpf_program *prog,
> +                  const char *func_name,

func_glob or func_pattern?

> +                  const struct bpf_kprobe_opts *kopts)
> +{
> +       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> +       struct fprobe_resolve res = {
> +               .name = func_name,
> +       };
> +       struct bpf_link *link = NULL;
> +       char errmsg[STRERR_BUFSIZE];
> +       int err, link_fd, prog_fd;
> +       bool retprobe;
> +
> +       err = libbpf__kallsyms_parse(&res, resolve_fprobe_cb);
> +       if (err)
> +               goto error;
> +       if (!res.cnt) {
> +               err = -ENOENT;
> +               goto error;
> +       }
> +
> +       retprobe = OPTS_GET(kopts, retprobe, false);
> +
> +       opts.fprobe.addrs = (__u64) res.addrs;

ptr_to_u64()

> +       opts.fprobe.cnt = res.cnt;
> +       opts.flags = retprobe ? BPF_F_FPROBE_RETURN : 0;
> +
> +       link = calloc(1, sizeof(*link));
> +       if (!link) {
> +               err = -ENOMEM;
> +               goto error;
> +       }
> +       link->detach = &bpf_link__detach_fd;
> +
> +       prog_fd = bpf_program__fd(prog);
> +       link_fd = bpf_link_create(prog_fd, 0, BPF_TRACE_FPROBE, &opts);
> +       if (link_fd < 0) {
> +               err = -errno;
> +               pr_warn("prog '%s': failed to attach to %s: %s\n",
> +                       prog->name, res.name,
> +                       libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +               goto error;
> +       }
> +       link->fd = link_fd;
> +       free(res.addrs);
> +       return link;
> +
> +error:
> +       free(link);
> +       free(res.addrs);
> +       return libbpf_err_ptr(err);
> +}
> +
>  struct bpf_link *
>  bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
>                                 const char *func_name,
> @@ -10047,6 +10166,9 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
>         if (!OPTS_VALID(opts, bpf_kprobe_opts))
>                 return libbpf_err_ptr(-EINVAL);
>
> +       if (prog->expected_attach_type == BPF_TRACE_FPROBE)
> +               return attach_fprobe_opts(prog, func_name, opts);
> +
>         retprobe = OPTS_GET(opts, retprobe, false);
>         offset = OPTS_GET(opts, offset, 0);
>         pe_opts.bpf_cookie = OPTS_GET(opts, bpf_cookie, 0);
> @@ -10112,6 +10234,14 @@ struct bpf_link *bpf_program__attach_kprobe(const struct bpf_program *prog,
>         return bpf_program__attach_kprobe_opts(prog, func_name, &opts);
>  }
>
> +static int init_kprobe(struct bpf_program *prog, long cookie)
> +{
> +       /* If we have wildcard, switch to fprobe link. */
> +       if (strchr(prog->sec_name, '*'))

ugh... :( maybe let's have a separate SEC("kprobe.multi/<glob>") and
same for kretprobe?


> +               bpf_program__set_expected_attach_type(prog, BPF_TRACE_FPROBE);
> +       return 0;
> +}
> +
>  static struct bpf_link *attach_kprobe(const struct bpf_program *prog, long cookie)
>  {
>         DECLARE_LIBBPF_OPTS(bpf_kprobe_opts, opts);
> @@ -10127,7 +10257,7 @@ static struct bpf_link *attach_kprobe(const struct bpf_program *prog, long cooki
>         else
>                 func_name = prog->sec_name + sizeof("kprobe/") - 1;
>
> -       n = sscanf(func_name, "%m[a-zA-Z0-9_.]+%li", &func, &offset);
> +       n = sscanf(func_name, "%m[a-zA-Z0-9_.*]+%li", &func, &offset);
>         if (n < 1) {
>                 err = -EINVAL;
>                 pr_warn("kprobe name is invalid: %s\n", func_name);
> --
> 2.34.1
>
