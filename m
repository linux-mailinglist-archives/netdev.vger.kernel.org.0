Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC60643C538
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239211AbhJ0IeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:34:24 -0400
Received: from mail-co1nam11on2052.outbound.protection.outlook.com ([40.107.220.52]:62208
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240957AbhJ0IeP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 04:34:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDD8l72pvoGUJ8he6O52BaRaD76OVYlyVXkZZyktEWoAofA6VzeR9rKDViXV0g3NskPbdnLqCAlo2rXgb9HkOnKrm8CAKWDCQrMXlpHZZ83jSe0wnKx0HrzSISmdmuqoCccMD0GcTRDQPn08cB7fF4aanR5kaKcCk0lwHB4KvBdlbs/97WmEVGmkXtHXXuJCqbqf78nfEjSh+pNKQoP3EwLEsiwQWt8kP1CXVC8jFqACS7FveNMMpcb6gnqeGDaUIbhB2U4xhQDBB7DlqKbchwRXiOxxQrupMW2HijjMgXyx8MQoehS4/n09Gut/JFX/XudkkL+VuRFG7g2i5oO0ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=APHqCF8J7zWwLSOZO/CU5YLopZLySlaQn2Ldq+Sezoo=;
 b=Vuw+0vkmmTOubQi9pbVx+aQ9kTEnGT3yR8kGtQOxZhEQ0CJRb5eT+cxpnZvlWeNqc317kS65jU1oa97xue9ZSCcRAsB05nS+RTJ5QB9oSmuN4AiWUlNNwATcd+mO6Huv/iPIRuTb3JCL25YwocGjezt6cwfhS5fg7I7tFpIPkqmOfHdIw1/02KTlGWs9xXlr643to0PCVPwgRX99nj+52JWNEVbjbqgb/cnIbWAlplvMG3VWYvbVZB9L5RslJF0TizMbUe/1twhStBweDuReEi3qA+vJxbmQuCRvk+d+oPolQu6MumdpUUtpNHEyeb+3PTr4gyGdWPLQH1v2EFWkVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APHqCF8J7zWwLSOZO/CU5YLopZLySlaQn2Ldq+Sezoo=;
 b=h+wtzuthf0rv76UeDzYEIRFYIysfOalg/4C4V98BhDeMP11vcCNxSon8/411SfZW4AnoWK0bym/gstyDKBqnS7EDFDOuQMKGgd9SOgwihhFYGA59sWu3JZp7lMwsOqo47luiKGUlUTfV0gyTWY3j2l3dCz9keyiH1uNV+e4uRUUEhEmxIykGXTWQbyxt29x/oLElbBIa33z9sXUExlSkxKkB+8uzI8c1GFUwvb7rKN/GjH5q2GMLg/4i+ppx0eQ0UzAyFN7ZUExe40fGsSZLfURxayZosw6m/D36Z3fRJrzdZCQa4ejQKp9jaLmVZDqxZg++uOqnfTi57QwTiBidLg==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 08:31:49 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 08:31:49 +0000
Message-ID: <37979ff6-be58-6f7b-a263-4a28cb24f06b@nvidia.com>
Date:   Wed, 27 Oct 2021 11:31:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 3/8] net: bridge: rename fdb_insert to
 fdb_add_local
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
 <20211026142743.1298877-4-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211026142743.1298877-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P191CA0051.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:7f::28) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by AM6P191CA0051.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:7f::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Wed, 27 Oct 2021 08:31:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f70fee45-ed4e-4d8c-5464-08d99924386f
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:
X-Microsoft-Antispam-PRVS: <DM4PR12MB50408F3E0655B32DEEDFC581DF859@DM4PR12MB5040.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V/EsNSdYopQPKeya2zij3xSvnwd9owLyaZfTRz1EdocTwsk6QGjM4NrXl134A2Z6VJWQKtAAxr6eDR9MJxRiWzkrnUh5s56EStaRiRsZLlUJZMROW+iv+PpFvum/pYk/9LvwudQzUC8rKb76QfJYoi9ks1N9cFWIlFtXv8UGN8naVHZ7aTrSkAMvwRDfRzHo7RzoemkFfsqH2o6ViLGBg9tW6XZO/12/2ku8jbWegdF6PHp2+r6k18pAraO/tqehmEERUHWXMd1NnoTNCnRFbvZd+3HjFA0l6blw6oRLBTGxCIfRcDvYMCkz3TFii1UF50xe4sOgfruRSrys52jUrKWEzU6Jz2nE673DIivhfOXwB3v3AZNS11eBeR1Q/G89VYv9Kdefslj9Lk5MAcsGZLs+8Stembp6Z5DhX5g18Ttv2wGZBsp4H8Ku329+zmq2XuykWnNKmQTgti+FB5jLv7/PBmHOkd8fhSefaDn/LFBVGXvL1dM65OzzrMMj0rwMWjC1U77habgSFG1yduZzouDWIAinlTzbPPpIFhaq4mzxLMvYQx6+YQrdHV82P2T6keSiqbCnMJcnkuxMt5n0M62KiJN/lmpgpO3tgpBAV+Vy18Y/7usSK8vPo/Jr5bUd4yZrWJnE96Ys4EvvO7ewng2v2XevYwM0remE1CqT1QHzct0DPbCrfKT2msaHAKusHUduP73aFlYjF0lb/JG0caA8voJbFC5k5h5Z5fmUhqk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(53546011)(86362001)(31696002)(107886003)(8936002)(4326008)(66556008)(2906002)(66476007)(66946007)(26005)(186003)(4744005)(83380400001)(6486002)(31686004)(38100700002)(6636002)(508600001)(16576012)(36756003)(316002)(6666004)(54906003)(956004)(2616005)(110136005)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUVuenpNamVsWGNLMXhFeGl6NDRqc0FsTW1FRlFKNXJpQ1ZyaXNPS3N3L2I1?=
 =?utf-8?B?R0JGbnBEM21ZZzZyVDdSQ096WnBHUDdRR1ZuWWZiWUZ5V0JHdnhDRGV5dlYy?=
 =?utf-8?B?LzEvdTJGUDZXaHdRVkFYbSsreWpPa24yMUtRRmViMkRJSzVDdG5Eeld3cnFa?=
 =?utf-8?B?ZU9DUHpHbEJDbGlwVXhNeFN0Szh3UjhBMDUyWjMvRThYUDZjWTFTTFYvUVBP?=
 =?utf-8?B?UkcvS2hOZGtjQ0tYa1ROUXZUcXlKYWdNQjlKNjhoOTNLcWtDS0dJZkRYSUhW?=
 =?utf-8?B?M3lXU2dpMjdQbjUxRDBvcUxYZUhrZ0VxbTVqSS9IeEZEd0ZqcGxYdmcvaXY2?=
 =?utf-8?B?NGUwUnhYeTNTSUJYcnYwcENDUENoblFZRnpIeDlCNFNTZTJFWFVYWGR4a3RR?=
 =?utf-8?B?c2dpWStiMmE5WmdrZS9xanVQREZNYmIwdnlBSkM0dXBMdnJhZS9Oam1La3RF?=
 =?utf-8?B?OElQRWMxc0s2cmtjb1BIUGZMSm50dVBYTHZBcnl6c2VITGlYeWl1SjU1aHRZ?=
 =?utf-8?B?UUUyNjJSSTlKblVOWWFoWnQ3TlhxdjhqUjJQTmxtQ05TRk54dXM1eUNtSHJx?=
 =?utf-8?B?SGl5UXlrZi8zZmRrTjBXZ3pKNW0rZG9TVlplcnk1RmNNK0J3dTJseEZiNURW?=
 =?utf-8?B?elZUZkNSNlNqdE5WaHRvZEpMRGZDd0tiY0FIVXdqdHBGbDhJc2ppNWY4K3pi?=
 =?utf-8?B?M3g4UWZ2Z0U2V1ZhRXB5VEJoRXlxVEFZVXFXTThEQXJ2K2hBellnWjQyTnR6?=
 =?utf-8?B?MGFXTllIQ2VqMGdrRmlkd1VQZC9QTjBzQW9ESDc2eDlZeWxacGNNeHBEVko1?=
 =?utf-8?B?eHMzQ0FMTEJaSlU4YTdBQm1oWEYxaE5qT2V5cVorelpHN0huRk5aKzd1RmZM?=
 =?utf-8?B?R3l0RHBkd2RRMlhnRjZkeEh4SEJGak5xeEhkcjZUUm83TUJkQ1piWG5NNjFr?=
 =?utf-8?B?Skpnc0pXWXJsVjlLeEFEZHAxd3FmNTNNNXl5NVUyME9PWDhDQUtuSFgvSGpD?=
 =?utf-8?B?a0E1Tzc5NDNTSjk1cmtmRHFTOExzZ29qL2hQVzdSVHhIMUtXQW1GaS94Wi93?=
 =?utf-8?B?MnNnVXNweExQWUNnTkN6ek5TcmZwMi9xczRzWUhldFRwdk50K0t0ZmZjdTZI?=
 =?utf-8?B?UG1uaDdUZHVRODBoYlRybnh3WHNwQ29jNHdwcWV0Rzd6bzVnOE9QRnM3WlBC?=
 =?utf-8?B?VmttWGNzVDFxRnN4RlZjbExqTjVvaUltcnJxOC9Ob2NuSlI1Y2liSFN3WXVu?=
 =?utf-8?B?WVV4bDFlWXV6UjlnODdBa3dlWEFIRkpDeDBqMmFNbUlPWnBYajBiVmpUd1lp?=
 =?utf-8?B?OTJ3VTBWSUJuQzJIbDRFd29laVpBdUlrYUJDK1EvbjFvYVgrK0V1OEkyajRH?=
 =?utf-8?B?UkF3bjYyNzdhTGxkZGg0SUUzYTlrWml1U29ZYlVmS3dpT3RxbERyWnFRaldz?=
 =?utf-8?B?VFNvZ2RpbWNpTzduS0lnT0NlbndmanVXbFJPa1ErcVdPQUc4enVqM3VZTGxu?=
 =?utf-8?B?L045eHdvZThqbng2QndFL2ZEVFBIM2ZKNStYV2JQeFFOMHovNXErRHlFeW5O?=
 =?utf-8?B?d09Oc0t4TmVzUzN5OXg1eVpjdFptbC9UaXNxSUpHK21mZnNjcE8vRW5RS1dz?=
 =?utf-8?B?V0g3RERxNlNPVDBycG9wZmRZSWY1NnlmL0JuaHJ1M09EVnM5TEhnaCtrVnM0?=
 =?utf-8?B?MjBsSFAyUk9USEZVZEl5S3kyeVpEVnFTR3g5ZjltZVpEQUYrVWU1QTBBSUZ6?=
 =?utf-8?B?ejROZkNqdFFRaVRjbEpFUkdLcHBvdUZxUmNyeUgrNS9XSjhsbE1oNEROcGFY?=
 =?utf-8?B?VE80QjhiQ0VvSzhyTEhuVzdwTGR0V0NJOFVtWitNWkFqaHI4cHBYbHk0NHJj?=
 =?utf-8?B?aVQ3VDV2N2NScGZsSnJwNjIvUGRLb1g3SzJLdEF4UG10QU52b1dhL3NlQ0sv?=
 =?utf-8?B?VFZOZG0ydm42Y2xWRFVZY2VTKy9rWm53akJxZnFZMnYxb3ozb05MU0lpdGY4?=
 =?utf-8?B?ZXlQUTVKSVRPZU5OR3dacmJ6MmRaSTJ0eEhFL1NZdFRTVDV3R3ErVTVsNTN6?=
 =?utf-8?B?U0Z1S1JydmNrSWxTZzB4eEh6WVpYZGtKYTJuMlhEQ1NGeHp2QU5FQUhQQUhY?=
 =?utf-8?B?UFpiYVRSbHZFajk2RTVOZ2tVYnp5UWs0Rm5OMlM4Lyt0cUVJMFBHSmp2a01F?=
 =?utf-8?Q?tUxDzNERs7JsIl9k7SwKLlM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f70fee45-ed4e-4d8c-5464-08d99924386f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 08:31:49.6598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jrxkz0mbh4NCxvwNHJaCHQFU5IYvtSObAAAOnBzHp2jNvgfn3L2lOG9kyJgrK3SFX2a87uDY4l6eKJdAPOCyKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2021 17:27, Vladimir Oltean wrote:
> fdb_insert() is not a descriptive name for this function, and also easy
> to confuse with __br_fdb_add(), fdb_add_entry(), br_fdb_update().
> Even more confusingly, it is not even related in any way with those
> functions, neither one calls the other.
> 
> Since fdb_insert() basically deals with the creation of a BR_FDB_LOCAL
> entry and is called only from functions where that is the intention:
> 
> - br_fdb_changeaddr
> - br_fdb_change_mac_address
> - br_fdb_insert
> 
> then rename it to fdb_add_local(), because its removal counterpart is
> called fdb_delete_local().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_fdb.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 

Indeed, the naming was confusing.
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

