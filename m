Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF5714331F
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 21:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgATU4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 15:56:23 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42558 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgATU4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 15:56:23 -0500
Received: by mail-qt1-f193.google.com with SMTP id j5so871843qtq.9;
        Mon, 20 Jan 2020 12:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DmDOf0n1Uh/peGzEOmgfSb9HmQAqydm6Nl5bcqVlrmM=;
        b=qtbvV9o0qlYj0zEYfaetNpBWONaNX49z7r9KiONLvB56ImwV9BfzAQfRJ/d+P39w6e
         Atx4wqs0EezVaqWKK8iOEwpK1VXFvtGnF3Z5bmzVb4hIK/JOunUkOOMX8jThq/UN+foD
         Hk9xS71cvdaBqbBeZUudlzvTmorF3r8/NnQQA91oezRuX9cO76q+rynoOBJwQ0i2hWch
         8P4FiE7epbKWthfQX7/ZH5GcrLb4ig3qRcJ2IYOUVrJN/4gFbfeV6TVC7mHa6cXu1IWz
         2+divanKVWo8d83xgUuSTG5tywO6xLNvZpBPT/j7YMcN8AqZcufWyA2HE9q3a50Xkp+1
         ptTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DmDOf0n1Uh/peGzEOmgfSb9HmQAqydm6Nl5bcqVlrmM=;
        b=Pfrm29+ZVf1itz3TbdaWRlM47c9beZnxDtcVkMxaSzv/otrqrYtvM80OdCk9dZlUwR
         fA1D0u5gSDG91kkdjibrwSHsk2F+S1up7Y7EEcNOfQUgCC9LfxpOBFjzqtcE+xPtZ0sG
         uhNdq7XoXJchuZwkHUaaFX6D/KxzUf/eRC52wdkGfswQqdKTyfS/g3wQSnrd0bR3f4ig
         v7Sj9bhDDPL9Qm5aLsQPSTUSSQ+//s4P83ommNP3l75U58I+/KrWei/y9jzdSUeiXNFL
         /ODyAssUnVYSgJ2dF1abV1VJ2HMzP0LuutBSGQeAvyEQKpBYn3NXBaOSSFaPL7pPN6WE
         Oa0w==
X-Gm-Message-State: APjAAAWR0Vxbh7/jKHugGpvgQlq3lY4gJ892PnwvQR6ct8AWtj+iyZa9
        IkZbT6BRHt4YWWHkGl5YHm1sFEZb25FgB1peWFw=
X-Google-Smtp-Source: APXvYqzrIt+QdW57C+3Nfq5K12Tt1bsCDun3Y6YsqP0UmeYR/HLoyVgHor+Ss8TdgdzRMadXC67J1+FhTg41oWHh0YE=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr1212310qtl.171.1579553781967;
 Mon, 20 Jan 2020 12:56:21 -0800 (PST)
MIME-Version: 1.0
References: <157952560001.1683545.16757917515390545122.stgit@toke.dk> <157952560237.1683545.17771785178857224877.stgit@toke.dk>
In-Reply-To: <157952560237.1683545.17771785178857224877.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 20 Jan 2020 12:56:10 -0800
Message-ID: <CAEf4BzZWahGh5ToWViFHRHQLpii-Xxc_f=xnbpuuLwXbvcDwqQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 02/11] tools/bpf/runqslower: Fix override
 option for VMLINUX_BTF
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 5:08 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> The runqslower tool refuses to build without a file to read vmlinux BTF
> from. The build fails with an error message to override the location by
> setting the VMLINUX_BTF variable if autodetection fails. However, the
> Makefile doesn't actually work with that override - the error message is
> still emitted.
>
> Fix this by including the value of VMLINUX_BTF in the expansion, and only
> emitting the error message if the *result* is empty. Also permit running
> 'make clean' even though no VMLINUX_BTF is set.
>
> Fixes: 9c01546d26d2 ("tools/bpf: Add runqslower tool to tools/bpf")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
