Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC4531D51D
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 06:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhBQFiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 00:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhBQFiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 00:38:12 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D52CC061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 21:37:32 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id f20so12604644ioo.10
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 21:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jj0ZHT9pDzLmvQ3PfcNH9vAt+g9Gq3cZ1Wa963EQOSA=;
        b=I/ByEMblnzSoyzebbbOoSpJ8rH0QAxHXOUxdPYRvAHrsYgk1Doy3Z0WOfYQfNl8uKs
         6UF7lVkoU8l/Fl0dqjZQzCBc7zL7X2ywptxPyk7VL78J6080Lx3vhXwoAvCn1H9PJnuQ
         kAY4KX4d2+4N/Y3Te5AANHFYk4DE7+9SP3ujgXmlaHu/b3O5z+og8wA5dHCueK/W+Nj8
         sQ+gADB/A7ooj5zebV42lW1Mvp1laxep2wxkBXvhDy/MPd9c1x6RnNlH3pldXdUkhT0b
         Stnf9xlimTf/v9pPvyxEFLxLAwvjVEruczoBmkyv+dwwIgnEOQmxOtPFl2/eJkIbuumk
         vOZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jj0ZHT9pDzLmvQ3PfcNH9vAt+g9Gq3cZ1Wa963EQOSA=;
        b=WgtAUoM/mqzDhwHqqVeb/gN0wA/m3ps2FS2xOG/n7lJGoE+vDVbRToL8Zl1sHZmNLa
         PytRlrHhYZ0ccrrPBTZxb95yCB6K5ewQP1gY8AHnZ3zGfIp9NVaw0DN5+g8PlY83Xfpy
         r4T6QuQZ2NfMNy/EFHKfzNO8bfUMHRiENcT/JX3kgK15yjkRN/6Gam5EXftuiCMKgedd
         zfzFMjdUVLxU6URhpyKTPOXYjHqsjebnQGcFnu767Y8SApQJ86T0v/Kp9Db4ntTSZm6W
         CCXW/rav1mRCxLwkx+ANDH3s8EkIxjg4p1HTLv2uj0rIMyXULw7XRx0qc/XMs8l7L5aq
         gbxw==
X-Gm-Message-State: AOAM530iHLEivdg5XaxvYI3WW0t1Bum9Qz2voJUjYdqR9NEVNC0tMJRU
        cPJFw5JGu9dTtIxXQJNufRw1ubLyDA/lm3Fcexg=
X-Google-Smtp-Source: ABdhPJywayers43tvCln9UHiWr1oyV3UOblQKs+xnhEBgcrFsoWbNhqxkKtT59t0c8NZc1jMWg5d+mv1Ps1Tu0QnTkw=
X-Received: by 2002:a05:6602:2497:: with SMTP id g23mr19261083ioe.22.1613540251976;
 Tue, 16 Feb 2021 21:37:31 -0800 (PST)
MIME-Version: 1.0
References: <20210216235542.2718128-1-linus.walleij@linaro.org> <YCyNjB5PpYomt4Re@lunn.ch>
In-Reply-To: <YCyNjB5PpYomt4Re@lunn.ch>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Wed, 17 Feb 2021 13:37:21 +0800
Message-ID: <CALW65jZG35HNxYe=GXDGUVY6kLBExKczDM_pRU_ZrJ9QnHBUNA@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: tag_rtl4_a: Support also egress tags
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 11:29 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +     /* Pad out to at least 60 bytes */
> > +     if (unlikely(eth_skb_pad(skb)))
> > +             return NULL;
>
> The core will do the padding for you. Turn on .tail_tag in
> dsa_device_ops.
>

Please don't. .tail_tag does far more than just padding.
