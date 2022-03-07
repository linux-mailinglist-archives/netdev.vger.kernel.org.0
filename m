Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0440F4CF0B6
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 05:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbiCGElu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 23:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiCGEls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 23:41:48 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DC8546A1;
        Sun,  6 Mar 2022 20:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646628053; x=1678164053;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DdffTisXoh007mRFKH8NFkSV4gzoKt7I9k1bvBUjwSE=;
  b=wq8pBHXkqDPi1d66op5Ca52qZxnmPEQpC8GM+DXHEub9akP4BJNI4m1t
   60JdaC6gG0pLM95gfieGEvVBHvOIzxtz0mT/KdzhItYQruHLygGYs/47r
   r2R5qT8WHCX+yylcA80DCe07VQqkZRvlalrvckCP3areqGzyA4DcLu3TR
   Nomx8OEwRy683Itn1YRwwz9IXfKVWzXCUgfS3s9M/K8ArA2qpn9rMDtOz
   MlIEpFm9sqFDQxrAtKpHEg+O5o5r3ezL145eKd0wDRhb3vznHuV8vKOab
   +fdAx3r0s25aJm7ep+7Fe6G5ZLqQRALt59Lc3K2Wxt9yUbrHcEOPS1AKS
   w==;
X-IronPort-AV: E=Sophos;i="5.90,160,1643698800"; 
   d="scan'208";a="88014522"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Mar 2022 21:40:52 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 6 Mar 2022 21:40:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Sun, 6 Mar 2022 21:40:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDxArzeV9/mPYuFI+nHC1mh7TU8Yl5uflf7X/u2ZizY94pYij/Il20SKheINh5+Xr7zH3NBLv1gTy71viLc9QXapiPgX2162I+PpX83oB14bqqozqF0Wf3yDZF3lkSIRHXJ5ZFgJAN7eUHRWtdbISER3me0ryzJaO/ep8s/uVlpIC0hgfmXQ1jjSEQ9iv1h0gihXdKrjjHMybgUgu7mG+6uH3yGjhmxjhpXTgM8h5zFtnDVbx8/bhivpGrtflFcdHb9S3ellGukKCoD4Cv8GGDMKdhHLuvo0FXBl6yqxzur+62Q7ePXJJ5+PkdecpEVVKcjlU1C1ZMMloKRj8YJlzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sn5gI1jMWMthTo2DJ2Awj/ntvr37gr0bDJlqnXmykf4=;
 b=DH3XhRnqxV7wf33oRB1RfoNQMyHj8t69dIgZ9Uz3DHOwiXNWzsNnLcD4YTA/QCaS31N5J8Qo9wUdYrOBSxzSowndMapSbswps7N/u//iKEjKMk7B2YNZobZxYBly1fDz9abxB7pGzqXVmotdPWXs57dfKJ0gf7hiDxlil+gS/AH/4aC+tGeSiWm0WS3Sp/FUagrb0Zuc5BLAkS5/jlWSvS5mL8IJI4EQ10aIVlxtvR4JLxh5ATwtoppMl4kHQJYcKpHLyrikm27yffsErKao9XILmC43IvuWoI2eBC40EuFyQRorf/y4JxtRw+dTqo5hV4MUD+P7L2gCuZX2zxUeOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sn5gI1jMWMthTo2DJ2Awj/ntvr37gr0bDJlqnXmykf4=;
 b=ZBC/cRiETAWyrdLotQuJqbFtIjLnGKG5CSgLNFzbp+tfrbWYQ4JevbxjpRwiXjbss8ZOO4kXGunfYuPr7AeXj47nsyEMTq3IdaXKe93DcWR5Sity0IMsDQbANdxVr+sIUtSO7847CaAue4O2mzhhe6VICV3TGmLT1MxZwuTeLlo=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by DM5PR11MB1692.namprd11.prod.outlook.com (2603:10b6:3:d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.19; Mon, 7 Mar 2022 04:40:41 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::7861:c716:b171:360]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::7861:c716:b171:360%3]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 04:40:41 +0000
From:   <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <richardcochran@gmail.com>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>,
        <Manohar.Puri@microchip.com>
Subject: RE: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Thread-Topic: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Thread-Index: AQHYL6tdGiDfF8muKUy6jpI4YK/Ta6yvLZmAgAQXZ7A=
Date:   Mon, 7 Mar 2022 04:40:40 +0000
Message-ID: <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-3-Divya.Koppera@microchip.com>
 <YiILJ3tXs9Sba42B@lunn.ch>
In-Reply-To: <YiILJ3tXs9Sba42B@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1892ad64-715d-471a-21eb-08d9fff4a253
x-ms-traffictypediagnostic: DM5PR11MB1692:EE_
x-microsoft-antispam-prvs: <DM5PR11MB1692A35D82DBB8E6F08E2BDDE2089@DM5PR11MB1692.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iuXhJLDFq9JWiTu4rC0rqvNmordlBq5jTKWTOWjLN06jlDz8jZxBusyOFh+cbrKUS0BE+KgE2/D7ntu92gFS3HjAtl7Rz6UuJalyE/GWoFFGRwpjLBsTIjFtFtcsdq2LAt3Rh1Cu/c9+wSX7fIgyFzM1h1WPwMHG9SDKkyjKCoPnqpd44HvPhcBA6DkcQAfdWEdNwxALxwcEPf5oDod/O8Bx5MLQMQ0G99XrAUP0WQ5Jwjzf5/Qx094GYifEtR5XTRPUrwI/9CdzhINDPB6tCXiYmcDq+DRWnkM1/GIiPTpdr5Z/W87R0WebGCMHrHTP2CAmM6COEi13baiF1VMxE2jVXAj0r2llPqgTqV4Nb96XYYBMwMs14xUHQmLFZFtrxtdIrez2kp2tiqrHCjiSsOcCSKnm7Bd3SpUswRISPpx4/Kb11xhfZd0Ogpu38CCyKtMl5wu/JwGwOqP0q+CpbIzOrJ4i4CuWDGi0J1WkVomS11/zZjEcPamw0dzSdGwYfZRhGt/sGApgXl3dJVjxBmP3wiH7Hqwwvn/5wI8JGztgxo0EMn5fwZeALZnBmVTWy2nzRIIbi7Ygv/aCEiMgZYQ7OxgJB+gQJLjUiFSQGSH7lfPBLjfbB0LDaM28nemPXiycc0y3UNcstbQ9l8yL7OLotK/8bjkMXG0R7zJiQwuUe4WPmI5RS7zcoF2/RwWURx+/I7/Judvyx7BziaAfKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(38070700005)(107886003)(76116006)(8676002)(66556008)(66476007)(64756008)(66946007)(83380400001)(66446008)(33656002)(2906002)(71200400001)(86362001)(53546011)(9686003)(7696005)(6506007)(122000001)(316002)(186003)(26005)(38100700002)(55016003)(6916009)(54906003)(52536014)(7416002)(8936002)(5660300002)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6A4vr4kPFbUalsLre8shA+tLJ13IJHXHiJMXhupvFxwSUNdJBc+/NmNDWwsj?=
 =?us-ascii?Q?NJjGLxSfJuN0UqKybTAYNThbEkjxC5fvAeaalY9ckA6aYUQtEgPszmKy+uqB?=
 =?us-ascii?Q?Lxii9EwnNcyCCa99s8GQn40ixnpuQGW1SX1IuexTVSZqkcsTWxOGlhL87omp?=
 =?us-ascii?Q?acT5T/Kp1QomBVBcBu4jm4JvsFC07vL7GfW2cUNa5Pgt6laEX86rvhPgTRyT?=
 =?us-ascii?Q?UNKFWhE3dH/AlyZ+/n6hsYyT2FKTgdblm6phNYV588k1rwDm0H3CzBtZjiI7?=
 =?us-ascii?Q?l34J4nnuWAQw0u6QgMZXxDA/IiqFtrxTGMqefBnZxTkM9Qu6HR0q4nI3fuSN?=
 =?us-ascii?Q?5cOfZ43yn019hQ1scUb7Hm5uNfYiABXRBBjWDCdh2g5w4sV/upj8dOyuXEH0?=
 =?us-ascii?Q?O5tkycP1yL4piVqZL521euLFc1Mowhc7SMRCDkUIguvIDC6yVLsj/5NcdREp?=
 =?us-ascii?Q?MpDNBc0LH+tg9ECnx9J1UvAk1XK7I9BJrXioj6wzkG3oiRNsKhObG9Q1njhT?=
 =?us-ascii?Q?qk6JkWfSoG4pIB8i+itlPwm0FrDG41D+z31kxBjRfnST0QKFV3/mthzs1Ux+?=
 =?us-ascii?Q?/SP+1pJdmBRyu4uIYFyeqX/2jg17Va4lI36fYN/W7kvn9grmx98rNuBkcHXM?=
 =?us-ascii?Q?L39thnSg3nbRnLaxd3J99YbX+IgzC4Jjm6yAQsMOFtP2xadCYOElWeH1kFYE?=
 =?us-ascii?Q?pLxBi/waAyH3pn0WlxaI5XP52onZChfIKlORjvf4pScQTqhA2R4zYhyGxvQ4?=
 =?us-ascii?Q?Sz9sdbtM2H+vU+6ACh16jnLUy2sX3oaETJn54mBj1RrfMHGqKb3uH/I7CfsV?=
 =?us-ascii?Q?6hW1TFGGLKiS26yRQcdLOSRY3tF1CJ4qzhsBjuGTCtbgL25Fic45eHGRlzxh?=
 =?us-ascii?Q?phwmBVOAU6reRKucJqVDAvFWAi/2RmH3jBB+QVGQ4KAZCdmR7DTcnXYpmfL+?=
 =?us-ascii?Q?kHjOrgQVbj2+x7/Tu7hdvsh/QX9PZNiky/kVYPIioNTsVgW91Sd2+SF8mYeJ?=
 =?us-ascii?Q?DOHjujV/2hBqmpr8/MZfO5jlYTSlubt57POKolbJ9FY4nHib41Y4c9u2cixv?=
 =?us-ascii?Q?eOjpniiWp0NFtH8tbQQx+PimdNaeRAGAJKowSijZpKGNvyHE83LknJC64G4z?=
 =?us-ascii?Q?N7k69yeEFZ2JbQnS2uz0xAkF7P37Krj9HvgV7Z4eSwJMSqRvMRQ5eBLkrGOA?=
 =?us-ascii?Q?GTDtwmanf0XCO+abQ/+0up0esoVLpVE/XtUYLZDaDoenC5wu0Mreom7/43he?=
 =?us-ascii?Q?ambd2AoqczE/FEr1YSvAgMmlHz78viYuNnH6XtLpluGDckcwy6WHX2Mq5q7G?=
 =?us-ascii?Q?mo46LGPqlQ4TOz92zYzpJMh6kIcCb+A2zXFbH70DDsIkos9OrIgXDJeDOY1O?=
 =?us-ascii?Q?mSBPXxgQqwgE7mQ0Jx7Z1JiyHbqZfMBZFN/ONavAue8efnsOY2QcyOhkyAXy?=
 =?us-ascii?Q?NZcg1+XJCEi9WlaXKiMrDLRzEhCNAZKzllHB5hVm9nLX8LznkvuIBCWYC/vk?=
 =?us-ascii?Q?hUwDL7Qr1pyFeBynqP6VJhBR45WOAbizpLAXn9hFOmehU00uWHUt0FkqsWLb?=
 =?us-ascii?Q?14gIY9UZ6C2q/ygKFOUOzdEefHGLaN56tsKLBLVQbHxn59BUVTHZuNN7Qwkk?=
 =?us-ascii?Q?sDO69SYJ+j8ncljccu79pJCddtnl9La7ySSM7nT9e6lJlSve5ayHMd8EwvIV?=
 =?us-ascii?Q?oQZmLw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1892ad64-715d-471a-21eb-08d9fff4a253
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 04:40:40.8689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OCqCXw1SE0WAxaXHWXR5I4QbCOT1LZEWKIF5+UHbA2ZXhaH1pAnhr3lRh2Q4ZwPnIaLnHXn36d7DI1A78afkjk0ASt9zAGGSgrT6F8rjNZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1692
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thanks for review and comments. Please find reply inline below.

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, March 4, 2022 6:21 PM
> To: Divya Koppera - I30481 <Divya.Koppera@microchip.com>
> Cc: netdev@vger.kernel.org; hkallweit1@gmail.com; linux@armlinux.org.uk;
> davem@davemloft.net; kuba@kernel.org; robh+dt@kernel.org;
> devicetree@vger.kernel.org; richardcochran@gmail.com; linux-
> kernel@vger.kernel.org; UNGLinuxDriver <UNGLinuxDriver@microchip.com>;
> Madhuri Sripada - I34878 <Madhuri.Sripada@microchip.com>; Manohar Puri -
> I30488 <Manohar.Puri@microchip.com>
> Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure lat=
ency
> values and timestamping check for LAN8814 phy
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e
> content is safe
>=20
> On Fri, Mar 04, 2022 at 03:04:17PM +0530, Divya Koppera wrote:
> > Supports configuring latency values and also adds check for phy
> > timestamping feature.
> >
> > Signed-off-by: Divya Koppera<Divya.Koppera@microchip.com>
> > ---
> >  .../devicetree/bindings/net/micrel.txt          | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/net/micrel.txt
> > b/Documentation/devicetree/bindings/net/micrel.txt
> > index 8d157f0295a5..c5ab62c39133 100644
> > --- a/Documentation/devicetree/bindings/net/micrel.txt
> > +++ b/Documentation/devicetree/bindings/net/micrel.txt
> > @@ -45,3 +45,20 @@ Optional properties:
> >
> >       In fiber mode, auto-negotiation is disabled and the PHY can only =
work in
> >       100base-fx (full and half duplex) modes.
> > +
> > + - lan8814,ignore-ts: If present the PHY will not support timestamping=
.
> > +
> > +     This option acts as check whether Timestamping is supported by
> > +     hardware or not. LAN8814 phy support hardware tmestamping.
>=20
> Does this mean the hardware itself cannot tell you it is missing the need=
ed
> hardware? What happens when you forget to add this flag? Does the driver
> timeout waiting for hardware which does not exists?
>=20

If forgot to add this flag, driver will try to register ptp_clock that need=
s
access to clock related registers, which in turn fails if those registers d=
oesn't exists.

> > + - lan8814,latency_rx_10: Configures Latency value of phy in ingress a=
t 10
> Mbps.
> > +
> > + - lan8814,latency_tx_10: Configures Latency value of phy in egress at=
 10
> Mbps.
> > +
> > + - lan8814,latency_rx_100: Configures Latency value of phy in ingress =
at 100
> Mbps.
> > +
> > + - lan8814,latency_tx_100: Configures Latency value of phy in egress a=
t 100
> Mbps.
> > +
> > + - lan8814,latency_rx_1000: Configures Latency value of phy in ingress=
 at
> 1000 Mbps.
> > +
> > + - lan8814,latency_tx_1000: Configures Latency value of phy in egress =
at
> 1000 Mbps.
>=20
> Why does this need to be configured, rather than hard coded? Why would th=
e
> latency for a given speed change? I would of thought though you would tak=
e
> the average length of a PTP packet and divide is by the link speed.
>=20

This latency values could be different for different phy's. So hardcoding w=
ill not work here.
Yes in our case latency values depends on port speed. It is delay between n=
etwork medium and=20
PTP timestamp point.

>      Andrew
