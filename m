Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38145412BD2
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350862AbhIUCi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346413AbhIUCSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:18:21 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FD9C066ECB
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:36:46 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id v24so64971260eda.3
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8STq4tXqX/qFW7zu7c0l82H0nFqebVqytytxlkiGF4M=;
        b=T27j9HdGWVdUIPTWNs+mBZHux3dE0M+fgVP3cN9WAr1sfkFV46cSCv2LoiYlzQFcO+
         6tC1LfsAjDvkMvX9UZwmaeKErDLeA4b6++zC/Tg67R2T5xjvl4k2B55WCenotub1LvRA
         o64U8U/mBoE0cSeB7fil1N8ZQSBN9Ghssbz/f6BEqfIuTH/FTl/tjeO4i8Nj7cLuEdIi
         6Ngvczq4K5zRT9ZwigrTqUIcGpBPEqNjL0faXK1sDsml2BFCHIrGeOAvmQI9j/17qzQk
         SsHGovjDuZqJ8TnRDDlg1Y5RnEmWy/dAWYI3kD9tnUTlwWzWJQ7r3HeZdQ2JtT3YNJ4j
         FCqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8STq4tXqX/qFW7zu7c0l82H0nFqebVqytytxlkiGF4M=;
        b=0LK1+yO9ubDr7+JSEdki3XDYgbLAX/WUEpZ0CK9FsDCXDpfb9LNVgCFmhrlCLSBUHm
         YhmlP+ae9BsQV+qtSxRHreBU98OsNfdvo9SIhlOXqbu/EqYH8hcYASSRdkHEcTQ5o65B
         UFZTKk1JpIhd74/dra5rff5tEPwBAOEZZQhAZqIm5l+YTTp4g/6tD4NAvLEeaFK8++yO
         mCWsMTtLOlf3a9XD362lCReJKdMoWGyx8quUdXF1/17twFEryncxzyBWT9cFhn42DJZe
         4tLNV9y41PD6factJefmw0pcd2/yVwPlqRVXmS5sDfOlVEPRMtcb2FROX/MzvqcYYMn2
         Exnw==
X-Gm-Message-State: AOAM530LV/iFgPRvCRSj4sZXZWTjP+7M0qsOm3hcinVBm1xjgM9nTwXP
        KWcAXewq9EK80yMZd/wyATs=
X-Google-Smtp-Source: ABdhPJyR9OpOjS/R6wUefRF1NQGnhXqKzaHyJlwHmKqb2RTyRwspgJkaim+fIJGzeh8L31i7lJ9mNQ==
X-Received: by 2002:a50:f145:: with SMTP id z5mr30799441edl.4.1632163005547;
        Mon, 20 Sep 2021 11:36:45 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id di4sm7458722edb.34.2021.09.20.11.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 11:36:45 -0700 (PDT)
Date:   Mon, 20 Sep 2021 21:36:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: Race between "Generic PHY" and "bcm53xx" drivers after
 -EPROBE_DEFER
Message-ID: <20210920183643.becqhjik2rl6ri3h@skbuf>
References: <3639116e-9292-03ca-b9d9-d741118a4541@gmail.com>
 <4648f65c-4d38-dbe9-a902-783e6dfb9cbd@gmail.com>
 <20210920170348.o7u66gpwnh7bczu2@skbuf>
 <11994990-11f2-8701-f0a4-25cb35393595@gmail.com>
 <20210920174022.uc42krhj2on3afud@skbuf>
 <25e4d46a-5aaf-1d69-162c-2746559b4487@gmail.com>
 <20210920180240.tyi6v3e647rx7dkm@skbuf>
 <e010a9da-417d-e4b2-0f2f-b35f92b0812f@gmail.com>
 <20210920181727.al66xrvjmgqwyuz2@skbuf>
 <d2c7a300-656f-ffec-fb14-2b4e99f28081@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2c7a300-656f-ffec-fb14-2b4e99f28081@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:25:06AM -0700, Florian Fainelli wrote:
> On 9/20/21 11:17 AM, Vladimir Oltean wrote:
> [snip]
> >> All I am saying is that there is not really any need to come up with a
> >> Device Tree-based solution since you can inspect the mdio_device and
> >> find out whether it is an Ethernet PHY or a MDIO device proper, and that
> >> ought to cover all cases that I can think of.
> > 
> > Okay, but where's the problem? I guess we're on the same page, and
> > you're saying that we should not be calling bcma_mdio_mii_register, and
> > assigning the result to bgmac->mii_bus, because that makes us call
> > bcma_phy_connect instead of bgmac_phy_connect_direct. But based on what
> > condition? Simply if bgmac->phyaddr == BGMAC_PHY_NOREGS?
> 
> Yes simply that condition, I really believe it ought to be enough for
> the space these devices are in use.

So the last question is, are the link parameters advertised by the
switch pseudo PHY identical with the link parameters advertised by the
fixed PHY instantiated by bgmac_phy_connect_direct? If they are, is it
intended or merely a coincidence?
