Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CA951A0EB
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 15:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350559AbiEDNdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 09:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350145AbiEDNdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 09:33:20 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E425923BFF;
        Wed,  4 May 2022 06:29:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ND6xW8Djps55wpv33O/MJSBgiLrdm50pYdxYz2XccMxp60d6tAmxn8KO2lkZ1zPrXxslVbmh69zXh8z/rVPj3Sw5XlJYj4xIDSfziBJRTdAUhms9c+twERuAkUZIE7bVTcJ8RQ+oiqkMJbFt8LMMYjTiW/7H7yW7HkVjIwIDyJgDrLABlmNjY7RMzwSfnUthsvrwEEk87WwZuGPiyL1/pJk560+Aw+WfzS/n/3BJnXnCV/Qekp8RNvrMszgXH4p0uSDqCQ/d5FfXXqkdVCNVyFTd5UT5hvHAKk/otS69dtyXrvvY345KwGoMg84+qonmqw7USE6plJcfGhufiZaxIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2buBwKtXi5ss6arfdsLvObj1J6hPoaT6751mX5f9/TY=;
 b=gCUo2Ou7mU/MQICmwYa1sF1kzkne0fzitiA1H3wjFkuxZG3Vf+ML1VpFTjAHnZUBOn2H//BihcRnmFXrYMtmHzLuz31WN3eM9BnvHPfYzbWYKAHrfgAqZxXYHh3O9JiwOimasg7SpEv/bqegYQPtOv6+4Ogjhu0pUeH8Ft1F3fZVkn5QaFk2efFT64iGQtxP+oYhmuGEKGSQnr/hr8P5+IyfG/rXymlNSO9tC7ZBu3GyILGLpT0TiZ2Tmq0vpgxo5W/Hwg/63X19LjUBPbg2QnT6Vkqr2hL864rZMhPt9IJChqrBrxMaR02E3xPWC0ovCB27cXxXsf7lDgXu1c8cUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2buBwKtXi5ss6arfdsLvObj1J6hPoaT6751mX5f9/TY=;
 b=knL8ry+Xd8faxKcZ9TMhEucu4RNfNGpXjOfNUE0v4LZMt1IRLkU1qzHdVqhQoOAx6PBJjg+QgzGU2oD1j4kB0KB/c+zv8hpXsv0TUeohx2e2qk3i1AqXzjdnMwuIPfSxxVwBddVxelS4ZzsIb4N8HBX4+0eoZZ5jvNQNBaowOr3J/60L5xQqZTZ9jcZUFUH1VmQtDmI7xqgGCGlnntQDNf/xuRIbUEzmk0N/OKN7C3XfJtVFNKdS2nyN/l/zBahb8x1lEc5yBnI/5bsr0Je1irO1GOpzU1fqqZt9oLM4pJ7TFDK/G/jd11rJ1cHSzWAbZpUEBfmId35/Q0mck9+E5Q==
Received: from DM6PR05CA0066.namprd05.prod.outlook.com (2603:10b6:5:335::35)
 by MN2PR12MB2909.namprd12.prod.outlook.com (2603:10b6:208:103::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Wed, 4 May
 2022 13:29:43 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::35) by DM6PR05CA0066.outlook.office365.com
 (2603:10b6:5:335::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12 via Frontend
 Transport; Wed, 4 May 2022 13:29:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 13:29:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 4 May
 2022 13:29:42 +0000
Received: from [172.27.12.171] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 4 May 2022
 06:29:39 -0700
Message-ID: <4295eaec-9b11-8665-d3b4-b986a65d1d47@nvidia.com>
Date:   Wed, 4 May 2022 16:29:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH mlx5-next 0/5] Improve mlx5 live migration driver
Content-Language: en-US
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20220427093120.161402-1-yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e49411a-2943-40dd-70a3-08da2dd22613
X-MS-TrafficTypeDiagnostic: MN2PR12MB2909:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB29092AD296942A7DB04E5080C3C39@MN2PR12MB2909.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I36A1LhYynrZ/xK7JtEh7GRfaHMmm+0/tVl7ZWwjuFetAjew2hKwn6UIaflE9MB0PzdHyWyO4DRzzBXpbodwxbXQjQU43J1Owl/lVYPS2X2dF8Pc9hvlo1kpAP4VaSRLRmFQSyDun/LQ1J73wfGZRHO+s/1ORF/WVsJxyViHQ0UQf2mNuJyNnfa7OTBAD6j3iy5QfVAhACrsmpXz/beHnOpnl60ovLpyFmfnREi39Wl0ChvXFQcHe7LSgbpbX/v+bG+Xc3lRmqFAjqiAyieomyJJnz++oRovBgaJCg5cNWBHpPsbVdkhb71k86qO4e0wSCgLUXqx2IaTOOE/v4b+C57hmvKlSxwU0IXvVXuATJ3IrK36YR1FzNaJK7YUWLj85IHlBUlcQPoHOIV6lIs/Sz+M+ZPA1I0dVCxm8RYkVdr81nzUoxqKkcuh0jkr/MfLWo23QQqtQvvaii1K49OM7+VTq/UoHOKvJRLVl7QYn59DeyzLS+mwKpHwyywSozicqW8stjL/TZWb/cq42DJB2HpAZRlvLcKY5Sq59DX+bw6YIU0dcJNytFAjnFO4ctTSUqnYsGJoqLVGPcsfSx7fSNRfZ2kZ+dTJlDZapzkhKrAeLRIwKB2gbV9z9eUEF80S8A0MWUe3PkyNHZ+BXLuLxNs2xLiCSQVbkmYx6qnRA6veEG89Hz4D2fbHJiUr6dxRY+amkCBDVv8LfZTzG0LQL3m+/kY62TlIOVoBISkGOV4ICxhyiJcrIBzB0MzC8efB
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(110136005)(508600001)(82310400005)(5660300002)(54906003)(36860700001)(83380400001)(8936002)(31686004)(2906002)(36756003)(316002)(6636002)(16576012)(70586007)(4326008)(70206006)(8676002)(2616005)(186003)(47076005)(426003)(336012)(16526019)(26005)(53546011)(40460700003)(31696002)(86362001)(356005)(81166007)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 13:29:43.0286
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e49411a-2943-40dd-70a3-08da2dd22613
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2909
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/04/2022 12:31, Yishai Hadas wrote:
> This series improves mlx5 live migration driver in few aspects as of
> below.
>
> Refactor to enable running migration commands in parallel over the PF
> command interface.
>
> To achieve that we exposed from mlx5_core an API to let the VF be
> notified before that the PF command interface goes down/up. (e.g. PF
> reload upon health recovery).
>
> Once having the above functionality in place mlx5 vfio doesn't need any
> more to obtain the global PF lock upon using the command interface but
> can rely on the above mechanism to be in sync with the PF.
>
> This can enable parallel VFs migration over the PF command interface
> from kernel driver point of view.
>
> In addition,
> Moved to use the PF async command mode for the SAVE state command.
> This enables returning earlier to user space upon issuing successfully
> the command and improve latency by let things run in parallel.
>
> Alex, as this series touches mlx5_core we may need to send this in a
> pull request format to VFIO to avoid conflicts before acceptance.
>
> Yishai
>
> Yishai Hadas (5):
>    vfio/mlx5: Reorganize the VF is migratable code
>    net/mlx5: Expose mlx5_sriov_blocking_notifier_register /  unregister
>      APIs
>    vfio/mlx5: Manage the VF attach/detach callback from the PF
>    vfio/mlx5: Refactor to enable VFs migration in parallel
>    vfio/mlx5: Run the SAVE state command in an async mode
>
>   .../net/ethernet/mellanox/mlx5/core/sriov.c   |  65 ++++-
>   drivers/vfio/pci/mlx5/cmd.c                   | 229 +++++++++++++-----
>   drivers/vfio/pci/mlx5/cmd.h                   |  50 +++-
>   drivers/vfio/pci/mlx5/main.c                  | 133 +++++-----
>   include/linux/mlx5/driver.h                   |  12 +
>   5 files changed, 358 insertions(+), 131 deletions(-)
>
Hi Alex,

Did you have the chance to look at the series ? It touches mlx5 code 
(vfio, net), no core changes.

This may go apparently via your tree as a PR from mlx5-next once you'll 
be fine with.

Thanks,
Yishai

