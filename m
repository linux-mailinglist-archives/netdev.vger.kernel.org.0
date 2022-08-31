Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11635A7E3B
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbiHaNGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiHaNGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:06:08 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::60a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E2FA6AE8
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:06:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKig6cninnznkjuZOaYzuXKK4ildljAutN/vT5zKIreBD8V3Dl6gORL5awIkclQatgPyAUIKZgXl4w4uMV0dCJBRyezGnQ4fY7fb3rnXYHH7cbTAVFwCr0j2RXXdCmH0lrb1lCD8XaAc8f3lqtaQIzqTbNYCAx4HZGdOUN9Pip7fYCJ1IN+qIfrjxmOz6kGO5QCEWqulbyY6kd8Mp8SIUnkXUw31FfRyJVTy2Teb3syOAR770MYnQirwFcjyGWzxainJk778rbAQpqVmxRGjKqD+THO2tEV4lWZ1KuC6cLQIxxqvWTwu0TGHTSO7K4r7r/VosC3ZDRRSGcUcMnBvyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l610MN/Cc7d6YBUHIUe6/7GnbyR/mP/YRiWe+LQFMkA=;
 b=O44rF+bVyySwsK2O4t4oIcN6OQ797lCDx6VROsU4zSpmDpL9m4Ux+U0mSZ8ARULV3KxN9hFuFMad5XfKeQf7hmNjCD8dBAonupbWs/214UhKbhm4P/dmgwIxKTp9o+u7AG6MSRdR59fi2hK2KvwQWc8M9z7lSBln+lK8OmwQPDvVHA7gSVs4ApZazYxQ6t3EUqoxLTIDG6bZhYTYZN0MBYgFJP8wM/E0wKNZrifWRNMYG3XHXSw+WjW33JZGy5Df4xPm6CJH8/jMXZf6AaP1qrvvzhKMYED0ZfPZ7glnSlFu+qneJ8BE7UJ2QkNpdXfoa8RErLTEckfX87ZqYxQA8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l610MN/Cc7d6YBUHIUe6/7GnbyR/mP/YRiWe+LQFMkA=;
 b=YS7jDxBrajYwmxacZZqZWQ/XHcVZvqPtxZNVb88DFXQG3d8tOsHsoDRCpoVKxgajFoq0MEs5TgjmNtzzQVPY+JZX7EUKxVzL8/t24qybux/TI8JMBeXS4LjLjvcUaIk6SYP5EX+gacpJO8+mL8Ufvol6sC6rGi8zjFbys1rpivXz5MfjetwBfAOpl+1gD6GmJinqvbjbCK14YrkW8U3DdKjGiYngUyK9afV/y2kOp9JdYCr8kJtSSFJP65MjseZHGFp/kGywxVHNX7NwwW9a7OhjikwI6ktRTo60SKoMWz0MCq9cm6M/E2uN3ydvEkjpn83k1H6Dz/XDtglP3UrDFA==
Received: from DM6PR02CA0082.namprd02.prod.outlook.com (2603:10b6:5:1f4::23)
 by PH7PR12MB5596.namprd12.prod.outlook.com (2603:10b6:510:136::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Wed, 31 Aug
 2022 13:06:00 +0000
Received: from DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::fa) by DM6PR02CA0082.outlook.office365.com
 (2603:10b6:5:1f4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Wed, 31 Aug 2022 13:06:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT080.mail.protection.outlook.com (10.13.173.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Wed, 31 Aug 2022 13:06:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 31 Aug
 2022 13:05:59 +0000
Received: from nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 31 Aug
 2022 06:05:55 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <stephen@networkplumber.org>, <davem@davemloft.net>,
        <jesse.brandeburg@intel.com>, <alexander.h.duyck@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>, <mst@redhat.com>
CC:     <gavi@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH RESEND v4 0/2] Improve virtio performance for 9k mtu
Date:   Wed, 31 Aug 2022 16:05:39 +0300
Message-ID: <20220831130541.81217-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f55053c-e8ef-47df-62c1-08da8b518d63
X-MS-TrafficTypeDiagnostic: PH7PR12MB5596:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fvKMuhL/fIBcQnbq3HtxvZSHU0p5wo3FP8D3GnJngaD41Gq2hqalhX6viOqJw/tuG0GrN8PP8bkXOwKXhAw77TavKLNNpnu9dKOv+n8XwqYQ68tOWbp0tIl12AsAeOq2LMGQm5zo6PKPE3TytdwUJFcF6JSVntqVoqSXw/DUkojjsF4WT0Cmd9HYrsDscaLS0eV754wsyYpG20g7CwBNdQQoSQAMSZVdXIVkZXeWhSHoZZl5TZhBV4GnxEWprQwHJSyOaPbivo7v8mTJ9czeC86KIoTYJQwirC5D8dBWxQvX+HcWB9/R44DXW9rqCSbeRISD3cVnhxHNGZ3ll3tieGE/cHoIJcACPIYByxxIHakCVyipP1IRssw9CjPfS1mmqscy9P//l6ajC06DPhsyDbNNyAeV/UGMmA+9VptxRtJMA4PS7RwNdSPvBQ2+fAT8HGLgIGMv07ryEX6xPIj106yrl9WZt6BulUEYC/qDFJZCJEUqHR6vKETbMR1LDe4S26EBZwYZKPhrntKa84Fk+gtLkgb+/OR5xwTiI3xQ/D2lhGvLdxTTRSA6b9Mq571DjTbPlL6niJe1SkmSyfxwy/7LvIA4GRDUpXbDAcxskzGQjb0lEub3HyWcCVZ1B5TF5BnottRD3cFoDgB5apbwKxCle4G1NUOnhRLU3EqFNXTA1pHmteV5+x7GxtIK+ltXUJKOQorGN37rXQzqKIxHx5a3MlRo0hPj+dQTYYLANCdmp7vFtWl1p8TKEh/SHkZWOSJOYOuoa3TnLzYrofnCDpXrlGAx0EahcORzWVWJo6Cf6zthtPhxS1VU3pVz+Pj5
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(39860400002)(136003)(46966006)(36840700001)(40470700004)(40480700001)(4744005)(40460700003)(55016003)(2616005)(70206006)(82740400003)(83380400001)(81166007)(2906002)(47076005)(316002)(54906003)(36756003)(8676002)(70586007)(4326008)(110136005)(336012)(86362001)(26005)(36860700001)(6666004)(16526019)(426003)(8936002)(6286002)(107886003)(478600001)(1076003)(186003)(82310400005)(5660300002)(921005)(7696005)(356005)(41300700001)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 13:06:00.5652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f55053c-e8ef-47df-62c1-08da8b518d63
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5596
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series contains two patches that improves virtio netdevice
performance for 9K mtu when GRO/ guest TSO is disabled.

Gavin Li (2):
  virtio-net: introduce and use helper function for guest gso support
    checks
  virtio-net: use mtu size as buffer length for big packets

 drivers/net/virtio_net.c | 48 ++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 16 deletions(-)

-- 
2.31.1

