Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9112F1F1043
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 00:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgFGWab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 18:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgFGWaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 18:30:30 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09545C08C5C3
        for <netdev@vger.kernel.org>; Sun,  7 Jun 2020 15:30:29 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id d6so5190794pjs.3
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 15:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OSASK+3X/fSSI7ny5aNfN21EmPCbzFlJKFZbkDaEweQ=;
        b=VvlR6brjRXBuwZ3tpMAy02H5gZcwlasl4qJ+CdlPknKlK6J1DKUAygqTgjqGui2Pu2
         VC40RGolqWQ5efcCkmJ9hdPad8zQXZFUwP+f/4T7edNil1ExJvNSwm/jlYa/kcPjTcxe
         kuQ//EzpMGrwVoaMNUSavL4CZrD+f/l6yL8tt+IUZwgH9C97TZAP2YkaXFhx6Bk3soSw
         wiNaDbGlYNx/EzzjuvIP3yt33W2pI3xb46qjtHQgiU4ZZakeMNWLL5AeRwbq5X3ceZ1U
         Z3qdTVCRCMlrYqk5czIZipjrVSriZTxhPdVUHq0ecRHDvtxtQ5QRhyFPo69+PFkMVLYz
         Aaww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OSASK+3X/fSSI7ny5aNfN21EmPCbzFlJKFZbkDaEweQ=;
        b=dnN+Gs+qbiaJMl4UsFBdhDF+tPZ+lqtypCO3wIy7deElxC2y/vX8ubCU5Oo2tVvOE7
         WSZpN71ovI6CGM46VEIwgdyVtKzjJnVy55+SFbj3lKw4Km1k03eb8+DvxYE5nS4fpKGb
         MrfmgP0WFtrHNX85u3kMsXSLWtmQh64AFNnjMMn3jntPijHpujo5iOWBRp4lQoMbuGU6
         wd1ez/SGMe6NeysteHmEiXIsJmuxQpTu+6oUAfOcz1wJBrif7D3tk6kHZ7sywL6DbzIU
         6Yv3pXeOi7YXErt2xIUaq+pDFlsjnYSd2F2F8mUd8J4vidvvztTBArZyKVrGMfVbGSk9
         k7MA==
X-Gm-Message-State: AOAM532WD5pb2Os5iMQLAR57MAGSa5Na7eMN6zDcX0KrQ749gABQoFse
        MnDJjD2xnHg6c2TrJmkJiRIIwQ==
X-Google-Smtp-Source: ABdhPJx28YlWY0X68MCd/y/7sg3uZjiuj416dL7rHADKc/gSN2t4z1r0jfS5xPsHMZl4FzWYlW7qMQ==
X-Received: by 2002:a17:902:558f:: with SMTP id g15mr18381316pli.174.1591569029270;
        Sun, 07 Jun 2020 15:30:29 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d4sm13615305pjm.55.2020.06.07.15.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 15:30:28 -0700 (PDT)
Date:   Sun, 7 Jun 2020 15:30:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
Message-ID: <20200607153019.3c8d6650@hermes.lan>
In-Reply-To: <20200526091025.25243-1-o.rempel@pengutronix.de>
References: <20200526091025.25243-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 11:10:25 +0200
Oleksij Rempel <o.rempel@pengutronix.de> wrote:

> This UAPI is needed for BroadR-Reach 100BASE-T1 devices. Due to lack of
> auto-negotiation support, we needed to be able to configure the
> MASTER-SLAVE role of the port manually or from an application in user
> space.
> 
> The same UAPI can be used for 1000BASE-T or MultiGBASE-T devices to
> force MASTER or SLAVE role. See IEEE 802.3-2018:
> 22.2.4.3.7 MASTER-SLAVE control register (Register 9)
> 22.2.4.3.8 MASTER-SLAVE status register (Register 10)
> 40.5.2 MASTER-SLAVE configuration resolution
> 45.2.1.185.1 MASTER-SLAVE config value (1.2100.14)
> 45.2.7.10 MultiGBASE-T AN control 1 register (Register 7.32)
> 
> The MASTER-SLAVE role affects the clock configuration:
> 
> -------------------------------------------------------------------------------
> When the  PHY is configured as MASTER, the PMA Transmit function shall
> source TX_TCLK from a local clock source. When configured as SLAVE, the
> PMA Transmit function shall source TX_TCLK from the clock recovered from
> data stream provided by MASTER.
> 
> iMX6Q                     KSZ9031                XXX
> ------\                /-----------\        /------------\
>       |                |           |        |            |
>  MAC  |<----RGMII----->| PHY Slave |<------>| PHY Master |
>       |<--- 125 MHz ---+-<------/  |        | \          |
> ------/                \-----------/        \------------/
>                                                ^
>                                                 \-TX_TCLK
> 
> -------------------------------------------------------------------------------
> 
> Since some clock or link related issues are only reproducible in a
> specific MASTER-SLAVE-role, MAC and PHY configuration, it is beneficial
> to provide generic (not 100BASE-T1 specific) interface to the user space
> for configuration flexibility and trouble shooting.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

NAK
Open source projects have been working hard to remove the terms master and slave
in API's and documentation. Apparently, Linux hasn't gotten the message.
It would make sense not to introduce new instances.
