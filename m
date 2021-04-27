Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE2936BE79
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 06:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhD0E0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 00:26:30 -0400
Received: from mail-eopbgr60086.outbound.protection.outlook.com ([40.107.6.86]:5617
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229490AbhD0E02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 00:26:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuH6c3mIxfZ9GVmtRJtvvJfp/YF0t86q8O+QYFKG9xzS9Tkit+JFPNwJeHd4e19LdkpIqeONxe3pCM9y0BxWV4xvxthx4L5Zq759u8AeKMBbDVnxvZjDSgQlYX6ZBqbABSczF3trzOxvJlcpgbMmyv26Q7lnwO4RHHaLHvvMkldfTS/+kttBDzY0vmN8ewe561UNrj+1ZQecB+SvsFqx85B9ESP18MB4qeEuq7UNB4yWs6Jz9ioQqXLyFiF2hN3ZZqad5uhgVqm1L3vKBEAEfZbAT+Q5xU2OcQE98ZX6IvrUb34MZlJ9lVIZQYzSDwdzAJZ1ZU/bGYbopfoPrU4MVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7X/v/MptBiVxhh0HYj8ZUmHpxC0xuFpHafqnpUo994=;
 b=UErfY2kaY/+NZ6K0k6S3wCZ8nmDZJIr6Y4J2qHyx7YEdnWf3O1NOCHS5chZX0sxj8y2vsmaR9BXYA6hz09yoHwbKH3Q7wjPRVDJnA5R0/a6YEC4G7OWgWi0XGZYUA/i7/Gta6Bm1IVf2Q9kaX5poxaef7C/lkLvgry8sTJ+eJFMJ/eMORI5bzRmJqWTiN1H2/ZAdtumNKeRg0vmz6FrpKEWcnsBBWMoVKGIdHEu9NYuXlecW2Y4SaxC7VbxUky90dsRYBdSnuExvbA/Wajfb1xaaruI6Qrf2/W96Tv013A0ClZk7zkmnemavePTaocaZBqz/VmFgkWa9GjEaKkNSDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7X/v/MptBiVxhh0HYj8ZUmHpxC0xuFpHafqnpUo994=;
 b=WzaVZaMJPw5ieKbUDRYqLqOrrXamvkqBrRBkPzqeaAPl0uJmJ/izykXBYgk+lWcMdtDbN8/93+K/MD07oLBzLPebJmnV/7Kjplg8h5JUh7k6Bg/Ygl64yB9G8q2Y6CcP/khLrEcj47ixTPHuBTsWuSzsNg1FwrhJXCWmmVhykkY=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM6PR0402MB3384.eurprd04.prod.outlook.com (2603:10a6:209:6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Tue, 27 Apr
 2021 04:25:42 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777%3]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 04:25:42 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
Thread-Topic: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
Thread-Index: AQHXOn8Jr4d6SG7MRkyMg7TxAYZcc6rGzfgAgABUFgCAAKBdAA==
Date:   Tue, 27 Apr 2021 04:25:42 +0000
Message-ID: <AM7PR04MB68859682C46E40D3D93F4692F8419@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20210426093802.38652-1-yangbo.lu@nxp.com>
 <20210426093802.38652-4-yangbo.lu@nxp.com>
 <20210426133846.GA22518@hoboy.vegasvil.org>
 <20210426183944.4djc5dep62xz4gh6@skbuf>
In-Reply-To: <20210426183944.4djc5dep62xz4gh6@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b2fc2da-cdc4-43d8-492b-08d909348540
x-ms-traffictypediagnostic: AM6PR0402MB3384:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0402MB3384AA7D63E47334F4C11BDDF8419@AM6PR0402MB3384.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:221;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o1nzXT6erprxzXaKWqBYYNhNnYecgS0iUCcQO/gI8CzHmyxJ+an7xnrEOiyKDDQ6eXkDwBNzMfX5ZEJ+10pUCrEZOqo4bFbKbkl8IUQpv0ZULGmRIz0ifx0fNFFTPPlbHU6mey1a8ab/nX0vQrEk5YNA1cRffsGXMWhfouO/8FmJVfuE+B2RPhbnAm0C7GCyvJFeGb5Ds2sLcnoeuN3lqHVuetUlQvbFOW11et/lMulsVeF0nuQF9yNSO1AB6AfuEJP4eBxqnOe79u3EpyjBzEQSFfyLOzYvFeEhXEmZDQRYyyPr/x4lvDEyduPuYEOVV45DdJda4tUgNotC8vNQAXJaB5B1zC52p4teF/dUbUwv26eKGCqOJKmzeqWd+s5I1Bxk9WiAe9WXxQvoJ2W4KbEBtoYl+EN8Aqr/3HcCx2GV5lU54MNU1hGs6xNXF7QBSO4uROn6TxQtRCrWkOPAs7fvPAF6xdwM0K7bNsDhdecMAGqUMRNusZZg6EqsuIpcVQrhi/huzRrYBOqozFyyBuojfOALKmiADz3NvUznn7Ltc/rt2bypm6D3wS0xbiMbaM0+MQLuEuXA09oNy60QTcqplmrRQZOjokrtnZIyWEg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(8936002)(38100700002)(8676002)(122000001)(86362001)(5660300002)(7696005)(66446008)(66476007)(76116006)(64756008)(9686003)(6506007)(66556008)(66946007)(26005)(186003)(71200400001)(52536014)(83380400001)(4326008)(2906002)(110136005)(54906003)(7416002)(498600001)(55016002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?MTNmUHQwUDNpdEVkUEZ1VkJSbVQ1dWpROHlvb2FiMFZrQzN2OW52dDdoSWFW?=
 =?gb2312?B?ejVWeHR4UzZJcmJXWTU5U3R2KzI0WXBLNXkxQVpZbHVwMG1WZEpRVnQyUk1Z?=
 =?gb2312?B?R0VSN055OXVWL0pNcDRzdHM0ZVFmY2NpWHFFaFFQL21la0NPM05BTURNV3dS?=
 =?gb2312?B?Y2VQbkx1clZKQSsydGZsL0dQTDRIMDA3LzU1Ui8waVZOV2N3Si9tMDlNMWlM?=
 =?gb2312?B?dDV6WTVDUHIzd2xVNE41TDkvR0g0V3R1TjJaWngrbFg0WFFTZjdLRFMrdHRX?=
 =?gb2312?B?Tm9Rb2loT2ZmUzRqVnR3Y3pLRi9KMk0wTktROFdhaVJCU2pLemlZSSs5TFIr?=
 =?gb2312?B?Qnp4S3FNaFBDbkxTdlBTNzMwK3pqUmE5SjJMSEcyaENXSEJwMXNQRXdIcWZi?=
 =?gb2312?B?aGswQzl6cTJzSlNSV0x1Z2NzOFFNa3l6V3FSNzVGMG1XazJwSEVwZlR3d3lB?=
 =?gb2312?B?eitLR0hFNTJoeitHV2NZUlJaL2VnYnNQQWE0UXNzcWRSYW5IdThPdmg3RXRO?=
 =?gb2312?B?M2EzU0Z5N1JuMDBQVk9RWUVNemN4cER5Y1VVaUE1Z0FUWDVCSjhWUlVpZGpi?=
 =?gb2312?B?WjdmbCs0MUtXcFh4NkZCRnZKalBaTjMzVVhkbmdvb1BWUldNTzlKWE51NFg1?=
 =?gb2312?B?VzBLVU8zQnA5SVdyb0RhVnJKcFZTVk91clg4Nm5idW5aSHZxKzF0NkJaQ0JK?=
 =?gb2312?B?QVhVM2dPK0hnc1p2UDA0RkVpQVRrOFpPY0NIU25ERFY5YUhvT1loOHR4eGxO?=
 =?gb2312?B?TlNSbXRKT2JROWVRTWZRVXd6VnNpdXpTbFhnNmRUUUxhQ29ZRGpVMnMrbFBK?=
 =?gb2312?B?WWhtM21Fakd3Z2VrZDk1QnJJN2svWnp0TjdWTjFiby83V2l3a2ttTDNSRnNs?=
 =?gb2312?B?K0JBdDRYSUh6cVFxM0VJc3hqS3BpRUEzNFZ5NnBMTS9VWjBOb1cxQVJWdHNX?=
 =?gb2312?B?T2o3VkZQK0VkdXdid1c1OG9iR1p4U0JzRTh2TllRdlViVGgyZXhKaW9pcmN3?=
 =?gb2312?B?Vk1VWmVjK1R5M0lGMWNxNFdKTWtHTDVoTWxvSVBqNDZvUGNuR3J1NnpLK21o?=
 =?gb2312?B?eWM0SW1MK3hBU2psY3VjZk1UY0hTYk12cjVoRW5zaE5QMi8xUStjdTN3MFVw?=
 =?gb2312?B?SUpVakhJclMzV0U3YWRMZm84dktZaFZhVytJL1ExcDkxZlEvbTA5SThGdnJJ?=
 =?gb2312?B?MnU3VGNJK1FkRzg5TTF4V3hTeUd1eEtmWGF0V252OFNkdTFiNzFuVmQ1Qzd1?=
 =?gb2312?B?SXNFRmx1MlNBNXBkeldtZmhnQmEvb1BFeVBDNUtHZkZsdkVvY0VhMVNEaFdp?=
 =?gb2312?B?TWE3YUdMS0IxUUQ4KzlzODJrMDR3ZG90Z0ROY284amFwUEo2UW5zVjV2VXZp?=
 =?gb2312?B?SlBPdVZuenFqQWR2UytzemIyTHRtV2FGMlZHRnNMU3BzSmJtNStMaE9leTJ5?=
 =?gb2312?B?dXVVbk5nakJmazY2bENDK3Z1YlF0c3drUlVxckd1L251NFNyQ0FhenZPSjlh?=
 =?gb2312?B?SmpFVlhnckcvMTNLTjhGZ01pQ0lQVTlEcWpmV0RFL3k0TlFFZ2tkUG9ZMFgz?=
 =?gb2312?B?NEh5Ris0T05rUlBWZklJVjdrMDMyZ28yYmlSRjNsUHdlUElkZ1F1WlN4RWRN?=
 =?gb2312?B?NFVtTmJSNzV0U21reUgzcFNac016Sk04MWozT2UyOE0vZWNoYVl3WVQwajZl?=
 =?gb2312?B?UEF2Y2F3ci9MRGhsaW1wK24wR282UEFBQzRJRXZsc2RFb2xNMlpMWnNOUWlt?=
 =?gb2312?Q?0TaSGJ2By0PsSJA0bkVE3qCtYZIHGn6ekahbdXk?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2fc2da-cdc4-43d8-492b-08d909348540
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2021 04:25:42.7042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jKbVgnxKoPxUNtrrbuKjxKdmtyd7vA4EVhwnXdnxCaK9uWcLUOJ4yczzuZ2zEXGMyQs0PqFmQuiAAUdBcZFO1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3384
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWbGFkaW1pciBPbHRlYW4gPG9s
dGVhbnZAZ21haWwuY29tPg0KPiBTZW50OiAyMDIxxOo01MIyN8jVIDI6NDANCj4gVG86IFJpY2hh
cmQgQ29jaHJhbiA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPg0KPiBDYzogWS5iLiBMdSA8eWFu
Z2JvLmx1QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBWbGFkaW1pciBPbHRlYW4N
Cj4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsgRGF2aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldD47IEpha3ViDQo+IEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBKb25hdGhh
biBDb3JiZXQgPGNvcmJldEBsd24ubmV0PjsgS3VydA0KPiBLYW56ZW5iYWNoIDxrdXJ0QGxpbnV0
cm9uaXguZGU+OyBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBWaXZpZW4NCj4gRGlkZWxv
dCA8dml2aWVuLmRpZGVsb3RAZ21haWwuY29tPjsgRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxs
aUBnbWFpbC5jb20+Ow0KPiBDbGF1ZGl1IE1hbm9pbCA8Y2xhdWRpdS5tYW5vaWxAbnhwLmNvbT47
IEFsZXhhbmRyZSBCZWxsb25pDQo+IDxhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNvbT47IFVO
R0xpbnV4RHJpdmVyQG1pY3JvY2hpcC5jb207DQo+IGxpbnV4LWRvY0B2Z2VyLmtlcm5lbC5vcmc7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtuZXQtbmV4dCwg
djIsIDMvN10gbmV0OiBkc2E6IGZyZWUgc2tiLT5jYiB1c2FnZSBpbiBjb3JlIGRyaXZlcg0KPiAN
Cj4gT24gTW9uLCBBcHIgMjYsIDIwMjEgYXQgMDY6Mzg6NDZBTSAtMDcwMCwgUmljaGFyZCBDb2No
cmFuIHdyb3RlOg0KPiA+IE9uIE1vbiwgQXByIDI2LCAyMDIxIGF0IDA1OjM3OjU4UE0gKzA4MDAs
IFlhbmdibyBMdSB3cm90ZToNCj4gPiA+IEBAIC02MjQsNyArNjIzLDcgQEAgc3RhdGljIG5ldGRl
dl90eF90IGRzYV9zbGF2ZV94bWl0KHN0cnVjdCBza19idWZmDQo+ID4gPiAqc2tiLCBzdHJ1Y3Qg
bmV0X2RldmljZSAqZGV2KQ0KPiA+ID4NCj4gPiA+ICAJZGV2X3N3X25ldHN0YXRzX3R4X2FkZChk
ZXYsIDEsIHNrYi0+bGVuKTsNCj4gPiA+DQo+ID4gPiAtCURTQV9TS0JfQ0Ioc2tiKS0+Y2xvbmUg
PSBOVUxMOw0KPiA+ID4gKwltZW1zZXQoc2tiLT5jYiwgMCwgNDgpOw0KPiA+DQo+ID4gUmVwbGFj
ZSBoYXJkIGNvZGVkIDQ4IHdpdGggc2l6ZW9mKCkgcGxlYXNlLg0KPiANCj4gWW91IG1lYW4ganVz
dCBhIHRyaXZpYWwgY2hhbmdlIGxpa2UgdGhpcywgcmlnaHQ/DQo+IA0KPiAJbWVtc2V0KHNrYi0+
Y2IsIDAsIHNpemVvZihza2ItPmNiKSk7DQo+IA0KPiBBbmQgbm90IHdoYXQgSSBoYWQgc3VnZ2Vz
dGVkIGluIHYxLCB3aGljaCB3b3VsZCBoYXZlIGxvb2tlZCBzb21ldGhpbmcgbGlrZQ0KPiB0aGlz
Og0KPiANCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS1bY3V0IGhlcmVdLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L2RzYS5oIGIv
aW5jbHVkZS9uZXQvZHNhLmggaW5kZXgNCj4gZTFhMjYxMGEwZTA2Li5jNzViMjQ5ZTg0NmYgMTAw
NjQ0DQo+IC0tLSBhL2luY2x1ZGUvbmV0L2RzYS5oDQo+ICsrKyBiL2luY2x1ZGUvbmV0L2RzYS5o
DQo+IEBAIC05Miw2ICs5Miw3IEBAIHN0cnVjdCBkc2FfZGV2aWNlX29wcyB7DQo+ICAJICovDQo+
ICAJYm9vbCAoKmZpbHRlcikoY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5ldF9k
ZXZpY2UgKmRldik7DQo+ICAJdW5zaWduZWQgaW50IG92ZXJoZWFkOw0KPiArCXVuc2lnbmVkIGlu
dCBza2JfY2Jfc2l6ZTsNCj4gIAljb25zdCBjaGFyICpuYW1lOw0KPiAgCWVudW0gZHNhX3RhZ19w
cm90b2NvbCBwcm90bzsNCj4gIAkvKiBTb21lIHRhZ2dpbmcgcHJvdG9jb2xzIGVpdGhlciBtYW5n
bGUgb3Igc2hpZnQgdGhlIGRlc3RpbmF0aW9uIE1BQyBkaWZmDQo+IC0tZ2l0IGEvbmV0L2RzYS9z
bGF2ZS5jIGIvbmV0L2RzYS9zbGF2ZS5jIGluZGV4IDIwMzNkOGJhYzIzZC4uMjIzMDU5NmI0OGI3
DQo+IDEwMDY0NA0KPiAtLS0gYS9uZXQvZHNhL3NsYXZlLmMNCj4gKysrIGIvbmV0L2RzYS9zbGF2
ZS5jDQo+IEBAIC02MTAsMTEgKzYxMCwxNCBAQCBzdGF0aWMgaW50IGRzYV9yZWFsbG9jX3NrYihz
dHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QNCj4gbmV0X2RldmljZSAqZGV2KSAgc3RhdGljIG5l
dGRldl90eF90IGRzYV9zbGF2ZV94bWl0KHN0cnVjdCBza19idWZmICpza2IsDQo+IHN0cnVjdCBu
ZXRfZGV2aWNlICpkZXYpICB7DQo+ICAJc3RydWN0IGRzYV9zbGF2ZV9wcml2ICpwID0gbmV0ZGV2
X3ByaXYoZGV2KTsNCj4gKwljb25zdCBzdHJ1Y3QgZHNhX2RldmljZV9vcHMgKnRhZ19vcHM7DQo+
ICAJc3RydWN0IHNrX2J1ZmYgKm5za2I7DQo+IA0KPiAgCWRldl9zd19uZXRzdGF0c190eF9hZGQo
ZGV2LCAxLCBza2ItPmxlbik7DQo+IA0KPiAtCW1lbXNldChza2ItPmNiLCAwLCA0OCk7DQo+ICsJ
dGFnX29wcyA9IHAtPmRwLT5jcHVfZHAtPnRhZ19vcHM7DQo+ICsJaWYgKHRhZ19vcHMtPnNrYl9j
Yl9zaXplKQ0KPiArCQltZW1zZXQoc2tiLT5jYiwgMCwgdGFnX29wcy0+c2tiX2NiX3NpemUpOw0K
PiANCj4gIAkvKiBIYW5kbGUgdHggdGltZXN0YW1wIGlmIGFueSAqLw0KPiAgCWRzYV9za2JfdHhf
dGltZXN0YW1wKHAsIHNrYik7DQo+IGRpZmYgLS1naXQgYS9uZXQvZHNhL3RhZ19zamExMTA1LmMg
Yi9uZXQvZHNhL3RhZ19zamExMTA1LmMgaW5kZXgNCj4gNTA0OTYwMTNjZGI3Li4xYjMzN2ZhMTA0
ZGMgMTAwNjQ0DQo+IC0tLSBhL25ldC9kc2EvdGFnX3NqYTExMDUuYw0KPiArKysgYi9uZXQvZHNh
L3RhZ19zamExMTA1LmMNCj4gQEAgLTM2NSw2ICszNjUsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0
IGRzYV9kZXZpY2Vfb3BzDQo+IHNqYTExMDVfbmV0ZGV2X29wcyA9IHsNCj4gIAkub3ZlcmhlYWQg
PSBWTEFOX0hMRU4sDQo+ICAJLmZsb3dfZGlzc2VjdCA9IHNqYTExMDVfZmxvd19kaXNzZWN0LA0K
PiAgCS5wcm9taXNjX29uX21hc3RlciA9IHRydWUsDQo+ICsJLnNrYl9jYl9zaXplID0gc2l6ZW9m
KHN0cnVjdCBzamExMTA1X3NrYl9jYiksDQo+ICB9Ow0KPiANCj4gIE1PRFVMRV9MSUNFTlNFKCJH
UEwgdjIiKTsNCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS1bY3V0IGhlcmVdLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gDQo+IEkgd2FudGVkIHRvIHNlZSBob3cgYmFkbHkg
aW1wYWN0ZWQgd291bGQgdGhlIHBlcmZvcm1hbmNlIGJlLCBzbyBJIGNyZWF0ZWQNCj4gYW4gSVB2
NCBmb3J3YXJkaW5nIHNldHVwIG9uIHRoZSBOWFAgTFMxMDIxQS1UU04gYm9hcmQgKGdpYW5mYXIg
Kw0KPiBzamExMTA1KToNCj4gDQo+ICMhL2Jpbi9iYXNoDQo+IA0KPiBFVEgwPXN3cDMNCj4gRVRI
MT1zd3AyDQo+IA0KPiBzeXN0ZW1jdGwgc3RvcCBwdHA0bCAjIHJ1bnMgYSBCUEYgY2xhc3NpZmll
ciBvbiBldmVyeSBwYWNrZXQgc3lzdGVtY3RsIHN0b3ANCj4gcGhjMnN5cw0KPiANCj4gZWNobyAx
ID4gL3Byb2Mvc3lzL25ldC9pcHY0L2lwX2ZvcndhcmQNCj4gaXAgYWRkciBmbHVzaCAkRVRIMCAm
JiBpcCBhZGRyIGFkZCAxOTIuMTY4LjEwMC4xLzI0IGRldiAkRVRIMCAmJiBpcCBsaW5rDQo+IHNl
dCAkRVRIMCB1cCBpcCBhZGRyIGZsdXNoICRFVEgxICYmIGlwIGFkZHIgYWRkIDE5Mi4xNjguMjAw
LjEvMjQgZGV2ICRFVEgxDQo+ICYmIGlwIGxpbmsgc2V0ICRFVEgxIHVwDQo+IA0KPiBhcnAgLXMg
MTkyLjE2OC4xMDAuMiAwMDowNDo5ZjowNjowMDowOSBkZXYgJEVUSDAgYXJwIC1zIDE5Mi4xNjgu
MjAwLjINCj4gMDA6MDQ6OWY6MDY6MDA6MGEgZGV2ICRFVEgxDQo+IA0KPiBldGh0b29sIC0tY29u
ZmlnLW5mYyBldGgyIGZsb3ctdHlwZSBldGhlciBkc3QgMDA6MWY6N2I6NjM6MDE6ZDQgbSBmZjpm
ZjpmZjpmZjpmZjpmZg0KPiBhY3Rpb24gMA0KPiANCj4gYW5kIEkgZ290IHRoZSBmb2xsb3dpbmcg
cmVzdWx0cyBvbiAxIENQVSwgNjRCIFVEUCBwYWNrZXRzICh5ZXMsIEkga25vdyB0aGUNCj4gYmFz
ZWxpbmUgcmVzdWx0cyBzdWNrLCBJIGhhdmVuJ3QgaW52ZXN0aWdhdGVkIHdoeSB0aGF0IGlzLCBi
dXQgbm9uZXRoZWxlc3MsIGl0DQo+IHNob3VsZCBzdGlsbCBiZSByZWxldmFudCBhcyBmYXIgYXMg
Y29tcGFyYXRpdmUgcmVzdWx0cw0KPiBnbyk6DQo+IA0KPiBVbnBhdGNoZWQgbmV0LW5leHQ6DQo+
IHByb3RvIDE3OiAgICAgIDY1Njk1IHBrdC9zDQo+IHByb3RvIDE3OiAgICAgIDY1NzI1IHBrdC9z
DQo+IHByb3RvIDE3OiAgICAgIDY1NzMyIHBrdC9zDQo+IHByb3RvIDE3OiAgICAgIDY1NzIwIHBr
dC9zDQo+IHByb3RvIDE3OiAgICAgIDY1Njk1IHBrdC9zDQo+IHByb3RvIDE3OiAgICAgIDY1NzI1
IHBrdC9zDQo+IHByb3RvIDE3OiAgICAgIDY1NzMyIHBrdC9zDQo+IHByb3RvIDE3OiAgICAgIDY1
NzIwIHBrdC9zDQo+IA0KPiANCj4gQWZ0ZXIgcGF0Y2ggMToNCj4gcHJvdG8gMTc6ICAgICAgNzI2
NzkgcGt0L3MNCj4gcHJvdG8gMTc6ICAgICAgNzI2NzcgcGt0L3MNCj4gcHJvdG8gMTc6ICAgICAg
NzI2NjkgcGt0L3MNCj4gcHJvdG8gMTc6ICAgICAgNzI3MDcgcGt0L3MNCj4gcHJvdG8gMTc6ICAg
ICAgNzI2OTYgcGt0L3MNCj4gcHJvdG8gMTc6ICAgICAgNzI2OTkgcGt0L3MNCj4gDQo+IEFmdGVy
IHBhdGNoIDI6DQo+IHByb3RvIDE3OiAgICAgIDcyMjkyIHBrdC9zDQo+IHByb3RvIDE3OiAgICAg
IDcyNDI1IHBrdC9zDQo+IHByb3RvIDE3OiAgICAgIDcyNDg1IHBrdC9zDQo+IHByb3RvIDE3OiAg
ICAgIDcyNDc4IHBrdC9zDQo+IA0KPiBBZnRlciBwYXRjaCA0IChhcyAzIGRvZXNuJ3QgYnVpbGQp
Og0KPiBwcm90byAxNzogICAgICA3MjQzNyBwa3Qvcw0KPiBwcm90byAxNzogICAgICA3MjUxMCBw
a3Qvcw0KPiBwcm90byAxNzogICAgICA3MjQ3OSBwa3Qvcw0KPiBwcm90byAxNzogICAgICA3MjQ5
OSBwa3Qvcw0KPiBwcm90byAxNzogICAgICA3MjQ5NyBwa3Qvcw0KPiBwcm90byAxNzogICAgICA3
MjQyNyBwa3Qvcw0KPiANCj4gV2l0aCB0aGUgY2hhbmdlIEkgcGFzdGVkIGFib3ZlOg0KPiBwcm90
byAxNzogICAgICA3MTg5MSBwa3Qvcw0KPiBwcm90byAxNzogICAgICA3MTgxMCBwa3Qvcw0KPiBw
cm90byAxNzogICAgICA3MTg1MCBwa3Qvcw0KPiBwcm90byAxNzogICAgICA3MTgyNiBwa3Qvcw0K
PiBwcm90byAxNzogICAgICA3MTc5OCBwa3Qvcw0KPiBwcm90byAxNzogICAgICA3MTc4NiBwa3Qv
cw0KPiBwcm90byAxNzogICAgICA3MTgxNCBwa3Qvcw0KPiBwcm90byAxNzogICAgICA3MTgxNCBw
a3Qvcw0KPiBwcm90byAxNzogICAgICA3MjAxMCBwa3Qvcw0KPiANCj4gU28gYmFzaWNhbGx5LCBu
b3Qgb25seSBhcmUgd2UgYmV0dGVyIG9mZiBqdXN0IHplcm8taW5pdGlhbGl6aW5nIHRoZSBjb21w
bGV0ZQ0KPiBza2ItPmNiIGluc3RlYWQgb2YgbG9va2luZyB1cCB0aGUgdGFnZ2VyJ3Mgc2tiX2Ni
X3NpemUsIGJ1dCB6ZXJvLWluaXRpYWxpemluZyB0aGUNCj4gc2tiLT5jYiBpc24ndCBldmVuIGFs
bCB0aGF0IGJhZC4gWWFuZ2JvJ3MgY2hhbmdlIGlzIGFuIG92ZXJhbGwgd2luIGFueXdheSwgYWxs
DQo+IHRoaW5ncyBjb25zaWRlcmVkLiBTbyBqdXN0IGNoYW5nZSB0aGUgbWVtc2V0IGFzIFJpY2hh
cmQgc3VnZ2VzdGVkLCBtYWtlIHN1cmUNCj4gYWxsIHBhdGNoZXMgY29tcGlsZSwgYW5kIHdlIHNo
b3VsZCBiZSBnb29kIHRvIGdvLg0KDQpBaC4uLiBJIGhhZCB0aG91Z2h0IDQ4Ynl0ZXMgbWVtc2V0
IHdhcyBhY2NlcHRhYmxlIGZvciBub3cgYnkgeW91Lg0KSSBhY3R1YWxseSBkaWRuJ3QgY29uc2lk
ZXIgdGhlIHBlcmZvcm1hbmNlIGFmZmVjdGVkIGJ5IHRoaXMuIEkganVzdCBkaWQgdGhpcyBiZWNh
dXNlIEkgYmVsaWV2ZWQgdGhlIGRpcmVjdGlvbiB3YXMgcmlnaHQ6KQ0KVGhhdCdzIHJlYWxseSBn
b29kIHRlc3RpbmcuIFRoYW5rIHlvdSB2ZXJ5IG11Y2gsIFZsYWRpbWlyLg0KV2l0aCB0aGUgZGF0
YSwgd2UgY2FuIGZlZWwgZnJlZSB0byB1c2UgdGhlIGNoYW5nZXMuDQo=
