Return-Path: <netdev+bounces-7485-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45483720739
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:17:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72EE5281934
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954151C75C;
	Fri,  2 Jun 2023 16:17:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812D61B8FE
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:17:02 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0BDD3;
	Fri,  2 Jun 2023 09:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685722611; x=1717258611;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZaFcI7Q0gamIyzVbr9zmaHAn2Jiytdin3HKTYjKIDr0=;
  b=RAmLj09CIr3Ohb+lULZx8OHvKJK+IvzYgWsTA1UkyrJs1k56ZbUHBfMu
   aSIbZRBeb9iLDEMuJXN4ynprh2iYg5m+Fq3CHx4TMINd9uPJunRBQDb+Q
   aEn98i9PQUk8CgUluB8wOhQTDJmGSdJMo/+XMcafnLBuh/gRJ3ZOa6fO6
   bpqJF+BLyamwNbA0M2A6fcBUC3doIROk00zp/tdb+CS0FQL6KAeraLtCD
   7dRVSD7+n7SsI5ecc70RccGRVwh/ok+di1sgT8VJ5jZ9TUo/SjYDZnI+u
   CAkkYkourPsKEHB4MABMABAYqicWL6y/LrRzyoBQAnXPiha5saXa5mxYs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="358337816"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="358337816"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 09:16:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="820345242"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="820345242"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 02 Jun 2023 09:16:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 2 Jun 2023 09:16:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 2 Jun 2023 09:16:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 2 Jun 2023 09:16:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 2 Jun 2023 09:16:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZqiUwedmYtUm13O5uWTH7sEAtEW7ZO68u9x5VMlIghNg5Vx4aHQDBhjRe8rPq2M/GDCWBXJp798Bf1VWaRc2MqwpNcXJjxFWWu8GTFEAp1eOnhDs2nSDSEXaDf2aS1KnxekBjPgEsJUYWk0o+V6ZxOrefZzN3sptSBxXpBgJsybJPlBr3nGJWp32v4CRWkW9e/WPMHoMxQXY6gturPph4356dBh7KMRdjQCKyBxONBLcEPmvZEPqcp9DffQhI/G1nQFl55SnUdWyom+KvMYrCPHpGhQH4GdZhGLRM65biVU9K2WLphTF8CqeGDNLgxWNfs0c2F8ti0zmFA86q8nrdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AU0vseKYY1yI/deY0sVFOIp0BralLIdzdIuQEMbn3w0=;
 b=Qby+7Hirjmiz7c7uK8lARJlWl80Yl3wlQ0F8lIaPBYmSQpPrgU5N16pH/nQhgdnk8kCC4mhHLazIIARtW2jOd8mdRup2A5T7xPFl4qHhVFP8JdqpJfgPpURoyMsdPBXWUq6H1vXVsvp1J237bpz/tK4g0zc6jxR03IlBvqdBZr5xrntzedS07jlB62VLvBP+dLGpXAwQchKsQ0BKFbMNHZlpe5YGbiTV8wRgOZcAMxTQWq29oXwaf8iOKBf1gx9+8noF9FIehHbOFOG69SKyxVlf11pk3nxp2TWFs2ue6FGJ/TssUtfghamzyIMnR6RMR+OEIz4U+GosVN5OjfRM7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ0PR11MB5120.namprd11.prod.outlook.com (2603:10b6:a03:2d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.26; Fri, 2 Jun
 2023 16:16:23 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.024; Fri, 2 Jun 2023
 16:16:23 +0000
Message-ID: <cd88ac7e-fe82-fdc0-3410-0decf57d3c43@intel.com>
Date: Fri, 2 Jun 2023 18:15:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 03/12] iavf: optimize Rx
 buffer allocation a bunch
Content-Language: en-US
To: Alexander Duyck <alexander.duyck@gmail.com>
CC: Paul Menzel <pmenzel@molgen.mpg.de>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Larysa Zaremba <larysa.zaremba@intel.com>,
	<netdev@vger.kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	<linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Michal Kubiak <michal.kubiak@intel.com>,
	<intel-wired-lan@lists.osuosl.org>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Christoph Hellwig <hch@lst.de>, Magnus Karlsson
	<magnus.karlsson@intel.com>
References: <20230525125746.553874-1-aleksander.lobakin@intel.com>
 <20230525125746.553874-4-aleksander.lobakin@intel.com>
 <8828262f1c238ab28be9ec87a7701acd791af926.camel@gmail.com>
 <cb7d3479-63a5-31b4-355d-b12a7e1b2878@intel.com>
 <CAKgT0Ud204CiJeB-5zcTKdrv7ODrfP09t73CqRhps7g3qhWU5w@mail.gmail.com>
 <d375fef9-43c4-9f2a-41c9-5247fcb3aa1e@intel.com>
 <CAKgT0Uc4UQ=PpVtjUAP=hjTDrWWkc79PeSwp39T6MSpo1ZyOag@mail.gmail.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <CAKgT0Uc4UQ=PpVtjUAP=hjTDrWWkc79PeSwp39T6MSpo1ZyOag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0158.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::11) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ0PR11MB5120:EE_
X-MS-Office365-Filtering-Correlation-Id: 026ba02e-06fd-48a0-75c4-08db6384b4ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RopMLUlmr3KVaHCEDmYYPhACT6tcOcnttyDJX6Iyp1ebPDY7xtzJz6hQEHqJBR0yGJWozEndivN5hHTfYt+9P6AI0l86WKnsUQDlTq+fgyLlbbru0wJv03bwI7bR+bv9GY49cNHjRxi/4Xh1NAiCeKJAGSa5SeauZgqehObHbgZm79SuMnfN9LU/3piQ1olLd1SoOZxmGCEjY+wpzXnVr3phqoW9jLClR53BfJXZjTbYGhTDMcKcWBVEWkih+47ZlnDko2rZJdvRrIEww7fRxl/r0RyXyNTQiuYjMnj/SWH5Y8AtYAhGO3MkK1FEKx8FB9x/JPGKaRziJEW0jTM4vGA3GtFi0I5pxTGIQcWw3RkX73RVgFhot0ZyWK9hIIagbwMAGuL0b67CBaXUyE1Dw2kU6/YNysAXr66+00Zfk6w4Lx7nVBV7mNO9hhx/SwD9a54Wszx8gcK31g06vDCbmQuU1+g1J/yzlFwsL72cMIMb2wJd27CBlnqhv5earDKOnSTx8VQrnmEnmmLTmjsAWurb9G0VGZwkc8/TV938bn9dsYX0tdwX8pA4fow9k0rqWsQYM1iEdDoKhKbfnsQNL7GeWZ6NGgnMbcR77J5/o4055fMkZKpd9miaQ2haqeNE4AjPxJxCI6opuhNudB9zcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199021)(54906003)(5660300002)(8676002)(8936002)(478600001)(41300700001)(6486002)(86362001)(6666004)(316002)(4326008)(6916009)(53546011)(186003)(7416002)(107886003)(31686004)(66946007)(66476007)(66556008)(6506007)(26005)(31696002)(6512007)(2616005)(2906002)(83380400001)(36756003)(38100700002)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGY0bEdoRkk2THVVY09PTktGVisrRGgwZ0xScnJZZmhrbjkzM09ZbmJVb01J?=
 =?utf-8?B?bHRSV3JwSDRIZ1ptRzJPZ0ZmM3NjNFgwQi91RG5RdURlWTlIQ1MwdjAva1RB?=
 =?utf-8?B?bllTdDJoOGdwU0MvRTdvMUNZUU5KTmg2N1U1ZlZnL3h1eGtCWEZnTVh0S1hK?=
 =?utf-8?B?UWw1S3JSZnczZ0dkMmc0aERxZDBmaTRacldCa0Y3SHFNUm1RbzhoNmtjTkVQ?=
 =?utf-8?B?SmliYjdMKzhYNEZ0Smk2bmUrYjdiTlZ6ZXRaRDBTZDc0WklKNThsNU1XUEN4?=
 =?utf-8?B?SzNYZ1BGcHlRSXB0bzRzRWpQbTZtcFhOTjBQdWtEcEpjTzNHMHNrYjNIL0FT?=
 =?utf-8?B?bUZoVExqdlh6eFpkeHB5TGw3MFVqZEpMZGxScU9wK3Z4QXl3czFHSXROYk4y?=
 =?utf-8?B?RWkrQVd3N2ZaS2pqV3I3MmI3Nmc4aVNrbG5ZYXhicHRBS0tmTWVGdVk0dXRx?=
 =?utf-8?B?c3cvU1lVc2QzQWtiWDh0bmtOc1VXQVVZNjJsNHd4SzBUNWYzN1lxQ3ByRFBa?=
 =?utf-8?B?Qm95ejR0ZW1xSGk1QnMrTSt3blArMzc5NURMcmx2UTVKTmRhK0FhODV5UHpM?=
 =?utf-8?B?Q01xWmdsN2N5ZTQ5TmUyVitDVmtHZWdaNEFna1pua25OYzg1STVzcU9GZzBw?=
 =?utf-8?B?a1ovQURPellOZWIxVyt3VEtUWENBa1k0S2sxYmQ1TSszRW9vdGVkOTNaUS9S?=
 =?utf-8?B?RXBZU0FpaWNNN1ovNURtcng4aEhtc0hRZkF1cnJZVjRyb04rcTlZaVlOSDlI?=
 =?utf-8?B?ZkM2ako3RFIrT2ZRZWZBejZnbTdLUE55bFhBT1ExNm10VUY2VC9xUU9pcDMz?=
 =?utf-8?B?WTVKUXZIcENnUk1Qa2xsNXRxZ3dPR1dNSWVJaER3NzhlZGpFMjFGamJEYUVZ?=
 =?utf-8?B?OExRQjdIVkF4Y3hwR1VocVZkS0dxOWgyVUowd3JxZUlnT0thTEI2K1lteVhQ?=
 =?utf-8?B?dEJoMUtjdXpweG1LUFhyb2dlVW9iclFTRk1WYUMwcFRMK1hWZjA0Qkc5OEhm?=
 =?utf-8?B?UHhXSFp5a1FtdWx1TFg3ZDRiR21MZEY1QUUvN0t3OE9YR0hDSmxTTEp6MzVk?=
 =?utf-8?B?RGhKb1k1TktqekVOU0RsOWhuZGVZK1FjTDQ4UmpVUFJENjVxK1JLQkdaZjB0?=
 =?utf-8?B?bG1nMVFZVS84Unc0Uk54L3dpczBoeEc0WTZOaXFhNElZUGdVRjlYanFoSlZX?=
 =?utf-8?B?MzNHVkt6S2ZNeFcrTTU5SG50SkYrcWJBU2orOG9nK1JjSktpMk5IWncrSGpn?=
 =?utf-8?B?QjJ2NjB0WWRoT3A2UE84ZW5yZE1Pck92VDNWcUVSdUZSVGJVQjl6aURkMmh5?=
 =?utf-8?B?YXlzaDhQa0hGUWlZL1RoOGY1Q2NBNnpNOXdIWTlPeXlFMHoxcFZRcXNBRjFz?=
 =?utf-8?B?ditqLzJCZ2wyUXRTWFRQTFZKankyNW1MeWJndC9nSURCeFFUTnUyMm0vY2E1?=
 =?utf-8?B?UkNiV09ocXlaRGRrM1laVUFkdTdWdGZTMHZudWdqNkNVODZiNDZDVEtCUDZL?=
 =?utf-8?B?bVQ4aWppTXdzb0NMbUFlNE45OENQYmFXWmd4SmJBWWVZR2x1OTRrSExmTjJM?=
 =?utf-8?B?NmtHQ1BTNEhnTjV5ZE45MTNzSjFwbUJEb3p0ZldNamM3dDBsRzZ2QTV1eE9m?=
 =?utf-8?B?Y3RzU1RHK3J6ZUpDd2FVdzZ6OWQ4aithQ1lFazJtZjRobGROaEhNYUI5dVZz?=
 =?utf-8?B?R1VnaWZXeTY0NG5ydVNCSzJvemFGOXhhRURMZTRIK3BVNjJvK3ZOcGlWeFcx?=
 =?utf-8?B?Z2VpOEZlZzFORWxDUjl5Y1ZHekpzKzV0RnlGM1hwV0ZQUnAvMzkwbDY1bVFa?=
 =?utf-8?B?bnAwYVlQMnpGWGc5NGF4QkFlUU9rWU82clR2ZEE1STVCYUJjQmZjWWdUNWVH?=
 =?utf-8?B?bXhYdmNmNXlsOXkydXJGdUZRMjlzRGY0NzlXWVpnREFYb0JWcllyL1BGOWNn?=
 =?utf-8?B?NmJDdVVoa0JSb0hqQnRHMExMaXVHU0JpVGtDQmNhc2Q0RnVrSy9VTGlteHFl?=
 =?utf-8?B?d3dIYWtXU1pNMXIvS05kQzh2S1ZITGpQeU1nNkFtSWJYdVNSZGttTTlicE5I?=
 =?utf-8?B?M2NYSW40SUNORTQ3eHFTNWoxUlI3UkxCa0NQVzBEUG5zNmJydEhKYkxKWWlH?=
 =?utf-8?B?UjZWUnhJaHo3WUtsRDdNN2tvbXBlSlV4cG0vaFQ2VFFHaERIRDlMc1IrTlFH?=
 =?utf-8?B?RFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 026ba02e-06fd-48a0-75c4-08db6384b4ab
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 16:16:22.4863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AgBqpC0Fg7BXyNbSrSfC2uvfeXoOzYJ6ZyN9nsB6/erPfQ8nqTViP/g+VltkyufDe3QRrJ/fXUuZO+nNvj0H19EVD1atxHCbBMSRBP5fPFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5120
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 2 Jun 2023 08:04:53 -0700

> On Fri, Jun 2, 2023 at 7:00 AM Alexander Lobakin
> <aleksander.lobakin@intel.com> wrote:

[...]

>> That's for Rx path, but don't forget that the initial allocation on ifup
>> is done in the process context. That's what the maintainers and
>> reviewers usually warn about: to not allocate with %GFP_ATOMIC on ifups.
> 
> I can see that for the static values like the queue vectors and rings,
> however for the buffers themselves, but I don't see the point in doing
> that for the regular buffer allocations. Basically it is adding
> overhead for something that should have minimal impact as it usually
> happens early on during boot when the memory should be free anyway so
> GFP_ATOMIC vs GFP_KERNEL wouldn't have much impact in either case

Queue vectors and rings get allocated earlier than buffers, on device
probing :D ifup happens later and it depends on the networking scripts
etc. -- now every init system enables all the interfaces when booting up
like systemd does. Plus, ifdowns-ifups can occur during the normal
system functioning -- resets, XDP setup/remove, Ethtool configuration,
and so on. I wouldn't say Rx buffer allocation happens only on early boot.

[...]

>> Oh, I feel like I'm starting to agree :D OK, then the following doesn't
>> really get out of my head: why do we store skb pointer on the ring then,
>> if we count 1 skb as 1 unit, so that we won't leave the loop until the
>> EOP? Only to handle allocation failures? But skb is already allocated at
>> this point... <confused>
> 
> The skb is there to essentially hold the frags. Keep in mind that when
> ixgbe was coded up XDP didn't exist yet.

Ok, maybe I phrased it badly.
If we don't stop the loop until skb is passed up the stack, how we can
go out of the loop with an unfinished skb? Previously, I thought lots of
drivers do that, as you may exhaust your budget prior to reaching the
last fragment, so you'll get back to the skb on the next poll.
But if we count 1 skb as budget unit, not descriptor, how we can end up
breaking the loop prior to finishing the skb? I can imagine only one
situation: HW gave us some buffers, but still processes the EOP buffer,
so we don't have any more descriptors to process, but the skb is still
unfinished. But sounds weird TBH, I thought HW processes frames
"atomically", i.e. it doesn't give you buffers until they hold the whole
frame :D

> 
> I think there are drivers that are already getting away from this,
> such as mvneta, by storing an xdp_buff instead of an skb. In theory we
> could do away with most of this and just use a shared_info structure,
> but since that exists in the first frag we still need a pointer to the
> first frag as well.

ice has xdp_buff on the ring for XDP multi-buffer. It's more lightweight
than skb, but also carries the frags, since frags is a part of shinfo,
not skb.
It's totally fine and we'll end up doing the same here, my question was
as I explained below.

> 
> Also multi-frag frames are typically not that likely on a normal
> network as most of the frames are less than 1514B in length. In
> addition as I mentioned before a jumbo frame workload will be less
> demanding since the frame rates are so much lower. So when I coded
> this up I had optimized for the non-fragged case with the fragmented
> case being more of an afterthought needed mostly as exception
> handling.

[...]

> That is kind of what I figured. So one thing to watch out for is
> stating performance improvements without providing context on what
> exactly it is you are doing to see that gain. So essentially what we
> have is a microbenchmark that is seeing the gain.
> 
> Admittedly my goto used to be IPv4 routing since that exercised both
> the Tx and Rx path for much the same reason. However one thing you
> need to keep in mind is that if you cannot see a gain in the
> full-stack test odds are most users may not notice much of an impact.

Yeah sure. I think more than a half of optimizations in such drivers
nowadays is unnoticeable to end users :D

[...]

> Either that or they were already worn down by the time you started
> adding this type of stuff.. :)
> 
> The one I used to do that would really drive people nuts was:
>     for (i = loop_count; i--;)

Oh, nice one! Never thought of something like that hehe.

> 
> It is more efficient since I don't have to do the comparison to the
> loop counter, but it is definitely counterintuitive to run loops
> backwards like that. I tried to break myself of the habit of using
> those sort of loops anywhere that wasn't performance critical such as
> driver init.

[...]

> Yep, now the question is how many drivers can be pulled into using
> this library. The issue is going to be all the extra features and
> workarounds outside of your basic Tx/Rx will complicate the code since
> all the drivers implement them a bit differently. One of the reasons
> for not consolidating them was to allow for performance optimizing for
> each driver. By combining them you are going to likely need to add a
> number of new conditional paths to the fast path.

When I was counting the number of spots in the Rx polling function that
need to have switch-cases/ifs in order to be able to merge the code
(e.g. parsing the descriptors), it was something around 4-5 (per
packet). So it can only be figured out during the testing whether adding
new branches actually hurts there.
XDP is relatively easy to unify in one place, most of code is
software-only. Ring structures are also easy to merge, wrapping a couple
driver-specific pointers into static inline accessors. Hotpath in
general is the easiest part, that's why I started from it.

But anyway, I'd say if one day I'd have to choice whether to remove 400
locs per driver with having -1% in synthetic tests or not do that at
all, I'd go for the former. As discussed above, it's very unlikely for
such changes to hurt real workloads, esp. with usercopy.

> 
> 
>>>
>>>> [...]
>>>>
>>>> Thanks for the detailed reviews, stuff that Intel often lacks :s :D
>>>
>>> No problem, it was the least I could do since I am responsible for so
>>> much of this code in the earlier drivers anyway. If nothing else I
>>> figured I could provide a bit of history on why some of this was the
>>> way it was.
>> These history bits are nice and interesting to read actually! And also
>> useful since they give some context and understanding of what is
>> obsolete and can be removed/changed.
> 
> Yeah, it is easiest to do these sort of refactors when you have
> somebody to answer the "why" of most of this. I recall going through
> this when I was refactoring the igb/ixgbe drivers back in the day and
> having to purge the dead e1000 code throughout. Of course, after this
> refactor it will be all yours right?.. :D

Nope, maybe from the git-blame PoV only :p

Thanks,
Olek

