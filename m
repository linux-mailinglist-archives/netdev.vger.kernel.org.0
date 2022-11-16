Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A6962C62B
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 18:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbiKPRTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 12:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiKPRTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 12:19:15 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A949E45098;
        Wed, 16 Nov 2022 09:18:59 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id h193so17252016pgc.10;
        Wed, 16 Nov 2022 09:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KdnWpXnlMV8dqtc8sv94MXZIkfMTh+D/0AUVWA5+XxA=;
        b=eEQpQ/4vA4BjeCi1aI0tHdBoPVcLwN0Zqr3YWmYJKxkyiJM69zbAFwOxMMaA7gOo1j
         REI6EK4UH73G00dE6+dFE65dEqpJafISG4TTwdeen7hYnKZwUwPogTNO5ixFISaqxGhT
         AIZizoUvpoOXrndgB6ZkgKOczq56WG2BIJRC68MuAfKHLhB+R3P/htyJMWm/LNtF697S
         LPNMNmv96kmuCYGv9ycejgEclbB8nka9lnsqVNk9wCswsSDIJMIpaqckkwS8rm28aatE
         eOWqHwp8K2GHbIlV8azmj9Qi4fgpoEASYSkLB+RHUn5LEJLBP/ff2VGFXcT1fK/GSi5g
         GwiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KdnWpXnlMV8dqtc8sv94MXZIkfMTh+D/0AUVWA5+XxA=;
        b=YOk21YKJfDgG2/COZEL/7bimhGfV69w9LbXv1xwjwTZDUs5NndeoMGr4XYr8k1LeDl
         aIQ33WzFcyH8iJHss4wEAyc9ZZoev5uma30NRgY29k0T7hM6iOElderetTuzb0UfsoGs
         5FX8LOtBJ9ZBg14Owzq5d8lQEWfMls+pqysAm8AtlrRZayXqHKNo/Jl7HsLScXHnmzJ+
         4Dmkyq2ccngueDghz0zcuZ/ePr0gGEV1T61s7VfoTNpgVE/IPHCy1dl93fRlaeOtCt9S
         Nwg/h32SamG2FCMGNmmTJEK+UIrtGUx3QRN8+/HU6jAry/zE/ZCytwgDL/AYmDJlzDUT
         d2dw==
X-Gm-Message-State: ANoB5pkl5/IycjE8E18FFHlfGKuEj6BdrjMD3A/mcc0P+efZhC2q9aB4
        W+VUd5muZBX13Y22HjJ9xtk=
X-Google-Smtp-Source: AA0mqf5jic0GmJlm5IomfjTAv/QAwfiVyeeFDKgw3jg6jUBkIQ69aND/mMQ6qy8xMsNETGZSJnxKHg==
X-Received: by 2002:a65:620e:0:b0:470:5f22:1496 with SMTP id d14-20020a65620e000000b004705f221496mr20855979pgv.585.1668619139055;
        Wed, 16 Nov 2022 09:18:59 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id s14-20020a17090a764e00b001f262f6f717sm1867217pjl.3.2022.11.16.09.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 09:18:58 -0800 (PST)
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
Subject: [PATCH v5] ethtool: doc: clarify what drivers can implement in their get_drvinfo()
Date:   Thu, 17 Nov 2022 02:18:28 +0900
Message-Id: <20221116171828.4093-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221111030838.1059-1-mailhol.vincent@wanadoo.fr>
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
rest is expected to be done by the core.

In struct ethtool_ops doc from linux/ethtool: rephrase field
get_drvinfo() doc to discourage developers from implementing this
callback.

In struct ethtool_drvinfo doc from uapi/linux/ethtool.h: remove the
paragraph mentioning what drivers should do. Rationale: no need to
repeat what is already written in struct ethtool_ops doc. But add a
note that .fw_version and .erom_version are driver defined.

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

v4 -> v5:

  * update struct ethtool_drvinfo doc in uapi/linux/ethtool.h as well.

  * remove the paragraph mentioning what drivers should do from struct
    ethtool_drvinfo in uapi/linux/ethtool.h. Rationale: no need to
    repeat what is already written in struct ethtool_ops doc.

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
 include/linux/ethtool.h      |  8 ++++----
 include/uapi/linux/ethtool.h | 10 ++++------
 3 files changed, 8 insertions(+), 17 deletions(-)

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
 
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 5c51c7fda32a..9e0a76fc7de9 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -473,10 +473,10 @@ struct ethtool_module_power_mode_params {
  *	parameter.
  * @supported_coalesce_params: supported types of interrupt coalescing.
  * @supported_ring_params: supported ring params.
- * @get_drvinfo: Report driver/device information.  Should only set the
- *	@driver, @version, @fw_version and @bus_info fields.  If not
- *	implemented, the @driver and @bus_info fields will be filled in
- *	according to the netdev's parent device.
+ * @get_drvinfo: Report driver/device information. Modern drivers no
+ *	longer have to implement this callback. Most fields are
+ *	correctly filled in by the core using system information, or
+ *	populated using other driver operations.
  * @get_regs_len: Get buffer length required for @get_regs
  * @get_regs: Get device registers
  * @get_wol: Report whether Wake-on-Lan is enabled
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index f341de2ae612..58e587ba0450 100644
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
@@ -179,10 +181,6 @@ static inline __u32 ethtool_cmd_speed(const struct ethtool_cmd *ep)
  *
  * Users can use the %ETHTOOL_GSSET_INFO command to get the number of
  * strings in any string set (from Linux 2.6.34).
- *
- * Drivers should set at most @driver, @version, @fw_version and
- * @bus_info in their get_drvinfo() implementation.  The ethtool
- * core fills in the other fields using other driver operations.
  */
 struct ethtool_drvinfo {
 	__u32	cmd;
-- 
2.37.4

