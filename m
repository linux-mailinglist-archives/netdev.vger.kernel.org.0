Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C6C392DB0
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 14:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhE0MMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 08:12:25 -0400
Received: from mail-eopbgr30070.outbound.protection.outlook.com ([40.107.3.70]:32367
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235085AbhE0MMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 08:12:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hR5EHcVYSnN1wuVsIG0UnSubSnj/+q3hiBpM5NpyaGYghsEAbAVck7NwCtctVT3y0+D4jahYO+7L3hbqEdiRIzKOpjzeOeTVbRUa9muDnlOajXKP3v5etqZgSkUbexyYSF5RgiTk4739QLRm2RJxgxNW6xzqj8RkdT7iXnBxdRifRTCJtmwITnhiAtVc77sVHoDKZO5kCsob/XeF4dz9PucJCCfTaeRPORpTmsSVkbIm63g3VGj6B6XvT70IV68pTUutHJ1AzMekyjXQgWX0ZdKpGxkhRVHMUHi4st5FJHXQ99T4D14Z4qCqcLTNsxX1PzDV86ns77MJylFtpuzVpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9/Mcide8nYiuCZjQ4WBFOznVxgzfGiP/V4Wz/6iT6U=;
 b=MskePpwJl+eUvu2c8k+1A5tv2xADK5TjXk/EE9d+uXdq4w1nkTbwXBmBTvrw5Dn1FxxDZg/VB3kX/c49Pd+xv01i0zkG32ao48BTFaA9mPvqlr5TiwcEWYzWwXFc+7DrclT5j1BIB6F3C8dDXxDxq6z2KIsN/zt8jAFPf8OhOeMbV07+GphagCsbKuoWLKZmjmma8kApHiueDNFBSaHvYywy60211fJnsKBhWry4QudckkrBT1HAAuPweirqCUNSC5WtgCu2eF9IrAugvS+A4tl7hLx99BhclNmttg4A2ymzrNpFfWY3qHkpL8jfA/NVIXRc85OXhNKD/95FYVXYMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9/Mcide8nYiuCZjQ4WBFOznVxgzfGiP/V4Wz/6iT6U=;
 b=b61yr/PHFWqguKwt1Ks8kQikEMWkAuH03Onotv1XCN0PEmzji1cLhEffBnJc2Kd3+yhL2DZUNNrmiA+kqx1DLRkjWvZ/8XscEbCdcv+UzNqDQCG8QLBX8jdBd7m2zWtp/i/VTh47OoxD4Wk1Yc+/rsnuZLac58EQxG36wsI67KM=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8137.eurprd04.prod.outlook.com (2603:10a6:10:244::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Thu, 27 May
 2021 12:10:47 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4150.027; Thu, 27 May 2021
 12:10:47 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V1 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Topic: [PATCH V1 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Index: AQHXUvDdAkrP6ejNDkGcbE4OJnlbKqr3PELA
Date:   Thu, 27 May 2021 12:10:47 +0000
Message-ID: <DB8PR04MB679585D9D94C0D5D90003ED2E6239@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210527120722.16965-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210527120722.16965-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1c5d390-81ae-4ff5-f42c-08d9210875f5
x-ms-traffictypediagnostic: DB9PR04MB8137:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB9PR04MB813766A584CACD55C04AD925E6239@DB9PR04MB8137.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bgV0G1KjeJxrCGm+E2y6tWZNngEvJd67QFSosG+nyyoWQPOAU5N3qGbAM6eJ4bLQssp81JJ1zcWd3Qwd6TpHV61cm46+RvhsZJSHz3gbJV5fffCov0sMADdHZoWb4PY2Uf7SuknEcLlk5c6ol9Z9YnUt+Vws1ROfEsEG89NajfXkuMaDkCV6kXYiYgyjhd8JMHiaPKN8owqt859awpWWaLmSh3Rk48DFPj/Eh3y7VzXjuFZGMbmXt9SQuDBCmUEp0z5DlfjP1pZEf2fWaSKlsPEuC2f1Dv/W3FQfKFFOaCoylatjM8nPm3k/gm/qLZet2K87LlghSPzbmu/c6kEBtYJUEf11xI8IWWAzd3BrL/ROFd9LAO8YEdDWFWlTeYi1i5/8lh3rimoX+i3X5pq/8+YPvdyB9MJ+TflHD1D8xzF0BwovquNLRE+n+y79RoKy9aleN4Y8CJANZCqVN0G8YgbmgzKmhzQbuF4satWHe0xfcc51/4dOG524xP7cOQ6/bnAV8Rhv9TjGEOwJZsITEftuLyE9qVKV2wqRL8CLjrQ8/RAtDg3Z8s9xtUR8OV/glOtSwxwRVqttKaDWVwKAA3Cd8XKlpwiX43MUQY3p8wvHb9/Uh4Jgazkrd7UfGdRqEfErtROB/APxi6ymCLKBCyBMf2Oz76DJmCm+8xrkpNhAKcMiMFjUpyd7vBFHOQTLn1Eda0KROelxKFi+zhOYQaFoeeG9gxm63EX7m+eka2Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(376002)(346002)(366004)(66946007)(55016002)(2906002)(122000001)(86362001)(66476007)(52536014)(4326008)(54906003)(76116006)(83380400001)(38100700002)(8936002)(316002)(110136005)(64756008)(53546011)(9686003)(186003)(66446008)(26005)(6506007)(71200400001)(33656002)(478600001)(5660300002)(7696005)(8676002)(66556008)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?RC9PV216RUNtMWw0MVZCV3NRZ2l5aWMyMzIzbXV5eng1dC9YWXBZdFZCMFha?=
 =?gb2312?B?RXUzWFdrVHJtcE1ZZ21nbVFpenRVRm9nT3FXYTFwRUJrOUVkc2Q2eWpweFpH?=
 =?gb2312?B?Kzc4WEtXam0zWW9kYW5uU3RuOExJdjM3aUljajNvQXg3dHRiN0dqWEt6MnAz?=
 =?gb2312?B?TXhvbksvMjUrWXN6R2FNTVlxOFNlc3N4RUxPMHFNckZta0pRK1k0Zk51UlNN?=
 =?gb2312?B?ZDVVemxKellqQy9KcFVXNHNqdml5eEFlSVdGdjdVUGdMVVB4N3NEKzJLZ0VX?=
 =?gb2312?B?MktISzcvZ3RHS1ltUXNDOGM1THZZRTE2eUZ1QUNwSy9MaGFqSE0zVXIwbk9M?=
 =?gb2312?B?OFc2ZFNoenBQSjUwSHpSZTl6NjhnczJnZm8yMndIZStzS0RFSWg3bnVSb1Q2?=
 =?gb2312?B?MmNTVVNHL012ZDhpTlNsRWkwdmgxTVN5b0Q0Ui9Eb2RVeDRyN3dzU0o0SWhI?=
 =?gb2312?B?MzQzaGZPbnIxOE1DelZDUGxZWXU1bkRlVmYySmMzRUltVy9jalh0cmFrdkkr?=
 =?gb2312?B?YjRZeGNsZkZ4TFcrY0pxWm0xSTE0bzIzRWo3TUVaZGpTb1FsWDR5SGowY1Ez?=
 =?gb2312?B?WXF4WGY4YjBaR1FJZFh2Kzl3SWJxZVlRa2JhN1RTK0NOUkNSbWRBbDMwVFMz?=
 =?gb2312?B?dW0weWpYWkxncmtlYlExSUZ5SlpVQ0ZQRXNRL2hYQjBLNnVYeS9BUzZGOHBL?=
 =?gb2312?B?ajU5a0xEN0hLVGc5cXMvYXVFbFlVcVpTYmpvMHV1bVFKcThKVFcxNW9pUzFz?=
 =?gb2312?B?L085MHhSMUF3S3piOW5KRGVObWJacWE4VVdYZDRaUk5ocG84MFh1cEM0M0dz?=
 =?gb2312?B?QnVZbjJwUDA3aUNDYlh1N2pRVWNkRy9zYnBWSytSN3RxMzB5QmM3VmxWbXpl?=
 =?gb2312?B?VXNLLzQweGdFTU5lZzVyQ1dhZ2ltVWhyTGVhckp2d3NyNlUyLzFwS0lMeGtm?=
 =?gb2312?B?MDVaMnZuQ0dzUXd0bjhLSjFlaURQNHpBQ0VaWkUxMHVFSlM5aGJCNzZkdERK?=
 =?gb2312?B?T1hRRDJGSlZ3ek5mREtTUWFQUDVubHFZdGlpU3ZDb0NsMHBxTWp3YkpiOE9q?=
 =?gb2312?B?UGJyeUd4UmY4VFRvUWszay8vVkFKK1V3MDVJTkM1NnFZdkNpcHdSRnFuR0Jy?=
 =?gb2312?B?V0hwaElMdWZKd3NQcWg5REhuMVRZb0lSK0x4VDQ2NHdwUnBId2d4U1kwUDh4?=
 =?gb2312?B?WVRDWW0yK1h1dldUWjJwNjNscm8vSEg4ZWx3T1JEVTA5cjJOV3N3WDJkTmNa?=
 =?gb2312?B?aFVaS0JzaUh4dTFkbzAxcW1sL0g0VGRjRmZqclhBRnZKSnR5Z3FWR1FuYVg4?=
 =?gb2312?B?V296NllrMks3L29FdUJYdUV6dERsbFZSWVQ1QThHK3ZlWUlZQkRSUmNtUmxz?=
 =?gb2312?B?UDhvSTJOZ0tPZVRBbkRVc2FkZHA3cGNmWTF5UzEySnFjMHc0UkNtVEJ5bzFN?=
 =?gb2312?B?UVBTUUFSTlVmbkk4cFY4ZFVxWkFNSEh1QXM5UXNUQTZzbHM5UGltd2ZpR2xv?=
 =?gb2312?B?R0NuMGNQRHZpTGVWSnV1ZEM0TnlYcUtrdTZMSUpTVVAxcGQ2UVV3ZThWYXUx?=
 =?gb2312?B?Rm9PR21yS0ZCYThNNHRSY1RBb1oySUdVa2pGR0E3OEpXNFg5VUhtQzJ6d0xI?=
 =?gb2312?B?UHhjOGI1clZWZnVsbTNRNFhLaWdBbkJuK3pCc1pNYUYzNThacEN3azdEaE9V?=
 =?gb2312?B?VzJBM1IzS2xZVTlTT2dacmRSa1h1RkRIQWpDTHl6OXZnbUFNV0c3ME51bHJF?=
 =?gb2312?Q?yhlh0ANR/brXaGajDM=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1c5d390-81ae-4ff5-f42c-08d9210875f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2021 12:10:47.0620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y93qESMbWjGjplOTRqzZvV/hVcWB47diRXaQncAHWaSp13zYfKN4yqFwUiJz6+6CN5B70JzyiOnnqN6xEwOQEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGcmllZGVyLA0KDQpBcyB3ZSB0YWxrZWQgYmVmb3JlLCBjb3VsZCB5b3UgcGxlYXNlIGhl
bHAgdGVzdCB0aGUgcGF0Y2hlcyB3aGVuIHlvdSBhcmUgZnJlZT8gVGhhbmtzLg0KDQpCZXN0IFJl
Z2FyZHMsDQpKb2FraW0gWmhhbmcNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBG
cm9tOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBTZW50OiAyMDIx
xOo11MIyN8jVIDIwOjA3DQo+IFRvOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5v
cmc7IGZyaWVkZXIuc2NocmVtcGZAa29udHJvbi5kZTsNCj4gYW5kcmV3QGx1bm4uY2gNCj4gQ2M6
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGRs
LWxpbnV4LWlteA0KPiA8bGludXgtaW14QG54cC5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCBWMSBu
ZXQtbmV4dCAwLzJdIG5ldDogZmVjOiBmaXggVFggYmFuZHdpZHRoIGZsdWN0dWF0aW9ucw0KPiAN
Cj4gVGhpcyBwYXRjaCBzZXQgaW50ZW5kcyB0byBmaXggVFggYmFuZHdpZHRoIGZsdWN0dWF0aW9u
cywgYW55IGZlZWRiYWNrIHdvdWxkIGJlDQo+IGFwcHJlY2lhdGVkLg0KPiANCj4gLS0tDQo+IENo
YW5nZUxvZ3M6DQo+IAlWMTogcmVtb3ZlIFJGQyB0YWcsIFJGQyBkaXNjdXNzaW9ucyBwbGVhc2Ug
dHVybiB0byBiZWxvdzoNCj4gCSAgICBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL1lLMENl
NVl4UjJXWWJyQW9AbHVubi5jaC9ULw0KPiANCj4gRnVnYW5nIER1YW4gKDEpOg0KPiAgIG5ldDog
ZmVjOiBhZGQgbmRvX3NlbGVjdF9xdWV1ZSB0byBmaXggVFggYmFuZHdpZHRoIGZsdWN0dWF0aW9u
cw0KPiANCj4gSm9ha2ltIFpoYW5nICgxKToNCj4gICBuZXQ6IGZlYzogYWRkIEZFQ19RVUlSS19I
QVNfTVVMVElfUVVFVUVTIHJlcHJlc2VudHMgaS5NWDZTWCBFTkVUIElQDQo+IA0KPiAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlYy5oICAgICAgfCAgNSArKysNCj4gIGRyaXZlcnMv
bmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jIHwgNDMgKysrKysrKysrKysrKysrKysr
KystLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgNDMgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMo
LSkNCj4gDQo+IC0tDQo+IDIuMTcuMQ0KDQo=
