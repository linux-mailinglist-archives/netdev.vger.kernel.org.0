Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCB23F16EB
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 12:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238011AbhHSKBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 06:01:22 -0400
Received: from mail-am6eur05on2046.outbound.protection.outlook.com ([40.107.22.46]:33876
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232750AbhHSKBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 06:01:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DlNwkwTRGtjo1ptz9BiFjhyrRjxFRkt+x0DDvU9zq2YZqYuov7hjL1vrigG2yYciK1LMrD5n3dmQ+7SNfvmp1B3A5ESP4M2xK3YZITEZqETUzd+xsY2jYYVuFfyiar0xdyv0bGoVRttF72tFVetVmjIAmALjgIgeKiCY/NloZliId3QjO68rcuIOF6U7Pzky3rOItYBOUMCPCiBNNvETZLcZDCvOw7dNDjgiLkgy6/J/Q4QnBeXi2OValUs6ZJYUoriFx3V/k27/ntLATIV3ENnxdPfc6GTMwyYgJubsn6I18XJlga12UP17CLBtWV24D9iYYjNh6n2e6OwLPDbhVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I00ihqGkEjGgu1tja6GB0qp41pt06IYHwQbBk1h1/vs=;
 b=m/JpFKx92CygXfXj5Jy1YE0/h0Zb9KpW9DBb6UhUVJ2Fyg9gxskwsyPdKrBkiUbQWZMeIodYH4277wO0SKaDPzXuNzhC46C9b6UQFq2ylLAarlvh59gJipqcwz7TWEfBEG8FEThWZOuT/n0Me+nIhIURMKCZw3ihOph0wQJLuIsph4xXW0oFQ1yhK23JeLNyzb9e2tF/clTvxI2ANlI8cxuCtY4RLJYxG7pOJp67naUrSudQncl8lph69S9iGR2xPpDpVHUBcFukIr9MGLRd8zr5SDb2oeaxPf5mQm7zBkR65f/eb95D7Sc9xZHPkuBYSD4ge0aQde3/GLH5cBNt6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I00ihqGkEjGgu1tja6GB0qp41pt06IYHwQbBk1h1/vs=;
 b=UCCwhbr4Q768/jeo/GKGPXk7bP/WLfhEqTlXQxMH6BNcCj6eK0dJ+Bt3hArrcFVUq7DjXjudcTzUeZdrtZvCc4H3NH0xVBt1p7kTPhe7RE+CH+Dwl1mmpUif89b8k1fLhLJelh7EoYDnP/1buNJBRO70+A7TDfuKMql0Ind04P4=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DBAPR04MB7480.eurprd04.prod.outlook.com (2603:10a6:10:1a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 10:00:44 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::20d3:3fd5:a3e5:3f46]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::20d3:3fd5:a3e5:3f46%3]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 10:00:44 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
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
Subject: RE: [RFC v2 net-next 4/8] net: mscc: ocelot: add gate and police
 action offload to PSFP
Thread-Topic: [RFC v2 net-next 4/8] net: mscc: ocelot: add gate and police
 action offload to PSFP
Thread-Index: AQHXk/d9BPsg5KTR3E2gqQF4SGe+36t5W8AAgAE7puA=
Date:   Thu, 19 Aug 2021 10:00:43 +0000
Message-ID: <DB8PR04MB57852F0E658C57DD4B0B76E2F0C09@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210818061922.12625-1-xiaoliang.yang_1@nxp.com>
 <20210818061922.12625-5-xiaoliang.yang_1@nxp.com>
 <20210818150053.numtnvntscxcm6r4@skbuf>
In-Reply-To: <20210818150053.numtnvntscxcm6r4@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afbbdad8-30af-4109-b3bb-08d962f83595
x-ms-traffictypediagnostic: DBAPR04MB7480:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB7480F61557958BD056C5B7B2F0C09@DBAPR04MB7480.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EUhihXw3V0tap5SOXh4y8AKN900blgKIvPW9MSTeuHcE5vccpK6j67hvo/7P2Tz8xeYdH1+IVRwuIaiyj09ex/ij5peeUxtdr9qphF71pCKcrtoVYGHBs+hbh6R93K4bEeLrPvOrmtWA6SfFkZMmqndWHnAljGGJnXZp2Gk0JB8EkqF+CKkE4icd9h3k8EaRFXmbmH2Bi3lFt6wjx4h+iZaCkW/0tk451FehPuWRXDX+Q6pQK66ltg+wnNzTySuK2YyvhFeq5ZHA15X56Mh4m08oh4N6GrbDqzP1TiRapRSZEQ1znV0Q1reEHcGljdC3VEBXFWVwVAJxhKLN/6iAanE00/d/4P1tRr479ou24quOCwFN1j7ViwzLdGI/EpVUgT47RwVbFNM80KPqWhrOL6AaHpgWqfWx8yEq9PWCH524NWodKXKJ6sO7OfvvjAK/swuPAzJBzV3WhXn2lCcCB1hTffiolRs8pzu2kdHb2KpKEaI/Hx9N6v3n8d9D+ZA+0ZGfT7zssyOPxtNCLU0DDD1VlNiYwv8IqWbwwSZjnBTkka6dufdc/L0KCZgnSoq+5YY1NxxsCZokdILsq+UZLbAWwrvanHnAab0L5B82QskctXEEo7+h2Uh+bx+GttGyCP0Q80o8XQE1VvFt/OmyKobk8fsr86yY9+7Spui5sUIGTfmWc9q8+EvSvbcORgc75bu2b31r/MDMFxJoCk8Gbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(64756008)(6506007)(52536014)(6636002)(55016002)(66476007)(7416002)(76116006)(8676002)(71200400001)(26005)(8936002)(7696005)(5660300002)(66556008)(66446008)(186003)(66946007)(6862004)(4326008)(316002)(86362001)(38070700005)(2906002)(122000001)(38100700002)(9686003)(33656002)(54906003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gFAYxY8B26xRkV2gPr0fzCjq1ut/0/g3ECbxwMcq3i4KTacZuo8LpQpybo61?=
 =?us-ascii?Q?XIdkwlS9wCH23usKu+hlTSe2nHk0nUlvMmIVRMNl4CEkkJYz2j6jsF5uj5G8?=
 =?us-ascii?Q?9e56qWhrtRiFFGXbtE61WSVqWJdnesCytZ1SYeR2Lu9Y+xWtCKtVPGpRnjhO?=
 =?us-ascii?Q?7hF+5YkzYhVJ3HwU1SOnzxR2lqy1kp326PgU2PcJjfkRjtS2kZkvnIPSwSvX?=
 =?us-ascii?Q?mYZLrac7P6Baj0pRXO7sTJNxIu2fXeGRBFMvkKqWSTDqGVW66DvgyhA8aevc?=
 =?us-ascii?Q?bynhfcXp0XJuxuZvNmUO8zl6Xgmv0p2BYJ2+621CNznowLl6bMphchmCprQK?=
 =?us-ascii?Q?ZQlkdfF1sPSKy58tgCwBj4oh/6hJSIkf+UhG2/mOaFlbTS/v8NsmqdfkAodc?=
 =?us-ascii?Q?iKHBMQ+HEzySOB5V3cmc5y5mKnpOCbRM8gJvi+vt3/RpHZ7/J9rWSKC5n3Kc?=
 =?us-ascii?Q?9Sf9mZNEHzEwKzhxG6T78Ik7E+7H0pjVskiYwk42aYOnH8uYrrfg/M9JenKb?=
 =?us-ascii?Q?ZWSwwo5CREhmyYwmDlHaOxJVvg2EWpxI6uY2qoXoIo4vAMtvO270LQSavIpJ?=
 =?us-ascii?Q?cMfqPTDpSJPCVyghnHLDarhlrkd5TqBM+zpm/zR9WYwLGN2Xk8oRcBUb0u3b?=
 =?us-ascii?Q?9nghGu8T17udGjbCWCbI9XevcP7v4iRG0bYa3NYoqlpGpbcYxmZO+HR8sTv2?=
 =?us-ascii?Q?x3xtOpASpGeD7Ws8hBdb1jgFT4cmMcIwtd0smZJJakzOxdu6kjX5Zueh1WRt?=
 =?us-ascii?Q?PQ2LINiwDkjrUOhC9U+ZVxkdkAohruDcsRBuQtKRhpepA8xmmdk0XQ15oqDq?=
 =?us-ascii?Q?LpRLoV1OhD/kr4p2CpweQ9uVwURVk8MojAoXNVF3KCGn4bYUmvLk7QQLcSj/?=
 =?us-ascii?Q?fJgWmZEmVV8MpHV+nUstTo0tMeOMf8rHy5j7fubSscZOuVnezG1vYem0dnMe?=
 =?us-ascii?Q?+qGY1MBuVGxwffPF/ZaKQ8iUK7Ccrbq9jCq5iQrCxUqc30E2lw1ImzPwwckW?=
 =?us-ascii?Q?nUWSAR4X4EODyjhxx5mWg7EMBwJJOwMlldtM7q/U1GIhau0CVs3XHir30y0n?=
 =?us-ascii?Q?WCWLpzb2hllE4m7tQkLGgK53YL4kLBaakv3vdHS1VtO4VfIxa5bRSL1Bbk39?=
 =?us-ascii?Q?JQZnlLvErKDw1j0VcEEVfBeUFoJkT+DQf8fOtqLdoyt4cxmthZmQ1n+3wG7I?=
 =?us-ascii?Q?KzLW2RQvzEwnOCj8bsvFGTMui8Qy7PNOwmgshWrLv8GiCOoia9e6O5KOsw8R?=
 =?us-ascii?Q?lvsRmAz/+iuleaTm+lJsdHhToDLx9xGjKv/ba7Hf0GZFeFDLZFIgSKowI1OY?=
 =?us-ascii?Q?+9gb2aheiMf3va/5AlKbB0WV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afbbdad8-30af-4109-b3bb-08d962f83595
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 10:00:43.8851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ee4tgshG8k+HI9CSKDhROmT9wvF6BOTCEWal6mMpe8u4neIrXP++GWgtFTQKM6PqW2VYLnHLtvKQ7rP5/iLZm1sSQIUXLJtEQerK3HsvJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Wed, Aug 18, 2021 at 23:01:23PM +0800, Vladimir Oltean wrote:
> > @@ -718,6 +734,15 @@ int ocelot_cls_flower_replace(struct ocelot *ocelo=
t,
> int port,
> >  	if (filter->type =3D=3D OCELOT_VCAP_FILTER_DUMMY)
> >  		return ocelot_vcap_dummy_filter_add(ocelot, filter);
> >
> > +	if (filter->type =3D=3D OCELOT_PSFP_FILTER_OFFLOAD) {
> > +		kfree(filter);
> > +		if (ocelot->ops->psfp_filter_add)
> > +			return ocelot->ops->psfp_filter_add(ocelot, f);
> > +
> > +		NL_SET_ERR_MSG_MOD(extack, "PSFP chain is not supported in
> HW");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> >  	return ocelot_vcap_filter_add(ocelot, filter, f->common.extack);  }
>=20
> Hmm, I don't really like the idea of allocating an ocelot_vcap_filter whi=
ch we
> don't need for PSFP filters, just to kfree it later.
>=20
> Is it that much more complicated to not allocate it at all in the first p=
lace, add
> a bunch of "if" conditions that allocate a VCAP filter only if we are off=
loading a
> VCAP chain?
>=20
> And that means, don't create ocelot_vcap_filter::type =3D=3D
> OCELOT_PSFP_FILTER_OFFLOAD, because PSFP filters are not VCAP filters.
The "vcap filter" variable need to be created and use ocelot_flower_parse()=
 to get the type. If the rule is checked as a OCELOT_VCAP_FILTER_DUMMY, the=
 chain 30000 dummy rule will be added in vcap_dummy_filter. And not offload=
 to PSFP filter function. So I created the "vcap filter" and free it before=
 offload to PSFP filter function.

Thanks,
xiaoliang
