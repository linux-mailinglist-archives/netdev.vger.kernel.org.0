Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3541BCC8D
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 21:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgD1Tnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 15:43:40 -0400
Received: from mail-eopbgr70041.outbound.protection.outlook.com ([40.107.7.41]:10433
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728392AbgD1Tnj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 15:43:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KfXYihsiFYPcafXka0l8jzDplIQaTZlPy8cRmEC/OP1cjNCxojplBZaJ+AealgLpAeYbAaWT0IIC4zvnmG67q7vZ9Ix9+fP5zxJWqG7FOhU6b6NSEwiRlj0547GoDx9Em0sM6txSp9L177C5aYF2ZwdDD4FTdqQ1jpKnS5LG5FE5ksxZoe8drewtlGkNFuoSYysnscNeuWC4QkPOSB4SSOtyoVsq9s0PZSGgjtggEUV7NzU3U28a5/eRNLoh/Whfq3D0t5NFughcwfuuI6ApXpaU35w1kedbeW89o3Ju96XpTDCzaJnOLHKoQK46KnaAD8H+MlJlaKSfKI7bHzPpjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLFFzQWfZWM+sBXPwUNLvmMcIsJP87ClzSYJ7yx1DeQ=;
 b=ETfVgVInJtbmrUXRva7lXqNE0MC8v7/zc/d+cuGepQCF0Xcwi0dVtQGdg3b/cT0DyB6RI4GQxa5DyKNt1kASkZjxzFTxN5HtJQOsObS6fozGST/7kt195pWlsXlNjzLM2V1p+lNp2sPR3LhddPJCwCScA3RivHNCBdDwJr5kmzQoA1AVYVT4cNIul9nrtPdoUuOZzyTkXG87ZcXiIZx4Xe1YbH2OyzTKHdI1RqRqPH8qpFzUvGK5MYblBK6hTCyQsqzb3TQIn3LC9rkFipjZAuTggFVFm/dTRg6NkcIPzQN7/VoeD5OwWvS7PgLZD+/HChanHQJVDCc92ctKe22y+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLFFzQWfZWM+sBXPwUNLvmMcIsJP87ClzSYJ7yx1DeQ=;
 b=B3iVLrzDAzr9kAMS5PPcRHDLQPEXzW2eI8M3W4+fVJKGF1sUApqBLQ/UvaN3qKAP7G9FBVS12htpCVXOTu2kTj0uVjXGRJ7qsJjVt48PFkNY5bIaTxtTMXHAHN374hpCQzW2YlUKG2bcPhAYiaoIbfcpnwk65CswN9edFMPt8Yc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6861.eurprd05.prod.outlook.com (2603:10a6:800:180::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 19:43:36 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 19:43:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     Ariel Levkovich <lariel@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>
Subject: Re: [PATCH mlx5-next 3/9] net/mlx5: Use aligned variable while
 allocating ICM memory
Thread-Topic: [PATCH mlx5-next 3/9] net/mlx5: Use aligned variable while
 allocating ICM memory
Thread-Index: AQHWGnDv749zZUEmH0OpavVY0xgqTqiIryAAgAZGlAA=
Date:   Tue, 28 Apr 2020 19:43:36 +0000
Message-ID: <d2f32b582d770dfdd99ac4850c1a8598232bc27f.camel@mellanox.com>
References: <20200424194510.11221-1-saeedm@mellanox.com>
         <20200424194510.11221-4-saeedm@mellanox.com>
         <20200424195320.GB15990@unreal>
In-Reply-To: <20200424195320.GB15990@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 34234438-8cfb-4b1a-0b70-08d7ebac7133
x-ms-traffictypediagnostic: VI1PR05MB6861:|VI1PR05MB6861:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB686167CFDDA559EEFD3857BBBEAC0@VI1PR05MB6861.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0387D64A71
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(86362001)(66946007)(76116006)(64756008)(91956017)(66476007)(6506007)(66446008)(8936002)(37006003)(66556008)(2616005)(54906003)(26005)(36756003)(8676002)(6512007)(6862004)(107886003)(6486002)(71200400001)(4744005)(5660300002)(498600001)(186003)(450100002)(6636002)(4326008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JYxtjtWTG5k/XZXRfXpWTMrHg0RIM22HffQ51sJDzdgU1G9I446RIXCHgfmv1nPoje2pu0paL/KkbAq72i6X+TQ/KFBI9UhUsoB8n+HRMcDTQIxJ/E+ZdrHKBhcEuWA1X30zBOSajaRvo0TqtskJd+G7M8rf5IkZO0uOF0e1zIl9aaAfeH9eo8Zd6+nh2nCCcopU6T6l4qoiHNiMng2MTggDGUbI9LHAwGkHLjcOy0dwvRp8lL+x0Y3k1k1XR47Tr/PGTeLa/F0FxpvIH4zLalvykzYU0c2XYGZWabpelm5k6WM02gzrUxSUYo0l2z1HyDBHUZOCYDfvqFLLyjKW0UnwTYFqPkp1TnBsSeH50yIznabbwuVbspWOr/oTZsrOIq0DpciqEXE83tDpuABdqex6NKkmaxZNDmFakbe2iUQ967IEa/lc7ChEznVr9TtX
x-ms-exchange-antispam-messagedata: YqM4Ue/lErlmAwlwwmT8ybCtNvU0d3WZlk9yUQvUHeJV3BY1VE4a7LdA53GmxbnXWwq+7ha7biOERJea47S1j0D68l6rvl5+tvhzhSU39J7wMz2TM47ZsuogJasfVonZwC5aKO5Kgh7cEHI8pq4rVil7ztG07cJDyYjKKk+30e6taZphSvsWL/5lMOLZnLHOvnQAHl1wAI1tWnwaph8VPXUY9oGGK77yqSmx9jb908YcJkDPAuC7wm7rtfoZbgSkfHH8JEqXpjVIK9xgt2MFGGAT4b8TF9Z4JM2R60B7vmTeMJKupNMoaUbIC1mvT7rwoGe0k6U5Fhf1v3PbRVxMlwVwwmjaMIWIIwI6CAhGT3nf7y7T3uuDswvi+buHhUS8VdV1RJMm82WbmAZo3+godR6PttDkbJ2lKu1e/ikMqt8GxvqYoKgdoOJGf2+67ZuHNeygTUo/8lJxAsK2T/NCeZAWJPbKBUEEAfY5KEX0gWUCS1TcQFGje1HFdLi7HPK26BJBi1B0OPK4c6HcRxcpeu3oQGXGYZ1+59vr7OuJWuG/kgsXOLuJWTKrAHqSl2LrrD0QnpOlIuluDMhMw3V64KnZ+WMrmSopXohry5nGv1vxB/UjvJIDGT8+UyvEOM+apYs82Y8vMhzNl5qNrU6u8gp+6GG0bx+hyIXIcXEeiXYP/KAoJ/QnpuiCzWT6R2i7ohmOwFkUbQRFwgW9Jegde+OqXFLwmRLt9HNHzX6pIQ78LXhX7FLlEleSDmD20IeFK+g94hgjXvgLHl28GDn/ZV79CiHb5UnNUbtC2DZBMVY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02B9CC60BB5E9244A8BC5627AC689FEB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34234438-8cfb-4b1a-0b70-08d7ebac7133
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2020 19:43:36.0978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VslitKeWg7HFls3IkToziXwsimUeTlWRIo2WohKYslOCJ1Vj6npjSoX9a2mv7F4LTdB10oiVcylL869ekEWOVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6861
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA0LTI0IGF0IDIyOjUzICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIEZyaSwgQXByIDI0LCAyMDIwIGF0IDEyOjQ1OjA0UE0gLTA3MDAsIFNhZWVkIE1haGFt
ZWVkIHdyb3RlOg0KPiA+IEZyb206IEVyZXogU2hpdHJpdCA8ZXJlenNoQG1lbGxhbm94LmNvbT4N
Cj4gPiANCj4gPiBUaGUgYWxpZ25tZW50IHZhbHVlIGlzIHBhcnQgb2YgdGhlIGlucHV0IHN0cnVj
dHVyZSwgc28gdXNlIGl0IGFuZA0KPiA+IHNwYXJlDQo+ID4gZXh0cmEgbWVtb3J5IGFsbG9jYXRp
b24gd2hlbiBpcyBub3QgbmVlZGVkLg0KPiA+IE5vdywgdXNpbmcgdGhlIG5ldyBhYmlsaXR5IHdo
ZW4gYWxsb2NhdGluZyBpY20gZm9yIERpcmVjdC1SdWxlDQo+ID4gaW5zZXJ0aW9uLg0KPiA+IFNp
Z25lZC1vZmYtYnk6IEFyaWVsIExldmtvdmljaCA8bGFyaWVsQG1lbGxhbm94LmNvbT4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBFcmV6IFNoaXRyaXQgPGVyZXpzaEBtZWxsYW5veC5jb20+DQo+ID4gDQo+
ID4gU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+
ID4gLS0tDQo+IA0KPiBFeHRyYSBibGFuayBsaW5lIGJldHdlZW4gU09CcyBhbmQgbm8gbGluZSBi
ZXR3ZWVuIHRleHQgYW5kIFNPQnMuDQo+IA0KDQp3aWxsIGZpeCBhbmQgYXBwbHkuDQoNClRoYW5r
cyENCg0K
