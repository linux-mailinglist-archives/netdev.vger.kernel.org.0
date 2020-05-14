Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6946B1D3DD4
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgENTpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727124AbgENTpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:45:24 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE1CC061A0C;
        Thu, 14 May 2020 12:45:24 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id e25so4872021ljg.5;
        Thu, 14 May 2020 12:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f+ynEXTEXIA/UBzTx0/2/1kODhDccZ63ruLWjclaitM=;
        b=jdu9SkxM+QwQhE4HfNAhOc9pqBrmIrbxwY0Zj3378mEgtyoHy+RsYapNXmXMCcTnPz
         7Skb5FkbUwQMyOyenlrHQUUuUUGeqEbkUO1QKDVMwe0XkLOMd/faguQCV6xbAF36DpNo
         SmYnRvSJ0sCgCJVbx+COB4KNlFoCFuizXrGO3vYwMDQbUmg2oYSKowTIob2+hqUDYd1l
         AEQHDVWRamhbJGst1/AF3h5RqNLUjZVNmMe0BTIXo1ymnpmctvu1SeddvwlXt7YZhvGS
         QwbN8PhaTc34u6HOm9DUpLtxrgvEPSaKncqvcAYIfAGIUUTRD3g7AiwA0GAPymjF7E8O
         U4ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f+ynEXTEXIA/UBzTx0/2/1kODhDccZ63ruLWjclaitM=;
        b=mhbf5Jkf5pK4P1JpSS5faL/VFIc1mN99uyrHZXxUj7xejh3pDPGwn30ktXlZNvqs+n
         1WUkd/Odr7qT/xY6RTihr9BfKAvEj17ZyOw6IPdGTp0bcUr9eFfI+3Pbg/QCyYJHDmyR
         Q3xcTW8+jxTa8NmTzvb42+7piBFKG+wbN1MTsGLWW27fpWdjs8iV4klxhPXoXWjUjfNF
         NkiLd6QdlZ00p9veJFb0HuZ34C2pYLXOpD1Vmm13skrRmsigvgfzMO54qn6dNiAir86M
         rO4RvGemXmI4jsPRa6LRP6+QJ89c+eHsHwQi3JY330Qr7GAsOpWNjCPc6rUiGh3zkASw
         wwhg==
X-Gm-Message-State: AOAM5329WMkVJ3QqpmxCzKYaA25s0YFRWAsxukuszYsL+U+hEM+31lzZ
        e2sKbXNt1BU/4eEHmE70v6Abwmh0LcfX3mGzss24rg==
X-Google-Smtp-Source: ABdhPJygk0pBhxFpXMKyyUb5nW8GY5jbwbJJSlVxvF+IETfTnIkzD1CG6sKXmT4/8atgz2BflNE2QTUdI3+q10T/4eE=
X-Received: by 2002:a2e:b4c2:: with SMTP id r2mr3841131ljm.143.1589485523007;
 Thu, 14 May 2020 12:45:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200513154414.29972-1-sumanthk@linux.ibm.com> <CAEf4BzZdAc6D0DRc+63_a=8PP6SbGn6GrHMQ8D9VmopyCT+-6A@mail.gmail.com>
In-Reply-To: <CAEf4BzZdAc6D0DRc+63_a=8PP6SbGn6GrHMQ8D9VmopyCT+-6A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 14 May 2020 12:45:11 -0700
Message-ID: <CAADnVQL4v6OK5sJZrybspQZKHMTA1EN-Q9r+O34rPkEeHg+3ug@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Fix register naming in PT_REGS s390 macros
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>, jwi@linux.ibm.com,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 11:14 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, May 13, 2020 at 8:45 AM Sumanth Korikkar <sumanthk@linux.ibm.com> wrote:
> >
> > Fix register naming in PT_REGS s390 macros
> >
> > Fixes: b8ebce86ffe6 ("libbpf: Provide CO-RE variants of PT_REGS macros")
> > Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
> > Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
> > ---
>
> Great, thanks for catching this!
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied to bpf tree. Thanks
