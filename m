Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF3A416066
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 15:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241541AbhIWN7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 09:59:00 -0400
Received: from mail-dm6nam08on2079.outbound.protection.outlook.com ([40.107.102.79]:43360
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235976AbhIWN66 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 09:58:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ed8fMpEkq6CnGe034dLBhiDiUTz1Yts+g4zQpjob1D2iU44znToKFFkfhXWejHEuhVqupEukeNOX7NlB4VmDw9+6ltlWkyJ5B8tZ8b4EgM7dbSwp1BzfQ+ic+nRVsD22igPxCRh25orKg71rUDtLFfh2IL6dna1mnB3lX5UphTHSNuduZNwPEVyMqwmNvzBktzYBcq9g7JAidUPmrm1aFUSoiUZyHPyxk3Q3e8Iv94YSh7kH/R9mPh6BBvqWDfYDFsTv2LLQitqfKuiBiYHA5u5TR/yTQEaLSW6S/Q4IFS5OeU1qfPXtUtX48BejpRo4edf9knKXmkLSBCZUQrb0kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=fuRrMtGUpJYB192uQ5rJqL2JRpK1mp70DkeCjo6MwvI=;
 b=N108xyZtB78FzVXQqdnpv9QsFKlwYykm7Q6E6CK3VL0tDfifcINoIyQ4BEmmr/ftVMIn6YlwAOnIDZS1mMfrkjt9NibIST4cxV6ppeCan7uwZ7RAc6mAxjAjI2F2GMQx6aiKzppwrvsnaK8JPZs0MrGFuo9oPOtoxjOoSJyXjdLsJ4oU56dB/A1vyq4dOyjT8m/qTgC6sa3x2ugfXKZOj6HS1b/0z9qT1m+ag1OeMFbfUc0K7HP6pnKR86UBilszDQE+aqbnmlwQrPtLflvbDjPvn1lsJmc0iq+XKIMnk5STCm67/GGPqR2CL4YORRCdDfwrnAC5Qi8ge5H3aAmbmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fuRrMtGUpJYB192uQ5rJqL2JRpK1mp70DkeCjo6MwvI=;
 b=szZfX2jf0626s/zX+x2AVhd4d2ff78VJgfB6sYWbjMJma5fuAKxWT+mBL3/EEAa0AgFq4+0TuuGNHT3NoixrNLKaqP/bjcLwewk510q/P5b2DTYvCSUfg/4hTys+CpYX01nwC2hv+BSlGT3rey5yik9Cuzo7h2Tl5Cwm1O1SjnedmjYPSGw0YreJtuH9fQATKh71dHVcHLJBubHouMu7tCS17uyZrKyF9Sk8PCucnGwcf663051NQCWXqw+0G07WGJ2m2J+LFtO//5WDhGh7DBrKOT76S+GhqUX6yRToPWzE2um+vQDTbhVTiU3DUskBkNtMTVgmVEnCuOZmjm1GXw==
Received: from DM5PR19CA0060.namprd19.prod.outlook.com (2603:10b6:3:116::22)
 by BN6PR12MB1827.namprd12.prod.outlook.com (2603:10b6:404:fd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 13:57:23 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:116:cafe::16) by DM5PR19CA0060.outlook.office365.com
 (2603:10b6:3:116::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Thu, 23 Sep 2021 13:57:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Thu, 23 Sep 2021 13:57:22 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Sep
 2021 13:57:22 +0000
Received: from [172.27.15.96] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Sep
 2021 13:57:18 +0000
Subject: Re: [PATCH mlx5-next 3/7] vfio/pci_core: Make the region->release()
 function optional
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Kirti Wankhede" <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
 <a01c7bb01ac4b1930a428fa8a8cae89bb1c4327a.1632305919.git.leonro@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <60b22817-442f-c7ac-3dce-8f8a57c12c4b@nvidia.com>
Date:   Thu, 23 Sep 2021 16:57:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a01c7bb01ac4b1930a428fa8a8cae89bb1c4327a.1632305919.git.leonro@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aefb4f5c-ff32-4044-3c8d-08d97e9a1171
X-MS-TrafficTypeDiagnostic: BN6PR12MB1827:
X-Microsoft-Antispam-PRVS: <BN6PR12MB18272FD4B8118A581D89E8DDDEA39@BN6PR12MB1827.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qM7GV6SyZiJBzuV+iXIb0HkaXd5weNSUaNsZSptBIHRR8IFqM4780pH7ctpHIUarRL05WHmd/SLQ/pEU+t9ZjNmXUmFVR0qHZb2XMqqNP3VeUe3netUfFePQME6VFzfu4s3A0e9dmIMEegQ+W0b/6ss4vMTNLfX/egxwLFfcdU/o3qoqdZE/zXNBSsJ4vNSc49WAU6o1SeHxvWrx5SnCMzYHUUl4y7oc7HyXTtNzqh7bEEMwjSIurL9veI5OL5C+2/PhfqlnNhjbjb5qHLMjK+C+lHN2SFwy4aCPXS9JMlPCNJRi+7pAWxi7K/gR0niDNM9h0ksnIQ5n4YKqxXhYu0iCxeHJh/oLtrLTfCcx8FGEzjVw/t/2qr6b7/tVosYfC1zbl+BnSSSTLwXMWHUoXCu6KDKu6akgVA8uNTsVOQP9T3ioModwmVngFS+RGVmD7U2Cg+01a+gKQvSta3Or9+k8IcAPLA7px/KSU5+Q7L5t5nZBeAgCQ6hMNi9icE8zyIVHBaEE2bnG1JTMo+Z08jwZcroUvbKfY4RYdVAy567bBrFPqvatQ341mu5+A6uLFG4kwjMWw+Yy+aKwiK00aSetAKHLbTeXU5fuTHa8R12mvBxmD2FlespQYbkOQnlMvRWkpfm+pOBqiN8UHsZlAYJWwyysOGsaZwTG40I6+G97DM70OKqxjc8HlcjTQaODXUjhgnsATbaF/cE3iZZhDWH3BPGTLYCP6ZqtjC0XDwY=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(508600001)(83380400001)(186003)(53546011)(16526019)(356005)(336012)(36860700001)(82310400003)(26005)(7416002)(4326008)(31696002)(2906002)(31686004)(36906005)(8936002)(70586007)(8676002)(16576012)(316002)(54906003)(86362001)(2616005)(5660300002)(7636003)(70206006)(36756003)(110136005)(6636002)(107886003)(426003)(47076005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 13:57:22.9574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aefb4f5c-ff32-4044-3c8d-08d97e9a1171
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1827
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/22/2021 1:38 PM, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@nvidia.com>
>
> Make the region->release() function optional as in some cases there is
> nothing to do by driver as part of it.
>
> This is needed for coming patch from this series once we add
> mlx5_vfio_cpi driver to support live migration but we don't need a

mlx5_vfio_pci *typo


> migration release function.
>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   drivers/vfio/pci/vfio_pci_core.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 68198e0f2a63..3ddc3adb24de 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -341,7 +341,8 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>   	vdev->virq_disabled = false;
>   
>   	for (i = 0; i < vdev->num_regions; i++)
> -		vdev->region[i].ops->release(vdev, &vdev->region[i]);
> +		if (vdev->region[i].ops->release)
> +			vdev->region[i].ops->release(vdev, &vdev->region[i]);
>   
>   	vdev->num_regions = 0;
>   	kfree(vdev->region);

Looks good,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>

