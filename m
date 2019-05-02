Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3E431248C
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 00:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfEBWXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 18:23:39 -0400
Received: from mail-eopbgr710113.outbound.protection.outlook.com ([40.107.71.113]:63936
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726022AbfEBWXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 18:23:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=t9nG4i7BrimZ0tXMN+LaxWR0VtGgMB4g4Iza//MlpevHwa7xadjilyUdhj1uy5l8oVBBz1R+Iw1A/2P2+BAXK3Tph/XcY0jgQhYyOMprhXX7ERGIVYimGuZqBg8ZgarxF3w7X3TSyyhAlMyw4uRgfK23UdrAUfAYtRcvaFX30xw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YX+iDcQdyeKvd7pkyZyaZ/32pNsYVG7AYp5KfXUosw=;
 b=vpcrp+erYzrewOwm2Nv8mRiDvN+vtpdixLHGlSNl7ZMgYEyevzyx4gMGWJPrQH/UtWwJYatf/7yIbIYlxWiRT2PKkjXVmUhFEN3jZOSX6qnlFor6VYaaTrCAe2pPl6WyYBa0L5GTnxRDeS3D8jVk3Ky6NvKOvAgIrFnzosoX5fk=
ARC-Authentication-Results: i=1; test.office365.com 1;spf=none;dmarc=none
 action=none header.from=microsoft.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YX+iDcQdyeKvd7pkyZyaZ/32pNsYVG7AYp5KfXUosw=;
 b=SlNJx3N7tcJZVm3mjDILIKlIGwnoeUnBh3SGySItoRskGluHX2Q6aTCBjwaZdqzO5fIRDESnoRLZQR4qkIef7YWGOA6F7i+YUlZwZQKNGCxZsS0FrbCNE2C5PTBB1zkN8Ofcaivcsz/0ub88ejyRn03P9J4qq9GrojGLHYN9cT0=
Received: from DM5PR2101MB0918.namprd21.prod.outlook.com (52.132.132.163) by
 DM5PR2101MB1096.namprd21.prod.outlook.com (52.132.130.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.4; Thu, 2 May 2019 22:23:36 +0000
Received: from DM5PR2101MB0918.namprd21.prod.outlook.com
 ([fe80::815c:93cf:218c:2927]) by DM5PR2101MB0918.namprd21.prod.outlook.com
 ([fe80::815c:93cf:218c:2927%8]) with mapi id 15.20.1878.004; Thu, 2 May 2019
 22:23:36 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Hyperv netvsc - regression for 32-PAE kernel
Thread-Topic: Hyperv netvsc - regression for 32-PAE kernel
Thread-Index: AQHVAQL5MIhdQT8Fok2ZjXIeTk3EpqZYaLiw
Date:   Thu, 2 May 2019 22:23:36 +0000
Message-ID: <DM5PR2101MB091875296619F1518C109E71D7340@DM5PR2101MB0918.namprd21.prod.outlook.com>
References: <6166175.oDc9uM0lzg@rocinante.m.i2n>
In-Reply-To: <6166175.oDc9uM0lzg@rocinante.m.i2n>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=mikelley@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-02T22:23:34.1321169Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f05d3649-7f6f-4063-881f-89c658604d4e;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=mikelley@microsoft.com; 
x-originating-ip: [2001:4898:80e8:3:a56b:af08:1fb3:dbef]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0955eac8-6a13-4945-b535-08d6cf4cd1c7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DM5PR2101MB1096;
x-ms-traffictypediagnostic: DM5PR2101MB1096:
x-microsoft-antispam-prvs: <DM5PR2101MB1096F906C724AB2D4E646CC7D7340@DM5PR2101MB1096.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:353;
x-forefront-prvs: 0025434D2D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(39860400002)(346002)(136003)(396003)(199004)(189003)(6116002)(6436002)(229853002)(55016002)(66446008)(53936002)(7736002)(4326008)(14444005)(33656002)(64756008)(76116006)(10290500003)(71190400001)(71200400001)(81156014)(478600001)(8676002)(68736007)(81166006)(186003)(22452003)(25786009)(110136005)(5660300002)(46003)(14454004)(8936002)(66476007)(74316002)(305945005)(66556008)(256004)(476003)(9686003)(316002)(486006)(6246003)(86612001)(8990500004)(446003)(66946007)(86362001)(102836004)(7696005)(76176011)(6506007)(2906002)(11346002)(73956011)(52536014)(99286004)(10090500001)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB1096;H:DM5PR2101MB0918.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Y1NEoo09vnIhfMoUALRy1Y8gwqnlssr//YFg6yorBBFH2AUR6AOWQ64N6BmtD1pa74rgQBx3bEBUC5a0VInGIRoi8NzP6h3L9LZlrBaK1kqcP+9KGhJeABAmjax8payjX+WJYMSHudzBOTwamcDBvOuFmyCTN94ZdDOXBHrUO4z0tV47vn5ebonDfWDQNGFsf3BSMRo0+FGJCAJFQz9+CxS6kCsoDE5+QkG4y/6Hyu9CEL5WbrMMEcIpL6Xwoaqf8WHdCuqYbSmCqBdsDjoZE0wgqIKQIIb906l/nwLWn6t/ZbTCPf3od4v+r2yhinFGGKmgdCAHJvTRY9Xl9E5QXv5+u7y8w23Ml6IzY73HgbYaT3bRY03VrfCNyGwMPY1HzwGcXQKGhS0E6eAOOdi36lfjgiqgBlMDqSOZ4iI2Hmw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0955eac8-6a13-4945-b535-08d6cf4cd1c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2019 22:23:36.2884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB1096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com> Sent: Thursda=
y, May 2, 2019 9:14 AM
>=20
> So I got to the following commit:
>=20
> commit 6ba34171bcbd10321c6cf554e0c1144d170f9d1a
> Author: Michael Kelley <mikelley@microsoft.com>
> Date:   Thu Aug 2 03:08:24 2018 +0000
>=20
>     Drivers: hv: vmbus: Remove use of slow_virt_to_phys()
>=20
>     slow_virt_to_phys() is only implemented for arch/x86.
>     Remove its use in arch independent Hyper-V drivers, and
>     replace with test for vmalloc() address followed by
>     appropriate v-to-p function. This follows the typical
>     pattern of other drivers and avoids the need to implement
>     slow_virt_to_phys() for Hyper-V on ARM64.
>=20
>     Signed-off-by: Michael Kelley <mikelley@microsoft.com>
>     Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> The catch is that slow_virt_to_phys has a special trick implemented in or=
der
> to keep specifically 32-PAE kernel working, it is explained in a comment
> inside the function.
>=20
> Reverting this commit makes the kernel 4.19 32-bit PAE work again. Howeve=
r I
> believe a better solution might exist.
>=20
> Comments are very much appreciated.
>=20

Julie -- thanks for tracking down the cause of the issue.  I'll try to
look at this tomorrow and propose a solution.

Michael Kelley

