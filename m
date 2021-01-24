Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFA2301C32
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 14:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbhAXNY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 08:24:58 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35326 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726672AbhAXNY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 08:24:56 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10ODNCYV029978;
        Sun, 24 Jan 2021 05:24:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=x1B+ckfVRUdT9Ny3lyULpOA1KtfhaW52rWoJulY8MrI=;
 b=QI1uoQogv2B89Gq2AyS9UHmYg3fJ+f1iHQX7z6j9XAYiHtqnH5bRb582dT0O1gYEHKoN
 QOhUnN5j2jdp+K1XkB7QbgDHKeAiylRjXnLB5rr1FqdqADrcbc+7FiT/XovDQq+h3LKp
 IjXZHDKA+wAQhq5tn9jynixayeYfRSMnO47+uFyEFjkg+ZXieyVAadEg6kYG7IDU8l98
 HNuRfA8yzyU/bmRV6c68IpLpCOUNyAJwaQ1kiUNkmdyKx53usaYpJdXj0du7NFr2Uc+Z
 eziGgSc+SmPmQEhnrTtQiwRuRMFergENvm00uJDps1i2vLUMabT1Nh2yOhS2h8F/2zt9 tw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 368m6u9x5n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 05:24:04 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 05:24:02 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 24 Jan 2021 05:24:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmDH2WWC3xQLvEQuIaISqNnBubzK7uUaM2gsR2zDXQCRMimr5OF4Z+cyxnXyVUg2mjSeSSG9hdGuKhOTUsc69yHw2JkFta32bVPl7BOTlV+Slt4z7xlOfg6QWx3TqUuqWYDYINBgDTCM3NuNE5qTwSr9/4sKD13rTou680KpFzbOXwdN88BRhkI9evCzrz49vlLNY8LmELGRDMkJUZhyiNpIY3W3SlkVkz3ezNSOsFkxwRKEnYq2C86kD4N+m2DGEb6g34N0zRWR/MjPdxOqJrT9qLSYGgnSH10H7U2P11PdsHQR/Ebc23JK6bxHUwatT9VhPmAMwcIf3/+wqH7DyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1B+ckfVRUdT9Ny3lyULpOA1KtfhaW52rWoJulY8MrI=;
 b=fhRU+dJ2Sc2doN/zvbBEUbTIddzaR/m+WfdBEzYUqRRW9m2sNiG4qca5PNayOpRUKM9sg4M1fvvAPBTLBD+kv8U4eeNmql3auaEkkfL6U2BI6etfSqd28NrwkADmXP6aW7tb0sPxpaZrejxY701Qg0sLCFjkSL3I1wwMY7mpwmtkXiLCIGG+xRl6OwZ8pU3+mhvQaS5xmqkHfim7OMBdQCCGLUp30a3V6Hr/RFIq+XYmOXrgey1h92/tBXRRA0BLKU9X1gnXzfx048EYV5T74EMEfVM+RhbHDOEsfDM0sPIkqeIdwqLVEuGU2feH0JKGJtqk4v/vpj98Y3b/wGWPsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1B+ckfVRUdT9Ny3lyULpOA1KtfhaW52rWoJulY8MrI=;
 b=p3Fzxelgqxb+Xtpge+osps6sZuFM7Iq1czw1zk5cdm3L38UHXH4ZV4530CGwGCJVCETgcGccKiocWVZuDVxcNwkdf4ijvW+Z7ocDzXaAKg1m5i5N8dVLsDvzuv0Sw7kW2PmAPRm5kZBcYGic6RQ5hha2vRtjmE6q0Ms8zu42eNw=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3843.namprd18.prod.outlook.com (2603:10b6:5:34b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Sun, 24 Jan
 2021 13:24:01 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3784.017; Sun, 24 Jan 2021
 13:24:01 +0000
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
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 RFC net-next 09/18] net: mvpp2: add FCA RXQ
 non occupied descriptor threshold
Thread-Topic: [EXT] Re: [PATCH v2 RFC net-next 09/18] net: mvpp2: add FCA RXQ
 non occupied descriptor threshold
Thread-Index: AQHW8kZjJgcom5hFkkCJmWkUxNxWoao2vYsAgAAD3jA=
Date:   Sun, 24 Jan 2021 13:24:01 +0000
Message-ID: <CO6PR18MB38739ED82AB44815ADAC3DBAB0BE9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-10-git-send-email-stefanc@marvell.com>
 <20210124130134.GY1551@shell.armlinux.org.uk>
In-Reply-To: <20210124130134.GY1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.11.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f97a7423-ab5a-4992-3937-08d8c06b5037
x-ms-traffictypediagnostic: CO6PR18MB3843:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3843F95CABE29643AD0512FFB0BE9@CO6PR18MB3843.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b40v1UnJSb4ArQgwdUPmSURBI8vfDWzWYChPqtJHCAuEblrveRq8AR/DfJKwweELbAM8HuMBX4YV8pOYD7ZDcTLjkRjeqoNy2a+0XEB9qsHPguBL02XlWRvYI33upbBjWV4FWxOBjBiEysU4X+zlboPKcz7jOp4wWFkRwEZMnBzmr0sgFf7KpZ40tpZXbZ4nPmkFFO1WuqKtt5n0D69h7e8DcKjg808Jp0uvxP8sAon/+siaOCONMOdpHVFW8wkEx1DgdHqo/SMbCxYr1Vrx6ZQkSxLddtR16BRjR9Swzcfk8F/32u3i0V8QOl42EJSKuEarqRWmKOc+uFUxIIH7W/r5KXlDcwk/xU9/FQSyXttCmLG/Pin5azgl7qC8XaCZ8o4bjl8cMLLBk6wX7+r34g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(136003)(346002)(39860400002)(6916009)(8676002)(4326008)(2906002)(186003)(5660300002)(52536014)(54906003)(478600001)(66446008)(64756008)(66476007)(66556008)(66946007)(9686003)(6506007)(76116006)(26005)(8936002)(55016002)(316002)(86362001)(71200400001)(7696005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?p847nEyrKC9WmqADWxEZdG2k3vCr055hUSQDqNaNDHKkuO6TGuzdhjMdPfLZ?=
 =?us-ascii?Q?Sa2ahGDHOGniZsWFYG3v8hwccCsq0tGarCbPOd+CwO/KJX9WiYDHf/ecHn/I?=
 =?us-ascii?Q?55nMQEOOasEVY6j2xreRaWxHah1rO/NBBgxeOyBgMFZuJgX+6qveDvoXQaiP?=
 =?us-ascii?Q?8LGcUGB5Bc+qxv7WmneVnZD+jpvUvP/APHnhblw7hG+7rU1xPletpqb4Ifcs?=
 =?us-ascii?Q?auOopU8qwGyIUvOGTJNovYfBTCDA4qSDJ8qekNfNMTo92Ron3lQJjaRyuGIs?=
 =?us-ascii?Q?pkcD+SVaUQZW17gPf6OWhwBaCrHs/+O62yzwRCvYPBWfrnPU+I+lF4aYbmzh?=
 =?us-ascii?Q?+8y/CXxbsRidKjS9NbewDxiqzlz3D7Wur2W1043r4Ncl9aPYTo/Uf3w6lj73?=
 =?us-ascii?Q?nCSjP73CieZVefn0ABQ+5p/wGb9oeb1gRK4/kaHAEH87ZWARo+THv71dUeRM?=
 =?us-ascii?Q?LD++QakbSe3V+s9gxBR0moA6mR1FOPMIjvzfdoBkf7nozNe0OWXtkbtMCVFn?=
 =?us-ascii?Q?woLEB0p6WdPIcyTQvr+fjpHnAPMNHF9S4OkEZExkj0+dPy1sMRjvFAtbX+LQ?=
 =?us-ascii?Q?C7PO4h18YOAmRJBMxg0TEPTtw6TTTHeyhUyFmQDMC5o8xeQ03lyOhqPZ0Up/?=
 =?us-ascii?Q?LKDy9l4NKai0txCU0wAq5cBWauBoekbxYO0u1mgsSeoyaPgJklBWQqOQoqGm?=
 =?us-ascii?Q?sW3z96sWxMrOZvPxjzybkv7p+0dZzNH5WPJkJ4aZ+OR+5+/qwUlCoASPZ/zB?=
 =?us-ascii?Q?1dFBoWX9D+p0quZMOnXqoTchU/Rs5Q4FIMNKDop8Z8OcRr9SVS1uK8LV/Pjc?=
 =?us-ascii?Q?ApBk361a7we6VKMwu57DRpNMdaJ7m8rU/48TR4Ukoip4/m7oB1mGL45+tq7N?=
 =?us-ascii?Q?csfKFf7Xv7qL6ExTABLg2xGYD6GW+wNuaz5EemiKfCvDKnZuedqvsW/HcnBv?=
 =?us-ascii?Q?eXlxDeChD5v3AuYtdkwRNtzKnQC6oy5k92GANbMDi+SHg/zb1WdgccHzFaKj?=
 =?us-ascii?Q?pj6xB2Gs35lWSOFDSqY9UCyYm81xer35aEgZXrKBMcIXZneDqLE2Somg4Xiy?=
 =?us-ascii?Q?Xu75GvUi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97a7423-ab5a-4992-3937-08d8c06b5037
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2021 13:24:01.1660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vsU/jNXQilGKOxQR3IDk71mzVYKea4LbOuuz9czSgd6XmcAGCqXTRIhJiN+2PNMpXqqMPz9GWLaMZuKKEt1i1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3843
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-24_04:2021-01-22,2021-01-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -1154,6 +1154,9 @@ static void mvpp2_interrupts_mask(void *arg)
> >  	mvpp2_thread_write(port->priv,
> >  			   mvpp2_cpu_to_thread(port->priv,
> smp_processor_id()),
> >  			   MVPP2_ISR_RX_TX_MASK_REG(port->id), 0);
> > +	mvpp2_thread_write(port->priv,
> > +			   mvpp2_cpu_to_thread(port->priv,
> smp_processor_id()),
> > +			   MVPP2_ISR_RX_ERR_CAUSE_REG(port->id), 0);
>=20
> I wonder if this should be refactored:
>=20
> 	u32 thread =3D mvpp2_cpu_to_thread(port->priv,
> smp_processor_id());
>=20
> 	mvpp2_thread_write(port->priv, thread,
> 			   MVPP2_ISR_RX_TX_MASK_REG(port->id), 0);
> 	mvpp2_thread_write(port->priv, thread,
> 			   MVPP2_ISR_RX_ERR_CAUSE_REG(port->id), 0);
>=20
> to avoid having to recompute mvpp2_cpu_to_thread() for each write?
>=20
> However, looking deeper...
>=20
> static void mvpp2_interrupts_mask(void *arg) {
> 	struct mvpp2_port *port =3D arg;
> 	u32 thread;
> 	int cpu;
>=20
> 	cpu =3D smp_processor_id();
> 	if (cpu > port->priv->nthreads)
> 		return
>=20
> 	thread =3D mvpp2_cpu_to_thread(port->priv, cpu);
> 	...
>=20
> and I wonder about that condition - "cpu > port->priv->nthreads". If cpu =
=3D=3D
> port->priv->nthreads, then mvpp2_cpu_to_thread() will return zero, just l=
ike
> the cpu=3D0 case. This leads me to suspect that this comparison off by on=
e.

I can push patch that make it if (cpu =3D> port->priv->nthreads). Or even r=
emove this if.
Anyway on current Armada platforms we have only 4 CPU's and maximum 9 PPv2 =
threads(nthreads is min between  num_present_cpus and maximum HW PPv2 threa=
ds), so this would be always false.

Regards,
Stefan.=20


