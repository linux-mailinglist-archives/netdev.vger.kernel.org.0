Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2299968889B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbjBBUzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjBBUzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:55:22 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DA081B3F
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 12:55:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAp7RQRlRDwsI1C6wwxqgnJ2IJZkDksYELRZi9sB3ue/swCQztqEg8JW3Q0ApFbVhg3sXiybde8vInrHfDOxSMj72gMcFBaZdVG9kPqLe2wq3j2r4TsytWzcBVt2RqAfEpf22FgAWI54PBleCbLuMlUb6Nd+yZxTv3IPVVdTsTKzyHKnByIzYn2o1pgzHlrDgNk6+RMZ0IAyTpY0bLCfYHkJASk8f/Ef4+GMHOHoqjOBd92IVEpA7jKiFymuNCabbeQqiOhd7nw3kQVEHTdOL/UzZOFBUZJG2dq7EzpjiXdGbmn597m6AEDsciKD6Y7Vb0JPKPR9b3Fh+ewItuuREA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AoHKK/QWNmYVtJMASXH4Tz0R+QyBJibW2t1Xr57p1Cc=;
 b=SoHJBmHdNg7/cE5c57/6yHliMD8TbgBx35asM6f9PL/O2QZ126aReszDaXmtflUS5cidFN8m3/J4cg8N2rLrpJhiE+1PFo5QRH88ulHG4GeWZDJWirwJYjYgCnOmX4MIBo6ZcdwRkCiWXS4aRavkx/bAXOpfelimxbdpCDXObs7Pb2j3/9bqrg72cqLvtuYXBKRciuBDlL0fMKm5yuXc0+noGmdIklcZuk/tHJm2gyQJBJJeXvmGITT1++IyYqCFIsVlZDZLMhOxKPN+BWp3Oz+E1r3bCdOErLgktFJr4V0Dx0adbEj98+iwVqlURFUNKS3Hu2HRv8kLu31Xas3Uqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AoHKK/QWNmYVtJMASXH4Tz0R+QyBJibW2t1Xr57p1Cc=;
 b=5BnrWZfWkpFVv7cekqTOMSRc1vmn+MKhqWUfuYv0maL/zJULEwBqIs58tD3PkNz6h+/oDcDWtC0SZ4BrfHCpHyo7gS5sgDs7QH7x1xj3BDj+i+wqrJhP4cMqFBY+pqCrGmTLkt4pNVCAsUqppu1mTwDBEyaed5+FMaDip7KfgcE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CY5PR12MB6227.namprd12.prod.outlook.com (2603:10b6:930:21::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.38; Thu, 2 Feb 2023 20:55:11 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::43e4:6bab:7b1e:235f]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::43e4:6bab:7b1e:235f%9]) with mapi id 15.20.6043.036; Thu, 2 Feb 2023
 20:55:11 +0000
Message-ID: <2d9dbd68-112a-f292-e5a8-1be821d06fc2@amd.com>
Date:   Thu, 2 Feb 2023 12:55:08 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net 3/6] ionic: add check for NULL t/rxqcqs in reconfig
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, drivers@pensando.io
References: <20230202013002.34358-1-shannon.nelson@amd.com>
 <20230202013002.34358-4-shannon.nelson@amd.com>
 <20230202100538.6f9a4ea3@kernel.org>
 <917e57c0-fd37-18a8-a418-c439badb7d41@amd.com>
 <20230202124615.1bf1a2f9@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230202124615.1bf1a2f9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::14) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CY5PR12MB6227:EE_
X-MS-Office365-Filtering-Correlation-Id: a0b38398-49e9-4f49-2774-08db055fc660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lo1S3QyVcuXH3RrZPg1anENTZvFrW0iiVE2tA6+dat+02Ywi5xpOPOG2wgTtxHdLcZ0Zr+QBk5V/BgbssLT/yy+gumdynjP0BtuCKars5MaQ6GdEIYhyuzxYtgH057eAY7IluMLYoUZ0k7BvsSC5rK14yUf+T5NE0OpdrySXK/NCGxBLvg050SoWVVzRDCBmoIJOL3qE6RnM39f5XMaZgMDvHHK7Wb7KLWAWV/4yKwOm7kqVw5gUC5vKwXkBNN3Bo/RitRkwkEczXCJpROGYr+i9FHn2L8ncRP64xfmclShvJJyljIktPec3XjqV0N77iXKIA+7NbBmPq2xlpXImlWAvpr0VQkcHBBRt6/dvuJmuQEavDNtegRfBGJutqT1QlHddu+oyKeD5LgeQtqo/XlxeuQC4gi87t5urmHa+EdEKsKyP9+xOXJRSt/+BPApgSmlNSEtb9SrMuGA9vCETNhhhQCLHSu2b7odfemvagOG5uvnXeY3frO9D/f94aljMj8ghE/Nvsk+zS94EoywwoeS5OhLiTiFjIPO7iMAuGRujX2KCYHfYwKKm8nMarvDQI9e2yKSuKfQ2McQEZATrJnT+jA6r+DA+Q1cI7kGgjzGz4rrugiNGgq4NmOuhb/u3UPOA7uSRiezSAJgevlu7/9VtitkvHMVg3689vm4ef2Q1pn1WqtnBl3/auZ8tKu3HMFMkQxrCTsED5wu/yZivcY26qpt/Rj0UR5YJ7DiLFIU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199018)(6666004)(31686004)(36756003)(66476007)(66556008)(31696002)(316002)(8676002)(4326008)(41300700001)(5660300002)(6916009)(8936002)(66946007)(38100700002)(86362001)(26005)(53546011)(186003)(6506007)(6512007)(2906002)(44832011)(6486002)(478600001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWlJSVowVlFWMUwvc0E4YW9YZS9yTmFMTzBOVmZDaDE1cDVPYzZDSjAvK2hr?=
 =?utf-8?B?NDRxeUo2cFUyUlc0YWdXYnVaVkJHV2dqOEY3alRjZGdsa2Z5Skg2S2lvVWo3?=
 =?utf-8?B?MDhaRHN6eTJsckxoWmdVRk9WTk0yYTc0ZXJxQitJVFhRSm85MHBJTzVqYXBR?=
 =?utf-8?B?S3pnTk4zQW5tcmxTM2N2ek9NSk9ZVHlBUjREYTdZeDRaZjdTV2p1ZTlUVTZE?=
 =?utf-8?B?bm1oVjZkSVUzMDVmTWRxdXJOUzJ1aE5obnlCQW1ZcE8ycTVBcUFEQ2h1azYx?=
 =?utf-8?B?R2tiYlJIcHhMM01ZK2N3aHlwQ2FEMk5JaFFOMWZmSTluQUMrRUlvcm9FMkNi?=
 =?utf-8?B?NFNjN1o4Skh6eGppZEkzNkUwL1IranJKODJNOFVnaGlCTUZlQll6L2t4Vkty?=
 =?utf-8?B?S3ZuWjNMbFpTc2lrTE5MYlZjSFI5bDVYWkR6L0FjbW0weWpyTVNPeUltcVFQ?=
 =?utf-8?B?T2FCY0RLdnZPYkVaUkk2NGtzSkJDcGpYSjlIVVdna1lpcDBmZUNpZis3N3RL?=
 =?utf-8?B?dFE5Zktuci9DRDI3WlFGdEU3REdwUStHUGpvQVhoQW9wMzFKd0Z2aklBZDda?=
 =?utf-8?B?Ujk4aWN6RnFSOCszdmZTVTFnSDZOd1dFaVFwVTFnYUhva1hhQnYxOUJZbnZs?=
 =?utf-8?B?RzlwV3lIcS9qT1ZVWDhybExKaS85ZDZGQ3FUT2JaTHpyU0NRY05NN0FLdjUw?=
 =?utf-8?B?bDRTM200ODZzaU1DNm85Vy9PU001WHExa1FMdWJrR1JUMDYyUmd5cnhJbE03?=
 =?utf-8?B?QTJoMlRoSWxaZW8yeUUzY0hlV1VEODNEQVB5Z05NVGRWdTkzcGd6dzhzM29u?=
 =?utf-8?B?MC8yYkpDY0w2azZoYVA3QzAyM2ZpWGI2RjZjL2dnQ25qMm1Wa215eU42U3J5?=
 =?utf-8?B?YVlydXNtUE9HVHQ1SWFUbXNHalYrTXlXMFl0RENBNXVrR0ZsUExzQUdVYlBw?=
 =?utf-8?B?MHNkcFliblkzMkhJMDh3dWUwOVIwTGRJS1dnaEVJYm5pMFdCV1pVZzgrNTBl?=
 =?utf-8?B?RFdRYm8wSEtUeklRSDhQekhKejlYRFhFeWE2TkJqaE9pZ1M4RFlWWDA5aExT?=
 =?utf-8?B?NVBmeCt5M1Zud3ByOHdLY29PRlF4U3FjRWlVbXVvSUlGaWhkeGljNHdVU3VW?=
 =?utf-8?B?NHJXTmVsVTllQWxDck9qUE11c0Z6azMzSU9ZdnBQZlZmajZvQUR3WGdOaVFS?=
 =?utf-8?B?Y0gxVzRmdm9Yd3Q1bnZaa3lUZHBvWDNjelJxZnJvditmMENjWWZnazJWN1Vk?=
 =?utf-8?B?RzJ6YkJkaWZDUWZkODBSd1hid1hCdzFZWE1ZRW1iTTJqbWVlZHZ3MWc3dHBR?=
 =?utf-8?B?Qklsa1ZmMFpaQmRLSmdpMlZPM2JSSDZDUzdmU3RYWkhzdW93MmovcDR0Qzlj?=
 =?utf-8?B?WnR0b1FHTkdlTDloeTdaVmJ2SWI2c3oyemlzalc1eTE2dWVhYXVXOGtDa29I?=
 =?utf-8?B?bHNtRERwQnQwVXovalFsRGZ0TDA0Ulo1cURjemd1MHg2NXBTcVRlYisxNTRi?=
 =?utf-8?B?Tk01cEs5cy9McHNvYmtDbWFaVnFjaVVFbUY5dUNUaDZDM1B5SkMwT0FxYnNK?=
 =?utf-8?B?dFRHTXoyL1dGVng5OE1hZ0N4TG5kZ0RZY2FGT0E0ZFZKWEpJSDhLVEdzY0JY?=
 =?utf-8?B?ZmUvRW9TL3VITWpWK3JES2lyVXpYY2NMMy8wRmVvdlRFR3FNeUhyQy9HQ3FW?=
 =?utf-8?B?Sm50dmVvNEZKamY4ZkNudW1sZk80UzhudFY2cGdDWEdiYWVjTW1tUHZ2RHVE?=
 =?utf-8?B?WmNJQlRuQWxsSXhRSFhpUURYT2hZS3RnUm9rMEZBZ2QyaU9ONnBzMVQ2dU1j?=
 =?utf-8?B?cThmZWplRFNKWVBJd2grRVFLRHRidUdBRTkxSVVGYlpSZFdzNHR6YSt4ZGRv?=
 =?utf-8?B?NzREUjdpNmJIa0h4NEh5T2crZDB2N2N3UHByN003anFNUmZmUXBxaElEbEdM?=
 =?utf-8?B?ZnUxNklURVphU3FHTGtKcFVtZzVVcmVlSWx5UHhjdTRvVFN3Q3lmbGNGTk9F?=
 =?utf-8?B?Qzc1OVQ3STRONXNCVHBkclRMV05WWG1QUmVJNEVUZGVvRFU0b1ZkVi9qQWE5?=
 =?utf-8?B?STFHN0VZV2Z4K0EvR1pQd256Wi9yRnN6TjVrVWQ1ZXNIN2JOWU40UEJTQUJT?=
 =?utf-8?Q?c5JrO1ZaLcmpD2MVciQZ2XxgP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0b38398-49e9-4f49-2774-08db055fc660
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 20:55:11.3154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fihN8U7BrnQFHad8TE2scnDdmGFxttd5Iy8AB6QBQQJYSSMy6VrGwMMSuDrMb9siPBdMKECT8MSIs50U0Llx/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6227
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/23 12:46 PM, Jakub Kicinski wrote:
> On Thu, 2 Feb 2023 12:06:52 -0800 Shannon Nelson wrote:
>> On 2/2/23 10:05 AM, Jakub Kicinski wrote:
>>> On Wed, 1 Feb 2023 17:29:59 -0800 Shannon Nelson wrote:
>>>> Make sure there are qcqs to clean before trying to swap resources
>>>> or clean their interrupt assignments.
>>>
>>> ... Otherwise $what-may-happen
>>>
>>> Bug fixes should come with an explanation of what the user-visible
>>> misbehavior is
>>
>> I can add some text here and post a v2.
>>
>> Would you prefer I repost some of these as net-next rather than net as
>> Leon was suggesting, or keep this patchset together for v2?  I have a
>> couple other larger net-next patches getting ready as well...
> 
> I'm not sure what the user impact of the fixes is, but at a glance
> splitting this into separate series makes most sense. We merge net
> into net-next every Thu, so if there is a dependency the wait should
> not be too long.

Thanks.  I'll resubmit 3 of these for net shortly, and pull the others 
into the net-next list and send after I rebase tonight or tomorrow.

sln
