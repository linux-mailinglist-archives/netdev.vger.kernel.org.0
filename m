Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348B73766FF
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 16:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbhEGOXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 10:23:34 -0400
Received: from mail-eopbgr750053.outbound.protection.outlook.com ([40.107.75.53]:3985
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237621AbhEGOX0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 10:23:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUdfzo+jffuBVa5waiwbccT3c1FtZMoDqTxc7LYZEnSxZNqb1CzWpSp3Jn3W9QGIJLPQ2Nakmc9TodDsGBbMAbB7u3TOHTwGRbzKUBs3JdgX2i3mJsPcBzRCxKqXagmUZAuTs5e7qn3ooBfJbwq8qK59ctv9LWhbmrB4ceeepkzboQW8TuKkui66TfJvFavURE6O3U57BUY7iZSaXV2JMSiLZ8Rz8g1IsQfSVJE6UvNqhOzpysXmtGUTsXozt1u4wQ66wd4TZSt9SJ5acgO6HfFaUyr17H6fJ+TosAGWo1RBoyRGhbEiyXHBIB9es+2yVMNOU64eoCFkj6MVfMUxPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nYmwnLfbmSCjLbBkV991uhzibW6o6IvG4ba/z8M03Y=;
 b=cs9YGPvsEj6+m4Sv/vPuOUBpgMC3PLLAfiY15+gHirpIcmFy8EAKuJPRyuebITsHAEnRJrmlq00zuSVLqJ8aBlFfHnVOIFxEJnpcy1O20lKsl86hB0g0oI0S0SQ2Amsym9NL4w9/w5g0KSXkzXqxBWakvg0XDXfFbPbLZ5/K8qYTM8RNcvZHQeBFrWkfaw0nBjSTrWciiSMA060P0wrKvnoLPtWz37ZxbyXxGgOhhqRb+3JnVPJuhI+1co4SW4AkhvMBCOuO1fuMbUhqc1DHoAzMGvddmepHj9vqwURiLinyhKWRXplJGCVb6nXNoK82x6GMFmvgmQkfh2T8IyumHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=foss.st.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nYmwnLfbmSCjLbBkV991uhzibW6o6IvG4ba/z8M03Y=;
 b=CalbQ1JpCf3SiRLLRxGuOGd5DXbLiJmICAxKRn2fbw33kd+30cZrLuh+jJm2XqrZd616mckXSPeAyu10KUhF4KvURASVcJiLotn0gpNgKJBQz08KiomMnxpScX9R0L95R7U5OVPfsrCYt5pk8FgmW/ctjQimY5WKlonXd9soKjMdkComL1haq4mp87wmF8+GR0MZwbYdOBHbWtmBUyLAww2JLPu+g+LOm0Xnmor3++KbJuppI101Nh90F5GPOW5LtS1LEB45ogbjL2LTl6gBNYv9rR5Vn0tf5dLD35ez7VApFs4TZGmo6gFeyXggsV7ubX1CqjqFBKugTXl7ERofrw==
Received: from MW4PR04CA0172.namprd04.prod.outlook.com (2603:10b6:303:85::27)
 by BL1PR12MB5109.namprd12.prod.outlook.com (2603:10b6:208:309::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Fri, 7 May
 2021 14:22:22 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::d3) by MW4PR04CA0172.outlook.office365.com
 (2603:10b6:303:85::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Fri, 7 May 2021 14:22:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; foss.st.com; dkim=none (message not signed)
 header.d=none;foss.st.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Fri, 7 May 2021 14:22:21 +0000
Received: from [10.26.49.8] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 7 May
 2021 14:22:19 +0000
Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
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
 <1732e825-dd8b-6f24-6ead-104467e70a6c@nvidia.com>
 <DB8PR04MB67952FC590FEE5A327DA4C95E6589@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <c4e64250-35d0-dde3-661d-1ee7b9fa8596@nvidia.com>
Date:   Fri, 7 May 2021 15:22:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB67952FC590FEE5A327DA4C95E6589@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28a3d646-579f-45ca-2521-08d91163876d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5109:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51096613CE29BE7CCB2B8F66D9579@BL1PR12MB5109.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m+sVRju3zIqRb2gSDJgKLLPGH7xHzTmcxnv5Gw1ocnJVyrP8ehsTh0OIjDdR8CXiGaZaYVB41YJInysh8DMzgRjtkT5DG/fd0fRZYVmr13ejzPwtSFsSu1YoCoAORP5pJwMoM2D+4NGFJKHY24BhiEBL+s7TFnuxbH1q53IaSh2J9KBTVRqtbbF13v2purcYsesxCsITkik3bSU5COU3jrg1b+4f3BjW9yBLLGOTkP0mQN1iOJ34tfZYhcEQ9JJbBm8+kSBeG+66xvcbGZaAw/+EhP+CbUzb8hbK/184XoD1W/KEDegSiJ8IA3+JUAiWqxv1ssssdrZcXjLGyNyCIDxB8bnoDVXpNW6EfQDOQ+IjEpZGWpQAcTWyoj/nnKJqNguuRGr2cktnvs45qXMDGj2AvEAqb1QBQUjM1lnOjxNBqhyB+DkxmCl93p8kfecwflvhKzYZs0TnNrQTW0VHUGbg2n4uik00rdncop3r7p8U9pUPtNMV4NKUZWAwlp4nDF8kj905VhOElbHPzY6xtin51kwqGAlA4UkTAzBAhkdxXT/+IiD7pWUdUd4LOA+vb+N8PkRGW5h7/pWt/3PMUMT09SVKpmgBxD1XNFbchZbxhGchMDvbXFUvxotgZmuVAV9KnPxf1UU3U+nvB/BITvxlApr+EuTS+JkRrAOK02BliuCqRH5EjHqitmt2U3CA
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(36840700001)(46966006)(7416002)(53546011)(5660300002)(36906005)(36756003)(2906002)(16576012)(110136005)(316002)(54906003)(31696002)(70206006)(8936002)(4326008)(83380400001)(356005)(70586007)(36860700001)(426003)(47076005)(31686004)(186003)(336012)(8676002)(7636003)(16526019)(478600001)(82740400003)(2616005)(26005)(82310400003)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2021 14:22:21.9398
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a3d646-579f-45ca-2521-08d91163876d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joakim,

On 06/05/2021 07:33, Joakim Zhang wrote:
> 
>> -----Original Message-----
>> From: Jon Hunter <jonathanh@nvidia.com>
>> Sent: 2021年4月23日 21:48
>> To: Jakub Kicinski <kuba@kernel.org>; Joakim Zhang
>> <qiangqing.zhang@nxp.com>
>> Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
>> joabreu@synopsys.com; davem@davemloft.net;
>> mcoquelin.stm32@gmail.com; andrew@lunn.ch; f.fainelli@gmail.com;
>> dl-linux-imx <linux-imx@nxp.com>; treding@nvidia.com;
>> netdev@vger.kernel.org
>> Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
>> STMMAC resume
>>
>>
>> On 22/04/2021 16:56, Jakub Kicinski wrote:
>>> On Thu, 22 Apr 2021 04:53:08 +0000 Joakim Zhang wrote:
>>>> Could you please help review this patch? It's really beyond my
>>>> comprehension, why this patch would affect Tegra186 Jetson TX2 board?
>>>
>>> Looks okay, please repost as non-RFC.
>>
>>
>> I still have an issue with a board not being able to resume from suspend with
>> this patch. Shouldn't we try to resolve that first?
> 
> Hi Jon,
> 
> Any updates about this? Could I repost as non-RFC?


Sorry no updates from my end. Again, I don't see how we can post this as
it introduces a regression for us. I am sorry that I am not able to help
more here, but we have done some extensive testing on the current
mainline without your change and I don't see any issues with regard to
suspend/resume. Hence, this does not appear to fix any pre-existing
issues. It is possible that we are not seeing them.

At this point I think that we really need someone from Synopsys to help
us understand that exact problem that you are experiencing so that we
can ensure we have the necessary fix in place and if this is something
that is applicable to all devices or not.

Jon

-- 
nvpublic
