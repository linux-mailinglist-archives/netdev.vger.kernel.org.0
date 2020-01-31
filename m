Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5E514F036
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgAaPzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:55:18 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55354 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729016AbgAaPzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 10:55:18 -0500
Received: by mail-pj1-f68.google.com with SMTP id d5so3023397pjz.5;
        Fri, 31 Jan 2020 07:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=etZJ2qDpxy+0er04QinaGebZrFL79G7fzpxa6iBYDb0=;
        b=PZwzKaguKqfjKJtzpSTHSbyZ5xO6kPiqklv+v/r4qZ/DuGJ+UfVa52gNxkbb88H1ty
         C/xCxtangnvtd0Vh5gXYKDCQGyenioqW0SZbsICopT3i67ANZRNAC30eeQIyXiaPqhpg
         KjK956XVQl+/GTJ//Ah+yWb5fcCRjfv8HdpIb4UhegzW666sa0PIkLBp8cqN5wmTK2VF
         JG6UGAwUOBn8Uczwa457o1Srvi1VrIzxdoyqxKA7whALQNiMD+cEisJI6rd8mcOHUGnv
         yRKiqpQs1y3G9x2oRAG+Lo9iG0qUJU5NxF178GCopTO74yD6pDWsg8204tmrFqFeeuc0
         1h4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=etZJ2qDpxy+0er04QinaGebZrFL79G7fzpxa6iBYDb0=;
        b=cQb4ZJLzqWYkADujPlLpc1VuT0XW1JBjXbS49S+3bP8zl0PSDKarB5n31e+cjqntmk
         RNLnJBT3RyDggkRjz97l6pwBvHL/dirBTCYLvBxS8Bb//812v+Ozh9EDVBdTUpo8Ekih
         OSWHIM8XyJ3GjlNlUNgc6/QnnqzGxaP9dXX84kgzqWRykcGhGGzERfi6e3gi+YQFJ2zJ
         WuuVw3xYVPTaNN7uItwr0SJKxaS/2EeC/ZELcFmHOHnTVrtLn2HuVJY53vbX3k4gR70s
         YB7VyekiXrC2A+wLeBu+QytluVhHHVWoklNEEXQbdi3OYgCwf68t71zjFIE+fhoIXIlb
         Veiw==
X-Gm-Message-State: APjAAAX2CIG86+gwsRQECNltN44+/BK9G4/fyurmxC7KZjoUKTx7bnUy
        nEm/Y9h4qDoE7nn2LAdfebt1Gna19vu2PwqKj2Rsbz7v+dMqLQ==
X-Google-Smtp-Source: APXvYqwIzdBo1hBzieOYXAveRmEM/5fGcZv6LSrtHUvUYTzNV9mq70fEh9894S0QDusxcZUWYUIM1VbxwzGylEUoQXo=
X-Received: by 2002:a17:90a:2004:: with SMTP id n4mr13271281pjc.20.1580486117613;
 Fri, 31 Jan 2020 07:55:17 -0800 (PST)
MIME-Version: 1.0
References: <20200131153440.20870-1-calvin.johnson@nxp.com> <20200131153440.20870-5-calvin.johnson@nxp.com>
In-Reply-To: <20200131153440.20870-5-calvin.johnson@nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 31 Jan 2020 17:55:09 +0200
Message-ID: <CAHp75Vdnz79NiHs5MfxAevzOuk-A6ESHR+Epoym+v3Qo4XPvLw@mail.gmail.com>
Subject: Re: [PATCH v1 4/7] device property: fwnode_get_phy_mode: Change API
 to solve int/unit warnings
To:     Calvin Johnson <calvin.johnson@nxp.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux.cj@gmail.com, Jon Nettleton <jon@solid-run.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Matteo Croce <mcroce@redhat.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 5:38 PM Calvin Johnson <calvin.johnson@nxp.com> wrote:
>
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
>
> API fwnode_get_phy_mode is modified to follow the changes made by
> Commit 0c65b2b90d13c1 ("net: of_get_phy_mode: Change API to solve
> int/unit warnings").

I think it would be good to base your series on Dan's fix patch.

--
With Best Regards,
Andy Shevchenko
