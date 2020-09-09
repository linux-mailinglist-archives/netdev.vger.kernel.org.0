Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F2E26245E
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 03:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIIBFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 21:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIIBFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 21:05:52 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27420C061573;
        Tue,  8 Sep 2020 18:05:51 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gf14so473146pjb.5;
        Tue, 08 Sep 2020 18:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zr6cnsJrgGJ7VyctdOhrp3MO2aQmMSjefw9UvSk2yzk=;
        b=kHr8dTzJ2Zha+Du3DjsnzZDE2WU0Ygh7mE+tPAEPc9+Ol92EDfIY7UZcIyJoOCQjE/
         Ng7GWuzA8UQpNUU8kTBDrFwXbrWGAZ6m5SkYDpIcgRZ00bzq0qiCdvg0lPuMuDsPu+dB
         YrHE6xHmTFhildA5rPc+UyQImJMX4VtzyNN2MpQi5ETiSFYZ8qQmaUTJBdCRTMBrdxYK
         cf2kLCvZtnBPxITWJB3g+a/jHTfk/xUqS2VyqmPRgTUrcxr+Db+oWgeF9+8IHFMCjiIp
         8bO8+sXlHLVD/W0kKmKotOUY3QSqRTjYC7pbNU8JZ+1hWJBEPDKA6ppnp/4B+e25Zj0Z
         buuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zr6cnsJrgGJ7VyctdOhrp3MO2aQmMSjefw9UvSk2yzk=;
        b=G2a/golNWUsW0dUbvCtGLqDdBvGzBtCuQsLm4o5BFzP4jGuFpPiRajLEOQ3PiLBGfW
         SHpE+hwGv+tMrej1kR11+FxIk/svElv2GcBhnmTNZ+F8vhJeHkmcX6awvegSnWKWo0dV
         5IGISJbgs7KbuyXLx6UuKlIYRukFwtIKPAnHK44b8QyboPk/P4MG4dKm1pRY5XjCUiCI
         Cq2s6QDN/qAwzUjej/gK7SPqX1OX0XxaY9sBm2zJc9YbZTT2Qz9fC2NCaghFktj6KkEh
         gTMkZBI7P/Jg4UPJZkf2+Vg6nQxlHAjK8DTAHe88xfhxswtXI52gcYQy8mwJflmXVIBU
         MoBA==
X-Gm-Message-State: AOAM533SXOzIL7ettiH6yt4bAlRNGexzaIAfHO13DQ9cT7zv6cxPpehk
        92gC6Bi4gPM99s5W1HgHWeM=
X-Google-Smtp-Source: ABdhPJyO8D8EaICbd5KYVI64MaDJvzPXVnFgMcZYSKA+UeY0fuEonhQoNZoNuIBJQcKimWZl1l5zng==
X-Received: by 2002:a17:90a:5304:: with SMTP id x4mr1298263pjh.16.1599613550538;
        Tue, 08 Sep 2020 18:05:50 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:39bb])
        by smtp.gmail.com with ESMTPSA id f207sm620986pfa.54.2020.09.08.18.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 18:05:49 -0700 (PDT)
Date:   Tue, 8 Sep 2020 18:05:47 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v3 2/2] selftests/bpf: add test for map_ptr
 arithmetic
Message-ID: <20200909010547.4xvmkqjt4x264wk7@ast-mbp.dhcp.thefacebook.com>
References: <20200908175702.2463416-1-yhs@fb.com>
 <20200908175703.2463721-1-yhs@fb.com>
 <CAEf4BzZJ5MfLryVjZfp4TLHLmbukTm9k9EUgko1eyPAds+A2pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZJ5MfLryVjZfp4TLHLmbukTm9k9EUgko1eyPAds+A2pw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 04:11:21PM -0700, Andrii Nakryiko wrote:
> On Tue, Sep 8, 2020 at 10:58 AM Yonghong Song <yhs@fb.com> wrote:
> >
> > Change selftest map_ptr_kern.c with disabling inlining for
> > one of subtests, which will fail the test without previous
> > verifier change. Also added to verifier test for both
> > "map_ptr += scalar" and "scalar += map_ptr" arithmetic.
> >
> > Signed-off-by: Yonghong Song <yhs@fb.com>
> > ---
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> >  .../selftests/bpf/progs/map_ptr_kern.c        | 10 +++++-
> >  .../testing/selftests/bpf/verifier/map_ptr.c  | 32 +++++++++++++++++++
> >  2 files changed, 41 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/progs/map_ptr_kern.c b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> > index 982a2d8aa844..0b754106407d 100644
> > --- a/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> > +++ b/tools/testing/selftests/bpf/progs/map_ptr_kern.c
> > @@ -82,6 +82,14 @@ static inline int check_default(struct bpf_map *indirect,
> >         return 1;
> >  }
> >
> > +static __attribute__ ((noinline)) int
> 
> just fyi: there is now __noinline defined in bpf_helpers.h, saving a
> bunch of typing

I fixed it manually while applying.
Thanks everyone.
