Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866CF4B90B4
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 19:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237846AbiBPSuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 13:50:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237840AbiBPSuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 13:50:10 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219C32AFE94
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 10:49:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JK+8bBZh05IrLQwhMNA25TVmvfZZXbcOi0T2pScIHamqgDvrpihfy7T9o/FS0/3GRhFZ/QIjBQd1pB0A4EEW1jxvSfLoq4470JC9z+IKZ5WSXw7A0KvbB2Lqb4WMzcdiCOEJiqVO4eP7tZH9QeksJYmpC077GrY4b7GHN9Gn1EFfZhT2zaLa1DKaVjCabEtcCyTWKZAeYdKsT8pgKx7lz7R4K8LlQMu5YLLSAsJoBEhIx9O+XMQXasU+sd9VhmIBosIlptzOBoRPKLvleSX6Zs9xhUNeCOAruuNmQu/SppPdKYEsbbTGs0VBcQ2q+AvUB3TWNRvJnhcwoFRiIKZdpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9tgdexoTmjG7pHRSVG4uOHq+uiBFwbor+Oyu4HU66G8=;
 b=jikF3stKkd1Mh3zREUzjqsygJCXeecSSwFB8wfWxwpMbSML/nauL3ZfHjk84oOMmZrIF6+pL9yOFpLLiYnYdf6/31exRBLvCImXAbZgL1vJvRjJqeRTKKZYZYAWNFnpXg6QFQMb7F9Kz7rT5jG2MkZyRLFGs+MNHf3+JwEHRaXxrjG/mJ2xTHs99Ee2mOZYd2+xzvL8V4arbVnQBd+rJy6GHVy81+feAyEJ0nj51RRosRG0bqhnN070IfR6DhvIkDdHsARBpECynKDn9puJ3JZEY5NKr/kT0icyIRSRgGgPZvnbockHXtQxSjIAIzJdAtUSm/R41vJPcW5KQRkDqPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tgdexoTmjG7pHRSVG4uOHq+uiBFwbor+Oyu4HU66G8=;
 b=Q5h0FaGt6Y0vgsbIPAIhFQGfq3IoA6hlWn9J16/qxCSa6H9fFgjZF56D5Xy5I6tNXGTTRBhaM43sswSXkd+4lDYB3dE0piS4f+xpMJUqHhG3xlUUzu+OqXkY33nOzP/jmFzOdd+zTXOVmM4q26rVRdZs78TkYs0enHy57vI7hQ7wayd22pIr4gfUGHilQo6tR4xnbPh9CIbq7Grli4PfCTG4S6GSYkqP/rMb5zxhNDMtwGaXP2xj/s1OAVKlVkzOzUIDrKplz6jXDLYs+QMJCsHyA86+PWAf+XPvHGhP2ZsZ0zH7e93l5hdNpM36qNs0y5jvPcec5UXinLXTY7cFbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21)
 by MN2PR12MB3469.namprd12.prod.outlook.com (2603:10b6:208:ca::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Wed, 16 Feb
 2022 18:49:55 +0000
Received: from BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::fc78:7d1a:5b16:4b27]) by BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::fc78:7d1a:5b16:4b27%6]) with mapi id 15.20.4995.015; Wed, 16 Feb 2022
 18:49:55 +0000
Message-ID: <3407e581-2cd3-d096-f2b0-289ecc840e0e@nvidia.com>
Date:   Wed, 16 Feb 2022 20:49:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] net: gro: Fix a 'directive in macro's argument
 list' sparse warning
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
References: <20220216103100.9489-1-gal@nvidia.com>
 <20220216140605.430015-1-alexandr.lobakin@intel.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220216140605.430015-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5P194CA0006.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::16) To BY5PR12MB4227.namprd12.prod.outlook.com
 (2603:10b6:a03:206::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b338105-11b6-4724-0c07-08d9f17d1f24
X-MS-TrafficTypeDiagnostic: MN2PR12MB3469:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB346930BDE0EE4F0C112BFC4DC2359@MN2PR12MB3469.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ajLmm82yB81hfRzRYWSG2O+9x2D4KbFv5oRT3TJmYhXyDWxxrvDqvjgG3MXaAS3GBzaE/gCiPoJ8qHKTEbSvEMJAMj6ETLjLbV2pygku1QYLvCsic27vnVzir2Ni05yiCBZTk07t20vZoGJVnyifGwC2BpPaAJKSMCbwx6Prcyk7IkIstvztqVjNisciJ6pSkQVEJXr3fVLFso+FheB7zD0ui6PfjPtX55o3E6BKP0iOLEkjmTKdrjSDOFvPtmIeEShwTGejxkfEyKg/uTSMVOc3vn2gKOcy5Gf4Ko5sioapW2cHR0LOit1nu8/lHv3qt8TwAXTPUs8w3wrwY0MCouUZtNMMyc1pJZnNys0ekNxCqWk4JdqoNBqTc9MiaCNF0PgLsIBtKtz73ORb18lo8PM/xAxFwnA5VmHCxgnN6YWAfMZOztTmVGlxmSMQF2xe6luTrlOgjwtGSJMyCE5+s2xjEw0nMXhbIUY7eCSBK5XPShNJiK8s3gm/QtIiJ6WHr+pwFb9muz6gnI8ZNhvaaEISXOqWxKO9222TpsMvQGQ8Tn9CY5CGtmNd/CAa1qbZnGCjBtnBpGCo+NW/KvkoZPw5wf0wyCJV7hGcrk5p9/hsQKlVBuk/Hiqw3QaddElLE/+ozn3z5yx+MMoaljA60ctBCOyh0GJrbqGykD20RrA4bcM4E+6RnlSyURnPOeh+QygUUbIg1WxXwcc2Qhp4U1niQ+wGzadPfMZsEovog67dfXf99wRa40LdXtTqiod4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4227.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(83380400001)(6916009)(54906003)(508600001)(36756003)(6486002)(6512007)(31686004)(6506007)(6666004)(86362001)(2906002)(5660300002)(26005)(186003)(31696002)(107886003)(4326008)(66946007)(8676002)(66556008)(53546011)(66476007)(8936002)(38100700002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkR3VWRQMys5aFBoRkJNN21LNG0vYXJtZm1MY3Z2ekpNYkhoMDZyQ3pDaVla?=
 =?utf-8?B?ZE43RkFUMFNLdXltQkpCaFA0WjVpNmRBMTVSNmw0blZmc3Q2VnNJL1lwVURj?=
 =?utf-8?B?K0pzZk5wZU11TW1qZUFzakxRTDhCdDZWdEtMK01pQVpJcEYvS2NWQnd5MDdx?=
 =?utf-8?B?d3kyejJobUV5NkxGN0t5blgwMktIUW95Y2pmVHhka2pKZERRdFM5dU52QWsx?=
 =?utf-8?B?bmJDN1E3TzZjQk1WR0dlMFNSTUw4d1NQZ0tkRjQ1THE5S3VQN0hWbDk2dHoz?=
 =?utf-8?B?bEF5T1pIRmYvNlhheVNjU0hyUlczd011ZldEeGxGdjlycHhSdkkwTnNLT0ds?=
 =?utf-8?B?RXFCUTBxK3BXZGIrM0lHUUZFQTZkSFRXNFZGU0Q2QlZ3TmlkWUxpcmFjNXha?=
 =?utf-8?B?OS9kSmE4cm1PV0xJVnZacmVxNDhteWlpL2F6N2dDaVZ1cXNvdzE1dHJ2Qi9D?=
 =?utf-8?B?L01qWWpTNEplMG1MZGJvWGVBL0NhRTRRdUh0Qk1OTldFTisxQjZhaTdYYkNS?=
 =?utf-8?B?L3VZVkpQUEgzWkdyVi9ROGUveWpXRUhQY0l5VUdReUFQUTRQcGJWd01ieFBR?=
 =?utf-8?B?MFl5bVVQcTNmbzdGSENjMGdZc3BxbytFRWJOVlp2Q2prSXU1RTRvOW8vakIw?=
 =?utf-8?B?cUZ1YmJJbFZzVWlpNm9KTDB1eThKN1FOREpVRi9zcnBXSVVmeEUxcWdJOS84?=
 =?utf-8?B?eWpNalptRFh4ajNJemgvY1NzVFFxb3cwRGdaRnRlakEwb2xnay9aVEJEUEtl?=
 =?utf-8?B?ZmI4K1I1R1ZkdzhUTG9RdkZnakZWalNLYlBkYnFBOVVqRWxWNHV1VVplOVQ2?=
 =?utf-8?B?c2I1N0VKV0V6bVYvb2pQUGVYbW1YcDZLOWx4eEt2a3g5b0o4emlwWWcvZEdm?=
 =?utf-8?B?clhNelg0ZC9TOGJiODdFN0h6R0FTTkpZWnhsTlVLVkNMV1hZRkJobW5oVlhs?=
 =?utf-8?B?ZHNKTmNqYnpjSDR1Sm85aUVmRTNVMUp4R3QyNnlsVzU1QnY2WkgxYkpoQTVD?=
 =?utf-8?B?M2tIY2ZxT3oycFYrMXBlc2pDSXpuaVJXVHNxNEpWMk0vbWJYSXBCVUhRbGhk?=
 =?utf-8?B?QzBSRW03a2JIVTlIVG5TQ1RUY3B2enY1ZGtyVmdYWEdmVUhLNEhyeXYrNm5Y?=
 =?utf-8?B?N3VLN2RuK1Q5czFRRFhaZEJ4Mmgzb0FIOXBlZTJJb0VHS1FoQmtxVGh4QjQx?=
 =?utf-8?B?eGgzdnhYeTc2aTBPcnBVYjFmNm13OXVmcUF0bG85d2Y2aXVFQlBrMzJwL3N6?=
 =?utf-8?B?RC9PeG1lQ2YvNWhnQ1pxYWVHbFdJVUwzRDVwSWxjc3J0dUUwZ2VaK3F6Lytr?=
 =?utf-8?B?Rlc3WHoyeVFpRDJNZDJrQitQVnJOVmpiY3BzQ2k2cjVYcFNpSHBIVjBNWUNN?=
 =?utf-8?B?VU5kZUp6a2RycE9JRHpLam0xOGl3ZlFsa2lDVUJ3ZkU2cDhwUnRmdzA5WWxX?=
 =?utf-8?B?UU4zZ1dvSi83T0xmMHE0Rk5hcStjNnEwM2FuWWdCekU3NmxkSzdxaTBOMkNT?=
 =?utf-8?B?dXMwMHlnSkMwWHd5M2M2MHNFQ2s4MEJiZDJhYk4zbWkxTDgwTXg2ZTVWZnRN?=
 =?utf-8?B?eS8rYzQ5VE5sejVCcEJjQXF4NE5hRE1JVFNaT004SmM3RUV2d3JUcys0OUVh?=
 =?utf-8?B?bGJ1eXNQVTk3SWtFTzlhV3FXY0lYZDRQdjVqaXRMaVpDZzZPL2VoV25NMlZP?=
 =?utf-8?B?QUlhT3IvR3crYVdGUmNZcTJ4SEQzWUtZbDBUV2pqNlVra3NROGhmdG9kZ3dq?=
 =?utf-8?B?UVBJUUpBaTIyUUlHUzhlVisrN1liaHFKTzUrRjhTZldnWjhheTFNZ3NHaG53?=
 =?utf-8?B?V1hnS2EzWm92T1JRS1BQOFp5d3JDbW5wQXdRd2FaaFFpbGZ3dnFUcFNKbW9U?=
 =?utf-8?B?cUxEa0ZsSmVkREVsK09Yd3NwenRnak0xeHhrRGw4dXhiL1c5RnBFZk42OHZl?=
 =?utf-8?B?TG1HM2lqa1NEb2RQVzg5dnJBTzd6RWVTdkNhcHZOMmlTWUI0VVp1eVk3WGxy?=
 =?utf-8?B?OGpoTGIrZXdhWmZIREUxc3Y2d1lXQ2JYMHhINUYwZFhyL3hBWTcvNnBOMUMz?=
 =?utf-8?B?TnR6OEVqck9uVUtJalprbWRCQUFiMTRMT09ZeE5qeEZJZFRBUzZGUVc1VCt2?=
 =?utf-8?Q?9tv4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b338105-11b6-4724-0c07-08d9f17d1f24
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4227.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 18:49:54.9047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OJZ42u+Qlz5dYYWJ/6QMAUSZJwlkla/OBykaFGsfZjbDKZebtHY03cB8P9oq5bgE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3469
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/02/2022 16:06, Alexander Lobakin wrote:
> From: Gal Pressman <gal@nvidia.com>
> Date: Wed, 16 Feb 2022 12:31:00 +0200
>
>> Following the cited commit, sparse started complaining about:
>> ../include/net/gro.h:58:1: warning: directive in macro's argument list
>> ../include/net/gro.h:59:1: warning: directive in macro's argument list
>>
>> Fix that by moving the defines out of the struct_group() macro.
> Ah, correct, sorry that I missed it during the initial review.
>
> Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>

Thank you!

>> Fixes: de5a1f3ce4c8 ("net: gro: minor optimization for dev_gro_receive()")
>> Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Signed-off-by: Gal Pressman <gal@nvidia.com>
>> ---
>>  include/net/gro.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/net/gro.h b/include/net/gro.h
>> index a765fedda5c4..146e2af8dd7d 100644
>> --- a/include/net/gro.h
>> +++ b/include/net/gro.h
>> @@ -35,6 +35,8 @@ struct napi_gro_cb {
>>  	/* jiffies when first packet was created/queued */
>>  	unsigned long age;
>>  
>> +#define NAPI_GRO_FREE		  1
>> +#define NAPI_GRO_FREE_STOLEN_HEAD 2
> 1. Maybe add a comment above the definitions that they belong to
> the `napi_gro_cb::free` field?
> 2. Maybe align the second with tabs while at it?

Sure, will add a comment and fix the alignment.
