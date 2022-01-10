Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83372489609
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 11:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243674AbiAJKLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 05:11:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:27300 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243650AbiAJKLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 05:11:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641809508; x=1673345508;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J/CbEYxNybnfOKuDAvU+TsR13YSEuxbeYjtZ0ln5S/E=;
  b=eDefIc0QoltKnQxJ5y6Vh2SIWMNNSJSJUNRylNTpZ9YBy23uw4z0ayOm
   AuX1toFXgZN5sYhw82F07LZjK0XkX3oZQOF47Gnxtngkgik5ddxXkbTpY
   6YU569VvkvwgDKAKZ/ZC3tzvdVxPmumZHWovIcuJ+9PMvnHpyKeCAzrsV
   ZDilZ/+aAR4aUiDzulLNc+1e+/4pykaFRGT4Do9CKqcIhR5IAeAmFKJ3t
   VSnbTuk+qQ2IdjlNEsPHIjgfZsGA0o0RerlT4YO2r1n5fj2m0KqX/6RF/
   ohuQ9IvkodgugrKbsG8xWjPGCFQe0PAzN/U4lVioRjemdxUe+P2XOmKIQ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="267522970"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="267522970"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 02:11:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="514624302"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 10 Jan 2022 02:11:46 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 02:11:46 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 02:11:45 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 10 Jan 2022 02:11:45 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 10 Jan 2022 02:11:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqUlA+PdP8ml89tD5eASZywWz66k27BQ2lFDA5n7To7WEt8SibnINVl8nAU20FC3ngHVft6XvxrBFfJ0zYHEp4U4J0vOhynYJts647d/e1jMQdggIsN5sjpooqk7JnVnu0As4JpxyRLBxGJYb4pczkJg4WE3vUFs7v4I/Kx1VM3d5EKoNW8tKTGCd+8E4UF6UlcQfiZTH4v5bDsde7UPDmqMK/bDmvSpVPK+EnRUPhmk73I8KqsXvRykdTdBytvdlbL2hO8J7qGIybpE5OtA1OrV9eOOtTBhgl31pcV7Kyb2yZtytEdFEgQlxflvUfAN0xQNN0z3Q+XMedotXIx8lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TAjC8xF7EJSVR/TutHRhUBNBOBcRqScvBb8bYg86R9A=;
 b=Q+os5Gr8XL6+on/opMnfcjW8iXB05F5xwoOcaIYRvQboyRELDk7q6QexpMbxqptDtlEii7ndnamX4isvrbhj8d/cEvGAqUUCoHfCDCDYlu+i/z80Bf29B0N5Y7riJobyTNNbSVVHmYd22fwtgNq+eIuqL4IvGUnPjKwNvW0r4Z8kFY1Yl6th1MeGAtlVc185LhK3lRp9zpfcIySrb7J562Bdoaug5x8YkBhPJRmiNeacAlZBmQjAGbaEhSgORQRFFqbcVLdZPiJIjk+TEbtyxJeduao0dsDgagNnHk051+Cz58t5R9Kr0I8uFrR2veUKvZRhgg8HbOKu6GszCc8htA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM6PR11MB4153.namprd11.prod.outlook.com (2603:10b6:5:19f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Mon, 10 Jan 2022 10:11:44 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f%3]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 10:11:43 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
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
Subject: RE: [Intel-wired-lan] [PATCH v4 net-next 0/9] net: intel:
 napi_alloc_skb() vs metadata
Thread-Topic: [Intel-wired-lan] [PATCH v4 net-next 0/9] net: intel:
 napi_alloc_skb() vs metadata
Thread-Index: AQHX7D0GBStG13BisUmYcc0eBW8cqqxcPCkA
Date:   Mon, 10 Jan 2022 10:11:43 +0000
Message-ID: <DM6PR11MB3292AA2C0D33C635FE9D068BF1509@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20211208140702.642741-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211208140702.642741-1-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bac306f0-975c-4230-86c7-08d9d4219a61
x-ms-traffictypediagnostic: DM6PR11MB4153:EE_
x-microsoft-antispam-prvs: <DM6PR11MB4153653116920ECA292F91A5F1509@DM6PR11MB4153.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e2vcC+0iqKzBs4+X0xtOHWx1E9h9bhlO8GNOzqm9OtSXvoaAvz2howwgvgj5U5mTBfeTRZBMoJKmnr/6MPXsKEl2U6eD2z/KG2oTflzLRU6NhmjeaGmYQ3rfrqLfJh8VXT1pB4HoNpauiivWMBKTMx46LKFAvUcI6PZbfgT0fVj3xGpYMMl4ajOOK/HJ6PFRpNRIrPpTrnKYuXmPrZiUz5jMliN/pVKuD7BzsdRslvv0HbGX5nT6A+Ws663+bdYxgc9hyFZEpym9AYM+jR3BIX6VXtwVKH5yxiQhF43Vu7Q6Cws7dHEaZ2tSg6k4OgAREGSRz3t98xAvzG5vW06W1kSTsd2QFCwCS/qLoJ71lJu6rTWp4EKihExH7Oo3/UHGydtrZFHOBNvvJBAHGbTteFSL/pbWemCz/dNn9FBewP2Dlu++dSa5F9tYjC++I7GbLr8xFimPGa3R8hnhGOmRK/ATjAEqkAHANnbBB1vkwgDytMdeE7hBl+K5fy+DTqS4463ssXYq/s3ByRITETIX+fBw7wCNMxb/94Ji9Xq0VNztAXhTBZMunTWNokVxA5KB76GJ9qEaI3XXLVIsU+pjaZJ2v+gApJCFk2/HRBPXV1T+f3eXp9/JoS+voiuPvIl4hmY0m7q22zjFruqeUvHn9Xql3HcFlu2dE/JA5ZDBQ3zaBapEMb9MHry8+JmCUS3is7SSG3TGiQpbNwW6DiMacGnDz82FTFdDLS439IqJnaiJrVW8BBd68Y4Tt2anwuO/0cQmF6Nyk6vmYqn6VYh9D9L0k4XaXjq2aI/V+DwQrT0CA1SH3b9ESjwa3OAsX0jRYk8UDXml1JV3xiolnuSYVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(7696005)(316002)(8676002)(508600001)(4326008)(71200400001)(54906003)(110136005)(38070700005)(38100700002)(122000001)(186003)(76116006)(52536014)(26005)(82960400001)(66946007)(2906002)(66476007)(9686003)(66446008)(64756008)(66556008)(7416002)(86362001)(5660300002)(33656002)(53546011)(55016003)(6506007)(66574015)(966005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?bB+DWYPCNu+OGKfEt/RCuKZ8BJCZaDMhqLzRC6ME6QFkm9rAPfiliGRjgF?=
 =?iso-8859-1?Q?aw2hRbz9b1O1aMEf9Z6fFfsrDkOwcqdPqOw4KfxYHkMywKgLjf0g8ZQ6db?=
 =?iso-8859-1?Q?85iYiov3KSv/9a9MlL3nxo9qfWtlPvVeSJiTmdKhDB5t/w8U4jGYL6cccN?=
 =?iso-8859-1?Q?TYiYaoe5Gtj7dOC789Ub91Edxs5nAmaqjHPY+dR5NdUtnvWHYXba67IaUp?=
 =?iso-8859-1?Q?HI+XoD3q9zucPGphfbt5WadzmaHojsESCeZx+UoHHhb4UXuocQnb9ior2T?=
 =?iso-8859-1?Q?ZGS5R3nVAO+EknFRTc5j7MDpkj1XSj7JufdqzhZQA4EWlwLzFRDU2fqfLg?=
 =?iso-8859-1?Q?G1bamMwhyYh7q+4iZdBlJZLFQdcqSGFGoZgKb+Clbj9y5vkYMOeSliraeO?=
 =?iso-8859-1?Q?GaftfXkcINj6VAYbLSJnozyZk/3cuCCoIgKzkLH1iKZ5U2Bc4i9XF9k6ox?=
 =?iso-8859-1?Q?navqQ8VEDsMa8JMCfraAu4mwoidiOKthScorVhheZF6sJDtHRMlmIJyIEK?=
 =?iso-8859-1?Q?nwRr0aak9PTj2eh3slMsa+rB2FmbNemzmD1Glts/alYu/OQuQU7ksGfKeX?=
 =?iso-8859-1?Q?VDgfwEDibSByTWMF5zGaL7dFfDQrcWJ6TLkkQ1TCduEaT985QxM4CuO/90?=
 =?iso-8859-1?Q?eUL8pyyVv4qh+iO+SbnYqv3JxXerCSbDKrqEg5QfA2NQPd9Y+9Y2udsAGG?=
 =?iso-8859-1?Q?cVS6MbajUDOtBOo+QEE09kl4VfIwX5QaWJGS9eaU0ukBT0qONNGMyEIjPZ?=
 =?iso-8859-1?Q?OASiIp//VuxmtSnmyqk8wYWJ9sMBCJ05gEJGdSNxuBpJjPyQIG24hUwILj?=
 =?iso-8859-1?Q?joAiPGN8nnRD76QKo/byOY0+uLOKeWJHeY1JCgO4UJz4Gfkbeb2FIoBXP4?=
 =?iso-8859-1?Q?3pKLirfBBMXzG+1RG++bP6Ev2VsxC6ZvBbC1d/5rraL0ARFqY4gJz4q7Ky?=
 =?iso-8859-1?Q?rUsQr7KkbYOKgNRLQbuac6HfOz3sJMsbWgHcyFgOf76qPwOEdMDqk0HCn9?=
 =?iso-8859-1?Q?8NBBJI74by5IESW1sLF6zJ18fU7ReK33ISubWM8W1h6MVsun1ZD57b4W4A?=
 =?iso-8859-1?Q?QuJFRTfDoljCsQhVUn3DSvR+GJGUc+OVII312W3Ab9ckzpFiDbB9YCcYem?=
 =?iso-8859-1?Q?zrxA2UpqPPjR1ETxpy3kCH0kJUnND4XD3otYLQhfTS/Ny4x3AkLYBiLVzi?=
 =?iso-8859-1?Q?Sn0ha7WJUxyMdKkwFOWOhnJBm+Ibb+Z7BS0evkxDhPQ1XRMfruc2h4V58d?=
 =?iso-8859-1?Q?ABc+v6obATfiXlbVO3HTCeC/3Ux+xWb3PxHcr/ni+UGEVRvSN8Stk3ZFAe?=
 =?iso-8859-1?Q?ggPZJqiDtfiX7QhVgC44C41rhJykKyqeUP/yIXqQ6zJ9HKKjbBTipy/eyw?=
 =?iso-8859-1?Q?21n+CJHV1CUcrIHHfdk/NkzV5tzKdPorYp1t12i3SS84b0w32A44+ZccwO?=
 =?iso-8859-1?Q?AaehCHPEBYSfPniAW/p4n9I001HVN9seSlI3vnhie401chIXCyzGU/5zxc?=
 =?iso-8859-1?Q?2BzYWAjmvBH5mxakVq7S7yJl5qFLPJ/f4pkvU6LD6U93Gkna12TTmHo3oy?=
 =?iso-8859-1?Q?dCl5Srqfdp0hkz/8QUZuZf9L2aEgH/AOZoMU1GXrpzbTScG8KhyQ0MRgd/?=
 =?iso-8859-1?Q?2zkXutcAjoHQMuYxLbQf4kHStE0dT0o+IFzjsEUABGGXBggIJLTCtC8WPL?=
 =?iso-8859-1?Q?gZfNiXMCdoTGlbW+vU6k1NIs1mqb/5iQriPSunks/yd/m62Oo0FyujA/qu?=
 =?iso-8859-1?Q?thdQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bac306f0-975c-4230-86c7-08d9d4219a61
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 10:11:43.8102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GdExyaBiYwy+jgf3g4gumVHT8rbhRpj4DJ32D8xsCnBxxjWf9TWP+DogXjWPWW3MgF18Vy4/3bx2mO5gV7ZZ4to5gjOaNlFWwqLOlLJXJzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4153
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Alexander Lobakin
> Sent: Wednesday, December 8, 2021 7:37 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Song Liu <songliubraving@fb.com>; Jesper Dangaard Brouer
> <hawk@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>; Yonghong
> Song <yhs@fb.com>; Martin KaFai Lau <kafai@fb.com>; John Fastabend
> <john.fastabend@gmail.com>; Alexei Starovoitov <ast@kernel.org>; Andrii
> Nakryiko <andrii@kernel.org>; Bj=F6rn T=F6pel <bjorn@kernel.org>;
> netdev@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; KP Singh
> <kpsingh@kernel.org>; bpf@vger.kernel.org; David S. Miller
> <davem@davemloft.net>; linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH v4 net-next 0/9] net: intel: napi_alloc=
_skb()
> vs metadata
>=20
> This is an interpolation of [0] to other Intel Ethernet drivers (and is (=
re)based
> on its code).
> The main aim is to keep XDP metadata not only in case with build_skb(), b=
ut
> also when we do napi_alloc_skb() + memcpy().
>=20
> All Intel drivers suffers from the same here:
>  - metadata gets lost on XDP_PASS in legacy-rx;
>  - excessive headroom allocation on XSK Rx to skbs;
>  - metadata gets lost on XSK Rx to skbs.
>=20
> Those get especially actual in XDP Hints upcoming.
> I couldn't have addressed the first one for all Intel drivers due to that=
 they
> don't reserve any headroom for now in legacy-rx mode even with XDP
> enabled. This is hugely wrong, but requires quite a bunch of work and a
> separate series. Luckily, ice doesn't suffer from that.
> igc has 1 and 3 already fixed in [0].
>=20
> From v3 ([1]):
>  - fix driver name and ixgbe_construct_skb() function name in the
>    commit message of #9 (Jesper);
>  - no functional changes.
>=20
> From v2 (unreleased upstream):
>  - tweaked 007 to pass bi->xdp directly and simplify code (Maciej);
>  - picked Michal's Reviewed-by.
>=20
> From v1 (unreleased upstream):
>  - drop "fixes" of legacy-rx for i40e, igb and ixgbe since they have
>    another flaw regarding headroom (see above);
>  - drop igc cosmetic fixes since they landed upstream incorporated
>    into Jesper's commits;
>  - picked one Acked-by from Maciej.
>=20
> [0]
> https://lore.kernel.org/netdev/163700856423.565980.101625649213476937
> 58.stgit@firesoul
> [1] https://lore.kernel.org/netdev/20211207205536.563550-1-
> alexandr.lobakin@intel.com
>=20
> Alexander Lobakin (9):
>   i40e: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
>   i40e: respect metadata on XSK Rx to skb
>   ice: respect metadata in legacy-rx/ice_construct_skb()
>   ice: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
>   ice: respect metadata on XSK Rx to skb
>   igc: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
>   ixgbe: pass bi->xdp to ixgbe_construct_skb_zc() directly
>   ixgbe: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
>   ixgbe: respect metadata on XSK Rx to skb
>=20
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 16 +++++++-----
>  drivers/net/ethernet/intel/ice/ice_txrx.c    | 15 ++++++++---
>  drivers/net/ethernet/intel/ice/ice_xsk.c     | 16 +++++++-----
>  drivers/net/ethernet/intel/igc/igc_main.c    | 13 +++++-----
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 27 ++++++++++++--------
>  5 files changed, 54 insertions(+), 33 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
