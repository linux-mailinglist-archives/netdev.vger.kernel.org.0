Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04217399B62
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 09:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhFCHTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:19:51 -0400
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:28204
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229610AbhFCHTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 03:19:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WofK5XoksVZr43t49Hb1QgC5pc4GFndid1r3g6L5gXcbqJoB32LObx86WAUVxcMVo+fBRXDLErNNxyHXqsJuH7WzwaB6nbtjm6Pf9RCyOXPzZ7Bsi/4ifU8Ogp7Vba5AJe4bbiZM6NiYl6E6pJqb+Hzk7x0HvPMXQWoL66z5nDAHWOj9w4EjLE8wyzqDKpcrBP4nJ4lic5jE9H37v4BErJGkeR4ZlBRKbPvrzmzDuE3yRbuhEBSLJdmktcw8V/l4WGsjVNXoqRPijSg8MiizeuPuv5fTL5YM2LxQPUXfGBH/19d9VezUS69zndnw5R2Na1BwRdVWON4CHuboLyDTFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqFYw776EQDRq3Wrgx68/aPeHCtus7bfpbfMRzwj0ms=;
 b=S1lTPISOqx1O7GCXbGBrHmRsYiHnC4WME8GQNWoD1TFY4nhYzV5AWEekPkv5nTZnG9C8xv8s6mt5YSMenSn72mz9Zw6W9EYeUL6vfhbQ2vDiDy4DNkkSw5WlHrUoyfvwL9oHsr0wwCB0LOg1xGslKuV8DKGXPcLZzP387o2U9ugbhhJKP1uLQ1qjcPH5mbko2iPhUGNJByE2ZL01ICTSAP5QRkpGQOLO4d0o0n0YYVSe2/mqxuGDCaHjONWkyBdmVfXMeVhqhNYjp91Nz6TBtNxw0shl+BqsC4jCO/FyOdbKYtWIMU814eVKnoB3UTiVzlJzYq6cJkxh9AS/4Sat2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqFYw776EQDRq3Wrgx68/aPeHCtus7bfpbfMRzwj0ms=;
 b=ABGzljO9eWapt2N304U2lU11muJ7iuLUX/6yeQ+7uwBL1E5BQmz5FfF5UwaxwgCw7vjBYYgpDhAu1ipGASq8n4tLtM8uR4M4irPTGLR9wKY4voXanK5Wk5HeXP9Aq51Eno46R69u61lLoGxffgkYUB95zckdoopuk6XxSRJdo3yGvyGodf7xVXOHPDttN8R/CVbMb9hhpzLH55uNyXP8ItSX80FoqIOLKmTynihk3L3CrYYgq5BkPRZLJU/na17XJjUy5MiJOBEYQwAGkBLviq0canXcswKW0nhHA4o53qqZStsNS0k+Q/lzb8Xc9X1MQ3KtAIhK5wTnN+SSV6ZdVA==
Received: from DS7PR03CA0300.namprd03.prod.outlook.com (2603:10b6:5:3ad::35)
 by BYAPR12MB2903.namprd12.prod.outlook.com (2603:10b6:a03:139::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 3 Jun
 2021 07:18:04 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::7b) by DS7PR03CA0300.outlook.office365.com
 (2603:10b6:5:3ad::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend
 Transport; Thu, 3 Jun 2021 07:18:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Thu, 3 Jun 2021 07:18:03 +0000
Received: from [172.27.0.70] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 07:18:00 +0000
Subject: Re: [PATCH ethtool v2 3/4] ethtool: Rename QSFP-DD identifiers to use
 CMIS 4.0
To:     Ido Schimmel <idosch@idosch.org>
CC:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>,
        <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
References: <1621865940-287332-1-git-send-email-moshe@nvidia.com>
 <1621865940-287332-4-git-send-email-moshe@nvidia.com>
 <YLTxWcO1pNQkN3Yr@shredder>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <f209cd19-b841-22c5-ad08-b41f36a270c8@nvidia.com>
Date:   Thu, 3 Jun 2021 10:17:57 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YLTxWcO1pNQkN3Yr@shredder>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb2146bb-048b-473d-4571-08d9265fba4d
X-MS-TrafficTypeDiagnostic: BYAPR12MB2903:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2903E9CBFFE197CC55DBD6CAD43C9@BYAPR12MB2903.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zJHRf+2Ndb6eylNWxAoCiG52lbWkql+RRgKisFa5nayKZIhYLnGGyrhZldy+8EZ3Fdg4/BDCCf/gLrSwJwT0W2JVb7iaLe0UoXQYsH55uYsmWoePxaTziXvM3GjNZbu762GZ1kl8w8JiLjf1qJ3++UEgOvmBmR6ggXLbPXqYnoHeywG1145GtjeC7DIzksBGk7ngeW22wYY/L7pjgv1lGkXsums/hBrx8P0/wqCbm1jjeoTc4w/AgwF9KHKDjLlov7eFP2YcyP2cskcIqteyH4KhJdUnTo4RbSoYrP1cODBLzTUJLt/xjTJMj9NN1Gbx8hhLAQv2tMR1XbZaR7e38NaRJlrhUzNgilVJxc/TEsX8F52JD2o87v8YJYHgo8xZHpa3rtCm7XbzhiFLhQ8CwUC6DvpDOEulz+RB15XqNDvFQU+yCFe+ZzqNluIqjLUmX1zW83Ba6PtbE2VjvQAXyGGPWCADkexFIyBEvzPe9pt2v+dU0sKJf+EHZG4BVodDIHg6XcKKta0m7oWY+Ds4ruO0ZR7cLCNKeiTMWrdfZAC0WYPJJaYQeqzsjPRDCmiTL87a4c1MnBhE0d9mvtFWC2hLuiCpStNFu5PlGicYQivuqKg4pQRP0AkmTANvlIq/n56Oug7HaAQmeKFTUxWIIrN6z6D9NdEuEPDCSoAZk+BcQJUQjU3k/KMZ9d52TAUSMKv55UM0Dll3VHqGELzbZQh43qqE//qg0wt/lZf8fk77G7aBGk6yrBcS7dCYTjo72HD/wAHx/B6X5A99okxdO+2YB0C/D6Fd193/Se6TvHAxtF54Z6QztKtEaxeTunZ5vxonS3uUef+0Vh7aX/GaBw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(46966006)(36840700001)(8936002)(8676002)(82740400003)(83380400001)(31686004)(31696002)(7636003)(426003)(36756003)(36860700001)(82310400003)(6666004)(2906002)(356005)(70586007)(478600001)(26005)(186003)(4326008)(53546011)(107886003)(336012)(70206006)(5660300002)(16526019)(16576012)(2616005)(36906005)(86362001)(47076005)(966005)(316002)(6916009)(54906003)(43740500002)(15398625002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 07:18:03.7141
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb2146bb-048b-473d-4571-08d9265fba4d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2903
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/31/2021 5:23 PM, Ido Schimmel wrote:
> On Mon, May 24, 2021 at 05:18:59PM +0300, Moshe Shemesh wrote:
>> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
>>
>> QSFP-DD and DSFP EEPROM layout complies to CMIS 4.0 specification. As
>> DSFP support is added, there are currently two standards, which share
>> the same infrastructure. Rename QSFP_DD and qsfp_dd occurrences to use
>> CMIS4 or cmis4 respectively to make function names generic for any
>> module compliant to CMIS 4.0.
>>
>> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
>> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
>> ---
>>   Makefile.am             |   2 +-
>>   qsfp-dd.c => cmis4.c    | 210 ++++++++++++++++++++--------------------
>>   cmis4.h                 | 128 ++++++++++++++++++++++++
>>   netlink/module-eeprom.c |   2 +-
>>   qsfp.c                  |   2 +-
>>   5 files changed, 236 insertions(+), 108 deletions(-)
>>   rename qsfp-dd.c => cmis4.c (56%)
>>   create mode 100644 cmis4.h
> Is there a reason to call this "cmis4" instead of just "cmis"? Revision
> 5.0 was published earlier this month [1] and I assume more revisions
> will follow.


We called it cmis4 as we comply here with CMIS version 4.

However, I understand your point that other eeprom module specifications 
only spec number is mentioned and probably we can do the same here.

Andrew, Michal, WDYT ?


> Other standards (e.g., SFF-8024) also have multiple revisions and the
> revision number is only mentioned in the "revision compliance" field.
>
> [1] http://www.qsfp-dd.com/wp-content/uploads/2021/05/CMIS5p0.pdf
