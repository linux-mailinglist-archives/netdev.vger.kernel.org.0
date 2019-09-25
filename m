Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13398BE83D
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 00:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbfIYWXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 18:23:32 -0400
Received: from mail-eopbgr700101.outbound.protection.outlook.com ([40.107.70.101]:39762
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727010AbfIYWXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 18:23:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHvCd09gCLTrmHTcUR1psY+nRFbZQ6tTdJwFTtw2wiKoid+qfCIe6Q726g0vs0OISX8tNqGmh9j7lrfhRvoXu6KGOMIjfnCpi6WucvLc9rcEe08TIG97ymdFJ/EJhQ1urd2JwXJOqahSsby3XgfGSFmMBfWMihYKLHrRFsvtf+Eh9L/uNm1/f744mi/7+XTS3auTCQD0HeI48mK1U9yEzdQx1JyYssaZDaYCHm0fI+D2+lCgX/oXX+Ejvxf/pVr1+iIS5MglLXtJ9vA8wYYn3mvLRaOqt3e9HR4wLtXygKf7J+t/74JtTpGwfHEn7KuzR359XlMNemH1TZen+sK5zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NRem3lWQqXik2HLucQ9dV31hBwYtbB/bVMNCPabWeZg=;
 b=O6owLXuPh48xX76fHykGUZ5wiyYT9B1Mp3hAUGQ2J8vnFJkphqlLWHZHjOYA743ote9cs4iOupAkGCuJEwBkNKBAjnZvNu7jw/T2uOdfjfp7fQdoFA5QgPUgoV9aaNNbumZeE4vSfjBgJ7H3fLw1me8BaueNo/x59WN9mqF1cLtD84k1R0o1f9aWDtnkiizd2vueLHAgJyH6Ql9MjvJPqMWrWPkArTOroB5BT/E4ZBxnzI+ratu6xdd4UGlYZ6wHU4ZB8oxEQQpc1QnQhTE9wLpdOuUlK95O1QWujHuCh1dvueUnY6YsO+XxKicjEJloeSHK/j1kKYVBW5nXz5VdPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NRem3lWQqXik2HLucQ9dV31hBwYtbB/bVMNCPabWeZg=;
 b=gAd1ZhSJ2SQyiQIPkfvzw7oUw/fKJwTBsSmbi7roJp1OG41AwFIrGOhnTf9KOTyS4+AeTiaMWtxsRqahJjpM5Y2SQPdFqjS4OKaf97FDL6x29f0g9pJb66PqtMFSmmolMdkahWDHJOEN821FBTNvmlkdSScwt/cO54g5zeU5c+o=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1226.namprd21.prod.outlook.com (20.179.50.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.3; Wed, 25 Sep 2019 22:23:28 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::488c:54f6:842e:4c1b]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::488c:54f6:842e:4c1b%7]) with mapi id 15.20.2327.004; Wed, 25 Sep 2019
 22:23:28 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>
Subject: RE: [PATCH v2][PATCH net] hv_netvsc: Add the support of hibernation
Thread-Topic: [PATCH v2][PATCH net] hv_netvsc: Add the support of hibernation
Thread-Index: AQHVc+0lDC5AZrZT/kSUmTsZN92eDKc893KA
Date:   Wed, 25 Sep 2019 22:23:28 +0000
Message-ID: <DM6PR21MB1337194387A53DF549398F1ACA870@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1569449034-29924-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1569449034-29924-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-09-25T22:23:26.9387517Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=05dc5d50-2768-4e9e-8630-62d09477aeac;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0a306a5-b516-466e-4b14-08d74206fda9
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM6PR21MB1226:|DM6PR21MB1226:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR21MB12269BF23C99E98537637EABCA870@DM6PR21MB1226.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 01713B2841
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(189003)(199004)(13464003)(3846002)(6636002)(6246003)(26005)(1511001)(8676002)(102836004)(76176011)(22452003)(81156014)(186003)(5024004)(2906002)(53546011)(86362001)(10090500001)(6506007)(99286004)(256004)(14444005)(2201001)(7696005)(81166006)(66066001)(7736002)(6116002)(74316002)(8990500004)(305945005)(25786009)(229853002)(33656002)(66446008)(64756008)(8936002)(52536014)(4744005)(66946007)(76116006)(2501003)(476003)(71190400001)(486006)(9686003)(10290500003)(71200400001)(6436002)(316002)(11346002)(110136005)(55016002)(478600001)(5660300002)(14454004)(66556008)(446003)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1226;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ee9uHZcmjYCDE0gr3Hm16KTdSxaV3JZ6xdU5nJ8fG4dBvzgGyu4h8B1U8mbjujuQRAdFKSxqNWM/ZXLcImyQGjQmSF37avMpL5XZ15Rdz6CZFiARLegdYzswYJ7+LoFoFF+AywHqE786NMVKK+1zOjlkqqGis6Qq+SnR6GCEsdHfYFJGB29C9HOVw/6IuWwIPjgURRhezxrbAH0IgXOvETZ0P2eAy2aOHhtFkZWF9rl6cRMWy1X6CDN2GSoPHFnsUcC780jLjeJ+LMDrJ8995cRO4kIGWDdVboTqwlJ83ScEk9CezOFzoX8HyDexw9VYJhgZOCx69R/VjiDfoxtzl3yAxwM0OUWaugrdLz3dRLQbmFfjwPSVhED8ifalvFbv2x2CBEBh0f/iGwwLSx0SnUcdvfDR1+6/rSsT+lvJHDY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a306a5-b516-466e-4b14-08d74206fda9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2019 22:23:28.7379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: miscHE2fDX4a74eVZYZloHeRcgjvm9rLUIIp/qTqPM7UI7PsJGeMQFXNGZ+DOFZQokvcR8m3jnV8PjHqEPM+ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1226
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Wednesday, September 25, 2019 6:04 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; sashal@kernel.org; davem@davemloft.net;
> linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Michael Kelley <mikelley@microsoft.com>
> Cc: Dexuan Cui <decui@microsoft.com>
> Subject: [PATCH v2][PATCH net] hv_netvsc: Add the support of hibernation
>=20
> The existing netvsc_detach() and netvsc_attach() APIs make it easy to
> implement the suspend/resume callbacks.
>=20
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
