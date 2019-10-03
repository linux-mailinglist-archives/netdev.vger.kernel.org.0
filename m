Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F764CAFDA
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 22:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388053AbfJCURS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 16:17:18 -0400
Received: from mail-eopbgr1320128.outbound.protection.outlook.com ([40.107.132.128]:6116
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725957AbfJCURR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 16:17:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0B6B+fR5JqHTlbrPiQlSXpD8T/P2uABg157YEcVPbQcbwFHh9zvo4uxzQdDgXqgSf7FJ/msz+88U4hs2dqH4ZTqJKGDx5u548KKgHtCuWuczjCwHyYznxQqcalTHsrbLVANLb+nUgunB1BYP2mtJ+Jn6HnfFZF3MzIry89AQE6OCysqj/91YONF+992q7WhyPTKNkj917EQ48yCjldJ+gY5rKuYADp9U8RxM0PJvKkwFKamLE+QRA0lDkw6+HaNeJg+2C4T8CGjg6l/Erk7BYAAA/BJFVpZuvunXsNEEVRUN91ev0tdgbKNGE/Sqzi9stqUdVkyKnLDtYFpqq7Kkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91GpBJ2TmaRHSqR6iDo3i3JkyEp7T3maUXSRcjLWjq0=;
 b=D/4hhY21sn7sSlhNiejC2z1K2L1rwdtmR9OAU7tGCgH3cFV7KkFwPEh8udQFCdCeLyMlQ8A6qPij45lIu+W3OO3OfPKNaOb0I8BwY5knfdGGEu8s9ZWJjE+LjwN1Qet1IzruBhmmOsCe3iCmW2KHpI8UsHZyfMtHA8y9DAqOPVDzBuk8mfOWfRRC55jVPPWVwL23IehBJws/9ruRNwBJ9Aq4qbnHVwz/Mn1HqOUDYVuufC6FBMvGzNgq3y29PsaUTgP1x6XJfxz80Y7G+4YTmLnP1mt857QKsNH3AS3aqregUfZto3aFmPE8DTVMkWFOnq8PqAH1j1EKCfXfpfBybw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91GpBJ2TmaRHSqR6iDo3i3JkyEp7T3maUXSRcjLWjq0=;
 b=eD67drbqWTVAQKHP26IgZJcW43XCefAa8JC0acJrUiD7h/Ge2D1hbaI/a8PkalENY4Jsokak3sgW20EHQZH+yml4EyYbcTfvqg19ylE7VJ4MYCqDY+OxL2RV8ZP+ZSVcYOfxkAAMioR3I4XPt26eO5eavuWVgnkdRLqNSh5Eb8c=
Received: from KU1P153MB0166.APCP153.PROD.OUTLOOK.COM (10.170.173.13) by
 KU1P153MB0167.APCP153.PROD.OUTLOOK.COM (10.170.173.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.6; Thu, 3 Oct 2019 20:17:07 +0000
Received: from KU1P153MB0166.APCP153.PROD.OUTLOOK.COM
 ([fe80::ccb6:acbd:7d4c:7f7c]) by KU1P153MB0166.APCP153.PROD.OUTLOOK.COM
 ([fe80::ccb6:acbd:7d4c:7f7c%6]) with mapi id 15.20.2347.011; Thu, 3 Oct 2019
 20:17:07 +0000
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
Subject: RE: [RFC PATCH 08/13] vsock: move vsock_insert_unbound() in the
 vsock_create()
Thread-Topic: [RFC PATCH 08/13] vsock: move vsock_insert_unbound() in the
 vsock_create()
Thread-Index: AQHVdSatVEha0YvJokiAPbW0TOdB9adJZJkg
Date:   Thu, 3 Oct 2019 20:17:07 +0000
Message-ID: <KU1P153MB01663CA0F105C416555A06FFBF9F0@KU1P153MB0166.APCP153.PROD.OUTLOOK.COM>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-9-sgarzare@redhat.com>
In-Reply-To: <20190927112703.17745-9-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-03T20:17:05.5588798Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ccffdd80-9d38-4480-b37d-9cdc3b475856;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:9:4930:a527:7f59:8664]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53055dd8-d731-496c-2277-08d7483eaa1a
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: KU1P153MB0167:|KU1P153MB0167:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <KU1P153MB0167812C5F15F8A01E503C4BBF9F0@KU1P153MB0167.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(189003)(199004)(54906003)(66446008)(110136005)(66946007)(66476007)(25786009)(316002)(66556008)(64756008)(8990500004)(52536014)(6116002)(22452003)(7696005)(99286004)(2906002)(86362001)(6246003)(76116006)(4326008)(478600001)(5660300002)(10090500001)(4744005)(14454004)(10290500003)(33656002)(81156014)(2501003)(55016002)(8676002)(81166006)(9686003)(486006)(256004)(14444005)(229853002)(6436002)(8936002)(446003)(11346002)(6506007)(76176011)(476003)(46003)(7416002)(305945005)(186003)(102836004)(7736002)(71200400001)(74316002)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:KU1P153MB0167;H:KU1P153MB0166.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sdIqOYISXf6AYfcGDo90igjX+FEW55gEwKhbX54BHsNkOZquki0wAgqabXPRyjCKpJ3PMNRLU0JH1GBv65VSxbGrPM1Ip8WkaIlKGYlZ+cOPAmchoTyJHjjPglvbfhrv2YrJVLbWh7p3hu88Qw3d6cm3LkEsVb2JsqL6KcJxij95l5BZXD6w2tyfJOAC/PABX9uOwzLhqpTPlfaF22uR1qc8pzZzJTDNmdW5p3Jf66cmb/OIMusLJ6aR7PYA9B3saZ2LuNZA/LChBmyMvAxHIw/dru9W/dFMwPzISEFzNJMMBPAkSkWcRQg1G9JRvaDZiRVsd5GDnZyI6uh0pvMaRBLJ0Pnbfch2LrkVMivIt5Uch5qt7HjWBM5muIxxMdkKmEGbP5JEStOlEdjAKhykPIo7hr/l/dcCAbXbci991H0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53055dd8-d731-496c-2277-08d7483eaa1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 20:17:07.0329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wQGlk8XzZJhaxrpkVFGfShpL9gH5q+Y+fylgrFulSPSMcaxA+rMkGVRgOCJbWLc2zfPu/fHjpdMzxeMG6go5OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU1P153MB0167
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Friday, September 27, 2019 4:27 AM
>=20
> vsock_insert_unbound() was called only when 'sock' parameter of
> __vsock_create() was not null. This only happened when
> __vsock_create() was called by vsock_create().
>=20
> In order to simplify the multi-transports support, this patch
> moves vsock_insert_unbound() at the end of vsock_create().
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/af_vsock.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>=20

Reviewed-by: Dexuan Cui <decui@microsoft.com>
