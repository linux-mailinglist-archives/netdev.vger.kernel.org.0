Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C03D3189E2
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 12:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhBKLxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 06:53:52 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57730 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231396AbhBKLui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 06:50:38 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BBjD96021304;
        Thu, 11 Feb 2021 03:49:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=+5NbkP6ZjGpRje/NICs1Yc92Zt3BNev3RcAWTVb35ec=;
 b=SQdYDNdJhdGX0Nqbxin3LIj4zhvJgbwSbAf7NXhWB7xHIMAFsectQlP9/YzVsD7wpjaM
 9Y133RUpDpf2Vnp6LTEv7qCtG1DIzkCrnm6yu8QFvk9txfefmNuRFHG7yYbj84cf28Fi
 HkKLvUZVC05lwE3k8NV5dez1S+EXcnxbFyMiD6GGDNCvLIk/yHAV2blVOCh1sdwuee1P
 22OXx0kVT8cdotkQ5gR96c/jQzqVZiXxmA1pJPO9uaibojd106k/uwbo/wgghAXfes5G
 wXYwLAwcl/523LkQtJmmjPTGcP/vpdJrtLgaY56vZj81zQTbpk5aqqT1fFQsIzrTRkLU 6A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqejp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 03:49:28 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 03:49:26 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 11 Feb 2021 03:49:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZfM817u0oV5YvibXNJ9saAfmCMbX9GWXgsqIewQn5DCIZ6hYMGzi3mUEF7htwQ6460X/AFRxbZ7j9Q8NL47Ewm31RLkcw87/YrjwfOeAX8qRx/yGvCIa5KUrlcYfKrfvtaHzXpDtJ1YJAH9pZXicvfDBGGL7JTBPxQBue665iM9rmFN8N+ORZUG6qGaHdQDShR4rfyVUptevJLsaxC0K3ZAni5ZMhYznNbDk+PhhaCFFrK6Tjx1XVN2r584kYziY0R/kz6qDAdMzeqxS576cyFiU4KDpVoPCtTHEfFqhdnQdQowDk7HunPRd92WfbzAQIeJIOGCoOHEiZ8oQUjehPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5NbkP6ZjGpRje/NICs1Yc92Zt3BNev3RcAWTVb35ec=;
 b=SMPLxL+uZ5LWNTTTqCsn+21e3TkaL2OFii8JkxexBXHFEbFl02RkzU9GaPniRbULJ25wCgXiJIQNrRjAxO0VXxZa6I86kJLYB3x/7t3dzBvRIcJcHstieWhQ7kqm5JYZoVUsCmgH0heDp/VucwHtTJ5qau2megyf7qi+ErwCu1vI/LUeP34pa6VGAARhurSy7DjiB6IDBuSKqY3Iv537ytQYnD4q42V5HocbnN8PRJNs1jGN3njzyTkLbOiI0+eim7WBAqW9ftAYLz2is3YrgIF+haDyQYe/1DYrrhR0ZTijbSSKdYTfZ7sGqi10+zFCDg8rId965qO4SQncFEOncw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+5NbkP6ZjGpRje/NICs1Yc92Zt3BNev3RcAWTVb35ec=;
 b=okicaxzjI2CvL7xgzGRKYEG4v9aiii2xUN+b9PLW6AhVRt8ZcDfhUTwDk57ka2/lKAg1R5Hz5ayFR0CpCkgBFRAgGUOZmzfjuTxTe4sdM6pSzDxSjSk4Q2Nz6YoKAcVz08U/LsfZdS1zKQ/KAIeLPshn6qNiLL1YX3xr0iJ8OOU=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW3PR18MB3514.namprd18.prod.outlook.com (2603:10b6:303:2d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 11 Feb
 2021 11:49:25 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3846.025; Thu, 11 Feb 2021
 11:49:25 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [EXT] Re: [PATCH v13 net-next 05/15] net: mvpp2: add PPv23
 version definition
Thread-Topic: [EXT] Re: [PATCH v13 net-next 05/15] net: mvpp2: add PPv23
 version definition
Thread-Index: AQHXAGPWXLwlpUz4Jka63qgQr+Wit6pS1TYAgAABjpA=
Date:   Thu, 11 Feb 2021 11:49:25 +0000
Message-ID: <CO6PR18MB38739CA874F3748919C8361CB08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-6-git-send-email-stefanc@marvell.com>
 <20210211114238.GD1463@shell.armlinux.org.uk>
In-Reply-To: <20210211114238.GD1463@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.25.16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e71256e-3fc9-4a7a-9bce-08d8ce831492
x-ms-traffictypediagnostic: MW3PR18MB3514:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB3514747FB679E4C1F16A8659B08C9@MW3PR18MB3514.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XTrbi4nWC1U7AD4FDCWcrhbP4xn5UxRjqheEYPMMkNh3NI+XiF9xhaF9cmKV5VI/IW9dymS1m1GwPLx4s8hjrVVjBP/eSISxc3xzmLHGx4XKZAi5WghhN219Mc+BWECfmKZy9qNt59r/FyG58NJHmNCD2kMJOZYo6JqQ6t5a1SgnnrqIAwpjs83vitAPy8erI1MbyBNTUNRCCTGNdLKeO5db7I4Y1eTU8fYZdFdOvGgVWbQTnR4HTtzmkByz26q4lr79ztqjX5g0DtPxA31cDRgI3aeqUj9DMp5PhRkHdCRD5SjBuKqZvgxLSLU5UBPJrGgzPn8VRI0xw152TB6qONxC/zfxxfOVjN1nuulk0Xvv4U3sclmx1HE8t8mXfc+vPPYjQC9s8lbFb5vNTVvA7HcDsc5qs2LpIuAaFmiADIWi0Nz5ynW6KzJU+9BFCpS/aikudWo92UM1pTY1Yr8Uc2vr0aAr1EOOHoGtBHiUd8zWd3CSBIASyYj/B23wTOKM90hIGTQlohdzNEk5JiC+rA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(8676002)(6916009)(4326008)(2906002)(186003)(33656002)(478600001)(9686003)(71200400001)(54906003)(86362001)(316002)(66946007)(55016002)(6506007)(76116006)(26005)(66556008)(64756008)(8936002)(7416002)(5660300002)(66476007)(52536014)(66446008)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HUATo2IlTOdej9/sqM0wIgKziG9IKte+MlIjhoKwW6L4kfsMfB7MAO9L4cJm?=
 =?us-ascii?Q?FuZT6YBH+olpEfEDsxiYtAkB10hgxw58HCoVS8znqD7yQmq1EeOao649Fx2c?=
 =?us-ascii?Q?RvSFs2brQbOLJhKBjsZX5G4L8HuJnOjPRmW22xoM5bwtvdzs4/EZQnP+hER2?=
 =?us-ascii?Q?XHbiY20/i65I/opF8bz5b4xT14TdHt/QlMQ4ADh4UUI6ddj3GPO85HiSbCgU?=
 =?us-ascii?Q?IrDeVbycihVxc4T25lbXUFhaLLvJB697GZBdwi8+7uT/6xIkzFGcVnb4kJ9X?=
 =?us-ascii?Q?sCFU06X8GiB1aysqroiZEreft7zx35ExLCC9Hpf2uU4nAQ4D1sreMDTWczT7?=
 =?us-ascii?Q?fJ/BwxXjv9V/qNu7A2D3U7cctxVkfNWle124JnII9XxMwEyuJTdL7qkBYgkK?=
 =?us-ascii?Q?h4MkpD7qn1gzGILc8oBTu3i8mDDVPoQbZhRST3FmAv/PaM5O3Lp6x/zYYYvv?=
 =?us-ascii?Q?byK0xBElXqMdktvTBlHj8CtpW18jSUx4nrL/6eqeoLIRSl0Ven8gIDBYtpaW?=
 =?us-ascii?Q?X5O5nfvCQL0aTDDFXaFM5mSMgCSenSFBXJ11v4wAoNHLSaAkG7HBgJJXr2Lx?=
 =?us-ascii?Q?vggiUXfejRFO7x/waclJu8AO23PvoyQv71F6cFNW0W0IDrrf7LlAPWN5dZAC?=
 =?us-ascii?Q?WRqIB6/F4/ILY17fiSSxTw2bxkwdOU9BjksvmQbbZydMRwdKHPCYnf2nkFsA?=
 =?us-ascii?Q?oubLSCGHZRU131SUGA5jSC43HyTPLYQ9S70/zOco/mqoWrwt210rznQ8eCz9?=
 =?us-ascii?Q?xWJy7IkEDh7qMFz6bHn2+9CDWEcNsgdtLrcq9+7xKklRMUa8o5uxfZvHcMCd?=
 =?us-ascii?Q?dUVlL7UUf3DKH1JkR1oURYeW4+mRCadI0c1aTE85BDKiSO8l9P9TXpplPFbu?=
 =?us-ascii?Q?agtcDzGUWeRCKihDsFDNU4R/WIwRnnaUXedMMUaXxqhGmellekNJ9YM3JK5j?=
 =?us-ascii?Q?yceT2dyMxxvsQcvQ/hIfP9aDtFjzI9r0dx7ZmVPfZGwnW+wPkRTzlNJkq398?=
 =?us-ascii?Q?ibrYGcVxIE6TfVxLH+EuhvHi7YuM1ZFW60MzBXPnlty4MkrqLRTEMNoVqvtL?=
 =?us-ascii?Q?+v+FqIpyZqd0AytH6W/5Vnpak0H3iXetyzUKf1x9dA19l/loH/z0kj12vhBn?=
 =?us-ascii?Q?yDcIXfYMU6LIsaROSr2XMtaUrEt+DOe0F5/nURifeQtWnIF4C9iL6a28MSB9?=
 =?us-ascii?Q?P6BMbRe7HXT7h1u8DYKu8ecrSx9VK9TiVxuh+LiT2LABnGlL5ljrdQNRS//r?=
 =?us-ascii?Q?ySpojPgwefT+W+Mn4eXeYd9uJQW3cBFWuxCKJk5TMOZCKPGRavEO1GXmd1f0?=
 =?us-ascii?Q?jOI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e71256e-3fc9-4a7a-9bce-08d8ce831492
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 11:49:25.3089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GjKLNWnJc/6JXYb68QiEIiQpGdaecoXYtHZ4jwINBECyMQcb0OgCR8/SxEywGtP6AlkXwvTxZ1pzl/qMJ9eT/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3514
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_05:2021-02-10,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> ----------------------------------------------------------------------
> On Thu, Feb 11, 2021 at 12:48:52PM +0200, stefanc@marvell.com wrote:
> > From: Stefan Chulski <stefanc@marvell.com>
> >
> > This patch add PPv23 version definition.
> > PPv23 is new packet processor in CP115.
> > Everything that supported by PPv22, also supported by PPv23.
> > No functional changes in this stage.
> >
> > Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> > Acked-by: Marcin Wojtas <mw@semihalf.com>
>=20
> Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
>=20
> > @@ -7049,6 +7049,11 @@ static int mvpp2_probe(struct platform_device
> *pdev)
> >  			priv->port_map |=3D BIT(i);
> >  	}
> >
> > +	if (priv->hw_version !=3D MVPP21) {
> > +		if (mvpp2_read(priv, MVPP2_VER_ID_REG) =3D=3D
> MVPP2_VER_PP23)
> > +			priv->hw_version =3D MVPP23;
> > +	}
> > +
>=20
> The only minor comment I have on this is... the formatting of the above.
> Wouldn't:
>=20
> 	if (priv->hw_version >=3D MVPP22 &&
> 	    mvpp2_read(priv, MVPP2_VER_ID_REG) =3D=3D MVPP2_VER_PP23)
> 		priv->hw_version =3D MVPP23;
>=20
> read better?
>=20
> Do we need to even check priv->hw_version here? Isn't this register
> implemented in PPv2.1 where it contains the value zero?

Yes, we can just:
 	if (mvpp2_read(priv, MVPP2_VER_ID_REG) =3D=3D MVPP2_VER_PP23)
 		priv->hw_version =3D MVPP23;

Thanks,
Stefan.





