Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769653F85E2
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 12:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241775AbhHZKxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 06:53:25 -0400
Received: from mail-eopbgr1410123.outbound.protection.outlook.com ([40.107.141.123]:32198
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234296AbhHZKxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 06:53:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHO0Hfm4NMnwNpZPF7FmbOaO/rT/pOImrzctsGtjrkbIcF8fJnHy+Zs4vqIrn8PPgf3MGJfHJmWhCAyH0RfTmvnkN6gTfKAgjI860f2tIyOc0eLT9oFYQ8QkyR/TDPrHlPxtWGK6Lgg60CbBs5rZ17q8aRlU+DmAI+Vi7sTkZZplbdGI1o9nO3oRh83aEReZK+lf1IhT+bq7Z161p5yxxKCX6/i+OpdsjjaXLTB83gyB4UIofraNVVbAUt1uYc6SjfvQq9KLisGE/PJxwDJGDGGeIi7+/vWqfE4v8EXa/FYHFpTn3oEvtQtQbOxx78Oh4H73/jYjad/z6Ewo3wEwfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S4mjpWZbRhacf3RcFj8mFqbAFogGMcUC5CXTBynVn3U=;
 b=knrfgOG+M7A0gZNrZgWeIvDZRvwzv4TT8Z21SzYr3qwpR6sJTyVRPbe2ZbXKajmgacq6+9EDJgEPRXBubq36EuGB8UNU7RPYcrhTlwEE/wfDADIDcNGR9VWH9vCGZ6PP8lvW3vVMt52mqG5rDKXmZYHa8FVZw2eU1OJd3dwRGIy0tzLHmJQUnKyo+yWoZRrIgMz5v/URi9TQ7Oqmad/pYHqXhrF/mB/el6wXa4m1EGLjbDj0NNRW9VlFS/4R9J3hJLK1Dmcgu42b7P0/e0fwwmEx8J/YPxHgURD0ToORVjjeB/ltahgtdFEDjQPdLa7mEQauafehkW4o9EEXKJm6Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S4mjpWZbRhacf3RcFj8mFqbAFogGMcUC5CXTBynVn3U=;
 b=neOGvS+WImhhCrP/KGeTbAwphT/mVsmDWuwqA3FijY55QI8/24cqvwNqVMAUWvH/DWb1wS57u12WMTTBa6xykRJD8Miqgm31AjdyQQClkGtyq5kCRkO4EiFG1YXNrQsMJQXrNOtMsYKXlby472iVmr8pxtjfLOL3ndwZwF3Qy1A=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2708.jpnprd01.prod.outlook.com (2603:1096:603:38::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.23; Thu, 26 Aug
 2021 10:52:35 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98%3]) with mapi id 15.20.4436.025; Thu, 26 Aug 2021
 10:52:34 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
Thread-Topic: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
Thread-Index: AQHXmX8jVvjbtjTRLEe2lQMMRo0BcquEr1UAgAChqBCAAEagAIAAAOMggAACgwCAAAEbsA==
Date:   Thu, 26 Aug 2021 10:52:34 +0000
Message-ID: <OS0PR01MB5922F8114A505A33F7A47EB586C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-5-biju.das.jz@bp.renesas.com>
 <777c30b1-e94e-e241-b10c-ecd4d557bc06@omp.ru>
 <OS0PR01MB59220BCAE40B6C8226E4177986C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <78ff279d-03f1-6932-88d8-1eac83d087ec@omp.ru>
 <OS0PR01MB59223F0F03CC9F5957268D2086C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <9b0d5bab-e9a2-d9f6-69f7-049bfb072eba@omp.ru>
In-Reply-To: <9b0d5bab-e9a2-d9f6-69f7-049bfb072eba@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dabcb6f9-48dd-476c-8cea-08d9687f9cbd
x-ms-traffictypediagnostic: OSAPR01MB2708:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB270857FE3850FBED1D3B4E2E86C79@OSAPR01MB2708.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hV6MKvD01flrn7zrGngq2Aoo1CyUnXaFlbCTtjvTwpc1oceJwrdGbVDjQge0HaHwBty4HzwvfMekNPCoxPxwcXcp6FjXyUWryXirg5Sr9pMJBttLh0k36EcoMsgs1TonarUcXOxvDEmwE6fxAQRn5l1U7c/su8PHPZk/dHx5fxtOSPqp+mmDxm839u7X0AC6zW//3liJ3QgD5udp0nM6SXwcqZmuPNvzH96lkZPkAF5dywY5+bBvpYJi6hiQfKv69pB8J0ATWE14QwAl01UcETDHz1a2N+nJMFGNEgwPyW0ueJIiDI+D+MEPgXL1nZATCZZZS81Uk0KmJ2Wh2h6O3W0mlT6hRzko7l32WYgEktQarE4+WbwRzIcbeKfMPwtJLVQk8yJjrXXlyDUtj3U9QGZf1z/DJqsSvL4KddhIZ6EMuG+uKcHoG1MSvE7VuYul51Wa0+hXBKnqeXQgROAmMQsMD/NpeD3sdBBwjzxDk4u3cT99F0dyHxy6/d0gRixERzxLSk9vxoaYg7veejsOrfCK4WOQRFpdhtpUqtnla5h0gYETnsy9rTIB5jo1mEObtxnKEmD79I6kM8wSzv0GKd0HnUxAtuKaK5g5YroYjvcvHDjIeX2M64oDvIcO6T9KMMF2/byu/Y64Pb4ySzIs9xTM90DCNygOcJYPjQPcaHMw6qa0xfbEZPGCw4McoyJYbZcDbCwIMW6Od6qLeFlj9Dm2x+2pCTbPQjfmhJvhGulbWNi6ShgG1dFLc+5ldi0mq4NevB2eWtd0A6Uy8Myyb3BNaEHQasIcHdqFhKLRMA0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(76116006)(33656002)(316002)(71200400001)(9686003)(66946007)(107886003)(478600001)(83380400001)(55016002)(66556008)(66446008)(64756008)(66476007)(186003)(4326008)(2906002)(8936002)(38070700005)(5660300002)(86362001)(52536014)(8676002)(6506007)(26005)(53546011)(7696005)(38100700002)(110136005)(122000001)(54906003)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anltdEQ4U0gvbFBjR1I5NUhKV0VoSk0rR3Y4NU03dzRiS3BVYWlwQ1AxZzB4?=
 =?utf-8?B?cS9Md21ZR3NQcnR4QmF1djNkS1ZkejZKcDM5NEZ2d1FnYlNHdUtsNG1Fczdw?=
 =?utf-8?B?a0Z2UFYwckhnUERzY3NjdG5OcDhac1ZGQlRycjI1VU10eFRhOHdYTEhPNHNp?=
 =?utf-8?B?RW9kL25YakVPYUt4clhwSlZ2b3l4QjlaLzBEYkhtVEVIMWNBdDI3R0ZRNGJh?=
 =?utf-8?B?cFBUM0VyZ1kxNktiMTFnOG1Sbi84K1ZoZGxwQUhtbnZIRm90WkdMaWtwenhj?=
 =?utf-8?B?elFYcXJ4dnlwY2E2Nnl4TUg4SVh2VCtnaldmVjlmcy8xVzQwaTJONlhneHBz?=
 =?utf-8?B?eVQ3SkZNaDR4Y1IvV0t4aEY1VjBYaGNqTGlpdGZuR0VnbEtnNWhTdjRlOGVs?=
 =?utf-8?B?VWh6TzNSTzFYcGozWDlCaklmczJjZldaK2NDd2xYK2pkeDBNTldXSUQzeXhB?=
 =?utf-8?B?WkNoNU4zdjQrdkNiaDdoSnI0cWRmWUpVbFZNZ1RQa1RmR2tST0t6eUtOejAv?=
 =?utf-8?B?c0d6NkU5YkFVRmZzR3I4UnQ4TGZ6VXZaRGdsdVFnV0prdHEvYU9FOFB3OXV0?=
 =?utf-8?B?dWJXQXN4U3VYbG5oWDhYTVhiR05FMVdqQ0dpUUp0NVdBVi9RcW5DRWswdFM0?=
 =?utf-8?B?RVJtQ0RlMzBlWXU0WXdlUmZwdDRzZkl4cndtblNHQWNLNTltdVorZ3FyMEFm?=
 =?utf-8?B?ZmJXV2pnaGZpQjFtN1dBZUhUUmtTSTZZWitxY0hRSG5FMmpXQVUyV3BjaHR0?=
 =?utf-8?B?dDNTTlRmcmxDTURBY1ZjL0ZLeE1Id3FPbHV2VmxJODVEbmVvRENsTGM3d2xY?=
 =?utf-8?B?N2pjdGpicDBBd2JoMmNqcXA3elhwYzVoMUJjWlVRWE8vNit2Q3lPc0NlMU41?=
 =?utf-8?B?WGExa1U1V2FFYllPM1JkRXR2UGZzMnh1VFJMTUpJQi9TbTF1NTFvam1UQTBx?=
 =?utf-8?B?Z1FQeFh2NFhXZmM1M0lxcFozYWQrSWZLN042YmMwaEpnbnR2WmFHb1BrQjZM?=
 =?utf-8?B?TTlHSys3bXBHNlk1ZmxsUjQvd1VLWUlZMDB5TjhkZXMzNlV4Q2Y3cGhCdXNn?=
 =?utf-8?B?b3dnbFN4OVdmTWhBTkE1OUZvQjRvTW5XREFZdWdlMXk2UjRaektHejc5RlZD?=
 =?utf-8?B?Tkl6dWRRT09WUzJ3WTdXNFRoekxDWEhBbitaeklUMS9rSHNHMDlNUC9Wei9P?=
 =?utf-8?B?WFdVWlpwRHlWbis5NitqYjllOFlMT0gzNDZjb2FuaVNmUTNLb3NSR1FEd2t6?=
 =?utf-8?B?WnhnT01lVkNmczdNR2E0b2ZSZjNXMVFzTnJiS3FZSTZjcWZlYkh3bm5PbVhn?=
 =?utf-8?B?WHpSNGhlL3U3K09iczFOckVYbERjQWN0a0lFRnU5Q01NUjJZQUpvM2o2Qjl0?=
 =?utf-8?B?bjU1NjhVU3ZKa0dOVzZSZ3NEdWVXakNFbHc4N3dtK0ppWEM2ZXRVdDcwVFd1?=
 =?utf-8?B?cDhHaDZkenNOaVI4MjVpa09ub21OcWlEa1p5eVBTL1RwZGYxaUxhRGMzRzhM?=
 =?utf-8?B?UUVIY0Noc2E1TnBicmdSTG12VjR1SzdFTGtWejBPMk43T1dhMVJOTjBjbEhm?=
 =?utf-8?B?azZhcEo0cVQ4L09NejJadExiZnliOVg5YXJJbHg5Z0RPWjdpczg0a0YzODln?=
 =?utf-8?B?Z0tqWHZKcHZLSFBUZEI0bzVYbzF6TFh1R3FPMzZtUXRLSi9mcW85Vk9JYU80?=
 =?utf-8?B?bEFuRW9TUktIcmRNRWJoNnFzUEpRSzdEQWFiYldGcGtoNGNhWFlUdnE1amlP?=
 =?utf-8?Q?eaAIh4x2AuhR5d+d31MM/g4bXf3JwVG+WW2d0Tk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dabcb6f9-48dd-476c-8cea-08d9687f9cbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 10:52:34.7537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fMenV8Rw9DP4tCobJPGdgYvoOaEqFOAkeY8nXL26fkhJWkHG97+O3AmvL1vaDx3020V+t0oNpUhuyNIAbasKgwoillsVxu0DwB9i2s17L1Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2708
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMDQvMTNdIHJhdmI6
IEFkZCBwdHBfY2ZnX2FjdGl2ZSB0byBzdHJ1Y3QNCj4gcmF2Yl9od19pbmZvDQo+IA0KPiBPbiAy
Ni4wOC4yMDIxIDEzOjM0LCBCaWp1IERhcyB3cm90ZToNCj4gDQo+IFsuLi5dDQo+ID4+Pj4+IFRo
ZXJlIGFyZSBzb21lIEgvVyBkaWZmZXJlbmNlcyBmb3IgdGhlIGdQVFAgZmVhdHVyZSBiZXR3ZWVu
IFItQ2FyDQo+ID4+Pj4+IEdlbjMsIFItQ2FyIEdlbjIsIGFuZCBSWi9HMkwgYXMgYmVsb3cuDQo+
ID4+Pj4+DQo+ID4+Pj4+IDEpIE9uIFItQ2FyIEdlbjMsIGdQVFAgc3VwcG9ydCBpcyBhY3RpdmUg
aW4gY29uZmlnIG1vZGUuDQo+ID4+Pj4+IDIpIE9uIFItQ2FyIEdlbjIsIGdQVFAgc3VwcG9ydCBp
cyBub3QgYWN0aXZlIGluIGNvbmZpZyBtb2RlLg0KPiA+Pj4+PiAzKSBSWi9HMkwgZG9lcyBub3Qg
c3VwcG9ydCB0aGUgZ1BUUCBmZWF0dXJlLg0KPiA+Pj4+Pg0KPiA+Pj4+PiBBZGQgYSBwdHBfY2Zn
X2FjdGl2ZSBodyBmZWF0dXJlIGJpdCB0byBzdHJ1Y3QgcmF2Yl9od19pbmZvIGZvcg0KPiA+Pj4+
PiBzdXBwb3J0aW5nIGdQVFAgYWN0aXZlIGluIGNvbmZpZyBtb2RlIGZvciBSLUNhciBHZW4zLg0K
PiA+Pj4+DQo+ID4+Pj4gICAgICBXYWl0LCB3ZSd2ZSBqdXN0IGRvbmUgdGhpcyBpb24gdGhlIHBy
ZXZpb3VzIHBhdGNoIQ0KPiA+Pj4+DQo+ID4+Pj4+IFRoaXMgcGF0Y2ggYWxzbyByZW1vdmVzIGVu
dW0gcmF2Yl9jaGlwX2lkLCBjaGlwX2lkIGZyb20gYm90aA0KPiA+Pj4+PiBzdHJ1Y3QgcmF2Yl9o
d19pbmZvIGFuZCBzdHJ1Y3QgcmF2Yl9wcml2YXRlLCBhcyBpdCBpcyB1bnVzZWQuDQo+ID4+Pj4+
DQo+ID4+Pj4+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2Fz
LmNvbT4NCj4gPj4+Pj4gUmV2aWV3ZWQtYnk6IExhZCBQcmFiaGFrYXINCj4gPj4+Pj4gPHByYWJo
YWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT4NCj4gPj4+Pj4gLS0tDQo+ID4+Pj4+
ICAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAgOCArLS0tLS0t
LQ0KPiA+Pj4+PiAgICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jIHwg
MTIgKysrKystLS0tLS0tDQo+ID4+Pj4+ICAgIDIgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25z
KCspLCAxNCBkZWxldGlvbnMoLSkNCj4gPj4+Pj4NCj4gPj4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+Pj4+IGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPj4+Pj4gaW5kZXggOWVjZjFhOGMzY2E4Li4yMDllMDMw
OTM1YWEgMTAwNjQ0DQo+ID4+Pj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMv
cmF2Yi5oDQo+ID4+Pj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5o
DQo+ID4+Pj4+IEBAIC05NzksMTcgKzk3OSwxMSBAQCBzdHJ1Y3QgcmF2Yl9wdHAgew0KPiA+Pj4+
PiAgICAJc3RydWN0IHJhdmJfcHRwX3Blcm91dCBwZXJvdXRbTl9QRVJfT1VUXTsgIH07DQo+ID4+
Pj4+DQo+ID4+Pj4+IC1lbnVtIHJhdmJfY2hpcF9pZCB7DQo+ID4+Pj4+IC0JUkNBUl9HRU4yLA0K
PiA+Pj4+PiAtCVJDQVJfR0VOMywNCj4gPj4+Pj4gLX07DQo+ID4+Pj4+IC0NCj4gPj4+Pj4gICAg
c3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4+Pj4+ICAgIAljb25zdCBjaGFyICgqZ3N0cmluZ3Nf
c3RhdHMpW0VUSF9HU1RSSU5HX0xFTl07DQo+ID4+Pj4+ICAgIAlzaXplX3QgZ3N0cmluZ3Nfc2l6
ZTsNCj4gPj4+Pj4gICAgCW5ldGRldl9mZWF0dXJlc190IG5ldF9od19mZWF0dXJlczsNCj4gPj4+
Pj4gICAgCW5ldGRldl9mZWF0dXJlc190IG5ldF9mZWF0dXJlczsNCj4gPj4+Pj4gLQllbnVtIHJh
dmJfY2hpcF9pZCBjaGlwX2lkOw0KPiA+Pj4+PiAgICAJaW50IHN0YXRzX2xlbjsNCj4gPj4+Pj4g
ICAgCXNpemVfdCBtYXhfcnhfbGVuOw0KPiA+Pj4+DQo+ID4+Pj4gICAgICBJIHdvdWxkIHB1dCB0
aGUgYWJvdmUgaW4gYSBzcGVhcnRlIHBhdGNoLi4uDQo+ID4+DQo+ID4+ICAgICAgU2VwYXJhdGUu
IDotKQ0KPiA+Pg0KPiA+Pj4+PiAgICAJdW5zaWduZWQgYWxpZ25lZF90eDogMTsNCj4gPj4+Pj4g
QEAgLTk5OSw2ICs5OTMsNyBAQCBzdHJ1Y3QgcmF2Yl9od19pbmZvIHsNCj4gPj4+Pj4gICAgCXVu
c2lnbmVkIHR4X2NvdW50ZXJzOjE7CQkvKiBFLU1BQyBoYXMgVFggY291bnRlcnMgKi8NCj4gPj4+
Pj4gICAgCXVuc2lnbmVkIG11bHRpX2lycXM6MTsJCS8qIEFWQi1ETUFDIGFuZCBFLU1BQyBoYXMN
Cj4gPj4gbXVsdGlwbGUNCj4gPj4+PiBpcnFzICovDQo+ID4+Pj4+ICAgIAl1bnNpZ25lZCBub19w
dHBfY2ZnX2FjdGl2ZToxOwkvKiBBVkItRE1BQyBkb2VzIG5vdCBzdXBwb3J0DQo+ID4+IGdQVFAN
Cj4gPj4+PiBhY3RpdmUgaW4gY29uZmlnIG1vZGUgKi8NCj4gPj4+Pj4gKwl1bnNpZ25lZCBwdHBf
Y2ZnX2FjdGl2ZToxOwkvKiBBVkItRE1BQyBoYXMgZ1BUUCBzdXBwb3J0DQo+IGFjdGl2ZSBpbg0K
PiA+Pj4+IGNvbmZpZyBtb2RlICovDQo+ID4+Pj4NCj4gPj4+PiAgICAgIEh1aD8NCj4gPj4+Pg0K
PiA+Pj4+PiAgICB9Ow0KPiA+Pj4+Pg0KPiA+Pj4+PiAgICBzdHJ1Y3QgcmF2Yl9wcml2YXRlIHsN
Cj4gPj4+PiBbLi4uXQ0KPiA+Pj4+PiBAQCAtMjIxNiw3ICsyMjEzLDcgQEAgc3RhdGljIGludCBy
YXZiX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UNCj4gPj4+PiAqcGRldikNCj4gPj4+Pj4g
ICAgCUlOSVRfTElTVF9IRUFEKCZwcml2LT50c19za2JfbGlzdCk7DQo+ID4+Pj4+DQo+ID4+Pj4+
ICAgIAkvKiBJbml0aWFsaXNlIFBUUCBDbG9jayBkcml2ZXIgKi8NCj4gPj4+Pj4gLQlpZiAoaW5m
by0+Y2hpcF9pZCAhPSBSQ0FSX0dFTjIpDQo+ID4+Pj4+ICsJaWYgKGluZm8tPnB0cF9jZmdfYWN0
aXZlKQ0KPiA+Pj4+PiAgICAJCXJhdmJfcHRwX2luaXQobmRldiwgcGRldik7DQo+ID4+Pj4NCj4g
Pj4+PiAgICAgIFdoYXQncyB0aGF0PyBEaWRuJ3QgeW91IHRvdWNoIHRoaXMgbGllIGluIHBhdGNo
ICMzPw0KPiA+Pj4+DQo+ID4+Pj4gICAgICBUaGlzIHNlZW1zIGxpZSBhIE5BSyBiYWl0Li4uIDot
KA0KPiA+Pj4NCj4gPj4+IFBsZWFzZSByZWZlciB0aGUgb3JpZ2luYWwgcGF0Y2hbMV0gd2hpY2gg
aW50cm9kdWNlZCBnUFRQIHN1cHBvcnQNCj4gPj4+IGFjdGl2ZQ0KPiA+PiBpbiBjb25maWcgbW9k
ZS4NCj4gPj4+IEkgYW0gc3VyZSB0aGlzIHdpbGwgY2xlYXIgYWxsIHlvdXIgZG91YnRzLg0KPiA+
Pg0KPiA+PiAgICAgIEl0IGhhc24ndC4gV2h5IGRvIHdlIG5lZWQgMiBiaXQgZmllbGRzICgxICJw
b3NpdGl2ZSIgYW5kIDENCj4gPj4gIm5lZ2F0aXZlIikgZm9yIHRoZSBzYW1lIGZlYXR1cmUgaXMg
YmV5b25kIG1lLg0KPiA+DQo+ID4gVGhlIHJlYXNvbiBpcyBtZW50aW9uZWQgaW4gY29tbWl0IGRl
c2NyaXB0aW9uLCBEbyB5b3UgYWdyZWUgMSwgMiBhbmQgMw0KPiBtdXR1YWxseSBleGNsdXNpdmU/
DQo+ID4NCj4gPiAxKSBPbiBSLUNhciBHZW4zLCBnUFRQIHN1cHBvcnQgaXMgYWN0aXZlIGluIGNv
bmZpZyBtb2RlLg0KPiA+IDIpIE9uIFItQ2FyIEdlbjIsIGdQVFAgc3VwcG9ydCBpcyBub3QgYWN0
aXZlIGluIGNvbmZpZyBtb2RlLg0KPiA+IDMpIFJaL0cyTCBkb2VzIG5vdCBzdXBwb3J0IHRoZSBn
UFRQIGZlYXR1cmUuDQo+IA0KPiAgICAgTm8sICgxKSBpbmNsdWRlcyAoMikuDQoNCnBhdGNoWzFd
IGlzIGZvciBzdXBwb3J0aW5nIGdQVFAgc3VwcG9ydCBhY3RpdmUgaW4gY29uZmlnIG1vZGUuDQoN
CkRvIHlvdSBhZ3JlZSBHQUMgcmVnaXN0ZXIoZ1BUUCBhY3RpdmUgaW4gQ29uZmlnKSBiaXQgaW4g
QVZCLURNQUMgbW9kZSByZWdpc3RlcihDQ0MpIHByZXNlbnQgb25seSBpbiBSLUNhciBHZW4zPw0K
DQpbMV0gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbmV4
dC9saW51eC1uZXh0LmdpdC9jb21taXQvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZi
X21haW4uYz9oPW5leHQtMjAyMTA4MjUmaWQ9ZjVkNzgzN2Y5NmU1M2E4YzliNmM0OWUxYmM5NWNm
MGFlODhiOTllOA0KDQpSZWdhcmRzLA0KQmlqdQ0KDQo+IA0KPiBbLi4uXQ0KPiANCj4gPiBSZWdh
cmRzLA0KPiA+IEJpanUNCj4gDQo+IFsuLi5dDQo+IA0KPiBNQlIsIFNlcmdleQ0K
