Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3F428DC7B
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 11:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgJNJMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 05:12:47 -0400
Received: from mail-eopbgr20086.outbound.protection.outlook.com ([40.107.2.86]:2723
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726481AbgJNJMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 05:12:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGU7gN5eqIG0Tgah6ioFYjoc0WYSk9AIO9t7BYwbn+YaW4LGX5pf0b75SNcoHK7Vq4v6wazsaaxaOA28D+sen1mMqeYxzZWhnY5Bol7yvzw9NhT+uun6qDGIu5Bbj/TwgzpaY7DlPG4/l/oGmiao1a1twLB810v1aJlfY6/Ho4fhSSqsmYRMmE9spxNLjCKGRgc0sXFwCHIG1Clj6Psxlk9hDJH8aYVwHy2NdUHxh05jvdm40Kfz64UOcpEMiu8Ezh2pndgzPLtcK+9TNlBufEenc+I8bPr9bjMt8Rs2Nc0pfwtOq2PBGr6S8gcDU7Rnfehwpx8uhEHHKmUSTuAa0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VjVg39MT1iJzbo5jYERyD3Z/MWO6HCbNXarV5OOA3FA=;
 b=WPXQ0vR93l13Alncd1JQwBsvVSlW34Nv4/uM7F9TjCivZI6Z2rTUFhCLhz9eD0KO6imvXGB6MWqgux6S9oZ71LvqVyG2Qhq3oLbnOZrdEc4Fvmkvh+nRHhhHZwqyuETAe6Bimm6yfYniK7p9AKqx+e+1Rch4bMqnRxac5ktHgLfkdKOwwOC7sftUvjVXz+pbSUniFUHOvXHqyeCn/PrC/8KZUGAn8kT1F4V4okPAOg5uYgndp00pLlEch9ho2URRz+IWSzS9HtG3FhTQmryznjecyTrv3MSLvRcGX5PqkYtQRL4maL4CEm/0OSa0Loy41oaT2V9gg1276ZyJL20OCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=siemens.onmicrosoft.com; s=selector1-siemens-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VjVg39MT1iJzbo5jYERyD3Z/MWO6HCbNXarV5OOA3FA=;
 b=O5Z2+PHqV30dAzZ7RFGJMHTX4FCHTAsiEAhBMgs9tSwRmrNNm57YaNorAZLjlFY6EgXbTZJ92Q1Tgm5SQoy3MIbvO3JdJmnC6nQQlXTORzunzHe3BAroc4uerz/5F4OX9VBPQN85XUMxOC71PaoYzY/F9dhvRXltUxrOxaTjVyE=
Received: from AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:161::30)
 by AM0PR10MB2420.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:d6::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 14 Oct
 2020 09:12:42 +0000
Received: from AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9852:e40f:56dd:13bc]) by AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9852:e40f:56dd:13bc%7]) with mapi id 15.20.3455.032; Wed, 14 Oct 2020
 09:12:42 +0000
From:   "Meisinger, Andreas" <andreas.meisinger@siemens.com>
To:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "Geva, Erez" <erez.geva.ext@siemens.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "0x7f454c46@gmail.com" <0x7f454c46@gmail.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "vdronov@redhat.com" <vdronov@redhat.com>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>
CC:     "jesus.sanchez-palencia@intel.com" <jesus.sanchez-palencia@intel.com>,
        "vedang.patel@intel.com" <vedang.patel@intel.com>,
        "Sudler, Simon" <simon.sudler@siemens.com>,
        "Bucher, Andreas" <andreas.bucher@siemens.com>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "Zirkler, Andreas" <andreas.zirkler@siemens.com>,
        "Sakic, Ermin" <ermin.sakic@siemens.com>,
        "anninh.nguyen@siemens.com" <anninh.nguyen@siemens.com>,
        "Saenger, Michael" <michael.saenger@siemens.com>,
        "Maehringer, Bernd" <bernd.maehringer@siemens.com>,
        "gisela.greinert@siemens.com" <gisela.greinert@siemens.com>,
        "Geva, Erez" <erez.geva.ext@siemens.com>,
        "ErezGeva2@gmail.com" <ErezGeva2@gmail.com>,
        "guenter.steindl@siemens.com" <guenter.steindl@siemens.com>
Subject: Re: [PATCH 0/7] TC-ETF support PTP clocks series
Thread-Topic: [PATCH 0/7] TC-ETF support PTP clocks series
Thread-Index: AdaiB8a+x+RhfhtwSZ+NKfvRdyiJkw==
Date:   Wed, 14 Oct 2020 09:12:41 +0000
Message-ID: <AM0PR10MB3073F9694ECAD4F612A86FA7FA050@AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-document-confidentiality: NotClassified
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=siemens.com;
x-originating-ip: [165.225.26.247]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a903b5ad-874a-4021-2874-08d870214e28
x-ms-traffictypediagnostic: AM0PR10MB2420:
x-ld-processed: 38ae3bcd-9579-4fd4-adda-b42e1495d55a,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR10MB2420C5AD13B2EA0413C84A39FA050@AM0PR10MB2420.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tCSZbqQvc84P0eBp/p5RigpY8NZ4AxMw3t2yI5vtPtsEVRbSoe0I5Nv973CrPOEJGNYXjJId3KgrqXIbicKlKe9xPsPrG+f7rnrgpfnxvOJFL4BMcZWk2mFuNmbA8OmXdBA9EZVMeBXoyvHLh5V4n2BE33PDuhAYxlT4faXBBllIzHD7anM0NMRvuqUKKNjI1BTsWr7YcQx3jCVrndzeBEuh+IVjfDC8PSHiAcXz5CZCxSOCCBHpYrghhp/0LcjkYlQh+HmGXTixa2cWyLiHdHFvE4Lo4Wov5zpjflPZ8W3E6bZ8hhCwl56+ImZjR7Xt8vYkORjIlka1sk0O/yjkSlIT17l/o3uooaxGSKbooAYwKaPxyUWUE8IfvrZo/MAM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(7696005)(186003)(478600001)(54906003)(316002)(83380400001)(107886003)(55016002)(7416002)(5660300002)(33656002)(83730400002)(55236004)(6506007)(26005)(52536014)(71200400001)(66476007)(76116006)(66446008)(64756008)(66556008)(2906002)(66946007)(86362001)(8936002)(8676002)(110136005)(66574015)(9686003)(4326008)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 02aDP0nmkauQhlA3cMgN2JGK5RzZ3RpiTyosnrXHFnJw81FUHT/CYDsqbr+zNYH6bKlVL80giGkajf7TVLBc7TjdjfgsV+NtlDyZn5ya3fzIpLOZA58BWFoRRvEu7M+LWLCEmNHZS7ZizXHk5nK3O6ROjDj/sTnUQlSxMXLdur4z85ujdrZE1hQRoEchMJEA1iALuiiiJkAQTvzH+4/U22d494xc1mnx8nRdVAGpiMuacFpxbakuqn2xlqn5zKHT/P3KTOdFb9oTKRU0vdVcC/Qa8b67pmvzB5Ecp05LUrI+v7Zd4SKPlTx4xE4Wr7wHjNAfLuKhAMaRSb+GHxRtzSFyOtqXA8kdpoY9lEV3Tg902+fy02rVTFHU3y0E9y3asds6b6dRQcYJbs33M40KKbr06rkjLF3GzDQYOIsEthaQd1fxaZvamhcZRQrcpLWFIdWtyYlQ6mUKkL1GN6q1JLylZ4ZzOo7jngurDIRS5o77xt6jGH5bHwNiywILQiCOQOQbbYjlCWiOtyq/XET++LNXP622+jLylMWQXHte+TcyKvSP9FDqivnM+WX6nWrOpnLxh1GTpJe4EiUb4XhzSAaM5Mh8dNDX4BE9EPH+RVUSAfwOzWQzqYwZgeI7Gy/oRN2Daf8KfsKROLsCurDr/A==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB3073.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a903b5ad-874a-4021-2874-08d870214e28
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2020 09:12:41.9472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lG/Vlp4h+hsNSuSNuzP1IXcpeuxH9Ob4R4HGY1zMbF/SXgQ245f+QcarMc4l9cbCYHksKwJ1nJpPvrNw/W7Q4qCrJ9xMicR46WyKUKYMCvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2420
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gVGhvbWFzLA0KU29ycnkgYWJvdXQgdGhlIHdyb25nIGZvcm1hdC9zdHlsZSBvZiBteSBs
YXN0IG1haWwsIGhvcGUgSSBkaWQgZ2V0IGl0IHJpZ2h0IHRoaXMgdGltZS4NCg0KTGV0IG1lIGZp
cnN0IHBvaW50IGF0IGFuIGltcG9ydGFudCB0aGluZyBiZWNhdXNlIHdlIGRpZCBoYXZlIGRpc2N1
c3Npb25zIGhlcmUgYWJvdXQgaXQgdG9vLiBBcyBvZiB0aGUgbWFucGFnZXMgTGludXggQ0xPQ0tf
VEFJIHNlZW1zIHRvIGJlIGRlZmluZWQgYXMgYW4gbm9uc2V0dGFibGUgY2xvY2sgd2hpY2ggZG9l
cyBoYXZlIHRoZSBzYW1lIGJlaGF2aW91ciBhcyBvZiBpbnRlcm5hdGlvbmFsIGF0b21pYyB0aW1l
IFRBSS4gWWV0IGlmIGl0J3Mgbm9uc2V0dGFibGUgaXQgY2FuJ3QgYmUgbGlua2VkIG9yIHN5bmNo
cm9uaXplZCB0byB0aGUgdmFsdWUgb2YgSW50ZXJuYXRpb25hbCBBdG9taWMgVGltZT8NCk9uIHRo
ZSBvdGhlciBoYW5kIHRoZXJlIHNlZW1zIHRvIGJlIGNvZGUgaW4gcGxhY2UgdG8gY2hhbmdlIHRo
ZSBDTE9DS19UQUkgb2Zmc2V0IHRodXMgbWFraW5nIGl0IGJhc2ljYWxseSBzb3J0IG9mICJzZXRh
YmxlIj8NCg0KPiBUaGUgdXNlciBzcGFjZSBkYWVtb24gd2hpY2ggZG9lcyB0aGUgY29ycmVsYXRp
b24gYmV0d2VlbiB0aGVzZSBQVFAgZG9tYWlucyBhbmQgVEFJIGlzIHJlcXVpcmVkIGluIGFueSBj
YXNlLCBzbyB0aGUgbWFnaWMNCj4gY2xvY2sgVEFJX1BSSVZBVEUgaXMgbm90IGhhdmluZyBhbnkg
YWR2YW50YWdlLg0KDQpJIHRoaW5rIGEgdXNlcnNwYWNlIGRhZW1vbiBoYW5kbGluZyB0aGUgdHJh
bnNsYXRpb24gaW5mb3JtYXRpb24gYmV0d2VlbiBkaWZmZXJlbnQgY2xvY2tzIHdvdWxkIGJlIGZp
bmUuIEkgdGhpbmsgaXQncyBub3QgcmVhbGx5IHRoYXQgcmVsZXZhbnQgd2hvIGV4YWN0bHkgZG9l
cyBhcHBseSB0aGUgdHJhbnNsYXRpb24uIEtlcm5lbCBsZXZlbCBtaWdodCBiZSBhIGxpdHRsZSBi
aXQgbW9yZSBwcmVjaXNlIGJ1dCBJIGd1ZXNzIGl0J2QgZGVwZW5kIG9uIG90aGVyIGZhY3RvcnMg
dG9vLg0KWWV0IGFsbCB0cmFuc2xhdGlvbiBiYXNlZCBhcHByb2FjaGVzIGhhdmUgaW4gY29tbW9u
LCBzZXR0aW5nIGEgY2xvY2ssIHJlbmRlcnMgdHJhbnNsYXRpb25zIGRvbmUgaW4gcGFzdCBpbnZh
bGlkLiBJdCB3b3VsZCBiZSByZXF1aXJlZCB0byBmaXggb2xkIHRyYW5zbGF0ZWQgdmFsdWVzIGFs
b25nIHdpdGggc2V0dGluZyB0aGUgY2xvY2suIEkgYXNzdW1lIHdlIGNvdWxkbid0IGRpc3Rpbmd1
aXNoIGJldHdlZW4gInRyYW5zbGF0ZWQiIHZhbHVlcyBhbmQgZ2VudWluZSB2YWx1ZXMgYWZ0ZXIg
dHJhbnNsYXRpb24sIHNvIGZpeGluZyB0aGVtIG1pZ2h0IG5vdCBiZSBwb3NzaWJsZSBhdCBhbGwu
DQpJbiBvdXIgdXNlY2FzZSB3ZSBkbyBoYXZlIGEgY2xvY2sgZm9yIG5ldHdvcmsgb3BlcmF0aW9u
IHdoaWNoIGNhbid0IGJlIHNldC4gV2UgY2FuIGd1YXJhbnRlZSB0aGlzIGJlY2F1c2Ugd2UgYXJl
IGFibGUgdG8gZGVmaW5lIHRoZSBuZXR3b3JrIG5vdCBiZWluZyBvcGVyYXRpb25hbCB3aGVuIHRo
ZSBkZWZpbmVkIHRpbWUgaXMgbm90IGF2YWlsYWJsZSDwn5iJLg0KSGF2aW5nIHRoaXMgZGVmaW5l
ZCB0aGUgcmVtYWluaW5nIG9wdGlvbiB3b3VsZCAgYmUgdGhlIHRhcmdldCBjbG9jayB0byBiZSBz
ZXQuIEFzIG9mIHlvdXIgc3VnZ2VzdGlvbiB0aGF0IHdvdWxkIGJlIENMT0NLX1RBSS4gU28gYXQg
dGhpcyBwb2ludCAic2V0YWJsZSIgb3IgIm5vbnNldHRhYmxlIiB3b3VsZCBiZWNvbWUgaW1wb3J0
YW50LiBIZXJlICJzZXRhYmxlIiB3b3VsZCBpbnRyb2R1Y2UgYSBkZXBlbmRlbmN5IGJldHdlZW4g
dGhlIGNsb2Nrcy4gQmVpbmcgaW5kZXBlbmRlbnQgZnJvbSBjbG9ja3Mgb3V0c2lkZSBvZiBvdXIg
Y29udHJvbCB3YXMgZXhhY3RseSB0aGUgcmVhc29uIHRvIGludHJvZHVjZSB0aGUgc2VwYXJhdGUg
bmV0d29yayBjbG9jay4gVG8gbWUgdGhpcyBtZWFucyBpZiBDTE9DS19UQUkgY291bGQgYmUgY2hh
bmdlZCBieSBhbnl0aGluZyBpdCBjb3VsZG4ndCBiZSB0aGUgYmFzZSBjbG9jayBmb3Igb3VyIHVz
ZWNhc2UgaWYgaXQgY2FuJ3QgaXQgbWlnaHQgYmUgYSBzb2x1dGlvbi4NCg0KPiBEZXBlbmRpbmcg
b24gdGhlIGZyZXF1ZW5jeSBkcmlmdCBiZXR3ZWVuIENMT0NLX1RBSSBhbmQgY2xvY2sgUFRQLyRO
IHRoZSB0aW1lciBleHBpcnkgbWlnaHQgYmUgc2xpZ2h0bHkgaW5hY2N1cmF0ZSwgYnV0DQo+IHN1
cmVseSBub3QgbW9yZSBpbmFjY3VyYXRlIHRoYW4gaWYgdGhhdCBjb252ZXJzaW9uIGlzIGRvbmUg
cHVyZWx5IGluIHVzZXIgc3BhY2UuDQo+DQo+IFRoZSBzZWxmIHJlYXJtaW5nIHBvc2l4IHRpbWVy
cyB3b3VsZCB3b3JrIHRvbywgYnV0IHRoZSBzZWxmIHJlYXJtaW5nIGlzIGJhc2VkIG9uIENMT0NL
X1RBSSwgc28gcm91bmRpbmcgZXJyb3JzIGFuZCBkcmlmdA0KPiB3b3VsZCBiZSBhY2N1bXVsYXRp
dmUuIFNvIEknZCByYXRoZXIgc3RheSBhd2F5IGZyb20gdGhlbS4NCg0KQXMgb2YgdGhlIHRpbWUg
cmFuZ2VzIHR5cGljYWxseSB1c2VkIGluIHRzbiBuZXR3b3JrcyB0aGUgZHJpZnQgZXJyb3IgZm9y
IHNpbmdsZSBzaG90IHRpbWVycyBtb3N0IGxpa2VseSBpc24ndCBhIGJpZyBkZWFsLiBCdXQgYXMg
eW91IHN1Z2dlc3QgSSdkIHN0YXkgYXdheSBmcm9tIGxvbmcgcnVubmluZyB0aW1lcnMgYXMgd2Vs
bCByZWFybWluZyBvbmVzIHRvbywgSSBndWVzcyB0aGV5J2QgYmUgbW9zdGx5IHVudXNhYmxlLg0K
DQo+IElmIHN1Y2ggYSBjb29yZGluYXRpb24gZXhpc3RzLCB0aGVuIHRoZSB3aG9sZSBwcm9ibGVt
IGluIHRoZSBUU04gc3RhY2sgaXMgZ29uZS4gVGhlIGNvcmUgY2FuIGFsd2F5cyBvcGVyYXRlIG9u
IFRBSSBhbmQgdGhlDQo+IG5ldHdvcmsgZGV2aWNlIHdoaWNoIHJ1bnMgaW4gYSBkaWZmZXJlbnQg
dGltZSB1bml2ZXJzZSB3b3VsZCB1c2UgdGhlIHNhbWUgY29udmVyc2lvbiBkYXRhIGUuZy4gdG8g
cXVldWUgYSBwYWNrZXQgZm9yIEhXDQo+IGJhc2VkIHRpbWUgdHJpZ2dlcmVkIHRyYW5zbWlzc2lv
bi4gQWdhaW4gc3ViamVjdCB0byBzbGlnaHQgaW5hY2N1cmFjeSwgYnV0IGl0IGRvZXMgbm90IGNv
bWUgd2l0aCBhbGwgdGhlIHByb2JsZW1zIG9mIGR5bmFtaWMNCj4gY2xvY2tzLCBsb2NraW5nIGlz
c3VlcyBldGMuIEFzIHRoZSBmcmVxdWVuY3kgZHJpZnQgYmV0d2VlbiBQVFAgZG9tYWlucyBpcyBu
ZWl0aGVyIGZhc3QgY2hhbmdpbmcgbm9yIHJhbmRvbWx5IGp1bXBpbmcgYXJvdW5kDQo+IHRoZSBp
bmFjY3VyYWN5IG1pZ2h0IGV2ZW4gYmUgYSBtb3N0bHkgYWNhZGVtaWMgcHJvYmxlbS4NCg0KVGhl
c2UgbXVsdGlwbGUgY29udmVyc2lvbiBlcnJvcnMgd291bGQgaGFwcGVuIGV2ZW4gZm9yIGFwcGxp
Y2F0aW9ucyBhd2FyZSBvZiBpdCdzIHRhcmdldCB0aW1lc2NhbGUuDQpUaGlzIG1pZ2h0IHVzdWFs
bHkgYmUgYW4gYWNhZGVtaWMgaXNzdWUgYnV0IGZvciBzb21lIG9mIG91ciB1c2VjYXNlcyBjb252
ZXJzaW9uIGVycm9ycyBhcmVu4oCZdCBhbGxvd2VkIGF0IGFsbC4NCkluIGFueSBjYXNlIGFkZGlu
ZyBjb252ZXJzaW9uIGVycm9ycyBzb3VuZHMgc3RyYW5nZSBhcyBvdXIgZ29hbCBpcyB0byBpbXBy
b3ZlIHByZWNpc2lvbi4NCg0KSSBkb24ndCBzZWUgYSB3YXkgdG8gYXZvaWQgY29udmVyc2lvbiBl
cnJvcnMgZXhjZXB0IG9mIHNvbWVob3cgcGFzc2luZyB0aGUgb3JpZ2luYWwgdGltZXN0YW1wIGRv
d24gdG8gbmV0d29yayBjYXJkIGxldmVsLg0KUmlnaHQgbm93IHRoZXJlJ3Mgb25seSBvbmUgdGlt
ZXN0YW1wIGluIENMT0NLX1RBSSBmb3JtYXQgd2hpY2ggaXMgdXNlZCBieSBFVEYgYXMgd2VsbCBh
cyBieSBuZXR3b3JrIGNhcmQgdGh1cyBjYXVzaW5nIHRyb3VibGUgaWYgdGltZSBpcyBub3Qgc2Ft
ZSB0aGVyZS4NCklmIHdlJ2QgYWRkIGFuIChvcHRpb25hbCkgc2Vjb25kIHRpbWVzdGFtcCB0byBT
S0Igd2hpY2ggd291bGQgaGF2ZSB0byBiZSBzZXQgdG8gbmV0d29yayBjYXJkIHRpbWUgd2UgY291
bGQgYXZvaWQgdGhlIGNvbnZlcnNpb24gZXJyb3IuIEFzIHdlIGRvIGtub3cgd2hpY2ggbmV0d29y
ayBjYXJkIHdpbGwgYmUgdXNlZCBmb3Igc2VuZGluZyB0aGUgU0tCIHdlIHdvdWxkbid0IG5lZWQg
YSBjbG9jayBpZGVudGlmaWVyIGZvciB0aGUgc2Vjb25kIHRpbWVzdGFtcC4NCkZvciBzaXR1YXRp
b25zIHdoZXJlIHRoZSBhcHBsaWNhdGlvbiBpcyBub3QgYXdhcmUgb2YgdGhlIG5ldHdvcmsgY2Fy
ZHMgdGltZXNwYWNlIGl0IHdvdWxkbid0IHByb3ZpZGUgdGhlIHNlY29uZCB0aW1lc3RhbXAuIElu
IHRoZXNlIHNpdHVhdGlvbnMgaXQnZCBiZWhhdmUgaWRlbnRpY2FsIHRvIHlvdXIgc3VnZ2VzdGlv
bi4gSGVyZSB0aGUgQ0xPQ0tfVEFJIHRpbWVzdGFtcCB3b3VsZCBiZSB0cmFuc2xhdGVkIHRvIG5l
dHdvcmsgY2FyZCB0aW1lIGJhc2VkIG9uIHRoZSBpbmZvcm1hdGlvbiBvZiB0aGUgdXNlcnNwYWNl
IGRhZW1vbi4NCg0KV2hhdCdzIHlvdXIgb3BpbmlvbiBhYm91dCBhIHNlY29uZCB0aW1lc3RhbXA/
DQoNCkJlc3QgcmVnYXJkcw0KQW5kcmVhcyBNZWlzaW5nZXINCg0KU2llbWVucyBBRw0KRGlnaXRh
bCBJbmR1c3RyaWVzDQpQcm9jZXNzIEF1dG9tYXRpb24NCkRJIFBBIERDUA0KR2xlaXdpdHplciBT
dHIuIDU1NQ0KOTA0NzUgTsO8cm5iZXJnLCBEZXV0c2NobGFuZA0KVGVsLjogKzQ5IDkxMSA5NTgy
MjcyMA0KbWFpbHRvOmFuZHJlYXMubWVpc2luZ2VyQHNpZW1lbnMuY29tDQoNCg==
