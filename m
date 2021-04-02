Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239E2352709
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 09:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbhDBHpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 03:45:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:30044 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230492AbhDBHpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 03:45:09 -0400
IronPort-SDR: 8B/EjX4MTNjSmCiy9bAkHncHB33pTjRF1jCtU0W1iuTxtlgyYqyGTPAcrCgMjc582egtiMypU2
 Wr3vaFUD1RsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="179945023"
X-IronPort-AV: E=Sophos;i="5.81,299,1610438400"; 
   d="scan'208";a="179945023"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2021 00:45:08 -0700
IronPort-SDR: h0X+cMwm4H7ZTsxzfb8NJtOY2+J9hVv0gmq79pYysqkh3KpJB1zlWAvyl6ji+pKv3INZyQCwRH
 wNUyFioltDIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,299,1610438400"; 
   d="scan'208";a="379606872"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga006.jf.intel.com with ESMTP; 02 Apr 2021 00:45:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 2 Apr 2021 00:45:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 2 Apr 2021 00:45:07 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 2 Apr 2021 00:45:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7U0wIQoEey+YepiO9hCzT0/zrCL10F0iIWOmlTHu5ovCiiccsQTwA7/kDzvWCmzNV5Bj3A9K70a0/xYusMJ6hmv8dFTTTz6inup5BmAr6wm5Dbi+Eyp+i4XuwL5T49Zo9IxykG+wWxYx2itEsgI4yLOAJIwCyZ5nOceHqf8iikclzJSRAYlxUv+hvrjnIMAT0GZ2gDa5HNbVWvH+Nyddi9sybEt9kPc+TdXnJNrLr1sVzLLBhjbVownTvVwisK+yv7ZPs3F8Xdl8jZ/BcOggItFepl7NvFfQnRiGKgiPLNTlgHAyGJdhMVUSGU3qti8smuhAx7JvikHnX7OyJFFuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zx992Xjr0uR41avrnqU4PMF0cDt/fAIZhwQTMvoAcVo=;
 b=jykHwhAjwNsrmmosoJfGMYER79aKOoXU/UTX93XWrWwbx65nbqCRy4fhSBV+PYb0FqD/ZkGic1ifWCw9ifJNf71mF4KZlHriyRwN3qBSdKHoQxv57fI/WvDkuPs+OuK1Tb+tqabNKFGoenvagP4M3kBOA3Qp2gCWQe7QpuEsE7y4JTtIBjN1cbTtncwag/2vV68VrJvG2W5lDlpIusKoJvJ7Qh+dalo6vfIjqmZCQij2rssrEaJTwoWt7KqGZAWkgjeXnP73gGR1/yF+Q7EopDsMbpv4V0Cm3vA/JE4oLH+sorFte7h8Sw8oqlZW6IIlNmZJGOdNQbHXsyL/q0Du+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zx992Xjr0uR41avrnqU4PMF0cDt/fAIZhwQTMvoAcVo=;
 b=LMNyZza416bqzMcDmhPB1syLyxxz9iYS7P7ixJJ61s1nDP72AQvC95TkaNHFb9PTA9X6/HkW1k2M/EkBj3i/getTeUDmGB9gltxxuWGgPSmt/G4E1M+Ij/KCjVIM3cCoETBNL14keewpFNMgd38j29sqaOqN8OxRruEgQ6iuuOg=
Received: from SN6PR11MB3136.namprd11.prod.outlook.com (2603:10b6:805:da::30)
 by SN6PR11MB2672.namprd11.prod.outlook.com (2603:10b6:805:58::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Fri, 2 Apr
 2021 07:45:04 +0000
Received: from SN6PR11MB3136.namprd11.prod.outlook.com
 ([fe80::5143:5d07:51b:63a7]) by SN6PR11MB3136.namprd11.prod.outlook.com
 ([fe80::5143:5d07:51b:63a7%5]) with mapi id 15.20.3977.033; Fri, 2 Apr 2021
 07:45:04 +0000
From:   "Voon, Weifeng" <weifeng.voon@intel.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
Subject: RE: [PATCH net-next 1/2] net: stmmac: enable 2.5Gbps link speed
Thread-Topic: [PATCH net-next 1/2] net: stmmac: enable 2.5Gbps link speed
Thread-Index: AQHXJwi9OfCjiapOEkC0eUgABv6UiaqfxE4AgAEOrbA=
Date:   Fri, 2 Apr 2021 07:45:04 +0000
Message-ID: <SN6PR11MB3136F7A7ACA1A5C324031607887A9@SN6PR11MB3136.namprd11.prod.outlook.com>
References: <20210401150152.22444-1-michael.wei.hong.sit@intel.com>
 <20210401150152.22444-2-michael.wei.hong.sit@intel.com>
 <20210401151044.GZ1463@shell.armlinux.org.uk>
In-Reply-To: <20210401151044.GZ1463@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=intel.com;
x-originating-ip: [202.190.27.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0647f8cd-276a-446b-f1cb-08d8f5ab3ac9
x-ms-traffictypediagnostic: SN6PR11MB2672:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2672A39AE51015A797EE0C04887A9@SN6PR11MB2672.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NvnCDehlxmbNzkQGbXU9PlmzXQoe2eIkmAk3LrteBx6kb9xADY7V+rvmykZZtZrLIJ31xGYsAEp+BJ4of+aqD80MjPK+rF1K4tXc9CKTLkC2DyHoa+sS9Gnn2axlWWRNovjTpDTG8SCbCpVeExVbVx59zMRIakF5zBliUP7eFHfXLThZC6KSqUK3BTBvGJ7ubDJjJnTA8GPO13CJXT9oWYbclHTXuO7MOH/g5N/nTNPqnEmO717LM54f3Z+vWSltxKgal5WxCkYXf6fiR9QLcWTZYF7louLVui5slcPw+CHx2oyHOpVAkVcq1zVJFus8bzWwi6EnSUO65NRfAJIGo0DcOgBGFQHMlnlyiPmcf7xMJfEphYW1RIsT/qY5UopDy3Pvq9nEj76Om3/SDiqyIpUQSx/Z6YgCiQbUFyCl2JXrfTy+3nnnyMfdqsfHk1DupY8LFf2Cft+48K96IOfDwSlx+iCSPyZjZW7XG0Q0msu9mGzEvQArpCh9Lv29hjae+W5wuQ49+z07TtWtQAh7ugfReRWZiJblAlav1HoQCSJ9eUalqJnWAA3nd+IG7MMGiwY0SoFQphsoksJSrBBMIcWLCbVbfAHaeqsrCnUbXiCZi5MegCXjBHlYcDPg4sBnsVd/IBDjoB8BhGsLGxn1N9CNdVbpzCS0O9iHKEVNv4o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3136.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(136003)(346002)(39860400002)(5660300002)(4744005)(26005)(52536014)(71200400001)(8676002)(6506007)(478600001)(55016002)(2906002)(4326008)(6636002)(316002)(8936002)(186003)(76116006)(38100700001)(66476007)(9686003)(66946007)(86362001)(64756008)(110136005)(66556008)(66446008)(54906003)(33656002)(7416002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UbD+x7uyXLF5emlA+bLmLXn+fEbbKcqJnDnI+SGSJTaVyY15GyTR+Wi2vN65?=
 =?us-ascii?Q?bLWp+kUfOlJ4F1UZ1tsrkiLboyB3d7A5DEi1ns/utFbSZHoRQiIdxqmFkFZQ?=
 =?us-ascii?Q?PqMKS203msZrIa/UgrG0ZntVy5BtGDafON+tAWVDjqWGNo50L64Q6PwkGtLP?=
 =?us-ascii?Q?gTgptR/1NGuhKydu7mtqKpnObUNvnyqykrLQyimLUfEHGAIcvfVt23mhg8k/?=
 =?us-ascii?Q?QGHDnMe2lad8d1VfUAbtKT/gqm2uWgAL+G/ST0avUvNRix6SAWt+jIkhihGN?=
 =?us-ascii?Q?KZEkUnLV/TmA/ADMAQSWGCxQNiJLCVEKK//BpDFidnL4Xl30Ys2XGFb++5Y/?=
 =?us-ascii?Q?JIi0/Nxx/j5+xkfADBePSYGjRahtJ+9yMMLV6A6fiEY0HMu4Bqson0/Ij7gs?=
 =?us-ascii?Q?/AOpqqZ69ME1ONNWv59WaPI4mX7mwUr+J5VwZxPA12/3X9l4aRLCRmdUmv0/?=
 =?us-ascii?Q?pzgQrPNawgFKPSlx0R4GgzSjvEY7kHp566/ZZIJFphXD4v0x2IxoApp0t24J?=
 =?us-ascii?Q?IsldD2ewr/2eLFBV5k7SSF2p0yLgTYwzPFt0or8OyYo0lZQuelTgDVAdGiUt?=
 =?us-ascii?Q?zxPqeb9zyopB9N9dU1PMq3ZuYlYuJabs38JDIAezMynZttQZl6Q/Y1D7gN2+?=
 =?us-ascii?Q?Eo1qxVyctrchTxe8KDR9yOTefLJf3g5YQX/hO0qbUpojrVu6NkG9vQlwCFKE?=
 =?us-ascii?Q?me7RtveF4D5I9G2ypyUrpRRRMdWdRgGVooOASS1SiAr6ZLa/4PpEFFiIQWVE?=
 =?us-ascii?Q?zgBGcShJFMwUbUSJsowlALo9h47sRANnsXlydVMEC4ljIlOe/+K72f9RV7FT?=
 =?us-ascii?Q?VLVCe8QXDN3lX53cn/iF86GuCY0wnyoesiaiolvugvYAf3f6pUDyp/5Ke4Nj?=
 =?us-ascii?Q?ZpXSptX1zxYv9YkWkitHrtv2GE5y+9ynjlVb549CRXOTDzoRLNrpyLZsB3oh?=
 =?us-ascii?Q?xITL0JKqM1nHXAUnRoSYvRhz1/o1/+81S+QI6GW0IaZR39xYjj/nW6g5lbgc?=
 =?us-ascii?Q?ShmypvXV3x/o4dIqOd4v9RadvqRs7OLjM+s+duanKOhmyt/0k+fd5nEQfDVT?=
 =?us-ascii?Q?No/Vw2QZQX1j+v/5wL74uNYyrtUnGmePzRf2Cw3wb+EfiM/6xxU0RtaRaNeN?=
 =?us-ascii?Q?3i8AvQaxfmd1rFndDaj61iX9rfz5I59Pl6cA7C0EqEeiOYwP49q8Jg9/EKZ3?=
 =?us-ascii?Q?G8UkX+yaa+W17cr1xJoma2E1qGrTthI8apsCDw2TXZVc1g6J3iF1SR/eaEtz?=
 =?us-ascii?Q?6H0d167c1yyPKO1ATGMyCxeRV1kKQfpipRGOucg3/IBC3e26IoaKQLyOLryI?=
 =?us-ascii?Q?hc5Sx2JIezrRFD3NjKF1vkHJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3136.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0647f8cd-276a-446b-f1cb-08d8f5ab3ac9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2021 07:45:04.5352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P3d6/ChvUwRTtzECOx+GwQUSOG4CfxsdBqkeEx/TsGfqvdQkdNKG3xzCLPvcHS6LIYGccu8jqumchq2S7Dy4AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2672
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +	/* 2.5G mode only support 2500baseT full duplex only */
> > +	if (priv->plat->has_gmac4 && priv->plat->speed_2500_en) {
> > +		phylink_set(mac_supported, 2500baseT_Full);
> > +		phylink_set(mask, 10baseT_Half);
> > +		phylink_set(mask, 10baseT_Full);
> > +		phylink_set(mask, 100baseT_Half);
> > +		phylink_set(mask, 100baseT_Full);
> > +		phylink_set(mask, 1000baseT_Half);
> > +		phylink_set(mask, 1000baseT_Full);
> > +		phylink_set(mask, 1000baseKX_Full);
>=20
> Why? This seems at odds to the comment above?

> What about 2500baseX_Full ?

The comments explain that the PCS<->PHY link is in 2500BASE-X
and why 10/100/1000 link speed is mutually exclusive with 2500.
But the connected external PHY are twisted pair cable which only
supports 2500baseT_full.

Weifeng
