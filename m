Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D331701F2
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 16:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgBZPH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 10:07:57 -0500
Received: from mail-eopbgr140071.outbound.protection.outlook.com ([40.107.14.71]:16548
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbgBZPH4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 10:07:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDgoYgNOk8TqRRTiRVZyTfhPcqPV+rZyFxZiEooeKHcel/xx5jwR0hIwFDow00P4KTBIGHih3U0kWdBwZ2ZAJc1MC4W9r45fCSyNy6hN1bBm83HaRy+b42HUsvQE3/KLugXWv0qX5bE7+3UaaOjHImN/TqRJ1Z1WEvZgJENVRTVkaGO3OjiGezUtrIfSgF0ke04xRSkL+glNrPJhNnS33PVF0NeX+45WMJgvH74uSy0GpIpoa7bMa0GqfXaApV+vP/swTHE7G5WNc77O08faWnHHTb1HU6TvCP5pAkIrJaw3Ou5HBIwPrUD6fvHx66WQSNdi0XsljZ675tDZ6f2uRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKQxL1tg8qxGVVymZDRFYi7aXQYJ/gAgT6avONxa66o=;
 b=gGlPPI7+y2XaFLVoUyP4i/PWPGlHPAouB1S8Vq1kfKnURZPqVp4SV577s5kXSMFDhks0GXKGZ/2XW184ZEf+R/I9IgGi3nu1TNqRVTvJznFe447uJ4RWdjh1adn2VmNajeWcw3HhP6NjfMvKyQNzSjo9zACuN/1lmIoP16ggte8MaH6nIjJtwjZ0HLVkiHFXgVg48CRGTNtI+dgf8CQHxBajwktsc/3sP49vC9dCHafNTZtGYXtvs4Ncn9mAn1EViGytUxc2qdYL5iyuv1CF34wfiOG8GY/VN8j6rnOENhi9uuwb+pVwayoJBlrBCClEiqOy0wjtGrVaVakF4keUDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKQxL1tg8qxGVVymZDRFYi7aXQYJ/gAgT6avONxa66o=;
 b=qh2ymQld5yXHCY3O+EEPOOLjB/gFh6bESYsw+wPE4CFOTyJHsdnpGxb5iVvX5NsyYMAp30IBrLPUomPg06jQJ/4gyYRsoMApglMJcp0jKY6ystxXU8KI2MdQgiOhSl0Y/dr3vcW6fDZ5A01yRGFlyYl+xLAJM+AzQK0lUyr0mRk=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (52.133.240.149) by
 DB8PR04MB6716.eurprd04.prod.outlook.com (20.179.250.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Wed, 26 Feb 2020 15:07:52 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::9484:81c6:c73b:2697]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::9484:81c6:c73b:2697%6]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 15:07:52 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jose Abreu <joabreu@synopsys.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: RE: [PATCH net-next 5/8] net: dpaa2-mac: use resolved link config in
 mac_link_up()
Thread-Topic: [PATCH net-next 5/8] net: dpaa2-mac: use resolved link config in
 mac_link_up()
Thread-Index: AQHV67+le9Rplv4RF0eFqNNnaoBGEagsGLhggAEqKwCAAFHtwA==
Date:   Wed, 26 Feb 2020 15:07:51 +0000
Message-ID: <DB8PR04MB6828131F75AB5D9162138F6DE0EA0@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <20200225093703.GS25745@shell.armlinux.org.uk>
 <E1j6WgG-0000TJ-CC@rmk-PC.armlinux.org.uk>
 <DB8PR04MB68282F710FB598B977C36F99E0ED0@DB8PR04MB6828.eurprd04.prod.outlook.com>
 <20200226101204.GW25745@shell.armlinux.org.uk>
In-Reply-To: <20200226101204.GW25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b8e8932d-a94c-4dd2-d83b-08d7bacda67a
x-ms-traffictypediagnostic: DB8PR04MB6716:
x-microsoft-antispam-prvs: <DB8PR04MB671631EC366662E4A1D10496E0EA0@DB8PR04MB6716.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0325F6C77B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(189003)(199004)(81156014)(8676002)(33656002)(186003)(8936002)(6916009)(81166006)(71200400001)(44832011)(7696005)(26005)(6506007)(66946007)(66446008)(4326008)(478600001)(86362001)(7416002)(66556008)(64756008)(55016002)(54906003)(9686003)(76116006)(52536014)(66476007)(2906002)(316002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6716;H:DB8PR04MB6828.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FG1SoBBnTbK9ttGqNZCCCrC4A9Y2C1emH4fWhzRc7BNmeM3Oy7uWEJ0p3WDst/wl5U8eXCXyTzwyYmojNHwRG0Gz9vbP6eUfn/Wl2WkXaqG6kDVL/woTQ6arloxkriX1wPqkmBsoJnp3gjn9VhccqFxxRqX5fOIrDchUwMYvGEJG91qdpSHEZlHrQGUCZtwtyW6lYGqHFd/ok3fpm63HbFf2Cqrq5Dd503uLBYHNZzvtD62uvcgOkP7CQFLW4U7gptd5HVgMyKCvUkYi9pA4hsfHFik10809ILuL8OxC0pAoV0XfJa63qbRDUg0tjJJgRE2vugZGdDVIurm/Wtw1Tcrbvu0oHGcbKakbAUd8tT9Y0P4y7lR8K+ktWyUKieKxjlqOEw31qGsAm9Y0HVbpEWVWtAz96rJEV7xYhjkR1zH/Jj/NHdUXOB4zP+FTolWJ
x-ms-exchange-antispam-messagedata: 3tiDRHOqRBv4I8HkL06zHdDmXhpCLu7+GrB0MJKOGt41b38T0bzzE7hew5c/5AaS2kxkkfI0V+6I8kGuFsZ4r86W7T0ADFwmI/PPiWLb/pqIa75JwKLOFU+QgFsRFzGW38RBuIJMhieFagbJMhNFQg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8e8932d-a94c-4dd2-d83b-08d7bacda67a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2020 15:07:51.8543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aHOETpdVJgxEbhHpPzk9R6ooIwbcIN3IGRu5D7KOJa1A0yvXHEBgSG4d5W9PjDLVUajOYLyrKpi50iExDcQ0zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH net-next 5/8] net: dpaa2-mac: use resolved link confi=
g in
> mac_link_up()
>=20
> On Tue, Feb 25, 2020 at 04:36:32PM +0000, Ioana Ciornei wrote:
> > > Subject: [PATCH net-next 5/8] net: dpaa2-mac: use resolved link
> > > config in
> > > mac_link_up()
> > >
> > > Convert the DPAA2 ethernet driver to use the finalised link
> > > parameters in
> > > mac_link_up() rather than the parameters in mac_config(), which are
> > > more suited to the needs of the DPAA2 MC firmware than those
> > > available via mac_config().
> > >
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> >
> > Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>=20
> Thanks.
>=20
> > > +
> > > +		/* This is lossy; the firmware really should take the pause
> > > +		 * enablement status rather than pause/asym pause status.
> > > +		 */
> >
> > In what sense it's lossy? I cannot see how information can be lost by
> translating the rx/tx pause state to pause/asym.
> > If it's just about the unnecessary double translation, then I agree.. t=
his could
> have been done in an easier manner.
>=20
> If you're just translating rx/tx to pause/asym and then doing the reverse=
, then it
> isn't lossy, but if the firmware is resolving pause/asym according to the=
 table in
> IEEE 802.3, then it will be lossy.

The firmware is just doing the reverse translation.

>=20
> If the firmware doesn't interpret the bits, then why not do the sensible =
thing and
> just pass the enablement status rather than trying to confusingly encode =
it back
> to pause/asym?

I agree. It's unnecessary and confusing. I'll add this on the list of fixup=
s to be made by the firmware team.

Ioana

>=20
> --

