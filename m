Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D633F0750
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbhHRPBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:01:33 -0400
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:16256
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238799AbhHRPBc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 11:01:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=arZw8bxpuPwfz2Xfa0G2NjFgdL/WdR1Bu1IPSLfiNR5tsE9BvI+gTnnZ4aQ97swhLos+lB2e1n7Gn4C3FP96IAABwbg0e74CMdMA6a13aLvlVNpQ6flrczrcEGxQeDkq2RtonKvthC0s1Uc0JfrmJfSuKgWGRumjgxVJ1u4w4JwHwm4Y7lO59swDlsYx3hNvRqoKjZLhqag/ZWtBAIboswN66Lvrgw+O+qfiq28JE++AYbU8thNcw14vEHScW+K+2L1CIM5laG8b4f2STFU8g9Y2pTRCaW6F9/c4lHXKwnc3bBshlyJqN6z4fvMezuortWc/rdXFPJaSgjF2YeRCYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPsch87PDY8fl+ZFZQXu86VQln7Vjs3uQYgiH5INXAU=;
 b=BXh0lciTUcInSSrw9zhlh1UUeRI7hScvmWRwlj2MqqFBO+UYLydgzHbpDfZayQhnBmRraRG6fwJQvhr/3FQkt09zSvsMDJt9F9LlN/SyZe8VqG1wkmObS6ouWSCtEdA0xe4HbJrAn50rUVYTQZhDA/JiZLNGqhnn9auxBO9Tz7HNyt04wdIxkY2b64U8ekiWgxrnGugXZa84wU9c6lEVg3NH2duQ8SpmA4Pw9jXGLmjaPXmryG652Q2a4q37KlzQMeg+lLZVHUCWhvytm6hrlEg5vhPMaHsxL00YIQm8/OUgEKzfU6Sr4rtPuEqT0Nqf8lSIhGGIAYiuJ046qJBmEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPsch87PDY8fl+ZFZQXu86VQln7Vjs3uQYgiH5INXAU=;
 b=jM5SmKpbDJ4mLf69rOxs3HtYT9wQLJV+aVtAFz0FB2mBjXTjO0NbD2LEUYCVcfZsbusfv6oaU2DktcDXKoVg637uS5f/wZ17yIEOcbV0YZ/C/gfK6RJN/4fs6E1jsax/MxfloSx+dMWmVqiQlKT5J8nAGKIXkuERE1G/WsRfFcA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3199.eurprd04.prod.outlook.com (2603:10a6:802:3::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 15:00:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 15:00:54 +0000
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
Subject: Re: [RFC v2 net-next 4/8] net: mscc: ocelot: add gate and police
 action offload to PSFP
Thread-Topic: [RFC v2 net-next 4/8] net: mscc: ocelot: add gate and police
 action offload to PSFP
Thread-Index: AQHXk/d9N+Eb4ZR7QkSKrssyK5QJaKt5W76A
Date:   Wed, 18 Aug 2021 15:00:54 +0000
Message-ID: <20210818150053.numtnvntscxcm6r4@skbuf>
References: <20210818061922.12625-1-xiaoliang.yang_1@nxp.com>
 <20210818061922.12625-5-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210818061922.12625-5-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e333ef86-dc42-47f2-6d58-08d96258fa2d
x-ms-traffictypediagnostic: VI1PR04MB3199:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB319909915248C11A899B26F8E0FF9@VI1PR04MB3199.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1qu4R7YtTEBXYaOZVIXCI3gQxrLwurIHhKy2j6/V8Lkd07GSGIKeh2ReOyBYydrQqWzq9kT5I47kULpH8Tx4nDeDwOrAY5pxwCmw/KjEJ4FsrcJtU+qDkFt2X8OHMIMHQXGTUR9kmS8fnpOPzIVJDm7B3JHYcX/y/6o213Vi1Qjrc9NVYT4adqGBYMk07aS4hx/is03+4ObjJhqN+F0r+VH1EXulSHQdkS2OjzhPS+Wk+s+YuyGu1dCLp3TeezIN37vxLGUSirvRw9UIOrfz1Mmr1DMhVz0Oa6Ls0iNxtgzMtICExhizYtXXF1d0lGi8uDVyiJsXtsmJkWz1lL0NUwM/7q9Tx/+YQMVfCvPoJyIbHKWsdouPD68DYnn80Mf0wRRkjj9aZCG8MwIUvTAeupnYeA0e0k+GJD6Th9B9xcRnCweuarwhCiTEPUCubuLvhOGCzqAV/iePbkni56iqiC+4H94jPNGKlTx/kzWUHcmtke8RoA0CQvjKnmDGbkhCBdb97Jwy+qjEzjryfah2MnsMduqnISzCTeehePiUqMRMf1KlHb/VdudOfwRXZEKYV519PN9ZIGiXZNLcTUk/oDJYrqzW8O6Nb3BizDnnPCQccTZQstWzXnwivvIcqMxIwL9VmoeGjPlS+BrFeZCn1Z7bMP9XmiPiAi00DfTV4Pwozfwqnai5fF2iBNyQ5zK0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(376002)(396003)(346002)(136003)(366004)(6636002)(122000001)(71200400001)(1076003)(38070700005)(6512007)(86362001)(9686003)(54906003)(316002)(8676002)(2906002)(6486002)(8936002)(478600001)(76116006)(33716001)(66946007)(5660300002)(44832011)(66476007)(64756008)(66556008)(66446008)(4326008)(26005)(38100700002)(186003)(6506007)(6862004)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dCxwsfWIB7Aha/AyLWkRDnRcX5GPncGRbY37/hyBxOl5CUrp8XM2YP48RH3J?=
 =?us-ascii?Q?/BiArM/06xFs96vOtHELZLCanYufD7N6Kxtwjw5ssQXXcaoP1uZoSEP1jqo5?=
 =?us-ascii?Q?+GftwSe/slNReMICa3LuZHVSZsIHZ5/HF4LlETI2GRReP77QSva55txGHWXC?=
 =?us-ascii?Q?aP4TggH2EE3urrfP9IZhd1RdP1aSzWIyqvzjs/0p7L/XlkpciW/l+GJM46P6?=
 =?us-ascii?Q?oPcP5sIkibby92Tzqd8ZaKsLmUQLqiTmCrzVBPvlW4rAG9cSpggLK2q1LUsp?=
 =?us-ascii?Q?pXCk6a+OiUn0sJk7DRBjagPLO6boZYJBvaMeEk7zp7XO1mfWYgiHzuMlcj8f?=
 =?us-ascii?Q?1p/YwdgUXzmR0TUG/XVFatFTrIqa7ToWsNcRJovLji4y1j6xiClNHc8DbefG?=
 =?us-ascii?Q?gbAe2OVh/1W5RvzeFkUh3Kr3XvGHEY2PrbNMPpQFZEWlXEqIZvxtfgdV02W6?=
 =?us-ascii?Q?uLqKmXMIYIvTzeNFSNqu50DbfM4/ddOoAFPpEaxRy4DhqbcspC/uce8d5rEp?=
 =?us-ascii?Q?5Q1gXUlTo9fi79ZB0Zlsxcxh7yraQ7IhxL7laP7NymaeOn3WmuEfsj9tPG6/?=
 =?us-ascii?Q?BsapqlKApaa8VkZWZIgbOhSL4UkkR6HdQ7yYlivm4sP49zglbgDQdc/shmOp?=
 =?us-ascii?Q?FjpW/LgL8SAMRhbGU1Bg/rj+opYrRbtpPqZtvURVKDs849lfFiJ3jx7BoMw7?=
 =?us-ascii?Q?lkRcp3XHze1aOgOND3XRoy3s3LRD50+SkY70DxKBUPQIMksgGlKaWReWrZIG?=
 =?us-ascii?Q?m7RTv+DLeYCzHJsbovTi/WFB3KW/9aFFYKMTazhX9CH2hSxvUWvzSB2g2cXG?=
 =?us-ascii?Q?G9VodObL7hvHienFtu3TGZqpG92hfwtnfQoUNxtoSXnUgU6fP5FRAdEi2wzT?=
 =?us-ascii?Q?xhwemHE81uH0LzTAt1eJFaDCyRwbvzo/PVXf8YFBQnxWrm5frO3eOZ1M36xb?=
 =?us-ascii?Q?/mmSbvG0LttBT7/ybAoSKbGO9yWOeLD3oYD9L8YJPVX3BEmfQnhJM4qp8sRm?=
 =?us-ascii?Q?mPt7w0wJjHh7MMccbztYo3XpcAoG3iXcrAN45QsWsX2zDr6gvlNqncsL0ima?=
 =?us-ascii?Q?6w7li3GYnrAkvNhCHrRN1RGYVJmdfPLKihR5FL7hnPZ+IdK77LlQ76KXd+TL?=
 =?us-ascii?Q?sD9fRbYvtMwXOQLwv6B068jw6ydr5x5OgMFsL47OsRtNX2N/ocEad4qtCiiy?=
 =?us-ascii?Q?t1b6kG5wj5rXHv+D5RwWxC2SMqcXCOchPWq13eNaSPjlxk4CgEGqnjd43tg2?=
 =?us-ascii?Q?g7JhW6GzTrIouuqOXUcBBq8xC+f99nrMSt41PT3aCZyc6JiOoUInHCouJ5QE?=
 =?us-ascii?Q?FyhgAz8zl4K/S6KFqPzTkJnv?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <97BCAAEBE5AA3642929D3EFB0515A8B8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e333ef86-dc42-47f2-6d58-08d96258fa2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 15:00:54.2701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +RDexaAnZ0Oss0FaF15LcqCuznxkF6TBwW+24kmH+vcym3Y9hk5MqrLVcMA/1PTdwfg8ifQ6wznV0K7Ppb9cMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3199
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 02:19:18PM +0800, Xiaoliang Yang wrote:
> @@ -718,6 +734,15 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot,=
 int port,
>  	if (filter->type =3D=3D OCELOT_VCAP_FILTER_DUMMY)
>  		return ocelot_vcap_dummy_filter_add(ocelot, filter);
> =20
> +	if (filter->type =3D=3D OCELOT_PSFP_FILTER_OFFLOAD) {
> +		kfree(filter);
> +		if (ocelot->ops->psfp_filter_add)
> +			return ocelot->ops->psfp_filter_add(ocelot, f);
> +
> +		NL_SET_ERR_MSG_MOD(extack, "PSFP chain is not supported in HW");
> +		return -EOPNOTSUPP;
> +	}
> +
>  	return ocelot_vcap_filter_add(ocelot, filter, f->common.extack);
>  }

Hmm, I don't really like the idea of allocating an ocelot_vcap_filter
which we don't need for PSFP filters, just to kfree it later.

Is it that much more complicated to not allocate it at all in the first
place, add a bunch of "if" conditions that allocate a VCAP filter only
if we are offloading a VCAP chain?

And that means, don't create ocelot_vcap_filter::type =3D=3D OCELOT_PSFP_FI=
LTER_OFFLOAD,
because PSFP filters are not VCAP filters.=
