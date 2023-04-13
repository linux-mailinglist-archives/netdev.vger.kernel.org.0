Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA43F6E02EE
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 02:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDMADd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 20:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDMADc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 20:03:32 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532FB9D
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 17:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681344211; x=1712880211;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d1wV73n0ZC8GH7buyxuzPnJ94IXYOgqiuFK9OSmcyfU=;
  b=ntIjRMXhiiVBqJfjcVXk6UX4wkl7RIXcIKBgOuf0plpz1XOpy+2blr10
   3Xi2WEXmXoumsODlYkhYKb3TNNLrR7J0qKxljHT8S80xehNQ1VldT+Z1s
   l805wkvzOXFzn3xfEZFMIj7CkLP6j7tXhNQJ1lQPAbuQNbOkj67ZkE99u
   757uom3nLJXb7uN4yL8qFnnfB5P5O5/uHdQsF42euPNkIT46k/YAMsBaM
   mVN5gPsJM6TLAemATOn4CYLo0byoKAMU4i86MvGBShLlZTM+L+2cOEfZ7
   5GgcAvNboPSQ96s+F+7ejxEfJAhXoOhebQ9XMgR8/cuj7VDiDn1KJMkwW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="409197212"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="409197212"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 17:03:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="758439767"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="758439767"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 12 Apr 2023 17:03:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 17:03:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 17:03:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 17:03:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7jXvs9iHKAJ8NMzx0RUnvKGBu/pgmqENWYHtgU596bznKUGRR2OHq/7ofgqY3o9yh/wZ03dHvcTdN9CRI4AppwLHY2FldX65QlY/qfxLaBx9iDbvK/uoYy0Wtt0ZCUAV1Be/e+wRxWBCJYgjaNJtn1kwbLHT05ej41j+faoXraP92OWlHlQKoCMk/qZljrCppOBYtBASKWGPmn+b1x0F44sq5U5fdZ6McExhMoktZHmHHavS18pkj74yjSAS0eGaYW2+q33qAn8lAwr1XJl2RNuKxUG9Hnfv7NZSON701+3o0egFMnxky2WoVcANv5jbuxYyYetPPEFQCGmtXBAIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3tt2qiu9HrHRYWu0RZ1oTHUiW8/JX4otpZU0HFHlJ64=;
 b=jjtlIsahDrCdld3OfZQxMExFDaxt1pERN/EWGv5UzznsC6SdnjPefnStih9fW25ECAjRdn8xpUFxqUOrFNZxZW0wRq41i4o9dP9DdsbkJzawSyyjoOH3ooXnVpOlI+wBcqNQmvWMQS3kG131CEMdW8bG1o7EauzZxouMhT3/OIVqnpHmwjoVx0vjth1YsKV7Pnwj/aUPNebd8s9Ucbg89BGDSsGrWRCYlKjYNPYeSx+XswkYW+wpRLYhLB7PWSEVsZYZ1eRyfRJYtd8bFyfHJrXZKg0z6bqlVvGC8T8U187eaZmW4t7nlw845RQhvrEKSJ4hbr9xfvZunmNkZClVSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by IA1PR11MB6075.namprd11.prod.outlook.com (2603:10b6:208:3d5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Thu, 13 Apr
 2023 00:03:27 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::922:4817:b4f2:c7b3%5]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 00:03:27 +0000
Message-ID: <d2585839-fcec-4a68-cc7a-d147ce7deb04@intel.com>
Date:   Wed, 12 Apr 2023 19:03:22 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 00/15] Introduce Intel IDPF
 driver
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>
CC:     <willemb@google.com>, <decot@google.com>, <netdev@vger.kernel.org>,
        <jesse.brandeburg@intel.com>, <edumazet@google.com>,
        <intel-wired-lan@lists.osuosl.org>, <kuba@kernel.org>,
        <anthony.l.nguyen@intel.com>, <pabeni@redhat.com>,
        <davem@davemloft.net>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
 <ZDb3rBo8iOlTzKRd@sashalap>
 <643703892094_69bfb294a3@willemb.c.googlers.com.notmuch>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <643703892094_69bfb294a3@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0372.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::17) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|IA1PR11MB6075:EE_
X-MS-Office365-Filtering-Correlation-Id: c9fe861c-77c4-44e1-c8c3-08db3bb28195
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hNo85WUklxUcEDTUK1co1JdteGpgZmWWDwTh7joByrVubPqf7H4QDUirKCGXxrgRe7lJCl96mOzLd0EkcRPsMDXSYgxzDI3ZAT/RVi8WvRT2VCy/dNxfAbT+Vklue1bMw3LC0OjAYpBhCKwjxzEo7PkOj0Am/2tbx4cDXwwkNvEf5Nqk9ppJquaBs4iNwrgFWzX5p1wgcNNiCZFQnanlFuoPlUFiD5iu2HdFyEe+YwfVMmabp1BUNzc6tkWuHhe/52H7N5r47N8EKKJdgLeftOVn82bQ6VtS4t6vIYgZPg5DMEgFo6xhSPr9QMasx73sT4HLR2jL7F+Yg5goAWG6KQG+zZzCmfRfWE46dmvkPeMFXqE00QOzqt8aIIltbYzi3NY3TDTLtSqONrvQ2lX4X8fMDElhzSTr7Vr7A0enQrpDH4w/RCECYB55uO11BykVqXmiBds6NH0+rCsBhRciyOQ4fwbvzBHET3YykOsAPSfQXdrN3bPc4x2AvgwevXxFke49m//rdfPUD5QkrVFGj+m/kZfQPlCugD3om/oVzrWXKk5BCVWmMDfTylyOMOg8utCj18ewjmFiNUnD854oH2quAAC2QRtEQ1jAyfi6Jvt89yV/9GE0f3SObJiXeZ2WxukYmvhlxo4HgsTlNbghzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39860400002)(346002)(396003)(376002)(451199021)(316002)(6512007)(966005)(66556008)(83380400001)(36756003)(2616005)(478600001)(6636002)(53546011)(186003)(26005)(6666004)(6486002)(110136005)(41300700001)(38100700002)(5660300002)(2906002)(4326008)(7416002)(86362001)(8936002)(31696002)(66946007)(82960400001)(8676002)(66476007)(6506007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0pWVGVFN3VtVW9TL21XM1NFWGV6NFJHQm9OOHB0aTdiUW1kL2hlNkkzUkdY?=
 =?utf-8?B?djZaNWt6dGZhRFpEZlRPeXp4MDBtMG15SHRWOTMvaWJoUWw2M3JyMTkxR1Mx?=
 =?utf-8?B?STBzbGIxL3kwbVFzdGwveFpZMk4zdG42NE1wMFRTSThvbXhwN1BoVFJBWW4x?=
 =?utf-8?B?dndBS2R0Zi9ZUzM4QkdkTDRYUk54aWp3RXRQTEZtcHFaTlliUnBERElUc0lr?=
 =?utf-8?B?ZmgwZzN3b1Bua3drKzRwNzdHc1BmWXZ1N0xUYnlkRnUvMysrQ1BEUkp1c3Aw?=
 =?utf-8?B?TkR1aFRNQ3J5Mlg3ZDhBMTgrWVhIaEN4eU1Hc2VLRWJHcHZtQzNEeUY5Ynlx?=
 =?utf-8?B?QlptNjU1UVUvTEhRUlVMQlhIM1Nqbk42dGVpZ0Q1d2xBd0NjV29TSWRRUDBa?=
 =?utf-8?B?VlI2bloyY2ZmeWZ4d3ArK3RXOUhjc0dNT1V0NjFZckNENmdSOUhad1hHWElz?=
 =?utf-8?B?RGZkQi9XUTVjOWQrdUhpWDN1NkRXcHNpZlRYVERyVFRXRTVBbE5DNHU2dG9U?=
 =?utf-8?B?YkNET0MyWDJBZmJwa0N6ODJLR0M3bVg0a2dRTXl3R2NFUXRKRkl1NWY1K0FQ?=
 =?utf-8?B?RHh0VnhER3NCcVFKc1JtWnUwSHo1T3BaVzRNN1lkbHRieVB0ZmIydUVYcC8v?=
 =?utf-8?B?SFZWaFdOV1l0cHYwUGNwamZMWEljV3diVFFYazZiOFhsRjBaQ2k1TFhFVWlu?=
 =?utf-8?B?Wm1INFc2RnQ3RWtweC9pMEFxalN0dWRrL21nU2RMQkFTMEVNTVBsUXFZM0hZ?=
 =?utf-8?B?MnR6cmhoMmNYd1hzZDdyY01UbEdRV3ZQY3pKd0I2NlpIT3ZacDNQZktqUWJi?=
 =?utf-8?B?TzNRYkdkUmExTmladVo3ZzhEVUdvQmlNUG5mUFN1SGN1VlVXeGRGcGdkVDh1?=
 =?utf-8?B?Z29IanNiZ0RhTzBySEo1djZqbXV6eCtQTjA5eEJ3bzY2MmlkNGlsaThvd3Bo?=
 =?utf-8?B?UXBsRkdkYjBnTEpBeGpEcVlFQllBdXJrWDlabVM5ajkrQmU4QnpFR0kxWW9i?=
 =?utf-8?B?a1lKYnpxdDZwQWpna1FGU0tWOGxVWE45aTU2YzJPZC9ocXluVzZMWEhaS0Rw?=
 =?utf-8?B?UW14QzEzb21qbWlwSmhSYWt5aFFwSXFuZWc5Uk9TR1lkb1ZIeDhTbmlMOEt6?=
 =?utf-8?B?eGJYUUtJYkd2anJTN2tSYUZCenVFcFQzQ3dMd3VzRWk5dnhmcXRhcVVWaUM0?=
 =?utf-8?B?T2FVWjUwODJKZDh0RnlhVTFOanI1WHBLVU9JdzYxc0w0VUUySzhDeTlxTFJG?=
 =?utf-8?B?Rm9CRlJSbkZsR3p6bTF5NXJBM1VHRFdoeWRoK1hZOXZJdlhubnk4TEwvTkFx?=
 =?utf-8?B?WGRja1hQem9LSjlmSlJLZEpHcFJLVWoxSTR5cmI3bjVZaDhQQTJJNFpBeTh0?=
 =?utf-8?B?M3NDcGFIUmFoWVU3NlFkSXB5QU1ySlFkSlYrKytKTlhPNjRKa1NveWtNQ2ZE?=
 =?utf-8?B?Q2cwUXhrd2lkdzVMRjZyN0hQWVVCamNyWVl5MWlmd1NPaUhJM00zdUIrUWRW?=
 =?utf-8?B?aGpub3hBR1ZscEJqSmp0eWFXOEVxckJKTVYrYVVqOW41dkdLaGNZbng3VG9l?=
 =?utf-8?B?Rk1oRnozMm5FSGpyazZ5YVZnRGFZTlVZY2JxNmZGTjRpRVErcndKUnBxY1Vo?=
 =?utf-8?B?SXBJQ254OWliTGw3ZWcweXA4ZkJLbzJoWHZqWDN5YUJPUzA1YTdKN1dGMUs1?=
 =?utf-8?B?VFE5amRlOHlETWRmU2RjNzF0aklGSTNrYUY1QzZ0cHc3eVZ5QkhadjdsNm9J?=
 =?utf-8?B?bVU4NlJPZmp5R1l6cytRS0ZrZWpQbExmNjE2Q1VRR1NsQm9jbzR0cjRTWnJI?=
 =?utf-8?B?aGZiNDFldnNlWVA4aFBxZXFMeEtYTGx5TDdmWmJUaTAzcUJMYzBoOHJwVlE2?=
 =?utf-8?B?RHQyS0lSUTFUZnIvOE1EWkxzYUxaVURPV1RTUndFY3ltc05qWXBhV1pqeFQ0?=
 =?utf-8?B?VVczZHkzQ1FwVm10VXFkUS9xT1Yvd3dVREJsTzc3LzV4Si9YU2JkenFBOGh3?=
 =?utf-8?B?MjU4VE96bytCRTZuNkRqaWJMREpMWnZseGpHMGtDZXJSY1ArVEVhWWxkdTNQ?=
 =?utf-8?B?Mm0xVjJCV2lXOTdRL1lIaUtYeHZOWkF0MVNHNDlIRmpxVlZvL05zdnEzaFRN?=
 =?utf-8?B?MjJhOE1rZm5xNEhsV1RWVFBhSmNRbTFBclYzT3M1YjgxLzBWZURMbk1CbHVx?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c9fe861c-77c4-44e1-c8c3-08db3bb28195
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 00:03:27.0616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +TpL4VzeiZEM6t4M97DN7nuMFIqKbQRaj7LwlanZaShfLpDs9SmsUWvGydLwGpI/Rn9FbTK0oZeS4KwqRvA7FRCiXslBISz+8rEbrz/b4Pg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6075
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 2:16 PM, Willem de Bruijn wrote:
> Sasha Levin wrote:
>> On Mon, Apr 10, 2023 at 06:13:39PM -0700, Pavan Kumar Linga wrote:
>>> v1 --> v2: link [1]
>>> * removed the OASIS reference in the commit message to make it clear
>>>    that this is an Intel vendor specific driver
>>
>> How will this work when the OASIS driver is ready down the road?
>>
>> We'll end up with two "idpf" drivers, where one will work with hardware
>> that is not fully spec compliant using this Intel driver, and everything
>> else will use the OASIS driver?
>>
>> Does Intel plan to remove this driver when the OASIS one lands?
>>
>> At the very least, having two "idpf" drivers will be very confusing.
> 
> One approach is that when the OASIS v1 spec is published, this driver
> is updated to match that and moved out of the intel directory.

Yes. We don't want to have 2 idpf drivers in the upstream kernel.
It will be an Intel vendor driver until it becomes a standard.
Hope it will be OK to move the driver out of the intel directory when 
that happens.

> 
> This IPU/DPU/SmartNIC/.. device highly programmable. I assume a goal
> is to make sure that the device meets the new v1 spec. That quite
> likely requires a firmware update, but that is fine.
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
