Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D98B394EB6
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 02:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhE3Asn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 20:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhE3Asn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 20:48:43 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11418C061574;
        Sat, 29 May 2021 17:47:06 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id f84so11184162ybg.0;
        Sat, 29 May 2021 17:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wHVx+VBhplvwzx2toCSsFH2zHsatsW41FO7wcaTFWzA=;
        b=gJN7A3ulotTcEQc2Wa/lHhxAVfgLkvK3/aFtXAZrmwQauqXYPLfU49tN9cKmqp3Cgt
         y/MIgJ9krRME6CKdOFngV5d9Mk6yQK1DO59Bu8sMbAmQTiylPNbeIredhPLhb/zYceYR
         6SGIW5ciEZK5Zwriyetu0FvabLdtod8DO55qHoG1Rrbk9n4aqszLigI1tXnNZ7ONOIrL
         py97cqhYGjAKzpM1jxANBb1CxlhV8MpaR107zMeWICa7f4t6bh35fi5QfWlHiO1lLUq6
         vyYPMkbOW4JIkqwRc0TAQCAdIlbKvKEfz3eISBrM4Lmbnm2uVJkvt0u60sU9ejPapkH2
         mpNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wHVx+VBhplvwzx2toCSsFH2zHsatsW41FO7wcaTFWzA=;
        b=tSIBDNzADAqNtcqvdF6Q23gAA+5sjm1PIDp1YQVlXm6gJbHvhtuSe2HzxC6RSIJSZM
         GUkJC8oMFUZBd0+5oT6Td4luQQkK8S94GP5e/ddLlfJ57U0bcy57NX4ZXrSMI93o5kAV
         1z3sc3LFgIqb9VnS0v5U8rLR1cOvlJZoDyoUXhulIMxdl+rhNu+lK7Wsfbzs+qOMUUGT
         XgR66fGjQfO+knHCxR2Cp/iXfNJTJ4S5YEzwqBy9anNcj/uw3k6Fz/ZzSKYtFjwODQdJ
         /DNDr4mWDNk6A6n0lTwM99UUEq4LWXs8JWe7a/FWbFe+2FkJSk0pSn9c4XB1JOntVV7o
         uXgg==
X-Gm-Message-State: AOAM5321eFdan4m4mTocTYfrQCaN39KLKKZ+IVqIsfxDy70AXbFf4Ax9
        w9BpgXXKjbHhdnWuCJaxWroNzOI2RVWkx6n1uCtHeRqK
X-Google-Smtp-Source: ABdhPJyVCSvo7YuE7iTDPdR6ItpzciTvgUe4BzC9/eZuXPloN32lpJW0F6uHoswRlFR4/UW802WB0tRxgMNNbLbqd5g=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr20800026ybg.459.1622335625288;
 Sat, 29 May 2021 17:47:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210526080741.GW30378@techsingularity.net> <YK9SiLX1E1KAZORb@infradead.org>
 <20210527090422.GA30378@techsingularity.net> <YK9j3YeMTZ+0I8NA@infradead.org>
 <CAEf4BzZLy0s+t+Nj9QgUNM66Ma6HN=VkS+ocgT5h9UwanxHaZQ@mail.gmail.com>
 <CAEf4BzbzPK-3cyLFM8QKE5-o_dL7=UCcvRF+rEqyUcHhyY+FJg@mail.gmail.com> <8fe547e9e87f40aebce82021d76a2d08@AcuMS.aculab.com>
In-Reply-To: <8fe547e9e87f40aebce82021d76a2d08@AcuMS.aculab.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 29 May 2021 17:46:54 -0700
Message-ID: <CAEf4Bza_yDe7=0jNuPcFnJOTiHPTWD43cHyQqqa10i228P_OVw@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
To:     David Laight <David.Laight@aculab.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>, bpf <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 1:09 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Andrii Nakryiko
> > Sent: 27 May 2021 15:42
> ...
> > I agree that empty structs are useful, but here we are talking about
> > per-CPU variables only, which is the first use case so far, as far as
> > I can see. If we had pahole 1.22 released and widely packaged it could
> > have been a viable option to force it on everyone.
> ...
>
> Would it be feasible to put the sources for pahole into the
> kernel repository and build it at the same time as objtool?
>
> That would remove any issues about the latest version
> not being available.

That would be great for the kernel build, but pahole is more than just
a DWARF-to-BTF converter and it has a substantial amount of logic for
loading and processing DWARF before it gets converted to BTF. All
BTF-related pieces are provided by libbpf, which is already part of
kernel sources, so that's not a problem. DWARF processing is a problem
and would add a new dependency on libdw-devel, at least.

>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
