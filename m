Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8B62E1D8A
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 15:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgLWOqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 09:46:33 -0500
Received: from mail-eopbgr00126.outbound.protection.outlook.com ([40.107.0.126]:61785
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbgLWOqc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 09:46:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flmTNvqHV1LfKXhgq9mPTyiYfNjjIGgLllc0Qby+uczALYk3A4zASbSvSvjOKZNGSG1OiuRW74HzMIzYtfliS4cZYQyel6WUSIEA5+I8qBN4DEeyFFPNJFGdOUBBgOktswZXi4smToJiW+aXP3qmGMscQ99CFsE7qSV5g6MBzIs4CzH3oqLVCNRhH3v5g2QYRTobAVML4F5FkgW/0tV4Nwx5IcEoVQR5+v/7mshMiuZ9Cz6dySEYlj6+uUvyGEzKJ/lXa5MYnZQBSYflmlGTVC24bI/ZRrRYuNDDzqroU3qk+4RJoeVciYNjQ1Hrn+aimCxO03CYLAR6CePSvTrcYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++z9tOgtmh/5x4eGs+urNGZf48et0pU2jXHFgyS8Vd4=;
 b=ZB7X9W6n4JnijeAzYFhGRmBqlCBaQEnrU/CgciJsoS1+1GRTI0DGP1TMbmxLpASYTaIGmcZuVr7v4/LUSWU76jqTTU16gvN+8h3IKd9cYrMhQpb2gLEPu5zkzBcNtVFQm0Aovq0M/SmVDwuO4K5YQxFqL9G3OPLBtcsAGgWmbS50kUZ3dsMj2mN4DV2jJJQkYQNV4M06HJfaQ2FWdMRuwhkCvH82nMvnvOe5Fx+WcHHlyy2pjS9GqAWv86dGft6wc2XwCp8YwL/L0hh0k+XLGvenMxaESU4xB8ge2u6WGQo5PEDIX2hPxV+4WKLRqzve3HdAXnjWwlj7YBO7lcC0VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++z9tOgtmh/5x4eGs+urNGZf48et0pU2jXHFgyS8Vd4=;
 b=hywU5WJraksGHYpq3iBFwV3XjQplPcF81ETFMOFjEM03qo8jX825RKdar1aJ1fAJYp4nn4o8GNaby64Tzt4hkmlyQRZs38OwaRXDsR0JtMJsi9wkkyh9WhH+gptDn0lUb395jWNBmP9TlKj66bFAvjufWW9X0RFY9w7ECBgHARw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3057.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:162::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.33; Wed, 23 Dec
 2020 14:45:43 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3676.033; Wed, 23 Dec 2020
 14:45:43 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net 0/2] MRP without hardware offload?
Date:   Wed, 23 Dec 2020 15:45:31 +0100
Message-Id: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AS8PR04CA0142.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::27) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AS8PR04CA0142.eurprd04.prod.outlook.com (2603:10a6:20b:127::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Wed, 23 Dec 2020 14:45:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4a2411a-da2f-4bcd-9a8e-08d8a7516d0f
X-MS-TrafficTypeDiagnostic: AM0PR10MB3057:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB3057847CA18D11877A1C364193DE0@AM0PR10MB3057.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TGFSEAvxqbojSxxC05QG08ZKxQPOqkTZ7Bxh6WjMaTvKHRu8r99Z6tEq5lyxk+AqzVHtflfTaeTXRRY6dgAgfUr6fwN1YaTmWNNTciabTHvCVWVmOLje8tUWlScWIKihhG/Ni9ewPQLQhg9eaZfhNFpkDeq3DSSvy+BtkzBagG418yla1GD32FCqA+hFBYePzmv4suVYIIV4DkIyo6TtjY8e9KJ1/EcPVFCnoFvtimjLtw78II7NAJMMv0T0Eb0BdeEmC0CAGj+dEepzgMau1oKMHSYc6MWGdOCv6VYElmF+QU8IvnIa+FU+32VJMw+DOUdXlo73TWq6OS8avTpSlvrMEEglMpCgngy1kisppcixY9iJ56wZ5XhkuNE78E93tGt+8u2S7lQaVKmqSmTi15uPgtb+WGrFANUkfMstTQSQ/p/tsP+E+G2NOPp5QWIbocIg7hWtdBg8Zz2eS4ce/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39840400004)(376002)(346002)(54906003)(4326008)(6512007)(6486002)(107886003)(316002)(16526019)(5660300002)(26005)(66476007)(8676002)(66556008)(6506007)(83380400001)(66946007)(186003)(52116002)(2616005)(6916009)(6666004)(966005)(44832011)(1076003)(86362001)(8976002)(36756003)(2906002)(8936002)(956004)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Moh9GryaefRQX7hH0n7Vw8Gm2HHt+Yll0hR/Vc6j1Wp8JWNWm0RzdgudVwyB?=
 =?us-ascii?Q?69hBV4y6R3Fa0hE1QH508rWtI2i/Q6p7oky2lR2I7GVrd6rXBy5YRu34arrU?=
 =?us-ascii?Q?XyP7RM/bv6q7ma9qo2yyIIXxKtrE2j6sz5tiFrogEdzNBEEXKtCQb3f9qGU+?=
 =?us-ascii?Q?LZJXgfhRRs3MUhG4xmlgCed3+ztNJ3WRL38QML+IdU7K8x2BCcr2Z0JFtrp6?=
 =?us-ascii?Q?I7JcLFgzCtg7v0okLKoxoIZNZgyLW5tmYlbsveDIecndtJ1+2dX2spX6QxPz?=
 =?us-ascii?Q?il0u4mDgCrl7KxNAe3nRd2E4q3TvYBmoQOmzML/aVLTUC1OEyyj1gPtM23Vu?=
 =?us-ascii?Q?Jmu3Bf6K1XRFlYiIVZlH3o7E9qV+Whua6HiTI8ik+MO0n5ksha/NxD1BRd6v?=
 =?us-ascii?Q?NKeihG2yuig4lM/Ba8RiShekRC8oT/a03udNuIg+0GxVPEWXNjhLXVIlzk6j?=
 =?us-ascii?Q?Fpj2v4jwnlXd/jKBhBv/F0lRNz/pDsNolj0OnLRD07al/cf+qghMfAIw3X5p?=
 =?us-ascii?Q?xDx8WE29Xs0v7eZL4HeLXFtHR0NkoL+YJYHS5x/fgqqa+qwjdHADBq8vitEo?=
 =?us-ascii?Q?Ou7BF0xg6bdefxWnxAxh1PntlZcYbEXVV1GYfJWDIe1a3L74Jol3BIDfb0Nj?=
 =?us-ascii?Q?YkZAuPeIwbXa0aP52lE7OcWrEmRxGhvFlKqJXjgQQUboqKp7gxkveKrEK8KB?=
 =?us-ascii?Q?feakctqULiQdgXlix3zk6HVK78sQ7k2zMMZcivOeIRHGAspYSBzxM6UCkTSW?=
 =?us-ascii?Q?lWYLHE2aie8uig+IwYMNidpdEbXep4gWTSFRONDNl34im7mMaU3kqrv4Pbtr?=
 =?us-ascii?Q?QfZxL+HgiuAxlODpfWzjSKoO+ygKlhQat2QvZthVp1UQjVyhDj72BaNsX1Kk?=
 =?us-ascii?Q?ZPXATXrHK8RXWif5CIzT9wlxAJ0q7R1XC5fo/gIgHskANnrGueprKQJImXby?=
 =?us-ascii?Q?Uxao9Rkvz5/Cf0XhX+hqkKiJfE/fyHwz12gmDvoV9T9Bmtu2+7eAcWScVGZ5?=
 =?us-ascii?Q?FWZA?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2020 14:45:43.5014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-Network-Message-Id: e4a2411a-da2f-4bcd-9a8e-08d8a7516d0f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SPwHdR7w431i4fYvllln4odSqe6LxmD5iD9rrc3QHoJbjjquu50GO16Rsc2uxcfPPG8AySsHAGTZ3y6V/hh4Q1ZL1DmOPEzf8YC2P84P+YI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3057
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu and net folks

I'm having quite some trouble getting MRP working in a simple setup
involving three mv88e6250 switches in a ring, with one node set as
manager and the other two as clients.

I'm reasonably confident these two patches are necessary and correct
(though the second one affects quite a bit more than MRP, so comments
welcome), but they are not sufficient - for example, I'm wondering
about why there doesn't seem to be any code guarding against sending a
test packet back out the port it came in.

I have tried applying a few more patches, but since the end result
still doesn't seem to result in a working MRP setup, I'm a bit out of
ideas, and not proposing any of those yet.

Has anyone managed to set up an MRP ring with no hardware offload
support? I'm using commit 9030e898a2f232fdb4a3b2ec5e91fa483e31eeaf
from https://github.com/microchip-ung/mrp.git and kernel v5.10.2.

Rasmus Villemoes (2):
  net: mrp: fix definitions of MRP test packets
  net: switchdev: don't set port_obj_info->handled true when -EOPNOTSUPP

 include/uapi/linux/mrp_bridge.h |  4 ++--
 net/switchdev/switchdev.c       | 23 +++++++++++++----------
 2 files changed, 15 insertions(+), 12 deletions(-)

-- 
2.23.0

