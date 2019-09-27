Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14AE0BFE37
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 06:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfI0Ej3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 00:39:29 -0400
Received: from mail-eopbgr1300122.outbound.protection.outlook.com ([40.107.130.122]:5613
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbfI0Ej2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 00:39:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RygEXUNPGuMbkrt5JgpUZHbbcEwypT8hmXv/dxsEqGCz1xwCj2RDOIk+ngTYcoN8SsXqISLIk7ymH8GdDWh0cw7t1mpWs9Mo/npYsQqoX1C/VWspfevGQ1z53CYKYBCTevolYTiY71IoBbHkuHnJE51TnSPJ+B2ogKceUd8HMujZ5xmNdQvwFqMxGW37rxHk6KE8XXOgNwbh9m0PvRlElgj+B337t1pSbhO6ej3KCF9WUrTQuEN5xXMCpRs8jnGnDR5b1TKa3sR5J/IlMMnoZfILg3Wwk52xwvenLaeLMWWtHS8ELCBbZ6HxtmZ8wvmGx2YQ/pXUK0I+o7wNKQBfwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPBBFMaa4tD1T1exfIbRtd0IZbi0r5Mk1jnLe9ufxeY=;
 b=Oaz6Mgo9FVUf2B+dYVEZIGWO0NVITW/ThD9vI5RVepzXmZ7ywfp/oGSdN65cxxzT3lkgOF81aFUxNC+xkmfbyMv/J5H8IGxz55T62HmjOlLnzQu5l5Hp2MZ7nQ8t/PyJMa3T6OOyYdG6o5tscfolFD0/2rWAwPwfEQ/ipsgytbKIKwDzFSeRFRqSnJJQJbIwYDwP3UkOpNCh9eVFKerRPeg4IMpQIYmgK73LyvFnXIAE3iEWfOvd8swzwwjAMhOgS9TtrQrw2JYxnhu9b7NXBUxDCFUZNOFrxuuI5bL9jPtPZiU2zA/LDT2fASyFcat6EuY650wFBL/lSt57O7+9ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPBBFMaa4tD1T1exfIbRtd0IZbi0r5Mk1jnLe9ufxeY=;
 b=M36FehZx6sMwgUKnmOvUkd4araT0YmyM2tbvbxmgVUlFrVFdHNCRQKfnpmyN/GDbPNioE8WHPNnpIPgO1azM/b+jMDLUII091jm1AHyQvWiCWAL9LLMcSuzTRkxy9NRBgGRwf2SjBuWF45i9yKgdaP5QPKn8zZQeMXqAo6QUnxk=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0153.APCP153.PROD.OUTLOOK.COM (10.170.188.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.3; Fri, 27 Sep 2019 04:39:18 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2%7]) with mapi id 15.20.2327.009; Fri, 27 Sep 2019
 04:39:18 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     kbuild test robot <lkp@intel.com>
CC:     "kbuild-all@01.org" <kbuild-all@01.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>
Subject: RE: [PATCH v2][PATCH net] hv_netvsc: Add the support of hibernation
Thread-Topic: [PATCH v2][PATCH net] hv_netvsc: Add the support of hibernation
Thread-Index: AQHVdOtIvVP7uozUnECo7mWGk3f9h6c+7q1Q
Date:   Fri, 27 Sep 2019 04:39:18 +0000
Message-ID: <PU1P153MB01691FC64459D2713AD6E692BF810@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <1569449034-29924-1-git-send-email-decui@microsoft.com>
 <201909271207.245jsWr2%lkp@intel.com>
In-Reply-To: <201909271207.245jsWr2%lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-09-27T04:39:16.4810696Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0dde5ed5-1be0-49cf-a7ef-e02b36369d59;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:7f70:557a:f14b:ea25:465f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 393ee30a-b9f6-456d-03bb-08d74304a8c0
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: PU1P153MB0153:|PU1P153MB0153:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB015351A723150AD1D94E25FABF810@PU1P153MB0153.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(189003)(199004)(33656002)(52536014)(486006)(186003)(99286004)(14454004)(256004)(66946007)(76116006)(66446008)(66556008)(64756008)(14444005)(66476007)(55016002)(8990500004)(9686003)(10090500001)(446003)(6436002)(476003)(229853002)(6116002)(4326008)(11346002)(5660300002)(2906002)(4744005)(6246003)(46003)(7696005)(81166006)(102836004)(81156014)(71190400001)(74316002)(71200400001)(107886003)(25786009)(8676002)(6916009)(305945005)(7736002)(8936002)(316002)(478600001)(86362001)(6506007)(76176011)(22452003)(10290500003)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0153;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B7kM11vXmVoDB8UzoCV32WFX/Cx5kBoYRfNgGb7p5hNWTy9h9pSq9mUZkq09rm2emHJt8Q4WBEMTRqtCt4rkLkAySjOjCywzwnB09qlWot4jPMNiaxTF0EIUlYip6YIRmXhQO7hL5nLwoH9SvDpSd4KlBIH/DtwcSIGwfh0fmcUgLF7vsqsbNxJk/hYZm7Mb9wqXXEcP6HvB23qooYP8d7Uu+3sytPA6tK7hTTLHOTNNG9uJ7Otj/3lgDkx975+yUoaGciSxV/1CDgmMFih6ZlUDbRPVh/RlyOSsSrhBZRjWaZUOsg42/sS6DpLgsNX6S+GWKM0mwJOTWrsNGa6TYvquNjxRcP2L6kUIDaipXoQhtULQk/roTBViVqa5oVbJY/m3ue03+9gJisvaTZVcdiEkE1evq0BaV/fSZiFneoc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 393ee30a-b9f6-456d-03bb-08d74304a8c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 04:39:18.2183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IT2McOdtH3s1Gi+2BfWByJ7aHYn/my8l2VXxhokoK8LDhkcaHZIHqrgD4HeCkzgKxKTvYEVLL0qKeT+Jy0L71A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-hyperv-owner@vger.kernel.org
> <linux-hyperv-owner@vger.kernel.org> On Behalf Of kbuild test robot
> Sent: Thursday, September 26, 2019 9:18 PM
>=20
> Hi Dexuan,
>=20
> Thank you for the patch! Yet something to improve:
>=20
> [auto build test ERROR on net/master]
>=20
> 'netvsc_drv.shutdown')
> >> drivers/net/hyperv/netvsc_drv.c:2487:3: error: 'struct hv_driver' has =
no
> member named 'resume'; did you mean 'remove'?
>      .resume =3D netvsc_resume,
>       ^~~~~~

This is a false alarm. Your code base needs to be merged with the latest=20
Linus's tree, which has the prerequisite patch:
271b2224d42f ("Drivers: hv: vmbus: Implement suspend/resume for VSC drivers=
 for hibernation")

Thanks,
-- Dexuan
