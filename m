Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4834F69502A
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 20:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjBMTBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 14:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjBMTAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 14:00:55 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0470E1BE9
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 11:00:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjjxOISJb4+zR2KXdwJY1wNfk83FgB738Zv+HajkPtESp+bcuAzaY+fUDnu2ITsVHgpJdg1szcnu/kzfb7TIpOl2Fdc4q8s6LAH/oIn2BesZ8FXSJ2jBzk5sOsnoGiuxo4AsiBnjgsf0dBit1gUtEpz68qfBJe575lWm+kmRECVNudmYpujw9qOUjOf9XdWnFQSZV+OcB0gsOM+fjYKVRHC6E7GiIYR9EYCknPfe1gLYxc4D9c+cQ22yYS5W8T4SquzNz9i96AJq1xRZvNjJmJL6hhIv/vui7ydWr003UCHqfP0/eRGnPyxr5K4xBcOd+SMaBSJSZ1R/BsxxsqDDzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FB4RH3sV4BrU1stVTgrdEyWwJMpGIIp7NgpJ//oMzAU=;
 b=AHYBPaH7+Wp//vGRki3imEhz8ZP0wrjfHLa1NTU2ppWMfT+3OH9X05DTNWz8i3bWWRh5GyMchDa+3h8CXj7bPgMxypldg1WMHgCPc/LwtXqRq4oACsJBrpQFAQ62yOntY0oLYgkcn6KMydTweeBiig55vzF/aPf3ctuN4i04raI9gII9BaZDYXYFRKm374h0nYBBNQw6buTVjnMLvm+VjixmneP87VOZaGQBSXaDOXpJ5bdWYrRCAUnYNevPRFgX5VnRBdhIzCytHV2QHtM1Hk+m1yK+6hSI7XLM4gbKLJQFV2CqXdXRk4QkXtG05+OP5MPAbJwp11ziUTXpTud+wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FB4RH3sV4BrU1stVTgrdEyWwJMpGIIp7NgpJ//oMzAU=;
 b=ZnAfn9aHQeoIiHZmGP2e7irfS9SEkVT1kqYxA0hNVsyyRZ8yYUrQOn9lPoG+zKxSBwprM6lfu/CXWNn0tETF3epcaJNY45rQDYH5SYJGxCjmUPR0hOqaHFZrAW/mY0stun2UC25oySw4ORggudNvrjbtCtdLyUk/z7nSzHbFqpHVibAt0KqQU/WYb9Lqm1a6BmzxUfojFIAwMH04UWQddNLRg2U4E3SbSdK3CgpaLvuuokmhcOKmNTyFhOd+Enucm2t2rnYhVZDdh8DPvpddgXyHw5UZh8bK2BlhDBaPh7+iPSAln3/Yh6i9BKJ5oNVtNPK8zDFqvLGHc5oRml8Z3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN9PR12MB5258.namprd12.prod.outlook.com (2603:10b6:408:11f::20)
 by DS7PR12MB8369.namprd12.prod.outlook.com (2603:10b6:8:eb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Mon, 13 Feb
 2023 19:00:22 +0000
Received: from BN9PR12MB5258.namprd12.prod.outlook.com
 ([fe80::75a7:9c68:f95f:9fff]) by BN9PR12MB5258.namprd12.prod.outlook.com
 ([fe80::75a7:9c68:f95f:9fff%8]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 19:00:22 +0000
Message-ID: <db85436e-67a3-4236-dcb5-590cf3c9eafa@nvidia.com>
Date:   Mon, 13 Feb 2023 21:00:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 01/15] net/mlx5: Lag, Let user configure multiport
 eswitch
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
References: <20230210221821.271571-1-saeed@kernel.org>
 <20230210221821.271571-2-saeed@kernel.org>
 <20230210200329.604e485e@kernel.org>
From:   Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20230210200329.604e485e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0232.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::14) To BN9PR12MB5258.namprd12.prod.outlook.com
 (2603:10b6:408:11f::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5258:EE_|DS7PR12MB8369:EE_
X-MS-Office365-Filtering-Correlation-Id: 6eb736d1-31d1-4d78-08d4-08db0df48ef5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xokounj9aNb2zUh3bI9PDsrLzEDfMURXhxT+XzKaoedxmMaPyGlVWYoO/XGMnf6eODvdGx5Bj5wrZuFyNaPhSAcdS88ze1DEsGYTRsqkL1KNgonQ7LfXbfpkZ4btI61Pa24rOrHOI9KwkUSuMezeL0upu3PhkiX7WKq9lKdX4DX8PwUxRl7N6Op0SlxTSU1MkquyxchijezxvCe/ipOAjcnJE+5Sg2Ng2jZMtmf4YQ8Ff7S+MZq3ZT6rAccZlkMoecBqMW68JAGJoJ800ZvfIKsF/aJJ7Nau1bIMKZiSU4HLJcMOf1hFgw620WizKoZ4IbQFz4b9FeBuC+ti7bmshBm2+cfEiHMBWKl8UiG+O88sx8KKggAnudPTPZe28GkvqqISYBNOkpMRXQwQZmFp2IuyYmiPXivv5AGazzL5DfuMDO07aEtheVNhK17nPWMLPFpcKgTRkPrTY07StSUfsFjjZ6ZEMCHYSDEsSAMjKzu1GN5MXdsB5PrfVkV82qdUU1CmPISQyXZus+STwD/GeTu9GS+22Cls0bBzqbYR1WHwr52ecCwaWoZr0b/G6WcFVfw53FWLs6G4c1eCafkTcVqLBIfcMgcFi2fc6RTky9dpeq4SkzcEi7qN2ruLgRqORDGMVJ15HXIt5hnJidZbcTblyXW2m+GIEoESptpapWj95RDQErLIVcW3msp79myr9sJnOjv8q+px9e7+Y/leM1fYNhHG8zLAT+/w9CaRDL4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5258.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199018)(38100700002)(8936002)(2906002)(31696002)(66556008)(66476007)(66946007)(4326008)(8676002)(5660300002)(31686004)(36756003)(41300700001)(107886003)(110136005)(66899018)(53546011)(86362001)(478600001)(54906003)(26005)(6486002)(2616005)(186003)(6666004)(6512007)(6506007)(83380400001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEtIZVhkWk56WWpTNURLMDVTVkJKUXZUaGt2bXdxN3BNNFJLdFJseWtYNGdi?=
 =?utf-8?B?ZytrdW1rNHJUaG1UMk9uNVhzVVlZYmsreXBwUllKZU9pekVjQyt0OWF0MmZQ?=
 =?utf-8?B?RmFIejQxTVhZcjlNOU96cHBTY1J1QlFRc0NwekpHQlJJT0lacy9xQnV5amd4?=
 =?utf-8?B?aGd2NCt0NG53Uk0rRjQ5b05zNHhYRWNqbjJFNEMvMWtOenVIL1JvMkhIbkNN?=
 =?utf-8?B?STBkc2lvRVpHZWRkSmpQQTBPVm16emhteGE0Tkk5azUzWGl0Mm1FelJ4bkdJ?=
 =?utf-8?B?ckxpd0FFNWZoR0V4VU5IcVVDZEVIYnNTMVFxb0NIUWlvVzhwZ1VSdEs0MnVY?=
 =?utf-8?B?RU5Lci9jYlZyQ3REemU5L0xXby9hZWdXa0JtbkFEWXk0Z2x4d0NOVm5zdk1W?=
 =?utf-8?B?TGg0WFp3ZEFBbzVsT2pMenlmRnpRb1hVblJEdW5lT3oxdnIxZGZ4cnVyQnVI?=
 =?utf-8?B?VzU3eEljWGhSR1lZczZIZG93RmlUS2NyQzFBNEg2cjh3cEx6OTQ4R0RNVm5I?=
 =?utf-8?B?SDNoZGJBVDhnNUpnSjlnczRjYXZaM29oZGw0SXczOFlLUE5lZGVubXl4RHBz?=
 =?utf-8?B?WTFRYVFvMTg0SWFyTTUxRWJ5bXBqMnNPN1hVS0dPcndjQmNYSEJ0eXhRVUVO?=
 =?utf-8?B?U3B2VVdWWHdKTm1tN3NCajVFOWdrczhBdlczOTJiZ0NZN2J4cUUzUGRTSFFZ?=
 =?utf-8?B?dStMa0dWeU5aSjRxb2RFMTdjbFlSVFlBVnRsMUZML3M5SjRaL2F0QkFKbDJM?=
 =?utf-8?B?Nk0ydHZNVzk4VFlaLyszT1dFTjJNbGNiR1RIMlcyQnpiYVNhQkFFSEY1YVhz?=
 =?utf-8?B?YnZGUlpFYllJbWFSMjZ2RXUxRkpMcDJDL3J1cGlOSE1ZcWFFaG1IZjBHZXdH?=
 =?utf-8?B?NHo0TlZuSW1WbmZSU1pnVko2aXJDbU41Q0RENlR2amhpODltc21uM0RqamdI?=
 =?utf-8?B?djBZK1gvVGVrR1RUVElQN3N0UlFkQVVUYm1nR2NEOEFOTDBiL1RuVHgwdGlG?=
 =?utf-8?B?WkU5OEZ2bmh3WGlKd3o1ajlSMmhZZ3ZwbGNRVnZEWHZaaUlJR0ZGSHRKWXl6?=
 =?utf-8?B?TFBGdDIyVlF0QmloWFN0bXN0YUxzZTRvTnRPK2NnOXFSK3ZieTBadDhzbjk1?=
 =?utf-8?B?TmIrckw3WmJMcmZyRWcxeElkZkp4c2orODdjWStSbVVMZHl2UzQ5eTRwdy96?=
 =?utf-8?B?TGFFSDVRZlZPMjF6NU1uNlF6dkJERVpPNTFLL25pVXhzdldqMk9rREsrNlRL?=
 =?utf-8?B?bGlvNnMxdTZ0NlhIajBFTDF6cy9vOUR4TWMvcHQzbnRFYzYybEZZbGxMYUNa?=
 =?utf-8?B?dmZ4NVdha05MZTlRK1YwZmxrdmFGdVFURFZDZDJINE16Q0VQMkVHRFpyWC85?=
 =?utf-8?B?RU12Si92QzlVSjEzTFZqSFRsS1c2OWV1NEV6ZG1wemQzb3p1TmVTZWd3R1p1?=
 =?utf-8?B?UHBTOUpWYXhIbzBsbE1xMUdXMGpOTWFMYjV6ZWd2TEw3UXVxbVdmUzBmQnFY?=
 =?utf-8?B?Yk1ySXZSV2lvMHB6ajA4K0o0cnZXZjJjdk1kZ0ZSUzlQVnYzQ2hJcE5LZ2NE?=
 =?utf-8?B?NEtMclpXNVBncEk0M0ZvbEtOblNKYmRFZE82VnNieDA3bW1rYU92Yjc4MkJ3?=
 =?utf-8?B?c2tGZHJHSjVRNk90WVh5cG5Ra0M1bk9VNEdBSjRZdFZTMUt1cTdwczIxcW9B?=
 =?utf-8?B?bEtEdUZlbDlyQThIbEQ2UEF0WjMzWThJVklsUHBhQkZ0Q3lldVpZQzhveElJ?=
 =?utf-8?B?QTdubFdXWEVZRGxvTTU0VnhLaDhXbS9XM2ZYQis2N0ZuUFlJVlU1OXBLTlpG?=
 =?utf-8?B?QWRmWFdoQ1M3c250RC9XY1ZnWDJWamZqck8xcU1sR0lEaXZxRlhNNjlWSXNU?=
 =?utf-8?B?YmVBd3hmclpZZnNnbnNPdTBEbWhLbCsvNjFiV3lzcHZFekJXSzNwUXNRZDJO?=
 =?utf-8?B?WWxETkpYSitMNFJmUkJsbGsrRjRtOXZKcGJXNFRMcHlOOEFsVXV4Q2s3OW5u?=
 =?utf-8?B?TkRsaEN6V282QWpQSkhIYkprdEliS1E0Ym0wOVQ4cG1WVTc5am1CTFVNTERL?=
 =?utf-8?B?MXFUY0xGNk0zaHhpL1Q3Z1lKYy8wZXM4NlZKLzRGSm16SG1MYllpRXkyUklJ?=
 =?utf-8?Q?/FAhVsjokJSEFtGrJH63kULJf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eb736d1-31d1-4d78-08d4-08db0df48ef5
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5258.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 19:00:22.7942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0iLh4zo6Tbk/asIUL4MKxZ4cdAsr75fpxluPyGkzxxV7wagTio4AglTzBSX6dNCJ1vkXa4260XRGHzz3t3nW5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8369
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/02/2023 6:03, Jakub Kicinski wrote:
> On Fri, 10 Feb 2023 14:18:07 -0800 Saeed Mahameed wrote:
>> From: Roi Dayan <roid@nvidia.com>
>>
>> Instead of activating multiport eswitch dynamically through
>> adding a TC rule and meeting certain conditions, allow the user
>> to activate it through devlink.
>> This will remove the forced requirement of using TC.
>> e.g. Bridge offload.
>>
>> Example:
>>     $ devlink dev param set pci/0000:00:0b.0 name esw_multiport value 1 \
>>                   cmode runtime
> 
> The PR message has way better description of what's going on here.
> 
>> +   * - ``esw_multiport``
>> +     - Boolean
>> +     - runtime
>> +     - Set the E-Switch lag mode to multiport.
> 
> This is just spelling out the name, not real documentation :(
> 
> IIUC the new mode is how devices _should_ work in switchdev mode,
> so why not make this the default already? What's the cut-off point?

Hi Jakub,

I agree with you this definitely should be the default. That was
the plan in the beginning. Testing uncovered that making it the default
breaks users. It changes the look and feel of the driver when in switchdev
mode, the customers we've talked with are very afraid
it will break their software and actually, we've seen real breakages
and I fully expect more to pop up once this feature goes live.

We've started reaching out to customers and working with them on updating
their software but such a change takes time and honestly, we would like to
push this change out as soon as possible and start building
on top of this new mode. Once more features that are only possible in this
new mode are added it will be an even bigger incentive to move to it.

We believe this parameter will allow customers to transition to the new
mode faster as we know this is a big change, let's start the transition
as soon as possible as we know delaying it will only make things worse.
Add a flag so we can control it and in the future, once all the software
is updated switch the flag to be the default and keep it for legacy
software where updating the logic isn't possible.

I've been dealing with LAG / E-Switch code for the past few years, which is
a very big pain for me. I would like to move forward and have a software
model that makes sense and simplifies the logic inside mlx5 and this is the
best way we have right now.
