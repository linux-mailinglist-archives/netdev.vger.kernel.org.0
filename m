Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72613457DA8
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhKTLsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 06:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbhKTLsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 06:48:42 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4769FC061574
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 03:45:39 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 6B137C020; Sat, 20 Nov 2021 12:45:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1637408734; bh=vePQcfQJvQBClcGAuOg032qkL+JD6uLXmp+Ryp6iyA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=4JrVv7o9mqtwJ4motkiQ6mQeTmpPLuOAM1nmDzETHDlftTEzhTzxupIZftI5WQE+L
         YsZZIqVl7ESPddpJJPtvjyVnAcP2d6+J3JD/LztxMxTIPCS58B9supccEIukYetmdo
         0Pq7bmVrMARO3gJoDMxiKZ3FY695n7D7p2Mr1KleEBtXFam9xB9jxJhnCj1glRECUq
         kKD5WHRDMVIS+KRUDdF8gjLdlLKZ84n3P3FzzF4NyRo2eDDy1ygF+Spaiu1c56/ueF
         m7Yn0Qs6uxcaJ9edEL5PlxKFo0gKvHCnUd0hLZIUdfKYtCOfNxdMXN8+AkEN/IF0gq
         xhHrA3iGJT36g==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 0B591C009;
        Sat, 20 Nov 2021 12:45:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1637408733; bh=vePQcfQJvQBClcGAuOg032qkL+JD6uLXmp+Ryp6iyA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2yZKO7xBpuG9lfRB4cOisWRvYShc3U4g8PbTvUL9i4IOQuA41bQZyCaOVfmO65/cU
         O0+ua975ESijBtwLqA/ZOZUlV/I76t9fMYUjNF/99XYAsbSY1VP6yaxO5YmwhhYsE7
         CSGvePBOI5e2QQSFBkWhO1rDQUDhlG/HINmTHfqbEO82WghLVM9L6/e7/t79t84E8k
         emLU0nOkFbVlGLjp9wZll4uyLvkNSAdv4AKt8+4269ygPua7QQJaaTAOq/Yx7nOMpt
         SjP1s++SnSqGD1JtbaJlp7McwuNGyGrXvqbpWVByT/PRNhfjCMrVBjb/9snfQELLT3
         I3N5uNX1PLQhw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 01277f42;
        Sat, 20 Nov 2021 11:45:24 +0000 (UTC)
Date:   Sat, 20 Nov 2021 20:45:09 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Nikolay Kichukov <nikolay@oldum.net>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 6/7] 9p/trans_virtio: support larger msize values
Message-ID: <YZjfxT24by0Cse6q@codewreck.org>
References: <cover.1632327421.git.linux_oss@crudebyte.com>
 <8119d4d93a39758075bb83730dcb571f5d071af6.1632327421.git.linux_oss@crudebyte.com>
 <cef6a6c6f8313a609ef104cc64ee6cf9d0ed6adb.camel@oldum.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cef6a6c6f8313a609ef104cc64ee6cf9d0ed6adb.camel@oldum.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Thanks for restarting this thread, this had totally slipped out of my
mind...)

Nikolay Kichukov wrote on Sat, Nov 20, 2021 at 12:20:35PM +0100:
> When the client mounts the share via virtio, requested msize is:
> 10485760 or 104857600
> 
> however the mount succeeds with:
> msize=507904 in the end as per the /proc filesystem. This is less than
> the previous maximum value.

(Not sure about this, I'll test these patches tomorrow, but since
something failed I'm not surprised you have less than what you could
have here: what do you get with a more reasonable value like 1M first?)

> In addition to the above, when the kernel on the guest boots and loads
> 9pfs support, the attached memory allocation failure trace is generated.
> 
> Is anyone else seeing similar and was anybody able to get msize set to
> 10MB via virtio protocol with these patches?

I don't think the kernel would ever allow this with the given code, as
the "common" part of 9p is not smart enough to use scatter-gather and
tries to do a big allocation (almost) the size of the msize:

---
        clnt->fcall_cache =
                kmem_cache_create_usercopy("9p-fcall-cache", clnt->msize,
                                           0, 0, P9_HDRSZ + 4,
                                           clnt->msize - (P9_HDRSZ + 4),
                                           NULL);

...
		fc->sdata = kmem_cache_alloc(c->fcall_cache, GFP_NOFS);
---
So in practice, you will be capped at 2MB as that is the biggest the
slab will be able to hand over in a single chunk.

It'll also make allocation failures quite likely as soon as the system
has had some uptime (depending on your workload, look at /proc/buddyinfo
if your machines normally have 2MB chunks available), so I would really
not recommend running with buffers bigger than e.g. 512k on real
workloads -- it looks great on benchmarks, especially as it's on its own
slab so as long as you're doing a lot of requests it will dish out
buffers fast, but it'll likely be unreliable over time.
(oh, and we allocate two of these per request...)


The next step to support large buffers really would be splitting htat
buffer to:
 1/ not allocate huge buffers for small metadata ops, e.g. an open call
certainly doesn't need to allocate 10MB of memory
 2/ support splitting the buffer in some scattergather array

Ideally we'd only allocate on an as-need basis, most of the protocol
calls bound how much data is supposed to come back and we know how much
we want to send (it's a format string actually, but we can majorate it
quite easily), so one would need to adjust all protocol calls to pass
this info to p9_client_rpc/p9_client_zc_rpc so it only allocates buffers
as required, if necessary in multiple reasonably-sized segments (I'd
love 2MB hugepages-backed folios...), and have all transports use these
buffers.

I have a rough idea on how to do all this but honestly less than 0 time
for that, so happy to give advices or review any patch, but it's going
to be a lot of work that stand in the way of really big IOs.



> [    1.527981] 9p: Installing v9fs 9p2000 file system support
> [    1.528173] ------------[ cut here ]------------
> [    1.528174] WARNING: CPU: 1 PID: 791 at mm/page_alloc.c:5356 __alloc_pages+0x1ed/0x290


This warning is exactly what I was saying about the allocation cap:
you've requested an allocation that was bigger than the max __alloc_page
is willing to provide (MAX_ORDER, 11, so 2MB as I was saying)

-- 
Dominique
