Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E84F9D34
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 23:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKLWi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 17:38:26 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39444 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKLWi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 17:38:26 -0500
Received: by mail-lj1-f195.google.com with SMTP id p18so258040ljc.6
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 14:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=29otD4aR3aEWAxaTCSYvPRcjUiBxLg5jZIiTShtx8AY=;
        b=ZzevqphfV1hsT/pdPQxdqEtMcTW7RpulPX5NWB767wlWVJU8wP0cFFXwTEejgB3y18
         BGQef3e2EyGtx8TTI4pm3zcKsGxt5tlftEymnzya2vmJZ4MgaFeglgbixMKQshyCuI8I
         BxecFVHe6JDfZSFdOJuZn4RHcJvhRbKkzkpHuI10iCvXEx5rz8z/wrWmK9i4XpQlQKTu
         vmHYxjRuKTDAPH3d6l5Ixf4jSkZNtLUdA1DE7bdK5zE0mHnhW1xNeXQ7SUXT+GS1W2mc
         C74U3hKWuIrrp3j6Om1THzpI51tY6dB5DXJ6PUmN1ZnqG6MiNgNKAlNiEXjhOaWEBss6
         gWBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=29otD4aR3aEWAxaTCSYvPRcjUiBxLg5jZIiTShtx8AY=;
        b=KF+0ZqTR5hu9SJ8JDaejglrPB/cwAIni7vJWhCx8wDAkK84SPHCGRZvY+a3vnQsOIw
         yZCCx+58Doejvxz4AlLYOtOW3GirW5VP/xM1ccHjhB97gQ7TW8upNnduNCenEFcjSPAU
         NPk1WiLieJ2CyesOqLisDY8BlqsLnTx8q0JVxM3mGHOBxmiTZsvsTr8u8IaALeo1ZiEy
         gWNVGMTi1ditw/kKStDDUr9KsKA+WBeBIZJCtE8Z0ytbU1a2ZIQLWx9u5oC4WGLaaa9S
         MIGn6GGAgosCwLrgd/oPH2VsrxxOYp7fRSuOIrzs8rQMqam2jAgnIy52eDD6A4xXN1vO
         JR0g==
X-Gm-Message-State: APjAAAXbnSN552u8uJxfz/HXHp8xqhuudR5hcOgQI41fLb1sYaVBdBtb
        DZLezcZBY37t7cS1TGITUUeY0Q==
X-Google-Smtp-Source: APXvYqxs6xpz6Uyx+8Ynsibh1nQnWQv6mWzukODKje6LtHgBWlJCFb6B7xSCXeIvLIhIMKClYDWUfw==
X-Received: by 2002:a2e:8809:: with SMTP id x9mr121591ljh.82.1573598304546;
        Tue, 12 Nov 2019 14:38:24 -0800 (PST)
Received: from cakuba ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m28sm30869ljc.96.2019.11.12.14.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 14:38:24 -0800 (PST)
Date:   Tue, 12 Nov 2019 14:38:17 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Rik van Riel <riel@surriel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: add mmap() support for
 BPF_MAP_TYPE_ARRAY
Message-ID: <20191112143817.0c0eb768@cakuba>
In-Reply-To: <CAEf4Bzbx0WvgX9uGF4U1HM41m6kfdvWHCeYBSBRnQhR3egGy5w@mail.gmail.com>
References: <20191109080633.2855561-1-andriin@fb.com>
        <20191109080633.2855561-2-andriin@fb.com>
        <20191111103743.1c3a38a3@cakuba>
        <CAEf4Bzay-sCd5+5Y1+toJuEd6vNh+R7pkosYA7V7wDqTdoDxdw@mail.gmail.com>
        <20191112111750.2168b131@cakuba>
        <CAEf4Bzbx0WvgX9uGF4U1HM41m6kfdvWHCeYBSBRnQhR3egGy5w@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 14:03:50 -0800, Andrii Nakryiko wrote:
> On Tue, Nov 12, 2019 at 11:17 AM Jakub Kicinski wrote:
> > On Mon, 11 Nov 2019 18:06:42 -0800, Andrii Nakryiko wrote:  
> > > So let's say if sizeof(struct bpf_array) is 300, then I'd have to either:
> > >
> > > - somehow make sure that I allocate 4k (for data) + 300 (for struct
> > > bpf_array) in such a way that those 4k of data are 4k-aligned. Is
> > > there any way to do that?
> > > - assuming there isn't, then another way would be to allocate entire
> > > 4k page for struct bpf_array itself, but put it at the end of that
> > > page, so that 4k of data is 4k-aligned. While wasteful, the bigger
> > > problem is that pointer to bpf_array is not a pointer to allocated
> > > memory anymore, so we'd need to remember that and adjust address
> > > before calling vfree().
> > >
> > > Were you suggesting #2 as a solution? Or am I missing some other way to do this?  
> >
> > I am suggesting #2, that's the way to do it in the kernel.  
> 
> So I'm concerned about this approach, because it feels like a bunch of
> unnecessarily wasted memory. While there is no way around doing
> round_up(PAGE_SIZE) for data itself, it certainly is not necessary to
> waste almost entire page for struct bpf_array. And given this is going
> to be used for BPF maps backing global variables, there most probably
> will be at least 3 (.data, .bss, .rodata) per each program, and could
> be more. Also, while on x86_64 page is 4k, on other architectures it
> can be up to 64KB, so this seems wasteful.

With the extra mutex and int you grew struct bpf_map from 192B to 256B,
that's for every map on the system, unconditionally, and array map has
an extra pointer even if it doesn't need it.

Increasing "wasted" space when an opt-in feature is selected doesn't
seem all that terrible to me, especially that the overhead of aligning
up map size to page size is already necessary.

> What's your concern exactly with the way it's implemented in this patch?

Judging by other threads we seem to care about performance of BPF
(rightly so). Doing an extra pointer deref for every static data access
seems like an obvious waste.

But then again, it's just an obvious suggestion, take it or leave it..
