Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5B93FE5D8
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343609AbhIAWw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 18:52:27 -0400
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:32899
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236906AbhIAWwJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 18:52:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1s5M7gCpJbRHyLo/wJsRfiIZu0bPNBgnZnR1ka0ja1eFxGhudiW9Zbf0TqrPYSsQGipxjBjuWCHL4IsObbiPsVMwQxY+RuWQZmIlUrPlccJRF4xf9OUtzUCRKsRc03wmwGddfxXE9I7frFoh4QWiTD3hhmO5/Ln6B8lhU8CN2/+5yXA7Fr7uqLOu5zz2al1Xa9+QjYOxoMjBZ49z/wXtf3CY6I7DB7xWvXVrwCgnQsmWUHZOjdKHZcob1AskLzDU97z7LntSG1HBazsSbS3AfJ+7gpLXmuykATLDRoytie57HbTpDkmhIdOU+sBXRWk6bAMX/qcI/jhlnG+nyv8dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pWiPOuEmFZyrTxtIUVeN4fyc4bTX3yYc0vTDGglDUzo=;
 b=XaNCbXi/wlfTNT73R8Pn3kJWOi+/+35VHotBxSUXz0HW2gyqZhL6u2/De061v7G018Mx20lzdyRYvn/ItUp3210xrVQqKpgo0YrDxRms246i3tOX3MbYtgPcKAf8mkRhw0mJxnz81CLwzhbayhISfujdEOi7uqC7hAU6EJeFHx+Kc7LEsOdYAlrjqMzaUNrh2yXMlKhErd64WHGcAeIxmWBW40ccw2RAU42kyjvBucWRxdnXH+7PHWvv3xKkPl/WkKRDngnx1a5JITyLPkkkZcFaL30/qN26HTv/C6xSrewg2jFKDzmZOrC11C3PuePctgJckCG5hCWTmpRw7uaEDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWiPOuEmFZyrTxtIUVeN4fyc4bTX3yYc0vTDGglDUzo=;
 b=MnYpuEtCCuJws4xigf3E1XlDu3PSY0Ec7eizZdcWhtCwkKw/xUFlVPefaSo9KsbEFl8ZIjx4pXELmcRwfA0KPuMkzYM2isK0ZMSOF8KQD2+nNFnQB5DwYj/xbf977y17nLiceWwSDy+gauK9OwLASTpL2Ws80+9FiyJIK5t5WVQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6015.eurprd04.prod.outlook.com (2603:10a6:803:d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Wed, 1 Sep
 2021 22:51:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.026; Wed, 1 Sep 2021
 22:51:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in phy_attach_direct if the specific driver defers probe
Date:   Thu,  2 Sep 2021 01:50:51 +0300
Message-Id: <20210901225053.1205571-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0130.eurprd04.prod.outlook.com (2603:10a6:207::14)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM3PR04CA0130.eurprd04.prod.outlook.com (2603:10a6:207::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 22:51:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d5d4052-366b-422b-a641-08d96d9afbc8
X-MS-TrafficTypeDiagnostic: VI1PR04MB6015:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6015AA911EAC234ACEAB3FD5E0CD9@VI1PR04MB6015.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /1kGNySXgg76QpPjveAl3o01fWS8SysvXRT2y7I3kdrnHuJiKZid5wIIIKgg5O9ihqXg2Vib5eck9fbTg/eoY4aEaX27RbIFUm4reisI2XCCuz/J6TKaEoUx/dVz6fz7ZvGUk56yYgKMph4CWyKrTm+sYbNK1JXbdVBGbjf7+M+KiMq5E1Nzr9OUC3r3aep0rbjXY4tUWh/SAEnvNChJ8NpGqjJRPy+oh177l45ZbHxzx/6sISvPll5kl02rtco5JEpAo9viFOLdLps+NgR+sbkHLEdmRszTHT0/msf0JNLwfMUrGDf3UN4+ZJ1Z8iyvv02/7aQM6nY3/8drsHI9OJhgEIuxCTiU3lSl/zIUEBW7aZ77jmgFhnkyO1BOerlazPNxG8Y1DJ9bPHF5ioj1x03AvQPa7KteQkSpQ/GP0JoN8dsqk3TCZMYAiEcxNMOWq1ElCI/BAMSO5cmk2ExG2UsgLI9kCHxKVZc512QkamCtnahHA3Kg0CYMe+fpj8Jj9vG2VtJvkY7y0ElKBsU+njGpcCYAT0lo+ZuRfzQ/MhuCaWpiMSQH4ovFk/oY61az3eNPHUuLDxBiLsYICTW+7adw+rZNQvnf//jlwVCAPH5dkOMsfX30J3uUeg48Kdim0E44V0hkQVqe4KaYpUqcSoAEmG3PlcOesy8exHSsw30TqYOp6aLoUa/M5bBDZsLie434f0X60BxmIPJWPFHn3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(66556008)(66476007)(83380400001)(186003)(8936002)(66946007)(26005)(6506007)(52116002)(316002)(36756003)(478600001)(5660300002)(6916009)(2906002)(7416002)(4326008)(6666004)(956004)(86362001)(2616005)(6486002)(6512007)(44832011)(1076003)(38100700002)(54906003)(8676002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?muemRvmZsER8ennsqke+yIxR0DgheQjxSCC8AkIrB1LEl18AZFgMn71AKM+q?=
 =?us-ascii?Q?nuceJW2pgieoIhSH+oBX0O78l+3LG6zKJcKgA8T6oF59eTL2eNEplkuy3HKq?=
 =?us-ascii?Q?5AwHHDaOs5wLtFdqO99ciXfVk5OggfNGN8htVkMgUPjYgh44RdqL/d6+wv/L?=
 =?us-ascii?Q?JNC1EddKXGRi73xHGP0DJtBNwdzWDH9GwCEj2xNtXY0EhJhobhuiNsO8rsvM?=
 =?us-ascii?Q?OEe85w9mhX218G/eeHdR7TzcwmRVxFW6bu0KFsgKSRBCkRRQ7e1Bu5689v5T?=
 =?us-ascii?Q?mLPPE1BIhxL8hroxEUFK6umFH7IU43kWnatcqiz/pKpOg6ptDjz+eygeDtp/?=
 =?us-ascii?Q?QMhOBNzXgPN0ICmsT38PBqWsTNCsjCUj2TkR5H3X82LGDTLJqBEEdnTHcOMB?=
 =?us-ascii?Q?/wGaU9JErQdtLRLYD3KLXrUqvwCtTuMvae/GKrHNrMwCUuD/GAnri2ErePwh?=
 =?us-ascii?Q?5LfWVuVhSZuTCfMLaw9sLRla13Wo3qKeDYKQURqKOLZnZEB7VBFRG4cAQpVo?=
 =?us-ascii?Q?P6u8/gzeroNmf/MXcekJ1Pzj+UTmMlDfo6Iz1qS6Wk+kV5pS2jOZInnLHIKl?=
 =?us-ascii?Q?Y6/E4kzp3OtqCSKA1Hcgg34/OMVLw2lz7UUArOYBeda29+B1EAuODUMGxHGz?=
 =?us-ascii?Q?KRzOe3vq8f07SJCCrYnAWx/Rbz3JEpagLQ3s+MzBeGqgo4gC/RStXUb4S+3f?=
 =?us-ascii?Q?fwX2tDGrjZdoeJWEMWU4Yl9sFjOD3SQW9M0KxkuSfQIBxfzhkji6Upk3AxPy?=
 =?us-ascii?Q?HtTNX2x5dudDdun47M95irOXB+l3iu80RUMUJyjfqrMSGpwe4mY11ad1BsTa?=
 =?us-ascii?Q?euEf//zy4Oi1vFF09VnrNHSd5sTXD3Qe4tSfwF5Vj8k3sgLNokl7rB9MwGns?=
 =?us-ascii?Q?ABqDRrvmlBaZQ2UEkTfolOMxSii6fPOpfrl7S/Huiu0dhm5b4tCJR3NBTKoS?=
 =?us-ascii?Q?+R9x9BOukFpeOa/QMEaA2ru9tfUutCpyM9bRnlRfNL0lExWjih7qYxL+1q+S?=
 =?us-ascii?Q?kZ7tMrrP9wbJX70nKV/sRLQ9OEeGr3WGg0VrTDHVLRNXBVV6Gr1qCaWiOO5h?=
 =?us-ascii?Q?VhreqZ9hpi9fcFQJ1+AFTx/wBROmUZ0bdEPTbaRdfDb0z+Os4EGCprrhPwml?=
 =?us-ascii?Q?ndYIm15yqIPGNYC1D/fxTnNLc5VKHLg79fDr+Bk+mrV4MgFiR3YU6Rq/L/uH?=
 =?us-ascii?Q?ssTpQOwLeQ2dE/fDA8lVxf+q/z0xjd8huKkVzVtvUsopzULvmqLH5ycclMd5?=
 =?us-ascii?Q?kpFbdZ5WNTk3vwhOA+H1nNp9Sre0k9ktWj4/XArP4CeGiGgfKrVdKa3NTBlO?=
 =?us-ascii?Q?lansEr+1nP7YIdAjGAJunhjG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d5d4052-366b-422b-a641-08d96d9afbc8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 22:51:06.7887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: czQ8cnPbkwtV+PbLI4RAaFR5LAuQkgyyceVswUgAr1jj5E6oox8M98ezYmvnPh+IfM1K02Un01PrvMfXIGuRBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6015
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are systems where the PHY driver might get its probe deferred due
to a missing supplier, like an interrupt-parent, gpio, clock or whatever.

If the phy_attach_direct call happens right in between probe attempts,
the PHY library is greedy and assumes that a specific driver will never
appear, so it just binds the generic PHY driver.

In certain cases this is the wrong choice, because some PHYs simply need
the specific driver. The specific PHY driver was going to probe, given
enough time, but this doesn't seem to matter to phy_attach_direct.

To solve this, make phy_attach_direct check whether a specific PHY
driver is pending or not, and if it is, just defer the probing of the
MAC that's connecting to us a bit more too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/base/dd.c            | 21 +++++++++++++++++++--
 drivers/net/phy/phy_device.c |  8 ++++++++
 include/linux/device.h       |  1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 1c379d20812a..b22073b0acd2 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -128,13 +128,30 @@ static void deferred_probe_work_func(struct work_struct *work)
 }
 static DECLARE_WORK(deferred_probe_work, deferred_probe_work_func);
 
+static bool __device_pending_probe(struct device *dev)
+{
+	return !list_empty(&dev->p->deferred_probe);
+}
+
+bool device_pending_probe(struct device *dev)
+{
+	bool pending;
+
+	mutex_lock(&deferred_probe_mutex);
+	pending = __device_pending_probe(dev);
+	mutex_unlock(&deferred_probe_mutex);
+
+	return pending;
+}
+EXPORT_SYMBOL_GPL(device_pending_probe);
+
 void driver_deferred_probe_add(struct device *dev)
 {
 	if (!dev->can_match)
 		return;
 
 	mutex_lock(&deferred_probe_mutex);
-	if (list_empty(&dev->p->deferred_probe)) {
+	if (!__device_pending_probe(dev)) {
 		dev_dbg(dev, "Added to deferred list\n");
 		list_add_tail(&dev->p->deferred_probe, &deferred_probe_pending_list);
 	}
@@ -144,7 +161,7 @@ void driver_deferred_probe_add(struct device *dev)
 void driver_deferred_probe_del(struct device *dev)
 {
 	mutex_lock(&deferred_probe_mutex);
-	if (!list_empty(&dev->p->deferred_probe)) {
+	if (__device_pending_probe(dev)) {
 		dev_dbg(dev, "Removed from deferred list\n");
 		list_del_init(&dev->p->deferred_probe);
 		__device_set_deferred_probe_reason(dev, NULL);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 52310df121de..2c22a32f0a1c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1386,8 +1386,16 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 	/* Assume that if there is no driver, that it doesn't
 	 * exist, and we should use the genphy driver.
+	 * The exception is during probing, when the PHY driver might have
+	 * attempted a probe but has requested deferral. Since there might be
+	 * MAC drivers which also attach to the PHY during probe time, try
+	 * harder to bind the specific PHY driver, and defer the MAC driver's
+	 * probing until then.
 	 */
 	if (!d->driver) {
+		if (device_pending_probe(d))
+			return -EPROBE_DEFER;
+
 		if (phydev->is_c45)
 			d->driver = &genphy_c45_driver.mdiodrv.driver;
 		else
diff --git a/include/linux/device.h b/include/linux/device.h
index e270cb740b9e..505e77715789 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -889,6 +889,7 @@ int __must_check driver_attach(struct device_driver *drv);
 void device_initial_probe(struct device *dev);
 int __must_check device_reprobe(struct device *dev);
 
+bool device_pending_probe(struct device *dev);
 bool device_is_bound(struct device *dev);
 
 /*
-- 
2.25.1

