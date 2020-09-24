Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D5A27663C
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 04:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgIXCKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 22:10:06 -0400
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:34030
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726281AbgIXCKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 22:10:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOH1zJ2EFZxcDneWgksjXsfGr1a4TJ/jd6kcQsbYvvRALUjsCsP4rKitrkuPQlCejb00A6AXOdEnVzEoo1woLDnyhT/gL/DjR83dN/e9u1qmGKmqkFyfIiaJZ2/iM9sQh7Ig+QjjCUk/l3AMOsTepucGOg01VRGCIlRz6AMT0bPaxqusMpuyEAOMb7Gv+Ur7juNZOdvWV/95N7InaHJhACG723+1uyCuPSpVDZ/FkvEpBYTKhVIjwEd002UDdruWsQnVyQF9rGbs1Bp6aEYprmfH97BQDXH4Bfpcmz5vQFjX9JpRDF0gklE4O5zapFOw9mkuQfj3xYIPXFeRiXyN/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HMDrciIwSRKB/nd2xieV8mRKRoZjSK4cG8NwA1x7idg=;
 b=ldcSZF3KXhRW/JmcMoDF8vCRX6eYfukJe+zaTQGXV5on6I7NM0sgDt7Vo+OtoqvRmCbk2PSIaQGTAexL2hB0CJ1CpbcBAN8nwjEkIPiT50SS2nFc7hcW2WvLWfTFot/rKv3zexMZ9faCJj/YxpXYYCfWMzYFkAKXu2Ra5R6E7N0pIlOgsqLzfeTVxLh1Ymdu2mzzqzB4NvzeRkEFQc2Helmcji/uDAo44wB1oWgFqwaW/SL8TOPCirmkauN/MK4AK7PBTw0/6ItBDm1tlPYYppMouq9qrtnLbKP7MpNxEdkdubTHYejAT8U5xZGyBhrwu5jHUTPb6L2y8sET/RhSFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HMDrciIwSRKB/nd2xieV8mRKRoZjSK4cG8NwA1x7idg=;
 b=G9f4bo65KH9Brq4F5MGnmvvigya9Lxs4OpV5X+Yh3G2uZ/9oxkv6vlF4TbM6TaSb5W8hMgEljfo4ncow1iiJlw5reyvZXHu6WoRPgGc+MilichPdlRO/KP8geLSjTZ0Cy65tZ+fI6KnRhGCw4IEwQVDgWCPO737XimkCQV69M2c=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB7PR04MB5307.eurprd04.prod.outlook.com (2603:10a6:10:1e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Thu, 24 Sep
 2020 02:10:03 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::2174:5a93:4c29:2cf4]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::2174:5a93:4c29:2cf4%6]) with mapi id 15.20.3412.022; Thu, 24 Sep 2020
 02:10:03 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: RE: [net-next] net: dsa: felix: convert TAS link speed based on
 phylink speed
Thread-Topic: [net-next] net: dsa: felix: convert TAS link speed based on
 phylink speed
Thread-Index: AQHWkM5TaOCnSiK1nk+I7CbW7JsXual0h6+AgAKFUFA=
Date:   Thu, 24 Sep 2020 02:10:02 +0000
Message-ID: <DB8PR04MB578529D733A50F048A1EB793F0390@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20200922104302.17662-1-xiaoliang.yang_1@nxp.com>
 <20200922113644.h5vyxmdtg2dickpg@skbuf>
In-Reply-To: <20200922113644.h5vyxmdtg2dickpg@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bd686a65-8c9e-4648-c97b-08d8602ef2c5
x-ms-traffictypediagnostic: DB7PR04MB5307:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB53071F23051D469EFCE2F116F0390@DB7PR04MB5307.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KqbjcsPZiHvi5ygiu3pOwf1b2hn47qJwIfRhlU1FhyRlL7x1kqgLnv1fPaGByhLLl7ryIs67IqK1ejfiJ9QlDnRdKfdrxPEIQKwlSqEEBTTRss7Vl4PWccRKmJlFq46+LoGXj5u4tgFKf8GjDLnWoiEqrKChB8cV5g05iXYUs/YFbGJ0qRdbz/PyENCnXmatbsmlrwkGrrsKEE9uCv13gBfCnEXS9eEm7f96MH67akz4aatKJcqWPvhBzz20xXg4XfKD0EZ7BJOBkf0TunU3JJEHA1X4SJPLIu/1KfHeWvNb01DuvC2ZJHhAwC+h0/Y2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(86362001)(8676002)(316002)(71200400001)(8936002)(54906003)(66446008)(110136005)(64756008)(66556008)(66476007)(5660300002)(478600001)(6506007)(55016002)(4326008)(52536014)(7696005)(66946007)(2906002)(33656002)(76116006)(26005)(53546011)(186003)(9686003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: P5Up9HMlCx1Ehd03XnUDjnqZvtx7mpgQnVXi76np5o7nx4sEDOcU+2HqGCz+CkYNBnRFvf0BgKiiv98qEE1IhWoCFAPuV/EjkZVqdmTYj2UOxUYys8PqMeZDsfWsLrkh8GsllPRupoSz1sKX7v+GSVLBCZCsi4SKXd38PKs+m0wZ9yKHPW2JIBe+Vzm5WBR5ZWpxOU4QO2hGwxVfVW51cesoEpZFLbIXiWMWrgAMzFhrG4A5oAmIfBCdutcX64UzDeGQFI6BGDDP6RL6ZHfGVA0WzUWStCoRyp+V2+O1xtZtyXZHSxtI0w5FniRzMEVzwwJ6k5fFMKO8y1YqpIz+63K79rO7RIsu9df7RSVnpJF1qS+f+gFMmBYC621kKjxMBbaypddbBo8ln+SAjPKCc/7MeTxVDM7USy2mmsUHmeGFLjkuFkZSe6UFoLdeVc9K5ixtHXx3waeLaJln5RMK9njaW+7ea0Nfzvw+6FpdZj84kyKXeGAK0RcbODgbXluRLBJvxvGZuLTJb/tfTucRWvw3eOpDjky5ji/kbBb6vl//d5uuOTeQPCBEb0faYhfmSyUMPB0pQc8oAIr3rprn+AD+HZeuJlilBtQdrNOC8IDDWaeG1bQYvbuu17ricVLyHMowK8P3ka55HLO2grOQQQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd686a65-8c9e-4648-c97b-08d8602ef2c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2020 02:10:02.9176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ioxk8/6R4W/vMS6P8rd5Xwg+gtv6Zfu0I7kq/vDaVYHdYuWGAkFAHhV8O6Sp0TFMBTGXXEGC44LKA4Fv9ADkdpiJ+Tf6I5jvrwoH4IwZTqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5307
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, Sep 22, 2020 at 19:37, Vladimir Oltean wrote:
>=20
> Hi Xiaoliang,
>=20
> On Tue, Sep 22, 2020 at 06:43:02PM +0800, Xiaoliang Yang wrote:
> > state->speed holds a value of 10, 100, 1000 or 2500, but
> > QSYS_TAG_CONFIG_LINK_SPEED expects a value of 0, 1, 2, 3. So convert
> > the speed to a proper value.
> >
> > Fixes: de143c0e274b ("net: dsa: felix: Configure Time-Aware Scheduler
> > via taprio offload")
> >
> > Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> > ---
>=20
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> But next time keep in mind the following:
>=20
> - The Fixes: tag should never wrap on multiple lines, even if it exceeds
>   80 characters.
> - Patches that fix a problem in net-next only should go to David's
>   net-next tree. Patches that fix a problem on Linus Torvalds' tree
>   should go to David's "net" tree. This one should go to "net", not to
>   "net-next".
> - All tags (Fixes, Signed-off-by, etc) should be grouped together with
>   no empty lines between them.
>=20
> Actually due to the first issue I mentioned, could you please resend this=
?
>=20
> Thanks,
> -Vladimir

I modify the commit and resend this patch to "net tree", please reject this=
 one.

Thanks,
Xiaoliang Yang
