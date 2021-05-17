Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7622F383B1F
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbhEQRVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:21:13 -0400
Received: from azhdrrw-ex02.nvidia.com ([20.64.145.131]:52738 "EHLO
        AZHDRRW-EX02.NVIDIA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241395AbhEQRVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 13:21:10 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by mxs.oss.nvidia.com (10.13.234.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 10:04:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TvywYmge6rDsHpeUzVXiGbYmLB2wE03N/lI9FonoD3A8K5QJAc9bNzJR5BQ5e40Qipe3WzkCCF7UkI2EpfbrbNEBloXsGDzhbtyCVUKhgj4ip5pb3FytHs6wPp9ZlTyRDt8cwnlqVAEDFuVrxsHaO4SeZzmNDKq8BYHliYa4A+XV59ZLHKOIFQoInw3jFkik3lGvP/KGcV6IgyMSQMEX3Hy7hZbUndDMiihho9czkXD+mm9V9+TN3t9w11HRXDAxJN8a+nCUFlSaxdPDlOOCAHJ3fc41N/FbeYAoUOjjiZoSMe5DyheUDfCxd0O9XCScAICoqZy8QpBCaW9c1zT3MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLmhMjFUEeSsSHwoV9tmCg1B45heV7fvMPf8uocmN+I=;
 b=m8JMO9xGbyBdgo/RgX0glWaRp3WPYkk68mAQa4h0je2/uqwOKfKhzUTaK0XiAzrO6RtsQ3lvkCmX7s+7YyzWHgWcV7Rt2TFQd3Y6VyFs4f6eFzx2UWCKx0TImEU1VkEiuadryH+OPvKERVr8hgD/JkYTVCcta9z8EFS0vXNMOVvDiVrxWUkUl988Fp3/23cwTwjqsVKU8nVIE0IwootkR/M4TO2BDjNvwMLanpETLAAySLoHTNS9NscMkgryJpXo7YvW5clFQweUYzjkIiqXrtaAkF6fD1+58SSl8W04pov+Wh/lcc/kF+UhVYlO5kcfzYhn7Pq9JkPxSci0+EKnkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLmhMjFUEeSsSHwoV9tmCg1B45heV7fvMPf8uocmN+I=;
 b=ecVNoPUtoh+ABX0rDxBeW3CsUpPwd221cDUB4XyJfseIvc8Nru/Hn717XBG+mlxj8Lrh+TAbdnN8WP6A0F4XmNq0ywyKXeIAuQn2aEmINmC0Z/1aLVQo86tLlI2BmT2+YnWJABtRzvIOlMim+HlkpbJIw7nM5HsUpja2D9vsIL6VSBz7IvpcN5EvbI7+NPewJfI/KVka7OykQ6Xt9q8FQ7Ew/wC+ji1WndZJOIqDXXsf2mnyWorqgyVhKHg7EYMJcc3RlWqZ/uFgYOzbnEGCiVwWkUfmJe4oOubMbOFj4PCM3U0xs5FwQGFPAPWqB+u0GozTB3v+03FLCWre7tz0Nw==
Received: from DM5PR2201CA0002.namprd22.prod.outlook.com (2603:10b6:4:14::12)
 by CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Mon, 17 May
 2021 17:04:51 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:14:cafe::b6) by DM5PR2201CA0002.outlook.office365.com
 (2603:10b6:4:14::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.32 via Frontend
 Transport; Mon, 17 May 2021 17:04:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:04:51 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:04:48 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@OSS.NVIDIA.COM>,
        <petrm@OSS.NVIDIA.COM>, <danieller@OSS.NVIDIA.COM>,
        <amcohen@OSS.NVIDIA.COM>, <mlxsw@OSS.NVIDIA.COM>,
        Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 05/11] selftests: mlxsw: qos_lib: Drop __mlnx_qos
Date:   Mon, 17 May 2021 20:03:55 +0300
Message-ID: <20210517170401.188563-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517170401.188563-1-idosch@nvidia.com>
References: <20210517170401.188563-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b02e72f3-7021-41f6-3f6f-08d91955e2d7
X-MS-TrafficTypeDiagnostic: CH2PR12MB4181:
X-Microsoft-Antispam-PRVS: <CH2PR12MB41817AA15E9A37DC0E90D5CFB22D9@CH2PR12MB4181.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pqpryHnhcf3uK3TVUW7wOsX3GVLpf7TiRrGM4SngclQGETrt4Dr1KdEnojhuTdL1qZ7TZLmL26BEoYoGa0Rzxjx1awhwFot6s9K/QV7GF48JoxVv7yNPNj1r0nPGisQo0WNcxh1oyJwmwrDX2YA0FGi+XfKQQ+qc1vyABC+NM/EQA0Kd8at69D6z5opWQaiqZTVnw0q782Fgs1fab0LlLFiVCj9CCSFIpHzlUOsPH2EuQN61UVU86i5Lq+rhBgwJxz0zMQl0wrzKr7cZZxdwP1FJQHq3ARtexInwJabbGW3FcOSt6e1YjyA2GHH/60ofoEPsM6ABiKe5RfkDgMvmh5q8Rme46+20SMpWGAbczQ2ODrpq1z9x3CvhAgfN1OXszacbgAaQiojwcZ8/1cPPCBPbu9zdbtePSwbiMWO1EP0cQEYFSCUPYaYPvdxu0tMZucgpOKmLx9hzfMR3Dam5uDNhyPVYErOwn3WK7KI7ptqV8eiTLObzfwsClji5ps50Yuh2aEdUH4ZuapavLFQbRgvx2rOZpTVFW+kyZS28vEmhl7XznOofgBfz8PNZkAd7EL7i5UlelZz8F+0I9FJ8DNPC1s+Fzgbt9eAWZcHE2lZq8eGssVgW64hcZAeks3intiNPleGFyaPT/lYf+lm/jAgFKs+PH+IU1rzju0OWpJs=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(136003)(46966006)(36840700001)(82310400003)(83380400001)(82740400003)(7636003)(47076005)(36860700001)(86362001)(16526019)(70586007)(356005)(2906002)(4744005)(5660300002)(4326008)(54906003)(1076003)(36906005)(316002)(107886003)(426003)(2616005)(186003)(8936002)(6916009)(26005)(6666004)(70206006)(336012)(8676002)(36756003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:04:51.7308
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b02e72f3-7021-41f6-3f6f-08d91955e2d7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4181
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Now that the two users of this helper have been converted to iproute2 dcb,
it is not necessary anymore. Drop it.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../testing/selftests/drivers/net/mlxsw/qos_lib.sh | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
index 0bf76f13c030..faa51012cdac 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
@@ -82,17 +82,3 @@ bail_on_lldpad()
 		fi
 	fi
 }
-
-__mlnx_qos()
-{
-	local err
-
-	mlnx_qos "$@" 2>/dev/null
-	err=$?
-
-	if ((err)); then
-		echo "Error ($err) in mlnx_qos $@" >/dev/stderr
-	fi
-
-	return $err
-}
-- 
2.31.1

