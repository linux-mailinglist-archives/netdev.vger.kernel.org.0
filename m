Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E5F48ACFE
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 12:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239250AbiAKLvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 06:51:50 -0500
Received: from mga06.intel.com ([134.134.136.31]:23128 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239135AbiAKLvt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 06:51:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641901909; x=1673437909;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8p/BiT7fhF+HtgqDZZgXe/Us+1u20PPykP2hq75gbNI=;
  b=FnO6SKNfLdyjjAi1iZh/ZfRHZS/lOiouEBmxUALCM2lhM4OR/iRnERa5
   cxbQZOtSezriabu0U8x8U4/sRbDh313KtTKequBfC7qrCjDGMFmQ7eNn3
   0TBEeBwrY7OYZtlZS10uGzfTZTr/SlT5uwS/yCW1N12ew2DNNN5EpAQ5l
   Ym7MgH9/0YczYCuBf+Xu8U0KsVcmWVXoixdAXLeI4M0ra9ij3uwbLYv32
   I11nBpfgH2VBvwnRMj4bUyrvNvSyBe1wu1vtCfd8uhZd29XrBvN/MKTku
   qzE1COzsO7rd/250e1seAhwjanB8JgqvxT/EgEanKsg4PxhCdx+w/l7Lp
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="304205589"
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="304205589"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 03:51:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="576182250"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga008.fm.intel.com with ESMTP; 11 Jan 2022 03:51:48 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 03:51:48 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 11 Jan 2022 03:51:47 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 11 Jan 2022 03:51:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHwpLrlxXCuy5AWATcxtMeK6otNcFaZEBuXLsjFI7Hh1d5rBrmY66GliQpTjfftPqV/vY9i3UnAZlO/tpjBTgNY0ABsTO0sZPDbr43FtnKcT97OLiyLkIzF9T8tJ7J6avG10fOvW/yDPMCTy2ZKhk5WZUgLhNEhq2mnUwzBKN1j3MImpfJ+0GD3TRfs39X62Sg9i2oQj8xRI7kRTu99/zw/hLv3k7wX6/l4bhBlr5YCAORFcoE4UhLqryYwYS29UiWc1BajfXyy8kNOUTxZM814cb6Liu/0AwRzS58IJ+mpFWSRnspl9YFh9MgXSPrEVRwezLJ3EM/cAvzosDXkn5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8p/BiT7fhF+HtgqDZZgXe/Us+1u20PPykP2hq75gbNI=;
 b=hhPxYjM81lEcSBw57B3JK7kmMmHS2s/S2OqubqEwQLpg6mqT390kSI2toKm6XS4SdyYA6B6nV8rBEmLb9g2HCRjtyEXuWtp8qM2lkK9SkzFan4t56WJTIxOEZrXzW9Ayez4CE48S2exLhfd59n/dPDnBTSN3zL4rU5DcjsnvoomCD8dEvTXn7KSZm0nBcjtCKgcAYaZTHrEe0VZEpTe7UiIcTj013DpA1LIhZ+Y/jo/fM2UcQfYiA20E4LJabT8f/7fTgwa795L7bnx0l4mxBRdb+x3xES4tAriSFF4s/dCgvDjFG2p+hKsea+AumwqaUtXk17QZzHntEK56Nf69jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by MW4PR11MB5934.namprd11.prod.outlook.com (2603:10b6:303:189::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 11 Jan
 2022 11:51:47 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::42f:73e3:ecb1:3b75]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::42f:73e3:ecb1:3b75%8]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 11:51:46 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     Song Liu <songliubraving@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>, KP Singh <kpsingh@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH v4 net-next 8/9] ixgbe: don't reserve
 excessive XDP_PACKET_HEADROOM on XSK Rx to skb
Thread-Topic: [Intel-wired-lan] [PATCH v4 net-next 8/9] ixgbe: don't reserve
 excessive XDP_PACKET_HEADROOM on XSK Rx to skb
Thread-Index: AQHX7D0V/4WGMGM6NEelJP0aKGyShKxd6pWA
Date:   Tue, 11 Jan 2022 11:51:46 +0000
Message-ID: <MW3PR11MB45546CBEB4E1427EA5CD65C99C519@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20211208140702.642741-1-alexandr.lobakin@intel.com>
 <20211208140702.642741-9-alexandr.lobakin@intel.com>
In-Reply-To: <20211208140702.642741-9-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b9194d0-58db-4978-9d0c-08d9d4f8beef
x-ms-traffictypediagnostic: MW4PR11MB5934:EE_
x-microsoft-antispam-prvs: <MW4PR11MB5934054BF4B04FF43640DB4F9C519@MW4PR11MB5934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sirVFWBrtRWLI76zUDNZTHp3Zy5COuCH13qWM1eMXVA1RJAB6EXnIaUGlgC28D2p+WJ2UA8tMH9iv53m2dcMldgkUDqbyGKOloj7tHYflRbDInbpIKH/GYEIX1y+pK5emt9As1eSkDdlZeSLfrlsgV9NrVOADwpc97+ni8pKEZdoePJKaTc8qVtQ9lCdnL3kV2i0W0bTUfYgmvBf2w5xVdYd5edwg9GoOGEGLT5wfXkTKozLBnyC4Cq5zpNXXI4rBdXiwgRLOnU5ZT/2cpyQx2VE/n43oy/tsuclENmnt7h35MLqfUtpreeyHOPdaJtiiBMtmbn5hr/jVobrjxMjld0DrDiz88O9FpQFVZrmmxwBA9SpymG8rA3Hnd/JL2UpPU70z3oSA5j3uOJE8OXFT1xMYKcgILmZ5Z+3zrLXLsRuljo3LLb4IMV74Rp8wPHRmjCim32E3ywBqLCMkQeVq2wLMA9cE/8LHDtshq5Vw2jIKztPBwgbilVayN3VSYi5kGPQTLZCV7jx6d3BnNXd0TYOPNYL38TI9Opb6TLmVWeULJ0KrA1MhVaapyXEmolAKsUPAiyDLhv9G+iK5c901H9DURxibnc5MSa8yDRX0Ww1Y1IYCzfSkbJ8A8haO32Zb8248tRbDSGmr4+2qvZ1/7NGmHQNBCosSNgpOIhDXJuhahckEZiJi/RNZoDIxlC1sZk2K9ocWJHf6UOhzAacKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(6506007)(122000001)(186003)(38100700002)(83380400001)(82960400001)(7416002)(2906002)(52536014)(33656002)(38070700005)(508600001)(9686003)(76116006)(5660300002)(71200400001)(8936002)(66556008)(7696005)(55016003)(86362001)(110136005)(54906003)(316002)(4326008)(66446008)(64756008)(66946007)(66476007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?N1yjlsJDSCC42MAe1nrMskKizRelt+YNpc8JIjBqABpjffbnsmTzkdl7yN?=
 =?iso-8859-1?Q?2/rotwoWEHeyiScgpcmsuscvfxFnA/n4v5VD9M8ZIFq6qmHwAn5F/JhDyl?=
 =?iso-8859-1?Q?evLHH2VGXAVA+tT9EOmNKdRjMr/4GDJlG4k/VjMKSii5YOUekQYjGv/g21?=
 =?iso-8859-1?Q?FgkkvUGJokqHkqU5f+EvGaeYsTP8ju20wab+kqrEFODGu6r/pVCZXj1BIC?=
 =?iso-8859-1?Q?hcyzRlmqj+fh64IUpmh2rPHqCJmjITrCkmusEzqV+KaBUoa2i0dv9dKUS6?=
 =?iso-8859-1?Q?nq7N5kjKdRWVOHaQ9vlpGivB2elFqoFS9n336NnitlZmeSRQ8sl3yArABR?=
 =?iso-8859-1?Q?v+dQEz+ux8SEFIwd3rmHOt95nh/l+dfTl4CfWujqP9QJBA4crgONEhRErN?=
 =?iso-8859-1?Q?Zxzr5iYfKQWshCzRgn/xIuXk3izFyz3Z0OQTjnMtknVxONutDsPHiSiqIg?=
 =?iso-8859-1?Q?7mUd8WIWoAwDfBjJPlRzYIAK4wOJryPH/4BjE74C3UqqcYlXNyTctSMNx5?=
 =?iso-8859-1?Q?rgjpYIhMcxRJIgmdwVBmIW7rMU3ceAx5J9PJVrxgr3O3tL+R+bhtUEWkDd?=
 =?iso-8859-1?Q?424Sg8YHlgiTcz1q2X8iRm4bD+3EWkcAgqnFF27dOyI1Twc47+brjfT0la?=
 =?iso-8859-1?Q?w/6PbUXiqm2ey2t77yIP08XyipEVzxfXtqSsqMJZQhqDsxeB3CiA1PW4mJ?=
 =?iso-8859-1?Q?SJquEcfrCbj2g0CaaoE5Kz10T46jh5LMnRt8XQssGmHwW3uI7/FGl8YjYI?=
 =?iso-8859-1?Q?5FmR6up5yOW56YYq1ZNDytR3lcdhCyXoKF1NP2AkSvT0Yek6mydG9pY7F2?=
 =?iso-8859-1?Q?iX5YZPH6AgytiPWhtVVAk2iRDwvveFK0nGGHaJ0modt7RthkkkYYYS9aNN?=
 =?iso-8859-1?Q?rz+zKrBmLHS2M4Jm9HHeAR+zQ3898BL7ei3L6KWAQvEWa3oOT9jgoKPf+Y?=
 =?iso-8859-1?Q?U0IiX9lNwC42Uqa8c8pIWmI10vXpsFScSJIOIfSKbxunZSENvX8c2/wcpW?=
 =?iso-8859-1?Q?CwU5OzMGzsF5WQMQZlli1xRk7XYSkinbzbgg+dOACmP465QbqsqgiAlKIV?=
 =?iso-8859-1?Q?8rP0R7dozsn44OqrLe1balIapH4NmVtISPBcxwJmW80V0Gtryqa2wZz7T4?=
 =?iso-8859-1?Q?OXRK/CYfBE4H524NJbe+ZUi9hJOLFq++XJhW0flA/AUdoGa6upIDfNNFUd?=
 =?iso-8859-1?Q?4PB4jZt4GZ5o+Zcahr6Sb/N8pwsySyTReM+JiBFnKWIcCQkI2ycEpyRNV3?=
 =?iso-8859-1?Q?57Q0YiBPAeAR9Ea1gjYNlDZb8WHAtbx5RBWVtwjHDwVOUb7xyYYOgdZCPp?=
 =?iso-8859-1?Q?FQ59S1t8MqY432wuRCPZ+EWMLGiU7qgCWum1A6fccSQUxwg/EQAG6dHnLa?=
 =?iso-8859-1?Q?jP5WVQuSwqj1fEf/57t27TcWr0L11x6zSLVeEcDIJobkYI8DJg/q6mSpDO?=
 =?iso-8859-1?Q?tNHkOgOf3p9KTbcH1ihAQq9NWMOn5FWREVUBnS62ufbsYHwSPX+PP6e5ko?=
 =?iso-8859-1?Q?EmqPT9N5mCRO+TZ+quzZy2LyDB+lgJkSlLFd9/Wzs379rHcEN+MMm+CI+E?=
 =?iso-8859-1?Q?nUehHRjX10sSpn72bHyIn6FWFXc5Duf2fbTVeJ2S4ED5iZxibocrW06YAR?=
 =?iso-8859-1?Q?BhKvS7EF1CQDiqtP9f6NAqaKpIRqlmAf3JcGmZbmlczTGooNOktLlPna3L?=
 =?iso-8859-1?Q?THIOJnN28hxXjWhtgkIMps9+lTT5+gotCGCyGW6hqqQYuYQcdWPZneQyvQ?=
 =?iso-8859-1?Q?p9lQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b9194d0-58db-4978-9d0c-08d9d4f8beef
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 11:51:46.8894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OnE0PvWf1F66Pvmeekcfqeg+/iClwAt9ZpbNXxDUo8PBk/x8/4ICaXEVt51m+Gn9nNN4lC2m2FG6PGYBHmmpKSFXKwxpxOa0t9qX1tdi+RE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5934
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Alexander Lobakin
>Sent: Wednesday, December 8, 2021 7:37 PM
>To: intel-wired-lan@lists.osuosl.org
>Cc: Song Liu <songliubraving@fb.com>; Jesper Dangaard Brouer
><hawk@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>; Yonghong
>Song <yhs@fb.com>; Martin KaFai Lau <kafai@fb.com>; John Fastabend
><john.fastabend@gmail.com>; Alexei Starovoitov <ast@kernel.org>; Andrii
>Nakryiko <andrii@kernel.org>; Bj=F6rn T=F6pel <bjorn@kernel.org>;
>netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; KP Singh
><kpsingh@kernel.org>; bpf@vger.kernel.org; David S. Miller
><davem@davemloft.net>; linux-kernel@vger.kernel.org
>Subject: [Intel-wired-lan] [PATCH v4 net-next 8/9] ixgbe: don't reserve
>excessive XDP_PACKET_HEADROOM on XSK Rx to skb
>
>{__,}napi_alloc_skb() allocates and reserves additional NET_SKB_PAD
>+ NET_IP_ALIGN for any skb.
>OTOH, ixgbe_construct_skb_zc() currently allocates and reserves additional
>`xdp->data - xdp->data_hard_start`, which is XDP_PACKET_HEADROOM for
>XSK frames.
>There's no need for that at all as the frame is post-XDP and will go only =
to the
>networking stack core.
>Pass the size of the actual data only to __napi_alloc_skb() and don't rese=
rve
>anything. This will give enough headroom for stack processing.
>
>Fixes: d0bcacd0a130 ("ixgbe: add AF_XDP zero-copy Rx support")
>Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>---
> drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 4 +---
> 1 file changed, 1 insertion(+), 3 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
