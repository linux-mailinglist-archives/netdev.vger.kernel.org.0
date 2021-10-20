Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB952434852
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 11:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhJTJvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 05:51:44 -0400
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:30592
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230058AbhJTJvk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 05:51:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AP7KFAQ3A+zosBaWyrA9SzpNJt/NwcZTufPMjdaHdN44AgKmhPuV9syyuOtidaPtC638BtTKdoY9i4P4hNw6zcSJKjP8N8Tc3Q0gKuijnuDtUwSup5qioN5oPkNek7LxofCJZVTTtc47ydE1awLnaoTe0PP+Uhp9rFZZUVdrKwW+lWnbuFN8snnyMc+EORZ8WAv3AYERC/8b3ePd7zS6LqDJ7Ey8LF9EhL8B4KhUC4IHYSSLqMQ7oV/jOq4S0ZbWHCbV2Las8YbEEBcCZQox3GlOgza5EVS0mTxP5yJrH4LJ5EquYsPYdT0vw7k0WyPtYUeMMVQttw0CPKzf1fmRmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jtQhH49jeATDSvrb0XMHhnj5RIAkMJRsgiVpXriwb38=;
 b=IKrpBA1URETI4yPOhNxzJcy2DUcd4DHA1Ntz/aqmpkLhmtuM9mnPhsDPFxmvJIxue4voyprkOUftiqKgHUMIBQkH5FGIhvQfw0DfH6NEBBSHRMZ/viFjWMn2taR8F7c4n60O9Lk8ilfeqTh8fjOUlSoIl1I3CMVa3l1r325mFNaOjfkMj8Lm+i30kKoLj3KoDJAgaFxFaC080h7TYI4D3k7x+O7SxXB6dFYYto3Zsk7fHZdoGiN9NjjQ08Wrs/JeAStr4GCJdtJr8/8Vf33x6XeIwzzO+u02KceCpiQjkn4wuvC1aGLv/I5HquzKQ1wPZI0Lf3/yKuPF0S3FXfMAww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jtQhH49jeATDSvrb0XMHhnj5RIAkMJRsgiVpXriwb38=;
 b=AnLum5ggDi67tMcrVtFvtnjcxHkAKtDun+xFwqmxdwjJsid1NcqhzBpM+4kbWEOKeCGQCYBpsXcxrpn0uu/0rnBzrO9x373t4wM+Ceqjltwe5YU1hDJcJzUUsliqmki5zGkwgCz+zAx7koB2ZA83B1D26b1L2OU+mklf3cAkOnr5ejZKsWrA67snKSWB0gQy4CdYAsy1TeYBHJI59x5xqjP+qEYpd70lzCGZLGlEQQRycHJYIbqmcqd9zLXDWrF7fur+uQVpI/oz/VXXJxd4nI5jg5YIg1PElQYtQN7IvNQC6mtr3G7k/C4+3qlxM5czmarfS7FUK1wNY8PN861KSg==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.16; Wed, 20 Oct 2021 09:49:25 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 09:49:25 +0000
Message-ID: <c041a184-92cb-0ebd-25e9-13bfc6413fc9@nvidia.com>
Date:   Wed, 20 Oct 2021 12:49:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCHv2 net] net: bridge: mcast: QRI must be less than QI
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org
References: <20211020023604.695416-1-liuhangbin@gmail.com>
 <20211020024016.695678-1-liuhangbin@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211020024016.695678-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0152.eurprd04.prod.outlook.com
 (2603:10a6:20b:331::7) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.240.28] (213.179.129.39) by AS8PR04CA0152.eurprd04.prod.outlook.com (2603:10a6:20b:331::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 20 Oct 2021 09:49:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f763f02-e1bf-470b-f5b7-08d993aee689
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5398E99379E9C5E93BEA3A44DFBE9@DM8PR12MB5398.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5oHdTs1X6a2DxRkssLQ59R7LkdZJrzCNRBoSAU3UKC2wjwDyQwi57mmSqUg3cVbjhdu+47LO9EmUU8xCrCtK2OIpcS4vBqMKM+b+Nn+qac8DYT5vUtaud14hIuzoaCG1ZJa5FCV9XhvyCljzw6CDwuS6tpmf99PDNIGgr+xxGoQzQu3IqvlGQMtBRveIu/6+HYisMB/KtnNCvahu/S50jIUcENFsKQ3g8wgYDqi9gAmVZETkWGEm3w2gCF6bNsr0Evtfs+vDpizHH4/j70OTd+LGKheEmFdlrBQAz4a8unToo7QttVL7pb7CCdjM4GlXlZGROPQA29mGskDuEhO3vaFjKf0+T9zPDgMsc9xDbEgBuoF5iP3L0PZDfh+XesUcorhGK0dE/SQllxD9kpoStEzvQr3KduwJvDC+kPvUpuwVD8HDzrZLIDHFCa5u2v1W+ij2LRWfnD5s7zXQWkozIPZmsneMiopYnzWfZCNDxuZQKOxMXzP5YRot2/A3GRvFs5gegnYnffk4BQrCROV4A9hTuOD9JAsOV1pJBuxpo9q6drnHi1YoT4J12lAZBpas5qem8gLF3suGufVvZRaU8xjCvMv9U/fegbiSwx2ZFsP4YVJhzqajjObYXDsThgpzq3QwUp9NlxwpvEp4h3pTqdxSC5yrF0C8CdhmrUMz2Pj6LqYf68T+7lENUJFS7ZY87FuhVeyPXOreRWquE2zUsm+vnlUEY5f4brkropE4rNU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(16576012)(316002)(6666004)(5660300002)(38100700002)(956004)(2616005)(8936002)(86362001)(6486002)(186003)(26005)(83380400001)(4326008)(31686004)(36756003)(8676002)(66476007)(508600001)(53546011)(66556008)(66946007)(2906002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2NBMXJPejhpSzdybklmRGg5V2tDTUlxM2V5Q2R0RnU0a2Qwdk5pMjVneWNG?=
 =?utf-8?B?N2M5RTJOWGU0elJSY2I1VEVhT25Ba0pxNXVEOHp0UDdDNjdIdXVYbCtBNit0?=
 =?utf-8?B?bllHYUFWR1c2SmJWa2ZrZVVVaVNYVGk3SUUxM2RaeGVrV0xXc2xkRUVSYVh0?=
 =?utf-8?B?RHdwZSthUzljZTF2L2ZUVTIxVldZRWJXNmtqcEY2UUw5YU5ESGNycVlMM2NF?=
 =?utf-8?B?T0ZxT1Bjd29UQjQrNklOOUhzWjFjU1F2T3k3ZlVxMzQ5dG5Bcmd5bzNzODZP?=
 =?utf-8?B?UHgzalMzSEx5bHc1bVRpMk9nUFo2Y2N4STJUVUtKcjI4K1k2YkNNWjVRSXd3?=
 =?utf-8?B?M2ZjbGpidEFUQWg2d3hvZzUrbjk1cEhyY3VWWWhOYlIwenp2cWNiQ29hSUI2?=
 =?utf-8?B?VGoyMTRGMy9YVFZTOURkSGZDdE9kNnZiRlA0TnFkMUlWb3RWQVNXNVZTMlhV?=
 =?utf-8?B?dkxXZVkyWXdzdnVFL25SaHI2amZXNzRjSDRpbU9oZG8va2l4aDU5VlVlWnhr?=
 =?utf-8?B?bVd4VXJ4RHNpeFpUV3ZjclFUOEhoNDc1NXgvdXJQYUEwcHRDRllpWHJQYVhV?=
 =?utf-8?B?dVVUdGhpV2VDWWJiZytiYnpydTMxZmJvemgrVkFCWHBPVVptT2VBUEhpdUxp?=
 =?utf-8?B?aFY5VDBwL0ZZSWNFSGN6NjVVVm42SDd6MGR1VERMaU1PaFUrZkhMTGxrVThV?=
 =?utf-8?B?ZXV3RFl4bk1TeDFnN1hSTnltalJOUkhhQzFlQW9TcGdWREsrejA2b0MvSlBQ?=
 =?utf-8?B?VG9mSDlpcE82OHBtc0ZTaVk2dmZTTmM0NDFYTi9nZUZaUVlXQUdyNnc1anNG?=
 =?utf-8?B?R00xalRHWFFGT1dldkZPNjhHUld1Y3JYVzdVNjY3UG0zN1FuQjVaM1drdTJO?=
 =?utf-8?B?M3JqOXZ2MnBmVFdqMk0wa1lQeVp0cEllVHZiUFU4VGQ1SXZvaGtRZ1huZEdu?=
 =?utf-8?B?aWZVbVkwMzE4SjlwVEFoVUNhdC9yQW1EdUJ4aEFzZkh5TFRkNGY1Z3J5WGlZ?=
 =?utf-8?B?OVJTYjZjUHhUdSs0WWZvaGRCbHN5bS91bE1BVzI5aDZCZHBvVnJhSVAxUE5s?=
 =?utf-8?B?YnBSQ1Zibm10UjQyRG5nVU8wMjQwcUlkdVJSc1dEVkVtanR1b3BSQm0yMUZ3?=
 =?utf-8?B?L0lNd1JhZUoxTkFLWmFra1J1ZnlycnQ4YWErbWdFdWVJU1pzVU1pS2FWVlp0?=
 =?utf-8?B?V2NBenY0QjQ3MTJkdjh2M1pBbUhIOENsSWlKZzV5NUNlSnF5UExzbW11UTZU?=
 =?utf-8?B?QkZ3YWU4Rks3b09GRnoyaW43ZjNYRUhpUEJMcURDZ2xoelJEZmp2aUg4dTJq?=
 =?utf-8?B?U2tpSXd0LzB4d0VnWEpJdjlLYnp6Zk4wMTNuajlqY3Z2V213N0xLQVdHY0pa?=
 =?utf-8?B?TFdkSm9VSFl4ZmVId2xYRGZ1N2RzSnQ5M3Q3bjhMYjdvV2VxU29rb1NZTFQr?=
 =?utf-8?B?R3ZET29SN2twUzJyVkQxRlNPRVYySllQRkp0blZGVFRmdlZhTzJXUXViQ2Jq?=
 =?utf-8?B?azN5OG5qUGgxa21HSTN3dy9KYXhIRGdCT3NpTHVOaWhpOFhvaUhnOU8vL1Zw?=
 =?utf-8?B?U0VvTS82L1RPeUxsYnVxYVpEbnVOSHIrUUYydFQ1RlNYNThNNjd2VEFzd0Mz?=
 =?utf-8?B?c3M0NFVKc3kxalg0aFZVaHJrc1daMC9KbFg5VTc3Y0hnbGk1SXVBTDdOaDE3?=
 =?utf-8?B?NXhGWEIvZEVRbHVPU3QvejZ0dFpTNHF2dDhYaWlIV2xzSFdCdWk1eHZHcE0x?=
 =?utf-8?B?T1FyM2tMVzlSMGVaUVQzQWYvUnowM1lhREN3NE9IUUt3WldxM1BsckU3bDlO?=
 =?utf-8?B?WkNrR20xd0VvOXF0YkQ2TEtRamhzdXVoQktRVnkxOVluV3dQamV1QXBIdSsy?=
 =?utf-8?B?b0dxZ3dyVGZWdUhHRXBla0tnMWlrRlZhcmc0VVlLQnY5eHVTdHYxMmxpVTk5?=
 =?utf-8?B?UlRjR0p3UW5naWdIbkwyelNKT2xnazVQMXVGdkdsN1ZxMUptQ25nRHNQZ3N6?=
 =?utf-8?B?S0Eyb3JHSGNCaTE1dnNSajNldjRLam1pLzJQREhmRG9sZ2JxeVU5YnZBRXQy?=
 =?utf-8?B?Y0FIR04wNnlEYTlyM1ZXN0toM3YySTA5aVZqZlJ6T1pkT1VzY3Nrcmp6ZFhh?=
 =?utf-8?B?aFo4YWJSWXRWcXJwVjB4MllXMjY4eUVSeGVVbDY4ZE95QkFaUS9HTWVWblIr?=
 =?utf-8?Q?N/AAWRNqt7j90d8gGEkzC2w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f763f02-e1bf-470b-f5b7-08d993aee689
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 09:49:25.3299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LkUWkpzRhXR17wLchTPZEW99sFoMuchdAdR1673dWlTi6YEuhLs2bCQC2vrad22/N+BTfsQFekljJ8hTZK9tbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5398
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/10/2021 05:40, Hangbin Liu wrote:
> Based on RFC3376 8.3:
> The number of seconds represented by the [Query Response Interval]
> must be less than the [Query Interval].
> 
> Fixes: d902eee43f19 ("bridge: Add multicast count/interval sysfs entries")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/bridge/br_multicast.c    | 27 +++++++++++++++++++++++++++
>  net/bridge/br_netlink.c      |  8 ++++++--
>  net/bridge/br_private.h      |  4 ++++
>  net/bridge/br_sysfs_br.c     |  6 ++----
>  net/bridge/br_vlan_options.c |  8 ++++++--
>  5 files changed, 45 insertions(+), 8 deletions(-)
> 

Nacked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

I think we just discussed this a day ago? It is the same problem -
while we all agree the values should follow the RFC, users have had
the option to set any values forever (even non-RFC compliant ones).
This change risks breaking user-space.

Users are free to follow the RFC or not, we can't force them at this
point. This should've been done when the config option was added long
time ago.

Thanks,
 Nik
