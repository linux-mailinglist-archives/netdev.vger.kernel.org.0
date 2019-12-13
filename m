Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F35211E969
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 18:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbfLMRrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 12:47:17 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42484 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728576AbfLMRrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 12:47:17 -0500
Received: by mail-lj1-f195.google.com with SMTP id e28so3553693ljo.9
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 09:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=eoAJedssCRtORBBwXDIR4/QT9NuQsdzJ4Ntg4pSM5cY=;
        b=1bgwUcAZ78xCTIqaqNviEKuMJb97CygulYIPlFUqxsRkcRsnof435hIi2Xo9UN6RIc
         AZYzu5lldy7TGNkcuuLDtmbqA1CDS4B8+QWKjQIUCcDOGvfan9LAwAD5e4SGX5E4fWZ8
         PXr8h/WLRIBnR5CSWvuAyIOKbY3V1te0Yx+wzlK6CRWEW1gFd8vpWsNfyjUJWPWCOmfv
         MUC3EwO12smFILAg7MrScMAH0IE4qq/4k65nNGoDEWhlbyWO1MQ6X5wlg7AQ/TmO0+oK
         uVCG6N9DC/fHP5UGuJFkKhRSC/pUrkPeWc06iatwR9gPJUnsjrur6Nrv/Sbm2NM0Hqat
         RGTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=eoAJedssCRtORBBwXDIR4/QT9NuQsdzJ4Ntg4pSM5cY=;
        b=YTC08StFv42try+uWpKQz8BoREuGcIMRkGkALjaOqK2o493rLE7DNMgK8NYN4SiIoH
         K5ZJYOfpIow7uc8kF3k/c8hnByriE6eNPMorjDPejYxmus7q8RAfcRhktIinkU/L21ks
         Ltz1QsaVHRnuHachxwk8o53WtSoMjnrQMF+UeuPXH7o0Il6DUhU1XQ+xFWPGt2/KnxOX
         e7wJcx9sSv8fGeuoyd3fiSDDEwhz0IP94Mj/C3n2B9jvUlscLjjXgfC9oT33RIQwvTFr
         RN6A2fD5FpXnWW9Cjqysed29UOlDC+ao8fsvbvHAKRwX4bABdD7z951iP9M/4Z432J3X
         8ZEg==
X-Gm-Message-State: APjAAAXX+K6c8iaQzVrakSd9007NQbLEMVahByeAoaLqUEfz2wj2AR+e
        D8iGBtOaOT39O0Z7a+/OGgXihA==
X-Google-Smtp-Source: APXvYqyrL4fP/y35voKQ93uhJQCdlErk3H7h25gfob2xBThYWvN+CbLHJ+UN7VZf7cdxBzpPbR1YQg==
X-Received: by 2002:a2e:868c:: with SMTP id l12mr9458337lji.194.1576259234756;
        Fri, 13 Dec 2019 09:47:14 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j19sm5555628lfb.90.2019.12.13.09.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 09:47:14 -0800 (PST)
Date:   Fri, 13 Dec 2019 09:47:05 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
Message-ID: <20191213094705.486101a0@cakuba.netronome.com>
In-Reply-To: <CAEf4BzaG95dxgSBSm7m8c3gJ-XeL97=N4srS5fR7JRfcjaMwTw@mail.gmail.com>
References: <CAEf4Bzb+3b-ypP8YJVA=ogQgp1KXx2xPConOswA0EiGXsmfJow@mail.gmail.com>
        <20191211191518.GD3105713@mini-arch>
        <CAEf4BzYofFFjSAO3O-G37qyeVHE6FACex=yermt8bF8mXksh8g@mail.gmail.com>
        <20191211200924.GE3105713@mini-arch>
        <CAEf4BzaE0Q7LnPOa90p1RX9qSbOA_8hkT=6=7peP9C88ErRumQ@mail.gmail.com>
        <20191212025735.GK3105713@mini-arch>
        <CAEf4BzY2KHK4h5e40QgGt4GzJ6c+rm-vtbyEdM41vUSqcs=txA@mail.gmail.com>
        <20191212162953.GM3105713@mini-arch>
        <CAEf4BzYJHvuFbBM-xvCCsEa+Pg-bG1tprGMbCDtsbGHdv7KspA@mail.gmail.com>
        <20191212104334.222552a1@cakuba.netronome.com>
        <20191212195415.ubnuypco536rp6mu@ast-mbp.dhcp.thefacebook.com>
        <20191212122115.612bb13b@cakuba.netronome.com>
        <CAEf4BzaG95dxgSBSm7m8c3gJ-XeL97=N4srS5fR7JRfcjaMwTw@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 22:48:10 -0800, Andrii Nakryiko wrote:
> > improve and hack on it. Baking it into as system tool is counter
> > productive. Users should be able to grab the skel tool single-file
> > source and adjust for their project's needs. Distributing your own copy
> > of bpftool because you want to adjust skel is a heavy lift.  
> 
> Skeleton is auto-generated code, it's not supposed to be tweaked or
> "adjusted" by hand. 

Obviously not, I said adjusting the codegen tool, not the output.

> Because next time you do tiny change to your BPF
> source code (just swap order of two global variables), skeleton
> changes. If someone is not satisfied with the way skeleton generation
> looks like, they should propose changes and contribute to common
> algorithm. Or, of course, they can just go and re-implement it on
> their own, if struct bpf_object_skeleton suits them still (which is
> what libbpf works with). Then they can do it in Python, Go, Scala,
> Java, Perl, whatnot. But somehow I doubt anyone would want to do that.
> 
> > And maybe one day we do have Python/Go/whatever bindings, and we can
> > convert the skel tool to a higher level language with modern templating.  
> 
> Because high-level implementation is going to be so much simpler and
> shorter, really? Is it that complicated in C right now? What's the
> real benefit of waiting to be able to do it in "higher level" language
> beyond being the contrarian? 

I did not say wait, I said do C and convert to something else once easy.
You really gotta read responses more carefully :/

> Apart from \n\ (which is mostly hidden
> from view), I don't think high-level templates are going to be much
> more clean.
> 
> > > We cannot and should not adopt kernel-like ABI guarantees to user space
> > > code. It will paralyze the development.  
> >
> > Discussion for another time :)  
> 
> If this "experimental" disclaimer is a real blocker for all of this, I
> don't mind making it a public API right now. bpf_object_skeleton is
> already designed to be backward/forward compatible with size of struct
> itself and all the sub-structs recorded during initialization. I
> didn't mean to create impression like this whole approach is so raw
> and untried that it will most certainly break and we are still unsure
> about it. It's not and it certainly improves set up code for
> real-world applications. We might need to add some extra option here
> and there, but the stuff that's there already will stay as is.

As explained the experimental disclaimer is fairly useless and it gives
people precedent for maybe not caring as hard as they should about
ironing the details out before sending code upstream.

I think we can just add a switch or option for improved generation when
needed. You already check there are not extra trailing arguments so we
should be good.

> Would moving all the skeleton-related stuff into libbpf.h and
> "stabilizing" it make all this more tolerable for you?

I think I'm too tired if this to have an option any more.
