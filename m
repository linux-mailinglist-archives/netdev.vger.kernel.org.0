Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889AA5A5966
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 04:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiH3C1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 22:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiH3C1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 22:27:08 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2047.outbound.protection.outlook.com [40.107.212.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BFD9E110
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 19:27:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VomUrngMmvQbLQkxBdN8TGIby2CMbnXcAqYfccdpmwYjUjG28RQZ6yCdvIFwAfJD6GUIFiVgi5PHhQCt2aJ5ybIHN9BtIcoaZNKymmYLtdPNqgGHPZ+7kLTU+mCRdXDvcwr+CN/9Q0TposOxnM65ZBh+/VGUohGwR0ky+nvr+bgkqcgyMXTRExVtG0n7oRLsdZ6BWmIGQs1itjCUHhgfIWrvtlDudQxXayJbcJtY3MNu/hMtTFUQbvlvBZ0xU8BBwWpNNfkIoeZHXAgBai1A1KylQajMKtTD/aEHRHKGIjlWUJH+8+AJ6MJxsrp7VTVEfp96qdyvd4vD91uINnHmdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l610MN/Cc7d6YBUHIUe6/7GnbyR/mP/YRiWe+LQFMkA=;
 b=PqLrc7FNdVdzFBXl1vwVARH2opymjCRurxL5jbnQnJbRl50uAciwzpF6bV/vFVNPlGXZdGwQhH3L7YXl++SrNpXPdrXDN1bhZQ0X4VJd8e/ERvitfV2d07Af5zoFOZM7JMWK+LggdDJWBI9CkyvhKj6DZVHpx7xX6UW9D1VaS+9nS/WxLt6Orxxr5zDaLy6tNiTTDTaJK7RxEJ8aptjsRIYU/QtPMd/FhdcYkY1EfZyZUZRsMLvwF++y4hxLAfhhLzow+TvP8PARKmKsF1Cw43n5kuWSbh7HhRJRWQViOArbYVXHdDI00XjCkjuuhNynrz1yP0uPLi6a85yMB57Iig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l610MN/Cc7d6YBUHIUe6/7GnbyR/mP/YRiWe+LQFMkA=;
 b=XSDusbvQtknKtgfqbHTLJsTaCnTYpW/bLPP0avMdvYzVVaLn0umMpoEPtpkdovSjGOtkTRbvu+msKExbPq1cggnXIPP0cqwl2RXY9eXc/ROSR/KcNCeoJF9V6o/ZUxwKWudHaQ5MRdljMUVVkJD7ARxwD+NOeVQXOFt+h0/BNQ1I+6HeRlNjNBBfNTOXVD+LerojAN7kyYH37F7HAxsw9S5e9o3QOwLsTGlJHxgKuh0iAQYiZhDovH8FJHMPtUL/dB9FcjIXExlVEq9rxDsF3i0ix7twmNf2gHAf9TBMq6ky3kJnNtQT0u9WHu2JoB3JfmZMNwSaZAJlQ7FJTcgZ2g==
Received: from MW4P222CA0018.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::23)
 by BYAPR12MB2999.namprd12.prod.outlook.com (2603:10b6:a03:df::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Tue, 30 Aug
 2022 02:26:58 +0000
Received: from CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::4) by MW4P222CA0018.outlook.office365.com
 (2603:10b6:303:114::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Tue, 30 Aug 2022 02:26:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT048.mail.protection.outlook.com (10.13.175.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Tue, 30 Aug 2022 02:26:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 30 Aug
 2022 02:26:57 +0000
Received: from nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 29 Aug
 2022 19:26:53 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <stephen@networkplumber.org>, <davem@davemloft.net>,
        <jesse.brandeburg@intel.com>, <alexander.h.duyck@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>, <mst@redhat.com>
CC:     <gavi@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH v3 0/2] Improve virtio performance for 9k mtu
Date:   Tue, 30 Aug 2022 05:26:32 +0300
Message-ID: <20220830022634.69686-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb56a87d-808f-4088-d2cd-08da8a2f1d01
X-MS-TrafficTypeDiagnostic: BYAPR12MB2999:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: meVWtjWK9fSOxbHFvziSH20RpV38LV1YW8Ua754LyynK6LvPa0iBziq6bWURkh9CJyiyUD/TGGlYvs/s3nsm69EXTe/rU1m+AoBDJ+RWGxEhFDbkTJjGpqe9ST9RFwpjAXGvrwpjXVU91ihTkvdq5O8m5Chy3ZImTwJZ5nI3SDxBKNzB9wY2/d3ZV5kiprJqC1Q6dsaGDTNL5GfFAPIV8sANqX7jrYGn4QnD9h+MzpRhFon7WVZJhyd4ZjoBFxGUYgD+wWO53+40392UdXBJChHFUYuQBTVwYazNuot3jO8S/QNA84gq0YHufHVcY3HXozviK/orgdOJjXFcZRVDNKIDuA2eGhObGjGT4elV0FQxvjE9T0DdTQhR5Y8ze62XTwgYn0GP7j5ER18q8luwBqCuWo9zbtSKf/oCF48Ff97znkLDRUNvusQiuhqa0mV0Y5QUxZqAY7j7I4xPIQncKHVkS9EBNaVqM8adsAZXdu+92FRXAfxhJK3ABRr64a9TenmJbnmsm7pm86mgMXK4/+HyZgisYHYB908jKUWZbGgtwmRO2ZyxTrV/PqM9f1GKUqS8G7ecYzX/LP7s4lKDBbK/vas+4GD9qoez8yfZQsZHTEBWuSUuWRNfoqvOZ0/mz09XT9WNESkqi7rCCNkWZ/r0fi4/59kY/oJ6cxaEWZpcXVVWVS0j5rdguhAo+nNbFjEWEejqxe0FokaUzYWZZLwpwFXi0J0b79MqOcfqLWH1ooqk7x41uIgsmXFFYokIZzxV03+AUs0Txyj1H6nZ2EsfkKqRFyrJbfVtPiSe6eZ9iYU3i+sYVcNkLMSLFrRS
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(136003)(376002)(36840700001)(46966006)(40470700004)(36756003)(40460700003)(81166007)(86362001)(921005)(47076005)(336012)(1076003)(36860700001)(16526019)(186003)(356005)(426003)(2616005)(82740400003)(5660300002)(7416002)(4326008)(70206006)(8676002)(70586007)(2906002)(83380400001)(82310400005)(107886003)(40480700001)(55016003)(478600001)(7696005)(6286002)(4744005)(8936002)(41300700001)(110136005)(54906003)(6666004)(26005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 02:26:57.9851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb56a87d-808f-4088-d2cd-08da8a2f1d01
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2999
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

