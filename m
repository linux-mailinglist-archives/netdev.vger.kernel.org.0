Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DFD4456FE
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 17:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhKDQRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 12:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbhKDQRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 12:17:39 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C447C061714;
        Thu,  4 Nov 2021 09:15:01 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id f8so7978697plo.12;
        Thu, 04 Nov 2021 09:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sGhrNvp6uYs1eENGQtazLcPrJxO2giqX3yn86Q2Rjb0=;
        b=OzWlf0h4HDva5w8/fjj8qykjVe5BGNoaTXijP4Hro17C7voOuJc2L83UigCX/Ce/Cb
         oN9HSXKUkDlmO79igfzpN06HaVh8mgRhtICw5Ix+iFqTxY/mHUXFu+Lgs/itfW5uQ7JP
         /U/7LGPCPa/siFewODGT5aajhljPambkIPQxtS4PXL8uVpH8iv+EZGjlNFZ3QxlCK7o9
         JamSxoe3HUtNXrTPUDPNzdTb7qwxLf5FuxoCxowi/RFzgyF4DDITN2cMzVC/FqJnchSa
         /qyM12DwUyQyENbiGq+bYPQTzCb3MZoQxrJHR0Uy3G+LmnPJSrTNKeUPFC7OD+OINALE
         UQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sGhrNvp6uYs1eENGQtazLcPrJxO2giqX3yn86Q2Rjb0=;
        b=Zd9YynsPhdZV/ALtmGbrtPLi1ZcShOlyEgCNdZJzrzyB2syMMisGPhHUa54mjppRsS
         GQOV9x7Xd379wExszpqBtcpZylNkHlJ916jQwCdCyKxoCIYPPr27QNz/D+nGC6dQ3ros
         eqgwpECeeEtp1JFAF5tICsHrx6e74KGcaycvATnZaa1PKJe6zxOps+YHdyhioqKJnS0n
         Bcpcwn7Fuos5tCNWt0QPhU4YHMMJzM8997jtLrIJ1mGzksOExRn/kvXkwtgkRIO6p5Tv
         /XxjFiV/xAqHlkyW6g/HyaFfNM5ssfGaaUi946dAmlkWKoppOQhPBQDIjOvYFz4mkAHR
         DDuA==
X-Gm-Message-State: AOAM531QKqy0vkNeOHj2ehKaGwbTOpCFSvIqxxdhhf+xcMHFegdKJaoN
        bEFk6QbweuOG1qZ87y/rVLBEnRc5+oD4R/bOUGw=
X-Google-Smtp-Source: ABdhPJzTreflRsKrO58KDvo836UWmeaabpCOf7NZG2guZUrj0IZFxcDX/Iaw9TuVGSrhhCktbaJ2d2suAoiggJNMJmw=
X-Received: by 2002:a17:90a:6b0d:: with SMTP id v13mr23239514pjj.138.1636042500356;
 Thu, 04 Nov 2021 09:15:00 -0700 (PDT)
MIME-Version: 1.0
References: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
 <20211103001245.muyte7exph23tmco@ast-mbp.dhcp.thefacebook.com>
 <fcec81dd-3bb9-7dcf-139d-847538b6ad20@fb.com> <CAN22DihwJ7YDFSPk+8CCs0RcSWvZOpNV=D1u+42XabztS6hcKQ@mail.gmail.com>
 <CAADnVQJ_ger=Tjn=9SuUTES6Tt5k_G0M+6T_ELzFtw_cSVs83A@mail.gmail.com> <55c95c15-ccad-bb31-be87-ad17db7cb02a@fb.com>
In-Reply-To: <55c95c15-ccad-bb31-be87-ad17db7cb02a@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 4 Nov 2021 09:14:49 -0700
Message-ID: <CAADnVQK6kMbX379dy5XOo1s7DricX1z9WZ04PhUD6DoEPO+jsg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/3] Introduce BPF map tracing capability
To:     Yonghong Song <yhs@fb.com>
Cc:     Joe Burton <jevburton.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Joe Burton <jevburton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 3, 2021 at 9:23 PM Yonghong Song <yhs@fb.com> wrote:
>
> asm("") indeed helped preserve the call.
>
> [$ ~/tmp2] cat t.c
> int __attribute__((noinline)) foo() { asm(""); return 1; }
> int bar() { return foo() + foo(); }
> [$ ~/tmp2] clang -O2 -c t.c
> [$ ~/tmp2] llvm-objdump -d t.o
>
> t.o:    file format elf64-x86-64
>
> Disassembly of section .text:
>
> 0000000000000000 <foo>:
>         0: b8 01 00 00 00                movl    $1, %eax
>         5: c3                            retq
>         6: 66 2e 0f 1f 84 00 00 00 00 00 nopw    %cs:(%rax,%rax)
>
> 0000000000000010 <bar>:
>        10: 50                            pushq   %rax
>        11: e8 00 00 00 00                callq   0x16 <bar+0x6>
>        16: e8 00 00 00 00                callq   0x1b <bar+0xb>
>        1b: b8 02 00 00 00                movl    $2, %eax
>        20: 59                            popq    %rcx
>        21: c3                            retq
> [$ ~/tmp2]
>
> Note with asm(""), foo() is called twice, but the compiler optimization
> knows foo()'s return value is 1 so it did calculation at compiler time,
> assign the 2 to %eax and returns.

Missed %eax=2 part...
That means that asm("") is not enough.
Maybe something like:
int __attribute__((noinline)) foo()
{
  int ret = 0;
  asm volatile("" : "=r"(var) : "0"(var));
  return ret;
}
