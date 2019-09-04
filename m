Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 294A3A7816
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 03:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfIDBfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 21:35:55 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46491 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbfIDBfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 21:35:55 -0400
Received: by mail-pf1-f195.google.com with SMTP id q5so4271615pfg.13;
        Tue, 03 Sep 2019 18:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rhY/vI/VhJMkveLdYjP4bvjyAVodiq5BxKPvGV69/8k=;
        b=TBk+brMgj0VnTlu+K0UUyGOQqiBnACqfbSoRGEl1HAkaslzg13FKPH3PuOSkvw0nCE
         Zsez20RkTPTA0clsh5wS/ORkyY4uHFfhCUh+tNOenrzPOPMe9vsrfgosb4maldp7ZAaS
         GR8bTW51Ba+b6qlXv9R/omAbaaJCP/tVynKKgLxtjawYTlPtzHHZ7wxOuv4ukCpAEdBR
         KStD0plQ+B+Y1edUliPXJZYg2bLT/jiMaj6ZiUAfKOhZNOlAVqfIquzQ8gtqNrZ3jt6M
         tKdw5x7Uh1MZnsHtkHEsiEj2DkfFjqLEMTX1nRE2+JENOosH0mCCdNdyRft2viKTdFXZ
         dXLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rhY/vI/VhJMkveLdYjP4bvjyAVodiq5BxKPvGV69/8k=;
        b=TaSOEO9IgBFGHH+tvI/JQ65nu5tbnCcK6Y5V9H2sgXQpxvm8rvcgGPwq/VgyWC/Tf5
         JssFONJ7cZVpjrozRGxY3uco5Gx5sZJVOVpDrvJriqBTYQpVYGJuctpj2GWOOwFqLijq
         6czsfrutMCh+0y3bocXkdeT4oZIoPVkNhnFdgFLFwX57S5Ge1tAO93BJffEuDVs8/xHh
         qHelHtvBx0p8Vml+jVCi9gmznxcM7MiLZg1gi69o+kSnDPVzWDsW05cbetiGlBO6LvOc
         B/IegRqVaQGBba0waXSW9yZDwMT7UyeQXIuqY6wNqcS8Yz9MywPRmgphs/9GKP3xkpXc
         MOsQ==
X-Gm-Message-State: APjAAAWFgygpfswm+A9YwJAIyIOXB3sYy22a8lSt6yNmjIvEVMCxLLTT
        +2n1fWFdSPX6h8Qg/jjMcX0=
X-Google-Smtp-Source: APXvYqwWKAu64+IWA+sV+3KOjv6up0T3qxBzhU/r9+CxEG3TKetkxF442jeFsZaFLb0jIVUzPdtG2A==
X-Received: by 2002:a17:90a:c384:: with SMTP id h4mr2366371pjt.47.1567560954193;
        Tue, 03 Sep 2019 18:35:54 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:58a9])
        by smtp.gmail.com with ESMTPSA id n24sm790404pjq.21.2019.09.03.18.35.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 18:35:53 -0700 (PDT)
Date:   Tue, 3 Sep 2019 18:35:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Message-ID: <20190904013550.bfq3kccwe6kghmrg@ast-mbp.dhcp.thefacebook.com>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829113932.5c058194@cakuba.netronome.com>
 <CAMzD94S87BD0HnjjHVmhMPQ3UijS+oNu+H7NtMN8z8EAexgFtg@mail.gmail.com>
 <20190829171513.7699dbf3@cakuba.netronome.com>
 <20190830201513.GA2101@mini-arch>
 <eda3c9e0-8ad6-e684-0aeb-d63b9ed60aa7@fb.com>
 <20190830211809.GB2101@mini-arch>
 <20190903210127.z6mhkryqg6qz62dq@ast-mbp.dhcp.thefacebook.com>
 <20190903223043.GC2101@mini-arch>
 <CAMzD94Qge5CtUZ+_0DsuQ_VLpmoADDZemFH1=WA-H8P0ax8qDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMzD94Qge5CtUZ+_0DsuQ_VLpmoADDZemFH1=WA-H8P0ax8qDQ@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 04:07:17PM -0700, Brian Vazquez wrote:
> 
> We could also modify get_next_key behaviour _only_ when it's called
> from a dumping function in which case we do know that we want to move
> forward not backwards (basically if prev_key is not found, then
> retrieve the first key in the next bucket).
> 
> That approach might miss entries that are in the same bucket where the
> prev_key used to be, but missing entries is something that can always
> happen (new additions in previous buckets), we can not control that
> and as it has said before, if users care about consistency they can
> use map-in-map.

for dump-all case such miss of elements might be ok-ish,
but for delete-all it's probably not.
Imagine bpf prog is doing delete and bcc script is doing delete-all.
With 'go to the next bucket' logic there will be a case where
both kernel and user side are doing delete, but some elements are still left.
True that map-in-map is the answer, but if we're doing new get_next op
we probably should do it with less corner cases.

> > This all requires new per-map implementations unfortunately :-(
> > We were trying to see if we can somehow improve the existing bpf_map_ops
> > to be more friendly towards batching.
> 
> Agreed that one of the motivations for current batching implementation
> was to re use the existing code as much as we can. Although this might
> be a good opportunity to do some per-map implementations as long as
> they behave better than the current ones.

I don't think non reuse of get_next is a big deal.
Adding another get_next_v2 to all maps is a low cost comparing
with advantages of having stable iterate api.

stable walk over hash map is imo more important feature of api than
perf improvement brought by batching.

