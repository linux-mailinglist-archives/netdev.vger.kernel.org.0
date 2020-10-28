Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6703B29D629
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730803AbgJ1WMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730790AbgJ1WMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:12:12 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C85BC0613CF;
        Wed, 28 Oct 2020 15:12:11 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id n15so578222otl.8;
        Wed, 28 Oct 2020 15:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ziWzHtHDKEUCQdSi3YfjA8tMbkauNIh8Kw71IC6e0PI=;
        b=WH5XdK6Wqo1HCo4aaY86BUZaEL7tM3sr2gD6MykRYYHobBzsJlsUGM/EmJFizQ2Bql
         vqO0DRg2E28K+0rjgZsNSvk0rYw39XyVbQ2Cw6nLTCYr15qMqlZ2zmO1Kl/5/UkeD/Pq
         xrT/1hfltkeXQK24NIxIORFDP3O5b0GP4cH8olAZMFcRIpVzrUfKDcKhNgX8wwucX8IL
         BVJSoZqw+Ijdm8BN98Hr5xvT+eZavCuQUsVwCN+iftSVPHIPsxVXWUehGtSBHO3JIp8G
         9DlJQvwxVqovibhsfFGsdJpXgV/pxu9vb4a/AOyS8kL62M0W/L8wdbiPPCQ55Jv2wQGY
         CwTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ziWzHtHDKEUCQdSi3YfjA8tMbkauNIh8Kw71IC6e0PI=;
        b=tktL8x96Omq+thF85itGXVUm7yFPad9XT56EYtKEbWE+MCg0oMkOgFtJZdSvTMDRTW
         13ojagYpZdXi6DfMDjPIUhxYiGBXWsR8pZ4vYtaOC3mjewggBjCOHoAdY33tkNMXTREI
         GcuXqphh3ArdIaJqme3dGvwWwgyhXlxESZeFzMFnNCobavcaxKPPwr7W8MaRfpzjoQDi
         4yC49PYy9kBbvrhKwgP57HpNJp3FDwwgthoDB4SU1DgKDufrki/GMT71Zklhpy7LRRtl
         KWk+SzbGteTkwdq/vQ427ahyVjOvKl4axhxfawPDiRYQWseC5AzJ0vFDCC6D91L0DJTy
         UVcw==
X-Gm-Message-State: AOAM532Uv8zxDX/NaGRflGK5ho6kr16/sLMPCJO1AUrldYkjAdWg+Zhz
        g5EuyBxf1OmEnIrxAMiVr5r8p/Bqw/esiQLUg/bCQ1eOAgISNg==
X-Google-Smtp-Source: ABdhPJw1U7gofXrY1jn3ur63ecWI7ajwv2Ydl4fSaB6M/40eNqnmI16qo0SSlVhpKFIIe9jugUdtincmL9nj5mT2JRA=
X-Received: by 2002:a25:bdc7:: with SMTP id g7mr8137389ybk.260.1603856432876;
 Tue, 27 Oct 2020 20:40:32 -0700 (PDT)
MIME-Version: 1.0
References: <20201027233646.3434896-1-irogers@google.com>
In-Reply-To: <20201027233646.3434896-1-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Oct 2020 20:40:21 -0700
Message-ID: <CAEf4BzZm+-pHwnkaaP4+kPJPmsG=0vTKFU4M+At890JsivfZeA@mail.gmail.com>
Subject: Re: [PATCH 1/2] tools, bpftool: Avoid array index warnings.
To:     Ian Rogers <irogers@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Michal Rostecki <mrostecki@opensuse.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 4:37 PM Ian Rogers <irogers@google.com> wrote:
>
> The bpf_caps array is shorter without CAP_BPF, avoid out of bounds reads
> if this isn't defined. Working around this avoids -Wno-array-bounds with
> clang.
>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/bpf/bpftool/feature.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index a43a6f10b564..359960a8f1de 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -843,9 +843,14 @@ static int handle_perms(void)
>                 else
>                         p_err("missing %s%s%s%s%s%s%s%srequired for full feature probing; run as root or use 'unprivileged'",
>                               capability_msg(bpf_caps, 0),
> +#ifdef CAP_BPF
>                               capability_msg(bpf_caps, 1),
>                               capability_msg(bpf_caps, 2),
> -                             capability_msg(bpf_caps, 3));
> +                             capability_msg(bpf_caps, 3)
> +#else
> +                               "", "", "", "", "", ""
> +#endif /* CAP_BPF */
> +                               );
>                 goto exit_free;
>         }
>
> --
> 2.29.0.rc2.309.g374f81d7ae-goog
>
