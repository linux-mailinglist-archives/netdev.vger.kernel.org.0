Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637AA48DD30
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 18:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237271AbiAMRwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 12:52:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:20101 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbiAMRwx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 12:52:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642096373; x=1673632373;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PW3O/FXztKDXj8OX3NMwq/933faQSkO7bBcSiSYijPA=;
  b=N4RTKsvR0S4sZ+lsUz4/2sWY6TCUM6U+ewlSoxBICoZfHgMY3sQ8R0Ip
   HrfYdExpii2ySzeraKd18fEMRpjt+YzHGhxfrWANNZgfzhEKHTWBoDCBR
   o7G4XCCM53l8I96CKPK66QE8IUgP5udWCKYflV8GUph8nI6fpkwBWOGgV
   /5P8XMmho4J1mTs4OUi42enBp+uTyzOrhjHblhYkY3yCYXWcikxJjk3aO
   P8M64A0xf0zZvjhAHTCfsvRauZuT7sD7L7Ih4wVCJ3ofsMs5maeHQ4Nu+
   S962LIWYC8+ftLRV3JqfzAwdsxKMxAjeFMQmOJtde3wexyWS3JCVHCA6t
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="268429796"
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="268429796"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 09:52:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="763339929"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga006.fm.intel.com with ESMTP; 13 Jan 2022 09:52:52 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 09:52:51 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 13 Jan 2022 09:52:51 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 13 Jan 2022 09:52:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POqRGNp8OsoaCUz9ujkYJTQqsZsvtOQ/N2DDsb8DxCT7t9K5k+2j/sioJF+iz6zXLl8X0cQAi4YcpbZL7UZrGQjjcWbXHc/hyGs/dMH9w0nTf2AZCUA44wsbobY/eVzVhtpZQtMKh9W/WJI/PNu9/7PvvDHAhzl8Yt6oTdPb737jKypVSc2llMEsrWhhPp077PxUXF7m/bDHF8n0CVeRrOovPfPNXHi3+UQjWlsZ7jcRLX/2D1OhuSdOxHMeEBq2eHITcSrUHQITcTZT0yWuYSPjIV6hLqpr4K+gENVG3XoEw+J+HfIwZW3Uwdw3x9jOgl4ds0zwqUcRkb7n/A9IRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OoOJHdTcuP35kPhp9OIwhyFNgVFpKYu15gWzMgZxBdA=;
 b=b1omGRnnmQyAAriQB8Amf1pw0zqv1ckR5U+1LpD7AdZrHrUwUYSDlyW9tw2sCklWWhlxfJskDYbZ9l51a7EdxLRPbNCRu7TnH2LtVe/rJHKeB5XHfnEzFDHHkRVwDyZeyiXr67HFSRm1zIMQE63RSSQFuIJEbC10ZIRDNeTc1DoTnl8MSH3z7IT99Wdu4scX7BAkcCQNFgNRf6Ev33SGePOSXYEtkPO2cKxeXCKd8aQhRKyimULP4TszIvTKGonRjivBtIof+mRtb0fXpzTTLpkMkVr5dr9ysmkcaA8VIXc/q7d4rhs+ATHWMUWel6HCap9b1PQiT5ZvkTBhxuxbDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by CY4PR11MB1383.namprd11.prod.outlook.com (2603:10b6:903:2d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 13 Jan
 2022 17:52:50 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b%4]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 17:52:50 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [Intel-wired-lan] [PATCH] ice: Remove useless DMA-32 fallback
 configuration
Thread-Topic: [Intel-wired-lan] [PATCH] ice: Remove useless DMA-32 fallback
 configuration
Thread-Index: AQHYBYZEhjZ2hIhe/k2cCu256g6rtqxhQZiA
Date:   Thu, 13 Jan 2022 17:52:49 +0000
Message-ID: <BYAPR11MB3367988A2E1F57783A98B083FC539@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <6a4df3e0a0849f179f9747f47b9c8cae53b29b59.1641752692.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <6a4df3e0a0849f179f9747f47b9c8cae53b29b59.1641752692.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58e02300-9670-4dc6-e306-08d9d6bd83f1
x-ms-traffictypediagnostic: CY4PR11MB1383:EE_
x-microsoft-antispam-prvs: <CY4PR11MB1383584BE1F2A8962F5CC80DFC539@CY4PR11MB1383.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HbJNzoFpppRV3rciu66RhE2f7N6TMpoFE7XZm2cSZDN8xX48SF5Geq4Wm1wCXUjH7kSSdW94DRO6qMtiaCdLFVp1GvkNma2ibISWJ+Vz/tELx3NqDzUpvWJyn9lczU0XUIAVM3N5rKtEE7PpCWsyt7f+ptSn3H+MrC4WYuRMSurHAKcx/KbhL620Lkxp7vosZJ4Gi+Gqb0KMAb1zdxODKCU/MlfIYG4GFtjJZsdjISuQHyYWAMag022gW2+otEGKZWKnku7OhOKOdIWi1zjNCbVI3C0bYTLlwOxNETfN6Zl4w16OY8KHl+QIN+8P2aTJ1Et5KNCSYo3i2xJ/g1Z9XV9EHbKwwRVHJWe2LVnyDT0IPaDuoGFtTMwSP0pZB0F4AJTbtXBlHQygvc0zlEFQOm/Vj/BWcpuRIofXt4dk+NJXnRAqhQl10YSVarBdnq2qzfy+r5O27vnlvtZwen6hxA/Vn4d53TdrU+LR9Bd/mMo0y3YmUwMl+4E9sdncV5ssRi8D2UxkECRC/FSL4NvZLEyudRm5cmXAYo//guL+juOHl+9Ug3PksgPdv2BmOHmCJ5uzs3yujgrFctTiIJmaMMmZoG2I+2LrLp1P2n0GdKwSk26YM4NRm+6cPczBaxVzvVodk6dqO8i1cD/t9TNQTg+VLgbSps8QAzrjAqf4P9kRl5yfBwjRm72RnAVUESkRhxQFoVyt1HKRl5oRQRN/otj/aB+2kVqzSR05GJd7/DhO2uaQs/Z38xX3G9vl86LKTt80yjDQmoC9VkGkhagMPwBE/i+YtjxwgU15cMAWeT4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38070700005)(55016003)(82960400001)(966005)(186003)(9686003)(86362001)(4326008)(52536014)(4744005)(5660300002)(33656002)(83380400001)(38100700002)(122000001)(6506007)(53546011)(66946007)(76116006)(54906003)(110136005)(66556008)(316002)(66476007)(64756008)(66446008)(7696005)(26005)(2906002)(508600001)(8676002)(8936002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qiz27i6pFj3ArO/DNNJjv20NOpMZJGp0LpPKdMVA03PO4pSGcSy1XBHDg5CJ?=
 =?us-ascii?Q?i+iWcDj2NXaBVRS7NuwrLpso4JWkiapnW647m23FQWZ5uaaV9NkFwhUAdft+?=
 =?us-ascii?Q?z4pGohBqfSX1Qw45nNyY0kO4Npa9Fjk/AAEHtIntCis8zsXvN5org7kNrYjM?=
 =?us-ascii?Q?TXDETaWS1YabrA5yZy621QVkRxfWCVKh7nCVEzZyo1fExINpwctJ36Q2dKwC?=
 =?us-ascii?Q?R4KxoXHTItIkdvpI/g40ooqJy9r7/p8pUjZbotw78XG5l4gSXFHnBdExHlL8?=
 =?us-ascii?Q?twf5oB/5jmZ7DE8zVWW6GnFtY6up/58oS3hVvS7DJb2JhO1ZmTMUnHEQcQc+?=
 =?us-ascii?Q?dqYCmO9A5Ox7SRcqFklUYNFsjdfvx6lmYBMPjGK+mpmOVEoJ8c6YH7f5oowS?=
 =?us-ascii?Q?KaCqRxatLLvuqNFjhZPiS1HR6J5bvL7ClVpmrJI9Mh0WOHB0pkIMKpI0P3zz?=
 =?us-ascii?Q?3novjjz/DUfVxGec4tda623bpnMLGoEtDQPQV4+MTlvXl0OK/vCiFZVH7dl2?=
 =?us-ascii?Q?kiqfnugfvWvnKnGUTaFsI3G7zHs5jCpWeQikEoo5ncP9mhsqJ6XfREVpWkBR?=
 =?us-ascii?Q?pn9lPLbPK9p72TwfExOcvYLkGNaovy8JgWwX5H+Dy9kuiZxmxGTOC7KWj22l?=
 =?us-ascii?Q?jCmqliPM/aDe2K5vtC688bySTxX/P1haoxhyeLZk/dGgOjm7e5tfBVnDQIum?=
 =?us-ascii?Q?xNwcy/B9Y/AKBpaexLXXx2YJyg+fMhfUECfSMDmHOFM92S0yicDUDe2b5a8D?=
 =?us-ascii?Q?4gC4XDXjWd9dc2rSpP8/r82HFOTAj2pZRWihP2cIRtT2WDnop0r3qi8bWAZj?=
 =?us-ascii?Q?5IoERyWuUZ1wxeJK2B5gS4ughbW7riOLLO8bJCrdU912OArw2+0Aom9RyuBs?=
 =?us-ascii?Q?wAa/yQ+RIgV90TivkQv8/wReOBD46lDonh1WtvGnq2pVPXJdTj4dbc8YK6Sl?=
 =?us-ascii?Q?giYKRf8RLbtFKweTHEJJisxWWvgTtrjg6pc3poUSeAp7aQwxWJEXgL3YNzZ/?=
 =?us-ascii?Q?nc6pttyZ8HNnqFvkTK4yOMarKq7lu269ohmioI8lc56Dw3kTBdw2pWjUTKu5?=
 =?us-ascii?Q?btmh7z+MMC3/wAvuo94P2CmjulMv94R+bzSAkhv2QqKBhQ8zK9/BbQ2sryqQ?=
 =?us-ascii?Q?8rCVxhILfYgTvPklczu1yBOpuVLzT7kCsgF09g+fh184i8mfrp8Qk2N8e4g/?=
 =?us-ascii?Q?04jjCdzEiuNgNLeJzrNnshMtij/AVkeWCSb7chhV7V+ZRKt2dW2vKa/ucVW6?=
 =?us-ascii?Q?p0ylEV4e2oUyoY3spCEnXg00MTc9GNayG9vX8VIAa14yCOfg5uHytUve6ee5?=
 =?us-ascii?Q?3U3A8Dyp0COvfwEq25rl8ztay9PAdycSKvDdSzBRGUPSlhfl/vPtaTysmWEM?=
 =?us-ascii?Q?/q8tYvsMFA9MTdkDiloObmYfJN4p2SIGDy21+oAapuDOd1NmiEO58XBKgA7h?=
 =?us-ascii?Q?7CjHAe72owoY7t2EeMIVPpQB2tn12oEcOWUc5NPRVgcqaIu0kZKtdXy224oJ?=
 =?us-ascii?Q?An8Ibyn0n8ql9Qxg7Ubj9eqPAeM35a1Fs/ESAqGbJEnVRKMCSKeoCGLFThI7?=
 =?us-ascii?Q?QqyhTrd3wwWAOl7vDPr7qZRYN2W4DCqspd5cMqsyAR8g2hOhhUlKU2NEScJi?=
 =?us-ascii?Q?kQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e02300-9670-4dc6-e306-08d9d6bd83f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 17:52:49.9685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GdOmlILGY0AYv55QAl/yFJ26CgTbTDZkM4CThTXaL+iIbx4nXIvqh7wUe5cDK29bP4t2uOG3o6V1dZ8blD96GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1383
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Christophe JAILLET
> Sent: Sunday, January 9, 2022 11:55 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org; kernel-janitors@vger.kernel.org; linux-
> kernel@vger.kernel.org; Christophe JAILLET
> <christophe.jaillet@wanadoo.fr>; intel-wired-lan@lists.osuosl.org; Christ=
oph
> Hellwig <hch@lst.de>
> Subject: [Intel-wired-lan] [PATCH] ice: Remove useless DMA-32 fallback
> configuration
>=20
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
>=20
> Simplify code and remove some dead code accordingly.
>=20
> [1]: https://lkml.org/lkml/2021/6/7/398
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 2 --
>  1 file changed, 2 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
