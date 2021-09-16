Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A0940DD62
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 16:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238972AbhIPO6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 10:58:04 -0400
Received: from mail-db8eur05on2077.outbound.protection.outlook.com ([40.107.20.77]:8481
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236506AbhIPO6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 10:58:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/jXwyqLW0FSe2+zZ4RyrFIv4OGRSHcbHlFb2MnQxshwTgdMsF188+jaf27TsvARLKBz+Z2pQX6UYQgS5h8MUlhbTXlRHydSx0rzrkCxvxPhN0bRHKCphnuXrVGfDUCqZwbPaVY++eOk+VeOvSDvX9LGylj21Kb1tszej0xkheiE69QbjEGVEV3MyXPGBgYIx9AlRLzg76tmf9X8U5dKQ2+ucVaqDAZvYC1sJKCHwl90IDicYmBWF5Kd2Q6CpM1bl7MULKS9GWxqO+6+z1495kuMHfnAM85+h+nFvpZJ1/W94SOmvRO4LjT5NcAx4kPbJqVSBOWsuWb20BIMRYen1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=LX5uBpkvS+X0t0UJxXfAowQFnWSBo/tqpsbi6aedkTw=;
 b=jt41KbkNMbve/64grkCx12HXuKEgolCCNzc+OH75+zYHmk9V/LTX5d4VpOOTW50j/Bas22a8vwL8zkFhIzjIjiyJGmx4oDLiXKoQiFJbVygZqnmrr3nF5kpIBStvhrr0d/V2ri5zDruTXXqDlfhtzk+OrqXtHul8C/epAnkGRifi5mcbbWTdV6yZJQs0mMU1LfeBcctgaO1FcHbIKlGRJgYuE7aN8bE/pfs1pvsiIZZS0u0zLBiJc6JO6Huj75VgSnJjZqJYCOPQiU6P4G9SdZBniU50EE6HTKASP1unoTZIKN08aWiRlK5r/ZGQQ3gvGdVyS/h4W8XC3s8l41ar+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LX5uBpkvS+X0t0UJxXfAowQFnWSBo/tqpsbi6aedkTw=;
 b=ctMtk6OzkpJwnzJ6QKWoq2owcZ0auLor4uulXiIcnfc8szWOxn+LCzuYNKdGcRqNw59vblnPFWPdW0fHB6u8pQH3hl27za99WuSNGTTk280nMhP4uB9JqfKVJ1RQD8PWKpkGAvr2/mkdTRWcX5fT/5bcAu+Rf55QxaQ5uE6uh40=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3710.eurprd04.prod.outlook.com (2603:10a6:803:25::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 14:56:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Thu, 16 Sep 2021
 14:56:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Colin Foster <colin.foster@in-advantage.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 net] net: mscc: ocelot: remove buggy and useless write
 to ANA_PFC_PFC_CFG
Thread-Topic: [PATCH v1 net] net: mscc: ocelot: remove buggy and useless write
 to ANA_PFC_PFC_CFG
Thread-Index: AQHXqpeh6y6SRE8JykW9vsuy+tc/X6umjJKAgAAzO4CAAAEcgA==
Date:   Thu, 16 Sep 2021 14:56:38 +0000
Message-ID: <20210916145637.yu63cf3mzkkx2eg2@skbuf>
References: <20210916010938.517698-1-colin.foster@in-advantage.com>
 <20210916114917.aielkefz5gg7flto@skbuf>
 <20210916075239.4ac27011@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210916075239.4ac27011@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73b16e82-485f-4b8e-7e68-08d979222f78
x-ms-traffictypediagnostic: VI1PR0402MB3710:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB37100EA7B6296160271EDC99E0DC9@VI1PR0402MB3710.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rg2wGN1vWM0+b+nuKjUGd1CrRGhDDjIqFlKufWUpp3asSrJbLeiXJpKaJqqO3VD1+8SXmQbuAicbIgloHUDnrFtf27LUIFKpPzn7poNPzUdLofPOKkv08uN4isxXjr2YolyaaDT88qBLlwipvi2qAoVHP0NtNm+l2LICLi93kboWYWZV5e/OaMQRrqpVmjby0NKKsYJNH1Z+JS2fZ7Q7kRCTq4ZVv6AoX/+Jdg7O0HQOtqGdW6TkwUMiHbNwH/HnOM/dn3KugNjqLcDf20yWUv+vqREet7TJPfMfco7buJ4N2ltpO4J2jo83amyKRzwA51E0qyakhmzbcasgPGXYRnltMIQvzk8SFM71ebUNWsm0GTT98Beaxbn5KhY9x8qjCfM6SkNGS0/IkyXCI93zhgClIgJAB2R1XxXRpR4N46zRG9frudTIUdbUFEHUOIt0l3g/hcXwxly/+vC0gr4Yl82o7i5ZHgxNew1/Y8DJyg4ULZWPkhs1ifGGBdPkfYUiY4rJz44i87tG96KOiOOK1F84XpLLQCB4zwX2oont4ohyOgPlu/SI2QBnMUEbCvtCNn+RKEmSs/VcGRzZyqOe2HJP5RocoYbw/khT5/zsBchxkEURSyJ/hsg0wQwrJBfsCTir2wBCBviiSJOXOSk4I94A+jEFgj4OvvOMOrIEdqtSvlHBty8WNUW4Cn1MVUYVHrvUyaur68NAaTh2zw4ezoTZkcYB1QzSKNBhd5RUL4iB4IzbyICX+V5ZX+ImU0bEWt5cF1bmayDvyUX2xKTM7zE8J/PE6K7I17Ozg5LemUI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(38100700002)(8676002)(26005)(478600001)(8936002)(6486002)(122000001)(54906003)(71200400001)(1076003)(186003)(6512007)(33716001)(5660300002)(966005)(4326008)(316002)(9686003)(6506007)(64756008)(66476007)(66556008)(66446008)(38070700005)(91956017)(76116006)(66946007)(6916009)(2906002)(44832011)(4744005)(86362001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YQxbASJ6l/dAcRzgsxsR4eEUWxOLIAptWXQncffWg8QVqHGlMM5KF16o8EaI?=
 =?us-ascii?Q?wfMzBf5DSaUOu3AOBGv4i4EIr9GgaMYUDBOvnwwtbOynSsw+JMu5nQl25jWP?=
 =?us-ascii?Q?U0DVsqKs4/rVMqX3Z4vuYBvcz+tjM23xneGbOfJZmZPGTD9AHgPd8KQNf2zJ?=
 =?us-ascii?Q?zfgyVT4Z1XZO8CiB9zQvlGQ8QhXTD/roLekGHBAaL1PmITzNKoEM6ZDDZmhK?=
 =?us-ascii?Q?cqlZUYct7HK/IkotoMRvgwY9314X+A7a/qDOuoamlzN4fIhY0kn49glAkfT4?=
 =?us-ascii?Q?IiuFDhH3unVHrt9+OeBM0ADYgUQlqFcKbJRHPzxQo6LMV/ZRGhORJKqNJAqQ?=
 =?us-ascii?Q?n0as1S5mSdy59ginieEWQgRZwRyO0DRr66AdRWoTOIIAUnCda3iWSsG6Tnzo?=
 =?us-ascii?Q?uvc2opaaexEpM6i6+ELb/p/jm8eI/W3gEXYuyc1cwZyr5h65RnfXvWORbvHr?=
 =?us-ascii?Q?U3I5KeoY5RIydPTLdQ3uPjvoQl7RPVs9cYS4oPVztwqnc0VSZN9CU9CV/N34?=
 =?us-ascii?Q?RvPnlUkkz+NU+NKB4Jbhr21q33CE3odEycQCI3wXV5DMw+ZYzEGcQxjEguFU?=
 =?us-ascii?Q?tBSpws7Uo62qxA1PQy0dy+GVRD1fp92PUsumYTPzDsgePhk8IO0Z1sZZAeP+?=
 =?us-ascii?Q?jTJPjOkIl5HPOVW0nP+BBA66q6sFV7u19wgAhaHhybbf1fAZ18kMz6BaN18N?=
 =?us-ascii?Q?y5IFlWmw0wD5QRW+DPhYQ7pMFX98rT5OWOEPBE9f0mOpaA6c6fXsdV3TwddU?=
 =?us-ascii?Q?ZbxUdgVHAfcfsC93lF+TDClyVh3tNGvJA+c15O1cES8Gj4OCMQh/SGmICOmq?=
 =?us-ascii?Q?tQt7Slp6LZfTJQXzpm/USGMdRsNYIUU4TZbIeKSYz1qWU787QcBioT/GMXmn?=
 =?us-ascii?Q?DVkAg5GqimOQMTnmjVPs5m23C2wPuy0RI+Boe6rjy+2f4DJPqfASeugM1z5g?=
 =?us-ascii?Q?j4zv5TSsT2pXCXMUx5PuoWWmFbERvPEg7N6/Ce/OjYPg5/Cuj8QL4Gf2TLd5?=
 =?us-ascii?Q?Po1uHTeCOHlJCrgqEMqcDO1r0V3YPZse+V9xgIIULmsDljkzhsoHS8Pw0WCr?=
 =?us-ascii?Q?i4rV0Bj3J5wuDnUtTGVodkDF4Mo5z3pkX8cr3+RO0zdSBM2PjdFmaeO0C/Nv?=
 =?us-ascii?Q?vTYDVMEoF7fDJnF3M3wZWvtUR+TRPhM3ykdmJ5MSTVmmKoPqf1LbRHLNHy1C?=
 =?us-ascii?Q?fp/m2l9i4FrTx1xu/03TZWPJF9sTfUKfLz5oO2Oi67t9cwydqG5EiYZa0awH?=
 =?us-ascii?Q?CGAa/CZVa+gaEZgPDXcQTyw+GAKokiv6wi/0STCaxOToYSYzAXJoEUsIob+N?=
 =?us-ascii?Q?PI2kFIrTpy2zJAO3m7w1AmQlii0U1iHXh1Vl+jVnFPEJTw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D2D0D2197E2293489DF0B7B750BE8E01@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73b16e82-485f-4b8e-7e68-08d979222f78
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 14:56:38.0631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rvz6bnLDhSZSUrYCfbzcMAkDoml70PLT2EGOWqmZuB6qa7Y1WDJY+ggTBvgmQa0hdalZaxGLhDVdh4Z+QhEfNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3710
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 07:52:39AM -0700, Jakub Kicinski wrote:
> On Thu, 16 Sep 2021 11:49:18 +0000 Vladimir Oltean wrote:
> > git format-patch -2 --cover-letter
>
> Nice instructions, let me toss this version from pw.
>
> FWIW the patchwork checks don't complain about 2-patch series without
> a cover letter [1]. Having cover letters is a good rule of thumb but
> I thought I'd mention that 'cause unlikely anyone would realize otherwise=
.
>
> [1] https://github.com/kuba-moo/nipa/blob/master/tests/series/cover_lette=
r/test.py

In my certainly limited experience I have found out that forcing
yourself to write a change log and a cover letter makes you think more,
which is sadly sometimes needed.=
