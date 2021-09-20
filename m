Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597F2412BD6
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350955AbhIUCij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349303AbhIUCZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:25:47 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE493C0A88DE
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:58:59 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id eg28so42500855edb.1
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6exHgK6vGzAOEpe1ocoQSvp6Lvs/E+5qV0A++5q/Iqk=;
        b=Cx782PC/TMmkVC0GOVBe5SmMzh2krQUt91kXVnGtUd4tc4FGsSR8j8jMP/WKThKE2l
         PSyis9Qd5sgbA6Fwk6cdc90Dikgp8aHCjgl/dvD4HQNEgjDnbcMTh1aAsZ5pZH1y1Cg2
         byrcj9C2D6BkOMpnMTL/lCXTqE4GHlrzbNRlII26nO6Uwjl4IsRrG/WNvhsPg2AM08H/
         iYJIjWWW1jaHSOm0vRqeyYGWtezLqgMgKRzBpH1ZCFPELku+NCHGw4IZfe4hLiv4Et0w
         jFufukAkUnXb6gxiDxG6GlD7oLVpFh8aOU6vfb4vlxeTAEkSXQtjmxFhYpJxIjAybxLm
         u39A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6exHgK6vGzAOEpe1ocoQSvp6Lvs/E+5qV0A++5q/Iqk=;
        b=0AqYZ4lxs1qc2ZFYN50jI7gR/wIMEoUydsG9//Yc7ocnFGpJTNQYq9jCly71t4iVS3
         Mp7nq2w9ymEJvqJlPPDqBAF/03S9c5NBgQSTPBomjHsxqqC5t+3SfU/fXb3+eFfaKzhG
         vUEHyBy4D3EvQa9mQckmnvZ9+RcFcCA4w5U2GxfKayllBTIcXkZv21qTNV4+GcTOPqFX
         gvLRISVi2eGPRKkHasgSA8DVN/cRp5CrjfmB4xMpbPrNI1TnNMQN0z/Q9yiR/iYbU16y
         mNBMGGj8V5XIQDL9kuhYLAXAr7eG4pWU3glhSl79Egj0QWPYbjYdNvZ1JWEkXjQogpWR
         pa6Q==
X-Gm-Message-State: AOAM533kTmBhg0d3IRQhaGLE3XHzun1bjUlnZmIBeyKJoHK44wckbR+B
        BIsc9INFZ0Fbot5L0bOxT04=
X-Google-Smtp-Source: ABdhPJyCaYQMrC4jUgnsT3g0zODNYmLSd6K4OdsBQvUhjrXO6PYbJ7eJ4mN/Bzlz+Ugms427Wxr0EQ==
X-Received: by 2002:a17:906:c1d0:: with SMTP id bw16mr31062856ejb.146.1632164338426;
        Mon, 20 Sep 2021 11:58:58 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id w13sm7894882ede.24.2021.09.20.11.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 11:58:57 -0700 (PDT)
Date:   Mon, 20 Sep 2021 21:58:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: Race between "Generic PHY" and "bcm53xx" drivers after
 -EPROBE_DEFER
Message-ID: <20210920185856.4mffcj7rifslxyil@skbuf>
References: <3639116e-9292-03ca-b9d9-d741118a4541@gmail.com>
 <4648f65c-4d38-dbe9-a902-783e6dfb9cbd@gmail.com>
 <20210920170348.o7u66gpwnh7bczu2@skbuf>
 <11994990-11f2-8701-f0a4-25cb35393595@gmail.com>
 <20210920174022.uc42krhj2on3afud@skbuf>
 <25e4d46a-5aaf-1d69-162c-2746559b4487@gmail.com>
 <20210920180240.tyi6v3e647rx7dkm@skbuf>
 <e010a9da-417d-e4b2-0f2f-b35f92b0812f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e010a9da-417d-e4b2-0f2f-b35f92b0812f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:10:39AM -0700, Florian Fainelli wrote:
> > But even so, what's a "pseudo PHY" exactly? I think that's at the bottom
> > of this issue. In the Linux device model, a device has a single driver.
> > In this case, the same MDIO device either has a switch driver, if you
> > accept it's a switch, or a PHY driver, if you accept it's a PHY.
> > I said it's "broken" because the expectation seems to be that it's a switch,
> > but it looks like it's treated otherwise. Simply put, the same device
> > can't be both a switch and a PHY.
> 
> A pseudo-PHY is a device that can snoop and respond to MDIO bus
> requests. I understand it cannot be both, just explaining to you how the
> people at Broadcom have been seeing the world from their perspective.
> Anything that is found at MDIO address 0x1e/30 is considered a MDIO
> attached switch, that's all.

Nothing wrong with that per se, at NXP we've been thinking about RevMII
as well, and having a switch expose itself as a PHY over MDIO, in any
case something a bit richer/more interactive than a fixed-link.

One way to bypass that limitation is to access the switch registers
through a different device compared to the PHY device. At the very
least, a different MDIO address. Even better, not over MDIO at all, but
something faster, SPI, PCIe etc.
