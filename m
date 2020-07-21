Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F7C22893F
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730903AbgGUTgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730877AbgGUTgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 15:36:22 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAE8C061794;
        Tue, 21 Jul 2020 12:36:22 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id q7so25388536ljm.1;
        Tue, 21 Jul 2020 12:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fxu1ZU20Y/S/zgHj//3BPz0PVPjxCVp0vsB9qgjUbGI=;
        b=iv3E74EOrsjDcGJCRYWmYjvJE4JFVdHo+q1h8lzkAM5lpp+BLV658uHJuUCpkY5ZZa
         YgDSskaCqdxo4qh9LpkGF2xrBTegOtDhAiGS8xPkEOp7a2YbpnQembVOf+awjHQ9jD2v
         qEB+GUylavs6YAaamlVplaE11oGpmTPtnjAlKHApYpzCYhBfi0fQRLsBG8XAdc4lQq8l
         Nte4CzV6vVT2FFKtr+u+cNqqJI4fY4coAKfp8WwvlptZwtYe9flsd0O83JEaCrJYxV4h
         lvyrOTl4GnSgukCGGjhs2NCuYtpfyEquCrEtiU+UiMQH+w8Vs0AmZ2FOz/Bp1sdrHZty
         TCOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fxu1ZU20Y/S/zgHj//3BPz0PVPjxCVp0vsB9qgjUbGI=;
        b=L6upCamnpM48+r06fHDBIZjUDctox7eXm3fUtuzevPwUxtlfSuWRoy1Act79Suzgee
         Io+1DotVLvDQPjd7TRwbcZnxhXf8lSiG2G47BfqVQsqZnaIuTn9zwX+JLrXnBiGb6S+d
         id48jenFcAvfLEd/gKI4OV3Wu7V13k2orWLB9cedknLx+PVxKxJw9WluPzs7eAtBaK/U
         V5sDtwi6Ypn9q7O+1OeM7y6IRObSIWoNShe2v+CVTJBykRs499HwQyaPS8Lk9MRMXSdi
         Elka8m2AEmY8C3V7LPiIjjgAmzYoZnKdnnGZQqoZd4fHcF1gHVEJt1y5clzZlJj7K+Rp
         s00Q==
X-Gm-Message-State: AOAM530XPDsRl9CzVW9MQl+BySnJdI2ZtrwIuPoy/7qIwf8yIrEdyFsT
        +B2noPu1kM2e/cdP5wC8Z1aNJSRemS1HeBqJKTQ=
X-Google-Smtp-Source: ABdhPJysSYnh1jlHRdRZNZwwDWfeUB9z3qTS2v8zJitEDLWaA6VLUOUchmDxvMNxWd4LGJ4HdkALu78UWu0kebDLepA=
X-Received: by 2002:a2e:9bc3:: with SMTP id w3mr13974528ljj.121.1595360180907;
 Tue, 21 Jul 2020 12:36:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200715031353.14692-1-yuehaibing@huawei.com> <20200717123059.29624-1-yuehaibing@huawei.com>
In-Reply-To: <20200717123059.29624-1-yuehaibing@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Jul 2020 12:36:09 -0700
Message-ID: <CAADnVQKE=0Y5y6X2sEG1o7f6h+AektUU13=D40YOd+7OLqozFw@mail.gmail.com>
Subject: Re: [PATCH v2] tools/bpftool: Fix error handing in do_skeleton()
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 5:31 AM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fix pass 0 to PTR_ERR, also dump more err info using
> libbpf_strerror.
>
> Fixes: 5dc7a8b21144 ("bpftool, selftests/bpf: Embed object file inside skeleton")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Applied. Thanks
