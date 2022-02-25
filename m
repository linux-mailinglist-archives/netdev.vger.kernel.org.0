Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501274C4462
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240436AbiBYMOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbiBYMOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:14:53 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2042.outbound.protection.outlook.com [40.107.101.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00265227599;
        Fri, 25 Feb 2022 04:14:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLEFxdqeaRMHnm+/j3ASB8I+djVOHk1wqe4XnQ4qXyM/+0RtL2PNHP0nXGzQeE31Eb19KcmKCm9vVY6+KibK2FFnIPDL1ctDepD6Z9bDqci0RyiFYd7Bg/LmgIb7Ya9fQm0zNsOKYZzy37BXlGtX2Wf5hvmpd78vsZ1z0JC50MkLRZSUYNqQyph/+nhteySgqReaxOJnmhLFGAjaY6yYZW/ZPwb1M3dx1MmL0ccXONrnsEWLdHeDi7uk9NHGDxbnYQxvVKra+nXpKn+ABynqOAvE7t76hRy76O9ExruZ/2D1vZCP7bm48O8T6i2SLqKToAlwc8tKhWfGd3pqQF0ivw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6OzXSx+Z74xY2ySQkA2ihNHE/3T++lRqkfg95wBGb4Y=;
 b=LWSNtBHGrkrVY2Ao4VMhWwCEXE2uEga6vclBDSIv9u5402aY4RIeTUIM7WMEJ/3JpragmfA1hnrTsNe9IHmH+oUKoo0yhtBtRXulTfT57WONrGv7U2O9zHP/0yLgjepBffRpc38eEp8cJP2rOizkNP6mQRMexW4X/QfOJP07HEZpGKlOagnfloKur0F/MJZgHKqDujt86JN3Nz1eckL1FzDVznM0HB3q+yOuZmPvL46eOX2/ZRxAk2GH51JAOkaZMifzRgs2lViFXPqPvezlGYiu2StUcREtfDxcpa/O0T5WHXLXDnxVZiL0elwkxnuowiTUGpt4UQ/K4tP2Pmo6dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OzXSx+Z74xY2ySQkA2ihNHE/3T++lRqkfg95wBGb4Y=;
 b=gXKoKDdauDitSLghwcuhil+tW/igqAf2vwsR3x0G11OzIMkXqKPmWYZda7z3EIyK/b4yDdy9fNWOCHqvNZlsOQMlbN0cnE+qoav+6I0Ajn22dIbkKcVHMbzP+XduH1/wTneEgtJoSfU8zJALhlHUmiVVRWWfcjbKb7YUqauD7UuTSqjnzQTfCLjGpqJ6cwc8K9ykrC5vwsKS++steqelq4SE/AAGhRQswOF6WZU+XPylZP1bwslS7Q682uPTRK/bbjezQl2DPsIm2LS68spUP3qMI+K283S+UDfyIMWMYITNI/zCigFSZwK7HXHyQ9Lwmh9zxFUaK96WchEfLdC08A==
Received: from BN9PR03CA0568.namprd03.prod.outlook.com (2603:10b6:408:138::33)
 by DM5PR12MB2453.namprd12.prod.outlook.com (2603:10b6:4:b5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 12:14:20 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::1e) by BN9PR03CA0568.outlook.office365.com
 (2603:10b6:408:138::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Fri, 25 Feb 2022 12:14:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.24 via Frontend Transport; Fri, 25 Feb 2022 12:14:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 25 Feb
 2022 12:14:19 +0000
Received: from [172.27.0.43] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 25 Feb 2022
 04:14:15 -0800
Message-ID: <331ea6e1-a8cb-3076-0dc8-385c53ab379c@nvidia.com>
Date:   Fri, 25 Feb 2022 14:14:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101
 Thunderbird/98.0
Subject: Re: [PATCH] net/mlx5e: Fix return of a kfree'd object instead of NULL
Content-Language: en-US
To:     Colin Ian King <colin.i.king@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <llvm@lists.linux.dev>
References: <20220224221525.147744-1-colin.i.king@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20220224221525.147744-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cb795d4-80d6-4897-40eb-08d9f8585a2a
X-MS-TrafficTypeDiagnostic: DM5PR12MB2453:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2453B5B585EB5E4EC333A0BAB83E9@DM5PR12MB2453.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DIlY03ZnQVFsIXLlB/e+qEvws4sQogHi1TfX2uuScy0NVYEKdVSef4765RtBaXeu9PaJniT7f7QJ9tauLfT3adV5ZzO/T5pt4OqpzgPFn/aJXCT8VTCRV6OaSxKTecPb9V2yOHZF74T1/I5z3VzdfqCuqXrgydtHQHHFioEcOQWxWiyYr5Wcy/Ae89XnpZ7eoX2BDIDT88XXSag08gXB/XTS0+0TaNyuPP9475cZU7MPC1BxFK/tDHG+NbXqxLtgu6kuMUSLlPXVMyVOuy3FwQLO5ec0xtT9mUuR0G5F/K/2/Ky23fN1U+Pb1rBGZdWakk2zJqXKgczYpFT9X3qr0cVdgCQsTyN8DdphnjLGXbf8QZPaYPCvSNInZvl2TH160KexC+2csW/k7xlxKSeMwnAuO/bwvqK5WxHxroBVzlPN6SnAULYcrAwd39iC89zHJVYHWUl6aBRZmQad+LnuWXNzKML58Yo/hXEho4uq9Cza9HID8JvUuafSeMiK+yu59EhBo9aux7FXksNFCAHvX9iTtH/bRxovnWtAxlccIUu38+dMzt+9eRTuuqVdPJeRWXqzs4Bg0jUT9xaW13Kuui1+jSP0JTM5QqBn3We2km6EYCWLGIT3Q1WB100qUJgNDpCzohqAe+vFpoRlKg/moErXGWuFp0ZfadN19B1ZnuuPZXyOTo8KhykpjCeo9PYG4anmzbM8pFALivVTPW6ObV9GvbU4pQIE7n9FOqL9Ah2v3kTk7UQUm+hkZYW0fB5Yvbx8TpBXWePruc5kI8w7cw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(81166007)(36860700001)(26005)(82310400004)(356005)(186003)(2616005)(426003)(336012)(16526019)(83380400001)(8936002)(36756003)(31686004)(316002)(2906002)(70206006)(70586007)(4326008)(47076005)(8676002)(86362001)(6666004)(54906003)(110136005)(31696002)(40460700003)(16576012)(5660300002)(53546011)(508600001)(7416002)(2101003)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 12:14:20.1446
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cb795d4-80d6-4897-40eb-08d9f8585a2a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2453
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-02-25 12:15 AM, Colin Ian King wrote:
> Currently in the case where parse_attr fails to be allocated the memory
> pointed to by attr2 is kfree'd but the non-null pointer attr2 is returned
> and a potential use of a kfree'd object can occur.  Fix this by returning
> NULL to indicate a memory allocation error.
> 
> Addresses issue found by clang-scan:
> drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:3401:3: warning: Use of
> memory after it is freed [unix.Malloc]
> 
> Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 76a015dfc5fc..c0776a4a3845 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -3398,7 +3398,7 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
>   	if (!attr2 || !parse_attr) {
>   		kvfree(parse_attr);
>   		kfree(attr2);
> -		return attr2;
> +		return NULL;
>   	}
>   
>   	memcpy(attr2, attr, attr_sz);


thanks!

Reviewed-by: Roi Dayan <roid@nvidia.com>
