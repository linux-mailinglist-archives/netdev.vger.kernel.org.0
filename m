Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA7E15A5CA
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfF1UTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:19:16 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46794 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbfF1UTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 16:19:16 -0400
Received: by mail-qt1-f196.google.com with SMTP id h21so7741928qtn.13;
        Fri, 28 Jun 2019 13:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=obPM21NhQDVkccWhasuUXM9AdwGT3JrTvxws6QoC3/k=;
        b=Bm1KOV/dKaQVDVlnppcjtMk04wGw1vdgXdrBHRY/GELx/a/fwxris+s+HEh5dLdExN
         W3RYFse9CSlin3y1SuebI9HUJ+wiYYM0wf8tHt1LdMPzH/NShHa3DJg3W2ORxXz783nH
         Ko1QIHBMgFw10pSJ2DKzyT0ReZh1ugWpkvCfu18EGmNMUOZ32y47Uxo5af+qBWm0NSaK
         ZPWHh9YJkrxvqI/EKCIBmTy2dxfgN2vKla8sp2GaU9XZYKABqzV2cLjSiAcidCqI3VT0
         z2bu0J4UmScn4y0ayZEWWQkdW8skLHjwdjqwyZSDNkhM8X6r6WrtyC60VftoMco4Rtov
         eTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=obPM21NhQDVkccWhasuUXM9AdwGT3JrTvxws6QoC3/k=;
        b=lIRfS44tH/UHhSjjRWuYNgMjh8Mv092Lw006zbuM6MNoaBn0wjUY24pRpCzfBx0Tql
         r9YWGgsW/fAw14ATAaEOkuVktuQKi3t/c8/ShGXlRoDvmlVJQfM4yZrjO6sQtOtPpvQu
         edGMehSnv9g3teG4Gz8pNIcRXdX0W09dFlBRFQZTkSCVW3OzokREyBTERCeZQ80VmIFA
         VycoUsRerV9Ee7T2xVog9owiDD9T6QqV5mn5TinxmFDrr99svgRUzPz8YdVtI8A/5714
         0DhxVkmglnrFdqeMs/mA+3thZn1feH6rehZ1br0mZHg4SCdGAYGyLoQpubFdNsLtWVTU
         G7lw==
X-Gm-Message-State: APjAAAXkAb0x27A9dsWfk8ufnP0BROQNdyc2N8MtZDxv7mZXFIhQTM0J
        V+QHUVUAmPydePOfW6fJzwYwyEk7G0pLDNlovBg=
X-Google-Smtp-Source: APXvYqyios5/2liHkrZ4f+0iixB+BeIp8Ai96PizJHFfhv18y73F6tR4eha3pGrrH6BH2F2/ytNe8VVx5ZdF1Hf+h7U=
X-Received: by 2002:a0c:9695:: with SMTP id a21mr10186781qvd.24.1561753154676;
 Fri, 28 Jun 2019 13:19:14 -0700 (PDT)
MIME-Version: 1.0
References: <02938ce219d535a8c7c29ce796b3d6ea59c3ed15.1561694925.git.baruch@tkos.co.il>
In-Reply-To: <02938ce219d535a8c7c29ce796b3d6ea59c3ed15.1561694925.git.baruch@tkos.co.il>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 28 Jun 2019 13:19:03 -0700
Message-ID: <CAPhsuW4woTdoK1gMrFG=BZAXGD=ovYgm1YJ5G88DcWBrhSOYww@mail.gmail.com>
Subject: Re: [PATCH v3] bpf: fix uapi bpf_prog_info fields alignment
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 9:11 PM Baruch Siach <baruch@tkos.co.il> wrote:
>
> Merge commit 1c8c5a9d38f60 ("Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next") undid the
> fix from commit 36f9814a494 ("bpf: fix uapi hole for 32 bit compat
> applications") by taking the gpl_compatible 1-bit field definition from
> commit b85fab0e67b162 ("bpf: Add gpl_compatible flag to struct
> bpf_prog_info") as is. That breaks architectures with 16-bit alignment
> like m68k. Add 31-bit pad after gpl_compatible to restore alignment of
> following fields.
>
> Thanks to Dmitry V. Levin his analysis of this bug history.
>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Acked-by: Song Liu <songliubraving@fb.com>

> ---
> v3:
> Use alignment pad as Alexei Starovoitov suggested
>
> v2:
> Use anonymous union with pad to make it less likely to break again in
> the future.
> ---
>  include/uapi/linux/bpf.h       | 1 +
>  tools/include/uapi/linux/bpf.h | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a8b823c30b43..29a5bc3d5c66 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3143,6 +3143,7 @@ struct bpf_prog_info {
>         char name[BPF_OBJ_NAME_LEN];
>         __u32 ifindex;
>         __u32 gpl_compatible:1;
> +       __u32 :31; /* alignment pad */
>         __u64 netns_dev;
>         __u64 netns_ino;
>         __u32 nr_jited_ksyms;
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index a8b823c30b43..29a5bc3d5c66 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3143,6 +3143,7 @@ struct bpf_prog_info {
>         char name[BPF_OBJ_NAME_LEN];
>         __u32 ifindex;
>         __u32 gpl_compatible:1;
> +       __u32 :31; /* alignment pad */
>         __u64 netns_dev;
>         __u64 netns_ino;
>         __u32 nr_jited_ksyms;
> --
> 2.20.1
>
