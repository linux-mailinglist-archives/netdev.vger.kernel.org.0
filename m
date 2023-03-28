Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38946CB727
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 08:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjC1G2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 02:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjC1G2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 02:28:11 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A9C2D41
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 23:27:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0Kb92KfxPalJlXzx5SHY8aZDff2h0bfgFffr7/mMW+I2PcwxPRiqRZZ+wmKW3noZbhqfdooqgSLhBePsVdVNZtXQqA2OgzMzi/8ydGWnPQ4kenjnSaB8L0nhiFSoBhyJObCYcrDsFTxS8x04SxtrRTL2WCcaBul30j3BLvotM4duaGn/ul5G5HcjdQxA6ZZSXxH2klhn3t+cq/SuMUGNKhoh80ATaxysCYdQB3JoUyT0IgX4EXmTVnB1ebrQnt5Hh8y1BkAgB/x54e0c4cE9LAIzw6dDZ3DZyxMefqLTyqYd7+Jo04dAKx0ayT5D4A/PB+sPTViWqP8F4PP7dEO1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfDdGesA+5QseV82Ha0yHFDNrNwOa8e0lnx/FOiXI/U=;
 b=XkTHqXqOJQfX8Io4v1SpBw/yUuVBTWkMSYUEYPuhMjLfo5BdKrCKTGlOP93Fjj8Z1wX7kCIj/ZuqrJOVthF+bYGhH060PUMVxD1/hyYwYOqR8M5l6C7QLTmCSe84rgpQYpCNOTuwOBQDg/rXod1tsEccguE7vk6NhYYLZ7KzyALmqXvWPqCdSUKH0j6pw43xQTHV6D49fqmQaLmhjsA/FW1LKo39XhWAQhMy2sDOuWHomW80OeMuYKbHhb0vCWchxQgTF73FdTF4WHYpgEeUhfOm8AUnMrmG8qHideUYYl89sdeyCCj8omy6L7TgtfDcrLPZYOI6b0vUm6UwuVAdmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfDdGesA+5QseV82Ha0yHFDNrNwOa8e0lnx/FOiXI/U=;
 b=cqD0P58Y0ZP8SjKnovQxG8gdAImWY6oLYdtOZTNW3LPbn/LzBy8pao3YuO7vSRjXrRjszoVBs92nD983Eo2lmVHk3RBMyafxGkqQZJiv6XVMvvdJLT3GI1KXT0KWHiI6HzeYBO9ckeFwkGB8iGxDaqf6eO+RZ7fmVMVQXTM7paoTY9bdTXG4AcWP4PmKmVvAj9SaIzhw4yS4H42R/rdFUY8O7U9lFwvSZZPiSlGDQ66ebpmvJxJPB5dr9c3hDMn2LC/etN3220+a6JuxaI+1rM6bLmhSUQcdhicbQLQvCYtPx0XGxYrIWcac95aGcdEQSEJZX8riFY+0jOuhmEK5NA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN9PR12MB5258.namprd12.prod.outlook.com (2603:10b6:408:11f::20)
 by PH8PR12MB6674.namprd12.prod.outlook.com (2603:10b6:510:1c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Tue, 28 Mar
 2023 06:27:51 +0000
Received: from BN9PR12MB5258.namprd12.prod.outlook.com
 ([fe80::dd0c:ecea:440e:e1a]) by BN9PR12MB5258.namprd12.prod.outlook.com
 ([fe80::dd0c:ecea:440e:e1a%5]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 06:27:51 +0000
Message-ID: <b880d6ef-fe6b-4b39-d023-b66efeae4fc8@nvidia.com>
Date:   Tue, 28 Mar 2023 09:27:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 net-next 2/2] 6lowpan: Remove redundant initialisation.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20230327235455.52990-1-kuniyu@amazon.com>
 <20230327235455.52990-3-kuniyu@amazon.com>
From:   Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20230327235455.52990-3-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0501.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::8) To BN9PR12MB5258.namprd12.prod.outlook.com
 (2603:10b6:408:11f::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5258:EE_|PH8PR12MB6674:EE_
X-MS-Office365-Filtering-Correlation-Id: 70f3e5b7-2eab-42fc-44df-08db2f558e58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: usILgrfwyQ3F/gHn4Qa0Bc/AXuegDrIfH0AvAqkZIe/l3qHqriA1DVzUbbArVhCSBL9WUycOXxqVnNpxpoL96p4dJww9KNpD7qL5nSTbBPkQh0QGYwl3XU1rg7Sf4LsgNjrZFFA7f9ue5Bd7EFCJhK5QLKmZcDEMhMdFk4YHjIFo4wWyOLGVAkBaiGHWyE9rr6BzFmnGWBfzfjlaW6qKQBNDp5eN9IMzzkn2Fh/6WBL67bMFYzlfBf9fx3pYP/ehLKfKzCsQBet5F211MKpSdHNlCkSG7tV3NuhH8pN1tj/pT3UoLRcAD+DAqYOT/Ofd/a2EqYikxeC78Pb3VZpmAyKleKHQTokDyJ4T6sfNi9Hqc2rLx8tlZ4nNz8N2LU1S37EM+i+kxpDVdeBCrLs+8VeJlOPUxB0ClquJos2eESQ1uprJbwjoEB43oAgfEQukFigZgpgsmz2zo4sjRTKgIKbMHKOhMMUTym8sLYohyExfK99GelCVWuBp9+wGj+JV0v9phrdSUyNpUf/oSQs+xMOK2fsxEDF+svZyEaUaBPGJXIkgltTM3Z50NOy9B/eRlcZaDH4yWJTmITnnkzZ46rDqhZnwsRucmyjbvL9O9aCvwlb+3xDVli80aES9y8uEbt6c9ZcoW7v8jA/i88MNAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5258.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199021)(26005)(186003)(6486002)(6512007)(316002)(53546011)(6506007)(8676002)(4326008)(66946007)(110136005)(66476007)(66556008)(41300700001)(31686004)(6666004)(478600001)(2616005)(8936002)(4744005)(5660300002)(2906002)(83380400001)(86362001)(38100700002)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2hwQjVYNXdMTjR1ZVdNdEZUK3R5MXdBN05PNVFpS2s3enA2bTgzcXo1UGU0?=
 =?utf-8?B?ZmNBM0owTmkxd2Z4dmtjTXFsVnBncEVGb3Z4TCtiYnBqVTd2ZjJheExGc09z?=
 =?utf-8?B?VHplVVdkWW54bnhueklSd3VKSmR6aHJaYUFqZ2hJd1dnUk1kL1RlTFpYbmpU?=
 =?utf-8?B?VFdkc3F2TTNNbGxieTNWTUd3Q2hRMytqdHRYalZVSjlPTkRRZXl0dmdIU053?=
 =?utf-8?B?LzVXVTJXWTN1SEw4aFlXV1JoWWFsT3hDZ3FlYTdKYVgva3pnZ1JmbGZpYzQz?=
 =?utf-8?B?ck0rY1JkRVpiV1BIbmdaeTZEQlprRmwzS3c3L2xjMDhvNHU5a3dwYXhKb0Qw?=
 =?utf-8?B?MEwxYnNmQzYxNmMxN3VMektIcHB5MWd1STFSK3dNR0FCMklRZjFxWDF1UXNS?=
 =?utf-8?B?b0hXWjNyRmd0aTJONW5KOWcwTjlyRVladER1amRXc0cxWCtBM0oydVo2NnVK?=
 =?utf-8?B?cGQ2UldhN0hrQUtrK2pDZGJwUWMwWURnTm0xcktYcFlONFJmbWFaUmdrV2xi?=
 =?utf-8?B?cDhnaTZQOUdlSFNOSDVZZTFSWGVwR2MyVFJOTjA0d3VSOWpQcWZieW5FOFRs?=
 =?utf-8?B?Sy9ZZVVBT1BZWi9USTM4bG4wR1duRUhhdDYySy9nS0FSMEROcnF1NHh6dzZS?=
 =?utf-8?B?cXp0WXMrMFYzck96cDJ5eWRLc0pZd1UrL1NSZFp4MkZCS1JZNFI3bDVQVk04?=
 =?utf-8?B?U0ZQQWY5RzRudTYrMXJkaHJtUGcyQ2RGTGwxeTlYWUl1Zk9XeXREZ2tqTDFs?=
 =?utf-8?B?NEtpMU1paXNVRmFhYVlpemVyUWJqSXNQRkt4VXAzZCthN1UxeitNRk4zUUhs?=
 =?utf-8?B?MTExQ1dCdVFNUStweE1OeUl0Y0xtOWZxcG5JTjZvVDNTREU4a2hpK1kweS9q?=
 =?utf-8?B?clptdzdnSG05SHpDeHQvU3U2UTZ3T1hqa3NrS0ZlM3lwQzhOQUFWVFpUT05J?=
 =?utf-8?B?TDFBQ3N5K3I5QWJDeGVLVzZqay8wbStWYzUzRzdkYTgwbk1DT09scDJqckhP?=
 =?utf-8?B?by84cFlJSFdyTnE4a05aaUh5THBaTHhRUUtBTC9GTFhPa3JGbmRvQ0h5S0h5?=
 =?utf-8?B?VUNxZ2l4a3gvM0pHMTU0Rk9FUTVLdXJJT2IwNEVnTVBud2RVSkhMN0ZsUXNx?=
 =?utf-8?B?MGNrWTZwQnRobmdPSGp5dmw3ckdYdjc3RFlIKzFJRXBwL2VwZ2FWRWFhVU1X?=
 =?utf-8?B?cWFMaTJkVkRxdWVWUFFQU3NZWDcwSW84M1FrVnRiTUxQcCt0OXJTVHVkK2lD?=
 =?utf-8?B?Z3BhbG4vdDg5WGQyQWFFZ0JoZS9OZFBTNDNSWTZXcm1ZejY1RDRWS0ZxdnNU?=
 =?utf-8?B?WlNmWW1QR1hHOVV1dlNaK0lsdElOMFJ3N2JxM0FLaldLU2haWHpxdVJJVi9y?=
 =?utf-8?B?Z2k1UUtXVWFtZmJDbDRZNW5iUlAvU0RMVGhqN0ltM29YSWRrdW5Sb2xoK3p0?=
 =?utf-8?B?VStYRE9xcmVrdnMrcTVYcnlpb0ZvaFRYNGhJdGdCNDBiRHlaNEJVb3JiMmFl?=
 =?utf-8?B?N2lOYjQ5clBsZlBBQS9YcTVQTWxoNHZFR2FlUjIwYnVzckxUbFZRTkJDVHZ3?=
 =?utf-8?B?d1lVYlJWNHpnNFJzSDU4TWVIN1pTdHIzQWJXbytET3RhdUZ4S0pkRDJRakFK?=
 =?utf-8?B?S3Z3SWl2MmNYQTgyM3hONHJ2S1puUGw2QTZtQ3p3QjRhN0R2bGJZL0ZrOGtO?=
 =?utf-8?B?Z05jWEpDODZQT3RxOW9mbUt4YU9jTEx3eGhLSFNQWWQ3cFJGbGs0a2U5VFQ4?=
 =?utf-8?B?cmZON2xvTFdBVS8zVmhVRmpUZC80cWp3bllNRkFuRXdoNHhBYXFWODRCUXJ4?=
 =?utf-8?B?aHZmbHlyV1VVaC9Qd3pMbGhMQUdUd3laWnhjS0VXd01xMTJXTEpzSHhJME9Z?=
 =?utf-8?B?eW5CbHVld3pDSXkwcG11cG5oWjJpWHppWVNxd2p3TzZJbXEvMTlDOTJRNlFM?=
 =?utf-8?B?MGRIeGxSb0pnbnlJSXYzNUZWcyszZG1Mb0F5ZldkcjR0bWEwMEF6bFM2QXFw?=
 =?utf-8?B?b1Z3MkRPSm00QTVhVlBGcTEvVWNaZ2hxQ1lrTnZWcWJrMEhvRUtTc3VWaGh3?=
 =?utf-8?B?azBFTFd0elpxUEdDa21iTVRFeERhTnliL1BIVkJCbnJQb0Q5MEx1UGpUZmdN?=
 =?utf-8?Q?CsvywTcemX4SflsoXjPkmPpo0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70f3e5b7-2eab-42fc-44df-08db2f558e58
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5258.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 06:27:51.2142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z0DR4yVfld24MeZ5CHfpRJI3sBmMgUkFu/p3pxabYUWGNGFL7VPTCXSNczGUFoWAM8MMH49HWXa0RTA+ujoSKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6674
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28/03/2023 2:54, Kuniyuki Iwashima wrote:
> We'll call memset(&tmp, 0, sizeof(tmp)) later.

Why not just remove the first memset() then?

Mark

> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/6lowpan/iphc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/6lowpan/iphc.c b/net/6lowpan/iphc.c
> index 52fad5dad9f7..e116d308a8df 100644
> --- a/net/6lowpan/iphc.c
> +++ b/net/6lowpan/iphc.c
> @@ -848,7 +848,7 @@ static u8 lowpan_compress_ctx_addr(u8 **hc_ptr, const struct net_device *dev,
>  				   const struct lowpan_iphc_ctx *ctx,
>  				   const unsigned char *lladdr, bool sam)
>  {
> -	struct in6_addr tmp = {};
> +	struct in6_addr tmp;
>  	u8 dam;
>  
>  	switch (lowpan_dev(dev)->lltype) {
