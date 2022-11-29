Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB4263B6BE
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbiK2ApW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbiK2ApU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:45:20 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574C910B79
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 16:45:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ev7T0Yd8MQmGud3fZWaywaS8mMnj0C3RXVZsKNZS+kOmti7KiLTMD2kxrv7PEykC5PXePIsolzpudpU24pLr0fWLqNjQES0Tjat9ORAb3O6rlWSF44o8CTmEOdlVcyGuilyxXqksBGFzATyu1z/zWBmAXZ9b6bxeFwXzJDhBLFGM5jXWHvDZybQhbDZL8hepDyGM82Z2TAwgO1fQpFVyVh7k/fK69MgglIUPXZM2wIp4QNtDY8NO1OBD7P0qvMQa3YOYWNb4NoJHCfil44ZDP2e5MN9gxOaDov25OM0rNPDVutLOkRPqeXsIKX5jjIcaUK8KIH6PjwbXsiGrfeouqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nWKlGaivr/ZdDUucRiOe8w/spvx92YIx8SQSHug75N0=;
 b=iJos3JX5lgSjHaH+WVGa6LhfvBWRLKHeRNZx46XcBUhJmevw4vq+tCIXo06E+JVEF/TYaRbn8xT3dywKwj39qEKO+ytzkHAleFWFFqUaus21kr0moEC1NZ8I0/TrgBYcPrzDLEMgCj+nX4kA3ccvh2HNx11jKsFE1dxuKJjF5OgBlOGjko/TAGRya/BICuDxKP+NuWzGEbT38ffH/g6dNH0abtrLLt1RGq2r+BD9PQEJESSb0lGe/dgMJo6IdTZQgv+2A6bx7vYb0WcHtnXoOAPF8EqLYwXV4q5k+BxmSsLHezam/uaPPtipnUONXNi5yc2V6inIE2LF3m4t0+K5gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nWKlGaivr/ZdDUucRiOe8w/spvx92YIx8SQSHug75N0=;
 b=KtQQlM0CDkh1FezSyi74RwY5r+W2FeE3esF3x4Qy0jfw9+4HMATk37geAF7YV6HdJJdNc25F6xYE1aTjX23CoJIO4kOoyp+j/KH/WnRmwhF3kLebgYYceQCWM4FYDmChzDflRZuaYHYFMiG7oF8wY4QHJf8K5dq0HC9rFRTkbkY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DM4PR12MB5817.namprd12.prod.outlook.com (2603:10b6:8:60::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 00:45:16 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 00:45:16 +0000
Message-ID: <7b744160-f0c9-b3a4-784e-bcb62206175d@amd.com>
Date:   Mon, 28 Nov 2022 16:45:13 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH net] ionic: update MAINTAINERS entry
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Shannon Nelson <shannon.nelson@amd.com>, brett.creeley@amd.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io
References: <20221128193910.73152-1-shannon.nelson@amd.com>
 <792053eb-23ce-7e09-0bc1-951d470e03e7@intel.com>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <792053eb-23ce-7e09-0bc1-951d470e03e7@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::34) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DM4PR12MB5817:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e42a9a9-bb84-464c-bcf4-08dad1a2fb8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9fa49Yn9NADGxe/71AJZ7U8NGNxozd8yvOVxFHbyecSJXx+GOu8E8kl2uPyoJOliUdolXQ30UxMSK+2gxFO8pEpy8hbnVVZrD1DkdNFkEmKTL33UBpb/CDbsRRgAQXYqybavKGxROmLo2/Gg5FjxGlWP5+DecPMhYZMrmSngisEhwYtLZ40DaWdfTYFRlWJuJGHdzVrPOFlpY6eLuvD6gxksAKSaUdS0mfkx7G+gcLMvuO7dg1qFbaDnWaYlgPg4LYMh+7kvLBRIV6UbPziXVGppH9qDVXkHccKQgmrh+y5h6iEzjTFEHU3tlrMkjy2VDwG34wEt+hwaU1V9idx77/UgJatNIb5p6JhXv902A9QVyZLaa64H9eN7+ekCs6s5KzAc4XH0FFpNYSE08XOAuHLAT9lJMSpCVsJxlfGFHol2sX0vc9zqyaLneXTxefMUlZT9zuOwlpeL/9tOHxnJsZKu5YZ3MglqfbXNSeE+i11wrAFRGZc3GmF/p6IkecowcTpyKrMVBwYLtaKAQyDFhBv3cNt4hsvmIbIuMListAnV68QEbhmTErN32bLwe7iKYpFaw9ZC8ZN3C97/aantRCFt2jqc+7cTvJ4Ew31bQwqiw/pJp70wnyFkW1P9wSIkcYeS/XAn3YMs7XIM8jjzQorN/634Lh8z4+9LU6+L9ScO8jjHCFoJOlyDnBVCQHyhcInO5mNBskmiYdmdwSRU4JPYJIHuWLwKR2hxUZWsJ3U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199015)(31696002)(2906002)(38100700002)(15650500001)(83380400001)(41300700001)(8936002)(5660300002)(6506007)(4326008)(53546011)(26005)(186003)(6666004)(6512007)(2616005)(6486002)(8676002)(66946007)(66476007)(66556008)(316002)(478600001)(110136005)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTlsWUVTWi90ME9wZ3VGWEVGZHlSL1lVNWd1UEpPSi9PWWE3VGIrVTR1MTJ4?=
 =?utf-8?B?T1NpVzlBM3IweWZaQkNGRWxFdTZVQTBQRXNMOGEvVG9PblA1VU9VSTZkMUxY?=
 =?utf-8?B?ZC9jSDM2OVlscVhUS3pxTlIrQ0REN1QvbnUwdFFLTUkzQTZVbS95Y3hPY0s2?=
 =?utf-8?B?WHJzakpBZ1UvMW5NTjMzTE5hRGNVaFRKODF0T1A4R3FDL3hTN1VMYzFxSTl1?=
 =?utf-8?B?RDlvV3lIeDBYQXpxc1RKUEF6SXl1QzFjTTMyY254K1lPMmE2Szg2Q1F0ZUtP?=
 =?utf-8?B?TzlqRkduakZrcXJBQUpObi9VSzNHOTRubUdsM0dIWXJnK0NYVWNzdkZMVXZM?=
 =?utf-8?B?NXNJY2J2SzdjV0thdG1sdUt2TFQ0V3Q5OElCdVhhYnZTZzk0bk9mTTF1NkRK?=
 =?utf-8?B?NW9XQUZNN3Nodmp4UzZIN1VDK0hpMkZrUU02MlFWQ3hvRzgwc2dqRENXYlNS?=
 =?utf-8?B?YnNQbVJRUS9kYTBOSjZmYWZod2VkRVVUd0pHdlJsMmZ1VXFyMytieXV1V0lr?=
 =?utf-8?B?T250OWlMUGdNOHRlOS80TitYSHk4WGdMQXBhd2JPRzcvcys5NStUYjA0eG43?=
 =?utf-8?B?WStHK2xjbkIxNXorWkZ6b1FGejBGMWFxK3RTMzlncC9MZ0E3WDljQWFoTis5?=
 =?utf-8?B?TytwWjZUcGk2cW5UUlA2WlVqR282QlI4dStPc3o5d0loVFRnVDhDZHQwZlZm?=
 =?utf-8?B?ZkpTS3hvMVJyVU8rNHpaZHp3Y0dENzRrdDloR01CcTc3ZUZtdWhtcFllbGxn?=
 =?utf-8?B?Qm5nSUZDRDNCaXZxaGVmbS8wS0ZXUTZQVXZ6a3hYQUMxRDh0VkZuTDByejJN?=
 =?utf-8?B?WU9tMStXYjFhTzA4SGY3Q0oxTXBwbHVRbXF2ZUpvWStrZzFuUG1CcHNjbWRG?=
 =?utf-8?B?dFZYc0p5NzFvUmdWazRheHRLVzlLL2pUUWllQXozMmMrTnp0M0F3alFXbFhQ?=
 =?utf-8?B?RVp4SDJLblFORUZSQWgrNzdZRU5ETHdReTVqeWFsUElQS3BNalZFQTVYZXB0?=
 =?utf-8?B?U1lyZHZDUFJKQU50ZDZWaWlSTFp2ODNvSEdrakM2RXFkNDJGcVphNUs1RzFJ?=
 =?utf-8?B?RWlud1R0cEF0b0R6YS85ek82ayswcDRJNkN0NnpRUGp3bVgybDVlcE95WWNu?=
 =?utf-8?B?clhWMUN4b1lOSzVtdHZTUnBtcFg0TmVxOXZlem9QdEdwNGpnRmZpRld1V2Yz?=
 =?utf-8?B?Z08rTzlQdU44VzlDRGlwM2RITllzMWwzcHVzUVc0ZWxyWk9sV293Q2FrdERu?=
 =?utf-8?B?Qmh5eGJyZTBtSUNsVlVTK3ZEdlBaTFV5RUF5MlIxZnIyTzk3S1NxNGdNd0lB?=
 =?utf-8?B?S1BiNnVYNEFRQmhlTmZMS0czL2Z6WjlqWVZzV0FvbE9FN3dJVC8wTCtyRWE4?=
 =?utf-8?B?KzdDL0RydXRERlpnaXpOaHlwaXpNNDE1THZZWDZkWExaOE1JeWxVVE54NzJy?=
 =?utf-8?B?eG41QUtBaktFa2RRTk91NnBmWlV2Wnl1WUtQYkRtblhkSzRpV3NsVGphSXRD?=
 =?utf-8?B?OEFBejdxTkxRekVFU0NCcENWWXFwUVl6TzBWYU5FWSs3cUJKcHRpQjNBMGd2?=
 =?utf-8?B?OWh0UjZ1eWYxcitpTndWUWhjZTRsaTVZaXcxQjRjNnAxZFBzUERnQmZjNTB0?=
 =?utf-8?B?UEo4ZHVKY0toVEZ2NzI2R0Zvc1M0a3pIUVRTQndCT252T1BZSGpGOHdNLzB0?=
 =?utf-8?B?b0RCNFRBQUxJRy9tcVhvUjNneEovOGlQY254dnFGUVBSM1pMRVNVYmllQnph?=
 =?utf-8?B?ejRoVU9WdGFZUkcyeGxBdXhSZ1dDUDB6bWFDM2t3QUw5V0VoclF3bnBMYUl6?=
 =?utf-8?B?eHZaL3RkTTBGVjBkYTd0RkFyZEtKOTkwbWgvYnhjc0xTbTZoUWpKbEhrdDN6?=
 =?utf-8?B?R25vdktoUGZhaTc0TU02TmZISEtrY0x6eFdjdTM2UE5LUjJrMmI1NmpzcXpt?=
 =?utf-8?B?eW1kSEpXNm92c0E0UUF4RjhYTjFRQ3c5b1JTN0tOc1RrblZxWHAzdlFZSDVt?=
 =?utf-8?B?dTVvWldISmR4VUdDdHl1SnQzdUhZNndTeHgxK1FYYWFLRWZGOEw5U2ZLbXRC?=
 =?utf-8?B?N1QySDVuTUJGL3RDVEM5M2k0SkswcG5xWDZiNEg5bHhMSzRCelNOclpXcG1O?=
 =?utf-8?Q?aVb2Ftx08TXb0XhnKg7cohCE5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e42a9a9-bb84-464c-bcf4-08dad1a2fb8f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 00:45:16.2849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t2IjVLJeAh7fNjW1imItcUpJxfHUG0YIZxgRa/hrN9eapGt2cj5S4HNEQEjXO2w8Nc+Hj1pJUkWgDxmUwbmKAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5817
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/28/22 3:46 PM, Jacob Keller wrote:
> Caution: This message originated from an External Source. Use proper 
> caution when opening attachments, clicking links, or responding.
> 
> 
> On 11/28/2022 11:39 AM, Shannon Nelson wrote:
>> Now that Pensando is a part of AMD we need to update
>> a couple of addresses.  We're keeping the mailing list
>> address for the moment, but that will likely change in
>> the near future.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
>> ---
>>   MAINTAINERS | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 256f03904987..44f33c6cddc8 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -16139,7 +16139,8 @@ F:    include/linux/peci-cpu.h
>>   F:  include/linux/peci.h
>>
>>   PENSANDO ETHERNET DRIVERS
>> -M:   Shannon Nelson <snelson@pensando.io>
>> +M:   Shannon Nelson <shannon.nelson@amd.com>
>> +M:   Brett Creeley <brett.creeley@amd.com>
>>   M:  drivers@pensando.io
>>   L:  netdev@vger.kernel.org
>>   S:  Supported
> 
> Makes sense. You may also want to update the .mailmap so that git will
> show your new email as the canonical email address.

Thanks, good catch, I forgot about that one.  I'll send a v2.

sln
