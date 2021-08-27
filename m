Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5543F9474
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 08:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244289AbhH0GhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 02:37:06 -0400
Received: from mail-eopbgr1410097.outbound.protection.outlook.com ([40.107.141.97]:42334
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229611AbhH0GhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 02:37:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LYyolpN6j8XbUpguMndxOil7NhccGKLSdmZJt8lRkO9BOwjMP2OouwtwsqV3z/QLfHtYEo6ZhQPxoxpfxzvRXkXXTUP8/mZpSvkGHxZzhwm2At0oM7vtgKa8l32aRKxid841pg9ekR/Iv20uzyU97stSlYcyl+SBrT+LEK1uFx3INqzYursxASLlY9dmnLAneX+Z4/XR35SmNUuRlIeste1gyfCPgn3gzu3KeWFoNemUFAhQUgOEnuBWOUXPc57pcKrS9SAhQG4J1aqg6jX+dxtVOkSeY0AOqeptDWDUfwNCbcClcsSPXEXmI1nYbaYXcb1LGfZN4XjydBOsn2rEbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmBsnEV+/3yK0JsqGk5QpPgP8+3eB6JJlRVRv3TBU/g=;
 b=R5tloGxnm8X2vJgcnCRhTzfx3Jv7ce3YOnM0yJspFodFqDeKG0z5Qx/IOdo0+P8ivgcU7dZSnV8kR7tMo8L/5jwWomTS4iFIbHYiAbdDS/4X9If8pKNYwbKUCJB1geNuxVq4z8jGU/u0Po0GFIv3pPwF22JdLgIGMQegTL3G5lmsD9oXPnXIfoNGTLQsxLtNSZjY6gGTZoWfEaZw6gpnafNfBC+u0MSsMBp8K70olKO7H962QPvUD8DoGPfRWKZrm1pvdGHn5D1triRkvzAuX1ky9w2BB9TQ9J6uMSDv0YN/EgkDHEY3oqua+lwahPq4XVGAk7lzR17QCxB0IFM4hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmBsnEV+/3yK0JsqGk5QpPgP8+3eB6JJlRVRv3TBU/g=;
 b=CHKXDJcDGgjGVIzUAzcZFWI+o7vEo1XPw50JB4W9mn0ssEeI5YW38Re0ihM8wvFYVBaghjpjJQBnLr4A89lQd3EffJvV3dKErLHdkTyRBYiRyJZvWxK5evFSOUWINQBeA2z0gajzPc7wB2wxX5DsWmxzTsPlTgEhmtnO60yMsGg=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB2133.jpnprd01.prod.outlook.com (2603:1096:603:1f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Fri, 27 Aug
 2021 06:36:12 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98%3]) with mapi id 15.20.4436.025; Fri, 27 Aug 2021
 06:36:12 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>, Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
Thread-Topic: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
Thread-Index: AQHXmX8jVvjbtjTRLEe2lQMMRo0BcquEr1UAgAChqBCAAEagAIAAAOMggAACgwCAAAEbsIAAeyUAgAAONACAAAFFgIAAAhaAgAAHRlCAAAe6AIAAry5g
Date:   Fri, 27 Aug 2021 06:36:12 +0000
Message-ID: <OS0PR01MB59220DB4277F4414D5779E6A86C89@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210825070154.14336-5-biju.das.jz@bp.renesas.com>
 <777c30b1-e94e-e241-b10c-ecd4d557bc06@omp.ru>
 <OS0PR01MB59220BCAE40B6C8226E4177986C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <78ff279d-03f1-6932-88d8-1eac83d087ec@omp.ru>
 <OS0PR01MB59223F0F03CC9F5957268D2086C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <9b0d5bab-e9a2-d9f6-69f7-049bfb072eba@omp.ru>
 <OS0PR01MB5922F8114A505A33F7A47EB586C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <93dab08c-4b0b-091d-bd47-6e55bce96f8a@gmail.com> <YSfkHtWLyVpCoG7C@lunn.ch>
 <cc3f0ae7-c1c5-12b3-46b4-0c7d1857a615@omp.ru> <YSfm7zKz5BTNUXDz@lunn.ch>
 <OS0PR01MB5922871679124DA36EAEF31F86C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <0916b09c-e656-fa2a-54d9-ca0c1301a278@omp.ru>
In-Reply-To: <0916b09c-e656-fa2a-54d9-ca0c1301a278@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e743eda9-c63f-4a43-ce1b-08d96924f68f
x-ms-traffictypediagnostic: OSBPR01MB2133:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB213356EDA3EAB720417F92DC86C89@OSBPR01MB2133.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tbEXE4EUN+KtzujmsUpSevrLgk4fEH8OhpzxwmlhA3YCbOB0AmTwf7evYwed+yxQfPx/M8ZUTjkjP+IYr4RqbGYR0hpbzRxE0P0m7ZUHE4KjAZoI5v5GSg2PBKyijZjPt6zvu7FyvAR1BJNSbnVwx6rEesqIV/PgU68Ioc3DhWgg5X0ifGKB6Eb7yI9Qe6AE76KA+ZTZybUwJ8moq6t4xYWupWvD3aqhxXTb6Dsb2zJ0Y8kuxEbkjlNjrSOgxWmAXyBKoA3GC9j5fQPFy3Oi8VLDDKrqn96hSWtFGMOmxU5asyZEk+voHcCzMwdm7Sawu8EmUvJ4Nla4/VnnfYl6ibW9NFQ3s9wZPf6lootkqrIiOG8pBzEPbgb4OCUZG3qEi5Ma7k8yBqccWSK4rItgKkMD+MQSo4lv4p0c5oZXifdqRj7l2rxVgJ5pEmofc4hoDWGI6f2rQuJ791DvtZ8qAqL3PRr3Iy2lQ4f7TEqQRy7droQslU6ThHk+8yr/BCYAPfLDrDYR0SHz4smZ7AtFFd0LKxUrtBGOpgCETzaLOYqS441fr9ifZRczpUj0DvcMuMQBDWxPXpiWTzb/YK8XscrL90vy4QnPbJoD9f66m5J4Zx8ojo/1hhldmfV4pyXJAHoW2lLzFYk1TTmclpSXrs2LP1jTq/EvPq9/JQislvpOitdPpJk4+qIv/2GjRbBCuvCiX7Qjw5ULXx09VnWXJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(55016002)(53546011)(52536014)(316002)(478600001)(38070700005)(86362001)(26005)(33656002)(9686003)(5660300002)(6506007)(4326008)(107886003)(186003)(66946007)(71200400001)(64756008)(66556008)(38100700002)(54906003)(110136005)(2906002)(66476007)(122000001)(8936002)(8676002)(7696005)(76116006)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?alpXRmpSbmFZM2k5R1RxZmQ4bnNFRS8rUk9ocHcrUmk3N2hBZVNIdnFZMytn?=
 =?utf-8?B?Rmd3V2trNjd6bG5TVVYyWUJLa3JkMHMxQmVYOU04ZTNZQVZ6bE1uc2czeVZO?=
 =?utf-8?B?bEo1c29xZGZ6OTVMUmNWSXZUQ1A1QmxrY04rQVFxWVQ3SW1TL3pDdTdWV1Jj?=
 =?utf-8?B?UWM3L3dIcU85cHQwektFdjkvSzVKMC9WTEVMdVlBQWdjb2NlR3pnQ2hqdkZP?=
 =?utf-8?B?OFc4Nm15WFU3OE5uZXd6WWgxNTk3NEZLOXdzd2lVQWd4ZjJzMUVRV2hpMFhj?=
 =?utf-8?B?V2NXcWdVaDlhQ3NwYXFlY1ZYZU9lQ3FsOE8xNFo5Qko0WlJGMHpkM2JwSXdV?=
 =?utf-8?B?aFdNQnhLNzM2WXBSYUQ5RUNqTDFGRktlbnJEUnRkNUJWZ2VYb1VkMHo1YUpF?=
 =?utf-8?B?b2lVcHpZZWtOcFlYaFpibER0SU1jSnRyeVVKei9FYzcxdEZqQTJtK1RYcnIw?=
 =?utf-8?B?Z3l1eWY1UkJ1T0tLaE01ck40TXN4YTdEbVFyQ2R1NlhLWXo1MTZieWxvTGlG?=
 =?utf-8?B?dVdJTTFlQ251SHd4RmpwMmpOd3ZCZXA4R2pkdUVtOXd2eHpmMEZqOVFwT1JT?=
 =?utf-8?B?c2cwUlpkTlUyNmFoSmFmRi96dHRpR3BNK012QU9tYTVScUxVdXJrNXQzUEJO?=
 =?utf-8?B?SytxOWxpNzlIdGRyOHEvZ0J1TENsa3ZVQjRvaXlmOWNiY0l6VXJVaS9Wd1gv?=
 =?utf-8?B?OExtQlI2T1d0b3pTc0hLZzI0bjl3bXpTWUR4QzRLaVB4dG5IdXB6UXZYR3ZM?=
 =?utf-8?B?Z2JLQ0JHcTR4NTRNZUVIWDFSUStsZElIc095ZUtsMTNiT0ZNM1ZjMytBbUNs?=
 =?utf-8?B?KzZwdVpBZHVoUWM3ZnNmRFVKMllWWGQwRkVGd1lrNThXUHBleVpGNUJJbzBi?=
 =?utf-8?B?cG1iUlplQzRFR3dmT1ZmNm55OWpIRjZ3R0dXSll0VXp5SUtqcEo0MEpJOGMw?=
 =?utf-8?B?a1ljdzFqWjdwRy9ObnAwZVBaSVJrQTEwcjJHbkV4bmxhd1RkNkwvQkZiZDlz?=
 =?utf-8?B?ZDFmZnpVVFJVSUlYSUNvSjFINHZ2Q1phUWlxelc5cWtIREtJQS9uV2pYZ3Ni?=
 =?utf-8?B?YTUrUWFaUGJsVEhJT0RBdGw4MlhNT1FhVUpDK2JKMTRZK3Y5WnpRajdpUm1M?=
 =?utf-8?B?SUZiVkRVVnNzOHV2VXFPd2RMVVVZUVE4Z2xJMTNEaENnQmxlY284ZXJsK0tk?=
 =?utf-8?B?YnFmODZKNmpobEM3YmtYS1UzUmNvU3JySDY3ak5kRURKMVZnL0ViUHpaUHB0?=
 =?utf-8?B?aGRNc2lQYjFyRHBiZnRqYTMzY09BR3ZmVjE4Vk9jb1AwSXR3dERiWm5GT3Rq?=
 =?utf-8?B?ZCtQelJNdTVKcE9TdnJ5c1dPL3d6RVVrMUJ5dWljMUozbVRTN0NJVW0vWkVh?=
 =?utf-8?B?MDdyY21rUEFNd3dpQUZZOEJEcUJiMEpRbmdodUhnZFRIU0ZJWENtU2prTHYv?=
 =?utf-8?B?blh6ODhNOXR1clFUQm5xcmphU0hVTWZndS8za2xseG9TQWdvNHZuSmlRN0xa?=
 =?utf-8?B?aHVEWFlMUm9hUDB0MFhJWjc5aUxjL1M2bHNBcDFNQ1dGcFMreVVQaGt3dk9N?=
 =?utf-8?B?SWRzSXVzS3hHa1FMUFNYaGRsZW1RVmlXUk1NQWhFdzUxemRlMEFKSmNPSzFi?=
 =?utf-8?B?NWhJcThKSFM2VXZNRTFKMjJmc0hlNmVqWkpyZkhqZzA5YWRRR1BBZ0hZOHkv?=
 =?utf-8?B?WEFmdWpGK3o4UHNxNVdCYUpiaDMvaGVNblBMSXpnak9yYXVjaC9tUm9UWjRN?=
 =?utf-8?Q?0+58drbN2m/7OjsdcU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e743eda9-c63f-4a43-ce1b-08d96924f68f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2021 06:36:12.4391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zy6zb5K96YoT1ZL464MCldQmon8ppF25Hae4VicxlsbI7Px437Wca84xaSNOckbtI6jagb1s4/PnClS544zA0vCbWquGsS6ginyERjzOj+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IDA0LzEzXSByYXZiOiBBZGQgcHRwX2NmZ19hY3RpdmUgdG8gc3RydWN0
DQo+IHJhdmJfaHdfaW5mbw0KPiANCj4gT24gOC8yNi8yMSAxMDozNyBQTSwgQmlqdSBEYXMgd3Jv
dGU6DQo+IFsuLi5dDQo+IA0KPiA+Pj4+Pj4gRG8geW91IGFncmVlIEdBQyByZWdpc3RlcihnUFRQ
IGFjdGl2ZSBpbiBDb25maWcpIGJpdCBpbiBBVkItRE1BQw0KPiA+PiBtb2RlIHJlZ2lzdGVyKEND
QykgcHJlc2VudCBvbmx5IGluIFItQ2FyIEdlbjM/DQo+ID4+Pj4+DQo+ID4+Pj4+ICAgIFllcy4N
Cj4gPj4+Pj4gICAgQnV0IHlvdSBmZWF0dXJlIG5hbWluZyBpcyB0b3RhbGx5IG1pc2d1aWRpbmcs
IG5ldmVydGhlbGVzcy4uLg0KPiA+Pj4+DQo+ID4+Pj4gSXQgY2FuIHN0aWxsIGJlIGNoYW5nZWQu
DQo+ID4+Pg0KPiA+Pj4gICAgIFRoYW5rIGdvb2RuZXNzLCB5ZWEhDQo+ID4+DQo+ID4+IFdlIGhh
dmUgdG8gbGl2ZSB3aXRoIHRoZSBmaXJzdCB2ZXJzaW9uIG9mIHRoaXMgaW4gdGhlIGdpdCBoaXN0
b3J5LA0KPiA+PiBidXQgd2UgY2FuIGFkZCBtb3JlIHBhdGNoZXMgZml4aW5nIHVwIHdoYXRldmVy
IGlzIGJyb2tlbiBpbiB0aGUNCj4gPj4gdW5yZXZpZXdlZCBjb2RlIHdoaWNoIGdvdCBtZXJnZWQu
DQo+ID4+DQo+ID4+Pj4gSnVzdCBzdWdnZXN0IGEgbmV3IG5hbWUuDQo+ID4+Pg0KPiA+Pj4gICAg
IEknZCBwcm9sbHkgZ28gd2l0aCAnZ3B0cCcgZm9yIHRoZSBnUFRQIHN1cHBvcnQgYW5kICdjY2Nf
Z2FjJyBmb3INCj4gPj4+IHRoZSBnUFRQIHdvcmtpbmcgYWxzbyBpbiBDT05GSUcgbW9kZSAoQ0ND
LkdBQyBjb250cm9scyB0aGlzIGZlYXR1cmUpLg0KPiA+Pg0KPiA+PiBCaWp1LCBwbGVhc2UgY291
bGQgeW91IHdvcmsgb24gYSBjb3VwbGUgb2YgcGF0Y2hlcyB0byBjaGFuZ2UgdGhlIG5hbWVzLg0K
PiA+DQo+ID4gWWVzLiBXaWxsIHdvcmsgb24gdGhlIHBhdGNoZXMgdG8gY2hhbmdlIHRoZSBuYW1l
cyBhcyBzdWdnZXN0ZWQuDQo+IA0KPiAgICBUSUEhDQo+ICAgIEFmdGVyIHNvbWUgbW9yZSB0aGlu
a2luZywgJ25vX2dwdHAnIHNlZW1zIHRvIHN1aXQgYmV0dGVyIGZvciB0aGUgMXN0DQo+IGNhc2Ug
TWlnaHQgbmVlZCB0byBpbnZlcnQgdGhlIGNoZWNrcyB0aG8uLi4NCg0KT0ssIFdpbGwgZG8gd2l0
aCBpbnZlcnQgY2hlY2tzLg0KDQpTbyBqdXN0IHRvIGNvbmNsdWRlLA0KDQonbm9fZ3B0cCcgYW5k
ICdjY2NfZ2FjJyBhcmUgdGhlIHN1Z2dlc3RlZCBuYW1lcyBjaGFuZ2VzIGZvciB0aGUgcHJldmlv
dXMgcGF0Y2gNCmFuZCBjdXJyZW50IHBhdGNoLg0KDQpDaGVlcnMsDQpCaWp1DQo=
