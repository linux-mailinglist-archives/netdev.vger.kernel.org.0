Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00CEEA66
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbfD2SqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:46:03 -0400
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:58600
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728962AbfD2SqD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 14:46:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3p+mV1UBf5HbumaxftpC6wOaOwXbha22V4UjeNvx9NI=;
 b=M28aOh1jkoqkPzw3ECdI+VrFvXziI4xjCHFCRFSqpFei8EMzLk8sG9ITLs3RHhPGCcg8MhhsbM/d5PNAHo/UkuN00Nj8G68BjzXfKpo4p3cVoz48EZpkmxEwu15ruUhnJaHCDontrjzBz4slXao/xn0uviyQmHO36guB86UVBeI=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2622.eurprd05.prod.outlook.com (10.172.13.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Mon, 29 Apr 2019 18:45:59 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494%2]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 18:45:59 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: RE: [PATCH V2 mlx5-next 09/11] net/mlx5: Eswitch, enable RoCE
 loopback traffic
Thread-Topic: [PATCH V2 mlx5-next 09/11] net/mlx5: Eswitch, enable RoCE
 loopback traffic
Thread-Index: AQHU/rdxfbRKUZWs402AO/w32fvXqaZTeNWAgAAAqlA=
Date:   Mon, 29 Apr 2019 18:45:59 +0000
Message-ID: <VI1PR0501MB22712A3E3743FE283308771ED1390@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190429181326.6262-1-saeedm@mellanox.com>
 <20190429181326.6262-10-saeedm@mellanox.com>
 <20190429184116.GB6705@mtr-leonro.mtl.com>
In-Reply-To: <20190429184116.GB6705@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ea08548-b52d-4d8f-28ad-08d6ccd2ec13
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2622;
x-ms-traffictypediagnostic: VI1PR0501MB2622:
x-microsoft-antispam-prvs: <VI1PR0501MB2622D8394E556A7034BB2997D1390@VI1PR0501MB2622.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(366004)(376002)(346002)(199004)(189003)(13464003)(102836004)(53936002)(229853002)(55016002)(99286004)(9686003)(107886003)(6246003)(256004)(14444005)(81156014)(81166006)(8936002)(8676002)(6636002)(5660300002)(86362001)(52536014)(66446008)(64756008)(2906002)(66556008)(66476007)(316002)(76116006)(110136005)(53546011)(14454004)(66946007)(6506007)(478600001)(73956011)(54906003)(71200400001)(305945005)(74316002)(33656002)(4326008)(97736004)(76176011)(68736007)(25786009)(450100002)(6436002)(7696005)(66066001)(26005)(186003)(446003)(6116002)(3846002)(476003)(11346002)(486006)(71190400001)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2622;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0K+Ixytk1f7SNbO3+1f7flc3KdjlRUonKKaLCzQYS6q/wTPzVWqhZMDu1ZsGmWCzjV0wIoqOJ6hfH+OAeh6/H9Ow022z9QXuXlMoxxbkAmCr3qsV4V/N+HIXOxTVLBZBFzaCjjneIAnrV9ifZFUw6OmCJ4/nXTRqttAxZxKrh+Lq3koTM0NJaTfFhYs9w3sfzJThGRdGboPmZt059fmXLsn2mnIZD5CwO5z5kVFlv/ZzxhyvVBWrUySBn9yiKpauCcsJ3sbc+l+7CeMDwP0f/19F52YTZmjDKXCLVT0sk+J+/Nxz4lu9ZH1NqMDYpxj2MqUmu29qb52ZZXeuJXQrF4Dgi5aKPPcjDgy5LlK2t6sN5pr9KpbjMphhPfApQhUMIIWqlr0hdW7lIX2HFe03WUailUvIynJk4KN6kyfnbLI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ea08548-b52d-4d8f-28ad-08d6ccd2ec13
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 18:45:59.3489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2622
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Leon Romanovsky
> Sent: Monday, April 29, 2019 1:41 PM
> To: Saeed Mahameed <saeedm@mellanox.com>
> Cc: Jason Gunthorpe <jgg@mellanox.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; Maor Gottlieb <maorg@mellanox.com>; Mark Bloch
> <markb@mellanox.com>
> Subject: Re: [PATCH V2 mlx5-next 09/11] net/mlx5: Eswitch, enable RoCE
> loopback traffic
>=20
> On Mon, Apr 29, 2019 at 06:14:16PM +0000, Saeed Mahameed wrote:
> > From: Maor Gottlieb <maorg@mellanox.com>
> >
> > When in switchdev mode, we would like to treat loopback RoCE traffic
> > (on eswitch manager) as RDMA and not as regular Ethernet traffic In
> > order to enable it we add flow steering rule that forward RoCE
> > loopback traffic to the HW RoCE filter (by adding allow rule).
> > In addition we add RoCE address in GID index 0, which will be set in
> > the RoCE loopback packet.
> >
I likely don't understand nor I reviewed the patches.
Part that I don't understand is GID index 0 for RoCE.
RoCE traffic runs over all the GID entries and for all practical purposes f=
rom non_zero index.
How will it work?
It is better if you explain it in the commit log, why its done this way, 'w=
hat' part is already present the patch.


> > Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> > Reviewed-by: Mark Bloch <markb@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
> >  .../mellanox/mlx5/core/eswitch_offloads.c     |   4 +
> >  .../net/ethernet/mellanox/mlx5/core/rdma.c    | 182 ++++++++++++++++++
> >  .../net/ethernet/mellanox/mlx5/core/rdma.h    |  20 ++
> >  include/linux/mlx5/driver.h                   |   7 +
> >  5 files changed, 214 insertions(+), 1 deletion(-)  create mode 100644
> > drivers/net/ethernet/mellanox/mlx5/core/rdma.c
> >  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/rdma.h
> >
>=20
> Thanks,
> Acked-by: Leon Romanovsky <leonro@mellanox.com>
