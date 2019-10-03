Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED940CAFD1
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 22:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388387AbfJCUMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 16:12:15 -0400
Received: from mail-eopbgr1310107.outbound.protection.outlook.com ([40.107.131.107]:55712
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729586AbfJCUMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 16:12:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ibgZ68kD+Q81H79dqcASVr7OBwqC3znRL4jUKp+tWclKd8wopWjXNAMg5OpaGPTtuh0o4GyvDqEOEVks3PHk4f/h7i7dKN/0LMa7+0ioWqrVpkaY3VxlpxcCZbtl80PPlzj3SUiJUIJKdzp3qVpl++R78B/gRiAFvj4uia8O5XlJEZ9dKYMCE8aDOCeZqzKRtSumHXdz4/RWu2S2FTDM9+ros1u85elXEPXPTwWJYmWYdpnfjcPr9kMMe0NSJlxxdHIHSIfArhjR/h6nXgmaXlzeq7+pnL8uhaDnGWg8emohIDqGtdlmzMp9X+rSdmIybCsemQ10y6L3aPZq3X4Ibg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5Ytw80D6rZUAmyqDOfMkfNNZ3mQeAtpGil9FJRwxIQ=;
 b=WyfickxKYsJNLrXKqSWoOV/FHaZC0snNe9gFFFcYDv+f2NdnVc4XCe0a9VjZ64srNGcWNMu5RFoxG4QTz6YVfCJHZAHAz0Qn2J1LNPEgkHpPJq+s7IYQ+IYqJ8KB6W7LaUVs9p9yMP0DQlbQyGZvN6zX+/E9dmcg5rYdsWFO86RF8MeJLGdRX58NBv8QsXKTMSwuPn4gpl2jBxERcJMhQ2CIiP1UNIyHqjWgev1SiHE3LcKOeeYJuBk02u/rM5UxHDyaGOdppbHrTx0v4UhK5nDY+ki1JXDZmzEvLVSV4PnpT7wr55qUYSrK9E/jgD3zipOp7rKfBFYfk9eHcnE7RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5Ytw80D6rZUAmyqDOfMkfNNZ3mQeAtpGil9FJRwxIQ=;
 b=cmYDd/mD35Z8Pt6wKqEFalDC8m3jkyx0rbJTUECOV/XF7rhBDAyZdds0p3t1DJJKeDRwEYG10zsrfV1PXPpBaItcWL2ztAN0Ieg0IPvjWyoHtGGd0yS10MrXpYwXxNpJQJdydHWsaut47POphMpnocCbUsLQ52lhMp/zCNvYJvc=
Received: from KU1P153MB0166.APCP153.PROD.OUTLOOK.COM (10.170.173.13) by
 KU1P153MB0166.APCP153.PROD.OUTLOOK.COM (10.170.173.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.6; Thu, 3 Oct 2019 20:11:19 +0000
Received: from KU1P153MB0166.APCP153.PROD.OUTLOOK.COM
 ([fe80::ccb6:acbd:7d4c:7f7c]) by KU1P153MB0166.APCP153.PROD.OUTLOOK.COM
 ([fe80::ccb6:acbd:7d4c:7f7c%6]) with mapi id 15.20.2347.011; Thu, 3 Oct 2019
 20:11:19 +0000
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
Subject: RE: [RFC PATCH 07/13] vsock: handle buffer_size sockopts in the core
Thread-Topic: [RFC PATCH 07/13] vsock: handle buffer_size sockopts in the core
Thread-Index: AQHVdSassErYYYgXqES9Q6BNsB/gZ6dJYpqg
Date:   Thu, 3 Oct 2019 20:11:18 +0000
Message-ID: <KU1P153MB0166C0DEDAC1FAC009B0D257BF9F0@KU1P153MB0166.APCP153.PROD.OUTLOOK.COM>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-8-sgarzare@redhat.com>
In-Reply-To: <20190927112703.17745-8-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-03T20:11:16.7229005Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=dd135884-07be-4d20-80e3-90c49b8e3e74;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:9:4930:a527:7f59:8664]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5efeb2ca-4a39-433b-3052-08d7483dda9f
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: KU1P153MB0166:|KU1P153MB0166:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <KU1P153MB0166D696EF03F5C6CD65ABCDBF9F0@KU1P153MB0166.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(199004)(189003)(446003)(229853002)(33656002)(11346002)(52536014)(99286004)(476003)(54906003)(110136005)(4326008)(102836004)(2906002)(10290500003)(86362001)(6506007)(10090500001)(14454004)(53546011)(478600001)(8676002)(81166006)(81156014)(186003)(25786009)(8936002)(76176011)(66446008)(6246003)(66556008)(64756008)(22452003)(7696005)(8990500004)(7416002)(66946007)(74316002)(7736002)(305945005)(66476007)(2501003)(76116006)(55016002)(6116002)(5660300002)(46003)(71200400001)(316002)(486006)(6436002)(256004)(14444005)(9686003)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:KU1P153MB0166;H:KU1P153MB0166.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rMOHf10btEu4EgO/K6ZPxyZAXXQ0U8BnQJQPxTNGQ1U0VGezDFg736HibahG4MFwAtWx+0ClN6we579FXPy19SEY2Vqa1/SxQmS/sO2p94LR/z/kf5FujdvnSKkiMRvOXuZdNc6BPYz9zwbmGzms1WVJmUMg2FMdGmmwR1scvviEZFokk5RAMKEF+7VOm7wdLJIbXMuyPW5Y6jlP2XynyaqExv/L2gQR9I4/EjJZYIoVJgPX3/TtmvnSRe+AkbyNoyY72qkGKEIHTys2WWUnBtaBYzsh1lshw53zQFSKhqKjdH/LVAhxMbqdkAvx8Yw7kehPTCL3HduByAmaKr2pnlqcMmfnCZGC/YcsDPWhC0klMq00bE+IdWbHC+E5Ec8UrlFBptr8h1Nog89+Wa83LTSf+FrGvrX5uHcmcvstPpA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5efeb2ca-4a39-433b-3052-08d7483dda9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 20:11:19.0097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7yWk9auZt77FA8ZNRfuLwtx0+J2gTZhvbSBT1JKBPO4j52zIfDLHyqbw8t94Wsy4z7op6nJqrQsKYcxmo0qc+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU1P153MB0166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Friday, September 27, 2019 4:27 AM
> To: netdev@vger.kernel.org
>=20
> virtio_transport and vmci_transport handle the buffer_size
> sockopts in a very similar way.
>=20
> In order to support multiple transports, this patch moves this
> handling in the core to allow the user to change the options
> also if the socket is not yet assigned to any transport.
>=20
> This patch also adds the '.notify_buffer_size' callback in the
> 'struct virtio_transport' in order to inform the transport,
> when the buffer_size is changed by the user. It is also useful
> to limit the 'buffer_size' requested (e.g. virtio transports).
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  drivers/vhost/vsock.c                   |  7 +-
>  include/linux/virtio_vsock.h            | 15 +----
>  include/net/af_vsock.h                  | 14 ++--
>  net/vmw_vsock/af_vsock.c                | 43 ++++++++++---
>  net/vmw_vsock/hyperv_transport.c        | 36 -----------
>  net/vmw_vsock/virtio_transport.c        |  8 +--
>  net/vmw_vsock/virtio_transport_common.c | 78 ++++------------------
>  net/vmw_vsock/vmci_transport.c          | 86 +++----------------------
>  net/vmw_vsock/vmci_transport.h          |  3 -
>  9 files changed, 64 insertions(+), 226 deletions(-)
>=20

The hv_sock part (hyperv_transport.c) looks good to me.

Acked-by: Dexuan Cui <decui@microsoft.com>

