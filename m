Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C7C6954F1
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 00:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjBMXrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 18:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBMXrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 18:47:03 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EE712041
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 15:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676332021; x=1707868021;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dTTA04IJ62Ol380S6Ra2FARV79ZmeB6h9Omaif8RKnU=;
  b=TWKk4WwNNsCEnkF1+MCG3ROuFUcRJbAVo869R03ahmt/uUBuxzDKpwgh
   GQmQPo52hni8TMAbS8m9kONBgoJ5oFR3LsTKkQOpqu0ivVytRleR5zOw9
   agJqHS6IdH1bnaRVVKyILDmlzDVoLr34g6Ar5PnDVDQjq78UlisMigFw9
   nYlC/TgSjTAIGhmfcIlCWSu8rJiFPzkUC2nI7kVBziOXxPb7ecWXxF/s2
   nvq6K8sjq2ktpunLDj1/X5bnTx9OiejMifFuF7TeO7RKdWPSw61UaWBZL
   xNwLeLwx15inKwDE6ZNNN+2mjdr2+6u5sDagQXoi5yYoFOO9pkRpfEda/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="311389649"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="311389649"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 15:47:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="701456141"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="701456141"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 13 Feb 2023 15:47:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 15:47:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 15:46:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 15:46:59 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 15:46:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWaxlzck0QG7AgPL8TZcxGVaTm5EusBi0gYKw+rb+Frr450uQMxcR0OQhlG/UP8X3ua34LIFFUBxxJumnnOKMEBXYmr3j9oiAcw7zYTQE5gqpVapSsLoPAP0giyCVkTVEtivZbrcGVFDv3yzTFY0Z/JSEzMPTKo89t9222CyYlehqyAKpNB8t/DPjZ/bs3LKJL+ACwvrcAspIfNk+GDCfbkelOrKjOYSJKBzY2eORASoHGJygNP0B4I1lFcFHqVv7k0sGrLND8HyjyASMHVhe/LuPzsOc9WqnVz5BUoMCEzCWq6IBwHFEcamVq0Hc9EP/q6sHIodWHghDp8GLvvhZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=omht1C10sBYDGq9KaeVet/ewkxjnoDg+96Vlv+68COo=;
 b=PaamIIpe68B9rsHfvXB3KwZM+fXWZR5Yc+LZ0QezGOxqy5oUO32hs5Oqq4PDZIzGoV53qUjFLlCnBtwsAqO9lJ6vb/Ef9iYtNn8k/4MAJPPfapIYlY9GvkzlQV18EcXsmv2M7dRxfrH0ev4kUeig5SLPZGtfwvGzhUqAmYCBznBpaGsYHov/BV65Rarx7Qb/qT1f1yvK5LchFFan+3nAGkHxEySXe9zYZ9Q2YAP/IexiQLtpwopL7au0+PJu8z7DS4fKBNDOfkEZxDKJTrPgmijf3+k3mJFHJMWvkAYYhpJGCfMhvcicTmS4Jha4Zwi5oNTHZFTTqyTIsoAKv6QhnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5636.namprd11.prod.outlook.com (2603:10b6:5:357::21)
 by DS7PR11MB6223.namprd11.prod.outlook.com (2603:10b6:8:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Mon, 13 Feb
 2023 23:46:56 +0000
Received: from CO6PR11MB5636.namprd11.prod.outlook.com
 ([fe80::ae83:22d0:852a:34f7]) by CO6PR11MB5636.namprd11.prod.outlook.com
 ([fe80::ae83:22d0:852a:34f7%9]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 23:46:56 +0000
Message-ID: <319b4a93-bdaf-e619-b7ae-2293b2df0cca@intel.com>
Date:   Mon, 13 Feb 2023 15:46:53 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 0/5][pull request] add v2 FW logging for ice
 driver
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <jacob.e.keller@intel.com>,
        <jiri@nvidia.com>, <idosch@idosch.org>
References: <20230209190702.3638688-1-anthony.l.nguyen@intel.com>
 <20230210202358.6a2e890b@kernel.org>
Content-Language: en-US
From:   Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
In-Reply-To: <20230210202358.6a2e890b@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:a03:54::48) To CO6PR11MB5636.namprd11.prod.outlook.com
 (2603:10b6:5:357::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5636:EE_|DS7PR11MB6223:EE_
X-MS-Office365-Filtering-Correlation-Id: 41cd0168-cadd-42e3-b1b5-08db0e1c9764
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YzB46g6j3OOAK0kSA7CsgUi72Pd0k2KdcqizaNb90QixTqU7ctOPiH2LF+rn/xPYR/6XYSVDebaptFGvV1StE/r+NrYPch7O7mlRxwHoQSFx+162SwSlHtsjxhKJ/6PhHjJMEFD6C4/ZDCTMl8e/fTpnRIIqe9vxKE6sdkJP/zcd9Xaadccg29Uh6hfCNT3WVnXuHCuop4c96z+7DAuDop5REStb6i2WtxR6mHYI2QruogujFv5Q6Jbc2d23+AXDdElXNKoHlqIQp1ILa4AXnYHhiiTJQoCv23EgflN+XXZUlEc+HBty78UYWBh7HuhFzOHFG9knNwhvDUdK27AbvKdXzH1E5e+Dru0FG32Q201q0JW556/dcK7bQFC52YbrkadoRm5at1I6UIQDvPzLX5vtMOOU08hG3tsQK2dwY4IGVs0XDvWqn8SXZCoZi/9ijDMCloQIp3pzAKbZOTf8SMer+9LqJiXAQMPg8OQn7WvVejvm6qeHFhXzwKgfEszkFXRmwD8KkJEseWERMYHOGLYU9RKEkeARPLOwBJKh+f8czEeIZDCl3E0KgG//bRF8M12wkORvZnj0II0ZmOkJ92QbJidM3BKt7udTeJNdjxxLJrSYOOAqTIfCL0oFYcVITnqsOC8Y/FCUX6+O5t4u5RRzwQXQkMSinZYnnBmWnKNwXoyfYenOzk+0LYBVQE4IZHd5ycvFG8BmwAoKSvKLPH3CXXlzkMTejpqX0BeNwtc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5636.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(346002)(396003)(366004)(39860400002)(451199018)(478600001)(6636002)(316002)(6486002)(110136005)(66476007)(66946007)(8676002)(66556008)(4326008)(53546011)(41300700001)(6666004)(31686004)(6506007)(8936002)(26005)(5660300002)(186003)(6512007)(86362001)(31696002)(2906002)(2616005)(82960400001)(83380400001)(38100700002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STBGZ2FOdzAwaXp4RTgrL3pqNUNkMEVzYU5ZOEFlNU8yOGxYcVpadDZXMis1?=
 =?utf-8?B?NUtITDh6OTBzT01PeFpZcDJUaTU5WDdHanpnOFl0VGJoSHJOL2tUNVpnb1ZR?=
 =?utf-8?B?SnU0OFptSVdMVEp2L3UxeVYzdzA0YkFQVjZTcytnVTFxaSs2ckdIM3p2WjR0?=
 =?utf-8?B?ZEw0L2FHUXF5R3pTSW1FOTMrV3hqd2lMYmJzM1dSSVJkcnhTL0cyd2x2ZzVZ?=
 =?utf-8?B?SjFjYUhwaWRvYTRoZWZ2SmVVcERMeXplTytoSDRNU0tJUTYxT3N5NXE2SzBp?=
 =?utf-8?B?eFdCVlpZZFpZVWtTYk9ncnYxVndjSDVtbVg3SjBDRmUzdHJYamNadXVtanJV?=
 =?utf-8?B?aWE4Ri9oSVB0eUJZWXVybVVDZjBVZTc5NmRET0g0aGtHSEptOG5aSlljNEJU?=
 =?utf-8?B?OE1Pd0RLajJTc0ZmaVlqU0R6VW1Hc3JkZ2EzUDBUOHlSM3RDQ1pFQzlWZndo?=
 =?utf-8?B?N1RYU2VvR0pZUEVzUGFnSGRCNkNlMUJTTncyUVZXbmkzVjNDNkZRQ1dFVGxJ?=
 =?utf-8?B?ZVB1SUk1TFgzWlYwNE0zbEpCRE4rK0N0b3krdjYxMjVMeVZFWGxqRXhzZ0VE?=
 =?utf-8?B?dXlGUElsOEhkYm9jbWdqWjNIbEdCSEVucnVQb2lSMWdWbUdrVVZIRXYvTVVw?=
 =?utf-8?B?VE13eEhVOHRjRnpyb2g5ZUkrWE1KejFRZ0cwS0l5QW4yUDdTL2NrRmdKMFlI?=
 =?utf-8?B?akx5dFVEdlhpN2NmQ1hTOVQra2oraXdxNnIzSlN0c3l0bWVNYVZQZTVUcmR0?=
 =?utf-8?B?OHRxamdQcmVhQU83T2Q3WEp3RWUyZmdSZkdFWnorWFRGdy9UTXhTNXpscWxv?=
 =?utf-8?B?NVRaanVvVkVpZTA3YkN5VjhPV1BlTVA5dG1Xakt6Wm0zeVhYYTRHTGpRR3kx?=
 =?utf-8?B?eks1bU1HWEN1M0JzZlhNVkk3b1E3Q2FKMlVGNytWTDI2RlJ6S2VDaG9XTlV1?=
 =?utf-8?B?WmVJYXM5bWdCTStxcEtEYmhkZUlJVGhURzhhNWxTZysyN0psT1Fzb09mejVo?=
 =?utf-8?B?ZDQxcHpDM2Nzc2JQS1JLK0N4amgxZ3ZVV2N2eldXczNLOFd4QWJrWkJyQWpU?=
 =?utf-8?B?MExxSFM2T1hvNzM1ZEVlUlBEeWF5Q2RxaFJER3IrY1hYdkdlME1UNTRUbkJ5?=
 =?utf-8?B?Yk5MeHA2aW96enRGZ3JOMFVFeFp0bnVXNDVsZGIyVEI5cCtxRHpRNnlXb0lG?=
 =?utf-8?B?ci9HK290dW1RdGhzZjJpemc4ZHJyRFJxYWNnYU1KVENuOTkyYng4MmhDMW9o?=
 =?utf-8?B?alBkenhMRTB4SUNGNEJFWUZFZzZFNXBiZWo4dVFRRXdSMmh0MzhGN25XVHdr?=
 =?utf-8?B?M2R4Rm8yTTFrdTNuUWZHZGxGUXJ2N3dKOGRpcnQrcUFpNlhoeVRPMVl0VGY3?=
 =?utf-8?B?SldPZGJxbEZ6S2J6ZEVEM1JsMDczTDBxQUVkL2JRNllVNEU0TkxQNTA1Y3FR?=
 =?utf-8?B?OXBhYVVaOE9qVWx6ZzIzUXYvVzBmcXNGVG8wbHN3QzBPZGtkbXBNRFkwa2l2?=
 =?utf-8?B?bXJROTN2ZFkxM3V0TU1EZnh1NlNFNmppYTNEVWcvdmxXNDN0aTFFVjZYTXE5?=
 =?utf-8?B?SDYzaHlXUTZmZkVlMVVyYisrOTVvelJiSVdXZ1dMSk5OV0phV1ArMmsyV1U4?=
 =?utf-8?B?WXVzV011aWIwL1djYUF0dk9DWUJKaEI2QUVoalR2blIvdkFLVEdNTU9PQ1h6?=
 =?utf-8?B?dzdzb3RVTzl2b2tsaUpYbnlrcDRzNVhJc2kzZllaSHphdmpSdVlBVUtBMTcy?=
 =?utf-8?B?QWs2bmhSS0cxZUgwakZkeGlqYnEweTVnQm9QVDh3U3hoZGRtRXZuMFRPNkJ4?=
 =?utf-8?B?L29WUDhKS1I2TGJ6UG1aTml6R3NUTnh4U01PSHQ4eU5DRTNtYnpCUlY5cEVX?=
 =?utf-8?B?ZDBTeXphZW1lMkhROC9SNTJuM2RhbG92a2gvVXBTdVVUam1jUW43L0pWdjlr?=
 =?utf-8?B?cW5pL0Iya2FGanRsWmJvazJCbzcrYVZRK0k4RnpsOUg3dVowejJ5ZVhLSC9F?=
 =?utf-8?B?SGdLKzZLM2N6UTQ0d3hsbXFOY3ppTnhud3NVVnB5NXNWZHR2dkk4akRCUWRW?=
 =?utf-8?B?SGtISlRwSDluTjBYTFVXN0VrQ2VSVUVHdHI1ZER0VmVoTGVrbWNTTzZoYU44?=
 =?utf-8?B?MjFkbzJoZ1AzbUQ3SW82V0M0cjFlSzdCbEZBU0NpUTBNdG1XTkhzRlZYOFYw?=
 =?utf-8?Q?eW80gHhyx5zN4y2bNZtQlm8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 41cd0168-cadd-42e3-b1b5-08db0e1c9764
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5636.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 23:46:56.6919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Chqp0zsuEew7OCEZtcguppLX14xx0XlkqsLD9vMhB7lB3Ih8mFjL32uSxsjCSydQuYJIhIbkp4GocP7MWhLM3eXgCd+YpLk/rcWJDjTJKQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6223
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/2023 8:23 PM, Jakub Kicinski wrote:
> Can you describe how this is used a little bit?
> The FW log is captured at some level always (e.g. warns)
> or unless user enables _nothing_ will come out?
> 

My understanding is that the FW is constantly logging data into internal 
buffers. When the user indicates what data they want and what level they 
want then the data is filtered and output via either the UART or the 
Admin queues. These patches retrieve the FW logs via the admin queue 
commands.

The output from the FW is a binary blob that a user would send back to 
Intel to be decoded. This is only used for troubleshooting issues where 
a user is working with someone from Intel on a specific problem.

Does that help?

> On Thu,  9 Feb 2023 11:06:57 -0800 Tony Nguyen wrote:
>> devlink dev param set <pci dev> name fwlog_enabled value <true/false> cmode runtime
>> devlink dev param set <pci dev> name fwlog_level value <0-4> cmode runtime
>> devlink dev param set <pci dev> name fwlog_resolution value <1-128> cmode runtime
> 
> If you're using debugfs as a pipe you should put these enable knobs
> in there as well.

My understanding is that debugfs use as a write mechanism is frowned on. 
If that's not true and if we were to submit patches that used debugfs 
instead of devlink and they would be accepted then I'll happily do that. :)

Or add a proper devlink command to carry all this
> information via structured netlink (fw log + level + enable are hardly
> Intel specific).

I don't know how other companies FW interface works so wouldn't assume 
that I could come up with an interface that would work across all devices.

Paul
