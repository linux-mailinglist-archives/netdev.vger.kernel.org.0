Return-Path: <netdev+bounces-4348-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4CA070C27F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:35:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76EDF28103E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4EF314AB3;
	Mon, 22 May 2023 15:35:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD94B1427D
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 15:35:29 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83159AA;
	Mon, 22 May 2023 08:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684769728; x=1716305728;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pZgHmgwueUJssly8c+X+QdeFenxgZjPmTHYdpkkNtow=;
  b=UzpfljgKimaC+VJ5Dewb+bqBmxvuqml0nPKnShCVTL3CFBTKpTKOEwPx
   2eafor78WJxFn2K8huWOJbbi3xqK6hN4g1DmOQHZR7vAPBzGi3lN1+zfL
   jenRHytt4opRJRF9PfLLVm8o8Z1T/4V6xGjCzVto/DNbvljP1/Ef09Kne
   3mzRLVA4k/0NR9F6doGMpJCDeFFsZxTRehtpfT0iNbp1oTqq0qoQEwVPQ
   3c88K/p3exQSlAYEgMvmkWKRKld93NANC+PpmSntAmtMylD/OqKFmhb1m
   z3fvseS4ysAnOiuovXtS1X6FlkvPrxECPWDD/gBNlRYRWmjGO3hGBCSP6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="355303044"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="355303044"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 08:35:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="773405932"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="773405932"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2023 08:34:10 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 08:34:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 08:34:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 08:34:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 08:34:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+4tcfs375+Hv3N5RgHukbZAf7H8zMWK6ylIweG43jXpNtQNvCGhf6u6hqh+0hi43xnbvDB9RtZr7qQRvD/RfGdG7MyoHP+qSBWX4ZXRS2ys2e+mJqfvlRzPsR49drOxnGEgMmz/NAnbUeNDzoRFsCZj4qmpeMuc5SAh4VwjLEgP+r9jbXxc6c/n1S+S3LAQFOe4eJvKRIdvenYptdtzaaWxgG+sPAjWe2/RLTzwlccOjvkpqQv8b5pDsKpWaHesiXY3egY+N0eA2gdrbyBKaDTl4ygfwvyfm/xQb38WfDMTmwt9caf6DglG5N0JKqmihtQ2BRXr2WUjJScl41qDew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0aXD3dgusfU16YgKAL9nyLxGHMJDVPMclK7HeJJIM8c=;
 b=HhAdY2y5aT+4u5xrzZIjWlfFeJ8Jim7t4TASZieT1yXltI52ZGwqX8xbawDDb/08kb6F5ECz3k2SL1+/tD5exlVQgf/4ikPAfoPBPecFx61kD8USjjXhRUHgMIKu3JYXqX/nD8Rcg3XUtwNg0Ri+T5wt2HNKgMIZNkHM8irkGlcaHX86xZyCEMiQmdWC+dZgyXQvCgXJ9LvqHWKvbQcaziRahXh8xvvgYoVtphLAAKMmdB++McQQSRXy+5x0OR7rmsIwZABgv9uAWVT6GUP5wSDL/CT6JIF7qhWBE7ep7i34qEFlnXmLOulKR+L/3DVjvpRYEUNcLKUFQBO0Bk+nkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB8569.namprd11.prod.outlook.com (2603:10b6:510:304::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 15:34:06 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 15:34:06 +0000
Message-ID: <74679c26-19b1-65fc-a986-8b4a20794327@intel.com>
Date: Mon, 22 May 2023 17:32:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [Intel-wired-lan] [PATCH net-next 10/11] libie: add per-queue
 Page Pool stats
Content-Language: en-US
To: Paul Menzel <pmenzel@molgen.mpg.de>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jesper Dangaard Brouer <hawk@kernel.org>, Larysa Zaremba
	<larysa.zaremba@intel.com>, <netdev@vger.kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, <linux-kernel@vger.kernel.org>, Michal Kubiak
	<michal.kubiak@intel.com>, <intel-wired-lan@lists.osuosl.org>, "Christoph
 Hellwig" <hch@lst.de>, Magnus Karlsson <magnus.karlsson@intel.com>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
 <20230516161841.37138-11-aleksander.lobakin@intel.com>
 <6bebe582-705c-2b7a-3286-1c86a15619f2@molgen.mpg.de>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <6bebe582-705c-2b7a-3286-1c86a15619f2@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0173.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::28) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB8569:EE_
X-MS-Office365-Filtering-Correlation-Id: 67d35398-f093-4cc1-1654-08db5ad9fa4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X+OE9gWDL5XzMgm7xBdrp38yMlsW32VNnAwncTl+ep7JG5WTKayXbCkINBnCtKPCuzGqyq2mFnKVXI1woPUOdo+KHVTTZyqeTeIZconvw2ZhIoDiefMr47Qf3i+LdvxvvkUpJSW8dq6MGyiiarllRman+REuWaQABiIRfH8LbxCEgYZDbzb0rpw8oCTKCYgQeiAlSaSNtSu1VMlWtOqXwRn08BHCAjmOvLz+FGvAuWtbjSGSxCr0TAhGqUEzLOphaeA0cMnHX9kOS3UIOjIbXm4HikNPA0ux3tHpYS9KYy6DSXRC1gWpNULpQgj7cpciQUTOWBz9LaC3zNvrnjLbCySr+7bk7ZFSKBiF9AK/KRsVorDgTK3q73hjeUpUh1gb+WHZD0uKP7Z6uB2n/7baALuwv3Qjp6FmTPf8+Dv/wRq5FabayM1V5cTvCfU7r+KN3hIs2U2AUKOQPcNW+XcW2QKPx9GnmQkB4VZShuTrVxyCBj3T4a0ZU+RQkf8BJtIKGO7Z96mitLHRjSMKl5Hxngyfu+RfjtZZ/FlqmZsaYpgPewLC4JAfRwn4VF/MPE3P/g5OYEhZohl6Brpds8T0+dnECp1Hbmw0FsaUzexOkNxNkoDcCEDz/uT6L7j7hPslYQEbEe4VrwzNPjua6p1VDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199021)(38100700002)(82960400001)(86362001)(31696002)(36756003)(31686004)(8676002)(8936002)(7416002)(107886003)(5660300002)(6512007)(26005)(6506007)(2616005)(186003)(83380400001)(2906002)(41300700001)(6486002)(316002)(6666004)(66476007)(66946007)(66556008)(54906003)(478600001)(6916009)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjZvWHVBbnNOVGNHL2d3Z2FqMElvMngzZXExQjRWdlhKWE9BL2d3N3dVdzlt?=
 =?utf-8?B?WVRiWGkyM08wZTNmRUxLQTZsbldDUzBYaVFNeFpTV2JvbmNORG5ISjYxVGMw?=
 =?utf-8?B?VzUwcnZKMjBZMDB5SGJCNnFhYkZuWGpkWDJDdW10ZHB1ekxXbmw3bjBHZVR2?=
 =?utf-8?B?MXBYaEJ6endNQW1CUnVmQXpsOWtTUHRURFlUemVOSHhQNXpIQkl6aWpDVTNC?=
 =?utf-8?B?My9QL1BwMXVwaEVjTHpkZ3lhNUExZTJIVUNxUlk5N21Hb1Jnd3FuRGtiUXNI?=
 =?utf-8?B?UE5HWmp1K0dRZHZCS2Y4d09aUWJRWWdCaFl1bm1NbXhwc1hhc1FWRWh0bVI3?=
 =?utf-8?B?Q0hCSGtpOXRyWXAxZkt0OHpLTWUzV2lnMlR0K0gveGw0eUUwb2JVRHlSZnZY?=
 =?utf-8?B?bm0vL01jVCt4emlva2tiQ2dmZDVFOENGNnRSTlFXT0NJRklFV0xhVysyTnV0?=
 =?utf-8?B?Q1hNcWt6Z0dLb0JIRndrdVNaWGlhUDcySDNhZkw2Ykd5M1paaVczc3JIaHYx?=
 =?utf-8?B?d1lhOGFEOU5WeVQ5aDV2TERFd2o4U0FneTI5SW5zN2srYVNrM0NWZmVkQWVz?=
 =?utf-8?B?M1pndWRWeFJ3V3dtbHpyU2szYzdCbFpnRHFZVC9jS1UzN0QrbFpnRndLUmZi?=
 =?utf-8?B?YnRkMitKcDdlZGdtT1dlSjd5b1R0YWZFR0JlOGtUUEptTkx1T3VQenhzSk5x?=
 =?utf-8?B?UUgxTTcvRTRGUVBtRCtuVlNzbUo0a21GREd2UzdPVDBjMkFzdmlMUWFVSlNt?=
 =?utf-8?B?alJhN0JLRzJBWE03T0p2S3NqMmY5K1IwcW5GOE9mVmwvcWpvSVJ0N01aTkt6?=
 =?utf-8?B?QjRtdVZURDBPdWkwNFRKbUdXNzMxdnJ4U2twWGQzZS8zUmFzVmZ6MHdGczUy?=
 =?utf-8?B?cmoyWURIUEwvQklla2YzbllkbWZXMElpOUgrRGpkakM0NlRrTTVXUWgyOURa?=
 =?utf-8?B?ejl6QUlUU2FKb2Q1NmpxSmdnODI0UzNWa01qQWYvOHZkQjlxbU1vd0RvMzJN?=
 =?utf-8?B?YWhrdG5VOGs1bUxDTXhNMVdxVXpYcHZqSmtVNmlwMUFwK2RULy9DYmJxYUZL?=
 =?utf-8?B?aksvTVZKUTJOYVlLTUJZMHZaNHM4L3VScVJGbGRIeTFXMU50ZXp4WUJpaVZ2?=
 =?utf-8?B?VGZlSGFxNGpURHpiTHRxWlZFU1Z0RWw2eEFLanBpM3Y1aFUrR0hpaFQwdWVH?=
 =?utf-8?B?eDdmWTZ2emhDUFdsKy9BbUlNdkhMWE82ZndyMm5DVnVDUUV0azRubm9USzJ2?=
 =?utf-8?B?ZkpnTXB5Y3pYeVpHWnpXS0s4YTljUkdhME92ZkV5V01WbjJCWkNvTlJSalNt?=
 =?utf-8?B?MEVRTmtUaWxQS3lWOHMvLzZOMlVVb25rMGRRQ1oya3Mwc1JwZjF4YWdZelcy?=
 =?utf-8?B?aUtWd3JtSklzSEtuRHJNQWphb25Tc280b0svZ09ZcThSV0g0SFFMK1NndzdD?=
 =?utf-8?B?dDZtVUVJSUxCbTNwSlVSWnBvcXowS3VhMXlmcjJHVENxdXRZQ2lqV3VVVDBo?=
 =?utf-8?B?TzRoRHNvTGt6UU1iNzByWFUyLy96MjNaUG00MEFacitZdjdLTHFDb1pZTnc3?=
 =?utf-8?B?RlZGSFAwMVNhQlJFekxyRFNSTjRwd1pwdnhROVZGZ3ZEVURJKzdUT1QzMWYx?=
 =?utf-8?B?czQrNjZvVW1PYkwxdGZoU2RiRnRNVTh4eHNrWWZ1RlZxbFVNamhISHI1TlRp?=
 =?utf-8?B?WHRGSUFYWFpPZTRlMEhUakV0a3pnUFp1ZTVUb1RveXFKOHh6cnRKcFJTQWFh?=
 =?utf-8?B?TDdRa2JJaUtUYyt0c3BYeXpxQk1DUi8vRGtIK2hVQVJtak1xVElBVGlzTUFn?=
 =?utf-8?B?MldvbERJMUV6T2tkdDVTSWIzdGFJeGtMcTl5NmV5UVIycDNHNmJsaFRhcW9U?=
 =?utf-8?B?N2JtckpCeFNFMk9rcnFQZzZFTlRORWJIWjBNV0NObEcyZFRIbmZRcjJLUDN2?=
 =?utf-8?B?RWZ4REw2NDFlWVBCbHM4Nkd0RWpIRHNWUnJHS0I5R1B2d1hDR0pUck1uUWZ1?=
 =?utf-8?B?VHZlQ21tOWVPS2NrSVVqQTdYYVErQWlmR3IvOGJBZVBqYkk2eFlNOEhkaFVt?=
 =?utf-8?B?b094ZE9NdnMyUmlsRU9xb3JFQWlyMkdsaUhrR3hjT0lldGw0WUMyMXhJdUhh?=
 =?utf-8?B?VjhjQ3VEK0pKUEZQWElKSU83amJuaXJCNFpxQUpTVFg4bXA5b1o3WkFEbVRK?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d35398-f093-4cc1-1654-08db5ad9fa4d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 15:34:05.8778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Nan0X2Ip+1WfSIY/ERixJfYp47Ho05Ft4JuXI1wLuuuyT51qcRRWwHIaicB+kibXQSp9c31j4ADJjPYEIfmBy3cC96gbgRRIzfXpmtXBUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8569
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Paul Menzel <pmenzel@molgen.mpg.de>
Date: Mon, 22 May 2023 17:05:28 +0200

> Dear Alexander,
> 
> 
> Thank you for your patch.
> 
> Am 16.05.23 um 18:18 schrieb Alexander Lobakin:
>> Expand the libie generic per-queue stats with the generic Page Pool
>> stats provided by the API itself, when CONFIG_PAGE_POOL is enable.
> 
> enable*d*

Oof, nice catch, thanks! I rely on codespell and checkpatch too much,
but from standalone-word-spelling PoV everything is fine here :s :D

> 
>> When it's not, there'll be no such fields in the stats structure, so
>> no space wasted.
>> They are also a bit special in terms of how they are obtained. One
>> &page_pool accumulates statistics until it's destroyed obviously,
>> which happens on ifdown. So, in order to not lose any statistics,
>> get the stats and store in the queue container before destroying
>> a pool. This container survives ifups/downs, so it basically stores
>> the statistics accumulated since the very first pool was allocated
>> on this queue. When it's needed to export the stats, first get the
>> numbers from this container and then add the "live" numbers -- the
>> ones that the current active pool returns. The result values will
>> always represent the actual device-lifetime* stats.
>> There's a cast from &page_pool_stats to `u64 *` in a couple functions,
>> but they are guarded with stats asserts to make sure it's safe to do.
>> FWIW it saves a lot of object code.

[...]

> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
> 
> 
> Kind regards,
> 
> Paul

Thanks,
Olek

