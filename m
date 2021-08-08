Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFDE3E3A74
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 15:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhHHN3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 09:29:11 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.7]:53602 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229923AbhHHN3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 09:29:09 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04lp2056.outbound.protection.outlook.com [104.47.12.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AE8A980026;
        Sun,  8 Aug 2021 13:28:48 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E02755v8TQUFQeh9elNW58zMg/7n0NZiJYOIsr7twvNMS+Swb5QnQ1lEQdS244K3mApzuN6Ac2lOKlSneu7FxFossxdEg00Z15c4gM5JFx6AvXn516D3jeYrqJxqZgKwU6gHfYb2h6KymmJnqA+uri5XQqfC4QX1fVMiS6bvefS9BAYb90Pk9JWfWQ01rQ5p0ntK4b3JtUg27oL7CWW/SBojbaeos1lqv9fv9vNvRgBrhg4Ky8iyVSe1UoAUS6/3jOSRE4ifn1dy3rhoHNW8mqfNCicm54GSRPXkflfWCoKKOwwSg9p0qWUqG3P6fJOTzOxyHVJ8rtd6kSgVS/esuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfaW8NdaBk7J0829JeqFA1GU4kCNQssZifohenExx4Q=;
 b=K4OMJu9ZSOIkD5GDD9sFL9js5dBGOKMCK51VXAFRQaA0gO1nTVty927lUvwHG7Rr2r1E2Hbtmndo+KLaqSn7tHg7Nqz+3ic9JTLXq8EbysIZCF8voyAN8a5171fvBh0/7/dTn/m/PRm3je/2B08wQWU4fI/YcBo6miNBY8Nx6d4427nqWa11sODXuqNAm5vhojO1ExT42WmodUxm9OikGiqewERwRtvh7uphtU2gvpU/+KW0LQ6QyeBUzUKkP77b0FC1gjo41i9bkKjnLezuXWCYdL0Taz5oDEywicvZMVXiVl1ROCKVLs7ZiUKIXA3MzlvkMWDJQ6v7w2krQ8xaWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfaW8NdaBk7J0829JeqFA1GU4kCNQssZifohenExx4Q=;
 b=qMPOR3WQwe114jeegDd4o1uqhTEBxQ2cGgkMA1Uq8I6Y+TpNLVgt73h/U8XjI9DmqNLY+bld1weoNhUH9+9WnZqfqmQ8V0kCdPCcVOzfEwk80yN925eacK83fxlfQwqByyRgFHvQcuHyoaEKOw0ZV2q32WVg2O7EDfywXvYglUQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (20.177.58.151) by
 VE1PR08MB5726.eurprd08.prod.outlook.com (20.181.180.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.15; Sun, 8 Aug 2021 13:28:47 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b%6]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 13:28:47 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [PATCH] net: Support filtering interfaces on no master
Date:   Sun,  8 Aug 2021 13:28:36 +0000
Message-Id: <20210808132836.1552870-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0059.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::23) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (199.203.244.232) by LO2P123CA0059.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sun, 8 Aug 2021 13:28:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6edd44ce-6814-4fae-7528-08d95a70737d
X-MS-TrafficTypeDiagnostic: VE1PR08MB5726:
X-Microsoft-Antispam-PRVS: <VE1PR08MB5726361F802C04338DF41850CCF59@VE1PR08MB5726.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FQSCycglsovQlxoezIqlW6bBJVs/wDs6STKQw6UvYQh5moyHlnRAZG2pLpAjh3RW4urcB/YTg10yovsJKk4I2Q3v+juWVHQ+OINrJcvW3aSWGyE3YdMb3vUzXSJS8srdcI8ovUHLh//o3v9CEnFVZ5f9GbshIMNQqzxuy9WYJEKtctgdDOmO2asNH1Cwc1cbX8C/WLgTBwQgQI1LCfp1U417paxmBN0OSdOh+qoXMEZ25vg+xVCLplaC6eRvy4JQSE33Qxicd2VIcX/jexoygBOHPuCh7wgcdtISCHCqVYtME9mRFI+fI4RaGjB4rEAJexdZQ6kOCQeM5J0JlKYXVjo21mehlr58GGj0nWunqSMP+yOKEwvO6XO//rgKldlevI6exk6fyLaKW4BUs7CAmD5fgXi+0iTYxBzJFMTJ9qEvx2AQppSxNuJZHrQrp8sQkrc08TqBpb1uneqEymyxR2hSyL7zKHLTq1Uf+//YadWaMcnDASCPJxc+sk2MgtAhx5gRCinyBOsDGsvaAoZFu42r3P4WIMB6j5cvUEzTkLRJyk3eg+FD8EXldikeibGRE+95NW7FDvZcMFCenPrhapoKqkmamU5QJTQ8Ugnd5ZZgCBi6XYAJ1t343FcHr+UqhU22BhgTpp0mnqvJBn3lHH7IDITxDaU6AMwLHkRTbUJs6uCs8szLDpIid24qSGy4tHrrzxhUfGfRRJpJX3KEDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39840400004)(376002)(396003)(136003)(366004)(186003)(4326008)(8676002)(6512007)(36756003)(6666004)(26005)(8936002)(5660300002)(6916009)(1076003)(66946007)(6486002)(316002)(2906002)(86362001)(66476007)(478600001)(6506007)(38100700002)(38350700002)(2616005)(956004)(66556008)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hVczhiCSn3uvJyNJxve+6iR19t98PHDINqF68J+kFT6vAdJEJbanXJUGgXM2?=
 =?us-ascii?Q?wM/jju2vXVolGrMXWxTj5xFZrDWKiA6L+PFnwiQ8gyr4lj3y+EAIS/CTosDs?=
 =?us-ascii?Q?Py0IG05yTzuqClyuRf4ky9YOMyI0WmB0uspmBxwJZ4bQ5dI1+iq0RdSwH/cA?=
 =?us-ascii?Q?GCSDmanAmFFMi8aAMk0WRdozVog6lFQs2bN3/4hMGv3WuFKEPPfXtUB1Zh1S?=
 =?us-ascii?Q?fr5D4boLJ6rgZDKdRBr9P8b7LXKNXcG9aD/Cyk8HCCzTvYbLnpPHMLqnj1EB?=
 =?us-ascii?Q?34ewZKElN7CZq5KR45+NwsWGzxG1IDcUjvB6M2Ow12ZbwDtQEGwsDurDGkAK?=
 =?us-ascii?Q?ER2rm4KcqWiYV+W8TQvNKfTxf9I9llaTt8uLhIVpMKUXMyFUHjzKKB7KB+Uc?=
 =?us-ascii?Q?w6mHXSWfoVoxgzNT4+049su9ArNePTnobSaGF+ccWME9lwLpGRjdC/2I31in?=
 =?us-ascii?Q?MxRKPAsBptqvVOuM278t4oZ7bb1H4fq2CFhKGBLXC884W3mTSpyiCB4/Gp3l?=
 =?us-ascii?Q?bbj36HUbs6mUR6Qrp1VPijBtfDo25HxcWXvV6sKeZFcAiaTsqD9Rc65m6r50?=
 =?us-ascii?Q?JcXlE73pjDULMZlX4x/NYoUqRP9OdavoDUcUMHcLeQocY+XOzWFk+37cECNR?=
 =?us-ascii?Q?hZ+kSx/ugWWrY8t5AqsuU+94CpTcP3K9JFBMWc1OX3/Bg3rsBZbNTiij4CnB?=
 =?us-ascii?Q?6frFMUUjq8qD7fO9cIArGs9rA8gwcl8OMbB/e1tFVQrhG6p4QyIg1ReQK/LB?=
 =?us-ascii?Q?mSoF/KaNn9u2QXBfyG6eySs8xgqPoMNzWMwvMxcVZ2TfZ3uIPPHZrWp/Vnrj?=
 =?us-ascii?Q?H5kIOSsCIiS9qSFdVxcKzDLtLPy6H015+rh6fGDDn62EHxDkHOUVVkt+VcnO?=
 =?us-ascii?Q?ipObhQ9ASBrmu+cGbmfgOdFazf62/iH+9JMavlPlmH5tW2Y6THCYjPKpBHNg?=
 =?us-ascii?Q?ZxY+bHEGiJ6eZxYqzGPt4AIcv24II5HCFvAYCvPiPCddUNJm/2MaCDu/5PnP?=
 =?us-ascii?Q?dVlcE/+xEItKKTF4SLdH1Oa6JcxRjBKHyYb4hGrT+pqsvopa3xjmgK7Ql6bZ?=
 =?us-ascii?Q?dfR+SQwrDOe9mZU3iXUBkxizlqtf/IdE9OZ5wke1opaVgbL93tEYsp3pRDxi?=
 =?us-ascii?Q?xEu/1+e11KRrcO+EZt6Fz32wf4na+RRZHILzg7W5OV/lENt7R6PdwyzT6yDb?=
 =?us-ascii?Q?+2lrln+uOI9Sz0F9Lx8DklfL4fh7Zpnazypbjzbl/VJnK4nADLk2+ts4p+3c?=
 =?us-ascii?Q?2G6KsATgoPcukB62jeRv3sjB4ODfxNSfZy0xULIKLkoF8loMm8hu+L91aj2v?=
 =?us-ascii?Q?8+Kj+AhlvW842EVt/O2NR5QH?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6edd44ce-6814-4fae-7528-08d95a70737d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 13:28:47.2313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nlKo5hi1JbHQubrCrhpXaVEOdmtQxJci7cIRDy3Hmqfw621l2AkkVORFvXFbGwzQfnthuCZARYmJiM13ABAL8sA14Ep/HZQBzqpmzs1Izkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5726
X-MDID: 1628429329-0II5XnSK9YAd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there's support for filtering neighbours/links for interfaces
which have a specific master device (using the IFLA_MASTER/NDA_MASTER
attributes).

This patch adds support for filtering interfaces/neighbours dump for
interfaces that *don't* have a master.

I have a patch for iproute2 ready for adding this support in userspace.

Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/core/neighbour.c | 7 +++++++
 net/core/rtnetlink.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 53e85c70c6e5..1b1e0ca70650 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2533,6 +2533,13 @@ static bool neigh_master_filtered(struct net_device *dev, int master_idx)
 		return false;
 
 	master = dev ? netdev_master_upper_dev_get(dev) : NULL;
+
+	/* 0 is already used to denote NDA_MASTER wasn't passed, therefore need another
+	 * invalid value for ifindex to denote "no master".
+	 */
+	if (master_idx == -1)
+                return (bool)master;
+
 	if (!master || master->ifindex != master_idx)
 		return true;
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f6af3e74fc44..8ccc314744d4 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1970,6 +1970,13 @@ static bool link_master_filtered(struct net_device *dev, int master_idx)
 		return false;
 
 	master = netdev_master_upper_dev_get(dev);
+
+	/* 0 is already used to denote IFLA_MASTER wasn't passed, therefore need
+	 * another invalid value for ifindex to denote "no master".
+	 */
+	if (master_idx == -1)
+                return (bool)master;
+
 	if (!master || master->ifindex != master_idx)
 		return true;
 
-- 
2.25.1

