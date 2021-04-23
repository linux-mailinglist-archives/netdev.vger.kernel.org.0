Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301F9369401
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 15:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238302AbhDWNr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 09:47:28 -0400
Received: from mail-mw2nam12on2059.outbound.protection.outlook.com ([40.107.244.59]:56385
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229871AbhDWNr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 09:47:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=addffBSCRIroaYV1iYk7ncbJQILKXT4C8TrTPssHXB1vmbX/gm+HHtsvg+ECvJzrKzhq94x51yAqs0140vdQ6qBAvvF2XmlMJsiCDFw+rs10uerTsnrCaGwvPIaVRgpFQofnESFhkh/FL9yXVvagF2HdxM6gktroTm92FpI2YQpAkt/OYdoqJkvrukW9/PfT5Oi6gPkjET/0GjHvW96PWQ5VsCm6spsRI7uRgIdFtt82RXpNH5kO1whCM6AjGQ0ckFASZ84AO3FxK9dmQ1LB6uUk5M56XGmDnVDSwIWPg9X9n2VKkDGrI8DlKUySBgyLVyQBOmAx9k1R4wCsiPC8fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6oMd6BcdzG8+Keea8TCHhZJgDNAnlfxyMKPdorFCo8=;
 b=IYKehrRzkrVOl5rK7VA+rjZFtIhjoyQx2jcn0G9KVC8v/i+ZTew2sxxYSF92WLp3O4CgJ9ZxtaTl9EFpdBiHMV0jyJ18244PS1lKXBP1Ti2ofkdoTOeYwB9IIJZvbK1GlsxNFRec08IvjkcFJX+ZA4XzaGWYp50tz3zYg8/XFsI6zmjmwbn4PvwW6sVQ9CiZllVwcMQlCQsCogg0BBDxhfW5jabCk3PTs0zLO3W4sh0Ny8f+uqKlFli8us63dtyfGa1IFOH7mD05w/3a7VLo8sJOCgW3yvK30nGLQllzyp35iZYY1YW1cWiq28o2kEnHjc0k9/PgnrrnewzeeOUbCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=foss.st.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W6oMd6BcdzG8+Keea8TCHhZJgDNAnlfxyMKPdorFCo8=;
 b=azsM85yKtvqT+Kc9LeOyg3ZFLhymvzvp22bhrf32rDj/pmtcxAV34NPQ1lbyslXtwohBrP7ig1961Mi89JbC5LsXRK6XV8ERTUS4WyK8mm1bDYSD18UUhdRWnSGC52HjEfi5g0keFp/xjhzSyw/AmRt7y1mH9QrBeacJrZO0IvJ9YPnv5es5kkX6Ep5u5zvzHdISdizHu5rKAgIDnvlfsYifeZi06wZMSwXZ63uKducXPovLjKVU5fuxGj3YSMHWHa+n1Tg9qn4lPrJG4jay8mLe/MbPW7C+qlSI/8UgDQWuCcQoshmZQ8hIDTCM6VaM/m4FXgEdfYmNKbvZOnETBw==
Received: from BN8PR16CA0014.namprd16.prod.outlook.com (2603:10b6:408:4c::27)
 by BL0PR12MB2386.namprd12.prod.outlook.com (2603:10b6:207:47::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Fri, 23 Apr
 2021 13:46:49 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::8b) by BN8PR16CA0014.outlook.office365.com
 (2603:10b6:408:4c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Fri, 23 Apr 2021 13:46:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; foss.st.com; dkim=none (message not signed)
 header.d=none;foss.st.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 13:46:49 +0000
Received: from [10.26.49.10] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 13:46:45 +0000
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
 <bd184c72-7b12-db4c-0dd3-25f0fd45b7aa@nvidia.com>
 <3ba28b13-15eb-85bd-0625-f99450c8341b@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <0e6467a0-428a-6520-f012-bdd332a7d7ee@nvidia.com>
Date:   Fri, 23 Apr 2021 14:46:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <3ba28b13-15eb-85bd-0625-f99450c8341b@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb318dd0-4ff9-4b41-39bc-08d9065e3e67
X-MS-TrafficTypeDiagnostic: BL0PR12MB2386:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2386C584738F5303F99835A6D9459@BL0PR12MB2386.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oPFdNy2LRKV+RojqYmmnrGfLknCr8kVSjWNuqndlkKtpA2KddE4NUW488yOk/b6tA7kiASDxJpsgMmXsHJZoqmWgrsyBpKJV6rcO6fQfd5VwCdm2UObYL6/0clnYa245n6wDBXZAmTt356/bbjGhVli2FE7N6Xn6iYc3wXHI2TBENJ5vJg2tX3dhgzOItuP6ePidr1wcKrfEHC+j193ReDp+ew6fUC1F7sjQKaHDoabnZVT2rAe75WLLL5LIHVO3ozg13iFxcvs0QxwPGp0j1wDencUdnO0zBu1k3lZHnKmSiQnzqRvUXAEjxQ/L2CHt/X0h5r5SPklU5UC4805aEoanilgjgENdUxaoH8wObiXl9LafWnkcpXt8s8zJ/MQv8uYEznbypKQQA7qagmYb109M6I3Nhriur5JqPfTENPdKbvZyjA1OXtYafPJkQZHu4bcGfzZRf8YyG6lP5ODCA5Ua/3lzy5lQlfbmYvinpPHl/HTs5qvnHRMyVZbGYrKprvUDX/2CL4B5yUSbR1AGsRUoiFLAiA99tJsYJ9NRnyCEJGtcaEgVcKkao0OvYfpBYQivygWwKKAoUint9DBFsz2HlukWsI4tRCCt8dF0HtZvd8uT3v99cJ2EhXktk7t6OqK9gIM2JTYTz2Xz77+p/kkonOpFb6vvgOPk8jFS+0InPSSoacDZ7/zN7LHHZRx/
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(36840700001)(46966006)(36860700001)(54906003)(70206006)(70586007)(2616005)(8676002)(110136005)(478600001)(53546011)(31686004)(8936002)(36906005)(36756003)(16576012)(16526019)(336012)(7416002)(356005)(86362001)(26005)(426003)(83380400001)(47076005)(316002)(186003)(82310400003)(4326008)(2906002)(7636003)(31696002)(82740400003)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 13:46:49.1631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb318dd0-4ff9-4b41-39bc-08d9065e3e67
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2386
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22/04/2021 19:20, Florian Fainelli wrote:
> 
> 
> On 4/22/2021 11:18 AM, Jon Hunter wrote:
>>
>> On 22/04/2021 18:32, Florian Fainelli wrote:
>>>
>>>
>>> On 4/22/2021 10:00 AM, Jon Hunter wrote:
>>>>
>>>> On 22/04/2021 17:12, Florian Fainelli wrote:
>>>>
>>>> ...
>>>>
>>>>> What does the resumption failure looks like? Does the stmmac driver
>>>>> successfully resume from your suspend state, but there is no network
>>>>> traffic? Do you have a log by any chance?
>>>>
>>>> The board fails to resume and appears to hang. With regard to the
>>>> original patch I did find that moving the code to re-init the RX buffers
>>>> to before the PHY is enabled did work [0].
>>>
>>> You indicated that you are using a Broadcom PHY, which specific PHY are
>>> you using?
>>>
>>> I suspect that the stmmac is somehow relying on the PHY to provide its
>>> 125MHz RXC clock back to you in order to have its RX logic work correctly.
>>>
>>> One difference between using the Broadcom PHY and the Generic PHY
>>> drivers could be whether your Broadcom PHY driver entry has a
>>> .suspend/.resume callback implemented or not.
>>
>>
>> This board has a BCM89610 and uses the drivers/net/phy/broadcom.c
>> driver. Interestingly I don't see any suspend/resume handlers for this phy.
> 
> Now if you do add .suspend = genphy_suspend and .resume = bcm54xx_resume
> for this PHY entry does it work better?

Thanks for the suggestion. I tried this and this appears to breaking
networking altogether. In other words, the board was not longer able to
request an IP address. I also tried the genphy_resume and the board was
able to get an IP address, but it is still unable to resume from suspend.

Thanks
Jon

-- 
nvpublic
