Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F95B180211
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgCJPkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:40:12 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35743 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgCJPkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:40:12 -0400
Received: by mail-io1-f68.google.com with SMTP id h8so13233490iob.2;
        Tue, 10 Mar 2020 08:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/2Nc7EO5K8qowxgiDrjJZXV6Z7Z9/191yVE6G6w18cE=;
        b=PQf3SBsQNP1oB6jtzPQiiK7TDcfsUrs/F407VPm1MnNVt7Y4krhvssfjrRV1ipo5TA
         gIMwBoLuT2kIgmaUzYKz916Up/N8PoaeZaI1LY04foLSZ/kHE9yccVWiCHcv7Y9+WZxy
         G+218WPcguwcBtI6mRsUj47EiL+zkbULRt53bJrAxFTwo2/vV0Ih+kAHP9Je1RMcb/X6
         F6dMkivS90gQwRJX18UujKdUlDIqo7H4reKFNfwLh4ZJIvLrMOG1piI2ixWT+a1Gd8d8
         L+ait9nelBbGTW+Z7RMTk4cIqWCW0h2CFfMi1/F2IuOoS3A6TZUfja9Kk6q9MdTr+iMz
         r/hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/2Nc7EO5K8qowxgiDrjJZXV6Z7Z9/191yVE6G6w18cE=;
        b=CeNuQzAyxaMbreqiqE9QPkvClC8kclS77LzvNy3nolmRohL+oy4crUZa49mNPw9VoT
         xpp4bd4jt/AsGyOOx+FT078gNN8a7S1iXeXzqOtsRkwIVkzbRLKyTI1XpCMVqIUrdFeO
         z1+0ura6Ahx7gTY8MgJ3FI6waSUvi4+Dl5m1SToGtfxjnHT7xlkIJ94X1uAAHVjmZ4Cy
         VP2zPvwgKzeAdvDXL30bSVjCo0v3DXg9L0C5bDILRwlMbUeeCT4aMMynbVec3MALtkO1
         rwnH/m5VurRz72O0MNwJizD0qmdVYD9u83cFSaA7RQXMjZGKtArqbBJ0BOCP5zouJMfr
         jmbA==
X-Gm-Message-State: ANhLgQ2dquUShYE7mAGAvGztIt64kjFf++nEDapib5LV/jXnUa+vX+pF
        CFEZDQ95eFtAsIiLxbMafEnX28HPL0QseppLg9A=
X-Google-Smtp-Source: ADFU+vtZDKlQ+VnzgcTE5iOycELBoO27ZmSqMCAEeQrTNoeNdxJpQr+T1u4KtJrnH3x06Ce3sJyeVbxvM9YJ61iJ9Uc=
X-Received: by 2002:a6b:dd14:: with SMTP id f20mr5740184ioc.32.1583854809734;
 Tue, 10 Mar 2020 08:40:09 -0700 (PDT)
MIME-Version: 1.0
References: <1583825550-18606-1-git-send-email-komachi.yoshiki@gmail.com>
In-Reply-To: <1583825550-18606-1-git-send-email-komachi.yoshiki@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Mar 2020 08:39:58 -0700
Message-ID: <CAEf4BzYnuaeZ7s-yo7kAtHczcO5Ryc8ZGKYxWYWoFU-+WE0BRw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 0/2] Fix BTF verification of enum members with a selftest
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 12:32 AM Yoshiki Komachi
<komachi.yoshiki@gmail.com> wrote:
>
> btf_enum_check_member() checked if the size of "enum" as a struct
> member exceeded struct_size or not. Then, the function compared it
> with the size of "int". Although the size of "enum" is 4-byte by
> default (i.e., equivalent to "int"), the packing feature enables
> us to reduce it, as illustrated by the following example:
>
> struct A {
>         char m;
>         enum { E0, E1 } __attribute__((packed)) n;
> };
>
> With such a setup above, the bpf loader gave an error attempting
> to load it:
>
> ------------------------------------------------------------------
> ...
>
> [3] ENUM (anon) size=1 vlen=2
>         E0 val=0
>         E1 val=1
> [4] STRUCT A size=2 vlen=2
>         m type_id=2 bits_offset=0
>         n type_id=3 bits_offset=8
>
> [4] STRUCT A size=2 vlen=2
>         n type_id=3 bits_offset=8 Member exceeds struct_size
>
> libbpf: Error loading .BTF into kernel: -22.
>
> ------------------------------------------------------------------
>
> The related issue was previously fixed by the commit 9eea98497951 ("bpf:
> fix BTF verification of enums"). On the other hand, this series fixes
> this issue as well, and adds a selftest program for it.
>
> Changes in v2:
> - change an example in commit message based on Andrii's review
> - add a selftest program for packed "enum" type members in struct/union
>
> Yoshiki Komachi (2):
>   bpf/btf: Fix BTF verification of enum members in struct/union
>   selftests/bpf: Add test for the packed enum member in struct/union
>
>  kernel/bpf/btf.c                       |  2 +-
>  tools/testing/selftests/bpf/test_btf.c | 42 ++++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+), 1 deletion(-)
>
> --
> 1.8.3.1
>

You should have updated patch prefix for patch #1 and #2 to [PATCH v2
bpf] as well, please do it next time,

For the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>
