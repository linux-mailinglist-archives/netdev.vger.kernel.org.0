Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD9B2F08E9
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 18:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbhAJR4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 12:56:10 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61118 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726394AbhAJR4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 12:56:10 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AHkG8D009646;
        Sun, 10 Jan 2021 09:53:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=6K8imtPctvQhlyKbrD8p1i8UyceElVaAwmQrQCcpYv0=;
 b=J//6/I6okos+3Wm/eTRGJ0Pio6FP1xAfJVX6q1hymeuG9dN9efqLuOB96Dlk4CHQWrcZ
 ESiNNPBqfX4+n8vlyRbZArxceF1yU1tisKxFm013CToxqAVEx4+iQnBxGsRckzAhELa3
 zCkTYbC7RGZ3b5H1SExVyBF6b+gQISQ6GbnTMoKujlXKPH6WEUukUFgfyl8jH+aqykES
 HMIcIBsHlAp5JP5FhzHpImHHwmYSSpHOS2B3cuZpBb7AfdEKBqtEDjdErMylaSXUlIti
 lv0CDoJXf54Jd7KO7hyJvyxwytlMwJg9zJAHm+zZHnboooq27g7P9kGQQhGxMFRbkNBp cg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35yaqsjau7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 09:53:22 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 09:53:20 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.59) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 10 Jan 2021 09:53:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4Pe7MSUES97BWUfYTh/vNhz3WHYbctBu5v58OuVCDp+XJQNkOZIAHt5Nbv+nJHxAli6NOnatUkqemk7rgaaRaFN2IKx9j7i3WJdhS1wIq5cKZSs5CUr7pmolv9Bdg0Qur0F0RibwOqc4MEVSqYI5IfmyKyYfSmDQP+omN3r9YN93/vegwGezJbXCQqa555iV19ZrKdIE8H63yNcGeVR4BiNZ66b9E91r2KdJE9zVHozeQjhOe2qTH2781KSc9BGamIUbhB63STIa6fhXECUvpTlVUx6YLongTWlxy84qK8rta5OkkZaPHuUV8/M/LLHWa11aFgeK0Tnbbh6/zZQtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6K8imtPctvQhlyKbrD8p1i8UyceElVaAwmQrQCcpYv0=;
 b=QSpPQjX11wec2VQsaeTMt5QZDDY/rdwM3/XPAVt2U51RfsTQMvUCkeu+YJBr29KUIYF4nRhrQm6B+JBZDKvw4ZH1/RjpaEowokZjh3RfrOcoxTdkSKAMpuiRSFYCf469aqCwQjfOeTkq7xQCKlvh8vfz9aHN1aobQ0THSn44sEkNhTnRHVL9de1Y3MfjzrpEyT4M6aldZ2stqQBqFX2/4lQCspSeE+UyaYaEnSQvBDtSb/2MNBRgM+SC/i8D0yw43jnQTpuAntXmUev8ClfBUrtik5fUwxgfmyeVtCuqAJ5iioQkTRhYWjsjOzmQvJHFyX4o9t/ERe+1Ko9KEYvGww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6K8imtPctvQhlyKbrD8p1i8UyceElVaAwmQrQCcpYv0=;
 b=kgh8sYHFvPytppFSSTRArVQAL5qMchwiz8n9f+qVTVv9B+as9kNEXPerx4uvMSiG6CQG8VMgXrwoKWp4PvoqotJ9fBJbJUqjOY7NTqsaJxNKEx9/jnV0bf7S9Zo/9wyF2lRblisc8tfHBfGKDRg1EkZ6jb/scemtFhQvJso8C7U=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1488.namprd18.prod.outlook.com (2603:10b6:320:2d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Sun, 10 Jan
 2021 17:53:17 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3742.012; Sun, 10 Jan 2021
 17:53:17 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH RFC net-next  14/19] net: mvpp2: add ethtool
 flow control configuration support
Thread-Topic: [EXT] Re: [PATCH RFC net-next  14/19] net: mvpp2: add ethtool
 flow control configuration support
Thread-Index: AQHW52XSPa4bBlohH0+vFZswHt8ZzaohHqUAgAAFKvA=
Date:   Sun, 10 Jan 2021 17:53:17 +0000
Message-ID: <CO6PR18MB38730409D799C0A44769C417B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-15-git-send-email-stefanc@marvell.com>
 <X/s6bkkoq4HVbLR+@lunn.ch>
In-Reply-To: <X/s6bkkoq4HVbLR+@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.29.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54a71ec3-8b39-45e6-081f-08d8b5909c3c
x-ms-traffictypediagnostic: MWHPR18MB1488:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB148862473E98FFCB89B4264BB0AC9@MWHPR18MB1488.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lOzCfwHxF5rnnp05JMVm6+NmbTChC1whfAHoWLD/ubGnzRvIq5NyBmrarUYHKOQtRn1guyJ/2c23nylHvu6GfAWsBs1600859rZPPpY/yrYuj09zxiVKlmfpc5Vz03q7bvclDxvtWexmJfTV9bT1A+3ANkxZTV/MmYWQybOcmX87pJqBlql6oExnpXVxjGuwTcnp/mgGwhSWljPK4LRAG/RyNqBovN1OFUCUSXiOuluNeZjaIM1Yl5fA9OJnSDf/TtVUE0QExBOknIV5Npesdg0bUIHZZ6eFQtIgQndHGZML/5JIq9KCJPmM37qF85i1ZLT2EQxMFdVQA9JsjRkXL5gM9ddadz6cH+uciSJ1u0GMPJ1XIoyy0FLoAFzJDeWKlxsdu/VJ0Iu5fMHbcMouSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(7416002)(4326008)(186003)(33656002)(55016002)(316002)(2906002)(6916009)(54906003)(71200400001)(8936002)(7696005)(66446008)(66476007)(26005)(66556008)(52536014)(76116006)(64756008)(8676002)(5660300002)(478600001)(6506007)(66946007)(83380400001)(86362001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?OMnbuM3U+UdUomkfYU+srgLwMe15nYNKEqD2xPRKHzVdPn0KU++yw/PkgHZT?=
 =?us-ascii?Q?hSMCYcDfi5AdBoCdt6USLz3zBBOP8TX+zb9G2xK9gsNTPx8uoI+wfOUg/LpI?=
 =?us-ascii?Q?CSmaTp4VlGX9zQLkAlH96Y35uqz9KUl4ATSplhhKVKBrlP5ylwfSZz0Sc+ik?=
 =?us-ascii?Q?b+epwxqNK/93X8dPkwA3mg9XHog2Nv7U8sJ3CoS4z9SpPkF/Ea/spisX9xt4?=
 =?us-ascii?Q?jzpWYaJ8YAe2G0g7zOHQ/Vq/xueL9vYglGrdE0qItzxx7CK1io4n9JnpwBNB?=
 =?us-ascii?Q?nFZ+9KinXl5MKk/IA9SE20krQocFygk2gRgOkti+Eavz2d5W8ZS0kbQ49SNR?=
 =?us-ascii?Q?hloApu723chRc8vma6XtcfjuBibXbqN1WG3/jc1YDp9LWXjHYUALPKVgLlk8?=
 =?us-ascii?Q?UgvXRxoqXiGm6I8kGNLA2u6Fng3G92/edCRcI6dLESJ+sW6uU1nWuEIwswxW?=
 =?us-ascii?Q?auB/xRgCeR80kdMseg8rxVN84FTTmmV8cJih2bUDI8UziTXXsrTKofYyaMjd?=
 =?us-ascii?Q?xzbT2hBYepyMGP45QQIXsi1dQfOpL+fUUu2yC/cjK2PQhy17KRpptyXpnrgk?=
 =?us-ascii?Q?FGBCXfRtoL6Y6LVutAp25S3MAwhoPipSgJkU/j8aHRg1NeoxtFs/47Holeh2?=
 =?us-ascii?Q?ikwhpNTuNXOEDfS6kuQgmCjK0U7nUMA0Cz4jTW3YMX9fP4HyVOtCU0DX7Wfe?=
 =?us-ascii?Q?FHslxFJfJKGLBYLetpC9Ere/6SVZ3OxpccfP8okAhFOsuVAgwr56YR9FYYf8?=
 =?us-ascii?Q?A9hZT8yHX0cO19Rljl93uKS0Fe+g5H82ozZ7DKn7+7YQ611sEQ/ffzT0JtGQ?=
 =?us-ascii?Q?4p3ejsSG8kazDPK4riHNtEPO/wyEibvlBPa/Rn/8DKr98fPTkJwb0otKakNW?=
 =?us-ascii?Q?IrErLw2roAS4abfWNJEILi4btkSvzPc+oeBuT+Zv+xUmRGeMXAUxrc/Q4kfi?=
 =?us-ascii?Q?wY4AD1b6S5yWv6xCUVPm5iZCRQphd32jCsMAbBfpV6E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a71ec3-8b39-45e6-081f-08d8b5909c3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2021 17:53:17.3137
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z8sqjQ5OnxpsL+eFAoDuvU1AbX2Eyt/KIqJp7AUlgBmn4GzwOQMxtWAI7gPB0WcYJautkfEWDF4TQyR8BiU4/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1488
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -5373,6 +5402,30 @@ static int
> mvpp2_ethtool_set_pause_param(struct net_device *dev,
> >  					 struct ethtool_pauseparam *pause)  {
> >  	struct mvpp2_port *port =3D netdev_priv(dev);
> > +	int i;
> > +
> > +	if (pause->tx_pause && port->priv->global_tx_fc) {
> > +		port->tx_fc =3D true;
> > +		mvpp2_rxq_enable_fc(port);
> > +		if (port->priv->percpu_pools) {
> > +			for (i =3D 0; i < port->nrxqs; i++)
> > +				mvpp2_bm_pool_update_fc(port, &port-
> >priv->bm_pools[i], true);
> > +		} else {
> > +			mvpp2_bm_pool_update_fc(port, port->pool_long,
> true);
> > +			mvpp2_bm_pool_update_fc(port, port->pool_short,
> true);
> > +		}
> > +
> > +	} else if (port->priv->global_tx_fc) {
> > +		port->tx_fc =3D false;
> > +		mvpp2_rxq_disable_fc(port);
> > +		if (port->priv->percpu_pools) {
> > +			for (i =3D 0; i < port->nrxqs; i++)
> > +				mvpp2_bm_pool_update_fc(port, &port-
> >priv->bm_pools[i], false);
> > +		} else {
> > +			mvpp2_bm_pool_update_fc(port, port->pool_long,
> false);
> > +			mvpp2_bm_pool_update_fc(port, port->pool_short,
> false);
> > +		}
> > +	}
>=20
>=20
> This looks wrong. Flow control is normally the result of auto negotiation=
. Both
> ends need to agree to it. Which is why
> mvpp2_ethtool_set_pause_param() passes the users request onto phylink.
> phylink will handle the autoneg and then ask the MAC to setup flow contro=
l
> depending on the result in mvpp2_mac_link_up().
>=20
> 	Andrew

Ok, I would move it to mvpp2_mac_link_up.

Stefan,
Thanks.
