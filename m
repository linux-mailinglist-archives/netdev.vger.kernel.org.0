Return-Path: <netdev+bounces-10436-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0717E72E73C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:33:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA62F1C20365
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DA453B8D1;
	Tue, 13 Jun 2023 15:33:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A9115ADA
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 15:33:06 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42FF183
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 08:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686670384; x=1718206384;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rjV+J49fuxq6j5HcwBObcio5VUToHZrwz++TyGGMBuE=;
  b=dxtaU+F+GfxUQFP5fFBtW9kJLgS8uOmB1g8OHZA+H37uqfnGeGrwTJ5f
   cFhHx1XvSmrQASt6kPxtvQaP8X50RR8Bm358UcY1wwOXVAMnkCP5yGEEo
   upD00XRKWWKR1UhNmEMGiLm8FxFWhXaN+vvWB5AO9lwgJrmPnBXm6ya9e
   jMIyIHNs97iBp0xfKUARlPMdONdE7+1KuWmdgAv4aAOK6u5IuY4pi2ItB
   tkVbzcZzCGvrKNc60oY40StZyiklVxrdvNJDVNI8S7Nn7/cV88h2We1Yn
   UZKq5E4iVg6uxkjyerZHsJ2F2Wh12iuBG3f5DB8NdEkfWitGHRuUnJ4Wu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361738484"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="361738484"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 08:33:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="741475819"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="741475819"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 13 Jun 2023 08:33:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 08:33:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 08:33:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 08:33:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 08:32:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzH3BYArTOB7F24t0DXOnvUUz1UYQ1e/hTWdx89jbqQNTeOneaJkM9Fdqjf21IJqO/Un8J2nL8X2ldNQVaHG5vDPuN/U35RSG6/fikyPAhpFw94ymnDWW/NwnSRlDdwpdOhEtKCLJ6m24wc12azHObghGKK55NOqAgw/E16FGS5SO5s0is1zUzNzXlJ/lHM9UPCDFcctkyURUnesBBJNce9A3cmP4Py2XqCp/8lfro0Dwm5r2J7F8dTxhPEtWEs7uhJshKK1Jf4kb1zLDSmbPH43ZcNK9TD5fKeoS0WB+gcrXwpDwI5d6OEwcjM0X4zvyRWUipAy9wQaIqQJz0t+Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=prwdxLpbPhe79R8Yy60Wctj0v6SGeT/2L1hEbKc14dY=;
 b=LaIjZ1I8UW/RQsEERqqn2fr9J8RUDBcSpZUVRePSRhd1eOUftaSgJMghjV2jXushPDcXvqqFt8MdghcljN7h2a8og8vTegD61lP+a0TpaYCZt4I9v0s6ivJ8n2DqDWb77kDkGaxNZg9rJJDHh+mZ4vCqNh2D4AhJlxrcyAPPLWPhbpbpbZ2YqwFluqSKU5hQQJFcQE0fyrBR74lpYCi7eV2+Otbt0qfp+gwJUoUMR3CyTDEdH44joTUC0iKxCRbBSD7uabj+3/ziCDVQGKMmNr+rtXTAN2176mSddTp2f/D8kJqaolClIyluwb6SFYs8VGKOYA29yNEsood0rhfTQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4451.namprd11.prod.outlook.com (2603:10b6:a03:1cb::30)
 by PH7PR11MB5818.namprd11.prod.outlook.com (2603:10b6:510:132::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 13 Jun
 2023 15:32:57 +0000
Received: from BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb]) by BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb%5]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 15:32:57 +0000
Message-ID: <9ea8a985-923d-62ec-5a34-ef7eeb056f05@intel.com>
Date: Tue, 13 Jun 2023 17:32:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 3/3] ice: remove unnecessary
 check for old MAC == new MAC
Content-Language: en-US
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>, <netdev@vger.kernel.org>
CC: <pmenzel@molgen.mpg.de>, <simon.horman@corigine.com>,
	<anthony.l.nguyen@intel.com>, <kuba@kernel.org>,
	<intel-wired-lan@lists.osuosl.org>
References: <20230613122420.855486-1-piotrx.gardocki@intel.com>
 <20230613122420.855486-4-piotrx.gardocki@intel.com>
 <4db2d627-782c-90c2-4826-76b9779149ce@intel.com>
 <c9f819da-61a6-ea8f-5e16-d9aad6634127@intel.com>
 <837ccaeb-a77d-5570-1363-e5e344528f97@intel.com>
 <08b11944-984f-eeeb-4b03-777faaa3ce01@intel.com>
From: Piotr Gardocki <piotrx.gardocki@intel.com>
In-Reply-To: <08b11944-984f-eeeb-4b03-777faaa3ce01@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0064.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::12) To BY5PR11MB4451.namprd11.prod.outlook.com
 (2603:10b6:a03:1cb::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4451:EE_|PH7PR11MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: 61a55e12-5c1a-4d0c-ef90-08db6c23763e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CZ8fz3QqHWVUEQrpDqLBXZlyxzautDZwsbGus5czqBshGFESCciORCK7scMCegAh39NHSwIY8YICleZ5tRtXmHIXLSD7rn4yDdtBBYBqUtUDYR0CQiWz8Os7DtvWyUgP8OMQb1Gj+XxG9Mm5wt0E/HwBbsMypuvQSNgi99xSFlEwP9wpAkEys/qqr08YvVV8o91DYRifp5sLPn7KKVbKdomyeCEedgA5NhkTwnGpv/UbPmxUbuImZbTBlXtt+wYqq8Bthcv0c/gq62hbf0p/tc0IEVJJ5i4SFaD7GHcs0qnfHRThzkz3BL5XxruafsuAlj9nuJqfZ9owUVhiBP8y8eNHVsX6PLBt1gcPKrLjA0TSFf2CKVOiX08nsznAIPl84auwxlsp1Sm8WHDBajqV8GicdtW7sqZr8Rr63CLNNVw95BY5z8OIYTR57xX6WbrvQ9ItpH78bywPzzTZj519ITj7jxrm9XXbDPD1NXkSPWyvGcXWYX2qouqdj3IrjUiXDLszUUKME++n/ZwXB8cI5J4/Qk2ghkCoJUsG7ujluhuRgg0X0MCW11L7rCawuCvOJBhnYtWtN+O2ZUcKQM+obMOOBwnfTXcbwdgHAp6r9GrrtwcN72TgexQiccE0+aXqqrzHEsis+0qXxC1CYzve1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4451.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(376002)(366004)(39860400002)(451199021)(2906002)(36756003)(38100700002)(82960400001)(186003)(66556008)(478600001)(31696002)(4326008)(6486002)(8936002)(66476007)(2616005)(316002)(8676002)(83380400001)(41300700001)(6666004)(66946007)(6512007)(86362001)(53546011)(26005)(6506007)(5660300002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0h2cm1qbHMyenBBZXVpNmcrbDliTVhTVTNwTzVHRVlyTU1CK1Y3WC9tWHY1?=
 =?utf-8?B?WWtlZjB1a0J4WFdXVnVNUVFud1RBVlMzS1lPa1Q2N2lWUE5HVDlyU1lDU3NH?=
 =?utf-8?B?Zk1oRjJOSlEwbUVWZmJqZ0txR0JKc3psYnAvK2R0aHNhN2tlSFM0ZG4zSk5v?=
 =?utf-8?B?MXZTOEF3UUNkZFYrcVluMTJpYW9mbC8vdjN5dk10TGt1YUlhQ213dnRCY3JK?=
 =?utf-8?B?SnN4a1M3Qm1SWmc5dEc1SStxbzNndlhOeEVpY3NsM2hWUG1YZmV2Ympqb016?=
 =?utf-8?B?anUwbEZrOGozQnYxemwxSERoYlh0YW85ejdPMVE4ZVcwOCtZdHIxK2Q2aVVs?=
 =?utf-8?B?Q1BKaTZLRHdXNTBhbktVWGJNRkxjV1pWcTZDRVhYclAxZzFFdWRxTjJpVWE3?=
 =?utf-8?B?cjcra0RwWlJNcmIwanNxVVlsL2E5Ulk1bWlPUktQTWxsNjFGUjFKV0J6aXJP?=
 =?utf-8?B?NlNFNm5iUHlVcUpoVndVNzIxRVBoOFhTdUdqemI3cFZFb1J5SFAyT0VHREhk?=
 =?utf-8?B?M1N3NmdlUnhUMm5HSFpxL3AzMWxWdzhjaGZocERoOFRjWmpJOG5pR1ZZd0lF?=
 =?utf-8?B?Sm54UHBrSkFuOVNLRFM3RTNxaGVnSm4vYzlQdFM2bHFSa2NMNktIaGkvZDJU?=
 =?utf-8?B?MnJvc1lBdktTZ3pMSjhMc1BuVENHcjFtTkJjeThjcWhFSTlScGY3WWFHU1Fs?=
 =?utf-8?B?NzM3U0daSWFyeGdYK0Z1V1liSnRqWjZ5cUxIbEViUWZWL3ZOMkVqQW5ia1Jo?=
 =?utf-8?B?MGhzL1NsK1NRRm4xaUY3SGM1UU9EalhJZzJBdzFPOU45d28xNE5XTkNvSFF5?=
 =?utf-8?B?b1RDTUl6MlVqcVNzclNIbHVPdlAzK1hEYlBDRk1ObXAxamUrWUgvL1ZwOWZJ?=
 =?utf-8?B?aTFLQ1hGQ1p2SlJvUG1JVjlEYno5MzVtb3RGQ0MxWENhVHQwa0VZVGJaaGth?=
 =?utf-8?B?OHdDRXp5Y2FJbGZvMzdCcGRJZzFGQTZlVG5qL3VHN05wNkhOWW16cjM4aVYz?=
 =?utf-8?B?bXo5eHVIb3FjVWVuYVZUTHV6aStLeU9JZlBVQ1pWNElUd3crUVowRm5XR0pS?=
 =?utf-8?B?K1Q3cmxzWlZKODRyZk4yZXJRaGxGR2I4U1hQZHBqV2FEZ3BteXZ0ZkNBUXcx?=
 =?utf-8?B?bmZLQnpDSWFDbU9jQng5OGdlNWQ1QjhWdGE3N2VpK1lMY04rSUk0RFFObkpw?=
 =?utf-8?B?WGt5MzBWT3VPdEJ1c1dzY25XcmJsV1lOTlRmZFJ0Y3o0d0Qxd1o0dlMraG13?=
 =?utf-8?B?SGVqUkUyT2U3cnlJbWVLbFlhUXZHSTc0MGEwQWV0bURyek03K1BCRjEvTTl4?=
 =?utf-8?B?Z1NqQytobHVteldtNDQvaU9CSGlMUzkrQ2MxVzA5K2tzK0RNdFJFKzFDd1NR?=
 =?utf-8?B?UEN6STlUWVp3WnpPb2I5eW9xNjh2Q2FYc3FBdUllRmhFOXc3eVVrUVpxK2py?=
 =?utf-8?B?TEU0MVdySkZjdEI0cUFMdGJ0NHlzNGpqbTlRbzJidzk2M2c0Rm5qQjFkOFJ2?=
 =?utf-8?B?RmNqOC8vdkh3dnhiaUYxcXp3NkcyZFk1dDJXRkFWV2JCdUZTeEpSWlVJVUds?=
 =?utf-8?B?RU5wREMyUTdvMVdJSmFXcE54SU1HYi96bCtPR1ZBU2JBcCtSZFBGa2loZTVS?=
 =?utf-8?B?YnFLOW1NemdOajVFUXlCYWlLVnNsSE5tenpiNFlKaE5Yb1p2NW90MG90c2Nj?=
 =?utf-8?B?TG9Pc3JQYTZnRGo0Nk00MjhiMmZ0TGxpMFFxNnRvdEE1SFhBb1VVNDgwZU1Y?=
 =?utf-8?B?VWU3TWlWMWhVenR3bTVlQmw0dDRZaVlnTU9weTk1MHArRDA3L3BqR3NaZDBq?=
 =?utf-8?B?SEFWZW1SNk1BK3puWW1YV0RLMHBGa2J6S1BZZHIvd21kOGZ0SGI4ZTlaTHBU?=
 =?utf-8?B?cGRTZmU2VnFTeEZZMVNYTU1NWW1BQnJveHRiSFdjNmh0ajV3RTNDUnZHeVVi?=
 =?utf-8?B?MFZpSVlUWWNla2tVaHFKVGJ2U25kQmJ4cit4QVUxZ3ZJN1FsR3g4MmwwODZr?=
 =?utf-8?B?MVh5a0JkL2RmOWwyeEF4QmJrSE5YYjZoWHBZYTN4VDBodE93ZU9MenpySUo1?=
 =?utf-8?B?TnNGV1RjMVV3cjh4YW1QUTdCOE9Gdm0zL0VONzBYa3pqbmdlZ2JISzdpYXpF?=
 =?utf-8?B?NERwOEg2NDJOL0JITDExS0lxaDl0UWg3YzFseFhqaTJnSDkvQkdreDRDdVZ0?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a55e12-5c1a-4d0c-ef90-08db6c23763e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4451.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 15:32:56.9052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YnaQV4RqL/OYepFWzGaMST4v3W5ywyH8j40LqgGde69qvUljAQZOdFLh/xsUnpJjH++AxK4+BhRNvvJ92t8An8uTrfIKSPLFdVgKrmxmk4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5818
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 13.06.2023 17:24, Przemek Kitszel wrote:
> On 6/13/23 17:16, Piotr Gardocki wrote:
>> On 13.06.2023 17:10, Przemek Kitszel wrote:
>> [...]
>>>>
>>>> I would expect one patch that adds check in the core, then one patch that removes it in all, incl non-intel, drivers; with CC to their respective maintainers (like Tony for intel, ./scripts/get_maintainer.pl will help)
>>>
>>> I have checked, it's almost 200 handlers, which amounts to over 3500 lines of code (short-cutting analysis on eth_hw_addr_set()), what probably could warrant more than one patch/person to spread the work
>>>
>>> anybody willing to see the above code-to-look-at, or wants to re-run it for their directory of interests, here is dirty bash script (which just approximates what's to be done, but rather closely to reality):
>>>
>>>   grep -InrE '\.'ndo_set_mac_address'\s+=' |
>>>   awk '!/NULL/ {gsub(/,$/, ""); print $NF}' |
>>>   sort -u |
>>>   xargs -I% bash -c 'grep -ERwIl %'"'"'\(struct net_device.+\)$'"'"' |
>>>     xargs -I @  awk '"'"'/%\(struct net_device.+\)$/, /^}|eth_hw_addr_set\(/ { print  "@:" NR $0 }'"'"' @' |
>>> cat -n
>>>
>>> @Piotr, perhaps resolve all intel drivers in your series?
>>
>> Thanks for script, looks impressive :). Someone might really
>> use it to detect all occurrences. As you said there are a lot
>> of callbacks in kernel, so unfortunately I can't fix all of them.
>> I fixed it for drivers/net/ethernet/intel directory,
>> only i40e and ice had these checks. If you want me to check any
>> other intel directory or if I missed something here, please let
>> me know.
> 
> there is ether_addr_equal() call in iavf_set_mac(), even if not exactly before eth_hw_addr_set(), it still should be removed ;)
> 
> Anyway, I would fix all 3 drivers with one patch.

I guess you're looking at old version of dev-queue branch on Tony's tree :)
Regarding ice and i40e I made two patches to have different prefixes in titles.
I don't mind merging them, but I'll wait for someone else speaking up about this.

