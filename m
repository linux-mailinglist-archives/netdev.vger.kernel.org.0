Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A2844271A
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 07:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhKBGbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 02:31:52 -0400
Received: from mga12.intel.com ([192.55.52.136]:29999 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhKBGbv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 02:31:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10155"; a="211246525"
X-IronPort-AV: E=Sophos;i="5.87,201,1631602800"; 
   d="scan'208";a="211246525"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2021 23:29:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,201,1631602800"; 
   d="scan'208";a="467571289"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga002.jf.intel.com with ESMTP; 01 Nov 2021 23:29:16 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 1 Nov 2021 23:29:16 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 1 Nov 2021 23:29:15 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 1 Nov 2021 23:29:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 1 Nov 2021 23:29:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhqb3aouQE1qw+Dknr0S9qwn61+i2CLzFNFdzaitv9todeyt5o/VX0Ao93wDzfM5yrqhL8t5YiFTxSUPLcvCKhbJ+S42+ILS1MmRfikl+ezA14CEl2kXGbJm3OQ4sAYzr5aAYa+yB2rm+MO0QUbYGhnTD3VSONu17UkqtYv3V1+uOqB/IDDP0HnKTZO6XEmFA3lBD6qk2viXHuObbbgtL/pGZ+cbd/oHJEas0uw4rU9e0qDlakgjZU0fO6APVhdGmxbGvb0yf4i7WSo229edXPWFeIYauur5zrvZZY6dwGtZc/7k5+lcdrYcGdSTxy58vd8vaxQT7EsBevvOZ2dOmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cp5swAxdI3b4eCHiMTuHGZtbUAvBJzysxRlyXhlxOZg=;
 b=LZFSLgOKb6dYxQRspXEqYsuqfI3c0F99lZGrphltrFFl70hDFGzZ5+eRwXo7KVSOehz8gRwCykImQV4CHtioXuJJjDNE4BISDzP05d2KrUkKF9Am8aQvW1KWxbUE423Dny8F5VRaUL9tGeInKZo7NTw++VOOJm88+ZL7FItvqYlWYKZh5FyMuX6SN8HIGdbgaB/6lUkPHkLiJDIQEIPsbMy/Ar2ZwL6paf+mxpd/4M1voI/sub8MGPIylXccKtoOSDX4+LwrmDhwt0vUEVVigpq44+S5vhDf0dP+/KQc8udcyAPO/kiPrC8PY+2Xz4hCQAr31lyG/NVmAFrqvvUjuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cp5swAxdI3b4eCHiMTuHGZtbUAvBJzysxRlyXhlxOZg=;
 b=GvtMbmurFEChlpyblwqUCqXkeslFjorCIu1Gvl9Rh1tL3fjNudXZZnvAzNwxhVpSbzi+3K2fOWMSty9pwgU3dw+fNd/bMXlOFI8kSynkq4omud70RK3BF9LercV+DxeVMrdAbQgoTF31ilDDkka7H856NZqmvZAaL7yFkI27qBE=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by MW5PR11MB5908.namprd11.prod.outlook.com (2603:10b6:303:194::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 2 Nov
 2021 06:29:14 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::cced:992a:9015:3b8d]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::cced:992a:9015:3b8d%7]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 06:29:14 +0000
Message-ID: <b20821ce-2f16-6932-280d-a2cf98ad2120@intel.com>
Date:   Tue, 2 Nov 2021 08:29:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.2.1
Subject: Re: [PATCH v2] e1000e: Add a delay to let ME unconfigure s0ix when
 DPG_EXIT_DONE is already flagged
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        AceLan Kao <acelan.kao@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Dima Ruinskiy" <dima.ruinskiy@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kraus, NechamaX" <nechamax.kraus@linux.intel.com>,
        "Fuxbrumer, Devora" <devora.fuxbrumer@intel.com>,
        "Avivi, Amir" <amir.avivi@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20211026065112.1366205-1-kai.heng.feng@canonical.com>
 <04ed8307-ab1f-59d6-4454-c759ce4a453b@intel.com>
 <CAAd53p69k-2PVw5RpJOAbe=oBh11U_UqzsyMjxHFbo7xqNBDsQ@mail.gmail.com>
 <f6a4d53a-3ec8-b5cd-9b6c-b14c69d20248@intel.com>
 <CAAd53p67dehgizx1h0ro40YRmKNsbv3Ve=2987kyMUKs7=LOpA@mail.gmail.com>
 <49c5e91a-8e02-2a76-db5d-5f15df3c485f@intel.com>
From:   Sasha Neftin <sasha.neftin@intel.com>
In-Reply-To: <49c5e91a-8e02-2a76-db5d-5f15df3c485f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0068.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::15) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
Received: from [10.185.169.41] (134.191.232.48) by FR3P281CA0068.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:4b::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.5 via Frontend Transport; Tue, 2 Nov 2021 06:29:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1448e017-f936-4ded-80ca-08d99dca167c
X-MS-TrafficTypeDiagnostic: MW5PR11MB5908:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MW5PR11MB5908ECB5DB30F4D4F8FB93EA978B9@MW5PR11MB5908.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hSXt+hIF4qjbzI5aQpIoLtnzqN1nJ5wlPz2y/UBuz9Dpopd3di4c5RR8fIiH7FgkGZjFBqrU7B+YTZb4yeASSwDCv4nZWlnWxCRw8c9vgAKRbm5gV7XSUB8/jgKqjNdjPSTip5iezouzZxe3/3KN3EfR0Hc3tQ5Ct8a4MA0/0dClwKv1aJYgmXGSmKgfVKnqEx1p9oNMxqetnvXSddwH8U/czHkNBrBxwfBGGmygSmZ9Nf4NHcvfq/79m5T2qdUL4DSnglotueCXQ+d0d/2diUxCsAPXsG/dp9YXfe/3VHNGbjUzdf5UX0NZHWD//MKLR0KVZM9usEyXFFZiwseMa/bstsz/Re38QC6kObRwlUaVd5m+uN3nBDE58JV2rzyiZ7hUpU7nhESH5JRINj1hxgfUgtC0H75zuW+2mjFwEFFi+qa89eJDJoX1hCWnjdejDr1ZPp59pmdxUEmcvilqsJJZmsYGmngIWduITgu0nIXV3LwvxbM2Tfg2G5fogj0TN69YsqwqJrGUmmsADJS8Po8kFb9G7D3P1Wy+7AETCnjffyA2q+5AAuHpW++eV8OpZysh282hzzsJrUuAKkRArchxFpvPb6Cb7yaZVIxFyPW5Ibqbom9OpsZftadXzzRFoFBIr5o77Fe4WNhSBG1QYPk8IdrIfQ0NcJLKw1Mv3eLx9gFJ+krJ8wQPXBxbrQLtgQdGLafSdLu9VlBRP78WUyy2vSuFt/pSchjrWqGt9XGd9RaNgkBt03iL1E0Zd4UBkSp2wQQp+FkfSeXxI3xp/Q5olKA3NNpc5lRnAYIxhBHPZDgMr0PNYTrHJGynPKFnDzJqqdKrTvXJd1T2MgRuXu3HiUxtPebk9FvOmC2eDDI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(8676002)(54906003)(16576012)(316002)(6916009)(8936002)(4326008)(83380400001)(2906002)(5660300002)(6486002)(82960400001)(86362001)(66556008)(66476007)(38100700002)(66946007)(508600001)(31696002)(31686004)(966005)(186003)(44832011)(2616005)(956004)(6666004)(26005)(53546011)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmdKVFBFMURlTVlzRFlvTWdvWDE0Zmgyd3IyMUNPREhtWEhYaHMxSGFVcjFw?=
 =?utf-8?B?SC8xenJCaUJ0NTFSTnYzRUYvcmxxQTBoMmUrbmxCSlljdktnY1VSU2xMZG92?=
 =?utf-8?B?MDN4SUlxQnVkMWJpbjF5NG9uQWJCK1lHUDFGSUlPOEJCWWpaRkcweklFa0pv?=
 =?utf-8?B?bGI5UThiZ2VWeldSckZrenlyZjJrdjdCNzVBRUsvbG9aYmVBNCttdW1HRnBK?=
 =?utf-8?B?cVQ3TGh4ZkJQTTJmM0N6akdzV3ZrdVMvNEEwbGZ5WXQ2NWtVOCsrSEphbVBJ?=
 =?utf-8?B?ekRYZkpXTmJFSkNQN2RTTnhzazdjTkdiL3VMZXZyRXJ0ZTBMV2JlbUxTWHZO?=
 =?utf-8?B?dmxXYy9sa2RQYXZON3BpeTYxczBPbDhnNkhnTjFvNnlid200YWZORTJjS2h6?=
 =?utf-8?B?eHZpejQyZHZLdTh3T09tK2ZscHhlaTBCY2k4RFVJbiszbVY2Zi9oQlBEelFx?=
 =?utf-8?B?NUpDaFBLbXVaWlltdE9uV3FXU1VhbUpKNG13Q0tKL3M1ek9kZmFIcFJNWkZT?=
 =?utf-8?B?SFV3ME92QmN3SllsVTRyNEN1ZjJPb2lvRndkQW1jcVQxcE9jbkQ3bkllWldt?=
 =?utf-8?B?d25mOWNpaTRKSDduS2dlOFdJWStEc0ZDakVoUTAyVks3NXNnMVdmazlpSnFz?=
 =?utf-8?B?VDZldW9YRzU1UGZvc1A3L1k2c0g3L2RlaEg1YTFsUUZUd3J4LzlRK0RHdnZJ?=
 =?utf-8?B?ZUJpUTJOblpLcG5LMGtLWGppb2M3V3phT3cxY1UzdFk5OGpzbUV4c3VNT3Z6?=
 =?utf-8?B?ekVsVXNYS3libjBEaWtMTDdmeXFkS21mNlNIT1ZyM2NiZXZEd2w5TmQ1UTBz?=
 =?utf-8?B?OW01MFJLUkNqY3dKR0NSWnhiNnZsdmRqZGRJRFZjVEd3blFjTC9WM2lpTEl5?=
 =?utf-8?B?a2JudnFMQWk1K0tqVGtlY1NlYUxGeE9zSzhSajNVNTNORTJWS3dUQmdZZ2Vr?=
 =?utf-8?B?ZFdrNFhLYzBHY3hwc0p6UGx3M3pMNVQ2c2JWMXBlRC9pVG9ucHRMOUxTRzVa?=
 =?utf-8?B?KzBSY2gvQThvcVRReGJrUXpON2tEZmZQWnEzRjZvZElIRHpRSHpvWU1yRi9t?=
 =?utf-8?B?dmRjWDdWcXVRWHNzL1FldzkvYWFKSG5iVDlLZm9xVzFrWnk4dTgzdjFlcUc5?=
 =?utf-8?B?U1lRL2dDRVdpbnFBTFJ4MWJkN3FycnkxTHhGN1JpOXoxUjhaQkVqY2ROUm9Y?=
 =?utf-8?B?OFVTODk3dUU3dFgxTXNaeDZSeTYvYVRsbTBxRmFTQWwxSGx5NWJ0UlQrSEVT?=
 =?utf-8?B?b09QK3lZODl0WU14Qm1NcHF1WjJuYUVsSm85dFk0blhqRHdQVjNXenpnQkJD?=
 =?utf-8?B?bTV5Qm84azRxdjMzUjdVbE1hZGVxaEh5NVV4NktwNDJ3NXZuOURBb3ZTRnpz?=
 =?utf-8?B?OUUzMm5ReGMwSXVQaWFSTTJ5MkgzMHp1NHRISkZlOWxwWFFrclEyYmlibElu?=
 =?utf-8?B?WmNKQWhYNzVETHhXSGZpbFNGVVVFdEg4d1VZeW5FOHJ4RnE1RFN4ZWgwU2VM?=
 =?utf-8?B?blhVSFhzZmtFeXBDZm8wVlkxSmpkdnBDZ2xHL3hlRHduTGp1b3Z5UWNFQ2Rv?=
 =?utf-8?B?WkxTRENhYlY4ZnRaRjZZMWMxbENTdkY3VElJbjVFQmc5TWZxdVZJMTI2SDAy?=
 =?utf-8?B?VUVxNjVWbjZZRHhjQ3pjNlFLSzdJamhzMjdLWmdsajF5S3haajByZ2Q5RHlK?=
 =?utf-8?B?N1JveXBzOUJmNVErdWc3ZGZDYVhFTldOc3hXK0RCUmpJYjNOWHRxV2dkUzFo?=
 =?utf-8?B?OXFFMzBDelZqY1Z3VFJ4UnlodXBQdjZ2VElKSjZWTlAwYjRNRDN1N2NPckE3?=
 =?utf-8?B?WkI0RlcxcWRIU3Y2bTlMRHBod3cyYzFBaXkxQW0zK1NFWlNZN2NkVFVqZDRG?=
 =?utf-8?B?akxmbE0yU2ZoaDJEbkoxRXFmNllSTHdpL29LMmNZdDlqOVhQeEpHMzk5dGhB?=
 =?utf-8?B?ZmMzd3o0VTZ0TE15RHp6MEZLcXdUVnVaOEVmOXJGcllmd0lsRkYweVhuUUlN?=
 =?utf-8?B?YzlWTkFHekxXR3YxMU9pd2xqQ3NLQys1WHpJbVJ1UW03WkJ3aHdVZm4vYjFt?=
 =?utf-8?B?N0dEZ3BvWk1GbDYxNFNRa21odzNJcHErMWJnNzZvNDlEeThjcllWUmRpWm0w?=
 =?utf-8?B?bWVZdXRKdGpMUXZFelAxY2t1dG80dGVZWmJvOUprM3VmTXE0cDNrYnRuZjQ3?=
 =?utf-8?Q?MDctFoIhTtHOf15iov0ywGY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1448e017-f936-4ded-80ca-08d99dca167c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 06:29:13.8915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p6QeT0oNNsX2WLV24fB7JJgG47ZyuYnCTdmH2HEBNu4pCaqLHfC1bU/k5wj6NpJh6vkIUfjS2itE2TbGunz29Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5908
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/2021 08:24, Sasha Neftin wrote:
> On 11/2/2021 05:27, Kai-Heng Feng wrote:
>> On Fri, Oct 29, 2021 at 5:14 PM Sasha Neftin <sasha.neftin@intel.com> 
>> wrote:
>>>
>>> On 10/27/2021 01:50, Kai-Heng Feng wrote:
>>>> On Tue, Oct 26, 2021 at 4:48 PM Sasha Neftin 
>>>> <sasha.neftin@intel.com> wrote:
>>>>>
>>>>> On 10/26/2021 09:51, Kai-Heng Feng wrote:
>>>>>> On some ADL platforms, DPG_EXIT_DONE is always flagged so e1000e 
>>>>>> resume
>>>>>> polling logic doesn't wait until ME really unconfigures s0ix.
>>>>>>
>>>>>> So check DPG_EXIT_DONE before issuing EXIT_DPG, and if it's already
>>>>>> flagged, wait for 1 second to let ME unconfigure s0ix.
>>>>>>
>>>>>> Fixes: 3e55d231716e ("e1000e: Add handshake with the CSME to 
>>>>>> support S0ix")
>>>>>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
>>>>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>>>>> ---
>>>>>> v2:
>>>>>>     Add missing "Fixes:" tag
>>>>>>
>>>>>>     drivers/net/ethernet/intel/e1000e/netdev.c | 7 +++++++
>>>>>>     1 file changed, 7 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c 
>>>>>> b/drivers/net/ethernet/intel/e1000e/netdev.c
>>>>>> index 44e2dc8328a22..cd81ba00a6bc9 100644
>>>>>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>>>>>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>>>>>> @@ -6493,14 +6493,21 @@ static void e1000e_s0ix_exit_flow(struct 
>>>>>> e1000_adapter *adapter)
>>>>>>         u32 mac_data;
>>>>>>         u16 phy_data;
>>>>>>         u32 i = 0;
>>>>>> +     bool dpg_exit_done;
>>>>>>
>>>>>>         if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
>>>>>> +             dpg_exit_done = er32(EXFWSM) & 
>>>>>> E1000_EXFWSM_DPG_EXIT_DONE;
>>>>>>                 /* Request ME unconfigure the device from S0ix */
>>>>>>                 mac_data = er32(H2ME);
>>>>>>                 mac_data &= ~E1000_H2ME_START_DPG;
>>>>>>                 mac_data |= E1000_H2ME_EXIT_DPG;
>>>>>>                 ew32(H2ME, mac_data);
>>>>>>
>>>>>> +             if (dpg_exit_done) {
>>>>>> +                     e_warn("DPG_EXIT_DONE is already flagged. 
>>>>>> This is a firmware bug\n");
>>>>>> +                     msleep(1000);
>>>>>> +             }
>>>>> Thanks for working on the enablement.
>>>>> The delay approach is fragile. We need to work with CSME folks to
>>>>> understand why _DPG_EXIT_DONE indication is wrong on some ADL 
>>>>> platforms.
>>>>> Could you provide CSME/BIOS version? dmidecode -t 0 and cat
>>>>> /sys/class/mei/mei0/fw_ver
>>>>
>>>> $ sudo dmidecode -t 0
>>>> # dmidecode 3.2
>>>> Getting SMBIOS data from sysfs.
>>>> SMBIOS 3.4 present.
>>>> # SMBIOS implementations newer than version 3.2.0 are not
>>>> # fully supported by this version of dmidecode.
>>>>
>>>> Handle 0x0001, DMI type 0, 26 bytes
>>>> BIOS Information
>>>>           Vendor: Dell Inc.
>>>>           Version: 0.12.68
>>>>           Release Date: 10/01/2021
>>>>           ROM Size: 48 MB
>>>>           Characteristics:
>>>>                   PCI is supported
>>>>                   PNP is supported
>>>>                   BIOS is upgradeable
>>>>                   BIOS shadowing is allowed
>>>>                   Boot from CD is supported
>>>>                   Selectable boot is supported
>>>>                   EDD is supported
>>>>                   Print screen service is supported (int 5h)
>>>>                   8042 keyboard services are supported (int 9h)
>>>>                   Serial services are supported (int 14h)
>>>>                   Printer services are supported (int 17h)
>>>>                   ACPI is supported
>>>>                   USB legacy is supported
>>>>                   BIOS boot specification is supported
>>>>                   Function key-initiated network boot is supported
>>>>                   Targeted content distribution is supported
>>>>                   UEFI is supported
>>>>           BIOS Revision: 0.12
>>>>
>>>> $ cat /sys/class/mei/mei0/fw_ver
>>>> 0:16.0.15.1518
>>>> 0:16.0.15.1518
>>>> 0:16.0.15.1518
>>>>
>>> Thank you Kai-Heng. The _DPG_EXIT_DONE bit indication comes from the
>>> EXFWSM register controlled by the CSME. We have only read access.  I
>>> realized that this indication was set to 1 even before our request to
>>> unconfigure the s0ix settings from the CSME. I am wondering. Does after
>>> a ~ 1s delay (or less, or more) _DPG_EXIT_DONE indication eventually
>>> change by CSME to 0? (is it consistently)
>>
>> Never. It's consistently being 1.
> no. On my TGL platform is cleared by CSME:
> [Sun Oct 31 08:54:40 2021] s0ix exit: EXFWSM register: 0x00000000
> [Sun Oct 31 08:54:40 2021] s0ix exit (right after sent H2ME): EXFWSM 
> register: 0x00000000
> [Sun Oct 31 08:54:40 2021] s0ix exit(after polling): EXFWSM register: 
> 0x00000001
> [Sun Oct 31 08:54:40 2021] e1000e 0000:00:1f.6 enp0s31f6: DPG_EXIT_DONE 
> cleared after 130 msec
>>
>> Right now we are seeing the same issue on TGL, so I wonder if it's
>> better to just revert the CSME series?
> no. We need to investigate it and understand what is CSME state we hit. 
> Meanwhile few options:
> 1. use privilege flags to disable s0ix flow for problematic system 
> (power will increased)
> ethtool --set-priv-flags enp0s31f6 s0ix-enabled off
> ethtool --show-priv-flags enp0s31f6
> Private flags for enp0s31f6:
> s0ix-enabled: off
> 2. delay as you suggested - less preferable I though
> 3. I would like to suggest (need to check it) in case the DPG_EXIT_DONE 
> is 1 (and polling will be exit immediately) - let's perform enforce 
> settings to the CSME, before write request to CSME unconfigure the 
> device from s0ix :
> 
> if (er32(EXFWSM) & E1000_EXFWSM_DPG_EXIT_DONE)
>      mac_data |= E1000_H2ME_ENFORCE_SETTINGS;
> 
and then allow to CSME finish the enforcing synchronization:
ew32(H2ME, mac_data);
usleep_range(30000, 31000);

> I will update Bugzilla: 
> https://bugzilla.kernel.org/show_bug.cgi?id=214821 with this information.
> 
> I also will need some another information regards SMB state in this case.
>>
>> Kai-Heng
>>
>>>>>>                 /* Poll up to 2.5 seconds for ME to unconfigure DPG.
>>>>>>                  * If this takes more than 1 second, show a 
>>>>>> warning indicating a
>>>>>>                  * firmware bug
>>>>>>
>>>

