Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B653B8807
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 19:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbhF3Rw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 13:52:26 -0400
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:55031 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233353AbhF3RwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 13:52:23 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jun 2021 13:52:22 EDT
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 15UDhnpd015596;
        Wed, 30 Jun 2021 13:49:43 -0400
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2057.outbound.protection.outlook.com [104.47.61.57])
        by mx0c-0054df01.pphosted.com with ESMTP id 39gsrm066w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 13:49:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FT3vvWzgentKnDaXps2pWHli6Il4R6U2kUq7lqMXf9X/CLZtOOKJLoygYJ40KEEfR+JYB/KxQvbwpxglyqplt7FQiF+W1cynSd7pLXq2XddJsI4V9VGkgct5+YY4lIozGZ2kJC/uDQhxHahD+7R0Yt6fbGojxkJt/622j12+sedONl1aZkKK3DOoNEonxi41TTf4HyZKaQwEYnE3+8qJJMyUpIXUTZIrmWutVKC6qyYT4mDoBMPQGqXSVmWKtE2pv7vYLZhTQhYWk22KfEu6aBKcJSpack+BOGTxclf8CYdeMlsiw1vXFafUhgwpgjMyEz6ro7kyKAhusfTbyxMwUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lsl0Rj3qfLOAEBbbLFccwdf0orNjR9xoGOvMnAEOwc=;
 b=RQnyXWlVnVkgHTGBDpxnuBswpOfTFruePvrgFGv7Knwp1AAJK6vD7Lz08Oh+f9H8a0qI36RyMGN1YpFDYf9Yk2qW0FhG2Dy7SQR9gZ0z7+Gs2eseGlTByRwZoXx/TKIXUR/83/1kO5CnGoLWJvSMoldnNDq5hC0vh7zLBbBqvCraSrm/2kwzZQVh5Q/5UIuzJzQSjpINqxD/XCfWHnm5wYrt76JPAxVmCKb44XA2nwxSHPjIBSOSlgWwszKCYlHRWbD21rj27x3v3fQS0E+Hltghwx8GIT7ocmQVUDx056Ce+fG/E8ply6gQlWiIIFc8FgOsabmGPN7roUrnwXpJPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lsl0Rj3qfLOAEBbbLFccwdf0orNjR9xoGOvMnAEOwc=;
 b=lJPXIqX3m8HwuKEl6uAL9jMwXgChrt4OF0pS+KNRnz2/9GVRQdEGbW+651WKWFKxFQh/OjzK2C4vve+DmiVBPPhRn+VrEgSjIouju9D9/dXzk6a1m1SbGKCA1ttrEZMUIaLNTzqU0REb/mVV0UJ/hQdGjTvrh4IPJH6cIpO6R5Q=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=calian.com;
Received: from YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:27::23)
 by YQXPR0101MB0869.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:26::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Wed, 30 Jun
 2021 17:49:42 +0000
Received: from YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::88bb:860e:2f3a:e007]) by YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::88bb:860e:2f3a:e007%5]) with mapi id 15.20.4287.023; Wed, 30 Jun 2021
 17:49:42 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next] net: phylink: Support disabling autonegotiation for PCS
Date:   Wed, 30 Jun 2021 11:49:27 -0600
Message-Id: <20210630174927.1077249-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: MW4PR04CA0126.namprd04.prod.outlook.com
 (2603:10b6:303:84::11) To YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:27::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from eng-hw-cstream8.sedsystems.ca (204.83.154.189) by MW4PR04CA0126.namprd04.prod.outlook.com (2603:10b6:303:84::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21 via Frontend Transport; Wed, 30 Jun 2021 17:49:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11848ba8-8fb9-469a-0336-08d93bef7079
X-MS-TrafficTypeDiagnostic: YQXPR0101MB0869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YQXPR0101MB08699B6F982D922076869796EC019@YQXPR0101MB0869.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9474/Txgz7nkSCLJeEphpXK5V21bFo5XTy5U0hakrZUKcepR1fDEHsDw036ZpWXZ6GRfYJo/qsQIMik9HCI31t1OVuWKKqqrl090wnjyNB88c5IH+mT/h+k6oKQxaISsi10HvTj9kFOXeAfNxiN4NYLxMIcuCaHnimTkLynUa4F9rZlzaE986tPEN/Nww9rEX21P+2ujgIlJyLR9rncKA7SJm4bLVwMiayi4XVi7JQwTmULSIqyDK1fG2uAqiF8tpoQJGlc4HrO1b+CyYzUzKpr1IU6f7RkBV2fGnFNGmH7X2zvxi8esQ6RR2EK7x3X/Cunw1vFQHCpOcMWv9zIslY8njribzrjoW3eUnDDNS151K9S7Vm1nT1HdSqTbWvGOLT3ga+9s0FshjCt9TozMKk32eNYE1MmxUO4kqhvjczA3dc2hF9E8uTl7c+TJQr3p5NR+wg40mJiI0OPLHrlGscQeR+tfhc70B7mv3BHK0Ch2e1Aw5o5UZcGmWwkd8wUfHE8PHfL6ddpxpvNu50z/OtLcUOc9gZXXwqV38cdASV9rILPS2j7awEjqy4uxI6IpXENPZ5tbJMf1Tg3dT79IrVrk+oP7cLeoqRND5Nf5ygAT8G9HCcyMwUAxjZqdTKRz/7wRddEKJcsZ6sz0+XFuPqFDO6XwczN/69JeSi/kKbOt40ETD00LvoWGud4VwmcGQTBuJwYH3eZm64Ts9Km+6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(376002)(39850400004)(2906002)(6506007)(83380400001)(44832011)(956004)(66946007)(316002)(6666004)(107886003)(4326008)(86362001)(26005)(38100700002)(8676002)(6512007)(6486002)(186003)(8936002)(66476007)(16526019)(2616005)(52116002)(1076003)(38350700002)(66556008)(36756003)(5660300002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?emu83fgMFTIsG/IiDys66y2i2BYWZ5I12JsfoArA72ghAFzJa/uqH/tjt0Oc?=
 =?us-ascii?Q?un1IoC4Vv9JCXrl9sjbAhhfnteSEREPQMo8nv8AwtD442K7Kcas0H+V1vEbl?=
 =?us-ascii?Q?R8QO0NRVhyRe8P8sqQEbrrI+zzii0aR3waSePdA+ZZdxRU89ETpWiA0wgwIQ?=
 =?us-ascii?Q?Iz4jFB6hZgH1jYr/ENdshvh3SgCL3ryOiDc0Ezv6bhOTlHRn+SlDkghBwvRe?=
 =?us-ascii?Q?sG9RCStRaOTmUEvct5Q7jgCOuELeQyqfwQVSOP+PV2xNLMXC3OiKtp3JO+1c?=
 =?us-ascii?Q?n5dQSSnvB48Hj4zdNHlYyljzuptGJO2ymMTzhe72FOxD4KnHS+5Ir+gFc6DM?=
 =?us-ascii?Q?YvP91J3BxtMq0JNyWsFuEjfzplfj4KR6gukLiz3nvl1NfgvyD3UlhD00euEP?=
 =?us-ascii?Q?IbNt94p+Jj+Rrxg+0jNeYqi6rNu+Q6BFuBf+w2AdZFhRdfycJ0LNcQrPSZwi?=
 =?us-ascii?Q?xf6z+BX/rTqpIqpDwnK4Nhps+WoBdI8KSHbnv9tlJflRBB2giWJuD8UjorrJ?=
 =?us-ascii?Q?7w5gHWrN9cPLwT1uaxtLR0vrgAFNdNibJGYMXiVRdd6KFL5qwrTyRZOWRBXm?=
 =?us-ascii?Q?jzScX7abE84vVF0aETGsA2pdb03aSwVvvIHJmM6qZAs9mWwuRJcKKEUE440T?=
 =?us-ascii?Q?SuvKBd0b00PRuzk+qyDbVNr4Y7NVBQwVmUmDYU2QOF1kJ1GX8U/KSgVquiWb?=
 =?us-ascii?Q?TwoZnaWZ38JlqDBousZhodV/sKTLhbp3JZjqW9LVv+vwE7nmNWZ1i1qxaAxz?=
 =?us-ascii?Q?L4HoeNofuocyG8gplHh8r6haH8Yv4rUYn4Ia/YG0lh5XnDtd7RIZTUeUnkFt?=
 =?us-ascii?Q?2V338bFkgvNMxIW85OIVg1foX/xdLy52qiOAeHezCafkhhRhGVoUZXllXdXf?=
 =?us-ascii?Q?28pRXEurdMyFYG0mw7KR+UfYv4Zq3gYtX4/pyK/BGgZ8xAOr92iL7p46yFxs?=
 =?us-ascii?Q?2rOitaZpn7bAX4fxvPzYIJcCtrmT50EwDzZWpKgkYtgP45bPRtntv++es+LL?=
 =?us-ascii?Q?m5RZT68nN7sTSo8iQpj4C3d0WEUyxxrlUby0aK0NTM4IqqJsRbmaxI+Mh1rR?=
 =?us-ascii?Q?yl+LSYMJDfF/UPfqaauXKbyOdTWTVf4GIkZqKYyUTVDtH9G7xc3ZFSasB8xN?=
 =?us-ascii?Q?PlaaCbRBqw5veeNu/1M1KJkwvvrXllY0FTHAJlcaP/8Y1OhKVNa1qzEHxI6B?=
 =?us-ascii?Q?aG+eWKwpqofX5vHieRKBWXGAeolABMIqn51wPEcIOoGjYB0O2GGLFMbEujmY?=
 =?us-ascii?Q?RgkG3MEHCxCJddt8iQsE/tXhNvA4P64QiMiMDM2X/g/ZEjLS4rpL7GJFeP8R?=
 =?us-ascii?Q?BYWBlFXJXZkr44aJa5BcKHhS?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11848ba8-8fb9-469a-0336-08d93bef7079
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2021 17:49:42.1330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uKENLngzN1MrI0Fc5A5pvDoIcuMmpYzF6ZFpu9LyLnJHXgQh7vz5/ez6E13B3M5yCKD4bbbL6fg2WBYHvWIEcNKbqnItQM7ZCB8o+8gAsyo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR0101MB0869
X-Proofpoint-GUID: JadBhL4ms0bTYWZGrhMyRyWAELchMcTJ
X-Proofpoint-ORIG-GUID: JadBhL4ms0bTYWZGrhMyRyWAELchMcTJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-06-30_08,2021-06-30_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 malwarescore=0 clxscore=1011 impostorscore=0
 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300098
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The auto-negotiation state in the PCS as set by
phylink_mii_c22_pcs_config was previously always enabled when the driver is
configured for in-band autonegotiation, even if autonegotiation was
disabled on the interface with ethtool. Update the code to set the
BMCR_ANENABLE bit based on the interface's autonegotiation enabled
state.

Update phylink_mii_c22_pcs_get_state to not check
autonegotiation-related fields when autonegotiation is disabled.

Update phylink_mac_pcs_get_state to initialize the state based on the
interface's configured speed, duplex and pause parameters rather than to
unknown when autonegotiation is disabled, before calling the driver's
pcs_get_state functions, as they are not likely to provide meaningful data
for these fields when autonegotiation is disabled. In this case the
driver is really just filling in the link state field.

Note that in cases where there is a downstream PHY connected, such as
with SGMII and a copper PHY, the configuration set by ethtool is handled by
phy_ethtool_ksettings_set and not propagated to the PCS. This is correct
since SGMII or 1000Base-X autonegotiation with the PCS should normally
still be used even if the copper side has disabled it.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/phylink.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index eb29ef53d971..4fc07d92f0c6 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -539,9 +539,15 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 	linkmode_zero(state->lp_advertising);
 	state->interface = pl->link_config.interface;
 	state->an_enabled = pl->link_config.an_enabled;
-	state->speed = SPEED_UNKNOWN;
-	state->duplex = DUPLEX_UNKNOWN;
-	state->pause = MLO_PAUSE_NONE;
+	if  (state->an_enabled) {
+		state->speed = SPEED_UNKNOWN;
+		state->duplex = DUPLEX_UNKNOWN;
+		state->pause = MLO_PAUSE_NONE;
+	} else {
+		state->speed =  pl->link_config.speed;
+		state->duplex = pl->link_config.duplex;
+		state->pause = pl->link_config.pause;
+	}
 	state->an_complete = 0;
 	state->link = 1;
 
@@ -2422,7 +2428,10 @@ void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
 
 	state->link = !!(bmsr & BMSR_LSTATUS);
 	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
-	if (!state->link)
+	/* If there is no link or autonegotiation is disabled, the LP advertisement
+	 * data is not meaningful, so don't go any further.
+	 */
+	if (!state->link || !state->an_enabled)
 		return;
 
 	switch (state->interface) {
@@ -2545,7 +2554,9 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 	changed = ret > 0;
 
 	/* Ensure ISOLATE bit is disabled */
-	bmcr = mode == MLO_AN_INBAND ? BMCR_ANENABLE : 0;
+	bmcr = (mode == MLO_AN_INBAND &&
+		linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)) ?
+		       BMCR_ANENABLE : 0;
 	ret = mdiobus_modify(pcs->bus, pcs->addr, MII_BMCR,
 			     BMCR_ANENABLE | BMCR_ISOLATE, bmcr);
 	if (ret < 0)
-- 
2.27.0

