Return-Path: <netdev+bounces-8585-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9FD5724A37
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:29:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F156281010
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED32E209AB;
	Tue,  6 Jun 2023 17:29:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDDA1ED5D
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:29:56 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E3F10F7;
	Tue,  6 Jun 2023 10:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686072594; x=1717608594;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=8doea8wywfcPrSvysw71yKjb3jWkNJn0hmFrr/XNzGU=;
  b=CbafFCEf+qHzA3Vkaxm2QEezumSnU+zcTPmO/2zGByTE7BAG7x/tonqC
   p8QTu/mFyueCclLwW/++N5t7P/nuPeUQXt2gDFYOy4XMbzWlM++u8Tt+V
   fSXQI3Ojqjcxz7ZIBwC/Yb09mATFcRwK/BDjuSXpD0tRIq9hkmvi3jYem
   ohOmKcguX3TJxpkTG9rr0KHBIXJZvgQRE/R49ddXbnQ3aC9By2Bd0a0Ei
   yuBBLTGJQrjl4e6Kntz4ir6vzPymcapE/QKiEOCCvQwJW5c0bX8b2ni0G
   BXQrtjR7ua9tnJGTaAQ5XVNUKS/UiTfahvDZ/9U0fGKd9TNKLg5YG9Ct3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="346350810"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="346350810"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 10:28:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="833319099"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="833319099"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 06 Jun 2023 10:28:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 10:28:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 10:28:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 10:28:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 10:28:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xp5YhWXy0TCWfqGJEqd0FZB/8gey64qD2ya0vUShBHicaKvbJKu1c9/Swluvnw9T8vuzv4K99Fe2jOjmbaYI5z6YtxEW4AEy9vESEcgooDhfxF5/IaEoS2fPo35nD9WvjMszKXs6bC6uVK/GURZ1vAJZAPgRSJciAzlEBVOCQIXIGX2isHDp+KUBXSqBGfecYJ6DyLCoQzDLIC8e3dNexwA+j/aTqB77ltYVbuZI/1Z5GcAuU29co/g2uE3exZ1cVMbxSQiUOo+29kBmCF3tb7eVGeG2tLZEpZ63rslV5cJk87raVjCYSgKWXNGcRgz5sQBsg1ZUEYIZLbAU615vYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/i4sycZyan772892e2xMVHYi6r5K43XD+n93puBiAiM=;
 b=j6iJdu4x80pZee4g9KnU3upvRGuUO7F9B7D9tuiIctphJ3flWOMPatdUk3qRwMu9goxflXOqpi0R92NwCRr9/h5s9dABkQgsYhIQ4p2xzWpeNQpOGzr/sxZ+RiJb1RKFVR6DGqjGPy1w9KEKXwQL/Dvr8L0jYiof5EIvYW/FqgTslw5voVuDvFEP329bC5s8Y+CrAbU087HXQImsuVyq4MFra2OzaJa9+RTFu1lMi42K+we5ABOB+kmpUd7mc6nCwKCdH0kJmFjUN+DlVcMgD0y/hNvp71m7BiI1XhEh/fkYSWA10NWGkMcVzwbdRuksJJXmtQH+M3b0dqcpR5OMDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DS0PR11MB6518.namprd11.prod.outlook.com (2603:10b6:8:d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 17:28:24 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 17:28:24 +0000
Message-ID: <3279e4c3-2a26-9a77-0334-292fee0c0510@intel.com>
Date: Tue, 6 Jun 2023 10:28:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] igb: fix hang issue of AER error during resume
To: Aaron Ma <aaron.ma@canonical.com>, <intel-wired-lan@lists.osuosl.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
References: <20230526163001.67626-1-aaron.ma@canonical.com>
Content-Language: en-US
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230526163001.67626-1-aaron.ma@canonical.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0046.namprd11.prod.outlook.com
 (2603:10b6:a03:80::23) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|DS0PR11MB6518:EE_
X-MS-Office365-Filtering-Correlation-Id: 436e400f-e1f6-44af-e7b1-08db66b36e9e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zSE/f9WMxM4wZuTfB4p/bU3sSL4XG25g6C7V9+5NNdiNIrdBTF1iTxLL49YkXvVOZOkvLZs8jNTn7uRZ4SwqsC9aO1PqoAzpKEyByls6niRcBcvmLRW9WRBmMilsBJPWnrPZQQ0wyQv6LSxakiepXroRBAKet+0nrX+/ryau5pccfLCjCKt/YqoXp42G2pYkFtkzIcn11l1eh/Ms+Jio2fX4yi4dp4G66oWYB7s5YNCCppLxJaJXGKsvvvJylQhkAG5S4x9MbvLqBVbcaJHbSrPFfrGFJfFXp+QlDQ7aW0o7UYU2QZRQFAhESdz+DDCtyTV8dJtdHzSMhq5G/0ndNCD+h9eNTeAU62tabYKcHuZNjZipAzZuHSdIacx1/luTHQnqN3wzTw2q7rg3udfJeNyDHuRHf0a3oPYd/n77+b/ptaj5XLbzop89OjSYJ1DVcaaj4mK+Wk1Lb3fJekiLUk/KWkhULiSTgUnxa0vBO587LhX8FTrlns/9NPrR/g4XkDWGlkZUTVrMKfO0aWd7O/WGljFd20YckK4GbKfIOblB7KbC2kRm8p/OWH36QEzuhJ35xDFqeaYSmZhz1r4cx3mYh4Lw6oiQ9M52g40qdtOotyiqtsnty6NtBLFllGuyxnQ0zLmLcuCyDZtRaeibFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199021)(26005)(6506007)(53546011)(6512007)(966005)(36756003)(83380400001)(31696002)(86362001)(38100700002)(2616005)(186003)(82960400001)(8936002)(41300700001)(110136005)(2906002)(478600001)(66946007)(8676002)(316002)(31686004)(5660300002)(6486002)(66476007)(66556008)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVErYi96RXJIcUlmZ01iWGQ5VXdFd1ZFQjVva29qMkFiMzdCVExqYW9RU2xE?=
 =?utf-8?B?RGQ5RnhwWHlOWUdlcGlmTXI2d3U3VCsrYUNzQmJCQXhEcC9iN1hDTkZTSTBU?=
 =?utf-8?B?dnZkaDFVZ0RuK21YeGFzM0tZN3BxUVk3NzlWaHl3V1RMM1JZOWJ1U1dtZ2xt?=
 =?utf-8?B?L3l2UmFDdFVnMzFOOXhlNTRSSW4wVTN4S0ZMR29qMDRHTWFLd1drYTNHckR4?=
 =?utf-8?B?U0pENURMb29DZ1RGdW9vTE9BTTJENnhWYnk1cVNSSEVhZHU3R0l4d0RZRGtM?=
 =?utf-8?B?bVQ1VFBnL01kUWRaYU9GdjNWVUVKQU14MEQwdEtMWEt5elN0Tnc4T2tZRnQx?=
 =?utf-8?B?WngzUFUrRFk4T1FwZWYxWjl3YlhwdGxZZklSanFzak1kczZYYW9WTE9yeG9p?=
 =?utf-8?B?aE5tTm5HbXB4WUIrT0plSFJyMnZuMm5zSWV2S2lmdVNvS2xobGk4TGZvMXRR?=
 =?utf-8?B?WGpoeTh5UDRoL1F5UFhhTExlQkExVWZzSXIwUnRCTlpUWlVwL2dmaGhTdlNN?=
 =?utf-8?B?WEQrYmNZVWlJdDB4OUZHYmNqMmJ3aVp6MVJvS29lbkszbURjNFNCRjdka1kx?=
 =?utf-8?B?Vm9ib0kwclQ3T2dGWGxNUEt2YUxxVkRFUnNMdmlyS3RqcGFTQ2pEZm0xNitk?=
 =?utf-8?B?aTVSR3lJbUZJMTBuL2tLZ055VkNlOFd2ejJMc3kwK3BzekFmREhKdGI0eFBB?=
 =?utf-8?B?d2VhWHVuTVdDdnNoWU90RU9scHgwME92TzVnUlpjcmQvYkVKU3ozK0tueHNN?=
 =?utf-8?B?dEVGUHFzd2J0emp5ZDdXb2JjbFU4UXAwTXR1V2g1a0dJK0xWQVBDcThMNTZz?=
 =?utf-8?B?T21NZG5jKzFOZ0xLUm12aElsMzFGS3JIT0k1SDNLdm9rV2FxZHJYMlcvSEFj?=
 =?utf-8?B?UTNyQ2Z4V0ZqdEJZbmJ5NUpWcXNVdXVGcTBmTVpBMWNwc0d6NGl2UUR0cU9C?=
 =?utf-8?B?N0FRNmY1MG9jK3hPL0paNHFleDNRbktuKzh4UjNGcjBSVU4vckduUXQ3eXdr?=
 =?utf-8?B?R284MXhWNHFFM1Q5ZVJuWW1SSWlzZW9rNlNqaGFwU3J2VEMvK2JCYTNSU2pt?=
 =?utf-8?B?NU1jWHFYVis3ZDg5ZXdrQjhRVXF6UHVjM0dhcm4xNkFKQVJhVUphdWJCcnMz?=
 =?utf-8?B?MXlBMTdseWRVc3NNTTBhemtUTzRJenlURElVelJISU9CbGg0anFQbjBNN29F?=
 =?utf-8?B?U0lVVXJ1U3VoWEp6SEpESmh1QzJiRUprd0QzZXdvR2JmV2RpajF2WGhSYmxn?=
 =?utf-8?B?YzlBNi95QXpITTc2b0ZJT3NrK0F0a1pGQVh1TzNnL21nQTIzUG5DdDJ0RlpQ?=
 =?utf-8?B?MmNKV3BwZXRDZHJJRnlBTDN1Q3ZrUHNVWVpXeW9JTllCMmo0UWJWRkhUTFhK?=
 =?utf-8?B?aTV1TGZXMkoyWmg3YU1GUzVaczJVeUxhdERYTmNIR1QzMXpmenNaOVV4MlBF?=
 =?utf-8?B?em9xUFN0MTMwUDBnQkFRNGZwK3lnNUxJbGk1ZlZCaTV2R2M5MHltVXhibFVi?=
 =?utf-8?B?ZyswTExCU2MzN2F4Z3JJL1V6bk05UTkxczJockg3QWZMSUhTZldhSCs4dWJT?=
 =?utf-8?B?MDBidHpseWNaQUlsVzlVV2F1VWZXcTBEN2s0YnNhWjJBcXcxQjRESFJFRVpv?=
 =?utf-8?B?YWVKUnNlUEdWNDBMQlY4UkxxNWljVE5wUTZyKzEyTkFMUEZvNjdEZ1l1K0di?=
 =?utf-8?B?SWl2VmRMNmhPSkZxa1FLMUNYbUM4NjVuVEF2aGs4cU5wRlplYXB2a25aa3lG?=
 =?utf-8?B?N1RVRDFEUGJXMENjb2s4Y3JHNFU0UWJ4L0hNeW1aR0xzMDZMRFJ4V3V0OURo?=
 =?utf-8?B?YUJHVnA1OGVZcUlPeU15RDdIK2x5Uyt0UXB6Z0xDSmpacEliMFNPb3ZPQWNT?=
 =?utf-8?B?U2RYQmliWTArK2lyRzN5ZFpxOXkwZmRwQk1scGR0VElLazhOemJzOGgrTFU5?=
 =?utf-8?B?YTVnZnJ3RXN2cFMxY3lBR212a1p6VkZOcU90WnZJdStiNzZCSXE5b003bzhV?=
 =?utf-8?B?NUo0ckdJU05KY3VZRUpmaUR6a09jRk15Q0UrdWQ2bWVVL2krZkFkb0hxZm90?=
 =?utf-8?B?TjI5Rjltc2xLYytManlzdXN2dHJTR1NSajVJU1FDN0FQS0JYUWdjMWxhS1Ba?=
 =?utf-8?B?TThxZGF6RlQyUS85Z002UnJ0MmkwSDBzYWpFbjZldTJNWkRRZmtEME9Hamw3?=
 =?utf-8?B?YWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 436e400f-e1f6-44af-e7b1-08db66b36e9e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 17:28:24.6203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QfBzzMtkuDj2T8cE+mXM/e7a883mwad0x4P5GwnPJ0KewKAfZY4V34yBcK/Ey0x8HsT5M1bKc8Bv6lsv26Mytwkr8KFdaZrZoS8mtupup6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6518
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/26/2023 9:30 AM, Aaron Ma wrote:

Could you designate the target tree for the patch (net or net-next). I 
presume it's net...

> PCIe AER error_detected caused a race issue with igb_resume.
> Protect error_detected when igb is in down state.
> 
> Error logs:
> kernel: igb 0000:02:00.0: disabling already-disabled device
> kernel: WARNING: CPU: 0 PID: 277 at drivers/pci/pci.c:2248 pci_disable_device+0xc4/0xf0
> kernel: RIP: 0010:pci_disable_device+0xc4/0xf0
> kernel: Call Trace:
> kernel:  <TASK>
> kernel:  igb_io_error_detected+0x3e/0x60
> kernel:  report_error_detected+0xd6/0x1c0
> kernel:  ? __pfx_report_normal_detected+0x10/0x10
> kernel:  report_normal_detected+0x16/0x30
> kernel:  pci_walk_bus+0x74/0xa0
> kernel:  pcie_do_recovery+0xb9/0x340
> kernel:  ? __pfx_aer_root_reset+0x10/0x10
> kernel:  aer_process_err_devices+0x168/0x220
> kernel:  aer_isr+0x1b5/0x1e0
> kernel:  ? __pfx_irq_thread_fn+0x10/0x10
> kernel:  irq_thread_fn+0x21/0x70
> kernel:  irq_thread+0xf8/0x1c0
> kernel:  ? __pfx_irq_thread_dtor+0x10/0x10
> kernel:  ? __pfx_irq_thread+0x10/0x10
> kernel:  kthread+0xef/0x120
> kernel:  ? __pfx_kthread+0x10/0x10
> kernel:  ret_from_fork+0x29/0x50
> kernel:  </TASK>
> kernel: ---[ end trace 0000000000000000 ]---
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217446
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>

... which should have a Fixes: tag since this is bug fix.

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#netdev-faq

Thanks,
Tony

