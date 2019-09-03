Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70DFCA64C6
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 11:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbfICJK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 05:10:56 -0400
Received: from mail-eopbgr790137.outbound.protection.outlook.com ([40.107.79.137]:26592
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726557AbfICJK4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 05:10:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7f2aBRBK/Oo0+6H9g+KSxATOxlJ97Xuu+UMFPKpMyUVjIpoM/V95/3kUCZVGDwoYTBKUYfTZDv4UjzQvREMrsr9ZmfAjJUvH8A0Hpz2JIEqfa3K7s6wd5mjTSoCa55Czkf+GJ/yZLID+4drz5HqhQrdY8jv0h3QcTr34Ns/lTQzOtPdfzrsCiUZrg0gz/XiIrYtqKp1Cu0whQKB69tYLOkXiSc2lpRmUfKZTlBTfyhtgL8pgThe+vstU16pnYSGwANfgZy7svSvwbnymMVwf27G4V3Pk3rn+FvvR6fSc8Lk9SPYKgOPYLGZVBi8cpD0l0JYjlUx2UW+XTDiLyLt/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9EUhd1jB7mK6BzogD/0f2+S4IN+aQkhGwbN+Hw5ymc=;
 b=jb2WcWyDJ9DWxc+ogs8mcRT0W4ZKUdq3M1v2kQhflzaTjd/FhM7VtTYzaQlazC+dHdh9haiXFkflQuvuT24Xr5rYWioJTcZfpfsDG15eDI3f2R9xgfEcbmUB/jn05Jns0iqVPP8a+oOuAM1yDfry+7J1MbhuvDOL5iqcuuYSOFChoEOgxvBalt8UU6u3Y6nzoSDACwCKTEh7v1MZt8bD1gXjaefLI8CKJyfg+1o4Oe1y3mUiSm354rfZIC+ncMA1nioOPOOFFN7yQ8ejbQhfwavl9yLfzZl0R2BigtTDcWyCuMa1rQ6PuAkumSkRVu83rqvL052+3mHqzexrsyJkEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wavecomp.com; dmarc=pass action=none header.from=mips.com;
 dkim=pass header.d=mips.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wavecomp.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9EUhd1jB7mK6BzogD/0f2+S4IN+aQkhGwbN+Hw5ymc=;
 b=upScYiC7qsvh4ZlWPdsztvpQeO5AQuUZkaXLlAL7L+lxOw42AksKBY5ZTGBNwGYzD+jUAHx6a2QDIUcGx+Gilkx6N4kaulWjEH8HE7SYdSVrM1h0xzOyUDsgQITMfCaKNeH2ZYAbTCJBSLpNHRy9o+T7VS0BPFFf3EycmV87XNU=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1311.namprd22.prod.outlook.com (10.172.62.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Tue, 3 Sep 2019 09:10:53 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::f9e8:5e8c:7194:fad3]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::f9e8:5e8c:7194:fad3%11]) with mapi id 15.20.2220.021; Tue, 3 Sep 2019
 09:10:53 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <pburton@wavecomp.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rtc@vger.kernel.org" <linux-rtc@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH v5 04/17] MIPS: PCI: refactor ioc3 special handling
Thread-Topic: [PATCH v5 04/17] MIPS: PCI: refactor ioc3 special handling
Thread-Index: AQHVYjd8rUWfDFbi7Ey4tyNvKR/uvw==
Date:   Tue, 3 Sep 2019 09:10:53 +0000
Message-ID: <MWHPR2201MB12779E08754158B97B8A9A83C1B90@MWHPR2201MB1277.namprd22.prod.outlook.com>
References: <20190819163144.3478-5-tbogendoerfer@suse.de>
In-Reply-To: <20190819163144.3478-5-tbogendoerfer@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0275.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::23) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.196.173.241]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c2ffbb5-a1cb-4b3e-a585-08d7304e9ef6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1311;
x-ms-traffictypediagnostic: MWHPR2201MB1311:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR2201MB13116C2472901BEE809FBA89C1B90@MWHPR2201MB1311.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39840400004)(346002)(376002)(366004)(136003)(199004)(189003)(14454004)(4326008)(386003)(102836004)(42882007)(55236004)(6506007)(186003)(26005)(52116002)(476003)(486006)(44832011)(7696005)(14444005)(6916009)(33656002)(7416002)(446003)(11346002)(76176011)(966005)(71190400001)(6246003)(66446008)(71200400001)(64756008)(66946007)(66556008)(2906002)(5660300002)(4744005)(66476007)(256004)(8936002)(81156014)(6116002)(66066001)(8676002)(55016002)(316002)(54906003)(9686003)(6306002)(99286004)(6436002)(53936002)(478600001)(305945005)(25786009)(7736002)(74316002)(81166006)(229853002)(52536014)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1311;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yESQEe8lVZsqkoEgMi2IOYjILal4xTOxUCwVfoJcqkLtd9FtHTUGWsaPrdX4APvzlDSm1mQV8UoAetwBAZIg3Eu1KCpuri+/APsQqMLICoFZeUjhMFTvMQNPpfPVYE4tYAzfvD6mzZbiv/DUuGRHVYRhVcd32GnY3RmKLdqzJH+gytY7/Q4j9CK/lkMWzph7cGxLeTiB+tZ3A7jmiw2CA4P0QRpC8jFFRia4LtKPpKdLa//bZNUqpojg5M+V8DYL8pD180FLjP3pGQoimTLnANOjZorCW8gwLGXQY/jj4K3f9EHSR4W/dETpWWVFDgI86DVNvtmo1bj22HhgEdU2LqdWeoYutaHFwIQPUb8/btTI4DIhDfuQ/WOwi6MbfPYJoDoseCdJ1KPKiN6S66AHnuE1uHa3ZR1ZBpYLxtnggnI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2ffbb5-a1cb-4b3e-a585-08d7304e9ef6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 09:10:53.4698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U8qbxL4VbGaO/9gop127afN6NFWAoDSdPZbl9O+eCmIbsTC/w7xSOzDZUmxrMSSzvuQOHl19soEiN6HDgc14ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1311
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Thomas Bogendoerfer wrote:
> Refactored code to only have one ioc3 special handling for read
> access and one for write access.

Applied to mips-next.

> commit 813cafc4109c
> https://git.kernel.org/mips/c/813cafc4109c
>=20
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> Signed-off-by: Paul Burton <paul.burton@mips.com>

Thanks,
    Paul

[ This message was auto-generated; if you believe anything is incorrect
  then please email paul.burton@mips.com to report it. ]
