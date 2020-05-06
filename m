Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D4F1C7CCC
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbgEFVsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729114AbgEFVr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:47:58 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB87C061A41
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 14:47:57 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id b8so1819728ybn.0
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 14:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XDCm9CTFpoK5/Dz09DifiPd0oVvuVU4Sq+Ix5lhMoGE=;
        b=q0NTsDStrOr+UQIXdfTWe7lCFEPZiokqO93iTV1gRM883GSUZ9ii/vpxrQIQN0A1PK
         kmCVpFj4K1Wr+lTRujOHHRTB4kiJZi8t3XloESG1fmKMuogXgT0nI9GowWm5nbl4P+u6
         YrT/O2jhg2DCT2+tNFqIjMSWwtAJiR4iCKGdC8F2VYCH0k2/y1+0WpCrqwTe4pAWaXJR
         DsY0q6AmpcDoIQchhkdMYSGImFRrLr9irByz7Ivdtscp3LcbCT8qlddV6wfTeYMK3YEB
         N9/bzhPxi5xmXNlMsQCoV7wW4bKDp8K4J6KH/gS8CDHHYYBrwOP42prp/zge31Yv3f+r
         sOnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XDCm9CTFpoK5/Dz09DifiPd0oVvuVU4Sq+Ix5lhMoGE=;
        b=NxYhTrnFBIcVzeYZqPvXxhE3flOPpTQ/opk4ZuvGMFZJ5Wa1sB6NY82eUUjW2uMrwX
         yXsgm6ESL5T+gQAV9a6Lk02+RuH+hQmaXJ4cvP32xsy28X5/ZowOU8dWmUHgMj+EJjRw
         eIKxmYWbuuLArlr5mnb+H7NY/3f8I2EnbMq5GEW1NwrdKOBk2XoWanZ5qnrer/9fGAi8
         UrM9fHg8ZXG1Z9yyCEYmAxJM8+isUflj8jImPDDLUrA4Rqdh/HehhbPmpHOpUGrweqmv
         PZOELXPnRFm+fXYmYypV6lsIFR7+A8Ajl5Y3It5tCEQildAbNPnUE7nX7nZMb1fgS+he
         8Njg==
X-Gm-Message-State: AGi0PuaOWNBPgsiplwwmbClHQYegKheavKYrFjLRcL68BwzZaoesi6i3
        Ew7ouAL5LhixqKfi46o4S+BRxTGaFa9W3xTaTgRTcQ==
X-Google-Smtp-Source: APiQypJdAjh8wJuI5rwPq5qfKo9myLWhJ28U+nrCFELrn/pn42TV8D9nQAhbiTKLkEzwpEtffuLetg891d5szEVZBbU=
X-Received: by 2002:a25:be81:: with SMTP id i1mr16844255ybk.184.1588801676046;
 Wed, 06 May 2020 14:47:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200506205257.8964-1-irogers@google.com> <20200506205257.8964-2-irogers@google.com>
 <CAEf4BzZRmiEds_8R8g4vaAeWvJzPb4xYLnpF0X2VNY8oTzkphQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZRmiEds_8R8g4vaAeWvJzPb4xYLnpF0X2VNY8oTzkphQ@mail.gmail.com>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 6 May 2020 14:47:44 -0700
Message-ID: <CAP-5=fXUxcGZbrJMONLBasui2S=pvta7YZENEqSkenvZis58VA@mail.gmail.com>
Subject: Re: [PATCH 1/2] lib/bpf hashmap: increase portability
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 2:33 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, May 6, 2020 at 1:54 PM Ian Rogers <irogers@google.com> wrote:
> >
> > Don't include libbpf_internal.h as it is unused and has conflicting
> > definitions, for example, with tools/perf/util/debug.h.
> > Fix a non-glibc include path.
> >
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
> >  tools/lib/bpf/hashmap.h | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> > index bae8879cdf58..d5ef212a55ba 100644
> > --- a/tools/lib/bpf/hashmap.h
> > +++ b/tools/lib/bpf/hashmap.h
> > @@ -13,9 +13,8 @@
> >  #ifdef __GLIBC__
> >  #include <bits/wordsize.h>
> >  #else
> > -#include <bits/reg.h>
> > +#include <linux/bitops.h>
>
> why this change? It might be ok for libbpf built from kernel source,
> but it will break Github libbpf.

Without this change my debian based machine wasn't able to build
within the kernel tree. I see bits/wordsize.h on the machine. Perhaps
the __WORDSIZE computation could just be based on __LP64__ to remove
any #include?

Thanks,
Ian

> >  #endif
> > -#include "libbpf_internal.h"
>
> Dropping this seems ok, don't remember why I had it here in the first place.
>
> >
> >  static inline size_t hash_bits(size_t h, int bits)
> >  {
> > --
> > 2.26.2.526.g744177e7f7-goog
> >
