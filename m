Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E5341F7B5
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356160AbhJAWso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:48:44 -0400
Received: from mail-eopbgr40040.outbound.protection.outlook.com ([40.107.4.40]:59470
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1356196AbhJAWsa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 18:48:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHKNTqWVT+U4NeZGtbXI6WDC5d2qtL1FyS2tOiMRedMoBC2uJkR7RGTJdUxf9lNzQLzUKKdsgTVuTA7yGAsGW9o6YLmom+xA2kByAHcWuaQ7R+77ZpLpOtRUMfbKB73uRvq66xkuSYU6WqvFoxNZmv9I6i2frIdbPNA83wUaDUub3Pf3DXD+vtkO5oBKcBPmI1ZqvToGQH1uzsYx0vD0EJiTrgSHbJNtQT2Q+11o9vkThPlgovmaxhRcyWj7LqZJTTz+zmBVI/3ICHZDLlpBcMdcXDXulAzHMLzHiVXsi4p4+s/NJNakNGxLQdPTh36NJRDlBRbAywJi6vebbd5Zxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IvY0EwfYrkl9zaCRzngzPIkSBqUfPC+LfCdyLeSDSR0=;
 b=ie1kq3FH2LijIlpAKcJs94si0bPMA9TzoOJ2LirHWlF/3RU4zEF62WRyEIMUeoWRFUTOzNS+Axy0wmk41O+GL+o+3yL/2DcGoZrHdN2EbiLiyUS5ljll3yku16yoqs7M9X0MHg7lqKmE+MC+xa2AKrp5ZnqspI6EuJY+HpSeswhGVK1Z6TnjWpHIPCWduuHUhsEG9xeGTpoWFQJd+srWbrcXn8CDUD81Sad9UupkItKIK+9uSrVzweuvs4Iw1Q68s5uyiO9lFRsNbCuyl4BZrU2FQq557uTOGVpCY98uXSPE51UdeQLmZnfuNd4xKLmYT6MX5wbDBzCqBqglH+Aq+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvY0EwfYrkl9zaCRzngzPIkSBqUfPC+LfCdyLeSDSR0=;
 b=eNZ2ONRlIfA+eDVEdfxp1YUTSmPWOGOxSPCFB/oncjZ+iLZtwfjDPhshSvtiosp8t7HeLM7XR/tCP1vGW82MXodqHU4pHalCCHFAx/5AXB5CTQLUyp6RIS6k7iGoRGr4qfoaLSKiNtpv5Ly15iwMa8PXYUcu3TOo5Ye0ZnXzqeA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Fri, 1 Oct
 2021 22:46:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 22:46:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        Po Liu <po.liu@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH v6 net-next 0/8] net: dsa: felix: psfp support on vsc9959
Thread-Topic: [PATCH v6 net-next 0/8] net: dsa: felix: psfp support on vsc9959
Thread-Index: AQHXtc/NwIV3BgN/R0a4xHtuLk/jJqu+tuCAgAAJ3YA=
Date:   Fri, 1 Oct 2021 22:46:34 +0000
Message-ID: <20211001224633.u7ylsyy4mpl5kmmo@skbuf>
References: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
 <20211001151115.5f583f4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211001151115.5f583f4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09bf550a-11db-415b-59bd-08d9852d5205
x-ms-traffictypediagnostic: VE1PR04MB6639:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB66393D60BB85EF65528C7357E0AB9@VE1PR04MB6639.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0L9hN+vh30jxRgNgiCazMC08aStOQo12oPMslmd/owbf8vHPWQbSKl+kKe7W4PbAsphWXYm07YYZth/AIhuATDmUzxdsQQnOdjJnZg5AtKJY4MVmrQ1RWUtqCVCygtQL6PZ7VEi206QTLablANjaLzANls53HurF/uHZwoKmoLk5qfNmevECWJEotDfXkn5VIW/dE+qEs/MKN2lMQ1XLupiigTRLqCtxaispO7FkHUo6iYcToVYDLRDsybk2ZCpx7IYqrZGGELY2vYVC5+ej4Wf+YMlJKad/4MQQvAv0O+y6Y3662xNn2ZvEgc7ApcveeFFipGs5I5U9E16dXP82AjY1Cpuqv3XGsues6TKsT4r6GK/3Pp7cCnGHyJhsOcOSgx9EuLe+IA3ZO+JzYDuJkFQPk4L30uUoLQhyauf8VTE0oqeomo+VoVECoHMC3r/NVUKXKOOhDG48ffIOvUg4n1rYUAVoBMY/n5EkIGobas7CfZfifuHvjPVRmASET4ysVtPNWP7592luAaItRpgtue7o1tknIpQqQQcj15Qiljd5hreJr+z1RyFkR/XpK7YpsMIuV7dWzJlHt4uDbg6S9G67i9nGZZS8IHHKMfu6orEnXR7cAg6RiCodvmW7N49nmekqZ/mr5A6tMQr341vYgBFQ1cFaEESpy/EfXoYH3OCafzhCNIoI+EM1jdk9CBIMSUWZ+dhcXvqbpWam+/Qox/1kzEQjJpRVn+WykyeI+S4iiCwOxuo4OjSd9Dahdl5SoVsgpJ+6y/+uW66HNIv/gU8+ey+XMMZkdX/RyB/5wxU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(122000001)(4326008)(33716001)(38070700005)(38100700002)(86362001)(316002)(7416002)(54906003)(6506007)(5660300002)(8936002)(8676002)(6916009)(66446008)(64756008)(66556008)(44832011)(76116006)(91956017)(66476007)(66946007)(2906002)(6486002)(9686003)(26005)(6512007)(71200400001)(508600001)(186003)(966005)(1076003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3zyUwi1NLmOXNQAEibceINNQ9aEj9yp8BDoVg4GoRO++FcIWlqoUBsiYdUzT?=
 =?us-ascii?Q?guDWlhIfizA5cE2qi9WwzahUovxfyLCGMAd/idMI6NmPGbcglQqP7wJWSdiY?=
 =?us-ascii?Q?D+LOyqCaIOxOVX1f0vUfM6SmS/dZiJZvQ3a0hUwgD67l8gJcj1emo9D3BGnY?=
 =?us-ascii?Q?A7SFAgVZAWbSRCuUKF0HWjRlNFtAGGOngzA/aS39razBklB6cDSG9knwKGT7?=
 =?us-ascii?Q?hq/lxe7BoZvrooNdjw9IFBLPC8kNTdwozrfAGc1LpRjc3dmaplWwN7jkaXDF?=
 =?us-ascii?Q?eysO9AmFd8ImJCZIF04p2nQDJniTu8T5xIXNjzE27Fgf0VJ9GeFTWMxI5qRr?=
 =?us-ascii?Q?e/SjtOSAKp8bioHnek8Aqq5RkJn0zovXEcV1ZJfEgbfSN4lcPzeaZP48Z5WG?=
 =?us-ascii?Q?IhHo0MPhWV84TYZ1aV2jyDjxQrA/BO4y3TBn74zxCvVYN93hQlwHiS54SSn/?=
 =?us-ascii?Q?XLNcHlpMPRYbP3HGtZk/2NNqW7foyiEtXFkLJA/1NrtZTFsHe4eGnJedta95?=
 =?us-ascii?Q?qATvsuNneLSgz5j7eA4+vlSbydzl3fk7rWBLPWJuuVB6qX0uQsB9nl1uplhb?=
 =?us-ascii?Q?uAl9KFbXGUcPezsj434K/zNqPWMkK2Gg8E6mpVByABpHduzxwrOIpIZkoU8T?=
 =?us-ascii?Q?dINSKB4kyXUVi6xiR1Vk28vsmo6hRoroXmsX+uk3GMkdJP5u70OGcQp+b1JZ?=
 =?us-ascii?Q?pxNxDy7UZbcGpyqmnpwnkBtDUaxXLU3E171jYYUB3fcvumSncjWCxnhSzM9D?=
 =?us-ascii?Q?t79aBqS6HBRX+NPV01p7nvjrTP1gjLhrm5PIQd0eLbHBis0IVtb5rsP9XFPA?=
 =?us-ascii?Q?yGnIwhVm6QcZWoqDCu+T75Ra44pHrG2/dWUNCPeSKMuJR/8JEmGpjHvEGoiG?=
 =?us-ascii?Q?75rOUPlLubJGfYc2fsU6gtn9S6QagxS1Mu94CKq3PBuBle6yY039feBrvMLP?=
 =?us-ascii?Q?K6fKFBVZIuVQeQmdKpjwaBBhPB2+Lv1tTyKjj/uOKJre+IxFocH2NIp/bx9b?=
 =?us-ascii?Q?qk9WKjZSQStnPhwzV3guqjKe3ajCm6PucdzFcngKgX8W/cjocG0pT/zSb7Jl?=
 =?us-ascii?Q?MOclGlTnSKNlhf/E8bwPsVS9+0PA0kBs9ZUWfwtJ7yNqWToqFZz1Pysa5Cpm?=
 =?us-ascii?Q?ffwEAnn/XNKCfAIb40CbvfVRAhuWzkWwURJQsgIMhDbH+Gh73WqCmcpdiHlu?=
 =?us-ascii?Q?lo7GmXUzAK3ohp6eG4NdATsTg6YE93C5wN0ac2g7yyw1lDARdHO+TMQBRgFr?=
 =?us-ascii?Q?t6I/LCnd58SB38N9clPtq8F+1zHwZgFDFmodRXF4f5DkxmQmIsfaI869TxiB?=
 =?us-ascii?Q?lvZ4A8yVK1/HdPtrmNbOvba4RegDlqDA6DV0CBP/48IYKA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A0C6CFECD2344C4290654BAF4FDA2803@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09bf550a-11db-415b-59bd-08d9852d5205
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2021 22:46:34.4161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nf8ABeQ70f6uwbLWvvybPKajPhdguzc9m4s1LnC5AIQpJET0ycIN1SELDYOmMm+sL0npWNtWAl/TynLa2DVGsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 03:11:15PM -0700, Jakub Kicinski wrote:
> On Thu, 30 Sep 2021 15:59:40 +0800 Xiaoliang Yang wrote:
> > VSC9959 hardware supports Per-Stream Filtering and Policing(PSFP).
> > This patch series add PSFP support on tc flower offload of ocelot
> > driver. Use chain 30000 to distinguish PSFP from VCAP blocks. Add gate
> > and police set to support PSFP in VSC9959 driver.
>
> Vladimir, any comments?

Sorry, I was intending to try out the patches and get an overall feel
from there, but I had an incredibly busy week and simply didn't have time.
If it's okay to wait a bit more I will do that tomorrow.
In general I feel that the most glaring issue Xiaoliang has still
avoided to address is the one discussed here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210831034536.17497-6=
-xiaoliang.yang_1@nxp.com/#24416737
where basically some tc filters depend on some bridge fdb entries, and
there's no way to prevent the bridge from deleting the fdb entries which
would in turn break the tc filters, but also no way of removing the tc
filters when the bridge fdb entries disappear.
The hardware design is poor, no two ways around that, but arguably it's
a tricky issue to handle in software too, the bridge simply doesn't give
switchdev drivers a chance to veto an fdb removal, and I've no idea what
changing that would even mean. So I can understand why Xiaoliang is
avoiding it.
That's why I wanted to run the patches too, first I feel that we should
provide a selftest for the feature, and that is absent from this patch
series, and second I would like to see how broken can the driver state
end up being if we just leave tc filters around which are just inactive
in the absence of a bridge, or a bridge fdb entry. I simply don't know
that right now.
It's almost as if we would be better off stealing some hardware FDB
entries from the bridge and reserving them for the tc filter, and not
depending on the bridge driver at all.=
