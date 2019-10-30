Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D74E9E11
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfJ3O5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:57:06 -0400
Received: from mail-eopbgr820043.outbound.protection.outlook.com ([40.107.82.43]:31296
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726518AbfJ3O5G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 10:57:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXxkB0FnqHeCOtqZcXfBjp884+JgkkOdnqCjlCUTC0XzhNTSOCDEcjkceoZM/MnnbbnCRAcN0icm3UjPQ8wAsL3f46Y/IdFoyBcYqbxxXM8fuwpfhuAtQJrMS9dyTqWF5B6C7zAgLCPLQtCKw1hICBi+JuvXHfOxXrmApF3d5dNmWr2bEahvrTgadZu4RJxXeO/rdkC5lOXtqSNFWnx+gcJ79hv73R09VM89DY6qePXIVFofOtsLGq3vf4nGljqsZF0VQKMopuBGhiKhiY5+s+gXrhMHi8fU/tReDxH0NJQw6ACSxmfL5iTECAcgO0ib67RuWTPwH+rEqsbt0Jveeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bAdktAW9j4STi0PjJe5ciUX6edDsIPVGCzG750c0d38=;
 b=PZDvhQgQBtl83mFTklkHTOcOii6tZaTdpZ24zmHXTSjCNaGJZMi6de0njpIx+cUvNJp0TWIJ0qjdXpbMmkrvdc2OE/a4267N61NA+P1w/scVYBVNZVxdSa4E4o8peHK3IScMuARFMZNgKbAV31aHvG0TPbSpZIO6sA0q3GkT2ebmuZ59dQi30Ih2yPwOMKK6uyss7JcQkqdwgFdz+OC7Ym/rxFC/zAfcKayBCYKdVDTusE8mJpc8S79ovhIJ6h638dbiaSDGk7Cq87l3Ppnf4lu44DFtjN0igJDxLvX74wH0cu0uXStTtyCrXRxPS43o2rO3B6FU2AE1Kylba3fBTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bAdktAW9j4STi0PjJe5ciUX6edDsIPVGCzG750c0d38=;
 b=eWOq8MTgxavFXXNzmL3RAiUbqXEiahPuaWePrlJLFEVsfUTBtfafDY4qvIx1M7EOuOu7vGqDN8DJg1YALdoc7diMXh1Y3rnK0E06YfmmFj6T7pc2zahpYeS5j7tZXty4HmVGhbarQy4cTd8Ud1+dxZX3VZp4Rgj3HHcnsFazsPA=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB3390.namprd05.prod.outlook.com (10.174.175.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.15; Wed, 30 Oct 2019 14:57:03 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209%7]) with mapi id 15.20.2408.018; Wed, 30 Oct 2019
 14:57:02 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     'Stefano Garzarella' <sgarzare@redhat.com>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 03/14] vsock: remove include/linux/vm_sockets.h
 file
Thread-Topic: [PATCH net-next 03/14] vsock: remove include/linux/vm_sockets.h
 file
Thread-Index: AQHViYgoRCd14Ilyok2RZer4OBK3yadzUUBA
Date:   Wed, 30 Oct 2019 14:57:02 +0000
Message-ID: <MWHPR05MB3376B0A779F775D0603EE752DA600@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-4-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-4-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [146.247.47.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cfc3b3e-4577-4ef1-7daa-08d75d496c77
x-ms-traffictypediagnostic: MWHPR05MB3390:
x-microsoft-antispam-prvs: <MWHPR05MB33901C0168DD59B355EDE4BCDA600@MWHPR05MB3390.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:291;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(199004)(189003)(81156014)(33656002)(52536014)(55016002)(54906003)(4326008)(81166006)(2906002)(316002)(86362001)(25786009)(8676002)(478600001)(7416002)(256004)(14444005)(6436002)(14454004)(66066001)(8936002)(99286004)(9686003)(6116002)(71190400001)(64756008)(6246003)(102836004)(66476007)(66946007)(76116006)(6916009)(229853002)(53546011)(71200400001)(66446008)(74316002)(486006)(7696005)(6506007)(186003)(11346002)(476003)(446003)(26005)(7736002)(305945005)(3846002)(76176011)(5660300002)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3390;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GrfTeYI96Gjg0M0ECtMpFDQ2PVdyCmY9FwdbgIDp29scDRyuYpTKfYGqj0juNV8PfjWlYKTzjlkgkZrUvOcJ6q2Oadw8M+mzoN7IqV9slKshEkGjul65wk5a60zklgp5gO1akYTucGLggR/KatC2AIghmhhkRlT1rv6WoCBDJSwnWhXnFx/2SWUNFas5+swI2K0zsLTbIShL+KJNSvoKUS4Y83jjUPRr0rmLhDFWocTxcvs5Oj4oQoKo12eDo34bi+DU/MdNFaaEVc+Opr1xW2LeL4e+0tjXaTsB/HuhWnOvwC8q0ystgjLWukdC41eczI/6Atbu+9JqoysDwRuQHtxN5OgjOOnTYF4sHPVO0Qn4gaclEQwADBhI1y3iOyOzI98qI2SrkOh5ET7ugByxjmtEa3wYWra/f22YH7PeK3V86ZhLuRpPOivyzHcPlis+
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cfc3b3e-4577-4ef1-7daa-08d75d496c77
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 14:57:02.9670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bZtiOJ8MWBPmqBlit5l/TzsLAuC/r83GSsc+YDEyft+y87KO1ffEcdV2DR7bumQQxAhgMsGV5Lv+ZfgkD2/kDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3390
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> Sent: Wednesday, October 23, 2019 11:56 AM
> Subject: [PATCH net-next 03/14] vsock: remove include/linux/vm_sockets.h
> file
>=20
> This header file now only includes the "uapi/linux/vm_sockets.h".
> We can include directly it when needed.
>=20
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/linux/vm_sockets.h            | 13 -------------
>  include/net/af_vsock.h                |  2 +-
>  include/net/vsock_addr.h              |  2 +-
>  net/vmw_vsock/vmci_transport_notify.h |  1 -
>  4 files changed, 2 insertions(+), 16 deletions(-)  delete mode 100644
> include/linux/vm_sockets.h
>=20
> diff --git a/include/linux/vm_sockets.h b/include/linux/vm_sockets.h
> deleted file mode 100644 index 7dd899ccb920..000000000000
> --- a/include/linux/vm_sockets.h
> +++ /dev/null
> @@ -1,13 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-only */
> -/*
> - * VMware vSockets Driver
> - *
> - * Copyright (C) 2007-2013 VMware, Inc. All rights reserved.
> - */
> -
> -#ifndef _VM_SOCKETS_H
> -#define _VM_SOCKETS_H
> -
> -#include <uapi/linux/vm_sockets.h>
> -
> -#endif /* _VM_SOCKETS_H */
> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h index
> 80ea0f93d3f7..c660402b10f2 100644
> --- a/include/net/af_vsock.h
> +++ b/include/net/af_vsock.h
> @@ -10,7 +10,7 @@
>=20
>  #include <linux/kernel.h>
>  #include <linux/workqueue.h>
> -#include <linux/vm_sockets.h>
> +#include <uapi/linux/vm_sockets.h>
>=20
>  #include "vsock_addr.h"
>=20
> diff --git a/include/net/vsock_addr.h b/include/net/vsock_addr.h index
> 57d2db5c4bdf..cf8cc140d68d 100644
> --- a/include/net/vsock_addr.h
> +++ b/include/net/vsock_addr.h
> @@ -8,7 +8,7 @@
>  #ifndef _VSOCK_ADDR_H_
>  #define _VSOCK_ADDR_H_
>=20
> -#include <linux/vm_sockets.h>
> +#include <uapi/linux/vm_sockets.h>
>=20
>  void vsock_addr_init(struct sockaddr_vm *addr, u32 cid, u32 port);  int
> vsock_addr_validate(const struct sockaddr_vm *addr); diff --git
> a/net/vmw_vsock/vmci_transport_notify.h
> b/net/vmw_vsock/vmci_transport_notify.h
> index 7843f08d4290..a1aa5a998c0e 100644
> --- a/net/vmw_vsock/vmci_transport_notify.h
> +++ b/net/vmw_vsock/vmci_transport_notify.h
> @@ -11,7 +11,6 @@
>  #include <linux/types.h>
>  #include <linux/vmw_vmci_defs.h>
>  #include <linux/vmw_vmci_api.h>
> -#include <linux/vm_sockets.h>
>=20
>  #include "vmci_transport.h"
>=20
> --
> 2.21.0

Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
