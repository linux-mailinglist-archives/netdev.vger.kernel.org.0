Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E374B3D470F
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 12:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbhGXJlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 05:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbhGXJlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 05:41:39 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F33C061575;
        Sat, 24 Jul 2021 03:22:11 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id f20-20020a9d6c140000b02904bb9756274cso4634987otq.6;
        Sat, 24 Jul 2021 03:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aRoUv1wABabEGBHGqPIcqO0DCv1yalyroN2HGWm8Zyc=;
        b=ZpBG5Pth38l1GL8iZw9LT6YoGIh2Vig8EYSbVQbIqo3lsSK+Rb0k8O7UEMPdTUZ/4n
         CnXZNA4W5N6+BGBVH83xffazL9hQx65nvkeBgkgbcmZoKYY4xUes4Z5HMTk1e5kJfSUm
         kuBlcxCw9fLoPSH5qIFMfYOfMfDcb4490HpA3Zi8L80p/ZzL8ruYX3986d9jK54Wj2cv
         WCyXvoyRt/8xNYGw8q+Z9aR+fpuSPBdabA1CGaPmgWGw0cTtCH9gDRneYKNmtFSCNV7k
         5YTqzSFIDYtPh+MMWhFtbYIjDp++TNTljwL97B331mt5/O2V0amzUdzIMn3A+WXn0u0E
         Lo/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aRoUv1wABabEGBHGqPIcqO0DCv1yalyroN2HGWm8Zyc=;
        b=p3gXqNZtumkaCdnv74uerCVq4UlfaU8m5dzB2t0wRGNUJQE1PO8LKnDv5Mv6iSvmEc
         8Cd1C+c3nx9FIFItCfbs3tT9TZ6WPFGcYP0ah5G2SdENFoVyFeeNKlK9rtW9XGgOFcXV
         fTGaSG/NDD+fD5a6Ndy9Q8I8l5okrJxhK1XsqUYLxMKDUBuPFc1AltcKNn8NTk7ILVWd
         NxXae9wL/yM2zMOdhGPecqDPTBLqwue+GkCX9jseqhQWrcGwxv9Ep+7Oj2UhHOoPGZyK
         dVbmIl75BFjjDa3km8f14pmrrk2AbjR8cKw+7KAx2ad+aHLrfFkdpPdSWsJMxlX5enX0
         3uoA==
X-Gm-Message-State: AOAM531pxEC/GpuEhT2ah0jESCWDWehw4/oYEJsepynByL3PiuHvWttR
        WWg3A/PYgQ1EA0KJrdlZji6O1Ey6XQb12e2lCbM=
X-Google-Smtp-Source: ABdhPJyvCXh0jYmGBSOC0D0TYxIXw+zOnL0ZwXIXYQACqxrb4F0ld7fFvBJidMAWaiJja0NqDuBj0twE7d7V1H9aPJs=
X-Received: by 2002:a9d:3608:: with SMTP id w8mr5886963otb.371.1627122130908;
 Sat, 24 Jul 2021 03:22:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210719145317.79692-1-stephan@gerhold.net> <20210719145317.79692-5-stephan@gerhold.net>
 <CAHNKnsTVSg5T_ZK3PQ50wuJydHbANFfpJd5NZ-71b1m3B_4dQg@mail.gmail.com> <YPgQR/VbNVyxERnb@gerhold.net>
In-Reply-To: <YPgQR/VbNVyxERnb@gerhold.net>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 24 Jul 2021 13:22:21 +0300
Message-ID: <CAHNKnsQXb6H0Ee3sjbVi_UyED0UAXv7LK7mL1aKAG3SQtQ48ng@mail.gmail.com>
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

On Wed, Jul 21, 2021 at 3:17 PM Stephan Gerhold <stephan@gerhold.net> wrote:
> On Tue, Jul 20, 2021 at 12:10:42PM +0300, Sergey Ryazanov wrote:
>> On Mon, Jul 19, 2021 at 6:01 PM Stephan Gerhold <stephan@gerhold.net> wrote:
>>> The BAM Data Multiplexer provides access to the network data channels of
>>> modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916 or
>>> MSM8974. It is built using a simple protocol layer on top of a DMA engine
>>> (Qualcomm BAM) and bidirectional interrupts to coordinate power control.
>>>
>>> The modem announces a fixed set of channels by sending an OPEN command.
>>> The driver exports each channel as separate network interface so that
>>> a connection can be established via QMI from userspace. The network
>>> interface can work either in Ethernet or Raw-IP mode (configurable via
>>> QMI). However, Ethernet mode seems to be broken with most firmwares
>>> (network packets are actually received as Raw-IP), therefore the driver
>>> only supports Raw-IP mode.
>>>
>>> The driver uses runtime PM to coordinate power control with the modem.
>>> TX/RX buffers are put in a kind of "ring queue" and submitted via
>>> the bam_dma driver of the DMAEngine subsystem.
>>>
>>> The basic architecture looks roughly like this:
>>>
>>>                    +------------+                +-------+
>>>          [IPv4/6]  |  BAM-DMUX  |                |       |
>>>          [Data...] |            |                |       |
>>>         ---------->|rmnet0      | [DMUX chan: x] |       |
>>>          [IPv4/6]  | (chan: 0)  | [IPv4/6]       |       |
>>>          [Data...] |            | [Data...]      |       |
>>>         ---------->|rmnet1      |--------------->| Modem |
>>>                    | (chan: 1)  |      BAM       |       |
>>>          [IPv4/6]  | ...        |  (DMA Engine)  |       |
>>>          [Data...] |            |                |       |
>>>         ---------->|rmnet7      |                |       |
>>>                    | (chan: 7)  |                |       |
>>>                    +------------+                +-------+
>>>
>>> However, on newer SoCs/firmware versions Qualcomm began gradually moving
>>> to QMAP (rmnet driver) as backend-independent protocol for multiplexing
>>> and data aggegration. Some firmware versions allow using QMAP on top of
>>> BAM-DMUX (effectively resulting in a second multiplexing layer plus data
>>> aggregation). The architecture with QMAP would look roughly like this:
>>>
>>>            +-------------+           +------------+                  +-------+
>>>  [IPv4/6]  |    RMNET    |           |  BAM-DMUX  |                  |       |
>>>  [Data...] |             |           |            | [DMUX chan: 0]   |       |
>>> ---------->|rmnet_data1  |     ----->|rmnet0      | [QMAP mux-id: x] |       |
>>>            | (mux-id: 1) |     |     | (chan: 0)  | [IPv4/6]         |       |
>>>            |             |     |     |            | [Data...]        |       |
>>>  [IPv4/6]  | ...         |------     |            |----------------->| Modem |
>>>  [Data...] |             |           |            |       BAM        |       |
>>> ---------->|rmnet_data42 | [QMAP: x] |[rmnet1]    |   (DMA Engine)   |       |
>>>            | (mux-id: 42)| [IPv4/6]  |... unused! |                  |       |
>>>            |             | [Data...] |[rmnet7]    |                  |       |
>>>            |             |           |            |                  |       |
>>>            +-------------+           +------------+                  +-------+
>>>
>>> In this case, rmnet1-7 would remain unused. The firmware used on the most
>>> recent SoCs with BAM-DMUX even seems to announce only a single BAM-DMUX
>>> channel (rmnet0), which makes QMAP the only option for multiplexing there.
>>>
>>> So far the driver is mainly tested on various smartphones/tablets based on
>>> Qualcomm MSM8916/MSM8974 without QMAP. It looks like QMAP depends on a MTU
>>> negotiation feature in BAM-DMUX which is not yet supported by the driver.
>>>
>>> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
>>> ---
>>> Note that this is my first network driver, so I apologize in advance
>>> if I made some obvious mistakes. :)
>>>
>>> I'm not sure how to integrate the driver with the WWAN subsystem yet.
>>> At the moment the driver creates network interfaces for all channels
>>> announced by the modem, it does not make use of the WWAN link management
>>> yet. Unfortunately, this is a bit complicated:
>>>
>>> Both QMAP and the built-in multiplexing layer might be needed at some point.
>>> There are firmware versions that do not support QMAP and the other way around
>>> (the built-in multiplexing was disabled on very recent firmware versions).
>>> Only userspace can check if QMAP is supported in the firmware (via QMI).
>>
>> I am not very familiar with the Qualcomm protocols and am just curious
>> whether BAM-DMUX has any control (management) channels or only IPv4/v6
>> data channels?
>>
>> The WWAN subsystem began as a framework for exporting management
>> interfaces (MBIM, AT, etc.) to user space. And then the network
>> interfaces (data channels) management interface was added to
>> facilitate management of devices with multiple data channels. That is
>> why I am curious about the BAM-DMUX device management interface or in
>> other words, how a user space application could control the modem
>> work?
>
> Sorry for the confusion! It's briefly mentioned in the Kconfig option
> but I should have made this more clear in the commit message. It was so
> long already that I wasn't sure where to put it. :)
>
> BAM-DMUX does not have any control channels. Instead I use it together
> with the rpmsg_wwan_ctrl driver [1] that I already submitted for 5.14.
> The control/data channels are pretty much separate in this setup and
> don't have much to do with each other.
>
> I also had a short overview of some of the many different modem
> protocols Qualcomm has come up with in a related RFC for that driver,
> see [2] if you are curious.
>
> I hope that clarifies some things, please let me know if I should
> explain something better! :)
>
> [1]: https://lore.kernel.org/netdev/20210618173611.134685-3-stephan@gerhold.net/
> [2]: https://lore.kernel.org/netdev/YLfL9Q+4860uqS8f@gerhold.net/

Many thanks for such informative clarification, especially for
pointing me to  the rpmsg_wwan_ctrl driver. I saw it, but by a some
reason I did not link it to BAM-DMUX. Reading these links in
conjunction with your parallel talks make the situation much more
clear. I could not say that "I know kung fu", but I can say that now I
know how complex kung fu is.

--
Sergey
