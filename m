Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5697F43CD85
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242760AbhJ0Pc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:32:28 -0400
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:38368
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242747AbhJ0Pc1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 11:32:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l40tbd7Yg5F1GPcq8WKq8hu4SIlvzXwqd1a6VUjL+6AVXAYqZ80wUHyar5nf9+AkX9Fsd7N2fyWMu0gUmSekN2zWd+87Wc/LnxX1Hxk7Xam5NsjwzB6XEHReBCU9RXckYlLDA6Qk3ZZTe444YpHA+x2OozUMakZ8z8jK4ihaqTYtU6uXhWA5Vs+Ce5U5N9sGHcIrs7k9eX9MCuv4hGrxiSGnOw992n7J52q9srYBLt0tYUZumjMU6wHflUaJPdezQS04AKxV08St1iBMtta2HMXdFw+sFnqJOMr8J9OV5WlyKTxeR+xejoCdOljTDlf9IUlrEGP0tbK31lQOVTKIig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2HF69LL6rd1Z3u9thHnBrsJs3y48dHP7y8nOqOWvVM=;
 b=ehJ55rA0PxPNUkIFAdNVE5OmMm7F/5+B3KZ5QlSwTErirTZs1L1ZlZksR3l0z+bDUnI+5U4DPlf2Kx75KKiNIDeVmUO6tK4GIZNCwcQMqu8VnO22vfVaTqz5DpRhjKe1eSwCH4hT+XZ2VrV+U88oxJr694FfdhakwYFtqVGK0REQuyDm/86sY7owFIMUz93tt2rNxPnDwNedwYJRBbhOg1Xq+zmHlY88kwcl4Q/u5QkKYLjcK09M9+YnjVCfTQmQOA7SYeoNHnj2y8m+qOF2PzVGYFfZk56GEsD7q6RYD5XvS/+xNRC9mTP0EFEwEIofuZy03+h58Xz/Vz41yG9B8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2HF69LL6rd1Z3u9thHnBrsJs3y48dHP7y8nOqOWvVM=;
 b=t/o7w7eefxALsRGrQNvTnN/qXn2NXdaZXtc20lcnAEag61WCjLxUKZe//u4C5eepA5cLz+zc1ZwGRp/8v003IWAwEYDjpRXoL0Z59MWSfYOc+irvrdXUMGRMWQuImqiAjxHPbR003Q2Ued5JO2XOGDe19PmxhbU+Qi9zf+B09Q5k9wGBOhqG77o9jo72kwNMG1Lyc44QncfuTQfyC8lr+6fhhyY+vjaQxDKYloFR0Nde9A6OntKkGDq+JhYpYVx9pA8K6Qsut2Lfa5ABK+qjrxUXPvItKvRt2Z6aPm+wafGPXdo8Z45pm/wYLnCiDuAzPgf7YvC3p6eEuO6v3+CZmw==
Received: from BN0PR02CA0018.namprd02.prod.outlook.com (2603:10b6:408:e4::23)
 by SJ0PR12MB5440.namprd12.prod.outlook.com (2603:10b6:a03:3ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 15:30:00 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::12) by BN0PR02CA0018.outlook.office365.com
 (2603:10b6:408:e4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Wed, 27 Oct 2021 15:30:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 15:29:59 +0000
Received: from [172.27.13.210] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 15:29:55 +0000
Message-ID: <8aa68a17-2ac7-4e8d-9c13-1f26b47d2754@nvidia.com>
Date:   Wed, 27 Oct 2021 18:29:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH V5 mlx5-next 06/13] vfio: Fix VFIO_DEVICE_STATE_SET_ERROR
 macro
Content-Language: en-US
To:     Yishai Hadas <yishaih@nvidia.com>, <alex.williamson@redhat.com>,
        <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <maorg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20211027095658.144468-1-yishaih@nvidia.com>
 <20211027095658.144468-7-yishaih@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20211027095658.144468-7-yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84c94e59-5362-4199-e220-08d9995ea397
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5440:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5440AF7F2F09413694CC96E4DE859@SJ0PR12MB5440.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PI74mxf5w9PPit0qKfIR6EGc+q03OEbFb4cKERr7e3VXaai4iI0SB+BIiZK4x/ektI5ibre8zYsMKDe7cC6Q0FW+lgc+NLKmv/giBRVdUL9d2ggNXwIeS1nHtIv12mzOPXflsh7mlfEqtTH5GBzy33OpP1uQmJ2cSNnlCJFxhKfKZIZR+BpsTKEt3zTqj6IpCoQXVRe9e3FnKhP2hUJliIISWruXTqjSQngBmQQ8hDksHkBOTpFSQ3jVC/TDR+Ycl15g/QHrnYalzyKLd4xAXMf46Md5uidM060t1T5k9itATVycjSrb/cQRaqSQV3q1ULDezGVrlsNuENa8CReZtBmNFYYpf6fSiGam0KdiusfYNIpOO4l51dZ0/AtAtjJLRW7yGbTFDqNxtQFvulDygxt9U5EKLIjJLkrDz+N5q+Jsq8xHJaUXCSfIi69plU7s/fjgd2DZo6l1j2kDgeVFKX9uYp7kGoL0dM1HRBaHsK9BPz/Qe9kMxEUHM62CAVXaoR4M4DD5a6A2ELvZ3EKdA+j9pqoTfOAXtn9Acg2GlC55sFnymbf99dYha1VcJNV+OrTb9NyAR8I59C7alhghMmivKDwqvR6KT8QpqK1vK2VE/8JdDNf8nytgBXMILwh4hw3GXNDS1LmtllmXqCTjVo9EIMyNMVtNcST5TI0pA1NzXXsESMWPWRYVresQ/YK4pJUpHgaCUhOp8IUwwjDFV1tAvdJKXLWRqvI3NwN9cto=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8936002)(7636003)(31696002)(26005)(16576012)(36860700001)(70206006)(508600001)(4326008)(83380400001)(70586007)(36906005)(47076005)(2906002)(356005)(110136005)(8676002)(186003)(86362001)(6636002)(336012)(316002)(6666004)(82310400003)(5660300002)(53546011)(16526019)(31686004)(2616005)(426003)(54906003)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 15:29:59.8452
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c94e59-5362-4199-e220-08d9995ea397
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5440
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/27/2021 12:56 PM, Yishai Hadas wrote:
> Fixed the non-compiled macro VFIO_DEVICE_STATE_SET_ERROR (i.e. SATE
> instead of STATE).
>
> Fixes: a8a24f3f6e38 ("vfio: UAPI for migration interface for device state")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   include/uapi/linux/vfio.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ef33ea002b0b..114ffcefe437 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -622,7 +622,7 @@ struct vfio_device_migration_info {
>   					      VFIO_DEVICE_STATE_RESUMING))
>   
>   #define VFIO_DEVICE_STATE_SET_ERROR(state) \
> -	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
> +	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_SAVING | \
>   					     VFIO_DEVICE_STATE_RESUMING)
>   
>   	__u32 reserved;

Looks good,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>

