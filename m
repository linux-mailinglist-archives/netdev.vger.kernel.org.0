Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCC64A4DBD
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237449AbiAaSKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:10:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:61801 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232320AbiAaSKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 13:10:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643652643; x=1675188643;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GBXr7W66lbVwBC73LrQBLJ4HVtA4OpEIpyJ1EcPGblE=;
  b=lOGHRpxD/MUYf+VjL4CcCWCyspQIeLcRrKkDWirjDQX3uijpacjHtTHs
   31Tvx1Zh/nMWvQpZCvPBaEkOBh8PN1E7MTPuKwxmNt4pJVw09iP9GPexA
   dhdrnQvd3+V2OoxU+WMhhaxtE2UYZupn6K8H/v2jmRMOnC256oV23nMci
   e/jvzqq7Gbg6y7CsJz5bLU7Ar07dzhryTjl5Ry5pRyVsp3ZKVm0p3XZWR
   POII0xiGM2MHHlF6M5sjaH6MCJkO/weh2a/z7HajsXTG+f2aaIrsKHvO/
   qWTGmGzmVLbA1Mh2ak9X3yOBs+laDXE45Wqq0BTrfyPn05vyMV/FB+8Jy
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="308251217"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="308251217"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 10:10:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="626454133"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 31 Jan 2022 10:10:42 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 31 Jan 2022 10:10:41 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 31 Jan 2022 10:10:41 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 31 Jan 2022 10:10:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XoQpQiBKP0JovmCnDansUHSZlEHY9oAF+nGCxgipC83qJHRjL0sYqwp+VLZUl0qfwpAkWAd8x2kA1BVMtjCZmWQ61axzYIVeefn81Xcb9Mu66xhs8GOLxAQT5DpE+/dIfOr5DibAXHhcsNt8FIZ6LzcsKU/blKKyqN5tOX7ZdneuUqI912VtXVdv22Fg5L2bhvEWzhiNKNXI7Ij/xNl+LQhtJGq/IklOS2R5oIXDroAaq8tuODuU7icq82GmqvI4Ru+kuGNe59X35EpTcaxCRc9CUKiQc3V99lEzys43AXPdsYqkGO6wTT73CCVMa2v9OKNGA4MuNJdPpPmo5a5Uvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1JjTiHQ4WysFWcva7olUSsWdoiqgbMVUMG7Rp335fGY=;
 b=mdB/kI0NEwGcdtHFAFZebP/YwwJ7BCZ9bPUlfwgE5wDukunqgnnChU55cFG43dX5igjfkIvR3yZcJdEcWyDXqeWy3xUJCGThJQYXryoBPRW6vKQrqzURBxliMFYb2Shz1rwcl7fryQISWxqltKl9KtVRk0WQTGTiJXC/p3etBq+ODr8GUxvL/2X//iJ/lqBX3hK4RU+1V3BZVInXUnF1osjUeleWPWYfRNErrn7mFxje/eZ4yvqsuDbhmL3GNKwEiS0Qj6GcichW1ZUVs5R+IceRNu6WYw+AfUi5co9hSbike8YejTmIY5+GPhHM6MME1KiTvnPcqvhr53G/dmcjAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:6e::10)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 18:10:35 +0000
Received: from CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::44df:92e8:8706:13a3]) by CO1PR11MB4787.namprd11.prod.outlook.com
 ([fe80::44df:92e8:8706:13a3%3]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 18:10:35 +0000
Message-ID: <59052a6a-ddbe-fde5-2eab-ce90d958697c@intel.com>
Date:   Mon, 31 Jan 2022 20:10:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH net] net: e1000e: Recover at least in-memory copy of NVM
 checksum
Content-Language: en-US
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Fuxbrumer, Devora" <devora.fuxbrumer@intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20220127150807.26448-1-tbogendoerfer@suse.de>
 <d32ac7da-f460-6d7a-5f7f-9c9d873bf393@intel.com>
 <20220131164105.GA29636@alpha.franken.de>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
In-Reply-To: <20220131164105.GA29636@alpha.franken.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR10CA0010.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:89::23) To CO1PR11MB4787.namprd11.prod.outlook.com
 (2603:10b6:303:6e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90d56cee-f3cc-4f83-c48f-08d9e4e4fa12
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:EE_
X-Microsoft-Antispam-PRVS: <SN6PR11MB2606C5340155E7BAD05C0EDB97259@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: elPxS0m3oCOHJ37NkAxIF3boHy+G4P35Iipy9F8mJl2R8xtL32h1nxfmHX27ZQF3gL7AN8aEdSKfLZbwXQKotVG/WtvYwPhk6vrEIPv37HOv6+9v1oWqndcgKnSFECgIszZel7uYu9yRuec3eBKF5bsHfW5qzSD+G3DaUVjY+okp5Dqlt8axycTCUPc6QVmwPE13vzKStlPRxeiLerD6LIQ1bcOMnXRZP/PsTaBuk2AlN89zlW1FUCCFkqNxTiDflwJSTmGmQJtvAEBtKHprVhm9+UBnvgGLLspVxvm1IL608+XOqiv2QwPvyNF2ZwZcRNdg9a6+pSXjaII43h9wSuHFLrGCgcWWzITtLhEa+96bA1BU7VoIfdPgBuW098nAwuBUOrBtBWvr1VXdeNxDprvQv/TWiPPFQs8QwdEKhCEC/N2oa3Wwk66Q8ro0IQfWAtW4DvBsvTCxEOpsXcbJdoFCFM9T3rnonXgQo5TaHMDkS0djVMap3+yy3+4tsZ6IHMyG6CYkEbI2M6iuCNwcw6j0n4E9YRLgG9Uygdjppxk32rF1k2KK45hzvAJwH/BJcMg26JzNnoO2uNaOEACoqxFqBA72H6ic8XZXfKFQmnQDixZSJQHENxV2bVuz9+K9gB9xmgzrEdWpVBZ4QUsJU/rCcMr87NJFjnvbZJunWkRj/VVLM3DJ542YMz5+4bs2VDtvgM0rgaROGfRhiKafdcM23CFO9zGMqidI8Z+1Z8I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4787.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(86362001)(31696002)(82960400001)(66946007)(8936002)(66556008)(66476007)(8676002)(6666004)(5660300002)(53546011)(6512007)(4326008)(6506007)(508600001)(83380400001)(36756003)(6486002)(6916009)(54906003)(316002)(2616005)(2906002)(107886003)(186003)(26005)(31686004)(45980500001)(43740500002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEJzaTZsUlh3aFcxOUFYU1VRYmFDa3JXb1UyNVRMNnhBM0tFVW4rUUFJT2h5?=
 =?utf-8?B?VjR1N1AvUjhKWTBGQStHNEpjTkVXWnVkK0Evend1bTJYTDJEYm9aNk95b2tq?=
 =?utf-8?B?Z1VxcE5oTkM0YU9XZ2VhOGl6YzdoeklwekJncjZhUGFQN05oVytrVEE0dTU3?=
 =?utf-8?B?czVvUWV3RUNnejhmaGswYllYckozZ1hUUTVVRVRSb3J0SmFyNTIzR2NqaUVm?=
 =?utf-8?B?cmhZd0htcU1DN3RUV3djK3FKRnBGMXhIUENXeng1Qk1RaWd1UFMzM1dxZmQr?=
 =?utf-8?B?cDlZY2I0ZmdQb1hMcVIzMkxzNW9QRnY0SkMrcE8vaXF2VUp4VmtBaGFGTSty?=
 =?utf-8?B?WWRpTlhRV0RNNTdmSkVtdnBDMUZZZHcvcXdXZ1I5QzB0LzNoOUZhRTRWek5t?=
 =?utf-8?B?TTF0UnI2SVplVWdQNW5maXgvS09FdEVpbEVFZGlLYzFER3dYWnpMSHRUYnVl?=
 =?utf-8?B?TW9jQkxQeE05UWJOOURITTAxaTljMzA2UkxXeVJQMTVRUHNZaGFnOHFxZnds?=
 =?utf-8?B?TGxNM1NzRmZackhleE4vYXJQT2FrdDRpNWpmOG13elZGekZwdTFRY29sMkF1?=
 =?utf-8?B?bGd1Ulg3YmlNdWs5YUNBOC9aaENWU0pKTkRIK21Kejk3eVFRdVp1OG1qMm5O?=
 =?utf-8?B?dkQ5WFJsSXhuMGpER2NuRmlHVk9BQVVKWllEVTZxSzNNa3c4UkNrYXZ2NFF3?=
 =?utf-8?B?SEZaWm51SUx3aE40M1M1NHdZRVg1bGR0RityYUZUUXdmRElvdHZ0MVJwUk42?=
 =?utf-8?B?QWZZZmMwVFJBazdCSjgwK0puT0MzekZ6SmZHN1NCU0s3Z2dzaFd1OFF2YzFZ?=
 =?utf-8?B?NzdWQ0hyUnl3U1dEYmc2ZnBZMjhTUUtPVGFzcHd3MExTQklva2pXb0crU3p2?=
 =?utf-8?B?bGtDR0ZGMEZjcmdPZ0VDaHN3THdDNHpGU21NVzFFZlBFMmwwZmpEZjZIYU5z?=
 =?utf-8?B?L3RJT3J0VXhYejFRV2N2U0t2SzlwS1NVUjRzcHE4eUptR1BMSzg0TlhhTTEr?=
 =?utf-8?B?bG9zanlZcDFVa3ZYdmNyNTlEREc4UXlDNjR0YmZCTWE0V1pRRjdXeCs5VjFE?=
 =?utf-8?B?UkN0QTJsWlFGVWNTeXM1Q1MwdUl0TVdnNXNTOVlBejVsY1BTdGxSbk1xNDZ6?=
 =?utf-8?B?NHdxREptK2Vzenp5SzZaVFROd29lckhOd3IwUlJETklhckNHaWdlMU1pK09Z?=
 =?utf-8?B?QmRHY2JjOERUb2tiNm5QZksrdk1IU3BRQUFwK1ZyclEyeTVhVHFhTE9HTk4w?=
 =?utf-8?B?RmJtZ3VocitWZVdmOWxWSXlDRmNNdTRhTTBlaGFvc0tuOWZNS1djVHFXeTRG?=
 =?utf-8?B?VU9GcDRJcVZtYmdueVZTVmRob000YzduSDFLQ2Ztd3dOeStyS0g5SGluRlNn?=
 =?utf-8?B?K3hzcnNPVTZpUklNK2NYSk1nN2xlSlJhYUhFcmNxYjk4VlErK01GcUVJQUNs?=
 =?utf-8?B?TXhGZ1RzdVdYeVhQYkxoMytlM0o0QjNxWGJIMTlnN3NYOFA4UXRwdWp4S2FP?=
 =?utf-8?B?R2Mwclo5dUV5RURmc1BZbU5oNlpMUjhJNkpWVGhqRmJWYlM4dEZoQjllUEFE?=
 =?utf-8?B?a1FFcENzT1RRMGRMMC9VWGlHZ05oMkVITzJMTitvblphVUJvR0I2MHJIbWdq?=
 =?utf-8?B?NllNQTBwWkFwSkNWSFN2VkJsb1dBY1haZmp1bm9TenpnVk1TU1h2VHVJOEVO?=
 =?utf-8?B?aW5FejRwYXRzUUJtL0lyMVJMcTk0WWR2K3RHZHhIZUlKd1FrNDY5anpEc0h3?=
 =?utf-8?B?eWR3cFA3Sm9SQWNQQ2g5eDZBSnBkMFBtTVhPS01kUlhBSTlzaGx4NG5kOUpE?=
 =?utf-8?B?RU1xNElEenpkQmpkaytwSFdMT3pvL2R0YytDZ1ZHRFdtOUd3MGMvbFA2VTMy?=
 =?utf-8?B?ZncwMkdEdUcvZU5rMUtwV2I1RUorRXI5bWZaL04zYkVZWFlqaC80blhnMEYr?=
 =?utf-8?B?UHN2dHZzVHo0TXNEN051Tlk3bDlHSm5HSUpSc1FialgrQkx0a2lpbHBOS1ow?=
 =?utf-8?B?MlpYT2ZVd3VjcTZTNFZnNUtzY0hVQ3YvdFRmT1FvTjVYbnNJeERiNUFwaHJT?=
 =?utf-8?B?N0hSWFJwT2VveXpRQ00rU3p5bk52S3V2Q0c5MEJxd3UxbGFtNm1VNitkVXNz?=
 =?utf-8?B?eER0MEU2Z0pDMHc0RFJXNHRFeFRQc3VLQnBVbXBjbXNhNlF5WlRieUV6Ymxp?=
 =?utf-8?Q?rjq6yEnoi7y1d38XP1lM04Q=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90d56cee-f3cc-4f83-c48f-08d9e4e4fa12
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4787.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 18:10:35.1345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B2Zq414c+l0s8prMy39DrqSH8rc2dV42+3Y5Zjk4BALr9HS0raAaUNQvwM0tUFZXRiSTs90RP5YzPqd3CBZuOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/2022 18:41, Thomas Bogendoerfer wrote:
> On Mon, Jan 31, 2022 at 12:51:07PM +0200, Neftin, Sasha wrote:
>> Hello Thomas,
>> For security reasons starting from the TGL platform SPI controller will be
>> locked for SW access. I've double-checked with our HW architect, not from
>> SPT, from TGP. So, first, we can change the mac type e1000_pch_cnp to
>> e1000_pch_tgp (as fix for initial patch)
> 
> ok, that would fix the mentioned bug. Are you sending a patch for that ?
Sure. I will send patch for this and inform you
> 
>> Do we want (second) to allow HW initialization with the "wrong" NVM
>> checksum? It could cause unexpected (HW) behavior in the future. Even if you
>> will "recover" check in shadow RAM - there is no guarantee that NVM is good.
> 
> sure. Out of curiosity why is the NVM fixup there in the first place ?
It is legacy implementation (many years ago). I believe the 'main idea' 
was to allow SW to fix checksum when somehow it was computed wrongly. 
(probably recover checksum calculation bug in NVM release process)
> 
> Thomas.
> 
Sasha
