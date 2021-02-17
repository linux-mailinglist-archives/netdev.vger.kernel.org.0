Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F63431D4B0
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 05:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhBQEpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 23:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhBQEpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 23:45:38 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362A4C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 20:44:58 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id ba1so6791832plb.1
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 20:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=date:message-id:in-reply-to:references:from:to:cc:subject
         :content-transfer-encoding:mime-version;
        bh=ISday/KsYY0xQs3tCg315TlJ6VVCMdondXb9+vl+bcE=;
        b=S3x4RqcBAQAaC57b+huv43oWkyGkBo15h+TPRf6lRT16y/SGtxiEZ2LRSSm68CiDxG
         D/auyBTtXOHtvQTsVUITXACv+3hPDetYwXcWKE6ia3S/Dml+ZX0pe7kPik+1izNWUthm
         cgJruFpmK1+S8ODWtECzRCyjJHrITYUaD9mQPUGRbHGWM0QOSj2xoGkKOrQTiYOzl+km
         HB8DDTkwUQqwimR5bQV8zuoDG6VCwuWfonH4kIz3HntHFhfVm/w/Qog0CfU58rTronV8
         yyXB7BlQoao0fiQjRwzJ2BFx7HeGhEFk9jFwBaxt4D2XuxKMYr+FZdour/TrxCEHXzuK
         06rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:in-reply-to:references:from:to
         :cc:subject:content-transfer-encoding:mime-version;
        bh=ISday/KsYY0xQs3tCg315TlJ6VVCMdondXb9+vl+bcE=;
        b=EEKdtASQKNr8FjcinQ1BjAWco/2h4wQCX5aGFa2TXWnuMJipxdEktgto3rr/RL6WX/
         xiwXG+5fSBwqvICfJrWWWoTZLZUedEfjvzgbdWfCbtA4zdliG8cJY9bEvw2tagw7OQxh
         O9FsoQ750R7SV4vc9wfk7tgm2ZMI4eKJEA25qGzwr+CIbrUNH8Sp/nwtNETZT4zeoWWf
         BFP2eAAtUI+IbkXjJYTMUd6k8/kkWA3y3UIclS06h4XQ36Isyi1QXczZb3fn8FY0jHkj
         8VGvqirX/cKFHOMQvuyg8nKOL/MxxFJn0f5KwRpM/M3GyjnmzWk8RV2orQPmVYy1ePpE
         fXsw==
X-Gm-Message-State: AOAM5332Hx3Oxg1+ZAaHFWZQqKm5XEqDWFjdIfHSjbtqe+CJnA4Di2fk
        2l1M5iBHURETo0FlUM3QkfQjGIbTMeJplCSLP4M=
X-Google-Smtp-Source: ABdhPJyChhN+s8GI98DhLVL/9m7QKdnjEiOK1Rjt7OK7OWw+YWRM+zog+vgaNnH8tOnCTzn5WecgnQ==
X-Received: by 2002:a17:90a:1a16:: with SMTP id 22mr7745724pjk.34.1613537096570;
        Tue, 16 Feb 2021 20:44:56 -0800 (PST)
Received: from [127.0.1.1] (117-20-70-209.751446.bne.nbn.aussiebb.net. [117.20.70.209])
        by smtp.gmail.com with UTF8SMTPSA id i7sm532711pjs.1.2021.02.16.20.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 20:44:56 -0800 (PST)
Date:   Wed, 17 Feb 2021 04:44:43 +0000
Message-Id: <20210217044443.1246392-1-nathan@nathanrossi.com>
In-Reply-To: <20210215070218.1188903-1-nathan@nathanrossi.com>
References: <20210215070218.1188903-1-nathan@nathanrossi.com>
From:   Nathan Rossi <nathan@nathanrossi.com>
To:     netdev@vger.kernel.org
Cc:     Nathan Rossi <nathan@nathanrossi.com>,
        Nathan Rossi <nathan.rossi@digi.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2] of: of_mdio: Handle broken-turn-around for non-phy mdio devices
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Rossi <nathan.rossi@digi.com>

The documentation for MDIO bindings describes the "broken-turn-around",
property such that any MDIO device can define it. Other MDIO devices may
require this property in order to correctly function on the MDIO bus.

Enable the parsing and configuration associated with this property for
non-phy MDIO devices.

Signed-off-by: Nathan Rossi <nathan.rossi@digi.com>
---
Changes in v2:
- Only handle broken-turn-around for non-phy devices
- No need for of_mdiobus_child_parse function
---
 drivers/net/mdio/of_mdio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 4daf94bb56..9796f259a8 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -158,6 +158,9 @@ static int of_mdiobus_register_device(struct mii_bus *mdio,
 	if (IS_ERR(mdiodev))
 		return PTR_ERR(mdiodev);
 
+	if (of_property_read_bool(child, "broken-turn-around"))
+		mdio->phy_ignore_ta_mask |= 1 << addr;
+
 	/* Associate the OF node with the device structure so it
 	 * can be looked up later.
 	 */
---
2.30.0
