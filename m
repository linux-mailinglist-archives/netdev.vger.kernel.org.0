Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED44C0A4C
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 19:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfI0RZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 13:25:01 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39746 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfI0RZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 13:25:01 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so2583549qki.6;
        Fri, 27 Sep 2019 10:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fp9/KftdEtpjpZzVghKC+B+z3dlnEYS7Civsnr0AZ4E=;
        b=me5qcWhJMrGiCSikVup1nS/W8tWE0A5jtsuDseaYTzV86Nh3QWB3dGWNGQxqSMOGle
         oK53yPL4k9PDoIKcwsvz2/LCYc3dkjcV6M4pmcqJHvHgf2agPoCYFKlp0CRstaVbUWNd
         3ydb0tqYnecGdwjjBdioEscfhSeIf2MNcahLCqH8mu0m86Adx/C86oIVw1qpgCqlQfFb
         6A56J9aCgU+qzq5F0QFKk//Ma6VPcuCKm8BZipXuUA0WHGJx2JqVLh54d55/kl8OrSDK
         ghW9pKGqhOoLe6aXaoSwQr2XPhX6Rm1jre/K6On44V7FV+h38hTqujZQYgmw7m0kBXTW
         gRBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fp9/KftdEtpjpZzVghKC+B+z3dlnEYS7Civsnr0AZ4E=;
        b=TgQm1g3XxoPbFjGm2/O0vBBrdaDyj5lhw+a5uceoje9hPBP0F15dSXg43AHpjr0Kd8
         sRWvXXLsPGdkhh5TYUx1I2WkgaW+kbYAbszaabJIhrqWj++06XttuBQCLIXNWV8r9etF
         uu83LsSBg9rHD3LHPiieVSHLCsCfEAP+z6dpUtBgmv4O2uhGP+cedxgupuGI6zR/JcLf
         UFDxN5EFdb20cjOKND+H2ElGGnLakzIyOUMPlEQ9zHkssUJthto5g+JzRABC3Kg5SixO
         TDkHg84SLb8NT+UuXEXQe4YD0pPnV8Vp67YOB3KYuSQh3rchKIBRTAZ97eZod1lx0CJ5
         o9kw==
X-Gm-Message-State: APjAAAWTe5Cesbafz/d3+BOxFJEBghnNLy1Z8SI0mYfATXlD74qrdiKb
        z/K4EgC9Pg+1/VcLIc/txGERaO15eDOUDPKO0b4=
X-Google-Smtp-Source: APXvYqwuRBk0PvMkvF0xZoDKljnR/rJCD+v2wFtXZ389qadU1r+o2jnBrtj20Vf3Bf5DIgii8GRyAe+oWFTidx4fsOc=
X-Received: by 2002:ae9:eb93:: with SMTP id b141mr5933377qkg.36.1569605098196;
 Fri, 27 Sep 2019 10:24:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190924152005.4659-1-cneirabustos@gmail.com> <20190924152005.4659-3-cneirabustos@gmail.com>
 <CAEf4BzZeO3cZJWVG0min98gnFs3E8D1m67E+3A_9-rTjHA_Ybg@mail.gmail.com> <12db0313-668e-3825-d5fa-28d0f675808c@fb.com>
In-Reply-To: <12db0313-668e-3825-d5fa-28d0f675808c@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 27 Sep 2019 10:24:46 -0700
Message-ID: <CAEf4BzYZGh774nS1EaCP4od9gzWqPtePPAGX6J7O+pEosnuYrQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v11 2/4] bpf: added new helper bpf_get_ns_current_pid_tgid
To:     Yonghong Song <yhs@fb.com>
Cc:     Carlos Neira <cneirabustos@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 9:59 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 9/27/19 9:15 AM, Andrii Nakryiko wrote:
> > On Thu, Sep 26, 2019 at 1:15 AM Carlos Neira <cneirabustos@gmail.com> wrote:
> >>
> >> New bpf helper bpf_get_ns_current_pid_tgid,
> >> This helper will return pid and tgid from current task
> >> which namespace matches dev_t and inode number provided,
> >> this will allows us to instrument a process inside a container.
> >>
> >> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> >> ---
> >>   include/linux/bpf.h      |  1 +
> >>   include/uapi/linux/bpf.h | 18 +++++++++++++++++-
> >>   kernel/bpf/core.c        |  1 +
> >>   kernel/bpf/helpers.c     | 32 ++++++++++++++++++++++++++++++++
> >>   kernel/trace/bpf_trace.c |  2 ++
> >>   5 files changed, 53 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> >> index 5b9d22338606..231001475504 100644
> >> --- a/include/linux/bpf.h
> >> +++ b/include/linux/bpf.h
> >> @@ -1055,6 +1055,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
> >>   extern const struct bpf_func_proto bpf_strtol_proto;
> >>   extern const struct bpf_func_proto bpf_strtoul_proto;
> >>   extern const struct bpf_func_proto bpf_tcp_sock_proto;
> >> +extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
> >>
> >>   /* Shared helpers among cBPF and eBPF. */
> >>   void bpf_user_rnd_init_once(void);
> >> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >> index 77c6be96d676..9272dc8fb08c 100644
> >> --- a/include/uapi/linux/bpf.h
> >> +++ b/include/uapi/linux/bpf.h
> >> @@ -2750,6 +2750,21 @@ union bpf_attr {
> >>    *             **-EOPNOTSUPP** kernel configuration does not enable SYN cookies
> >>    *
> >>    *             **-EPROTONOSUPPORT** IP packet version is not 4 or 6
> >> + *
> >> + * int bpf_get_ns_current_pid_tgid(u32 dev, u64 inum)
> >> + *     Return
> >> + *             A 64-bit integer containing the current tgid and pid from current task
> >
> > Function signature doesn't correspond to the actual return type (int vs u64).
> >
> >> + *              which namespace inode and dev_t matches , and is create as such:
> >> + *             *current_task*\ **->tgid << 32 \|**
> >> + *             *current_task*\ **->pid**.
> >> + *
> >> + *             On failure, the returned value is one of the following:
> >> + *
> >> + *             **-EINVAL** if dev and inum supplied don't match dev_t and inode number
> >> + *              with nsfs of current task.
> >> + *
> >> + *             **-ENOENT** if /proc/self/ns does not exists.
> >> + *
> >>    */
> >
> > [...]
> >
> >>   #include "../../lib/kstrtox.h"
> >>
> >> @@ -487,3 +489,33 @@ const struct bpf_func_proto bpf_strtoul_proto = {
> >>          .arg4_type      = ARG_PTR_TO_LONG,
> >>   };
> >>   #endif
> >> +
> >> +BPF_CALL_2(bpf_get_ns_current_pid_tgid, u32, dev, u64, inum)
> >
> > Just curious, is dev_t officially specified as u32 and is never
> > supposed to grow bigger? I wonder if accepting u64 might be more
> > future-proof API here?
>
> This is what we have now in kernel (include/linux/types.h)
> typedef u32 __kernel_dev_t;
> typedef __kernel_dev_t          dev_t;
>
> But userspace dev_t (defined at /usr/include/sys/types.h) have
> 8 bytes.
>
> Agree. Let us just use u64. It won't hurt and also will be fine
> if kernel internal dev_t becomes 64bit.

Sounds good. Let's not forget to check that conversion to dev_t
doesn't loose high bits, something like:

if ((u64)(dev_t)dev != dev)
    return -E<something>;

>
> >
> >> +{
> >> +       struct task_struct *task = current;
> >> +       struct pid_namespace *pidns;
> >
> > [...]
> >
