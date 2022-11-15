Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99FA62AF77
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 00:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiKOXfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 18:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiKOXfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 18:35:32 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1D325E94;
        Tue, 15 Nov 2022 15:35:31 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id l2so14821063pld.13;
        Tue, 15 Nov 2022 15:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXT6t4V5rZmP6BoieWbc03yVr+oSUgcqfVfJ/T8w1cI=;
        b=hmz4b2JlE/NJbO7xVmWS7MVl8kMleGGd+w6QCKLC/ZHYBkqJa2ed60T8w48IrERv9/
         0ktfpsNSNDFXO+ntj+cW5URJ/0Y32oliZg+d1VEEWPIbE4xTgjyDv3PsVV1A/GTyE/NM
         lOuEkYxQvumP34JIMsqLvCck/jcz3DYxhc3DCDll0D6LZnKk14i5mtOcyVH3Wu+Ncmn8
         H2W3wjwTJAzES3FNF5IiL/EoUiWJFHMdQwl+FAF1SK653f5HGsC/845b80/209nlok7g
         9k+X/pKTuBauSd9LOUGcn9MbXl50dg6hU/ES7eCWsgLQ6W4zvnMSznqFgJB0KZf4yBb7
         Gi1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PXT6t4V5rZmP6BoieWbc03yVr+oSUgcqfVfJ/T8w1cI=;
        b=siuPcwVREj90ck/Hhex19wH4lO6UElAnLz+BhXK6Gje/OEjyYZM54rQZ2CgLphy+h3
         wpwb5SoIMsTTBZms9da8qu/9D3BKlFVMGk7ozAyHLI58yHhwtLDuJc97/0074naGQEXw
         hJqCX+1Rs28eEaDpOXIAnr3xf5BVu8ONoHm37Scjae9WCK8PoiHTYzq9r1InEmGHApxJ
         sN7eFDwG7Y1lDTY3+gPdH3BFrIppvdyvvBHt0792jh7LIcKdGdxy4hhqj9JFLfGRlHzd
         BHiJstxrng45vItzXxt22MyCdhnmxAfuxvFP8uPHX28QOYu/iHdrng1MdGJ7uREwNVVs
         ViAg==
X-Gm-Message-State: ANoB5pmxSI8T0IgTZeYVLX/5OIGlkyBSUr3if27GmJ7GcQjhlK3cj72o
        YGxi30OHUnDquP74+S6pbSg=
X-Google-Smtp-Source: AA0mqf6Jcbp/QJKxg2Vqxq/VcXRV+weVW31uIj85GkroBswFjtHQgVofvlPxoYJ+hE3J9kX/oqvOfA==
X-Received: by 2002:a17:90a:6508:b0:213:3918:f2a2 with SMTP id i8-20020a17090a650800b002133918f2a2mr695024pjj.218.1668555330639;
        Tue, 15 Nov 2022 15:35:30 -0800 (PST)
Received: from XH22050090-L.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.gmail.com with ESMTPSA id k4-20020a170902c40400b00186a68ec086sm10555362plk.193.2022.11.15.15.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 15:35:30 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Petr Machata <petrm@nvidia.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next v4] ethtool: doc: clarify what drivers can implement in their get_drvinfo()
Date:   Wed, 16 Nov 2022 08:35:24 +0900
Message-Id: <20221115233524.805956-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: 20221111030838.1059-1-mailhol.vincent@wanadoo.fr
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many of the drivers which implement ethtool_ops::get_drvinfo() will
prints the .driver, .version or .bus_info of struct ethtool_drvinfo.
To have a glance of current state, do:

  $ git grep -W "get_drvinfo(struct"

Printing in those three fields is useless because:

  - since [1], the driver version should be the kernel version (at
    least for upstream drivers). Arguably, out of tree drivers might
    still want to set a custom version, but out of tree is not our
    focus.

  - since [2], the core is able to provide default values for .driver
    and .bus_info.

In summary, drivers may provide .fw_version and .erom_version, the
rest is expected to be done by the core. Update the doc to reflect the
facts and discourage developers from implementing the get_drvinfo()
callback.

Also update the dummy driver and simply remove the callback in order
not to confuse the newcomers: most of the drivers will not need this
callback function any more.

[1] commit 6a7e25c7fb48 ("net/core: Replace driver version to be
    kernel version")
Link: https://git.kernel.org/torvalds/linux/c/6a7e25c7fb48

[2] commit edaf5df22cb8 ("ethtool: ethtool_get_drvinfo: populate
    drvinfo fields even if callback exits")
Link: https://git.kernel.org/netdev/net-next/c/edaf5df22cb8

Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
* Changelog *

v3 -> v4:

  * rephrasing of the documentation according to Jakub's comments.

v2 -> v3:

  * add Reviewed-by: Leon Romanovsky <leonro@nvidia.com> tag.
    * use shorter links.

v1 -> v2:

  * forgot the net-next prefix in the patch subject... Sorry for the
      noise.
---
 drivers/net/dummy.c          |  7 -------
 include/uapi/linux/ethtool.h | 12 +++++++-----
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index aa0fc00faecb..c4b1b0aa438a 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -99,14 +99,7 @@ static const struct net_device_ops dummy_netdev_ops = {
 	.ndo_change_carrier	= dummy_change_carrier,
 };
 
-static void dummy_get_drvinfo(struct net_device *dev,
-			      struct ethtool_drvinfo *info)
-{
-	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
-}
-
 static const struct ethtool_ops dummy_ethtool_ops = {
-	.get_drvinfo            = dummy_get_drvinfo,
 	.get_ts_info		= ethtool_op_get_ts_info,
 };
 
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index dc2aa3d75b39..e801bd4bd6c7 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -159,8 +159,10 @@ static inline __u32 ethtool_cmd_speed(const struct ethtool_cmd *ep)
  *	in its bus driver structure (e.g. pci_driver::name).  Must
  *	not be an empty string.
  * @version: Driver version string; may be an empty string
- * @fw_version: Firmware version string; may be an empty string
- * @erom_version: Expansion ROM version string; may be an empty string
+ * @fw_version: Firmware version string; driver defined; may be an
+ *	empty string
+ * @erom_version: Expansion ROM version string; driver defined; may be
+ *	an empty string
  * @bus_info: Device bus address.  This should match the dev_name()
  *	string for the underlying bus device, if there is one.  May be
  *	an empty string.
@@ -180,9 +182,9 @@ static inline __u32 ethtool_cmd_speed(const struct ethtool_cmd *ep)
  * Users can use the %ETHTOOL_GSSET_INFO command to get the number of
  * strings in any string set (from Linux 2.6.34).
  *
- * Drivers should set at most @driver, @version, @fw_version and
- * @bus_info in their get_drvinfo() implementation.  The ethtool
- * core fills in the other fields using other driver operations.
+ * Modern drivers no longer have to implement the get_drvinfo()
+ * callback. Most fields are correctly filled in by the core using
+ * system information, or populated using other driver operations.
  */
 struct ethtool_drvinfo {
 	__u32	cmd;
-- 
2.25.1

