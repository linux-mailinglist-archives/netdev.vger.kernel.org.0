Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19174458073
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 22:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbhKTVbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 16:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbhKTVbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 16:31:42 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04351C061574
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 13:28:37 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id v1so24953181edx.2
        for <netdev@vger.kernel.org>; Sat, 20 Nov 2021 13:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oldum-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=DBAy+PDPEAV3BA9s3sfwEPfn+NmLvEn1r8upoAU9QIA=;
        b=CggvuFKZlZYe9QeLITiq5POizBgnFP/HWdTIfenV9TpbmGqYGGORPa8NqVfQNoOO6B
         pJFNgALEMU7cY4mS9Efw0V6VabfHmA3dE3fx14W6sl/7oElUGOTO6r0pn55O9gY+E0hJ
         d7STO9Z3YhIyrwuKrmUXwvMxw0m8vD/eydbR7TqkHJnkCtDXozP9tO4+/2C9iwojSr59
         Lp3uBBaku4tYc48ZQ0IYK62LHwR7ABgacdTQy/9s3r7K02IcWRRGyvMScQceLW5bsaVA
         OSTmhw/6o7vo2DzU0KM9Vp0gO2HNPypemDrjgHbX0qp8cTa0SxRQo/gVsAtZpL/LP7LF
         6/PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=DBAy+PDPEAV3BA9s3sfwEPfn+NmLvEn1r8upoAU9QIA=;
        b=LJOpxyJMvhHL0ViW1cFz6E9br/m/cwjeOpcn1V24M3wjzgmt+wEcUtprBo7vJ0y+MJ
         z+5JCZDF3+Zn5F9Fmp6jqduwq01987qdE0RdphRyWVisnBg1z5XzET25hZ1X4Vd6xg3P
         2S/M86Sqim9LLNAHuR8DyqsKvSn75MuwU6WL+l6zBTmp73anaqrTg4CIL9a7P4ZmBCxL
         AByUaHbQLvGp+PAo6AKZbQ4kIbFZP08f4DRjfsA58sc1GCYiG5Q11o9DR4tIfWzZ9bF9
         XIZaMkKZilN73KB6S30H6ITTlZI4GHM0lb3CNjpfx9OQuMyW7tYQib3Ra0+WUt9ZP1tD
         B7wg==
X-Gm-Message-State: AOAM532rQMlqZqlb8ikgm6QUf54tgt4WEmTn4kK4Pitqaj8SSoP2Tmr0
        uV5jKcaNmWCvzxjNOW3iu9rpaR8Thv4GpgOu/n4=
X-Google-Smtp-Source: ABdhPJyRNXKYN8IXkl5QyQhOkyLhMvM3JCK4IGDNjDmo2mZdMK8Xxuf5JDQr5mQMZAWrUL79IVaVUg==
X-Received: by 2002:a50:e707:: with SMTP id a7mr43964686edn.352.1637443715885;
        Sat, 20 Nov 2021 13:28:35 -0800 (PST)
Received: from [10.1.0.200] (external.oldum.net. [82.161.240.76])
        by smtp.googlemail.com with ESMTPSA id j14sm1724917edw.96.2021.11.20.13.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 13:28:35 -0800 (PST)
Message-ID: <8d781f45b6a6fb434aa386dccb7f8f424ec1ffbe.camel@oldum.net>
Subject: Re: [PATCH v3 6/7] 9p/trans_virtio: support larger msize values
From:   Nikolay Kichukov <nikolay@oldum.net>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Date:   Sat, 20 Nov 2021 22:28:35 +0100
In-Reply-To: <2717208.9V0g2NVZY4@silver>
References: <cover.1632327421.git.linux_oss@crudebyte.com>
         <cef6a6c6f8313a609ef104cc64ee6cf9d0ed6adb.camel@oldum.net>
         <YZjfxT24by0Cse6q@codewreck.org> <2717208.9V0g2NVZY4@silver>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-11-20 at 15:46 +0100, Christian Schoenebeck wrote:
> On Samstag, 20. November 2021 12:45:09 CET Dominique Martinet wrote:
> > (Thanks for restarting this thread, this had totally slipped out of
> > my
> > mind...)
> 
> Hi guys,
> 
> I have (more or less) silently been working on these patches on all
> ends in 
> the meantime. If desired I try to find some time next week to
> summarize 
> current status of this overall effort and what still needs to be done.

Great, I would be more than happy to test next version of these patches.

> 
> > Nikolay Kichukov wrote on Sat, Nov 20, 2021 at 12:20:35PM +0100:
> > > When the client mounts the share via virtio, requested msize is:
> > > 10485760 or 104857600
> > > 
> > > however the mount succeeds with:
> > > msize=507904 in the end as per the /proc filesystem. This is less
> > > than
> > > the previous maximum value.
> > 
> > (Not sure about this, I'll test these patches tomorrow, but since
> > something failed I'm not surprised you have less than what you could
> > have here: what do you get with a more reasonable value like 1M
> > first?)

It worked with 1MB, I can stick to this for the time being.

Are the kernel patches supposed to be included in the KVM host kernel or
would the guest kernel suffice?

> 
> The highest 'msize' value possible for me with this particular version
> of the 
> kernel patches is 4186212 (so slightly below 4MB).
> 
> Some benchmarks, linear reading a 12 GB file:
> 
> msize    average      notes
> 
> 8 kB     52.0 MB/s    default msize of Linux kernel <v5.15
> 128 kB   624.8 MB/s   default msize of Linux kernel >=v5.15
> 512 kB   1961 MB/s    current max. msize with any Linux kernel <=v5.15
> 1 MB     2551 MB/s    this msize would violate current virtio specs
> 2 MB     2521 MB/s    this msize would violate current virtio specs
> 4 MB     2628 MB/s    planned milestone
> 
> That does not mean it already makes sense to use these patches in this
> version 
> as is to increase overall performance yet, but the numbers already
> suggest 
> that increasing msize can improve performance on large sequential I/O.
> There 
> are still some things to do though to fix other use patterns from
> slowing down 
> with rising msize, which I will describe in a separate email.
> 
> I also have an experimental version of kernel patches and QEMU that
> goes as 
> high as msize=128MB. But that's a highly hacked version that copies
> buffers 
> between 9p client level and virtio level back and forth and with
> intentional 
> large buffer sizes on every 9p message type. This was solely meant as
> a stress 
> test, i.e. whether it was possible to go as high as virtio's
> theoretical 
> protocol limit in the first place, and whether it was stable. This
> stress test 
> was not about performance at all. And yes, I had it running with 128MB
> for 
> weeks without issues (except of being very slow of course due to hacks
> used).
> 
> > > In addition to the above, when the kernel on the guest boots and
> > > loads
> > > 9pfs support, the attached memory allocation failure trace is
> > > generated.
> > > 
> > > Is anyone else seeing similar and was anybody able to get msize
> > > set to
> > > 10MB via virtio protocol with these patches?
> > 
> > I don't think the kernel would ever allow this with the given code,
> > as
> > the "common" part of 9p is not smart enough to use scatter-gather
> > and
> > tries to do a big allocation (almost) the size of the msize:
> > 
> > ---
> >         clnt->fcall_cache =
> >                 kmem_cache_create_usercopy("9p-fcall-cache", clnt-
> > >msize,
> >                                            0, 0, P9_HDRSZ + 4,
> >                                            clnt->msize - (P9_HDRSZ +
> > 4),
> >                                            NULL);
> > 
> > ...
> >                 fc->sdata = kmem_cache_alloc(c->fcall_cache,
> > GFP_NOFS);
> > ---
> > So in practice, you will be capped at 2MB as that is the biggest the
> > slab will be able to hand over in a single chunk.
> 
> I did not encounter a 2MB limit here. But kmalloc() clearly has a 4MB
> limit, 
> so when trying an msize larger than 4MB it inevitably causes a memory 
> allocation error. In my tests this allocation error would always
> happen 
> immediately at mount time causing an instant kernel oops.
> 
> > It'll also make allocation failures quite likely as soon as the
> > system
> > has had some uptime (depending on your workload, look at
> > /proc/buddyinfo
> > if your machines normally have 2MB chunks available), so I would
> > really
> > not recommend running with buffers bigger than e.g. 512k on real
> > workloads -- it looks great on benchmarks, especially as it's on its
> > own
> > slab so as long as you're doing a lot of requests it will dish out
> > buffers fast, but it'll likely be unreliable over time.
> > (oh, and we allocate two of these per request...)
> > 
> > 
> > The next step to support large buffers really would be splitting
> > htat
> > buffer to:
> >  1/ not allocate huge buffers for small metadata ops, e.g. an open
> > call
> > certainly doesn't need to allocate 10MB of memory
> >  2/ support splitting the buffer in some scattergather array
> > 
> > Ideally we'd only allocate on an as-need basis, most of the protocol
> > calls bound how much data is supposed to come back and we know how
> > much
> > we want to send (it's a format string actually, but we can majorate
> > it
> > quite easily), so one would need to adjust all protocol calls to
> > pass
> > this info to p9_client_rpc/p9_client_zc_rpc so it only allocates
> > buffers
> > as required, if necessary in multiple reasonably-sized segments (I'd
> > love 2MB hugepages-backed folios...), and have all transports use
> > these
> > buffers.
> 
> It is not that bad in sense of pending work. One major thing that
> needs to be 
> done is to cap the majority of 9p message types to allocate only as
> much as 
> they need, which is for most message types <8k. Right now they always
> simply 
> kmalloc(msize), which hurts with increasing msize values. That task
> does not 
> need many changes though.
> 
> > I have a rough idea on how to do all this but honestly less than 0
> > time
> > for that, so happy to give advices or review any patch, but it's
> > going
> > to be a lot of work that stand in the way of really big IOs.
> 
> Reviews of the patches would actually help a lot to bring this overall
> effort 
> forward, but probably rather starting with the upcoming next version
> of the 
> kernel patches, not this old v3.
> 
> > > [    1.527981] 9p: Installing v9fs 9p2000 file system support
> > > [    1.528173] ------------[ cut here ]------------
> > > [    1.528174] WARNING: CPU: 1 PID: 791 at mm/page_alloc.c:5356
> > > __alloc_pages+0x1ed/0x290
> > This warning is exactly what I was saying about the allocation cap:
> > you've requested an allocation that was bigger than the max
> > __alloc_page
> > is willing to provide (MAX_ORDER, 11, so 2MB as I was saying)

Yes, this is no longer happening when I lowered the value of the msize
parameter.

> 
> Best regards,
> Christian Schoenebeck
> 
> 

