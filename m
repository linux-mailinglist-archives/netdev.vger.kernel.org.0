Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A637275D48
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 18:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgIWQYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 12:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgIWQYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 12:24:40 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E46C0613CE;
        Wed, 23 Sep 2020 09:24:40 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id x20so188067ybs.8;
        Wed, 23 Sep 2020 09:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OXRwJJaCa16IJL4VuqAce1J6KireVXHGr8I47nwF9PQ=;
        b=u4hQMymrCigIfoEBUnTeNGOKfTSKicaFGAcX+HcfHtJOD6qS7L6GQ1G6CBP/BzlGge
         s/lWpmS1DtT531ycrqGx0QTsGd7x1tzMcM9V15aC0ednpEfMef5yCbFCYvte723HOOBW
         vkdf8L28q/uQqwbJ87GVZPZ9q+OpoeRfbgEyy5H9AwW131E2b1I4cjS2mwatMmJUxeL7
         JY4WJtp4b+5DTml6CIzfXbO1nOmCSsmPhUxR+/Wal61tsxRd5GIhj5xhzBSS7JBIXicw
         7t45ioEig0AZ53ZW8UWI3YmYe7TLcZvVUDyjQ8QBnnYIsgNk21k0R1IcWuJDDDo7yq6f
         IU+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OXRwJJaCa16IJL4VuqAce1J6KireVXHGr8I47nwF9PQ=;
        b=UtApz09qF+Lo6qaBTYoY0s5G8bY7HSgk/QJRJOTQCXH/n+pvTPqRgVdaBEY1iDjnUQ
         QBavAVJ+81rCYljVRWLByrHwHZ7+y52c0z+z7rgWfNCpdUnvSh0pJBsLwd2MWNaSiGrH
         2zdPS8Izoxw9tIVF7S5WBnaWRXLWPyybzXiR+vzrLeCKH1IkNViq9DxzHLVKBE4ALvMa
         TEFT0eT2eWFHgtIfPWGU/Zg/hLt3RlowtDwe/dMC9jL0hHYFvIQOOeRz4u/oYUdW7+An
         SSkmZJD+uDsQColCk39GymP7aPUK++2ttBXWp9Dlgl+9YQquBJJPnB1OELXwilvTYCU+
         stKg==
X-Gm-Message-State: AOAM5339rKi8fMppXirxWRHRjKxiwLxQg5YdIS39zp/T6dmTzOwiOjbE
        hazXKAFnQfgFbPutfH7R0I+1J6frHgfTys1q3Ps=
X-Google-Smtp-Source: ABdhPJwhKeiwoW/W3m5engPGOcYf9kmBSebKzC+cmxMTvGlRNaxlV3MEbvCEkeePrOpe5cqdnowrMA8K+ISbe1hS9tQ=
X-Received: by 2002:a25:2687:: with SMTP id m129mr1050560ybm.425.1600878279966;
 Wed, 23 Sep 2020 09:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200916211010.3685-1-maciej.fijalkowski@intel.com>
 <CAADnVQLEYHZLeu-d4nV5Px6t+tVtYEgg8AfPE5-GwAS1uizc0w@mail.gmail.com> <CACAyw994v0BFpnGnboVVRCZt62+xjnWqdNDbSqqJHOD6C-cO0g@mail.gmail.com>
In-Reply-To: <CACAyw994v0BFpnGnboVVRCZt62+xjnWqdNDbSqqJHOD6C-cO0g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Sep 2020 09:24:29 -0700
Message-ID: <CAEf4Bzakz65x0-MGa0ZBF8F=PvT23Sm0rtNDDCo3jo4VMOXgeg@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 0/7] bpf: tailcalls in BPF subprograms
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 9:12 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Fri, 18 Sep 2020 at 04:26, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> [...]
> >
> > Lorenz,
> > if you can test it on cloudflare progs would be awesome.
>
> Our programs all bpf_tail_call from the topmost function, so no calls
> from subprogs. I stripped out our FORCE_INLINE flag, recompiled and
> ran our testsuite. cls_redirect.c (also in the kernel selftests) has a
> test failure that I currently can't explain, but I don't have the time
> to look at it in detail right now.
>

I've already converted test_cls_redirect.c in selftest to have
__noinline variant. And it works fine. There are only 4 helper
functions that can't be converted to a sub-program (pkt_parse_ipv4,
pkt_parse_ipv6, and three buffer manipulation helpers) because they
are accepting a pointer to a stack from a calling function, which
won't work with subprograms. But all the other functions were
trivially converted to __noinline and keep working.

> Hopefully I can get back to this next week.
>
> Best
> Lorenz
>
> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
