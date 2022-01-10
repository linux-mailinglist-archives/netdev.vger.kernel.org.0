Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80619489629
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 11:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243792AbiAJKRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 05:17:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:27547 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243764AbiAJKRA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 05:17:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641809820; x=1673345820;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NfTAEftq87qz1jRB9jjx8zWqVSR8qDezsmW/T8kGkdA=;
  b=gTN2kwZiPhtKFBEwzEQLDOI29QXUkPnJ2Ji59r/zp/L4VEDHj0tG+GD8
   +lF8g1654KvVr0VdnPYP9gcbaD7TXKk0NA4MgqfQjVVnNSgOtO6P14cHW
   qVG7VUr4QAXPJa851/GRQvAqWmfnnB6AuODGhoH6JaMOg5F5kfEoYrLM8
   jqdGRZutWOcz7vensHXwAZ7loOFEAo43aNmKV9vxbFidrtHKvnRKnATZd
   lwC2DdaJCA5NYMvOEZ2mtAtFL6W0iLkt9uiU/i2/es8S+93CqYFq6lftC
   RPruYqIb/o2oNz9kcGQYYGSXmd2qQAPOaN9tO7esDa4zaZE9ECTBnVBIX
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="267523510"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="267523510"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 02:16:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="612812098"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jan 2022 02:16:28 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 02:16:27 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 10 Jan 2022 02:16:27 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 10 Jan 2022 02:16:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AlZdynXcBcU6zC07GcLGQd1t8IzdjkkOrUmR4SQLlUYDhDc4c+1uL3S8Nf0sEg5gd4ISsDNcGNMiaI343VwxncHuIq+xEpcvLry4HYRu7LJhZtKyNlcowfo1TTPxWbHReQO9xVQtnswF9jlqmG4mqh/TGWWMb9+aWE7UA2G4C8sN/zErpFZB7dH/SU2nlRUKxMYsh/r/biFXcqbCW60D8p0ujqJuYLGUh8qTNdYtl5YxBE4ou+MxeMhTiXg49/05aL9YKByD06Tfz9cF3uyvgXrJcuujtuNmoixEJb7HTPygwHtzNM3zok2deeYfCvxv34+MOW7LyIbY+m2tYxu43g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7sb+/Dg+F/way/GyfqleZwHl1Ujpju07pBbAwV16as=;
 b=fKa9A3Kdkb/wUyeRfOG0urLzF+RoPEJ09gNO61Gi66tMOUMgx4Ah8X/n6Ceee1fsBK3xEIHaHb6iJXD54YrRoHm1HXXuND1M3LdxOMoeiEI1F4G/YR+HpbCYdTRyU7OFBDQC+xg9+3OJnqYOjp1c66xUlXGoBc3qqx6Dk9FZR0JKivHdnlH/Jf2o8Fp9N/ty/JGf2JeVCOvLu3naLi+919u2aZwRH/4PbMaDEuwAkSzoNvLh1qFYj2nZcRjf2AlY40/2VVCvxSMdYuI6C58ClyLEGmjNN+sgqE6F2+AAfIehqzUuY+4UTI4ZC7J52Uxa0mbLntiuD9UvrjX+aj11GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM6PR11MB2713.namprd11.prod.outlook.com (2603:10b6:5:c4::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.9; Mon, 10 Jan 2022 10:16:25 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f%3]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 10:16:24 +0000
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
Subject: RE: [Intel-wired-lan] [PATCH v4 net-next 3/9] ice: respect metadata
 in legacy-rx/ice_construct_skb()
Thread-Topic: [Intel-wired-lan] [PATCH v4 net-next 3/9] ice: respect metadata
 in legacy-rx/ice_construct_skb()
Thread-Index: AQHX7D0Gy8Fb3GycJE2mAj1DNm0MGqxcPZ2Q
Date:   Mon, 10 Jan 2022 10:16:24 +0000
Message-ID: <DM6PR11MB32929E15779B9451D1CE5E98F1509@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20211208140702.642741-1-alexandr.lobakin@intel.com>
 <20211208140702.642741-4-alexandr.lobakin@intel.com>
In-Reply-To: <20211208140702.642741-4-alexandr.lobakin@intel.com>
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
x-ms-office365-filtering-correlation-id: b7ecf88a-c6c4-4102-b224-08d9d42241dc
x-ms-traffictypediagnostic: DM6PR11MB2713:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB2713F1EACF73443228E0E02DF1509@DM6PR11MB2713.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oHTJ1OMuJ9TrpxY36VbXnoCWWCooCtVS+0IZORZtp08vdJU4ZdQtYuHamzkFszT2DUVKgdjjCx1Srp5LTU15RteL6+1ak3Ti6YAB9sbt2rY4o3E1MAHsu9S3h66pxTiiI4bj/EtHkWTi5IKu3p+TqsEUJaLC5CHjtgRVIUdq4vkIstaIklEOmEtZlrxYLKOCCYXSGS0WKWEUv0DqB0n3kuW4+04K6uPTDV3srwJeOFfFKAY/Ibh7Cwg92GrDc3Lzg1+t1Z8NXCgpnBbk7lRUUpxCDCtMHI4hyW+bkcN4/NYFdL4SMsvEi/TU+p+iwuq8Mmr0cyrEmUC1GtLiWY1lGjt801jFsohgYRBrD9qQ/joh6zJSfeVCRJ8AgkISC1viIGhMbJw8SrzgQJMNr97VjrK6uDWYQ8h0wWF9+yMj9hSa4UgNwgWwZzClyJcRS7uXmijGf1ulhtgUOIkjnrzQMv/UWYxijscEdKEITGPPB08bJBtRGp5+xA8Tz3gSe64/WUrY19LOcDSCllYg51aVaiLtlhStHkudkWXn36P2uoCqitZPSm31BDcClRVJkYYhRjKuiTGsq5keNWjCB89GRtptTm6765n2+y3Q19V2zcIdH8pkQj7GC57U0/GwL+1B206z6NtLwgS7D3wB3VfvdhBSTDyyWIZXnM2NOHrmR87uwjnQdMJD2xDzN0gkeUh9QCWQ6s7bcdvY1rxOYSWN2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(7416002)(6506007)(5660300002)(66946007)(7696005)(66446008)(66476007)(8676002)(55016003)(64756008)(66556008)(38100700002)(9686003)(508600001)(38070700005)(52536014)(82960400001)(122000001)(53546011)(71200400001)(33656002)(26005)(54906003)(66574015)(83380400001)(316002)(2906002)(4326008)(76116006)(8936002)(186003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?7+kCUp7byhrC7avxDNm4QNfyYLxk8i4bMVRfqVegU9awdfvZajA1yvuXoM?=
 =?iso-8859-1?Q?jPFbNuVhpHjBQYMf9Vm5dV70VDrprN/lnoXa1DmulermgglGsEIvzqDxvc?=
 =?iso-8859-1?Q?+p236wy++Yvv+IAnBT0edihJ7xun4vlmiyVgjM864RQAnCyBfJrCFP0fkp?=
 =?iso-8859-1?Q?jI3lM/sTQ63l0ZkZXze/GqCxGNXbhLpjn9pMTIk6BUpgQCiPSbJG+nbHrc?=
 =?iso-8859-1?Q?4OQbJ7EHQkrdRxm8QZ2er/yJTd3uL4vcy3wMcfTy1kHPB4Di/GzJdoC5LX?=
 =?iso-8859-1?Q?Pyme/L4TXCh7JoWE6LPzDbGD6+lUyJJGhrfFZbLbvgMAtggXnHgzKWXqMz?=
 =?iso-8859-1?Q?GX/xU+WYUKPoQ45SAyUQYqsz/yTR7LgYuCldiKT5rcLbEfiGiHTpT5syVN?=
 =?iso-8859-1?Q?swsSMsirmaptxYeTTZMGEyhUgnyI99haEqamCVoXWXY5DBjYUnX0x+8K2I?=
 =?iso-8859-1?Q?KbjVjvJeiL7sMUdnR6m/k94cXY9cbJ0Sw4N9oyhEFpvjLqUSHh8ERIEP+t?=
 =?iso-8859-1?Q?fdNRgOscvS6JwhZPNtk446sKLqkUdd+e3xL5ryWB9Em1ADDnOK0VhL2unq?=
 =?iso-8859-1?Q?n41X+1rHBr/yhqPVIOehG+ji5CBDLYx6xXUXCQcA3kIHA0JnGcqwW6X3KT?=
 =?iso-8859-1?Q?iBlcdhkHE0mOl2oVZSx9cHHGzevVCLc0hTI6RDd+6A92/h1V4ouLyp2yO9?=
 =?iso-8859-1?Q?F8y+83rCwTzifjevwvV2TDfd1hqIf16M0pa0DG6u7v7AYKLJv7mvQrH86n?=
 =?iso-8859-1?Q?UX/JBsZNBpkRqIIiQ9LyYH0TG6GvauhvJDr4z0FjBDs+J+eKi1HHEm6AlX?=
 =?iso-8859-1?Q?5YQeU6jfU+08z0g5pHHMklw+2YV43Gd0JvWVsdfzTYoHZSdB959UrzQOhL?=
 =?iso-8859-1?Q?PbtTr5wWLc1mg/gi9XQbo8odw+n6iqJG1q9e4rhclOg06/eom+t2bySnGQ?=
 =?iso-8859-1?Q?QWkhowJKZMnujOIhMe0xTWd+wngOzA0ujmTUZZHRGp/qCQCx1AGUS4QKl2?=
 =?iso-8859-1?Q?g7gbCf1f8cmEXH5slKQf03QbiVNJvKEd3vVuK5H8EzKTLBJKpNGJfXyhHI?=
 =?iso-8859-1?Q?xZ7E/Ypygovbh5+e7i+j3nMUx4zYVT0adzYaymqD/T938hvNGDBGZe7WlQ?=
 =?iso-8859-1?Q?t5jPoH2ERDnVsrmDeVrZvTDk16q/PRfeldtMAQA3i3+Nz4lay8GffQgw+e?=
 =?iso-8859-1?Q?aoqyNMftnKzDOwk3401ZzW56J14mtkt7vw7iUPQzS/FEU7myLUZFrIQw7x?=
 =?iso-8859-1?Q?IU5g3u2OuW/bCz+Xqxskky6AYndpCy658LweRmEAVjSFQCxVTE34wEYpHK?=
 =?iso-8859-1?Q?zC6o6C/X67JiHtluTAnBoIPJND+m9y9bTEP6+rVG9CBKAKUQRJeIxhDiFx?=
 =?iso-8859-1?Q?morCnywsasyVWmMRroYiS3D9mFPWmrAoOhtpLBi4XZFXkEzh7PKjo4ezKk?=
 =?iso-8859-1?Q?CKp03H4M747juKgYLth6+6pE7Zl3X24hEZHAUBIYppbVB1goq16aHM/QVe?=
 =?iso-8859-1?Q?6D3iE/KIb7kuO5y9RRxeIPNgmRacwrpgd7S27viHvnj4pnpv0kzBaw9MJU?=
 =?iso-8859-1?Q?Ppug/l7q+Yqg9oS/GDTpjJtmLN4PwF3XNMWLbYz+XvljQJe1cShpINha0M?=
 =?iso-8859-1?Q?NbxtRCMAIHB7/lwRfaS6ArqY8XIS31VVm9nadW06SnZfNZIqSrcnXUGZ4f?=
 =?iso-8859-1?Q?FuS8yhFGN3ZAfOcOW5Jbp2ZTr9Gsp+ugSckjfX8dr+YQV2oqJ61j5cFG2X?=
 =?iso-8859-1?Q?RPTg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7ecf88a-c6c4-4102-b224-08d9d42241dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 10:16:24.7657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A131+tSg5/SG7Gx0xl7MMC2DjaqqYk9vRNzs6xGU3KYG/OACABEUWypYOy/LVuowuy771rUoI9RCWVzyBGfaI/5U86ayneMdleGJZrgUxwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2713
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Alexander Lobakin
> Sent: Wednesday, December 8, 2021 7:37 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Song Liu <songliubraving@fb.com>; Alexei Starovoitov <ast@kernel.org>=
;
> Andrii Nakryiko <andrii@kernel.org>; Daniel Borkmann
> <daniel@iogearbox.net>; John Fastabend <john.fastabend@gmail.com>;
> Jesper Dangaard Brouer <brouer@redhat.com>; Yonghong Song
> <yhs@fb.com>; Jesper Dangaard Brouer <hawk@kernel.org>; KP Singh
> <kpsingh@kernel.org>; Jakub Kicinski <kuba@kernel.org>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; David S. Miller
> <davem@davemloft.net>; Bj=F6rn T=F6pel <bjorn@kernel.org>;
> bpf@vger.kernel.org; Martin KaFai Lau <kafai@fb.com>
> Subject: [Intel-wired-lan] [PATCH v4 net-next 3/9] ice: respect metadata =
in
> legacy-rx/ice_construct_skb()
>=20
> In "legacy-rx" mode represented by ice_construct_skb(), we can still use =
XDP
> (and XDP metadata), but after XDP_PASS the metadata will be lost as it
> doesn't get copied to the skb.
> Copy it along with the frame headers. Account its size on skb allocation,=
 and
> when copying just treat it as a part of the frame and do a pull after to =
"move"
> it to the "reserved" zone.
> Point net_prefetch() to xdp->data_meta instead of data. This won't change
> anything when the meta is not here, but will save some cache misses
> otherwise.
>=20
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
