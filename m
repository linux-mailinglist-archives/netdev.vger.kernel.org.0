Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD09774C3
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 01:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfGZXBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 19:01:23 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:32806 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfGZXBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 19:01:23 -0400
Received: by mail-qt1-f194.google.com with SMTP id r6so49998049qtt.0;
        Fri, 26 Jul 2019 16:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CKsWoGEut8VHetzBmSR/YVPbFmV89D59h03uCfQZ1gE=;
        b=P6Sj5GOvpc41bLPnATC8ZU55ZltoeXIjh7EZl8FHLcMJcxcaK9L0lQJ/SLFtRJWVMO
         VvuRrgzeRLT4+TEomDS8pFXleIzik0MshOCbkicF0ODFKzkzpV82Y795ohN4plXRZK8m
         I8CjyHdyM2nj9VuNKuOh1U9AEjRjrzOWZ9QYpuVTliBdUnGMzamutUCUIAb/xHZvdbWR
         JUXa/7c0QUqlyndMzrlrYkIC8591y3KdUYfioQHqQYwvJgti+GJq5BWZmaujDN1qsTHr
         cL4UEQkG1GRFVmRScSQrpKGSRDSbbFDtH0gxeU5tLx1j5xtQw8Zq0L08iIfPzmPPytfb
         IZKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CKsWoGEut8VHetzBmSR/YVPbFmV89D59h03uCfQZ1gE=;
        b=cc8a1cfsuv72ZFC4+DyFXiPwuTRnSGS6vkWCvZe+omWSjlOzvGvt89ReM2A+SJaFMM
         72o/3+6tYuAl9wKAPCk+x4va2wn+pgRmNsPmgd1oBSg51moNW0qcJ8rIJCZhZgHOgmHr
         W4LjZuzlHRMtuqlHa7P+wKS9JCJDJGCQyp8RB5Ff7v9HWh6yywiSN7QhIgtNzDaUnVIc
         jY3+4rgmyIE7Sp3GRYvGjzJWTuEoyGNK+Qd7WTXScXdyAQReFXEd8fZkpAXgMAZaiOWZ
         bD1G6eFa77om+tMjUNZxhuOUIgKomZzVFYbxTwZo/+nFD1SUhlp9BSry/RweWdBYNmFJ
         i8Yg==
X-Gm-Message-State: APjAAAWuOyttARsdbmHCc+zIijGP5l5vEK5l6Cu6TwBFKfKrlpbQ56xb
        CUlMCjG0vMyQ7aWlgIQLU/hvyF2fFXvB4AQL7rk=
X-Google-Smtp-Source: APXvYqx+hA48hqlGGwbHwfF4p4DjRkqbYOIfXMQkDHmfcd7qOH5bW+OtLZtrnaom31JmdfegSTJNYCsf7omBa/ZSNe8=
X-Received: by 2002:a0c:c107:: with SMTP id f7mr69050945qvh.150.1564182082438;
 Fri, 26 Jul 2019 16:01:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190718173021.2418606-1-andriin@fb.com> <20190726204937.GD24867@kernel.org>
In-Reply-To: <20190726204937.GD24867@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jul 2019 16:01:10 -0700
Message-ID: <CAEf4BzYZT3fmQUuGp45+Mn6hLLyWnT2NE3PxfpD88sThX8JS_w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf] libbpf: fix missing __WORDSIZE definition
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 1:49 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Thu, Jul 18, 2019 at 10:30:21AM -0700, Andrii Nakryiko escreveu:
> > hashmap.h depends on __WORDSIZE being defined. It is defined by
> > glibc/musl in different headers. It's an explicit goal for musl to be
> > "non-detectable" at compilation time, so instead include glibc header if
> > glibc is explicitly detected and fall back to musl header otherwise.
> >
> > Fixes: e3b924224028 ("libbpf: add resizable non-thread safe internal hashmap")
> > Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Couldn't find ths in the bpf tree, please consider applying it:
>
> Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Arnaldo, I somehow got impression that you were going to pull this
into your perf tree. Can you please confirm that it wasn't pulled into
your tree, so that Alexei can apply it to bpf tree? Thanks!


>
>
> - Arnaldo
>
> > ---
> >  tools/lib/bpf/hashmap.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> > index 03748a742146..bae8879cdf58 100644
> > --- a/tools/lib/bpf/hashmap.h
> > +++ b/tools/lib/bpf/hashmap.h
> > @@ -10,6 +10,11 @@
> >
> >  #include <stdbool.h>
> >  #include <stddef.h>
> > +#ifdef __GLIBC__
> > +#include <bits/wordsize.h>
> > +#else
> > +#include <bits/reg.h>
> > +#endif
> >  #include "libbpf_internal.h"
> >
> >  static inline size_t hash_bits(size_t h, int bits)
> > --
> > 2.17.1
>
> --
>
> - Arnaldo
