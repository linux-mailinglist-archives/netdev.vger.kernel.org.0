Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE0D3F072D
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 16:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbhHROzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 10:55:17 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:44747
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239340AbhHROzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 10:55:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnQGetI+3iw4NgWSjMmn2pu6W1DuarUi0ufH3CDMCdyzGO6lD0NPmbIjQEkyzfBW4oKERuaPUTLgHZQ86JdTEFY8IzsUGGzgh7yAezqYzn3sN91p6HI0v4SoWNI6JQrvBpi5FV2SM/kYeAQy9At1w2HYdXW2DerMsso97XpmFIE8iy40kvxUv4cjIlVmRO8/2O7aW6urOlcrt+Icb0sfE3GZSUFXkKYK0+hGj/RWJLn+WUp8Flzi7oG3R2vcImrP1clU3BGTrYv/H16J+Lk6y71b3XiglGr4hi5uCNqTr2JRhN/L3xvMrbmwmSjEKgGRyxQMGR4ilthn5UOn4YbYOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4eefxCfyVYWWnFQ2ggMGUGmCIYCAWVQhMETneQWB7E=;
 b=XYXS1/TyBp9oown+EDw+yBtYHTKmJ9g+W0tTUbSNchOboEEd1MQ1mlVhxtTtNRyKNUVBX7PYObW+Aoyra2E9U5gxf38uHGrslPBthX80wKig7G039/b7hlknjCr7JuYIO7FpGLABBfgHiOYWW3AghQx+jmuhxrlXeEIcs1WzyGpgIZtyy0mh60Dpv8PeD8KmgJE54DLLw25zd8sArDn+6UFzfICNq2Uca2QA30VgxdWdvQSvvPsOT40OReN49lTeGx9i6DWtP9wF3AO5sJRQ6NrQEIc67l4lolKieQ35wZwoHGIuy6vVhlQaEgQ4OP95MsKsL/0WcC+WoOKFmHjUCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4eefxCfyVYWWnFQ2ggMGUGmCIYCAWVQhMETneQWB7E=;
 b=G856ShL2akVR/mHfLqJU+cBRefJb4WjaiWmNyHAApMIgQX8giPYrul2HL9go+Bm+ai0hHilsf/RY8XMJ8AqXaejBrvS3AnTM5AcsyDi0A2UZ8PJn0D788lC8p99GFqzpCI5ap0f+eXztYdAFPPx2dT3wWJBD1ja62aj/5SqgxLc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3200.eurprd04.prod.outlook.com (2603:10a6:802:d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 14:54:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 14:54:36 +0000
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
Subject: Re: [RFC v2 net-next 3/8] net: mscc: ocelot: set vcap IS2 chain to
 goto PSFP chain
Thread-Topic: [RFC v2 net-next 3/8] net: mscc: ocelot: set vcap IS2 chain to
 goto PSFP chain
Thread-Index: AQHXk/d8w12R5e6WKU6VaUMTnYcT/6t5WfyA
Date:   Wed, 18 Aug 2021 14:54:35 +0000
Message-ID: <20210818145435.bsbxuq7bbjr4fkel@skbuf>
References: <20210818061922.12625-1-xiaoliang.yang_1@nxp.com>
 <20210818061922.12625-4-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210818061922.12625-4-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5a833db-7ef2-4732-61fb-08d9625818aa
x-ms-traffictypediagnostic: VI1PR04MB3200:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB32009E732A243E18844B93E9E0FF9@VI1PR04MB3200.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NOxn9v0tYTzaGo/qFIfhZmQCQBHt1cMCYCljuUxTUqHdsdYjJlGp97XRAwrF41ep1LGqkXO+RfTuV085SIVGIFZuvooB6lVFr3kBXcw+P5gGiJU21dzZO1Wh80aYHtEeI67vZMbFFaYzQ6myuItcoGOd0zyw1MIRNhnnk4RSI8bXmajFkyF8EILo86PvjDHfu9g4v6Tr8JcKcu/vGHUr58ZLCWVGddmEUhhRkfF2Mrohat8JROhFT0ekePW0ikb0s2RjF5tv9v0FW2wc13IEd7RPFeP4GkiZ9nSLYCxhb6PtMOs3u/Vq8uPMEMH31xUpHhBS6Dwf/9ToD/A8IaSvfivsOcAax1csK5eWtZjodeI9Pwq4COf7ItvrVm4kZA69ysSptmYp8Ki0HBjzJZvLTaVVD1ZC+3CVXpvRzxBt/6YzRgQAGiN5H+xdvUskBfxVF5gDAVlUSx0NIo8NLv34knXHqgB9YxsiM0DV46Mgu4761FIIeK0WClhPDUMcCxTjpN87whe3aGR/n5N3E1ic0Gp4UGoPg0LVzIStaRXbBjm03SiDusWTzowN9NjcRURAOP2P4nv87u/d0Znt8E39MItQ9lv4m4DDNLLNe4KuDDTuJByL1eSZJzXAK+dWs+VCvJs/qpUbFIXHGhha89t3U8h34xqz40D8Pm9DMNpRcVKMc2+1IzPqICWf3fQf0avpUfWl7HfclamU+GVm2B6VHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(8676002)(33716001)(2906002)(8936002)(6862004)(478600001)(316002)(7416002)(1076003)(54906003)(38070700005)(4744005)(5660300002)(6636002)(64756008)(66476007)(76116006)(66946007)(66446008)(66556008)(4326008)(9686003)(44832011)(86362001)(6486002)(38100700002)(71200400001)(6512007)(83380400001)(122000001)(186003)(6506007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?e15FeqcUmItcu1luLbk8iqzA1qUzNxA9t5v2yGWLM24bartU6Gzok5JEyX1a?=
 =?us-ascii?Q?vz8hYfws4lHfnZ7+wVSkUa1YmUriO2Bd30CrIDPaAcEkMSbL3tumFccU3dJk?=
 =?us-ascii?Q?nKHYGd2CT4od+jzMPSPZxVuISPVlXfgbGIMQO2yMwlH6I+HsjOMp/zDrnde9?=
 =?us-ascii?Q?eLJKHsxvB0iM4e5lHYbjyRggcx8dfcaDNEhinfgQY4gTg0lNFstABQFm6awu?=
 =?us-ascii?Q?coz7j2oC/RhFLYz6hxOqsXa5DthIEZM1GL5fRDZeep38Fwi8tZizTkw4VYpK?=
 =?us-ascii?Q?FU7em3ohTuXC2Yd69pK9SvEY/G6vVKsFgpqM0Ckgc366ksr7DzvAbZMQH7RQ?=
 =?us-ascii?Q?4SaqKj2mScEEmXFPZF0KUkabdmls8GMm0Dlvh3drDQXmRitqoDrJLnqxM+GV?=
 =?us-ascii?Q?s1CHowHGpv0p/CTFUKFDQXEOlt1m82lSaf6OoaQs04n7rynqtAl81E4TJYtG?=
 =?us-ascii?Q?80dBiK3A6DC1AGRHx5dl410jqTat42+JEXvonu/oClFoy1WcFV1j+m3KdTOO?=
 =?us-ascii?Q?fjRxgQd0lEBqTGuaINxLi6ZGNZ+sm3gPVWNr8oJD3lf+d6AfyoXNV9Xk6Msp?=
 =?us-ascii?Q?HVmJHTG07vx9tguzro+hzYJfxPuOsxEEbBiX+4KzomJWkcGvvevEEAK4v97j?=
 =?us-ascii?Q?wkdG9T3TSmJw224k0ed0rXnssM8HvaiqjDZUSQNDwa2zHjKaZbk84OzaWEW9?=
 =?us-ascii?Q?C5cyT1jfLx1yx/TCOHK1BVKCodteCAbmUh3vanGlZX0irFRwAbKgC+w49JAo?=
 =?us-ascii?Q?V9k/n3bZ5FS8Za6+GdmxK2R57AbkKC85g1b5CCBS4jbZGQbb6DTYKK0Ua7mw?=
 =?us-ascii?Q?HQrn2hPx5osxAHJwazZUkonnge0ixLzaXocf4peh4otpfI7gVMmWhqd9k2Wk?=
 =?us-ascii?Q?CeYVZ/rvYSODuI7fmgzvycPMyFsVcCZ7bY7rTiQ8YcPT7Y22c3iQV+HXvh4n?=
 =?us-ascii?Q?7JOt2nP5CjABax6Sk8Ekd8KsD1baroJNgpSXMawnV6hjRYxjUKJdXLxbXXeh?=
 =?us-ascii?Q?SgxABHf+sX8bRFrCYzJJi7R7b1FDt39FM9Xfs5hihRpcyXcezcxyAk0FB1m3?=
 =?us-ascii?Q?h9dGAS94/KdZAv0fCLxfIOJCoczeIahfzq5LOO7T6jks+QIvbtVvuCQXuF5A?=
 =?us-ascii?Q?sALlf0MgrS6PEfq/vpl3Q88wIlCPezrPawuXOZXFauuUahaewNHNOL0sLGOF?=
 =?us-ascii?Q?Hnz9bSootYZYxhRtR892xRfzgLuN5rFY5qaWl57FBO1I9NDQ7gMiG/zWvNu1?=
 =?us-ascii?Q?eggZ7bVHxupRd7NjrDh7Uk1EFHkAeopfXRNcuZbimtVtFaCBcRHA6v32e79w?=
 =?us-ascii?Q?AsMMVBw11DSHIGTSpLSvhz0I?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <827A99EB718D2E46812A01C820EC38CA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5a833db-7ef2-4732-61fb-08d9625818aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 14:54:35.9139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uNrWU/NrD5fsMw6rxWu7tubthq4TnstV/qiPijFIS1y+b8ob0Ol25bnPr6n0BO/pCpX8pe/Ilpv9euUMiCfjjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 02:19:17PM +0800, Xiaoliang Yang wrote:
> @@ -353,7 +364,7 @@ static int ocelot_flower_parse_action(struct ocelot *=
ocelot, int port,
> =20
>  	if (filter->goto_target =3D=3D -1) {
>  		if ((filter->block_id =3D=3D VCAP_IS2 && filter->lookup =3D=3D 1) ||
> -		    chain =3D=3D 0) {
> +		    chain =3D=3D 0 || filter->block_id =3D=3D PSFP_BLOCK_ID) {
>  			allow_missing_goto_target =3D true;

I would like to not allow missing "goto" targets for new filter chains.

Due to legacy support we must keep support for VCAP IS2 on chain 0, but
ever since we added the ability to offload multiple chains corresponding
to multiple hardware blocks, we should really use that precise chain ID,
and chain 0 should just goto the first used chain in the pipeline.

Makes sense?

>  		} else {
>  			NL_SET_ERR_MSG_MOD(extack, "Missing GOTO action");
> --=20
> 2.17.1
>=20
