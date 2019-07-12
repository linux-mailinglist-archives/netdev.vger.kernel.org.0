Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 072E66630D
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 02:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728887AbfGLAth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 20:49:37 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34789 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfGLAth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 20:49:37 -0400
Received: by mail-qt1-f195.google.com with SMTP id k10so6482578qtq.1;
        Thu, 11 Jul 2019 17:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FFEMusMstvLu6dKMmbZCyJ/qK2tJZq6EONZVRYJnMc4=;
        b=UhfrT8zHIgRU5BPbRcM1kGlFdP5C2Wekj9514obINpSE8bhh/qU7YjXB8c9XsBcVbH
         NqQWQ6e47Hin/hhHtpyDsXEwCYDhQGvpzdnMbvMEke7RbOnJQHwY1fnfyV+6ytjGTdSV
         V1TOvWl24eAGQH3J/gJLZNKWT0yQOQv2fg/JBeo3aY6H9ys/kwOKPLcm/89Z8WTrmbaj
         FJqUxiQJsIV0q1p+Mb9yQKYPGC2z73cb/GSpoNzUWstoQiGcuvNQxDnUOnM6RG6OvRxJ
         B0a474MHREw8Xw7V9Rsoge7nhMXExBre6/gg5MLZKcXVA45BJuLRFPES7EJlbhrynspE
         /3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FFEMusMstvLu6dKMmbZCyJ/qK2tJZq6EONZVRYJnMc4=;
        b=e0MhImXbgiai2TVO/LQJn5pEzmbzXl8AsuoKrObvaQGQhH6VCF8LkrYL6eOMg/UcJI
         RI1+C+RgIa0mLD8EKcE0I1hgGZ4GK9HFM1V5DXhSzA1ynwvwxq5HKIwhXeJFoOcxSPI1
         45dV+AJsZYvSKkniYwgsaZ+tKvnUAz9Jc7FqbgqT05CsSl1cLnq3UHj5TUnW6ZkncbfL
         5KI2/LOAkf0jixfUkHpqx3Yx2Yzbx4qzJMssF2YZ4wpH9i92ZBOQTEaQbU9xl98XEO4n
         6EUfvWewCGgWrCigexr2nJzYCrv0bOqDMb3qu5kTGVVx6yd9fY6YtYJCCyk9moEWdK5/
         zW0w==
X-Gm-Message-State: APjAAAVeQWYdiS/qSt0yI7JfHTKS5sX+xnfX1/SR9SVSM2qcDtBpGoJ7
        boXnhsP+f1fjxQlP4KmfbwoS+QaYHKxWVU62oiI=
X-Google-Smtp-Source: APXvYqzK+ZzUDTUqm3mEmbdD1PMl9RW3qFBN7x/hLeRFWmSxg6RDU2kLGdzOkIgZ/xT2PQqi1ZGrFRooi/SeXrNsjmM=
X-Received: by 2002:a0c:818f:: with SMTP id 15mr4018751qvd.162.1562892572581;
 Thu, 11 Jul 2019 17:49:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190711142930.68809-1-iii@linux.ibm.com> <20190711142930.68809-4-iii@linux.ibm.com>
In-Reply-To: <20190711142930.68809-4-iii@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Jul 2019 17:49:21 -0700
Message-ID: <CAEf4BzZ3-oA_h2YbpgUXnLoCL_6dj881rryizcUP=Kxf512-9A@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/4] selftests/bpf: make PT_REGS_* work in userspace
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Y Song <ys114321@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 7:31 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> Right now, on certain architectures, these macros are usable only with
> kernel headers. This patch makes it possible to use them with userspace
> headers and, as a consequence, not only in BPF samples, but also in BPF
> selftests.
>
> On s390, provide the forward declaration of struct pt_regs and cast it
> to user_pt_regs in PT_REGS_* macros. This is necessary, because instead
> of the full struct pt_regs, s390 exposes only its first member
> user_pt_regs to userspace, and bpf_helpers.h is used with both userspace
> (in selftests) and kernel (in samples) headers. It was added in commit
> 466698e654e8 ("s390/bpf: correct broken uapi for
> BPF_PROG_TYPE_PERF_EVENT program type").
>
> Ditto on arm64.
>
> On x86, provide userspace versions of PT_REGS_* macros. Unlike s390 and
> arm64, x86 provides struct pt_regs to both userspace and kernel, however,
> with different member names.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---

This is great, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>



>  tools/testing/selftests/bpf/bpf_helpers.h | 75 +++++++++++++++++------
>  1 file changed, 55 insertions(+), 20 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 73071a94769a..27090d94afb6 100644

[...]
