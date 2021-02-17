Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F68E31D367
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 01:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhBQAYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 19:24:41 -0500
Received: from mail-eopbgr1410138.outbound.protection.outlook.com ([40.107.141.138]:16067
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230079AbhBQAYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 19:24:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aaif1Sgb6oENICDppW3S1VxRlv6IlaPlax4rXXhIzKN0FrDmMY+RXDFiKPDEgAVR6J7syaE6VV+rk/BUdr1nfbK2/TyZUKpXWMia0e22g0iIuO2qar1KKXlSR39k6RWvlt/VFRRrLAXjWrS9JWd1wKMPE5+pqgMUrGB0JASBTYVZcxX+RcK2S5vRlmQnd3s6xBMgptxTajPYOuT5XNFhEm6HTdu9L/t8T5duGHxtIL/qk9EfATiq6U4W0EZ18wVmjV97Q1kw+2BElca93ZdA8UduhFak0JG5V3Cx7wzjB+6JI/VssDmsLAGPfBNJCSyUFLA0sjD0Hq6o9MjDDwx9UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qO9r2Dg5UM0RHN3z0hGLed91Bk6Vo9ZyojBnn4T5ZUM=;
 b=ZHOZynpJTx8zIwDBgEnOxc8kxK+D9x+ClXkN2qjHPkzPEcyPf0N//JGYO2IEY8Sy7i3pd0b0Nbg90yYA9zkwI7zvg0TGVu85MFXls9SzdFnxSqRmUh2aBd7R5SIvqjJRpVDSxZGjhksHKIumlJLU+5+G2pNYq7yUwuM2KiMbajm67auHb5BBY2tVXlZyyvIjr/dnN2Ig1gMcsValgnp2u3MTHY6Vvuo5PjQ5Kfa2SSrHLQzRNyP+MjhdFKJNgnrNa40HZ/MpyC0UTOhx+M3X5AuE6vT5JAanpnOLmZusAEaZmAj3ZrvAq0LbXQFZcUmNWYmNvSQJM2Mhsx0CKGfILg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qO9r2Dg5UM0RHN3z0hGLed91Bk6Vo9ZyojBnn4T5ZUM=;
 b=HcLOSAfzNJ2cqOOWbm6laK+DKIdDDZiPVmymEswLPNlja74yrPdzkIjOZftI2T8XyBNNh4kPamtOOoU1O1UMNqm4PW+s8IDgBs7Rt8BARZu+mIbnln4LDObVeh8GF8o9wuSrmBycbizeEqkIwd+bzgzImL5MsT9RftWzyYg0VN4=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TYBPR01MB5405.jpnprd01.prod.outlook.com (2603:1096:404:802c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 17 Feb
 2021 00:23:48 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::cb4:9680:bb26:8f3f]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::cb4:9680:bb26:8f3f%4]) with mapi id 15.20.3846.038; Wed, 17 Feb 2021
 00:23:48 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
CC:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        ARM <linux-arm-kernel@lists.infradead.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: manual merge of the net-next tree with the arm-soc
 tree
Thread-Topic: linux-next: manual merge of the net-next tree with the arm-soc
 tree
Thread-Index: AQHXBAh+B+TipWzLUEKtUb6Ddgfgl6paq7qwgACehICAADMTEA==
Date:   Wed, 17 Feb 2021 00:23:47 +0000
Message-ID: <TY2PR01MB3692AA4A88C27C2CBF2BF13CD8869@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <20210216130449.3d1f0338@canb.auug.org.au>
        <TY2PR01MB3692F75AF6192AB0B082B493D8879@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <20210217081739.6dfac3ab@canb.auug.org.au>
In-Reply-To: <20210217081739.6dfac3ab@canb.auug.org.au>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none
 header.from=renesas.com;
x-originating-ip: [124.210.22.195]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a28b6b99-c12e-4bcb-43cc-08d8d2da4b7e
x-ms-traffictypediagnostic: TYBPR01MB5405:
x-microsoft-antispam-prvs: <TYBPR01MB540550E355EEFFA3CA4B2D51D8869@TYBPR01MB5405.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N0UB/w5RDdAl/aHizd6o//TidetekQsKSMSTebEC8EY7B+oU1rB2E0IR3c582u6a57F/+lxY2L4ZYkAr92IEpMRVOIUIw1E+eWptEzh5vTzaWnbedT3BGPGtOMwV654rz6ss4+qREx71SA9EgG0nyZV2fTFICf8GUSHJPPho2mvkZij+MyPilcgXi1KGtm40w31ys9iL3+MicUHEbJbz1JZ3LjVk+Dl5j/CPSvaI14umivPZ9ZH5fACCReGtVHDfSxOxn8t5tCgDcKA3TapaQ5fUzRpOeNRa3TY2A4oz3X0icHNkxkQCRlA5hQblndLSRJBOW/n10QljI4ziMy8rPpvduLdUjHkD7nrhB0xpsmX1q5wLIOWGTcj7Vg8K+7wx/9hq6jwIbIiSKaCowwYJ/HUqcVn5OJeNjcXXLGX7BF2eafzR7yzYaRlbcw4Jc0+sd4/cVTr/l3OEted6zeCzhFvOa1w4g/+szPNfndZxyHn3C8nLAXyTA/XzmHhzgnWW7mbFAx5McuF18ORVp33mgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(9686003)(66446008)(478600001)(5660300002)(2906002)(6916009)(7696005)(52536014)(66556008)(8936002)(33656002)(54906003)(71200400001)(8676002)(66946007)(66476007)(76116006)(55016002)(64756008)(186003)(6506007)(83380400001)(86362001)(316002)(4326008)(26005)(55236004)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?xzj/X6OBIS5yaPDQ1ah/vjLiMGL44+SufarQj8EKQLh9zIGCe6XT9f4Renyo?=
 =?us-ascii?Q?5TVJjHDuhGyYtYLQXDGaDP7k/ohC/pd2AFBPbxmObcoBujkCJ3L73+T7DqtZ?=
 =?us-ascii?Q?j/hVeOEyknF8rSZ4UoJqmHwxaz3IzcDdG89Ov53MrhzyJWIAsEnwT1Q0Sugd?=
 =?us-ascii?Q?pt6zGEpVGAJ+iPNlBnjCMkk5wS9Qtmapi3TDHmzpfMUAeCu1X9sZm0DTKB8Q?=
 =?us-ascii?Q?7A5e+U0wlc9gwu74nVIu7ETGvxflVWCJEymIvdouSGJaPnBrMmjL7Q5eJjru?=
 =?us-ascii?Q?sduglUHYYg5e/Ty1MPfcKdxH+E6ifQ+iqqkJTnbH3CQIH24zetuHcDA1Ml7L?=
 =?us-ascii?Q?knE3v/mDHew92QhypKfDUr19/lkGXAiqihIiR4ta6dAQk3F83BZAx6r/S38f?=
 =?us-ascii?Q?hgK7XYFvrlm7foEX3qNiW0ZKx+QhfuHF0GdbOVM6/n/pujcys/of0wNTREeI?=
 =?us-ascii?Q?kbWa+S17ddPEst2VZ257SSbXeHTbMSRm9Wuee0gVieEIYVoa+HYQZDwblhBE?=
 =?us-ascii?Q?EyM8xv7tr5Y7p3FV0SSYeAX5WMmDZeRQbvsaW4h+DFH3aNsHmr4W6Jdrci0q?=
 =?us-ascii?Q?Pf7K93FivU7KNkZWFFs7FR7P2m+yg4UM6vkdhuRra2ajqm3fQ6lx1RqyH7d7?=
 =?us-ascii?Q?8x8wikVDQIoljFguzMEKMj6p2mBT1c2+9IdGHdLiQzAdJflJZdgrje38hqzB?=
 =?us-ascii?Q?/MHx74Apys4OZ1Hmx4aqipVWWL2IPt6NIMeZgQg1u2zU7/pUPG43/DtK2/lD?=
 =?us-ascii?Q?738QI5q9ERSV6tunkfbpwHyx98UaT6h97l4O15b9+uh4VwUz9iC4YfKbOkQQ?=
 =?us-ascii?Q?VwYTN9HXKc77/K4YJyvfqCcVbxSFyrTLizj9vX/8THfwD+8UfsY6+RVmOKen?=
 =?us-ascii?Q?d3PL6yDgfCEm17DNuduF2UcL8uUwhv/lPJAJdpLdHT6Hk1OZyNQ+lc8A/60e?=
 =?us-ascii?Q?opFNQNtM212zyB4q806It1wpKS4GDfYWO817MSXsjVC89kKKeQEPoh0X/PfZ?=
 =?us-ascii?Q?/+05+dkwVbWR4kapjjPEiUb9lm4PWNlym8PP7ZV6Q2nrVxWcu4Y95JSKphiO?=
 =?us-ascii?Q?swdD0AiTzop+SRhVLuCCedlAW/grMKnrge26Z057dvCWqR+0R8kZhq+M6aGY?=
 =?us-ascii?Q?WpdojkAxszHMjXVx8KsEFZLPlB9j8lFcXrbiTYDs6hsJ/UfBuvy+6K0K6dZV?=
 =?us-ascii?Q?cLrj+kBULkUAL5oTeX4Ne3tLqAAc3BIBhD/fTMBvv9M3PE1Oqfvjtnrz+3Nw?=
 =?us-ascii?Q?mmqNV1DfhZXL16NrdWRjBAvAlSoZpfngOlLzDdC4PDyFtatjo1Ram9mVlPHe?=
 =?us-ascii?Q?OGW+HpwQgvJ+s3QZuERi1Rl5?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a28b6b99-c12e-4bcb-43cc-08d8d2da4b7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 00:23:48.0167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6xWBwComxI7DnCc9Vm0IJG96o6SYpSV0MA3ZyOLXHJgiUT+iDKY1502pbsqjTQnkb/Ivmo6IeRMpk4l143Qt9GslaOn96aAUNYPccGIOOYtOa8Rh9gJ3R/uDtwRN6rXV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYBPR01MB5405
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

> From: Stephen Rothwell, Sent: Wednesday, February 17, 2021 6:18 AM
> On Tue, 16 Feb 2021 11:53:56 +0000 Yoshihiro Shimoda <yoshihiro.shimoda.u=
h@renesas.com> wrote:
> >
> > > From: Stephen Rothwell, Sent: Tuesday, February 16, 2021 11:05 AM
> > <snip>
> > > diff --cc arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
> > > index 2407b2d89c1e,48fa8776e36f..000000000000
> > > --- a/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
> > > +++ b/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
> > > @@@ -42,11 -42,20 +42,29 @@@
> > >   	clock-names =3D "apb_pclk";
> > >   };
> > >
> > >  +&wdt {
> > >  +	status =3D "okay";
> > >  +	clocks =3D <&wdt_clk>;
> > >  +};
> > >  +
> > >  +&gpio {
> > >  +	status =3D "okay";
> > > ++};`
> >
> > This ` causes the following build error on the next-20210216.
> >
> >   DTC     arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dtb
> > Error: arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts:52.3-4 syntax e=
rror
> > FATAL ERROR: Unable to parse input tree
> > scripts/Makefile.lib:336: recipe for target 'arch/arm64/boot/dts/toshib=
a/tmpv7708-rm-mbrc.dtb' failed
> > make[2]: *** [arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dtb] Error 1
> > scripts/Makefile.build:530: recipe for target 'arch/arm64/boot/dts/tosh=
iba' failed
>=20
> Sorry about that ( ` is nect to ESC on my keyboard) it will be fixed up
> in today's resolution.

Thank you for the reply! I understood it.

Best regards,
Yoshihiro Shimoda

