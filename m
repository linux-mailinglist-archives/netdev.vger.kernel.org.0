Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF8014E9B4
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 09:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgAaIns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 03:43:48 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37452 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbgAaIns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 03:43:48 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so7622120wru.4;
        Fri, 31 Jan 2020 00:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DcqGyKAvtPPkJuQZbjaeO7NbZl/Jo6mcF1VsF4v5ARU=;
        b=H/xVxMAGPsPyCmZ6lXmBKhopujuJONsH7Ir+DpwOmuUGB5BrAsftBaHYOzXeeLtC33
         831n6cHeRyQxQuIO7z6njBEea/MWtZMdj3uXv9vSpAtfHSFWURuCrB14Ymijck3S6nJX
         l3ZiuyqB96+E75MXUhT7q+poNzlYhsdZOydwUIqWo6UL7uIsfwTelsL1vOmov2ol5Fsp
         vx89rJxMOS6OCMeY6f5pZapN9i6h/ZpGAznb8tO38d+nr96CuI0MfKSEj+Q8Vea652am
         WJyF1+ar9jCli2FXdl+pe3qhuNsbY4lenJvOda3EifsdNiMvvOt4xkjHeLimoTIHW7sF
         lEUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DcqGyKAvtPPkJuQZbjaeO7NbZl/Jo6mcF1VsF4v5ARU=;
        b=h0QAGopWqakbf72KJULnzzRI9cZ+FDqlMYKi2vwz7Ni20OMZ9MJzypA0k7kHHHoS2N
         s9E0brN5HAHKRcTMnZ14kbyvOZ+eDpSfS+/VcIqt4iB+8GjbseSkjvQ5B8gO0kvyLFpM
         CRJYNPwKLLrkc8DfBYSE2rx7aTleDLjbP46vMET78xzb6oxmimpMRu+mWAzQghd0TTXp
         qRuyrQcQUvdPKNBJ1i6B96WVGhahxrEsY+JujiwjdywMY8bZ4GyRdViUbPgnzeYyw9uT
         8TFThUCzbNYxjEWSciaTihbg1KKNNUNoUVFNOCKURtOSKSpQRzDWy+pE3ndT4bwKD435
         OgcQ==
X-Gm-Message-State: APjAAAVtcuiKn7ZZc09H7XoWQc51+57NwE/YbHaPsDu++k9jJ8A4s+D6
        fHNhEEMtCIre48GXSdLkW9EtNWOpfdw=
X-Google-Smtp-Source: APXvYqy0U/xqqHXFTb/9QWAoWsBEHdhyHRZcs1prV15T/CGFgpARF/ycN6LOPQULSVyNOJLgdnIG3Q==
X-Received: by 2002:a05:6000:118d:: with SMTP id g13mr10334756wrx.141.1580460225648;
        Fri, 31 Jan 2020 00:43:45 -0800 (PST)
Received: from quaco.ghostprotocols.net (catv-212-96-54-169.catv.broadband.hu. [212.96.54.169])
        by smtp.gmail.com with ESMTPSA id z25sm9705197wmf.14.2020.01.31.00.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 00:43:44 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 97ACF40A7D; Fri, 31 Jan 2020 09:43:43 +0100 (CET)
Date:   Fri, 31 Jan 2020 09:43:43 +0100
To:     Cengiz Can <cengiz@kernel.wtf>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] tools: perf: add missing unlock to maps__insert error
 case
Message-ID: <20200131084343.GI3841@kernel.org>
References: <20200120141553.23934-1-cengiz@kernel.wtf>
 <20200131083858.GH3841@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131083858.GH3841@kernel.org>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Jan 31, 2020 at 09:38:58AM +0100, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Jan 20, 2020 at 05:15:54PM +0300, Cengiz Can escreveu:
> > Please tell me if the `__maps__free_maps_by_name` frees the
> > `rw_semaphore`. If that's the case, should we change the order to unlock and free?
> 
> No it doesn't free the rw_semaphore, that is in 'struct maps', what is
> being freed is just something protected by rw_semaphore,
> maps->maps_by_name, so your patch is right and I'm applying it, thanks.

BTW, you forgot to add:

Fixes: a7c2b572e217 ("perf map_groups: Auto sort maps by name, if needed")

Which I did, and next time please CC the perf tools reviewers, as noted
in MAINTAINERS, the lines starting with R:.

- Arnaldo

[acme@quaco perf]$ grep -A21 "PERFORMANCE EVENTS SUBSYSTEM$" MAINTAINERS
PERFORMANCE EVENTS SUBSYSTEM
M:	Peter Zijlstra <peterz@infradead.org>
M:	Ingo Molnar <mingo@redhat.com>
M:	Arnaldo Carvalho de Melo <acme@kernel.org>
R:	Mark Rutland <mark.rutland@arm.com>
R:	Alexander Shishkin <alexander.shishkin@linux.intel.com>
R:	Jiri Olsa <jolsa@redhat.com>
R:	Namhyung Kim <namhyung@kernel.org>
L:	linux-kernel@vger.kernel.org
T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
S:	Supported
F:	kernel/events/*
F:	include/linux/perf_event.h
F:	include/uapi/linux/perf_event.h
F:	arch/*/kernel/perf_event*.c
F:	arch/*/kernel/*/perf_event*.c
F:	arch/*/kernel/*/*/perf_event*.c
F:	arch/*/include/asm/perf_event.h
F:	arch/*/kernel/perf_callchain.c
F:	arch/*/events/*
F:	arch/*/events/*/*
F:	tools/perf/
[acme@quaco perf]$
