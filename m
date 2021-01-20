Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9732FC934
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbhATDix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:38:53 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6933 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbhATDiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 22:38:21 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6007a5840000>; Tue, 19 Jan 2021 19:37:40 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Jan
 2021 03:37:39 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Jan
 2021 03:37:37 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 20 Jan 2021 03:37:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJdmQmBpWv+nDPb0bZl7eGFFtD25M3CFtnslyKzNNcJpxN6pfx32romXLUBpGARDKuIJKCt9jsCyoJdC+6f6JGoLbhmFKtaeMl7LuNKknqXdvHaPNgJvo6beKxTP0buGrTZrYmBqxJbaAq8foqFCAiaI2e1sTvhujZXQqe4rHOtN9XRMH7cJ+dNEOV2KV2Q3XTiZoch8dzwkYHWq7MUmBPbhiiIzGPDRDgZwKbXR6+61ocUu9TGbZYkvCEhjrtWWvkhB4RWc2ZqTZnQn4oePp9xLGutxH6+vBk4AOup+FhgS2Dfz2YGTAnFDttrSBW6D0EpIXM4I2iPAiqaiBIQBLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9U2Putf/WNxUlOCPXMngPGSBuIHn/nqFBJycw5Os0lk=;
 b=b9X9c9LaimVteE3NFsjx9z/kvMtHTCiuOBddoxckOfvtpLjtEVElr0DFeabEUBw5qwAyMojy/VifZqpCPpNIsEBsxlpR0nhJEapPJCwLZl6zWVG3sa809kASql8aUAIkGC72HdMF5Mr9i5/EUp9llxE+gUOO0Tu3V6YVVuU6uWgM/75O25DpLI+AxkjbW+YrELldCQUODV3YQjMPbGTOMFUWk67btxrhcoStcI9X6Tabceu1ZUjYl7wq0UVjxvOkeRTpCj0ExymsLAJmoqlDNsGjUUtPz5aoSuGxzA1TZ8iJy94UZXreN1ZCvYVICw8U7JeWgYZNMNvboG9QAVtVJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3623.namprd12.prod.outlook.com (2603:10b6:a03:a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Wed, 20 Jan
 2021 03:37:35 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%5]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 03:37:35 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next V7 03/14] devlink: Support add and delete devlink port
Thread-Topic: [net-next V7 03/14] devlink: Support add and delete devlink port
Thread-Index: AQHW7dZSzLjG4xLSkU6QoaEsyf2jUqov3LuAgAACQYA=
Date:   Wed, 20 Jan 2021 03:37:35 +0000
Message-ID: <BY5PR12MB4322FA7F1F55F6E8450A33AADCA20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210118201231.363126-1-saeed@kernel.org>
        <20210118201231.363126-4-saeed@kernel.org>
 <20210119192739.0b3d8cf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119192739.0b3d8cf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58f979f3-2912-4b6f-9093-08d8bcf4ba09
x-ms-traffictypediagnostic: BYAPR12MB3623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3623B20461B29AC1D9AC7B7DDCA20@BYAPR12MB3623.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bLHEJTxjyG0MbrI5yfvwJGUWUoQFODAAX7Ia+O/MV0EYXJhhhEDiNprVfAWreMWMlFkvrcf2O027it+z4qNrmFIeIgNAvsthCWgmW2f37KRb+FEIjKVwLYefhc4KLDGU/gyw5pUcaapVTT63rLpXL4cEYjkYDpcO3lskZFxBcJe9iZWfmeI0OFX25fvrjdYoBfeo5EYsrfcbsDTBvaMKPgWF++MadT7mjx258zhgnfZEK7KgyaRMvVUorQRPXCUcouE8peYstkVmYz5sBrj1uAqwRJ7ss/oMwlYxrds4YU0CxIvW2af9+5Td/eRvSL13dwCPjF9ZLPZdeVl6DDT79YP75SSDl7KGPP/9ecG/9K4XGJsVANRzdLCpqmBCSGx283KFECTEO5ZAC1Rc+pzczg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(7696005)(5660300002)(478600001)(26005)(186003)(9686003)(4326008)(33656002)(52536014)(2906002)(6506007)(316002)(55016002)(8936002)(66476007)(8676002)(66556008)(64756008)(76116006)(54906003)(71200400001)(66946007)(66446008)(86362001)(110136005)(83380400001)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?jyoC4cGKGyY43yMLntuqIE1fPGCQ9ZBEqTu1NB+aJoiLkEqe64ObjS2WQqvn?=
 =?us-ascii?Q?AFCh9N4a1ucp9spnCxplQ/UpXOawATi6PsUy1aIYplttD29ChiwaMh6+2kt0?=
 =?us-ascii?Q?ci0+SF5LbUXhAwrBNGzZ3XQ4HpEsMcgbB+tPWT5ab42PAYMjVOb2DZ6wG+wV?=
 =?us-ascii?Q?N02Z8+frnyOOF3sXnmND1zF2RHd8MiMQ31X4LymZ6CodRuaKC2RSl3/oIMjU?=
 =?us-ascii?Q?BkCL9mTe+/4VZl4qnQwC7++4nkY44tmmoVHHSVH07xD86knEZ/KuG9uJ05QO?=
 =?us-ascii?Q?KXgtcz+dsmtW22FWrvDW4yZbVBWv5q6bUCq2WL5Eb5KHB1tSzfJ2AZJbOlYH?=
 =?us-ascii?Q?zw/cUnUG8orjbTgHp3GUgS2uC5YYIjjYkZTfMXClJyPRca2+cWYPd1x2ghWX?=
 =?us-ascii?Q?G6vus7KLhZXkciH6mK7agsIIn0rPszzxXeogwqs00m0+TPTXs/eIfinwlzbZ?=
 =?us-ascii?Q?/Dl3HF1YF/uTAauZmV665BFG0eDAeEa7TMezrUDjInIS5u59xgAj1nOwtTx3?=
 =?us-ascii?Q?gHyiapLW68dJSejkVSGfd+srBrfh+1nnkvmsOdSlA/BKFoIgeqGpUZsO3aRE?=
 =?us-ascii?Q?onHofiRBTBALIphvvTX7pf+JPcvOAFiYOyC4pKqA8X4mTUXNQBnZbnCW9wKi?=
 =?us-ascii?Q?PnhMcBMMFtQvMa5LxdWCM+CEDIvM5Rgt9OvIWPAnBsQUqVPRLuTQgAWwP28O?=
 =?us-ascii?Q?fLc7spk04fPdhGQnlSPah9i8JrF/dqKnzkxcAdbz2yo/o2QtoQJlRNDO6W7V?=
 =?us-ascii?Q?1eN9gJzyIGqE8mdi8XxyEZiqrNM80jyPeLnP9kUZJ1nMRbpMtfoe+IVFli4f?=
 =?us-ascii?Q?Ami7ttuXroixpOYsEscOF7fa8nefIVzvNfCrK2wThjifMBTvpNqclr+T7hnS?=
 =?us-ascii?Q?QVCptHplKjSV6lMksIXTGxuh4z4Wf0WX/Et8jTSvm95CC64OAit5RGhR6A4w?=
 =?us-ascii?Q?fwT/tZnW5U4G1vnucYbJu0bnOPMedk1QdOzzuvuXZOI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f979f3-2912-4b6f-9093-08d8bcf4ba09
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 03:37:35.1648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eubf+POHx4jtVXagaaeQPD2OiXMSm070tDIdsE7+BrU777k88s6tiSvFjKXwd52Hra0KGzo3kA6LkuUzokvntA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3623
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611113860; bh=9U2Putf/WNxUlOCPXMngPGSBuIHn/nqFBJycw5Os0lk=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Y5Fvh66RyHNuRbWl3y95R6VideqYTObgivYsklo4bEbrDVCY04xOslI9H1xNmpiuP
         FL3SJUkXxsR686KJRAcaGu+oE+ZTnsCkM+bpWCFl097YMgClNjL4k7hGwwfPWuDct4
         tV9+kCRZGtiDKdPQRMoPZHi4/uuxAy5qogOLlZOMr+/yjocI3985G5Qc0jmZydARiD
         j2GLQZK28OhhfioFd6Da6pn6jghfdh1qHYkwYcB9iYfmjblY3o5BchlJOPxYtJYEdD
         s1Blpdb68fCi1zauEydEuxWdn64EF2w1dpjgv76A2sDSE0UaoVrAD2kS181DqH991A
         Kv1mBgT01/blg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, January 20, 2021 8:58 AM
>=20
> On Mon, 18 Jan 2021 12:12:20 -0800 Saeed Mahameed wrote:
> > From: Parav Pandit <parav@nvidia.com>
>=20
> Saeed, this is closed to being merged - when you post the next version pl=
ease
> make sure to CC appropriate folks, in particular anyone who ever
> commented on previous versions. Alex, DSA, Edwin, at a quick look but
> maybe more.
>=20
> > @@ -1362,6 +1373,33 @@ struct devlink_ops {
> >  	int (*port_function_hw_addr_set)(struct devlink *devlink, struct
> devlink_port *port,
> >  					 const u8 *hw_addr, int
> hw_addr_len,
> >  					 struct netlink_ext_ack *extack);
> > +	/**
> > +	 * @port_new: Port add function.
> > +	 *
> > +	 * Should be used by device driver to let caller add new port of a
> > +	 * specified flavour with optional attributes.
>=20
> I think you missed my suggestion from v5, please replace this sentence
> with:
>=20
> 	Add a new port of a specified flavor with optional attributes.
>=20
> Saying that the callback is used by the callee doesn't sound right.
>=20
Ok.=20

> Same below, and also in patch 4.
>
"let caller add .." words are not present in patch 4.
So I think patch 4 is fine.
=20
> > +	 * Driver must return -EOPNOTSUPP if it doesn't support port
> addition
> > +	 * of a specified flavour or specified attributes. Driver should set
> > +	 * extack error message in case of failure. Driver callback is called
> > +	 * without holding the devlink instance lock. Driver must ensure
> > +	 * synchronization when adding or deleting a port. Driver must
> register
> > +	 * a port with devlink core.
> > +	 */
> > +	int (*port_new)(struct devlink *devlink,
> > +			const struct devlink_port_new_attrs *attrs,
> > +			struct netlink_ext_ack *extack,
> > +			unsigned int *new_port_index);
> > +	/**
> > +	 * @port_del: Port delete function.
> > +	 *
> > +	 * Should be used by device driver to let caller delete port which wa=
s
> > +	 * previously created using port_new() callback.
>=20
> ditto
>=20
> > +	 * Driver must return -EOPNOTSUPP if it doesn't support port
> deletion.
> > +	 * Driver should set extack error message in case of failure. Driver
> > +	 * callback is called without holding the devlink instance lock.
> > +	 */
> > +	int (*port_del)(struct devlink *devlink, unsigned int port_index,
> > +			struct netlink_ext_ack *extack);
> >  };
