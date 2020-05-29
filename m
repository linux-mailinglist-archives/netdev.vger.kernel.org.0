Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A4B1E7B7D
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgE2LRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:17:24 -0400
Received: from mail-eopbgr60067.outbound.protection.outlook.com ([40.107.6.67]:13233
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725681AbgE2LRW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:17:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDhOAArHqeA6/Tv6cfCWGyj9YkWyezUnd7VuP5wfiqCqCm60emPee/dfugxDiJwEOzxdnpoKxNi668CNmPDvsX1r5RYgFMHsPld9WNFG7JzTXI3xFPu4LVNqvBTVgo71PWenSxE6XA7HWodUIeYEI7frg3IccxkYut7QgprdXp0NtzcKrWWEoU/3fmMmYX5+1GFcEsuHbw4s6ivEAQ0u+o8L5+dnAV8U37xbk3bcWY80Mdn4BD6UtVcNB8PR0OkoT1wS4NTNaAh0yKDlIahvukIMfVjeUSaaskIEkMWz9iOT0ZOUUdisgi302lavGhiO+B3WBOsbe7uGz7MSic9a8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMmeaBtl+BAclSG7jpa6HlXGrS2x0VW9cUkGd77rdrg=;
 b=BqgbR29Skvk9fbM3RWLXOvPf5GLgqnzBM+sHoPGp/Wps2OMreB4iJ0IBTC5dwJDpZHnzW6yQE+K5SKUFHxTeOrSYGfd0cUSOtUncpfQ5CZKqa8K6lB27BhDdTxEDUojd3IJlO1PTDir0ZxncZ6+gLA6UEAdJl+gKBhn4zU399/8KLaf8jj4KYvT6fxPwDAQTBqYoEyJTgqTm4Tl33idJsyeNYVs5dpnSvWnhC1LYiD96G52bt1ve/7RrDFjToZDt5EqpOJi1kN8npPVDYBIJeOoA2172OEnjNZonmyuwRk1lrotLg+mtAqD9pinu27LqXioGMKxqNFgx5hRinOljbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMmeaBtl+BAclSG7jpa6HlXGrS2x0VW9cUkGd77rdrg=;
 b=rcgOBXAhdgPiBY/qBSZGTBoBvXkR4DkOndDlhtCfvZzz8/Asa43uvjvsnvG/HspCwmViU9tGDAutf7aSw/LVLGeENE0GybzfyVY0abVr4NSYgCfbjEzt9vZ5U1UEU06ayEGD29ZJr148cda2Rl9ZIBICOMCvs6jomonyXxxfEpw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3468.eurprd05.prod.outlook.com (2603:10a6:7:32::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.27; Fri, 29 May 2020 11:17:17 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 11:17:17 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/2] selftests: forwarding: mirror_lib: Use mausezahn
Date:   Fri, 29 May 2020 14:16:53 +0300
Message-Id: <61e2f4c1489aa35ef05a5c7c0f4f55e2ee946321.1590749356.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1590749356.git.petrm@mellanox.com>
References: <cover.1590749356.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0032.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::12) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR10CA0032.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 11:17:16 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a205e30c-28c9-43db-5b36-08d803c1d870
X-MS-TrafficTypeDiagnostic: HE1PR05MB3468:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3468DF9907AD7523AFFE5CB1DB8F0@HE1PR05MB3468.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p2K+JGAWmlYv0/SMBy5ldZ1dfJsJau/iLeC0HlkeUIwNCLZoRmQ9Tp8ZmxH7fMJawQ5foP8Z+ITJD1l4WmOiZ3CAlAFPuBmniSvQRDS2HE0APdIIuKvugCaxo8xbbGd6CMgTTsqXMSpuZ+oBss/rZ7/iyiCmGQIA0vbejjpY65+rqsHoLhnnF9iRh+B1a7OQGNiOHdl1vYKeMTwbvyF6JH5/+7RWbBqLSfa/45rGWvShFYRLJ97QZhZI7JtOys06P6PQrWws+81at1wI/whsAdAMHp1gBg0FDKu9SUhbfbka9c6RyqfCDou6s76WkRiZX8LFW5zUG4/egRVFEwEQNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(6916009)(8676002)(316002)(83380400001)(86362001)(8936002)(186003)(107886003)(16526019)(54906003)(6512007)(6486002)(478600001)(4326008)(6666004)(6506007)(36756003)(66476007)(66556008)(66946007)(26005)(2906002)(5660300002)(2616005)(956004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Kl8OozK0V8sNiEAytEZSVBPweOiXYEJwO7b+nWnfmG1VMwWx5PO/oqOaHVO74BFwG3QP66sBK1UAoEbO8Jsd/u3haPfkDeNHee4HeKLUb3D/cyCzSjZhErA1tos1+h6up40IUewym40Z4T3U2yX0PBx/QkBZgTRcm1EaVgMoYzmpaVvEcjs35zCB85zkWqIRqzvx4dyXzM31/uZd70OrYLbeHJFi1916hJ2nMeEUqd1YEGMP+R6TRguGElIey+sTPIBflZgv9pz2hq2V44fql7KXg/z0/H5ICyvesx+417b9x6m65I2sQF+UkLrup3GSolyr6V3tdkGK5O7PE2CtKseHS5OMUy4WayPbPb6jnPTSkCU4LBprA/X5jt7DFtZNNtwc8uQ0EjB4LxJL1juqKnL9v1SBBNfjrcZjwnX25BoWWlrR0qMDmiGnNAZQYtmCuCRVStixLApRIwRzE0IHGBVypYgjXRrqLldLI7fvQew=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a205e30c-28c9-43db-5b36-08d803c1d870
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 11:17:17.0677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3NhL/rI0/oBATl8iPl/GIbr2zSBwBBVCVXzGa2/SXsZuzKnM7QdP5Ujb7HlmPufau4A5NGIXddzLN7ZRpTdbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3468
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using ping in tests is error-prone, because ping is too smart. On a
flaky system (notably in a simulator), when packets don't come quickly
enough, more pings are sent, and that throws off counters. Instead use
mausezahn to generate ICMP echo request packets. That allows us to
send them in quicker succession as well, because the reason the ping
was made slow in the first place was to make the tests work on
simulated systems.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/net/forwarding/mirror_lib.sh | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/mirror_lib.sh b/tools/testing/selftests/net/forwarding/mirror_lib.sh
index 00797597fcf5..c33bfd7ba214 100644
--- a/tools/testing/selftests/net/forwarding/mirror_lib.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_lib.sh
@@ -29,11 +29,9 @@ mirror_test()
 	local pref=$1; shift
 	local expect=$1; shift
 
-	local ping_timeout=$((PING_TIMEOUT * 5))
 	local t0=$(tc_rule_stats_get $dev $pref)
-	ip vrf exec $vrf_name \
-	   ${PING} ${sip:+-I $sip} $dip -c 10 -i 0.5 -w $ping_timeout \
-		   &> /dev/null
+	$MZ $vrf_name ${sip:+-A $sip} -B $dip -a own -b bc -q \
+	    -c 10 -d 100ms -t icmp type=8
 	sleep 0.5
 	local t1=$(tc_rule_stats_get $dev $pref)
 	local delta=$((t1 - t0))
-- 
2.20.1

