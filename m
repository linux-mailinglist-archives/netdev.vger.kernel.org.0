Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0116E9E39
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfJ3PBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:01:43 -0400
Received: from mail-eopbgr820085.outbound.protection.outlook.com ([40.107.82.85]:49520
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726554AbfJ3PBm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 11:01:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fE0PSbk55wvf4vWXjF4k0O7tUYSlWKTPMgRUt7VyXkhZIE/LbE9ri+wwweWbohLbuZWx+/up00brLUZQZJDinPREfTtX/aj0juse8cu1qHT/a5bPrdxNut892W2fBQm/M5eToO2rn8aRsT2Kby+12yZbR3Hwn0eHVyOQr9b+yYsX96KTbuw90WfIzFiKMpOeC26XFd4T8KjXlIP0aN98/z3Tcb+u2b3LeCOF6uB0Mhi19WIouHKqjgmPPnnCQvsDG8K4HavUbtf1x41+J9q+kOD1LKRaCsE0JK4Nu50wj4vBrAA5oFJ9Oe/IMX8Bk3igX34cStRUvcQSlJdkkzpSMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TR1n0eyok09KYq4v7J8+0LUCaFEo+foVc2EVXUhe0z0=;
 b=h/u5w1ht793oIUtVAVr3FYV+5vtIRZd8+zoO9W9Hot/hSf0dZ824FuEY/DbwT1qivKtf8XFHKtyyYEIkhgYL/TLfz88SPqB+WWjqhWIYZXej+/HBOufool84Oi9tMw5w+l7fZboroEB7To8pWYrwNAhEhD60O58aEzJb2/+GR+2Ue7dz781DlUdtpRNB9uGUsAGdPBkW1oZbV5t1lRE8oCEngQUhsJgaMHuegYMP8IPKDJ6FwcTW5LNRishsOtb82ihG65uA4j8aty36THznYWBEkz0F/CciiiJpSD6wFsIH0t1uOUmhpXHS8PajbofZnJyR1E+KHs7f/yZyTS1/vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TR1n0eyok09KYq4v7J8+0LUCaFEo+foVc2EVXUhe0z0=;
 b=b3+FpbIsE6hue/XfvQhxjXV0nqJA4KuwmuMghVG469Sw2kIXVY5VvvW93jjGG+a1Nu3h1xIwIT9wcSCHX0/z7L9yhgjsRaDLdzhOOenYb+6Qk4peknGz2+p9EDtFvmyOsuhgEei+22ePPDBUc3jKIgtUtCpPudHZ4VXdQFs6srM=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB3390.namprd05.prod.outlook.com (10.174.175.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.15; Wed, 30 Oct 2019 15:01:39 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209%7]) with mapi id 15.20.2408.018; Wed, 30 Oct 2019
 15:01:39 +0000
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
Subject: RE: [PATCH net-next 06/14] vsock: add 'struct vsock_sock *' param to
 vsock_core_get_transport()
Thread-Topic: [PATCH net-next 06/14] vsock: add 'struct vsock_sock *' param to
 vsock_core_get_transport()
Thread-Index: AQHViYhVbfxCaQWpnUKTckVdAjR646dzUpNw
Date:   Wed, 30 Oct 2019 15:01:39 +0000
Message-ID: <MWHPR05MB3376B7BEE1400BDEFCC64EDDDA600@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-7-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-7-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [146.247.47.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a98c5fa0-be00-478b-582e-08d75d4a1114
x-ms-traffictypediagnostic: MWHPR05MB3390:
x-microsoft-antispam-prvs: <MWHPR05MB339032923155C92008BDC43BDA600@MWHPR05MB3390.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(199004)(189003)(81156014)(33656002)(52536014)(55016002)(54906003)(4326008)(81166006)(2906002)(316002)(86362001)(25786009)(8676002)(478600001)(7416002)(256004)(14444005)(6436002)(14454004)(66066001)(8936002)(99286004)(9686003)(6116002)(71190400001)(64756008)(6246003)(102836004)(66476007)(66946007)(76116006)(6916009)(229853002)(53546011)(71200400001)(66446008)(74316002)(486006)(7696005)(6506007)(186003)(11346002)(476003)(446003)(26005)(7736002)(305945005)(3846002)(76176011)(5660300002)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3390;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZW6FeDcBb3TC6Hi6WRg5hDeHgBHt2YNiwSDp4pzVkKE3c0wstX8V1KzG/G30l/Mil/qOfeFQUtIF7YozjWzGUj3p/jokn5xDfi0qVPhMSEmbjMB74bN2aK/6mB1ZuOnLusBDHwq3Mrp+8tzuiiVTAmKbZOKo+0NBKQl9TOMtfwNWlmFA3P249bX3OV76c+0T3HbsqT/+UdpqGOkIfHxSJDr918tJxzCSbpgMeqCXCERKl/gFcTd5eWHpWgqDInCQCxkVD7E/faIP5ySKwv6VUD28v6rH4TxOhWqgAemx9VJqBcQrY6WKy1RfBu/mMNwN59GNMb6JISx+uv7+g5hJQNt2t+zwH09ARdhZDUF92IXqGp3EOt2UN0Qq3zTorLHZ6rIfoLPjOHexSrSBIhefx2QEoJx2l5Q/lIrwM2KmThxe42vIsEYSB9kYKk7ENsZq
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a98c5fa0-be00-478b-582e-08d75d4a1114
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 15:01:39.0624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: By7qsopOQnj1xtPWfgAYuCw73oiGOmpvWgk58axhPybcgH6fQEGoMYQR1sYDal5aS4OUQuX/tPrjNxO/3CuczA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3390
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> Sent: Wednesday, October 23, 2019 11:56 AM
> Subject: [PATCH net-next 06/14] vsock: add 'struct vsock_sock *' param to
> vsock_core_get_transport()
>=20
> Since now the 'struct vsock_sock' object contains a pointer to the transp=
ort,
> this patch adds a parameter to the
> vsock_core_get_transport() to return the right transport assigned to the
> socket.
>=20
> This patch modifies also the virtio_transport_get_ops(), that uses the
> vsock_core_get_transport(), adding the 'struct vsock_sock *' parameter.
>=20
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> RFC -> v1:
> - Removed comment about protecting transport_single (Stefan)
> ---
>  include/net/af_vsock.h                  | 2 +-
>  net/vmw_vsock/af_vsock.c                | 7 ++-----
>  net/vmw_vsock/virtio_transport_common.c | 9 +++++----
>  3 files changed, 8 insertions(+), 10 deletions(-)
>=20
> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h index
> a5e1e134261d..2ca67d048de4 100644
> --- a/include/net/af_vsock.h
> +++ b/include/net/af_vsock.h
> @@ -166,7 +166,7 @@ static inline int vsock_core_init(const struct
> vsock_transport *t)  void vsock_core_exit(void);
>=20
>  /* The transport may downcast this to access transport-specific function=
s */
> -const struct vsock_transport *vsock_core_get_transport(void);
> +const struct vsock_transport *vsock_core_get_transport(struct
> +vsock_sock *vsk);
>=20
>  /**** UTILS ****/
>=20
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c index
> c3a14f853eb0..eaea159006c8 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -2001,12 +2001,9 @@ void vsock_core_exit(void)  }
> EXPORT_SYMBOL_GPL(vsock_core_exit);
>=20
> -const struct vsock_transport *vsock_core_get_transport(void)
> +const struct vsock_transport *vsock_core_get_transport(struct
> +vsock_sock *vsk)
>  {
> -	/* vsock_register_mutex not taken since only the transport uses this
> -	 * function and only while registered.
> -	 */
> -	return transport_single;
> +	return vsk->transport;
>  }
>  EXPORT_SYMBOL_GPL(vsock_core_get_transport);
>=20
> diff --git a/net/vmw_vsock/virtio_transport_common.c
> b/net/vmw_vsock/virtio_transport_common.c
> index 9763394f7a61..37a1c7e7c7fe 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -29,9 +29,10 @@
>  /* Threshold for detecting small packets to copy */  #define
> GOOD_COPY_LEN  128
>=20
> -static const struct virtio_transport *virtio_transport_get_ops(void)
> +static const struct virtio_transport *
> +virtio_transport_get_ops(struct vsock_sock *vsk)
>  {
> -	const struct vsock_transport *t =3D vsock_core_get_transport();
> +	const struct vsock_transport *t =3D vsock_core_get_transport(vsk);
>=20
>  	return container_of(t, struct virtio_transport, transport);  } @@ -
> 168,7 +169,7 @@ static int virtio_transport_send_pkt_info(struct vsock_so=
ck
> *vsk,
>  	struct virtio_vsock_pkt *pkt;
>  	u32 pkt_len =3D info->pkt_len;
>=20
> -	src_cid =3D virtio_transport_get_ops()->transport.get_local_cid();
> +	src_cid =3D virtio_transport_get_ops(vsk)->transport.get_local_cid();
>  	src_port =3D vsk->local_addr.svm_port;
>  	if (!info->remote_cid) {
>  		dst_cid	=3D vsk->remote_addr.svm_cid;
> @@ -201,7 +202,7 @@ static int virtio_transport_send_pkt_info(struct
> vsock_sock *vsk,
>=20
>  	virtio_transport_inc_tx_pkt(vvs, pkt);
>=20
> -	return virtio_transport_get_ops()->send_pkt(pkt);
> +	return virtio_transport_get_ops(vsk)->send_pkt(pkt);
>  }
>=20
>  static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
> --
> 2.21.0

Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
