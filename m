Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBE41436EA
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 07:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgAUGCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 01:02:20 -0500
Received: from mail-db8eur05on2041.outbound.protection.outlook.com ([40.107.20.41]:6031
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725789AbgAUGCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 01:02:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J530pE8L1vUSkDDb345txFGHtWi1AKHu6WRCSnlk5E4xiec3O24UPzE/secxZdeVAPrbivdbHQC4SNxhurK3ApKM5mEc9DlUdmUl6alikxunQezG/J/hCeni4nx75reRAOvG2nUm6b0hwRE+ZZzt4YyKnyxdMvHJgZ1PvtGDKdzxcOza9LRDCT1tNMpVrtVqYTsENdyLw4xbtQLlWEv6OlDVp9CHiq8s+89jWV1AOloxInI1AdIymE1IECfP2UBAJDzgrDo/LCQGR5y1dAYmGUAqVKK5ExUJ2AQPE1KmxkIMWTwlf7wYagYpX451kAS3bX1mULwEPFQzxJqsW2QXtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OV6oVxzNKDpc3oMB7BGA8Ta50prbaytyH5sixDUz9mw=;
 b=EWUwPtv0emiLJFmmkRV8+SAh8yU8aZi3i/MhEc7z6EpmKNoNPrCO+J8v2Uz1ly8FoRkVovI2XYr6PvlbIM3E7TWxtrUqIqJ2PAO201YnyqyIbRLP0YJc2XT2egvZNz6+D/UXdu/naVjZjaSOEs/i6pQphcmDsVI83+SbIYTg5LJ9rOQzFMimmNLc0cSaIssQfN0LeRdsoVxwE0COGGmx0Rlh24wRRTrbWbOzESaTreYMZ9TfEXdtNDkr4U243vO0Kwk6tsXAwIpe9Uy9vQH/5/6gCaaTb9ij+HVL2oQl/c8t0dLFSbGTYMFtf8rEy2m/UsLxbBCt7E1fpXoZGfSxgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OV6oVxzNKDpc3oMB7BGA8Ta50prbaytyH5sixDUz9mw=;
 b=lcFWv8XIZ7oypTqEZyZDGkQbkxzGoHMHMDg5g5Cj3bT8yWv0eHkyj2HnqW2lZpUQ8rj8UjSFKf4AxUGUF7y4z+zmt/718jxL/bUdZAzADcDzJ5WhgadlQMCLvgqG1LHO9I5sLYeBhrYAMzgiXoPP4LgE6FGWxm4TlmVzWEk+T/E=
Received: from AM0PR0502MB3795.eurprd05.prod.outlook.com (52.133.45.150) by
 AM0PR0502MB4068.eurprd05.prod.outlook.com (52.133.38.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Tue, 21 Jan 2020 06:01:36 +0000
Received: from AM0PR0502MB3795.eurprd05.prod.outlook.com
 ([fe80::d862:228a:d87f:99bb]) by AM0PR0502MB3795.eurprd05.prod.outlook.com
 ([fe80::d862:228a:d87f:99bb%7]) with mapi id 15.20.2644.026; Tue, 21 Jan 2020
 06:01:36 +0000
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
Thread-Index: AQHVzGqTFJN2iC19r0STv/0Uj4sDPafuxkEAgAAbnwCAAAWygIACyO6wgAGSJ4CAAJh8gIAAMkCQgAAKB4CAAAT0wIAABKAAgACDJzA=
Date:   Tue, 21 Jan 2020 06:01:35 +0000
Message-ID: <AM0PR0502MB3795940D8E0A269D4A32FF8FC30D0@AM0PR0502MB3795.eurprd05.prod.outlook.com>
References: <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
 <20200120174933.GB3891@mellanox.com>
 <AM0PR0502MB3795C92485338180FC8059CFC3320@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <20200120162449-mutt-send-email-mst@kernel.org>
 <AM0PR0502MB3795A7BE7F434964D6102517C3320@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <20200120165640-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200120165640-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shahafs@mellanox.com; 
x-originating-ip: [31.154.10.105]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4b8c523a-9dfa-40ed-10d3-08d79e375fb2
x-ms-traffictypediagnostic: AM0PR0502MB4068:|AM0PR0502MB4068:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB40680FF65C1B14E21847D1FEC30D0@AM0PR0502MB4068.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(6506007)(81156014)(81166006)(6916009)(8676002)(54906003)(52536014)(5660300002)(71200400001)(7696005)(316002)(86362001)(7416002)(478600001)(2906002)(186003)(76116006)(55016002)(66476007)(64756008)(66556008)(66446008)(9686003)(33656002)(8936002)(66946007)(4326008)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB4068;H:AM0PR0502MB3795.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K/cox9n5S/YveOFmsjzGJx5Hn69HAfu7+uKCAYcvEyZUfDQKjqQuI9nV/5LhvlRMynJiSDd1ibrBoU+XBseAo4Y3+iY48Yk2cDxsClbqILLP0dNlSdiUuI8tj+pc/LRWX3na3zCT43qqJhUJHCnH3p6twH/zVT6Z5HurdKE8oO/h+yo8505dgay0OtT05liLEvtYRkGAphPTj8G75VhOiaSvm8z7jnZg+kpkV4mkYySLhpVccceadAo5j9k3MAKLmcnyyCnr6PH+rvGLx8EB3z5Sw8zM0RovXE2IH0Ki9iCoaPm8HjzUF9E+N9UPvN6hehqtG+LBD61ALNj7WdSf2hgWZOHt+YmbM/8qfkn+n6IjRaFwQe2pgpkS4WQMkfmBUEfE1Uhx4SjTT5ZWtxF2Prrl8iiFwOL7bwkfCv2W1W2BwNJR08lSwaV0+aSapxyx
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b8c523a-9dfa-40ed-10d3-08d79e375fb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 06:01:36.0140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r01f4LBK9w+kxopI8CuL/mfXsTMsdmU/r2xTu6W0xOr9Dksjpi+vosKZrUtbxAcZuaqS0Kiapr21EO2vY/7+zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4068
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tuesday, January 21, 2020 12:00 AM, Michael S. Tsirkin:
> Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
>=20
> On Mon, Jan 20, 2020 at 09:47:18PM +0000, Shahaf Shuler wrote:
> > Monday, January 20, 2020 11:25 PM, Michael S. Tsirkin:
> > > Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
> > >
> > > On Mon, Jan 20, 2020 at 08:51:43PM +0000, Shahaf Shuler wrote:
> > > > Monday, January 20, 2020 7:50 PM, Jason Gunthorpe:
> > > > > Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
> > > > >
> > > > > On Mon, Jan 20, 2020 at 04:43:53PM +0800, Jason Wang wrote:
> > > > > > This is similar to the design of platform IOMMU part of
> > > > > > vhost-vdpa. We decide to send diffs to platform IOMMU there.
> > > > > > If it's ok to do that in driver, we can replace set_map with
> > > > > > incremental API
> > > like map()/unmap().
> > > > > >
> > > > > > Then driver need to maintain rbtree itself.
> > > > >
> > > > > I think we really need to see two modes, one where there is a
> > > > > fixed translation without dynamic vIOMMU driven changes and one
> > > > > that supports vIOMMU.
> > > > >
> > > > > There are different optimization goals in the drivers for these
> > > > > two configurations.
> > > >
> > > > +1.
> > > > It will be best to have one API for static config (i.e. mapping
> > > > can be set only before virtio device gets active), and one API for
> > > > dynamic changes that can be set after the virtio device is active.
> > >
> > > Frankly I don't see when we'd use the static one.
> > > Memory hotplug is enabled for most guests...
> >
> > The fact memory hotplug is enabled doesn't necessarily means there is n=
ot
> cold-plugged memory on the hot plugged slots.
> > So your claim is majority of guests are deployed w/o any cold-plugged
> memory?
>=20
> Sorry for not being clear. I was merely saying that dynamic one can't be
> optional, and static one can. So how about we start just with the dynamic
> one, then add the static one as a later optimization?

Since we have the use case (cold plugged memory to guest, e.g. when populat=
ed w/ hugepages) I think we should start w/ both. The static one can be opt=
ional for drivers.=20

Moreover am not yet clear about the suggested API for dynamic, can you shar=
e the prototype you have in mind?
Also will it be :
1. multiple add_map and then flag the driver to set
Or
2. each add_map should be set by the driver as stand alone.=20

