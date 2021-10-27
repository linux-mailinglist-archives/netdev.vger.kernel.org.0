Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6202443C53E
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbhJ0IfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:35:13 -0400
Received: from mail-mw2nam10on2066.outbound.protection.outlook.com ([40.107.94.66]:7393
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233389AbhJ0IfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 04:35:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNPCfTxMkW2za74QvefxH1m0aMi0cbyspY0VdvkPPv7qiG7KCw2yP0LYHKLdyanqlxhSJ7frR+umbk7PDoNwy/DF33SvUlksqgK4Oy+rTloKz/SrFFJC48MpJ25I4gPSaDO4IHRqvv/CIb1MwrQlTXoFukMlfbgn0E36MVO1BFwGclgI+djH0SZu63HjNJChdQd35RHDJO45G0eWK0YGfC6W/6VuqslyeoqAtfdsdFx972Bwyc66NyPA8yGD3BUmuU2+v/Mwgslf5/R3LsUoH72kIC+PoxGwxFM2ZlIMxiCG2dWpYifFzAaKOY0nC+Q2Ctkb5panNIOjvsFanY8gXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+tJbcxT5uRDTqAYLlo6ha0jPJtETk1Rptbo7U7FF1OU=;
 b=BuudCQaEfeE6C9iBoimGjZ+Euoqz9W5mwiFUM5WHFeA4UuOGrnbV44EXCS0BRor/UMR5jpZ1knaFtUBzZxPhdsQCx6pkIBv3/kMe8XXE3mS2asLcOEWJ+E/5rOKQZARzddRf7BTezQpGHLVe2IkLWmlkh09plIHaGQYdafTx9AExRMnEue85oZ2ovxRlaT31lUfVgG5IkxbfsssImcFvSGPLNzIulKp5dltr0EAZfY1J3jmGmEiHpTXTiDJPrcGkl/AXUrlVbTgTzEkZlcrqeuvr/mPxHnFs5q/R3+C1ZZNaKQ9lEodWUYC51AaTVBBjFMGXz7ie8JaZhjjtZD9Q1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tJbcxT5uRDTqAYLlo6ha0jPJtETk1Rptbo7U7FF1OU=;
 b=Vyl7oFHGZW+mMhraERbPNE07vujsOOGWUjkKk8oIAe02hBQTSjiC08VVYohR/rZgW1z27xSTsR/uphi3YiFf5S3YhjJpmFqMbobtiZ/oti+LTKlqVKV3wZWJlGZEPvyKwm1LbHz/aWLedM3ADDPaq1+B3JthJfZIY3xqhl3nvYPiLEDd9twHbTLkfVy0JjE/piIieK/tQ1u4ixaL4uFGBUzQYbNxpJnhqsIRLNH7W6HqobKZBgha1WQtkpWOvGczVCezQ0hb+oc1fYP8L0O+eu0uNn4VgHL63YNXMzoDFQQ/p79ZGp/DLYKNV3+nbVCNxm/b/0Fknxvdd/30ps5mgw==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 08:32:46 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 08:32:46 +0000
Message-ID: <1ba35739-127d-e6b2-7121-91ea98a77ce9@nvidia.com>
Date:   Wed, 27 Oct 2021 11:32:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 5/8] net: bridge: reduce indentation level in
 fdb_create
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
 <20211026142743.1298877-6-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211026142743.1298877-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P191CA0072.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:7f::49) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by AM6P191CA0072.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:7f::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Wed, 27 Oct 2021 08:32:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d7f486c-fe89-4d1b-52e0-08d999245a21
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:
X-Microsoft-Antispam-PRVS: <DM4PR12MB50400DFB9D72189DBF1CCBD6DF859@DM4PR12MB5040.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GmB9u8NyZPz+RSBJbxk+yQ53I/WslZbRGebliVt0XN5vBOzEI6xtdzwL1wbeCI7bTB3XqpPZX6hqA9N/M1GZHfQihatOAUQUFHcOo+56bu6iGr+yGxE0TBsoxPVilZ86OqqaCCR4pJJz4tKGtdSVaP5IaROUHEifS+DhB68SKa7s0Jxal9GlMgmf9pPxQltdDzKm/XH0mn9uBcEnZ97bSfSViW/dNtjJ0rLpb9QB4HJ+mDB+7UHtnKtLfNmW1b5A5/5OdK301duPgDt6qL+CO6CzxZnjlsK/AtIdj0rhLMYB9hJZcdr2ZlD6FZI/NE3/kFyuw+u74ARWYWeB8667Sbo84+i30dU71Rqz2Xbm3BboEId1UHMRbEcwt2Eph0CYyYBKI1rKnytF+zmAx88KgZXUoHB4Ipw/YknU8RZwZOhiWtzsxC/iR04+5a7gdf6ZpHFjgnPQK/zS32li053yE9n8StpPxoazMJG5gXtb9QeSFe2IEzcfcFjiuLLiB0cFQ0MupkewMBR14260ND3QbSlq787r9TuvP049usPx6guNpr+hkIN9VZ6+F3p/D8//CEuRi8QKfLysBQyZxo3YlSh5EJeJuZWTro5dhB3O16YdGMy22jgYPAxeq9bgpsR3nGydJUMRAsv20Zfv3tbcLlv4M0u2WL9dKUyXmueDPrS8eL0B7N3u8Q5M+twXCod1OCMlWV1A5KychKxGy2M1yKoNCt5+kxbkCSmqD4La4yc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(53546011)(86362001)(31696002)(107886003)(8936002)(4326008)(66556008)(2906002)(66476007)(66946007)(26005)(186003)(4744005)(83380400001)(6486002)(31686004)(38100700002)(6636002)(508600001)(16576012)(36756003)(316002)(6666004)(54906003)(956004)(2616005)(110136005)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTgyTHVXbGwydklNalpWa3FCUzdhdHRJWlYxUHptM3Eya3E2QnRPanFMZ25a?=
 =?utf-8?B?aXNXcXEvMnNZSDJ6UlhpQmVhT1N6LzBWYWRjRnFwUUVORW9WMlpkcG04amt3?=
 =?utf-8?B?eHU5QXNXU0xyazN2TnVEVkp1UG5HTUtlSCtVdjJEZ2Zxd1h2R25Hdnk2aURj?=
 =?utf-8?B?NWlTOThEMUlGS0tEL1hPK0dOK0N6Y3d6WDNVMk84OFhONFdXV3VYcTV5V1Zr?=
 =?utf-8?B?ek1MSFcySTJzZVlCODJ2azU2WEJzVXlCSDZVc2Nab3ZRNlBJZXlPVFRVT25T?=
 =?utf-8?B?YjEvaU1MMWNldFhyYkE4QjJPNEhWRHpTMCtSU0FTMDRYbTc3TlQ1cGhDUnZw?=
 =?utf-8?B?cXlzVk02V09sMjRoSEJyQ1BKZFU0SHZOdUZvNGQrdDdVaXFsSTdITFBTTHNi?=
 =?utf-8?B?UFFCYzJncWxIcmEyRFdFNDNvZ1JPQXVaSmpobkxpKzRBVzNqYTloWG9wMW5K?=
 =?utf-8?B?MXl1WEhRUnh4aFpXbmdiTUhnTEpjVXpyckcxRXlxZ0RhbDU1SzNvelNyOHNL?=
 =?utf-8?B?L0p4UWNXL05QM0xyVmVNdUNFNGczUUx5SkFRaUYzc1lVK3dsdEtSVHgyejFi?=
 =?utf-8?B?dGUzQjJqKzQ2eVROS1A5a1BIckwvcUY1UHo3dHpSL29OY1FkbHpERXRNRmkr?=
 =?utf-8?B?aEJZVWJIb1BDU1p3TjFHZXpXaEtNV0xLb0c1ektDbFIva0tGSjMyZlVwQUFn?=
 =?utf-8?B?UVlReGZnUWwwaHJDdTV4N0ltQWdNWGdIc2huVm40bGhlU3NVZU8yb1liQTJm?=
 =?utf-8?B?TlMyWHRLanI4LzRBSVhrM0ZRaDl1TnY5SE9MWEZqZWZXcXZXNDVwYUhDYXNr?=
 =?utf-8?B?UVN0S3p4WGlVQXpMQndCd1JDbEtmcytoK21tVm9mV0xQWUFsaUgxenpvUXdY?=
 =?utf-8?B?RjRJOVE3Wlo4Ung0Rlkxd3VRKzdpYU1xZVlMSk9BNlNXcEI2ZVpteSsrMEln?=
 =?utf-8?B?U3RYSi8wc1pqS3NDbEFsUXp1YkNoNHdreVAxRUZtRjlNM1hVelpLa2F1SWJZ?=
 =?utf-8?B?c3Q2dU9iek83K0pwVDEycTFIY1Y1ajFBSjgwTzNOeXVRWjlBT2NUUVlZU250?=
 =?utf-8?B?aDhaZVdzQ0dwMXVXbmJIeG1CeXVQK1ptRTZwdnVqTTZLcnovYnVKSExZQ1Vk?=
 =?utf-8?B?emYwekVMZHlYRXl3amluQkVmSnRVNExpMlRMTjV2OHpwV1djQ1J4VG9QNERx?=
 =?utf-8?B?ZlZYTTNXWDR0UWpPUGI1SGRXYzJBSXYrdG1IcHorYnBObnFzeUFDakU1RS9q?=
 =?utf-8?B?M21tTFJkRm5mcGQyMlkybjJNU0dtejVkZzBiZUN0TUhPbmJhamZjR3VrRkYx?=
 =?utf-8?B?cmltalpKOXlENzB5V2pQQXJ0elBNWkVMaEJINmozMkVaVVA0c1VQSHZPeUpO?=
 =?utf-8?B?ZElqempXd3FYQ3RCK3gvVVlBNzZoNnpuTTdmblVSZ05wQ3BMVTF1YWI4UkRW?=
 =?utf-8?B?VXpTZ0FjUE9BYUFEbjdHVFZ5cU4vSmNjNklORU9SYmptN2tWNDZ3UkpUMXhy?=
 =?utf-8?B?Zmw0cmpFZEtVM1kxVFk3VUd2aG1wYVRtS3JiZzFPQ0kzdy93NkI0UUlpTDhJ?=
 =?utf-8?B?anpURnJPY0lZeUtJd0hpUDliNTVRdGRNNTF2VktySW1yMGQ5N0pqYkR6U09W?=
 =?utf-8?B?UER2S0ZKeXhjY1hnaTRpQjJiQ2o1SEJqN1ZmS1FsYW5aOWw4SDF1R25lMGVp?=
 =?utf-8?B?QjV0RDNoRHl1TkJOWmdBWHI1R3VrdGwyR0MyTG9WQmc4dHpMakRPd1ZpeHRx?=
 =?utf-8?B?TjNmSHdiYXR2SnJoNDZsQ3JYd003QktDenMwRGx0WG91NDZHT0tQU1lJbzVx?=
 =?utf-8?B?Z1lYUVJDK1BWWWFWakFqMFl2ejU4TmkyY3JycCtKT2hFUEJLS3Z6SDdEakFT?=
 =?utf-8?B?OFY4ZndqQmEyajZTMVg4UkpPdHdzTEZINnBZWDA0YXNTQUk0cnlYUnNkZ2RT?=
 =?utf-8?B?YkFCaEpFK1NTK3I5SDgzanZLTGpKTVJDSlNzUktwcFZDc1Q0dEhoUXA5UFZU?=
 =?utf-8?B?V2k5RTZDcmlnVjVPVktuWk1hYmtWOUVzME1kNXRxbjlsc0sxY0ZmcFdWTFhK?=
 =?utf-8?B?bnBBWUIxOUVBelVEbmJCZDVFYi93QTZHM2RnVDFVUmxRc0ZUZ0dNa3NtUVJw?=
 =?utf-8?B?bWcvMUMyV29WSFQ4ck1rbEtKMmFlM1gvbjM3anZqVUVKc29qSGQxRlR5dnVE?=
 =?utf-8?Q?CiYwPNE+oVY9imO2zSTFqEg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d7f486c-fe89-4d1b-52e0-08d999245a21
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 08:32:46.2289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hV72evTpLIFI8LFrho4Refw1lfoa2WoJJrfrEE1ODV5DrkXkIwDIO4YVwxbV/pYkK4RZ0y5sv8bbytHNAKgyDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2021 17:27, Vladimir Oltean wrote:
> We can express the same logic without an "if" condition as big as the
> function, just return early if the kmem_cache_alloc() call fails.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_fdb.c | 31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


