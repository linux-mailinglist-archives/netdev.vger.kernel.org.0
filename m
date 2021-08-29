Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929F73FADA8
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 20:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbhH2SM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 14:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhH2SM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 14:12:28 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCC4C061756
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:11:36 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id p38so26581674lfa.0
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nOEXbomGVxdTg2YIKOufPA0FWw0BA6Ntj3OHAW88ff4=;
        b=G9weGkeHN8FlJqJ0GQMGRkvYxT9+fXAmH0dB17bI65t7LV9Q70hlMMFtwZr4o4zSms
         C3ZBm+mpNRjS+UkmvFIj8dKgUWkyzIyP3SJa7hZUeOvoF9uuwyCa0eKl5/wXl5LDkYvt
         g1hC/0+a5me3A0DEW79RnUqRw17xLL0C1Ysgk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nOEXbomGVxdTg2YIKOufPA0FWw0BA6Ntj3OHAW88ff4=;
        b=Y/BtodGtcg7nB8IfZc+pgFYdi3Y5z44TjOD5tBi7eAilcryUKBotzTr5i9n5RfrHk/
         JBCa5pRcZrKjjMWyUsfZj9WMd4Y9yMrrIo2XzdyjeZg6lBE1LVe4c8x12fKekdpEZE85
         Z1u0d4Gi/l1v23Qx64FYf8PrzzOVQI2Gaqs+bvYxTImSt2j7z7MRbRhJu3hgVXXTGLJn
         GDaKO1YPmFWTLCOPHfr4/TBsguVQtI3/x8HyMm34VVFmEBAxNek5Wvd7qFk7n7y+i4tY
         M6HEjPWxsHlbp3A5JdVM50oD2gfMaGVVmk1wO+96PX/7ZXtFXgaavxsnZDkOsm6MVC79
         7log==
X-Gm-Message-State: AOAM530ai057+AhIkyhgm99hlBSFc6WQFf/Qe91mKTFvQIxPJpBzlQ2l
        dzbf08yRmD+OV1DR2ws6Oxmj0ZAWVtQIwP85
X-Google-Smtp-Source: ABdhPJwLFuWTKpreHY3tZeM4C6P/9aSHYgTNMklhTwMV5Kn/tw5VNWEs8eAsEOFxh8tWOiVlG4HHWA==
X-Received: by 2002:a05:6512:2205:: with SMTP id h5mr15025089lfu.398.1630260693827;
        Sun, 29 Aug 2021 11:11:33 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id y9sm1535906ljm.5.2021.08.29.11.11.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Aug 2021 11:11:31 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id l18so21709318lji.12
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:11:31 -0700 (PDT)
X-Received: by 2002:a2e:7d0e:: with SMTP id y14mr17065408ljc.251.1630260691346;
 Sun, 29 Aug 2021 11:11:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210829115343-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210829115343-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 29 Aug 2021 11:11:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjYkPWoQWZEHXzd3azugRO4MCCEx9dBYKkVJLrk+1gsMg@mail.gmail.com>
Message-ID: <CAHk-=wjYkPWoQWZEHXzd3azugRO4MCCEx9dBYKkVJLrk+1gsMg@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: a last minute fix
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 29, 2021 at 8:53 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> Donnu if it's too late - was on vacation and this only arrived
> Wednesday. Seems to be necessary to avoid introducing a regression
> in virtio-mem.

Heh. Not too late for 5.14, but too late in the sense that I had
picked this one up manually already as commit 425bec0032f5
("virtio-mem: fix sleeping in RCU read side section in
virtio_mem_online_page_cb()").

                Linus
