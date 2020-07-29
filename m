Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F41231F20
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgG2NTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG2NTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 09:19:36 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31EDC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:19:36 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mt12so1855704pjb.4
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vJp/L91vzMdcd/JAQLyTbdHvawWZGsV5cve4D65nwnk=;
        b=jWm2xv4rN0YKWZ5wys8A8fDEBKkXZrBKg988viv8hpUJ8UyGVgzv7G1psBO52sU5nu
         Y+A7pYlD5ZtUQAKZM8shBICS8TvtGw/kHqJN/PUaD6sh5pWHUP0//Z4vHDHdda9EmAhL
         hPA4ZQv1a6OE7gypjGKVIoCHJsW/xSHawZYOB5wJet/cuRsqnM3biY8nfEr6rMaMoHef
         bim3+mOUGkg8rxBRSU0WRzY1HyFjqe7l210acXBiQp8tKmW3S1wvkixuAfjzb/B6zKoU
         axxa4C4VAJaECqA6Z/4lXe4UYWnVkdAEtObi52NuEcxAJ91UbQACRPFF6TJhdo1EBbEz
         HpAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vJp/L91vzMdcd/JAQLyTbdHvawWZGsV5cve4D65nwnk=;
        b=hlHrAZi/b0erTl6H1scdGeWLcKi++9RduauvjzasomhdKG9CoKj7LogXMffL124QjC
         KtD/AyetLcPu2zQVEk6FCXch6DVaWKPYtxUEh9bHnpSaLpHO9n8DE/cX4K4+Yg84OdDU
         yIYMiWeDykgYvc4UNR6wLK4RoTv+LSN6C0knTjZ9H0eW8JPPefNuvWYP7g2FEsqtKPHL
         tuqlMoRocgnjBGruB0PR+GHVPr9b9jfYWhVjyqq3QPVsPDRuM+bgyOa9eSZBQvfkkKvF
         A8pZOLYcM1a0QVlYf++dW6eCVZej8pcxbQlPzaGJCX5hVIAMZf8106JnlPhYjYTuitgD
         j+vQ==
X-Gm-Message-State: AOAM532t3Q4ae9KOpLWE2IbbcAKgBSdnP+ZpJPWgpf8DNTYRGI/xlWgo
        ASL1Z5s49rcF/sq2BZJBxF3AhlC1
X-Google-Smtp-Source: ABdhPJxEoegPChZIF3551KZEyCSWwUqW0chJswex+kM4ElAaAKoN0OJGvWQOtb/znhtTiJSrgKFaew==
X-Received: by 2002:a17:902:6b08:: with SMTP id o8mr22134880plk.6.1596028776033;
        Wed, 29 Jul 2020 06:19:36 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id s30sm2554314pgn.34.2020.07.29.06.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 06:19:35 -0700 (PDT)
Date:   Wed, 29 Jul 2020 06:19:32 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200729131932.GA23222@hoboy>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
 <20200729105807.GZ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729105807.GZ1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 11:58:07AM +0100, Russell King - ARM Linux admin wrote:
> How do we deal with this situation - from what I can see from the
> ethtool API, we have to make a choice about which to use.  How do we
> make that choice?

Unfortunately the stack does not implement simultaneous MAC + PHY time
stamping.  If your board has both, then you make the choice to use the
PHY by selecting NETWORK_PHY_TIMESTAMPING at kernel compile time.

(Also some MAC drivers do not defer to the PHY properly.  Sometimes
you can work around that by de-selecting the MAC's PTP function in the
Kconfig if possible, but otherwise you need to patch the MAC driver.)
 
> Do we need a property to indicate whether we wish to use the PHY
> or MAC PTP stamping, or something more elaborate?

To do this at run time would require quite some work, I expect.

Thanks,
Richard
