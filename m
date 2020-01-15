Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 717AE13CA1A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 17:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgAOQ73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 11:59:29 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35961 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgAOQ72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 11:59:28 -0500
Received: by mail-qk1-f194.google.com with SMTP id a203so16318205qkc.3;
        Wed, 15 Jan 2020 08:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zXrVKnuJiXeQCR3gw20F62xg2np3z08kfj/7nG55paY=;
        b=OSUmC/dYP9RIlJCOVjfv/a2ZhRCa/XB3teZH6z9cTlpa2INK4lmXFx7a7gmgRTDsrH
         XHsV9vPzoCRYqP4WOtk/OaTnbdVzXYn07lB76lDBcUF9iDNNB5NUfM5medXGt9zKAxlL
         V2Nrn3JZ2rvGTGW/rLuJOyVPFhrAfrIQ81c10nP0eVXKtfeeoq9AWdXLlqthZhhudP5C
         Hr06gGZIn/xF51ZRbGZIT3gKDlM5fO2a0Tw4XTFygoUvgX5Zrk2+Ub8UuINh9tMB/PqK
         fUoM/aAxz1W5jijfpabq4sgr7V2JQ3OhOott+NfJkhQ+5VGS5J9OjhLVtdRdDi8KPM6l
         CMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zXrVKnuJiXeQCR3gw20F62xg2np3z08kfj/7nG55paY=;
        b=hS9jhCGJQd/5/visierr9+EDcPkghpZqAxKzEygKhZe6IypPgw2awBxQTnGzqifY36
         fXBAq8ZNqZvFAQmZtYEQpKxHIX12q3tVtEzsbnTh0NHnSg179AfwDzosIggv7O5+0S8Q
         TFFED6LME8ttaoqrcc4Mki940a7G4vAvyWTQhDBhdI+ZAcTOUbAXtlaBKpyMt95MSZql
         t9bPIhHLIMrl4PKYpA6Xy6hJbqtmv7n9jquSXRMhl4ytl2CQte4m/remjNkJ1L64iVpM
         zCrc3LPWAjT4uNnQgzxuT1PZGl6nTlQkX/l1hxrozaazdIavQX3wgUlBhtnoD1L7kNFZ
         kIDA==
X-Gm-Message-State: APjAAAVFmJhLXMUQgAGZKMLtgZPOBccM6BawzSOrBSqX80LIAvLc9yo1
        G6JjIk8/SNzHvLZZRK5lqArRjXS8gft4IOVP2rc=
X-Google-Smtp-Source: APXvYqyZzPUPKQU82RI/Xe8lh0YQjYoSLtx3Y3/ZmHRzsFSYleooQ9vaYsFcptvbv7JiDAeJrQDfYXfKhtZ6J3dr3Ko=
X-Received: by 2002:a05:620a:14a2:: with SMTP id x2mr28643046qkj.36.1579107567235;
 Wed, 15 Jan 2020 08:59:27 -0800 (PST)
MIME-Version: 1.0
References: <157909756858.1192265.6657542187065456112.stgit@toke.dk> <157909757089.1192265.9038866294345740126.stgit@toke.dk>
In-Reply-To: <157909757089.1192265.9038866294345740126.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jan 2020 08:59:15 -0800
Message-ID: <CAEf4BzbqY8zivZy637Xy=iTECzBAYQ7vo=M7TvsLM2Yp12bJpg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 02/10] tools/bpf/runqslower: Fix override
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
        Jakub Kicinski <jakub.kicinski@netronome.com>,
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

On Wed, Jan 15, 2020 at 6:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> The runqslower tool refuses to build without a file to read vmlinux BTF
> from. The build fails with an error message to override the location by
> setting the VMLINUX_BTF variable if autodetection fails. However, the
> Makefile doesn't actually work with that override - the error message is
> still emitted.

Do you have example command with VMLINUX_BTF override that didn't work
(and what error message was emitted)?

>
> Fix this by only doing auto-detection if no override is set. And while
> we're at it, also look for a vmlinux file in the current kernel build dir
> if none if found on the running kernel.
>
> Fixes: 9c01546d26d2 ("tools/bpf: Add runqslower tool to tools/bpf")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/bpf/runqslower/Makefile |   16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefil=
e
> index cff2fbcd29a8..fb93ce2bf2fe 100644
> --- a/tools/bpf/runqslower/Makefile
> +++ b/tools/bpf/runqslower/Makefile
> @@ -10,12 +10,16 @@ CFLAGS :=3D -g -Wall
>
>  # Try to detect best kernel BTF source
>  KERNEL_REL :=3D $(shell uname -r)
> -ifneq ("$(wildcard /sys/kernel/btf/vmlinux)","")
> -VMLINUX_BTF :=3D /sys/kernel/btf/vmlinux
> -else ifneq ("$(wildcard /boot/vmlinux-$(KERNEL_REL))","")
> -VMLINUX_BTF :=3D /boot/vmlinux-$(KERNEL_REL)
> -else
> -$(error "Can't detect kernel BTF, use VMLINUX_BTF to specify it explicit=
ly")
> +ifeq ("$(VMLINUX_BTF)","")
> +  ifneq ("$(wildcard /sys/kernel/btf/vmlinux)","")
> +  VMLINUX_BTF :=3D /sys/kernel/btf/vmlinux
> +  else ifneq ("$(wildcard /boot/vmlinux-$(KERNEL_REL))","")
> +  VMLINUX_BTF :=3D /boot/vmlinux-$(KERNEL_REL)
> +  else ifneq ("$(wildcard $(abspath ../../../vmlinux))","")
> +  VMLINUX_BTF :=3D $(abspath ../../../vmlinux)

I'm planning to mirror runqslower into libbpf Github repo and this
../../../vmlinux piece will be completely out of place in that
context. Also it only will help when building kernel in-tree. So I'd
rather not add this.

> +  else
> +  $(error "Can't detect kernel BTF, use VMLINUX_BTF to specify it explic=
itly")
> +  endif
>  endif
>
>  abs_out :=3D $(abspath $(OUTPUT))
>
