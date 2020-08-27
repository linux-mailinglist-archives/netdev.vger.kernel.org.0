Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D62254BF6
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 19:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgH0RUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 13:20:52 -0400
Received: from mga12.intel.com ([192.55.52.136]:2552 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgH0RUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 13:20:51 -0400
IronPort-SDR: dWHFIE71Vduq0P+1u5UTN04awJ+TLj5F3PoTN2gopH+IElL8AO18C4JARt42uxOVHsT4n7oGl7
 rjEpptyYmk+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="136077183"
X-IronPort-AV: E=Sophos;i="5.76,360,1592895600"; 
   d="scan'208";a="136077183"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2020 10:20:50 -0700
IronPort-SDR: TmIebvGCl3N2wZLZ4OyPlgF0dzbRl1wozT7GtsaqgPg4obZ9ttz4vBVV7XxbMHm40jSS68LF9w
 54vTLXNJ42vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,360,1592895600"; 
   d="scan'208";a="339591407"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga007.jf.intel.com with ESMTP; 27 Aug 2020 10:20:50 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Aug 2020 10:19:32 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Aug 2020 10:19:16 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 27 Aug 2020 10:19:16 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 27 Aug 2020 10:17:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCB48alHfSTgqUtOVAQA4+dp/TErBTMNW4SiDU0plDDcYcwXU4yZTmCiCUwhB7Qmf2sQ/WacvOj/yTLS0keNzbc5Bn3X4qSU1b0bybI0V+U869eRLAXXldPzKXboSSf3cgXrdIPDP9q42XQi8esRC5Qn30NecrITtNN4lnR4ufYX7+1wcDXLaNg3XbclG3D/cLgr8/vjShkJmgyg78NhoWN2Ulm1gqqo7ArGQ7iQZNH+h/koUM4yu7Pe7uJZBPLqLdcJd/age0+uC6No8jcKsBxQBMvC2dsuWsAlaDzhpalHdiAh/Cy16m2ucN60Nj7sOeyw6dJOwmsHc0b9k4pZ/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcscwJNRi8JQFKjfiKs56cbiIbT2zbLU8/yyn2igjkA=;
 b=WXyrxpCsdns0H2A7wOUP3SaWvk5Eqfk7QYkpeW1Drm6DLcjEUpG11C/o9TWI2ZrXuJ/wirQMjUeI1fwttkyITZVWta+WHWLBZAxeM11ajhnufWKvClJSxvJF3LKnkhO4JcPJIANXPq6iBUnlZV5RmXs9lWiNzcoG3QNfqHPxXKn1DOz5hze4Am/zbC9tMFsG3DxcNc/fSoLIAFwtmbI99LNpiTYtcNRJI0qvwg5gwLoWKD/olv1kTdmKDJetVZK152fvt2d9qE6FgwxKR5zfQNkgjkFlW0z2UOnOskjEfvdVJHi2zX0a2NmJ3gi2+0kbw69FIsBrhOq8VgW1ZqKYgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcscwJNRi8JQFKjfiKs56cbiIbT2zbLU8/yyn2igjkA=;
 b=Q8NlVm8M/roOvV/ppud7NTZL0wE6j15CT+sUERlHre7f2ohJGkpk4+m4jBsD2gtinTeoBUXtxhVU4MTfahZQA2Iopb97e14hE5AwM5HDHZbpJhHw8wIKxUGD8LaSaVyM3cvijAewBfRidVun7ZG2+1dZXzh4A7U8mnPkIktQHbI=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB1727.namprd11.prod.outlook.com (2603:10b6:300:1f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Thu, 27 Aug
 2020 17:17:08 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 17:17:08 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v5 11/15] iecm: Add splitq TX/RX
Thread-Topic: [net-next v5 11/15] iecm: Add splitq TX/RX
Thread-Index: AQHWejy7cEsFm/B8Tkq3fnGYOJpzOqlHuT8AgAR9/hA=
Date:   Thu, 27 Aug 2020 17:17:07 +0000
Message-ID: <MW3PR11MB452220A9F8EFE1D90E2224248F550@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
        <20200824173306.3178343-12-anthony.l.nguyen@intel.com>
 <20200824134054.4dd467bc@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200824134054.4dd467bc@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2f301c4-e71c-4ae6-c3c0-08d84aad072b
x-ms-traffictypediagnostic: MWHPR11MB1727:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1727B9C67D2F871FF816E00C8F550@MWHPR11MB1727.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:494;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ya77dAc1HX4kaaZK2wxe53KVib0927Pp6pwHdV1Ou2W6cZMwj4/pdYteLdE88JuPeNyPS5Nn5fv9iX0OdKkNeaWEWYomdTq+fOzFkH9ewa6hLvXsuGUpSUzcgDHGz8fF+mUNuR1gxNlf3gV073uTgMKepNFD2PN/C+yfD4T2n6EzomHL12GvjNF8D/nRyRNjzGhJR7XVZGnVrYporV6z2mx7TlKIuu121PWuc9nFY8iAeKRXFkV3vXBA5qi3OX7tiSOeWQzjyoA/dlLVt6W5bvDSkMs0pIkZHE6GEzOm2YQ9/8icHazqbqwlUovPQjuoQwwOhJMtspkey2nOKBTdNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(316002)(6636002)(83380400001)(26005)(8936002)(7696005)(2906002)(110136005)(6506007)(54906003)(52536014)(5660300002)(86362001)(33656002)(53546011)(186003)(4744005)(71200400001)(55016002)(9686003)(66556008)(64756008)(66476007)(66446008)(66946007)(76116006)(478600001)(4326008)(107886003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: iXrM4iYa835otrgwlIUIOJ83Gy2v++ri4YOERXLpZHB9lnFR1QutcoJndVvBWZH+RWBMxiDSa0H4xFeo6G8tej/iW7aNn6Tfz0q+DLeJQLLFV7HentwJmb0NSaLPq71CDzDdj1ZPquAHLxp3zCftTLTQ1V+2QmwAsnVamAhA3dYAXmpR1snYzEBsI0AwjnK/BemPvnk9zZ4WQWtUYYYSPspAPFgVBLTZ8b3YSpWKfbSeJCME9AHi1SJ8C/sYfhL4bQr+7KMPnCqD/NcjVNIcpK4+sdUYPbr80+LTDir1mZDag1OFmExJHdfdwsVi5ul5VXvyaSBd++sl5DYgOkre6XktJE1zg2MJSDNJAt0eo4kngi2UffZwvAZwCoUZW/S8rSAesli3Hqx4we70PCPTvTVxgTP1uIflDMRLtlleH5joIyl+HwAhaJHI2dSr+WtFaJ2vd+odXS61CqZvjZzukNTbAHF+jwmHYdiIM2+AEKg48GSTjx7/NooTsfaFTCzWSZf8Q9vJ5bVQZxVRtNkguIpFAl+4xDn8v6V/IrPJgW0qkwIFClHDCyYh0FDz/jLYU8taqJj9lkudG5xC1s/33g/0dETiN99sg2wWITQwdiFNzAG1YfHCQtKfJzlw8EXsu4nMA2N9Ksk2oSdad91AAQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2f301c4-e71c-4ae6-c3c0-08d84aad072b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2020 17:17:08.0064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YjZHcE4XGKdm86Z5QKDjOG+NEqSe3BOwIFDH12DfJLG8mbrtfmPJJpYZjMYTUNCqGrFVbdJgjVd5YXJDpVlubQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1727
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, August 24, 2020 1:41 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; Michael, Alice <alice.michael@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Brady, Alan
> <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.com>; Hay,
> Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v5 11/15] iecm: Add splitq TX/RX
>=20
> On Mon, 24 Aug 2020 10:33:02 -0700 Tony Nguyen wrote:
> >  void iecm_get_stats64(struct net_device *netdev,
> >  		      struct rtnl_link_stats64 *stats)  {
> > -	/* stub */
> > +	struct iecm_vport *vport =3D iecm_netdev_to_vport(netdev);
> > +
> > +	iecm_send_get_stats_msg(vport);
>=20
> Doesn't this call sleep? This .ndo callback can't sleep.

Will fix

-Alan
