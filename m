Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7F863E64F
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 01:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiLAARD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 19:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiLAAQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 19:16:41 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EDA59852
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 16:12:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8FB50vVhlkB4OGNcQYa8cSC+Gx/M6QNzQ98ZCf885fbLmu/45yBrphqOf57VG04/AwefDwMJlVzCGMxUJKY5oPo2mBlVP+ygZTSJbIIhyTSl0gosy/uvHQFEpr3MsarUiZ/TBPrWn2EyVGJlPcNwmcLgeOxA9MiL54nj0R7H5+U99rE8+pV9rDepg7dyxEeuRQlp45cwjz4JtfGq1MEXATfFRBuhy/p1feFP+UKTqVhNRsFgDEi1CMWWL9p+vbPXqTll1fw7kPqW49ZqmKzLsf2gvA96r7SZMMguph4XHWCsv2o/GaRkC/UbKtAbVsS8P7/2/aTKXqV2MBb703+1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tn5WzGRSJTlR2NrZshsLYZ42SmOeW6GkA3ZxRRYPLy8=;
 b=GTgE/+F/nMXywjgvhBHjdk7Ir+6D02ncz6X2+TqUcH97R1qQ/oNXAO7WFlVyidKWPjUESZF89PPC8SAz5/cSDr/l2FoSX1rAZkkLdosEQHudLq1jlswaCAR5sBH3pyNwsYBz3pBM9M0NyMibfJ7kGw7PIdLtpFCzvV6PPFhu/Yc8ONvDrH0td2Kpk6t/+4ZIfpsG4HQsE3Ni9+tib1ZgyHAFhblkjQ21pdnpVfpzno+pk0obmCM5nqvQPkJjoquRxt+gRtiQH0n6tOp5BLp1mazH9TAKMXyw3/VI0Nv+dSRihYI1PH1Ql2IiWbRHidmC8nSWUz/QsAd9OML/MxFuAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tn5WzGRSJTlR2NrZshsLYZ42SmOeW6GkA3ZxRRYPLy8=;
 b=Jq6p4h/n1bQHx0e6d9Oo7DVAVdObFTlkmr4XhrK6NGiucUyg6fnUf1QHgwB+Kk8pfAqHfmWNzL1iGWimSh6U82BZAF6zRCqVy/dyMgt/YomDGvqRkAJlMkw4FEf70f14DUpDhODBUvNZV/ooiN75m3eIgAzjYdHp0buJ2rQJVuQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DM4PR12MB5962.namprd12.prod.outlook.com (2603:10b6:8:69::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Thu, 1 Dec 2022 00:12:26 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 00:12:26 +0000
Message-ID: <b839c112-df1f-a36a-0d89-39b336956492@amd.com>
Date:   Wed, 30 Nov 2022 16:12:23 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH net-next 08/19] pds_core: initial VF configuration
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-9-snelson@pensando.io>
 <20221128102828.09ed497a@kernel.org>
 <d24a9900-154f-ad3a-fef4-73a57f0cddb0@amd.com>
 <20221128153719.2b6102cc@kernel.org>
 <75072b2a-0b69-d519-4174-6d61d027f7d4@amd.com>
 <20221128165522.62dcd7be@kernel.org>
 <51330a32-1fa1-cc0f-e06e-b4ac351cb820@amd.com>
 <20221128175448.3723f5ee@kernel.org>
 <fbf3266c-f125-c01a-fcc3-dc16b4055ed5@amd.com>
 <20221129180250.3320da56@kernel.org>
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <20221129180250.3320da56@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0085.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::26) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DM4PR12MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: e19e5401-04e7-4fb1-5702-08dad330ba57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pa+SYePOmconILcHrYJNgTKdQet+HHvYySq9naCpsuVOsodWTjpen22t7C8F5188OVkXofqdFTyY99aIWysRc/w+ZeI/fer5BM+ctfrUsO0D8zxK1U94bzFFN9BOopFN4mpvMV6TeF2DaH/JEyABcyNAYwZawWbmiUxS1rVKwQC2pzLILkehfravvGL4YV39F419LJtwGGHuoF25RV2vWv5NOmmRiJwl9LeYlRCSigxasquT/Kqt5hIWwDrYH3TfQF7uM28KmW+d5hOD1j7xvAkK/ZJHQjNsQkKS/2F1xDE8T/5ea9akU4HNOl70l9q4eVt3Vr1wx6FwfZBs6VsYlhoo0pVlQik+1aCZX1zGqnE37ZYr1AZZAM5kkAMlnnQN5c20ZPa5IbHwd8tgdnWxaiyBwt2wZDoOJ12142r1u6tgaGdT5HQEQ40HLoCbbv5TwZg817YovCckF2Ca81DNqoN2hUmlCiKX05YLJ/4oIpJ1Q1A5AI3AQGE5iXOXrfxKwBCW7XJYF5AWuDgswvkA7pIh/9DcoBW/CDCsB004GsXpeFghr+2Rs7a/+OK8q9zcZ/b9N1JIcK21i7ep7mTm+jKr93w7iZJ+SzSeczNaWtOiFqUEhF9EYKLIg1GUHWU0+yzHLIYEBgi7l0c25on6VYSBvk9tmbRx58bHP0pnSPgLhb+G3ThXLwWp4WZvvSpvXfviD9HzgxDrLK0iTverr6/i9jzNbGNnvnrZXOyKkWWDyc+EVf91SW1eaa5xJFVuM+p6XA6LyFHiVuu3D4mUwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199015)(8936002)(36756003)(478600001)(316002)(6916009)(2616005)(2906002)(38100700002)(186003)(83380400001)(6486002)(31696002)(53546011)(6506007)(6666004)(8676002)(6512007)(5660300002)(41300700001)(4326008)(66476007)(66556008)(26005)(66946007)(31686004)(21314003)(354624003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWZ3SUMrRnRXR3BKOE8vZ1BXSzF0eEQzRERhQjl2cGNtY3hHak4rNU1HUlZ0?=
 =?utf-8?B?SGdWWTR4MHJLRnZDcm1TSzh1eVM0VWsvczk0ZmVQQ2NmM2ZzOFpPa2lJaEVH?=
 =?utf-8?B?K1k2a1o2dGVBdU15TG5hYzVuM3EvMkhSTjZXTEIxaXhKM3ZEdEE5UzQ3clpE?=
 =?utf-8?B?VTJid0pWMjk4Y2V4dGdOYzJwcUlmV0FBaGZDWWxZeGRMS3kxZGtZdjNESUlF?=
 =?utf-8?B?VlpObkJVOWJjUGMyelpUbCtWc0J5ZEVZU3F4ZHZVWkRaZTlHczY4VmN1ZlB6?=
 =?utf-8?B?SGp6SWcrMVVxSGxkd3VJZUttenBIWU5MTCsyTWY5VjB3bG1xMllLaGVOVGdj?=
 =?utf-8?B?cU9UaTh4TWt6QkRUWXBKcm9MeTVoV0RnOWRHOFZKcCs3SXE5Y0N1NUhMVGtw?=
 =?utf-8?B?OEpnay9ta0RFUkM3VHJVMDlaWENpbUZ4U2J0ZFlKc3ZBVmlHanRuTi9Mb3c4?=
 =?utf-8?B?WUZpcHlQdDJzSWpiZ2U0MkYrd0w2QWVtSnRwb3Z1SVdxem5PS0ZycmFJV05W?=
 =?utf-8?B?QlMydWRoa3VXK0I3ZzNUS2FFWm40WmkyZXhSZ2o2QldHTE42T2lmeFRNbTIx?=
 =?utf-8?B?SEtLVXFxU1RRRndFMjBJdzVEUGtGQThkaXpxazk5Smo1c0IwL3hsOUI1L3dh?=
 =?utf-8?B?b1d4dkE5bGxORjFoL3VueTcxVzNZS3hzWEI2UjdWUGV1YmhJc2xUQm4rQVND?=
 =?utf-8?B?ckNGenAzeFAzb0h1K2tUU2twSHFUaWZycFAxYUZZNEhxZGRFdCtLRmNobmhI?=
 =?utf-8?B?eDVSbmJaYlk1N3ZCRGllbW1aYnpMelZYY0NIMFRwc05Xa2ZIcGVhbTd0RDlU?=
 =?utf-8?B?OWlJOUlOTGNFVGRHdkRIam1kdmk5d1AxZENrRVF3RTNrYjZmakk5b0tHSWo1?=
 =?utf-8?B?THdkUUlCaHluT3lXcWtrRW5pZDBZTVc2elloWW0vdWIwWWVPSW02Y1JucG9Z?=
 =?utf-8?B?ZHp1QkRWQ3ZaZjJwc0RFaVZhdTBLSEJld2M3QmtHNktUS2pNdHJPeEVXMEhP?=
 =?utf-8?B?OXVaUUhBS3dPSTRSclJ1OERIZU1ya2RsRXJwZUd3dFhsVitsdzk0TXdTdWdv?=
 =?utf-8?B?TFZEcE9mOVR5Sy9LQVdVZ1hpdW4vNklpUWRtY2dJS3BQSlR6WXZMcTgwanNE?=
 =?utf-8?B?R1lqbGE0MVo3V3VxejA0K25udnJjNG5wVnJBU2t0ZFh6SVJ4anVjeURid3BQ?=
 =?utf-8?B?cFZVeGFVRll1VlI4K3VRQUlSYkkvL0tCL3BSTmFWL25vMitnN1pjSE9lU1pw?=
 =?utf-8?B?S052N0s3cm5kMjVURW1oSm0ySWs1cDlGU05hN0ZDUUM4RVozb2VKUnVxTXpO?=
 =?utf-8?B?ZzRVYnQ5emZzaGpEZUEwdkNYZGtLaHNTeDRaMDZoSi9ObVBCN1pMU0Z4cnJr?=
 =?utf-8?B?TzZHU09RU3VPRlNhVG5qd0NUbXdqTjg3WXJTVVhVMWx0cDNSSVNwUmEvWTNm?=
 =?utf-8?B?UWdDS1E0RkFtVE51MWQrV2NYNzFGVFJ2Qmtndi93aHhkMWNzQ1d5ZVN3MnpR?=
 =?utf-8?B?SUdPaThoZEsyZy9GelNCazMzWUJScVlvVjlpOWF3YTdGVVBtNjA5YldDcUFR?=
 =?utf-8?B?QjB1UHpseHNCN0JVR3Z6QUVLYS9DL0FjeElscTU4ejhZcFF3VDI5WnpKVHVu?=
 =?utf-8?B?ZHlaOUVwSFRWOUxFbXg1RVQwdGpXbHdGeUI5TWgyeU5KWE5wOERvb0tkRmJ4?=
 =?utf-8?B?VitCY1BKZVZoOENXWllCQlRiSFlIeGF0TUtGTmZSSFgwVmVORUxGdzIwTXo3?=
 =?utf-8?B?T3dNbE93ZmpWRTVNRlQzcnNQUlBQTGxZK0Y5bTlNbHMwMkpWUWM1ZTZEMHRL?=
 =?utf-8?B?blY1Z3phNTU5VXJPbWVnMllmVjZ3WkRMVzZyMUdrSlhkU1QxSU43MU1XNkgv?=
 =?utf-8?B?VTdQVDRCZE1NZUJua2RWaFZwc2pOYXZKWWRrV2FOSTZYaWEzQTEyMU5CU2p3?=
 =?utf-8?B?MmhmcGduS0hMWC8rSTFoSXh0bE9ObERMNEk2WlRLVUEyaGJCSDVaQzNrUDNS?=
 =?utf-8?B?VW92bFlpSU5FU0pMUlE1SURPZlJRcU4xSHNvVlpNdFlyditKeVdudTkyckF2?=
 =?utf-8?B?dG1CeDFNRWJKK3ZDREQ0SlZ6Z0xjRjJlS3Y4LzdUcTJFclkwUTI3OXdnQnpq?=
 =?utf-8?Q?rbMvWaesXELZCYreQfrVz0OU3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e19e5401-04e7-4fb1-5702-08dad330ba57
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 00:12:26.5617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GdYKmTtuE194vROpe19Hj0yKKfBcm/j/3qSUplDuC9u00ZIVAKeQbClhpiEFDiWnmOEuyvhNLeGKQdHXw2+U0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5962
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/22 6:02 PM, Jakub Kicinski wrote:
> On Tue, 29 Nov 2022 09:57:25 -0800 Shannon Nelson wrote:
>>>> Yes, a PF representor simply so we can get access to the .ndo_set_vf_xxx
>>>> interfaces.  There is no network traffic running through the PF.
>>>
>>> In that case not only have you come up with your own name for
>>> a SmartNIC, you also managed to misuse one of our existing terms
>>> in your own way! It can't pass any traffic it's just a dummy to hook
>>> the legacy vf ndos to. It's the opposite of what a repr is.
>>
>> Sorry, this seemed to me an reasonable use of the term.  Is there an
>> alternative wording we should use for this case?
>>
>> Are there other existing methods we can use for getting the VF
>> configurations from the user, or does this make sense to keep in our
>> current simple model?
> 
> Enough back and forth. I'm not going to come up with a special model
> just for you when a model already exists, and you present no technical
> argument against it.
> 
> I am against merging your code, if you want to override find other
> vendors and senior upstream reviewers who will side with you.

We're not asking for a special model, just to use the PF interface to 
configure VFs as has been the practice in the past.

Anyway, this feature can wait and we can work out alternatives later. 
For now, we'll drop the netdev portion from the driver and rework the 
other bits as discussed in other messages.  I'll likely have a v2 for 
comments sometime next week.

Thanks for your help,
sln
