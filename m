Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB54083D0E
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfHFV6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:58:10 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41712 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfHFV6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 17:58:09 -0400
Received: by mail-pl1-f195.google.com with SMTP id m9so38265132pls.8
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 14:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sIpKrhEM5/tp8Qz70zYOUEplPaoReCoRwp7XJifEk9E=;
        b=Nr8ioY5nkZ+hHZ2Vd0oyyKHnIg7xCeor9Xlx0BbFopNr74mYCyFu7X0ek69HSI5/LQ
         maJ99kveqAiDiqbNJdgPtA5yLsZQI6UQrJL6G8uHOU4Ma+ZscOetJr33ovKX8TU3Rr+u
         2kfVMzj12XkP7J1hltyE6y08214mXxwdmJjmU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sIpKrhEM5/tp8Qz70zYOUEplPaoReCoRwp7XJifEk9E=;
        b=aMfgRlDbh7FrekomPg6NHbOHWsh+K82qoMnvKbHGT+BVRyyHRqP/2s1Pn6YFX57Qmm
         FuIPIGNQdQLjqaJLTVxAhiUVp0vq5E9+iedDUMi51bG9ya5wOAh6cL471sZrv4m+EWBx
         NL3qeZUNzALmCS4Jw620rAYqc9rsEcHn6THQxuErk2F1jETJbnpRQubyqlAj6iPR9CTe
         HpBuCw724APB6fOo2YwlCpZXFM9Gqk0IvSe5miYgoH/VoiWmg9sj7RhBAk1fgTEK5dTV
         nEIW6/3gt3oNYKs3LPdRslyG2kLchK1KiJSngIu3xq123kkdeHBzpkSXjU5IKkhawCQ1
         Q9Ow==
X-Gm-Message-State: APjAAAWGiKilSJM4u3yrkGUbjao6TuCNIozPAvTibSO67300u7xCCFfg
        hp3793oUfJc6uqsOWUX1N44ZOA==
X-Google-Smtp-Source: APXvYqxVXktSpq1nZpGeh9uN+NMaAvCm4lZBgla+rcPaGxxPGYsYZt2arEhRJcrXpXSlw2j3J8jLNg==
X-Received: by 2002:a17:902:1aa:: with SMTP id b39mr5246938plb.333.1565128688993;
        Tue, 06 Aug 2019 14:58:08 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id x128sm131544170pfd.17.2019.08.06.14.58.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 14:58:07 -0700 (PDT)
Date:   Tue, 6 Aug 2019 14:58:01 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v4 3/4] net: phy: realtek: Add helpers for accessing
 RTL8211E extension pages
Message-ID: <20190806215801.GN250418@google.com>
References: <20190801190759.28201-1-mka@chromium.org>
 <20190801190759.28201-4-mka@chromium.org>
 <71d817b9-7bcc-9f83-331d-1c3958c41f51@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <71d817b9-7bcc-9f83-331d-1c3958c41f51@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 04, 2019 at 10:33:30AM +0200, Heiner Kallweit wrote:
> On 01.08.2019 21:07, Matthias Kaehlcke wrote:
> > The RTL8211E has extension pages, which can be accessed after
> > selecting a page through a custom method. Add a function to
> > modify bits in a register of an extension page and a helper for
> > selecting an ext page. Use rtl8211e_modify_ext_paged() in
> > rtl8211e_config_init() instead of doing things 'manually'.
> > 
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> > Changes in v4:
> > - don't add constant RTL8211E_EXT_PAGE, it's only used once,
> >   use a literal instead
> > - pass 'oldpage' to phy_restore_page() in rtl8211e_select_ext_page(),
> >   not 'page'
> > - return 'oldpage' in rtl8211e_select_ext_page()
> > - use __phy_modify() in rtl8211e_modify_ext_paged() instead of
> >   reimplementing __phy_modify_changed()
> > - in rtl8211e_modify_ext_paged() return directly when
> >   rtl8211e_select_ext_page() fails
> > ---
> >  drivers/net/phy/realtek.c | 48 +++++++++++++++++++++++++++------------
> >  1 file changed, 34 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> > index a669945eb829..e09d3b0da2c7 100644
> > --- a/drivers/net/phy/realtek.c
> > +++ b/drivers/net/phy/realtek.c
> > @@ -53,6 +53,36 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
> >  	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
> >  }
> >  
> > +static int rtl8211e_select_ext_page(struct phy_device *phydev, int page)
> 
> The "extended page" mechanism doesn't exist on RTL8211E only. A prefix
> rtl821x like in other functions may be better therefore.

Sounds good, I'll change it in the next revision

Thanks

Matthias
