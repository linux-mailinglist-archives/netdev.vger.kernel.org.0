Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95020198B1D
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 06:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCaESS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 00:18:18 -0400
Received: from mail-eopbgr60067.outbound.protection.outlook.com ([40.107.6.67]:44512
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725809AbgCaESS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 00:18:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWt/zS8ZLU9E0hcPOfOxwGwt9JQgX/x79cY4TI7tyDc2/U14JjBKP0KNpt1081sfyGGn+ALo3RDuoR1DrfyP91Odtii75G6UXypK4rI2qb1YkVxmME6VAcC2hCXyW0mnFxEYDOp9I79xyJp805mKOa8K7p8BF3qxjyIBbJ1vOdTtUa62ZTM1cY78X7cxPx6YuIO90dfinWUKZ13EfzCJo2VXzA+X51H7dazwZGkyyNg6iK2/qRnyDyutHQe5OVVaWvYcpcsGlFCtHCnfsDs8s673Cw7URxXdrN58F5OTyPqIojjf2Ko2ExemKrFen+QnImLhyF/RerWM0UZD8MDVkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwIjb4FCBWO2lb+LYWrWtaUAF+9DvAoa1pJp4nndKHk=;
 b=XxT5QWEfUh+Be/yx1YbltIumkMrmRSbW4cA6iUkO7yfaSm1zwT7MmT+vj2GSRabYmL2Iz++ptknUro6pY1nFi4GZenJ6FFHTYcRKCqgDI61GbddbUy4+4yiU1yzZoceZQKZLn3ortsIlNpqP2mlmZBSchpKSImPcq6uusjCCU25JVdxqMejRG2cjmrLXNBXDBLzds5EeM95icygxQPYJjr+q9M+8APHQQatk/JZgavPrGzS8JLqifGywku5v/fIQclErCGC+x2Qa8Kll5TcKOowqkvQAS0chwJXI9cV7b73BsybB6o9Gidi2iJFzNFc6SEL4nS0tyeSIJ/JI8LESbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwIjb4FCBWO2lb+LYWrWtaUAF+9DvAoa1pJp4nndKHk=;
 b=d2b2GpYMYuN9RexDel/IAUd5JeZDpDqRQajNqqbwChizwZdUpqX6Sp+BMUTalV55pf92wlEuBb4BocUQ9TdSFbZDOR38iEzWavjosrWvkmWt9UO66Dxxpl872s7tmAu2K8R59AErr4+RkUypGU0irme0WoDRn3OVBl02GfJwi00=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (10.141.174.88) by
 AM7PR04MB6950.eurprd04.prod.outlook.com (10.141.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Tue, 31 Mar 2020 04:18:10 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94%2]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 04:18:10 +0000
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
Thread-Index: AQHV/qQWBIiKj5A/T0WD8BjMeGVxRqhXvRSAgADnAvCAALTjgIABSqMQgABMsoCAAQih4IAGMAqA
Date:   Tue, 31 Mar 2020 04:18:10 +0000
Message-ID: <AM7PR04MB68853D5057F34E5CF0A26479F8C80@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-7-yangbo.lu@nxp.com> <20200324130733.GA18149@localhost>
 <AM7PR04MB688500546D0FC4A64F0DA19DF8CE0@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200325134147.GB32284@localhost>
 <AM7PR04MB68853749A1196B30C917A232F8CF0@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200326135941.GA20841@localhost>
 <AM7PR04MB6885113954C96DFD69F2C692F8CC0@AM7PR04MB6885.eurprd04.prod.outlook.com>
In-Reply-To: <AM7PR04MB6885113954C96DFD69F2C692F8CC0@AM7PR04MB6885.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.68.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5523aa37-8719-4672-5d09-08d7d52a85f1
x-ms-traffictypediagnostic: AM7PR04MB6950:|AM7PR04MB6950:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB6950A505B6CADD6BA48D0989F8C80@AM7PR04MB6950.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0359162B6D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(2906002)(76116006)(81166006)(478600001)(66476007)(81156014)(8936002)(71200400001)(53546011)(66446008)(6506007)(64756008)(8676002)(66946007)(66556008)(5660300002)(4326008)(316002)(33656002)(7696005)(26005)(9686003)(86362001)(186003)(54906003)(55016002)(6916009)(52536014);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dvZ2eo95KjSL4WHcRJZzvlNNoSXE8HhaesORVq4f5XoPpFonTPWy4jxFBkCAVUCgau+xsETdi6Y8OLevqXHcL/mGdglJrFykFONKQTAGyIgxNB0X0VEEwOiMVVwf9nm6OOjA8BKJsblY1rRfzmef5FM2o8f6lvF0iLV4Jy36X4y4vkfbqHk4QHyAOoBamZYUMZbuWEz6XPM8o4BvewBt/hGiqbKx9BB2MwPI4i7QAcy/0PSoqY6QqWbNRcf/pB0wUNom9PUCMLc4ht59vKAEJoFfku6/W+aEowf8Q8FdSPblMOzdEXoA6DdR2aKmrCQcYujxSSI45bs8Bokt2uq4ViHcNj/iiQ0LWEHFUqsLXZ+D2ZSfNR0rWu2oFK2YkVTI0JUqCMpOrZwpXNtwUhavNlWilAgDqn17O6KRlcD0zfLhrJlqGp0A8YxzUo+TYVIy
x-ms-exchange-antispam-messagedata: gViaHSFnWhCHkEEbhIuKURNmeNC6aVzQkPBpkeRPyZqNzxd+imNieZkkIbXJVOCAp2H0t2G9b0DWu0yIZvw/b8XR1MgugJP5N5WOkaW6xU52+lIBkNrWBnqzji7IcylFSElFdAYRSc3SaYeCfq1A8Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5523aa37-8719-4672-5d09-08d7d52a85f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2020 04:18:10.8316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NMF09aeo9RGUHen8HLbJGzxoAFpAqkXLoyNeSeLRP80dAPunAF2kNW/1f/onx+y+nAnMU9eBD9MqFeIkrRMtqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6950
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Y.b. Lu
> Sent: Friday, March 27, 2020 1:48 PM
> To: Richard Cochran <richardcochran@gmail.com>
> Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; David S . Mille=
r
> <davem@davemloft.net>; Vladimir Oltean <vladimir.oltean@nxp.com>;
> Claudiu Manoil <claudiu.manoil@nxp.com>; Andrew Lunn <andrew@lunn.ch>;
> Vivien Didelot <vivien.didelot@gmail.com>; Florian Fainelli
> <f.fainelli@gmail.com>; Alexandre Belloni <alexandre.belloni@bootlin.com>=
;
> Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> Subject: RE: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
>=20
> > -----Original Message-----
> > From: Richard Cochran <richardcochran@gmail.com>
> > Sent: Thursday, March 26, 2020 10:00 PM
> > To: Y.b. Lu <yangbo.lu@nxp.com>
> > Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; David S . Mil=
ler
> > <davem@davemloft.net>; Vladimir Oltean <vladimir.oltean@nxp.com>;
> > Claudiu Manoil <claudiu.manoil@nxp.com>; Andrew Lunn
> <andrew@lunn.ch>;
> > Vivien Didelot <vivien.didelot@gmail.com>; Florian Fainelli
> > <f.fainelli@gmail.com>; Alexandre Belloni <alexandre.belloni@bootlin.co=
m>;
> > Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> > Subject: Re: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
> >
> > On Thu, Mar 26, 2020 at 09:34:52AM +0000, Y.b. Lu wrote:
> > > > Of course, that is horrible, and I am going to find a way to fix it=
.
> > >
> > > Thanks a lot.
> > > Do you think it is ok to move protection into ptp_set_pinfunc() to pr=
otect
> > just pin_config accessing?
> > > ptp_disable_pinfunc() not touching pin_config could be out of protect=
ion.
> > > But it seems indeed total ptp_set_pinfunc() should be under protectio=
n...
> >
> > Yes, and I have way to fix that.  I will post a patch soon...
> >
> > > I could modify commit messages to indicate the pin supports both
> > PTP_PF_PEROUT and PTP_PF_EXTTS, and PTP_PF_EXTTS support will be
> added
> > in the future.
> >
> > Thanks for explaining.  Since you do have programmable pin, please
> > wait for my patch to fix the deadlock.
>=20
> Thanks a lot. Will wait your fix-up.

I see the fix-up was merged. Thanks Richard.
62582a7 ptp: Avoid deadlocks in the programmable pin code.

I just sent out v2 patch-set based on that:)

>=20
> Best regards,
> Yangbo Lu
>=20
> >
> > Thanks,
> > Richard
