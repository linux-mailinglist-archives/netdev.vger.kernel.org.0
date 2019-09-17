Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25AC1B44DA
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 02:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731282AbfIQAWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 20:22:12 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36505 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfIQAWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 20:22:12 -0400
Received: by mail-pg1-f194.google.com with SMTP id m29so970995pgc.3;
        Mon, 16 Sep 2019 17:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gHvCS0WVH6nxYtiVa7cmozt6ck7gFLQffDaRFaPUffg=;
        b=JVYTowaLIzs55a08OwW7+1LUrzAWD08aN31/PaXOCbf6VJrKyRw4oxkO/HMDjDR2Ss
         VHJccL1WXw1Ard7nTI5inozA2xt6smVM7TWC0xWkmOUizHgkmg2IxsTHXbmBRn7U9MaG
         sqC8VPO3gCq40qVaeqVxB9vl67T+JNzolQGp7v86oNyTji1s6fXImtuUNR6vP0yVQA/q
         y+PxowdPxsSw0cY2njZ6lrxTEd1a7SFUHK63b5NDecQDSzmdrsIjn9QcIhvEGPJ30yko
         udvbDp0GzntKTVqq5pmxkwTz0ePE4jzL9WXbpT3+yprF7IQfOcPDo1gaMVWn/LyZKt1B
         OikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gHvCS0WVH6nxYtiVa7cmozt6ck7gFLQffDaRFaPUffg=;
        b=mWHu0eLdfb/F0z61wTshFvLlkd+8e3oo0L2k3qCS8oCF37BpahDRSiTj+of/UfWTq8
         3NaUHcr3UhBrubwHFR1XdCWG9CcO8sRj2fhkmpxLtSeOSDMgFpHIk23APkuK6t/03t0c
         UkyfuQOsArdXV6sVk8FUjr9oTyAE+1fCI87tGxYArb9ORAFyyWbNA0yo2WLsRRlUL8Y/
         Z2M1VdCGRMEdjc+XmSnhNlQACV5vEEZzIQs+NzoHb6niDyrULOfB5/G+eF/d8scb0Bxh
         35/nYR+krQyvSh4VNzoHy5RUrN06eBOF1BMO0KmkIZQIhpSZF+sKLcxVBDHKkYPuGH2w
         X8Hw==
X-Gm-Message-State: APjAAAVJyPuRra5x3c7C1xWo4nrpCG/382wIsD421RQq9o62jZWH/ZhY
        dw8hNcc8C6PH825hB1/hNAo=
X-Google-Smtp-Source: APXvYqzJ6FqLP4djoh9LqAiR2iEtYD5Kkz7MksbyKf2l/vz2NaL/A51k9HEdd9SWkQezPbEFKC3CUg==
X-Received: by 2002:a17:90b:f15:: with SMTP id br21mr2033808pjb.101.1568679730699;
        Mon, 16 Sep 2019 17:22:10 -0700 (PDT)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id q204sm288345pfq.176.2019.09.16.17.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 17:22:09 -0700 (PDT)
Date:   Mon, 16 Sep 2019 17:22:07 -0700
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
Message-ID: <20190917002207.GJ237523@dtor-ws>
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
 <CACRpkdb=s67w2DCGubhbLQTtxpWtiW8S1MECMO4cvec=bF6OdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb=s67w2DCGubhbLQTtxpWtiW8S1MECMO4cvec=bF6OdA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 12, 2019 at 10:55:47AM +0100, Linus Walleij wrote:
> On Wed, Sep 11, 2019 at 8:52 AM Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> 
> > If we agree in principle, I would like to have the very first 3 patches
> > in an immutable branch off maybe -rc8 so that it can be pulled into
> > individual subsystems so that patches switching various drivers to
> > fwnode_gpiod_get_index() could be applied.
> 
> I think it seems a bit enthusiastic to have non-GPIO subsystems
> pick up these changes this close to the merge window so my plan
> is to merge patches 1.2.3 (1 already merged) and then you could
> massage the other subsystems in v5.4-rc1.
> 
> But if other subsystems say "hey we want do fix this in like 3 days"
> then I'm game for an immutable branch as well.

No, if it is still has a chance for -rc1 then I'm good. I was thinking
if it does not go into -rc1 I could convince some of them merge a
targeted immutable branch off -rc8 or 5.3 final and then apply patches
relevant to their subsystems so we do not have to wait till 5.6 to land
everything.

Thanks.

-- 
Dmitry
