Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A5C43DD19
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 10:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhJ1Irs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 04:47:48 -0400
Received: from mail-dm6nam10on2054.outbound.protection.outlook.com ([40.107.93.54]:11425
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229993AbhJ1Irr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 04:47:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBdiyRb1aHsmlloFZtzZYUyF/NUDJrJKzrf6x6p/dzntYqSw9VbB1ihQ7Txvcys5qrBsNEZP9TKhTgmU+dwaE1+wMYHVfjfve4PQWkGBK/Qu9RXk5C3DslrNo2YxsF0nk96rVrLB/NPDoUpB7snB5Qd9BaTZxPFruLVh/8EzsmKOnNOVoLJBsTxYsZMhcHvsNL7U2yfGzy3LwlBCySmb+ARJxWQlZsGLY2/g+3ihuwJfV2qMX+zEcptl6wlOQd1mgunCEOKddFxvTHNj9KekJ4g+RSDt//588wQHV5YbFvsXIWLpCEq3RmVYZ6C4p1hzmV9s9wrHUe/X6Wc5o6CHlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QBWICISfARMm+/g6Wys21wHqxuDLnv7FkDWfN/FFKGQ=;
 b=NdNIUmpNp9rGAdJizGahdF+tb60MJ2P5l8Z7xHpnHT1+q6PpwF5RbFJGhltLSiRjNguM40mWPavRAcaGaXg3A2ZRrufSqKvIg3F+T7Kt4YTfbCIM4lfhrj4Fm3qfbiyKxZ7E4keZzb8eZVWRFes5qJFHQ7MgVidn1SXsP2wnttntgWaLPF2rvmUbIRUCHhZtAiKeUAzI3f2z6DVb/XnQmSg6nlHxGVyVfkRFauPF/iHUXA7x/EHOsnUDWEF1BE5kmN5DQp0pVCPIsFSUFJnffQ3IR04/p/XJ+F7kzhbMPmTHmCdb/i5vAG5spGD/Zj5CYCNfRUMDmczEqwzie+bIRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBWICISfARMm+/g6Wys21wHqxuDLnv7FkDWfN/FFKGQ=;
 b=MQayY0FGF/q1F8mLblmwCMX3oPfCsX8QjYO+XeJwKo39uS9rEzpPuCrnuHDHuZ2C8naKlkmQ6vz4FURBfhHgogRCzfuaSN6qqzrnxes/+dZS645c5M6XQkiXcbcos11bXjboPyxGKDRn4Ajy48M+iyELLTuwFPdy10E7oBy38lTXKnbbCXvv+dMU+eKLd/lt2UYfuECsw0x5GzWTIY7AsQUr+ngiEZzAZfVwP3zp03LZ8B5gvTPRQqX7A8LMp66kJfETH7R9Wt0eqbXJ/L3o6zvSSDqurSw8LujoIH1qxONUvmdZwPBMcqBYAW7BQgkCvXYq4n4Lt+Kb2RQw8km0zg==
Received: from DS7PR03CA0303.namprd03.prod.outlook.com (2603:10b6:8:2b::19) by
 BYAPR12MB2726.namprd12.prod.outlook.com (2603:10b6:a03:66::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Thu, 28 Oct 2021 08:45:18 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::84) by DS7PR03CA0303.outlook.office365.com
 (2603:10b6:8:2b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend
 Transport; Thu, 28 Oct 2021 08:45:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Thu, 28 Oct 2021 08:45:18 +0000
Received: from [10.26.49.14] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 28 Oct
 2021 08:45:15 +0000
Subject: Re: [PATCH 2/5] PCI/VPD: Use pci_read_vpd_any() in pci_vpd_size()
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Raju Rangoju <rajur@chelsio.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <ba0b18a3-64d8-d72f-9e9f-ad3e4d7ae3b8@gmail.com>
 <049fa71c-c7af-9c69-51c0-05c1bc2bf660@gmail.com>
 <88bfd6ed-f5c6-b9f9-c331-643eb0d37289@nvidia.com>
 <84956be9-f9d1-d416-5af9-664d7c4831ce@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <62ebbb68-8cd5-65a8-0ef0-82e257216ac5@nvidia.com>
Date:   Thu, 28 Oct 2021 09:45:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <84956be9-f9d1-d416-5af9-664d7c4831ce@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73d2474b-ed68-43da-2afd-08d999ef44fb
X-MS-TrafficTypeDiagnostic: BYAPR12MB2726:
X-Microsoft-Antispam-PRVS: <BYAPR12MB27266F7161D4E187D799D6C8D9869@BYAPR12MB2726.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v9a5QQnPxWNw+L7pQ9U0c51553N7AF7P70MAEIOxh8xSAEn+w4L5uHG4C5QLnhFt5eb+Q5EAaw0arc32o3OqvGtSXV+ayDVmB3An9W70WP+anLwk8OD4Mbht/WHVNiFIxjmHtNCusGCkbLMdVAYqdXZm6CRvlO17kFwMx8jHwy6K9FcvVTufp0aMor/0WnW4Eztrz2ju9uRyRI3qA1BC2FScDTrbw3fFLnrLg/bsrgM6fUyT/okGJc2bzxeIrt9xfVaU15kPvdPg6UAECkY7R6RMN6mP0s/hpsI0VYtpZ5dWYVTh4Te4TBMISjkAjMIrrqc8gicY6smMAie/3QC0LW/9ajWvnsvEZK94NzYIco6t7AsKzlYde5IWZLuYSRe7odEEq4KJsTS/Z7lEJfLScMoTWcXtmyXlryyXn8FUVTkpPxn+vmnUeMSeY+hsiM4lXV3ZRFGeqZLfrQuyioZ/Zp4SHk1e6aF0OUT/e+ikxYfSQm1yG/aTZW1rV9IAKYj0XuVsws2YLJ3Q5NF6mDn8d/DgaWxrcFB20W6NEAYlPmrrNZib4vzlxxLacCwEYNkoYPMD6vgkg1E8cxgwBP70xUYioOaCgQVQUvStgQvurmxBZ3YWI3yO/EsptKFi8T6+L6Yec8xxddeD7RKFB1N0E9pm5HYvzo6DcMdZ93xfXuAcUd/dVmA8EOGGTIOtzI4RfzSZaH3aCPlw29StoCGdBtRrIQNdixbgSe5dmcaYg3w=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(83380400001)(4326008)(508600001)(426003)(8936002)(70206006)(16576012)(26005)(31686004)(86362001)(186003)(36906005)(54906003)(316002)(8676002)(110136005)(5660300002)(82310400003)(336012)(53546011)(36756003)(36860700001)(31696002)(47076005)(16526019)(70586007)(7636003)(2616005)(356005)(4744005)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 08:45:18.2011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73d2474b-ed68-43da-2afd-08d999ef44fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2726
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 27/10/2021 12:32, Heiner Kallweit wrote:

...

>> This change is breaking a PCI test that we are running on Tegra124
>> Jetson TK1. The test is parsing the various PCI devices by running
>> 'lspci -vvv' and for one device I am seeing a NULL pointer
>> dereference crash. Reverting this change or just adding the line
>> 'dev->vpd.len = PCI_VPD_MAX_SIZE;' back fixes the problem.
>>
>> I have taken a quick look but have not found why this is failing
>> so far. Let me know if you have any thoughts.
>>
> 
> There's a known issue with this change, the fix has just been applied to
> linux-next. Can you please re-test with linux-next from today?


Thanks. Looking at yesterday's -next, I do see that it is now working again.

Cheers
Jon

-- 
nvpublic
