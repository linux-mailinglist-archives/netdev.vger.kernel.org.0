Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A752A8570
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 18:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgKER5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 12:57:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgKER5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 12:57:44 -0500
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A60FA20936;
        Thu,  5 Nov 2020 17:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604599064;
        bh=U0DJ+fGoceNGEJQ8jALWaiQGwxbXijhBlc1CwbmDS0U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vkjsbF4wwfPfyPLkBD097pMiSMmx06nIQQR56owlkYXAoR22BJhzF0G6aSH9C9uAb
         ZnjWQps3ZaeilFVrJrevvftEvHSuITj/YQQpya6/H8+K0oDDo4SlFS3Q5M7o02r2cy
         dtYHCzQjePLcdhiN3icYfl6QCm9HinImNTiMgsMM=
Received: by mail-lf1-f42.google.com with SMTP id l28so3554534lfp.10;
        Thu, 05 Nov 2020 09:57:43 -0800 (PST)
X-Gm-Message-State: AOAM531fl5GKph0Aeb9hNOHB338azOyq6ProkgHiA0C5EI8cXccAo8Ll
        0nFeyxIiPHtRuuUWcYjKNhpklOFamB4cNH6B+p4=
X-Google-Smtp-Source: ABdhPJwjk5DLpTdQOjI0YutL4jwBKuBWCpRo0UR7+oxL8TdnZtrsndy2HKXNfC176dQG94laITaxaHbci3r4wFjBLlo=
X-Received: by 2002:a05:6512:3156:: with SMTP id s22mr1364509lfi.273.1604599061868;
 Thu, 05 Nov 2020 09:57:41 -0800 (PST)
MIME-Version: 1.0
References: <20201105115230.296657-1-lmb@cloudflare.com>
In-Reply-To: <20201105115230.296657-1-lmb@cloudflare.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 5 Nov 2020 09:57:30 -0800
X-Gmail-Original-Message-ID: <CAPhsuW45MMnHHSpAKXB9iOrHxujiO_DroBmqEsRYXq6sKVso8g@mail.gmail.com>
Message-ID: <CAPhsuW45MMnHHSpAKXB9iOrHxujiO_DroBmqEsRYXq6sKVso8g@mail.gmail.com>
Subject: Re: [PATCH bpf] tools/bpftool: fix attaching flow dissector
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team@cloudflare.com, Jiri Benc <jbenc@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 3:54 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> My earlier patch to reject non-zero arguments to flow dissector attach
> broke attaching via bpftool. Instead of 0 it uses -1 for target_fd.
> Fix this by passing a zero argument when attaching the flow dissector.
>
> Fixes: 1b514239e859 ("bpf: flow_dissector: Check value of unused flags to BPF_PROG_ATTACH")
> Reported-by: Jiri Benc <jbenc@redhat.com>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/bpf/bpftool/prog.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index d942c1e3372c..acdb2c245f0a 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -940,7 +940,7 @@ static int parse_attach_detach_args(int argc, char **argv, int *progfd,
>         }
>
>         if (*attach_type == BPF_FLOW_DISSECTOR) {
> -               *mapfd = -1;
> +               *mapfd = 0;
>                 return 0;
>         }
>
> --
> 2.25.1
>
