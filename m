Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A24AA538
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 15:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733085AbfIEN7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 09:59:16 -0400
Received: from mail-eopbgr30058.outbound.protection.outlook.com ([40.107.3.58]:3286
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730739AbfIEN7P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 09:59:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=df63PsAn6WpgD0PLXPWb6ovX2vA30xB0dGq0Z2ifIsqAzxyA7vBH9/Y1G9RZfHGa6FZzSyXK8gtJhOgfpC1eDFktNw8TVjlO0KrQ2GiRMMEoYXuib6IYgTOdfwOhQPwPSv2cnj94LU7lTRXCkTI6ZNtrfFACYLJCdTN83aXo2WHRUlzMDMWCL+Ph5imDCqXNSxc8cQMfFBiE4eApE0u7lSwc2LdFh97MzwgNMJW+r1x5HB3O57cbO6TeRJ//V8HxbstM+JyWU3OKg9RqJUtPnH1AQhUS1y8dZwrHNurmMpFx35PseiSfB6cBqQQqH9hU2Uf3ia9p+jilq5YJD3NDdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMizm16Z+F9Mrxrg67ccIMS7U02Y9WbnS9tOyZE5WOk=;
 b=c1d+WInCV2GujWUAdm27kixitBef6NOEwCBspLl05rn1HUGfgofZnF4YTO4wH+kAhg6lxbYRHbIo/WdG/cBSqe0B6H1h0Qjc7XCuQOBGQdgXUflgxzEMkiMCP7zt61FeKcDqc+Zzxsq4eefYSn06FSr+OYSH6lUxuCO0QOuJg4iSwmHhzGbt3lKiCPVz8bRjOFRn7CIM+k/85LVAKtG2o8uplFafFRBr9PkYlF22Mq39n0iM7bnLH0yG5ieZfA0fBPG/bgXWi2MM2FQSxjAgeFYU+asBdPUMOudE9EzmTWBUyb4YQrkc0a9hu1RLjedr3Az0yvt4muJpD4kwxrJncg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMizm16Z+F9Mrxrg67ccIMS7U02Y9WbnS9tOyZE5WOk=;
 b=WKMK7AE4+8mhynCpJh55lDsrjJi2cL46C8GpbsGOwC1fdMci3K7PwI2dLI8D3Mr5gWNzjnsXdDewkOYORcYERQDAai06J2R4Ax95co2uLkGxzChEi1YsYfAHgtlI1Tqhr5Vy/NCp4wHlMW2nsKZCYA4U+OpktgbzioDL65iM+Y4=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5183.eurprd05.prod.outlook.com (20.178.11.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Thu, 5 Sep 2019 13:59:11 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::79a3:d971:d1f3:ab6f]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::79a3:d971:d1f3:ab6f%7]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 13:59:11 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "jglisse@redhat.com" <jglisse@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/2] Revert and rework on the metadata accelreation
Thread-Topic: [PATCH 0/2] Revert and rework on the metadata accelreation
Thread-Index: AQHVY+VUnpT/Tzy9vUuDxdg4xWUdk6cdHGCA
Date:   Thu, 5 Sep 2019 13:59:10 +0000
Message-ID: <20190905135907.GB6011@mellanox.com>
References: <20190905122736.19768-1-jasowang@redhat.com>
In-Reply-To: <20190905122736.19768-1-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LNXP265CA0085.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::25) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 171bda58-a846-45b7-175f-08d732093a20
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5183;
x-ms-traffictypediagnostic: VI1PR05MB5183:
x-microsoft-antispam-prvs: <VI1PR05MB5183FE3F1720403ACB20303ACFBB0@VI1PR05MB5183.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(199004)(189003)(3846002)(6116002)(76176011)(5660300002)(102836004)(186003)(66556008)(26005)(71200400001)(71190400001)(66476007)(14444005)(4744005)(6512007)(8676002)(478600001)(66446008)(386003)(6506007)(66946007)(64756008)(2616005)(476003)(1076003)(486006)(86362001)(446003)(11346002)(256004)(66066001)(2906002)(6916009)(7736002)(6246003)(33656002)(8936002)(25786009)(4326008)(36756003)(305945005)(14454004)(53936002)(6436002)(52116002)(54906003)(81166006)(81156014)(316002)(229853002)(6486002)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5183;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: adzM/hgIStuBPGyRMZbeZW3tI3aZg98pbWLvSgnzBMCvrrhjVxWQtFGqc1a/yi6I6imIOUt74wAxhCmO/Tz/tiDaA2ySB8idd5hZiZ1tSTteAKPcB8NVpLLOo1TOLpASe0tgRIauZAzZwRPIQmoU961/5qzmDNwEGFYCJj8QlcCoFZvCMnRTa50qh3vkbF2Vad5WOnyfkcTdcs6AMrcr5fh7e8+If6kUAK9OqwasHoVfR4c+IK+3QXCevNMykWAN+j/tYVSi68UHsPaa7tYxqZ3rfS8hY+FSPC3VxIGSaAJDHHoUhCcJdmlI93C4NKQTCRzfGxSXSun99PVWim/Q02+0wraqZqgrgY1gbF5+PBQycQCv/ZA2sGOFxH3q5dOSvRcsvnkXfKz4XzMwPBAuShLEIHOhNhPGzIkAHAXUOZ8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A9EFBDB41F67594A8536A97722126F60@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 171bda58-a846-45b7-175f-08d732093a20
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 13:59:10.9169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cJHkiKeD5jjSxVxs3lfvbMZrXhjFojVGmf1BmFlK7WeSM62dGGLgx3Aw5ApkrsgJx+luBZMkx8jDfllTC7/ETg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5183
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 05, 2019 at 08:27:34PM +0800, Jason Wang wrote:
> Hi:
>=20
> Per request from Michael and Jason, the metadata accelreation is
> reverted in this version and rework in next version.
>=20
> Please review.
>=20
> Thanks
>=20
> Jason Wang (2):
>   Revert "vhost: access vq metadata through kernel virtual address"
>   vhost: re-introducing metadata acceleration through kernel virtual
>     address

There are a bunch of patches in the queue already that will help
vhost, and I a working on one for next cycle that will help alot more
too.

I think you should apply the revert this cycle and rebase the other
patch for next..

Jason
