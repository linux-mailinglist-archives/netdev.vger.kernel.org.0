Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CFD14E830
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 06:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgAaFSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 00:18:09 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33325 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgAaFSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 00:18:09 -0500
Received: by mail-pg1-f194.google.com with SMTP id 6so2858321pgk.0;
        Thu, 30 Jan 2020 21:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ax5JKtShVF4pOcmfNzJ/FPZX/6Hzfw0ryxGY+YWf5AM=;
        b=erOAcbZrJeQmLWUBvi3Pk4hatMkbOkCzv7+mhJnRXmqbludk8VJXLX60vBP2WnXmta
         HFhvKK8KfvQu1bj2106MQDN/WozDfYlWt3xdVzZATWl1+isX9d+Lf6538Kf8/kz/g7+E
         nR3YpQ6Kem10r4R265BQTl8Ze9ebKQuDN7kWx6NhrfwtHMoLKas2XAEL7R6yAlM/d28X
         g5LIH4jM1ycowB/z8soXQYIzmp8cAyQyWiuZyWScBcX1pUbwKMR/KrsE2bBu6eBr1exl
         p4iIJ59bt1kAA11TjKwTrS8XCZTkC7PH94m4fMnmQ8JgA0KufPlbTQIV3QFPd0ranXCJ
         q16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ax5JKtShVF4pOcmfNzJ/FPZX/6Hzfw0ryxGY+YWf5AM=;
        b=Ljsenl5j2MF7ytTBTFQrWY3BO9u4RtMb457Y5JORMFQraNf78jOAip1E44QB2VWo7x
         BtJMP4UloysKA7Dugus+G2Ntgt4USIXUwzVRD8+DsG1xWNDpMLe43p1O7YOy9ySSZKdf
         Am+6uMTQZRDNLXj3GMuY54HPGbmwoB7XFhB66wZ5JbJbIZHrFjcqwgfo3NjFNMeunOop
         9D/2Icu2oCz5IvcZ5JJpxCgjJOY2L71/by7jRv8kg8bJ2uiDtcnLgR1CwHAiu1hxwCvh
         55+i7dq30ZjglN1c5Vf1e2CrqABlcniZspGgDWCFyLW+v2fOKlYzNLhyQXlgdrFmS/f1
         XNSQ==
X-Gm-Message-State: APjAAAVNMmuBhhg4XIfhZ2GP+TYJdqsh1+re9RsD1Yklq4CGjVsm6IAH
        zY1lLeHMRRQTyERFwuiFY2UCKwO2
X-Google-Smtp-Source: APXvYqxfo7Nt5JvGv2CaooTo3QysX5l94BTj8d0KqmWhYVFBkjz6PfUF5IDImRrAEk7AMS14arsmJg==
X-Received: by 2002:a62:ee11:: with SMTP id e17mr8969429pfi.48.1580447887224;
        Thu, 30 Jan 2020 21:18:07 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id h7sm8861596pfq.36.2020.01.30.21.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 21:18:06 -0800 (PST)
Date:   Thu, 30 Jan 2020 21:18:04 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 2/2] net: mii_timestamper: fix static allocation
 by PHY driver
Message-ID: <20200131051804.GB1398@localhost>
References: <20200130174451.17951-1-michael@walle.cc>
 <20200130174451.17951-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130174451.17951-2-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 06:44:51PM +0100, Michael Walle wrote:
> If phydev->mii_ts is set by the PHY driver, it will always be
> overwritten in of_mdiobus_register_phy(). Fix it. Also make sure, that
> the unregister() doesn't do anything if the mii_timestamper was provided by
> the PHY driver.
> 
> Fixes: 1dca22b18421 ("net: mdio: of: Register discovered MII time stampers.")
> Signed-off-by: Michael Walle <michael@walle.cc>

Thanks for the fix.

Acked-by: Richard Cochran <richardcochran@gmail.com>
