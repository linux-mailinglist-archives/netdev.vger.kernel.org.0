Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BE1458540
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 18:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238304AbhKURKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 12:10:25 -0500
Received: from mail-eopbgr50042.outbound.protection.outlook.com ([40.107.5.42]:50502
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230330AbhKURKY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 12:10:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xh/snVoCpsfa4skNWrzB2tbhF/V6O41n4fNN4AiG/e2ipPZg64m1J9wnLDx+EDzbGHnf9tzh434QouOjfuBsrgQc1nqO+cCTcZchZ2UodDCOzWHf1BKwbiRDzprU2UHhZZsglE4FodDObQ7SxdD4CQrWXHTT0MXIC0XpQV0TJSUyMyB9UiXfQz23QE9SzYhEdTryVwRGK/sTMi49LVd+RjgoNfm8cxEbeHeM++QCmSBT78Ho5IHBxvi6fUhjoz2Uk/v+Gy+QiSilrVO7MXvDNcouRiAZTIKoeRVLFfKuGS9W/YXOdA6dhGLv6VG77lQjthaWz0xbQEdiJqbM0eyBWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZZbe0pjdECpUMmPJjesic/SbEEB+8477TAxfpuTQdk0=;
 b=NW61IbxQqCZwM9moipCRsa1Cf/siyyzTTjTbO7pLa/DM1ai4LxzhsuC+YnVCn3nEpS4UMI7SDZDVF3Nl/2QtRrOviP2qlZIC8eTwUZwkZM4s1XgHwdLPkb0dgpQNowwHjX5xmeN5NC1KH0NsSKWYvjup4p4cJPAJv2rb0IOgEVZ694MhCEMC8HtCFuowSjK9NdnJCbCsvSXUSSR8QRrxzX5OOoDdlSXZggsuCGv1oqYcrnETZAlUgHrU9gwp4hOa3bdXpe5B4wzH+PRSkLIuNjrFo0Q6J2tm/ZCu27OkKS99VnSGCMXFFwlh8V893sKTZRUXWcJfiMWrsAa6Ug0VcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZZbe0pjdECpUMmPJjesic/SbEEB+8477TAxfpuTQdk0=;
 b=Jogh+9a8KgSfxuq+M4b05Uv9XVe6XlCCZ8Z0P1rQdnISFjRx40HDAJP9Kpv46R4k/jJUbbnHhpMzWJ/4zKOAP7/7mhVQHRO21BoPCLt0XhuCb+57xKH2Kd4uTBGu7472IjjKnoFxJ2nb0bGOWxQujFnfH2WzcHP1q+nvzrjP1mQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6943.eurprd04.prod.outlook.com (2603:10a6:803:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sun, 21 Nov
 2021 17:07:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4713.024; Sun, 21 Nov 2021
 17:07:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 6/6] net: mscc: ocelot: expose ocelot wm
 functions
Thread-Topic: [PATCH v1 net-next 6/6] net: mscc: ocelot: expose ocelot wm
 functions
Thread-Index: AQHX3ZbijsqTM5sy70WhaK65YkMIuqwOOUiA
Date:   Sun, 21 Nov 2021 17:07:16 +0000
Message-ID: <20211121170715.mv5434lsdguq3jmw@skbuf>
References: <20211119224313.2803941-1-colin.foster@in-advantage.com>
 <20211119224313.2803941-7-colin.foster@in-advantage.com>
In-Reply-To: <20211119224313.2803941-7-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b02ad639-6a07-4143-8a49-08d9ad115eb5
x-ms-traffictypediagnostic: VI1PR04MB6943:
x-microsoft-antispam-prvs: <VI1PR04MB6943014BBE4B6E7823DC962EE09E9@VI1PR04MB6943.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: prZ3aHPtgG4lvVevhYvDTeCPrQ7IObOpzxmR5FT9mC3umrz0TdZO6J3e9+m3XxxSQfBxwh+BDaUrbamCEblRCtpJhHkTPG2C2IfUbecEQzm6tcsvyWSrqoXs+nfCoWTwCw8zZ22EVBKKrMANyyvkDs7KOnxGYWz5bGT+TZ+iEDcBNSGpSRhnEMlYKekM2w8fkoebjFwZdc62Ag2zfMosQqAbBwHaimtRbMR0loMeYlfuzs6yfP7SB638rka/8Uciutdewzg6TyTN41sRmSATB2yqwDwE+FYQAd0IsHiI3snpRUu44dhbrpCR2Wu4mGsE6s6XHiWdD/Oog/dFOKc4VKZs27S+tKopd3QLysQWdfD7M+FOIvJyvb1U1vfGqq3OUlerHH87BmnI1iZiHvv6AONK+UUswHExn70a8+dfKn7W8c5vg1XuaN5d2Vxd76NtQDEMRKCH3Cmo6nDlr0A8xp/nzaPWV6zYe6MdfKx/1nrYeF/5Ar9EAQVKY5LAuy+kwBox1I/BdZc56ECp3RsDFfbBBrtkTZ/uF9T6pdtbQC3LtdeTp+3v8uaA/jj3C27MjTOzx7ArW4RGozZhReeC8DjySmRKqkan2exTbZNL1PbCEBgaSWakr400PHY8mcKPcuP9J+qxES379YZz1D+ZaRVMXlVwUBJv+tWV47d8F1meZlPPsZMqgRRAspk1PsLQkvE5bzHFw3TX1v0z1UAyEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(91956017)(76116006)(508600001)(44832011)(4326008)(26005)(6916009)(8936002)(6506007)(54906003)(38070700005)(86362001)(8676002)(2906002)(1076003)(66446008)(66476007)(38100700002)(66556008)(33716001)(558084003)(6486002)(6512007)(9686003)(7416002)(66946007)(186003)(71200400001)(316002)(122000001)(64756008)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z24IQaSwTW0Br8Y1sPXeDmr13HIl/d69woWyE1SkoZJAJBBE+eEfMdUNhjUg?=
 =?us-ascii?Q?xJYnm7DGmseWrV/IrveMrot7DRicHvYFtaTeq6plb+QWxLiUulNQkF+a09aF?=
 =?us-ascii?Q?tTPlpEys/YXedQNvH1G3oytZs7RwJA2WP40VysnsQvrmresDRpzf5YdQ1nsG?=
 =?us-ascii?Q?+JLj5wrjz9j3Sn8Q0ZYB44Zni8qzwcKlOiO75Ns/PTjsGyonWiNC9PlMRcKB?=
 =?us-ascii?Q?QVedOGuDH6ADPwd3Y0t2LMekSKHoivmP7XwEYwMbXnBLvlS3cpaLOP950iSI?=
 =?us-ascii?Q?kwEu1v7O0KHAkS01QJuTUKSEb6X+0Kf/BUhIAvkKDrYR7HMXselFa9mv+7qp?=
 =?us-ascii?Q?uFYQ9uqRDpcESePJ8H73isd07gW47ruMVwbj7PW4cVgiU0l/+uCoLHQB2LTV?=
 =?us-ascii?Q?hIXNnyDXx8xlrxVMYoA2z6Mj985q3XKg24jFgW195BDRonicYzkklBRZzQRm?=
 =?us-ascii?Q?YKt8SjC0ehlty77NOpaMtflS0Y2ZTMKL1SgdtErJYerWx7ebrntq5z9xAS73?=
 =?us-ascii?Q?EQ9lvJsSBzuEO2L3wkNvxzVbYgHQu+t2iKNujvR39bCG4ySbM3/x8nVYD95A?=
 =?us-ascii?Q?J/OoS8DiYYU0sPCAODYXeL6y/WPO16uRs6DUMgPk4gXxRGMfyMaV947mwJLX?=
 =?us-ascii?Q?k5exGP2oU1Ss9uFFYKMquY1ShuEuEFL3r7fzKnjUcRcyUDD3c68j1xpZ5bSo?=
 =?us-ascii?Q?vJWhDO/5u0CfEkxM5cFGpHWs/QkiIMOrKkmRktIOztjxOw2+LRr2figOjzxW?=
 =?us-ascii?Q?G44OIhfA9Iz5UFEPoCwPkgqlrc+AVj0zqyJlnTqmxqXhE7gTMYmEdKNkB2iL?=
 =?us-ascii?Q?wsaBuHZj+bib2agBwd2w1MY+ibzIbtRxjVX6YWy8OC4N2NLuW+LjWDgxTJGJ?=
 =?us-ascii?Q?UUXlUTb3R1WJZ/HPfbGV7sax+IHWB8fuZYnOZ6etPLyJ2EEnLN6/uRbyz+KO?=
 =?us-ascii?Q?6JGbtg5VkET3rp8MZ1wVr+I0XjkqntNDpXG1JYVuLvCAPBmaeOlVW3awfR/9?=
 =?us-ascii?Q?Vpqw0oHQOZ52A1z3rH20YrRDl7wIP2uamzo0vhubpll6CPvun9z7gioM+zj2?=
 =?us-ascii?Q?JFcNs3POC8O4SG1nimapf7Kqjl/IWfPAAVJziwV1LvX/ANqq7WA2sQF6PxIY?=
 =?us-ascii?Q?pPxzFwUhHd9/TAQaDTHh3qqApOU1VcJrffT9XGq1UYTdl6qVdfTUnwOOj3ZJ?=
 =?us-ascii?Q?ALq5gPCLJU3KPzDdkMrJNGjrKps527Bj50ZGw6CM0X4dtIAIeMMmBWQkrzhV?=
 =?us-ascii?Q?gUuDQetM4WvilNy3KkskNpru788gw/1r/kTKCBv7zcHRGgXFGQAo1kDYFSrN?=
 =?us-ascii?Q?bHtXl92zp19l42bWz8BNQtGfS0JFlB4GerCAm2vTzcKa/lQJ2KmoD0hpJ8pw?=
 =?us-ascii?Q?kdaHrP492HKqeCnlYuBQ8oe5z4cqYXJ22JGevetNfHdkYI63+U5n9A5pnFYu?=
 =?us-ascii?Q?62aXReBc7TDMdBt5GKakaMRT3htsqfTQOlOTKX5Uoh8wHD1TXbK5qBnPdLfe?=
 =?us-ascii?Q?51doT9HFtk0wYWKaRb++q2khoaA2zKz9rJQDFypaNYQ4vWoRReLUw1D0jZOe?=
 =?us-ascii?Q?2MYEacS6c6/AGMz/oPB07ztOxTl2N3apJH93HLlF9ogLTHiMnathATxC7jit?=
 =?us-ascii?Q?K4a/OfhVbLqZQ5I60tnWi/Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <80DF656778F5FF4D9D60CC53C1D7EE2D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b02ad639-6a07-4143-8a49-08d9ad115eb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2021 17:07:16.2372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cu6AmS2/bzLRyWwdR/ZLHFfJVMo/b5K04Ud71MzasJEDVGmlhXKu+V1Qg1Z++Ty+2Kf2W9zcXQVj2SdX7tVGmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 02:43:13PM -0800, Colin Foster wrote:
> Expose ocelot_wm functions so they can be shared with other drivers.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
