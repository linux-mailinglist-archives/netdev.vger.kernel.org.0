Return-Path: <netdev+bounces-871-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2067B6FB24E
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:11:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30420280EFB
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24CFD15CC;
	Mon,  8 May 2023 14:11:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1156F1361
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 14:11:50 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD253AA4
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 07:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683555109; x=1715091109;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ikm6a5xbmPy1ZRqI66qN3LDxnvNg71ykq+PsZpLotBk=;
  b=eokr35kcR2dn6Wt7Q/NxJhsTXKTHaAsBdDCBjTzMIcfDAjcbCguprMUN
   UITBEaQaSriklYySjXOvA2/N9HRJjKbiKH30dvj+RSDmOOATOr+Ax5Zqh
   26Fz1QNmn/QcNCB4oXQ++q3YM5Umk6PBU35w2PZtjDubV7o6MXT6yZHqH
   0zfO2viZsc0oBsYcC4aGbVelexRDMD/rlVFsXsw/12Z96xkp7qyRkrHoE
   g1kz6nOo+ggQgUllEcXO1JkdwELEqUEXVB1V3y97kEIqVRdcgLzube7b0
   hYd7AiXmeRfiqm4A/Rfr4chpjXwVmrlfPGNX1b+YxpnnVs0cXF34m7Yw9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="330017233"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="330017233"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 07:11:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="788108308"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="788108308"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 08 May 2023 07:11:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 07:11:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 07:11:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 07:11:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 07:11:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iwio6OBSgvRMSSMb7NzCr74x1xRDMRXnM5DtezImn3Kanf/VLN+9wjOpxjffR893/4tXnsor7bmUCGob/43aAUKqbIQ7zgjAsjaRfU55eot3fl7F9aaMQc8ir92xL7cKeh1GZD37t+CJYvlE7xpxhU2wHXfZRcVLqolrYygFlZ+Uo8dhupKPMeqkhlyFIhGkhnwn2CuipyfATIA+3sJCCEjzFvzzv92GB3FRjxOpjbdd+mkALt9lYKJ7wtojcFs8yjo3IqNtXn7AacTLZhc9TWJ5yT5XCsusUI71DZO8BV7CAIq5syV1uBtSTPIYW/ZiFGhSCz8NWqbMw8vN+0uTOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GV/OPVuLl6fgEIm4tuP2CEmPRePeRvU+NOQTi5O9xqI=;
 b=LFemd3t1NFWGlDXJdfDrMhsEThy/U96WScJNjTekA+J4Ix9Swo3z9FbdBHaXd7cgnoms7cmmj942RhUnRIeevK0v3mVuLLJ8+yZGROm1JLguo34E3jg7vu50HLs4p4dkCvZuP3NfGo99l6UDQqPhWfvdVGjQd0LZQkIxHtyAS2ea6/b+jvJRLJOXH/U7bWiL708CIIsLB9OVir2NsPt5NX//GEW+myYQX1JqMBqPulu3xd0J41jfY8upBX2X/82FtZ9XLSSm3R1brS3vS8AhsVeM1v3uHYUUCrHg2USSDfVdaJSdW2E0AmByZ82AZBJvGto4GBZLxVJ7ul0v74z80Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CY5PR11MB6283.namprd11.prod.outlook.com (2603:10b6:930:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 14:11:40 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5dbd:b958:84b4:80e1]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5dbd:b958:84b4:80e1%5]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 14:11:40 +0000
Message-ID: <3f761331-8bd5-a2b3-2f47-a562d28c6a3d@intel.com>
Date: Mon, 8 May 2023 16:09:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 08/12] ice: Add VLAN FDB support in switchdev
 mode
Content-Language: en-US
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ertman, David M"
	<david.m.ertman@intel.com>, "michal.swiatkowski@linux.intel.com"
	<michal.swiatkowski@linux.intel.com>, "marcin.szycik@linux.intel.com"
	<marcin.szycik@linux.intel.com>, "Chmielewski, Pawel"
	<pawel.chmielewski@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-9-wojciech.drewek@intel.com>
 <d3cc5703-bc8d-9e5e-c354-94dde3b1e91c@intel.com>
 <MW4PR11MB5776844315E90B76E1DBCD64FD6A9@MW4PR11MB5776.namprd11.prod.outlook.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <MW4PR11MB5776844315E90B76E1DBCD64FD6A9@MW4PR11MB5776.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0087.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CY5PR11MB6283:EE_
X-MS-Office365-Filtering-Correlation-Id: df7dbcf8-102a-46e7-12b4-08db4fce2451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C6T2/DlZ7AKCoWyYd6P0KdpRqh24RI1jrBX0+PN9jk8Xg9pFZf9SBf83jpYdheDKQ3Z1F9YzI4WS1PMmgyfiM1Ma3eKb29E+/0f2YzYB1+6B1N0a9tac+mQ0Nqhp2+/KZjWBRrjzgJcgeKuezj73bhMkVdS7UzZYAICWuwUlI13G4NI3DOyS8KFYmyxQqAVnZMEmd43ctMy5JSCwa2Og9sKspkAZ6yS8udCwDd7ERe29lUVl9L9M1jaiSSVkwzjQs0TWqCPjhXE5pE4SMkPvN4wI3EkaBLF5wQPLKZXDr5XJm7ekgKdTlnpfs8BoaJkXP+lFEn93VNMwAp5KrAnYdqLkv1KQPRxs9kMyyAusXfYkldpK4x2Z2a7ehMOtOr2eBDiBHqQS5ZjevcAbx76mJLsLUFjnRvuUjgixMJjz631z4a79mXmLHcougO3wReuYr+85zHexLiVPqKNzUlTeQrU5CkWRX/fQ3TlxXjMRIanUarzTEbY/SxwReB1hRqv8e2SZQvGZUT5bwtvU7Nx+kEbZ+gbh7Tu1UJ0g7o7X64FDpQB+FMnc42EH5+aZcCmYDM6Bx4MhVPQIy/el4BjKfD3/da0ysNd0RUpn6wqy633T+Cr+i30rP7GxgHol4YBJ8C9BRNHfkL8ME1PghPaOIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(39850400004)(376002)(346002)(136003)(451199021)(26005)(6506007)(6512007)(53546011)(6486002)(83380400001)(36756003)(2616005)(38100700002)(86362001)(31696002)(82960400001)(186003)(37006003)(54906003)(2906002)(8936002)(8676002)(6862004)(316002)(41300700001)(478600001)(6636002)(4326008)(66476007)(66946007)(5660300002)(66556008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2ZiUDl1REt6UXRCWTJVV1pidTR5dEg1V05BYWRWdEtkRUdlOGZmSnMwbnNJ?=
 =?utf-8?B?Tnk5S3NGUHcxUDF3K1NoUGp4U2tZZHZqN0o1eGpmN296cC9UaXI2UGlYa2NX?=
 =?utf-8?B?WXd6dUR0aGkrN2M0S0pvRnRyamtQV1RET2MzV1NZVWkrTjc4ZmEyY21yY3pz?=
 =?utf-8?B?OWFXT3REYU5HcU4yUUsxMUpLakszMStCUkFsTjhkRjFidFJsYTVvS0MyY3Ro?=
 =?utf-8?B?SUVDNE52MjNUbWtpVWwzUVNadmpGZWZ0eHJlZ2J5c1BkTWZPZWIydHNzUEl6?=
 =?utf-8?B?cGViTndwK1Q1TjVyNVE5eUE2Z3JCT0Rvc2hDQWRQWHZGRElTWnVFRWVqVW1m?=
 =?utf-8?B?VWxBM0F0R0xHblRtQnVWWGxSbkEvNVVNbkRZV0RqZkU2N2l4aGRZcTJlcHZX?=
 =?utf-8?B?Ni81WUFjbmlRaEM2Y1cvT2dXRkRxS1dJaWdEejdMZWMwa1FtdWFydE5wOWlp?=
 =?utf-8?B?dUZjQU8vYWFjaDZSdVhxOGFtajg4RGJwV3FJdUZ4L3NROVNWRWdoRGJwWHI2?=
 =?utf-8?B?U1dFNFFuV0RkU0FvQTkvM3BrRFcxdFR0b21NT283dHQwYThmTUZJbUE4TzBr?=
 =?utf-8?B?a1lsaEhFbk5hckZiSkp1VkRTbXFUNzlORjFRNGNNazhSWFJFWW5abkZrTWhv?=
 =?utf-8?B?TUlsZ3B6cVkwR2xYZlpZRjFPV3JEbVJBbFhpOHVrMkdqcG9wZUFpWkgyU3RN?=
 =?utf-8?B?Y1N5SGZ4ck5LNUxraDNmYkFDaVhmVW91NWR6bndycVJ1d2NzQ3NBNlFENkpZ?=
 =?utf-8?B?MXNmcEtuRTJNWHcrQW9pdU5PanFvNzVNMnhMT0J1QmRDSmJMZGJCZW0vS3JD?=
 =?utf-8?B?MkxmQVdiN084QjVubzAranlaUnlhWW5jVUtkaWYzVzA0a1pta3lyNC9PMHVm?=
 =?utf-8?B?S1VBUXlDNVZTQkdXZUd1bEROZjd4NDZvdXVFZnI2U2t1Uzk3THJiVXJ1aDZI?=
 =?utf-8?B?QU1GcWlJM1ZpNlRrS1pMRHhRc09ad1RVWStueXhrNzNBRkxwMFRKUzIvZExy?=
 =?utf-8?B?azNzcXc5em56WldWc0U3YkMweTFZb2c2WnJ4dVN5a25LTW9YOTJ5Ym1LU3My?=
 =?utf-8?B?Uk9VcUpOSWxaOHlrc2YwQ1pOSHdRdTk4dm5NVVFZUHArTkFoM09yWEY3UkFW?=
 =?utf-8?B?N3ZDNDZtNWxJdytGNWdGY2VOUDl2Sk84cW52YjVQaEVCNU9xMHREV2VRdEM4?=
 =?utf-8?B?QW9HV2dHNFFvQWRkTmdDMmxqdW9WSUtRUWVoeVJjdmp5TEQ4OTJUaGxKU0Vt?=
 =?utf-8?B?bVU2NFZVVzdaSm5zZmorSm94WDM0SEZTNzJZcjJnMVk5aWMwS0llakN3ZzRL?=
 =?utf-8?B?bXcxMHFOZzJPdmtHWGRXb0JhUStmZTVtekxDWFJNMmFUM0JiSlF1UnF0Mk9q?=
 =?utf-8?B?UjlHYkZjOC9RTjVxenhoVEtCUFNqMVBSOXpxR0pVMkRUUjFVeW8wTTlZU09i?=
 =?utf-8?B?L251dnZzbmFYVlhyOXYxdkg2TmRKUENHV3pzWGpDdGFJWVhPQXF4aGl3VFZr?=
 =?utf-8?B?bFluZ0VXQmJ5aDlhaDc0R1VONnM5VmhNdjB1ZE1vVThwd09PS3RZZ29ualJw?=
 =?utf-8?B?UC9penlMaFJvY1FKR3JNRzVNM3llNXJiWmllYmVqam1CQWQyVERITVd6NklB?=
 =?utf-8?B?NjRKaWtTMEwzY2N5Wk12MDhJbnVteUZ0aXhYVVo5aXEva2VaZ25qNVhHRzJi?=
 =?utf-8?B?Y29nUG9xL3BMSWN2MmNWTEhXcW9vUnZka0s2L2lnK1BuRjNnYTg2NTVKQlZM?=
 =?utf-8?B?RmdlK1UvQjZvRTM3dHZHajArVFVnUlY5Smh3YUJiR2toaXJsZmsvQ3R4NlVQ?=
 =?utf-8?B?WExCYW5ENFN0c1NnNHFwTC9qaTZ0ZmdlL04rUUFTMTk5S1FJMXo4QnlkWTlz?=
 =?utf-8?B?MU5UbEgyWG5OSVNCK2c0YXluMXFXK2l4L0JqRGRnQThUbUpXbjRFWSs0TVlK?=
 =?utf-8?B?SE83amttNHJLVjRYN2dZNzJiZDhYUzZYdXo2UWhrOWx0bHkwT2c1WVAwUlND?=
 =?utf-8?B?SHVkZkUvTG9Ja3NnVVRlVzJHNUdIbFN3RTFsS0hqbkQ3cFdsb20yeHgydjBE?=
 =?utf-8?B?S1VJYjQ5c1A5Zzlnb2R4dWVoMUpNT1FKQ0oxV2swUzRtZ29VS3lRTE5xa0l4?=
 =?utf-8?B?QmFsa3ptK014eERDNEJuQjQycXBXSXNXSTZDby9PK2VZMUl4R1A4Y3NReUh0?=
 =?utf-8?B?dVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df7dbcf8-102a-46e7-12b4-08db4fce2451
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 14:11:39.7838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sA4IzMj0/9yiFwwjWuD+Xir4kDhkoM9dJSfZCb5N9e/AmqFVU0PJ4W2IbTwHQenrxshbLIcS3b0wVIScyrOeY/2ZmlaiQS7Gligw09hBDFM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6283
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Thu, 27 Apr 2023 12:28:21 +0200

> 
> 
>> -----Original Message-----
>> From: Lobakin, Aleksander <aleksander.lobakin@intel.com>
>> Sent: piątek, 21 kwietnia 2023 17:25
>> To: Drewek, Wojciech <wojciech.drewek@intel.com>
>> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Lobakin, Aleksander <aleksander.lobakin@intel.com>; Ertman, David M
>> <david.m.ertman@intel.com>; michal.swiatkowski@linux.intel.com; marcin.szycik@linux.intel.com; Chmielewski, Pawel
>> <pawel.chmielewski@intel.com>; Samudrala, Sridhar <sridhar.samudrala@intel.com>
>> Subject: Re: [PATCH net-next 08/12] ice: Add VLAN FDB support in switchdev mode

[...]

>>> +		break;
>>> +	default:
>>> +		return -EOPNOTSUPP;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>
>> [...]
>>
>>> +	br_offloads->switchdev_blk.notifier_call =
>>> +		ice_eswitch_br_event_blocking;
>>
>> Oh, you have two usages of ->switchdev_blk here, so you can add an
>> intermediate variable to avoid line breaking, which would also shorten
>> the line below :D
>>
>> 	nb = &br_offloads->switchdev_blk;
>> 	nb->notifier_call = ice_eswitch_br_event_blocking;
>> 	...
> 
> Hmmm, I feel like it is more readable right now. It's clear that we're registering
> switchdev blocking notifier block (switchdev_blk). Introducing generic variable (nb)
> might a bit ambiguous IMO. So if you have nothing against it I'd leave it as it is.

Noprob, up to you :)

[...]

>>>  	int ifindex;
>>
>> (BTW, ifindex is also usually unsigned unless it's not an error)
> 
> It is defined as int in net_device, so I don’t know

I know, but back then people don't care much and were usually defining
everything that doesn't need explicit size as `int` :D No interfaces
have a negative index, indexes start from 1, which is reserved for
loopback, so even 0 is not used. Up to you anyway, I just usually don't
use sign when it's not needed. But it's more of a personal.

[...]

Thanks,
Olek

