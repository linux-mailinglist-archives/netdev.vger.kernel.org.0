Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E593A368675
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbhDVSTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:19:53 -0400
Received: from mail-eopbgr750041.outbound.protection.outlook.com ([40.107.75.41]:51441
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236459AbhDVSTo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 14:19:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YY06BdNKIakhgIrla788MRbbEfOKpPscljR7KcZbcbwZb1fDTueMSL1fgkiiUOlDUNgcRy9PmzVWk4HC+zLU4O+bzbfnomI+Czsiu8dr+eUJupDoRBxYaWpwXSoVejHyg4S/Re8K7v/wY8NNRMvHWXOEVhFQWqI88MhORcTGT85+QLi/sF9XGN3SU6l+waZbF4U7s5bxCOPe9ACjqoJKwyeLA4fxhM4CiK+lBEQhnk5oRJASaql/O5OZrmIIQKed8++wbqH5uSpv5UoErt34x2vIEu5WN984PajlyeSqeL6GI4M1PaJxAQy5wqyaQGeqLqJbiasnMGiO++LTxqQsBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4OdCrXfBvq4KREsWVSp9AsTm2Vt4WdM5WIGx/tz0h8=;
 b=HY7+c1hySGU7i4Uz/1epci53wygz11PWRFQ9820A98eGScVHHRb2u/8djBEqZAx9XeNmBSOG5LzcAoqEiwN49Dk8Pxd9ffW3G9+N6hrJf8JxtUKJpmh2CtHVZiPg43jZrX6ZCUzpSXKTBcjanVG7A/IW3unIhuipcaVauhwsE9m0Z5wAWGD0PQo+IiHxG3CU8slmiLfNONj7PlvgSubwFqRPsjuUdQUbOtqXwnwRkl324tF2wbkb4jqrf8IF2vlZjo83rIZh4ELicOAvERw+B+vL/yM34VOUPo+K9iyCZ/7QHZF+7KYtzhfUKXJqdYylNsjfbkJf8EyxPyxUUntSZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=foss.st.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4OdCrXfBvq4KREsWVSp9AsTm2Vt4WdM5WIGx/tz0h8=;
 b=LnZNYRafzU49HITHHclfNA0/OWC5Bm3VRnqWUGlBmj6NiGVGngPNdvTmT3tQ0wOrRPlue1lseQundtemXUtnPWeAs8h1pXwDhM+qmLHFzIhKXiQ57GMMdUMlfKU2mtmQwyW5uhylDqejNn6k7T7MKVftFObC44qlLrSHvwjxBDVY+LRO8GpQB8pXEhSXKJ7Ar0YeXJQeTjbgr7RGcqAYxcIqhsiinXQ+ODk9m32oEM6eRV8Bhn3BIqOf6MPh7BcgQgayIP+I0zHewtFeM0gkAGeozwgCtOSPEW7fK/u6qcy30lvGzKzCxF6ZrxgvzaQ0LTSavNQqn/LAlbCcJ6gR9w==
Received: from MWHPR17CA0054.namprd17.prod.outlook.com (2603:10b6:300:93::16)
 by DM5PR12MB1513.namprd12.prod.outlook.com (2603:10b6:4:d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.23; Thu, 22 Apr 2021 18:18:59 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:93:cafe::c9) by MWHPR17CA0054.outlook.office365.com
 (2603:10b6:300:93::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Thu, 22 Apr 2021 18:18:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; foss.st.com; dkim=none (message not signed)
 header.d=none;foss.st.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 18:18:58 +0000
Received: from [10.26.49.10] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Apr
 2021 18:18:55 +0000
Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
 <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
 <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <2cf60306-e2b9-cc24-359c-774c9d339074@gmail.com>
 <9abe58c4-a788-e07d-f281-847ee5b9fcf3@nvidia.com>
 <22bf351b-3f01-db62-8185-7a925f19998e@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <bd184c72-7b12-db4c-0dd3-25f0fd45b7aa@nvidia.com>
Date:   Thu, 22 Apr 2021 19:18:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <22bf351b-3f01-db62-8185-7a925f19998e@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 537714c1-3166-4a00-255c-08d905bb1905
X-MS-TrafficTypeDiagnostic: DM5PR12MB1513:
X-Microsoft-Antispam-PRVS: <DM5PR12MB151363562C54F03C52C2B96ED9469@DM5PR12MB1513.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PCW9mbuapW64emRdxtEGV/YG9gG2c/3/bjTX8jYQ4/sL8uTM7OW7xWaWR0ct/M+vkg/5ayHkmWgkczxb06GsIVNvIoePjpYitzllYoyehsr24ajt3tIfOutrjuX8+v3zw/JsRRAGbUaKtSD9KUXNNFJbLTZIukY1xHi/0c5ptDxOY+EupMEkVzN3HCu4lMOv8oxBIn4bhjH/XyCKzWcvAC32NNnT7Embv+X+wtmmjQmgpO/DlA3D366s/yQJkteVkof2OGx2WY4USolhkM+v9BqTWGxTu9oFzdJU/91r/5TD8MMcGs1pdGsKJFMzoUI1g5pEyOWh1/lpq3ZH6//azeLo5u3+cbSUeS7tJX5C5GrSbbjEDsw59dWhWkqMrLBPfger+/uFwShok4F4Lf2kcvpzqE/7NchsoFoNB6orVm8nNzacR4O2ofU2k4NOzYybl7t9Ro13/G8kUfmE/ZbJVksyZteWRe4qQIFySytcri95G8DlP2/wz2yvMIGpKCuVpxpbHZdcLVK1lGizJOgiHvTWQzYxZqkTc9PJJIbWsogtiMv4fa8h/PEKmekpE2iCxtSE1uQA0tBBpRTE8m+gdf77wdczEVNnu5kfgCJIQMvlknW3ocPiqkjA6Pc45+4+0up4UVlN7N3GRlGoOQuQD2oJwaK0bSCn/Tvmg9uJeDua1p+jhnCqA8eG5DNIC1Qw
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39860400002)(46966006)(36840700001)(8676002)(2616005)(8936002)(36756003)(36860700001)(53546011)(336012)(7416002)(426003)(5660300002)(70586007)(82310400003)(70206006)(478600001)(16576012)(83380400001)(36906005)(47076005)(54906003)(16526019)(186003)(316002)(110136005)(7636003)(4326008)(26005)(82740400003)(86362001)(356005)(2906002)(31696002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 18:18:58.5817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 537714c1-3166-4a00-255c-08d905bb1905
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1513
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22/04/2021 18:32, Florian Fainelli wrote:
> 
> 
> On 4/22/2021 10:00 AM, Jon Hunter wrote:
>>
>> On 22/04/2021 17:12, Florian Fainelli wrote:
>>
>> ...
>>
>>> What does the resumption failure looks like? Does the stmmac driver
>>> successfully resume from your suspend state, but there is no network
>>> traffic? Do you have a log by any chance?
>>
>> The board fails to resume and appears to hang. With regard to the
>> original patch I did find that moving the code to re-init the RX buffers
>> to before the PHY is enabled did work [0].
> 
> You indicated that you are using a Broadcom PHY, which specific PHY are
> you using?
> 
> I suspect that the stmmac is somehow relying on the PHY to provide its
> 125MHz RXC clock back to you in order to have its RX logic work correctly.
> 
> One difference between using the Broadcom PHY and the Generic PHY
> drivers could be whether your Broadcom PHY driver entry has a
> .suspend/.resume callback implemented or not.


This board has a BCM89610 and uses the drivers/net/phy/broadcom.c
driver. Interestingly I don't see any suspend/resume handlers for this phy.

Cheers
Jon

-- 
nvpublic
