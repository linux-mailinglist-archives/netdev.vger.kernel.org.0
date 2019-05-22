Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2E726895
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 18:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbfEVQq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 12:46:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41957 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729862AbfEVQq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 12:46:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id q17so1615157pfq.8
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 09:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7kOfNkvfLOrsvKhryQIQ9dhn+PcqS/Zrm3nHf3izu8c=;
        b=po3HnMg7ABzLT0a+KXyR47NsK85c+Ebp3J05nm0RT9zftApCly513e2aj+XgUP1dAj
         LANeVAS9OhvgeDedcYm8fWzqS0kMOhZ68EAmralcGLtdm9CVbt/8JKNsOnaYQ852S16g
         Z3Lo+CyF3SJA1aYicWIIZw1S4UpSKH11QQVBQrM1neWX2mNzNKZysaLAqe5VNEnTfjMa
         L10dstcV9SE0/nc1wJm+s8vQHSXJNzO9Asy8gs5lqCQATj56aITr/mH0TVU8YzzSiHqD
         +jUg6M1kzYpQly/C92Tj8H36hi4p5HCHu1hpvyUWVm5ZqoIwIZVQsz7EikOs4/bctnwn
         X2lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7kOfNkvfLOrsvKhryQIQ9dhn+PcqS/Zrm3nHf3izu8c=;
        b=dxCZcP0J9isJ/FQkS5JOTDVhptEHrU1WSEAr4qPp7kIPCWaPlmywlssIj4tePnros4
         30pqEDPWSLRilijioR/+0Ou0dDQDS89vR5ICRmgJ4T4TnSk+32KEQ44Gup/cnGsXoR+Y
         reSA6WJ5E2nN8cPVK04Wv545feo1U7ACqBdUpUarytxTWAsYK6jkT0Zxy6qeYPpiXv+Q
         vZLCxs78hQnT+zmFauqpsFdc8iOBOBi1LA+ICNvZAuNHlcY6j9DeO0SQxJvlqRXm5Vxn
         ScswiuD+DpvD1qFjMggZHVdNhIO9cyPMDOwXFW3NzKcwNwC94js94u4x/ALMzx8lLavs
         LcKg==
X-Gm-Message-State: APjAAAVAGuv8W+ixT4Lkd62BxKdoWXpYsc39R3Qi7NBlCxoCK2tOOLJU
        Sns/MNNgH7hdxeQOg9reWfmoBVtCj0M=
X-Google-Smtp-Source: APXvYqxEsogU65ow4ZOdBgaC1+t6sO4OhfXuz+vGOMcG0g5udW9deLDd+VqUiO2Qz1OgTFOomry2Pw==
X-Received: by 2002:a63:f44f:: with SMTP id p15mr90929837pgk.65.1558543618090;
        Wed, 22 May 2019 09:46:58 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id c17sm1313668pfi.116.2019.05.22.09.46.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 09:46:57 -0700 (PDT)
Date:   Wed, 22 May 2019 09:46:56 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next] libbpf: emit diff of mismatched public API, if
 any
Message-ID: <20190522164656.GK10244@mini-arch>
References: <20190522161520.3407245-1-andriin@fb.com>
 <1b027a52-4ac7-daf8-ee4a-eb528f53e526@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b027a52-4ac7-daf8-ee4a-eb528f53e526@fb.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/22, Alexei Starovoitov wrote:
> On 5/22/19 9:15 AM, Andrii Nakryiko wrote:
> > It's easy to have a mismatch of "intended to be public" vs really
> > exposed API functions. While Makefile does check for this mismatch, if
> > it actually occurs it's not trivial to determine which functions are
> > accidentally exposed. This patch dumps out a diff showing what's not
> > supposed to be exposed facilitating easier fixing.
> > 
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >   tools/lib/bpf/.gitignore | 2 ++
> >   tools/lib/bpf/Makefile   | 8 ++++++++
> >   2 files changed, 10 insertions(+)
> > 
> > diff --git a/tools/lib/bpf/.gitignore b/tools/lib/bpf/.gitignore
> > index d9e9dec04605..c7306e858e2e 100644
> > --- a/tools/lib/bpf/.gitignore
> > +++ b/tools/lib/bpf/.gitignore
> > @@ -3,3 +3,5 @@ libbpf.pc
> >   FEATURE-DUMP.libbpf
> >   test_libbpf
> >   libbpf.so.*
> > +libbpf_global_syms.tmp
> > +libbpf_versioned_syms.tmp
> > diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> > index f91639bf5650..7e7d6d851713 100644
> > --- a/tools/lib/bpf/Makefile
> > +++ b/tools/lib/bpf/Makefile
> > @@ -204,6 +204,14 @@ check_abi: $(OUTPUT)libbpf.so
> >   		     "versioned symbols in $^ ($(VERSIONED_SYM_COUNT))." \
> >   		     "Please make sure all LIBBPF_API symbols are"	 \
> >   		     "versioned in $(VERSION_SCRIPT)." >&2;		 \
> > +		readelf -s --wide $(OUTPUT)libbpf-in.o |		 \
> > +		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}'|   \
> > +		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
> > +		readelf -s --wide $(OUTPUT)libbpf.so |			 \
> > +		    grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |		 \
> > +		    sort -u > $(OUTPUT)libbpf_versioned_syms.tmp; 	 \
> > +		diff -u $(OUTPUT)libbpf_global_syms.tmp			 \
> > +		     $(OUTPUT)libbpf_versioned_syms.tmp;		 \
> >   		exit 1;							 \
> 
> good idea.
> how about removing tmp files instead of adding them to .gitignore?
We should be able to do it without any temp files. At least in bash
one can do:

diff -u <(readelf -s --wide ${OUTPUT}libbpf-in.o | \
	  awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $8}' | \
	  sort -u) \
	<(readelf -s --wide ${OUTPUT}libbpf.so | \
	  grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | \
	  sort -u)

But might be complicated in the makefile :-/
