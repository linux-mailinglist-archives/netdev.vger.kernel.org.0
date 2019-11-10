Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 060CEF69E8
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 16:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKJPsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 10:48:40 -0500
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:24099
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726800AbfKJPsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 10:48:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2JrCKmpjvDsJhtqDxS/pZWDXNLk/680aL3F5JRthnySCh0Lua7dlLeagDJuoTc720/1/nAouB5hK0Be1jorudd7T1mH3jMNBD1eXQ4TFWNSrnYcSeNoOXbqen79+819t9OPpwknOCFUuX+I4iuxPDqZ4q+VHdecGvRT2eJKG/KW7hDqipoHpsMu3Y1+0KIjTrXplG9+NJzcQ3lCi6kl0v1CMvz6MKI2YSx+d2J/i0/6J4Ehlrt0IfamA4Xwg+eKe1VlRzE9SChjcpO5K020uvuxyWIOUzKGKSrxXN+v5rCLKjYDNnwq4+Yx/8dIIAcOPjmecQen6F97BMDri6Skfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymxLw0tffLPELbSNdGkAAIMY2Dc1b+JGM0aSHKsTRi8=;
 b=kZ7pcwZkauhpUn6Sp+ByO3CMXaQLNo1XMLePgKhonfkBhrGrT9Iu7+aWf3J9vGXbxL+7Ner5UL61qM+n5ZhQ32V/9ryJwRpQq8Wil7nl6OCQkeQbJHqLeM0+QukG8yidej+al5MrU+z6w74CagD3u7l8tOfjuKooG8Bp9HHb8zgnqDGIHxqHPQnBFeOfhWjEG/34uC5RwHfWZPAVEHTU9x72wtCSTkefqp4xBCFjLiCL/w5SW/nwIfICxCRa1d17s8ckexoXCFysZdYWjSDjKqinAxSapuj2YE3B3kXRfpIRZ5zBwnsSFHErpxh9M5mDXfih6rARC+Jdj1eTW5Bl4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymxLw0tffLPELbSNdGkAAIMY2Dc1b+JGM0aSHKsTRi8=;
 b=gk/XlHLBLNQsBW/ldpgwp5RQ4dW3arb572XlnJK1IlNpWD7oR/CQ4E5doYw5uuDsl9PEjto+3sXz2oYz275NyV74250Ok+chkSSGd88PqrETj1b6Uv19/7/iwAgQ71BYpbX9t8EUxztnjbP2zm0WUZTPKT7XTSd4t6BcFVhqSak=
Received: from AM6PR0502MB3783.eurprd05.prod.outlook.com (52.133.17.145) by
 AM6PR0502MB3672.eurprd05.prod.outlook.com (52.133.20.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Sun, 10 Nov 2019 15:48:37 +0000
Received: from AM6PR0502MB3783.eurprd05.prod.outlook.com
 ([fe80::7478:e4bb:fa38:3687]) by AM6PR0502MB3783.eurprd05.prod.outlook.com
 ([fe80::7478:e4bb:fa38:3687%6]) with mapi id 15.20.2430.023; Sun, 10 Nov 2019
 15:48:37 +0000
From:   Shalom Toledo <shalomt@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Ido Schimmel <idosch@mellanox.com>, mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net] mlxsw: core: Enable devlink reload only on probe
Thread-Topic: [patch net] mlxsw: core: Enable devlink reload only on probe
Thread-Index: AQHVl9vq7biYbZKT1ECGRVp3Hi0iuaeEjOYA
Date:   Sun, 10 Nov 2019 15:48:37 +0000
Message-ID: <6775f3cb-ab66-dd82-30ff-d18d7b34c714@mellanox.com>
References: <20191110153123.15885-1-jiri@resnulli.us>
In-Reply-To: <20191110153123.15885-1-jiri@resnulli.us>
Accept-Language: en-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
x-clientproxiedby: AM4PR08CA0062.eurprd08.prod.outlook.com
 (2603:10a6:205:2::33) To AM6PR0502MB3783.eurprd05.prod.outlook.com
 (2603:10a6:209:3::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shalomt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 541077bf-5368-47bb-a96c-08d765f57342
x-ms-traffictypediagnostic: AM6PR0502MB3672:|AM6PR0502MB3672:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0502MB367284CA73AA0AA30056B9A9C5750@AM6PR0502MB3672.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 02176E2458
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(199004)(189003)(52116002)(2501003)(76176011)(386003)(6506007)(7736002)(66476007)(66446008)(64756008)(66556008)(66946007)(53546011)(102836004)(31696002)(305945005)(86362001)(186003)(26005)(6246003)(107886003)(478600001)(4326008)(8936002)(6436002)(229853002)(6512007)(31686004)(256004)(6486002)(65956001)(8676002)(446003)(25786009)(66066001)(65806001)(81166006)(81156014)(4744005)(5660300002)(99286004)(14454004)(486006)(476003)(2616005)(3846002)(6116002)(2906002)(316002)(58126008)(54906003)(11346002)(71200400001)(71190400001)(36756003)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0502MB3672;H:AM6PR0502MB3783.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fxPYdS75a9eEPtn+qLJuX1asquxJxc7ZZW9b+Kicaj8CfbqN+TmsYjn5oNIIFZBolB/nFaWOLzdL3O5TDVDm/7Av7Uyd1u9Bxv/qwUPS2Gsx36Ra38tjNN2Q4ZzxTLYYxGflN4AkAqY1EKKZ52hJfrbG7JeLadypkZEO+0vOJJV4OaJvjeIGjcs9SRSSHm7935b2wyGAAvqKx4cyKCPz2xF8qSVDKHgQhYdyFqKqpQxunTXVFY+ZOoqnhkFYP733ct+pYfowSfKwO5d1iaKtMdZj2JMJsSu4QSq34rOfkA3+FtANTr/R8TTwzFNAvRWXRQuqoPcakOi7f/c36RuMdGJb7dbD4ZqjVgtvwjR3dy2SD2/dk2WYW5uXmV/AA/ZKNSgvidh9XmlEdSWDgPyQvjPqg2XHxDsnUZp/Vfnw2u+XxfOZKo8cF6LunJTjMVt7
Content-Type: text/plain; charset="utf-8"
Content-ID: <B0FD62B890296342B5F5E451A9794B94@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 541077bf-5368-47bb-a96c-08d765f57342
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2019 15:48:37.2525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xDO+OQy3e8jijgI9vmTL0nOu+LeK+SwUr5QZJLjYPEvT/xtCJQJ+LmKP+06e497Qmy+FPvX5rlZG+oZNKzd63Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3672
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTEvMjAxOSAxNzozMSwgSmlyaSBQaXJrbyB3cm90ZToNCj4gRnJvbTogSmlyaSBQaXJr
byA8amlyaUBtZWxsYW5veC5jb20+DQo+IA0KPiBDYWxsIGRldmxpbmsgZW5hYmxlIG9ubHkgZHVy
aW5nIHByb2JlIHRpbWUgYW5kIGF2b2lkIGRlYWRsb2NrDQo+IGR1cmluZyByZWxvYWQuDQo+IA0K
PiBSZXBvcnRlZC1ieTogU2hhbG9tIFRvbGVkbyA8c2hhbG9tdEBtZWxsYW5veC5jb20+DQo+IEZp
eGVzOiA1YTUwOGEyNTRiZWQgKCJkZXZsaW5rOiBkaXNhbGxvdyByZWxvYWQgb3BlcmF0aW9uIGR1
cmluZyBkZXZpY2UgY2xlYW51cCIpDQo+IFNpZ25lZC1vZmYtYnk6IEppcmkgUGlya28gPGppcmlA
bWVsbGFub3guY29tPg0KDQpUZXN0ZWQtYnk6IFNoYWxvbSBUb2xlZG8gPHNoYWxvbXRAbWVsbGFu
b3guY29tPg0K
