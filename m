Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DB7369231
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236857AbhDWMek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:34:40 -0400
Received: from mail-bn8nam08on2066.outbound.protection.outlook.com ([40.107.100.66]:55168
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230305AbhDWMej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:34:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDYM6OFkzAWDqMaM5oySHmu/lzVDttb/nQ4dI7BpdYB3S0FnmS+Zp+/mwrfXb4Chxb8pPK3h6KiJ5Cx5gLXj/oC4l6e3XgvGAIJJLRe6B8t6YaLx5LDYI23YE2ZSa5CPanJDrMerkEkOY08gEpqf56Z14bXY3+UrFPTsYuGJp5cDU7fAXMYEiAzdzO30p6p814Rlj0L0zp4EOLr2nDzB/9QG3zFXCnADSFwWm1JcoOHKxnZ0zh0GXIGXROFD3x0FY5ySMZjgHz1fsPTLqdyIgjtAVZ/KFymixWAn9V1JFAHDgy3DfIcl8wb18AD0AubjmdPSCG78Xk1BBBLEmi5Yfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNUi7wtcvywfkTMFcEbB5CpUyS566uq620Odr3JeLM8=;
 b=DGa3EVWeBNmXgkkuAI7Hgzt6iR782w7ovyEVzAnmN4+n+IeTdeZS1gTtnXR78qNfv2mXdqZd9X00I8GBLlfEssX4HTk2CIHNajs5AUDwM7U6cB87Nu/OeIEUvTjoOvHRM5eINyObBLKdz1XL0nvBbHzEmgSbch6ZZ8XaHCCAl4htYE3pKrxNHjUzZTDBpbX9o1+NOfHagJJ5kdobloBZkuLvlUErTXBtMyEn6Ed10+3FbDCpT24Rle7aKVGVuchRoLpYcUikXSzZAbwV4BD6Ddo6jKaW3eS+nxjb+ao7O+z0a5pB3YSdNLzkjxI37yb3NQopViPRdwlqNPpK04FGnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNUi7wtcvywfkTMFcEbB5CpUyS566uq620Odr3JeLM8=;
 b=bBnteYyEqm/xpiWvcjzwMss1ZjB83znJBArgeFmpdGq8e0FJQ7Cjet6xIRReQFBVVHgszR7jN+y4s03PzxidzFlhRBBIKxpUR6AmUdAa3DxuLii2SpWphbzTJKHbe3h3AQXazRCwwhzHTjRejfjwFZlVO2z2INRy2KYsD+PgcQpRg55QR9spA7MZBjw4+mXcLqiSophdN3xv55Hx20U5RBxBlyEXXU7f7ja+mZvCVIQYjP79k/fFan5TcGWukdy0kXt7qmllwv14F9w7dfPyk4Irc7CWuBttwY+HhNqyn8bHq8iY+3DkvPwoINX41OxeTFPfJ9LnEU4TRr12Z3dEVg==
Received: from DM5PR18CA0054.namprd18.prod.outlook.com (2603:10b6:3:22::16) by
 BN9PR12MB5050.namprd12.prod.outlook.com (2603:10b6:408:133::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Fri, 23 Apr
 2021 12:34:02 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:22:cafe::c9) by DM5PR18CA0054.outlook.office365.com
 (2603:10b6:3:22::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Fri, 23 Apr 2021 12:34:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 12:34:01 +0000
Received: from [10.26.49.10] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 12:33:59 +0000
Subject: Re: [PATCH] Revert "net: stmmac: re-init rx buffers when mac resume
 back"
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Thierry Reding <thierry.reding@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <qiangqing.zhang@nxp.com>,
        <netdev@vger.kernel.org>, <linux-tegra@vger.kernel.org>
References: <20210414151007.563698-1-thierry.reding@gmail.com>
 <161843460976.4219.11833628435503987516.git-patchwork-notify@kernel.org>
 <d51f9f85-9093-86d7-fe41-a4353eb6599b@nvidia.com>
Message-ID: <04978066-b4df-7bcc-0db0-4a2f091a1f00@nvidia.com>
Date:   Fri, 23 Apr 2021 13:33:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <d51f9f85-9093-86d7-fe41-a4353eb6599b@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7eb0b52-43bf-4405-a017-08d906541316
X-MS-TrafficTypeDiagnostic: BN9PR12MB5050:
X-Microsoft-Antispam-PRVS: <BN9PR12MB505005233600224EE61186F8D9459@BN9PR12MB5050.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+2WsobJrABNpB2aD6smBzHgR0BOh/g5NmIHFoAijM3cQYVotyEg/7BKNw9Uk7SeTL94tgtSFG2BOvPQJjZZpjQoXe+UEmVxPqmIAzniSP64zC0CKG++Lj4hsKSb8Dwr1MTDZT7g/aejUsjJHtrSe5xtIbPYAsUFuR94Akwq2utKs+fDQ/k4MbDweJeG3bjwNbnAXdUp+4ucNQpSjjDVX3lXGf1K1L1t+wy/+8fTlKrgsKynNz+s0zE1CMmAIT4tbxSGKilxbxjK8GSs1wPHkpXkXkAmFR7Qw5Yqp2tYm+L7JkXl+h1ExyRrGMxiFE1EXAdnhlNb2VLNMVmLP5IokNWFRFFMPruzq9HFvvcTazKy5QguzsWqnbsV3s6yrzCzkxfTGoaYMjbBFHycBG+X10NilbbQ0MsRk+v1uYnA9+YW5PW5kp/IIJ5xKpu9zdYnSRehmqA1S9KXD/TUH9AmRv6bcn1kAnZl09HG8mgLTfaLb/WVkf4suvhfGzAMxpslFp1RNXI40zz54Hay9JSQdRohKYPyd8+/joCu6g4Hg1Gda3GYceu+yEFCTslmkucbpsBA9Vk5CeXKgMBfbRgDsfwZMZsLHtwzraaItWPWd3RVmK+zH3hOoYlE5fcJtvheFpNNVVkcdEijxpbAXplqGgZHUCKlxlFct6jkH6UeGNmpO2vSevuTx+AuzaywjQtTVPuS4F2mmBbb4V6vpTKv5Bp0BrLojNv1vKHW4qAeHEyucrCIFkHgZ8wcyv9qjyzOGT9yylPSKnnkZiMFy48v2Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(46966006)(36840700001)(82740400003)(16526019)(336012)(8936002)(70206006)(426003)(186003)(2616005)(53546011)(8676002)(5660300002)(356005)(70586007)(86362001)(83380400001)(36860700001)(7636003)(26005)(16576012)(54906003)(110136005)(47076005)(31696002)(36756003)(36906005)(2906002)(316002)(478600001)(31686004)(82310400003)(4326008)(966005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 12:34:01.5795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7eb0b52-43bf-4405-a017-08d906541316
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5050
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22/04/2021 13:48, Jon Hunter wrote:
> Hi David, Jakub,
> 
> On 14/04/2021 22:10, patchwork-bot+netdevbpf@kernel.org wrote:
>> Hello:
>>
>> This patch was applied to netdev/net.git (refs/heads/master):
>>
>> On Wed, 14 Apr 2021 17:10:07 +0200 you wrote:
>>> From: Thierry Reding <treding@nvidia.com>
>>>
>>> This reverts commit 9c63faaa931e443e7abbbee9de0169f1d4710546, which
>>> introduces a suspend/resume regression on Jetson TX2 boards that can be
>>> reproduced every time. Given that the issue that this was supposed to
>>> fix only occurs very sporadically the safest course of action is to
>>> revert before v5.12 and then we can have another go at fixing the more
>>> rare issue in the next release (and perhaps backport it if necessary).
>>>
>>> [...]
>>
>> Here is the summary with links:
>>   - Revert "net: stmmac: re-init rx buffers when mac resume back"
>>     https://git.kernel.org/netdev/net/c/00423969d806
> 
> 
> This revert is needed for v5.12. I was just checking to see if this
> would be merged this week?

I see this is already merged! Sorry for the noise. It is a different fix
that we are still missing for v5.12 which is not related to networking.

Jon

-- 
nvpublic
