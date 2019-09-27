Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83CB0C095B
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 18:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfI0QQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 12:16:09 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46494 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfI0QQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 12:16:09 -0400
Received: by mail-qk1-f194.google.com with SMTP id 201so2384219qkd.13;
        Fri, 27 Sep 2019 09:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WH+jCb5SoMk5PgpbLmgZLUs0O9xYNHix8ZiFZUfLT4o=;
        b=LPCmFaL1gv+jFl6/93kp6LkP/x2PmI/dci7AOy6LBaNXb6V1mHtMUx2hGdbu8xaO+j
         m1AJw04JWzLqlcgkn18mH4BgrbCVFIcjQWONu9gZeyTERhny0nWZxEPAWDDMXFVIz+Id
         pJfY2lpWXBPDmry6e6IuULKBN+YdiN1S1cDCiGI25rpdMGGqEWICzwmvxvz53ci2ZrCD
         Hw55wgxxk2IcSiiCwTJFZjFOI4O8BmqyvXTJ5TCLh19unXDHnQTC/5dPDZOaRQUq5LFF
         JniwYNzLKnF471vIMCAv8Ghxt998PFcHvpJ/WPpUaMvtvIPMNgPWYUqaBfgH4JV7MJTS
         cC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WH+jCb5SoMk5PgpbLmgZLUs0O9xYNHix8ZiFZUfLT4o=;
        b=ZsW9KyvDnokHSYMc86aizJmXqr7cUW6NgbFUNUwAEY3rjZFGaLrn7ZM4ql5pbETa1L
         se0KgXuQIxWtk6XBYK5bNu2BZda26SpOcxKVGxf7tqNGUKHHW2GaoBCN5iljzmspRR8I
         /Xmwjm48d314krD1qRwFAux0VPkUhpjNMnKbCcxuTZX3n92w2jhvdWiEh+2bgBLU2Qy2
         jV02AQNf7ofrtKYML4sxlnorTytR19+QfrTb4fspqzEVEa3/vEdVwuKI448m2x1UMGTm
         uaEI7fC+ub/zK5DN9RpekbH78P6PYlaZ24NUKoVa4AXWIbdM+5Oj55WalZl3DzU37O1r
         u/TQ==
X-Gm-Message-State: APjAAAVLMdifWKvMMd89FEWl/nEa0/U0YE0h3akyg9fU99epB+7+Z/Xs
        mj1R9aNsfbtguF8WI6XaP53NM/qXlB78TXaAaYg=
X-Google-Smtp-Source: APXvYqwcnZq6iS1/KX2eb586JfxIsGc2OnLE/cIhhWL5/lhF5aU9O3YnVMs6VvYYAU9vv9Me1Z2OpAfN6DgyIjZsB3g=
X-Received: by 2002:a05:620a:119a:: with SMTP id b26mr5405136qkk.39.1569600968422;
 Fri, 27 Sep 2019 09:16:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190924152005.4659-1-cneirabustos@gmail.com> <20190924152005.4659-3-cneirabustos@gmail.com>
In-Reply-To: <20190924152005.4659-3-cneirabustos@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 27 Sep 2019 09:15:57 -0700
Message-ID: <CAEf4BzZeO3cZJWVG0min98gnFs3E8D1m67E+3A_9-rTjHA_Ybg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v11 2/4] bpf: added new helper bpf_get_ns_current_pid_tgid
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        ebiederm@xmission.com, Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 1:15 AM Carlos Neira <cneirabustos@gmail.com> wrote:
>
> New bpf helper bpf_get_ns_current_pid_tgid,
> This helper will return pid and tgid from current task
> which namespace matches dev_t and inode number provided,
> this will allows us to instrument a process inside a container.
>
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---
>  include/linux/bpf.h      |  1 +
>  include/uapi/linux/bpf.h | 18 +++++++++++++++++-
>  kernel/bpf/core.c        |  1 +
>  kernel/bpf/helpers.c     | 32 ++++++++++++++++++++++++++++++++
>  kernel/trace/bpf_trace.c |  2 ++
>  5 files changed, 53 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 5b9d22338606..231001475504 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1055,6 +1055,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
>  extern const struct bpf_func_proto bpf_strtol_proto;
>  extern const struct bpf_func_proto bpf_strtoul_proto;
>  extern const struct bpf_func_proto bpf_tcp_sock_proto;
> +extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
>
>  /* Shared helpers among cBPF and eBPF. */
>  void bpf_user_rnd_init_once(void);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 77c6be96d676..9272dc8fb08c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2750,6 +2750,21 @@ union bpf_attr {
>   *             **-EOPNOTSUPP** kernel configuration does not enable SYN cookies
>   *
>   *             **-EPROTONOSUPPORT** IP packet version is not 4 or 6
> + *
> + * int bpf_get_ns_current_pid_tgid(u32 dev, u64 inum)
> + *     Return
> + *             A 64-bit integer containing the current tgid and pid from current task

Function signature doesn't correspond to the actual return type (int vs u64).

> + *              which namespace inode and dev_t matches , and is create as such:
> + *             *current_task*\ **->tgid << 32 \|**
> + *             *current_task*\ **->pid**.
> + *
> + *             On failure, the returned value is one of the following:
> + *
> + *             **-EINVAL** if dev and inum supplied don't match dev_t and inode number
> + *              with nsfs of current task.
> + *
> + *             **-ENOENT** if /proc/self/ns does not exists.
> + *
>   */

[...]

>  #include "../../lib/kstrtox.h"
>
> @@ -487,3 +489,33 @@ const struct bpf_func_proto bpf_strtoul_proto = {
>         .arg4_type      = ARG_PTR_TO_LONG,
>  };
>  #endif
> +
> +BPF_CALL_2(bpf_get_ns_current_pid_tgid, u32, dev, u64, inum)

Just curious, is dev_t officially specified as u32 and is never
supposed to grow bigger? I wonder if accepting u64 might be more
future-proof API here?

> +{
> +       struct task_struct *task = current;
> +       struct pid_namespace *pidns;

[...]
