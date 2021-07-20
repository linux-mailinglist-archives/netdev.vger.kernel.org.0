Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CA53CF6AD
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 11:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbhGTIcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbhGTIbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 04:31:05 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C165EC061762;
        Tue, 20 Jul 2021 02:10:54 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id o72-20020a9d224e0000b02904bb9756274cso20958605ota.6;
        Tue, 20 Jul 2021 02:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p6Is2ssE5TIQVmIGiDn4GSKdJRhQ0anPapx4YCLQJX8=;
        b=saKX98KeWneAhyQVzO5iKzGFol/XtOEBdaIxSKXVRh9tGcKnrbNpRe2KRcIFNmurDQ
         M5BzlbGC+kZ8Nppkl61VyuwKm/HhSpZcTsR2CK+HOhdEqtfJdELZ6MH9PXVcVC7dlWNU
         LScRRBdZKQTC/lkPOAoWRvpwYHusb+1unMDn8nwAJyD78zLDM4R2vpsymo+7yxqhLcAy
         1eZbYf3F9WtugvGMsxoeOX4uGzJ10c9MJ/Y8IO8qHsFdgvcobUY395aVcdSnOrYmevy8
         x68W1HYItydrjD4fl1hROEqH6BKH0g8xpv+2lyI23MnzyS2q+4M7PAXAjS2crIBV9Gw5
         4Y3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p6Is2ssE5TIQVmIGiDn4GSKdJRhQ0anPapx4YCLQJX8=;
        b=ixPFSuy+Vl8dkUlDo3e1JyYuQlGBA9ccXm4J+HGJ8OJoRG61XgRQLv0HuTR/qLzNJ5
         uRVhecmwy05ESAIVTPVgchniaXSm++Ujlt4F0lcpyvQFUUQ0P5wjCmUT051MeRiR9AA0
         xMOQRBrRFoAPV4BEHPFQNdIYi1MLd3VdptiCNGg5KTuokand92qXUdmRFJ7rQZ9bbG0G
         4r6EUyiUo86llZujEGyhHD1Oyy9B6XJfD4WBVRJ+kWRlPrSMcR9KizMPU6Qn7JotuuJG
         8PdXXI2HG2Kq6JYOOlb2dJ5lEkzJnVbDiHcHHxiJWt/vCIjYwo9sY4ehTg/FTOAoUb60
         Fi0g==
X-Gm-Message-State: AOAM531rASAowhpkxm/OU+lCsAMNhsLI2/PVlcAbEJAQJb1h7dY6A7l1
        1LlUxREa7kEIilqhhfFyW/sAJMYJv5IBGUQgxx0=
X-Google-Smtp-Source: ABdhPJzy2gyhp2Ac5tFifphlRMk5DJqNOX1IEF1IwKJkNoFCxmsrUUevYLMMx8mXFAQ2CYIBubGyB/3ux8dj5lStF9A=
X-Received: by 2002:a9d:6d83:: with SMTP id x3mr3179843otp.110.1626772254143;
 Tue, 20 Jul 2021 02:10:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210719145317.79692-1-stephan@gerhold.net> <20210719145317.79692-5-stephan@gerhold.net>
In-Reply-To: <20210719145317.79692-5-stephan@gerhold.net>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 20 Jul 2021 12:10:42 +0300
Message-ID: <CAHNKnsTVSg5T_ZK3PQ50wuJydHbANFfpJd5NZ-71b1m3B_4dQg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 4/4] net: wwan: Add Qualcomm BAM-DMUX WWAN
 network driver
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Stephan,

On Mon, Jul 19, 2021 at 6:01 PM Stephan Gerhold <stephan@gerhold.net> wrote:
> The BAM Data Multiplexer provides access to the network data channels of
> modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916 or
> MSM8974. It is built using a simple protocol layer on top of a DMA engine
> (Qualcomm BAM) and bidirectional interrupts to coordinate power control.
>
> The modem announces a fixed set of channels by sending an OPEN command.
> The driver exports each channel as separate network interface so that
> a connection can be established via QMI from userspace. The network
> interface can work either in Ethernet or Raw-IP mode (configurable via
> QMI). However, Ethernet mode seems to be broken with most firmwares
> (network packets are actually received as Raw-IP), therefore the driver
> only supports Raw-IP mode.
>
> The driver uses runtime PM to coordinate power control with the modem.
> TX/RX buffers are put in a kind of "ring queue" and submitted via
> the bam_dma driver of the DMAEngine subsystem.
>
> The basic architecture looks roughly like this:
>
>                    +------------+                +-------+
>          [IPv4/6]  |  BAM-DMUX  |                |       |
>          [Data...] |            |                |       |
>         ---------->|rmnet0      | [DMUX chan: x] |       |
>          [IPv4/6]  | (chan: 0)  | [IPv4/6]       |       |
>          [Data...] |            | [Data...]      |       |
>         ---------->|rmnet1      |--------------->| Modem |
>                    | (chan: 1)  |      BAM       |       |
>          [IPv4/6]  | ...        |  (DMA Engine)  |       |
>          [Data...] |            |                |       |
>         ---------->|rmnet7      |                |       |
>                    | (chan: 7)  |                |       |
>                    +------------+                +-------+
>
> However, on newer SoCs/firmware versions Qualcomm began gradually moving
> to QMAP (rmnet driver) as backend-independent protocol for multiplexing
> and data aggegration. Some firmware versions allow using QMAP on top of
> BAM-DMUX (effectively resulting in a second multiplexing layer plus data
> aggregation). The architecture with QMAP would look roughly like this:
>
>            +-------------+           +------------+                  +-------+
>  [IPv4/6]  |    RMNET    |           |  BAM-DMUX  |                  |       |
>  [Data...] |             |           |            | [DMUX chan: 0]   |       |
> ---------->|rmnet_data1  |     ----->|rmnet0      | [QMAP mux-id: x] |       |
>            | (mux-id: 1) |     |     | (chan: 0)  | [IPv4/6]         |       |
>            |             |     |     |            | [Data...]        |       |
>  [IPv4/6]  | ...         |------     |            |----------------->| Modem |
>  [Data...] |             |           |            |       BAM        |       |
> ---------->|rmnet_data42 | [QMAP: x] |[rmnet1]    |   (DMA Engine)   |       |
>            | (mux-id: 42)| [IPv4/6]  |... unused! |                  |       |
>            |             | [Data...] |[rmnet7]    |                  |       |
>            |             |           |            |                  |       |
>            +-------------+           +------------+                  +-------+
>
> In this case, rmnet1-7 would remain unused. The firmware used on the most
> recent SoCs with BAM-DMUX even seems to announce only a single BAM-DMUX
> channel (rmnet0), which makes QMAP the only option for multiplexing there.
>
> So far the driver is mainly tested on various smartphones/tablets based on
> Qualcomm MSM8916/MSM8974 without QMAP. It looks like QMAP depends on a MTU
> negotiation feature in BAM-DMUX which is not yet supported by the driver.
>
> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> ---
> Note that this is my first network driver, so I apologize in advance
> if I made some obvious mistakes. :)
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

I am not very familiar with the Qualcomm protocols and am just curious
whether BAM-DMUX has any control (management) channels or only IPv4/v6
data channels?

The WWAN subsystem began as a framework for exporting management
interfaces (MBIM, AT, etc.) to user space. And then the network
interfaces (data channels) management interface was added to
facilitate management of devices with multiple data channels. That is
why I am curious about the BAM-DMUX device management interface or in
other words, how a user space application could control the modem
work?

> I could ignore QMAP completely for now but I think someone will show up
> who will need this eventually. And if there is going to be common code for
> QMAP/rmnet link management it would be nice if BAM-DMUX could also make
> use of it.
>
> But the question is, how could this look like? How do we know if we should
> create a link for QMAP or a BAM-DMUX channel? Does it even make sense
> to manage the 1-8 channels via the WWAN link management?
>
> Another problem is that the WWAN subsystem currently creates all network
> interfaces below the common WWAN device. This means that userspace like
> ModemManager has no way to check which driver provides them. This is
> necessary though to decide how to set it up via QMI (ModemManager uses it).
>
> For reference, example of the channels announced by firmwares on various SoCs:
>   - Qualcomm MSM8974: channel 0-7, QMAP not supported
>   - Qualcomm MSM8916: channel 0-7, QMAP usually supported, but not always
>                                    (depends on firmware version)
>   - Qualcomm MSM8937: channel 0 only, QMAP required for multiplexing(?)
>      (Note: This one is theoretic based on logs, this was not tested so far...)

-- 
Sergey
