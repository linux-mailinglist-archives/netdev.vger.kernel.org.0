Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F8C348AFB
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhCYIBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:01:12 -0400
Received: from mail-bn7nam10on2069.outbound.protection.outlook.com ([40.107.92.69]:57922
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229669AbhCYIBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 04:01:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYK1bCOQbZN3N0S9gP+NevKu7N3HMBAERCDnNIGCvWJJc9ZxnKisiE0NibH5sx2ovrkKj7azHJZxQze7PkxLJzBThOC0LMyHIfHdskNcb2+vV9Amx+OfRc066PQJcEw05OU0wj/zqN1jd5KH/6dite80OKaYUL6bIpsTGsh23FqaXXqU8WUjcchnDRMSqfwYnkcct9DCiEc3E9nOuWWPzQAIOQOByhKmP/DazLFIJiizvUpK/LC+V5YuNf4Vj4Py9CcN4WcroqJW1/LEjeQKQTQLa8m8V3E/rfVXhgIXaA4e141thjKd4YVrYhSe1o6FcV0dHxGW+S23hFfORXtLvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+c8+HktjxTcP1ZRonkxpUpkjZM3VCzEbIBVevr69M/0=;
 b=ntu00z4SeP/eDcTJtu1o8G/PusSJ/4DO3clRpe6KLINDF2e7aL0/5xJ4Z+xngj2fPYdtCmQ9q9tTBEWtJRfzoj3LurHPfxpx+WRZDmR+bjyq7xuX1IAJOatdoPEyKfnMEEVUGPtXboLrwP8WjbJWZ89C1keqlT2P/+06fhBOFzeL0mQHpQZhImDyXfREWCDYAowbYlG0sC/9ZaI//ylQEUN6C9goYu1iJP0kzCwYbFtAI8c6RpYwefiHaVLb3faR9Iu8vIS1m1mejEmT1n6QyQzyQg/ve+ZoDrdH6X5IwHReYqE5dra+V5q/OFQtwDCXARr2EzlYhhlvbJKb8CmL7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+c8+HktjxTcP1ZRonkxpUpkjZM3VCzEbIBVevr69M/0=;
 b=I4FHg3N9iTVUGrlU0aFcsmSguQ9XVNH+VSlsG+6tKbBIMLatE2lrl24sKEbiS7Gd4n/7JjmxRWX3RNwbLg9/Ce78wQxEDcxYcqb8toQ7C9x643x20TmAyXxRw1zFXfAg4NM42rAAnP0oRLyjd5NGu9k4DRCH9k4XpUD3JTAvh8eXeFygcLYDMcAYh4evtq6MIVfwuu8nhknYLjNwfqjK3Zlp8pAuNnWhIiQZyuIe8iTO5q0wVf4gC/1vsj+Sz8mOZAR7Mh3JWAC5NAVwj45zzFp6aKiZ3Vii5E12/EVN8T/5dqPckk+bw14il6QrWxdrMmGc9ZFCWhDK2K2LPjFVXw==
Received: from MWHPR15CA0052.namprd15.prod.outlook.com (2603:10b6:301:4c::14)
 by MN2PR12MB3933.namprd12.prod.outlook.com (2603:10b6:208:162::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 08:01:00 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4c:cafe::2a) by MWHPR15CA0052.outlook.office365.com
 (2603:10b6:301:4c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend
 Transport; Thu, 25 Mar 2021 08:01:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Thu, 25 Mar 2021 08:01:00 +0000
Received: from [10.26.49.14] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Mar
 2021 08:00:59 +0000
Subject: Re: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com>
 <DB8PR04MB679546EC2493ABC35414CCF9E6639@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <0d0ddc16-dc74-e589-1e59-91121c1ad4e0@nvidia.com>
 <DB8PR04MB6795863753DAD71F1F64F81DE6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <8e92b562-fa8f-0a2b-d8da-525ee52fc2d4@nvidia.com>
Date:   Thu, 25 Mar 2021 08:00:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795863753DAD71F1F64F81DE6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbe294b6-d1bf-4ee1-b586-08d8ef64214b
X-MS-TrafficTypeDiagnostic: MN2PR12MB3933:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3933161D6F6464F5C1B90239D9629@MN2PR12MB3933.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pBfxkR8zR6tKex88d5Tontn7ovsJTSKAHlDdnou06mVuWuF43Xo36tUWvbMnRFRnKgFD6e48cyJW/wYy87srRz9Hw+uLmRmpkhph1PS2JTVXNVMwkhHs5t9CCXZqwRbKrsVfc58xykq3EAfXMCXR2MJihPxN4123lO3hBOOal1eL6TMUdIaHKG8XDxtFSwD9Mmw3f6h40atiLeZqGkMJeUs/SS7r8das8mOlAwnOGQeO0bhIiKghq+vpbTUfIfNb9RXaN4F8Rt6cGk5uAIQZc1tjquvCTzlg6VuJViFo+o5PvSDlr5j8fjijyzWeTc8n+V7YsLX5j0oESzgteeE42lr71EFtVn4iXd3++WGEShHOFWDi4JFVMeIjZD/FgLyY5Eh/IjO8HtBbtFAapzfiY7bJombaKG0OTN0ZDURZ+n0k6x1WZY3wvWCZab0qU6pS7r8hPStlFB3yDLvzUDVjrQCriwR8un3hiCDUxkZExpOsK3JvRzgavQyaXEhDPR1OHM0aU8nVI8WLXsg2JFPchGC7+skiKBUkImHcZN7/G81pW36vxKqQZmbPRtPmwFex35DIgh4OKcbUSBgCWKLyFVopvNMVFlaMXyioFcHW9k3fVQ8FlUhYGf0GC/7Y6bV7+G1HVbNrscAkgXG6ED8BFoi4WCwd+WK25sTB0rTdg9JQmq6IAIWkJKJSs+xMdHXK
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(36840700001)(46966006)(70586007)(316002)(8936002)(70206006)(31686004)(82310400003)(53546011)(5660300002)(336012)(31696002)(8676002)(186003)(4326008)(6916009)(16576012)(6666004)(36756003)(26005)(83380400001)(86362001)(36906005)(478600001)(2616005)(2906002)(54906003)(426003)(7636003)(356005)(47076005)(16526019)(36860700001)(82740400003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 08:01:00.6263
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbe294b6-d1bf-4ee1-b586-08d8ef64214b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3933
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25/03/2021 07:53, Joakim Zhang wrote:
> 
>> -----Original Message-----
>> From: Jon Hunter <jonathanh@nvidia.com>
>> Sent: 2021年3月24日 20:39
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>
>> Cc: netdev@vger.kernel.org; Linux Kernel Mailing List
>> <linux-kernel@vger.kernel.org>; linux-tegra <linux-tegra@vger.kernel.org>;
>> Jakub Kicinski <kuba@kernel.org>
>> Subject: Re: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
>> resume back
>>
>>
>>
>> On 24/03/2021 12:20, Joakim Zhang wrote:
>>
>> ...
>>
>>> Sorry for this breakage at your side.
>>>
>>> You mean one of your boards? Does other boards with STMMAC can work
>> fine?
>>
>> We have two devices with the STMMAC and one works OK and the other fails.
>> They are different generation of device and so there could be some
>> architectural differences which is causing this to only be seen on one device.
> It's really strange, but I also don't know what architectural differences could affect this. Sorry.


Maybe caching somewhere? In other words, could there be any cache
flushing that we are missing here?

>>> We do daily test with NFS to mount rootfs, on issue found. And I add this
>> patch at the resume patch, and on error check, this should not break suspend.
>>> I even did the overnight stress test, there is no issue found.
>>>
>>> Could you please do more test to see where the issue happen?
>>
>> The issue occurs 100% of the time on the failing board and always on the first
>> resume from suspend. Is there any more debug I can enable to track down
>> what the problem is?
>>
> 
> As commit messages described, the patch aims to re-init rx buffers address, since the address is not fixed, so I only can 
> recycle and then re-allocate all of them. The page pool is allocated once when open the net device.
> 
> Could you please debug if it fails at some functions, such as page_pool_dev_alloc_pages() ?


Yes that was the first thing I tried, but no obvious failures from
allocating the pools.

Are you certain that the problem you are seeing, that is being fixed by
this change, is generic to all devices? The commit message states that
'descriptor write back by DMA could exhibit unusual behavior', is this a
known issue in the STMMAC controller? If so does this impact all
versions and what is the actual problem?

Jon

-- 
nvpublic
