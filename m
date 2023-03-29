Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D006CF4D9
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 22:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjC2UyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 16:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjC2UyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 16:54:04 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3DF5B92
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 13:53:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grtjFasCjQM9hAIbZAeiz1N8OW5r90+BCMkfyfqvZcVzkIB3uEfk2jWKQtqAMFy5dn6QxiYaveMgHuhYuOrlLiaHBGyyUJC8ux3g5GQNfDZ3CDcrmSI7skVcO9XicyQDtDmqAtlH2VVuJNExcxXWtnS7rFSQ/T0ur7d9o/kLWP5+n7+JY++d/4LFzimfkk8QX3R8St8MioDsxN/oND6UQBWPuJpFdLYPX4d0FNBBRsELZraEy3TtqRYuNttZYwEz3APyIccYzCVEAhgWktb1UV5DSUhc6MXrSnyobw4lmu6WcZDW0ZETvuRBlvzMlVYvfaJnoYErfBQqlRg6eocHGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pr3lESkovcTG1agEmcmDYcRSkK1icKQ3xBmEHTiCreU=;
 b=Az1LY9kngTINd2PfMHnZuFpSHoNdy2dzrI1WAYxcjapid/dPTc8eMeAVNc4K9e0dCGiRgQQ9avPLkl2badFMlk+QVyM8V4RQ98zgR8Mj903JoG02cXyD7jwvaxsi1KlW+YQiOI5KQsvg8pGkItkrry+YqpDlSwyzbcM9FbwC5obXfFUMCeV5rORskik467RQ7ozvHW5fiBU56coWM982V12HjmviZOTJEH2jMpP58VCu/EBFp4FFZXO7dF3cXLk/+5Tao55fXOOHDM53rXCmxa4AeMmRZ6cpHrYjsX4y2w4RM7V2qYLYR0eBNehuN/VpBcptse/SWQIqWNm/acFayw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pr3lESkovcTG1agEmcmDYcRSkK1icKQ3xBmEHTiCreU=;
 b=xMOuz3rV6u/l+WYvklFrVkWonbORQxItHQQnIc+Hho4H7jiS/rYRk470rFMZSLfttat7nZvuHZuSVEHx+SBzgfGVnzM1in7LnaHYapBK+Q7inPzTDIhkkfBl17yIRjBaKyHlWQELNjgEAWfTe3f/IRF096LuPcqVNC9dF9vNQW4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH2PR12MB4085.namprd12.prod.outlook.com (2603:10b6:610:79::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.33; Wed, 29 Mar 2023 20:53:26 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%7]) with mapi id 15.20.6222.029; Wed, 29 Mar 2023
 20:53:26 +0000
Message-ID: <45c28c76-688c-5f49-4a30-f6cb6eab0dce@amd.com>
Date:   Wed, 29 Mar 2023 13:53:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v6 net-next 01/14] pds_core: initial framework for
 pds_core PF driver
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        drivers@pensando.io, leon@kernel.org, jiri@resnulli.us
References: <20230324190243.27722-1-shannon.nelson@amd.com>
 <20230324190243.27722-2-shannon.nelson@amd.com>
 <20230325163952.0eb18d3b@kernel.org>
 <0e4411a3-a25c-4369-3528-5757b42108e1@amd.com>
 <20230327174347.0246ff3d@kernel.org>
 <822ec781-ce1e-35ef-d448-a3078f68c04f@amd.com>
 <20230328151700.526ea042@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230328151700.526ea042@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0291.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::26) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH2PR12MB4085:EE_
X-MS-Office365-Filtering-Correlation-Id: aa4516ce-78fe-479e-9350-08db3097a4d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C/TXRmKtlUCEkBjwvCZr5FZTOG+8CC8JlVtChPocovJvAIf9MnxzlinDjU3Yl9jH35Qc4yoXnaxQfrUcoxEGQk2mHNvj7sH75tOp1vrznt/kKG6LhuQQR27GzVvuSygLpEIo+I8/zr0St5tByEZV/1bTzEd3TkDaRzTSAMSR35QS1ueZvFgB78oP7i3WyJVXjmXLS4yg52WcJYwvTXkfwDHoG7mmdZL9MjmnOqsgieVGwEeciU8vpChF3PfMrCyc4nfBoQcgaCGGlPczK24/4e3wrGyTszeWxSN5emAZ/7ABmZrML2sMFoR3TgKvuH+Z+0MArQ/wFU7t7nVX7r/kL6go6lBs4TzOeiyVs6uBP/8Okrxa2z0zR0JxlRBgggb0qxNl1LtRJUZezqDfpWQEObWfCqnNb152gGXV1qhEkKqFx2LR3CqaboZVaYsA5Q/b/LnnjMkXhIp2fT8yAJxOYVzMIXh3jugX7NHbeju+aDUINVrqNdnnMdKMgKfFPWKvSi1m+QVWTHdZd8aqUfApLoUCcL8COFLliTAi3cdGEcH7OIa4eac9oVwwnPZ1NkQORPe9EFdh5YN0oru08Z+PMqFahKZnucGo6zPFSfU4S+QdZqjAB//a43p9Ye7s6+3RRA2XPxtZykPRH9srvTI/iw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(346002)(136003)(366004)(451199021)(66556008)(8936002)(83380400001)(66946007)(31686004)(44832011)(38100700002)(5660300002)(2906002)(6916009)(8676002)(4326008)(41300700001)(66476007)(316002)(478600001)(2616005)(31696002)(6486002)(86362001)(6512007)(186003)(6506007)(26005)(53546011)(6666004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZE5CN1BTL2NTcHVnQURMdC9TalNYd3ZnWDFkclM0NmQ2NzBBUDB6azhyUVo1?=
 =?utf-8?B?ODdxVlZqelBZTEVUK2ZGVE1odmVYRVpSbjR0blNlYU1uYUkwNHVPcWZiQW9w?=
 =?utf-8?B?RENPV1F6QzNGbDBMWGpPVGFlYnI1MEpWL3NMNUovQnFadUVkUFAvWjFiWUhl?=
 =?utf-8?B?UHpjRWc0bXZjSEZrdVpPQkZvZWRHRHArN2xVejA0NzRCcGk4NjBnUW13cnFD?=
 =?utf-8?B?RmY5MjA1RUhVWTZSMGczRGVnSkxWV3crNGFPa2lVcXI4SGNGbVdrRk13c1N3?=
 =?utf-8?B?WHIvd1V4N0Q4Vk5hNUdNR293ZlE3MUdGanNBaEdreWEyNkdVTkN0SmdyTURm?=
 =?utf-8?B?WFlTOTNSVHFHUjdEOTFySU1DUnA1NExsaWFya2pzcklEekZHK1VMODI3R2kx?=
 =?utf-8?B?MW1QeGdST0U0cXRUaXFrRDhtWWNaMTdFZ01GVlNqV0o1cmxaSUJ2QlNsWFlk?=
 =?utf-8?B?R3MxT2svcmUrRjVINkNraG1saGpJRWtnd0dwMjY5U29USm12cFFaNVMvSWth?=
 =?utf-8?B?b0lGcEUyMC9rRWtkSDBKZzc5bGxQR0Vjd3V1cWJSQVdtSVZPSnJSRmhUMW9M?=
 =?utf-8?B?Tm1oUndpM0pmNmd2ZENsei8vUitkQWdqMGI5azN1d3ROY0NuQ3lQTzVYRHFx?=
 =?utf-8?B?eWs4eFFDZEVaSFFFL0FEQzl4aERmYWt0dlJZcWliaUN0aGpXYy9KT08zUWNK?=
 =?utf-8?B?MktBUHkrQ2UzV1VDOHYxUmRkdkRrMWpkTUdCUjA1MUw1QjdnZkFtRzNzbWsx?=
 =?utf-8?B?cTdhWG1scG1XOXEzYTJJSWc1SmxZQVlKdFlDbFgrU2JGYUtFL2xHODJLSkpx?=
 =?utf-8?B?Y1I1Ukt6QkF1Tnd2T1ZqZVNMdE9Mb1BOWFRWK1U5R0FqTkNGVXQ3TzI3YzJk?=
 =?utf-8?B?N3M2U29LSC85YTRWWWtwemlWdHdrbm8wT1pkdlNkTElkN3Q0djVUL09NTkc1?=
 =?utf-8?B?b2dsT0M3NmJMaWJlQWIxZFBlU1lpTlpwWisyeTdzdGNHZWVOTlhEYm1MT2cz?=
 =?utf-8?B?U29YY04zVTVnZVV2Z1FvaTB6SHMyMUU1ZGtiSXQ4dTI4OWdvMUJiZmhvbVls?=
 =?utf-8?B?WGczSkRRZjZsUnkwQzlDejhYQTVLSEUvZmdheWFlR1NwSUljZUdhRnFLQ0RZ?=
 =?utf-8?B?WExRdUZvcERZaW5rRThOckhaN2VYVjRScGFpbUhueUd4TStLNjBqSjZiaU9W?=
 =?utf-8?B?Y2NLVXZxejR6VEwzeVVrQlJZSFN1VDY5dlJrSlFDRUxUVk5yTTltNU5tZERi?=
 =?utf-8?B?ZjIrTHZWcEZSVCtoN1ZlVnEyZ3lKU3hSSFVQQVVBVkF2OHBicGgyVHF6U252?=
 =?utf-8?B?dVhTam9IbGE5MVd3eFJFbDhSa0tkZWdOZXk4K0EvdGpMQnFUeENVMm1veHNt?=
 =?utf-8?B?MWpHckJHRmtXbjBrWTZLSWg2MXlJblpITGxwQTRxUjg4TERvVnBhbjYvMisr?=
 =?utf-8?B?UEpMR3NOZG8yK3kreDNlcklZQ2ZWUW5qY3dUL1RGanNJNkF5RXkrK0hPMzU1?=
 =?utf-8?B?WWdkNElub1lVK2YySFNEbzIyZGpoc29VSkxOeWE0R3c3MkFhZDBoS09JeEUr?=
 =?utf-8?B?ZEFLaWdZTUQxU1I1dlVVOUxyUDZRcmp1QjVVN09JNGFkY3BFZmZzSkNIMkVP?=
 =?utf-8?B?Qm1lYWQ5aHhiclNCdm9PMWRLYWRZS1RhT2dGa2VkSEVnRmxialFtQTBKSEI5?=
 =?utf-8?B?UmFGdmg5em50ZGRSbGxaa2UzTjlJMm1oWTlrMDExWmluYm43TWFqUzg4RkQ1?=
 =?utf-8?B?ZkRqN3VpQS9wOTRxdU1OYVliU05Tdkxja1hSVWg0U0Mrd3dQSG1BNXRqbzVj?=
 =?utf-8?B?aUdkbmRHRXh1VEY3a0hsclpadjc0VVV3cnd1S2dmd0lsNjcrSEJzbUdnWklG?=
 =?utf-8?B?aUhjQnU0RndwcEc3ZE5RSEhMRFdFY1NLa09kZlFyenY2eUc5UVA3bC9OYVhF?=
 =?utf-8?B?cDhFZENtVzRkS2k0eG9UYXR3eGNQSXdiTjg4ZTNNYUo4djd0K3c4c1dQSlBZ?=
 =?utf-8?B?UEV0K3ZudXVNRXlrZG9ZTlVjWUhWb0l3YVVGVmptYkxPWHUvMjdBRmpwam90?=
 =?utf-8?B?WDVGU0lwUG4xcDFLWHh5YXRlbmhWQjdrd3RFQWdBbExJN3AxcHJ4dnhabC91?=
 =?utf-8?Q?sBdVGP8zkmelcERA9a5Jv3e6Y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4516ce-78fe-479e-9350-08db3097a4d4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 20:53:26.8656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hP6S7FVD/Duewi1tBKmsWPtnYhI60iTPDTduzRoqZTgsJNnoqg/UKXaS/TW89TahFRHKnDMkbw6YyqDGov0WDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4085
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/23 3:17 PM, Jakub Kicinski wrote:
> On Mon, 27 Mar 2023 23:19:28 -0700 Shannon Nelson wrote:
>>> What are you "abstracting away", exactly? Which "later patch"?
>>> I'm not going to read the 5k LoC submission to figure out what
>>> you're trying to say :(
>>
>> I'm saying that more code is added in later patches around the
>> devlink_register() for the health (patch 4) and parameters (patch 11).
>> This allows me to have a simple line in the main probe logic that does
>> the devlink-register related things, and then have the details collected
>> together off to the side.
> 
> It's not supposed to be off to the side, that's my point.
> It's a central interface for device control.
> 
>> Obviously, when I update the code for using the devl_* interfaces and
>> explicit locking, those two patches will change a little.

The devlink alloc and registration are obviously a part of the probe and 
thus device control setup, so I’m not sure why this is an issue.

As is suggested in coding style, the smaller functions make for easier 
reading, and keeps the related locking in a nice little package.  Having 
the devlink registration code gathered in one place in the devlink.c 
file seems to follow most conventions, which then allows the helper 
functions to be static to that file.  This seems to be what about half 
the drivers that use devlink have chosen to do.

Sure, I could move that function into main.c and make the helper 
functions more public if that is what you’re looking for.  This seems to 
be the choice for a few of the other drivers.

Or are you looking to have all of the devlink.c code get rolled into main.c?

sln
