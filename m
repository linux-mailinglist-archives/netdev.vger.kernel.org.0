Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A79619A44
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbiKDOk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbiKDOkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:40:09 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B807C32BA3
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 07:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667572697; x=1699108697;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=krYZLYO3mrm71LhyAkZRHxZDgQQfUnsNPRzVnK56UZo=;
  b=HT6S58CJ28C2ufYfUU/ryw6cVQRWs/ynLLXyJR/+5+cacoSRcOBCueUf
   3V3XYngy50Y8Nb4W15Z20O4A9xz6O/Yvi4IFL17U0loSTr0GrlerkjNNk
   Jwwsh4IXc6wk/5aA1u8KbOt5B9TuKWLXhMn6aRi9zYk/b7tZsGjLagNev
   SyuHgn4DSiFK94+ef5HQSSU8GQW68gh/O1HECTNn28OxdntlNgePZaEku
   tFiKr0MMDeE3fRlMJQoPUuKv7hqQ3eZiI3SFv4GQSy9+mmCDx9pl8NVrf
   NnWV+7x3Ato19NKdL1ZPj2wsY49vidV7FOOL/L4Ac3M8sswrw2ClIEctT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="311720552"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="311720552"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 07:38:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="629742509"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="629742509"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 04 Nov 2022 07:38:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 07:38:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 4 Nov 2022 07:38:16 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 4 Nov 2022 07:38:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Em/I9yesl6B81ZzOslqdPU9PPxOclz6TsgYRR9U2UGAdNzvrJKpSy95dns5q+BgFyC+2RaKj5QKbUaRiI+MtNdlvao5xI6xxt59dUr2/vUkcK7tI1n22x/P6QH2wiHHIkykTZdCFSMbTRrwlf6Ue7Fs61SKlKXZ1wokUo6i2hL/u1hB+7Q6lMTehCu5U1ntwR5TUsFFHk//ziimhNAyFs8W7d3hgGcvz9c/txpMVv0WtXLK29IDtblQZpUbQlgGUBnevcOsaTCzRboU3ZMlQHH+SEqb3xvOIet71Or5NucC6iopnxVGhGm1zHyb2zVuQLs+9sp31MXmJiNECthwUMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=krYZLYO3mrm71LhyAkZRHxZDgQQfUnsNPRzVnK56UZo=;
 b=Btli8ofqt6WcXf/80mm5rzDLFjepPnLhfVGY7eSPoFl+oSiw2wls0e0CYY0AR5K/GADA4DMf8aE0al/Y85RZbGeIbx+qrlnFfnNn3P4Gaqt/wi827ilCouMIn8jDcGD2DQzIDHO54H00hNcPuMe8N13CNgLtuUkny1HdcAreMiY2mYEPp87pOD5A2wk0T72NHShQ2mfEkpUsAG1ZJh95Cj8iYmX3mweck1Jwzh4Hp7REuV83AhTTHxcTYoY/WgOhpgJMaHFXIVftWvPEiD1RbTHqUkL2TEQRwXFJO+J2UkddTj385meR4F0h6ak+AnK7UI5FafKdP/geJG+xXmX82w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by MN2PR11MB4615.namprd11.prod.outlook.com (2603:10b6:208:263::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 14:38:14 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%8]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 14:38:14 +0000
Message-ID: <1390589a-77e4-fe3c-853e-9e2fcc5fd57d@intel.com>
Date:   Fri, 4 Nov 2022 15:38:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v8 6/9] devlink: Allow to change priv in
 devlink-rate from parent_set callbacks
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <kuba@kernel.org>, <ecree.xilinx@gmail.com>
References: <20221028105143.3517280-1-michal.wilczynski@intel.com>
 <20221028105143.3517280-7-michal.wilczynski@intel.com>
 <Y1++Hcqm67cv30QA@nanopsycho>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <Y1++Hcqm67cv30QA@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR04CA0122.eurprd04.prod.outlook.com
 (2603:10a6:20b:531::24) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|MN2PR11MB4615:EE_
X-MS-Office365-Filtering-Correlation-Id: 68ef31a9-ef37-4525-d71e-08dabe723493
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jy1IzIxLwxdhHJY5KzhgYtl0pdkyv2U0jboGJ67V0NS6YPb686WIjsD+WgLuIb3qzqSC+joMYLShUlpBQV2yBqo3VXVLxo8rkhv5uoN9/hhPH9J7BVmZ7UjuYbTFq1c6hy+prz4PJ+2G9v8QbIJitVzWdcnTnNGzYARPN7PgIlqA6GrX0sgMR1Wrsmw6H1SXMzs0jp8ZSSPvCVlXAz1tcuK6CbULGrI9wQqfUdne97TunIkCyqRkh7SI3NvJP64o/x7iv2Bflqy1J/+zI/nkP5N7nDH9RrzD0HJS/DzthqLb4OlkWjLpC4nbh0+1EoQGvBlSN2WaSfJnFzZh5OtLXGgLIZ37qT0hW4XJjHgObtwzEba94BvWJogy7V6KSHIJhx3cAKFi2USTwhu2Ccb4NUFloi6tjpPz3yZVFwbSMxW9Cfpeg0qHVSZQuuZqCBBBwJzwI4Bck2p5FR5OIE1ZHe3ZtI9ZayUtE5GiaYLqcIhhgLYxUAk/PQf24QAZo7wYk/1KGa2+9/qx8dt92ArJ5brccrvS3SYGkm9mEf15gvIxjg2b8ccfqTTlomvLrfKIr0sCPcJXy0iTnXZfCqtcUHAUR7Rk8G63VSZkmMwlAle67nnPuRoOb8yyuiIfktsXRejok3K75n5pturlxJXMhHu2JY0jyMYknrC/+E+9uNNxTcqr+St/kCDJDNQGGBEzt0FuiMkodu+X5l2WL6tXjNxx0mQM+j7eyMQ9sv05BRUrvTQUlMfnmqR0z8mkMQzP8viV2QyxR3ZnB59AQILmKrQGGOaA5Nj5XTX6fOr1Krk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(31686004)(2906002)(66899015)(8676002)(36756003)(6512007)(66476007)(66946007)(4326008)(41300700001)(86362001)(31696002)(66556008)(26005)(316002)(6666004)(82960400001)(38100700002)(6916009)(8936002)(5660300002)(2616005)(186003)(6506007)(53546011)(478600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnhyLy84blhIMGZheGtpTGo1R2tNWEVRSGNWVnd2NitHUXoyeU9QNlM5Y0hy?=
 =?utf-8?B?Ymw3akxJQmRTTWN0c2plT1lPemZwQ1BOZHFhaFZBaFhQdXpQUUlyaTdVUmwy?=
 =?utf-8?B?YUtjM0x4ZzF2UUN0QXVZUEdPbWNoRGtWZUw2eE9BYVI4b0l4Rk9IekhmODd4?=
 =?utf-8?B?MDlGMjV0R0dRcU90ZE9VNWlxdGNvbW9Ra05sT281NkxEWksvZnJIc3NXY0pB?=
 =?utf-8?B?T0pJRGY1RXFKSXd5cGxyeHQ0a2FnUlR5d08yNGM5OEpIeHVBbnJxN3NHUFdB?=
 =?utf-8?B?ajNNM1NEZ2w0WlBjaVErSm05dHdLQ01LMzRHL2UrN3pZdzRrY2twUW05UG42?=
 =?utf-8?B?c1FsSDJrOGEyVDJRWVpQUHd6ZktsSmIwZmdNQ090NFBmTHZ6K3ZScnQvSmxY?=
 =?utf-8?B?MmpjemJlck5FM3JiVHBzVVBGODlPTVJGMzdZTnJhaGNma0hVQyt3MGxjTHU5?=
 =?utf-8?B?RDkrbitIcU04OURhNmdpWm5Wd1BGcm5oajFRRno0bjM2Ty9DaW96dC9MNE00?=
 =?utf-8?B?Z2MwZTgzZVB1VjN2WDFlRzdaRTYyQlY0UC9FeFU1bFNSZ250QWRqOEhNdk5q?=
 =?utf-8?B?N1h3YThPSUdMMXA1Wm0zMnZBd1Z6SGdRQnNHWjZiY0NYYnRIOVFCYWtRN1J0?=
 =?utf-8?B?OTY2RUdtRlNSRTYxVnNudno3YkFrZmUvclI0WElQNW5OZGt6RmZtZ0xqMXZ1?=
 =?utf-8?B?NmZ3OElqN1E4QUtpQnhHdG0zZ3ZKWjFTUnFZU0VSY2cvYVU3QW1TSnZoTmk5?=
 =?utf-8?B?Nm9WRkFML3RGa05lcDhtSGpKZmRsTHZobWJib1VLZ2FZalhwL0FvelVaY2Yy?=
 =?utf-8?B?UWRMdXNnelkwUmpmSUNaSmpXamhTc3lVZ0tiWnMrMFN5ck15L1B1eVVyNDgv?=
 =?utf-8?B?RnkxMTVKT2pvNTN0U3hFVE9hOUNqRnplZStmZVZSdS9aOS9sVXZ0b1E4WnRt?=
 =?utf-8?B?SkZHb2JoNklCMlg3c1BWS1M1bWdweWtzN1lJbUJIc3BLRkpTekxxSEw2UjRj?=
 =?utf-8?B?b1QxNmJLK1dORWlTMjhXeWhjcFhjVWZpNmRZRlVUOFR1V3h3REhrRXo2ZkE4?=
 =?utf-8?B?Q3pMelFIZ2x3WkJrTTVEWUdYWFh1cCtPSENiWnc0NEYvd1RhaTBWdVJHM3dH?=
 =?utf-8?B?OE1xOTdhY1hYNEFjemFEdktEY1gwMTYrT0MyTHJGWnROYTdrQkpGcEhWeFdZ?=
 =?utf-8?B?UFdCR2w3SXlSc0J3cTRER0RhZjI1ckJ4N240MjZmam1GblJ6Syt3RHN1UnVj?=
 =?utf-8?B?NkM3OWI4eVpVcFN6LzJ0S1FiMlVJc292cVp5amU1VTZ5UTRKektGenZhWVRB?=
 =?utf-8?B?SGZPOVkwbVp0SWJNOGVBbThLZXNSczRzV0docU1ReCtzeFlyRmNnbGtaY3FN?=
 =?utf-8?B?Zjk2WllzbmJSOG9RU3lWWXp2aEpOd0VxZzQ2YWhJazVFaEo5dVVTbmNvU3Z1?=
 =?utf-8?B?ZTlZK0Nqd2F1TVErVTl0eFc1WWRDYUx6S05IREI2cjJMcDgxUXVxSmViOVgy?=
 =?utf-8?B?OVZaSXJkMjMzQWNzYXpYSW4wb2JTNlpuaWNCbVJpRXZjZGdKc084K2crUEo2?=
 =?utf-8?B?Vy8zSUxqc1c2SWxXRkNNQ2RyZ3AvZDNQb0lja1NzaW5kYUJuTjBDTXh0MmY3?=
 =?utf-8?B?MTVSNFlabk56em9XNFVIOVQ5N01qL1RlQWs3allXWjVpcnErczhZTFU4emls?=
 =?utf-8?B?Ry9jUlFQK3FVOUdZdVd0MzVLZHp4WUcrdkdYakZlMDBWSUdWaElMbmZYME1h?=
 =?utf-8?B?TFRnSUlWS3V0YkNBR0VYWGNQS0VFeVdOcGhkLzhMYU5jdWhYWThJbTJVbUFH?=
 =?utf-8?B?Wm9jQ3dkWXNKM0llR2lRSU9wMlBKM1RVckFPMmFMR1IzOFhzK1NZL3NOM29k?=
 =?utf-8?B?SStHRFY3OXc4RmRnNnd2Z0ZETURiY0dsUVFiUkpVMUV4NHlleE1qdVZmSXR0?=
 =?utf-8?B?a29Hdkt2VTR5aXRaSXdpRGZUTG5Pc2NOY0EzRktPU2pqdEMrUEY5NktaUXJj?=
 =?utf-8?B?VTR3RDBqN1J4c1g1RWdYK0ZiajFjT1paNnl2OWFUMENSWFZVYTFiaTkwUll1?=
 =?utf-8?B?NHlxTG9KK0Z5QmIwaWNmOXR5Vy95alg4Z0lubkJtTGpTOWREcURqcjUwRzNJ?=
 =?utf-8?B?aTVNRnR5ZElaNlFNUUpEc3dwRU02UC9NY0VkUWhoOUxZVTZieEt1M3NnemN4?=
 =?utf-8?B?Ync9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68ef31a9-ef37-4525-d71e-08dabe723493
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 14:38:14.6030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wjjmCFlzpp+Jo0JaCjiszU0bdn0E/h937hnj/uEGeAWLPFIt2F6jYh70OI6PE1MH31+5VJgP15QGDy274NvNeF8IFpw0ASSkItYvymkFk+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4615
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/31/2022 1:22 PM, Jiri Pirko wrote:
> Fri, Oct 28, 2022 at 12:51:40PM CEST, michal.wilczynski@intel.com wrote:
> >From driver perspective it doesn't make any sense to make any changes to
>> the internal HQoS tree if the created node doesn't have a parent. So a
>> node created without any parent doesn't have to be initialized in the
>> driver. Allow for such scenario by allowing to modify priv in parent_set
>> callbacks.
>>
>> Change priv parameter to double pointer, to allow for setting priv during
>> the parent set phase.
> I fail to understand the reason for this patch, but anyway, it looks
> very hacky. The priv is something the leaf/node is created with.
> Changing it from the callback awfully smells like wrong design. Please
> don't do that.

I was trying to point-out that nodes without any parent, or children
doesn't actually exist in any hierarchy, so in driver internally we don't
really need objects representing them.
Anyway I removed this commit in v9, this involved pre-allocation of
ice_sched_node so it's not ideal for me either, but it solves the problem.

Thanks for reviewing.

BR,
Michał


