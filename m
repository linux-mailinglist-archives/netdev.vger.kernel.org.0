Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28FE4416633
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 21:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243012AbhIWTvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 15:51:33 -0400
Received: from mail-eopbgr1410103.outbound.protection.outlook.com ([40.107.141.103]:57989
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242861AbhIWTvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 15:51:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWL59iZvt/wzM4mW9dDpnIv8FU1sCz1hQEwRrETU4AB9m7Fxues0vGWTELeUoS8zRdwsRBvJ/ynHk1NmBPP1t0EoICGayfigm1dwZBgeHW/F+vMQkRdnM8/BcbvdZ8KuiHrqmVNAdhbj0AvTDrTTK3JYQuGoI5B+OFPyp1aVDizNpSp1LIU0wrnUEPKBSxYcikSCT3JFM8FNg2jAr5g9Iry2bZKbKmwfL5bmXPfuw5vi6TPB/Va/abKoWox+bzAzW0SqEUH15NWF5e754Lj6lCbkJJLeJBpUgYU9G5wb1lb3cPcdHGScNxVEgH5UHLxRDa5mEeDS4cQcQSbJZAP6KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=iiOnSiklG4RWHTpwiE1kkhrX051ss5fMEiESoKr/V9I=;
 b=IczX3HIj1amENt+HsaeL2fdkmGIf8jrpBxxamlcYnVIYP7Fe9DxlbHJs791A3SwXb4jDmmtdHAwhkyCQH9CXTuyrQCuHkbL8jKXC3iNCY3EFJRvG5R4fWTiQVf4Uip9JzGZ7PVI2vYr7JJ8lvC1aqYHiCnuifU2mHAA7xjnjZwv77ZJhV8KLs4ZSmZ29EkASnkO2vvo5rj3SgfzGzDAPcj7X3KODdvS5H9w8q2fG2nvcw+imlpsEwAqg4VUWU3TEPB0MPSiM15EzGP9nkCeMxB+WiTLrBrWD7fUw6+diu1Q3YQoXQJsjpv9vCFdzxYP0wct63HLUlR8ooClj5w5Wdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iiOnSiklG4RWHTpwiE1kkhrX051ss5fMEiESoKr/V9I=;
 b=MT6C0uHw3tLM17qqHf0ziEQ/z2XTTBSE7L9M6hAyUeAc7yL5wYv3ocS+6F0HVCHMRbGZgnvPtMcI05CnvX3jOMd1NamnhZXHT0USAzzZw0QmtwAIVQqFWGGAa8giQA1FEhkg+eh+s0eEqVfRUKrExTMl8ogvwuxMuD/Pb3AIKbo=
Received: from TYCPR01MB6608.jpnprd01.prod.outlook.com (2603:1096:400:ae::14)
 by TY2PR01MB2284.jpnprd01.prod.outlook.com (2603:1096:404:f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Thu, 23 Sep
 2021 19:49:57 +0000
Received: from TYCPR01MB6608.jpnprd01.prod.outlook.com
 ([fe80::e551:f847:27da:4929]) by TYCPR01MB6608.jpnprd01.prod.outlook.com
 ([fe80::e551:f847:27da:4929%4]) with mapi id 15.20.4523.022; Thu, 23 Sep 2021
 19:49:56 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Subject: RE: [PATCH net-next] ptp: clockmatrix: use rsmu driver to access
 i2c/spi bus
Thread-Topic: [PATCH net-next] ptp: clockmatrix: use rsmu driver to access
 i2c/spi bus
Thread-Index: AQHXr7nQycIf/kQI20iun4+FyujEaquxwHAAgAAQGjCAAAPNAIAANEYQ
Date:   Thu, 23 Sep 2021 19:49:56 +0000
Message-ID: <TYCPR01MB66086FB0DF1CBCC00F716A7ABAA39@TYCPR01MB6608.jpnprd01.prod.outlook.com>
References: <1632319034-3515-1-git-send-email-min.li.xe@renesas.com>
        <20210923083032.093c3859@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <TYCPR01MB66084980E50015D3C3F1F43CBAA39@TYCPR01MB6608.jpnprd01.prod.outlook.com>
 <20210923094146.0caaf4e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210923094146.0caaf4e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f38e323-b4cf-4152-fe8f-08d97ecb5208
x-ms-traffictypediagnostic: TY2PR01MB2284:
x-microsoft-antispam-prvs: <TY2PR01MB228453E7FDC062C84110B630BAA39@TY2PR01MB2284.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wwaoXt3LTjMIVzZo1eU02KxmVBJlXPaGbO91g1UJbbEV9YiCNm4wP0CZVBrviqZ7XPz2bMFdW34zlT1Iz4l/K2QAZQbMiyYr3xdF8nZXb2dafZYSX0zxPuiBhurIMKdpp2+DVptadPAcgwd7tmXeoo6ZwJBnif7pVlgl8l1SC7eI2x+U/j/2os2XQ6EGSglwU3X/kP+5BZ1zPK/7pwnuRVEi3Keid3vwS6yiOWZuRSDwqek3c3+K0UValDfd4A9exaOuFcWmg7z2oAS/IKOMpMtyHri+0Wk19/Q4VD5923pIFJjR7XZTgjC6G+WRralLXAYoGoVLI3VkS/90IkCOkMQgel024unFqCMwGDlCblyPZLReYVL0kjdXLYPXVUJJSIERQhcV+CJABQVdblpevj3/lGBjVD7cMU0e3Efya89XWwW3O3roXUCFM2/QFjrosfzPfRk/CHZF5MzfPbbuW4x0Z+6N3u4BJ4G88FLuPlmSG23vjX2syrgLzsyshvaxPCbqkL9XuxTM8e3L9mgfv3vK8rRvNhLsAThbotZlE7zV59N1gstiZNUe1m0p8vsiTdGMJNYG77Vzw0cX7iFylEygZ41v/j0h6ZZIqT+1HO4PHejuM3QwpGXc6HhL3As1O7WxAzMV0H/f1msoQYwfajuzRrAXDz/aYxh2JU0B1swwJC7dymZyDhekqZkDI1x20xv776wMLAxEsV4LN1xkLg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6608.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(508600001)(52536014)(55016002)(6916009)(9686003)(38070700005)(38100700002)(122000001)(86362001)(33656002)(8936002)(66446008)(54906003)(64756008)(66556008)(316002)(66476007)(66946007)(5660300002)(4326008)(8676002)(26005)(7696005)(186003)(53546011)(71200400001)(76116006)(6506007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CXv2MVSQq97od5UlFoYK2pi/XRlQgukjR7rjNkFCocGSZGCj8NqHzIelo0gF?=
 =?us-ascii?Q?82lSedbrsvWCGNfLLq+tWfxknJB2sgmkLkYpxzkcXlYhkmnNvfaRWqPpoWOC?=
 =?us-ascii?Q?e/RIyZmXpysoDkO6F9lZLNgdcsKRcmo820qjf1C8fJSW+fLeNwAcabV73SLv?=
 =?us-ascii?Q?7q5F5tP3+RzTgPdE0y+6ZoWE8HxEvZuDYh8E6zy5ypu15+R6L7eu3ORiKIme?=
 =?us-ascii?Q?l8w7gd108wv12x4N68jiP3K2kgi2kbbuDk0NXY+5HM7TKnyMmWuXDk3Rf6Z1?=
 =?us-ascii?Q?O7lwLMGrV2c0sMkrFQpcCb+Vf0DtCL8QXtncu++C2lAhCs6Xgo50h03f4a8k?=
 =?us-ascii?Q?mhIwSU+aSMAGxspNYt384tH2lHmstivWC507DqOSQCGKkVwP3Ia4GCz24L/Z?=
 =?us-ascii?Q?DqadpPTxchnVZUvIIe7K6ueowOT6i+VqS+MDcQ8DWOP/5aMsokOXkbyTjb6f?=
 =?us-ascii?Q?5t/xl1HGWsIipZXUR1EF324NnxEY+2TDbKtVJMSEZ97oPJRSPv/zsN03lZeE?=
 =?us-ascii?Q?7LvWmau4J0dy+fSv7JyCzZUm2ZsylcbfDqcgXyDVQRi+huN9OS9rBibiLG+I?=
 =?us-ascii?Q?V1GTaJem55f7GT0Fn+tZNgqa3mN+FDtbc7i9TXysxkOFe+olfVablfg3jZP1?=
 =?us-ascii?Q?lGR3v7ay8r2+VAUhztLuzMKxshLFh7nayMPZIIB6+3gRgT6JptC1owYQ9qhF?=
 =?us-ascii?Q?YarhRPXiHfLLqUIxS+yZL1PS46z3WurENA1CduEiz2dsn/vzVlE8r/r7LiDn?=
 =?us-ascii?Q?NTehD/Bky9oB1FPA8wP9hb8xgIgnvtqruGp1aCDMmI4AdZ/ucV4iD3cSdLoN?=
 =?us-ascii?Q?Mp+dZKQPlx/CcpGjXWsuajuNSjTmPeZ5PDhFGKrP4RwDaGyKlUGs1NssoTvB?=
 =?us-ascii?Q?t6GensjtOeLJHJxwg0oiCHhlhykdHYMUZaGmrWCf67K0aU0QKHhyQ1Hz7XBx?=
 =?us-ascii?Q?Qe4nayyozhfk30FfGKp0w/unqX65Nvpk/Pl1Y1r4sCX37TOtWw/1sUoE4CB4?=
 =?us-ascii?Q?WX7/CxKHpEGP92rgHqA0emP3alwPDjp6SksjTKngoLkQT7Ye6NUg99aQTdVS?=
 =?us-ascii?Q?qXCCjmHgDTHZ99gxOL0zyBvP+KnZEnpkaxgLVeQf81VlR9/C/gnf2FnitWuU?=
 =?us-ascii?Q?1Cw0Qhnmvm8NkUV/2Jk9eSIhAmVfkSMEpfNdxQK4RZPIWHuVNyutzoG/jlHQ?=
 =?us-ascii?Q?/gqqA6bvtJuOx0xvDmUQWa2bDNeqw42Y5q/3wTcq0WRwaosAm/C4fcuI+Agb?=
 =?us-ascii?Q?oIKsC/on/qkf8reFWecPswRRXUxpDsAcbpGbstdN43v8nWzNXWI+yuCteozQ?=
 =?us-ascii?Q?7qOrA5UGXhMBW7eSbmipNqhn?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB6608.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f38e323-b4cf-4152-fe8f-08d97ecb5208
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 19:49:56.6321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0M8lpLvz8uMf4frX51hCAC+ke0t/UsIBEVGxUyVVesfuOaMzgA3Mtxzch1NbHr1oK2Q+jGlJQQhpxIaRnhE9+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB2284
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: September 23, 2021 12:42 PM
> To: Min Li <min.li.xe@renesas.com>
> Cc: richardcochran@gmail.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; lee.jones@linaro.org
> Subject: Re: [PATCH net-next] ptp: clockmatrix: use rsmu driver to access
> i2c/spi bus
>=20
> On Thu, 23 Sep 2021 16:29:44 +0000 Min Li wrote:
> > > On Wed, 22 Sep 2021 09:57:14 -0400 min.li.xe@renesas.com wrote:
> > > > From: Min Li <min.li.xe@renesas.com>
> > > >
> > > > rsmu (Renesas Synchronization Management Unit ) driver is located
> > > > in drivers/mfd and responsible for creating multiple devices
> > > > including clockmatrix phc, which will then use the exposed regmap
> > > > and mutex handle to access i2c/spi bus.
> > >
> > > Does not build on 32 bit. You need to use division helpers.
> >
> > Hi Jakub
> >
> > I did build it through 32 bit arm and didn't get the problem.
> >
> > make ARCH=3Darm CROSS_COMPILE=3Darm-linux-gnueabi-
>=20
> We're testing x86, maybe arm32 can handle 64bit divisions natively?
>=20
> ERROR: modpost: "__divdi3" [drivers/ptp/ptp_clockmatrix.ko] undefined!
> ERROR: modpost: "__udivdi3" [drivers/ptp/ptp_clockmatrix.ko] undefined!

Hi Jakub

I tried "make ARCH=3Di386" but it also passed on my machine. Can you tell m=
e how to
reproduce this? Thanks

Min
