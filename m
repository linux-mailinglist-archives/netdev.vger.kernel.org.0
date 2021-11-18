Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1D94563B5
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 20:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhKRTwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 14:52:45 -0500
Received: from mail-eopbgr30118.outbound.protection.outlook.com ([40.107.3.118]:20317
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229576AbhKRTwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 14:52:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQU4+/iJduw9OhofM3uhCNax98b9bS21Z8AzXAHU0p25RsVGdwnh3hQU4EZnoOpseAqTM33EYJaxOXYMgoY7yjcjrLKqzSAmxeWQFhAa+/aQpT2hY37KothepUabjnP+cmAPvlcI3QV87QARG2eL3VrenANCIrtbBfTuYGmO5/usRr5rjJJ5jXDWiB6u0MbdiFT6vFIxJgCau1npiw67qJAz0PJR/vvZlwW4LN8U2x6hgXX5Z6UtNFad+bpNvuoptSZsxhWLefbIUlHQnRnCmIJOeFV1yOf9bBV4B9d1ubw9HS/pNfMnq3r5n0OAVCVwvIlGYtXn3EvQgpq+ybyspw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cF8iwrXyNmE1UFj4K6VYkQnLP0t9H3DEDqumeoxSBv4=;
 b=UPHAJGsdrVAAWhxuAyT/orDAsW9oUi1f1+alRuNXWmMcPcSiJ0Z0HSdUvTc/uR74q3S5FvGQ2YhWrVNzeNDPbswAMECHdkwselsj294NGzJBuo0wMj81A4VPW+GMWhNiQP3fafcMEudj2lICihvc59xtYZB2w4OVuNr7yCCmeIAfZw44HczW6oca7Ux2cECnytFrBr7aiHAGbo5b19D71sTcgUl2IAHzg8AjCSLaV1FctuLj8ufpkVShXy6xDEPE1RX4PQbp7Cc2yvyms3UDcVm/hsHZN1KCIQ9phrpjtVZQ1F0CRttdgLyr7Gn1rsvfeK4GKT4C45M9AFBpOJG58w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cF8iwrXyNmE1UFj4K6VYkQnLP0t9H3DEDqumeoxSBv4=;
 b=XYb4V5M/82w/DjpojLnI+b05s5koXPOnPBsF+/fjknjPdf4j8YIOCvS285NwF/QPweXYhJrvbKWNg2GGTtCIJlQFiWlYxpmNLNOMywtXXx3lXaiS54MJGcrd7LgGKiwqR9N7zV5ZvB/68dJyct8tUomzV6yWXMXhiLLdQrxdTqY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0432.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:3a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Thu, 18 Nov
 2021 19:49:11 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f%6]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 19:49:11 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org, vladimir.oltean@nxp.com
Cc:     ioana.ciornei@nxp.com, mickeyr@marvell.com,
        serhiy.pshyk@plvision.eu, taras.chornyi@plvision.eu,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: marvell: prestera: fix brige port operation
Date:   Thu, 18 Nov 2021 21:48:03 +0200
Message-Id: <1637264883-24561-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0047.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::24) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by AM6P195CA0047.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 19:49:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d753de5-da30-41ed-da3d-08d9aacc7dda
X-MS-TrafficTypeDiagnostic: VI1P190MB0432:
X-Microsoft-Antispam-PRVS: <VI1P190MB04326E72043AE620C36EB9568F9B9@VI1P190MB0432.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bgaMiwOXuM2PQ+O80sA0LZH43m/DLz+EN+VvXVf1wwesk3uPAustG2gehp1rIWmefrYTtNKyCPD/pl/EcG/EmohPpt9/lc/xRCXwMgYmjaapbBJeHIg4M2ndLRX1It47lpeX1iDMc6gQDQ6LsLfPqIdmiBmN2E/dvpqiHqb0OSXEv0rKbpU2SgvDrtIvqIkZvRbbyRD28dU9ZI2IW3tv6uslC7xuGHygLZZgscxvYPClPdMcP5g8H5S3KQspWT25T1Arm6M2uHlmQ+pM0i5pSldYSJLBo78JNg+HmU63BphIFg7vOGkceUbxdRZrX2OE2jPQyzAnwVqyuOd0lBSkuECTexo7foOiLxTVqTfStDVAK+rBqjNo0A7w1nbSY4VDjgqvJls0Sbe5aH0wYZ3tbZlE8vxN9aFj9lJ5X/4ELf0TmNltGHTbbio+EvwAfhQCReRtft61jWoqva74I+Ugghbp6RX8ffKn4sUuV2rqkHqF42bJd1TBC7tgAdf4sVMQc2vrFX8cLQ/mg4Ncp6qCRtzXOFfvnxHR/IpofYnOwpaMzb33cGxNp1bBc37ske84dbxWLsQ8mqvp0zra2rOyo/NVatxrmtD7eGJdvU9C2ETt1bHDS1akHWOrI4aFBXXbrvofCN+ObBpvZYa3hFHbdVHujhEnJQoAcbsOfEyjAUWkliWF76aw1O+MwE0U2T0B3eQqY9iP6mj5TG6XubaOOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39830400003)(396003)(2906002)(6512007)(52116002)(6666004)(8936002)(66556008)(86362001)(38350700002)(38100700002)(66476007)(44832011)(316002)(4326008)(186003)(83380400001)(5660300002)(2616005)(26005)(6506007)(54906003)(956004)(8676002)(66946007)(508600001)(36756003)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vAICLmZON1cxApYWmBuI8MtXDRvXarUG5/VpO481F3ACpxAs+Hfui9IrGUVw?=
 =?us-ascii?Q?cM8eZoPDLhiQDjjffDdmywuAvoo0P5VrTn4/qHKgwKOVJbYx8uB+OCYudP+N?=
 =?us-ascii?Q?yr+8uOjD/axBLcJNsAjI+/Yx4ya3T199WHpqRIm4ai05Jsd+uTt56b9Ktvwd?=
 =?us-ascii?Q?SWvZG4H/NPLcH73hQFYEugw1u2vZl+JNo7N6EjBdcpa5nfDGbJqGL8T64wAj?=
 =?us-ascii?Q?M3WNdeKO+QMATgTVuOgyBNJ3UQ9EEZHyMsB8OUmtHLdVWuckVAyF+v8wFQ7l?=
 =?us-ascii?Q?xTkmZgCTxdR4Ds38iBhJwG0ijIcHWPDm+rxDiN2W4ZqHIYEzxuTL5nmz7FLK?=
 =?us-ascii?Q?0On/6bIBomWhOd7dJj4xNfcXV9UKHdpaQRm2fjLfam1RopwkH03zO/EW2srI?=
 =?us-ascii?Q?30UNfqLzanioLarWh7jatkf48hp2OqR+sqevBegJmJrEwpamUmCbsZnenQjl?=
 =?us-ascii?Q?PISeInvNUjZUSFYTPAn35sIHnM8PZOjSYVBg+9Gtq0QXcMUcMEeesbVb3moF?=
 =?us-ascii?Q?aGq8+1AH4RdJHdluQXrsAHolEKMAg946w4TaYM27Z6lWmJSqywBOfaWSVOEF?=
 =?us-ascii?Q?YlcMadHNjFxUnzZnOvjSAv9JR4L/ESRJ2/3evC/FQANINy63KelCm8IH05q6?=
 =?us-ascii?Q?SCyPfEUN9DWKQf4cQyFAYEJzUJJZ6zepcDWB3zm/6nUfo9dAakobW1ufG9J3?=
 =?us-ascii?Q?WASAh0rxfXWbmGCp3k51tnaKpYPATsyvrPLd3gD6rvpLxV2nZ9juhoWZZXOe?=
 =?us-ascii?Q?gMI1Oq62JFzLICk/2/HRUx7peP5IXioXkRzn23t0nK3SbVE9u6opI2yqfMy+?=
 =?us-ascii?Q?GuL1xNVMySSs7Hm8J2YKuVl8bosyvBI0ULRvJ7rXpiI7WQB6N5ZChUHfWZ89?=
 =?us-ascii?Q?gT0wbvesKCRCmmqNZ9XTNFlYF9VabUWlTwx6fOuT2lCDMJcwt5i99mHjDGFF?=
 =?us-ascii?Q?yopMmyE0B9vMXKE7I21t59IXffj/8t4R4LHqcI3l42wUVkV8UnLaC1p5qbnj?=
 =?us-ascii?Q?aqRl6lRmdspASD9cscappvNNaevsbNIUoX1WePZ/4MAU6UpDEbr1DyySinuc?=
 =?us-ascii?Q?6YayLPhBH29TfTFx+qq6P18dmiZqup9c3m/b991UERZW6iOkQZ6sieIlbGcj?=
 =?us-ascii?Q?orLZdLS/PjwixPdg229Jv7fEDFN+MAxgu/yDZRqtm2YvDz7UyKVl6OdsOFV4?=
 =?us-ascii?Q?8SpnXUKo9lkFhTGdKCucduRwpvBvmS4g8XSsmJYT/CLsjHH6567CrXPUJ9K1?=
 =?us-ascii?Q?XZ+Gtt6jlL9Zo4YXc6yCusxLK/VOfRooqS+Bk8fQCJt24Rn3eNE3NBDCyS9q?=
 =?us-ascii?Q?yB31EFh8TPN9B83oYBsPE7SJuXlfl041zA1YhwbwC68x+b42vrWdDXddRYci?=
 =?us-ascii?Q?+LlTI7dbphPXZ5vfo2cSr3BiVs7wjnV01AdOC17OIvNiYBYtP3XicxIDKACk?=
 =?us-ascii?Q?ZRX+9CMMQ++agtIvDPu+PWIBcNqwlvVPR/NBsBpNfM+Y3XGR+Zms/0folmgq?=
 =?us-ascii?Q?OOI0HiWlH67Cpy/GXlU3E365zn16f/dxDMIS3keY8wo1jwFtJl1x1x8z9P0q?=
 =?us-ascii?Q?5SaiyByE6uxbjgGZVZPj/jONQmTAdujchUA0+koUHTzIxVd/x246rAO57KOh?=
 =?us-ascii?Q?6gWFYH9g3LoXjjstITFyj/4EpfcP4lSKjGOGE9YkQIkU23SdNlQxQw/Oiu8l?=
 =?us-ascii?Q?Va8Gzw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d753de5-da30-41ed-da3d-08d9aacc7dda
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 19:49:11.2664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZCC/8u6VFNMUPBw4DUKxQ6iaqmS85ymRJDZbITc6f7EvbGuG+4ApDTAFhubtQCG6bnr69NAJr0ivT23ycNGVIO/FILiKChhS6SZFHbllCs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0432
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

Return NOTIFY_DONE (dont't care) for switchdev notifications
that prestera driver don't know how to handle them.

With introduction of SWITCHDEV_BRPORT_[UN]OFFLOADED switchdev
events, the driver rejects adding swport to bridge operation
which is handled by prestera_bridge_port_join() func. The root
cause of this is that prestera driver returns error (EOPNOTSUPP)
in prestera_switchdev_blk_event() handler for unknown swdev
events. This causes switchdev_bridge_port_offload() to fail
when adding port to bridge in prestera_bridge_port_join().

Fixes: 957e2235e526 ("net: make switchdev_bridge_port_{,unoffload} loosely coupled with the bridge")
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---

Changes in V2:
 - Split changes into two independent commits:
   - fix prestera_switchdev_blk_event() handler (THIS PATCH)
   - fix error path handling in prestera_bridge_port_join() (NEW)
 - Updated fix tags in both patches according to review comments
 - Fix commit messages in both patches

 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 3ce6ccd0f539..79f2fca0d412 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -1124,7 +1124,7 @@ static int prestera_switchdev_blk_event(struct notifier_block *unused,
 						     prestera_port_obj_attr_set);
 		break;
 	default:
-		err = -EOPNOTSUPP;
+		return NOTIFY_DONE;
 	}
 
 	return notifier_from_errno(err);
-- 
2.7.4

