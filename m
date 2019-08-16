Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7CCF8FA60
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 07:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfHPFYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 01:24:47 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34090 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfHPFYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 01:24:46 -0400
Received: by mail-lf1-f66.google.com with SMTP id b29so3242610lfq.1;
        Thu, 15 Aug 2019 22:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rpfB3Q5jcM+4sbz0QcY5vnHo3c0rHRb/VWMYMI6DOqw=;
        b=O9aQa6vXGh2JKZ24LO62tv8KbvE4fTqMX9XH6D43Rb8tNNl+oQffVUylgUyoFxV6iK
         wRDllUngoU8SZ5L241dO79srqiUQfHd7B3kF9WDgdAq9r1b8/bQKtK5TKmjB+5pICfjb
         nUULr2chxztm8lG2h1jcq9NhgiVBJwUUfkvnsY+Lyn8vixlxOlQLTBNidLFWD0qvlOc/
         /vnDY8kfViPf1MhDSzvKou3Xx/A+MmT5UG8fT95l1zaRgj64hh86sLUlzgn6j58FWBYn
         DhitkqsF8nyJwkWi3QUICn2c1+ErEzlvlmXTkW3hJUz7bVqKws7jrheXHqKZOrmRVc72
         r4lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rpfB3Q5jcM+4sbz0QcY5vnHo3c0rHRb/VWMYMI6DOqw=;
        b=gfZbjI9KjNlFqfKLliXHle1bQowkjOgNQRdeTkeRIE4kRYrDoqab3fMHInEQ3Z/mnV
         80NYdHy2RUdpJFjtJeXLrYdRaKsQIJHEBwvii3pva+ojy+q99BhAcV0aEdMDf4VuNHL8
         nHx6TsUlZyF00+RT2+4wS/IpOva+Udlgli1td8X7ezZdF6I+1XX0Btgzhk/lfxz0ghlf
         TaWSkZTzZenXzJxMq4Nte3Y56vQxe+PsPM38rNaH1Wfi3Dpr2BOlCcXLnQuMmKE6BXNl
         hPXZRG8UqrJyIyaZP6bDjdrU/wK15rHz4Suw7oofUiuflWVoHbldNmWHbr31MnLRrDnm
         VsvQ==
X-Gm-Message-State: APjAAAVMyUhzAPGcbGhXLtbXWIVkLaQDmnd41428CQA8nQSCw2pGEpFr
        x38G/c/AwTl7hiMxsZrSOQfB2aSL74oBvmjN/lM=
X-Google-Smtp-Source: APXvYqzn5i/+XEV2n+C529s0+kZBTANKIa5O2lpzrVhd6ZBs+0aYkWQrlmxhSKaa3+GkHOpVNGLsPqrjrWTygNCsqYg=
X-Received: by 2002:a19:ca4b:: with SMTP id h11mr3994625lfj.162.1565933084391;
 Thu, 15 Aug 2019 22:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190815142432.101401-1-weiyongjun1@huawei.com> <20190816024044.139761-1-weiyongjun1@huawei.com>
In-Reply-To: <20190816024044.139761-1-weiyongjun1@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Aug 2019 22:24:33 -0700
Message-ID: <CAADnVQK_NTZVXosgLDBg-in+HBDaK5d24heaR0HSkEw2L0g=6w@mail.gmail.com>
Subject: Re: [PATCH -next v2] btf: fix return value check in btf_vmlinux_init()
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 7:36 PM Wei Yongjun <weiyongjun1@huawei.com> wrote:
>
> In case of error, the function kobject_create_and_add() returns NULL
> pointer not ERR_PTR(). The IS_ERR() test in the return value check
> should be replaced with NULL test.
>
> Fixes: 341dfcf8d78e ("btf: expose BTF info through sysfs")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks.

Please spell out [PATCH v2 bpf-next] in the subject next time.
