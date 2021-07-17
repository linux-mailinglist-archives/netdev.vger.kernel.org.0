Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372253CC01F
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 02:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhGQAfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 20:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhGQAfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 20:35:47 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48810C06175F;
        Fri, 16 Jul 2021 17:32:51 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id k184so17575284ybf.12;
        Fri, 16 Jul 2021 17:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kpyLInZ23t1JdTv5YH8Lulxd0oqyy3IgpReraeEh2kY=;
        b=NTtlhJOe+oL5dewMsuBCE+A+AJNOTNfqOu8V3/s2uNOL6Pt4a+NRpQswWlYGLa2CiX
         5pBjDGoUu+mz5p3cWBN54RZAXbVM+Fy5zJZJY3PepDYYM7zOanR1tfueHnD88Twuv6Bg
         ybyFy0j9uHT0I/IAJq+nFWOi8V9DZ7pBZVFU79+R102GpnifWJIfxhgMl12pH+H8A1CH
         rAJLHLcUhv9JrZaVYVy8agrxi9ioXeAKbKUvMcMCZeCoEnWnFfkAMZztfVW/DaZaZVsx
         0UE9JFPHZVvCpUgXo/tInaGorDkhk9mzG2RIcm3wsxMtn6D9FYwplYF1L/LUrCKVBgy4
         0hyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kpyLInZ23t1JdTv5YH8Lulxd0oqyy3IgpReraeEh2kY=;
        b=o0Pj4ETjJ3XQxotAgLnu6e7NyHYv7nRBvu1ACpRT6iT+e6OWheBNFZLXHCTnq+Iwtd
         IAlMIEmSPjiOZQI6CVo0ecW9bhwiQBF1fZEHOJk9fWK2Kufy12NzrLTtQnsIf8NP4QlI
         7vIr4mSXCTh9HdAsizniO292A6jMZPy+esYV9co5Oy6i0YMJbS+mbCCW2AqCNrz6EnBY
         uiJxrMkVLLqSqcHuyrqOxeqxDbdSy2zlbOFFHI6Ln0D/4gKSdqYcW0aq+RUOPWp2Z+/4
         LDVbLxckzGSWXQ4sCspOdCC/Tf8+oWTCb/JYfaNwmEZ8MrOvwtChiUmgvkRo2kXT1/1P
         a1/Q==
X-Gm-Message-State: AOAM530G0C7w1ggJh6G8Qq2EmXJmoD51ZqGo4pUoqtqm4Bgj+QsA1GaG
        OAW3F/BJioZLkUOAgvelyLQVaRRRfytpj3R3fA0=
X-Google-Smtp-Source: ABdhPJxe3mFqGu3F5HoBSLl+FlVHoWz/Qd4EKRmuOiH8k+dleyNeGfcYE46wGcVq720EBwmWmTKJZHtZ1cwGq8C7leE=
X-Received: by 2002:a25:d349:: with SMTP id e70mr16315021ybf.510.1626481970369;
 Fri, 16 Jul 2021 17:32:50 -0700 (PDT)
MIME-Version: 1.0
References: <1626475617-25984-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1626475617-25984-1-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 16 Jul 2021 17:32:39 -0700
Message-ID: <CAEf4BzbCYhJnvrEOvbYt3vbhr23BytbfDPkc=GUgkzneVJVJMQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/3] libbpf: BTF typed dump cleanups
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 3:47 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Fix issues with libbpf BTF typed dump code.  Patch 1 addresses handling
> of unaligned data. Patch 2 fixes issues Andrii noticed when compiling
> on ppc64le.  Patch 3 simplifies typed dump by getting rid of allocation
> of dump data structure which tracks dump state etc.
>
> Changes since v1:
>
>  - Andrii suggested using a function instead of a macro for checking
>    alignment of data, and pointed out that we need to consider dump
>    ptr size versus native pointer size (patch 1)
>
> Alan Maguire (3):
>   libbpf: clarify/fix unaligned data issues for btf typed dump
>   libbpf: fix compilation errors on ppc64le for btf dump typed data
>   libbpf: btf typed dump does not need to allocate dump data
>
>  tools/lib/bpf/btf_dump.c | 39 ++++++++++++++++++++++++++++++---------
>  1 file changed, 30 insertions(+), 9 deletions(-)
>
> --
> 1.8.3.1
>

Thank you for the quick follow up. But see all the comments I left and
the fix ups I had to do. Just because the changes are small doesn't
mean you should get sloppy about making them. Please be a bit more
thorough in future patches.

Applied to bpf-next.
