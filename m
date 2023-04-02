Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0726D35EF
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 09:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjDBHik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 03:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDBHii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 03:38:38 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4FEA269;
        Sun,  2 Apr 2023 00:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680421117; x=1711957117;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UjI7VnggVFkIbkR3kPEgyB9DCsGOgKi5dXahw8aPuvs=;
  b=Ix0R655ZV4LRN+rPfDatds0uygisX25GV4kgmH+ASYtTLNbOsW7a34Kz
   XayG8o/rNdSkMEdG3MNcIMDG836gP3zuO5yVQV+OMStuTKE+X6YFcagbz
   bPIzXopg/92rDI2EUS2sQnL1FuWc8+eMCg6RDVjpcURZYl6iboSWpb31Y
   0XDxiRxcEwgeabWRhxPuZcdQ1uqiaMhNFSExpIG+xJ9pNgaYJsYO3JRCd
   lbaR5y8e9GaJvSrjX32BPOqxwgWJSkqfuDisXsZo5jh5GY015mR5jLy2E
   qdOq2QL5OKh7eJR1DflFL4sfi9+V/hgc5nhLEsT/0XgJk4lGiYqBD2++c
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="344264817"
X-IronPort-AV: E=Sophos;i="5.98,312,1673942400"; 
   d="scan'208";a="344264817"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2023 00:38:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="662850578"
X-IronPort-AV: E=Sophos;i="5.98,312,1673942400"; 
   d="scan'208";a="662850578"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 02 Apr 2023 00:38:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 2 Apr 2023 00:38:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 2 Apr 2023 00:38:27 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 2 Apr 2023 00:38:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMFRPvFZfVensfxJVbkMFYpW8Il1wXDfdtb+J2e+Hsh5kuxyoIajdqp2Um71LE7AYcMgRdblmzCkD6uVzhjUzQY7iO2e4vrzAT1wjMAioCJuS2iYGSLTZqAaGerAK1Tn3pc1oiBrltWONe+AAjE9VKBu63/gFfKt99OpLi+nTGO8J3B/LdByo0a2RTJiGorq05NIUkVhu1w4AF/3Cnruksc/d50DNXOQVcf9blGGSr/hMlfdcrDqp4mGhFm8TSDV1p//RVbRn30Nb1mv9pZgmV3SeQLuqSujIp8ZOxV5mB2kQTlvZkJUt8uciIfBFCJPYvCuDY3DiNYxS4VQyDGfkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=naXQBteNQXvLhBVdeTi+SZiUKzXV9syJCJn9obtbq98=;
 b=bqJHkfmsiXCeRWF8GUVCH34OEalM/ZcyQ+k8FnJ/mSdO8fUsrTDeJRQttsbC0RvE+urjWrdkffHEQEGwJHoMn99MXRLFWTUImtPqTytPorTAlwz7Pc9Q4fQNKIsvbF1z6CLvOxrZAHdSpdHCtgyRDsdZoYTcsTS0YIEhb2jQALnq+7k+5arW7QTnRL2LUfW4Q33B7WJqplDd0v2SZT4fzNiRCgkVctBh49IesGJPIEnapDoZ1uPFt3o1dTcgd+WoxpHfmud0mrI9oFQ+oCO4H8Hyo4oYupg+mgAtj/iDw5BYGSXHgxJsGtmVjY2BUVWUBzg8oJJZUdWYZKnrQWxpDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW4PR11MB6738.namprd11.prod.outlook.com (2603:10b6:303:20c::13)
 by SJ0PR11MB5150.namprd11.prod.outlook.com (2603:10b6:a03:2d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Sun, 2 Apr
 2023 07:38:20 +0000
Received: from MW4PR11MB6738.namprd11.prod.outlook.com
 ([fe80::da3f:5b37:c794:5a46]) by MW4PR11MB6738.namprd11.prod.outlook.com
 ([fe80::da3f:5b37:c794:5a46%4]) with mapi id 15.20.6254.029; Sun, 2 Apr 2023
 07:38:20 +0000
Message-ID: <a443c61a-5432-6d81-9fc5-c21feff0011e@intel.com>
Date:   Sun, 2 Apr 2023 10:38:10 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [Intel-wired-lan] [REGRESSION] e1000e probe/link detection fails
 since 6.2 kernel
Content-Language: en-US
To:     Takashi Iwai <tiwai@suse.de>, Jakub Kicinski <kuba@kernel.org>
CC:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <regressions@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>,
        "Meir, NaamaX" <naamax.meir@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>
References: <87jzz13v7i.wl-tiwai@suse.de>
 <652a9a96-f499-f31f-2a55-3c80b6ac9c75@molgen.mpg.de>
 <ZCP5jOTNypwG4xK6@debian.me> <87a5zwosd7.wl-tiwai@suse.de>
 <20230329121232.7873ad95@kernel.org> <87wn2yn43q.wl-tiwai@suse.de>
 <87edp6msra.wl-tiwai@suse.de>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
In-Reply-To: <87edp6msra.wl-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FRYP281CA0008.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::18)
 To MW4PR11MB6738.namprd11.prod.outlook.com (2603:10b6:303:20c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB6738:EE_|SJ0PR11MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: f34421d2-d65a-4d79-df0d-08db334d3af6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4IjPmh/GFix8StqE3fmpLmQN76VO5Zoe4R05fL4UUJ+/aeVdB6IOfe6vqCeMufnufs3oHveXr5U0rV4fIXGrgdmqGVgOJosNkf+KE+9peOlqbRsQVSzV5UVd9FvPluNdQ76ynwc5wINTklHC0sE2nNlvnPLt1l0lhcsmwZgX5C7/4bBUeG6xfhc9i3R0FkrYCuJ4UkjfYa/83Ee4RAkk7PKCw7t1wktZO2CsqC3qkN/6Id2mEob8Z1bv3Patvn3UjYCRKRaRHENpLaMyzVJ4j7suKT0/xDyMES2tWnO5fdNiV3R7LWbqCAjA0VjfkDUaFETgRTyC6lnmGckxfEEp7yrJh0h5Y7x5Yi8Xdc7La6VVq0RatoG0cWcAmEipC6bLgBDt4WTk3t3vj2LMEFdldKcxgo48rN4Cz+cn9pPG7sti4WM8cCT59rgcZTx32kDC53EVfNLn2ApQLipzwP10bh0VVk9bsp0IvFWjLm5Iws4JFF0ix4UdQgSdgy7meGULNFOluQqE+1TREbyoD0MTC868DfBdlDPIo+/7oIRFHiQfdFdV8JsEVzWU+WoqWRmJqtpv0TtPW0d7ZePZNdSpu+1XtZdVhdpB0zXevTaBuicqMRamt3+LQEsK0qlSyzVbCH350+9kL3GzZ4+ZocWWdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6738.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199021)(26005)(31686004)(4326008)(66946007)(6486002)(110136005)(316002)(8676002)(66476007)(66556008)(54906003)(36756003)(6506007)(53546011)(6666004)(107886003)(6512007)(38100700002)(2616005)(186003)(83380400001)(41300700001)(5660300002)(8936002)(478600001)(86362001)(31696002)(2906002)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmVkcVVXdFVrMWF1T2I5dFA4WGU4YnBCZkFvRWZ6Z2IyTUgwSCs2YWdYeEpM?=
 =?utf-8?B?THNWVjhHMG1sZmVLTXRhV2ZkTFpVelczaHdFRk5Oc1RzVDJhWmFsZkR6U2hx?=
 =?utf-8?B?dDRFbU1MSGZ3SUROOFpadGlZRHJvYjI5OFZ2cENnWDhLTzJaWkJiL3Flek01?=
 =?utf-8?B?QmR4UUZqeTVPZUswWHFBZFVHNXI5V0lpdTQwN0dlR1l0YXpyRzc2Q1hmTnJY?=
 =?utf-8?B?bTNYanFTcUwybXlidVlSb3lXeUV3dlhhaDNVYTBEd3BubHVaNFEvVmkyekh3?=
 =?utf-8?B?SlhiL0pyQmZVbEhIOWVSQno2NmgvSG05dVNaMzJPNFhkYXRsdEh5NGZZS05V?=
 =?utf-8?B?bWZpbjVvQVNpS3JMNDNuNkhLd0pTR2ZLcXJJbkwrYlJQMndVMFp1U3lvd2J6?=
 =?utf-8?B?ZklCdHMwYWtyZ2NpL2J2WnV3UGxsY3BIa3MvLzVnNzBkVnlBbXNMOWlZUzFr?=
 =?utf-8?B?M2pMekNBY01qYkUvdUFzU0hNTmFKZW1rM1VXaVBHekhnQkJKdGpRTHYrb1V5?=
 =?utf-8?B?YXFzbmR0OWovclZsS01ZOHBFNjFsMWlZVHJSQVhBVCtqcDBzQnp3cm04Y3VW?=
 =?utf-8?B?cURPVGY0aytrM0kwN3FSSUtwS3NDOVBVT3NrUFByTGJ4a3RHdS8wL0psYndM?=
 =?utf-8?B?Vytta3htOFhST2s3bWwvT3hralVIOW9xU2ordkp2NTcwN2EvRjR3TkhUcUVI?=
 =?utf-8?B?VTh0VGs2S2tod3VpdXJnTmNBUlNpWXFFcTN6ZEMvY2tPVmlVT2xqR1FpNUJp?=
 =?utf-8?B?Q0owQ1N4R3BOZ2FzZ0JWc3Y0TlZXcmNjWEVXZlBmbE95bFB5ZGZQSFlab3BO?=
 =?utf-8?B?ODh6OEN0YkQ2N2NJVUNuS0IrdVR0TTNLT0luV3ByNUxwTnZhYW54T09QTWJ5?=
 =?utf-8?B?WmR3RHpiR2VWZVF3ckNQRnQvTnp4eTMvQmllWG1TRHpTbTJJWElzNG8zWisy?=
 =?utf-8?B?UEZMWUhDa082Y3lKRFYrWkZDTjFwQ2ZVcXMwc3FJa284b2VRbDRJcGVLZDlD?=
 =?utf-8?B?Uk1iSEJFRURvWC85MDJBVDBjanJPSEwwQ3J3VUdYZnZaeE9Qck0xWFlXTDFh?=
 =?utf-8?B?YS9QZHU3RkxzaCtGL2JzRHorZTByOU41UTBHQ0FrZEN2U0tPZ1N2YlRURDQy?=
 =?utf-8?B?a1cya3pCRmFnVWw1R2pzTVhkUXE4bmdoeGFVQjRpUmhmNTI0L28vUVBZR01x?=
 =?utf-8?B?OGNVYUhxWHl1aE1ZRVdIOGNyaVdkN2dNYkJvV0tjdGNkVXEwMHVPRjR3WVdT?=
 =?utf-8?B?MDN5bnEwZmlLSit4bnJEclMxWDJ5ZHFIL2ZiUXU2TXRuRjdwOFVjR09xMlRw?=
 =?utf-8?B?Y3praElYWWRYTmZPQWtLTkE5eDB0d0cyb0tsTUFHMTd2cEJXTU1kSXRucDV4?=
 =?utf-8?B?WVBuRFUwdEpmeTlpTk5lejN0VFdxYjV4TjNTK0l2VnorMzU5MjdYOXcybm1q?=
 =?utf-8?B?M2ovcXliQi82azRLU2huOUF1WG5GQXJqN2pkSnFFQlBWbW1mMlJpaXkwRTl4?=
 =?utf-8?B?UVRoWEJjQUU4VldFdWM2R1JVZWk4dlZ2K205VnN6clMwZ0g5WDRLTnpQQ0Zm?=
 =?utf-8?B?V1paTTlycVBzZkZGaDhwN1BmUSsvUE8yKzRVL0JKdzFPOEpFS1VrRDBUYUVx?=
 =?utf-8?B?MG8wWUQ5aVBQTUpja3NoWW1rd1Z6MEVkekh1Z1BwVFBRbldCZ1pYZWxvYmNJ?=
 =?utf-8?B?ZVJnM2xqUjZtVVgyRnV6MXI0YWsvbGtYRWtXckFETVJZOU13S2NVTy9PM3dB?=
 =?utf-8?B?VXNOWXBaWjlFTmVadVNscE42YmxkT3JTZWJ5ODhRWDR4WWpMdVJuUnl1NXFZ?=
 =?utf-8?B?UVZxMGErbXBCalB2YTA5YzNKUFJmdE9aempMenFIQXFZeEkvQW9oTGFPbVA4?=
 =?utf-8?B?K1BsL09wTnZLem5QUUhrbmNzNHgrU2V0TUozVThaY2xMRSszMnRFY2l1MDBr?=
 =?utf-8?B?RlpucHptcXBPOFN3OS9ody9ubXlQZ3hmOWE0OVlLbi83T1FENWxqd2J0QzFt?=
 =?utf-8?B?SjB6cm8vU0krc2U1dkdUd3A0UERhbzZmdzVrK2pEbFo3T0wrM1FGUnVxcVBl?=
 =?utf-8?B?SzRudTRSSzFCUjJFOE9yV0UzMlhIc28wUkYybzd0MWNhUTU2UWRFaFFScksr?=
 =?utf-8?B?d1YwSVUvdkR3bWNycXhHaC8yNDN2cHBIOXNFdVgvbXRFVjVUVXFyZmErY1dG?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f34421d2-d65a-4d79-df0d-08db334d3af6
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6738.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 07:38:20.3511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSbfX1Fc4bpHLd/aL6IicltnJ+UVdug+8udDYH9mdjyROXKAR2Cg5pGdeUkAEc+I6U+zofz8Jw/oEcbh+OP/Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5150
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/2023 13:35, Takashi Iwai wrote:
> On Thu, 30 Mar 2023 08:30:17 +0200,
> Takashi Iwai wrote:
>>
>> On Wed, 29 Mar 2023 21:12:32 +0200,
>> Jakub Kicinski wrote:
>>>
>>> On Wed, 29 Mar 2023 10:48:36 +0200 Takashi Iwai wrote:
>>>> On Wed, 29 Mar 2023 10:40:44 +0200,
>>>> Bagas Sanjaya wrote:
>>>>>
>>>>> On Tue, Mar 28, 2023 at 04:39:01PM +0200, Paul Menzel wrote:
>>>>>> Does openSUSE Tumbleweed make it easy to bisect the regression at least on
>>>>>> “rc level”? It be great if narrow it more down, so we know it for example
>>>>>> regressed in 6.2-rc7.
>>>>>>    
>>>>>
>>>>> Alternatively, can you do bisection using kernel sources from Linus's
>>>>> tree (git required)?
>>>>
>>>> That'll be a last resort, if no one has idea at all :)
>>>
>>> I had a quick look yesterday, there's only ~6 or so commits to e1000e.
>>> Should be a fairly quick bisection, hopefully?
>>
>> *IFF* it's an e1000e-specific bug, right?
>>
>> Through a quick glance, the only significant change in e1000e is the
>> commit 1060707e3809
>>      ptp: introduce helpers to adjust by scaled parts per million
>>
>> Others are only for MTP/ADP and new devices, which must be irrelevant.
>> The tracing must be irrelevant, and the kmap change must be OK.
>>
>> Can 1060707e3809 be the cause of such a bug?
> 
> The bug reporter updated the entry and informed that this can be
> false-positive; the problem could be triggered with the older kernel
> out of sudden.  So he closed the bug as WORKSFORME.
> 
> #regzbot invalid: Problems likely not in kernel changes
I do not think the problem is with the kernel/SW/driver code. "Failed to 
disable ULP" (ultra-low power disabling)line in a dmesg log can indicate 
that the PHY of the LAN controller is inaccessible. Probably your laptop 
has an _LM SKU (CSME/AMT)of LAN controller (with manageability).
Unfortunately, we haven't had the reliable opportunity to interact with 
the CSME/AMT. Moreover, access to the PHY when CSME/AMT controls it 
could put the LAN controller in an unknown state.
This model of the laptop is no longer supported thought. Worth checking 
the option to disable CSME/AMT via BIOS.

So, somehow it worked previously. _V SKU should not hit on such a problem.
> 
> 
> thanks,
> 
> Takashi

