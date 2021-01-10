Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CFB2F0908
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 19:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbhAJS2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 13:28:50 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27948 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbhAJS2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 13:28:49 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AIO6du011791;
        Sun, 10 Jan 2021 10:28:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=8hiQP1uynvFCD4xrP0fkzAz/U7It5WLHa1hKy3rL2Wc=;
 b=TWtTi0irQTngoYCc+TMFDfn9tnaagnxaS5OnQPOedFD3Ag5U9ubeOU8CRkvgcJ6kyoXr
 hjWdDN7ermSiEIaHLvFQ7IQCZkPXMi/fIEsXgGmiYHNhnxfDZU5pJ/I2hIWur0WBoEq1
 MAyT19cMf6jDE48WoJDm9UsBhjZi9JukPlnSN4M3hoLAWHC7B25oCoXFN+nk6iLsycmU
 kOhLt+Ndwuxa16MF5EUot44ObXugmvy8A1EbigvC6GmA4ksGH6d5IBgUj824ivCapugl
 L6CpGCgpcT2/yKrG9qTMwnnloHE2HhJlLjupxNo4PWYU58K96z7uJInIGmmvsCH0nHv9 6Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvpj3ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 10:28:00 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 10:27:58 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 10 Jan 2021 10:27:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iH3GJNc8UmH7/2zDh9wYRWu4yRE90Lt5XGfsYHzG0/xBDHOk5J1owwLPo4eb+/13oIp8rHnrDKpAUuBdm5poz+llSgrXFULaaNY3HUQosW4NyunR31R9gKDa02olO48v1xka/0XQ5hhOM7KuGfJn8OvY4yt+7G/W8/A7XzFkFF+Z3//cv0alnLqjyIWHxEUHq+37Aue5HpyUxj/l/THA5ftdWVSYL9OHe4H+kvnU0S6IhpfwIsvqLhsCeuRb6sUnull1nn2vKs+J4S4iI6yOL9HduFjKStskGr+GD6SZdHkezv1EPgFu67Xx6BmnLR+nH4QPRl+9WOKAUdtaZoZz8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hiQP1uynvFCD4xrP0fkzAz/U7It5WLHa1hKy3rL2Wc=;
 b=XU3qYOuj1NkOUCkR2mI1yp748Nd3ZcPyGj3dltElIXjWbdX1YK0KPp0JaUW/hk3BxeyxrhY/9LBfK3xDCM1a8G1VzOZHv5qcA8VxTBraF4yLMDP1wFVcLQHSiUO471DjaLNDz5lFS0LuOPOg3NStbb+QWzL3wu7nLwVrm8iYxVt/QJVddTBYaulYE5vJmE5deSWBoQejyAfh3iMNGKJvi9KD8fBylG7lOgtekE+znZ+TRDlVrgHSthY1ZZSfOnwSrgtCm1ib2xoc/wXJffRXDe1MJOySGdcKt4wA3x72QfbL9+7C9F5T+tS3zK63dZJ6HTEE4h6eWC+4MU5meB6dHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hiQP1uynvFCD4xrP0fkzAz/U7It5WLHa1hKy3rL2Wc=;
 b=Bmf/TzGPv+UtQQQLCo1Y7rXkxXsvyxYq3RNSt6aTAlbDtu/UUBbd7c5w0PSR45g7fbWYWp2SjJMTMSI2f7jaBito5zRzuhWcPTUyAL9qJz7+BeaDUNtlxR0q6WrRXAsqnsCf4v1aFiJmgw3vnZqTC4LCnPb30AT8w7tOwOjnskg=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1663.namprd18.prod.outlook.com (2603:10b6:300:d1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Sun, 10 Jan
 2021 18:27:57 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3742.012; Sun, 10 Jan 2021
 18:27:57 +0000
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
Subject: RE: [EXT] Re: [PATCH RFC net-next  14/19] net: mvpp2: add ethtool
 flow control configuration support
Thread-Topic: [EXT] Re: [PATCH RFC net-next  14/19] net: mvpp2: add ethtool
 flow control configuration support
Thread-Index: AQHW52XSPa4bBlohH0+vFZswHt8ZzaohKk+AgAAC4xA=
Date:   Sun, 10 Jan 2021 18:27:57 +0000
Message-ID: <CO6PR18MB3873D0FCB65F1E3879002D15B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-15-git-send-email-stefanc@marvell.com>
 <20210110181519.GJ1551@shell.armlinux.org.uk>
In-Reply-To: <20210110181519.GJ1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.29.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37b5e251-3afe-4e54-0836-08d8b5957447
x-ms-traffictypediagnostic: MWHPR18MB1663:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1663F17F9087BD7FD09CEED4B0AC9@MWHPR18MB1663.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Eg1wpUECcap+nnZ+hpihi2JdVIf4dyDAaR6TFwbHR9VBiXwRYqSn9DiNmXBB0yThEX1cRSkEXy40Ws+Vbkqfqee0TW81u2fzYUPKKDR8LogEWm8CD8QFflT21wNrbSr9vdteOHPlTH6jy5tbeOhdFYHdmfBQAAd4t+LDss7vcT2Zo0Xui7xlNUBoUyEdt+LgPMMpFF32wxDDb4ymZOQj9wpHhFZVlkR8DRIhPH9/JOPZisCzuMg9itijH4qaeXRNtYtHf4nO0hJPLiLFGurr02m3xAHdHDHV39aNNbAZTPHsX6um+N3NykDg9XO+ftxNrJwg3bXuyktfABoxQtASqhPuljV799avodRtWCqK/bTHqPt0ivcf2q+rQ2/SaZNfNGctkPrARGka/zuFvvnLeQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(86362001)(66476007)(8676002)(316002)(9686003)(83380400001)(186003)(66946007)(55016002)(71200400001)(7696005)(76116006)(64756008)(66446008)(478600001)(4326008)(6916009)(52536014)(26005)(2906002)(54906003)(5660300002)(66556008)(6506007)(33656002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/cCUEhlkPkOkfuRIIcUUbuJbcXyLFbBm6SFIQLabOrFRO9oqf23+iWQijm/v?=
 =?us-ascii?Q?3EEKiX8ikWBZoj2qwNza23T+RnwKJG5Q5nJ8LDBpwGG4DeXj33OElk3OuSMY?=
 =?us-ascii?Q?nsVfOVdqoUXdEOO889MyBbeSR6FXH5FFizYNmzzd1QnMw9LMUxM0hRf8TZy9?=
 =?us-ascii?Q?nroG5ONCxseoFlGkwLSU236IBD83fZr/cEh+jmTnj/TWxFgZR7YzLRs1N2ZY?=
 =?us-ascii?Q?dIzCd2dxYoLPDSVoMgxNZRfAswGBdfdtlRI1LJQiUtxFly4cU4Kiwehcx+Ri?=
 =?us-ascii?Q?9r/8o9SSq8/lfOnTKx3oapS/h3n3JYoYkZeub4WS5WLIj1Qb/m03Or2cyHHV?=
 =?us-ascii?Q?J3X+qdVs++XSts7cwsk+fK8SXoEwAM/EpIIVabG9h6nB4Lnncj1y0UuTlEKS?=
 =?us-ascii?Q?t2fCaVnrAochCRNKnvCEu/3Yb0rwmF1rtr04LAHHZlhgLfjhbk3nANL8kz/D?=
 =?us-ascii?Q?rc4q6asBUTn0Uy1rG/m7PKUE+kT1Qcyfc7gHLc5g2L4cb+ctYw7O6HJLQ9yJ?=
 =?us-ascii?Q?r+Ts4kcp/Bwk5IFWXhQLv5BiRfVQMRkTT+QT5QjBLheti1+waJpZyPynLwq5?=
 =?us-ascii?Q?QHQp+5KVYbkC6MuwNofHBMwubAelvXBEkRnaxZyjvQ0NqCOz2f0s2aQr7LbG?=
 =?us-ascii?Q?tMrJtS2c+wSMt4WtqU9Lqwy1RumkI4LS69IxEQ8VRXq90EKy3JMglypmlP2g?=
 =?us-ascii?Q?1i6SxIUzSQXimpqvMzbQ2qj4/A1HoJ8AhhD0i478bo0eer7LO3hQ6rjOcAEq?=
 =?us-ascii?Q?XRvhTnkTEesipMM66+6vsp0Fm5VPkrSEn/VKQg97Jq9OaJYOX8xx2thY5aR0?=
 =?us-ascii?Q?urbb0EjrBna2XtawzKy0o7EqdGUdJd91tV+GtCQ+alosdfAGzvTuQrghH7bn?=
 =?us-ascii?Q?2otDOUCg5OMgYyZ7368C6CM+krvZlF9Kqm3v2RbPQIDv58gT468RvSXMGkly?=
 =?us-ascii?Q?EJzeDM4IkPPxkEww/epCgiYWMztsS0nd91whp9/IDVE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37b5e251-3afe-4e54-0836-08d8b5957447
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2021 18:27:57.7078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BVHRjuaWiCgXcHdI26hv+HTaAA5w5sTAlZJPGR3sZboKHJ+zBhmThlqljXJ/eRjFsYaBNYOBIO+VSkMGlZdexA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1663
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
> This doesn't look correct to me. This function is only called when ethtoo=
l -A is
> used to change the flow control settings. This is not the place to be
> configuring flow control, as flow control is negotiated with the link par=
tner.
>=20
> The final resolved flow control settings are available in
> mvpp2_mac_link_up() via the tx_pause and rx_pause parameters.

I would move this to mvpp2_mac_link_up.
Thanks.
=20
> What also concerns me is whether flow control is supported in the existin=
g
> driver at all, given this patch set. If it isn't supported without the fi=
rmware's
> help, then we should _not_ be negotiating flow control with the link part=
ner
> unless we actually support it, so the Pause and Asym_Pause bits in
> mvpp2_phylink_validate() should be cleared.

RX FC supported, issue only with TX FC.

Stefan,
Regards.


