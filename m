Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B534C3FD4E3
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 10:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242916AbhIAIIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 04:08:23 -0400
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:56544
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242848AbhIAIIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 04:08:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqoN5rBrZB/fKS906lsHiyIr/kXpixo7xYm48jvFmT9vTzVkkBtc0qOGZbdlFTsZe3TrKjdVAMegGwPP/W+Z3UTXexNGGiiTb3mhhZJJtNYQHJBE4hRfUM2pqJS64vZ21IcaToj2WnUno/bDwoqBtKbaYTGKzFWuZJVapULr84I3bOc/kJfmhIUAFc7XPjSbmHa9L8gZIfDF52cOjHsveR+a+Yu82TxiPxcFT5FLnvmyaqKFxDmlRIwwQCmSpYkOxi5BGStJpbiJAl5IghzhFbCxFqwFqio9ByBoJ7ErBsZ/rExVGrjHBAoQERyFrVJ1UuHPT+VQPddyxX+ipK+ByQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jedP/8EkClnA1BmPqD/+NEkrDohPA5vtPLeLEDbeQQ4=;
 b=jZ+KtcQQIwpqc7gZLxqXH0M80MDsQ/mNX9CvUnoi4fGdFvFs8XzTpo6hdZtqV9WE9/ah7XEej2Kj/TuihEjDB68lWmvAd1WPduA0UrSY37SxXz7M24v5Ks3aAqyw4JEi/8UlfAX2GXh49psIdK0zrMacQntK5hV2efcCuYqZ0Y2e9Gj8NnOwGTZExDERtRkGtymloXxh+8VHeFVGGdmcvo8QnBJA3JiJRHGFmkn+m7odDf2RA70QIeNwveRP67TLLY4Rv131SxQaDpbw/LciA19UYHXYUDalQSXDqeElLrRjVC8d2AD5xpAgTRxARoy2XGG7+fMLacbBjSLIgt9y/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jedP/8EkClnA1BmPqD/+NEkrDohPA5vtPLeLEDbeQQ4=;
 b=Aztrl1eXRpIu3CfasL6WV/tqXH3eZm0XtNrjCr75P1uHCFRck0G9NiV6bBzRLBYmTEfySpBSl9v2heNqr5kTLM2PUQnOFxsZVB2E9JENx34c7fD/PAQKpyTdyWobCGfxr9nUMcOLztvamAV2VxRw6lps0VPRQ2olG0M3u7W/Ia1XWSoiE1S033XiXTS451M95i5PAj21sdP4i31X43u1ijRp7JYvrIxwxlS6Z5wD4Bpd8tVS17xvkGnt7RBIJSz14vylKl74ONmEgmbsqrhEhwPP6OZnFAN2jKVLfaX/kLfO9qzqJV9FG99pBQwq9EIFOtEylTWXrkSelGoRXvuYXg==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (13.101.61.81) by
 DM6PR12MB5533.namprd12.prod.outlook.com (20.179.167.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19; Wed, 1 Sep 2021 08:07:24 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%7]) with mapi id 15.20.4478.017; Wed, 1 Sep 2021
 08:07:24 +0000
Subject: Re: [PATCH iproute2-next v2 07/19] bridge: vlan: add global
 mcast_snooping option
To:     David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org
Cc:     roopa@nvidia.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>
References: <20210828110805.463429-1-razor@blackwall.org>
 <20210828110805.463429-8-razor@blackwall.org>
 <52857ec7-48fc-b22c-de20-e751d51e612e@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <9fe01b5a-0f22-348c-c1d5-16f96b9605ef@nvidia.com>
Date:   Wed, 1 Sep 2021 11:07:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <52857ec7-48fc-b22c-de20-e751d51e612e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0077.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::10) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.240.175] (213.179.129.39) by ZR0P278CA0077.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24 via Frontend Transport; Wed, 1 Sep 2021 08:07:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1fb6fe8-023e-425b-061b-08d96d1f87ee
X-MS-TrafficTypeDiagnostic: DM6PR12MB5533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB55332A86CBDDA47B4719ED51DFCD9@DM6PR12MB5533.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1um8OSsk+6g31emiEPwmtwVFdlJ0U0IRENfErI17fzglw5UrlOMPW7tVe5jgZoi8nGUOhpUR2aY7qNYfUGmJ573u/uo97EZfEDvnRqHmQJNUhNd+2dVU/nVwg/OgJ9NF+JEDC/Rr/zMat+jCDwHNssPJWVon5jMzaN45xJtpeAXcUngHroQ2qIcER4WYxrv/zxbVjE/aCogKCxDnrHlJyDnMj7LmLwydn23QPzyztXyuxJGDsLGWxxZaI+KmR1mxIZBJeeO1U0SSQ7refmtO7DO4NXFcL2R8N2vISJTkwDiVyhjm5Vx+IWXBs++q38Q/ajbzXHV4J1ga0bjLhp8ZiBracjV9If1eOuH4nNAUggoUwfJgjJtJ/H+fpoCD+MKbNt5ebs1b4bTKxU40sehNOx3ajGdAcrkzeCWhwjKQcle87tQWygY/DAzYwHV1YpueBjg49w474TL9mWXOIgzHgcx1yiTDir8iCoEmgnHaBK9TtjYpuhIHMT3aGT896c4jAAkughyi9qfV/zegd0TNnU5iRhXWPulTLmNEn2hNokBBS9ytgzOMROnCNf7sH0gi0w/WtWBjowMhtIZoCRr6TyJqolMYWW2uNeC930utO5IaPZtndcBUVYZQ0lY2RG70hs7oKjDL1VVHfwoS+4qxJtL2CcAQqJ1qS8IXj7ptyYeakHRDWS5BhH/hl5FPqZguU7Shd288dhCLqxPZEytQJfS5DPwfH9e82LvQYTo2sSI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(6486002)(5660300002)(66556008)(66476007)(8936002)(66946007)(8676002)(31696002)(36756003)(478600001)(2906002)(4326008)(86362001)(110136005)(2616005)(956004)(6666004)(38100700002)(16576012)(4744005)(316002)(31686004)(186003)(53546011)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0pyMmdiYzZidkZPSjY5OTJzelg1OHJZVklCZUdIbWVsWmcxclUwRzlYQTNW?=
 =?utf-8?B?c3Z4UGRZYVBvdHhzM3kzUHZrVmlTQTRCdnI0MkhrTVdwOXB3Q1czWnF1cUJ4?=
 =?utf-8?B?aEdDZ1FVUHJleEZwY3ZyTk1ORDVYVlNiWkFWVXRxZW1xMVJsOEZzTUFwbGh0?=
 =?utf-8?B?MHd3TmxCYndXNXNqMnowUFZhVVdvZUZ1aG82ZUpkRHJMV1VUeWF4M2dmQVN6?=
 =?utf-8?B?Z2FPY0lyWkNiei9tK09QWkVwUExEVlR3Nk5qRmF6b3BZK2FJbGwvTTh2Njhm?=
 =?utf-8?B?T2ZFTEpLVnlPbHQ5WDhVekhZcW5pN1NsOTVNNEl1Y2RKOU9rYmhBUUJKRmpv?=
 =?utf-8?B?bUd6THlkQzFIRzFqYlprdFI1UzFwL1VFeUtySjl5ekZoVTRBc2xYc2ZreUU2?=
 =?utf-8?B?WENmT01zNEdtWTFGUFdJcGkvaEc3Q1FNd1NYbHM4SlpLSHd3NStYRDJ6R3N6?=
 =?utf-8?B?WW9uR3VjYWlBQ2hXSnlqOG9NcjhPRDBuemxtdnN1cjRNY0RLVmQ0bldYd0o1?=
 =?utf-8?B?RFppMXgvQ3ZNY2dEaFh2Qkw3aWMvVXdvYlFneldzenpoRGNvUUs1RzV3WFJ1?=
 =?utf-8?B?QnFuZEJobXBsbDBEMXg4YmZJbitNMURNUzh2L0MyZmJ3dXFJT0dlYytLNWdZ?=
 =?utf-8?B?Q2RCaW15Y01JYUVJM2tvaUtpNVA5YU5veVBremNqdVJrVFJMMDNmcmNDVDUv?=
 =?utf-8?B?cGpua05qdjhLOW1scFR6N2liM2NGcWJ6OG9tK2ZodVZaWHNUekQrU1VIc29J?=
 =?utf-8?B?c29hOERWSE56U3AxK2gzSU94a1JOKy81VytmTFBwK1U2UG10RmZtdVhCbXIr?=
 =?utf-8?B?UTA3cnJEcDBWekR0c0p2S3YweEhGLzYxL2MwSEdXOGlPTmRJeEZWajcvN2dU?=
 =?utf-8?B?WHFkaWtJa0M2RDBBVkE5WkRMWVFHb3EyVEF5VmVTWEZvYU9QVm9qd3p1cTZn?=
 =?utf-8?B?V1VnT29TcUNRZHdPeWhCQ1Vub1QwRFBhSGxITDBRQTY3WERSc1hQbHVlVUtp?=
 =?utf-8?B?YkZIUnlnLzY0NGo5M3NzK2VOUE5JZ3ZPWVdWY0JGa3h1YVF0SC9hY3JqZUo3?=
 =?utf-8?B?bEtmMkozQ1pjbk5uQ1YxcEI2M2dIaUY1TW5WenVqKzE2cDdqT1AwTWhOMTJk?=
 =?utf-8?B?d1hqWTBFSHJUaXdxZCsvMEVjR1J1MHREeFFwbVY3aDhzMDZUdlJucXRlZU4y?=
 =?utf-8?B?dU1NbnJNVTE3WkhVM3JSRlo2SGZqNnZkbjlwRkkrY3ZRR3ZlbmRRb0hEWUhq?=
 =?utf-8?B?dnVtbnFQbmFic3l2Q3dva0tGaWlXRnQyVy9UT3N6Rkc0M2dSUndObmNoUUFP?=
 =?utf-8?B?TWt6Y3ZMUHhqRWc1Qi9Ocm5PK3pyMVBmSXh0SXR5NmtTenBBSFU1NWpVTS9w?=
 =?utf-8?B?UHpsc29vT2hVRTF4UFhKcWZCZ0NrcWpoYWJZM0IyL2JLY3l6UGsxUUpsYjdB?=
 =?utf-8?B?R3JHVm1KNnpJQmVLTm94dWwvY2hOQ0FGRE1Pc2FmNGVwU29JbTVseUV4RmNB?=
 =?utf-8?B?SS92WXA2SGlsSTN1UU8rYlBBOUtRdVptNHpUT3RObGowYTk4K2gvV0ppQ3Nx?=
 =?utf-8?B?a3l2MUxSaEMxZTAwYWp5bWdreU9EVVhNQVBmc3FVUDZYSTJDRG5vbFJjdkM2?=
 =?utf-8?B?ek5DVHhXTmJ2a240UlZaUkRZR3d5SGY3bXdVd1VOT3FWRlAyWU9VbUVwV0Jj?=
 =?utf-8?B?NUJGOFlFV25YNzAzMDFrWEJPTDdrZkF1OGlkL2xtSW9LOURUMWxrYk1ab1U0?=
 =?utf-8?Q?lPxD85n1FAIPjU3Ts3lCpk6I2qfcweEi0rOpYAE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1fb6fe8-023e-425b-061b-08d96d1f87ee
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 08:07:24.2817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SijDOvFDG3T2g66F8h72o0rnQHYWQ6JX936gHNII1i6xd1a8MInfjr1CrypriLIMMRRT/jnjtXmT3AElkz+WGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5533
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/09/2021 06:36, David Ahern wrote:
> On 8/28/21 4:07 AM, Nikolay Aleksandrov wrote:
>> @@ -397,6 +400,12 @@ static int vlan_global_option_set(int argc, char **argv)
>>  			if (vid_end != -1)
>>  				addattr16(&req.n, sizeof(req),
>>  					  BRIDGE_VLANDB_GOPTS_RANGE, vid_end);
>> +		} else if (strcmp(*argv, "mcast_snooping") == 0) {
>> +			NEXT_ARG();
>> +			if (get_u8(&val8, *argv, 0))
>> +				invarg("invalid mcast_snooping", *argv);
>> +			addattr8(&req.n, 1024,
>> +				 BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING, val8);
>>  		} else {
>>  			if (matches(*argv, "help") == 0)
>>  				NEXT_ARG();
> 
> How did you redo this patch set where 06 uses strcmp for the help line
> and yet patches 7-17 all have matches?
> 
> Fixed those up given where we are with 5.14 cycle and applied to
> iproute2-next.
> 

Oh wtf, looks like rebasing gone wrong, I'll have to fix up my scripts.
Apologies about that and thanks for taking care of the matches -> strcmp.
