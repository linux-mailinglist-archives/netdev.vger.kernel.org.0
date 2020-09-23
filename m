Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCC4275DB6
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 18:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgIWQnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 12:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWQnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 12:43:49 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BE6C0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 09:43:49 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id m7so572992oie.0
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 09:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kQxvaYNxyzuBe/2zrjgv7SCCpseqSt392kijnThrMG4=;
        b=BukdKgyckTaLJeKaLMkfTNxO+n6aKCPT/+EcFqVYWIYDNQ7cxeyWyeJOmXJ1qjWJbn
         vvoGIfqh/tCxwbcL51xliB7SZFgJYztXtRk4ONdjIbvUSDPjU6j6DPA+9JcZvZZ+Nd5+
         ffN0LfJmetXKZdR9MkvA+Gy7szk720bAhK+ZU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kQxvaYNxyzuBe/2zrjgv7SCCpseqSt392kijnThrMG4=;
        b=PIxL15VI46J6Hn8pcmf+rglW/UCXdY8AjewJDJbSSMMM1sly89HOtdcpIN3D8hqpVd
         WfvJIxnyfGWDX6aq9FlDRR499kX4N/BWPoKNNDUvFOeul6vfBaYzGTyO3AKrMwyzn6ci
         y33dM6W/UZiko//pK2n0N4/5a1cArDfRX5su68wsOTcph1lzvFD1sXSid+e8qtr3iU7A
         foBXKt81fKYIPH9shU0fFvT2BSPnXkxOxfTWO+Vx8AxcsZJCfyV1TiIfntX/L1bRZ3k4
         XOSToeiYWf9OSWLMCTHqBY029t1siADI071Zbnp7MBaOYPJr7ZVIltr5iD9Mq6Iy3Y9g
         ekhg==
X-Gm-Message-State: AOAM533xYu/7ePDy1x2tD5exieKDOaz+fSqvZ2UpNsMgd9MLT+A0pjMZ
        a2m4hP+hHr5gj8UQFpIF+MLMWHmK/F8HPR+c1eZhSlDFur8=
X-Google-Smtp-Source: ABdhPJxdpk2KpdkM4paPqdaSvoAA1gvtlKUOqKTQHivN4CmeCo2EmHl1d3xJkiCr86N0UeGKBhhmNlLPf56YXnFS3+0=
X-Received: by 2002:aca:f0a:: with SMTP id 10mr233833oip.13.1600879428464;
 Wed, 23 Sep 2020 09:43:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200916211010.3685-1-maciej.fijalkowski@intel.com>
 <CAADnVQLEYHZLeu-d4nV5Px6t+tVtYEgg8AfPE5-GwAS1uizc0w@mail.gmail.com>
 <CACAyw994v0BFpnGnboVVRCZt62+xjnWqdNDbSqqJHOD6C-cO0g@mail.gmail.com> <CAEf4Bzakz65x0-MGa0ZBF8F=PvT23Sm0rtNDDCo3jo4VMOXgeg@mail.gmail.com>
In-Reply-To: <CAEf4Bzakz65x0-MGa0ZBF8F=PvT23Sm0rtNDDCo3jo4VMOXgeg@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 23 Sep 2020 17:43:37 +0100
Message-ID: <CACAyw9_WkndmJiwBZTn+P8fQa6OFfxmxH7uCxi0RTNOonbCzww@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 0/7] bpf: tailcalls in BPF subprograms
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Wed, 23 Sep 2020 at 17:24, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Sep 23, 2020 at 9:12 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Fri, 18 Sep 2020 at 04:26, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > [...]
> > >
> > > Lorenz,
> > > if you can test it on cloudflare progs would be awesome.
> >
> > Our programs all bpf_tail_call from the topmost function, so no calls
> > from subprogs. I stripped out our FORCE_INLINE flag, recompiled and
> > ran our testsuite. cls_redirect.c (also in the kernel selftests) has a
> > test failure that I currently can't explain, but I don't have the time
> > to look at it in detail right now.
> >
>
> I've already converted test_cls_redirect.c in selftest to have
> __noinline variant. And it works fine. There are only 4 helper
> functions that can't be converted to a sub-program (pkt_parse_ipv4,
> pkt_parse_ipv6, and three buffer manipulation helpers) because they
> are accepting a pointer to a stack from a calling function, which
> won't work with subprograms. But all the other functions were
> trivially converted to __noinline and keep working.

Yeah, that is very possible. Keep in mind though that our internal
version has since become more complex, and also has a more
comprehensive test suite. I wasn't sounding the alarms, it's just an
FYI that I appreciate the work that went into this and have taken a
look, but that I need to do some more digging :)

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
