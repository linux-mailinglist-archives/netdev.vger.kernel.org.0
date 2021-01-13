Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6926E2F529E
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 19:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbhAMSok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 13:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728226AbhAMSok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 13:44:40 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB903C06179F
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 10:43:59 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id by27so3028597edb.10
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 10:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vanguardiasur-com-ar.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/KzoTFWjybD/r1NtUndSBUsrUMAZKtv7j5VbLpYXnf8=;
        b=icWSwC1XH5N1j1UsZ/I7yXSO2Bv9DrpZ/ESFacPkPRQgTp1eWA3+zVHPoxj1Qm0SZX
         XRmJOUOfeW4HsHiyTLtZmqOSXY/m2eUjdfixjihZpMeSaqGcuWYhqnxqnvwOOZQrIT6/
         KWKbi8bS8cgWIac6Ielih93TzACXUza3NWz+BdUlAfelqSaboZMEi3b9UijIKTxG/ysB
         BrB7pQ62DDbb4S1PBE5RiK2aJ9jt+jZTDZDDicAVmK//PhpUpYfU83v1YvwC7kS8NMea
         rzlX1xEID3oVPCpG/GkZr696RfGGJIFIhYmsAT52lmQWh/8Gwmv8rp2AYDaSJvskvdnd
         loSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/KzoTFWjybD/r1NtUndSBUsrUMAZKtv7j5VbLpYXnf8=;
        b=qpBAkPGXE8QoANmrqe7cXnnVxS/oU+XeG95G4rs1ZEiPYL4J8eid5TQmn1B1ImEB/1
         KY0D1dt8PU1635jTQDCDaucMLny9860q5JqC4vS99WqFmkgou8q7Va35UIRGNvni/RKU
         B/F5DbcuQX92CkXPJA6LZeDgiEZHxAquzycGJbn4SzlsFXCg0RHM0+5yQbK3dh+iopfe
         cY+ac43s2bv9P7epZ45ql2pRYlrZNtlsg/WPzcJ2AvjGg5bjQyleU4p/gbX/rXRVzW69
         oftjkCV1acAJGkWtJoUcQ6df1FU5ZYqLasBRfT3deYDcEM5h1B01O0ua0Il8dCJ5KyDk
         L6sA==
X-Gm-Message-State: AOAM531m72u4JI3tkVikFbWSFracy6Os+v3Hy+GNSkM6p77aasFOodw1
        03UF1cLV9mZFNp8TfhDls3WdVhm38bph0fYYPbk06Q==
X-Google-Smtp-Source: ABdhPJz7yGlfZHsDJZRnLziMXfyryL2sAq76aj1N0CBiX2AVdhW2jODpzHCel2BFEEJKxOfntxde1pCc+7MHDoiPUdo=
X-Received: by 2002:aa7:cf8f:: with SMTP id z15mr2930266edx.17.1610563437312;
 Wed, 13 Jan 2021 10:43:57 -0800 (PST)
MIME-Version: 1.0
References: <20190208132954.28166-1-andrejs.cainikovs@netmodule.com>
In-Reply-To: <20190208132954.28166-1-andrejs.cainikovs@netmodule.com>
From:   Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date:   Wed, 13 Jan 2021 15:43:46 -0300
Message-ID: <CAAEAJfBWMWuuVebLjURJE=+UtJ8OQxXtEiPWKeQMgQTJ5rivfA@mail.gmail.com>
Subject: Re: [PATCH 0/2] D_CAN RX buffer size improvements
To:     Andrejs Cainikovs <Andrejs.Cainikovs@netmodule.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick Zysset <Patrick.Zysset@netmodule.com>,
        "Federico Rossi (fede.a.rossi@gmail.com)" <fede.a.rossi@gmail.com>,
        Max Sonnaillon <Max.Sonnaillon@ppst.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

This series was recently brought to my attention, in connection to a
long-standing
packet drop issue that we had on a Sitara-based product.

I haven't tested this personally, but I've been notified that this was
backported
to the v4.19 kernel, and the packet drop was fixed.

It seems the series never managed to get upstreamed,
but I think this should be resurrected and merged (probably with after
some cleanup/review).

Thanks,
Ezequiel

On Fri, 8 Feb 2019 at 10:31, Andrejs Cainikovs
<Andrejs.Cainikovs@netmodule.com> wrote:
>
> Re-sending entire patchset due to missed cover letter, sorry.
>
> This patchset introduces support for 64 D_CAN message objects with an option of
> unequal split between RX/TX.
>
> The rationale behind this is that there are lots of frame loss on higher bus
> speeds. Below are test results from my custom Sitara AM3352 based board:
>
>   Sender: timeout 15m cangen can0 -g 0 -i x
>   Target: candump can0,0~0,#FFFFFFFF -td -c -d -e
>
>   * Without patches:
>     - 15 minute RX test, 500kbps
>     - 16 RX / 16 TX message objects
>     - 77 received frames lost out of 4649415
>
>   * With patches applied:
>     - 15 hours RX test, 500kbps
>     - 56 RX / 8 TX message objects
>     - 41 received frames lost out of 279303376
>
> Please note, I do not have ability to test pure C_CAN, so it is left untested.
>
> ---
>
> Andrejs Cainikovs (2):
>   can: c_can: support 64 message objects for D_CAN
>   can: c_can: configurable amount of D_CAN RX objects
>
>  drivers/net/can/c_can/Kconfig | 20 ++++++++++
>  drivers/net/can/c_can/c_can.c | 93 +++++++++++++++++++++++++++----------------
>  drivers/net/can/c_can/c_can.h | 20 +++++++---
>  3 files changed, 94 insertions(+), 39 deletions(-)
>
> ---
> 2.11.0
>
