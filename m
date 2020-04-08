Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C531A295C
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 21:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbgDHTgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 15:36:12 -0400
Received: from mail-eopbgr150073.outbound.protection.outlook.com ([40.107.15.73]:30368
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729978AbgDHTgL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 15:36:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLvmuGNMIkW6Aq9UO0tgttyf2CZJBQbDAvdwmK2Gc4mwit5XcJ7dO1/9J+1Sh05q3XCMtCbrTAuXv90jJB0Tf+JNN58lCSMFi4TuX47njegKpgJsEIglS+oCgV/M+emSd7JoO5hh4uGJAK1V6rulT35uFHxqNoIBsTFt/SY+QSd9fJlEnc+8KA2K+S4k2rtlFTO89Qi8QBaKz+W7FI0B26T3s2qz9TjmqtxjNOuRjk8IeNVQ/n9vIyf59Xlflfry/yDoQ+XKoSUdRHTKtb0ZnW5Ii1OH0+6kWqk5LxlG7p/4kcqKk2+svkTalEppQJGZIZX8oWlid2YsMxdpLV8NLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NLgExbLwTCF8CK6zFLNUL7AqliA28Qc0BxN8M9gEkI=;
 b=YXTDmTFfNyn6Om9CAU8hHpKd3LUgAeJouyRsQh4q5tret3aWACQj9MKD78I3PzUe2TPV2k4SjZy6gsgBd8eQvgFzfDB9Enwc+E1UHXKR950QVPApKaU067h7mV8mBOAecMy9bAelwqgq9Rm6HMI5wBXa+muZ2Z/m5Rc9rIIr5UxC3OvejnUhwN6bZKAFCF/K6L4ijF8s2JcgWiNx12Nt/whziCCFROsBOODwnLWwCmBapJ+x3+QC5WV2oGP5jEKFsqXyxY+InwcWQiYWCEtl2sxWNIWpjcqMCa7iXlI+6vogQXpmshdEUWJhxE1lal/N9Kibpi7XQRL3NSpve3PxiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NLgExbLwTCF8CK6zFLNUL7AqliA28Qc0BxN8M9gEkI=;
 b=OqvaG2faaHnJ0q7s52AEPeZZdaiuAka0iJNYRryaN76YskILCx/79ZUjs5F+W96qzTM5HcU8l8H6V7J6NLtkWV8WnVJff0YQarBToBYSynG7D94thwybcn+pAL6qQ8EZ2YnmjR/47M0GYvdRSyHZR0WwEaMPGDFHx4Y95pJSzjA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3472.eurprd05.prod.outlook.com (2603:10a6:802:1a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.17; Wed, 8 Apr
 2020 19:36:07 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 19:36:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Alex Vesker <valex@mellanox.com>
CC:     Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/1] net/mlx5: Fix failing fw tracer allocation on s390
Thread-Topic: [RFC 1/1] net/mlx5: Fix failing fw tracer allocation on s390
Thread-Index: AQHWDLLERkPdcFex20i6r53b871po6hvoH2A
Date:   Wed, 8 Apr 2020 19:36:07 +0000
Message-ID: <00fc95b9c6f5da7ec5844b9eccf4488d4a37efd8.camel@mellanox.com>
References: <20200407080130.34472-1-schnelle@linux.ibm.com>
         <20200407080130.34472-2-schnelle@linux.ibm.com>
In-Reply-To: <20200407080130.34472-2-schnelle@linux.ibm.com>
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
x-ms-office365-filtering-correlation-id: e122c735-35d0-4808-ada5-08d7dbf41589
x-ms-traffictypediagnostic: VI1PR05MB3472:|VI1PR05MB3472:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB34723EBA9A664FCFB9FCAA50BEC00@VI1PR05MB3472.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0367A50BB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(396003)(39850400004)(346002)(366004)(136003)(4326008)(4744005)(6636002)(71200400001)(26005)(5660300002)(186003)(6486002)(478600001)(81156014)(2616005)(8936002)(81166007)(6506007)(8676002)(66556008)(110136005)(64756008)(66476007)(66446008)(91956017)(316002)(76116006)(54906003)(2906002)(66946007)(86362001)(36756003)(6512007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fkruMyxvNr9asNW/g8lofbDy3mydGzqZNNL+/xzWAVlnUJUI6SnqS0oYaWUrrWL3Rnhky9V/a63bKUB3xfwXOt2jO0cMO0cxKi/x6E0WOClw9XjJvch42cm7F6VeTzevKNGg3DEF5Y+mHdn3NKevLWEKe5xnbV1IQhGK5Drf3uY//AGwzP/fsofNjUQaNi3WnVA4fsgA0YMmi62ng6idpw7m7ADciNc4yVx1XN+LUvXTMCCDEAnRhfwdSnZKjxumhPmPWyUb9x8waGNAVv86jIRc/3wINlLXTKiTXm0V412ftqfzxeqwJ0DaRFJI7jPh9PtOBemJKzD0Bw7pJzyRB323ga6A1SFmGuLVM3L/H4Y4XebjJqccBz6VBDdbF/lOv6FjGcvddHbOSqBJJZ4nO9XcvP85u/cj5QmE9LzwVTs7sKWoFYloQFOcYOoZvx5n
x-ms-exchange-antispam-messagedata: yPRHVZ+/6yRXZ8II0LF6OgSnNSYKY1VOUXrudgoK6PfUfTgbxw4eWKojK6qGOEWJElGiJa+HIRKb5Syat5oxYtbsvyMWQHQXR9Ym9f+Ps36bgII9Rvofc/Z9RXqrog8Qs/VyUH5t9S61CDpfllCDFA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB0804B430423243A3973836B19E1ECA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e122c735-35d0-4808-ada5-08d7dbf41589
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2020 19:36:07.5602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IlMYJMooVkKZcYDrMuvYJFocHfMIT9jC7CSMG8FP8E2YUw5Dm3DqQJ7Xv759k0WG4YLpAJ4cGVvyE1e4z+pSgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3472
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA0LTA3IGF0IDEwOjAxICswMjAwLCBOaWtsYXMgU2NobmVsbGUgd3JvdGU6
DQo+IE9uIHMzOTAgRk9SQ0VfTUFYX1pPTkVPUkRFUiBpcyA5IGluc3RlYWQgb2YgMTEsIHRodXMg
YSBsYXJnZXINCj4ga3phbGxvYygpDQo+IGFsbG9jYXRpb24gYXMgZG9uZSBmb3IgdGhlIGZpcm13
YXJlIHRyYWNlciB3aWxsIGFsd2F5cyBmYWlsLg0KPiANCj4gTG9va2luZyBhdCBtbHg1X2Z3X3Ry
YWNlcl9zYXZlX3RyYWNlKCksIGl0IGlzIGFjdHVhbGx5IHRoZSBkcml2ZXINCj4gaXRzZWxmDQo+
IHRoYXQgY29waWVzIHRoZSBkZWJ1ZyBkYXRhIGludG8gdGhlIHRyYWNlIGFycmF5IGFuZCB0aGVy
ZSBpcyBubyBuZWVkDQo+IGZvcg0KPiB0aGUgYWxsb2NhdGlvbiB0byBiZSBjb250aWd1b3VzIGlu
IHBoeXNpY2FsIG1lbW9yeS4gV2UgY2FuIHRoZXJlZm9yDQo+IHVzZQ0KPiBrdnphbGxvYygpIGlu
c3RlYWQgb2Yga3phbGxvYygpIGFuZCBnZXQgcmlkIG9mIHRoZSBsYXJnZSBjb250aWd1b3VzDQo+
IGFsbGNvYXRpb24uDQo+IA0KDQpUaGlzIGxvb2tzIGZpbmUgYW5kIHZlcnkgc3RyYWlnaHQgZm9y
d2FyZC4uIGkgZG9uJ3QgZXhwZWN0IGFueSBpc3N1ZQ0Kd2l0aCB0aGlzLg0KDQpQbGVhc2UgcHJv
dmlkZSBhIHByb3BlciAiRml4ZXM6IiB0YWcgYW5kIHJlc3VibWl0IHRvIG5ldCB3aXRob3V0IHRo
ZQ0KW1JGQ10uDQoNClRoYW5rcw0K
