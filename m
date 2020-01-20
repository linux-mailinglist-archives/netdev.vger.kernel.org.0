Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69E97143311
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 21:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgATUw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 15:52:28 -0500
Received: from mail-db8eur05on2041.outbound.protection.outlook.com ([40.107.20.41]:61728
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726586AbgATUw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 15:52:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GinDkqLvzgbmalXmyMtMefJW3nmjuXcgxT87JPD2KJ8goziWb5dFzfRlYwM2zkKB4yWfNi93Wyu6/Jbk9iXdGtIyd26lOp+UgQqFWZwFaPZr/ise/ceHPG523DfZGA/R27pZdy44hZCA2p1uSMYorM2+C009LWp/l2AAZ1DArFpaFK5JSi1EEx1aVFZ/R7VGK8UuIqsiKKJl5XsINBRyl932+/X1lANfPYrsPUj8/g5uIfI+lpg+ZS06ppb8KHwuezXXF4anFaoigHcAG+1T8IoRJ1uXytAJQGtCg9iqOVrlBdNOEA+ifSd5lUQqB+iNb39HghOHGeMLtS6kpRvShQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BALKI9NsSM2rAos4Vxt8hfbiMtUUjSbmJC1+NsyQhls=;
 b=Ue4a3PhX7WPKXOWZIgyx3iFfxeF1a33kZlgn6AeWY8b41pmo6I1+MTem0yG/m2FnGMRSHUAAzwH8WzkTSZKrXOc7yJXSlp80jVc95uC4Rfa8VqXoMFMAKKymU+JjyDskbGupuIBhOhBZQn4vl/yvgEy/FjFNVHBoQnpVa+WJpN8mIaVoTT+5mUI6LFyC4VT3GYRabU4ypd1LVolGmCzKhQRbFywbws0in1dglqxfONgaTfryoHFL/P8N2zf6QXFRzO8DNxIyI/1zhSguu3K/qpvTOQxaApS9oWCnOLT2Q96mcJbRrXRiu8KFQCkT8QfX3UJp5SHq22nexDaTHLGN/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BALKI9NsSM2rAos4Vxt8hfbiMtUUjSbmJC1+NsyQhls=;
 b=ZI4tydE3ozP1fwSmARFAldlRlCa6V0gPoLoUp1EFueDMOXStDOTM5Av0SBCbUCo3RxFanW3wSvJ+btrawdXmdYlU40knGAhAmUr3KDaAKf/JUj6siRQWIcpQ57qPl7aFQ53L7TpqnVPtvap47NTK9NZoAtNwt7q/eaitHHtYIfg=
Received: from AM0PR0502MB3795.eurprd05.prod.outlook.com (52.133.45.150) by
 AM0PR0502MB3876.eurprd05.prod.outlook.com (52.133.48.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Mon, 20 Jan 2020 20:51:44 +0000
Received: from AM0PR0502MB3795.eurprd05.prod.outlook.com
 ([fe80::d862:228a:d87f:99bb]) by AM0PR0502MB3795.eurprd05.prod.outlook.com
 ([fe80::d862:228a:d87f:99bb%7]) with mapi id 15.20.2644.026; Mon, 20 Jan 2020
 20:51:44 +0000
From:   Shahaf Shuler <shahafs@mellanox.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        Jason Wang <jasowang@redhat.com>
CC:     Rob Miller <rob.miller@broadcom.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Ariel Adam <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: RE: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Topic: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Index: AQHVzGqTFJN2iC19r0STv/0Uj4sDPafuxkEAgAAbnwCAAAWygIACyO6wgAGSJ4CAAJh8gIAAMkCQ
Date:   Mon, 20 Jan 2020 20:51:43 +0000
Message-ID: <AM0PR0502MB3795C92485338180FC8059CFC3320@AM0PR0502MB3795.eurprd05.prod.outlook.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
 <20200120174933.GB3891@mellanox.com>
In-Reply-To: <20200120174933.GB3891@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shahafs@mellanox.com; 
x-originating-ip: [31.154.10.105]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eb4ec263-5f1e-49ac-f1eb-08d79dea8ee8
x-ms-traffictypediagnostic: AM0PR0502MB3876:|AM0PR0502MB3876:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB387684856DB6569E79273B38C3320@AM0PR0502MB3876.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(346002)(39860400002)(136003)(199004)(189003)(81156014)(81166006)(86362001)(478600001)(8676002)(76116006)(66946007)(52536014)(7416002)(33656002)(8936002)(66446008)(64756008)(66476007)(66556008)(26005)(9686003)(7696005)(6506007)(55016002)(2906002)(186003)(4326008)(316002)(110136005)(54906003)(5660300002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB3876;H:AM0PR0502MB3795.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HvYo1urlyLxjeYX7pRDEQ0gytB4zlLC73tpyt2mlGAEcOT7pOrgROhAiDO23XXwimGvk7fquLACm/iwSh2u2UTF64e3obID/6+4hbQdLrUV/f4L0p6/n6XZA2pIMV4HpNBIrvJqDOvZOv3xYtGNF/w92U+8smbeVu40nqkPyy/74Es791dEOVHNLWEug+eHn8ZXpdVhcbiRSXFSQVwKPKF+zYpt2L48tMzHw+KhLS+/i3JObMlafxI0H4hmTRPrLFJuXouEJm+VMj8S01ml7OLwr6NaLlX0alooUM9LhKoRos4IXFrryzSkjrXAUHhWIniEiwdxbUwUQnPqfSAVU1B2Bfw4ZZt7965BvkLAR+XiQe9VhiOUJXY/lVnFzPzCENmQeTKhHQ6zpVcQxMUX1s/QNvAzKUI+XwqRYqOA0XXLZ1dCPkC/0ttuQrR3XHPhr
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb4ec263-5f1e-49ac-f1eb-08d79dea8ee8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 20:51:44.1143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CBU9dbfDpUmSc4YQKFwCKGAo5AuIV7aQVk+gsSwzKrZWWXEZafcNt/pUrypeB5BuLReiVVdRLIRPd3nTQltu4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3876
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Monday, January 20, 2020 7:50 PM, Jason Gunthorpe:
> Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
>=20
> On Mon, Jan 20, 2020 at 04:43:53PM +0800, Jason Wang wrote:
> > This is similar to the design of platform IOMMU part of vhost-vdpa. We
> > decide to send diffs to platform IOMMU there. If it's ok to do that in
> > driver, we can replace set_map with incremental API like map()/unmap().
> >
> > Then driver need to maintain rbtree itself.
>=20
> I think we really need to see two modes, one where there is a fixed
> translation without dynamic vIOMMU driven changes and one that supports
> vIOMMU.
>=20
> There are different optimization goals in the drivers for these two
> configurations.

+1.
It will be best to have one API for static config (i.e. mapping can be set =
only before virtio device gets active), and one API for dynamic changes tha=
t can be set after the virtio device is active.=20

>=20
> > > If the first one, then I think memory hotplug is a heavy flow
> > > regardless. Do you think the extra cycles for the tree traverse will
> > > be visible in any way?
> >
> > I think if the driver can pause the DMA during the time for setting up
> > new mapping, it should be fine.
>=20
> This is very tricky for any driver if the mapping change hits the virtio =
rings. :(
>=20
> Even a IOMMU using driver is going to have problems with that..
>=20
> Jason
