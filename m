Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8A83DF528
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 21:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbhHCTN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 15:13:56 -0400
Received: from mail-eopbgr1400115.outbound.protection.outlook.com ([40.107.140.115]:54352
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238920AbhHCTNz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 15:13:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kX+Lcfw/YvRBLfqN+boS3z3P8kZm5GbCWz+5cOy4b/8cZ6+P686b5l+x+SMjvbUQXx4ofQ5XOrr5SDYBrGC4/EHHqYImTn/gWiD9b3XahC9Zsr/gY861eJDVPX79/BIqKBjivtqAeCxIC1CrhPoTv+v4QjuL8SSfBXyxSHJCWnpVLSmYnWTU2tx0dLbWUvkZqX3kM8gO0X6MsTY7zANfSwz2LlfjpLmbHBDQxIk7C9UDcCegFlFX+3NFgfFoyhID2AQoisuZCi1kKbWW5MdqtO/8XEXvn5HrKzZ8ypxdVTpEL7Ps96MA4tz913DoHt4NdyZOy1Ms+N5ax4SMq5Q4+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luRyKfbAqvA/SwkrLjQF3766c6NYxZKvFpoyBciKDKg=;
 b=ZKbcSWUuDRblyhhLkscFrDyyvTnd6HHcLB+YS3vP7wqCJNFBbklpThF713N0nXbcUCgh6GvwnLlvpud7l6n1Jj/ToMQuVOPDaEPtU5zOaGXbboVfvCFLkpt5PcHZSlyj+TopMH6rDRYyYpj1ldFIo0gVvwq8zdpCeX/22qAPxpGIQNvJkn5yxxzHuYxilPAUMRTKz00Yver7s7DViyV1L2DXStg9eBqhwRdD8lkR4uDcRT5kqNW+DtnGiqQaIdxgIpZA2Ix3LkjNSWh6wJBnbEI4v+6XW+nFxgAoAxJAB3+vBPkRDneLpRcKOVKK4vYLjhd0o1ylswSUOfZd9GRApw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=luRyKfbAqvA/SwkrLjQF3766c6NYxZKvFpoyBciKDKg=;
 b=GG4u4BVACE1U0Xi7VQtJ0ovVvESFSam5RzQDDyjbS6W0K9nG8E2C28h1rFBng/u1M1tElejhQ7lyEJRpCJ0FIGQdRVLFR2xsGk9f+oJojZNchHXLKRLiVN9xMmD7mPcIM00svLWdSCnJWjTOXzjENMlhJv2npk+pf2C5Glc818A=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB1943.jpnprd01.prod.outlook.com (2603:1096:603:23::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Tue, 3 Aug
 2021 19:13:40 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 19:13:40 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next v2 3/8] ravb: Add num_gstat_queue to struct
 ravb_hw_info
Thread-Topic: [PATCH net-next v2 3/8] ravb: Add num_gstat_queue to struct
 ravb_hw_info
Thread-Index: AQHXh4j6N5nNIwH/Qk677Je5gv3Cy6tiGcmAgAANlPA=
Date:   Tue, 3 Aug 2021 19:13:40 +0000
Message-ID: <OS0PR01MB5922F86AB0FDB179B789B6DD86F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-4-biju.das.jz@bp.renesas.com>
 <dab78c92-8ee0-f170-89db-ee276d670a1b@gmail.com>
In-Reply-To: <dab78c92-8ee0-f170-89db-ee276d670a1b@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad3d1d5b-5dcd-4e5d-b30c-08d956b2cdf1
x-ms-traffictypediagnostic: OSBPR01MB1943:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB19438117749A14793CC1601486F09@OSBPR01MB1943.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lzdgV/aA6jjJnEUCHIpGOyTKt5lN1tSAixkwG/tFuyXPdG4YoWKvAql+VD8pzTNnNF3Xvw2pAGDMygm1HGr5v0TcZ+h3c1LakotAlQxNP2+yP+pu5yowuZWWt7v+o0WOfU1gbEDEAoVfrRHcDGADXLaAG2A/8MqbU85nyS8G/rupr2XqEzhcPG/sPVIy3Poh6nYLNmBe0Zh/D0X0icq4mYq0qdT3UHx8e486oyfenJEfpj61fCzOYypd9L8nelZqL+eHWc5scaT/wTbkzUn+5qnWo9fVsCB6k5xSGf26KOi1oQ/3olIdJGlB4qbk+B9Dz/ZqsNKpapHe5G977tXdV97ToUBwbGL+atjuQtQ5C/AEh6x8EeHCj39AibEoIPqMCRWy/dFBnH6aRwXF6XCw2W6PzvE0OgxdiHNWQp5Gso6ICjFq/t+4zJVuYSV+QoRVyGMtfFyDrGVS7hDZ/4NA77Io5JlbG0rKHp5vWty9m741YgZuMURDOw3oGJCMU5gWZKhRajepqY2p3joo/FfH9OcWo2D12XTB0wU0ZsXx+Whf4n7XtD9Ow7jlt6WY5+zbOX1wfphJn9mQwSQvWg545tiKQwt/lQZGQHCqWOJWmwKQrhTb9obsQaPf/g0mHl/VkrQl/7kcSM4jBfk7nh68+WjSWg82nOjKWUzjddH8mcRZoJ0TOuHZujiZXaEkNcfGaZMRucmyldoPxCptHKFpyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(122000001)(76116006)(6506007)(64756008)(66446008)(66946007)(316002)(4744005)(71200400001)(7696005)(8936002)(110136005)(66476007)(66556008)(54906003)(26005)(186003)(8676002)(5660300002)(52536014)(38070700005)(53546011)(38100700002)(508600001)(2906002)(107886003)(86362001)(33656002)(55016002)(9686003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bW40TjFvVkdILzhSajFDWVhzK0JuK01USm5vWkRURU5qcTBqdkxpd0k4TzhO?=
 =?utf-8?B?SmxqMjhTN2lGcS9vcXhwQXJmUGFobERtQTBWOVRVRlFVSDJ3WmJOdXdNcEQx?=
 =?utf-8?B?Y1FhQWVhWFlteklZaHdnbzdMUFJ0Z3ZJclZlWkYxbWROaUVuYmQxRFhkanhR?=
 =?utf-8?B?OTE4Zk55OXVCem92RTdvamdQWFlvNCtWUHRUalN6Zmc0bnhrZGJsWncyTEg4?=
 =?utf-8?B?VlM3MGhaSThBRWFGSW9JMGxoSGFYNGViYWZXVGdQbzJ0Z3lKNFFZa2w4WHhP?=
 =?utf-8?B?R3hka1VHZDBuNWdiY0toaCtyS3FkQVJ4UVdnbkt4aHcxMUxnbGlpdzdvcnc2?=
 =?utf-8?B?TmZBQUR5T3kraUJJUnU2aVp6Q1U5M2dQeE9mN1lhSnhhcFJIeUJHVXVYMldj?=
 =?utf-8?B?cXFuakRqTmkxV2M1ZmxMMUtYc1UvRXBsc0RkQlBUMnFOcnRWT2ZLMmlDS2tB?=
 =?utf-8?B?Z2NkRmEvL25YRXpEMGRKSzBxS2VRVWs4aUJxR1pZN1Q4NDl1SWNRbjhkblYy?=
 =?utf-8?B?TVlqZjRTbVV4R2NOc3ZmT2wvUXVVb2x6UnZoSlVwL2ZCRElrdHlSdS9HZG5i?=
 =?utf-8?B?ZmtrYXpKZlhyaFBWZWZEMTBFeW9IZGRnbDJhUFVTQ2M1Tlk3cElOOXhxVW96?=
 =?utf-8?B?UXJNYyt1M0xScGw1bG4zOHh5a085dStpMlRxdTNXbGpTNDdDaHN5Zlg4a05W?=
 =?utf-8?B?ODNIUE9MbzdOUSt5bVhMNDhCUm9TRFNWUXg1U0VTV0FWM3BMdUpKY1A2ZHJX?=
 =?utf-8?B?WU5HNnBhN09kNTl1NWR6d3p3RzZYdU1nblhwbCtuVkVPMGlOcFB5SEdiUUpa?=
 =?utf-8?B?U2xSNm8yK0x4YjBIRVR6Q0Q2QktFbVRRemdNZ1Bkd2tZSFQrc0dEaHZiQlJR?=
 =?utf-8?B?andsNm1lVnRST04yUVFJbWR6cVZhb1JCU0drM2xmSW5EN2o2RXBZZHJrTXZm?=
 =?utf-8?B?L1E0dE5nb1krTjRxK01uR1RROXlSM3FFQWRBYnd1M1g2VWZqVFdNQUdHMnVY?=
 =?utf-8?B?OWVEckJrRm45NjZUNElaUnc1SjMrZC8xN05SbzVaNjUybzFoSnlmeDExWEdJ?=
 =?utf-8?B?c2JIODNzaDB4L3RQckJOR0sxVDNoeGFtMGNBTXVJM2psOGtzOXl1M1dMZ0c2?=
 =?utf-8?B?MTR0dkI1UlNyMnRNZ3BYSDFmaHB2RUZpeVhTWk5nMkVyb3N5anA1bDljdEpq?=
 =?utf-8?B?ZmMvbzIxZUxYK1pGWGRxdS8wSHhMMXNpUmc1dm5uNENzV2NMSTNUazB0T1A5?=
 =?utf-8?B?U1l3NGtBL0lYWUd5OEN2alNFKzRGUFBDY3N3elo4WEhmWlpZVUVUdWtORis2?=
 =?utf-8?B?OUVuTGV0aTZiZ3NQN1pQVW5xNGJUeTIvNUtsZ2FWTUtNdlBQckFqNHdlalNV?=
 =?utf-8?B?VVZtM0hXVkF0R0NwVS80ck5XalVvcGM1QW41NUZIdHVib29LZjViL0g3WHho?=
 =?utf-8?B?R2ZmNmlsT1RhM0hzUnM1SjZoNlJMVFdmcVZGWnNzS0Y0S0pMTWw0S1BJQzdN?=
 =?utf-8?B?R1ZCOHl0VnRtZzVjU20xdklOWnlWNUx6cTZVMnc4d3lndDFIRGhuRTdJRHA5?=
 =?utf-8?B?ei90SkxRUTlRZEVCRzV0WVdaZ2pjdXJaV3VId3NQNi9mckFueVlpV3JWVEdJ?=
 =?utf-8?B?bitWamJseUUzRC9NYWlOUHpSZFRFclhmZlVFeGZOdElQbk5rUHVTdUxTQUZZ?=
 =?utf-8?B?cjlFelNMUk1hR1BNL0tHaDIxek1tU0VoZlAyc0ZoTzRnUjJaNE5yVzhObnJK?=
 =?utf-8?Q?h80Ns/Ww6KhNeZDP1GWJ+bSHbw3iVYh0nbtF0qc?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad3d1d5b-5dcd-4e5d-b30c-08d956b2cdf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 19:13:40.4263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QgH0TqdLYywhrsypgOHXJmRjDrGWeWXjqLUcxYZRcA0SLfneU4IBkSKwsZFtFD6xKiOnFMezmHwTZ147TbRif7Z6CrmBjV1+yBpTxDiOozw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IHYyIDMvOF0gcmF2YjogQWRkIG51bV9nc3RhdF9xdWV1ZSB0byBzdHJ1
Y3QNCj4gcmF2Yl9od19pbmZvDQo+IA0KPiBIZWxsbyENCj4gDQo+IE9uIDgvMi8yMSAxOjI2IFBN
LCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4gVGhlIG51bWJlciBvZiBxdWV1ZXMgdXNlZCBpbiBy
ZXRyaWV2aW5nIGRldmljZSBzdGF0cyBmb3IgUi1DYXIgaXMgMiwNCj4gPiB3aGVyZWFzIGZvciBS
Wi9HMkwgaXQgaXMgMS4NCg0KPiANCj4gICAgTWhtLCBob3cgbWFueSBSWCBxdWV1ZXMgYXJlIG9u
IHlvdXIgcGxhdGZvcm0sIDE/IFRoZW4gd2UgZG9uJ3QgbmVlZCBzbw0KPiBzcGVjaWZpYyBuYW1l
LCBqdXN0IG51bV9yeF9xdWV1ZS4NCg0KVGhlcmUgYXJlIDIgUlggcXVldWVzLCBidXQgd2UgcHJv
dmlkZSBvbmx5IGRldmljZSBzdGF0cyBpbmZvcm1hdGlvbiBmcm9tIGZpcnN0IHF1ZXVlLg0KDQpS
LUNhciA9IDJ4MTUgPSAzMCBkZXZpY2Ugc3RhdHMNClJaL0cyTCA9IDF4MTUgPSAxNSBkZXZpY2Ug
c3RhdHMuDQoNCkNoZWVycywNCkJpanUNCg0KDQo+IA0KPiA+IEFkZCB0aGUgbnVtX2dzdGF0X3F1
ZXVlIHZhcmlhYmxlIHRvIHN0cnVjdCByYXZiX2h3X2luZm8sIHRvIGFkZA0KPiA+IHN1YnNlcXVl
bnQgU29DcyB3aXRob3V0IGFueSBjb2RlIGNoYW5nZXMgdG8gdGhlIHJhdmJfZ2V0X2V0aHRvb2xf
c3RhdHMNCj4gZnVuY3Rpb24uDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8Ymlq
dS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IExhZCBQcmFiaGFrYXIg
PHByYWJoYWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT4NCj4gWy4uLl0NCj4gDQo+
IE1CUiwgU2VyZ2VpDQo=
