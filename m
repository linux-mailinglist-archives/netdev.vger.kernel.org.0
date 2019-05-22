Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402EF27256
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 00:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfEVWaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 18:30:15 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:47062 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfEVWaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 18:30:15 -0400
Received: by mail-pl1-f196.google.com with SMTP id r18so1725249pls.13
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 15:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nomqC9wm5tKuFrywoJSBZU7V59BqM/V7+n7l0RLilrI=;
        b=hpTtArzyg9yCaaL49Lq91oOAB6AXDpHvXuwPd+tZwEqUACpEou2KNhmOjQMSyXMPFz
         iNo+w62eh3kqA2TwABPkH34q2RjfuIykzW99bVT6/DgB9s3eaZOU0qkW9RG/kloRUZaR
         qaqQGUXB8zb6hRIdaSh0OSKIW7ZL68HlwgMsiSqkoomVnD9cmuvIdrzb139C8UHa6QgF
         Ie+AWutMSYGdo9RcJ2oGiMM11dZChiov7RcbLkCEmQ+JlViwJ1DNLtbBvOcHDH32LCSK
         CLJ+kW0pF4wykSRK6lJ9ga3o14j+ZFHIhwR+sKeJI5Dh3QOc7huPUwA81sEODxXU4oxU
         STcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nomqC9wm5tKuFrywoJSBZU7V59BqM/V7+n7l0RLilrI=;
        b=LO3dhiRxRhjrzIp/IknMI9k8GiC+2mZZaA9PYrSfWk+LptCsuRUMoeEQBAsVF2hBTy
         v/woPSTONvcRnoJSOwQH8kfEx6hM8lSMx66UdYEVsDS/JhVbHMIboQ8pcjEoQzskLV2p
         druGO7xX7Fk+JYcfx+JwL7dadJE9D3pM/XDiCv+Zc6mreiK/7UgDxrnPup71QdyHWt7H
         IuCREQLM5lxSu07gb9U54MFOeCg1d4I9e5viLZh3OoLDwv2s5ZVBNAYHoLR3BS8kvjkU
         eZPgOXzdVwHhseXXdIcXrqhQEhpVHjAzZ6Ex+zjG5cgkKV5TML7IPuo56zfI8CNMaj+8
         dv2g==
X-Gm-Message-State: APjAAAWBm8SbXCJU65VoKTVOHJ8r84N+YN7s0sxbvkXvRBnrne8Oqkp7
        jKYBZyvYpJ0zKmamLBWjJ/5JnQ==
X-Google-Smtp-Source: APXvYqzRH9ynCDvis8JkHjoUh5xNSbhqtE0xxa1qUjd/rVGEWIQAYqoVDGCBfN8KUqlOJyXCsLo8ww==
X-Received: by 2002:a17:902:760f:: with SMTP id k15mr17935549pll.125.1558564215019;
        Wed, 22 May 2019 15:30:15 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id m12sm22418831pgi.56.2019.05.22.15.30.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 15:30:14 -0700 (PDT)
Date:   Wed, 22 May 2019 15:30:13 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 05/12] libbpf: add resizable non-thread safe
 internal hashmap
Message-ID: <20190522223013.GC3032@mini-arch>
References: <20190522195053.4017624-1-andriin@fb.com>
 <20190522195053.4017624-6-andriin@fb.com>
 <20190522203032.GO10244@mini-arch>
 <CAEf4BzZi6A1vcFUFdwSQrbag_ptoU9+imdWhHdVKCLB8yvPSTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZi6A1vcFUFdwSQrbag_ptoU9+imdWhHdVKCLB8yvPSTw@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/22, Andrii Nakryiko wrote:
> On Wed, May 22, 2019 at 1:30 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 05/22, Andrii Nakryiko wrote:
> > > There is a need for fast point lookups inside libbpf for multiple use
> > > cases (e.g., name resolution for BTF-to-C conversion, by-name lookups in
> > > BTF for upcoming BPF CO-RE relocation support, etc). This patch
> > > implements simple resizable non-thread safe hashmap using single linked
> > > list chains.
> > Didn't really look into the details, but any reason you're not using
> > linux/hashtable.h? It's exported in tools/include and I think perf
> > is using it. It's probably not resizable, but should be easy to
> > implement rebalancing on top of it.
> 
> There are multiple reasons.
> 1. linux/hashtable.h is pretty bare-bones, it's just hlist_node and a
> bunch of macro to manipulate array or chains of them. I wanted to have
> higher-level API with lookup by key, insertion w/ various strategies,
> etc. Preferrably one not requiring to manipulate hlist_node directly
> as part of its API, even if at some performance cost of hiding that
> low-level detail.
> 2. Resizing is a big chunk of resizable hashmap logic, so I'd need to
> write a bunch of additional code anyway.
> 3. Licensing. linux/hashtable.h is under GPL, while libbpf is
> dual-licensed under GPL and BSD. When syncing libbpf from kernel to
> github, we have to re-implement all the parts from kernel that are not
> under BSD license anyway.
> 4. hlist_node keeps two pointers per item, which is unnecessary for
> hashmap which does deletion by key (by searching for node first, then
> deleting), so we can also have lower memory overhead per entry.
> 
> So in general, I feel like there is little benefit to reusing
> linux/hashlist.h for use cases I'm targeting this hashmap for.
Makes sense. Licensing is probably the biggest issue here because
my original suggestion was to use linux/hashtable.h internally,
just wrap it in a nice api.
But agree on all points, thanks for clarification!

> > > Four different insert strategies are supported:
> > >  - HASHMAP_ADD - only add key/value if key doesn't exist yet;
> > >  - HASHMAP_SET - add key/value pair if key doesn't exist yet; otherwise,
> > >    update value;
> > >  - HASHMAP_UPDATE - update value, if key already exists; otherwise, do
> > >    nothing and return -ENOENT;
> > >  - HASHMAP_APPEND - always add key/value pair, even if key already exists.
> > >    This turns hashmap into a multimap by allowing multiple values to be
> > >    associated with the same key. Most useful read API for such hashmap is
> > >    hashmap__for_each_key_entry() iteration. If hashmap__find() is still
> > >    used, it will return last inserted key/value entry (first in a bucket
> > >    chain).
> > >
> > > For HASHMAP_SET and HASHMAP_UPDATE, old key/value pair is returned, so
> > > that calling code can handle proper memory management, if necessary.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/lib/bpf/Build     |   2 +-
> > >  tools/lib/bpf/hashmap.c | 229 ++++++++++++++++++++++++++++++++++++++++
> > >  tools/lib/bpf/hashmap.h | 173 ++++++++++++++++++++++++++++++
> > >  3 files changed, 403 insertions(+), 1 deletion(-)
> > >  create mode 100644 tools/lib/bpf/hashmap.c
> > >  create mode 100644 tools/lib/bpf/hashmap.h
> > >
> > >
