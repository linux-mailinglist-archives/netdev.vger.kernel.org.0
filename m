Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3A63D3366
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 06:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhGWDXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 23:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234898AbhGWDXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 23:23:45 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47FCC028C34
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 21:01:54 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id a201so292960ybg.12
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 21:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HGO3KZZ5XuMMsTAAKBPHPvKOlQpDVKA1UVlvmwLS+6o=;
        b=HLadaPqURKUbE7Vj61tejUIaVb7ONB/jkUOhD7lSEW7vW3NRuJb+9lordmCIV5b1eP
         DhzExsSFvo8uRHt5dpqvSHBtd0YX7v1JLS/CfUfftDPMjFyVLazHNde3dWs0PKaxToIS
         QlAeWOP2Vw3cMqx9Vd3976SXBSvilB5een/G6XU7oySahTVUuZqpEgIbgZ18yVQgjf9U
         +7pz30t0j9Q1ZYPY8A2srtDLBIDsn3nLLSxl81U4HV/+CepvkYCAYIXI/IAhXnauuqsd
         YlBcAIXvslm1OnjqSM+N4muP2M5nfVrCUeaAHsZLKqptr/+dRxUc2wtj4nd0SWpQw604
         TNKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HGO3KZZ5XuMMsTAAKBPHPvKOlQpDVKA1UVlvmwLS+6o=;
        b=Su86BC0HnjI9gVj5cwBYRSoc4SVjXcLub//X5FctBGVYvUDKY+JtbyJQPNd5ZIi+PF
         KJ4ZdMSpYumauB33g3rfokJ412ETN+ka8uAr5ZA7uVcMP/w92Q9kHwBUUDgKVsEZSY6b
         VO+94bJp3aaHS7a/DrQnQhRZWMDZodtY0g0V8bDSckAZUxAERGRMMHJzoYNVKlvqdTq8
         opugdRbJFkZ1Z4TxoU1dy+dbfNVoRL0NvYeaNcDclF8hVEBxEqmKt9C4YxfEIonEM13S
         mRGEgM16fmWTWKZSEnPZDZXh69gwwDag/6W2Wyt/CXTlzBfV0hGSXkSKai3aRYOJtplq
         gUKA==
X-Gm-Message-State: AOAM533wlEfnqMF73qkPvc4w9c4XidH89PUWoNAnhUjYnaK//JP7b40e
        vyAGntAGVakmWcb+69qJ9UK8qNDvBGkiUWdBKNo=
X-Google-Smtp-Source: ABdhPJz2S+eCAPVNuKA9PBGb13yq8lnCHqbcCASXVKIc2rJ+33NJZ9G67SPcaE1E4WyZ50f99P+h8aDScfQMJBQ1rdg=
X-Received: by 2002:a25:9942:: with SMTP id n2mr3952777ybo.230.1627012913956;
 Thu, 22 Jul 2021 21:01:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210705124307.201303-1-m@lambda.lt> <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
 <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt> <4f1b5aaa-80e0-5dcc-277e-c098811cc359@gmail.com>
 <a68f1e05-e9c7-595e-23e9-6f02a3a209de@lambda.lt>
In-Reply-To: <a68f1e05-e9c7-595e-23e9-6f02a3a209de@lambda.lt>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Jul 2021 21:01:43 -0700
Message-ID: <CAEf4BzZCKHTA4o4ShmT_-THuT_mb7nwSkzG9OjeYVLPSzq4gmQ@mail.gmail.com>
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple sections
To:     Martynas Pumputis <m@lambda.lt>
Cc:     David Ahern <dsahern@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 8:25 AM Martynas Pumputis <m@lambda.lt> wrote:
>
>
>
> On 7/21/21 4:59 PM, David Ahern wrote:
> > On 7/21/21 8:47 AM, Martynas Pumputis wrote:
> >>>> diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
> >>>> index d05737a4..f76b90d2 100644
> >>>> --- a/lib/bpf_libbpf.c
> >>>> +++ b/lib/bpf_libbpf.c
> >>>> @@ -267,10 +267,12 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
> >>>>           }
> >>>>
> >>>>           bpf_object__for_each_program(p, obj) {
> >>>> +               bool prog_to_attach = !prog && cfg->section &&
> >>>> +                       !strcmp(get_bpf_program__section_name(p),
> >>>> cfg->section);
> >>>
> >>> This is still problematic, because one section can have multiple BPF
> >>> programs. I.e., it's possible two define two or more XDP BPF programs
> >>> all with SEC("xdp") and libbpf works just fine with that. I suggest
> >>> moving users to specify the program name (i.e., C function name
> >>> representing the BPF program). All the xdp_mycustom_suffix namings are
> >>> a hack and will be rejected by libbpf 1.0, so it would be great to get
> >>> a head start on fixing this early on.
> >>
> >> Thanks for bringing this up. Currently, there is no way to specify a
> >> function name with "tc exec bpf" (only a section name via the "sec"
> >> arg). So probably, we should just add another arg to specify the
> >> function name.
> >>
> >> It would be interesting to hear thoughts from iproute2 maintainers
> >> before fixing this.
> >
> > maintaining backwards compatibility is a core principle for iproute2. If
> > we know of a libbpf change is going to cause a breakage then it is best
> > to fix it before any iproute2 release is affected.
> >
>
> Just to avoid any confusion (if there is any), the required change we
> are discussing doesn't have anything to do with my fix.
>
> To set the context, the motivation for unifying section names is
> documented and discussed in "Stricter and more uniform BPF program
> section name (SEC()) handling" of [1].
>
> Andrii: is bpftool able to load programs with multiple sections which
> are named the same today?
>

I'm not familiar with those parts of bpftool, I've never used
bpftool's command to load BPF programs. Please go check the code.

>
> [1]:
> https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an11_iaRuec6U-ZESZ54nNTY/edit#
