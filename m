Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C993EBFC6
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 04:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbhHNCcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 22:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236545AbhHNCcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 22:32:10 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97B6C061756
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 19:31:41 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id w2-20020a3794020000b02903b54f40b442so8867992qkd.0
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 19:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VScF7YU24u6/3/ImRpw40sHg3zOa5uLkS4vlieP2+vw=;
        b=BQFS55IcoBMVhmhaW3LlsF6XbAI8wIJ/hKqJevMy4quj58zUUZQDpVIM767gWm0pZ8
         WnWgO41gNIdMllgEtaLBBbH/Fvp+JqEv4TBA0lSiPWb7fZnMDKynorQ63A99vXxXd0lQ
         wXZ+KB8vl9qc1WZQEskoQvWrbWHAd1AXU2l0zaCFcPhn0X/Op7IKecbw/XiXXrg1/+zZ
         h6SxdZ6ej8gmeIK1WhUaxxOtFQdWUp7D2o4GxTc+nVSzA1La02bAbeFZ/PCBjvJhkRUx
         NFNBCBeQZKXX+p89gZ3+PcUjI8eJxkF7WSD3uLr0ROq6bYM2NPc+qKniAFxY+Yq1DG8f
         IUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VScF7YU24u6/3/ImRpw40sHg3zOa5uLkS4vlieP2+vw=;
        b=dH08NuOBk1a+Q36NdpcITZ34Nesxy/0q+ozHnJN3JrIiURly0O3Kk1QeOtIYzORKed
         pS8YmREAE+g1lEB+Fzd08Aw4pTC/OvyfPmBG4exM0QsKi3tcCB2bjwRFT7qUICElFaL6
         4iBnO6tLq6fkJruB2YLfFtCe9kJYDDW2z5rekTXDa9MvgG90IbacRCrGmWLE0y3gxp2w
         KN1MqapH5W9AlSMqPhv4p+FpgtDxKoOmId0x1HNvqxgU0ZLwfHnUADYODy8HMkWBfbkZ
         6OmHX7Q5kBvQLXXnhTNZsCG8SHamkAPFQHZRbhwu83z6qx6QjqOgPvcDeB4E/BmI6NoD
         OJ/Q==
X-Gm-Message-State: AOAM531mVxrlFzFhQM5skt636uRvSvXGt0MSOcit1LrW/twou+uk5eLL
        gMMZkTbj0bYpPjEX1gPT3WVIAb0tsdQ9aus=
X-Google-Smtp-Source: ABdhPJzOErHhEkhCh9EJI4GT7EBhMAEaMyu97hAOx70DUHnw2UgHafwWHHIKdPvynjFR28LWZZv3wBqG7j9w8Kk=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:55f9:6fdc:d435:ad28])
 (user=saravanak job=sendgmr) by 2002:a05:6214:1e1:: with SMTP id
 c1mr5744296qvu.42.1628908301138; Fri, 13 Aug 2021 19:31:41 -0700 (PDT)
Date:   Fri, 13 Aug 2021 19:31:31 -0700
In-Reply-To: <20210814023132.2729731-1-saravanak@google.com>
Message-Id: <20210814023132.2729731-3-saravanak@google.com>
Mime-Version: 1.0
References: <20210814023132.2729731-1-saravanak@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v1 2/2] of: property: fw_devlink: Add support for "phy-handle" property
From:   Saravana Kannan <saravanak@google.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     Saravana Kannan <saravanak@google.com>, kernel-team@android.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allows tracking dependencies between consumers of an Ethernet PHY and
the parent devices that own the PHY.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org
Signed-off-by: Saravana Kannan <saravanak@google.com>
---

Hi Andrew,

I spent a few hours looking at most/all uses of phy-handle and my
comment in the code seems valid. Can you confirm that please? Also there
are so many phy related properties that my head is spinning. Is there a
"phy" property (which is different from "phys") that treated exactly as
"phy-handle"?

-Saravana

 drivers/of/property.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 931340329414..70d9843fd4bf 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1350,6 +1350,20 @@ static struct device_node *parse_interrupts(struct device_node *np,
 	return of_irq_parse_one(np, index, &sup_args) ? NULL : sup_args.np;
 }
 
+static struct device_node *parse_phy_handle(struct device_node *np,
+					    const char *prop_name, int index)
+{
+	if (strcmp(prop_name, "phy-handle"))
+		return NULL;
+
+	/*
+	 * Device tree nodes pointed to by phy-handle never have struct devices
+	 * created for them even if they have a "compatible" property. So
+	 * return the parent node pointer.
+	 */
+	return of_get_next_parent(of_parse_phandle(np, prop_name, index));
+}
+
 static const struct supplier_bindings of_supplier_bindings[] = {
 	{ .parse_prop = parse_clocks, },
 	{ .parse_prop = parse_interconnects, },
@@ -1379,6 +1393,7 @@ static const struct supplier_bindings of_supplier_bindings[] = {
 	{ .parse_prop = parse_resets, },
 	{ .parse_prop = parse_leds, },
 	{ .parse_prop = parse_backlight, },
+	{ .parse_prop = parse_phy_handle, },
 	{ .parse_prop = parse_gpio_compat, },
 	{ .parse_prop = parse_interrupts, },
 	{ .parse_prop = parse_regulators, },
-- 
2.33.0.rc1.237.g0d66db33f3-goog

