Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 525ED78F8B
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 17:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387941AbfG2Pjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 11:39:36 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:58894
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387496AbfG2Pjg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 11:39:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GaNdccnlO4Vhm73ip3X1mpCWN5iJAKPJCP1aWNMkYl8fb9giwhrCB08uguVESxzXC04HtBFqLLkeA+OkoUeOWFaY1fmCiyOPuRDXAjQllub+GbB/szEoUy504qmuj8KVA7OT8UBb1UyX6fwld9gB3dvH+SbwxS5N2sev65dJDzkpSQ44XJWSMSHOLoCmbIVbxEFLPd1rahjS5J9/VRRevTwNfcC64g+7rS09HIzee78LI5Q/mZ3Ak87Lucimb+8XUx9IZU+Z+5sY/PSuyegfhQpZIxX562jcFrdkwl0JpCJZtfkOjS9LXY/cHE0+dXm36FtShE1tqCVArE/UwuDDxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0VGKXhn0DuBIy37MHBwPHlh7x1/6FWHVs/R1HlowrY=;
 b=MAB8/6PsPy7OLxu2hrMzXPKuI589dKT9lnI7yBMzJfWp/XyFsH7+RolLisOVxER38X5L5gxuYxhk3droZvT4urB1U4rpU56I2LfycuvTla9OWk62bDHPWgD65qkoutmLgVbbSYZiqyNVOCbJV720ihk41dBil20FJ2RKZv+zIciTYZ40mveOnrJThq8MrChzxDTSN21Q8fCRhVaVY+qhv0qKYzmF3xcOW6CjPXZZdfhwlq025kykaV5ojDXQg+IKu4+iT3yHItpwY+vKOPUIo423GJBd9WB2wy/7qdN/L217+Rx+/hpvUOrvpY3stHkIISHHQVhFbgx2HkfjuBOdUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0VGKXhn0DuBIy37MHBwPHlh7x1/6FWHVs/R1HlowrY=;
 b=qtPhQ+bN7IsQR4z4q7LMRSv/xzJEh994YdjYZQT3b+oyWLkqvPWKFrs4sadFG1qE09Bne1uHCHTPMCHylz3d+touN8oEdpHn0v8zKWMrVx7NcH8JM5rl3bpVxzJHhcyKzGHLOWZvXVeVVuAVLKeQBgA1Ii2hdSPluIEEnToaurc=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB5197.eurprd04.prod.outlook.com (20.177.51.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 15:39:32 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::e401:6546:3729:47c0]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::e401:6546:3729:47c0%6]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 15:39:32 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v3 2/4] enetc: Add mdio bus driver for the PCIe
 MDIO endpoint
Thread-Topic: [PATCH net-next v3 2/4] enetc: Add mdio bus driver for the PCIe
 MDIO endpoint
Thread-Index: AQHVRfTzIlSQL21yzUKJl+LDCQ5gdabhupAA////0TA=
Date:   Mon, 29 Jul 2019 15:39:31 +0000
Message-ID: <VI1PR04MB48806AF2F6CEDE105B78086696DD0@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <1564394627-3810-1-git-send-email-claudiu.manoil@nxp.com>
 <1564394627-3810-3-git-send-email-claudiu.manoil@nxp.com>
 <20190729153524.GG4110@lunn.ch>
In-Reply-To: <20190729153524.GG4110@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c90a2cd-1c52-4d3b-864a-08d7143af364
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR04MB5197;
x-ms-traffictypediagnostic: VI1PR04MB5197:
x-microsoft-antispam-prvs: <VI1PR04MB5197B8012BA2CFCFC392D2EF96DD0@VI1PR04MB5197.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(13464003)(189003)(199004)(33656002)(71190400001)(86362001)(52536014)(6916009)(99286004)(8676002)(305945005)(71200400001)(5660300002)(25786009)(256004)(76176011)(7736002)(76116006)(66946007)(6246003)(66556008)(64756008)(66476007)(66446008)(74316002)(4326008)(68736007)(102836004)(6506007)(66066001)(6436002)(26005)(55016002)(14454004)(229853002)(7696005)(446003)(316002)(54906003)(486006)(11346002)(186003)(44832011)(476003)(478600001)(8936002)(53936002)(9686003)(81166006)(81156014)(2906002)(3846002)(6116002)(4744005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5197;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: A43O05XHdcMAWQlB14ieyvWtnEva87NU3cFbAMxKn51xArS9s4uDXfl6bxqThgH2KVJmejPwD9pLttZX/zHs5nfM8MM1KwIPKy4nsjMKzHf+5yHQbmyIT9MNbJCCxWCkzvBupfApUmqxrc7J/xSDPJa6tpVNLxZ734JjU8RaohJ9ti2RvdJ7pAg0yjNvYcygIHPNZIxINdGPCm3gCxADTNNceNWYOKnevSffIN4e7CFvzoPWwQScEVJkLp1BHZwhkUHgd2YEyU2wqNpVjb2O4SI/HZOABQyiCag7woefH9+zHqz/jZE+5/o+PqUczEU+4a18/I4t/0Q6x/uDdvV23iYQceEpLQpH/QqbA2Tww8U4p60YEPdS6fofm9N5X/VHRWqE9mi1kiX6ZN+8E7+gTh+Jurc/cAenlTworOfyiaE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c90a2cd-1c52-4d3b-864a-08d7143af364
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 15:39:31.8995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: claudiu.manoil@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5197
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogQW5kcmV3IEx1bm4gPGFuZHJld0Bs
dW5uLmNoPg0KPlNlbnQ6IE1vbmRheSwgSnVseSAyOSwgMjAxOSA2OjM1IFBNDQo+VG86IENsYXVk
aXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPg0KPkNjOiBEYXZpZCBTIC4gTWlsbGVy
IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgUm9iIEhlcnJpbmcNCj48cm9iaCtkdEBrZXJuZWwub3Jn
PjsgTGVvIExpIDxsZW95YW5nLmxpQG54cC5jb20+OyBBbGV4YW5kcnUgTWFyZ2luZWFuDQo+PGFs
ZXhhbmRydS5tYXJnaW5lYW5AbnhwLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+ZGV2
aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFk
Lm9yZzsgbGludXgtDQo+a2VybmVsQHZnZXIua2VybmVsLm9yZw0KPlN1YmplY3Q6IFJlOiBbUEFU
Q0ggbmV0LW5leHQgdjMgMi80XSBlbmV0YzogQWRkIG1kaW8gYnVzIGRyaXZlciBmb3IgdGhlIFBD
SWUNCj5NRElPIGVuZHBvaW50DQo+DQo+PiArCWh3LT5wb3J0ID0gcGNpX2lvbWFwKHBkZXYsIDAs
IDApOw0KPj4gKwlpZiAoIWJ1cy0+cHJpdikgew0KPg0KPmh3LT5wb3J0ID8/DQo+DQoNClllYWgs
IGJldHRlciBpZ25vcmUgdGhpcyBmb3Igbm93IPCfmIoNCkl0J3MgZm9yIHRoZSBlbmV0YyBhY2Nl
c3NvcnMsIGVuZXRjX3BvcnRfLi4oKS4NCg==
