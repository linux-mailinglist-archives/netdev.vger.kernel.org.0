Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADBBDCC6A2
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731474AbfJDXp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:45:28 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:44963
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725730AbfJDXp1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 19:45:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHzOxUQKtDy6nB5LL22OTPyzbkTvb1XeLcghYAg2FqM5rs29p3GBMYnRNehsI0xF7a6/tudaR7xlzlFhHp2IOHPcSTWM+sK+KCMWE7kDL8AeXnCtxEzRBuVlvjpEUKgjAVi3b2d2w+MR1DpUFFebVi//fqGPpweFCzW+116YPlLjl9wuTSEZx/KGJoR15eKTV315So2c1uFgLBHiGLjKR6/x3ycDn5TbNdTdDx+MkIUaaQjY6ewLfrWn1nJL924iIG78rAx+S+R7jKfSuxqiC5LoNG5bnNgejSEplZoiG36SopH240YnDU+KFWH+Hbcn6iFE5mnXth3g9MZEZ834Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skYNCdqcclV4Xy/B20rKqP0hODeBFJ8mVOubI7B8MWI=;
 b=GeExlx1OxWPTWlAbeHvzLwqtL/3JYuBOtFK6HrRXmwot7FZwErd+25tsgJE+MtS3uSv/GumKtw6VIjdIdmmPUBmTlE9jbb9bi4+WUe6pKKNV95yLDj11bQJX/pxGuwHwMk48oA04VcpuqTvgkdqpwtCYYCCnccPSy7hOoHfUb2PqQVR/2AZxFaFhU4WV+lp0guh93MUPhKAmCh5hrp6nVddqTb+cAsMBkdQJu2c/Bsz6gwn6U6EPW1Wm6hYBI7dTy/88W2qSLgZgNhgQ7Wcd6NbKV/wiYeJmJ0hdFFSIcR67X/qNXOmwGkcPo8+dpG5Pxt9vPj6yHbGzxhnvNLkREA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skYNCdqcclV4Xy/B20rKqP0hODeBFJ8mVOubI7B8MWI=;
 b=JZJXDDsUJwKzxx9Tbqdoz9sRPhqQCn+QoAnc2isZl7t9L3MbueG5CFntcEptmQEQ6RcJLi86/eu3NuyfKgC/WKu+o3upYo06GteWfh1vsD2PV9Mp2YFz2wmqt9BB5g5huP/JqZoQ5nph2K1U/H5JqsPvgrS2wcUDMzCM8MBFzHk=
Received: from AM0PR05MB4130.eurprd05.prod.outlook.com (52.134.90.143) by
 AM0PR05MB5716.eurprd05.prod.outlook.com (20.178.113.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Fri, 4 Oct 2019 23:45:24 +0000
Received: from AM0PR05MB4130.eurprd05.prod.outlook.com
 ([fe80::c065:c533:7837:61a]) by AM0PR05MB4130.eurprd05.prod.outlook.com
 ([fe80::c065:c533:7837:61a%5]) with mapi id 15.20.2305.023; Fri, 4 Oct 2019
 23:45:24 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Thread-Topic: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Thread-Index: AQHVdInRxKc9Xqm18UKMerHkf/S7lqc+Ny4AgAy/zgCAADt/gA==
Date:   Fri, 4 Oct 2019 23:45:24 +0000
Message-ID: <20191004234519.GF13974@mellanox.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-5-jeffrey.t.kirsher@intel.com>
 <20190926173046.GB14368@unreal>
 <04e8a95837ba8f6a0b1d001dff2e905f5c6311b4.camel@intel.com>
In-Reply-To: <04e8a95837ba8f6a0b1d001dff2e905f5c6311b4.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YTOPR0101CA0039.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:14::16) To AM0PR05MB4130.eurprd05.prod.outlook.com
 (2603:10a6:208:57::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.162.113.180]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7ec7b49-304b-4fa4-35bc-08d74924eceb
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM0PR05MB5716:
x-microsoft-antispam-prvs: <AM0PR05MB57160F3EAE4FEBD28C6897B5CF9E0@AM0PR05MB5716.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 018093A9B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(199004)(189003)(6916009)(66556008)(64756008)(316002)(66066001)(1076003)(81156014)(81166006)(33656002)(54906003)(6512007)(3846002)(8936002)(6116002)(4326008)(6246003)(71200400001)(8676002)(71190400001)(66476007)(66446008)(256004)(66946007)(2906002)(86362001)(478600001)(7736002)(25786009)(305945005)(229853002)(5660300002)(14454004)(476003)(386003)(6506007)(446003)(11346002)(186003)(26005)(2616005)(102836004)(6486002)(99286004)(36756003)(76176011)(486006)(6436002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5716;H:AM0PR05MB4130.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zs7wQDRGu+qWnUaJtcquazD/ax4QtQgXXNU0oli9erxg7m+WR8GguDLTS5xQl1/8jvmYDWSU+8D4TkzHsAeI6GRY/8a5UadFDrD5KfDC4hj0ZE3tFuNW9Q2JpB4NK/dEcT9WjnvztGPf0hxeNQi93tCSP1QM9pt2zEjSDaI34VEBmeSrbHgUVD95Ssox5AiROmpjmS0bPDKFrNMXIaF76/x2AvoNFh21uMqQn53IbIxT694+ZbHNqDeZlBng7PLLAkjrXdMtQqR/KzqaWwuUm/ZHzgiLPa5rNvhuZTQdFkYBAlOdeqlAk5cmSDgBBnkDGVS9armTNZ1Ki16fH8f0a5+5BwtjRWahtWMshE27mOCp1p2ZrFQdSb1v3Pc1hluFLt7xj/rV4K7W8+ViTq0bus1p7N7zbkXxJKJVb4huZb0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <46FAF2E769B70B418129D4F9E746B5CF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7ec7b49-304b-4fa4-35bc-08d74924eceb
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2019 23:45:24.0811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k3eZgvnwJ8jGGgnipnvyBEGqUnexY4SineWjgH26xcHexioM395MkMbHBbPqHPf8EVuh0ZuJ7uqpdR9UC3CfUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 01:12:22PM -0700, Jeff Kirsher wrote:

> > > +	if (ldev->version.major !=3D I40E_CLIENT_VERSION_MAJOR ||
> > > +	    ldev->version.minor !=3D I40E_CLIENT_VERSION_MINOR) {
> > > +		pr_err("version mismatch:\n");
> > > +		pr_err("expected major ver %d, caller specified major
> > > ver %d\n",
> > > +		       I40E_CLIENT_VERSION_MAJOR, ldev->version.major);
> > > +		pr_err("expected minor ver %d, caller specified minor
> > > ver %d\n",
> > > +		       I40E_CLIENT_VERSION_MINOR, ldev->version.minor);
> > > +		return -EINVAL;
> > > +	}
> >=20
> > This is can't be in upstream code, we don't support out-of-tree
> > modules,
> > everything else will have proper versions.
>=20
> Who is the "we" in this context?

Upstream sensibility - if we start doing stuff like this then we will
end up doing it everwhere.

> you support out-of-tree drivers, they do exist and this code would
> ensure that if a "out-of-tree" driver is loaded, the driver will do a
> sanity check to ensure the RDMA driver will work.

I don't see how this is any different from any of the other myriad of
problems out of tree modules face.=20

Someone providing out of tree modules has to provide enough parts of
their driver so that it only consumes the stable ABI from the distro
kernel.

Pretty normal stuff really.

Jason
