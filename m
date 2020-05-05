Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD411C51EA
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 11:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgEEJ2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 05:28:13 -0400
Received: from mail-eopbgr30041.outbound.protection.outlook.com ([40.107.3.41]:22713
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbgEEJ2M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 05:28:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrKsDyh1yRHTSTIQlEAjMzoVa5kgl851/vfhI/Hf9MJvoqDVN9KCkPOuW1xdwSt4eaVYssCgPE9SNAWYl1YqEJ0iL0fEajSKgBidhMrUlDvtCEUcMW4SQIZXHtBmjl5zyAO61cDdzk3oeqr2Mc2L/JIeD2zHbQG+Myc0qToVSYiaDx019rDPMf78OUv9heQhVJ3SsJrMVIw+5e7xk0Dwh9aNx/P3UJq7V1pJULhAwWQ+4o1JVIbqHD/hEE/2LgADZSlvW4WgyjJhVnX4/+x7YsJVJ8hAVf+bCrPvkUHd69TQWu1AvPNTHAH8oHO2Nnl+HM/44QBXYBA11syTNVK5SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0C+ugtKc4EdQbJBDPGZHsh+EXdM58MihfrEVPRuWgAk=;
 b=cCY9+wQHDLZdycTg2r89MuQzSr3K9z4dCjTFR2rN1SRZrGSNhyy2KMp4/mb38ss1gqIXl+ngZDX6HgQ5xbNioOsSWpPcZHthk9f6dHnPBuhwWfTqQh+C695pLRSJotmAw0s3K797/oKZ9kvqm/Xkoif5Bigu/XW5mb2o44ffCjq6TJcC8zGinHGwNXR9dW5LxMlidXY5PBobvSrO+FNvjoSMAg8e8oIhX9SD2YibGEbWZ0EJ9ZKKWE8BFeFFL2hXMtVpWZ3driW3Lf3uaBkr6SySfGnWRwFAZdxKA1/2LSLYWnrrpuzc0oiFwf1OhLpRMMIOWkrLlOGKQsrsGkea0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0C+ugtKc4EdQbJBDPGZHsh+EXdM58MihfrEVPRuWgAk=;
 b=W7w2UjevnrnUp5K/VXYRan4kOip0UbuqjCL52MmBei5R2ppjliuZvqXv0+d1VlpiHnZGERo6zXyUh/yBXv+a/eqyFhJEsCYCjOYL4JbcrpoKLehO/adgPmv0lxWh0dUGL0q+WPLC/M3yat3nuDCc9xCJUbT8n/awA7590uZZNzY=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6751.eurprd04.prod.outlook.com (2603:10a6:803:128::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Tue, 5 May
 2020 09:28:07 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 09:28:07 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>
Subject: RE: Re: [v3,iproute2 1/2] iproute2:tc:action: add a gate control
 action
Thread-Topic: Re: [v3,iproute2 1/2] iproute2:tc:action: add a gate control
 action
Thread-Index: AdYiv3VBpVMv48SeQpGUFB261Kc8Og==
Date:   Tue, 5 May 2020 09:28:07 +0000
Message-ID: <VE1PR04MB6496BFC11F9195C32D00931092A70@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6bd4a841-b539-4f62-0a55-08d7f0d69f19
x-ms-traffictypediagnostic: VE1PR04MB6751:|VE1PR04MB6751:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6751060DE60769B3BEA4EFC292A70@VE1PR04MB6751.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0394259C80
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p+dSAZlVbp+dezt5LCqpEJ9v3LsfuUS5mo9jJdFQYbZN9a0R1W9VKD1isyOsaraEfNe9gS51UVYPGbUCYDUeAUp5suEERD7nGaWG7V9o4HWIUlVp5wOW/xrtHJBXOOY1C3iKya/ekTungWbdsDkJaJa2zHqAIjIQKLywxCSWrVPWKtgxaeyhne5g1kdS1mdZKYA3CGGpc/xFXaTLfKAYu+TAQsB/HajNUlh03hQk+3X9SW2wjxPJooMebf/wkvO9DTilUZ+Zk8bSH+iaQmccdINNCQoQLs8SM87+GValWtAo+9eTF3QMELyyL09laSGtiBdjiUcC1RECHvsWdYn1WztYt1dJi7fgtwOm+Fmn+WFFNBWIGiXeJtZqHA+KK4mHAv3wZgbdbldKvw2WO9/bzbgHD9251JMtwiEPUCV/2HOiJUARyL8WEbyR/dQRdnoj88+tnNARScUtWPC58O6DGegD5Yimm1oj27f3nmrHVk2PGqOSDkT66kFOoVEWnCOhgHdSqM8T1r/40r6OACEcmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(33430700001)(2906002)(5660300002)(66476007)(8676002)(7696005)(4326008)(8936002)(66446008)(66556008)(66946007)(26005)(64756008)(44832011)(6506007)(53546011)(76116006)(186003)(71200400001)(52536014)(316002)(478600001)(110136005)(86362001)(33440700001)(9686003)(33656002)(55016002)(54906003)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: m72/KdfLdL5/QNzG2rDAilRoTyg96/QDrLuMDowEdd/vAsk4+mK4vJI0jlj9alomslW843kvsCGL8LZnraKO4D1kifwqbQ0YQSXkE1YJ09UATAcGxo7rwb263shtUiVvmaHhuADUHGe1zNos5W5uS6AdgHiqjHoy8JRNq9SBnbtcDxZnXlpjh1ciGRU70M8TEIaUqOSbTD2N6OQLgqVyv8tHpZJdyyX9yl1MQp6JDskvrta8wABwKPcqpEPl9gpwbHIX1E2AErFMlMIElmlAtKAiHUDKWr1T+RlHxi9rtxfxSfe7Lvt+4t6dc9lyWhIuP1EksmFl/hANQkWmJlWx4Lke/QmKb06/owJf/Fs8OffTRH4gV6LAPCcf2I5kCooJ5UDH7Bpq+BIymgBmiQYv4S/4fLACTPKvXCpOy3RBR/5btwKvJtRSfGFq3RmS7z37JxkapKl89VxZwrLuHkjLB9ByRvyVlfz9hCC2TLMmxIEO8ymUhmKyB1D670r5aadvbikbpk8OLmfvY9kQEjOz5O4XvtvpJ3zKnq0DVjv/4RCxac7tfrLv0+sNvr15gvYQfVZ5DmS6a0Emw1kuXLpzs1HpiuWZev6BQ+2Ia+B15HXYu6+JBpsotrF8X5Dfc6p1npzmQxTI1BRwc/MtAnTccG2ZTfRTfRM/JXbZXocPCnjjBIbNFBW5erD096lKIhQ3O4Tkqx5CVO6KbBNgSoHi+pQL2E2ulQ+ySazU14fAxm6l7x0/x1mempQEzKNY9qgWoFojYZkTPnWaccMll3C4vYiIRn/Au/88JlsmK5fcZEk=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bd4a841-b539-4f62-0a55-08d7f0d69f19
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2020 09:28:07.7581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ryOlQoa+V9E2j22JzHO+LOKNaBf40gd9uE3xu99BGUijXp+nPUpuq728m7wpH/n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6751
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3RlcGhlbiwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTdGVw
aGVuIEhlbW1pbmdlciA8c3RlcGhlbkBuZXR3b3JrcGx1bWJlci5vcmc+DQo+IFNlbnQ6IDIwMjDE
6jXUwjXI1SA4OjA3DQo+IFRvOiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPg0KPiBDYzogZGF2ZW1A
ZGF2ZW1sb2Z0Lm5ldDsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZzsgdmluaWNpdXMuZ29tZXNAaW50ZWwuY29tOyB2bGFkQGJ1c2xvdi5kZXY7
DQo+IENsYXVkaXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPjsgVmxhZGltaXIgT2x0
ZWFuDQo+IDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT47IEFsZXhhbmRydSBNYXJnaW5lYW4NCj4g
PGFsZXhhbmRydS5tYXJnaW5lYW5AbnhwLmNvbT47IG1pY2hhZWwuY2hhbkBicm9hZGNvbS5jb207
DQo+IHZpc2hhbEBjaGVsc2lvLmNvbTsgc2FlZWRtQG1lbGxhbm94LmNvbTsgbGVvbkBrZXJuZWwu
b3JnOw0KPiBqaXJpQG1lbGxhbm94LmNvbTsgaWRvc2NoQG1lbGxhbm94LmNvbTsNCj4gYWxleGFu
ZHJlLmJlbGxvbmlAYm9vdGxpbi5jb207IFVOR0xpbnV4RHJpdmVyQG1pY3JvY2hpcC5jb207DQo+
IGt1YmFAa2VybmVsLm9yZzsgeGl5b3Uud2FuZ2NvbmdAZ21haWwuY29tOw0KPiBzaW1vbi5ob3Jt
YW5AbmV0cm9ub21lLmNvbTsgcGFibG9AbmV0ZmlsdGVyLm9yZzsNCj4gbW9zaGVAbWVsbGFub3gu
Y29tOyBtLWthcmljaGVyaTJAdGkuY29tOw0KPiBhbmRyZS5ndWVkZXNAbGludXguaW50ZWwuY29t
DQo+IFN1YmplY3Q6IFJlOiBbdjMsaXByb3V0ZTIgMS8yXSBpcHJvdXRlMjp0YzphY3Rpb246IGFk
ZCBhIGdhdGUgY29udHJvbA0KPiBhY3Rpb24NCj4gDQo+IE9uIFN1biwgIDMgTWF5IDIwMjAgMTQ6
MzI6NTAgKzA4MDANCj4gUG8gTGl1IDxQby5MaXVAbnhwLmNvbT4gd3JvdGU6DQo+IA0KPiA+ICsg
ICAgICAgICAgICAgcHJpbnRfc3RyaW5nKFBSSU5UX0FOWSwgImdhdGUgc3RhdGUiLCAiXHRnYXRl
LXN0YXRlICUtOHMiLA0KPiANCj4gTkFLDQo+IFNwYWNlIGluIGEganNvbiB0YWcgaXMgbm90IHZh
bGlkLg0KPiANCj4gUGxlYXNlIHJ1biBhIGR1bXAgY29tbWFuZCBhbmQgZmVlZCBpdCBpbnRvIEpT
T04gdmFsaWRhdGlvbiBjaGVja2VyIGxpa2UNCj4gUHl0aG9uLg0KDQpJIHdvdWxkIHRlc3QganNv
biBmb3JtYXQgYW5kIHVwbG9hZCBuZXcgdmVyc2lvbiAgcGF0Y2ggc2V0Lg0KDQpUaGFua3MhDQpC
ciwNClBvIExpdQ0K
