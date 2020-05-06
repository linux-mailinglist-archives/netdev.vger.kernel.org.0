Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160221C7CE6
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbgEFV4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726927AbgEFV43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:56:29 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AB6C061A0F;
        Wed,  6 May 2020 14:56:29 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id q13so2988018qtp.7;
        Wed, 06 May 2020 14:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aBCiVVZEpJWRYd7epspD5olBcNsS+jZLiGB12vTlPJ0=;
        b=n/kzFmwEJyYkO9ldTqSkf7R/Yy7OqGmNcDVU8GEQizholP9steDnVou2QWWWDccrg+
         sic3e+clFU3UKJovfLUY3aneEcWmSnucNVF3YdOnviRoXdhA4FLM/cBicuS5uwK/4RtI
         q5fLMKyJZk+JYqO429wZdWZKoENTBwVJUi4Q+2mBzXXATv72RikKhuqvs4f4uOFOg7OE
         E6vY7lvSQPyBtJL47ASNUlyAyPmELWMYoECwS3FvY7ICNjQMF+aS2MrgamfRnm81Cu80
         dUCBkXHAmwos/sf8NZFPytrAGqxsgnOoIszFejTO7GpR2sPHAUeeqOhdJSCL2HvzevQF
         bsSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aBCiVVZEpJWRYd7epspD5olBcNsS+jZLiGB12vTlPJ0=;
        b=G1vNm3fxSWDxIYjb332B7XR+YQHFm/85I2vSlzHS0deBgkLpQnHbcWLty5hD5cqans
         lIAj+LLC2ZTlSzOQ0+1xyOaJD8wp/Yt7mhC2uSBSrmK1m/RQ39pb2wpcaVhQGudH4dTz
         1hUDq/v7DanTtsCPSW7CUnkQXACP5YhE6SpUBSfjln7RdHcngq84rAUCQL8KjOTmI1oP
         vZvfBZPJcn+ntDZHgU5XunE8r8h6C1+dyy+4k2h+p2cFsyASv9H1v07oGj1ehbOaTJGF
         PvHOi+e97mf0JCtcZuGIGyEvf3W7HqoaUbkLCWZhch/CtXyntuoLwVaWXwYwdgL4AZF7
         de1w==
X-Gm-Message-State: AGi0Pua/OZrVpj6tQ+2gLlDc1oqUDfgK5AlToxzPBqGBA67hhIr3yydx
        EAofM/5H1hiPqUU70TNjDaJTyeiuRFxg4WYU7pA=
X-Google-Smtp-Source: APiQypK4NoKr538iX+W9Wacx4prmGnbwutNe7LOltABa0SwhYN8wYMurbB6deVOp9aDSqEPBGCyIIDsde3En5uPnqRY=
X-Received: by 2002:ac8:468d:: with SMTP id g13mr10390645qto.59.1588802188756;
 Wed, 06 May 2020 14:56:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200506205257.8964-1-irogers@google.com> <20200506205257.8964-2-irogers@google.com>
 <CAEf4BzZRmiEds_8R8g4vaAeWvJzPb4xYLnpF0X2VNY8oTzkphQ@mail.gmail.com> <CAP-5=fXUxcGZbrJMONLBasui2S=pvta7YZENEqSkenvZis58VA@mail.gmail.com>
In-Reply-To: <CAP-5=fXUxcGZbrJMONLBasui2S=pvta7YZENEqSkenvZis58VA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 May 2020 14:56:17 -0700
Message-ID: <CAEf4BzYxTTND7T7X0dLr2CbkEvUuKtarOeoJYYROefij+qds0w@mail.gmail.com>
Subject: Re: [PATCH 1/2] lib/bpf hashmap: increase portability
To:     Ian Rogers <irogers@google.com>
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

On Wed, May 6, 2020 at 2:47 PM Ian Rogers <irogers@google.com> wrote:
>
> On Wed, May 6, 2020 at 2:33 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, May 6, 2020 at 1:54 PM Ian Rogers <irogers@google.com> wrote:
> > >
> > > Don't include libbpf_internal.h as it is unused and has conflicting
> > > definitions, for example, with tools/perf/util/debug.h.
> > > Fix a non-glibc include path.
> > >
> > > Signed-off-by: Ian Rogers <irogers@google.com>
> > > ---
> > >  tools/lib/bpf/hashmap.h | 3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> > > index bae8879cdf58..d5ef212a55ba 100644
> > > --- a/tools/lib/bpf/hashmap.h
> > > +++ b/tools/lib/bpf/hashmap.h
> > > @@ -13,9 +13,8 @@
> > >  #ifdef __GLIBC__
> > >  #include <bits/wordsize.h>
> > >  #else
> > > -#include <bits/reg.h>
> > > +#include <linux/bitops.h>
> >
> > why this change? It might be ok for libbpf built from kernel source,
> > but it will break Github libbpf.
>
> Without this change my debian based machine wasn't able to build
> within the kernel tree. I see bits/wordsize.h on the machine. Perhaps
> the __WORDSIZE computation could just be based on __LP64__ to remove
> any #include?

It might work. Do you mind forking https://github.com/libbpf/libbpf
and trying to execute travis CI tests with such change? It compiles
across a range of distros and arches. You might need to set up Travis
CI login, hope that's not a problem. Thanks!

>
> Thanks,
> Ian
>
> > >  #endif
> > > -#include "libbpf_internal.h"
> >
> > Dropping this seems ok, don't remember why I had it here in the first place.
> >
> > >
> > >  static inline size_t hash_bits(size_t h, int bits)
> > >  {
> > > --
> > > 2.26.2.526.g744177e7f7-goog
> > >
