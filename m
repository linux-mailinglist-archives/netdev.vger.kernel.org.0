Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0443519C8
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbhDAR41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237207AbhDARvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:51:07 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20631.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318E6C02FEB5;
        Thu,  1 Apr 2021 09:28:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjJTX95hSQJZntdcMCR3NnScPVtsB88TsETLUXeu0ny+WCt0gmHO0gd1E/AWoR1AILyH4UTcBYKIJf5u2U6KTHA1+ltjnWMb3Z+CgPSMulACIaQJJTIL7idruFHekyulBZQMW9FGOSlaXj3gurcH0mlKKjwYmvHryI8JutmSEIVduvwc0blWptrsWWTOzTlIk727vezXQXz0HdQM28aVajIbeqtbKsOeWUgk/gB66LdjZ3NXRuByL8z58uO2EDXM3mEdUdnTQoBjR6VZhLoAVwhqSZlmZsOxqP9/aq6e8wv/n1KiodsAWRUtFG6KPF8feiwD4cnja1/T9PZ9RNquzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeyNSTLyaA3IuPYGbFMpTBbENNenOUWzR0NQHtAdzOg=;
 b=HgI3sI4lGSYjAkQ9dcaWSkl60gc5rlMlQbGzU3SVD8TJ8g7bvRm0SdW4UUxtNUaqBml2Zj8ZyAiI4ewneMs2mSxcuuY5okRhp1WYF3+uasMZOkrfw505MLDBX9IwIRRwvufnk5YMoovoAxuQJQ85TLPjJiYDh08+Hhx3JKANo8G3jP/uojueIERIQ7GK5W8lNDw65Y2UOIVMqZQJn85WPyfxYWBTV1SYeZ+UowXNg7+2wZbEZO96uSBVxo6JNv0cG5f0sP7acZCSF8LcWDCrU/e3c5k2/uBDOpPuxLe+ymXHG5DJ5Qf6IMpdd3UikSAYLDChLRJuXGUrc84Iqf94mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=st.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeyNSTLyaA3IuPYGbFMpTBbENNenOUWzR0NQHtAdzOg=;
 b=azIrVFpKjW39kG4HBJ+Akdl36nqL57ew6up2TWSgDyxO0FEGsxQD0yJbrb0MLP08np0Pt8qjQpcV9x9mNH10zwUqWF5rzyi92JtJAjx7vg+WX6NGNqyJ2KXdyW3yLPhxuOvRNcJ3mTk+naYLr3QsU+WSW4Gm/e865lwalBOBP0cZktks7P44/07QbDn74PRxRkynGNtZyV6fZmTqRC551/BSVPDU9AwuTa/Rb7I8e/ddpFNIgcgaUz+gbUei6JIt/v0FkGYEMeoDUeKnSoo69ARTdTRx5D1h0mk0w4/w6Dgd11729JEYmZPno+YkHOKey6G/T2vhFzBecNTnrXhM8Q==
Received: from MWHPR18CA0071.namprd18.prod.outlook.com (2603:10b6:300:39::33)
 by MWHPR1201MB0237.namprd12.prod.outlook.com (2603:10b6:301:56::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Thu, 1 Apr
 2021 16:28:39 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:39:cafe::a4) by MWHPR18CA0071.outlook.office365.com
 (2603:10b6:300:39::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend
 Transport; Thu, 1 Apr 2021 16:28:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 16:28:38 +0000
Received: from [10.26.49.14] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 1 Apr
 2021 16:28:36 +0000
Subject: Re: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com>
 <DB8PR04MB679546EC2493ABC35414CCF9E6639@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <0d0ddc16-dc74-e589-1e59-91121c1ad4e0@nvidia.com>
 <DB8PR04MB6795863753DAD71F1F64F81DE6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <8e92b562-fa8f-0a2b-d8da-525ee52fc2d4@nvidia.com>
 <DB8PR04MB67959FC7AF5CFCF1A08D10B2E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <ac9f8a31-536e-ec75-c73f-14a0623c5d56@nvidia.com>
 <DB8PR04MB6795F4333BCA9CE83C288FEEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <DB8PR04MB6795D4C733DC4938B1D62EBDE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <85f02fbc-6956-2b19-1779-cd51b2e71e3d@nvidia.com>
 <DB8PR04MB6795ECCB5E6E2091A45DADAEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <563db756-ebef-6c8b-ce7c-9dcadaecfea1@nvidia.com>
Date:   Thu, 1 Apr 2021 17:28:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795ECCB5E6E2091A45DADAEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4448c67-4587-42b6-d796-08d8f52b34a7
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0237:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0237B5A9F8E698C3A07BBF3BD97B9@MWHPR1201MB0237.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g2xtHWQ8KlrUpN0MwAJ4/0bcA5t4VaF1ZLORPj1FrSgNdT469C36ViZ4ThJv8uPzXfe3qijs5xTFL8hq27LaHvlUeWWEq2jpu9b8/9GW0F71UYv5GTdoGWFu2QDSnXiPenmi0K4WpzR9BTXQSnzXdxKkwuIwZBrFdcdKoP1lebeBULeoGAgnr+eYHLE1D1Mot5eyBbk81HhUk8JVP25hFWwpzXuSO39EVpcIu6WSPL61OWN5bPv4K+tyXeLLfyqYkZiERYFHi2yxUgHBGxsJYHh2KxkqUwmJnO6OISXUQ1Fk5ARuv8l+vWHSq8tiYt8Ye7WSkz0LbYboJMu/lT7fYNOILax1TAied2I4AXYXT0bainLKVcGXWwBqSdNmy9Xn1wEp5T76OR8iKy92tYsDuZO/pGlLwq2lo2hUVZOAJwqDjj7TeV1e+7js0ectW9+8+LFwrsJWzMf0BbgUdPKQkZJDFI9T5D8ntJjNXlyPDXWCalwfEnZl0gREozXO0rZySj407PoLjpA0qZH5nxDj0fXJtTxosBYfLJJLBHZ3rFnqjcZtPW9JKoSR8NVjL5vGCwIJUG2nxO1Zb1TkHveZpO+UcYwTMApIu+Mcf00kGTi0pgS4lBYHG6HaZDBm9LuL9D8vceEwREG216pVVn1SpBkmUrCUavM8vJNHbYZmSGAbvaDDOf56oQvtkMSe+99d
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(36840700001)(46966006)(31696002)(110136005)(54906003)(47076005)(6666004)(36860700001)(16576012)(36906005)(86362001)(316002)(16526019)(186003)(36756003)(5660300002)(70206006)(53546011)(70586007)(82310400003)(26005)(336012)(31686004)(8936002)(8676002)(82740400003)(83380400001)(2906002)(2616005)(426003)(478600001)(4326008)(7636003)(356005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 16:28:38.7529
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4448c67-4587-42b6-d796-08d8f52b34a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0237
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 31/03/2021 12:41, Joakim Zhang wrote:

...

>> In answer to your question, resuming from suspend does work on this board
>> without your change. We have been testing suspend/resume now on this board
>> since Linux v5.8 and so we have the ability to bisect such regressions. So it is
>> clear to me that this is the change that caused this, but I am not sure why.
> 
> Yes, I know this issue is regression caused by my patch. I just want to analyze the potential reasons. Due to the code change only related to the page recycle and reallocate.
> So I guess if this page operate need IOMMU works when IOMMU is enabled. Could you help check if IOMMU driver resume before STMMAC? Our common desire is to find the root cause, right?


Yes of course that is the desire here indeed. I had assumed that the
suspend/resume order was good because we have never seen any problems,
but nonetheless it is always good to check. Using ftrace I enabled
tracing of the appropriate suspend/resume functions and this is what
I see ...

# tracer: function
#
# entries-in-buffer/entries-written: 4/4   #P:6
#
#                                _-----=> irqs-off
#                               / _----=> need-resched
#                              | / _---=> hardirq/softirq
#                              || / _--=> preempt-depth
#                              ||| /     delay
#           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
#              | |         |   ||||      |         |
         rtcwake-748     [000] ...1   536.700777: stmmac_pltfr_suspend <-platform_pm_suspend
         rtcwake-748     [000] ...1   536.735532: arm_smmu_pm_suspend <-platform_pm_suspend
         rtcwake-748     [000] ...1   536.757290: arm_smmu_pm_resume <-platform_pm_resume
         rtcwake-748     [003] ...1   536.856771: stmmac_pltfr_resume <-platform_pm_resume


So I don't see any ordering issues that could be causing this. 

Jon

-- 
nvpublic
