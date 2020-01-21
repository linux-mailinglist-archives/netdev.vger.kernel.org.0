Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CA7143EFA
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgAUOMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:12:13 -0500
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:54286
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727508AbgAUOMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 09:12:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nV+xZ2xxbNyiaDV5Tzs8zPgEh0ev2Yz1BzHFWJ+WzIXJt/+Ju7suACgf8bh1FBBBNph2HJjzXOlOTundKZo62VF8+xOHHbcJeWQbQMpE79DyYToRc1LwMj1DJ4sl1EqjzUCKs3lWePyhqIyDftRc9DKxT4RAMm1UQOvpLjdpleOL0Df/Njr6ALKvBnNK9JX2fusOO9SagQNW/UMtkbkovDkZfupHDUVmYukWCKdC04PwLjSVhgenHOFUQxo8oJB7oVBd/tay2MlrsZvZN4h2yrQlTpFFp1wURNsRrEVyUPsxtSP/yy64I4y39fP+oVcBGU28CdzbtBJvf7XZ34RyBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JgSIX5Rej5Ob9G+61C5OGPSNuPeBILHSNLndvnJWpCI=;
 b=m0iil/UFUo/T7urjLhc2jMvYETCMVi7LmVfJTiTKkVWBS0jadNciIZhGY7kIxEEzu9EH5r6zsrggT5Kj3ezxm2dfRLDZ3fq9DHHG/E5bwFR0SuDGoaShGbYqqr+eykB1f1/dxPtAqzVxjDD4QENKfBxAcCootu2P+D+uGaomLXt1CHUe0qMNIUvdImy0/O9APr36gs7dd3H9S+ITItyDN4VruDkYABZMZDEDxxlWCucs9furtv3b8N1N5p7J2qPiMPyhZ5Atpsr+PQ+hwRNDk3mYO7RdTI/jqKKlFDCkK4bWYhsiHTEVGg6+MURJB+i/hmD+zEC2ZXnK8ndu7RbgSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JgSIX5Rej5Ob9G+61C5OGPSNuPeBILHSNLndvnJWpCI=;
 b=XNXkH6ScmAcQgV4/Cphx55LdWCvdAyjmofAygO6R5GC2MYGFphhw0nHyY5EfVT+EVjW9oMfKIzhPogLr+JnIzp5JQHjiaiIIltNe5fTz3N2sIr+f/DBuW+VCHbVRlBkpFirJbvredPY2cjxz0hnrtuX9YHKYXXZnWsGrocZbRrU=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB6126.eurprd05.prod.outlook.com (20.178.205.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Tue, 21 Jan 2020 14:12:05 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 14:12:05 +0000
Received: from mlx.ziepe.ca (12.231.255.114) by SN4PR0701CA0039.namprd07.prod.outlook.com (2603:10b6:803:2d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Tue, 21 Jan 2020 14:12:05 +0000
Received: from jgg by jggl.ziepe.ca with local (Exim 4.90_1)    (envelope-from <jgg@mellanox.com>)      id 1ituG8-00033E-CM; Tue, 21 Jan 2020 10:12:00 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Topic: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Index: AQHVzGqUgTlkW8H4N0+zRVK4Lh0XAKftaJqAgADD3wCAALX/gIAEm9kAgABdJwCAAESHAIABEKoA
Date:   Tue, 21 Jan 2020 14:12:05 +0000
Message-ID: <20200121141200.GC12330@mellanox.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200116152209.GH20978@mellanox.com>
 <03cfbcc2-fef0-c9d8-0b08-798b2a293b8c@redhat.com>
 <20200117135435.GU20978@mellanox.com>
 <20200120071406-mutt-send-email-mst@kernel.org>
 <20200120175050.GC3891@mellanox.com>
 <20200120164916-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200120164916-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0701CA0039.namprd07.prod.outlook.com
 (2603:10b6:803:2d::28) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.231.255.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fc192fcb-d9e4-47f8-e8bf-08d79e7be4d2
x-ms-traffictypediagnostic: VI1PR05MB6126:|VI1PR05MB6126:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB612633D15B57B70EBD5E9DDCCF0D0@VI1PR05MB6126.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(199004)(189003)(26005)(81156014)(86362001)(7416002)(6916009)(71200400001)(52116002)(8936002)(186003)(1076003)(478600001)(33656002)(4744005)(81166006)(8676002)(2616005)(5660300002)(4326008)(9746002)(66556008)(36756003)(66476007)(66946007)(9786002)(64756008)(66446008)(54906003)(2906002)(316002)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6126;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AkQT1Jvn7vb1mlkKQ70NhJBVP3lvAQ1BXMCNDIrqYDYT1ifl6hcQBTBYKgHwfm0770Ulz3HgleTHxUaSBR8Ze77cOcICPhIrqhQ0Ak10NJrI0M87xygRwjl7aKyIKLSXM0trdhG7hEC0ilDoS7EPcNFSkM3gZH5AyZ40d7KHt7EJCRmzXUGqJuZdiScwUx4xn5VJdxNCYl2A48vioe5zGX8zrDkUhSkf8ZWuNwsjY5hFPZ9att+KzlCyOs4/7wb3nSlpdMckMxZ5JyJwzV83m9AX8eWPV23jDbahkw44z4iflUM2GPz6bqwKfET82zyYBKMSCqtuVXKWNwPVtWOq/Bk7ASks/UUOTI61fjSLZxug3abbEeWdIvgx4iGTu8K86h9C9ztxzkaowPgO580Q8lMmGXHrSHmIir0ihLD6RHBPKmWginE2NgpQxeMVV477bezBDlAJ/JGheyFHOigoSmMFgj2fEtVK9jSzfn2cKxgadf1ThjaoqBngjn76lQJl
Content-Type: text/plain; charset="us-ascii"
Content-ID: <94EE7557C61D6249B42BBC493D5A18F4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc192fcb-d9e4-47f8-e8bf-08d79e7be4d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 14:12:05.5056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aV75+HY1W3XMM5wwesld8kaLEunXJ6LpK1HZEnE3lxjdvZvWvYWRIbX9sAfZCZ7YeWiWtH82yIMu5IIBnhJtsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 04:56:06PM -0500, Michael S. Tsirkin wrote:
> > For vfio? vfio is the only thing I am aware doing
> > that, and this is not vfio..
>=20
> vfio is not doing anything. anyone can use a combination
> of unbind and driver_override to attach a driver to a device.
>=20
> It's not a great interface but it's there without any code,
> and it will stay there without maintainance overhead
> if we later add a nicer one.

Well, it is not a great interface, and it is only really used in
normal cases by vfio.

I don't think it is a good idea to design new subsystems with that
idea in mind, particularly since detatching the vdpa driver would not
trigger destruction of the underlying dynamic resource (ie the SF).

We need a way to trigger that destruction..

Jason=20
