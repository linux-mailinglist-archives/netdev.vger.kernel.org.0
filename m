Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE3D36868E
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238690AbhDVS3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238463AbhDVS3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 14:29:24 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F010C06174A;
        Thu, 22 Apr 2021 11:28:48 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id p202so8979724ybg.8;
        Thu, 22 Apr 2021 11:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kccFp5PkD2OzEdY3szoFVg5JbDJwnPZzgBEkYQnfrB0=;
        b=qXj5xLHlA+PIZD3iIGirCpXXZIvXbVtVMWheYsd+G8D9o89UERWqfqtyEsRRISxqdc
         2HZ9jZUwwF0RsCNtGQxOAJxV9mjI86yftTWNF9KfefdNbc4hsbucDKjAZxOct4boNHCW
         KBxdYbHYOd1iUy9iE7Gf3+uSjNLpZzEQ4YCxMtjAuYSdbK2Dg9xsTjZf7iqI7v+N1Hoi
         HG4LNU6TtpS4bYVXG7CLty1cF3AuWdMa/ljUXrrsUTvYWLQw8syH9o5Ii3ZPHK7z5FdZ
         yUI0XHlF17QPsFJG977zyu4m3V5mzdbyb5maq+InHwWY0MDQg0/+JcYxnB6Kcr4LU0pe
         07kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kccFp5PkD2OzEdY3szoFVg5JbDJwnPZzgBEkYQnfrB0=;
        b=YSYDIYdj0VEIDjVhFwkyUpq2gD9EAepKUY4ul6Mle9zRVW0YnTMYcy+sgBR+wMYy7O
         Z8+ce9CNNmfo+oZ4azWwDKA6o4ojSnnKscJEWx3gyB/7Y4l91dVOY0oW+RZHR1tJGs2l
         NHuTdzsY351hR0TxMdn5oHIU0B0Kvb4Z/g8gGEtkIp+syL6tbU72gylbdjffGbfo5Xba
         +9JuKQ8IQrGb6q3kcIvLvWT6z4NSk7n6Gt5234znjfqzZeRrv4muFO4epIyv4HcpSJwM
         JKntKN8Mzuqf/OS8U23Uz7IK6Y+pixJGfhcOXE3Bv9SrCEOTE697torIhfatBrvAsb1w
         aPIQ==
X-Gm-Message-State: AOAM5300xL53qzqz5splEBQIM2VQaa2jWs/OboqH1LECw85XxPielOn5
        wNtIIUg8Mf918rhKBUr3tLGtFBE8fyVw2ZFr9Go=
X-Google-Smtp-Source: ABdhPJz12k0vgb/zprEdY0F4pPYSCC55kx1TKYoUV9kTG7E5cLCUbaE9B9FsmmM3VIPwttxF7VgnzuPXumDdogUKDx0=
X-Received: by 2002:a25:d70f:: with SMTP id o15mr6398881ybg.403.1619116127605;
 Thu, 22 Apr 2021 11:28:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210420193740.124285-1-memxor@gmail.com> <20210420193740.124285-3-memxor@gmail.com>
 <9b0aab2c-9b92-0bcb-2064-f66dd39e7552@iogearbox.net> <CAEf4Bzai3maV8E9eWi1fc8fgaeC7qFg7_-N_WdLH4ukv302bhg@mail.gmail.com>
 <b7ace8c2-0147-fde7-d319-479be1e2a05e@iogearbox.net>
In-Reply-To: <b7ace8c2-0147-fde7-d319-479be1e2a05e@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Apr 2021 11:28:36 -0700
Message-ID: <CAEf4BzZKjhsrF3ii4U-pMk3pJt7G3U7Hzkf_7zMOFhGMv7WKWg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 8:35 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 4/22/21 5:43 AM, Andrii Nakryiko wrote:
> > On Wed, Apr 21, 2021 at 3:59 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> On 4/20/21 9:37 PM, Kumar Kartikeya Dwivedi wrote:
> >> [...]
> >>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> >>> index bec4e6a6e31d..b4ed6a41ea70 100644
> >>> --- a/tools/lib/bpf/libbpf.h
> >>> +++ b/tools/lib/bpf/libbpf.h
> >>> @@ -16,6 +16,8 @@
> >>>    #include <stdbool.h>
> >>>    #include <sys/types.h>  // for size_t
> >>>    #include <linux/bpf.h>
> >>> +#include <linux/pkt_sched.h>
> >>> +#include <linux/tc_act/tc_bpf.h>
> >>>
> >>>    #include "libbpf_common.h"
> >>>
> >>> @@ -775,6 +777,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
> >>>    LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
> >>>    LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
> >>>
> >>> +/* Convenience macros for the clsact attach hooks */
> >>> +#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
> >>> +#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
> >>
> >> I would abstract those away into an enum, plus avoid having to pull in
> >> linux/pkt_sched.h and linux/tc_act/tc_bpf.h from main libbpf.h header.
> >>
> >> Just add a enum { BPF_TC_DIR_INGRESS, BPF_TC_DIR_EGRESS, } and then the
> >> concrete tc bits (TC_H_MAKE()) can be translated internally.
> >>
> >>> +struct bpf_tc_opts {
> >>> +     size_t sz;
> >>
> >> Is this set anywhere?
> >>
> >>> +     __u32 handle;
> >>> +     __u32 class_id;
> >>
> >> I'd remove class_id from here as well given in direct-action a BPF prog can
> >> set it if needed.
> >>
> >>> +     __u16 priority;
> >>> +     bool replace;
> >>> +     size_t :0;
> >>
> >> What's the rationale for this padding?
> >>
> >>> +};
> >>> +
> >>> +#define bpf_tc_opts__last_field replace
> >>> +
> >>> +/* Acts as a handle for an attached filter */
> >>> +struct bpf_tc_attach_id {
> >>
> >> nit: maybe bpf_tc_ctx
> >
> > ok, so wait. It seems like apart from INGRESS|EGRESS enum and ifindex,
> > everything else is optional and/or has some sane defaults, right? So
> > this bpf_tc_attach_id or bpf_tc_ctx seems a bit artificial construct
> > and it will cause problems for extending this.
> >
> > So if my understanding is correct, I'd get rid of it completely. As I
> > said previously, opts allow returning parameters back, so if user
> > didn't specify handle and priority and kernel picks values on user's
> > behalf, we can return them in the same opts fields.
> >
> > For detach, again, ifindex and INGRESS|EGRESS is sufficient, but if
> > user want to provide more detailed parameters, we should do that
> > through extensible opts. That way we can keep growing this easily,
> > plus simple cases will remain simple.
> >
> > Similarly bpf_tc_info below, there is no need to have struct
> > bpf_tc_attach_id id; field, just have handle and priority right there.
> > And bpf_tc_info should use OPTS framework for extensibility (though
> > opts name doesn't fit it very well, but it is still nice for
> > extensibility and for doing optional input/output params).
> >
> > Does this make sense? Am I missing something crucial here?
>
> I would probably keep the handle + priority in there; maybe if both are 0,
> we could fix it to some default value internally, but without those it might
> be a bit hard if people want to build a 'pipeline' of cls_bpf progs if they
> need/want to.

Oh, I'm not proposing to drop support for specifying handle and prio.
I'm just saying having a fixed UAPI struct bpf_tc_attach_id as an "ID"
is problematic from API stability point of view. So instead of
pretending we know what "ID" will always be like, pass any extra
non-default fields in OPTS struct. And if those are not specified by
user (either opts is NULL or handle/prio is 0), use sane defaults, as
you are proposing.

>
> Potentially, one could fixate the handle itself, and then allow to specify
> different priorities for it such that when a BPF prog returns a TC_ACT_UNSPEC,
> it will exec the next one inside that cls_bpf instance, every other TC_ACT_*
> opcode will terminate the processing. Technically, only priority would really
> be needed (unless you combine multiple different classifiers from tc side on
> the ingress/egress hook which is not great to begin with, tbh).
>
> > The general rule with any new structs added to libbpf APIs is to
> > either be 100% (ok, 99.99%) sure that they will never be changed, or
> > do forward/backward compatible OPTS. Any other thing is pain and calls
> > for symbol versioning, which we are trying really hard to avoid.
> >
> >>> +     __u32 handle;
> >>> +     __u16 priority;
> >>> +};
> >>> +
> >>> +struct bpf_tc_info {
> >>> +     struct bpf_tc_attach_id id;
> >>> +     __u16 protocol;
> >>> +     __u32 chain_index;
> >>> +     __u32 prog_id;
> >>> +     __u8 tag[BPF_TAG_SIZE];
> >>> +     __u32 class_id;
> >>> +     __u32 bpf_flags;
> >>> +     __u32 bpf_flags_gen;
> >>
> >> Given we do not yet have any setters e.g. for offload, etc, the one thing
> >> I'd see useful and crucial initially is prog_id.
> >>
> >> The protocol, chain_index, and I would also include tag should be dropped.
> >> Similarly class_id given my earlier statement, and flags I would extend once
> >> this lib API would support offloading progs.
> >>
> >>> +};
> >>> +
> >>> +/* id is out parameter that will be written to, it must not be NULL */
> >>> +LIBBPF_API int bpf_tc_attach(int fd, __u32 ifindex, __u32 parent_id,
> >>> +                          const struct bpf_tc_opts *opts,
> >>> +                          struct bpf_tc_attach_id *id);
> >>> +LIBBPF_API int bpf_tc_detach(__u32 ifindex, __u32 parent_id,
> >>> +                          const struct bpf_tc_attach_id *id);
> >>> +LIBBPF_API int bpf_tc_get_info(__u32 ifindex, __u32 parent_id,
> >>> +                            const struct bpf_tc_attach_id *id,
> >>> +                            struct bpf_tc_info *info);
> >>
> >> As per above, for parent_id I'd replace with dir enum.
> >>
> >>> +
> >>>    #ifdef __cplusplus
> >>>    } /* extern "C" */
> >>>    #endif
>
