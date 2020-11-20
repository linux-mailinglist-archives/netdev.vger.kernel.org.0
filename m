Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9415C2BA67A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbgKTJq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:46:26 -0500
Received: from mail-db8eur05on2059.outbound.protection.outlook.com ([40.107.20.59]:30473
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727214AbgKTJqZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 04:46:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJuCzkM+5cAOVBDKMFP3bdGVQcCzYxQl8tcFiS1a5PfKHJntxohYooRpJbizpcZGDZf3aGF5Oj2xGYkaaIWtF/7l7eC1B4R1P5bLJNZzz2DncCuwGhVr/nCRD6HOGD065p808udEPNKlAxeXoei0Ye3lFI+YV1g059IiSfo+ICyHiMlpBV+0ohBFK/EsAXppUUS6ZmeHdAzF6HEF+sluenYzEt31WE04LAZzhlfwJKPW/nrOkl0VuLZdlqacKzlG9ngoh3q858pLAh+o/HbG10lebmZVuqEHgkubbyyZjcvFBzEGi4rz04P3xLk0C/GAGo4ggN+j69kcdrH211ZfDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NzUr8pnk7EDFrMK00EKH7C96fSaydV8wq+A0b4d8sA=;
 b=OvGu9h2lM5/5YuILAxL7Z6W3uyInEJtUJ2uSjciDF4hNydAOUUhIauz0DFp8n2W3QODW45jsXFj63PhlXFlN5MHyfl51pB5ById6mrDcVZ4ewEMiI1GMqThvjZv7hpssS+bggovmgRHCakFJ259IoaLclxKI7X6MeJLOolV4xFyYeN1WZ7gpuDSmYgdy8lKp/NyDDd33vl29wc7Y9UVtMckwABRTefklWflbhCTcfrnfi9TE9jn7rLxqsYLs5Ej8fDvKCkJP3XkKgUPTw9TOGMDfQcvR3jvjVsOyYzbgFo+PWxdPdjn2XC11XJ2m2D81QX7lW5f8pk5ETlhaHA8ktg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NzUr8pnk7EDFrMK00EKH7C96fSaydV8wq+A0b4d8sA=;
 b=aginkioEpnbnsSjGmm5BIQEHLwEl6BcFfoUyzelBw/VJJi+AXhVCEIojAJ1vXmMTLogt5dPh59dFjej6ZECygMX2rfq9YBEWe/CyKoRut+AFwaVAwnb8r5FTkbU4fXIkosXRappSO0DGRfGOOvZ7rrNRfLtD4d5LyqN4q/J8Axc=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4912.eurprd04.prod.outlook.com (2603:10a6:803:5b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.25; Fri, 20 Nov
 2020 09:46:21 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3589.024; Fri, 20 Nov 2020
 09:46:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     Joergen Andreasen <joergen.andreasen@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [EXT] Re: [RFC, net-next] net: qos: introduce a redundancy flow
 action
Thread-Topic: [EXT] Re: [RFC, net-next] net: qos: introduce a redundancy flow
 action
Thread-Index: AQHWvKn0LvIWftnXUEms3Hqujf7rPKnMro+AgAQaHgCAAAH+AA==
Date:   Fri, 20 Nov 2020 09:46:21 +0000
Message-ID: <20201120094620.5jlez4baxsnfxaur@skbuf>
References: <20201117063013.37433-1-xiaoliang.yang_1@nxp.com>
 <20201117190041.dejmwpi4kvgrcotj@soft-dev16>
 <DB8PR04MB5785D4586B8CB3651F427E69F0FF0@DB8PR04MB5785.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB5785D4586B8CB3651F427E69F0FF0@DB8PR04MB5785.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 46e854df-75e2-4d85-ab8d-08d88d39235d
x-ms-traffictypediagnostic: VI1PR04MB4912:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4912B071C1C5DD8712646C94E0FF0@VI1PR04MB4912.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vUxykLVcEiIDO9pzSNw0KHLkAh/WglEvx+ufsNtWnAxT0py3o76ZP1OA4JSA6ln8p0/Qt+fxLnbMbytxWciTne3kWVebwGtla0XzNM2WbDVWl5/NNpkAvTQDhgJSDYbLW2Epplpzrnkayhteuz2/ny0/0fJupr7P3y0xgLRlm+fRgfvUc2LdfWSNaFYn3gxdDiijk0tm/SpShHlAMgDtKQTRLWdhnaVIvH5DMHPlBmo5nW5RQveci1gOwoqYjLfQCtIgRv/GJuUaeGMkEzzACuIVaxNvM4ZgP2b0L3Sxy/wRwOJP3TBSQQgfHKPkRTDZ5nweIGR6wvKt4Lr35+UlxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(53546011)(6636002)(6506007)(8936002)(8676002)(478600001)(83380400001)(33716001)(86362001)(64756008)(26005)(4001150100001)(4326008)(2906002)(6862004)(6486002)(6512007)(9686003)(44832011)(54906003)(71200400001)(5660300002)(7416002)(76116006)(91956017)(1076003)(66446008)(66476007)(66556008)(66946007)(316002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: sYXhFpeIw7oT+L3wJc1sKAfDzAPjVdKUw92BqHxHauHRLlW1tbOkrlx9X+gp/hze979AyBqxWWTM2cPJBXyP18/X/mujx2uyWPS1yr9GZhWMoaamTNK980wuAldBh/PuilvwNFtOs3Tsx0338hkZApDy0wfAqtyV+DBPdvDD28STXH1sPzIBa+a5rGgVwxyCfEWR6VM/12zaqXlYwXtSRnwOJ2FLM3wLfiD5OSMMen/nqBrcGFxxJmyY79RPg6JQuzUzdXQfvEX7Z8ReNnLsvtiWctHmmlYgphLGfoPXRwBg6DfEi5pZTZ8Y3qFInFi/9UGl+AySivu7ToBTLbX+1Y5yDDoinz/CLjMfu8QdC/zpbD+VtIhmUWtHmdDCAcpl1Z9Oap/GiQsJo5n5Rp19s3YAPud2MqJ2uaBn5iQXKD9Eqn3Q8l7HCmFjf2Sg/WmJX+mhiUJusWl2N/JNfIwXevl3GRTFNMAbqofnu7Qp5W626Wm89wI9gqByyCJPVILY3axN5FWAUYOGKoXh+OIi4xz/fWTWl1jvP79pIiC6srFHLF+gDiyFgCLaTVH/ck3gzABc/AcfUTY2hxCWfiMb2POaPyBy0NSrc8nEQVzSVqNUXeuuqYjj27DsqCUwk9wvtcW35ICu3usOpOViPHbVRQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2FB4A81C0A9715429DBC9D5C3DCDACF5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46e854df-75e2-4d85-ab8d-08d88d39235d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 09:46:21.8079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t+PEWNdZ/uG5xwrbBl3WeDAvTSK+cWeZA5ZLe/SeiGnlbKmBuLr3GlkyrXjxyfiqhgudlDYFjdUsX3ZYadmepg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4912
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 09:39:12AM +0000, Xiaoliang Yang wrote:
> On 2020-11-18 3:01 Joergen Andreasen wrote:
> > I like your idea about using filter actions for FRER configuration.
> >
> > I think this is a good starting point but I think that this approach
> > will only allow us to configure end systems and not relay systems in
> > bridges/switches.
> >
> > In the following I refer to sections and figures in 802.1CB-2017.
> >
> > I am missing the following possibilities:
> > Configure split without adding an r-tag (Figure C-4 Relay system C).
> > Configure recovery without popping the r-tag (Figure C4 Relay system F)=
.
> > Disable flooding and learning per VLAN (Section C.7).
> > Select between vector and match recovery algorithm (Section 7.4.3.4 and=
 7.4.3.5).
> > Configure history length if vector algorithm is used (Section 10.4.1.6)=
.
> > Configure reset timeout (Section 10.4.1.7).
> > Adding an individual recovery function (Section 7.5).
> > Counters to be used for latent error detection (Section 7.4.4).
> >
> > I would prefer to use the term 'frer' instead of 'red' or 'redundancy'
> > in all definitions and functions except for 'redundancy-tag'.
>=20
> Thanks for your suggestion, it's very useful to me. I ignored frer on
> relay system. I will study sections and features you mentioned on
> Spec. If using a new tc-frer action is ok, I will perfect and update
> it.

Is replicated IP multicast (with IGMP/MLD snooping) something that is
going to work using your current abstraction? I think this is one area
that is required to work at a higher level than the level of a physical
port.=
