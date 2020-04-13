Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F411A6C85
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 21:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387883AbgDMTdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 15:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387876AbgDMTdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 15:33:32 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1FAC0A3BDC;
        Mon, 13 Apr 2020 12:33:32 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id g74so10667803qke.13;
        Mon, 13 Apr 2020 12:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qIiKYh1UWRhILa4wYdd2ozXCdGsAO7VYF986qRqPRDo=;
        b=tnO1f7XNe/IXlAEbdEOeDaHjjNi5yU6znoyNSY5cB+XhaCe1Ab9UkIrRurBD3swTvc
         rFlZaJwCDk/pNPKxC2Y/8aDMqc4oOG5klqRDunDRSL+i/v3ys4xjcGEopxZgUbgP50HY
         cn9oBa4/fVnKoPi9fDWuPq84KYii38HrmWeKUREHuE8GsmkDhTLo333VQ9IF+/269Qc4
         wC37DFtPNTUAHIKbjEeVr60xykSudUNBSiPk1pcO0Y7usKwjCQIDukJ7rljkzasqPRIY
         s8nbEtU6Uk8PQKBLpJkTbHjz+UKUt94SzTaR3X7CyXz1lyd1EqjKb9bFPXqa0ONLj4FB
         1nJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qIiKYh1UWRhILa4wYdd2ozXCdGsAO7VYF986qRqPRDo=;
        b=T8LpYxNz85YdG3+ZhBBdDY53DUkOWjjqGqserOz0nkU17S2ZPRW0LaBKWgKu3wnFSh
         eeaYyzxmb5qM73Wbk3JL5VL4+uZRdQmt8wBLHe0uAbxLmFkumqkAIyxBK8gz+ebxvH8J
         9VzfZechmeIt1tK/EB9IvTN4M38AtU2bGPWkdpT45i09dNV+Mz1NTNWl1D3hWXVFxzHN
         BSzpQTPtmGVcvlPMLxrc9nnLAEgHNQ8nHWDE8d3lMCROin2kYW2TOOVloO7ACtFrUCwf
         8wCIJUQ1raxz/vFQv/xSEojsFYIfIsMBLLPSl+Xw1HdGxAPWq0krnLPHfrfRdl+TtceY
         0EyA==
X-Gm-Message-State: AGi0Pub4WyIWHwtaZv7ZHsnY/rXApYgr9f6oUWgSHb3T8BnCy3rg8P55
        YGT+bcm7xKuKJND4TA7jRDoEsX4asYhUuFMYks4=
X-Google-Smtp-Source: APiQypLZwzK9CMBCMu8Tpjul437RRfsZqv6SDJYJcSOfCD2hU0Sxti68uE0RPE5LxFh6jGQ6ew4H2EnIL+UXx0a6qvE=
X-Received: by 2002:ae9:e854:: with SMTP id a81mr17916800qkg.36.1586806411677;
 Mon, 13 Apr 2020 12:33:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232524.2675603-1-yhs@fb.com>
 <CAEf4BzaTvAMOLVfhqvFCY_5Aj32J4vVSm343-C4Cg7Xyr65H4w@mail.gmail.com> <8005135f-03a1-17ae-29ca-c0b4b68c1eaa@fb.com>
In-Reply-To: <8005135f-03a1-17ae-29ca-c0b4b68c1eaa@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Apr 2020 12:33:20 -0700
Message-ID: <CAEf4Bza3K=Sk+SJNN5o9HY=i_+gkimGoYbwmDQy6b=K5mt-dwQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 04/16] bpf: allow loading of a dumper program
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 4:28 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/10/20 3:36 PM, Andrii Nakryiko wrote:
> > On Wed, Apr 8, 2020 at 4:25 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> A dumper bpf program is a tracing program with attach type
> >> BPF_TRACE_DUMP. During bpf program load, the load attribute
> >>     attach_prog_fd
> >> carries the target directory fd. The program will be
> >> verified against btf_id of the target_proto.
> >>
> >> If the program is loaded successfully, the dump target, as
> >> represented as a relative path to /sys/kernel/bpfdump,
> >> will be remembered in prog->aux->dump_target, which will
> >> be used later to create dumpers.
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   include/linux/bpf.h            |  2 ++
> >>   include/uapi/linux/bpf.h       |  1 +
> >>   kernel/bpf/dump.c              | 40 ++++++++++++++++++++++++++++++++++
> >>   kernel/bpf/syscall.c           |  8 ++++++-
> >>   kernel/bpf/verifier.c          | 15 +++++++++++++
> >>   tools/include/uapi/linux/bpf.h |  1 +
> >>   6 files changed, 66 insertions(+), 1 deletion(-)
> >>
> >
> > [...]
> >
> >>
> >> +int bpf_dump_set_target_info(u32 target_fd, struct bpf_prog *prog)
> >> +{
> >> +       struct bpfdump_target_info *tinfo;
> >> +       const char *target_proto;
> >> +       struct file *target_file;
> >> +       struct fd tfd;
> >> +       int err = 0, btf_id;
> >> +
> >> +       if (!btf_vmlinux)
> >> +               return -EINVAL;
> >> +
> >> +       tfd = fdget(target_fd);
> >> +       target_file = tfd.file;
> >> +       if (!target_file)
> >> +               return -EBADF;
> >
> > fdput is missing (or rather err = -BADF; goto done; ?)
>
> No need to do fdput if tfd.file is NULL.

ah, right :)

>
> >
> >
> >> +
> >> +       if (target_file->f_inode->i_op != &bpf_dir_iops) {
> >> +               err = -EINVAL;
> >> +               goto done;
> >> +       }
> >> +
> >> +       tinfo = target_file->f_inode->i_private;
> >> +       target_proto = tinfo->target_proto;
> >> +       btf_id = btf_find_by_name_kind(btf_vmlinux, target_proto,
> >> +                                      BTF_KIND_FUNC);
> >> +
> >> +       if (btf_id > 0) {
> >> +               prog->aux->dump_target = tinfo->target;
> >> +               prog->aux->attach_btf_id = btf_id;
> >> +       }
> >> +
> >> +       err = min(btf_id, 0);
> >
> > this min trick looks too clever... why not more straightforward and composable:
> >
> > if (btf_id < 0) {
> >      err = btf_id;
> >      goto done;
> > }
> >
> > prog->aux->dump_target = tinfo->target;
> > prog->aux->attach_btf_id = btf_id;
> >
> > ?
>
> this can be done.
>
> >
> >> +done:
> >> +       fdput(tfd);
> >> +       return err;
> >> +}
> >> +
> >>   int bpf_dump_reg_target(const char *target,
> >>                          const char *target_proto,
> >>                          const struct seq_operations *seq_ops,
> >> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> >> index 64783da34202..41005dee8957 100644
> >> --- a/kernel/bpf/syscall.c
> >> +++ b/kernel/bpf/syscall.c
> >> @@ -2060,7 +2060,12 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
> >>
> >>          prog->expected_attach_type = attr->expected_attach_type;
> >>          prog->aux->attach_btf_id = attr->attach_btf_id;
> >> -       if (attr->attach_prog_fd) {
> >> +       if (type == BPF_PROG_TYPE_TRACING &&
> >> +           attr->expected_attach_type == BPF_TRACE_DUMP) {
> >> +               err = bpf_dump_set_target_info(attr->attach_prog_fd, prog);
> >
> > looking at bpf_attr, it's not clear why attach_prog_fd and
> > prog_ifindex were not combined into a single union field... this
> > probably got missed? But in this case I'd say let's create a
> >
> > union {
> >      __u32 attach_prog_fd;
> >      __u32 attach_target_fd; (similar to terminology for BPF_PROG_ATTACH)
> > };
> >
> > instead of reusing not-exactly-matching field names?
>
> I thought about this, but thinking to avoid uapi change (although
> compatible). Maybe we should. Let me think about this.

This is creating a new alias for the same field, so should be fine
from UAPI perspective.

>
> >
> >> +               if (err)
> >> +                       goto free_prog_nouncharge;
> >> +       } else if (attr->attach_prog_fd) {
> >>                  struct bpf_prog *tgt_prog;
> >>
> >>                  tgt_prog = bpf_prog_get(attr->attach_prog_fd);
> >> @@ -2145,6 +2150,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
> >>          err = bpf_prog_new_fd(prog);
> >>          if (err < 0)
> >>                  bpf_prog_put(prog);
> >> +
> >>          return err;
> >>
> >
> > [...]
> >
