Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BCA3C6752
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 02:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhGMAFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 20:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhGMAFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 20:05:00 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B6DC0613DD;
        Mon, 12 Jul 2021 17:02:11 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id a16so31846450ybt.8;
        Mon, 12 Jul 2021 17:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1XFbfONQrym8mWajHQrDI6DaCktdaoVNGOfVNXqTlqU=;
        b=dFuo6cSgucUqZuu2e1mCUzI76+ZbW+FwTOnXkPhopfaqqdCvv54WRJwT9SOkXZ9zvB
         T+4TSQSOPmLL9yZlxlGzV+JanROOHXB2j14q69PUbh02cUdK+EdBmoqMx9BoLfuJR/F/
         eYYeLPuH9Og4ZXL5SarOHtAPy1H/aTUqIzcv4+hWcJryPblOR60mJpgimNMODPbqI+Re
         GH2u1FAge19dg8I3sP26/fWtyqz4vXsO+6fueMpHQ6hWrdTWWQaauPjW2FKnavAav9Aj
         b9V4CKEgIPsBRES2Cbd7Ld0X/fVCM4ChmCEquO49LAJpVfY2Nql/GGdfy9XOZZGomtot
         5GVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1XFbfONQrym8mWajHQrDI6DaCktdaoVNGOfVNXqTlqU=;
        b=JME83li+8S3v5z92ay3yvZHOeEXUQzeMBDSL7mqW+q3r8k1Ixe10BPUfx1LmK63Ccb
         uTWb1hO3jwHAxl3OysIbMdm/3ecOupen9rosgZFzGD3RxO6UnPIj2ZueUd8F6qKyQhCQ
         xQbCD0NF+y2vMVDGy2L5ez4J/B81smJDk1NFg70z9A2COPqhvshYQDn9N7tY0s19oIGw
         IMMzNqXM93mllET1OmsD0VaHMSHM5APU+QmO4fitYwEz07IIkEnPHtScEOkznZArMI6i
         3TIL72YsBI51O8iKNVQtRC5GS3jidpCnfRObI4tBw88c77z9vyALmZ9fUd4mdk5kTsPE
         Uh9A==
X-Gm-Message-State: AOAM530Lpibw3jkQw++rv1TfyhLw61vbudzP6YRs8++dnVdtKx2Rx+fl
        ljhW2TKG649uTL2JJbNuWxbFzTsEZwQSSF1mwOM=
X-Google-Smtp-Source: ABdhPJxfmS8rAuGqe5Gx3gBkVhzBs921u4akX2EPI7WTdjUZOq6zhHh1HyDDXSZmfEtal+GHBRE+TQ3236wW2/bwu/g=
X-Received: by 2002:a25:3787:: with SMTP id e129mr2026342yba.459.1626134530328;
 Mon, 12 Jul 2021 17:02:10 -0700 (PDT)
MIME-Version: 1.0
References: <1625798873-55442-1-git-send-email-chengshuyi@linux.alibaba.com>
In-Reply-To: <1625798873-55442-1-git-send-email-chengshuyi@linux.alibaba.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 12 Jul 2021 17:01:59 -0700
Message-ID: <CAEf4BzY2cdT44bfbMus=gei27ViqGE1BtGo6XrErSsOCnqtVJg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/2] libbpf: Introduce 'btf_custom_path' to 'bpf_obj_open_opts'
To:     Shuyi Cheng <chengshuyi@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 7:48 PM Shuyi Cheng <chengshuyi@linux.alibaba.com> wrote:
>
> Patch 1: Add 'btf_custom_path' to 'bpf_obj_open_opts', allow developers
> to use custom btf to perform CO-RE relocation.
>
> Patch 2: Fixed the memory leak problem pointed out by Andrii.
>

Please note that the cover letter should have a high-level overview of
what the set of patches you are sending is doing, not just a
changelog. So in this case, as an example for the future
contributions, I'd write something like this:

```
This patch set adds the ability to point to a custom BTF for the
purposes of BPF CO-RE relocations. This is useful for using BPF CO-RE
on old kernels that don't yet natively support kernel (vmlinux) BTF
and thus libbpf needs application's help in locating kernel BTF
generated separately from the kernel itself. This was already possible
to do through bpf_object__load's attribute struct, but that makes it
inconvenient to use with BPF skeleton, which only allows to specify
bpf_object_open_opts during the open step. Thus, add the ability to
override vmlinux BTF at open time.

Patch #1 adds libbpf changes. Patch #2 fixes pre-existing memory leak
detected during the code review. Patch #3 switches existing selftests
to using open_opts for custom BTF.
```

BTW, see the description above about selftests (fictional patch #3).
Please update selftests core_autosize.c and core_reloc.c to use the
new functionality instead of load_attr.target_btf_path. It's a general
rule to always add a new test or update existing test to utilize newly
added functionality. That way we can know that it actually works as
expected.


> Changelog:
> ----------
>
> v2: https://lore.kernel.org/bpf/CAEf4Bza_ua+tjxdhyy4nZ8Boeo+scipWmr_1xM1pC6N5wyuhAA@mail.gmail.com/T/#mf9cf86ae0ffa96180ac29e4fd12697eb70eccd0f
> v2->v3:
> --- Load the BTF specified by btf_custom_path to btf_vmlinux_override
>     instead of btf_bmlinux.
> --- Fix the memory leak that may be introduced by the second version
>     of the patch.
> --- Add a new patch to fix the possible memory leak caused by
>     obj->kconfig.
>
> v1: https://lore.kernel.org/bpf/CAEf4BzaGjEC4t1OefDo11pj2-HfNy0BLhs_G2UREjRNTmb2u=A@mail.gmail.com/t/#m4d9f7c6761fbd2b436b5dfe491cd864b70225804
> v1->v2:
> -- Change custom_btf_path to btf_custom_path.
> -- If the length of btf_custom_path of bpf_obj_open_opts is too long,
>    return ERR_PTR(-ENAMETOOLONG).
> -- Add `custom BTF is in addition to vmlinux BTF`
>    with btf_custom_path field.
>
> Shuyi Cheng (2):
>   libbpf: Introduce 'btf_custom_path' to 'bpf_obj_open_opts'
>   libbpf: Fix the possible memory leak caused by obj->kconfig
>
>  tools/lib/bpf/libbpf.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++----
>  tools/lib/bpf/libbpf.h |  6 +++++-
>  2 files changed, 53 insertions(+), 5 deletions(-)
>
> --
> 1.8.3.1
>
