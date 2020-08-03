Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE6A23A006
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 09:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgHCHIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 03:08:05 -0400
Received: from mail-db8eur05on2079.outbound.protection.outlook.com ([40.107.20.79]:36160
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725270AbgHCHIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 03:08:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmhPwUOOjRmFnMSFP+N3v/lnGebM7Hu7ZQrEfS2VeLw9Z1QBXnNncfSpI0xMIYl/Sw4ol48Ei358yzlNpc7Ib9+5jqPcUFtqPrW9ZZZLLA+dZ/q1g+rG6RaO26vKw//jj61Mx49Nv2knm3Z07A8rPTHeFTJhLE50NOVG7wbbuRIgngYORHDJBYnMjafBDPBUiLlvz56fZY4kF71AkmAElAbke/92uQ3LgmPam6Oe+PATsFK5RcgQ+BJ/CSmhQXBB1+QTuLzmM87IbxeOXpg7BGW2IqPCJITb0kXI5sE0V1x8ZN/GdnC/om3PwdsBQGg9kxjC0DWgwuYZ0bbXfpJwcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VBu1ce8+z3lTJGHX6uJzot5JCBo57S4F028e6g4wwA=;
 b=dfDsCl0E9X6DeY4haxS6+Aa2nLaJFfvdHsS66dAJ0rLThZIWdiIRTVVI4Ua3yQIxN9JxGE5b3U5JIpmvdwEXknSVPRMgD+sIg+ttLu+c6PMt9xYTEgwClBnhEepQlsa79FuQ3/ncl+S+VqMtya05nmhCtiklGZafcyVySKn877taOHfbiBP6BzmQPDdsAhZAFYcZZgf2Bs2Rj9cW/lXJcsm8q/Z4BTI66MnvAlZ9/tDevr/4R9B1PJXrLvARTslQbNnecSBCUnwZCRZCt5gKKXnhuzgOX8X3wpkHLfPk43YGcs4bRu6OfU79GtnByFANHIwcktblccyZLAVy8VnUqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0VBu1ce8+z3lTJGHX6uJzot5JCBo57S4F028e6g4wwA=;
 b=lGXoVYbyLDL825M8Kb0gfKmCKjJkXgRkxB8WMl9JyFKOtdT7yzs6mI2MChaD86ilwA8vxMWtrM+UzMAGAqOzAlJoMApXi5riN1BOrHEBJVDSsFdSKO+mb3HKosYve2oNh2eZBByEbVwAwLNce6wsjFNoVkATNJY8rNlB/9hjZ7Y=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5233.eurprd04.prod.outlook.com (2603:10a6:208:c9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Mon, 3 Aug
 2020 07:08:02 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 07:08:02 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net v3 0/5] DPAA FMan driver fixes
Date:   Mon,  3 Aug 2020 10:07:29 +0300
Message-Id: <1596438454-4895-1-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0007.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::20) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR07CA0007.eurprd07.prod.outlook.com (2603:10a6:208:ac::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3261.13 via Frontend Transport; Mon, 3 Aug 2020 07:08:01 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b46a67b6-a413-43e6-36fd-08d8377bf5e0
X-MS-TrafficTypeDiagnostic: AM0PR04MB5233:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB52335C789AD7E38DCDE4831FFB4D0@AM0PR04MB5233.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jiWQxzTWxNS8L1C78KXz1+UXnOWo/lBgPaGlBJGUZ+x4+/nKCx836hgB2pM6miznaABQm360YoWU9vtapNvmDjJ+hxJ6hDomlp1dUBYsMANiUkIpsp8Y2l1KFV3JuoshSK47RQUfzgdgbi1wQ3kzeUicyDGe5fVVTdEh+XH0DIGBlz47oelT6MaFYMVDemLeU7jmQdxFzeQdRACB49gE3XQ3tfI8SPUqC2K6cp79LkFYFs1UbH0uPZADEh5kktdW9VnTJWVakbUNmzIs9RegKd4xRZM2z7nhNAJuMPNFC9GKL+kKh/ncQplgonXePyE8OYA+WckUn3DsnKNJvm3NSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(316002)(6486002)(52116002)(16526019)(2906002)(8676002)(26005)(4326008)(6506007)(3450700001)(186003)(8936002)(478600001)(44832011)(6512007)(6666004)(83380400001)(66946007)(956004)(4744005)(5660300002)(2616005)(66476007)(36756003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mqALyOtwdT02HYagtxOspAGPuEcJoARzavAgjgn5ba7v1X/n82twm4I4IzgzOoKdFawO97UeWLOVzYVZ5IVmtyRhOFgQKiX56DYYE3857qMfa2q6colBRgWd3Elm1zMgaPrGUgCwUKMAUB0g3QOXPZA99L77kIZ1cOLGrTDj2Pe/QvuhUQDp1Srd6PKcam/WC7XhxCKmJ0oc8NCJej0G+vK9TOiaYI5lkrWhogI82v78nnYEEqZpCGUpNgSejFfKGTJeH+Ozjb7OAJJ2OjdgtHCnnwRy2ey4CJCC5TN3DjNV0UvmxHXoSvRyHzrYwNvhJGEg24zGsJv0kjQoPEoxJ14GtWvmrZWTVSmKgq7H8TYR8Q/33qR7oK1OGHfySA9aing2SELK8ou5KvH5mtsuxOoT8PPieFAhMH0heb+LuxklhDLXthKZZpAiNJteou3bghuYQJEV0Q28Bx0KXzkzJe0euGNQyM8GLtJKhnsOOKeonPlOrfUXPKKPO8eW4ntghG0pohrLbuoQPnnBzdGhtB/CCfYIcSaLBLRQFKzZgRiigI9PTMaa0q6rcBlpzuQ0+ufw1Y2HBWjdVAdQfxeiQWxehBJWcWH7wKlOePFa7X4Q0CizO8atywh2GpFvL6KiFrDK01PvdWLuNGnUIYnGkQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b46a67b6-a413-43e6-36fd-08d8377bf5e0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5443.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 07:08:02.0071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ncng0z88WcWwkuYGzyrUSgzmWJ5BZjkGbNWVsM3d2kA0BHeh6z2pPjVus0r19T9zKSA8P8rJu5aidWF7pWCaD1IPwURrVOu6SjS7TUBMKt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5233
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are several fixes for the DPAA FMan driver.

v2 changes:
* corrected patch 4 by removing the line added by mistake
* used longer fixes tags with the first 12 characters of the SHA-1 ID

v3 changes:
* remove the empty line inserted after fixes tag

Florinel Iordache (5):
  fsl/fman: use 32-bit unsigned integer
  fsl/fman: fix dereference null return value
  fsl/fman: fix unreachable code
  fsl/fman: check dereferencing null pointer
  fsl/fman: fix eth hash table allocation

 drivers/net/ethernet/freescale/fman/fman.c       | 3 +--
 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 4 ++--
 drivers/net/ethernet/freescale/fman/fman_mac.h   | 2 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c | 3 +--
 drivers/net/ethernet/freescale/fman/fman_port.c  | 9 ++++++++-
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 2 +-
 6 files changed, 14 insertions(+), 9 deletions(-)

-- 
1.9.1

