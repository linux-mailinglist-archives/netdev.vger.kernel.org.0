Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC6C46498B
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347971AbhLAIZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:25:57 -0500
Received: from mail-dm6nam11on2060.outbound.protection.outlook.com ([40.107.223.60]:40289
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347936AbhLAIZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 03:25:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFD7AoXEeSSRHp/i9XjWBKiXIUDMIPHlVYsjImVWGfUFR4nbnjuZcAouYdKfKjpeGNdmP+Y33uXrvXvWDkae7NWCd4eRkoOI7yCPAfzDzsNjNOSKttFbMKkct9yIsNYnwhvrmUWwx/iSnIop9lGOcME7WBGDI5n5rabWCiehN6EON86ZQOaia0rspiMMrFNvyH35/cuGiiCB3kMEjogpC3UaFIASxQD3EaMJJ/9uNBdTtFT6QQGlVQaO2rnr8Fg7pJqNSsfHjvuxFCZ5I5LMjPwbPgUf5SckJEWT3tXZYayiKXEU8nN4uWWZ373utNc3gZnfrUEJRCqPBt54Fa4q6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rAlgnDEqj+8V9RpZ56YXoecClduuv6pWWv9GuWDQNqI=;
 b=dp8rhy/1fTXUkrecYnhVGu+yfR2cVaG243VSYS++Qhq4GP+EHsFoKXJdvYGkqZqXSgEaC7p+WYm8pKLq16Bec0FA1z2lRWFkD5I+/snaMRCsbiP0QSYSS2MoKFXuM3NDCujlm/ICbMl5FL5wYNz90/8cdMIKH+BdXSsV9368/d/oG2BrMcsuEhe3PF0rLA60VfEGGRebi/buIJegHad+cxizaPllimHEvSXujd+kaBjlvNa64Du/KVBdk11A3WnhLILBqZK3DWIzavTHXczk0jDld5kLXcKeX9N+KPabsx11qG8b1yy9c+p/S859UHXLn0BYA0Uo3zXxmqy9B4NL3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAlgnDEqj+8V9RpZ56YXoecClduuv6pWWv9GuWDQNqI=;
 b=pPaqZ6t7Lj///9TYIgoh89LKlTsnuLAnrMgKnhZ14SPU+Buw0ODY34JTONf6LOPJ6TbSe+oKGnMo4Fz2d7SYnLioCXG1OOYusDU19j721BFhrG/am6yuq5u5cgSjnwuNoQQMHA0Zg12sq1dWhjG4NrA41bAun9vErRm6mEBNLC1MdMevr7lOcSJQ93lfQ9w5HrUfxRwu3rB9LKfjpghA0x0uBXBIFo/ElLQJ+LTAIVjc8MEm6k7WS+/JWeibXAHRHs0+GyootgiM8dRpmJp4slYb+81bCRf/ucv3EfPBeVR2un766DHl+qRO76+f37dL/EhmOLaf86Uv7iXN+uTzmw==
Received: from DM6PR04CA0006.namprd04.prod.outlook.com (2603:10b6:5:334::11)
 by MN2PR12MB4272.namprd12.prod.outlook.com (2603:10b6:208:1de::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 1 Dec
 2021 08:22:24 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::f2) by DM6PR04CA0006.outlook.office365.com
 (2603:10b6:5:334::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Wed, 1 Dec 2021 08:22:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 1 Dec 2021 08:22:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 1 Dec
 2021 08:22:23 +0000
Received: from [172.27.13.11] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Wed, 1 Dec 2021
 00:22:20 -0800
Message-ID: <879d6d7c-f789-69bc-9f2d-bf77d558586a@nvidia.com>
Date:   Wed, 1 Dec 2021 10:22:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net-next 0/4] net/mlx5: Memory optimizations
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20211130150705.19863-1-shayd@nvidia.com>
 <20211130113910.25a9e3ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shay Drory <shayd@nvidia.com>
In-Reply-To: <20211130113910.25a9e3ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd4800c8-65e7-44fe-5f74-08d9b4a3b432
X-MS-TrafficTypeDiagnostic: MN2PR12MB4272:
X-Microsoft-Antispam-PRVS: <MN2PR12MB427218066B47D0E590200853CF689@MN2PR12MB4272.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 95PNB+aLeL9XntZYURxBFrqGwkoqAXEfrqsmeE+KaivsJWHGO7ZiFs2wyNobY8ENBl4+tz+qKwyeWJXdwfvgA34tYd6s2x/uol5UiXFmXnPCRoFwsgJucHvjIYsbqgjCioM15y1B5SkTjsUTVWGqJoMK3OoFYP9KUL7ErxxLMPNjB/R65XZTuKdxCt0mWnkSmHX4QQuHoO9sjkdKBfcc7UWkQ6Mh/DSYY3wUsNZyfSefeJQNDMQ2c4GpR0b7g2LySPZot3yRsQ+VwPEZ0ueH0st6lac3nu292S72rFA23eIJmbYVB34eSLrhcZzB0SxOY2jDuTG1sv7VJzV951aXTH276Ix9YBS0ytsvic96iVatJ0ONjzh5U4SQrlrd1DvsiF4d+h6i2lh9rM9MjyB4csZW2YZ28O7Vv6exZk2Q535FvtlqW5Z/meFw/8zOAe7HmMPfCjXenFUIR1xodgDqwi32uhfWiRUNuD9z1wwINi+41XJm9s+B6DslnO9y4NUotkDwql3OuEBZwKeZEX/9yWikDLco5uHpMOLzEgMMVxopjaXHm+fwz7Euhs3SZJlob0z1bIBAHeW2r2eVBmT00sZ+NcQqngHigkHDdqA7GsB5c/PnMvhS6waknVs9kNaehT0iwtPCSP2/POKfZN40ufHxvaf3hqKELSr/dBQKX02OPANekyw/Dkbg+zij4DUAi3cdtDLXd62EJeKX9stlAkkwtn2giohjKf3VJ7SrOoyXmVwtpGEyWg9UAJY1fOn8Tlnuu/TR3YMx5IBy98gMcKe/mtHKMlDd82APmGp1bIQ=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(356005)(4744005)(508600001)(31696002)(6666004)(2906002)(70206006)(8936002)(53546011)(4326008)(86362001)(186003)(70586007)(7636003)(36860700001)(16526019)(54906003)(336012)(82310400004)(16576012)(8676002)(316002)(47076005)(426003)(2616005)(26005)(40460700001)(31686004)(36756003)(5660300002)(6916009)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 08:22:24.4411
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd4800c8-65e7-44fe-5f74-08d9b4a3b432
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4272
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/30/2021 21:39, Jakub Kicinski wrote:
> On Tue, 30 Nov 2021 17:07:02 +0200 Shay Drory wrote:
>>   - Patch-1 Provides I/O EQ size resource which enables to save
>>     up to 128KB.
>>   - Patch-2 Provides event EQ size resource which enables to save up to
>>     512KB.
> Why is something allocated in host memory a device resource? 🤔

EQ resides in the host memory. It is RO for host driver, RW by device.
When interrupt is generated EQ entry is placed by device and read by driver.
It indicates about what event occurred such as CQE, async and more.

> Did you analyze if others may need this?

So far no feedback by other vendors.
The resources are implemented in generic way, if other vendors would
like to implement them.

