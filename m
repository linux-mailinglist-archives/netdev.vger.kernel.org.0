Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D2D9BE3F
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 16:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfHXOS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 10:18:58 -0400
Received: from mail-eopbgr810125.outbound.protection.outlook.com ([40.107.81.125]:11892
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727618AbfHXOS6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 10:18:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcGomaMX6dwCBrT3wipRGx3QrJS8XVIZ8Y+W4JfGuXcnXvDFsdM3Mb+3NF/dUi85IuGFpDU7EZjAeuYIFV0X5RUU65PVR9XFrLwu4kz939B1z02F+VV+rV2lHm0Vf/iVPCPwun7KxJv0/RHkeIysZqzpTt/sl9V9J7SDUYr0ugK94nCycFHWe+/NznGjq5czmRN9FmMS46Eh21Ox2jYlR2V2w5/t/e9ASf1p9T3R0rCDITZP4xuQy2LoGyNkm4diAcdDNjeUP0/PdCXZ+xU08EzRcpRADtmRxN7mQ6J7MOnfdRg3rJsiXAbemySXNIp82rRxFuzZmeuJmbViKJQWQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rs/pMHAdB9QCZmlhPhdlYgfcNmdFDUEWRYbY/k/jjVA=;
 b=I8fF3cqobAqVWf0dsgNyAJoDsbCRaz+bxZ25lMXkXfsYEsORQkmYUjS5Gu4tuuYsBh12C7DllQ1xNXJzqtCvufUZL7Y2xNLbeoHfcsRS1R1MYBJ4Se0KaQYqedmC7QLjuc8c6dMRx6gLCIKLq4fOqzUSH4tA22vMV61Ilp0YoR3VQij1+HeLtvnwxphc5EkIXaPDV8hoZ/p+D6wfoGcCL1rAxdVGcdY9pXtMChXg5HRjL37a0eysX7LV9HVu16AnhkLaIImFHrN0/4JBiMfkrQml3Kcf0Q26+KiIGfw1JENwoIjlGQSTw7XyJq0PQq/foSqPs5/ZdO5Hj/wvLFAtiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wavecomp.com; dmarc=pass action=none header.from=mips.com;
 dkim=pass header.d=mips.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wavecomp.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rs/pMHAdB9QCZmlhPhdlYgfcNmdFDUEWRYbY/k/jjVA=;
 b=D4IzlTtQIed1skdvjM1lyJ/60XBVKq/9CzpJMJGi6kZ8eHhozLpPxyMF8kfOZ6TCZZ5fEz2BrO6vRa5xIZOTuGIA8Q9TCzuNLOOS2bBvxyuOMoxuOZPmyANURT5NQK5FHXwbuI0kVHBKawP+3QUXtaVUU56msB8xeLukKMMxV6s=
Received: from CY4PR2201MB1272.namprd22.prod.outlook.com (10.171.214.23) by
 CY4PR2201MB1304.namprd22.prod.outlook.com (10.171.210.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Sat, 24 Aug 2019 14:18:56 +0000
Received: from CY4PR2201MB1272.namprd22.prod.outlook.com
 ([fe80::2d81:1469:ceaf:1168]) by CY4PR2201MB1272.namprd22.prod.outlook.com
 ([fe80::2d81:1469:ceaf:1168%5]) with mapi id 15.20.2178.020; Sat, 24 Aug 2019
 14:18:56 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        Paul Burton <pburton@wavecomp.com>,
        "jhogan@kernel.org" <jhogan@kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH net-next v3 4/8] MIPS: dts: mscc: describe the PTP ready
  interrupt
Thread-Topic: [PATCH net-next v3 4/8] MIPS: dts: mscc: describe the PTP ready
  interrupt
Thread-Index: AQHVWobd9le+Cdj8lkCmv2k/0nT5+Q==
Date:   Sat, 24 Aug 2019 14:18:56 +0000
Message-ID: <CY4PR2201MB1272FD18679D457C981FE03BC1A70@CY4PR2201MB1272.namprd22.prod.outlook.com>
References: <20190724081715.29159-5-antoine.tenart@bootlin.com>
In-Reply-To: <20190724081715.29159-5-antoine.tenart@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0353.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::29) To CY4PR2201MB1272.namprd22.prod.outlook.com
 (2603:10b6:910:6e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:5e65:9900:8519:dc48:d16b:70fc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff1e331a-943e-425e-bb5b-08d7289dff87
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR2201MB1304;
x-ms-traffictypediagnostic: CY4PR2201MB1304:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR2201MB1304600A09439E46AA10ACAFC1A70@CY4PR2201MB1304.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(39840400004)(376002)(366004)(136003)(199004)(189003)(33656002)(81166006)(81156014)(8676002)(6306002)(54906003)(6246003)(25786009)(256004)(8936002)(6436002)(316002)(55016002)(9686003)(71200400001)(71190400001)(7736002)(5660300002)(64756008)(66446008)(52536014)(66556008)(74316002)(305945005)(66476007)(66946007)(229853002)(6916009)(14454004)(4326008)(53936002)(478600001)(7416002)(966005)(476003)(486006)(186003)(386003)(102836004)(6506007)(76176011)(52116002)(7696005)(446003)(99286004)(44832011)(42882007)(11346002)(46003)(6116002)(4744005)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR2201MB1304;H:CY4PR2201MB1272.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6d4nzkyZ5W+ajz3ZxVzvLcZHBCi9jqSdPkNyniUksdOuxu690n41RACQff9xy0npXby1AY4pf2VmFzNv6fuGVSgy7NUmviZFpw0rQay/tGRQ5QY+xRXiX/OEQ2kwMim8M8rYiYYQ3ipj08hitOUcHRJ3M/p1SUfWkjx78S2XQoEvkXVIJ/vU2sPdSbk2d7ZhzxLjQgDE1FfhK357W0Lrt0jARi2Kjd9jxjaRN/WDYGUrSCMAlNSHPwvsS0iAMNEDzpsMNHjnZSvcPJVx4WR7Zjo6KbjIiIAZTCO+Oo1rR5D1IPfN1afCL9rXeE0w+ql7/GCyI8/64xTTn2Z51mdGiNRBmZl+arEEngU9+ckUdeJeqOik2N4zOjBzkcrhGE+BKvCjgwfBSy9ONguZnEEKK7Jp21NZZ1mnhGmGB8vJr4Q=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff1e331a-943e-425e-bb5b-08d7289dff87
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2019 14:18:56.0105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XWhXqJ2cNDidwpjwiPo7a1XBFmMgTHP80KEjeIrIduqXpuJ+NjGs8oCpx9yahCRr0guuLxNzn1RrOmOx1SAN5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR2201MB1304
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Antoine Tenart wrote:
> This patch adds a description of the PTP ready interrupt, which can be
> triggered when a PTP timestamp is available on an hardware FIFO.

Applied to mips-next.

> commit b4742e6682d5
> https://git.kernel.org/mips/c/b4742e6682d5
>=20
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> Signed-off-by: Paul Burton <paul.burton@mips.com>

Thanks,
    Paul

[ This message was auto-generated; if you believe anything is incorrect
  then please email paul.burton@mips.com to report it. ]
