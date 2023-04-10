Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14306DCC91
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 23:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjDJVGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 17:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjDJVGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 17:06:05 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F952125
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 14:06:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWPnx7CVHEZNDMNagn6bAuR3l5aGX3HgkUkmS4b0ylRDEJFVXkI+2VPs4tIqi/xbl+dzlp3sl3VKmXyzgT2HDcnFLokTlwYInQiTb8KLRVmPA+hxa0t9gfmS7/Zxmezhd8QNeKWOAvZHX0huO2yUCyXkZ59TUQken38uTHm7Fvi1ZFtDYFLF9uFdbqiHwQ/XnY7fN9KN9oaWitFZnnKTXwOQzuFJwHUd17lBi+SQhT5ag1UQrsjAj6sG/rGIybBd313tA/Q5jkXmJqcE9szsKXX30JfVT1DEmt5phbe/BYk6aM0DvegsYpHbZYdxTo8OREV9TnFWCosUctiGhZSu6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNLWKNo6PKsSearuDLXmWuBG++jLL0SUQ3CnOzHVT2w=;
 b=hv8iVuJACHj3eFwkYs5+ssykG7mI5amLh3RMh0rwEVogRZzvA3VCqgu09GfW+MdhXLZcVLH8BAeh31o9OqjeqfIdfdrCL8QYPzkr6wnIJsWksxECUocUUZH3a9TeE2LceR9Xaygi8Vq2MRrfBwp4B2mTS2sBZQd6UTUvblhmKw7kTy+udkRaT6osO4EuQBlfgZ4UdkwxpsP+UNKfnOB7Pqy4tqAa42GbI5b8thYpnu9y/IkLQNCvHloEcp4LeI/hkXR/u0PA0Th84CaFDoqqyNzr8jiXbwAOk/4HFkUV2I9/ez4FJsz5/M2PpzcsdWj8+iPxr039ekUGsThExcbyzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNLWKNo6PKsSearuDLXmWuBG++jLL0SUQ3CnOzHVT2w=;
 b=ziEUqSTPgULcI5L+qtKhNbH8JhAoOajJabKPit4Md+lcl0OHftIXR9kQBPh4HdpOp+qQ8YnSviexFs/Ze92aPx1PexYLPmx+dDTEf7VIp5fpcVFUzK8fX0tvSfaVB7DF5BfVuZzSp1bS/WwjeChVJ0RGFw8xca4UwUer0w4Z3x0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SA1PR12MB8987.namprd12.prod.outlook.com (2603:10b6:806:386::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Mon, 10 Apr
 2023 21:05:59 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 21:05:59 +0000
Message-ID: <c30e9a58-9bf3-b2fa-6d46-0f9143ee1567@amd.com>
Date:   Mon, 10 Apr 2023 14:05:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v9 net-next 00/14] pds_core driver
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, leon@kernel.org,
        jiri@resnulli.us
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230410140039.5c1da8f1.alex.williamson@redhat.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230410140039.5c1da8f1.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:a03:333::34) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SA1PR12MB8987:EE_
X-MS-Office365-Filtering-Correlation-Id: 167027df-d906-4669-2852-08db3a076277
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c24IPJo/8la33NL0L90xqw59ctOaHvUzE5ADCZB1DiGOs6jwAx2vrOBMF5cGyfk62G2v65VoObNjMeW9P12LAwcXgKn+RgSQ9RdGAmZomZpholVNzCdUhF81nnTECFY3O+Eh0mKHQFHwrjiCq9EoR7NZa890p37c80GilnyYX2/WSBdzlWzKPX8YxUP3mg9u05j+Y1/q0Mx0Ukj8ekEvbYAzf+erFyoEFqoPlvAv/y/sgU++Ys0hI0/6Xx6J60kqkPVbpmUfK2l92vky/kyeczhx3NT8YF913EciIRk8bQuv2aTupbnzC+OWkxk9bc40SOL4YHFNS1qEENSvpBH71xPi54+Ypj2hR73w2cgAKMtrF/nJtebIKh1+N2mndrdXYapQUB07CKMM+KWNLJvLsFxEBjBPVEqki5I3jR0DQe9kwAVEU2Vyi1GnBoecfQKOQsUH8NIKlglNFe5KlGHj84O2oSyQ0jDxNcL/oBG4pi+++fVoXnZTxyQ9j8/lCcfNw7yW2Wn4yrUMfaKq3tqiAsiniOz6ESP9+4z4mN7M4DcT6fcWOQFGnfAjw+57fSSst4Ib7Z2SjRcCx4HAMpEWgkBRJI5voRwsNgf5vBFwQA0i9OETyRR3HZbXkmQUgg4/fOKZ5qmdJDKF64dUCeBBOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(451199021)(478600001)(6506007)(316002)(53546011)(6512007)(26005)(186003)(44832011)(6666004)(6486002)(2906002)(4744005)(66946007)(4326008)(66556008)(6916009)(8936002)(66476007)(8676002)(41300700001)(5660300002)(38100700002)(86362001)(31696002)(36756003)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFI1NldxTmNDSVNiQ1FTRkZna2YzYzlIaEZBYUlwNWwrMStWMnQzK2c5T3h1?=
 =?utf-8?B?Y3dCczc5MHR5dkVLUSs1QWJRalRuZzJsOG82cTJXamVCdDkxWEd6OTNaRXgy?=
 =?utf-8?B?NWxxa1ZJU254SFlXSnBnNk9PcCtFVjMrcWNHTi9OaENiVmRiRUZrSWVHNlgx?=
 =?utf-8?B?VDBZUkRWTXQwZjJncWV3MHFMWlpHL3BPOEd6MUp4RnpXbVJ0Sm5vVmNGSmRn?=
 =?utf-8?B?a2Jxa2dpZU1sSDhMeTFINzVmMGRvVzFwcWtIemtwNjdSOFgwWVl4QVhIU3My?=
 =?utf-8?B?K3VPQXZPNGxxZUJPaVdrL244a0xlcW9IY1oxcXN6TnU3MHl4NGRJbEwzR04y?=
 =?utf-8?B?TmFVL2VyY3pkeDVZRXVkSW5ETjAxNThxNHRrRjdoS2hpcWhjTTFUQy9CVk8v?=
 =?utf-8?B?ZUw5cis0VE9MbEVqSlNmNHArRXpnS0U4ZzNEM01PeHBYa3NrMUZmcVRFeUhP?=
 =?utf-8?B?THRWU0lrbnpCRVVCQStCeDB5RzViblJ6bms0U1kyZzU5U0FLaElyM3VvckVB?=
 =?utf-8?B?dUlTWU1ZMVR0TEpaMmVic01yWklzTUVCR2cyTUgxbXpXcUlKamk5L21Vanlh?=
 =?utf-8?B?ZmhOektHQVNBdmdSTFZiN0VHZWttMGMxWjNSemJoazJzOTg3K3IwQmkzQ01s?=
 =?utf-8?B?ZDFLeENQQm5oTS9ETmFkR1VGTGJReUE3Z1R3TDlGb21qeGNrYTVpbWN3QjUw?=
 =?utf-8?B?azNTVmQ3TWFnSXg2eVhtZFl5czdBVkQ3TnpnL0tXQTQwVUwzYm1RVS9KS1V5?=
 =?utf-8?B?MTNyZVAySzZkamZ2R3lnMEdtb2tPdWxST2ZFanJ4YndiMWhSbjNQNE94b0xa?=
 =?utf-8?B?SUFwSktGdDUwVUpsYWVrM1FyRVNKVklvZDgxejU2VEMzVzBNa0lHZGxWUHBF?=
 =?utf-8?B?aHR6dTZDK3FXa0FGcFdxSWRmblVPaE5WUHFKTVFuY08rQi8wNGw0V25YcXov?=
 =?utf-8?B?U3Y1a1ppM0p1STNtQ2xBaEpPNHh6eVdldEVLcklHRzJUOHhYL2w4ejhCeXZi?=
 =?utf-8?B?QkJhT25kOXJ6TFYzbVZCWEZDcHc1OTg2WkM5TlNWSnV0azFRMitkYUpsZjdP?=
 =?utf-8?B?VzduVGxUOWVrL3RlczZlUFVidklMQUtIWlpxZTJwSGJlMjEzZVNZUmRUSEVw?=
 =?utf-8?B?Z1JicG5RbWliZUh0aGlPdzliZlRqUWtPS3l1enNTc28remtkdE5WV3p4TzlU?=
 =?utf-8?B?dnpOdUpwd2ZJSkE3RzN1TGtZQ3VtVVRXZ241WEUxZFpPdVI0aHJQcGYxL3hy?=
 =?utf-8?B?SWRzdXVKMXdVYzJRdFBFOStjT2tEUVNYaVcyS1NzcFlTV3F5VlcySGJ4Vk81?=
 =?utf-8?B?eVpOcmlramxSRUIyNy95NkdVMTltOXdGVENOSmZ6ZzA4aEQrbjdMU3REUGl5?=
 =?utf-8?B?eGlYeCtvSml0ME9TNEFqMFcxamx2SWNDbkFzMmVCVkk2bVFVdmpiVldrVTZ6?=
 =?utf-8?B?M21xc09Dd2dwWXpiTUFLTG9RdlFxNjJaRDY0NG15azBlcWF6OWJydzBZVEhI?=
 =?utf-8?B?dWRiYjZxT3VlR1BiTnZoUzlFRzZFTHJMUFp1TjI4M2NEUXlRS21RVk5mQU9p?=
 =?utf-8?B?aVZ5SnFZNmpPbDlOei9ocFBCUzVJU3BxU1FBV0VxdklYbXorYkltZHc3bjJZ?=
 =?utf-8?B?ZTh0dmZZVEVaVnhKZ0VSUXBlb3k4Zmd5L0pnUVVwMWZscVczYVRxcnNrVkR2?=
 =?utf-8?B?RTY1bkREOWxUb3dEaDYyUFMvMXA3RjU1MlUraks0ZlFZUE1XVldZQlZaMUww?=
 =?utf-8?B?dTVnQlI3eTBXT2Rnci8vV0tCMk9OUDI2Sy9BRDlKOXpmaURNQk5iWGliREpj?=
 =?utf-8?B?NFRSdjc2WitjcWhiSGQ5dlNlT0Q3NkhrMEZQa01yNUMzMUE1RjhKT3NkQTFv?=
 =?utf-8?B?T3ZqQTNvR2NQR0pDdWVXVWQyUEIrd2E4WVZNLzhFME9mMGcyYmFjR1Z0SkVj?=
 =?utf-8?B?R2dwaWIzTWNId29lWjRHcW50eE1XL3J0RTd0eUxHNVp1RS8rajRTS09iWkJj?=
 =?utf-8?B?cVF4cFhpazRma0YyNGpveGZ3VFNaMWN6UHlYM1Z2bmxsQzl1ZitXOGdkRlFk?=
 =?utf-8?B?QUluYjFFQTlFeUhueUg5RnNGLzQrK1ljaVd0QllPdUM4QTYvSnJoaFJaUFNj?=
 =?utf-8?Q?fCyfTS+jThU64h107YSi5xK10?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 167027df-d906-4669-2852-08db3a076277
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 21:05:59.6316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+8sIFVSIWH4roaLw1EeS6IXWOYYPR4n0m14JWM1PAfIP280Almnkz1NF6B/fMIJEbUmc6lhdD3OuUqnImW/fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8987
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/23 1:00 PM, Alex Williamson wrote:
> 
> On Thu, 6 Apr 2023 16:41:29 -0700
> Shannon Nelson <shannon.nelson@amd.com> wrote:
> 
>> Summary:
>> --------
>> This patchset implements a new driver for use with the AMD/Pensando
>> Distributed Services Card (DSC), intended to provide core configuration
>> services through the auxiliary_bus and through a couple of EXPORTed
>> functions for use initially in VFio and vDPA feature specific drivers.
>>
>> To keep this patchset to a manageable size, the pds_vdpa and pds_vfio
>> drivers have been split out into their own patchsets to be reviewed
>> separately.
> 
> FYI, this fails to build w/o DYNAMIC_DEBUG set due to implicit
> declaration of dynamic_hex_dump().  Seems the ionic driver avoids this
> by including linux/dynamic_debug.h.  Other use cases have #ifdef around
> their uses.  Thanks,
> 
> Alex
> 

Oh, good catch, thanks.
sln
