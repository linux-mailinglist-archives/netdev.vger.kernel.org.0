Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE0F489759
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 12:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244675AbiAJLY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 06:24:26 -0500
Received: from mga06.intel.com ([134.134.136.31]:48914 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244669AbiAJLYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 06:24:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641813864; x=1673349864;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZnmTB+O910n4HIS+UUP3QCZ9s5Pq85b2OSKGaMHOF6g=;
  b=BYwnSIqirV1puJFfN2nh2yA14rXc2uz1Tq9T3kAJy4upCv4ZJ/jlqAkP
   n/h0GY5GhbVWRjH66pgzTx6AuUTKVMTEFww1CLjyO/RQIvJHkUYtW6FJr
   Rvc/rlyrPrzuv8YS4e2iWv2+Qlotk8xlRBpZgKpSnR7SgEKjpe1oTBkre
   lLKAucj6iZnneN2spjy/qbKFClphic6w8Z/hfijQ5ZqrRJJut+l8aiu4k
   ku1BeoVbJeCoA29djwGg6gKg0T0P2K962Y/GmMFEYoVyQw57nIeQqbWX/
   dCioeXpIlpgx2MFe/U1bmi4fn6J2Onw1YxVkGiPtulCCczR4O5tSmphx0
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="303945805"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="303945805"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 03:24:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="669426604"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga001.fm.intel.com with ESMTP; 10 Jan 2022 03:24:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 03:24:23 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 10 Jan 2022 03:24:23 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 10 Jan 2022 03:24:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VvwhB7gGRbgOFkSPPX+ucpPnAwr8XxQCl3QVWrb+1cfWiLl3uiJNWPQyLSjIUggbzXsYQQENnr/f1akpO41JwoijHCsFtZ7t5vYEmz8ED7AWMLG/QiGqA7syfKWPT5lUzrdcpSLn5jIpNl4FP0JLHbUFjIQtkiTyXon0ZNHBqFTDzD4tQ3eKfshnp7zXm+N9yu7+qM1UWvrp7GQKwCmuwdqfTuq/1iiO5pmxpWpwXtv8gzlZoBuH/+MYiPMu1XB6KMjUK9m1y0mBcML0vpuZpZs++YDXuuJfuawnRS4Wd8e3OIacpkSAroIEO9rdRlLTSt8TiOfnaml5fJgk1d9Kpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cs3JhYulJv6+HQD6HZzyKTsogK+bM+zLeud1TKH+G/E=;
 b=EktPjVF55BcMRur5RvQnnNSnYxVDCL2bhvgbPogV5JWKZwGioAsbUpovw10yWeV3g3eOf4828xZAo385dHwljGoEamhUkxZkc35LVHcL+X2nxJGBlKNSnFotyla/zhK7swrGm2+nZFURA+lgVZnDo5LYrgLpQ7JoEXInI/AuLd1i5ad7hSn/3BTRxhJaORAY50nHy5wAkhIr7HOBrasIvbBer3Cz9VjR+ymnm3F65mESOdLnkiZK2wlT6Ay0dfv4yYpXLRsO9HW1aIWqf6XMwGX55Z+kbsEdFLO/6y9ZcgKBOmpgoNJelCOJTop78v2fjiT1JKcP2GA1Wbf16RMusw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM6PR11MB3148.namprd11.prod.outlook.com (2603:10b6:5:6f::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.11; Mon, 10 Jan 2022 11:24:21 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f%3]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 11:24:21 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "Brouer, Jesper" <brouer@redhat.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>
Subject: RE: [Intel-wired-lan] [PATCH v4 net-next 2/9] i40e: respect metadata
 on XSK Rx to skb
Thread-Topic: [Intel-wired-lan] [PATCH v4 net-next 2/9] i40e: respect metadata
 on XSK Rx to skb
Thread-Index: AQHX7D0DcDEzIDRdw0+rfrddXiafC6xcUL0g
Date:   Mon, 10 Jan 2022 11:24:21 +0000
Message-ID: <DM6PR11MB32922FF17EC415EC54D541EFF1509@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20211208140702.642741-1-alexandr.lobakin@intel.com>
 <20211208140702.642741-3-alexandr.lobakin@intel.com>
In-Reply-To: <20211208140702.642741-3-alexandr.lobakin@intel.com>
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
x-ms-office365-filtering-correlation-id: e6abb3c6-01bc-4b3f-bec2-08d9d42bbfb9
x-ms-traffictypediagnostic: DM6PR11MB3148:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB314885FC3226C6F4273820BAF1509@DM6PR11MB3148.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: //HeDJGKCgdwQKS2rZ8fLiTh94nRWOR+DHz9y3neP2uf6TKGjbOgJCMBWS+ut+mL2J4LRJTuHsxFc4orSww8cJyAphRHFlsVui0LrJAFqCep58f1QrwJ0Zbm4qxs1uEytF2PCunvwSfdScFRhruNZlbbK3ZaRBuysSEiBJOc7pN302rC1ekF0Pr90P1QtI59ty7CXFhG9k3nQ+fRrmXXuGnWxSxuadfzWAR4F7n6co/BAhT9TDfThquL6ZHQECHqaoYFfRp3MN8oz8vPCs20kw4SI0y2HXj/JhyBU2TP+RbAb1TvCkb3Jw/quEGGOZR/Q/cUpqJ4wLxG7f9wZtcjC6uPp0Lq419hgfJm+kuEpBKwUvMQT8SHQGav/hErP72qrbnI12ZSif2MoVyPhLWEn0uyfxlEDd7ANIqmXqBYF1ubOITNg1yucMBht0QQU7ZgQifM8aweT5Pz50saF1jhKZ5p1aWrrMOdckGCf5HJLwoKmJbvNcRGHsVZycCWc40Qvu6QnjiPw/+bhkp2IlNUFMEpFBGegty8YtEcMAdKKSRlccUr8Q4Xx36ORf2UJjGlN2aAQzBAn9GKhVyK0KjaMsX4e0SpSWIS4U8G/lPi3SWDPhomC7iYizB3suRSpGDtHaosbsaaIt6DUFtMac7smE1IbxdW8d1EGQ8FJnjqs9NkOtIAYI8kWq+c4VtPZTSnFME5aJTQ3E4W38dPvO5eSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(110136005)(54906003)(55016003)(508600001)(9686003)(122000001)(8676002)(53546011)(8936002)(2906002)(33656002)(316002)(26005)(6506007)(7416002)(71200400001)(76116006)(66446008)(4326008)(7696005)(66946007)(64756008)(186003)(66556008)(5660300002)(38100700002)(66574015)(38070700005)(83380400001)(82960400001)(66476007)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?NUoKY3h++9GLigaOdqgVlJ8E/LOgUFNmePcsxYkDWR3NuuO6xbG3uE24kd?=
 =?iso-8859-1?Q?6TmJYNN979rwsOpyAagicsrYGHtmv//iepnwu5oO+NwUKAnKw+VxPtiSq/?=
 =?iso-8859-1?Q?D4Enb0KNG8gt+RUbvNXolhXgmLdzti4vWmtTR04Zit+oyCaOhGUnMnPRuF?=
 =?iso-8859-1?Q?0aTdOFs2uU8XJm1RO1P0nh1K2iQufGX3zRD1RM6PcANVQ/ET/kp1Ok8qS/?=
 =?iso-8859-1?Q?6Uc0dC4PPxZpmIW7oD5Ly1kvxQ/vEFFDVY1utx+IYOLtbiZMfOIh9Ys7ab?=
 =?iso-8859-1?Q?3DVdxZ8OqcSQjGNYMXRviVgYtqtHD8WGwICbG/Zr4ILEUgC2tEkCL/TgWd?=
 =?iso-8859-1?Q?ooCRdzPCUstMnEDLLQoIcnqsPsYqazQL4BdYa+itsiJev0QnRNJrfcJf2T?=
 =?iso-8859-1?Q?Y0l/ekB4o1G1aD4Le2dlbZVwyo/nqB12w9JDkoL1EcxDEVZ35C0U+Zg6/h?=
 =?iso-8859-1?Q?THK8YrSVlnaUK1D4IYEDgXbOsNgDuODy1UiTsVjDbCjO1AB7Mq9d/1G5Rs?=
 =?iso-8859-1?Q?RHASxeX6fKrQmej/eplQWnV8RSgO736dgd676lONnrYAyUp9jcJogoAScj?=
 =?iso-8859-1?Q?yiQOyMqufWcgmuiZT/0Vk4rAFEdUHL0hjfqaJ7s0LWqlg/mE7qWjtj+LfS?=
 =?iso-8859-1?Q?LvCMt/PShIIqMn8vwnU1L2ECbahQR8j5cMOpS49vdnds/xamBf8YKq9UO9?=
 =?iso-8859-1?Q?fqcqibY1fI5PH7pNeQdzLyJcarosa6ScrE1/W1bMGTJ/IXKpcqnuORRNey?=
 =?iso-8859-1?Q?/LK+zqd9nwjplzOEiQTYLCbcg8yWDCF8/mwr+cj5Wix+Ka8x2w1qPPwza6?=
 =?iso-8859-1?Q?4MO33f5R04ohorbfZ9eSK0l/anIaxwn0Pe+wrYNZz9I0F+5Ankf2D7Q4m8?=
 =?iso-8859-1?Q?icJca6SEmRHW/N5xJHBBfyle+8PYGpsKGMmWxVQscsnIYjGHTgE0JF3aCu?=
 =?iso-8859-1?Q?bzNk3P1FniXH9gEP50Hfnl1V5P04ICrTajuTPuIn/WOBU0LSoOPkzwD1M9?=
 =?iso-8859-1?Q?WWX6zs3EWg9Y8Fet1fUOSabDF6xQgDhWT/qhthkjehd+PhOFsPfb9hbB6G?=
 =?iso-8859-1?Q?k4Lu1igQATW2TGeyV8ZNwui1gmSslByRZ+VlsQljz1I202a7k2EVbYCjFj?=
 =?iso-8859-1?Q?JMilUWTxFgOdyR7Q5LMToEOCYLUHOlqzR0pX9e9B+idElrIOr/qkkpK8f/?=
 =?iso-8859-1?Q?x4ptwFDmVhlq6XrAwkvhvXRC05M+duGVyuqUhLxf3SicJH+LHjpL3WaRlK?=
 =?iso-8859-1?Q?/HiINyC8VS4sTK3atKMkj12JQoFPB+WlNoeyD/W/TK+8wllZt5xbWQFWKn?=
 =?iso-8859-1?Q?0fou6S5IeoVkFn72K6sDLCXks4S34nKeOAd26/6pHJpXAbN/FrTRueBAvE?=
 =?iso-8859-1?Q?l8gKdxvcPRL62JpUWYzoW/GHpZOykfBXEYBMGeVb9zPMJWHlvPTaeB+cxD?=
 =?iso-8859-1?Q?tlENRlzGOSBlb+SgPtxmujjf9/E6QbVogfY4TnXFLld/xbnzM5/32H2//f?=
 =?iso-8859-1?Q?lgrB4PeXXaW9LgdtoJPt+u4pu+/VjCARgkAq/kh5ysLlVTJO8kdI52LgpS?=
 =?iso-8859-1?Q?GdCS7dfM5LyAwS6Ga1U8Gy2W2x+tiwGwU3nYwsWVOrY3sPNItY5q80xdTp?=
 =?iso-8859-1?Q?/M4B72JzXNF96piwKg3ICC3UDuXjznEJHlSyDa6Bstk/2iVGDzFGBTrvFU?=
 =?iso-8859-1?Q?1QfZtTEp972u0FfBiiKFMcK5SvfJnunFtCUhDdx1lSRRyUuUBLBJOcTQZi?=
 =?iso-8859-1?Q?SexQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6abb3c6-01bc-4b3f-bec2-08d9d42bbfb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 11:24:21.4158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZqX4NUgd6nv2j/r/CDL45vjoLdy1mQ5e3HVvVnhQvFW7/SpZpcM6+N8jvnn9eAsAHN/UBEkbmp8ILAYJ3I4mfyFSCxwePJxXutJpd0GsdUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3148
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Lobakin, Alexandr
> Sent: Wednesday, December 8, 2021 7:37 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Song Liu <songliubraving@fb.com>; Alexei Starovoitov <ast@kernel.org>=
;
> Andrii Nakryiko <andrii@kernel.org>; Daniel Borkmann
> <daniel@iogearbox.net>; John Fastabend <john.fastabend@gmail.com>;
> Brouer, Jesper <brouer@redhat.com>; Yonghong Song <yhs@fb.com>;
> Jesper Dangaard Brouer <hawk@kernel.org>; KP Singh
> <kpsingh@kernel.org>; Jakub Kicinski <kuba@kernel.org>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; David S. Miller
> <davem@davemloft.net>; Bj=F6rn T=F6pel <bjorn@kernel.org>;
> bpf@vger.kernel.org; Martin KaFai Lau <kafai@fb.com>
> Subject: [Intel-wired-lan] [PATCH v4 net-next 2/9] i40e: respect metadata=
 on
> XSK Rx to skb
>=20
> For now, if the XDP prog returns XDP_PASS on XSK, the metadata will be lo=
st
> as it doesn't get copied to the skb.
> Copy it along with the frame headers. Account its size on skb allocation,=
 and
> when copying just treat it as a part of the frame and do a pull after to =
"move"
> it to the "reserved" zone.
> net_prefetch() xdp->data_meta and align the copy size to speed-up
> memcpy() a little and better match i40e_costruct_skb().
>=20
> Fixes: 0a714186d3c0 ("i40e: add AF_XDP zero-copy Rx support")
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
