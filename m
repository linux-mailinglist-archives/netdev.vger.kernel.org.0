Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68CC82E324
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfE2RZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:25:04 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46045 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfE2RZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:25:03 -0400
Received: by mail-qt1-f196.google.com with SMTP id t1so3549094qtc.12;
        Wed, 29 May 2019 10:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xyDjyrArOUdBn73QuhTdcHYiilWIQWXHmzX8mfwMWFs=;
        b=u9IOgIzNDMJ6/fZBbXhPHtENqfZ/3E8qggwcHxDlo0hE/EvGxwb9NXlODJU7AT9SY5
         uJ4TDMrs6qZieU++KvoobL1nVOG66vzFfKR2heaS5f9jT+enHeqKjoefofx1pcFTB8OQ
         PC3Cmw3tk9zPRtOaJ6bycxCygb45frs2nr6Dju5hmjIPiHyDXd+lj4nO+zL/rknAIgeE
         6XxaMErmW0iucXBeRWO/dLbr0bF8clYTNxw+0bACl/E7tM5k6Et795p+JYSHL5FS2nsk
         PhGE0+rLgnO50CgMEQzc9WivihDgfSFrFSM2me/4nDLdC3SltVdKEDvvT7tSki5wliC5
         RM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xyDjyrArOUdBn73QuhTdcHYiilWIQWXHmzX8mfwMWFs=;
        b=P0+ZRtuxJvac8yeIoTpX3YjPd1LeQ7tn2eNUD7dhsN38jkxFKUai1iEBllO71eZqwW
         VlTaMivMFDBfRzH3dEFZDHrEVMqvaEPDIKdrICXmyziac3JEW/xnDLjgUGiguvQ0lmGT
         +40CI7QPF2wcnS5MdQpCkq7/Xk26OSIjCU6nnvOIQpZuVWPudozRfOsW63pi4b54Noiw
         SGLVyFf4P9XNxBwnRi4eTV7bfQHXMSFIfN0LMz6GE25e9/tv8HlMLX7MQyPz96/zQ2th
         syoHinLBvUj/zqCtmFHldsk7sDirliPq0LCQjuO3+8HrYhzkDrD2zO5w343KkYbSjmeo
         6NFw==
X-Gm-Message-State: APjAAAW5bHtK+FsIUF8m2IKyPbxTMcEZWhHfyfmEtGk8qcEFn/w3dml6
        UXoIHcimpGQZSlIu1tQIlImLRyLFOZZXBA5iS5M=
X-Google-Smtp-Source: APXvYqzkHy4svj/A8VgjggRRpQa1tcEqtJDElgu2Xo2aKIEFmz6H2dB4ubBK7ZJHrvm/LK+7CO0RmbIXPMzmLaN9IHk=
X-Received: by 2002:ac8:2a73:: with SMTP id l48mr5237386qtl.183.1559150702882;
 Wed, 29 May 2019 10:25:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190529011426.1328736-1-andriin@fb.com> <20190529011426.1328736-8-andriin@fb.com>
In-Reply-To: <20190529011426.1328736-8-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 29 May 2019 10:24:51 -0700
Message-ID: <CAPhsuW5AzLfRcNOSRRN9YvUocMxpR2eoH6uGgwdBjqFwZPxBAw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 7/9] libbpf: simplify two pieces of logic
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 6:14 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Extra check for type is unnecessary in first case.
>
> Extra zeroing is unnecessary, as snprintf guarantees that it will
> zero-terminate string.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/lib/bpf/libbpf.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 292ea9a2dc3d..e3bc00933145 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1430,8 +1430,7 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
>                                 if (maps[map_idx].libbpf_type != type)
>                                         continue;
>                                 if (type != LIBBPF_MAP_UNSPEC ||
> -                                   (type == LIBBPF_MAP_UNSPEC &&
> -                                    maps[map_idx].offset == sym.st_value)) {
> +                                   maps[map_idx].offset == sym.st_value) {
>                                         pr_debug("relocation: find map %zd (%s) for insn %u\n",
>                                                  map_idx, maps[map_idx].name, insn_idx);
>                                         break;
> @@ -2354,7 +2353,6 @@ struct bpf_object *bpf_object__open_buffer(void *obj_buf,
>                 snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
>                          (unsigned long)obj_buf,
>                          (unsigned long)obj_buf_sz);
> -               tmp_name[sizeof(tmp_name) - 1] = '\0';
>                 name = tmp_name;
>         }
>         pr_debug("loading object '%s' from buffer\n",
> --
> 2.17.1
>
