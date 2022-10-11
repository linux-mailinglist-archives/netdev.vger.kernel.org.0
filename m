Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBA05FB370
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 15:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiJKN24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 09:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiJKN2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 09:28:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0C05071F
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 06:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665494932; x=1697030932;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E6n23DpQL4+ebW2GCpz6FHOQaCxIZSk+4ZmydlvX4a0=;
  b=JQD5YVNFtBa9tl98CZwgyw9wEzDHnWSi7hOAiDN8cllkYKo7D4/50gul
   fR6uOdplyN0qE5SXWqBKvcbLFqdC1QG0S6H3GakdwqSwk4wW3b2m6U6n9
   pbVjyMo4NjnjBZ0sPLLTd2x3bzIRaz+huYiWHCzzIhWhayrMyKASimOml
   bQL6ttLCrYjz1XOVeTfpM5ITejsSrV2hKULAbuCi4fY/jPjXoSNe7cmIW
   37I9g5yXWKlFVxTb0NPrgIFWI9JOl7ddxq7kcYuku5PDOmNx9KWbxmMnQ
   bjaHiQ2qiEoIvkR+ceVxBaLGyFo6X6sMJsjTCfCD3UeH47134LVnkWWlQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="390808062"
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="390808062"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 06:28:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10497"; a="751730667"
X-IronPort-AV: E=Sophos;i="5.95,176,1661842800"; 
   d="scan'208";a="751730667"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 11 Oct 2022 06:28:50 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 06:28:50 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 06:28:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 11 Oct 2022 06:28:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 11 Oct 2022 06:28:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gof+2OSWOmDYHUGORXa+rMLxiAmlhcYoz4tmnHkQhf4HwVd6nsq0TKddwCdKpmi68PRSk+po8twq8Qe7nAMgbRuzUlweKmOrq7freQuv4cE7Jjcg+DVZHo++JxUw3wFd5REQzxcCg2kJZUrMug1iWXD9alHABxUKvittrexEbFUlXEt++oLRrIIlPm5ElTy0+5S2exY65C+G94EQMo8K9SF5Vv/dTj2IptKIpADThaU4/cEs3+DpI95PKcZsZvbJml8T2YRoF8nlFFvld5mV2E1gFwhXmOeTdLftdcb0ltInkQGgEMHzvle74Asch00zCOxwmF7E0of0PXv2YWKFug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xuCLLVxmSFi4jICOxFD38XRrg1X28sJanMeCSKJBLGU=;
 b=NZvUOtU9uOZUM2ZrND5CjuBKAJvgQ9qFpmjEEycuCjatuHaLcPMuDRfl1R/Zhosd6t8OuJMFW7suTGCq8TcUAsrOmDY4SLChqDeuxQ14JTXsLtK5pVuO3oqVx0nvZgtQlyzBvT58/9PXfHRpYBWt4zAkiDqzYsgU+kiqtN1gLfxbIJQiXYVpQQXuU6jeXN8xV5dHx/zhLRR9tFzxvIksidh0OMx9s+1TVUrlvmqJ14NScy7Y6x3FR4r/8GZZmEkJbEdxwN8GLPUdV+0Lr5m5E0VAGgjbY4Ol+gcqk+E65E9YmZz9tYhLa0j6zMl5BP8eDiufasUynrvP4jvei1jetg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by CY5PR11MB6161.namprd11.prod.outlook.com (2603:10b6:930:2a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Tue, 11 Oct
 2022 13:28:46 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%7]) with mapi id 15.20.5709.021; Tue, 11 Oct 2022
 13:28:46 +0000
Message-ID: <3ff10647-f766-5164-a815-82010c738e12@intel.com>
Date:   Tue, 11 Oct 2022 15:28:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api with
 queues and new parameters
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <dchumak@nvidia.com>,
        <maximmi@nvidia.com>, <simon.horman@corigine.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, Jakub Kicinski <kuba@kernel.org>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
 <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
 <YzGSPMx2yZT/W6Gw@nanopsycho>
 <0a201dd1-55bb-925f-ee95-75bb9451bb8c@intel.com>
 <YzVFez0OXL98hyBt@nanopsycho>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <YzVFez0OXL98hyBt@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM5PR0701CA0051.eurprd07.prod.outlook.com
 (2603:10a6:203:2::13) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|CY5PR11MB6161:EE_
X-MS-Office365-Filtering-Correlation-Id: 3efd8fd1-4787-44e6-52fd-08daab8c85fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /KCJQzG+lH+QsWb5YGgeM0+Zq66+8iaEjCkK5YBSEagNS+D8NW9rXabuypdq9ChVibqh0eF/ODm1uF1qp7210aBI/fh1sFhZS/VaEb92+8qAD7+wY64UpfqQhXIdrswBnFIK0HIhPUQukXwLcG5eFwsaiP+PcgoXXSu3R4G1Ft3c4mfTLG7wO99Zk+5yscrradGJ+EFPYR2UVWS82KLjGYwep0SDqrYR1PBlkaUntRryAAMJWhS2ytdLHEF5sMbVGhXHzVFv33rR0BGwa3Cd7VYeC3Cb8tGOCVkjxoN3XQDX9rf6LG2f51AQKc73ZX1vNfgQZgNUNUYm49TjXix/DU8vWvO12H6yq6Cg5a3Ak/FtFvpo8ANDxyHdOxuf33NgO0HoIE/wfeJc3icJMOZJrfb3lHyiBbMAYxetvtrI0zgE9W7dJYNLz7XjX5P8siDO1RlZM+iGZUwp3lF+Vf7XPl/Kmp6aoRvCAwmFtA2JffrMSpCkoGZPro4w397/Rvw/G2nCENqINtrwnkoex/EZeafRUOUlU+b+FVCiVaywpVUvYYa433dG2YaDBwjIm8gnqFsmMqgLL7nc+fR2AaHEfHXDpGVxbx0uQ5794xB7ge5IxKoIgAXob/faes0aYDMbVgSQF03evKLT+uZ9I9M3rqwO5iz0RaK0mm1TaY0rCL0Q6TfznZ71VQcRU3/Xre/JgtUGItuKtvKd7rnk9RS0HRuzzPGt+PhCm5JTiGDbxXBPnDK7Gc8g/dUNahhdcit2qo0qCn6xaBJYfucFpNuw+jJmY/jzYjGnHwky36rCt3rY+mQpuorX/UNx+BMOTdgWzpJ/op7rN+6yr4y1oq75ZLEjpRXRLJwCWQ6HnrKepE0STe89+PKET1e6R2ivKjXK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(376002)(136003)(366004)(451199015)(966005)(66476007)(36756003)(38100700002)(82960400001)(66556008)(4326008)(31696002)(316002)(66946007)(86362001)(8676002)(54906003)(2906002)(6512007)(41300700001)(6916009)(8936002)(5660300002)(186003)(83380400001)(2616005)(6666004)(478600001)(6486002)(26005)(53546011)(6506007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zys0b1N1NTkwc0NvenVxTE9mcUpNYzZHWVhMYmlsK0Z1MFJadkJOVzdOanVN?=
 =?utf-8?B?blRIZEVJUjVBTmI4bE45cTdqNXBVcW5KWnpuQllkRG1EZFhpdVgvd0hMMEIy?=
 =?utf-8?B?YUpKZndNS3pQbnB2TWxueDdFbjhNcTdzYXNCZyszMGowZm1aejF2dm5XL3Np?=
 =?utf-8?B?V09LaHc1Y0dvSm5qdDE0NUZkK1FXN3dyOVRUQXZtZGsyNE1ueHlBNG1zNUpv?=
 =?utf-8?B?aWcycXJvNVZTaGZIV2ltVy9KQ3lyT3lBWHhOdUZ5TE5aRzRkSGxhTjJHdUF3?=
 =?utf-8?B?LzhmYm9mNzVueFQvaC8zbHpvYjR4Z0s5ZHBhRDFSTUNQYm1NVFdZNGIyQXJ2?=
 =?utf-8?B?dzh1MFNiMHd2NEhGMi90Y2tIQVFYQ3ZnZmg5K01uYWE5aFZvVjg2WDJSeHhr?=
 =?utf-8?B?TkNnN2tDVHZiWXRFeE9GTW0wUS9zeXFuMkVZY2J0MDg3c1ZhVzBVTFFGSjZT?=
 =?utf-8?B?V0FjNkQ0Y3phV0NtSG1TVitRNmczQ0g4eDVLVWxLRjVLVVBrNUlzYytkNHA3?=
 =?utf-8?B?VHhGZlpadXFaM2FEUTZvSFpDZFMyZlNrRCtWYktFOFQ4VHRINjJnUERMRGVE?=
 =?utf-8?B?cnlNVWx6UnFUaDJJWC9jYTNMeVB6NklVSUQ2cTRhYU0yVWJlak1oZzMrdWZn?=
 =?utf-8?B?aDFHbGs3MUNubDVoM3lhc1ZpRTdWYUlldUVDcXcrTUpTZU4yVDRlOUluV0My?=
 =?utf-8?B?SkFqREo1SmVpbnFaMXp2RHNJd0hiQlZtRS9HdzAwSFEvTVlqSmpUUW1QUmZX?=
 =?utf-8?B?MmJ0amtycTVVQkx6U3QreHFXMll3YzdtUlBDaVBpYm9PYzRwMHlBSXBDQUZ2?=
 =?utf-8?B?VDNjQVExdE1mS2RGbERrL0JFYlY4VTNHSWVsSGlHMUJqMHFOcVorSWRVYnVv?=
 =?utf-8?B?cEFKaGpHemVyTkkzb1U2QU9QSGRVeUpKdG5EU1d6MC9lSzdsRU4yODh5RzlG?=
 =?utf-8?B?MGhUWVp2TVR3RHN5VjFsdUJSeDB0VjZab0h6bWpkQzVhaEVrMUZKR0F2UGpy?=
 =?utf-8?B?dzl4RXNVMDR4QUxtMzFydnl1c1hzYTdsck9Eb1dTMjBsdFErdklWNVV1dXBx?=
 =?utf-8?B?UWhBN2xmK01NaU53Q01Ubnp3a2hXbUZGWGR0RzVXVmVhUjRYZlRIZ0Z2YThH?=
 =?utf-8?B?L0lHTVh1TEQzVS9LRUplVFpIVDJPa2dzVVFQd2hwQndORWpTSE5nam1WbEJ3?=
 =?utf-8?B?TjV1TlNVVVU4dnF1NjhwNnhsQTFmbUlSc0xxQmg2YmdNWVZ4V2dLNzc2N3hk?=
 =?utf-8?B?bWw1bDdIaXExaHBvRmRqRE5ucHdHWXZvUDFsRTNnMWVWUXlIdGY1UGlvNERD?=
 =?utf-8?B?QVRBNjFRNnVlaXZCb0VUT3VjeEF2UDdmMkdNSGVMd25HcVRwZ2g1bjFTVU9K?=
 =?utf-8?B?Z0JGTmpERmQvck9lUmlGRVVzVlFHR1FsdWJoTU1rM1dJUXRzVnE3S0JQVmlO?=
 =?utf-8?B?TzBwYm9HQUE4WU1PcHg0MFJtNXpUMTlndGxxL2RXa1RGdjJoU3JmeGJreVkx?=
 =?utf-8?B?a0JXdEdXNUhEWVl0cE1LNi9keWR2L1VqTHQ4UFVveVdwb1QzLy9QZE5tei9N?=
 =?utf-8?B?T3FSVGpwT1BBdmlZRUFUT1IxaEJKV01VeWZ0cDNCaXZkVm5FRjR2dUg3ZmEw?=
 =?utf-8?B?RXl3aEtWZHgvUGRlMHAvZnVSb01FajhScElkTkdTN0FaT1pONE8wVm5EVnBo?=
 =?utf-8?B?eFdkMFp6ZVU1dTJUWEZvOG1vMmRTalpleGZjK2xkU25IUHpyZCt4MjdmdklG?=
 =?utf-8?B?WmVxcUNGbHJTNEdGWVpuUmsyYkt2dEZaSU9WbUoxM0RSSndObUdCSEhmN0FL?=
 =?utf-8?B?eTJuSUdBTzZrakVEbVB5NVVoeUtKQ3FhVmI5Q21jMCtsT2c3bzZ6YlNqQVlu?=
 =?utf-8?B?bGU5VXZ6cG5LZmxlWnNSM2ZpNEUvbThVb3dKb01KeHUzbEVuUURJUk5YSk1D?=
 =?utf-8?B?NHJBejNRNTdaNGZQL3NTOWtJYW1tcGFZSmd1TzBhNmxIT0RjYlJMcVU5NzY1?=
 =?utf-8?B?ZUI0c1JtQlF4aUFJeS81L1NHQVRsbmtQakJGNk80Wjl4ZUtLeW45NDE3Z0JX?=
 =?utf-8?B?VUpiZUpzY2tublFYd2FHWXZuZXdKdEdsWGMvMFpjc2xJL3J5eE1CVnArTE93?=
 =?utf-8?B?NFpqdGxjVHM1U1phT3kwbGhkcEUvWFJEek4wTko2WGg1Wk9sZnVFeTVXamV5?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3efd8fd1-4787-44e6-52fd-08daab8c85fc
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 13:28:46.0835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uh9ca1sRzT4QmFrIdxDmxy9aIVVwu7J7uOYloyhvqPgE0yLYWjlfm0rBmGV5YVPKHYyGley3txRwFZicNL17Dg8aVOGcyQcHrgrutybUEBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6161
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/2022 9:12 AM, Jiri Pirko wrote:
> Wed, Sep 28, 2022 at 01:47:03PM CEST, michal.wilczynski@intel.com wrote:
>>
>> On 9/26/2022 1:51 PM, Jiri Pirko wrote:
>>> Thu, Sep 15, 2022 at 08:41:52PM CEST, michal.wilczynski@intel.com wrote:
>>>> On 9/15/2022 5:31 PM, Edward Cree wrote:
>>>>> On 15/09/2022 14:42, Michal Wilczynski wrote:
>>>>>> Currently devlink-rate only have two types of objects: nodes and leafs.
>>>>>> There is a need to extend this interface to account for a third type of
>>>>>> scheduling elements - queues. In our use case customer is sending
>>>>>> different types of traffic on each queue, which requires an ability to
>>>>>> assign rate parameters to individual queues.
>>>>> Is there a use-case for this queue scheduling in the absence of a netdevice?
>>>>> If not, then I don't see how this belongs in devlink; the configuration
>>>>>     should instead be done in two parts: devlink-rate to schedule between
>>>>>     different netdevices (e.g. VFs) and tc qdiscs (or some other netdev-level
>>>>>     API) to schedule different queues within each single netdevice.
>>>>> Please explain why this existing separation does not support your use-case.
>>>>>
>>>>> Also I would like to see some documentation as part of this patch.  It looks
>>>>>     like there's no kernel document for devlink-rate unlike most other devlink
>>>>>     objects; perhaps you could add one?
>>>>>
>>>>> -ed
>>>> Hi,
>>>> Previously we discussed adding queues to devlink-rate in this thread:
>>>> https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczynski@intel.com/T/#u
>>>> In our use case we are trying to find a way to expose hardware Tx scheduler
>>>> tree that is defined
>>>> per port to user. Obviously if the tree is defined per physical port, all the
>>>> scheduling nodes will reside
>>>> on the same tree.
>>>>
>>>> Our customer is trying to send different types of traffic that require
>>>> different QoS levels on the same
>>> Do I understand that correctly, that you are assigning traffic to queues
>>> in VM, and you rate the queues on hypervisor? Is that the goal?
>> Yes.
> Why do you have this mismatch? If forces the hypervisor and VM admin to
> somehow sync upon the configuration. That does not sound correct to me.

Thanks for a feedback, this is going to be changed

>
>
>>>
>>>> VM, but on a different queues. This requires completely different rate setups
>>>> for that queue - in the
>>>> implementation that you're mentioning we wouldn't be able to arbitrarily
>>>> reassign the queue to any node.
>>>> Those queues would still need to share a single parent - their netdev. This
>>> So that replies to Edward's note about having the queues maintained
>>> within the single netdev/vport, correct?
>>   Correct ;)
> Okay. So you don't really need any kind of sharing devlink might be able
> to provide.
>
>  From what you say and how I see this, it's clear. You should handle the
> per-queue shaping on the VM, on netdevice level, most probably by
> offloading some of the TC qdisc.

I talked with architect, and this is how the solution will end up 
looking like,
I'm not sure however whether creating a hardware-only qdisc is allowed ?



Btw, thanks everyone for valuable feedback, I've resend the patch
without the queue support,
https://lore.kernel.org/netdev/20221011090113.445485-1-michal.wilczynski@intel.com/


BR,
Michał
>
>>>
>>>> wouldn't allow us to fully take
>>>> advantage of the HQoS and would introduce arbitrary limitations.
>>>>
>>>> Also I would think that since there is only one vendor implementing this
>>>> particular devlink-rate API, there is
>>>> some room for flexibility.
>>>>
>>>> Regarding the documentation,  sure. I just wanted to get all the feedback
>>> >from the mailing list and arrive at the final
>>>> solution before writing the docs.
>>>>
>>>> BTW, I'm going to be out of office tomorrow, so will respond in this thread
>>>> on Monday.
>>>> BR,
>>>> Michał
>>>>
>>>>

