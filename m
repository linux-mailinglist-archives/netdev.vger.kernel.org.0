Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62A543C55C
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbhJ0ImV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:42:21 -0400
Received: from mail-co1nam11on2081.outbound.protection.outlook.com ([40.107.220.81]:53257
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235727AbhJ0ImU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 04:42:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPiD8DZev6tauTAEZHSF5kZMLmm1z0NR9yZ23JvOIC3IJc2ty0eQNb7DJI/SxRCBPzcOuch+NacQU3iM6byQKsTpCipl/QiLqCFJctzHwzlVaLc2HZJcq4hipI9voRsx9w0li4n+RUh2DPbo7aKVaXuYsk27FTBLv/bphorTSgSpAH0fc5Hmg9aadyqhkp37SK8EqLHSNsx3uyUgcLBqvKo//5ORRlsU3Y2LK1SFneOM8yMsIFWIPIQb2W4NKBHorWgJkAex+QkdPXQiVYHq3RO/bi0EfRAk/4s/p6KRYjOQ9nGJ3CQIDoYBndZ2ruIPDiVUwsDBKeBE0FTk2R/GsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2siee4F8xI59iaGAZI40Lqfp0h0LgLRpDddleXPGF8=;
 b=nx2+rc1maIjsPKSmGGuifmJyDmWL9iNCeSL+WvDtAO/CIxaljZvrtS6kjCyuDnnJEhyZ9jkk8dmBXxWwvaRsEPzNFOB+0Wq2D6I0lPdEKGdlGHF3ae+oMSoafj4z4xtpSGx87UEOg8tLrK0OgOqQFyS7HRHpAiBibmyUeQRl+kRVh54hGAx55+CHBNLNYVFa81pfhKo1HJJ1IcMQUnTHeL2AMRvj6XiKfRh3qSSG5XpE37ngagtqo03VIupaesgMZzjJubYW3BQw1tpEww8+6vj8agSiqJp4gYCUrpScv+EOTTaalBZrD0fNyC1y4iFvB4hUihSpqKX68A4W66mpVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2siee4F8xI59iaGAZI40Lqfp0h0LgLRpDddleXPGF8=;
 b=jZsVTAXgCnlcAPBbb65Y6rtlqo6tzcPsCkwkqTkfVdI+oaL+CyKuHGP6jcZGEGopyHaI/ID+23Oszftdt3kaGvYnSY2mjq8gojAljFfDq2Dk8tr57LAxsWokIYML4gKeBmPVLYQkhJoTUFtO9ttt2Q9yNjPYA601UWBj0pYWvc1i+oSlSn/gev6wPtUlzBgOY5AQTC/CS2NDQcfmDCgZKdBagG1hyAdejXSmyNKzTgUDZd7NwWYbavjq+vW445bApDL3m/Z+xIX1R69WoQJvZkogDyUp5h2ZuiyEjsO5tyaOkFit58DNUYr+Ki4wHyFFhkqM7/RlMwNN43ZnjVUhzg==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5534.namprd12.prod.outlook.com (2603:10b6:5:20b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 08:39:54 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 08:39:54 +0000
Message-ID: <78be1476-ea67-446c-575d-29d69ffa43a7@nvidia.com>
Date:   Wed, 27 Oct 2021 11:39:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 7/8] net: bridge: create a common function for
 populating switchdev FDB entries
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
 <20211026142743.1298877-8-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211026142743.1298877-8-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR0102CA0073.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::14) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by VI1PR0102CA0073.eurprd01.prod.exchangelabs.com (2603:10a6:803:15::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 08:39:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6d5f2a4-7ff0-40d2-273b-08d999255917
X-MS-TrafficTypeDiagnostic: DM6PR12MB5534:
X-Microsoft-Antispam-PRVS: <DM6PR12MB5534B9F8770F94677F5EDC24DF859@DM6PR12MB5534.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ickd+j36V0tnIq477dP9UJFk9ut847p22DwJYpaFlTXkjDCXrgjwHdnpbiLu+0oJtpA2zO+kWjQembERoQjtyMLZQoZX4soxv2a+fEJKZB86SI573syooV128V3Yviu0vUdcbd+bdf0gOQK14H8e+IivBnDDTuo5JZauj5xgE7aPN7/ZJoyOErqz2gXZoI/AAVdWA4JUzpLYPwDC9se9tUwfncE4kxpTHylVUwHUynoGaQ4TQzgBaNn8zg3MeAR01aeD3D9VlqcD7kK2cnk5qiUzGiLKcGlCQB1y9Jkc+QqirLGqv7BJvGESCfFjTpCqP566TJq8svIbiFV7Gse3sORoEYIxNEg2cAKcm4g7x0YNZM7r9ZbBUqcSNtJ9/0Nk0p3DuCiRBAadHrosVG8HhWXkCWbNgMvlYwzKPmQidn+e6vJhwr+MDoY9MRX9MEY4PwNjIxRDJLfemUajROdZk7K7JXdOPxgfHCP7F4NGZndfQt8Geldfcv08iReoE5ZardrKsOUvQUD3FU7IDtaoUW/KiD3qLIiX0cruJx6xPzIB6GThEJ0gX9en3RAcVGA6rMHFzmmuHJY0TWjMJIyRaOwOEObtE8tCGx9558tSMtSllhWWFq0Rruso7r7YFjqR+uuMBM/u39RKcLw0klsqDV8mEjzRtO4We+n/LP8YyMIIOH5Vy+PQeiZWyQZzFY/izprFLQbyS3R9KDQnCGjw2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(316002)(16576012)(5660300002)(6486002)(8676002)(2616005)(53546011)(107886003)(66556008)(2906002)(26005)(186003)(508600001)(31686004)(66946007)(110136005)(6666004)(8936002)(38100700002)(6636002)(54906003)(4326008)(31696002)(66476007)(956004)(83380400001)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dndYaDZOZi80b2FIWE9GN1puSE5ZL0RmMjhEUUZHbFduWURIbGJnNFd1RmQr?=
 =?utf-8?B?S2UzbkozUUVBakRlSGxrOHJCbTM4SzRKVG00Y3ZjRm1GVnRKdnk0Q0dNVm5Z?=
 =?utf-8?B?dlM0U1Jld1oyQzdyUFlCVTBVRW9zM293V09EYzdCVXdpZzR3OEdIQ0VMV0NG?=
 =?utf-8?B?OHhON1g4UzM5V3NtZVBmMTVDTzlWSkFhZGQvOFFtaFJFbzIzZmpobmRRMW4v?=
 =?utf-8?B?SmNoTzBpMW5lSEZFczFQR2ZFY2JsVVVaaHpJdHFEMFdKRHpVUXVJT1VOalpm?=
 =?utf-8?B?anJYV0MxT25MK3UxRjhEZmxTWkMzVUUrVkl5eWgxMkw0VXhKTWpIODJzQlNr?=
 =?utf-8?B?a1RVcFBneHVxL29uclEwc2pQZ1VneGI5MS85VE50K3JYbldoV3JCaEcwdVNn?=
 =?utf-8?B?TjVISjRpYXQ4SWV0Vi9mcmZGd2hBTGgzR3BUYkEyYStaakE4ditDYVd3Rkpu?=
 =?utf-8?B?ZHltM0FlRHJDTE1NWTkwckhOQUFFQklUektwaDlnTld4YjhnWXo2cldhRVY0?=
 =?utf-8?B?WDdsY1h0MUp4MWM1YzB6M2lxdUtoQlRlVVRrUjE4OE9MWjE0L29kVnd5NHN2?=
 =?utf-8?B?dy9EL0JXdC9wZzlFUHZnTVNzcmdzdFZ1WUFETkJMS0JmN05qQzFnMHlhWVQ3?=
 =?utf-8?B?NWxDdWVTUEJGNm1tY1lvYnJhUGVzcmRaTGxLbFZ6OUJXa28yYWNLWHVPU0VC?=
 =?utf-8?B?aHJwSWc1aWtrVzYwOFFpZUlycU1taGtJcGJMRkRTTzlpUmVkeG1ETEIranBW?=
 =?utf-8?B?dkM3WFFNZnU4Q0x1LzBUcnF5Vld6ckhZN2RSRHJFWUZQNjVjMVZOVS9KT3hr?=
 =?utf-8?B?T0ZWY2FLZlhhbGQ5aU1EbURoSkovNFdqQTNXekV2MEMySVhubjRRb2JnbEcy?=
 =?utf-8?B?TSsrMmcydmZSUGVtaGFMb2RHSUU0anBYMFZwWU1OcE1zZVFQRWUvUFBCd0li?=
 =?utf-8?B?ekNHdytBYktqYk44Q3IwMk52SUUvTDlKaVNzQklaa2JqU21tNzg1RHE3bkth?=
 =?utf-8?B?TjZ2RFo3bmhKenI5UjZhYWpZZGNPTCtNaXkrUHdvKzNiWmRtNGJHdUpZSnNr?=
 =?utf-8?B?Sjc4QS8vSDhUMTJlRTJkVmU1RWRrQnY1MlhyVGlFYThwN01RbE1uTjFWWXZO?=
 =?utf-8?B?UjVHaFUrNzJ1ajBHblRWbzZlUjFoUU1mSHRodTNSYUhHNFFKOUlMaDdSQ3cx?=
 =?utf-8?B?STJnSmRtR0x1TXhxcGQraXlhdFlSQ0lKUFpNSTBadTVpMDZTdzZPNlo5NVlk?=
 =?utf-8?B?cjBGWm0vbGhERWxJaURLeGZzdnAwYTNFa05Gb1VoU1NBVWtwOGNQejNreCtD?=
 =?utf-8?B?dVlqSFZuajJqODhEb2pnUWFUQkp5d1dCMzh1L2ZXeDRVbEJsSEtOdzBIcENS?=
 =?utf-8?B?c010Vk04c1dHVnVNSkx6a1NrZnFxOXNqMi9xODljTzJlRnl0dERzeVR1b1Yz?=
 =?utf-8?B?cFd5SkdaKzFvL25ja2RTaXBQUWduNjFkTGg5WFVJdVdwS2NBT0VrRmRrRTJi?=
 =?utf-8?B?LzRDRDB5MnFaSGc3WTRxWkEwUjZ6MkM0N3ZLZk1kY3ZHbFJRZVRrNnlHNU1Q?=
 =?utf-8?B?RTl4QVVsL3ZuMmx1K3V1cFcrdFBFdTNoUDk3UmlNUkkvWCtQVWNHSFFLRWJk?=
 =?utf-8?B?MU8zRzFZZHJHb2k0QXlJNDIvL0U0aTd0c2JXb2d6a1JKMUxiRy80T0QyOGdX?=
 =?utf-8?B?K3pJSmgyVURTSUl3dWtlYWg4WjV6YzdDcE1HbWJVeDRRTkxiRGZabGRweTBz?=
 =?utf-8?B?NjdPQTlWWjdQeDBoTU4yOStuOFgyYllMcCsyUXBBaFdHV3lPdll5dVB3Ymx2?=
 =?utf-8?B?eVROeGkrQU0rY2NJSjc0VDFobjlLOE80THVnTkRReWRMYmFUZ2w2SUlyN3FW?=
 =?utf-8?B?UGpMMzdkNjJHME5RVEJtckY2STlGejgyajkwUkFPQWJCLzZsRzJqVWtza3FI?=
 =?utf-8?B?R3Fxd1kvM3JqUVdvYkYvTVgwQThDZiswOW40MldnRVpBQklnbEFsRE1KbVZp?=
 =?utf-8?B?eWdLRmpmTFI4Z2x0Sk02eFVqZWpGcDJ3ZmFqdDhlRFUwY2R4ZDB3VjRZNU1Y?=
 =?utf-8?B?Rm9DSGx5SDYyYXZQb1R6M2JvdWttcGZlRnZ5WWpGdU1CYlRNRUQyTW5TM0c2?=
 =?utf-8?B?R05iVDB4c3ErWThYR0k0bGwwZmtNa3dMZ004ZnVvL081N0hjUmtnUkY5eG5D?=
 =?utf-8?Q?YPCcZvzckHaZAQgsAHOJI4U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6d5f2a4-7ff0-40d2-273b-08d999255917
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 08:39:53.9514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RPoBjkexeIQinXppghEErDtBE4zE5Wj2pdEYdDYyoR11LgbpHnwARO82MYOZfZTlajj3j6J4+4jNfDKbb163Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5534
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2021 17:27, Vladimir Oltean wrote:
> There are two places where a switchdev FDB entry is constructed, one is
> br_switchdev_fdb_notify() and the other is br_fdb_replay(). One uses a
> struct initializer, and the other declares the structure as
> uninitialized and populates the elements one by one.
> 
> One problem when introducing new members of struct
> switchdev_notifier_fdb_info is that there is a risk for one of these
> functions to run with an uninitialized value.
> 
> So centralize the logic of populating such structure into a dedicated
> function. Being the primary location where these structures are created,
> using an uninitialized variable and populating the members one by one
> should be fine, since this one function is supposed to assign values to
> all its members.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_switchdev.c | 41 +++++++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 19 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

