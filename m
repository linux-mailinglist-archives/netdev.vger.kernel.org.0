Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8D248AD02
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 12:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239267AbiAKLwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 06:52:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:40873 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239181AbiAKLwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 06:52:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641901935; x=1673437935;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=424wOjqbkmReClyR/kOwVeksolIQcVZHZPEiFMgM8o0=;
  b=NkCVRKC3yUT19srbv/+QTtAZoR5kl51B2cP7FTsbbR2u2HQtQl2/+AOA
   TBtT8gatRR3t5X6dY7bx+tOcJsy+C6nwwO+ziA/rxypJ7VQFbwLe8eAH6
   kn0Tx538a9P2RMo4ca+ypZT08AYN4w30XdxABPcNttSKFskNLdJHneqtH
   stQD3ytpYbOYFghPt5gvC6Guc0argg94AaEZeu4gVULX1kDRXWNfByD8w
   uv9O2k5i5Mbld9vp8Ja8vvXHOKogsKbhg71qTwZ0Jzl/z8Gv6ZApt3QWB
   xCcqHDoGZSjWozlpbvV1om01bG5GISAJf7ZQReNfzLD9VZqeJuSyPfW4E
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="267804800"
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="267804800"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 03:52:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="762505256"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga006.fm.intel.com with ESMTP; 11 Jan 2022 03:52:14 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 03:52:14 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 03:52:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 11 Jan 2022 03:52:14 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 11 Jan 2022 03:52:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/HMvTsPVSUy3BztOCZYTozpLg48JJ/Mu21gAMutSwOEqlZpay6sNViK7/2w982cGe3dYNX5F7j3Qqai93SWiJD2KO9j9Dnneaqhyvl3iKx4T6HFLzaoXu7yQAERh9o8zY6hHzwYZ2nw+vSRdrYQ2Q+dFzLdPynH4DXrFOKoMrXPYiDXb8ylQZggnxFESe/SWfb/w3iNNggUMXWJ/+kx3hKhXgNg8HXyNwLTRaMSZpX0t6vdc9eB56aZtH4bN4YTXJll0w7/ZxUEzWHkkmZm5q6+PIAr20Y5hGYb2jwNDSrtDrDy//1arGZ7L+MdEptib6wt7qtTSz4o7LodC95G7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=424wOjqbkmReClyR/kOwVeksolIQcVZHZPEiFMgM8o0=;
 b=dbagojcp5xBpWMYCTe0pBmaRupsH0mM5aNKXJ8r8EXUmBuGwGFNyIvJxu81xs1PNzM0/4jL7as3xheRl8agZTXmW48hfIHUKRKJU7neTy6PLjkmMKRhuVsLYbuYuT5/peCnVSm0IGSW+SyYlTwq7dVx2S+obHB99ZokhHRFN1Ql8c2/hwST8jMBHYFl1KrwOqm1U+wn8/Y4S6Ilp9m7hhgk8JDvX5b/R6VLIEAk8SuFoSvbv0LppEigEloiDvAZSh5HmFnQgmMSPAQ8T4ZRHLZVZd9FEmxGeNRIcd1zYOJipHvpA95WV5JAvHjpGDczVSh+n/gQuhj8sQqn9BAY9hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW3PR11MB4554.namprd11.prod.outlook.com (2603:10b6:303:5d::7)
 by MW4PR11MB5934.namprd11.prod.outlook.com (2603:10b6:303:189::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Tue, 11 Jan
 2022 11:52:12 +0000
Received: from MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::42f:73e3:ecb1:3b75]) by MW3PR11MB4554.namprd11.prod.outlook.com
 ([fe80::42f:73e3:ecb1:3b75%8]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 11:52:12 +0000
From:   "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
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
Subject: RE: [Intel-wired-lan] [PATCH v4 net-next 9/9] ixgbe: respect metadata
 on XSK Rx to skb
Thread-Topic: [Intel-wired-lan] [PATCH v4 net-next 9/9] ixgbe: respect
 metadata on XSK Rx to skb
Thread-Index: AQHX7D0fZ5JsDE1k70OElN7bbzlE2qxd6sdg
Date:   Tue, 11 Jan 2022 11:52:12 +0000
Message-ID: <MW3PR11MB4554E0499E598B382155A48E9C519@MW3PR11MB4554.namprd11.prod.outlook.com>
References: <20211208140702.642741-1-alexandr.lobakin@intel.com>
 <20211208140702.642741-10-alexandr.lobakin@intel.com>
In-Reply-To: <20211208140702.642741-10-alexandr.lobakin@intel.com>
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
x-ms-office365-filtering-correlation-id: b57e6402-7484-4ea2-3674-08d9d4f8ce36
x-ms-traffictypediagnostic: MW4PR11MB5934:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MW4PR11MB593423FA02E37EAD81BBEFF79C519@MW4PR11MB5934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g29u4C2Fjo6xT96hh2o7LHfIUsmH0AE5AaQ/qC6laJcK+D9kC8wZNoDgQhUVnC20Tjn/uLJZkbFW3g5UM3CPwOg+W/VrjIP5NdzN3q6gBaFss20I4sbJI78Wx4+rzqeDel2MWyTAhcmmlYPDFzRpddX1EIAIzumlBohm2TQ3RXmVNwFCSvZJdbQuBDOc3c/xlrMRjJSbtBNRKTqnDn1h2/+04gjYyao3nZPg3eKWKRFfAxINzeRaeNwpmRnWmlagh/kmies0M7fZIrshFrEl6QjqbIURggSsoxkYyz0Z7RMZWTlz8cbvLZRAcaiLlXNoi875gScFA4+H8nu4WQMTOq97mxkX5NLKQvxQD3wENKe0EVQ0D3o11b3igIqocvm3z4STrv1En96qZkWYkti9nWffMBpazaCLfVbNE1/iWXDgrX8viAC+3xFCh/oRUG2arTCipzqZcYLTVe+PTn+iF+AmvtmY78EwSlHxs7oANPWvR+j4J4belJ8ergP2zS6zz7qa8g+7tiA1oQwLKSeDj2/9UdSLiY2HdvpVhXM9sH369TKEGtmZG2gIPm+tAHZ8egePxJAVfTM9ZU7whzqrowydLZrmzhjMoTlC2c8jl/R1hUOOc5z50///gY97VEUWmsilLJy6nFMhvLvJp2W8m98SKGaA1+Z/K8sa/x8e87ZqsO4Wq9rji4qqL47Fw0QGMjEOFCdRCerluwpBvOKMyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4554.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(6506007)(122000001)(186003)(38100700002)(83380400001)(82960400001)(7416002)(2906002)(52536014)(33656002)(38070700005)(508600001)(9686003)(76116006)(5660300002)(71200400001)(8936002)(66556008)(7696005)(55016003)(86362001)(110136005)(54906003)(316002)(4326008)(66446008)(64756008)(66946007)(66574015)(66476007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?e/A0XSulY9bW8A+3+1w3Srun1kJs6E6e7ejZ4U4H2jHvtmryK40blqeE30?=
 =?iso-8859-1?Q?mliKx9Ye/k3MNsesdta/LjFYs/xR5plL7zg2DMVE1jIMz62QTW5YXz+vab?=
 =?iso-8859-1?Q?QNOraeJgpX8D6mg459HegJMPocmEM3lS2NHRMDqJ6AcRHsJMlLssgSdBmQ?=
 =?iso-8859-1?Q?j1wRTpQOwWuR8vOsYNu3k/5RBLqmiuQ3Tz8HHjv230kqHCpNInVFH/jhen?=
 =?iso-8859-1?Q?qeC7B4iKZYJyCr6GCXSp4wniC9ebmEe9x6UrmCSadeR3W2EGy2nsApfnwx?=
 =?iso-8859-1?Q?UVjPZSYALcCpZXGqQUdri9VIi9eCOySyVnm/X3smjzPDhF7jdUdIxJrOxu?=
 =?iso-8859-1?Q?70syosJzidtLF1vTIf7PBkCeqVZ2Lu6dvpYjDTD4QoPXc7jmWLVTGeqgnt?=
 =?iso-8859-1?Q?kUlwWml0tJcjssobk13PlckVldPNnXOxh138Z0Vz8GPkPi9W89x4YHobta?=
 =?iso-8859-1?Q?OjCsgarTLa/tHP8rk6Sy5EMe254cUmCtIneumIEDD0ljF0SYuSfypKTBOn?=
 =?iso-8859-1?Q?mEDfOhDV8gAegGNuTFklm9r9KACWHTegHAsZBsyh3AwlkDTm8n1vHtJozR?=
 =?iso-8859-1?Q?GZB64/1LjVemRl8siAz4oLTBBGm4hc4GM6tOFqtpDAAR8RW6FmBQfJxWUP?=
 =?iso-8859-1?Q?/R6474SWM+xFsCkJmBZwjsmzZzFX16LL/FQwCvOOrhGVeEYEUa5ImsTPPF?=
 =?iso-8859-1?Q?vgs4ibqhccFdCawVWQEZFQxbF2QZ5sS4R6pjTB5k7dkgtung8izIisR9uK?=
 =?iso-8859-1?Q?rNEb+++InDbDpO6I2lFHYBfwzIwcQKUNz4ANgLSgjNQlTruj3SPPBSrP9B?=
 =?iso-8859-1?Q?74MqMVMrVHk5DzHnJpSAbz0LasnQWbWXNivuB7YNFf9N8uFStK6OXV7qPx?=
 =?iso-8859-1?Q?fqGlRonGGteqKI8IzSi6yeidNZPOD0pTO1TKQBo9hcGrpCE7A4biaJeXsm?=
 =?iso-8859-1?Q?5xPkfokwD9aVae9zzk+tHErru0MHltA08rYwu15dJI5Tk3+i2tWvFDq/Zd?=
 =?iso-8859-1?Q?Z0C3l7QxueNW+f3UxXuxn1yV418e25fNuO6YZHSKvvnUO2RBNa6B47Fx4o?=
 =?iso-8859-1?Q?mqaCYYVQDY0rh+c2h48Ow5B1dbKSPjGOPlfO0DiEPAUO448zDhUT2A8Dkl?=
 =?iso-8859-1?Q?HT7RKs3lDLXeO90ExHeD6Ublu7kF/KfsCo4G9zJ/F23evvg4IRawJ1Awvj?=
 =?iso-8859-1?Q?q7Nu+XDsNXwnAur2JYinAaLy11sa5K6Odoe3wlKE5Nf8fR4R+PsGfjH9Oq?=
 =?iso-8859-1?Q?sRYTq+ikViubOnVdSMlvythkVBmY3pBnjPECRVIbRGm0szAObzRmoIdAXy?=
 =?iso-8859-1?Q?cCibduX7Z9BMhnniMg5LyccUHy5LKaTGdN/0KgMSTY9KKYcsq3aeT0DS5J?=
 =?iso-8859-1?Q?iv7kFQWu3QQOlNg3cJNniEFHBnKlFd+8apVkXF8pjMtpGVvjnp5qz7ywn6?=
 =?iso-8859-1?Q?54+wmCyYGq/PzrUuwpUakUu271gQrGlHXC1jqiNwwm15XmvdAIAa3lzsHE?=
 =?iso-8859-1?Q?tK6lbL0dzWuWDr7/YCoIEJxu54S7q0chhexcI0JuR/gZR+AWVXhs9/BJ0f?=
 =?iso-8859-1?Q?m6b69ZCoJuNIh97ilf/Tq5bE+RfiyT1QCNY880quqw98AVbiU9Y8q+n3jT?=
 =?iso-8859-1?Q?2XOZUX0ayjFNOqW++Wuq0vFZOd4iPrETnjo/IaX7weOzZCyIFvWrrBAgOQ?=
 =?iso-8859-1?Q?XBsPwFmL3wfB2uFEewVFJmXiiYI6hTnUDP/rrsXJX6Cm58HCsTlkxCd1oc?=
 =?iso-8859-1?Q?/39A=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4554.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b57e6402-7484-4ea2-3674-08d9d4f8ce36
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 11:52:12.5023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vOwCBlmyUpj9S9Zjzs9CURTRq5w1srmsfzxnd7HqzbRhbT61sRaV8Ppdb/NnF4W8ppzJTS+46Uynx870pJB13uHhlM5+E+m0/wvkWUgBPwI=
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
>Cc: Song Liu <songliubraving@fb.com>; Alexei Starovoitov <ast@kernel.org>;
>Andrii Nakryiko <andrii@kernel.org>; Daniel Borkmann
><daniel@iogearbox.net>; John Fastabend <john.fastabend@gmail.com>;
>Jesper Dangaard Brouer <brouer@redhat.com>; Yonghong Song
><yhs@fb.com>; Jesper Dangaard Brouer <hawk@kernel.org>; KP Singh
><kpsingh@kernel.org>; Jakub Kicinski <kuba@kernel.org>;
>netdev@vger.kernel.org; linux-kernel@vger.kernel.org; David S. Miller
><davem@davemloft.net>; Bj=F6rn T=F6pel <bjorn@kernel.org>;
>bpf@vger.kernel.org; Martin KaFai Lau <kafai@fb.com>
>Subject: [Intel-wired-lan] [PATCH v4 net-next 9/9] ixgbe: respect metadata=
 on
>XSK Rx to skb
>
>For now, if the XDP prog returns XDP_PASS on XSK, the metadata will be los=
t
>as it doesn't get copied to the skb.
>Copy it along with the frame headers. Account its size on skb allocation, =
and
>when copying just treat it as a part of the frame and do a pull after to "=
move"
>it to the "reserved" zone.
>net_prefetch() xdp->data_meta and align the copy size to speed-up
>memcpy() a little and better match ixgbe_costruct_skb().
>
>Fixes: d0bcacd0a130 ("ixgbe: add AF_XDP zero-copy Rx support")
>Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
>Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>---
> drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 14 ++++++++++----
> 1 file changed, 10 insertions(+), 4 deletions(-)
>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
