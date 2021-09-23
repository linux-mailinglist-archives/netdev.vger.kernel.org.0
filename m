Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795F4415ACD
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 11:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240137AbhIWJYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 05:24:02 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:56609
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239965AbhIWJYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 05:24:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Je8fPuE6cz9RaEXn4RcN8PS/vaNjnSFlEawI+gwUaFVZD3lFuzdQnRv5l1nfcm+iGdH4kGAxEHmO9x0H9LUvPccSD23G5sUM4lK95qIaFLpdhGYzwia9ppeyaEWsfeulgiWmhJvUtx70tiQJ1McEuOAfYbcnxrxJsb5bLM6zqicyNQtS610Js7uIeYyT632aYXjn1VvME6oJMMzKuZ9ZLclnBbQlRDTk+aGM46MjnZKXizuV71lBm7HHc4Je5LpCQ5oJWcbGoK1zVXLuUaZT1pKcN3Ouzqf1b2yogq0yDVgmP+gcHgfU+nYqKsBY9DHrY8OHxIcr+44404jogNf11Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=d7asa+ANrN335x6JDzeqNez+dXeZL8caMg6q4z6l+mo=;
 b=BBD7DJ1wjZ8PeZDKkLwTjdOr5JWtplic42yyvGaeXjsf3AwleXzHHEE2rC0Kr9ObC/+KGx2O5Wx70z/D27sJG0zStb/dqKD7ac3knMtklSiMcHGcDyOHiK5KFppJM0bJUZDQgKa81DZWfDv1SiWRGyVD1OROaOqLSWdEQvjG9N6xBjEGLIKNgdy8Sop/JHqINBBp2zsi+Ci03LMIXV9rKKTFn+D79qkuC3JJcHwjgkAvjGr7xSRpLAQ/MGeho5ijONFWdqV8RhcOVqohvDaXVKiuygIIjjwLc9P7aKytPpOU+PgXhuxUkukog3TI4rxxm5WjOTlDQ5SrC4Bh1Uy+xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7asa+ANrN335x6JDzeqNez+dXeZL8caMg6q4z6l+mo=;
 b=rPu63hZ3VMMa+8V75z0/1I5FPqG/Xmy9YFOU5A2AbVHjxg8UIzVYpB8f/a74BESYPZfzwJuS9dcxx5jStNpVuvGVjvjb9Dg6aNld+SuwTSAyFKN/WQo3z8NP7fd62omoR1H2fZnRYDZeZrF/AGTvcCh0GpQ0MfQ05aPz3YDXnVk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7326.eurprd04.prod.outlook.com (2603:10a6:800:1b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 09:22:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.021; Thu, 23 Sep 2021
 09:22:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v4 net-next 7/8] net: mscc: ocelot: use index to set vcap
 policer
Thread-Topic: [PATCH v4 net-next 7/8] net: mscc: ocelot: use index to set vcap
 policer
Thread-Index: AQHXr56I1X8k6Vdwpky9OCEV9EsRoauwCXaAgADSrACAAF6JgIAAHyMA
Date:   Thu, 23 Sep 2021 09:22:27 +0000
Message-ID: <20210923092226.nmin3abnrilmu6rj@skbuf>
References: <20210922105202.12134-1-xiaoliang.yang_1@nxp.com>
 <20210922105202.12134-8-xiaoliang.yang_1@nxp.com>
 <20210922131837.ocuk34z3njf5k3yp@skbuf>
 <DB8PR04MB578599F04A8764034485CE89F0A39@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210923073059.wbzukwaiyylel72x@soft-dev3-1.localhost>
In-Reply-To: <20210923073059.wbzukwaiyylel72x@soft-dev3-1.localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82ce40f1-8c83-4d4d-4520-08d97e73a979
x-ms-traffictypediagnostic: VE1PR04MB7326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB7326717DC8759DC03F501350E0A39@VE1PR04MB7326.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qQHLUp7adKaYji8oo32HCTOaZFeFxS31VSz6GFgJECLpEbV06oBzchM2fZl98M3o5uYFeIP0KJLDfKp3Q0MkfBGdtPYYaJfn8u9mMfPS5JYYOtxsTkQtAOzoi1ZsRf8BKBd8FcErDJTOqDbb4kM0l46Uso9ZdbKw0QsTt4hkuSyuuAijRo9nLONOXWCR9vvdyGYgu7lp5zNU8MmiwLQASeVne9fO4xGk9jjGSLEE4yhp0uDTwUmolpHsQbAeTeyOouo+6nDsOgOUa7oEw8IQmqM33DLfKZnFdCfI2Zgj+71kwEVroJ28RLsGhpphHKi3RjJYeEkDoAxpoei3S6Z/1ryXYu7jNrK7StNNgy7AvxWPHTgaqXz4frq0j9sNxqrUfuzHMwrhj4d31uOXjNpRZBaGcOCNmhsfVeCCt4GHs8eNPA+8cSW+pgq9gQFk7szB7aIVhHjNQTfoQg0992aLyH335HLyz8uTSXy+yX7T7NVxXsmhOoX0YnM0K8k6tBFZ1mfjrQGa+Z2Y84RmJqt02Gz+bfm6uo7QgB79JrGeWyepC95JNfnlhqCkCadfl0mMS2nP8SBD2UR0s+YFfFgnOnXMNFIhAitilNKTNoWQXwhXtYy2I5HYNInC9fQDj8cQz/6aRzQAVPIs1/rRjIvSbXW5Fan2nd4phVFUmu5zd9dUpxDHQJaPEFPei8ee2Q5l1m6ub5+jGRZeiDPfB+X4cw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(44832011)(6486002)(4326008)(38070700005)(5660300002)(6506007)(2906002)(186003)(7416002)(86362001)(508600001)(26005)(6512007)(6916009)(9686003)(54906003)(66556008)(64756008)(71200400001)(8936002)(122000001)(38100700002)(76116006)(91956017)(66476007)(66446008)(66946007)(1076003)(8676002)(316002)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JyIGfU2bwlf1gFlOcKG1COvnrapo72JsXdz3UBhx/S4DaOF2BsZ38ElSfC/v?=
 =?us-ascii?Q?2C6H4PN6tvwz3KGwngUKERXql9q62YyA6FRJhuZMq3toSdHkuXJbfrNyCfLv?=
 =?us-ascii?Q?zmmeM6PLWOFXhidLflB9Zch1CQGb4fC2nMrgRv0azPZiFfOv6GPw0cyDFw4S?=
 =?us-ascii?Q?BXHrXWGpqUbcaVRtctDa0djnmODuj7umqRwzzwv7rJjXz+RnwiLd/MaLaFJ9?=
 =?us-ascii?Q?mCLDeXVBdaikd00qSrIdHPf1jRtVegxmOoorBMJh4lsGIo73Kpq5kO4MOMLx?=
 =?us-ascii?Q?ymSNMfCi7VUAaWBh19X7WNRj1OAIV47FDoI+PQ5qM9LYbIYTB5YhB6kDdyBw?=
 =?us-ascii?Q?eD7Ad/dv7hFnNZjqfvdx3/YLh8vKpovAm3I76n/o8gDzR+wonO+wsRF3xHAv?=
 =?us-ascii?Q?o5ld++DIXyyc+alRKvGJuKnRjvPwXKHvts/B02EpbRpKY1waYs9NnISw5Wwu?=
 =?us-ascii?Q?OJcD5B9YUAJM7F9r1nliT97vB7etrDVuI3zU4g7dFERkYHUBPGaQcTzQRE7G?=
 =?us-ascii?Q?+8RBo3HOsZUqCeWnmRODvZJK5lFv3caCK+/ye/JvgLiHaBWq85PDqS4CelBK?=
 =?us-ascii?Q?/txoKXa+A8K2G/B8zS+sT9VXIg9pRzK7pJL2nB686Lu3Mu2lsrXNRmyl6rED?=
 =?us-ascii?Q?NjARk2f7D/r6doh7SpcWEy7/s23pKraimLH+khHPnUd7dm2JmpctyXL81Mhj?=
 =?us-ascii?Q?CcdyViH+BAw53sD4XQ9a8bzD7EkDcd+jFa+RIPCMvJ22bM7ojhiWe/1pPOso?=
 =?us-ascii?Q?pZO+j/oCeiCy/l8bO1AnIisYoaumzwh7i10IzCoe8cTiUbrR1eCeNqgvj76l?=
 =?us-ascii?Q?wxxHuamwc6LQaJ+E1zM5zIn1zamtbq+9vPQisy/8FQUY0/mT5QHlxcWxvf7l?=
 =?us-ascii?Q?YxZ5TlzdvvIrPuL1NSO99OEKAkgNTP1KiytVaJajLjEgteoFjkJztAy+Z7kH?=
 =?us-ascii?Q?RBznARLl/Ufr4lxROAlOed+c9OyrvcnVlHAJ2G5agrOhIWTzERBwemfQbTK4?=
 =?us-ascii?Q?aGSIAY7UcDKGabFJDmA4f2AKI3NmDJZh86SJ60O5gvvzEn2y5yHAwyqMIt5t?=
 =?us-ascii?Q?DyopqzdycM+buCBf5zCPcCqtZv2Ja2Xu5ky5QX891Xjnl19XU+0NxiK1axF+?=
 =?us-ascii?Q?jGXH8A0vQHwndi8gVlS1eKCSBqxkNhOYZVTfdKzGJcHtK8IukklfYu7CZc+R?=
 =?us-ascii?Q?25NAze0t4SWYiDVKborsQ6x5D4qbFpG6poZmZy4a0O5UqqV+BvL8VppBKrvn?=
 =?us-ascii?Q?ZncJhTdvWR3R+tiMcsDJB7r7hrjrbHTnmOGnVH4V2kz5ocggnUOgouiHDdvR?=
 =?us-ascii?Q?qL36/i7Y1SPO4fUM7f9ohp0HgBp27mGGDydFLKri8KgTbw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A728646D2A885344A8536E10BA05F9C7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ce40f1-8c83-4d4d-4520-08d97e73a979
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 09:22:27.7312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0DnpQFJTxz2HwzZOpo5LLSeSdzKwG26xXcF3XMVexuZEjDdrdZWYz7Nj2QNSX9FjDCbbqAUKN3jzMliU27jbNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 09:30:59AM +0200, Horatiu Vultur wrote:
> > In commit commit b596229448dd ("net: mscc: ocelot: Add support for tcam=
"), Horatiu Vultur define the max number of policers as 383:
> > +#define OCELOT_POLICER_DISCARD 0x17f
> > VCAP IS2 use this policer to set drop action. I did not change this and=
 set the VCAP policers with 128-191 according to the VSC7514 document.
> >
> > I don't know why 383 was used as the maximum value of policer in the or=
iginal code. Can Microchip people check the code or the documentation for e=
rrors?
>
> It was defined as 383 because the HW actually support this number of
> policers. But for this SKU it is recomended to use 191, but no one will
> stop you from using 383.

So if it is recommended to use 191, why did you use 383? Should Xiaoliang
change that to 191, or leave it alone?

> > > Also, FWIW, Seville has this policer allocation:
> > >
> > >       0 ----+----------------------+
> > >             |  Port Policers (11)  |
> > >      11 ----+----------------------+
> > >             |  VCAP Policers (21)  |
> > >      32 ----+----------------------+
> > >             |   QoS Policers (88)  |
> > >     120 ----+----------------------+
> > >             |  VCAP Policers (43)  |
> > >     162 ----+----------------------+
> >
> > I didn't find Seville's document, if this allocation is right, I will a=
dd it in Seville driver.

Strange enough, I don't remember having reports about the VCAP IS2
policers on Seville not working, and of course being in the common code,
we'd start with a count of 384 policers for that hardware too, and
counting from the end. I think I even tested the policers when adding
the VCAP IS2 constants, and they worked. Is there any sort of index
wraparound that takes place?=
