Return-Path: <netdev+bounces-2653-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40490702DB7
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:11:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED5F2280D0F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC12AC8EB;
	Mon, 15 May 2023 13:11:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C919679D4;
	Mon, 15 May 2023 13:11:38 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D8130FF;
	Mon, 15 May 2023 06:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684156279; x=1715692279;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZZeioi8rdQ60LYNBboy0f8d/uLsFvpcOfgARL23AxLs=;
  b=F0MKPtMsslqGudSOxyvB3oPr+5aCSbv8r1dZdLz6uhmnho9ZBQ0sqRMo
   Ilujxuz3TCFZ55sDSqDDYIakBpie6uh1zPqV1AGkiOLPY1MwCJOKapp+K
   9EHVe+Nel+Do6e3yU2jHKQoNQQ1mRVjiE83Hur/1qe2oMX6/uTtzlfXz3
   VmMxLtLvx8Zrstei9zEXf5OFQBmIreqCVzL/VJ0qc2QZlJj6qXniAAITD
   RU1+gg3LvI/YlKKFZxIrjbNIu4G7Hx8dPF4xvrE0UxQUqHj3Mra1XjgeN
   /ZwVHv76QdNi+XMPn4/ZKyKna576Rc21ms+f1g4Y75hw8PUONQ4mqTB5q
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="351229457"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="351229457"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 06:11:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="790642283"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="790642283"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 15 May 2023 06:11:18 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 06:11:18 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 06:11:18 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 06:11:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dragWl/ylz6iGtIcV18TkND56WTV3Auz4thdsJyqUn0AIpIj9NjyYTcB4vRAdIaxJG8b86pk6yu3ySK4xi5VurEw81KwPouyaHvLTsdCxs0b0vCsTBUoZX95V2ZF+p9AgbO7X2KhmdpwY1bKGb8arWLytsYBVNuIS+AUjXW9VxSYq8ISsDVz5b4I0WQ3i+GQ5LCqrp8OyPR5PD0DLKDnHoCpxJ6YgzfDN+dRI2Y/P6J7voieSR4H43I69DUx/oO1ACQHj/lkRhZY1U6587HGe0AmjB8saXqljVSVYIA68/AMNxRgZ+IlurQRnzNDMY5gsJKYudWEowA5JyKKbsp9mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMSZufySicNoPOMlmBjpLiCxBC5jwQCvM6CjX+3LxT8=;
 b=YfiSPhrV726rM5qUo5KtqDQeBKZBQKVmxQYoW/zlKQgOauiMEBYIL7whdoRd5+UuPibHxElN86C1OBJm47xu9vPrGu27Wl2PLRKIip3p8J4OhG5E67UBWLropJ66zkJsYYTAM/2CMzhg4MK0jZ6eFJOUc9wugaB7pvzGZQjUDwzZlXDy70VFJnkJLO/c1+ia1bxkJJGHNwxsPwijPJ3s2E8d1+/3eDCJUFDM2Rz4U4MEaKdOElT1Nc2q6IJh8k8ovSzcxh2AcP4nTeT0jY/GU7QM7ln7vnkP3VSiNqLsEV99SephPXzMZPdVl7qyESopusnG+gMeERTqXuoTJoZ9ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SJ0PR11MB4864.namprd11.prod.outlook.com (2603:10b6:a03:2d4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 13:11:16 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 13:11:15 +0000
Date: Mon, 15 May 2023 15:11:09 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
CC: Yunsheng Lin <linyunsheng@huawei.com>, Lorenzo Bianconi
	<lorenzo@kernel.org>, <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
	<hawk@kernel.org>, <john.fastabend@gmail.com>
Subject: Re: [RFC net-next] net: veth: reduce page_pool memory footprint
 using half page per-buffer
Message-ID: <ZGIvbfPd46EIVZf/@boxer>
References: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
 <62654fa5-d3a2-4b81-af70-59c9e90db842@huawei.com>
 <ZGIWZHNRvq5DSmeA@lore-desk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZGIWZHNRvq5DSmeA@lore-desk>
X-ClientProxiedBy: FR0P281CA0213.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::7) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SJ0PR11MB4864:EE_
X-MS-Office365-Filtering-Correlation-Id: 376c11ff-a9cf-4e8a-488f-08db5545dd23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0WSpuvb9e+zMsQwUhhp4jfpX6u6zwlvtiH8+mWla0RyUGqNPKYKhmGczREsvlm8vmyE2ViKgDYmvl5NSc8dl+BWBelwDIAWDtlW+NAWULZ+EsBalOQSNbykW3cvNdyyKaMO7sUl1FV6q+S2ErZ4Txi5f9h58zAl0jDqhWuVwmfUSk3DxQDjrMBVXTeyyZOgXPPbVfKzAzUFDmv3dJhjcWd372J+r0xoqY02HgnfXFAN6dJNrYpUUNYGAqbxUzYNj3HnbHoDVMY+Uuh0Ja7qmjLBZXamPrFRhgF78a/cEYcTxfioF+i6ZZqQvKdISsTjYeQhbVxrTr3d0mwTr1G2JCFbS2Vmrrt8kbpcqG/zwH/wT6RsdIjOMgdImPT5NQjqWYDU58QStsHMQCPffACDzaeiwTxUXQkdtZKtKIhU9phNfUH/NC5DmBDqw3LbqbNAZzm/DaeLc0AcjJxMI/V5A6omfPjaHNzg4/r6S93wVk+k25719B4Ss1eN+WqtLKu612OaBHv0xLF6H29FP+9fUHsjS7m8TObJW2vWze3Sk5SlQNWxX1c9XCOBy8k6pfGaZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199021)(6666004)(4326008)(6916009)(66476007)(316002)(38100700002)(478600001)(54906003)(66556008)(66946007)(33716001)(5660300002)(82960400001)(41300700001)(6486002)(83380400001)(8936002)(9686003)(8676002)(26005)(186003)(7416002)(6512007)(6506007)(44832011)(53546011)(2906002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LJ1SZZbXBPCUz+88OEvNgjPyxsK+F8vAH/lOobZLds2rgv7+PD5SyD9F2vhV?=
 =?us-ascii?Q?Wpu7UyNLQ1rGRN6uULixprWuXCZ0XmlMt0KSXKzPlZ5KYckNtRxoWiMeP0Ga?=
 =?us-ascii?Q?x1P1Gwj65v9CDiinWGyUn+jeehS2jvVT6UG+OV+J++S/klcGsNdY89NYPm1G?=
 =?us-ascii?Q?bTw59Wh/XXR4tJuDvqF3vw37G91FVW3dqcqp9QZlQ54hlsLKZIVP+qEmStv/?=
 =?us-ascii?Q?UcKSYRUZwM9m+IR+n/nF/+FkxJkuCP+f5A1oGU18gftmQwhB5jB6AZc4s/Zo?=
 =?us-ascii?Q?sRSDwtJv8arYdGvsZ69rdR7/mDFcxjCahmvjqabpFvwovt2yDefa0wRrGjTR?=
 =?us-ascii?Q?WVAnqc81W6PniMLDiYcoZBOWTfYLZT8rxEMNATr2Ui/1ZW9RTsaGMKUy2H+L?=
 =?us-ascii?Q?OiJnvZSUBw72su5g2GoYWud80wqD54pzm7Za663eXdiazXe/sDJYeGpqMBa0?=
 =?us-ascii?Q?kgwb6+SQ4GU9z55cSI1DpaOx1qHlEz9NdPJyNC9FmB6x4VRiXBsg8onb21AI?=
 =?us-ascii?Q?axM/LMcdfXJuKgQclN2OUWBov4P39FMHFPKxcFtfvrvfBM/U4+SeaP/koDRg?=
 =?us-ascii?Q?6/tAZn5lOLtk/t9fCoVDcKROorkdmFL4n/ftVzmBpX25tTvrvSs4V7M7g/lz?=
 =?us-ascii?Q?txSCQ8BG5lVorAxQBa94tNiILnrNfWvM/UK/5seABAo0njz43Dl8JUZN0Eva?=
 =?us-ascii?Q?Hdy41iFjGlab/kg108+62+iwuFAVaN99pLX+KdqDstQ52rr5Qf0mPE8o0tvV?=
 =?us-ascii?Q?aPZOWi9pQdYyNIEMj5LlQDs47nVwmfP8sLMzGwvFecYrOEnZ2kH+uX7Hd2Jf?=
 =?us-ascii?Q?DjUlQGSsYBnJO76r6NzWMt5geHbCajhHq2Ml+JsDBpaOFsnbbZpIj6vBdXAy?=
 =?us-ascii?Q?IiiY1EfH3mj5VmD7DlWdArt97vJ6jbRE6d7EmVz2Sm/FaSe/nVEJJS9sNha2?=
 =?us-ascii?Q?41UNJFVQ3Xn3dHEwBbGETTJ3KgnM3p1opiqwD8PXsbKH+Zn6EafV1W7g+fEd?=
 =?us-ascii?Q?CQf71e+g22Q3HnfKjIC6Sf3PgDV1+5nq4CbKUW4HsufeU8mqvJMbQmCny981?=
 =?us-ascii?Q?JeFgaqPmVTWZ2h/F6UWj72H3BY9su3AmliJPOPu0cccDNGd5qW3WxP/s7oqW?=
 =?us-ascii?Q?hdfciOCO9kiPcmf2+e/iZJu/47njT/Yku3ggfHZwsIQa/BuOQF3mrL58Jxi2?=
 =?us-ascii?Q?Sr6U4/yZ9H4vK90xWuyEiQVRFrbW1NevkmZeVzCK8zP7te58sGpLyI+GuYAS?=
 =?us-ascii?Q?XcQoiV/2lGwJGp6Lylwh01TGuUovVzGjVJdBBABpH2zEm0o6YggR1HNVOJ2F?=
 =?us-ascii?Q?cebvMjuepbz4Os+wkxMGn9NqOhm/F8XVjC2dJFmAHoLXa+OOqG/nktWA4gjP?=
 =?us-ascii?Q?+ssYV1VlAiwEyssr2tCG9lI9pwghNIYPTHb78/1ehRUjt6btSiMsnZXTdzKk?=
 =?us-ascii?Q?yI8qY9sauHqA+C2hoZJX1X0aNMgLwAP+J5to1azRzRIvPUjQUdwpcz9qUOgr?=
 =?us-ascii?Q?v99vCsfjiYClfsodM7W+4dBoSnuYf+lWG5dSQziF4/49B7na3u1g0K4YflJJ?=
 =?us-ascii?Q?zQ+uoSHZgaakGTZMfQa+uYjrjU0JxMBdZtiDYsiI9B8+CQqtroS/jC4PXST7?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 376c11ff-a9cf-4e8a-488f-08db5545dd23
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 13:11:15.6960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y6JMI45pv/L7ge1J6Cu/Ph9mNq9tL7QZBNlYQUipvJqf+dImw6aZRZM5kNEp5L2ceSVFaOxMeG2eLYerYYFoYrwQIlvsoK1CNkjtXERTiik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4864
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 01:24:20PM +0200, Lorenzo Bianconi wrote:
> > On 2023/5/12 21:08, Lorenzo Bianconi wrote:
> > > In order to reduce page_pool memory footprint, rely on
> > > page_pool_dev_alloc_frag routine and reduce buffer size
> > > (VETH_PAGE_POOL_FRAG_SIZE) to PAGE_SIZE / 2 in order to consume one page
> > 
> > Is there any performance improvement beside the memory saving? As it
> > should reduce TLB miss, I wonder if the TLB miss reducing can even
> > out the cost of the extra frag reference count handling for the
> > frag support?
> 
> reducing the requested headroom to 192 (from 256) we have a nice improvement in
> the 1500B frame case while it is mostly the same in the case of paged skb
> (e.g. MTU 8000B).

Can you define 'nice improvement' ? ;)
Show us numbers or improvement in %.

> 
> > 
> > > for two 1500B frames. Reduce VETH_XDP_PACKET_HEADROOM to 192 from 256
> > > (XDP_PACKET_HEADROOM) to fit max_head_size in VETH_PAGE_POOL_FRAG_SIZE.
> > > Please note, using default values (CONFIG_MAX_SKB_FRAGS=17), maximum
> > > supported MTU is now reduced to 36350B.
> > 
> > Maybe we don't need to limit the frag size to VETH_PAGE_POOL_FRAG_SIZE,
> > and use different frag size depending on the mtu or packet size?
> > 
> > Perhaps the page_pool_dev_alloc_frag() can be improved to return non-frag
> > page if the requested frag size is larger than a specified size too.
> > I will try to implement it if the above idea makes sense.
> > 
> 
> since there are no significant differences between full page and fragmented page
> implementation if the MTU is over the page boundary, does it worth to do so?
> (at least for the veth use-case).
> 
> Regards,
> Lorenzo
> 



