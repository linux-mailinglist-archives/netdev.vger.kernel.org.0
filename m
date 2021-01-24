Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05896301BE4
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 13:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbhAXMk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 07:40:56 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38640 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726497AbhAXMky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 07:40:54 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10OCWbMB007613;
        Sun, 24 Jan 2021 04:40:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=VNWRwLw4wA6NUeWEyEMaKrnl6KDN1jHgD8nsdSMMAqo=;
 b=PxALRHdniuZevTXZX9IeRhkHG6GhHKHuvdHazNwCEjn0uY6lq0T2bcVvWk0d0jzxXVTC
 RkzN+WehXtBY0aqyV+FBJ88UTtior0Jfd0+Vlyb4ORgp+dZ6rk0Pl68rAfJsVi7xIDx9
 TxuSIiHHr9I+MCBSSfpSb6zG2UOq2zMI+HGpwRYA3TEnI3FOR85X0g1nr2Czw+syLpt6
 zaBeaftcHCfixSZGeEhtu3/68/V/0do3UXwH+IvQZmVrTmDIQyXri+wCWoolVK9fsBh/
 M5YCLZyOO7agbjHR8WqAG2UlP8e77IrcBnzOuc81ytJsipiCVBHtkDELIr8MaAaIadu2 Yg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 368j1u238d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jan 2021 04:40:01 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 04:40:00 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jan
 2021 04:39:59 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 24 Jan 2021 04:39:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TqL0du1cx6u7b2Rq6JdGtH+TB5nvfGli9yo0273FICeYfQz9wM9tsgBasSfFZBhzc3JIq4DBMX/TNWLNMmxwLvJFbx5ko/dF1uv2dRvJ5bABoj9BPG4Xy96QgozsWmdnnNMEj/zUdcKfb1pToJh+KxhEH1SGbEzR41y2NyhGuahnC3bz2afUPf3ENMU32uFKAuE0c9Fx9J3RikAw69HF4l9caubXHAkfrWiTRaTBc0tuLcn/olIGLxPD/LWJkzBUBV2zHC0gutKl5GatXzLPQQU88IEG55JBow/KOfgzD2GYyXTdXDlXx0q4z+ck8lvIH0m0SKK60dS2l/nXuj5EkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNWRwLw4wA6NUeWEyEMaKrnl6KDN1jHgD8nsdSMMAqo=;
 b=T+fkLcJMgxbta/jBzetIjGzVP0xHky577AQAidWtcacfch2QF6UQsSrjHXnGFTfb1/9p4EWIjwAERRXZp/kLzqo2EI1NKsz/y8fJ+d7yltkNLhVUi7gpC0jxOEd1/UBPnI53boLZX2dYrooc9xqdFQ8AVNRJzsExMNgkq427uW+2QIAy+cG2Mh/rrz1TFQE3zPkc7ymKMfpP9eW54YNbehdStFoWxJnw8WkH2eaIrJsnZXusa5AQbROZ7aA3zXw50Yn8j8gDUHaOL3755zY6u8Z4XdhmQN5QGjFng6scchSuX8sIo9pt1V6eZMoDoOCPDQVylGbjNl3Yzm+Wf0iKRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNWRwLw4wA6NUeWEyEMaKrnl6KDN1jHgD8nsdSMMAqo=;
 b=D3KeqNm4xV73TStSqzQ4GehBJCwm//oFHDdgmnI55NgwsYbyUeGkW2fHKLD7t5n7c4NHHT+A4WmDO6Wjv9eKp+diW2AB9vvh2orVM8ncbgv/5rUlI7dc1icwYddJt96nzCJBNo7nRJ+bvgURR+oX6D4Ir2LwVbhapfbZYiabpuQ=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW2PR18MB2315.namprd18.prod.outlook.com (2603:10b6:907:9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sun, 24 Jan
 2021 12:39:57 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3784.017; Sun, 24 Jan 2021
 12:39:57 +0000
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
Subject: RE: [EXT] Re: [PATCH v2 RFC net-next 13/18] net: mvpp2: add ethtool
 flow control configuration support
Thread-Topic: [EXT] Re: [PATCH v2 RFC net-next 13/18] net: mvpp2: add ethtool
 flow control configuration support
Thread-Index: AQHW8kZrqv9d/Q/GOUWKD5NmmM81S6o2tlwAgAAA6CA=
Date:   Sun, 24 Jan 2021 12:39:56 +0000
Message-ID: <CO6PR18MB387376F5CA52DEF588D2F4C6B0BE9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-14-git-send-email-stefanc@marvell.com>
 <20210124123554.GW1551@shell.armlinux.org.uk>
In-Reply-To: <20210124123554.GW1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.11.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ea882bf-85bc-4c20-3cd6-08d8c0652829
x-ms-traffictypediagnostic: MW2PR18MB2315:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB231590B00ED24BB6C42CE935B0BE9@MW2PR18MB2315.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qtd5SDsosK27OGBRSmOfyNbQ9KZVYfWwlOYSxbkkStOsDXQEpEfOUFawsTDQvsdXAtXAlY7S7D6IWv9qyNZbdRyH/5UpPWqf48nqYZxboMz7nvRhKkIk30bDDafoLx3gOZUyzJ9S1aiykHlXFc3xjNFYLDEoPehj0VPlNR6TQQCliF5WCY8DYzWd85h5DubPW+3FQtYCfGHwkTe9q3rCAbs97ldHZfd38iej+etd06Rqz4AY8WWxaN4OHFkSdHk4IObPdzJQECEd6r7TczfXytTqetCg0Bv4FmSAfEkiBWZud42/VG8u7VowrDkAQNnKr6exBaBGmIW0njCE3ym9YRpYBIQ0BSFG8FU78YzJ4mGsed59AYHEGNvq5Mg7nVM22GFEmHnSTyLIHbxLxDuDmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(6916009)(66476007)(7696005)(2906002)(66556008)(66446008)(64756008)(8936002)(66946007)(4326008)(26005)(52536014)(86362001)(186003)(8676002)(5660300002)(6506007)(54906003)(55016002)(83380400001)(478600001)(33656002)(316002)(9686003)(76116006)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?GEycnK9Sv+c9gmpLlv1R7Qrq+Pc30NKwuw9kv8iT03gHlta8O1EahdczBJ4o?=
 =?us-ascii?Q?kBrwzaWQzHio22btA6goETLKgbqsSpliln4lm94bi920zilkV4YDkg2ftPXk?=
 =?us-ascii?Q?aRMF7YK9/joLdgSZU+j0U+Eblw3KfyaX0zGcRolCZCfVMH4UfAWDYS7pjFCP?=
 =?us-ascii?Q?ffNsBIqLhTI0iZsPWGH9kRR2BhSfmF9ZzUTX9O+S+YCX238x65BIlIk0zW2f?=
 =?us-ascii?Q?+gGb+dWutVmZ5oD6hpvljU3zUX/9RbgndzNcF+BCI+tR/N6IljFhTyFkh9Gi?=
 =?us-ascii?Q?Ajjw/M5L1Jdy3giloeiVg+eW7OzT7FwTIq38jRTcsa+W7SDfwYqYY9GW50X6?=
 =?us-ascii?Q?Vj50feWzZSV/PhYVOhYm5ZjvOh1mOybyHcuosrtcKcV4UoXuMJvVj5yPxbzY?=
 =?us-ascii?Q?D3gyXdAn7KjAUfVDkymfANHXijyMoOMT6cWMZUeCfCd3wdsO7Z0Vjh25RaIm?=
 =?us-ascii?Q?32NeYgnxaIdq036a3ROz12+9eBS0CUxQEUcLyUj5sZFBL+x/xgWwTH+6a1IC?=
 =?us-ascii?Q?LO1YeZGy63usf7wIfXAF4egkHXaE09Ox06P0eXNr7g9e996sE5/+tWgezMzM?=
 =?us-ascii?Q?EKbp1Sv7pvM3O9hl6qwMiCqTITgaXYjw4oVCyUVJnWU4teFLpnP/8DMmghsR?=
 =?us-ascii?Q?uZzh8JVB4nh5e184g+XAK4hE45DHpEv3Li8KZRqCSWARRet0gFMUruGzZp8F?=
 =?us-ascii?Q?PS/JHlkQBUM2D6arcr+O7uZl7bqOCVa8jacpdB9rYvTcU3nxOYmuKi49iAaQ?=
 =?us-ascii?Q?Fy6o9NEur4dUGIBv45H9yuK/rEx/37cCQZLbe4Af7hrOu/MyepUCcpU2f9/Q?=
 =?us-ascii?Q?/7/rKD+r2vNlB1xIh7RJ2sARpz7EJROxoYz8j0DS0ZiI59p3oe4Yc9ByXIlf?=
 =?us-ascii?Q?CLQaTw9wxcKNlfnzQUbzAiKHzKjyv53aJvi/Cf1Z0wcSjQMI07X/j6ugc9Jz?=
 =?us-ascii?Q?bsg+fcLuRuGigXZWPFnDwIhWRRK1LS3gFjQHnorJbDwgsMpD5dD1m+locrsL?=
 =?us-ascii?Q?zhnneR24e38JrdpgBGeofs6JSHtvw1+rymIVjDk5DIH2KIhjY9NEr37/i3kp?=
 =?us-ascii?Q?XiDJVbLR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea882bf-85bc-4c20-3cd6-08d8c0652829
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2021 12:39:56.9582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VWEGRciBw6ybpJpi3pshSiE/P/TXlZeHTO2P7uDMgalRWB/KO7eUDtDEA3/m8iES+z5TEt5P6zuontb8m115Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2315
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-24_04:2021-01-22,2021-01-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> ----------------------------------------------------------------------
> On Sun, Jan 24, 2021 at 01:44:02PM +0200, stefanc@marvell.com wrote:
> > @@ -6407,6 +6490,29 @@ static void mvpp2_mac_link_up(struct
> phylink_config *config,
> >  			     val);
> >  	}
> >
> > +	if (tx_pause && port->priv->global_tx_fc) {
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
> > +
>=20
> It seems this can be written more succinctly:
>=20
> 	if (port->priv->global_tx_fc) {
> 		port->tx_fc =3D tx_pause;
> 		if (tx_pause)
> 			mvpp2_rxq_enable_fc(port);
> 		else
> 			mvpp2_rxq_disable_fc(port);
> 		if (port->priv->percpu_pools) {
> 			for (i =3D 0; i < port->nrxqs; i++)
> 				mvpp2_bm_pool_update_fc(port,
> 						&port->priv->bm_pools[i],
> 						tx_pause);
> 		} else {
> 			mvpp2_bm_pool_update_fc(port, port->pool_long,
> 						tx_pause);
> 			mvpp2_bm_pool_update_fc(port, port->pool_short,
> 						tx_pause);
> 		}
> 	}
>=20

Ok, I would update.

Thanks,
Stefan.

