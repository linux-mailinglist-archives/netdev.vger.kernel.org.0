Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605A7538D1D
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 10:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244939AbiEaIqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 04:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239278AbiEaIp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 04:45:59 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F018B0B9
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 01:45:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3iUMngyN599kmVN9cOjOgsYjT+klD87Oq2EIAknvGGLZKDH+ncOWXJ2pRscEQK377Z0iYzutZFCMOLgjBh0zEoRyJwKN6kepwxhRcC01eV+wqVCBDbGVz3EZLAlY0drroeFs72ZyZ39qlVf1gdwthgHypDnh+NdFBnrWq0v+aPHXsP/ey1sfUzrypIKk+VIOue1xTAyFNJiKKeD++ru0q6MVqOmWcmJvSOD8j1iUraJtVTLhgG30FJY1fxeHNaXRa8CWXFbC34aqO9VcbYF81id8dQY3fSVdB8XQT8x3fXYxcJSREpza0PSRys9vgc0/G/sPkhdsB28WHbB3rb7Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMaDynRJ4/rW09luelAXIoLAI6IR4iI6ToeYFSovb0M=;
 b=FBPAMrXDpOwtUtAVoBXsiBUCgEFBdPO+e4gqE83h+fePjnpQrby3QIcD2kJqzsdq6YyfANDl5E8tRaKDjwEomONjb8SQ6Z6FY70C4Wry2tIVR8xwUVSubav1q4cgqjE7lNdWo6z0PlmpXXURDBeYWdy3VEEh5R+l+i4nDkuYtIY9bSNojaiLulDtyyTapIMyVEfTp4LdMlNf8F6FIhC62aMINj2MlcqG/DVy1qB9/Wn9UtYdrYrIcz0LeoCikqsHbmHXFPPKmf7IMXVE5mbhtihWUpg6EO2664AX1DPfBkeNCxr3F/uvJvX4j5JhKQ4/LJU61JP5eZlia66NwcEXiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMaDynRJ4/rW09luelAXIoLAI6IR4iI6ToeYFSovb0M=;
 b=rXSEzbgk5PsEuR9d0y3A3WQWYptitnDNeJITlmaXd0gboXQ63AvsCXEgsIQbnJWbZyi+LAZA9zjCkDmiTS3Eq8+o74v38FkTjrAV5b/DQoikmi0cu7HTjd07QGAllftpaHRog5ievU9T2pQazqYTsryoRECTHengQW8uLtaa9RmWLyQ7iVjGpXZ17r89fjR4BP2sDRkh94y8X8UmdGs9sCyCcIoKRr2anr76/r2weugrZDu0zq2M3x1kxF7UTG5fWW6za2lz3tc5nwLjbHyTU/LYmjV34iI9qqZHmmZJY/oRCMEKSMOHKwIZrx2SZPHEcHB+Q9n+EHYVVcx3X5gEwQ==
Received: from BN1PR14CA0006.namprd14.prod.outlook.com (2603:10b6:408:e3::11)
 by MN2PR12MB2959.namprd12.prod.outlook.com (2603:10b6:208:ae::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Tue, 31 May
 2022 08:45:55 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::40) by BN1PR14CA0006.outlook.office365.com
 (2603:10b6:408:e3::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13 via Frontend
 Transport; Tue, 31 May 2022 08:45:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5293.13 via Frontend Transport; Tue, 31 May 2022 08:45:55 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 31 May
 2022 08:45:54 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 31 May
 2022 01:45:53 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Tue, 31 May
 2022 01:45:50 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net V3] net: ping6: Fix ping -6 with interface name
Date:   Tue, 31 May 2022 11:45:44 +0300
Message-ID: <20220531084544.15126-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 686efd1d-3553-4439-bd95-08da42e1f9ef
X-MS-TrafficTypeDiagnostic: MN2PR12MB2959:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB2959836CF5B790D22E4FB400A3DC9@MN2PR12MB2959.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jo6mJ3TucfHU+nGOfU7N6UP/y6xLgcmxTOs7kQA1E46SOIFLS8twu7JX495FkjXCOufbcxeXJer8E3mYj4CEt36YEHs+y5TCA0yFwY1726TKi6QNJg3TsDoE3HzugUWF8/9BEGdSO3CoLzLtHRP3+21THHBnoTC/zpI5IvK5nIrCR2wHKnRY2gOjcSxnWq+AhnA8E0kowvaliWARpx7ZZegUdasL4R8+6/fpduVH0lnV/YgkpZ57ldKg/rVAPIgmmmK4tJGAWzSNHF/WJqV0yRwPx8VCpYlXR1EO5OJjA4R7f4IVZdW+eQVi7ntDL0lP9TKehliaDpQCkC7b6RDhjHUW5prtHMEex4sJepX9YTkTjlWGH4dTpJv3JPeO/5NfMcC61vBFouFgl9qb0RfPwg8/QkBw0ITNPqRO+rc2sevDSQzkZwqt+FpP+86d9X2NdK3XYtxk898UoaStjKtkDM3DgQh3fW2ldHi/plg8puKQMGTytz/ade7T0/GFrzfOiLrmUoNDpeSleGefqslJGJHsuZzEP49zb1oX72M3a9O2lphLS9jfzNZ/+BLGT7LQUXozfoS6RUtKiDTKmpgYpy6M0X0NEY7lzTjAA3e0WMgGMlSiI165VLY9rSEmd0FEUSuD6FXDFPgjbcDytJ57tZuwrrvftun3k6PNvcUmJHCnfeKN/6mTMpG1IT4Kpf3SSt08nTe9qucXFL4T03bfIg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(508600001)(83380400001)(36860700001)(6666004)(2906002)(81166007)(82310400005)(86362001)(26005)(356005)(47076005)(4326008)(8676002)(70206006)(70586007)(40460700003)(110136005)(316002)(36756003)(54906003)(5660300002)(2616005)(7696005)(107886003)(1076003)(8936002)(186003)(336012)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 08:45:55.2784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 686efd1d-3553-4439-bd95-08da42e1f9ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2959
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
 net/ipv6/ping.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

V3:
Per David Ahern's comment, moved fl6.flowi6_oif init to the
shared flow right after the memset.

V2:
Per David Ahern's comment, moved memset before if (msg->msg_controllen),
and updated the code comment accordingly.

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index ff033d16549e..ecf3a553a0dc 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -101,6 +101,9 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	ipc6.sockc.tsflags = sk->sk_tsflags;
 	ipc6.sockc.mark = sk->sk_mark;
 
+	memset(&fl6, 0, sizeof(fl6));
+	fl6.flowi6_oif = oif;
+
 	if (msg->msg_controllen) {
 		struct ipv6_txoptions opt = {};
 
@@ -112,17 +115,14 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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
-	fl6.flowi6_oif = oif;
 	fl6.flowi6_mark = ipc6.sockc.mark;
 	fl6.flowi6_uid = sk->sk_uid;
 	fl6.fl6_icmp_type = user_icmph.icmp6_type;
-- 
2.21.0

