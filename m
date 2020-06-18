Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4A51FFDF3
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732054AbgFRWZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:25:58 -0400
Received: from mail-eopbgr40068.outbound.protection.outlook.com ([40.107.4.68]:7552
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727776AbgFRWZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 18:25:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObE8oN3yADzsUeWsRv38FrlnPpw/HD56LHD3JPPypEIRmM+azfbcqZrWNV+0kl7wQzj9gU7r2lW6+rjbL3Oij04WZDjcERgRLn2Ezs88QCUyay6NPBQve7MvKRzr4QUCoQuRWVYnnQtgAlI4pnAwRIczM4hRTrnKp844vtJUqBmmyX0ie/DD/eCKh9/BC43R543U43P28Cl30t3nl6j64bUZnAy4EV9CcWMRUHx96tXTh+BPEkCJwBBeuPbBbWKGOJPjKMZrKm4W6i8mVaCwRaM0wD2+g02cFQTObnZQ+6td6QZ9XctOEogO7cn8helX3Dk0LQ8lYxG4HBJjE3LiwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zq5G9sNDsThw6eZRZcU/zl/oikeQ/c0O6cqTZgRCIc=;
 b=LS64RyfY/lqWoEXI/yWOSv0wjMX2irxENAW9ln9HQsbbSCkNcH7n+RONggNVpMUdL9JUpGIZMAABzE3frDLnLL4owOMUsxACevyExov2QBMOLWxVSSA7xH7WDDEGSRLu5GEzqVKyHSfnQBaA2RILqs+SECd41t4XH2GmMFs7FrjoVKArCqA69zEXK/SeDpyC9UF62Dw4A1aoaKOGyaGGXAT9oka9xDx/DyhxDOtmPP2EXufaITfD6SJ8N82rXeWLo1WvmvTCTfaHfDlaormqszWvqVAHBZ4poZ2gp+SL2ScvRF4CHFgT2orFpJxKVH0LGj6zEUvLk9yrUsEH4KgBDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zq5G9sNDsThw6eZRZcU/zl/oikeQ/c0O6cqTZgRCIc=;
 b=OnbmNzb2JsCtIXA/4XPyQOHJBtiKQ4tjW3O2HQtmi1KdyonsqSmJ12J/Ji1Zmhq6BJHbkZr24c6IDnqlcmundeZ01SWKVF+3JUBsWphe3oSr2xQyyCj39MwEiQZfC6qhd0xwaTUOj0/QeZKF8maa4ep7Gx8DS4HoJZOzXMGaQ0M=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4877.eurprd04.prod.outlook.com (2603:10a6:803:61::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 22:25:52 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::1df:4c77:2e50:22d4]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::1df:4c77:2e50:22d4%7]) with mapi id 15.20.3109.023; Thu, 18 Jun 2020
 22:25:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, Ioana Ciornei <ioana.ciornei@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Thread-Topic: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Thread-Index: AQHWRb9sG63E3tXMlUqFs3t4gqPayg==
Date:   Thu, 18 Jun 2020 22:25:52 +0000
Message-ID: <VI1PR04MB56966EAF1429D1D61E57F90AE09B0@VI1PR04MB5696.eurprd04.prod.outlook.com>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
 <20200618120837.27089-5-ioana.ciornei@nxp.com>
 <20200618221352.GB279339@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.56.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 69c7ca34-19ac-409e-4906-08d813d68f85
x-ms-traffictypediagnostic: VI1PR04MB4877:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4877318B33D3CA126CED5AE8E09B0@VI1PR04MB4877.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aeGpgPAPYBw5ohIj3Yy/cGp86p5hVREW3aVIO8AEStln4neaN3lTscoQMFVKIPP/OMSda+fXngBe6AnrW5ZqCib9fHe6U8ba2Tx02v8kcfvProScqXQInQJy7q2T6SnQVsVJmVfXat/4H2J2MMz7hbEXwTMTJs7pgOaXLDznyASb/Y/Qr81ixIk/dsdZg5fJojlqpO2DRBUe8z9tL31Ik1EBP+FSU4e/ZmF7noUuxyHUJJlL8ETHHuVry1ifk8wq63mbeGyOFFVeSOJWC3ete4a+vGARo+z7RT1ccMb55kvvbhaMncoG/mh0FkBeMlYujFu/nqbF7Go4rirvOIayHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(316002)(54906003)(110136005)(64756008)(66446008)(91956017)(76116006)(55016002)(66476007)(66946007)(86362001)(71200400001)(9686003)(6636002)(66556008)(4326008)(53546011)(7696005)(26005)(186003)(478600001)(2906002)(44832011)(5660300002)(8936002)(33656002)(52536014)(8676002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: H75unEuMmMvvMDtja4zhAV2yXXvSVo4gqDMg/se2EAIMtUBIFxtfEBTxfL915TeDhKlbEZpmdj+umN2ZPNHL7AdFFvUkuJh5uIjqcBny3KMxFsBze7PE4VxeydjGyEosvxlpirNI/Y75eWS5lTMNuwDyqJ73Wk+WWeLvLjIB0bV/DMK/2YdsrvsXU8mjfw0hUniyMPEjJJGhbXHEjKYojN2Va/hmQoph45htvLd+Cqf+AgeZmtcjW4nGjBP0AxpUi00gWmn+xJUAupKwESm/bICr/FIobRJzpwOl5jLTUgR/0nvruuRjU5SYQJuYG6mqE8USPjsQbqLyGEMPdizWWC8pG/3Et9mTINYS2eypj4ilWY8pgNsC+DvDYh5tCrEQXPRTrvxAIiL6qBx1+neESCZOa8ommOucMYDUrymPvO2FWNxdVM4q/rJgaYMwHahaOpU8LRc3yG5//fFABl24EKbDP2IbF92Q7Qj+bwr4ZqI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69c7ca34-19ac-409e-4906-08d813d68f85
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 22:25:52.3351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1eDkA29Rg08fh+VEpyjqaaixXBvKc2ePFCS1VtNw1QigDIqx+RxNGB7agbed6dgLQCKMWiKvbnLQ9KLm87C4Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4877
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,=0A=
=0A=
On 6/19/20 1:13 AM, Andrew Lunn wrote:=0A=
> =0A=
>>   MAINTAINERS                     |   7 +=0A=
>>   drivers/net/phy/Kconfig         |   6 +=0A=
>>   drivers/net/phy/Makefile        |   1 +=0A=
>>   drivers/net/phy/mdio-lynx-pcs.c | 358 ++++++++++++++++++++++++++++++++=
=0A=
>>   include/linux/mdio-lynx-pcs.h   |  43 ++++=0A=
>>   5 files changed, 415 insertions(+)=0A=
>>   create mode 100644 drivers/net/phy/mdio-lynx-pcs.c=0A=
>>   create mode 100644 include/linux/mdio-lynx-pcs.h=0A=
> =0A=
> Hi Ioana=0A=
> =0A=
> We should think about naming convention here.=0A=
> =0A=
> All MDIO bus driver, MDIO multiplexors etc use mdio- as a prefix.=0A=
> =0A=
> This is not a bus driver, so i don't think it should use the mdio-=0A=
> prefix. How about pcs-lynx.c?=0A=
> =0A=
> In terms of Kconfig, MDIO_ prefix is used for MDIO bus drivers etc.  I=0A=
> don't think it is appropriate here. How about PCS_LYNX? I don't think=0A=
> any other subsystem is using PCS_ as a prefix.=0A=
> =0A=
>> --- a/drivers/net/phy/Kconfig=0A=
>> +++ b/drivers/net/phy/Kconfig=0A=
>> @@ -235,6 +235,12 @@ config MDIO_XPCS=0A=
>>          This module provides helper functions for Synopsys DesignWare X=
PCS=0A=
>>          controllers.=0A=
>>=0A=
>> +config MDIO_LYNX_PCS=0A=
>> +     bool=0A=
>> +     help=0A=
>> +       This module provides helper functions for Lynx PCS enablement=0A=
>> +       representing the PCS as an MDIO device.=0A=
>> +=0A=
>>   endif=0A=
>>   endif=0A=
> =0A=
> Maybe add this at the end, and add a=0A=
> =0A=
> comment "PCS device drivers"=0A=
> =0A=
> before it? I'm assuming with time we will have more of these drivers.=0A=
> =0A=
>         Andrew=0A=
> =0A=
=0A=
This driver faithfully follows the model of drivers/net/phy/mdio-xpcs.c. =
=0A=
Should we rename that as well?=0A=
=0A=
Thanks,=0A=
-Vladimir=0A=
