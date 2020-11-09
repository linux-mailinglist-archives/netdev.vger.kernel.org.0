Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF2F2AAFB2
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 04:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbgKIDBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 22:01:37 -0500
Received: from mail-eopbgr140088.outbound.protection.outlook.com ([40.107.14.88]:6550
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728038AbgKIDBh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Nov 2020 22:01:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7HRKTTMVnmtnJ2bvI7HMckO9bVx3VU27KAb2HAy2fDA9GPJc8OvxGKEh0NIQpLpHZwdFW3rGF9vI75oxJHWHhpNH54yGucbyzX6Ut5lih2HNoqHkHzl0/5HiUyhY/CF3ZYwUIcB7FiO39LDKos0VuR7ZRmh3skhgkLyigL6XFWXwJcxgez8FXWXO/gHKv1oCSywl3oWUIHEHOuddABNIEzDRYyJlPOFGJXmAMAyQRbOTUTDIFPRSbHhwPTxsPBWV13UpuYCFG5DQzYk8CdpJFEXN7T7WeeYSq9ij0UVRgm6TfqJUJqc2D928W3yMw9sDD00iq60l4vLZ+70oH3Mjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5drY0RMY6uwLn6idje8mhNBqJUAXv3NC1d7Iwg4aqYs=;
 b=bd7EnG5yoY0EDjxabWa2/iaN5k6qGV1riXf9rhsl7dFzk25Nyd0ewEZA6tw7BCRp3SmxsBP5kDegh1EXSz4Pza4f0+IfKrtuyS65DcRFQbaDvw4XmC3VLY2zJzXN8607qvXdWJcbs2KJLb6STU4zZdWdHHjC+V+ptFjbF28NLU1NE9+lb9Gxs1qOSvPtRlCK9/vO6eWDEIkzO9/tinxqgGqldMTyUjBMJba9so0GOpL8kR8A6XyVagIZiTW0SJMAEXvmHaZ+G69CGGzDopE4NDBCTH0MUdEurUth+UOmBaV2YE7PzDOK/RwkDNPdnTmxotMBTM6YptXnSM0QYt5s/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5drY0RMY6uwLn6idje8mhNBqJUAXv3NC1d7Iwg4aqYs=;
 b=s/6nO5RWgsCVYf9yBSHYxKjTTgc6Yq0uIkIb+be+we9KocU1RTXimcJykWPAX08zqrgf36ItKvSiceNS74Evr4YQhZ9zcGTinGHg4i3z98synhrOBkc172ylwwRcWtMOX2UisAqYfUDJG5TX9uvrzcg9lecIZQVwDVSPHAIeVlw=
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::7)
 by AM8PR04MB7876.eurprd04.prod.outlook.com (2603:10a6:20b:240::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 03:01:32 +0000
Received: from AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271]) by AM8PR04MB7315.eurprd04.prod.outlook.com
 ([fe80::11e6:d413:2d3d:d271%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 03:01:32 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     zhangqilong <zhangqilong3@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: fec: Fix reference count leak in fec series ops
Thread-Topic: [PATCH] net: fec: Fix reference count leak in fec series ops
Thread-Index: AQHWtbR0cLl78/z7wEeCrdGvuGMwFam/CZHwgAARggCAAAJ5gA==
Date:   Mon, 9 Nov 2020 03:01:32 +0000
Message-ID: <AM8PR04MB73157728290E9AF743B8E59BFFEA0@AM8PR04MB7315.eurprd04.prod.outlook.com>
References: <20201108095310.2892555-1-zhangqilong3@huawei.com>
 <AM8PR04MB731568128C08B0730519E9D3FFEA0@AM8PR04MB7315.eurprd04.prod.outlook.com>
 <deec0b718f894de191a26bbe1015882b@huawei.com>
In-Reply-To: <deec0b718f894de191a26bbe1015882b@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fc7d2f35-3a94-4da3-3132-08d8845bc35f
x-ms-traffictypediagnostic: AM8PR04MB7876:
x-microsoft-antispam-prvs: <AM8PR04MB78763B7FC5BF71000887E987FFEA0@AM8PR04MB7876.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0vh1Zh/xzlaKwXSYih1dzVZeTk5O8Nvjw9Ya62jGHoPERZmmVDWjuArFFCTTHdOTYroKnqxwmq9xFSkLLV0z7kJWcv2N8k0jwyXWX/17l3/rXOJK+xZAz5EJQ2h4QbQy68BbazVJBapAp9bb+Z9ETSlZsG50/lkfsptgD2MTZStGBUfKto608Byn38c4Z74C96ctU7gJl7EeVU6IjujpRChKlIIVECdKgpzFC/LRvyrkhePrkJ4Jq/0f6dccEbH+k1sGEXMJRpTam5vX5g1qMLDQueIvd5sGhdM7WyLUaWTvEaXBUq/0oInH7SkOFan16i9c3B3B7DbMggp5R2zvAIW78vYjKU5h/x+/AocA1CpiVwbkBQ529IpE5PHDrNPzD50iQTQqg3O7TN8+zcvBdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7315.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(5660300002)(9686003)(55016002)(64756008)(86362001)(966005)(2906002)(66476007)(52536014)(66446008)(66946007)(66556008)(316002)(76116006)(110136005)(6506007)(71200400001)(83380400001)(33656002)(45080400002)(8676002)(8936002)(478600001)(4326008)(26005)(186003)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: leM+3QuhdrXAtxJFgEkcgelgjC4xu4dnoaLdFf+pBu88p6PWVnHkAZ/Xa5ymrW2Fc+bmVLoyP1z8biZRbrpNncnwfARpLHBWCdnrzw5fCJ8fO/sYTU494qjrGmOq12p7NHJ1Khwr6rvYhZfPQ3UTLxWbLGVDekMGBkUpVag3CiEtDzRMs1j5rdrG7rR3ZQ/bcJ0PgFl8KSDY3s5DxRCKKt9/+C3ZQsgx8UKMRIvTEdP/BxmnjlxXoA5mnPfRpN2/vn+aow/bZoCtrc1Ez+q0wwI4pEjXAnQ1iCXIuTodQ/mwMnGDzYpu+O3vRts4C9znl2T7XlimTtYhi4vKtT9olHZR+0rrBlCLIdecxQnCXnM/XySrP+NOxEW+7VJtqx9h3GFIKq/4ih1nEm+635AP+ZEaibvl+A2JCODbGOKrbUZXhwDxED9lcPmFNDc062tFBAZIk7jfovNXKIfUvrA3nGSIt9LPgfFEOhsctsfbfLGO6VFbmG9n608I+zNuPd9sHuoP4WmXetMYQlBlWeQDWFg4GElnuG+7Mihb66b+fIc+QXrAMiSWgeOTvad7M5dekM1vjZ+a7UFWn6S0enWWoL36jJx7G+HuU8JQwWYNYvgVL9ZHHsAedB7dnX6BPy59jcFji5pItjFWiU02SXA7dA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7315.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc7d2f35-3a94-4da3-3132-08d8845bc35f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 03:01:32.6784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XbJlV4I37efIx04bcDSTGHDqo7IhZgsNJ1QJHbHQqc4PvbIpESfa9l/yswmw8y7ekepVyNtixvRloRF58DaHCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7876
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhangqilong <zhangqilong3@huawei.com>ent: Monday, November 9, 2020 10=
:52 AM
> > From: Zhang Qilong <zhangqilong3@huawei.com> Sent: Sunday, November 8,
> > 2020 5:53 PM
> > > pm_runtime_get_sync() will increment pm usage at first and it will
> > > resume the device later. If runtime of the device has error or
> > > device is in inaccessible state(or other error state), resume
> > > operation will fail. If we do not call put operation to decrease the
> > > reference, it will result in
> > reference count leak.
> > > Moreover, this device cannot enter the idle state and always stay
> > > busy or other non-idle state later. So we fixed it through adding
> > pm_runtime_put_noidle.
> > >
> > > Fixes: 8fff755e9f8d0 ("net: fec: Ensure clocks are enabled while
> > > using mdio bus")
> > > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> >
> > From early discussion for the topic, Wolfram Sang wonder if such
> > de-reference can be better handled by pm runtime core code.
> >
> I have read the discussion just now, They didn't give a definite result. =
I agreed
> with introducing a new or help function to replace the pm_runtime_get_syn=
c
> gradually. How do you think so ?
>=20
> Regards,
> Zhang

I also think so to avoid so much duplication code in function driver.
>=20
> > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flkm=
l
> > .org%2Flkml%2F2020%2F6%2F14%2F76&amp;data=3D04%7C01%7Cfugang.dua
> n%40nxp.
> >
> com%7Ceaef5020d1c143dfda5208d8845a6391%7C686ea1d3bc2b4c6fa92cd99
> c5c301
> >
> 635%7C0%7C0%7C637404871050135426%7CUnknown%7CTWFpbGZsb3d8eyJ
> WIjoiMC4wL
> >
> jAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;s
> data
> > =3DGLi34HRLzzTnTjT54dpNXkMdvuPuyVhcSuAGqc1rdvw%3D&amp;reserved=3D0
> >
> > Regards,
> > Andy
> > > ---
> > >  drivers/net/ethernet/freescale/fec_main.c | 22
> > > ++++++++++++++++------
> > >  1 file changed, 16 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/freescale/fec_main.c
> > > b/drivers/net/ethernet/freescale/fec_main.c
> > > index d7919555250d..6c02f885c67e 100644
> > > --- a/drivers/net/ethernet/freescale/fec_main.c
> > > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > > @@ -1809,8 +1809,10 @@ static int fec_enet_mdio_read(struct mii_bus
> > > *bus, int mii_id, int regnum)
> > >  	bool is_c45 =3D !!(regnum & MII_ADDR_C45);
> > >
> > >  	ret =3D pm_runtime_get_sync(dev);
> > > -	if (ret < 0)
> > > +	if (ret < 0) {
> > > +		pm_runtime_put_noidle(dev);
> > >  		return ret;
> > > +	}
> > >
> > >  	if (is_c45) {
> > >  		frame_start =3D FEC_MMFR_ST_C45;
> > > @@ -1868,10 +1870,12 @@ static int fec_enet_mdio_write(struct
> > > mii_bus *bus, int mii_id, int regnum,
> > >  	bool is_c45 =3D !!(regnum & MII_ADDR_C45);
> > >
> > >  	ret =3D pm_runtime_get_sync(dev);
> > > -	if (ret < 0)
> > > +	if (ret < 0) {
> > > +		pm_runtime_put_noidle(dev);
> > >  		return ret;
> > > -	else
> > > +	} else {
> > >  		ret =3D 0;
> > > +	}
> > >
> > >  	if (is_c45) {
> > >  		frame_start =3D FEC_MMFR_ST_C45;
> > > @@ -2276,8 +2280,10 @@ static void fec_enet_get_regs(struct
> > > net_device *ndev,
> > >  	int ret;
> > >
> > >  	ret =3D pm_runtime_get_sync(dev);
> > > -	if (ret < 0)
> > > +	if (ret < 0) {
> > > +		pm_runtime_put_noidle(dev);
> > >  		return;
> > > +	}
> > >
> > >  	regs->version =3D fec_enet_register_version;
> > >
> > > @@ -2977,8 +2983,10 @@ fec_enet_open(struct net_device *ndev)
> > >  	bool reset_again;
> > >
> > >  	ret =3D pm_runtime_get_sync(&fep->pdev->dev);
> > > -	if (ret < 0)
> > > +	if (ret < 0) {
> > > +		pm_runtime_put_noidle(&fep->pdev->dev);
> > >  		return ret;
> > > +	}
> > >
> > >  	pinctrl_pm_select_default_state(&fep->pdev->dev);
> > >  	ret =3D fec_enet_clk_enable(ndev, true); @@ -3771,8 +3779,10 @@
> > > fec_drv_remove(struct platform_device *pdev)
> > >  	int ret;
> > >
> > >  	ret =3D pm_runtime_get_sync(&pdev->dev);
> > > -	if (ret < 0)
> > > +	if (ret < 0) {
> > > +		pm_runtime_put_noidle(&pdev->dev);
> > >  		return ret;
> > > +	}
> > >
> > >  	cancel_work_sync(&fep->tx_timeout_work);
> > >  	fec_ptp_stop(pdev);
> > > --
> > > 2.25.4

