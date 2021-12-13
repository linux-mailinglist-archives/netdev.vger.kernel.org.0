Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8D7473746
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 23:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243463AbhLMWMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 17:12:52 -0500
Received: from mail-eopbgr70109.outbound.protection.outlook.com ([40.107.7.109]:55751
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240321AbhLMWMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 17:12:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZklHodCJ95j0gYJjLPm5xGo0fFUVEFROP8xoNQuTj4t0PrGKiAsNdCf4BlcsoavbajfTclWgjVMRhm0lNvpbczGfXPiAk0RjuJK8wvA+WyOA58yG27cdLg1nP44r+69S8P9SMPWYpHyd7cZx9Yw4+tEgU/zotB3/JnR8USVOo8fmfIS+6Cg4p/Zg7FiahjNPP5xHEcRi48gUfNCb23qjmFnyWxLjDxvTCTuVLAPRD2b278iE2xYbDcy6puZCvWTa6AszfI7vcAlb+djNAfCd3J4c27izzuHjNNkjLhQqJIJKzc5+MtWwdkIt3hazI377cAUCCZu18M7bpecCoTzNdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9bWqqG6WxHZVUTXi7doKFORiLSmS8e18I8Elto4gELE=;
 b=K7BLe05vsaFCCzOdLKL1/28Bn38u+Z7Alhw86cTOyAWJFlJw+W2RCbY2P7o4pAq9uiNLDkI75tpDJGbb+jrHPmyFtKo5D5UsgNhDdShSDibloGzBkvSi+H5AY+NIpiWcPdOe5WIWlpLKb9YMs8pi6XDQBfP5T74uKlRufCp29mnMcdznWPtm8J6dPRjUlBUdY11Dq/poctqClpReZ3acWnrwflt9AQJ1F5goIGEoz5ydU9Wyd9wATWyQeVfnqmra8Nr0fNxah9bGQCMv84RT0Gx+E7EBW6msa51xf4anyWyCqpKcK28Y9qdVld2LHyX5Dg70FS0/QSH1kK/xsLgtdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volvocars.com; dmarc=pass action=none
 header.from=volvocars.com; dkim=pass header.d=volvocars.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=volvocars.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bWqqG6WxHZVUTXi7doKFORiLSmS8e18I8Elto4gELE=;
 b=ebv9IPC9CAU96DwUK/Rhv9qh5oDkGJg1kE30yWTKlRIcYVVVTi9j+7ZfhpLc4SMLcpHcPxj4hMIeuic/kgGLwIj4O6/FxtPIMUq0CjopJcyCaoS7nPOiuL9jL6JwhjU7YJ9BUgS4N1u9JjjbfcznFgMTSZVSn8YP+NA6yKAL2cQFX2hPTERTq7Fjs+LINt3Zp1sIChTWlD/L3lxafiexsdLKzshN2DNoo0bWFx7muL7s/VwC1QHFcvcwfQORCc7mCoa7bfxR4LVZuits60HoGSvrgiUgSUwVK7k9bya27PAfPzT55JNsJgG3T88PW9WWQzB6Wz5MlLlkx62r14uGqA==
Received: from PR3P174MB0112.EURP174.PROD.OUTLOOK.COM (2603:10a6:102:b3::13)
 by PR3P174MB0110.EURP174.PROD.OUTLOOK.COM (2603:10a6:102:5b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 13 Dec
 2021 22:12:49 +0000
Received: from PR3P174MB0112.EURP174.PROD.OUTLOOK.COM
 ([fe80::11e1:ae68:3684:6804]) by PR3P174MB0112.EURP174.PROD.OUTLOOK.COM
 ([fe80::11e1:ae68:3684:6804%6]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 22:12:49 +0000
From:   "Modilaynen, Pavel" <pavel.modilaynen@volvocars.com>
To:     "Thomas.Kopp@microchip.com" <Thomas.Kopp@microchip.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "drew@beagleboard.org" <drew@beagleboard.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "menschel.p@posteo.de" <menschel.p@posteo.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "will@macchina.cc" <will@macchina.cc>
Subject: Re: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Thread-Topic: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Thread-Index: AQHX63m5RC9thyxmT0S34SqWhDegYawp9YdggAADTb4=
Date:   Mon, 13 Dec 2021 22:12:49 +0000
Message-ID: <PR3P174MB01124C085C0E0A0220F2B11584709@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
References: <PR3P174MB0112D073D0E5E080FAAE8510846E9@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
 <DM4PR11MB5390BA1C370A5AF90E666F1EFB709@DM4PR11MB5390.namprd11.prod.outlook.com>
In-Reply-To: <DM4PR11MB5390BA1C370A5AF90E666F1EFB709@DM4PR11MB5390.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Enabled=True;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_SiteId=81fa766e-a349-4867-8bf4-ab35e250a08f;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_SetDate=2021-12-13T22:12:48.726Z;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Name=Proprietary;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_ContentBits=0;MSIP_Label_7fea2623-af8f-4fb8-b1cf-b63cc8e496aa_Method=Standard;
suggested_attachment_session_id: c493dd9e-675b-cff0-5ea2-efdd9be01665
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volvocars.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d1f4f42-ad07-4e89-e5b9-08d9be85b2e9
x-ms-traffictypediagnostic: PR3P174MB0110:
x-microsoft-antispam-prvs: <PR3P174MB01104991B2ABD864B87A184284749@PR3P174MB0110.EURP174.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EaAwmQjCdpCXb5tOQr5KNmzotjd7Hv2jUKy7+olCtl94Tdv/NZED0y+FUEszCwpguyk3J9RTPFoOlb1RphuVehjVHJ57jyJ9f7INsTcagr6hz1p9zrQ9PlSJbCJjsUmM0n/m45d534rgw+VMF9aXAIXKC8gb1Qov9l1jL02EeSAXUeS27R5fYOQDoiUgKvFhwfByjT0+bhrjnglAGF0noGMpK1+3zSmPmqC4ThpOmVwNPvaUSHypapXm7jL378WkLjwv7xaXL4A6ow1l70uNQDqpiPz/M+j+25tRZBpDLCbrGXBYfHecXgnWwFs1yFyCOC0hDmriiT5eR113ALXjIJMERGNTVFzDDamPLnYzPM829IHkYPc3EyFdJuu6I0g4riQWaOMj/UKmninCQ1gbOQTm5TgkLc9VQCYzEV6KfN54jEW7/c1P4VkvgzEea6ufVLxbFRm7ji7Sj0zXS0s03nYSJEt9S5GLePFisHoa32xCQd9gGFooIm2x+NFYKQtIrOQiwuYKCGaf2YkibkEE8NiOxqDu0pD5/S3xWvLwpCDe8JTJI+Xrz7M8zf5C50N+jnvf3ixkrrB4fe5uYAWokTvxTgrF0sjFBEt662OD38PDv5hJhGmrRMMO2PhmLyHKPRr5iwpS1naHr0wTBdwjUH41tEQp6WD5eZNorKUshvHMSkWBY8AYbgD0cIX6D7GN8voYTDwkd2h1GRtn394pTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3P174MB0112.EURP174.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(4326008)(66446008)(7696005)(66556008)(5660300002)(76116006)(38070700005)(508600001)(55016003)(52536014)(4744005)(83380400001)(2906002)(9686003)(64756008)(33656002)(8936002)(8676002)(6506007)(66946007)(110136005)(38100700002)(82960400001)(316002)(54906003)(86362001)(71200400001)(122000001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?n/qti1NbzS9OQReq7rCsoeA9QlYUSzeKPNGSjWo/4SiVuQMRVOQtdq0H+5?=
 =?iso-8859-1?Q?mHR0KwHdjD3dHHniaRCvAwC+lPcMWP7yashLTBueT6e1TozT4RLF6F4sHE?=
 =?iso-8859-1?Q?6oH3qS3bNwtpMH5nAumj9jSHl6c2kFNnJGe5WQOVwB2pHkx7uKDwPxlOkN?=
 =?iso-8859-1?Q?Y+aX8v/nuQBCgXnCCHL26iu85P7ErkDSeBCeKclvT34UJ9+4e3pzssrGzL?=
 =?iso-8859-1?Q?O7FcL4HEO8VVrMmGp8hyuYnjgE+kT5Twbll6nij5IDTgAJKKzIhuuiTOC4?=
 =?iso-8859-1?Q?C/nKsVwQXPjfLsrR+Eq3hnOuYFyevVzbxdTqigyEYbVBGOYS4vy8rye8jv?=
 =?iso-8859-1?Q?/4Xzap0gHhxDWKJCtbaRyh4GLg+ZJjwVxtBb14Cqsv4FpklpsjeciWwT6o?=
 =?iso-8859-1?Q?4VRfLIgqsuHhvtTbeAHsGGhJliFO3Nj9GmvO9bXmAiufoUJ2VklMOq7DwK?=
 =?iso-8859-1?Q?5iwy5PohwXPIsQYrIaa6UyCW+lwj6xN8PCk0Msq7jc5Akv/2SnYraqQMon?=
 =?iso-8859-1?Q?MV2CHDafypLh1QHQ/72AlgS4koU0RA60WHjYMq2GX7dSNJnO+qun/OTldO?=
 =?iso-8859-1?Q?QDeStWGFnoKLJoZ3JF2pNcnSHzPRIZBeiBjZBdCDTYHiwR1qf1aTZY+4RT?=
 =?iso-8859-1?Q?dzKOuk+kPiF2gEZk+lxX9EWfEAHNsdOrw+m1XuTNtnqV8eD/tzg6J6S3x+?=
 =?iso-8859-1?Q?B9RFhpuoz0dNo6a5tNDF29t4lsDAK8UGucyqEwcw2SpDCOSeSlBD+OATfk?=
 =?iso-8859-1?Q?u7tUC2XQHrBbMCJ8ndXpXUbt5f5GekBmjV4XBlX85kx1U3p2vCZ8hkowle?=
 =?iso-8859-1?Q?QBO/5pDJwKZfqxr/KIM9oM/UTijJAJulPStfBcAnIyfvSY5l3/OEhfz16+?=
 =?iso-8859-1?Q?UeOpCt2WHPAi3QnF+KvoiMq13j+jRYFTL+ELB5eJiOXFt0ejNvYYjNDVsY?=
 =?iso-8859-1?Q?UyC5w8Ooq2jY1RdMhe+bsmM6kjVIQFaQsHfgn7CdiRtQm6KCgvnZLi5501?=
 =?iso-8859-1?Q?jqQ11ndIkSIfSQKmwvfwiDyXn7dtYH3tmftF96OYupMMh7z2YookaEVXn9?=
 =?iso-8859-1?Q?YPDIvjh3M0Tqox3xPqcJCXH0711n0ceVneJoj624iCXuA2KByC9jXq3TJz?=
 =?iso-8859-1?Q?U1dNVQYgeakDNCPXtC34q0CZCV/bXnilMnij+t8fKRgF7am2HpumsvwF3Z?=
 =?iso-8859-1?Q?fQLpBOUDgEn61+Sc2kMtxv+VotE0LpKEqz1+Td+yd1tAkKPyn45DaWbeaK?=
 =?iso-8859-1?Q?qrrCeCe5ZAOVTuZQ85GLMRASE56+xl0NAetRRE/49vrVUsqWHQ8qwH87+p?=
 =?iso-8859-1?Q?9AhIK2NVgBcIz4+U66n4RG+c8NnE5vgepreA1LbTdx5fIyQHGT9FajpJYb?=
 =?iso-8859-1?Q?rpd5zV9/B84uRfnBZyP/9PZ4CzyQI8KRX3wKXXNFfPbK8XT4Thg+EKGXZj?=
 =?iso-8859-1?Q?biSGfp2fh7jCOC12QDVDSQM9ggqrdB0wjtHHVzPLWXg2HrX5eFqISG1KsM?=
 =?iso-8859-1?Q?uuTSaSaxnJZJj4jYFY6NQSMpj56g7IkGvffOqnpUqVqO3RxzesrnEKfQ1e?=
 =?iso-8859-1?Q?3gnlxGv4aL2elEAxE1PGF0q4mRnh7sO1+P34tqV8L2op5u5OHkuSM8+sjD?=
 =?iso-8859-1?Q?gHj0WTzPz4GSS2TWrKKOo7PqMSBI8WtXN423n9iCR83JbuBPUVmynQOoKX?=
 =?iso-8859-1?Q?kxJH6jsNmmR6UkZVKmYrD/sZn//rvyxYoFv5XaTdJ4iSAV3ZQab7SpczEp?=
 =?iso-8859-1?Q?GlI0ULBux6wNDkBuhjQaXqIic=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: volvocars.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PR3P174MB0112.EURP174.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d1f4f42-ad07-4e89-e5b9-08d9be85b2e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 22:12:49.0611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 81fa766e-a349-4867-8bf4-ab35e250a08f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FI8VTEx16n7OsIQFv6QaxcsJMtMdQTrHtOv9KWMDL1BwF2QMF9J/hVOjwWYcnPE2fbe21XEeY9HjAkZB6QxNow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P174MB0110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,=0A=
=0A=
>=A0> We have the similar CRC read errors but=0A=
> > the lowest byte is not 0x00 and 0x80, it's actually 0x0x or 0x8x, e.g.=
=0A=
> >=0A=
>=A0> mcp251xfd spi0.0 can0: CRC read error at address 0x0010 (length=3D4,=
=0A=
>=A0> data=3D82 d1 fa 6c, CRC=3D0xd9c2) retrying.=0A=
>=A0> =0A=
>=A0> 0xb0 0x10 0x04 0x82 0xd1 0xfa 0x6c =3D> 0x59FD (not matching)=0A=
>=A0> =0A=
>=A0> but if I flip the first received bit=A0 (highest bit in the lowest by=
te):=0A=
>=A0> 0xb0 0x10 0x04 0x02 0xd1 0xfa 0x6c =3D> 0xD9C2 (matching!)=0A=
=0A=
>=A0What settings do you have on your setup? Can you please print the dmesg=
 output from the init? I'm especially interested in Sysclk and SPI speed.=
=0A=
=0A=
mcp251xfd spi0.0 can0: MCP2517FD rev0.0 (-RX_INT +MAB_NO_WARN +CRC_REG +CRC=
_RX +CRC_TX +ECC -HD c:40.00MHz m:10.00MHz r:10.00MHz e:10.00MHz) successfu=
lly initialized.=0A=
...=0A=
=0A=
Regards,=0A=
Pavel=
