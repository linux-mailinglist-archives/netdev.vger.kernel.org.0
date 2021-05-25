Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A917C38FE0F
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 11:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbhEYJqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 05:46:33 -0400
Received: from mail-am6eur05on2061.outbound.protection.outlook.com ([40.107.22.61]:29792
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230508AbhEYJq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 05:46:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNAsJ0tJrUqMJ/6WWhKXLCrt2T63H723yYgWs4u0PKrhkqF+SOmLzCocZORIz6uRbITJ3KyXFIm1c2NNDQ9ZXP2HF/MnutIrFb1VppkUkVqO4DhixONXTg6cqaeYD65ey9Hs0sNREq04AFNt/qBKGqV03i7e3iCMObR0b2napD/2eP/Ie2gn/8LkPg48lsBg9knMc4Nbpw3YWBD5obDOhom9iBL7Uw6pQyqQ/qSF5ouwDDfScHUWAeIU73ZBT+sgYUfnpyKKj1Lxy1iAa3BmW+qhqO1PUcl/BDHUUo/0RZDa0I8r2F71d+f6Ar3u44GY2fqNg2Jw5Zj/nildLmVbLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+AVZTBwuFxYWljwn1yQFtQuFW+WuoERnPqHWFgqi2p4=;
 b=hNS4pXsIGervDz2ZDI5ojhAj1H04xXcbpl+Hq9N8bP+GX6Sv9y4Mwkvf8bA/LqzIP0J/L3Rj8DvlhbCZgHAShlM2Izu9TrEriIt7/h4oV28ThlWKwRjg24lFgJv1XXDUfy7VpayKm2MTjOcY8drQyRBa8D0AXO2nwYFsKDD4+1PDMrb11h0TSLRl0QizdnjfdnllXRDvfmU7vjzGD4/sZMcPn7+xAhdpRNlgrft24+bLVOUkAsJRdKqS7ZxTzdSXENuomdThAOBLyamqUyJbP/g/nOazU7hg5kd79YPA5VZZv9Or4Gh88ExLDMBIiFxyRdN1XHKGr7uaqpfKOdOaQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+AVZTBwuFxYWljwn1yQFtQuFW+WuoERnPqHWFgqi2p4=;
 b=XhTeiSX+1MTKRfFAGNDfvthI1pJiUfvnyjPdsW5hUkbJ1tUxL46Ox8cSol6zCpodOF5UhixKZTJwUnPKrpxgW8CA3gDl2tGzQ97DKjn5Z77DaPs9lRzyBJzmivhN9dzZVr1TM4wUGPTIMMadVCXNwhVSQGLFaBLcE3lv9CkdJh4=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7429.eurprd04.prod.outlook.com (2603:10a6:10:1a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 09:44:57 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 09:44:57 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [RFC net-next 2/2] net: fec: add ndo_select_queue to fix TX
 bandwidth fluctuations
Thread-Topic: [RFC net-next 2/2] net: fec: add ndo_select_queue to fix TX
 bandwidth fluctuations
Thread-Index: AQHXT708BKGTZN/11k693vD2JZ2LfqrxIzCAgAJks+A=
Date:   Tue, 25 May 2021 09:44:57 +0000
Message-ID: <DB8PR04MB67957D65A10E6E70C68E8D88E6259@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210523102019.29440-1-qiangqing.zhang@nxp.com>
 <20210523102019.29440-3-qiangqing.zhang@nxp.com> <YKpo9fs9lEqCOx9l@lunn.ch>
In-Reply-To: <YKpo9fs9lEqCOx9l@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8f8e3de-7fd5-4219-55cd-08d91f61c21d
x-ms-traffictypediagnostic: DBAPR04MB7429:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB74293FD895DA66FC7686C9C2E6259@DBAPR04MB7429.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ykjOZAVBphlsey523AqBaq/rYlwre0gvYJHqZCCvMSdgmy3sU6DogOzEgqd30f1KE6G3HpNWjL5dkR7b7gdwiYXog8baJjdcl3pmuITWDrdiahKBBJFeyLAtgGqvILQy9f42gb63oWDu5nt6FVffxf7mWDisNQFa2SrfCFOHNfWijqeC/eNbEwvJDPZvijU/i3zNxKhfh277ZgOcWa4Fr5fM2N5neD2+ttyvOMZYvK7qgFokSL4koewIPYHTg/L19iMVT9RVOm8uNOVlZw3y2/A8FgZK2KHvbK0W9HwbAPxK4yOnaMfCB0W37zF9nDETGLUHGE570j7b5h2BXcgzNNDONk8Ehv72EyxF06Qae7HcgC7G+LmzB9lZMoojQkjuh54ZJBAgytuZlMY09/2Oh2Gs+xDp9GGhxJyNRDNJLEql4HmQL6UG/jSjmJdwpCYsIeP1adG3i9w+1GMolGktx9JslaAYwr8vEM8zlmzQlBNyyO3GC/KhM5SPhV2DhOXHfIPHIMlUERqURpTZEfjnkgMfBTA6kzeZbIdF+Dg6uRv7l6cH8NPP7nWF8DRozkK6CgzNjy+FP6XPa1Gq3SGxHB2Tg64TaDR02zXPRzF4Zio=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39840400004)(136003)(396003)(376002)(76116006)(66556008)(66946007)(4326008)(66446008)(64756008)(66476007)(71200400001)(8676002)(6916009)(54906003)(33656002)(6506007)(5660300002)(38100700002)(86362001)(52536014)(4744005)(478600001)(83380400001)(122000001)(55016002)(9686003)(2906002)(7696005)(26005)(8936002)(186003)(316002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?WWdaeGZuN3hnR0FoKy9BbWE0QUJyWWxxYkZvTUFHQks0T2kzSVFGNnNpTW9w?=
 =?gb2312?B?ZWxpZWFwT21HK2liWE5iNGJhUlUwM0RiaFhKRXk4c0FJMk94cUVXQlNUUEdU?=
 =?gb2312?B?VE55Uk4yZUtaWXBOcUhzdm9YMmhLL0x2WFpEREpZY1JIYjh0WGlTczBXcjZI?=
 =?gb2312?B?ckEvTkZ5RU1NRHU5RUhac1VFNnpMblhFWjFPeVZ5SkV2SkMyQm5LalB5SnVG?=
 =?gb2312?B?SFJzeVdMVUtuVzBWMzNYeFFJd0hnKzZQRU9jbU1XeFZqNnNneFFRSVZrZW9J?=
 =?gb2312?B?blprOWpjVFd6b09OdG9CeHpObi9WeEsyRDI2cXMzTSttZlJIMEJiR2ZQR05o?=
 =?gb2312?B?QWVnVklUa3ZwUFJ6RkFUemQ1Nzl6QjdRRTJrU3RYS0o2UVVUUmZLTmN0ZE1o?=
 =?gb2312?B?SFQ2WFNDUmJPc281alJwYVdaMHpqTjAwWHFoT2dqOWM0Y1FPVVJWZXdRRWFq?=
 =?gb2312?B?b3JpVXkxblhsc3phMm5YUG5HRDZOYWVtdlFVREdoYTJ0M1JFL3lYbGhWMWs5?=
 =?gb2312?B?dmJQcGZXUmphejFkMWpBZmlSaDZIOUgxTE9qYlhLQXVDRHhDa3ZUd2RURmdI?=
 =?gb2312?B?R21MQTViN3paSnlxVldnOTkrejZyazFnaFNzMUk2M1RjOExJOVVvU1JSRWlQ?=
 =?gb2312?B?cTJ6bzAvTC9Ha2FNcXNRSmFNNTNYdUpSWTN0aGM4YlN0d1dseFRmUlovdVRw?=
 =?gb2312?B?c1MvUEtWWWZlZ1dwTW1rcHA1NERDeXZrVUZ6ZVh1R2orOXprbE10Rk1HdmFE?=
 =?gb2312?B?dHNoUU5nSGNUUXpyUklnQUZNSkttakE3UlA4OE9xUjB4V2ZaL2pxWjNDYTl2?=
 =?gb2312?B?dlZyTURLc2dJMEtVaU0rZDVpMjdmRytiZ3V6MHpYWHlLWllUWHd0VkVueUwv?=
 =?gb2312?B?U2lFUUFOVURzR2UzRGJiRjlrcUJoMVFCaUx3ZElvSnNHQitxRE9ORzQwRWZ1?=
 =?gb2312?B?alNqZ3VIV1BxU2dVNWlra0xwNThYWmk2eXpoc214eW04UEtyNFdUU3ZiRk1x?=
 =?gb2312?B?VUxwR1FabHdNNkZIbmliQklDREl0WEFzMWE5eUdWZ1JFY05YZWt3c3oxd0Zj?=
 =?gb2312?B?RnhobDZ2eFYxUU5RbzdrSUwyMVpsdzVZNng4NlhBUisyNGIyM1V4M2hpV1U2?=
 =?gb2312?B?dmdKVWdpc0tzbEtTUFc3QVpNZ3d3WEl6c2psOC9rQzl4TkZyK2JNaDdrWFYy?=
 =?gb2312?B?NEZ2UjNxVjdPSmhna29RYytpVkZTblY0bDFXWUl5b3Brc3IyMVNPZENrYkw5?=
 =?gb2312?B?NVRGK0JxZTM1aEhHL3AzeHpIRTRIcWV5WFYvUkVsRldacXl1S051SHlFYUYv?=
 =?gb2312?B?Z1I3S1k3bzdKSXBkdXlvdG5pcDh4R29rb3dRU3ZvVlRHb3BKQ1RDYTR5ZHh5?=
 =?gb2312?B?RkV3cHpmcmVJcWJEZ1BZNTlkRlRMeFNtclplQVcxdDBZbVVVcGdkc1R4d1Z2?=
 =?gb2312?B?QVc4cnZnSWc4RUNidGVyUFBMaCt1dlhiOXpKZEo5d2JTRkIrb3ZETnVLRHh4?=
 =?gb2312?B?ak9CMlM5Z3o5SHBaV3c1ZDFTYVlJeHJtVWZsRDJONDNIOWlZWW9pMWNVZ2ZX?=
 =?gb2312?B?TVlZYWlhSCs3bWkwSlBmTVdGdkRTYUU4NWYxK0c0N0VlS1VseW5rUmp2TXN1?=
 =?gb2312?B?djBJZ0Y3dGRrMUVibjFkYktDS1dibEVrNWlEZmZlbTNCbkw5YVRnTEhhajY5?=
 =?gb2312?B?Y3RWZk1DYnRzY2c5QWRkYnY2bWlGUmgvNWNXNWNGM0FqZncraE1YMW5LWmk2?=
 =?gb2312?Q?m9OL47UYUFF7+6c54z8D1AKBE5P7kgdlOH6KFrk?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f8e3de-7fd5-4219-55cd-08d91f61c21d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 09:44:57.7352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 03/IQga+aKGjDiQUQ/nG8zELh15RZYTmvdKDQIiwGyhLQKG1mvv3Wf1KmjOCCHV7wSTJYPrkrytHolTKBXwrFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7429
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbmRyZXcsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5k
cmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIxxOo11MIyM8jVIDIyOjM5DQo+
IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogZGF2ZW1A
ZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBmcmllZGVyLnNjaHJlbXBmQGtvbnRyb24u
ZGU7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IGRsLWxpbnV4LWlteA0KPiA8bGludXgtaW14QG54cC5jb20+DQo+IFN1YmplY3Q6IFJlOiBb
UkZDIG5ldC1uZXh0IDIvMl0gbmV0OiBmZWM6IGFkZCBuZG9fc2VsZWN0X3F1ZXVlIHRvIGZpeCBU
WA0KPiBiYW5kd2lkdGggZmx1Y3R1YXRpb25zDQo+IA0KPiA+IEBAIC03Niw2ICs3Niw4IEBAIHN0
YXRpYyB2b2lkIGZlY19lbmV0X2l0cl9jb2FsX2luaXQoc3RydWN0IG5ldF9kZXZpY2UNCj4gKm5k
ZXYpOw0KPiA+DQo+ID4gICNkZWZpbmUgRFJJVkVSX05BTUUJImZlYyINCj4gPg0KPiA+ICtzdGF0
aWMgY29uc3QgdTE2IGZlY19lbmV0X3ZsYW5fcHJpX3RvX3F1ZXVlWzhdID0gezEsIDEsIDEsIDEs
IDIsIDIsIDIsIDJ9Ow0KPiANCj4gSSB3b25kZXIgaWYgcHJpb3JpdHkgMCBzaG91bGQgYmUgc2Vu
dCB0byBxdWV1ZSAwPw0KDQpZZXMsIHdlIGNhbi4gQnV0IHRoZSBvcmlnaW5hbCB0aG91Z2h0IG9m
IGF1dGhvciBzZWVtcyB0bywgVkxBTiB0YWdnZWQgcGFja2V0cyBvbmx5IHVzZSBxdWV1ZSAxJjIs
IGFuZCBxdWV1ZSAwaXMgcmVzZXJ2ZWQgZm9yIFZMQU4gdW50YWdnZWQgcGFja2V0cy4NCg0KQmVz
dCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+ICAgQW5kcmV3DQo=
