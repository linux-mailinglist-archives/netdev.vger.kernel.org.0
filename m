Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F183187AD0
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 09:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgCQIGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 04:06:35 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:40610
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725730AbgCQIGf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 04:06:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmb1gWYwJX1jlsDepBkBzUxcgkTZYDdIjwkAQ10Yq0t0rqrFzcJUB9ckvjzh+vd6Hq4dmAkn8cZx4VO+1zUoNWIVOWo3QRQZVCMcaFjR6E1q4V2YI4x4vgfKoXUGxItQT8DwZZqggpXHKmNQYQ/tMQGhkvSyHj3wN0DJZbAB1mLcNwjxMIqoYL2mGSf9lRj6W9vLuubt71KZhqjvpxZ8w1f8/eZI+szsP2Jp1O0VdaN1BdEBF/r7YKYpRDAAcMLuJyhOJQpE7T5Rh2W4ShZCMBjXJcGxC+TuA0jsJ7BER8+26v6ZUdy0MwwDbT/gCqm8yWbsmUm9UE7bGMZ3JG1iCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRqkWTAfK72ufs58Ea+1xBGmJbv9yDWDfWw1VWNzR9M=;
 b=mL4P3JK5e92v8O8r2UI34P0h8eWe3PZpihWFI5Q/3vlqGTWshAF4FX0xMffNcDFEksUQPw+rGG7gRz/9lamEs3l05KioE7ohSp4DFq/Z+94b/oKib87E88zl3rYBL7pJYIKbJwsRYPzB2VAqHXpDkOtKNzcBhMR+VgvsDSUnEzUgErYz7pPOdim+NR1AAIYNoRUJuQ9jmlI2A+QQucZUjGhLtz4462drsKLTQf/36M0XhOEFefMi8tGybqoCw/YWjaNesc0NOVwiQb2/tSZdMNwOzHWJFYAJ1JFSWtph3OrYddBjCURsMjMDWi86gMTQcy277gN9k5FJdjj+4Q2nfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRqkWTAfK72ufs58Ea+1xBGmJbv9yDWDfWw1VWNzR9M=;
 b=FoQMXKCWQvhtMgGbd+9fgUrLMx1SMoOInKCMjjCfV/kbGC1p0TXGwxqEmY0hPtjm0fZy8SJlQTOG4/jGPZVxxRXz0+hKUca5OAhZixKFy8JSP8yk2tW5RB8KJbIAw6dUntabrfWKxbE5XEoCHFMG0ddmJApLgf770C1FjY97Jik=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com (10.169.134.20) by
 VI1PR0501MB2365.eurprd05.prod.outlook.com (10.169.135.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.21; Tue, 17 Mar 2020 08:06:30 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::71d3:d6cf:eb7e:6a0e]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::71d3:d6cf:eb7e:6a0e%3]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 08:06:30 +0000
Subject: Re: [PATCH ethtool] ethtool: Add support for Low Latency Reed Solomon
To:     "John W. Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>
References: <1584025923-5385-1-git-send-email-tariqt@mellanox.com>
 <20200313192803.GB1230@tuxdriver.com>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <19010e9f-1847-717e-1ade-a4157205503a@mellanox.com>
Date:   Tue, 17 Mar 2020 10:06:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200313192803.GB1230@tuxdriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0093.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::34) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.125.109.57) by AM0PR01CA0093.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.19 via Frontend Transport; Tue, 17 Mar 2020 08:06:29 +0000
X-Originating-IP: [77.125.109.57]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4a64ef94-d4d8-4f90-d9e6-08d7ca4a19b5
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2365:|VI1PR0501MB2365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2365FCCFF5E9DF45A344F6FCAEF60@VI1PR0501MB2365.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(199004)(53546011)(54906003)(478600001)(16576012)(31686004)(52116002)(6486002)(316002)(2906002)(2616005)(956004)(4326008)(5660300002)(6916009)(86362001)(8676002)(81156014)(81166006)(16526019)(186003)(66946007)(66556008)(107886003)(36756003)(66476007)(31696002)(6666004)(8936002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2365;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i27Fa5dJgj3t/Q3tAfz6vDmZ8s7dJJfjSqzYZL8+dlYcqSZ4msqKzNesg6cgGCZ46E+Yw7U9dSzBqLnu8cRGXKwobBUoI28A56+jdAT0QxcoCCkpVUsWAlZWFx+560/Chr6eGcu7c3d8qtlNFT8sTdpYRSSnm7ramaSTg2NLqeLtSQVkQBzM6PcIGj2iWDVeWqEIU79Fk7q7RvA3AWHcfFv7Xg+Huw82XSqtie8TDuEdNYCgqfqR+/jekePDtExzojwe8ED1tvRhhOUPON9tb6DWVzQ0J59GKyD4AxDUSq/YssMN8n8QGg4GJ9kYvIWcgq0IerCe+Ftpu5bdCFfJZrL5t0zl/8N8bADTMd7XWMPnbjVAQmKNNp5TQ6JHzBpaAsG31TVhtRnuwI6bvBgMcbYESDbI/nIeKKy2ShJeA4FXCP8B1PYySI8eI0xPJGnj
X-MS-Exchange-AntiSpam-MessageData: fGuxtdA83gPr9OeOb9R3OxxZ32wqO3LDSPxcCWAD3teFlJXtN0SqdogLkSlTjsUMdBP3BhhxJXRuGAU1EM96tyFRP7EaIEpsB5YuPF8i0RoIUcNrjb/95AxaE2WcYmI8cP4tKTcTCamUzSJtp2jMYw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a64ef94-d4d8-4f90-d9e6-08d7ca4a19b5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 08:06:30.5862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u84y89aF58+UH9vg3QWWFQVf71tSExsLk8ZSgb/jFfPZCV2fqyKE0dkPC1RV9ILiWDl3sT2YgQ/f7lJiHWxs+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2365
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/13/2020 9:28 PM, John W. Linville wrote:
> On Thu, Mar 12, 2020 at 05:12:03PM +0200, Tariq Toukan wrote:
>> From: Aya Levin <ayal@mellanox.com>
>>
>> Introduce a new FEC mode LL-RS: Low Latency Reed Solomon, update print
>> and initialization functions accordingly. In addition, update related
>> man page.
>>
>> Signed-off-by: Aya Levin <ayal@mellanox.com>
>> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
>> ---
>>   ethtool-copy.h |  3 +++
>>   ethtool.8.in   |  5 +++--
>>   ethtool.c      | 12 +++++++++++-
>>   3 files changed, 17 insertions(+), 3 deletions(-)
> 
> Hey...
> 
> Thanks for the patch! Unfortunately for you, I just merged "[PATCH
> ethtool v3 01/25] move UAPI header copies to a separate directory"
> from Michal Kubecek <mkubecek@suse.cz>, and that patch did this:
> 
>   ethtool-copy.h => uapi/linux/ethtool.h       | 0
>   rename ethtool-copy.h => uapi/linux/ethtool.h (100%)
> 
> Could you please rework your patch against the current kernel.org tree?

Hi John,
Sure, we'll rework and respin.

Thanks,
Tariq

> 
> Thanks!
> 
> John
>   
