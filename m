Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17F45F59EB
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 20:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJESdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 14:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiJESd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 14:33:29 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF62220D6
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 11:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664994808; x=1696530808;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hWWg08y1iudL7p0L8JfTihhuRCzSYrfQ/ydYzBT9NPc=;
  b=lcGNqnWpymXLVV+T6amnu5SiINTcqox0n0K6jjUvCP1x4z6dF9aGamyc
   4k4ip5f88UB/Hvgby9/c1jKUilPBSVgsA50x7sA0xlzn70ME6/mSVuQA8
   dmilNfWCRqJWS5diduiDPu7tinIMbswgur6so7XsnJ48pilnPN8mQkfyI
   yxd7duMl+KFNtG0dIXXoI4bXLHHTcKTaFNxWw53VBAgAj7m3g9B83A0go
   rZxzBD+/01uCIN2L38kJGHdtDLucrrwNz42eLTtNsjmb2MAUcwOSGtj4x
   7GZABUjp00zulIjTBFyUg4orGncTc3od27REnzh8ySpNdir29jHBIO5/n
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="329656571"
X-IronPort-AV: E=Sophos;i="5.95,161,1661842800"; 
   d="scan'208";a="329656571"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 11:33:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10491"; a="575507117"
X-IronPort-AV: E=Sophos;i="5.95,161,1661842800"; 
   d="scan'208";a="575507117"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 05 Oct 2022 11:33:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 11:33:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 11:33:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 5 Oct 2022 11:33:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 5 Oct 2022 11:33:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m43uJX869zQuBoxSeIm3D2hVGcM3fJDWsZ/ZBxMuEJmzaGIqkK+TmQGnJW82FWdBTx3eY5ms1OSjNZhq65Rvg68AvTw1WXN84cD3yZ6HUUOTNv+0yY3lebv6uA1RTZ9ZzKheNGSNxb/kTSl6e5oiEmHWf+LNwYdmXkyUvSCwiEoU88cjqha5b6Nlmn1BwlNAHrMk3pcfZTDvqrtxL6k4ZSVKrqCio4q2FsUAo/HvPXmSCnkEK0Yce6XsZcvvR/3u9rrX5bPtwQubY1ZUDYW/Jh2OUapGTAEK8Hbu0CDNL2zMyOMcGk3Gcraa5fHycPr1k1CpYUbsA9kFEHN3JCmMhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWHNOtQc1Dn9tZUuB1KyUGzHpGW3F1Z2pXaj2H89vdA=;
 b=FKQKBF1PAiNFug50E5usmFgx+VccKtbb63fpfVsOX8w//XY784+xpfJqpX0hdnLLhk9/WwVKNSthzvtBAKqhpSdFRKmJQ23D/6IZlc5bAFZe4LF7Z/9EVIy88q7mND8vd/9JJF1nmXMHtzXt06tZNPLb9MwEQWDk8twz+yEjq1ls2xoQ9+8U1hf8ZHIi3h4XUMEoaBLDmkxb3guN+ScItRCIQJtQ+FpnicFS0fqhCFQI1cIcMZ+1Yl6Hykx2cyaJjMmGLSTlQs3q1pqoHLLqnb0mg4Bhde8yYGNCg0q4F3at6SGGuB3MmJiVgSC75CCfu9mh+tVTqUUd38ytdZeN4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by DM4PR11MB6357.namprd11.prod.outlook.com (2603:10b6:8:b5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.32; Wed, 5 Oct
 2022 18:33:25 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::a3c0:b3ec:db67:58d1]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::a3c0:b3ec:db67:58d1%7]) with mapi id 15.20.5676.032; Wed, 5 Oct 2022
 18:33:25 +0000
Message-ID: <e352426f-7a43-6353-5c1d-aa3480f64860@intel.com>
Date:   Wed, 5 Oct 2022 11:33:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [next-queue 2/3] i40e: i40e_clean_tx_irq returns work done
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <anthony.l.nguyen@intel.com>
References: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
 <1664958703-4224-3-git-send-email-jdamato@fastly.com>
 <Yz1gh6ezOuc1tzH+@boxer> <20221005175031.GA11626@fastly.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20221005175031.GA11626@fastly.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:a03:217::8) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|DM4PR11MB6357:EE_
X-MS-Office365-Filtering-Correlation-Id: 49bbc310-932c-48f5-0a3f-08daa70016cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /N1MhogJXAM6Z1v7swMBHIyK82FRof78czmeWzMVVBcSjKzco6YDelZdOfuLwXJD/h6yLT2JnnITwXMKyiNz18DK03iV4GL/0wTPtB6v6nQBT5SuITl4NhHocO2cj7S2dF9izLAkne83UEKK06s9ADkbUGztVPccl/ywRo9k7O5KNd6aLHQFCws1kUfxmqNh/RMac7Mur/DX2tzV3Ds79USrfTlCPztXpQNSvLA+SVHR6YySfMIsfy8D5If0Ae0hebotkB/I1sp0yIHrIKzBTEPFgU15TI+cnqrxEu4cf3oKjqG5VMfvt5EV0IJ9V/4DsUneK+hQccD8PuhHygX2HZrrhjeK5XzH8XajQu+t0YbrQLJyFo/duFhAfm4AOEfe9PoKaCgvd4p0CdT3dg7F7AdgvYQozEkFESCR/7fmqCdwIo2eWc7hW3F2msU971j4LCIYmu92C7UFeK1sXN5qEwJErXal0eZ25Rpn8/bbBzrFsD56dR1U88wnDtlaToct6inMVDN0SW/YMskaTu0sfySQVWDfQI8htCnuSYX5AE5GdmqTiZteKN9GvdPCqe4EQqagaX88G0g8X53DutFA6joaBqgjk65GbKOGQLnV6zmt9tILr1ERjP1ARNW5zsUDOP4W9JBIvmjIiq4wvF9nsN+NFHbb9UK87/sxYYikVq6cScKr9oPs4fSbiXuUcnCs5GhXUbmsFaUc1DJ3i/KqWQGbQ0kT0POWxfTULtRae9KgJ1kAcYbvbQArEHDU+QipMUiwNzdZCUqWl5Qe+8NQXjmItINYZCHAFoBrEzVM9QCwaEe24yh3X8VCl7u5ABvz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(136003)(346002)(376002)(451199015)(26005)(2906002)(186003)(83380400001)(82960400001)(38100700002)(66946007)(66556008)(66476007)(4326008)(8676002)(316002)(6636002)(44832011)(41300700001)(8936002)(5660300002)(53546011)(107886003)(6506007)(110136005)(6512007)(6486002)(478600001)(2616005)(31686004)(31696002)(36756003)(86362001)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEFwNlZJNWxONytSRDE4Z3VwTHFPOFB0dHRDMGRTWHI0Ym5PUVNGUUE1WUlU?=
 =?utf-8?B?L2h4WEgvdTZlSDQ2aUVOZmtLSXdPakd3Zk94SjJTM1lwQXRXeithZkVqRHlz?=
 =?utf-8?B?bU5TY0srZWFTdENxMlg3MCtLajZpT2J3dVNQWnQyd1BwaTBoOWRPNS85Z3hp?=
 =?utf-8?B?dFlHOVR2R2JuUTNzOEJQdnF3QUdWc1lDd2RNeGhlcmdoelhUWVRXWWJLclh3?=
 =?utf-8?B?Z3dlYlhoTzJybE52ZkEwQXd2ZTZUL3FaWERzZG1DYUZFQXRpek1ITVpnVk5H?=
 =?utf-8?B?cUN5K2xEQ1VHa1hDS3pNdWlXT3dUU3d4Z1BMbWhwOEFraGpEZ1dGK28zNHBC?=
 =?utf-8?B?WUpvQ1RPYW5rS1JUZitBWm9GODdSRTFPbnFQUC9JRjBhL1ZjSzI3eExCc2dC?=
 =?utf-8?B?WkhWbVdaQUxzd3FkOVdUOHRiQytHSTNvZTM3QkZrZmlpR0RLQjlZK0pxOEdR?=
 =?utf-8?B?ZnZ0Z0syUWZURmIrZk0vMkhIeGVOYTY1ZTMyVEYrR203UDdyV0x6QWhzU2JG?=
 =?utf-8?B?dU5kTGM4MWZ0czJuVjRzRHVwL2FCYUZ4bWNIQVl4Sm1Wa2E2L2V3SWhabWxt?=
 =?utf-8?B?Ly9xbld4Wm9EVnB1UXhtU2J0K0lYbkZxaHpkd2xUcHhYMGRHV1BzdFpFZkpa?=
 =?utf-8?B?bGE1b0tpc0VMaGZLYmxMdDJubFlLejRkOVNjN1FHaWx4RTZXVjJaZUVOSTVI?=
 =?utf-8?B?OG5IZDlaVW5wZjRJK1N1OWIxTHJaMDlaNnhXTUFMb1JQVlNMdDdtS1NsUlM4?=
 =?utf-8?B?b2VTVi9MYWMvUFMrcjNITlBqL3JvNmlwZGs2VkZkQ0xEZjI5WmoyNjZpR3hh?=
 =?utf-8?B?TE9EYzhoR1R5MDhUaEtuZnJ3RFp1cU51MU5hOGpVZ3prNTFTZmF6TGtKZ0o1?=
 =?utf-8?B?V0JoRTJZLzY1aG1LL2hSUkh2d1JVVjJ6aUE5bldLdG5VeWYwdUNIcnFWbmRt?=
 =?utf-8?B?VE5icHpORUMrK0FUY0xlb2pSSU9LcXJrV2haWHluUFBrRGRpTkRadlErTm9h?=
 =?utf-8?B?UEhDekI3VnJNVE1RVDlPc2RwVW5uc0IyNXM2ajY5eEp4aHJTNzlvZEdWa0hI?=
 =?utf-8?B?aUtvbmY2cEkzL1FzUG5kNVgwbjNZNHpXNy9uVDQybzRxalNqYk13SVVhekdQ?=
 =?utf-8?B?b1I1TW5XTHlYVkx5K0hKdXZENFFhcVl2WHFtOWZ5d3dmQWNOQmY2bWZmNENC?=
 =?utf-8?B?RWtMcnNkUkdLSy9Ja1YrY2QvMlQ1djg0REVPWHdzNjJ2Q2Y5ZVp1UFBQU0Vp?=
 =?utf-8?B?MVNEZVdYamZjQmxJSzY0MmZGcFN0QWFOWDhUNjZSZUF0MmxKczErQWwzdjFa?=
 =?utf-8?B?M1FScTRxYVQzUHdOTzRyRUx3bUFYQW9acmFJckpsRllLU0cyQkIzdTg3d0Vt?=
 =?utf-8?B?MUlqNGd0N0R4RHFUSXJmTjFTY3pjdWFjUTRtT1dKM1p6UTlneG5ncDV1U21S?=
 =?utf-8?B?RG5JYVdhSXY3LzFzaUgzeG43TmVLQmNDaFNneU9Kbkw5QnloSk04SkVsNGpS?=
 =?utf-8?B?L0RvbGs0ZG0wblIzWFdxVTBWbmh2MklndVVnRnc4SkxVS0J3Z3l6S2tQbzRn?=
 =?utf-8?B?eWVCUU8wUnFvWXp1dWJuVGt0bXQwc04wMCtYNkJDTGV4L3pBMmJrN3ZhK3FQ?=
 =?utf-8?B?UllXQ1A0YXB1c0R3MlM1bnZtUXdnek9rU2JnS2U5Y3dDQzJPeG5Oai9iSUpM?=
 =?utf-8?B?azZ3ZW5uaTU2dUpMWXkzQ2x0WTN0VnNuam84eG5TdHRML3FmcHR6S3NwTU14?=
 =?utf-8?B?Y2VwTkxMNzl3R3BuOWdEMm9LRTBMYkhtVjRXelc2ZEJxWkRYM3RtTmRTeTZl?=
 =?utf-8?B?eXJ2MEI5VDlNZkNhVldhRWw2cWMxdVk0NmxXZTNpdTBWUlFaa3JwSlZjUU5H?=
 =?utf-8?B?WXEyS1pMVkkxVS83VEp2STRIY3pycG1VTDVyNTN2bmc4MXNZVndYZlhHdUVQ?=
 =?utf-8?B?QWVJOEdWd1JPNW40MVdHSURxTit2OTVPVzlhTzFGanIwVi83UkZFenR2WnlU?=
 =?utf-8?B?bUUzNVNqUUtrZXUvZmhHdnZBOVBta3Qxem14LzN0VitkS0tpMjUyQWw1VWFF?=
 =?utf-8?B?Z0gvcEdndVV0ZnpLQm1ZOXkzdTRQZUdZWmJGdC9vM0lHaCszckZZU1BEbzgy?=
 =?utf-8?B?NjN4dTVxZEJaZkI2TnNDR2tWRWdkME8weElLQ2ZZY3JtdWdtZW1MNHU2blho?=
 =?utf-8?B?Rnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49bbc310-932c-48f5-0a3f-08daa70016cd
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 18:33:25.5734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lG9h7kgareDKzdfzDPjfu+hy3RdbDKOgNVPfMJJBheCKBrbT96PN0xxy164bukL/wFbNhUWq4+uCA85C9rTGugLE9EJxsgmDIkg/ql4b/q8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6357
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/2022 10:50 AM, Joe Damato wrote:
> On Wed, Oct 05, 2022 at 12:46:31PM +0200, Maciej Fijalkowski wrote:
>> On Wed, Oct 05, 2022 at 01:31:42AM -0700, Joe Damato wrote:
>>> Adjust i40e_clean_tx_irq to return the actual number of packets cleaned
>>> and adjust the logic in i40e_napi_poll to check this value.

it's fine to return the number cleaned but let's keep that data and 
changes to itself instead of changing the flow of the routine.


>>>
>>> Signed-off-by: Joe Damato <jdamato@fastly.com>
>>> ---
>>>   drivers/net/ethernet/intel/i40e/i40e_txrx.c | 24 +++++++++++++-----------
>>>   drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 12 ++++++------
>>>   drivers/net/ethernet/intel/i40e/i40e_xsk.h  |  2 +-
>>>   3 files changed, 20 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
>>> index b97c95f..ed88309 100644
>>> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
>>> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
>>> @@ -924,10 +924,10 @@ void i40e_detect_recover_hung(struct i40e_vsi *vsi)
>>>    * @tx_ring: Tx ring to clean
>>>    * @napi_budget: Used to determine if we are in netpoll
>>>    *
>>> - * Returns true if there's any budget left (e.g. the clean is finished)
>>> + * Returns the number of packets cleaned
>>>    **/
>>> -static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
>>> -			      struct i40e_ring *tx_ring, int napi_budget)
>>> +static int i40e_clean_tx_irq(struct i40e_vsi *vsi,
>>> +			     struct i40e_ring *tx_ring, int napi_budget)
>>>   {
>>>   	int i = tx_ring->next_to_clean;
>>>   	struct i40e_tx_buffer *tx_buf;
>>> @@ -1026,7 +1026,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
>>>   	i40e_arm_wb(tx_ring, vsi, budget);
>>>   
>>>   	if (ring_is_xdp(tx_ring))
>>> -		return !!budget;
>>> +		return total_packets;
>>>   
>>>   	/* notify netdev of completed buffers */
>>>   	netdev_tx_completed_queue(txring_txq(tx_ring),
>>> @@ -1048,7 +1048,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
>>>   		}
>>>   	}
>>>   
>>> -	return !!budget;
>>> +	return total_packets;
>>>   }
>>>   
>>>   /**
>>> @@ -2689,10 +2689,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
>>>   			       container_of(napi, struct i40e_q_vector, napi);
>>>   	struct i40e_vsi *vsi = q_vector->vsi;
>>>   	struct i40e_ring *ring;
>>> +	bool tx_clean_complete = true;
>>>   	bool clean_complete = true;
>>>   	bool arm_wb = false;
>>>   	int budget_per_ring;
>>>   	int work_done = 0;
>>> +	int tx_wd = 0;
>>>   
>>>   	if (test_bit(__I40E_VSI_DOWN, vsi->state)) {
>>>   		napi_complete(napi);
>>> @@ -2703,12 +2705,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
>>>   	 * budget and be more aggressive about cleaning up the Tx descriptors.
>>>   	 */
>>>   	i40e_for_each_ring(ring, q_vector->tx) {
>>> -		bool wd = ring->xsk_pool ?
>>> -			  i40e_clean_xdp_tx_irq(vsi, ring) :
>>> -			  i40e_clean_tx_irq(vsi, ring, budget);
>>> +		tx_wd = ring->xsk_pool ?
>>> +			i40e_clean_xdp_tx_irq(vsi, ring) :
>>> +			i40e_clean_tx_irq(vsi, ring, budget);
>>>   
>>> -		if (!wd) {
>>> -			clean_complete = false;
>>> +		if (tx_wd >= budget) {
>>> +			tx_clean_complete = false;
>>
>> This will break for AF_XDP Tx ZC. AF_XDP Tx ZC in intel drivers ignores
>> budget given by NAPI. If you look at i40e_xmit_zc():
>>
>> func def:
>> static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
>>
>> callsite:
>> 	return i40e_xmit_zc(tx_ring, I40E_DESC_UNUSED(tx_ring));
>>
>> we give free ring space as a budget and with your change we would be
>> returning the amount of processed tx descriptors which you will be
>> comparing against NAPI budget (64, unless you have busy poll enabled with
>> a different batch size). Say you start with empty ring and your HW rings
>> are sized to 1k but there was only 512 AF_XDP descriptors ready for Tx.
>> You produced all of them successfully to ring and you return 512 up to
>> i40e_napi_poll.
> 
> Good point, my bad.
> 
> I've reworked this for the v2 and have given i40e_clean_tx_irq,
> and i40e_clean_xdp_tx_irq an out parameter which will record the number
> TXes cleaned.
> 
> I tweaked i40e_xmit_zc to return the number of packets (nb_pkts) and moved
> the boolean to check if that's under the "budget"
> (I40E_DESC_UNUSED(tx_ring)) into i40e_clean_xdp_tx_irq.
> 
> I think that might solve the issues you've described.

Please don't change the flow of this function, transmit clean ups are so 
cheap that we don't bother counting them or limiting them beyond a 
maximum (so they don't clean forever)

Basically transmits should not be counted when exiting NAPI, besides 
that we did "at least one". The only thing that matters to the budget is 
that we "finished" transmit cleanup or not, which would make sure we 
rescheduled napi if we weren't finished cleaning (for instance on a 8160 
entry tx ring) transmits.

I'd much rather you kept this series to a simple return count of tx 
cleaned in "out" as you've said you'd do in v2, and then use that data 
*only* in the context of the new trace event.

That way you're not changing the flow and introducing tough to debug 
issues in the hot path.

Also, mixing new features and introducing refactors makes it very hard 
to unwind if something goes wrong in the future.

Thanks,
Jesse
