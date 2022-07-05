Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE295668EA
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 13:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiGELJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 07:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiGELJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 07:09:09 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE0D14037
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 04:09:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWEagtA3gj2kAWTM49mbghzUcvjpSJDe4reKajv0mxQ5zmkQdtGqJ/giuWghk+moa34+pgyayOup+HRstVTBGUJkIHW9RKcTY2sFJgNwrw5qFtJGss/lFY+3ygENJWhv9u2P5qQlCZl00nRfrakyV1RTt2zxiCbx7Gyzir8qwgH5c+pstitvblwdAeENwjApzVCrWX8CbD6aNDm4RFY1As1ePD0ydIgYKAZBL0z1kfE63UWTwoBA52kDi1pzOGqx1q4QI9gjT/AoFj06hFPCrdIvi4OjIsF/eimuroJIR6fruTnfy0PT+Q0ybqX0KHMH1nM/t6fE6tAsxb4479yNWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Ttzh6SuBjYnlTcGeyARldraHZ9+7iLfHwVg9Raew4w=;
 b=BogMvxOzTC99K2YE8Vi3PlcZLwAy/qcQKVsDd5SvBQ4A35Mlo1oMCMKSYYWOq491aBqHJYUXFbYQFyP++tXv4+XKyQBx5kGqb50xNyPbXvOgRULpYgnyuF0YgHw6FLcfjPF3M3cPpPJE+Tt93DpEdKUQVao2Jf61XaqMOvbOAYViPx7RuLr4CFsHBrumOuWvbaHFhZR5PNngIEXNccilxKvUibWn92kguAvMwrBoxPLfjmplby6GfNfkWgeiBO5+O+kELOMTFhW5SYea2y6RKCyng634Do6GNQOMYq8vxqR9XyBBzfhaoGsHDpK1JWuuLmPwVnPzp3NZ65b1MPsNfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Ttzh6SuBjYnlTcGeyARldraHZ9+7iLfHwVg9Raew4w=;
 b=IDKgfbzTOYx3y3nWnjsEw/Ntq7yR1SErWomBKSephaM3HMj7wUSfRxgHWzL/JenoY/V2TP9RTWnE+dqp57eeG+XpFbVl3+6LC0+jry0up4zGfst05pFCqt9wQRrZr2Y/rMsLE17fQi4WFz3wnK0LkeJ7090Ou3mqFEvAta/ZMCC5+hm0nF4Hbw5W6igEBjwjguCfHhk2vWd7S9n+3izaZ9rds3+deVXR9q+hjxj7COoj2iwtXSPC9USWHnbhoenYyZb/a78/MtpT+QMnwgz0rsPVBrkGiUv1yRFDYf3vt6Gyh849hBdlO+Qe66lvA8JDLU/xaKd4rkFh4zjSiXSwug==
Received: from BN0PR04CA0131.namprd04.prod.outlook.com (2603:10b6:408:ed::16)
 by BYAPR12MB4616.namprd12.prod.outlook.com (2603:10b6:a03:a2::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Tue, 5 Jul
 2022 11:09:04 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::69) by BN0PR04CA0131.outlook.office365.com
 (2603:10b6:408:ed::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Tue, 5 Jul 2022 11:09:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 11:09:03 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 5 Jul
 2022 11:09:03 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 5 Jul 2022
 04:09:02 -0700
Received: from vdi.nvidia.com (10.127.8.11) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Tue, 5 Jul
 2022 04:08:59 -0700
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Gal Pressman <gal@nvidia.com>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] Revert "tls: rx: move counting TlsDecryptErrors for sync"
Date:   Tue, 5 Jul 2022 14:08:37 +0300
Message-ID: <20220705110837.24633-1-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b7a1061-0bf0-423b-59d2-08da5e76c57f
X-MS-TrafficTypeDiagnostic: BYAPR12MB4616:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 53hDXd/2zdAtB5DkQnQSR268W6bPqLCiQlfXjnDYbAkcCjYtnlj8FwY831V2Gfec32UsJK59RxgTc6L6PreroF/EbAR3hVP8YteM9ekCEG+3NpllnsyKCIWSwvqXYxzIMO8yF9UpF79enMcDKk565A9Ieroma9ddUUkOhUAWp//3DQcsUp2yeEPblgk0hcu6xFu0KEDj9wflFVeJd6zBZx/Lrj8Lg+N+XpdljrMVxRUMzmNj39QIDjvgw64XnxQkrLrkRhxI8jn2PxBWFdEQua8VErwamepKg/udMBq5WAqHEjJaFMduodfyVJk2HAinunmu2zrZUJtts2/em7Hr2ETEsYZZxXe/CUE2DiD7nvoluyawIzpreIsNuTXXxoZSMhywss5ammMltN+veq5iawBo02WLpet77HQr81WGStFytB43fkTtQN451ygZQ12vl741kiRVcr4PAbfVFHZm10Apx/MHgSZPnPFnlqE+BIGC/nuk7uaGYw0JXAEOcm2oiBEdxkkJcgh6Nfz/8vD6r3ZOBcgyrZGsDd5/ylUhoFIBgTwfyxmk0DYUlAi9YPT5AGlkLDNetCOp/qIp2788yfXOxmACOUZXPGJextwd+0emxggXuqUQJpxmCbZHg0Vz5eEMOI0gQX7n9jcg0oybrmrOB6ZcWUaILzVEUiHY6wZoUcnyYXPDlzfP4TD+NiaqWCu79EnstLHXilLIDm+mglUTW0nT39PvZId0C7D8rbMHoRNKPSgcXFamLlZfKfBT2s0qhDyutY7C0rpE9T+Qbd33/PyCA79yz1pRjDFs5VdH1hHNq6AzO1hlNtrAYnnQrdSy5wpe/Ql8GJplsnHxUS4H6ZiHDgHiQMHfKNY637s=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(346002)(376002)(40470700004)(46966006)(36840700001)(36860700001)(4326008)(8676002)(70586007)(70206006)(41300700001)(86362001)(6666004)(2906002)(7696005)(478600001)(40480700001)(356005)(82740400003)(83380400001)(5660300002)(8936002)(40460700003)(26005)(81166007)(1076003)(82310400005)(107886003)(47076005)(2616005)(426003)(336012)(186003)(316002)(36756003)(54906003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 11:09:03.7393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7a1061-0bf0-423b-59d2-08da5e76c57f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4616
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 284b4d93daee56dff3e10029ddf2e03227f50dbf.
When using TLS device offload and coming from tls_device_reencrypt()
flow, -EBADMSG error in tls_do_decryption() should not be counted
towards the TLSTlsDecryptError counter.

Move the counter increase back to the decrypt_internal() call site in
decrypt_skb_update().
This also fixes an issue where:
	if (n_sgin < 1)
		return -EBADMSG;

Errors in decrypt_internal() were not counted after the cited patch.

Fixes: 284b4d93daee ("tls: rx: move counting TlsDecryptErrors for sync")
Cc: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 net/tls/tls_sw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 0513f82b8537..e30649f6dde5 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -267,9 +267,6 @@ static int tls_do_decryption(struct sock *sk,
 	}
 	darg->async = false;
 
-	if (ret == -EBADMSG)
-		TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
-
 	return ret;
 }
 
@@ -1579,8 +1576,11 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	}
 
 	err = decrypt_internal(sk, skb, dest, NULL, darg);
-	if (err < 0)
+	if (err < 0) {
+		if (err == -EBADMSG)
+			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 		return err;
+	}
 	if (darg->async)
 		goto decrypt_next;
 
-- 
2.25.1

