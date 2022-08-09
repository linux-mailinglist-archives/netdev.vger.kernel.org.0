Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91D358D8D3
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 14:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242254AbiHIMlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 08:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiHIMlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 08:41:09 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C96D110E;
        Tue,  9 Aug 2022 05:41:08 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x2so286995ilp.10;
        Tue, 09 Aug 2022 05:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=OH2f5g6k9+qbXZFsQ2Ho2erjcjWAHljfg8M1LYTp1+A=;
        b=i2KuZ9g7/tmr06LMSl8brb+5GUD0ec0/F/f7Qb89WqyrjYSoKisi7F8HrPNpnjvPjU
         wSWsDyJaCf3hsY2liT26vQ4VtT6ExN3PvaqjRe0BIFP+oJ3qziKtqzpSFvZQ4//oUA2H
         kPATgvO5FM/hd5IHppHl7AtneqzNSjYbSl3SFG/69u/VOV2apJQ8knFJpbq3HbjB0jfp
         frHXkHcBwYt4hc6l/tHIPBXQb9xlGJLfilF+fB3fMhXLSdhJigyVUgJbL0VOJWfnhPqr
         cbwyoUbvyc2sWBL6oYv8S3Pknx+m8SBYW+HcfNpdUx4F92eGolGJQ1t3hHhChbdWJuEd
         T7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=OH2f5g6k9+qbXZFsQ2Ho2erjcjWAHljfg8M1LYTp1+A=;
        b=hQsNk8jr8ywtBHYN7mDjirgpEUiaFxYdKBpsxszCL+gaJLzMrRHtnnbHqK8w0KBLSc
         4KJ79DsemFwFKlhLk7xPaWYggfi5lDqoPGSoZRscdwnXof8d59R+zFjQ4oO40oQrzoDM
         MtE8yAJmwcM8JpxFDuCdF4PjWRzcrtXgcLk31p7zMm9JjMlyah/aUn07A/+8XvkUAUdY
         Ha9VmgOPmz3jOghU9CLdCDmsQTmxtXGrftORFGnuWoohJ8/7V6FaeF/papPmit/GooNX
         L4zFZFjosx5H2MezfbAWjdmWJKIaHBA/CT7moN/f5Mct9BTYxHCphc6QSxYTcEZy924i
         Ixpw==
X-Gm-Message-State: ACgBeo39UbhV1GL0vvxUpaTpt/kAUeQFg9armsdbmQW6qNlPSCo1GzdC
        Mjd02OykiMUj/UOORJOW6V+IDz2Z0NK2Y79W5z4=
X-Google-Smtp-Source: AA6agR5MDCW3WkYaKVwM860AoLF4ea8orT7Y7FpX4CVO7hpJqDmrZvd5hEkHX6/Oy6S8zRwxTZ5ZBQwxHJCxEFRVVKo=
X-Received: by 2002:a05:6e02:198c:b0:2e0:ac33:d22 with SMTP id
 g12-20020a056e02198c00b002e0ac330d22mr6236746ilf.219.1660048867835; Tue, 09
 Aug 2022 05:41:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220809105317.436682-1-asavkov@redhat.com> <20220809105317.436682-2-asavkov@redhat.com>
In-Reply-To: <20220809105317.436682-2-asavkov@redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Tue, 9 Aug 2022 14:40:30 +0200
Message-ID: <CAP01T75Qern=-hvYONBMom7T3ycs-bpGxR1n5CdrehJBwrOTuQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/3] bpf: add destructive kfunc flag
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>
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

On Tue, 9 Aug 2022 at 12:53, Artem Savkov <asavkov@redhat.com> wrote:
>
> Add KF_DESTRUCTIVE flag for destructive functions. Functions with this
> flag set will require CAP_SYS_BOOT capabilities.
>
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>  Documentation/bpf/kfuncs.rst | 9 +++++++++
>  include/linux/btf.h          | 1 +
>  kernel/bpf/verifier.c        | 5 +++++
>  3 files changed, 15 insertions(+)
>
> diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
> index c0b7dae6dbf5..2e97e08be7de 100644
> --- a/Documentation/bpf/kfuncs.rst
> +++ b/Documentation/bpf/kfuncs.rst
> @@ -146,6 +146,15 @@ that operate (change some property, perform some operation) on an object that
>  was obtained using an acquire kfunc. Such kfuncs need an unchanged pointer to
>  ensure the integrity of the operation being performed on the expected object.
>
> +2.4.5 KF_DESTRUCTIVE flag

This should be 2.4.6.

> +--------------------------
> +
> +The KF_DESTRUCTIVE flag is used to indicate functions calling which is
> +destructive to the system. For example such a call can result in system
> +rebooting or panicking. Due to this additional restrictions apply to these
> +calls. At the moment they only require CAP_SYS_BOOT capability, but more can be
> +added later.
> +
>  2.5 Registering the kfuncs
>  --------------------------
>
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index cdb376d53238..51a0961c84e3 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -49,6 +49,7 @@
>   * for this case.
>   */
>  #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
> +#define KF_DESTRUCTIVE  (1 << 5) /* kfunc performs destructive actions */
>
>  struct btf;
>  struct btf_member;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 843a966cd02b..163cc0a2dc5a 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7598,6 +7598,11 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>                         func_name);
>                 return -EACCES;
>         }
> +       if (*kfunc_flags & KF_DESTRUCTIVE && !capable(CAP_SYS_BOOT)) {
> +               verbose(env, "destructive kfunc calls require CAP_SYS_BOOT capabilities\n");
> +               return -EACCES;
> +       }
> +
>         acq = *kfunc_flags & KF_ACQUIRE;
>
>         /* Check the arguments */
> --
> 2.37.1
>
