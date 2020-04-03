Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D90A19CEC8
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 05:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390082AbgDCDAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 23:00:20 -0400
Received: from mail-eopbgr40050.outbound.protection.outlook.com ([40.107.4.50]:54611
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731842AbgDCDAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 23:00:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CsBOZdjo0Lmw69Ds0gmePduQoxcSWrQXKbF0ApaStzbwswoMNjer82sBXOITALraBXROS8KQt0+nkkhqp0jBDk3khviypylhMXSdUDvIGbMClA6Pv0LD0YqamDStqfyMf9ylvD64Fy6h/V3ahzHFVlRqAl8sH+FcoazM56zqxepp0IjFZFnfcgi99l48KnIg2TLtOeVZlL/QfQ4cbZbQyp46kIs5cuw/dCg9ff9qNMWKfPMeCkb8MsRHu3mVvwEKtd9dqpIDzofTPZpWsez+jkVypRDzPpZ7zb777C9Rrj02R7BFA0sXwC4YjsRypa1CRnjEjSX46nwpYk29mWml8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yomnTlG0Tn/zjq906GuXHd7WcwVS7MQ3KCJMj8pC2M=;
 b=X9m7RrIlW5zZlkQs0rTDcPR1hSqMaAZAKTGZK811/KSP7ogZYKsb9pLL4cNWsa6wSXnOSpmNBr7zNZ9lmq8UqPLwrbI+DkCBtewI9GV38P/eD8mMf0f1uKojWnRySikRnLfQN2zHnw76hjDmywZd3QeB4nov5MqvUD9YkwQQ2U/HL+LHmTOJ347cXuSnbrziwoGAE50rfYAWhiEVl8cr8LjRLKL2JCD/f6G3vsvutJCr+q35kVPvd5v6377b2rN63tnvzwl6Scc1oh6PoGlm2mDxwhveCTtml3JS+ntzLLquNAbMPKYchkiyoGLeywi6c4h9ycd0pKyzCvcAM7DDAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yomnTlG0Tn/zjq906GuXHd7WcwVS7MQ3KCJMj8pC2M=;
 b=Y3Pk5Hz2gI4fwuOzignwJWACcQY6ae7ihgXEWIghKrhjHNxjuRMjdFoLE+7zF3n/ILVLqipNVXScEPvT/ntP2dZCF7yB3Dh/LZTzAFe4lAgdKWjRLdRKA47VTluVRJfY/Z9/+xJzCuwj6VkY1RVrJSTAFU0+tZUhW6FMaRmZkYQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5151.eurprd05.prod.outlook.com (2603:10a6:803:b2::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.17; Fri, 3 Apr
 2020 02:59:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.018; Fri, 3 Apr 2020
 02:59:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        Paul Blakey <paulb@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        Oz Shlomo <ozsh@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: avoid check the hw_stats of
 flow_action for FT flow
Thread-Topic: [PATCH net-next] net/mlx5e: avoid check the hw_stats of
 flow_action for FT flow
Thread-Index: AQHWBZctpmGmicoH9kK9gECt3tT45KhmvLcA
Date:   Fri, 3 Apr 2020 02:59:57 +0000
Message-ID: <fd36f18360b2800b37fe6b7466b7361afd43718b.camel@mellanox.com>
References: <1585464960-6204-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1585464960-6204-1-git-send-email-wenxu@ucloud.cn>
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
x-ms-office365-filtering-correlation-id: bbbaecea-577e-4640-92eb-08d7d77b178c
x-ms-traffictypediagnostic: VI1PR05MB5151:|VI1PR05MB5151:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5151AD57CA5AE1E26C21FD10BEC70@VI1PR05MB5151.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0362BF9FDB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(5660300002)(2616005)(316002)(110136005)(4326008)(71200400001)(6512007)(8676002)(81156014)(66446008)(76116006)(64756008)(66476007)(66556008)(478600001)(66946007)(81166006)(6506007)(6636002)(8936002)(6486002)(91956017)(36756003)(2906002)(86362001)(186003)(26005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CCHHzl/CE1oWH28egoN4Ec9Pe7Nw9bKOhIkYs9mZizxIYkx9l0RlUgCNse60vmdOVxZxeFq4f72XDYplvvot9pHoaKaem2Gee10by3kO51dGGYtUyJ/VO7nOPTxMHLXaBIxg/72CbI4oyLuVPAuyOWK7F9TTVJ/DUqtrcydF5XhD/rj03pYF3HNId09IjH/XG1B/XIL7ZuAxIwlR8twIl6f/k4DrZ6vT/8ptEWrWtYZDXbVEg+UxGelvfcJLhfYQXo8X0agn+jKQ1GQ9wXx16b9XSIr6a4ijgQ6wSOp20deyZKGlAO2FjB4lW89h7+0cfdLC0Oqs6DyjvS9WzOYdOlJNFjofrKwTjb6/RHcyINkMIwQNAeLgSjGXWbgK+xA4csojIzGVXok/FZnagXP/pX1i0QLQDfb24fYS8lF+2T/amK9Vw+sgZr6Al276cJxn
x-ms-exchange-antispam-messagedata: 7NsG0oCxIJvVnWDmRyZtny3GAjZKs0+FwVThJGhcafx0WF6QJxr9B8yaZ5+KY1NJybVSKz3ebB2VKP4aksos5BYlfhmQo7vHZTMFEMtEdO4RVM8IfKqvJ5vWEpsoi+oVNGHIWFyGMAHsIsG5tz+NMA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7E2DCA620AE0141B76DF9EFF22C7B5D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbbaecea-577e-4640-92eb-08d7d77b178c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2020 02:59:57.0703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WHnaJ4KOEn1xObv5heePqV/SWHEK/YDjbW2JbZpD3WOtB5OkUTcOLYR917vlW8VAd4xJ6ojCxWnPhVKyjkjygQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5151
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTAzLTI5IGF0IDE0OjU2ICswODAwLCB3ZW54dUB1Y2xvdWQuY24gd3JvdGU6
DQo+IEZyb206IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+IA0KPiBUaGUgaHdfc3RhdHMgaW4g
Zmxvd19hY3Rpb24gY2FuJ3QgYmUgc3VwcG9ydGVkIGluIG5mdGFibGUNCj4gZmxvd3RhYmxlcy4g
VGhpcyBjaGVjayB3aWxsIGxlYWQgdGhlIG5mdCBmbG93dGFibGUgb2ZmbG9hZA0KPiBmYWlsZWQu
IFNvIGRvbid0IGNoZWNrIHRoZSBod19zdGF0cyBvZiBmbG93X2FjdGlvbiBmb3IgRlQNCj4gZmxv
dy4NCj4gDQoNClRoaXMgbG9va3MgbGlrZSBhIHdvcmsgYXJvdW5kIG5vdCBhIHNvbHV0aW9uIC4u
IGlmIHRoZSB1c2VyIHJlcXVlc3RlZCBhDQpod19zdGF0cyBhY3Rpb24gdGhhdCB0aGUgaHcgY2Fu
J3Qgc3VwcG9ydCwgbm8gbWF0dGVyIHdoYXQgdGhlIHJlcXVlc3QNCmlzLCB3ZSBzaG91bGQgZmFp
bCBpdCBldmVuIGlmIGl0IHdhcyBmb3IgZnQgb2ZmbG9hZHMuDQoNCmlmIGl0IGlzIG5vdCBzdXBw
b3J0IGJ5IG5mdGFibGUsIHRoZW4gdGhlIGNhbGxlciBzaG91bGRuJ3QgYXNrIGZvcg0KaHdfc3Rh
dHMgYWN0aW9uIGluIGZpcnN0IHBsYWNlLg0KDQo+IFNpZ25lZC1vZmYtYnk6IHdlbnh1IDx3ZW54
dUB1Y2xvdWQuY24+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuX3RjLmMgfCAzICsrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX3RjLmMNCj4gaW5kZXggOTAxYjVmYS4uNDY2NjAxNSAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMN
Cj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMN
Cj4gQEAgLTM3MDMsNyArMzcwMyw4IEBAIHN0YXRpYyBpbnQgcGFyc2VfdGNfZmRiX2FjdGlvbnMo
c3RydWN0DQo+IG1seDVlX3ByaXYgKnByaXYsDQo+ICAJaWYgKCFmbG93X2FjdGlvbl9oYXNfZW50
cmllcyhmbG93X2FjdGlvbikpDQo+ICAJCXJldHVybiAtRUlOVkFMOw0KPiAgDQo+IC0JaWYgKCFm
bG93X2FjdGlvbl9od19zdGF0c19jaGVjayhmbG93X2FjdGlvbiwgZXh0YWNrLA0KPiArCWlmICgh
ZnRfZmxvdyAmJg0KPiArCSAgICAhZmxvd19hY3Rpb25faHdfc3RhdHNfY2hlY2soZmxvd19hY3Rp
b24sIGV4dGFjaywNCj4gIAkJCQkJRkxPV19BQ1RJT05fSFdfU1RBVFNfREVMQVlFRF9CSQ0KPiBU
KSkNCj4gIAkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiAgDQo=
