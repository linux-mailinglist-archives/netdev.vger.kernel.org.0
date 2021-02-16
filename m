Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456AC31C95E
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 12:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhBPLHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 06:07:47 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:17881 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhBPLFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 06:05:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613473536; x=1645009536;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RYBNxYggxTfJUaFKWNqHQGA6w1dZSlSPUmbl3lpNhco=;
  b=kbPMWyYAjCm8+Gk6ro1viYnjaViKGd0OHn/ImnTlBeN9M44ckWYK6VB0
   v0jqb3pE07tG+DYcB7e/lF5yp8XhenE+t4uDAX9HsEcFlJJvTYuJnSoDw
   h3lNSjCm2nLbdZOukRuF2hNcAwWJ9PIzNbcxfd74OhMeAoxRa5r+unAX+
   U0R2SiOONdnjpIfoq1sjJ9HTS4qdSRJ2KB9Oz9NOTNW/pnxidc244heuD
   XxzLXbcHOk/SnvyVQGh+jJKz8zc/Id0HCEnKwAEcyrPoEqzK7XClBGEQv
   jtJ9Oud6Gwxqs7sB5l8VZWTD4n/4BniDw16CBpCITXv9cESb0C2Oolp3d
   w==;
IronPort-SDR: XBY3M34E8cEdHvKzayHIiWRCtOO78xmm2v8pBkRfUWzygugLBy5w7fR9XuGFvWpYjJWlbUNyxI
 DTFGhNP2FG4JKtE/F3TkyaEk6y9RPXetTiSNbPzuNZ1QzpFAlAwtYbZaxPa0Zg0Yc1LNtsw4ea
 QqWxEnBYYfzim29AoJbQy2aaN6zlUFe9o79shY/sR+Zfbsd4hFRvrhNdFUjeVGQtJumXcX7eZu
 OL7F3P5/IEnF3fVPifbSeOHOMSEYtk/Ujsw5vpcV6i4KItSFvPNpKEVy81wKWlRk2AhBuKum38
 ahk=
X-IronPort-AV: E=Sophos;i="5.81,183,1610434800"; 
   d="scan'208";a="106727172"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2021 04:04:20 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 16 Feb 2021 04:04:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Tue, 16 Feb 2021 04:04:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeYCcrNYn18xconbeq/9iIjMAP5lVQpc4x8GjQZIT6cau8KASl9Uppgyz0nhpa0vu5aA24dv+KGutH+PkYBvvwevXtQz16Y9BgQoXXanz0ahlg71Y5iV0hyQZLYL8++OjU64zH4wagt8kcFDO4LeZvFTtfniMPDPYXLsRE1FwLPvrSyYmDENNnY8679n7JAV5WXvKXxRRCCQpbtSkTUyVONuSLjY6pGWor19ZFoAmaCVnWQyIltvUCVXpO1sm/mL0sZ5OS+8fhGLbrjoGqyuxmbgwRUFahlJflD2RGt/Jqhqimv7DZp70WD+xE1xgwU3GW0P/CGntqHnDQms4uFbqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYBNxYggxTfJUaFKWNqHQGA6w1dZSlSPUmbl3lpNhco=;
 b=fzBvU8ttJgYuWhedf/309of4NG4nBB4qYIxIHZp+GZm3WnRs0Y/jfR2GHeZzt7QsplBJOMIda/Xf8FHPe9p7mE1q8fkDEjt5p7N4FzfXUqZx8Mq4GEoXtwcCfDnaVPmJ1nU7vpcSdlUezqrKUp1l4+8+nXaC9qZ3FyOD9K5Sy8Bk2maVsHy6qVHCc+zul7pr1lWPWIwkP2DpbttiTfACp3lQATVqOyL20aLYUEekf94WikOlSYFv/BJ917ZjpGabKCgutd6vejt8IuiPl302PewYYQpe/8OK1Q3aBPl2I5FalfmoS/CXPUkSTwtr1CamZSir3ecnFf+VGkytyRtEyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYBNxYggxTfJUaFKWNqHQGA6w1dZSlSPUmbl3lpNhco=;
 b=c/7ZKcvWH6RC9glUnR9pb7+aeQeAqSGjUIavF+5vo4GeQ+wFtGO1T8G+8p2xo+ikwtXmTKmieUv+CycfokAUY7TSw3enDTGeo8FMkfWkkogODtiIPIHH9NJd8vys8uZfYaSulMI1ndhMa2c5wSEGiFALNixF84osFHZ1f2ERNP0=
Received: from DM5PR1101MB2329.namprd11.prod.outlook.com (2603:10b6:3:9e::23)
 by DM5PR1101MB2249.namprd11.prod.outlook.com (2603:10b6:4:5a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Tue, 16 Feb
 2021 11:04:16 +0000
Received: from DM5PR1101MB2329.namprd11.prod.outlook.com
 ([fe80::e048:33b3:3453:5a9]) by DM5PR1101MB2329.namprd11.prod.outlook.com
 ([fe80::e048:33b3:3453:5a9%11]) with mapi id 15.20.3846.042; Tue, 16 Feb 2021
 11:04:16 +0000
From:   <Bjarni.Jonasson@microchip.com>
To:     <andrew@lunn.ch>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <vladimir.oltean@nxp.com>,
        <davem@davemloft.net>, <hkallweit1@gmail.com>,
        <atenart@kernel.org>, <ioana.ciornei@nxp.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Steen.Hegelund@microchip.com>
Subject: Re: [PATCH net-next v2 3/3] net: phy: mscc: coma mode disabled for
 VSC8514
Thread-Topic: [PATCH net-next v2 3/3] net: phy: mscc: coma mode disabled for
 VSC8514
Thread-Index: AQHXA9ZxNwTyPCZJNEexH28B2lTg+Kpan0CA
Date:   Tue, 16 Feb 2021 11:04:16 +0000
Message-ID: <e238cc1557233b81ae8e69b12b8f5af50adfdd87.camel@microchip.com>
References: <20210215165800.14580-1-bjarni.jonasson@microchip.com>
         <20210215165800.14580-3-bjarni.jonasson@microchip.com>
         <a3a7c583-e881-58d2-6c94-b68809a8b675@gmail.com>
In-Reply-To: <a3a7c583-e881-58d2-6c94-b68809a8b675@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [82.163.121.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 913ecc6f-8fdc-4980-4814-08d8d26a99ff
x-ms-traffictypediagnostic: DM5PR1101MB2249:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1101MB224932E3ADDA169C88441D24E4879@DM5PR1101MB2249.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MCw/WOXyagLSo98zNIwmSD0xWy9vSGG5jlCbQB1yu1iLfYreLZHF3QKLtnw+wgPWqFlUDIPwb1CX5gFKkdkPkGsOd+j/KvFu8sO+vaFZ2c+LpOfqVi9t5Bsczx2b+szTZxr38fOBpgjOpmGlndCfNZbYV51zXuxgpVjOhl7UnA+KySZdXd9YKWhK9MYq8rF9SRZMYeDttP54vDR9CCskVD3bcR4JM614EiDzES2nsBHlx0GqGfWn3whwlbS7tbH5BHkn9Vb6S06S5Ge9pv9vHeZYTwUxkkgBctmgM8RVbNWsRNJMU3euSzj9zMppWe/B7zbe4wHZ4rU/SehTn2ByiWPsYdeOsXKuOswW0PLo5ZmkJyDdoOTcaLlOjp5bC5lK9RHqT0DL7BC4xCQ75mvZPKE8uG6xmJh93ASRR1O9fO6jp0bXaofMdMn/vkm9vSpe6lE2SlEp3/+EB6TDSnzfFDm7PczCc2gn7FYYYxz7K6qT+hty4hutYGYwlDKimeaNDjApwlcYYy3dEreZTF5Phq5cJlw70RbHIYDeBwHVBtOgwhj0YTIZMOk8e7lQJQPO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1101MB2329.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(136003)(346002)(376002)(186003)(71200400001)(64756008)(66476007)(6512007)(110136005)(66556008)(66446008)(107886003)(54906003)(36756003)(26005)(76116006)(6486002)(91956017)(53546011)(5660300002)(6506007)(316002)(66946007)(4326008)(7416002)(8936002)(2906002)(86362001)(83380400001)(8676002)(2616005)(478600001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?N0NOcW9Ycy9CaVVqVm5uVUZkZmZqMm9Qa0ErNnVaeHNCc0xmYlZHbEpPcVY0?=
 =?utf-8?B?bGxhRmllckZXL1lpbXdnek90TTZielIzSEJ0U0NOby9ubGxldDVDREZCV0lj?=
 =?utf-8?B?QjU5bS90c3F6VVpXcGErc0NLbk5VZFQrN0RBQW10SWRZcHZWcU5GYk9IWGRB?=
 =?utf-8?B?ZjF6MUNWNVBRYUZHZTFyU2grLzdyMVNDcEZTSEpSbHhBMTJsb09pTk9rU2gv?=
 =?utf-8?B?SW8vcmpiZmxMWHU1NFBJSWF5NlZuWHZQcCtaRnp0NDlMeUI1VHkzOThYSUds?=
 =?utf-8?B?Rmx4VWFhME1zU3RtY1gzcjVmNnJEWVpZdVVrOWt5V2ZXb0JWWHZwVEgvTTUw?=
 =?utf-8?B?My9MUmFXYVk2WHZValloeFNHbGRQMDhGc0g2VHk3Q3dBdG9qc1Q4ZmF2eVVN?=
 =?utf-8?B?bHlsRVQzSXVOd093OXJyTzNPOUpzNGdPR0xiMUNiQ3c5WDd0bm04aHRKVDEr?=
 =?utf-8?B?bXIzK1drbm5mQWdFSWJyNUtEQXBZaHlmcU9QWDVBQy9MVVNBZkZMMUVad3RQ?=
 =?utf-8?B?WlRKQ29XREdLU1FFVEFqUkwwTVFONE9kcVFibkV4ZldiZUtmR3h2SjYyVXNS?=
 =?utf-8?B?UWNTelR0Nk42ck52WkF4NmJJVjBsWjhxd2RYVFdESEluZUkvNnQ5TUx4ZCtO?=
 =?utf-8?B?Zk5VMlQ2QnN4RVJWaGQzZFZGUWRoS1JkTjZJclRqcnpMLzFoYy92V3ptQVFM?=
 =?utf-8?B?VjBUVkJQNmM2R3A0enBxcUw2a0Y5SW1OWWpkNFBMazl6dVVhNnhyVEgzMWIx?=
 =?utf-8?B?Z0pZRlZsU0ZIekhzeUlaWDc5cDVwN0FvT2lSZEZhSTNZa2htYnpKSEMrc0tW?=
 =?utf-8?B?UVcxRkJ3R0R6SGFxU21tSlI5ZHRPQ0g0b0dvbWdEQkFSd1FZQmp5RCtLU2Nq?=
 =?utf-8?B?WWJEbjRySmEydjVhUlcxbUh0d0pHNEN5T2h1Y2xMdnY0eWFzRTBHVTZFbU9C?=
 =?utf-8?B?VHJqTHBCZnhpQ0pRaDQ1UlpodFZYWFNZWkcvVmt0T1A1YVAwdXRUSXVjVVA4?=
 =?utf-8?B?Ty9ZY3FUeTl2MVZjdkpXbjJIZ084bjZIUlBZQWlFOWNqaHpTMkIrcUhnR1ln?=
 =?utf-8?B?TkdyR2pBeHNUVUluUmVnZWtvSEdreVRPV3NzbUs1cDZkZENiUWsrQ3RmYlh5?=
 =?utf-8?B?c1lvSTc1WS9UQW9qdUVTL1ByK3k4YkloZVlVc2wrQ2NrYzA0OWdTSFBHWWF3?=
 =?utf-8?B?MytaQThQRjNnS3l1OSt3VEM5dGF5eEFvMDF4YmNUQjJEODc1NFNuWGZXWGxz?=
 =?utf-8?B?THZOdnNSalMwc3JKSnErWEtaQlppQ0UrNWUvR09nYnkyZHJlYytndVc3LzE2?=
 =?utf-8?B?NFBFbndjSkRlT2JnbEQvSVJtM1BOOTNiNmc5SkhJQ014Y3FlTC9YNjQwZDdH?=
 =?utf-8?B?TG1taytpeUh5MmRqenJrdWpJQStNOXBPQitEdUhyV005eitSYi9qa21GSnBG?=
 =?utf-8?B?MHNWZ1pJSVNqenR3U3RVSVcvaU50Si81ZUswUGNBODQ0SkJUSkJicVp4VDRH?=
 =?utf-8?B?dDkyNkVJZTBGV2cxUUMwVVp3TUFkenk4M0xFU0c1UTljcmJLbENpZGVVaUpy?=
 =?utf-8?B?akNLOXI4R2VzalFDN2dNTWpmais4QitHUzN1RjEwWnBmazlXcm4yV0YwK2RP?=
 =?utf-8?B?Qk5qSHNmdUoxMnZHaVlhNTRmNWV0ZzZ3L2VnUVBNRGdYa1RLMDlMY2ZMekJz?=
 =?utf-8?B?V2xZV2V1Wm52R2hZOHJlVDZ3dTFHL2hXOHFkTzFZbUh0S3piWUlKNm5hdGtK?=
 =?utf-8?Q?imYs09cLggmY4AmToRqXdCDgTsROMTvTAjmXx9M?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0251F4AF35DCA4EBEC2ED3173150776@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1101MB2329.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 913ecc6f-8fdc-4980-4814-08d8d26a99ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2021 11:04:16.4555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wi0uIL3DGDlur2EquV4D81b65BIpcEN9D6dp9CzjPgLBICMl+JShI6QZjp82w9SfxBoD/zWBuy5YYJVkKqq1+B74UVE67r1Kin8MYQmtyzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2249
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTAyLTE1IGF0IDIxOjA4ICswMTAwLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gMTUuMDIu
MjAyMSAxNzo1OCwgQmphcm5pIEpvbmFzc29uIHdyb3RlOg0KPiA+IFRoZSAnY29tYSBtb2RlJyAo
Y29uZmlndXJhYmxlIHRocm91Z2ggc3cgb3IgaHcpIHByb3ZpZGVzIGFuDQo+ID4gb3B0aW9uYWwg
ZmVhdHVyZSB0aGF0IG1heSBiZSB1c2VkIHRvIGNvbnRyb2wgd2hlbiB0aGUgUEhZcyBiZWNvbWUN
Cj4gPiBhY3RpdmUuDQo+ID4gVGhlIHR5cGljYWwgdXNhZ2UgaXMgdG8gc3luY2hyb25pemUgdGhl
IGxpbmstdXAgdGltZSBhY3Jvc3MNCj4gPiBhbGwgUEhZIGluc3RhbmNlcy4gVGhpcyBwYXRjaCBy
ZWxlYXNlcyBjb21hIG1vZGUgaWYgbm90IGRvbmUgYnkNCj4gPiBoYXJkd2FyZSwNCj4gPiBvdGhl
cndpc2UgdGhlIHBoeXMgd2lsbCBub3QgbGluay11cA0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6
IFN0ZWVuIEhlZ2VsdW5kIDxzdGVlbi5oZWdlbHVuZEBtaWNyb2NoaXAuY29tPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEJqYXJuaSBKb25hc3NvbiA8Ymphcm5pLmpvbmFzc29uQG1pY3JvY2hpcC5jb20+
DQo+ID4gRml4ZXM6IGU0ZjliYTY0MmYwYiAoIm5ldDogcGh5OiBtc2NjOiBhZGQgc3VwcG9ydCBm
b3IgVlNDODUxNA0KPiA+IFBIWS4iKQ0KPiA+IC0tLQ0KPiA+IHYxIC0+IHYyOg0KPiA+ICAgTW9k
aWZpZWQgY29tYSBtb2RlIGNvbmZpZw0KPiA+ICAgQ2hhbmdlZCBuZXQgdG8gbmV0LW5leHQNCj4g
PiANCj4gPiAgZHJpdmVycy9uZXQvcGh5L21zY2MvbXNjYy5oICAgICAgfCAgMyArKysNCj4gPiAg
ZHJpdmVycy9uZXQvcGh5L21zY2MvbXNjY19tYWluLmMgfCAxNiArKysrKysrKysrKysrKysrDQo+
ID4gIDIgZmlsZXMgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9waHkvbXNjYy9tc2NjLmgNCj4gPiBiL2RyaXZlcnMvbmV0L3BoeS9t
c2NjL21zY2MuaA0KPiA+IGluZGV4IDlkOGVlMzg3NzM5ZS4uMmI3MGNjZDFiMjU2IDEwMDY0NA0K
PiA+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9tc2NjL21zY2MuaA0KPiA+ICsrKyBiL2RyaXZlcnMv
bmV0L3BoeS9tc2NjL21zY2MuaA0KPiA+IEBAIC0xNjAsNiArMTYwLDkgQEAgZW51bSByZ21paV9j
bG9ja19kZWxheSB7DQo+ID4gICNkZWZpbmUgTVNDQ19QSFlfUEFHRV9UUiAgICAgICAgICAgICAg
IDB4NTJiNSAvKiBUb2tlbiByaW5nDQo+ID4gcmVnaXN0ZXJzICovDQo+ID4gICNkZWZpbmUgTVND
Q19QSFlfR1BJT19DT05UUk9MXzIgICAgICAgIDE0DQo+ID4gDQo+ID4gKyNkZWZpbmUgTVNDQ19Q
SFlfQ09NQV9NT0RFICAgICAgICAgICAgIDB4MjAwMCAvKiBpbnB1dCgxKSAvDQo+ID4gb3V0cHV0
KDApICovDQo+ID4gKyNkZWZpbmUgTVNDQ19QSFlfQ09NQV9PVVRQVVQgICAgICAgICAgIDB4MTAw
MCAvKiB2YWx1ZSB0byBvdXRwdXQNCj4gPiAqLw0KPiA+ICsNCj4gPiAgLyogRXh0ZW5kZWQgUGFn
ZSAxIFJlZ2lzdGVycyAqLw0KPiA+ICAjZGVmaW5lIE1TQ0NfUEhZX0NVX01FRElBX0NSQ19WQUxJ
RF9DTlQgICAgICAgIDE4DQo+ID4gICNkZWZpbmUgVkFMSURfQ1JDX0NOVF9DUkNfTUFTSyAgICAg
ICAgICAgICAgICAgR0VOTUFTSygxMywgMCkNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
cGh5L21zY2MvbXNjY19tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L3BoeS9tc2NjL21zY2NfbWFp
bi5jDQo+ID4gaW5kZXggMDMxODE1NDJiY2I3Li4yOTMwMmNjZjdlN2IgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9uZXQvcGh5L21zY2MvbXNjY19tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25l
dC9waHkvbXNjYy9tc2NjX21haW4uYw0KPiA+IEBAIC0xNTIwLDYgKzE1MjAsMjEgQEAgc3RhdGlj
IHZvaWQgdnNjODU4NF9nZXRfYmFzZV9hZGRyKHN0cnVjdA0KPiA+IHBoeV9kZXZpY2UgKnBoeWRl
dikNCj4gPiAgICAgICB2c2M4NTMxLT5hZGRyID0gYWRkcjsNCj4gPiAgfQ0KPiA+IA0KPiA+ICtz
dGF0aWMgdm9pZCB2c2M4NXh4X2NvbWFfbW9kZV9yZWxlYXNlKHN0cnVjdCBwaHlfZGV2aWNlICpw
aHlkZXYpDQo+ID4gK3sNCj4gPiArICAgICAvKiBUaGUgY29tYSBtb2RlIChwaW4gb3IgcmVnKSBw
cm92aWRlcyBhbiBvcHRpb25hbCBmZWF0dXJlDQo+ID4gdGhhdA0KPiA+ICsgICAgICAqIG1heSBi
ZSB1c2VkIHRvIGNvbnRyb2wgd2hlbiB0aGUgUEhZcyBiZWNvbWUgYWN0aXZlLg0KPiA+ICsgICAg
ICAqIEFsdGVybmF0aXZlbHkgdGhlIENPTUFfTU9ERSBwaW4gbWF5IGJlIGNvbm5lY3RlZCBsb3cN
Cj4gPiArICAgICAgKiBzbyB0aGF0IHRoZSBQSFlzIGFyZSBmdWxseSBhY3RpdmUgb25jZSBvdXQg
b2YgcmVzZXQuDQo+ID4gKyAgICAgICovDQo+ID4gKyAgICAgcGh5X3VubG9ja19tZGlvX2J1cyhw
aHlkZXYpOw0KPiA+ICsgICAgIC8qIEVuYWJsZSBvdXRwdXQgKG1vZGU9MCkgYW5kIHdyaXRlIHpl
cm8gdG8gaXQgKi8NCj4gPiArICAgICBwaHlfbW9kaWZ5X3BhZ2VkKHBoeWRldiwgTVNDQ19QSFlf
UEFHRV9FWFRFTkRFRF9HUElPLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgTVNDQ19QSFlf
R1BJT19DT05UUk9MXzIsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICBNU0NDX1BIWV9DT01B
X01PREUgfCBNU0NDX1BIWV9DT01BX09VVFBVVCwNCj4gPiAwKTsNCj4gPiArICAgICBwaHlfbG9j
a19tZGlvX2J1cyhwaHlkZXYpOw0KPiANCj4gVGhlIHRlbXBvcmFyeSB1bmxvY2sgaXMgYSBsaXR0
bGUgYml0IGhhY2t5LiBCZXR0ZXIgZG86DQo+IHZzYzg1eHhfcGh5X3dyaXRlX3BhZ2UoTVNDQ19Q
SFlfUEFHRV9FWFRFTkRFRF9HUElPKQ0KPiBfX3BoeV9tb2RpZnkoKQ0KPiB2c2M4NXh4X3BoeV93
cml0ZV9wYWdlKGRlZmF1bHQgcGFnZSkNCj4gDQo+IEFsdGVybmF0aXZlbHkgd2UgY291bGQgYWRk
IF9fcGh5X21vZGlmeV9wYWdlZCgpLiBCdXQgdGhpcyBtYXkgbm90DQo+IGJlIHdvcnRoIHRoZSBl
ZmZvcnQgZm9yIG5vdy4NCg0KSSB3aWxsIGZvbGxvdyB5b3VyIHN1Z2dlc3Rpb24uDQpUaHgNCi0t
DQpCamFybmkgSm9uYXNzb24NCk1pY3JvY2hpcA0KDQo+IA0KPiA+ICt9DQo+ID4gKw0KPiA+ICBz
dGF0aWMgaW50IHZzYzg1ODRfY29uZmlnX2luaXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikN
Cj4gPiAgew0KPiA+ICAgICAgIHN0cnVjdCB2c2M4NTMxX3ByaXZhdGUgKnZzYzg1MzEgPSBwaHlk
ZXYtPnByaXY7DQo+ID4gQEAgLTI2MDQsNiArMjYxOSw3IEBAIHN0YXRpYyBpbnQgdnNjODUxNF9j
b25maWdfaW5pdChzdHJ1Y3QNCj4gPiBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ID4gICAgICAgICAg
ICAgICByZXQgPSB2c2M4NTE0X2NvbmZpZ19ob3N0X3NlcmRlcyhwaHlkZXYpOw0KPiA+ICAgICAg
ICAgICAgICAgaWYgKHJldCkNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgZ290byBlcnI7DQo+
ID4gKyAgICAgICAgICAgICB2c2M4NXh4X2NvbWFfbW9kZV9yZWxlYXNlKHBoeWRldik7DQo+ID4g
ICAgICAgfQ0KPiA+IA0KPiA+ICAgICAgIHBoeV91bmxvY2tfbWRpb19idXMocGh5ZGV2KTsNCj4g
PiANCj4gDQo+IA0K
