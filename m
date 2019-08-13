Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51BDB8B4F9
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 12:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbfHMKGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 06:06:52 -0400
Received: from mail-eopbgr00063.outbound.protection.outlook.com ([40.107.0.63]:46545
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728410AbfHMKGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 06:06:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0JGEMftzKSo76dcvBxK/vtO3DL1bQLmRU4bNXJmyFRWLfnRub0BhmFcPKig/emhmGEOZ3HuyapckPEfctOc+v1IDQblQotPOEe+jUjFHAe4xD7f+jk+/HTRnfBd499N0+oe/6obTZfOOC+4PJF8Xr385OfUsp5bt/ndYOq3+osX5pZjx7iJISG36Whbc3dNDgkt5RHuGV+YvAUfSuE+WJOJzk9RV8RcMaZJwuKWnygQr9kfDV4y8CtcT+cE9+hLGpvMZHC1EzgcqzCITnJ2dM4rEAzzw9pgtPpf4ubagPslG9pbJxXvWbv6YhAvconzt9sMaJFZZxqMBgEdBJGxfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/vOrywlU1PsPaAsjvNnRSheLaBjDKNze21BcW4kYvc=;
 b=lNIRw2pagaoceEMbuG1Qfayb/Ci8rsOxX7bzR01Q6a8BS4r8X5i2klmZe6ZJAsWoj8SRWCbcF56HhPvvkxM6PMLBkDScVg55B03rI5WQItWyI+ewRb0MgkaAFAvHqWsibdzrJgo0GmGXtBkWZGgmTzL2C9GeTiNCSJg/AkFwKCQMlDj65g82T5p7EiIhzE0LIbPAuuibaMlxXnlLsLd0GR+g+BXoOZNoW39YIJ1zN3sqh/N8+4PsFN9XPBXI1g4KlIOgC05ueS4URWAZvoL20c2fuuf/4/wmtbEGfja71GLhGb5/MMxC/gm/lydd6aTmimDTDLRNVt85YeZ7BeIZog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G/vOrywlU1PsPaAsjvNnRSheLaBjDKNze21BcW4kYvc=;
 b=VOC0jWryTSPDELLkwVBMqanClh0KYmT6WlkKiBO2McRruFe6FPtRmWLyu9jV8bNEIUWMmVRk4OVmXk80CrtZcJ4l2ElqLMIQeFYl+LlBiP6nIh8N4vuQJOMZDRaszbu9/C7pocEDAmWyN/NhcrxdoaQqIknGzfp6MHdq08fcrzw=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.188.155) by
 AM4PR05MB3329.eurprd05.prod.outlook.com (10.171.189.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Tue, 13 Aug 2019 10:06:45 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::a1bc:70:4ca9:49f6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::a1bc:70:4ca9:49f6%7]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 10:06:45 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Edward Srouji <edwards@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/4] Add XRQ and SRQ support to DEVX interface
Thread-Topic: [PATCH rdma-next 0/4] Add XRQ and SRQ support to DEVX interface
Thread-Index: AQHVTcVwaztmXBnL+06+efxz6YKskqbxB5uAgAamXACAATQaAA==
Date:   Tue, 13 Aug 2019 10:06:45 +0000
Message-ID: <20190813100642.GE29138@mtr-leonro.mtl.com>
References: <20190808084358.29517-1-leon@kernel.org>
 <20190808101059.GC28049@mtr-leonro.mtl.com>
 <dc88624d6632f23a1b0ca77f45ed21a20158d3e6.camel@redhat.com>
In-Reply-To: <dc88624d6632f23a1b0ca77f45ed21a20158d3e6.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0041.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::29) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:8::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67329947-9851-48f1-8a82-08d71fd5f245
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3329;
x-ms-traffictypediagnostic: AM4PR05MB3329:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB33290B053B3CE6799711EBEFB0D20@AM4PR05MB3329.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(189003)(199004)(6436002)(66066001)(54906003)(8936002)(76176011)(2906002)(52116002)(316002)(71190400001)(71200400001)(81166006)(81156014)(4326008)(4744005)(5660300002)(6486002)(256004)(1076003)(7736002)(25786009)(26005)(53936002)(33656002)(6512007)(9686003)(99286004)(3846002)(6916009)(14454004)(486006)(186003)(6116002)(11346002)(6246003)(476003)(446003)(305945005)(386003)(102836004)(66946007)(66446008)(6506007)(66556008)(66476007)(229853002)(64756008)(8676002)(86362001)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3329;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7d2GZsvkvO+8ntZ7c5FNsXO9abLAhl/pfUki9XOYDx7j3MSJlmRBUV4zUx03/eCVsSU+RUtMArsznQj+/K94WvFdGDI9TncyoVORPvot3KHPr5mjDKpS750BS6V+fBX42+rw8dhFA4qmsS6CEaYstiB+/BGpIBELWUtu4AdOeAZPYmzgqQGM2A62X77WEQfv2LpBC2zw2tHLLhJEBnGGOClLd5S+6H+lv6osG2OxkxD8dQ1WdQ6F7Z3HVEOSdjQNkr3f1V8zMcW76dedmLKTvkka//CiFeRCzRIgAIOvE0YbzNuqGE+yOABiFSUqZkLYBM0hwKsvqNB09ugRHV8MiqPd7Loq37CYJIPX2gdfbuv6SoMFqlraIhhnNQeouhOKFG1eEZNhRm3vEEs+WZ2CwGnTxIaU78nn+b1RD/dmS+c=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <82D9C18F0658304FA60A667EA2020C07@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67329947-9851-48f1-8a82-08d71fd5f245
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 10:06:45.1152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rLsndG7wg5QSVEYNNSU0umLNOg3/2IkgU8behb84lbS81armlTgGcpc3dnivKdjFZWMlnxzJ5xMRhZ2a1XHJPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3329
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 11:43:58AM -0400, Doug Ledford wrote:
> On Thu, 2019-08-08 at 10:11 +0000, Leon Romanovsky wrote:
> > On Thu, Aug 08, 2019 at 11:43:54AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > Hi,
> > >
> > > This small series extends DEVX interface with SRQ and XRQ legacy
> > > commands.
> >
> > Sorry for typo in cover letter, there is no SRQ here.
>
> Series looks fine to me.  Are you planning on the first two via mlx5-
> next and the remainder via RDMA tree?
>

Thanks, applied to mlx5-next

b1635ee6120c net/mlx5: Add XRQ legacy commands opcodes
647d58a989b3 net/mlx5: Use debug message instead of warn
