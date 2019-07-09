Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0446F63A4D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 19:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfGIRux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 13:50:53 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43423 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbfGIRux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 13:50:53 -0400
Received: by mail-qt1-f195.google.com with SMTP id w17so19374788qto.10;
        Tue, 09 Jul 2019 10:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HbR/FwJaNA1U78yvn7Pam7D/QH3xOj8IA+pEkc6eqOM=;
        b=FOi0rZmFtZ9e5iE7P2cQMmg7hUV9836GTzxy+Zj/wRGTebRGeSsKDik4j/xOWHQeT9
         nDWAlgcCtfKJkZAvKlnP6EfoPc2ulOrUwFpDUYxCIdplDT8gDsPI0iFI7nROpQSVwhLP
         iPPIEgf31mEJQSrFbCZsObhB7L6JAGI+8vMD0lHFzTZ2t2rJUWKN38Og/g2O36EAV0+5
         emDbff2oZaliVxc88whGKSUQOTPDnJQuJq3ihC1L1crKhSJhpyHj354rdJ4RtIqeRrRP
         sNyFS4n543nO8j0vKyozlbqnfEiajeFIkIX//PZUXVFHv/bzrUr7KIRSFChae1VNEmza
         n+qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HbR/FwJaNA1U78yvn7Pam7D/QH3xOj8IA+pEkc6eqOM=;
        b=fUQ8cynu5Imz9m4kZw7Jw5Oy3rQYnWl/O1FYU0wYv0Wqk6+Q3sra4sJ5njFEmFBcm8
         Fw+K9FweOMGs8RGDC8cB8ZTTwd/GJ5lG+NPrIW/y+vJTy4rSvPyHFt2ueBGvPhLCY9I8
         AVupBhNVUG5t0CUH2OT58NNOq8C3n5aSlJNjLo3kkQyV120m79Dx6bLL1/a/PVmyN2ku
         0G5c86xprh6RIivPmkRnwvLpNqREsVA903IDLK+yiec3kYaVQV4M0r21TOi0Cm1Hoxv0
         zr2NEwikCPtZKc8l4+oukmNC3MdEi8drLFsUHpm/dJ059QppyBjKraz+Dto78O9PD388
         9UGw==
X-Gm-Message-State: APjAAAXdVgiI3j6vl0mv4JYW//x3bqpIe/CBmIoAbFyJIX9pmnUffSwU
        Mp3ETXLS/989Sa3xE5EtEjMTjqA2qYVHkH3RjhU=
X-Google-Smtp-Source: APXvYqzwChPeVwKY82QRDgOW5y3+jFFTwvWRKIzZgxSJIfltI28uMOIEp7ofm4ZtQJYfwg07vIBCgy3QAs7bjqjZVSo=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr19460735qta.171.1562694652078;
 Tue, 09 Jul 2019 10:50:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190709151809.37539-1-iii@linux.ibm.com>
In-Reply-To: <20190709151809.37539-1-iii@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 9 Jul 2019 10:50:41 -0700
Message-ID: <CAEf4BzaYpYaotOFDQW017jkAdTC6rLvPRJPhHbPRcSWjEQzhmA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/4] selftests/bpf: fix compiling
 loop{1,2,3}.c on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Y Song <ys114321@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 9, 2019 at 8:18 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> Use PT_REGS_RC(ctx) instead of ctx->rax, which is not present on s390.
>
> This patch series consists of three preparatory commits, which make it
> possible to use PT_REGS_RC in BPF selftests, followed by the actual fix.
>
> Since the last time, I've tested it with x86_64-linux-gnu-,
> aarch64-linux-gnu-, arm-linux-gnueabihf-, mips64el-linux-gnuabi64-,
> powerpc64le-linux-gnu-, s390x-linux-gnu- and sparc64-linux-gnu-
> compilers, and found that I also need to add arm64 support.
>
> Like s390, arm64 exports user_pt_regs instead of struct pt_regs to
> userspace.
>
> I've also made fixes for a few unrelated build problems, which I will
> post separately.
>
> v1->v2: Split into multiple patches.
> v2->v3: Added arm64 support.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
>
>

Acked-by: Andrii Nakryiko <andriin@fb.com>
