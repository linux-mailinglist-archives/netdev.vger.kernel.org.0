Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF3D580C42
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237731AbiGZHTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbiGZHTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:19:39 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788622A96F;
        Tue, 26 Jul 2022 00:19:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNCeXhSHBQlPErxrZ2LQ0K8n/+QuNNVGmC7MW8koZ42NhcFdlFjuG9Vik17Wm7Z2BEgeZ/D4dZWVSCO0fmQ/IJ9RkultAs05zsQvCv9X/avOER9ysJ0v0cFfg0i53yPBbzghpH7LFVf/ioK8s77js4HAQiAqspU5OkpPnfzAk3pvoIbWg0dFxUT0ENYru8y9IlLGKsYxMNRAIhotm+c9gtNl/xIc9obMvBQ7aIlsrdBQ8bdeTVgorcihclpbh//dmaveokmZv8MT1XX/SxoAyOiO6KlzOuz8MCrflVzzbGJ0nDVncWf6Qj7N0klaAeFKM7MB/akAXwkwA2pChidzew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZPrBlDt7dgKpf2CvV5CUED4w1kHXyW4Pq6kqDqXQyU=;
 b=fqnVkIrStZGwqRvY9LJWgDDzjXk7ZiwB0oHET6+jCb7FzpU/esaR12CxRBYzF5eREIL9RbtLX3Ka8feADQUR9VXRzWz+B66A2uhXV20HLdxSuXV0Td2mGuRWl5cYdBhKTZ7QqjivyDL1uHCrxwcdswQDnf0ILM4C+q6b13jZzGZ4mqw8TCNPKX+TmNaSvLPiKhGe9Rb+WP3M8/5R+Oi9+dYu7Q0Clx2AX0F8UUDjWk1/NQda9DSMKS7U011Dj8e7083HCjVdJnhe5o8O4d6ysOFWFB28VHEw6eCA5qnZM1bCqrO8UCllVnmX1oOEHMg7ZXkBA8ban7ur9NabsStTjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZPrBlDt7dgKpf2CvV5CUED4w1kHXyW4Pq6kqDqXQyU=;
 b=fDu/u8VWF/EGhqTbMJPWJNktQhOG2PE48qW3tlB4fySIH8R7d+W6hyz/bXVfM2RbEzJdK9tQX38B2J0ER1mPhq+gXQTaKrUlodGtqFIKEaCwICmtof6np4BOVoZlgKiljnE1wW3FZ9aHIVUDyqmwePoNkOi+kEA66CNoGZt3+K8SKtUZ0ayDEYfZIWaDauUPgYavYGIaGKUnd4Q5WFfEJ3zMNCkEtbkuadmlryk6mN+lngDfo3Es/XT4hBgPt09VPmciItbwUUiT9hRfwf0EEp96/RzJswsdax+4ODDUjfI0rqC55W6Aul11o7wGGA98VloZEIfBPyA9wORJM11F0A==
Received: from MW4PR03CA0100.namprd03.prod.outlook.com (2603:10b6:303:b7::15)
 by SN6PR12MB4687.namprd12.prod.outlook.com (2603:10b6:805:12::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.23; Tue, 26 Jul
 2022 07:19:36 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::bc) by MW4PR03CA0100.outlook.office365.com
 (2603:10b6:303:b7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20 via Frontend
 Transport; Tue, 26 Jul 2022 07:19:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Tue, 26 Jul 2022 07:19:34 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 26 Jul
 2022 07:19:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 26 Jul
 2022 00:19:30 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Tue, 26 Jul
 2022 00:19:28 -0700
From:   Michael Guralnik <michaelgur@nvidia.com>
To:     <jgg@nvidia.com>
CC:     <leonro@nvidia.com>, <maorg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, <saeedm@nvidia.com>,
        Michael Guralnik <michaelgur@nvidia.com>
Subject: [PATCH rdma-next v1 0/5] MR cache cleanup
Date:   Tue, 26 Jul 2022 10:19:06 +0300
Message-ID: <20220726071911.122765-1-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45dfb01e-148a-49f0-06ff-08da6ed730c2
X-MS-TrafficTypeDiagnostic: SN6PR12MB4687:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DkPb6YUx9kxQtEr6FyJzmNeDlevUSX4jtU1il/oUw75CliwRbW44BdMPwAhf8gMoNLoNjw+A0OIObvpYjvHXCegXKoz4Oc2FKPwD2xnklvhO8T6q7YezmF9zW8KisPrxLybFOVBgtmDl+/e1JyWmjf11LJ8zO9XGJFPDfw4Awky6DbB7m062HTwpnF7ywO/Fwx/UgclCbFH1vlhoUTVSF2jI7CJNocSZLpyxOl/BvMIfD5mpJ7fGD04DQuqOioAEN0y31GyX0hKWi8F3nofrfIokysy8cHKE0X5SJzej77qxE+cWUaMjEzoYlQJfIdxA07WbU8/qV+LxNNajfU8fJIMXXw6yHOY1S+VFGPQ190xDatu1QN2DGBRtb+0RBuaXgNu/VB52GSmeDz5z//WP+/PSflxPKt6rmdfMqf+nreu9wXHDEcUrYCWdAsCLWy7GR8xQwxlXoBoLgSKBNvG475k3pffWXsXXwX6Zid/RVL7IRdGvBemdtSc0CeJjFA9L7cMpYV6CHamwI1Yy1POazOWcFwToxuc1ll+3L1pNMnTmqv93JkfiEy/z9Z6zD/74KQA1er+CV1Pu22MPz/7NbJM/xswGwiem0wx50MhyvY6yoRi1blQghOkg0tL/0kNEi9TWiyGaA4yUrKoCZYYqK2T1ht42BhnKsKlTt1TOHE4cpd2OsqGjfs8elf+rmvxR356L4q8a4Vn9PC38ikgZB9+nzGQdN0bRp8yqpYvbDiYrf02W6MtV3M/0CYGm7vHKvKxIOtPGBW6NkhzmCgfD3EaukASPS+6eC7Ya/2mX9oWhtEBq8hVM+MFm7U8dkhEV3egAUiPFHjK9FClHohdG3/2a1ti5+yat38FgZhsR9rRzw9s7u7cOj//KEgQkUgTAxV8TtkI+9VMHHv2SYaMWB0mXgd9EUsLdr0vvkpiS3VY=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(376002)(39860400002)(40470700004)(36840700001)(46966006)(5660300002)(8936002)(70206006)(4744005)(4326008)(70586007)(450100002)(7696005)(82310400005)(41300700001)(40480700001)(40460700003)(86362001)(2906002)(6862004)(8676002)(36756003)(81166007)(6666004)(47076005)(107886003)(336012)(1076003)(356005)(83380400001)(36860700001)(426003)(54906003)(2616005)(316002)(6636002)(478600001)(966005)(26005)(186003)(37006003)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 07:19:34.0298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45dfb01e-148a-49f0-06ff-08da6ed730c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4687
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

In this series, Aharon continues to clean mlx5 MR cache logic.

Thanks

v1: Change push_mkey to eliminate locking on mail flow
v0: http://lore.kernel.org/all/cover.1654601897.git.leonro@nvidia.com/

Aharon Landau (5):
  RDMA/mlx5: Replace ent->lock with xa_lock
  RDMA/mlx5: Replace cache list with Xarray
  RDMA/mlx5: Store the number of in_use cache mkeys instead of total_mrs
  RDMA/mlx5: Store in the cache mkeys instead of mrs
  RDMA/mlx5: Rename the mkey cache variables and functions

 drivers/infiniband/hw/mlx5/main.c    |   4 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  61 ++--
 drivers/infiniband/hw/mlx5/mr.c      | 514 +++++++++++++++------------
 drivers/infiniband/hw/mlx5/odp.c     |   2 +-
 include/linux/mlx5/driver.h          |   6 +-
 5 files changed, 307 insertions(+), 280 deletions(-)

-- 
2.17.2

