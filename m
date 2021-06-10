Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2A73A2C13
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 14:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhFJM4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 08:56:16 -0400
Received: from mail-dm6nam10on2062.outbound.protection.outlook.com ([40.107.93.62]:62752
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230248AbhFJM4P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 08:56:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YlDDd3IdmGjy3xckZaCfiQkxBM9A5AsuRGjBar3AdK8BgwZlHVo30aZ1/iyK0/W3ldm2+D+YOF0GwxJ6tiPT9gcW5JGBU3kMeWBBDgn9M0lmQLXJRMy1yIaE7z14fr7wRxi4rp9B1KZoun0qf9/OcyqLAaN3rgLw4QchhfgEmMi9gV+xIluFNgyl0K1eMz08xe1LL4sZobgOKl7k0l/rc6m7wFK9pIRK25aYBSAXkroBW++WFx+6cMivo+5rQIydeoZQ7wsF1aTAKp2xSHKo/jx2wnxWHlrjjchRK1VAW9o5Zh9rWTImSYRo4dwc1srCOGfNL98XDEhkfxUxqknH/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+oWDPeo7Q+1evX/7/SWM7k/Pcrr/I+qdWXpMNUF+Us=;
 b=JXpqoTeX5HLRdFSjb47JTiemGB9b6ALIos64ykcrIzldAo8DHgWhk3+0v8Q9N6DpVSa3FJncuZKQjKrN7cJX4fLpG1k9yU7sOPUCjUqXiERNBSynDZUiVzPnlkApR/P4bvGq5THG+R93jCWmpw7qWgBdD/1aohTFlmYLIDdxDVpdm6RqP9iyJ6GMBkVtbSIknv9VgxDE5/kmZKfVtdgNcwLIiUd5yR9CiyU7a4jmbnqkEqyc/QkSpS6PICRTk1Ymviuy+tPtvQNjfIPfj5lBA6tGkRel5FY4zYDvcmAaGs6bAjaHLdEDlxP+csHA8LVJBcDAVqQ5k4EaehxTfwlDzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+oWDPeo7Q+1evX/7/SWM7k/Pcrr/I+qdWXpMNUF+Us=;
 b=jaHs/YJ+M7rgwKmA4LAA9UQ/Z38b+x5R7pKwtVbEcZH4XMZBYyve2D25Cjh+a6ESvPQmGM66457LOMIgL4e8dMAEopieUndB1Lu6N9dCgCXpQ2Tm9LFW9Y2HbLUwv3706+5nseKXLKVGWnMvlret+7QWU7SPiAPgC409VyuOTNC/nT4Oeqabmi46DBpLgYKTUPk2aEuTtffUfUgu3NnuMb0xVyh6B9OIcz2imGo0JU3hJ0nVd9Kvx58GZE5kmq3ejyiz8StN0VcBuUNikSy0qhqVWrnvdmY/uyuCabaL3uMNy3USx2dmp04Q5kOr8gMSKoQ7MLAq/QpOsjS3+RRj0A==
Received: from CO2PR04CA0202.namprd04.prod.outlook.com (2603:10b6:104:5::32)
 by DM6PR12MB3819.namprd12.prod.outlook.com (2603:10b6:5:1c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 10 Jun
 2021 12:54:18 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:5:cafe::61) by CO2PR04CA0202.outlook.office365.com
 (2603:10b6:104:5::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend
 Transport; Thu, 10 Jun 2021 12:54:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 12:54:17 +0000
Received: from [10.26.49.10] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Jun
 2021 12:54:14 +0000
Subject: Re: [PATCH net-next v2 4/8] net: usb: asix: ax88772: add phylib
 support
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
CC:     <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20210607082727.26045-1-o.rempel@pengutronix.de>
 <20210607082727.26045-5-o.rempel@pengutronix.de>
 <CGME20210609095923eucas1p2e692c9a482151742d543316c91f29802@eucas1p2.samsung.com>
 <84ff1dab-ab0a-f27c-a948-e1ebdf778485@samsung.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <0ebb1698-cd52-d8ad-b5cc-045d29ea964f@nvidia.com>
Date:   Thu, 10 Jun 2021 13:54:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <84ff1dab-ab0a-f27c-a948-e1ebdf778485@samsung.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5d304fd-bbd0-4219-e8ac-08d92c0edbd5
X-MS-TrafficTypeDiagnostic: DM6PR12MB3819:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3819D78605E7C72412806E10D9359@DM6PR12MB3819.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:255;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qp+VULzv+p5ROxUxGntO/nSiGeGiDV9Ob0z7XMMvvNHYTku1rHOt/a/R7V4De2L1/ANVG/eYQN4D8UEJTX5VJSftXnjaLbvt72F/FflxX0fMY8TcqgRVObWMaVaAHbTdQa0uIibCynZqZn4UQeuBY8ZYvb2aSqIJ53v7rqPSphvyROQL+Gj/LDcH4GT+tcKY9SY2ZaAG/5wdsIMtZSEvzpYR77JzbuL3Yxpu4hPuYZdixAo4HmSMl4xjlC1X6P3aLIP7RnMxLGJsi+owgqo+ViMrmRD4GI0mUn1NWaHiU7udP6VyYKFihTNqaAl+1w91xLxT/S7JvZwgc8/XXI05smpWNWVIXUnmmxip1LWtJrpps2XrLUmed5yqUHbb91g/ihGd4knVn4XBBMuSvCYr8HXqxEBCCkXGOJMa4Ya+2aKSiyURpV5dB3nDsuz6AH5egywzLMqXDciiRbbOv4FxeHCBTFyNQMIor/E5bhf+60bPD1ltXEQxi0MFCNyaSooXyusHFbsC4Ux/jyDhgsOKgTiuedQEkvp4rcxGENLyC0+rcYQo/Xdq288SxDfn4Dx120dgVxlifyWBFbP177kNHBvR/d8dYu8j3v4cjvcSiAk3zjlLhD1awLQ1aMVwAl7ZALlpW1C80iMdh/8VEuf+T4UEnGTqGNBnM2na6gAT4AjUxfFYG6ftUvl51roYWZdS
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(36840700001)(46966006)(31696002)(70206006)(110136005)(8676002)(70586007)(53546011)(336012)(5660300002)(36860700001)(8936002)(36756003)(7416002)(82740400003)(31686004)(186003)(2906002)(54906003)(478600001)(47076005)(7636003)(82310400003)(356005)(86362001)(316002)(426003)(16576012)(4326008)(36906005)(26005)(83380400001)(16526019)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 12:54:17.8029
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d304fd-bbd0-4219-e8ac-08d92c0edbd5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3819
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/06/2021 10:59, Marek Szyprowski wrote:
> Hi Oleksij,
> 
> On 07.06.2021 10:27, Oleksij Rempel wrote:
>> To be able to use ax88772 with external PHYs and use advantage of
>> existing PHY drivers, we need to port at least ax88772 part of asix
>> driver to the phylib framework.
>>
>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> This patch landed recently in linux-next as commit e532a096be0e ("net: 
> usb: asix: ax88772: add phylib support"). I found that it causes some 
> warnings on boards with those devices, see the following log:
> 
> root@target:~# time rtcwake -s10 -mmem
> rtcwake: wakeup from "mem" using /dev/rtc0 at Wed Jun  9 08:16:41 2021
> [  231.226579] PM: suspend entry (deep)
> [  231.231697] Filesystems sync: 0.002 seconds
> [  231.261761] Freezing user space processes ... (elapsed 0.002 seconds) 
> done.
> [  231.270526] OOM killer disabled.
> [  231.273557] Freezing remaining freezable tasks ... (elapsed 0.002 
> seconds) done.
> [  231.282229] printk: Suspending console(s) (use no_console_suspend to 
> debug)
> ...
> [  231.710852] Disabling non-boot CPUs ...
> ...
> [  231.901794] Enabling non-boot CPUs ...
> ...
> [  232.225640] usb usb3: root hub lost power or was reset
> [  232.225746] usb usb1: root hub lost power or was reset
> [  232.225864] usb usb5: root hub lost power or was reset
> [  232.226206] usb usb6: root hub lost power or was reset
> [  232.226207] usb usb4: root hub lost power or was reset
> [  232.297749] usb usb2: root hub lost power or was reset
> [  232.343227] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
> [  232.343293] asix 3-1:1.0 eth0: Failed to enable software MII access
> [  232.344486] asix 3-1:1.0 eth0: Failed to read reg index 0x0000: -22
> [  232.344512] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
> [  232.344529] PM: dpm_run_callback(): mdio_bus_phy_resume+0x0/0x78 
> returns -22
> [  232.344554] Asix Electronics AX88772C usb-003:002:10: PM: failed to 
> resume: error -22
> [  232.563712] usb 1-1: reset high-speed USB device number 2 using 
> exynos-ehci
> [  232.757653] usb 3-1: reset high-speed USB device number 2 using xhci-hcd
> [  233.730994] OOM killer enabled.
> [  233.734122] Restarting tasks ... done.
> [  233.754992] PM: suspend exit


I am seeing a similar problem on a couple of our Tegra boards that
use AX88772A device. When resuming from suspend I see ...

[   54.733266] PM: suspend entry (deep)

[   54.737179] Filesystems sync: 0.000 seconds

[   54.741904] Freezing user space processes ... (elapsed 0.001 seconds) done.

[   54.750895] OOM killer disabled.

[   54.754452] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.

[   54.763505] printk: Suspending console(s) (use no_console_suspend to debug)

[   54.898334] Disabling non-boot CPUs ...

[   54.899546] IRQ 26: no longer affine to CPU1

[   54.924373] Entering suspend state LP1

[   54.924493] Enabling non-boot CPUs ...

[   54.933164] CPU1 is up

[   55.005166] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -113

[   55.005226] asix 3-1:1.0 eth0: Failed to enable software MII access

[   55.006579] asix 3-1:1.0 eth0: Failed to read reg index 0x0000: -113

[   55.006722] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -113

[   55.006762] asix 3-1:1.0 eth0: Failed to enable software MII access


Interestingly once commit d275afb66371 ("net: usb: asix: add error
handling for asix_mdio_* functions") is applied, then resume from
suspend completely fails because the error is propagated. Bisect
is pointing to that patch, however, it is this patch that is
causing the problem.

Cheers
Jon

-- 
nvpublic
