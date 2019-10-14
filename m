Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5F53D6199
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 13:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730807AbfJNLpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 07:45:30 -0400
Received: from mail-eopbgr710073.outbound.protection.outlook.com ([40.107.71.73]:65464
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730178AbfJNLp3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 07:45:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UF3jH5OdcU1HE/BmTNwXP9juPQi9TOuLmIJZKfKlBkhJvZIVbd71rzGDT3Gr3HChNkReTgL38WMSUZsUwOlibJikHgMGZSU7uI4l2juVWELa9xly8sTirx2JStZijnFtGlfKGv7suIJ/0Ted+ABXygAZBagxs3f8T/rv0Z6v3fC7mAPK5rQbbk/fP6VHskTKzKYQv98gi26rbFM33B/5qXxCd1+GlOxvTxjeRDPgNN06zN8LwqH0pMsWvKyM7TA4N4H0OFIPhrigmkJRSnmg00lLrZuPXPZH8IAcUUD94dOiOux4BLTavThhLp3dAgOuz2ZfVoijKRpO9ZX+/J1+bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwkU2uqoDZziMVu1pwB6enUECQhLRWAgXBYeOvrTUt4=;
 b=bKu71iRZ+hTJEawBRQZID26XuFU7Z31eDwzmkOsRZwaw7JMjioaKVbFia/anjupBI1Q+J/6fsUmAz1XEjSAXtUlaKR3cunB52MjnktFDfbBXk9+M5ayT570kEnnf6HLO590hmoYFTgPNSOg05T9NP0QsrjAU0DBhvcimD2HbRwLzfob8Rt1IaHiBKnuTbXSZ06NXWSWK1u+WB427kpRr7QVGcQ6QwPTieSbKOPevqLru+BNXsOHIRSVjY2MxUifz85blaRJaNIFyzL0sZJC8sHw4msMys8wOYerngyP8lttb2OdjBUgIjBRcTcQSk1I4hmmXZ4MM4iF6liho7Lk34w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwkU2uqoDZziMVu1pwB6enUECQhLRWAgXBYeOvrTUt4=;
 b=nxFF8P2Fkkl6IpIjeDyz0xQShToduMzmf4uAmuCrwtgv3U2nm/itfzRVb3XKUvy/JeCecxaWx42zf1JohmmlVytxd7UBFw8WOvofsKo48LBZjE8yFe2CV+emGAk2oiMY8nFhzaaeh8Q6+IqVYbha2bO/E7uvhYugwosCZDg4Oa8=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3828.namprd11.prod.outlook.com (20.178.220.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Mon, 14 Oct 2019 11:45:28 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.023; Mon, 14 Oct 2019
 11:45:28 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v2 net-next 09/12] net: aquantia: implement get_ts_info
 ethtool
Thread-Topic: [PATCH v2 net-next 09/12] net: aquantia: implement get_ts_info
 ethtool
Thread-Index: AQHVfccYExjJPQMOJUibtnb4Jx6x/A==
Date:   Mon, 14 Oct 2019 11:45:28 +0000
Message-ID: <d78f0bee-2d7d-904d-9198-798edc4c3740@aquantia.com>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <58f42998778f9fa152174f4bbc175b1b09ed54b8.1570531332.git.igor.russkikh@aquantia.com>
 <20191012190717.GL3165@localhost>
In-Reply-To: <20191012190717.GL3165@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:a03:180::27) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6145f486-5e7c-4f99-771a-08d7509c0238
x-ms-traffictypediagnostic: BN8PR11MB3828:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB382861BDE11886C57CC7819498900@BN8PR11MB3828.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 01901B3451
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(376002)(346002)(366004)(396003)(136003)(199004)(189003)(99286004)(31696002)(52116002)(25786009)(5660300002)(1411001)(6506007)(8936002)(81166006)(81156014)(8676002)(31686004)(76176011)(186003)(66066001)(102836004)(14454004)(71190400001)(71200400001)(54906003)(386003)(26005)(86362001)(316002)(508600001)(7736002)(6116002)(305945005)(3846002)(476003)(2906002)(44832011)(2616005)(6916009)(11346002)(486006)(446003)(256004)(36756003)(4326008)(66446008)(64756008)(66556008)(66476007)(66946007)(6436002)(558084003)(6486002)(6246003)(107886003)(6512007)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3828;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ELWzP/0dIzbyS5hR+PObsGG8oUrBTDjqfZp6r6REvaYKYJC+7V61b+pp3x+FgPQBaYBLa9g28eaMnJiGlzYjCEeYwRhXo/FH/rnk1F/Wg6WoxrZ7W3Gu2SzFtKuBmDM7FNhiCGtjEKS67toytdUhSp7gLPFMpK3pQCQHxIFMXjbi0KpMMA0FKEnr9eaQvstTZTviAsEQkMrswI9yz/2ptvaFfSa2+f/uEnfStaP3I6Y2AJLQ5gFc+iOdOVJROGZIjr5uE0yi9p4c4S2evMq/xDoEznF1fg7aBCjo3wqH7JXzxE8ETfiJqRZkPhluWMv4ibNGtkZqeFlYY3x6e4uozW/QtzLglh1f/n+6nlshkHodX0yLWtEH5qn5Ec4izuCLiaBOd0mU7MfnuOjH65auiUNuIknF/j04v2qfcsY9u6g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C33AF91FCA22994681226C8AABA9B1C0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6145f486-5e7c-4f99-771a-08d7509c0238
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2019 11:45:28.2497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xwgkXQjsWPhBJIO2BadZd0dy1/aniasWJb0dgh86NveIJpAJrG42/Dq6813t5h/7jFL+t+NQoSAFGDU6r0pHJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3828
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+PiArDQo+PiArCWlmIChhcV9uaWMtPmFxX3B0cCkNCj4gDQo+IFNob3VsZG4ndCB0aGUgdGVz
dCBmb3IgKGFxX25pYy0+YXFfcHRwKSBhbHNvIGVmZmVjdA0KPiBpbmZvLT5zb190aW1lc3RhbXBp
bmcgYW5kIGluZm8tPnR4X3R5cGVzID8NCg0KWW91IGFyZSByaWdodCwgaXQgc2hvdWxkLg0KSXQg
c2hvdWxkIGFsc28gZmFsbGJhY2sgdG8gc29mdHdhcmUgZXRodG9vbF9vcF9nZXRfdHNfaW5mbyBp
bg0KY2FzZSBIVyBpcyBub3QgUFRQIGNhcGFibGUuDQoNCldpbGwgZml4IHRoYXQuDQoNClJlZ2Fy
ZHMsDQogIElnb3INCg==
