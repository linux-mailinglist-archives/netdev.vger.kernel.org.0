Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1397AE2009
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 17:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404548AbfJWP7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 11:59:35 -0400
Received: from mail-eopbgr30070.outbound.protection.outlook.com ([40.107.3.70]:37947
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390259AbfJWP7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 11:59:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VaPMGnHDBtO1Dl24bcnCTCKVEOTaDDPHd5phBLvwzJkb9DNAJKnHcW2cfWixgFMc9RKpySnXVDPOqBvIWJ9FTITf8T0+EQtCTNoIjxn9FxF9YNmJtpVpbHPvCIlFseVvMXatmEBWDHOFcAg3TTcjKA3zGvy1gsXRIX0Wg4kcATFiO9UW142PwNbEkA+4iKGbiySHyfV0K2sjqZh46dm9u3c8luUkROrtRWtD8T5FHke7h/s0fnE1y9DV8PVM84eYNGKxCjF9kak57e79Tkc2Ry78ND6vOAdS7LgFVLv0p+IXD9vKDaHqLwMdOhqKMXW7MxZqYRPSsH79mi80NmQFRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mR7YNpAiACH2EK9FuWFK9cY+7pUoRC5Bi/5Aw4QQyro=;
 b=Y9iBZXHuqq1k/DVHAtLRd74cG3guQLmja7lwWzZqw4usiMUa7UhxJvpydpY3A3BmWppA58qdygoSE5N23fU78yzryyGW2by00vx9SkmFiVrMJyN/8ogNRLDLEtraU2LlEv5cAtiE3Ev6+dpkaXFYdaG04OZshBEdG8BzDa89S01P/T0GWEfVcyf+YrTEsLRugnhrKnDl58s6hCSVLfRn9RaUS2Nxtgx7OR1cHef67/ieuUsEXgVJodeUO1454cQrh//9imSDJgQeIXFsCH1UoCof0Ez5goSI0O2CnhGucPnMKI5VdfOzf40wysxRsk6b7ZccRtVE9eFJMCSQCWOv6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mR7YNpAiACH2EK9FuWFK9cY+7pUoRC5Bi/5Aw4QQyro=;
 b=EYegZLYavmp7N2ZuxPNYUOurZ9MtZ8NsXp8ieUmj8WqAjtFuHTPudM3xQJQAVHcG28YnfM83h0BPBtiPf2tDRM5FkASmsOXE5FMPDlx8g3aauN0ADUILXidrdyuQS7fvxwdnPJ19jHSCf6uQq3V/7Ri/Dx7M58/3LZBJ9JtgDMg=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3789.eurprd04.prod.outlook.com (52.134.15.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 23 Oct 2019 15:59:31 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2367.025; Wed, 23 Oct
 2019 15:59:31 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next] phylink: add ASSERT_RTNL() on phylink connect
 functions
Thread-Topic: [PATCH net-next] phylink: add ASSERT_RTNL() on phylink connect
 functions
Thread-Index: AQHViZ33k+js7C6uIke2Z+ttv9mMow==
Date:   Wed, 23 Oct 2019 15:59:30 +0000
Message-ID: <VI1PR0402MB28006A194ACDCFAF145D1DF8E06B0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1571833940-26250-1-git-send-email-ioana.ciornei@nxp.com>
 <20191023131032.GZ25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [86.124.196.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 19aa2156-1eef-497b-6dcf-08d757d1fd92
x-ms-traffictypediagnostic: VI1PR0402MB3789:
x-microsoft-antispam-prvs: <VI1PR0402MB37890AA2BC6422DE683E7CB8E06B0@VI1PR0402MB3789.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(189003)(199004)(229853002)(5024004)(3846002)(446003)(476003)(14454004)(66066001)(66446008)(6246003)(66476007)(76116006)(14444005)(66556008)(2906002)(81156014)(55016002)(71190400001)(71200400001)(33656002)(64756008)(81166006)(102836004)(256004)(6116002)(66946007)(25786009)(8936002)(9686003)(8676002)(478600001)(44832011)(4326008)(6436002)(486006)(53546011)(6506007)(186003)(26005)(305945005)(7736002)(74316002)(52536014)(5660300002)(7696005)(76176011)(99286004)(54906003)(316002)(86362001)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3789;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 95MhCMFwGubtVC1nq3fgk1PhEoy3Nm/5/P3QSWAqNrDI2X/9o47O3XoH90J11V/nBChWbpVIBHc5QbAnC9pyodoy+ytImzcn7aJyQxFs97+fN5nNP0zBOfVETrVK/bjpaAX8Nywv5KldC/bYunFdqHd4VYIiP/H5ifxAjJmMRaxKUozVH2K8Vfmap4uHG3TJVnYHPi+goOjctQMq7iV99GfOcxzsPGH+kmUCDtzVRBZRvvUaNgaLGQlfmqcX1grEG0SQLu1CnlViAfeyeCOnsdX09Y4sEoUzDYCnkHbUysRBtcUoZDQkRY3mMM0MIPv7O4GcZd93HWApyjCR2LDloKcYl/UNag4ZXZdT7tynBRP0p77Kf2bIt0Bvqy4gabsP0MUT5JKpuwCPva7pb5ZlwXe/ijiJVoHdKm1aRHNpUeDUfYnba4GmCpyUkETLbIIZ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19aa2156-1eef-497b-6dcf-08d757d1fd92
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 15:59:30.8908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +7OgNw9CrSXfLGqbvfUtJXSDRzlThv5xDQ59cJoigl11qdtAzjCPPTJcUwN8KdbatWq3rCGxHxYLjMnM7BCDyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3789
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/23/19 4:10 PM, Russell King - ARM Linux admin wrote:=0A=
> On Wed, Oct 23, 2019 at 03:32:20PM +0300, Ioana Ciornei wrote:=0A=
>> The appropriate assert on the rtnl lock is not present in phylink's=0A=
>> connect functions which makes unusual calls to them not to be catched.=
=0A=
>> Add the appropriate ASSERT_RTNL().=0A=
> =0A=
> As I previously replied, this is not necessary.  It is safe to attach=0A=
> PHYs _prior_ to the netdev being registered without taking the rtnl=0A=
> lock, just like phylib's phy_connect()/phy_attach() are safe.=0A=
>=0A=
=0A=
Yeah.. I was trying to catch other errors like in the case of dpaa2-eth =0A=
where we also connect/disconnect when we are notified by the firmware of =
=0A=
a DPMAC disconnect.=0A=
=0A=
I now understand why the assert is not always needed in the _connect().=0A=
=0A=
Ioana=0A=
=0A=
>>=0A=
>> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>=0A=
>> ---=0A=
>>   drivers/net/phy/phylink.c | 4 ++++=0A=
>>   1 file changed, 4 insertions(+)=0A=
>>=0A=
>> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c=0A=
>> index be7a2c0fa59b..d0aa0c861b2d 100644=0A=
>> --- a/drivers/net/phy/phylink.c=0A=
>> +++ b/drivers/net/phy/phylink.c=0A=
>> @@ -786,6 +786,8 @@ static int __phylink_connect_phy(struct phylink *pl,=
 struct phy_device *phy,=0A=
>>    */=0A=
>>   int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)=0A=
>>   {=0A=
>> +	ASSERT_RTNL();=0A=
>> +=0A=
>>   	/* Use PHY device/driver interface */=0A=
>>   	if (pl->link_interface =3D=3D PHY_INTERFACE_MODE_NA) {=0A=
>>   		pl->link_interface =3D phy->interface;=0A=
>> @@ -815,6 +817,8 @@ int phylink_of_phy_connect(struct phylink *pl, struc=
t device_node *dn,=0A=
>>   	struct phy_device *phy_dev;=0A=
>>   	int ret;=0A=
>>   =0A=
>> +	ASSERT_RTNL();=0A=
>> +=0A=
>>   	/* Fixed links and 802.3z are handled without needing a PHY */=0A=
>>   	if (pl->link_an_mode =3D=3D MLO_AN_FIXED ||=0A=
>>   	    (pl->link_an_mode =3D=3D MLO_AN_INBAND &&=0A=
>> -- =0A=
>> 1.9.1=0A=
>>=0A=
>>=0A=
> =0A=
=0A=
