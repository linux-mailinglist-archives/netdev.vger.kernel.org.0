Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C2953AC73
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 20:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353638AbiFASIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 14:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiFASIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 14:08:14 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5816A30F62;
        Wed,  1 Jun 2022 11:08:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2j3OjIDo9/2zre+kF+sL3boHQtq1/uK3Xv9S55dFI48/vuUjMUCpxoAEVYD10kIzDJymM8JS1rUKI6tKOjtbGCdn9xopXpLcPOgiCX0s8d+OpyvRTZKb8ocah5AmQUFwS4LEG+XwBvQLSvIVTchufvsoTbAdHmtO0zJHp3xm3Dej2E3hGlx2qONxAntOw6+R7V1JPhD7ZXgtf6jWkXmrhmFtD2UIi4Kx4Q0HZD6kd08ueyoE+Az2CdqRLGqJZqB69Eto/L7naO267/Wua02jjhB7FrJDPTmbfbTm2gW608iIMuctbg021pvwl5PtDqJJgnwy3v2xmM37QMV7rzSsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3dIOJiS3txfpERQozYCY+n6Fp8ihPEBKXPncoEHGxo=;
 b=Pa45Qi4Gx3OzvhQ8yrCtQxplE/6uu/MAkf7sQD/1b21Sx5xOFe3VdllTqzFkRqwEHXw9FYyGBDT6naiNgrVnB6Aubm4P1t/RostNxDcvmZlbSSfLY09gJtHf4hI5yzfr3cEpQeKAnOSKjZbtK7WykEFbcPcqDqHrcaHoJ7xhzytvTw5mPFDMCOoCqRJ7RUbC+9tqvtIrvk3ESdPFUwZb0MrVz0hOG1xKMCarvBdPFcJgBAy6IwXtkwCNHIVBcgSQ6cEGE07ahsGkgGQ/o3En+2Ae8kUYrGJsPQXt+gnUQMTAHT8XaaB1lQ9EdyGoIeTKbY4EfKxPOiLyUOKP81BQgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3dIOJiS3txfpERQozYCY+n6Fp8ihPEBKXPncoEHGxo=;
 b=KbaynKn6fC6d7QwfcYmcYQ2pZRQJFsOUE4ooIYSBZ3tVV/Sd4KcgwLX9Ub0YS87CSZDdKXStGOtj0737gOCsAnsrWjjl8OiF1qTMI1NYv0eWO7psxgQOVVSN9uQlD6P/4oxmXqdR3KOYDEgO5qKOYiensCg2BpwjTpYViRFsADyGd0zZJ67veR4P3TW+FoYVCinrV2cymdxK68iwphEJytLlSGnZcANK1AGyAJqtEwxX3D5S02kteSSu8w/qtcCcBUMluKahL6zq8/9LOn7y4Pho0Wqdq5dI/W0Er3pgOXt2NUFgvRvZyBPJDWgPuPNum689K0FcV4X19+a1WFp0Eg==
Received: from BN6PR17CA0054.namprd17.prod.outlook.com (2603:10b6:405:75::43)
 by MN0PR12MB5713.namprd12.prod.outlook.com (2603:10b6:208:370::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Wed, 1 Jun
 2022 18:08:11 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::8d) by BN6PR17CA0054.outlook.office365.com
 (2603:10b6:405:75::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19 via Frontend
 Transport; Wed, 1 Jun 2022 18:08:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Wed, 1 Jun 2022 18:08:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 1 Jun
 2022 18:08:10 +0000
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 1 Jun 2022
 11:08:09 -0700
Date:   Wed, 1 Jun 2022 21:08:06 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: Re: [PATCH] MAINTAINERS: adjust MELLANOX ETHERNET INNOVA DRIVERS to
 TLS support removal
Message-ID: <YperBiCh1rkKDmSR@unreal>
References: <20220601045738.19608-1-lukas.bulwahn@gmail.com>
 <Ypc85O47YoNzUTr5@unreal>
 <20220601103032.28d14fc4@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220601103032.28d14fc4@kicinski-fedora-PC1C0HJN>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 719790aa-e83d-445f-feb3-08da43f9b09b
X-MS-TrafficTypeDiagnostic: MN0PR12MB5713:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB5713944BD39F17027EF21CE7BDDF9@MN0PR12MB5713.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eM0SfkLkpaTQJnQC+7IXEQqWilhV+uL2PSAO6x8nmJltl1fWVqC1Ap6cuLg7kegsNXyO1Nt066aeB3axS5TIuPv2X0Bq8p8ewO3chGKK7x1LMz7GkSbPpDTwWAcBBLXBAXtcB0h+TbEWItUb3J9ZCBiS5Rlkv4rlfCKlcdMi7CdYhmCPXv7Ih56McCBBYSdXco4nxEcRIMRkvPV8vIM4hA1cPxD/DtKndKdvkVF1SIfC+5wybIlpdXsK3bumUl8Hot3KjQH33frc74EmDA5v8QJllNQWeskNpw3Us9dHuH47onNpVrdnJfMAJ36oYv3PIS7fqpzFWYyfEXqTs0Piqml+a4L1i+Wb/yeWA8PKSbP+3Tf1VitWSlhjhAgGKkB5UW3hnFVdmduw6GIfogUO1UPQUDYJIvGOXHM/aFU3zzI3eP1cAM+2nQH6tFP9NTycts7Twoajh7j26B+D08A1Bi8atjxhiJMlXZcx+We98SnSvfNcMPwvGNeWVcnzswyu8MdJu9i6cBJLsYDVBY4BfzaIXNZ5CfkDL3I6hLfYD6guyEKbmcI6SarI62awPy4CbU0Wqq+WvPBJtdg1hlyRtHhpbG3K0vFdh3hgmjrjAk3OreY6qjt3mP7ucuCMuyjUzcWWj0F/l2TjrSqZPWy8AVR/Zn8uSxhXbvw3Zm4i9JKqGTkjX6qkCJzOHtU8ulhUwWeEZ+O3ZtFpvM4WWyrbR0Nrciu+N8RYd/8SVAZ/Grng27h+SIE/vIk0SUsZsoTLt1UkDwbUJHOrNv9fqlWaG9xS9lmEMNXepicsBbyIebM=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(7916004)(40470700004)(46966006)(36840700001)(54906003)(33716001)(316002)(2906002)(81166007)(9686003)(26005)(6916009)(356005)(47076005)(336012)(83380400001)(426003)(4326008)(16526019)(70206006)(5660300002)(70586007)(82310400005)(86362001)(8936002)(8676002)(40460700003)(508600001)(966005)(36860700001)(107886003)(186003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 18:08:11.3402
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 719790aa-e83d-445f-feb3-08da43f9b09b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5713
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 10:30:39AM -0700, Jakub Kicinski wrote:
> On Wed, 1 Jun 2022 13:18:12 +0300 Leon Romanovsky wrote:
> > On Wed, Jun 01, 2022 at 06:57:38AM +0200, Lukas Bulwahn wrote:
> > > Commit 40379a0084c2 ("net/mlx5_fpga: Drop INNOVA TLS support") removes all
> > > files in the directory drivers/net/ethernet/mellanox/mlx5/core/accel/, but
> > > misses to adjust its reference in MAINTAINERS.
> > > 
> > > Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> > > broken reference.
> > > 
> > > Remove the file entry to the removed directory in MELLANOX ETHERNET INNOVA
> > > DRIVERS.
> > > 
> > > Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> > > ---
> > > Leon, please pick this minor non-urgent clean-up patch on top of the commit
> > > above.  
> > 
> > Thanks, we will submit it once net-next will be open.
> 
> It should go via net FWIW.

I'm slightly confused here.

According to net policy, the patches that goes there should have Fixes
line, but Fixes lines are added for bugs [1].

This forgotten line in MAINTAINERS doesn't cause to any harm to
users/developers.

So when should I put Fixes line in netdev?

[1] https://lore.kernel.org/netdev/20211208070842.0ace6747@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

Thanks
