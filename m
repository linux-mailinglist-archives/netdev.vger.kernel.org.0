Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BC330BE43
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 13:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhBBMex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 07:34:53 -0500
Received: from mail-eopbgr70084.outbound.protection.outlook.com ([40.107.7.84]:4069
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229590AbhBBMer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 07:34:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWB6IHbgaLHloCp37nayhsVPvFfTz47PWixLwoATi+4rF1DJ8wOUIWugjV19i2eOeUNsoEW0HH5qcLz+mQTrxzZEIxfjFiNAd19K5cgYzI4PCWiptZP9wZs4GnUGe79/+eneTqyVj2pCk1DyfQHG7eIRrbcGTHSQdyPbvz7flvKbEUrbJT+h9LjTQHEX7nDLOoXLACv6r7gVG7isAINkoama19XL6B8wtcZ0x+qge23ECRFJL2KFyJAsNCx6cg58dDyLJsVtzjnYKeeOI820JB0V1YFnWv4f7EDVKJa3TSH0apqPa6u02Gd09IX6tO6HrEqCj1Fu+w7PDDPFs+6VpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFGohC2cm+7hiKHqBequx4P2SZQOXjJ1FauRcCgjxmA=;
 b=j4xQUDB8jYQhCmbBnhDan6NOMHUqD1yAXw2DtMk/IqDdZLwHdlH1JOvhmv4SI3KV5F4GB66lkSJV0WRIMdaCKPCYEllK7FNnQOBpn+uKZpMpuM/meLn8XfN5XDrwn6WkQkJUD0gjeDPi8vuAGhTegwWIMduNfyvLWoJVuD4JxXR0Qj9PuEgh/aWE1gc4VeJDPDOZP+V7+AMi7Y15J9lLyqrl+aUyEvSwss1hvK92AKYrDsfDpA5E0VC/b1nvq0RmBV63A8+A+xlbLKp2K4QlP8dFPpFwClhoXJdfQQ86YHdzfEyFjr4OMFAy8r+KhJo7MbQMTpCvBaFkFAEoH1UxPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFGohC2cm+7hiKHqBequx4P2SZQOXjJ1FauRcCgjxmA=;
 b=cc3nSZ1Csx5fsKN9xbVrm8n8fLdzv2KDhQiW6jJsns0nFbefOXIoQ85MNEvJP7cPsuanl2FRdwNDk04mpeWRjgySDKx/i+MNQFM11qV6LkzZmTFiCVmtKdPCtX1edeLs1dDivy1O5SqwnyxFINOQlri5CpWHxruVLDfPMvxlQdg=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VE1PR04MB6445.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Tue, 2 Feb
 2021 12:33:57 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88%3]) with mapi id 15.20.3805.028; Tue, 2 Feb 2021
 12:33:57 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
CC:     Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH] dpaa2-eth: Simplify the calculation of variables
Thread-Topic: [PATCH] dpaa2-eth: Simplify the calculation of variables
Thread-Index: AQHW+UqUQ+Vok9fAFUqJqoxZiaDPhqpEzMMA
Date:   Tue, 2 Feb 2021 12:33:56 +0000
Message-ID: <20210202123356.ythsfeyfk2uuegcc@skbuf>
References: <1612260157-128026-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1612260157-128026-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 38753a5a-bc39-4860-687b-08d8c776cf6e
x-ms-traffictypediagnostic: VE1PR04MB6445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB644541AB6BC376DA6D1C4E81E0B59@VE1PR04MB6445.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PjgEQVCDTf0LQ/ox119qS9W5piSzRISbtoMzqdCmZpAJMvxd2eaeAQZEC7ku/zgi4bTUFjzzKssnjpikou2mTexQxtUWcS3+lP7iXE228H8yDz7Y1xnZjIxJPKdtWCO2bO8MFKVEC2IAHifK3IRzjkax1LpWnOgRplMatIzu1Wfr5XZWUSDe+x4bhxxHHFkB7kZTJAuF5ogJp+B2E6OERSRYx/bWiHc/WWzij2JygHrpEMcximPc+gboZ7KWPh11WBsape2sYt6N5S+XslivTxo4/nWBNajy9neIhm1/n2Rqwz5oX3S+Q3/MmF/jGbVmXvT9RcI6jZyAbdsCExa6jmEgjJr2oQtx09s7f/EMTxzWccszE2Y2StGYlsEDcTQBvFDsXGlBmnpMxqchkEYa49P4bcCitX91WTT8Pyo8uKmAkETMKPsNDudcX3kQUlAdmbBbEwPXCeUnVgjgB1/98LCx3bs2IzOIk+8vLoV/Wow2zOw6aYivOSiBf4ll8LinH9IoU2U/TJmc+Jtyq4jmhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(6506007)(8936002)(6512007)(9686003)(2906002)(1076003)(91956017)(7416002)(316002)(6486002)(76116006)(26005)(8676002)(54906003)(44832011)(86362001)(478600001)(186003)(33716001)(6916009)(66556008)(66476007)(66446008)(64756008)(83380400001)(5660300002)(66946007)(71200400001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?F52DJbvyfnHKvmmvDRMawPME0hvY3STOBMXydmkn3V2rs3VUYa8IFh0QRtAf?=
 =?us-ascii?Q?NZg1GkBEvoCW1dslXObk+x3DhFG0UZe6w/DOc0LFoMyvz/KR3QmtkD6Dr+TQ?=
 =?us-ascii?Q?8CBQYA1uiRBR8MW7n02clDIMN92zfmgNZ/Pb+bzE8gYHoIYpoceg70+ESJZb?=
 =?us-ascii?Q?0wGo6TrRJ8T23b3fMkOdcY8hLvGx0uvtgxyJ9Lpd1aqRemC40wW+N10uuwvI?=
 =?us-ascii?Q?deZNgeJzCJmgyLE5nHcydqWuzL3OmUVloxohQZ2M4JKPuC9/AxSmrTlSk/d3?=
 =?us-ascii?Q?Jpb62vLrxO94bVKpp+/da7a1CJMN08fFtv7TcS0jiyVj0gKF22uFfFni7DpZ?=
 =?us-ascii?Q?oQhqyQ8wV+zSggz9SJejkmDRDb9tAYWNQP8F1FJtOoLjYq7pESQiLGxJ3fR5?=
 =?us-ascii?Q?v3GArmOdCMUpaL55nQtL8RvoQDht0KoZ6ZjItPgRIYiFlSVXH/BFDkxMP+55?=
 =?us-ascii?Q?xgIFhqA29mcS0jFLdcPajLpH6jctXTffD9SsIthanelkkbHATjusWhvPhLgi?=
 =?us-ascii?Q?TOJcSuP3fO53RuqjNBs3ziE2W2ID1Aolpb+NDdqUq+uMwXOdk1vcN6gbqW2k?=
 =?us-ascii?Q?Kn2WobZGePgk5yEdEXZPV5cz81ioPejK1lvyFx/RKFebIX9fdUsILigMMWoJ?=
 =?us-ascii?Q?fS8QpCvaUg2Y7dtsjqOUrE7IgLv3Ff6qsG7aS04SZq1VBNH86nfHSkbP1o08?=
 =?us-ascii?Q?FQeJtIxoZwatM/tt7EDAatgLjsDprHTLBfNCdW1x2oXolGDfXnl9Sb2MWX2d?=
 =?us-ascii?Q?sm6l0T6zf1kCUo1BtTahfJ296UceUhLQ4YwPla5QpzrlUU/Hl6oKUZ4TpU+b?=
 =?us-ascii?Q?3ZqU/AaxtEtaVMlBnL6cLRZrGnrsftmAJz8FKTiMa+uFasw8CzNJVLc3bGDs?=
 =?us-ascii?Q?H8E1A00E2YQ9rkHXEQD90CRJRoV+Rc7FLgthd0P8ksyi59MkeM13m1yNBMvu?=
 =?us-ascii?Q?3heIOGhWXlt2xb4UbZAC87cbuDpzcet/uQMRnxe3+LU4O5T0KDkiK1b/AClT?=
 =?us-ascii?Q?7nRPGNt2QvyPFFt2N4WlOrJEkziudLN9WXy3L7NyzKVK3XrEX6UxUJ1hMXCd?=
 =?us-ascii?Q?xLp5lVX4?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28058608A25B884482ECA752160330CC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38753a5a-bc39-4860-687b-08d8c776cf6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 12:33:57.1553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AtNWTsV/AZ8j4kInmUjfyqmC3P/tG+LbLpYmyiIOQFokv9fXkbdU9EVTISsPyfVc8rZ96Q19yLjo1KZx92NiVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6445
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 06:02:37PM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
>=20
> ./drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:1651:36-38: WARNING
> !A || A && B is equivalent to !A || B.
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com>

> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-eth.c
> index fb0bcd1..93f84c9 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -1648,7 +1648,7 @@ void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_pri=
v *priv,
>  	 * CG taildrop threshold, so it won't interfere with it; we also
>  	 * want frames in non-PFC enabled traffic classes to be kept in check)
>  	 */
> -	td.enable =3D !tx_pause || (tx_pause && pfc);
> +	td.enable =3D !tx_pause || pfc;
>  	if (priv->rx_cgtd_enabled =3D=3D td.enable)
>  		return;
> =20
> --=20
> 1.8.3.1
> =
