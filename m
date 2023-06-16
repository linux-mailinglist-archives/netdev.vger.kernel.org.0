Return-Path: <netdev+bounces-11469-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C176733314
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:06:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6937F1C20F95
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7576619BBF;
	Fri, 16 Jun 2023 14:06:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7381113
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 14:06:02 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8141A3A82
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 07:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686924337; x=1718460337;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E+8fIT2+h9sx69jDNsKI9PDlkii7GzG66E+nzN7IGXo=;
  b=X+jZ3r875e1hnLjC8wvy171tIqwAPWTF02uWW8y//kQ9n4tMKbayWKik
   yGB5Q/Vezmv3Klqkfx46pUeCdvwQUJBGW8Uf1Y2DYUwGtR4jkdKxgLTLO
   DJBlfuDx9h1vPpPh+RPr9Q0O8iRRzW62d3fldorUwvOtCHUk0AWmqGSWM
   A1hNCuXgl3LeS+iH2X9rDHSkgCF8J+KdgSDGvZNYxiX4FZpuPes3FpQAH
   0YHMMlEMd3XexgvXd3pnRqinDVpc59yJja87XLrfZWbqpzSqDg2K3nlFr
   dgQrfUEXmVdRk/AofkYIZVCyI2y3UzW/wsajvxNxgigIMRie7SGaGCi51
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="358093044"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="358093044"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 07:05:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="837046016"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="837046016"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 16 Jun 2023 07:05:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 07:05:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 07:05:34 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 07:05:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iicYgkUSf2efab4GEFUV+dX+ao0D+ZPMtjTuTb+9revss5StB4gyhaQvl/udKo6mpLFC6kszHI1NOqI8P8ckBvZCey9Me3WjGf0Dz0DGO54THKt/hMbkVboKGGHKG9ki8+NvwRX/kxFKX7g0hDqmWCU8VDFs1E/guU7rFo6drg00kva7bUtkdW6/O4fZFUAlyOHR//hndrLJEpu+wc6Pz/QogxiE2vKpzGvfKJxhpgsa4Bt01g92uM7ur5uVLAAXsSDfKc5FCsfLKz0u2MeCjZ20VhG6JreMOTjRmGH+IrQAHHEI+0D+vT3SE6JoZFjemjrmlqo4qU0AKQXQ/AjzxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9vYCaP0CP9pKic+JWslrcymvdjEjaC5grc7W4d/UWAg=;
 b=b4Tl8YgWz2yeTGgUowmDM9y313ZoaEtEPuUs4z+cxtlLtMIWhHLHuHXTL59/mg3od1b7M0XG+8mkPXYwD7faypriDrk0p4dwdGFx3oaFxP1pl9HFqvr8ycl/WxkQyv0kVWZ1T1HQ0ljxSWEH5qbnLpe+5mvBOkw/msDQoAHbpWiHE3Nhg9+5BDrRpUuucUI+EuTRb1r/ajVwDpRlSJFu19FpJgkj01lGPkKd/i/fY8uR/rYzPMTvIy+6WdgHiBTZuh2SbnxDri6GRiBRyv5N+FROqO/AeE9GayOxZyxV0jZ7xY8f22P3ki2k/nAZZ99NEZK7iV2ZfSwnkKD5ZBzt3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB5360.namprd11.prod.outlook.com (2603:10b6:5:397::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Fri, 16 Jun
 2023 14:05:27 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Fri, 16 Jun 2023
 14:05:28 +0000
Message-ID: <8852e500-1417-830b-9b24-31ced5ac4b99@intel.com>
Date: Fri, 16 Jun 2023 16:05:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: [PATCH v3 iwl-next] ice: allow hot-swapping XDP programs
Content-Language: en-US
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
	<anthony.l.nguyen@intel.com>, <magnus.karlsson@intel.com>,
	<fred@cloudflare.com>, <toke@kernel.org>
References: <20230615113326.347770-1-maciej.fijalkowski@intel.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230615113326.347770-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0157.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::20) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB5360:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aaa0b8a-60d9-4095-d55b-08db6e72bcf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fJPfh7XjGF0852Y2O3lNBYJwEd8ZcMGdhYTY8H2JPEqnuwlAKnzS4IW0FJctAmv6/yvgHLFmsksIkOAOb3tkSKOtz1fNB3v5KhFIUVfV4kECbDW29VlLKRTKe+uTdD5sevSiMgiGEPnyCsafBILAyc7OZFfkYoblGgYeIwJ8twEG4xH4mt2IweyBNaXhCBCHbDYQbCBwhcnDTLY3690JXHTjJgaB2UqZ36vnMfWNeK7i4u818p6PR2zM8jeFRMnqm7n4xldFBj01uAQltUnZCA/eRFCkJEhG9hzZ1/Xcy5Vw87eEs7YbXGtmrWZSA5aoOBbDBRSFbiq9IiC1IpkxX7679rmOVGDgi9UnqRzr42Yh26QGeGiX8oLDfO/04xNRkXr4IuOZYkBDixETOWBHq90vOSXIFx0TF9KolrpiB76Uvc5YVx6weVDplT6EuneTxh/0KfcnEVzV16oOf47oBJl3pwbOjJj+4ho7KGAzmGt4cc2BhYeYXyy5qdmN4HVyp5lX0y3z32/vOYxMvkKuGOku8ucB3h4MH8r3uta9HJFd6mjAmwqIVHcPHtswugqh7RpoGcafzL0r9mRfGV9OE82dAZ/gQvlNNsi8VIQnIK9K1srLkAMkdx1rFjAHFBEWTuBJmENLugOwvpxwiYvhQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199021)(478600001)(37006003)(6666004)(6486002)(5660300002)(8936002)(8676002)(82960400001)(41300700001)(2906002)(36756003)(31696002)(86362001)(6862004)(38100700002)(66476007)(66556008)(316002)(66946007)(6636002)(4326008)(26005)(6512007)(6506007)(186003)(31686004)(83380400001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NW9CQlhtMFdnWk02UHFMT3dyRm9PcGgyb3drdG9jK1dUTHg5Ylp2aFZOYStN?=
 =?utf-8?B?UjdvOVE3WFNUV2p5cWJzTmY1RXdNR0VqRTJoOGszWmg2SU1LUEdjckVnUzYy?=
 =?utf-8?B?VmFlRzRMcVF0a1prOXk2NHJHUnQveVJlZmw2NEh5VzlZSG5iUEhYSE1tM2po?=
 =?utf-8?B?Q29QblE2Z3l6TCs1b3dBK0JsalBzSjgwZDJBY0JzV0lLMzFtdG50b24zWlFH?=
 =?utf-8?B?SklCOFM3YTFSYm8wbHRubk52SHBLcC9JL2M0OGk4ajRYamppT1F3Z0tTT3pK?=
 =?utf-8?B?NDhEbGVUdDQ3cWs0ZExEeXhqWThobVdocFgrUXhxVUFLNnlwbG85WmovcWk4?=
 =?utf-8?B?aHRCdkNGY2tTS0tIS09YTDJONVdyTFY1OHBPc0pnNXBpMFM3Rm1xVUlUSkRh?=
 =?utf-8?B?Smc4dXd4alJSMHZTTEZSOXptQ0dOWHlWdkJzSEZRQjVWQ0gyeUJoUTZqMkNp?=
 =?utf-8?B?b0VyakxkVW5ZYk1FZnlqSUlHc2tIengzNGttdUZGL0duU21EdmNSdE9Ld3Fv?=
 =?utf-8?B?K3M4RXN0c3Bxa2NPQ29renNEVEQ3Q29lQmVMYjdLQ2J4ekh1Wkk2RW5yOUx3?=
 =?utf-8?B?dXZsck9jTG81ZzZvclFFcjZqYzFkTkpEL2E2NXVBVkVVUFdKR0VTV3Bld015?=
 =?utf-8?B?bnhBY0N0cGkySmJyd1drVHpnREkzUFhxOUtXckdtajRpam4wV3pkcFpIUWpN?=
 =?utf-8?B?QkhHZUdrcmc3aE9SYTVRYVJTbmZrOGZIdDlzR1pud20xZDdBVzQ1ODRvVndr?=
 =?utf-8?B?UjZUVm5ieEtOOEZWRy9yVDFJa2xpMGlNd1hlb2NtNWU2MEpkUXJNMm5RTVFN?=
 =?utf-8?B?V3ZRdzdrUlluUWYxRHVkTlV1cGZXaURrMjRWN1Vldy95VTJHS0xEWE9KK1Fo?=
 =?utf-8?B?c1NaeTdhL3hRcVFsRGErazhoMXQ1TlhMbWlPYlpnV2FZRXlSN2xJbGVIQmNv?=
 =?utf-8?B?TG94MVVTRGRpYkR4NGlqeVpwWXQwWHEyVSt6TTZDNDBBVlprdXY1Sk5yaDA4?=
 =?utf-8?B?c2dtN2dZU3NBWkZ3eXVqY3Y1eThFTUJLbWEvc2lMNFpXMmFydkd5MmtQanVM?=
 =?utf-8?B?dFN6QStqV0xiMENzbzZxU282NnZkZklXYXF0MnMvRkMxR01FUW95ZWRCRUdt?=
 =?utf-8?B?TnU0akt3b0xaeHNqUnluR3huYVd4YzZGWlZlQkxYUFdrNjNJQ2NLMkgvMVQ3?=
 =?utf-8?B?WWhwTTVtSVh6cWp5SitUWWdRN2JjNVhodzBxNStzWWlzSXVYamRTd0RuVmNI?=
 =?utf-8?B?eStNS0ZhZ3V1RC9HQk5xVU1US2RJaW9EMlZsNGVWOHBSMTAzOUhIVVN4aFV4?=
 =?utf-8?B?TTh2UXZzcmh2SEpGWnp2VllOS1hOc3N2c3czMjNoUVI0Rko3ajN3VmlraElY?=
 =?utf-8?B?Y1F1QUNleHE5WFRRbk9sdU83OHc4WVNCbGpQOTJyS0tDanU2bzBwTW5wSyt4?=
 =?utf-8?B?Vi9NbmZia1pQb0owTXFzVnlRRk5wcFdFQkQ0OS9wbnBaaXJvenJPWWpuNGt2?=
 =?utf-8?B?N2FESlFGS1Y1NHNDUVYySU5GOFhieTBVUk9oTG0xT29FbVluenJ1MWpNeDg1?=
 =?utf-8?B?WEV2RWRBZ1ZScVBJaWZVOGFlbERPSlo2Ukp5TktkTU9WUWZDTW1WWnl3MWhZ?=
 =?utf-8?B?Lyt2eVNRdm5JU2pDd0U2U2JwemcxV01iTUJrVkxiSFlTaERPWWdvZko5aU9i?=
 =?utf-8?B?VGd1bEJIb29Vd0w4WHRLOXZ6T2RPTEJNbEEySXpFak9LRzVPYndEM2szVWE4?=
 =?utf-8?B?eG1BSUh1QU5zbkZvSHpjODZTMXBKQmJQNGVkUDFNWmJIS0RUQUkxaWlLdUZh?=
 =?utf-8?B?Rm13Q28zSGRJV3NsbGtvTEFuZDRmdFdMSTFrMDQ1eHlPWFc1TG9vU211MVll?=
 =?utf-8?B?ZnQwMHlKYlJpbFB3aHYvdTExNEgyaVZMNktJVGdqRldocXRoWXVpYWxPRWxD?=
 =?utf-8?B?Vy9lNW1JSjVHRUxpRVR4bU5KYzZDVjRrVCtNNnIvVjdLTGZLSXNtL1VheGhD?=
 =?utf-8?B?NWdyTVVvUUZRUVNxbzlkc3c3blBONkRmaU5zNUtsYTFWN2htUTg2ZGJ2Rngz?=
 =?utf-8?B?Q0VtMFhKeENRc2VUYzFjeDFPWm0yRUw2Y0FYOEVHUE9HNCtQckd4Yk1UTmt0?=
 =?utf-8?B?RVFuLzFXOHpJZzY0MWZOR0JmdDhHTnBuN1BLb1pNaytUNTJvbDhKYmwxWFMv?=
 =?utf-8?B?ZUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aaa0b8a-60d9-4095-d55b-08db6e72bcf4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 14:05:28.0975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NiJP4kntl0a9zP+/WXvNTDZZ74WSyayp01VR6VOSpVqWk/0YcEwHYAYFB3HmBmorNQpWcCJ+8a2aCog+jqxNbtm2fnNLB8Ox9y8c1xWI4DE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5360
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Thu, 15 Jun 2023 13:33:26 +0200

> Currently ice driver's .ndo_bpf callback brings interface down and up
> independently of XDP resources' presence. This is only needed when
> either these resources have to be configured or removed. It means that
> if one is switching XDP programs on-the-fly with running traffic,
> packets will be dropped.
> 
> To avoid this, compare early on ice_xdp_setup_prog() state of incoming
> bpf_prog pointer vs the bpf_prog pointer that is already assigned to
> VSI. Do the swap in case VSI has bpf_prog and incoming one are non-NULL.
> 
> Lastly, while at it, put old bpf_prog *after* the update of Rx ring's
> bpf_prog pointer. In theory previous code could expose us to a state
> where Rx ring's bpf_prog would still be referring to old_prog that got
> released with earlier bpf_prog_put().
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

Good stuff, much missing previously.

[...]

Thanks,
Olek

