Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5119C3F05BB
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 16:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbhHROIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 10:08:17 -0400
Received: from mail-am6eur05on2075.outbound.protection.outlook.com ([40.107.22.75]:41536
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238970AbhHROII (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 10:08:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9Ii+zvrmCmRB++TfIT+XBGKrEih9f46zLVh0HfrbXf9T9d0n2K75oU2ngZKF5n3VjsBzCJKpyI/n5pPyZBLoSWr+JVpUkF/ha86Id1/i29QAj6we+oNibTtpMHWn/MEp085joRZizjkEBYCbx4YNDnpxuCyyr3IYYIKbHI70y41Fu7iIFKjjR6D3RxcbBHUNLllwUq4GQAxqxxbDagjvNNAsgr1DHFYw2knbrN9vYrYfIZpsPJKZcPPHPr23f/vZeWUUvWfjb2zxQKVcdNdHCIEQ3gd0HR1uDIY5BtdOqyDjW9juJWrMduUlAN5DT6a6IZwjSYn4vgGqVlARHXNKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8X1cqzGW8dKDWhSuiPt7rUYhD069hFs5HGpf8beqgHg=;
 b=Q3D1tvQyhexUPMBTMLsqrKTEZ2ApqYenmXWgHJ5BLF9Z9zx8HnYbUdB/Or0lsBqdvJwbpwQYG4smTGZ6DYTFDlHpu3RmlO+p4Zp1C5Q+9TEvWN0jlZClVUJr/OoJL7flodc1qlFZ42rMmIkL52eChepJVzNNV+E4X4fSD40QwWdC6zeOA3L28hsnBFw/UXxKxG594VMSJ7nTHmH3aZC4EqD04xszEqmSw1mjYt1Oz9v1jrHGZgOnGqJXuMAchnlZsq8ZEbK4qEqk0nLzysnmcx3dswFAzxnH03saTodZ4g5Qp1iPnd6Tfxs7qU1IEsvjOAXWv7XqQww+PA1hNEnjww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8X1cqzGW8dKDWhSuiPt7rUYhD069hFs5HGpf8beqgHg=;
 b=iVnUv4jRCwnMKI4xiotpvQ7fEMO2nWmXf6Pqtux2hJQKDE4v6tos7uwDK35WoDsmDyxYbK4Sht47rOnW3fJOii5KzKiVxmhcK7ZvFxdpE6EWAT4j+BJa+kqyqWAtglbKstxd6o2pnNwkxL7IclvF+juJ67l83cP7r+j3dvEUfvg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7216.eurprd04.prod.outlook.com (2603:10a6:800:1b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Wed, 18 Aug
 2021 14:07:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 14:07:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
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
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [RFC v2 net-next 2/8] net: mscc: ocelot: export MAC table lookup
 and write
Thread-Topic: [RFC v2 net-next 2/8] net: mscc: ocelot: export MAC table lookup
 and write
Thread-Index: AQHXk/d7FW3EK5xtW0agq9/5JXNYNat5TNWA
Date:   Wed, 18 Aug 2021 14:07:31 +0000
Message-ID: <20210818140731.pdnfj553tflryq4e@skbuf>
References: <20210818061922.12625-1-xiaoliang.yang_1@nxp.com>
 <20210818061922.12625-3-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210818061922.12625-3-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1a2b740-e24d-4f22-719f-08d96251855d
x-ms-traffictypediagnostic: VE1PR04MB7216:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB72169D4A7D9EFE9C23660E98E0FF9@VE1PR04MB7216.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lQeThCQuvKBJOjhXnsV32ZTZ20Q2thk8wRI0l5EQBMH9tZ41ngPa66U50fB1z5KUbJtsRsBJsrME3vS5mPRqTql1leNaUHms3SdgwAnK3nLtNuMXvHJCjxrWsb0o+32/Ga/c/L7bQTnHlxR3igxdqsTBPYJLppRkRtUVoDvdGNKeG4K6/vpPS6sjokm/NYgBZ1XW95o+1fNz4iPxGJCCQoJkmwKUfV7vo+VN9JAcBxcSjVtStIyu10H2MLIMdG2NCBTG7JwW0AGf1w3bKzCl/i4HWhyTMzQhKTjUOR+9f6oFRbdDKgGixMH8xsMw6TDdIgvtWcObyS/HzHQmFszmmI8SnbwBBS7rE3JuDBZuCPJOM22OsAdXlkhrKLaHcTk88BuygbCkTGCszwT4jj4oZkUYuXLekrp7zHjUN7unU6+P5jla2TXs7R2dT+yTiPsP2TB5SdY1ZGy86oB+3Ga5ninPjXD8KjbyYLKUnXFLiw0NJXfc4+b10VPYOwpZua7gQkKl0h11N9OW7miwpG351T5KJocMyQrkZSKZIJNG+9TtLs61Ssh/PwtjOcnGjslqeLTt/jo+lMWDvhsh7qRhEQe8A7BpvfI2f3iT2dRxHG0Y4LO4Ab2/RkNJw5zVOt6hnwLsZZ47RmFSitqwTiMihiPqA17KR/hUkKGqqH1vQdOn7S0zA6NQiIGYEifenB5km7jvFxWWssKdoBx4Lbm3RA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(26005)(44832011)(71200400001)(6486002)(478600001)(76116006)(186003)(86362001)(66946007)(122000001)(6636002)(6512007)(9686003)(4744005)(33716001)(1076003)(54906003)(4326008)(8936002)(8676002)(83380400001)(66446008)(316002)(38100700002)(64756008)(66556008)(38070700005)(7416002)(6862004)(6506007)(5660300002)(66476007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?43CTi00FZFY8gCeth96zTA9s/IH+LNMAloVtVw0gAqXM0zsOfcbfvBz2901u?=
 =?us-ascii?Q?MeqKCWCnfViv3eNu4l2Rc2x2y/TkKODUWDSd1/+a0y9Sygggmt7xytTvyr5L?=
 =?us-ascii?Q?CL987UZYsu4Tl2rHaoVFQZHDj7Rx+d46pq4QlzX9Tp1WZ5bCZshZ1Oo339nz?=
 =?us-ascii?Q?B/qX3cvJCZ8UwZVTO4a9iAYPPssTwY20PBeO/0tlt6cfaE9Rp5SY7ncBbEoa?=
 =?us-ascii?Q?Vx5joWxGBjbX23ISQJUlNV+qaJ8VDmVfQO5XXi27xcK3OOx20RVQbMfatyCn?=
 =?us-ascii?Q?qjb6OKXQaiV4N9mDIjadixlr+b9uqPrwbkmrv5TeU+h6SGlL+Dde4G5rXv33?=
 =?us-ascii?Q?Akh64mivkgJttIbOvVpLqGB0Az9R1vZ21E6BM2wcLKjibXWMXWLbaKXQuhJt?=
 =?us-ascii?Q?KNge19HbrcHxlwCsKCv0W0JFtofCd7AP/Jx4xUo0NRMkjGnQVGPufOgvgmUy?=
 =?us-ascii?Q?Tf8YrxU3C56MTUiQxBI3ZCBCgmRNgOyR+i4WhPYYMBv/33yVHziH+kiuv2qf?=
 =?us-ascii?Q?1aF6MceT8RwqG2HjTTnbwxlAXodn88rk/ytKo+kwBD+rf54o+3cZ8B20hIIO?=
 =?us-ascii?Q?HrRFHkRgz+PSZ4XPkDwrcqqknAUfb2V5311HWQpWx2nQJr/6X5r6KEaVGd5T?=
 =?us-ascii?Q?8EZoNDVsmd23CXAy1xv7ZS6L0pTJcie17n7At474mfRSn5dVde63FZcdQhGa?=
 =?us-ascii?Q?i3ofuEZVhM30l65Y6McErx3SDJ4wUShTRaBp37YeAu9A2cr6gdkzhUjzl/2q?=
 =?us-ascii?Q?u/LfqFu+AYfL4l7mIdbiL8ir3daYomC1z04xdF+1QudhRVeAXk00s9NyVh5t?=
 =?us-ascii?Q?uiRD9Sb6yxbAs5beT9JWxX4FDOlKK/XBH23+JgrtoPtsw+GSzVKK5RDW7q6x?=
 =?us-ascii?Q?Q0rFc3Q6c8aDLCQ1jN1TEqmPkmOC7v/8NoI/FvMsVZXN7d6jR/rSd4U5mZvJ?=
 =?us-ascii?Q?hmjGGm2Ks2G4+u7xLbXehlbHY8xy7rYRNio13lVo5a266/whJxtBlm+V8m6I?=
 =?us-ascii?Q?iI/VNb8bYOF4cnd+ks1r2GdwZZ98qVelez9OXQSC+cPIuh2J/Lm3PLibgc0P?=
 =?us-ascii?Q?jYEK8VqbVXIw0ZRiAe6eG0+omRF7owa8DLEfD3yXkUYJD1m4Vw+4xGu8U94O?=
 =?us-ascii?Q?k5CIazhOEjbPVb3LO9fke4B39JacKehUuI3mH7DgjtdQXuEvJTi/kUK9r4ep?=
 =?us-ascii?Q?IJIBnVFdQbNDGCtyXWUT0AkT+ZqVWsAvRMzlcXPwzVTReghL7z5/vBSDpfi6?=
 =?us-ascii?Q?xkLW0Box+GqOqfzY9TCz2WXMLrjdwr3I52dIQG+TsHBuBvx2yFrYlpF0awIm?=
 =?us-ascii?Q?bHfI7F/JvVmDCV/kyQ/gSmn+?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CFE03A4ECBF7EE4E8F23FE2C309CAF5B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1a2b740-e24d-4f22-719f-08d96251855d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 14:07:31.7703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ncpcjiqZ9vn5dsn3XZ2FDDhTRsIfej8i098SkjmAz+z0TIGb0BSJyOhuq8YvUSigN5DCU3rIWqO7NMMiWR25sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 02:19:16PM +0800, Xiaoliang Yang wrote:
> Felix DSA needs to use these operations as well, for its stream
> identification functions, so export them in preparation of that.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---

So maybe reorder the patches, first export struct ocelot_mact_entry and
enum macaccess_entry_type, then introduce the ocelot_mact_lookup and
ocelot_mact_write functions directly as exported?=
