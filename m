Return-Path: <netdev+bounces-10433-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6F6072E6E0
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:17:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80A14280DDC
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:17:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1FB33AE7E;
	Tue, 13 Jun 2023 15:17:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52BA38CDA
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 15:17:12 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B29DD2
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 08:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686669431; x=1718205431;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j0nP+w4T65XThR5Dl6/kmQ9EGQuYEedYxhIKYu9MF+8=;
  b=PyUQZgMQhf7UJAurWdouOJnw+Wpk9oKuL6vqJOMN/wtVhPt/ntFfeEbs
   quCl4b/mKIYpUVGz6Dgzr6K9CbgBzm1zVU3drpNSZ+E4L3DWyagNs2TvW
   xjD2A2C79T5UYiJgQEoBz2RognG2TXOpYus1D7cOu4T+qp4v4s1mjmecU
   WvRSzs4c6Pfe2YZcGMx067DeKyZK1za5PEvyt1pePdrok9j9GkLBkCaue
   mebWIS117Kspv5ynnNhLzcnpYWvY+oyY+xoCl3zMIy0CWB8V3mi+Xhpl9
   LqxYZ+2uAQ3rO2w8E9cI/E8P8RTpefLYMPRen2Z65nzuDYraKxk5MIWi1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="421958803"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="421958803"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 08:17:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="744726582"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="744726582"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 13 Jun 2023 08:17:04 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 08:17:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 08:17:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 08:17:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I31AssNxfT2Jjgh8yu9Truz+Wd7a7F1qQASpw9E1CniIhfAsCHBHnwZq5OTeWgVMwQFWbG8PpU6tJS+zalY4KrCtCk9gX+7B59dRVNyCLQM6cSFWDK+h6/M68m2hHPBIKwjvBvml0J/pNKP9mq6a/GoiCMKNaGhgwv4l52hVodCDOXIcb02/qQLA2vyMEYBhY5qFpnAbKt9db2nwA8xbvxbUvKUe5RIQB9Y+xg19Bd5JDM+uXTY8N7nWlRFFiNQuX2t4DCJ2xWH5QSVtSHoy7cKldGf+tdOP/sSdTduosUnywQAgxJ4ZAje02knWBUaR/fzz747z+xBM7Vv26rWv3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Mkyu/9FypSr/qZ8dX65odNBWLd8cTaID3nyLdcLlbg=;
 b=adnGzsVK2Ly+GwJ9x1fP7X2b+ipPPJEqEiA8Tl7WvAeSxUaXgl7ecrAlaiX49zbdKqjL9fGrOtsswkBKgBfYWGKO6XLqAJRd2bsLi1WTY5h6ib4HghGZgnHOIEVoC2l472r1wbS/PEhZ8C8lMikwono1X92NZYWRwBoaFuRVnN9ZBZK6vm+unc6s+NBY8lROqWPQgnbFrurt5p/U8qmz/zbYRX6spGqK9LlLlksGvWbAtg4JiILOk6nyKxVOHcuBa0SndOrLtd/FQBpDMdCDsjIw0pytUcJhGaSmjNcOMNtYWzka8lIu6soVp1/DModp70hVLIxR9PhShMSRg1VQRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4451.namprd11.prod.outlook.com (2603:10b6:a03:1cb::30)
 by SA0PR11MB4605.namprd11.prod.outlook.com (2603:10b6:806:95::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 15:17:00 +0000
Received: from BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb]) by BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb%5]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 15:17:00 +0000
Message-ID: <837ccaeb-a77d-5570-1363-e5e344528f97@intel.com>
Date: Tue, 13 Jun 2023 17:16:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 3/3] ice: remove unnecessary
 check for old MAC == new MAC
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>, <netdev@vger.kernel.org>
CC: <pmenzel@molgen.mpg.de>, <simon.horman@corigine.com>,
	<anthony.l.nguyen@intel.com>, <kuba@kernel.org>,
	<intel-wired-lan@lists.osuosl.org>
References: <20230613122420.855486-1-piotrx.gardocki@intel.com>
 <20230613122420.855486-4-piotrx.gardocki@intel.com>
 <4db2d627-782c-90c2-4826-76b9779149ce@intel.com>
 <c9f819da-61a6-ea8f-5e16-d9aad6634127@intel.com>
Content-Language: en-US
From: Piotr Gardocki <piotrx.gardocki@intel.com>
In-Reply-To: <c9f819da-61a6-ea8f-5e16-d9aad6634127@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0245.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::17) To BY5PR11MB4451.namprd11.prod.outlook.com
 (2603:10b6:a03:1cb::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4451:EE_|SA0PR11MB4605:EE_
X-MS-Office365-Filtering-Correlation-Id: cd7094cc-9094-400d-4d46-08db6c213c36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z3EJ8VW55IFlw65RM5X9kgZmAa97/dUYFAVsA0DxMMLARBlQCQ+30oXpfLn7O7lv2MsH15Bkny+Z7GGIlP1rDUuSsYAYUfLGcNWujCB4bNc4MHYESLyBVJUcHWXY62J52hmbuGIzL4ZN3nNGceX9LDnWJO9CtKrhg0HhACyBgd1oZDspVslFyblzcHtCH3FsFO+iz+T6mfbdIhj0IcRYcER6MbiKfHW+oy30lT2/U23oaKZz5igVZ9/nRie5a6VOF3yqrs2h8MQZnXfnxAaY2SxKDlQTnpGXZFQ6N6Hukd8fLLIHQyJiw5acLhKudMruArXX0JQVFCUFQDkZ2vf7o3mc8uGva98OmWhIlC/C2xZanXlSk1WFwSjh1YPBISeGwF2p5qXjiNO9gOQVbchO4JtcoZMKKJhfmG80vxW7+mfx8jQG81VWlbmncycM1m74PWosTM+NpIC9MR7lB88u4Cs28223PHKZACqaENUGcAnq3sFabeGBw5ru2ZlpKsLVNHHJgJ1zlx/fQEP33keF+ahlN34lGgnKDsg8j3GHs/ITE/0w8KsUIvVieNaCICKzEE8vgr0RVVmukuT18Gze+6DR+KHiSxVkCmTJIrRafuW1G2LV3O0UoCyCIWrqD7RPkV/F7XEf3IFo9qaaSGPO2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4451.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199021)(2616005)(83380400001)(82960400001)(86362001)(36756003)(38100700002)(31696002)(478600001)(4326008)(6666004)(6486002)(8936002)(2906002)(8676002)(5660300002)(66476007)(66556008)(66946007)(31686004)(41300700001)(316002)(53546011)(186003)(6506007)(6512007)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cG9YS0dwQmNvTENWUUNzemZGTVAwWnZmS1VNVURvRDJ2dFAxd3UrNFpWSys2?=
 =?utf-8?B?VndCdU5xekVaSncwaGxrSWV4cVJZb1FvTEtXdjRHOXBMOFpEMmJKOVZ6N3Yw?=
 =?utf-8?B?dFNHdzUxN1FrZEJNRGFrUUx4Q0xvR2VmK2V3eFF2aFM4djBnK2JMckJLYWRO?=
 =?utf-8?B?WlhWdWd6SEtUMjNxdU1OVDhRWHNqakpyVWJzRXorbHVXKzRabG9ZK1F1TlBU?=
 =?utf-8?B?ak9xWm9zR2tDR0NnSGFCUTBzS0lHT1lDRmRmVTIrNWUzTnR3MDl0TWlldVov?=
 =?utf-8?B?WFJhaVVWakprRGJFNTFZWG56L0tUYzRHcHVVem5rS2V1TjJjd01uNTVTZENF?=
 =?utf-8?B?T3ZhVEp1cGpGR3ZBaG1ocy9DSjZmUmV6T3RNRVZ4MHMyRStOdThUM3EyRUtk?=
 =?utf-8?B?S2svcE9lMWxoVklLQkZEaEZZY01jWXcydzUzUjZHV29QTzBrS0o0eHFpMmtp?=
 =?utf-8?B?ZnNYRWF6aDhmWUZ0Q2g1eGt3dkFFNmNsM3p1cmNVeDdaNytKV3NnTE8xenBr?=
 =?utf-8?B?dWF4ZkxYQmJaKzQ3NmowMHRMOHBCWTFSZVVodmJINjhtMW1tUjdwb1N5VGZE?=
 =?utf-8?B?QjQreks2QzBJZVNGOW4wdFJsaGp6Vk4zK2dHVEJFZElvZnFmWDhGUi9uelVk?=
 =?utf-8?B?YjJlSk9wenl4U2NqMm1kaTNSUjNkMnI0MllTaGl5WHBDL0hKL2FnbEFuLzBz?=
 =?utf-8?B?MkVmL2RVaTBLMjNGL0VacUxoRHNkckk3TWNtSVpFbUJQTWJrejI3UFVhU1Zk?=
 =?utf-8?B?UGhBRUFqdDJHbWh4R0JkTEJMNi94SjNva2Z4cFRqcEkzMXVib2c2OWxsYVlM?=
 =?utf-8?B?RG9RdjNIRURwRE5lbnM2VmhETWQvRy96YlRsblRkditUYzNDeTJFenAxdHVu?=
 =?utf-8?B?ai83R1BTc0J1OVRESnZRMWtsZkh0d2EwRG5nT241aFpXSzVuQWczTVlnU1hF?=
 =?utf-8?B?Z0Fjc0tkZUUrbXhkbVVaVXBpYTVzUHhTemc1Q3ZrMDlvek9NajAybVNySE01?=
 =?utf-8?B?RTdRUDhFQnF2UjhSUG9jYVlxdVNveUVlN0prY1pHbUgwTEFXekRzUUllbjV0?=
 =?utf-8?B?UDNmWW80VW0yeThBd1ZHWlJJbWF3TXU1aFozMktKdlczdFNTUE5lS3dyKzZy?=
 =?utf-8?B?K0l2Y2RIME5GRmdpaTAyMEJkdHBCMGVzbWhUcjB5YkJKZWI3bjFQK0pGUi9I?=
 =?utf-8?B?Z3RFWE9GZ3A4bzJWamgvOUxNM1lEOFRQNXdQeG5hTWkxc0YzMU55QnBZYTBI?=
 =?utf-8?B?allWWDdFMGJSZHhvR3B6c1AwZzQrWHJLaWhuN2crYldHamxwZW1tNnc1QWVM?=
 =?utf-8?B?MVdtTTJPL3dMRUJJUnFmeFhyYTA0OW1OOHMxZFRkdEpGczhHbHNhZytIam14?=
 =?utf-8?B?RVV5QzZhdTJDTmFRRUN3LzBqYWxLYUx6b2s2YXZBMnJzQ3ZRcnV6YS9aL2x2?=
 =?utf-8?B?ZU9DeHNFT3BXRjhLMjRzNGI0WlFPNEJQVnF1NTM5b2JNREx4dHM3bDAza05D?=
 =?utf-8?B?amRKaTM3aEpDaHVHZVRxTWZBSTNwUDNvQzVoTWRGV216azlBSzRTcWpEOXVv?=
 =?utf-8?B?UXBrZHp3QUtmVy9HUUpaRVgvYWxWRjN1U1hUOU8yTi95Q0pYVG81VHIybkN0?=
 =?utf-8?B?dDUrbDFLZkNEclp3ZnU5ZnczUGxBQ2lld1FiS25FTWtraW5RVGFna1FvNFlr?=
 =?utf-8?B?V1lsVDNnQ1FFR1JUWDZVN0RNSGM0ZDlSdWJUcktFR2d2L1FaM1N3dEs5bTI1?=
 =?utf-8?B?MlJwR1VBd2F0VFRsaEZUR2sxZnMyV1lrWGs4bXhrdTJ0cnA0K3VTZkFGcXFJ?=
 =?utf-8?B?NkNmWDZXSzlvZTcwZllyMHpFYkozVnN3dFNRWC9ETC9JZ3NiNE4zYXB5RExv?=
 =?utf-8?B?REVQaVJDV0tlVFRIRmhrQXJVMlBhMm9NOUxiSnBNeG9TRG9VUUVySUN3WjJv?=
 =?utf-8?B?Vy9GclFiNjRJdzcvWmZVdFBMb251VnJMUEo5dWlsRXUwbGxCYVY0RThLZnFR?=
 =?utf-8?B?dWZwL3FscDA5Q05ibnN6K0g0MkljNENaeWdUSWFBakRYb0sxcUZpSXE3Tkh1?=
 =?utf-8?B?MGpHMGV1UktSYkRoc0U3RFpCTW9LSzJ1NC9WL2VNY3gwL3NzOXY2cFM5MFpz?=
 =?utf-8?B?RUtpQ0Vuamg0dXdSaEszaU1VNHNzSkQva1kxNnFsTUZEN3dFbjZ2SGd5UkVE?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7094cc-9094-400d-4d46-08db6c213c36
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4451.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 15:17:00.5487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xiPnqFO7DDEqubjgDTnMuNdeqhV8icVZkcjb8+hEWikUAyIeiKimUDX0cy53msMkv+IsXBBd7MLFr1bAMhrYdJbg//zRtYk73ydHVKVOuO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4605
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 13.06.2023 17:10, Przemek Kitszel wrote:
[...]
>>
>> I would expect one patch that adds check in the core, then one patch that removes it in all, incl non-intel, drivers; with CC to their respective maintainers (like Tony for intel, ./scripts/get_maintainer.pl will help)
> 
> I have checked, it's almost 200 handlers, which amounts to over 3500 lines of code (short-cutting analysis on eth_hw_addr_set()), what probably could warrant more than one patch/person to spread the work
> 
> anybody willing to see the above code-to-look-at, or wants to re-run it for their directory of interests, here is dirty bash script (which just approximates what's to be done, but rather closely to reality):
> 
>  grep -InrE '\.'ndo_set_mac_address'\s+=' |
>  awk '!/NULL/ {gsub(/,$/, ""); print $NF}' |
>  sort -u |
>  xargs -I% bash -c 'grep -ERwIl %'"'"'\(struct net_device.+\)$'"'"' |
>    xargs -I @  awk '"'"'/%\(struct net_device.+\)$/, /^}|eth_hw_addr_set\(/ { print  "@:" NR $0 }'"'"' @' |
> cat -n
> 
> @Piotr, perhaps resolve all intel drivers in your series?

Thanks for script, looks impressive :). Someone might really
use it to detect all occurrences. As you said there are a lot
of callbacks in kernel, so unfortunately I can't fix all of them.
I fixed it for drivers/net/ethernet/intel directory,
only i40e and ice had these checks. If you want me to check any
other intel directory or if I missed something here, please let
me know.

