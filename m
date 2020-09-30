Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D1827F2B2
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgI3Tod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3Toc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:44:32 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8348DC061755;
        Wed, 30 Sep 2020 12:44:32 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id x20so2166992ybs.8;
        Wed, 30 Sep 2020 12:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cZhnF2vFP1tGcMNCykFeilnWoMw6zpP+9XGqk01gtQI=;
        b=t+8axvRIfAHrp3d1z4wASj1cSL+8OqtjDH5CGD6fDR1BZDrXzTbRrlanG3130cS8+B
         xyz35JhztPc7vYEYxEqYcwQD7oXVjNaJKqu2X5oaPAPWDJQYAdtsi2RLZ8JnkmbL409W
         S4lZWNhrYH+PPYKuKv/joVMCN28kr45cjIOZcRN0UlF9n6xb00AVl75TYrXG4kf6aapJ
         8vbN6ccHQoTOyNCR7wXuAN8R5eRBfN/E8Cw3xc/D04iClKgKuCFFgzOp0UgyOZWBGwoa
         juHtS74+h3dK2I4c5ClKLgB9Ug2W3po11ymPykfVD6GbePTVMluoCDgKqMaVUC2c7lBm
         IdUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cZhnF2vFP1tGcMNCykFeilnWoMw6zpP+9XGqk01gtQI=;
        b=SINZCNKT/oLbaAmYR8TDD9DQGogXeCdiCT0/G2VZycKu8QEQiB2k56cqKDYlxm4ET0
         BnaczfYzOSsdA069Z2HqEgPpNLt12vGpJ8+AjOkefSs9Y/ALnZgpF/rCQUru9rQrLkke
         QkyOxUAqpirV+7iVCLisXHIzPAOi2+sCF1Z8k9ky+bCLjuXWzIwlTJD1w4XrR9D/zMSK
         wAMCGr9a5O8LuVHj5FOteztPkxO5dkybZgEGuofi0WgtBg6vIwvN4YuGYh+KxGsGmBgg
         OrABrUJfQV2Mg3OhObJRbTuk/EumH6rgceKe01U8SHnORi+/nMnNvR9asHTuxolZviER
         CZ0g==
X-Gm-Message-State: AOAM532CTMwdoNVQW2XPc5bCkeUbJHZQx+7YrBFtHSsKQpIelbuyFnHj
        WwvXrhdkh+1vFmNBuxRr6r+SO0QTcj7XDi1bwfM=
X-Google-Smtp-Source: ABdhPJyghC+QWhdVxiW6pjxLGQi/ToE13kghqGGUVr3VtUFHrmkobMijSAwZtYyv1iZah1+q+LxR0T6bN+qpqQItcXU=
X-Received: by 2002:a25:2596:: with SMTP id l144mr5490405ybl.510.1601495071755;
 Wed, 30 Sep 2020 12:44:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200930164109.2922412-1-yhs@fb.com> <CAEf4BzZKqrKPifnJmX8fabmXCVRK45ERiEy5aHGFJ9dg0c2oAA@mail.gmail.com>
 <db1cec73-a16a-5407-1bc5-cd7afd557771@fb.com>
In-Reply-To: <db1cec73-a16a-5407-1bc5-cd7afd557771@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 30 Sep 2020 12:44:20 -0700
Message-ID: <CAEf4BzbRcix1Jfw4WVXVi1E0zf9usv-94gYMgweogGnm+dWB5g@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix "unresolved symbol" build error with resolve_btfids
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 12:25 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 9/30/20 11:40 AM, Andrii Nakryiko wrote:
> > On Wed, Sep 30, 2020 at 9:41 AM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> Michal reported a build failure likes below:
> >>     BTFIDS  vmlinux
> >>     FAILED unresolved symbol tcp_timewait_sock
> >>     make[1]: *** [/.../linux-5.9-rc7/Makefile:1176: vmlinux] Error 255
> >>
> >> This error can be triggered when config has CONFIG_NET enabled
> >> but CONFIG_INET disabled. In this case, there is no user of
> >> structs inet_timewait_sock and tcp_timewait_sock and hence vmlinux BTF
> >> types are not generated for these two structures.
> >>
> >> To fix the problem, omit the above two types for BTF_SOCK_TYPE_xxx
> >> macro if CONFIG_INET is not defined.
> >>
> >> Fixes: fce557bcef11 ("bpf: Make btf_sock_ids global")
> >> Reported-by: Michal Kubecek <mkubecek@suse.cz>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   include/linux/btf_ids.h | 20 ++++++++++++++++----
> >>   1 file changed, 16 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> >> index 4867d549e3c1..d9a1e18d0921 100644
> >> --- a/include/linux/btf_ids.h
> >> +++ b/include/linux/btf_ids.h
> >> @@ -102,24 +102,36 @@ asm(                                                      \
> >>    * skc_to_*_sock() helpers. All these sockets should have
> >>    * sock_common as the first argument in its memory layout.
> >>    */
> >> -#define BTF_SOCK_TYPE_xxx \
> >> +
> >> +#define __BTF_SOCK_TYPE_xxx \
> >>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET, inet_sock)                    \
> >>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_CONN, inet_connection_sock)    \
> >>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_REQ, inet_request_sock)        \
> >> -       BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)        \
> >>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_REQ, request_sock)                  \
> >>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK, sock)                         \
> >>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK_COMMON, sock_common)           \
> >>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP, tcp_sock)                      \
> >>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_REQ, tcp_request_sock)          \
> >> -       BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)          \
> >>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)                    \
> >>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)                      \
> >>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
> >>
> >> +#define __BTF_SOCK_TW_TYPE_xxx \
> >> +       BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)        \
> >> +       BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)
> >> +
> >> +#ifdef CONFIG_INET
> >> +#define BTF_SOCK_TYPE_xxx                                              \
> >> +       __BTF_SOCK_TYPE_xxx                                             \
> >> +       __BTF_SOCK_TW_TYPE_xxx
> >> +#else
> >> +#define BTF_SOCK_TYPE_xxx      __BTF_SOCK_TYPE_xxx
> >> +#endif
> >> +
> >>   enum {
> >>   #define BTF_SOCK_TYPE(name, str) name,
> >> -BTF_SOCK_TYPE_xxx
> >> +__BTF_SOCK_TYPE_xxx
> >> +__BTF_SOCK_TW_TYPE_xxx
> >
> > Why BTF_SOCK_TYPE_xxx doesn't still work here after the above changes?
>
> The macro, e.g., BTF_SOCK_TYPE_TCP_TW, still needed to be defined as
> it is used to get the location for btf_id.

Ah, right, so you want those here unconditionally, even if CONFIG_INET
is not defined. Missed that. Might be worth leaving a short comment.

Otherwise LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto = {
>          .func                   = bpf_skc_to_tcp_timewait_sock,
>          .gpl_only               = false,
>          .ret_type               = RET_PTR_TO_BTF_ID_OR_NULL,
>          .arg1_type              = ARG_PTR_TO_BTF_ID_SOCK_COMMON,
>          .ret_btf_id             = &btf_sock_ids[BTF_SOCK_TYPE_TCP_TW],
> };
>
> If CONFIG_INET is not defined, bpf_sock_ids[BTF_SOCK_TYPE_TCP_TW]
> will be 0.
>
> >
> >>   #undef BTF_SOCK_TYPE
> >>   MAX_BTF_SOCK_TYPE,
> >>   };
> >> --
> >> 2.24.1
> >>
