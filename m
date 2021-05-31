Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7863959BF
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 13:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhEaLdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 07:33:08 -0400
Received: from mail-eopbgr140072.outbound.protection.outlook.com ([40.107.14.72]:50517
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231240AbhEaLdG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 07:33:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvXedUVAMFBoNDbxvYBfp5j+ReJqumgCcxNz5mn1j6CwV2ZO6wGdrWdi5s+vV42j0Tj20RQEIr5vqtb66Vgu32lckdv++UCk4ooTjw7PdNzsU61fmY7cLKY/VWnHjnLqwfqqjua8fluNdw5yclDv15MdgYub4pUVsjMFZme5fiiU3WV3K/0w37wMy6yBjdyafGtjrDlneXkOac8OIPLP494E/SdtTkgB+MUl4HqEcx3tjjc7Ldx4bqnVviF2WcTeaFvn9vaMtAM6COKn+bmd83WyW+xSmEGUB4HjeEqz6zXJlPMRqIzJtH1dtBQNAE1/Ji2Vvb0x6nPh9F1xJ444WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2H//wBtJ9/LQf+OxzUHtPZNTUVqcdEYSKHR9lpn4SY=;
 b=KG/IT/Du9WPBYAWpQ/FzB3Vlt3npn/jg+ZwogP4GQfNR883iLTSs/Eutvlh4cS7NpmefSTl/vQl+mi6Bg5N7slpGhgRqfWGJ2BdY7/c+5/YFWdIaCpserR139VpY47pFv0rZ2yuNmDQ9hGSUw879QMfP3id7RlNMQwP4XG4Yl+aJA+N0BpmB11A6+6rWRv4y7i1VrnQoREdKyzwcvO1vm6gzB/wyUcCadO/XSWBzzvestZuh7XO85vyesigBoL0kDpDd56Fx/LzLxiEGjtUWHLfxk7zx5C+gDEK4p86xd5XgXymPVBWBK/R/RgjZQMB+dlHhcKo6EY2Z5sg6GSVmhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2H//wBtJ9/LQf+OxzUHtPZNTUVqcdEYSKHR9lpn4SY=;
 b=CoJqUm44j8VvsSGJaZRvAJIJfX9ati9k+91x0VTrGe1rlvtL8Z1FFZuz8a667+HLzk9nyHTlk+In/o7244qWx1PbPViLy+Aa2ceb8eCZQNEQg+rJtI9ti9+OfE6MN8AlZLSvUbbsXu9Qv7dik+sxJHPieOfZGxn52Es95pdrJ80=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB7PR04MB4170.eurprd04.prod.outlook.com (2603:10a6:5:19::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Mon, 31 May
 2021 11:31:24 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 11:31:24 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: RE: [net-next, v2, 7/7] enetc: support PTP domain timestamp
 conversion
Thread-Topic: [net-next, v2, 7/7] enetc: support PTP domain timestamp
 conversion
Thread-Index: AQHXTfl8MjjmUYWreESzJP4N6mmsJar0KWqAgAlOe5CAAAvgEA==
Date:   Mon, 31 May 2021 11:31:24 +0000
Message-ID: <DB7PR04MB5017313658AC779FBA59843DF83F9@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-8-yangbo.lu@nxp.com>
 <20210525123711.GB27498@hoboy.vegasvil.org>
 <DB7PR04MB5017604C9B3AE7C499B413D3F83F9@DB7PR04MB5017.eurprd04.prod.outlook.com>
In-Reply-To: <DB7PR04MB5017604C9B3AE7C499B413D3F83F9@DB7PR04MB5017.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de7e40dc-a73a-447c-fbdd-08d924279f7a
x-ms-traffictypediagnostic: DB7PR04MB4170:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB417029F12E5EB3D64B6D8C14F83F9@DB7PR04MB4170.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: It6DibLedUahXuxntz/V+9Jv9ITx79PVH1hCc4KEroJSOkDs/WcGuVP7l+jgTwGeESiOCHUJZn2si4e16acRhJAlALNj3gKCWigIOlmnhz5W6+zhnCxXnSwcCSMRhQ3JuMlhm8vUSj/cYjxQLleNOOu9LeE0gj8RXPV2HCUG7Z9/ZhUelkiXXOWbvI53pwapL4n/IkAAwp4Lp6uYmfj1kdVxnzEwiYrZyacFCopFKIVMQykhogmJYpDl+HzZ3VUjfLfJVZlUzb63u614iiJZkMFCjjNlBK0exKtLIUAD1rUUQBade1qZmoBFv73WbGcnYE3Hq3vgdItapL36L1TW352H/dQneLPv5acK7TESgD7uMxWTY4qK74k6AN/0hZkWi4fOSajBcZhRtI/zXEJb6OgNQy+YNpVv3iVKbMpeXfqBs16Rmeqw8bkxCC2QnlKRILAZ+ELtnv1wm/0I/Fe8x0IGB5tZyDkG5B3L6IHYvvaVQFhMm64UqG9RJ926i0tv1ZFpgTic/IqY3vIQMtbPy3lvilCpA7jG7y/495g5B3YBbzg4dNRuHdw3LIogpFmuof1/rQZcmpWBZL0yxQxIIlW3VghZ2y2v1xGcwupB70g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(396003)(39850400004)(316002)(4326008)(6506007)(83380400001)(53546011)(26005)(86362001)(7696005)(54906003)(8676002)(8936002)(186003)(6916009)(2906002)(64756008)(38100700002)(66556008)(9686003)(52536014)(478600001)(5660300002)(122000001)(33656002)(76116006)(66946007)(66446008)(66476007)(55016002)(2940100002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?SzRGQWVnVXByYVVDemxMNnQ1dmRoSkV5Zm9uVFhQQndyQ25Od21SUmhFWEdX?=
 =?gb2312?B?M3JPLzREV2RsRnR2S1RiazZnYm4vc0NOcGhJSnFUcC81dlZiYWY1SWc5eC9m?=
 =?gb2312?B?T2cxaE5na09ab3kvUHltakd1M0xZVTYvWG04U1JHSkp5Z2tjN2p4SVRzaUZq?=
 =?gb2312?B?SXRWMjRPdHFJRmdWNmVUMnhETEx0SmQwMkl1RVNRcldTVGt4bXhMOVV0Vkl1?=
 =?gb2312?B?QlozcUFuZzN2VDBkTjc3dkFHNVZwa0Z1RlpnVFU4dnVUTkkwc1hMeTU3bC9j?=
 =?gb2312?B?SHJsb28rTHYzbXhvdUErMjdnb3FmODhWS205ejVtaFB4Wmt3UDFNV3EyWHk3?=
 =?gb2312?B?SnB4ck1xeUw3R2pCYkJlU2V3VDkxV3Urdllwemw5WHoyWWRDdUNlc1IzOVpi?=
 =?gb2312?B?ZHM4ZWZtSis0MFpPQnFCVm1MOTFzdnNzcHdJQStoTS9yQnFQbkZjNkJqS043?=
 =?gb2312?B?Njd5RnZjRVBHMEV5cXVhUTJMZmtIcWh6MDEzd1RwUC9NL3E1TkQ5cmJkZTY5?=
 =?gb2312?B?T2NDVHZWc3U2TkJKVXIzdlNXNjZxclIrSXRwNHZjejZJVlZoaGtCRG90ZlYz?=
 =?gb2312?B?a2Qxekp6N3hqQkIrM0k5NmhCVk51UFhyV3hON2hKaW5BZ3Z3L3J6Qkp2WC8z?=
 =?gb2312?B?V2hISFJ5VXdTMjhDUUFkQThxa2FNZjB5bUJ3RnUxUWhMUmJnWENrNng4ZkFk?=
 =?gb2312?B?VksxN0xnQ25QU1hXK1lGVkVPUHljanIxVFJXY1lMcURtS21PNjJqUzhVYmpI?=
 =?gb2312?B?cWpSWHlYQllnMy84bEhHWjFOWjdrL3dRejlJejRmbTU1cndqTVVERXF6QkZ6?=
 =?gb2312?B?cmFVcFowTWRqeVRhYitMNHBGQlFEUzVrMlYvNFVzejZ5MDA0WjNjNXc3Mk5o?=
 =?gb2312?B?Mm1Ra2pITWhRR2dCUFozUXR2a2JoZ0hpTlpoYlJJRXFtQlNud1MxZDNGRnZQ?=
 =?gb2312?B?b21hb3dnQkhaK2IzZER6dTRER3NWMlY5MGhuTFplYXFBZTJRYWYxemdLM256?=
 =?gb2312?B?UGVlUVpXMGpYd1FLbkViaGd2RXRPcThxS3NCVzhaWGNGbEw5QlpIMGdwMS8v?=
 =?gb2312?B?Sm9aYlp4MHl6MkZGdyt3N2tyMTQ5YXNrejdmc2N4L2UxRFlSWEw3SU12eW5Y?=
 =?gb2312?B?OWhGMjdkdVNKaGhNK2QxKzdpYjhCRUxFQ2N2YWVBczlneklYK1FGejQrNlFF?=
 =?gb2312?B?R1d6T1RVQkhWUjdXRURLT0Q4ZnlnU0dSS1hteUFYcXFaT0tIdUxmdGZ4d1dq?=
 =?gb2312?B?VDlKNHZ4WDkzZUJKTDVuQ2R3TWUwZEVVampwQXZyZFIvc2lhenl4cHBIOVVj?=
 =?gb2312?B?VmV3VVdFclFSSGF5dnBxcEJqNTJiV2M1YUswUXpKSGpXSTJobTRFMmFyZ3Bw?=
 =?gb2312?B?cTZtVEplWVBqVDVpY3VXaEl2Q2tNWURGU3ZtTC9yTjNPMlFkZTRISGJVcFlF?=
 =?gb2312?B?T2VmOUZTdnl6bjhEUWJzOXFITkMwMjkrSXprc3BmVnoyYmV6RE5iS2IyUHNp?=
 =?gb2312?B?NFh3QXpDNnRSU1d2Yzg0REFxRGxIN043WVd6bHBkbzZMc3BWSUptNFVkTVh1?=
 =?gb2312?B?dm5xNUxmNmZaTjdHaE9VYk5RSy82bHZNS29xM0p5Mm4vMS8yaGFIeko0MGZ1?=
 =?gb2312?B?N1NjQW0zQjFSdWk0TllDMElQcmVVai94dnVxbXcxNWJIV2tXa3hXTmlkMUdk?=
 =?gb2312?B?YjhRQkZoNWgzOEhORnRDTXZRNTI0SGY1dVRJYjRoOXRzUENndzlKRkdMdDFP?=
 =?gb2312?Q?taVFgnG+7S4jVxnY+9sa0pgsM2OCDLDt640U7tn?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de7e40dc-a73a-447c-fbdd-08d924279f7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2021 11:31:24.6318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 63G0V6ohdXJt7NIpYOo0BYRVfcefIRELeaC1A3Cyjk5I8lnCdbBpPzLmSBYKR8EPcLQ9Mktq0mqSoMEJPCje6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4170
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBZLmIuIEx1IDx5YW5nYm8ubHVA
bnhwLmNvbT4NCj4gU2VudDogMjAyMcTqNdTCMzHI1SAxODo1Mg0KPiBUbzogUmljaGFyZCBDb2No
cmFuIDxyaWNoYXJkY29jaHJhbkBnbWFpbC5jb20+OyBDbGF1ZGl1IE1hbm9pbA0KPiA8Y2xhdWRp
dS5tYW5vaWxAbnhwLmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IERhdmlkIFMg
LiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1Yg0KPiBLaWNpbnNraSA8a3ViYUBr
ZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSRTogW25ldC1uZXh0LCB2MiwgNy83XSBlbmV0Yzogc3Vw
cG9ydCBQVFAgZG9tYWluIHRpbWVzdGFtcA0KPiBjb252ZXJzaW9uDQo+IA0KPiBIaSBDbGF1ZGl1
IGFuZCBSaWNoYXJkLA0KPiANCj4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+IEZy
b206IFJpY2hhcmQgQ29jaHJhbiA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPg0KPiA+IFNlbnQ6
IDIwMjHE6jXUwjI1yNUgMjA6MzcNCj4gPiBUbzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+
DQo+ID4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVt
QGRhdmVtbG9mdC5uZXQ+Ow0KPiA+IENsYXVkaXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBueHAu
Y29tPjsgSmFrdWIgS2ljaW5za2kNCj4gPiA8a3ViYUBrZXJuZWwub3JnPg0KPiA+IFN1YmplY3Q6
IFJlOiBbbmV0LW5leHQsIHYyLCA3LzddIGVuZXRjOiBzdXBwb3J0IFBUUCBkb21haW4gdGltZXN0
YW1wDQo+ID4gY29udmVyc2lvbg0KPiA+DQo+ID4gT24gRnJpLCBNYXkgMjEsIDIwMjEgYXQgMTI6
MzY6MTlQTSArMDgwMCwgWWFuZ2JvIEx1IHdyb3RlOg0KPiA+DQo+ID4gPiBAQCAtNDcyLDEzICs0
NzMsMzYgQEAgc3RhdGljIHZvaWQgZW5ldGNfZ2V0X3R4X3RzdGFtcChzdHJ1Y3QNCj4gPiA+IGVu
ZXRjX2h3DQo+ID4gKmh3LCB1bmlvbiBlbmV0Y190eF9iZCAqdHhiZCwNCj4gPiA+ICAJKnRzdGFt
cCA9ICh1NjQpaGkgPDwgMzIgfCB0c3RhbXBfbG87ICB9DQo+ID4gPg0KPiA+ID4gLXN0YXRpYyB2
b2lkIGVuZXRjX3RzdGFtcF90eChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCB1NjQgdHN0YW1wKQ0KPiA+
ID4gK3N0YXRpYyBpbnQgZW5ldGNfcHRwX3BhcnNlX2RvbWFpbihzdHJ1Y3Qgc2tfYnVmZiAqc2ti
LCB1OCAqZG9tYWluKSB7DQo+ID4gPiArCXVuc2lnbmVkIGludCBwdHBfY2xhc3M7DQo+ID4gPiAr
CXN0cnVjdCBwdHBfaGVhZGVyICpoZHI7DQo+ID4gPiArDQo+ID4gPiArCXB0cF9jbGFzcyA9IHB0
cF9jbGFzc2lmeV9yYXcoc2tiKTsNCj4gPiA+ICsJaWYgKHB0cF9jbGFzcyA9PSBQVFBfQ0xBU1Nf
Tk9ORSkNCj4gPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+ID4gKw0KPiA+ID4gKwloZHIgPSBw
dHBfcGFyc2VfaGVhZGVyKHNrYiwgcHRwX2NsYXNzKTsNCj4gPiA+ICsJaWYgKCFoZHIpDQo+ID4g
PiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiA+ICsNCj4gPiA+ICsJKmRvbWFpbiA9IGhkci0+ZG9t
YWluX251bWJlcjsNCj4gPg0KPiA+IFRoaXMgaXMgcmVhbGx5IGNsdW5reS4gIFdlIGRvIE5PVCB3
YW50IHRvIGhhdmUgZHJpdmVycyBzdGFydGluZyB0bw0KPiA+IGhhbmRsZSB0aGUgUFRQLiAgVGhh
dCBpcyB0aGUgam9iIG9mIHRoZSB1c2VyIHNwYWNlIHN0YWNrLg0KPiA+DQo+ID4gSW5zdGVhZCwg
dGhlIGNvbnZlcnNpb24gZnJvbSByYXcgdGltZSBzdGFtcCB0byB2Y2xvY2sgdGltZSBzdGFtcA0K
PiA+IHNob3VsZCBoYXBwZW4gaW4gdGhlIGNvcmUgaW5mcmFzdHJ1Y3R1cmUuICBUaGF0IHdheSwg
bm8gZHJpdmVyIGhhY2tzDQo+ID4gd2lsbCBiZSBuZWVkZWQsIGFuZCBpdCB3aWxsICJqdXN0IHdv
cmsiIGV2ZXJ5d2hlcmUuDQo+IA0KPiBUaGF0J3MgcGVyZmVjdCB3YXkuDQo+IA0KPiA+DQo+ID4g
V2UgbmVlZCBhIHdheSB0byBhc3NvY2lhdGUgYSBnaXZlbiBzb2NrZXQgd2l0aCBhIHBhcnRpY3Vs
YXIgdmNsb2NrLg0KPiA+IFBlcmhhcHMgd2UgY2FuIGV4dGVuZCB0aGUgU09fVElNRVNUQU1QSU5H
IEFQSSB0byBhbGxvdyB0aGF0Lg0KPiANCj4gSG93IGFib3V0IGFkZGluZyBhIGZsYWcgU09GX1RJ
TUVTVEFNUElOR19CSU5EX1BIQywgYW5kIHJlZGVmaW5pbmcgdGhlDQo+IGRhdGEgcGFzc2luZyBi
eSBzZXRzb2Nrb3B0IGxpa2UsDQo+IA0KPiBzdHJ1Y3QgdGltZXN0YW1waW5nIHsNCj4gICAgICAg
IGludCBmbGFnczsNCj4gICAgICAgIHU4IGh3dHN0YW1wX3BoYzsgLypwaGMgaW5kZXggKi8NCj4g
fTsNCj4gDQo+IFRoZSBzb2NrIGNvdWxkIGhhdmUgYSBuZXcgbWVtYmVyIHNrX2h3dHN0YW1wX3Bo
YyB0byByZWNvcmQgaXQuDQoNCkJ1dCBvbmUgcHJvYmxlbSBpcyBob3cgdG8gY2hlY2sgdGhlIHBo
YyBhdmFpbGFiaWxpdHkgZm9yIGN1cnJlbnQgbmV0d29yayBpbnRlcmZhY2UuDQpJZiB1c2VyIGNh
biBtYWtlIHN1cmUgaXQncyB1c2luZyByaWdodCBwaGMgZGV2aWNlIGZvciBjdXJyZW50IG5ldHdv
cmsgaW50ZXJmYWNlLCB0aGF0J3Mgbm8gcHJvYmxlbS4NCk90aGVyd2lzZSwgdGltZXN0YW1wIHdp
bGwgYmUgdG9rZW4gb24gd3JvbmcgcGhjLi4uDQoNCj4gDQo+ID4NCj4gPiA+ICsJcmV0dXJuIDA7
DQo+ID4gPiArfQ0KPiA+DQo+ID4gVGhhbmtzLA0KPiA+IFJpY2hhcmQNCg==
