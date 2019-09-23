Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7C3BBD82
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 23:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502930AbfIWVCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 17:02:44 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:19014
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2502584AbfIWVCo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 17:02:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bx3BWJaVzuclcnSCCTZ3+q9kSC6XqcHz9tDIbHMdjWMdejkCN/Q6ad7q8EqXXXSqIMKvV7e09AQ3Y0V/AzDvL0I8j1SsREJXEc+TR9neWP60/pEg6MdLBGq39LbVN5tV3nr4svlt/IoO8yBlLlqVJW4VnW6jQB00qvqLlwAaHtu+MafUgGVm9UUeJqsPD0tfOXpK3vQ0+UXDdz3x1NhlI3kspxpAlRRQDU2mZj0wkYaJf8nUI8NR+DDBqi1fy25M/C6oxQmUNjzSE9jPKjEjK8MommiRsdfqRc8JJf4NOrDGiPn/tvYqmzE0lynz5QEM09tARHeuS1XLNGrX4b+2AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUgww1O+SotrZSvEPpBNEqpue37Qo5fZklgsQJmJva4=;
 b=efmaCXrY5cFWnolQdk9qVUgIMfj5srbRT7La8Vmz3G9BxJHenIydTK2cfuUQvfUiIyQ2BIuQCG6SDh1Fq2XUomXyZkorgkItNlSAkOM8XVqa4rQiJyRqlDS84ylium+Dx7v9V9pLCB+CIJRRDmH6v9qJAqQl+ZNReAeU4aXLpovKLmO+c0zmw4XzdG74VMH0LDBMapdib9YE7B2oLyFbN1tnusiEP9lxk57g5VvlAWddXRvBeenXZn7C3nKXbKapzR5NyHvouD/hX8uzawPkAtukTLyQMXvw7sLWXA1kXoIm5wxT5XEiXsidGF+ymgnHwlWMo6UkEYa+vQXcZ1Fiqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUgww1O+SotrZSvEPpBNEqpue37Qo5fZklgsQJmJva4=;
 b=FtHAMnug5/xWIjub1VPMDx8+7WHJtaXHZ+Yuh8Kl8XoaB1+QbPN/bBEPJ+P/Rg+L6Dsn3WX7/CdbK6YpQnYHjF+PNZF3+72mWh8fjoaQjg8DVag+rP/Ai8bsZcxACw8tQ3dPle8+PAjInFDFivz32BNCFeyVaRexwely1r1/i5k=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4913.eurprd05.prod.outlook.com (20.177.41.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.22; Mon, 23 Sep 2019 21:02:39 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::bc4c:7c4c:d3e2:8b28%6]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 21:02:39 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "zhi.a.wang@intel.com" <zhi.a.wang@intel.com>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "joonas.lahtinen@linux.intel.com" <joonas.lahtinen@linux.intel.com>,
        "rodrigo.vivi@intel.com" <rodrigo.vivi@intel.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "sebott@linux.ibm.com" <sebott@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        Ido Shamay <idos@mellanox.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>
Subject: RE: [PATCH 1/6] mdev: class id support
Thread-Topic: [PATCH 1/6] mdev: class id support
Thread-Index: AQHVcg9tP+s325DFukm8x3s6EiJzu6c5v99w
Date:   Mon, 23 Sep 2019 21:02:38 +0000
Message-ID: <AM0PR05MB486657BB8E48F744D219CF9BD1850@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190923130331.29324-1-jasowang@redhat.com>
 <20190923130331.29324-2-jasowang@redhat.com>
In-Reply-To: <20190923130331.29324-2-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75c0b691-181e-4156-7702-08d740695e12
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4913;
x-ms-traffictypediagnostic: AM0PR05MB4913:|AM0PR05MB4913:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB49134659721B286F51A1A69ED1850@AM0PR05MB4913.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(346002)(366004)(396003)(136003)(376002)(199004)(189003)(13464003)(7406005)(256004)(478600001)(26005)(55016002)(6436002)(486006)(229853002)(102836004)(71200400001)(53546011)(25786009)(76176011)(71190400001)(6506007)(54906003)(316002)(7696005)(446003)(110136005)(186003)(52536014)(9686003)(966005)(5660300002)(11346002)(6306002)(64756008)(7736002)(3846002)(6116002)(66476007)(66066001)(66446008)(476003)(2501003)(74316002)(2906002)(4326008)(81166006)(81156014)(8676002)(8936002)(66946007)(66556008)(305945005)(86362001)(76116006)(6246003)(14454004)(7416002)(99286004)(2201001)(33656002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4913;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4fhTK+flDcZ2Jj7ds0yII8EAdhFtYJtyJGhrvd6cCn9iVvOydVcSmirbFmKp/sOCHTzXoli8YLtXp1aQwAcmCFEASxkM3Huj2Cf1MZO/AqD9aKLYcYqK3dFg8pHgEhvgaRiqRiOsVDlLchs1i8zZhZNP2vZmDokNApGRfO2ZeZKoRw3HVc/ip04UgYlqJIK7Xtki+zmsDCbVA52t2RGhFPX2bYm7TldrGGYKqgmbOHcVi8Wz/GySOlQO3JxAuZdDKaP+kcNcePV/XriBYqNYSt7yiz5Y/UB/YLjdH2lnVmP8IvAQQGFR69+u6bnl8JwprD44YX0N+O2dzgHADhTdlrmm/RP9Ls+de+WRvn1m514fXaT1j28eWlw8QgIImcDoH3udKpQTAja0FnIb38ajYVOrjMmESM2nUhQ1CnLeLeY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75c0b691-181e-4156-7702-08d740695e12
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 21:02:38.8737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vZYdqqU8fCZF62yOFudeIR+5hhqf4+mL9KDaGh3yNO7TGXerVBrjm1J+hztV9sOHKPVNGFUcTb0A6s0YkZSdFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4913
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,


> -----Original Message-----
> From: Jason Wang <jasowang@redhat.com>
> Sent: Monday, September 23, 2019 8:03 AM
> To: kvm@vger.kernel.org; linux-s390@vger.kernel.org; linux-
> kernel@vger.kernel.org; dri-devel@lists.freedesktop.org; intel-
> gfx@lists.freedesktop.org; intel-gvt-dev@lists.freedesktop.org;
> kwankhede@nvidia.com; alex.williamson@redhat.com; mst@redhat.com;
> tiwei.bie@intel.com
> Cc: virtualization@lists.linux-foundation.org; netdev@vger.kernel.org;
> cohuck@redhat.com; maxime.coquelin@redhat.com;
> cunming.liang@intel.com; zhihong.wang@intel.com;
> rob.miller@broadcom.com; xiao.w.wang@intel.com;
> haotian.wang@sifive.com; zhenyuw@linux.intel.com; zhi.a.wang@intel.com;
> jani.nikula@linux.intel.com; joonas.lahtinen@linux.intel.com;
> rodrigo.vivi@intel.com; airlied@linux.ie; daniel@ffwll.ch;
> farman@linux.ibm.com; pasic@linux.ibm.com; sebott@linux.ibm.com;
> oberpar@linux.ibm.com; heiko.carstens@de.ibm.com; gor@linux.ibm.com;
> borntraeger@de.ibm.com; akrowiak@linux.ibm.com; freude@linux.ibm.com;
> lingshan.zhu@intel.com; Ido Shamay <idos@mellanox.com>;
> eperezma@redhat.com; lulu@redhat.com; Parav Pandit
> <parav@mellanox.com>; Jason Wang <jasowang@redhat.com>
> Subject: [PATCH 1/6] mdev: class id support
>=20
> Mdev bus only supports vfio driver right now, so it doesn't implement mat=
ch
> method. But in the future, we may add drivers other than vfio, one exampl=
e is
> virtio-mdev[1] driver. This means we need to add device class id support =
in bus
> match method to pair the mdev device and mdev driver correctly.
>=20
> So this patch adds id_table to mdev_driver and class_id for mdev parent w=
ith
> the match method for mdev bus.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  Documentation/driver-api/vfio-mediated-device.rst |  7 +++++--
>  drivers/gpu/drm/i915/gvt/kvmgt.c                  |  2 +-
>  drivers/s390/cio/vfio_ccw_ops.c                   |  2 +-
>  drivers/s390/crypto/vfio_ap_ops.c                 |  3 ++-
>  drivers/vfio/mdev/mdev_core.c                     | 14 ++++++++++++--
>  drivers/vfio/mdev/mdev_driver.c                   | 14 ++++++++++++++
>  drivers/vfio/mdev/mdev_private.h                  |  1 +
>  drivers/vfio/mdev/vfio_mdev.c                     |  6 ++++++
>  include/linux/mdev.h                              |  7 ++++++-
>  include/linux/mod_devicetable.h                   |  8 ++++++++
>  samples/vfio-mdev/mbochs.c                        |  2 +-
>  samples/vfio-mdev/mdpy.c                          |  2 +-
>  samples/vfio-mdev/mtty.c                          |  2 +-
>  13 files changed, 59 insertions(+), 11 deletions(-)
>=20
You additionally need modpost support for id table integration to modifo, m=
odprobe and other tools.
A small patch similar to this one [1] is needed.
Please include in the series.

[1] https://lore.kernel.org/patchwork/patch/1046991/


