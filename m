Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1364BA025
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 13:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240481AbiBQMau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 07:30:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240468AbiBQMaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 07:30:46 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057702AE285
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 04:30:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8wYK5wEfelsIV2HR2ZYacxgJtUlc4h8sYcVcfLjQBLVmqQRQFj9LDHSJMGlSwFQWPjKtlWQ6aN4j5a1H2F42maJETNf/a7gJwlIGf21jk/tu3p2lkfb8PVM/rh4XjmGlGhTz9AXU1ix7xRsHBMgw5sNpkVHtZEv/ezpI37p0nBahp1qE23XkGitQUhj+ZE/QKx5wT/CiJ8y7z4WPfzsLfWnkADdCG8Xh2WV+3bnQOkYWE38UYA1pUSyRinJOWLrhgg/LLh3tA6eXhti+WPBbVD+5FhjPypQ6YEaggPghCopIv1u+zH1OHYReJQtXyRHXVznWJ3BGjHHzAwcd8hiPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vMOj9A4AazOyZtrg06lsA3nYDSDe05G7N1Nv9S6H3bM=;
 b=g+k1Vd6EagtSql6fe2QDURMb3G7l9J7hbGbVV8gjEE8rpuv4mjOs+EAq0dQ8UHnf3w29cIZnwNuIn46PKENAGazu3eoCeIBC1tUlWbNeGiWUhNby3umEuPdkHLj2/A5EfjKcsmHKYgeQysHtABhsbXg65clVlFHOmbobUhmZB3MZZQKPxgdNbSxRtAm0yw1E77NONvTeS9fs43A6ooq56mftgIL6Trme97pra9BRZMjxal/2xUTnw52/ZoRwbfNhrHTx/ruEMdmga61idwg59seLqbDxaj2JKA0jVlBCNMr53w34Xt9TkTRNICd0YfaKQauyuxv5LTLl/stAyHdBOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMOj9A4AazOyZtrg06lsA3nYDSDe05G7N1Nv9S6H3bM=;
 b=tzOA0yFYpzVUfpO2MhnxWz+jDKcBSVSMvPeYmFjvzR5LX2VI768wO8BJweW5MUmcjtmW2CGGCIk3RmdwJFuLECBwvyySAgrfG6lbhRlm87JH9fIl/BiFDHxOdNFYcBHHKdeWk6TfZefn9ww8jFOCSBapnefyQjBrK9cMLpTfjVyFhDYVl8maW6+zXSa4H5+kwXECS0q6Q3c7LPMoLgqzggkz2UyfVsIU85lU3ZbveO6fughLCAfoKlEUV2tWMIjrIUzWDaBTpJW0A8Ney2I8v3DVVniKzQYoGjNtpmCraxpA4o671x7xlTRnln2XjYOy0q9t1inZyG3DeGUiXdmN+w==
Received: from DM6PR01CA0011.prod.exchangelabs.com (2603:10b6:5:296::16) by
 DM4PR12MB5843.namprd12.prod.outlook.com (2603:10b6:8:66::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.15; Thu, 17 Feb 2022 12:30:30 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::88) by DM6PR01CA0011.outlook.office365.com
 (2603:10b6:5:296::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Thu, 17 Feb 2022 12:30:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 12:30:30 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 12:30:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 04:30:29 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 17 Feb
 2022 04:30:27 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     <jasowang@redhat.com>, <lulu@redhat.com>, <si-wei.liu@oracle.com>,
        "Eli Cohen" <elic@nvidia.com>
Subject: [PATCH v2 0/4] vdpa tool enhancements
Date:   Thu, 17 Feb 2022 14:30:20 +0200
Message-ID: <20220217123024.33201-1-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58357f45-9fef-4481-a761-08d9f2114935
X-MS-TrafficTypeDiagnostic: DM4PR12MB5843:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB584309DC9AAAF5AADE60C805AB369@DM4PR12MB5843.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6jJoK6eRYCQh65gzIWZbuIINz6ZAPV6+uYSNTd3RLaZMuFIWxhkMZ+7yUoh7bSmhK1kahWl29jEzApz6TsDBjb8LGrbyJLgG48oqjzJ5bXrEjMF20FzktxuIBC0nJ8Q+by+D/qeowCljdE8ncxDL8Mx06MvDfU4N2PBFtGFQBakhhhEdyx45OZgf0OtL8YeK4YQX04lBe+cpGRVXVCtjCc4DgAJs3R8MrOhc3Ym6wDkM+7sr9bMm8hBB9U95gpPekSkmQJWT8soCcoJ92jetlU8g/QvGsbfQVKL7lRhioIclADk2LuIJz6WcDGh7FBcwH3LwAIBqCl6GTCLOTxxjh+Iyy3Pz0KqH8Jr8UU/n4RalxuXej6bqzl5Z3y934ZACQxpY/eeDqJtmPZhpgLuo/9Rzh/xJOu4qeHvnAB7dgIL6aL1mXqHPQTU9MvZ5eYwqdzrg1soUImHp5tFY7ANzFWnd3JUHenP9JpOMJSgN4y29Ttcr5HA9+L6NDXjtqC378ksetcBvUmkr7sth3prBYk2aFqTJ/vHeRUwxRX2eQL2DvV1dY9HGa0X/fGj9CmRjsD6rO7+gR4qfjT5Aq2u+MpmIqVDbRGMMoH5dK98y9R1haYQVrF1EQWq3ePQ7ER74tvKDKJaKVu2NbICCR5n+U74Yq/gkWkn+JVZMaNg8TeWFpa2EiJ47LEHMUnNcMeu3K8YXwDd9n52wEYG41MU07A==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(86362001)(4744005)(83380400001)(2906002)(107886003)(7696005)(82310400004)(26005)(1076003)(186003)(2616005)(6666004)(336012)(40460700003)(426003)(5660300002)(47076005)(70206006)(356005)(54906003)(36860700001)(110136005)(316002)(81166007)(70586007)(8676002)(36756003)(8936002)(4326008)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 12:30:30.4848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58357f45-9fef-4481-a761-08d9f2114935
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5843
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following four patch series enhances vdpa to show negotiated
features for a vdpa device, max features for a management device and
allows to configure max number of virtqueue pairs.

v1->v2:
1. Re-arrange print functions to better reuse code.
2. Fix printing management dev features instead of negotiated features
3. Update help string with max_vqp option

Eli Cohen (4):
  vdpa: Remove unsupported command line option
  vdpa: Allow for printing negotiated features of a device
  vdpa: Support for configuring max VQ pairs for a device
  vdpa: Support reading device features

 vdpa/include/uapi/linux/vdpa.h |   4 +
 vdpa/vdpa.c                    | 151 +++++++++++++++++++++++++++++++--
 2 files changed, 148 insertions(+), 7 deletions(-)

-- 
2.35.1

