Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16232315B61
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhBJAhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235101AbhBJAdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 19:33:32 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF265C061574
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 16:32:51 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id 18so151898pfz.3
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 16:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vulMIh88N9FP+++al8a+crf2eGfHNtkUQxG0lNNXE2c=;
        b=gDkPizx0JxOqvnoX+LxWXHds3M3BvtJJSYavtBZ9vbD4UbmZrBTxWkGrpl9XphtogG
         m86hJ+2n0eklqQt7Z7cziTZSUKqXZ/HWMdLTY3Pqwl0wSiaadEn5yfrVAbNi1pf0Cgm+
         zv06vd+pcqXKIZryXu2kZgg/k5xNoqK2VxMZjoFT9DPwc03TrH/TCqr+A1tXfjB34FSm
         yl486ileJemgupCCAT7tQP/YDUydj2IDayRAeTDyfFnY6n0Y+jfNnv+JcLX/atNxdJ6s
         nLfOVdITaJt+gzaT6d3MHCo6XXgbOCrnBWisCqpN3OpXBAQGSFoQpam5cdHCmysP+StE
         RmLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vulMIh88N9FP+++al8a+crf2eGfHNtkUQxG0lNNXE2c=;
        b=GJwE1PMLC/H6pNj1dg2xuuFT/wR2mkG1/PUZJji2vVi2tKT/OT28x/pP2QGmzP4Fxz
         V3PrbIibr5+OTSUGvAslcfMdYR+OcdEXcs0Y08d6RyN8rz0OxkXoPVTgfo6mC+Xjmh3B
         D0u81JFFDfUlJgHzK6hnjJ92kPtqoUMd0sS+dpT5ke72wnAYDkjkk1r6g8XGc0ga5W7n
         ftMjDdsozEXZzArMCYLavX9LDq3Icd4jB9QXCP9b21z6wcVzRL3NxLTosK3j0LFY7lzq
         HoDxRo1zup2wPPnO1KrWV8W2Kigj9s1VXJFBzIpYIG/vOaDTKwzRSRy18aYcrlJLbaKP
         oDPw==
X-Gm-Message-State: AOAM531tXnEDxFhrW9+gxkB98PPq6gHzAQG22MH7IDJaE6W5QAHAZ3rU
        MADmbR9fObgHoxwMDGDjPIqLoyoCNk1SQ7El
X-Google-Smtp-Source: ABdhPJxc220nymai/xnOwOGoaxgdGEi+OMrPCA1iCFxtjBN5hO+SN43Evi7P3Eo+pZ+8xEQW2BhWFA==
X-Received: by 2002:a63:f447:: with SMTP id p7mr507660pgk.243.1612917171410;
        Tue, 09 Feb 2021 16:32:51 -0800 (PST)
Received: from hermes.local (76-14-222-244.or.wavecable.com. [76.14.222.244])
        by smtp.gmail.com with ESMTPSA id 25sm84880pfh.199.2021.02.09.16.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:32:50 -0800 (PST)
Date:   Tue, 9 Feb 2021 16:32:42 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Anton Hvornum <anton@hvornum.se>
Cc:     netdev@vger.kernel.org
Subject: Re: Request for feature: force carrier up/on flag
Message-ID: <20210209163242.7ce62140@hermes.local>
In-Reply-To: <CAG2iS6oP+8JG=wCueFuE3HwPsnpnkqxhUx8Br84AnL+AoLi1KQ@mail.gmail.com>
References: <CAG2iS6oP+8JG=wCueFuE3HwPsnpnkqxhUx8Br84AnL+AoLi1KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 18:35:54 +0100
Anton Hvornum <anton@hvornum.se> wrote:

> Hi.
> 
> I am a bit new to ethtool, kernel drivers and all the surrounding aspects.
> I also recognize that my use case is of low priority and a bit niche,
> but any response would be greatly appreciated.
> 
> I'm modifying an existing Intel driver, and I'm looking for a way to
> integrate/add another ethtool hook to force call `netif_carrier_on`.
> There's plenty of hooks/listeners (not clear as to what you call
> these) between the Intel driver and ethtool via C API's today that
> allows for ethtool to control the driver. Many of which are for speed,
> autonegotiation etc. But I don't see any flags/functions to force a
> carrier state to up.
> 
> This would be very useful for many reasons, primarily on fiber optic
> setups where you are developing hardware such as switches, routers and
> even developing network cards. Or if you've got a passive device such
> as IDS or something similar that passively monitors network traffic
> and can't/shouldn't send out link requests.
> There are commercial products with modified drivers that support this,
> but since the Intel hardware in this case seems to support it - just
> that there's no way controlling it with the tools that exist today. I
> would therefore request a feature for consideration to ethtool that
> can force carrier states up/down.
> 
> A intuitive option I think would be:
> ethtool --change carrier on
> 
> Assuming that drivers follow suit and allow this. But a first step
> would be for the tools to support it in the API so drivers have
> something to call/listen for. In the meantime, I can probably
> integrate a private flag and go that route, but that feels hacky and
> won't foster driver developers to follow suit. My goal is to empower
> more open source alternatives to otherwise expensive commercials
> solutions.
> 
> Best wishes,
> Anton Hvornum

Normally, carrier just reflects the state of what the hardware is
reporting. Why not set admin down which tells the NIC to take
the device offline, and that drops the fiber link.

Or maybe what you want is already there.
Try writing to /sys/class/net/ethX/carrier which forces a carrier change?
