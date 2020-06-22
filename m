Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C79202E0E
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 03:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgFVBTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 21:19:32 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:23588
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726529AbgFVBTb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 21:19:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUtxshz9rEoMYn5glLwJP7tu58rzJdLt4r+lqwzoTAKUyrfNEE/2e3Le3QhbkIYF6/qyK/ZzciHuBuzukE9NV+MMo10dHo4QKOYaAHCnxIgIZM0fJZViSBx0U+PpwdJaeENEcXIv0OsyKBd1WHdjPkPrKQs9FqF197N2syzZVpRVvK91B4nQnwYWv6dSGyxeqNpBadYqfygsGrwYr3HED1QC+rGAULX2g/sjSsnzoy8ItDho6a2iwRWKTJnrgEmI8X+kG7R+TKjg+TVJNM6FbSV55Ow0/GOCt68slveQ0aSqEYSGSieR2y2hZAMzk5q11Zv++boaBCKcwGhO6JzjOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwr+3dD62NqqgOgncHdeKiMm7g60XR5C+wuxGN/zcvY=;
 b=WYtaZkC9WyelvwfnUzhutvTnVF3fo1G82v5PrctHEbArjuLqKSUEpKnTpADEB8BBwHa5pRj0oM+aaTeFc+gX5NWZ8TgvMB/x8K2ZZX07E5rp0NmQ3hh8NmCOnfIdz6JvopWcuVHaIppEOZE7XCbGr0DYAbUt7jRiZG2l7R6k3qk4h91moFKznDy6OFVruQIx389iKNAi4/98ImQASuKcRnmKJYRSqIlQbBZEEmgNLAO9HjLWCQvL/2/m4dnF1BOYOFYo9ti8/0ntXYSXNad4/f+pTisQ1ENu5EeUtnfIwZcJzn/Lef0tJWoikd9s1dV3U/Ixvz7HXlWErmOvuuWPDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwr+3dD62NqqgOgncHdeKiMm7g60XR5C+wuxGN/zcvY=;
 b=gmUWZlGxxEzsnzbUtNXJT95lhqZxoCcIY8/jw/CIviNp5Q1UhQ7Do+LSSgiMan7he4kGVRn6klO3izogPX4CGSjZ3hpLq2DVfH6xUOC87LgAMf+umZfESn3KUPvrOXJDhSu1tFftXwmwF2kEWmpxBFmFGq3GVxP5kXTREa/w1Yo=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6670.eurprd04.prod.outlook.com (2603:10a6:803:120::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 01:19:27 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3109.026; Mon, 22 Jun 2020
 01:19:27 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "john.hurley@netronome.com" <john.hurley@netronome.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pieter.jansenvanvuuren@netronome.com" 
        <pieter.jansenvanvuuren@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: RE: Re: [RFC,net-next  8/9] net: qos: police action add index for tc
 flower offloading
Thread-Topic: Re: [RFC,net-next  8/9] net: qos: police action add index for tc
 flower offloading
Thread-Index: AdZIMS3QW2+l4dwgQjGOSfzM0l3hPw==
Date:   Mon, 22 Jun 2020 01:19:27 +0000
Message-ID: <VE1PR04MB6496E399A69D090331B27D4492970@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [114.241.15.28]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 80f7e823-19e8-4b28-28ed-08d8164a4e9a
x-ms-traffictypediagnostic: VE1PR04MB6670:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6670D427F41E8AB1C7E66B2092970@VE1PR04MB6670.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0442E569BC
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BftS9L75fIvaAESvQWZw5YImKKOQi7fN6JNrGdrSK1bYAgE/UxfHfahAquS3mtZp80GnoRNNOsHsIR2zZ2UnLlFgsTv5pjhc+qYAelGba0mosR141qkSL2rwOlGCj8ULff4XEx/39X2iD35y5aiTR8bq0MJe1h/e+H706E7Fsb+E/mmyonzMWLCsz+2u8T/42oIl3yi2Uc6Cb1mn6LCXnn+bAugY32EjOMlXb2yaLC+Xzan3bkw7Y0N10+FEITVksoGt20hxtay7/RCrxyOG8lZnzlwwZ0zGBnSVCoPq+DyGURit7T4xli3aXmH9ffYUUZ3r4ymXOzK0muvk79RHXOE3Eff5kwrhmLLbhEDeoPlk/ly7I/OYn53RMB0Ihllm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(71200400001)(9686003)(8676002)(316002)(83380400001)(8936002)(4326008)(52536014)(54906003)(55016002)(86362001)(2906002)(5660300002)(44832011)(26005)(66946007)(76116006)(186003)(6916009)(33656002)(53546011)(66476007)(6506007)(66446008)(7416002)(64756008)(7696005)(478600001)(66556008)(142933001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ftFLkx829NM5h2mmaX/0LBenkNmX2tMnkZ+1oJ/RCcdGEwz/aF/222XZ4DBDMHE9Yq33gqHpQUrLxymWWjmkQeXr61njSMARUoLclH5YoPkSfx+gPf2rMJCCz8/fkjHrsYixZwGf/BCrmFRhoprOMoozzglsBdQfm28BsimNDyS/e4KDlayb/csNT+iWOpAfLr28SrXIX+R2jGTYvyWejjFPtC9wUzTdokaLIDbBU2DHcUZUkNRfms5P6qiDZ3KGslfVixzH8gew9PvL1WRdZtrJLCxcRCLYDCSbWRK78byJOnHj2xH4YpKWFJia4yLf3MvGUFIUXreW+SdO2JJnCQw4UBvv9BODo9E34u9gnzL4/2SlpgCZlXwa0A6NcwqJ3/Fi8xnZZOOZ4SxkBjrz0ttrC0D3QjhmR97rqT5OwIenB0JWzK9aESU4J1jyxYZgLdx7EmPIfoUuvMG5b7ep+M43kjdwrvEcz1YxJFWP96M=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f7e823-19e8-4b28-28ed-08d8164a4e9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2020 01:19:27.2393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ruu5XFrcmMN05uVo5mm1qiSEhCmdXp9DxM6lW/6tFe3KTnn/arXuYbhvEVcJvKju
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6670
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSWRvLA0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSWRvIFNj
aGltbWVsIDxpZG9zY2hAaWRvc2NoLm9yZz4NCj4gU2VudDogMjAyMMTqNtTCMjHI1SAxODowNA0K
PiBUbzogUG8gTGl1IDxwby5saXVAbnhwLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7
IHZpbmljaXVzLmdvbWVzQGludGVsLmNvbTsgQ2xhdWRpdSBNYW5vaWwNCj4gPGNsYXVkaXUubWFu
b2lsQG54cC5jb20+OyBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsN
Cj4gQWxleGFuZHJ1IE1hcmdpbmVhbiA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBueHAuY29tPjsgWGlh
b2xpYW5nIFlhbmcNCj4gPHhpYW9saWFuZy55YW5nXzFAbnhwLmNvbT47IFJveSBaYW5nIDxyb3ku
emFuZ0BueHAuY29tPjsgTWluZ2thaSBIdQ0KPiA8bWluZ2thaS5odUBueHAuY29tPjsgSmVycnkg
SHVhbmcgPGplcnJ5Lmh1YW5nQG54cC5jb20+OyBMZW8gTGkNCj4gPGxlb3lhbmcubGlAbnhwLmNv
bT47IG1pY2hhZWwuY2hhbkBicm9hZGNvbS5jb207IHZpc2hhbEBjaGVsc2lvLmNvbTsNCj4gc2Fl
ZWRtQG1lbGxhbm94LmNvbTsgbGVvbkBrZXJuZWwub3JnOyBqaXJpQG1lbGxhbm94LmNvbTsNCj4g
aWRvc2NoQG1lbGxhbm94LmNvbTsgYWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5jb207DQo+IFVO
R0xpbnV4RHJpdmVyQG1pY3JvY2hpcC5jb207IGt1YmFAa2VybmVsLm9yZzsgamhzQG1vamF0YXR1
LmNvbTsNCj4geGl5b3Uud2FuZ2NvbmdAZ21haWwuY29tOyBqb2huLmh1cmxleUBuZXRyb25vbWUu
Y29tOw0KPiBzaW1vbi5ob3JtYW5AbmV0cm9ub21lLmNvbTsNCj4gcGlldGVyLmphbnNlbnZhbnZ1
dXJlbkBuZXRyb25vbWUuY29tOyBwYWJsb0BuZXRmaWx0ZXIub3JnOw0KPiBtb3NoZUBtZWxsYW5v
eC5jb207IGl2YW4ua2hvcm9uemh1a0BsaW5hcm8ub3JnOyBtLWthcmljaGVyaTJAdGkuY29tOw0K
PiBhbmRyZS5ndWVkZXNAbGludXguaW50ZWwuY29tOyBqYWt1Yi5raWNpbnNraUBuZXRyb25vbWUu
Y29tDQo+IFN1YmplY3Q6IFJlOiBbUkZDLG5ldC1uZXh0IDgvOV0gbmV0OiBxb3M6IHBvbGljZSBh
Y3Rpb24gYWRkIGluZGV4IGZvcg0KPiB0YyBmbG93ZXIgb2ZmbG9hZGluZw0KPiANCj4gDQo+IE9u
IEZyaSwgTWFyIDA2LCAyMDIwIGF0IDA4OjU2OjA2UE0gKzA4MDAsIFBvIExpdSB3cm90ZToNCj4g
PiBIYXJkd2FyZSBtYXkgb3duIG1hbnkgZW50cmllcyBmb3IgcG9saWNlIGZsb3cuIFNvIHRoYXQg
bWFrZSBvbmUob3INCj4gPiAgbXVsdGkpIGZsb3cgdG8gYmUgcG9saWNlZCBieSBvbmUgaGFyZHdh
cmUgZW50cnkuIFRoaXMgcGF0Y2ggYWRkIHRoZQ0KPiA+IHBvbGljZSBhY3Rpb24gaW5kZXggcHJv
dmlkZSB0byB0aGUgZHJpdmVyIHNpZGUgbWFrZSBpdCBtYXBwaW5nIHRoZQ0KPiA+IGRyaXZlciBo
YXJkd2FyZSBlbnRyeSBpbmRleC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFBvIExpdSA8UG8u
TGl1QG54cC5jb20+DQo+IA0KPiBIaSwNCj4gDQo+IEkgc3RhcnRlZCBsb29raW5nIGludG8gdGMt
cG9saWNlIG9mZmxvYWQgaW4gbWx4c3cgYW5kIHJlbWVtYmVyZWQgeW91cg0KPiBwYXRjaC4gQXJl
IHlvdSBwbGFubmluZyB0byBmb3JtYWxseSBzdWJtaXQgaXQ/IEknbSBhc2tpbmcgYmVjYXVzZSBp
biBtbHhzdw0KPiBpdCBpcyBhbHNvIHBvc3NpYmxlIHRvIHNoYXJlIHRoZSBzYW1lIHBvbGljZXIg
YmV0d2VlbiBtdWx0aXBsZSBmaWx0ZXJzLg0KDQpZZXMsIEkgYW0gcHJlcGFyaW5nIHRoZSBwYXRj
aGVzIGFuZCBwdXNoIGFnYWluIHZlcnkgc29vbi4gVGhlIHBhdGNoZXMgd2lsbCBhZGQgbXR1IGFu
ZCBpbmRleCBmb3Igb2ZmbG9hZGluZyBhcyBmaXJzdCBzdGVwLiANClRoZSBuZXh0IHN0ZXAgaXMg
c2Vla2luZyBtZXRob2QgdG8gIGltcGxlbWVudCB0d28gY29sb3IgKyB0d28gYnVja2V0cyBtb2Rl
IGJ1dCBzZWVtcyBhYnNlbnQgb25lIGJ1Y2tldCBpbiBwb2xpY2luZyBhY3Rpb24uIFRoZSBjdXJy
ZW50IGJ1cnN0ICsgcmF0ZV9ieXRlc19wcyBvbmx5IGNhbiBvbmx5IGltcGxlbWVudCBvbmUgY29s
b3IrIG9uZSBidWNrZXQgcG9saWNpbmcuIA0KDQo+IA0KPiBUaGFua3MNCj4gDQo+ID4gLS0tDQo+
ID4gIGluY2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oIHwgMSArDQo+ID4gIG5ldC9zY2hlZC9jbHNf
YXBpLmMgICAgICAgIHwgMSArDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCsp
DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvZmxvd19vZmZsb2FkLmggYi9pbmNs
dWRlL25ldC9mbG93X29mZmxvYWQuaA0KPiA+IGluZGV4IDU0ZGY4NzMyOGVkYy4uM2I3OGIxNWVk
MjBiIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oDQo+ID4gKysr
IGIvaW5jbHVkZS9uZXQvZmxvd19vZmZsb2FkLmgNCj4gPiBAQCAtMjAxLDYgKzIwMSw3IEBAIHN0
cnVjdCBmbG93X2FjdGlvbl9lbnRyeSB7DQo+ID4gICAgICAgICAgICAgICAgICAgICAgIGJvb2wg
ICAgICAgICAgICAgICAgICAgIHRydW5jYXRlOw0KPiA+ICAgICAgICAgICAgICAgfSBzYW1wbGU7
DQo+ID4gICAgICAgICAgICAgICBzdHJ1Y3QgeyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgLyogRkxPV19BQ1RJT05fUE9MSUNFICovDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIHUz
MiAgICAgICAgICAgICAgICAgICAgIGluZGV4Ow0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBz
NjQgICAgICAgICAgICAgICAgICAgICBidXJzdDsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAg
dTY0ICAgICAgICAgICAgICAgICAgICAgcmF0ZV9ieXRlc19wczsNCj4gPiAgICAgICAgICAgICAg
ICAgICAgICAgdTMyICAgICAgICAgICAgICAgICAgICAgbXR1Ow0KPiA+IGRpZmYgLS1naXQgYS9u
ZXQvc2NoZWQvY2xzX2FwaS5jIGIvbmV0L3NjaGVkL2Nsc19hcGkuYyBpbmRleA0KPiA+IDM2M2Qz
OTkxNzkzZC4uY2U4NDZhOWRhZGMxIDEwMDY0NA0KPiA+IC0tLSBhL25ldC9zY2hlZC9jbHNfYXBp
LmMNCj4gPiArKysgYi9uZXQvc2NoZWQvY2xzX2FwaS5jDQo+ID4gQEAgLTM1ODQsNiArMzU4NCw3
IEBAIGludCB0Y19zZXR1cF9mbG93X2FjdGlvbihzdHJ1Y3QgZmxvd19hY3Rpb24NCj4gKmZsb3df
YWN0aW9uLA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBlbnRyeS0+cG9saWNlLnJhdGVfYnl0
ZXNfcHMgPQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRjZl9wb2xpY2VfcmF0
ZV9ieXRlc19wcyhhY3QpOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBlbnRyeS0+cG9saWNl
Lm10dSA9IHRjZl9wb2xpY2VfbXR1KGFjdCk7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIGVu
dHJ5LT5wb2xpY2UuaW5kZXggPSBhY3QtPnRjZmFfaW5kZXg7DQo+ID4gICAgICAgICAgICAgICB9
IGVsc2UgaWYgKGlzX3RjZl9jdChhY3QpKSB7DQo+ID4gICAgICAgICAgICAgICAgICAgICAgIGVu
dHJ5LT5pZCA9IEZMT1dfQUNUSU9OX0NUOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBlbnRy
eS0+Y3QuYWN0aW9uID0gdGNmX2N0X2FjdGlvbihhY3QpOw0KPiA+IC0tDQo+ID4gMi4xNy4xDQo+
ID4NCg0KVGhhbmtzIGEgbG90IQ0KQnIsDQpQbyBMaXUNCg0K
