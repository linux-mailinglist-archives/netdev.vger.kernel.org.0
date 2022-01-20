Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C6E49566E
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 23:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiATWn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 17:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbiATWn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 17:43:57 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8469EC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 14:43:56 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id f21so34942090eds.11
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 14:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oldum-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=enGhjxILGRnnQl6nute3Ght0JLasQgpcrNHT9XN3Abg=;
        b=kQtujP0Ff8ZU4GAKSKVfEZYNNUyRIbKO7wb5tbmVojcBGeFOapIcnV678ybiJ+27nI
         T2s8H0FsNkXb8kNulMull+cfiRthTjXiYfMTxoD8sxzikK2JfTT0LSA/La1FO3AuOuTa
         0mqBU6ESfn7oKHuWjGOwtAnAgkhFg+9FMwmIU/FdjGgKODHi/4ewA9rNdMk3rYjuZlCM
         8VulBk8kvz+3hj43Bn3uv8ujo4O2nu0u1df0dmhLx8HbwH114B0YhHm/Vd+TjofDh7Cr
         cNXTsg/g3FlBTg9VzLHtiRm1Ri9TV41q27+MLUDzwIQxVww+gSFeY7cY3hc/vRL4b6KD
         vX2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=enGhjxILGRnnQl6nute3Ght0JLasQgpcrNHT9XN3Abg=;
        b=LvOn5Y7uFMh7eISJP/3vFRJfuafaojcmjGxcnf4DZHPJat0cUaPVec6al1SlvWZytG
         6DeFlZT50u4xVIhK/X7Hufd1omBhuqJ80PW5I7WY9IN6s9QQ7r1nZZOw2/7HBxk4bFiD
         sdZNmpnwenCIo3tMw/hGI8GOrUpdWr5scAUnkMqYzzN2moSmyUMvw2iKIEihKLLaN/V+
         YLWOS9RnkaLh5PXdelidWzpm/CRaYA3pwfScxNRActPy/S7nQl0T5GdmIBcgktpOIes9
         eIhkloDFA/Sb7GuNoPNhG/Z7b4kJIQVq4mnTCvyvtXmGehMkDxTtHUg0HKPHUdvTG79+
         IKog==
X-Gm-Message-State: AOAM532UYHaAX8/TuMdD4RObxDwfGacbLpMnkcFI01cBE9cDixHWsVHq
        TdrUjJ0J2/paycRSpXf56OhUDg==
X-Google-Smtp-Source: ABdhPJz32HvfAg6KluA/KyEJBaaXAo0NZteHVXzJmGKrghlR6iadIKbzIU8Je/im80UePClykmrsKw==
X-Received: by 2002:a17:906:36da:: with SMTP id b26mr886534ejc.213.1642718634939;
        Thu, 20 Jan 2022 14:43:54 -0800 (PST)
Received: from [10.1.0.200] (external.oldum.net. [82.161.240.76])
        by smtp.googlemail.com with ESMTPSA id yy13sm1447749ejb.222.2022.01.20.14.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 14:43:54 -0800 (PST)
Message-ID: <29a54acefd1c37d9612613d5275e4bf51e62a704.camel@oldum.net>
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
From:   Nikolay Kichukov <nikolay@oldum.net>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Date:   Thu, 20 Jan 2022 23:43:46 +0100
In-Reply-To: <cover.1640870037.git.linux_oss@crudebyte.com>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the patches. I've applied them on top of 5.16.2 kernel and it
works for msize=1048576. Performance-wise, same throughput as the
previous patches, basically limiting factor is the backend block
storage.

However, when I mount with msize=4194304, the system locks up upon first
try to traverse the directory structure, ie 'ls'. Only solution is to
'poweroff' the guest. Nothing in the logs.

Qemu 6.0.0 on the host has the following patches:

01-fix-wrong-io-block-size-Rgetattr.patch
02-dedupe-iounit-code.patch
03-9pfs-simplify-blksize_to_iounit.patch

The kernel patches were applied on the guest kernel only.

I've generated them with the following command:
git diff 783ba37c1566dd715b9a67d437efa3b77e3cd1a7^..8c305df4646b65218978fc6474aa0f5f29b216a0 > /tmp/kernel-5.16-9p-virtio-drop-msize-cap.patch

The host runs 5.15.4 kernel.

Cheers,
-N

On Thu, 2021-12-30 at 14:23 +0100, Christian Schoenebeck wrote:
> This series aims to get get rid of the current 500k 'msize' limitation
> in
> the 9p virtio transport, which is currently a bottleneck for
> performance
> of 9p mounts.
> 
> To avoid confusion: it does remove the msize limit for the virtio
> transport,
> on 9p client level though the anticipated milestone for this series is
> now
> a max. 'msize' of 4 MB. See patch 8 for reason why.
> 
> This is a follow-up of the following series and discussion:
> https://lore.kernel.org/netdev/cover.1632327421.git.linux_oss@crudebyte.com/
> 
> Latest version of this series:
> https://github.com/cschoenebeck/linux/commits/9p-virtio-drop-msize-cap
> 
> 
> OVERVIEW OF PATCHES:
> 
> * Patch 1 is just a trivial info message for the user to know why his
> msize
>   option got ignored by 9p client in case the value was larger than
> what is
>   supported by this 9p driver.
> 
> * Patches 2..7 remove the msize limitation from the 'virtio' transport
>   (i.e. the 9p 'virtio' transport itself actually supports >4MB now,
> tested
>   successfully with an experimental QEMU version and some dirty 9p
> Linux
>   client hacks up to msize=128MB).
> 
> * Patch 8 limits msize for all transports to 4 MB for now as >4MB
> would need
>   more work on 9p client level (see commit log of patch 8 for
> details).
> 
> * Patches 9..12 tremendously reduce unnecessarily huge 9p message
> sizes and
>   therefore provide performance gain as well. So far, almost all 9p
> messages
>   simply allocated message buffers exactly msize large, even for
> messages
>   that actually just needed few bytes. So these patches make sense by
>   themselves, independent of this overall series, however for this
> series
>   even more, because the larger msize, the more this issue would have
> hurt
>   otherwise.
> 
> 
> PREREQUISITES:
> 
> If you are testing with QEMU then please either use latest QEMU 6.2
> release
> or higher, or at least apply the following patch on QEMU side:
> 
>  
> https://lore.kernel.org/qemu-devel/E1mT2Js-0000DW-OH@lizzy.crudebyte.com/
> 
> That QEMU patch is required if you are using a user space app that
> automatically retrieves an optimum I/O block size by obeying stat's
> st_blksize, which 'cat' for instance is doing, e.g.:
> 
>         time cat test_rnd.dat > /dev/null
> 
> Otherwise please use a user space app for performance testing that
> allows
> you to force a large block size and to avoid that QEMU issue, like
> 'dd'
> for instance, in that case you don't need to patch QEMU.
> 
> 
> KNOWN LIMITATION:
> 
> With this series applied I can run
> 
>   QEMU host <-> 9P virtio <-> Linux guest
> 
> with up to slightly below 4 MB msize [4186112 = (1024-2) * 4096]. If I
> try
> to run it with exactly 4 MB (4194304) it currently hits a limitation
> on
> QEMU side:
> 
>   qemu-system-x86_64: virtio: too many write descriptors in indirect
> table
> 
> That's because QEMU currently has a hard coded limit of max. 1024
> virtio
> descriptors per vring slot (i.e. per virtio message), see to do (1.)
> below.
> 
> 
> STILL TO DO:
> 
>   1. Negotiating virtio "Queue Indirect Size" (MANDATORY):
> 
>     The QEMU issue described above must be addressed by negotiating
> the
>     maximum length of virtio indirect descriptor tables on virtio
> device
>     initialization. This would not only avoid the QEMU error above,
> but would
>     also allow msize of >4MB in future. Before that change can be done
> on
>     Linux and QEMU sides though, it first requires a change to the
> virtio
>     specs. Work on that on the virtio specs is in progress:
> 
>     https://github.com/oasis-tcs/virtio-spec/issues/122
> 
>     This is not really an issue for testing this series. Just stick to
> max.
>     msize=4186112 as described above and you will be fine. However for
> the
>     final PR this should obviously be addressed in a clean way.
> 
>   2. Reduce readdir buffer sizes (optional - maybe later):
> 
>     This series already reduced the message buffers for most 9p
> message
>     types. This does not include Treaddir though yet, which is still
> simply
>     using msize. It would make sense to benchmark first whether this
> is
>     actually an issue that hurts. If it does, then one might use
> already
>     existing vfs knowledge to estimate the Treaddir size, or starting
> with
>     some reasonable hard coded small Treaddir size first and then
> increasing
>     it just on the 2nd Treaddir request if there are more directory
> entries
>     to fetch.
> 
>   3. Add more buffer caches (optional - maybe later):
> 
>     p9_fcall_init() uses kmem_cache_alloc() instead of kmalloc() for
> very
>     large buffers to reduce latency waiting for memory allocation to
>     complete. Currently it does that only if the requested buffer size
> is
>     exactly msize large. As patch 11 already divided the 9p message
> types
>     into few message size categories, maybe it would make sense to use
> e.g.
>     4 separate caches for those memory category (e.g. 4k, 8k, msize/2,
>     msize). Might be worth a benchmark test.
> 
> Testing and feedback appreciated!
> 
> v3 -> v4:
> 
>   * Limit msize to 4 MB for all transports [NEW patch 8].
> 
>   * Avoid unnecessarily huge 9p message buffers
>     [NEW patch 9] .. [NEW patch 12].
> 
> Christian Schoenebeck (12):
>   net/9p: show error message if user 'msize' cannot be satisfied
>   9p/trans_virtio: separate allocation of scatter gather list
>   9p/trans_virtio: turn amount of sg lists into runtime info
>   9p/trans_virtio: introduce struct virtqueue_sg
>   net/9p: add trans_maxsize to struct p9_client
>   9p/trans_virtio: support larger msize values
>   9p/trans_virtio: resize sg lists to whatever is possible
>   net/9p: limit 'msize' to KMALLOC_MAX_SIZE for all transports
>   net/9p: split message size argument into 't_size' and 'r_size' pair
>   9p: add P9_ERRMAX for 9p2000 and 9p2000.u
>   net/9p: add p9_msg_buf_size()
>   net/9p: allocate appropriate reduced message buffers
> 
>  include/net/9p/9p.h     |   3 +
>  include/net/9p/client.h |   2 +
>  net/9p/client.c         |  67 +++++++--
>  net/9p/protocol.c       | 154 ++++++++++++++++++++
>  net/9p/protocol.h       |   2 +
>  net/9p/trans_virtio.c   | 304 +++++++++++++++++++++++++++++++++++----
> -
>  6 files changed, 483 insertions(+), 49 deletions(-)
> 

