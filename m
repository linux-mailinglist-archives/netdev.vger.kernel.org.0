Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB0A542F0F
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 13:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbiFHLXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 07:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237500AbiFHLXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 07:23:09 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2077.outbound.protection.outlook.com [40.107.212.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1873BC3E0
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 04:23:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bhz7kyolchezqZvNlKKegGjB8lQQ1Bj3io1ZR9zkyu4sooGUjZqUr62pqmBWf/dqMLwDVQcxFWeYqKsX2LKRaMxLhTDSoSR/5FV/sVP+G/QG08ZGSm2hf+dwi73wa72BY1z6j5Nspg6kJnDj5BuiH7FADITGOHWd8T+IgnM/KEuvszh4Co7U0SoagKbM3lAKC6btpzeykeNMNhwamKNC+VdcAnxVCFtZYzAKWqmVCSZDvDRR/7G+hkGT++BhruZKEh4d6H9qZHZhwQnFkw8BajnxuFrfU6lhigaBTBykYBlHh6KgwUkCV09nbXjl8EAmHrXF4ZJeB3+0MWSkocggIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=03ubAIsOqsdP3U+VwtFbBtLmIcy/jSNPXCWVzHwaLoY=;
 b=R81MG9ECQdPhLqNgHN+RZQ9kbx6OtLZCA0K3uvLg+sjXjPRU72d4Fgg0qJsjp52GnLRY8LrsChKU0zqAmN9qVssvPlNxTuqzxMWI9gHm13H3scD3Qo94tzuVnG/BOFyztrzxcskMveNIQTTtEmmDA1wO8CqjeifUTeO+mI54qZN+jCgMpiZRKaiHr6KKNqX3zYbEXmZ1tCv6lxo0IEB3+zjtuUvmDilCQtZwxM4QTWIJlXRf+o9e9NBTVTCSln3eE3CzqsYoUlc4VOsPUOLg8BDGNm2wWoPDv9ESwIWOY6xk1646GWV1nH2Qvd1+4VWMTCK29ggBqyQcoxVaUCnWaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03ubAIsOqsdP3U+VwtFbBtLmIcy/jSNPXCWVzHwaLoY=;
 b=kpI5IPwc5osL9C273k5pUpJgC/GBX0XAdWr5sCdDnDLrAYqWiDCjj9EhIuGr05El8A3M0Is6YZ4qitt2JsSyniXA3OG/YiVUBEUitdNukaoYipbD4EIOJCL925Cq8XpcRTPO7Oz/ANxjKJrUaxw2/TEcMtWbbW3LGx4WyABnMtXHtWCQtidXaGN3gnyYgCZuDA+JjdGP7+YgqgYak5k9nuEr/FXvfnR6WWePcQ5DqJLEGe/QgRyk5cPz0V2hM7RHU+4Xz3BeEssVu5mFzZxDpAEQA8xIXZescfx2arEl9eOtwisFiBp13pOIDNPP1Es9fme2WULREBo6QUkp4GE/GQ==
Received: from BN9PR03CA0141.namprd03.prod.outlook.com (2603:10b6:408:fe::26)
 by BN6PR12MB1458.namprd12.prod.outlook.com (2603:10b6:405:d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 8 Jun
 2022 11:23:05 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::70) by BN9PR03CA0141.outlook.office365.com
 (2603:10b6:408:fe::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17 via Frontend
 Transport; Wed, 8 Jun 2022 11:23:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 8 Jun 2022 11:23:05 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 8 Jun
 2022 11:23:04 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 8 Jun 2022
 04:23:03 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 8 Jun
 2022 04:23:01 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH iproute2-next v3] ss: Shorter display format for TLS zerocopy sendfile
Date:   Wed, 8 Jun 2022 14:22:59 +0300
Message-ID: <20220608112259.3132037-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7113393b-b7f1-4726-126a-08da494141da
X-MS-TrafficTypeDiagnostic: BN6PR12MB1458:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB14586C81C3EF8A90A0B5A427DCA49@BN6PR12MB1458.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kQtT3Gmp+2PgXbyIlwdabHE8X9pXIgz0UN9n/lBpmtyMpdvTfxHRRgzeZimiY91H96ETqWheJx3GEZsx1OMOWmL5qDCA/ddoFb/LC5hMPyad6kgNGjNeiOVUbuj6D5JzJfP4ETiIFW705hQ5vrcoCGA+YFMNwLivy5LFS3nx26EyqPeyGwUo9b9YXsomi479SmRKz+CZPIT6wXscLsjnTG1Vs5rNzq/pJf75QWhDDNqW9Y6LkeCk4+OeatvSxfGXSeKURuy0YLhCklXJi449/xdzJ8MBPrBaq7bnMpD+IRoahrvuo23bjuny9xT4ZuY6e6bRBs3nWfzMIDmwU51Eh6jJIM3BqDgjx81rrUSvNDmNybIu6dnZPqW4vzXImYvPlHRtwie6PUhdRpP7PdIs2VJZQ6ZH06sfQhhiYrz2rgG6feOZQib6XXRX0JjQjs8PwqSNa2KMgmxomg4GLUSomiIH1m5g+VDV3j0EPdZkMULYO1HNbrEMNFBko/tQwdQZaQkjO7TpIWNueX/Ersl0w96KHg4/hfUeVH0R2YxFAL8PKX7nPG1rHnSwUXuNjQD+zn1kHtgPAv8sh4NtcrbCX8KPG6M8lxxCqWvug00cYUKUnDr/5NhDrgiwdNb65SCA+IREIxz3eqbzMZ1gJNmIHQQbCXPji7EyGOHuxLpQ1NaC11nLlvvu2qdTk/vOPp1N61kr/CsSuHp9YfGHsfwmxw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(83380400001)(356005)(2616005)(186003)(110136005)(40460700003)(8676002)(81166007)(8936002)(70206006)(54906003)(5660300002)(70586007)(2906002)(82310400005)(316002)(4326008)(86362001)(508600001)(336012)(47076005)(1076003)(426003)(36756003)(7696005)(26005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 11:23:05.0984
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7113393b-b7f1-4726-126a-08da494141da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1458
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 21c07b45688f ("ss: Show zerocopy sendfile status of TLS
sockets") started displaying the activation status of zerocopy sendfile
on TLS sockets, exposed via sock_diag. This commit makes the format more
compact: the flag's name is shorter and is printed only when the feature
is active, similar to other flag options.

The flag's name is also generalized ("sendfile" -> "tx") to embrace
possible future optimizations, and includes an explicit indication that
the underlying data must not be modified during transfer ("ro").

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 include/uapi/linux/tls.h | 2 +-
 misc/ss.c                | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index 83a3cea4..e9eeccd2 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -161,7 +161,7 @@ enum {
 	TLS_INFO_CIPHER,
 	TLS_INFO_TXCONF,
 	TLS_INFO_RXCONF,
-	TLS_INFO_ZC_SENDFILE,
+	TLS_INFO_ZC_TX,
 	__TLS_INFO_MAX,
 };
 #define TLS_INFO_MAX (__TLS_INFO_MAX - 1)
diff --git a/misc/ss.c b/misc/ss.c
index c4434a20..78e52ba2 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -2988,7 +2988,8 @@ static void tcp_tls_conf(const char *name, struct rtattr *attr)
 
 static void tcp_tls_zc_sendfile(struct rtattr *attr)
 {
-	out(" zerocopy_sendfile: %s", attr ? "active" : "inactive");
+	if (attr)
+		out(" zc_ro_tx");
 }
 
 static void mptcp_subflow_info(struct rtattr *tb[])
@@ -3221,7 +3222,7 @@ static void tcp_show_info(const struct nlmsghdr *nlh, struct inet_diag_msg *r,
 			tcp_tls_cipher(tlsinfo[TLS_INFO_CIPHER]);
 			tcp_tls_conf("rxconf", tlsinfo[TLS_INFO_RXCONF]);
 			tcp_tls_conf("txconf", tlsinfo[TLS_INFO_TXCONF]);
-			tcp_tls_zc_sendfile(tlsinfo[TLS_INFO_ZC_SENDFILE]);
+			tcp_tls_zc_sendfile(tlsinfo[TLS_INFO_ZC_TX]);
 		}
 		if (ulpinfo[INET_ULP_INFO_MPTCP]) {
 			struct rtattr *sfinfo[MPTCP_SUBFLOW_ATTR_MAX + 1] =
-- 
2.25.1

