Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3C93B524A
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 08:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhF0GMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 02:12:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229678AbhF0GMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 02:12:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624774176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xjHjwF63ZoQwHIadC5M6yX3Nr9jz7iaPsOhpdvmf+n0=;
        b=J6cGJCZD7ACnG0ZvrNt7oTVr6XhVPKY1riVf1E3dYwYigKz5RPhYtXI2j4yYyUtoQ/EdMn
        w8vZW+r6HGypPUXIJ3H9pAA2/ZyCuBKVibdhUchWIY8QsEpNK7EcVzgU8eR2Mys0FEAOsB
        GA4t+lj6kH5YpJwm+Qm/zqiCs6ufTjw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-iIKlt5N_OlyTj4M1xH1bDQ-1; Sun, 27 Jun 2021 02:09:35 -0400
X-MC-Unique: iIKlt5N_OlyTj4M1xH1bDQ-1
Received: by mail-wm1-f70.google.com with SMTP id 13-20020a1c010d0000b02901eca51685daso1280091wmb.3
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 23:09:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xjHjwF63ZoQwHIadC5M6yX3Nr9jz7iaPsOhpdvmf+n0=;
        b=HHABOQeMBlqPuH5jTXuU2mzCCkfLDtlAXbT611dUOYnOLB7IKCBMkl0ilx8JY/INHk
         HdqxE9doD7kaOezOkD1n8Yu+856JTZEXv271wS0Cv2a4fsT09dgB49FQEK3kXO+PMvm5
         yEP2rA1NkXsxHuEzZsKkuere+r2SWqTysWC/OQGBfxcVa88tC62hbgiUdq4Zzd7jfIGG
         RclcyYO6j0gwUF2AFfPb02iVlo94bluwoXFrh8oQRGEi5+VB+48DzgvK2CFcJ2LxAwV+
         dnvK6HYt+KIBtql50pExEk+OiVZmsq7YCQxz+QdTkR6ZZFcsiwuldq47UpX7tYVlkXK6
         2LNw==
X-Gm-Message-State: AOAM532WzmQJbwJEuR32sgdl1Yp5a/Q5hdll0kLRxJCrgeM5kp3NPdjx
        uVKaPG4UJD16zeHVJq41FEELBdF0KO89iB08sWy/e8zhtxJQ4Xi1QuGhbtc1tiIDKOSq5XK2BY/
        U5olTYfBhfGdAVf/3
X-Received: by 2002:a1c:f314:: with SMTP id q20mr19827802wmq.154.1624774174061;
        Sat, 26 Jun 2021 23:09:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCwSkKSHaIrM4c2Dqi4H0HPnoa0ASoFbW0sX1z8cD7D60tAy63K3+RMc/z4JA5ZLb3KEW1yg==
X-Received: by 2002:a1c:f314:: with SMTP id q20mr19827782wmq.154.1624774173810;
        Sat, 26 Jun 2021 23:09:33 -0700 (PDT)
Received: from redhat.com ([77.126.198.14])
        by smtp.gmail.com with ESMTPSA id f22sm9635976wmb.46.2021.06.26.23.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 23:09:33 -0700 (PDT)
Date:   Sun, 27 Jun 2021 02:09:29 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jason Wang <jasowang@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, brouer@redhat.com, paulmck@kernel.org,
        peterz@infradead.org, will@kernel.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [PATCH net-next v2 1/2] selftests/ptr_ring: add benchmark
 application for ptr_ring
Message-ID: <20210627020746-mutt-send-email-mst@kernel.org>
References: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
 <1624591136-6647-2-git-send-email-linyunsheng@huawei.com>
 <ff47ed0b-332d-2772-d6e1-8277ac602c8c@redhat.com>
 <3ba4a6f1-2e1e-8c1a-6f47-5d182f05d1cd@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ba4a6f1-2e1e-8c1a-6f47-5d182f05d1cd@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 11:52:16AM +0800, Yunsheng Lin wrote:
> On 2021/6/25 11:36, Jason Wang wrote:
> > 
> > 在 2021/6/25 上午11:18, Yunsheng Lin 写道:
> >> Currently ptr_ring selftest is embedded within the virtio
> >> selftest, which involves some specific virtio operation,
> >> such as notifying and kicking.
> >>
> >> As ptr_ring has been used by various subsystems, it deserves
> >> it's owner's selftest in order to benchmark different usecase
> >> of ptr_ring, such as page pool and pfifo_fast qdisc.
> >>
> >> So add a simple application to benchmark ptr_ring performance.
> >> Currently two test mode is supported:
> >> Mode 0: Both enqueuing and dequeuing is done in a single thread,
> >>          it is called simple test mode in the test app.
> >> Mode 1: Enqueuing and dequeuing is done in different thread
> >>          concurrently, also known as SPSC(single-producer/
> >>          single-consumer) test.
> >>
> >> The multi-producer/single-consumer test for pfifo_fast case is
> >> not added yet, which can be added if using CAS atomic operation
> >> to enable lockless multi-producer is proved to be better than
> >> using r->producer_lock.
> >>
> >> Only supported on x86 and arm64 for now.
> >>
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >> ---
> >>   MAINTAINERS                                      |   5 +
> >>   tools/testing/selftests/ptr_ring/Makefile        |   6 +
> >>   tools/testing/selftests/ptr_ring/ptr_ring_test.c | 249 +++++++++++++++++++++++
> >>   tools/testing/selftests/ptr_ring/ptr_ring_test.h | 150 ++++++++++++++
> >>   4 files changed, 410 insertions(+)
> > 
> > 
> > Why can't you simply reuse tools/virtio/ringtest?
> 
> The main reason is stated in the commit log:
> "Currently ptr_ring selftest is embedded within the virtio
> selftest, which involves some specific virtio operation,
> such as notifying and kicking.
> 
> As ptr_ring has been used by various subsystems, it deserves
> it's owner's selftest in order to benchmark different usecase
> of ptr_ring, such as page pool and pfifo_fast qdisc."
> 
> More specificly in tools/virtio/ringtest/main.c and
> tools/virtio/ringtest/ptr_ring.c, there are a lot of operation
> related to virtio usecase, such as start_guest(), start_host(),
> poll_used(), notify() or kick() ....., so it makes more sense
> to add a generic selftest for ptr ring as it is not only used
> by virtio now.


Okay that answers why you didn't just run main.c
but why not add a new test under tools/virtio/ringtest/
reusing the rest of infrastructure that you currently copied?

> 
> > 
> > Thanks
> > 
> > 
> > .
> > 

