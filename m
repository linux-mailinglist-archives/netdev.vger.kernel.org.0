Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F135B9ED9
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 17:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiIOPdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 11:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiIOPdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 11:33:51 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2103.outbound.protection.outlook.com [40.107.21.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ABC4DF0C;
        Thu, 15 Sep 2022 08:33:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhkoNYNcVec71J7MGxL5v4ysL/Eav/XkrmHk1gHYFKfMwZ94FrdUfMhLliTHbBFX9tgAAJ8hTungveXyKJ9Sr+tGAHc7MX8w4FLkeTg9iSI/bsQTyOv4yvsarLofJHK2U3fXQGsTtXc0kKf82VS5tv1W41GBfSGM0Kr4tAFIYzIKeriifYgrjIh3+4IvEb83rZG5pa4h2AbL10c62/FYQLLBC0EfFosq0xne8r8ZqjIiX4Gl8F3vIpL0BwePa3UysCNlau81ndiQ/2l7L5cw1fIUFdLeIBi1/Tn9zlchKdGLUz296y/BxpM8muOcrqh7SoLo2dE8KC/Qadn9mDQkrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/bSbcSdizuXIgIuadvWOZaFxJt3Jl3WkELF92T1lLk=;
 b=EZ6bpi+Kki6llHBoro13maCVOBxHYvNHrA/Y246enxrhi5kplQYw2wP47uBgGAD/HlCqpU0LIVAyLTzte0uG/AnzC8In5JP5P5YJtO2iBMRaPkVNW0jWZIdKqh29s3TsYVLKyDdh/Tslt+WH13eG7ONP8zv8xzo0GsekXluN27WGGNyIBuv4V8rUIATQqpsMIxWMjfzztKmET5UDgLyba/ng8MkGbJu41/JVl/+9UhXCXiARsr23Z2Z8Jd3E1Jtta5okEmyLcmUGhBHutGu8WTKeEtQfX32QrJemPAuHRD0Xy69JlbBvVd1HqGGzDhHWGIHKRnpd009Y1Z+84fV2gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/bSbcSdizuXIgIuadvWOZaFxJt3Jl3WkELF92T1lLk=;
 b=AdA+bWowp0x6IgHxGpD3wljic63z0umidoo8621IdjLvdxSyNpakU7N8WC3LgQeN6bVjEQ4YrO2CMH1itprX4+FhKyDhqGNTJJPOZ7nIt5E3hfTn55miTZSRv2ALNa0yWu0HiDeMYhBmVsTkx/Yq8d46VdQLuqr2i216gP6D41A=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB9PR03MB7567.eurprd03.prod.outlook.com (2603:10a6:10:2c4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 15:33:47 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb%5]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 15:33:47 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
CC:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rafa__ Mi__ecki <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        Sven Peter <sven@svenpeter.dev>
Subject: Re: [PATCH wireless-next v2 02/12] brcmfmac: firmware: Handle
 per-board clm_blob files
Thread-Topic: [PATCH wireless-next v2 02/12] brcmfmac: firmware: Handle
 per-board clm_blob files
Thread-Index: AQHYyRiLci0VhGHSREyonM+LYMkGHg==
Date:   Thu, 15 Sep 2022 15:33:46 +0000
Message-ID: <20220915153346.a7waulp6xzrzcleh@bang-olufsen.dk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
 <E1oXg7S-0064um-F7@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1oXg7S-0064um-F7@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|DB9PR03MB7567:EE_
x-ms-office365-filtering-correlation-id: e0c0dc89-b048-4fdc-5a0d-08da972fae43
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vHtNmD3dqB9pNxredK3HEbmqyIKovB3WD/2N5ChAa19cBaOzaxDWqOzNq+llNSSS7IClqqopnkn+83YgNTa3G88WNJx8WL73xbYTRA7FCY2rEO4fS/Qzd2FBm+hXfnCynEne01JEP7MW7Yo5bsn5jyaN0MYN2sGD3dQElEAJMfd278H05sJg9G6Yh8Fv/c4vL1nRwfs3D4kjPDaXxi+GafCfbMIiOs2ND7Vn0ajp1qq3NdM7O2gaMq82Yb9mtCLu4zgTzic5I+BVvWoSqg6nJV87akFjY8VAxkL0kCwthv9toEqwZzaMRSPbGNwgTAv34CK3quMbriB/UDZ7eCjLFagLXC9zje7cQh0yDV9360OOQaufTEMxpKbA8TsL8JEHnqnZsMLuif9aw2Uf6BoL+dBKls/EE2CuJBbOmDHVgkGXVtH/o0NSD1PSPAa1e0edPINNIfF+b1T2iBILvAoNTBMXS+cyLlU/NquEX8H7TMz+KWwVKwCtTx6HD+3zv4S8uqHW2WRPMCqB7DO48po2s5+VYMoaek11f6X/wO6lASZfNvHX1EBnbH6z5pb1trsB5I1iHtvRsJqm7GanTny+vLP8+ApIQ/qGEqvUJs2WvVaqEBr+VLkoQ1WODJGjqjMgsdT8cddZRYq58d5DnsNScgS9joxhoflMx/ta6DjObiemgFVE7nHCjX6uhV+xDO1hOF4cp+aHyvHZgZLAMNjlpcKKcFgHyYCXRD1U7/n4ua3amjiegy7a9xcYeSQCLF4LNiue2empyIVFPAGVOdpHbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199015)(122000001)(5660300002)(4326008)(91956017)(8936002)(4744005)(8976002)(64756008)(76116006)(2616005)(8676002)(66446008)(2906002)(36756003)(316002)(66946007)(85202003)(6512007)(71200400001)(41300700001)(86362001)(66556008)(54906003)(6486002)(66476007)(1076003)(6506007)(38100700002)(38070700005)(85182001)(83380400001)(26005)(478600001)(7416002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bENObHI3SGhJVSszMXBRRjlaR0VqUWZJdDgzYmpGMFAxcHBENlh4Vkc0cFJW?=
 =?utf-8?B?SldoU1pUYlVsbFJRWTU3ZFRQcjh0VWtUOXFsQVhoVElHUVZ5SlBiQnp2OTla?=
 =?utf-8?B?Umg1MnROU1prVEVBTHVsWFY1MnBWRVhBaFMvUG0rK3BJdUJXWVc3REZybnk4?=
 =?utf-8?B?cG5weEl2SWlLQlBTaE1Xak5HTVdNMk5jK1FGLy9jSnlsNWVnU1hBclZ3Ulov?=
 =?utf-8?B?RkxQbGNmS0hTTmJBRk9VY1d3QlUyWkNzcFcwSjNzY2ZlbzVXZ0lnYkQrVHpF?=
 =?utf-8?B?Ni9NOGNDRXlZNGlqYzRaWmluQ3VsTUwvdWs3M0VqUGpScGJZYWllaXBaUzEv?=
 =?utf-8?B?WmNVYTBHbXNzZTJSdEpCSG5LRm9yZTVkZzVmdTB6ZDZvVXFmVWN6Y0IwcWtC?=
 =?utf-8?B?UnFUT2hYREc1bEh6OUxUYTk0YXZqdlRaWWJ4czE2YXZ3WjJmbUo4Y0dTT0w0?=
 =?utf-8?B?dmlyV0hNRk1qMUowbmExY0I2eTdrRytrekJLU281dDVxY3c1WHhYNU5xNGlx?=
 =?utf-8?B?MUxiVGF6RDVWSUdiQ2JQUnR2S2xJYlc4NWpGbnJKNzZ6YVFxNFR6ME9aaUFa?=
 =?utf-8?B?TmFnVDZncHF0MDF3WTkwYk5CRnJndy9iWFhDemM5QzZ1Z3dhRDRxYmY0SFBF?=
 =?utf-8?B?NlJZSW1aaEMvZHgzQXlRTWZTQVZOT2lBamFlSDFyaEZTcUlXaTdVZm14aStC?=
 =?utf-8?B?aDNnR0V5Q2RmOTU4SzZNNkk1c041NHN6b1lSN3dpTFBibzNZY0FaeFMxUk5M?=
 =?utf-8?B?MVpaZ3ZQb01rSDhxTEdiT20rVW5PUmRpeExUaGNTZmR3VkdFVG14akMzb2xr?=
 =?utf-8?B?YVQzLzJ4a3lPeDVRdzg5N3c0UWYyMTRMdkllcVFXVndPWEtnOXVvaW9rVjJW?=
 =?utf-8?B?a21sbm5kR2cxR1BJVDJaK2JqUm5JWXRrVU9DU1JtNjNiZTQ2RDhhRUdKQjlx?=
 =?utf-8?B?T3UwZCtkNjNYb2Urby9LdmNGdmlnVnlkalEvWS8xRGdPaEZzaHBNYmc0dG5j?=
 =?utf-8?B?MmFYNTc4aEVhVE4rLzhBUDR2bnpTZUNQTUk4QmlvbU50eVFncGRpa0YzbUs2?=
 =?utf-8?B?cWlXQ1htSzZtdExUNnAwRzMzTC9neGZjS3dWYm9EVkEwcXZwZUUwdERpL3N1?=
 =?utf-8?B?UEkyVk1DK1ZhNGsvWGNjUklQNEtXNkJEMFZ2dk1wRzUvMkZxVUhWT0xXRWQ0?=
 =?utf-8?B?WGNOYW9DQmlyVkRXN0MyWGJYZ0FSNkh1NnNLL1grTThMMmtUVDg1dm9TaDBW?=
 =?utf-8?B?ZitPNFVjc3p4WVpqNk02Zzd6b0RsTkFIL0twbWd0ajhlekhaTFdxQ1R1U1lm?=
 =?utf-8?B?YU16SWRnRmc3NjRFemNTWW50aFVDZFE0cVN3R21ldWcyMkJncjNrTXJWT3M2?=
 =?utf-8?B?enRyS3E5YWt2YXNEUXZsRE8wSzR3d3FQKzc4QWIya1I4eDdLcjdCQ1FSQUh5?=
 =?utf-8?B?N08xd1p4WFl3SkczMXVPY3J1cG83algwblYySEpBZjZpWUZ5VEc1c1VQczN0?=
 =?utf-8?B?MTQ3S2daLzF6TktDaFppT3VjanFpcU45bHFJUjR5bFFuVi9CN09NQ2FvQ2VB?=
 =?utf-8?B?QWRKdEpZV3F2emtTak5hMFRLVnRNODd5akh5citMaVdPcWJjbUdJR2ZzZ3h3?=
 =?utf-8?B?M1pqNzE2RWMyYUF3NVF0V1pPcE5YLzV2M2l4UFdQanZDbXA3REZBNzZIZW5j?=
 =?utf-8?B?NnY5OE5pY3BwbkYwZ1RUS1hHNFhkem9BVzBuaS9lTWtzMU53cld0bEUxK2li?=
 =?utf-8?B?UU1FcHkvT0pqakdmeUREbDh2Rk5zTlhRNVZ6ckZGMGpIN1Jjb0N6SmE0bjhs?=
 =?utf-8?B?Y1FkNGNIeDBMT0tlNVVsSkwrejd2dmRyUWk1ZDNFYUZYOEtWVDlPYThXNFd3?=
 =?utf-8?B?b1piR0hXUzNqM2lUQ2gyVmtYQ0xTY2d3OXprVVRLcm1leGdHa1U4T3Bsc2py?=
 =?utf-8?B?QWZDa2YzMDVFdnRjVXhwN0Q4bklTSENhWU11WW5iSFl5RmtEeUVUeldZQnlP?=
 =?utf-8?B?Y25qeGZYNGgvMHN1SWRhVk5aMlIwRzRwYmRDRDJtc3lRQnhFTllVbjMwTmdr?=
 =?utf-8?B?enF4bnRJaXVwUkxybjZMZEVZbHZUSVRSSzFOMURQQ3lUOFJSc2FKeHduVTZ0?=
 =?utf-8?B?R1dkSVpTc0ZmWnNtQ1l3a1VpYVZOMXhIem43a3dwUGYxZW14eEpjV0VPZk1q?=
 =?utf-8?B?Ync9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2BFFD52A16DE048B8C36C6AE37ED4B0@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0c0dc89-b048-4fdc-5a0d-08da972fae43
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 15:33:46.8628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dq52mc4slqq+UNMbMZvpdcDAeYvIUrM83YGrGAydrc70LUf/ZH17e+aoR1pV/fBDUChC6kcmct4mCpxFvADedg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7567
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBTZXAgMTIsIDIwMjIgYXQgMTA6NTI6NDZBTSArMDEwMCwgUnVzc2VsbCBLaW5nIHdy
b3RlOg0KPiBGcm9tOiBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0Pg0KPiANCj4gVGVh
Y2ggYnJjbV9hbHRfZndfcGF0aHMgdG8gY29ycmVjdGx5IHNwbGl0IG9mZiB2YXJpYWJsZSBsZW5n
dGgNCj4gZXh0ZW5zaW9ucywgYW5kIGVuYWJsZSBhbHQgZmlybXdhcmUgbG9va3VwcyBmb3IgdGhl
IENMTSBibG9iIGZpcm13YXJlDQo+IHJlcXVlc3RzLg0KPiANCj4gQXBwbGUgcGxhdGZvcm1zIGhh
dmUgcGVyLWJvYXJkIENMTSBibG9iIGZpbGVzLg0KPiANCj4gQWNrZWQtYnk6IExpbnVzIFdhbGxl
aWogPGxpbnVzLndhbGxlaWpAbGluYXJvLm9yZz4NCj4gUmV2aWV3ZWQtYnk6IEFyZW5kIHZhbiBT
cHJpZWwgPGFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEhl
Y3RvciBNYXJ0aW4gPG1hcmNhbkBtYXJjYW4uc3Q+DQo+IFNpZ25lZC1vZmYtYnk6IFJ1c3NlbGwg
S2luZyAoT3JhY2xlKSA8cm1rK2tlcm5lbEBhcm1saW51eC5vcmcudWs+DQo+IC0tLQ0KDQpSZXZp
ZXdlZC1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2VuLmRrPg==
