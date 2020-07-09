Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD21D219A2D
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 09:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgGIHoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 03:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgGIHox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 03:44:53 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F60BC061A0B
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 00:44:53 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id m26so584149lfo.13
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 00:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ORoWbKGu1a0Hoz8QXyoUfUESDBmcLBzC1O77aGMSiE8=;
        b=isMqIImLya3iKYoPte+7br0bl0DDwuKhB5YSDr12XtoAtlxkfzuD+qohdEN9l7uYIa
         3evfj+C6jeF1BI2qO32GTZ8eb2gOljLqMJf4ra8Ws7La2M8qnzsfBpEFr0pcuBiGLMAv
         RuTezI1msqRbgFGH4r3KOlVfG32i5bM2sZ/GK6rdqt79aXiFkI0Fm9AqTVTwjVsq097a
         SVAo077ZRXXOlZULl6BHpOqUexuzDvgwpr3YpWvRopsPx6Br0JpEOsK9QYXhL6mGQGII
         F3Z5JBSAUhjw7HgrWI6X2qi1yWIK9GsTG2SfENB5ojPG1A6Op0GS5kXqL3MrUErMd25s
         9F6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ORoWbKGu1a0Hoz8QXyoUfUESDBmcLBzC1O77aGMSiE8=;
        b=MGOPZKJCD5gSu/IbxJZjj3eq2UvTNbQHIKJse8vROxpSmj69tS5WygqkbGPeWwR5+V
         ulFOKDcG9Tso5XgKsFD1ZLlCoroLAGQlu1AueJFvW4T6KUwBCQNiCvLNDylMPquxJ5sk
         Q2WsD+DYzyg1HbKda5ZdlWZM0+CEWEY3OTVicI3rgXmnMPy18SRsV89P+2nfSLQCugMr
         inmSh3buA5th7t/A3k4iulFlx6kwO6F4PQGPk1EZN/I4i4lu45Y2tzmitQAuo6TrjWOb
         VkyFQhwhRidFauBX7V8GvoJ2AkSj9QbZQWE29eC5ktjnv9jzlOFrcGp1H3eKx7WPvGL7
         gsTA==
X-Gm-Message-State: AOAM532anPLUvRFFjAUsS9s5OTROmkCRbScYU4PVSqjmjJmWdIZXmUZH
        gDGITTVlT03X1WurcM39sZgmYIz9J4Zy95AvHu3xBA==
X-Google-Smtp-Source: ABdhPJwdenCkwsIbb7Z0ap7OTcOfqvgU+8P8lNP4RciRZX1Gpod5wq4nXe7z26LqNRcOp1EikrmtiwOdDEwBHwl+FkM=
X-Received: by 2002:a19:e05d:: with SMTP id g29mr38461342lfj.217.1594280691833;
 Thu, 09 Jul 2020 00:44:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200708204456.1365855-1-linus.walleij@linaro.org>
 <20200708204456.1365855-4-linus.walleij@linaro.org> <164d3477-df6d-103c-b9ed-55f5d7705e7a@gmail.com>
In-Reply-To: <164d3477-df6d-103c-b9ed-55f5d7705e7a@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 9 Jul 2020 09:44:40 +0200
Message-ID: <CACRpkdaU_K6gKBVpnRt+iofVtakSTDZ6Oxf+YUceTERb_AERFg@mail.gmail.com>
Subject: Re: [net-next PATCH 3/3 v1] net: dsa: rtl8366: Use DSA core to set up VLAN
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>,
        Vladimir Oltean <olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 4:29 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
> Me
> > The tested scenarios sure work fine with this
> > set-up including video streaming from a NAS device.
>
> Does this maintain the requirement that by default, all DSA ports must
> be isolated from one another? For instance, if you have broadcast
> traffic on port 2, by virtue of having port 1 and port 2 now in VLAN ID
> 1, do you see that broadcast traffic from port 1?

Unfortunately yes :(

I test this by setting a host (169.254.1.1) to ping the router
(169.254.1.2) and if I connect a machine to one of the other
ports I can see the ARP requests on that machine
as "who-has (...) tell 169.254.1.1"

> If you do, then you need to find a way to maintain isolation between ports.
>
> It looks like the FID is used for implementing VLAN filtering so maybe
> you need to dedicate a FID per port number here, and add them all to VLAN 1?

The FID exist in the source code but neither the vendor driver
not the OpenWrt driver make any use of them, their way of
separating the ports is by using one VLAN per port and setting
the PVID for each port to that VLAN, in the way described
in the commit message.

Is there an example of some driver using a FID for this?

What do you think about the option to teach the core to set
up VLANs like the driver currently does with one VLAN per
port and PVID set for each? I haven't even been able to
locate the code that associates all ports with VLAN1 but
I figured it can't be too hard? (Famous last words.)

Yours,
Linus Walleij
