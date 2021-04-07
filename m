Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9527C357564
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355869AbhDGUFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348996AbhDGUFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 16:05:08 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD390C06175F;
        Wed,  7 Apr 2021 13:04:57 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4FFwNR0zGjzQjmW;
        Wed,  7 Apr 2021 22:04:55 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1617825893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x/SavWgMTIlT38FW/ptNNTaKRDlmmxJUPCoUw3uGMZA=;
        b=0zO1e2w6vtsV3izioESoLXsQOa62Z2Fh01yHrwfgn+7MvPC3lqPiXzCXhAPK8398zFBgoh
        8wnBv9AVZAGfNIpsH2hC2yVnIjKM2QZwAQU9MaPf9jk+ds2Uqi6fkEzR91rRc5RtW2uQih
        R/gjPBHkoMqfqzwlj2wVCCZt9mCH2J/jzN36fGh5cYlfWn6OxwyM2bnOAlieUQXYyABJGd
        JHNywPFxInZIaNz8dN7T2tCvZr4lPDfky30zRYEp7ol8IxUw5aQZSXmEZjN2BlHeE9FZZS
        EO3zmJwFpJJJRJBtycFxyh3KTiLyaj5rFzPMiQQrDDgKxqCYKBLFbJPQgaszxQ==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id Gj-CFps7egyi; Wed,  7 Apr 2021 22:04:51 +0200 (CEST)
Subject: Re: [PATCH RFC net 2/2] net: dsa: lantiq_gswip: Configure all
 remaining GSWIP_MII_CFG bits
To:     Andrew Lunn <andrew@lunn.ch>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
 <20210406203508.476122-3-martin.blumenstingl@googlemail.com>
 <YGz9hMcgZ1sUkgLO@lunn.ch>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <94c2777d-5111-2568-f64b-f68480766c5d@hauke-m.de>
Date:   Wed, 7 Apr 2021 22:04:49 +0200
MIME-Version: 1.0
In-Reply-To: <YGz9hMcgZ1sUkgLO@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.33 / 15.00 / 15.00
X-Rspamd-Queue-Id: BD48716F2
X-Rspamd-UID: da13e3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/21 2:32 AM, Andrew Lunn wrote:
>>   	case PHY_INTERFACE_MODE_RGMII:
>>   	case PHY_INTERFACE_MODE_RGMII_ID:
>>   	case PHY_INTERFACE_MODE_RGMII_RXID:
>>   	case PHY_INTERFACE_MODE_RGMII_TXID:
>>   		miicfg |= GSWIP_MII_CFG_MODE_RGMII;
>> +
>> +		if (phylink_autoneg_inband(mode))
>> +			miicfg |= GSWIP_MII_CFG_RGMII_IBS;
> 
> Is there any other MAC driver doing this? Are there any boards
> actually enabling it? Since it is so odd, if there is nothing using
> it, i would be tempted to leave this out.

We saw this option in the switch documentation and activated it to 
prepare for such systems, but I do not have any board which uses this 
and I am also not aware that this is used anywhere.

Hauke
