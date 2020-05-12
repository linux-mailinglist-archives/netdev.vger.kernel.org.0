Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7421CF15A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 11:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgELJSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 05:18:04 -0400
Received: from mail-eopbgr40087.outbound.protection.outlook.com ([40.107.4.87]:34178
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726024AbgELJSD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 05:18:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yd3ZqG9SIIsjxbsQiLNQWCS9s0HQiEkrzVDjo4+t18gwF/uFnrEG3rFMKBtsXvTOVZLIQS3VShvdnNzjoWKp5x8JT2QJLQ/CBiThTQJYAVJCwpg9I6x8ljLDiZ+cNJUoadHW+FfXZ65UaTB3en+7FnUjDwQZ6crq4TVAc27wly5zPqrECdFbc/c6LcMbkFxyct9xCaLuKmCZ94IQCiKdy/no62wZ/HU86p7F+OQDEUQ+7rrYoO608dpayCz0SMv8mS3I5VAkbMRcBpi/OvV2GTiNGnpA0UBsyMiMN394tgQI9mo8WnJb9JIAIHYtic7Phb3TMMdac5Li9tXTuZgtXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+YnzC1wKwxqwILfdPws/UHRIB5flu6VMxJn/+JRJuU=;
 b=HdWH5huYRxXkLyE+Y9eSJmSPv8j1LAKWKViEMQY4Ot1i1YX6iM49oDw2cxPOT5pE2F9HSQPMh9yyFYM95L0NGdqfZHWkMVXNu59LQMy+VVI3BsdneXfZQCFzOW+4tKTIAdceSmE4FH7a/WEfucS6bsbq8+USNb1Fickbx3go8PS0P91ke5J7wjMyu5wBe8qPB9luy5kCiB67JmB8V+Rv1QmBsDaUCRmJmygL3SEOw+IVhWtLSTaR/IfxuylSc9qLasMkY9dp34pilIxV9ySA8xdLqCa+N81srU+BO+rHpieJz2eS5jlYL7f+qO1PRtkwJ443vhKSEwfGBWrmwxNhQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+YnzC1wKwxqwILfdPws/UHRIB5flu6VMxJn/+JRJuU=;
 b=BpTRtOv3lySMh7WNJpuc1WkL5jBqYINwgXK/52rFJGSCiRgfQOppALAhc2FhsOBcvtYAZjGPyDptk9D/FvJh05jRmL5xX7FW3S54nF80mG5zbkB5yS7aK0l6L9OZ9VbSzVGizXraQb0KVBWN6qQ3wOpqXhj/Ch+u6515Nj5mNgM=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB8PR04MB6811.eurprd04.prod.outlook.com (2603:10a6:10:fa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.30; Tue, 12 May
 2020 09:17:59 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::c898:9dfc:ce78:a315]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::c898:9dfc:ce78:a315%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 09:17:59 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Subject: RE: [EXT] Re: [PATCH v1 net-next 3/3] net: dsa: felix: add support
 Credit Based Shaper(CBS) for hardware offload
Thread-Topic: [EXT] Re: [PATCH v1 net-next 3/3] net: dsa: felix: add support
 Credit Based Shaper(CBS) for hardware offload
Thread-Index: AQHWJ1fQ0aW9GYkaGku6h57iU7QcdqijrlGAgAB9cIA=
Date:   Tue, 12 May 2020 09:17:59 +0000
Message-ID: <DB8PR04MB5785B9263290981AC1AB6A0EF0BE0@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20200511054332.37690-1-xiaoliang.yang_1@nxp.com>
 <20200511054332.37690-4-xiaoliang.yang_1@nxp.com> <873686rkte.fsf@intel.com>
In-Reply-To: <873686rkte.fsf@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b025d2ed-8ebc-4bc6-ab8c-08d7f6555d82
x-ms-traffictypediagnostic: DB8PR04MB6811:|DB8PR04MB6811:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6811F5BB71FA9D69699E8ED6F0BE0@DB8PR04MB6811.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0401647B7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4L+SO1U9rvlqvRYSLMKJigaWwjyfQ1nOfY8un+USydkCmamCKmpVGr1nuxHnjvul77EaE9B3pWlAl7h3Os7PMgPjI0JkTVGYUwfjG+BDbnRtPS4q1GnSxlXkIhFIKekDZLV6b1XVcH3A0gU5qJ/iRzc/2hnP0Myq6jTaqYKL/xeZUNyTXoxK2V9c4VxYfWOGTXgwr0u5XvuYXPpb5QapjxxfKMU0rR5KKsCwpjl0Ryf7HxgA0Uj8GgxfohX8hJBDTwkURUHcY/iCtGGTchRT5cH0NZBJnWq1N6n5S+/0x4l/6rgdibekZNIS7oBhyjvl6tAsuRHjtqwn5i2SZzACA6j24qBcUWB8RCDUEXbKaVk6Q7g891TXyT2YOhl1qpWZcaXvDvYddEwOANb7s5LesZuIdBIhMDsjxfwya4gxPoSvmzjquMcawtWG+m2+Ec3kvgMqAC7j8Yuq/n1HPK9+KN6mUL+bQN1C1kv9hCquS1hg3MUNwejO54QaXgjCjB8I4U1ntAf12TCY9nZgGnlwUO0SE72u3t5cPW/IVIyhNjw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(33430700001)(110136005)(86362001)(7696005)(316002)(33440700001)(9686003)(55016002)(71200400001)(66446008)(66946007)(76116006)(8936002)(8676002)(66476007)(64756008)(66556008)(6506007)(26005)(4744005)(7416002)(33656002)(478600001)(5660300002)(186003)(52536014)(2906002)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: BP9EnVCLO8BB/VaClUkCP6qX8Jo7O+8qHmNWk8JPUZmipgWcJyEh4aHvWR2M3BMWwhr/XbpYUVaGSD1y+z2lWmOfvbqqjt9LygNHiiQFR4ujzvipii5ecnu56chSeg9xKhuEePIGnO/C/g/koza1LMrkWCwwa5aPkVHo7WLqbrJxwgoIlYkihFD62HK5EB6OPlJ6876dCL6ELmgfd8NC/gL4ZLOLOWftrwdZt3zSNEjCbUb2RxMHMLcBN9MX2aGYRYPs6edqBj+fiSuwugthTYRiTzbMzEtNO0e4ArNXFWsmHMk96TRz1ZKNmbuhRfz6AXoXqN8Fm298JNr2tgyvav2gK1QtT46VRf9joI2uiIBRqXWbq4twrFpquK9Elx2BzxByyp7YajYHXiVFe3otb1jwxjGXsE0ObYaC6J/hwaMpmirMWMTfwqH4J1KGoweHX5cYc620JHKDmO7RclSTEVKhywtYJhyPGJOiTMB0Yxk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b025d2ed-8ebc-4bc6-ab8c-08d7f6555d82
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2020 09:17:59.6143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f9ORB11xjEUgaJJFkBjtu8b8/rmKKT1FmyuxHHaO6kNeNn6Fvpl0gU1W42GyLi/+QN3dezaei5OQNhCzdDM/xMRysIzlaKzUniWhBAfN3W8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6811
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,


On Tue, 12 May 2020 9:42:23 Vinicius Costa Gomes wrote:
> > +
> > +     /* Rate unit is 100 kbps */
> > +     cir =3D DIV_ROUND_UP(cbs_qopt->idleslope, 100);
> > +     cir =3D (cir ? cir : 1);
> > +     cir =3D min_t(u32, GENMASK(14, 0), cir);
>
> Please rename 'cir' to "rate" or "idleslope".
>
> Also consider using clamp_t here and below (I just found out about it).
>
> > +     /* Burst unit is 4kB */
> > +     cbs =3D DIV_ROUND_UP(cbs_qopt->hicredit, 4096);
> > +     /* Avoid using zero burst size */
> > +     cbs =3D (cbs ? cbs : 1);
> > +     cbs =3D min_t(u32, GENMASK(5, 0), cbs);
>=20
> And please(!) rename 'cbs' to "burst" or "hicredit". Re-using the name "c=
bs" with a completely different meaning here is confusing.
>=20
I will update this, using clamp_t seems more concise in the codes.

Regards,
Xiaoliang
