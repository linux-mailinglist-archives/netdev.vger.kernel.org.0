Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9613C1D8BE7
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgERXzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgERXzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 19:55:33 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26071C061A0C;
        Mon, 18 May 2020 16:55:33 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id f189so12534425qkd.5;
        Mon, 18 May 2020 16:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qAA3OKl6AVtvhmTV5S8FL74OsHN/DYWammXE/OmRhwk=;
        b=of7AbYv0K2/b2seTUWM/TCubCj3XxMuDVafKnxmHkJ5qKedufmFbUg/4MMwe4PweiG
         6QojRewkL4NlTCXCkYG8wpCvaCiYXBYocBMwbJb/zweokGRWLpmqLgvQ4sJ2XcgmoECt
         ebW/k42dOPj0mVvwtLOxBNanjNzbqVAkow7SHuOVXBHJJbt5V+DwOJfw3BPGvEnify2Q
         KY060T/ZVjDBthFiAldmSGjvzLI0GaVkLRfU17VG1d3doEHlcYIg/gzgpBdoQSsP05YV
         jZ33AnHXQwB94XLYtyohTkCRzAQck5ygfcQT7BAtC3zKIJlS6vuvJoCCfqKxEp0HTb8+
         K8kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qAA3OKl6AVtvhmTV5S8FL74OsHN/DYWammXE/OmRhwk=;
        b=Qg9tkg7uIsMaNWF6+r+nz9SSM0wn11mpXeK5lA8z3Rdi7zY1HBcqMIH6PTbIKt1tst
         qbqSbWTgevPX17m8inUodj1rhyi5CEUNJFhVCT2pMBlH5c1WFPS7GtflPRmvp2nBLef+
         HIcXSQ11WH5BZY3In+XM6ofkdYRX3rIJCrUSLIGwzCeX/E+siSeRq0wh80eLpN3N+wjT
         VDC9smpry1gAn+Prcdpy1tfRD3wMuSH37qiaA1x/XVjsdkfuREBuZyxNAk2JMom8Yuew
         G+3yTPHp3gIrTSD9BjMboV+XVhPVV4SsocBWXk4SGXqMSZezQ/LUwhg3a5pMFZS2vv+h
         Dzsw==
X-Gm-Message-State: AOAM530A2ze2t8OlB9cKsa33dnLJifuW2bkxLSTqQpKJ996FoEkLfiBs
        A6HvRvxCta0lD+ZnK9O6ozdQc5+8Q/CwMEaUS64=
X-Google-Smtp-Source: ABdhPJzh9Kj+2AxdNEAYc+rIsDyGhowO1iK33avGNCWJvAzzh177gX8yg+klZsBJ+v4xBnbvsP59bmeclxmn9uEq/9s=
X-Received: by 2002:ae9:efc1:: with SMTP id d184mr19648194qkg.437.1589846132391;
 Mon, 18 May 2020 16:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAG=TAF6mfrwxF1-xEJJ9dL675uMUa7RZrOa_eL2mJizZJ-U7iQ@mail.gmail.com>
In-Reply-To: <CAG=TAF6mfrwxF1-xEJJ9dL675uMUa7RZrOa_eL2mJizZJ-U7iQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 May 2020 16:55:21 -0700
Message-ID: <CAEf4BzazvGOoJbm+zNMqTjhTPJAnVLVv9V=rXkdXZELJ4FPtiA@mail.gmail.com>
Subject: Re: UBSAN: array-index-out-of-bounds in kernel/bpf/arraymap.c:177
To:     Qian Cai <cai@lca.pw>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 7:45 PM Qian Cai <cai@lca.pw> wrote:
>
> With Clang 9.0.1,
>
> return array->value + array->elem_size * (index & array->index_mask);
>
> but array->value is,
>
> char value[0] __aligned(8);

This, and ptrs and pptrs, should be flexible arrays. But they are in a
union, and unions don't support flexible arrays. Putting each of them
into anonymous struct field also doesn't work:

/data/users/andriin/linux/include/linux/bpf.h:820:18: error: flexible
array member in a struct with no named members
   struct { void *ptrs[] __aligned(8); };

So it probably has to stay this way. Is there a way to silence UBSAN
for this particular case?
