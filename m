Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E16C3CE82B
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352948AbhGSQig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:38:36 -0400
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:25006
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355023AbhGSQfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 12:35:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJJlisG3Yw6ou7LsKXTkTO9g/M2pzDXJ2AzKM6B7Ov5adaojYPAca/GkZzMFwxESLEyHk18/x/1ECKbhr8Nl+bE1fv5KkoJv1l40zI3HGed+t9tPIll1qBdrQJWV8H4pnzjxqrEUylYs+1daf5SbxcJDi3UsH/dweeLm9mHobCAS3Gyb2unBATa7ZOitybTPwVmDmYmFqJ0GP82BxMdFP3NMRoX06axo0OyCONoZ/Z8WOiApi+hDNOxMxl1ZX/Q46EDlAf/QYKGEpmFUzVsBmIsjF+pH4wvRjbbN31kC36SBEH6gHXKGQe3UBoz6L1Re7zbI/PWWQ10RGkF5R7cdtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wp2DAv5cDaOpWWhhapL7khhT8pdJNUjQMjebbi+nG0=;
 b=hJk86P2Gx9aUsa5TGLeOyMQWeyRFmNTv0MZOWqxU/mayXbncEUv70aHzLmqpAcGfz8ewAZCQ+8rM4DtA+ufVW6NxMkiSdBOM4DZAX5AR0HWeseFpfkDDHbI5W2Woso0i5XxUzrTigPaWZbNXajbKMpG6y2jKW2C6fiUNXn/OmYmL/uoSOdif5BzA8Et95vpiAf8y0Darkf2N7pS+7s4PwTDF7BX+kGiYRCXwEdQFYhT5Kng+qvoG/PQB8w3NTkeoIPEuXxJCLDbfXxES001xzt76dStDup3xMcBuoaT5RSY53DcMQTDbDQVrjgjnhGD4XO+8ftOkyokhzvzPM/xA+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wp2DAv5cDaOpWWhhapL7khhT8pdJNUjQMjebbi+nG0=;
 b=b831CSGdQPghCOdb2Qhr6PuXKK8vRAeJ7rYGkwsfBqx5JBFSIhd9bqk3Oy8IxYfqXLAhmIMkdEiEiHf7FmYpv3Pv80s2huPBKIz8OVo1Jx22JF6ws7oQlKPuBXZOevHCcVAKqs6ofRJlcYNLjiW/XGvEbfCRnM1vcuDf+bw0DEU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 17:16:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 17:16:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 04/11] net: dsa: tag_8021q: remove struct packet_type declaration
Date:   Mon, 19 Jul 2021 20:14:45 +0300
Message-Id: <20210719171452.463775-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210719171452.463775-1-vladimir.oltean@nxp.com>
References: <20210719171452.463775-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 17:16:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87f6b08b-d5a3-4fdd-18b6-08d94ad8e569
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34076EDACD9497C9C7459D04E0E19@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:345;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 039jzsV0FtFgK+pQoTmF3A/pNWhtuQ0K3XmdwbXIKfHfrBaDrT+WER0NUVisD6QGaV60k4gsCdjs0DVl8JdjC5ybNkB/4ivoLZ0VqVHY7fM6CA+RuoA8182JuQj+8HefWqBsUAN1t0griKxt654wG18CczVgKjDOecq+QqZhMVq4UrkXhsMdw/29Jy6AFenDwRbqRZ4p+Xx2ixGXIYXOEKq2OG8KpnQZFicItPLWC5rcnR/6/DBw3kQCU8GPr6tvzCvpPpowGJfSi+6CDuQajMxjFT8T9UR4pAIptJ4PgDYZMV0zrDgljCZJGX4HpDqj9lDgGN5FTaN2Sstm0QelVgnqiZ4R0DdEesINvuWnUqOB1i/E2bgf1FtlFnFcEXQ1wMzeblAfkmnL/RoauO7VmPtCf3N1SfAUhSWW5aN6cv0zkzqgYtkHeFdNoH+ZCZPPHo1Og9RyXwWitnJvVW4rYfa0XGM/6aYKOoUtgTyhq79ngoAhgWcoLsqMII5SRJwkcurikrq2SeFCZX9/eVpwQRIqiABUtvdp5KNVup3m/j4LGaClsNDNFn9Pb+hhbm/iKs+NtMNMMXs+2B/lKjvdpbKdpnE3Tdrn76q0KhtX0c7Eie/tWOZVcBmAiNU9Uq7iqi9tRYve8kUiB7c7Kgp5565EkmNdvRS5gxpVuyZChATjqNmBceb6Ze80FHhTDT7g29qV2VdczpztSwCxQPrPAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(136003)(346002)(376002)(6666004)(6512007)(86362001)(36756003)(52116002)(8676002)(4744005)(8936002)(6506007)(83380400001)(316002)(5660300002)(66476007)(4326008)(66946007)(66556008)(110136005)(2616005)(956004)(1076003)(6486002)(54906003)(38350700002)(478600001)(38100700002)(186003)(44832011)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z9JyEnlehUQWqZglxHUc3f31tDYxxUdx/bLJ/JUbpHLpwQOvoH+e7S+iQpbB?=
 =?us-ascii?Q?KkUoRBHvMYW8hMfCcrviO5u17a8GcVzajjkSG268IMazkODhaHULXbSe23AT?=
 =?us-ascii?Q?CdMPvK5oIwywQCbSdjRTBKgj9lcZtBsOwrutzqajh9P3cwnVxfcqKnk5+Tzv?=
 =?us-ascii?Q?MMnBbTj2qetj9JzodmICwcicJl147AEJ0jHicSqipClq8bFeAgrGZjC08uRp?=
 =?us-ascii?Q?8FA/Yrn8m2sl2cayRBw792sqWOnxknhSdMYn3+On8FueMbaWGr4Oa6yhDVqY?=
 =?us-ascii?Q?ZKtY0IjYIkgZTwJG+SeCllUMHdC5oid/4OygzjOZsPMyt8ZchdOuAGJp6ACn?=
 =?us-ascii?Q?5igx8DBrCzVSSZg+SILn0Z30YjABGs0eoc/RKoB/ehZxwHEkNrKLIHIgvZ1g?=
 =?us-ascii?Q?aHgiXk5UYSwIYgiuvMSTcB14hO6cved2VfQ5ysNRRSTqSuA4mGP7F5Embn2p?=
 =?us-ascii?Q?ylpPgb4xptJi9M873KtAsuAllylsr8wouPDZRgO4MWiawK61ktGmNwDija/O?=
 =?us-ascii?Q?jcfHfzxZc4+Gvc8Sb/8OtM/0r76HtfbaGk9FES9meoQxtGgHRjxp0sUFYeam?=
 =?us-ascii?Q?CuehAZ007e9TaAHX50TDlH8L1cSyBi4TyFwliKgMJAgU2TKGmj6hGbGU9j3T?=
 =?us-ascii?Q?NyRwLZAD7CZc/hphudPuiNM6FCzz6OpoOlSvwkYB7/wDrmpTkQEjCWq30acA?=
 =?us-ascii?Q?mFoEv7W3ZoZHY2ppvbKAlKezVSGRCglrY2FvMRnmHqVWbDGxoi83QYBXKOWU?=
 =?us-ascii?Q?iSasInNG8C7bMwA0eb0vrqZGc3kddWCwDegeeUFeXaa8zf2XnVP1+inS28WI?=
 =?us-ascii?Q?3oOHoMbhUXGbTIrHDeqJo2jF0+3UIJeYry6Wac0WCVrrqXJMe9BnWug6W8Io?=
 =?us-ascii?Q?UajnU9rLNjBWZgsTrZBcE1PYgGNWxIgu25MRx8/JU/6zgYz2dVtdgekvJUUh?=
 =?us-ascii?Q?6SdpXtDxbzrBn+ze9jaFU0U3exsElyytTiVH1gaqpzPVXSaaS9iNGqevx5Ex?=
 =?us-ascii?Q?52uxiCDWxF9crnoBXCnuGBdpX2jAqxZUfDqOd085PMj0jlCnIoNV4MTA7KjY?=
 =?us-ascii?Q?y/wIVxwxyFt2pYwagdTb8cAy/cd61EuWX7gVJrnwT19P+b5qw2cZXFGWFqmZ?=
 =?us-ascii?Q?5rNBpQHyRR5JVdRzYWIzX7QKBrDmlqS7wS36/Ww27ZfVlFTwGb91Vp1W87P0?=
 =?us-ascii?Q?MwuDfP4X4UmKp/NcETywvoKQak2a8+4BBmd+/kbWnRuHjF5rIEtmrEc4qAI8?=
 =?us-ascii?Q?jaD3rSwl842LxrMe+Utpzr4HX2oKLA202huuntlVyTb7XfrJhkx0ZF6qRs+Q?=
 =?us-ascii?Q?NJ+ZhDIDFFwOXLQJTsnuBo17?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f6b08b-d5a3-4fdd-18b6-08d94ad8e569
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 17:16:07.3886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CKLn4tGhc9Ym/6qHIirMIhCeUVkL9NpUtXsYwnd8Q5XmTfqu24JjguYaX7OLa0qcQBT9VAVYcGXOVspNBS+i3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is no longer necessary since tag_8021q doesn't register itself as a
full-blown tagger anymore.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/dsa/8021q.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 608607f904a5..5f01dea7d5b6 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -11,7 +11,6 @@
 struct dsa_switch;
 struct sk_buff;
 struct net_device;
-struct packet_type;
 struct dsa_8021q_context;
 
 struct dsa_8021q_crosschip_link {
-- 
2.25.1

