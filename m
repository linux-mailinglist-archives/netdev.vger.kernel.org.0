Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BA44F79F8
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 10:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243199AbiDGInE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 04:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243196AbiDGInD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 04:43:03 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAD33EF2B
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 01:41:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJvlWEuC6GbYTvaeVi3RTQed5kKUk0d+ZpDcFsCnVRA6IXuCRWbTxZ2Y9gX3UFv6NPHRb3e4VgMCU4qYCv91MIj9jx2EVqhiDK0TQozli8G7+JEdYw1aWNNmsHbWb+zfOSa2OZ6gxH0ncx45SRxX4fNyckvAHTNrdZb2QXlzXIDKoH2D1GrkyawkqAc9Qoti7jAs7kB90OEDevQ43pNl5SVtOrHe08Q9Ee7ILS7RqUrapbOvB5V4Pg4jlT7E2+POP8lmA7+VMfM6Ny6pgO9n+Y7PoQc+NtcCZPiMbAPJ4wtUkIshua6o5noMQD+CIjVEAgVdzoWMFnyLZdSPOTxVag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5QYdghyUpU7WJFrR/qu5tpdGBfQwYdkJdqZC0M9JyJ4=;
 b=bsLVg0wo9xj2dNPLx4bj+azowA4AWSpYmfXO5n4G9zRP4Or59ajIuwOMOyGoJveL1Bvsm7WTg9i6MqS06duxJ0Pwa0TeiKwaYiGp4qOtbrq9ToryipVTKZh27Fjb05FB9Plhq3TiXAYwev2EL7blDrFAf0Q+kITbJ7Hua48IEKJH2SrWcYGiBtPHx7ehy2yjjP4ZcmkPig2yoWLSvYhnZxpPHBEoWOy/NEZgwJ7o6XCKMSHfDFoBiw+cFFIt22CDHr8Kievz8moFB7YvZOcbG+apGUDfXX+5eDkzb+hnsDRfneKIBiUwycmZ+zEd5ZkzXCqoOLbaY+UOlHxhmvFrZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5QYdghyUpU7WJFrR/qu5tpdGBfQwYdkJdqZC0M9JyJ4=;
 b=cC8W8TkLYnb7iW+NNyIaUHiFFJCUw0QewdtMjuFsxLzhd9gnt9Th5C5/wyOMVbZ0XclO40U5X/X49R3JrU98QwjRpvv6OSmpVBAL3RaM1Fg2UEWYuXR/Ch5n3FVqQ/r4hOldQ/0wkKMT2cLWITXVksESpi2w8ZTLidh+/urcsvSwQwuX76l6dFhpDgkOyEh8+5lv/8JO13Nhw05xCmQkmXs3aRz7zcuANsdvXGtzzFu1yU3f6qaWZlh5StBlV7VJnU6kkAfMNEudKAJpKsUuVeLU+tKtwjvpVR2s7O8daKfQRvuJFeixRKpMx+8v0KA2qHyKguPbuXhm7QYivbOjbg==
Received: from BN9PR03CA0755.namprd03.prod.outlook.com (2603:10b6:408:13a::10)
 by BN6PR1201MB0145.namprd12.prod.outlook.com (2603:10b6:405:4d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 08:41:01 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::7d) by BN9PR03CA0755.outlook.office365.com
 (2603:10b6:408:13a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21 via Frontend
 Transport; Thu, 7 Apr 2022 08:41:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Thu, 7 Apr 2022 08:41:01 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 7 Apr
 2022 08:40:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 7 Apr 2022
 01:40:58 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Thu, 7 Apr
 2022 01:40:56 -0700
From:   Michael Guralnik <michaelgur@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <jiri@nvidia.com>, <ariela@nvidia.com>, <maorg@nvidia.com>,
        <saeedm@nvidia.com>, <kuba@kernel.org>, <moshe@nvidia.com>,
        Michael Guralnik <michaelgur@nvidia.com>
Subject: [RFC PATCH net-next 0/2] devlink: Add port stats
Date:   Thu, 7 Apr 2022 11:40:48 +0300
Message-ID: <20220407084050.184989-1-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ded1b26-984b-43a1-bf36-08da1872586e
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0145:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB014577168F19EA81067EB8ABAFE69@BN6PR1201MB0145.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +H/PGYoljZAO9L2VhcZOjZk+Lb6CIWrO3deQDg//JxC5AKYRNKwQbA2baUTHytHdenNYcXt0x/qFUBsc+PMYmV7HbGqe8V72qPvdULrjtXYcgKqvAzdB1jav/MVblXiZdHKMbSqBYaMjVEDYQdzSbtHyutenWWlyftyahjXmb3albJS4ycgzrDUmeh1XmfzONDSB2XWjvW2Y2Qx/wHWC14NxaOliCstbQW/hra3bwPIQM56R1YdT9/KaIupvxcYUZwLriI/efPdh6nsNLAsFsYKSypfg0b91eVL9lkVpeay8nZ3hhbFhQzKSR+C8WcLkbMBpRFpXQMwNvKiu9pkx8epHDNAElsj2z3Md9slRUaRKeZhvSCvKaS/AQJnwlaMGlcRsd3xBPJpHTuBPh8nLsw2f4x8Yt6UrG4x0AwgVVwjFo85xvUF5sHvNWYKfDl+hQJOyf2hxgMwrVbxxmSqYzeDDafHtYz/KOWAhHqh27iHaZzB215GaE6xXmx2eZZoJ1SXtjHZGsEHh9zyMN9ZfZ1Bm3hxzH+jCODil86ldEhquOXABdB2XndLoHg9X7VG3f48qY7fjfk2CBJUzjN3buLjTyDCVGm8NHbqaA4GAv4SyNntcnlb+ewPBLRoX+a/ZUop48j6u9ogsyHyh9q0ZQyUbsxSnpoSAx/nrp0e5NMwzg/MSU5ZpIZcGcqSEs+x0c9qHcQ8rIe0DMqgU+pnFcg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36860700001)(47076005)(36756003)(186003)(26005)(2616005)(86362001)(107886003)(336012)(8936002)(426003)(82310400005)(1076003)(2906002)(81166007)(356005)(4326008)(7696005)(40460700003)(54906003)(316002)(6916009)(70586007)(70206006)(8676002)(5660300002)(6666004)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 08:41:01.3619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ded1b26-984b-43a1-bf36-08da1872586e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0145
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds port statistics to the devlink port object.
It allows device drivers to dynamically attach and detach counters from a
devlink port object.

The approach of adding object-attached statistics is already supported for trap
with traffic statistics and for the dev object with reload statistics.
For the port object, this will allow the device driver to expose and dynamicly
control a set of metrics related to the port.
Currently we add support only for counters, but later API extensions can be made
to support histograms or configurable counters.

The statistics are exposed to the user with the port get command.

Example:
# devlink -s port show
pci/0000:00:0b.0/65535: type eth netdev eth1 flavour physical port 0 splittable false
  stats:
    counter1 235
    counter2 18

Michael Guralnik (2):
  devlink: Introduce stats to the port object
  devlink: Add statistics to port get

 include/net/devlink.h        |  28 +++++++++
 include/uapi/linux/devlink.h |   4 ++
 net/core/devlink.c           | 119 +++++++++++++++++++++++++++++++++++
 3 files changed, 151 insertions(+)

-- 
2.17.2

