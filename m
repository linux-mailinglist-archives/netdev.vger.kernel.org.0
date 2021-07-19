Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C463CCDDC
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 08:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbhGSG2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 02:28:39 -0400
Received: from mail-eopbgr140104.outbound.protection.outlook.com ([40.107.14.104]:3271
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233048AbhGSG2j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 02:28:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mz28AXi5QYARwcBfRj6plVzCqGk8ANKkSNi4za6XqnP08n20FjlI1xPoQQi9ZTSrop8onOlXSTzUWJhqb8ZB18W0tB2azuQq3WLxsWi0DJww3upUpMKMtgmfMPfi8oppWsmeBrlrw6Wjw0/4BuHcmLC2Ya1uoqP8ZGYU100wmUt7pg3HNLMm6fw89oIKVFS4lNOsS7bpzQh4ElIO560jiIkHMeHQ/QM1Ivq18BawEJjv9iZ0rElqclJWwENDqx5idskkmFzCb9f0LGeyV/U/jIKDxQGNGTsp/JCeOgJtyviRfmuibPUjNzgPPSQoB6olCHYivQ8pU9597WpB/Z+/sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJJymK5hgIke43evJZabltsIVNUMIOLahRqeCPUz28U=;
 b=WXM2BMFooISVGgjQV01X+ho8WlRmC5hwuvvGj2/M69ZooPmPVizVMeqSdq4qWLDYRuOuT4zcG6TmVpHRL8+wcLgrecPFIQym62QFh1YrY07GJqzJRhbmszVAOfEMEKFVE/IVhkVxyOQXUTKHFkGHffH18FgfUCAXsdujUzKYo1AQ7pFSz4ERi0OXpUaLgVkWE4s1qwih/0kDVATlsgI3IRUFUUn6VWsI4lyagLw8Z2NGq7CdHVrSoSqhwIk0ZllJR1aBHiMKzzK7TcF+myAYmJmnMOFLrdmvurH89WpRaQT0V6SNJ93fj6XVkEek8LgzQlacuFiOkLlYpqyKy/VvFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hbkworld.com; dmarc=pass action=none header.from=hbkworld.com;
 dkim=pass header.d=hbkworld.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hbkworld.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJJymK5hgIke43evJZabltsIVNUMIOLahRqeCPUz28U=;
 b=n6mTibb5vHZohfKEJI6sjRyzAWQpR3Nq9/IQ6CnUkx7OTDpoPIiQ+Ty0pZ8OKAsXkF3Izbqn3E12HIbtDFo/m4rDmVIHu4WR/AleQfwmwLrutEdcMKTr5h2BrETd1dOFI8J+OnzT9E/QpRM32Uzdnjne47bJToXD4imB0Tm1TC55D+JKw/nk3KJDUJGmnB7pPIzydGZu0OWFJHC51beI7SvNPMzHNB2Mx6IkfSXBySxCUEIIffXpggJ0q5kUi+CQyqLeDqzlTqBCkluwlRrN47bDCOhJ+ZPBgUUfWoieX9PaPnUXPQDKap6fHftyINo6AvkbHyWRdTv/up1yrQlsFQ==
Received: from AM0PR09MB4276.eurprd09.prod.outlook.com (2603:10a6:20b:166::10)
 by AM9PR09MB4562.eurprd09.prod.outlook.com (2603:10a6:20b:2d6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 06:25:37 +0000
Received: from AM0PR09MB4276.eurprd09.prod.outlook.com
 ([fe80::4d88:bf9c:b655:7a92]) by AM0PR09MB4276.eurprd09.prod.outlook.com
 ([fe80::4d88:bf9c:b655:7a92%7]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 06:25:37 +0000
From:   Ruud Bos <ruud.bos@hbkworld.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next 0/4] igb: support PEROUT and EXTTS PTP pin functions
 on 82580/i354/i350
Thread-Topic: [PATCH net-next 0/4] igb: support PEROUT and EXTTS PTP pin
 functions on 82580/i354/i350
Thread-Index: Add8Za/fDdMT2JqQRJGsY63N4Gs2lA==
Date:   Mon, 19 Jul 2021 06:25:36 +0000
Message-ID: <AM0PR09MB4276D9CCEBD1400A884AFB06F0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Enabled=true;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_SetDate=2021-07-19T06:25:36Z;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Method=Privileged;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Name=Unrestricted;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_SiteId=6cce74a3-3975-45e0-9893-b072988b30b6;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_ActionId=38ee0f8d-635f-4bc6-96cd-79f6eb34da54;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_ContentBits=2
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=hbkworld.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dee78b1c-ae5d-41ed-605b-08d94a7e05a9
x-ms-traffictypediagnostic: AM9PR09MB4562:
x-microsoft-antispam-prvs: <AM9PR09MB4562EA43A60FA945D2E21FECF0E19@AM9PR09MB4562.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MzQVGO1l00CnJYo++YEuWwz8EM1gE45FN+ImlGoXdiz7Zd5/9sqvABRaTwKW/pu6JDWuv8f1IbUynLTX+EBdE8IDT3Q+JdC30fr0Szu9uy//Wf50dyav5RA1ofPWlvjB5o+2M1QfyTcyeBGQa+L4IC5QQDii/XyooURi/Lm7wfy7zoj2Da82FUKYH04hoQ9jnGcExOV4JtAH/rN4LMeVJsLvCmLOBGTkANp3O8+NMPdJ2yftwA2iSKCCOEVvv3YpUVZt467SUxngDrd5G4Rj+KyAsnDfr1pfHkg8rgbCdbgan3xYtMlmNlOfhybGlkINe1qEJnhT3kOfb5dcJ5rPiv1g9IiJmqY5o0tGaqGP3AwTTA25TWlfiLLGYNdacUpccDGomtIuNT0vccU+BErEFmAX4xERQdPbs8MzTiuqbv2VZSm0QXmMZOMmHp++fcFuCLvsUkNgu3xMJixoYHaNrdZq7gTkmqNR19H9kbD2/VcCaag+OBTrsiWVv/N/peZJ1AKu1/d2erNcC6+M+S7780p0zNcwFXD98VUP/jr4zB1ALIa9JpwJJHMASkMlSIOrvifSXGrS/DFN6OM1QWBChXPTKYoMJRR88pLjNlhHxy1GZAh1jsOWsx5bLEp1ec3a1CkPjijKmVVSOyGINrimNFEITJb8TcoACp23w6+PqCsZTSrgemUIfpH/PJLaMQanttVsjzyX/2pbZDLZbDHriA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR09MB4276.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(396003)(376002)(136003)(366004)(8936002)(8676002)(5660300002)(64756008)(52536014)(6506007)(66476007)(66446008)(76116006)(66556008)(7696005)(83380400001)(26005)(6916009)(15974865002)(38100700002)(55016002)(66946007)(86362001)(478600001)(186003)(9686003)(44832011)(2906002)(71200400001)(316002)(33656002)(122000001)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UnJLUzFhZU9UaTFSWkRGdEI1WXFNTlhueTVIcFgrSThCZG45Q2ZiUGgveDlR?=
 =?utf-8?B?elJvY0w4NEd5cDZtai9YOFRTTjdHVFNCTWZuQk1RUHh5R3l6WXI0UUlXMTdT?=
 =?utf-8?B?KzNINUN6amxSUnFzWnFoRzY5dWxhWk4za01ySmphVm9WT052YkRyMzdnRnRq?=
 =?utf-8?B?SXdCaCtRK0FDbEdNSUNHK3FLMDN2RitLTmFtQklGSzdBNUU5TkdPbDQ5NlZ1?=
 =?utf-8?B?U1J5dnNodzJxS1YwaEYrN3ZPRHgxRUdVK1ZlWDAwcUhjR2ppM1lzRno5R0pD?=
 =?utf-8?B?ZlFadllFSGdDSEZHOUZQSTdFZExsejRBenoxLyt0K29vT2FjOVZ2WTFlUDRL?=
 =?utf-8?B?dGxNaW42d3pLMHZWVmpLSmJ1VW5Sc2Z6R0ZIVEVFdUIxY0dXVG1jQWYzNnFG?=
 =?utf-8?B?TCtnM3lLZVdtUWJsVlZLTzZHK3dpS1VYT3V5SXBYZWFKOURLd2pmVFRldm5j?=
 =?utf-8?B?ZGhhRlo0S3ZZME94Nm1ONVRSL2l1S3BmTy9kOWYvck1TV3pBR0I0WTl2SHFa?=
 =?utf-8?B?ZG5uU2FvaHQwMkx3OXBocGN2VCtoRWdGSWxoeHljK2ZHRStrK3RoQ0pYaXFt?=
 =?utf-8?B?QnVlZVlDUmR6Sm9tcTFhQlN0R3A0WS9SaTJxYWM0SC9QdVhOVkRlczVxd0Ix?=
 =?utf-8?B?bVhPMnhUQmp4ZCt4VjhrNzdoYjFJUTZwTWRqdWRtYkhBR2sxK0pLTDExTHY0?=
 =?utf-8?B?NTErUGdqSGtpR3hMNnYzb0hkdTJxMHMvVFoxWHlvZVNyd25zSGdOQU5heWp4?=
 =?utf-8?B?WUFZeWluNUhUVFpEb2tTOTl5T01XZHVJWjhtMkVXY3hNcHVmemZpQlhjL0cz?=
 =?utf-8?B?blJBOHh6ZStNMGhDTXNzbk81eWVKY0VRTlpLT0NFZ05nVU1JWGNwSjEwZnJG?=
 =?utf-8?B?S0dXamU3VENRQ3NUQ0d3UDNENVgxY0lvUmpGeUNRWEZnc04zaENnT0JDUEsr?=
 =?utf-8?B?ZW9uK3FuZVFQdDZEMmJZaFBHQ3g0R1U1MTJ1aDNnOUxLYkQ2a3NReGt1bnZn?=
 =?utf-8?B?L2pMQm8yUVk4Um1MM0dtWngvTHV4K2JBTkhVT3NNVythS0hKcjFvNG5rUGZH?=
 =?utf-8?B?RmgxQ3JhY3MvQXhUK0xic2ZhUmtnMVNyelNHNlVIWS9POU1VTkRKRVEvQ3lN?=
 =?utf-8?B?dDBOZ2Q5ejdIcy93SlpBRGZDVWR4WXhuTjJ4V2p2a3BNY3pOQXlsYWFGU2hs?=
 =?utf-8?B?eHNqbXBFVTV2aUtSVTF6WnRQUHcrQ3c1cFdRUy95akcwSCtpbDY2K0ZHY1Qz?=
 =?utf-8?B?NGtNNy9kYVNKN2lmeU1MdmZhbGVldzZLWTBiaEViNU1qS3NHUTBrdEdmQU9r?=
 =?utf-8?B?TW16L3NtL0tHaXBmcDRJT2lvcVJwUmJMckMyWWVOc0NMTGxYLzMxUU9nR2Nk?=
 =?utf-8?B?M0dVZVJuTndPNzVmc3Y1NlQ4ZlFFZ2NCYTZEUTV0QVhzTHdreHJUMjNNc0V5?=
 =?utf-8?B?K1lWRXRIV1Z0VEhxWDBONVBRb1lZTkU1OEQraFRxbEtyUDRqeDlJVFhGalQ3?=
 =?utf-8?B?ZEVjNlMrTHVsajBQdGJReDNyMllVbFMvRkd6MHhNc25KRHZ5cDA3ZStOZ1hL?=
 =?utf-8?B?MzZWQVd4alBFVm13eWFQNDVFS3RPdGxiRm9nL3E1KzExZStFaUp4a1R0MlJo?=
 =?utf-8?B?TzIvYlFhT1pLNVBUQmV4REhyQmRBeEdVVSsrY0lWcFovOTBZWHVCbVdSMVZk?=
 =?utf-8?B?cXN3a0hJNUdqQUN0dHZYU0s1bE9wQTJsdnFTVmMyeXNNOEYzazRkbWVVYTUv?=
 =?utf-8?Q?Wp5sbwBP3PdWsxvVQI=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hbkworld.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR09MB4276.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dee78b1c-ae5d-41ed-605b-08d94a7e05a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2021 06:25:37.0160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6cce74a3-3975-45e0-9893-b072988b30b6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i/Pmk8kp+oToda1wYcW6i4evgzEbszy6le9NAXTR6YDO5n6TV0iHgt9LmK6W+/NU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR09MB4562
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIGlnYiBkcml2ZXIgcHJvdmlkZXMgc3VwcG9ydCBmb3IgUEVST1VUIGFuZCBFWFRUUyBwaW4g
ZnVuY3Rpb25zIHRoYXQNCmFsbG93IGFkYXB0ZXIgZXh0ZXJuYWwgdXNlIG9mIHRpbWluZyBzaWdu
YWxzLiBBdCBIb3R0aW5nZXIgQnJ1ZWwgJiBLamFlciB3ZQ0KYXJlIHVzaW5nIHRoZSBQRVJPVVQg
ZnVuY3Rpb24gdG8gZmVlZCBhIFBUUCBjb3JyZWN0ZWQgMXBwcyBzaWduYWwgaW50byBhbg0KRlBH
QSBhcyBjcm9zcyBzeXN0ZW0gc3luY2hyb25pemVkIHRpbWUgc291cmNlLg0KDQpTdXBwb3J0IGZv
ciB0aGUgUEVST1VUIGFuZCBFWFRUUyBTRFAgZnVuY3Rpb25zIGlzIGN1cnJlbnRseSBsaW1pdGVk
IHRvDQppMjEwL2kyMTEgYmFzZWQgYWRhcHRlcnMuIFRoaXMgcGF0Y2ggc2VyaWVzIGVuYWJsZXMg
dGhlc2UgZnVuY3Rpb25zIGFsc28NCmZvciA4MjU4MC9pMzU0L2kzNTAgYmFzZWQgb25lcy4gQmVj
YXVzZSB0aGUgdGltZSByZWdpc3RlcnMgb2YgdGhlc2UNCmFkYXB0ZXJzIGRvIG5vdCBoYXZlIHRo
ZSBuaWNlIHNwbGl0IGluIHNlY29uZCByb2xsb3ZlcnMgYXMgdGhlIGkyMTAgaGFzLA0KdGhlIGlt
cGxlbWVudGF0aW9uIGlzIHNsaWdodGx5IG1vcmUgY29tcGxleCBjb21wYXJlZCB0byB0aGUgaTIx
MA0KaW1wbGVtZW50YXRpb24uDQoNClRoZSBQRVJPVVQgZnVuY3Rpb24gaGFzIGJlZW4gc3VjY2Vz
c2Z1bGx5IHRlc3RlZCBvbiBhbiBpMzUwIGJhc2VkIGV0aGVybmV0DQphZGFwdGVyLiBVc2luZyB0
aGUgZm9sbG93aW5nIHVzZXIgc3BhY2UgY29kZSBleGNlcnB0LCB0aGUgZHJpdmVyIG91dHB1dHMg
YQ0KUFRQIGNvcnJlY3RlZCAxcHBzIHNpZ25hbCBvbiB0aGUgU0RQMCBwaW4gb2YgYW4gaTM1MDoN
Cg0KICAgIHN0cnVjdCBwdHBfcGluX2Rlc2MgZGVzYzsNCiAgICBtZW1zZXQoJmRlc2MsIDAsIHNp
emVvZihkZXNjKSk7DQogICAgZGVzYy5pbmRleCA9IDA7DQogICAgZGVzYy5mdW5jID0gUFRQX1BG
X1BFUk9VVDsNCiAgICBkZXNjLmNoYW4gPSAwOw0KICAgIGlmIChpb2N0bChmZCwgUFRQX1BJTl9T
RVRGVU5DLCAmZGVzYykgPT0gMCkgew0KICAgICAgICBzdHJ1Y3QgdGltZXNwZWMgdHM7DQogICAg
ICAgIGlmIChjbG9ja19nZXR0aW1lKGNsa2lkLCAmdHMpID09IDApIHsNCiAgICAgICAgICAgIHN0
cnVjdCBwdHBfcGVyb3V0X3JlcXVlc3QgcnE7DQogICAgICAgICAgICBtZW1zZXQoJnJxLCAwLCBz
aXplb2YocnEpKTsNCiAgICAgICAgICAgIHJxLmluZGV4ID0gMDsNCiAgICAgICAgICAgIHJxLnN0
YXJ0LnNlYyA9IHRzLnR2X3NlYyArIDE7DQogICAgICAgICAgICBycS5zdGFydC5uc2VjID0gNTAw
MDAwMDAwOw0KICAgICAgICAgICAgcnEucGVyaW9kLnNlYyAgPSAxOw0KICAgICAgICAgICAgcnEu
cGVyaW9kLm5zZWMgPSAwOw0KICAgICAgICAgICAgaWYgKGlvY3RsKGZkLCBQVFBfUEVST1VUX1JF
UVVFU1QsICZycSkgPT0gMCkgew0KICAgICAgICAgICAgICAgIC8qIDFwcHMgc2lnbmFsIGlzIG5v
dyBhdmFpbGFibGUgb24gU0RQMCAqLw0KICAgICAgICAgICAgfQ0KICAgICAgICB9DQogICAgfQ0K
DQpUaGUgYWRkZWQgRVhUVFMgZnVuY3Rpb24gaGFzIG5vdCBiZWVuIHRlc3RlZC4gSG93ZXZlciwg
bG9va2luZyBhdCB0aGUgZGF0YQ0Kc2hlZXRzLCB0aGUgbGF5b3V0IG9mIHRoZSByZWdpc3RlcnMg
aW52b2x2ZWQgbWF0Y2ggdGhlIGkyMTAgZXhhY3RseSBleGNlcHQNCmZvciB0aGUgdGltZSByZWdp
c3RlcnMgbWVudGlvbmVkIGJlZm9yZS4gSGVuY2UgdGhlIGFsbW9zdCBpZGVudGljYWwNCmltcGxl
bWVudGF0aW9uLg0KDQpSdXVkIEJvcyAoNCk6DQogIGlnYjogbW92ZSBTRFAgY29uZmlnIGluaXRp
YWxpemF0aW9uIHRvIHNlcGFyYXRlIGZ1bmN0aW9uDQogIGlnYjogbW92ZSBQRVJPVVQgYW5kIEVY
VFRTIGlzciBsb2dpYyB0byBzZXBhcmF0ZSBmdW5jdGlvbnMNCiAgaWdiOiBzdXBwb3J0IFBFUk9V
VCBvbiA4MjU4MC9pMzU0L2kzNTANCiAgaWdiOiBzdXBwb3J0IEVYVFRTIG9uIDgyNTgwL2kzNTQv
aTM1MA0KDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9tYWluLmMgfCAxNDEg
KysrKysrKysrKysrLS0tLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2IvaWdiX3B0
cC5jICB8IDE4MyArKysrKysrKysrKysrKysrKysrKy0tDQogMiBmaWxlcyBjaGFuZ2VkLCAyNzkg
aW5zZXJ0aW9ucygrKSwgNDUgZGVsZXRpb25zKC0pDQoNCi0tDQoyLjMwLjINCg0KDQpVTlJFU1RS
SUNURUQNCkhCSyBCZW5lbHV4IEIuVi4sIFNjaHV0d2VnIDE1YSwgTkwtNTE0NSBOUCBXYWFsd2lq
aywgVGhlIE5ldGhlcmxhbmRzIHd3dy5oYmt3b3JsZC5jb20gUmVnaXN0ZXJlZCBhcyBCLlYuIChE
dXRjaCBsaW1pdGVkIGxpYWJpbGl0eSBjb21wYW55KSBpbiB0aGUgRHV0Y2ggY29tbWVyY2lhbCBy
ZWdpc3RlciAwODE4MzA3NSAwMDAwIENvbXBhbnkgZG9taWNpbGVkIGluIFdhYWx3aWprIE1hbmFn
aW5nIERpcmVjdG9ycyA6IEFsZXhhbmRyYSBIZWxsZW1hbnMsIEplbnMgV2llZ2FuZCwgSm9ybiBC
YWdpam4gVGhlIGluZm9ybWF0aW9uIGluIHRoaXMgZW1haWwgaXMgY29uZmlkZW50aWFsLiBJdCBp
cyBpbnRlbmRlZCBzb2xlbHkgZm9yIHRoZSBhZGRyZXNzZWUuIElmIHlvdSBhcmUgbm90IHRoZSBp
bnRlbmRlZCByZWNpcGllbnQsIHBsZWFzZSBsZXQgbWUga25vdyBhbmQgZGVsZXRlIHRoaXMgZW1h
aWwuDQo=
