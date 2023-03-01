Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94ABA6A64E0
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 02:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjCABgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 20:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCABgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 20:36:52 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB3136689
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 17:36:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyAYaFsfdpIIfbmbP3i4zPG40zPF4x6zTzPhCAdeKaT7SRl9n5kTUiJNMCvvbSTIcbzzgPhYLKkDJX5h8lNNTtFi+qoK8JU/x4eylHLskBRKpisB96i3DbjtwHn1aD7bCqX3U9k7AZpuefcO4OzEpP/MlOg2TeudbrOZcmPGnDt6AGUsyNf7T+v3GT7KduI/YCTtWsGdAdFesc3AeZp60IFs1OjF5FCKqaYz0zo+145DXJBIVfKKzuI/nsjix91bWNlpwWA9bTCv1bcHcCziKaEvDfoGojGOoZoQh0OLKNiKe37BhYWN4RyLXp3EO2+aPK1wSsPh+xYOBvzMSzPzXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TlUcb9VnwmHM6JXxNse8SzKPyRsOK/6KXZSLDwyWl10=;
 b=Wlb5TDkBcBJqaRqh9IHcYQ43/5o4+WdgTT0d0jGYJkpINNIJLVioo1XiuwiGLCklOgcE6vIULxB1GsWWVQlK/ACAaTNIIUeBRx6Yj/GQhfZLBW1AzwSsZ0Lp73WNGdg89udg0gSqRj7kUeGEZqPhgU6MjGTBSnIGhJAaHqihq0ZtMmkxpTthgofVIfz0reCfQp4J0su8Gga3f7ghQxyC06YP+MS4uk31lcgvXszkPoUQkztHXTSr2UjyqPvhZW3w7IH7OVnr6wVNG/TghXSIDb5eKEInapiEmO5zqFS7TlgtECn0rSLpfJlu+GNGX/PqNVF1w9tOZonmcff/CFufGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlUcb9VnwmHM6JXxNse8SzKPyRsOK/6KXZSLDwyWl10=;
 b=jFm1LoQV43B4yzV/PEgwzdR+LPhxJB5dPQDFTevVWrHWAHHmWnPR/N0+KceoWkrzTPoYOt4As8WI8QbXdQRRqW5rNrz6GHUJqlmU9/NN7t5TMzGv5SI9G3iyqJvuuQDa+lpZWWHZk1emtXIp5eU+8zZWNX+dUQxu4t/UpwBdz9Y=
Received: from MW4PR03CA0325.namprd03.prod.outlook.com (2603:10b6:303:dd::30)
 by SJ0PR12MB5610.namprd12.prod.outlook.com (2603:10b6:a03:423::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Wed, 1 Mar
 2023 01:36:48 +0000
Received: from CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::fa) by MW4PR03CA0325.outlook.office365.com
 (2603:10b6:303:dd::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18 via Frontend
 Transport; Wed, 1 Mar 2023 01:36:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT087.mail.protection.outlook.com (10.13.174.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.12 via Frontend Transport; Wed, 1 Mar 2023 01:36:47 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 28 Feb
 2023 19:36:45 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net] ionic: catch failure from devlink_alloc
Date:   Tue, 28 Feb 2023 17:36:23 -0800
Message-ID: <20230301013623.32226-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT087:EE_|SJ0PR12MB5610:EE_
X-MS-Office365-Filtering-Correlation-Id: 11826479-a376-4d8b-af96-08db19f56bf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e6RcrbZEGZWW7TEZRKm22gpePr6kBU47PAx9nYTrHKlIHMjbViX5ixU+wug3lLq5KBlBSSf/Opyro1qDDrIMOO62PtgkZa3yckTTGvLJ3ddxhtlwvk/f53vc7/P/MnDUTEx/SW4j9P8VSpB1yxv7eMdn5Cp5aSpup5xwTUeT2wx6gfM8oz9sF9Pt+SvCrUtheDpgB3YHDBYwoYP7zMWFf9nHSarQHPCj+ic+n4aw9DnQqkA0c0HF9I/CAm1ibKMWwhU7QWngRh7VunldckejgZdprrTWCAqDCkjkNdYZfdZzNbipAsYt+97X7nuOQcGMAv2eIgAD0ydC4sUd/MavUhYTMpd1fD4kGfcusH4XllvGxBWKNofb4nzt0OvMyb8Xwhj9IBdaQ+OKMK3nZnsOxsDtYn4LNEW3UkH2YUO+TuTftRdaCugpQrTXWiW3oqRGcopfK0BlFKDnOVwOvqy9zuoKoub8INCOMrbfi/uOxrk9a4nJWSr0BHERF83htCMEZq0MWTrVue8Fr3NpHMxgCJIj7d0UONrZsanuMKYmQy7wNMXjxWbnGuvYceXCrmUGsUPDff3CBH+bRaCv2LwacA6gGaHmWb2AFbhp2iBECTfVtj8TntOzvBIemE6v+fySXIJttNnkm2cJyrxl6OYW9roXC7L5byq7kdYkoy/d3RfY5Ly2/1baEYNQIkz/7z1BbYzrRBepagbcWrqae3mcR4AR8EFYevDn+/KXPdaMQ+c=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(346002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(40460700003)(36860700001)(47076005)(82740400003)(356005)(82310400005)(81166007)(40480700001)(8676002)(44832011)(41300700001)(70206006)(6666004)(2906002)(186003)(1076003)(16526019)(26005)(8936002)(110136005)(478600001)(54906003)(5660300002)(4744005)(316002)(70586007)(4326008)(426003)(2616005)(336012)(86362001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 01:36:47.0702
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11826479-a376-4d8b-af96-08db19f56bf9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5610
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a check for NULL on the alloc return.  If devlink_alloc() fails and
we try to use devlink_priv() on the NULL return, the kernel gets very
unhappy and panics. With this fix, the driver load will still fail,
but at least it won't panic the kernel.

Fixes: 919d13a7e455 ("devlink: Set device as early as possible")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index e6ff757895ab..4ec66a6be073 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -61,6 +61,8 @@ struct ionic *ionic_devlink_alloc(struct device *dev)
 	struct devlink *dl;
 
 	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic), dev);
+	if (!dl)
+		return NULL;
 
 	return devlink_priv(dl);
 }
-- 
2.17.1

