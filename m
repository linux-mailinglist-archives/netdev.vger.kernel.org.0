Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C12A273A7C
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 08:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgIVGC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 02:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgIVGC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 02:02:26 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18F0C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 23:02:25 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id m5so16692614lfp.7
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 23:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vzc8/W+FjF8ZlSuIdeA6KWVtuCzZjYzq6wAPjTGAzPs=;
        b=Thv5wXnvByrU6M2vLgT0+IAzCqwUKUjy8ZXpGnKvG5uMm3EMgJnKnaX7R48MX7L6Kx
         ZgkEsom4rbKaUhoYPFa0Ek78778zNETmLHOIBz4NuFZZ/v9o3j9e/svXm5Nqb986nPnl
         hFN7+ZclzFUrXut7oSbrnfaLi4xLED8ovLGuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vzc8/W+FjF8ZlSuIdeA6KWVtuCzZjYzq6wAPjTGAzPs=;
        b=DeoCTGHYsznGKAtmq0pVsPR39KX3EB/DAp6QAFOS5kOP/KRHlSV4UnCQCjOwv/IneI
         nD+Kaer0x9lMFG3QSRh/PSsp4uQk2VARmH9l1nbha+SY36Ha95YQmi5++JS5BGiRTqOH
         Q9CHzcKwAd9mY/8zJT0jye6UvKLCUY6XuRNSXfroIqghbnrazHjA541efpkKfBOUM79g
         xMS6i7+z13LulreRXSAyPYoNqW22UewkTdiRl24dLygeExuQYyOPcLC1KWS2muuroJb8
         RzhlW8oamR4v4hoKp8XV4w/JrnO1mKFii69CRtVmnWNx3bqeu1ZeYMQboBR0+YmQofxt
         /UFg==
X-Gm-Message-State: AOAM530KFYgMWBDMw/PVsENe+FOFPwPSuuRlz1KQw10rUZMgK/Wgbbj7
        38hz0K/0v8hd6LyOU4NZx+HGkRQEvRNMSRIM0l3acQ==
X-Google-Smtp-Source: ABdhPJyf+/TzK9OzAP0CRGJIfFDw0CQrEOHHcszsmkqNw9Vv/7550+8AoPjDe3s0ynEOkTPTN8RBqdCfLpaE6Mx5eLA=
X-Received: by 2002:ac2:53b3:: with SMTP id j19mr1219577lfh.101.1600754543916;
 Mon, 21 Sep 2020 23:02:23 -0700 (PDT)
MIME-Version: 1.0
References: <1600670391-5533-1-git-send-email-vasundhara-v.volam@broadcom.com> <20200921124105.GD3702050@lunn.ch>
In-Reply-To: <20200921124105.GD3702050@lunn.ch>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Tue, 22 Sep 2020 11:32:12 +0530
Message-ID: <CAACQVJr7=C3h0YeU5wo5mbU3PnOs6z_7SMkxmCMhVFxd0ydQDw@mail.gmail.com>
Subject: Re: [PATCH ethtool] bnxt: Add Broadcom driver support.
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 6:11 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +struct bnxt_pcie_stat {
> > +     const char *name;
> > +     u16 offset;
> > +     u8 size;
> > +     const char *format;
> > +};
> > +
> > +static const struct bnxt_pcie_stat bnxt_pcie_stats[] = {
> > +     { .name = "PL Signal integrity errors     ", .offset = 0, .size = 4, .format = "%lld" },
> > +     { .name = "DL Signal integrity errors     ", .offset = 4, .size = 4, .format = "%lld" },
> > +     { .name = "TLP Signal integrity errors    ", .offset = 8, .size = 4, .format = "%lld" },
>
> These look like statistics. Could they be part of ethtool -S
Only a couple of PCIe statistics look like counters. But to have all
PCIe statistics (most of them are not plain counters) at one place,
dumping them in the register dump. Thanks.
>
>       Andrew
