Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD883E5635
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbhHJJHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:07:35 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:52088 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235034AbhHJJHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:07:34 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05lp2105.outbound.protection.outlook.com [104.47.18.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3A7C1740093;
        Tue, 10 Aug 2021 09:07:10 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNeeYCj7pVFPEt5QMx9R811X4Gfz9b0GCuMYBvoFoZ9JhRDpAzuBVl7VvRRIntWzeMcu3HE2S2ud6BnAID87ZvUhbMDBYfhqXDULGatiwmUNTfHREKRcPGFNckRl2uNV2DmgFWLF8MIMVCTJJ9PGOe0Rmle93OBe4ogL3Za33Ei+CfbePPzyNL6ZM3p6I+S7jRAGjrCTH0ch57siK5xAubHSNxcNr4veUbWVhwlYdm6XOLchtjS9LRO5n72qGEU7H/jIZb0soQdCqX1NuyWziaSjPIAyZ6nRFDsgtfKiVu2rLuqj+fPs7waNWnev8oceztmYU6H2Dl52joHY+KSu9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=En3X5mfqyf2MNerlSdn4Eo69EWYQO4hQzGV4M3EHmDU=;
 b=V1nSEKkzfBCUgKzdm9CUlBCo4WZxcYoX17k1B1R2U+d8jCXqGrExU4ek4UVeKhHfpmFntBFhTRm6WSP+cdbaiowEGys3rnKnOHMsUbJJ+c1ofRkboBw9fKJr9sli0BRc+Wcq3pgVK2/N3yDU5kV9MofYnVhc9S0f0H5XCRijwJtJdBWUdIStU83ZXNbrPUoghiXkps95M1eySTNvZQ5lOVM11UesnpjjC56H43DlOg+yLF2e9Jg8npvlEBIY2nb7dy1bxY5BWAdPcGLfOCeyH3VKnnWP7IV3TQY6ZLNJdvhOv6D3aJbWfYuXUX7u5zADWZSpfJhqs5Nlx37TJH2igA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=En3X5mfqyf2MNerlSdn4Eo69EWYQO4hQzGV4M3EHmDU=;
 b=N2G1ssYAqR6i+9PXuNvTAO3EHRk+LEAFl5o+SWr21iJuP4LxtFOFc4+kY/VVXMpFVkVdSI34ZaaJAY5lzriW7TC7mpRmEqFCrZBqgvu8XJjAHlBX/jS40OKZLPKpdArBqR864s2cUPRK/q9DKqWGb0ss1PK/TxWGyXWwaPX5Vo4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=drivenets.com;
Received: from AM6PR08MB3510.eurprd08.prod.outlook.com (2603:10a6:20b:48::30)
 by AM6PR08MB4936.eurprd08.prod.outlook.com (2603:10a6:20b:eb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 09:07:09 +0000
Received: from AM6PR08MB3510.eurprd08.prod.outlook.com
 ([fe80::d90b:71c3:9c4c:34a3]) by AM6PR08MB3510.eurprd08.prod.outlook.com
 ([fe80::d90b:71c3:9c4c:34a3%4]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 09:07:09 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [PATCH net-next v3] net: Support filtering interfaces on no master
Date:   Tue, 10 Aug 2021 09:06:58 +0000
Message-Id: <20210810090658.2778960-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0137.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::16) To AM6PR08MB3510.eurprd08.prod.outlook.com
 (2603:10a6:20b:48::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (199.203.244.232) by LO4P123CA0137.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:193::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 09:07:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd3d66d6-46b5-4359-f180-08d95bde3b82
X-MS-TrafficTypeDiagnostic: AM6PR08MB4936:
X-Microsoft-Antispam-PRVS: <AM6PR08MB4936BC16BA539BDCC940276BCCF79@AM6PR08MB4936.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0U9gjMYad/fbuf/XnUkgi1ZPu6q971idltwIeL6KzfmLaPtEpMQ5CTJJfnUGFULuIW2qoFRp/SPZ+5e2sGpbL29V83+3W6tJ0TGi4ogJ3LP5Fsm5owdgRW8S9dBjKlkjLqLXWoOmy9GnB7+8y0u2+Fo6IZZ57Zma+cLA16u5rXZBbWYx11bt6FBK9FflKG1e0vvs+KLrIDbd/Ja3+dxyZ0v9RFNsX9npx06yjfFqBDQzm8ICqw/Y7La6LwirkjeWMSk2JU+UabOcINvxULQJsYJNL3GagYvYv8SAd/jI0+6BsMbuwW2vdpYPsPwkshQLmS/gj0mtTLHWVzct97FZTVX9yYb2R+dpKrZMZr9Dn8BLr2c+/YOiI/SLqZJRNowR3JlZfyCePyMSbQR/gnnl+BLV/OaT+bImGqs5I18IctnTbW9ZJ9j0nCGekWE4zwLDXEJeUZH8gxLGGIb6vyguh3cCwx4Ynf0KDBwotI6z2cOr33+ZvjtO8mUGan8AnMu58wqIWZjHYE8alpxqogSjkQVRSnwNui8A2WzrKW1xkQ235T4G8phn2nev3aYcwHXUI7wBgWUAmx9Swm/37dUEdPY0Xyb/e9j9LtyCvdqDP19sDCiUEdcK/AqHu+ORuSpssH9I2UuTQL/9kkFF107jaInYAs56BjImQsO1NM6Dftejw2K5WeYjevg1GNdIFkcrvGYSPCCd4KHRXc9k5UBX0U091nb5iBnNA974oGqPODk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3510.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(39840400004)(346002)(366004)(6666004)(5660300002)(6486002)(86362001)(2616005)(956004)(66556008)(66476007)(52116002)(38350700002)(6916009)(4326008)(38100700002)(36756003)(316002)(2906002)(6506007)(66946007)(26005)(1076003)(8676002)(8936002)(6512007)(478600001)(186003)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4mIh3QLcgCO8P85xSz0IhWMNM2feIIXQ8IN4QIYZFPAUOLMY2QZwiC+0sbEo?=
 =?us-ascii?Q?h6ipGGXaDjJjzdO3nq6xlfQgwshf8G7bYZd0aX2wh4/2sQ6ZRXmvOh6fl6ZN?=
 =?us-ascii?Q?eQiBHHz4npCqCkCgDcWZVIw0mZ98D7qH/T/uKamaH1TZmxst0rtpPSpZ0KLP?=
 =?us-ascii?Q?mW8/uD7zILrxNMEJ5ZvupoV68st8situA4691fat+NToe/TiHytV9kbHQI97?=
 =?us-ascii?Q?FbpGZEG3Qk4mSwVmfVwNN67D1xG1EIvWDmVIthoGYitVM9RWXc8m8pC4ixVE?=
 =?us-ascii?Q?UmQ0Z7Od2HEn+3++KpYr7y3x/Yv6LNag34Qz2WiJq9dXgKvIEluHDv+3PW+F?=
 =?us-ascii?Q?LLSY3xG2moTKKBRI82H4z0khyzYXXd7xXIj7v9z+oExWefGV1FeS6Ex0vbuv?=
 =?us-ascii?Q?IySaB5REOa4B2qtfAmtf4GAfIA9osWpZIIiHhPHkVoqF4WMBJw5GPlhfq6T/?=
 =?us-ascii?Q?scymadzzy7Yts1S4pjJtXEh7t9kA9YqBydDYP33KX1Mrfl8aV/fUIPU0qhcz?=
 =?us-ascii?Q?e3jtXQzOQHOsWib+o5ILUeHvdvVFbgoj+0VsF4ADv1TBSJSyVkStQV+5PJgh?=
 =?us-ascii?Q?fi/bg5rJVdvHJKzVdMPWuHqWXp4Y+7Qf0RBQya6nSrwJ4zsY28gWjFoximwg?=
 =?us-ascii?Q?BSIFx84kbTKE+DDz4QAQJJZWcp0ua5uTM23ED0KPEl0qT59t7KUpYbgQ4Qvz?=
 =?us-ascii?Q?eaerEK04HuulNF9wBBYSx+Eb31KFnGPee4H5rgHbccYolKFOr3oPD4BOYgyW?=
 =?us-ascii?Q?rix8ACQKXy4x00NZ3sEGwZidnPbPtVua0u1IiGtknLzK42QmFrPBiCfXRmhP?=
 =?us-ascii?Q?SRK9Orvrm04v3vwBq4USmijz21m575doSVimIj63DelhWgB+dUZam2j+lgPX?=
 =?us-ascii?Q?2DrYH8RskH5hDnd69G5Udh0fi4H6c4gXb3qXf8RlsRATzuorzyZj2/osIwUX?=
 =?us-ascii?Q?PWjsOQ9ev5jdt9M0Td5Exl8PdytpE8ya4v5QVGL2Fxdtdcuou/kCSN9S6upg?=
 =?us-ascii?Q?ma9BHnpxWtJAnBir0Erd3ut2blBSmMZm/17G4ENpDKjPSYTnWY17kQLqqO/W?=
 =?us-ascii?Q?ZLaQ2ZiqyUVq04zO78WY5kdmBGin6RBCeJS5Z0IKAoz0wQhf5TZEeT51yWeq?=
 =?us-ascii?Q?jQoT5JQj6J+h2Vadf0y5laV8psgyHZf7CRSCHKKnS04spYHitRVsthkTo7ox?=
 =?us-ascii?Q?L6ZJJfWr56PzZLppjedwtKFoiTuoiSLcqHdkY/9qdY3kyHfJnJvfCmaaY5pw?=
 =?us-ascii?Q?hjujaP8LbptCfQkJngQ+g8zHIABpA0ui4mkUz/RN62+CIyr29uR/x2l2oI2W?=
 =?us-ascii?Q?0hl09/jZV+wzhkbXkqQCiefA?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd3d66d6-46b5-4359-f180-08d95bde3b82
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB3510.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 09:07:09.0959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vX9AGgG3gDM03SF5mZ+577CVvPQByyTAhDFsVLqHx+zHHRgw8fjPpX6grANrSNExzqxBxjyKKcHdnAHPMj5zR4JRUUJ+R74L64dyDDstxHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4936
X-MDID: 1628586430-yh8uRmvVi-Qa
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there's support for filtering neighbours/links for interfaces
which have a specific master device (using the IFLA_MASTER/NDA_MASTER
attributes).

This patch adds support for filtering interfaces/neighbours dump for
interfaces that *don't* have a master.

Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
v2 -> v3
 - Change the way 'master' is checked for being non NULL
v1 -> v2
 - Change from filtering just for non VRF slaves to non slaves at all

 net/core/neighbour.c | 7 +++++++
 net/core/rtnetlink.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index b963d6b02c4f..2d5bc3a75fae 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2528,6 +2528,13 @@ static bool neigh_master_filtered(struct net_device *dev, int master_idx)
 		return false;
 
 	master = dev ? netdev_master_upper_dev_get(dev) : NULL;
+
+	/* 0 is already used to denote NDA_MASTER wasn't passed, therefore need another
+	 * invalid value for ifindex to denote "no master".
+	 */
+	if (master_idx == -1)
+		return !!master;
+
 	if (!master || master->ifindex != master_idx)
 		return true;
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 7c9d32cfe607..2dcf1c084b20 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1959,6 +1959,13 @@ static bool link_master_filtered(struct net_device *dev, int master_idx)
 		return false;
 
 	master = netdev_master_upper_dev_get(dev);
+
+	/* 0 is already used to denote IFLA_MASTER wasn't passed, therefore need
+	 * another invalid value for ifindex to denote "no master".
+	 */
+	if (master_idx == -1)
+		return !!master;
+
 	if (!master || master->ifindex != master_idx)
 		return true;
 
-- 
2.25.1

