Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6F8332822
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 15:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhCIOHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 09:07:15 -0500
Received: from mail-bn7nam10on2086.outbound.protection.outlook.com ([40.107.92.86]:45345
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230052AbhCIOG7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 09:06:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLnqJLrq8GBKbGaiS+FGcttVWbELvOYO8jIeCEUq7yFHpXrQmKXHvvVpqoWZ0Ak6cNSHasovuNYuzmkUcZqnrXnh+5ZkkaO1yJhaGTEYj5Y22KmA67F192Wa7PNO/3nVVrR3Kcjrb9fxavN3BnOJZ0nWECgUQt08LcdiMcnH3+a2qwJP3OFo9EeEl6simUhc09NZl/39YxODrGXAT9v7aqLQmC47FPz7x3JueyHq10cMdBkvXIBp0XChxCmjg7+ougIA4F1IB4WdHn/bM3WN2LK0zsoo9wsdVt1rnFEf8Zp22Gdp6LpSJ9ogWuFyPrGOvWPayuTDVx+GD5VwGWil/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9y7m80vMh40yCPBgJ5iOleq9HK02uCR1bBcwvDOAQQ=;
 b=VsZOsCMB2A15intz9Wbdf0s9wSF4FPu4vDWNAAlu1ZP50dpMERE6aZqJdJnMD3xeDQmUz/HND0mO4JpxvPAmvxW449N90o55zWUjQbAtCAOx5oEu9oVPk6Y/BN+7U54xmcI3jIdJrJFZrwCfl+tWTVTmKGH656ZndHnklQoQIn3amLCkG5lL5hHjuYTaUhUcrk2F9vWsJ8hqgRvdiCxpmKqPMqOAyoCy+/BXc0lqSxAjBkPuVhEMipyCe8I/QU3M+jSK/HsorH3kuSAJHjGCaYS17Wb5GHT/reIf7ePqYZTO5NpSmKNAXCqC1R8xi/ljudGbDyPv9amU2U4xMm1I2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9y7m80vMh40yCPBgJ5iOleq9HK02uCR1bBcwvDOAQQ=;
 b=itYGXW+cnIOV9+EjTuY+AQFqfwpaNRxSSorVcykQYBdIl4CkmXhDinIk9/XU98Mj23rFYGidrA1/3A2rMleyG93zphSwpZ3s+iyqDaxteU+FK54MYevYZN7HJuxtpzQYKQclZtDTiZtGAvziW/CW6/+D+e++TVpByxTLkZEhtDVx+Yt3gYdt/bELqhGBnrtTQlTbWu7YdQOThJ9LaAf3XrDL1CSZiW7mXGXOI9i5dB4tbqMDkPlXRHpkVejVOdPBRamrBCTXsOpH/pxQvDcu7jVCkvuITOUGXCTUe1CMGk1RnPHUDY2qs2wZ1rGefsaHO5ib+jl+qr2ZExDV+mZ6ag==
Received: from MW4PR04CA0140.namprd04.prod.outlook.com (2603:10b6:303:84::25)
 by MWHPR1201MB0269.namprd12.prod.outlook.com (2603:10b6:301:5b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27; Tue, 9 Mar
 2021 14:06:55 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::67) by MW4PR04CA0140.outlook.office365.com
 (2603:10b6:303:84::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.18 via Frontend
 Transport; Tue, 9 Mar 2021 14:06:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 14:06:55 +0000
Received: from [172.27.12.237] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Mar
 2021 14:06:51 +0000
Subject: Re: [RFC] devlink: health: add remediation type
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jiri@resnulli.us>, <saeedm@nvidia.com>,
        <andrew.gospodarek@broadcom.com>, <jacob.e.keller@intel.com>,
        <guglielmo.morandin@broadcom.com>, <eugenem@fb.com>,
        <eranbe@mellanox.com>
References: <20210306024220.251721-1-kuba@kernel.org>
 <3d7e75bb-311d-ccd3-6852-cae5c32c9a8e@nvidia.com>
 <20210308091600.5f686fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210308095950.3cede742@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eran Ben Elisha <eranbe@nvidia.com>
Message-ID: <bca3440c-9279-58a6-377f-6a4fdcccdf1f@nvidia.com>
Date:   Tue, 9 Mar 2021 16:06:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210308095950.3cede742@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b252912-40fb-400f-cad9-08d8e30498a6
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0269:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB02690AA8BFDB68D2A6980141B7929@MWHPR1201MB0269.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cEDE6ANoJwTeh86nw6KSvMU07dGZRBjE8SKiG/W35AiH3N/TU5N3BO8WoIBsUlmofurRx0CXFi2Vp/UPjb24iojrVuaciTkfdbCmM6vpwZ/4RLxynKuEsccK/nIVyk3UbCI55tY22337CcozNrIV+BSEsMmDnRiW4YMgtte6jVUSPCfXsllZFoG0gdVlxFKc+eb36tI+4iv/pSFo935a0eqAvSGVyI9p0CzwWNiiMrY3Xwhu+f7tuqrGOKHNK2rv00JW0yXoFE6zsKI49l96a5tlcb5L54M9eET3YRUwEHAK4MPsdmMQHeb/CqDqpZJGAsLz+o0vH8P34qqQxSuNVHhlXs4wQdyaKvMRIxlvjZscw5cVZZufFqZpv1sGpdQ1DPIokrsZ8cpXM2raoUMtQLxO7TGJHJyXFJjHlxx1eZ6mcwTnippzeckjITaqoG8cu4zx2AuY5GMo98GTOMORNktil7CMzZDs7svU/g+J441OnnbOid4zOCNXnKKHkM71Jd9HZiDzio5786TJ0ObnSc00I/zZo6TyIycb6pZ/ukCNcJ1jmzIYMngjAtig2M6ynAGA0YJOtyWCKgkWUNVIIsZFIAKasoa/Ycc9WpNksF8mPXbCviwxMN6eWjE9Pi8ucQTWRj2LgLqyRHlSL6cGihhXT5n0p2XIo6dmjHQROORkmBuLbvbnT/n24afllE0TMV0U9zBUYA3ZSzywh/Q/n35BezJMCZBNoLfSXWs6qYM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(46966006)(36840700001)(47076005)(86362001)(31696002)(6916009)(2616005)(8676002)(107886003)(356005)(36860700001)(478600001)(8936002)(4326008)(26005)(7636003)(5660300002)(83380400001)(54906003)(316002)(16576012)(31686004)(53546011)(36906005)(2906002)(36756003)(70206006)(70586007)(34020700004)(82310400003)(186003)(16526019)(82740400003)(426003)(336012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 14:06:55.2337
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b252912-40fb-400f-cad9-08d8e30498a6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/8/2021 7:59 PM, Jakub Kicinski wrote:
> On Mon, 8 Mar 2021 09:16:00 -0800 Jakub Kicinski wrote:
>>>> +	DLH_REMEDY_BAD_PART,
>>> BAD_PART probably indicates that the reporter (or any command line
>>> execution) cannot recover the issue.
>>> As the suggested remedy is static per reporter's recover method, it
>>> doesn't make sense for one to set a recover method that by design cannot
>>> recover successfully.
>>>
>>> Maybe we should extend devlink_health_reporter_state with POWER_CYCLE,
>>> REIMAGE and BAD_PART? To indicate the user that for a successful
>>> recovery, it should run a non-devlink-health operation?
>>
>> Hm, export and extend devlink_health_reporter_state? I like that idea.
> 
> Trying to type it up it looks less pretty than expected.
> 
> Let's looks at some examples.
> 
> A queue reporter, say "rx", resets the queue dropping all outstanding
> buffers. As previously mentioned when the normal remediation fails user
> is expected to power cycle the machine or maybe swap the card. The
> device itself does not have a crystal ball.

Not sure, reopen the queue, or reinit the driver might also be good in 
case of issue in the SW/HW queue context for example. But I agree that 
RX reporter can't tell from its perspective what further escalation is 
needed in case its local defined operations failed.

> 
> A management FW reporter "fw", has a auto recovery of FW reset
> (REMEDY_RESET). On failure -> power cycle.
> 
> An "io" reporter (PCI link had to be trained down) can only return
> a hardware failure (we should probably have a HW failure other than
> BAD_PART for this).
> 
> Flash reporters - the device will know if the flash had a bad block
> or the entire part is bad, so probably can have 2 reporters for this.
> 
> Most of the reporters would only report one "action" that can be
> performed to fix them. The cartesian product of ->recovery types vs
> manual recovery does not seem necessary. And drivers would get bloated
> with additional boilerplate of returning ERROR_NEED_POWER_CYCLE for
> _all_ cases with ->recovery. Because what else would the fix be if
> software-initiated reset didn't work?
> 

OK, I see your point.

If I got you right, this is the conclusions so far:
1. Each reporter with recover callback will have to supply a remedy 
definition.
2. We shouldn't have POWER_CYCLE, REIMAGE and BAD_PART as a remedy, 
because these are not valid reporter recover flows in any case.
3. If a reporter will fail to recover, its status shall remain as error, 
and it is out of the reporter's scope to advise the administrator on 
further actions.
