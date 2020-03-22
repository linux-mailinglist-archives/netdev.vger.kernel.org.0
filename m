Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F39518E714
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 07:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgCVGMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 02:12:41 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36600 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgCVGMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 02:12:40 -0400
Received: by mail-pj1-f65.google.com with SMTP id nu11so4469366pjb.1;
        Sat, 21 Mar 2020 23:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=uAK6TKBCDDk7h5/OByrdwQjpqLN9cTxpZB4sdO/I36Y=;
        b=hcXuOW1EBXtoglSD0qea+XzyUQp8VavAOaHF0B22XyLDKgJKUVtG9q4HXB5ojrcc81
         ERWMzeV0bbuw8LusA0hGUnGraIPkk/5bpq51Pe0weKFD9nPRy9Vjz+nXCRxj1JzZz/eS
         9ijoYtwqG4TRQ/TsQjUXckiwZ63aBv8e7eCcceZIbwEtAVfytrYneBagr4aifKULntwg
         ki/c2pBsaMoGQLaKJfi7DGwQ308azZpc0tQFJ/9qiSoOfsVO+DmBKJRztnLDHXFjKYcp
         fcYy+wpuhS3gFfQrwIfLxNI6u92jFYhNrgL/WVlyr6NXCu1ZP+Zd+oQvYr9XwJy8ti7w
         hDCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=uAK6TKBCDDk7h5/OByrdwQjpqLN9cTxpZB4sdO/I36Y=;
        b=enTbH2MyUtpIavy7faa1moiVlvM+JEsJqQl23W/S/dih+IjvqpohqUbz9M9tXaQSBp
         EzGxw9q1aptCH3fTC7ZYMcXrYsIsOWSZl0Cch08U2rnRt4a6GP0+SiD0gClEIBp79xJJ
         ymURT9N1vEWGsy+pGwwUl33H6x2wJrHvpQxbAyxvJgepW5hlgurMcBojFxLvjYrOuFM7
         6F8FTWqFatLGet8Ic2f2nj7xy5GwACZiQm8HqEhTlD2KDLGjEVhM6Y+zdAalW8FCe/6f
         U6ZfdEGuLAsNbMzYEE69Et5T8UPdjr6z1d6GQgkUpDMafXLd4PovQya+30B9Nklv0Yw7
         tTbg==
X-Gm-Message-State: ANhLgQ3Z5HF+93y2d3OxCuUi8t2AUxa97c3O9ZLXeZSiO042Rv0lZaHn
        JAcyqAA9l5JX4Y78oi8+Qbw=
X-Google-Smtp-Source: ADFU+vtgXQJ8cYxetVmdBrDHo0wv4pTnrn8U69MQt06dCBZ+rUg8bxCKHLyMVhBsxDLNsJyDlu9V2g==
X-Received: by 2002:a17:90a:bd0e:: with SMTP id y14mr18698669pjr.11.1584857559562;
        Sat, 21 Mar 2020 23:12:39 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id ck23sm8696181pjb.14.2020.03.21.23.12.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 23:12:39 -0700 (PDT)
Date:   Sun, 22 Mar 2020 14:12:25 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, allison@lohutok.net, tglx@linutronix.de,
        gregkh@linuxfoundation.org, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 7/7] net: phy: use phy_read_poll_timeout() to
 simplify the code
Message-ID: <20200322061225.GA22897@nuc8i5>
References: <20200322024834.31402-1-zhengdejin5@gmail.com>
 <20200322024834.31402-8-zhengdejin5@gmail.com>
 <242d4d32-8559-4ffc-9272-7ee1efc30793@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <242d4d32-8559-4ffc-9272-7ee1efc30793@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 07:57:11PM -0700, Florian Fainelli wrote:
> 
> 
> On 3/21/2020 7:48 PM, Dejin Zheng wrote:
> > use phy_read_poll_timeout() to replace the poll codes for
> > simplify the code in phy_poll_reset() function.
> > 
> > Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> > ---
> > v2 -> v3:
> > 	- adapt to it after modifying the parameter order of the
> > 	  newly added function
> > v1 -> v2:
> > 	- remove the handle of phy_read()'s return error.
> > 
> >  drivers/net/phy/phy_device.c | 16 ++++------------
> >  1 file changed, 4 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index a585faf8b844..cfe7aae35084 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -1059,23 +1059,15 @@ EXPORT_SYMBOL(phy_disconnect);
> >  static int phy_poll_reset(struct phy_device *phydev)
> >  {
> >  	/* Poll until the reset bit clears (50ms per retry == 0.6 sec) */
> > -	unsigned int retries = 12;
> > -	int ret;
> > -
> > -	do {
> > -		msleep(50);
> > -		ret = phy_read(phydev, MII_BMCR);
> 
> You are doing some subtle changes here, the sleep used to be *before*
> the read of BMCR and now it will be *after*. If there were PHY devices
> that required 50ms at least, but would incorrectly return that
> BMCR_RESET is cleared *before* 50ms, then we would be breaking those.
> 
> I would recommend we drop this patch for now, the rest looks good to me
> though.

Hi Florian��

Thanks very much for your comments, I will drop this patch, and can I get
your ack/reviewed-by for the rest patches? thanks again!

BR,
dejin

> -- 
> Florian
