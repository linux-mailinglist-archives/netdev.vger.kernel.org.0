Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160776E8C71
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbjDTIOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbjDTIOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:14:04 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25FB35B5
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:13:55 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-63b4960b015so632226b3a.3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681978435; x=1684570435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9ATYIUW0VL5jv34KSuydy4tkMajLvSkNKzBXFZEi9c=;
        b=OGZhHQPc5teD2uiUoyEfyzXHywP8ztNA9qiK5ulhiP9T92wt4chvkk0ixf07oPyYmW
         Zh0VYFR6CMFYkGmVyTCh3IGDEkGoItnpHewcBsZKTqj+vwqPw+cvgiayMGsKaxSYT95E
         jz4zpwrFXp3aENZV//XLVwT77yVMxWWRE66w5zUnKoBafAbNvUmFc+hn17T4+a7VDp47
         i4D81ZIFmyxqFe1AUwnP8cl3sg044RN3tE3TjkVmmQJkr1Gegr60e6l9nB9EoCeYVSTP
         i6EtFNu+10Uy3YQudBttVWRE2aw0DhuWrqwPDvbH0/UH/uvo0aaVhF006oirARA3ZyWf
         tYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681978435; x=1684570435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X9ATYIUW0VL5jv34KSuydy4tkMajLvSkNKzBXFZEi9c=;
        b=ALaaifH6KaQnFZbRV/0pGm901+FlU8oYVYXFa9EGkJp0rq7FExSbhFKrrxs3x0y/PI
         PBBpQOCnzTjEL7P762yiR1utCOOpq+HTejy4kKSwj6Wlwt8YA330WkCaTZIemZfuYV9F
         j+xUokJ6WOhEc9YIp60i2d4oqatFe36Oam1OalFYKjQRJ/ecOc5LX7NMhZWXu6qFlVGK
         vaNk8pcnK3Pg6zF2D2aSXul5MUibHR6H8yNnP2zkDSsltvWssO0CrAfUZnDak0WtR7Y+
         s9lQh3sbem5uTTsJCwHUd4t+NfSyuwUT/hvsrKEVH24DAHXURfoula/wItJEf+cJEg0P
         sh2w==
X-Gm-Message-State: AAQBX9e9opmronNgCD+L4qVGoKFB1hcDxbBmkXWUocEabosL4a7sc91R
        IS8OUnlqymCyy/d+JOy9EHAWOj9dfa2xJOQM/vnq
X-Google-Smtp-Source: AKy350YMFBvd48ME7MOBmbabocXtQnwell8rcwMQhYjmK0urUPQvAFUg5BmSAFi9uHg1A7RpWw6twG3j5gCoZ9GAdgA=
X-Received: by 2002:a05:6a20:2590:b0:ef:279d:433d with SMTP id
 k16-20020a056a20259000b000ef279d433dmr999724pzd.61.1681978435184; Thu, 20 Apr
 2023 01:13:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230419134329.346825-1-maxime.coquelin@redhat.com>
In-Reply-To: <20230419134329.346825-1-maxime.coquelin@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 20 Apr 2023 16:13:42 +0800
Message-ID: <CACycT3tbQSFdADGiP-ijSj2ZjRctMsPmJQhEBygguzYOjA4Y9Q@mail.gmail.com>
Subject: Re: [RFC 0/2] vduse: add support for networking devices
To:     Maxime Coquelin <maxime.coquelin@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Marchand <david.marchand@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>, xuanzhuo@linux.alibaba.com,
        Eugenio Perez Martin <eperezma@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 9:44=E2=80=AFPM Maxime Coquelin
<maxime.coquelin@redhat.com> wrote:
>
> This small series enables virtio-net device type in VDUSE.
> With it, basic operation have been tested, both with
> virtio-vdpa and vhost-vdpa using DPDK Vhost library series
> adding VDUSE support [0] using split rings layout.
>
> Control queue support (and so multiqueue) has also been
> tested, but require a Kernel series from Jason Wang
> relaxing control queue polling [1] to function reliably.
>
> Other than that, we have identified a few gaps:
>
> 1. Reconnection:
>  a. VDUSE_VQ_GET_INFO ioctl() returns always 0 for avail
>     index, even after the virtqueue has already been
>     processed. Is that expected? I have tried instead to
>     get the driver's avail index directly from the avail
>     ring, but it does not seem reliable as I sometimes get
>     "id %u is not a head!\n" warnings. Also such solution
>     would not be possible with packed ring, as we need to
>     know the wrap counters values.
>

I'm not sure how to handle the reconnection in the vhost-user-net
case. Can we use a tmpfs file to track inflight I/O like this [1]

[1] https://qemu-project.gitlab.io/qemu/interop/vhost-user.html#inflight-i-=
o-tracking

>  b. Missing IOCTLs: it would be handy to have new IOCTLs to
>     query Virtio device status, and retrieve the config
>     space set at VDUSE_CREATE_DEV time.
>

VDUSE_GET_STATUS ioctl might be needed. Or can we use a tmpfs file to
save/restore that info.

> 2. VDUSE application as non-root:
>   We need to run the VDUSE application as non-root. There
>   is some race between the time the UDEV rule is applied
>   and the time the device starts being used. Discussing
>   with Jason, he suggested we may have a VDUSE daemon run
>   as root that would create the VDUSE device, manages its
>   rights and then pass its file descriptor to the VDUSE
>   app. However, with current IOCTLs, it means the VDUSE
>   daemon would need to know several information that
>   belongs to the VDUSE app implementing the device such
>   as supported Virtio features, config space, etc...
>   If we go that route, maybe we should have a control
>   IOCTL to create the device which would just pass the
>   device type. Then another device IOCTL to perform the
>   initialization. Would that make sense?
>

I think we can reuse the VDUSE_CREATE_DEV ioctl (just use name,
device_id and vendor_id) for control device here, and add a new ioctl
VDUSE_DEV_SETUP to do device initialization.

Thanks,
Yongji
