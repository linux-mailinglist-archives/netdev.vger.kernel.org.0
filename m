Return-Path: <netdev+bounces-8405-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A081723F0A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:15:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92DCC1C20E4B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:15:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 515F12A70D;
	Tue,  6 Jun 2023 10:15:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2A02A6EA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:15:03 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5322E196
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686046502; x=1717582502;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lSeDC7xGvpHVwEMtF+DFfPA+m8paWxpsHmbR/WlvR+4=;
  b=acstX6AYGsyCWhsXECGRkpwmFh6Ec2f80lv3y/L0ZEPFyYagThpm8p9T
   fZCdSFu4NiIpyZObquN9RtNpUZ02VXSy7onPbHD87ojqRSwby8OKG+B1R
   nUnXLfM5oO0MikmIQolV3LC/vlNWclzpOIaByEvrhsVoobL6Y5lSV+wiq
   KwOiiHcm12Imj4viodQCI+bIkCmPm9+g22csPzSOBDKVc0tKSiuVASuGj
   3484a8vnME6NDz+rrwSTvelN0b2ddn8+tnoZPSKlD6qTd6PzaSFNg09TS
   bSuGATZO0YBEajhMwEP88MRm5jNUaPIuQXgzx9B0s2no5NhVFLnp8/3GH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="341263775"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="341263775"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 03:15:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="821573330"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="821573330"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jun 2023 03:15:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 03:15:01 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 03:15:00 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 03:15:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJ1kaFTP6i+ntAipjteNYjE0dTggrGLdh9Wvujhc9gIQJr19EoItP0qmsYMiMrifBnVYl9pdxua8SEXLa2zkZD/eyNXluvf+Jhg1mngbCVxAu9WRungFpniXwfbhJlpoSQp6+RvFA/kHQoG07qDwJfi3xw49IkXH0N8Iu5ea/QhZv2k4vQWEgAbOwFdeuVFtHMGtd9iP2AWHHpMx4h99Hzp1QkrM+o3/XpnCXP5/7fSxpx2JF8+QFJLg8d+e3mkASnASfUVHp7kBHAKi6AkV+F5ylFCrgk0Q6eBXQuV0+rcMUp5Y1P83pn5JrL81T6mZg3LRXHqcdRtiO8mJ9blxRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGSqDqISChNQbj/WbruSMHwlrTNh2hP7wThsx+gBDwk=;
 b=EwyXjnsZ3Xvjl2O4MWtsIioaV8Zd1xU/ISEAnOO78Dn255winHJVerUAkPXCU4LqfclQYs9HsAgR2kw/6U8BNJJB4n2/OP/uYQo87MwhlzyqEUBB1xpjGnZkSOuDL7yOxub74YHiVEu9SmeTtkv7sz3ieQueBTYCzLLGcJSXY3mxmyE+0uZNYXQmDBQCuiS2of4d73JmhUtjs5d7/++i/aSU0+I7z4a46qmhREWpgJw+qewb/kCDBI9045/Tg2z6BkjChx+BCkAOjtKiaBI0zPHQV6OkW/xF7+FJfjPlprfdyHAEUEzA8Vc9wATJCLVEvKNj2sDaMLXREIQocGcovg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3672.namprd11.prod.outlook.com (2603:10b6:a03:fa::30)
 by DS0PR11MB7684.namprd11.prod.outlook.com (2603:10b6:8:dd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 10:14:59 +0000
Received: from BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299]) by BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 10:14:59 +0000
Message-ID: <29e3a779-2051-d4bd-08fc-2835b05de55c@intel.com>
Date: Tue, 6 Jun 2023 12:14:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH net-next 2/3] iavf: fix err handling for MAC replace
Content-Language: en-US
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Tony Nguyen
	<anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, Piotr Gardocki
	<piotrx.gardocki@intel.com>, Michal Swiatkowski
	<michal.swiatkowski@linux.intel.com>, Rafal Romanowski
	<rafal.romanowski@intel.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-3-anthony.l.nguyen@intel.com> <ZH40yOEyy4DLkOYt@boxer>
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
In-Reply-To: <ZH40yOEyy4DLkOYt@boxer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0283.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::18) To BYAPR11MB3672.namprd11.prod.outlook.com
 (2603:10b6:a03:fa::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3672:EE_|DS0PR11MB7684:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d6df8d0-8127-457a-5cd6-08db6676e220
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DdBDCG3dxjVHbhR7lCP3j6xXqNR77JWRb3al2C/WbOsqR0qBLaWnpY8r3r0J70Oi+6/+rOILIOTpQdtsFQXe6Lx8ArrKdDnb+Vih2gwxufkau5GBi9R/GrtQb7WFQnhtAbpZIFxoS323mZCEEFymWr65OTuCd/ENg2uT2TKmlXKIMo3PY0oT9k82Lvx2FqRQChtP/cWg3uLVl3TUQ3ff9m0Z2UKEo0VeZ76XJTepMZweO5nxl0zIgEUxyh4wJ4BZNZ3qRxfEl2KslB4iadO3JZU+e21HVIp4SZadD4apPXq8rUU2tMvu7vJmHv0jHsPkTYW/5g6r97782hTXMNAbjf6NWyhfN6TDUtHStnn1b7+C2C8cQ000gMbcIi+qmijhVD2/drUxgXlz11FyHu2hXwYffncZiYhsWLBgnGXv2g1MM0LFXU1sIqGXsnaoaeMGN03ZmsDCpsvWX0J/qR7srxI1BP0x8y50VHXsqsM7ARxs2yRKiZP0cIirIx+E5BOQvneDvYkTTB9ccZahb/AkzUCaGIi8E2pgedS3iyB980dtkjzoHBL/jm++NZVE6r6b+He0b6lwQvKQw8eg4iwsYo3TQ9n24CBZFNjazRQ1ucA/FrdF94QpL9cuq7sISmcIcwGJyL7sO2aFwEmWNl0uSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3672.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(39860400002)(376002)(396003)(451199021)(86362001)(83380400001)(54906003)(110136005)(6636002)(4326008)(38100700002)(66556008)(66946007)(66476007)(6666004)(6486002)(478600001)(2906002)(186003)(36756003)(2616005)(8936002)(8676002)(41300700001)(316002)(5660300002)(82960400001)(31696002)(31686004)(26005)(53546011)(6512007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1BpbktFY21BWnROV0pwZmRaeC9sbDM4SVRCVW5zVCtxQ05mTG94bXlwZ2hm?=
 =?utf-8?B?YnByY2cxSUNoMWRlUlVCTFdqQ1E5OXEyeWhEck0ySzQ5TXd4Mm9TTW1tdHpP?=
 =?utf-8?B?b1gwWTN3YkI1SW15SHkvTGRkOGNpNG1nVUN2eEtsZEFNTnBKRFpBRWZPaEJR?=
 =?utf-8?B?eTR0N0Y4b0ZKQXAxMHRKTlZnT0d2THR4UVNpY3YrQi9vQ2NHM1E4MDN1dzdN?=
 =?utf-8?B?OGJqMmpkODlmZFVtV0NFOE4vdjVQNlJsMWkxbE5FRVdaTVArbTdMc2tMZUM3?=
 =?utf-8?B?ZTBNYXI4Rlp2WnloeWZ1eFYvRGJtcUFIWEduUHhKdFc4dWhNbWhvWDFmcHRp?=
 =?utf-8?B?QkVMZFFBT1oyUVQ3cE5jREZ3cnJBSktvK1ZLYmNicVNwdTYyNjlXcjcxZG5a?=
 =?utf-8?B?ZFZxUHo0V3hIS1ZTeSsyMk02alhoTkVjd1c3dnFzWWRSL2NMWGwvQ0I5c05m?=
 =?utf-8?B?WDRRQ2swVmVPL05iNExwSXlDbGwyMzlrbnhpcnFnYklQRjBndDdKVGFNeUJ6?=
 =?utf-8?B?QldyZ1Irb0J1cUcvNVN5L3EyTkFJdkZ2UHZ4dXhOSTZnV2ZNRklzRHduV0hM?=
 =?utf-8?B?ckVmWXF4TkJKS0xxb1hrSHpkeFF2OTZWV0d1cXdPTENVRnRpczFSRGpaZnMx?=
 =?utf-8?B?UzdDSTNWN1R6cFNBUWFWMXI3bGUzYUluTStQbW1Eb2dPT0RrbXFDN1ZOZzln?=
 =?utf-8?B?SDk2SUg5ZGRYTlI0am9NRlU3SHZHMU52SDE4UU5VK2dyRTFCRnNyOE5qYjNh?=
 =?utf-8?B?YXRLbjFGZC9MdTRPay9OTVFMSWh3NDd0dG1lZElyRktMSjhIM2JBd2lsRkFR?=
 =?utf-8?B?VWxNdW5adFlRQWpSckxYcUk4TnB2d0dZbSs5K3RMQ3Rta3hDZW8wbGc0TXls?=
 =?utf-8?B?ak83UEQ1U1FEU1lVMFJlRTVGZnRtNE4wdVlJTkZnZTlYbENKQjBoVldoQTBj?=
 =?utf-8?B?R1hmRnl2K2M4UWJGQS9qTlFESVNjRTEvWVFtUHFBTGRoU2thYzIwYitHMFhP?=
 =?utf-8?B?ak1hMTJpdEpOazFGM1haaktSYldSNFZ0TGpCdGZZaVBLRDNTRmkzRTRzSnNT?=
 =?utf-8?B?R0h3aytZS3FUK1FyY2EvQ3Y4SGFOOGo4TmpMaFJtVXhmQzNtU2tjZmFNbmdC?=
 =?utf-8?B?RUw0OWhKTFU5VDhCam44WjUwTElzOG53bWc2REh4WmFZQjZGT2NHVDZrTklL?=
 =?utf-8?B?Y3FnY2EzU015NFhiQWNFSy9UWWZVcFMzb05FQjRMMUpQYTRmYXVpUjZsQWJ5?=
 =?utf-8?B?T1MyM080L2xrdnh1TUx2VzZuS1NhS1U3QWVxMkF0MUgwQ3J4b2xhdVdnWXN4?=
 =?utf-8?B?MHdjY0prMjdQZlBVMGJiaTIzVDhMcW9mdUUvdFU2Y2ZwWXJ3MGJOM01qT1kr?=
 =?utf-8?B?SVZ6QTY0OWFRUjFQaElySVdyby8wcEgvWFBVRzY5MDVzejBRYmRSaDdjM1NE?=
 =?utf-8?B?UDViMkNNV3ZNWmlscmRFK2JVUkJQdEFhUENjRms5UjhLdjdyaEpWVDIvTFgy?=
 =?utf-8?B?ZFVISDRBTm1mL0JHSk9wVTllSG5nWllYS04reElhRjVIV1V4Z0s5bG15ZnBt?=
 =?utf-8?B?akQwaXQ3UFhCNDF6dzVidmZ3VnBNcUhMa3hlOHk3V0VHZHNrbEpNV1l4d01q?=
 =?utf-8?B?dGJqMEhvN3NRSWw1NmVFVWdoOEQxSFUxS3pNdk1RL2xhekd0QWdaaFZnUFFm?=
 =?utf-8?B?STNLQ1BsV0tINGdvd0lSRWlZekVOVVV0dXF3a29zRmdzQzZSSWtWSUFNZS9v?=
 =?utf-8?B?WmUxeXdqb3llTFBwdC93RGZOMVpHVGxVWUtMMVo3ZldENnArbnJnSm13NnYx?=
 =?utf-8?B?cWFBT3pibFQ1ZWVldHpVOCs3V3M5bDVFTTdldTVtS0J1bmFyQno3VlFwOVlx?=
 =?utf-8?B?MWkyUkpzRVZzK1Q5UGFLa2NBRzhGN2Zub2tXanNqU0RMWWlYbVhtT1NRR0xx?=
 =?utf-8?B?SzRRcGRHd3pOeTVCdzhQNGRiampITVBra003a0Ixd1AxYm1BYmlTbmtFaGFq?=
 =?utf-8?B?ajJWUmJ4eDIvWlladjZYNFpFdEUvaE5nb2VCMEcrYzQzaDBvS0hCYzJWV0Zt?=
 =?utf-8?B?SHFpWXpiZWdRNXJHYjlxQ3dkejVkV1dva3dUMi84OERFclowRW9jbm5yMzhM?=
 =?utf-8?B?RndCQUM4MGt6alFlcDBUNllaN0pkVm5pSmtPajVKaUtFY1N3R3hScmFBL3lj?=
 =?utf-8?B?Nmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6df8d0-8127-457a-5cd6-08db6676e220
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3672.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 10:14:59.0173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ++szM7Zz57E7J15dugIU5pbuz1Vylu6+ajBwiBd1V9zHnTgAZhbN5LTkSGsFLc1mupcEHNP+wuxQRhyqCyd5K1KlTFS0Cif/7hzBUSCQFFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7684
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/5/23 21:17, Maciej Fijalkowski wrote:
> On Fri, Jun 02, 2023 at 10:13:01AM -0700, Tony Nguyen wrote:
>> From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
>>
>> Defer removal of current primary MAC until a replacement is successfully added.
>> Previous implementation would left filter list with no primary MAC.
> 
> and this opens up for what kind of issues? do you mean that
> iavf_add_filter() could break and existing primary filter has been marked
> for removal?

Yes, prior to the patch the flow was:
1. mark all MACs non-primary;
2. mark current HW MAC for removal;
3. try to add new MAC, say it fails, so that's an end with -ENOMEM;
4. ::is_primary and ::remove fields for the ::mac_filter_list, alongside 
with ::aq_required are left modified, to be finalized next time 
user/watchdog processes that.

For me it was enough to treat it as a bug, and for sure a "bad smell".


> 
>> This was found while reading the code.
>>
>> The patch takes advantage of the fact that there can only be a single primary
>> MAC filter at any time.
>>
>> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
>> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
>> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>> ---
>>   drivers/net/ethernet/intel/iavf/iavf_main.c | 42 ++++++++++-----------
>>   1 file changed, 19 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
>> index 420aaca548a0..3a78f86ba4f9 100644
>> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
>> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
>> @@ -1010,40 +1010,36 @@ int iavf_replace_primary_mac(struct iavf_adapter *adapter,
> 
> from what i'm looking at, iavf_replace_primary_mac() could be scoped only
> to iavf_main.c and become static func.
> 

makes sense, thanks

>>   			     const u8 *new_mac)
>>   {
>>   	struct iavf_hw *hw = &adapter->hw;
>> -	struct iavf_mac_filter *f;
>> +	struct iavf_mac_filter *new_f;
>> +	struct iavf_mac_filter *old_f;
>>   
>>   	spin_lock_bh(&adapter->mac_vlan_list_lock);
>>   
>> -	list_for_each_entry(f, &adapter->mac_filter_list, list) {
>> -		f->is_primary = false;
>> +	new_f = iavf_add_filter(adapter, new_mac);
>> +	if (!new_f) {
>> +		spin_unlock_bh(&adapter->mac_vlan_list_lock);
>> +		return -ENOMEM;
>>   	}
>>   
>> -	f = iavf_find_filter(adapter, hw->mac.addr);
>> -	if (f) {
>> -		f->remove = true;
>> +	old_f = iavf_find_filter(adapter, hw->mac.addr);
>> +	if (old_f) {
>> +		old_f->is_primary = false;
>> +		old_f->remove = true;
>>   		adapter->aq_required |= IAVF_FLAG_AQ_DEL_MAC_FILTER;
>>   	}
>> -
>> -	f = iavf_add_filter(adapter, new_mac);
>> -
>> -	if (f) {
>> -		/* Always send the request to add if changing primary MAC
>> -		 * even if filter is already present on the list
>> -		 */
>> -		f->is_primary = true;
>> -		f->add = true;
>> -		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
>> -		ether_addr_copy(hw->mac.addr, new_mac);
>> -	}
>> +	/* Always send the request to add if changing primary MAC,
>> +	 * even if filter is already present on the list
>> +	 */
>> +	new_f->is_primary = true;
>> +	new_f->add = true;
>> +	adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
>> +	ether_addr_copy(hw->mac.addr, new_mac);
>>   
>>   	spin_unlock_bh(&adapter->mac_vlan_list_lock);
>>   
>>   	/* schedule the watchdog task to immediately process the request */
>> -	if (f) {
>> -		mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
>> -		return 0;
>> -	}
>> -	return -ENOMEM;
>> +	mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
>> +	return 0;
>>   }
>>   
>>   /**
>> -- 
>> 2.38.1
>>
>>


