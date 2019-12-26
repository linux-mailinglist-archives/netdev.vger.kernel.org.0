Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF77812ABE3
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 12:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfLZLWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 06:22:53 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:36846
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726055AbfLZLWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 06:22:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWrJcwca7c0H4hBWjyf6kn7t/7/eP1J5z/vTATCrchmKaGsozt7MymKrF+6gojv/XspaEY7aTVkvtphMg6qDNOEMNiXodTOxvHdWK3/jsEDYgWyv1cmwrXWrE3tibcoPO95XB1CuV6QiQZNNd9EpBWjWV+9l+MQvANe4sKgSePkwXExUycwfQFNJT60xlGA8lfBaDyeLy+6cx5RsJz2t1zu8YaF0n6zFJA1Gm4aWOZG21WPet1CmARYucZkMHy07KG3uBj8uCYaCRMbETUjk2c8YAHRzSTMwRVgzXE/t+2HBprFkviw8ZpYLPj8oUkvtdhcxIqmrWP7/3ibuM90gUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yaGEsOoS9Ei6acCs1oYKdQYyLdvVgdugBoxGm2g25Y=;
 b=ntwMW1xeqUamtUiTgJ/DUIfEMqYaQ4PMD/geU16kQAtfv+GxHuKl0jX4zCSGtomFJBACi9NAppOABXTxxmQod1FUlxHiBdZBubZNiVP8wv6IJXBYTJg2ZVvu4H/GfybAU4Hkls5Ihn1o/uv5ERr42CIYpZSPrtXsO4cit/qWGj4MnYZ/geFGRf335o6HXf2fEU7g7+ZzPMdnh8tsD2QIZ9U/lm5f6oDBEZFhdY5lBFci6d+BK8FPfjT4h3j3GMH/OYlW/UHOB1AbkY+R+/bq3UL6rXUOpM5xw5TLeBKM1WN4/Y8cenwzNfxo5htCazR7J8u25tLLdbKOBwfX72JppQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yaGEsOoS9Ei6acCs1oYKdQYyLdvVgdugBoxGm2g25Y=;
 b=jCNCfg1cGUylkv4IMKva8mN86fupY4GfpXzxH6XkwSUYOXUWBp0cGkbb91t4lQPjEZ2hipIDykGWmViicjsoMxb0fvSzHkG5eSW3FM4B1coPoX9RLjI0Vheta2uuGJcrYmTXbRiei5PwK0bjzU1e+lKVI9pZ3vWX8ZOfHpIFhZY=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (10.141.174.88) by
 AM7PR04MB7144.eurprd04.prod.outlook.com (52.135.58.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Thu, 26 Dec 2019 11:22:47 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f07f:2e7c:2cda:f041]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::f07f:2e7c:2cda:f041%3]) with mapi id 15.20.2559.017; Thu, 26 Dec 2019
 11:22:47 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: RE: [PATCH] net: mscc: ocelot: support PPS signal generation
Thread-Topic: [PATCH] net: mscc: ocelot: support PPS signal generation
Thread-Index: AQHVu9M/WSOP+wb7uEmsr7BfCHTyEqfMPzMAgAAGbAA=
Date:   Thu, 26 Dec 2019 11:22:47 +0000
Message-ID: <AM7PR04MB6885E29B3D92E3C256A10D37F82B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20191226095851.24325-1-yangbo.lu@nxp.com>
 <20191226105838.GD1480@lunn.ch>
In-Reply-To: <20191226105838.GD1480@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 25f7b257-d7b5-460d-5a19-08d789f5ef89
x-ms-traffictypediagnostic: AM7PR04MB7144:|AM7PR04MB7144:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB71444C514FA8CD40BE3EE7A2F82B0@AM7PR04MB7144.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02638D901B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(199004)(189003)(13464003)(5660300002)(81156014)(8676002)(8936002)(81166006)(33656002)(316002)(9686003)(478600001)(55016002)(71200400001)(54906003)(4326008)(64756008)(66476007)(66946007)(66556008)(66446008)(76116006)(86362001)(186003)(26005)(2906002)(52536014)(6916009)(53546011)(6506007)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR04MB7144;H:AM7PR04MB6885.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sk8qYDa6ssBazE50MaEWRrhauvTvGTP9fo9k93EYAN1cPR9CY/rsNNoO1CcnlukcUypmtXiIdWR/6WK0Empf8nsNrexoQTGz5g8mw+Dx6RB8QL6oP6S2G94DYu5nw2hYFiMTWD4TzMYrfzqYKao3IxqJg4bedjMSS5ZnWL2lsL0xwXeLo8xa9Xl48jXNHdfWcCUXR5eo5RjvjnRVL2fTGCHbt3zYneQ8QHLfhVmexGEs6g+XTvhsKDrLjmcRE+LxyB9igjrmgpHEtMQGECRyhNIc+/NKn2lAvOZZhYZFt22UW5EJxuTFN/CgYimQ7qmKdsryLem5yavzLnQ6fJJkpRlzmUJHeKurMccNqId3UjorONq5mGur1g7m0zUovMUG7L8VGIQ5x7EWOyZ0Y69p0AyXUDA6e1d3vDmJykIt2UrSmW7gvJn2kxik6oDRHKDImCdDT4tzeuU9nV+XExk+yHBVBHSkNJMU7lw4bdE4RIrvGTOHWX/8r8TQUstjcJYJ
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25f7b257-d7b5-460d-5a19-08d789f5ef89
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Dec 2019 11:22:47.3748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2YpRZR9NP2var02EpZK+59uFZm/UKzDVrW799VpHV6pc02cXpAlHbnlMF90Gk/tCA8LdnH9F0zOSDiHRxJvGqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, December 26, 2019 6:59 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>;
> Claudiu Manoil <claudiu.manoil@nxp.com>; Vladimir Oltean
> <vladimir.oltean@nxp.com>; Alexandre Belloni
> <alexandre.belloni@bootlin.com>; Microchip Linux Driver Support
> <UNGLinuxDriver@microchip.com>; Richard Cochran
> <richardcochran@gmail.com>
> Subject: Re: [PATCH] net: mscc: ocelot: support PPS signal generation
>=20
> On Thu, Dec 26, 2019 at 05:58:51PM +0800, Yangbo Lu wrote:
> > This patch is to support PPS signal generation for Ocelot family
> > switches, including VSC9959 switch.
>=20
> Hi Yangbo
>=20
> Please always Cc: Richard Cochran <richardcochran@gmail.com> for ptp
> patches.
>=20

Sorry for missing...

> 	Andrew
>=20
> >
> > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> > ---
> >  drivers/net/dsa/ocelot/felix_vsc9959.c  |  2 ++
> >  drivers/net/ethernet/mscc/ocelot.c      | 25
> +++++++++++++++++++++++++
> >  drivers/net/ethernet/mscc/ocelot_ptp.h  |  2 ++
> >  drivers/net/ethernet/mscc/ocelot_regs.c |  2 ++
> >  include/soc/mscc/ocelot.h               |  2 ++
> >  5 files changed, 33 insertions(+)
> >
> > diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c
> b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > index b9758b0..ee0ce7c 100644
> > --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> > +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > @@ -287,6 +287,8 @@ static const u32 vsc9959_ptp_regmap[] =3D {
> >  	REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
> >  	REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
> >  	REG(PTP_PIN_TOD_NSEC,              0x00000c),
> > +	REG(PTP_PIN_WF_HIGH_PERIOD,        0x000014),
> > +	REG(PTP_PIN_WF_LOW_PERIOD,         0x000018),
> >  	REG(PTP_CFG_MISC,                  0x0000a0),
> >  	REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
> >  	REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c
> b/drivers/net/ethernet/mscc/ocelot.c
> > index 985b46d..c0f8a9e 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -2147,6 +2147,29 @@ static struct ptp_clock_info
> ocelot_ptp_clock_info =3D {
> >  	.adjfine	=3D ocelot_ptp_adjfine,
> >  };
> >
> > +static void ocelot_ptp_init_pps(struct ocelot *ocelot)
> > +{
> > +	u32 val;
> > +
> > +	/* PPS signal generation uses CLOCK action. Together with SYNC option=
,
> > +	 * a single pulse will be generated after <WAFEFORM_LOW>
> nanoseconds
> > +	 * after the time of day has increased the seconds. The pulse will
> > +	 * get a width of <WAFEFORM_HIGH> nanoseconds.
> > +	 *
> > +	 * In default,
> > +	 * WAFEFORM_LOW =3D 0
> > +	 * WAFEFORM_HIGH =3D 1us
> > +	 */
> > +	ocelot_write_rix(ocelot, 0, PTP_PIN_WF_LOW_PERIOD, ALT_PPS_PIN);
> > +	ocelot_write_rix(ocelot, 1000, PTP_PIN_WF_HIGH_PERIOD,
> ALT_PPS_PIN);
> > +
> > +	val =3D ocelot_read_rix(ocelot, PTP_PIN_CFG, ALT_PPS_PIN);
> > +	val &=3D ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK |
> PTP_PIN_CFG_DOM);
> > +	val |=3D (PTP_PIN_CFG_SYNC |
> PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK));
> > +
> > +	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, ALT_PPS_PIN);
> > +}
> > +
> >  static int ocelot_init_timestamp(struct ocelot *ocelot)
> >  {
> >  	struct ptp_clock *ptp_clock;
> > @@ -2478,6 +2501,8 @@ int ocelot_init(struct ocelot *ocelot)
> >  				"Timestamp initialization failed\n");
> >  			return ret;
> >  		}
> > +
> > +		ocelot_ptp_init_pps(ocelot);
> >  	}
> >
> >  	return 0;
> > diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.h
> b/drivers/net/ethernet/mscc/ocelot_ptp.h
> > index 9ede14a..21bc744 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_ptp.h
> > +++ b/drivers/net/ethernet/mscc/ocelot_ptp.h
> > @@ -13,6 +13,8 @@
> >  #define PTP_PIN_TOD_SEC_MSB_RSZ		PTP_PIN_CFG_RSZ
> >  #define PTP_PIN_TOD_SEC_LSB_RSZ		PTP_PIN_CFG_RSZ
> >  #define PTP_PIN_TOD_NSEC_RSZ		PTP_PIN_CFG_RSZ
> > +#define PTP_PIN_WF_HIGH_PERIOD_RSZ	PTP_PIN_CFG_RSZ
> > +#define PTP_PIN_WF_LOW_PERIOD_RSZ	PTP_PIN_CFG_RSZ
> >
> >  #define PTP_PIN_CFG_DOM			BIT(0)
> >  #define PTP_PIN_CFG_SYNC		BIT(2)
> > diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c
> b/drivers/net/ethernet/mscc/ocelot_regs.c
> > index b88b589..ed4dd01 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_regs.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_regs.c
> > @@ -239,6 +239,8 @@ static const u32 ocelot_ptp_regmap[] =3D {
> >  	REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
> >  	REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
> >  	REG(PTP_PIN_TOD_NSEC,              0x00000c),
> > +	REG(PTP_PIN_WF_HIGH_PERIOD,        0x000014),
> > +	REG(PTP_PIN_WF_LOW_PERIOD,         0x000018),
> >  	REG(PTP_CFG_MISC,                  0x0000a0),
> >  	REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
> >  	REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index 64cbbbe..c2ab20d 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -325,6 +325,8 @@ enum ocelot_reg {
> >  	PTP_PIN_TOD_SEC_MSB,
> >  	PTP_PIN_TOD_SEC_LSB,
> >  	PTP_PIN_TOD_NSEC,
> > +	PTP_PIN_WF_HIGH_PERIOD,
> > +	PTP_PIN_WF_LOW_PERIOD,
> >  	PTP_CFG_MISC,
> >  	PTP_CLK_CFG_ADJ_CFG,
> >  	PTP_CLK_CFG_ADJ_FREQ,
> > --
> > 2.7.4
> >
