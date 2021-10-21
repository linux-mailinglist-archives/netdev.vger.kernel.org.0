Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439B4435F60
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhJUKlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:41:35 -0400
Received: from mail-dm6nam11on2045.outbound.protection.outlook.com ([40.107.223.45]:53760
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229567AbhJUKlf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 06:41:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POLcuibGEHlvt4cEm24WX1HBnBpjPvZ+NheGSB7ZwtTmCuq66iAVnIzeLF/wslJHpTSxfqBxt5phvO0lw7uXejLF4fCnOpahKuxlGJyf6ay6KtzZMAgNr5qGZbftbPdrth4i03fedcE38FwkdJ75tdO0Bn8/siUviyjqcXARn+9AlknXdIcjidC6WinP9WECtiMxLijDSMCYDLXdKPtsRtANngAHlG6fHpNnJD5DY9u+qMcRSDng8iIPJ6YrcZPbyl9KzPCkSTMrTAsMhbBikhPHVuLePzvis3jzWq9yhoN2eTOEXySrcecIJCYjzj1Pqw8NF1/dj1OIye+SxQnxBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruNyPvSH4vcqoUZb9xHutQSk2AmaTvOrLoaT8BT3m+Q=;
 b=N/nmFLy5gSLSfxAqsOlMAIzjkFp7WPNH4Ugp9nzCts/JfDzj786gEcvK3z3KFsoBDV3zdiXtj8rHsFUA4ZHF52qYm7279A+vOCm6UCSn1MVHzDsTuB/EXVMFz+rDiydYwaFtoWOR9Ou4lxB79CjApwWkcy0RYlOh9Aucvlo4m7HyvFev4W/d/lt/X3iJA8bX4Vsx8HCJXdaUCu6gc6uOuD8IL4mM4FfTmj0mdMLQDAR5T+BZBhs4j3quAt9PuyIh04NFnx67UShZEXnTPyZwnPt4LfaCta1qF4iwPM2y+2iIuAEn7YY2mq/JrT1tKFHVjUhqgbD2Uxnc02tiafxwfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruNyPvSH4vcqoUZb9xHutQSk2AmaTvOrLoaT8BT3m+Q=;
 b=bv7QHVAiGTcRXQiU/HjMKD2WzBpYpHUSaUC14IADvBYVr6+mqHNWKl5m8DoAk0scZQxYD21pzGsX1NqvOozCQ4RsSt5uUT3xElcjpx5kGhFa1hw7jzo+Me2FQ23+enqr6HgUnDAWIv2em3/ZHNUxUMyQxxGmEHfFBAgoXV98Hoa/KfqL5/485vlRV2f4MWxyHcOXVveDOGmPWUIxRer3IA9TLEX2VNmJTDMS0T7K2zS1Kz3PgG4ZNeTFK6trUSckWTAbW+/bopk0aJiFIov9rgBTSLp2qm5TQ/tHrGxIKhX48nuHJp4CGPTeMn46me5JdrfZkPQcJvXZKKYjR3xCyg==
Received: from BN9PR03CA0105.namprd03.prod.outlook.com (2603:10b6:408:fd::20)
 by BY5PR12MB3890.namprd12.prod.outlook.com (2603:10b6:a03:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Thu, 21 Oct
 2021 10:39:16 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::bd) by BN9PR03CA0105.outlook.office365.com
 (2603:10b6:408:fd::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Thu, 21 Oct 2021 10:39:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Thu, 21 Oct 2021 10:39:15 +0000
Received: from [172.27.15.75] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 21 Oct
 2021 10:39:10 +0000
Subject: Re: [PATCH V2 mlx5-next 14/14] vfio/mlx5: Use its own PCI reset_done
 error handler
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     <bhelgaas@google.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-15-yishaih@nvidia.com>
 <20211019125513.4e522af9.alex.williamson@redhat.com>
 <20211019191025.GA4072278@nvidia.com>
 <5cf3fb6c-2ca0-f54e-3a05-27762d29b8e2@nvidia.com>
 <20211020164629.GG2744544@nvidia.com>
 <20211020114514.560ce2fa.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <36fffe2a-cc37-7f65-1a99-558d24fce837@nvidia.com>
Date:   Thu, 21 Oct 2021 13:39:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211020114514.560ce2fa.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a593dd90-5666-45d8-29b4-08d9947f079d
X-MS-TrafficTypeDiagnostic: BY5PR12MB3890:
X-Microsoft-Antispam-PRVS: <BY5PR12MB3890C3DC0602B33498918394C3BF9@BY5PR12MB3890.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /hhJhY0yIuFcmCaWpp3ROrRBi/h15ool0ziZwtyTvW4Y8pTWQRrDi6IhNHgfeLJLUYsLh8WKH8G7uyZiFzNi1twQJ1xh78IPots7FgApWuaqBIvp7o9z6FmaHKCrT0Dk+AyFwsQGLDkBq6+zt7j13znzIL0MtDdif9Enz1wx+nzzazEqFrVcmyYm+tD1nQOytIziQMtdXTKlNjGFO9+Ki8RUve68Y0QyimkL/SQ4lZNcfX00FICIUavtgPxHxGjPRNzpQPa1daxqBR222I8uYj9e9QkhxBycbJ/Gk3jRJ5Q8OwIruepSn1xrbrmcKGtDecb69E0mXyaQnqUiGXBNbaXp+7MBVup+dbW7h+Wqa53UZ33IKcjZSxHopAuZqmYIBTR+MQt+lJBgxrwn2FOULsR+VMmDRrspJS+PPjo7ljNriE8iE9PdE9kUcMWqw96rBqOSOCIiyuT3FaXhhMeOWteAKazijmTL5pUP5gaLPHdHK9gbMBBa1fuk8rgHKg8WkviBviQphJIHky+HVvlqNdcvBm3sL0T0vImpbn2Naw5QGxtHRIqOkWI+ZsOLdlMxEQCVYnrVPUDS7+8uUchhd55S1u2H0+EW5EkgJ3Jr3KDcN0575lAAA4H3TA8BPWcKo1q5tlwiXSsC8LEGv1Kr6WRW+WCr0/Qb+zFIItmXi0QOLGPFudUhtDlOTbyOfbSp51gi8zDQYy/lB7aoai7LNoUvzy2NUUlVw5W1NR+Svv8=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(186003)(8676002)(4326008)(16526019)(8936002)(336012)(26005)(70206006)(47076005)(426003)(6666004)(16576012)(54906003)(53546011)(110136005)(2616005)(5660300002)(70586007)(508600001)(36906005)(316002)(36756003)(31686004)(31696002)(82310400003)(7636003)(356005)(86362001)(2906002)(6636002)(36860700001)(4744005)(107886003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 10:39:15.3496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a593dd90-5666-45d8-29b4-08d9947f079d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3890
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/2021 8:45 PM, Alex Williamson wrote:
> However, regardless of the migration recovery strategy, userspace needs
> a means to get the device back into an initial state in a deterministic
> way without closing and re-opening the device (or polling for an
> arbitrary length of time).  That's the minimum viable product here.
> Thanks,
>
> Alex
>

OK, in V3 I'll use the algorithm that Jason has suggested in this mail 
thread to let things be done in a
deterministic way without using a WQ.

Thanks,
Yishai
