Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989A2365A3B
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 15:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhDTNe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 09:34:59 -0400
Received: from mail-dm6nam10on2072.outbound.protection.outlook.com ([40.107.93.72]:9525
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232609AbhDTNeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 09:34:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPQ3CvBllCkW2cjFqTTRXfCDTSasUYiw4MzzWUyYFWc1z3zi2PTu0HA8LcrZ0NdwmJyDKOMe5WULREy4fB4Tno2QDWGJJ5ujpR6UpgeOZ9ZZbPfRiw9I+J4AicJYRtOsg4VW32ExMBRQtwA3uVM8g8feyEE6lwEHL5pDVeHWCHPMlW5QPTCYDSM8ZQSvxMRHajPVt74Rtl7AM4iYRVcaHNIUpO8H1Q5cFHG68/wHDkWRqjrzWd2WBMV6Wsfy33g2JIy5zZsOZ+qZ3U5mVRebJFFlb/Lu/nXKud0eAAiG1yOetYMTsq+ZjILHXusZS1Zflz+mfc5cETvtqDuM/7lFXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5VljEUDVinQFgC20GNUf3d57/fnjDO5ixHK1NgJcXQ=;
 b=LGsYP1QTRaL7ZazT/2f6URdL1FU8DcSrZQSQq/xV/gp9/Msg7zGrts3b9Xs+JcTr2JgAwngkPMuX+PeiXHmWQB3LEdYQLarOMrNfaOureiPdnWdbXMNXpg9Sy+7fTfFi9sRxkZTmVpKDnEBoCYd6nsSQm/MQVrj8IDKOymH8owY4uF/RpFq4fO/OmQ1tU0jUqq2kuxRklFHU6QyTIlCdLzCZP7tBVM6wILd2YxmD2BVY1nwLy+pKFwHp5uoV4HEy1bIswyzkqWV5cdz8EgMM8QXeE9E9jvuT8cQWv11YlgCQ1HvoNp3Irb/5qeNQyxKp9jmQ5tu1ab3jtgmttBhxnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=synopsys.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5VljEUDVinQFgC20GNUf3d57/fnjDO5ixHK1NgJcXQ=;
 b=FVdmZrwjSr4nAupYO9i9/8eUiHQwftdxSpRoYOF0vc+ZYf5st/tAbttgRMqIjsmTh7HFWzqEm0YAjYwscyerfXuXDtCtQVtXRgpDqxW1ZJZfSR/CoqnxwgOrkBNpHnG3xuoyz48SJPUTdbo04iPIAbFH5usNYRj7pYEn9CQrxWJsiwJZFN5+iXkVc8u0F6y0ZtJk8qSz9dvN/mRbwbDjfJpc/8jrUR62GAcHm9nCiaEwmQQF94tj65AenqMGVN7mfSdroOJ78CPYgNVT9n+q9SWtzWL1punDb/HmfARU9VZo6QtWLv/aHofwHPUx0xjA+N5CMEFnPIIzWRSmcLkgvg==
Received: from MW2PR16CA0066.namprd16.prod.outlook.com (2603:10b6:907:1::43)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Tue, 20 Apr
 2021 13:33:45 +0000
Received: from CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::a1) by MW2PR16CA0066.outlook.office365.com
 (2603:10b6:907:1::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Tue, 20 Apr 2021 13:33:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; synopsys.com; dkim=none (message not signed)
 header.d=none;synopsys.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT026.mail.protection.outlook.com (10.13.175.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 13:33:44 +0000
Received: from [10.26.49.10] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 13:33:41 +0000
Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
 <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
Date:   Tue, 20 Apr 2021 14:33:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9acec2a9-046a-476e-c3fa-08d90400eb58
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5439607D5665E8662027C110D9489@SJ0PR12MB5439.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vkRPC8fTpefyLyD/T5Zs+ww2ZZGeBiUCxpMnAKW1I9E5CnDWKYqCYCT/Kyn1HRet2/1QjQrYrlFgJ+q6QF9OgrRkvbwF0g7dL+PjV6LExZyPy7JDqM7SkhiPuEk+Zdpv0Dtzq6MotepF53Cj15NNV+u7xWjBmE+kH4BF1iV/f9JejyA2303W86wN6Qu7D+JWxozagXbecz34Sneachp1SzZwsE3rRrsiE1dPj8EZrF1POP1dLSOs28r1Lyaq9yo9CBsdHvatjHAcXlG23LgcbOj0gFU8xJkX/Zp3bJTFB4s+hPJTPtTeOdPFG3w2oWlDHv0R9+k+XZApNMF4QkafzF87Avfv2yDStnIZcxXVF5wrUDMa98sy78E0GTtHkKiJrOVg+3TLpgFHRT7yX7cgSyJrIvKXMvf20L+o5axRHyKE2AwprXXgi4qhJDYsp/kWp1NQX0lIbApr6NChmGMP6+OEeZCm/ZccqzfffkKcpBWLdUeC2i53BJLy+EXDWRdjQ4QTWr7w4q0r96MT9JrAUw6fRQQ+vd+DduQ8BXuJTG+MUdd3n/RwnNgwWDXhooDePZANqVc0bJZ3fsUzdrURtATB4AMDVLRNzUazx43Wad48wx7mcmiV2RNUoDJG05LrSLP7ElrIZKkjgKlaNF3ZA69Ct3rP/AEy7B/+BQ4oYNefZPrniThVK1PYPVR4SRlb
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(46966006)(36840700001)(356005)(82310400003)(26005)(316002)(7416002)(8676002)(86362001)(36756003)(54906003)(7636003)(186003)(31696002)(16526019)(4326008)(8936002)(478600001)(110136005)(16576012)(36860700001)(31686004)(36906005)(83380400001)(47076005)(82740400003)(336012)(4744005)(426003)(5660300002)(70586007)(2906002)(2616005)(70206006)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 13:33:44.3560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9acec2a9-046a-476e-c3fa-08d90400eb58
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5439
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20/04/2021 02:49, Joakim Zhang wrote:

...

>> I have tested this patch, but unfortunately the board still fails to resume
>> correctly. So it appears to suffer with the same issue we saw on the previous
>> implementation.
> 
> Could I double check with you? Have you reverted Commit 9c63faaa931e ("net: stmmac: re-init rx buffers when mac resume back") and then apply above patch to do the test?
> 
> If yes, you still saw the same issue with Commit 9c63faaa931e? Let's recall the problem, system suspended, but system hang when STMMAC resume back, right?


I tested your patch on top of next-20210419 which has Thierry's revert
of 9c63faaa931e. So yes this is reverted. Unfortunately, with this
change resuming from suspend still does not work.

Jon	

-- 
nvpublic
