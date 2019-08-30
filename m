Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02F5A3EDD
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 22:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfH3UPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 16:15:16 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37205 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbfH3UPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 16:15:16 -0400
Received: by mail-pg1-f193.google.com with SMTP id d1so4072430pgp.4
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 13:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a6iN+pwJ7vrmX1H+dzIi/TKd0qsBtlF9jo10cWeeCWs=;
        b=ZJ93UVFBrkW68hAG0iT6jJcxri/8ieSCOfCeF1WRhWEhwc8pXmySXs109taBDGvw8h
         vid/2OV0HdFTGfQJcLQB8Bu2kvePDbGhlJ7OST6A4LKaX7kfuZspwb57MXb0UNJeI+HJ
         ZpPQ4Qb+KsKbKhTvTzOIT4UBIRDHoQsuPM2aI3K1ip2at11v119uwMu0m7zeTZESmUsW
         sbyJ3AeTGfUFJ/3ndX5aK1xvzkphftDRalL+6WM7O4g/4vRkKHZ86Q2c6qt7BWhj71SZ
         4h6Rze2cAiSHN5hb6SEh21XJtRAWvHa6b8rUPBu1FCBGEkzQBmk8mR3VNypD8V1s8cg4
         qgGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a6iN+pwJ7vrmX1H+dzIi/TKd0qsBtlF9jo10cWeeCWs=;
        b=CvUg5fgtt8zcV+Z3m9B6WH4i3XEE2GVMt/zoHfA3ZglTH3v6V6rnb4BTDScg3w+vbG
         qnp+OFLDA+A6bmCR6VX5cZ2haMtWDbIzbvu+sikKCy3YiN5r0J+Vq+HliSuUtxKyAAb6
         ZWdgnvOLheGbpwh4K7XkYHhc2uKL4XRxbwbUYkUzvY331TqoOM/tZJoYvLyK0ssMb1fj
         1y/QRSsZ7HwJe94kETQos9PHDf0771VW9ShlAW6755GNxLaY+rdVuhXANUWz2cnIA5Y4
         m7nIwLtI72uZRoLIRzaN4stYm/JGSygdG1GZkuhi82UJj4YZIji04GC784yJb+ej7iQ2
         /WEw==
X-Gm-Message-State: APjAAAXGnQ56vk9avGlgZke3UGhlKMfZR4/ZxryEmdwpmcYyiRYwHSEc
        IgZI8Pj1nvr6Nz+HUJkiiFSbkA==
X-Google-Smtp-Source: APXvYqzy14D+UOFPHU/6U/qi89zti6bRxhra2XowGr5nshW5OF/0Ya0KHUPkwHH6qx2LzFzUMrjkaQ==
X-Received: by 2002:a17:90a:bb92:: with SMTP id v18mr366213pjr.78.1567196115743;
        Fri, 30 Aug 2019 13:15:15 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id w2sm6949840pjr.27.2019.08.30.13.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 13:15:15 -0700 (PDT)
Date:   Fri, 30 Aug 2019 13:15:13 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Brian Vazquez <brianvv@google.com>, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Message-ID: <20190830201513.GA2101@mini-arch>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829113932.5c058194@cakuba.netronome.com>
 <CAMzD94S87BD0HnjjHVmhMPQ3UijS+oNu+H7NtMN8z8EAexgFtg@mail.gmail.com>
 <20190829171513.7699dbf3@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829171513.7699dbf3@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/29, Jakub Kicinski wrote:
> On Thu, 29 Aug 2019 16:13:59 -0700, Brian Vazquez wrote:
> > > We need a per-map implementation of the exec side, but roughly maps
> > > would do:
> > >
> > >         LIST_HEAD(deleted);
> > >
> > >         for entry in map {
> > >                 struct map_op_ctx {
> > >                         .key    = entry->key,
> > >                         .value  = entry->value,
> > >                 };
> > >
> > >                 act = BPF_PROG_RUN(filter, &map_op_ctx);
> > >                 if (act & ~ACT_BITS)
> > >                         return -EINVAL;
> > >
> > >                 if (act & DELETE) {
> > >                         map_unlink(entry);
> > >                         list_add(entry, &deleted);
> > >                 }
> > >                 if (act & STOP)
> > >                         break;
> > >         }
> > >
> > >         synchronize_rcu();
> > >
> > >         for entry in deleted {
> > >                 struct map_op_ctx {
> > >                         .key    = entry->key,
> > >                         .value  = entry->value,
> > >                 };
> > >
> > >                 BPF_PROG_RUN(dumper, &map_op_ctx);
> > >                 map_free(entry);
> > >         }
> > >  
> > Hi Jakub,
> > 
> > how would that approach support percpu maps?
> > 
> > I'm thinking of a scenario where you want to do some calculations on
> > percpu maps and you are interested on the info on all the cpus not
> > just the one that is running the bpf program. Currently on a pcpu map
> > the bpf_map_lookup_elem helper only returns the pointer to the data of
> > the executing cpu.
> 
> Right, we need to have the iteration outside of the bpf program itself,
> and pass the element in through the context. That way we can feed each
> per cpu entry into the program separately.
My 2 cents:

I personally like Jakub's/Quentin's proposal more. So if I get to choose
between this series and Jakub's filter+dump in BPF, I'd pick filter+dump
(pending per-cpu issue which we actually care about).

But if we can have both, I don't have any objections; this patch
series looks to me a lot like what Brian did, just extended to more
commands. If we are fine with the shortcomings raised about the
original series, then let's go with this version. Maybe we can also
look into addressing these independently.

But if I pretend that we live in an ideal world, I'd just go with
whatever Jakub and Quentin are doing so we don't have to support
two APIs that essentially do the same (minus batching update, but
it looks like there is no clear use case for that yet; maybe).

I guess you can hold off this series a bit and discuss it at LPC,
you have a talk dedicated to that :-) (and afaiu, you are all going)
