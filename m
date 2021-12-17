Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E06478F83
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 16:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238119AbhLQPYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 10:24:01 -0500
Received: from mga12.intel.com ([192.55.52.136]:46788 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238122AbhLQPYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 10:24:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639754640; x=1671290640;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2cgkxd+6dndQGy3BAy5U/+5+IHrkVr3uxGNlaMGNIOY=;
  b=lnjk7v9XcUJmJx7l6cSPUhQcflPP+MDBRCjtAvAtgnuKoXAAcR8arq8T
   XRv909yTvkoj5RlrK54JrtcYIhM3D3KHv2hExOPakJ0RskgB1vu6R9FqV
   hlXKhp0mJAHBD3r4SbeRT/JyaFDE25dyHzZ9n4dqiDzTzyHuIB5PMtufX
   yqrPtlK8IDk92UWUM+yJmNUdIEcTeglF5ch8jywCyHQlCyN3+66PeFbr0
   bHerEF4nyynq53O3t8FhxPvk4LXIUelKPVSpmB81QVScIsYMI/HSR4lvD
   33lry4+ghOTFxMaw6t6lsfDVf3svb+agGckPpQ8yydCxydKkuHeKmye6B
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="219786405"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="219786405"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:24:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="605921302"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Dec 2021 07:24:00 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 17 Dec 2021 07:23:59 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 17 Dec 2021 07:23:59 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 17 Dec 2021 07:23:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCYEu1O1M4EPEbFQLo3Y9fCsQ1YZ72Qvu8d7OzfBz3e9MmukucfLDwp2DjxCaZQC4ZChU8IRQsqvf/SJ1UDmYWpfCiw+1eL81RX1H6RzQO1JvfPVpkvThKTWl9mehqZJJGlZRERti3wLOjcPzPQg4Fxc56ZE6n4ZZNeF7tlMJKkITfOW9CJTDY0GN28vlr3T2+qlfah8oVS3iqaFKwN1DXcghTG5bHrEqySUe13pTI3rW8QkzpqEJCAhH2vVyCaRiDuvKqpqJLnFX0BJVHz6VsaBct/b59VwNLVws+dkcqetzazK8iXCweh/JfiOoXsYdDNdJWNXxucV1DAEPcN/jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q05eG7TBL12ISLW0tHLTws4ej8JP33wFUg6FNht2Vac=;
 b=HpoaHdj0eIkkdMJtjSI+tpeQc7q1yGjLlPO+Rt1OmvpVyhOTRP4s0VkRPV/RIv9eTr9CLUZB0pF3pmYb285t+Yn2nbrf4wA6tejuP15sV7FvfoIAwuK7MgKOREyBbg2f/HTQhn4JUHkUdsPtmA16D1qZ/HpGBMs0PiAVxG22u1fTV5U+5/IWxvGAcGKOhKpl4pRz1QIeKpAeExYHiAWbFhYSba8DsD2l5Nbz2sssZey3OloRO3IqDFQ8lSB8RPFQoJjVhtVkzsUtOcaIM0GqzdQyPefq/ek9mmA8uSFJfk6etUUzFBGiv6qnQ9hwyec3R9ONVyvVUgB9WOL4IzIhrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM5PR1101MB2105.namprd11.prod.outlook.com (2603:10b6:4:51::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.17; Fri, 17 Dec 2021 15:23:52 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::84b0:d849:dadf:e47f%3]) with mapi id 15.20.4778.016; Fri, 17 Dec 2021
 15:23:52 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Mathew, Elza" <elza.mathew@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v2 intel-net 5/6] ice: xsk: allow empty
 Rx descriptors on XSK ZC data path
Thread-Topic: [Intel-wired-lan] [PATCH v2 intel-net 5/6] ice: xsk: allow empty
 Rx descriptors on XSK ZC data path
Thread-Index: AQHX8DahZ3MoNPqVZk6coIxkBONeiKw2hIPg
Date:   Fri, 17 Dec 2021 15:23:52 +0000
Message-ID: <DM6PR11MB32928282AF0C5E3C90621516F1789@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
 <20211213153111.110877-6-maciej.fijalkowski@intel.com>
In-Reply-To: <20211213153111.110877-6-maciej.fijalkowski@intel.com>
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
x-ms-office365-filtering-correlation-id: 863eb757-0f95-4527-dd70-08d9c1713b6f
x-ms-traffictypediagnostic: DM5PR1101MB2105:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM5PR1101MB210523AC2AA46A5029CA639EF1789@DM5PR1101MB2105.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6T/87FnccP8ST/9E8swI4zR338HJz9vbzpIE/S9jiUTE4/MVFLPl6C9DGVQ+LXmrRRHPae1LzWuovgqSTtEP4hawmBT+NUADr7KKZUym/+myMtvYBpf8YN9T+y6/rKBf0HJnVaSbGWXBoHNACFAwr7nFVe6+QuSt/Yhy4zSBqIm2MwdCWMJiui0hn5Lq4g+EYHgRTYX4CQyCs1pdrOHz8pYgTRPxYyle6tJBATVJUheXzz5o0baUDFj1Q8xgXC2JsIXpgRtB0RfdXPM8g80GWqlQ3GUXq0nqBPL0YEFX9pI+EsnW6okgvyV8ldPsiO35jV1/DILmQPeciH0EfZ6FVEhNdOwQMYv3lrj17xixrWnC1g+xXDSfBSFe+3Yu0dNlsYAdvzU5rs9YCWEl0vP4OdD6Vuk9NOhIJme2ay54bVsxGzHSN4QQOsDTbmwk00c63gOY23hlxFqUAPKoNrDSNFEDGfrStxa8WEaqSfHmtSy1Fbfn4cl9r7xPnnKXkeRgDaMA9k5mNSb1/8hJwK9myq3arRrjmIngJ88SE//72KUnM0/935Ta25gW/lww1te84KcfFqTB9aimUREW254DcYIxXiSuchsUe3YCLEECpBAA2mSAKPPmhLdy7WIN7x67pc7M+4ljEwUKcW/+fpXKYLaB4PmBDTaEhY7vs0dA7o/CWwcCJ8bR6PIZL6ozkQJeyFb3jo0pftKy/9CyGJrV5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4744005)(26005)(82960400001)(5660300002)(8676002)(8936002)(53546011)(6506007)(71200400001)(54906003)(107886003)(122000001)(52536014)(55016003)(110136005)(316002)(38100700002)(186003)(9686003)(4326008)(2906002)(66446008)(66476007)(64756008)(7696005)(66946007)(508600001)(76116006)(33656002)(38070700005)(83380400001)(86362001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J74sNlMj7EI3jM0fSdo5TXCZUd348IL39PjIW7gKrSzIkCfNgYPYqv7rk+Gd?=
 =?us-ascii?Q?nmb/vi2rwe68EyCsBemIjzWb+Em1C/wRbgQ+4Fu79o3zrkgwYriTodO0WV2M?=
 =?us-ascii?Q?d0ZAUImZ4FosR9nh1u3pl5nC6j24FcAXT9ogwHNp2mR0eXMdfBX2CDCq+7FL?=
 =?us-ascii?Q?hpmkdTY4+jW5XBt4N58LAiOmhyUYHtb+DKaC12rVGf0aBGGj9UgVFGlUhs6g?=
 =?us-ascii?Q?cXPhjiY+/brk3N8u8X47FDA+a5y4Ss+z14Sr90ABpA2LSW4gLe81GSRiYUAU?=
 =?us-ascii?Q?nm2wvhVB7iFemlGrju9kwa6VOdW9yCuP62CziZOMoR1g19VUXycis6ON+V9/?=
 =?us-ascii?Q?puK2Nm1okYLPxo+Jd5LGLfis7wNryfWcNSkvpssb4tCB7REeyICoQnRtPZRq?=
 =?us-ascii?Q?6NicD16EXG283hVvanLyhq4pLEcOvxGX1HUZpl55EQRhFK5Yxuv40iUHF0YB?=
 =?us-ascii?Q?lFjgMpU+CJg4bsFMXioeqB19DaKzCByiV2nuLMPeT2/anup+tDCMRAmkel8H?=
 =?us-ascii?Q?OWevNLOnQtGZ5jyEc9OkylojXay/XBzr434FEvvxnpCzDbUyVwJdSB4kQj/s?=
 =?us-ascii?Q?6efIIARLqMGTLvgIw13SpNze8zhRdACUjvDfYuqwIQnAp6EzDaEiIQuzKEee?=
 =?us-ascii?Q?4/ta2pezre8G9gnl/TFq11CnNxDD+pndIBEO4QjwkK3Z+TzeYMOdUZ5EsELz?=
 =?us-ascii?Q?Mn2fFu9Eh/Q5CjIqy5FUgfHyW9cQbmL40ih6zo+h5+2o0DjsLmUMO9VbTSII?=
 =?us-ascii?Q?Q2/7iOOUOeZXoJdc/VaRqZjhGZUmgUx90Zo6VRkH7dALWM8Fy67YhJFjs2/J?=
 =?us-ascii?Q?kLavZVg66QT+3t80scQkVpEqDCn6nZjMrodgKaqsAvo9aLosfJtd9jEru7UP?=
 =?us-ascii?Q?rnGIuGGHZ+DHiPqdIAmkzbzWHxG8QeQQ0beEnPoM+boOzSgmTZV/2tjTx8Np?=
 =?us-ascii?Q?N6jPu/x+2BwQhTtzYEFGgdQV+fCfiEOiuccuMlqt11VyjEaAb1YGVBZptr9X?=
 =?us-ascii?Q?ncwWmlyiQ7Yt9oMrqXYlStyZzfYrbK4k2lPJHQ/v9EPPY3rzcn2lShkRd+Se?=
 =?us-ascii?Q?wNMDWa68jdX1OulNqMGdDprlfS5zbSLxg+9Ehtxb0dPxEnsBEB0QM9kbrXEN?=
 =?us-ascii?Q?08yXgTZw/rnS+PBWBwCFdtR/XjqIoUITErstqzOItNG+I41RPXZrvQWE7pBP?=
 =?us-ascii?Q?mAmgOek/aJJSemp0XMfZAxyz1zh2tDuDnPlrvCOYI0CV2eIYzGdQlq8gTZYs?=
 =?us-ascii?Q?JIhPlE3cMt29AfdROgQzed+SgxFDulCgXjTPF8NiagKROoELGkoUY4gaQzzq?=
 =?us-ascii?Q?j6+IqMvlIwiHd4b+z3F7NVTNKc3S/741+qHJbAuqEDzE9OtkkV6RiT1bUQYa?=
 =?us-ascii?Q?Pe80E3JgC3lux4mlHAUPktWIc3VXQ6Caki+UPjNcj2VDHML727WuNkKibzW4?=
 =?us-ascii?Q?gKW+LPYMy7G3OiGjJT+ue7U6am3mOTmhu0oo30ycz7la4APavtGcRTuC1gMr?=
 =?us-ascii?Q?9ieOUtH2OBgOA9tVxBBOL7aE6TViCRhGyEYtEMRYeEUJby8O1XHQaEbf42uZ?=
 =?us-ascii?Q?DcBPKeIZquUxoP2KUMqns4qJRIv5H2gP3W8IXIIiYkVpW2T5g4YCDKjmU0SZ?=
 =?us-ascii?Q?xcMa3jcAhN/oSqrlF+yKyiqD5gKb3G0Z+nBtbqyxmFjZVqvxFxCQRjVk3FMO?=
 =?us-ascii?Q?YEUAfw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 863eb757-0f95-4527-dd70-08d9c1713b6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 15:23:52.1506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +AQ7xafsm/OoCMMpEt6BetZVJl/upp2+Jv113M0xiXL242qZY7fD33JJNXd3xwVaJHtH4wsp/C5VmwyFMxdqXtV8tHjK4qRuKnWotN47aSs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2105
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Monday, December 13, 2021 9:01 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Mathew, Elza <elza.mathew@intel.com>; netdev@vger.kernel.org;
> kuba@kernel.org; bpf@vger.kernel.org; davem@davemloft.net; Karlsson,
> Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v2 intel-net 5/6] ice: xsk: allow empty=
 Rx
> descriptors on XSK ZC data path
>=20
> Commit ac6f733a7bd5 ("ice: allow empty Rx descriptors") stated that ice H=
W
> can produce empty descriptors that are valid and they should be processed=
.
>=20
> Add this support to xsk ZC path to avoid potential processing problems.
>=20
> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
