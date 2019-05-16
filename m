Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C8220832
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 15:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfEPNbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 09:31:17 -0400
Received: from mail-eopbgr20047.outbound.protection.outlook.com ([40.107.2.47]:29879
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726528AbfEPNbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 09:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCgt6aJ4FHdlBcWirefvbkbgnsQtFRXZ5rwvzDoRq4A=;
 b=VtBsh4pw73zPcebTqr+K3LTT6av4XRu4pvrHG6n5g6mnY69fPIinhCh/CJwMZhVsj3xNufODKjMqFcmuAUNx/xNPMm4JZKc9PYPL16KkDBwm2aSEpRy6eypfqzufa4u5OdJMzroi3/HBOslQXpLNy+IpAbF8Lvvmbl6umQbmN20=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB5742.eurprd04.prod.outlook.com (20.178.127.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Thu, 16 May 2019 13:31:12 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::d9de:1be3:e7e6:757f]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::d9de:1be3:e7e6:757f%3]) with mapi id 15.20.1900.010; Thu, 16 May 2019
 13:31:12 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        David Miller <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] enetc: add hardware timestamping support
Thread-Topic: [PATCH 1/3] enetc: add hardware timestamping support
Thread-Index: AQHVC84BpTq18Sng3k254t8Y+2yCUKZtu0bw
Date:   Thu, 16 May 2019 13:31:12 +0000
Message-ID: <VI1PR04MB4880C3E6D24AB7A53887D9C9960A0@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <20190516100028.48256-1-yangbo.lu@nxp.com>
 <20190516100028.48256-2-yangbo.lu@nxp.com>
In-Reply-To: <20190516100028.48256-2-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af669eba-f862-4790-fd83-08d6da02c36d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5742;
x-ms-traffictypediagnostic: VI1PR04MB5742:
x-microsoft-antispam-prvs: <VI1PR04MB5742891663A18BB2EDD4A25F960A0@VI1PR04MB5742.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(396003)(39860400002)(136003)(376002)(13464003)(199004)(189003)(55016002)(478600001)(6436002)(9686003)(3846002)(4326008)(6116002)(53936002)(64756008)(256004)(33656002)(73956011)(66476007)(66556008)(71190400001)(66946007)(66446008)(76116006)(2906002)(110136005)(6246003)(71200400001)(446003)(2501003)(229853002)(7696005)(76176011)(54906003)(66066001)(26005)(74316002)(102836004)(305945005)(44832011)(486006)(7736002)(6506007)(25786009)(86362001)(99286004)(81156014)(81166006)(186003)(5660300002)(14454004)(11346002)(476003)(68736007)(8936002)(8676002)(316002)(4744005)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5742;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Q10LGT+o1yOJVNPfES/wALUGZNVQgjpq5dbbFUJqf6iH9Ce5/oZPyEMdzsp18cQoFOYY/APOeEV/dk1/gtl4pBnjdmEkMBEc+wkkLX2tK4PsPSy+/6SPdBVODYy7AJ0LF4CELj6ooPLwGDufgrPMrFUi9yYn+T199Yi6vm0LrYF7fz5k4Z3Lhx2mQv5Yj4zkDzK7LevvHbKUSIgznRk5QTfUQRsify8LwA7lSNFEmuqDW7QKM7YKbkrodEVfKF49eBGOajuFdd6u4m1C3fzXBhf5SSQ3tCgYEHvmHLsGsGIH28acyBv/YEXHxr9iQ4Yob/Hxnc6sn0lwVrC5zMTpeQL+SmhYIymtZIT+nupYVU2KbDa2uRaCv/9kiwlX1IVhLrIf1bPg1++kClgZsTqm0tasPbEjLCvYzuKaf5AT9h4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af669eba-f862-4790-fd83-08d6da02c36d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 13:31:12.2079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5742
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogWS5iLiBMdQ0KWy4uLl0NCj5TdWJq
ZWN0OiBbUEFUQ0ggMS8zXSBlbmV0YzogYWRkIGhhcmR3YXJlIHRpbWVzdGFtcGluZyBzdXBwb3J0
DQo+DQpbLi4uXQ0KDQpIaSBZYW5nYm8sDQoNClRoZXNlIGVuZXRjIHBhdGNoZXMgdGFyZ2V0aW5n
IG5ldC1uZXh0IHdpbGwgaGF2ZSB0byBiZSByZWJhc2VkIG9uDQp0aGUgbGF0ZXN0IGVuZXRjIG5l
dC5naXQgY29tbWl0cywgb3RoZXJ3aXNlIHRoZXJlIHdpbGwgYmUgc29tZSBtZXJnZQ0KY29uZmxp
Y3RzIGZvciBlbmV0Yy5jIGFuZCBlbmV0Y19ldGh0b29sLmMuDQpUaGFua3MsDQpDbGF1ZGl1DQoN
CnNlZQ0KMjJmYjQzZjM2MDA2ICJlbmV0YzogQWRkIG1pc3NpbmcgbGluayBzdGF0ZSBpbmZvIGZv
ciBldGh0b29sIg0KZjRhMGJlODRkNzNlICJlbmV0YzogRml4IE5VTEwgZG1hIGFkZHJlc3MgdW5t
YXAgZm9yIFR4IEJEIGV4dGVuc2lvbnMiDQoNCg==
