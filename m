Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646CA3450C3
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhCVU3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:29:43 -0400
Received: from mail-mw2nam12on2070.outbound.protection.outlook.com ([40.107.244.70]:47104
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229871AbhCVU3R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:29:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VhU7sPhJMhR1QmWwVp1vEuNNOMr09phi/1q3pI5j7CdCyuBLJWyCtQVYJBb2dUQyfKyggESk3HqK82C880XSQKQpIbJwn17iOuBHfG+LafTylKUIbB8W8lC+da8N+zCEKd5yAtKXgWf0JGzx0G6p9mW8ZkiyuDo50AsAVpOPMf9/MYW+GKAxhb4qE0wyNi40yiL3ucZCQgC3qmQB2ZWQauGoYP8i9WMzoH+8EGscW8qkJKIelqg4XxNgrFCJ75mwJXsAtIh/XOE9x23stWo7tAUZjVOAttHi4ffzR54gAbHMARhpdqJ4BbUrSp12MaQmSi3mwFNOUG1mrB2DdNY2hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKdsPr/uAe1PaWQv9bhKOh8JMcV9Iiel142QqUnrm9k=;
 b=bAYx/oK3tvWJ2bHTIxbkzuKnYVFJRtVGXZFul/beD1WdnQe55nBmy21OLKmYBPnyEl5Es6arfMRLohvJvIta2UWwl/hhKZuz+GZ7mwAx1nyXvL0Sk9sP84XZRIhU2VxXDukeC45yXXvX6TJRrZr7Y8xXy3MM1a/yjLaDPiJkSfz6u7JUG8uUnBZPY+ys6rGLC5rCFxE3TdhNDtbnDveZbLNQ5YmMgbuyhuRmMWUTiOQcvy4H9hqO6sgkfm7uXL4aKVSWgteLoSy2L43Fm40FAHe9t4tQESFd8n6SwXD2gbX1HvrRsQWjGe9X76qY37ZNf/rQ+g9azIFoDMWTUbae9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKdsPr/uAe1PaWQv9bhKOh8JMcV9Iiel142QqUnrm9k=;
 b=M5OtQDRU5eFLtZLpurIQx/EZYBrCx0XnIzbRkcxQutympYchApzRfUNSFeSMlTXenJzp+VXgKYU0Wn91TXFGlC2LM5xuZbrQePDrbCiNDVa0B1RzNQmXVlUlnv/GiIXITpw6OqXfPaitj/XSwIhGrLSjqtZGTRdZET+nAflRkjOP8mJkxCtqTkO5754Eb74GxZzrHQJCWH02V9FoBwWokZNHPUICBw5VsGQhaLfV0md2q42Q0D0mXedS6VWjQskDfMtw+OUqypeaRk700XWOLZIDU7bLQTVwPVQcEhoQcd3ar9KL/J7ydzhN+j2AHTM3C4DOopeqTdlcyH6tMnbylw==
Received: from BN9PR03CA0692.namprd03.prod.outlook.com (2603:10b6:408:ef::7)
 by CY4PR12MB1798.namprd12.prod.outlook.com (2603:10b6:903:11a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 20:29:12 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ef:cafe::db) by BN9PR03CA0692.outlook.office365.com
 (2603:10b6:408:ef::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 20:29:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 20:29:11 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 20:29:11 +0000
Received: from [172.17.173.69] (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 20:29:09 +0000
Subject: Re: GTE - The hardware timestamping engine
To:     Richard Cochran <richardcochran@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Kent Gibson <warthog618@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        "Bartosz Golaszewski" <bgolaszewski@baylibre.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Networking <netdev@vger.kernel.org>
References: <4c46726d-fa35-1a95-4295-bca37c8b6fe3@nvidia.com>
 <CACRpkdbmqww6UQ8CFYo=+bCtVYBJwjMxVixc4vS6D3B+dUHScw@mail.gmail.com>
 <CAK8P3a30CdRKGe++MyBVDLW=p9E1oS+C7d7W4jLE01TAA4k+GA@mail.gmail.com>
 <20210320153855.GA29456@hoboy.vegasvil.org>
From:   Dipen Patel <dipenp@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <a58a0ec2-9da8-92bc-c08e-38b1bed6f757@nvidia.com>
Date:   Mon, 22 Mar 2021 13:33:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210320153855.GA29456@hoboy.vegasvil.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1790cc9e-c4ad-40de-767f-08d8ed712766
X-MS-TrafficTypeDiagnostic: CY4PR12MB1798:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1798A398C788F83AFC9C05F4AE659@CY4PR12MB1798.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X9seO8jA3ttM+E7ILkhETTkBniIJhtVKkGDTaAOpj8/hBCWrhEIv7wXMrsJxaRSfWV0rrecExjoBfEfoHdcCIxUljZZX0yCt5I70EHhp0+TOfSoRyaRY5tLP8owpF4qb+lkRMs/7+X3tATKUl/kxAqUvIEvJsZofbHb38wYxuJSZI9wWPQyV7nxrX+0Zne/nOBpYAkBEVllPvJ9o6iwMBMPH/xZ70+Cd2fnsMrUNh3EFEtjuaPuW8vVzTzTiXISatWiN/F0yp2MTXoTqtVsXvw+68kNl5ZQPULuaW93RJ2Y+Pfdjaagua2Er1ee3iTrDm6ASvqizqaMzdbhcFPYwaNf7uBVGHwAI7XQm9TJlX/NUPFJ/D4YHA1oxR9xjDY1US3p949KIY9uAOfjH57effbl3Sxv1Bax8JCXrvvYTIzEOwcgMRa+g5dCQWdbuphAkWn+31ZI297wKQbc1GR9FMR9aV7JLXn/KH+UPZcISu0ob139ytliVBbGcl/GLxE5JaZgNSl6W6DQ8QGNYZisbxYw0I6NBZGKuPoiykffOBatds/7QQQWoDrtcAoumSoz2/CM45gwXMMAOkZXs8ygbKZeLPNyxQdTg7J5XUzIT1Mf1GuGOqWmOu7vPITPYD9hNrwnfORhXiB+PjIZthtBzGeMrh+lXhzHDdSmDZFLyTLq2mJKZvZ8IEMEMzMMLEaHm
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(36840700001)(46966006)(7636003)(8676002)(26005)(356005)(186003)(47076005)(36756003)(336012)(53546011)(426003)(31686004)(7416002)(82740400003)(5660300002)(16576012)(110136005)(82310400003)(54906003)(31696002)(70206006)(70586007)(316002)(36860700001)(2616005)(4326008)(8936002)(83380400001)(6666004)(36906005)(2906002)(478600001)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 20:29:11.9419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1790cc9e-c4ad-40de-767f-08d8ed712766
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1798
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

Thanks for your input and time. Please see below follow up.

On 3/20/21 8:38 AM, Richard Cochran wrote:
> On Sat, Mar 20, 2021 at 01:44:20PM +0100, Arnd Bergmann wrote:
>> Adding Richard Cochran as well, for drivers/ptp/, he may be able to
>> identify whether this should be integrated into that framework in some
>> form.
> 
> I'm not familiar with the GTE, but it sounds like it is a (free
> running?) clock with time stamping inputs.  If so, then it could
> expose a PHC.  That gets you functionality:
> 
> - clock_gettime() and friends
> - comparison ioctl between GTE clock and CLOCK_REALTIME
> - time stamping channels with programmable input selection
> 
GTE gets or rather records the timestamps from the TSC
(timestamp system coutner) so its not attached to GTE as any
one can access TSC, so not sure if we really need to implement PHC
and/or clock_* and friends for the GTE. I believe burden to find correlation
between various clock domains should be on the clients, consider below
example.

Networking client has access to both PTP and GTE, it would be its job
to find the correlations if that is at all needed based on whatever
use case that client serves. GTE in above may come in picture if said client
has some GPIO configured and wants timestamp on it.

Sorry if I misunderstood anything, you can elaborate more as I am also
interested in how GTE can fit in PTP framework and which usecase it can
help doing so.

> The mentioned applications (robotics and autonomous vehicle, so near
> and dear to my heart) surely already use the PHC API for dealing with
> network and system time sources, and so exposing the GTE as a PHC
> means that user space programs will have a consistent API.
> 
> [ The only drawback I can see is the naming of the C language
>   identifiers in include/uapi/linux/ptp_clock.h.  If that bothers
>   people, then these can be changed to something more generic while
>   keeping compatibility aliases. ]
> 
> Thanks,
> Richard
> 

Thanks,
Best Regards,
Dipen Patel
