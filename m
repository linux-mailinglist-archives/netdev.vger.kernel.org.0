Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178B63CE3D7
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 18:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbhGSPko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 11:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348945AbhGSPfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 11:35:36 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11C6C0A88D1
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 08:24:50 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id i16so1855315pgi.9
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 08:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MkKhttHk1f1NxvEjszFkNPRaTR2uQK8NNQrR3I9+ckM=;
        b=lMJZcOx6oA7r1fitEX6eCxK880OIlVRr2rH/LT49CPkL3ITNjZ/NPY6N6YmEwBHwT3
         FvHe3PgnV5SmlS1oG+8cBvE4+Ow59gFX5xochDQ0tRZVdhxPkXYAGcvV+V2yUQ9RJ0mn
         rYE0k/MGE6B7F8wRUS0zf/CmcLnsn058kUgZ9piS6aoX9r9HqLAdmLXb+CJFcpkHJbB+
         92gVu13ylQzRpowsNN5al1KOXpfCMNxK01aZYtS/LArebMSTZuAuxu4kgMY2mbJsQ3oG
         2nw2HqhJ3AOly/2NQwRte8o2k+GcV3HlcpyrAZpCRq+GS5E5VtevVrYO6A+Y6Y9FVGPf
         B2yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MkKhttHk1f1NxvEjszFkNPRaTR2uQK8NNQrR3I9+ckM=;
        b=EZIpbgE3BFw21LPFobdRn9KKCmx+EWbc1wLq0b6fVPwuUwLVgj/lBsliPzj9V8N3bl
         sHJTBJh0oOQ7xLx3lR4L1wgpD4tpUry1lpwUJf9t4Ryft2kgxuTnTLgXw9CCeNiZaoUQ
         6UD/SZQi8lWcS1viJ9qhZaN4AadRE22lQnBVCZeVPVc2+kahICRPOuS73ytBWbtrTaPT
         5iAuSDhjYVTbOCtC6uNeWb8GD3z2QoY5eav760F8tioNv63GvAOzQWPUg/CTHfoI/DLw
         Lcd/RkufuIiu3+b8mwCQP1XdRGC/xLhY+yl/mASwGVb1uXWJAWGV7gEt1/QiSevMJQRv
         lLoQ==
X-Gm-Message-State: AOAM530mX+cDuk5gKtHFqLZCN3IjoHodwp0C7hhK3fGT232ybtN3ANk5
        sUYRGWLDJkkbPtsuOP4WgpPj4K5NSTWfYm8a7ArLyA==
X-Google-Smtp-Source: ABdhPJwbPHFgosVLoCqok1vM0WItXj22KFp9TT5+FAelCfh+WtA7xCqRRbbFZHLQm+9yVwk+v+LDH1QIUgp0c6MCGLs=
X-Received: by 2002:a63:3107:: with SMTP id x7mr17715236pgx.303.1626709896370;
 Mon, 19 Jul 2021 08:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210719145317.79692-1-stephan@gerhold.net> <20210719145317.79692-5-stephan@gerhold.net>
In-Reply-To: <20210719145317.79692-5-stephan@gerhold.net>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 19 Jul 2021 18:01:33 +0200
Message-ID: <CAMZdPi8oxRMo0erfd0wrUPzD2UsbexoR=86u2N75Fd9RpXHoKg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 4/4] net: wwan: Add Qualcomm BAM-DMUX WWAN
 network driver
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        dmaengine@vger.kernel.org, devicetree <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephan,


On Mon, 19 Jul 2021 at 17:01, Stephan Gerhold <stephan@gerhold.net> wrote:
>
> I'm not sure how to integrate the driver with the WWAN subsystem yet.
> At the moment the driver creates network interfaces for all channels
> announced by the modem, it does not make use of the WWAN link management
> yet. Unfortunately, this is a bit complicated:
>
> Both QMAP and the built-in multiplexing layer might be needed at some point.
> There are firmware versions that do not support QMAP and the other way around
> (the built-in multiplexing was disabled on very recent firmware versions).
> Only userspace can check if QMAP is supported in the firmware (via QMI).
>
> I could ignore QMAP completely for now but I think someone will show up
> who will need this eventually. And if there is going to be common code for
> QMAP/rmnet link management it would be nice if BAM-DMUX could also make
> use of it.

I have this on my TODO list for mhi-net QMAP.

> But the question is, how could this look like? How do we know if we should
> create a link for QMAP or a BAM-DMUX channel? Does it even make sense
> to manage the 1-8 channels via the WWAN link management?

Couldn't it be specified via dts (property or different compatible
string)? would it make sense to have two drivers (with common core) to
manage either the multi-bam channel or newer QMAP based single
bam-channel modems.

>
> Another problem is that the WWAN subsystem currently creates all network
> interfaces below the common WWAN device. This means that userspace like
> ModemManager has no way to check which driver provides them. This is
> necessary though to decide how to set it up via QMI (ModemManager uses it).

Well, I have quite a similar concern since I'm currently porting
mhi-net mbim to wwan framework, and I was thinking about not making
wwan device parent of the network link/netdev (in the same way as
wlan0 is not child of ieee80211 device), but not sure if it's a good
idea or not since we can not really consider driver name part of the
uapi.

The way links are created is normally abstracted, so if you know which
bam variant you have from wwan network driver side (e.g. via dts), you
should have nothing to check on the user side, except the session id.

Regards,
Loic
