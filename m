Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90D456196
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 06:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfFZE6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 00:58:41 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37642 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfFZE6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 00:58:41 -0400
Received: by mail-qk1-f193.google.com with SMTP id d15so611526qkl.4;
        Tue, 25 Jun 2019 21:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0OrHEeR3+U66RidUb/bN4V2v2em1a70fnkFr2OCfmNs=;
        b=PVYfovMcGFWBSBvBMrhWxHdwe4Qig4AEKR14zM8ubMyFtBnooL0+MBcrL/ecX6VzCZ
         +izYDrgexioUanxGicv3D7w4KPpqkHrFRGxC3DtRjLY2XtiDSK4VrahioH4Ke4iSbdwU
         kBB/dB1rQ8QTsEWHv40uTjlh7i7TB8hWD3kFYAyru4ALz2oRu5yCq63DaDt8G5cW5PYm
         PtLGkUkWjZCoNILFabBO91curwKYqOwhCRbMaC2A1klhTkzsLsnAHitmFW+RxsIY9GKT
         A0unOL46q/MkWNflLLWoQOWreQ4oHPJb8qW0roLUhpyUhEC3IyvPLVLO4OgFd8e7dSx2
         OE/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0OrHEeR3+U66RidUb/bN4V2v2em1a70fnkFr2OCfmNs=;
        b=oHu78ZC/UGCVtMlcnv2+lLfYRugSgY8Dto3E3KX4tV5Qge8SOKIAP66PK36IKzwkT6
         /M6i7awW+xi75REBexcRUWF85O8YYkbZngvNm4ozYNjq+p+VD0W1RP/nMnYFDocLmu5M
         Ve20K3hm0nkk4aPTVIshuu78kzE/3izidl8zK7hVxSh/s+t0Y7TmbC4bCg6lDOV/DYWE
         LY9SNHPZSi8mzEQDN+Ue0ZyCxBNVj9gMuaycYImnv5aXL1SEDaLRsNEmPuZLq83a9iSO
         p91TF0dbmLlQPqH0czxfDhwJvPUuGmWYHKGyANXWLALWA5eUOwYSORpMnlzyivicOQPv
         R5kg==
X-Gm-Message-State: APjAAAVJwVKgU5P2Ddw77QYVHKCFqlz3s21ctlY119J/2jjO/IwshLKd
        ZHkmILL/3KBZY++cc0Jd3rc4d5KjhibN6oo2FaU=
X-Google-Smtp-Source: APXvYqzvzmObldpjM7RwS5EfOCH2J79NYLejhmjGi4PMxV3Vbedmc+upuOn7531If66fNyjv30+OnMag3/PnrqHFzbU=
X-Received: by 2002:a37:a095:: with SMTP id j143mr2172011qke.449.1561525120240;
 Tue, 25 Jun 2019 21:58:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190625202700.28030-1-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190625202700.28030-1-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 25 Jun 2019 21:58:27 -0700
Message-ID: <CAEf4BzaUNfJOj1B9Zo9Bgr+W9aykH+CyzQiJXTXz1gsnc+-K4A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix max() type mismatch for 32bit
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 1:28 PM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> It fixes build error for 32bit caused by type mismatch
> size_t/unsigned long.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---

Sorry, forgot to mention, this should probably have

Fixes: bf82927125dd ("libbpf: refactor map initialization")

With that:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 68f45a96769f..5186b7710430 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -778,7 +778,7 @@ static struct bpf_map *bpf_object__add_map(struct bpf_object *obj)
>         if (obj->nr_maps < obj->maps_cap)
>                 return &obj->maps[obj->nr_maps++];
>
> -       new_cap = max(4ul, obj->maps_cap * 3 / 2);
> +       new_cap = max((size_t)4, obj->maps_cap * 3 / 2);
>         new_maps = realloc(obj->maps, new_cap * sizeof(*obj->maps));
>         if (!new_maps) {
>                 pr_warning("alloc maps for object failed\n");
> --
> 2.17.1
>
