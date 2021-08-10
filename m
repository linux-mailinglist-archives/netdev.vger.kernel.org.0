Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792E23E7D54
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 18:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbhHJQSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 12:18:40 -0400
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:23521
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234936AbhHJQQh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 12:16:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fx+m1FevHisCyzlM/DusyWbr+gkrGmOfkwK2fswalf4kSh96SY6hgfH2oRuVF3ou8kOGUb1tLJqUYYyj+leQF6KYuWdNFgmitekMfMeD1omglM/dr0D9n/5gnV9zPvqqdICarn149eQBICcWLS02VHhqiBeq/+a68Tk4YTm5zwS6OPSri+T8hf4XSCsQs1vCX8EeUx4gXVdRFgWi6aecegRPXjU5TG+lfWIBTsonuEYraECp113NfXWSSvLUqowOTvjp3SGCLxUoNDRw3dq0hfUYoVxKkHjjkYg3cTFxEDI6/AK6zYLH+Y5p0aQajc9ww3GBXPhd2C/LRIU8NPYmAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVQ+QwfFN8J4dK05om740vkFljwYVXOzBExFmow+Mag=;
 b=SGtEtLwPmTppGz8lIeHZ8DHgLqhQ0RXijTSOYfi6U7UTzyhCkHHg3++aMglEBpTHVyNsoceL1A7xSV/beBXft1Pw/PN6tYbgl7zc/bIgG4YUGBFbHKLK6+O5mebxALVTBtDEWNicY2yp6d98+r4w/MHf7N8cFhyW4VxDteCxF2gpV+y95XRh8Xvsh2MH0z0tg8G8J+enwIqATZM0JvnDmp+6sMdrIWmyxSgucDMeMd1TOHqA1FrYKcg5P4MpslT3X2+juYPjfKfxzmQ915MB/31W9166AarS/ZbildfUovc0+jhNAq44ILXhCHYAX/P69dMWtZZUYMEJj333LjLo9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVQ+QwfFN8J4dK05om740vkFljwYVXOzBExFmow+Mag=;
 b=ClH8uKZjds6kvwB/I/T6B6HiGb94F7ZbAXkLY1wGQ/e85HmoP19j9WlRn3C1c7sGz6h80kgj3wwD4ZSVMoRth1LDd9SAL8HpYbNFu6jcMMQ00ENayH/DKNAWbEdUHm+DQg2HJ89EoFcAKpjXHhrcJO1ExPjBfmRPtFTS8R0Seeg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 16:15:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 16:15:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: [RFC PATCH v2 net-next 6/8] net: dsa: remove gratuitous use of dsa_is_{user,dsa,cpu}_port
Date:   Tue, 10 Aug 2021 19:14:46 +0300
Message-Id: <20210810161448.1879192-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
References: <20210810161448.1879192-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR05CA0031.eurprd05.prod.outlook.com (2603:10a6:205::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 16:15:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa4c96e7-46ac-445d-0d15-08d95c1a07ef
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2800:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2800FE2B4482897A5E87ECE7E0F79@VI1PR0402MB2800.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YqLmJMydxwXTAGyjEQUImk2mWbmD/QuapEXtWKfg3ivLjKyuiwH+QQQ5GAYGM45Rp7Tp5A194Ta2Kueo1CdloEg83LQpVl+Sqdxmg/tFkNomEZqNEmKlT8kbay4HN9dCKVO6iqj3LQb3p7nbtDBsH6/spM/xaf7SICLisshuo7WMrcTHnyrYeGpP47MTErrPqS5MkEqP3+1iOecrKZOeqsQTDle+0QP1pkZP5z5lFCaveL8CaMQ9GhcT1ukHwOMralMxJEXmUharF+3kpz5bPvuyxBWKU0LD4L+I3uUgj9sLtnlFw7hnJwPGE1pa8GxpZqzQQaXCmJyIvOmxK42hiWV0Mi9JvLcdAshmYrTQZusk8EViAHpGQnRad0V34yO0JNYxzcNC+IjAZXrLYowmF5h2eaubi8E7X+mNKbohFknbAMa66LzHYma27viz56NCJ/RcQ/a8hlM5DC3Dp1cgNT1Pov2M3vdmgKQjcFcVPQ7L8QZN4NroRR6HnlcIk0t8dLweZZbectCGrhKmpYNdXfLGDWHHiQi49KLyX0GvEIqRMAK6pYwYdtYjSUt+XgL72cxywM6UhPO2m47Lq2uuPYEGAJcWBVqJEGZ1AQpiC77a1hV7eG8cIZ58MKAObR9ci2Tts3H/MnYhyjfUnpmUDRVoVCs9Ba+CxBjBcNjk9kfI71gE8rjcGb90+fHzgd/m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(6506007)(52116002)(6512007)(86362001)(110136005)(478600001)(8676002)(2906002)(956004)(83380400001)(54906003)(26005)(1076003)(8936002)(6486002)(316002)(36756003)(7416002)(186003)(66946007)(5660300002)(66556008)(66476007)(44832011)(2616005)(6666004)(4326008)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BcSOyLqmIIi2W3j4rM/KDT1gOzAbuQJ4EpL3jlS89qRWoTLsxEkS7ctfJlQb?=
 =?us-ascii?Q?lLgEmSrYyMmAAQNYjKGhtX05KNokNrXZ+Z2lwCJk6ljOm/DVooQPz+UNDRGU?=
 =?us-ascii?Q?Hw8i+OvoyHQ0G/nncLbote/MEH15XIVHyH+dkPxPyOZPk8mrY97NkT8RydVq?=
 =?us-ascii?Q?XL/jwh2zdd+3lA2nZzNA4cq8P7/m/PYQmqQsO9G7k/IpH+aS2M66xchCw9qX?=
 =?us-ascii?Q?Lk/oaPb5sWw/BtlDiBVvK16nzVIkPm7A4QeAaPKu/vRtOqdfcazXMxeZUMrr?=
 =?us-ascii?Q?68i5YocDBhpm98RZuAjFM7xoZjxQsY4C600PQ9hnKBgd92N7VW/9Tj5dsD0e?=
 =?us-ascii?Q?r/zXMD89LYUoaJIMZ6DJ+j1vXz5ZNVjZXNkwfW6kq9NapPw3O2eUnZLROG3T?=
 =?us-ascii?Q?x/XwycWJeQlzKrag+DcS9blAY+5ERknu7VGYlKExM37+jyJQYW9rYN+a+CiG?=
 =?us-ascii?Q?BE93ERvDd6RC1gH4zVQszPbljmJSzeRas4+JIgxX1yWviRrDr3DDJ6gK9+Pv?=
 =?us-ascii?Q?5/7lhSNPddgpvB61ZudVV29iO1IlULzp7BKr5rfGQnmLKZHH4BOfUUTFuGs1?=
 =?us-ascii?Q?esG2FRjN7eosrPI11z+7RomJbCojeoKzCyRMOiImVHXsvigtzc+KI7tVMpuS?=
 =?us-ascii?Q?H6xzp49o+rFOr36E1CfPMd67Z0ut/IdxI9uAUCefwUUJRMBjaigeP0CvzeB6?=
 =?us-ascii?Q?39PLiYE6y/rk26vif68cuRhERgQqCio7WP14jaLxnpZQM9cazrMVKjcSwEug?=
 =?us-ascii?Q?7u7R1BoLwHrZugteQlhtscD0Mi3DnrbsIhXPv//yGCpkdAJ1hCJm7RQF+SV8?=
 =?us-ascii?Q?JCt0eRqK7uRpLT3g6nrkm9gZPwuUBQYNF7UpXBNnIBtITqI6hRioxhp0vBAX?=
 =?us-ascii?Q?KTxvjrlAcX7bwQSD+Lyx0l2fOm4j0d5tlSc2fjete/UXBmtR96UDi5fkXkAF?=
 =?us-ascii?Q?MAAI77d6Yo3N4yHRKJ3lPU5KQnteV7HsgnFN8ehrO3CCrgnkPROI++zxpnnu?=
 =?us-ascii?Q?T/U2Dpl0YuYliyl3lM6+fnOrRySgD7qyl49HBkALGFbAg379kSncwQTrgJPk?=
 =?us-ascii?Q?mEaB45XB0Ki9a6ofU8i8SfjoW0OIjkbEjiM5mRw8G4j9Y82O+W9OXS6+reva?=
 =?us-ascii?Q?IiYlh3b6EyOEZ6TxpXQ1JW1blmKx/HtfL3/3AVHF/H47F9EMnwnM7k1ih+Jf?=
 =?us-ascii?Q?Sk5hp0fdc0EA+TZ44K7LcxfQIrygO8byBqoQs2YVYSkGU+Q3e9ItLDInQNy+?=
 =?us-ascii?Q?2GfoIOftut99B2/FN32t1cJM4u/wbj8+rVbJEjB7g00JnSWHYsGl1tpzpD+R?=
 =?us-ascii?Q?zbafSbdbziqAcqRx/cg289lc?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4c96e7-46ac-445d-0d15-08d95c1a07ef
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 16:15:12.3197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z08Jmklnr0N7vh6tkviq/kO9RPHJIQmbp7VgpEqYC6cjPdcm4J99VdT1bmQVyVPmXLWA/NTddusA8IUEk+OXVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Find the occurrences of dsa_is_{user,dsa,cpu}_port where a struct
dsa_port *dp was already available in the function scope, and replace
them with the dsa_port_is_{user,dsa,cpu} equivalent function which uses
that dp directly and does not perform another hidden dsa_to_port().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 net/dsa/port.c                   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5ce3c9129307..edd8eaa22bc7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1641,7 +1641,7 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	int err;
 
 	/* DSA and CPU ports have to be members of multiple vlans */
-	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
+	if (dsa_port_is_dsa(dp) || dsa_port_is_cpu(dp))
 		return 0;
 
 	err = mv88e6xxx_vtu_get(chip, vid, &vlan);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 05b902d69863..e035650a30ab 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -548,7 +548,7 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 	 * enter an inconsistent state: deny changing the VLAN awareness state
 	 * as long as we have 8021q uppers.
 	 */
-	if (vlan_filtering && dsa_is_user_port(ds, dp->index)) {
+	if (vlan_filtering && dsa_port_is_user(dp)) {
 		struct net_device *upper_dev, *slave = dp->slave;
 		struct net_device *br = dp->bridge_dev;
 		struct list_head *iter;
@@ -1046,7 +1046,7 @@ static void dsa_port_phylink_mac_link_down(struct phylink_config *config,
 	struct phy_device *phydev = NULL;
 	struct dsa_switch *ds = dp->ds;
 
-	if (dsa_is_user_port(ds, dp->index))
+	if (dsa_port_is_user(dp))
 		phydev = dp->slave->phydev;
 
 	if (!ds->ops->phylink_mac_link_down) {
-- 
2.25.1

