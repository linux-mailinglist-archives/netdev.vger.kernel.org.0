Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA98369406
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 15:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbhDWNsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 09:48:52 -0400
Received: from mail-eopbgr760075.outbound.protection.outlook.com ([40.107.76.75]:57605
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229454AbhDWNsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 09:48:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEmUIsBP6sajVwUb4R1OJzm43GfsBZiet1d+rtA1cb3foOCewv0up0SlJg6y978BECOituvs5vqJIb9u8r7H5XXlusuwCCz2Uh/YIVy6IDtdPg+0RE4H1Dx2Uda0HB7iwtjgSX2rQths6lZfSqsp2lYlOkGp1Fe6CBN0DMwk75Xm/uU7VeXTIXHoS27fS18oDr02NjMgqoVh4AVCw16LYWs07v7dU1KeXXQZf41QWEr7Ksz3o8j5zLuyCTUV+O8OZLh7cNt5ofd2AWHqNWqLHBduOmtsPBtkEs0RfmttTN+0io2NTHpPn6Zp8X/Zq9k8fHstCGd4dHDrXwEmaturrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kBh3eJIkuz1dLTgUbOpCr8mk2ZIUi2geSyHmiNhoJds=;
 b=FAJaxVAc86v8+AbjNL+pFLgxvQWgJBM+qfGQPTQxbM/ezK5RFsx4Wy3HYxPZXZO2JMLmzwI+YWoZi7dFHZ/YD3CS/GLC3EhgSPiw8s3RHoNFkdGB2hLEaAdRvrTfhpBQYytNiE32WBsDJh0NfCWkLYw651xucZv+LrsBgvcUc7wmLgbvqTEBSy2TdUIlibwSU0ILSGJG5Qkc06WzeB94anrpazxlHySdj4hAoB/97mZWqH7m+brTVbIrWVcngQHA5y8rqvOSF5YtyWtJQp1F3AIHSPTf0W5A9Veh2iUTa2n1hcOz0muBjWakWtmSgC2ov6C0f46qX8vX/+uEHa0Gkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=foss.st.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kBh3eJIkuz1dLTgUbOpCr8mk2ZIUi2geSyHmiNhoJds=;
 b=QKxXGI8xIppgtPmWki5h3iMoCAl8KfS2mdagDvnjJe4Yxqksw4E1b41IMSIpyq92Z5Tn+Q7TN9KeJjWzAixw/JJrhfdTBzarkawhe7dEV/uqcUKRCa7z37xUdCy2bc2oKq2Pjc/gpVlCy+WArwliV6QuubBQYwS6XX4QF+o4wGWXLdBNaPSGTdvwpvtND3YKjwM9YQfnFIjxyGseFbynW/ESqLb2jn059GhREL+HfFpqkPkL8TvMkDZDbkI7FhHO/lw9iMw9Jwks+m6dQXUCECQoJqprtLKnXUYr8e6wPN75nOW7eVEdmTXlV6pYt5XQVIQubXBIN8+LsDT2+XUYhA==
Received: from MW4PR03CA0131.namprd03.prod.outlook.com (2603:10b6:303:8c::16)
 by SN1PR12MB2542.namprd12.prod.outlook.com (2603:10b6:802:26::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Fri, 23 Apr
 2021 13:48:13 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::aa) by MW4PR03CA0131.outlook.office365.com
 (2603:10b6:303:8c::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend
 Transport; Fri, 23 Apr 2021 13:48:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; foss.st.com; dkim=none (message not signed)
 header.d=none;foss.st.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 13:48:13 +0000
Received: from [10.26.49.10] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 13:48:10 +0000
Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
To:     Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
 <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
 <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210422085648.33738d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <1732e825-dd8b-6f24-6ead-104467e70a6c@nvidia.com>
Date:   Fri, 23 Apr 2021 14:48:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210422085648.33738d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 394eb778-d25e-46c9-0711-08d9065e7077
X-MS-TrafficTypeDiagnostic: SN1PR12MB2542:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2542FE6A15208B0788148F58D9459@SN1PR12MB2542.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9XTx8UlAXeR3Yae2svfDPgd5estqpSPdB1l5On+mQPTJg6T7+Fl2QhggFyter7nGu16sRXlTgiMg6+EoUY32tn4V5HQmNS+ktSj3OeHiUmH2shMfZ/Iyk+gXv1HuJPJVA3uwP2OIu3t9tKKjb6zroha8O5zkO1YuOQhORLAyV9VFAUgCiXJcLUIFMQoPmP7FgZDmuAh3vkiPLQ1LlH/ZJBWRkJOalT2Sq0sLlFE0HzAjA2WePIV3TUPP3g2vHyCb+XHm2oHoc6OWVI/hfjMlSLasE8EDnMN8Uhp/2+fJbYbswtqLLZWJVOGAikH0QN9MDYMzM4SoprABtmxpILK5IbDy+cWNGKiNDfWZAwbg8dS2muTAt2upFXjWSGcUEX6vsRVBdvJgSB178bsZyBtjcn6BxIFPyT/O+GSb0AnIbVAsos82ebmhHG/8VhVxvhupAzw/SthJqjf6xE5stLewOl/lTAKK9xau7c1JLQ4GB5VosBkDfpXu8MHGtom0t9fb2go6WZNuHsLtgg4/Q5l2wEuV8j4llxTIBTI7SUo2eZMJXOufnQmRnrTH78lgFA2WN9NEnFSdItIpSra5bP0/+nTOYuELZD372eXHqiGxG7oTN2uF0JgGySLg9IdW8qKZ0pBMUuQftVSmALTwl95bTZ/YzQeKcfnPC3KdkejfN5Y1jmbKxTp1qJIELjKxu3tv
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(36840700001)(46966006)(336012)(426003)(26005)(2616005)(356005)(83380400001)(16526019)(186003)(31686004)(5660300002)(2906002)(82310400003)(36756003)(4744005)(478600001)(4326008)(110136005)(316002)(31696002)(36906005)(47076005)(70206006)(70586007)(7416002)(82740400003)(53546011)(54906003)(7636003)(8676002)(36860700001)(8936002)(86362001)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 13:48:13.1897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 394eb778-d25e-46c9-0711-08d9065e7077
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2542
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22/04/2021 16:56, Jakub Kicinski wrote:
> On Thu, 22 Apr 2021 04:53:08 +0000 Joakim Zhang wrote:
>> Could you please help review this patch? It's really beyond my
>> comprehension, why this patch would affect Tegra186 Jetson TX2 board?
> 
> Looks okay, please repost as non-RFC.


I still have an issue with a board not being able to resume from suspend
with this patch. Shouldn't we try to resolve that first?

Jon
