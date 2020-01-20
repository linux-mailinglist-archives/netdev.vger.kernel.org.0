Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3F3143111
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 18:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgATRtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 12:49:45 -0500
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:18660
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726642AbgATRtp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 12:49:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kErpxvD0g6ou4wZmwUGdimDeeXxqn8Yx5hqvY6nkBbF2rR+qUKaxKPiJB0QHUBTUBIFVNVdsvllHf6S8o1vV/h0Tzk0+bCE0rkaO9XxWL8h43CNRDhHYQDPE30itfF+H6HxG76MCGyChvCVJiv2FTneBsvbILgynu718aFL8FBSO0S3Y/QdvpfPpAgdZ4+eKnJtZdIc4CLBUiNciORcQbrgvh0spsRWq/dP44oqkXyfGXJfPWs0SmXEOgfMWxKQXam2o6ZylhSAFx7BhTswNRY7Ac/zrVVFkbdVjHdFAklDpcnPQtvmUGxNRMkB8ogRi5eF0HIIQXaP4F20unBxQmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2yLUhjgddNodTMi+kzecKXqRwdT5XVOpS3BBx9zbUk=;
 b=SVAxzvFGMpmki9iN9EmYFZWD8NbKVFBLAyaj+jKERESMfqLZaF3iFalm5Yjw12nVaN417JaZD3qk0+qvF7Hr0MppS3gPiARAAFvpdq1H+rfgTaRtMhM72IY8XiVKWVEbqFXI1xhaZx3BtoJxn20eRpfKxMgou1MJHEbUljIzTzqxntLZFjqQBKB0E/oldshbuncREkfg4qMkPH3RSrASpSXPLFBvMS1QylQkmoMKpl+mG0QHQpdw+7y/5WCUSurQAASffj7ImT3sloWS8TaPGd/rTc5gtzH/0R3Hbx+Q+s7JNOasOPTkUCDP/E3unueFsVnLE1GZYLXX8hOSNwWvwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2yLUhjgddNodTMi+kzecKXqRwdT5XVOpS3BBx9zbUk=;
 b=Yk9RZ+qVaIospGrAcJ6b2Kc+COp4l649NUNF3b/foXUckKjVkCcsFjXaRSixE6bjRZBfuMLy/GKq2KEcZsyDC8ZvY9ShWviUUrlh0kV1/wsYNSjwIdpeDSDGE5gpYXxtH9bJVNBbkbY1XRxCPdpCkG+TzOJb/e6/s93mqhzQxK4=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB5741.eurprd05.prod.outlook.com (20.178.122.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Mon, 20 Jan 2020 17:49:39 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2644.024; Mon, 20 Jan 2020
 17:49:39 +0000
Received: from mlx.ziepe.ca (208.176.44.194) by SN4PR0401CA0044.namprd04.prod.outlook.com (2603:10b6:803:2a::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Mon, 20 Jan 2020 17:49:38 +0000
Received: from jgg by jggl.ziepe.ca with local (Exim 4.90_1)    (envelope-from <jgg@mellanox.com>)      id 1itbB7-0001Iy-Uo; Mon, 20 Jan 2020 13:49:33 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     Shahaf Shuler <shahafs@mellanox.com>,
        Rob Miller <rob.miller@broadcom.com>,
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
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Topic: [PATCH 3/5] vDPA: introduce vDPA bus
Thread-Index: AQHVzGqUgTlkW8H4N0+zRVK4Lh0XAKfuxkEAgAAbnwCAAAWygIACz0CAgAGL1YCAAJh1gA==
Date:   Mon, 20 Jan 2020 17:49:39 +0000
Message-ID: <20200120174933.GB3891@mellanox.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
In-Reply-To: <d69918ca-8af4-44b2-9652-633530d4c113@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN4PR0401CA0044.namprd04.prod.outlook.com
 (2603:10b6:803:2a::30) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2174ad8d-8dab-4fa1-7172-08d79dd11ed6
x-ms-traffictypediagnostic: VI1PR05MB5741:|VI1PR05MB5741:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB574136C4341C05536C1D3509CF320@VI1PR05MB5741.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(199004)(189003)(66946007)(2906002)(6916009)(66446008)(64756008)(33656002)(478600001)(66476007)(66556008)(316002)(2616005)(7416002)(4326008)(81156014)(8676002)(81166006)(26005)(5660300002)(1076003)(71200400001)(8936002)(52116002)(9786002)(4744005)(9746002)(36756003)(86362001)(186003)(54906003)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5741;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: snGUpjDYZrm/eUAeYDemX9Ua1Qlza/G4mgGTLencteJRuz6W/VY+bDQYf592ZOmYBtdKUr2S1/D5YfpBjSf0k/NBldSsfOq4QSZ01nSjWz5f+/E57GDB1z5C923AvHhRoA1HDhayYTBFMGif4FGWvGEpBC84iTtB4v7tcexwykRa54pD2SU2Ww15IIuinBcPqlK0wjMBKOxp7VVC+ckVNe0+AADEORCvUxKY5sBYJQ31bPigJ2Ql4UoV4oI1yN+JayiqJHE+BK2zLVzX0N85XeqiXZqoR4XXN8bP8AnsGVcTvX/m79+tED9N6I1p0mQVOqNcyj+CIO1ruqi+sg3xh8BZyPyXtfcyaIp5FWHXxCoGsD5LOIvy901rJAROQLskDPJ7XjCrApRU7yPqDl9fe/mH/dt/jvm8XDFHdKqHboQ52a5L5J4vG2tI0mVne4jeYslQ2RLrK5rxgH9BWBBVEKW3X9OK1eLVO/2CeHCUcInDl2HnQ4aBPKBGEzscNzMu
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AAA356A2330DEF40A2E3E29B75A5874E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2174ad8d-8dab-4fa1-7172-08d79dd11ed6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 17:49:39.0958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OY2YfhTHoiJbJJstF3GsY6GcaES8MqBw2znUf8scA6WytO3hDIEhnhl8Xmnv352mUN2U4OWGfIf9pNvmp42LWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 04:43:53PM +0800, Jason Wang wrote:
> This is similar to the design of platform IOMMU part of vhost-vdpa. We
> decide to send diffs to platform IOMMU there. If it's ok to do that in
> driver, we can replace set_map with incremental API like map()/unmap().
>=20
> Then driver need to maintain rbtree itself.

I think we really need to see two modes, one where there is a fixed
translation without dynamic vIOMMU driven changes and one that
supports vIOMMU.

There are different optimization goals in the drivers for these two
configurations.

> > If the first one, then I think memory hotplug is a heavy flow
> > regardless. Do you think the extra cycles for the tree traverse
> > will be visible in any way?
>=20
> I think if the driver can pause the DMA during the time for setting up ne=
w
> mapping, it should be fine.

This is very tricky for any driver if the mapping change hits the
virtio rings. :(

Even a IOMMU using driver is going to have problems with that..

Jason
