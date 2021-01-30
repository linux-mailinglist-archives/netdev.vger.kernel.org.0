Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA001309925
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 01:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhAaABA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 19:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbhAaAAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 19:00:46 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D3AC061574;
        Sat, 30 Jan 2021 16:00:04 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id e15so10073245wme.0;
        Sat, 30 Jan 2021 16:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=98fiWn69S2Pq3I8O6pRBiZncvLz9xWgYETkJN7pf/jQ=;
        b=JqgQ16TGct0aRQPGSBnpfx/yCS3Gu3mi1F4UF5w17tDRObP2Ynbx8/I3PG8hPJlz49
         Ed86yobCG2Y1caNo/UD/mjeVK16Q9OkvXzrqWxpIEefyG0dSV+shI5CrCKNI6tvNASJ4
         0pd0sN6pRxMqEKiK79ystM1A6EytPT383OtxVuWsG/rOpZBIVNSHA1BTkjVYOG6Zu4sv
         GeeAV8po7wyDh89pY3jzAUQn3O/Ad4J1bjT+v0R41TfdoomsXr63F9B1QFRQ0HaTlEnn
         J+8gj4QO7RxyliZyyGttl/k4+buix6qoYFx0RQKYVHy8AjbdIlO5bqeDVimjyx5qU/py
         XCew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=98fiWn69S2Pq3I8O6pRBiZncvLz9xWgYETkJN7pf/jQ=;
        b=CkpVpvlxJehYlo2321zW5tHGvzXI4LjCBAnJlVdbdU4MyKuyQbW+4sKDAB61LUn5ep
         ITKgXrBebd7w6w4ZJpX2leeSZ5eTE2sQOMI8WvN5ROyse0We5TdVLOfuNbBV/YniZm8f
         ktsyxAmjPcKxq6cCVNG46U9xEUyzdonpPTLgnufEr4Afd3JLXDHGHpzAcXUGEd7tOnWg
         dlK0I/3xHWLmhiGhgGmODWOO/uvTGsUCxn+jEVt+Lo+h9lZRDx+QRVgvcdB+x5uUsp8I
         miyVJIrDFbOInHvshYKjaIPxBq5NtY18pr31+Ecr6HUrk01P+Us34Gt+6Euw50xPiXGc
         /F+g==
X-Gm-Message-State: AOAM532SBmMjVzTem3tROY7XTdEisu/BjBMnhkx2OJ4zM6Dgnml81AqC
        8dhiV609dnI0f1R2IhWKnvYIhVVHPrAeJQLDE6WNCLuOUAQ=
X-Google-Smtp-Source: ABdhPJyTPpHc18Fi5SciDLsc1+bSO4w/MJ2HRIJT/LbPEw4Z/TCf5+qpNKvNrvLViokuuD1ZGSts8JbsDWOuk1cGLDk=
X-Received: by 2002:a7b:c8c8:: with SMTP id f8mr9179408wml.11.1612051203243;
 Sat, 30 Jan 2021 16:00:03 -0800 (PST)
MIME-Version: 1.0
References: <20210129195240.31871-1-TheSven73@gmail.com> <20210129195240.31871-2-TheSven73@gmail.com>
 <MN2PR11MB3662C6C13B2D549E339D7DD1FAB89@MN2PR11MB3662.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB3662C6C13B2D549E339D7DD1FAB89@MN2PR11MB3662.namprd11.prod.outlook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Sat, 30 Jan 2021 18:59:50 -0500
Message-ID: <CAGngYiVw2mwmcFWJNid52oPPET2M6+BEgr+Eb-_-yUj6it0ifw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/6] lan743x: boost performance on cpu archs
 w/o dma cache snooping
To:     Bryan Whitehead <Bryan.Whitehead@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bryan, thank you so much for reviewing, I really appreciate it.

On Sat, Jan 30, 2021 at 5:11 PM <Bryan.Whitehead@microchip.com> wrote:
>
> >                         /* unmap from dma */
> > +                       packet_length = RX_DESC_DATA0_FRAME_LENGTH_GET_
> > +                                       (descriptor->data0);
> It appears you moved this packet_length assignment from just below the following if block, however  you left out the le32_to_cpu.See next comment
>

Correct on both counts. This is a merge snafu that crept in when I
rebased to Alexey's very recent little/big endian patch, at the last
minute.
My tests didn't catch it, because I'm running on a little-endian cpu,
where le32_to_cpu() compiles to a nop.

Had I had the good sense to run sparse on every patch, like Jakub has,
I would have caught it...
