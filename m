Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A53D1EDEE0
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 09:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgFDHxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 03:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgFDHxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 03:53:05 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33466C05BD1E
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 00:53:05 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a9so2501467ljn.6
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 00:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=svs00+gnRJMF7kg407O0f49giSLj+wyDQSkuLRJ0D3w=;
        b=m5g7zxDtmnx0UzdeBSZxxo+yHPEHnE0RB0koeFvzlDZzCDtKSsL/8Ymh0JwBQ+qGUJ
         Cm1LKhEHhRoHWzQmaL27jZHE1JWqDEla1jCDcQV550c3JQWq7tdastd7OgQ1tbCqboQs
         BmYwiMZpwmtwCobmaQwu+2g3C6zOmPtdSJ1j4xXB69XfGeZVHcNXCWdRe/Hl6aJi2yCl
         vUdG++rUIKh7zgx18gu34EbElhpVXjm7V9eLoTsoutw+Jm1O6aEHmHQs2QFgBl3kXvbo
         45I1sZ8lBsgiqyBw5G26U50VlEqFfRPqQhVMmXztus7WSBIe7cJdVPCiE8v0iMC7Rb41
         NVZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=svs00+gnRJMF7kg407O0f49giSLj+wyDQSkuLRJ0D3w=;
        b=q9a5A6Qq65Gvu2ee/ATqs+RYqh/4BQtfWJ9Leb8VQutQWuqpqTBHx96le3f3Gi8U9T
         Oq02JStZAAo3+n+GyIjS7S8QSZLSQLxvatl3PfzdSwcrNlSaG99zpw8+G9jvelstWvPT
         z6836ph45PrdSPjTMfw6oJ5X7KnDGVgg+9kaMsPHkuNjw5oZgJ4cjgu6yzJZuhRhlV+O
         FQdpqaXqFR1NcT2NvgL+ZmqEIR81Do1tFahnK0CiWRr9JJfPeEPH/RFIbfbn/lh+ITkd
         GdGM1NWvBkOacy+VzChWj5JQuSy8+3X8oI6z6N7Irt28xhlmS3S/W4s8a0lC5ueD059T
         GyDg==
X-Gm-Message-State: AOAM533R6KLumcHhJmt3P3Nx8BcfW6mJGiuJbs4DTZcFJl/BbasXQb6p
        EcDNFMBfo7oY2EwAd9naN4U2U5+NMNFIPdqwCALt/w==
X-Google-Smtp-Source: ABdhPJz1QmWUdeTjs0OtJmBMmipN4BoMReKrgG5MEqMxrkkmSradWY1mkBd+OG7L4yUUdA5On5BPS/YOm3uSe8m7tXU=
X-Received: by 2002:a2e:7303:: with SMTP id o3mr1609495ljc.100.1591257183667;
 Thu, 04 Jun 2020 00:53:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200602205456.2392024-1-linus.walleij@linaro.org>
 <20200603135244.GA869823@lunn.ch> <CACRpkdbu4O_6SvgTU3A5mYVrAn-VWpr9=0LD+M+LduuqVnjsnA@mail.gmail.com>
 <20200604005407.GA977471@lunn.ch>
In-Reply-To: <20200604005407.GA977471@lunn.ch>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 4 Jun 2020 09:52:52 +0200
Message-ID: <CACRpkdZvf4qnhQK=dqF4Shv0Q0nkVqTFcZS_5Zg8PrO+iCjxoQ@mail.gmail.com>
Subject: Re: [net-next PATCH 1/5] net: dsa: tag_rtl4_a: Implement Realtek 4
 byte A tag
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, DENG Qingfang <dqfext@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 4, 2020 at 2:54 AM Andrew Lunn <andrew@lunn.ch> wrote:

> If spanning tree is performed in the ASIC, i don't see why there would
> be registers to control the port status. It would do it all itself,
> and not export these controls.
>
> So i would not give up on spanning tree as a way to reverse engineer
> this.

Hm I guess I have to take out the textbooks and refresh my lacking
knowledge about spanning tree :)

What I have for "documentation" is the code drop inside DD Wrt:
https://svn.dd-wrt.com//browser/src/linux/universal/linux-3.2/drivers/net/ethernet/raeth/rb

The code is a bit messy and seems hacked up by Realtek, also
at one point apparently the ASIC was closely related to  RTL8368s
and then renamed to RTL8366RB...

The code accessing the ASIC is here (under the name RTL8368s):
https://svn.dd-wrt.com/browser/src/linux/universal/linux-3.2/drivers/net/ethernet/raeth/rb/rtl8368s_asicdrv.c

I'm hacking on it but a bit stuck :/

Yours,
Linus Walleij
