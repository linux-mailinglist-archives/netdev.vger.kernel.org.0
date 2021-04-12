Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D7135CE56
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343784AbhDLQnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344434AbhDLQjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 12:39:55 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A94EC061233
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 09:31:37 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id d15so1762897qkc.9
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 09:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V39vJ8+XVZOqX4DC+GK6mHC3DoQ8P1rhNExHTLfMMDQ=;
        b=uiYtZ1u5gdlXqwa4kFIKxKi1xzGWk5yJe1/Qd7SHyDkWQq7UOP0ZwHhsSF7Jkhvb5S
         KbazOecqj+jVITras+qBfh9rnLwJhx48YzLmRVqLILlz0KIwNSau9tre/w2Q6dq5IQVr
         MBKlXG7ZRn171tNrCiM2vi2phMyqKWuLJseGEozK2h63hx3w4KGOHS9KtA+yaqwfS3u7
         PZGd7ScQwI6tZC5gDbH9QEt9Px1Gxk32WvDKpK9AfpUib/MprbthIOBULf7ahcNWmEQa
         KnVTxkWI43E6XK3F7nzB7vTOWB8pXM8upSJkpFToLvM7JMjbs66szOkweu24a/3OWcnI
         AjLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V39vJ8+XVZOqX4DC+GK6mHC3DoQ8P1rhNExHTLfMMDQ=;
        b=GuIhJtHUNuxHGXRo5x7h5uMSC6dhKUlTD3aOJhmfezVfWWz7ucER/KPA6YfkijjfqI
         yc86MRTJetnOPNDw3skl0vfszLsMXhefExXrQh+qclbecx7MWWmNtxTg24FsGJFaG/70
         T4fQWnpYuptVjtySQ6EwtXa9c+/DYRYAgidZAifBK/yeH3MxTvIJGjiWotVM4wwT8xe0
         PvaM7xC0+OOEGo1EBvMdt4kNxN4gTPc92Jl2vlNB3ZzqMHpZQsk0zOqBtXRPs21x9xlL
         +mhEGrdSqCiPrZqzFCOvMi7G55NLxfGyzuDAKYE9EgLVfdP77DrZZTDAaT/lOgTIWmbo
         4Y2A==
X-Gm-Message-State: AOAM530KjbCrRUiNVt7b59j5MLGIJD+xUrmThkQDSUU6fgBFdu9hCeVR
        wXSHZYD6fb5p4buv39n/H0GCLhDXgDfUvMcIKJwasw==
X-Google-Smtp-Source: ABdhPJzodwso6LxIhV15Rw93CnWB+kC+2pa/49ZcK4vho4iGkN5DQnTRTjwWMTzkTlPfisGvmYCs3LGlXD7MxAIZngc=
X-Received: by 2002:a25:4244:: with SMTP id p65mr10068345yba.452.1618245096298;
 Mon, 12 Apr 2021 09:31:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiHGchP=V=a4DbDN+imjGEc=2nvuLQVoeNXNxjpU1T8pg@mail.gmail.com>
 <20210412051445.GA47322@roeck-us.net> <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
In-Reply-To: <CAHk-=whYcwWgSPxuu8FxZ2i_cG7kw82m-Hbj0-67C6dk1Wb0tQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 12 Apr 2021 18:31:25 +0200
Message-ID: <CANn89iK2aUESa6DSG=Y4Y9tPmPW2weE05AVpxnDbqYwQjFM2Vw@mail.gmail.com>
Subject: Re: Linux 5.12-rc7
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 6:28 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, Apr 11, 2021 at 10:14 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > Qemu test results:
> >         total: 460 pass: 459 fail: 1
> > Failed tests:
> >         sh:rts7751r2dplus_defconfig:ata:net,virtio-net:rootfs
> >
> > The failure bisects to commit 0f6925b3e8da ("virtio_net: Do not pull payload in
> > skb->head"). It is a spurious problem - the test passes roughly every other
> > time. When the failure is seen, udhcpc fails to get an IP address and aborts
> > with SIGTERM. So far I have only seen this with the "sh" architecture.
>
> Hmm. Let's add in some more of the people involved in that commit, and
> also netdev.
>
> Nothing in there looks like it should have any interaction with
> architecture, so that "it happens on sh" sounds odd, but maybe it's
> some particular interaction with the qemu environment.

Yes, maybe.

I spent few hours on this, and suspect a buggy memcpy() implementation
on SH, but this was not conclusive.

By pulling one extra byte, the problem goes away.

Strange thing is that the udhcpc process does not go past sendto().
