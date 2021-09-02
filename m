Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99923FECC1
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 13:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243737AbhIBLQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 07:16:48 -0400
Received: from mail-eopbgr60053.outbound.protection.outlook.com ([40.107.6.53]:47278
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230256AbhIBLQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 07:16:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGkP/Dm181kJSqig0Rg7luFh8IIw8Z7L69V9wbJHCPLp2KCCMmRpRW22768jl8/EQ+WajzCq+hP3gZYlGHT9gnmL3RVyVHUFK3MqR3Tvs7/E/90GxWCLCg9HRKv+Zkn3J6CJmT+zzQSJRKPPX9p5rhETMlz0QEkFGLr7SUrBbhNVicDS8zW9NNPDXfMPC0Ga+zgOanuRs5oejlh48TL3DGu0zI9nlKzuwSAaYT8a0XamS1qkiAXTKUThyRLAUWZVhbRnMkIdHIzp/sLvaxdVLKgRKgHT8n8U+vz9ZxVg2u6nD3m8YPXylyzawYfHDJBWJNzIoKXFlpsP7TIRzBuxdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=w2ML3t9HO60hWde0+mJB2w8Tb+0dmjGX+3YyYUrbLNs=;
 b=YdWekZDrtvB62t74eBmNTGxx6dJIMaOB4Dcxkgp/0l14cdh0OtW42XYu0QBgwE1mNkGnMzt5CQKc4TH2hF3/JMKWpjnepWMPznqWO2wRJb2ike7wvZUBTGrBQG1FE/1twEFENDkgrsTa/D/FrnHqQoePU12+4ibtWROtlBlcycpqltj1FPLYVOR97aTzAJf5cLkLjuxZUcuTpGtT2qOU+VPLfIg6VF7CX85SlYStMbNw6QrYS2UhcYpOr+c3+6RXY++a5dXsEYBnR1Og+YoIMpUG6wKH7L9y9CIOaveMXpib2R+1hMD2YujuB005RKaV6MzzUreTsGgaOyZgaP6fAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w2ML3t9HO60hWde0+mJB2w8Tb+0dmjGX+3YyYUrbLNs=;
 b=S+PYP3uYVwlX05lLAFEHlN8hmC48vMRmLwA9SepSAg1fOTYreC0LM3Ocf5WYOdRFWJoAD9/K3P1yjEbe6zkGX+dW6jWGQgtNk3qNhdjLGd1sNXVWSh5T5xdoj6D6f8nyxadfSty1oN2cvAXV4gPexi6q5P+IwX1chIDG61f1vEU=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3205.eurprd04.prod.outlook.com (2603:10a6:6:e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19; Thu, 2 Sep 2021 11:15:43 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f%9]) with mapi id 15.20.4457.024; Thu, 2 Sep 2021
 11:15:43 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Thread-Topic: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Thread-Index: AQHXnxAXiWCMYvQkY0qCXzBIAPLPn6uO53WAgAAPWNCAAAsFgIAACEPggAAhioCAAQx9sIAAM98AgAAW9HCAAA9qgIAAAa+A
Date:   Thu, 2 Sep 2021 11:15:43 +0000
Message-ID: <DB8PR04MB6795C37D718096E7CA1AA72DE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210901090228.11308-1-qiangqing.zhang@nxp.com>
 <20210901092149.fmap4ac7jxf754ao@skbuf>
 <DB8PR04MB6795CCAE06AA7CEB5CCEC521E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210901105611.y27yymlyi5e4hys5@skbuf>
 <DB8PR04MB67956C22F601DA8B7DC147D5E6CD9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210901132547.GB22278@shell.armlinux.org.uk>
 <DB8PR04MB6795BB2A13AED5F6E56D08A0E6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210902083224.GC22278@shell.armlinux.org.uk>
 <DB8PR04MB67954F4650408025E6D4EE2AE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210902104943.GD22278@shell.armlinux.org.uk>
In-Reply-To: <20210902104943.GD22278@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: andrew@lunn.ch
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3fbf19c-0259-440c-7384-08d96e030188
x-ms-traffictypediagnostic: DB6PR04MB3205:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR04MB320552158C82FE50921E5CB3E6CE9@DB6PR04MB3205.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dBXiSFoiFcm1QdVR1JZrSSnOQqlHZtdAV88XzcBxchvNpx7uG0MRyu5ZHt9kL20U7/kv8YTHHOkyw/cavesKm903HEWqxQQNeWzhTK4INa+KF3LC3wKRKiOECe8ocUE4s8AlVujnVzZlSkMr9l2jZvrd+cSgP7J6CVI2DoNCoGrrZB3b345tLYFwTM0THATbx7whyyfVP3+Pv8EdyVHLKFrDMlSw74JQAZEe/MdaDaV0GGFGLawFMXo07zSnEMtAyXlxjFtJrETSsAvzNCO66fcM4x4m3n26AghgAPng4jPlZuoouANWkAjfWatNd2XOxd4jv9/sb+ZO3hhcpoG2gvMRENN9Ci29glDeyKi1sPiFndZiSTAV40T7XyRGvu0Y0uNzBMTSBCB2aZxvt8ySTdVpa2GTmzYy8U4kITHQNy9aYxpsI1p5dp1HHbYJRPNBviWIsnExV+1/zhRY1obFCI9DNi8c7OHp5nOFESndSwusmvqquFYuZuii/SjEx0LoasViMDHDsMs4/vYs4sqmxDp66MBhdrSgLX7fMe1HM41uhmZhhUEcQSBEYsXhMQRrSj4gj116HQGoHpyYdj3JH5MUd6R8+lPS0srqn86e1JBR3lJ2c38k+xpgJ6JQ6akntzngfhTZVCdXrwENAvry63vQXpEkgYyY3VcOvhrbCPsAUiE2YzgpZ+f/8rf+i0rLpzv/g4gTytNSLPYkEuO6gg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39850400004)(376002)(396003)(136003)(33656002)(2906002)(83380400001)(110136005)(53546011)(122000001)(54906003)(6506007)(26005)(186003)(8676002)(478600001)(7416002)(316002)(38100700002)(55016002)(7696005)(76116006)(66946007)(66446008)(38070700005)(71200400001)(66556008)(66476007)(4326008)(5660300002)(64756008)(52536014)(86362001)(9686003)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?M3E5VU8xOUlqWmwvR3J6QlN6bmNEb2Z0ZW51dlJGTzBsKzcwUGRCQWtsMmow?=
 =?gb2312?B?QTBudjFwMTFDd1lyYXo3WGMwVk5IeVZzZVkvSzV2V0h3MUlONnBGbGhPOU1Z?=
 =?gb2312?B?TjVWdDVlSWNQUm94WVcxNldtSE5tZFBTbE9Ob0V0WUEwdWtmUzRnekFGU2FK?=
 =?gb2312?B?dFlMbjdVKzBwNHpnWW1RZlJPQVBXZkJ1NW11RU8xSEl5MUZ3K1I4TzNibkFE?=
 =?gb2312?B?d3BGYm5HUm1sTGh3UEowSFZHb0NTbmxidUl6SHdsdXN6SUdQOXRWaFFkTlBp?=
 =?gb2312?B?Q0xEbzBHaTIvWlEzWGk2SS9ZaGxrWUZ4WlhsYTlJZFRIVktjZXJjRllUSitF?=
 =?gb2312?B?U0ZYQzE3aERXeDkvekFRd1h2RlVlclR2Mm5RanV3WGEwbmRQTWNtc24wa2RZ?=
 =?gb2312?B?RXAydmtDM1NmM0NZL29zenhuVUZncmNFRFYydSt6OE1RZEx3NGk1MFlSeU11?=
 =?gb2312?B?cGxwNnNYdndUUHNHTEhHaWVHU3RKMXdIV3JNNHBGTi9uSVNwaFZ0N1JJczAx?=
 =?gb2312?B?ZnV5WnFicDU5RUZZdnhTZFhSUWI2SUZJaGpnUkErTitNbXpjREJTODl6YVJk?=
 =?gb2312?B?NGJUVFpoT1V1b1piV09NeXIvYm5TKy9vdUo2VktKSHlJMVBvLzJpN0xpdys4?=
 =?gb2312?B?cmhTaXplenQ5SnpWSk51RFAxWWlTTzJrbWdMTlkwVkowWkh0VkZqenJpTVFG?=
 =?gb2312?B?WDdidmZsNlczM0IwaDYxTU05UUwvTDVIc3cwNXZVa2V1d3BZU0xrWmNUSnZv?=
 =?gb2312?B?aWJqS0RmQktjb25ENEZKRTdyVU9zWHJzeHl0a0cya283N0FiS1dTbDYxSjdx?=
 =?gb2312?B?Ykg2MDJCSzNoNE9ySjdTdzRXMkpleFNlU0VrT3o2d3RPSUdka3IySVlrMjMy?=
 =?gb2312?B?M2J0UkRMeE1jL21mMkdHUTk3UVRJOEV3WTkxLzVRaDlTNDF1SDZkVXB6U1pJ?=
 =?gb2312?B?VDhuVHQ3VHJLcWdxV2ZQdk9kOTZpUE9ORE1veDk1V3FueEZEd29IOXpZQWhj?=
 =?gb2312?B?alZZRkNuMVZVS3ZXdTEzMzYwUlRjK1p6bExEN2FVSm9LSUFNK0ZDM0loWVJh?=
 =?gb2312?B?Y1B2UFhwcDVBS0FIQzh5VGtJRUpsNDVZaEl3UjdnZHNiWk5OR1VDbXNIWGdo?=
 =?gb2312?B?ZEhqVnFzVDh2UHFyYmxvcS9ZZ0lQNWxhNk93VVNZYmZoMVd2Z2NsMXNnYy9n?=
 =?gb2312?B?Y0VqMkowY0JwNnFXY1piaERNdmVRVFU1WUhwazYySzhvb1dZd3RRM2FMSGJ2?=
 =?gb2312?B?YWw4UzA3anlvdHY3dU9leFRveVJxZUdVMmVRUVlHTE9aRmY1UGM2QmN4ODRx?=
 =?gb2312?B?ZjY0ZkFaWndlTUFHam8vbEJRUVk2d3pmc1QrWDA5bG9abmtnczdIVElOdlQ4?=
 =?gb2312?B?WUNsNE5HODFjeG9qSnlPSU45cm1IckZUN0E0MEs3YXhYQ2NZWHJ5OTB3UlpV?=
 =?gb2312?B?cXFHQmp4QjZ1djlyczczU09VT0Q4eUFKc3NTQkQ0UFFTTk42YjFUNGtrZE5q?=
 =?gb2312?B?c0Y2NCtBd0RXM3E1OVhkQ1h5Tit0YnoraW1xNTNtSEJJZGttQUlFeUR1RjJD?=
 =?gb2312?B?NElJVkNxeFZ4UUZQblpDT0hrZUtLcjUwNUp6ZVcyeEphd2NsRE5HNmdtOGpN?=
 =?gb2312?B?ZHFnVm5TMEl1MU5zclUrNEVvWkxXdG5HMjNvdUxFR2tRWVdNSjZwWDNhNGpH?=
 =?gb2312?B?YUUydTlTb0srbnQ0MUVQVlNVdDRIWTQ1T3pyZFRZazVOUTVDM1dPMVRNakRs?=
 =?gb2312?Q?NugVG6DW/wlpONo5/v9kRDmPxJZ0r2OdNvu3qXq?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3fbf19c-0259-440c-7384-08d96e030188
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 11:15:43.7082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NxJxnMbJ6SL13s2xfUnIX6ZWtzP1sWiO3jf5Aor/iPctFofU84qlVM3zV2t8Xfbiyf7dAV2rMOHLlLIIR09QkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3205
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBSdXNzZWxsLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJ1
c3NlbGwgS2luZyA8bGludXhAYXJtbGludXgub3JnLnVrPg0KPiBTZW50OiAyMDIxxOo51MIyyNUg
MTg6NTANCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IENj
OiBWbGFkaW1pciBPbHRlYW4gPG9sdGVhbnZAZ21haWwuY29tPjsgcGVwcGUuY2F2YWxsYXJvQHN0
LmNvbTsNCj4gYWxleGFuZHJlLnRvcmd1ZUBmb3NzLnN0LmNvbTsgam9hYnJldUBzeW5vcHN5cy5j
b207DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgbWNvcXVlbGluLnN0
bTMyQGdtYWlsLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgYW5kcmV3QGx1bm4uY2g7
IGYuZmFpbmVsbGlAZ21haWwuY29tOw0KPiBoa2FsbHdlaXQxQGdtYWlsLmNvbTsgZGwtbGludXgt
aW14IDxsaW51eC1pbXhAbnhwLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gbmV0OiBzdG1t
YWM6IGZpeCBNQUMgbm90IHdvcmtpbmcgd2hlbiBzeXN0ZW0gcmVzdW1lDQo+IGJhY2sgd2l0aCBX
b0wgZW5hYmxlZA0KPiANCj4gT24gVGh1LCBTZXAgMDIsIDIwMjEgYXQgMTA6MjY6MTNBTSArMDAw
MCwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+DQo+ID4gSGkgUnVzc2VsbCwNCj4gPg0KPiA+IFRo
YW5rcyBhIGxvdCENCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+
IEZyb206IFJ1c3NlbGwgS2luZyA8bGludXhAYXJtbGludXgub3JnLnVrPg0KPiA+ID4gU2VudDog
MjAyMcTqOdTCMsjVIDE2OjMyDQo+ID4gPiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3Fpbmcuemhh
bmdAbnhwLmNvbT4NCj4gPiA+IENjOiBWbGFkaW1pciBPbHRlYW4gPG9sdGVhbnZAZ21haWwuY29t
PjsgcGVwcGUuY2F2YWxsYXJvQHN0LmNvbTsNCj4gPiA+IGFsZXhhbmRyZS50b3JndWVAZm9zcy5z
dC5jb207IGpvYWJyZXVAc3lub3BzeXMuY29tOw0KPiA+ID4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsg
a3ViYUBrZXJuZWwub3JnOyBtY29xdWVsaW4uc3RtMzJAZ21haWwuY29tOw0KPiA+ID4gbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgYW5kcmV3QGx1bm4uY2g7IGYuZmFpbmVsbGlAZ21haWwuY29tOw0K
PiA+ID4gaGthbGx3ZWl0MUBnbWFpbC5jb207IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5j
b20+DQo+ID4gPiBTdWJqZWN0OiBSZTogW1BBVENIXSBuZXQ6IHN0bW1hYzogZml4IE1BQyBub3Qg
d29ya2luZyB3aGVuIHN5c3RlbQ0KPiA+ID4gcmVzdW1lIGJhY2sgd2l0aCBXb0wgZW5hYmxlZA0K
PiA+ID4NCj4gPiA+IE9uIFRodSwgU2VwIDAyLCAyMDIxIGF0IDA3OjI4OjQ0QU0gKzAwMDAsIEpv
YWtpbSBaaGFuZyB3cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4gSGkgUnVzc2VsbCwNCj4gPiA+ID4N
Cj4gPiA+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gPiA+IEZyb206IFJ1
c3NlbGwgS2luZyA8bGludXhAYXJtbGludXgub3JnLnVrPg0KPiA+ID4gPiA+IFNlbnQ6IDIwMjHE
6jnUwjHI1SAyMToyNg0KPiA+ID4gPiA+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFu
Z0BueHAuY29tPg0KPiA+ID4gPiA+IENjOiBWbGFkaW1pciBPbHRlYW4gPG9sdGVhbnZAZ21haWwu
Y29tPjsgcGVwcGUuY2F2YWxsYXJvQHN0LmNvbTsNCj4gPiA+ID4gPiBhbGV4YW5kcmUudG9yZ3Vl
QGZvc3Muc3QuY29tOyBqb2FicmV1QHN5bm9wc3lzLmNvbTsNCj4gPiA+ID4gPiBkYXZlbUBkYXZl
bWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7DQo+IG1jb3F1ZWxpbi5zdG0zMkBnbWFpbC5jb207
DQo+ID4gPiA+ID4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgYW5kcmV3QGx1bm4uY2g7IGYuZmFp
bmVsbGlAZ21haWwuY29tOw0KPiA+ID4gPiA+IGhrYWxsd2VpdDFAZ21haWwuY29tOyBkbC1saW51
eC1pbXggPGxpbnV4LWlteEBueHAuY29tPg0KPiA+ID4gPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0hd
IG5ldDogc3RtbWFjOiBmaXggTUFDIG5vdCB3b3JraW5nIHdoZW4NCj4gPiA+ID4gPiBzeXN0ZW0g
cmVzdW1lIGJhY2sgd2l0aCBXb0wgZW5hYmxlZA0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gVGhpcyBt
ZWFucyB5b3UgbmVlZCB0byBoYXZlIHRoZSBwaHkgPC0+IG1hYyBsaW5rIHVwIGR1cmluZw0KPiA+
ID4gPiA+IHN1c3BlbmQsIGFuZCBpbiB0aGF0IGNhc2UsIHllcywgeW91IGRvIG5vdCB3YW50IHRv
IGNhbGwNCj4gPiA+ID4gPiBwaHlsaW5rX3N0b3AoKSBvciBwaHlsaW5rX3N0YXJ0KCkuDQo+ID4g
PiA+DQo+ID4gPiA+IEkgaGF2ZSBhIHF1ZXN0aW9uIGhlcmUsIHdoeSBuZWVkIHRvIGhhdmUgdGhl
IHBoeTwtPm1hYyBsaW5rIHVwDQo+ID4gPiA+IGR1cmluZw0KPiA+ID4gc3VzcGVuZD8NCj4gPiA+
DQo+ID4gPiBZb3UgbmVlZCB0aGUgbGluayB1cCBiZWNhdXNlIEkgdGhpbmsgZnJvbSByZWFkaW5n
IHRoZSBjb2RlLCBpdCBpcw0KPiA+ID4gX25vdF8gdGhlIFBIWSB0aGF0IGlzIHRyaWdnZXJpbmcg
dGhlIHdha2V1cCBpbiB0aGUgY29uZmlndXJhdGlvbiB5b3UgYXJlDQo+IHVzaW5nLCBidXQgdGhl
IE1BQy4NCj4gPiA+DQo+ID4gPiBJZiB0aGUgbGluayBpcyBkb3duLCB0aGUgUEhZIGNhbid0IHBh
c3MgdGhlIHJlY2VpdmVkIHBhY2tldCB0byB0aGUNCj4gPiA+IE1BQywgYW5kIHRoZSBNQUMgY2Fu
J3QgcmVjb2duaXNlIHRoZSBtYWdpYyBwYWNrZXQuDQo+ID4NCj4gPiBQZXIgbXkgdW5kZXJzdGFu
ZGluZywgaWYgdXNlIFBIWS1iYXNlZCB3YWtldXAsIFBIWSBzaG91bGQgYmUgYWN0aXZlLA0KPiA+
IGFuZCBNQUMgY2FuIGJlIHRvdGFsbHkgc3VzcGVuZGVkLiBXaGVuIFBIWSByZWNlaXZlIHRoZSBt
YWdpYyBwYWNrZXRzLA0KPiA+IGl0IHdpbGwgZ2VuZXJhdGUgYSBzaWduYWwgdmlhIHdha2V1cCBQ
SU4gKFBIWSBzZWVtcyBhbGwgaGF2ZSBzdWNoIFBJTikgdG8NCj4gaW5mb3JtIFNvQywgd2UgY2Fu
IHVzZSB0aGlzIHRvIHdha2UgdXAgdGhlIHN5c3RlbS4NCj4gPiBQbGVhc2UgY29ycmVjdCBtZSBp
ZiBJIG1pc3VuZGVyc3RhbmQuDQo+IA0KPiBDb3JyZWN0Lg0KPiANCj4gPiA+IEZFQyBkb2Vzbid0
IGhhdmUgdGhpcy4gRkVDIHJlbGllcyBwdXJlbHkgb24gdGhlIFBIWSBkZXRlY3RpbmcgdGhlDQo+
ID4gPiBtYWdpYyBwYWNrZXQsIHdoaWNoIGlzIG11Y2ggbW9yZSBwb3dlciBlZmZpY2llbnQsIGJl
Y2F1c2UgaXQgbWVhbnMNCj4gPiA+IHRoZSBNQUMgZG9lc24ndCBuZWVkIHRvIGJlIHBvd2VyZWQg
dXAgYW5kIG9wZXJhdGlvbmFsIHdoaWxlIHRoZSByZXN0IG9mDQo+IHRoZSBzeXN0ZW0gaXMgc3Vz
cGVuZGVkLg0KPiA+DQo+ID4gQUZBSUssIEZFQyBhbHNvIHVzZSB0aGUgTUFDLWJhc2VkIHdha2V1
cCwgd2hlbiBlbmFibGUgRkVDIFdvTCBmZWF0dXJlLA0KPiA+IGl0IHdpbGwga2VlcCBNQUMgcmVj
ZWl2ZSBsb2dpYyBhY3RpdmUsIFBIWSBwYXNzIHRoZSByZWNlaXZlZCBwYWNrZXRzDQo+ID4gdG8g
TUFDLCBpZiBNQUMgZGV0ZWN0cyB0aGUgbWFnaWMgcGFja2V0cywgaXQgd2lsbCBnZW5lcmF0ZSBh
biBpbnRlcnJ1cHQgdG8NCj4gd2FrZSB1cCB0aGUgc3lzdGVtLg0KPiANCj4gWW91J3JlIHJpZ2h0
Lg0KPiANCj4gSG93ZXZlciwgYXMgdGhlIFBIWSBpcyBub3QgY29uZmlndXJlZCBmb3IgV29MIHdp
dGggRkVDLCBhbmQNCj4gZmVjX3N1c3BlbmQoKSB1bmNvbmRpdGlvbmFsbHkgY2FsbHMgcGh5X3N0
b3AoKSB3aGljaCB3aWxsIHBsYWNlIHRoZSBQSFkgaW50bw0KPiBzdXNwZW5kIG1vZGUuIA0KDQpO
bywgcGh5bGliIGhhcyBtdWNoIGxvZ2ljIHRvIGF2b2lkIHB1dHRpbmcgUEhZIGludG8gc3VzcGVu
ZGVkIHN0YXRlIGlmIGVpdGhlciBNQUMgb3INClBIWSBXb0wgYWN0aXZlLiBTdWNoIGFzIGluIHBo
eV9zdXNwZW5kKCksDQoJaWYgKHdvbC53b2xvcHRzIHx8IChuZXRkZXYgJiYgbmV0ZGV2LT53b2xf
ZW5hYmxlZCkpDQoJCXJldHVybiAtRUJVU1k7DQoNCk9yIGluIG1kaW9fYnVzX3BoeV9tYXlfc3Vz
cGVuZCgpLi4uDQoNCj4gTWF5YmUgdGhlIFBIWSBkcml2ZXIgdGhlcmUgaGFzIGEgTlVMTCBwaHlk
cnYtPnN1c3BlbmQNCj4gbWV0aG9kPyBIb3dldmVyLCBJIHNlZSB0aGF0IGF0ODAzeCBoYXMgc3Vz
cGVuZCBtZXRob2RzICh3aGljaCBJIGJlbGlldmUgaXMNCj4gdGhlIFBIWSB0aGF0IGdldHMgdXNl
ZCB3aXRoIGkuTVggcHJvZHVjdHMpIHdoaWNoIHdpbGwgcG93ZXIgZG93biB0aGUgUEhZLg0KDQpZ
ZXMsIHdlIGhhdmUgbWFueSBib2FyZHMgdXNlIEFSODAzMSBQSFksIGFuZCBhbGwgc3VwcG9ydCBN
QUMtYmFzZWQgd2FrZXVwIGZlYXR1cmUuDQoNCj4gU28sIGhvdyBkb2VzIHRoaXMgd29yayB3aXRo
IEZFQyAtIGJlY2F1c2UgcmlnaHQgbm93IEkgY2FuJ3Qgc2VlIGl0IHdvcmtpbmcsIGJ1dA0KPiB5
b3Ugc2F5IGl0IGRvZXMuDQo+DQo+IEkgdGhpbmsgd2UgbmVlZCB0byB1bmRlcnN0YW5kIGhvdyBG
RUMgaXMgd29ya2luZyBoZXJlLCBhbmQgd2UgbmVlZCBhIGRlZXBlcg0KPiB1bmRlcnN0YW5kaW5n
IHdoeSBzdG1tYWMgaXNuJ3Qgd29ya2luZy4NCg0KRW1tLCBAYW5kcmV3QGx1bm4uY2gsIEFuZHJl
dyBpcyBtdWNoIGZhbWlsaWFyIHdpdGggRkVDLCBhbmQgUEhZIG1haW50YWluZXJzLA0KQ291bGQg
eW91IHBsZWFzZSBoZWxwIHB1dCBpbnNpZ2h0cyBoZXJlIGlmIHBvc3NpYmxlPw0KDQo+IEkgZG9u
J3QgaGF2ZSBhbnkgaU1YIHN5c3RlbXMgdGhhdCBzdXBwb3J0IFdvTCwgc28gdGhpcyBpc24ndCBz
b21ldGhpbmcgSSBjYW4NCj4gdGVzdC4gKFNvbGlkUnVuJ3MgaS5NWCBwbGF0Zm9ybXMgZG8gbm90
IHN1cHBvcnQgYW55IGtpbmQgb2Ygc3lzdGVtIHBvd2VyIGRvd24sDQo+IHNvIHN1c3BlbmQgaXNu
J3Qgc3VwcG9ydGVkLikNCg0KVW5kZXJzdG9vZCwgdGhhbmtzLg0KDQpCZXN0IFJlZ2FyZHMsDQpK
b2FraW0gWmhhbmcNCg==
