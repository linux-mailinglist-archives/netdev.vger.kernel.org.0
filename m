Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4599E9DF7
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 15:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfJ3Oyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 10:54:43 -0400
Received: from mail-eopbgr760055.outbound.protection.outlook.com ([40.107.76.55]:48486
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726175AbfJ3Oyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 10:54:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGPokvSd96DMAexYD3wxlVoWLvAW7ERiMMZg5K6cSekrJgufpE7ntr8a61y7waZFLcnMA9jKHqd1hPSYnTknyLtd37l9IEaj5BmKIFuyszNZe5dwNc7/ZtgpN2bT8cN8AU1sNh1uEI9AX6d2y68yQXZjqv589omRELjIDq4pBF8QsbERhP3LDN9qIRSx+F6hn4SHfn24y0X6+URwGuwzl7kgUkL1mtDUIFhsQmLHuYMed+75RsLwXPfOCGm3IbU0oPq53UwUDknbm+EqqwhH2IHVcW473C3QUoIPWNBgKycAqyHPdClj/y2iqTOlKIy3rHjBn6FC0OfMZ/pGuwb29A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAqlBtN/qU0EZXP+jlLoD2515vwCPlWQiESnGyOhwEk=;
 b=EL5JpqKr9d2WiQXgby5fFWHyqWuv811Pdnc1v7jLEHoA1va91skffjZPXiEt+NiI4VLN70acbuax5HK2cZXZ2DryB9pV9B88DPSnBS6MUeoH0cJT37+wcHEfKFdqlotmFp654X4t/FQaBGoq0Qw9X+GRWMuyNV69l42jpYYtaNRnOVhjHnUkitPuqNOdzJIEaY6i/H6c6VtZ6TrB2YOcvkH+So/KcRWdjV+mq1HNd5HR65o5Juuznz1yacIwEMsMrHmnNDqwLpJ17oul1b9vc/exa926OJ8Pwpas2bFLG60yZAsaYmML7KqVCM9DV74Mu8sr6NrFsbOOWqWzc6Sa4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAqlBtN/qU0EZXP+jlLoD2515vwCPlWQiESnGyOhwEk=;
 b=MXJRQNJCIOW9Bl663JTJCHH5ccTRODHSXGy857XSkDtxq6AmPGmHasZ03L5K2m17f6a94AXiCFtdTJPrKuiF6u2mZbSsmq2VkgwN7z5DFmyMVvTUJeDcrd7L22NPvy74KUAy715SQ8Bu6R9GnnVPfbDdiZBzYnesWDCsTuTHmGM=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB3280.namprd05.prod.outlook.com (10.173.230.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.13; Wed, 30 Oct 2019 14:54:39 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209%7]) with mapi id 15.20.2408.018; Wed, 30 Oct 2019
 14:54:32 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     'Stefano Garzarella' <sgarzare@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
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
        <virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH net-next 01/14] vsock/vmci: remove unused
 VSOCK_DEFAULT_CONNECT_TIMEOUT
Thread-Topic: [PATCH net-next 01/14] vsock/vmci: remove unused
 VSOCK_DEFAULT_CONNECT_TIMEOUT
Thread-Index: AQHViYgiNQokIjXofEOPdPrYOG75LqdzT/5w
Date:   Wed, 30 Oct 2019 14:54:32 +0000
Message-ID: <MWHPR05MB3376646861BD8B349E0AE0A1DA600@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-2-sgarzare@redhat.com>
In-Reply-To: <20191023095554.11340-2-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [146.247.47.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbbc004e-4d26-414a-9cb7-08d75d491308
x-ms-traffictypediagnostic: MWHPR05MB3280:
x-microsoft-antispam-prvs: <MWHPR05MB328021636C030A6AB018898BDA600@MWHPR05MB3280.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:454;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(39860400002)(346002)(396003)(199004)(189003)(6506007)(446003)(99286004)(6116002)(486006)(476003)(11346002)(7696005)(86362001)(76176011)(102836004)(3846002)(186003)(26005)(53546011)(14454004)(71190400001)(52536014)(66556008)(7736002)(54906003)(66476007)(66946007)(66446008)(256004)(76116006)(478600001)(305945005)(110136005)(33656002)(64756008)(71200400001)(316002)(8936002)(8676002)(5660300002)(66066001)(81166006)(81156014)(7416002)(55016002)(6246003)(74316002)(4326008)(2501003)(229853002)(9686003)(6436002)(2906002)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3280;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dLIzFzpsUNvApefrv5VHItWiu9cJKwMLrH36LPP1DBSrxeLsg0JmVRvFf/c/v2LVZFniQwg5x4yNDwVe1KgrI+IrgNB7tb/c87UHyImK0NN0/+0vINhtIFWVmTstzXZUDo54ODSWnpgrB4zxLmalHlEhh3tnmywdOGu3E6FJV8a12rQnP3HrkpNNe7X89tNXW79dC5hsjqgeKQkcjprhU74yOqoZ5Um28XvZ0pKk6jkfkhPC9OLrQ0adxc2ChnUIb4eHJnjmLtyC0l9m8VX105NCpWjYVe9UUuhpvHkys7B0xtlExOzPMwcZC0D3qhjmiL+J2YfTs1qvzMc7w3GTak0x/4MUhDLI8KfpOYGC7kzJlS515xXGqEQlDa8H0MNow6bmRJYRlw1ohAXOi/k8D7flbGpr/eCDWx13ISTahsGwipWMVoipOTSFvCk5+n8l
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbbc004e-4d26-414a-9cb7-08d75d491308
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 14:54:32.8862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JDZsaIW7MhXQjsEPh3actB2OKayjpC3IJbU+jJW6BljY6aPDL7mt0VjG17HqKpIOex3zvLRJVGTQJ50OUMmoMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3280
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> Sent: Wednesday, October 23, 2019 11:56 AM
> Subject: [PATCH net-next 01/14] vsock/vmci: remove unused
> VSOCK_DEFAULT_CONNECT_TIMEOUT
>=20
> The VSOCK_DEFAULT_CONNECT_TIMEOUT definition was introduced with
> commit d021c344051af ("VSOCK: Introduce VM Sockets"), but it is never use=
d
> in the net/vmw_vsock/vmci_transport.c.
>=20
> VSOCK_DEFAULT_CONNECT_TIMEOUT is used and defined in
> net/vmw_vsock/af_vsock.c
>=20
> Cc: Jorgen Hansen <jhansen@vmware.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/vmci_transport.c | 5 -----
>  1 file changed, 5 deletions(-)
>=20
> diff --git a/net/vmw_vsock/vmci_transport.c
> b/net/vmw_vsock/vmci_transport.c index 8c9c4ed90fa7..f8e3131ac480
> 100644
> --- a/net/vmw_vsock/vmci_transport.c
> +++ b/net/vmw_vsock/vmci_transport.c
> @@ -78,11 +78,6 @@ static int PROTOCOL_OVERRIDE =3D -1;
>  #define VMCI_TRANSPORT_DEFAULT_QP_SIZE       262144
>  #define VMCI_TRANSPORT_DEFAULT_QP_SIZE_MAX   262144
>=20
> -/* The default peer timeout indicates how long we will wait for a peer
> response
> - * to a control message.
> - */
> -#define VSOCK_DEFAULT_CONNECT_TIMEOUT (2 * HZ)
> -
>  /* Helper function to convert from a VMCI error code to a VSock error co=
de.
> */
>=20
>  static s32 vmci_transport_error_to_vsock_error(s32 vmci_error)
> --
> 2.21.0

Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
