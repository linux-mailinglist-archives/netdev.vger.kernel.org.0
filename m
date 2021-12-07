Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7CF46C10F
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 17:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbhLGQ4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 11:56:45 -0500
Received: from mail-eopbgr70138.outbound.protection.outlook.com ([40.107.7.138]:12143
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235127AbhLGQ4p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 11:56:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8pTNBWVLW5Ik3ZsSDfU3vUWjk0yA2rFNotI6dWjH4PFEDEGRZm/Cjg/o+DDvMs5Hn5vggdq9jd6mctuR7f+/RyC+n9mUfm863vJHxt3iSGDJMTuz3DF+Wtk7gbu7vb9kiDH1OliX3SsJ7xsc6Idd1LkqJK7J7D/Sc/wrYJJm9r/9Ng65AbgO5N7Ph6D/NVoAoqRElNOvn/iKXs2vCwEEsmJhFGLmKSyk/j8ueBROQJ/7P1n/rLKj3ZK+7bX3IPcZTGBDHVEhklPLgr1cif081OEqvHLNmEvOo9w+AJ+hH8LfJSE0urHDE6/coOB7z27jgrlke0f7bYZ6SDko4P4jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rD0NqD/D6T7oHPAdPaUVLEVN7usoXUtRsOxtg0ebSgw=;
 b=UvvihgO0mh69vPkAE2yH7LIxh5wuAZv/TLTw7VAOrVpUaD0XPinNhBY283mIEf9WSJafi0fp3QK2y50PUNFY5CjDITHd5oXpVfBbYkCEucl3P2QT44ym1eUtfD/rBb4kpFg4Gx53yea+kcS6I3Rf4JYmCrMYg2HFPXzRtMbNiERvgWZVWNyXPlCe7oj4+UaHset3ATRhtS2e5bhJMw8VaRf7PIqpdG739Wdpd8nqt95VydbHa1JlibRcCyAt+bFgpnhjz/9yGha1GhUA/V0MbkJk6O42D3Bs8HZ8M+5uQTxRvW8KAMEqj/sFPV2VJX15Yto9JEg/7ON31brZaKrWHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volvocars.com; dmarc=pass action=none
 header.from=volvocars.com; dkim=pass header.d=volvocars.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=volvocars.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rD0NqD/D6T7oHPAdPaUVLEVN7usoXUtRsOxtg0ebSgw=;
 b=oSoleL9jXymNqogeI+TJBpxp9J/N8gKBfXuE6N0S4bkxddbNhzpjRO/SARPDFNqzNbm/Nx94cfmu5PKNcnoTrj4dTNusOXGbQmhzmiQg1ZbX1uYDB8BudsalOgJ9QZuKFAAJQBR4hVC+1va0MQd/c4U0MsyjLLiy2Y3N5xhu5sZOmigeCroS42jNO0x4ys6jVOhdSDgyNO80dHtr1JR936PVu8bjAPglC54Tq7JMLv+BrKFXlhXvy1vc6LC1/Pw7BcT2jBCT263fJXiQz07eZ4UXv56pqHiG29dPmBYFlu6wdVIbgiBFK1emuYMda+HFa957QjvBeU5KbxjZRoDSKA==
Received: from PR3P174MB0112.EURP174.PROD.OUTLOOK.COM (2603:10a6:102:b3::13)
 by PR3P174MB0109.EURP174.PROD.OUTLOOK.COM (2603:10a6:102:b2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 16:53:12 +0000
Received: from PR3P174MB0112.EURP174.PROD.OUTLOOK.COM
 ([fe80::a9a7:347a:5f6:d928]) by PR3P174MB0112.EURP174.PROD.OUTLOOK.COM
 ([fe80::a9a7:347a:5f6:d928%2]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 16:53:12 +0000
From:   "Modilaynen, Pavel" <pavel.modilaynen@volvocars.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "drew@beagleboard.org" <drew@beagleboard.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "menschel.p@posteo.de" <menschel.p@posteo.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "will@macchina.cc" <will@macchina.cc>
Subject: Re: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Thread-Topic: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Thread-Index: AQHX63m5RC9thyxmT0S34SqWhDegYQ==
Date:   Tue, 7 Dec 2021 16:53:12 +0000
Message-ID: <PR3P174MB0112D073D0E5E080FAAE8510846E9@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Enabled=True;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_SiteId=81fa766e-a349-4867-8bf4-ab35e250a08f;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_SetDate=2021-12-07T16:53:12.130Z;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Name=Proprietary;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_ContentBits=0;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Method=Standard;
suggested_attachment_session_id: c465ce89-772e-a796-0bd5-fb2c5b5f0aac
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volvocars.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71dc2736-bdf4-4ef9-c773-08d9b9a20e31
x-ms-traffictypediagnostic: PR3P174MB0109:
x-microsoft-antispam-prvs: <PR3P174MB01094662182115571E371154846E9@PR3P174MB0109.EURP174.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qD/KUXOUBZtHbbC9gw6/MmbTRg3HP8kBVaioOGHN/NNZp8WBEhzJAAVVRXYN2t6Ir/Y8Wm1/DzH3IN6RA1mNg2zzh786ySkKrfo2gdESxI1qlfr+mJMuZu4wqUeZffTCdVsfQXyZmdje4xv0WlaouiQFjKv413jG+pv6xxLcCYKcttd3EN3snm4qgtwgQGqEqbKXmReFV/mgthC6xU8tK7WtVWMqKTvAe8khvVFxZmpzKK6NjiyW12z5coKiNX9rswfIhB4KzJdgSerFv3jg5PGkKE2OBKN49TGSU5QG7D0qTYCr8jWMCLzqOhj2FQufo6w/0Q1mvv3UrBLySuEIeg7dG1tjk/WI/UQJdwUVknV00B5RLFd+ABgM9I/RIzy5b0lvxDGGYG1kYmoBDdMaAxZuEl/NAGknbWuDM5PgY+379/3AdC4ETKIzdQDWHGksXvgi4MU9xB4nxfRKL2q2TyMRS7BEvdmVV800XvDvVaWC5OoaZqO+fIidt539rpCEF8az5SiTZDiNGQjTBKoyBD4JMg3EPPu4A7/GALdgVnvnHusGMm53Tg4L3swa1skhljPMXhpXMIb9exuA1qjgX+mcZraJyxONr6ihQIGMR+yU9XzRFc9gqv+pgWeIgmkdhWgpqh4IhDJn93BydWgjDzg4JnEKsoWWhGF0BX11i+fGMiAHCjik29YGilFaRTRW/f9KzJ0iwu6Xf/yBDpV/MY7RLtiWIVIaNaN2jdNcMZq7+A3x+eYxX90xjndVQftyjpXeuLGsUvkP1s/WSXoxr7SuoBKxT2c2vjQoXp+OoVQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3P174MB0112.EURP174.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(186003)(4326008)(55016003)(9686003)(38070700005)(6506007)(86362001)(33656002)(52536014)(54906003)(316002)(7696005)(5660300002)(38100700002)(122000001)(8936002)(2906002)(82960400001)(76116006)(508600001)(966005)(66946007)(64756008)(71200400001)(66556008)(66446008)(8676002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?F9rlzzrY51BxJrMcvFVZXs5ySslhtMw1I6s+wJy+RSXZwkGPjIUF4synmx?=
 =?iso-8859-1?Q?DcP13WlhCZ8G6OtAG8m+LZn5vKfM/7lY1NKerx1kimhQECc3M7RzBBrS9g?=
 =?iso-8859-1?Q?rCbmpMUUB5ikCDrI5CSU9eW7J+SSbB71HIrSgyNwiYpv2V+m1qEjQSJugS?=
 =?iso-8859-1?Q?FROI2382Innu5Ktp9CAvXncfeLwy3NqNqnEO649uTZgQETw73vBG14mKpH?=
 =?iso-8859-1?Q?/hn0WWel7HjQ/gn8oQQCVAivB6aTKJ1BSE/jMOLTDkHFljFjTZ1rtHv4gf?=
 =?iso-8859-1?Q?jWVHuYtntWmcSmHweo3N9nK6HUzLEWzcox4jrveIBt6gRaT+tLgaoj3and?=
 =?iso-8859-1?Q?wVPytDXcjygc5T60FWTZZInOTeISSLfS2FtBiLolwi7mU0vGg3HhuzM7OM?=
 =?iso-8859-1?Q?/WFM2ZtZIg9vPCFS+zjFyJWHy1Rn4W/ki7RGM2lEa5HPRqf+S0QWCe/pqS?=
 =?iso-8859-1?Q?wbd2G3mkEz/2EDvmelDSIRBXi3Uf/we8pfv+p8qF8/z/bRqbD+G1HNd0Ug?=
 =?iso-8859-1?Q?8UvYvwtSFLHde0YDrONDVImbJ0+VslwssTjlevwdAUPXUdCD31bU/jWw4z?=
 =?iso-8859-1?Q?EkdId4bhWW91dtviAJTV4Tl1yvfdBCKWLz+zXR8SOwU6fD3sWkOhS/0Eld?=
 =?iso-8859-1?Q?+Zyl5o5ELKBbCp1wsPDHCKWYhc7SCQBp2ELNw5ercnySZ6aFRHsXZgAFB9?=
 =?iso-8859-1?Q?n7ZDvYaYxTgpdkauLlO41Xpm5uDTkMv6oEWDowiESy65xUufkA0zQ06gQb?=
 =?iso-8859-1?Q?IIRUZZrQc0foLjX2itiBqP0NtLbgmvvHm2X09XkpFOTm/oxklRRz3RQWT1?=
 =?iso-8859-1?Q?205N0lXHusCD4mgWbtbZ1ra0V0jRMtd3JuT6BrgyYijLYObpuRSYdclDMW?=
 =?iso-8859-1?Q?+AedWY2pYg42zNU+oSUsyDMxnoRe6uBLLSOZTyyCdOH8RJ+dhrKIv1NUJ+?=
 =?iso-8859-1?Q?IaiQO85oIRVKQNWcHH+nZaD7fDSd/IrHla8mdsyqIbkTsHxp4oZkf2eI9o?=
 =?iso-8859-1?Q?vGLtmNbH6E5/Sum03FwW0c0gL22P4D3+VGxQyvphOtAsYsFutd4steakLV?=
 =?iso-8859-1?Q?PXieWpCwEU/xhmvEtGwCG9IUBEtQFurOUxwALGo9vtYtcfhRTU2hlBgcxN?=
 =?iso-8859-1?Q?+9rNNrOhXBQ87GJdw8L8XeG4uWGIXdeGleLejJDMsz4R5i0WWEVojp3jkV?=
 =?iso-8859-1?Q?vxLpKgKXYj5mr/EURvn6X5DmWl4kdQXrp/iA28xC9AWAW8VXeiZHDidfX9?=
 =?iso-8859-1?Q?vadzXoaeBgS3IwXbwbkubbCO6PM9APc6mwsoDdOG2clHyJWB4mbMd9oPC3?=
 =?iso-8859-1?Q?SfB0hYM3XUB0pKT00fBBf/vKGMURw6T6g21TMwV5ydohmKp0GQeedy+qCq?=
 =?iso-8859-1?Q?0YqaD6D80gAl5cjwoln4BYp7MWwNZmVAv2+UkuEBEsJKINduEB3xYSM7yA?=
 =?iso-8859-1?Q?eiJw4ELEIa4NlKuMZwGf8o9pchPH8UFhX1MAlKPYOZrXB2zL+wIQW/iEzc?=
 =?iso-8859-1?Q?HqxkYY98aJOO+K07sny0Z4faV/L90dU42l2pTzn8qgBR89YFT8tEdDimeP?=
 =?iso-8859-1?Q?X7Wz1cXltwD3jxD3X0xCFpoeTTm5e4HCGN8ui6uxYWNvGPECOVK/SXmthF?=
 =?iso-8859-1?Q?i+TYNR1fRAAY8RffVddlUrWQC5Y4jy1BWUjx/HPhVmOuWw3r9GtDasmhK+?=
 =?iso-8859-1?Q?oYEXLubnf+TttSGFAgDWTapff6n3Me0ghRm0XkSHAcEldMyKFZYBkp6BtY?=
 =?iso-8859-1?Q?qOpA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: volvocars.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PR3P174MB0112.EURP174.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 71dc2736-bdf4-4ef9-c773-08d9b9a20e31
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 16:53:12.2484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 81fa766e-a349-4867-8bf4-ab35e250a08f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fw8SWcPTtypmA9HgRJxjgUJl/eoT71T1Md9aOnFqPQhILAFQSurGjKtqC9wllQE1H6obfhi2PFC2/QkB4xQh4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P174MB0109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,=0A=
=0A=
We observe the very similar issue with MCP2517FD.=0A=
=0A=
>The CRC errors the patch works around are CRC errors introduced by a=0A=
>chip erratum, not by electromagnetic interference. In my observation=0A=
=0A=
Are you referring this errata doc=0A=
https://datasheet.octopart.com/MCP2517FD-H-JHA-Microchip-datasheet-13660904=
5.pdf ?=0A=
=0A=
We have the similar CRC read errors but=0A=
the lowest byte is not 0x00 and 0x80, it's actually 0x0x or 0x8x, e.g.=0A=
=0A=
mcp251xfd spi0.0 can0: CRC read error at address 0x0010 (length=3D4, data=
=3D82 d1 fa 6c, CRC=3D0xd9c2) retrying.=0A=
=0A=
0xb0 0x10 0x04 0x82 0xd1 0xfa 0x6c =3D> 0x59FD (not matching)=0A=
=0A=
but if I flip the first received bit  (highest bit in the lowest byte):=0A=
0xb0 0x10 0x04 0x02 0xd1 0xfa 0x6c =3D> 0xD9C2 (matching!)=0A=
=0A=
So, your fix covers only the case of 0x00 and 0x80, =0A=
do you think that the workaround should be extended so check=0A=
     (buf_rx->data[0] =3D=3D 0x0 || buf_rx->data[0] =3D=3D 0x80)) {=0A=
turns into =0A=
     ((buf_rx->data[0] & 0xf0) =3D=3D 0x0 || (buf_rx->data[0] & 0xf0) =3D=
=3D 0x80)) {=0A=
=0A=
Errata, actually says=0A=
"Only bits 7/15/23/31 of the following registers can be affected:"=0A=
=0A=
So, we could basically, in simplest case flip bit 31 and re-check CRC witho=
ut any check of =0A=
rx->data[0]....=0A=
=0A=
Regards,=0A=
Pavel=0A=
=0A=
=0A=
