Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875023EA137
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 11:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbhHLJA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 05:00:28 -0400
Received: from mail-eopbgr1410104.outbound.protection.outlook.com ([40.107.141.104]:31383
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235600AbhHLJA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 05:00:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6htULpQ1Vp0FVcv9UEwWhkc9wVBpIGwt4iLtBBOm8BXTMKXeuiLQkqbp0Eed03ryW8edWeMimBYhdinVIHUn1+t6bAV+SW2G99ghthRtjhocVVuCXe7PFQkHyoDT6Bn+BluMXizNY09ReyT4SdUx2pMAXmOsNOSx1AYzQCzaFnfbWcpsfyRPUbACRr4Q/vJf1FAYy4XJ1W5W0kT7exPVKxdKoWthe7k1D7Lc3AhIQWX/YjYYSO2brb6EtnzqUmnTu+Es7WQT1c6RHZOZbQrSVokod2VsK7e9BKi7Tm+jmhDCviWK61Ni/FMg9jzID9tHQ4nJM7LJrSRmS4gDoqM4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4veR5cnOOCn8gNN6XFMORPN2n5NR1n9MyMO3M1Q9LQk=;
 b=SuCIvNpUykv3oGwt0V3AlVacE2wEfME3MjwRQwvIEzXhH+R6xk+4u9KZEmS3d1FW6UPdq/vy6yhPucuUNRB8sPCwKjXYwXrF0zL0+NJx3EWZmyi7ON9NxGgYnFVXPYuhvH9X966OF6GbNyN08GQSpMWjz7JQSTtSy1q4F1ZnC4x81w8TIqIxopNS7xMP/8Ipgceri83BRqSqlEe5R5H8Zscgr9ac+5NULkMI9o4q7ovMutFlV/ET0/CJ/wJSmIa1LSIf7Oqeujhi/O5HrdHTK52LqE+abuy6eHheWSiVKZuZgMVv9eVLI7JWBB/dfaohJBKBwgnZUyJriKAL59epWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4veR5cnOOCn8gNN6XFMORPN2n5NR1n9MyMO3M1Q9LQk=;
 b=gLq+lV9xWvTY5iuNv4X6PCh82NZuAq+yjy99Ebb2ENbhwR7n58Aq7UoovS6u+m+esSO5RfWUm/UUDtTJHQUBCmeZb5PV3Mv4pude0d//liUnGEH/scYK/vR0hTgD703riffO+qAlDpdoQDAekOtdjMOro+EiGMlUfz1Ij4Mu5no=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB4343.jpnprd01.prod.outlook.com (2603:1096:604:72::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Thu, 12 Aug
 2021 08:59:59 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4415.017; Thu, 12 Aug 2021
 08:59:59 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH v2] dt-bindings: net: renesas,etheravb: Document Gigabit
 Ethernet IP
Thread-Topic: [PATCH v2] dt-bindings: net: renesas,etheravb: Document Gigabit
 Ethernet IP
Thread-Index: AQHXguPRHVSIu7wrFUiJgnWPByuYR6tvoeeAgAABj4A=
Date:   Thu, 12 Aug 2021 08:59:58 +0000
Message-ID: <OS0PR01MB5922DDDBA73FB25B700B1E2A86F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210727123450.15918-1-biju.das.jz@bp.renesas.com>
 <CAMuHMdVSWks7f31O3y4QuZLnztoQgG04CuCiZ9Beo-qKezNmbw@mail.gmail.com>
In-Reply-To: <CAMuHMdVSWks7f31O3y4QuZLnztoQgG04CuCiZ9Beo-qKezNmbw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50d8ae4c-c52d-4966-936d-08d95d6f9021
x-ms-traffictypediagnostic: OSBPR01MB4343:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB4343F823086FC05910DF798986F99@OSBPR01MB4343.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qe0k5YkjdGZhmP2m+7HdqzcgQ/va9GPYqPHRNoMvTJZNcAnUxo+VwO/GhYVlUpzNM0gecl4vTlzeo1YJekANczjXrB64MxJz3Cha0AusRVi0IrXxeC/R2wbOfkHS/yTw65ospGBTia1WnutGh4SbxevkhZxMiqozAIoprekHSjyjyFJrLNYEYgHDKxbRn/RDUDPwjrW7E5Eu/xYgznvmvpdzUJZn5NI/gW9h7xwMDjw8QGRNjoo+7Ti6/fhi8u2aJieHCCsOFaa8rDIbLQOs26VU8NV8Yp0hD8ONebr+dVOTZ+8oE1ySgJkuZ2DpvT1xW9H006mIL/amGUPIMAAaQyEJ8Die5INSO63q4w4wr6sFPzRBp083MCKBwjcc6dHchu4dWqiq9YfJ/vJQsT1Az36JJsLa5ks5tluAskCYNvfNR/bTHjUpqYJMbKMsD+O9SbE/g1P2clysQUrRvi/dEUU9VNSu/ZPMgqiQaWsiNVE1eRcJr55HZOCHptpdTyp0Ly+dabdtBqm1kQJ6Jhk4u4EUoaQo7YWgF4/xmOvl0AI3r+zTdVwhc47w0yafaMyav6HpMYir42HywyQpDCSLcVQA7osMNtdjzK4DlBxqbwGCNCKPQQKBV3TSloAaP9zMsCfTWG+AKy1uVG3USIDv/fM//85GvQTcqo595P4MyBYjy4xGqWeS6vigRxpZzzQknU9G6kdqaai3RAu37v0kBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(64756008)(122000001)(38100700002)(66556008)(6506007)(4326008)(8676002)(76116006)(66946007)(53546011)(6916009)(86362001)(66446008)(55016002)(9686003)(2906002)(66476007)(54906003)(33656002)(478600001)(38070700005)(107886003)(83380400001)(316002)(5660300002)(8936002)(7696005)(52536014)(26005)(186003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEFIUDBjSFYvTmMwemNCNUtPMEoyNEV4WHF2aUFBNWhvZVdYTUR4a1dPTE1o?=
 =?utf-8?B?UTFRbW5pTi9LUCtTVUlVM0tSckR5T2VEQXZUMU8yVTlvRy9LejNGanNUYlVB?=
 =?utf-8?B?bWxOb1RMaEJCZ1pXSXI1UEtXTXJiK0RiMmQ1azF6b2RBZ0R3U1c0TktCazhj?=
 =?utf-8?B?bWVjRlpPc0lkK2ZYVG1BbHc0VDQyMzM1WjIxZGkyTVI3MmVIN3k2WDFweFk4?=
 =?utf-8?B?Umo2WnpZbGhSMm9VOXkwTW9FVTdSN2NwL0FHZms3V0JSZkk2U2Z5L01Dc1BL?=
 =?utf-8?B?Mk1Pb1pmOHFzWmtPY2lhT2RVU2RkMHBWUk5ObkpqVjRubWFDMnZ1bk1IYlFH?=
 =?utf-8?B?dWJ6WTFTaDN0QXJWd2R5dUtKRFowZktCS2hMRDNOMXBqVFRCSG03a3Y1RmxU?=
 =?utf-8?B?ZFgzWlJwMWNCUUExcGY4VW5BaysxWFM1VzZKUUF6SHUydXpkOUtWV1BzanE2?=
 =?utf-8?B?UHhnTUxrNzk5TkpoSEtsMzRtMnliQTNMYWlCMDVvMVJTN2ZRUzFHcWhpektC?=
 =?utf-8?B?RU9VZmF3b0FhRHZHcXZlTEVBclgzY0pRV0hiZ1FESSsyd21DOGo0cE1UeTdp?=
 =?utf-8?B?NmRjOC9OZExySTEwMGtUSGtRSEpYV2EvZU95ZlhtTDBNRkRxdERUSUxKRVd1?=
 =?utf-8?B?a2ZtQW90STdXZ21aTWl1V1FWWXhvcFBhaVlIMWhpWjh0Ymd0ZmZEWU1LZWVF?=
 =?utf-8?B?RTkyTmc0RysySUsvVCtyMHF4WkVPVFczRHdEd0laV2RLNUZVSlpPMDlJMEE3?=
 =?utf-8?B?TEJBRzlFRHkzR2tzWGdrOHVaalVvb2ZjR3A0REhrVEtkSkQ0Qy9xMlFVQUhK?=
 =?utf-8?B?RDJpUkM5VWVvOGd6YWZNcHJ6SFpjM2RmQXFWMlBWRnQ3c0xka3Vla1BBREtk?=
 =?utf-8?B?VW9KVFNxTUVOSjZJeW1CTk1RUzdWV0VrTnB6OGhockRHTWpyYnZGRjF2ZUZO?=
 =?utf-8?B?V0JVRUFFNTNzOUZDVklrVXMxajdLK2w5Ty9OUGNneHdDcHdlcFZpU2k0R3M0?=
 =?utf-8?B?Z0dzTlF0QW9CczhId3RPNUtLbEpqdjF1bTE4dTlMc3ZuU21COGFEK0tmTUQ1?=
 =?utf-8?B?bnFpRzgrODlFa3J6QjQxY0NTUEZxWFFVTDJFbDRJM2VPVlVvZFZzOWc3Q2xj?=
 =?utf-8?B?cVpWN3ZkbStMdWswa3l4THprTHdER1ZFQzFaZVVTK1BBREtsUzRqRUd0eDdi?=
 =?utf-8?B?ZFBwbUJSL3BaZXVEc1dSQSt2VHVybkVERzVRWXc1aUdWazlOc1QxKzIrUEtZ?=
 =?utf-8?B?ams0VkdseFlKT0pWVjBEVVh2RVh1L0pBZDFqV1lZaTc0V3c3M1JWaXhNNlY5?=
 =?utf-8?B?T2VDTHpGQ3I0QnpvQllpNml4ZzdNbXFNTmNnWjVVbnd3aEZUUkVmTEJjZUdq?=
 =?utf-8?B?dnpWa0xJcG05NWVPYkFtUUx3Tk1sd0pMTzZmbGxTMnJGU3BoYXJWRGNBMHVw?=
 =?utf-8?B?cDNTT2I0R3BNK2hhcDJiUG1jNHltMUxiYWljejVIL1NJM1JGWG5Pa0U3SXp5?=
 =?utf-8?B?aUNSbTFzYXpxL211WWdob1FnNUI1R3JmOWVWMHJWakY0YmZTa0I1dk1OOXlr?=
 =?utf-8?B?ZDVVSHFGbEI1VHJaL3JJNDJlRW55RWRrUHcwY3Jlbjdrd1Zucm9zVHNoL3JW?=
 =?utf-8?B?TkVxQUZvSE5kZGZ0UGthSU9NV1ovS1pnaFNReUxkN3ZzdVdZWmc4cGxVSnJZ?=
 =?utf-8?B?d0t6bjAxeFlQTm9xMXg5RHJ6K2dpZGpUUHJjcnlJN3F2YVpMS0c2MnhkaU5t?=
 =?utf-8?Q?PzGvWfUTgQ0Z1dipJTBX9pk3Tx2qtCgIq0lvNss?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d8ae4c-c52d-4966-936d-08d95d6f9021
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 08:59:58.6769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LpjJZlzy3AuI8bwbe+3+TAHi5GEBFpWYjG0dEWq1V+3mlPLNECHcXO32YqkRJNZ/LxkHS4Kb//QhOcRKUHLrjUlNX3pKPmQW0uSZTnW8rIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggdjJdIGR0LWJpbmRpbmdzOiBuZXQ6IHJlbmVzYXMsZXRoZXJhdmI6IERvY3VtZW50DQo+
IEdpZ2FiaXQgRXRoZXJuZXQgSVANCj4gDQo+IEhpIEJpanUsDQo+IA0KPiBPbiBUdWUsIEp1bCAy
NywgMjAyMSBhdCAyOjM1IFBNIEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4N
Cj4gd3JvdGU6DQo+ID4gRG9jdW1lbnQgR2lnYWJpdCBFdGhlcm5ldCBJUCBmb3VuZCBvbiBSWi9H
MkwgU29DLg0KPiA+DQo+ID4gR2lnYWJpdCBFdGhlcm5ldCBJbnRlcmZhY2UgaW5jbHVkZXMgRXRo
ZXJuZXQgY29udHJvbGxlciAoRS1NQUMpLA0KPiA+IEludGVybmFsIFRDUC9JUCBPZmZsb2FkIEVu
Z2luZSAoVE9FKSBhbmQgRGVkaWNhdGVkIERpcmVjdCBtZW1vcnkNCj4gPiBhY2Nlc3MgY29udHJv
bGxlciAoRE1BQykgZm9yIHRyYW5zZmVycmluZyB0cmFuc21pdHRlZCBFdGhlcm5ldCBmcmFtZXMN
Cj4gPiB0byBhbmQgcmVjZWl2ZWQgRXRoZXJuZXQgZnJhbWVzIGZyb20gcmVzcGVjdGl2ZSBzdG9y
YWdlIGFyZWFzIGluIHRoZQ0KPiA+IFVSQU0gYXQgaGlnaCBzcGVlZC4NCj4gPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiBSZXZp
ZXdlZC1ieTogTGFkIFByYWJoYWthciA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJlbmVz
YXMuY29tPg0KPiANCj4gVGhhbmtzIGZvciB5b3VyIHBhdGNoIQ0KPiANCj4gPiAtLS0gYS9Eb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3JlbmVzYXMsZXRoZXJhdmIueWFtbA0K
PiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvcmVuZXNhcyxl
dGhlcmF2Yi55YW1sDQo+IA0KPiA+IEBAIC0xNDUsMTQgKzE0MiwyMCBAQCBhbGxPZjoNCj4gPiAg
ICAgICAgcHJvcGVydGllczoNCj4gPiAgICAgICAgICBjb21wYXRpYmxlOg0KPiA+ICAgICAgICAg
ICAgY29udGFpbnM6DQo+ID4gLSAgICAgICAgICAgIGNvbnN0OiByZW5lc2FzLGV0aGVyYXZiLXJj
YXItZ2VuMg0KPiA+ICsgICAgICAgICAgICBlbnVtOg0KPiA+ICsgICAgICAgICAgICAgIC0gcmVu
ZXNhcyxldGhlcmF2Yi1yY2FyLWdlbjINCj4gPiArICAgICAgICAgICAgICAtIHJlbmVzYXMscnpn
MmwtZ2JldGgNCj4gPiAgICAgIHRoZW46DQo+ID4gICAgICAgIHByb3BlcnRpZXM6DQo+ID4gICAg
ICAgICAgaW50ZXJydXB0czoNCj4gPiAtICAgICAgICAgIG1heEl0ZW1zOiAxDQo+ID4gKyAgICAg
ICAgICBtaW5JdGVtczogMQ0KPiA+ICsgICAgICAgICAgbWF4SXRlbXM6IDMNCj4gPiAgICAgICAg
ICBpbnRlcnJ1cHQtbmFtZXM6DQo+ID4gKyAgICAgICAgICBtaW5JdGVtczogMQ0KPiA+ICAgICAg
ICAgICAgaXRlbXM6DQo+ID4gICAgICAgICAgICAgIC0gY29uc3Q6IG11eA0KPiA+ICsgICAgICAg
ICAgICAtIGNvbnN0OiBpbnRfZmlsX24NCj4gPiArICAgICAgICAgICAgLSBjb25zdDogaW50X2Fy
cF9uc19uDQo+IA0KPiBJJ20gYXdhcmUgUm9iIGhhcyBhbHJlYWR5IGFwcGxpZWQgdGhpcywgYnV0
IHNob3VsZCB0aGUgImludF8iIHByZWZpeCBiZQ0KPiBkcm9wcGVkPw0KDQpPSy4gSSB3aWxsIHVz
ZSAiZmlsIiBhbmQgImFycCIgaW5zdGVhZC4NCg0KPiBUaGUgIl9uIiBzdWZmaXggaXMgYWxzbyBh
IGJpdCB3ZWlyZCAoYWxiZWl0IGl0IG1hdGNoZXMgdGhlIGRvY3VtZW50YXRpb24pLg0KPiBVc3Vh
bGx5IGl0IGlzIHVzZWQgdG8gaW5kaWNhdGUgYW4gYWN0aXZlLWxvdyBzaWduYWwsIGJ1dCB0aGUg
aW50ZXJydXB0IGlzDQo+IGRlY2xhcmVkIGluIHRoZSAuZHRzaSB3aXRoIElSUV9UWVBFX0xFVkVM
X0hJR0guDQo+IA0KDQpCdXQgaGVyZSBvbiB0aGUgaW50ZXJydXB0IG1hcHBpbmcgdGFibGUoUlpH
MkxfSW50ZXJydXB0TWFwcGluZ19yZXYwMS54bHN4KS4gSXQgaXMgbWVudGlvbmVkIGFzIGhpZ2gu
IFNvIEkgZ3Vlc3MsIGl0IGlzIGNvcnJlY3QuDQoNCj4gQW5kIHRoZSBmaXJzdCBpbnRlcnJ1cHQg
aXMgbm90IGEgbXV4IG9uIFJaL0cyTCwgYnV0IGNhbGxlZCAicGlmX2ludF9uIg0KPiAod2hhdGV2
ZXIgInBpZiIgbWlnaHQgbWVhbikuDQoNCkFzIHBlciBzZWN0aW9uIDMyLjUuMTIgSW50ZXJydXB0
cywgdGhpcyBpbnRlcnJ1cHQgaW5jbHVkZSwgRGVzY3JpcHRvciBpbnRlcnJ1cHRzLA0KRXJyb3Ig
aW50ZXJydXB0cywgcmVjZXB0aW9uIGludGVycnVwdHMgYW5kIHRyYW5zbWlzc2lvbiBpbnRlcnJ1
cHRzLg0KDQpUaGUgc291cmNlIHN0YXR1cyBjYW4gYmUgY2hlY2tlZCBmcm9tIGluZGl2aWR1YWwg
c3RhdHVzIHJlZ2lzdGVyLiANCg0KRm9yIG1lLiBUaGlzIGRlc2NyaXB0aW9uIGxvb2tzIGxpa2Ug
YSBtdXggaW50ZXJydXB0Lg0KTXVsdGlwbGUgaW50ZXJydXB0IHNvdXJjZXMgb3JlZCB0b2dldGhl
ciB0byBnZW5lcmF0ZSBhbiBpbnRlcnJ1cHQgYW5kIHN0YXR1cyBjYW4gYmUgDQpDaGVja2VkIGZy
b20gZWFjaCBpbmRpdmlkdWFsIHJlZ2lzdGVyLiANClBsZWFzZSBsZXQgbWUga25vdyBpZiBteSB1
bmRlcnN0YW5kaW5nIGlzIHdyb25nLg0KDQpJIGFncmVlLCBvbiBIVyBtYW51YWwgaXQgaXMgbWVu
dGlvbmVkIGFzIHBpZl9pbnRfbi4gSSBjYW4gcmVwbGFjZSBtdXggd2l0aCBwaWYgaW5zdGVhZC4g
UGxlYXNlIGxldCBtZSBrbm93Lg0KDQpSZWdhcmRzLA0KQmlqdQ0KDQoNCg0KDQo+IA0KPiA+ICAg
ICAgICAgIHJ4LWludGVybmFsLWRlbGF5LXBzOiBmYWxzZQ0KPiA+ICAgICAgZWxzZToNCj4gPiAg
ICAgICAgcHJvcGVydGllczoNCj4gDQo+IEdye29ldGplLGVldGluZ31zLA0KPiANCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgR2VlcnQNCj4gDQo+IC0tDQo+IEdlZXJ0IFV5dHRlcmhvZXZlbiAt
LSBUaGVyZSdzIGxvdHMgb2YgTGludXggYmV5b25kIGlhMzIgLS0gZ2VlcnRAbGludXgtDQo+IG02
OGsub3JnDQo+IA0KPiBJbiBwZXJzb25hbCBjb252ZXJzYXRpb25zIHdpdGggdGVjaG5pY2FsIHBl
b3BsZSwgSSBjYWxsIG15c2VsZiBhIGhhY2tlci4NCj4gQnV0IHdoZW4gSSdtIHRhbGtpbmcgdG8g
am91cm5hbGlzdHMgSSBqdXN0IHNheSAicHJvZ3JhbW1lciIgb3Igc29tZXRoaW5nDQo+IGxpa2Ug
dGhhdC4NCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAtLSBMaW51cyBUb3J2YWxk
cw0K
