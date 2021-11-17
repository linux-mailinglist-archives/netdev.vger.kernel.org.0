Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9931E454EEB
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240239AbhKQVIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240349AbhKQVIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:17 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A0CC061570;
        Wed, 17 Nov 2021 13:05:18 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id l25so512185eda.11;
        Wed, 17 Nov 2021 13:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W8VEPkIJ+G9KDOOFEoKmrVPN7jMCAsjenX9iNG15oUo=;
        b=XRu6M3iQuOXjNWyPkNAzPR7F62BSOazpeWz9IDhVcwnE217NX98sixNEIVVjVOj7ST
         FvbK9J+wwRU6DyEi9yROmqzv1KZmexSq/IJZ16Bnq8xCkhdrAMsxIP23X02HG7kxa42k
         eDn+9A+zNVfwBMXwoUm9KzHH2hFZjLU7kScZgEmYh4+dg+FH014EovCSyNIueJyHy0Qf
         I3ZEa0hcXO+ty7A/8Zd7lieYdFSpbsIPKpSBsrtU1/jo8TQXRqz+vGmR+dgUP/fvQ56B
         S+POrdafrCbtzxKPi3QliheUmc7cXIveNneOHyrcUx3ujzBioh/QIJbOh9cvYmAxhETO
         3xtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W8VEPkIJ+G9KDOOFEoKmrVPN7jMCAsjenX9iNG15oUo=;
        b=Rr46anYQtjDqKxwx5hMOdmBFEQUocb2JSmOI7mh6RbTjIjFRl/PMioeoEgF5yE9J10
         xONDeDj6SMjvQg0w1T1aMRdLxvfbVRgPyBi6nPBT4JbLXq4SttwctArccQrvTPV+ULTk
         yXhhI0qvOvft7LWNuA2OHPLVG5GCcx+fy5/eJGmRpYBRW3mlNQ/Vj3oqCVUgYGT0CPfs
         eAbMgvKAufsuqej9xapgxUjpYwG5HMVYTJVZQF+TJRX1R//U/RyxRCzGg5X9wHNCHZR7
         RQF1iIzUq/Lv1HT6q0XS4Lp0LBMeAQcaDJdWT2/JvnrfoBwYdF/pK4hpuvMd+jtxOL/z
         1y1w==
X-Gm-Message-State: AOAM531NRa2ToXgBw3T/2rplgYtsHkrMJ1z5vxTmdUCFfUEb2wERWDhb
        QWo9ADS8b76OhhOYEZJRUxo=
X-Google-Smtp-Source: ABdhPJwNvor4DawGjeJMCNUv/gg3npFezWRsUL5kc+6ix6gAptWXcwTRX47h2QxAxyiFjDYWGjniDw==
X-Received: by 2002:a17:906:2ed5:: with SMTP id s21mr25243566eji.30.1637183116945;
        Wed, 17 Nov 2021 13:05:16 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:16 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>
Subject: regmap: allow to define reg_update_bits for no bus configuration
Date:   Wed, 17 Nov 2021 22:04:33 +0100
Message-Id: <20211117210451.26415-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some device requires a special handling for reg_update_bits and can't use
the normal regmap read write logic. An example is when locking is
handled by the device and rmw operations requires to do atomic operations.
Allow to declare a dedicated function in regmap_config for
reg_update_bits in no bus configuration.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Link: https://lore.kernel.org/r/20211104150040.1260-1-ansuelsmth@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/base/regmap/regmap.c | 1 +
 include/linux/regmap.h       | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 21a0c2562ec06..2d74f9f82aa92 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -876,6 +876,7 @@ struct regmap *__regmap_init(struct device *dev,
 	if (!bus) {
 		map->reg_read  = config->reg_read;
 		map->reg_write = config->reg_write;
+		map->reg_update_bits = config->reg_update_bits;
 
 		map->defer_caching = false;
 		goto skip_format_initialization;
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index e3c9a25a853a8..22652e5fbc380 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -290,6 +290,11 @@ typedef void (*regmap_unlock)(void *);
  *		  read operation on a bus such as SPI, I2C, etc. Most of the
  *		  devices do not need this.
  * @reg_write:	  Same as above for writing.
+ * @reg_update_bits: Optional callback that if filled will be used to perform
+ *		     all the update_bits(rmw) operation. Should only be provided
+ *		     if the function require special handling with lock and reg
+ *		     handling and the operation cannot be represented as a simple
+ *		     update_bits operation on a bus such as SPI, I2C, etc.
  * @fast_io:	  Register IO is fast. Use a spinlock instead of a mutex
  *	     	  to perform locking. This field is ignored if custom lock/unlock
  *	     	  functions are used (see fields lock/unlock of struct regmap_config).
@@ -372,6 +377,8 @@ struct regmap_config {
 
 	int (*reg_read)(void *context, unsigned int reg, unsigned int *val);
 	int (*reg_write)(void *context, unsigned int reg, unsigned int val);
+	int (*reg_update_bits)(void *context, unsigned int reg,
+			       unsigned int mask, unsigned int val);
 
 	bool fast_io;
 
-- 
2.32.0

