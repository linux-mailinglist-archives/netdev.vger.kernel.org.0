Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6664401A01
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 12:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242000AbhIFKm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 06:42:56 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:1665
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233253AbhIFKmz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 06:42:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijkXY/m723tyHUcy7og+n1ngfBSvSkjsXuWZEwByiHXoAgvvCQ/7ov3mphbP5iiqA4AZuVb5kJpOgetWn3bglSBeW6c58fyLWNK56KqcOBo+6Y5GmHszc8ejAo7xsi5b4U2WEPkP4f+g6uQ0ae8b0fh/smzxTN0yU4lNdK6WgOvoOXmJaitlviSPBvUVAkQi6W2REaBSf0QQ5BEWyWN+rNfAfqf6s46cVLIr16DUg0V5r2kOn0qsgj24QmL/UIZrXLablU1nPfyM38Wu0NbGtKQZEq+mC9zQAUFShl3sUe2jIYh4YaCZn3J3DH1NUNyhi0JNUlPGgnWOwFuwZqNEug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cVWYkbwavoh3/dRRSoMVIu5pkpIpy1NiPWyzRUtmAFQ=;
 b=lG/P1Rkoer/3rz0kwQjRVZ25d/iQLyZzuVMpsdJsaVQUuMFHfyJAldwziK0kiTgDN1ayHl5I3RYF2VWYfSs2kw/aljAfmX4v8qACYtV06R4H1R7af5YzS1i8wyw5WOO0GMFbpuic7IWO028YQCwJ6Ufyluq8KVTtpcY8UbFfZQXJ8eAd8SqWgjzLloQGIvI6S2m3rVfPqi4/PqzMkgrrd6vlpm8RMlp0bck8aWzJDvZpjMSjbanDwmacKnQgcI0PB6JAEf7W70OZcVHNakDJT+mqrUG35E0rJCYhRbSrzqk4zAkuGzZBru4nzJ6dVPN+MMWACxTLIocl9E73TvTnPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cVWYkbwavoh3/dRRSoMVIu5pkpIpy1NiPWyzRUtmAFQ=;
 b=j/IaokNOj+cAVjLBxQpw6UR8ngfe/50VgaFqcZN8J2MZqEYl/8HK+VKlt1F5migJLM8q/cso0BFcxUrSt0J4S9pphkCQlpk8m4Lnbm0d0Ry8u3WevVR/AKJfpvzfxWiHLuIwB2MaegZ+MEf0Jxda0OZVE50SJ8dfdYJVlgQF5Js=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7770.eurprd04.prod.outlook.com (2603:10a6:10:1ed::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Mon, 6 Sep
 2021 10:41:48 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f%9]) with mapi id 15.20.4478.025; Mon, 6 Sep 2021
 10:41:48 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
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
Thread-Index: AQHXnxAXiWCMYvQkY0qCXzBIAPLPn6uO53WAgAAPWNCAAAsFgIAACEPggAAhioCAAQx9sIAAM98AgAAW9HCAAA9qgIAAAa+AgAAYrQCAAOF04IAAZ5oAgAAFMvCAABQ5AIAADizAgAAbXoCAAIkbAIADjA8ggAB4yACAAA3QoA==
Date:   Mon, 6 Sep 2021 10:41:48 +0000
Message-ID: <DB8PR04MB67958E22A85B15FFCA7CDA70E6D29@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <DB8PR04MB6795C37D718096E7CA1AA72DE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YTDCZN/WKlv9BsNG@lunn.ch>
 <DB8PR04MB6795C36B8211EE1A1C0280D9E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903080147.GS22278@shell.armlinux.org.uk>
 <DB8PR04MB679518228AB7B2C5CD47A1B3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903093246.GT22278@shell.armlinux.org.uk>
 <DB8PR04MB6795EE2FA03451AB5D73EFC3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903120127.GW22278@shell.armlinux.org.uk>
 <20210903201210.GF1350@shell.armlinux.org.uk>
 <DB8PR04MB6795FC58C1D0E2481E2BC35EE6D29@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YTXgqBRMRvYdPyJU@shell.armlinux.org.uk>
In-Reply-To: <YTXgqBRMRvYdPyJU@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd5c013f-8f38-4d5c-e9c3-08d97122ee05
x-ms-traffictypediagnostic: DBBPR04MB7770:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB7770F433692379D284833356E6D29@DBBPR04MB7770.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r/GDn0p3SvfPCYTXaoOWiGVqEcHVXjTdqJUCNdCg8yaSKMNbF3tYnvQFMJm+q/pYX/aJteq8ROOU39DwSZfQOnIQFAhLq7MdP/rk097+44qu0thHALYDEeOK6WVFOgcmPjUXNMfN3HsP0OigsMkdUAA/fM502FzYXCxhwLHEzOzRclGEP6HrMTPGSe+ayFQYNhlYPc4J8WKl50c82V/mwZtBy5AkM7P4y2fligsDPmJHYV77P0qE0XVon3taQDaGDM9H2B+UBpeThQVZfcLL0Od2EOxSFs6wSTmbQrvYUJ38iCXlnwZIX/+msXwW0FfSaM56UnOnrVk00LVV7JjWZ+O1nr9JR7lwCAjgfE0AGIwuXMemj7/Kqo7cQ3ORra4wS0w2fn+0pqUK3Z8fuTcV3h7xPKxdCtg2muCAtYUAnhDfPRYsQelp5feam4btEj37w7SRfpBeD1Yhuv8JZfrmldfxDkzFrTXuQJeUm18GwAEg0DEpet7Fp+iz/DgtzUdo09EcI9WapYqum4aHNuXaI55Fq2/86QL5qT+uFjYq4nWGzXZuwPIeF7wK33D2AhAdgQ/HEXc8NzKeuXyTRtIumQ9xq7/4fGohmZw9t+Ysc/4zg63hjF02TREufHTu9h8R5VL5e6eMTHcW2Ea1eNnrz9YlR18jZIpzhekvBQpAbYrAu0pfuEgjrR+4Yt6m5XmpOP9LreFQZaOXE5/A/UYPbQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(64756008)(38070700005)(71200400001)(66446008)(4326008)(76116006)(122000001)(83380400001)(53546011)(6506007)(66476007)(38100700002)(86362001)(316002)(54906003)(55016002)(7696005)(2906002)(66556008)(66946007)(33656002)(478600001)(5660300002)(52536014)(8676002)(8936002)(6916009)(186003)(26005)(7416002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?M3QyMUR0aWtNdkt0WmpBUmh3Uzc1anc2RGF3QVpFNWRSVkZCbTM5RW5rTzJz?=
 =?gb2312?B?UGN3UXh3bk9rcHpMc0I1UTFpblQrMm81UXVLZGtaTGhoSTUyRmx6Y0p6YkxU?=
 =?gb2312?B?SzlpejN6alF3VnNFMmVDTE5WZDRlWHo1SzFENlVQS1g2NzhPbmFBK2VSZ1RR?=
 =?gb2312?B?OUVhbng0aThLMkpUVWlqdDhEUmZKSWtMa21LR2xjYmlNYTJSZ0dGRVZXOUtQ?=
 =?gb2312?B?eldmNk1ESzZGTm8zRzVQd0RrQXVja05TTEt0R08rdThpdUxkOG1YT25WNmhQ?=
 =?gb2312?B?ZnRSK0hnaGZOWFB5enFoUHBmRmJlRkRrbGxha09aZzB3Vy9veEsrbG5WeXNV?=
 =?gb2312?B?QlVNOXBrdnJkU3VjRTZ0b3lrSGQrS3NWOWY0ZG9iSUxkdFVCamNsQ3pNdkZ5?=
 =?gb2312?B?R2tYZndnYUQzQTEwcEFhdi9Ra3RSTm9tTzdubE9aZndHRTFkM3g5WEExTStO?=
 =?gb2312?B?VWlvbXNHei91RERLNGJSOHFYNFBueGdKSzVCazlyZVZWWXBYYjRkSGJUWXZi?=
 =?gb2312?B?dnl3L1o4V3g4WUpMTVg1TmJpcDR1UXdXTEQ5U05pS2xiYWt0M0JPZWU3UHFY?=
 =?gb2312?B?aEZuV3BhdXBZL0NYWFVuQVlGekcvRy9hRUFldllSZ1k1aDZmbVVDMm5TL0lX?=
 =?gb2312?B?S0orTnVJQkVVaEQ0UHh0Z0xUY1lYUVl0cmorMVhZKzRpNnphU3VxNCtrelZT?=
 =?gb2312?B?WE92bzhYODBUR2YwbXBEdlEzOTArQlJQelIvUWc0VnRhQWpvV2NiSDcyRmo5?=
 =?gb2312?B?NXpQQ21YbndodklvZXVNSVEvUlB3REphR3Z3dzNrRlJEMlF3c3ltQ2VyTldw?=
 =?gb2312?B?TXBieUxJWlJ0RmlKbFlJTllOTHZLV0puOVJTYUt2dFNJMml6V05sZFpYZ3hU?=
 =?gb2312?B?NURUMmdQWDllRlJvOXNuYmJTV0FVNHZ2UjNjV2dYUW5jdEM0ZjA2R1hoeTA1?=
 =?gb2312?B?ZjBaQ1NvZ083N2hpZ1JMMjRMcmlacWxPazVXRStQV01BSkMyZ0lXRXdZNjdH?=
 =?gb2312?B?MTJvdkd0aWFWaXRIaDdKbnVLdTlrNFRNMDZkUGkxYzkxYjhDVXkrQ3YyNFl2?=
 =?gb2312?B?VnhLTzl5c252MW1YSFFQaDlpcjRKVi82ajlOVFF4d01oZDRDeFhXd042SUZ5?=
 =?gb2312?B?UFp3NTNXc2o0VnBWR3l1aS9naFNCUlE2QTVodkFUODVRUUIzUmo4MHMwS1Vi?=
 =?gb2312?B?YVNYN05mbzhhNHNzWmJWcnVoSHlIaE9BbnB2RXhnQndFdDFobUNQRTZvdjdI?=
 =?gb2312?B?N0pJOHFucUFzZnBlTzlDWVllRjF5VmR1S0ViUUVTNERkSjd5M3IwZW81OFlX?=
 =?gb2312?B?bUdzVldMNGpEK0Vqa0kxcHp5OWNYUlRUeW5WM2ZCaXZ1LzdraGh6THY3aHJF?=
 =?gb2312?B?TUV3VjErLzRqbjBUeWdiMkpiR3UzWG9tbkU0L3FkcVF2c2hodVlFUTA4cWhJ?=
 =?gb2312?B?ZzdUcTBUb3dIZG1Cd3JPZTBWV0hmRVVEaWlZVXk1dlZhZG1BdTE1VGN3V2xX?=
 =?gb2312?B?b3pwNE00a0NMNGYrUVVhTzQycThEaWtOMEhySDU4U0s0YzhhRzYrNWw2SW93?=
 =?gb2312?B?bEU4TlVrRk05R2NsUVZpWjN4Z3ZYb0Q1d1Y5QXNBTkF3WUNDK2pvQWpvVGdz?=
 =?gb2312?B?ZWlCdW5QcjRQbmYzbmcwLy94V0pNQUZLeDR3TGttQ3Z0ckxFeUw4T0pqOWIr?=
 =?gb2312?B?bDdHK0Z5eE9mSEdJbDZRblczeFJvdEh5ekxKTUE5OXJERnJueU0xcVRpVk9P?=
 =?gb2312?Q?e1qnvY07863CvnaiOXRN5/ESg0uY/uuDFed6UqL?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5c013f-8f38-4d5c-e9c3-08d97122ee05
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2021 10:41:48.4393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LCd45q0fAQjRvov9zjS8Xltq7IWKBj25VDUFKIfqIsWnnabIWbjCnQ6XNxIJbRZEO24vMEP7N1fmpyHNqM12eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7770
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBSdXNzZWxsLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJ1
c3NlbGwgS2luZyA8bGludXhAYXJtbGludXgub3JnLnVrPg0KPiBTZW50OiAyMDIxxOo51MI2yNUg
MTc6MzUNCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IENj
OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBWbGFkaW1pciBPbHRlYW4gPG9sdGVhbnZA
Z21haWwuY29tPjsNCj4gcGVwcGUuY2F2YWxsYXJvQHN0LmNvbTsgYWxleGFuZHJlLnRvcmd1ZUBm
b3NzLnN0LmNvbTsNCj4gam9hYnJldUBzeW5vcHN5cy5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
IGt1YmFAa2VybmVsLm9yZzsNCj4gbWNvcXVlbGluLnN0bTMyQGdtYWlsLmNvbTsgbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZzsgZi5mYWluZWxsaUBnbWFpbC5jb207DQo+IGhrYWxsd2VpdDFAZ21haWwu
Y29tOyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BB
VENIXSBuZXQ6IHN0bW1hYzogZml4IE1BQyBub3Qgd29ya2luZyB3aGVuIHN5c3RlbSByZXN1bWUN
Cj4gYmFjayB3aXRoIFdvTCBlbmFibGVkDQo+IA0KPiBIaSwNCj4gDQo+IE9uIE1vbiwgU2VwIDA2
LCAyMDIxIGF0IDAyOjI5OjMwQU0gKzAwMDAsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiBIaSBS
dXNzZWxsLA0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gKwkJ
LyogUmUtYXBwbHkgdGhlIGxpbmsgcGFyYW1ldGVycyBzbyB0aGF0IGFsbCB0aGUgc2V0dGluZ3Mg
Z2V0DQo+ID4gPiArCQkgKiByZXN0b3JlZCB0byB0aGUgTUFDLg0KPiA+ID4gKwkJICovDQo+ID4g
PiArCQlwaHlsaW5rX21hY19pbml0aWFsX2NvbmZpZyhwbCwgdHJ1ZSk7DQo+ID4gPiArCQlwaHls
aW5rX2VuYWJsZV9hbmRfcnVuX3Jlc29sdmUocGwsDQo+IFBIWUxJTktfRElTQUJMRV9NQUNfV09M
KTsNCj4gPg0KPiA+IFRoZXJlIGlzIG5vICJwaHlsaW5rX2VuYWJsZV9hbmRfcnVuX3Jlc29sdmUg
IiBzeXNib2wsIEkgZ3Vlc3MgeW91IHdhbnQgZG8NCj4gYmVsb3cgb3BlcmF0aW9ucyBpbiB0aGlz
IGZ1bmN0aW9uOg0KPiA+IAljbGVhcl9iaXQoUEhZTElOS19ESVNBQkxFX01BQ19XT0wsICZwbC0+
cGh5bGlua19kaXNhYmxlX3N0YXRlKTsNCj4gPiAJcGh5bGlua19ydW5fcmVzb2x2ZShwbCk7DQo+
IA0KPiBZZXMsIHRoYXQgaXMgY29ycmVjdC4NCj4gDQo+IFBsZWFzZSBsZXQgbWUga25vdyB3aGV0
aGVyIHRoYXQgd29ya3MgZm9yIHlvdS4NCg0KVGhhbmtzIFJ1c3NlbGwsIGl0IHdvcmtzIGFzIHdl
IGFyZSBleHBlY3RlZCwgSSB0ZXN0IGJvdGggTUFDLWJhc2VkIFdvTCBhY3RpdmUgYW5kIGluYWN0
aXZlIGNhc2VzLg0KDQpBbmQgSSBnZXQgdGhlIHBvaW50IHlvdSBtZW50aW9uZWQgYmVmb3JlLCBp
ZiBsaW5rIHBhcmFtZXRlcnMgY2hhbmdlZCBkdXJpbmcgc3lzdGVtIHN1c3BlbmRlZCwgd2hhdCB3
b3VsZCBoYXBwZW4/DQpJIHRyaWVkIGJvdGggRkVDIGFuZCBTVE1NQUMsIHRoZSBzeXN0ZW0gY2Fu
J3QgYmUgd2FrZWQgdXAgdmlhIHJlbW90ZSBtYWdpYyBwYWNrZXRzISEhDQpJIGhhdmUgbm90IHRo
aW5rIGFib3V0IHRoaXMgc2NlbmFyaW8gYmVmb3JlLi4uLg0KDQpTaW5jZSBuZXQtbmV4dCBpcyBj
bG9zZWQsIHNvIEkgd291bGQgY29vayBhIHBhdGNoIHNldCAoa2VlcCB5b3UgYXMgdGhlIHBoeWxp
bmsgcGF0Y2ggYXV0aG9yKSBhZnRlciBpdCByZS1vcGVuLCBjb3VsZCB5b3UNCmFjY2VwdCBpdD8g
T3IgeW91IHBsYW4gdG8gcHJlcGFyZSB0aGlzIHBhdGNoIHNldCBmb3Igc3RtbWFjPw0KDQpUaGVy
ZSBpcyBhbHNvIGEgcHJvYmxlbSwgd2UgbmVlZCBhIGZpeCBmb3IgTFRTICg1LjEwLCA1LjE1KSwg
YWJvdmUgcGF0Y2ggc2V0IHNob3VsZCBnbyB0byA1LjE2LCBkbyB5b3UgaGF2ZSBhbnkgc3VnZ2Vz
dGlvbj8NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo=
