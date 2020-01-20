Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED53142A14
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 13:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgATMI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 07:08:27 -0500
Received: from mail-eopbgr50067.outbound.protection.outlook.com ([40.107.5.67]:14594
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726650AbgATMI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 07:08:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alSs9LXu4IICPNx1FsSme3WutPkbmFm5s7u5Aek8RPOOWEP9Sx/Rx78J5FDpBaSSZcSA9BSAFrL65ro/mnSYpkaFdw8E/tw7uahpF26+54qldZIjw6rEG2RBbSIvgfPK9nYBvkVRj2cay8bjOtDEgyO1RaKocGP4RcxRscz8ZE0j5DkNODXxM2nwm/jOirU+3MJN2JVYkpK8SK5k844ZGoaqsUB9qEpom5Y+HxqujiiZd51UY7uFEQhBLsFm/CV1oa/Jeznohj2tsbjR1nVoGOPbTzuIcdhSwLXB2ny2ujHEFtTe7S3fraPkVM8VgUEhbrP3XpEBNl0rEEVdw6bBjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RvSQgQfGXJO+4hg07DnNroL++yU+5zFbeZ4g8IYq2g=;
 b=Gg4ITzC7SdsFpduiLTVvSPN0EZdWenm4+AHyoD6VnYBDr70ve2O4q78frOzFvJ5JfqMn8hMivnRTGwJB04UPE5HC6L/EUgC/FMYJ9mv52ObzrCPcb/uHo2KuP4gf5six+/XN7E8jCd0GcXFphdFYc7DagadKeLsJ23ilytPfn3G5pD3xPeBy1CkjlpI5h8sRW87nEio49QqeK6s9j2ptBeI5WRwSCTmajNbUvrytG0TjJuhu9OksBD0JNf5OJELiFzfEWoXjVyazLYV2TV5PeM8kwxNYeoqZGD8bzVXTS0hqprpUeiCC5V3mdfHJnMwItroBs83YOp0b5gHH9tCTVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RvSQgQfGXJO+4hg07DnNroL++yU+5zFbeZ4g8IYq2g=;
 b=fAQXnP+O0BmwTL7ZtKJCHw6v+8+MUfnDDQKwP2v/PKas9t0tYzzRkrhd6sNwwt4xUsMlEP0n69BdcTs1iopaXVMaqeWzoP1HAH7YPZwVrE3c8v1yhWmL5E5I5JHRdYloL/wbVR1L28vAWYGIk0rUNj/SkX0SzUKzDFJDwch5CuM=
Received: from DB7PR05MB4204.eurprd05.prod.outlook.com (52.134.107.161) by
 DB7PR05MB5575.eurprd05.prod.outlook.com (20.177.194.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Mon, 20 Jan 2020 12:08:22 +0000
Received: from DB7PR05MB4204.eurprd05.prod.outlook.com
 ([fe80::1c4e:bcb1:679f:f6]) by DB7PR05MB4204.eurprd05.prod.outlook.com
 ([fe80::1c4e:bcb1:679f:f6%3]) with mapi id 15.20.2644.024; Mon, 20 Jan 2020
 12:08:22 +0000
Received: from [10.223.0.91] (193.47.165.251) by AM0PR02CA0049.eurprd02.prod.outlook.com (2603:10a6:208:d2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.24 via Frontend Transport; Mon, 20 Jan 2020 12:08:21 +0000
From:   Moshe Shemesh <moshe@mellanox.com>
To:     David Miller <davem@davemloft.net>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] devlink: Add health recover notifications on
 devlink flows
Thread-Topic: [PATCH net-next] devlink: Add health recover notifications on
 devlink flows
Thread-Index: AQHVztnNYWuihUsYUUW2VoHt4eJrT6fzUGKAgAAmhYA=
Date:   Mon, 20 Jan 2020 12:08:22 +0000
Message-ID: <9ed99e52-f55f-0a4a-0eb0-974504bed85a@mellanox.com>
References: <1579446268-26540-1-git-send-email-moshe@mellanox.com>
 <20200120.105027.695127072650482577.davem@davemloft.net>
In-Reply-To: <20200120.105027.695127072650482577.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
x-originating-ip: [193.47.165.251]
x-clientproxiedby: AM0PR02CA0049.eurprd02.prod.outlook.com
 (2603:10a6:208:d2::26) To DB7PR05MB4204.eurprd05.prod.outlook.com
 (2603:10a6:5:18::33)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=moshe@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ea692a2a-9f36-4622-de09-08d79da171ee
x-ms-traffictypediagnostic: DB7PR05MB5575:|DB7PR05MB5575:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR05MB5575CD008B0F375C585FEC9CD9320@DB7PR05MB5575.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(189003)(199004)(53546011)(81156014)(186003)(16526019)(81166006)(6916009)(8676002)(8936002)(4744005)(26005)(31686004)(5660300002)(956004)(2906002)(15650500001)(2616005)(36756003)(71200400001)(66946007)(66476007)(6486002)(64756008)(66556008)(66446008)(54906003)(31696002)(52116002)(86362001)(4326008)(316002)(16576012)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB5575;H:DB7PR05MB4204.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1HlmvloCCedcs0TeuB8Mm432DhPmF940s3U+Ju04Hw/IwiHqvjKV+P7c7vpsFqO1y1O+JlHg7pSM0or0SHSlhpgndyKbCWMly5tV5aLPFfp6HNkcE4V2nod+BlTAQEH07UmWqAHxVh+nxJnnPT1mk1UEKv1Ryw4yM/+Uorx0idFgnoHqbs3V86FrGAU+Lyw6Me5AuEEtzaLZv4Ie9HQztfs/MrFqW4wDKHa0ttnAyhLQZJp5ayCqSoF6ADP/css5/sB4uZiTfdfzaBiCqvfpz74jKJE5RZQExvct7N8kUlVuyJ28ambwOOnLz/852hTMuIzfhKniP5ih0aRe+URiSFV8Nk2EG9oTtDaNF1pwIxvqYkARPxYmI5/3Fg8puj7YjFnfIA80PJCFp0wEow4T8VeltbXORBS8rjIOXLDjda0ZaTmKwQUgB11Rm3GDRWzs
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C73C519D8657A4B98C090CE17626A76@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea692a2a-9f36-4622-de09-08d79da171ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 12:08:22.5368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jm2zd4Iu1yUo9n08jUtPiyTkl+FVBSA+e5Yg8AI3bVwREHaeLXkQmndoChfha2qMVa3vnjc3Vt7MPrT6zKASOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5575
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzIwLzIwMjAgMTE6NTAgQU0sIERhdmlkIE1pbGxlciB3cm90ZToNCj4gRnJvbTogTW9z
aGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KPiBEYXRlOiBTdW4sIDE5IEphbiAyMDIw
IDE3OjA0OjI4ICswMjAwDQo+DQo+PiBEZXZsaW5rIGhlYWx0aCByZWNvdmVyIG5vdGlmaWNhdGlv
bnMgd2VyZSBhZGRlZCBvbmx5IG9uIGRyaXZlciBkaXJlY3QNCj4+IHVwZGF0ZXMgb2YgaGVhbHRo
X3N0YXRlIHRocm91Z2ggZGV2bGlua19oZWFsdGhfcmVwb3J0ZXJfc3RhdGVfdXBkYXRlKCkuDQo+
PiBBZGQgbm90aWZpY2F0aW9ucyBvbiB1cGRhdGVzIG9mIGhlYWx0aF9zdGF0ZSBieSBkZXZsaW5r
IGZsb3dzIG9mIHJlcG9ydA0KPj4gYW5kIHJlY292ZXIuDQo+Pg0KPj4gRml4ZXM6IDk3ZmYzYmQz
N2ZhYyAoImRldmxpbms6IGFkZCBkZXZpbmsgbm90aWZpY2F0aW9uIHdoZW4gcmVwb3J0ZXIgdXBk
YXRlIGhlYWx0aCBzdGF0ZSIpDQo+PiBTaWduZWQtb2ZmLWJ5OiBNb3NoZSBTaGVtZXNoIDxtb3No
ZUBtZWxsYW5veC5jb20+DQo+PiBBY2tlZC1ieTogSmlyaSBQaXJrbyA8amlyaUBtZWxsYW5veC5j
b20+DQo+IEkgcmVhbGx5IGRpc2xpa2UgZm9yd2FyZCBkZWNsYXJhdGlvbnMgYW5kIGFsbW9zdCBh
bGwgb2YgdGhlIHRpbWUgdGhleSBhcmUNCj4gdW5uZWNlc3NhcnkuDQo+DQo+IENvdWxkIHlvdSBw
bGVhc2UganVzdCByZWFycmFuZ2UgdGhlIGNvZGUgYXMgbmVlZGVkIGFuZCByZXN1Ym1pdD8NClN1
cmUsIEkgd2lsbCByZXN1Ym1pdC4NCj4gVGhhbmsgeW91Lg0K
