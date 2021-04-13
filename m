Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5E335DA3A
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 10:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243219AbhDMIlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 04:41:46 -0400
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:1248
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229996AbhDMIlp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 04:41:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pv/gka5tPS0bHSmBWv2fBEHc+yt0lDeEQzQHg3TOW+Ho4xs98lPxbBIcYbsRxIcB5Mz6tDzCnLdpGwoJWqLXx63U9B1xDrAkAgORSNimQr+3d51PNd77l/PqfpEj3yrhYuLRxvemUDjfHSEoD03CRVr1LIXMyLmwtZK5ANAzHUmWWAjO9nQYSyk/x+QlEvfD0rzUQ/VB8FeUDiVgQ2Yvw/4QJJ4KgfEmZ/4BoyIocegse+lwMmzWprzl1ljXFwJ6YB2ndvtO1uNuEql6+80ac0QA6gVR7MldJrdAzobQZK2mPmtmzATsNok0Cj337yQECt9kUWSswaOL9tzFnpjXFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YELaEJR1iBQggJC/QAv63uYQ2l7uDc1SUMp5Qj4Ozwg=;
 b=HM41AqZx+hUBPOyw9aid8deJCQMiukeMC5Yyy1oxVwYbNwucenMdXlBCjflK0VFSe9aK8BHUFUOkTlCpS4rxAgW9ZgGQ7Q9o9+hKJE6ipYrMhOvvtxWP7roa7fykj9dAYzad31mrbHLDCLVKmwSHpohUHfda88o47pagIdHmKEL49xR5oms8zX5azYY8v/SWid/tvy9sxXLdOW263O6o0ehi8X6hCKEqVZPJH+B3BfD3NlzYTUzMflXzNZy37YZTCy9hQ07P7bSufUUoJ8y4SB7MlB3ahtikbEjNL5K97bYHj5uvteNhoEN2MKfZYkZ1NqZsRPOT/SuJjRzMZA4D8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=st.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YELaEJR1iBQggJC/QAv63uYQ2l7uDc1SUMp5Qj4Ozwg=;
 b=XLWOPcgrzugpqzksBb4u3KEt1+7g98EE2uXjCtRM46eDzRfm50C/2+FevBGf9mfTMu3OXNZzLWWqY2WaCMnXZqjHTgmPftzXCa40d4Zg+4iO2F33CHZx+HYwXBaujnRLXwjT9S99yFcw4mdICGPWVPTE3uKx5UXL/GdnR+OhaEuFh4EbHL7eTdmITVnQ5GFtHwbMvY4KWu45lVo7UTmspUEMiCo+cy5rvxT2qabEkgvJcbFvww0R1f5tNAP6KpU6sYUn0iGHoWlE6IrsL6DA8j4XMVTY9558fJDpBu14GJ8Owriq/581+WELBz/cphhFEiV3cRch3rpYO3B1JXBoqA==
Received: from BN1PR10CA0022.namprd10.prod.outlook.com (2603:10b6:408:e0::27)
 by BN8PR12MB3043.namprd12.prod.outlook.com (2603:10b6:408:65::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Tue, 13 Apr
 2021 08:41:24 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::60) by BN1PR10CA0022.outlook.office365.com
 (2603:10b6:408:e0::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Tue, 13 Apr 2021 08:41:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 08:41:23 +0000
Received: from [10.26.49.8] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 13 Apr
 2021 08:41:20 +0000
Subject: Re: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
From:   Jon Hunter <jonathanh@nvidia.com>
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
 <563db756-ebef-6c8b-ce7c-9dcadaecfea1@nvidia.com>
Message-ID: <e4864046-e52f-63b6-a490-74c3cd8045f4@nvidia.com>
Date:   Tue, 13 Apr 2021 09:41:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <563db756-ebef-6c8b-ce7c-9dcadaecfea1@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 192d8826-ae38-4530-b892-08d8fe57eb1d
X-MS-TrafficTypeDiagnostic: BN8PR12MB3043:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3043C79BBBFEAF24143925B1D94F9@BN8PR12MB3043.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oxew9u71Dgh4Ff8RKuSzyEQHNYh5lw/Xn0JYsm0koOXG9oQ1crjJYXcUiPrxEQUg3R16w9jM7gnFQ3WybLE5tY7NHDWb99zZ4T8ZCGhVSOP4zjf5Br0CQfKfKvTrezGyj81Uy3fvlF15XixPLaXjGvB48MjXBu0zya4c2cFkcavr8guXuisbTtMz97FI7+kjyQSMcMfKqfEr9LtT5bOO5l0Vu6nStXdueLp/sLgeE6AE1g0A8X+SxuK6IAGvytTTzqsQdlG7Pk8KUYBmZDRuDAOeEUI6tJkXv0MR4uzgNOLuB50jGFgKQtDpVvave55c1da1UGhexaHa90iQC2MPkmI5m3PhohQJjiI3X1nGZLUda/1rkceF7OcXDqvhL+NvNeYD2oH/e6N6r4zAuooNFqDKnpahmSg9URoe/VgDwFScOxkyOSQa67wzLOykRF9D6jggVHePBr9IcwlP3sExMTu830oZT5J+y2KiQa2EYRpp2cc68I/jlWHporXQCM3wz543BSBgHngnSEoyMi+CcTzOU3ljRtITO7IODQ5W0l+TXBWeufzKZQMRckuaJ+umzfi5x3utZOo0zOFmzUSSzGdZ+SqW9x0zbRKIIXNB0jMQwq50/IAT9mlPsRo1ErnFcKiOtUXKnWlNNufiwnmSpY9rDoBQSNVI9TjHAT+PaNxc2N6YlkSjPQtD+rBCuTuJ
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39860400002)(36840700001)(46966006)(186003)(36860700001)(53546011)(426003)(478600001)(110136005)(8676002)(2616005)(82310400003)(16526019)(356005)(7636003)(8936002)(83380400001)(336012)(70586007)(86362001)(316002)(70206006)(82740400003)(31696002)(36906005)(2906002)(54906003)(5660300002)(26005)(36756003)(47076005)(31686004)(16576012)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 08:41:23.1079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 192d8826-ae38-4530-b892-08d8fe57eb1d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3043
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 01/04/2021 17:28, Jon Hunter wrote:
> 
> On 31/03/2021 12:41, Joakim Zhang wrote:
> 
> ...
> 
>>> In answer to your question, resuming from suspend does work on this board
>>> without your change. We have been testing suspend/resume now on this board
>>> since Linux v5.8 and so we have the ability to bisect such regressions. So it is
>>> clear to me that this is the change that caused this, but I am not sure why.
>>
>> Yes, I know this issue is regression caused by my patch. I just want to analyze the potential reasons. Due to the code change only related to the page recycle and reallocate.
>> So I guess if this page operate need IOMMU works when IOMMU is enabled. Could you help check if IOMMU driver resume before STMMAC? Our common desire is to find the root cause, right?
> 
> 
> Yes of course that is the desire here indeed. I had assumed that the
> suspend/resume order was good because we have never seen any problems,
> but nonetheless it is always good to check. Using ftrace I enabled
> tracing of the appropriate suspend/resume functions and this is what
> I see ...
> 
> # tracer: function
> #
> # entries-in-buffer/entries-written: 4/4   #P:6
> #
> #                                _-----=> irqs-off
> #                               / _----=> need-resched
> #                              | / _---=> hardirq/softirq
> #                              || / _--=> preempt-depth
> #                              ||| /     delay
> #           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
> #              | |         |   ||||      |         |
>          rtcwake-748     [000] ...1   536.700777: stmmac_pltfr_suspend <-platform_pm_suspend
>          rtcwake-748     [000] ...1   536.735532: arm_smmu_pm_suspend <-platform_pm_suspend
>          rtcwake-748     [000] ...1   536.757290: arm_smmu_pm_resume <-platform_pm_resume
>          rtcwake-748     [003] ...1   536.856771: stmmac_pltfr_resume <-platform_pm_resume
> 
> 
> So I don't see any ordering issues that could be causing this. 


Another thing I have found is that for our platform, if the driver for
the ethernet PHY (in this case broadcom PHY) is enabled, then it fails
to resume but if I disable the PHY in the kernel configuration, then
resume works. I have found that if I move the reinit of the RX buffers
to before the startup of the phy, then it can resume OK with the PHY
enabled.

Does the following work for you? Does your platform use a specific
ethernet PHY driver?

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 208cae344ffa..071d15d86dbe 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5416,19 +5416,20 @@ int stmmac_resume(struct device *dev)
                        return ret;
        }
+       rtnl_lock();
+       mutex_lock(&priv->lock);
+       stmmac_reinit_rx_buffers(priv);
+       mutex_unlock(&priv->lock);
+
        if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
-               rtnl_lock();
                phylink_start(priv->phylink);
                /* We may have called phylink_speed_down before */
                phylink_speed_up(priv->phylink);
-               rtnl_unlock();
        }
-       rtnl_lock();
        mutex_lock(&priv->lock);
        stmmac_reset_queues_param(priv);
-       stmmac_reinit_rx_buffers(priv);
        stmmac_free_tx_skbufs(priv);
        stmmac_clear_descriptors(priv);


It is still not clear to us why the existing call to
stmmac_clear_descriptors() is not sufficient to fix your problem.

How often does the issue you see occur?

Thanks
Jon

-- 
nvpublic
