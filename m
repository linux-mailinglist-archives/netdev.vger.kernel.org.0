Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F204B53A26E
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 12:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351692AbiFAKSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 06:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346695AbiFAKSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 06:18:21 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061.outbound.protection.outlook.com [40.107.100.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2210959BA5;
        Wed,  1 Jun 2022 03:18:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmN3zL1U+ZpRgVIa/N5AzBkP+RzLw3hUXPIZwI4CUC0D98WUY4fXiQR4bTDUzZzu8bAHIxqvBp0864C8oOVJbl727D+sjw0sdbvIXIPiLplLxKa2b5eKsf3wm3waoCJ1PtR3nUQDhRVKCrR/5/MPvYXsXim59qo9RC9DAdw3JEwZP+kzpeYj0yJe3Kp+dQNMra4r1RhYIAbHxQ066ql83iFHDEZ63PVR4gXe2k8b+lY8tzzD5iF0R/YUeSiZ8Xqyt/Dtsp/UsWa+8Q7lUHF1YYikODMQKSJlFwv+4OYiQO/98egGuXrgR7xJQImLE0Mp0S8CWiqhxKapTeNS3uzkaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tmkkZTyAuh1M3kDRGnEk0u21tnNnP34n8cS+xB6CTXU=;
 b=ixJgeIcOTVP6yjjOBaBhpEV6j9XuolPYvhiaK57Z+2yaikGZfxB14j2q5ZUKpDq/NEQ7HZIsXyjUV6RMy73yqTdlOrHHlCFHBO7Ag/5IUg4KS9OMEnzchDODDtkt+WIq9PlxjWuE0FKUXpO4EjmHOc33RyumM7Gp1JkPnSKfKvGeKVTIO/Hg4BOiKzl3DZdCpqkUkb8xaej6qUC8vvoJ50lUE1WcHkme2EZaj7di2gy5mu7q/wFTCdscb+WbBADUPL44+p57JhhLNUkhjfaPJUC4im8K2BUAxDyYGkvvmi6ZyZQeMITM6xEp5A7Vhb2WcEV4rosZvu4fUWWJ0f3/qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmkkZTyAuh1M3kDRGnEk0u21tnNnP34n8cS+xB6CTXU=;
 b=aDKCgH3ffC9st6sY7MEvdVOZTRwxzzgzbpmp3tLps/FiPdnozkolrA6trqwC2Uhh5xB8ewuYNKKHU8LWHrRKl3+4E+SeMqWWJ/BE+x3sPJL6geuQGwK0keK1L9pPgWDKeZaH+13i1nzgThV1TOFKG79tG3Mmw6URWYNHIcDoZK6WtiHWqvX3M8tNPBJnbwK+WsoDriraGo2+A7zk3qDPt9tm1hdbgFfDk4ZeF7ibWeOZBviswT63+vfGjwD75x16NpsVsDqehzo+CvzQuXNBD43ewfTGXATmI1HrptuGxl8vyLkDiFWI2kYzP+Dq+ZdZz6qYuN2bGxrHMkrmLynCrQ==
Received: from BN9PR03CA0923.namprd03.prod.outlook.com (2603:10b6:408:107::28)
 by SA0PR12MB4416.namprd12.prod.outlook.com (2603:10b6:806:99::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Wed, 1 Jun
 2022 10:18:18 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::52) by BN9PR03CA0923.outlook.office365.com
 (2603:10b6:408:107::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13 via Frontend
 Transport; Wed, 1 Jun 2022 10:18:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Wed, 1 Jun 2022 10:18:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 1 Jun
 2022 10:18:16 +0000
Received: from localhost (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 1 Jun 2022
 03:18:15 -0700
Date:   Wed, 1 Jun 2022 13:18:12 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
CC:     Boris Pismenny <borisp@nvidia.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: Re: [PATCH] MAINTAINERS: adjust MELLANOX ETHERNET INNOVA DRIVERS to
 TLS support removal
Message-ID: <Ypc85O47YoNzUTr5@unreal>
References: <20220601045738.19608-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220601045738.19608-1-lukas.bulwahn@gmail.com>
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c639241c-4234-4f50-f699-08da43b80bba
X-MS-TrafficTypeDiagnostic: SA0PR12MB4416:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB44166CCDB5F7C54058117740BDDF9@SA0PR12MB4416.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5fcGmKSuS4wOuF6wbAqrlcNo+752AioYEXUb2bxwSYW+bKTEDakbfcwdB0ZZa7tukjVyTc0aeUNZJmualYXC4m0NAteBa1ZjWb3kupZBdaaikT9/Pb5wmJbK5mQp3OgFVpnWANXlmXELWZrx9g9VOAF63nLHXQO2DLYNOApgb3139K1mtr5H8UKHuD21hb2NFzyC7BoMaF8lDbrbshbS62pmfrHhEaaHr6vmiT+Eak61jnmIVoIWBfZtZgTEyIMwRr/W/zLNnreFSv1OP/AoX/O68C5YtEMyt4/72MFeleJPwr+4XjWAKrTJRL2H8fnxe5E6/GOpmviMR5MECc0HaTbvLHLTCrBjTjJAFXK55iCqOuTi3jUQNrpm/4KpoqEsdzAH4ozEt3O9MFvfhoLrTqg42ySdjcEvY/zFdOs0bZQMNX2MzINP8qrfYbO+mSJnwVdU2pzOTgUMNBrSFG1VzgSGJeBM9XLrS00twcwl4VHyPQULC8HxlP20hXu/e6cKpiaGAkIcd8Sb4PLdN8VCUvo0G2B/RMbWFHJh2NeNCnIHEA9n2QHxiXn64YqngnRakauTBRqQ7dQMZZ/JrFQ8VxzQPY+tv7scAbwUNEqJVMoJRWgdIqfil6Igp0eWh3ns444uDRv3di3mE/kWwgXXW2yfiygDBlVuM6dFpmT5mOYsOI41HFVwCfKiMuTd9KwTKoT7kCDmumvrabVVmr7BOw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(7916004)(4636009)(40470700004)(46966006)(36840700001)(83380400001)(8936002)(33716001)(86362001)(36860700001)(82310400005)(81166007)(508600001)(9686003)(4326008)(26005)(70586007)(8676002)(70206006)(40460700003)(356005)(47076005)(54906003)(6666004)(336012)(6916009)(426003)(2906002)(4744005)(5660300002)(107886003)(16526019)(186003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 10:18:17.4473
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c639241c-4234-4f50-f699-08da43b80bba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4416
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 06:57:38AM +0200, Lukas Bulwahn wrote:
> Commit 40379a0084c2 ("net/mlx5_fpga: Drop INNOVA TLS support") removes all
> files in the directory drivers/net/ethernet/mellanox/mlx5/core/accel/, but
> misses to adjust its reference in MAINTAINERS.
> 
> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> broken reference.
> 
> Remove the file entry to the removed directory in MELLANOX ETHERNET INNOVA
> DRIVERS.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> Leon, please pick this minor non-urgent clean-up patch on top of the commit
> above.

Thanks, we will submit it once net-next will be open.
