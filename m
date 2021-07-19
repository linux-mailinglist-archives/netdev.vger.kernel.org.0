Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8853CD3F0
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 13:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbhGSKwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 06:52:34 -0400
Received: from mail-eopbgr70125.outbound.protection.outlook.com ([40.107.7.125]:39582
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232156AbhGSKwd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 06:52:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENP2tu6kQRAMd4C8heSKJBM0xfdU5Qzj+/FprZEC0t1aGwP+C61k2Umek0QY7N0C6NUcT34ZAA3KcAbAiIMSLETnuzS773g+ZVQjJvfThovSHQQczAnGnpnILo3fiW2cpsKt564LBfcvktlHdocwD8AFIonrqiIdabqD9k96cUhy+dIeblRJ29OTv12TVvmkAB7xuWHaAg/jILAuWf+hcTqIwQNf5BSjuyyOT2u66YXFgBaeuWJWEBvLjlM9yMAnKADVxSrnWeXE+wMjja8q4NISJYux3I94bCsEHAqdLbvEAr8iz9iuw4ZG27YSYXSsp1MQfxsl6m42jblIga26Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmeK6id2BD8sCn8jF2V95bbGZtML7jgHDIZWkfM+dEA=;
 b=UG2qD1E+1Z+44EQm1Jawmi3S/hcFuuCD3SwED5isWLkXcX1z4cu1EnF5eP8jIzS19HvN5XoMbCILP29kvINUi5BsAz72DJweKVpCt8EVFTgoPDSgtxpHffDb4dMFTdJzcZkec8rj4EiFSOcD6eq8YaESJTR4n5ppxjkqFWvO9ASVegDfG9g8fAxb3Mgj31jdgf3BxSZsw84w/uL/h3vWFvsRuFIbDKUH2+R3WixXun4T+KuJCqIprSiGZ+VMh2neK5FPJyysICFWGKjgV3TL5lbLUiaH2yWInzCYkzMrcnlxKSaOEtMzePO/3VAG0x3McVsPZr9rqGBlxrnVZtoEoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hbkworld.com; dmarc=pass action=none header.from=hbkworld.com;
 dkim=pass header.d=hbkworld.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hbkworld.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmeK6id2BD8sCn8jF2V95bbGZtML7jgHDIZWkfM+dEA=;
 b=f2vCY0bzJ90BImbQ/uHDKbmxQUJnWPI6/vm80RADOE//t0fF67HSKUQzJvTueZVOurXk2sRRPNuy9tE6u6jtzRqSSI/Lm9Yf0+46QB4ajxSLNDjoIEUfXiHpZXRuVOPOubdM5YPDJQXSuqCT26EQ6PI63axotylIoKbwF8o2W5N4MWfGLnCHnWtwYlskUYZWwAs2tFgNd5/a4jP1ZfB08YaUAEgRtviK1IrEOUOnQeibfgH2CMDk+/v+Dj3jVLKmtA3HKhY1IVWvH78MTUcIhAtzXsBSVL+NGoWzFzT+R17hQDYzcnjtshWT2EWht8OWlp2TlOh1cSz4N96r6TSfew==
Received: from AM0PR09MB4276.eurprd09.prod.outlook.com (2603:10a6:20b:166::10)
 by AM8PR09MB5228.eurprd09.prod.outlook.com (2603:10a6:20b:3db::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Mon, 19 Jul
 2021 11:33:11 +0000
Received: from AM0PR09MB4276.eurprd09.prod.outlook.com
 ([fe80::4d88:bf9c:b655:7a92]) by AM0PR09MB4276.eurprd09.prod.outlook.com
 ([fe80::4d88:bf9c:b655:7a92%7]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 11:33:11 +0000
From:   Ruud Bos <ruud.bos@hbkworld.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: [PATCH net-next 0/4 resend] igb: support PEROUT and EXTTS PTP pin
 functions on 82580/i354/i350
Thread-Topic: [PATCH net-next 0/4 resend] igb: support PEROUT and EXTTS PTP
 pin functions on 82580/i354/i350
Thread-Index: Add8j5wx8XMO0pl3SxeqH60/gUl7Xg==
Date:   Mon, 19 Jul 2021 11:33:11 +0000
Message-ID: <AM0PR09MB42765A3A3BCB3852A26E6F0EF0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Enabled=true;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_SetDate=2021-07-19T11:33:10Z;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Method=Privileged;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Name=Unrestricted;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_SiteId=6cce74a3-3975-45e0-9893-b072988b30b6;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_ActionId=4146b0c6-0467-4ce5-b929-2190d04919d9;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_ContentBits=2
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=hbkworld.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c8f88e1-4304-46ab-28ef-08d94aa8fd72
x-ms-traffictypediagnostic: AM8PR09MB5228:
x-microsoft-antispam-prvs: <AM8PR09MB52287BF7504121B44F21519BF0E19@AM8PR09MB5228.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IdCEfpnfpWKWecKhFKa1qTtmFK7708YKbZKK/TQGfh+fwYRPF4k5RFJVzKxrrWM6QGJYdSEqvVOuSnKxRRA/9v7qa4c5P27BfRkLyyV8AmsSX1MwZN0GLU7fNw3G07ZNp7XkqZrplgcHw3aWl1EXBvo6S6CeihaNT5/76kWvg+ybJKToKRUUbXVaztwpUUmvY43sUog05skKebrGaWBao+Imw9BBD4vYFtjUQ+F+8aNrtl/NFCUyy/MkjqOmtDpBA6EgWkaBp3YtvWR2Tbkc9R4sssQQAjZZ22GCPF2bKfrlGbE00gI7MNv1+E1iEZjiyynrTqb3kNOkJU9YXHqtabFFcMUrR9+5Ae3+lYG5dNLiQCvhBhGpATliQgCjIWdSC/kbu3oLzfAN84uhH+QkstPtBeXxATiOB3R9bAvD5BdKq9gXyvskl6HvjCs13q1per1BTb3jBjBPO+vgZe9ue+FRAH/eCtgpGpwQWL3PVQbjxC3ZZdUWUrNrwO8sTVFm2dYL4tryKvv7FDnxqxDbnmre4XI5FRIpR42HD4eHrd96++63bTaR9Zu37wPcjWhsdKr3j4HHHz7HI32b5ztvsfoKsTwB7VxoOT89Ti5xcdrs/RJvNfus3MFqIa88PYWbyFrRm6mb1w9waNzy6JoCU0brj7aINZJ9KT9oZsOgzfoM4GMWiSZQlsR3c0lOLBUqcBgqDFuP8ZijGrzgvnmHbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR09MB4276.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(136003)(396003)(346002)(376002)(8936002)(8676002)(5660300002)(6916009)(55016002)(33656002)(52536014)(83380400001)(38100700002)(2906002)(44832011)(122000001)(26005)(9686003)(54906003)(86362001)(186003)(15974865002)(66446008)(64756008)(66556008)(66476007)(4326008)(316002)(71200400001)(66946007)(478600001)(76116006)(7696005)(6506007)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzgrT3liQm5ncCt0bHVHRDZiL3A0aXBDR2QyQmlaUUp0MjU4dzRuMDNCb2di?=
 =?utf-8?B?b3dJazJ6dDg4d2QydmhvQjB3ZWJ3S1lHaWVGWk9tUFFNNktoRjJDU21SN0t2?=
 =?utf-8?B?QldUVUIxNEt5Tlh4ak1jeEtVazV4ekZLVnJJbWl3UnpseVBBaTdLTW1hZUov?=
 =?utf-8?B?eWxhbEF2Ykc4L2ZVZnpGSlROY0V2Y21Md2lYNDdWRGluSmdTNGgreG1hT3pW?=
 =?utf-8?B?Y2hXYXZoUjBzZWw3K0Vyd05PWGpkSDJVc2NIaGlkM3VhTTk4dk8za2xDTHFx?=
 =?utf-8?B?SnRLYkQ3Mml0bkJaNnp3bVNvVlBTUnAySDZieHdrcHFnTXZybmpBc2JxOHg5?=
 =?utf-8?B?Q1ZjYzVLcDNuSjIxbVNaK2pURzBtQWp2QXptTUpZU2hhRDZtRkpXWGpNZ2R6?=
 =?utf-8?B?akFqMGxxSE5tcmlwSFl1dnQvdndXbHV6VXBhak9pcGttVEdCN1dtZ0VNWERv?=
 =?utf-8?B?bzB4a0YvR1RjV3gzczVycXlzM2p6MC9ORXMvbTJWZE5YOEVnZXFVakwra09n?=
 =?utf-8?B?NERPbks3ditPSnRGaHUvcmF2c2FsRFNtOTJGbXBLOVNJa2cvZmgycERELzQ3?=
 =?utf-8?B?aDIyNU1WTkFEK3ZsNzBkSkVrR0xEUnJMZW1DaEF3dEtUb1J5c2ZESEZ4MVo0?=
 =?utf-8?B?d0ZqYjdoTXdBdFkxU0RJd1NEbTVRVkE1T3ppSzlrSm5jSnNydkJoVE8rbUpo?=
 =?utf-8?B?T1d2R1ZnUmI1S1Ixc3pTOElDbFVZK0hjTmQwT1NMUVcwMTd1eVlRTGRNS2Yy?=
 =?utf-8?B?WjVJV1Z0cmU1RmcrY3NKelhWbkVoYWsxTk5oU3FyQXZPNzN3V2hRZDZwRitE?=
 =?utf-8?B?OGN4STNoNHlRNURvSnZ6NTJlWUpDZHdySndEc0ZjaGlOTFRyMU5aOFZDVW1u?=
 =?utf-8?B?T05DNHNCU3p3RHpKMGY3RXNqbko5MUVKYUI2bE9nSlhCTGVBYTZTUUJ3aTh6?=
 =?utf-8?B?d2M5Z1FIeHkyMVdXd1JxNEUxbWJrNkxjdWVDRDhiR1lRREVkZ0RMZW9UcUNt?=
 =?utf-8?B?UUg1cWxZNFgrVi9LTFhvUU5VSjZWUUpPY3FBOUFuQ3VDR2RJSkZIN05mMzZ0?=
 =?utf-8?B?am1nYXptdTJmbWVoSzBPUkVsODhYK3JPNHJMMzFYRVRZd2hUUFNoMnBaU3V6?=
 =?utf-8?B?ZEJiTnRpRVN1cDlGTEFUNXdTUHErTFg2MHNrM0tubk8vQ3dNVXE3N2RlUG5P?=
 =?utf-8?B?a0F3UHdXWWFtdTF0NXNZamJaVXJkRW05VEQ5WVFweDA3QUNaUkxPSkVFN00r?=
 =?utf-8?B?dmpUR0YwSXdScDFLOEZHKzVGcTFrYnFwTkQvQzZMQVRxQ1V3dTd0UGdlY0xr?=
 =?utf-8?B?OEpweDlvbkZJbmR0Zzg4YXAyNHJFRFAwWHhQZHZhRjh5M2FialFDbVQraEty?=
 =?utf-8?B?SDhOMVljNTYwVy8zUXExSEhHZk04YksyOEhodktjT0twd3FqRWFvOEhhb2Z6?=
 =?utf-8?B?M3VyVkRsVkFGZUpKWEVvdjRmQlpHYndweVpuYzd5b1Ewakt0Nk5NZlRnY3pr?=
 =?utf-8?B?SW9pakFhV1lKcitEcm15SVpxMkFhUEFFNzVBWThYeUNEQnlqUHlkeWF0N0E2?=
 =?utf-8?B?dVE0UGRscTVqV2RjcE52VXhLU0p5NjE4Nk56VGwzZjhnZHNMSHY0dkk3bDc0?=
 =?utf-8?B?TDRTZzhxcWdQWWQ2QSs5a0Vheksrekl0TjBCbFBkaUs2SmtGM0x3aUIyZGQx?=
 =?utf-8?B?dElzbFJTbVNqZEVsbmhSYXpQZ3N1ODN5WWY3K1ZwVUxtMG5zdS9kSDIwQjdx?=
 =?utf-8?Q?kZYcHfc83rseUOFcxo=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hbkworld.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR09MB4276.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c8f88e1-4304-46ab-28ef-08d94aa8fd72
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2021 11:33:11.5320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6cce74a3-3975-45e0-9893-b072988b30b6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1jWWUJhzghRqe6EtZVKXCKGp/s2WJg+4aptDjgz0zbONrPrWcFMli5QmyoC94D01
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR09MB5228
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
bWVudGF0aW9uLg0KDQpSZXNlbmQsIHB1dHRpbmcgbWFpbnRhaW5lcnMgb24gdGhlIENDLg0KDQpS
dXVkIEJvcyAoNCk6DQogIGlnYjogbW92ZSBTRFAgY29uZmlnIGluaXRpYWxpemF0aW9uIHRvIHNl
cGFyYXRlIGZ1bmN0aW9uDQogIGlnYjogbW92ZSBQRVJPVVQgYW5kIEVYVFRTIGlzciBsb2dpYyB0
byBzZXBhcmF0ZSBmdW5jdGlvbnMNCiAgaWdiOiBzdXBwb3J0IFBFUk9VVCBvbiA4MjU4MC9pMzU0
L2kzNTANCiAgaWdiOiBzdXBwb3J0IEVYVFRTIG9uIDgyNTgwL2kzNTQvaTM1MA0KDQogZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9tYWluLmMgfCAxNDEgKysrKysrKysrKysrLS0t
LS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2IvaWdiX3B0cC5jICB8IDE4MyArKysr
KysrKysrKysrKysrKysrKy0tDQogMiBmaWxlcyBjaGFuZ2VkLCAyNzkgaW5zZXJ0aW9ucygrKSwg
NDUgZGVsZXRpb25zKC0pDQoNCi0tDQoyLjMwLjINCg0KDQpVTlJFU1RSSUNURUQNCkhCSyBCZW5l
bHV4IEIuVi4sIFNjaHV0d2VnIDE1YSwgTkwtNTE0NSBOUCBXYWFsd2lqaywgVGhlIE5ldGhlcmxh
bmRzIHd3dy5oYmt3b3JsZC5jb20gUmVnaXN0ZXJlZCBhcyBCLlYuIChEdXRjaCBsaW1pdGVkIGxp
YWJpbGl0eSBjb21wYW55KSBpbiB0aGUgRHV0Y2ggY29tbWVyY2lhbCByZWdpc3RlciAwODE4MzA3
NSAwMDAwIENvbXBhbnkgZG9taWNpbGVkIGluIFdhYWx3aWprIE1hbmFnaW5nIERpcmVjdG9ycyA6
IEFsZXhhbmRyYSBIZWxsZW1hbnMsIEplbnMgV2llZ2FuZCwgSm9ybiBCYWdpam4gVGhlIGluZm9y
bWF0aW9uIGluIHRoaXMgZW1haWwgaXMgY29uZmlkZW50aWFsLiBJdCBpcyBpbnRlbmRlZCBzb2xl
bHkgZm9yIHRoZSBhZGRyZXNzZWUuIElmIHlvdSBhcmUgbm90IHRoZSBpbnRlbmRlZCByZWNpcGll
bnQsIHBsZWFzZSBsZXQgbWUga25vdyBhbmQgZGVsZXRlIHRoaXMgZW1haWwuDQo=
