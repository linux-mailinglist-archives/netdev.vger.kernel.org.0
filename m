Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA533ECD2E
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 05:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbhHPDUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 23:20:09 -0400
Received: from mga12.intel.com ([192.55.52.136]:24141 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231680AbhHPDUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Aug 2021 23:20:07 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="195371807"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="195371807"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2021 20:19:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="640376597"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga005.jf.intel.com with ESMTP; 15 Aug 2021 20:19:35 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sun, 15 Aug 2021 20:19:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Sun, 15 Aug 2021 20:19:35 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Sun, 15 Aug 2021 20:19:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWND5tZuFteBmqvZIQJv63GqgH6HtNFGaPrYXKrdlF0m5zyWgSDwa8EVWZP+W/9fp7HtqzSngAwioxW4StPk8tmLf7eitcH3ROhH/bfET3VnXy+97fI5ZYfoiNx9W98BmqJJOx8v3XkUrha9kAYXI3v21ZnpSiB97c/6JM9woGl5xsqQUYwvvhTI2LJcevM+oWkhuLrbHvWNNTTJXfAfehyw2sHa5isEXK41DFtncsEIx2ayCYivTttX/Hjw7dQNKoSrk5ArKUyn/Hdslqmpk7syWG+2UApg5CRozZhqwhezsooQPu+q9MDheHmf1zmrUz2WiqH/YI3ahfkgzq82QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1h924yiZJuwGFgCuSObrioInH49aoKaHg1uRUFdWWs=;
 b=LYHEJknYfzpFhHyREry/TBnwK8sXEFaZCEUmheuUsS6jmCiWiKP57zYXBIcbcfR6oa9hpBRqqrzjKkuK9wIaPeBsTDlNZ8upI5hAsm2BDh6ctSquONZ8eRCYVk6/p45CBaJtb1zWUrfRcuTk9zrjynuLwpq2dZ9DMQtEl1J266wsIBppD2UFyLl4sk4DZgKNEGUXcPmkpGdeBeQxr+04P990texp3z+4//cL7Ryxx6X6w26WHoan3VNKlvvJQI2wE/gNlOUSFv1YXc+TZw1V6/tTvlOTEf6clzrJs337biB8jarJIXMEJ6PRbeqfpnAQPTfnpo5MpMgl1NaRBT5SPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1h924yiZJuwGFgCuSObrioInH49aoKaHg1uRUFdWWs=;
 b=C1fXmXCuh50z8gzk3EDtUELjMvJ9lekeyuIZyS9sd3dZq/zGjbzT4pXU6BE+hs1YrYKZO7Ks9k0n0lyusVrjKFEP6pDVSm+AF05zoIrUNT5sBc4g2rb7JutVorZM3ohhIyuvJfHUT7IytsBb6ETc9CDryLfby5vOxA1ReQs+VDI=
Received: from PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20)
 by PH0PR11MB4790.namprd11.prod.outlook.com (2603:10b6:510:40::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 03:19:34 +0000
Received: from PH0PR11MB4950.namprd11.prod.outlook.com
 ([fe80::784e:e2d4:5303:3e0a]) by PH0PR11MB4950.namprd11.prod.outlook.com
 ([fe80::784e:e2d4:5303:3e0a%9]) with mapi id 15.20.4308.026; Mon, 16 Aug 2021
 03:19:34 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Thread-Topic: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Thread-Index: AQHXkCCVH1orffAF2Euk1FyXsMmop6tzQucAgAAKnYCAAhalcA==
Date:   Mon, 16 Aug 2021 03:19:34 +0000
Message-ID: <PH0PR11MB4950EAF1FC749EAAE3FDFCB7D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
 <20210814172656.GA22278@shell.armlinux.org.uk> <YRgFxzIB3v8wS4tF@lunn.ch>
In-Reply-To: <YRgFxzIB3v8wS4tF@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5176b100-b42e-4b34-0045-08d96064abbf
x-ms-traffictypediagnostic: PH0PR11MB4790:
x-microsoft-antispam-prvs: <PH0PR11MB4790D0933DB69EE50C23D641D8FD9@PH0PR11MB4790.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7mXIVnrYDoQmBOlmOBtbIExQFSDoTlvhiQ52+Dq7hUtN/nc2YEbKLI0qIFZ2vMepCYHFU1Yti5Ep2y4jJmmiyU5re2MguP8TYCJpjsz1j5iEQ8BxHwx7ydFGH1JfB9q+1c9XVCWLbO3Bt+crsEbjN0oda74ZYds6z1T/EIjRfqwB+/z1XyKjU+FaR2bDm4BGfRuBB5O3sE2Vnl8LS267x3VV2TRQiPBEe7ySIKxE8yOXfkqgZdVnD51LIvVIQBZS2qGVeAPRbMQVNMdAbB4/3aSZV6zXYOuPltKrDrEPNZvDmg3HZV6ihg/dqPe2JfFov7R7G30LcDeVtEZ3XK+iiqiph79b7XRRwbXHMbNGeaV6hgKZaOsMJcrMo5NVmkWG7WkPU3UM8G3tHiIMK+qmT+1WIwW89W/Pr/dq296/C+GXCnIc+q6aHwR8AD/J8Pg+ODmh6e5204EybZx9Rcdjqb1d7ogFZffFQIS1mNFJ4QH+LKdb5D6+hk0LOog5XuJVcj8cyXgLTeNXtGw4Gr5YTxmp5btAHscRIx42VpwqN5NXrdWpMftT47OD4/8QZvIZJurxGys3azgTwBnO/Sc1wowgvs+av4NOGAq5m8frQ4925jtE3410pcTawnGFjG00o88wG+l9m9NnClSL7Zf2BywyHx893/WJm/GLmDa6jgSZZgM94V1m7dQ5R3ACQHpJI+qBh+UGRmn+TxBVB3fmPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4950.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(8936002)(4326008)(2906002)(8676002)(33656002)(71200400001)(38100700002)(86362001)(83380400001)(186003)(122000001)(7696005)(38070700005)(6506007)(5660300002)(55236004)(55016002)(26005)(52536014)(316002)(110136005)(54906003)(66446008)(478600001)(64756008)(76116006)(66476007)(9686003)(66556008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Ufs9cviruIQKkpe26RJ8fGKbQM+hih/JOvdf8qQlI3Txvb08kqQ8BmY2Dn?=
 =?iso-8859-1?Q?232nlMd4w/eHo03kvZ1vfb0r3QdNDpPHXG5NoAQUUgrLrMEg2zg+tY2RAM?=
 =?iso-8859-1?Q?PH/SJccqbartCvgtwkiOe9bHEouf09d7qIip5mjgcU9j/37Z/uE2OIdzcy?=
 =?iso-8859-1?Q?ed8CyVeOY6AnvkaCeCGTj7XzOzrKlgwDyTNVAvXJ2BMPgb8iklfz6y54P7?=
 =?iso-8859-1?Q?9QG1jLd2Y7vjh6VCjfrEpWTisBtUOqLhOctRbAJ1aILXATPwnavhQcz2Oj?=
 =?iso-8859-1?Q?4pgzTVTAYGQSqJogA5PvPnNRcYmKeB5zoAhezrAQuzmE7lYLgtOp1CLD9E?=
 =?iso-8859-1?Q?m+lnrGhTdWLwkjPnuuuH3DfPPQiQJtdSXUJrv9cixl6JRTqvPYLLKx9Gqr?=
 =?iso-8859-1?Q?08fmJ776MZlzYY/ePOzLLgTLm4JCqUeWqs8REFztiFL1eRF6PNyl2xjyvx?=
 =?iso-8859-1?Q?SXEVGra+tIv2U55ANksevjGxLqCHe2G1E4vqzecwdVLlu+Qblawrp9kYnH?=
 =?iso-8859-1?Q?D+pYkLMCrktZ1wijPj3efRYTZsw4V8LyeyGsxeCyXXUbDHROLzolfATnc9?=
 =?iso-8859-1?Q?bqlUrdueKrT+19PPLMY6YvqDE2PA+XPfKIDrYMzZL7DVcaplXbsT7UHNkn?=
 =?iso-8859-1?Q?SIaBtyJqrKSPQkHcAtnz9z3XcVTPnQ36B0jBRiCUdlrRwmla1E/mtaBI+i?=
 =?iso-8859-1?Q?7Qdgo23mJpIELEj+rZ6vu6iVtWT5XjNBLpk6o2lxK8LJZ3kg6HYb4Qrd5X?=
 =?iso-8859-1?Q?AyAkNsYkWE5wFWVpyIhFDYvgC0KZoZFMfKJJR+pMwht5LVb2JDxN2hYVnI?=
 =?iso-8859-1?Q?YCinzYGCahCO2anY8SrWMCUA+OdRMFxaTyuxjY57Yr+HQUct41ECmA9LMH?=
 =?iso-8859-1?Q?pT5y/y+qeH/OeYKpzQFYQ0PKiMJse8kDPJSmzKu+wwc5B6NZ8jEQ0K0I2z?=
 =?iso-8859-1?Q?7+dl7oABpqBwDd0VJ8fgcey+T8r384u297p1Rc2G6qDd3oVKnPRBCrCy1Q?=
 =?iso-8859-1?Q?yKy6PWMmfA5psw0LJU6L0CJ4HxO/+uXOifbTvY0H9sNV7xyWFiBWEW64m2?=
 =?iso-8859-1?Q?LGPhg+oOgveY0ONe5x4YfbWqpYgIKE5p153YlhsyUOsbngScQBWyU/vdvL?=
 =?iso-8859-1?Q?tCBFNszL7MXsvlLxm2QC/89gNUsuK9rPo6lMMQNHQHMCzWiHoK39PBOOjq?=
 =?iso-8859-1?Q?slpEvbEE3+kayFKJ92PZecJJljMsrQsbf/h4gsg2jKfFjjCzs16erwJRaH?=
 =?iso-8859-1?Q?4SCGnDdRpDEHwCvXQnnHFXfreoOiA6S57BasnrPfjZGxTW4C9xA5mXUcbi?=
 =?iso-8859-1?Q?HYFvKt7IVq8V+HqZp6nYoBLu8nO089SMqaeJm8dU+bcCppVAIQ1+IinLoF?=
 =?iso-8859-1?Q?M/pAK57OsG?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4950.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5176b100-b42e-4b34-0045-08d96064abbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 03:19:34.3047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GbEeRl7JgqScFBD+bXsYpydR7KNXtGSIOHZ/9cGj/i7xboy9dvjBnLLDRggG3PffjOeZwN0cqiuRgVutbjjV3cicUGKp1t0ycOhjZTbAglU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4790
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > How does this work if the driver has no interrupt support? What is the
> > hardware setup this has been tested with?
>=20
> Hi Russell
>=20
> We already know from previous patches that the Intel hardware is broken,
> and does not actually deliver the interrupt which caused the wake up. So =
i
> assume this just continues on with the same broken hardware, but they hav=
e
> a different PHY connected.

Hi Russell & Andrew,

This is tested on Intel Elkhart Lake (EHL) board. We are using polling mode=
.
Both WoL interrupt and link change interrupt are the same pin which is
routed to PMC. PMC will wake up the system when there is WoL event.

Regards
Siang

>=20
> > What if we later want to add interrupt support to this driver to
> > support detecting changes in link state - isn't using this bit in the
> > interrupt enable register going to confict with that?
>=20
> Agreed. If the interrupt register is being used, i think we need this pat=
chset to
> add proper interrupt support. Can you recommend a board they can buy off
> the shelf with the interrupt wired up? Or maybe Intel can find a hardware
> engineer to add a patch wire to link the interrupt output to a SoC pin th=
at can
> do interrupts.
>=20
> 	  Andrew
