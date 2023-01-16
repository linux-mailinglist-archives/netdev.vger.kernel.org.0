Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA8566BAC3
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjAPJod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjAPJoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:44:06 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2055.outbound.protection.outlook.com [40.107.20.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFF03ABF;
        Mon, 16 Jan 2023 01:44:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wv67b+30s7up+C07L6mbdinnh7nHoUC3r+Pz1W70CIzO1jHzpB690P6uWT3ZlqUQrRN5d1G0PwUg4Lgf7Z4t05Z5NXJd0Xvur6oAekHCmV5L8NNi5VEUdT2smJ0cgye2jBRcF9LhMDIcHJpbr0YZ7sbJRsbLyt+aKfmLlprdtLS4aTpHaHBAQAAgMHjzToNqUYCPYPivcQZeiAFn7tZz7HcwkOiNTZolF++BARk7cM7ceaGe4UOoPsYzTl7VQetCc84ACB/JIT/vpBfjaV/ETdCL2Gn2erietrLSEsOvnMBLICuEENhYdLboWvhIFuUjAmbKjexMXYW5k4GXcWNeFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VZdgzEFyjdmT3xX48hqZ93tEyyy9mCKwrrPiC+CTIxc=;
 b=SzrdeQq5xrGTP9YFzi/pBCiCsusiVx9IWvZ5RZLML1nKJKfSwW58Swy6z5559sPUptV9wkjGVNHVZGtOAeF5QmAtonz2JQryrqLCOeAueoZnh/o6ImU4Pqs6cyzjTjJgEtfP7cNWx9i4SLXtAqkYuknuqR+1dK80u+dCowCc24RvgPq+3peIEVtMSWmOixXRWn8hNmMtCV+LVa4FI/7Uaofu+fX02fpW/uvoSbmWVRpbrRDmXXdJhJBCXZmofItUGUNokMK76WzREieyuDufxfdGNfZ9B7qWnH+9Rynu5S6x58ijJ5EAYCfLF3/AjStMs1tdzAqg8R2Xszw12S/lyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZdgzEFyjdmT3xX48hqZ93tEyyy9mCKwrrPiC+CTIxc=;
 b=Lj/f1cx/rIACs4cR04yoUf70xQV9TQqxIUdky3WhLhRrhtZzEED9ykQEU38AM2B9ipbfhrpAC5iF0og5TIAmbE67UVdM66DCMG/Ar//7nJYJWduneHO/YsS84i5wjysNPrjgVNBkPI+jQM8lrH4mYIfqJFLbSGPuTWIz2l7wHMdTNFMNadCvwYq4HeYA2hMVbNbllrwZiZFkssrC+w5jJhw1h2hkYtCdOH56Mv4T+WFVbzm4VQzLlGPYXZvhUEU3u95vcVPVdQgZJXs2tXTz57DMe+6Ujum/54E2ZGQMC3gjew2f0bKgmzpR6kSLT4gh3453NTEFdFN9jUiTGcPIRg==
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AS8PR08MB6360.eurprd08.prod.outlook.com (2603:10a6:20b:33e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 09:44:01 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee%5]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 09:44:01 +0000
From:   Pierluigi Passaro <pierluigi.p@variscite.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Pierluigi Passaro <pierluigi.passaro@gmail.com>
CC:     Lars-Peter Clausen <lars@metafoo.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Thread-Topic: [PATCH] net: mdio: force deassert MDIO reset signal
Thread-Index: AQHZKPvgQPO0npisDkSvgN3jEdgJF66fthyAgABQ/YCAAAm5gIAAG3CAgACcr+s=
Date:   Mon, 16 Jan 2023 09:44:01 +0000
Message-ID: <AM6PR08MB437630CD49B50D66543EC3BDFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch> <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
 <CAJ=UCjUo3t+D9S=J_yEhxCOo5OMj3d-UW6Z6HdwY+O+Q6JO0+A@mail.gmail.com>
 <Y8SWPwM7V8yj9s+v@lunn.ch>
In-Reply-To: <Y8SWPwM7V8yj9s+v@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR08MB4376:EE_|AS8PR08MB6360:EE_
x-ms-office365-filtering-correlation-id: 3bf54b31-6096-4cb7-9944-08daf7a632d1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +unKlZXRveuA6NidgaIfjdR7+mOLVootixO6uDzs8wVx74WfHzdlrrG5Qwj5ixzLBns7AmpM0pG2+786LJYgzc5OjtgzvhUNQNgsjo0Ybi2ZT2tQJnNh2BswqkLeHyQdDDNiEjdE4eloCuy32ko9WJOMBq1Efl1a47efxgrVAdkkncRvV5iBL5yLzGc51Y+06vwAK3MeGgAlNLReg3taAumRx4PSELFHUor+mHk4mBUXz1wDPDIzljOcTRxwYfVgShVqCs63wvd/Y78k/cVuQTlAY9B0G/znJk7cGH6neajRo2SD2kt17yhn3Ph8ZbCvgN8ZNvoVoS7Ogl4rWMaLdptV28Pjzr1oMYkl8N3E6R+lI6SipcSwR30GzbPU3srqlSl7V9ADVkHC1V9YGWxGVsvSEGyLH1+dYRHkikuhmYS/m4GEG2FJjm7lbbWPEsbctITgEhDo2yJ43Zcdnr6T4stcZL8D5glJsbjGmhGXQojR/BaDliEt0yG4dGgV1G8pqg27SXFJNJNnRKowzCwrf+roh5hr14WVzHIiVYauUo3xXOLP94Aeah6zZKn7Lor1Pso/UqlullTsIULPgQoE4rFSlRlN/IXHW6kIzid7Q5Pvv6toZoduAFXG0zQz3hKaXSA+sZoYshOTA6L8bqb05BJciCi9WxUz/+6tLa+4NfhF1bJqU6adE2I9HnVpzLv/g4kWsRIUcMVsmZdpuVinbTvD7uHt5BsPPwDG5mOs+NQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39850400004)(366004)(396003)(136003)(451199015)(55016003)(33656002)(66556008)(4326008)(5660300002)(66446008)(91956017)(76116006)(66476007)(41300700001)(8676002)(64756008)(66946007)(6506007)(8936002)(186003)(9686003)(478600001)(26005)(52536014)(966005)(7416002)(83380400001)(53546011)(107886003)(110136005)(54906003)(316002)(71200400001)(7696005)(38070700005)(86362001)(2906002)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?BVLGsofk1WdjQAfJ5BfAAg/6Y6x5z9fWP6p1N7/8McFi7IU4tGqclhptId?=
 =?iso-8859-1?Q?FwXoX/Wbl8CsJqnRL2oNLi493i47ctRvOB+CzmOFRECvfewk/rgr5p/Yof?=
 =?iso-8859-1?Q?0eVz/6xUsq6cYF259TbTQrW7pijRkzznsCI53ESdvR5Pn1MOLFU4PCYHLo?=
 =?iso-8859-1?Q?KfIw15M7aMFcZMIFDJFvNropK8xGXUyJHcFDvyyanmTrSXxTWIoQjjhSEz?=
 =?iso-8859-1?Q?a/A99EC3Ef4w9+GS5nvtZCITlKgVoUXOZfUCPgmSOSb1tR5cLZdHPBj2u8?=
 =?iso-8859-1?Q?0jpSiF8hVrh0dizFA2s2MShCMW7Kj5tzeW9xBQnMaNGz5aKk9ns6aJZYHZ?=
 =?iso-8859-1?Q?zGugpRd4bA14EN8d/SK/EpjN3Ia2pWQV1qXRUWCxcUUI9qT9GjMX5l/d5g?=
 =?iso-8859-1?Q?im2SGVsRZIl9ZzBsbqWdQl5tJxAfn5yLk0EWMF5qTTrjtzbhFTH40QZcvT?=
 =?iso-8859-1?Q?QBJBCe7kP0NefpQ54n2DkfuinR4E9iCq/zifTxXZJqWCUOf7NLzLpGn5tX?=
 =?iso-8859-1?Q?aHczwKwOgFz3zfjfH4tIEoYsJFxmjlFQigoZ66B0Kp7OlyiK8p4K7wgO6/?=
 =?iso-8859-1?Q?ocAjiOKdksbbkxZIc2K01kdip3pBL3NpcUFu8yZwlSwIKrZQsVow8ByKl4?=
 =?iso-8859-1?Q?SJYoC65nOuqCR8VghrSRw9uIk6feqZfVWsqBibgY/WE43BcI0n4j2NH7Ue?=
 =?iso-8859-1?Q?ZbTb8o6yL/KbenqomcZqAfO/MWIJPlN8YWxdWRa7OiMIQizEK7Wh5r80QZ?=
 =?iso-8859-1?Q?0nJMqFGxPYm5G6N+a28/dPpSgb3mfBzi2G/bAyxITle2CzDrppUGo8P967?=
 =?iso-8859-1?Q?QVI21a5XC9+L35/28twuU1cigeuPJISbceaaGsm2LIb9oUAuZaS+Ee0BEq?=
 =?iso-8859-1?Q?hJ9ij6mz32701AXUkQJdY5jUgKHX6xgUZnGDJaPig/R7p8C8bRU/eZr4ry?=
 =?iso-8859-1?Q?KPEiYnZlV+qOyK3H1GbhxAp+/V7CUr46NZG0D0sBsnhGMHK8KoiZd632KJ?=
 =?iso-8859-1?Q?bQyquGTS6muEkOY/74JmULQ3ALIr1/UsfSto9BzfTNOarimHeOahENG35o?=
 =?iso-8859-1?Q?NDNWKfToqxGQX8qFI0Fkg45md+M/PThkL5A7GhfmWIf7YXb4fecYivzvhj?=
 =?iso-8859-1?Q?SB2GRAYsGXJeQmacyo156ixaaBA5FX+D0Eiehu6mlPz1EspuoVqzhYT4cj?=
 =?iso-8859-1?Q?XeXWknfYW7JHnwFy4Q3wZsqibCRIF4FN9HzZiJJ4+oHMCDcDNB0SwUzlCZ?=
 =?iso-8859-1?Q?hpiIpd4MVJriDW/a4MTYNIiRukMz1yfSV+idh2uNDfK5ppSYhemGB4jpER?=
 =?iso-8859-1?Q?4rB2tLIMyXL52RLHfopPf5KB7HC5Z7IissWlpKJQhm/lRCRmbRTp8hcVh1?=
 =?iso-8859-1?Q?U2BuY8WhvFpSsVfesUCOB9vIbG4oGW0a00XQBlR38DYsySoLIvncgwR6wR?=
 =?iso-8859-1?Q?H9S5wglmXfIALD0/xFuY5MiBuEsGoBgnYCL0D2RToZo+qB84amamcM9h0Z?=
 =?iso-8859-1?Q?ZAqtoG09l2pRX83nJ4EjDuMSqgkbZTv2zMlOwmrFOJ7ZB3kzmUi8ejqdfs?=
 =?iso-8859-1?Q?cLJiJpcbYrIP3MJ/MpBRWVLzsrn8El0eroeM7wVYcTcq16SJ3JBISVfbQH?=
 =?iso-8859-1?Q?nQ6NoYzPNHmScCYmoMI2AAWK743XPcRxNa?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4376.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bf54b31-6096-4cb7-9944-08daf7a632d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 09:44:01.5106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E6G1nbb4R1/EThExuwucA1rskLuXVn4k4k9Ov+AMAQjLkGudDIE7FHRtg3+MfRXlWrRN4qJHGSDt56BDcYci9uHoGsY1BXP01PctUCRhBzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6360
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 1:11 AM Andrew Lunn <andrew@lunn.ch> wrote:=0A=
> > IMHO, since the framework allows defining the reset GPIO, it does not s=
ound=0A=
> > reasonable to manage it only after checking if the PHY can communicate:=
=0A=
> > if the reset is asserted, the PHY cannot communicate at all.=0A=
> > This patch just ensures that, if the reset GPIO is defined, it's not as=
serted=0A=
> > while checking the communication.=0A=
>=0A=
> The problem is, you are only solving 1/4 of the problem. What about=0A=
> the clock the PHY needs? And the regulator, and the linux reset=0A=
> controller? And what order to do enable these, and how long do you=0A=
> wait between each one?=0A=
>=0A=
Interesting point of view: I was thinking about solving one of 4 problems ;=
)=0A=
This problem affects all the platforms using the reset GPIO without=0A=
ensuring that either u-boot or the HW put a pull-up on it.=0A=
In our test, the problem is reproducible simply setting the reset to 0 from=
=0A=
u-boot and then use the GPIO reset as designed in the MDIO framework.=0A=
Is this approach=A0reasonable or a comprehensive=A0solution is expected to=
=0A=
cover all additional HW actors (clocks, regulators, ...) ?>=0A=
> And why are you solving this purely for Ethernet PHYs when the same=0A=
> problem probably affects other sorts of devices which have reset=0A=
> GPIOs, regulators and clocks? It looks like MMC/SDIO devices have a=0A=
> similar problem.=0A=
>=0A=
> https://lwn.net/Articles/867740/=0A=
>=0A=
> As i said, i've not been following this work. Has it got anywhere? Can=0A=
> ethernet PHYs use it?=0A=
>=0A=
> =A0 =A0 =A0 =A0 =A0Andrew=0A=
I'm not that familiar with the article's implications, but it sounds like a=
=0A=
partial redesign of the framework is needed.=0A=
I'm not sure this is the real point.=0A=
Let's refer to I2C/SPI/USB busses, the sequence is something like=0A=
- probe and setup the bus=0A=
- once the bus is up & running, start probing the connected slaves=0A=
Apparently, in the MDIO framework there's an excessive coupling=0A=
between the MDIO bus and the PHYs.=0A=
I can't really understand why the MDIO bus must check the PHY presence.=0A=
Other busses try the communication only while probing the slaves,=0A=
never before.=
