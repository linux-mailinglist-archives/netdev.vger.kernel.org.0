Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21D76665A1
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 22:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbjAKV3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 16:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbjAKV3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 16:29:14 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7C8633C
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 13:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673472551; x=1705008551;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S8LQfv6VEjtcc6+sgSsqPOtxheMgAxbLQVVS/Bo61Yc=;
  b=JexM/0Tk2tJJPuxtaoPIHUSTSuSfFQ6ZIGJVwlCK0w9iGe7T4gPVRs9t
   Am0zB+8IPtIYQhE7ObLPgIcGIIjBRtzWvTrMg0GaQperkEhp6g+BVs63X
   GmX6qZB5fPyj84iwbEnbe0psTnHG06FGT4B1vtzqL1X40taz6XpEogCwB
   RmUcDCK7IO+scoLsnFkeEQDEQjs96Zoy2yKrHelpWtxiShUNghtC4EUla
   tc1gOhTU9byR7qoCwkLSCY4hvTcazV+SulCfxuClI4plnKEg7dGENUi21
   WYNACKQa0A9eqve3oYE6w8CnAqSkP9WMelwk18QLkU9T9URAV6iOMH7r2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="307063217"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="307063217"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 13:29:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="659529902"
X-IronPort-AV: E=Sophos;i="5.96,318,1665471600"; 
   d="scan'208";a="659529902"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jan 2023 13:29:10 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 13:29:09 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 11 Jan 2023 13:29:09 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 11 Jan 2023 13:29:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EG9SIUeXZFmVDR/Atu+sXsTrw29SQO/9LLxt3LXt8j5/NPjFQfejbnqMGQoAvaKlRdbmEBz46EISTVwp4+Lrdj5BF3of/iwClAXsrnd2t7DQlNHBDNB8YCpjam3tlKuVk1t+3QmZA0GjLJPwMvsFEA+nLbRi3Vx8Cj7oXtiQ/O4YrmHaDUpPfTftolYwCIk/orhDdfRzNpfNl97nqouMT4GzdTnOq8kLfzu80kVRvwZZvRxAackTR/6u/SrrN17YoTEhGL0LvA8O5TTE1aT979lcGd+rwY7u9igowssO8PaPVGxtWc3SgGqwnGp3l863koUw1Om0z5kocfhzrOta4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=150JUDrB7QsAYQrkZk59UZWHbdfZf7cOsQbX+ZtE3e8=;
 b=Nam5R0KtxtNrIcVsCvnuESKbENh/qIFPCdtANCIzNBmH+O+gKh5GzpNVERfZbaVa/V7l/H19yVF4DbSfOM30fgYXKdDbB/2QaLuxvZCPHCdlJg66RF1BIEw1TSWBSnNLzeSTcehYv1QS7qNGicM42vXdEm1ceFbsTk+myhbvRJzdXZPnOCU157DKSGoEUfFBwfvBPbjPu6UCRS+hJg1HYKiCdS8QlmgCX/bxkH7PyKEaEV2lP3GsZN1c0enmZUzwmr/JTIJVrq1RPWoq/xp7617u5kmefmDBoj748cawchy/aGZlSffh1Zvq8YmKWsVUkkX5ZdLffgbncZSy7kS5rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by SA2PR11MB5035.namprd11.prod.outlook.com (2603:10b6:806:116::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 11 Jan
 2023 21:29:06 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::ef17:4bdc:4fdd:9ac8]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::ef17:4bdc:4fdd:9ac8%6]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 21:29:05 +0000
Message-ID: <f5d9201b-fb73-ebfe-3ad3-4172164a33f3@intel.com>
Date:   Wed, 11 Jan 2023 13:29:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-8-kuba@kernel.org> <Y7gaWTGHTwL5PIWn@nanopsycho>
 <20230106132251.29565214@kernel.org>
 <14cdb494-1823-607a-2952-3c316a9f1212@intel.com>
 <Y72T11cDw7oNwHnQ@nanopsycho> <20230110122222.57b0b70e@kernel.org>
 <Y76CHc18xSlcXdWJ@nanopsycho> <20230111084549.258b32fb@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230111084549.258b32fb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::6) To PH0PR11MB5095.namprd11.prod.outlook.com
 (2603:10b6:510:3b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5095:EE_|SA2PR11MB5035:EE_
X-MS-Office365-Filtering-Correlation-Id: f9605acd-6631-4b63-a23b-08daf41ade0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QyL6OirBBjoChQXoYdlWH422FWZcz2PSSTmTTeLmg4eaQsntTDVFXNX1zRBgUNfCnBvh/OZ6QPmrd6MvoJNWtYCTEuczKRwzWeKf8PAptRPBkwyrSxIJmBjcd9xyyKP3O42OIlK6BVmSXj39ApYgCc65/D9AURO7CzvIN9gQ942nh/wx0Y2gmno/Orcs2K0smVjYbkndbCbfAR7+hN1/8eIN77ux2Zp0MQPrxOJI5SS+gDoo1/qnmVwUpWQ9mT3vMNi95+dqKt+XuPI7wQpocTFwlDVGCu56B9max8ldwdj+4Z73g7BgZLtVROAP99R7uGOD+kNedICdmOVlk7aIiADldISUOM3dmYmlLwleu53wPOdvgXE3GNY9Pcg2OmlYg9LayRYgRKrhOGQJWxGmLuZ8YJG2hjTOHiCxonWPm3aDFw1NYDA/BJGiC5ci++gzvuPuKUe9pRgxwta1igkHdWF0+5yML8Bqu4hlz2lx7q4La0mXwvUjnVrc+CJ+YVfS+r3wL2TkkQ7TILcQrA8eeU86KDYQtq9FqhUYv7QGFKRccOxO+2iOSVXw+DAXgkqx570Wh3hspw+4YwXENIY5LfV+kZZYLzEY6cWaJP77fLbGERY2ukhtvMPXwQjD/0QCbOkLTRj4qs0StxUSnrhRqFHJ38MU6uGon9WRWbWIzLdLkCe1SKh9IYrpJ4do19+D9Ldf17v1iKhawuXLxgQtlorYbfpjWX4oX9Wt0rld6wc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(136003)(376002)(39860400002)(451199015)(36756003)(31696002)(86362001)(110136005)(316002)(66946007)(66556008)(66476007)(41300700001)(4326008)(8676002)(38100700002)(82960400001)(31686004)(6506007)(53546011)(2906002)(8936002)(5660300002)(26005)(6486002)(478600001)(6512007)(186003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N05sQTJZVXdRSlp6eTMzOEE2aC9JOTRGWm9jMVlHUFVUSGNtOTlBVXA5QjJj?=
 =?utf-8?B?Y0Y2L0Y2bmR2WHZBYk9DN3NCTityRVpLTHZUOWdJeXUxSEVyS3BHNXNvTktv?=
 =?utf-8?B?QU9yWFQvdG5GTWlORllHUElKMTZFcnJjbWJVaVV0U3c4emkzWnl6NG9uRk9D?=
 =?utf-8?B?SVBRRGcrOFVnNVJpWGN5VXVqUVR3MjB6aERPU2NYUjV0dks1VGlyRGlNaTNK?=
 =?utf-8?B?WGQySU9vVVQ5M2pocStzcVJwS1dyNU1yZEFLSTEyaHA0R091VkNBc0VJN1FU?=
 =?utf-8?B?RFh6ZnhnbGMvNnd1QmdaVjRwWCsrQzNtY1U4S3NjbUhpU28xK0djRmNlZzNq?=
 =?utf-8?B?S25sb09lRXkzNGRWMFM0aXJqdUdwMXhlYmErVmJjbU53NlJDT25PdmNDY1Iv?=
 =?utf-8?B?UW10cTRKTnFVMmhPc2pjM2tCeUhDYzNXKzNWMjcrOTNpaHFLSE5kc0N3eXhx?=
 =?utf-8?B?YlE0ZlY4ZWZPWEdCMzQranZUVnI3OFp6S0gvYWNUNTJrc3NTU05BS0VZcDhC?=
 =?utf-8?B?NEhyZEtSR1h6aDQ2eVhBT1kwYTFoSHhJUVRnb2VQWDVLL0FzZWxuK0FLZWhV?=
 =?utf-8?B?NytYMEJlanU0Q2JvN01zZ2o5ZDJFS2c3N2hHYXJuZnhhZHJwTGFsaXl4NWlI?=
 =?utf-8?B?Mm1ndWdPZ3E1dUFDdFQ0elZLKzhqaWIxbjN3STZ2ZDdTNFM2SVRIM2w0UnY5?=
 =?utf-8?B?RGU3ZHhUL3RaSys0SWJpN013cUk2clFWRjJmQ3JTSVNoTmdYTXlIOVlkYStk?=
 =?utf-8?B?QXJZY3NhWFhZNXdjNTFqY0pZTEQycER3K0xhZDFYSzlEWE43VW9iWkpqRmNU?=
 =?utf-8?B?MXE0K1haQUYxbnFrWG1kOG94NVVvYWxEbnFqKzNVeXd2WFFPTVFnUElzOVY2?=
 =?utf-8?B?eGp6MGprWWtIa3l5dVI5ZG5BaCtIQTYvdEs2dkVuZDA1Y2ZzZXZyeFBFKzBH?=
 =?utf-8?B?QkRZNEVVVXQ0a21SaVd1aDFQL2lNelJ6RFV0dnhUYkt1ZC9JQ2EvemZoZnB4?=
 =?utf-8?B?dkJCTEtzVzZwb3BQUVdMR3F5K1pWWmNEVHZnTW5qVW5xZS9xcEdXczFQVER5?=
 =?utf-8?B?bHdoMjJMM0x3UVM5SzlDYnhKWjcwOGkrR1MvYytoUVJQdmVHZ2pxQTk3b1Qz?=
 =?utf-8?B?VHNQVXRXQ2hRWW5EbEJnVWdMQ09zUDNqbVo5Q2hDc2RBcWpVbm1pQnM5eEJW?=
 =?utf-8?B?S29kNmFLWlV4SldmQTU2c2FQZUNpU1BEa1d6K24yU29aQWd2Ni9qS1AyZWJN?=
 =?utf-8?B?QWJTV2REMGtUdjVBWEZWdzFtMGcwODQxejZjbTlUOVplOUtBVjNhOWRaREMr?=
 =?utf-8?B?Skc4WUZrYXQwVEU1d0dDSjkzRUtRQ3dPSHEvY0hJS1IvNWFSandmTzlzNlJI?=
 =?utf-8?B?ZHVkMTY4eHFXZEJTNGZTcStxZkxhVFQ4c2NzS2xic0Jmck9VQjR5ZWc5NFZB?=
 =?utf-8?B?SGE5ZFhobGFLYzhHaEtMa1pjY3poSlBXd1YzYlRFbmFnK2ZqQVN2VDQ3eU5B?=
 =?utf-8?B?dFg1Nk1ZendqV2lTV1c4ZzkvM3U3ZEhXMlpjQnNBRk1paFBGcXdpMjB6aVlv?=
 =?utf-8?B?U3N3Y21BWFEzem1rOGVtM2tpM1U4S3JlZytxT082bmVOck9pZWt0YllpNVQv?=
 =?utf-8?B?NTFyVlVIdnRRSDdUSjdaWjNMVnc0NnZOYlhSa01rbnl6SEFGSFBpV2tsOHJV?=
 =?utf-8?B?VDZ4WjVyUUFvRXNubmxRbGkzQnUzWkZHQjMwdE10eVQ0N1FpVUxKUEdMV1VW?=
 =?utf-8?B?c29pVzdURytjUFlZSzMycWRHWkpGcGVEd0RmTzhPREtmOElWWnJ4Q1lEbGl0?=
 =?utf-8?B?aFNEQWhsNmJFRy9UWDdOSXpVWHZMZm05QmkyM1BtcXVnZEZWRnF3TDBmZ3RL?=
 =?utf-8?B?WGxkaDE2R0x6cUhLZkJ3T3RyTmxVYTFVY0RFZUt0R1NLMkVuVkFnanRWc2Fz?=
 =?utf-8?B?ckNXU2Q3VkVoMkJSU1F1bUNNUzBpTXBOT3JKZGxZZkpmck9WeVNaclJmT25o?=
 =?utf-8?B?UlNuYlQ1SWNvM1g5eG9nRkhCNGRzT3pSUzFxMUt2V29NcTBUeWVnVDRQUFZH?=
 =?utf-8?B?K3BJancxQ1BQWXduL3ZQazNGUVNpUnBGbUY2YzYrNkJSQlVGN21tOGpoQlBW?=
 =?utf-8?B?azhUc0I4cHRTc3VGVjNkbXczYTRHaWhtbGl0Rk14RjBTdGNTc3FBQUc4Z0Rz?=
 =?utf-8?B?bGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9605acd-6631-4b63-a23b-08daf41ade0c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 21:29:05.9136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aa/cck8750QbpUPk2UfVttjWY0QL+vzr3ETyu1W/biFu4TOSyGLdpX3A4JkJQMWv6EOgwhK1/BMAMl18SiIynSBpJat/qq7NaPbFpSXOAgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5035
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/2023 8:45 AM, Jakub Kicinski wrote:
> On Wed, 11 Jan 2023 10:32:13 +0100 Jiri Pirko wrote:
>>>> I'm confused. You want to register objects after instance register?  
>>>
>>> +1, I think it's an anti-pattern.  
>>
>> Could you elaborate a bit please?
> 
> Mixing registering sub-objects before and after the instance is a bit
> of an anti-pattern. Easy to introduce bugs during reload and reset /
> error recovery. I thought that's what you were saying as well.

I was thinking of a case where an object is dynamic and might get added
based on events occurring after the devlink was registered.

But the more I think about it the less that makes sense. What events
would cause a whole subobject to be registerd which we wouldn't already
know about during initialization of devlink?

We do need some dynamic support because situations like "add port" will
add a port and then the ports subresources after the main devlink, but I
think that is already supported well and we'd add the port sub-resources
at the same time as the port.

But thinking more on this, there isn't really another good example since
we'd register things like health reporters, regions, resources, etc all
during initialization. Each of these sub objects may have dynamic
portions (ex: region captures, health events, etc) but the need for the
object should be known about during init time if its supported by the
device driver.
