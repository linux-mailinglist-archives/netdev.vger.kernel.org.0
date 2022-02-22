Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043574BF5C9
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiBVK2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiBVK2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:28:04 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1531A15A22E;
        Tue, 22 Feb 2022 02:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645525659; x=1677061659;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I9p+/v3WhXxrF5YP8mLFfvSGwBohxFx8U9vpQ0P4KE4=;
  b=AAiARY+F8ZCH/0Q19G6UsUx0vBWzOuCvfFtsvIgiS4iY0xjVl4jvluIv
   9wAXvG1pWg3SiR993N84Wcq1FXp5twL7pg19t9hZsGR2Mtj8oE4KjGIPc
   TuIT8kCCWT1KxgpNZc/uoaveoMotcY1ve2X9fJJxdaz+JX05+Xzf3sSja
   9npUH94eeeOvDazTdWUYnO+1+1Xw6rmhORzaw101WLmFKxSn5pGuXDGNX
   nkst1IqnjGALJDpk+oLuEQEisQ39jQFbqY4QjPhyARWhxBTOgO7faYxcl
   m1tl1hZRAnpu2F3Sq9Oa/E3f5GfhDo6XbpmAYJanBzyXcVnQOyk4nvDQc
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="231632546"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="231632546"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 02:27:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="638859599"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga004.jf.intel.com with ESMTP; 22 Feb 2022 02:27:38 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 22 Feb 2022 02:27:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 22 Feb 2022 02:27:37 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 22 Feb 2022 02:27:37 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 22 Feb 2022 02:27:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gz6zTtvgmjXT73kqrgVwGDiNgQsq+0/gzqyrBOHfw+6/zzHhlcDAXKGLnzU685qZERg96jXCn7q/WCfbbfaBrTOFF/IcTF2IcOcQWBvbVg8bTIZ+P9fWeiNAvkz0ZqRTaYYJDFyaiahiQxRYe+c45S38HII4pbzvjosB+twLldo9HQa/+8v8Gxon0GkPrvtBTxq8AklgsQmwOkhhqVrCUuAc5GhZbxlTrRKfBRCGpArej7UXCg8b+iO2yvO+2YIPCIICJcTTQzEfGePm16tVqE2DoAj/yHwm9YnrNZ7YBNKrDgKmmpDYBD046jukwFt4WOwdtthFRoSUgZH83u9VNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0WqFltJt+dIaZIcauPjD8lwHBntGYPumDPIxSfLqBto=;
 b=nAWz/a4/PdpTVomVhLURspSHuQJ1Ym6w8Lkf6udNbQxBdT+VE5LAU13kW7wO+uHMXfbj1t1mmU7aZHaVhxk6LVYyt2PKr23tkRFbFqmMty45GI0yxZYpAZqTN7b8KgIV8bJLzGeXg7VasrXVWhs7AFTWuPOGqfFpxJ9uDkNI4G2vhDwTKVWBzSViJdsaZm1YPdHJkSe5Dx6n+GncPfQd4wr5bS1G1xCHbGSfT27liutjYEwoghJ4WtJy6PhnueAphKN9v8XimhI8Wapdj2ZBXQhZP3tyHD9NNdaAGRTZjfxlTIG2TdgOxoWCd+eV/ZfmVhKMugBrn2DuKo+kkRa3hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3180.namprd11.prod.outlook.com (2603:10b6:5:9::13) by
 DM5PR11MB1737.namprd11.prod.outlook.com (2603:10b6:3:10b::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.24; Tue, 22 Feb 2022 10:27:35 +0000
Received: from DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::11f6:76fa:fc62:6511]) by DM6PR11MB3180.namprd11.prod.outlook.com
 ([fe80::11f6:76fa:fc62:6511%6]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 10:27:35 +0000
Message-ID: <2a31d520-454c-c837-ec17-12dbf879e6d3@intel.com>
Date:   Tue, 22 Feb 2022 11:27:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [PATCH v3 05/11] lib/ref_tracker: __ref_tracker_dir_print improve
 printing
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, netdev <netdev@vger.kernel.org>,
        "Jani Nikula" <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>
References: <20220221232542.1481315-1-andrzej.hajda@intel.com>
 <20220221232542.1481315-6-andrzej.hajda@intel.com>
 <CANn89iJxaPqTLY0BaD79Ubxx55RMtWzZk_jkpuF1cp3Wsy2RzA@mail.gmail.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <CANn89iJxaPqTLY0BaD79Ubxx55RMtWzZk_jkpuF1cp3Wsy2RzA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0378.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::23) To DM6PR11MB3180.namprd11.prod.outlook.com
 (2603:10b6:5:9::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd0db905-a387-42a8-98f3-08d9f5edf101
X-MS-TrafficTypeDiagnostic: DM5PR11MB1737:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR11MB1737F093B0E6E9CC87916094EB3B9@DM5PR11MB1737.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QX/8NPm0K4EySjsT2tEVmdiDn0Ld+m8ESIS5Jx4HwgiuZtt3hote2m44fiinGjeWw1Kv6oGZEWACHx3UahWX4cjLVLEFj5sq137H/UF6B9/O14QpUt27QWj+dkDeHAvYZ6gt7rhD3kpY5jDBDOIOi9AuGyo+KP9l0zCcLB5dq+zUepAYrEbv3cfUN3uRmQAwDRDfV/wKpVRjvJ1dhttr7gO8jr6ysLJSKH9/BdmI9uYJBfMpakxPxrhhgLSzLQh6KbE4hGDZNK8N6LDsDvF81DeSNZHwjPOqJdhNIJJJI90xEI6kmDsNhLQilztHpbNRaBdBxLE4Eqm7qXrkNdGEvlhA+hWCN4LDs5o1CzevcVwyKEryyz/6s0fg3bbo4WvqNpAQhBju1scr8aDmaKZGPfSejKnQRbflUoAqTP2tXJC0Apgb38/anAed2xLoxlTIjWceCd8OmX0fzRG+06/Q8Y6k/gmTntr1HSGp4JwX4ipa9IJygqtN7QtyXKOmBkOvDLIVpM5dNQFTqYyuyEA9j/k7cwQ8turDxftBSGgNtBpHSbdEINDh1oXAECqRlDARDrrtctddPOs/2CWfJaMk6fdeIZaq48GKzUBJulCVuonuMW5ZHd0Zet8WElka44VXZ/SwU3w3Je0fz8vMZ/EwBU+k0wolvhnsJEBCn4GXRcELziiySu9T2JCgivjJNPeqEV1OvlOHGreUGpymjzfPYcTACsLyf90/0YHL0gyH5hQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(83380400001)(6486002)(54906003)(8676002)(66946007)(66556008)(6916009)(316002)(66476007)(31696002)(6512007)(8936002)(5660300002)(2616005)(508600001)(44832011)(36916002)(82960400001)(6666004)(36756003)(186003)(6506007)(26005)(53546011)(86362001)(38100700002)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmtDamY0b0lHaU5uM3g0YjVSU3VxWjFnMkp3NHNTa0xyNG9kKy9salppTTRR?=
 =?utf-8?B?WHRMVm1WMG1YQ1cxWFUreEhCZHRWamV0Qk05RzVPYndndzVLY0pJTDJaZU9I?=
 =?utf-8?B?U1ViYjVKTUZtdXBPeGVCdnBQeWtVU1V1TFgyam9tY2kxL0tCL2pJaHA1Q1Zn?=
 =?utf-8?B?aFBONFhCVW5MNWNqejJjL3l0ZW9mWjV2ZjhGcVJoZG1WQ2g5aStxV2tXc1dw?=
 =?utf-8?B?Wi9OL3ZqcldxSElSQnpnMVVNeGUvcGQxMkRqOVdIU2xrMUg0RHdqTVNnN1lQ?=
 =?utf-8?B?Q2NrZHFsWU9Deld4d1kzN3IyZmxiZTAzUFM1dy9NbmJSckRKOHFyWU9RUlcw?=
 =?utf-8?B?ZEJFK1VtSndQVHFPZkx5dWZRdkpMRUkxN0R2Y1BsVVRkbk1IZzJQazB1djBl?=
 =?utf-8?B?UUNqSVRLUnlhQ09FZHdiVUZIT0ZTK0RaU1RGSi9ld1M1ekRZTlRoeXR1Z09o?=
 =?utf-8?B?ajBzTEc4V0RoR1ArUGZ0YWJVbW9EWmxmMkQrdnMvN1d5TTlDSCtNT01ycE9s?=
 =?utf-8?B?UzZNNGplUzRMUnR6Z2Y1cStRU09WZS9yMk0xc0pqUVBqQzdrNWF4R3MzblV6?=
 =?utf-8?B?cnZkcmhidGdPcTBxWHFmRFd3ZktiWEJWMHdEUGI4em1XaG5xcGxBM2FpdWNN?=
 =?utf-8?B?RFkyaThBTzNXR0dMM1E4VFpNbWFDWWV1VS9EVmd2VXc1NFk2Ym5MR3g2cjJ5?=
 =?utf-8?B?Z01OSTN3dFhBbVFOVElUcFhnK1k5NC8raGdEQjJxdUc3ZVBkWi84VGpnZHVp?=
 =?utf-8?B?ZmJvM1ZBY2JsaHhsZzVSSlFQMlBrYTN1NzRGMTAzMUNlRm1Ma0Voa2hnSWJo?=
 =?utf-8?B?d2EwODBBUHZCd0JQUUwzY3lJK0huVjVabHQxVXgzS01hMjVNMmJVVk1EY0Qr?=
 =?utf-8?B?LzVXbzQ3Tk5QNTVaYk1JQjlXZTAxbWIrS1Q0clZoUVpMYnlwR00xMUtKR1Jm?=
 =?utf-8?B?RER4UFZnWFlNZ0l0c2hQT2NYUlZFZkVWckdIRmx4OUFyeklUMHV3RXVZRmc1?=
 =?utf-8?B?Ym1IN21oek9CV2paUU1NUEVWV1FIc2VtYzJEQWJERldFT09Db2xPTWxFWEpi?=
 =?utf-8?B?YXNUYkt6SE9wT2xGY1JNVi95UHlyRGxIR056bmpxRjVGQllrYXRvc1F5b2Jm?=
 =?utf-8?B?SXh2R3BvYTRXUVh0Vy9SVTBJYSs1a1F6dG8vUHJVM3JxRysyam02ZlRVWXlm?=
 =?utf-8?B?WUhxOUV5YVpzNlZZYzV0VTdFbzVOYlNoS2N6c3pWWHNVbWtGSUpYNXZ3K2I1?=
 =?utf-8?B?RENVaDY2K2xLbFc3UW1nOWZvTlRnWkVTVkhKYjlBdHQzOXdMUUlsVTAwMU9t?=
 =?utf-8?B?cFFVSkpxeDdVL1phb3ZidnNKM25GandNcGl2Tlp0aCtCSlV0MEFXcDNsb0ZK?=
 =?utf-8?B?VEhUSzhiaklRTkRieEQvbVczeUN4aEFScnVTMUZpS0JPYVJvcFJmUE1aQm13?=
 =?utf-8?B?RWgxUXlJOGdvcnc2YXJNc3BZbzV3M3NoM2RlN1VpSGZoY1pZaHBrZS9XSFdX?=
 =?utf-8?B?aVRGalZPMzlLSlNEUEljcmlLQzhKaVhXTTRITHhHYWRNdXRCelcxWlBRU3k2?=
 =?utf-8?B?eU5xbHRtU1pTdzBRR01IQmVCT1JRWXlDUlhMMlNScGpkcEZUZW52V0lVb2w0?=
 =?utf-8?B?RnQxTkFGRlExclRBcjVmcHpYQ25xTmFlaEphMkwvYks4RzdhK3pjdldDWXYr?=
 =?utf-8?B?dnVKNUlrT1ZKT1F6YXVqcEFDbVVkei9PU2JrejM2ZDBTcXZMeEdrMVZPNFhm?=
 =?utf-8?B?UUhwcUdYbmtRSG4rWVJOQTdwRGFmLzRhYmNhN2xHb0MwMWpkemkvVzIzL0RY?=
 =?utf-8?B?ZFNwd3pPdlB3WTFlNHlSb1ltQnZVdVFtSXBVYVFlQUovSUJDVSszcWpVTzQx?=
 =?utf-8?B?anJNK1FQeTc1b3grTnd1eXZITkxVVTRSRkNmd1lWS3pINHZqWHhNR0tRekRH?=
 =?utf-8?B?UDNqckd0VVA0dTU0NFp1TlYyZDJwY1pKc0xBVjQwSHg3ZlFBMFhFRmpId2FM?=
 =?utf-8?B?ZkNRQ1dSWXFKTmZBRE9jOE9UdmhMWkp2R05neldqeWNmVlRDSDV5SFpBSVhE?=
 =?utf-8?B?L0VWaDBEUkNNRm1NS0xtaEZEczU5L09IbDhFMm1OYzZoc2llRTM2SDloN21O?=
 =?utf-8?B?Q1FUT0V2SW1VaDVYQkRaL01aaDJPb29WK1p1MzZ2L1hQM1B4RGg5WTdNV042?=
 =?utf-8?Q?J4Ey5DV/pSUlhjleB8D/auA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dd0db905-a387-42a8-98f3-08d9f5edf101
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 10:27:35.1134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wCUgkCD42r65ZJtxfTO7bAa5ajMPsbEuo0B8RSgq92SkE2N9snBTtfEIVYHaH41Jn1pzqq+mfKFBYcZYqnnvoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1737
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22.02.2022 01:08, Eric Dumazet wrote:
> On Mon, Feb 21, 2022 at 3:26 PM Andrzej Hajda <andrzej.hajda@intel.com> wrote:
>> To improve readibility of ref_tracker printing following changes
>     readability
>
>> have been performed:
>> - reports are printed per stack_handle - log is more compact,
>> - added display name for ref_tracker_dir,
>> - stack trace is printed indented, in the same printk call,
>> - total number of references is printed every time,
>> - print info about dropped references.
>>
>> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
>> ---
>>   include/linux/ref_tracker.h | 15 +++++--
>>   lib/ref_tracker.c           | 90 ++++++++++++++++++++++++++++++++-----
>>   2 files changed, 91 insertions(+), 14 deletions(-)
>>
>> diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
>> index 3e9e9df2a41f5..a2cf1f6309adb 100644
>> --- a/include/linux/ref_tracker.h
>> +++ b/include/linux/ref_tracker.h
>> @@ -17,12 +17,19 @@ struct ref_tracker_dir {
>>          bool                    dead;
>>          struct list_head        list; /* List of active trackers */
>>          struct list_head        quarantine; /* List of dead trackers */
>> +       char                    name[32];
>>   #endif
>>   };
>>
>>   #ifdef CONFIG_REF_TRACKER
>> -static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
>> -                                       unsigned int quarantine_count)
>> +
>> +// Temporary allow two and three arguments, until consumers are converted
>> +#define ref_tracker_dir_init(_d, _q, args...) _ref_tracker_dir_init(_d, _q, ##args, #_d)
>> +#define _ref_tracker_dir_init(_d, _q, _n, ...) __ref_tracker_dir_init(_d, _q, _n)
>> +
>> +static inline void __ref_tracker_dir_init(struct ref_tracker_dir *dir,
>> +                                       unsigned int quarantine_count,
>> +                                       const char *name)
>>   {
>>          INIT_LIST_HEAD(&dir->list);
>>          INIT_LIST_HEAD(&dir->quarantine);
>> @@ -31,6 +38,7 @@ static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
>>          dir->dead = false;
>>          refcount_set(&dir->untracked, 1);
>>          refcount_set(&dir->no_tracker, 1);
>> +       strlcpy(dir->name, name, sizeof(dir->name));
>>          stack_depot_init();
>>   }
>>
>> @@ -51,7 +59,8 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
>>   #else /* CONFIG_REF_TRACKER */
>>
>>   static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
>> -                                       unsigned int quarantine_count)
>> +                                       unsigned int quarantine_count,
>> +                                       ...)
>>   {
>>   }
>>
>> diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
>> index 5e9f90bbf771b..ab1253fde244e 100644
>> --- a/lib/ref_tracker.c
>> +++ b/lib/ref_tracker.c
>> @@ -1,11 +1,16 @@
>>   // SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> +#define pr_fmt(fmt) "ref_tracker: " fmt
>> +
>>   #include <linux/export.h>
>> +#include <linux/list_sort.h>
>>   #include <linux/ref_tracker.h>
>>   #include <linux/slab.h>
>>   #include <linux/stacktrace.h>
>>   #include <linux/stackdepot.h>
>>
>>   #define REF_TRACKER_STACK_ENTRIES 16
>> +#define STACK_BUF_SIZE 1024
>>
>>   struct ref_tracker {
>>          struct list_head        head;   /* anchor into dir->list or dir->quarantine */
>> @@ -14,24 +19,87 @@ struct ref_tracker {
>>          depot_stack_handle_t    free_stack_handle;
>>   };
>>
>> -void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
>> -                          unsigned int display_limit)
>> +struct ref_tracker_dir_stats {
>> +       int total;
>> +       int count;
>> +       struct {
>> +               depot_stack_handle_t stack_handle;
>> +               unsigned int count;
>> +       } stacks[];
>> +};
>> +
>> +static struct ref_tracker_dir_stats *
>> +ref_tracker_get_stats(struct ref_tracker_dir *dir, unsigned int limit)
>>   {
>> +       struct ref_tracker_dir_stats *stats;
>>          struct ref_tracker *tracker;
>> -       unsigned int i = 0;
>>
>> -       lockdep_assert_held(&dir->lock);
>> +       stats = kmalloc(struct_size(stats, stacks, limit),
>> +                       GFP_NOWAIT | __GFP_NOWARN);
> I would be more comfortable if the allocation was done by the caller,
> possibly using GFP_KERNEL and evenutally kvmalloc(),
> instead of under dir->lock ?

I though also about it, but decided to left this change to another patch 
as the change can be substantial and could open another discussion.

I am not sure what you mean by 'caller' but it could be even external 
user of the API:
1. alloc data for ref_tracker_dir_stats.
2. take locks, if necessary.
3. gather stats (ref_tracker_get_stats) atomically.
4. release taken locks.
5. print stats.

This way, allocation and printing would happen outside locks.

>
>
>> +       if (!stats)
>> +               return ERR_PTR(-ENOMEM);
>> +       stats->total = 0;
>> +       stats->count = 0;
>>
>>          list_for_each_entry(tracker, &dir->list, head) {
>> -               if (i < display_limit) {
>> -                       pr_err("leaked reference.\n");
>> -                       if (tracker->alloc_stack_handle)
>> -                               stack_depot_print(tracker->alloc_stack_handle);
>> -                       i++;
>> -               } else {
>> -                       break;
>> +               depot_stack_handle_t stack = tracker->alloc_stack_handle;
>> +               int i;
>> +
>> +               ++stats->total;
>> +               for (i = 0; i < stats->count; ++i)
>> +                       if (stats->stacks[i].stack_handle == stack)
>> +                               break;
>> +               if (i >= limit)
>> +                       continue;
>> +               if (i >= stats->count) {
>> +                       stats->stacks[i].stack_handle = stack;
>> +                       stats->stacks[i].count = 0;
>> +                       ++stats->count;
>>                  }
>> +               ++stats->stacks[i].count;
>> +       }
>> +
>> +       return stats;
>> +}
>> +
>> +void __ref_tracker_dir_print(struct ref_tracker_dir *dir,
>> +                          unsigned int display_limit)
>> +{
>> +       struct ref_tracker_dir_stats *stats;
>> +       unsigned int i = 0, skipped;
>> +       depot_stack_handle_t stack;
>> +       char *sbuf;
>> +
>> +       lockdep_assert_held(&dir->lock);
>> +
>> +       if (list_empty(&dir->list))
>> +               return;
>> +
>> +       stats = ref_tracker_get_stats(dir, display_limit);
>> +       if (IS_ERR(stats)) {
>> +               pr_err("%s@%pK: couldn't get stats, error %pe\n",
>> +                      dir->name, dir, stats);
>> +               return;
>>          }
>> +
>> +       sbuf = kmalloc(STACK_BUF_SIZE, GFP_NOWAIT | __GFP_NOWARN);
> Same remark. These allocations are most probably going to happen from process
> context, I think GFP_KERNEL is more robust.

The problem is that in my scenario it can be called under spinlock, this 
is why I want almost everywhere non-sleeping allocations.

>
> This is debugging infra, it would be sad if we give up at this point,
> after storing MB of traces :)

My approach was to avoid allocations if the system is short on memory - 
better to keep it alive, and we still get the report, just without 
stacktraces, one can print full stats later (for example via sysfs, or 
trigger to dmesg) - big chances that the bug will be still there.
If you think that is no-go, alternatives I see:
- go back to GFP_ATOMIC,
- print stack directly, without using stack_depot_snprint,
- pre-allocate buffer.

Regards
Andrzej

>
>> +
>> +       for (i = 0, skipped = stats->total; i < stats->count; ++i) {
>> +               stack = stats->stacks[i].stack_handle;
>> +               if (sbuf && !stack_depot_snprint(stack, sbuf, STACK_BUF_SIZE, 4))
>> +                       sbuf[0] = 0;
>> +               pr_err("%s@%pK has %d/%d users at\n%s\n", dir->name, dir,
>> +                      stats->stacks[i].count, stats->total, sbuf);
>> +               skipped -= stats->stacks[i].count;
>> +       }
>> +
>> +       if (skipped)
>> +               pr_err("%s@%pK skipped reports about %d/%d users.\n",
>> +                      dir->name, dir, skipped, stats->total);
>> +
>> +       kfree(sbuf);
>> +
>> +       kfree(stats);
>>   }
>>   EXPORT_SYMBOL(__ref_tracker_dir_print);
>>
>> --
>> 2.25.1
>>

