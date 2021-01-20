Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5752FD988
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392112AbhATTYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 14:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392088AbhATTYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 14:24:20 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCFFC061757;
        Wed, 20 Jan 2021 11:23:40 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id h205so35618256lfd.5;
        Wed, 20 Jan 2021 11:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FB9rCEvUKKLUEE3zDbbNHWd1Ms8+O71NKBDL0wI3PRE=;
        b=ps5alcIMVpBMxN05bXhD0FFEmNIACfekcJyE8TgUCjMhUrOzsr32oHcHFZjqqjVBzU
         T59rlG+opjxX3+JnutUYZmv7mz5NYgPDYG3oZtdR+VD5F2p1CbzlatTg2XAVxJ39baoz
         /BzTaX0MUwog4ymAGp4Ak97lbRFHbetd/xAmj4HWhTxXzrPrgZ6ReHE6OW+UuGXzm6DV
         ci7GpkMoEa5QIJMs8e2/fHRiKS3xwvRp3zaCTenaxKWDqOt2VnjlSoJxDaJqqzz35mDY
         55QrwejvWxwThNrkHbCLv6ZP2tHv3PeLX3kRB4dAcVLppuiHIjC1KkZdvN8gSxlcNsNC
         iUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FB9rCEvUKKLUEE3zDbbNHWd1Ms8+O71NKBDL0wI3PRE=;
        b=ox6B8QLtTcsM8dAPSYghMoCTjFFTioabs9zzIGLJFL9Xuhjq8jRe3bLxMF66WtlzIO
         oNe4QHvZL6E+uvwC3cSkVbCIMiCQZa0+541c5lZ4zKRH3SDGb7cLXNV5UWoOk3fH9b2+
         VWunIJKfgto4y+LXVAKAfyfuA9CF5nX1MbAJKBmwBbpTeJs4uLMI2/bVSQ5UpSZsVTus
         A2W5Bye+oPNTeEFrswNa74rlzaw6yyK6eIhxv0/4HqGZDI0IUHXi+S4BCRufCmMd2tEH
         VwyQNniQS/4ShOU5Vqx8e+itHWXW1ciYB4TCFbO9mOcLNtk3kf2sVfKFyFt4Dm7X9hpf
         BY+g==
X-Gm-Message-State: AOAM5312N6RUtg9JGhBexPmiXJ3Y/SbKAS0vBDrT4EtsXfUbGPf2bPM/
        VrOZcG2x10E2de3o9WEXf0mQSBu4qjc+76mbS+Q=
X-Google-Smtp-Source: ABdhPJwhrYUxdKjAh1i9WyZDqPgsq/8sEaSggDumv1OtuzGfyXnhLwa61GVUp6rmLs04sbMCDL4mQsNFqz3d8uIb1D8=
X-Received: by 2002:a19:8983:: with SMTP id l125mr4672224lfd.182.1611170618663;
 Wed, 20 Jan 2021 11:23:38 -0800 (PST)
MIME-Version: 1.0
References: <20210119114624.60400-1-bianpan2016@163.com>
In-Reply-To: <20210119114624.60400-1-bianpan2016@163.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 20 Jan 2021 11:23:27 -0800
Message-ID: <CAADnVQJr0idctwt53eD3dFmbZ_upLT6_7jc4raD825aPi640sA@mail.gmail.com>
Subject: Re: [PATCH] bpf: put file handler if no storage found
To:     Pan Bian <bianpan2016@163.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 4:03 AM Pan Bian <bianpan2016@163.com> wrote:
>
> Put file f if inode_storage_ptr() returns NULL.
>
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  kernel/bpf/bpf_inode_storage.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storage.c
> index 6edff97ad594..089d5071d4fc 100644
> --- a/kernel/bpf/bpf_inode_storage.c
> +++ b/kernel/bpf/bpf_inode_storage.c
> @@ -125,8 +125,12 @@ static int bpf_fd_inode_storage_update_elem(struct bpf_map *map, void *key,
>
>         fd = *(int *)key;
>         f = fget_raw(fd);
> -       if (!f || !inode_storage_ptr(f->f_inode))
> +       if (!f)
> +               return -EBADF;
> +       if (!inode_storage_ptr(f->f_inode)) {
> +               fput(f);
>                 return -EBADF;
> +       }

Good catch.
Somehow the patch is not in patchwork.
Could you please resubmit with Fixes tag and reduce cc list?
I guess it's hitting some spam filters in vger.
