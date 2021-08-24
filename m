Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72493F6B9F
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 00:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238671AbhHXWQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 18:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhHXWQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 18:16:10 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABADC061757;
        Tue, 24 Aug 2021 15:15:25 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id m4so2081186pll.0;
        Tue, 24 Aug 2021 15:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dxd11OUrvB9RJEaZboe/M/emqrU0iALdwV2Fo+CWDbA=;
        b=llO0hESPXEUWWbhqYNKsh8j7d4KqbafG2I0nGffiAkD7wSf6k4DFXiiDk5Q/GzalS+
         sYZzue2qiXOLeZCHX27kL8JfdZAjUt6Si2IlSQsFE+vxEzuyVTl+YQxFIB60f1AXM3pA
         wPMtZglRINiR2TZlvnlj5q67jD9y8YPqfFOz8waUL+snvukVzrKkQBxSTITgo0V4/Pho
         mF4mhnc/5ek3DGNxImumte9a9BR9UDg74ZBjw7YUFhXjfkgH/S4yS/LcbWpC+iADAzK8
         TDKaeGknKligzssLm/XeL3gvcZeE5ALFcuj2oOF0HjbmovuyQS2EArbx7+iS5fROwNVw
         op6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dxd11OUrvB9RJEaZboe/M/emqrU0iALdwV2Fo+CWDbA=;
        b=dynJPLEAIMOROqDrbza7tbsp3BqJvUsTcWlDnJqAKuHE4LPESKAYbf4NDwvz2AR/UB
         gmA4XL9xJix/W9KcM2Nf3/WDQc/4iDAXICgKE+bJzpd1W3p0QsTECZDGzljAGxNJhCqq
         57cxvT2pTEOy/8MCzy7KvFYXJNbVD51OBQIdrP4LbIRyuN7BwHZNBFP2Xbr3B8RTMFnh
         9xnkrt/LJ3HECSihlgkDh79YndbDIL3K6R4Ind5u8YwI2uCQv9poL26QA8YjD8VL1M1/
         rzjyTHFmVI7oR39cONnWeVs5xLmqYGYk2gTaQ8rTeliLJbdgn0rqMbfnF2pavHX89uES
         sW5w==
X-Gm-Message-State: AOAM5303XhMKaFqqmRRywulJ6X3459l3faqOFrdVCUdkyFQ7erxSjcXU
        6BWpiwGwae+CPpGfmBZ5wGg=
X-Google-Smtp-Source: ABdhPJzp4glQnPn/CBKVieurs7ALor3fKFLUsN5YcHWLhtoitrMttuCwr7r8zQm7fK2MccpygXRF9g==
X-Received: by 2002:a17:90a:28a6:: with SMTP id f35mr7036524pjd.68.1629843324783;
        Tue, 24 Aug 2021 15:15:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:500::6:5aca])
        by smtp.gmail.com with ESMTPSA id h8sm3404851pjs.8.2021.08.24.15.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 15:15:24 -0700 (PDT)
Date:   Tue, 24 Aug 2021 15:15:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     sdf@google.com
Cc:     hjm2133@columbia.edu, bpf@vger.kernel.org, netdev@vger.kernel.org,
        ppenkov@google.com
Subject: Re: [RFC PATCH bpf-next 0/2] bpf: Implement shared persistent
 fast(er) sk_storoage mode
Message-ID: <20210824221522.5kokuv3eekalo2ha@ast-mbp.dhcp.thefacebook.com>
References: <20210823215252.15936-1-hansmontero99@gmail.com>
 <20210824003847.4jlkv2hpx7milwfr@ast-mbp.dhcp.thefacebook.com>
 <YSUYSIYyXmBgKRwr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSUYSIYyXmBgKRwr@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 09:03:20AM -0700, sdf@google.com wrote:
> On 08/23, Alexei Starovoitov wrote:
> > On Mon, Aug 23, 2021 at 05:52:50PM -0400, Hans Montero wrote:
> > > From: Hans Montero <hjm2133@columbia.edu>
> > >
> > > This patch set adds a BPF local storage optimization. The first patch
> > adds the
> > > feature, and the second patch extends the bpf selftests so that the
> > feature is
> > > tested.
> > >
> > > We are running BPF programs for each egress packet and noticed that
> > > bpf_sk_storage_get incurs a significant amount of cpu time. By
> > inlining the
> > > storage into struct sock and accessing that instead of performing a
> > map lookup,
> > > we expect to reduce overhead for our specific use-case.
> 
> > Looks like a hack to me. Please share the perf numbers and setup details.
> > I think there should be a different way to address performance concerns
> > without going into such hacks.
> 
> What kind of perf numbers would you like to see? What we see here is
> that bpf_sk_storage_get() cycles are somewhere on par with hashtable
> lookups (we've moved off of 5-tuple ht lookup to sk_storage). Looking
> at the code, it seems it's mostly coming from the following:
> 
>   sk_storage = rcu_dereference(sk->sk_bpf_storage);
>   sdata = rcu_dereference(local_storage->cache[smap->cache_idx]);
>   return sdata->data
> 
> We do 3 cold-cache references :-( 

Only if the prog doesn't read anything at all through 'sk' pointer,
but sounds like the bpf logic is accessing it, so for a system with millions
of sockets the first access to 'sk' will pay that penalty.
I suspect if you rearrange bpf prog to do sk->foo first the cache
miss will move and bpf_sk_storage_get() won't be hot anymore.
That's why optimizing loads like this without considering the full
picture might not achieve the desired result at the end.

> This is where the idea of inlining
> something in the socket itself came from. The RFC is just to present
> the case and discuss. I was thinking about doing some kind of
> inlining at runtime (and fallback to non-inlined case) but wanted
> to start with discussing this compile-time option first.
> 
> We can also try to save sdata somewhere in the socket to avoid two
> lookups for the cached case, this can potentially save us two
> rcu_dereference's.
> Is that something that looks acceptable? 

Not until there is clear 'perf report' where issue is obvious.

> I was wondering whether you've
> considered any socket storage optimizations on your side?

Quite the opposite. We've refactored several bpf progs to use
local storage instead of hash maps and achieved nice perf wins.

> I can try to set up some office hours to discuss in person if that's
> preferred.

Indeed, it's probably the best do discuss it on a call.
