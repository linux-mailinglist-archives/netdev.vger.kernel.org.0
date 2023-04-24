Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3986ECCB9
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjDXNLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjDXNLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:11:43 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECBC5274;
        Mon, 24 Apr 2023 06:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682341868; x=1713877868;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=zMOJJjMg18uvCpimQBHf0P9EYqwTrezrWTEinRHJJg4=;
  b=ZrBe0dSW9y0wulgjew3vEp1s/yo3wuGlhgvm4nXDzF9mzwgD8PxUjyvL
   8mw7Wgjw6BMqlIak5mo+RLreCMV8IJwa/ncEaOUHYufMkAaVGW2K+8X0D
   f+NJSt+dZHmIByEaAOquk847HMdZqB1qn45ZryF8Pv8OzG8HK81Z8zI5w
   ZOTNWCU05sqLHx3tBTf14qNeR4n44irO1SOTrgXdLgF4WGs6dnBdEOO9n
   Wo+Eo2XXgyeXAbsUtEztXwn54g4jJw3Tm+ib2UQfnUUaDDNc1MvMWBEv/
   xUsc5qfa++5Rb1NXYahYFWypail8R/gAT5HoEWPz0mO9FLK6C7LU9iuTI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="326055838"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="326055838"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 06:11:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="757694695"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="757694695"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 24 Apr 2023 06:11:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 24 Apr 2023 06:10:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 24 Apr 2023 06:10:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 24 Apr 2023 06:10:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzSkxcFptUqjWQDDD6GvxGIya1a537zfvj19W//f/M1qEaNMKXeQP/rig7QTrHaYdAQHOtut5yWH8yaSiqh5X43yHCEJKcVgy1ZaB5BcAPnWXjowoWhlz5oImZBI7OWmn1ksmgFakjvzhvxUFDUc064E9/iXXZwlcj514i7hWKmjYVg9vdau7SvVktXqhm/qkokTyVlGbLeRx+sIOrKgIKrG/U8+VA54tAT+OxQPBpeUk/mTUDR7icvAU/wLNInR9lbCBsskrvkktnMe2nUMA8yWcwK1AJ+7ApVEfXU1C2JaU5kp9U5+daetIlCa3+VXTeISvBWyq0YWs3bTXuKGew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30cS5BeLPzWexhvQN//jnLZOS2EOWU5KvA99FRpreZI=;
 b=d+7LtApXwNaFHOTW9ccwADHXzW5PK9LJ9CAqURcmoh23rehZawkEZzL2jgjDwf3VxE/kpXUmWiRHugdsMSxyxAc69Kg6JN9tmknKoHMWJj6bsaQJ+bsv1eCcd4LihGtFRCesF41WC26EmTygrr6MD/f+4AeTa4hvq0KhwC5vUaNsanF+gcPzOTbGXlI/uwwOQRu9s13RWoOb3EYpkc/83GeMTwDIXWi5/9h8N47CYhJzkjBtF0u4KLHONXw6JQpvhfIhu2EJVQWZfvxIZ7FrLkUjKa07IH8TMrwTWRijDYlAAn5UB4R1MCuE8xv/5cA/vODnyF/45/UmDAfuTg49Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH7PR11MB5941.namprd11.prod.outlook.com (2603:10b6:510:13d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Mon, 24 Apr
 2023 13:10:47 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%3]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 13:10:46 +0000
Date:   Mon, 24 Apr 2023 15:10:29 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
CC:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>
Subject: Re: [PATCH v2 net-next 1/2] net: veth: add page_pool for page
 recycling
Message-ID: <ZEZ/xXcOv9Co5Vif@boxer>
References: <cover.1682188837.git.lorenzo@kernel.org>
 <6298f73f7cc7391c7c4a52a6a89b1ae21488bda1.1682188837.git.lorenzo@kernel.org>
 <4f008243-49d0-77aa-0e7f-d20be3a68f3c@huawei.com>
 <ZEU+vospFdm08IeE@localhost.localdomain>
 <3c78f045-aa8e-22a5-4b38-ab271122a79e@huawei.com>
 <ZEZJHCRsBVQwd9ie@localhost.localdomain>
 <0c1790dc-dbeb-8664-64ca-1f71e6c4f3a9@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0c1790dc-dbeb-8664-64ca-1f71e6c4f3a9@huawei.com>
X-ClientProxiedBy: FR2P281CA0122.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9d::11) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH7PR11MB5941:EE_
X-MS-Office365-Filtering-Correlation-Id: 14198955-d66a-4823-8b45-08db44c550d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RMK7Eb0JrI6vKk8qyQz8I1kv0KGf5oDtZw7cMww+AZ9C+TPGxn4xRvLQafqJVmbgtphnR5tbatKRqCTYUST1Nc+ndQ1xYxLvOU3t7wixZrYLLc8hJ2EAlI8IVBFZk4lvE9ImXNzmIFUxVIP+eip7QnS7D4SDvlITcv//syWJBqZ3zN3oyZkK3KPSBDQaO1y1KUAHFU6/VAGfwrUIUiHf5Gne9q22TwR8hB1grtoXyJzLCcQQXQwwrHnYTlereba2XMf2701hZz7ds+D7TYYT9FeKYVXZkBqKMzOZQj9PR+sE1nbftvN6GIK0H2LLBdOrIb+2LoPc/pZdgvijATjcMbLb1OlYwR7soK4OcRgFSScusZZ5RlQA+1cG+ZwgdGjKrjBN3Kk1OwW3nqZ7ExlrPzoB8CYM0mEMnJ/1gjbU+m+n7ukDhQT1b1976AN7z3DhO0JNgIfbrGAgIt5chYSyZJUQij+ctZS2SZ3PVCb7COoVHf2EhfbhzdeDY1f1Dgm2BSbntrl/xTANwfukvuTmDY42dJe8sG5HjGoZjN1UdOsxiJdU4kRSdjGBRaIq+dQI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(54906003)(478600001)(82960400001)(316002)(4326008)(6916009)(66476007)(66556008)(66946007)(7416002)(41300700001)(44832011)(2906002)(8936002)(8676002)(5660300002)(38100700002)(9686003)(6512007)(6506007)(26005)(53546011)(33716001)(86362001)(186003)(6666004)(83380400001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ty8l8RkYxQ9pm00E0Xh/PCVumD5JxaNZ1vm27XCGRfAFgvmRDBkC0ys10CML?=
 =?us-ascii?Q?pwmvZHdp1FYhP4XQRiG1R5cEkzEHlCowwlx6/72nWFEbIigKL9FDKti1JOTI?=
 =?us-ascii?Q?BwJ2Wi2igijbOR9JJRxTk1//pL05LHK4sAy5PguiLUpVK6jMzXNEVjOdLbWN?=
 =?us-ascii?Q?+iIyCiqV/zaSYwxONFG+3uiQ0l4pAWByZbIlbdkEDp4m6WzXdNUqNZsTdGm6?=
 =?us-ascii?Q?hwoLZnMfifv67pUk44kf05WNUmjraf+2TixdiqxiokJcODo1pWe2PMHvu0lZ?=
 =?us-ascii?Q?N+QHpAhG5ZhgeL7hIcsTd4pqvLCiwFB6antSkGAtuXUC+dSW0Ma/cQ8kHZrU?=
 =?us-ascii?Q?uo1E+98geRNC9KaWtP7TUITKpiRtRIXO+z4C0LLQAN2YUZ/P5jcBESe0Zmwi?=
 =?us-ascii?Q?Rmyb5EOm+yBtiJ/8klnROMseQ6Cs5v/coOE9vShhAWiXjMMsr55ocMLtHbUH?=
 =?us-ascii?Q?Y9yaR7hgq09U9obuN1QzUno6COW/wa+PBNHrBAUqTIUoz4WaBsPMXvBhYrxR?=
 =?us-ascii?Q?119JTwOtzZDgifSVmrfDAU8IX4lWZEHygWG04Jz4RfYJoQHpmQpgAflSWvMa?=
 =?us-ascii?Q?vLbtjU8iAlkKMf0oReurgPPb+TuYvXpPe1dpmMIjgGE95gINBYvBE912AOnH?=
 =?us-ascii?Q?hNEp6CzYVXtcIDPZQmVrrtQKTBmqwVjcP0vM3d2AjH4Sue37iaDAd+QcAnaG?=
 =?us-ascii?Q?aITKBgacVAjctQogGjbrxzx4Mxraj7jpTpFIujXPYK4a+oZ8iM3PzAVc3jXt?=
 =?us-ascii?Q?lRzMGIIW9EiKr3FgfmIq9RTNB9D09Il6rZQcqG9JsXdQ6cb0ftNSyg9B+6sJ?=
 =?us-ascii?Q?OZ5WCwFqUW36hZuoPzNUPIaMKvOoEH3nucwwusCETXwmRfs7r4o2BCeZeIyR?=
 =?us-ascii?Q?lf4B8pu8Seh2fhbZ+yXyoxC3/XzGGUhtcXAhnPhhVHxVbHj2UYZE28+1BYzs?=
 =?us-ascii?Q?+3//OAiVFVHp8sIAJwX5iQ5L55Xdn2A49TI73mVAJxeYjFap5KL5h0kPr87+?=
 =?us-ascii?Q?LJdZMZBvAk43kXJU5mZTjAMmnyOm6WtyV2zh/815WKFPyr8UHVhu2g1rxao8?=
 =?us-ascii?Q?8YnduTz7kaqbIeZ5nV20+N5K3sgZ7Y/hFvCSM0XbgOKQGKRNms+rkH/Cwrdl?=
 =?us-ascii?Q?cvsDru5/IeiT4byPlpcpWZTM4vc8+tY40uimYgDmcYyswDUd9xSBi022ao/I?=
 =?us-ascii?Q?U8uSKzMGE34nOm/FTYtRvec+mF+SPBk9oe0+kryYj9UgNtTSpAnPkOjZ1UZr?=
 =?us-ascii?Q?nN9HvwkhR7lQvGB1ZX8rFhRABMesOWflzF9ryoUwG61s0ekmvANkIYMHERiW?=
 =?us-ascii?Q?/tMYGHuBkTHdQH7DPK0gc0btOkqsyp5ij5tiyQkyqlVGbe7X4lCRziuRu233?=
 =?us-ascii?Q?DGMqogYsgEUUV2RO8mmxHsUdi83k7CUNE5UlD+ERMF7YDkKB4FC5fP/MxJ1C?=
 =?us-ascii?Q?gXlMiE9+LCPQeVWkO1rf9BOQBpUO0RY2XlVg4um/cHGLrQ33Y1DdOtZLTfr7?=
 =?us-ascii?Q?0X1VZt3u0k7fGq3+mZ57RRER8D8JbkZyxCrm4vxwOVz4CKuHAcLnD2b4iZcw?=
 =?us-ascii?Q?R5qXFgKiRJg7R1rMrlusJzw0m5Gtvla2paVl1QeoX/JwJtD0frasDVzEvwIS?=
 =?us-ascii?Q?Jw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 14198955-d66a-4823-8b45-08db44c550d3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 13:10:46.1048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PqeWsWQ14a9MCjihKA0YEp2eMRpeUocJix9Jnlj6VQO+S4QktuZ0KGWE0NLCIHEJ9pTpI+xDi8FAuvCAnUQn7Vkepi6hjYKqy9dY4w9PS6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5941
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 07:58:07PM +0800, Yunsheng Lin wrote:
> On 2023/4/24 17:17, Lorenzo Bianconi wrote:
> >> On 2023/4/23 22:20, Lorenzo Bianconi wrote:
> >>>> On 2023/4/23 2:54, Lorenzo Bianconi wrote:
> >>>>>  struct veth_priv {
> >>>>> @@ -727,17 +729,20 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
> >>>>>  			goto drop;
> >>>>>  
> >>>>>  		/* Allocate skb head */
> >>>>> -		page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
> >>>>> +		page = page_pool_dev_alloc_pages(rq->page_pool);
> >>>>>  		if (!page)
> >>>>>  			goto drop;
> >>>>>  
> >>>>>  		nskb = build_skb(page_address(page), PAGE_SIZE);
> >>>>
> >>>> If page pool is used with PP_FLAG_PAGE_FRAG, maybe there is some additional
> >>>> improvement for the MTU 1500B case, it seem a 4K page is able to hold two skb.
> >>>> And we can reduce the memory usage too, which is a significant saving if page
> >>>> size is 64K.
> >>>
> >>> please correct if I am wrong but I think the 1500B MTU case does not fit in the
> >>> half-page buffer size since we need to take into account VETH_XDP_HEADROOM.
> >>> In particular:
> >>>
> >>> - VETH_BUF_SIZE = 2048
> >>> - VETH_XDP_HEADROOM = 256 + 2 = 258
> >>
> >> On some arch the NET_IP_ALIGN is zero.
> >>
> >> I suppose XDP_PACKET_HEADROOM are for xdp_frame and data_meta, it seems
> >> xdp_frame is only 40 bytes for 64 bit arch and max size of metalen is 32
> >> as xdp_metalen_invalid() suggest, is there any other reason why we need
> >> 256 bytes here?
> > 
> > XDP_PACKET_HEADROOM must be greater than (40 + 32)B because you may want push
> > new data at the beginning of the xdp_buffer/xdp_frame running
> > bpf_xdp_adjust_head() helper.
> > I think 256B has been selected for XDP_PACKET_HEADROOM since it is 4 cachelines
> > (but I can be wrong).
> > There was a discussion in the past to reduce XDP_PACKET_HEADROOM to 192B but
> > this is not merged yet and it is not related to this series. We can address
> > your comments in a follow-up patch when XDP_PACKET_HEADROOM series is merged.

Intel drivers still work just fine at 192 headroom and split the page but
it makes it problematic for BIG TCP where MAX_SKB_FRAGS from shinfo needs
to be increased. So it's the tailroom that becomes the bottleneck, not the
headroom. I believe at some point we will convert our drivers to page_pool
with full 4k page dedicated for a single frame.

> 
> It worth mentioning that the performance gain in this patch is at the cost of
> more memory usage, at most of VETH_RING_SIZE(256) + PP_ALLOC_CACHE_SIZE(128)
> pages is used.
> 
> IMHO, it seems better to limit the memory usage as much as possible, or provide a
> way to disable/enable page pool for user.

I think that this argument is valuable due to the purpose that veth can
serve, IMHO it wouldn't be an argument for a standard PF driver. It would
be interesting to see how veth would work with PP_FLAG_PAGE_FRAG.
