Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3B814A32D
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 12:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbgA0Lnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 06:43:53 -0500
Received: from mail-db8eur05on2079.outbound.protection.outlook.com ([40.107.20.79]:6259
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726210AbgA0Lnx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 06:43:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoorGe/rUqrpcw2vIvSw4g7Aw2oZLCErIcEv9DgL0+kAijIuELZxk9h5sLlClbLcoOH4osmLd/7zNT8UZ8TglM4vAKD1nwshkQPp4Sr9uUYV5r690Ri9V1MtN9zy2QraQLeyCN/82FExa+wit1EYztZdHEUc6AbIKxEVQxnoPkl9ftWhxf6tvZY15W/3lSDS7PehiV5ohpjvoaSlOBOVa5zfbux4nPpfL9VKRBtYkquoXSQ95XHazioigpEZ1LzWfSIy5bj1xX/T9cYWFAtL1Ia0BJnhtF/hIU6uPsZa/1bej95Mx7dXbcOhs5qc7JcAdhYIPA+RtG2qMY40QwNKuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIngfjI75VLckPIzvaoDorlrNdQ2pJL+MFns//uBN9c=;
 b=RxHT/VMJg4EgNu39DhuqY+eZ0p07ah4sgQcc4BCLLEXun2b73iLC1U1zg6ZOn9PkQl6MUdp1Big5aGrIOiciD27JMzwQvTkRljfMZ3dspGXrMgK3NiWLL3IBmtxmTsjAdepF8/jwyHAWCvWguddGFM6ys1inHBGaXRk7kJmkqBR8eQGOvw3OvwvH+QS176jVIy/LJPO/rgfkjfA4VeZPFxB+eHD+nUq4Lf52J/KZF2imVaNPnmzp0OYhEqTAqvIU2yO+BYhfWawa9imjfKPnkbpaLp2oTsyhwLnH5sy+Rub9OL+rzDCCyvHyz0lI0KbNfRZzTgX5u43vhDM+r1BwfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JIngfjI75VLckPIzvaoDorlrNdQ2pJL+MFns//uBN9c=;
 b=Z/aLYsfrgIUqH3p5zHopBVTNM3iWT9+Og4BUCKa4QZIkuI/HZ+Kd8xMx30rs0yoHyAaVn3l9Y9OCngk4uXs9u0v27G5dwCBrxsJIW/A7sGUuATIbc6SsS3aUNpgXIKN1xsiZtlC4JH/o3g9qduVHtJGOnyIy459Fn91XlUtNubk=
Received: from AM6PR04MB4774.eurprd04.prod.outlook.com (20.177.33.85) by
 AM6PR04MB6694.eurprd04.prod.outlook.com (20.179.247.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.19; Mon, 27 Jan 2020 11:43:10 +0000
Received: from AM6PR04MB4774.eurprd04.prod.outlook.com
 ([fe80::48e8:9bdb:166d:1402]) by AM6PR04MB4774.eurprd04.prod.outlook.com
 ([fe80::48e8:9bdb:166d:1402%5]) with mapi id 15.20.2665.017; Mon, 27 Jan 2020
 11:43:10 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH] gianfar: Allocate the correct number of rx queues in
 'gfar_of_init()'
Thread-Topic: [PATCH] gianfar: Allocate the correct number of rx queues in
 'gfar_of_init()'
Thread-Index: AQHV1Cnp/aGg7k6RokG5M3Bmrty8Qqf+TbxQ
Date:   Mon, 27 Jan 2020 11:43:10 +0000
Message-ID: <AM6PR04MB47745F475F454DC598A8D771960B0@AM6PR04MB4774.eurprd04.prod.outlook.com>
References: <20200126092028.14246-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20200126092028.14246-1-christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6e1c0ef3-a052-4e26-dc6d-08d7a31e15ad
x-ms-traffictypediagnostic: AM6PR04MB6694:
x-microsoft-antispam-prvs: <AM6PR04MB6694A0BBBE3237AFD543CC47960B0@AM6PR04MB6694.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(199004)(189003)(186003)(478600001)(26005)(55016002)(9686003)(71200400001)(52536014)(8676002)(76116006)(66946007)(316002)(54906003)(5660300002)(6506007)(86362001)(44832011)(66556008)(7696005)(4326008)(110136005)(81166006)(8936002)(2906002)(81156014)(33656002)(66476007)(64756008)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR04MB6694;H:AM6PR04MB4774.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZINFnuJILXsXvPZ5zzxIW5fXeLKWjtbGqLrp+zDw+erBJJYoiX6c1di8ksTr3oqedL3URtwPIO7WuLkMO9Ip4nzqCFZQ9VEQTQYSurukA635+PXri7yI4cq280gstnu7HS9w+VGrcOdANtHwLx91gTMEGoMDoyi3XJ5SHd0YLvBW4Q9d27+3E3WnZoi9bBrqygyArDA28cPoPO1a69v27V3GD2iQV7mYnzlyX5UcyTSuOAtd7eSufiUSvN5i0p7KiLTt1wMS9piUPW2EHsAg4uln5dqbw4sif/n/YrrXpnIJe5vCwN94jlVqvDuXD7sd2ccIJQtW0i/Keia1lfDRrZ7f4LXIhZai8rDSQMzRADr00ZL/xS/2feCR2eAvlNx00veXRM9BM2Juh9pE1V09ci19+DU6vze0bLZZs9NOh8Xdl7Amwcm9HY1lUQcDOoBm
x-ms-exchange-antispam-messagedata: A8iS136VnmeKhcTIQ98zkHntlW+I1Wd8Ass/BEYUHY1tl/F4H61JVtErTw2AhPEvqC0bvXH4FGq0bPAWjtlmv+6jFwRt/WGQ7tVSzOWKp5XuXfyPbGC6rR3A0vC2Ju4BiMq0jaiebqK4CEpzsCIHoA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e1c0ef3-a052-4e26-dc6d-08d7a31e15ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 11:43:10.3646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 664UAMe8TBku55K22C1H87rxiOM1+6pbFyEvB1AALITjbV8b8X/kB5gIY8wrj+2r4ct3c4VS3JOcqdFjsDluIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6694
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>Sent: Sunday, January 26, 2020 11:20 AM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>; davem@davemloft.net
>Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-
>janitors@vger.kernel.org; Christophe JAILLET
><christophe.jaillet@wanadoo.fr>
>Subject: [PATCH] gianfar: Allocate the correct number of rx queues in
>'gfar_of_init()'
>
>We can get values for rx and tx queues from "fsl,num_rx_queues" and
>"fsl,num_tx_queues". However, when 'alloc_etherdev_mq()' is called, the
>value for "tx" is used for both.
>
>Use 'alloc_etherdev_mqs()' instead.
>
>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>---
>WARNING: This patch is purely speculative!
>
>I don't fully understand the code, and tx and rx queues seem to be
>allocated by 'gfar_alloc_[rt]x_queues()' and handled with priv-> fields.
>I don't know the relationship between queues provided by the core, and the
>ones specificly handled in this driver.
>
>'netif_set_real_num_rx_queues()' a few lines below is also spurious to me.
>If "fsl,num_rx_queues" > "fsl,num_tx_queues" it will return an error and
>things then look out of synch (i.e. 'priv->num_rx_queues' is set to a valu=
e
>bigger than what is allocated by core, that is to say the one from
>'priv->num_tx_queues')
>
>If my assumptions are correct, I guess that the call to
>'netif_set_real_num_rx_queues()' is useless
>
>
>Sorry for the noise if I'm completly wrong.
>In such a case, some explanation would be appreciated.

Your patch is reasonable, you rightly noticed that something is amiss,=20
we could reasonably say that:
Fixes: fba4ed030cfa ("gianfar: Add Multiple Queue Support")

But the fix doesn't change the behavior of the current mainline code.  That=
's because
in the current mainline code num_rx_qs is always equal to num_tx_qs, and bo=
th can be
either 1 or 2, depending on whether the platform has 1 or 2 CPUs.  The GFAR=
_MQ_POLLING
mode option is never set, not on the mainline at least (you can look up thi=
s define in the code
for comments).  As it is now, the GFAR_MQ_POLLING option can be activated b=
y adding an extra
if statement in the driver, to select it by a special device tree compatibi=
lity string for example.

So, the problem is that this option to support more than 2 Rx and 2 Tx queu=
es in the mainline code
cannot be accessed without modifying the driver.  Supporting more than 2 qu=
eues has shown
considerable overhead in the past.  So the decision was made to support onl=
y one pair of=20
Rx/Tx queues per CPU by default.  However there's no easy way to change the=
se defaults at
runtime, and switch to GFAR_MQ_POLLING.  And so far I received no feedback/=
 request to support
GFAR_MQ_POLLING upstream.  So I see several options here: 1) remove the GFA=
R_MQ_POLLING
code (something I was about to do 6 years ago, but I was prompted to leave =
it there), 2) come up
with a way to activate it at runtime, 3) add support to activate it at prob=
e time via new device tree
properties /strings (not ideal).  Any suggestion?

Thanks,
Claudiu

