Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D92CAF54
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732438AbfJCThI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:37:08 -0400
Received: from mail-eopbgr1320129.outbound.protection.outlook.com ([40.107.132.129]:31940
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728812AbfJCThI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 15:37:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FK4BRdWeXwCJVF59vDLq4L+yBSsQ02FZltIBBMw5wCDRerXUJ0jWVQKj7QVcQKeAJaYH4agoFZ8OTrKWs4s+KDF2Twz9/BBj7+B8oATp2xkDKm88XQzQYkG7Uug8bmUaAFc+u12sdT8ccu81HqytOJUl/kfQThAFS7q71c4OAyp3B7NTqe+cLMpPZUDjY++afRSwRJ46DtkEAlDeQY3YEDEmgDp4IzkxgcfMR26IDif3yYMg/+wjJtZKxwnl+2ZrjYey3KOOP5yOPQ6EVViJ7MssZvc0oJv5banTzsN/vMS9Wtricgey6BqYaEDpuquNz1ryNcbslVB0J1YOgfFAWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOznQ6K8BDawJi6inDLukyC71uBlyb8CD1TXI0C3SoQ=;
 b=l31JrRb6ep10lJUeRTeySaN+9ZWwbTCTluqx+38oWbIZknlwBUl1JGOov3T6mPxPGjc5X2+PAMg7LVGM2j6fm946AvFskTrgItKXgOweLzF+4v9hsjQfJpoMtcq0Xt5G6gpsTrtHl3/o4vnWzGl8eFpXQeH2o2qOh5/vbBggPnnBRAlX1rF3Kjaqb4r8sK1F1oyYgwUKG4zrusYGrZrMJLaEfmadm6rybBXc6NGN/PGzPS1iOfiReX1YW93JlwHp39VjgkMNG/SFqaxNLQaq9Tx9ojVwmXo06IgE9UPW9LZUYfEaVmBJTnjDUYJD015T+tVJC4eSPrQOgXft4wDftQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOznQ6K8BDawJi6inDLukyC71uBlyb8CD1TXI0C3SoQ=;
 b=bEB47uycE/H+72u5C8oJrh+O610GuU9v5qzthP7N3aK9mcw+yK17hIzpFAlRjnlX/wFc0szrLHDyfbS/ZU77WAycjnJg0I8yaVQBO8G8rdxk/Gfno7nQLFqZq+Bqj2RTEjqg5GVr73MzY/K+1TGpfQoWTe+PVGnIR9QZ5y1UJ64=
Received: from KU1P153MB0166.APCP153.PROD.OUTLOOK.COM (10.170.173.13) by
 KU1P153MB0182.APCP153.PROD.OUTLOOK.COM (10.170.175.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.6; Thu, 3 Oct 2019 19:36:17 +0000
Received: from KU1P153MB0166.APCP153.PROD.OUTLOOK.COM
 ([fe80::ccb6:acbd:7d4c:7f7c]) by KU1P153MB0166.APCP153.PROD.OUTLOOK.COM
 ([fe80::ccb6:acbd:7d4c:7f7c%6]) with mapi id 15.20.2347.011; Thu, 3 Oct 2019
 19:36:17 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: RE: [RFC PATCH 09/13] hv_sock: set VMADDR_CID_HOST in the
 hvs_remote_addr_init()
Thread-Topic: [RFC PATCH 09/13] hv_sock: set VMADDR_CID_HOST in the
 hvs_remote_addr_init()
Thread-Index: AQHVdSavCYSzGTajGEWMNaF3wKj8aadJVK/g
Date:   Thu, 3 Oct 2019 19:36:17 +0000
Message-ID: <KU1P153MB016631EC4AEA02A8AB8822F2BF9F0@KU1P153MB0166.APCP153.PROD.OUTLOOK.COM>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-10-sgarzare@redhat.com>
In-Reply-To: <20190927112703.17745-10-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-03T19:36:15.4668775Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=fd5fb71f-ff1a-4357-b430-a1e5f8fd6b4d;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:9:4930:a527:7f59:8664]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e7ec216-d22a-49a5-9fe4-08d74838f5f7
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: KU1P153MB0182:|KU1P153MB0182:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <KU1P153MB0182E10CC051BBC488649D9ABF9F0@KU1P153MB0182.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(199004)(189003)(14454004)(2906002)(446003)(11346002)(8936002)(186003)(256004)(478600001)(7416002)(10290500003)(74316002)(86362001)(81166006)(476003)(81156014)(52536014)(5660300002)(6436002)(14444005)(71200400001)(71190400001)(46003)(229853002)(8676002)(2501003)(102836004)(66946007)(64756008)(33656002)(66476007)(25786009)(66556008)(9686003)(305945005)(6246003)(66446008)(4326008)(486006)(6506007)(76176011)(7696005)(7736002)(53546011)(6116002)(316002)(22452003)(110136005)(76116006)(10090500001)(54906003)(8990500004)(99286004)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:KU1P153MB0182;H:KU1P153MB0166.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PUqo+BAl5swCmZCNUwDr6ptDu8ohnXDgoF2lQ8dhTt/AnlF3NuW50ZtyMOseBNU5bZV4Qu2B6zI14PuWOhnx6klNR2e0vB/mpDYodeIhNsl27fCozJT3FKNf03pdh1f2dxy7hvH1ZMrNMwiHsNzgHzZuGAwafFHUYwhlbGkRKXoPcUwoGjDqVR2NhRfIBde8pUsaiTVXY9arOoJE4QmGEXcS8umSLY8BdAGSIGR3fD939xmfE3HChHm+BgGbImO/7r+8ck6hMuLvcqB39/oRi3GenDUy8POuUeSd5H0w99MzFYXz/j0fJ4tHZ00KHPkgFVIUj737NRO4ZmWEMvPlbzgbVxnV5JAS6lliEsDaDXecVWy8YYNDd3QvAtQZNTYduRyLm0R6YXf9yLjjRrAyJuO8r3RPX/G+hnm0RrRvfMA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e7ec216-d22a-49a5-9fe4-08d74838f5f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 19:36:17.3791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mi/C7177I32orbMkK79hf9ANs3UIxyLsFPj/rm5Q7AONE2E+4BE7j75wKHs1wGkkCMcPhFU+BGt37GAbVHD0tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU1P153MB0182
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Friday, September 27, 2019 4:27 AM
> To: netdev@vger.kernel.org
> Cc: linux-hyperv@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; Stef=
an
> Hajnoczi <stefanha@redhat.com>; Sasha Levin <sashal@kernel.org>;
> linux-kernel@vger.kernel.org; kvm@vger.kernel.org; David S. Miller
> <davem@davemloft.net>; virtualization@lists.linux-foundation.org; Stephen
> Hemminger <sthemmin@microsoft.com>; Jason Wang
> <jasowang@redhat.com>; Michael S. Tsirkin <mst@redhat.com>; Haiyang
> Zhang <haiyangz@microsoft.com>; Dexuan Cui <decui@microsoft.com>;
> Jorgen Hansen <jhansen@vmware.com>
> Subject: [RFC PATCH 09/13] hv_sock: set VMADDR_CID_HOST in the
> hvs_remote_addr_init()
>=20
> Remote peer is always the host, so we set VMADDR_CID_HOST as
> remote CID instead of VMADDR_CID_ANY.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/hyperv_transport.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/vmw_vsock/hyperv_transport.c
> b/net/vmw_vsock/hyperv_transport.c
> index 4f47af2054dd..306310794522 100644
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -186,7 +186,8 @@ static void hvs_remote_addr_init(struct sockaddr_vm
> *remote,
>  	static u32 host_ephemeral_port =3D MIN_HOST_EPHEMERAL_PORT;
>  	struct sock *sk;
>=20
> -	vsock_addr_init(remote, VMADDR_CID_ANY, VMADDR_PORT_ANY);
> +	/* Remote peer is always the host */
> +	vsock_addr_init(remote, VMADDR_CID_HOST, VMADDR_PORT_ANY);
>=20
>  	while (1) {
>  		/* Wrap around ? */
> --

Looks good to me, since hv_sock doesn't really use the CID in the=20
transport layer.

Reviewed-by: Dexuan Cui <decui@microsoft.com>
