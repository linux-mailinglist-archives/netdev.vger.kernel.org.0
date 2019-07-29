Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F5079B16
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388613AbfG2Van (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:30:43 -0400
Received: from mail-eopbgr40077.outbound.protection.outlook.com ([40.107.4.77]:44869
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388580AbfG2Van (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 17:30:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+eqRZzRygpMPJghiN9MhdDaGxi9T3jv8SwHHohl3GhG2m4wgACR/nJAwfZ3lXEvAcSDWSXF/te5poCl8RHhKXArxO9qQeNkIB8GknWf+615bcKC4MR+EHcgqN2T80EH4gh0uBgq4hg7k4Yll902NI6slzhmdvhPmfsxP3NYRiseFMThbb63aOVBb4AXrB2Ddn87BIEwTgINQUj/sXoMnQ23ViySrDCys1DvVVfSO+xw5Cp6JrfJxt7y+91OgbBGhx/bpdKt/GSO6AZGEOv0/Yk9AEWyZEGuwtnLdb/bIeNUhPVpNMp/pX1336beaQNxn0v8ogf6PX29xNQqqaHARg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJwa5IUA2TVflzHEwDmDUXZa5HC9E9snpTj0PKYtFJI=;
 b=MO9YvaW3jlfUxpc5Z0m+jTqLdIMdqOvwc9sYiNuxgM5ORIDhY88gb8aGZBndcFmmqURxDWvjC8F4jtbBKEgGrRA7VBKaz9mTCIMbjCz2hz0h//g61pcH4QYSZr7mpUqKUccY3W03ecAl1IvMTrfPaElWflv9HcB2bB6TGCDN6336jwHOC8+uhdr35twpdOdUk/5N4HY6O7C7k351x/OYfhSn2dWtaTW3Rz+6w+HrNVt4pmo1TBNfga2JcKA7HRN8amaThKkzCAYbwsLvB5TVj/mYdgKJqNeMoFCiiOXm4XLG5elvKOwi/4OQlZbDcodeP3uz/nEg82pdrxUWhQg8fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJwa5IUA2TVflzHEwDmDUXZa5HC9E9snpTj0PKYtFJI=;
 b=pWGoDCpggX2I7ObGTBAvU6saZmCKnBmJKUc51m23tHvvIkYVOCz3qDsqsyMfwXcdrIdae21CqncAJh8oNQaOXo3TLFADfCak16VlFteIPMwy6gqg6y5uMPyZ2yEvVqBA2DElR9frBbrhYHqVXZzEE6FNxvw+5pid99/45p+04d0=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2598.eurprd05.prod.outlook.com (10.168.77.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 29 Jul 2019 21:30:39 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 21:30:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net/mlx5e: Fix unnecessary flow_block_cb_is_busy call
Thread-Topic: [PATCH net] net/mlx5e: Fix unnecessary flow_block_cb_is_busy
 call
Thread-Index: AQHVRIv9dw+qrtg/K0GKuF3q83fzRKbiIKAA
Date:   Mon, 29 Jul 2019 21:30:39 +0000
Message-ID: <d44990abe24b82ebc664704383a5b7f1fed20287.camel@mellanox.com>
References: <1564239595-23786-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1564239595-23786-1-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a16045b9-a672-490e-9825-08d7146c0076
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2598;
x-ms-traffictypediagnostic: DB6PR0501MB2598:
x-microsoft-antispam-prvs: <DB6PR0501MB259808F6DBCFDC59F077CB8ABEDD0@DB6PR0501MB2598.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(199004)(189003)(316002)(6116002)(3846002)(76176011)(446003)(11346002)(58126008)(2616005)(305945005)(229853002)(110136005)(8676002)(86362001)(7736002)(5660300002)(71190400001)(71200400001)(6512007)(486006)(476003)(6436002)(6486002)(4744005)(25786009)(118296001)(36756003)(91956017)(53936002)(68736007)(2906002)(66946007)(256004)(102836004)(6506007)(66476007)(64756008)(66446008)(66556008)(66066001)(76116006)(478600001)(81156014)(81166006)(186003)(2501003)(26005)(14454004)(99286004)(6246003)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2598;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Mb6eOPZHO+D+Syua7MP3X1PG8asjVpn4385bRtR6mTk/5NVxFzxwj4gjX1/4IbPBFiwhCZaTHUemjkvhm9ek+oPA1XNcXA0ACdzRFuZRwSXTabZfllkbbFFgKhhXlyrQP+Iet3cr4J6dUgFH3yu3j7i5YHjXu3bGsGSeoI1SMHHa9RUczUmZiNs29LzemcOPu9QN5DVBwPft94QXlDdDIKvHyOjjuCnhaCkQRUF3lJTXEuq0osx7NqYyF7jkpAPCLYEcTfX6cvZ7nOJuOsBFCRymGPCQWK2xFIKyPDJZpZsnPttqiQ5m11i33EDRM4DipUaFFbkoYGm+TeIdZM0PxaB7Se+olrgBGvcolOgEvkC9+FxPIdqffWwpxn27GaQUP5BQdujnc4NDeXV07k9Y5DBECAyv0nEMKWEmNl7My4k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD794834B3BD4C40905381A352E22A2D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a16045b9-a672-490e-9825-08d7146c0076
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 21:30:39.1151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2598
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDE5LTA3LTI3IGF0IDIyOjU5ICswODAwLCB3ZW54dUB1Y2xvdWQuY24gd3JvdGU6
DQo+IEZyb206IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+IA0KPiBXaGVuIGNhbGwgZmxvd19i
bG9ja19jYl9pc19idXN5LiBUaGUgaW5kcl9wcml2IGlzIGd1YXJhbnRlZWQgdG8NCj4gTlVMTCBw
dHIuIFNvIHRoZXJlIGlzIG5vIG5lZWQgdG8gY2FsbCBmbG93X2JvY2tfY2JfaXNfYnVzeS4NCj4g
DQo+IEZpeGVzOiAwZDRmZDAyZTcxOTkgKCJuZXQ6IGZsb3dfb2ZmbG9hZDogYWRkIGZsb3dfYmxv
Y2tfY2JfaXNfYnVzeSgpDQo+IGFuZCB1c2UgaXQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiB3ZW54dSA8
d2VueHVAdWNsb3VkLmNuPg0KDQpBcHBsaWVkIHRvIG5ldC1uZXh0LW1seDUgYnJhbmNoLg0KDQpU
aGFua3MsDQpTYWVlZC4NCg==
