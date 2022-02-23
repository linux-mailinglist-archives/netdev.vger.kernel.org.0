Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F464C1FC1
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244836AbiBWXgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241997AbiBWXgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:36:06 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022F659A71
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 15:35:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewRMaYKHyze6vgJOf6ALMI7l0v7UsE+rRpezlzx+QTJD3j1QPeXRgAs/6rhHbynNEyXEhRSNNVeW5/EaG0joT+6zNucMf3UsBmrqEqsYbXprl44+CBI1CgkPV9ZJDTMW51+Plul0DTmg75U0t8tDut6YUGwtlEgeDsgxZREU+mWYabplnqLI8tMwhZ+2XuJXjdK4OabcGYKkspd95+UkL0oyUXglaUHGoVscsVmNzzYGjnvlGEJN2m4W9CdTTdAUszVprti6NBPYU1nNFG22qRgUNNph9FT30Kpas1s2cpDUxytvgdkQUlarZkn2T7i0BMntDH564kRuKqkRPnZWcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KAr9e4XcS1c/TnNQmiDyRlpB1a9A2uCbooYQpf1Krw=;
 b=drA9Z2RNTjMggdMTAUHGyKXBT3FqvbetsbDp61JsFANk0bVxA6tMZhnFS4JRzo4IeVaiGYy8hBCT92uterYbd1DDjbuoMB0MibANuyu8uHvnLv3WxV9BW1kJHAtOzBtjimus7jRBnNCeIE25fgt2ATuMlX+XJ3xWRaw6EF/eeVJOUwKn5e32WxXTk19cg4pKFtStw6miQqvcBQQNAdncirNuTpiXrZX/k2f2HnLJXwmKM0p8tjvsfeVrpp7JGcJWUeFtO9oDvn3/CNVp1UGQzKkrXs3hPJQWqtaYmg2APw6koTpgsFFYOhq6+K7a+sWoEpf7LUWiphViViLTsudJOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KAr9e4XcS1c/TnNQmiDyRlpB1a9A2uCbooYQpf1Krw=;
 b=RTVV4szTLwd7XwORa8/BIyTrtJGOxGbYSdeKUhZejSW4+2T1gEHiAe40le4Ia1eNfd03jCxqPISrcbZ29DcIsEtaFs3XirzI3/EFHlifZu6BX4JXc9hz6IwOE9eK5rxYJTKPhnCFVT87/eEoQ6kIohA1c+uRFm/XKsjrOjtUH7UWB7ASAsEcnDxZRgyoFap4+1T61bR3lNpVa5SSTXGrNXn1sBZp6xQ1wkj5YGXLdBjckqO4bUloMQWC7eTKpKakYq9zqbdEvaF9TwsvDwB3VWDQgUOYwkCXx+4AdGd2jpJS3PgaxMlrb/R/YZbGbAJvfJIf67WzV6aIpzqtot4l7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW2PR12MB2489.namprd12.prod.outlook.com (2603:10b6:907:d::25)
 by BL1PR12MB5271.namprd12.prod.outlook.com (2603:10b6:208:315::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 23:35:35 +0000
Received: from MW2PR12MB2489.namprd12.prod.outlook.com
 ([fe80::8b1:f0f0:ef1e:9918]) by MW2PR12MB2489.namprd12.prod.outlook.com
 ([fe80::8b1:f0f0:ef1e:9918%7]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 23:35:35 +0000
Message-ID: <5509c8e0-1689-783a-4052-85321fb7997e@nvidia.com>
Date:   Thu, 24 Feb 2022 01:35:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [net 04/19] net/mlx5: DR, Don't allow match on IP w/o matching on
 full ethertype/ip_version
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20220223170430.295595-1-saeed@kernel.org>
 <20220223170430.295595-5-saeed@kernel.org>
 <20220223152641.2bd501c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yevgeny Kliteynik <kliteyn@nvidia.com>
In-Reply-To: <20220223152641.2bd501c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM6PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::38) To MW2PR12MB2489.namprd12.prod.outlook.com
 (2603:10b6:907:d::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5abdcbfc-6747-4546-4c4f-08d9f72530a8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5271:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5271643B57A55B6FCDB3189CC03C9@BL1PR12MB5271.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zp9bYq4vsT5hgomPwlb7hE+CAq/hKkmHQt+i7lLEGC64sP629SNOCYJhY1Cn/u6guYQoDCNpzO4JvfIzw41jC2SbENoi1bjn3cJ3Go2uDaPVixh7/SOi2pipZcMPQagSwbFGqer7AY8+jnR7iISzoh9fcbgUT+eSeHZDlz6HLkmfap/f4G0k6F+7GaW41hya0Ht9oyNaVuCvgRHcQI6lgCCU03d3Xr22ehJuqxnMCiXplCmI9lTFlTRhk19CNjGGWTi+koiLADZqH3u527GoJVR61GLmJNK1AAGgRoTgx+hQUvrJRKeyZ2gf0T+NcY6j9pFChSklQ3XezL3xjLOoISeXoq4Rz38+FIpyZuHyT/ddDd2nZAzsfeManigL4wA6Z31tmDxuDQxbRDZaSG47ZOytf1nkzZF6wsCz8M7QY9vnlm1mWs5XRgI6qHZHYxXXOsoKlb3P9n1uXexr5+ZpVk2tO9S/pdk1TMcCHqZ0cV8UA86qVTU9nlCCvSqiBzd1/mONz4PfkIKzVmNJHqiF8JcCnfWYIV5A0NZoT4CdCP82EFy/XIaqeDwr3qpC7OxYQ0/bKbbZBKg59DUvEKK7/8FTZ/hPOc8vD2rvYgS/b8q079ln13KuK+mfJM5k2ZdAdr/WbjmnyaxU8gszAgCcdC+5EoxWwoQXaw8G9AVeRlZqMveT5GuEwqcC8W/HDEzvZun5UTdLfhJMBqi3JousgY/XmN+AYTujGU3UfXWpf8Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(66946007)(38100700002)(316002)(66476007)(66556008)(508600001)(54906003)(110136005)(6486002)(36756003)(31686004)(86362001)(31696002)(4326008)(6506007)(6666004)(186003)(26005)(2616005)(8936002)(2906002)(6512007)(5660300002)(107886003)(53546011)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anNMWVFXajF5aEswSkdoRFliNmxjZG5nck1IdkYwUWh0blVwRTI1QkRBRzVK?=
 =?utf-8?B?TnFpSWVGMTQwdm0xSmRUaVJGN3FpTjMzeVN5NGs2WFl6Qkhod2E4QUEvSmt4?=
 =?utf-8?B?dHJUa2UyTDc0SUF2d3VhTmRlZ29nQm1LdE14S0YrK3luMXR0K1hMNmJnN3BO?=
 =?utf-8?B?eUhOdUJ3YnlXOXlnYWNLWW5kdHBwU3FCQU4rVWgzSHFnZitnMGNVL3lVaHVR?=
 =?utf-8?B?Q1FYMnZ5QUFqOURtekhwN0pSK2p6bHUrNjNZZDZQREV0K09KZ0h2eVFzMEZu?=
 =?utf-8?B?RmJpQW9GTzkwSmtwdW5Zd2M3dTdlcnFrNWRpLzZDdW9wNXBVbnZLcmVmQVpu?=
 =?utf-8?B?blNPVmZqbU1PREk1bTg2OVpIZVhZVmtpTjhEWmtiN3c4Sm1VaUU3SW00Zm9h?=
 =?utf-8?B?ck05aVNCSk1QVHNON25UM2cyN0FLY0ZWcnZ5Skl6amxFK25yVmZ5ckRTMnpW?=
 =?utf-8?B?TWl0Q1NiYWxEM0lkeU9ud2ljVWJjRC92ZzhzM0ZUc005WGh1bisxcVVSWUhr?=
 =?utf-8?B?akZpQnRCNE1vbWtZTTZxVGhrRkY0Rjdrc0xNcUtrQ0ZuVlpKK3MvY2FocWRV?=
 =?utf-8?B?SWxVa0VWTzlsQ1pLOHR5ZnFVT1EyYVlhWFdMVGRiM3RjQWJMaVczcDZNQ1RD?=
 =?utf-8?B?ZC9PZEdVL0JpS2tFYjJWYVRPQjNTV29HbWc4cFE4U1NORmtjNHhEN2owNU1X?=
 =?utf-8?B?c2lLbzI5RFZuQzY2dlNYL1Z0L2hZMmZZOFVPMFFaTXdva09LVm9mR3ZqRHk4?=
 =?utf-8?B?SkRrWXhnRG1hWkVpQTc3eHRFZnZEL1BZOXQ5ZTlsbzQ1TEdncUNjU1ljeEdv?=
 =?utf-8?B?alFqWU8zbE1wMzVLZ0xweEwyd01KVUE1YXpIS1RxaHkxQ04zck9sd25UdE00?=
 =?utf-8?B?NldwQW1wWU9EQXVhbGNXYmE3blhTMG9pSW55eDhXb3lOamxlRDBWQnlXQW1u?=
 =?utf-8?B?OVFqaEE5eFFkLzM1bmN5U1F2cmVCSG9CUExLQU9hdmhDbzVSK1RTNUhIanhw?=
 =?utf-8?B?aWU4MWNPUHJudFIyZWh2NHFwT3puME94cTJOU2dOVndVSEM3V1UrS2duOTVK?=
 =?utf-8?B?YzBhYkNId0pzZnQ0dVNML2JKaGpiWU1sb21EaytMblJsWmNJemJjWWNBeEtT?=
 =?utf-8?B?bXdDcDRQMDVIbmEvOEtxdGFLVnZDU0JBTmR6QzNqVVNGYnVwUk5FUVdlLy9J?=
 =?utf-8?B?OVhUZkFDSVZTQjdHc0JWOEh3TVpyMW40R1NhRE1Ga0ZrSndEdlBLU1ZiekUw?=
 =?utf-8?B?L2JNNmY2enFneXNsSm54TTdpS1hBUUhUY0YwNW9QdGoyd2F3VjBMTkpEbmhm?=
 =?utf-8?B?VTcrcDRMVXhFcXYwblZDd2VMZUtnY21BV0l3a0Y4bzgzeGRPTVZraytnbGZT?=
 =?utf-8?B?TU5obFdCNjdHamxkZHA3VjVxTElIM2tCSEU2ZGdLcmx2c3R5elc0ampSR1cr?=
 =?utf-8?B?WXJrdGZycjB5aTdoY1EvdnNkSXQzK2NUdFNiWWtHeXRrVEtjNFV3SkJ6T0ht?=
 =?utf-8?B?VUpzTFVmM3hUQzJGMjB6N0h1TjZzRlRlQzBUeElQNkZ2dGJNSnoyVkpLNzFV?=
 =?utf-8?B?MWtYNVQ5NFU0K2s5cTBRTHNXckVwTEUreTVJQWhORkJXL3V5KzlrZHVCaXVa?=
 =?utf-8?B?OExibXV6aUp6WDZDazZrdzFBdnF6Q3VmbkJZdWhXZW4zbGlqVEVGWUllQUsw?=
 =?utf-8?B?TDY2dSt2WUdsOTJuQ2hhZVFIbzJFaytkSUJWM1VSNVdrcElLTDhJRmJBVmR2?=
 =?utf-8?B?ZFVRUm9sK2VheFF4TUNxdTZVdXd3aEhLWWc4aFk3WGFzMWVBdit5SUc3clI3?=
 =?utf-8?B?aFIyaVl3dTk0Vi9HVTYrRHN2SWtsTXM0Tit3NGFqQlkxMHNrSmFmTzBDbHNs?=
 =?utf-8?B?RGZzR2dCVWdVSStXbUxlWXVzMHdxeFBwaExmbWE2MVY1SDlscjJEdEx0cVp5?=
 =?utf-8?B?eHJhTzJoUUVMcDhtYmZEdjFSYTA4MUpVUkJRY0ZSaGcreXVPMllUS0lFU1Ra?=
 =?utf-8?B?UGdCQzdINVF3Sm9ZYmU1RHdIOTdsMWp2Q2J4VlRJNFZlNitLRHJDODh2T0ZX?=
 =?utf-8?B?b2RCZFNhUmtVRHl1Nld1bm4zcGJhN3hTVzVtTVlidElDK1Q0TGpPUHNuSHpy?=
 =?utf-8?B?QzNLOXhTUE9NTWpwbzJoZjFGdzNWakluaVhMdkhWdEdSWmFKTTBXWHZpMEZv?=
 =?utf-8?Q?yinV2lR/sIRD3+e4RFXnCDA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5abdcbfc-6747-4546-4c4f-08d9f72530a8
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 23:35:35.6353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3r4ogQJJts9jDwT35/tyGxU7VdUdvOT532estH4MU5QWfeLjS3H5U7DkNjyj9n8BC8d9IsoF9J6uAZx3vz06sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5271
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 24-Feb-22 01:26, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Wed, 23 Feb 2022 09:04:15 -0800 Saeed Mahameed wrote:
>> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>>
>> Currently SMFS allows adding rule with matching on src/dst IP w/o matching
>> on full ethertype or ip_version, which is not supported by HW.
>> This patch fixes this issue and adds the check as it is done in DMFS.
>>
>> Fixes: 26d688e33f88 ("net/mlx5: DR, Add Steering entry (STE) utilities")
>> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
>> Reviewed-by: Alex Vesker <valex@nvidia.com>
>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c:605:5: warning: symbol 'mlx5dr_ste_build_pre_check_spec' was not declared. Should it be static?
> drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c:605:5: warning: no previous prototype for ‘mlx5dr_ste_build_pre_check_spec’ [-Wmissing-prototypes]
>    605 | int mlx5dr_ste_build_pre_check_spec(struct mlx5dr_domain *dmn,
>        |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Thanks Jakub, will sent v2 shortly.

-- YK
