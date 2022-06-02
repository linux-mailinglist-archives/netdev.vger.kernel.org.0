Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD0653B142
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbiFBAfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 20:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiFBAfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 20:35:38 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A5529C128;
        Wed,  1 Jun 2022 17:35:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hekTe4FWW6xUDv1ZSyz5wltSW18d6juEnxEXeOkhzpIuf64HHugFEYHKdTKvgvSMoD6iBRReQwnVW4WquFJFQBQ3W8Crrb5zkV2ku4x6TvXz7TJCvvi/elAqMq0+4EekQ5EkJoL7cLdmAQx79LDIgVv/KEr2K2/yuBPUku+rpMVtr5p+Bk5mbXHQicPtOwRVJ7nIpeTmU//WSTkZ6oidjkgQ5l7jTi6AVCb/+VAYcV9PpJo9lMYbP6L3oxrmccx6yL17Poo+MCUAUlH7kPyKHlc0ccegfD6w1JuI+MJv4kfaXNs1K58ifhj28kv4E5z7uNghIoM0csW9IfKiR5tzTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StW0k4nJtpnqQJ+qBSoGJ0QTn+SPzVhln1JwAilIMEQ=;
 b=WU+oMsiSC4kNz0e2+Ztir/cD7yVvo1AhQ49uEINsE5GDjw1w7YxMNWc6H4dFhdEUWuOlwO9Wn+mZSSqqWy1m0x4OfK5pwnwGmISLPN6JrnMKuFDHIVJrA9cn2hNG9mCTj9W0pAP2K7rpMTna8X12ew0KhXD9tQsOy2BSLBGTOyDiBctJ7nt1xaYSmjeJzNwgqIiw/+N/EczVGN95gc3Y/p2Ayj2pHLyhZ8Mx2SFqDw0hgxqDbUJrnOZkWXJ8rLwE5MdwdIbEpY1TB6fLg4O0bCd5AK4PoAhmvo+Rzy97WG7AsHvPI5mxLZm4cP+6lpLPxx539cbRy6uN59aA9zoj2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 8.4.225.30) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=infinera.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=infinera.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StW0k4nJtpnqQJ+qBSoGJ0QTn+SPzVhln1JwAilIMEQ=;
 b=Kk9KGQSJR/8VGvD9OxwdJy4MCT0g24wjjut8nJQu+7CNg6QetXilh7JZgNzyRt7qjSFxZoBeu1U1EhYDgq2mitzcozIitKemay7USrKE4vKc4GMyNRsUzr0yUiMeGmQPCgMab4QWuQrAsFfZKb+TpLWz/Vega4VPcNjtqpvu9ss=
Received: from CO2PR18CA0055.namprd18.prod.outlook.com (2603:10b6:104:2::23)
 by PH0PR10MB5644.namprd10.prod.outlook.com (2603:10b6:510:fb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Thu, 2 Jun
 2022 00:35:35 +0000
Received: from CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:2:cafe::ae) by CO2PR18CA0055.outlook.office365.com
 (2603:10b6:104:2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13 via Frontend
 Transport; Thu, 2 Jun 2022 00:35:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 8.4.225.30)
 smtp.mailfrom=infinera.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=infinera.com;
Received-SPF: Pass (protection.outlook.com: domain of infinera.com designates
 8.4.225.30 as permitted sender) receiver=protection.outlook.com;
 client-ip=8.4.225.30; helo=owa.infinera.com; pr=C
Received: from owa.infinera.com (8.4.225.30) by
 CO1NAM11FT025.mail.protection.outlook.com (10.13.175.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5314.12 via Frontend Transport; Thu, 2 Jun 2022 00:35:34 +0000
Received: from sv-ex16-prd.infinera.com (10.100.96.229) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 1 Jun 2022 17:35:34 -0700
Received: from sv-smtp-prod2.infinera.com (10.100.98.82) by
 sv-ex16-prd.infinera.com (10.100.96.229) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 1 Jun 2022 17:35:34 -0700
Received: from se-metroit-prd1.infinera.com ([10.210.32.58]) by sv-smtp-prod2.infinera.com with Microsoft SMTPSVC(7.5.7601.17514);
         Wed, 1 Jun 2022 17:35:33 -0700
Received: from gentoo-jocke.infinera.com (gentoo-jocke.infinera.com [10.210.71.2])
        by se-metroit-prd1.infinera.com (Postfix) with ESMTP id 217212C06D81;
        Thu,  2 Jun 2022 02:35:33 +0200 (CEST)
Received: by gentoo-jocke.infinera.com (Postfix, from userid 1001)
        id 18E544010BDC; Thu,  2 Jun 2022 02:35:33 +0200 (CEST)
From:   Joakim Tjernlund <joakim.tjernlund@infinera.com>
To:     <netdev@vger.kernel.org>
CC:     Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] net-sysfs: allow changing sysfs carrier when interface is down
Date:   Thu, 2 Jun 2022 02:35:23 +0200
Message-ID: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jun 2022 00:35:34.0025 (UTC) FILETIME=[ABC09F90:01D87618]
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c19fd8d-8bfc-4d95-ff18-08da442fce98
X-MS-TrafficTypeDiagnostic: PH0PR10MB5644:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB56441635AB01851E3DD964CDF4DE9@PH0PR10MB5644.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 04WDJVLH80F41t2Zqvbs/czK29Hoq01aoyk5231iKpB/BvCsB9VSqYhZ7npjR7XBWlNiPA8fA2NwwbjZVIAFvXz/iPt7+WoKaij0hh70rA1BXnCtEKYVlQpIFbiC8LER/Q93ntbotWsqW7PNu8CTTFBtP9qjN2UkzEMwUfZ3v8evXl2kfxWuxGvfK5E5RRvpN3O/3t+aAtOhyUg7dL7op2BzTqsyXxE1G5IHVUJrT+b7pN6UFVZL8TwZKwgKrocdunQWIhAcJtpwJfrFwT4mDBOIHsIT1++JLDjFnbsRVXXbwjjUTVtAlEV6k1X1PXf81Y4jAXU0Ynx/HeNvrn10jiuzCYCxKUhmKUSg9RYxopKpwlkQLG3MijR9ps7Am75rNU9GQ6/vouggV0J88MPNQ0wFBrPw9R1BAkoAkmtyGtSo8GGnmhdwCHLJSCwQmiDeYVAHHP7PnwtVq0+kvBBRlWgt74isRNs/MnuMfHXyCtWyosdiMMiF0Y2DVa0TUvELz72Sn+IELGypElYLkRRphXzzfjyeZ84jKE3p+c8aVaox8Ip6vhSfh+GzcVsPGKd5HjePCW2qdHggkBnoJbE/l0oSwKwpIHOKH6J7MEfos03za3GNBpvPXLgnEsJ8D8jkQXAy/6E+zLpn+D7KytbSI1Nt6YnybD0g0GB2sZSzlgYa+RJiY8Gv5Aos5aQBfEq2OFyIvy1F+EkXmNsrw4wX4Q==
X-Forefront-Antispam-Report: CIP:8.4.225.30;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:owa.infinera.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(316002)(186003)(70586007)(450100002)(81166007)(8676002)(36860700001)(42186006)(83380400001)(5660300002)(2616005)(426003)(26005)(356005)(70206006)(54906003)(336012)(44832011)(4326008)(82310400005)(8936002)(6666004)(47076005)(6916009)(1076003)(36756003)(86362001)(508600001)(6266002)(2906002)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 00:35:34.6006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c19fd8d-8bfc-4d95-ff18-08da442fce98
X-MS-Exchange-CrossTenant-Id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=285643de-5f5b-4b03-a153-0ae2dc8aaf77;Ip=[8.4.225.30];Helo=[owa.infinera.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5644
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UP/DOWN and carrier are async events and it makes sense one can
adjust carrier in sysfs before bringing the interface up.

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc: stable@vger.kernel.org
---
 net/core/net-sysfs.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index a4ae65263384..3418ef7ef2d8 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -167,8 +167,6 @@ static DEVICE_ATTR_RO(broadcast);
 
 static int change_carrier(struct net_device *dev, unsigned long new_carrier)
 {
-	if (!netif_running(dev))
-		return -EINVAL;
 	return dev_change_carrier(dev, (bool)new_carrier);
 }
 
@@ -191,10 +189,7 @@ static ssize_t carrier_show(struct device *dev,
 {
 	struct net_device *netdev = to_net_dev(dev);
 
-	if (netif_running(netdev))
-		return sprintf(buf, fmt_dec, !!netif_carrier_ok(netdev));
-
-	return -EINVAL;
+	return sprintf(buf, fmt_dec, !!netif_carrier_ok(netdev));
 }
 static DEVICE_ATTR_RW(carrier);
 
-- 
2.35.1

