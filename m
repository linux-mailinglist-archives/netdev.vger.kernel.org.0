Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B00F8193BC1
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgCZJZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 05:25:16 -0400
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:6238
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726338AbgCZJZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 05:25:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQ8U710FFNFeyDQqLcvgr7gVSNcAPRRx7n5e4r1pHgCJG8IUCA23IyeyuvI9gH2vjwvIjrCEa9srYNI/fBdLMqlH/QZE0xZRckXVTU/wUeQDKZpkBnFubFXRKvwoLX6vRbLod3qYkZBPY4WBs76YexYQjOMzHplEdYcDPkEhOQtCVl9DOrQjLSIT7WF/lwOBeSX6+ofVW/X7FSxZ4+gedCo3ZS0wWhKn/dhfbszKEho+tImQqg4Rmq0QHSPPrhPEnIDzh6Gv/3i7pDj4B7zgFNXEdGzeCSNWsTgE3gWpQDvxRMZsuTdEJQq3Mc9yYxzhn2MtnPjwMB5FOIOjg6ZaQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GBzm66wqaJBCVJK79rHWwbn/YN8IYwukW+OVfkaiTJs=;
 b=RdEjDjR45AHiMBRJI106QQS/rJ0fZnoyleN99souUFxUCcXGl387oWwAleFbi97WlazoR4g07K6GyqtERP7Ggjnakr4u+DyN7eAaQl8CftRBSXKSX4A8sQdpEhVO18y6oB6WPpJMv78OpDqFCug3/XXa5ShOUOtmeIpD6g2kqHGMX2VUzOZpT2vOnRHY1xIGM5zRkfl0Y5faHmydmhjsrygg9W4VpXdMDJ9eoGFMthfhI3XCoEMafMsCjgFz0+x9heJHA0eqolRg7efU74QUL3CarDXTIntsmRWd+/VzSKKl9mvuiGEnVg2diAXpR1AGpAmEla1Np4p6RZTg08tGWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GBzm66wqaJBCVJK79rHWwbn/YN8IYwukW+OVfkaiTJs=;
 b=rrLNxsxl3BVp7K4DvPimWmxRg+7b8fSfgFpHGEtW2yG5ov03dYeVPX1L4N5omOAtexJMroZ7JdBaC23qBF9ieYu/hCPjSNIeESGY6nH2O+tkvtKn6e9wKN1bvLH88bpuavpMbB+hSsUXz3PEhPk0C3A4V3xuu4Hm30EgnmSFAo8=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (10.141.174.88) by
 AM7PR04MB7192.eurprd04.prod.outlook.com (52.135.58.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.19; Thu, 26 Mar 2020 09:25:11 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94%2]) with mapi id 15.20.2856.019; Thu, 26 Mar 2020
 09:25:11 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Thread-Topic: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Thread-Index: AQHV/qQWBIiKj5A/T0WD8BjMeGVxRqhZUaeAgAFP25A=
Date:   Thu, 26 Mar 2020 09:25:11 +0000
Message-ID: <AM7PR04MB6885D1A865AD7E539DAA16F6F8CF0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-7-yangbo.lu@nxp.com> <20200325131534.GA32284@localhost>
In-Reply-To: <20200325131534.GA32284@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f0971688-e420-4646-1909-08d7d1679543
x-ms-traffictypediagnostic: AM7PR04MB7192:|AM7PR04MB7192:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB7192E25EBA0B23061690EEC1F8CF0@AM7PR04MB7192.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(6506007)(53546011)(81156014)(81166006)(52536014)(9686003)(76116006)(66946007)(66446008)(66556008)(66476007)(64756008)(478600001)(8936002)(7696005)(55016002)(2906002)(33656002)(86362001)(4326008)(71200400001)(5660300002)(8676002)(186003)(26005)(54906003)(6916009)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR04MB7192;H:AM7PR04MB6885.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BeEpNPDN3bL8lLXmew2LfRM86kWGR40oW8uMOvchrzcjTBYSRBE2f3wUjiQ3wA15A5BbYlyrK46zRXUU8qBwObWhnMi9SleyQ0d4X6ohLc4fEDDooYU3sUEThGNIfmvpa2+JPQMpl/cg6rja/BQYbp9yx4iNMLPweqBg52RFDcGp567qCN9GzUlQjGV71BdV8ZcC+//iFUaF2+INe5S4mqrq9Us1pV19t/FGWy2houxVEtAfO6/v4cmuCJ2AM4tDLMFtxwGqlW+aG4+xe2tPCpwBXXkw9FXaqvBVHTHaBP3uRi+q58TN2r0Sl0aXgs5fK6lpc+OfOsSAvKz+naBP7TvF1V90z5oZPI/oQB1+sHDjLGath6agFxzyA8JmmYRjS1c4Ax1HciM1Fo+M/KmE/t1/iUq7Wx20624TWmzGG9txEvB736/cb79BlIAX1XiT
x-ms-exchange-antispam-messagedata: g2S0SU1kGQPrC6blbsnyoHTqK56ckZgd69L+PQljoNbwv8CQRWpa0aHTXK6kA03Q3Vxp+feR5QWXg+u9eKDFPpaR3msPAjLF0nLPeoTBRpvqRzYLf62zoMyQM0KTgazQoClM7iKpcMl2cJktrGUBpQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0971688-e420-4646-1909-08d7d1679543
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 09:25:11.0820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WZVt6k80X+806uqARoBkOAJqXsGz8G430ZjynMong/iXrTZOTV/0F9YeKDyCDUfkkH6OcUjdDIugc+4WI/tp+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7192
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Wednesday, March 25, 2020 9:16 PM
> To: Y.b. Lu <yangbo.lu@nxp.com>
> Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; David S . Mille=
r
> <davem@davemloft.net>; Vladimir Oltean <vladimir.oltean@nxp.com>;
> Claudiu Manoil <claudiu.manoil@nxp.com>; Andrew Lunn <andrew@lunn.ch>;
> Vivien Didelot <vivien.didelot@gmail.com>; Florian Fainelli
> <f.fainelli@gmail.com>; Alexandre Belloni <alexandre.belloni@bootlin.com>=
;
> Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
>=20
> On Fri, Mar 20, 2020 at 06:37:26PM +0800, Yangbo Lu wrote:
> > Support 4 programmable pins for only one function periodic
> > signal for now.
>=20
> For now?

Yes. The pin on Ocelot/Felix supports both PTP_PF_PEROUT and PTP_PF_EXTTS f=
unctions.
But the PTP_PF_EXTTS function should be implemented separately in Ocelot an=
d Felix since hardware interrupt implementation is different on them.
I am responsible for Felix. However I am facing some issue on PTP_PF_EXTTS =
function on hardware. It may take a long time to discuss internally.

Thanks.

>=20
> > +static int ocelot_ptp_verify(struct ptp_clock_info *ptp, unsigned int =
pin,
> > +			     enum ptp_pin_function func, unsigned int chan)
> > +{
> > +	switch (func) {
> > +	case PTP_PF_NONE:
> > +	case PTP_PF_PEROUT:
> > +		break;
>=20
> If the functions cannot be changed, then supporting the
> PTP_PIN_SETFUNC ioctl does not make sense!

Did you mean the dead lock issue? Or you thought the pin supported only PTP=
_PF_PEROUT function in hardware?

>=20
> > +	case PTP_PF_EXTTS:
> > +	case PTP_PF_PHYSYNC:
> > +		return -1;
> > +	}
> > +	return 0;
> > +}
>=20
> Thanks,
> Richard
