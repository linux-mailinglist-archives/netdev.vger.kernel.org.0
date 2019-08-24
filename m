Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDD09BE3D
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 16:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfHXOSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 10:18:50 -0400
Received: from mail-eopbgr810104.outbound.protection.outlook.com ([40.107.81.104]:40235
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727618AbfHXOSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 10:18:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNE9EbsppL348gwzg/N7956yOGeL+H6GL4MRZwO7pSrq3IIlTFT60meofBw3fmU8tun0MSD/Rkdlyp2PgFbse0BtxyeumvDUhVgN+dxmA/lOTQI4jsF0Ksuiyc417o4vS7/8hu/RtBR2W5bG31zMTR2XfaZTllv75Q7Uhzwlq4J/O3bqBLFK/oBRWaXggHtGpKtO9FeGnB2TgqXj6xpGf+n8aH48NycJ41ZOV1fvNZoVo9rf3NYScW6CIw053+47b+ZuX7BuRGWQWUyARlKdpICsIHsvb2k6b6dkR0bxRqQeVh3TxBlxR0OX/M+8J2fMetuJ2E7z+kcnSwtYkpyYvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQj/HemMMb+78YOqL7SuxETcYZWVKr21gYiq20vqA2E=;
 b=Qq05U8lyNE4qJTN/xZC4AHfFEVSiR0aDlVk5BtqenHINua9Zq6ZIa5WlUUS0x/s1hZyKdpXYqz2E0a64bVUrgbxVbSCaNH7ROPqK9AyINfOcVqGsvD0QblYrMtgfSUdZW5WA7JKwiNID1XQXZlNBCOut6/x/rnqks20DhOYz8kvnxvhHR85hLEDP9xNnx6I4MOy9kLezMYay5EqhwhEMjs3Ov7B1Wl4xpX8Ag5hxelkpn3XWHQNogqHItF7GKxS3eB9+bPhEL9STkxBQ7r8Vze5j7qyc6Kvd5oljUPXYMxHzVJ+s5kGRPKd+7Uo3chMns0TakAmDsXtQX7ndGUXDMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wavecomp.com; dmarc=pass action=none header.from=mips.com;
 dkim=pass header.d=mips.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wavecomp.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQj/HemMMb+78YOqL7SuxETcYZWVKr21gYiq20vqA2E=;
 b=Pvoo4MP0oJ+/t8eILBN9iZSRAxPUB7EvJ9hJ/njxqBORlws5URw4/yLd618rYtUSde4dkbu6t++GRUrfXQHowobrrZmZYb8EHEPP97YuHo6tMWhywk05Di+XdyomzctVyNsFGtPH/EBZR/lXq7ZArReinMiUlQRvN7X5/TdvNGk=
Received: from CY4PR2201MB1272.namprd22.prod.outlook.com (10.171.214.23) by
 CY4PR2201MB1304.namprd22.prod.outlook.com (10.171.210.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.19; Sat, 24 Aug 2019 14:18:47 +0000
Received: from CY4PR2201MB1272.namprd22.prod.outlook.com
 ([fe80::2d81:1469:ceaf:1168]) by CY4PR2201MB1272.namprd22.prod.outlook.com
 ([fe80::2d81:1469:ceaf:1168%5]) with mapi id 15.20.2178.020; Sat, 24 Aug 2019
 14:18:46 +0000
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
Subject: Re: [PATCH net-next v3 2/8] MIPS: dts: mscc: describe the PTP
 register  range
Thread-Topic: [PATCH net-next v3 2/8] MIPS: dts: mscc: describe the PTP
 register  range
Thread-Index: AQHVWobXiJm4BSQh4kq1KoJu/9U8ww==
Date:   Sat, 24 Aug 2019 14:18:46 +0000
Message-ID: <CY4PR2201MB1272F1401D4F5E691458CC11C1A70@CY4PR2201MB1272.namprd22.prod.outlook.com>
References: <20190724081715.29159-3-antoine.tenart@bootlin.com>
In-Reply-To: <20190724081715.29159-3-antoine.tenart@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LNXP265CA0058.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::22) To CY4PR2201MB1272.namprd22.prod.outlook.com
 (2603:10b6:910:6e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:5e65:9900:8519:dc48:d16b:70fc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f0a9c3b-d84a-46ce-63ce-08d7289dfa08
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR2201MB1304;
x-ms-traffictypediagnostic: CY4PR2201MB1304:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR2201MB130439C6C30AFA331B7915E6C1A70@CY4PR2201MB1304.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(39840400004)(376002)(366004)(136003)(199004)(189003)(33656002)(81166006)(81156014)(8676002)(6306002)(54906003)(6246003)(25786009)(256004)(8936002)(6436002)(316002)(55016002)(9686003)(71200400001)(71190400001)(7736002)(5660300002)(64756008)(66446008)(52536014)(66556008)(74316002)(305945005)(66476007)(66946007)(229853002)(6916009)(14454004)(4326008)(53936002)(478600001)(7416002)(966005)(476003)(486006)(186003)(386003)(102836004)(6506007)(76176011)(52116002)(7696005)(446003)(99286004)(44832011)(42882007)(11346002)(46003)(6116002)(4744005)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR2201MB1304;H:CY4PR2201MB1272.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9tcMPNgGBLQ/2JOL/jJlFaI+3Vis/RRaL+qxtwJj+fCMh4+EpImjchltYEcW4u/hRVh/x7o4fnieMr/XQr9fPMdPhO+l31Z3wtitGAT/VjHT7D6Ypl9Pnb+RJOGM5UiPZlCsHwfCa2NbNG48H1C0WL/hLT2X9xNwFJM6DXh2G5tAL9IFMW/faT8mCW1eyGGh7ri35EJie/N+IX1aUfPBgDeXxT3Alx/q4iQK2CY/i+J4jEaCiqFfhq3apQk2YOQO8iDWPne60+PhCCabSmenrZ3qZoGXY+g2yiJdN6OWb1sx5qqm92qxKV8rDBMqJfybOHt/vZGomOA8NlHGIfoUiB5YQD3RXM2fHN8AGte8+dRp4puB2MAvdAgn5IujW2ac33+qRyqOtyWNx6Hgaeji8OqRtyVkQ1BO+Au2H2x/lAY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0a9c3b-d84a-46ce-63ce-08d7289dfa08
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2019 14:18:46.8253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ojuCpgsRAaijVHrJHu/CmgA7itWfcglrUqsl/zr2Blu7cZnLmZb6yYnmAnA2+0P+EIO8vdj0jjsUDLAXNNzJ9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR2201MB1304
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Antoine Tenart wrote:
> This patch adds one register range within the mscc,vsc7514-switch node,
> to describe the PTP registers.

Applied to mips-next.

> commit 048dc3abe827
> https://git.kernel.org/mips/c/048dc3abe827
>=20
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> Signed-off-by: Paul Burton <paul.burton@mips.com>

Thanks,
    Paul

[ This message was auto-generated; if you believe anything is incorrect
  then please email paul.burton@mips.com to report it. ]
