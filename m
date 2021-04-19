Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744A6363BE2
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 08:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237560AbhDSGrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 02:47:00 -0400
Received: from mail-vi1eur05on2052.outbound.protection.outlook.com ([40.107.21.52]:12833
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233256AbhDSGqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 02:46:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbG+gJ+DPX1zzCg/C8qgg4ygTpzp5BGzQSoozOcogbY2gpzpbVLK6rTzl+IUMuVbHSYRCYV3feWrNE6t/dYb+OV7+S3y/nWqnZkz7uWEaM+X6pBe2JJV0GQ09QxSvuGChH9B8ROAu3/2aOtdvWIlIln90FRWZpgm2KmQ6O5U11IM24p5n2yhLm1WAr+UAVyqN4+Y4+EDSfkwGbbbfWxak1UBCOHvrE0QLU44j6i0uScL7M6xcMLa4/RkdoQBrYBhK8IcZKvPdWkf3yINUFKYgVh17wBOk2kFgtlmpya8jIUVJXMObmewpdLTcJGHMwtSILTUqZVyrtISn0NoSGdIQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/ekmCiuXpfdDZVhYbM3OJarFuVunEsDw+BeGEMho3k=;
 b=mtTNnVSGCwN+s2suWlHkfvgjXQ91e3RN2bziq819PR/rrvd0yX7KxMUK/+GteRZGVDuDNgMQYG+A0cAoEvP5LFrNB7kCxAoaE2Ee4NZa8KgG50fg3qYNoGxoAtZErAKgA7OBvgarzXCHonDI/HQvGZpDDPkpTb9Z73SBBgDxFV9CA6NC5sNkC/fjEHfHit0bQyXg1Sp4qkPZdDnQGSSG6vc10WXxew3A/J2ALsNXpcRqeZumDh6kkcj2tneQpKckny18ujkvXNA1bJoZbYQsxQoH2DD8GmbBKBWWNnBw6qVzedukAQlNt0J3XGr3j4NIA5PGYStM5p6sA/pstH/aVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/ekmCiuXpfdDZVhYbM3OJarFuVunEsDw+BeGEMho3k=;
 b=e9tcikXjb1qR7+Vbi4r+Ffh4kAeDuAITIQNnWetBTWZmZPi+N4nnOExt8Bq61uY57U9IjMEpuy01bHvDt7Aaxhs8PSF2QrkCHitKLhK01N6zQrsn8I+J+yqpaPGSPZl/2THjfz9r84iOZBnUgYxeEmdvQoDw8x32rX4FwLl9ubc=
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com (2603:10a6:20b:b9::10)
 by AM6PR04MB4087.eurprd04.prod.outlook.com (2603:10a6:209:4d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Mon, 19 Apr
 2021 06:46:14 +0000
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18]) by AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18%4]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 06:46:14 +0000
From:   "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tony@atomide.com" <tony@atomide.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "peter.ujfalusi@gmail.com" <peter.ujfalusi@gmail.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "robert.foss@linaro.org" <robert.foss@linaro.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "khilman@baylibre.com" <khilman@baylibre.com>,
        "tomba@kernel.org" <tomba@kernel.org>,
        "jyri.sarha@iki.fi" <jyri.sarha@iki.fi>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "kishon@ti.com" <kishon@ti.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Leo Li <leoyang.li@nxp.com>,
        "ssantosh@kernel.org" <ssantosh@kernel.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "balbi@kernel.org" <balbi@kernel.org>,
        "linux@prisktech.co.nz" <linux@prisktech.co.nz>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "wim@linux-watchdog.org" <wim@linux-watchdog.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-amlogic@lists.infradead.org" 
        <linux-amlogic@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Dominique MARTINET <dominique.martinet@atmark-techno.com>
Subject: RE: [RFC v1 PATCH 3/3] driver: update all the code that use
 soc_device_match
Thread-Topic: [RFC v1 PATCH 3/3] driver: update all the code that use
 soc_device_match
Thread-Index: AQHXNNSAr/U3xBWFq0aUS8skt1OGlqq7SKuAgAAbzGA=
Date:   Mon, 19 Apr 2021 06:46:14 +0000
Message-ID: <AM6PR04MB6053843FF75BCC8F4FB9A754E2499@AM6PR04MB6053.eurprd04.prod.outlook.com>
References: <20210419042722.27554-1-alice.guo@oss.nxp.com>
 <20210419042722.27554-4-alice.guo@oss.nxp.com> <YH0O1104YEdjY9mb@unreal>
In-Reply-To: <YH0O1104YEdjY9mb@unreal>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6906d7cf-de19-4933-5d92-08d902fed3b6
x-ms-traffictypediagnostic: AM6PR04MB4087:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB40877FE5ABB3E8ABC2F55EC6A3499@AM6PR04MB4087.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PxnJB4fOakDPC5VAW386/04kZOc479XgenjQD9GMKYnX7cqgyErPMtUT5qgzpqIloHfqrRfJEUzoYF5Qjhb0edBq8+bFWBOycr5zowtj5vsAtRfo+YYm3YER7MCJzS1WAXQdDb1JJi9ia7P7ebwTFRsLcLkfJjgsJsJDBJ5Y/Pq+Li02rPOOmzIfVuekfSyE5xBQhKuiUzRTfpYJ13anZaLL9iqd2U1V+DfoiHvViPB2y3fCsCSFyyFyyFmq9yXd4m7caSM6JhQHd+/Ltc7mbgWbNZ0hpQrMhq9UyxA7KDJ9WiVpWwgadsFlTDJ4NwX7BmcWolBeUARC4ZQ+Iu5jzzuwJ7BwRi6MlcUfgnOLuleViuL1WF/YCzeg1pwce1Gm0eHwQgBg+kC6PJ7gVnU42z7z4+cUWiJnO8KntysqdU2XwoP9kpbfpHtBNhxJtcsSRkFAPx5tnV56L7uWPe2Tim6s3xeGMTmcyS65U9Z/dTWWlFKOhKlyusMoHcJ/NWwh+gFISxra2z5SP0cQx+vJV0eVvXEDKahbZGCT0POb8e3fOazSlX+dtIra4XAJuNs5NxutpRtWiI5V6pLFszQY713T6Gv6uWI/Vo5QjJRrBbw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB6053.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(478600001)(122000001)(52536014)(71200400001)(7366002)(66556008)(66476007)(66946007)(66446008)(76116006)(9686003)(64756008)(7696005)(38100700002)(83380400001)(316002)(7406005)(7416002)(8676002)(86362001)(26005)(4326008)(54906003)(5660300002)(110136005)(186003)(15650500001)(55016002)(6506007)(33656002)(53546011)(2906002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?OFdLZXBSeHZndWg3b2w4bkRlOXA1TjQzRTVYUkhXT1l1eVJGenVYM0NDOXc1?=
 =?gb2312?B?bFZOV09UMjJXUTF4SUVDNStXVzJFWHA4ODFkRllTV0NJcXJFNkpoRDBSSG41?=
 =?gb2312?B?U3dFbVZhcTRnekdWS0RNRU44ejdjQTJ0VzkwVllhWEFnQWFKV1dCckFEQ01v?=
 =?gb2312?B?YlVzbmNXUjFRUEFweUZlSkNVT0MvL1hRSzBqQmpYTkxGN0JnUFhUMGx0TklL?=
 =?gb2312?B?SitsYUJySXlyUDFUY3J2ellLQ0NpSjdNaXpPblN4d1haSVpKMFFjTW5rU1Br?=
 =?gb2312?B?bjRaVkJVZXAzYlk2aFlBSjVRakpVaHZ4UFRnTytaTktDdk5lMzVxODdtTmtQ?=
 =?gb2312?B?amdJMlljNWNEUVlIdHBseld5UUtZZHlqdEJab1RHWXhOZzNWLzZsNDZ4Y2x6?=
 =?gb2312?B?ajcwNlBiMmRqazZ4Q3RZcHprOVB6ZVI4QUJVK25DR0p1bEpDODNXT1BXTUNK?=
 =?gb2312?B?em5BYXowb2FnaDd2NUhyZ0hnS2svRm5Fbm9HNjRKVndGQXpVWWRoZXg3K1o0?=
 =?gb2312?B?bURHY3JNYU94NlZOaE51L09NSm9vUS9RNUpXL2Q3aVIrUVNZZ2VCRTg3azBK?=
 =?gb2312?B?c2c2dmNhTGNKWXNEWU9CU0hiVjVEblNDcUFZRUYveWFHcC9mU3JEbklXWTdh?=
 =?gb2312?B?MEkrL1FUMUVwVG9sNG5MMHRXVzl3YU9DVExzVkwxVkxNaS96RGZObCtUaytX?=
 =?gb2312?B?R1FMTVhKMGgvMHI2RVJtUmpwYUpnRnl4UVVBbm1wVUYrRFRMWkg4OHFQcDB4?=
 =?gb2312?B?T2tUZlZlbDcxbU9SNmdGWFQwdk53L3pUTXF2MERaVlVLODRkcEZvY0NtS3Ny?=
 =?gb2312?B?VDluM0U3N0lpbkE4aUpKdFQ5VXQwRENEMmJMT25NSVc5ZDdoQXptOVB2cmQ4?=
 =?gb2312?B?LzVHSUNIUXhVUzc5NS9BNlp5VytjWjdHSkdPaXBibFBwc1NhS25JRFk1UThI?=
 =?gb2312?B?Y0dsSUoySStmT3RoRDBOeEtXRUdXR2IvSkpIWktoRjhsN1IyY2ZTbkZPTXQ4?=
 =?gb2312?B?TnV6MTd2YitqL0pvRUFWUWdublVXM3l3ZHJ0V2RuL0UyRmxwSHgxQmZvWVE3?=
 =?gb2312?B?bk1oYlFMTFM5MUlBY1V5UE13YlhRRjlJWnpRZ1A0WUNMTExRaVFMci9hNm9z?=
 =?gb2312?B?UUJ2T21uOENIRDFaTTM1eGEyNFZiM2VPRndaTTBxWWZ0bzRyNXh6TlZFYStW?=
 =?gb2312?B?Z1E4ZzM1dlU2cGZvZkZEZ29PSU1yUEdXN2JzVWVqNzNrbDFtSFhlSWZpODNT?=
 =?gb2312?B?b29Od1BOWGxxYVZ5NWVMRWxNS3BLVm1xU2ZHbVpoZXQrSGhwMkFBaVZydkY0?=
 =?gb2312?B?VTQwRXMzcUlWdElOYk14OGJhTm03MkExMExGWlJKcURLcTdaTzhRYkhNbmZu?=
 =?gb2312?B?bDBQZVR2aCtnaFlQcDcycFVTTkE5cmdqbjJHVy83Z1NTK1FmYWJsVms5eEZD?=
 =?gb2312?B?VXR5UEVzaWd5K25IWG01VjlXOG43RGVSdUtXVkQ4K1o1elQvK2F0TlpQUFlZ?=
 =?gb2312?B?VlJzbzk2RkhqWndqdDlKN0JzcWFMcjdsVGVLUGd3MFU0VndDYnRhSkJnTGVw?=
 =?gb2312?B?TGQyVGhxNHk3WWxpbjk2bDJwbVRWcmJhWHVFdFQxeU02Nms5aW1PSmRpNXJG?=
 =?gb2312?B?cUsxVk93dXZYWEVJbC9YU3hCejdJSFdrY3ZEa3c1RVd6cU93a1kvZzNIaXp3?=
 =?gb2312?B?STRpNTF2K2huM1hOZ0dsWGlvVnRXeTNLZEl2bjB1RnpZbjdjL0ZVZmRraU5w?=
 =?gb2312?Q?374GHsPavekmqMM+jj4SycNGizfBtXkoyW44V3B?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6053.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6906d7cf-de19-4933-5d92-08d902fed3b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2021 06:46:14.4479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fJXmLnh6BhYa1IBaaU0/Dz2uvUMEy1NmNA7eA1tgndf2twe1GZlxzCh11ua30CInKMVToXVSV7FpkBHa5AgVUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4087
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTGVvbiBSb21hbm92c2t5
IDxsZW9uQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjHE6jTUwjE5yNUgMTM6MDINCj4gVG86IEFs
aWNlIEd1byAoT1NTKSA8YWxpY2UuZ3VvQG9zcy5ueHAuY29tPg0KPiBDYzogZ3JlZ2toQGxpbnV4
Zm91bmRhdGlvbi5vcmc7IHJhZmFlbEBrZXJuZWwub3JnOyBIb3JpYSBHZWFudGENCj4gPGhvcmlh
LmdlYW50YUBueHAuY29tPjsgQXltZW4gU2doYWllciA8YXltZW4uc2doYWllckBueHAuY29tPjsN
Cj4gaGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1OyBkYXZlbUBkYXZlbWxvZnQubmV0OyB0b255
QGF0b21pZGUuY29tOw0KPiBnZWVydCtyZW5lc2FzQGdsaWRlci5iZTsgbXR1cnF1ZXR0ZUBiYXls
aWJyZS5jb207IHNib3lkQGtlcm5lbC5vcmc7DQo+IHZrb3VsQGtlcm5lbC5vcmc7IHBldGVyLnVq
ZmFsdXNpQGdtYWlsLmNvbTsgYS5oYWpkYUBzYW1zdW5nLmNvbTsNCj4gbmFybXN0cm9uZ0BiYXls
aWJyZS5jb207IHJvYmVydC5mb3NzQGxpbmFyby5vcmc7IGFpcmxpZWRAbGludXguaWU7DQo+IGRh
bmllbEBmZndsbC5jaDsga2hpbG1hbkBiYXlsaWJyZS5jb207IHRvbWJhQGtlcm5lbC5vcmc7IGp5
cmkuc2FyaGFAaWtpLmZpOw0KPiBqb3JvQDhieXRlcy5vcmc7IHdpbGxAa2VybmVsLm9yZzsgbWNo
ZWhhYkBrZXJuZWwub3JnOw0KPiB1bGYuaGFuc3NvbkBsaW5hcm8ub3JnOyBhZHJpYW4uaHVudGVy
QGludGVsLmNvbTsga2lzaG9uQHRpLmNvbTsNCj4ga3ViYUBrZXJuZWwub3JnOyBsaW51cy53YWxs
ZWlqQGxpbmFyby5vcmc7IFJveSBQbGVkZ2UgPHJveS5wbGVkZ2VAbnhwLmNvbT47DQo+IExlbyBM
aSA8bGVveWFuZy5saUBueHAuY29tPjsgc3NhbnRvc2hAa2VybmVsLm9yZzsgbWF0dGhpYXMuYmdn
QGdtYWlsLmNvbTsNCj4gZWR1YmV6dmFsQGdtYWlsLmNvbTsgai1rZWVydGh5QHRpLmNvbTsgYmFs
YmlAa2VybmVsLm9yZzsNCj4gbGludXhAcHJpc2t0ZWNoLmNvLm56OyBzdGVybkByb3dsYW5kLmhh
cnZhcmQuZWR1OyB3aW1AbGludXgtd2F0Y2hkb2cub3JnOw0KPiBsaW51eEByb2Vjay11cy5uZXQ7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5v
cmc7DQo+IGxpbnV4LW9tYXBAdmdlci5rZXJuZWwub3JnOyBsaW51eC1yZW5lc2FzLXNvY0B2Z2Vy
Lmtlcm5lbC5vcmc7DQo+IGxpbnV4LWNsa0B2Z2VyLmtlcm5lbC5vcmc7IGRtYWVuZ2luZUB2Z2Vy
Lmtlcm5lbC5vcmc7DQo+IGRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmc7IGxpbnV4LWFt
bG9naWNAbGlzdHMuaW5mcmFkZWFkLm9yZzsNCj4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZy
YWRlYWQub3JnOyBpb21tdUBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZzsNCj4gbGludXgtbWVk
aWFAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbWNAdmdlci5rZXJuZWwub3JnOw0KPiBuZXRkZXZA
dmdlci5rZXJuZWwub3JnOyBsaW51eC1waHlAbGlzdHMuaW5mcmFkZWFkLm9yZzsNCj4gbGludXgt
Z3Bpb0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4cHBjLWRldkBsaXN0cy5vemxhYnMub3JnOw0KPiBs
aW51eC1zdGFnaW5nQGxpc3RzLmxpbnV4LmRldjsgbGludXgtbWVkaWF0ZWtAbGlzdHMuaW5mcmFk
ZWFkLm9yZzsNCj4gbGludXgtcG1Admdlci5rZXJuZWwub3JnOyBsaW51eC11c2JAdmdlci5rZXJu
ZWwub3JnOw0KPiBsaW51eC13YXRjaGRvZ0B2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6
IFtSRkMgdjEgUEFUQ0ggMy8zXSBkcml2ZXI6IHVwZGF0ZSBhbGwgdGhlIGNvZGUgdGhhdCB1c2UN
Cj4gc29jX2RldmljZV9tYXRjaA0KPiANCj4gT24gTW9uLCBBcHIgMTksIDIwMjEgYXQgMTI6Mjc6
MjJQTSArMDgwMCwgQWxpY2UgR3VvIChPU1MpIHdyb3RlOg0KPiA+IEZyb206IEFsaWNlIEd1byA8
YWxpY2UuZ3VvQG54cC5jb20+DQo+ID4NCj4gPiBVcGRhdGUgYWxsIHRoZSBjb2RlIHRoYXQgdXNl
IHNvY19kZXZpY2VfbWF0Y2ggYmVjYXVzZSBhZGQgc3VwcG9ydCBmb3INCj4gPiBzb2NfZGV2aWNl
X21hdGNoIHJldHVybmluZyAtRVBST0JFX0RFRkVSLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTog
QWxpY2UgR3VvIDxhbGljZS5ndW9AbnhwLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9idXMv
dGktc3lzYy5jICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDIgKy0NCj4gPiAgZHJpdmVycy9j
bGsvcmVuZXNhcy9yOGE3Nzk1LWNwZy1tc3NyLmMgICAgICAgIHwgIDQgKysrLQ0KPiA+ICBkcml2
ZXJzL2Nsay9yZW5lc2FzL3JjYXItZ2VuMi1jcGcuYyAgICAgICAgICAgfCAgMiArLQ0KPiA+ICBk
cml2ZXJzL2Nsay9yZW5lc2FzL3JjYXItZ2VuMy1jcGcuYyAgICAgICAgICAgfCAgMiArLQ0KPiA+
ICBkcml2ZXJzL2RtYS9mc2wtZHBhYTItcWRtYS9kcGFhMi1xZG1hLmMgICAgICAgfCAgNyArKysr
KystDQo+ID4gIGRyaXZlcnMvZG1hL3RpL2szLXBzaWwuYyAgICAgICAgICAgICAgICAgICAgICB8
ICAzICsrKw0KPiA+ICBkcml2ZXJzL2RtYS90aS9rMy11ZG1hLmMgICAgICAgICAgICAgICAgICAg
ICAgfCAgMiArLQ0KPiA+ICBkcml2ZXJzL2dwdS9kcm0vYnJpZGdlL253bC1kc2kuYyAgICAgICAg
ICAgICAgfCAgMiArLQ0KPiA+ICBkcml2ZXJzL2dwdS9kcm0vbWVzb24vbWVzb25fZHJ2LmMgICAg
ICAgICAgICAgfCAgNCArKystDQo+ID4gIGRyaXZlcnMvZ3B1L2RybS9vbWFwZHJtL2Rzcy9kaXNw
Yy5jICAgICAgICAgICB8ICAyICstDQo+ID4gIGRyaXZlcnMvZ3B1L2RybS9vbWFwZHJtL2Rzcy9k
cGkuYyAgICAgICAgICAgICB8ICA0ICsrKy0NCj4gPiAgZHJpdmVycy9ncHUvZHJtL29tYXBkcm0v
ZHNzL2RzaS5jICAgICAgICAgICAgIHwgIDMgKysrDQo+ID4gIGRyaXZlcnMvZ3B1L2RybS9vbWFw
ZHJtL2Rzcy9kc3MuYyAgICAgICAgICAgICB8ICAzICsrKw0KPiA+ICBkcml2ZXJzL2dwdS9kcm0v
b21hcGRybS9kc3MvaGRtaTRfY29yZS5jICAgICAgfCAgMyArKysNCj4gPiAgZHJpdmVycy9ncHUv
ZHJtL29tYXBkcm0vZHNzL3ZlbmMuYyAgICAgICAgICAgIHwgIDQgKysrLQ0KPiA+ICBkcml2ZXJz
L2dwdS9kcm0vb21hcGRybS9vbWFwX2Rydi5jICAgICAgICAgICAgfCAgMyArKysNCj4gPiAgZHJp
dmVycy9ncHUvZHJtL3JjYXItZHUvcmNhcl9kdV9jcnRjLmMgICAgICAgIHwgIDQgKysrLQ0KPiA+
ICBkcml2ZXJzL2dwdS9kcm0vcmNhci1kdS9yY2FyX2x2ZHMuYyAgICAgICAgICAgfCAgMiArLQ0K
PiA+ICBkcml2ZXJzL2dwdS9kcm0vdGlkc3MvdGlkc3NfZGlzcGMuYyAgICAgICAgICAgfCAgNCAr
KystDQo+ID4gIGRyaXZlcnMvaW9tbXUvaXBtbXUtdm1zYS5jICAgICAgICAgICAgICAgICAgICB8
ICA3ICsrKysrLS0NCj4gPiAgZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9yY2FyLXZpbi9yY2FyLWNv
cmUuYyAgIHwgIDIgKy0NCj4gPiAgZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9yY2FyLXZpbi9yY2Fy
LWNzaTIuYyAgIHwgIDIgKy0NCj4gPiAgZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS92c3AxL3ZzcDFf
dWlmLmMgICAgICAgIHwgIDQgKysrLQ0KPiA+ICBkcml2ZXJzL21tYy9ob3N0L3JlbmVzYXNfc2Ro
aV9jb3JlLmMgICAgICAgICAgfCAgMiArLQ0KPiA+ICBkcml2ZXJzL21tYy9ob3N0L3JlbmVzYXNf
c2RoaV9pbnRlcm5hbF9kbWFjLmMgfCAgMiArLQ0KPiA+ICBkcml2ZXJzL21tYy9ob3N0L3NkaGNp
LW9mLWVzZGhjLmMgICAgICAgICAgICAgfCAyMQ0KPiArKysrKysrKysrKysrKy0tLS0tDQo+ID4g
IGRyaXZlcnMvbW1jL2hvc3Qvc2RoY2ktb21hcC5jICAgICAgICAgICAgICAgICB8ICAyICstDQo+
ID4gIGRyaXZlcnMvbW1jL2hvc3Qvc2RoY2lfYW02NTQuYyAgICAgICAgICAgICAgICB8ICAyICst
DQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgICAgICB8ICA0
ICsrKy0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvdGkvYW02NS1jcHN3LW51c3MuYyAgICAg
IHwgIDIgKy0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvdGkvY3Bzdy5jICAgICAgICAgICAg
ICAgIHwgIDIgKy0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvdGkvY3Bzd19uZXcuYyAgICAg
ICAgICAgIHwgIDIgKy0NCj4gPiAgZHJpdmVycy9waHkvdGkvcGh5LW9tYXAtdXNiMi5jICAgICAg
ICAgICAgICAgIHwgIDQgKysrLQ0KPiA+ICBkcml2ZXJzL3BpbmN0cmwvcmVuZXNhcy9jb3JlLmMg
ICAgICAgICAgICAgICAgfCAgMiArLQ0KPiA+ICBkcml2ZXJzL3BpbmN0cmwvcmVuZXNhcy9wZmMt
cjhhNzc5MC5jICAgICAgICAgfCAgNSArKysrLQ0KPiA+ICBkcml2ZXJzL3BpbmN0cmwvcmVuZXNh
cy9wZmMtcjhhNzc5NC5jICAgICAgICAgfCAgNSArKysrLQ0KPiA+ICBkcml2ZXJzL3NvYy9mc2wv
ZHBpby9kcGlvLWRyaXZlci5jICAgICAgICAgICAgfCAxMyArKysrKysrKy0tLS0NCj4gPiAgZHJp
dmVycy9zb2MvcmVuZXNhcy9yOGE3NzRjMC1zeXNjLmMgICAgICAgICAgIHwgIDUgKysrKy0NCj4g
PiAgZHJpdmVycy9zb2MvcmVuZXNhcy9yOGE3Nzk1LXN5c2MuYyAgICAgICAgICAgIHwgIDIgKy0N
Cj4gPiAgZHJpdmVycy9zb2MvcmVuZXNhcy9yOGE3Nzk5MC1zeXNjLmMgICAgICAgICAgIHwgIDUg
KysrKy0NCj4gPiAgZHJpdmVycy9zb2MvdGkvazMtcmluZ2FjYy5jICAgICAgICAgICAgICAgICAg
IHwgIDIgKy0NCj4gPiAgZHJpdmVycy9zdGFnaW5nL210NzYyMS1wY2kvcGNpLW10NzYyMS5jICAg
ICAgIHwgIDIgKy0NCj4gPiAgZHJpdmVycy90aGVybWFsL3JjYXJfZ2VuM190aGVybWFsLmMgICAg
ICAgICAgIHwgIDQgKysrLQ0KPiA+ICBkcml2ZXJzL3RoZXJtYWwvdGktc29jLXRoZXJtYWwvdGkt
YmFuZGdhcC5jICAgfCAxMCArKysrKysrLS0NCj4gPiAgZHJpdmVycy91c2IvZ2FkZ2V0L3VkYy9y
ZW5lc2FzX3VzYjMuYyAgICAgICAgIHwgIDIgKy0NCj4gPiAgZHJpdmVycy91c2IvaG9zdC9laGNp
LXBsYXRmb3JtLmMgICAgICAgICAgICAgIHwgIDQgKysrLQ0KPiA+ICBkcml2ZXJzL3VzYi9ob3N0
L3hoY2ktcmNhci5jICAgICAgICAgICAgICAgICAgfCAgMiArLQ0KPiA+ICBkcml2ZXJzL3dhdGNo
ZG9nL3JlbmVzYXNfd2R0LmMgICAgICAgICAgICAgICAgfCAgMiArLQ0KPiA+ICA0OCBmaWxlcyBj
aGFuZ2VkLCAxMzEgaW5zZXJ0aW9ucygrKSwgNTIgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9idXMvdGktc3lzYy5jIGIvZHJpdmVycy9idXMvdGktc3lzYy5jIGlu
ZGV4DQo+ID4gNWZhZTYwZjhjMTM1Li4wMGM1OWFhMjE3YzEgMTAwNjQ0DQo+ID4gLS0tIGEvZHJp
dmVycy9idXMvdGktc3lzYy5jDQo+ID4gKysrIGIvZHJpdmVycy9idXMvdGktc3lzYy5jDQo+ID4g
QEAgLTI5MDksNyArMjkwOSw3IEBAIHN0YXRpYyBpbnQgc3lzY19pbml0X3NvYyhzdHJ1Y3Qgc3lz
YyAqZGRhdGEpDQo+ID4gIAl9DQo+ID4NCj4gPiAgCW1hdGNoID0gc29jX2RldmljZV9tYXRjaChz
eXNjX3NvY19mZWF0X21hdGNoKTsNCj4gPiAtCWlmICghbWF0Y2gpDQo+ID4gKwlpZiAoIW1hdGNo
IHx8IElTX0VSUihtYXRjaCkpDQo+ID4gIAkJcmV0dXJuIDA7DQo+ID4NCj4gPiAgCWlmIChtYXRj
aC0+ZGF0YSkNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jbGsvcmVuZXNhcy9yOGE3Nzk1LWNw
Zy1tc3NyLmMNCj4gPiBiL2RyaXZlcnMvY2xrL3JlbmVzYXMvcjhhNzc5NS1jcGctbXNzci5jDQo+
ID4gaW5kZXggYzMyZDJjNjc4MDQ2Li45MGExODMzNmE0YzMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJp
dmVycy9jbGsvcmVuZXNhcy9yOGE3Nzk1LWNwZy1tc3NyLmMNCj4gPiArKysgYi9kcml2ZXJzL2Ns
ay9yZW5lc2FzL3I4YTc3OTUtY3BnLW1zc3IuYw0KPiA+IEBAIC00MzksNiArNDM5LDcgQEAgc3Rh
dGljIGNvbnN0IHVuc2lnbmVkIGludCByOGE3Nzk1ZXMyX21vZF9udWxsaWZ5W10NCj4gPiBfX2lu
aXRjb25zdCA9IHsNCj4gPg0KPiA+ICBzdGF0aWMgaW50IF9faW5pdCByOGE3Nzk1X2NwZ19tc3Ny
X2luaXQoc3RydWN0IGRldmljZSAqZGV2KSAgew0KPiA+ICsJY29uc3Qgc3RydWN0IHNvY19kZXZp
Y2VfYXR0cmlidXRlICptYXRjaDsNCj4gPiAgCWNvbnN0IHN0cnVjdCByY2FyX2dlbjNfY3BnX3Bs
bF9jb25maWcgKmNwZ19wbGxfY29uZmlnOw0KPiA+ICAJdTMyIGNwZ19tb2RlOw0KPiA+ICAJaW50
IGVycm9yOw0KPiA+IEBAIC00NTMsNyArNDU0LDggQEAgc3RhdGljIGludCBfX2luaXQgcjhhNzc5
NV9jcGdfbXNzcl9pbml0KHN0cnVjdCBkZXZpY2UNCj4gKmRldikNCj4gPiAgCQlyZXR1cm4gLUVJ
TlZBTDsNCj4gPiAgCX0NCj4gPg0KPiA+IC0JaWYgKHNvY19kZXZpY2VfbWF0Y2gocjhhNzc5NWVz
MSkpIHsNCj4gPiArCW1hdGNoID0gc29jX2RldmljZV9tYXRjaChyOGE3Nzk1ZXMxKTsNCj4gPiAr
CWlmICghSVNfRVJSKG1hdGNoKSAmJiBtYXRjaCkgew0KPiANCj4gImlmICghSVNfRVJSX09SX05V
TEwobWF0Y2gpKSIgaW4gYWxsIHBsYWNlcy4NCg0KVGhhbmsgeW91IGZvciB5b3VyIHN1Z2dlc3Rp
b24uIEkgd2lsbCBtb2RpZnkgdGhlbS4NCg0KQmVzdCBSZWdhcmRzLA0KQWxpY2UgR3VvDQoNCj4g
VGhhbmtzDQo=
