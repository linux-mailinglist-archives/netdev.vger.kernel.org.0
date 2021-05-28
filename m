Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AF8393B3C
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 03:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbhE1B7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 21:59:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:24250 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235016AbhE1B7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 21:59:34 -0400
IronPort-SDR: aFT3JlZ4bjtqdG55oC/98GcoSOfNIzEpRlP17tiD35JF1j7qGB19OKPB/z/vtGChtNRb0XzbkV
 ttTNkAfFGJ6w==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="266761280"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="266761280"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 18:58:00 -0700
IronPort-SDR: MblKSxH4I63PESAU8edTFcuMI0p6O8V9CeamdfyW+jMBnHRCBdkrRhP7abn0FdNjCZ4W1BLFTT
 N8wvNrVpj4uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="477736591"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 27 May 2021 18:58:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 27 May 2021 18:57:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 27 May 2021 18:57:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 27 May 2021 18:57:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUjOBoXJ/wA2nweKc2AqleewXOFevax9xEDjzIjK76yZ2BC7o7YwYxx76fM2hcSyWBh/JDwdlOhvzWDyqt1BQZiHi/g32t729D24PKRDnONrbAKuG70mOYfBMcFQz4hFqBps1BozjMil+YaFqOOBKg/uPdm9imWDliVOH1qB5vQpu86PHsW18imG40YrsdCvZCo6+57xZNRXtKNqlplIOWq19grKVrMwvAd2svy00WZn3dtqy4+Sf/EzrnJL3xk3SqtlyW9PQ2gAm9xawa++qGg4lJCQmyuX2ncvzS77EgwJtfujoNdw+9C5j+vWa2TMeJnAwvuK1OMDGi+mFkICKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwtGNn4wUpy5C3srOfhepVUj4O28wrlTBIGe/uWT+vk=;
 b=X+/5Px7IjlBRb9B+/6Am4BSUqrUpC6CqYNnwK38NjCRmX49mAJ2GjEvAWOtwRdHpEvyS1D9TwZiiH1+Foujk43o6VkVVwcnUsqq+zd5t+ArZjRPDCpwPcYGYpq+Y4myUcl9GI9ZBQVYZ1k6tvLeen+cux78tkm4ClgnYajzN2XOgE6WJE5uJryqOeq+eA2clhYEFEorQ/uEft6wYetMLTOzQWbmsO59HBfQ6XlXktJ3gc8l+QOjOwUeU1YGrHEoKCZHJMbnlkKZiqSNu7H089tvIL0N9bwNvhRxrJmxuiGgp3gXCmx26+HujjVC9KPc2fxjMY+pUradGOKFMbUYHsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwtGNn4wUpy5C3srOfhepVUj4O28wrlTBIGe/uWT+vk=;
 b=l5mZs1u2BU3OWjYLLXLnHtmkc10n48uRuofD8UUFSrG9d9cO+gr0VmF6VuszOG0smc1SLgsaS6n6yeNNiO2WCyupsbqa7gojz0L0dXgBvsqnj2crp5CNjwGaqOB2RrKBiUaSc01dEOWmvmp9Gsc+lpb5Wq4Q0ge2lJD9eEvclcM=
Received: from CO1PR11MB5044.namprd11.prod.outlook.com (2603:10b6:303:92::5)
 by MWHPR11MB1405.namprd11.prod.outlook.com (2603:10b6:300:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 28 May
 2021 01:57:58 +0000
Received: from CO1PR11MB5044.namprd11.prod.outlook.com
 ([fe80::fccf:6de6:458a:9ded]) by CO1PR11MB5044.namprd11.prod.outlook.com
 ([fe80::fccf:6de6:458a:9ded%3]) with mapi id 15.20.4173.021; Fri, 28 May 2021
 01:57:58 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v3 2/3] net: pcs: add 2500BASEX support for Intel
 mGbE controller
Thread-Topic: [PATCH net-next v3 2/3] net: pcs: add 2500BASEX support for
 Intel mGbE controller
Thread-Index: AQHXUtrnBn8MrqotsUKAotjUoAsS7Kr3+cUAgAAqCZA=
Date:   Fri, 28 May 2021 01:57:58 +0000
Message-ID: <CO1PR11MB5044DDF8E9080BDB9701B3339D229@CO1PR11MB5044.namprd11.prod.outlook.com>
References: <20210527092415.25205-1-michael.wei.hong.sit@intel.com>
 <20210527092415.25205-3-michael.wei.hong.sit@intel.com>
 <YLAqrte9qwQ/64BI@lunn.ch>
In-Reply-To: <YLAqrte9qwQ/64BI@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-originating-ip: [58.71.211.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c9360b7-352b-444f-e21e-08d9217c04c1
x-ms-traffictypediagnostic: MWHPR11MB1405:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB14059364E8DECBDFA4F5BF8F9D229@MWHPR11MB1405.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BBnIoHkHbPQ1QHA1KVrDETduUND0SkrPfB9Bj0Z41nYctK2IIMZFE+o+QIvfkyWu0OYTQH9SdttNQJUOEGxpJ9VZKWs/O1e+ZbROi7/PlyLwtJPFEFp3xBFDj7K25o4SpcRWkKHMBq2w8ffVOZEL9RO38jRbyMBVz/FB6J1L4oWfj2WfKLvWBEzEKYvj4l+usZQOoZPfGBuxcSvN2cGnIJ46VMlgUmy6v8IBy4M1xkKz07DqJufDvZc1VqBr5QnkAZep3z0DrpMZPa2ifuKaMrQN3sYuKfMhWUMSYC8jahfF6dfrzcLwEQYdN5xXDzDSrKtwPRlzG2Dy7VWdt0Jj9NKYH4fziQCgtIGMZyjRQeKAgfsieP5zgjnQKPy8IBzr6eaTPMEYkt8DKsDylMJnbEuiXgPdUjgz9wWMsDCnPcihYwotWnSjOsOenbNKYmuwIa16O6eAsXVt9hXv6B9NQUmxEq11KpX6SIZa1SOcd52bLWearwTmMKiUcjTMDaXLHfX93jca3AQoWpTbXcc+par7FN1VRtKgjHRDUinhfwdmcfZFtFnwC6309CfFbMCtEbe5A8NyAHHM/IyX9NqXEI44Vjl08SJb4CUpZsRMmxXKXK0dHclN3YfSplJGjR0SSTo1d2Tn8Dqcy3IZPCv4I62u4waLwMwexpOtXJI68GU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5044.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(366004)(39860400002)(346002)(136003)(376002)(396003)(5660300002)(316002)(83380400001)(6506007)(478600001)(186003)(66946007)(8676002)(4326008)(8936002)(76116006)(54906003)(66476007)(64756008)(66446008)(66556008)(26005)(71200400001)(7696005)(38100700002)(122000001)(7416002)(2906002)(9686003)(6916009)(86362001)(52536014)(33656002)(53546011)(55016002)(164013002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?xfr8YRgafMMHXDZHV8/uqdNshrBs5vC1o2lbZ7DG6KWdo6PMEIflSNSyfHR9?=
 =?us-ascii?Q?VXWnutMKtUplaMMe9jswyfhrfLb67BHiOCyYKsTnPEi+PsUwX1ybL92enLGb?=
 =?us-ascii?Q?daRJ3vlAgcVmciZpOkxMrIySvgqKcBgCSZ+SIqUmOv015HvsoNq0OfwJfit9?=
 =?us-ascii?Q?o1gShsNbT3lAiwDiCGgXCBCZDPUSm2pP4NZQf10R2///LNlzE5rd0GgBGS5d?=
 =?us-ascii?Q?+KW39S8gAO/0TT8F048xuYNbshIcmeuzlmqi1YJ823o03+tsWv4JWY+ZfsnH?=
 =?us-ascii?Q?Rlj9DRWVdYEBXKu1W6VwUyWAcs3bEMt9qVkTaoT6/OKQYKCycuUS9CVik6Yl?=
 =?us-ascii?Q?0GkLFtY4aaWVoYtTUlViAY073Fw5YnnY4keSZvfx+pWdZx0R1H4h+dmMxkWi?=
 =?us-ascii?Q?y9/DVVvL0MCIDAzDLvcFmCBhjMQ4IsFOqF87GKtkxGD/yK6gEl+D7qYhVfr4?=
 =?us-ascii?Q?9VCGNjiYbCUQVHJVLtZRkSYZO5MHe6+z1OGh1qJ3O2m3pDRrVpSiodQDQs5c?=
 =?us-ascii?Q?Bywv+Udv/ouReoxdafv2rQ3mNUbuzMwfUPE0QLkUQkTw4r9UfcrwdLh4uRus?=
 =?us-ascii?Q?GJgRaFul0MhL3MyJPumUWlV2T651XqQxgoGPtVj9JVpNCZMf/+EtcXFRHOHF?=
 =?us-ascii?Q?d7snfkCyoSEIzjhhlq5z0hzcWsnar+ziCTYmmfo08vbAnqQB2qQgajKDNRrO?=
 =?us-ascii?Q?yvul01jmBURPs73FIYOdNe7VTiDXIaQ5Rr4RRIMHlQmY4anQCa3YYmHpH8ou?=
 =?us-ascii?Q?IaxbjouPma4HquDiFP/Tjc9Mr2rFdsAF4u0HtjBnJDb8CCQmFRn8qy1dLzAn?=
 =?us-ascii?Q?YRqNPEMhGWGKHsxpa5ZMA0N9cilCCAIeffX+Q1GsF8tz7C6tuMLPQak3DlxP?=
 =?us-ascii?Q?/Opx34BvSPE2rKhXRubLVebmWtBndmNpJR0tTzi+CQxVo4kqO79g7to6h49v?=
 =?us-ascii?Q?TDYpVO8+bDTgHIgIbI6yBflUDpqfPDK0F4TJxVllzIh0OUN1OxbFxrjjLadN?=
 =?us-ascii?Q?iTCvoZ+Ap/2lLoJOKKfVGFbSVSqwOJtOyM8S7ambrqclrEnMRKibjZaKeWRz?=
 =?us-ascii?Q?qPRmXyoptUmRshNqvO82rowZZme7cjb8XawJcndDRp/Gl7Zu8KWBIIeUO1XT?=
 =?us-ascii?Q?0F0AU91liTQ2bmwojeQq9ZmXRrw2EvF0vxwcQUxtOyRXoc5XMwEAWlq3obXx?=
 =?us-ascii?Q?LYxq+lbiBsrEqPnDzfptgZnhamGIFzLx8/McJOkHIQJKQQ37RqjsoBSm7r9u?=
 =?us-ascii?Q?sZAd51vwQlkyAggZf6LnMaDPkdmdXf1d54emiYknUUpMXSuUi2BZUwj3r7N6?=
 =?us-ascii?Q?wsk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5044.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c9360b7-352b-444f-e21e-08d9217c04c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2021 01:57:58.7917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 11qr4mZnf5aQbCi0ENz9Nw77UJ29K1TA2yHXV07opTtLdC1O+9wmtIQY8jy9Quufxx9Mw1sXVv3GSLtOjwbjo5C6ohGmGWLsEP75J/DtqHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1405
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, 28 May, 2021 7:27 AM
> To: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>
> Cc: Jose.Abreu@synopsys.com; hkallweit1@gmail.com;
> linux@armlinux.org.uk; kuba@kernel.org;
> netdev@vger.kernel.org; peppe.cavallaro@st.com;
> alexandre.torgue@foss.st.com; davem@davemloft.net;
> mcoquelin.stm32@gmail.com; Voon, Weifeng
> <weifeng.voon@intel.com>; Ong, Boon Leong
> <boon.leong.ong@intel.com>; Tan, Tee Min
> <tee.min.tan@intel.com>; vee.khee.wong@linux.intel.com;
> Wong, Vee Khee <vee.khee.wong@intel.com>; linux-stm32@st-
> md-mailman.stormreply.com; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next v3 2/3] net: pcs: add 2500BASEX
> support for Intel mGbE controller
>=20
> > +static int xpcs_config_2500basex(struct mdio_xpcs_args *xpcs)
> {
> > +	int ret;
> > +
> > +		ret =3D xpcs_read(xpcs, MDIO_MMD_VEND2,
> DW_VR_MII_DIG_CTRL1);
> > +		if (ret < 0)
> > +			return ret;
> > +		ret |=3D DW_VR_MII_DIG_CTRL1_2G5_EN;
> > +		ret &=3D
> ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
> > +		ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2,
> DW_VR_MII_DIG_CTRL1, ret);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		ret =3D xpcs_read(xpcs, MDIO_MMD_VEND2,
> DW_VR_MII_MMD_CTRL);
> > +		if (ret < 0)
> > +			return ret;
> > +		ret &=3D ~AN_CL37_EN;
> > +		ret |=3D SGMII_SPEED_SS6;
> > +		ret &=3D ~SGMII_SPEED_SS13;
> > +		return xpcs_write(xpcs, MDIO_MMD_VEND2,
> DW_VR_MII_MMD_CTRL, ret);
> > +
> > +	return 0;
>=20
> Indentation is messed up here? Or a rebase gone wrong
> removing an if statement?
>=20
Thanks Andrew! Good catch, missed this indentation error,
will fix in next revision
> 	    Andrew
