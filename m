Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F3D1776A3
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 14:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgCCNGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 08:06:33 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33066 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbgCCNGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 08:06:33 -0500
Received: by mail-qt1-f193.google.com with SMTP id d22so1342407qtn.0;
        Tue, 03 Mar 2020 05:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5qtkGUAKyjubxoGCBuIb+d1TqkEissSGWcA4/L90vak=;
        b=jGwukuuyw2BJzDh3eUvHzsAS+MoG3rLt/q2jfga5Xo1oF3ZJU6PVAfTOnumzmV3vnn
         Cks+siixxzUAAfNrj30dS6Uw1GPOuJDmClS+Ibezv6gea90tld+ThX04jGyxxc3aVMwo
         h9EI8KqMmvei8Reqsp9/beW7nTGqaerRq6JW5r0CIMI9+K0ct0UqEus5zq//ntDi32PH
         2IfwbExWLEtfwcIK9eghhmWO8qg4ClcP8jx567DAd3PHNTgm29UKOUWwuUoIeorVvUXg
         OOWPLmElN3qyygxJUjCsz2zGAqD7lXw9gBE9gFrIGC6QCB3uZV4DhnGc6nQ+SW7jwT9v
         au7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5qtkGUAKyjubxoGCBuIb+d1TqkEissSGWcA4/L90vak=;
        b=eqSO0FbDZNYrDtpWtSHnrT2GcmGuFanEbPfOJLV6LEF0oL0KfDPm+rwGzmOSuElGfl
         GHU3bR2d93iJ+a390Hg8SnVisaWNgpuJrAo84fvnyhvoiA1MxPn/zwlfFX6dt3mc9icb
         /7AikAntfNaYbIrRkdbCKngwriP0nPfaSjNPrDS7ikUDicgqeZOAUEb5mIE4U91dm4w+
         qScFNOnYDIXXihNvD3f/5AK8x0KlgEgTS2Zr0saojqESUSk+rgPgPsaPsHfMtDTDNv9M
         i73yP5ZW8nS7uWWh82OD9okcelvn/wNDz1qzEqzxaixK6u9tNGWza8hIO8B4WXFtW7X+
         YzNw==
X-Gm-Message-State: ANhLgQ34+mXZH0MaSv6pUMDQ02VYkhN8IDjAKU4GbyboqlF5rvuGWE81
        6vrT3EL+LTrPbetg3UQVFExVDpNtjdk=
X-Google-Smtp-Source: ADFU+vuNBnyaMlnUy9gO9hs6c/Y6hWRH5Ibz7Ixg4w6/ZL9cGhSM7AH/pRjE913rKwBgn5D/c3HWWA==
X-Received: by 2002:aed:38c2:: with SMTP id k60mr4151566qte.103.1583240792222;
        Tue, 03 Mar 2020 05:06:32 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id l2sm5470950qtq.16.2020.03.03.05.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 05:06:31 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 1DCEB403AD; Tue,  3 Mar 2020 10:06:29 -0300 (-03)
Date:   Tue, 3 Mar 2020 10:06:29 -0300
To:     Song Liu <songliubraving@fb.com>
Cc:     Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 bpf-next 1/2] bpftool: introduce "prog profile" command
Message-ID: <20200303130629.GA13702@kernel.org>
References: <20200228234058.634044-1-songliubraving@fb.com>
 <20200228234058.634044-2-songliubraving@fb.com>
 <367483bd-87ff-02f4-71f6-c2694579dda4@fb.com>
 <67921C65-D391-47C9-9582-C9D6060161A1@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67921C65-D391-47C9-9582-C9D6060161A1@fb.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Mar 03, 2020 at 12:10:50AM +0000, Song Liu escreveu:
> > On Mar 1, 2020, at 8:24 PM, Yonghong Song <yhs@fb.com> wrote:
> >> +	},
> >> +	{
> >> +		.name = "instructions",
> >> +		.attr = {
> >> +			.freq = 0,
> >> +			.sample_period = SAMPLE_PERIOD,
> >> +			.inherit = 0,
> >> +			.type = PERF_TYPE_HARDWARE,
> >> +			.read_format = 0,
> >> +			.sample_type = 0,
> >> +			.config = PERF_COUNT_HW_INSTRUCTIONS,
> >> +		},
> >> +		.ratio_metric = 1,
> >> +		.ratio_mul = 1.0,
> >> +		.ratio_desc = "insn per cycle",
> >> +	},
> >> +	{
> >> +		.name = "l1d_loads",
> >> +		.attr = {
> >> +			.freq = 0,
> >> +			.sample_period = SAMPLE_PERIOD,
> >> +			.inherit = 0,
> >> +			.type = PERF_TYPE_HW_CACHE,
> >> +			.read_format = 0,
> >> +			.sample_type = 0,
> >> +			.config =
> >> +				PERF_COUNT_HW_CACHE_L1D |
> >> +				(PERF_COUNT_HW_CACHE_OP_READ << 8) |
> >> +				(PERF_COUNT_HW_CACHE_RESULT_ACCESS << 16),
> >> +		},
> > 
> > why we do not have metric here?
> 
> This follows perf-stat design: some events have another event to compare 
> against, like instructions per cycle, etc. 
> 
> > 
> >> +	},
> >> +	{
> >> +		.name = "llc_misses",
> >> +		.attr = {
> >> +			.freq = 0,
> >> +			.sample_period = SAMPLE_PERIOD,
> >> +			.inherit = 0,
> >> +			.type = PERF_TYPE_HW_CACHE,
> >> +			.read_format = 0,
> >> +			.sample_type = 0,
> >> +			.config =
> >> +				PERF_COUNT_HW_CACHE_LL |
> >> +				(PERF_COUNT_HW_CACHE_OP_READ << 8) |
> >> +				(PERF_COUNT_HW_CACHE_RESULT_MISS << 16),
> >> +		},
> >> +		.ratio_metric = 2,
> >> +		.ratio_mul = 1e6,
> >> +		.ratio_desc = "LLC misses per million isns",
> >> +	},
> >> +};

> > icache miss and itlb miss might be useful as well as the code will jump
> > to a different physical page. I think we should addd them. dtlb_miss
> > probably not a big problem, but it would be good to be an option.

> I plan to add more events later on. 

> > For ratio_metric, we explicitly assign a slot here. Any specific reason?
> > We can just say this metric *permits* ratio_metric and then ratio_matric
> > is assigned dynamically by the user command line options?

> > I am thinking how we could support *all* metrics the underlying system
> > support based on `perf list`. This can be the future work though.
 
> We are also thinking about adding similar functionality to perf-stat, 
> which will be more flexible. 

Yeah, being able to count events bpf programs using the technique you're
using here but instead using 'perf stat' to set it up and then use what
is already in 'perf stat' would be really great, having the same
interface for BPF programs as we have for tid, pid, cgroups, system
wide, etc.

If you try it and find any problems with the codebase I'll be happy to
help as I think others working with 'perf stat' will too,

Cheers,

- Arnaldo
