Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B5214337E
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 22:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgATVsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 16:48:03 -0500
Received: from mail-vi1eur05on2059.outbound.protection.outlook.com ([40.107.21.59]:11444
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726752AbgATVsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 16:48:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hF/rwCMrcGtzSd97eLzdVmtcma5uC6++h3kUHm/ov5VB4VdghgBQzoREpHzhBpLJpR7G2NERrlmxyp6jdwOa+WpOm0NENunj2CFR1NsMyTglnrTiO/jWLIggycohPeGt+zlkKPWKWqzc9HNJK2jwvpkqgi34Tn0O3yxgACN4cWrRqCN4rzN22Rq3eubLJp6nIxMnfjoJ+SAJvEs6Xyt4uUqBoF1fLLN5HcItPGoKk7kqErWCdoznRSuHDvWxAq/1pvpLwDV8dy/bd3DiRrBLCniwgTGngI/Hh7UI9GRwM6B3+UeNSu+EMRgFxHNF8dxDgB4JVLunQhvIjYf5nupfdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVN0ts7kwstpmRcCDHVLONchns/EVV2V4JYssidp3Qo=;
 b=FPNF+1VVyQYZR1p1kP/BLP9OhpJh3fS/PrExe9OH5szn78CNJKkZYhYFenrktPmhsGaKkoWdSzos9KRrB4LSXaAgD5ns7iUoCbVf8KvOQp63sR9BhijRavW1r5I5CO6CTLiZp6UT156KyYWqRyXjxEVq/LE8dEY+Qb2cVWfYU35L8jUUoIEgOzf66VR0EWolBBFwZmotaOu83GLPTi+z0uNt5YBBti3xpr5qGAASC/O8pkCCf8rycAuGDAq+gaye8/jt+IDx7R5AJ26C45OpvyCMunvv92zPAFkvXvXfgrSdS4oJUN6uc6BE6NTJl0+ueWPZ3qBNVzpH3uChjbEq6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVN0ts7kwstpmRcCDHVLONchns/EVV2V4JYssidp3Qo=;
 b=e8apTrAexvfugJIqaVTcIsdKCuo0ttjhxJ83ggdru10hq+Mz8SDxmLtAK/qBxsD1Fhmd7NgqBBXSChymV2uKFcOjedtf4/x+nm8JC/4z3XyyXyEW+1VpohD2E4AWyvEY5HkL8vDd+CXrh1h3t7oP5+m4lHVmuXU3HXP5wda5Iys=
Received: from AM0PR0502MB3795.eurprd05.prod.outlook.com (52.133.45.150) by
 AM0PR0502MB4065.eurprd05.prod.outlook.com (52.133.39.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.22; Mon, 20 Jan 2020 21:47:18 +0000
Received: from AM0PR0502MB3795.eurprd05.prod.outlook.com
 ([fe80::d862:228a:d87f:99bb]) by AM0PR0502MB3795.eurprd05.prod.outlook.com
 ([fe80::d862:228a:d87f:99bb%7]) with mapi id 15.20.2644.026; Mon, 20 Jan 2020
 21:47:18 +0000
From:   Shahaf Shuler <shahafs@mellanox.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        Jason Wang <jasowang@redhat.com>,
        Rob Miller <rob.miller@broadcom.com>,
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
Thread-Index: AQHVzGqTFJN2iC19r0STv/0Uj4sDPafuxkEAgAAbnwCAAAWygIACyO6wgAGSJ4CAAJh8gIAAMkCQgAAKB4CAAAT0wA==
Date:   Mon, 20 Jan 2020 21:47:18 +0000
Message-ID: <AM0PR0502MB3795A7BE7F434964D6102517C3320@AM0PR0502MB3795.eurprd05.prod.outlook.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
 <20200120174933.GB3891@mellanox.com>
 <AM0PR0502MB3795C92485338180FC8059CFC3320@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <20200120162449-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200120162449-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shahafs@mellanox.com; 
x-originating-ip: [31.154.10.105]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4214a623-f18c-45d0-7067-08d79df25273
x-ms-traffictypediagnostic: AM0PR0502MB4065:|AM0PR0502MB4065:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB406596735EFF2A0317C1674FC3320@AM0PR0502MB4065.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(199004)(189003)(71200400001)(6506007)(54906003)(7416002)(5660300002)(33656002)(186003)(8936002)(26005)(86362001)(8676002)(81156014)(7696005)(81166006)(52536014)(9686003)(55016002)(316002)(478600001)(66946007)(66476007)(66556008)(4326008)(76116006)(6916009)(2906002)(64756008)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB4065;H:AM0PR0502MB3795.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R+2zejLVh1adLJrQLq0+/Q9JetP4uRz0YNh0/bTDqzwp2rxKOYb/pBoMYqE/AwhAH2Rg3FFT4cGdTMIq6vnM4ALxllk7WfMgWm9ZXgRiqSJBYGvKLPyEghWFGGzXC2F5tY79/kyJIfab9odlofDMiBiQ56yk/MgMBagzMSCLlS2+q9DDiKUliLvHeZia8CDhoHsRQCxjMif/Q687jEbJDZD4xQjLOlJFvT9JB06SIMIA/ThTgaBsG3xNNWeJyCA+5S495R/o5Iw4G6K7Ls5zhdNQra7Sa5fUJsPgb+KcUTdOX3anqjYHS4HY6oiulJHO0CM/PBp+ucH85Vg2hQjHt2sS0sGL+MfcECLNk/oOofdFfEM3jeSiz0pkGDbPZCGRU60/W45W3z01GwrP+5TgmOAp1NS8HEj3D8o35LGtZTLSuskOocolkNg8nWcpRBDV
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4214a623-f18c-45d0-7067-08d79df25273
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 21:47:18.4819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ny3ocHIZd/PYBUUiF9E5GYZJjqTmJPggC9PRSAO/n/VAUP41QkCX0q0HU0CxjrO0x7lIm93SVqVR3aF9SEivZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4065
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Monday, January 20, 2020 11:25 PM, Michael S. Tsirkin:
> Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
>=20
> On Mon, Jan 20, 2020 at 08:51:43PM +0000, Shahaf Shuler wrote:
> > Monday, January 20, 2020 7:50 PM, Jason Gunthorpe:
> > > Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
> > >
> > > On Mon, Jan 20, 2020 at 04:43:53PM +0800, Jason Wang wrote:
> > > > This is similar to the design of platform IOMMU part of
> > > > vhost-vdpa. We decide to send diffs to platform IOMMU there. If
> > > > it's ok to do that in driver, we can replace set_map with increment=
al API
> like map()/unmap().
> > > >
> > > > Then driver need to maintain rbtree itself.
> > >
> > > I think we really need to see two modes, one where there is a fixed
> > > translation without dynamic vIOMMU driven changes and one that
> > > supports vIOMMU.
> > >
> > > There are different optimization goals in the drivers for these two
> > > configurations.
> >
> > +1.
> > It will be best to have one API for static config (i.e. mapping can be
> > set only before virtio device gets active), and one API for dynamic
> > changes that can be set after the virtio device is active.
>=20
> Frankly I don't see when we'd use the static one.
> Memory hotplug is enabled for most guests...

The fact memory hotplug is enabled doesn't necessarily means there is not c=
old-plugged memory on the hot plugged slots.=20
So your claim is majority of guests are deployed w/o any cold-plugged memor=
y?=20

>=20
> > >
> > > > > If the first one, then I think memory hotplug is a heavy flow
> > > > > regardless. Do you think the extra cycles for the tree traverse
> > > > > will be visible in any way?
> > > >
> > > > I think if the driver can pause the DMA during the time for
> > > > setting up new mapping, it should be fine.
> > >
> > > This is very tricky for any driver if the mapping change hits the
> > > virtio rings. :(
> > >
> > > Even a IOMMU using driver is going to have problems with that..
> > >
> > > Jason

