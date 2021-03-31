Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B55734FF4F
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 13:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbhCaLMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 07:12:25 -0400
Received: from mail-bn8nam11on2082.outbound.protection.outlook.com ([40.107.236.82]:5344
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235135AbhCaLLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 07:11:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByGYTEqZGrYuxZnG1KfmVHA361iSchzo0foZBV9/mikN6FLRvkXT553CUD2tBW+3xOD05rNlRHDvYJhSBkKGg4C9PGXq2C76qW6SlcrHDJVflSIonpvasAcanryVqZOT3ZpHoWPtZntF8/xH7iS85cm3zfZ1Xs2cyEV3cvn7sZYt7FETaYvfT3uwUwFGpoeo9jPDDFOnAYciMYovHquOXnn5HUZ/SHwb6uMgV0idChUQrzGDbkMl0AHDqmb185P5QBhOHiOXcjJ4PkDqHXfU5rHWDMLTq7rAA2S6pwTIsuky32kFoXzmsPjpasy1Eum4hfjs1CES/XFDZnda7Yhqng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEne1MMSUgechOJGAghiT8Un/flVWnSayGXyNYOSEXU=;
 b=Mjw2SjxzIxAEVi6sxuTuS2kduZWEFXMU1jha0Ogp1FLm9XiWM3YKFCth7wcKjZCzuWMs4gYCFCkChuIH2tJpRgriXGZNM4vERHPAeEZe0VTPgawrRGGe13CBidslgkKSf8v5i2SdhpfNmcXYhjGQhyObxXaUDARBTF1QveY+iUgYB2IsrLwUHk+zxaO2x/UWP5yWohEAj7KobuZgLn0mT7aH924N/WDCsHxL83x/ZaZTM29BLw3KVJmRTjJmxoRCTac8q4givPmFJG8gzFNnqBOe2JhR8YdXsX5uzBn01PEgj05Nh22070Hq5+DK4RG1zH+yNGKdAcaoT1CAdafvWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=st.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEne1MMSUgechOJGAghiT8Un/flVWnSayGXyNYOSEXU=;
 b=lx2wcTnfTzAAos+jguHgTz+cvVwBDI1BhiIGRzNOhGFR2M/LZFGupV2qRIzeyEfi9dt/G0+4JAL+qZJavGcOst314G/0mBzdf1gLBrsYK9iL52rfwDjjFGXQrCgLwrqyFrIUsQumm5lbf2wWZWK3hf0JrLanjkhr2mSg9bJ80giq2RlkSi/pASrzq5eotRhAskgQV88U94D9EwokzcV61T0rzG9rUHgH7DC2u3E+w8qJgfljY67oCG3yqPqvBFKQdzKIPx0FfFbRxUIcY4qHO8mm/xDtJDxf2jWuzpL36ArRr7hC9mOik39iUX4fzXkWq30hPcr71yhNfkY3nlbn0w==
Received: from DM5PR22CA0019.namprd22.prod.outlook.com (2603:10b6:3:101::29)
 by DM6PR12MB3180.namprd12.prod.outlook.com (2603:10b6:5:182::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Wed, 31 Mar
 2021 11:11:50 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:101:cafe::66) by DM5PR22CA0019.outlook.office365.com
 (2603:10b6:3:101::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend
 Transport; Wed, 31 Mar 2021 11:11:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 31 Mar 2021 11:11:49 +0000
Received: from [10.26.49.14] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 31 Mar
 2021 11:11:45 +0000
Subject: Re: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com>
 <DB8PR04MB679546EC2493ABC35414CCF9E6639@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <0d0ddc16-dc74-e589-1e59-91121c1ad4e0@nvidia.com>
 <DB8PR04MB6795863753DAD71F1F64F81DE6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <8e92b562-fa8f-0a2b-d8da-525ee52fc2d4@nvidia.com>
 <DB8PR04MB67959FC7AF5CFCF1A08D10B2E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <ac9f8a31-536e-ec75-c73f-14a0623c5d56@nvidia.com>
 <DB8PR04MB6795F4333BCA9CE83C288FEEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <6ad03990-888d-7db6-8271-23c5ff673448@nvidia.com>
Date:   Wed, 31 Mar 2021 12:11:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795F4333BCA9CE83C288FEEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2aa59af-20ee-4374-9255-08d8f435c7bd
X-MS-TrafficTypeDiagnostic: DM6PR12MB3180:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3180E55654A2907BBD946C52D97C9@DM6PR12MB3180.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3yVYLtQSA8EQFeIk9TEOUfvSrJivNNgrGgUlepnoXhh43R3DekGq1yEzOqutFG9iVKnt1ppGKXKvU3utrKAAkCAFfRT8DIA89gQ6l23RG63fUUilY9bAQxJidsBjDW03gmrMqlODQUXCSj4YCgU0UzN+nkgWVCH8QSDAVQ320nLZ5DMQ0I/DQdMW3L2GomAsvScBKgz+VHc2Lr1OYZqYJdcKBJet45BPp2slwXfFoVAAg54Aq+iEscTgwNo6uCFYp0dLptWJ5KG6cQn61Du2ReyM6bekmimp/7rDkxFnT5kB7t+cVEu+TQMli5J5Tuq8u6eT/5Nf/2zo3LEWYPdYKET/cFAZfHPecx3jQI/ga6i7m0T3AiBsx2UzZ4igeJ4G+fPZlFHACeS2xPc3rOoN2bNV3cM1xeIoLzMHVamp7rkG+hDsc2RaVNdlw/Gzl3hHwrwmHkr4Eda5MIc7/eRLOSq7+KB0CSVfIt5YSPQYM200FKEoOCPx1OM0hdBDgA97ak+HkbbLLfB1RFemipml8XF84wO2JHcLhNs56c2pC7O0UfH01yqDPnE0zXnIapTncXaRw2JV0v3j2kCIl3z/ecIpSCIbNNA9WUq9RGoSCNBaPbe7kUQlL/8fSpEPQgORC252wiNKw9yl41E40W8qNI6o61EY0TStLkZJfjavgr3QL0JLbsULprEv34mYDUga
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(46966006)(36840700001)(31696002)(16526019)(70586007)(4326008)(110136005)(54906003)(186003)(2906002)(6666004)(2616005)(53546011)(426003)(16576012)(36860700001)(5660300002)(336012)(82310400003)(83380400001)(82740400003)(356005)(47076005)(86362001)(316002)(26005)(36906005)(31686004)(8676002)(36756003)(70206006)(7636003)(478600001)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 11:11:49.3349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2aa59af-20ee-4374-9255-08d8f435c7bd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 31/03/2021 08:43, Joakim Zhang wrote:

...

>>>>>>> You mean one of your boards? Does other boards with STMMAC can
>>>>>>> work
>>>>>> fine?
>>>>>>
>>>>>> We have two devices with the STMMAC and one works OK and the other
>>>> fails.
>>>>>> They are different generation of device and so there could be some
>>>>>> architectural differences which is causing this to only be seen on one
>> device.
>>>>> It's really strange, but I also don't know what architectural
>>>>> differences could
>>>> affect this. Sorry.
>>
>>
>> I realised that for the board which fails after this change is made, it has the
>> IOMMU enabled. The other board does not at the moment (although work is in
>> progress to enable). If I add 'iommu.passthrough=1' to cmdline for the failing
>> board, then it works again. So in my case, the problem is linked to the IOMMU
>> being enabled.
>>
>> Does you platform enable the IOMMU?
> 
> Hi Jon,
> 
> There is no IOMMU hardware available on our boards. But why IOMMU would affect it during suspend/resume, and no problem in normal mode?


I am not sure either and I don't see anything obvious.

Guiseppe, Alexandre, Jose, do you see anything that is wrong with
Joakim's change 9c63faaa931e? This is completely breaking resume from
suspend on one of our boards and I would like to get your inputs?

Thanks
Jon

-- 
nvpublic
