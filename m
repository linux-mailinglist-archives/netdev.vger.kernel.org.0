Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEC8323131
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 20:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbhBWTOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 14:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhBWTOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 14:14:45 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39961C061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 11:14:05 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id d2so27045840edq.10
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 11:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LRyWoeuvYI6b9kccGVyJGial42rq2A+y7eUcdElFOUc=;
        b=QSMsMQr7lTL6E+gmYRiiNLixKP9rJV1636JbjSak1OZC5ogxu4FBe+QaGgn1LhHRAi
         +UeqwH2pPUz2M2BBft4nuhnzaAnujfxvWU+YhbFqw0GsmtSzj4gMb9GEpD+0fHhI2Q2s
         MnE39qX7ju2e/so3TgVe9KiqRxUsnhfykx+sNoJrkEk4fIQFwq0lhQxvY3VoN1fzbyZL
         LZvt7TXoCz3VLivwxjHXy1AmQ38Q/LXC2AhXKZxuqGevdlr3YjAT07e+mFo1PqDAGRxd
         YF8/fixLn1Z27/hfxde1bHDtP+XUQ9d+Xs7RCrA0nG9iL3XmrKjcYX4srQotg6VAPYyk
         bqzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LRyWoeuvYI6b9kccGVyJGial42rq2A+y7eUcdElFOUc=;
        b=nKJEpSaxUqkjqmLv+61TDrid+rT+C92Q1eqArR32B8vZy7Bo1UZGqKvhkEhd/Z592y
         fed1AjeRykG7FYhS8UAjFD16gUT5zGAbFmLfHCZGzl9Bs3HsgrELKv/141fI2374w/HS
         KSGWhDctzuwh8o3YW13vv3X5gjHzplhs3LrUTQEYcoaALoopYeCDHV9VFMO3RD6blxBY
         dQXwohMZDWKq9/3H92PBknZAT5Zp0yvEweJf0oNNqBwQWTUe8pBRSfuy5T4k3cW5MoZj
         fMAnD5tM1lau30c5Gxb9iF4tLZWMP/G0h4nKAFsihpziTjSonshJTD9PVG+otbtovmpS
         DWjQ==
X-Gm-Message-State: AOAM531elafQRpw1H43YSJH2Lx7g3VZpRc36LmatiB7XYktDwQSy6AO8
        ZThn/SuqTjhr4rm4f3CDTjy7TxXDjaM=
X-Google-Smtp-Source: ABdhPJyCSiOHk885CiIP4h8MR/6tPTkZZ6teUzVfG5NWlxZ3S1LDSIg93VAzohCFnNz/PQfyWfojVg==
X-Received: by 2002:a05:6402:4252:: with SMTP id g18mr30366462edb.231.1614107643611;
        Tue, 23 Feb 2021 11:14:03 -0800 (PST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id bs3sm13585165edb.46.2021.02.23.11.14.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 11:14:03 -0800 (PST)
Received: by mail-wr1-f41.google.com with SMTP id u14so23721988wri.3
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 11:14:02 -0800 (PST)
X-Received: by 2002:a5d:6cab:: with SMTP id a11mr318545wra.419.1614107642214;
 Tue, 23 Feb 2021 11:14:02 -0800 (PST)
MIME-Version: 1.0
References: <20210220014436.3556492-1-weiwan@google.com> <20210223092434-mutt-send-email-mst@kernel.org>
 <CAEA6p_DDTnbhP2TXsScthnHuaHDW4gSOETwVPRz4uqcmbuDeUg@mail.gmail.com>
In-Reply-To: <CAEA6p_DDTnbhP2TXsScthnHuaHDW4gSOETwVPRz4uqcmbuDeUg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 23 Feb 2021 14:13:24 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfTEoba-M43MkoQbqC09aa+TFGVWKvVRJqUifEkpDrFSw@mail.gmail.com>
Message-ID: <CA+FuTSfTEoba-M43MkoQbqC09aa+TFGVWKvVRJqUifEkpDrFSw@mail.gmail.com>
Subject: Re: [PATCH net v2 0/2] virtio-net: suppress bad irq warning for tx napi
To:     Wei Wang <weiwan@google.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 12:37 PM Wei Wang <weiwan@google.com> wrote:
>
> On Tue, Feb 23, 2021 at 6:26 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Fri, Feb 19, 2021 at 05:44:34PM -0800, Wei Wang wrote:
> > > With the implementation of napi-tx in virtio driver, we clean tx
> > > descriptors from rx napi handler, for the purpose of reducing tx
> > > complete interrupts. But this could introduce a race where tx complete
> > > interrupt has been raised, but the handler found there is no work to do
> > > because we have done the work in the previous rx interrupt handler.
> > > This could lead to the following warning msg:
> > > [ 3588.010778] irq 38: nobody cared (try booting with the
> > > "irqpoll" option)
> > > [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> > > 5.3.0-19-generic #20~18.04.2-Ubuntu
> > > [ 3588.017940] Call Trace:
> > > [ 3588.017942]  <IRQ>
> > > [ 3588.017951]  dump_stack+0x63/0x85
> > > [ 3588.017953]  __report_bad_irq+0x35/0xc0
> > > [ 3588.017955]  note_interrupt+0x24b/0x2a0
> > > [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> > > [ 3588.017957]  handle_irq_event+0x3b/0x60
> > > [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> > > [ 3588.017961]  handle_irq+0x20/0x30
> > > [ 3588.017964]  do_IRQ+0x50/0xe0
> > > [ 3588.017966]  common_interrupt+0xf/0xf
> > > [ 3588.017966]  </IRQ>
> > > [ 3588.017989] handlers:
> > > [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> > > [ 3588.025099] Disabling IRQ #38
> > >
> > > This patch series contains 2 patches. The first one adds a new param to
> > > struct vring_virtqueue to control if we want to suppress the bad irq
> > > warning. And the second patch in virtio-net sets it for tx virtqueues if
> > > napi-tx is enabled.
> >
> > I'm going to be busy until March, I think there should be a better
> > way to fix this though. Will think about it and respond in about a week.
> >
> OK. Thanks.

Yes, thanks for helping to think about a solution.

The warning went unreported for years. I'm a bit hesitant to make
actual datapath changes to suppress it, if those may actually have a
higher risk of regressions for some workloads.

Unless they actually might show a clear progression. Which may very
well be possible given the high spurious interrupt rate.

But the odd thing is that by virtue of the interrupt getting masked
once the warning hits, it may actually be difficult to improve on the
efficiency today.

As you pointed out, just probabilistically throttling how often to
steal work from the rx interrupt handler would be another low risk
approach to reduce the incidence rate.

Anyway, definitely no rush. This went unreported for a long time.
