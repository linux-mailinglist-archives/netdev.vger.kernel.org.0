Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F76046E768
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 12:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbhLILUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 06:20:48 -0500
Received: from mail-eopbgr50118.outbound.protection.outlook.com ([40.107.5.118]:52103
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232614AbhLILUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 06:20:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbB/rnc4WBN5y0eLvRSOfNb0TX/dJaZHFk1JhltaN24174iA94lmu+g15dV//rbE2PpPVKF9685+GWkE/tqi8Dyj8+cRxopo7WoRIzF0qxv0hu8hPnxQzCny+T+njKhGs62TuMrEzWhPnWONJcroTHfqyoadmbg03MBKHlttgDlkqgfKkNIKtI2HyNki5kgxRtDaU2trjT+H8ADJ3VaZ8hsklEHrvScHiBS1BGNuyp7DT+KZWHu4ZGqs7hxrHVeuVEaRoJe/3Ib01aAf42ki6Ws5z4OAjoUhshGqMdSiyYJn/qKc7JXVx3MttGHnHtr1LM3uurC1y7gQdkvUXIIG2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZj7Q76dFz6Nq2ULTtSDqcW1TPz2sdJ9h8BvSaeAZaM=;
 b=cRZ7eoPK1dUKpRY1BS+hGe9kIrD8zFg+eC87jzNpJSqpWd26600cKXonQeefD37hgXZhj6Z9gQ5IHMXFEgvfd28MXXIELdXnMzBNQQ42Rb0PQibwmIHtJKED0fIYQ2kn4lHHDjr1DfZIGeVQVfWbiqoe+CkulyrSukrkzkm9vy+iHUGY3jGkUH7Z8l1HsACb4wunZbpVCW9l/Rnn9kLluEUReYG0CUrn7Aq72pmWUt4xY+QnRptcsuhIylYf5iJfLyDRgyuuHtR5kIO3XR1ZRLrvGFUOutdb8mHKFzidW53T9y7oPP5Iu2SxTqb71J4xrBHgpIcK3AP7z6kWFQgYmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=schleissheimer.de; dmarc=pass action=none
 header.from=schleissheimer.de; dkim=pass header.d=schleissheimer.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=schleissheimer.onmicrosoft.com; s=selector1-schleissheimer-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jZj7Q76dFz6Nq2ULTtSDqcW1TPz2sdJ9h8BvSaeAZaM=;
 b=drDFJDc0NT9fi2AOdzQUSjszUnVMVI7zW3SzApeyqbKiIhh+8Nw4/RSH4hOzQI2uF08NEiiBwMd4171SXxM58m8A+aPHI737G04sYCOFTARse1fpljJSPJh0JK0Mt1DambOMeqds+Zc8axeB1BfT1Cs5GGX4k1SSJq/dbhGfgwY=
Received: from PA4P190MB1390.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:103::8)
 by PR3P190MB0953.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:87::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 11:17:09 +0000
Received: from PA4P190MB1390.EURP190.PROD.OUTLOOK.COM
 ([fe80::8c49:c17b:a3a1:f12d]) by PA4P190MB1390.EURP190.PROD.OUTLOOK.COM
 ([fe80::8c49:c17b:a3a1:f12d%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 11:17:09 +0000
From:   Sven Schuchmann <schuchmann@schleissheimer.de>
To:     "Thomas.Kopp@microchip.com" <Thomas.Kopp@microchip.com>,
        "pavel.modilaynen@volvocars.com" <pavel.modilaynen@volvocars.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "drew@beagleboard.org" <drew@beagleboard.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "menschel.p@posteo.de" <menschel.p@posteo.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "will@macchina.cc" <will@macchina.cc>
Subject: AW: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Thread-Topic: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Thread-Index: AQHX63m5RC9thyxmT0S34SqWhDegYawp9YdggAAPg6A=
Date:   Thu, 9 Dec 2021 11:17:09 +0000
Message-ID: <PA4P190MB1390F869654448440F869BCBD9709@PA4P190MB1390.EURP190.PROD.OUTLOOK.COM>
References: <PR3P174MB0112D073D0E5E080FAAE8510846E9@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
 <DM4PR11MB5390BA1C370A5AF90E666F1EFB709@DM4PR11MB5390.namprd11.prod.outlook.com>
In-Reply-To: <DM4PR11MB5390BA1C370A5AF90E666F1EFB709@DM4PR11MB5390.namprd11.prod.outlook.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Enabled=True;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_SiteId=81fa766e-a349-4867-8bf4-ab35e250a08f;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_SetDate=2021-12-07T16:53:12.130Z;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Name=Proprietary;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_ContentBits=0;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=schleissheimer.de;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24171cfa-ebb6-43b5-b2e6-08d9bb057136
x-ms-traffictypediagnostic: PR3P190MB0953:EE_
x-microsoft-antispam-prvs: <PR3P190MB0953DED1A7CE6C161896F1E7D9709@PR3P190MB0953.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FwMRwJDwT85z/0psETM6gzAvonCAVS+N8R2U6tfkRrDx5yEKT+yDz76846FDY96tavcYxhaNZqu8/PIyLXKEX4dczq31SV+O792oISl6bwKTtsmYh+cLnap9soAW9t8fqFFDsnnohRFvMTrdb7SvnZSThTcelxOC8Azv3k8X4l2cNj1dNy1gO0CEgDJMKGVcq3rkbiEpeeyJBMtO7D5YY2MRBr92UYAgaW9msWdQdmdT/R3jKqHLPAdKQRL979ylDSh4PO5MbKW1pdDWwDzLKFyVYIGAKCDR5J/OTHIr9Xmz8K5MpnF/k6Z/eRP+X818EKa0Hhj91ZEHzMZWdz1/kvKIJh10GdczFHGlYE/4bP1tQMjpp/rK6R81naRcrPljrZLDmFXDY3n6XXYpMkyd00AfobVuK4EchQ2w8PyhVWUb0o/VNfgpSNfiwnA9MbcKQ7UOCC1Sp7QZETr9OZQ4G9azpJKqAQ3NdYt16v+Wuh3lR9xT/xo842IKROPj+04maF8QTbOsF1mDELFprAVXNPSO1+++NDcTFyM1I8LhYtcBNXN4uFCftjG6P0NxS8Ws2J9OwArlMva+0p69n2/bhso1fdMv9MCcqM4nzdR8e0YJjTB8iags+a0CRczMau8r0jE6jPgc9AOeaKWz5weJhfPpSD8A0LB/OOjYsmxeXNq1Xkbk4wXwaW6LBoUr5tv/7BrEbxncVCR6/ijgMGt+kA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4P190MB1390.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39840400004)(396003)(376002)(136003)(122000001)(7696005)(66946007)(64756008)(38100700002)(186003)(6506007)(55016003)(2906002)(33656002)(71200400001)(26005)(83380400001)(86362001)(8676002)(5660300002)(9686003)(316002)(54906003)(8936002)(508600001)(76116006)(52536014)(66476007)(38070700005)(4326008)(66556008)(110136005)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gdyZ3x3UQKp7YvZcdRMgsFc3bRFjJQ988HFi/ujT++iACyt+hKupPUfVfx?=
 =?iso-8859-1?Q?po6Uoy/YcHELj/wabVslnSD+9wyq5S3H7ylm3ZjG2RDDaxM20G4ZC6i5dh?=
 =?iso-8859-1?Q?lpdhmFT9H48GSF++q+t5it3xuBBQhykviFZ4MYomDicuso+jqA7Qlfvzp7?=
 =?iso-8859-1?Q?rlcmfDpXyh08mWZAHmiz8pQktEOikJZCMo6z858XfU7F00P4S44Iw+4noD?=
 =?iso-8859-1?Q?U04rluUnwkUtv36JYDQAcdQ7hegs0nLnyL39fYPTdK0j7eMvzI4uR+AhoK?=
 =?iso-8859-1?Q?hzgC6pQDUpPYgJq5kAh4x2TZ7570kCmEDCTrfeSBdiH0oEM4poOW5OUsPW?=
 =?iso-8859-1?Q?BLazzGYk5zAidexGyy//XdYWyChGal1bKi6orEkLAmvZXarqe98vIdQZm3?=
 =?iso-8859-1?Q?BRBFb9bi2dLaqTRi+k3do0wOGBkHJiScQIndJ44o4Nl/l3dcVcBUMSYtJJ?=
 =?iso-8859-1?Q?aks403YOVLscauOIX97IdjZCmiz6kxofO9lq7rWnAb29QpT/4oxyxO2mL6?=
 =?iso-8859-1?Q?Pq93VUd8u50mPJ+4Qdo6870tJ7Qvzvm52Ms0rNZxebNW4rgFzBTPuIHYpe?=
 =?iso-8859-1?Q?+UuU6bghb+uqoerMw+IF3pah8+cKsx3OOYY+AVL/DJbYYWZR7odW+uGuzR?=
 =?iso-8859-1?Q?rVhZdYXGyo3l8j60sHkGbm0Dlu52RXNJgNs4smDU2+NDQ0KoQKt12ioFQB?=
 =?iso-8859-1?Q?Ujappv0vbnYMic3UrBi/8EOQB7eXsA7aECQfAcxtQhQcae67E4whR7+5Uf?=
 =?iso-8859-1?Q?A6SvvL7aTRLvrVKYDFePPtOkV1XHUTsI4CCQjYGJoj3yQXYvfulOdMY6YB?=
 =?iso-8859-1?Q?e0iVOgIZ0VDspCCXKSDAbK46H9h583qMtrqwuqNwbH37JKCIL+G8S9hQI/?=
 =?iso-8859-1?Q?6zkq7f8KMBwjJFyG06KFETe6SlgQAdo3CGAVq4DpS8KCYFgG5IcVX9RJe7?=
 =?iso-8859-1?Q?U3N6WWuMA6zDv+sHQcJXN2e4mzWcYNeayKH+c6aG6MflFvpfLARySbLY37?=
 =?iso-8859-1?Q?d4d1ODlVivqsJiJTnY6SuxB92jG3KEtoycldNguXXaADTn+eWzjZCQyQ7u?=
 =?iso-8859-1?Q?8YJZq7w116E+7MF7BTMj7fPOYULzVyzhkYb7xPdn1fM1Bc+6TYLCTVpDUj?=
 =?iso-8859-1?Q?af4ZAxY87QnxZqpfdJTaT3ofv8eNnIUTk06zsPzAaRptR84EFEBg13esWX?=
 =?iso-8859-1?Q?nCCxdPZUZuHHsTKgXehYUYiCcUwXQezfnEg53JLjJiAlOqaWWrz9ha/+pu?=
 =?iso-8859-1?Q?XZ7AUrBk5pVGaETgfubfAGe1BDBFBVzArpLl3VYdyxghhA29hZmWUkLJEy?=
 =?iso-8859-1?Q?GRWELItKhJD4jcibxZuYir1NFAA1AZ4oVxGtLGeTCtvyeHso9Q7J8MaiZ8?=
 =?iso-8859-1?Q?G806B5TrELO5Yo/7w5XYz6weE0UVfAnjt/Q84tugtR7oeZKJ3ICjaOUxdt?=
 =?iso-8859-1?Q?7y1jm80K6bj0xIghWVEzICUTAO+aLI81ShIn6NBOO8DFrmFKjyZ2q8Yx7Z?=
 =?iso-8859-1?Q?d/vWpHbK0/JPoE9H4Uc2EUEb0WnaGOzCUbtNuPLMUP1M3zcSNYfDR9S0YW?=
 =?iso-8859-1?Q?gfKt3+dgJT3mcOYwyUOfM3/4e6aMbyr/1FYcgqD/bnTRyDd8qubOx0mnkB?=
 =?iso-8859-1?Q?qCuCK/izGT5q/jC3r29VSRKar+rv8b2hSA5mYM0mir9FNnY3bcyxrb9kYg?=
 =?iso-8859-1?Q?UbR6IVP/38/3spXbkX9gODYMmC9mk1HlQBl/Ns1YQ+W9Gbs2R7e+4Ti2BC?=
 =?iso-8859-1?Q?Egkw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: schleissheimer.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4P190MB1390.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 24171cfa-ebb6-43b5-b2e6-08d9bb057136
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 11:17:09.7183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ba05321a-a007-44df-8805-c7e62d5887b5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OzdIMjB1G1nZ8HBUbsKMIxBYtjlwEnjwjF4dN9yKjCyIdva5u8T5QGi7+1Ukg2yEhA4HlL9ZiuOeXfsq9roVzoqCooWMmxL8UWcRv0lO3K0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P190MB0953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

we are also seeing the CRC Errors in our setup (rpi4, Kernel 5.10.x)
from time to time. I just wanted to post here what I am seeing, maybe it he=
lps...

[    6.761711] spi_master spi1: will run message pump with realtime priorit=
y
[    6.778063] mcp251xfd spi1.0 can1: MCP2518FD rev0.0 (-RX_INT -MAB_NO_WAR=
N +CRC_REG +CRC_RX +CRC_TX +ECC -HD c:40.00MHz m:20.00MHz r:17.00MHz e:16.6=
6MHz) successfully initialized.

[ 4327.107856] mcp251xfd spi1.0 canfd1: CRC read error at address 0x0010 (l=
ength=3D4, data=3D00 cc 62 c4, CRC=3D0xa3a0) retrying.
[ 7770.163335] mcp251xfd spi1.0 canfd1: CRC read error at address 0x0010 (l=
ength=3D4, data=3D00 bf 16 d5, CRC=3D0x9d3c) retrying.
[ 8000.565955] mcp251xfd spi1.0 canfd1: CRC read error at address 0x0010 (l=
ength=3D4, data=3D00 40 66 fa, CRC=3D0x31d7) retrying.
[ 9753.658173] mcp251xfd spi1.0 canfd1: CRC read error at address 0x0010 (l=
ength=3D4, data=3D80 e9 01 4e, CRC=3D0xe862) retrying.


Sven


> -----Urspr=FCngliche Nachricht-----
> Von: Thomas.Kopp@microchip.com <Thomas.Kopp@microchip.com>
> Gesendet: Donnerstag, 9. Dezember 2021 11:22
> An: pavel.modilaynen@volvocars.com; mkl@pengutronix.de
> Cc: drew@beagleboard.org; linux-can@vger.kernel.org; menschel.p@posteo.de=
;
> netdev@vger.kernel.org; will@macchina.cc
> Betreff: RE: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): =
work around
> broken CRC on TBC register
>=20
> Hi Pavel,
>=20
> > We have the similar CRC read errors but
> > the lowest byte is not 0x00 and 0x80, it's actually 0x0x or 0x8x, e.g.
> >
> > mcp251xfd spi0.0 can0: CRC read error at address 0x0010 (length=3D4,
> > data=3D82 d1 fa 6c, CRC=3D0xd9c2) retrying.
> >
> > 0xb0 0x10 0x04 0x82 0xd1 0xfa 0x6c =3D> 0x59FD (not matching)
> >
> > but if I flip the first received bit  (highest bit in the lowest byte):
> > 0xb0 0x10 0x04 0x02 0xd1 0xfa 0x6c =3D> 0xD9C2 (matching!)
>=20
> What settings do you have on your setup? Can you please print the dmesg o=
utput from the
> init? I'm especially interested in Sysclk and SPI speed.
>=20
> Thanks,
> Thomas
