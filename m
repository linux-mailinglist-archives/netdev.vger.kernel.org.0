Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE145BE23A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiITJkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiITJkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:40:19 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A31F33A24
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:40:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYUG40iUKWd2XV3e4HTOQ4h1rca5UgedTM09WtVhMu3kRNht4tk0tHrrhhLuavC+/jflMAuf39BNJqDWPocZn0MMaa9EOwk7iiQYsMH70n65f8OHcDUmKl5K97C4jbdhPbahn2luFRF20nzYbis9sCYI+4nkoQRYVcriswC5H+KubNJcqB0pBY2zEfoBBFiSKj/yieQvC0Q2qK3U16tFmcJHllsdAonU25nFaY5RpJeSyTF6HfuYuUOGZMUVg6/VxzVgN045s0L09HE0c3iKn+1e3NewkPGpPpjGPFKmI60uRCUjWdFR6wtz+27xvAw3uP5GfcyfcZDjJbCer2cXAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J9E44A3XpkmFFXmnC3pltCqBLzWBecnJdKi6ABjmLpY=;
 b=e6bqel3KRpJf3tn8+gt68cPJsuxUT45B09InHq9xLGRbPsfyN8UTx4JXpQK9zNP5deoBUCbRjxhlUpMQbvqcVAM/4MMYTQs+YPxxaoQ76QdM8LHFkLhgM0MG9vjleAxUg0X+DQhJ5OjuYl4H186xnAecwkVF3EgPcoSMzNMIIL/7orr2sFwCFLvG4E1RIk4lrO7lraiE+wtJGmvxCPskfjTslnUPMD7GzNNPUmBieulbE3IAS0WrU3/kGYSEUisNbvDFL3wXDpo0KcR9+qyJ0F2X+ocnbf2z+RwKaF8FyVA/U9kMhxiNVj6yH+vyjtj5uxKElrBMMzXttbXeXC2bUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9E44A3XpkmFFXmnC3pltCqBLzWBecnJdKi6ABjmLpY=;
 b=W461wRWaBrn3zuqyracOvlzHL0DMBBqEE6YTpwSXXNO6wAZb774X2bl2rssHulXeWvjJbhfP++wIcPMJ4eSdfOXGx39UqgMliO23uJt9f8hQlj3RXv461C1RzQgmYbb6etSiiQKz+lWq8K+j0L30pmLVqkF2wUoWiBu65Dca1wY1gq9qJcKR/F3yqBhh4A3MbV+UN82z7Mxxx+62LMP/1TgE7GMRv0/iPaDkfDJrcIrRWOdwYrZQVwS7uRxA8x7GTHguRMQ+YlUcLHuOopW37tw1ZSRyYymp8ubMZ92IxIuYBaJOpkWNSJmi4HDMNTkBMoL9nOSThwN8LvuqlyPEEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 09:40:14 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::24e2:5b76:cdee:bd15]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::24e2:5b76:cdee:bd15%7]) with mapi id 15.20.5632.016; Tue, 20 Sep 2022
 09:40:14 +0000
Message-ID: <15d65b5f-aa90-d2b9-cb17-9b29b463fe0f@nvidia.com>
Date:   Tue, 20 Sep 2022 12:40:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 4/4] net/mlx5e: Support 256 bit keys with kTLS
 device offload
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20220914090520.4170-1-gal@nvidia.com>
 <20220914090520.4170-5-gal@nvidia.com> <20220919184753.49e598ae@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220919184753.49e598ae@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0203.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::23) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: b88cd4cd-9e86-420b-6407-08da9aec1ea4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y/yA1QnHTgGpETTmL7EomBAby2OgWtn1PE6+HHc6mUOJFtIPWd0EYxPY8ck7w4ZxK51EURRine8Nag42s0d/GIQeNThQ7JFwkQ2wzjgFf2BVOQ4U31cADcB4xj/X1n8bNQ9jQQjPI7idUUIr6mROZr0r/E2dmbEz0fDFtfIlDDNvmTSEHR2Y4xhZykt0eKW69g2TVDz6vI7xwIfJ0+L26AAHk5i4E26tph7HdtHWNM5cZwP5IsVLtfpbXZKLJ0dkoJ/0EvZdj/DGVEkKrByCZKtik1b+vcdkYmlruMQbcFp23IPYS6y9hVcU9DkLOre+rHOJ7RFDiWhZDAWepJbhj4IpFqWa5ePViap7TCNEQA1Nre/reAT0+834fk7lKSsJJVkPoIP8o4Pt+CbsCpfTng/zPx7SU72XlxmMPJTp4kJXMGVNZCv015qHSBraLpGoplpLHA9flwIXloE2Xolov80naKrD7ZOPF/sZ4dta8ObXSU/M4qwEpch9aE61E7B4xFnlZ+MuDjWRmbmvKASLhmieJ73QRDlWLF8x+03ce6inyA4iq5rhW8dFk9rmSuIR0aQGWgtmd4ZjpM24My9EBGPvWwsWeV3u2IIt5YBLHLe2j2YqN6S7Qeg9Np1nTxyYpcGzP+sG0T8z5MOFmgcw7o3voVKarkNoFHG2ezt2QXP1vLVm7SH6hnQTYkPfEHqP5OFhXxE/7IAY34ZjdKjT3zT6v3SfQL0OciCFcnlkeyiUl0mmhbYcoJ6NEro9LZBlqpp06gW4Ntto3uhq7Kn4zwC6I/DyNZmsmpdwZkdPdRg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199015)(4744005)(8676002)(31686004)(36756003)(478600001)(66556008)(186003)(6486002)(66946007)(54906003)(6916009)(53546011)(107886003)(6506007)(31696002)(86362001)(26005)(66476007)(4326008)(41300700001)(8936002)(6666004)(83380400001)(38100700002)(5660300002)(6512007)(316002)(2906002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVdtY2FhTkNta2Nma1UvazNmSlY0emozTU9LVzVIcFB1M2ZjYUJ6b2NvQXM3?=
 =?utf-8?B?czBxL2FHZUFWV0lscDl3N2hLTzBJMUJ4SFJoblRhcGZ3WkhkSE5JV0NMQjJK?=
 =?utf-8?B?ZXVnY2g2R0s5a1pDSGZOMjNSZzU1eThxamNaWGRhM2JPZ2d0U3p0eWJJY001?=
 =?utf-8?B?bmNhUE95Z1BkcmZJYXYwMURNQ1ZjYnN0K1Y4ei9zZjZYUUowYlNhdmxZK2ZZ?=
 =?utf-8?B?Q3k0SElKcGlkOWlZYmRYR2s3SlJxZUNVY21TR3hrQkdibWFPYzRxQVlvcG16?=
 =?utf-8?B?ZTArY1BoZ0QvZkJ3c3pJTEdFV0laUFpJLzlXMTZUSmpEUUFNUG83M09hSlVI?=
 =?utf-8?B?OXBOTVA4VWhrU3JzbHpzY1I1SkZqamZUMUpnQzVCZmN3NVpxd3l6T01ZWkF2?=
 =?utf-8?B?U1ZHVk4yRlBtdU1QS3Z4S3lHSWd6V1V4MTJMbVUwaDVJSHB0Slc4a3FtK0du?=
 =?utf-8?B?R1ljOWlCYTRYb29qYlhmSUE5VXZHWld1QTJQMkFtSXJ3ZGE3dGJWd2VZK0NG?=
 =?utf-8?B?VVp0bUR5dEd6S2hzcFBiZ21MRmlUOS8zM3YxbTZLMGIvYmhIOERMUHhKUFBm?=
 =?utf-8?B?ZjlPL09KTW80TU42bnhvaHZhNU16SkJaNk5ITTZsRlpTY3NBMTNKQXBoeTZE?=
 =?utf-8?B?Y2lRN1JDdmV0eUorOVNvems4RDZQVzZBL01nTWIrMzdNSHZrR3J4U3lONWU3?=
 =?utf-8?B?dlhCaFFzMy9henhBV2htYnFxaUtTcnQ0dWpSWExVQ3Exd1VXYXM0QTdnSk92?=
 =?utf-8?B?MXdsNXFnSFkxRzJ5SnQ5RHdpSGN0U3lDL3hXbElycnJFOVdaV3VFRDc3aDdI?=
 =?utf-8?B?UTBnUGlxV1B0RnlPMkhQZEN0dmVTd3VmdFAwNGYybHhOQ1BxYXdjbXEwK0pH?=
 =?utf-8?B?WTJqaUViL2ZkYXZWemxjQWZVWmFpdkp1SWlML2R3NXNGOGtUQzdWS2M2S1Nt?=
 =?utf-8?B?U0JNaGRCVk5KenZmM2dINFdBendjTTB5UEg4N1pDbWJycThMSEwvZy9vZXVC?=
 =?utf-8?B?cE5oYjRoS3M3dkhZUVltVkp6NlhzS0lsMmVGSnI2RC92aUJ3Q3hVdUhpd3M0?=
 =?utf-8?B?cWVzYXZlbTVaczFQTE5MVUpqdkN5ZFBzYzlIbHIzTEZlcnZLSkRMRXM0OVJK?=
 =?utf-8?B?enFJbjBGeVV0amxxKzhrZnUzMVJnNVV2Mm5WZWFIRmQrY3NZSzZJY0pQMXN0?=
 =?utf-8?B?QXdaZmxCVlVlSnVOT2ZVSXJuRWhGdXRCeUE4U3JZMURmOEJGNExhaHM1TkJR?=
 =?utf-8?B?THc5emlqcWp4UXpjWEQ1RnhzUUhlOHUrOW5YYkx6VURTZGIwMENGYlVXeWhL?=
 =?utf-8?B?SWxrOW9HTmZkejZSazQxMXFqbVlZUGk2UG1ZclhNTUJtRkcvbG9iZkxidkVO?=
 =?utf-8?B?VENvNG1hT1B5dWFITXRpVVN4Mjkyb0hNVjZqaVRZZXhES3psTG0zZkZoTDk2?=
 =?utf-8?B?YlpiNnBUU3BVbkRPR0RKYStRZm5vK25ZejgzVmUzVFZERURCMTUrSXpac1Vw?=
 =?utf-8?B?YTdtbnEwdUdPS1YrRWJWU0htSjZYWnRvVzJkYXVzWkdDbGFYK3BJY0JmNVVV?=
 =?utf-8?B?UFhzaFh1eDFWQU8wOWlQY3Fxb2ZnT0sxSStTSFhKMjNyN2VOcFpWYzE1Nm8v?=
 =?utf-8?B?TStvUk0rcWR3TWxaOHBQRGFMakhMZUtVYlZ0R2xlRGpGc2ErbWhIVzZkcTRQ?=
 =?utf-8?B?TzdGOUk0NWN1SHJGbm41eVNqZzJ2djh0bjc1RUNFU1c0RVlpTHAwQnduQWVn?=
 =?utf-8?B?UVVYUFpTQVRoSWMwZHBZaTNZdE95STE0ZWh5c3czaHZqeTMzbUNKNE54VXRW?=
 =?utf-8?B?WVRzOXRzYTB5MzduVjFTYWIwcllTMng0eUc5S0pnYmhrdFFFbHZGU0tqVWNB?=
 =?utf-8?B?YnMwS29LYUVlNmlrWWw3czFzM0doeWdxcUx6ZXFvVHN0dlppcEFKLytQOHRi?=
 =?utf-8?B?K3BYYS9Bb3Jxd21LNVBmWDdZSVNvckFqeXUrc1NDaXJzRjBBZ0JCWVUzeHBt?=
 =?utf-8?B?NFhhckNwS2RxOVY1ZVNlMXpyV09IUzRnYW1aVlZHRVF4MGdmbElKeEJuRXZu?=
 =?utf-8?B?T3huUEdISFRKNGROVlk5N3FsSmp4QndZM3R2S2J5aG9nQ0N1SThnMzN4YVlR?=
 =?utf-8?Q?VS9FS9KrKO1buG68CDBHRmSaR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b88cd4cd-9e86-420b-6407-08da9aec1ea4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 09:40:14.4645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /nfxhgJDOcQlsGQNXHB6aXFwTAWmQS2LrpU4LnXNZiUhj7PJA3wSj0FwL9er4NXd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/09/2022 04:47, Jakub Kicinski wrote:
> On Wed, 14 Sep 2022 12:05:20 +0300 Gal Pressman wrote:
>>  	spin_lock_bh(&ktls_resync->lock);
>>  	spin_lock_bh(&priv_rx->lock);
>> -	memcpy(info->rec_seq, &priv_rx->resync.sw_rcd_sn_be, sizeof(info->rec_seq));
>> +	switch (priv_rx->crypto_info.crypto_info.cipher_type) {
>> +	case TLS_CIPHER_AES_GCM_128: {
> ...
>
>> +	default:
>> +		WARN_ONCE(1, "Unsupported cipher type %u\n",
>> +			  priv_rx->crypto_info.crypto_info.cipher_type);
>> +		return;
> Sparse suggests releasing the locks.

Ugh, will check how it was missed in our CI, thanks.
