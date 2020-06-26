Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEEB20B59F
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgFZQGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgFZQGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 12:06:31 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDEEC03E979;
        Fri, 26 Jun 2020 09:06:31 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q5so10007246wru.6;
        Fri, 26 Jun 2020 09:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WH5+dX1OUYMG5MfmWXgbhnz+c2DUXoRRb3W1X97OIVA=;
        b=DD5VeIcQIPBv7FMek3jmrC0DreNqtzJ8aADO7nZXveOL3C9lDL92WzIaRD8dnjn/4i
         y/GDvHIXjuZ4IsZU3tBckuoxeXlm7z9zPccbHU6CLNomr2nbv6MZEBDO4SaS8m0r0M7A
         PGtk4VLQB7nSQEYWQJgsS99DR/m5gOzhczylBXSl7QbqJ/WmXoPSjfqs4U/ZD5PN9XnG
         HZdnwo97mMOuxCdgkzTuOMV4BYnqE1bz3pkiK74HmjdvqnIFOzJ7PbdqgT+0RektoWCw
         Td80jt+/lbGUBYUOP5M1TwIznqg1iP1F5weKRndcePcP1IwK1esomGEWd0NT8EtrB5oJ
         93vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WH5+dX1OUYMG5MfmWXgbhnz+c2DUXoRRb3W1X97OIVA=;
        b=gXsqtzXRQuukvs12883qfWXXNDVE91rOI55Bi92D81HghAOna0aqzCWDd35f/zSae1
         RaJC6GBVYmpkL9L1/c+5x3cUcgfa2GIKav4InIYmlPxulFgS1nBdMX4+H0tgnz9ConEP
         n9ptO9OJbsMZGTTd358pPpQrlXwqgtid3Kk0rm5orpjjFdEk1fCmaTY5v+ILNSDJeM7L
         P0PVaSe9Sy2sORryVy8CKeJ3Tgfv7SzIvvgZzNMRwp3viae6rlp79xrsgt2wGFLqLjuQ
         4IVZL/8feP4Vv0cGDK4wbEkdKNJzutyatA1xckLdxmSMxrEFWTubrPf24ubteAd4jSxG
         CckQ==
X-Gm-Message-State: AOAM531mtKP2dUGzOH/OPgnwc6EKi2MCsSrPXAe6jUatKAqY2eEnJTXl
        UmooQuWzIEZUV5FMINaWqgI=
X-Google-Smtp-Source: ABdhPJwk2MJc9XFSCKBIPtk73r5Lq0FZ0WB2bHeQPb71Z515HiLDFpJysI5FwJ2CUFDrnkpPlV0CYg==
X-Received: by 2002:adf:db4d:: with SMTP id f13mr4457200wrj.336.1593187589786;
        Fri, 26 Jun 2020 09:06:29 -0700 (PDT)
Received: from [10.230.189.192] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s10sm6945892wme.31.2020.06.26.09.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 09:06:29 -0700 (PDT)
Subject: Re: [PATCH 5/6] net: phy: reset the PHY even if probe() is not
 implemented
To:     Bartosz Golaszewski <brgl@bgdev.pl>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20200626155325.7021-1-brgl@bgdev.pl>
 <20200626155325.7021-6-brgl@bgdev.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <edd6806e-555e-3713-514d-6d21198cc609@gmail.com>
Date:   Fri, 26 Jun 2020 09:06:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200626155325.7021-6-brgl@bgdev.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/26/2020 8:53 AM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> Currently we only call phy_device_reset() if the PHY driver implements
> the probe() callback. This is not mandatory and many drivers (e.g.
> realtek) don't need probe() for most devices but still can have reset
> GPIOs defined. There's no reason to depend on the presence of probe()
> here so pull the reset code out of the if clause.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

OK we can always add support for letting PHY drivers manage their own
reset line(s) during probe in a later changeset.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
