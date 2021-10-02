Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7A641FA5D
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 09:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbhJBHzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 03:55:19 -0400
Received: from mail-eopbgr1410127.outbound.protection.outlook.com ([40.107.141.127]:53184
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232457AbhJBHzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 03:55:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMtBN3CX3UzbQ3v83Vm4SjU0w+bFrgL0dS5al/uDtCx0nrwiyB2ESDx1RAEWGo6nzxKWNCHI+7FR2WPIEzsmozcFRU3obOanJXyWQKbn/hOp9JYaiCaj9UwZEA3Qeuv5OX4R9MoZig7q+S085Ias4HcQSzjLBY31KKPH5m+sc+885cnCplR5Jjr3AZA2SpVvcvcLEJoyCRybR5JdjviA2ijVA2PfdCzck6+qZDaqYwl6sS59aR1wBW3Cdq0bMnFgu6wYiRxgsYCYlOo9DaWL0WrkPtuMyit7MJ5p6OZv9HxyS8XbYFEK8QcXIIx190W4qn0xLTKaSKuO2x06EeGlGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYa3O66iYAnQMkrqt+WTAJSGvKOoSq0qKPwwPZKrbPQ=;
 b=HPyL761mOqHeQv58QyAu7PskJgOGgw78JJoCzm1vbgsnoRIgh8cFuF1V6t6wXDsuUR01Mw+Q2I3/5lEOnZk1iwAo8N57Fm+EYZsIbbLfXimhlEqg+3Um/Lu/QR+0bf8MJT3GQUBIoKRJaIdP4TlXHDmQGegMJR7wOHwHgcCdzz8N4Pd/Pvt/rbqkJ9e4x1HZVUGRPzWs7xTNjQJHCXTN7N9rlh4lsa8qLVBPnfRobe96EV2yBTE6A71xwIF8dVq23M49hrxMrdOpVmrIk9+JfESwibkbswjR6XckA3cI9cHjpLp19eqWHIVDMe9Ld3MkNNhdft1god98mi0JqNUGdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYa3O66iYAnQMkrqt+WTAJSGvKOoSq0qKPwwPZKrbPQ=;
 b=LLnU6toAFaOHF8Oh0h/VmydDRyJtpKdLwteC0YNJ6HJPETX3ycA8iRPaPOCZCBnflv7C7PW2Z2fGrMlzfaTk21hZj75E2N5/sTDuYQSc9F5Jnf291KY06Eaxzm99cNoPzhV82MM7QpovkOjy4r5n6qp45EpAqG7GdKjBgy8zQPg=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB4694.jpnprd01.prod.outlook.com (2603:1096:604:79::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Sat, 2 Oct
 2021 07:53:30 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4566.015; Sat, 2 Oct 2021
 07:53:30 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH 02/10] ravb: Rename "no_ptp_cfg_active" and
 "ptp_cfg_active" variables
Thread-Topic: [PATCH 02/10] ravb: Rename "no_ptp_cfg_active" and
 "ptp_cfg_active" variables
Thread-Index: AQHXttX2biYCMslwJE+yxvVmFxGPZ6u+nEeAgAC0NnA=
Date:   Sat, 2 Oct 2021 07:53:30 +0000
Message-ID: <OS0PR01MB59225BB8DF5AE4811158563786AC9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
 <20211001150636.7500-3-biju.das.jz@bp.renesas.com>
 <232c6ad6-c35b-76c0-2800-e05ca2631048@omp.ru>
In-Reply-To: <232c6ad6-c35b-76c0-2800-e05ca2631048@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ad7ce75-3574-4bf2-4720-08d98579b9ee
x-ms-traffictypediagnostic: OSBPR01MB4694:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB469463FC52DDFA2AC640329186AC9@OSBPR01MB4694.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y79vuQvrrBmD/wySFKwKwqsfDnCEyvahtUTmDIuZBgGBIBORVatg65I2o9PmZkkYXzPUB2IBxSJxpqWeoY+PWhIFfYDay0LCVeVGxQ5CFmmAOxG2edpV9r7vH8DP7fMUg9BufFsAzqEls0DtMGN4fRadigS6Fq8d33i3vC047hZYVKlU1PjsBl8hpGML8D6l2fES4wVz5XwZozbiEHWpP1nvJaysPwp51SgPJ2LTb7lRGlX0Q7DV3/DcaeYSw+NEIGSXakHMeIvoRbfpF1fbPMiiIGiXfKstceBMUKWvIDONv4pWpqHuvybvPjAX3I9TjjRAEcZ+g9DOWhIZl+e8HH5QNmjMl45EScrvlw8t91Z4FiRtVMLy2pOTfkTBTXI9PQZ9t4yp3oFTTWEqMIEItziSouYxOJItnVyDIUheSFl+Ox5ehTkTIGJGndLJO/ZoNu7kb3zSg/P6pk0v2ja5rbs1xwoMTY//5CEaQ4wfY8pH5cO0aaKCBBVFu0/lWSHqqI23Bgrvg+6dGJIT4Vdu5AkCkkk9fRUfZAdqVaNjeL//3IgjuJjeBo1tou1wqUwJN6M8wX2vpR9P43s6chHD7+Aq7FK83zhs0gV2w549b3+82Jq51iXhfFLqCevAXI1zxtHqI5tfo92ot9NF7VI8C1IT4mqJCGXrPBcDiGVe5rYtM/FmWGLhxnJmD6jaWPkKWwd/YiR9+/dvhF7WxN5B4hr7twzA3CjJoqROiZW6zMi4SPPJPhah8IbglHX5dcDfQauQTx+hM58r5Lo8Iw5yR99ht+zknOn1Ih8B6/HT55Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(52536014)(26005)(7696005)(5660300002)(6506007)(54906003)(316002)(8936002)(186003)(71200400001)(966005)(9686003)(110136005)(83380400001)(8676002)(53546011)(107886003)(4326008)(76116006)(86362001)(38070700005)(66446008)(33656002)(508600001)(66556008)(2906002)(38100700002)(122000001)(64756008)(55016002)(66476007)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDlvemtZQzhveVNnbytGVU05R3ZuRFUwVnZvSFdlU3JXMXJxaWxRczh2MnBB?=
 =?utf-8?B?NFd5MW5LVGtERDlPOUR5SVlxbjA3YVhuMjlPbXBWSmNsQTJpT2FOeFRVem16?=
 =?utf-8?B?UkdZSkl3WXBXb1kxaS85b21DOWp5Yy9MazNTdW9ONE45SUhheERVT2EzSXdh?=
 =?utf-8?B?ZUVGYXFqOXl6NkdZSEk4a0pVRWtGVmV4MHprb0NyNHdQZXhCUXJtcGVtSnYz?=
 =?utf-8?B?dmJ0d0dYdU5Xd01SQnRwMWovVmZSVlBHcmRmWSttalJ1d0F1MlYyRG00YmJt?=
 =?utf-8?B?NmQ0MkpRV29YWEtOcG96VW5waDREZzdFTEc5Z2dBaHUraFYzcDRJRHRlc0JB?=
 =?utf-8?B?amkrRG9kdGpOSktiWldGczZLWDhHMjJMazgxRzRMdnF1b0VKYWVWY0N0QWlz?=
 =?utf-8?B?RHU4YnFRUjYyd0hXcW10ZUhWNVNlRThrQTNsUmdjZ1R3RUdHMngxVFAxSjhR?=
 =?utf-8?B?d0Zza2Z0UDNtT2YxWlFoQVlxQlFrazVKSUJCTjh5RXd0NmFXOCtMa1hvSUN5?=
 =?utf-8?B?Y0tNL3JTK0VMbjQxWnRWdEIxVS9VNnJ0L2dyTEYxb1ZDUFlSU2VsTHVvS3pX?=
 =?utf-8?B?L2VwWUlKSGxYL0RpeEZBTnRzbW5ENmpoRjZqeGZndG5wRkwyeW00R1FwMlpD?=
 =?utf-8?B?UDdTOTd1cGo4Rkg3OUpBMXF0Z01oTVNpNU5Zck5xUXQwQXJ0SjhoeVNzZ2or?=
 =?utf-8?B?K2JNdlk2blo1Rkhic0Rwa1RmcVdhRGZ0cXVhbmtZWWxjQ2YxRERGSk9xbGdr?=
 =?utf-8?B?OGJFeW9pQ3dsUys4YXU0eTNGMVNqUHA5V2lXWFBmZlE4emhlNlZMOFpmU1pP?=
 =?utf-8?B?WGVVTGxKbVptMGxGZmV3Zkp2Y0ZTVFQ0bUNFWXZsM0tES0xObDg3WFZuRlhQ?=
 =?utf-8?B?MW9kd1NaM25SblpWK1lHa3VKeC9pNGdLWkFGbkdwWGNZaUpQTExGTzV2dWZx?=
 =?utf-8?B?Z0Z2YzRoblZMTHJIYlRQWHUvU0tUUzV6SlBzVUlORHhnRjhzMncyK1J2ekZK?=
 =?utf-8?B?K3FoV3YxM0pEOXNQZU4yZ0Zsb3B6UWF6aGhqYVdjTlYxU3h1Qm9hVjg2TWRq?=
 =?utf-8?B?dDQ2NTFLTHRzRjA1eFpRVWFqQjlPVS84bXRqdEdQZlRUanRaenlnTkppZGpz?=
 =?utf-8?B?TE96T1B2YzBvMC9IdmZpb2ZPTFhlYzhFNEcvTWkwOXFPbyt6V0JDQXhUYXJp?=
 =?utf-8?B?VGMwQ2QvQ2ZmelJ5Q04vYlhvcHZqbldyZjlwVlh0bXprMDhDZzhMVk9uMDg5?=
 =?utf-8?B?R2luMmdaQ3BsRVFiaVBsSkZHaFRrM1RwbVBHQmw5OWVEcjBrclQ1Q29qSUxa?=
 =?utf-8?B?SmM2djd1czJUemMxY1V5aFNzTUxiNzhaSi9WamRhaDBBdFRUMWdSQWhSS1lW?=
 =?utf-8?B?QWE0N3dMenZYcW1vTGJzU0RwVE9LYy9maUU5b3ZKRlJvNVZ1TGF4cXNaWG5N?=
 =?utf-8?B?clJ6di9obDNiWThMbTVSelp4RG50U3FraWZLYVJhdjM1RXJRcUN2blU0QXZT?=
 =?utf-8?B?bzNJVG5yMEhERTF1ZWZtdFFVQjIxbzg0RVFjWmhMaEVGWWhHZURuSjdEOWpI?=
 =?utf-8?B?YjlTSzB0QUxVSjRQTmUvcjI4b3JhcmV1OGRUejBnTG91TTVOVjlGN2ovZjdi?=
 =?utf-8?B?bitOdnY5K2JoeVZjSjV6ZXNyQU5kdlBQSnk5emlmdmg3aGRQM2gvMkRmNmdp?=
 =?utf-8?B?dWNDTEtucVc4ckJRZ2daVVdxL2JXVk5ndFlXSFNSb09lYm9KMG8wMVdVY0hX?=
 =?utf-8?Q?ay2bB2s/FoFK3uxyi4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad7ce75-3574-4bf2-4720-08d98579b9ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2021 07:53:30.1714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f/SvISUMQPC0VxsCzB/dcZOWA3SkfwnGqmGfrM+VPnMeB758nJ/FbNzxHwGny65MYublwGwK7gPALpH59O6SbRgzx2u4vbwtUYLcSLTgh0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4694
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMDIvMTBdIHJhdmI6IFJlbmFtZSAi
bm9fcHRwX2NmZ19hY3RpdmUiIGFuZA0KPiAicHRwX2NmZ19hY3RpdmUiIHZhcmlhYmxlcw0KPiAN
Cj4gT24gMTAvMS8yMSA2OjA2IFBNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4gUmVuYW1lIHRo
ZSB2YXJpYWJsZSAibm9fcHRwX2NmZ19hY3RpdmUiIHdpdGggImdwdHAiIGFuZA0KPiANCj4gICAg
VGhpcyBzaG91bGRuJ3QgYmUgYSByZW5hbWUgYnV0IHRoZSBleHRlbnNpb24gb2YgdGhlIG1lYW5p
bmcgaW5zdGVhZC4uLg0KDQpUaGlzIGlzIHRoZSBvcmlnaW5hbCBwdHAgc3VwcG9ydCBmb3IgYm90
aCBSLUNhciBHZW4zIGFuZCBSLUNhciBHZW4yIHdpdGhvdXQgY29uZmlnIGluIGFjdGl2ZSBtb2Rl
LiBMYXRlciB3ZSBhZGRlZCBmZWF0dXJlIHN1cHBvcnQgYWN0aXZlIGluIGNvbmZpZyBtb2RlIGZv
ciBSLUNhciBHZW4zIGJ5IHBhdGNoWzFdLg0KWzFdIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9jb21taXQvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYz9oPXY1LjE1LXJjMyZpZD1mNWQ3ODM3Zjk2
ZTUzYThjOWI2YzQ5ZTFiYzk1Y2YwYWU4OGI5OWU4DQoNCj4gDQo+ID4gInB0cF9jZmdfYWN0aXZl
IiB3aXRoICJjY2NfZ2FjIiB0byBtYXRjaCB0aGUgSFcgZmVhdHVyZXMuDQo+ID4NCj4gPiBUaGVy
ZSBpcyBubyBmdW5jdGlvbmFsIGNoYW5nZS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUg
RGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiBTdWdnZXN0ZWQtYnk6IFNlcmdl
eSBTaHR5bHlvdiA8cy5zaHR5bHlvdkBvbXAucnU+DQo+ID4gUmV2aWV3ZWQtYnk6IExhZCBQcmFi
aGFrYXIgPHByYWJoYWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT4NCj4gPiAtLS0N
Cj4gPiBSRmMtPnYxOg0KPiA+ICAqIFJlbmFtZWQgdGhlIHZhcmlhYmxlICJub19wdHBfY2ZnX2Fj
dGl2ZSIgd2l0aCAiZ3B0cCIgYW5kDQo+ID4gICAgInB0cF9jZmdfYWN0aXZlIiB3aXRoICJjY2Nf
Z2FjDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAg
ICAgfCAgNCArKy0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWlu
LmMgfCAyNg0KPiA+ICsrKysrKysrKysrKy0tLS0tLS0tLS0tLQ0KPiA+ICAyIGZpbGVzIGNoYW5n
ZWQsIDE1IGluc2VydGlvbnMoKyksIDE1IGRlbGV0aW9ucygtKQ0KPiANCj4gWy4uLl0NCj4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGluZGV4IDhm
MjM1OGNhZWYzNC4uZGM3NjU0YWJmZTU1IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gQEAgLTEyNzQsNyArMTI3NCw3IEBAIHN0YXRpYyBp
bnQgcmF2Yl9zZXRfcmluZ3BhcmFtKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpuZGV2LA0KPiA+ICAJ
aWYgKG5ldGlmX3J1bm5pbmcobmRldikpIHsNCj4gPiAgCQluZXRpZl9kZXZpY2VfZGV0YWNoKG5k
ZXYpOw0KPiA+ICAJCS8qIFN0b3AgUFRQIENsb2NrIGRyaXZlciAqLw0KPiA+IC0JCWlmIChpbmZv
LT5ub19wdHBfY2ZnX2FjdGl2ZSkNCj4gPiArCQlpZiAoaW5mby0+Z3B0cCkNCj4gDQo+ICAgIFdo
ZXJlIGhhdmUgeW91IGxvc3QgIWluZm8tPmNjY19nYWM/DQoNCiAgQXMgcGVyIHBhdGNoWzFdLCB0
aGUgY2hlY2sgaXMgZm9yIFItQ2FyIEdlbjIuIFdoeSBkbyB5b3UgbmVlZCBhZGRpdGlvbmFsIGNo
ZWNrDQphcyBwZXIgdGhlIGN1cnJlbnQgZHJpdmVyPyANCg0KSSBzZWUgYmVsb3cgeW91IGFyZSBw
cm9wb3NpbmcgdG8gZW5hYmxlIGJvdGggImdwdHAiIGFuZCAiY2NjX2dhYyIgZm9yIFItQ2FyIEdl
bjMsIEFjY29yZGluZyB0byBtZSBpdCBpcyBhIGZlYXR1cmUgaW1wcm92ZW1lbnQgZm9yIFItQ2Fy
IEdlbjMgaW4gd2hpY2gsIHlvdSBjYW4gaGF2ZQ0KDQoxKSBnUFRQIHN1cHBvcnQgYWN0aXZlIGlu
IGNvbmZpZyBtb2RlDQoyKSBnUFRQIHN1cHBvcnQgbm90IGFjdGl2ZSBpbiBjb25maWcgbW9kZQ0K
DQpCdXQgdGhlIGV4aXN0aW5nIGRyaXZlciBjb2RlIGp1c3Qgc3VwcG9ydCAiZ1BUUCBzdXBwb3J0
IGFjdGl2ZSBpbiBjb25maWcgbW9kZSIgZm9yIFItQ2FyIEdlbjMuDQoNCkRvIHlvdSB3YW50IG1l
IHRvIGRvIGZlYXR1cmUgaW1wcm92ZW1lbnQgYXMgd2VsbCwgYXMgcGFydCBvZiBHYmV0aGVybmV0
IHN1cHBvcnQ/DQoNClBsZWFzZSBsZXQgbWUga25vdyB5b3VyIHRob3VnaHRzLg0KDQpUaGUgc2Ft
ZSBjb21tZW50cyBhcHBsaWVzIHRvIGFsbCB0aGUgY29tbWVudHMgeW91IGhhdmUgbWVudGlvbmVk
IGJlbG93Lg0KDQpSZWdhcmRzLA0KQmlqdQ0KDQoNCg0KPiANCj4gPiAgCQkJcmF2Yl9wdHBfc3Rv
cChuZGV2KTsNCj4gPiAgCQkvKiBXYWl0IGZvciBETUEgc3RvcHBpbmcgKi8NCj4gPiAgCQllcnJv
ciA9IHJhdmJfc3RvcF9kbWEobmRldik7DQo+ID4gQEAgLTEzMDYsNyArMTMwNiw3IEBAIHN0YXRp
YyBpbnQgcmF2Yl9zZXRfcmluZ3BhcmFtKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpuZGV2LA0KPiA+
ICAJCXJhdmJfZW1hY19pbml0KG5kZXYpOw0KPiA+DQo+ID4gIAkJLyogSW5pdGlhbGlzZSBQVFAg
Q2xvY2sgZHJpdmVyICovDQo+ID4gLQkJaWYgKGluZm8tPm5vX3B0cF9jZmdfYWN0aXZlKQ0KPiA+
ICsJCWlmIChpbmZvLT5ncHRwKQ0KPiA+ICAJCQlyYXZiX3B0cF9pbml0KG5kZXYsIHByaXYtPnBk
ZXYpOw0KPiANCj4gICAgIFRoZSBzYW1lIHF1ZXN0aW9uIGhlcmUuLi4NCj4gDQo+ID4gIAkJbmV0
aWZfZGV2aWNlX2F0dGFjaChuZGV2KTsNCj4gPiBAQCAtMTQ0Niw3ICsxNDQ2LDcgQEAgc3RhdGlj
IGludCByYXZiX29wZW4oc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYpDQo+ID4gIAlyYXZiX2VtYWNf
aW5pdChuZGV2KTsNCj4gPg0KPiA+ICAJLyogSW5pdGlhbGlzZSBQVFAgQ2xvY2sgZHJpdmVyICov
DQo+ID4gLQlpZiAoaW5mby0+bm9fcHRwX2NmZ19hY3RpdmUpDQo+ID4gKwlpZiAoaW5mby0+Z3B0
cCkNCj4gDQo+ICAgIC4uLiBhbmQgaGVyZS4NCj4gDQo+ID4gIAkJcmF2Yl9wdHBfaW5pdChuZGV2
LCBwcml2LT5wZGV2KTsNCj4gPg0KPiA+ICAJbmV0aWZfdHhfc3RhcnRfYWxsX3F1ZXVlcyhuZGV2
KTsNCj4gPiBAQCAtMTQ2MCw3ICsxNDYwLDcgQEAgc3RhdGljIGludCByYXZiX29wZW4oc3RydWN0
IG5ldF9kZXZpY2UgKm5kZXYpDQo+ID4NCj4gPiAgb3V0X3B0cF9zdG9wOg0KPiA+ICAJLyogU3Rv
cCBQVFAgQ2xvY2sgZHJpdmVyICovDQo+ID4gLQlpZiAoaW5mby0+bm9fcHRwX2NmZ19hY3RpdmUp
DQo+ID4gKwlpZiAoaW5mby0+Z3B0cCkNCj4gPiAgCQlyYXZiX3B0cF9zdG9wKG5kZXYpOw0KPiAN
Cj4gICAgIC4uLiBhbmQgaGVyZS4NCj4gDQo+ID4gIG91dF9mcmVlX2lycV9uY190eDoNCj4gPiAg
CWlmICghaW5mby0+bXVsdGlfaXJxcykNCj4gPiBAQCAtMTUwOCw3ICsxNTA4LDcgQEAgc3RhdGlj
IHZvaWQgcmF2Yl90eF90aW1lb3V0X3dvcmsoc3RydWN0DQo+IHdvcmtfc3RydWN0ICp3b3JrKQ0K
PiA+ICAJbmV0aWZfdHhfc3RvcF9hbGxfcXVldWVzKG5kZXYpOw0KPiA+DQo+ID4gIAkvKiBTdG9w
IFBUUCBDbG9jayBkcml2ZXIgKi8NCj4gPiAtCWlmIChpbmZvLT5ub19wdHBfY2ZnX2FjdGl2ZSkN
Cj4gPiArCWlmIChpbmZvLT5ncHRwKQ0KPiANCj4gICAgIC4uLiBhbmQgaGVyZS4NCj4gDQo+ID4g
IAkJcmF2Yl9wdHBfc3RvcChuZGV2KTsNCj4gPg0KPiA+ICAJLyogV2FpdCBmb3IgRE1BIHN0b3Bw
aW5nICovDQo+ID4gQEAgLTE1NDMsNyArMTU0Myw3IEBAIHN0YXRpYyB2b2lkIHJhdmJfdHhfdGlt
ZW91dF93b3JrKHN0cnVjdA0KPiA+IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiA+DQo+ID4gIG91dDoN
Cj4gPiAgCS8qIEluaXRpYWxpc2UgUFRQIENsb2NrIGRyaXZlciAqLw0KPiA+IC0JaWYgKGluZm8t
Pm5vX3B0cF9jZmdfYWN0aXZlKQ0KPiA+ICsJaWYgKGluZm8tPmdwdHApDQo+ID4gIAkJcmF2Yl9w
dHBfaW5pdChuZGV2LCBwcml2LT5wZGV2KTsNCj4gDQo+ICAgICAuLi4gYW5kIGhlcmUuDQo+IA0K
PiA+ICAJbmV0aWZfdHhfc3RhcnRfYWxsX3F1ZXVlcyhuZGV2KTsNCj4gPiBAQCAtMTc1Miw3ICsx
NzUyLDcgQEAgc3RhdGljIGludCByYXZiX2Nsb3NlKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0K
PiA+ICAJcmF2Yl93cml0ZShuZGV2LCAwLCBUSUMpOw0KPiA+DQo+ID4gIAkvKiBTdG9wIFBUUCBD
bG9jayBkcml2ZXIgKi8NCj4gPiAtCWlmIChpbmZvLT5ub19wdHBfY2ZnX2FjdGl2ZSkNCj4gPiAr
CWlmIChpbmZvLT5ncHRwKQ0KPiANCj4gICAgIC4uLiBhbmQgaGVyZS4NCj4gDQo+ID4gIAkJcmF2
Yl9wdHBfc3RvcChuZGV2KTsNCj4gPg0KPiA+ICAJLyogU2V0IHRoZSBjb25maWcgbW9kZSB0byBz
dG9wIHRoZSBBVkItRE1BQydzIHByb2Nlc3NlcyAqLyBAQA0KPiA+IC0yMDE4LDcgKzIwMTgsNyBA
QCBzdGF0aWMgY29uc3Qgc3RydWN0IHJhdmJfaHdfaW5mbyByYXZiX2dlbjNfaHdfaW5mbyA9DQo+
IHsNCj4gPiAgCS5pbnRlcm5hbF9kZWxheSA9IDEsDQo+ID4gIAkudHhfY291bnRlcnMgPSAxLA0K
PiA+ICAJLm11bHRpX2lycXMgPSAxLA0KPiA+IC0JLnB0cF9jZmdfYWN0aXZlID0gMSwNCj4gDQo+
ICAgIFdoZXJlIGlzICdncHRwJz8NCj4gDQo+ID4gKwkuY2NjX2dhYyA9IDEsDQo+ID4gIH07DQo+
ID4NCj4gPiAgc3RhdGljIGNvbnN0IHN0cnVjdCByYXZiX2h3X2luZm8gcmF2Yl9nZW4yX2h3X2lu
Zm8gPSB7DQo+IFsuLi5dDQo+ID4gQEAgLTIwODAsNyArMjA4MCw3IEBAIHN0YXRpYyB2b2lkIHJh
dmJfc2V0X2NvbmZpZ19tb2RlKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpuZGV2KQ0KPiA+ICAJc3Ry
dWN0IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2KG5kZXYpOw0KPiA+ICAJY29uc3Qg
c3RydWN0IHJhdmJfaHdfaW5mbyAqaW5mbyA9IHByaXYtPmluZm87DQo+ID4NCj4gPiAtCWlmIChp
bmZvLT5ub19wdHBfY2ZnX2FjdGl2ZSkgew0KPiA+ICsJaWYgKGluZm8tPmdwdHApIHsNCj4gDQo+
ICAgIFdoZXJlIGhhdmUgeW91IGxvc3QgIWluZm8tPmNjY19nYWM/DQo+IA0KPiA+ICAJCXJhdmJf
bW9kaWZ5KG5kZXYsIENDQywgQ0NDX09QQywgQ0NDX09QQ19DT05GSUcpOw0KPiA+ICAJCS8qIFNl
dCBDU0VMIHZhbHVlICovDQo+ID4gIAkJcmF2Yl9tb2RpZnkobmRldiwgQ0NDLCBDQ0NfQ1NFTCwg
Q0NDX0NTRUxfSFBCKTsNCj4gWy4uLl0NCj4gDQo+IE1CUiwgU2VyZ2V5DQo=
