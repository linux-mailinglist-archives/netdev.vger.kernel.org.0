Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80AA71A296B
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 21:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbgDHTiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 15:38:55 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:25927
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729144AbgDHTiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 15:38:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1MgquxvASx5xZj8XxFoVBMVccZsiNLL2ADSwdV+XtGnNTZe2nkGMpoSgTGF7IbwjSyQfqY/8Tp6LDcyP1gP6nLzhtOkl7p/tp4dsI4RBaVdAUHMs/cUh1I3fcrYfCgxhoXsommkfRo9+IMwXpeuGeaBXKRcYE8Vcgwwzpvk19rYNIlqNnzMdUkbjj/YQocjdOyO0Z7Bl2ryUELpj/V0KlYAo1BJFEbN9s9hUkevWlUPbAjCciY/tJQFtEAobtBEjoK0e5pXSwn/45IVa36gzKP7PcCdhgUi0Lht0QUap22BTfEDCoqFIiKNMRgLykjiRAPYTYRxfAKbw42XWjMJng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1yemx7dBpE/p/AmNoPtEiU7nPK56iwcrsM9mPpO9ck=;
 b=GQcBSYL4E2ojqaT0scqhcP4Q2N9hekZcM9TCnbmUgNKtCTEP7AQcWgboA5lJHAcWSzZTq74kMzVBaN8UgO78N8/6pR9avqozcNycS//9FnmTZGLIbouevUJMYqfQpnjQwzllmVv2pOTGQqA9yvn0L34mW6UokTX9q7vkCrCnkPT8KauDp2qyVoIBtTkUqrv8h3VhHKODiEbwcSw5S60TiCJmmoK3aL31eBhtltcvKVwl2rYljAwLHJjTl+Let/Cpd8n4xYT3J/ENmmrnvVnecKdfL8etR+UOrUuvkiVTCn9X5LbKSAs8elt0LPUvhdjbXCgLYYiI3V08hO/4+yfCOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1yemx7dBpE/p/AmNoPtEiU7nPK56iwcrsM9mPpO9ck=;
 b=VsZzjyopzOy35Xa+jCFveNyTqt7z5cvJaI5bYjPCozmAFYRb/8dy2lghSfyzPpaNqLLFwU9Ze6xERtC42UEekY36xcRilikAB1uum0gMftVwqKt0HUdnc2YZ/69BQkT1Hlm9qttUh0UvJ/NsD5HzlESAGwjvZlvZTm+L9ZYNUc8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3472.eurprd05.prod.outlook.com (2603:10a6:802:1a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.17; Wed, 8 Apr
 2020 19:38:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 19:38:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "Markus.Elfring@web.de" <Markus.Elfring@web.de>,
        "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Eran Ben Elisha <eranbe@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [RFC] net/mlx5: Fix failing fw tracer allocation on s390
Thread-Topic: [RFC] net/mlx5: Fix failing fw tracer allocation on s390
Thread-Index: AQHWDO7rXNooSevpp0u4ixl0JMbrO6hu32sAgADBXYA=
Date:   Wed, 8 Apr 2020 19:38:51 +0000
Message-ID: <bf22d830013fcdae7b955ac687d96437cd21cc19.camel@mellanox.com>
References: <77241c76-4836-3080-7fa6-e65fc3af5106@web.de>
         <7eaec712-6427-7adf-98cd-2c4347dd9e85@linux.ibm.com>
In-Reply-To: <7eaec712-6427-7adf-98cd-2c4347dd9e85@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 29ab1092-5b01-4700-0c2a-08d7dbf47779
x-ms-traffictypediagnostic: VI1PR05MB3472:|VI1PR05MB3472:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3472558F42D8A562A8B4DFB3BEC00@VI1PR05MB3472.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:446;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(396003)(39850400004)(346002)(366004)(136003)(4326008)(4744005)(71200400001)(26005)(5660300002)(186003)(6486002)(478600001)(81156014)(2616005)(8936002)(81166007)(6506007)(53546011)(8676002)(66556008)(110136005)(64756008)(66476007)(66446008)(91956017)(316002)(107886003)(76116006)(54906003)(2906002)(66946007)(86362001)(36756003)(6512007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xw+w4mBXZ40CVpVvUjs3Cv3rBQuepcIm5v+Z8+ger8ymUVmYYwVNYASTCxEWlEfW6UX4ynCne1N3KP/51foJtfAcWx/p08IXX9XBfcXz7AchxzyST+lKPG4MtWZZh2SlDKLd6FgDBfF645fhCDO0pCNihuPCB1CmyD6OKiafVXVIjDaxW5S1Xs4tzHklQ7FmKMirRsT6kwrwo29uC+Wwe1So3ztPyujtvI/Nfdi0ZY267g51kCgO1phtKj9JOpp22/OTTLBm04863ESt9NNU4jlELgoFwTZnIU4opY25uv5qMbVZ/LrVldfsCm1j4FQz32+Chk09UfCWFv+TtrXGFSAb8hQxoGDBL/zWEXy64BHX4W6g/ymWGdSCCPqsBN/Mxyx45D2w75UMrK53hgXLJ3bwVsjBsTk+LXZxwyrv1Y0xMuujY+UPGFO1Cpsg7Uh2
x-ms-exchange-antispam-messagedata: gKSjipCBQVQcCiaXKW8yfo6ZISCD/r2rNzX/alarLEfSFXQpkZYKSedtuX5ZWd5bVakLjsia+V9Au8Lf1f3zEaDRx4mtEKlWphHQdlUasJuOp1zbxTVrBfpiAy7PerrWHdNElbjJLMexTnRmWi6gdw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB97C905B2697D4F9430CD411E50E76D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29ab1092-5b01-4700-0c2a-08d7dbf47779
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 19:38:51.8419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xhsBf+0a2q3cxh78JYKC06Lsdx7YCyKxr3JQijwQltkuFXL0drE5WD9R/MBQB7+T/JwYmGmJW9dpCkyRg3ZzyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3472
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA0LTA4IGF0IDEwOjA2ICswMjAwLCBOaWtsYXMgU2NobmVsbGUgd3JvdGU6
DQo+IE9uIDQvNy8yMCA1OjEyIFBNLCBNYXJrdXMgRWxmcmluZyB3cm90ZToNCj4gPiA+IE9uIHMz
OTAgRk9SQ0VfTUFYX1pPTkVPUkRFUiBpcyA5IGluc3RlYWQgb2YgMTEsIHRodXMgYSBsYXJnZXIN
Cj4gPiA+IGt6YWxsb2MoKQ0KPiA+ID4gYWxsb2NhdGlvbiBhcyBkb25lIGZvciB0aGUgZmlybXdh
cmUgdHJhY2VyIHdpbGwgYWx3YXlzIGZhaWwuDQo+ID4gDQo+ID4gSG93IGRvIHlvdSB0aGluayBh
Ym91dCB0byBhZGQgdGhlIHRhZyDigJxGaXhlc+KAnSB0byB0aGUgZmluYWwgY2hhbmdlDQo+ID4g
ZGVzY3JpcHRpb24/DQo+ID4gDQo+ID4gUmVnYXJkcywNCj4gPiBNYXJrdXMNCj4gPiANCj4gWW91
J3JlIHJpZ2h0IHRoYXQgbWFrZXMgYSBsb3Qgb2Ygc2Vuc2UsIHRoYW5rcyEgSSBndWVzcyB0aGlz
IHNob3VsZA0KPiByZWZlcmVuY2UNCj4gdGhlIGNvbW1pdCB0aGF0IGludHJvZHVjZWQgdGhlIGRl
YnVnIHRyYWNlLCByaWdodD8NCj4gDQoNCnByb2JhYmx5LCBqdXN0IGdpdCBibGFtZSB0aGlzIGxp
bmU6DQogIHRyYWNlciA9IGt6YWxsb2Moc2l6ZW9mKCp0cmFjZXIpLCBHRlBfS0VSTkVMKTsNCg0K
