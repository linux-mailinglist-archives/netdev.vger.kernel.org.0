Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DE2204B6A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731553AbgFWHlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:41:32 -0400
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:19425
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731202AbgFWHla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 03:41:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9hlnayZHIUPtbMHqgOYEVw5qQoEEG2ZkdFZxT0QChRKQd3s2NRRKLBCO9O1cg1oj+B/q92eNsv/KzNNiHjFfhjv5wDUhz90U6bQxNZQbsT3KPm5pgbopy3AltSMN0Ryxv5aTNIRS3lptkJMI5fWupfL0qHaLMLkqGDUH5k08zfx9JKLCqayfDG/V2vAWsBaRrcv5t5E2wQbFEcCWYuq48B8J8jjizRVhGo9C47z9EsW3VTqpZ1qvJGw1S1t+VxuYM8S/eIfT6BizzYfJMn3GwOPyjy0F3fcYKSmuBUt4fc4PCCQu2v2nFS7zRJTwavRXT/kk5w14hJ1xsVZt2YJ0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zf+70UacBNv4O/L8sGOrYxrYWqdZ3dZI/nCDWuPg8yw=;
 b=O3qXA05QxBZYNRlHuGrw/4Zrx0dlmgpt8mRvevr8Y2MvzZbYFY3F55bfaEuuO2mffLP2JX70f5bHwQp+PtCrclIHLBnp2Og4n6nwXQqN4FzofhQEnXIsHnQ5oMUVDADKI4nTgotZSmdm+PofEGHkirCHQSqBnSpmHANihvdHHSzaaBdkmHFannYhUK8+9trBJBx7KKm6D86AchseFE0SluaNaBQdzi47EGpRWVIbtHvkn37ISIjcMPfupkbGJLmnb8q3b14ueS3Nh9RUyDr0vBeX3zzqolXEJQV8Z5Ja+F8lOqYlocfnTHy3WdDvAbXr5KgFn63/p3oiJSye8IWG2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zf+70UacBNv4O/L8sGOrYxrYWqdZ3dZI/nCDWuPg8yw=;
 b=C+lq1//7/nQPqGV3/pApgNYzkA1ZQtBSORmmTjX1r+rwxia/me0csa+jpU1PRHHkEVS2jC+5El79v69Pi/4/Lyjj26tX79mpubdX+mXf/mmXnoTJQED9wC4ijY/66fOBHubdKkMGPCX82p54Kyw7FzUaqXqJIs0UHBbaSeeXHcQ=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6718.eurprd04.prod.outlook.com (2603:10a6:803:124::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 07:41:27 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 07:41:26 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "vlad@buslov.dev" <vlad@buslov.dev>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
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
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: RE:Re: [v1,net-next 3/4] net: qos: police action add index for tc
 flower offloading
Thread-Topic: Re: [v1,net-next 3/4] net: qos: police action add index for tc
 flower offloading
Thread-Index: AdZJMapo3COxHqjOTAinGP+yeLyswQ==
Date:   Tue, 23 Jun 2020 07:41:26 +0000
Message-ID: <VE1PR04MB6496D0C5A104FAA56F9F5C9092940@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [221.221.90.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e95ec8a2-7b25-4702-e4e7-08d81748d617
x-ms-traffictypediagnostic: VE1PR04MB6718:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB671808FC88CA3D4A5E30FE5B92940@VE1PR04MB6718.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mgdFU9puyZ44SqZFakbnbpszNI8ubMZ/lPqiY1EaUshIVKnD/jB9Eeuhzxmew7CovbrtxBR5MFnznx/9jqAfRd8NCHEms51j0ndFjcl2xOCPxQmWzBQWlpfT+xSvjw+S6XRBg9PpiwpmVhgQfg/mBbnNqFIp0J9ToMRnuki4tePojX8njmHDPjBJ4vHwW020AH9p81DmDwusObJecWrOqDg8tGw2WecqW5ZHXaX99hCjsoUGvQjFS2pqBgiBOKEjTnrEfVXDhtpis4fYlu/m2VuhQHJ1OH2+k/Fwy9HuXsaI3LCoT+DbAk2mhEZ6yB/BInd/mLSMefApMp6GOMrcKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(86362001)(8936002)(8676002)(186003)(54906003)(52536014)(5660300002)(64756008)(66556008)(66476007)(76116006)(66946007)(66446008)(4326008)(316002)(55016002)(44832011)(33656002)(2906002)(478600001)(6506007)(71200400001)(9686003)(53546011)(7696005)(83380400001)(6916009)(7416002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: q0zyqgBHDOPOVkqpvPXCx6BD+nPze4ijHyCsESwEfQfKOZ4lAM1pJIGUCbbMIWjOKmQC0Q/bk6oMyZusQuT9GTm/K5apOVCa24eTRuraVYgV6xQMOtshWrFbdqsR8eiXFo1McTMC7epYyux/cnb1yK1tRD1kuKpoxjrJlQ4zPZE2xu3Cjyo8gOmTHLiTwrcDhF4qVYS6vuV1FdTCHVQuip/yTi33zZvZb3IZ0SgLLzDlp59FzUQKvDJjnY4j76E6OUW8yrpuAPSZJzyBjRyL2IKHwNW7X1ZqO9UOF11/XxKqeRvZA3Glr53zARNRWllUqjuT7iuGTCFpAbS5PdznpzLGU2XrP2tL175g9pbZqPEeA6aC+/UZ6NHt+Lt5N+2Qs1XnVYe3UuwTQKg08fAnquhGwM4G5tThekLarX72J6PkVTshJn1hhokT+Fwitdr3lZo2b2UYorG8qYeaKpRCVIXzf4fU80y0MX1KXde9lT/g0TG4CupGa9c/sIBHT/sK
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e95ec8a2-7b25-4702-e4e7-08d81748d617
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 07:41:26.8100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qMNvTuEARGd8oBYn/+zqOnLK7uNrC7le8CATD479zGqziG5s5zALwmlsw5DWgbQV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6718
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSWRvLA0KDQpTb3JyeSwgaWdub3JlIHByZXZpb3VzIGVtYWlsLg0KDQo+IC0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IElkbyBTY2hpbW1lbCA8aWRvc2NoQGlkb3NjaC5vcmc+
DQo+IFNlbnQ6IDIwMjDE6jbUwjIzyNUgMTU6MTANCj4gVG86IFBvIExpdSA8cG8ubGl1QG54cC5j
b20+DQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBqaXJpQHJlc251bGxpLnVzOyB2aW5pY2l1
cy5nb21lc0BpbnRlbC5jb207DQo+IHZsYWRAYnVzbG92LmRldjsgQ2xhdWRpdSBNYW5vaWwgPGNs
YXVkaXUubWFub2lsQG54cC5jb20+OyBWbGFkaW1pcg0KPiBPbHRlYW4gPHZsYWRpbWlyLm9sdGVh
bkBueHAuY29tPjsgQWxleGFuZHJ1IE1hcmdpbmVhbg0KPiA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBu
eHAuY29tPjsgbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTsNCj4gdmlzaGFsQGNoZWxzaW8uY29t
OyBzYWVlZG1AbWVsbGFub3guY29tOyBsZW9uQGtlcm5lbC5vcmc7DQo+IGppcmlAbWVsbGFub3gu
Y29tOyBpZG9zY2hAbWVsbGFub3guY29tOw0KPiBhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNv
bTsgVU5HTGludXhEcml2ZXJAbWljcm9jaGlwLmNvbTsNCj4ga3ViYUBrZXJuZWwub3JnOyBqaHNA
bW9qYXRhdHUuY29tOyB4aXlvdS53YW5nY29uZ0BnbWFpbC5jb207DQo+IHNpbW9uLmhvcm1hbkBu
ZXRyb25vbWUuY29tOyBwYWJsb0BuZXRmaWx0ZXIub3JnOw0KPiBtb3NoZUBtZWxsYW5veC5jb207
IG0ta2FyaWNoZXJpMkB0aS5jb207DQo+IGFuZHJlLmd1ZWRlc0BsaW51eC5pbnRlbC5jb207IHN0
ZXBoZW5AbmV0d29ya3BsdW1iZXIub3JnDQo+IFN1YmplY3Q6IFJlOiBbdjEsbmV0LW5leHQgMy80
XSBuZXQ6IHFvczogcG9saWNlIGFjdGlvbiBhZGQgaW5kZXggZm9yIHRjDQo+IGZsb3dlciBvZmZs
b2FkaW5nDQo+IA0KPiBPbiBUdWUsIEp1biAyMywgMjAyMCBhdCAwMjozNDoxMVBNICswODAwLCBQ
byBMaXUgd3JvdGU6DQo+ID4gRnJvbTogUG8gTGl1IDxQby5MaXVAbnhwLmNvbT4NCj4gPg0KPiA+
IEhhcmR3YXJlIG1heSBvd24gbWFueSBlbnRyaWVzIGZvciBwb2xpY2UgZmxvdy4gU28gdGhhdCBt
YWtlIG9uZShvcg0KPiA+ICBtdWx0aSkgZmxvdyB0byBiZSBwb2xpY2VkIGJ5IG9uZSBoYXJkd2Fy
ZSBlbnRyeS4gVGhpcyBwYXRjaCBhZGQgdGhlDQo+ID4gcG9saWNlIGFjdGlvbiBpbmRleCBwcm92
aWRlIHRvIHRoZSBkcml2ZXIgc2lkZSBtYWtlIGl0IG1hcHBpbmcgdGhlDQo+ID4gZHJpdmVyIGhh
cmR3YXJlIGVudHJ5IGluZGV4Lg0KPiANCj4gTWF5YmUgZmlyc3QgbWVudGlvbiB0aGF0IGl0IGlz
IHBvc3NpYmxlIGZvciBtdWx0aXBsZSBmaWx0ZXJzIGluIHNvZnR3YXJlIHRvDQo+IHNoYXJlIHRo
ZSBzYW1lIHBvbGljZXIuIFNvbWV0aGluZyBsaWtlOg0KPiANCj4gIg0KPiBJdCBpcyBwb3NzaWJs
ZSBmb3Igc2V2ZXJhbCB0YyBmaWx0ZXJzIHRvIHNoYXJlIHRoZSBzYW1lIHBvbGljZSBhY3Rpb24g
YnkNCj4gc3BlY2lmeWluZyB0aGUgYWN0aW9uJ3MgaW5kZXggd2hlbiBpbnN0YWxsaW5nIHRoZSBm
aWx0ZXJzLg0KPiANCj4gUHJvcGFnYXRlIHRoaXMgaW5kZXggdG8gZGV2aWNlIGRyaXZlcnMgdGhy
b3VnaCB0aGUgZmxvdyBvZmZsb2FkDQo+IGludGVybWVkaWF0ZSByZXByZXNlbnRhdGlvbiwgc28g
dGhhdCBkcml2ZXJzIGNvdWxkIHNoYXJlIGEgc2luZ2xlIGhhcmR3YXJlDQo+IHBvbGljZXIgYmV0
d2VlbiBtdWx0aXBsZSBmaWx0ZXJzLg0KPiAiDQo+IA0KDQpUaGFua3MsIEkgd291bGQgY2hhbmdl
IHRoaXMgY29tbWl0IG1lc3NhZ2UuDQoNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFBvIExpdSA8
UG8uTGl1QG54cC5jb20+DQo+ID4gLS0tDQo+ID4gIGluY2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5o
IHwgMSArDQo+ID4gIG5ldC9zY2hlZC9jbHNfYXBpLmMgICAgICAgIHwgMSArDQo+ID4gIDIgZmls
ZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS9uZXQvZmxvd19vZmZsb2FkLmggYi9pbmNsdWRlL25ldC9mbG93X29mZmxvYWQuaA0KPiA+IGlu
ZGV4IGMyZWYxOWM2YjI3ZC4uZWVkOTgwNzViMWFlIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUv
bmV0L2Zsb3dfb2ZmbG9hZC5oDQo+ID4gKysrIGIvaW5jbHVkZS9uZXQvZmxvd19vZmZsb2FkLmgN
Cj4gPiBAQCAtMjMyLDYgKzIzMiw3IEBAIHN0cnVjdCBmbG93X2FjdGlvbl9lbnRyeSB7DQo+ID4g
ICAgICAgICAgICAgICAgICAgICAgIGJvb2wgICAgICAgICAgICAgICAgICAgIHRydW5jYXRlOw0K
PiA+ICAgICAgICAgICAgICAgfSBzYW1wbGU7DQo+ID4gICAgICAgICAgICAgICBzdHJ1Y3QgeyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLyogRkxPV19BQ1RJT05fUE9MSUNFICovDQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgIHUzMiAgICAgICAgICAgICAgICAgICAgIGluZGV4Ow0K
PiA+ICAgICAgICAgICAgICAgICAgICAgICBzNjQgICAgICAgICAgICAgICAgICAgICBidXJzdDsN
Cj4gPiAgICAgICAgICAgICAgICAgICAgICAgdTY0ICAgICAgICAgICAgICAgICAgICAgcmF0ZV9i
eXRlc19wczsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgdTMyICAgICAgICAgICAgICAgICAg
ICAgbXR1Ow0KPiA+IGRpZmYgLS1naXQgYS9uZXQvc2NoZWQvY2xzX2FwaS5jIGIvbmV0L3NjaGVk
L2Nsc19hcGkuYyBpbmRleA0KPiA+IDZhYmE3ZDViYTFlYy4uZmRjNGM4OWNhMWZhIDEwMDY0NA0K
PiA+IC0tLSBhL25ldC9zY2hlZC9jbHNfYXBpLmMNCj4gPiArKysgYi9uZXQvc2NoZWQvY2xzX2Fw
aS5jDQo+ID4gQEAgLTM2NTksNiArMzY1OSw3IEBAIGludCB0Y19zZXR1cF9mbG93X2FjdGlvbihz
dHJ1Y3QgZmxvd19hY3Rpb24NCj4gKmZsb3dfYWN0aW9uLA0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICBlbnRyeS0+cG9saWNlLnJhdGVfYnl0ZXNfcHMgPQ0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHRjZl9wb2xpY2VfcmF0ZV9ieXRlc19wcyhhY3QpOw0KPiA+ICAgICAgICAg
ICAgICAgICAgICAgICBlbnRyeS0+cG9saWNlLm10dSA9IHRjZl9wb2xpY2VfdGNmcF9tdHUoYWN0
KTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgZW50cnktPnBvbGljZS5pbmRleCA9IGFjdC0+
dGNmYV9pbmRleDsNCj4gPiAgICAgICAgICAgICAgIH0gZWxzZSBpZiAoaXNfdGNmX2N0KGFjdCkp
IHsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgZW50cnktPmlkID0gRkxPV19BQ1RJT05fQ1Q7
DQo+ID4gICAgICAgICAgICAgICAgICAgICAgIGVudHJ5LT5jdC5hY3Rpb24gPSB0Y2ZfY3RfYWN0
aW9uKGFjdCk7DQo+ID4gLS0NCj4gPiAyLjE3LjENCj4gPg0KDQoNCkJyLA0KUG8gTGl1DQo=
