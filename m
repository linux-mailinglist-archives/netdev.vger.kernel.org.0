Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCFC1DF68D
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 12:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387735AbgEWKOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 06:14:14 -0400
Received: from mail-eopbgr30129.outbound.protection.outlook.com ([40.107.3.129]:27038
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbgEWKOO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 06:14:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHrXi8D1Mltau6mof7hJhQsAxfgwBaeqRoKkl/Ry5uBf+mdMX0ovBrEKzPwkEKnz60nk08B38LSmTIkiKLuKIGD0G8HruqwgUl7r34z+37wvn8DZnr4BuG73xE/ZUYXtCW3MqV2HGy7TzBAWyLdzPvPWU0hZC+ablDOIPYtWKUsO3XiMfFEFWqJ0qoDR5vQgZCEh2xTNbZK8NqP47ArW6VPOt34W1iDBlyhR9Qx8ML1eTX+gUufXUvJ22FVcPO1XMaLXwCSvSuCKbXGeyP8KqSIcXPm5GHxQXVRkRPFOGi3fe62zaY79gMI5gXA11ckC6BcEXqCyv8eRqyDrRAqSxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRkUhrEuTDDG1sjtwYo756tDTZwajb0G/2IM0y3h5uE=;
 b=fjnoZ1rQGmAenpf8PP1eMaSyqW6UrLYc5R/2KsY/HCtUNVDC61Qy5ogUXWRg/UCFt6qyoK0PIY6jyBkhnMMfUxCWymUen1VLoAKifCO1nByDaMufcwrfEb1eoalFHsKOGEezP23C8ahalBqWkAvV+UZeMCpwb0ooOtYnt5HYoB/m9ipgPmH2UTkeRCT9lwUE3pp/9bHP4kGESim4DxwfdZiTnSU3mXrOzBq9/Buwzf12W0JPc+guT6+kFjphKARuWYCSimxQSkkSLnogOZAfqQCMy1L0ZBdy7zx8ARNcWVojLuNK49Bdoz3KDKs/vSlkpDYzXougS7iHWhokDOMh6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRkUhrEuTDDG1sjtwYo756tDTZwajb0G/2IM0y3h5uE=;
 b=lGNnCD3Y/iRwilEYHbjaw0sENYNkSEkJnFl4Xh+BArBhSbS28TgGh5joIubn3b50bFEWaHpbup0BG3MZChtSkaetq7odj3aVyrTU+nODDDWrOA/slw8+O5JDZzKfd8EMvweJ8tyVwZ7FBNaeM7atCW9UahLomi5bs2HOJ5PvdAI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (2603:10a6:208:f7::19)
 by AM0PR05MB4195.eurprd05.prod.outlook.com (2603:10a6:208:65::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Sat, 23 May
 2020 10:14:10 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::d991:635:a94b:687b]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::d991:635:a94b:687b%4]) with mapi id 15.20.3000.033; Sat, 23 May 2020
 10:14:10 +0000
Date:   Sat, 23 May 2020 12:14:08 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     thomas.petazzoni@bootlin.com, brouer@redhat.com,
        ilias.apalodimas@linaro.org, matteo.croce@redhat.com,
        mw@semihalf.com, jakub.kicinski@netronome.com
Subject: [PATCH 1/1] MVNETA_SKB_HEADROOM set last 3 bits to zero
Message-ID: <20200523101408.s7upzn62ihjy3pgy@SvensMacBookAir.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM3PR07CA0072.eurprd07.prod.outlook.com
 (2603:10a6:207:4::30) To AM0PR05MB5156.eurprd05.prod.outlook.com
 (2603:10a6:208:f7::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (78.43.2.70) by AM3PR07CA0072.eurprd07.prod.outlook.com (2603:10a6:207:4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.7 via Frontend Transport; Sat, 23 May 2020 10:14:09 +0000
X-Originating-IP: [78.43.2.70]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af327624-ce98-4c55-da95-08d7ff0208da
X-MS-TrafficTypeDiagnostic: AM0PR05MB4195:
X-Microsoft-Antispam-PRVS: <AM0PR05MB41954ED5083AD906B4E6EC6BEFB50@AM0PR05MB4195.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lhcy/YHvMQpiCVzsq/nMewr3elInzRr4sJQhjf5TKpzqY358/ItqezJPZWElSODDCHUoMzcs1WLLmwCTYGJifkUOmApoITZuQRMidFeH9Tkxqws9Mn420NF+8uf6gZ8hZRzVlC7W6GscqfzxdupFYrOZHXLzbkW6Ymfo4Gd0vJcBLH+mPkL6ibZGPz2w6J7eGcT4hUrR3rx0yhvJEN/DnI3Grp17vteeqJtdIGXFd4BZTEuhp+Fa9vskDyc878+N2yVJf8mWhWhNLcHiuLqx2NN5dsZez75Ojjbt75qUC2hW/GKzK3EYaIUithn94Y908iwRgPmbT9OWcRhLRhz3/IbQx7sjiXQI1b67uRSvXF0XBQky7/tLESf2W7X0wfeWb/X3NWZSkr4gRcHNsOfzr9NGUOZ9GSHzD7pdEtU3pwCJ5UmyP8q9acrP8FoPpeW/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5156.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39830400003)(366004)(396003)(376002)(346002)(956004)(55016002)(9686003)(4326008)(6506007)(7696005)(6916009)(52116002)(2906002)(44832011)(8676002)(66946007)(16526019)(508600001)(8936002)(316002)(186003)(66476007)(5660300002)(26005)(66556008)(1076003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: io0+c1Dzlh2Vci8NFxxJ9jy2z3LRcqZzx4E6q05FShHZ8a2Krt6GrJL8YdhkPG04TQnTYNB2+FZhLTT3ctCB2su5oqLIRk6KQLEGa1SDfqf8Cm1hZaeLAcxAFjTOm4YxxX2gDwfCKJEtZVUqQuzHhkQ7APZI0THFXWQLOeH+jD4VMdC1BL+ye8Iu5wVQq6VyKni8B/z18C0ICmfu6gX10N/2rgO2/eLD7iKykTpQ1DyHeKor0PLlht5C0wzAPtZpv5d/ZQYZNvHHjXHGHuXiQHVzy79AoB9DU+9imQa7IzBkGtdeWryIL/35BZSKi8LkQ85wFmBHasNkEPM+kpBkzs2QMeA/qkOjxhMknrrWIKCbS5KK67EPWRpZ9siFARq89/K5AHcy1rXLcMRKBJ7sPKifH7D7HfMHpU+UU8Dn9tOE77R4WQenwTcig2Z3AJYcZYEg8muOMWs5l1ts8sK4B6n7RyftiJ2otRoFsPZOwuM=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: af327624-ce98-4c55-da95-08d7ff0208da
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 10:14:10.1491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mkTU59MV9zafx79IW8sMjgRs9TMlKtgZZmAccU5A8hvVgYRp2rHg3orYwh8rBsWHBpyS+1R6lJVnqne+BrdtkNJ+W7Cb8VmhZ5aYMLi6snY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4195
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For XDP the MVNETA_SKB_HEADROOM is used as an offset for
the received data. 
The MVNETA manual states that the last 3 bits assumed to be 0.

This is currently the case but lets make it explicit in the definition
to prevent future problems.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/marvell/mvneta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 51889770958d..a4a2e0340737 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -324,7 +324,8 @@
 	      ETH_HLEN + ETH_FCS_LEN,			     \
 	      cache_line_size())
 
-#define MVNETA_SKB_HEADROOM	max(XDP_PACKET_HEADROOM, NET_SKB_PAD)
+/* Driver assumes that the last 3 bits are 0 */
+#define MVNETA_SKB_HEADROOM	(max(XDP_PACKET_HEADROOM, NET_SKB_PAD) & ~0x7)
 #define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info) + \
 			 MVNETA_SKB_HEADROOM))
 #define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
-- 
2.20.1

