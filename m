Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A96521A249
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 16:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgGIOke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 10:40:34 -0400
Received: from mga17.intel.com ([192.55.52.151]:23641 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgGIOke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 10:40:34 -0400
IronPort-SDR: ubzEQhUlLFZpV0bBRZOdb0X4n7qPgS07Ac3tUuMH59aUplZhbhtgPrw0d1XfmCbS975C3NAPpD
 9kKSdxAMeapg==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="128075328"
X-IronPort-AV: E=Sophos;i="5.75,331,1589266800"; 
   d="scan'208";a="128075328"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 07:40:33 -0700
IronPort-SDR: F8V15igqbACKcOSj5eMkaicV90nNc42bKcGMQUfsgcj2ufjuiAlf9rmwWcpn3SMBc5zvMzm9o/
 c1A1dFa4u6AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,331,1589266800"; 
   d="scan'208";a="306455245"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jul 2020 07:40:33 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 9 Jul 2020 07:40:33 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX151.amr.corp.intel.com (10.22.226.38) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 9 Jul 2020 07:40:32 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.53) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 9 Jul 2020 07:40:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkzsO5IrXdkjShQGu+lGB6h1lhmPckMj+JBHiA53GT8F+t4um3MkjKFXPZ1CeQ6XCP0v9gX5mplFL/DFOYOyfogKsQ1EbExgF/WbpGhxqKXWz/QMyC7vMv0aHnisM8ecxk1O8WEZi1eKP9C/MHv3WurgsACYhMOdFJEjhofkvz5W003HsSynQhKzITvPyPhh1d9SKkSHIlzeYix7aHSOM6jZT12HlA/v5CzezNdXF5EWTGltlBAx+Li9wHNM9dzVfuR/Hbgb0L02T+zWjYcmDUbXvkIHBMlU42qht8li5DCQWrjHP2Fz0vsEjF7lPOwEgZo70S0ZKz51EjO3NZFvrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ompuPW2BLQZdB6nlO/nyK+hd+ZOboj5/3nUoI1/A6vY=;
 b=lTeP5dUXwyvAlMZR99LV/EU99DFDqJnECS+OEg7Z8cKJU3xQB194vmVh6aeBoHaeCjRjMQZyGUhLYTj1ecTXT9PjTNzQjWzvDZ6G3kBE73WmzydOCovMlCiWLFMKE6A/Np5GvcX18q2Vl0sHCY7PAwSH5o0JCDhSbpP01JALcxLMFbGKGiomhB4r5u8rPd5ZfUMIf8Vw+6H646Jy6nEH2/8S5nBmET+EarWvk19QQw0lDaoMOGOmgKg6561otuSEwWjy9ibRWdxBu85bCAkRJfDBLLu6y632JCPmidBu1uZp2iIiR8oaMnIQHJ2yX4b1z8kAxlii2dvgfifmKFqTbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ompuPW2BLQZdB6nlO/nyK+hd+ZOboj5/3nUoI1/A6vY=;
 b=cxxciJ9SjvvQnXXi6v2DbIKwkpyEQn11XzRyzL1l+VHtzcODEHsUoJeURjHV4eSAQ0lclqM0/ilQ06K2Iujn36SIccNtWcChFCw4o5KOJFgqCDdM2iTDxeSGn+uZtNaGkz5aYdSms0ogkw3H6BCUloI2C5ullGFHoH+q0v9pIgs=
Received: from SN6PR11MB2575.namprd11.prod.outlook.com (2603:10b6:805:57::20)
 by SN6PR11MB3423.namprd11.prod.outlook.com (2603:10b6:805:db::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 9 Jul
 2020 14:40:31 +0000
Received: from SN6PR11MB2575.namprd11.prod.outlook.com
 ([fe80::cd49:6ea7:530c:95e0]) by SN6PR11MB2575.namprd11.prod.outlook.com
 ([fe80::cd49:6ea7:530c:95e0%4]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 14:40:31 +0000
From:   "G Jaya Kumaran, Vineetha" <vineetha.g.jaya.kumaran@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH 1/2] dt-bindings: net: Add bindings for Intel Keem Bay
Thread-Topic: [PATCH 1/2] dt-bindings: net: Add bindings for Intel Keem Bay
Thread-Index: AQHWVBoHg2J3hFBg90GdtvIrstZWeKj8FvyAgALf7vA=
Date:   Thu, 9 Jul 2020 14:40:31 +0000
Message-ID: <SN6PR11MB2575FC91B5567824F521C60CF6640@SN6PR11MB2575.namprd11.prod.outlook.com>
References: <1594097238-8827-1-git-send-email-vineetha.g.jaya.kumaran@intel.com>
 <1594097238-8827-2-git-send-email-vineetha.g.jaya.kumaran@intel.com>
 <20200707130741.GA938746@lunn.ch>
In-Reply-To: <20200707130741.GA938746@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.214]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac0b75f1-81a6-485c-3000-08d8241607d0
x-ms-traffictypediagnostic: SN6PR11MB3423:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB34233D72645110E05E4C3069F6640@SN6PR11MB3423.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g4FfoPH2/QHtifE+deysKrlNAupLEzQz2m1qF7YasvOr5fO88bgOLlZxWaRiL6pyOxzb/avQ59ia16WtkRm8UVIJ38cdWSQSs5ORsGknuBcdQMc1LJI0HGq7Ew2UV49Sw7tNlfuMsHLgZm26ybTShHaAbHWNWRsLgboD6ePecbwP4h2KpZdMbpUrB+baNXdMRQRCYO9RYOJrjZUNkvB4/Hhqcp81PSj3HdZoLx3w43A5ZMxvd7Fa9NYb/eJTHC1VZredrW9pR8LNf9MOKiPunUY7RwkHANFV16/mqreANZdldiPS/ZACXHSF4recjIU7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2575.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(33656002)(83380400001)(55016002)(66446008)(64756008)(66556008)(66476007)(76116006)(2906002)(6506007)(53546011)(4326008)(52536014)(26005)(186003)(107886003)(8936002)(498600001)(5660300002)(8676002)(6916009)(66946007)(71200400001)(86362001)(7696005)(9686003)(54906003)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: qVQm2F/9oXjKPQPs3OAN8prH3Wjov1k3O8SKjDC73JVnX9Npu+Wsjvt+9wW8PLWL28/7E5xwYEe9X4KASiG8/EthVsVTTFJrY0rEkb46nZzQf8lX7O3nyxPOZZgF9tgka3QiNwukd3pzjcZS8D7yPRm+m5PKeLGCzT5pr9Nxsu1b5XWO4rM7dxxotL638eGqXWNH9n/AHV+cfXmW7plgO8pgnhPkqIxfbUsag20wpJfI3TsPjf0IlMcDzcGdJPT7tp7sb38vNK9dMfdJJXVv3lS2DldqtMfk5M85sMCPQ7DGaUHVfH6ZR5H16Pi383BICOX3+Da9Z3FN7R56swR2FeGSTWytrETHeY+DhuQQ0RM76Kmgc91rDLriUFIvWd26tnJ9FcaVXDORtx66gZQLAC45mcVpD16rVcr8oDwAp6mU8XhZrBrAMTXp4AxSwz33c7HfHh4Fa7On77Mo+zmFBHxkf9u5++6kBFMhPZL4EjsSrmC6Ux+pnZnMFWVgBUQ9
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2575.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac0b75f1-81a6-485c-3000-08d8241607d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2020 14:40:31.0350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6TVWjVAg9nM/015MyqA+hNTwhTkJuQNvEidYrSlLBHhtlwKPlJI2zKLnPDA/jRd2gnLtP0NKJGgGdhRliZkCV6+UZ5XFWXilrGrFFmv3xxzJttT8+VAaLhdgwz633qNq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3423
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, July 7, 2020 9:08 PM
> To: G Jaya Kumaran, Vineetha <vineetha.g.jaya.kumaran@intel.com>
> Cc: davem@davemloft.net; kuba@kernel.org; mcoquelin.stm32@gmail.com;
> robh+dt@kernel.org; netdev@vger.kernel.org; devicetree@vger.kernel.org;
> Voon, Weifeng <weifeng.voon@intel.com>; Kweh, Hock Leong
> <hock.leong.kweh@intel.com>; Ong, Boon Leong <boon.leong.ong@intel.com>
> Subject: Re: [PATCH 1/2] dt-bindings: net: Add bindings for Intel Keem Ba=
y
>=20
> > +        mdio0 {
> > +            #address-cells =3D <1>;
> > +            #size-cells =3D <0>;
> > +            compatible =3D "snps,dwmac-mdio";
> > +
> > +            ethernet-phy@0 {
> > +                compatible =3D "ethernet-phy-id0141.0dd0",
> > +                              "ethernet-phy-ieee802.3-c22";
>=20
> You only need to provide the phy-id when the PHY is broken and registers =
2 and
> 3 don't contain a valid ID. And c22 is the default, so also not needed. T=
he
> Marvell 88E1510 will work without these compatible strings.
>=20
> 	   Andrew

Thanks Andrew, I will change this in v2.
