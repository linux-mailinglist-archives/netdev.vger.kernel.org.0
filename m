Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BBA1AB630
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 05:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390805AbgDPDZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 23:25:29 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:61698
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388679AbgDPDZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 23:25:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRzw+oUDTNDaE0P1XW5aYnC3EcGjEAOuP8dOZuCjRyoSnZmXYQozJakLBaQNB9ba7sxb/VJHjKymV28C7cOhWV0Nr3gPIg/W16bktZuwsiJn9HuGZGWz+TT5q/k0NpAUTCjwVTxnL9EhNs8dYiOPY/bz5Z9FgYfswnSsIsN2H4kPUjO9i2iKvJxXFeGpMCvyfJU9R66rlgsJJQhGApgY137X0MBUtOEz9QYQTyHWZ+fbh1QIowG18Zp+0SFPljLDtNXngecr99adyW4PkBvUWpI8+B9uWv4URHDMyTFeNJ6zq/6Ukv1T40eMdmEa0VBEUgJfvo8WIvr8ZBoQa95nkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knyUoZE4wv+YXjq5MDP3ECk/bnce9WQ+irsxak+ITsU=;
 b=FcsiAYiiC/EIuWi2PYuZcXk4rZ6jhHbX6lb/RmqzCW4CmWoETuW5Y+UI6G6qFr/72vZF2/dIOk9mcETX/NDW6nHyBAqbNwHaDZQIsTAhrC5n728/2j5g912VW0ERaLGID8U9iWu9A0Z/mykEhgCt8W6N7lzlEGY0dqoEuJdj8Pgb3zidJkrbHRMWg8NXa9ESy+yMEhm87gerd5T3OKnljgmOKfhr1exhucgHXSrhTgaRWbbTk6mkPExZ3KTkwW+H9nQZwMjzhgWhOHtqI3RcExb7YX/hHMQV8nSBoRwVvxXBBDi6b7UZykD5/XKuzYxe71JjwrmuK49Kv7dL5iFHBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knyUoZE4wv+YXjq5MDP3ECk/bnce9WQ+irsxak+ITsU=;
 b=MRQdieMEDAHRWbSxetxaQJv5nSWmD2urn3wJ+bydqWSCr7P2ygubs90dgUY/DVm6UlzKLxd6Z05nvF9tMkZZefaQWWcQGo1ROjQh2ZyI4fgIJ/vCe6bd3nWdBAFziMl0yqTMz0YqAJ4fUqEeUXdAkiTUxhazSpLAfjtdRmktZqQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4271.eurprd05.prod.outlook.com (2603:10a6:803:4c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Thu, 16 Apr
 2020 03:25:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.028; Thu, 16 Apr 2020
 03:25:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "arnd@arndb.de" <arnd@arndb.de>
CC:     "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
Thread-Topic: [RFC 0/6] Regressions for "imply" behavior change
Thread-Index: AQHWDeQiJzc7TgrcN0yUMWAEU5j98qhvr4mAgAADKgCAAB92AIAAp0gAgAEtnwCAAPPSAIAAHv4AgAXrpwCAABBmgIAAD4MAgAAAr4CAACg8gIAAECAAgAIjCgA=
Date:   Thu, 16 Apr 2020 03:25:21 +0000
Message-ID: <834c7606743424c64951dd2193ca15e29799bf18.camel@mellanox.com>
References: <20200408202711.1198966-1-arnd@arndb.de>
         <nycvar.YSQ.7.76.2004081633260.2671@knanqh.ubzr>
         <CAK8P3a2frDf4BzEpEF0uwPTV2dv6Jve+6N97z1sSuSBUAPJquA@mail.gmail.com>
         <20200408224224.GD11886@ziepe.ca> <87k12pgifv.fsf@intel.com>
         <7d9410a4b7d0ef975f7cbd8f0b6762df114df539.camel@mellanox.com>
         <20200410171320.GN11886@ziepe.ca>
         <16441479b793077cdef9658f35773739038c39dc.camel@mellanox.com>
         <20200414132900.GD5100@ziepe.ca>
         <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
         <20200414152312.GF5100@ziepe.ca>
         <CAK8P3a1PjP9_b5NdmqTLeGN4y+3JXx_yyTE8YAf1u5rYHWPA9g@mail.gmail.com>
         <f6d83b08fc0bc171b5ba5b2a0bc138727d92e2c0.camel@mellanox.com>
         <CAK8P3a1-J=4EAxh7TtQxugxwXk239u8ffgxZNRdw_WWy8ExFoQ@mail.gmail.com>
In-Reply-To: <CAK8P3a1-J=4EAxh7TtQxugxwXk239u8ffgxZNRdw_WWy8ExFoQ@mail.gmail.com>
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
x-ms-office365-filtering-correlation-id: 82daffa3-92f8-4ba8-49ea-08d7e1b5cb88
x-ms-traffictypediagnostic: VI1PR05MB4271:
x-microsoft-antispam-prvs: <VI1PR05MB4271649E778EA2A4D374A9BDBED80@VI1PR05MB4271.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0375972289
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(66556008)(66476007)(6916009)(6486002)(5660300002)(71200400001)(64756008)(478600001)(2616005)(76116006)(7416002)(6512007)(91956017)(66946007)(86362001)(66446008)(2906002)(81156014)(54906003)(36756003)(8936002)(186003)(8676002)(6506007)(26005)(4326008)(53546011)(316002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8HepqqDIGzEi7tORF5X5Tb7eoVREWluEC80774g/prha3cqwPaYbN25lrUFgxiRMpD6DNohkoTAJwmB1bmhc/s/h08T3m+Yu1uw4wKvvW3QlujiEvVWTyJrY88cA7s7RHtIA+B2IABZIJ/v04Ku4ysyNK3G0nHcZn1yN68lplqCMTbomq2Vjo4cGKJIHpj4nhXEmxelt2GOazolzidEhTxrM/Uh3UimAptxXxu4ihGloyqMbfShC+72RsFudGO28QuMs8G8TC1xJnOWAIFsYgRU9kn5zjpI+2LgySfw/4ZBEFuUY3xl6njDgIoOkUf3sn34wOQckv6Idwz8e2zJY6F5b+PLiLjkeulztQLE+ti1Y2bQ6zH4giqTtYaKW2acl3Def1H1fASvDdbXL/NDr7nktvAcG67TDMsaFsMNmjt+9Pq1QANe0SGmXFNlp4BQ+
x-ms-exchange-antispam-messagedata: JcdCHeSTiG2XhCo9in9V3RAZ5m5DubGzdykDehww6r9Poa9SQdOPri/i0CFqV5+Nl4NLIj9tPz51AXD7oEQrxLOUZgTuHROkO5I6zpVoZxLjEXiKh0Pv26gtRsHSfb1o0IQ/g+esnfH3YCPAh4x7nQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1152EAD69D690A4AAA58D754FDFF7D44@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82daffa3-92f8-4ba8-49ea-08d7e1b5cb88
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2020 03:25:21.3792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YbQgTK6PilEv+Zeii4Jn71Dy1zQrZY5+bMuMqMoYAgPlYJdHs2RD+bigZumM785TlqnxNBaQlw9Ujc8EMBGsIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4271
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA0LTE0IGF0IDIwOjQ3ICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBPbiBUdWUsIEFwciAxNCwgMjAyMCBhdCA3OjQ5IFBNIFNhZWVkIE1haGFtZWVkIDxzYWVlZG1A
bWVsbGFub3guY29tPg0KPiB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMjAtMDQtMTQgYXQgMTc6MjUg
KzAyMDAsIEFybmQgQmVyZ21hbm4gd3JvdGU6DQo+ID4gPiBPbiBUdWUsIEFwciAxNCwgMjAyMCBh
dCA1OjIzIFBNIEphc29uIEd1bnRob3JwZSA8amdnQHppZXBlLmNhPg0KPiA+ID4gd3JvdGU6DQo+
ID4gPiBDb3JyZWN0Lg0KPiA+ID4gDQo+ID4gDQo+ID4gR3JlYXQgIQ0KPiA+IA0KPiA+IFRoZW4g
Ym90dG9tIGxpbmUgd2Ugd2lsbCBjaGFuZ2UgbWx4NS9LY29uZmlnOiB0bw0KPiA+IA0KPiA+IGRl
cGVuZHMgb24gVlhMQU4gfHwgIVZYTEFODQo+IA0KPiBPaw0KPiANCg0KQlRXIGhvdyBhYm91dCBh
ZGRpbmcgYSBuZXcgS2NvbmZpZyBvcHRpb24gdG8gaGlkZSB0aGUgZGV0YWlscyBvZiANCiggQkFS
IHx8ICFCQVIpID8gYXMgSmFzb24gYWxyZWFkeSBleHBsYWluZWQgYW5kIHN1Z2dlc3RlZCwgdGhp
cyB3aWxsDQptYWtlIGl0IGVhc2llciBmb3IgdGhlIHVzZXJzIGFuZCBkZXZlbG9wZXJzIHRvIHVu
ZGVyc3RhbmQgdGhlIGFjdHVhbA0KbWVhbmluZyBiZWhpbmQgdGhpcyB0cmlzdGF0ZSB3ZWlyZCBj
b25kaXRpb24uDQoNCmUuZyBoYXZlIGEgbmV3IGtleXdvcmQ6DQogICAgIHJlYWNoIFZYTEFODQp3
aGljaCB3aWxsIGJlIGVxdWl2YWxlbnQgdG86IA0KICAgICBkZXBlbmRzIG9uIFZYTEFOICYmICFW
WExBTg0KDQo+ID4gVGhpcyB3aWxsIGZvcmNlIE1MWDVfQ09SRSB0byBtIHdoZW4gbmVjZXNzYXJ5
IHRvIG1ha2UgdnhsYW4NCj4gPiByZWFjaGFibGUNCj4gPiB0byBtbHg1X2NvcmUuICBTbyBubyBu
ZWVkIGZvciBleHBsaWNpdCB1c2Ugb2YgSVNfUkVBQ0hBQkxFKCkuDQo+ID4gaW4gbWx4NSB0aGVy
ZSBhcmUgNCBvZiB0aGVzZToNCj4gPiANCj4gPiAgICAgICAgIGltcGx5IFBUUF8xNTg4X0NMT0NL
DQo+ID4gICAgICAgICBpbXBseSBWWExBTg0KPiA+ICAgICAgICAgaW1wbHkgTUxYRlcNCj4gPiAg
ICAgICAgIGltcGx5IFBDSV9IWVBFUlZfSU5URVJGQUNFDQo+IA0KPiBBcyBtZW50aW9uZWQgZWFy
bGllciwgd2UgZG8gbmVlZCB0byByZXBsYWNlIHRoZSAnaW1wbHkNCj4gUFRQXzE1ODhfQ0xPQ0sn
DQo+IHdpdGggdGhlIHNhbWUNCj4gDQo+ICAgICAgICAgIGRlcGVuZHMgb24gUFRQXzE1ODhfQ0xP
Q0sgfHwgIVBUUF8xNTg4X0NMT0NLDQo+IA0KPiBTbyBmYXIgSSBoYXZlIG5vdCBzZWVuIHByb2Js
ZW1zIGZvciB0aGUgb3RoZXIgdHdvIG9wdGlvbnMsIHNvIEkNCj4gYXNzdW1lIHRoZXkNCj4gYXJl
IGZpbmUgZm9yIG5vdyAtLSBpdCBzZWVtcyB0byBidWlsZCBqdXN0IGZpbmUgd2l0aG91dA0KPiBQ
Q0lfSFlQRVJWX0lOVEVSRkFDRSwNCj4gYW5kIE1MWEZXIGhhcyBubyBvdGhlciBkZXBlbmRlbmNp
ZXMsIG1lYW5pbmcgdGhhdCAnaW1wbHknIGlzIHRoZQ0KPiBzYW1lIGFzICdzZWxlY3QnIGhlcmUu
IFVzaW5nICdzZWxlY3QgTUxYRlcnIHdvdWxkIG1ha2UgaXQgY2xlYXJlcg0KPiBwZXJoYXBzLg0K
DQpObywgSSB3b3VsZCBsaWtlIHRvIGF2b2lkIHNlbGVjdCBhbmQgYWxsb3cgYnVpbGRpbmcgbWx4
NSB3aXRob3V0IE1MWEZXLA0KTUxYRlcgYWxyZWFkeSBoYXMgYSBzdHViIHByb3RlY3RlZCB3aXRo
IElTX1JFQUNIQUJMRSgpLCB0aGlzIGlzIHdoeSB3ZQ0KZG9uJ3QgaGF2ZSBhbiBpc3N1ZSB3aXRo
IGl0Lg0KDQoNCj4gDQo+ICAgICAgIEFybmQNCg==
