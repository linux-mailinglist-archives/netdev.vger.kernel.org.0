Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB3F170A49
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 22:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbgBZVRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 16:17:07 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46762 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727446AbgBZVRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 16:17:06 -0500
Received: by mail-wr1-f66.google.com with SMTP id j7so529913wrp.13;
        Wed, 26 Feb 2020 13:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eGG5HV/wHjXmjW594DYnRXUEMq+KVnRCi2GVnSHct24=;
        b=GWMdC2CT7TecL5TAmiCGBNOag5B0X++Z1IY0dQWJIayMcUrrFTULSVfUlbT0TY1wA+
         TGqh7IexTm/eF1H0hR9Lj3XFtTUWPA74MBjrXxPhFbD5JlulljnQEXzJ88AOlVT7zv20
         R87ybBJn2VbvR4UFwp+OYTMj9wq7We6KOMUUXig0DqMGbtaAfvhe+UqbS8ftV8tRKo+n
         ZoYHLEL5+N1p1ZRCKfLr7ixiDi4sCQBvDq09jej2U2cK946ViEn+3hYOPVi7+M0kDzYL
         GWWs9IsvCcplqUrgG/mNaN+41I3tZN9yEYl7Gvrd32aW/hndLnr9mRdw0FLMH7pCjZTF
         ZC6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eGG5HV/wHjXmjW594DYnRXUEMq+KVnRCi2GVnSHct24=;
        b=CwTv1e/t7xlBB4XLpKCXpar3d3ZceP24wsIK9GBZ6VR8rhMUsPek/6rW0WZNW6cc7r
         ZrR67UjHzPP04mn5DaTZ7AR18G3BblasGuiSz/32NGAHwQvlAXmFYXGZpN2eVG4KxCRy
         Um/nkaKHTagG4Lk6CIFmVRtg/crJ/mby5c45A3TbrH8RBNRMidF2aSt+ux2YiME1/pgk
         SYMkjXVrEMdyaajbONwcIJdoJf2qyXOzfBSfE+INkjxArCfWh5cQ7AwjpzYWB89UicRP
         Vo/UXQ3jwQiKCcNUcj6q6B4NoCwkAM2u02X3TcvuwbT2c+tZFK/LGMkm7AX4yLSyVOp1
         wGCg==
X-Gm-Message-State: APjAAAVfF6G3UCASc15CO9Zp4+wmvVqxeGCa7+t0qm+Bx07xwUscKqsC
        i89WMTmyaUKvorIpMGn8YkU=
X-Google-Smtp-Source: APXvYqytANCFtOd8eL6ThzI4nOTk57R3SjvMxRHm6IAzwk+nJfSmbZzar4bJOjJ2Ks/IF5tG/MDhEA==
X-Received: by 2002:a05:6000:1206:: with SMTP id e6mr613672wrx.410.1582751824917;
        Wed, 26 Feb 2020 13:17:04 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:38ea:e5eb:bce2:2ee3? (p200300EA8F29600038EAE5EBBCE22EE3.dip0.t-ipconnect.de. [2003:ea:8f29:6000:38ea:e5eb:bce2:2ee3])
        by smtp.googlemail.com with ESMTPSA id s139sm4674219wme.35.2020.02.26.13.17.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 13:17:04 -0800 (PST)
Subject: Re: [RFC PATCH 1/2] net: phy: let the driver register its own IRQ
 handler
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
References: <20200225230819.7325-1-michael@walle.cc>
 <20200225230819.7325-2-michael@walle.cc>
 <3c7e1064-845e-d193-24ad-965211bf1e9a@gmail.com>
 <18f531a691d0c4905552794bbb1be1e5@walle.cc>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <60985489-a6e9-dc13-68af-765d98116eb8@gmail.com>
Date:   Wed, 26 Feb 2020 22:17:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <18f531a691d0c4905552794bbb1be1e5@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.02.2020 12:12, Michael Walle wrote:
> Am 2020-02-26 08:27, schrieb Heiner Kallweit:
>> On 26.02.2020 00:08, Michael Walle wrote:
>>> There are more and more PHY drivers which has more than just the PHY
>>> link change interrupts. For example, temperature thresholds or PTP
>>> interrupts.
>>>
>>> At the moment it is not possible to correctly handle interrupts for PHYs
>>> which has a clear-on-read interrupt status register. It is also likely
>>> that the current approach of the phylib isn't working for all PHYs out
>>> there.
>>>
>>> Therefore, this patch let the PHY driver register its own interrupt
>>> handler. To notify the phylib about a link change, the interrupt handler
>>> has to call the new function phy_drv_interrupt().
>>>
>>
>> We have phy_driver callback handle_interrupt for custom interrupt
>> handlers. Any specific reason why you can't use it for your purposes?
> 
> Yes, as mentioned above this wont work for PHYs which has a clear-on-read
> status register, because you may loose interrupts between handle_interrupt()
> and phy_clear_interrupt().
> 
> See also
>  
> https://lore.kernel.org/netdev/bd47f8e1ebc04fa98856ed8d89b91419@walle.cc/
> 
> And esp. Russell reply. I tried using handle_interrupt() but it won't work
> unless you make the ack_interrupt a NOOP. but even then it won't work because
> the ack_interrupt is also used during setup etc.
> 
Right, now I remember .. So far we have only one user of the handle_interrupt
callback. Following a proposal from the quoted discussion, can you base your
patch on the following and check?
Note: Even though you implement handle_interrupt, you still have to implement
ack_interrupt too.


---
 drivers/net/phy/mscc.c | 3 ++-
 drivers/net/phy/phy.c  | 4 ++--
 include/linux/phy.h    | 4 +++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
index 937ac7da2..20b9d3ef5 100644
--- a/drivers/net/phy/mscc.c
+++ b/drivers/net/phy/mscc.c
@@ -2868,7 +2868,8 @@ static int vsc8584_handle_interrupt(struct phy_device *phydev)
 #endif
 
 	phy_mac_interrupt(phydev);
-	return 0;
+
+	return vsc85xx_ack_interrupt(phydev);
 }
 
 static int vsc85xx_config_init(struct phy_device *phydev)
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d76e038cf..de52f0e82 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -725,10 +725,10 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 	} else {
 		/* reschedule state queue work to run as soon as possible */
 		phy_trigger_machine(phydev);
+		if (phy_clear_interrupt(phydev))
+			goto phy_err;
 	}
 
-	if (phy_clear_interrupt(phydev))
-		goto phy_err;
 	return IRQ_HANDLED;
 
 phy_err:
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 80f8b2158..9e2895ee4 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -560,7 +560,9 @@ struct phy_driver {
 	 */
 	int (*did_interrupt)(struct phy_device *phydev);
 
-	/* Override default interrupt handling */
+	/* Override default interrupt handling. Handler has to ensure
+	 * that interrupt is ack'ed.
+	 */
 	int (*handle_interrupt)(struct phy_device *phydev);
 
 	/* Clears up any memory if needed */
-- 
2.25.1


