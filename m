Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17CF26A5CE3
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjB1QNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjB1QNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:13:45 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCD31B339
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677600823; x=1709136823;
  h=message-id:date:subject:to:references:from:cc:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=behNtJnZtcigK/1KB989Kfc+kXhRntjjBvsSWHTONYo=;
  b=M/yKiSGuANvdyFD/J9rMjLjXqQoc8UgK3pen0tOuSQnyVgIy5ckPn6iW
   xYG9v/NwTJ/IjPE2Z+4CWVY98/Hosh+67W/68Kt3Sgz+xetuUxllrgtVj
   V3WLFRIRNCTv1SS/quaYSAtRRlts7bgn++oVnk12KGLPLka3sTZ7lmm2L
   MH1OIV+c4wdQkp64gtkgW4Rr5QUmXwGVN4ga4Jiia62yaFE7vKDlwu6Yp
   xsenDr8JTeHy5yxK/EMl8qEA8UXoK/SHuXj+E/rkEnzxfBlpLc/yB3/nf
   CrKRheFyA+MQXFRyUi5QmZI7iWLhr75inDsSYJWjE7wYdNhHCs6oVVJCm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="322429913"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="322429913"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 08:13:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="817128258"
X-IronPort-AV: E=Sophos;i="5.98,222,1673942400"; 
   d="scan'208";a="817128258"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 28 Feb 2023 08:13:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 08:13:42 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Feb 2023 08:13:42 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 08:13:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DvMSNi8kyXkJMy2wr8BuhgOFVwaXjJniahpohUkFD0HALLLvp7n1qkMwj2gexJTFfOiK48JsZfwu7vK2BaRJXHD8LHDJ8FJHZO6yEDsUJxFLTxM2LDqrnf0BK/K9P5XD9ecX5N3I8b4yXd6iKre8vcpv2SCVixJzawXR4dWZZbOo4H2JqFPihRqxXe46VjRKRMoWxsf6luBEi/bzSygV7KTZpcpkv41UhSaqlSYxDT3lxBnXalKUL3nRmfGHeG1BpPQW5JS+qGipkZVqKamr4lIXysfmUCBm5kMeCQBk5J6RCqC+hiobOIbJ/i2JDk5hMo2onNUCniw5tQVp+1V7ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOHVZTzZXib9om5gJaDIuil802CkMiLSRZSMxTum8HM=;
 b=jRLvCVf93mSOULfuYT0krvKWv2G+Igr/2Z7rZ2K8tdcgfAivtT+ZoodDA7RZuoIs4WMg1wV+ZP+Q2LM1Zn8iaQ9yscilB25YdC92X4CSVuSVx9UzjRvh/Chvw9y691iYgJmbp+j1UiJ2q5hYS5pDNPJuSfZHjCQYmGfPe3OndRjMTKvt3tfVZWWVn6ZeLjLgyTGIu9K4jQH+0dzijCTaP6HHgzPgdH3lP7Txg8jMOCvXXEbEI9mfmHGlcUPNyksmqmtHVqgORm2/vs/rWsdAbPCRkIsKypSxqvmaPU1hgalQugh07FP7yG3I5iGkfrMUZogy8XGJSdcF+o4x24h65g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH8PR11MB6973.namprd11.prod.outlook.com (2603:10b6:510:226::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 16:13:40 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 16:13:40 +0000
Message-ID: <fe77a548-a248-95f3-f840-8cd6ee0c1c27@intel.com>
Date:   Tue, 28 Feb 2023 17:12:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v6 1/2] net/ps3_gelic_net: Fix RX sk_buff length
Content-Language: en-US
To:     Geoff Levand <geoff@infradead.org>
References: <cover.1677377639.git.geoff@infradead.org>
 <1bf36b8e08deb3d16fafde3e88ae7cd761e4e7b3.1677377639.git.geoff@infradead.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <1bf36b8e08deb3d16fafde3e88ae7cd761e4e7b3.1677377639.git.geoff@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0133.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::17) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH8PR11MB6973:EE_
X-MS-Office365-Filtering-Correlation-Id: 65eb013d-7705-45e3-a9b9-08db19a6c141
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ccBJd9ULvvCfyj05IccytEM6KrhcqLKhNmra1bdEOI9L0LY2zNXFwPpfsQK8VF5JquPB0X2MtXMXg7cN6SwG+cW9tslUukUO/v9BwgnFVboMr8Jr+C6FQ07pG8SDZtcmKkW04wIBuQNNbv3gKgFQaRMaZj0ZoY3v8erv6YCKdoMhkpY4+5+ubUPPb7HqGVpp2YI21ZIc3JyIYxbtUYcuQJO8EoFX6dLkD+SGY+025mXLygr2ZTnIBk+0LkmW5+6eCPyrJVsyoOX+t+psmtYehkvho0iigiy1IDAJZTmyK+U6O55olzNTda2XXn3yENLIPw/ENKk6m4S+12+KOXFGhGDZNw+jCiH2N/woixnhxahb2Jh/ytB7Uf39WOwr/Jh5RyMp4XtgZUCs+WNEptD9vZ5R3PmlPnPWMJerq1kjNzjs+PF7hvH6yhNb25oYleGPuzXQE5iNCM4OzBW/y2IzT6E50i6QSTYdUSqqg7MucYXivBWzOfhASM0lXXQQ3zLiXuF6gQSlBqS31D7SkXIfWEpVKscekpo7W7CO5kIMuGy57T0FJU3NG2FFYnw/tTEMX0kD0g3h15uZJtqXB/2cWmxnoauX8SH9oIY/gMGlenWK4wvYi9bUQcCi873I5AVmd2c28gnpZ6W8X4qA7M93kmLqS2sfUkzAFf4/F4+dKyMrFctVdzQu6u/+3tr/sxHy4ZU/P6GsejCfYMBbtCktKsFz+LDz9Dd9tP3UgioyLWM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199018)(82960400001)(38100700002)(31696002)(86362001)(36756003)(2906002)(66476007)(66946007)(66556008)(4326008)(41300700001)(6916009)(8936002)(5660300002)(8676002)(2616005)(6506007)(26005)(186003)(6512007)(54906003)(316002)(478600001)(6666004)(6486002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2t3dExadkZ3NVhTM3IwTU52eDVNMkE5OUFabjVOSmo4dFp5QWFXekh5aWsv?=
 =?utf-8?B?NEx0cWpwb1ZQT0NYN0pOb1VIR1FSRjh3ZmJqaTlHbmxNb2VmRGo0cjJFMzgz?=
 =?utf-8?B?aWJyVUNUemQ2K1B2YmJJOThPVldiTGdzVmpKQXlWalNISUNqdis0bmQ4ZVoz?=
 =?utf-8?B?VjdlNXR5L2pDcFVUTHpKclVkdlRtMjJJb05tODJkeDcybnZkUGJwVytqVnV4?=
 =?utf-8?B?L1ZKTUVEU1NDRkIyNlJEZDUwVk1GRE1DdXpnem0zVlVKb05BQmwxWU01bXBN?=
 =?utf-8?B?Ujh2MkhiOHd1bit2TXJ4eWV2K0ZoVE1wS0dKcnljN0NjSW5SNFBvT1dmQjYy?=
 =?utf-8?B?QVRya1ZuVHpKcGJtQ04xaWtkaHE5eE9aeWJjRVpyOGVjR2JpcFdkSzVRblYw?=
 =?utf-8?B?eWpRRDlIQWVJRDNlVEUyRmswemdnYTgxMUNUdlNQY092RDRJL0FXa0dhYUxl?=
 =?utf-8?B?ODMrL2dpR2hMQnpMa3AyNXJpS0d0UDJUS1I1cXo3Z0xiSWpYVGw4enk5bHdw?=
 =?utf-8?B?QThKL3RJNGQzL0srT1V3WWd2bXh5dHFrV3ZaekMvQUhqd0Y1UDg1eXdjZWgv?=
 =?utf-8?B?VThuYi9Ga21IRi95cjVPMnhCNU5KVllBdXNvaE1RTGtXVzA2N3BJcjBRZVc4?=
 =?utf-8?B?VGY1T2dGSkFnUkF3WlUyZnZmb1AvNXJNZ1VXRU1tSVlRN3Nyc3RuUFcwNFFa?=
 =?utf-8?B?STArNy9RMlhaRWpCZGRvcjdGY3BpalJsTmhEWGNnNWNTWDgrWnRNemFaRDZB?=
 =?utf-8?B?bXhlaVEwOG1FYlZ5NGM0bUptVVFyYVBSclpITXNZK3BjYzRMUXorSXBFQlFa?=
 =?utf-8?B?SDZRMjBVVEIrYmNaaVE1Q2JaK2hNZkVRbDFqSGdDK3NTYUdoZksySm1WRWF5?=
 =?utf-8?B?YURFby9QSk4wMlNxQkl2U083UHVOSnJFeHV4alFnVVBKSkFWcEh3N1BScGZr?=
 =?utf-8?B?TTVDNXQyYTE5QzB1U2cwSnVVdlBTODZ1cjBwdXo1VFhYYjhGSnIvOWxESURO?=
 =?utf-8?B?S1JJS1Y5WkpoY1VvUjVJcy9YeEtsUDFBMklrczJ5QzVRZ1FWdldobmwrOXdh?=
 =?utf-8?B?L1ZQMUw0Y3RCUEtxUlh4SVRWNmdISUhjOXZHb0JNUzdYWEg1VTRIVm5LR0Jt?=
 =?utf-8?B?dDZGN2k0aGNFZmtGMkppdzM0c1ZtdlU4a1JkdDF6YXR1UVcrUWFrelB0WG1B?=
 =?utf-8?B?Y3RCMmNraFZMT1hUZ05DcHZhLzhJS2l0ZmlzNDFZalpSazFkUGYvYnJFSlYx?=
 =?utf-8?B?ejBqcndhTEpQbHBNNVNsdUZBU1hROGV4SDZOaisyZWFkeUwzRTZVTGozb3Zy?=
 =?utf-8?B?UkN0TkYwUVMvdkhIcE9RTm45bTRUMjdRVXc1NlJqS1BUT0NsZDdtdjN3bGpH?=
 =?utf-8?B?ZXJMWTVJTVhPVkxnT3AzYnQrNWx3RklVRWdETW4rYnNWVmRMa1ZzR0xlRjkx?=
 =?utf-8?B?N1hFd29na3UvcFBJQVdodURDNGlNUzZwdzJ3bTRvTDhwWXdacWtoTENaK0Q4?=
 =?utf-8?B?ME9oSGNPUndEcTJhbWNFUjhMaDR0VU10ZERLb3A4cndObXErdlhMZzhlaG84?=
 =?utf-8?B?WWMycklaeXMwTThqWHRLSVFUak92MUdlSEJhYTNPOFpvU0lZaEUwZnhucUFR?=
 =?utf-8?B?WEg4dE04YjZZMjQ1NHJWdkNmbGJ5U0V0VG9sa0hLYkNhRVE0WW5zcDljS3Rn?=
 =?utf-8?B?VnFZSVcvbWRyODlGOEhUMkszZjRwUTJVbTVYZFFxa1dWdzI4S0dqSEtJandw?=
 =?utf-8?B?eTVZcGdzUldJZndlaERKUWVQeEZpUkM0eHVpVHFpWlNhRVJ0Ujl3K0hKVERa?=
 =?utf-8?B?VHRxVngyeXlKUDhpaFpRdDUrcjAzL3pvMnFvMzR6cVQxTU5TWHI4K3J5ZjZC?=
 =?utf-8?B?YzVVTnJWdFU1OXJXWlZaeHltT1RhdUhRbjRBSW00Q2tVb1pXQncvMXdlaFNq?=
 =?utf-8?B?NEU5MElDcW8zZ292WVVVdXU0dTJqcTZVUjJBK01ucFlaa0dvRVNCT2tXZWVH?=
 =?utf-8?B?dHNaUlc1ZGY5clFBbkNtRWh2V1crVUM1OWlkcWl0U3VBQnI1bnJuSVJIYlZZ?=
 =?utf-8?B?b2YzdlFhVGdtcFNxOExvZGlPcC9pai90NnY1eXN6TDZENW5ORUR2TWFmb1c2?=
 =?utf-8?B?c1hEMWJFS1V2TzI1aGxUOWQrNW9pcjM5ZlR4dFVVMUwrdDBzNDBxU25aUkpZ?=
 =?utf-8?Q?aBCIUZF860y/0SkPq4vFKC8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 65eb013d-7705-45e3-a9b9-08db19a6c141
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 16:13:40.3284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s4MJkBP0RS34bHFoXVY7bxIDgLfIQvCFuTJaCNaSS9kWILsUw6pQG8RgDrvRsmnCEsvetUIERn3wVop0Z4Opj5dUMw7a4Lzo2ATZ6UZo2I0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6973
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geoff Levand <geoff@infradead.org>
Date: Sun, 26 Feb 2023 02:25:42 +0000

> The Gelic Ethernet device needs to have the RX sk_buffs aligned to
> GELIC_NET_RXBUF_ALIGN and the length of the RX sk_buffs must be a
> multiple of GELIC_NET_RXBUF_ALIGN.

[...]

>  static int gelic_descr_prepare_rx(struct gelic_card *card,
>  				  struct gelic_descr *descr)
>  {
> -	int offset;
> -	unsigned int bufsize;
> +	struct device *dev = ctodev(card);
> +	void *napi_buff;
>  
>  	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
>  		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
> -	/* we need to round up the buffer size to a multiple of 128 */
> -	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
> -
> -	/* and we need to have it 128 byte aligned, therefore we allocate a
> -	 * bit more */
> -	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
> -	if (!descr->skb) {
> -		descr->buf_addr = 0; /* tell DMAC don't touch memory */
> -		return -ENOMEM;
> -	}
> -	descr->buf_size = cpu_to_be32(bufsize);
> +
>  	descr->dmac_cmd_status = 0;
>  	descr->result_size = 0;
>  	descr->valid_size = 0;
>  	descr->data_error = 0;
> +	descr->buf_size = cpu_to_be32(GELIC_NET_MAX_MTU);
> +
> +	napi_buff = napi_alloc_frag_align(GELIC_NET_MAX_MTU,
> +		GELIC_NET_RXBUF_ALIGN);

Must be aligned to the opening brace.

> +

Redundant newline.

> +	if (unlikely(!napi_buff)) {
> +		descr->skb = NULL;
> +		descr->buf_addr = 0;
> +		descr->buf_size = 0;
> +		return -ENOMEM;
> +	}
> +
> +	descr->skb = napi_build_skb(napi_buff, GELIC_NET_MAX_MTU);

You're mixing two, no, three things here.

1. MTU. I.e. max L3+ payload len. It doesn't include Eth header, VLAN
   and FCS.
2. Max frame size. It is MTU + the abovementioned. Usually it's
   something like `some power of two - 1`.
3. skb truesize.
   It is: frame size (i.e. 2) + headroom (usually %NET_SKB_PAD when
   !XDP, %XDP_PACKET_HEADROOM otherwise, plus %NET_IP_ALIGN) + tailroom
   (SKB_DATA_ALIGN(sizeof(struct skb_shared_info), see
    SKB_WITH_OVERHEAD() and adjacent macros).

I'm not sure whether your definition is the first or the second... or
maybe third? You had 1522, but then changed to 1920? You must pass the
third to napi_build_skb().
So you should calculate the truesize first, then allocate a frag and
build an skb. Then skb->data will point to the free space with the
length of your max frame size.
And the truesize calculation might be not just a hardcoded value, but an
expression where you add all those head- and tailrooms, so that they
will be calculated depending on the platform's configuration.

Your current don't reserve any space as headroom, so that frames / HW
visible part starts at the very beginning of a frag. It's okay, I mean,
there will be reallocations when the stack needs more headroom, but
definitely not something to kill the system. You could leave it to an
improvement series in the future*.
But it either way *must* include tailroom, e.g.
SKB_DATA_ALIGN(see_above), otherwise your HW might overwrite kernel
structures.

* given that the required HW alignment is 128, I'd just allocate 128
bytes more and then do `skb_reserve(skb, RXBUF_HW_ALIGN` right after
napi_build_skb() to avoid reallocations.

> +

This is also redundant.

> +	if (unlikely(!descr->skb)) {
> +		skb_free_frag(napi_buff);
> +		descr->skb = NULL;
> +		descr->buf_addr = 0;
> +		descr->buf_size = 0;
> +		return -ENOMEM;
> +	}
> +
> +	descr->buf_addr = cpu_to_be32(dma_map_single(dev, napi_buff,
> +		GELIC_NET_MAX_MTU, DMA_FROM_DEVICE));
>  
> -	offset = ((unsigned long)descr->skb->data) &
> -		(GELIC_NET_RXBUF_ALIGN - 1);
> -	if (offset)
> -		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
> -	/* io-mmu-map the skb */
> -	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
> -						     descr->skb->data,
> -						     GELIC_NET_MAX_MTU,
> -						     DMA_FROM_DEVICE));
>  	if (!descr->buf_addr) {
> -		dev_kfree_skb_any(descr->skb);
> +		skb_free_frag(napi_buff);
>  		descr->skb = NULL;
> -		dev_info(ctodev(card),
> -			 "%s:Could not iommu-map rx buffer\n", __func__);
> +		descr->buf_addr = 0;
> +		descr->buf_size = 0;
> +		dev_err_once(dev, "%s:Could not iommu-map rx buffer\n",
> +			__func__);
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>  		return -ENOMEM;
> -	} else {
> -		gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
> -		return 0;
>  	}
> +
> +	gelic_descr_set_status(descr, GELIC_DESCR_DMA_CARDOWNED);
> +	return 0;

An empty newline is preferred before any `return`.

>  }
>  
>  /**
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
> index 68f324ed4eaf..d3868eb7234c 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
> @@ -19,7 +19,7 @@
>  #define GELIC_NET_RX_DESCRIPTORS        128 /* num of descriptors */
>  #define GELIC_NET_TX_DESCRIPTORS        128 /* num of descriptors */
>  
> -#define GELIC_NET_MAX_MTU               VLAN_ETH_FRAME_LEN
> +#define GELIC_NET_MAX_MTU               1920
>  #define GELIC_NET_MIN_MTU               VLAN_ETH_ZLEN
>  #define GELIC_NET_RXBUF_ALIGN           128
>  #define GELIC_CARD_RX_CSUM_DEFAULT      1 /* hw chksum */

Thanks,
Olek
