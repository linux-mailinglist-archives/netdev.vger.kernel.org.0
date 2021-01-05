Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FA52EB5F9
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbhAEXM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbhAEXM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 18:12:59 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99282C061574
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 15:11:25 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id 6so2730751ejz.5
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 15:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q7ywXkeJS9+NSy3KiTd8kIayGWN/LQ+tGHbFpLFfxzU=;
        b=kEzp/VUV/UHQyqHyVDMO2LLiaHd4Fx4biAGXpy7QgNDermjAOw5nfsT8kvUqMFXxM9
         XBqTRW5jIGqUOv4u3kgfqOexN5fNmJz6E4LmlVSVBVYMB5nT9TZ09JdoXQyO6foGGlXA
         NcKAnEFdesaaHFOWthPO9qoDS6Shy+h/l7SM5KVm/Qy3OVc87klPbvMJN19jLVJpgRyQ
         wuVlNJU+HVL0rJR2wsY+22gHj/y7vOiNRPHQQfMquJAWZRK0pBHlIZyJU0sqoKBpoc23
         hUjr3M5hOSXzueH+7qYohkg8N201qGyJ6uFSEosmb5Co1VAgA3ib5jbhZ8BgRW5jh8Cw
         UXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q7ywXkeJS9+NSy3KiTd8kIayGWN/LQ+tGHbFpLFfxzU=;
        b=FQ0eBBlKqQcaW+i+RyaXxVgSxRBsJHSw568k7AO4pYoKXcKsLThfY8nM2pk4jndxTK
         G7L14SlFy6/aFesir1aJCH5O7Sfjy024NRMmGADn/q5Wqn5dymuCxKBz5vHLNliG8aHn
         fJ52AphByOepvjqv84XVtN6h9abGZmH2HaKLKkCOuEdctZsKZEfV83nGydLkhwElQBXu
         wC0YhMXzCuYpuHulbr6mQ7rW9KaVz53RvnRkgqZaZchj5FhR1jhWuT4dM0ZUKmf4Ya4H
         FzI7kweH2jNU6OJQn4C3/fAHm+E1anNFBRV5BVD2cf0+ZDavjB6bCUUPqCU7FIvQYgZ8
         3Bzw==
X-Gm-Message-State: AOAM530gX4ZZEnGPMrOzQKMriFSCk80XyNtw9ObyhNUiYerKpBTUG5ad
        +7o4Jk98G2L/uNwKgzuG5xA+FSCS96Y=
X-Google-Smtp-Source: ABdhPJx2EVis6LFCzLAwouKP1fSeuwvr7yRwjOWwOTqkvFkzMcXmPQa1sEO4nvyhLVIh84JTl5uCTA==
X-Received: by 2002:a17:906:2681:: with SMTP id t1mr1130678ejc.29.1609888284421;
        Tue, 05 Jan 2021 15:11:24 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:303d:91bf:ac5c:51a1? (p200300ea8f065500303d91bfac5c51a1.dip0.t-ipconnect.de. [2003:ea:8f06:5500:303d:91bf:ac5c:51a1])
        by smtp.googlemail.com with ESMTPSA id h12sm219026eja.113.2021.01.05.15.11.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 15:11:23 -0800 (PST)
Subject: Re: [PATCH] net: phy: Trigger link_change_notify on PHY_HALTED
To:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20210105161136.250631-1-marex@denx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <275fa9f2-cc87-0bb0-93c2-96027c9b86db@gmail.com>
Date:   Wed, 6 Jan 2021 00:11:15 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210105161136.250631-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.01.2021 17:11, Marek Vasut wrote:
> In case the PHY transitions to PHY_HALTED state in phy_stop(), the
> link_change_notify callback is not triggered. That's because the
> phydev->state = PHY_HALTED in phy_stop() is assigned first, and
> phy_state_machine() is called afterward. For phy_state_machine(),
> no state transition happens, because old_state = PHY_HALTED and
> phy_dev->state = PHY_HALTED.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/phy.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 45f75533c47c..fca8c3eebc5d 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -1004,6 +1004,7 @@ EXPORT_SYMBOL(phy_free_interrupt);
>  void phy_stop(struct phy_device *phydev)
>  {
>  	struct net_device *dev = phydev->attached_dev;
> +	enum phy_state old_state;
>  
>  	if (!phy_is_started(phydev) && phydev->state != PHY_DOWN) {
>  		WARN(1, "called from state %s\n",
> @@ -1021,8 +1022,17 @@ void phy_stop(struct phy_device *phydev)
>  	if (phydev->sfp_bus)
>  		sfp_upstream_stop(phydev->sfp_bus);
>  
> +	old_state = phydev->state;
>  	phydev->state = PHY_HALTED;
>  
> +	if (old_state != phydev->state) {
> +		phydev_err(phydev, "PHY state change %s -> %s\n",
> +			   phy_state_to_str(old_state),
> +			   phy_state_to_str(phydev->state));
> +		if (phydev->drv && phydev->drv->link_change_notify)
> +			phydev->drv->link_change_notify(phydev);
> +	}
> +
>  	mutex_unlock(&phydev->lock);
>  
>  	phy_state_machine(&phydev->state_queue.work);
> 

Following is RFC as an additional idea. When requesting a new state
from outside the state machine, we could simply provide the old
state to the state machine in a new phy_device member.
Then we shouldn't have to touch phy_stop(), and maybe phy_error().
And it looks cleaner to me than duplicating code from the state
machine to functions like phy_stop().

---
 drivers/net/phy/phy.c        | 10 +++++++++-
 drivers/net/phy/phy_device.c |  1 +
 include/linux/phy.h          |  3 +++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 45f75533c..347e42d90 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -45,6 +45,7 @@ static const char *phy_state_to_str(enum phy_state st)
 {
 	switch (st) {
 	PHY_STATE_STR(DOWN)
+	PHY_STATE_STR(INVALID)
 	PHY_STATE_STR(READY)
 	PHY_STATE_STR(UP)
 	PHY_STATE_STR(RUNNING)
@@ -1021,6 +1022,7 @@ void phy_stop(struct phy_device *phydev)
 	if (phydev->sfp_bus)
 		sfp_upstream_stop(phydev->sfp_bus);
 
+	phydev->old_state = phydev->state;
 	phydev->state = PHY_HALTED;
 
 	mutex_unlock(&phydev->lock);
@@ -1086,7 +1088,13 @@ void phy_state_machine(struct work_struct *work)
 
 	mutex_lock(&phydev->lock);
 
-	old_state = phydev->state;
+	/* set if a new state is requested from outside the state machine */
+	if (phydev->old_state != PHY_INVALID) {
+		old_state = phydev->old_state;
+		phydev->old_state = PHY_INVALID;
+	} else {
+		old_state = phydev->state;
+	}
 
 	switch (phydev->state) {
 	case PHY_DOWN:
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 80c2e646c..9f8d9f68b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -620,6 +620,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 	device_initialize(&mdiodev->dev);
 
 	dev->state = PHY_DOWN;
+	dev->old_state = PHY_INVALID;
 
 	mutex_init(&dev->lock);
 	INIT_DELAYED_WORK(&dev->state_queue, phy_state_machine);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9effb511a..df48ea88c 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -442,6 +442,7 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
  */
 enum phy_state {
 	PHY_DOWN = 0,
+	PHY_INVALID,
 	PHY_READY,
 	PHY_HALTED,
 	PHY_UP,
@@ -566,6 +567,8 @@ struct phy_device {
 	unsigned interrupts:1;
 
 	enum phy_state state;
+	/* if a new state is requested from outside the state machine */
+	enum phy_state old_state;
 
 	u32 dev_flags;
 
-- 
2.30.0

