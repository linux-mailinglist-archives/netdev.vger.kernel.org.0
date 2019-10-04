Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8A3CC51C
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbfJDVon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:44:43 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45465 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730508AbfJDVon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 17:44:43 -0400
Received: by mail-lj1-f194.google.com with SMTP id q64so7895194ljb.12
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 14:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Am86CuSg4L4/4SThzqZ+x3OfLvEnqGtERkpRQqbTyyo=;
        b=mHoyMz44D2WiAxEQObuEHX6G00RlGGHzOJlRf4ram5Uw4WSYGsCgGObrFsOGL0bJUT
         aiOzQh7CHwV1qQrdMAcusBqOeNWE6EjE6sSFbCZcwuTGGZn02ga15PNfBS2AMwITwVdF
         EgKmzjP7XWS2xGmR0xPdrifdKD01SMM9eyR/Bt3tAd77+2Ivj48bbb+2FqdbrTquiFwI
         AcH8C6wUr68r8TNz0boFXRi344UGq9c9qA49TbQE5FyalLJ0dE328a/7G+MyE//kvAAz
         jYVahOt3Ou685MUsdu1JMEGKJNG2KJmxEad8vqpvyFD797Go+4+z9KOMWd+4luzNMZhI
         +H7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Am86CuSg4L4/4SThzqZ+x3OfLvEnqGtERkpRQqbTyyo=;
        b=C87en+MbiLX5LiYomzsuWozHxxsEumzGgvxmdzEE2NcLivVWZYMlP+71mvEvoLOz3M
         CCgykItppC3iuZJznuT2+tQEoOh9oDWLTF5nVCkB633M2ia63Hx5oaQG3nzCp8BhWqeq
         abcvRr8UQA2iS2n/SpygR5y+XnwZIUy//bbCX3AfIe1d0F4js/RlypV6a9RrXfNA/5Dy
         HZkSXKn6wrAo0SzyUgH+QZTppnvg7C9nfsJe3y7Pd12A2mr7h3lsoaAFK5/SnnGyNBpt
         jR2lwrPdEEdz8iPiXGFlsP8pUkFy0DLzk2c5wgLPN+YPKglg9Pq3P+BQg5bo/fkberxG
         PXQw==
X-Gm-Message-State: APjAAAVb8VnxgFkucjAhNz2Z0ybUzD0MVIAXUp+ppy+ASQMk5kMyb2ZI
        U7G8plpC+1PQkrN5JOzBVzNDb0SL7YTyKbEZoSkvKw==
X-Google-Smtp-Source: APXvYqwroM5221kd6DE0lMFbDD6+AtmXgtU5HwVqu+4VQvfXVATqsHb0Kap1NezC3fWlTCLdds9tQ/fVqjmiw3vaPP0=
X-Received: by 2002:a2e:894b:: with SMTP id b11mr10681582ljk.152.1570225481142;
 Fri, 04 Oct 2019 14:44:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
 <CACRpkdb=s67w2DCGubhbLQTtxpWtiW8S1MECMO4cvec=bF6OdA@mail.gmail.com>
 <20190917002207.GJ237523@dtor-ws> <20190930224456.GV237523@dtor-ws>
In-Reply-To: <20190930224456.GV237523@dtor-ws>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 4 Oct 2019 23:44:29 +0200
Message-ID: <CACRpkdZB2Z5fgbgq=aqBmw7wJ_uSE0_fyeOx6f7JvxJwfwjjMg@mail.gmail.com>
Subject: Re: [PATCH 00/11] Add support for software nodes to gpiolib
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Jonas Karlman <jonas@kwiboo.se>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 12:45 AM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

> So I guess we missed -rc1. Any chance we could get an immutable branch
> off -rc1 that you will pull into your main branch and I hopefully can
> persuade other maintainers to pull as well so we do not need to drag it
> over 2+ merge windows?

Yes I'm sorry. I was swamped with stabilizing the kernel.
I made an immutable branch and tried to use zeroday for testing
but it timed out so I folded it in for-next anyways after som basic
tests.

Yours,
Linus Walleij
