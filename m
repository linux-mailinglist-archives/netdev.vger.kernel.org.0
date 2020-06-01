Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010421EAF70
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgFATFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgFATFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 15:05:41 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3C6C061A0E;
        Mon,  1 Jun 2020 12:05:40 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id z5so10272767ejb.3;
        Mon, 01 Jun 2020 12:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uJb5msRtCD1x8pgkizgsyhzQFL+3ycJ+2vw4HKOf/yY=;
        b=PvQa4jb1a5l049GVtKQzUaa9HzMu5V0NFS4pPO/r/Ubwobpg7XtNAeO3xWZ6O1OxTl
         KmXECjT418ZWJJkX2PbrBRI/R0cSX55KSbNSht+0JBn7dOsR3T2FtPPbXLqNQPfzwQr9
         +/OlsiSn1XXQMiXF9CZznu99YbcVgdCBslZ95H68s7tHTCDmAXhnAvywQEMISt8pDjqt
         afCJbVHTqLB4MoIFrctjU8v/I9ZRQdR4JV+c0uagF4R+fa5liBXfVwNtvCgEO7WvQgPt
         yUUe0Ised6k5wJ92kFUgZtgp/1fqa0qeUngCZFiayd5r6zeuXtslW7sISQaP0EAYJ0M4
         6ZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uJb5msRtCD1x8pgkizgsyhzQFL+3ycJ+2vw4HKOf/yY=;
        b=lEO+i2cj4bK3FRP5YBtnhft0nbh/lzhT4s3TUJGLT43y06mBVaOybuoD9/Fx7mbT1C
         DQw/sIcFNAdyDs+teSP21+B0mPd2X4PL8ULYmqsr4hYYy0H/SkPqCXMRtfthcbjREBkd
         ZyMJ5mhyiXcbE5eBU6iwTnVWLSTQiW9Gm5UTl8331k18ipQFuQD++D7UyHonXLCpgnAk
         THsXqm3Fd8120/PHmWb+XZwRd36jQRU03hI10wIVRd9xS4g3ReUObFIEsWUtHaJWRtG4
         +0dcPu7+xUnl8wNOBJnbix+ywEJAMtUNYjuVS0pCPbKfSyJLM8YtgpQM9RQMYZXs5KqK
         HRQg==
X-Gm-Message-State: AOAM5318gHgLTLFw6AweFtjsCk8a+xbiwWM2kWL+8Dd35I8nhFBG2x3y
        +7o32s4QekpSuRVi0sz4W1C1drxbbQ6flBQF89o=
X-Google-Smtp-Source: ABdhPJzq4NVHoG3HeDx2g5wfQKmBi0y+M7wu7p5yMfLNP7sbeXv9L0nwpNy93yeyjbvVA2uHVLhNevtoxxgUML6QUWQ=
X-Received: by 2002:a17:907:b03:: with SMTP id h3mr22108613ejl.367.1591038339242;
 Mon, 01 Jun 2020 12:05:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200323150600.21382-1-zhengdejin5@gmail.com> <20200323150600.21382-10-zhengdejin5@gmail.com>
In-Reply-To: <20200323150600.21382-10-zhengdejin5@gmail.com>
From:   Kevin Groeneveld <kgroeneveld@gmail.com>
Date:   Mon, 1 Jun 2020 15:05:27 -0400
Message-ID: <CABF+-6UhnXVzJEnm-4K0hMd=Y53CDK=y2GfNuPVFzAN6w7HCYA@mail.gmail.com>
Subject: Re: [PATCH net-next v7 09/10] net: phy: smsc: use phy_read_poll_timeout()
 to simplify the code
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, David Miller <davem@davemloft.net>,
        corbet@lwn.net, tglx@linutronix.de, gregkh@linuxfoundation.org,
        allison@lohutok.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resent as plain text this time.  Sorry to those that got this twice.

On Mon, Mar 23, 2020 at 11:10 AM Dejin Zheng <zhengdejin5@gmail.com> wrote:
>
> use phy_read_poll_timeout() to replace the poll codes for
> simplify lan87xx_read_status() function.
>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> ---
> v6 -> v7:
>         - adapt to a newly added parameter sleep_before_read.
> v5 -> v6:
>         - no changed.
> v4 -> v5:
>         - add msleep before phy_read_poll_timeout() to keep the
>           code more similar
> v3 -> v4:
>         - add this patch by Andrew's suggestion. Thanks Andrew!
>
>  drivers/net/phy/smsc.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index b73298250793..93da7d3d0954 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -112,8 +112,6 @@ static int lan87xx_read_status(struct phy_device *phydev)
>         int err = genphy_read_status(phydev);
>
>         if (!phydev->link && priv->energy_enable) {
> -               int i;
> -
>                 /* Disable EDPD to wake up PHY */
>                 int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
>                 if (rc < 0)
> @@ -125,15 +123,11 @@ static int lan87xx_read_status(struct phy_device *phydev)
>                         return rc;
>
>                 /* Wait max 640 ms to detect energy */
> -               for (i = 0; i < 64; i++) {
> -                       /* Sleep to allow link test pulses to be sent */
> -                       msleep(10);
> -                       rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
> -                       if (rc < 0)
> -                               return rc;
> -                       if (rc & MII_LAN83C185_ENERGYON)
> -                               break;
> -               }
> +               phy_read_poll_timeout(phydev, MII_LAN83C185_CTRL_STATUS, rc,
> +                                     rc & MII_LAN83C185_ENERGYON, 10000,
> +                                     640000, true);
> +               if (rc < 0)
> +                       return rc;
>
>                 /* Re-enable EDPD */
>                 rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
> --
> 2.25.0

This patch causes the kernel log to be spammed with the following when
Ethernet cable is not connected:
SMSC LAN8710/LAN8720 2188000.ethernet-1:00: lan87xx_read_status failed: -110

It still seems to work but I think that is only a fluke.

The "if (rc < 0)" is not actually checking the return value of
phy_read_poll_timeout but is looking at the value of the register
read.  I don't think rc will ever be negative in this case.  If you
change the code to "rc = phy_read_poll_timeout(...)" so that it
actually checks the error then the function will behave differently
than before.  The original code would only return an error if phy_read
returned an error.  On a timeout it just continued.  So the "if" could
be changed to "if (rc < 0 && rc != -ETIMEDOUT)".  But you will still
get the extra messages in the log that were not there before.

Kevin
