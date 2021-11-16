Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2409F453CE6
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 00:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbhKPXym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 18:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhKPXym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 18:54:42 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B36C061570;
        Tue, 16 Nov 2021 15:51:44 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id x5so953425pfr.0;
        Tue, 16 Nov 2021 15:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/a8VkPOBp+sRhshdlMGv/oDCg20jVzLPWjV5XIU6qh0=;
        b=KfK1z35s2reqrgZuw9I2YR5DGVMmAJQjacu4q2s730DsD+K+mkk3bTKBWODTSTsh9S
         KKImSmEE/fEPslTeVzPzTXAv3NWJXT332fPqtzCuJMneWCHd8EFMZqoxZEBF58rMPXr1
         PG8g/Q1bKI4pW1sR/6jpu+w/db4iczyD73JNMlhmOpIMzAys/d66GJ86FXyMZToBf8VC
         SiGeo/TkYQkcPMq62RE4Bt99H2FoPBh0Un8/bSnmTJKddPIB3RLpfN/B7N4ri590zz7K
         ur8z6nYqLe+vbTo1lZNk/b+QkXLvRxadzwmHcUsVAbi7ztXeDL8n+nq0TIqy8Y0e5Dgj
         vkuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/a8VkPOBp+sRhshdlMGv/oDCg20jVzLPWjV5XIU6qh0=;
        b=SJ+wQomNFNEhzTQri6kENcJg81ebSiQA3jNSJgHydf2eyRgBs6FfOLu5k96ZRLxP8Z
         tynclnHn7NMXTRxCdJ2wOAQNRfp52hbJA7LwXXLxZk8vRY7WtQjGUCM6pJOfNnAqhaQ8
         evzy2okDQ0AzLb8eeqbBKhLz6sfsHeG04jj35K/5m+vejeRGIdMsvDYOfgX7FZdb2qnX
         1ieTv+gvK550sMDRY+a7AQb22Fy46eo6180npw8BxY+lw6NhnD6RK6Ay8OSUYxSz/exn
         etQnIyxfvGf7TZhLwUXJPQjZwYx1ZzfhjvVNl0IsFd/MxQk1z+1088AYNAH7aX+lsCTe
         Onmw==
X-Gm-Message-State: AOAM533nPPvRDmtUm9jNjmTkq6wIeVzu61Ib1Yyu0WLVyzgSiYi9ekUJ
        yOK3IpGwVhOauCVH3ZaMT1YCADLRlms=
X-Google-Smtp-Source: ABdhPJyHo9ax2VndO116SXAPqjSqES9eXZgyrgnatGJhOXhl1DOJeWTaVdhxGABayePJ4jBp09H6mw==
X-Received: by 2002:a63:f95b:: with SMTP id q27mr2238531pgk.202.1637106704042;
        Tue, 16 Nov 2021 15:51:44 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g5sm3299599pjt.15.2021.11.16.15.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 15:51:43 -0800 (PST)
Subject: Re: [RFC PATCH v4 net-next 03/23] net: dsa: ocelot: seville: utilize
 of_mdiobus_register
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
 <20211116062328.1949151-4-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8dca509f-5dff-bc19-c702-ed03e52a8f86@gmail.com>
Date:   Tue, 16 Nov 2021 15:51:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211116062328.1949151-4-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/21 10:23 PM, Colin Foster wrote:
> Switch seville to use of_mdiobus_register(bus, NULL) instead of just
> mdiobus_register. This code is about to be pulled into a separate module
> that can optionally define ports by the device_node.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
