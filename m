Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7552010B5EC
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 19:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfK0SoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 13:44:07 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38004 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfK0SoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 13:44:07 -0500
Received: by mail-qt1-f196.google.com with SMTP id 14so26384272qtf.5;
        Wed, 27 Nov 2019 10:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vLYRgEqQraqD/jRbKwCGJCTuqQIUu2eT37zrYdLloVI=;
        b=nJ+P4iz7K1/DdSVU64e3WR10Y5BWSkScNTlF35QpsGFfzfe2LkwADm77GfF23oEAzX
         ChXEdSxrkcPbEpZV0UtPYDPo17JK5jbcSgWwGOWN/Ql12Mfia2zKvweOig/ilUui4++G
         I9liubb+CgMfS5/zYVGGOGcBfDXx0MH8gqMnHIFGf304dcSD1MfcKFJFhY0iHOOTuamM
         6PNP8l6nvSddiDmN0DRTYgTsEoeJJuDMSng3qASLI+1pyxGc/f4LVssZgxIdMaOLFnMV
         d9k1w+FifS7kDQJLf1IzBit0oURjWCMzV62pG93cMWI3g0TE+751jHOj/t9YeSrBtNMr
         NY3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vLYRgEqQraqD/jRbKwCGJCTuqQIUu2eT37zrYdLloVI=;
        b=AAoim3ojxicW/WoXT2o+B8vJaryV3OUXY/dioj5ITru0Q+uup/W7EuEemE8UwntsiT
         S/spAXZfCgoneqymmvoxHzHoVQ4V3zne7VhsxAM8nvJSKxwICXMonfoTxE+MZhHLg0Xp
         zP94iur9J8URfBBox7NoSzTlBwEyvd6re68RpRuJL6ADZ29IgtPJN+jpLHrDfCje0Bhn
         rh8N0xNWllNPsPfd7rGGDQxJZQKO2scPCF6po9LcatV0dM3js0LspHeaTv6mY18hwkJF
         G4CWViiVZznNfjayOuj1/o3GnsSa2AgLeaMyBJYIzj0AqmdGXXHkvvjMoNEo7X1L5kiD
         ifAg==
X-Gm-Message-State: APjAAAXTNwn77uA3c3/ox2ifUHF9vxkZLXpWhfnrDdO1sE6+IkGiuu1A
        1xlnHVDbEzomo3hxa470GDi7n2JitId3zA==
X-Google-Smtp-Source: APXvYqza+dZLDafmoYQJI1Bsn0z4hENX6OJOQ4Ofq+mRxeXSofLRpVnd2slRTjKLtZLI2mYQQ66nAQ==
X-Received: by 2002:ac8:2a65:: with SMTP id l34mr8257242qtl.105.1574880246225;
        Wed, 27 Nov 2019 10:44:06 -0800 (PST)
Received: from quaco.ghostprotocols.net ([190.15.121.82])
        by smtp.gmail.com with ESMTPSA id x1sm7924206qtf.81.2019.11.27.10.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 10:44:06 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id EDCAC40D3E; Wed, 27 Nov 2019 15:44:00 -0300 (-03)
Date:   Wed, 27 Nov 2019 15:44:00 -0300
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH 0/3] perf/bpftool: Allow to link libbpf dynamically
Message-ID: <20191127184400.GA4063@kernel.org>
References: <20191127094837.4045-1-jolsa@kernel.org>
 <CAADnVQLp2VTi9JhtfkLOR9Y1ipNFObOGH9DQe5zbKxz77juhqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLp2VTi9JhtfkLOR9Y1ipNFObOGH9DQe5zbKxz77juhqA@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Nov 27, 2019 at 08:37:59AM -0800, Alexei Starovoitov escreveu:
> On Wed, Nov 27, 2019 at 1:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > adding support to link bpftool with libbpf dynamically,
> > and config change for perf.

> > It's now possible to use:
> >   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1

> > which will detect libbpf devel package with needed version,
> > and if found, link it with bpftool.

> > It's possible to use arbitrary installed libbpf:
> >   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/libbpf/

> > I based this change on top of Arnaldo's perf/core, because
> > it contains libbpf feature detection code as dependency.
> > It's now also synced with latest bpf-next, so Toke's change
> > applies correctly.
 
> I don't like it.
> Especially Toke's patch to expose netlink as public and stable libbpf api.
> bpftools needs to stay tightly coupled with libbpf (and statically
> linked for that reason).
> Otherwise libbpf will grow a ton of public api that would have to be stable
> and will quickly become a burden.

I can relate to that, tools/lib/perf/ is only now getting put in place
because of these fears, hopefully the evsel/evlist/cpumap/etc
abstractions there have been in use for a long time and will be not be a
burden... :-)

- Arnaldo
