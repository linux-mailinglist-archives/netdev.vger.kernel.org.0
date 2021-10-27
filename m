Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9563643CD90
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242770AbhJ0PdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:33:25 -0400
Received: from mail-dm6nam10on2088.outbound.protection.outlook.com ([40.107.93.88]:58849
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242803AbhJ0PdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 11:33:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2boB/rkwjbKSwsN4KfsH5EkGzdLqNbR2HiYl7EQr67+vp+xg0T0D/LrJbjRyOL2ef27ozKQr4Uq01Wli39rRVywD9bwOx0FdJIeVgVAg988wOfbWOz+6vfrweNT3OlwnGNjGzt61n2cxkbDS02JMZC2j5+nklqiqQ94QmUtNdyTVMH/fy4HHjrx5FKoH03t1v2obXAyhuJ92MWOoXGkd8/r1u0mA88w9ke2t7w/0DtU8uxr5lvcaPoqkrsMGDZ9yBSyG9lPIcGRPDvmvdbe4RUPxulvT3SSDkQ14gCYQN3wDIWqroutwbwvP+h/Ki/sTMrhR5tA5P01zQQQSzXFkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qrrpd3dHjQCrLuNhm+OqaDTrJvrps62u6A8w3gvUPgA=;
 b=ab+snd2U76tqC+HK8BDUD8p03Y8M2s1isl6TtmWgJnnYndKgrjIwHCk7Hc9J2UKEte0Cxforz9+scdXFX36qjuiR09+C/+kX/lQXCcMGewkGx8XDSK8Wn+IIF7ldb/HpjOJCsEiurzwxJGhG3SJYK1fkABilfvmX7r8w/q06bQU/Si/LaRtv/y+0lpH1zKweqkTjMkhiOpHz4WWnpRdE9LnGgzG409SM6IoymytGSSUlJNKXwzpBryRUKbRUtnw9E0yPWyWNUE1KBYG8nCURsH5e/Hh3AoCxAZfv0aYK2mpYLDz1Okprdf81PL31tMBCejewE02uGMGQsaYbN8tf/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qrrpd3dHjQCrLuNhm+OqaDTrJvrps62u6A8w3gvUPgA=;
 b=ADjC1u3meXXl96Y6TfFtV2/A1Q8xjhuZFajJhcGPCfmztnqknFRdOaLCtQner93iigMdQX31p42X//b1R7tD2WRYQ81ANG6XYePp0fHx7DTjNVzqltL2DBpY0r6Tt3ILmiZwCEtQg/7F1vvxtV/a+3+0ErWP3JZOrCdOBCSfC3EX+3UipKOKMbiXNMe9vPfDi7AhDmprrlzjXG8T5Q9mtGFuoJOqNzM8SoKMzhx9nGHaV+MwUtyw9tCgpmXWmLZWDTUxCOI0n7RFWZYMJ2Jsl74TClHrxP8WR8Sbe2VBhoNQBYLsLmTnEx4QxBPNDDjiPA5S/4BYIEzIiPJOMXTUiw==
Received: from BN0PR03CA0033.namprd03.prod.outlook.com (2603:10b6:408:e7::8)
 by MN2PR12MB4830.namprd12.prod.outlook.com (2603:10b6:208:1bc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 15:30:47 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::50) by BN0PR03CA0033.outlook.office365.com
 (2603:10b6:408:e7::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Wed, 27 Oct 2021 15:30:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 15:30:47 +0000
Received: from [172.27.13.210] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 15:30:41 +0000
Message-ID: <361bad9a-e8bf-f187-358f-95f57d3c1563@nvidia.com>
Date:   Wed, 27 Oct 2021 18:30:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH V5 mlx5-next 07/13] vfio: Add a macro for
 VFIO_DEVICE_STATE_ERROR
Content-Language: en-US
To:     Yishai Hadas <yishaih@nvidia.com>, <alex.williamson@redhat.com>,
        <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <maorg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20211027095658.144468-1-yishaih@nvidia.com>
 <20211027095658.144468-8-yishaih@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20211027095658.144468-8-yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a369b1a1-a7d6-492e-b850-08d9995ebfd4
X-MS-TrafficTypeDiagnostic: MN2PR12MB4830:
X-Microsoft-Antispam-PRVS: <MN2PR12MB48309B299E4BC4A9E9A281ABDE859@MN2PR12MB4830.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q3SZBUfgX0mWxj2vI/PdRmXhYQywICAvvE6dxHlTBqXYukQIPZ3GI6/nxWdQDt+LIUy0JpFThPWGk4qpCk+CMMFiIg95bIhAEiobPTYIBXB6x9yoEchVvorNIuLqk2fQuS5pVzECN4D6zLPbdFdz6BKiXjg7AR1v3KhqnRBhgxuovkRB6DdoAawAEpUB4d4HpREut/eF5+f+JItI80Wxj9YAZRL+H6pNO2Do/9LYe0hKgYwYzIo5JCILxk6WYzeAfqFJs9d7byZDGp6lijrQEOgs29rSe7RR8J1tXQ3z6CnhpNqgYtlqU+LSKqzPLmWULjPTxXsYdzofuKk+Yhk7nayWfDm7SSpfgNTbsvkdQk9V3UdJXNqXOUWePigX9Z+wvA1MBpnaE0QCzp6HMC4QSR/q1DOcOm7frTFWcMImAiiPHta/PjDpe2F9Lzmi5oZitFYUUIoyqznWo9EpPeXXTmLLCJU/Q7eJYnmyabXYUZR0p9/f/nV7c3xt4VomnYgIoLyiUv0gATIn9vH/Xhyn/kmamue9mRwKqyOrbz/R+cL6TVXH/FiBgK+H1ObbCCXB8YCjMLHF0VCEpnz3I6bg0p9iVu7pRKMGA0yccRZyPIcNFnwqdRt2dCf/mZDP+z3+KJVbQlV+ZNBs1OyeMoZ9aEPlWVSTtGLUFRRvzPoD1u8TCMzXjgbSPR9hO45OIv8jxnoAHXwvTxcj/9loEpwino2KeF1at4h94oPbgagGQJI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(186003)(5660300002)(86362001)(53546011)(508600001)(16526019)(110136005)(70586007)(2906002)(31696002)(26005)(4326008)(8676002)(83380400001)(70206006)(31686004)(316002)(36906005)(426003)(54906003)(47076005)(336012)(36860700001)(7636003)(8936002)(36756003)(2616005)(356005)(82310400003)(16576012)(6636002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 15:30:47.2261
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a369b1a1-a7d6-492e-b850-08d9995ebfd4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4830
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/27/2021 12:56 PM, Yishai Hadas wrote:
> Add a macro for VFIO_DEVICE_STATE_ERROR to be used to set/check an error
> state.
>
> In addition, update existing macros that include _SAVING | _RESUMING to
> use it.
>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>   include/uapi/linux/vfio.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 114ffcefe437..63ab0b9abd94 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -609,6 +609,8 @@ struct vfio_device_migration_info {
>   #define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
>   #define VFIO_DEVICE_STATE_SAVING    (1 << 1)
>   #define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
> +#define VFIO_DEVICE_STATE_ERROR (VFIO_DEVICE_STATE_SAVING | \
> +				 VFIO_DEVICE_STATE_RESUMING)
>   #define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
>   				     VFIO_DEVICE_STATE_SAVING |  \
>   				     VFIO_DEVICE_STATE_RESUMING)
> @@ -618,12 +620,10 @@ struct vfio_device_migration_info {
>   	(state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_RESUMING : 1)
>   
>   #define VFIO_DEVICE_STATE_IS_ERROR(state) \
> -	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_SAVING | \
> -					      VFIO_DEVICE_STATE_RESUMING))
> +	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_ERROR))
>   
>   #define VFIO_DEVICE_STATE_SET_ERROR(state) \
> -	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_SAVING | \
> -					     VFIO_DEVICE_STATE_RESUMING)
> +	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_ERROR)
>   
>   	__u32 reserved;
>   	__u64 pending_bytes;

Looks good,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>


