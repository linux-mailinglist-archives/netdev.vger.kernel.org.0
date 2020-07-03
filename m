Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF87213139
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 04:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgGCCBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 22:01:23 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:14675
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726032AbgGCCBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 22:01:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpAJWl30vK1xSfJ8hW8PzCK6D9gsIeiFpNlVaeCNC/5/sG878SjdG0teHcuUBJpehHisKr2dJYMITewM+jFGoHFoeJ2mTiLMFxOZaf6XR4uQaFSv/h0lZfbx61fdJ4cjOYkS+NDQUG28v4Y2QsaIhWmMRg0NIryGlbBtY3UtXvCKgcg1CkEHycwtSBweNed6KtCSmEx0e7c52LGmB6pS7pkr5szPkGZKwLVLOCxuJRDpkYkKl2x9xqHtgE3nBiEfxH8S9iewm6L7loPpENsJedQ9EGlKdchWkKm64WPMwUct+gZXsju5Jn0myEZY/Dir+1FRrQY75G4wz3870oz7HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKAa+aMp96cLvVbRKzQP9heJns1xct1xqOk8uXlILJc=;
 b=Au/4n3GRMm8J0bLm4YkbfnGt8GcbbvUBBUyzrgUzJ9FpoTTRLS8Zj+X+5KrKQMVk1LB9RbSYqOUP2Vwf/sBl7uqhC7AFCJiozMX+A2WI3l1F8qjUeGtActJJsBk/cI4xZg2AX2lXthKatB+vbfqQBBDtwSp6hnLlGVUyV/+uiLvbXYkDZEJ0IKRr3Y+bOgekulcL/ZCbAmdO8kn6GW3rJ+N3BAFC2MQdZqViXEgisftE6PvmEuaJ1qFWWs4LTIDAz9T7SAF9neshaLExPahUVT+PiXeF7O4FWA7ucGTNDfGd1O6R4586UruaP1v4hLAudL/w32MNmvAIzkwXQBmCHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKAa+aMp96cLvVbRKzQP9heJns1xct1xqOk8uXlILJc=;
 b=aYO73hNnhMKFypgla2RSRtWF4kAqHA4MqkBKYz/WaZUMtWcxL7aIYWAPYJmVZWvayhFRF2eM5IXDnTcUh79S/jrtEeWV+3XbIVc1Y3vqz32Ekr8PvYOthjA6z/aL0xAWIfjOv8Z3rJ26OhyLZtHMAv8OKvCcw2GPQmqpiGE7siQ=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR04MB5991.eurprd04.prod.outlook.com
 (2603:10a6:20b:9d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24; Fri, 3 Jul
 2020 02:01:18 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f%5]) with mapi id 15.20.3153.027; Fri, 3 Jul 2020
 02:01:18 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Sven Van Asbroeck <thesven73@gmail.com>,
        Fabio Estevam <festevam@gmail.com>
CC:     Shawn Guo <shawnguo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v5 3/3] ARM: imx6plus: optionally enable
 internal routing of clk_enet_ref
Thread-Topic: [EXT] Re: [PATCH v5 3/3] ARM: imx6plus: optionally enable
 internal routing of clk_enet_ref
Thread-Index: AQHWUMBIY0/PmQIJzUKZXhlXPuzWDKj1BoiAgAASrZA=
Date:   Fri, 3 Jul 2020 02:01:18 +0000
Message-ID: <AM6PR0402MB36074F535033A80140748928FF6A0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200702175352.19223-1-TheSven73@gmail.com>
 <20200702175352.19223-3-TheSven73@gmail.com>
 <CAOMZO5DxUeXH8ZYxmKynA7xO3uF6SP_Kt-g=8MPgsF7tqkRvAA@mail.gmail.com>
 <CAGngYiUEx98QUAHrzFNWzMr5+oPS4-7Nqq91JzhtzGUG7=kagQ@mail.gmail.com>
In-Reply-To: <CAGngYiUEx98QUAHrzFNWzMr5+oPS4-7Nqq91JzhtzGUG7=kagQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 584e2ab9-e895-4388-14aa-08d81ef4f9d6
x-ms-traffictypediagnostic: AM6PR04MB5991:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB5991B996DA6BF9B4E29C7874FF6A0@AM6PR04MB5991.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nI7Sd1GSwHzl5wXGwANvsFfij5WMzhHYIipPPATZ8EynlvfN1AwnXt24hOt3GKt4mgTFVtIcnztKubbcg5pOd5j4bvf6+SwTMA+IdnvZGP8Opc7hgeqsoQ2U/Gbpp1u0kgYm7nKBnuvQ9vGJ8e4eUXbpU2bz7/ZjmloxVxuj8C6w6QI5p4qt9GAsULc5IZRUoO/kVkC+r6j9EuudS8/8/Ygb3pbFjPBBJUpykmHolr6E8A8+A1WByvyvrezeJ4EaTT20bCXEknj6jz0YhcU56/yRAxc7vwl8ZAtZkoKJa5Qxsjys+YsJ6eTuroJu+lXbpK2VhwljEabJyC+Bo8cdGKHLNVYyxJK09Sz/ySGp6WfAbqFNTVAbpyM4vEyhL1CA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(83380400001)(26005)(4326008)(186003)(4744005)(7696005)(2906002)(110136005)(54906003)(8936002)(316002)(7416002)(86362001)(8676002)(76116006)(33656002)(478600001)(66946007)(66476007)(66556008)(66446008)(6506007)(53546011)(64756008)(52536014)(71200400001)(55016002)(5660300002)(9686003)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: HDgImFtqkX3//f0JB4d57/DSvHA4pwZ8V2Gen0xSqLlEuEJQSQ+fNtgt4bqUG25IFTyQxLOrc9u6vFy3Z50EBZigKwQcvrW0SvdF5VB1PF8sWx7qOvPKXq2CzIYGRWd/4+sJJcTYpsEcZwvpI4/er8xB1wYSV4Sf5iFNLQvDg++GbWnCeZAXoi6rapfCABumOdvi7gAlB5J/rBOSXV/6z2c3HHPcV0QJSDly807cRPUG4TwRUXPgFYeh6ffdgOSt7Dl0CDEF5yZO2zlQ5TBX9iRoZAmdwNDg9GF/X+B/Z14rogXG62jHpLRL8eC8sul9XQhO+nrtcwjCuM8cOFsMevZ4/ng7x0ddaDpBzxqMDllGDYH2PhuK+p44j/xx7RpCf8RmTyjG4vqp0rouuqpYEpvvdnzjV8afVleitunDTMLIuFaKem2E6TDEBMZM+SmNCYGZwu292QSGjc3hLrjgQdcO+mO4gEJz9+OoXkSQVsY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 584e2ab9-e895-4388-14aa-08d81ef4f9d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 02:01:18.4366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ksqYyioM0bspNQa4ZuHUevjDfM614F0NEFla5TTxsBbP3Ily0jEml91/v14oMsYbxtDFbFVrAFtU2H8MlEePkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5991
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU3ZlbiBWYW4gQXNicm9lY2sgPHRoZXN2ZW43M0BnbWFpbC5jb20+IFNlbnQ6IEZyaWRh
eSwgSnVseSAzLCAyMDIwIDg6NTEgQU0NCj4gSGkgRmFiaW8sDQo+IA0KPiBPbiBUaHUsIEp1bCAy
LCAyMDIwIGF0IDY6MjkgUE0gRmFiaW8gRXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29tPiB3cm90
ZToNCj4gPg0KPiA+IFdpdGggdGhlIGRldmljZSB0cmVlIGFwcHJvYWNoLCBJIHRoaW5rIHRoYXQg
YSBiZXR0ZXIgcGxhY2UgdG8gdG91Y2gNCj4gPiBHUFI1IHdvdWxkIGJlIGluc2lkZSB0aGUgZmVj
IGRyaXZlci4NCj4gPg0KPiANCj4gQ29vbCBpZGVhLiBJIG5vdGljZSB0aGF0IHRoZSBsYXRlc3Qg
RkVDIGRyaXZlciAodjUuOC1yYzMpIGFjY2Vzc2VzIGluZGl2aWR1YWwgYml0cw0KPiBpbnNpZGUg
dGhlIGdwciAodmlhIGZzbCxzdG9wLW1vZGUpLiBTbyBwZXJoYXBzIEkgY2FuIGRvIHRoZSBzYW1l
IGhlcmUsIGFuZA0KPiBwb3B1bGF0ZSB0aGF0IGdwciBub2RlIGluIGlteDZxcC5kdHNpIC0gYmVj
YXVzZSBpdCBkb2Vzbid0IGV4aXN0IG9uIG90aGVyIFNvQ3MuDQo+IA0KPiA+IEZvciB0aGUgcHJv
cGVydHkgbmFtZSwgd2hhdCBhYm91dCBmc2wsdHhjbGstZnJvbS1wbGw/DQo+IA0KPiBTb3VuZHMg
Z29vZC4gRG9lcyBhbnlvbmUgaGF2ZSBtb3JlIHN1Z2dlc3Rpb25zPw0KDQpUaGUgcHJvcGVydHkg
c2VlbXMgZ29vZCwgZG9uJ3QgbGV0IHRoZSBwcm9wZXJ0eSBjb25mdXNlIHNvbWVib2R5IGZvciBv
dGhlcg0KcGxhdGZvcm1zLCBiaW5kaW5nIGRvYyBkZXNjcmliZSB0aGUgcHJvcGVydHkgaXMgbGlt
aXRlZCB0byB1c2UgZm9yIGlteDZxcCBvbmx5Lg0K
