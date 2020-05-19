Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F77C1D8C04
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgESAH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgESAH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:07:28 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9EFC061A0C;
        Mon, 18 May 2020 17:07:28 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id m11so12605404qka.4;
        Mon, 18 May 2020 17:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zBdWx/5s9zdrUPeiAbUAeKt/f+eRSJu07pci8kjPTvw=;
        b=t+hkI3yxkycg59GnLosFRdm0kIxicPPbN8sNpJkJCEzYYl8kdSHFCl+9eUKasOW/9P
         FZ360jlDbuvSvY8Dxld6fHEDlwtEtlc5hutgCwQQChqkV73F9IAjfnchXnWiF/ZecZ9C
         V3rInQ874c+GNfcGxrXYEDlEUJpg+QWC8fs/A7C42G+RGkpF/4eQO0eQN8bSDc7vkyZA
         kN9iLpHRpcED7eUWXqMXAz0EkixpwNbYU0YUpTPc9+ejodLx47gDfIZe0KCw0eI1vEqY
         wDybsScYYXdlGRj3T0Vbj/Jr99d5pUSGZmeSuVSsCIzylJYT20mbqS3vW9xfFFCBXRN6
         hGUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zBdWx/5s9zdrUPeiAbUAeKt/f+eRSJu07pci8kjPTvw=;
        b=LhzEp8f3epSRGL6VPA9ihwWR69F7+fu6dsS0OOsZYXXXopxReDMdmJdnwMQsXz4tSh
         FKej6yGPVsaUaAY+zOW6sk2IyrOvNS5WcpOFbVmx1xDJsYzm0d3czAo8AHstGrF6hjn/
         GdB8x4qclSxYZrOzn2iNLgBg8qy5dOFytTyuZflfotY68oHcnNqgO61NAKJXTgouCKbH
         +0eLFJTx55U1lH6YO6a48HcKLRD7c9UWLrQs/HPWt9CUMdqANrE6ku7Yo/M3v+At4OvJ
         4L5zzTwudhzq8l9lv0ItEmwlEZ5raqat8Psna8iDagSxdFR5+tugBrqr0mAGsjEdWzRU
         xqkw==
X-Gm-Message-State: AOAM531AdTdPjs0X77cgWZ+rzHQRTHZ1EIC25x8SaXy4jf7DdP6sZ3cI
        kc9ZQYaq4DZzoOnn+hWVY0FzM6dWBzfcequeeJg=
X-Google-Smtp-Source: ABdhPJwMj65uuUiHqMl+G64d5iwusQwsN1Fb/X1EHsHHMxnnypluVDz/KzsL6aSE9JFSKY0EJmoraa0M1ViJtlDecnI=
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr19937747qka.449.1589846847938;
 Mon, 18 May 2020 17:07:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200516005149.3841-1-quentin@isovalent.com>
In-Reply-To: <20200516005149.3841-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 May 2020 17:07:17 -0700
Message-ID: <CAEf4BzZDC9az2vFPTNW03gSUZiYdc9-XeyP+1h8WkAKHagkUTg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools: bpftool: make capability check account
 for new BPF caps
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 5:52 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Following the introduction of CAP_BPF, and the switch from CAP_SYS_ADMIN
> to other capabilities for various BPF features, update the capability
> checks (and potentially, drops) in bpftool for feature probes. Because
> bpftool and/or the system might not know of CAP_BPF yet, some caution is
> necessary:
>
> - If compiled and run on a system with CAP_BPF, check CAP_BPF,
>   CAP_SYS_ADMIN, CAP_PERFMON, CAP_NET_ADMIN.
>
> - Guard against CAP_BPF being undefined, to allow compiling bpftool from
>   latest sources on older systems. If the system where feature probes
>   are run does not know of CAP_BPF, stop checking after CAP_SYS_ADMIN,
>   as this should be the only capability required for all the BPF
>   probing.
>
> - If compiled from latest sources on a system without CAP_BPF, but later
>   executed on a newer system with CAP_BPF knowledge, then we only test
>   CAP_SYS_ADMIN. Some probes may fail if the bpftool process has
>   CAP_SYS_ADMIN but misses the other capabilities. The alternative would
>   be to redefine the value for CAP_BPF in bpftool, but this does not
>   look clean, and the case sounds relatively rare anyway.
>
> Note that libcap offers a cap_to_name() function to retrieve the name of
> a given capability (e.g. "cap_sys_admin"). We do not use it because
> deriving the names from the macros looks simpler than using
> cap_to_name() (doing a strdup() on the string) + cap_free() + handling
> the case of failed allocations, when we just want to use the name of the
> capability in an error message.
>
> The checks when compiling without libcap (i.e. root versus non-root) are
> unchanged.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/feature.c | 85 +++++++++++++++++++++++++++++--------
>  1 file changed, 67 insertions(+), 18 deletions(-)
>
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index 1b73e63274b5..3c3d779986c7 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -758,12 +758,32 @@ static void section_misc(const char *define_prefix, __u32 ifindex)
>         print_end_section();
>  }
>
> +#ifdef USE_LIBCAP
> +#define capability(c) { c, #c }
> +#endif
> +
>  static int handle_perms(void)
>  {
>  #ifdef USE_LIBCAP
> -       cap_value_t cap_list[1] = { CAP_SYS_ADMIN };
> -       bool has_sys_admin_cap = false;
> +       struct {
> +               cap_value_t cap;
> +               char name[14];  /* strlen("CAP_SYS_ADMIN") */
> +       } required_caps[] = {
> +               capability(CAP_SYS_ADMIN),
> +#ifdef CAP_BPF
> +               /* Leave CAP_BPF in second position here: We will stop checking
> +                * if the system does not know about it, since it probably just
> +                * needs CAP_SYS_ADMIN to run all the probes in that case.
> +                */
> +               capability(CAP_BPF),
> +               capability(CAP_NET_ADMIN),
> +               capability(CAP_PERFMON),
> +#endif
> +       };
> +       bool has_admin_caps = true;
> +       cap_value_t *cap_list;
>         cap_flag_value_t val;
> +       unsigned int i;
>         int res = -1;
>         cap_t caps;
>
> @@ -774,41 +794,70 @@ static int handle_perms(void)
>                 return -1;
>         }
>
> -       if (cap_get_flag(caps, CAP_SYS_ADMIN, CAP_EFFECTIVE, &val)) {
> -               p_err("bug: failed to retrieve CAP_SYS_ADMIN status");
> +       cap_list = malloc(sizeof(cap_value_t) * ARRAY_SIZE(required_caps));

I fail to see why you need to dynamically allocate cap_list?
cap_value_t cap_list[ARRAY_SIZE(required_caps)] wouldn't work?

> +       if (!cap_list) {
> +               p_err("failed to allocate cap_list: %s", strerror(errno));
>                 goto exit_free;
>         }
> -       if (val == CAP_SET)
> -               has_sys_admin_cap = true;
>
> -       if (!run_as_unprivileged && !has_sys_admin_cap) {
> -               p_err("full feature probing requires CAP_SYS_ADMIN, run as root or use 'unprivileged'");
> -               goto exit_free;
> +       for (i = 0; i < ARRAY_SIZE(required_caps); i++) {
> +               const char *cap_name = required_caps[i].name;
> +               cap_value_t cap = required_caps[i].cap;
> +
> +#ifdef CAP_BPF
> +               if (cap == CAP_BPF && !CAP_IS_SUPPORTED(cap))
> +                       /* System does not know about CAP_BPF, meaning
> +                        * that CAP_SYS_ADMIN is the only capability
> +                        * required. We already checked it, break.
> +                        */
> +                       break;
> +#endif

Seems more reliable to check all 4 capabilities independently (so
don't stop if !CAP_IS_SUPPORTED(cap)), and drop those that you have
set. Or there are some downsides to that?

> +
> +               if (cap_get_flag(caps, cap, CAP_EFFECTIVE, &val)) {
> +                       p_err("bug: failed to retrieve %s status: %s", cap_name,
> +                             strerror(errno));
> +                       goto exit_free;
> +               }
> +
> +               if (val != CAP_SET) {
> +                       if (!run_as_unprivileged) {
> +                               p_err("missing %s, required for full feature probing; run as root or use 'unprivileged'",
> +                                     cap_name);
> +                               goto exit_free;
> +                       }
> +                       has_admin_caps = false;
> +                       break;
> +               }
> +               cap_list[i] = cap;
>         }
>

[...]
