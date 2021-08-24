Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141003F5D41
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 13:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbhHXLmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 07:42:25 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:43248
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236803AbhHXLmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 07:42:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U53a8pmtLg5EH5gDCnv3yuJK1r9TCCXXEc2wJGhzxUuvhxk4q+xOABN7FUDg41lN7cw0dpIaBD/qi+UhWkEtxke5k915QsUfz4sVkGmjI/MA0stkU8R2n+1ZGuMh/TejhyJUXXTb9Va1ejj6r7KveZR7c7BCCsEluzVyVpQMdECvo2G0oxD6E2N2jPUZsPFpUUYXF2aJ/Xx08Dakq/UBxpYzNS3qGkgQGScwBP7EtWCTsX3eTC3zWSxYHOK1mf3GedHMDNnx/hwLc0Jw4uLYLGNVl6m5fsEoje9MNuQ9Tmsqh5PlyAV1k+C++ZwMQHkYOztWpP3veeXjvYyCjZwmLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1MLoEG/rnDqVFrRVQuKAgy3tKTMZTYxjQ2iWsAUtwgw=;
 b=ZUWOhinC2e3D1a7u1M8NI0C9VOFkwfqJ4ZO7FCPOtct0HcZtO8V6Av9lvQsaQnOeIjjfqaQjPfa4qjBwj25VftmZswv/SK5IwUTdcgt2Skf6ZjGUOjvkNF7WQyp+FpeY1lBmijDnFTed5nAl95WRWwvSm1j13ejrEhzkAyogAGgqB+zP76rtEmPa/oVszXkMqVXGgl6R9GDHrMTFH/o/YTC29QuT2L4in7ZVWFwZ7SJWLtO4lMYo6j+M8TvWelCMs9axMRDuPKeVu8FKpWa2pM0/ufTD0ZYWQBSBee0pLUp4rL4aChuwM+0KjcDPTeWMtCHiD2D4RrKDdrnqGr1pyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1MLoEG/rnDqVFrRVQuKAgy3tKTMZTYxjQ2iWsAUtwgw=;
 b=qx21YIy4+9svLSmublr0VNwH/Xy/UWlxcWNObGB1+FerT1IDsCxi04FWqwsYAtXkbn8mnrex49ZfX4x4mU73OHgPWZvm8r/k45Svvucpkf3qSh8+N5cbE+cBVXAQ/C39B5VCM5AIjl4upG/w/4JnrxnB+2IsKosDZwwz2hxlShA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 11:41:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 11:41:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [RFC PATCH net-next 5/8] net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
Date:   Tue, 24 Aug 2021 14:40:46 +0300
Message-Id: <20210824114049.3814660-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
References: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 11:41:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c95c00a-84b0-4e76-7115-08d966f41832
X-MS-TrafficTypeDiagnostic: VI1PR04MB5696:
X-Microsoft-Antispam-PRVS: <VI1PR04MB56966AD27494435BFC1B99D3E0C59@VI1PR04MB5696.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q3ieuOD15rLjv8GNVwC0WbdX1tbW/KXlrqdq/NYmXDy2b5b9IRMUAelf/uHWJE2nfCJJYh745ji+wUyldd+miUS0i4ggIgAZNxxr+WZXITOlTDFOJlEeKeVeRVZqD6fMEd/PK36B57qxIs2nVuW8ZQe2mz+CVy12jZUYPZuZbxUegNN9iUyppRC05oCzJVSMJRy58uYtSdgyrun0THyQSetldPkgbwJfCrofrPtuH+YbrwoCMGFCeOBzLbcxQ/JL2CNFDPw+ertFpiTXJ3xcfTIBfi0VY3+D1VGXbgetx7Po0ufLJsa46Dg1SYC+1JDP+7ZDhAkdLQ0jgANNGBvKxWxGzWD+qJrg5+2/SZPzhWJmorRs9ZNx5Mc5pBvFjM8rK3HcaI+MDdGDskOP41KNOxdWMaz1p70VS88JbGftvj0LawRoZoVhpI4ylc3xgPVsxhp+D2STv5LpH8/z+J7TqFsEyQu+/92UvEXzd8Gvfa1XdILATleOYrybi8AyZBT4FpW3VCeCec+0hshHSMCi08xIGKmQ/D3b51FFcWbpD8yzevP99L+0+gPwOS9s5m6s6zjCbjCZZhTUp6e2ExTJ7hs6jFM0f2Cl8yoSdZcEu8DifLry7mUVgAAva3mPtST8yG1R4yU5YgDNA9Kvy9BnnLHyC4hDHB4rAIrN5f2cy6qSIEShSBUhRM//IXC4Tulh2j/XpV/VKftF9sWAFI3Nbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39850400004)(376002)(52116002)(4326008)(478600001)(5660300002)(6916009)(66476007)(66556008)(26005)(83380400001)(1076003)(36756003)(66946007)(6486002)(6666004)(6512007)(7416002)(6506007)(186003)(8676002)(8936002)(2616005)(86362001)(44832011)(38100700002)(38350700002)(956004)(2906002)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?48Qjl3ZBzyZQRFJXaNWyCRHIc8H6wqhwKJqk8FUhY4WxHhn647ka3Wz/fX5Z?=
 =?us-ascii?Q?ckjeu7mGmwJLZZIRsIB6TDyExcik1yUuco58A6SGz18NGAFPJ46rpuiuX79c?=
 =?us-ascii?Q?TJE6UOmzpUUWtPEMWb486Y/XmpM8DJBpXZQC0lpcjuab8GfD3H5A2iGm/0Om?=
 =?us-ascii?Q?37ckk/MbEzdliCySNf3uTPCc0q/CNbOaVrDhVCdgyFdIdexd7DJe/k7MO9xO?=
 =?us-ascii?Q?t9dykhoy6crcpp4m6mFkihRLrAuRE+f8NoDmWPNfrFk6UZeU/KBTLQtXEfHb?=
 =?us-ascii?Q?B0YQkVDyUCJrBMCnyrfkQZK0WCwqk8ZC7+dhW9bJMFuG9VGajOH2YM0EntYm?=
 =?us-ascii?Q?33QMgbrbBbrv/2kpkWvcHRfsh1lpsYNTPXsGMonpVwCpahRmMXNXYwcgwzZC?=
 =?us-ascii?Q?MX/WSEbMfyn3kgbUqPksywNSwexN57KS9h7FOLRcrMY9us1fRnojes0CDP4V?=
 =?us-ascii?Q?IzoDJH0k8TDnl29qvW57BlpHz1X1NeL2qD3ZXsqHIiwKJnqK7GesRKFz0C5E?=
 =?us-ascii?Q?j3kmNVLkbJ/ZUTcZxL2n61tT65gnQVGtPC+L+Cbyr/xiKpQbljF7r1WH5LHu?=
 =?us-ascii?Q?0GrE3JcipAurSIw6ftNeBs+a4I8m54QjxjtWQHYlPotQitd8skDKrzWhovbN?=
 =?us-ascii?Q?Ce0eUTvx3YXW/T9fDtM6wTpY5OLoJ/FYpyX4Tlf01jjZsAzimbzxfKa+2Lbf?=
 =?us-ascii?Q?Mnp+QEZArxM8yJqN+IhPFMCUmqkgb21E2JVfAoiaohdzweklo7zzJmIxt9Gc?=
 =?us-ascii?Q?hTYEpiHhBYvAuyXHTqOSy8k7c/QgaO9YczUbROwCfIJc4z3xBIIjklwnknwR?=
 =?us-ascii?Q?YP22kUjIZLY6FE1vgBFsRfuILXsrU9k6o3QJ3BgDBO+1zvUV7nAGADr1IiXk?=
 =?us-ascii?Q?g4mqa8P20DetuXjF1k6MekhzcK2phZbJfrMtcKDzL16AiqLegQM7XauQQj+A?=
 =?us-ascii?Q?cpQfM9qvMqxD0vsgByRzbVWzZ+zKqvnRXQSAxR4EjaXylZVTpeajB2azBqYh?=
 =?us-ascii?Q?67tQGoa55wsipz5OkRHZKXfiCIfj6RUZ2Z3mvMj+P8oh+7Hmtw2gw0wGJ+XX?=
 =?us-ascii?Q?uxjqdmofIzziqAAQ1mEcl9CE5A6igScXSz37zAk3BcB7eBlwcHw3YHYMUXRT?=
 =?us-ascii?Q?W16jnO5vr1oUpSW1aWEOcgLpjWoxVocIVMMkOW/PFS+ZJySvNUDHFzc8ug/p?=
 =?us-ascii?Q?hpYxtFKLlkHotWad4uVlEYtn58lOdFKudPAiqn3ePxK71Nzfzg69aXXjLJBK?=
 =?us-ascii?Q?8BEGCKYV46lM2AhS9yShrClQ+CLsWPYZTc9j00qRv2sAHLqNSv5okWSdnQkP?=
 =?us-ascii?Q?G854MiwcXKb9TNMSKKMUsL5D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c95c00a-84b0-4e76-7115-08d966f41832
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 11:41:21.4867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x5uoLMkB4eTfCAcRllI9TYEFvUAgCCDtuDrDP/BcQbk29rL+IW0KkJKeg8T3sDcK2gRin3qEYqqZmpNZWEzObw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After talking with Ido Schimmel, it became clear that rtnl_lock is not
actually required for anything that is done inside the
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE deferred work handlers.

The reason why it was probably added by Arkadi Sharshevsky in commit
c9eb3e0f8701 ("net: dsa: Add support for learning FDB through
notification") was to offer the same locking/serialization guarantees as
.ndo_fdb_{add,del} and avoid reworking any drivers.

DSA has implemented .ndo_fdb_add and .ndo_fdb_del until commit
b117e1e8a86d ("net: dsa: delete dsa_legacy_fdb_add and
dsa_legacy_fdb_del") - that is to say, until fairly recently.

But those methods have been deleted, so now we are free to drop the
rtnl_lock as well.

Note that exposing DSA switch drivers to an unlocked method which was
previously serialized by the rtnl_mutex is a potentially dangerous
affair. Driver writers couldn't ensure that their internal locking
scheme does the right thing even if they wanted.

We could err on the side of paranoia and introduce a switch-wide lock
inside the DSA framework, but that seems way overreaching. Instead, we
could check as many drivers for regressions as we can, fix those first,
then let this change go in once it is assumed to be fairly safe.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 662ff531d4e2..53394fb43d67 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2381,7 +2381,6 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 	dp = dsa_to_port(ds, switchdev_work->port);
 
-	rtnl_lock();
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 		if (switchdev_work->host_addr)
@@ -2416,7 +2415,6 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 		break;
 	}
-	rtnl_unlock();
 
 	dev_put(switchdev_work->dev);
 	kfree(switchdev_work);
-- 
2.25.1

