Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684BD286B44
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 00:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgJGW51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 18:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbgJGW51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 18:57:27 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F9DC061755;
        Wed,  7 Oct 2020 15:57:27 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a15so3691020ljk.2;
        Wed, 07 Oct 2020 15:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cLY1WXFooRrMXJ56e5lUp0ByBDfKB1IU1xwg0w/w8Uo=;
        b=fJw9o6uD6Xvr43r2qPCgBcRqVgKWcutotRCl0hUxwWlGBNGOo5CV0OUS8o2YJNZhLV
         c8ORfuW5+96qiVFspI+ZWJjz7O+doqEFrzamOOJNp4DPaRpFMvZP9hpk3DDaWCAb7VIa
         YtKW4iTehvc1534ailx9jsvvMxkyaBwcjOhFJAHyktJJKE7xzyJd7QEFTjyoC3iFOYpq
         /H+rhPKYQDgcd1VmCwGx+VLNU6n6RecuYP/UkMSMDWlfI9CH04ClCVJ35dKOxZn7G+V9
         kgYsiZkSF6cJeyfjG/lfCPyUgIILH6u2Nr02KAxqQaCizSLltOMelATIC0q+S4YQySD8
         +TMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cLY1WXFooRrMXJ56e5lUp0ByBDfKB1IU1xwg0w/w8Uo=;
        b=L6yTWZYBsIL/KJyEuSIDXZYDDCLqaYGS4wHkxPXlnmaSWuNUNe2judc1C+QJrMRCS+
         ChwK5m7X2wCddT1k9JDypZZykNLOjhNAXFWMH0UhbFVbCkbMCGA45Jwmv0y6U0yax5o2
         Wz8cgdCC2Ug9obVCdpjkPeKVW7e6Soz6RVjuVFDvy1mcOt1LWgKDgi+mG5tUfkApDBob
         BMmsHkWtts7kb8hq68P4EEC6dg5UyOgX/Lrv5fK9bHxGDWuikOWNnLGrVrb46PvbWj7r
         FQ7TGVsRs0g0ujwTlFqHF9wE4ueRpG+UCOzAgs2H8ViCSrh5HeHfJT900oFwUu5gyOUb
         5oyw==
X-Gm-Message-State: AOAM531W0geALMDu2P5svY4IK5REiEkL2Ef2nwsIYEvy6+GUDON0fRFA
        j2X3eLrl31JSZjgvcmoOrhDuppYE3SVczarpgbs=
X-Google-Smtp-Source: ABdhPJxmxn6igzD3ucmH7uPYj/abFossjHg40M6ezJKEL5ttdfPhMvvzyOozrSXzWr/Q8+2R933kR471RvLHPvhZoYI=
X-Received: by 2002:a2e:7014:: with SMTP id l20mr2089835ljc.91.1602111444594;
 Wed, 07 Oct 2020 15:57:24 -0700 (PDT)
MIME-Version: 1.0
References: <20201007222734.93364-1-alexei.starovoitov@gmail.com> <CAEf4BzaHuHAcjfnNvBKzxgdjY3DpSsiVKJUXEjp7mg=WL--Bzw@mail.gmail.com>
In-Reply-To: <CAEf4BzaHuHAcjfnNvBKzxgdjY3DpSsiVKJUXEjp7mg=WL--Bzw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Oct 2020 15:57:13 -0700
Message-ID: <CAADnVQJxpG4_c3UHQg-KxOxUWSnas-cZvjtA1_VJnbEdnxbEnw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Additional asm tests for the
 verifier regalloc tracking.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 3:50 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Oct 7, 2020 at 3:28 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Add asm tests for register allocator tracking logic implemented in the patches:
> > https://lore.kernel.org/bpf/20201006200955.12350-1-alexei.starovoitov@gmail.com/T/#t
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
>
> I actually read through that assembly :) LGTM.

Thanks. I've added comments to the trickiest case :)

> Acked-by: Andrii Nakryiko <andrii@kernel.org>
>
> >  .../testing/selftests/bpf/verifier/regalloc.c | 159 ++++++++++++++++++
> >  1 file changed, 159 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/verifier/regalloc.c
> >
>
> [...]
