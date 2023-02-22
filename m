Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9828469FE74
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 23:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjBVW0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 17:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbjBVW0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 17:26:40 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF59F6E9D
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 14:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677104798; x=1708640798;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V3N9OMyDBwnCzHiieCeny1tdEGldfRB+G+wAhsV0E/Y=;
  b=lZTANK013ziwcdMwya2uIG2AjiZDrAN86f263eY/zfpdBziNiPOa1tLl
   ieVHXlBwq0KyI5/K9FiRTpuctAyZ5h4nw5WbM0ynQc0z3NnHsQXMnN9rR
   PQ6YQ7ljtw4shP8/fGzrMbBfXZhXxPjXv2kkRJeQLiA3lTuWgsP6Jv1/o
   DxRI6Je8xIZNX4NmIuj9/+0baD5MHBlDQXMYeAFaVBxP+LgJzbaX14cDM
   aXHd6EAGm/xaq01NRpRfjJObf7wr1Je5PSBLhxR/gPH6fAClN2958XH15
   DJjySJclPO5TmzZzaXySkHuy4lnkrL9TU/EL++5DtkYbtgnup2CdGWVjS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="312678670"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="312678670"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 14:26:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="622101254"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="622101254"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 22 Feb 2023 14:26:37 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 14:26:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 14:26:36 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 22 Feb 2023 14:26:36 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 22 Feb 2023 14:26:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAjJC0Ba5P0wJVosWA8/oSHN57jijPB7qco3wBB1mNMQtvaAIjKjQEcwm5C+90bDx/0ugJFOK4CIxOu45Oajoj5s+KgYnK1nVcY/szVSYme7EsBBdK/gnvytyTenMFE0BK75gWOm9fQTNJIRLX9A51VZceH/VJfq6VBUO+lkJMaBrgKfvgO6RJcokA0u+StVSpYgYxy2Cy2+QudS6/MWCV7c+ssD/pLJIPJChfdTv4T+QfoQ3ENego09Yqi7W5xMSRIvpSmEYrfUQdbGx6pIU6HL3H62R/8gy5pIahOuEtIiA0bOXkyRB7U63egEjF0raum2zgK/732V7t8BRWCBoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8kiheTCSm9cAInrjwIGUUgrj22mK29cM5svuxy0URM=;
 b=HU/L+GsIMZu1id8L/AfSpEYNhHKMXV5MBhojK+7q5KJUpCJI/EFqFaiqOHYIOkGvgWbqCdpb0RdUW3T4hKy6ruQbsGRuaXTpCM/Rnz+gO2YQKAeuqraCISMiDMPWZrU4AC8sPJI22aihiM00f86ylVXZcKEo8z3rakAxNnn+ziXAPAMeSPy3WT7Tsfnp0x1prlIQmtaF/IVZJ5q+g9NMFn2x8Udt/fZywAbtY2YZgI1aQvdLtDJUr4biFdQsS8/xVAx6R2Hm3zADJnk8q/eTbb9W2Fixqz+SBRzYo7b01jcScZTZ/5+t/jOjsSkXGNY/qyJ+CELcNzekRxLay+L2Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by DS0PR11MB7786.namprd11.prod.outlook.com (2603:10b6:8:f2::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.21; Wed, 22 Feb 2023 22:26:35 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::9612:ae25:42a4:cfd6]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::9612:ae25:42a4:cfd6%9]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 22:26:35 +0000
Message-ID: <79180e81-ab37-f287-79fb-06b0974f81ab@intel.com>
Date:   Wed, 22 Feb 2023 14:26:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PULL] Networking for v6.3
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <aleksander.lobakin@intel.com>
CC:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>
References: <20230221233808.1565509-1-kuba@kernel.org>
 <CAHk-=wi_410KZqHwF-WL5U7QYxnpHHHNP-3xL=g_y89XnKc-uw@mail.gmail.com>
 <d04f822b-ac63-7f45-ef4d-978876d57307@intel.com>
 <20230222113334.0fb37d5f@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230222113334.0fb37d5f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::24) To PH0PR11MB5095.namprd11.prod.outlook.com
 (2603:10b6:510:3b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5095:EE_|DS0PR11MB7786:EE_
X-MS-Office365-Filtering-Correlation-Id: dd121e72-9492-4930-c83b-08db1523da70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dnsy85thcKBxSL51TKjDCgJwAQRT+fhO3nEyVM0yAwgMaXzFFBlTh/ZT0KD9owgCTGD3x4Mz8lntJyGQQL9RMIPC2wzV/LrMviFuvWE/Zu4wnuFVV/md0pJPm5DvSQ7Q5/nJV2wxgwaMX776EmCxmynelJ8wLbBTzSH9yyhW5a4tBDqX4H3uL4LttLQzdpV1TMlZkP7bBpj4vn64AzeBRZlWFH0vAJ3H18wBbGa9sPbLUubmT4Rdu/IWQblK6VQ27/iiV2P6TwWDPYiQ8kTmBdlmDQmJG4UxJEz4jYDGLi1QORGG+rKY9EOKp+SDrr9/ra/f5hwH7Dj0aOSk9Z9EnCnU5JEbMOOyVf8TxtkmHJyhR9A0C4jU6ShgHbzoD/ZrDxT6RNWqP38yiCkg+0hUq92wcYB7nPRwAo5tc0f6OnG7z1l8LOP6aaBVxN7d62Rfx+j/qs8LRMe+vjzf+COIDlkD3jMC3NJnxllAsCE1YBchAJwViQQwD44mnyJVueJ6AjhaN9D+sBK1iyECDoDwq1wSE19YnpU7ALo4KH1r7lipJt3dPxAHkrSZr/y1eBQqqEQ5vli/CAK9sA2QxjYhAkW6VCE9+y3Zb4mhGGAWycTwEhyD4c8TdEOC29nXDRo6kR3jenzM3710UvKKHi5BF5jTk4UYFVkmsRJNtSRogt31m8o/q3bFofK+vPOYnVpiQML3PqkSNHYRJ/kxgms9ZsjknzgjETRdH51ekTWOUxY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199018)(36756003)(2616005)(82960400001)(6506007)(186003)(38100700002)(8936002)(41300700001)(6512007)(31696002)(2906002)(6666004)(26005)(5660300002)(53546011)(86362001)(66946007)(478600001)(6486002)(316002)(6636002)(31686004)(110136005)(66476007)(4326008)(66556008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnhyVEZUK0J2VmIzVG5GU2JIV3NzT0xQZDE1UEIrMXMzQ0pEaTZ0MkYyTVE1?=
 =?utf-8?B?c0xtUUhVc0NvaExYRlhqUXM5Rm5FbDl1WEZzMTJaNG5Ud00yRlA5empjeFUr?=
 =?utf-8?B?RWlZTm4xeTBkZVFtYXZ0YU1OWFlsVGFIUE5KcXkvMms1TXlFZUJRR3N4UWVD?=
 =?utf-8?B?NWtEMTlLeE1FbDAvZWI4djVQSjdKMkljeS8reDFWOWRxc2VtaDZieEE3MCts?=
 =?utf-8?B?dGNXS3hzdVl0NmlSU3VPTXZFOVh3NGxZemlXbmdUR3pQUGxMb29NT3czbXVY?=
 =?utf-8?B?aGFSb2xiQnF4ZTFoQkpPcHdka2dUNDBmd3lJTENwd1plblhwcjltWWgvVXdT?=
 =?utf-8?B?YjZldkpxMThyYm5iNXoxbXRpU0k4aHpWMHorS3ExdFRNZ1AwUk1jeHFCdEtz?=
 =?utf-8?B?VGdqM0RWQ3FVbWcyNUZ2TnlOenBwcHhjbW5zdXcxMU9tUTR4R1YxRWhDSEpG?=
 =?utf-8?B?Y2NTdmhOSEs5Y2tyK2MxdC9Gblo5TU41L3l0ZC95WmRLbHJGQldrY2hrS0Rm?=
 =?utf-8?B?ckx6YkRtZjQ5MUJENGt2YXpobFMzd1hJeDFNZFZqMU0xbDZzYXg3VjBvSjlN?=
 =?utf-8?B?OGxSeHI2Q2p4bUlrZ2M1TTczaDV0bXNlbm9keXZKTzlaYlk2cDdRSTNLWnRG?=
 =?utf-8?B?MjNmSklzMnNpSmFRa3MrOC9yZDNJL2JBa1dKaUxIUm9vMUtvZGJ0bW4vcDky?=
 =?utf-8?B?eGdPalgzK3Z2UWxVZlhXOU40c3l2NWVRbWZxeDRXWWhaam9ZN21ycWp5ZWky?=
 =?utf-8?B?TVhIb1U5YzVOOXZYQXZiTFVVemczQUc1TGtNUG8xNitxc1hhYksxMkovUTVS?=
 =?utf-8?B?OVIrMi9UVUpXY09sNVAzQjFQeUg5eHNlQmtCOTBCdXpKSWpEQ0ZkaVJMV1Zz?=
 =?utf-8?B?MDE1Mzk2NkUxZlZGcXp4VmFrdDJzYnNxd0tRLy83d1BESXljT21tOWFoN0tv?=
 =?utf-8?B?bVlMdzVVZlRlS3Z1MkY5RTUwZWtZbkQxTFRKUW51emtKTk9zbXRFZ1JSZ3NT?=
 =?utf-8?B?SFY5M29FSCt0dWlDdFJlWGc0dXNEQ2dUcmEySEQ4disyMWdYRzlDRUZkNVp3?=
 =?utf-8?B?OXIvcTFhZXcxMUhCeEFRQnFHQXpHb0RuSHArOWlDQ1lxZkxZQkI5VE1TaVJJ?=
 =?utf-8?B?QnpZZVE3dERtREVuZ0Q4TW5ZTTd3YUZQK0pmY2tKcEh1ODdvSzl4SUNieTBG?=
 =?utf-8?B?eGpjN3IwUTNlQk5zdHRFZkdRbzdKRUZ4TjA0UVVHWGNxV1hGNjhPeWhmSTBa?=
 =?utf-8?B?VXRGV3dvNDR4NjExMFZzcmF0SGlRR3FTWFN4MG1Jbm8xYXpPb2hGMjluN3Rw?=
 =?utf-8?B?c21HdVZjcENOWmVnOWw1UkJvZnRlbCsyZlRlWU5IbFJwZVZzTHlERVFDejZl?=
 =?utf-8?B?dDNlY0ZyZkZWK1FnZDA4N0hoNFdlaGl5UmhUaVhOUk1hRmtLR1pWSnlzSEdP?=
 =?utf-8?B?YWZHb1ovWlkydHlDWW82bTRENndSQXhLUDFjRVFhSDlyS292Y09tVWk0K1l2?=
 =?utf-8?B?bVhrQWV6QTFOQ2NJZUdvV0d3U2tIV3l5MFQxSCtQZXhZNEFIclZXUFBlcFAx?=
 =?utf-8?B?enhNRjBCZG9iSENYd24yNVFZeURPOUh5SnBCcXlxWnVyVGJsaG9VaklHRTM5?=
 =?utf-8?B?OGw5SkJMZlJHTXE4cFQvRmd6RjM3azVlWVBGeFIxNklrc2s1UEZZY0tIN0hU?=
 =?utf-8?B?aURCOHBURXBDYTRldjQvd0h2dFV5WHkyNjBtbFE1dEhtNDlBTFY4RXJzdlNO?=
 =?utf-8?B?VTFSYUNMNGQ5bGR2QTZPNGxQVEtLL3EycGZsejRlNVBoK0ZsVEsrT0gwakIy?=
 =?utf-8?B?Y0xhbmc2SG1LWG1udk55QzFWYWM3SWZ5RTQydEIyQnU5M1ZMRkNUVHVzc0ZN?=
 =?utf-8?B?bitQUC9NekVNVERkS204Q0tnNWRJa0JuOWxpa053ZnlaVkRUKzBQd0tmQUxh?=
 =?utf-8?B?NldWMjkvemo3dndkM3dQN1Btc1JlSUUrQ1ZWVHRyNC93S2FKSE9QTDcvYysw?=
 =?utf-8?B?NlRLZW5PdlVYUUNGV2xtS3g0N0RXVDdwUjFjLzJ1cVJBc3VwbHN2ZzZ2REpK?=
 =?utf-8?B?b3kzTEs1YVdZa1paVnZidGVUaS9rV0xiRUxOUnBGdXpIT3FWNVM0SjZMQ0hs?=
 =?utf-8?B?L25XWGNxdnZPaFg2OGZmUkNkQWFXRWwvdlZsY3ZzSVM4emFLak5zeCtXMXlM?=
 =?utf-8?B?Zmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dd121e72-9492-4930-c83b-08db1523da70
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 22:26:34.7805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y2WdXP8TZidc7AyYOibB+V0EiIWfIbwtOoLr+0vy+mVconUT1CONxyVUlIQp1M0UDbvyQI+GhuXPLJFNW87RIykIHKx52WL0KVsfANc9nEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7786
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/22/2023 11:33 AM, Jakub Kicinski wrote:
> On Wed, 22 Feb 2023 20:07:21 +0100 Alexander Lobakin wrote:
>>> I suspect it would be as simple as adding a
>>>
>>>         depends on ICE != n
>>>
>>> to that thing, but I didn't get around to testing that. I thought it
>>> would be better to notify the guilty parties.  
>>
>> Patch is on its way already, it just drops the opt and uses CONFIG_GNSS
>> directly.
> 
> You got me slightly worried now. The overall idea of using Kconfig 
> to resolve the dependency and compile out the entire file was right.
> Are you planing to wrap the entire source in IS_REACHABLE() ?

No. The new solution guards the ice_gnss.o with

ice-$(CONFIG_GNSS) += ice_gnss.o

in the Makefile. This works correctly for enabling ice_gnss only if GNSS
is reachable.

Then we exchange the IS_ENABLED that was done only in the ice_gnss.h
header file with IS_REACHABLE(CONFIG_GNSS).

It's exactly the same number of checks as we had on CONFIG_ICE_GNSS but
without the extra unnecessary option, and it compiles  with at least the
following:

GNSS = Y, ICE = Y
GNSS = M, ICE = M
GNSS = M, ICE = Y (disables ice_gnss code)
GNSS = Y, ICE = M

Let me post the patch and we can discuss there.

Thanks,
Jake
