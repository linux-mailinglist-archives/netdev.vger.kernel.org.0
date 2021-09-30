Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E965341D1F1
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 05:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347974AbhI3DrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 23:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbhI3DrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 23:47:10 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B190C06161C;
        Wed, 29 Sep 2021 20:45:29 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r2so4842613pgl.10;
        Wed, 29 Sep 2021 20:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aJ7e9bVNPMrw4eoJT/lZLQd5+mAAuNQnNhKnui+l9jk=;
        b=YWqJb8lRd8ggutZ+4ifAHHiYFEfd1wD5RFKBJyvt70sPMhUxGJI98kKXrwN0Udn/VO
         bgJfxYu/PopITHt8bcfpzEvR9TE1sYJ7qOHO4ozJojszz/sUO273KoeRrX0LOD/JyBrD
         a56bQzphLNbTwPwf8GGcgI0mm8/rudjlHyhYh+O8q3O1v2GRBQp5IW3qhAdevV+PEL3z
         jUfCtBlURRAgLH0NWJuBUcvjfQrny1XToByUWth/eY2yAXZyINsh4GXnjFXf7EQArMyL
         hL4R4xPcOfzBITJec7i+W/Pmgv7umXeWP7Tv2OCArvitoeoAfIS0U496KilN8Ie8aB+i
         eYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aJ7e9bVNPMrw4eoJT/lZLQd5+mAAuNQnNhKnui+l9jk=;
        b=I8ETqQozFJmfYLzYSQsT2SUX1S/aW3XukPSa8pwGeBpywjEn/mYLElk/T2ab/LcAtC
         UP4qshetIWg1nQpYdWQCBd+LH/vjr7XvFNufS8AcE2XkdephJy4unCTvluH/fb7BBeJR
         EV7hDD/odvuzohbMZzi5OX1cd6WfDCG3hIsdEzHc/MzLMW99rPVnsZIKMygH3+hLbes2
         kfRTliRJQKpDYVQjLRWj/5rpSbrZn4ej3BBninI/ZgR4AX2YYvvXLRS1TSkXvMHANjmA
         Df2xERN1dPr2QrGQDVu4m1OT/hvHUEaYUiVfVBUXirtXuKoqKpxhVnCJpAQoqQ/Thl0O
         EORQ==
X-Gm-Message-State: AOAM532kmPPA9gO9+wAOxK+EuzJcGvoEyvKdqcgdVdHhaOZIQpq87QZg
        iU1WdGS/VIRjU0LwWbwOVTeBpa2Rb/HpxoiE+l4=
X-Google-Smtp-Source: ABdhPJy+ANK75GcIa9QtVbIUn+Ikg41UMv0bCgRC7ooT+v9X0MStCfoChTqfKxY3DS3ODaQSXB/mOXd60qjZ/RRIexQ=
X-Received: by 2002:aa7:86d9:0:b0:44b:8fbe:6bb9 with SMTP id
 h25-20020aa786d9000000b0044b8fbe6bb9mr2069604pfo.46.1632973528279; Wed, 29
 Sep 2021 20:45:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210927145941.1383001-1-memxor@gmail.com> <20210927145941.1383001-11-memxor@gmail.com>
In-Reply-To: <20210927145941.1383001-11-memxor@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Sep 2021 20:45:17 -0700
Message-ID: <CAADnVQKBBswOOsdpNsaxtTprSkcAvL3ggVV8g0A-mUjs4_ucaQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 10/12] libbpf: Fix skel_internal.h to set
 errno on loader retval < 0
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 8:00 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> When the loader indicates an internal error (result of a checked bpf
> system call), it returns the result in attr.test.retval. However, tests
> that rely on ASSERT_OK_PTR on NULL (returned from light skeleton) may
> miss that NULL denotes an error if errno is set to 0. This would result
> in skel pointer being NULL, while ASSERT_OK_PTR returning 1, leading to
> a SEGV on dereference of skel, because libbpf_get_error relies on the
> assumption that errno is always set in case of error for ptr == NULL.
>
> In particular, this was observed for the ksyms_module test. When
> executed using `./test_progs -t ksyms`, prior tests manipulated errno
> and the test didn't crash when it failed at ksyms_module load, while
> using `./test_progs -t ksyms_module` crashed due to errno being
> untouched.
>
> Fixes: 67234743736a (libbpf: Generate loader program out of BPF ELF file.)
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/lib/bpf/skel_internal.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.h
> index b22b50c1b173..9cf66702fa8d 100644
> --- a/tools/lib/bpf/skel_internal.h
> +++ b/tools/lib/bpf/skel_internal.h
> @@ -105,10 +105,12 @@ static inline int bpf_load_and_run(struct bpf_load_and_run_opts *opts)
>         err = skel_sys_bpf(BPF_PROG_RUN, &attr, sizeof(attr));
>         if (err < 0 || (int)attr.test.retval < 0) {
>                 opts->errstr = "failed to execute loader prog";
> -               if (err < 0)
> +               if (err < 0) {
>                         err = -errno;
> -               else
> +               } else {
>                         err = (int)attr.test.retval;
> +                       errno = -err;
> +               }

Applied this fix as well, since I hit this bug too :)
Thanks!
