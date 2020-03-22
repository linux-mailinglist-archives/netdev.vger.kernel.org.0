Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7957D18EA38
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 17:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgCVQSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 12:18:22 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39613 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbgCVQSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 12:18:21 -0400
Received: by mail-pg1-f195.google.com with SMTP id b22so5863467pgb.6;
        Sun, 22 Mar 2020 09:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZgXf5QsLU8moUeFbGruEqUCy/5/OEI1y7w06IrP82bU=;
        b=RtLaXqzwZI9+/JGvMRZAHdpZi8i8pV0EDDKeoyZeKUR7X0F+Y1CGzGNtCwdlSZ9zFs
         rparodvlt1pi2kMcwA5cPjdY0AcEzgJATpDsoqFG4THrRz1v+uu8xSMMQeio5I//Kj/q
         +l2BnGahK6KoX+vGIsJXyNFdOZez5GO8F5bjNesohBbplmNsbHabWf9+u14bZ4PcJFWL
         HcFmxfGwB15OdcFUPVxtmFDLAamB/tx7MvVaWb+mORSFuhmEcO3ZX4Pslz17xzB1TerA
         Hb8WBZdzu68ADjptzoZgwSdD2X//RkO1YwTcPekPY+BuRd8y04QJWJLnIySslbUU6EEG
         7u0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZgXf5QsLU8moUeFbGruEqUCy/5/OEI1y7w06IrP82bU=;
        b=PjUDgJkjIidbUvKY3QTyG+4l+fkSpP11DpvL5Y2P3lsOZ5/+z5ZdTCq4CfrQ5JpG6J
         12zSEwBTnVzRQele+7HuSGJiqg3R5/3z/CeuxnuN2gmjSlkWLD2INnaFcjPxAHlPao25
         Ptj7Qe2TWcWArtvGsH7pcBP5ZOmOmfQDNqZfBpfOa4zwn8RvAtsfGJLmc23MJJA2O4sM
         A6Q0qkl/qfkXIZa5YO/ym9HuFMxlSLsGf2zhT6rmnDp+4vJyE6a/VIy5vAP8eDgu7Zgl
         BiaWXYJUzLv7zzz5q2V4F5dMgGOjC9Mpeh5OapMJG0sucRdoHSIADKPrEAG+VGBJOLz5
         rCIg==
X-Gm-Message-State: ANhLgQ2imhliaLRtci4jyEfKhmjSBaoXAIrnhSfRdTpDH1TeD8TfKxHY
        +rtbCQbZTQx/6F6vzfBX4RU=
X-Google-Smtp-Source: ADFU+vvan0sQfqD07F/TK9MP8hmyuLR1qMO7rFAedZvxNYSgKXU619VndCDd+iPYT9613B2mXnn6Pg==
X-Received: by 2002:a63:1e57:: with SMTP id p23mr18544525pgm.316.1584893899795;
        Sun, 22 Mar 2020 09:18:19 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id mq18sm10682596pjb.6.2020.03.22.09.18.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 09:18:19 -0700 (PDT)
Date:   Mon, 23 Mar 2020 00:18:14 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        broonie@kernel.org, alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 6/9] net: phy: marvell10g: use
 phy_read_mmd_poll_timeout() to simplify the code
Message-ID: <20200322161814.GA20189@nuc8i5>
References: <20200322065555.17742-1-zhengdejin5@gmail.com>
 <20200322065555.17742-7-zhengdejin5@gmail.com>
 <20200322153659.GO11481@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322153659.GO11481@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 04:36:59PM +0100, Andrew Lunn wrote:
> > --- a/drivers/net/phy/marvell10g.c
> > +++ b/drivers/net/phy/marvell10g.c
> > @@ -241,22 +241,17 @@ static int mv3310_power_up(struct phy_device *phydev)
> >  
> >  static int mv3310_reset(struct phy_device *phydev, u32 unit)
> >  {
> > -	int retries, val, err;
> > +	int val, err;
> >  
> >  	err = phy_modify_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1,
> >  			     MDIO_CTRL1_RESET, MDIO_CTRL1_RESET);
> >  	if (err < 0)
> >  		return err;
> >  
> > -	retries = 20;
> > -	do {
> > -		msleep(5);
> > -		val = phy_read_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1);
> > -		if (val < 0)
> > -			return val;
> > -	} while (val & MDIO_CTRL1_RESET && --retries);
> 
> This is another example of the sleep happening first. To keep the code
> more similar, you probably should add an msleep(5) before calling
> phy_read_mmd_poll_timeout().
> 
> 	Andrew
Andrew, you're right, do it right away. Thank you for helping me so
patiently!

