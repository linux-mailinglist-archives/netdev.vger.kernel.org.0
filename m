Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AD2696A53
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbjBNQvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbjBNQuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:50:50 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1798977B;
        Tue, 14 Feb 2023 08:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676393431; x=1707929431;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b5ThcZmi8E4e8Ns1TKp7nt27TgP+fZL7WLRVIJ7Vc4U=;
  b=VZy8K+yp8ybov6LJYnRc6/nQTxHt6sPz6m2v8EP5iHxbOEX2RW/Th1u2
   irZqzsLIJSGYiV4oUU9b1Iq6LsYGmJDBIuNjUJ/ponyrPRja2wLh0k4WD
   m8zsnhi6M/eNrAo4DUvPAz2HXW5sLUpSWb9T0PnzVIIcTmCfORxpxDF3A
   G5UuPon0i1Kin0TOpE46XMqOkhVsttaJS5piJb89eA3HgETiqt6xJYJxK
   M9TbmpcmoQKaNPPqdynJCz0smfMOKq6mJdYaxjPuiazvFyIHyvyXUs/7X
   I04to2rXiN33ec6L0WoffH5hJllaCHAlfXRywffzj+zIOFKh3ugQQYC9o
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="358619886"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="358619886"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 08:50:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="998139336"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="998139336"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 14 Feb 2023 08:50:30 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 08:50:29 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 08:50:29 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 08:50:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JV+uUbIJmx+HWrLr3tNAHnwm6m3VhLI7EVbfhla70en/bHXHEHl8pjZt1tKXJH67nuI3FodKzuMX6Houqlc8DBtHT9pWGYKWWUYLOYgY4BtSIxXrrvzghpGrgNmJHNV48g2d5BHtkTmVc+627cMFqJQPdYSB2vKdYB9TORPaJGDhBWpLuI08y74k1g49Dla55EUPH1LQayYGsBhRHuvTIXoxOnUltkcoHVp4jFhg+/TP/MxvNk1sfKJyIBfOdwRW1MmGZ6dZmn0dwqc63O+91LRWyEroo+BwDSGqg2uI7OKuhrXj4i/T8D0OcwIQkgd/y5vjMV3mWWghJMKldxN6xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQf5xAlRouq/kvOX/qi3X1gJy82JoFPlSjifyksr5kY=;
 b=i3ZBbiT7DqvN9e7d2AwyMzy3fpGsWYQVi/MphRbLCwAuimLnPBDJjh/7MS17IKRuYDI5IZc4ZW/GMzNjKRRyIyYSPxMPOV/cY898FP4588EkdXB3JTSQ7Faiw0IlMfK0t/LBODXChC1e9HEvY5umWxYgPhWyGJYEc2jeb/zNIQvip4eb4zVV4+ttDuxNxLXqt0R2Qme3DLveUcGizBPO/9JqEvZHLbJjU5eYlOA6zNWHE3ONm7/hJru39UvDVwS72ZVb8r7m1YClvgTrwWfs1wJ9uogrhkeBgE35Iu+g6i61I5g4KBaGUJhXRKtDnm+SQ3S4V3kZgv8bl1e0paLxrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BL1PR11MB5303.namprd11.prod.outlook.com (2603:10b6:208:31b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 16:50:27 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 16:50:27 +0000
Message-ID: <fb2a599f-4a7e-1755-fbcd-56e57abe80be@intel.com>
Date:   Tue, 14 Feb 2023 17:49:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH V2 net-next] net: fec: add CBS offload support
Content-Language: en-US
To:     Wei Fang <wei.fang@nxp.com>
CC:     Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
 <ed27795a-f81f-a913-8275-b6f516b4f384@intel.com>
 <DB9PR04MB81064277AB7231F5775920D788A29@DB9PR04MB8106.eurprd04.prod.outlook.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <DB9PR04MB81064277AB7231F5775920D788A29@DB9PR04MB8106.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0117.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::15) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BL1PR11MB5303:EE_
X-MS-Office365-Filtering-Correlation-Id: 53bee215-04b3-423b-d657-08db0eab9306
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eYUMSUgFrIiP56pMnmOVK+8/vN5E78IvLixitL7QaW+fXES7YN2HZ07coJ/10nqfUf6r21tyDW0fzMAEtDj/BpdVBGOMtqDhm7Eoa6wxT0zUSiy8OMYtK16YWYv230dcGBxy/dnpmFj7CPJyqL8lXlyXC7k0qcTKtlMnZ9HqrRfvnUIVxqEJ48McLzj9AaW0Wy9bLJVt0CkXyxp78S9SuZbqqNeZEKn7WlzokVUFlIHj5B4/Ld2segJSf7tXQ196volfGnkU/Lruw8t4UGarXSbHy92XO4XFUnrXZq+nSNrpT9LEo/h3327W8G94OyYu0ra/p4UCM4povl6F3QAro0sdG5vQop/M5oDZCIKfvBCZsaviWquF66CRrZ1+iQCifYTSs+ZoArNnhFGg+D6arj8wfWw8mHmG9dQY2sG3YAK0GZkpNs/3NTEMB+fUxrA4vRsRNSpNDCYqDuo4M1i8hgeupvJ0tuMsTDBBw+3E6dGzxdeU7bZPUORfz7UWRd6qNLoQ2ekyqUYhbuT5geX0Rr1P5FF/fKkhrP3wbuva7BtMOSAJfb3I4SzFfFbunmKVhBeHoruJP6FagS5FisYqc2wTejUdHpU+lRlIbFERYt3+l3eRnRCgTh6Hw1pAuOVs4DRsTO8mTEltOm8lOuhlqyFeTiR7WvCTuKQ6llY7xQ1kh3ZX2tuTQ5bhegqT5e3hU3Nu5dtIWmzuqWC3S0WIv2z3X3ERdvfSiKqXj9Eh5WQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(39860400002)(346002)(136003)(396003)(451199018)(31686004)(8936002)(6506007)(478600001)(4326008)(41300700001)(6916009)(5660300002)(36756003)(38100700002)(8676002)(66946007)(66556008)(7416002)(82960400001)(66476007)(86362001)(6486002)(2616005)(2906002)(31696002)(316002)(6666004)(30864003)(83380400001)(54906003)(26005)(186003)(53546011)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTBaQWhQUnk5YlhZWWRQOUh2dmNZaytLVVJxeVlsVjF3bGVkUlBabzZjNFNo?=
 =?utf-8?B?dW5PMDlKWXZwdUlnU1lsd2YyQTZ1SjZ3YXc4Y3dUUDA4NEZ1endEanBjbGRZ?=
 =?utf-8?B?OUliYzVYcGZQdjNyZWJsYm1Cem8xSTZ6bFlRaFc1UDJ2NXNkS2I1S3JxOWRQ?=
 =?utf-8?B?SWRxMFNPWm1ObHZ2eG82YVVkK1ZOdjNaQ21HTndjUkpvYzlqKzlpZ05OcG15?=
 =?utf-8?B?MWFzekNBNW5XTU1SUldHMUdiM3VTdmV0L3BrMU5Hdjd2NnBKTGJTQ3JxdFRZ?=
 =?utf-8?B?R1BBNTViYTJWLzFXakhobVpDbVA5VlUxR1Z2MGRPSy9GSWszVmJjb3dZd3JG?=
 =?utf-8?B?c2dJRjZmUkpUUlNJS2lvQkZOZnFoU3dWajVwVmNHSHRrdEsrYm00Y0xPM29W?=
 =?utf-8?B?eXVSaStEdEY5NFhBQit0ZGh5blJXWCtSSEFTQjFRU1lPR3pTVks2a1hNRHkv?=
 =?utf-8?B?NGNWaS9Kc3dSUG45Z1FXQXdXaU1WQ0Y3YnVyOWRtMXplc1dhQWZQZmZVenlh?=
 =?utf-8?B?OW5sMWgwcTVnOWJ2RTIzWlFrM0l4RTk0TDZ5Qm5JZUl0cnEzSFJQZGxXRytF?=
 =?utf-8?B?N3VLMkYzNUF1QU44UDByc0dPU0MrV3NQWkQ5bUpocTlBamljZzRWdHl5dW1z?=
 =?utf-8?B?RGdrZkVCSkFtZTVnWnJQeHpiZWZYV0o4WXUvTFhGYnh4TUVRM3ZydHF4amZn?=
 =?utf-8?B?NE1rejVMR3RrMnYranhZUkdWYnZ4NHpmQWVMSytOWFdIS2xkMFp0WU1BcE1w?=
 =?utf-8?B?cTUvV0V1ZTA1cmpNRXk0WTRaNVRSZ2JFWnlwMmNLWjEyanZ0d1JwVUJYaWZz?=
 =?utf-8?B?WWdxczFyS0ZhOW94bGovcDFzNWxDRVBiaUJjVTBHRk5hTitWSEFGMkszcm5Z?=
 =?utf-8?B?UVpDa01hRUFoN3BHcUNJeFdnZWFSRForVk5mS0FWd1lja0hVaW5UKyt1QzZx?=
 =?utf-8?B?ZTBpL1Y0VUxsNTNyQ0NyeXhsRUNNL2RDV2FjUW1PVmZSUURXQ3hlWjJDaG5V?=
 =?utf-8?B?NHJwSlJwQ1hSVzdkNjFXMHR4K0xiN21pMUZ6WnlWZE9odk16d3pDV1NFb0RT?=
 =?utf-8?B?dWhkaGQxU3FBUVdOODdBekFmMjlTK3B1ZWhIZ0g3bXBZUnRtblIrNmdqL05B?=
 =?utf-8?B?SW9aYW1yM0c3dGtDdWdkMmlJYzNseGpRcERhQTRNSis5WEIwVHdYc3kwT28x?=
 =?utf-8?B?elRqQy8zM2JWQXRGbmNBNGErUWxTYzR6MHp5Zzg1S3FEZk9OYURPa2ZhaWpL?=
 =?utf-8?B?ZlpiSTl3YVdpV1VybDc1ZWJ3OTdGSGlZVDRhTWJKQ2NEQk5QdEpZMkdPRmhH?=
 =?utf-8?B?TnJRNU1zeEhwQ1lSKy9hOExVcmk5bUZsVk1mVXhtczVJZGQ3NFlsOUQ0RUth?=
 =?utf-8?B?RmF1SUJaVllRTk1kd0syZHZ4cG15bHFEajRQUGN1Y0FnalVoZGtoaUYrMlpV?=
 =?utf-8?B?RlI0V3F2aE41UTNYQndablRpTFVKZXYzUzdOeVFIR3V2QnVSY2ZDc1BRRVVh?=
 =?utf-8?B?YWlLWnRWcWlCdEZwdnBGNUtPVGhCZDNwbmZIdWw1akNGb0lieUFQMUc2YjhE?=
 =?utf-8?B?UjBDbHZKNHBlTTBlN2d2N1R1UUR4STJXVHhHMURFTm5uSEs0UEtvRkQ4NU93?=
 =?utf-8?B?dnhmajdkVVZhZ0ZNZlZQMi92YkY5REdsZjJiTEtMYldkekJXUVFmemlrcm55?=
 =?utf-8?B?SnBiTDFmblpuaEhsdEpVOG11MU52WjY3dU9haEJBbE5vVmdCa3N4QWlBL3RJ?=
 =?utf-8?B?ajRZVEhKb3A1S0JUd3FDL3RmUmZWQW5ibjZhQzhVd3ZVVUpDSTZ2VVV2VzFo?=
 =?utf-8?B?SkQxdU1XTU5rdndzZWFRVE1oaENvSXpEdjQyRGIrQjlvSnhDdGx4ZDh1bDFO?=
 =?utf-8?B?eWZzUTd2R0ZtZVF3T2ZyaVZDdWR3bjFJSCtTc1J5MlRRcVdWYnhUa1pXVkdm?=
 =?utf-8?B?RERWYThjY2ppUW1QeUZCZldGUWZHZW5ZYnpTQUlUSUFPb2pSNzN1L0pEL2tU?=
 =?utf-8?B?N2hQRDdjeVlGOEFUclRuQWF2S21oKzhOU3BDZnVXUk8zbUxWOHFJa3IvQWt5?=
 =?utf-8?B?cWRVUjR6a3JtQ2cyNjZIZnVaRTFkYTNiY1RFbVNvK1NsbmdRYWtOQm5sTDR4?=
 =?utf-8?B?c0JpNlZtMHZ2MmNCVUR3enNZV1hFd1h6NUw1Mjh3L3h3SjZoaE1iOTA4SEdX?=
 =?utf-8?B?QUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53bee215-04b3-423b-d657-08db0eab9306
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:50:27.4764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ufkgMLlzi66QyLHp7ysNm0Qba3unLzmI47s+TlhQ+S2c/jwiC84XbO/IXZFwOhZ24HHXzb/jFf7ALnlxsgygFjk/xLbceYApWf17spYlGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5303
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>
Date: Tue, 14 Feb 2023 09:34:09 +0000

>> -----Original Message-----
>> From: Alexander Lobakin <alexandr.lobakin@intel.com>
>> Sent: 2023年2月14日 0:05
>> To: Wei Fang <wei.fang@nxp.com>
>> Cc: Shenwei Wang <shenwei.wang@nxp.com>; Clark Wang
>> <xiaoning.wang@nxp.com>; davem@davemloft.net; edumazet@google.com;
>> kuba@kernel.org; pabeni@redhat.com; simon.horman@corigine.com;
>> andrew@lunn.ch; netdev@vger.kernel.org; dl-linux-imx <linux-imx@nxp.com>;
>> linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH V2 net-next] net: fec: add CBS offload support
>>
>> From: Wei Fang <wei.fang@nxp.com>
>> Date: Mon, 13 Feb 2023 17:29:12 +0800
>>
>>> From: Wei Fang <wei.fang@nxp.com>
>>>
>>> The FEC hardware supports the Credit-based shaper (CBS) which control
>>> the bandwidth distribution between normal traffic and time-sensitive
>>> traffic with respect to the total link bandwidth available.
>>> But notice that the bandwidth allocation of hardware is restricted to
>>> certain values. Below is the equation which is used to calculate the
>>> BW (bandwidth) fraction for per class:
>>> 	BW fraction = 1 / (1 + 512 / idle_slope)
>>
>> [...]
>>
>>> @@ -571,6 +575,12 @@ struct fec_stop_mode_gpr {
>>>  	u8 bit;
>>>  };
>>>
>>> +struct fec_cbs_params {
>>> +	bool enable[FEC_ENET_MAX_TX_QS];
>>
>> Maybe smth like
>>
>> 	DECLARE_BITMAP(enabled, FEC_ENET_MAX_TX_QS);
>>
>> ?
> I think it's a matter of personal habit.

It's a matter that you can fit 32 bits if you declare it as u32 or 64
bits if as a bitmap vs you waste 1 byte per 1 true/false flag as you do
in this version :D

> 
>>
>>> +	int idleslope[FEC_ENET_MAX_TX_QS];
>>> +	int sendslope[FEC_ENET_MAX_TX_QS];
>>
>> Can they actually be negative? (probably I'll see it below)
>>
> idleslope and sendslope are used to save the parameters passed in from user space.
> And the sendslope should always be negative.

Parameters coming from userspace must be validated before saving them
anywhere.
Also, if sendslope is always negative as you say, then just negate it
when you read it from userspace and store as u32.

> 
>>> +};
>>> +
>>>  /* The FEC buffer descriptors track the ring buffers.  The rx_bd_base and
>>>   * tx_bd_base always point to the base of the buffer descriptors.  The
>>>   * cur_rx and cur_tx point to the currently available buffer.
>>> @@ -679,6 +689,9 @@ struct fec_enet_private {
>>>  	/* XDP BPF Program */
>>>  	struct bpf_prog *xdp_prog;
>>>
>>> +	/* CBS parameters */
>>> +	struct fec_cbs_params cbs;
>>> +
>>>  	u64 ethtool_stats[];
>>>  };
>>>
>>> diff --git a/drivers/net/ethernet/freescale/fec_main.c
>>> b/drivers/net/ethernet/freescale/fec_main.c
>>> index c73e25f8995e..91394ad05121 100644
>>> --- a/drivers/net/ethernet/freescale/fec_main.c
>>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>>> @@ -66,6 +66,7 @@
>>>  #include <linux/mfd/syscon.h>
>>>  #include <linux/regmap.h>
>>>  #include <soc/imx/cpuidle.h>
>>> +#include <net/pkt_sched.h>
>>
>> Some alphabetic order? At least for new files :D
>>
> I just want to keep the reverse Christmas tree style, although the whole #include
> order is already out of the style.

RCT is applied to variable declaration inside functions, not to header
include block :D

> 
>>>  #include <linux/filter.h>
>>>  #include <linux/bpf.h>
>>>
>>> @@ -1023,6 +1024,174 @@ static void fec_enet_reset_skb(struct
>> net_device *ndev)
>>>  	}
>>>  }
>>>
>>> +static u32 fec_enet_get_idle_slope(u8 bw)
>>
>> Just use `u32`, usually there's no reason to use types shorter than integer on
>> the stack.
>>
>>> +{
>>> +	int msb, power;
>>> +	u32 idle_slope;
>>> +
>>> +	if (bw >= 100)
>>> +		return 0;
>>> +
>>> +	/* Convert bw to hardware idle slope */
>>> +	idle_slope = (512 * bw) / (100 - bw);
>>> +
>>
>> Redundant newline. Also first pair of braces is optional and up to you.
>>
> I will fix this nit, thanks!
> 
>>> +	if (idle_slope >= 128) {
>>> +		/* For values greater than or equal to 128, idle_slope
>>> +		 * rounded to the nearest multiple of 128.
>>> +		 */
>>
>> But you can just do
>>
>> 	idle_slope = min(idle_slope, 128U);
>>
>> and still use the "standard" path below, without the conditional return?
>> Or even combine it with the code above:
>>
>> 	idle_slope = min((512 * bw) / (100 - bw), 128U);
>>
> If idles_slope is greater than or equal to 128, idle_slope should be rounded to the nearest
> multiple of 128. For example, if idle_slope = 255, it should be set to 256. However 
> min(idle_slope, 128U) is not as expected.

So you say that for for >= 128 it must be a multiple of 128 and for <
128 it must be pow-2? Then I did misread your code a bit, sorry.
But then my propo regarding adding round_closest() applies here as well.

> 
>>> +		idle_slope = DIV_ROUND_CLOSEST(idle_slope, 128U) * 128U;
>>> +
>>> +		return idle_slope;
>>> +	}
>>> +
>>> +	/* For values less than 128, idle_slope is rounded to
>>> +	 * nearst power of 2.
>>
>> Typo, 'nearest'.
>>
> Yes, I'll fix it.
> 
>>> +	 */
>>> +	if (idle_slope <= 1)
>>> +		return 1;
>>> +
>>> +	msb = __fls(idle_slope);
>>
>> I think `fls() - 1` is preferred over `__fls()` since it may go UB. And some checks
>> wouldn't hurt.
>>
> I used fls() at first, but later changed to __fls. Now that you pointed out its possible
> risks, I'll change it back. Thanks.
> 
>>> +	power = BIT(msb);
>>
>> Oh okay. Then rounddown_pow_of_two() is what you're looking for.
>>
>> 	power = rounddown_pow_of_two(idle_slope);
>>
>> Or even just use one variable, @idle_slope.
>>
> Thanks for the reminder, I think I should use roundup_pow_of_two().

But your code does what rounddown_pow_of_two() does, not roundup.
Imagine that you have 0b1111, then your code will turn it into
0b1000, not 0b10000. Or am I missing something?

> 
>>> +	idle_slope = DIV_ROUND_CLOSEST(idle_slope, power) * power;
>>> +
>>> +	return idle_slope;
>>
>> You can return DIV_ROUND_ ... right away, without assignning first.
>> Also, I'm thinking of that this might be a generic helper. We have
>> roundup() and rounddown(), this could be something like "round_closest()"?
>>
>>> +}
>>> +
>>> +static void fec_enet_set_cbs_idle_slope(struct fec_enet_private *fep)
>>> +{
>>> +	u32 bw, val, idle_slope;
>>> +	int speed = fep->speed;
>>> +	int idle_slope_sum = 0;
>>> +	int i;
>>
>> Can any of them be negative?
>>
> No.

So u32 for them.

> 
>>> +
>>> +	if (!speed)
>>> +		return;
>>> +
>>> +	for (i = 1; i < FEC_ENET_MAX_TX_QS; i++) {
>>
>> So you don't use the zeroth array elements at all? Why having them then?
>>
> Yes, the zeroth indicates queue 0, and queue 0 only support Non-AVB traffic.
> Why having them then?
> Firstly I think it more clear that the i indicates the index of queue. Secondly,
> it is for more convenience. If you think it is inappropriate, I will amend it
> later.

Well, it's not recommended to allocate some space you will never use.

> 
>>> +		int port_tx_rate;
>>
>> (same for type)
>>
>>> +
>>> +		/* As defined in IEEE 802.1Q-2014 Section 8.6.8.2 item:
>>> +		 *       sendslope = idleslope -  port_tx_rate
>>> +		 * So we need to check whether port_tx_rate is equal to
>>> +		 * the current link rate.
>>
>> [...]
>>
>>> +	for (i = 1; i < FEC_ENET_MAX_TX_QS; i++) {
>>> +		bw = fep->cbs.idleslope[i] / (speed * 10);
>>> +		idle_slope = fec_enet_get_idle_slope(bw);
>>> +
>>> +		val = readl(fep->hwp + FEC_DMA_CFG(i));
>>> +		val &= ~IDLE_SLOPE_MASK;
>>> +		val |= idle_slope & IDLE_SLOPE_MASK;
>>
>> u32_replace_bits() will do it for you.
>>
> Sorry, I can't find the definition of u32_replace_bits().

Because Elixir doesn't index functions generated via macros. See the end
of <linux/bitfield.h>, this is where the whole family gets defined.

> 
>>> +		writel(val, fep->hwp + FEC_DMA_CFG(i));
>>> +	}
>>> +
>>> +	/* Enable Credit-based shaper. */
>>> +	val = readl(fep->hwp + FEC_QOS_SCHEME);
>>> +	val &= ~FEC_QOS_TX_SHEME_MASK;
>>> +	val |= CREDIT_BASED_SCHEME;
>>
>> (same)
>>
>>> +	writel(val, fep->hwp + FEC_QOS_SCHEME); }
>>> +
>>> +static int fec_enet_setup_tc_cbs(struct net_device *ndev, void
>>> +*type_data) {
>>> +	struct fec_enet_private *fep = netdev_priv(ndev);
>>> +	struct tc_cbs_qopt_offload *cbs = type_data;
>>> +	int queue = cbs->queue;
>>> +	int speed = fep->speed;
>>> +	int queue2;
>>
>> (types)
>>
>>> +
>>> +	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	/* Queue 1 for Class A, Queue 2 for Class B, so the ENET must
>>> +	 * have three queues.
>>> +	 */
>>> +	if (fep->num_tx_queues != FEC_ENET_MAX_TX_QS)
>>> +		return -EOPNOTSUPP;
>>> +
>>> +	if (!speed) {
>>> +		netdev_err(ndev, "Link speed is 0!\n");
>>
>> ??? Is this possible? If so, why is it checked only here and why can it be
>> possible?
>>
> It's possible if the board bootup without cable.

Then it shouldn't be an error -- no link partner is a regular flow, not
something horrendous.

> 
>>> +		return -ECANCELED;
>>
>> (already mentioned in other review)
>>
>>> +	}
>>> +
>>> +	/* Queue 0 is not AVB capable */
>>> +	if (queue <= 0 || queue >= fep->num_tx_queues) {
>>
>> Is `< 0` possible? I realize it's `s32`, just curious.
>>
> If the wrong parameter is entered and the app does not check the value,
> It might be 0. I'm not sure, just in case.

Ah okay, so it's a check for userspace sanity. Then it should stay.

> 
>>> +		netdev_err(ndev, "The queue: %d is invalid!\n", queue);
>>
>> Maybe less emotions? There's no point in having `!` at the end of every error.
>>
> OK, it fine to remove '!'.
> 
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	if (!cbs->enable) {
>>> +		u32 val;
>>> +
>>> +		val = readl(fep->hwp + FEC_QOS_SCHEME);
>>> +		val &= ~FEC_QOS_TX_SHEME_MASK;
>>> +		val |= ROUND_ROBIN_SCHEME;
>>
>> (u32_replace_bits())
>>
>>> +		writel(val, fep->hwp + FEC_QOS_SCHEME);
>>> +
>>> +		memset(&fep->cbs, 0, sizeof(fep->cbs));
>>> +
>>> +		return 0;
>>> +	}
>>> +
>>> +	if (cbs->idleslope - cbs->sendslope != speed * 1000 ||
>>> +	    cbs->idleslope <= 0 || cbs->sendslope >= 0)
>>
>> So you check slopes here, why check them above then?
>>
> Because this function will be invoked due to some events in
> fec_restart too, so I added these checks here. If you think it
> is redundant, I will move these checks to fec_restart. Thanks.

Maybe you could make a small static inline and use it where appropriate
instead of open-coding?

> 
> 
>>> +		return -EINVAL;
>>> +
>>> +	/* Another AVB queue */
>>> +	queue2 = (queue == 1) ? 2 : 1;
>>
>> Braces are unneeded.
>>
>>> +	if (cbs->idleslope + fep->cbs.idleslope[queue2] > speed * 1000) {
>>> +		netdev_err(ndev,
>>> +			   "The sum of all idle slope can't exceed link speed!\n");
>>> +		return -EINVAL;
>>> +	}
>> [...]
>>
>> Thanks,
>> Olek
Thanks,
Olek
