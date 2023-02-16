Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF1C699801
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjBPO4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjBPOz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:55:58 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6BD521FD
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:55:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mNArffsHRGAE2qN5++H+ZB3WQJ53/76ssLHBeR/1o1mVhfQAr23I8zCIh+BCjSEr6DHdCjkns5dWvuO9G3De/KjG8XRxfq/+sSv89ZpcmJyHFdBb0nPyBtujXzL4R8YQgd4Y4FD25LZyvM4vG7yz9xn4ZxAmGyK39GSFg1+mVWRmX4pVXitxArh3unuw+FzYKu398Ne9IZNUhYh5p+Ad5OK9gNXVGoMtKTg0seEieuZa0iZV46zhuOrEHDChaVE4CSS8q65b2kLtxUsFL89iAIFeURJm+upx2YaSkbHwhEXC+O6P1xsFTKGOAzYWK6HeoUxNMN7ttfugFaX4UFuhvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2u8+JiwQkn72aLyUNuRhABBzgEYaPPuz7TfPrZztKq4=;
 b=R75j9xAaeGPjaJEgfP2Tff0DTbtNOvlT5G+sQbBCZGFN96XW9WObXHIiNBNCOWxU5b7L0gBNvE8BZtJB9bYjbSKjQsP4UIsoJd2YsV83VV+xPQ8SjJwAO8uobkrkfXhWu8ufAsZ+x6uyB/Sosv6v3OWrN4KolABAIRN7QPtSMQ6na9XkJOyYObfxT5lTvj0E65dDniW104wwS/H78jN5hsFqUrVD3S41tLBzXI08zKsZ1emSCrjJy4RnJg88KQs7Mapuo/vypuNsBcLKkHJtPgOUs+VKAUwlWaidjlS5jrA6wKxOHP1C+ag+SLQiPv0v4s+s7rQbKQ7LRwhWU0faSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2u8+JiwQkn72aLyUNuRhABBzgEYaPPuz7TfPrZztKq4=;
 b=j/2lGClub+Hhm9IQcuugQVhH2dAsl8yKozCSK6ZPqcK2VvymfpAH+mQbC/cS5qYv2lMKI2U2J36cwp5L8+THYckMmSozxZvd6k9fOs32AQpfsf5XOaw4tqMXj37sgr/xuXvqmB5uD4mwPo7rEih5hrp3d4WQNHu2HqGuHiy69htn+iJ2DOGRBMwG5HDni6JCrv3tdlhoeSMx6VkTxdUU8ik6ZdGZcxxRSXWsk12eo7hF9RGqedSICxZcgtw5EQ2v93ZKukjM5jOFjsv1Nbv7sCYYNHMtL97/4Q0NOx13lyHInPETy6M7YT7ANDTh1YUGs18g6QAydoXtypxFMJbBgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 DS0PR12MB6557.namprd12.prod.outlook.com (2603:10b6:8:d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Thu, 16 Feb 2023 14:55:52 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::e3c6:2768:3a84:d196]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::e3c6:2768:3a84:d196%5]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 14:55:52 +0000
Message-ID: <646f4e37-9020-a5af-ba02-9962afa96d08@nvidia.com>
Date:   Thu, 16 Feb 2023 16:55:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 2/2] skbuff: Add likely to skb pointer in
 build_skb()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230215121707.1936762-1-gal@nvidia.com>
 <20230215121707.1936762-3-gal@nvidia.com>
 <20230215150130.6c2662ea@kernel.org>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230215150130.6c2662ea@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::7) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|DS0PR12MB6557:EE_
X-MS-Office365-Filtering-Correlation-Id: b176ff86-4e17-4dba-4729-08db102de5be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gG9JdJVfzWfPWc5fHdurs3PFYAH20x43V6bKQ12NnA2lC/iLy4fvl9QtLG1N+lx590wHdM3ZZTQSpHG6uNRdkMxkhIhasQguI9WB9+9fK7JG2eDl+YBbxsCCl+4YlqWKYzeYV0ZxzL/NTcxxtt702mepbbRAgBOOb47DwkCf0r2nkJ9qayCNGGpJv/gmrlXGKtSzPyBHkKVBo64NurkLBQgJtsgDguulqQeOID8oZbfZFsmT85aMN7uuS0BnThusK+oso2GnMtcIKSCqt4bdY08JBrCrUgp0NLnJ5Yx/ecTOzcggYi/E16IP6t/xUbnMJ8gbWxfuW6KnpiRjA2VRCCLVUoGtyEo1pCc3Q3mtxCUkGYWCXOzoBXZBigy0FjvatqJChzQx9MzmvbUOW8hMYMfyrNH/gxMzR6II31TUvOYFkWxaPaXKbyQ40L3sQRXXitMpgAroLrcO+v9UIC8Sxi9M0fI2aBedhN0B5kGtGxWEXPei1teyxcqBn44T+8f97fLF05vgSL9d6RWXN1CnKN1yJRnQ+tE+xvJtBvmU3j7Wfq9RQEdJb+zcbF2Wyeqem8UCae9/vYlWNFqCaLxmxGi3GLaNPXXHiEgOOjjg5kFJFJIN9e30ABapQgDS9lY5tbwUh6tTYidfQJPdw/etwKqNorTEChxTPgvj7bO8byHDagXVxNU6ymbV7nchOU0Ay31C1xa+4KAsMz+MPxfszcbX2ensO9D8ibjwg9RzZL8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(451199018)(2906002)(31686004)(6506007)(5660300002)(53546011)(4744005)(8676002)(4326008)(86362001)(66476007)(66946007)(316002)(66556008)(41300700001)(31696002)(6916009)(54906003)(478600001)(6486002)(8936002)(6666004)(107886003)(26005)(186003)(36756003)(6512007)(38100700002)(2616005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTJFMnMyWWp5NUR4MDJIQnA2d3ZxQ3hUNUpFbStGUFMzdmY0VmxHVkNQaUpC?=
 =?utf-8?B?Qzl3U3JVQUF6UEdkT21jRldJZUhHRVZCdjZnM1BTekxkVEVHM1lUd2kycTFp?=
 =?utf-8?B?dEdkZmM3aFNXM2xTbGlBSWlQWTVxeDJpSDZjaGI4cnI3TGJaRkErV3prYllm?=
 =?utf-8?B?Mm1td2U1RlFXOXg1UVEzVUljV3FyNWRnNS9hbHZVNjUxY1ZZZEZXOEg2YXg1?=
 =?utf-8?B?dlZlV0xja1pNRFBnb0RUU2JYT3FUL1BxcmJmWlRYSlZIeFg1Nis4SFA4WDZW?=
 =?utf-8?B?MlV2UitWSFhiZTUyUzVPdnN2SW0xRXdQdUs2NW5UdCtJOGhaQzJvdnc1YlFV?=
 =?utf-8?B?b3hOSEF1RU1BQzZ5M3MrQWJQbUJNcTUwdzhkRzNtZ29iVlR1QVlFNTRxczJy?=
 =?utf-8?B?WnJsRUVRTnlxcnZQaHNSVGxlNHJDbkU3dFBCWld5WE82eEtqcjZKWURwRWlm?=
 =?utf-8?B?K28rNnkxRzJQbFlkNEFoMmk3a3RqZXdUaXhOTFVBN2x4VXREdE1RTUhqN3BQ?=
 =?utf-8?B?VjdoT0hFd245RHRNbitLd0c0MjFCTG5Ga0pzK2ovS2p4bEV1YVRlcm5jMHhn?=
 =?utf-8?B?SkhJdGlsakQ4K3EzTGJMRmlDVW5JVU5GRWZyK281THBHV3FycVZLbGIydEs5?=
 =?utf-8?B?MldYM2JYTnBTdkZoWDV4WWZmdUZYNGdNTEdEMzZha2Vaa29IRGMxRE5ueW15?=
 =?utf-8?B?OVpUS3BBbzRSbVc1elN4OUE5Mk16RTl3d0k2R2V5cnBQcXBsSVE5azBJWW12?=
 =?utf-8?B?TWFGM0lpOUV1SHJxb2pNcXFLSmdhYloxY1pXNmhBK0hmUlFsak0yTmdNUmJB?=
 =?utf-8?B?RzZHZDZETW9HR09kS2tKK3Juc1dqMTZiYzJDY1ZBNW9nL3hMZVZCbDZvYk1O?=
 =?utf-8?B?QWpQenY2dWxpM3lPdStHZElDNDh3dzlKckZ2a2E0bFVocDRIWFpwemlLUzlJ?=
 =?utf-8?B?a2dYa2UvUlY1QlRIUTZJQzRvWk1YRW5jeGE3ZG9VOC9ydFhZeW9vVjg2Tys5?=
 =?utf-8?B?YUJ1ZlFXakRNVFJQaEdOVTNHRzlHcldYRXJCaXl6ZEJucnZwQVpkcWVqRzNR?=
 =?utf-8?B?N1FNZ3Yrb1hzVnIzY1hkMDRDL1FwZjkrNnQrLzZaK3UxcGk5d1NlUitFRlZk?=
 =?utf-8?B?R3BvQXRtZE13VmlTdnFsRFNLZGZmWjk5bGFncldmQ2EwK3QzKzFKblJ0dngx?=
 =?utf-8?B?YmRYRkI2U3c2aWRRRWhFY2JaOXVUclNSVFlCaGtNQkZRdGJ4eGQ3cTV6Mm10?=
 =?utf-8?B?NmxQdWRjUG9LK084UHdDZXJvWWl4elUyaytqLzBCQUdlUDh4N292Q2NvM0Nk?=
 =?utf-8?B?Ui9Od3hybW95cmZkSWFpNmRaVFp3d0Vlc29PL0dvaFFaMW54U2c5Y1JtYSty?=
 =?utf-8?B?UitaRjY5RkN3N0kzRDk4S0JlN2hLcnhuRFl4blhYcFNBY1VCSW5JZUlOSE84?=
 =?utf-8?B?WWNVVUpWSWhIT0ZlNUQ4RDFpcklVdDQreVJ5MjVpL2VpNWt2Mm9nTEhjTGlJ?=
 =?utf-8?B?TmxGV1huTHZFTjBOVUJBWmk1VWVsbkpxSTF1ekNjNHduWXlkNTMzNkRqc1lQ?=
 =?utf-8?B?N0U0UnJxTUdjZm9GZWdEa0dXeDhwY1VXcXpEUFYvbkdhZFFubkt5S1AvT21o?=
 =?utf-8?B?YW9Bb2FXOCtWMjFhbXlOZmxvcXJodDkzc09ubndUTWdSTGhYaVhibmJjdFVR?=
 =?utf-8?B?Vnl5UnJiU1luTUNJNTlqMHJ3Y0ZIMlhrZnk3TW5OV1VKT2ZsK1hBVWxpTm1r?=
 =?utf-8?B?ZGRaZm4wNXdEclNjb1YyU0hIdlBURit2aVcxbXVkQXZTKzFQS1U5RlVNeFM4?=
 =?utf-8?B?cDdhRW1PRFdvbXV4Wm92b0dhU1FIYkhQcFI3clYxK21TeDdONUVuVEl6U21r?=
 =?utf-8?B?WkE3UFlYbW5XbjdHZjh1eTljR3BRVVp3dlE4UFZtalA2ejVscDl0aFlrM3dI?=
 =?utf-8?B?WXZFMytyRkNsRHRVWk1ueDRDem1KRTZsb2E0M1VyZlFwRms1eUQwaE9Pa2pX?=
 =?utf-8?B?NjVtczkwY2tJQ0FyS1crV09xSE5EZmdEeWF0cDJuaEU4MTZCWjJSc3RYd2h5?=
 =?utf-8?B?ZzdvWVgvaTZmbnN3TzhCTllUT2ttMm5kWDBUbFU3SzRxVlNoQ0NLZUlVZ0cw?=
 =?utf-8?Q?4cu+amdNv1Li5k0D7UFyJe5EP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b176ff86-4e17-4dba-4729-08db102de5be
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 14:55:52.0952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ekNp7zdQjccNYihJECe8XUFrW9+OKzY8eaNfsCCbC0wmzN8ntoV+HbY4GORTdOda
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6557
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/02/2023 1:01, Jakub Kicinski wrote:
> On Wed, 15 Feb 2023 14:17:07 +0200 Gal Pressman wrote:
>> -	if (skb && frag_size) {
>> +	if (likely(skb) && frag_size) {
> 
> Should frag_size also be inside the likely?
> See the warning in __build_skb_around().

Agree, thanks Jakub and Paolo.

Do you want to fix it up when you take the patch, or should I submit a v2?
