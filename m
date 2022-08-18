Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4279A598750
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344191AbiHRPV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344249AbiHRPVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:21:15 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10070.outbound.protection.outlook.com [40.107.1.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E026C768
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:21:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8ZuutXoaDmGwLWb2hUGRQtNragBIXhmjXqJ854Ol/R4RlupvzHuU0cunMwsdB2jgx7FN4VnR6oU63DlgGe+AI2MAMY5pvanszDBQWr9t66Mn7hThlk1umaYGAr0w6IWteOq3oS/YF+0S8kyeE3MzCiZBvfTe+lZ3Lx2I2QybQw8a054yUn3KbXLpUHP3ZSE/f3ovzLy1ZguR1qXOAcAkmeXazMpUt9j3J3GRqW8NyONU0S4xXKv+6CaEDbMaDx9oKBn6iwZRqckjAPcNHvO2/kV5X5KqPnEtjZb3A3x5XxLwZlzPtGTbzyVihAfik+SLgSQO9xexcqTNo0h53hl3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wh8FKb556ur/J2b1fXq0h0aMzCMhAa7tQ/3YXkkSvk0=;
 b=TCIryqWFVprUhf2QqF7/qaNipnryq/WBdBeWLp9hNcV9NKcxoScsrTLPGWL0C45Kugfn3Ck67n2SpNqz9D4dQG68nJFtzd8AMC140s/tCL4EdXltc0nxa2Vg2TjsvcmgJhryjKED96ICwVVllWxsp1pCZkavUhU2Xdha7oPmLBIk0rCSLxRcZD2uJvzuXeahEPJ9XVObX50Yaw1Ip2SJpDu7gl2X/hcWGrDlLmkTaA2eBIosOKw/DKe4t5pa/H5aSCkfds9PuMf9TiQ2XY84CmlUyWvKaGtRr149DJrYGnWFkiuaaEMU/J5PQ7PapLaE//4eac5DPSR0fSnLy5APjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wh8FKb556ur/J2b1fXq0h0aMzCMhAa7tQ/3YXkkSvk0=;
 b=dXUN5vvitmzNO9VUyrYQexv8W/3BLbb9pgY6Fz+RKJpsqGEpBgvhWtAf20Uii0Hmf5TBY5fVnRfFyvmEpsfw0wu1kzs3CNvsSktmOTYeIhXRdvNRoUpzlYSSMhjYX4FqQ3U9rqSSjQjJH11O7fzAq/GNF9ppYNFBvpBtiXNeXqg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5341.eurprd04.prod.outlook.com (2603:10a6:803:3d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 15:21:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 15:21:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Russell King <rmk+kernel@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        =?gb2312?B?QWx2aW4gqeCoomlwcmFnYQ==?= <alsi@bang-olufsen.dk>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Craig McQueen <craig@mcqueen.id.au>
Subject: Re: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Thread-Topic: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Thread-Index: AQHYsw9wTPJvcSDZh0qzuivUfmRwaa20xB+AgAACBwA=
Date:   Thu, 18 Aug 2022 15:21:07 +0000
Message-ID: <20220818152106.qqd2q3leiaooh3fk@skbuf>
References: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
 <Yv5XL4KTLxukVhck@lunn.ch>
In-Reply-To: <Yv5XL4KTLxukVhck@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21ba01e8-5977-4067-b382-08da812d45e6
x-ms-traffictypediagnostic: VI1PR04MB5341:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: trtF/KbPvhu4OaxQQrev7ZQmYyfRQnRbHr9RacIibfWu3kvLPUX0048/Zfcw0nUMDXIzlCSV1HFF93hSdKGuPjAVYndmxy0fszIXieI2XmtkiAYbVx1rgNIJBfTtYTZgKD42kmQ3JecOJTyyedadiC+6vBU9XtQ2Ljs3hC5LGfgnMaNT0Ghnn5pMYjNvH2btC1Fz1Xx9Hi4BGzq9HMRlijFO6cKoF+e2XXjbLpnzrurwNaGyjDqRSUwze1PSAZ+kxl93//aTFQ/C9j7BN++j/T9lOcejO2CW6kPztK7l32dPgvl5hRFQphr6uGRBCY7l+xh4oTZNb8SOOKrzBfA+MmwUCfOa29AbkQbMgha1WUqjZf8xDXhlKmlRO5r7jDRz/zyIf5ENUUs8VEodFMA3jISNzuk7PNbeVTezwwpyz47Z+oSrloieHhjDfID7Sp6wZRf+vS7aF3j66oH1zGsEuUUDU4GL8QnAdkcynNcG6D0ZhY/vjL2HHdRpTH74EtP97LagYjewDbVsQ8IHLyM6y5xC6MYVdOs8F2Zi8EZBN7yWJ23wZea7nz3qt6tE3g9w8Qb0zviuIK+79NDoVoPHd8+oOApMAjAJQbHP2szobOnI706k1crZ/nN/7ffDTIMpEoSmB/PqtJB+2XItu4YcLsjLCtpuEF5yL3+QVZv1+rOh/Xif6f/zs0zMWJAoNuFgkW3SxpgZH3sNb16O1L9LqSexfUVNwOcNhhJeC5NBjJuKrIvW1resietXKvlyca1cU7WVJBrj5AShpT4Ty4MfZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(39860400002)(136003)(346002)(396003)(366004)(6506007)(66946007)(64756008)(66556008)(7416002)(66446008)(76116006)(66476007)(4326008)(1076003)(186003)(26005)(91956017)(6486002)(8676002)(5660300002)(41300700001)(8936002)(6512007)(44832011)(83380400001)(9686003)(38070700005)(478600001)(2906002)(38100700002)(86362001)(316002)(122000001)(33716001)(54906003)(6916009)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?b1JhTVhaMU9uVFk2dkMyYkx1T05nemFVTm11RFQvVXpPWTVNOW1PbHRBeVlZ?=
 =?gb2312?B?OHhyaFVobXNObXkvaEJuQUVUNUdUaEY5by9kczVLTUdnZ2hubDRsN0lYRHMy?=
 =?gb2312?B?SnByQW1pcXVhNysrR0QxOWl1OWF4MlR3VFdFdHJCTkF4QXJYb2cvSngvWFBL?=
 =?gb2312?B?MHhPUzhIbFc0UHh2clZ6c3lHQ3h3ZjRpUlhmUDExdHl1WDM1TkxJQmRYOWVi?=
 =?gb2312?B?QTBJTDdCTEhLVDJEV1FnSi9tcFJCblkwQURhY0RBdldGbjRkemNxTE0rNXgx?=
 =?gb2312?B?dDluNWY0a3licjRtbVdqUGJqclRDSldTeDNUOE5qQk4yMWdNZTg2TkRKNHF4?=
 =?gb2312?B?bHhxNVdBL1lQY2ZzQ3JXRWRqdGVBb0kxVkhDWVg0YUNTbUVrOWdCUWk5RzdF?=
 =?gb2312?B?L1g1VDhBMTN6U3VKQVQxbmFCUzFnYktFN29jM2hnSVRoTXlnRUNvUm0zczlw?=
 =?gb2312?B?dWlLaGNjRUhOdjMyWnlteFVPU2pXaGl4WjlRNEUyN2owRkZJU2hKeHBPS05m?=
 =?gb2312?B?dlVlbEQweDF1U0oxam0xUGorVHJhajB6dVBGOEF0Znd4d2xMemxhT3c2RkpS?=
 =?gb2312?B?dC9oRjFTNE4rc1lJa1JZanBSdGcyeEFYS2dIaFZrdXEva1UxdGU0WXFrR2Q1?=
 =?gb2312?B?alU2NTVWSmRwUUk3WWFYNmozc05XVGxlbzVpZzlaMXdtR21xVU80K2xFenMr?=
 =?gb2312?B?V1lQL0FySHVuSjdCUVU5R2dCOUZuMmNFK1drQ3NqK0g1VU56ZXVOam9vQzZn?=
 =?gb2312?B?Tk9oTzVUWGhrbHFiSEhSU2xqdTdXZHRaOHdNM2pxTzRyVCtNV0lEcWZQYXpa?=
 =?gb2312?B?VWxnRUJ1ZmVXOEdmQm1sNE5hSE83V3lGcHNia24zTmp0OEVVWThoMTRINjRP?=
 =?gb2312?B?d0J2di9aTHhpd25WUWtCdXRIT0RXZncrdXREdXMwNThRc0ZPZUNhUUpFNEkz?=
 =?gb2312?B?ZE95ZFhRMHlzNFRvTkFYbFFJeTYra0hVaWNRUlVYKyt2cHVrU1pJcVZzWmhS?=
 =?gb2312?B?SzhQQUtJMFZocFZWS0ZFa09DUzdJRm00RlBvd1pRbnQzb1Vpb2V2N2JFT2xk?=
 =?gb2312?B?MEcvV2QwSmMrZVdTOW13V3JDazJOVnVEUm9lVEJaUlUzVnNsc1pWUTBCNDg5?=
 =?gb2312?B?RVg5YWhyR2ZKUHFoY0l2bHJJWXdLY2ZoTWxObko2NlBjSVV1YWZ2VTVkanVj?=
 =?gb2312?B?dENuY1lYalFFUDh5cXI5RHdteXBjOWJKOGZRZWFuL3B4L1hVbjhLcEpQYXJ0?=
 =?gb2312?B?dnNvQklSTXdndUI3WUI4Nk5qOU1TSTlJT2JVeDNteXVtbXFOcUorOWt0LzJl?=
 =?gb2312?B?ajRheFR1VTluQW9LWkVCcU0rRW5kMmFOWG1sV3I0YXlMcVhKT1lGYUVYZ1pz?=
 =?gb2312?B?MHFLZTUxOElNOGdoUk8xS29VeG1aRHlZZHMrdGdSUHdGRWNGZjlqVzUrR01r?=
 =?gb2312?B?RHFCWlRxSFppQUQrdkZyZUlqa2VNWEZtZjd3dytuUGNDRi9GWEsvcGlXSU9l?=
 =?gb2312?B?a3g3VUNZSitRZCtQeEI4Nk9EZXJkSWd3S1pZSDJBZmo4VEdURFlYbjY1UEpZ?=
 =?gb2312?B?c1lqeExVN3VyYm9DblZ2V3RObllRdktlWENldERnVjJBblBvei83ZytZQ1VU?=
 =?gb2312?B?ZEZ6enJaZlNVK0JsVnlKd2NsOVU2YmZRQTk1NTZnMG9OY2lSMStMNGxCcFFs?=
 =?gb2312?B?dWkxcXgzNjY4MmN6RlpuVXVIWUNHSkovM3B2YXVvVTJsZUV3RzV0bzdncVdX?=
 =?gb2312?B?Rk4waUpoRHBOZC83Y0RzYzNzR1g2dDU0RDVReHdVNFQ2aEVJT2EvVGMzYmFR?=
 =?gb2312?B?N05zMXcwYzRMdFJhZnBvRkhTVWlzSlFQQjE0aGY4TlY2VHVUQWRObTE0Mkw5?=
 =?gb2312?B?RDFmSnJFd0RWdFVRT092a0xHSUNWM2JkTmpCWWxjSmNFRndNVzhIYWl4QnNo?=
 =?gb2312?B?RXhXaHB6SXdWb1N6djBqVmtMWEkrUGpXS25ibFlqWTVDdXRaaFpWcUJuZWpr?=
 =?gb2312?B?clFublZLdkt0OFYyVWcxc0p3WXpsMkEyTURuMVBwNUtBK3RiaW5uaEc1ZkdS?=
 =?gb2312?B?cUR1SzZFa29lSDhYTDdsdldwWTM3RzNHZmlDR1hRYXlNUHh2MGtFQ3dKME5T?=
 =?gb2312?B?ZU0rSHQrbFVUendMNFU4UUlzbmZoSDhJa09WKzk0NXcra3lSOHIvczY1SkVO?=
 =?gb2312?B?clE9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <DE3A4327FEC42C4CB9D39C879B0B347B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ba01e8-5977-4067-b382-08da812d45e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 15:21:07.2136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kMWzPSvrzpwBvqSAKQm67je0E6q/VVd9ir2gxOdzA9akoXGZ3M5Biyktvm9BpR/rszyqzEi7L82j5DgGsQfMUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5341
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBBdWcgMTgsIDIwMjIgYXQgMDU6MTM6NTFQTSArMDIwMCwgQW5kcmV3IEx1bm4gd3Jv
dGU6DQo+ID4gSXQgaXMgaW1wb3J0YW50IHRvIG5vdGUgdGhhdCBwaHlfZGV2aWNlX2NyZWF0ZSgp
IGluaXRpYWxpemVzDQo+ID4gZGV2LT5pbnRlcmZhY2UgPSBQSFlfSU5URVJGQUNFX01PREVfR01J
SSwgYW5kIHNvLCB3aGVuIHdlIHVzZQ0KPiA+IHBoeWxpbmtfY3JlYXRlKFBIWV9JTlRFUkZBQ0Vf
TU9ERV9OQSksIG5vIG9uZSB3aWxsIG92ZXJyaWRlIHRoaXMsIGFuZCB3ZQ0KPiA+IHdpbGwgZW5k
IHVwIHdpdGggYSBQSFlfSU5URVJGQUNFX01PREVfR01JSSBpbnRlcmZhY2UgaW5oZXJpdGVkIGZy
b20gdGhlDQo+ID4gUEhZLg0KPiANCj4gSXMgdGhpcyBhY3R1YWxseSBhIGJ1Zz8NCj4gDQo+IFdp
dGggcHVyZSBwaHlsaWIsIHlvdSBzaG91bGQgY2FsbCBvbmUgb2YgdGhlIGNvbm5lY3QgZnVuY3Rp
b25zLCB3aGljaA0KPiB1bmRlcm5lYXRoIGNhbGxzIHBoeV9hdHRhY2hfZGlyZWN0KCkgd2hpY2gg
aGFzIGEgcGh5X2ludGVyZmFjZV90LiBTbw0KPiB0aGUgZGVmYXVsdCBpbiBwcmFjdGljZSBkb2Vz
IG5vdCBtYXR0ZXIuDQoNCldoYXQgZG8geW91IGNvbnNpZGVyICJidWciPyBJIHRoaW5rIGhlcmUg
aXMgd2hlcmUgcGh5bGluayBpbmhlcml0cyB3aGF0DQpwaHlfZGV2aWNlX2NyZWF0ZSgpIHNldCBh
cyBkZWZhdWx0Og0KDQppbnQgcGh5bGlua19jb25uZWN0X3BoeShzdHJ1Y3QgcGh5bGluayAqcGws
IHN0cnVjdCBwaHlfZGV2aWNlICpwaHkpDQp7DQoJaW50IHJldDsNCg0KCS8qIFVzZSBQSFkgZGV2
aWNlL2RyaXZlciBpbnRlcmZhY2UgKi8NCglpZiAocGwtPmxpbmtfaW50ZXJmYWNlID09IFBIWV9J
TlRFUkZBQ0VfTU9ERV9OQSkgew0KCQlwbC0+bGlua19pbnRlcmZhY2UgPSBwaHktPmludGVyZmFj
ZTsNCgkJcGwtPmxpbmtfY29uZmlnLmludGVyZmFjZSA9IHBsLT5saW5rX2ludGVyZmFjZTsgPC0g
aGVyZQ0KCX0NCg0KCXJldCA9IHBoeWxpbmtfYXR0YWNoX3BoeShwbCwgcGh5LCBwbC0+bGlua19p
bnRlcmZhY2UpOyA8LSBoZXJlIGlzIHRoZSBwaHlfYXR0YWNoX2RpcmVjdCgpDQoJaWYgKHJldCA8
IDApDQoJCXJldHVybiByZXQ7DQoNCglyZXQgPSBwaHlsaW5rX2JyaW5ndXBfcGh5KHBsLCBwaHks
IHBsLT5saW5rX2NvbmZpZy5pbnRlcmZhY2UpOw0KCWlmIChyZXQpDQoJCXBoeV9kZXRhY2gocGh5
KTsNCg0KCXJldHVybiByZXQ7DQp9DQoNClNvIHllcywgYWx0aG91Z2ggeW91J3JlIHJpZ2h0IGlu
IHRoYXQgaWYgeW91IGNhbGwgcGh5X2F0dGFjaF9kaXJlY3QoKQ0KdGhpcyBkb2Vzbid0IGhhcHBl
biwgYnV0IGlmIHlvdSBnbyB0aHJvdWdoIHBoeWxpbmtfY29ubmVjdF9waHkoKSBJIHRoaW5rDQpp
dCdzIGV4cGVjdGVkIHRoYXQgaXQgd2lsbC4NCg0KPiA+IEFsbCB0aGlzIG1lYW5zIHRoYXQgaW4g
b3JkZXIgdG8gbWFpbnRhaW4gY29tcGF0aWJpbGl0eSB3aXRoIGRldmljZSB0cmVlDQo+ID4gYmxv
YnMgd2hlcmUgdGhlIHBoeS1tb2RlIHByb3BlcnR5IGlzIG1pc3NpbmcsIHdlIG5lZWQgdG8gYWxs
b3cgdGhlDQo+ID4gImdtaWkiIHBoeS1tb2RlIGFuZCB0cmVhdCBpdCBhcyAiaW50ZXJuYWwiLg0K
PiANCj4gb2ZfZ2V0X3BoeV9tb2RlKCkgcmV0dXJucyBQSFlfSU5URVJGQUNFX01PREVfTkEgaWYg
dGhlIHByb3BlcnR5IGlzDQo+IG1pc3NpbmcsIHdoaWNoIGFsc28gc3VnZ2VzdHMgdGhpcyBpcyBh
IGJ1Zy4NCj4gDQo+IEkgd29uZGVyIGlmIHdlIGhhdmUgYW55IHBvcnRzIHdoaWNoIGFjdHVhbGx5
IHJlbHkgb24NCj4gUEhZX0lOVEVSRkFDRV9NT0RFX0dNSUk/DQoNCldoYXQgZG8geW91IG1lYW4s
IHlvdSBtZWFuIGFjdHVhbCBHTUlJIHdpcmVkIHRvIGNoaXAgcGlub3V0Pw==
