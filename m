Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD371EC001
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 18:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgFBQa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 12:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgFBQa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 12:30:28 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98493C05BD1E;
        Tue,  2 Jun 2020 09:30:28 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id i12so1618508pju.3;
        Tue, 02 Jun 2020 09:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oPyGdBUnzVvgkB3aUzywZOPwpJVyWdo1joozTV5qdHQ=;
        b=AiBC9Da91CASqXYBYUQx0aTurxmYzvTNEldDZ+swyu1czxoN/B592J9gVPAIq/VMP/
         o9AxCB9i8pmiw1fxG9ROGWPufeEn3FZwWTnHb5+HXj17a6lmCNzBaIq3f8pOe5E/9FjQ
         /petRefRnkX9Z6Rx0FdcWa0c9372PWJ//IoqmrSSMfhAYv5PxWBlp05AJg5yzFE/1zoZ
         iesN8KM5YegXEiOs6mJ/2zJBE2o1RD3FlZpnHd6RjZl/T7c2O0Pn9FHGZCnIZC5LLp/H
         ncC7adxK31kfe3xYAv5BlHuE1r7P38uQtxbxQXCb4cx/3U+gdJHMF3gRp/1QSPCGy+Bb
         4WsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oPyGdBUnzVvgkB3aUzywZOPwpJVyWdo1joozTV5qdHQ=;
        b=D7UsofBazfI7jcqaQAiyU8+UN+c/63Zip5Eunpa/02foEH6zmmlcenb5khLGq3L5cs
         6pkOqft3tBeL8qPR/aB7i4FXgxzv8xWgrW59Wxi/0o0u05IxxIQxwviksI0+vZ67FuxA
         CfRRj7LI+1kURnDs1o7VUu5FjTFHPEEptFNFAKS88G+7dwIEb23kz/dH3cgEIHaCa5MJ
         KHyWLhT+KNg8IZud7y9/vjHq16Czt6okKzWKC/8NtzYbbdFzZaowLXt1Kk0UPFVYF3zU
         HrkuqTE0ESEj4jGzcMhcMiAuEvbC5uH7hhduAE8G4uWh7qsJSyteULHK7faiLYJK3fmx
         YY5A==
X-Gm-Message-State: AOAM531C+dNYQ8hZU1sL0sYqhndj25NknWS/ubrN3yhmJ1qNGexvcdAq
        KWL9FoLyqm6TUIxHz1XAHVU=
X-Google-Smtp-Source: ABdhPJx6Ls/DWASSP5arWojUIcrvrYeeG7D2JhRbQ8KTcnLGNmVQhL4CfAsuOUxzvX7eKOG4FEFOCQ==
X-Received: by 2002:a17:902:bd42:: with SMTP id b2mr24532845plx.13.1591115428064;
        Tue, 02 Jun 2020 09:30:28 -0700 (PDT)
Received: from localhost ([162.211.223.96])
        by smtp.gmail.com with ESMTPSA id s197sm3024029pfc.188.2020.06.02.09.30.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jun 2020 09:30:27 -0700 (PDT)
Date:   Wed, 3 Jun 2020 00:30:22 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Kevin Groeneveld <kgroeneveld@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, David Miller <davem@davemloft.net>,
        corbet@lwn.net, tglx@linutronix.de, gregkh@linuxfoundation.org,
        allison@lohutok.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 09/10] net: phy: smsc: use
 phy_read_poll_timeout() to simplify the code
Message-ID: <20200602163022.GA6169@nuc8i5>
References: <20200323150600.21382-1-zhengdejin5@gmail.com>
 <20200323150600.21382-10-zhengdejin5@gmail.com>
 <CABF+-6W-yo=CzaMaASdRGm5TS-JCnC5kGwPZHMce9OLPDCUw-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABF+-6W-yo=CzaMaASdRGm5TS-JCnC5kGwPZHMce9OLPDCUw-g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 02:58:21PM -0400, Kevin Groeneveld wrote:
> On Mon, Mar 23, 2020 at 11:10 AM Dejin Zheng <zhengdejin5@gmail.com> wrote:
> >
> > use phy_read_poll_timeout() to replace the poll codes for
> > simplify lan87xx_read_status() function.
> >
> > Suggested-by: Andrew Lunn <andrew@lunn.ch>
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> > ---
> > v6 -> v7:
> >         - adapt to a newly added parameter sleep_before_read.
> > v5 -> v6:
> >         - no changed.
> > v4 -> v5:
> >         - add msleep before phy_read_poll_timeout() to keep the
> >           code more similar
> > v3 -> v4:
> >         - add this patch by Andrew's suggestion. Thanks Andrew!
> >
> >  drivers/net/phy/smsc.c | 16 +++++-----------
> >  1 file changed, 5 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> > index b73298250793..93da7d3d0954 100644
> > --- a/drivers/net/phy/smsc.c
> > +++ b/drivers/net/phy/smsc.c
> > @@ -112,8 +112,6 @@ static int lan87xx_read_status(struct phy_device
> *phydev)
> >         int err = genphy_read_status(phydev);
> >
> >         if (!phydev->link && priv->energy_enable) {
> > -               int i;
> > -
> >                 /* Disable EDPD to wake up PHY */
> >                 int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
> >                 if (rc < 0)
> > @@ -125,15 +123,11 @@ static int lan87xx_read_status(struct phy_device
> *phydev)
> >                         return rc;
> >
> >                 /* Wait max 640 ms to detect energy */
> > -               for (i = 0; i < 64; i++) {
> > -                       /* Sleep to allow link test pulses to be sent */
> > -                       msleep(10);
> > -                       rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
> > -                       if (rc < 0)
> > -                               return rc;
> > -                       if (rc & MII_LAN83C185_ENERGYON)
> > -                               break;
> > -               }
> > +               phy_read_poll_timeout(phydev, MII_LAN83C185_CTRL_STATUS,
> > +                                     rc & MII_LAN83C185_ENERGYON, 10000,
> > +                                     640000, true);
> > +               if (rc < 0)
> > +                       return rc;
> >
> >                 /* Re-enable EDPD */
> >                 rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
> > --
> > 2.25.0
> >
> 
> This patch causes the kernel log to be spammed with the following when
> Ethernet cable is not connected:
> SMSC LAN8710/LAN8720 2188000.ethernet-1:00: lan87xx_read_status failed: -110
>
Kevin, I am very sorry for the trouble caused by my patch. 

> It still seems to work but I think that is only a fluke.
> 
> The "if (rc < 0)" is not actually checking the return value of
> phy_read_poll_timeout but is looking at the value of the register read.  I
> don't think rc will ever be negative in this case.  If you change the code
> to "rc = phy_read_poll_timeout(...)" so that it actually checks the error
> then the function will behave differently than before.  The original code
> would only return an error if phy_read returned an error.  On a timeout it
> just continued.  So the "if" could be changed to "if (rc < 0 && rc !=
> -ETIMEDOUT)".  But you will still get the extra messages in the log that
> were not there before.
>
Yes, My patch did change the original behavior. It will not have error message
whether it is timeout or phy_read fails, but my patch changed it and will
print some error messages. It is my mistake. I'm so sorry for that.
How do you think of the following fix?

> >                 /* Wait max 640 ms to detect energy */
> > -               for (i = 0; i < 64; i++) {
> > -                       /* Sleep to allow link test pulses to be sent */
> > -                       msleep(10);
> > -                       rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
> > -                       if (rc < 0)
> > -                               return rc;
> > -                       if (rc & MII_LAN83C185_ENERGYON)
> > -                               break;
> > -               }
> > +               phy_read_poll_timeout(phydev, MII_LAN83C185_CTRL_STATUS,
> > +                                     rc & MII_LAN83C185_ENERGYON, 10000,
> > +                                     640000, true);
> > +               if (rc < 0)
> > +                       return rc;

		ret = read_poll_timeout(phy_read, rc, rc & MII_LAN83C185_ENERGYON || rc < 0,                                                         
		       		10000, 640000, true, phydev, MII_LAN83C185_CTRL_STATUS);
		if (!ret && rc < 0)
			return rc;
BR,
Dejin
>
> Kevin
