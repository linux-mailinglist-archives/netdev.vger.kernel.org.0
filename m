Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CC5233918
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbgG3Tct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgG3Tcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:32:48 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94654C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:32:48 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id u10so5591230plr.7
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AAt8zgFXQyxsjPv4JL8VqdIponIe0JaRegcmCycE6Qo=;
        b=IiDTe2c84yrqxwfHi7YsVPBHhSl5DD7o3VhX+ZOg922Tj3+H/xaZjzNdeyBwv6iPZC
         Vz4Abvjpu9sfcB7B/zWrvKDGKMIrgSxL/1OFW+/om0U2uOxDjEuTqwd/hvhg9IaDVMoc
         Oj4h4K3Zcww5CaYqOsGdKjx51xb0h65JQkp4nQEutBKQdc1xTOGpRbhka1BlDkfZXRd1
         IRaO/Pr4P36KzfTPzo/5R/EuvQE80Jnu4ZZqVsyt7//FOLTmudhJxqlhe57w2IMjDzNy
         1vPMu3ge4BO8Tv1kHrzq4AIvx2zEqfs+1/mjcApkjXRM43JRXVnmloN0vad/OyQ5c8mG
         /q0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AAt8zgFXQyxsjPv4JL8VqdIponIe0JaRegcmCycE6Qo=;
        b=bC5kJ4WKsg3jRDAeJJUyRIXPTb12/e5DXb2UW7Wz8fPXkEUKuOPiTrcj/LEPW70B1W
         ohtj7m9BUiqycaRVxdk8pF6LCn3vcBXkMgmUR79RYbANRg485laYvHPw7Xj4MfXbhTkZ
         587Ock4kQPmqI0M/H8zAW6jLQViE8dmL6AGXeOYdICq5VN32Jqh2qJZONiacC6mwOhiT
         0zZhnZRKjIN2lhZIBeERd7d4nZ1kk5Wnpbtax1Mf0wQDGis3OboY+u4+kiKeBy0RAiIu
         wYg99yoMsl1WxIZfS4DJTIqjC+sRP+qsC0w2b7GoBF+WEmZBSoDorMgYFDnaipd+rNp/
         IDqw==
X-Gm-Message-State: AOAM5329rOkUCDNGJOgG7GRhXtbap+ngztmQoKDrlsM4a7b/4jFJsR54
        8W4LuInvYIo+2JScoq+V0Rg=
X-Google-Smtp-Source: ABdhPJxWYorrhFdSskXEJz+W5dTiVVc2YhtNPwL9XlgtCdI0INAGiCSqz3WOtoVvs5k48Srgybt5qA==
X-Received: by 2002:a05:6a00:2247:: with SMTP id i7mr455519pfu.217.1596137568161;
        Thu, 30 Jul 2020 12:32:48 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id m24sm2587727pff.45.2020.07.30.12.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 12:32:47 -0700 (PDT)
Date:   Thu, 30 Jul 2020 12:32:45 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200730193245.GB6621@hoboy>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200729105807.GZ1551@shell.armlinux.org.uk>
 <20200729131932.GA23222@hoboy>
 <20200729132832.GA1551@shell.armlinux.org.uk>
 <20200729220748.GW1605@shell.armlinux.org.uk>
 <20200730155326.GB28298@hoboy>
 <20200730183800.GD1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730183800.GD1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 07:38:00PM +0100, Russell King - ARM Linux admin wrote:
> What I ended up doing was:
> 
>         if (ops->get_ts_info) {
>                 ret = ops->get_ts_info(dev, info);
>                 if (ret != -EOPNOTSUPP)
>                         return ret;
>         }
>         if (phy_has_tsinfo(phydev))
>                 return phy_ts_info(phydev, info);
> ...
> 
> which gives the MAC first refusal.  If the MAC wishes to defer to
> phylib or the default, it can just return -EOPNOTSUPP.

I guess that makes sense.  If someone designs a board that happens to
have a PHY with unwanted time stamping fcunctionality, then at least
the MAC time stamping function will work.  If the designers really
want PHY time stamping, then they are likely to have to patch the MAC
driver in any case.

So I'm not against such a change.  It would be important to keep the
current "PHY-friendly" MAC drivers still friendly, and so they would
need patching as part of the change.

Thanks,
Richard

