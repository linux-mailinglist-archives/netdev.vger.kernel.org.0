Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3A561610A
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 11:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiKBKjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 06:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiKBKjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 06:39:18 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2C029362
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 03:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667385517; x=1698921517;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3n7Zfosxw0TOKvnURiTEDuNNL7e8dKsQ1pgNDq5mMto=;
  b=Lbl1670kSkO3H4ATif6w2DXQdU4m7O/aGpY08EVvaM78KFEL991MWN6J
   xZVNK9F0T52jH3TDA1B8ViekSxJmAUsl0ErUkKlemqmZakw5HD/BdHSh3
   m5Ix3voraPHN6D9LVAk9Bl5yY/iUjDjidPsWpX8BQ35uKRSz6Yvz+7AxH
   Vt0FMXuiFIWI7d4Hqgn7lB4plsV8OurHOiUu/TurXmerxxGuVdR413hxu
   Lie8p3sayynOezPseE213Kv6EZKImYMpwIrqUAKD/irCMtfLtUefshLv/
   pFGrSEcRo6t4Ra6FjJZFyncmbTR6eqXcogYts2hNwvVvibz2JThrUEnQi
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="289758833"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="289758833"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 03:38:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="723506426"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="723506426"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Nov 2022 03:38:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 03:38:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 2 Nov 2022 03:38:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 2 Nov 2022 03:38:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLyGM6GwowGNN4Hh1cWA91KCZL9aZBOy6kBHf1gCERxZp4vOZhGvUAcrZV2lZtbga1+xIxCQFBwwTcGXgjS70IvfV1VBVc2TOJnJcU5MtLa+g2gxM+adOcyR/X27liewhquMafBGMf9YDw78y8DC2lSjmh/v/pcDzebAkopM5JpmaRKFrKK4fgmu/j+Edpcey4E9jdYikrjE+F+KD73GzdmbAgskR6q8QyNU7RsvclHjpioefhtT7wTl9/tCD2BYanBtcG0udeYKENth+Tny8PKqo0A+B/gn0zjfn3p5CsqXpGSAFRi88UVzbS8bb6lpKmGiwSFVoHdZr76YChuQiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AuWxS6SrJqENnciJIXhRJSDUnVTWK90qvr7xUg86Zv4=;
 b=j/KqWs72gKdzUbF+c9/2in3tEVQBS+C/GplZzG0sgEdia3g7CBlWrBwJr10ju222vjobBRHtKuzm1rss4GMMxcTdIbgwJQV/ZxQXOUNYW4yU7698hmmfLwlOVKygr73pJbjZ3uC1H6bMoejXgvPnS+FvnUFEXSgBz+XB9AA6BrPuEVcHE/XTmiwgrv7TKv2LRPKJFiXDE5gkIGcF4NS7wktmxB+Eia5QCtBju5nQPhbieuLy/G/DoWCrVPEbLXTq8IzdgE8+6N4+oAgpbMQDsSW9cWspIBd5RSOrrHBDSJdp2NyCd+556RCQsKnztBwbUcjXuEBfyAOndlA2PUDS5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by PH0PR11MB4920.namprd11.prod.outlook.com (2603:10b6:510:41::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Wed, 2 Nov
 2022 10:38:33 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%9]) with mapi id 15.20.5746.028; Wed, 2 Nov 2022
 10:38:33 +0000
Message-ID: <496ae3f4-eb28-dc2d-f37c-4aeab9eabd42@intel.com>
Date:   Wed, 2 Nov 2022 11:38:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v8 1/9] devlink: Introduce new parameter
 'tx_priority' to devlink-rate
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <kuba@kernel.org>, <ecree.xilinx@gmail.com>
References: <20221028105143.3517280-1-michal.wilczynski@intel.com>
 <20221028105143.3517280-2-michal.wilczynski@intel.com>
 <Y1+ftW7vmzJlg48+@nanopsycho>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <Y1+ftW7vmzJlg48+@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM6PR08CA0008.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::20) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|PH0PR11MB4920:EE_
X-MS-Office365-Filtering-Correlation-Id: cbb153b3-39fe-4d10-9822-08dabcbe63c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fnplZL+4UuGPsJDVUlQc7L9PYoh1A9QxyOs9L9OEwiav11XuTkN/6guXFrgt5/LM4rsLTfnu0Sa9h4jmjwUinEUg3aIxw4PNCKU1zTWwLa4H1npzM6CjvmdVrB8ceVLv13UdaBAC/ScNBt0XTKFAf68SmBSKBjneL7ZsrdyZeCqkqL6F9fyhSmjynrJA2CLwVu9humMApjw+ntuWtnlntag0QAVgGUW1AgNwKBlMGwzw2HAdr0FbaaL3y9rI5mvCRdCAZGWIOpzDIQHFdGRhchuaKxm2atABTMpsQGLFyKidXME3tlQPf1D/dbrGHBk4PCeTIO5uzP1q83WBNqPeBA90A0T1JcdIOV4l4gVEIPAoNKsix52NTj4iotFl83J5j/VFZkaBzQ3+9y7TO9Ik9oTAGY3Tac2CA3mqdUXJXoG2MS4h0jVTV/yTMNbKNxUFQ+r4Rq4LQfJb+MjWz7QYrWi9wdmpgGR5v5tMKM57x2pydi5hMmxYCBtEhAMphBMbCVwWDs7UcQstuPQjAyu12X+VG4RODSk7P7SrKE9CR+zkVvbbeq5PPsLQbDDjiG6ilOcmdOKwuxvD9K+giDbGjJVmRxve71f219bskjhBSfosyV1zPa5z/HGCwOkjqvnsMlMaprn7Fx9aHzBoqGvfrKjH5iDXSGOPrDN13sJCmvyXLi8wH08TqYG6hNDn+KBQPiA6QNpWJAm0Y0d+OXNdVitw2oaGizrylkJE0rXtEOZ6Gdh1d6AktYLJaMpPeFvt7nMTr7Kht4Sy7xq6qWIFs11N4X6KDZINZ1uTHK39DVM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(376002)(366004)(396003)(451199015)(38100700002)(86362001)(36756003)(31696002)(82960400001)(31686004)(6506007)(26005)(2906002)(83380400001)(53546011)(2616005)(186003)(6666004)(6512007)(478600001)(41300700001)(5660300002)(66946007)(6486002)(316002)(66556008)(4326008)(66476007)(8676002)(6916009)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vktyb201a01EeUpTdStoVTdUd3Y5bzJBNjhvTThOYThQaUF5cWNwR0tVL3BM?=
 =?utf-8?B?ZlpodUJ2Q2d2S2RDa3grTWdhdXVaRzNoZndtbERrRkRpWWU5Tzk2QjZlZ0d2?=
 =?utf-8?B?MTNnUWcyVU9QUk85UmZzUjVRMkFCdktTUW01SXJGQnlEWUZtdndzbzZUTWtQ?=
 =?utf-8?B?eUdMQ29RQTJZQTlGK3RZTC9OY2Q5akxmUWN4SjBGTEduWXZEcUxkYjJMZVBT?=
 =?utf-8?B?UXVVSVhLbnUxM09OSkduRW5lTUY3VjN0NTFIL1RHOXdVVngvcWJGQmpuWWc3?=
 =?utf-8?B?aGpZSUdXQWgwaTM2ZmdQRG5rLzI0Z3hmajcyd3owMllWUU1uOWl6cUJxaytk?=
 =?utf-8?B?OVkxdWRSam5ReFdSdFJDTStZY2FYVVh6Q0ZlQytTYWdmUFo5SndXNFhkb2kx?=
 =?utf-8?B?VW0wY3UxQ1M2WXpNNkVlZzFKZjNJVEZiTzBKaG00bDFKdjVqMEIxVHlxOGo0?=
 =?utf-8?B?aTF3bmIyek1zTEEvd2NHaVFlYUt0WG1McHhRNDdyS1Uvc0xPWXJIODNSbFFx?=
 =?utf-8?B?enI2Wkd6a3J0SlcraXRlV2plMC85cDVBUDBrdWdVWVRUMzEyc2plS1IxUjhB?=
 =?utf-8?B?b1dsdmFaaUVDR0ZiTGhZdk9ZUjlabFJvSHRtWisycDNLaXE2VzYyZGMxQ3pV?=
 =?utf-8?B?c05rYVVvWWY2aGJLU1kramhtNnVFV2dYZkxWT3RaZ0pMeUlCSkJyMFVpRmJW?=
 =?utf-8?B?TVloYzkxd3NjTTVVUjRpcEZLYS9DZnlLSWxOSkQzWjJ4ZTdwWUc3UGQzTExJ?=
 =?utf-8?B?TWRZSDN6VHA4RXlzZ2pSSUNtN2IyT2pQT04wS2VmNytSMm94a2R5L25sektY?=
 =?utf-8?B?aU5ORGdaWEExSzUrMEJXOXVUNC9DM2F3eWsrTTY2c0dHVGdqRHRROGovVWlG?=
 =?utf-8?B?SHI3Q2kxdjNBRWxGNEFHeW5ZL0xzOThabm5RWWIyQ1VSMUV4Rk95TWVIaDFC?=
 =?utf-8?B?RHJlK041Z1FuSVQ4TnhNcXU2bVNNWDRFeEJjd1JCd2NtWG9tZzFCaXJPdFN3?=
 =?utf-8?B?aE51dCtULzU2Qkt4NVRWZUk3U0pQcWdHQWEyVEtmbUg1cVhQVUxobit5b0Uz?=
 =?utf-8?B?ZXVXelcxaFFDN1NTQ04xcGlMRUJ1WGcyd21Bc1FZSjdvbzl0aUwrZk5Va0xq?=
 =?utf-8?B?WnpMWjlGNUVwODdiQkJJaG9zam1xNEVieDJJUit3TzErVVJ4REVQcHdCamxk?=
 =?utf-8?B?TXhpeWlVN2FoS0RYNXhJa0szNEUwTzFsTURpMWQ5RXUwTEU3eDJlaE9sYVhm?=
 =?utf-8?B?ZDkvNW9rMDJ2SG81K29LaUQ1bmNVbi80TkRWSi8xV3ZqSS9ZV3p6NnRGZzhn?=
 =?utf-8?B?NVRkMjQ1VkNKK2pnZVdzV1JHREJLSlFLRG53c0o2d0RnVEo2anUwZ0cvTUVw?=
 =?utf-8?B?eFlQTk9yakZVRTZYRDZVYnh5Z3JFVkFIMXMxTWNlK243MjZEWWk1T3FzVWV2?=
 =?utf-8?B?azVlcWRCa0M1REhQYUdudlQrcUJ3VGNDbm1UWFUzdXFkUm1FaXFsT1YxVHY4?=
 =?utf-8?B?ZmtMeUcwWlFGc3o1cndoMDNUNVcyVldYdSt0R1FTdTN6M3BXSjFvUE5sQjFF?=
 =?utf-8?B?QjdYVVp1ZHFmeWhweURKR0trcVc0Vkd4NW52aTd6RCttQnRtaHhwK25YbHhC?=
 =?utf-8?B?VSt5Zk9sWCtTR0xwNVk0TTZmRW0zekthelo3NHBVbzNkTmo1ZVJPV2FvMUZa?=
 =?utf-8?B?NDB6Q1ZnSHh1TG5ZYVl3b2xpSlZsei9kK1BkVHZncUlUYWtuaWJvU0ZKd0VC?=
 =?utf-8?B?Y3ZjWnU2aDZjR2pGSDJxUmpsSmxyUFdxaVAvUVRnTEdaZzdLOVpmeGhyMXJh?=
 =?utf-8?B?Sk0xa0dMMGp1U2VPMlUxTnlMbSszZWJoL3hVZXpNVkVwRWh6Q1Yyb2p3aG1V?=
 =?utf-8?B?THlWYktuK0gwY2N2cTJJb3VvbTZmZFNkWFhOTkNCbmdHbXBmdkIvVCtGUVZk?=
 =?utf-8?B?bElFNUNmUmpXanNtdmZGWHRtT2dOeEw0LysxU3JpT3FLR0RBcW14TGdMQ2RR?=
 =?utf-8?B?ejZXbFRZRFF1eWJmWElpTDNxTmt5RXMrNlFLRGIxOHJpZHRlVjFobkFNcURp?=
 =?utf-8?B?WHZ5NUNSWDFZSnRoL1djdjJXdmE0aS9QY1lDWGU4Ukp2Q1ovWmhmbG5yeFU1?=
 =?utf-8?B?bENNcEQ0d1F4d1FtdXNjNnRqaFpCRjJ1V1dGKytjMC9LakQzZVZjMWRCc0tj?=
 =?utf-8?B?Unc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb153b3-39fe-4d10-9822-08dabcbe63c8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 10:38:33.2589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AKKKlsBOvNHY0PNzPQwWsONwwaZ6rhl4t/lcjDeVZOc7EQejICwfUHewWHa95RR7Ef7DQPo0qEXXuwgFpucCnUFt/AiI0GUFmH3SguPADNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4920
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



On 10/31/2022 11:13 AM, Jiri Pirko wrote:
> Fri, Oct 28, 2022 at 12:51:35PM CEST, michal.wilczynski@intel.com wrote:
>> To fully utilize offload capabilities of Intel 100G card QoS capabilities
>> new parameter 'tx_priority' needs to be introduced. This parameter allows
> It is highly confusing to call this "parameter". Devlink parameters are
> totally different thing. This is just another netlink attribute for
> devlink rate object.

Hi,
Thanks for reviewing this so quickly,
I will change this.

>
>
>> for usage of strict priority arbiter among siblings. This arbitration
>> scheme attempts to schedule nodes based on their priority as long as the
>> nodes remain within their bandwidth limit.
>>
>> Introduce new parameter in devlink-rate that will allow for
>> configuration of strict priority.
>>
>> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
>> ---
>> include/net/devlink.h        |  6 ++++++
>> include/uapi/linux/devlink.h |  1 +
>> net/core/devlink.c           | 29 +++++++++++++++++++++++++++++
>> 3 files changed, 36 insertions(+)
>>
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index ba6b8b094943..9d2b0c3c4ad3 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -114,6 +114,8 @@ struct devlink_rate {
>> 			refcount_t refcnt;
>> 		};
>> 	};
>> +
>> +	u16 tx_priority;
>> };
>>
>> struct devlink_port {
>> @@ -1493,10 +1495,14 @@ struct devlink_ops {
>> 				      u64 tx_share, struct netlink_ext_ack *extack);
>> 	int (*rate_leaf_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
>> 				    u64 tx_max, struct netlink_ext_ack *extack);
>> +	int (*rate_leaf_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
>> +					 u64 tx_priority, struct netlink_ext_ack *extack);
>> 	int (*rate_node_tx_share_set)(struct devlink_rate *devlink_rate, void *priv,
>> 				      u64 tx_share, struct netlink_ext_ack *extack);
>> 	int (*rate_node_tx_max_set)(struct devlink_rate *devlink_rate, void *priv,
>> 				    u64 tx_max, struct netlink_ext_ack *extack);
>> +	int (*rate_node_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
>> +					 u64 tx_priority, struct netlink_ext_ack *extack);
>> 	int (*rate_node_new)(struct devlink_rate *rate_node, void **priv,
>> 			     struct netlink_ext_ack *extack);
>> 	int (*rate_node_del)(struct devlink_rate *rate_node, void *priv,
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index 2f24b53a87a5..b3df5bc45ba5 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -607,6 +607,7 @@ enum devlink_attr {
>>
>> 	DEVLINK_ATTR_SELFTESTS,			/* nested */
>>
>> +	DEVLINK_ATTR_RATE_TX_PRIORITY,		/* u16 */
>> 	/* add new attributes above here, update the policy in devlink.c */
>>
>> 	__DEVLINK_ATTR_MAX,
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 89baa7c0938b..2586b1307cb4 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -1184,6 +1184,9 @@ static int devlink_nl_rate_fill(struct sk_buff *msg,
>> 			      devlink_rate->tx_max, DEVLINK_ATTR_PAD))
>> 		goto nla_put_failure;
>>
>> +	if (nla_put_u16(msg, DEVLINK_ATTR_RATE_TX_PRIORITY,
>> +			devlink_rate->tx_priority))
>> +		goto nla_put_failure;
>> 	if (devlink_rate->parent)
>> 		if (nla_put_string(msg, DEVLINK_ATTR_RATE_PARENT_NODE_NAME,
>> 				   devlink_rate->parent->name))
>> @@ -1924,6 +1927,7 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
>> {
>> 	struct nlattr *nla_parent, **attrs = info->attrs;
>> 	int err = -EOPNOTSUPP;
>> +	u16 priority;
>> 	u64 rate;
>>
>> 	if (attrs[DEVLINK_ATTR_RATE_TX_SHARE]) {
>> @@ -1952,6 +1956,20 @@ static int devlink_nl_rate_set(struct devlink_rate *devlink_rate,
>> 		devlink_rate->tx_max = rate;
>> 	}
>>
>> +	if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY]) {
>> +		priority = nla_get_u16(attrs[DEVLINK_ATTR_RATE_TX_PRIORITY]);
>> +		if (devlink_rate_is_leaf(devlink_rate))
>> +			err = ops->rate_leaf_tx_priority_set(devlink_rate, devlink_rate->priv,
>> +							priority, info->extack);
>> +		else if (devlink_rate_is_node(devlink_rate))
>> +			err = ops->rate_node_tx_priority_set(devlink_rate, devlink_rate->priv,
>> +							priority, info->extack);
>> +
>> +		if (err)
>> +			return err;
>> +		devlink_rate->tx_priority = priority;
>> +	}
>> +
>> 	nla_parent = attrs[DEVLINK_ATTR_RATE_PARENT_NODE_NAME];
>> 	if (nla_parent) {
>> 		err = devlink_nl_rate_parent_node_set(devlink_rate, info,
>> @@ -1983,6 +2001,11 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
>> 			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the leafs");
>> 			return false;
>> 		}
>> +		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_leaf_tx_priority_set) {
>> +			NL_SET_ERR_MSG_MOD(info->extack,
>> +					   "TX priority set isn't supported for the leafs");
>> +			return false;
>> +		}
>> 	} else if (type == DEVLINK_RATE_TYPE_NODE) {
>> 		if (attrs[DEVLINK_ATTR_RATE_TX_SHARE] && !ops->rate_node_tx_share_set) {
>> 			NL_SET_ERR_MSG_MOD(info->extack, "TX share set isn't supported for the nodes");
>> @@ -1997,6 +2020,11 @@ static bool devlink_rate_set_ops_supported(const struct devlink_ops *ops,
>> 			NL_SET_ERR_MSG_MOD(info->extack, "Parent set isn't supported for the nodes");
>> 			return false;
>> 		}
>> +		if (attrs[DEVLINK_ATTR_RATE_TX_PRIORITY] && !ops->rate_node_tx_priority_set) {
>> +			NL_SET_ERR_MSG_MOD(info->extack,
>> +					   "TX priority set isn't supported for the nodes");
>> +			return false;
>> +		}
>> 	} else {
>> 		WARN(1, "Unknown type of rate object");
>> 		return false;
>> @@ -9172,6 +9200,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>> 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
>> 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
>> 	[DEVLINK_ATTR_SELFTESTS] = { .type = NLA_NESTED },
>> +	[DEVLINK_ATTR_RATE_TX_PRIORITY] = { .type = NLA_U16 },
> Why not u32?

I felt like u32 would be too much for those variables, cause they
represent priority and weight among siblings in the tree.
Currently we don't allow that many siblings in the tree so
frankly this could even be u8, but I don't want to arbitrarily
limit this only to intel hardware, so u16 seems like
a sweet spot.

BR,
Michał


>
>
>> };
>>
>> static const struct genl_small_ops devlink_nl_ops[] = {
>> -- 
>> 2.37.2
>>

