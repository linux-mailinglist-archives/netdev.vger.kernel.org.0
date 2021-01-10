Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535512F08FB
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 19:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbhAJSKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 13:10:35 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59970 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbhAJSKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 13:10:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AI1BJY001618;
        Sun, 10 Jan 2021 10:09:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=gbajyOz6OUK80ma8jKDIlOr8+e7i3qqfYRXt4AGWHro=;
 b=FPPshV0r2S27oC2KjSANa4Y8Gpa1AdddpJH7EjJWSspY5s/VQBCEMd7DFUEI8JZBCPYZ
 LYdG2csslZxDV6Nu+qdgKyK4e7a0FQejC14cXCT2/xsUC3TssIPS097AcmxN4V3o3eX9
 AGK0lylX65Cx80n6P6AOyaYxM93HUP9Gd+V6rV6AePVl4rHIdtu0OVm6sU4BwNO6DV+O
 laBv9vvzP3DtUDQG8/MpouLqL7rubEmoASREk2TXANGmA/Jp5XbGaa6teJd3f5WAeNG6
 2FZXDe2kyvvjAFIDVkbKSWYGeHhMJjKNB4ghVAAeGuUCDhBs6otgPvOnQgeCr7Qg6oeL nA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvpj2tq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 10:09:45 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 10:09:43 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 10:09:42 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 10 Jan 2021 10:09:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUNM6Ha02a8yhKSfdtxG2MIx0lJiJ5usCkywoLJ/liQO8zTPt2Y3m8z5M/7BdAUAHKS3vpgPKJL6fjTggHBA5gvwakqLkJRCvGa/32hc9JlWyfdB7Rs9YA/xOex62dRCb2VDZUGMRTJ3n0pXSPTO+iREqHT0DwuO75nuJ0apYCl2l3WrDoyyK6a3/ieI2AmbHaP7hI5lGpROO2OgBG3tqsIM+3oXdCQPYfUwNeGpQShnmUP0B/fJ4h0tNB+t3qvJiWtV8yxiQBYFj6hLUS9H3Hlt6/0mXJYrSpIotyEgiKWw8AiLIcbLLii6kMSw3tVViJhBToL6UXtA+vNBeLfqZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbajyOz6OUK80ma8jKDIlOr8+e7i3qqfYRXt4AGWHro=;
 b=GCsO/lKIwmH/X6u6wQFVJyRQmV62Qy1XkslcOrfCerv+zZa26vKcYJCXNVOPZkJw4c7S4lRErN0+IytXUZuJny2LRN6QIUYBRMY0UlFo0Khhg6K5v55MYW5yU0yYmhfcNBAHotmDKGFcllL2Wdv3RQZVh8diZuhmyk/UuuJgbyiAHgwqs4EtJL7oo7SzLnJL60ARtejkmWtKpiLsu5ZZ6NJioMtYS88D3uupKCrvEQlTIqFmcVltIr6DySwwOuFs7hs5fENrdWlCCfR4HMin4IEIWwvCRZlg6PArZDUFqsNQZO3DhPG2b0Ue9AMYSAm6HMVwNlLg+phJBJKBJ2Qzyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbajyOz6OUK80ma8jKDIlOr8+e7i3qqfYRXt4AGWHro=;
 b=iFdUay0hm/ieY8yyFkeTDrnephptpSORJMWYu435eejTeMw4wFI50qaSJxoqCzrMB0OvYnG845t+9xD3doKctFfh6arnZ2x23f+muAvQPHDwq8Hzkb3BcbUh4OWi/qICtlCJGaKIFpZIhhedkfz3weig+oEgLz4JIwx9kn6hZ4Y=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW2PR18MB2185.namprd18.prod.outlook.com (2603:10b6:907:5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Sun, 10 Jan
 2021 18:09:39 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3742.012; Sun, 10 Jan 2021
 18:09:39 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH RFC net-next  03/19] net: mvpp2: add CM3 SRAM
 memory map
Thread-Topic: [EXT] Re: [PATCH RFC net-next  03/19] net: mvpp2: add CM3 SRAM
 memory map
Thread-Index: AQHW52WtPfi4P1NcGU6aLxAkyBGTaqohJKIAgAAATSCAAAIxgIAAAESA
Date:   Sun, 10 Jan 2021 18:09:39 +0000
Message-ID: <CO6PR18MB3873C00A07115021090AB9D4B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-4-git-send-email-stefanc@marvell.com>
 <20210110175500.GG1551@shell.armlinux.org.uk>
 <CO6PR18MB38737188EA6812EE82F99379B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <X/tBiyrJ8cJX+3u6@lunn.ch>
In-Reply-To: <X/tBiyrJ8cJX+3u6@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.29.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a56bf7c-c8b1-48c6-8f99-08d8b592e58a
x-ms-traffictypediagnostic: MW2PR18MB2185:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB2185E3941938F1421744E4C2B0AC9@MW2PR18MB2185.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qXkaMywGv/6xgq8RrKEngsNbwRg7ufHl078bTbaUATKGZ4Z+Yw1FyNubW20fyK1oZSLQPi1LjUCIXSk74i8p4f62sHkyD4KlYkPp0oNwM4YleYwJQcEoaGSNedqpg+t3+/7XPkWv+UCeC5sIeU5i4kirO7vLoDizq+tmK8/du8QRKwKcS3HNKlgRpKZb1Af6UwYqVIyprW+04To46T7E4KOahl22UJQFCnMMHyJx9PDfbD0GbaC1JQubZqQPtz00+uHs753Vf1LPszTOupdp8dWtAgvRyCZzOJMM7dWWNCL8UjKpK/R1nhgjSeEzit34LNuZ9ejhRQ7dQhkA2hJL9pX0Je6Rbmq/Okp5LSoMC7iBtEXl5IeYWVPJ4eiQ6lG8J3naUCmJnQ82BtfkIPqLRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(55016002)(26005)(478600001)(186003)(8936002)(9686003)(54906003)(71200400001)(316002)(8676002)(4326008)(6506007)(4744005)(52536014)(86362001)(76116006)(6916009)(66556008)(66446008)(66946007)(66476007)(83380400001)(7696005)(5660300002)(2906002)(33656002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?D+Vn0dqM0J/gOvZvuWc4QB3xo2gqcBjtLOSB7r8iXl6u2i5Ji9pga1Rw50CG?=
 =?us-ascii?Q?Z0mMs19FbQ60SdHI6D67SRmzZNuXqPmmeJq9dDGegqhJeVnxQi7XHEvEqMgf?=
 =?us-ascii?Q?J0sSwKaTiEPGIIr5tSTjDcvTvIokdYpU4RVCmXCu2lok3NZ8p1XtqBGSgeMx?=
 =?us-ascii?Q?BQQWHwekYqqW0e+UNOCGtjwgxGxlpoio54iRtgka4NftR2YV7u6GGvnAzcl7?=
 =?us-ascii?Q?VEQLMYayb9IBIsO3j4SeLjwLThafNWSqsH8865ZtyDMDf/NZeBnRdEMGXQ+I?=
 =?us-ascii?Q?KB8PUvA/FhS1gRlX3olZCsODS6cNwEvWUFQE/hZxMt1YXhOqUBw7gpbgG0GD?=
 =?us-ascii?Q?9OXCc88baCB/hg+D3/5LZddTibzf24QzrxP1STXd6mC5lBJLhLBF/YQ+upl5?=
 =?us-ascii?Q?O7u1C6phSh3dWTb3v5RAME6m9r5pcTaWGpQrjfuNBl4fi2E23rOiHwFxgsL2?=
 =?us-ascii?Q?XkAM/rbCAwtgakRkeSkixdqPJskUAK8jGSK/ViN3FQqINgrhDQE4pTsmwvBz?=
 =?us-ascii?Q?IA8Yqw9GinfgSw+T/8/pHFYTMOep8h/q9wKr1GN7hc8l04WcQgkMcTfL1L2o?=
 =?us-ascii?Q?gebHE4y/0sUdM3duRm5wztIJx124eQvAcqpUijBYRbaU/R7c07yuKzE64Nj/?=
 =?us-ascii?Q?Lg3/JoIvBYpRPXaBJtKsaXoRmeeNw7GGyyA9Re/YR0h68LVQ4Oo2yy1gYtFw?=
 =?us-ascii?Q?in4+fdMxCuyX/hddP6xQnY5K1pkYDMrTHAxD2m4Cqv58OXLGdgx2Qi8WxM/a?=
 =?us-ascii?Q?3snxzt2EaqUqa1H8x5vhEYEzlDWABqOSRm/Bj3ChHuCwBnSAkGDsHVzOi+XJ?=
 =?us-ascii?Q?nY87xYugH13FYE31Me7WAnW6uziRZTLcCdn5kFbbYusgAAQwnaz0xqWNdFlz?=
 =?us-ascii?Q?5H6zsWhjMZdeB3Q2ba9W9Ljf5re9YbZorJ5AFN38DRYn++GswGPJYW5GlM1M?=
 =?us-ascii?Q?0HG3Cx2tY4qrvZsQG4yIOIj6Pl144IqKJ03N6w1UT60=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a56bf7c-c8b1-48c6-8f99-08d8b592e58a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2021 18:09:39.3024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j1DPXoOJtImNMWEVZJObNHh70qQ3zlGUt9Dz55323BPGXRgrI+31sR2yPHREOUnMlUfjNkCF9IZkJ/EixFagDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2185
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > +	} else {
> > > > +		priv->sram_pool =3D of_gen_pool_get(dn, "cm3-mem", 0);
> > > > +		if (!priv->sram_pool) {
> > > > +			dev_warn(&pdev->dev, "DT is too old, TX FC
> > > disabled\n");
> > >
> > > I don't see anything in this patch that disables TX flow control,
> > > which means this warning message is misleading.
> >
> > OK, I would change to TX FC not supported.
>=20
> And you should tell phlylink, so it knows to disable it in autoneg.
>=20
> Which make me wonder, do we need a fix for stable? Has flow control never
> been support in this device up until these patches get merged?
> It should not be negotiated if it is not supported, which means telling p=
hylink.
>=20
>    Andrew

TX FC never were really supported. MAC or PHY can negotiated flow control.
But MAC would never trigger FC frame.

Should I prepare separate patch that disable TX FC till we merge this patch=
es?

Regards,
Stefan.

