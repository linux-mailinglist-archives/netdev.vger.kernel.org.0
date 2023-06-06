Return-Path: <netdev+bounces-8364-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50630723D25
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0AA6281591
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE482910A;
	Tue,  6 Jun 2023 09:23:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE8C290E1
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:23:11 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257A9E69
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686043390; x=1717579390;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mSy3qpakabSmjdCp2CSmnbaC/BFwYzQmSyhFL21xyko=;
  b=HKDFwUc9eqq7Pxkey3cTepDp9Hxfu/Wd3I4xLJtyyDINR5pQgBZfINhg
   14DKsFSigWhmR7axL2yvqZ81aTts0IUJXlJAqXQ9FC7v118/esPLHp2dF
   vypn/2K8wvaXUFwubEL0eI2uYMKegRgE5fb+qMTN0JraPYkdFqSrxRqmn
   ZddewATTaoFEeMgyloX4cUDpO2AlxtISaEpLxZt6CmkqimMsjvB5/YG7j
   pMu+Hv7I+ypVmKu9nXRU1TEr24pSm3Dc0+ZcSIAqSP5AiNTZy2QQ8M7pv
   kQ4IJFJPtjNVe2KYGZPtPTSiVGVQQgZuS1cA7ryCQfGipkfk4ASxNUFGy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="422439671"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="422439671"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:23:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="703082761"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="703082761"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 06 Jun 2023 02:23:07 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 02:23:07 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 02:23:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 02:23:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 02:23:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9WTyHfTtiOt1eOUe32M0O2oTPmLh19F77MQV5nyuhcgexI1omX+i7984gTLLtqLj2InK7vNI6//0jwTMlygTVhAlpeb0vIV7sZ9scd2/YELIrIkvLBp9daPWxfbi8OGWQ4UgLFlmCuuAZxNb5HbKipqpcS4cYYEMJzqs8EFforezg1lglDuTdIYi3d9MZP1Mero2YZUCWAHE/TH5yi4E3Wh4ac6eB9Bf86SnFsYkt/PjB7KCdzJ/Q4x+N4qhi0PlHNSACMOSbxBMQURBjTQW5Ecrs/YfuA38L4pe39lWEusyAZPwepFBOhkxkuyYGJAsZEUhHXndQc5Jt2Cacvh9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZsZOK5pbDAxfzMDD5DPjqpCnHuDzvPKXipm0dxLXWY=;
 b=HHx6hEjCgbzgf47ZwF9jaPA7wzVJjI0X/XiWFnX8MDNl+zueVnVfQxjWaW5IowgFLBzauOZDqGSAf6bHjESew8WFtEkJLyyj1O51FwDEwRGU+/TNSujPTi9IPFg8xwa+xg7Z4BTuhbHfnjXCl8RR20IyBkTvpyQfEIWXcL8iAjFlH8iLhvOjfXo5xvo/qzxU4imTTqKvQGSIxYfTwTNjyXInsnF6ER60Kwkf/62fICmSWt/gBodbIrkaAFqFnH25WGCjFOd+ZhSOqx8291dHtdnBKb1h0PlCnwhx2bwodcdtraZDptkuI0bppZ8Ly8PcPuupN1eD/xdZWQNpc81jtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4451.namprd11.prod.outlook.com (2603:10b6:a03:1cb::30)
 by CH3PR11MB7299.namprd11.prod.outlook.com (2603:10b6:610:14b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:23:03 +0000
Received: from BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb]) by BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb%5]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:23:03 +0000
Message-ID: <e7f7d9f7-315d-91a8-0dc3-55beb76fab1c@intel.com>
Date: Tue, 6 Jun 2023 11:22:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next 1/3] iavf: add check for current MAC address in
 set_mac callback
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Tony Nguyen
	<anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, Michal Swiatkowski
	<michal.swiatkowski@linux.intel.com>, Rafal Romanowski
	<rafal.romanowski@intel.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-2-anthony.l.nguyen@intel.com> <ZH4xXCGWI31FB/pD@boxer>
Content-Language: en-US
From: Piotr Gardocki <piotrx.gardocki@intel.com>
In-Reply-To: <ZH4xXCGWI31FB/pD@boxer>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0133.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::25) To BY5PR11MB4451.namprd11.prod.outlook.com
 (2603:10b6:a03:1cb::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4451:EE_|CH3PR11MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c8fdd75-6865-41ff-4468-08db666fa0b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fhO+kchKb/5Dpe/czzgp+XRsoNnfN3yavhzz8d68SF8TluqOsX2pwl6RF5ZUmTuPAWmtcL2dZto/sXyiWdfaxWvfrpve9M/Wa6GqAZd8M5/FwY+zuYKHk0kcrWtQznn/Jkqv2H1BK1fsbD8PW9dzWrNp6F63out4HFeDjFoQcVFsTDloSVJjki6neblyVe8pOHBAwlodJyyKsd8S7aun/ddmlVgCxbp0LRvuzHqvSW+naG6FvRGyDBiRrfzUQZsIQ2OjjTLPhA2OA1QrK0b/TteTIoNR55ghzvNdrY+ts8n/MW+05GtDR3pNHCPPkZ6HRnY6xpngsuVfaAGdXTnF6/rmNPvU0KQ9n6waJV7wb2A1+xSSfqRQxZi8p3/a3aFvojbQHJSvVI5Rb2KuUd0lKe2QqFksQdb1+4m/RgutUYzl6XRJyV/q/e4ntnPRq2HLGD3EvCRLtRenKewK0X7vvtgX7W0mjip6Lfb/ytkZGkvHoGRJJ3+82Mbe5GiZ7SVEIAnTVLfxHjwPfxfNqb+HKT7LVYimAzWsuGErooP6pr0XBSD/gOxrc/HbeQbHVcnliaOtcTlqRwsT18i61LqUzv7gejq9V0dR60+sqKE5PzIVjaojKHZMYb5NQok1HkG8Wi5032bpsIM5eo5gdIpmyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4451.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199021)(54906003)(110136005)(82960400001)(478600001)(8936002)(8676002)(5660300002)(36756003)(31696002)(86362001)(2906002)(6636002)(4326008)(66476007)(66556008)(66946007)(316002)(38100700002)(41300700001)(2616005)(53546011)(6512007)(6506007)(26005)(83380400001)(6486002)(186003)(31686004)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eEJzVzBWck94ckgwYW92K3U4VFJDcHBzNXlvTWRHSVhRUXpMM1NzZ2ovUFJV?=
 =?utf-8?B?M0RMNzRuNzdSdHJFUitHdW83Y0owVnorUy9HMk5rd2w0Z29FMVNDdmt1Ukw1?=
 =?utf-8?B?Qk9GblpaWkJzT3BKdWk3TU5qS1ZUZ3R0MWdUNkxJdFczekEvVy9xME5qMjRx?=
 =?utf-8?B?Vmk5S3F1SWo1YnJqMEpiSVQ1Z09qTEdGR3RNanYvOU9qZVAzTTlnMzljLzFU?=
 =?utf-8?B?aVZsdC91WVhVZnBTMFU3QzNtcDNwSEtUR09VMitLV3lGc1cwOUg4MXFPeUIr?=
 =?utf-8?B?bEp6amlKZzZHRGlzWXVlVzlBWm5XV3ZaY2RDR2ZndUxZYWxxSGlsc1I1bU4r?=
 =?utf-8?B?ajZqUkpkTFRhOTZ0TWRPS1MvV2ZtcFM2UFJjZUZZRGFUcTF6eU5UWkV2K2tj?=
 =?utf-8?B?K0d1Z1JnUmU1MjUxMngvK3hXTDFBSFFwQnY0VnBFVDVpcHVJdHZ2M3prbXVU?=
 =?utf-8?B?RzhhNGkxNVhjODdnTCtWRXZoRFduUDEyWjJkcS9XeDRVNXlMWmZxWWt6QjVj?=
 =?utf-8?B?WWJ5YTV4bDFWcXpNcEZ3a1poT05jUUZxOEpnbU5uUGs3SXI1Wjc4NTNESmRR?=
 =?utf-8?B?YkNaNlZaUlNOMmtXUXpka05COURianVycnUwOVBRSTJvK25WaTZtcGJQa3l5?=
 =?utf-8?B?NFlxVEFMeSt0U3RSbFFFRmNtN3l1MEM2RjV5UkJzcFJmVXFHbHZ5U211ZGtF?=
 =?utf-8?B?TFdOOXdDdTkvWFhtYVdra2k3OXZJYkV2VWhMckVzdXZ4a3dIcE0wYUliSnBr?=
 =?utf-8?B?T1hjUkxtSW95dzdPdjRlWDgrU3Z3NUxHdTZReERWeVU4TkZOZWdqb2lFeFov?=
 =?utf-8?B?L2R2eitiMlNjMWZ4MnAwenEvY1RoWTkySFdYZGNqcGNjWFJKZUdhT01PRDlB?=
 =?utf-8?B?MFE5U0xsWUkwUVhEMEVUc3hoQkwrQXNBQXpPaXNxUm00NlEvNkFnTDNCYmRZ?=
 =?utf-8?B?bzVTZjJIVGlXeDRjSzVwOWFuRjVLWEZ0SFJ3dmdIK1UvL2ppTlNYQ2l6OVU0?=
 =?utf-8?B?N0E2eFQ5T04zYkxsM2ppc1pFeGFITW1UaFUxSGcrWW9xQnpPMVRHMkx1NkUw?=
 =?utf-8?B?TTV1eXVjL3lGRjZJTEFUaTYya1BJU3AzMWZmY3IzbGJYUzJ0NWdhQ2tSRTJp?=
 =?utf-8?B?bm14U1lLV2JRMitiRTVoY1pnTS8xWjhJREdsWUkrUmR1SFVlbGpjbjk4THh6?=
 =?utf-8?B?MlpuY3AvSXY5Y0dYQUhvZCtCcGFKYWFsYWloWHd6SzJRWWZ2bnlHQzhERG1W?=
 =?utf-8?B?NXZwY1ZjVHB4UTQrOGVzcGZNV0tFSnBIQW00cExXczVZM1JLdFZiRlM2aExL?=
 =?utf-8?B?czBSVWVHbEdvK3VDZ2E5T0M5WGw0cVpOUEpMUTVvTEhnNVdHWlZjQnJnQ3RZ?=
 =?utf-8?B?ZGNYY092alQ0ZHR6MzZMTGVkRDBNOHM0QmUvaDVXVGJWWnYwRkhodzBDcmYr?=
 =?utf-8?B?VU85TGpGUkR1VWVESUVya2hlVy9PR1pmRXJDbGVMNENlOXN6c2kvdm1FT25M?=
 =?utf-8?B?bG9WTHM2VTZyK0NMMmF2blhQclloQVpFM3AzTW5QeWNtR0pzUDZRdXdqaXNj?=
 =?utf-8?B?bllzS2tNTkp3cTJsNjhVZ0V1cXRacTlncG5YQkJRMEUxWG9QZVY0OFJFeVNI?=
 =?utf-8?B?WENpL0tTbkxrZW03UDhINTU2bkNaYmYvNzllWjV3Z0FZNjBmT1BweXp3VE1x?=
 =?utf-8?B?MUQ0WGV0R2VxY3l5ZmV3R2lxNlVza3NWbEs0M3FJY2grY1hMT2FuQ2wvZXB4?=
 =?utf-8?B?a1B1ZUNOVVRuT3JHbGprRU1qRExJS3BiOTRzVjYwbW9veXlxMTFzNDJKWFhh?=
 =?utf-8?B?YTFpY2NHdk5KeWNGVVJ4cjBuVko0UzdibzEvWGxrVElvdWU5ZmRheDNOVGox?=
 =?utf-8?B?RXJUaXNTUWFPcFBXUjZ2ODNlNjZVVFBzUWMyMEltdlFLbXo5VmpvZTRscXN1?=
 =?utf-8?B?ZkY0QW51NXc4Y0JOcExvQTdZeUlZODRUN3UvTDhvYzAwM0NyMHhvbWJPcnBt?=
 =?utf-8?B?RlZsMEFZZkpKK2lIeTlQdlpKTU90b0tWWDVsRXVzQmxqY0ozMlR0d2orNnFj?=
 =?utf-8?B?V2NOZVlGTHR6MWlwcE85Z0I0QUN2bkV2eVZwRnVYdXlGSUl4ckVQVjZsL3lo?=
 =?utf-8?B?Rm81ZEtCZG5ySjBIbUFNaEUrVzBoSS8zZDR5TkUvNThOZFNRUjJvQjZPU3lV?=
 =?utf-8?B?RUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c8fdd75-6865-41ff-4468-08db666fa0b3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4451.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:23:02.9680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KHHqhXx2cVZMKQWIzBCJ4yBAJ/cB+nso3oZDuKBZYOnc/4GvBkt3XmzmbsTEkxnrJCh8H2IdZsOzK910ZlHQhqm0WR9l5qTFTQ1rL+HoMpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7299
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05.06.2023 21:02, Maciej Fijalkowski wrote:
> On Fri, Jun 02, 2023 at 10:13:00AM -0700, Tony Nguyen wrote:
>> From: Piotr Gardocki <piotrx.gardocki@intel.com>
>>
>> In some cases it is possible for kernel to come with request
>> to change primary MAC address to the address that is actually
>> already set on the given interface.
>>
>> If the old and new MAC addresses are equal there is no need
>> for going through entire routine, including AdminQ and
>> waitqueue.
>>
>> This patch adds proper check to return fast from the function
>> in these cases. The same check can also be found in i40e and
>> ice drivers.
> 
> couldn't this be checked the layer above then? and pulled out of drivers?
> 

Probably it could, but I can't tell for all drivers if such request should
always be ignored. I'm not aware of all possible use cases for this callback
to be called and I can imagine designs where such request should be
always handled.

>>
>> An example of such case is adding an interface to bonding
>> channel in balance-alb mode:
>> modprobe bonding mode=balance-alb miimon=100 max_bonds=1
>> ip link set bond0 up
>> ifenslave bond0 <eth>
>>
>> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
>> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>> ---
>>  drivers/net/ethernet/intel/iavf/iavf_main.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
>> index 2de4baff4c20..420aaca548a0 100644
>> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
>> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
>> @@ -1088,6 +1088,12 @@ static int iavf_set_mac(struct net_device *netdev, void *p)
>>  	if (!is_valid_ether_addr(addr->sa_data))
>>  		return -EADDRNOTAVAIL;
>>  
>> +	if (ether_addr_equal(netdev->dev_addr, addr->sa_data)) {
>> +		netdev_dbg(netdev, "already using mac address %pM\n",
>> +			   addr->sa_data);
> 
> i am not sure if this is helpful message, you end up with an address that
> you requested, why would you care that it was already same us you wanted?
> 

You can find similar message in i40e and ice drivers. Please note that this
is a debug message, so it won't print by default. I would leave it this way,
it might be useful in a future for debugging.

>> +		return 0;
>> +	}
>> +
>>  	ret = iavf_replace_primary_mac(adapter, addr->sa_data);
>>  
>>  	if (ret)
>> -- 
>> 2.38.1
>>
>>

Regards,
Piotr

