Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 872EAC29E3
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 00:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbfI3WpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 18:45:01 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46336 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbfI3WpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 18:45:00 -0400
Received: by mail-pl1-f194.google.com with SMTP id q24so4454808plr.13;
        Mon, 30 Sep 2019 15:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cK5Fghk/yA6wH8i7i1QdxuNjNjer/uYW7DYZEo/GN74=;
        b=UsyIMUg00LtJE64A4LiLe6eJzVF1zL6nphsK2U/Q2IqWrZP53dG4q1VEndLOUOYNYn
         5SEp3DRw3l7cXZ1osu3JlTEVDyzECiVpf9CZRZ+qF7EK8okwLv7gA5HXg3vLTVgj3toJ
         oE3oSQHrwjSgFSD6WS0XcDb/z8Q0ATme8RO9xD/byhPytcMAtRt6rhOoarHWAyjEK9hN
         OSXg/8HIwuMV/3mcDLh2yRcG3pIL2Lh/Pl+OTPlEuxgZKB0ZkFhU5n00g3bZjnQ7tiIL
         XXhd2dPfa8WSw2dXTy1o38zQlEVtZweCcrWF0Ce7wmvm/rWPWuzJjX7/TE1vyxfptElF
         18ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cK5Fghk/yA6wH8i7i1QdxuNjNjer/uYW7DYZEo/GN74=;
        b=IFEJZwyXa6MjGVtKM3tUgZGdVNTmpHxoqFIi4bOElO7O6Jx2Rt0c800zsSxqpsouE/
         f/TShsR5ufdu4WkUiCmO30FEGnMJHsyBXWVJScx9F1yY7pg3RVXoj1qB1pP9Gp0jgx5Y
         cSaPMST73Ov8Bx+cpkc8g0fpHDJVJjBJ6yNdQ7gQR1fFCyHSyG6+HO1bn9H25ljgq1AP
         WVvjREUuWsvSgEjHSd6jpU22Sz0vPdRRpYpZosyL3AjjLdfG4Hon1OAxrEtG9ayfhwhE
         n1tgVHF9sd5GbnG6RPF4IoOh81TN6UqsqLUTROzc9JvgIXS7V6L7vldxIaCvjH1a1wZK
         uL7Q==
X-Gm-Message-State: APjAAAUxDpUF3HMtWErI+dt6me1pX4n3dlLw/lmNWjwtayajBsC25Qtd
        zG2f/hJNcvq/tv5p7/jgs/I=
X-Google-Smtp-Source: APXvYqzpfrf1XrfBF5s/NlyYg1/o1Be4cDh58aR3YEzX+PU8lIPJMJmjlArWpf2bHK26A22NPfYSfw==
X-Received: by 2002:a17:902:b949:: with SMTP id h9mr8215703pls.35.1569883499500;
        Mon, 30 Sep 2019 15:44:59 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id y7sm12632755pfn.142.2019.09.30.15.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 15:44:58 -0700 (PDT)
Date:   Mon, 30 Sep 2019 15:44:56 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
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
Subject: Re: [PATCH 00/11] Add support for software nodes to gpiolib
Message-ID: <20190930224456.GV237523@dtor-ws>
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
 <CACRpkdb=s67w2DCGubhbLQTtxpWtiW8S1MECMO4cvec=bF6OdA@mail.gmail.com>
 <20190917002207.GJ237523@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917002207.GJ237523@dtor-ws>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Mon, Sep 16, 2019 at 05:22:07PM -0700, Dmitry Torokhov wrote:
> On Thu, Sep 12, 2019 at 10:55:47AM +0100, Linus Walleij wrote:
> > On Wed, Sep 11, 2019 at 8:52 AM Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> > 
> > > If we agree in principle, I would like to have the very first 3 patches
> > > in an immutable branch off maybe -rc8 so that it can be pulled into
> > > individual subsystems so that patches switching various drivers to
> > > fwnode_gpiod_get_index() could be applied.
> > 
> > I think it seems a bit enthusiastic to have non-GPIO subsystems
> > pick up these changes this close to the merge window so my plan
> > is to merge patches 1.2.3 (1 already merged) and then you could
> > massage the other subsystems in v5.4-rc1.
> > 
> > But if other subsystems say "hey we want do fix this in like 3 days"
> > then I'm game for an immutable branch as well.
> 
> No, if it is still has a chance for -rc1 then I'm good. I was thinking
> if it does not go into -rc1 I could convince some of them merge a
> targeted immutable branch off -rc8 or 5.3 final and then apply patches
> relevant to their subsystems so we do not have to wait till 5.6 to land
> everything.

So I guess we missed -rc1. Any chance we could get an immutable branch
off -rc1 that you will pull into your main branch and I hopefully can
persuade other maintainers to pull as well so we do not need to drag it
over 2+ merge windows?

Thanks.

-- 
Dmitry
