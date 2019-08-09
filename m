Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B72C88547
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 23:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbfHIVsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 17:48:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46515 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfHIVsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 17:48:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id c3so23579195pfa.13
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 14:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=al+szINUTqm7wZFEaVwhjdTr/VBQonILnIP5BOs/67Y=;
        b=qqi/kCnQcwg3rpYJCoDJ9q829zHHzfL5L2GwoKAVs9VTrEnwELnt7j9ZmyxJxYFUdl
         u37x7cXgIZNUg/JmZ5yEcz2EmX2FQbltLYxwEbL43BgO+ufcUf4F4AZJMM84YjhjXyHw
         fqQ+3IReqh6HSvgi/rb4PWqCQunT7jWbkwKtH3Waj0aEP8ln//Xig2f0rp7XMLj9FbHr
         nmY002NZMklnWcKF3hvo+6Qtb2NTAuopLj6n6pqZ92aYmQEkLuO5sNndijtxBAYg5UCp
         GshGmGxUZIiynag4eXHIghulskWfPeRCSr7IGohfFhkz8gNZR0z12eGVrcNPhEfHHQtG
         +Eqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=al+szINUTqm7wZFEaVwhjdTr/VBQonILnIP5BOs/67Y=;
        b=V9oe7przd5ZYoZYze9jFDTvWPKpP+2ze+HP89IyEcygt+ebVf/srAXrj3C6BqKtRy9
         IN6JMi7F6jNqzjAi4BACDHaCyGgBujfgFXgFczgjXsn9H5qrSKDxYE0XbGrF2EhI4Tqv
         doK9eSt9hvBvXxkIK6fbnOZFaHAz1U+RAfRhateG9hafOKA9HMl9M80lgKR0JaJjkygl
         C7OnaqV8lu3U8lR7hDr9YRB4J00b/l6/xDbvUm/ksIyjtdawsDwm40OQZbGM5fRInwr+
         aLSCmQFLYYS5Hpa40ArPMn3MhiNq0PmKJPe+gW6cFCXXBazN47sidb9fp5r4KNHlVtU0
         XDaQ==
X-Gm-Message-State: APjAAAV6rpt82WGNjNWi+gMaL4oV6rLd+RMQopo8AJz7soHM6IsJFro7
        dlD/RdFg2hR+OaAAloWuhVXVq9V/wvM=
X-Google-Smtp-Source: APXvYqwikoSmToBI8bgL3ZJmkxkAvDJ6rGoi7EE6kES5g5FfaxyWNfW0J38sg7UaNACjNfhn1u/8Iw==
X-Received: by 2002:a17:90a:a407:: with SMTP id y7mr11494086pjp.97.1565387320958;
        Fri, 09 Aug 2019 14:48:40 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id i123sm135353675pfe.147.2019.08.09.14.48.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 14:48:33 -0700 (PDT)
Date:   Fri, 9 Aug 2019 14:48:31 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Peter Wu <peter@lekensteyn.nl>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH v3] tools: bpftool: fix reading from /proc/config.gz
Message-ID: <20190809214831.GE2820@mini-arch>
References: <20190809003911.7852-1-peter@lekensteyn.nl>
 <20190809153210.GD2820@mini-arch>
 <20190809140956.24369b00@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809140956.24369b00@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/09, Jakub Kicinski wrote:
> On Fri, 9 Aug 2019 08:32:10 -0700, Stanislav Fomichev wrote:
> > On 08/09, Peter Wu wrote:
> > > /proc/config has never existed as far as I can see, but /proc/config.gz
> > > is present on Arch Linux. Add support for decompressing config.gz using
> > > zlib which is a mandatory dependency of libelf. Replace existing stdio
> > > functions with gzFile operations since the latter transparently handles
> > > uncompressed and gzip-compressed files.
> > > 
> > > Cc: Quentin Monnet <quentin.monnet@netronome.com>
> > > Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> 
> Thanks for the patch, looks good to me now!
> 
> > >  tools/bpf/bpftool/Makefile  |   2 +-
> > >  tools/bpf/bpftool/feature.c | 105 ++++++++++++++++++------------------
> > >  2 files changed, 54 insertions(+), 53 deletions(-)
> > > 
> > > diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> > > index a7afea4dec47..078bd0dcfba5 100644
> > > --- a/tools/bpf/bpftool/Makefile
> > > +++ b/tools/bpf/bpftool/Makefile
> > > @@ -52,7 +52,7 @@ ifneq ($(EXTRA_LDFLAGS),)
> > >  LDFLAGS += $(EXTRA_LDFLAGS)
> > >  endif
> > >  
> > > -LIBS = -lelf $(LIBBPF)
> > > +LIBS = -lelf -lz $(LIBBPF)  
> > You're saying in the commit description that bpftool already links
> > against -lz (via -lelf), but then explicitly add -lz here, why?
> 
> It probably won't hurt to enable the zlib test:
> 
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index 078bd0dcfba5..8176632e519c 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -58,8 +58,8 @@ INSTALL ?= install
>  RM ?= rm -f
>  
>  FEATURE_USER = .bpftool
> -FEATURE_TESTS = libbfd disassembler-four-args reallocarray
> -FEATURE_DISPLAY = libbfd disassembler-four-args
> +FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
> +FEATURE_DISPLAY = libbfd disassembler-four-args zlib
>  
>  check_feat := 1
>  NON_CHECK_FEAT_TARGETS := clean uninstall doc doc-clean doc-install doc-uninstall
> 
> And then we can test for it the way libbpf tests for elf:
> 
> all: zdep $(OUTPUT)bpftool
> 
> PHONY += zdep
> 
> zdep:
> 	@if [ "$(feature-zlib)" != "1" ]; then echo "No zlib found"; exit 1 ; fi
> 
> Or maybe just $(error ...), Stan what's your preference here? 
> We don't have a precedent for hard tests of features in bpftool.
I'm just being nit picky :-)
Because changelog says we already depend on -lz, but then in the patch
we explicitly add it.

I think you were right in pointing out that we already implicitly depend
on -lz via -lelf and/or -lbfd. And it works for non-static builds.
We don't need an explicit -lz unless somebody puts '-static' in
EXTRA_CFLAGS. So maybe we should just submit the patch as is because
it fixes make EXTRA_CFLAGS=-static.

RE $(error): we don't do it for -lelf, right? So probably not worth
the hassle for zlib.
