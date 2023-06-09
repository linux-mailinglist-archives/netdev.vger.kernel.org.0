Return-Path: <netdev+bounces-9630-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCC2672A0FE
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0C9D1C20EA2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD2E1C74C;
	Fri,  9 Jun 2023 17:12:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ABC1B904
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:12:29 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E31D359A
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686330747; x=1717866747;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=omHVIwLR3azXyxnSgSyBWB5mJUWPnov9XCdaTAtEyj8=;
  b=WYnc6pjEI19NZTOzKXxy+RpyqiUE4ajEb8V5/gfxU1a0Y3NtD7RXgOuw
   D49NXjhOJ5X9iT1A7FgyerkJO+MzR5B11JsCK5vTqQpdyOr/xPh2jhzlY
   yxSUtRu3EBS7pZW16aFgxhYryQsrnnHYmGkEty8HLBm49N/FjpMFEca6K
   G74c9vCgOwsMoMvihiShRt/zULEuIkRLa/KjsqDYO3hLhTYweNyyFfuSG
   Bo+cb0USVMYLZWex58o8GsWkDMyygQiJtK3cru5RShGsB+Y5NvP8gplnW
   vbwBRuI8zJWbeUrnL9V5nbx9Ajkzcc5oV9umon2X9gtf2SAan8+E+AEq+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="421236331"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="421236331"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 10:11:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="775576978"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="775576978"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 09 Jun 2023 10:11:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 10:11:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 10:11:38 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 10:11:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4tB0L1iYMUOZkjKXRGFXaID3j7Up5NnqkzuQ2HgV2lkRJbKFfLARwn6+7LUZt57pBP5rPIEo4NS4FCWH7TTPfMqvoVbbQHdQS1c5Nc/mZEnfWU8gogkAnJmV1BfT107BwmN8dRvoydg8KJ058WdPStHFmikf9uBdoxvuYlZ00AJ/MpOaODwRw9CFRO9FXL3A0gwvdMjhhOE5MOFnIvOCLkCK41rUm+kJnaTNtRfqCYn38JX9+ur9I4yX9WUMON7LWoQN20G3qb3yFoiX0jMXBBgW1zp5sXv8RxD1YAzK+PHCICfUlXb4/jRoUJnclShnGVPvQcAOOxV7FcMZmAp7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lnW8cYw91sZ8mU1JC9qpW0gfFaBICstkTWpzcLzT1kg=;
 b=YIJPCrOhPM25TWJRYnBTGMKp/U6wAliHe2N91+/poRjECDaYRFqBijlT3DP8+xCwiyHLG8oi8VhnFUkMxNDn1kYr3v4s9Xq2TCtc1xfGv3o13V1UofYG5KjjwTOSwBUlkk5MR0nTkQPj2x15ue78qCXDuY/aMLyyhGWgCDeG6NlBtxVUwn50Dr0a4j+I7uzL2bkCFp++iiUjB61dSAsS3ZoPxTqDCctw5y/mXIy55SHOPhr9vVXw6cTxiwiKQPIWPXEktzaG5M2CgfJzw4f48069JMZdOE0fIMgCyJzTIBimTBu1TT2eIZO3sl/y9krf4haYQnJQsYN5rcO9OXcXhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4451.namprd11.prod.outlook.com (2603:10b6:a03:1cb::30)
 by MN2PR11MB4678.namprd11.prod.outlook.com (2603:10b6:208:264::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 17:11:38 +0000
Received: from BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb]) by BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb%5]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 17:11:38 +0000
Message-ID: <06b5b9c2-38d8-2767-8b6e-1d23c88f397e@intel.com>
Date: Fri, 9 Jun 2023 19:11:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next] net: add check for current MAC address in
 dev_set_mac_address
Content-Language: en-US
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: <netdev@vger.kernel.org>, <przemyslaw.kitszel@intel.com>,
	<michal.swiatkowski@linux.intel.com>, <pmenzel@molgen.mpg.de>,
	<kuba@kernel.org>, <anthony.l.nguyen@intel.com>, <simon.horman@corigine.com>,
	<aleksander.lobakin@intel.com>
References: <20230609165241.827338-1-piotrx.gardocki@intel.com>
 <ZINam0Qlz47WFafH@boxer>
From: Piotr Gardocki <piotrx.gardocki@intel.com>
In-Reply-To: <ZINam0Qlz47WFafH@boxer>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0072.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::11) To BY5PR11MB4451.namprd11.prod.outlook.com
 (2603:10b6:a03:1cb::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4451:EE_|MN2PR11MB4678:EE_
X-MS-Office365-Filtering-Correlation-Id: 63d5a8b3-f757-45f5-d09b-08db690c95eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tpLsu+bsrvJz+/iKzuiIe2yDWSS0CORAzHZMcV0jjL0OH75jr3eTdKkbRjMyzeG0g0dEAaq+aTXDReLnA3+CwQDxA8ZkCc1c0NW8t85o/QWXq6YbTznb+WoUczOFobVOOpkrpVSbcL0/V+u/IXr5vuYncsnaOzmE9Zku+uQZgIdrmkdWHSjzE/TnGoRdiz4gG61ww8LsMpexAXH2xmpM6M7lqf7gtsXbT1/4rzp7r99v0pQBAroQv/kJF0kvCJVPxc08kQ4p7ADGsEdRLfXpgZHQXmuckvoDOaa79oXNu2g8y2+8y5tMPsQ0GxDNM4rL/e8lmufz/47EBXwFY807SWT2bMSx85ySbdHNOqUuTCN8TytcaOYX59R+lTY8vei1vehplqLgu4WhXUGBXiWoaUoKEOwMFh+XqvwxfoUJV09JyQw/H140uS8uAuAnMuQojGp10xnHG24cilsDQh3kH+03+SV1MhvjZUC4H7Td9/CFLdS5XVOfWV9H78ELH33Lo3bLxQe8DhADk/1c2PmuK/A6TUSbKy+ojlbbmUu1qP/RsFn8QThnV6KtH19XuSTpGHhSMxcGotmJPpOnLmxLJohh/G/qjkiRwCVPu++rQ105LQGNXfgVTZloE5BmH/0MwahI5edna5jjtKtpQIAcew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4451.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(136003)(346002)(396003)(451199021)(53546011)(26005)(2616005)(6506007)(6512007)(83380400001)(31686004)(6636002)(66946007)(66476007)(4326008)(66556008)(6486002)(6666004)(186003)(316002)(37006003)(478600001)(31696002)(36756003)(4744005)(2906002)(5660300002)(8676002)(6862004)(8936002)(82960400001)(86362001)(41300700001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVdvTWtqdllQbWpURUNjM3VDMVI4QXpiMDlUM0hFMk01ME0vNGphSGxTb2Yw?=
 =?utf-8?B?NEVQYVhMY2NISFREVUxITS9vSjg3YUdjQlNXck5jUUM3dWF4c3hlZHZpZHRZ?=
 =?utf-8?B?YTljR3NiY3dGQkJwMUdmVE9CczI0VXNiZ3lhNysxTHpqdHJWWmliZmdCL0Nv?=
 =?utf-8?B?akppdGY0eG9iTDlwQnZNWHBFSG9tMVZIUzhkaXpCL3Y1UWdDYytNUE90TjhH?=
 =?utf-8?B?MEJORTRaelZNbTVSZWJEenJwTEdTZFc5Y051bFM0QklpcU5NWTUydHRlVmg0?=
 =?utf-8?B?MU1jTjFiajJJSC9VU0JCUEEwWm5BV3lzQ3I4Q2hkblVsU2NMSnhLNElCaGc4?=
 =?utf-8?B?M1V6T2hPbVk5ZzY0K1VkKzVtQi9NWkhSRGFhdk0vc2xFQi9IMkdwamRGTExy?=
 =?utf-8?B?Y0pmbGVyMWU4aExoaG82dXFrMGNmSERqQ2ZOZ2FSMFBOckdHd3RKN3UvbVhE?=
 =?utf-8?B?cFdLS2FHZTJsRnZFUEZ4RTFYUDZkK1c3L3lCb3A3T1B1WlFkQXVMNDlFcnZw?=
 =?utf-8?B?VEdIRWNlUUIwMzRqYlJZSVdWdnVyaHhNT1JPcDZrcmdZdE1SdENRNGU5ZjVp?=
 =?utf-8?B?M1diNGNKWVdPWVVNVjZvRUxmS2NzR0tBTGRjOFo5Y3pWWVUzMkcwNU5pWllU?=
 =?utf-8?B?KzFHYzJDV2ZFNndYQit5OWcxdHZaNFZrcnNFMjFMcm1EZVdNeUkrZXlqVTkw?=
 =?utf-8?B?RnVYTWRtcmF6VGFqZTRUdXVUVFVCMG50dW8wVHIvWGh0Mmt5UXIydHJ1ZUdF?=
 =?utf-8?B?N01JclpBS0QyN0V2dGRodWFYak9rUVRHWW5DNmRmTzh1Z21Ta1ZySUVBVWRQ?=
 =?utf-8?B?Ym5mWmV6d2l1VUtRbXdSbHhPVjByMkVmT0dwS3pLZ3IzaHVOeE4rUUZVNUh1?=
 =?utf-8?B?bXVjYVRtK05sdUF4YVBicUhzSVlLVElMSzB2NENhUWpFR2JMWFQzYWNhd2xr?=
 =?utf-8?B?M1Zmd0k3K2xoemxHTFJOYy8xMkZCOWJYNmhzUVF5dUhETXJRQzJjbEp2a3hl?=
 =?utf-8?B?bDdBb0dJck5zdCtLclY4TjJBTldKQmdZTFEyMnBGeHFuQ2JtVDJSL0lEcGdq?=
 =?utf-8?B?K0t5RXhrVit0SStHQjhtK0RGZmppZnN3YUIreUJXZU05eHYxczQ0bXZyekRC?=
 =?utf-8?B?NHNjRHA0N2wrMkVEaFBjL3BhdlVkRDVUdGcxbGZydHdic3dSVXQ1djFiVTNx?=
 =?utf-8?B?R0dSRnN5UmlmT1Q3RzVONDZBNGFtcHhpMnVHcUVJODVlNkwrTmh3aUZ4MVBt?=
 =?utf-8?B?MXVjZ3ZJZHlVZFNoelo1SXNoVVNyTVhLSFlzd2VZb2tiWnhBUUxEZzlBbUlM?=
 =?utf-8?B?d0Q5akNXTzdQellGZW5CR0g5bVNVMmlUOTQ4WWxlcWNtNExJa0lYWVpvdkpx?=
 =?utf-8?B?QmNSTlI0djU5RC9NTDdZbU9OdTViajg3MlV4a0NTcS9pU2xaUUhyMkRLamRJ?=
 =?utf-8?B?bTIvdTFEZ0Y0VmV0ejFPd0N1Q25tWWliUmJnZ2k3NURJWStFallkeTY0bnNp?=
 =?utf-8?B?SWdoMWFLRjlRRVF2bW1udThmZlRJYWQ5a3JhY3FXa2djRFBVSUpFaXR3eEhR?=
 =?utf-8?B?aXByTStrZE9LcytabVM4WFhubE5DakR0NFZyK2hvMFdHUHBicFNrVUdsYWlW?=
 =?utf-8?B?NVM1NlV5K29sOGdYYzVJQXF3anZpTEV1Yi9Cd3l1NEVQK3htK1NrNXpKczk2?=
 =?utf-8?B?RDdPbnlvRWl3d1pkZUozOHVHZUhHNEc4eFFvSHRvckFKYzZ3VXVJQTNJOWo4?=
 =?utf-8?B?K2Z4QUIwOEh6cDdMNVZNdGtyVDY2Tkl5aWtaWTlHODZIemNzTXpYOTNsaXBQ?=
 =?utf-8?B?d2I0QzdsYXhSTnZWeHhvS0RPcXU0VnFDMWNpWnlxZmZVaEpWdi9NQmFqUFgx?=
 =?utf-8?B?bC9PTTRlQndoSVBMT0cwVGNaNTkyMW1JaHNrNkZpbGY5enFsQ3o0SUg5Rzdz?=
 =?utf-8?B?azArMEUyeTZwWkwvelVaVmtWZEwveC9FWkRIcmdsWldJV2dqZjNqVm9qOWIz?=
 =?utf-8?B?YlN1NTc1NlJlN2VNUTBGQzhmSjNxYVUrNnFWVDcrbjBYYktVTmR6Qi8vcVYw?=
 =?utf-8?B?RmJiS1FGZExFMEtaN3lBejA2ZkdUMWQxQ01FMVhjWVgrcUVDYzIxd3lQWk9k?=
 =?utf-8?B?ckwzS2Y3eUJHNEVCb2c3ZlhZYk03SmtVYTB3SVQ2ZDlZbGsrenJnN1dETklk?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 63d5a8b3-f757-45f5-d09b-08db690c95eb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4451.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 17:11:38.1760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +40Y0k5vm/sAsy4dCSw3ejgcNHE437f33TpxbDKrulbBPzkCdpAJXnfIegD3Cr5uuQtb2OyhRR2v/bHyT4GqCBO3mYxXf90uJZma36hu+EE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4678
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 09.06.2023 19:00, Maciej Fijalkowski wrote:
> On Fri, Jun 09, 2023 at 06:52:41PM +0200, Piotr Gardocki wrote:
>> @@ -8820,6 +8820,8 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
>>  		return -EINVAL;
>>  	if (!netif_device_present(dev))
>>  		return -ENODEV;
>> +	if (ether_addr_equal(dev->dev_addr, sa->sa_data))
>> +		return 0;
> 
> Now this check being in makes calls to ether_addr_equal() within driver's
> ndo callbacks redundant.
> 
> I would rather see this as patchset send directly to netdev where you have
> this patch followed by addressing driver's callbacks.

Sure, will do :)
I will remove this check in all drivers in drivers/net/ethernet/intel/,
I don't have time to review all usages of this callback in kernel,
there are too many of them. Will resend as a patchset next week.

> Moar commitz == moar glory ;)
> 
>>  	err = dev_pre_changeaddr_notify(dev, sa->sa_data, extack);
>>  	if (err)
>>  		return err;
>> -- 
>> 2.34.1
>>

