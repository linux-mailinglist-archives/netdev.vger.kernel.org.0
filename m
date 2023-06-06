Return-Path: <netdev+bounces-8487-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B4F9724437
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:20:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDC1E1C20F6B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC8D17FEB;
	Tue,  6 Jun 2023 13:20:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1F537B8F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:20:50 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E596712F;
	Tue,  6 Jun 2023 06:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686057649; x=1717593649;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PObT+021SCqQmTDTw/JkTLF81cltE8Uwq3zNznT29X0=;
  b=hNiAo4vH0L12V/58cvA46JtCu08AIUPDEY9T/eK1EYdouXfFpXuoknrd
   9MAAA6WuebO4svCONYYefpii2NnSrDMGrZZCJXe8ESZQ+2E83lodfcYVZ
   THQyQKo0TKyzyrApKeIRMBCAv+bu4Rd45Whmmmcpt0bNPf2Egc9il75kW
   1Eryo9g1Pr2HlGVSpjBHN4gyVfSy82yvrEgXhfDEKqwQeo270wq5Wov/V
   3DmQelRjv5vZlZ8TfQY/ZCuPBglQwH4HQjls9StXgNJTJ/HpOeWjcU6D8
   haM5zcGyLrwsW8kLcL1nuEAvyOpa3x6y8OQnLXMltcTR52HWxrp1CTirq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="422495276"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="422495276"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 06:15:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="798843620"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="798843620"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jun 2023 06:15:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 06:15:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 06:15:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 06:15:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 06:15:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5iK/bKb6+NXam6sTKt+2dlE7NMBAeUoKKs+RlSpTcy48GYW+Q+SBlui6zU7CmO/q+e/V8jbjISx3YfbySGtduAV/vVB70pVAZpTiHbc/P+Lw5uSvDQ3zjoqKBN2jduealaSGLwU0aq8FouhCgJcfNnGTdbXAFlIH5i2Hik0J9fG2P+uxItBy7cpn7IRzA4I98Zjz5PZN/0wP/4CAjv/yK7zUCAUvwheEajWPzl+tc3TXMyNbgMMqxJrfSkN0yxTXQXcb5pb2c9PuxC+Vb6kY5Wu/aPhxFnwF6pGmKoMhAEtw4Y2Rxt8DAFbnuOaqayYW/K05m74D3q/tyvKKlFB0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8gso4AurVdREySNFKTMcwviiJlcNtlWHn1XlrP9kKf4=;
 b=YFprucg6iQB8lII9E1YC22fXl9Q6OcpykdHqbKT8wljnepjz5Eu4Ctj52nNBygPt+I8UzPn6X3+iu7S+L0exZiWNUfGSvl4r6E6LW05+AU4M1DyTHwN0z/MZCV6StW4pUzNZljmbt4F3FdHsKJ1ESg7gpIMhAX5tQP68zfu20prwvJjbTFcFC29Mpn3bYURoCbFmkdYKPyFRVo43zB4+Lr4KWN5OdPP5fCAvDyhe2qN8E/1r8fdBfd++mn4t6stECUQLt1hf3tsYL21vPTdcW2Eni+anshmwjZ8mjiNDYeyBOjzsAx5yp67TOeRVCSDtnmnfAXZudW81r3Mii561BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB5342.namprd11.prod.outlook.com (2603:10b6:5:391::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Tue, 6 Jun
 2023 13:15:46 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 13:15:45 +0000
Message-ID: <df0bfcc0-558e-d394-be3e-59264a495e86@intel.com>
Date: Tue, 6 Jun 2023 15:13:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v3 09/12] iavf: switch to Page Pool
Content-Language: en-US
To: Alexander Duyck <alexander.duyck@gmail.com>
CC: Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, "Maciej
 Fijalkowski" <maciej.fijalkowski@intel.com>, Magnus Karlsson
	<magnus.karlsson@intel.com>, Michal Kubiak <michal.kubiak@intel.com>, "Larysa
 Zaremba" <larysa.zaremba@intel.com>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, "Christoph
 Hellwig" <hch@lst.de>, Paul Menzel <pmenzel@molgen.mpg.de>,
	<netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<linux-kernel@vger.kernel.org>
References: <20230530150035.1943669-1-aleksander.lobakin@intel.com>
 <20230530150035.1943669-10-aleksander.lobakin@intel.com>
 <0962a8a8493f0c892775cda8affb93c20f8b78f7.camel@gmail.com>
 <51f558e3-7ccd-45cd-d944-73997765fd12@intel.com>
 <CAKgT0Ue7US2wwZXXU6HcGPBZWg+pSZ=PE_HWxJHgF8bmLymkfg@mail.gmail.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <CAKgT0Ue7US2wwZXXU6HcGPBZWg+pSZ=PE_HWxJHgF8bmLymkfg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::7) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB5342:EE_
X-MS-Office365-Filtering-Correlation-Id: c99b4853-8e01-4d31-2488-08db669022c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QxC+/l2Wx7p7J5O6AyXC41QZjzpK2AvfnVihFggfvDFS4Fh+/5Y0UsPDgNmg/4mlamr5E4dY9Bi1z18ixrV5cWWn6xmvx4AWGKfrDv+r75/EPzY4m3cmb7tFYh2B/7QZevKmB8Qwv8C/iywE1HvgRffS6cbgXHwvSOCFUSsJZ5MRMtBpyquu7DmQY363ULGAXbAZTdiajHV5QTyqk4I8mRDSp7Kw9HQONJlLH0YPCkwqtfVBkZF11hGa+umQ5Dl5ITV48n+3s5EGYlENP0Q6gVAcfDATDqQ+DGIhpN8BvwxCZIu74+n4AZcxmzFKShbVbD6IAfBB3MmeSd1DzYkCdo1k8IX6mm4ajAjAAqfeCPN24YcLhIzkUp2xHNqFTk6QSvdzIgDZKJQtAHDhzEfh1OyEvkLygghjPqmDCDdqaHTezQFcBsqioilVYm9ipvlVfUD5dLgDARaRNHEjq3qJCnyUCRk1fXQZWM0dQG3uqw9HfsZFWhSKSRipuLOicnAJsUBVm6VqU3pkrYAuVSAZA6lNv67MnUGZLtTqC7pAU+AI+iYk4sZrCw4WHL6xuRpU3TLmuaYuW8fUepWR2HttpL2+HZSs5hIB4BKbf3mv3zE7pVA5SkW+eoK8fAAiqBajj4y824u0pUFEqqEDToDExA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(376002)(396003)(366004)(451199021)(36756003)(478600001)(5660300002)(54906003)(6666004)(8936002)(8676002)(316002)(6916009)(4326008)(66946007)(66556008)(66476007)(41300700001)(38100700002)(2906002)(31686004)(7416002)(82960400001)(26005)(6506007)(6512007)(31696002)(53546011)(86362001)(186003)(2616005)(83380400001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0lua0JmZzc1bnFQbTljRFlvbGVHb2dtRWUzeENJS1Q3VTVpQ1lqbHdCR25T?=
 =?utf-8?B?U2UrcGpiUWk0REVCbitIcnVNcHJodVhoYytMRDB3QzZwVEhTRTZOZTBKVDdX?=
 =?utf-8?B?ZnJ5ek5PQ1UvRGxUMVVYOUZyZDhrYStCK0N0b1NKM3B6a1ViMkszdkMvNkJv?=
 =?utf-8?B?UkxqMkVuOTdLV2lXZVFjd1BMSEg0VzFrQXV0dXNabFhyWkR3MGo5dlp4TVdE?=
 =?utf-8?B?WHp4a0g5QUplZTFLUTE4U0xkb0EvMFFQelBvMUswMVIrdnMyeTZQVkYvNHRM?=
 =?utf-8?B?WE4wNHREVkE2d21wV0ZXYVJyQTY1b1l1cS9qeU1LSlRqam1oYSthdmU0YS9J?=
 =?utf-8?B?V083VENHczVTNDloTmROYUVUZHVMejk5cmd1VmFOZHZkL0N5RmpXbFlKUmhF?=
 =?utf-8?B?VG5uRitJTUl0NjZBZnA3UXR5MHdOQUVwbGZaNmFQOXJRSUg5LzlRcW5kd1Bu?=
 =?utf-8?B?QWZ3NGNtMktUMVBhb1o4b1EzZUtkczZJMVUrcU5QSXVHa2FSb0VDS3pnVDIr?=
 =?utf-8?B?Y1BBWll5SkthVmxzVmk3YlNQemdIMG5aZHdlV2tGdzgxb1lRZVROMXZOZGdX?=
 =?utf-8?B?Wm9VbkRzSG9mQ2dYUFZ4TmtrMnJwTnBRckFuL3JzVjJLTFJGUGthSmdWOHhE?=
 =?utf-8?B?NGFUaW9EeGYraUVEVFZUVmJYQS9NYUVEQWpnam9wamNiSitNcDA4TTZVUE1k?=
 =?utf-8?B?NVRDRW9UNVc2d0RFdFRwelFQTHB0aCtGZFE2d29UOUlWYVV0dnlQaDFxZDYx?=
 =?utf-8?B?VlVmcG00ZVdyb3NYRGpjSC9NSEsyZFhYKzBac1Q4anBMN25NZUV0ZCttZ3Ry?=
 =?utf-8?B?R0pDclVWUExoZlhYYks0Zm5kdm1kYUJPZlpRUmpKaWo3bjA3UkF1ZFpTVWlQ?=
 =?utf-8?B?VjVhQlI3V0drNHBYR3FId3VtSWtEdTZncTZjUTlNQmN5SUFEeTA4Y3dlSnhE?=
 =?utf-8?B?WkMrTTdkdGlnelB4V1J4ck5kcmcyTG5pMURLaTZ2TnNPU2dqVFJZc0NTd2Rk?=
 =?utf-8?B?R0RBRzgxNWVlalN1Q3JNcXZCOU9qSU9RL0t3dFZkWnRqQXpoSTRGeUR3Q01U?=
 =?utf-8?B?c0ZoRFVxall4Qk1lbkRmVVdtUVVaSmN5K0x4b1JibVFDU1U2UG5aSVM5VXdH?=
 =?utf-8?B?bjZKN0p2SE9ybms2M3lYNTh3Ty9nYWZxT2ttV1NJcWtwMFJyMklIQUIrUUxr?=
 =?utf-8?B?K1NvQjFrakxCbGZVeXhpRGV5Z0EzTGFXM2tPMTA1aUtSQ01pTVdCZUpMd1NE?=
 =?utf-8?B?NUJncFNTNHRkOXFGcml4TnI2YU5UM3ZtQmZZZExJTmpNcDBmWndmR1hZZVMy?=
 =?utf-8?B?VGxNMXRxWm94UUVtcW5IaFhualduTlVaQ1d1Unp3Q0RNTHBOWkg4YjdYUnkz?=
 =?utf-8?B?QW9xemdvcCtvcWdJNkl2ckVzTGg2RktZbzBzdVRBbUNRUXplelQvZmlBNit0?=
 =?utf-8?B?WmhaVVNlRGp6VkZ2MGlsdFQ3bVNLSElrTDVVRXgxeFoyYmc5enUrVjVqUnJO?=
 =?utf-8?B?SWhic0JZY1BJY2tlMFdjeDNuaGkzRTkrVjQ0L0NBL1dzaFB3Q1MrNVpIOEph?=
 =?utf-8?B?L0ZTR0VQaFlSN3JycnZZTyt5OW15WDNxQ1YxNUNXZkltWXpuaUZXc2FwSTIz?=
 =?utf-8?B?Qmx0MTZtMlJWUloyd0R5RXA2anZHVTJOUCtHVTZvMkMvTDJydEVxZUx1MzJV?=
 =?utf-8?B?bS8yaFJGYzlqOVBydElXelIvdWdGNzloVnVINVU3Vll5VlBuL2VXUGNGbEMy?=
 =?utf-8?B?RGdoaXZoM3p0d3FUVmlNZU4zZzFnSCtVUytzNmIvWHJvVUJETHRwZzdXdFJL?=
 =?utf-8?B?WUpXdU1VdlV4KzR3em8vcUl2Ujc3bXlkU1NXY0dKZElBWjJ4L0dMZUVLNTdk?=
 =?utf-8?B?cEt2UTJXVHFRaFdvUldQdVkwYlpHWnp1N0U5UVNTeTk1aW5VcHNMMlNOSlYz?=
 =?utf-8?B?d0ZOMlF2QzlueStTZzF6cTB4OUtLalF1RUt2ZVdFK3ZLQy9mdTd1RzczZE5t?=
 =?utf-8?B?NmZhVDRNOWJaS25yWG5hWXIwNFZPbjliTTZzbm9wY1FZQVl6QUY0WFhtZk1l?=
 =?utf-8?B?M2hadnVSSWF4MUx1YllaTkJoVTZhQWhBVkhSSjdueEhJNlN5Y2hhTko5SDkz?=
 =?utf-8?B?WEZoZjYrcHYwVCsvQ0JIUlBxUmJkNXhyQ0lWUUgzNHpNOE91Y0ZJZnBaQitR?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c99b4853-8e01-4d31-2488-08db669022c3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 13:15:45.5798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aYp7ORTLQI1Ufuuu1xNtYqFrn2seCrC8eA5UW5Oindm7VR6h7frGe2zU5uQjZ8k2q8qxfdRPLsylki8+3t7qkLk2cVCudu+GCHNZviA6gVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5342
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 2 Jun 2023 11:00:07 -0700

> On Fri, Jun 2, 2023 at 9:31 AM Alexander Lobakin
> <aleksander.lobakin@intel.com> wrote:

[...]

>>> Not a fan of this switching back and forth between being a page pool
>>> pointer and a dev pointer. Seems problematic as it is easily
>>> misinterpreted. I would say that at a minimum stick to either it is
>>> page_pool(Rx) or dev(Tx) on a ring type basis.
>>
>> The problem is that page_pool has lifetime from ifup to ifdown, while
>> its ring lives longer. So I had to do something with this, but also I
>> didn't want to have 2 pointers at the same time since it's redundant and
>> +8 bytes to the ring for nothing.
> 
> It might be better to just go with NULL rather than populating it w/
> two different possible values. Then at least you know if it is an
> rx_ring it is a page_pool and if it is a tx_ring it is dev. You can
> reset to the page pool when you repopulate the rest of the ring.

IIRC I did that to have struct device pointer at the moment of creating
page_pools. But sounds reasonable, I'll take a look.

> 
>>> This setup works for iavf, however for i40e/ice you may run into issues
>>> since the setup_rx_descriptors call is also used to setup the ethtool
>>> loopback test w/o a napi struct as I recall so there may not be a
>>> q_vector.
>>
>> I'll handle that. Somehow :D Thanks for noticing, I'll take a look
>> whether I should do something right now or it can be done later when
>> switching the actual mentioned drivers.
>>
>> [...]
>>
>>>> @@ -240,7 +237,10 @@ struct iavf_rx_queue_stats {
>>>>  struct iavf_ring {
>>>>      struct iavf_ring *next;         /* pointer to next ring in q_vector */
>>>>      void *desc;                     /* Descriptor ring memory */
>>>> -    struct device *dev;             /* Used for DMA mapping */
>>>> +    union {
>>>> +            struct page_pool *pool; /* Used for Rx page management */
>>>> +            struct device *dev;     /* Used for DMA mapping on Tx */
>>>> +    };
>>>>      struct net_device *netdev;      /* netdev ring maps to */
>>>>      union {
>>>>              struct iavf_tx_buffer *tx_bi;
>>>
>>> Would it make more sense to have the page pool in the q_vector rather
>>> than the ring? Essentially the page pool is associated per napi
>>> instance so it seems like it would make more sense to store it with the
>>> napi struct rather than potentially have multiple instances per napi.
>>
>> As per Page Pool design, you should have it per ring. Plus you have
>> rxq_info (XDP-related structure), which is also per-ring and
>> participates in recycling in some cases. So I wouldn't complicate.
>> I went down the chain and haven't found any place where having more than
>> 1 PP per NAPI would break anything. If I got it correctly, Jakub's
>> optimization discourages having 1 PP per several NAPIs (or scheduling
>> one NAPI on different CPUs), but not the other way around. The goal was
>> to exclude concurrent access to one PP from different threads, and here
>> it's impossible.
> 
> The xdp_rxq can be mapped many:1 to the page pool if I am not mistaken.
> 
> The only reason why I am a fan of trying to keep the page_pool tightly
> associated with the napi instance is because the napi instance is what
> essentially is guaranteeing the page_pool is consistent as it is only
> accessed by that one napi instance.

Here we can't have more than one NAPI instance accessing one page_pool,
so I did that unconditionally. I'm a fan of what you've said, too :p

> 
>> Lemme know. I can always disable NAPI optimization for cases when one
>> vector is shared by several queues -- and it's not a usual case for
>> these NICs anyway -- but I haven't found a reason for that.
> 
> I suppose we should be fine if we have a many to one mapping though I
> suppose. As you said the issue would be if multiple NAPI were
> accessing the same page pool.

Thanks,
Olek

