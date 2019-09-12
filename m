Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82C6CB0C0B
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 11:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbfILJ4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 05:56:02 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38443 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730884AbfILJ4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 05:56:00 -0400
Received: by mail-lj1-f196.google.com with SMTP id y23so22634442ljn.5
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 02:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=329cG7VF2FWSqrxDIURXoF4mNurdRp+cB0ol/yD2IWM=;
        b=zQWgVC5tdLMykaX4/vwY9NwQnl84kGz+E6G4gmnU7E7z3xPgxUBAJuq/KLQlPf1oam
         RdLkgwT7ktokKveMir+dbsSJjHyajz6I6pmACAQ/vaCXqP1u+H53qJ9UGfH9Rqw4f+BS
         F8tIL5183K5mqiZie+gUfjKim5aKDftgnnpqvro3Rlrly4++DaglYIiO64u3PqxKyEqS
         vgu3cD+nTugMhX7gSo0wLYQx22Wjix5fu1vewOQSg/1dXyjPdDlBL2ZYcPZ7siq3qChf
         T+vLBgVhPJk/tcy3slq1OFZi3PAwqOrLAaNYWiAa1505El6PWxe3yZ95a9+Hy+PVW/Ih
         wamA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=329cG7VF2FWSqrxDIURXoF4mNurdRp+cB0ol/yD2IWM=;
        b=bopgxAXW6/cz/H5m6KFKBePDzCqg5y2/jsQdUM+wz8BdVZK9PYLPDnuf2n9mRAoem+
         xKmExHsyTrJLErxRAj+nMU/jkxDbJmU8Lo1icbvA3uk8CC6Mo6swfYevAHOHwguV2LyE
         OT9PDIjuwpBq8Bnlqd+GAUU8b/l4G5QKNvRcZ4vXfgaiR42yXkpmqc9pd7N49dAlF1ob
         Xncv7eaSbwsBI7100ivjKB2Rge4quOecq/iBvBsa5FLZ01cezOvzjeppG+xJJDus7VQO
         AJRdDjsNDBEFQRWTWMtKsABkvgcpsKiBJhrsSqr8KkClTEPkATzuTy2mal4tcQ2NKVlO
         asRg==
X-Gm-Message-State: APjAAAWd+u1vWWEXlOouUp1lrmVjAk/HSMVPmbPabqv7ip8FIj9EnlVR
        UsEwVDqyYm9WjKqsjczKDvCckHgB2eGivfMMlZ4FQA==
X-Google-Smtp-Source: APXvYqxzzu1xektMPHWgtffW/ZJV0KpU2PYzjtvuUtd9AIHNy13c8WglMkiuJC9aHP7eR5XUK9IR4cvejz1fmBwj4RE=
X-Received: by 2002:a2e:a408:: with SMTP id p8mr25771055ljn.54.1568282158508;
 Thu, 12 Sep 2019 02:55:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
In-Reply-To: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 12 Sep 2019 10:55:47 +0100
Message-ID: <CACRpkdb=s67w2DCGubhbLQTtxpWtiW8S1MECMO4cvec=bF6OdA@mail.gmail.com>
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

On Wed, Sep 11, 2019 at 8:52 AM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

> If we agree in principle, I would like to have the very first 3 patches
> in an immutable branch off maybe -rc8 so that it can be pulled into
> individual subsystems so that patches switching various drivers to
> fwnode_gpiod_get_index() could be applied.

I think it seems a bit enthusiastic to have non-GPIO subsystems
pick up these changes this close to the merge window so my plan
is to merge patches 1.2.3 (1 already merged) and then you could
massage the other subsystems in v5.4-rc1.

But if other subsystems say "hey we want do fix this in like 3 days"
then I'm game for an immutable branch as well.

Yours,
Linus Walleij
