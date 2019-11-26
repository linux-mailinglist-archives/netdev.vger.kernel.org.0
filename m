Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855A010A412
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 19:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfKZSfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 13:35:01 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37384 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfKZSfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 13:35:00 -0500
Received: by mail-qt1-f194.google.com with SMTP id w47so18385786qtk.4;
        Tue, 26 Nov 2019 10:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=do9rL/IVeEYg2QaHPqxB1Cxl9K/tcvEdG0Fqb61N9Vg=;
        b=LHmQ2DtLWzxQ1V0C1XZsrmf32WOYvUhwr6LlW5xgDpJaBY633wUPVnNDZwh8/GvRB/
         xAVqRXyrVxxvpcdbicmXOrBabgX0G7THUMT5eXzNbGk+UDRT5zNy4MXKXW2Nz/aaN2Rj
         j7qew7n/txrimuwhGpO9YdfeZtC4IVy+QHdPMah86TymfG4qE36jpUuZQDeg8+r3OkzA
         wTVMqFPBUKBTU4kChFe+pcIHtUgjcQPVcsAM5JFWc7WKL+TJQGzJBsWflxxcsbHh5jmY
         ESdY/CLaXfuG9CLoTd2o/M83mGfZcOtfEQUNWoxaJudT2TpGt8DrQphwjliQCuL5NOi7
         GiAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=do9rL/IVeEYg2QaHPqxB1Cxl9K/tcvEdG0Fqb61N9Vg=;
        b=o1j5QihAQ4W4jp2zYjno5e4cTR6jGf5GxnNSc3Qe8OR5irTqU/r1U1/wUKnKBkCA3r
         wvrn+2qXn/43/05X7aCATRrbPYIwuvOy+5h0u4U8XW3gKBwgysdd5kJNqt7/GG+bPMyF
         ZuhQKDAHwuqY0uVdPmMTS0K9HHEdKlMxhgC0CXffOqXoednpDqHtp7BQHXdnsSeUOCRh
         HVa81OxsplNUbUOMoCHKP4qEXlVu39BFc+wwRslywbvGxjqUWwP6NUbPvES8Wcz2+SuA
         oADZJgL9DoTgNzVstE22/jVScohyMFdztKgBc1RqpKWPvbyVQSV8l5TS3hUeV/xmtOmY
         cWiA==
X-Gm-Message-State: APjAAAX4nwuM8Q/dwrmEGM8f292wkzpS9cNE1NFbSW5NYMNVYXylnfFW
        OBwW6BdOGsW/wmlrfoCpIgc=
X-Google-Smtp-Source: APXvYqzfQGuWgWB6BCh/K9SUfZiW03do966f2pNjYOzvGBGtsf48Fq2o+FR/Ex/l7SeTCfU1zLr17g==
X-Received: by 2002:ac8:5418:: with SMTP id b24mr23549659qtq.226.1574793298174;
        Tue, 26 Nov 2019 10:34:58 -0800 (PST)
Received: from quaco.ghostprotocols.net (179-240-181-120.3g.claro.net.br. [179.240.181.120])
        by smtp.gmail.com with ESMTPSA id y131sm1003034qkb.29.2019.11.26.10.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 10:34:57 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 813F440D3E; Tue, 26 Nov 2019 15:34:51 -0300 (-03)
Date:   Tue, 26 Nov 2019 15:34:51 -0300
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
Message-ID: <20191126183451.GC29071@kernel.org>
References: <20191126151045.GB19483@kernel.org>
 <20191126154836.GC19483@kernel.org>
 <87imn6y4n9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87imn6y4n9.fsf@toke.dk>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Nov 26, 2019 at 05:38:18PM +0100, Toke Høiland-Jørgensen escreveu:
> Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> writes:
> 
> > Em Tue, Nov 26, 2019 at 12:10:45PM -0300, Arnaldo Carvalho de Melo escreveu:
> >> Hi guys,
> >> 
> >>    While merging perf/core with mainline I found the problem below for
> >> which I'm adding this patch to my perf/core branch, that soon will go
> >> Ingo's way, etc. Please let me know if you think this should be handled
> >> some other way,
> >
> > This is still not enough, fails building in a container where all we
> > have is the tarball contents, will try to fix later.
> 
> Wouldn't the right thing to do not be to just run the script, and then
> put the generated bpf_helper_defs.h into the tarball?

I would rather continue just running tar and have the build process
in-tree or outside be the same.

- Arnaldo
