Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D84414525
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbhIVJck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:32:40 -0400
Received: from mail-mw2nam10on2086.outbound.protection.outlook.com ([40.107.94.86]:34913
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234268AbhIVJcj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 05:32:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ov2CCQOiM57vTkAnX/n1TbeLKt2UMCcRboUnJHBBU8I4rUhOvJH4BT2G8eazIaA53OReRHr3eWV2EZ8dct7DxQNTypbz7uO5HICl+bqE2Fe8AMNCcQrJWrENijjO8m0j2CHpJMdTEsigB77Gn9I4qMMCirxVajCKnQf9GNksZidMTlEVzJr8sQB7qmkNwN9ng2SXpLkmzqhp+Z9KOPGvQKBYrHcDJtblh0I9LsehqhtmGsr8ceiHPN+21DZJ4jthcVVos0Jv3sQ3P7+iOnxLjKvt8m9j8C4zqoCWAWVk2Z8rvASWKFmFlBhH3fS+IByRUhkP85QVWtiA/vrbWqL4NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zXpASqH+1illgAJcAaM76eEHUxCuRv1yBbRm1p3K6Qc=;
 b=QtK9XrT5jobNkKGYrjWjPH1Q+ampwku3xbGEPIWif0p+Kl68z0jLXt98R+F0mQr2Qmk1kbNPzG2eP44TTEmvzGS4rqfCsxjyfEF0Ud7lRmxQMej5FXjuLyb+QQrHRy4DzMhCu/y7C1835vLhzTTigxvmaJvkWfeNsWfSMVfoO+ULP+HUKDjU4tA+ZfnQI89untmXGBmQ+Nx0pfRQdE6vF2rXArie+IXrG3rnb8qei7JrUHexau7mhQuAEa7Kvz7NPiOjIRf7JudGcKlIYrYuQOlOuRhAgEKT1dB5uW4T+ktWnV3WV85rph6SX2T9FuRPFsORXFPSyVt8+eYJn2FKvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zXpASqH+1illgAJcAaM76eEHUxCuRv1yBbRm1p3K6Qc=;
 b=Ab1k/vMfJKZ0//OosT/f5VH/6AjULaCvbmL0ZEbmviXQ58FJCz/1iOvD2uq32tkJFKU5tOgqCw30mvB8Ri0RwQ1uz/ECeWoL84rlmXnpV+1Jv7wTkEcrqvu8YhjgDGM+t9GZ7fae1Qcc1Gm5iIyr0KYSn7sjEbtYFyDHr5r5B9UnObL/+LoRrQVfUw5QG7BaJI4zdtSE5iAptPZQ/+PmnyZ4OF07FOgJKejR+ZyC5/QwqzVeVM8mj9F1E/PDLliqU3hjiPNTMRCI4JhmxN76IPLJVT4mR3ne8SCI3JmERPprLz2o2a+xR+5KkyoDKV7jWgDUuD6JWNnZxAdQi+Esrg==
Received: from DM6PR03CA0041.namprd03.prod.outlook.com (2603:10b6:5:100::18)
 by DM5PR12MB2487.namprd12.prod.outlook.com (2603:10b6:4:af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Wed, 22 Sep
 2021 09:31:07 +0000
Received: from DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100::4) by DM6PR03CA0041.outlook.office365.com
 (2603:10b6:5:100::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Wed, 22 Sep 2021 09:31:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT029.mail.protection.outlook.com (10.13.173.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 09:31:07 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 09:31:06 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 22 Sep 2021 09:31:03 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <dsahern@gmail.com>, <jgg@nvidia.com>, <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH RESEND iproute2-next 0/3] Optional counter statistics support
Date:   Wed, 22 Sep 2021 12:30:35 +0300
Message-ID: <20210922093038.141905-1-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a970a82a-9b61-45b3-ec76-08d97dabb4c3
X-MS-TrafficTypeDiagnostic: DM5PR12MB2487:
X-Microsoft-Antispam-PRVS: <DM5PR12MB248738AD1B4D45A64C491613C7A29@DM5PR12MB2487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qjg5a9tpv8gRZ0Tladtd9qfw+T9uoUaidre+Fjy3sTzqy1sfx1xpE17I7cNk6HxUS24/Ayvd96RPN1dc9sQdl/flZhDs2CeqZCWvjCdmNqu8M5UYrgiQr3rVXePAq6LGoeURXhX6mShJFufy8q7P6ctVBgyUs6Cgj/7OXxhgLUGXNSEmITkD+hzQJqbriz2rKQm2XMO/TThJcdmo5lrVTACe5ACStca+fkx2VP22ZYh/vLj8ebTfmIX4nelUlE+YEwNYeM43OzHocJO613y+4vY8DqpofZn/zG9GE5Q9WdWqh8wnTZQfb/VG2hHfe98er3pOpQbGwK3nngG8KeHGcQtPzCi4IH0y2XfhM8EwfX+2c6uEt7lY2wr6GWyShmASu8pQEG9lTBgs0JnbgFy72aaTGukyu2pArOCSxQZhvdZQ9XgojR66V+E/VRtZAK0/cymwWxUOg/9KKNzepdjNwGOTXiGRMOiExBmF73Gnh6NUkIDe+p+VrUJv2qckY8RFUO9dO3GOMhPmmvvQUqpR8MVhL8DGX1y9Mg+IDGYPSHoLZ20e/oMDo406CDezgCpwHEXPwC3Ln5/XB8oT2O6Q9olBvI+PSjt534AU+xoO//NYpJc+Eha/R8ti0F22aRreRAwxxjM6Jru0ft1AIKeWNlVqxgua7foDJF3PKzhMuvQfvDTKqjldrKzm2VmlVKI/0ptADlPDASBhvR3Qa/hhK/oMFjcx+npgKvwG23H9PNp7nle57NU51y6SoeWnf6ABOTaa+5DLWUujmUeBA5jyzA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(5660300002)(70586007)(316002)(36906005)(1076003)(86362001)(54906003)(26005)(83380400001)(70206006)(508600001)(356005)(2616005)(7696005)(107886003)(8676002)(36756003)(7636003)(336012)(186003)(2906002)(426003)(82310400003)(966005)(36860700001)(110136005)(4326008)(8936002)(47076005)(6666004)(4744005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 09:31:07.4135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a970a82a-9b61-45b3-ec76-08d97dabb4c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2487
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---------------------------------
Kernel patch is not accepted yet.
---------------------------------

Hi,

This is supplementary part of kernel series [1], which provides an
extension to the rdma statistics tool that allows to set or list
optional counters dynamically, using netlink.

Thanks

[1] https://www.spinics.net/lists/linux-rdma/msg105567.html

Neta Ostrovsky (3):
  rdma: Update uapi headers
  rdma: Add stat "mode" support
  rdma: Add optional-counters set/unset support

 man/man8/rdma-statistic.8             |  55 +++++
 rdma/include/uapi/rdma/rdma_netlink.h |   3 +
 rdma/stat.c                           | 327 ++++++++++++++++++++++++++
 3 files changed, 385 insertions(+)

-- 
2.26.2

