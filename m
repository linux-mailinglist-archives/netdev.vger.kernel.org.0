Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575DC27F17B
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 20:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbgI3Skt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 14:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgI3Skt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 14:40:49 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18877C061755;
        Wed, 30 Sep 2020 11:40:49 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id 133so2025475ybg.11;
        Wed, 30 Sep 2020 11:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vpp7RkZUjiG2Qq5bRQ+rscMCD+mCs58k244Ntann7LQ=;
        b=BLRe78pplKgHB2hrTQaGss/8T2WwRho/keQ6ecVBmARmsx0b4Q2AGMVZ2gXrIq/SiT
         hu9omIoJ/aMl/25p6KWIdqQiZrjGaiQH4T+38E5esvPMgXBqwuAAEhy82kFU/NHNKKUH
         R87F4XDFceFKWpKL6WjE25jkJsmkWQNGk18oIJwMr/B2RgrH865a/gEfh4ovivImBGok
         dHDUAkkj4ROhg6AvzGQOsZe12cWzghWp0uvK+WRwWA3L3gNpm34or1tuS2lTVP68GBQ3
         ma44SH9kERFWG1vHeQG9FzIDIuZ5TDcTyOPpwWRwZgyG9zPK/Ch4TQyUkp5s6Kdic8TL
         5IMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vpp7RkZUjiG2Qq5bRQ+rscMCD+mCs58k244Ntann7LQ=;
        b=DZgxDrNwGkLzr8A8uZuA8NSlkQcAdHJMotFBgGQZrCAc2D7nQTEqaUgPpPcNg6laaZ
         GAYMHIWt83QhVfF8byCZet8ZMgoVMj6t4/FeuqSzQgHhwVEPw33JqRl4MDVZEBBXabP0
         5XB/wUiOl/1GHBsi5IRtVNTAIusM0QgaBeV8aoYpNfBPC782UogWbxPBWkzU4Z6KbY5S
         SeYZ6EH1xks2ysFXzgk/F2BYlpuGZuJyxlmOrSsrWlMN+5XwDOq0ZAPMYassHzhZDbQC
         8PAMQIq5nLbSplvx6w7nf4sHdLbQyaUSCYj4jKmO8SnMzd7+jNu8fGlPPgRv/CtRa+AS
         dgww==
X-Gm-Message-State: AOAM5310pQBVZJdEJ6hHhaDHfUuebQjlA8Vxd78udDM1xD4oSU1OJ8i6
        8pY3bFTaPMnNsOJdJ3LRiakA7akrHQCsPjB6VWg=
X-Google-Smtp-Source: ABdhPJzgodkQob12/I6Zyxy82D6Q7lxeLrrxxBsd+L7EgW6FuKXMVi9OfIqBDwt8qPxjMrsLXwkf4rtn3wigzHVSxY8=
X-Received: by 2002:a25:2d41:: with SMTP id s1mr5075873ybe.459.1601491248315;
 Wed, 30 Sep 2020 11:40:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200930164109.2922412-1-yhs@fb.com>
In-Reply-To: <20200930164109.2922412-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 30 Sep 2020 11:40:37 -0700
Message-ID: <CAEf4BzZKqrKPifnJmX8fabmXCVRK45ERiEy5aHGFJ9dg0c2oAA@mail.gmail.com>
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

On Wed, Sep 30, 2020 at 9:41 AM Yonghong Song <yhs@fb.com> wrote:
>
> Michal reported a build failure likes below:
>    BTFIDS  vmlinux
>    FAILED unresolved symbol tcp_timewait_sock
>    make[1]: *** [/.../linux-5.9-rc7/Makefile:1176: vmlinux] Error 255
>
> This error can be triggered when config has CONFIG_NET enabled
> but CONFIG_INET disabled. In this case, there is no user of
> structs inet_timewait_sock and tcp_timewait_sock and hence vmlinux BTF
> types are not generated for these two structures.
>
> To fix the problem, omit the above two types for BTF_SOCK_TYPE_xxx
> macro if CONFIG_INET is not defined.
>
> Fixes: fce557bcef11 ("bpf: Make btf_sock_ids global")
> Reported-by: Michal Kubecek <mkubecek@suse.cz>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/btf_ids.h | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> index 4867d549e3c1..d9a1e18d0921 100644
> --- a/include/linux/btf_ids.h
> +++ b/include/linux/btf_ids.h
> @@ -102,24 +102,36 @@ asm(                                                      \
>   * skc_to_*_sock() helpers. All these sockets should have
>   * sock_common as the first argument in its memory layout.
>   */
> -#define BTF_SOCK_TYPE_xxx \
> +
> +#define __BTF_SOCK_TYPE_xxx \
>         BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET, inet_sock)                    \
>         BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_CONN, inet_connection_sock)    \
>         BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_REQ, inet_request_sock)        \
> -       BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)        \
>         BTF_SOCK_TYPE(BTF_SOCK_TYPE_REQ, request_sock)                  \
>         BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK, sock)                         \
>         BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK_COMMON, sock_common)           \
>         BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP, tcp_sock)                      \
>         BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_REQ, tcp_request_sock)          \
> -       BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)          \
>         BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)                    \
>         BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)                      \
>         BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
>
> +#define __BTF_SOCK_TW_TYPE_xxx \
> +       BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)        \
> +       BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)
> +
> +#ifdef CONFIG_INET
> +#define BTF_SOCK_TYPE_xxx                                              \
> +       __BTF_SOCK_TYPE_xxx                                             \
> +       __BTF_SOCK_TW_TYPE_xxx
> +#else
> +#define BTF_SOCK_TYPE_xxx      __BTF_SOCK_TYPE_xxx
> +#endif
> +
>  enum {
>  #define BTF_SOCK_TYPE(name, str) name,
> -BTF_SOCK_TYPE_xxx
> +__BTF_SOCK_TYPE_xxx
> +__BTF_SOCK_TW_TYPE_xxx

Why BTF_SOCK_TYPE_xxx doesn't still work here after the above changes?

>  #undef BTF_SOCK_TYPE
>  MAX_BTF_SOCK_TYPE,
>  };
> --
> 2.24.1
>
