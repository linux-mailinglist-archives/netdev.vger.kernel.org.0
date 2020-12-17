Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6075C2DCAC7
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgLQCBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:01:21 -0500
Received: from mail-am6eur05on2082.outbound.protection.outlook.com ([40.107.22.82]:13120
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727331AbgLQCBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 21:01:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZFemwKYqX+lrufqhWSBHwIK3YWybvzviUo7k0xDK1QCxCRaU//4c1INIuVXcZ9FRw/WkymoF9g6QwhFWW9CQBRT1+fvqkYazoEsnxu4mE+/hXt4R1mu1CUgdvWwdrmke8Jh6g3Zl4TDfKx9zVP6dqG3vxvTm0liKSLEYceFc7AaKfFK6NK2uZI1mcxNTz8zB7yPfZRBOzxDJ8zrgUEDJn9/BbAoMDrUc8ZSwAKLqhlar0PYDX1PLzM7f1UkV8MVeaMGu0+3hOjNNNAym+VQLecIv98kRFNGGAwTVeNQAeBlpB+wnfI5ou/rr6zW06WV+uQB8CiWQ/aquWNnzcl/Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JakImaRNNbxkauYiVJbco782UzvuX6BfEClxgCr3YA0=;
 b=FnHTpWKU+/N7CMpxDsLgUbNXjQtLpZ2bNRgqDkw39km4FgY1FO8zhDDmZ1G1Rpo3E/13xqXQ3XfCzNHuLO5plaw+c54T9heX4EnYQALAHzHLeDiwtZfyffsR9GcXmmmMMZs3UJt94fsEVkZMLwvtG2ELgu9z795v+F7fMWZoOOVhuyJLbI62YJiVxcqRgA8hEKz0JEfECeRLRuIgjuy8h12DygQxL1Ute8MMqDACex1+j0ClAsRtexe8MfDKUkaFNcTnpBdGjA9exYKyUwled1N4YU27PS3oHKJOxQ1oc+zFiVZiR4UnYQstLJwccRst88ExzcBRVRVJBeHlLuhSbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JakImaRNNbxkauYiVJbco782UzvuX6BfEClxgCr3YA0=;
 b=l0jBp67jSDFtINLZ6Y+ByUsKNQH4O9XKvww+nHlzrUpOJXLA8pkI2hpUjk6XFM2G3TDxglD4Z/Lo90w71vLRVjgQTFwkG5ITy+4ksXX26gT28/Pj2HWN59kG4NEny0M4wm3uuqiQoy/Om2GgZPH6MIURiMTMJSfd3BQFF4X2+wc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6943.eurprd04.prod.outlook.com (2603:10a6:803:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Thu, 17 Dec
 2020 01:59:13 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 01:59:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [RFC PATCH net-next 9/9] net: switchdev: delete the transaction object
Date:   Thu, 17 Dec 2020 03:58:22 +0200
Message-Id: <20201217015822.826304-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201217015822.826304-1-vladimir.oltean@nxp.com>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VE1PR08CA0028.eurprd08.prod.outlook.com
 (2603:10a6:803:104::41) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VE1PR08CA0028.eurprd08.prod.outlook.com (2603:10a6:803:104::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 01:59:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6b13ba5c-e35c-4700-2ff1-08d8a22f5a38
X-MS-TrafficTypeDiagnostic: VI1PR04MB6943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6943A690488E35A13075307AE0C40@VI1PR04MB6943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:326;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I266cp2XZ1OYComDtdTGKHUe/CreEkyKuPJQkqDAmHAuoKRfRBkOhT0UJOev7VSgv6cKCXdtfA1/ICMo4FP8dffhusnQeEvRLdWIjtvpha7WypZhGJaE0onaPOkd9qwXWtBq6X4TgTwi2tV30Zxvl1ksuOEx3qUKhrmRL3vbTll0qYKxPHCQWaWtKQENmR3T3zzFLQMn7qz/4Y/m/7BQmgTXcp98gawgzvby4tz+LATwFAFcOmedWPPKc0ClvhEQEqbCRuUm9zMS7Ekeep6oU45SxNnskZW+2JobUG2KF/4+yEUALqBL2UsnlCMVf3KhZP4FB3iBpzCgO55TVw7yWGE5enzANHcm9Z7fz5Va9ka1rO6NlUbQFyT1BLQWht/I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39850400004)(396003)(6666004)(6506007)(16526019)(478600001)(956004)(2616005)(26005)(7416002)(83380400001)(36756003)(66476007)(66556008)(110136005)(86362001)(1076003)(5660300002)(66946007)(316002)(186003)(52116002)(6486002)(54906003)(69590400008)(6512007)(44832011)(2906002)(8676002)(4326008)(8936002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pNBLgnsqWhnsmVhzsO8EvJIy2NkLqIW7/vLlWDwB2P4upqBrpf/7wBb6WPE4?=
 =?us-ascii?Q?OfxLPlI8Dfddrkc91LjhLJakdegiQajmzmcdz4gUa8FI0MHwR4KOkpZKkjL7?=
 =?us-ascii?Q?eFTv/Bu4bfwU+vu40rfQ1VDmsY/KPqeQhRNmLiBqmsIghwu0Na2YAqgsDcam?=
 =?us-ascii?Q?et7PcvC7fb2X1Rn9sWlMjoLRF5cXjLHAccsrUQrQwtIdxCtTA57zG2KCU4Oj?=
 =?us-ascii?Q?5G1lM8Ie5OMSgDlSh4QiQJNCifX/X8OntR/KGdq3JWvqrut423dGA+qD8ZVH?=
 =?us-ascii?Q?47qyO+9UvloTCOwJy3dgFiTKc+C4foDjGhMPfXrnPAGkxXtTr7FAS04C9xVo?=
 =?us-ascii?Q?RVTuUOx+lf2RbsL2aYt/I9a11VYJTq7CzApHD0+YvOFdzjJTkEe/qqFf7lyE?=
 =?us-ascii?Q?8UwWANHXJmNXEsiyKKurH1GUlk58hkLBp6mtyp4FKlQdXUAMDZEcZxb3guCz?=
 =?us-ascii?Q?ue2YPbZpR909Qd4s7B533tnuiL9wl7xO6uUVgitWeco9ZyQ99QepMk++K5rW?=
 =?us-ascii?Q?jkfonV73HujVDUujR6s5P5pOpem4fH4IfZ9rpU/uRFrKkkzvuruAjRQeaUvI?=
 =?us-ascii?Q?QFKC1ns1O3KlOp+h9y0h92jaxPi7Cxgss3bVhKsLUg4dm0AY/jq3HRWmWj9W?=
 =?us-ascii?Q?16sPsFKL0tlKX5ArxWDyBMWgsSXUICqZHLwzZONzsPDEoeitONi4jmEMEDIt?=
 =?us-ascii?Q?s0tJCDvRX0A913t1nSlhaeOY3ZXch+OWpvVk7VLYy/bObnqbd1MQCg6c+5oR?=
 =?us-ascii?Q?n3qKqzF5QCDFdUrL7FXMftrr9ufIJofke2NqG8S1GmXxyG9rMQmKAz/OyaZP?=
 =?us-ascii?Q?FO2/dn5HKA6+Z9Hm7UiNMEBVjj8Lq8LJCZuRgbyt/48AMBkotMF5hldrZWlU?=
 =?us-ascii?Q?G8YHMs/h7QC3p2lf0PKrhjL8JiJOeakF5cD+HqbaEWUSVllJeNyKAPLO2OI9?=
 =?us-ascii?Q?RdirBYr2znSmQu5ncRvqu3WxolGRJCqG3kf8mNaOxeIZfEZbHEGQYoegA1EX?=
 =?us-ascii?Q?Ev4B?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 01:59:13.2600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b13ba5c-e35c-4700-2ff1-08d8a22f5a38
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M9MmNPKozB22yuBXBq/fSj+w+cLGWo+Xi0fj5WhzmjAX0Tnbzg3neVyM1v7tO9y7HHuvwXfB3V7JpCX3EVVNJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that all users of struct switchdev_trans have been modified to do
without it, we can remove this structure and the two helpers to determine
the phase.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 2df84ffe6ba4..eb45a0bbc79f 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -16,20 +16,6 @@
 #define SWITCHDEV_F_SKIP_EOPNOTSUPP	BIT(1)
 #define SWITCHDEV_F_DEFER		BIT(2)
 
-struct switchdev_trans {
-	bool ph_prepare;
-};
-
-static inline bool switchdev_trans_ph_prepare(struct switchdev_trans *trans)
-{
-	return trans && trans->ph_prepare;
-}
-
-static inline bool switchdev_trans_ph_commit(struct switchdev_trans *trans)
-{
-	return trans && !trans->ph_prepare;
-}
-
 enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_UNDEFINED,
 	SWITCHDEV_ATTR_ID_PORT_STP_STATE,
-- 
2.25.1

