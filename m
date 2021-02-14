Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECC731B00C
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 11:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhBNKVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 05:21:02 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10197 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhBNKVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 05:21:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6028f9630000>; Sun, 14 Feb 2021 02:20:19 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 10:20:19 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 14 Feb 2021 10:20:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9u0tgWCkIT5C3YEOiNRUVZJtmLZKxpuhyH7VD5X6dGuzW8eFai0744XR6JEz+z5R5+uq7lxuyEiTau68mG3pfNxiINcmH1OFdqvWIKwz9I/PsZeocjwqPj89r+Gz7xnG3c+5rHNRnX3RWHKhMO1aqYkq328TQYrueurfwwEKT30BXovyCS/mehWzRZ7DWYagmDWLbueWvHYC1b3rbliubtCdH16wQTkGlqyXykbeTXR+8DpKz8lQLJpE6szPLhvrlM5LF1mOI+iVFJVxsF2M5YGj+U2yfGojIk+ESfkkr3dpmxfa6swUgCqCaf3O7mP4lO0iin+pHv0WQyuvvzQPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75cGke21lTOD3HhHFEEk4WxFfZGCoc1Qd8CO8Kmg6iM=;
 b=E05Ca2MoNRw9YMyXE9vZpLWYzx+C4B3lL2Pqasw02G/CZesvQaIZYdSUizGKDXQBsARCHn7VWUtHmQKUh28gEPe6EJTvtgE0MVfhwdlCk19JUMFFgQcUqD491C7CG/ByBHvP425aA8ByI9ctbkPg8FwK1UREubf+gIvmDxR7zRpH8wA8j1oTlAbs+YatoIg7MjEGPkXmjKViCJ1les3Z4l8rzx0oW2bquO8upHGaDa/+BaSewmqHWS0t7tcKU4sC8cjiX2wYlZAC9LvzQFNdROBOriXHEqOGWQZtWGOt1hHlCcW2NHoBlo2GmPtRIeda81WOAM+iS5H0lPB9REYpkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB2730.namprd12.prod.outlook.com (2603:10b6:5:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Sun, 14 Feb
 2021 10:20:17 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3846.038; Sun, 14 Feb 2021
 10:20:17 +0000
Subject: Re: [PATCH net-next 1/5] net: bridge: remove __br_vlan_filter_toggle
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
References: <20210213204319.1226170-1-olteanv@gmail.com>
 <20210213204319.1226170-2-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <ee4971c3-aeea-aa61-1fb3-b02bd041b03a@nvidia.com>
Date:   Sun, 14 Feb 2021 12:20:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210213204319.1226170-2-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0058.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::9) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.97] (213.179.129.39) by ZR0P278CA0058.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Sun, 14 Feb 2021 10:20:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b99f3428-9a6c-40b3-3d5c-08d8d0d2203c
X-MS-TrafficTypeDiagnostic: DM6PR12MB2730:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2730BE9A2E1629DA56587FDCDF899@DM6PR12MB2730.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:400;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TguY4C3dWmZB2r7mBXkHtUKTp9+QZAP1Z9qt3jy2Snzdc4x7ariMO+qamt4469aY1OIeCaVtT5PGGplCtAteqtFfGJSvH2ObOfyIsV/qNCtgCzccaITRfWP9bayK2Nc54kXXz1yNWV4lqsXUU5n4s7lksaxVchh78p+37gtQCl8xz+7kaJrksV0Z0RvfZrpuLXfajPQHRjRuxL4e8sBY/dEga7qVurTNkNv+mnBs+gNIoX0sZEdSP4SrrALOjHZwnxTU+L0OxsPywvTs9H2R8c8G6TjRZONYkpt88UNRKFthp/tdQNlGzMpF1EhUbZf1M3zg7ezqImlMQOw6i3uH3xZ3oe8MC7xR8QIcAxn8st5tVchwObrMeJSEm3BOX7hXDr+6XzOU7IW6JT1yacPKUYapYLX5+8WjXC9jypo5YHptiOIrMRl/LZBURwwE5Iyk3PIb2Ey1tCfzpmvMkwGwt1+m0mNKnwbJ94rIP/YYeKdfhY8WBf3S6jOXNNl9YRBylbCTg2+JabkfFljflZii3NzH+lEQ6j7h6BcudK/Z4haP4vST7J9R0lHf0oSMVkJ9Pu/zDpQ3NYb1T2htnZRdtvJ8M7MmGMKpPh7LkOT+Xag=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(366004)(346002)(396003)(110136005)(16576012)(66476007)(2906002)(4744005)(4326008)(186003)(16526019)(66556008)(6666004)(478600001)(26005)(83380400001)(66946007)(316002)(7416002)(2616005)(31686004)(8936002)(5660300002)(8676002)(36756003)(86362001)(31696002)(6486002)(956004)(53546011)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T3gyeEFERUgzSWFxZ09MYmE2c2JwZVIwcUgzQ1oxajFPb1VZSEt5aCtFZEIz?=
 =?utf-8?B?MWRqOVQ0RTg0dm9zN1d0OW5jdzlCSkY5OHdsbUR2ZjIvcXhoUVFRZCtYcnBy?=
 =?utf-8?B?QkdUemcvQVVLcmNjQVVudFBIcHBrTndNWTUwZkpHUzJwS1BZTEpqUDI1NVlR?=
 =?utf-8?B?N3RSa3lUeFlLa1Y0cWRnK3lRQnFsN1BwamROb1AyM1NvYzVBNWJ0Tlc2UEJ3?=
 =?utf-8?B?STY5aVNldVRaZVJTdS9kdmoxREY4ZnRTSmFHYVo4L0RrNlZSazlJYWU0UTln?=
 =?utf-8?B?NzFTUjJ4VDFvZUZVS1EwT2YrVHpIZ3RFQ1ZhZ0tUaXRuWTBwcVJ6c1FTN2JY?=
 =?utf-8?B?NDdMWGFyNy9Oa2pubi8wNThLWkpaMStCV0kvakxzMHVZN0RKZERxbHBDcXh3?=
 =?utf-8?B?Q2RJZ29rd0t0d2lVdFVoWTJkU1FIQ2pHSlRrQ0dDRlJMcUZOeWU5MmJzTG5j?=
 =?utf-8?B?R25NR2pKQ2VxZlFzSFF2YWNYQXZlcm9GeGdpMDB1QWdmZ0FaMHRhOUlvL1V6?=
 =?utf-8?B?M25KMlRTekpEV1RZd0pOQWhwSk9jNnF4UDkwRGpNaTh4akFKVlhmdnkwMUIv?=
 =?utf-8?B?UmVscmFMUFBxZTYxTVRIeU1vWGxDSmNOQ3ZOSE1vanJjTmo4bllkOHVQblhY?=
 =?utf-8?B?M0hmemtjbm1sZzljMUpiNEtKMWxFZkhoWXg0TFRIenNheGpsMUp3MWVRdnJr?=
 =?utf-8?B?NVdpZEFvUEhQWUhnME9QWEtwOWM1K3V1Mmh4QjgzWngwbXordkJMZnFjeXFv?=
 =?utf-8?B?eiticHFUZFNCUzJzbTJHQWtYK2VWRXViZ2ZyaEtRa2ZtWGJHaGlLNWt6blA2?=
 =?utf-8?B?ZDdqZVVqbTZWUGFXU2IrTlpGREk1WnpEcFcvYXBtUlhTVGc0aWdVdzRyUUhN?=
 =?utf-8?B?RDhUMXpOTW9oNlFGc0pjNlBucmFSQmVUeGhjU29sUDF1QWVZdytmNER2ajE0?=
 =?utf-8?B?R05tZUxnRHZjbi9TQVRxVmU0dWhOQTNKaGlxbFhaeCt2UDlkQUVkVStPdGtw?=
 =?utf-8?B?TFp6UjlxUjBVcmROSi80aXJXWk1MSDNlNENvVEdkWm9hZFRHekxrUEJrM0hz?=
 =?utf-8?B?aXJ3YlRNdzhjbHUyUTlIOUh1ZE5CWjB0Q2x1VXdENmFSbjB3M01CNHUwSlFn?=
 =?utf-8?B?b0krR1NsVlhVQThzMlF3R2FacmQxK0VTNEJvODZVWGZHWG5FVW1ZS2loNVZK?=
 =?utf-8?B?Y1NnNEhmYzRnSFdPVmhmMWhhamFubk8zR2VPNGZBTWV2c2lLbUxEbDJFcUxW?=
 =?utf-8?B?bkdYMTVpYUYrSmE5VGZ4SlIxUlk0aDFMUXRVWGNqc3EySXhaRFBCSnQ3NjRS?=
 =?utf-8?B?dllnQkJYSG0zcTdicWJna3dnaUxPVVFQV2ptLy9LdnJWVER4VFBoUXRvMTJI?=
 =?utf-8?B?MHIxWDJiNXZTNGlsZkE1U1RPR0hMcXB5a29vbTBPdGx3bGx0d29UUVdzU0RU?=
 =?utf-8?B?UVBhTzNCOHZDVEdjemh3dGhKWWZzTmpVa0E1Q3pJaUJ5K3FpWWF3VUc2bzRj?=
 =?utf-8?B?VUNWQ2FYdVpPM01mbWNmWDRXWXkvOWZpYk1IOUZianh3QkY3djNITlFLODB5?=
 =?utf-8?B?bmtHMzB1bEpUYUJzdnJLb09LQXh2TkJDTGNLR2VZbXk2ZlNEdzh2Vis0YmFT?=
 =?utf-8?B?enRMSEl5Y2lpMmtzS2NURm1SZk1wbHcvenNOSGx0TkVaUUt2WmZRalR0Z0Zk?=
 =?utf-8?B?RHNMdHFqdjFUMUg5WlJpT3ZtUCtrSW43VU1TK0xzR21DbGozclpMYXZtd2E5?=
 =?utf-8?Q?CwEvmIsoeuxwr/oY7bBRVQblaigxuLGFSaC4he6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b99f3428-9a6c-40b3-3d5c-08d8d0d2203c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2021 10:20:17.6807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R0zYavEJkZknrryo9zwTImCikf5I8vI/JWgMs1MijbadClL2vfy64a9nqVKPizuuHf1oTJOJDTl6aVQWayDl7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2730
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613298019; bh=75cGke21lTOD3HhHFEEk4WxFfZGCoc1Qd8CO8Kmg6iM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-Header:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Xw2absL+38RQYMnpjm0XcwJqJ2PPYvfHQyWJDEueOSOM0SUkqJ4Z5L4/Immhelk6m
         8Vw6yZVmeXBEswEckOPZQ1f1QzNnDBerAa9EFdMhEkzNqV7zYkMtTr3/F/BVvEqMKb
         dKC0ubvkaKAs+gTdEbfOWLpjJGfZqgQ/GN4wL2Go/WX2CTF+9aQ6CYZYIgyePeuBY4
         x9vxGSnS5nyIqyC7rP3Db0sgOG9BU6PMtK9N3xkQA8sh4fPZwrt/4S2VHDzEcSU3R+
         OYrnUnHCJ9bkvAxsXMR5bVgahgXS0VSszbssZYXXFScI2QcHblL6vA3HtSNXd0Jefj
         +kpKgpsr2tX+g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/02/2021 22:43, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This function is identical with br_vlan_filter_toggle.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_netlink.c | 2 +-
>  net/bridge/br_private.h | 5 ++---
>  net/bridge/br_vlan.c    | 7 +------
>  3 files changed, 4 insertions(+), 10 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


