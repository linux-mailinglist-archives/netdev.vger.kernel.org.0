Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176CF49B16F
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243397AbiAYKQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 05:16:48 -0500
Received: from mail-mw2nam12on2045.outbound.protection.outlook.com ([40.107.244.45]:31201
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241935AbiAYKHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 05:07:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QK34qnXRa/K5tvNkFblgs6XGOv8EUsQyDQ/WkVi7HUHxxujqvJ5prU3Aqcng0P2sp213QdmBzf2fCDWJJ8ejk782yA+fRvvHm3wAmkpXLaLCpg3RuWBjCmy4Z/xHFG+BW/v0XhKuNrlEHEgQkkf7pK/cpi04D/arszqQWtdz8vurUEzMV1Fh1kkirgGEkDrHFqEWt1SP5gh0CLPBx5wLD5JT5ouEGASyUFXiEqXZeyAgAeSPYKKFl6YqGf5Xdv9zV9BsDtTnedivIwopDz1BIb5XE0rF68rn8s5GlW8UoVfFP+bqUDR62GZi9YugB3vWfa4kPG4c9Fx2vTEaD3taEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6LayzCh38zwtBp/UVxSfequOAk4uaEFm0D8zYrVkQg=;
 b=VXbPf97cG5NVS4UAzM5tLLeV4fgXB4jJBk4ePHXvX8dEWycsreplB+8nY8KWRTcFRSTt87zHAtsi2XaKqcSqZoRE2dhMcWbx1FYm9RQciz7FMQ+pYqdJOoz4euLAkRyGl9xSJD/sI3e+2ME143kEVYiP8v28uCEqCn1j9uRrcnwO2smza2RHMh0/TqfJWNF9SzHzg/nVVspvhWHsbKiBeFxs00GsosnZ725aLWdpukIcxS+iZBHS7DqH/4CpYNKO/f+jmfVIotrjmLQ5rJ3zptt6e6s48EuLiXNbupPiz+fZOUOGxbM97w2e1W/YIfDdObeOrlmXLfeBhZz5WOJeGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6LayzCh38zwtBp/UVxSfequOAk4uaEFm0D8zYrVkQg=;
 b=UZzqiuqEsoY6xfsOqHXe5zBDKXJeantngdSSFGBNiCYtAgt0alLwgeIaE5kOPhSGytYnL41zso+By0v3qjcSodurqE70E9yLFZ8PUCbN0aog/kjuEOeg6VxKDzTV96yy0XHajb4ohpGbJztZp2x3com3ejBj6YULpLND7+Myg4zDm0nAMjwr0Ng5dJkHEJw0QowFyU6HLFVfZyFpI/NqDutlmbLyQXlGBNfT0tcZxXBEqbebJn7qH37sIqVvi8cXR58DxPQxNfeV1JLEnHRDxPLrRmC0dfOXKF01sBryjZdbj4R6xnRgg6rPtXByauicyABsjRLLQY/DX90teJPwBw==
Received: from BN9P222CA0006.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::11)
 by BY5PR12MB4290.namprd12.prod.outlook.com (2603:10b6:a03:20e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Tue, 25 Jan
 2022 10:07:17 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::f) by BN9P222CA0006.outlook.office365.com
 (2603:10b6:408:10c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8 via Frontend
 Transport; Tue, 25 Jan 2022 10:07:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 10:07:16 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 25 Jan 2022 10:07:15 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Tue, 25 Jan 2022 02:07:15 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Tue, 25 Jan 2022 02:07:10 -0800
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net] sch_htb: Fail on unsupported parameters when offload is requested
Date:   Tue, 25 Jan 2022 12:06:54 +0200
Message-ID: <20220125100654.424570-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8688deac-94c0-40fe-ef74-08d9dfea773f
X-MS-TrafficTypeDiagnostic: BY5PR12MB4290:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4290B025C52E988BFA24FB95DC5F9@BY5PR12MB4290.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: auakZRgNI1OwElPs3CPnbUTVIeAeuKOXJWl0G/ex9nCvyCrX2Gfwb1/DgV9hTAPtnnAGBM6TR+xEKMMw7TwMi9Et3UiTYqQx80v7yDROgDwlmUT95LYQzZNTE8jgA10+MumGmmB8IVjY6CY08V38j9IcvjDYSi/66xWVwtMzxrYB5HOsXYW3HdBOL7PSymHp/57oRSHfAB2zKpCXcWBdFtbyuWu87IML6khLO9qGkbBx0GNagYc09muo4On4uwgC+59hCCMHWYfxh9Br4HxnH4DNQj4VA9vdqQx4gMQZb9dVsJy7G8Q8pe2mziHxx9bJDnqpdyc5Bl4Z34dwy2lTEsaM5tUzhXKxj9dHlQsf+UUQhB3fFTQ2lnb9qDBACiuRVtEaV/beCnooUm2RS5ef/fvHokCLR9uhhdPdLdpYvpFdA1N2WIm0Ko2fIHbRsT/tR6hZK60UPIkIexgz1qBZdy0MPmEMXu3gr4O9fbYLjQ6rOPJ6XChrdwHs2hQr/RquPRa8FJCORg+svBl1tHkv/HH3OZ71b1AsyimeEHOqlhFOV/LasgrNTVsFKbk604mNcny+crD56iLy8pIxhF7Q0XrWe74u45GMPhTmLRdrRoUk3k43QfxFw0LLttAmeKagmWygQkaa5mS7CR2chY1TITx6y/7lXYU9Zh4U/z7l7ZUzsR4W6kjH4PJHcZN76uAxhJ7DW9q5tihW47IPHFicyxDeuofZLwuTSt7IqdrU4Qq3PvhrK5Lo9vk0cl15J34ZPChaz5yXG2yLLKM+O2123j+ZuNBbO1AJ/WH7RgQhtGI=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700004)(36840700001)(46966006)(107886003)(6666004)(82310400004)(81166007)(186003)(8936002)(70206006)(26005)(508600001)(40460700003)(47076005)(70586007)(8676002)(336012)(1076003)(36860700001)(426003)(4326008)(36756003)(7696005)(83380400001)(54906003)(86362001)(2616005)(2906002)(356005)(5660300002)(110136005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 10:07:16.2218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8688deac-94c0-40fe-ef74-08d9dfea773f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4290
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current implementation of HTB offload doesn't support some
parameters. Instead of ignoring them, actively return the EINVAL error
when they are set to non-defaults.

As this patch goes to stable, the driver API is not changed here. If
future drivers support more offload parameters, the checks can be moved
to the driver side.

Note that the buffer and cbuffer parameters are also not supported, but
the tc userspace tool assigns some default values derived from rate and
ceil, and identifying these defaults in sch_htb would be unreliable, so
they are still ignored.

Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/sched/sch_htb.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 9267922ea9c3..23a9d6242429 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1810,6 +1810,26 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 	if (!hopt->rate.rate || !hopt->ceil.rate)
 		goto failure;
 
+	if (q->offload) {
+		/* Options not supported by the offload. */
+		if (hopt->rate.overhead || hopt->ceil.overhead) {
+			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the overhead parameter");
+			goto failure;
+		}
+		if (hopt->rate.mpu || hopt->ceil.mpu) {
+			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the mpu parameter");
+			goto failure;
+		}
+		if (hopt->quantum) {
+			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
+			goto failure;
+		}
+		if (hopt->prio) {
+			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the prio parameter");
+			goto failure;
+		}
+	}
+
 	/* Keeping backward compatible with rate_table based iproute2 tc */
 	if (hopt->rate.linklayer == TC_LINKLAYER_UNAWARE)
 		qdisc_put_rtab(qdisc_get_rtab(&hopt->rate, tb[TCA_HTB_RTAB],
-- 
2.25.1

