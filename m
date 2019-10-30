Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEE1CE9E03
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfJ3Ozz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:55:55 -0400
Received: from mail-eopbgr760044.outbound.protection.outlook.com ([40.107.76.44]:48419
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726314AbfJ3Ozz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 10:55:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H46Y+1TryWmbMXwWBvZMfixwVrqzDBv2Ydo2dbOZE9zmMQXaF5vwYa4H2dM5ZacZp7/xxylCAOsW28/YMZdSx9RQPywF/PGe9K18CTdB7Wq0SIiY8N6aeuSc9Q71U5dvOKMQ9mZIk59zHauYgALdB16y8SCYf6BbQFy5lAF5SAFsYz3mFwd2CUaDu3ElPTr9rDAj/X6MWarp4CBAnx5DoZnF9egtsJ8pa3iLG1PSfUfiCoFwLhYruNHImRB0YAXUKhBhCAIKmXkyLizpl8jtyjGRsij3d9z5TmUnF9Grs3p1M4M5EcdD6Va3ytAbY25BmtB4htsAfMA442qEgR8AMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXcHSO4QW2m/dUJD/gqWhfxEnj8hitJisMLsiuVmHsg=;
 b=cnh0UjO0InQLMmUxNHdaDhQ5zAM1qmAv77eFRASLKyRiZVpUsVb1WsMxt/OMwzkjlNUn2dBVcoABlMEsjT71eOxUPpcBVLJBKcnIxnuawKXa7qghm7G8lM1YTaW2FHuvuFOKcosdNDD/aKhS7gPogMkDTJ+C+kP7gEzrPyJgttgIndB5ayrT44cMmxFxkup8oQJv1Z70sSaabSlglxT6zJcXeEa03HgNcG8q/kgx64ZUYwj1cqIH/VzhPJY2D2zil6vV5G48JNzN2rCkyft5VaaiQzwDyky3LPxKxyAbolK43LT5BN8rA0kM/DT2CsNLAlsZwBkKO0FjWa6EdtZLgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXcHSO4QW2m/dUJD/gqWhfxEnj8hitJisMLsiuVmHsg=;
 b=iINogs0lCnPCERMTb039ITQk1dTE91q5q2UmVRsJwkHMMwVGdxs6/jeKZLnnGdvYUzEfDVQncxPZzTwEHiuJwif+wCVg4vQDoh2ATVNQZvNtLgd3l0Im9R6hGmae8rSYoAX4ESgMRts9kJ7oXIFXoRoUcZZh7Ko9sYKhnUB1/lI=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB3280.namprd05.prod.outlook.com (10.173.230.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.13; Wed, 30 Oct 2019 14:55:50 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209%7]) with mapi id 15.20.2408.018; Wed, 30 Oct 2019
 14:55:50 +0000
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
Subject: RE: [PATCH net-next 02/14] vsock: remove vm_sockets_get_local_cid()
Thread-Topic: [PATCH net-next 02/14] vsock: remove vm_sockets_get_local_cid()
Thread-Index: AQHViYgljrD1JrSTekiUF7XD5Aj5gKdzUOnQ
Date:   Wed, 30 Oct 2019 14:55:49 +0000
Message-ID: <MWHPR05MB3376D6FBAC3940FE757CE578DA600@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-3-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-3-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [146.247.47.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e665699-1223-4b50-745f-08d75d494100
x-ms-traffictypediagnostic: MWHPR05MB3280:
x-microsoft-antispam-prvs: <MWHPR05MB32807C237A6DFA77C91AE125DA600@MWHPR05MB3280.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:499;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(39860400002)(346002)(396003)(13464003)(199004)(189003)(6506007)(446003)(6916009)(99286004)(6116002)(486006)(476003)(11346002)(7696005)(86362001)(76176011)(102836004)(3846002)(186003)(26005)(53546011)(14454004)(71190400001)(52536014)(66556008)(7736002)(54906003)(66476007)(66946007)(66446008)(256004)(76116006)(478600001)(305945005)(33656002)(64756008)(71200400001)(316002)(8936002)(8676002)(5660300002)(66066001)(81166006)(81156014)(7416002)(55016002)(6246003)(74316002)(4326008)(229853002)(9686003)(6436002)(2906002)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3280;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fgB/r5s/dN6kAiWt2H0sJICVwCkzdEKp3HG9+3zUjbOQinozcaMVuJggmUJ49TlPbayg2iY7temO5i6sNuXNYGhEYRr32FvbhRneIQ+M7N7vAQ5ToMTa1ZTokm2dFEHZUqW+yCjVRyRlZst2E5z2cXc3Aqz7rM+XiyuuVunTSEWi6pKtg4JLpFFfPs/AtVGDgKoIFKhuzvxCTP8V7H5GuXQqqxzHkx/s+23VzpcmJlgN/VdsVfsM9fLVYHEXXAU7/77n38nycE1fxAhDxv7ZXvhS+heFCdW2vBgCiWJituKTyPbl7Yf0RnhYVEPNPqTf911JYqsjYTGpRd0VXh7nldPqF/NyYMh/wQF5Ln4tGR2TTGFKyzpEVFO5RFhG+7JUgEntSe28eY4GjyPp+NuSZuzW/Mh2EY4Mmn17Nt1DD8WQCY+2u990YYyvlwiyGpm6
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e665699-1223-4b50-745f-08d75d494100
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 14:55:49.9679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VGb4TOLQhMn28PN2CXF9ISfdxIjmYY2W9CP3Zu+DXjC2f3L+GDYloiYZdkPr3KHaWOqpIzyHBnmGPXA/X3+eGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3280
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> Sent: Wednesday, October 23, 2019 11:56 AM
> To: netdev@vger.kernel.org
> Subject: [PATCH net-next 02/14] vsock: remove vm_sockets_get_local_cid()
>=20
> vm_sockets_get_local_cid() is only used in virtio_transport_common.c.
> We can replace it calling the virtio_transport_get_ops() and using the
> get_local_cid() callback registered by the transport.
>=20
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/linux/vm_sockets.h              |  2 --
>  net/vmw_vsock/af_vsock.c                | 10 ----------
>  net/vmw_vsock/virtio_transport_common.c |  2 +-
>  3 files changed, 1 insertion(+), 13 deletions(-)
>=20
> diff --git a/include/linux/vm_sockets.h b/include/linux/vm_sockets.h inde=
x
> 33f1a2ecd905..7dd899ccb920 100644
> --- a/include/linux/vm_sockets.h
> +++ b/include/linux/vm_sockets.h
> @@ -10,6 +10,4 @@
>=20
>  #include <uapi/linux/vm_sockets.h>
>=20
> -int vm_sockets_get_local_cid(void);
> -
>  #endif /* _VM_SOCKETS_H */
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c index
> 2ab43b2bba31..2f2582fb7fdd 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -129,16 +129,6 @@ static struct proto vsock_proto =3D {  static const =
struct
> vsock_transport *transport;  static DEFINE_MUTEX(vsock_register_mutex);
>=20
> -/**** EXPORTS ****/
> -
> -/* Get the ID of the local context.  This is transport dependent. */
> -
> -int vm_sockets_get_local_cid(void)
> -{
> -	return transport->get_local_cid();
> -}
> -EXPORT_SYMBOL_GPL(vm_sockets_get_local_cid);
> -
>  /**** UTILS ****/
>=20
>  /* Each bound VSocket is stored in the bind hash table and each connecte=
d
> diff --git a/net/vmw_vsock/virtio_transport_common.c
> b/net/vmw_vsock/virtio_transport_common.c
> index d02c9b41a768..b1cd16ed66ea 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -168,7 +168,7 @@ static int virtio_transport_send_pkt_info(struct
> vsock_sock *vsk,
>  	struct virtio_vsock_pkt *pkt;
>  	u32 pkt_len =3D info->pkt_len;
>=20
> -	src_cid =3D vm_sockets_get_local_cid();
> +	src_cid =3D virtio_transport_get_ops()->transport.get_local_cid();
>  	src_port =3D vsk->local_addr.svm_port;
>  	if (!info->remote_cid) {
>  		dst_cid	=3D vsk->remote_addr.svm_cid;
> --
> 2.21.0

Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
