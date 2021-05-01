Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDF33705E9
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 08:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhEAGdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 02:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhEAGdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 02:33:39 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B520C06174A;
        Fri, 30 Apr 2021 23:32:50 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y2so137448plr.5;
        Fri, 30 Apr 2021 23:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WN5NuPCEJ++Ln+DYOoWYaEWAn8Bhq95l7teuD1p1ksA=;
        b=hCjCzClrvoWrUpw/gB+PUs7KI13TND51BOzTZ829C3rOWevdJgbHXgkyztCKLa5IhC
         o0mLjMXXCwODt99EkTqCN4b7Yy5mDXTed3PoUX8t1ebf8e0Gkk01FDQp5jeL36SUEFZM
         fqaXkkH6x7iLnSErQ3nagVboOqwcNDAzez5hoR/nWLHKJmVlRqEmuKB6TOYGatNd/gbv
         CkNHicGi6qZvkAXqufG6TpQjH4JPiD/u177JK17Oy6Zy3Q39pX0rXcn6eWOLEkRV0s3x
         FLvL7H+JeXKt77MDCiFrN87W+RFXV8Ogqc9CUG0wNZ3tjChEVEGC0S7crkAUCFuIFMiL
         ZMVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WN5NuPCEJ++Ln+DYOoWYaEWAn8Bhq95l7teuD1p1ksA=;
        b=kRhtCUZcN2GriXRJgf7ayh0AOKDg0kQhplLzBr4PAyk73JreLDaduudYJ2lgTZ5tl7
         cpqiNztyMpGzjAijL2GjLE/XWvvvQ7gyHfXxbrqQ2sibxZABdJGPI0BwdIZR66zaaGHK
         jTruKsiLjaCtfr8/XLWgmFZ7RNK9FxvYbqSOSGpbVfcoSPeX9MZwyVFW3R+5hNQVAVjY
         mlUmi2vcuVChp7yEBVU7BCDlzr01aXysvvRUiEkum6kcEkhCrAecCYRrAbMjCoo8o2gc
         IMqfuneqFDDTF1FaEP6UKnQtRhx1crJhZILfOu9+98/ejIc+EFhXrYIJmbtZ8R3se9Eu
         ykzg==
X-Gm-Message-State: AOAM531Qd/jIMG4T5iQPSlZr4rKbAfESBIzq27dGtdiEtUs2WwHNDSBt
        932OXU+L+OIzFFauBoQ8tbU=
X-Google-Smtp-Source: ABdhPJyRHIzpVQAMUFRC2oPRnAgTyKGfQdPKvujN4f/UDypwJGRPUsprR813hWFgxJHEW+MfMdENgA==
X-Received: by 2002:a17:90b:4b90:: with SMTP id lr16mr16226706pjb.203.1619850769540;
        Fri, 30 Apr 2021 23:32:49 -0700 (PDT)
Received: from localhost ([112.79.230.123])
        by smtp.gmail.com with ESMTPSA id p65sm3787605pfb.76.2021.04.30.23.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 23:32:49 -0700 (PDT)
Date:   Sat, 1 May 2021 12:02:46 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Shaun Crampton <shaun@tigera.io>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v5 2/3] libbpf: add low level TC-BPF API
Message-ID: <20210501063246.iqhw5sdvx4iwllng@apollo>
References: <20210428162553.719588-1-memxor@gmail.com>
 <20210428162553.719588-3-memxor@gmail.com>
 <CAEf4BzYhOQu1A-iK_D-gzcxfZj4BfDXoJ5=8zzHL8qO-URfRiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzYhOQu1A-iK_D-gzcxfZj4BfDXoJ5=8zzHL8qO-URfRiA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 01, 2021 at 01:05:40AM IST, Andrii Nakryiko wrote:
> On Wed, Apr 28, 2021 at 9:26 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This adds functions that wrap the netlink API used for adding,
> > manipulating, and removing traffic control filters.
> >
> > An API summary:
> >
> > A bpf_tc_hook represents a location where a TC-BPF filter can be
> > attached. This means that creating a hook leads to creation of the
> > backing qdisc, while destruction either removes all filters attached to
> > a hook, or destroys qdisc if requested explicitly (as discussed below).
> >
> > The TC-BPF API functions operate on this bpf_tc_hook to attach, replace,
> > query, and detach tc filters.
> >
> > All functions return 0 on success, and a negative error code on failure.
> >
> > bpf_tc_hook_create - Create a hook
> > Parameters:
> >         @hook - Cannot be NULL, ifindex > 0, attach_point must be set to
> >                 proper enum constant. Note that parent must be unset when
> >                 attach_point is one of BPF_TC_INGRESS or BPF_TC_EGRESS. Note
> >                 that as an exception BPF_TC_INGRESS|BPF_TC_EGRESS is also a
> >                 valid value for attach_point.
> >
> >                 Returns -EOPNOTSUPP when hook has attach_point as BPF_TC_CUSTOM.
> >
> >         @flags - Currently only BPF_TC_F_REPLACE, which creates qdisc in
> >                  non-exclusive mode (i.e. an existing qdisc will be replaced
> >                  instead of this function failing with -EEXIST).
> >
> > bpf_tc_hook_destroy - Destroy the hook
> > Parameters:
> >         @hook - Cannot be NULL. The behaviour depends on value of
> >                 attach_point.
> >
> >                 If BPF_TC_INGRESS, all filters attached to the ingress
> >                 hook will be detached.
> >                 If BPF_TC_EGRESS, all filters attached to the egress hook
> >                 will be detached.
> >                 If BPF_TC_INGRESS|BPF_TC_EGRESS, the clsact qdisc will be
> >                 deleted, also detaching all filters.
> >
> >                 It is advised that if the qdisc is operated on by many programs,
> >                 then the program atleast check that there are no other existing
>
> typo: at least
>

Will fix.

> >                 filters before deleting the clsact qdisc. An example is shown
> >                 below:
> >
> >                 /* set opts as NULL, as we're not really interested in
> >                  * getting any info for a particular filter, but just
> >                  * detecting its presence.
> >                  */
>
> this comment probably is better moved to right before bpf_tc_query,
> otherwise it reads as if it's related to bpf_tc_hook
>

Ok.

> >                 DECLARE_LIBBPF_OPTS(bpf_tc_hook, .ifindex = if_nametoindex("lo"),
> >                                     .attach_point = BPF_TC_INGRESS);
> >                 r = bpf_tc_query(&hook, NULL);
> >                 if (r < 0 && r == -ENOENT) {
>
> well, r == -ENOENT should be enough then, no?
>

Yes, I'll change it.

> >                         /* no filters */
> >                         hook.attach_point = BPF_TC_INGRESS|BPF_TC_EGREESS;
> >                         return bpf_tc_hook_destroy(&hook);
> >                 } else /* failed or r == 0, the latter means filters do exist */
> >                         return r;
> >
> >                 Note that there is a small race between checking for no
> >                 filters and deleting the qdisc. This is currently unavoidable.
> >
> >                 Returns -EOPNOTSUPP when hook has attach_point as BPF_TC_CUSTOM.
> >
> > bpf_tc_attach - Attach a filter to a hook
> > Parameters:
> >         @hook - Cannot be NULL. Represents the hook the filter will be
> >                 attached to. Requirements for ifindex and attach_point are
> >                 same as described in bpf_tc_hook_create, but BPF_TC_CUSTOM
> >                 is also supported.  In that case, parent must be set to the
> >                 handle where the filter will be attached (using TC_H_MAKE).
> >
> >                 E.g. To set parent to 1:16 like in tc command line,
> >                      the equivalent would be TC_H_MAKE(1 << 16, 16)
> >
> >         @opts - Cannot be NULL.
> >
> >                 The following opts are optional:
> >                         handle - The handle of the filter
> >                         priority - The priority of the filter
> >                                    Must be >= 0 and <= UINT16_MAX
> >                 The following opts must be set:
> >                         prog_fd - The fd of the loaded SCHED_CLS prog
> >                 The following opts must be unset:
> >                         prog_id - The ID of the BPF prog
> >
> >                 The following opts will be filled by bpf_tc_attach on a
> >                 successful attach operation if they are unset:
> >                         handle - The handle of the attached filter
> >                         priority - The priority of the attached filter
> >                         prog_id - The ID of the attached SCHED_CLS prog
> >
> >                 This way, the user can know what the auto allocated
> >                 values for optional opts like handle and priority are
> >                 for the newly attached filter, if they were unset.
> >
> >                 Note that some other attributes are set to some default
> >                 values listed below (this holds for all bpf_tc_* APIs):
> >                         protocol - ETH_P_ALL
> >                         mode - direct action
> >                         chain index - 0
> >                         class ID - 0 (this can be set by writing to the
> >                         skb->tc_classid field from the BPF program)
> >
> >         @flags - Currently only BPF_TC_F_REPLACE, which creates filter
> >                  in non-exclusive mode (i.e. an existing filter with the
> >                  same attributes will be replaced instead of this
> >                  function failing with -EEXIST).
> >
> > bpf_tc_detach
> > Parameters:
> >         @hook: Cannot be NULL. Represents the hook the filter will be
> >                 detached from. Requirements are same as described above
> >                 in bpf_tc_attach.
> >
> >         @opts:  Cannot be NULL.
> >
> >                 The following opts must be set:
> >                         handle
> >                         priority
> >                 The following opts must be unset:
> >                         prog_fd
> >                         prog_id
> >
> > bpf_tc_query
> > Parameters:
> >         @hook: Cannot be NULL. Represents the hook where the filter
> >                lookup will be performed. Requires are same as described
> >                above in bpf_tc_attach.
> >
> >         @opts: Can be NULL.
> >
> >                The following opts are optional:
> >                         handle
> >                         priority
> >                         prog_fd
> >                         prog_id
> >
> >                However, only one of prog_fd and prog_id must be
> >                set. Setting both leads to an error. Setting none is
> >                allowed.
> >
> >                The following fields will be filled by bpf_tc_query on a
> >                successful lookup if they are unset:
> >                         handle
> >                         priority
> >                         prog_id
> >
> >                Based on the specified optional parameters, the matching
> >                data for the first matching filter is filled in and 0 is
> >                returned. When setting prog_fd, the prog_id will be
> >                matched against prog_id of the loaded SCHED_CLS prog
> >                represented by prog_fd.
> >
> >                To uniquely identify a filter, e.g. to detect its presence,
> >                it is recommended to set both handle and priority fields.
> >
> > Some usage examples (using bpf skeleton infrastructure):
> >
> > BPF program (test_tc_bpf.c):
> >
> >         #include <linux/bpf.h>
> >         #include <bpf/bpf_helpers.h>
> >
> >         SEC("classifier")
> >         int cls(struct __sk_buff *skb)
> >         {
> >                 return 0;
> >         }
> >
> > Userspace loader:
> >
> >         DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, 0);
> >         struct test_tc_bpf *skel = NULL;
> >         int fd, r;
> >
> >         skel = test_tc_bpf__open_and_load();
> >         if (!skel)
> >                 return -ENOMEM;
> >
> >         fd = bpf_program__fd(skel->progs.cls);
> >
> >         DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex =
> >                             if_nametoindex("lo"), .attach_point =
> >                             BPF_TC_INGRESS);
> >         /* Create clsact qdisc */
> >         r = bpf_tc_hook_create(&hook, 0);
> >         if (r < 0)
> >                 goto end;
> >
> >         DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .prog_fd = fd);
>
> I don't feel too strongly about this w.r.t. example, but
> DECLARE_LIBBPF_OPTS() does declare a variable, so according to C89 all
> such declarations should be gathered at the top. It would be nice to
> stick to this in the example, but I can see how such locality is a bit
> better for educational purposes, so I'm ok with that as well.
>
> >         r = bpf_tc_attach(&hook, &opts, 0);
> >         if (r < 0)
> >                 goto end;
> >         /* Print the auto allocated handle and priority */
> >         printf("Handle=%"PRIu32", opts.handle);
>
> let's drop PRIu32, libbpf doesn't use it so let's not use it as an
> example, %u would work fine here
>

Ok, will drop.

> >         printf("Priority=%"PRIu32", opts.priority);
> >
> >         opts.prog_fd = opts.prog_id = 0;
> >         bpf_tc_detach(&hook, &opts);
> > end:
> >         test_tc_bpf__destroy(skel);
> >
> > This is equivalent to doing the following using tc command line:
> >   # tc qdisc add dev lo clsact
> >   # tc filter add dev lo ingress bpf obj foo.o sec classifier da
> >
> > Another example replacing a filter (extending prior example):
> >
> >         /* We can also choose both (or one), let's try replacing an
> >          * existing filter.
> >          */
> >         DECLARE_LIBBPF_OPTS(bpf_tc_opts, replace_opts, .handle =
> >                             opts.handle, .priority = opts.priority,
> >                             .prog_fd = fd);
> >         r = bpf_tc_attach(&hook, &replace_opts, 0);
> >         if (r < 0 && r == -EEXIST) {
>
> again, == -EEXISTS implies r < 0, this just looks sloppy
>
> >                 /* Expected, now use BPF_TC_F_REPLACE to replace it */
> >                 return bpf_tc_attach(&hook, &replace_opts, BPF_TC_F_REPLACE);
> >         } else if (r == 0) {
>
> I'd go with
>
> else if (r < 0) {
>     return r;
> }
>
> /* handle happy case without unnecessary nesting */
>

Ok.

> >                 /* There must be no existing filter with these
> >                  * attributes, so cleanup and return an error.
> >                  */
> >                 replace_opts.prog_fd = replace_opts.prog_id = 0;
> >                 r = bpf_tc_detach(&hook, &replace_opts);
> >                 if (r == 0)
> >                         r = -1;
>
> just return -1;
>

Ok.

> >         }
> >         return r;
> >
> > To obtain info of a particular filter:
> >
> >         /* Find info for filter with handle 1 and priority 50 */
> >         DECLARE_LIBBPF_OPTS(bpf_tc_opts, info_opts, .handle = 1,
> >                             .priority = 50);
> >         r = bpf_tc_query(&hook, &info_opts);
> >         if (r < 0 && r == -ENOENT)
> >                 printf("Filter not found");
> >         else if (r == 0)
> >                 printf("Prog ID: %"PRIu32", info_opts.prog_id);
>
> same about PRI and r < 0
>
> >         return r;
> >
> > We can also match using prog_id to find the same filter:
> >
> >         DECLARE_LIBBPF_OPTS(bpf_tc_opts, info_opts2, .prog_id =
> >                             info_opts.prog_id);
> >         r = bpf_tc_query(&hook, &info_opts2);
> >         if (r < 0 && r == -ENOENT)
> >                 printf("Filter not found");
> >         else if (r == 0) {
> >                 /* If we know there's only one filter for this loaded prog,
> >                  * it is safe to assert that the handle and priority are
> >                  * as expected.
> >                  */
> >                 assert(info_opts2.handle == 1);
> >                 assert(info_opts2.priority == 50);
> >         }
> >         return r;
> >
> > Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
>
> API looks good to me (except the flags field that just stands out).
> But I'll defer to Daniel to make the final call.
>
> >  tools/lib/bpf/libbpf.h   |  41 ++++
> >  tools/lib/bpf/libbpf.map |   5 +
> >  tools/lib/bpf/netlink.c  | 463 ++++++++++++++++++++++++++++++++++++++-
> >  3 files changed, 508 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index bec4e6a6e31d..3de701f46a33 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -775,6 +775,47 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
> >  LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
> >  LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
> >
> > +enum bpf_tc_attach_point {
> > +       BPF_TC_INGRESS = 1 << 0,
> > +       BPF_TC_EGRESS  = 1 << 1,
> > +       BPF_TC_CUSTOM  = 1 << 2,
> > +};
> > +
> > +enum bpf_tc_attach_flags {
> > +       BPF_TC_F_REPLACE = 1 << 0,
> > +};
> > +
> > +struct bpf_tc_hook {
> > +       size_t sz;
> > +       int ifindex;
> > +       enum bpf_tc_attach_point attach_point;
> > +       __u32 parent;
> > +       size_t :0;
> > +};
> > +
> > +#define bpf_tc_hook__last_field parent
> > +
> > +struct bpf_tc_opts {
> > +       size_t sz;
> > +       int prog_fd;
> > +       __u32 prog_id;
> > +       __u32 handle;
> > +       __u32 priority;
> > +       size_t :0;
> > +};
> > +
> > +#define bpf_tc_opts__last_field priority
> > +
> > +LIBBPF_API int bpf_tc_hook_create(struct bpf_tc_hook *hook, int flags);
> > +LIBBPF_API int bpf_tc_hook_destroy(struct bpf_tc_hook *hook);
> > +LIBBPF_API int bpf_tc_attach(const struct bpf_tc_hook *hook,
> > +                            struct bpf_tc_opts *opts,
> > +                            int flags);
>
> why didn't you put flags into bpf_tc_opts? they are clearly optional
> and fit into "opts" paradigm...
>

I can move this into opts, but during previous discussion it was kept outside
opts by Daniel, so I kept that unchanged.

> > +LIBBPF_API int bpf_tc_detach(const struct bpf_tc_hook *hook,
> > +                            const struct bpf_tc_opts *opts);
> > +LIBBPF_API int bpf_tc_query(const struct bpf_tc_hook *hook,
> > +                           struct bpf_tc_opts *opts);
> > +
> >  #ifdef __cplusplus
> >  } /* extern "C" */
> >  #endif
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index b9b29baf1df8..04509c7c144b 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -361,4 +361,9 @@ LIBBPF_0.4.0 {
> >                 bpf_linker__new;
> >                 bpf_map__inner_map;
> >                 bpf_object__set_kversion;
> > +               bpf_tc_hook_create;
> > +               bpf_tc_hook_destroy;
>
> please keep this alphabetically sorted
>

Ok.

> > +               bpf_tc_attach;
> > +               bpf_tc_detach;
> > +               bpf_tc_query;
> >  } LIBBPF_0.3.0;
> > diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> > index 6daee6640725..88f7b6144c78 100644
> > --- a/tools/lib/bpf/netlink.c
> > +++ b/tools/lib/bpf/netlink.c
> > @@ -4,7 +4,11 @@
> >  #include <stdlib.h>
> >  #include <memory.h>
> >  #include <unistd.h>
> > +#include <inttypes.h>
> > +#include <arpa/inet.h>
> >  #include <linux/bpf.h>
> > +#include <linux/if_ether.h>
> > +#include <linux/pkt_cls.h>
> >  #include <linux/rtnetlink.h>
> >  #include <sys/socket.h>
> >  #include <errno.h>
> > @@ -73,6 +77,12 @@ static int libbpf_netlink_open(__u32 *nl_pid)
> >         return ret;
> >  }
> >
> > +enum {
> > +       BPF_NL_CONT,
> > +       BPF_NL_NEXT,
> > +       BPF_NL_DONE,
> > +};
> > +
> >  static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
> >                             __dump_nlmsg_t _fn, libbpf_dump_nlmsg_t fn,
> >                             void *cookie)
> > @@ -84,6 +94,7 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
> >         int len, ret;
> >
> >         while (multipart) {
> > +start:
> >                 multipart = false;
> >                 len = recv(sock, buf, sizeof(buf), 0);
> >                 if (len < 0) {
> > @@ -121,8 +132,18 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
> >                         }
> >                         if (_fn) {
> >                                 ret = _fn(nh, fn, cookie);
> > -                               if (ret)
> > +                               if (ret < 0)
> > +                                       return ret;
> > +                               switch (ret) {
> > +                               case BPF_NL_CONT:
> > +                                       break;
> > +                               case BPF_NL_NEXT:
> > +                                       goto start;
> > +                               case BPF_NL_DONE:
> > +                                       return 0;
> > +                               default:
> >                                         return ret;
> > +                               }
> >                         }
> >                 }
> >         }
> > @@ -357,3 +378,443 @@ static int libbpf_nl_send_recv(struct nlmsghdr *nh, __dump_nlmsg_t fn,
> >         close(sock);
> >         return ret;
> >  }
> > +
> > +/* TC-HOOK */
> > +
> > +typedef int (*qdisc_config_t)(struct nlmsghdr *nh, struct tcmsg *t,
> > +                             size_t maxsz);
> > +
> > +static int clsact_config(struct nlmsghdr *nh, struct tcmsg *t, size_t maxsz)
> > +{
> > +       int ret;
> > +
> > +       t->tcm_parent = TC_H_CLSACT;
> > +       t->tcm_handle = TC_H_MAKE(TC_H_CLSACT, 0);
> > +
> > +       ret = nlattr_add(nh, maxsz, TCA_KIND, "clsact", sizeof("clsact"));
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       return 0;
>
> nit: return nlattr_add(...)
>

Will fix.

> > +}
> > +
> > +static int attach_point_to_config(struct bpf_tc_hook *hook, qdisc_config_t *configp)
> > +{
> > +       if (!hook)
> > +               return -EINVAL;
>
> !hook should be already ensured by calling functions, no need to
> re-check this everywhere, do this only in API methods. All internal
> functions should already ensure non-NULL, otherwise it's a bug.
>

Right, will fix.

> > +
> > +       switch ((int)OPTS_GET(hook, attach_point, 0)) {
>
> is int casting necessary here?
>
> > +               case BPF_TC_INGRESS:
> > +               case BPF_TC_EGRESS:
> > +               case BPF_TC_INGRESS|BPF_TC_EGRESS:
> > +                       if (OPTS_GET(hook, parent, 0))
> > +                               return -EINVAL;
> > +                       *configp = &clsact_config;
> > +                       break;
> > +               case BPF_TC_CUSTOM:
> > +                       return -EOPNOTSUPP;
> > +               default:
> > +                       return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static long long int tc_get_tcm_parent(enum bpf_tc_attach_point attach_point,
> > +                                      __u32 parent)
> > +{
> > +       long long int ret;
> > +
> > +       switch (attach_point) {
> > +       case BPF_TC_INGRESS:
> > +               if (parent)
> > +                       return -EINVAL;
> > +               ret = TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS);
>
> direct return
>
> > +               break;
> > +       case BPF_TC_EGRESS:
> > +               if (parent)
> > +                       return -EINVAL;
> > +               ret = TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS);
>
> same, make it explicit that we are done and it's the final value returned
>
> > +               break;
> > +       case BPF_TC_CUSTOM:
> > +               if (!parent)
> > +                       return -EINVAL;
> > +               ret = parent;
> > +               break;
> > +       default:
> > +               return -EINVAL;
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +static int tc_qdisc_modify(struct bpf_tc_hook *hook, int cmd, int flags)
> > +{
> > +       qdisc_config_t config;
> > +       int ret = 0;
>
> unnecessary initialization, some tooling definitely will complain,
> please drop = 0 part
>
> > +       struct {
> > +               struct nlmsghdr nh;
> > +               struct tcmsg t;
> > +               char buf[256];
> > +       } req;
> > +
> > +       ret = attach_point_to_config(hook, &config);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       memset(&req, 0, sizeof(req));
> > +       req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg));
> > +       req.nh.nlmsg_flags =
> > +               NLM_F_REQUEST | NLM_F_ACK | flags;
>
> we can go up to 100 character lines, keep it on single line
>
> > +       req.nh.nlmsg_type = cmd;
> > +       req.t.tcm_family = AF_UNSPEC;
> > +       req.t.tcm_ifindex = OPTS_GET(hook, ifindex, 0);
> > +
> > +       ret = config(&req.nh, &req.t, sizeof(req));
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       ret = libbpf_nl_send_recv(&req.nh, NULL, NULL, NULL);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       return 0;
> > +}
> > +
> > +static int tc_qdisc_create_excl(struct bpf_tc_hook *hook, int flags)
> > +{
> > +       flags = flags & BPF_TC_F_REPLACE ? NLM_F_REPLACE : NLM_F_EXCL;
>
> see below as well, please use () around bit operators
>

Right.

> > +       return tc_qdisc_modify(hook, RTM_NEWQDISC, NLM_F_CREATE | flags);
> > +}
> > +
> > +static int tc_qdisc_delete(struct bpf_tc_hook *hook)
> > +{
> > +       return tc_qdisc_modify(hook, RTM_DELQDISC, 0);
> > +}
> > +
> > +int bpf_tc_hook_create(struct bpf_tc_hook *hook, int flags)
> > +{
> > +       if (!hook || !OPTS_VALID(hook, bpf_tc_hook))
> > +               return -EINVAL;
> > +       if (OPTS_GET(hook, ifindex, 0) <= 0 || flags & ~BPF_TC_F_REPLACE)
>
> please use () around bit operators
>

Ok.

> > +               return -EINVAL;
> > +
> > +       return tc_qdisc_create_excl(hook, flags);
> > +}
> > +
> > +static int tc_cls_detach(const struct bpf_tc_hook *hook,
> > +                        const struct bpf_tc_opts *opts, bool flush);
> > +
> > +int bpf_tc_hook_destroy(struct bpf_tc_hook *hook)
> > +{
> > +       if (!hook || !OPTS_VALID(hook, bpf_tc_hook) ||
> > +           OPTS_GET(hook, ifindex, 0) <= 0)
> > +               return -EINVAL;
> > +
> > +       switch ((int)OPTS_GET(hook, attach_point, 0)) {
>
> int casting. Did the compiler complain about that or what?
>

It complains on -Wswitch, as we switch on values apart from the enum values, but
I'll see if I can remove it.

> > +               case BPF_TC_INGRESS:
> > +               case BPF_TC_EGRESS:
> > +                       return tc_cls_detach(hook, NULL, true);
> > +               case BPF_TC_INGRESS|BPF_TC_EGRESS:
> > +                       return tc_qdisc_delete(hook);
> > +               case BPF_TC_CUSTOM:
> > +                       return -EOPNOTSUPP;
> > +               default:
> > +                       return -EINVAL;
> > +       }
> > +}
> > +
> > +struct pass_info {
> > +       struct bpf_tc_opts *opts;
> > +       __u32 match_prog_id;
> > +       bool processed;
> > +};
> > +
> > +/* TC-BPF */
> > +
> > +static int tc_cls_add_fd_and_name(struct nlmsghdr *nh, size_t maxsz, int fd)
> > +{
> > +       struct bpf_prog_info info = {};
> > +       char name[256] = {};
>
> you are unconditionally snprintf()'ing into name, don't unnecessarily
> initialize it
>

Ok.

> > +       int len, ret;
> > +
> > +       ret = bpf_obj_get_info_by_fd(fd, &info, &(__u32){sizeof(info)});
>
> that sizeof part... even if that works reliably, stick to normal use
> pattern, have a local variable for that. It can be overwritten by the
> kernel.
>
> you can re-use len for this, btw
>

Ok, will fix everywhere.

> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       ret = nlattr_add(nh, maxsz, TCA_BPF_FD, &fd, sizeof(fd));
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       len = snprintf(name, sizeof(name), "%s:[%" PRIu32 "]", info.name,
>
> libbpf doesn't use PRI modifiers, use %u
>

Ok.

> > +                      info.id);
> > +       if (len < 0 || len >= sizeof(name))
> > +               return len < 0 ? -EINVAL : -ENAMETOOLONG;
>
> if (len < 0)
>     return -errno;
> if (len >= sizeof(name))
>     return -ENAMETOOLONG;
>

Ok.

> > +
> > +       return nlattr_add(nh, maxsz, TCA_BPF_NAME, name, len + 1);
> > +}
> > +
> > +
> > +static int cls_get_info(struct nlmsghdr *nh, libbpf_dump_nlmsg_t fn,
> > +                       void *cookie);
> > +
> > +int bpf_tc_attach(const struct bpf_tc_hook *hook,
> > +                 struct bpf_tc_opts *opts, int flags)
> > +{
> > +       __u32 protocol = 0, bpf_flags;
> > +       struct pass_info info = {};
> > +       long long int tcm_parent;
> > +       struct nlattr *nla;
> > +       int ret;
> > +       struct {
> > +               struct nlmsghdr nh;
> > +               struct tcmsg t;
> > +               char buf[256];
> > +       } req;
> > +
> > +       if (!hook || !opts || !OPTS_VALID(hook, bpf_tc_opts) ||
> > +           !OPTS_VALID(opts, bpf_tc_opts))
> > +               return -EINVAL;
> > +       if (OPTS_GET(hook, ifindex, 0) <= 0 || !OPTS_GET(opts, prog_fd, 0) ||
> > +           OPTS_GET(opts, prog_id, 0))
> > +               return -EINVAL;
> > +       if (OPTS_GET(opts, priority, 0) > UINT16_MAX)
> > +               return -EINVAL;
> > +       if (flags & ~BPF_TC_F_REPLACE)
> > +               return -EINVAL;
> > +
> > +       protocol = ETH_P_ALL;
> > +       flags = flags & BPF_TC_F_REPLACE ? NLM_F_REPLACE : NLM_F_EXCL;
>
> ()
>
> > +
> > +       memset(&req, 0, sizeof(req));
> > +       req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg));
> > +       req.nh.nlmsg_flags =
> > +               NLM_F_REQUEST | NLM_F_ACK | NLM_F_CREATE | NLM_F_ECHO | flags;
> > +       req.nh.nlmsg_type = RTM_NEWTFILTER;
> > +       req.t.tcm_family = AF_UNSPEC;
> > +       req.t.tcm_handle = OPTS_GET(opts, handle, 0);
> > +       req.t.tcm_ifindex = OPTS_GET(hook, ifindex, 0);
>
> you are OPTS_GET()ing same stuff multiple times, it might look cleaner
> to use local variables for that. It will be faster also, but that's
> not important here.
>
> > +       req.t.tcm_info = TC_H_MAKE(OPTS_GET(opts, priority, 0) << 16, htons(protocol));
> > +
> > +       tcm_parent = tc_get_tcm_parent(OPTS_GET(hook, attach_point, 0), OPTS_GET(hook, parent, 0));
>
> and this will be much shorter, positively, please use local variables
> for all those input fields you care about
>

Ok, will fix.

> > +       if (tcm_parent < 0)
> > +               return tcm_parent;
> > +       req.t.tcm_parent = tcm_parent;
> > +
> > +       ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       nla = nlattr_begin_nested(&req.nh, sizeof(req), TCA_OPTIONS);
> > +       if (!nla)
> > +               return -EMSGSIZE;
> > +
> > +       ret = tc_cls_add_fd_and_name(&req.nh, sizeof(req), OPTS_GET(opts, prog_fd, 0));
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       /* direct action mode is always enabled */
> > +       bpf_flags = TCA_BPF_FLAG_ACT_DIRECT;
> > +       ret = nlattr_add(&req.nh, sizeof(req), TCA_BPF_FLAGS,
> > +                        &bpf_flags, sizeof(bpf_flags));
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       nlattr_end_nested(&req.nh, nla);
> > +
> > +       info.opts = opts;
> > +
> > +       ret = libbpf_nl_send_recv(&req.nh, &cls_get_info, NULL, &info);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       /* Failed to process unicast response */
> > +       if (!info.processed)
> > +               ret = -ENOENT;
>
> just return directly, you just did that multiple times above, why this
> one is special?
>

Yes, this can be a direct return. A lot of this is just oversight from the
constant rewriting etc.

> > +
> > +       return ret;
> > +}
> > +
> > +static int tc_cls_detach(const struct bpf_tc_hook *hook,
> > +                        const struct bpf_tc_opts *opts, bool flush)
> > +{
> > +       long long int tcm_parent;
> > +       __u32 protocol = 0;
> > +       int ret, c;
> > +       struct {
> > +               struct nlmsghdr nh;
> > +               struct tcmsg t;
> > +               char buf[256];
> > +       } req;
> > +
> > +       if (!hook || !OPTS_VALID(hook, bpf_tc_opts) ||
> > +           !OPTS_VALID(opts, bpf_tc_opts))
> > +               return -EINVAL;
> > +       if (OPTS_GET(hook, ifindex, 0) <= 0 || OPTS_GET(opts, prog_fd, 0) ||
> > +           OPTS_GET(opts, prog_id, 0))
> > +               return -EINVAL;
> > +       c = !!OPTS_GET(opts, handle, 0) + !!OPTS_GET(opts, priority, 0);
> > +       if ((flush && c != 0) || (!flush && c != 2))
> > +               return -EINVAL;
>
> arithmetics here looks pretty ugly, would it be too bad with logical checks?
>

I'll do it with logical checks, this was just shorter.

> > +       if (OPTS_GET(opts, priority, 0) > UINT16_MAX)
> > +               return -EINVAL;
> > +
> > +       if (!flush)
> > +               protocol = ETH_P_ALL;
> > +
> > +       memset(&req, 0, sizeof(req));
> > +       req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct tcmsg));
> > +       req.nh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
> > +       req.nh.nlmsg_type = RTM_DELTFILTER;
> > +       req.t.tcm_family = AF_UNSPEC;
> > +       if (!flush)
> > +               req.t.tcm_handle = OPTS_GET(opts, handle, 0);
> > +       req.t.tcm_ifindex = OPTS_GET(hook, ifindex, 0);
> > +       if (!flush)
> > +               req.t.tcm_info = TC_H_MAKE(OPTS_GET(opts, priority, 0) << 16,
>
> OPTS_GET()s just make everything uglier and unnecessarily verbose
>
> > +                                          htons(protocol));
> > +
> > +       tcm_parent = tc_get_tcm_parent(OPTS_GET(hook, attach_point, 0), OPTS_GET(hook, parent, 0));
> > +       if (tcm_parent < 0)
> > +               return tcm_parent;
> > +       req.t.tcm_parent = tcm_parent;
> > +
> > +       if (!flush) {
> > +               ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
> > +               if (ret < 0)
> > +                       return ret;
> > +       }
> > +
> > +       return libbpf_nl_send_recv(&req.nh, NULL, NULL, NULL);
> > +}
> > +
>
> [...]
>
> > +       tcm_parent = tc_get_tcm_parent(OPTS_GET(hook, attach_point, 0), OPTS_GET(hook, parent, 0));
> > +       if (tcm_parent < 0)
> > +               return tcm_parent;
> > +       req.t.tcm_parent = tcm_parent;
> > +
> > +       ret = nlattr_add(&req.nh, sizeof(req), TCA_KIND, "bpf", sizeof("bpf"));
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       if (OPTS_GET(opts, prog_fd, 0)) {
> > +               struct bpf_prog_info info = {};
> > +               ret = bpf_obj_get_info_by_fd(OPTS_GET(opts, prog_fd, 0), &info, &(__u32){sizeof(info)});
>
> same as before, use dedicated variable
>
> > +               if (ret < 0)
> > +                       return ret;
> > +
> > +               pinfo.match_prog_id = info.id;
> > +       } else
> > +               pinfo.match_prog_id = OPTS_GET(opts, prog_id, 0);
>
> when one branch of if has {}, the other one has to have it as well, please fix
>

Ok.

> > +
> > +       pinfo.opts = opts;
> > +
> > +       ret = libbpf_nl_send_recv(&req.nh, cls_get_info, NULL, &pinfo);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       if (!pinfo.processed)
> > +               ret = -ENOENT;
>
> direct return
>

Ok.

> > +
> > +       return ret;
> > +}
> > --
> > 2.30.2
> >

--
Kartikeya
