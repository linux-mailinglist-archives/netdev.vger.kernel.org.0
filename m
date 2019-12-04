Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0502411384E
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 00:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbfLDXjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 18:39:54 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34076 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbfLDXjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 18:39:53 -0500
Received: by mail-pg1-f194.google.com with SMTP id r11so650219pgf.1;
        Wed, 04 Dec 2019 15:39:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T+fmIAcbvPunjOne4lSVzDFj12f4dda2gaEWlkYAhO4=;
        b=QC9uba6k0eil9dabA/dnJu+IfZoCjL9HkwHTeIfZ+PvQfEaylkJZq80YcxGpIVce4D
         +ZO5pgMqjg+Oiefmbv1wppCCjVejhHdyZyDCh8JfeRXomomdyoHZzx5gnxRf4vOXxU2Z
         ARnlPk2dCZStJ27MIPhSdwb8Fl1Gf+zSpcPWqX8A16j/jDKkJ4dZY1jJiCeD0EYTUX9Y
         iFjAN+GCdi0GTJ+EGs1G1NsitP4FGspIHa/ZBpIAc9prEZT37p20N0HUDMo2ApYRGxv8
         HQTWCZoXgU68jZ2e9y3t5Yh78Jak00gmDgnb71iBDcyq6ccpCv7Ca5sPx85OfDLrFrAB
         JYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T+fmIAcbvPunjOne4lSVzDFj12f4dda2gaEWlkYAhO4=;
        b=kRgn+2TQjAKOnR6t+dGuo0mo2mbK3j+bLZu+in9JOev5oyyZNqNr65mWBBtmRBkHz9
         PWXo+/YmNuEBlatq5jRwx7BYKktbvB1bWGpqC6odgmBPkFb+7ZWJ/2p+YeCbE8XlqmW4
         tQjtF7uvxbLxqSQ2bpZwlEkjL77kETuuaSI5k+tuyP7bPfVfhfvh3VrXPOCes/vqUFAH
         7ZJpBjDtQ9ldAq5P83K8fRtX0yaUwGUcnYX3OIIYwep9lGvy7AnZ6CLSp7sF6U2MbGt+
         COfZpQAqYjoQPqnWOFCMPr9ZG65DHS9VtCmbqIr2J4JMAazcW3C1bHEYktCW1vxHD6HS
         xIag==
X-Gm-Message-State: APjAAAVRDgHQ8rFwPzLBodfzv3hALoKHrgqWtFjjidH9VZuayCmbiOlz
        AQxDdzhvBwfBlLKn56b75eU=
X-Google-Smtp-Source: APXvYqwGFrV46HuiqLpRY8kXemfGVnefFTlDWtqzEP44TXsqp4AkeVHfpn7V9XR9DokKpMf9Db4i9w==
X-Received: by 2002:a62:e210:: with SMTP id a16mr6209696pfi.123.1575502792921;
        Wed, 04 Dec 2019 15:39:52 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::f9fe])
        by smtp.gmail.com with ESMTPSA id r193sm3923243pfr.100.2019.12.04.15.39.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 15:39:52 -0800 (PST)
Date:   Wed, 4 Dec 2019 15:39:49 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
Message-ID: <20191204233948.opvlopjkxe5o66lr@ast-mbp.dhcp.thefacebook.com>
References: <20191202131847.30837-1-jolsa@kernel.org>
 <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com>
 <87wobepgy0.fsf@toke.dk>
 <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
 <CAEf4BzZ+0XpH_zJ0P78vjzmFAH3kGZ21w3-LcSEG=B=+ZQWJ=w@mail.gmail.com>
 <20191204135405.3ffb9ad6@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204135405.3ffb9ad6@cakuba.netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 04, 2019 at 01:54:05PM -0800, Jakub Kicinski wrote:
> On Wed, 4 Dec 2019 13:16:13 -0800, Andrii Nakryiko wrote:
> > I wonder what big advantage having bpftool in libbpf's Github repo
> > brings, actually? The reason we need libbpf on github is to allow
> > other projects like pahole to be able to use libbpf from submodule.
> > There is no such need for bpftool.
> > 
> > I agree about preference to release them in sync, but that could be
> > easily done by releasing based on corresponding commits in github's
> > libbpf repo and kernel repo. bpftool doesn't have to physically live
> > next to libbpf on Github, does it?
> 
> +1
> 
> > Calling github repo a "mirror" is incorrect. It's not a 1:1 copy of
> > files. We have a completely separate Makefile for libbpf, and we have
> > a bunch of stuff we had to re-implement to detach libbpf code from
> > kernel's non-UAPI headers. Doing this for bpftool as well seems like
> > just more maintenance. Keeping github's Makefile in sync with kernel's
> > Makefile (for libbpf) is PITA, I'd rather avoid similar pains for
> > bpftool without a really good reason.
> 
> Agreed. Having libbpf on GH is definitely useful today, but one can hope
> a day will come when distroes will get up to speed on packaging libbpf,
> and perhaps we can retire it? Maybe 2, 3 years from now? Putting
> bpftool in the same boat is just more baggage.

Distros should be packaging libbpf and bpftool from single repo on github.
Kernel tree is for packaging kernel.

