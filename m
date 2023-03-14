Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C580E6B8DBD
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjCNIrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjCNIrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:47:37 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D96087DAA;
        Tue, 14 Mar 2023 01:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678783656; x=1710319656;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gv08cH8umD21vwBjLAuOumbCuaGwl460CQuNoWZIDz0=;
  b=ROIXjxWHgxMnVkXXJNxN/APTLaJSEH0l462GaW5/iIs1IZt8bubgKG1R
   46nsQkne9xh3bJ8omQx2Sl2BrDTZYwyl7+8pcouLQlZTKL1vg0SaKMbTY
   Ojg0DX9aM46RDPTnNbq19Rb7kbCA62hHOSUV5+418av6zxKHdai99+FrS
   kYUenqsUR4cqDbZLtiyuZj7jYt1CXaJSgQJaFkoCISC42210R0MovQHCY
   Rc/w3lcKp42L+bD2s5NAB/6DHs1RXGJ+edJMwJpCFoAjny/T++bGrRJlf
   CM9YmEPEtBnD3cVCowU1LugnzOrtHSH/SToXUst02X+CQcTmWtm9euSpA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="317012573"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="317012573"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 01:47:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="656263181"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="656263181"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 14 Mar 2023 01:47:28 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 01:47:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 01:47:28 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 01:47:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAtig7P1tWerpJWpktOC9LmV1RxT9F4qekr4HGAQ8aA902/LO6aI6fu+JVpttV8F4mZhorepx7fvuEXLiTGCfjcB5fl9kmygH011dm/etDyIzghXAiu1eN8xiVmAavc/8pk3e7XUijTHFV0sg+eWf/2t3Pi2Z8UaiRKdPOECflt0DPEUPX0yK6jJXBCxek879gEpE+neDnRlTvTd01rODy71F0nFLtv7pvLP/Q90uq4TgEC8tQ3bdqs2RkBM6uxX/e80cJh2EF1i3W1h+ioCQTD/+Mimfks5ap6fMgXqXyPl41d3hQAdFSRHwMjX9Svs5kO4jQzxRtuFnqB6mhpdXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Va7E6YBx0TjLrHCmf+FLQGvK+97Qnm42UcVJqfd2YIc=;
 b=ZIB4WWnVRXR17Y6GUYLUEyQ6maak07yCscg9BStQmtuDHIMebpzDUf85HF7V6B9YNfPqxl8ZU3Ef/4YobnUxm33NuaEwbdk9EWcXLuRK+LdgO6wvH1lESfHhCEvGsHEAu4EJds8oFMloZQnUEKN1o/RDxYgHPpGDcLFFJH2e0lTRIKJQpIE/i8hsmAl2GWdB4fYbkgJTYd+GZspETvfWnK3tEy+FJ74jRSklBOHVyUAIoLQ4HVkl+r2ar0pu/tWRHTdt8Q/Au/n2hZJAPkH8x7gtUcJxwqUDQ49fPMbIPkYLt4kb7UTeKYz5qmyyM5s3YguFZ0CH2wJ7AhFrFJXY0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7587.namprd11.prod.outlook.com (2603:10b6:510:26d::17)
 by DS0PR11MB8208.namprd11.prod.outlook.com (2603:10b6:8:165::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 08:47:24 +0000
Received: from PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::a9d7:2083:ea9f:7b0c]) by PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::a9d7:2083:ea9f:7b0c%9]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 08:47:24 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     "Raczynski, Piotr" <piotr.raczynski@intel.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Looi, Hong Aun" <hong.aun.looi@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Lai, Peter Jun Ann" <peter.jun.ann.lai@intel.com>
Subject: RE: [PATCH net 1/2] net: stmmac: fix PHY handle parsing
Thread-Topic: [PATCH net 1/2] net: stmmac: fix PHY handle parsing
Thread-Index: AQHZVlB7Rf/wGnP6mU6QhHTf/1EIsa759Zhw
Date:   Tue, 14 Mar 2023 08:47:24 +0000
Message-ID: <PH0PR11MB758710CE5A7F7AD5F4E84DE79DBE9@PH0PR11MB7587.namprd11.prod.outlook.com>
References: <20230313080135.2952774-1-michael.wei.hong.sit@intel.com>
 <20230313080135.2952774-2-michael.wei.hong.sit@intel.com>
 <ZBAyvXhvXPsQ8WrT@nimitz>
In-Reply-To: <ZBAyvXhvXPsQ8WrT@nimitz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB7587:EE_|DS0PR11MB8208:EE_
x-ms-office365-filtering-correlation-id: 4c60583c-6627-47d8-68c9-08db2468bb7b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EWHr2YpYw3q+M3orYGMFB9ewTY3sK9QnCuTl7PErXa0yMs0TlIog0Seve6m11NRNF9MHB8bCpz+91/Kw9Bgp6qAPz7IaWoABc8dzMVFGf5GtPP0CW442VS5Kq2zmtw8GGKRIkndDKAbUhfwSyprnLFvqo3hMSud966QvsWrJbX5qmVzwDjRJFOMD7TxEFbdcWTkGNgHdH8PRjMupWjkKXaIs39iaF2K0Df3Sgj0JDHwPk6a5sNy0JUsizA1SjLGegMQsUFGHoaSBAYkSdPt4JhRzcK9qiJtdH+eWrlYoeErhOFQeM2toeErkWg7aEZKMayDZ9BT6W2xS7+E3ds2lAWO3ZKIY4kuo0Jud67Ys3T2AIJEjTKmpazBO8g6Zu5p3b6J1olbhPHBvIZV6ELzcsazx1/pF0+7q/wv9xnUCZ6i+dqqvI7/UKfkexOvKgo7WIZnLmo452jfE21XKZJIttbqqODStjBKQ8xrHCzt3gB1d3qeVqQxZ3v9fbnr2IT75FNSRHofixmTeJw+6Pe87X8knBL92dQyY4L4PGJL9hagAEhAGw4lf9hvBsZKM4vyJI6qNo7yFqmgeeqhxFXMybYEniAso+R3gUOZcybVqeGtqCRV52snaDl4iXe48+DqcQqtRmAcXDbCAAeOelzc+7U7WkPSA2amOJr6ocybOExmfH/aheaBUByZcbT6DCke+kTv6KwIA3hGqses9AwPNKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199018)(8936002)(33656002)(7416002)(52536014)(6862004)(5660300002)(2906002)(41300700001)(38070700005)(82960400001)(86362001)(38100700002)(122000001)(71200400001)(7696005)(478600001)(76116006)(66946007)(66556008)(66476007)(64756008)(8676002)(66446008)(107886003)(55016003)(4326008)(83380400001)(54906003)(6636002)(316002)(186003)(26005)(53546011)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eZpRTTmjYdViJXvPItILolgWO53V8X6XweMVHbiGvBxcRYYBjRXin35L2yiL?=
 =?us-ascii?Q?KjNaoz5IXdRglw1L0LvA4hu4zjMyq5beZPXOM86NguSEBjAQTk/ZVRqbZwGg?=
 =?us-ascii?Q?5RFMy6TOF7IOUumuip1mqRWBRLmbwVZxWv7aM4hy/8xPV++qF7AxANpYKuIu?=
 =?us-ascii?Q?NwX5JmsfrDoN2du1sYPtcVcrDkkApViu91WYqAlOsiHS7O+qQd0x8X4KOVA/?=
 =?us-ascii?Q?yysVmOvcU+cbABWczTX0ngVLgqqkHjcRlK8wtHJZdT3BRTzp9AW2W0VK8oxi?=
 =?us-ascii?Q?MDYyKosc24PjA7/wLKCr2E+pDaFfftVycDzGOPgdfucosA3oCDhWjq3LEAL7?=
 =?us-ascii?Q?i2hrAT6l6lwiM+tF/zP2lY64oskv3meIPeKCwMyUB5OC6h/M4TWmnRVOwTFC?=
 =?us-ascii?Q?Q2eJKzSxfQNVC3k+hpjzZhOSXXy9EDz9yNVO4pWKo7g22uJ6lrNGBXyiVP9I?=
 =?us-ascii?Q?jfMepoT/vSyyJXnQdChE1ySHCpqm9LrVaS2hD38MWY/WmpRmuHr+bQ+Teu0m?=
 =?us-ascii?Q?9CBJ+KRUvOlYgPOLlMbTwpcEyZzefgWtPqMb2f8rE/GKWflkU8GQ8i+ljtqn?=
 =?us-ascii?Q?WSA5jQ6fu70XMOElLqBj5QcQod/17WkDFBl9UKOkT4xpCwwfTnPX9s4eLBqk?=
 =?us-ascii?Q?+gSLJW+VWH9cn08kL/ycSQm95+M6c8Bzni2RiElC/7u1OYfJ+qLuiZMmt1Qo?=
 =?us-ascii?Q?s6olaMixzumkVT/zVCxTV+4sn26xA3+urPJ0nrBSuhvTBzdn5L9imzeDf0vj?=
 =?us-ascii?Q?/7/auYSe/WqQ5VZTZAkfsC27euk8xcQrS3muM0gRgoIhpHNfZW1w0ZuwVu/J?=
 =?us-ascii?Q?x9K3sFrwurhYyE5ZiiH79RgSMSXaiSQDJtcoLMRd2ECh4qEZcquNbm8+Hoop?=
 =?us-ascii?Q?f7y+jy4yBwCaiVYhdI7O8ZGEMv/xWgkYr0wNPTpx5L2IPDcLYmHSYifEYkC4?=
 =?us-ascii?Q?83znXViz8njB6qSBgsVCXXPV5QidDBp0Fs4zBo25h/RbikjcwWIXWWdY0GO/?=
 =?us-ascii?Q?0puYul1XRuBHQyUgUgrGpTHjOXM0FUJF0xNMf+kEhzMa0/vd6H/IUtKe3rkF?=
 =?us-ascii?Q?yRGwEeZzPklqrDnGAP/IdZE/7GJtY5oH3BOk5lEJa5d3P2pHAOT8YKTf4GDZ?=
 =?us-ascii?Q?vV9+rFSEtFdL6pu8HLgaxXGImDFBWeDw/kyXWyxDfZqKkWLfUtBjeHmRNjcj?=
 =?us-ascii?Q?thVbbJqwAsKv8nSd34zl0UUWjy2FWoAqe/Su8EaBBj9G4/H7xK8cVzSnk3tW?=
 =?us-ascii?Q?FWJ23yJrFNLxakDYSdWBjPp0cUD6BOm9LgaJ6Cb5nY64LFLLva0JIQXNI8Ws?=
 =?us-ascii?Q?B57F7t8mcVgg0CFaRzVxotD2pGmJ+nzz9tgSoALx6NJcVoSZivqild8GAXKy?=
 =?us-ascii?Q?117eUzHTmH/ivoarzJ9zsk5/D/bXrIXNmsr4UG4Dcjpz0k7JFnashNHo/Ecr?=
 =?us-ascii?Q?7HRHBwPxzse6ANuYXtjlzmWkywxAzw/G7zj6505GCV5ojumejfKeneGAF6vj?=
 =?us-ascii?Q?85TAwZMpk/BU2rsweuDUN+6BeLMuEPtA92swF1NdFMYI57MtU+8C/ulpSkWr?=
 =?us-ascii?Q?9n9hHEzPmO5LCHg+CEMh6T38ZbLwLTCtDRz5iegWCCyv0WgU6dW7A0x5IpXZ?=
 =?us-ascii?Q?lQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c60583c-6627-47d8-68c9-08db2468bb7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 08:47:24.3370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YJMBKBLHbsJb+sgqhM1USNMOr0kwlkzaCRk50Az1neT57/07PLFyFB4iW20+Qj5ax3IsW5JSto2ceLQRZK0nqa6J9/4y+eyj46cDOph//dc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8208
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Raczynski, Piotr <piotr.raczynski@intel.com>
> Sent: Tuesday, March 14, 2023 4:39 PM
> To: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre
> Torgue <alexandre.torgue@foss.st.com>; Jose Abreu
> <joabreu@synopsys.com>; David S . Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Maxime
> Coquelin <mcoquelin.stm32@gmail.com>; Ong, Boon Leong
> <boon.leong.ong@intel.com>; netdev@vger.kernel.org; linux-
> stm32@st-md-mailman.stormreply.com; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Looi,
> Hong Aun <hong.aun.looi@intel.com>; Voon, Weifeng
> <weifeng.voon@intel.com>; Lai, Peter Jun Ann
> <peter.jun.ann.lai@intel.com>
> Subject: Re: [PATCH net 1/2] net: stmmac: fix PHY handle parsing
>=20
> On Mon, Mar 13, 2023 at 04:01:34PM +0800, Michael Sit Wei Hong
> wrote:
> > phylink_fwnode_phy_connect returns 0 when set to
> MLO_AN_INBAND.
> > This causes the PHY handle parsing to skip and the PHY will not be
> > attached to the MAC.
> >
> > Add additional check for PHY handle parsing when set to
> MLO_AN_INBAND.
> >
> > Fixes: ab21cf920928 ("net: stmmac: make mdio register skips PHY
> > scanning for fixed-link")
> > Signed-off-by: Michael Sit Wei Hong
> <michael.wei.hong.sit@intel.com>
> > Signed-off-by: Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8
> ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 8f543c3ab5c5..398adcd68ee8 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -1134,6 +1134,7 @@ static void
> stmmac_check_pcs_mode(struct
> > stmmac_priv *priv)  static int stmmac_init_phy(struct net_device
> *dev)
> > {
> >  	struct stmmac_priv *priv =3D netdev_priv(dev);
> > +	struct fwnode_handle *fixed_node;
> >  	struct fwnode_handle *fwnode;
> >  	int ret;
> >
> > @@ -1141,13 +1142,16 @@ static int stmmac_init_phy(struct
> net_device *dev)
> >  	if (!fwnode)
> >  		fwnode =3D dev_fwnode(priv->device);
> >
> > -	if (fwnode)
> > +	if (fwnode) {
> > +		fixed_node =3D
> fwnode_get_named_child_node(fwnode, "fixed-link");
> > +		fwnode_handle_put(fixed_node);
> >  		ret =3D phylink_fwnode_phy_connect(priv->phylink,
> fwnode, 0);
> > +	}
> >
>=20
> On the occasion, why not rewrite above to:
> if (!fwnode)
> ...
> else
> ...
>=20
> or:
> if(fwnode)
> ...
> else
> ?
>=20
The (!fwnode) serves as a NULL check, and if the fwnode is NULL, we try to =
populate it using dev_fwnode.
If fwnode is then populated, then the if(fwnode) code will run.

If fwnode is still NULL after dev_fwnode, fwnode_get_named_child_node will =
generate a kernel panic if no
NULL check is present.
> >  	/* Some DT bindings do not set-up the PHY handle. Let's try
> to
> >  	 * manually parse it
> >  	 */
> > -	if (!fwnode || ret) {
> > +	if (!fwnode || ret || !fixed_node) {
> >  		int addr =3D priv->plat->phy_addr;
> >  		struct phy_device *phydev;
> >
> > --
> > 2.34.1
> >
