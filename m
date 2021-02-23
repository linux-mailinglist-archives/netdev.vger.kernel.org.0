Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB956322FBF
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 18:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbhBWRin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 12:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbhBWRih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 12:38:37 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A364CC061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 09:37:57 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id p193so17329419yba.4
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 09:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X73l9lKbpMPUfO2EuT47sWni6nbGRYBfE5EF1BFcCRM=;
        b=b1DjMrIiyFCbzLcOZxMZ1CQ/33DTTi9f9nOQY2ovakN9RgieuXMOlo/8yv/dg7wla0
         Pytnbft41QjvbxrDY2lfQwa8rmJCv+sbaw03gEWJKDpJCq+AObMSDlfFJjGksMKqoM/T
         g47DZXzh3vfyolliZBwENvo8OyX2Qx7iLPv0HbObIRqa9kUuY8daPzSw98qLQr1LjHce
         Fe4zazG43pHlY1TKkjU6KM10hFp9X8JCmZ233ogS7nyVQjNpvdRTwkppfpyXCVndJ4R7
         mgtLVNlvvbHteTJk031KT+1wgsTVde3AnE4mI8YlQydaBX/01tKTYIguttLEydDv1Ggh
         ucvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X73l9lKbpMPUfO2EuT47sWni6nbGRYBfE5EF1BFcCRM=;
        b=uk9jfYPa0PMjmIisWi2xMPnQfLG8Z6m1g8yMBzfLcq2wUU2unS4QmWm6GKV/EEThc6
         OFfeBKjKLJWoGf4gbtcDnk7gh5FOeEBalbgEp8dnOgGpaIGWbPFD/vRE8aatHUh0GNks
         7fKNLzdgP2SK52ZIayk7EDk9W/70WGTFJyu/btQJnx2q3Yyg9guBhYVn2o0U7W3gkj7W
         vgSaeKyZarTH19Pvc7Z87GKQag27NtF0v9TqnBbUHRHLWJVcxat8g162ylrMk9tWlwEK
         Q7+9rHyDFlAuf1yn52kWdD8WX7OA/V130q97RYOpBMIjpb3WYi3t1lc6xM+ccqosPErw
         l0AA==
X-Gm-Message-State: AOAM530VWDDfmPkuM4APQqngWoO+z5RKwR39U1G+K2Ko9toFki/UtG3w
        JYMpvkFwykxJSY+Fze7a/fYhL982u38zzwAFm1sScg==
X-Google-Smtp-Source: ABdhPJw7XFxIioyrBXwiIo5xQPvU72BspvYXVHxrAnCl4t+esTfk+eA3CQGY99KaTnF7LLrAW+nmAcKDT+qKCF5x6OM=
X-Received: by 2002:a25:d016:: with SMTP id h22mr42292524ybg.278.1614101876795;
 Tue, 23 Feb 2021 09:37:56 -0800 (PST)
MIME-Version: 1.0
References: <20210220014436.3556492-1-weiwan@google.com> <20210223092434-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210223092434-mutt-send-email-mst@kernel.org>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 23 Feb 2021 09:37:45 -0800
Message-ID: <CAEA6p_DDTnbhP2TXsScthnHuaHDW4gSOETwVPRz4uqcmbuDeUg@mail.gmail.com>
Subject: Re: [PATCH net v2 0/2] virtio-net: suppress bad irq warning for tx napi
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 6:26 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Feb 19, 2021 at 05:44:34PM -0800, Wei Wang wrote:
> > With the implementation of napi-tx in virtio driver, we clean tx
> > descriptors from rx napi handler, for the purpose of reducing tx
> > complete interrupts. But this could introduce a race where tx complete
> > interrupt has been raised, but the handler found there is no work to do
> > because we have done the work in the previous rx interrupt handler.
> > This could lead to the following warning msg:
> > [ 3588.010778] irq 38: nobody cared (try booting with the
> > "irqpoll" option)
> > [ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
> > 5.3.0-19-generic #20~18.04.2-Ubuntu
> > [ 3588.017940] Call Trace:
> > [ 3588.017942]  <IRQ>
> > [ 3588.017951]  dump_stack+0x63/0x85
> > [ 3588.017953]  __report_bad_irq+0x35/0xc0
> > [ 3588.017955]  note_interrupt+0x24b/0x2a0
> > [ 3588.017956]  handle_irq_event_percpu+0x54/0x80
> > [ 3588.017957]  handle_irq_event+0x3b/0x60
> > [ 3588.017958]  handle_edge_irq+0x83/0x1a0
> > [ 3588.017961]  handle_irq+0x20/0x30
> > [ 3588.017964]  do_IRQ+0x50/0xe0
> > [ 3588.017966]  common_interrupt+0xf/0xf
> > [ 3588.017966]  </IRQ>
> > [ 3588.017989] handlers:
> > [ 3588.020374] [<000000001b9f1da8>] vring_interrupt
> > [ 3588.025099] Disabling IRQ #38
> >
> > This patch series contains 2 patches. The first one adds a new param to
> > struct vring_virtqueue to control if we want to suppress the bad irq
> > warning. And the second patch in virtio-net sets it for tx virtqueues if
> > napi-tx is enabled.
>
> I'm going to be busy until March, I think there should be a better
> way to fix this though. Will think about it and respond in about a week.
>
OK. Thanks.

>
> > Wei Wang (2):
> >   virtio: add a new parameter in struct virtqueue
> >   virtio-net: suppress bad irq warning for tx napi
> >
> >  drivers/net/virtio_net.c     | 19 ++++++++++++++-----
> >  drivers/virtio/virtio_ring.c | 16 ++++++++++++++++
> >  include/linux/virtio.h       |  2 ++
> >  3 files changed, 32 insertions(+), 5 deletions(-)
> >
> > --
> > 2.30.0.617.g56c4b15f3c-goog
>
