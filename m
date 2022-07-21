Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5E257C71E
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 11:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiGUJLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 05:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiGUJLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 05:11:41 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2046.outbound.protection.outlook.com [40.107.101.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9802357D4
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 02:11:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIJtMm8xoQpQFi9AVf0UnlhAw1Ft1UpBCGP1F6zLUzrFmhwJV6t1KrwQrZf5l4ZFcsybl6DcPl5oqwCv0dr/U1a7WSzL9zNtN/A0GdCgXsfbqi4wO/i5j6XmE/DfDAwzVMcampjo34pHojRMS3JZwMgmbh14sshOkWjYM68KuN53Lw0pqJ3FxLdhIpxDoP2WQkHC6sMmhJGM0FSlkUPuug4FM48L43sBf/7ss6f1IazEGSgfi4WwCuLW6sPtDe1rFvBY5214PqZXSuaBDYGvhRXhFzzj3r+k7M3Gk9JZwxf4ttEqDTdbUouDj0laAPznDsBRaPDR8rKre9DjruiKxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DAX1Cb0FQk/y+AMS6dRUSzXiNofUm7dFhg89ax3CKY=;
 b=SaMv59obORteaI5X1iB7D765OxFU1pYqO3CB4mKYVivt7H2x/u/EROmQQLiO7cENLjsJwVgNnWq6IXlFELEur1qommyh/2G4MFCQP2OssKNFMyhTxdVqlaiYsdYYPjCLTwmTu4qnM26ZEE/lYk3FD537MeB9gHVh/XxqHGpBiCRyH0i2PrlpfRQlO48jErgqQywpkiWhjUzpSJQ8g3mB/MwrkbSot+7Apmp1l1WEFsmilDzSP8L51PgJZ5qYBwD+iUGlI6xcg/+w2BuW09RYvKjw7cnRlioweMVTRvvUdEtyRyD0Di05W6VSdEoYkY30oqdA+RxzeAwMPBS8+iFlsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DAX1Cb0FQk/y+AMS6dRUSzXiNofUm7dFhg89ax3CKY=;
 b=rj9jpXg+EGbMyL/dao6N0wrkCaBbjzlC4wWrZaw3aQkbkEkH2g6g5v5qZ9d49h9Jir9E8Lxh9DlCGayEoqE8Xa7kfvUfvUGu/T12RqXR211Cqf6v+UTSMH9USDO73iCYShC1Xb6bzBtMhIp3HawdqgygZ29sS/0SdK2xab21zjYGu5gh3C6IoLRGgTbqxfeOY8Jd+hOB/dZHT3DaUPvFKryTHUg5TZKwxHLzq83X++jpbkc2xgeikZRR+2NbalDpM4jAdym9yVdbWCP/XIcAQdKq2liM1AMsusRsBO1eL8Y7qQHlZQ1znDLWZF2dkBLJ4WannHkNZ20f+LHp0Hhoog==
Received: from BN0PR04CA0075.namprd04.prod.outlook.com (2603:10b6:408:ea::20)
 by MWHPR12MB1183.namprd12.prod.outlook.com (2603:10b6:300:d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Thu, 21 Jul
 2022 09:11:37 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea::4) by BN0PR04CA0075.outlook.office365.com
 (2603:10b6:408:ea::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14 via Frontend
 Transport; Thu, 21 Jul 2022 09:11:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Thu, 21 Jul 2022 09:11:36 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 21 Jul
 2022 09:11:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 21 Jul
 2022 02:11:35 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Thu, 21 Jul
 2022 02:11:32 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net] net/tls: Remove the context from the list in tls_device_down
Date:   Thu, 21 Jul 2022 12:11:27 +0300
Message-ID: <20220721091127.3209661-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57451b00-0a03-418f-a8e6-08da6af903c7
X-MS-TrafficTypeDiagnostic: MWHPR12MB1183:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LJIqRx/Qx96VgqeiTVJGqjCOhROYAg+cIfdPvVaocqLZOFnDFS3JiuhHIxlnlUSVRlN6NwG5lt01A+leinWge1UFVV8pv9pa+cqVhMDRB5H0JJBVR6xcxtC5zbGvvO8801MzQICbehBJMPBbUiqyE6NqHPrYcvJuBAUcPppuDBdXz+ZUINY+aiTFcdHgN8EO6XGnXpdgeh5F7o/wTbgt4dYbCUN6272A3DDZLn1oilLJxC0FKyH8+/8UscDswhwfd89Jsosmv9MLf7FjT0NCObXkszAZb5IDM00zw6DVF59g1zj5aFnBRJ9ayq9bf3fa2CSVXVSFjmRUUFcTCbe3rfRPu+xayEDd4KfCaGQHa9kwidRF9VOpnba1hNlGwCzsP+ptieCBsj5LneDoZgaUDfulprhh6t8HErLd0lF7o11zou5s+J1PLkmxzt52oFdueBogT5EPb5QfqzolVRHGy+8SF1vaHr72LFeurPmP9hNRcQGVb8/ptHq54NA+M9Hv4tylPKrHzKEkxckw5bTFuwFuuiHeTRfZ6eQ1gbBlBe/uXw61f6iVVesciI6BQpXm/9xSmuf3BZCEcbtL7eG3nQHkiQOdkga3vfWkFbN3JIuYpf7YsHyhGQ6bTvchKw4zO7YKQnmmOSGSjY7128OyUFJ6ncOKkjzQA0DXt9ORa7izBMg31C1+XKPlxNszE3B4b7Of3BymIGJonFS+qRRFxoFRbUyF24VqSGVQwkfHElqHHw5+ERb08VC49Ve6B2clYUoDvC/XzAy3nVBXi57itZBX2oZzplQ9KhwatUwgBxLgL+oSenArFH3dFSFjFQkDk0MFOhiH9KSvZMqOd3xuCA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(40470700004)(36840700001)(46966006)(5660300002)(82740400003)(2906002)(41300700001)(8936002)(7696005)(356005)(316002)(81166007)(478600001)(70206006)(110136005)(82310400005)(2616005)(107886003)(6666004)(26005)(1076003)(54906003)(8676002)(4326008)(47076005)(336012)(86362001)(36860700001)(186003)(83380400001)(40480700001)(70586007)(40460700003)(426003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 09:11:36.7445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57451b00-0a03-418f-a8e6-08da6af903c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1183
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tls_device_down takes a reference on all contexts it's going to move to
the degraded state (software fallback). If sk_destruct runs afterwards,
it can reduce the reference counter back to 1 and return early without
destroying the context. Then tls_device_down will release the reference
it took and call tls_device_free_ctx. However, the context will still
stay in tls_device_down_list forever. The list will contain an item,
memory for which is released, making a memory corruption possible.

Fix the above bug by properly removing the context from all lists before
any call to tls_device_free_ctx.

Fixes: 3740651bf7e2 ("tls: Fix context leak on tls_device_down")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/tls/tls_device.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 879b9024678e..9975df34d9c2 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1376,8 +1376,13 @@ static int tls_device_down(struct net_device *netdev)
 		 * by tls_device_free_ctx. rx_conf and tx_conf stay in TLS_HW.
 		 * Now release the ref taken above.
 		 */
-		if (refcount_dec_and_test(&ctx->refcount))
+		if (refcount_dec_and_test(&ctx->refcount)) {
+			/* sk_destruct ran after tls_device_down took a ref, and
+			 * it returned early. Complete the destruction here.
+			 */
+			list_del(&ctx->list);
 			tls_device_free_ctx(ctx);
+		}
 	}
 
 	up_write(&device_offload_lock);
-- 
2.30.2

