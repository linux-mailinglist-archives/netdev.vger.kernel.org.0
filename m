Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19EB3480F1
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 19:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237678AbhCXSux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 14:50:53 -0400
Received: from mail-eopbgr700063.outbound.protection.outlook.com ([40.107.70.63]:36833
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237711AbhCXSuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 14:50:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWmJXhfgem22y1UlSAcPfsE1UuQCDcoQseG0/hcQVcm9zkaULaAbSbIRMbacNRui9zBZze/RJ2hDdVVevF3BexweA+D3NNX+UgcAIH6OaWUe1wkCukO7NMRKRBoyMsFXBlX//nXVUZDZaWd+gQ8uq+wHqA/wX5Kia15faQqEULJ17NAB9GObeZTW7EuHfkM5uF89oQTb+yPaHA5U0hJMQAKfB0uArajscxCsaZUKW5zN6t0jWgg+20Q6swGx9KKH5OK6wzc0qv7wFAR2odi4wozXA0KIxPTJHGsVNmx+EgHNlyXDLsbyt31cXN5csGQ4ZT6llpoYrKAkC690/a5BpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MK89RJtp8YZiyl9VQsSyxLdwQRMKymm3CVtjYw8/0v0=;
 b=hrXD5ufeu8SRSlECSb5PkACG1/hjfhtpPUgqGoXmu0Ollb5MzYxWg330MnOdthnlVYQ3VpS4xPhFB+blQnvSe2SBTIKhF2bZNUQenIX0qrRH/32+3j6+9BI0D800ZobQca1Wpv6hg7sqJTHE75qmtDVymmFTIcglypWvLP2Ple23uow1Iekcc0gawgg0LbO85PmWu9K4dzChqXzBHb2MJFLGudjyN4DshdCQ8UJQzdBCMJ5VhXm2zG/plUFtj+9HRoUqanuona0xmd5YrEFFPrbRScEwrZ9Q+8TkGaYuZvx9EWWfg9dZtz2h7pdcxGIjT4vley7FqRmWE4I6BO6g7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MK89RJtp8YZiyl9VQsSyxLdwQRMKymm3CVtjYw8/0v0=;
 b=cc6RsBOmBfo1Lrkgwurx6qoujvWHnQeISzEJMq8BcLBeWcM7KlfMOxGJE4PIK861ZdzANMKDkjibbsY+e2OieXiNJCoAhGtaoDFDDtkguiomT5vEN7eceTGh4cgpKa7OZ4uQzHo7aCqXBKvNmKH8tRFVY6boorrsA0ulfSJOhwzvZWY0VoKfzSlYk0ELlVnXWQUidtowMVknUMWgZULnfHrulYWvTDGo/vdpkSe1ExSxyDoyUWZlUc2M4OsB+ThklfDZtpmbQTCkkyOL5pf4O5CeQ9mlSKa6m7ZJMMDUSI3tNl8ooMfWGeD5GpGHEN2QwxYiZUlS4Oz6ABaBq+LB1A==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3882.namprd12.prod.outlook.com (2603:10b6:5:149::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 18:50:50 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%4]) with mapi id 15.20.3977.025; Wed, 24 Mar 2021
 18:50:50 +0000
Subject: Re: [PATCH][next] net: bridge: Fix missing return assignment from
 br_vlan_replay_one call
To:     Colin King <colin.king@canonical.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210324150950.253698-1-colin.king@canonical.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <db4c13bf-e32a-d59a-a491-9a81ca292e59@nvidia.com>
Date:   Wed, 24 Mar 2021 20:50:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210324150950.253698-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0094.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::9) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.2] (213.179.129.39) by ZR0P278CA0094.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 18:50:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eec80100-1976-47b9-d1a0-08d8eef5be68
X-MS-TrafficTypeDiagnostic: DM6PR12MB3882:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3882DF3EF4FFFF403044C836DF639@DM6PR12MB3882.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hjDz7ONUnxSntuz72YanwJLU9Pu2wNqErNV9RO367Ix4KObZR6BlTxXpJHr1SEqO2Y5owRMzNLCf0r2dAdOhLLwytUtqqHmXy8hdpMev+mmXYgUIl0Hce5x4464RyS40lXoRjC+IVaX7vn34ek4SAIIXSMFv8hB53KLCNyviSua4ZgyPG5mvAj9gi2m9zbFeXaFCanabERLRBwjeA9NzSt0EsLEWa7JA8CJX7N9ewi/dVR2y2Eb+BHd+c/05Y4N+UYvYHnopciuFJe2wUvDMqfEv40+QNqB13gDT12RLb5zdb9grelU6eMEH7CIulbuY9wq5PJLOqS36dvRoGykhwFOPLCrQefhy25n5OBndyEySQ0VkeyAFMsgbW1ODuKShnIFvjgJ7OQfawGcyctOmkFUqZ5BIRcoOEtHq9LkBD/SVL0N/eT/BZPQBgZDqxPbTdcY/HwsEiNNDbs+WD/c5sGP0DcOMB/+o0rprMmFr4c8VI4wV7p52CnWTRERxq5MeA687QeDUwOanBNhxykZYtHyMujM/krWxdtq7G7tIMn77/nPfDpZHPmkdAazLuhDwf3EfoWEF9pHnyX5KGu4U/fQOFqq0lfZIZQY524TlmWvZQl7ctSy8tiCvSX7jjmJ/xauSk6iA56yrZvTzOV7emIk3IFf29398Af5uCPZIWlkIDg8mvdM7Hv38fHXZfASUhU4hHCz8ktAoNcFNHut6uZo+4fT5rcljEHY3RZdMqXM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(366004)(396003)(136003)(8676002)(478600001)(53546011)(38100700001)(26005)(186003)(16576012)(6666004)(16526019)(316002)(36756003)(6486002)(956004)(5660300002)(8936002)(4326008)(2616005)(66556008)(2906002)(66946007)(83380400001)(86362001)(31696002)(110136005)(66476007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VjdxamJQNEUvczJjZHRDN05sSDlwNGE3QkRWTjF4N0ZST2VOTVVQaWtneUM5?=
 =?utf-8?B?TWNQblVmWlhMU2hRYjNWOGxwS2JNSVZSL2ZVSjlsdGQreTBFZGZvSzNtTEFF?=
 =?utf-8?B?QVBTSXR3UU00VTdEdzZJQlB5WGpNWkFhYzFwOVRrZUZ2N3I2c3gvdms3QU5U?=
 =?utf-8?B?V21lTC9FSFU5dG4xWmdWWStwR0h1V1N4TWRFQWRQZ0pHVW85NzVWMmIrNWd4?=
 =?utf-8?B?RUNrM0M1K2FjNUg5MDRYN0hTblFybGloWTdLcVBybWx3Z0RuUzk4YzViQ1Fi?=
 =?utf-8?B?WnpXRWJaRHNDeHB4aWVUSmc4TjQwemtKRzhkMTFURzRTeXRETXRrckVWU2Fv?=
 =?utf-8?B?a2E1TEljZVI2cVo4eDFZa0F5VXdWY1o3VjBXTys0ZmlYcXJTS25aU0VZQmh3?=
 =?utf-8?B?Y0RRWWQ3WHZXbm9INTlFVStEM3NpV1owS3lxQ2JqR01BYzdJSk1tZGlUZEFU?=
 =?utf-8?B?eHRiSlZ4VDRuTExKNEEwZCt2aHRXU3FUY0UrNzNpRFhNME1kYUgxekJVMzEz?=
 =?utf-8?B?ek8wSmpBQXpIdExVMTNhTk1VMjFzeGVMbUcvMFY4QkFoM2hqejBpVllaQ0J4?=
 =?utf-8?B?Wnd5WDlGY0FLWHVYYXY2RUNuWlZCOEM1ajdyZk9FN1A5eVZIbzdmWkw5V3Nk?=
 =?utf-8?B?TFhKbzZNeXBxV3ZoeVZRT2FTSTBVWTVNSTZCNjUvOGRmSTM2UkZ6dEJQblZl?=
 =?utf-8?B?Mmp5cDVXZ0x6T2hkN2wvZGU5cm00ZVhoaHNBVWVRK2MzdHIzdVpadWhBUlpR?=
 =?utf-8?B?OVlmY2gwQjhpeGZ1MDRRMm5ML1NWTlJRQkN2R3pMK1BrR2lvRTY2d2FyTllX?=
 =?utf-8?B?Vy9RL094OXhpYk5rdVBNVHlocGlzbnFXTU9pYWQ4TTlqenNjaitoK3hjK1RY?=
 =?utf-8?B?WEh0Y3JiTkJNNGMwQ2lWVTVTZW5zcm44Zmp5NzN3NUd2d2VydWpHdkc4dWNW?=
 =?utf-8?B?MGp6bUlmUmNUQkVZWFBZdFpCZ2NHcW9SeDNJbWhDNUJyeUN5TDczZU1YemJn?=
 =?utf-8?B?aWthRDhtSTB2ZGJyTUMwd3gyZlRoVGJZSUt1bWhncVdWa1lNcERSdkFKa1RF?=
 =?utf-8?B?M281bkJ0U2RuYVNPWjl0YzNrSHJCY1hDRThSOFVrNU55UHdUNmRxWWZLdHh1?=
 =?utf-8?B?TXJGVU5pcVFTT3lhalJBOW5vazFRMWx1dzBpRjlKcW91YmN4cXFQUGpnejZZ?=
 =?utf-8?B?UnVUK1VUNWFXNHEraHo4SWhGUXJCdVlaWjc3MFFkbkFJK1FpYWFNQzdzNjhv?=
 =?utf-8?B?UEZJellUaExhK3VBKzV4dElGTzBUaCtwVFd3VklUd1Evb3ZJWEE2ek1PKzlp?=
 =?utf-8?B?MnZrYWUvSWpwNGUxMDhwWUU2TjlFSVVpV1ZQekhSUzNYSzBWbi80RzVEemRR?=
 =?utf-8?B?YVNWczdJWXdxY0dpWE8vdnR1M2h4WGorakZ0RG5ORzBLL2JFOXBNU1ZzVlFI?=
 =?utf-8?B?YllyWDFPaDdHc2piT3VYNk9Bbk96UTZnRFZ5VDZ4NTVlY0xXYktpZzdxcndu?=
 =?utf-8?B?L29mVUMrVlFidjh0Y0JwUjgwa0NhZitwWUpZdFVMaEQ3eUhZT1BxVTVhZ09h?=
 =?utf-8?B?bWtvZWlKaE9VdVY0d3ZJem0rTXNzc3ZINzFhRGdBbGpnVWNybFRwN2R6dXhL?=
 =?utf-8?B?RG1KMlFOWC9vVndYZ015ald6NkxCVG9rMTFqZG95a1FvaFBtVlluYldzbnV3?=
 =?utf-8?B?cmE0MlhIY1R4ekhhaW45TlNNZ2JwcmZCcktDcnhVeVdjcEFseHJEWDU1cU1Y?=
 =?utf-8?Q?ctKXih5CvYh/utT85IXIFenrUZn7GFyEOgBWvfq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec80100-1976-47b9-d1a0-08d8eef5be68
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 18:50:50.3516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MkbEEjjg+5YGKd/4vNz9nrtjam/XfG0OMYME+nJBa/fYcrO592YGYzaA3IwRP0NriAW+vLMBQezJH4R+oCbAMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3882
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/03/2021 17:09, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The call to br_vlan_replay_one is returning an error return value but
> this is not being assigned to err and the following check on err is
> currently always false because err was initialized to zero. Fix this
> by assigning err.
> 
> Addresses-Coverity: ("'Constant' variable guards dead code")
> Fixes: 22f67cdfae6a ("net: bridge: add helper to replay VLANs installed on port")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/bridge/br_vlan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index ca8daccff217..7422691230b1 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -1815,7 +1815,7 @@ int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
>  		if (!br_vlan_should_use(v))
>  			continue;
>  
> -		br_vlan_replay_one(nb, dev, &vlan, extack);
> +		err = br_vlan_replay_one(nb, dev, &vlan, extack);
>  		if (err)
>  			return err;
>  	}
> 

Thanks,
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

