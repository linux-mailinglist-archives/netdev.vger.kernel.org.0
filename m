Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18BE6C2C96
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjCUIgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjCUIf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:35:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5212512BE5;
        Tue, 21 Mar 2023 01:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679387725; x=1710923725;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DLsTiccPyH7bx55bHU/zTg3xNa8snfWDn/Y76x4NHcQ=;
  b=ib04BcI1pBqpTjpT42ehmkUCr7AkhB2AzcEQ/pkXq2mNSguBMJa9e1K5
   Imm9XEY/DbTtnaXb/Hj9TbEPM4QCGRM2VT5YxN05q6naecn7WOkhj3ssi
   BgD/CHvRZfeBJAH0GjUGFYBuY8Fg+3HXcq7ELW8kE+IOUH5b2z5cQPYlG
   baDs7mQgA5Jl5m7y6W+bgCcaLSqkmk9MD18DXxYxAMa/gl5Lu+BP0wPHk
   agOp4UczVErIUNIQym9EfiHHu2Ile/MFZXvylmWpfReUoseUFfvfKvlUK
   k+YbHegLHMEPqdOANAr00dfl+KmIVjtxw+yFT1/VEayQTo0sCDBo7VLcU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="322723186"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="322723186"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 01:34:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="805249460"
X-IronPort-AV: E=Sophos;i="5.98,278,1673942400"; 
   d="scan'208";a="805249460"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 21 Mar 2023 01:34:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 01:34:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 01:34:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 01:34:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDhohsXYG7j5x0WtXmsx13MgoyncsbOTckEWVKSifJQgr/Sv+4X8s0roc/0Bgv3EljDA1r5cBxxwCBC4pPfEEiTKEdsHdcTV07e0hwXEroodr25wxymoD3BYBb56qBoPgdQ0ee1tFrb+TVFR05207N6E/fRRNC7UvxwuChjOveDsubdFh2hKLCdOrYt+f+GH0tke6x8lKwmJLIk+Jd601y0+XzZ7R0pdSa/zlf6XWi4eVQBurrHxa3BcZaJLtIho9V4uOQvsHFkAzR1zCLAJz6OY2gb+XrtcFW5r+Ys8o4QXKbC+QEQLVqeq/ezy8mbQsJCWSEk/ZifsUvTnE5OFrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NyJtowKQyybi1L44fxn1rTqOV3L6DQzqD1MZ9bspH5A=;
 b=QNByR25HHR6Y04/Wmmw7UOTWrLoop72DBm55drYo1MC8k2XT2zHD1tQfbnqgdLKh58AsJSSCvp21wgjzqSjGBKP43NVcLiHDdOJj/MPRUaHhToaEmHpXw4BWLHkLTpqf/K4j7p4JNz8CYJTZWEZ+jZUsIoe4jwfZ8ysU55hK3XWHtmxzEPHhb006j80rj32MjjctPm66wm+DbI3/ZbRAZCA9xwXlR6zLXxTC4VnhLBssficTbYqwyrWmaQ2+aB0DTeovB/J/9VlF7bT6+TFPc6Ye1oul7+2xhD2PPuGsoIw8QxS2HqKHhdg3/MQFkAsDYwV26EitB28vl+6uvr7Bsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7587.namprd11.prod.outlook.com (2603:10b6:510:26d::17)
 by PH8PR11MB8259.namprd11.prod.outlook.com (2603:10b6:510:1c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 08:34:50 +0000
Received: from PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::a9d7:2083:ea9f:7b0c]) by PH0PR11MB7587.namprd11.prod.outlook.com
 ([fe80::a9d7:2083:ea9f:7b0c%8]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 08:34:50 +0000
From:   "Sit, Michael Wei Hong" <michael.wei.hong.sit@intel.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>
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
Subject: RE: [PATCH net v2 1/2] net: stmmac: fix PHY handle parsing
Thread-Topic: [PATCH net v2 1/2] net: stmmac: fix PHY handle parsing
Thread-Index: AQHZWQqKiptgMBBkxEe3QmwqS1rIqK7/dC0AgAV1bFA=
Date:   Tue, 21 Mar 2023 08:34:49 +0000
Message-ID: <PH0PR11MB7587DC1E7B2947BDB0126F979D819@PH0PR11MB7587.namprd11.prod.outlook.com>
References: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
 <20230314070208.3703963-2-michael.wei.hong.sit@intel.com>
 <10aff941-e18a-4d77-974b-1760529988a6@lunn.ch>
 <ZBTUTD6RL22pdlmq@shell.armlinux.org.uk>
In-Reply-To: <ZBTUTD6RL22pdlmq@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB7587:EE_|PH8PR11MB8259:EE_
x-ms-office365-filtering-correlation-id: 8fae234b-0786-475b-c061-08db29e7227e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4TDWPLQfnfd1owJ/gErIdSMNsg3Iyz1SR8F+aMNA2hWZQ5ekXJKbrHXeXO1yVRbZUtEEne3gTk8YsxaiT12jScPrhhTZHcQHCEwShD32Jqej8Rp0ywx/PIVssZVmshwYl908OB/c9gr5gsr3AQfbTh+VcaUiqu/tPZGe9u4nE3/zlDGMRjhVULPTDbn1mtXUCjTawsuXWXzKZ/Gcg8gK8p8kYSRPK+PqnFFHXVu9zFlW3fr3zKqT0XGulOn4jMy8pbdqHfgVywCAgKWKY1guSvaMzN8D+BIz1ecDpV9U0LPUiRlnVM00195xU95cOS71NvGIrpCR6dWuINSOtx/eX2EW7loAnzMjiX/beLTFaf7Y3l4cP9w7x2s3655LjIDBffOpQn7sI3JWQ9hCsgd9AaH0xiWS/HI87DmXU0Gw/J2TQmDIC3ZOBrJ3CoqJm6jUxv8QwrwMme2L2JpwZxOPVehy3PFQkp0Celkq9KzFvqP+QQYZdKDJ2ps09El0M46jbVfxl3x4Znyy0GDeHsFOpFxKyoriZN+QbDkd0Ni/Ww+vYBhX9ZjhjfsbCNPhUbKCfSiKqvVUHHJckxDVEG1xo8yj55VGZz4SrzrNHqURmmvJbcsqcKD9BephN8JIXTpbXL9va8t7YvWjVuPMMBJS1t2gweRBsg8i8P/JtN1Zc3uFWcbP3P3AktwGZOBGtaxM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7587.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(396003)(136003)(39860400002)(346002)(451199018)(8936002)(41300700001)(2906002)(8676002)(66556008)(66476007)(66446008)(4326008)(76116006)(64756008)(66946007)(7416002)(52536014)(5660300002)(316002)(54906003)(86362001)(110136005)(478600001)(55016003)(71200400001)(7696005)(966005)(6506007)(107886003)(33656002)(186003)(26005)(53546011)(38100700002)(83380400001)(9686003)(82960400001)(38070700005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?djaemcAHhFirhKj5q5IGB0qhHpwflvQE4TSrqNBRtTnVBiXHaZ4U3uivv6dc?=
 =?us-ascii?Q?Avv1hetbdfw09I8xzXLzzPffW3avjnd+072ZsrdjUoJQ21HoUKMuLDfiIW2+?=
 =?us-ascii?Q?D5eDG+avLPzCsXD9glhGmR/DKP57zJ0jj3ZT2fLammGFNV1XUmkCIQ8poe+H?=
 =?us-ascii?Q?WqFf9khs4DP3PzNxI9qVaHiGOt8TOm+wPSbhbzAxL0U9VaXEGp030g89FS9F?=
 =?us-ascii?Q?piEwm7KpElbzhFCRbCjzXssuiF7u8BOq9+wVpa/hB/+G1xRIdx5oLxw0Dm75?=
 =?us-ascii?Q?3PeuAURFBZexuttibdWhMDdzjGstqOj1kDtUMMl7BF0eR2M2x7u+WAoVA2aG?=
 =?us-ascii?Q?vk5o7jS1I6U1aOjHJojP7UDF2Ro2gTsaRw11QY6zCuGHx9OmjeTmIT1alEL5?=
 =?us-ascii?Q?u86iLK3Dav+eMtHE+OlOCSZn5OTxRlpFjTUnA/ZiKsanHebacHz527OeP2LM?=
 =?us-ascii?Q?RWzeC7HGS1E3q1mDVsfhqhUqenhd3iRZWFj6SfMMKz6QDyOiBj6LkEw8Hevs?=
 =?us-ascii?Q?LIHkJMQLJbWVPn0zz91o5S9ASfEwcD6IbCSYmEFualXigw5AjBzK50rbLOTk?=
 =?us-ascii?Q?rfrBpuTIF80UDGX6w4kIQUeSkipCKGxzmmedlvHW0f9qSPU2GhdZWjRBSvSw?=
 =?us-ascii?Q?G94zmrkCN1J+YMrrAn0p+8pUWaB29Xn8+ro78eIRLdu43MgvLyR9MhLMocNa?=
 =?us-ascii?Q?rxJTlhKvalEAnW+af+hLlvTQ3htLpe/ww+kKcJwsBdh4Zfkqe4iPXnhJeT94?=
 =?us-ascii?Q?8RL5C/qrCD4I8dJSiT7F7AKy26B/ofIAixAYzYvVJLFLZwhSvi2cp0mjRozv?=
 =?us-ascii?Q?ALA7c7yNl5HMOjyN6oYryaV/Zw42liFXHsR1C2jojWraejFQwc1zCTTgtjbk?=
 =?us-ascii?Q?09OQTi2l5tCNaQizQQ8N0KffvAbTdDImqQ/WaZXNHylPABI9M/cPt+MUXijM?=
 =?us-ascii?Q?pv/Qlb5DEID+OHm3ZR1sScSTwNaobc43i1GLi/uhnwO27Ip19QogW34Nj4Qx?=
 =?us-ascii?Q?mQs4K6d1qJkqn3FymHYPHkntgvVTq90/8bMAuN26joj56j9uTl7Ka7vW3Znw?=
 =?us-ascii?Q?Pk/3tkVFENQLMCUh7gjrk/OK18c00AxAnDolBUtLHMNknf5JSiVbjjV/n5Jy?=
 =?us-ascii?Q?sVjlppcNytR2GrDb7r+kQgIVrKUV0XYKBWEzjQ5Pu27YZ1blLgnK3YexO5Tg?=
 =?us-ascii?Q?0DXhijGbKwLEyCQg2MmWSouVd/6tmwdX5n/HlhgJtlZkGmWaYZXmRHIAa83c?=
 =?us-ascii?Q?TUsg1w1XaWfXGLAGP3uOzylYg8S20y1gXQOyXFDb50YlfmrHhTG3LWgdAYo/?=
 =?us-ascii?Q?cXvqJ3pG30J+2+h2q/PhIVXJgEI6wfBbZ+7jHtwTcWZ8prV2DNsP1dUBDSl9?=
 =?us-ascii?Q?htTD3WepeGRXzzFq+6eI1GZKdGCLLLY98TAzVWFbwdUxlLo2EebicUupMltK?=
 =?us-ascii?Q?SkRuErxfrKYfk8BMxKmFtibndNf6hqCTYu787Iupw5T0zcYFnyYa4iN6NZHC?=
 =?us-ascii?Q?rl3C7o6JApCt9rVTKQPZ1wP834CtT/JSz6FCM2sM7WL9/Ms2S7PmGCv23ooF?=
 =?us-ascii?Q?isoyX6qHJUeZ2OI8ZCpIgchxPTk8Lkrtl/+ttcpC+Ast2R27YIJx8j7tsSOq?=
 =?us-ascii?Q?2g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7587.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fae234b-0786-475b-c061-08db29e7227e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 08:34:49.5661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1ItbaCklIH4rCd4Y7G35Xlhv54educ4AhWfM8Qnsc1GdzRw9XN/eI5cbVbYp63F247tijRyFhGAsztE2m3m/uUEfnMNQo365GPimtt9/tqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8259
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Russell King <linux@armlinux.org.uk>
> Sent: Saturday, March 18, 2023 4:58 AM
> To: Andrew Lunn <andrew@lunn.ch>
> Cc: Sit, Michael Wei Hong <michael.wei.hong.sit@intel.com>;
> Giuseppe Cavallaro <peppe.cavallaro@st.com>; Alexandre
> Torgue <alexandre.torgue@foss.st.com>; Jose Abreu
> <joabreu@synopsys.com>; David S . Miller
> <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Maxime Coquelin
> <mcoquelin.stm32@gmail.com>; Ong, Boon Leong
> <boon.leong.ong@intel.com>; netdev@vger.kernel.org; linux-
> stm32@st-md-mailman.stormreply.com; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Looi,
> Hong Aun <hong.aun.looi@intel.com>; Voon, Weifeng
> <weifeng.voon@intel.com>; Lai, Peter Jun Ann
> <peter.jun.ann.lai@intel.com>
> Subject: Re: [PATCH net v2 1/2] net: stmmac: fix PHY handle
> parsing
>=20
> On Fri, Mar 17, 2023 at 08:56:19PM +0100, Andrew Lunn wrote:
> > On Tue, Mar 14, 2023 at 03:02:07PM +0800, Michael Sit Wei
> Hong wrote:
> > > phylink_fwnode_phy_connect returns 0 when set to
> MLO_AN_INBAND.
> > > This causes the PHY handle parsing to skip and the PHY will not
> be
> > > attached to the MAC.
> >
> > Please could you expand the commit message because i'm
> having trouble
> > following this.
> >
> > phylink_fwnode_phy_connect() says:
> >
> > 	/* Fixed links and 802.3z are handled without needing a
> PHY */
> > 	if (pl->cfg_link_an_mode =3D=3D MLO_AN_FIXED ||
> > 	    (pl->cfg_link_an_mode =3D=3D MLO_AN_INBAND &&
> > 	     phy_interface_mode_is_8023z(pl->link_interface)))
> > 		return 0;
> >
> > So your first statement is not true. It should be
> MLO_AN_INBAND and
> > phy_interface_mode_is_8023z.
> >
> > > Add additional check for PHY handle parsing when set to
> MLO_AN_INBAND.
> >
> > Looking at the patch, there is no reference to
> MLO_AN_INBAND, or
> > managed =3D "in-band-status";
>=20
> That's the pesky "xpcs_an_inband" which ends up as phylink's
> "ovr_an_inband"... I'm sure these are random renames of stuff
> to make sure that people struggle to follow the code.
>=20
It is as mentioned above, the "xpcs_an_inband" will end up as
"ovr_an_inband" which will then
set pl->cfg_link_an_mode =3D MLO_AN_INBAND in the
phylink_parse_mode() in phylink.c

The phylink_fwnode_phy_connect() checks if both
MLO_AN_INBAND && phy_interface_mode_is_8023z() true
before returning 0.

But in our case, we only have MLO_AN_INBAND is true, which
then goes to the next part of the code.

	phy_fwnode =3D fwnode_get_phy_node(fwnode);
	if (IS_ERR(phy_fwnode)) {
		if (pl->cfg_link_an_mode =3D=3D MLO_AN_PHY)
			return -ENODEV;
		return 0;
	}

Where here the IS_ERR(phy_fwnode) returns true, then it
Checks for MLO_AN_PHY, which in our case is not, so it returns
a 0.

When returned 0, our driver will then skip the manual phy parsing
due to if (!fwnode || ret)
> --
> RMK's Patch system:
> https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at
> last!
