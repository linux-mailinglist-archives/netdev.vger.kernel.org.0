Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820CF541578
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 22:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376479AbiFGUgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 16:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378177AbiFGUez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 16:34:55 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26951E8E80;
        Tue,  7 Jun 2022 11:37:39 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id l18so12877538lje.13;
        Tue, 07 Jun 2022 11:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JTi7/XTnBQX8I/wG1AnPNmtC155NtFS0zGTYsNk4hcc=;
        b=F306nsY9xSXX9mSunnEA/iT6FXODtrPZqF37aSzILBLiiOWZcUl3Qc/zrTRsMjOYzb
         Jqgc97BqGdhC8whLax2LDlZEwcrH6ZS1gnQTrWhtz2DuukA8G77WsEmev+P4UXU9VCiO
         TifcJIUP0ILUoOq8Qek1LdzuYI8ZA4cczk3vHuCcOW0v1Mljzm7mKgi9RTOVp0OGe/tQ
         XeFQQmkoIGJoJTMU/LYNuuQZkB+IKyfdC8urgdkgK94HQKutvzv4jJrAQT0ylcv/jVE7
         aZU2yfZzX9wxDj1cdKUkx8gMjhTJgWW/hNdUoLmR4RHdWIMIuimrUkqzwzhBGnn9SU7m
         Bw7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JTi7/XTnBQX8I/wG1AnPNmtC155NtFS0zGTYsNk4hcc=;
        b=42OSPNqrpO3ZNRO7vummiR3zTqB2wNtosGmjyskfGmhDJiBR3dKwe4yim2nuc+rcpw
         SXYwaTHdEN5OugHy2i0ZEBf7hPl7GvCminzavIGBJsHCEfxhzPCJbCb4oPZHp9gLW8Jd
         xptRHsQC8XsjfcNdM+H21mSmYERkRzov4hZPaoyHgoBUdcQQ608fpMnVR5UdV0MjeLwq
         4nFjIayYqlV0ZWyYCf73Zqpv8aHGqaWrlRfhBhy/MeEhqtfpPRwQ4gwBPUzVtzyH96U3
         oAVVTUENSo7pqfh2S4dq1QKGHFxSSha4ZCuqT41SGwsycZYCzpJztYR+DNpHjHh/g+aq
         820Q==
X-Gm-Message-State: AOAM533PzpuhKdXJZQx7O5OUO8+3XaFlgMYr2pEKDsUA1Hcrt7ysoz0R
        pFwc90t1iOaCYvCbgxk+CXzt/3TYakkwgnD7uwKKO5s2Mf4=
X-Google-Smtp-Source: ABdhPJxDqelTMp5czJXXSbx27tQqbWRaxPOt9U92qq8MrifM+FMfpVZFLHKQJQmbCEZeEDQgYYJZRJiAFevJAelA5uo=
X-Received: by 2002:a2e:3a16:0:b0:255:7811:2827 with SMTP id
 h22-20020a2e3a16000000b0025578112827mr14601755lja.130.1654627057128; Tue, 07
 Jun 2022 11:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220606185401.3902-1-mangosteen728@163.com>
In-Reply-To: <20220606185401.3902-1-mangosteen728@163.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Jun 2022 11:37:24 -0700
Message-ID: <CAEf4BzYKy0q7YrR4LY8hUJ2djHCmz-7AaxXrrUTqd-tKJPkvkA@mail.gmail.com>
Subject: Re: [PATCH] bpf:add function bpf_get_task_exe_path
To:     mangosteen728 <mangosteen728@163.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 11:54 AM mangosteen728 <mangosteen728@163.com> wrote=
:
>
> Add the absolute path to get the executable corresponding tothe task
>
> Signed-off-by: mangosteen728 <mangosteen728@163.com>
> ---
> Hi
> This is my first attempt to submit patch, there are shortcomings please m=
ore but wait.
>
> In security audit often need to get the absolute path to the executable o=
f the process so I tried to add bpf_get_task_exe_path in the helpers functi=
on to get.
>
> The code currently only submits the implementation of the function and ho=
w is this patch merge possible if I then add the relevant places=E3=80=82
>

See bpf_d_path() BPF helper, you should be able to do what you want
without adding new BPF helper.

> thanks
> mangosteen728
> kernel/bpf/helpers.c | 37 +++++++++++++++++++++++++++++++++++++
> 1 file changed, 37 insertions(+)
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 225806a..797f850 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -257,6 +257,43 @@
>         .arg2_type      =3D ARG_CONST_SIZE,
>  };
>
> +BPF_CALL_3(bpf_get_task_exe_path, struct task_struct *, task, char *, bu=
f, u32, sz)
> +{
> +       struct file *exe_file =3D NULL;
> +       char *p =3D NULL;
> +       long len =3D 0;
> +
> +       if (!sz)
> +               return 0;
> +       exe_file =3D get_task_exe_file(tsk);
> +       if (IS_ERR_OR_NULL(exe_file))
> +               return 0;
> +       p =3D d_path(&exe_file->f_path, buf, sz);
> +       if (IS_ERR_OR_NULL(path)) {
> +               len =3D PTR_ERR(p);
> +       } else {
> +               len =3D buf + sz - p;
> +               memmove(buf, p, len);
> +       }
> +       fput(exe_file);
> +       return len;
> +}
> +
> +static const struct bpf_func_proto bpf_get_task_exe_path_proto =3D {
> +       .func       =3D bpf_get_task_exe_path,
> +       .gpl_only   =3D false,
> +       .ret_type   =3D RET_INTEGER,
> +       .arg1_type  =3D ARG_PTR_TO_BTF_ID,
> +       .arg2_type  =3D ARG_PTR_TO_MEM,
> +       .arg3_type  =3D ARG_CONST_SIZE_OR_ZERO,
> +};
> +
> --
>
