Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E040294569
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 01:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410569AbgJTXYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 19:24:24 -0400
Received: from mail-eopbgr20084.outbound.protection.outlook.com ([40.107.2.84]:21733
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410558AbgJTXYX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 19:24:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hV/aFSnzyNzcbnz0RAGLgPgLumfE0Hrj/RNvitUOrDlroxixQORE5IEb96R2cdIm4cH+VcI47PFRysRqextRxp0AVPgiVa8dLX8MdX+67dfia8cc31bk+wPJlddNUAqSpzoLr2P2LpugcZK6IJNPrlXIS3FP8WXBupoENa1WrIcOO5zY+9bdd06uCrOSq+LTIBn8HYGYyrjfOxCpOGfQUOcKYhfMw4r0YUfuxHOWYlNEvJ5qlzTKPTsj7giqUHeE8EK9fxImGzK3dgdROPX+QLy3GBe4vvPUhwfhVdXEWcYjbNGUp3T099WF+kznMCmWIXsde70k3EzLBGbhPgek8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHd3ypeTiInyl5hQRwRFe8vKhf+uGnF+df09FsRcHbw=;
 b=gHSCVjJkYYLX7rwJJr5Nt66QqiQqn/zKoWI+Op8kJMGMW6ZjT9Oo9FbBifiU6qy9GaDC7dYoG9fpV82XX06SPKXhUnPnZHKALy88utdSDsdgd9Uc3xmuSlgE5lFEaVZzPndolhFWgUVNWbsKSk+yTahfuqzOs4OlXOOOY6y3XUjTt8wpAKXHN6yVhkTx4x+XmYm/EahpG7VrX/nzHXx9m+f663BQZmN1tsGIZ/hee8vdyJ2DoJI+9IqVLpI7Y0CSYdXqWxu5vLsFV/N7lsNeWOJuBNtdaBHIaAXtx5VM5lxFzhgNAYh2bj9WAfDQQK0/dF1o7qnADsA4uE5UtAHQsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHd3ypeTiInyl5hQRwRFe8vKhf+uGnF+df09FsRcHbw=;
 b=fA+xGzP+6bokXJrH9Pt+leCWB7+lXMp4uOS+dedamInWnp1NnnLpBIHyik88Xqx9QPvPD4wNFsJvQ3Nf7CtiZKQhDhqaMA4oqCwiCn9RV+u7+Hnv3aILdcZuHb/3LQ7xVMq7kswAlPAetcpti12aNa2HwT5itmStZweZ02t7eVk=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Tue, 20 Oct
 2020 23:24:18 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.029; Tue, 20 Oct 2020
 23:24:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>
Subject: Re: [PATCH v1 net-next 1/5] net: mscc: ocelot: add and export MAC
 table lookup operations
Thread-Topic: [PATCH v1 net-next 1/5] net: mscc: ocelot: add and export MAC
 table lookup operations
Thread-Index: AQHWprMwC3/3+gs7a0CCELKkF8zrU6mhItoA
Date:   Tue, 20 Oct 2020 23:24:17 +0000
Message-ID: <20201020232416.tlznucfoolagx3yw@skbuf>
References: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
 <20201020072321.36921-2-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20201020072321.36921-2-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d1be0a4b-7cd4-4cdb-8003-08d8754f4444
x-ms-traffictypediagnostic: VI1PR04MB6271:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB627187E11A97191595152ECCE01F0@VI1PR04MB6271.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: smL6GglHFlGgG0rmBfKwoZmrdlISyMArMTtkutjx0SNeXK0u4zR+kH5Qvhv8u0jtFXmUu5d0Iwjqn0s5rEF4bQXM1U01/5VBcQFv18vN8J/VJ0tKb+v6dfEeW3/Ij/mOkyuhcRPPuPBd2iJJhE0vYwCBUU1mqscAm7ON3i49J2ARYBJUvCtnxsn2QPD5cVVryaNk39SWxP3DqJwrVy6He6kwr4hLovzME3r5JKIrpsTybCTDbREu0QqdJ6b1Lv1HKelMXYxThZeOf9Y2chqEAmjQcGNQ+hY5lhXUqgrnYFoPPtkFo64lXEq8wkLrC/pGhNpmcJHGrYFo5/pgOKxZvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(136003)(39860400002)(346002)(396003)(376002)(6636002)(71200400001)(66946007)(66556008)(91956017)(2906002)(64756008)(6512007)(9686003)(8676002)(66446008)(8936002)(66476007)(6486002)(44832011)(7416002)(76116006)(86362001)(33716001)(5660300002)(54906003)(6862004)(186003)(26005)(6506007)(4326008)(478600001)(1076003)(316002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: DU1XcgRNfiBdWwe+ghcjal3OapkTZAxvbNCd6ZjY7nCb2y1VIvVBvNvshnnCw6+ZKwJIG7Ycb5usqJTKqmvm/nNTtKSR8OqjwutyCTQjkec6XUPRSg4oH6XgRt9xz6kMUpAoIKtJbYwiQuMEiirizilvcYAtQPirlJNG4Mg430a/ZV9424Nv9X4Bnr/NN7Nhmo0ewSLyyQneGoel4vtXN2HuNxb65bdofJZDZOloWcmxMfN3n+B+Z/qnihBz74vHjtBB5Q4quR3Zwuk8Vds6u/6NihaJi2L36VBjHBqJma0PpePxbxyJkFc2fMuoV56z3aB6M/UH+oj6g1qtKrEsW0xIXGo2Rf4mSnHEcDRq69Fa8mm+p03YQZVXjxmcTXe9i4bnmvf+RMePoy54dbbZqKHrPRAnbRAjnfidcpC++P2aRLN6F9mq1Qj59txSmTf8HlzUCrcln4dOMu5NY5BrI5JaONw7ZY+y/QJm093FrUpXGiSbJhZ6+bUtpJWQxKPDjDbC+W1/eAsYCtqqBn1noNbFhJOIlY0Y69IzTmfTY6ZsPRnFXBymY9bDivj42XcaHZOkObaf6f8cq7uveYZSLdHi9HPisTY5sOcKUWbkrebHadIbWBXkHczohGUbb7f5al2E3PNSjcJj5AIYmRVADQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <80811A39E3C5F44AA78456348532F0F7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1be0a4b-7cd4-4cdb-8003-08d8754f4444
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 23:24:18.0151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1DiSrlbZRKHymRrKF3DFsRvUQVTxVbn4r+cqBZtYGUPn+sS5zcknyQ4aAb3CttkBy/kyyBGLmqlfS7gmwaEk4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 03:23:17PM +0800, Xiaoliang Yang wrote:
> Add ocelot_mact_lookup() function to retrieve the row and column at
> which an FDB entry with the given {DMAC, VID} key is found.
>=20
> This function is needed in felix DSA driver, so export it.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---

Please split the moving of code and the introduction of new code into
different patches where possible (like here).=
