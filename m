Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1156043C532
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239322AbhJ0Ide (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:33:34 -0400
Received: from mail-dm6nam10on2066.outbound.protection.outlook.com ([40.107.93.66]:50113
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240900AbhJ0Ict (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 04:32:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LuQ+24gz6ShGC6GCOPBWmGLraz42zDns8Zkp9m7lgwGftlTHowDqfXAfHEbJJXwuI5LGMJL/CDVDVaehzl72Vj/HQlIPQjMnUw/871cEdMVGWO1cPBKClseuxrj0sE8et2UrJSCm5EVI2XpuE7d8HmBVFfbPl8uVm4RmLXu+YB7lC07UP92kUk/noh4r+QsOo5+4TyCllyXnkCqQrEfMsuFFsRLLV1le7ef7WIry5v58l7ZaC/Gv0z7p4PtYFyQOQgDNWVvmEOmt40kvb2LefHJt/D615vUVt5n+P70olh1tSoTF8/j2+JO2KgBIMUEcIIdrKwp1exiTgNKvb3b/aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZnLSLiJzRIaT45KV7fELaWnSE0bBMN2gKwXsF8svik=;
 b=Usimr/xDt5FTJUAP3laHRQEmy6LugCeJ0cRPFBUIu8ZDC5KlVJklb0+ddHABSBEriGAeOhnYfBKgaPMWy3tup7SEf5SAOkCCsxH+2IaJyojBVXBXb5iZrPEJFIuK7RPCfe7W1aevvB+wSauFIaDAe479e0Tn+YAcXXJAUohE4TlkrVyRuoEcS2tpA2NTpqjSknIzOfwNSZSuAnN8ys34sFR9vgvGPato676ItS2RgWXx+znZUBZiGWFCk8Bfa2u/2Rtt3vpE6n75GTzEtpIiJOpo05vQdvYKMf2jIIPWtVMBAIpAwvjbhN6QN7K6Zp8EDbwXtukPZD3XJZNSEO8LbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZnLSLiJzRIaT45KV7fELaWnSE0bBMN2gKwXsF8svik=;
 b=YrIEuF/4HS0eF/EX7LewgpvQqoD5xTZuNV5CfK55MolL7/9osjrX2WXpfVhn3rnYKVNWvN1sD8WMjATWT+ML4EclTtdj9w6zq48EhnY54UZmo6xIq8eGiHZc8gtGekd/bWOLZwZ7+Qd2OkszDitdph9JVe6d4tzm3Wy2Nyxqc8IB+VXR6l0J7xAaKSpqlmM3MB9dBBhlLZAG6WY31untklLq6nqe690T4LIdwrn/7CT5mNe8UIjHMM72fKxGH5jyTicqpl5IQ4/BTrvhuM2Bsvs6mu2OZci99irR7rb0U54YiyLBJ41AWcccjV4uV79CpFXwWJw6mS8dsrXdHyJPag==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5245.namprd12.prod.outlook.com (2603:10b6:5:398::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 08:29:49 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 08:29:49 +0000
Message-ID: <de4c0aa6-707e-9ee2-40d1-51d9e722f48e@nvidia.com>
Date:   Wed, 27 Oct 2021 11:29:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 2/8] net: bridge: remove fdb_insert forward
 declaration
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-3-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211026142743.1298877-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0035.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::22) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0035.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend Transport; Wed, 27 Oct 2021 08:29:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3577765-c647-4808-dce3-08d99923f0e0
X-MS-TrafficTypeDiagnostic: DM4PR12MB5245:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5245A896496A2E10B895393DDF859@DM4PR12MB5245.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ddtgt6hzrEisXWc9zQnkXD6yN6lxMam05++VRYjAZlFnWoJACE4+SsU7y+GwDz6iYM/EVv9vBE9MQ0Ij7ENPc6ZVg+/lGJI09aQCEaC+BrtbfKJDBUII4VYsThJyOThpdDfL7uus2nEr7LGiSpSBOUHf7rc0iSvij3ww0NCR4BE6mh/Koi6xWM6ItbVdi6qF5qcabNxoC/5+8aQxyvrm1VLE2yNdXmlwyxXMqXAkRWIA2aVpc8m8q69rh9NFjydnqfjTaJhzbt5ZQU0+28SMhp+be+IEOOt6mHtAxbfpWOBCR/yFY1P0ir1sa6893JfGywcleCuQn7fGtQQbOhpxkJhpwHEIWLja6woUM3bI0HLdpTXFfRuc9B+JPwCSDLDS9QxculR5YCtKnwPqTHFhjgMqQvhQytUpDBR+evhkq0YQhFbaFx6Xd8v4P1REIJeQxt5sHoJmsdf8eyjZBbOXadNQxvfQDefCFK27ABzXuTf/mE4Ays2RAZpoM+d+KAASfXfS5vFLyiDz0VuhrNHwRCtAEoGNMdzLmh5hzlxCxDvRfQkXh9Yrf0d5w/oqpJQOcuPOi/j8AsDEpzOkTmgwUWi3nY+K9Z0zHHIWsxetWSQdv6F0wMa4sQUxK3gZPjz6G9a8oomWYjhdLH/oyjpRjOgvxccyek0JJiSfayCgIZSsH9G1s/PEvodMAURnkdj2XPAaV1mnf2oMAiSYmfx+s4BujtTZAddlTOG1OhiZYIg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(316002)(6486002)(16576012)(66946007)(6636002)(508600001)(54906003)(5660300002)(31696002)(4326008)(4744005)(107886003)(2616005)(83380400001)(186003)(6666004)(66556008)(66476007)(956004)(53546011)(36756003)(86362001)(31686004)(8676002)(2906002)(38100700002)(26005)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDhWSU4xNEJQK3NQYTcwWVUxUFJkNGowVWVjVHZ4RTUydTBYSmNaa3o1ZG9n?=
 =?utf-8?B?SUNDU1Rub211WW9ZcXJYaW9VQmJPdllDTDU0MGFMRUFRZDJnbDJBVlMvU3R3?=
 =?utf-8?B?WXVFem8vZ1dpMFRMU0ZrTmc2NVcvOVNxdTdUcXZXMzNVM0JwMWJ2b2Fhdlph?=
 =?utf-8?B?Yk9EclJEODllb1haLzZZTWtwdDcrYXlYWER2TEV3S2hQNVFKYmh1aldWWlY1?=
 =?utf-8?B?RFhXclJ2enJWQnBDd0F3bjU0QWlHYis1ODVNT1ZwTDdiWnpTSmxBT21FNGsw?=
 =?utf-8?B?MGdIUk1iOU5RTVZoTTN5a3Q4ZFNJQ2o2L2RFSXZHcU8weFNjQVJmazByNDVh?=
 =?utf-8?B?N05rT3JzLzVCOVRYZG5XZ2JoeCtWS0x5a0ZhQkhtS0F5dy83WS82ckUvZVl6?=
 =?utf-8?B?UExkWlp0Vy84VzA1Y29lQnlLY1Q0NDh3WGdTdzdrTU8wanF5a1lWSjdWVzJW?=
 =?utf-8?B?MmVTNHZVT3VnSlJqUHhBcTA5aTR6UFpObU9uU0prZEZJZ3IvSmFucDlHcnRw?=
 =?utf-8?B?Mmx4eDlXWTlrU09HSGdtamxaaXpxUWdia3RGeGh4aVlPb0xNVHlOK3RnaStU?=
 =?utf-8?B?NEhHWFVnQUFPRjBZa0owdnV3OXd5QVoxZHh2dkhVSDJLT3AzS2F5UEtmdHFr?=
 =?utf-8?B?R3Vzcml4S3ZMNjFKU09XbkYyeUpEN3grT2pNOTNjR25uUGwwYzhLMDJ1MnBC?=
 =?utf-8?B?OEYxeTl2TWtBZE5hNmJiOGh0S1UwdFpwNHJoWkRUM3czRVR2eTA2TkVROGtu?=
 =?utf-8?B?VWZ6ZVdzZlVxdWw0WG0zNkZlSG0xUFcydm92UHZTSmZoVXhqN3VVMjVFbCts?=
 =?utf-8?B?Vlg2Tk5hNldoM1ZhL05ZY2h1cjJQK3NSRytNUkRsckJEOE5jZHQrNDRBdDlJ?=
 =?utf-8?B?U0NEbTlEUmlaUldOMkxTbUNrNGZrblRYQWhpVEx3RlZiTndOeFcwL3J4dmxS?=
 =?utf-8?B?WXgvQ0hoNVM2M2UraHRrQzRudFdzcUEvZ1NtU1NyN2FMQWk3SUVtOStGdGpz?=
 =?utf-8?B?aWw2SEhKaWl6Zmhyak5hdTlXYm5uZHJRck1CT3EzYVRXTlZCVGJGamE5RmlP?=
 =?utf-8?B?TExBdXZzSU1ycTdWbDNZa0dXMmZPVXd3R05weUY4UTVjeFo0UC83Zzh5b2NY?=
 =?utf-8?B?UUE4M1Izb21LWW9sTCtYUlVQT1hVNzZsWnhuRHV4L3k4MzBFN2hqL3phMjdL?=
 =?utf-8?B?aVRHb3NLZXB1RmdDenpNZnRWYVp2K2RyVFp1ektQdWw4dVN0R0tVcmxMbXhp?=
 =?utf-8?B?S0hjQ3pSMk96L2YrNWhxWEx6M045UFVyN2pVSGlKTTRIVFlmVXZCV2IzZzJz?=
 =?utf-8?B?VzNLRU5XZm9nQVFGdUpaUEVJOUt0WG5lMm9HUzArNzhQeWVOeXZSdWlSZ2R6?=
 =?utf-8?B?UjFJYUFaOElyNVN3a01jL0xGbkdwR0lyM1pKZGRWOUFEb2F1S0VjdmtGZHls?=
 =?utf-8?B?SjhmTlV6WmFzSHhRNUhSdlZWZEdLc1pXMFRlU0lta0lkMldQcTZuSmQ0aE5F?=
 =?utf-8?B?RVdXc2s1b1JtMDZuWFljY2hmaitPWGRBUFRERzduYzZUcUs1d28wOFJmTy9l?=
 =?utf-8?B?RVRlajFJRk9TTVBrdjF0QkpJeGlPOVk2dGtXc0dMbDZGSGw2dGw5M0FQRzY5?=
 =?utf-8?B?K2xHa2pwd3J6cXF1LzRoNUd0ZDl6dnB3dG1EaFk3UWorcUFmUStxcHFtRkg3?=
 =?utf-8?B?Z0VLcmVWS0pKNEwyMDZTZ2JFcjNaelkwS0J5aEgzQjFnaXNvZHowVjNKWjRQ?=
 =?utf-8?B?WkZDWXBqVFR2YWM3VFFBNHZpWkRuRDFxbG9CUk82eng0elUvSFNQNUUwdDh0?=
 =?utf-8?B?dWNUckVFb0YvS3hUemJqV242OUQzc2VLL0I4dEkvMWt6amtTTHFlOENuWXJu?=
 =?utf-8?B?a1Z6SzNRTkhzenhrWm9EZjBtTFk0SiszRHJvcXMrQm95akxJdkZScDh4cjJr?=
 =?utf-8?B?T2pNVTUrdjU5Mm9HWjlOTWRVSy82eFN3VElzYlpWNkdmbml6YUhZMTZUZU15?=
 =?utf-8?B?dFFhWlVPZUg5RnFSelN4bnV4dXpBbzlpbUdKd0lxNDdycWsvbThjOUU1MURt?=
 =?utf-8?B?bjlISmFPaXBrQmtCdjJ3NFRSWWttT3ZZczRoU2Exb0FJNWZVakJjL2tVdW52?=
 =?utf-8?B?M1V2czhhOTBuTzNWMnR3Q0h0OUI1eXlZZWlwT1NUbXBibkR1RUhCMUxZUHpI?=
 =?utf-8?Q?FAxU/Jse1YMcc8k3Zciu8ec=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3577765-c647-4808-dce3-08d99923f0e0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 08:29:49.6178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qyQDN+q9lxARILuTsDWS7558n9MMR+h5mU2+GL3LvxYrt24111rDh4O5lol39C0kVifCXWsEnN051UVthLh8mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5245
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2021 17:27, Vladimir Oltean wrote:
> fdb_insert() has a forward declaration because its first caller,
> br_fdb_changeaddr(), is declared before fdb_create(), a function which
> fdb_insert() needs.
> 
> This patch moves the 2 functions above br_fdb_changeaddr() and deletes
> the forward declaration for fdb_insert().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_fdb.c | 116 ++++++++++++++++++++++----------------------
>  1 file changed, 57 insertions(+), 59 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


