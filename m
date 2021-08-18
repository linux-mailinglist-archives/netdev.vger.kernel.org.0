Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096C23EF8C3
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 05:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237225AbhHRDit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 23:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236340AbhHRDip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 23:38:45 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5CBC061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 20:38:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n200-20020a25d6d10000b02905935ac4154aso1393005ybg.23
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 20:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=o87xEd9sY9pIPozIc37cNvJ7ApVn8/3VsQUX/onei7E=;
        b=ZPWfrtrQ1ArNoGHnZYyrunVyDFSOmrx7F/RcM34Z9tzTRmQDliYr8esIE+c2kFWR0V
         Rjg38Wrz3aeNp9jzwycmZ6ZE9CDtPOtGu492lN0b7wjE2wKsipfjg1YN+zApnf8U/WgJ
         66CXCBTKsI7SxSo6vmav2A8HpwyLsa/2Th5n5MIoywp1MGN7db5wPBpa+1AUp6Ah7uLx
         hnRMnzwiTKd5+K5HK/RtJXbFw2AqKzNnGe2UdDmmOjkhVfMnVx3hw0ygTOqKgSwc99yH
         ec3J8gb1Wsk66xA0EfZAVpmydGTmZRquniddfzPZCSefDZtcYZKYbqFDhUUTDUPeW9MP
         DWEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=o87xEd9sY9pIPozIc37cNvJ7ApVn8/3VsQUX/onei7E=;
        b=gWo7876UVe7/dBuIy69YhBSg45vqJtcnUtyAZMzgCyX9XAWbnAtHphxvvfRLkaYk8i
         tkLFVhAAAFt7b36hQM9ohEvztptgtYXzNacWNN65qI4M7d8ulfhiHhZN59XGq+sD2kO5
         MhDUg7ehvZbq7nDrqI414wGp8RDbKck9dQLgbY7gh7pNKLTg5Ep6HNUwhuTz2bNFoOrH
         hLgXrs3NU3Umgt9/RC6Ersokym+9WfqUKnCXSaiukQUyQvG65LtzbqsTI6VJXG7EgA0A
         ksT+4W/b16p18ODxZDAZuRGIhFxN6/yqniw8Qcq/pXHPRCDD4FSn+Vc0avoB40eavENA
         9zYQ==
X-Gm-Message-State: AOAM530zHMtnSsWtBO+vxTnDYXVShYA0yExL/6OUXt2RoXDhFtljp5da
        LneRKi7ospEymarJp7aNhE5K/Oi81XXlghE=
X-Google-Smtp-Source: ABdhPJyFRjKCrpEwy57C4bCO3wayF8LnP7wKl9qfoZNRztX7IjuUVmmLAmhnaStB00/Gxey2kg2vZHK/+5we3yA=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:7750:a56d:5272:72cb])
 (user=saravanak job=sendgmr) by 2002:a25:a565:: with SMTP id
 h92mr8544445ybi.423.1629257890499; Tue, 17 Aug 2021 20:38:10 -0700 (PDT)
Date:   Tue, 17 Aug 2021 20:38:01 -0700
In-Reply-To: <20210818033804.3281057-1-saravanak@google.com>
Message-Id: <20210818033804.3281057-2-saravanak@google.com>
Mime-Version: 1.0
References: <20210818033804.3281057-1-saravanak@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH net v3 1/3] net: mdio-mux: Delete unnecessary devm_kfree
From:   Saravana Kannan <saravanak@google.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jon Mason <jon.mason@broadcom.com>,
        David Daney <david.daney@cavium.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>, kernel-team@android.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The whole point of devm_* APIs is that you don't have to undo them if you
are returning an error that's going to get propagated out of a probe()
function. So delete unnecessary devm_kfree() call in the error return path.

Fixes: b60161668199 ("mdio: mux: Correct mdio_mux_init error path issues")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Marc Zyngier <maz@kernel.org>
Tested-by: Marc Zyngier <maz@kernel.org>
Acked-by: Kevin Hilman <khilman@baylibre.com>
Tested-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/net/mdio/mdio-mux.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-mux.c b/drivers/net/mdio/mdio-mux.c
index 110e4ee85785..5b37284f54d6 100644
--- a/drivers/net/mdio/mdio-mux.c
+++ b/drivers/net/mdio/mdio-mux.c
@@ -181,7 +181,6 @@ int mdio_mux_init(struct device *dev,
 	}
 
 	dev_err(dev, "Error: No acceptable child buses found\n");
-	devm_kfree(dev, pb);
 err_pb_kz:
 	put_device(&parent_bus->dev);
 err_parent_bus:
-- 
2.33.0.rc1.237.g0d66db33f3-goog

