Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD09261E9E
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbgIHTxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730929AbgIHTxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 15:53:22 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FD8C061573;
        Tue,  8 Sep 2020 12:53:22 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id q3so239967ybp.7;
        Tue, 08 Sep 2020 12:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yTyF/F5IvxMDOioXAQzY5e9blFLDz2CDbDpAejd1H8Q=;
        b=hffwUQwGoFx4hBJQZQ6YWJ3KuFzmytvE02tnlBPzEO9pm6VBLYLzFigkGSv+Z7v6MV
         Syx0UZYsQr4O82A8QdGlpuPFXWHeq7QD3eOF1ugdbAoxI0Qaq21Un1RrcaYKGtXEaewN
         xzpiyicrIhvzoyk5DuYfZr+GCd4u4MbE8E61/pQOGOhb+zhrV2Fjk6Sa2CJBIMhlZO2s
         JV8cBI1fuOExCUwliCPLqxaZU9r36DhM3/H8z/i3M0ggCIrh+oJlEw5MybkrA9JzpF5P
         CBQPqgE+Qke6rFGKeMN6jZR62KrVCioCrP0bRY98hd7PqRET2QraiXwpxg0susB5L1zU
         EAiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yTyF/F5IvxMDOioXAQzY5e9blFLDz2CDbDpAejd1H8Q=;
        b=PnZhp0HcvhYx17d+n4w9Uy4+Daf6Z8BSe5V1kVyozDUPOal7MsL44e5SAXDqHSrb2V
         32SWlWB5OLwp5ETksf0ds5ElqTdx4pY/IN1PYj7w1GxwEHDMuJyQVMvr96ajGYcXDtET
         OndofahlGQgvmEz0jJdktQATzzBkt43QtHG9kFIQUHuyq+xGwvxrvY0Scg/gunBNijNb
         K3VEsmWwhP1kk7AhHJlX3rxaBCWLrDLfsduZuRZg59KHjv+roHNH7au07eocFcsVz1bb
         NNNE09oLkuaWY8kKRPIKe3Ty8v4yjNUPRSR6aIQ18lVd7F5LBDvgpEpvL137VyCW/WEC
         rfyA==
X-Gm-Message-State: AOAM5312MS0er+3d9/pzn2KT6hCJYW0i0G4rUTHK6uFkuZ8z98G7q0os
        Aaf5tp/oQG7LP98WZmVzcEHiHc6yRsnW2m4YA1g=
X-Google-Smtp-Source: ABdhPJypdtRntJkWOeqoqZ6XwPLWfAEpxJr1JgmZrfwrp7n+nNGFoQWUG/WIwHXJE2gWbQlfnZ8M4rNP1ZYilorEIWw=
X-Received: by 2002:a25:c049:: with SMTP id c70mr717935ybf.403.1599594801125;
 Tue, 08 Sep 2020 12:53:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200905214831.1565465-1-Tony.Ambardar@gmail.com>
In-Reply-To: <20200905214831.1565465-1-Tony.Ambardar@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Sep 2020 12:53:10 -0700
Message-ID: <CAEf4BzYmHLvnMrg-b5rgLCU2fg3C1q1SHbonao96fFOPYagC8w@mail.gmail.com>
Subject: Re: [PATCH bpf v1] tools/libbpf: avoid counting local symbols in ABI check
To:     Tony Ambardar <tony.ambardar@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 5, 2020 at 2:49 PM Tony Ambardar <tony.ambardar@gmail.com> wrote:
>
> Encountered the following failure building libbpf from kernel 5.8.5 sources
> with GCC 8.4.0 and binutils 2.34: (long paths shortened)
>
>   Warning: Num of global symbols in sharedobjs/libbpf-in.o (234) does NOT
>   match with num of versioned symbols in libbpf.so (236). Please make sure
>   all LIBBPF_API symbols are versioned in libbpf.map.
>   --- libbpf_global_syms.tmp    2020-09-02 07:30:58.920084380 +0000
>   +++ libbpf_versioned_syms.tmp 2020-09-02 07:30:58.924084388 +0000
>   @@ -1,3 +1,5 @@
>   +_fini
>   +_init
>    bpf_btf_get_fd_by_id
>    bpf_btf_get_next_id
>    bpf_create_map
>   make[4]: *** [Makefile:210: check_abi] Error 1
>
> Investigation shows _fini and _init are actually local symbols counted
> amongst global ones:
>
>   $ readelf --dyn-syms --wide libbpf.so|head -10
>
>   Symbol table '.dynsym' contains 343 entries:
>      Num:    Value  Size Type    Bind   Vis      Ndx Name
>        0: 00000000     0 NOTYPE  LOCAL  DEFAULT  UND
>        1: 00004098     0 SECTION LOCAL  DEFAULT   11
>        2: 00004098     8 FUNC    LOCAL  DEFAULT   11 _init@@LIBBPF_0.0.1
>        3: 00023040     8 FUNC    LOCAL  DEFAULT   14 _fini@@LIBBPF_0.0.1
>        4: 00000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.0.4
>        5: 00000000     0 OBJECT  GLOBAL DEFAULT  ABS LIBBPF_0.0.1
>        6: 0000ffa4     8 FUNC    GLOBAL DEFAULT   12 bpf_object__find_map_by_offset@@LIBBPF_0.0.1
>
> A previous commit filtered global symbols in sharedobjs/libbpf-in.o. Do the
> same with the libbpf.so DSO for consistent comparison.
>
> Fixes: 306b267cb3c4 ("libbpf: Verify versioned symbols")
>
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> ---

LGTM, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index b78484e7a608..9ae8f4ef0aac 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -152,6 +152,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
>                            awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
>                            sort -u | wc -l)
>  VERSIONED_SYM_COUNT = $(shell readelf --dyn-syms --wide $(OUTPUT)libbpf.so | \
> +                             awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
>                               grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
>
>  CMD_TARGETS = $(LIB_TARGET) $(PC_FILE)
> @@ -219,6 +220,7 @@ check_abi: $(OUTPUT)libbpf.so
>                     awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
>                     sort -u > $(OUTPUT)libbpf_global_syms.tmp;           \
>                 readelf --dyn-syms --wide $(OUTPUT)libbpf.so |           \
> +                   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
>                     grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |             \
>                     sort -u > $(OUTPUT)libbpf_versioned_syms.tmp;        \
>                 diff -u $(OUTPUT)libbpf_global_syms.tmp                  \
> --
> 2.25.1
>
