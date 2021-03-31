Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2E134FF7E
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 13:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbhCaLa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 07:30:56 -0400
Received: from mail-mw2nam12on2066.outbound.protection.outlook.com ([40.107.244.66]:38393
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235199AbhCaLaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 07:30:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJGu6FYDVWgMHUioAkwvlhN+uGcGl3+tKtMprpPPFNqWbAz1AE5wbziNAi7ejYRDVmppNOqm56OgN/jNkl84XIdiUfW6L0CPBnd9ATjfhVWkLrjRE29Qk5rQT65o08Dv8xinW12p76TPcX1rIiO7eLF7UQ3Rpeb/KiYMh8C4EQNGzKIZr2LQq65d6WbXLFhsNkE3scZGG8sZqvB7DVWJGZ6dNMDwBAaBeT3OAMoYO3AxkGkR83g226YNTzpW7WJ5Oq5CNS5Uic/YGsdjK/XDIm6BS/hC1eVc4ERLn2YEQifA2WAoB+MmMtBUNy9ZWSNiAlc0FoBg3FPWfOM5yM6aGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/pK6DsKrPx2zdBZhSSixGjrFDwqBIY6E156+koF1jOE=;
 b=hCCdRLpZi1I4jth9S8Vpv5u+zhVBpTFQHoM6jdg8oE2WBQccwahFJdoEc5ONgd8CAExLhMstP2fjhIQonz3cKZjTmpnA1OkpekXomZCosmfOWc2ZQ4l2EVHy7g/9nAvZ9Oal+2OJIFuQceXJgfVV57ViQHKP0YWzTqDIClE6q4+XvgShXzJRaMcMkCSKHrdkKrmAAAGdPGfJzr7SfpI5Nv6632MLG7WQ/ZlBrCRo65m9F1L5CFwpbA6Q+2ZR0+gycS/BWb/5ZczbOK6xmiGbi8Vy6M6w3ESo7+sgyRQv7//dHu9D+ISZokFqx/jLjRrCtUkEeos541kKp/0/84/fvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=st.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/pK6DsKrPx2zdBZhSSixGjrFDwqBIY6E156+koF1jOE=;
 b=k9Hj5Pw1SF5w8PJ+hApjJ8k6NkYj29QQEZwoheVAW36gSSXwXJQKQooO2PyIRv30/vDOdZBd9moPYmn/xJhsOPc7FkALGqyYHggDMVbcIDmuGSVBYb/tYNYSxfHISFAs2EPzqQ/ujIk8PmcuWO8qAb4KsZ890aOhQGHGyzr37W5OeRp+K/Up5JBqEr40m5DK/J32GepfbRlUPYMpfIsjJtG9K2SxyPMUQB3tLJc2LsKd6pR9sscXzIO0l/XKWQWFqJYEDkrySYhf8AY8hZy0ozCxV5MmuP2QbwhOM8HtfSQcTWK0n9a7U1G8smX+StkfR317QvXa4QT//C62sLwVug==
Received: from MWHPR10CA0024.namprd10.prod.outlook.com (2603:10b6:301::34) by
 SN6PR12MB2686.namprd12.prod.outlook.com (2603:10b6:805:72::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.24; Wed, 31 Mar 2021 11:29:06 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:0:cafe::42) by MWHPR10CA0024.outlook.office365.com
 (2603:10b6:301::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend
 Transport; Wed, 31 Mar 2021 11:29:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 31 Mar 2021 11:29:05 +0000
Received: from [10.26.49.14] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 31 Mar
 2021 11:29:03 +0000
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
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <85f02fbc-6956-2b19-1779-cd51b2e71e3d@nvidia.com>
Date:   Wed, 31 Mar 2021 12:29:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795D4C733DC4938B1D62EBDE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6044614-290d-4fe0-2042-08d8f438313d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2686:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2686386BC9BC1F96DBB142EAD97C9@SN6PR12MB2686.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NF3CZ5Potxk9hCAbrbYBQdCbWJNspKZRQJ9Yr1sLCZZUkRRkczpKQDWS182QQA/b5h7u4szO52KkN0ywEiKtkL0KGJ/9ko2fB28I57qZyLqTv3Btv52yJ8tj4EcmAt2xmTrKFua8KElxOGBTjGq38wwohWkaoi9+D9CcbGbZOI0TV004ijKzph7IY8y4t291GHoCOKKfME8FvvLCe41A/4Vf1qYWBZpSHBxMuQekqFmBQnBCIilq0GuBeVUTrMrJHISikSmxB8Lqs3cjodPYY5ufq4yez3GRVsMqbfpaLV/2LZkfJ25CcIoHBbde/qRmrLyKnzfwOfRby/4BTWpxKOrcI1wcjfAqYYEI5unH0Epm87gE5NptNYL9Pay5HtYMIylE1FEioSnakyyHGPLGYaMSRqip674rb1yh4i2HbBv7Lrt7yRHD87pokehVQbJpNF1i79UmcOgQSVnhuYSS+CWLULDhlM0UKb5NIfg3zNskRoBtSKAmTaRtvNbanRGkcGYDeT7b85oklO6m0stqaUOG+WfbxhdYnQ8Kk5+Ggp+bD8t/O8N5T20t7gTbjlrqGkSb1ZNycGQCWSpSvQyerjep36AYxxV/MVzGBBe27G9pQuJ4mVgqangInWihFei9yTv8g6AztJ+FHhSM8vdjU4IgHLDGx3yLvsikn8XBTh+zBCdwxSKVNEgsyBgLrL9T
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(36840700001)(46966006)(8676002)(31696002)(36756003)(47076005)(7636003)(70206006)(2616005)(356005)(53546011)(70586007)(83380400001)(4326008)(82740400003)(426003)(82310400003)(16576012)(36860700001)(2906002)(186003)(110136005)(16526019)(26005)(336012)(5660300002)(54906003)(478600001)(86362001)(8936002)(31686004)(36906005)(316002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 11:29:05.3281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6044614-290d-4fe0-2042-08d8f438313d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 31/03/2021 12:10, Joakim Zhang wrote:

...

>>>>>>>> You mean one of your boards? Does other boards with STMMAC can
>>>>>>>> work
>>>>>>> fine?
>>>>>>>
>>>>>>> We have two devices with the STMMAC and one works OK and the
>>>>>>> other
>>>>> fails.
>>>>>>> They are different generation of device and so there could be
>>>>>>> some architectural differences which is causing this to only be
>>>>>>> seen on one
>>> device.
>>>>>> It's really strange, but I also don't know what architectural
>>>>>> differences could
>>>>> affect this. Sorry.
>>>
>>>
>>> I realised that for the board which fails after this change is made,
>>> it has the IOMMU enabled. The other board does not at the moment
>>> (although work is in progress to enable). If I add
>>> 'iommu.passthrough=1' to cmdline for the failing board, then it works
>>> again. So in my case, the problem is linked to the IOMMU being enabled.
>>>
>>> Does you platform enable the IOMMU?
>>
>> Hi Jon,
>>
>> There is no IOMMU hardware available on our boards. But why IOMMU would
>> affect it during suspend/resume, and no problem in normal mode?
> 
> One more add, I saw drivers/iommu/tegra-gart.c(not sure if is this) support suspend/resume, is it possible iommu resume back after stmmac?


This board is the tegra186-p2771-0000 (Jetson TX2) and uses the
arm,mmu-500 and not the above driver.

In answer to your question, resuming from suspend does work on this
board without your change. We have been testing suspend/resume now on
this board since Linux v5.8 and so we have the ability to bisect such
regressions. So it is clear to me that this is the change that caused
this, but I am not sure why.

Thanks
Jon

-- 
nvpublic
