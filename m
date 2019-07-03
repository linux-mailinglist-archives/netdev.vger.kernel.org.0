Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF735EDB7
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfGCUgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:36:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44996 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfGCUgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:36:53 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so1780074pgl.11
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 13:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rfHYB+lTiI64lxTRcrT8/UH1l7TT30GDFo4j4mMP0os=;
        b=lzqeBcEuokgv9F+An1HdqVa1FTlpZRSoxJVcua0QQjegnNqpBg13lqdi5uQD9G4S1A
         zzo2oYALjBRFRF6PsnkhuJjeEtqUHtc4uzNZKKitT/lsjVFmiwZrCIepl+bIri9ldgo/
         kOhgUwfQa1yH/168NopNHSZYBWEp/1YkmWVUY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rfHYB+lTiI64lxTRcrT8/UH1l7TT30GDFo4j4mMP0os=;
        b=jxOOFf6zJd5v1Ikt7tXWkBvHQZdgKQtEmBkqGiETdoqycCQgZxrbzkjBGRR9ujUTDE
         WJfs25Q154pWnJ1JjT73sna3Kp3YfXt/72jftIbOdyGl8/h9Lu/Z1kVyBxwIGlN9IObL
         T9aGbj7KfqqHh4WB5LoaHTtnV9JHyKIbwosIe5vHUaRTy4QVKuugKogS66G2RsbjBTIM
         Xltb3Z7SU65P64fbbLbpCljoiBm7gXXnX+20Vk1VhcnUnbLgoy/jwyDlsgy/y7u1SZ3b
         cJQOCBr+rLX5w5+b/WpdYUfWLzIj9Is8hfVUZCGamoJYi3iwSrjn3WwXsTTHOtH+zcbL
         1rQA==
X-Gm-Message-State: APjAAAUccR0qQ5VeE3OmhGP699i4h2BL6Cj03auLhQdpVjDyq4LI2tlK
        qamGeZKErYeJQYU80/ouJ+xvzQ==
X-Google-Smtp-Source: APXvYqzQxQSIwg820yjADqUQOcipDJH4aw/rukCrBqhLYubTwlnkIxMpQhcr9BOdFoKBZowj+r6xTQ==
X-Received: by 2002:a63:f817:: with SMTP id n23mr39418076pgh.35.1562186212565;
        Wed, 03 Jul 2019 13:36:52 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id u7sm3080371pgr.94.2019.07.03.13.36.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 13:36:51 -0700 (PDT)
Date:   Wed, 3 Jul 2019 13:36:50 -0700
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
Subject: Re: [PATCH v2 4/7] net: phy: realtek: Enable accessing RTL8211E
 extension pages
Message-ID: <20190703203650.GF250418@google.com>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-4-mka@chromium.org>
 <dd7a569b-41e4-5925-88fc-227e69c82f67@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dd7a569b-41e4-5925-88fc-227e69c82f67@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 10:12:12PM +0200, Heiner Kallweit wrote:
> On 03.07.2019 21:37, Matthias Kaehlcke wrote:
> > The RTL8211E has extension pages, which can be accessed after
> > selecting a page through a custom method. Add a function to
> > modify bits in a register of an extension page and a helper for
> > selecting an ext page.
> > 
> > rtl8211e_modify_ext_paged() is inspired by its counterpart
> > phy_modify_paged().
> > 
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> > Changes in v2:
> > - assign .read/write_page handlers for RTL8211E
> 
> Maybe this was planned, but it's not part of the patch.

Oops, it was definitely there when I tested ... I guess this got
somehow lost when changing the patch order and resolving minor
conflicts, seems like I only build tested after that :/

> > - use phy_select_page() and phy_restore_page(), get rid of
> >   rtl8211e_restore_page()
> > - s/rtl821e_select_ext_page/rtl8211e_select_ext_page/
> > - updated commit message
> > ---
> >  drivers/net/phy/realtek.c | 42 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 42 insertions(+)
> > 
> > diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> > index eb815cbe1e72..9cd6241e2a6d 100644
> > --- a/drivers/net/phy/realtek.c
> > +++ b/drivers/net/phy/realtek.c
> > @@ -27,6 +27,9 @@
> >  #define RTL821x_EXT_PAGE_SELECT			0x1e
> >  #define RTL821x_PAGE_SELECT			0x1f
> >  
> > +#define RTL8211E_EXT_PAGE			7
> > +#define RTL8211E_EPAGSR				0x1e
> > +
> >  /* RTL8211E page 5 */
> >  #define RTL8211E_EEE_LED_MODE1			0x05
> >  #define RTL8211E_EEE_LED_MODE2			0x06
> > @@ -58,6 +61,44 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
> >  	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
> >  }
> >  
> > +static int rtl8211e_select_ext_page(struct phy_device *phydev, int page)
> > +{
> > +	int ret, oldpage;
> > +
> > +	oldpage = phy_select_page(phydev, RTL8211E_EXT_PAGE);
> > +	if (oldpage < 0)
> > +		return oldpage;
> > +
> > +	ret = __phy_write(phydev, RTL8211E_EPAGSR, page);
> > +	if (ret)
> > +		return phy_restore_page(phydev, page, ret);
> > +
> > +	return 0;
> > +}
> > +
> > +static int __maybe_unused rtl8211e_modify_ext_paged(struct phy_device *phydev,
> > +				    int page, u32 regnum, u16 mask, u16 set)
> 
> This __maybe_unused isn't too nice as you use the function in a subsequent patch.

It's needed to avoid a compiler warning (unless we don't care about
that for an interim version), the attribute is removed again in the
next patch.
