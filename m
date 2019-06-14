Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6368446002
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbfFNOGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:06:10 -0400
Received: from mail-eopbgr10041.outbound.protection.outlook.com ([40.107.1.41]:21321
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728034AbfFNOGJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 10:06:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6jrAa0Qt/C2g+7j0/P38K8SXlNRuohLS54E/U3KIgo=;
 b=StoVC6YRcaEDRPdCnvoYSjnmnb4CCrTkjCcy/laI4sBdMdkB/3zzt5nvAfp0SORLAkDR+ocFcVSzddmaNndpbexvKD8dFLnkUK/b/vHS85CrouHFXXECIl/3BM02bYwvl23bgxURt5P+luAbC+vlpk4wT5ea40eLbGLubUJa004=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3712.eurprd04.prod.outlook.com (52.134.15.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Fri, 14 Jun 2019 14:06:06 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188%3]) with mapi id 15.20.1987.012; Fri, 14 Jun 2019
 14:06:06 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: RE: [PATCH RFC 3/6] dpaa2-mac: add MC API for the DPMAC object
Thread-Topic: [PATCH RFC 3/6] dpaa2-mac: add MC API for the DPMAC object
Thread-Index: AQHVIkOh0y3ZPvJmKkWBHedOBEb5YqaaV+sAgADJeTA=
Date:   Fri, 14 Jun 2019 14:06:05 +0000
Message-ID: <VI1PR0402MB28002EE1DB0B3FB39B907052E0EE0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
 <1560470153-26155-4-git-send-email-ioana.ciornei@nxp.com>
 <20190614011224.GC28822@lunn.ch>
In-Reply-To: <20190614011224.GC28822@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95105192-c1d5-4edf-c0b8-08d6f0d17169
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0402MB3712;
x-ms-traffictypediagnostic: VI1PR0402MB3712:
x-microsoft-antispam-prvs: <VI1PR0402MB37126D8176888C2693FD77B8E0EE0@VI1PR0402MB3712.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(74316002)(71190400001)(54906003)(4326008)(2906002)(229853002)(76116006)(73956011)(6116002)(3846002)(446003)(476003)(25786009)(14454004)(478600001)(6246003)(6436002)(71200400001)(11346002)(86362001)(6916009)(316002)(76176011)(52536014)(33656002)(66066001)(6506007)(99286004)(53936002)(7696005)(68736007)(81166006)(44832011)(8936002)(26005)(66446008)(66476007)(64756008)(81156014)(66556008)(8676002)(9686003)(66946007)(55016002)(486006)(102836004)(5660300002)(186003)(305945005)(256004)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3712;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xYLLNiJ/fOKe2wj9a3qXzR6KWsNiV9TBKrzAFX2rTwoxY/kI5XzCYu+cNxUQS9m7UosNGrRwIfWdW6FRUqPbJJECJ//043AmRFhCbmN7k9y2FwO6ecGHMhL94Epb83OJFBfvrPsMBbyc5KoHrpbQZF8LtJHJU/iHiclYcJ5S6vFkGDqBYEJFmkDPzRq938hARfVJ+bkSzV9O+5S7Gk+hhIdGyzGJCC2Jd5VbT1X2owANHcxSVjtTSrB9dyVKLW1srBgpis4cDAXFBTPo9MdqBhqsJZolnWJEkM3R4qjjQvp6DBAISXvsNW4Ru8QyS15zF2yow+mabq5I/hAy9prpL7xkhEFUoOCnuApXgsUal6/dQXZWHFs2c5xHWWWW8TxNxcW5Raauu9s702BofnZd4T6JwnnssRkaAgeoQh+8mZY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95105192-c1d5-4edf-c0b8-08d6f0d17169
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 14:06:06.0230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3712
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH RFC 3/6] dpaa2-mac: add MC API for the DPMAC object
>=20
> > +/**
> > + * dpmac_set_link_state() - Set the Ethernet link status
> > + * @mc_io:      Pointer to opaque I/O object
> > + * @cmd_flags:  Command flags; one or more of 'MC_CMD_FLAG_'
> > + * @token:      Token of DPMAC object
> > + * @link_state: Link state configuration
> > + *
> > + * Return:      '0' on Success; Error code otherwise.
> > + */
> > +int dpmac_set_link_state(struct fsl_mc_io *mc_io,
> > +			 u32 cmd_flags,
> > +			 u16 token,
> > +			 struct dpmac_link_state *link_state) {
> > +	struct dpmac_cmd_set_link_state *cmd_params;
> > +	struct fsl_mc_command cmd =3D { 0 };
> > +
> > +	/* prepare command */
> > +	cmd.header =3D
> mc_encode_cmd_header(DPMAC_CMDID_SET_LINK_STATE,
> > +					  cmd_flags,
> > +					  token);
> > +	cmd_params =3D (struct dpmac_cmd_set_link_state *)cmd.params;
> > +	cmd_params->options =3D cpu_to_le64(link_state->options);
> > +	cmd_params->rate =3D cpu_to_le32(link_state->rate);
> > +	dpmac_set_field(cmd_params->state, STATE, link_state->up);
> > +	dpmac_set_field(cmd_params->state, STATE_VALID,
> > +			link_state->state_valid);
> > +	cmd_params->supported =3D cpu_to_le64(link_state->supported);
> > +	cmd_params->advertising =3D cpu_to_le64(link_state->advertising);
>=20
> I don't understand what supported and advertising mean in the context of =
a
> MAC. PHY yes, but MAC?

It's still in the context of the PHY. I see that the choice of function nam=
e is not great but this is done
only to convey what the supported and the advertising modes are to the Ethe=
rnet driver.


>=20
> > + * DPMAC link configuration/state options */
> > +
> > +/**
> > + * Enable auto-negotiation
> > + */
> > +#define DPMAC_LINK_OPT_AUTONEG			BIT_ULL(0)
> > +/**
> > + * Enable half-duplex mode
> > + */
> > +#define DPMAC_LINK_OPT_HALF_DUPLEX		BIT_ULL(1)
> > +/**
> > + * Enable pause frames
> > + */
> > +#define DPMAC_LINK_OPT_PAUSE			BIT_ULL(2)
> > +/**
> > + * Enable a-symmetric pause frames
> > + */
> > +#define DPMAC_LINK_OPT_ASYM_PAUSE		BIT_ULL(3)
>=20
> So is this to configure the MAC? The MAC can do half duplex, pause, asym
> pause?
>=20
> But from the previous patch, the PHY cannot do half duplex?
>=20
>      Andrew

As stated in the previous reply, the MAC can do pause, asym pause but not h=
alf duplex or EEE.
The DPMAC_LINK_OPT_HALF_DUPLEX bit is just a leftover and can be removed.

--
Ioana
