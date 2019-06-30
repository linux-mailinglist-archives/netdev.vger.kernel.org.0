Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE86E5ADDD
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 02:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfF3AcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 20:32:12 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:49085
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726952AbfF3AcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 20:32:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CuV7FV+5ZfTNZixnzmdi/OyhjL7LvTIKS3rpPAWtqw=;
 b=KcYtI2klo8/JTqNbqC3JioIqcG3jfWUHltf+g/4cWRBYR3zkCueieQhriBCLHWVURGdrncNYn0xDPAVsgvMgBqgJk1wpDLeCNbE+hEgCAu3/xPIjFH/9CXt2ybayzsftiHmvrxEL6y52sQUgiAhyapgrcpJH7MsrvrKvfqstUuk=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB4944.eurprd05.prod.outlook.com (20.177.51.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Sun, 30 Jun 2019 00:32:08 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2032.019; Sun, 30 Jun 2019
 00:32:08 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v4 06/17] RDMA/counter: Add "auto" configuration
 mode support
Thread-Topic: [PATCH rdma-next v4 06/17] RDMA/counter: Add "auto"
 configuration mode support
Thread-Index: AQHVJfsE3tKh9oGpaUGuOuzrE5Gb8Kazan8A
Date:   Sun, 30 Jun 2019 00:32:08 +0000
Message-ID: <20190630003200.GA7173@mellanox.com>
References: <20190618172625.13432-1-leon@kernel.org>
 <20190618172625.13432-7-leon@kernel.org>
In-Reply-To: <20190618172625.13432-7-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR01CA0006.prod.exchangelabs.com (2603:10b6:208:10c::19)
 To VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59d54927-0236-4345-328f-08d6fcf26208
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4944;
x-ms-traffictypediagnostic: VI1PR05MB4944:
x-microsoft-antispam-prvs: <VI1PR05MB49440572A6068FBFE3FB7842CFFE0@VI1PR05MB4944.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008421A8FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(199004)(189003)(25786009)(68736007)(8676002)(36756003)(305945005)(7736002)(53936002)(1076003)(6916009)(478600001)(6246003)(8936002)(71190400001)(71200400001)(3846002)(73956011)(2906002)(99286004)(6116002)(5660300002)(66556008)(64756008)(66476007)(316002)(66446008)(54906003)(66946007)(4326008)(14454004)(66066001)(81156014)(33656002)(6486002)(6512007)(86362001)(26005)(256004)(6506007)(386003)(446003)(76176011)(11346002)(486006)(186003)(102836004)(81166006)(229853002)(52116002)(2616005)(476003)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4944;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZXeDRSTRs9TjuU8KBTlKqZ/JcX/gMjthPcE2WFLk2eT2f4hmxvU/k9zzeLvrdiyfirK0FeUNq+NKvcEHChHiRo3SIMBNVk+hl3huJugg1U2EWTnhiBGc1Ha0BgitTm20Fy0h3NUgOXc25T5JZNJrNvB+cgcdZrEeYDfu3eXFRFczAJpT+axQQPdTCa7/eMUjKTmVkEXpdvKKPWIov+EPT+jz0Da0CZeQvaBbesqqv0GmBh+tIp8Vsdj2zszN6fAbHAuFo0c1UNA827Uz2NwEWCsM2xz7lOVw6CxyWahwCULAd7GRmpffPbxmQQmo9dzzIcqcOHvZQBejQp7cRRb3PcZH7LBMzJKs3btSwxb5/1LldT4Jn855HV3mtV4NiEnW4kg+DgXF9ebiEjQx3au6EyiZEFBy73RWL7fZL7DvnXA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3B0F99AFCC5F4B44A12EFD058D50D00C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59d54927-0236-4345-328f-08d6fcf26208
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2019 00:32:08.1250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4944
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 08:26:14PM +0300, Leon Romanovsky wrote:

> +/**
> + * rdma_counter_bind_qp_auto - Check and bind the QP to a counter base o=
n
> + *   the auto-mode rule
> + */
> +int rdma_counter_bind_qp_auto(struct ib_qp *qp, u8 port)
> +{
> +	struct rdma_port_counter *port_counter;
> +	struct ib_device *dev =3D qp->device;
> +	struct rdma_counter *counter;
> +	int ret;
> +
> +	if (!rdma_is_port_valid(dev, port))
> +		return -EINVAL;
> +
> +	port_counter =3D &dev->port_data[port].port_counter;
> +	if (port_counter->mode.mode !=3D RDMA_COUNTER_MODE_AUTO)
> +		return 0;
> +
> +	counter =3D rdma_get_counter_auto_mode(qp, port);
> +	if (counter) {
> +		ret =3D __rdma_counter_bind_qp(counter, qp);
> +		if (ret) {
> +			rdma_restrack_put(&counter->res);
> +			return ret;
> +		}
> +		kref_get(&counter->kref);

The counter is left in the xarray while the kref is zero, this
kref_get is wrong..

Using two kref like things at the same time is a bad idea, the
'rdma_get_counter_auto_mode' should return the kref held, not the
restrack get. The restrack_del doesn't happen as long as the kref is
positive, so we don't need the retrack thing here..

> +	} else {
> +		counter =3D rdma_counter_alloc(dev, port, RDMA_COUNTER_MODE_AUTO);
> +		if (!counter)
> +			return -ENOMEM;
> +
> +		auto_mode_init_counter(counter, qp, port_counter->mode.mask);
> +
> +		ret =3D __rdma_counter_bind_qp(counter, qp);
> +		if (ret)
> +			goto err_bind;
> +
> +		rdma_counter_res_add(counter, qp);
> +		if (!rdma_restrack_get(&counter->res)) {
> +			ret =3D -EINVAL;
> +			goto err_get;
> +		}

and this shouldn't be needed as the kref is inited to 1 by the
rdma_counter_alloc..

> +	}
> +
> +	return 0;
> +
> +err_get:
> +	 __rdma_counter_unbind_qp(qp);
> +	__rdma_counter_dealloc(counter);
> +err_bind:
> +	rdma_counter_free(counter);
> +	return ret;
> +}

And then all this error unwind and all the twisty __ functions should
just be a single kref_put and the release should handle everything.

Jason
