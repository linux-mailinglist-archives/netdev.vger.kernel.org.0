Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76184191F8E
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 04:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgCYDIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 23:08:55 -0400
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:28834
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727262AbgCYDIz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 23:08:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9731y2HU5rIxBMQhRsAbeLLFL3IaehNwO2OfHD/gJlk+4DuqWtEgdDbhcw+/3wRRd3e5+XYvW0nCGRbmJMSiMBcDGvJCXCtHtTDuI1zbkPgZdV5XWfMN+p9EkWrggoBXluGPt2jEyaab+IlAHLQNEt23ob6x5ZM96Mnbh7WzGudHKNE60R8GcwlTv2500FY46YWODgHemdb9Us32mX4bwvVMnSvVKXIkpIBjoPZH2gOUduUU8XiTYGhF8p4tTTl+YRk9QcNEUECCgCdAMVZl28qjBAqyjB1tbFd8n2i4+5X9DTkzr/ZVGTG9mo2usPR+EThxTuBCfgdg+qUhNDrlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/5k1aQBQSoxj3i+ieSgYDTukkWtTJeWqC29jpYv5ZE=;
 b=gEQ+LnkXpoIl5ZZVC+d2gWprs+LsmR+I8vBif78cu0YirskeAJIuz6ZqAyTvkYaY8IH+HZtzFT/0fzlJDZOEzBboJgQDo8btUaQtrCY4gnUnj77/9Cvm8v/VL6vQoFKmY+5WnV9OThCIzZd/340tBLZ2pU4RRFd9jJEZ4D7T85mxDLWJ7M/w1AYJR+EMku3TKttCGx5M5+mmjodBUJhS5f/B09XEhim1K4+FhNUrJT4YLWl0KQERmK6pJWeOfBIHGichCMAO+EYNuecAn9RCe6b4kwrwBDqdR5We/AEJV9iBWE0EcpUDzklm3agxIY16PwxnRRlZQzuDpc//b1RqhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/5k1aQBQSoxj3i+ieSgYDTukkWtTJeWqC29jpYv5ZE=;
 b=Qw3dl6sDz77lSho+KPg1q66eTxjfRTJOb2iY2zdd3J3mjxnGo7wxGA5mjf3VVD5h8KBpD2yQIDH8MgeKCTZit2SqizUreSrG5Dgzd6yn5hIRNHoBvAI+9IYqFkjgAxenbPdmybASd+5BpuZLUYqHWFuSJ+V3fQBnlbAkPOTVFlE=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (10.141.174.88) by
 AM7PR04MB6902.eurprd04.prod.outlook.com (10.141.172.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Wed, 25 Mar 2020 03:08:46 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94%2]) with mapi id 15.20.2835.021; Wed, 25 Mar 2020
 03:08:46 +0000
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
Thread-Index: AQHV/qQWBIiKj5A/T0WD8BjMeGVxRqhXvRSAgADnAvA=
Date:   Wed, 25 Mar 2020 03:08:46 +0000
Message-ID: <AM7PR04MB688500546D0FC4A64F0DA19DF8CE0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-7-yangbo.lu@nxp.com> <20200324130733.GA18149@localhost>
In-Reply-To: <20200324130733.GA18149@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.68.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 242e2719-3b19-43a0-7a86-08d7d069d53c
x-ms-traffictypediagnostic: AM7PR04MB6902:|AM7PR04MB6902:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB6902115774A07209330E6CA8F8CE0@AM7PR04MB6902.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(5660300002)(33656002)(7696005)(71200400001)(186003)(54906003)(9686003)(81156014)(26005)(55016002)(86362001)(8676002)(81166006)(316002)(2906002)(66446008)(52536014)(4326008)(64756008)(6916009)(66476007)(66556008)(76116006)(6506007)(66946007)(8936002)(53546011)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR04MB6902;H:AM7PR04MB6885.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UB5vVs+MUKryY3gkHYC+TM4Q6XgZFrhrIYj0BNChpwabB6sgl0EcrCIlRNt2rAJPoMKQuXcMYxGjGLADdmN9tq6BMb+1mGuWA5HQ1nNAAaQmj8MsYaMGnsVl0Y8oJQ5AEFUQrqgYHwoKh2YglqHfjBbbMFapqLwgk1jsjgz4X/WXof/oNdAootdDukfVVHN4vGPDDa+6oKIr42CT9Tqlo9VT8yr8ETrbIWRS2/lBw7RJWgKqzqW4tbfV1f1YTq4699mM+q6olAvhpHVxwxJYPm7xgEMLE6DSsgeITnsbAaKZ28C4No47Co2vsdQqEoqP6QEssn2aF4h8LU5fk02RlBTXLurIgwmptEa10DUOWmX2cmnUJccTwogxh2UVKMXzAPQ+lrg/wl+pGUmyBfjkv9u0RNRO2Y5aT4DN4kGPQQSA1hPOncE3LhAr0Zki0lug
x-ms-exchange-antispam-messagedata: 5CPRyb9IEnafe7WYK6BMWUd6Hvz7pkkKIAkvakfmvPqL0wEUkbqWcPSS9z17vYg/rVpJ1CC7LyTQ7pf/NZdmhZ79I10RUhd1SVbzhaVF+0igESiurcm/mmVqQcOovyWBo3BdJBISB3KaQx8Ai2oQow==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 242e2719-3b19-43a0-7a86-08d7d069d53c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 03:08:46.3241
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 97okZQjcMsop9P4poCdbU2kmunZGuV9q2pCN7D5w3pfdGB580alRYjE7vwKypTASqyy1TpJjEBokFtvjjDobNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6902
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Tuesday, March 24, 2020 9:08 PM
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
> > +static int ocelot_ptp_enable(struct ptp_clock_info *ptp,
> > +			     struct ptp_clock_request *rq, int on)
> > +{
> > +	struct ocelot *ocelot =3D container_of(ptp, struct ocelot, ptp_info);
> > +	enum ocelot_ptp_pins ptp_pin;
> > +	struct timespec64 ts;
> > +	unsigned long flags;
> > +	int pin =3D -1;
> > +	u32 val;
> > +	s64 ns;
> > +
> > +	switch (rq->type) {
> > +	case PTP_CLK_REQ_PEROUT:
> > +		/* Reject requests with unsupported flags */
> > +		if (rq->perout.flags)
> > +			return -EOPNOTSUPP;
> > +
> > +		/*
> > +		 * TODO: support disabling function
> > +		 * When ptp_disable_pinfunc() is to disable function,
> > +		 * it has already held pincfg_mux.
> > +		 * However ptp_find_pin() in .enable() called also needs
> > +		 * to hold pincfg_mux.
> > +		 * This causes dead lock. So, just return for function
> > +		 * disabling, and this needs fix-up.
>=20
> What dead lock?
>=20
> When enable(PTP_CLK_REQ_PEROUT, on=3D0) is called, you don't need to
> call ptp_disable_pinfunc().  Just stop the periodic waveform
> generator.  The assignment of function to pin remains unchanged.

This happens when we try to change pin function through ptp_ioctl PTP_PIN_S=
ETFUNC.
When software holds pincfg_mux and calls ptp_set_pinfunc, it will disable t=
he function previous assigned and the current function of current pin calli=
ng ptp_disable_pinfunc.
The problem is the enable callback in ptp_disable_pinfunc may have to hold =
pincfg_mux for ptp_find_pin.

The calling should be like this,
ptp_set_pinfunc (hold pincfg_mux)
---> ptp_disable_pinfunc
   ---> .enable
      ---> ptp_find_pin (hold pincfg_mux)

Thanks.

>=20
> > +		 */
> > +		if (!on)
> > +			break;
> > +
> > +		pin =3D ptp_find_pin(ocelot->ptp_clock, PTP_PF_PEROUT,
> > +				   rq->perout.index);
> > +		if (pin =3D=3D 0)
> > +			ptp_pin =3D PTP_PIN_0;
> > +		else if (pin =3D=3D 1)
> > +			ptp_pin =3D PTP_PIN_1;
> > +		else if (pin =3D=3D 2)
> > +			ptp_pin =3D PTP_PIN_2;
> > +		else if (pin =3D=3D 3)
> > +			ptp_pin =3D PTP_PIN_3;
> > +		else
> > +			return -EINVAL;
>=20
> Return -EBUSY here instead.

Thanks. Will modify it in next version.

>=20
> Thanks,
> Richard
