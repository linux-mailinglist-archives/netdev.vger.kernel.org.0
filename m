Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4563B5370DC
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 13:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiE2Lu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 07:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiE2Lu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 07:50:57 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D3F4A909
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 04:50:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQxh+nwPMMutzJEazZAl0a8QVKe7CW5xk6370e02B/ahn8L+kbICbj9J2GqZ3jcPAr+GwQrSuYaSG2KxEWF9Yo+Ny9obFnksKIR1gi31H3i8dFckUEHW9KVUqdIwz9o+8agQbKF6hurmL4zAogNd1j9EgMaD18M/Zi+TOj0KQRI/hnOnDcZ/znbXZVY9oCtiDTL1LPm2os07I6epoUZW/qbNIaOOIoOInpApXGJ1wGszMkSnA1TmtMXsTB1uR0yOrBx58IG3ihQApa4ITKpFWd46Cn+uz/3ueKZhxaUHon0+oFaMf6DDQ3j3gCh5+tSk8mSIab5ntz8hTXWnkW0zlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NKRG3f39MbqLWhKFhEL1C9edf7wh7ypvREs95IFZMfk=;
 b=nS4b8hkEo+HkV4ZMEpplwBIBDihpJu3QCDn+IAZQROYKJqz9Pu6m7ig8KRlWvRIqDUL75zM+Bxq3eNGe3+EBfOY8SElgmYh4eAJ2iVXTEV/v/gINDeXVeiQDLfICZ66pUWkmjFVNb+D6eXZH/VWMvQ0UGwo1aKFUUVeocs2viVs1pbH/sBPPdHAw5TBkrJK7/9R1h1JPBXEjR5NIHyaiOXdyFAcmy5+qDluNtChtVjaUGoie9zDuBXRVrSIFeF0gf7eXPkj2VhvxwxHen6TOAm8f5EX9VT0R3fWcuFSUmDmx0kAZR2eSfqIaBsGeM/UOtmD+Mh4UDGTY3qv4xjPHqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKRG3f39MbqLWhKFhEL1C9edf7wh7ypvREs95IFZMfk=;
 b=tgoBHORpT4eYHBQBJe2Po42laih8mnrulazq5R/wEFkw7AAvRz9lwEzCipi8a37CRykTW+PGq0GBS0fCGX+NWXXfb5N9cO62Vmioql5WswjdU1DvLEeXhQsWocGZVYILg48mpPCxxmvKBNJeNiTddOiey/FHQuFyXclA6uPBBDGF1tEg0foLgznMGm3MjAwYBWD+ubFpjQUR7BQ9RShEiKAmMcjcrvonE99AREhniTV2zxO8LSC1YaBC1bAJDFc03wdkKdoRGftOmI8oL92a+Bc0fW2RgjoM8ZBIJaCcSCqOVjtlIsJrkQyINrfXF1mPiPwj9r9CZL2QkQH98KYOyA==
Received: from BN0PR02CA0056.namprd02.prod.outlook.com (2603:10b6:408:e5::31)
 by BN7PR12MB2836.namprd12.prod.outlook.com (2603:10b6:408:32::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Sun, 29 May
 2022 11:50:54 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::6d) by BN0PR02CA0056.outlook.office365.com
 (2603:10b6:408:e5::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13 via Frontend
 Transport; Sun, 29 May 2022 11:50:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5293.13 via Frontend Transport; Sun, 29 May 2022 11:50:53 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Sun, 29 May 2022 11:50:53 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Sun, 29 May 2022 04:50:51 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sun, 29 May 2022 04:50:49 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net V2] net: ping6: Fix ping -6 with interface name
Date:   Sun, 29 May 2022 14:50:33 +0300
Message-ID: <20220529115033.13454-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1f7744c-3d9f-45f4-edc2-08da41697c72
X-MS-TrafficTypeDiagnostic: BN7PR12MB2836:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB2836A2E857400728FA5F28C0A3DA9@BN7PR12MB2836.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WDi9Hyu6d8NH0+8yzQAzojtU4HZ3Zg1mMKL5JI8wIoufUzLi+EUEnPUhSP0lPMTQfix4+0oTG4gR0e121efz12vDA3BV8ymEQFA24q5hL7sDucFkMAEZekmIXq7vvdYrcO8otlafUiFHh81nwxBWK0gMnVZ4NgMR0Ls7lBmG2r2HIiC521dyV8Cd/yI8chkDbx0WnuKPLXULvO4O3ghspCnCP+oskh1BISgGV0AGl/cJgu3P+3kGlZtgIrlrXti+wF16BNjXvT5hkg1M5tcl5qp70lkShzgeLEDlpdncKxpFCjCsJ6K75FTGP/WS+ky66h346z7RCR/VoT54fiVkYF4iUX9SeT9uHHzwgzBdisgeRMqoW6smnGHUjQeSuKOYqYpR6PbJa9DKlGJcs3pqDHqGi+LwsFFu6qfBLVlYQZvkhhGjmNRJZqeXhavKwQXM5hVdpmrCePjm9UxmHZcN4tijaAm0CfY55JzjKpRLvCanleaJAZjKryjoj4rfUGud+ozf5Mt/yeueoFG4oNqfgYxqQl4h9+DA2wqlU9Fk7cwKjhM1n1Vtf8IThibuoA2ehaXQoK81j7fW3a/MMtz682MIoRl4IFh8UjKEnwLYrLM7AZGq5v8kIwCeAXUx2BCtTFDd6qwyfX9nuJxXohYnHs0qOwj6bIn9OW2VgDoFw5NfNf4hvC5PZogcnCvCe7WqPda8eoEYhYLj/bbRaHuB0Q==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(2616005)(5660300002)(82310400005)(8936002)(86362001)(107886003)(1076003)(508600001)(40460700003)(83380400001)(8676002)(4326008)(336012)(186003)(426003)(7696005)(36756003)(70586007)(70206006)(2906002)(6666004)(47076005)(81166007)(356005)(54906003)(316002)(26005)(36860700001)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2022 11:50:53.9437
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f7744c-3d9f-45f4-edc2-08da41697c72
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2836
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When passing interface parameter to ping -6:
$ ping -6 ::11:141:84:9 -I eth2
Results in:
PING ::11:141:84:10(::11:141:84:10) from ::11:141:84:9 eth2: 56 data bytes
ping: sendmsg: Invalid argument
ping: sendmsg: Invalid argument

Initialize the fl6's outgoing interface (OIF) before triggering
ip6_datagram_send_ctl. Don't wipe fl6 after ip6_datagram_send_ctl() as
changes in fl6 that may happen in the function are overwritten explicitly.
Update comment accordingly.

Fixes: 13651224c00b ("net: ping6: support setting basic SOL_IPV6 options via cmsg")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/ipv6/ping.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

V2:
Per David Ahern's comment, moved memset before if (msg->msg_controllen),
and updated the code comment accordingly.

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index ff033d16549e..2a5f3337d488 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -101,24 +101,25 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	ipc6.sockc.tsflags = sk->sk_tsflags;
 	ipc6.sockc.mark = sk->sk_mark;
 
+	memset(&fl6, 0, sizeof(fl6));
+
 	if (msg->msg_controllen) {
 		struct ipv6_txoptions opt = {};
 
 		opt.tot_len = sizeof(opt);
 		ipc6.opt = &opt;
+		fl6.flowi6_oif = oif;
 
 		err = ip6_datagram_send_ctl(sock_net(sk), sk, msg, &fl6, &ipc6);
 		if (err < 0)
 			return err;
 
 		/* Changes to txoptions and flow info are not implemented, yet.
-		 * Drop the options, fl6 is wiped below.
+		 * Drop the options.
 		 */
 		ipc6.opt = NULL;
 	}
 
-	memset(&fl6, 0, sizeof(fl6));
-
 	fl6.flowi6_proto = IPPROTO_ICMPV6;
 	fl6.saddr = np->saddr;
 	fl6.daddr = *daddr;
-- 
2.21.0

