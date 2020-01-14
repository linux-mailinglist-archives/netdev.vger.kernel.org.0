Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C88BB13B238
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 19:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgANSgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 13:36:52 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44201 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgANSgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 13:36:52 -0500
Received: by mail-qt1-f194.google.com with SMTP id t3so13335342qtr.11;
        Tue, 14 Jan 2020 10:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h0zBvJjpzgwK67F0RVeLSWa1LpfeS/py8/GHMZRGeeQ=;
        b=LEUPaR4f1Z3WcSuOoq1PxBaZG1mAx+z3vRXwJlTT8EJCU24AOglgH5v/VdMHlbTvlg
         rORVQe1GNuxAZOCTWc6Fw6ks+RvUBb4pll4BVvmuLcu7DbMWYZ8R9fIFMKRevwx6WIrP
         ArX5im+jSYJ3Nrf+aZpVIOvXOYfxROh0YD1itotDirLNRcggdIvZEeP55NvCMMfkP61Y
         dPKI3MCZrLCJudy9go8quE4JAVGWXsFKOKLJD3wW7RZwCpOCEf5g7M4OwByiTekbYoc+
         oT8gO8sUSmPHBMlE3yl4DPRjdd/N2kt4PXcOo8/leUm7Kgfo9/nZH+NyuwRSFA2hK8i3
         5nvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h0zBvJjpzgwK67F0RVeLSWa1LpfeS/py8/GHMZRGeeQ=;
        b=qk5UTpQwkee4HRXTY6NmtGFV1jCYrbIwhv75XhYJqCCwP5IXdTBjPrX5Zx4G1sR1UH
         Kc7RRWNpt2BW/qFRt9jSqxPGSehj6xzQPBMpDLohe86LNm1SDSraUSt0vRc82zQAYAXq
         wTu6lLflp8nLFO9Vtk45V+jbULelradr78pxGojnAeOW2GWtKJO6zzvq7qJdSwi6evXh
         cfUKkz5HWlp+zyIXasuS1uDil34QjoLrg15QLV19TAMcB2WNCt0vuXDTK21P1PYAJDgE
         K7V6MnS0h+U91WnB86vGtKmVVa3QwIjLprkNYPMV1kF+MXeeSI29vizhD15iS7n7Q0VF
         FzNw==
X-Gm-Message-State: APjAAAVy5MfNfMpLxZngTn5Uc28fMrwJif5ZXpngmPZ9uwK4VJPreLJw
        zEfhuvSuJUca0rUnGO2rTmJtqAlDdfG5YBSDcTg=
X-Google-Smtp-Source: APXvYqzKxGlm4fHti+iVpkSm7aZilbYKxb0vpta9AbCkO/OJVoWVOO3/fzlIz03xAgU2/Z3piNxaqH+qdovH+LludLA=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr4865708qtl.171.1579027011156;
 Tue, 14 Jan 2020 10:36:51 -0800 (PST)
MIME-Version: 1.0
References: <20200114164614.47029-1-brianvv@google.com> <20200114164614.47029-9-brianvv@google.com>
In-Reply-To: <20200114164614.47029-9-brianvv@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jan 2020 10:36:40 -0800
Message-ID: <CAEf4BzYEGv-q7p0rK-d94Ng0fyQLuTEvsy1ZSzTdk0xZcyibQA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 7/9] libbpf: add libbpf support to batch ops
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 8:46 AM Brian Vazquez <brianvv@google.com> wrote:
>
> From: Yonghong Song <yhs@fb.com>
>
> Added four libbpf API functions to support map batch operations:
>   . int bpf_map_delete_batch( ... )
>   . int bpf_map_lookup_batch( ... )
>   . int bpf_map_lookup_and_delete_batch( ... )
>   . int bpf_map_update_batch( ... )
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  tools/lib/bpf/bpf.c      | 60 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/bpf.h      | 22 +++++++++++++++
>  tools/lib/bpf/libbpf.map |  4 +++
>  3 files changed, 86 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 500afe478e94a..12ce8d275f7dc 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -452,6 +452,66 @@ int bpf_map_freeze(int fd)
>         return sys_bpf(BPF_MAP_FREEZE, &attr, sizeof(attr));
>  }
>
> +static int bpf_map_batch_common(int cmd, int fd, void  *in_batch,
> +                               void *out_batch, void *keys, void *values,
> +                               __u32 *count,
> +                               const struct bpf_map_batch_opts *opts)
> +{
> +       union bpf_attr attr = {};
> +       int ret;
> +
> +       if (!OPTS_VALID(opts, bpf_map_batch_opts))
> +               return -EINVAL;
> +
> +       memset(&attr, 0, sizeof(attr));
> +       attr.batch.map_fd = fd;
> +       attr.batch.in_batch = ptr_to_u64(in_batch);
> +       attr.batch.out_batch = ptr_to_u64(out_batch);
> +       attr.batch.keys = ptr_to_u64(keys);
> +       attr.batch.values = ptr_to_u64(values);
> +       if (count)
> +               attr.batch.count = *count;
> +       attr.batch.elem_flags  = OPTS_GET(opts, elem_flags, 0);
> +       attr.batch.flags = OPTS_GET(opts, flags, 0);
> +
> +       ret = sys_bpf(cmd, &attr, sizeof(attr));
> +       if (count)
> +               *count = attr.batch.count;

what if syscall failed, do you still want to assign *count then?

> +
> +       return ret;
> +}
> +

[...]
