Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6D269648B
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbjBNNWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbjBNNWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:22:45 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2049.outbound.protection.outlook.com [40.107.104.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8500A27D61;
        Tue, 14 Feb 2023 05:22:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzmXyUnsQj78G3ep4nPoHCKfaFnW62720q0EnWUWamPN0Df1UxZlyNS5BSzlw4uZoCrbebytAMlSa13HU9gYZu9vDLIIGzYP7eoGAHZA/eGXWu55OH4iL1nIhrAKuoRjIPBdm50p/D75y/XlE4UodyQ/jN+CxwCAOoKdkQovQjKnppxNMGAmF1veupMxp5XzOBw6bwz4eNlEPLwz1TcawAsylZU7kGurDwz943NyfthJQsnFD+XjyaOW/MMFIC9rfym8i0NdNSwAaYp8y+ncPIw5TqRRxDvjTvWoeVMx3SuFdEtYgqkJ56kyOBDp59ptxguwGMAN3uO9mnhnhLsdZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YxVoOtByh1yPV2LtnMEck2QMXRE4D+MKolojjmZGspY=;
 b=PYb9kF7baWUfYisA3qGx1oBbfA8GktUeYbU9vRawzNGDvEyfdKYrnGPdCRxim3wQIXhEVcmUjvByqoYt6uzlGR0MIN1/J3UP68Z8YOyczyjKcDTDRXFJgQQppUwsSy0HDPSn+LlKso0Oe+tkp35ch2g0IM+SHeHY/qnZ3rSVlFOSTtM/tmvHWZP7E4o5QE7yQiFDIvgmr+38hY2+8+49jsUaGNsPPHS+sE5zxpRU5RSWPmMfERTZ+WZgbBYjCx3j7DCwkQPhUBV9ssDPjnUIUGq3LFs6HJ0kWurpcC/DIP6yrHrVEUsVHXbS0INXR2PSPhDAaJoCji364sSpdDwjoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxVoOtByh1yPV2LtnMEck2QMXRE4D+MKolojjmZGspY=;
 b=UJpj87X9OKKYrCkzqYCVfPSIWHEqLFF25EBgAxzlZxQLUGSZS8Qcfm1Js6xGG+9mCvNebHjcKw7cSDKJD66jTr1X2I2CvRWJVanvHT2YAVDssqU1be9srJ/3SignPhUXKijBCHbmQn9/+kaHM3oCXfytJzRjHOB2L8P0LPkNJOY=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DB9PR04MB8137.eurprd04.prod.outlook.com (2603:10a6:10:244::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 13:22:08 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%6]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 13:22:08 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 net-next] net: fec: add CBS offload support
Thread-Topic: [PATCH V2 net-next] net: fec: add CBS offload support
Thread-Index: AQHZP44WIaasQ+1ZZ0O2FaaW5aXAcK7NCrmAgAAEr4CAABcEgIAABoCAgAEHe7A=
Date:   Tue, 14 Feb 2023 13:22:08 +0000
Message-ID: <DB9PR04MB810669A4AC47DE2F0CBEA25B88A29@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
 <ed27795a-f81f-a913-8275-b6f516b4f384@intel.com> <Y+pjl3vzi7TQcLKm@lunn.ch>
 <8b25bd1f-4265-33ea-bdb9-bc700eff0b0e@intel.com> <Y+p8WZCPKhp4/RIH@lunn.ch>
In-Reply-To: <Y+p8WZCPKhp4/RIH@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|DB9PR04MB8137:EE_
x-ms-office365-filtering-correlation-id: ab89db1f-90d4-4254-1b0b-08db0e8e790f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tCjPM45E5f+ZcB2fF5Eyd5L7y0HqhfnE1FRSmi9KlDQ1btJOgUFnb0EtwjQHwauAoo7I3ulIFv4pEToKchhw17otd/nD5yErZjshMVxXKlfZIonwNhhAzTNv2kGp6VzGKO9bw7QKaUH47ukE55C2RPJlq4AJ1/wbCrK9UTDLqZ4NnAg9NHNz6wm7F0SkEEEO/03OodpYn2n5jLRW53ek6nfJyrXuZg1ST3cQAPdU2aJP1dijWxerfoFAKCqg72sCqqw5TrhAd0KTXa1nqJRF+YTrxX6u8c9qKKrO1/OodSAccvZbP4j65ykRLRUdQJ9sq9KnITQQqEb9yf8nYs+GWoFuZjwtsPxfLdbUUrWOifwwMzaktst0jMxWLbxDAz3TnUV0tR+4NCuLNfmx8Yy1Qvh3OGIKbvM/A6dr112Nd2Vu3+Obrxc2c65GzsRF+1+wPLyXI6RX7Ofy0njHDE46Lj1gXIzF9tA6CqOtIKr8fBH2S7byDC/9HWy+zjdNQ5LsPpAN+UiVZxVZGp2xJoQxKsWtinXcpBnQzeLMxlDf6L41HYDdU48mwEEGybAAMjs5IyvBfqW/E+W38IALmyQYAJsGoHwhBNrarA0emm8TkNWaCzeMTNBUIW0au1779t5BtVlbtS9X6WZfsCIxrM5Dss1j1E7pzDhPisfoaXR1lS5pk76RKjmXS2CYdIijebRVxmqatfq+eej35388CyKXcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(83380400001)(38100700002)(122000001)(33656002)(2906002)(52536014)(86362001)(38070700005)(44832011)(41300700001)(5660300002)(8936002)(55016003)(4326008)(186003)(26005)(9686003)(66946007)(53546011)(6506007)(110136005)(316002)(54906003)(66446008)(76116006)(66476007)(66556008)(64756008)(478600001)(71200400001)(7696005)(8676002)(66899018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?dWpOSEdLNlQrTkFhYVRtRmZwZElmYnJCSnNFTmxmVW81QWM1aVY4ZjVhNnhE?=
 =?gb2312?B?T0hvREZERDhES1c0MWFFS0g0bkxOcFNIeFNXeGhWZmNtQVNERndUa25FdFBq?=
 =?gb2312?B?Q0Ywa0lRTTBVcW1Sdk1sTWJ4UWYzdUZreEIyUzMvRk54YjU3SStZUm5WK0JR?=
 =?gb2312?B?RXo2Y0JCWnltbXY1T0JXVkc5R2JLYndsOWVvV0NHK2RrcEFYRDNqbDV0ZmE1?=
 =?gb2312?B?czI4dTVaKzNFZG9YelA0WUdVb2ROU0thUFhuaitmWDBrVEZ1cy9OUEI0U2Rp?=
 =?gb2312?B?YURBTXZzeHpxc0M4WVhCa0ZMN0F5UFNTZ1lXZUJ1Z1dGRnd6RVNzYzQ0Vk4r?=
 =?gb2312?B?QVhVMHB6aEljSXVnOCtvd2l5bEV5bkd2TmtwZnBTMFMxcjRKMTkvTm9XMWNu?=
 =?gb2312?B?dWNWUU5QczNkUmovWFRhOUxMc1d5MmptTEhTcGdMRmFVUGtZR3NJbHg3MTNL?=
 =?gb2312?B?anB1RmVkNmJmajJaSWZCZVpxNlhMbEtPaFRWL0ZxS0VmM3A4c2I0NUpHVUxF?=
 =?gb2312?B?cGlaR0VvcTYvL3dFRnJpWnNPaDQrSjBqRFpYekJPNFo5U2Jpb0pTVkZ1ZTd6?=
 =?gb2312?B?MDJRdVRWTFN6OVlMaGJzVzdSMGZmb0l3OU5BNUFTZW1RRXNKMXdGQlRLTXFY?=
 =?gb2312?B?YUJEUWQxamt3YW9FaHQ4bmNZQWFqb1J1N2h6SmdSbTFscmtEeFNnNGhLS0Rt?=
 =?gb2312?B?Qm5NMUVCYWM0YWd3cjgycW1yeVJCbVhucW1Za2dZTzAwL2ttdmpxOVIzQyts?=
 =?gb2312?B?czVXeUNHRHFwc3VMMWVQckJidkNaSkhyNG1RSWhWSVhyWCtpYnlWZkROQjQ5?=
 =?gb2312?B?YndTTkt0MlUxTnhiYTVGOHN0a2RtZnFwdzg5cXMxT24zMW94enNmZTE1d0M2?=
 =?gb2312?B?ZFBhV25UK2lzR0VpNDBFSFBFMG9yZVpxNURMeElnTFpLN21FbnFBSlBXNXhu?=
 =?gb2312?B?bGJXWEpMdDdvNmVNN1NIYzYxWTlucGxrRjFCNXVxaW8yeEx3a3h0bjdva2Nx?=
 =?gb2312?B?OU9kdGV0OUxuUThIcHI4blEwNDZ6RDNtNWx1K3d4ZnlIMGRIOVZDdFI1cVRZ?=
 =?gb2312?B?dmFQMWJDejZQZFg1ek5zdmJKdUgvN25MZmNjc0p3aWFPamdYOFNxdjVwcXcv?=
 =?gb2312?B?N1VjMnBZMTlEQXNReGZDbDVkMjJxcldPM0RQa1cwSFBDdXI3b0tMenJkSitJ?=
 =?gb2312?B?RTdWbS9McFl1SjJFMnVuN2t1d3dJSlFxeUtmeVdoWVVIeWxYUmIvSGh3MDMy?=
 =?gb2312?B?SXQyL3pHZjBOelRHL0hVZkRBd1BQOTcvZmJlSkFRWGFrZ05iVkh0MCtIaTRh?=
 =?gb2312?B?UTF3VWJUL1gzY2FTL2dRQkdtV3ROR1VxV0V1Vm5GRE9jM2U3akhybUVTTnov?=
 =?gb2312?B?dWIrdFVsUndZbWpIcTJBZE1QMEVwUVczaXVXbVErdFJ2ZXIxdmswNXZ1ZHlG?=
 =?gb2312?B?blJNQVBiTFBBRS95NUlmZ094Z0tYUmpZU2R3cFlzTWMvOWpPbHB1YXZCRDdt?=
 =?gb2312?B?MG9vbzNjS3pBQUhOVG1KSnY3cXF3N09nd0VJZS9vRlZmcnBDM200a3RtVHZV?=
 =?gb2312?B?Uy8wc1luclF5a0ZzMzlEM1FXSUZVYmlkbEZ2RkFyeW5ZbEJucWlUNEg2SFFN?=
 =?gb2312?B?TUM5cVFiWWtDcEpSd0Rua3RwNWhJalZZU1p6czlGei93QlYvbndqdHoxQ3ZL?=
 =?gb2312?B?WHRRenZhdU5nRWphNlNoOG0yZlM1QWhqQ2pHM211d3NvMmVaS2pIdFE0Y2pp?=
 =?gb2312?B?TWxLVnFsdy80anFreHB6d0EvQlpCSXhwQXAveXprWS9QdDZWa04zS1RtVmI1?=
 =?gb2312?B?YmZiaFpobmVFcDc5OFZHMW5qQkFaT1g0MlhYUjFWUjJyTm43ZElWUFFGSmpa?=
 =?gb2312?B?eFB6TGJjUEl6ajB1aTIveENGbmEvZFNTMkxGTHBGM08zUmMrRlR4Vk9GVWZi?=
 =?gb2312?B?N3h5MUE5N3ZTNlZIdXp6MTMyZC8rMFhuVVhqRkF4UnIvUnhReUxnTWt4ekUw?=
 =?gb2312?B?aENYeGZSekM4ZGZlU1FIc3hzUEJ6cVo1ZE1UdWZOYUdlbkJUOTVkbzAyd2FW?=
 =?gb2312?B?eGJwb1ZYUTFNVlA1c1lPMG1BcFZOUFVUQU9LWGxuSTlacHg3RVYyN09SNUoy?=
 =?gb2312?Q?NA4c=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab89db1f-90d4-4254-1b0b-08db0e8e790f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 13:22:08.2078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O4meLLK3khF2KnMkyFM0EizB/XqietL4keMZhACRiWMcmoZ4YCny9QNRH+bTE0mdhACsqNroUCGBC77mFWigEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8137
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmRyZXcgTHVubiA8YW5kcmV3
QGx1bm4uY2g+DQo+IFNlbnQ6IDIwMjPE6jLUwjE0yNUgMjowNw0KPiBUbzogQWxleGFuZGVyIExv
YmFraW4gPGFsZXhhbmRyLmxvYmFraW5AaW50ZWwuY29tPg0KPiBDYzogV2VpIEZhbmcgPHdlaS5m
YW5nQG54cC5jb20+OyBTaGVud2VpIFdhbmcgPHNoZW53ZWkud2FuZ0BueHAuY29tPjsNCj4gQ2xh
cmsgV2FuZyA8eGlhb25pbmcud2FuZ0BueHAuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4g
ZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsN
Cj4gc2ltb24uaG9ybWFuQGNvcmlnaW5lLmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgZGwt
bGludXgtaW14DQo+IDxsaW51eC1pbXhAbnhwLmNvbT47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMiBuZXQtbmV4dF0gbmV0OiBmZWM6IGFkZCBD
QlMgb2ZmbG9hZCBzdXBwb3J0DQo+IA0KPiBPbiBNb24sIEZlYiAxMywgMjAyMyBhdCAwNjo0NDow
NVBNICswMTAwLCBBbGV4YW5kZXIgTG9iYWtpbiB3cm90ZToNCj4gPiBGcm9tOiBBbmRyZXcgTHVu
biA8YW5kcmV3QGx1bm4uY2g+DQo+ID4gRGF0ZTogTW9uLCAxMyBGZWIgMjAyMyAxNzoyMTo0MyAr
MDEwMA0KPiA+DQo+ID4gPj4+ICsJaWYgKCFzcGVlZCkgew0KPiA+ID4+PiArCQluZXRkZXZfZXJy
KG5kZXYsICJMaW5rIHNwZWVkIGlzIDAhXG4iKTsNCj4gPiA+Pg0KPiA+ID4+ID8/PyBJcyB0aGlz
IHBvc3NpYmxlPyBJZiBzbywgd2h5IGlzIGl0IGNoZWNrZWQgb25seSBoZXJlIGFuZCB3aHkNCj4g
PiA+PiBjYW4gaXQgYmUgcG9zc2libGU/DQo+ID4gPg0KPiA+ID4gVGhlIG9idmlvdXMgd2F5IHRo
aXMgaGFwcGVucyBpcyB0aGF0IHRoZXJlIGlzIG5vIGxpbmsgcGFydG5lciwgc28NCj4gPiA+IGF1
dG8tbmVnIGhhcyBub3QgY29tcGxldGVkIHlldC4gVGhlIGxpbmsgc3BlZWQgaXMgdW5rbm93bi4N
Cj4gPg0KPiA+IFN1cmUsIGJ1dCB3aHkgdHJlYXQgaXQgYW4gZXJyb3IgcGF0aCB0aGVuPw0KPiAN
Cj4gWW91IG5lZWQgdG8gdHJlYXQgaXMgc29tZWhvdy4gSSB3b3VsZCBhY3R1YWxseSBkaXNhZ3Jl
ZSB3aXRoIG5ldGRldl9lcnIoKSwNCj4gbmV0ZGV2X2RiZygpIHNlZW1zIG1vcmUgYXBwcm9wcmlh
dGUuIEJ1dCBpZiB5b3UgZG9uJ3Qga25vdyB0aGUgbGluayBzcGVlZCwNCj4geW91IGNhbm5vdCBw
cm9ncmFtIHRoZSBzY2hlZHVsZXIuDQo+IA0KWWVzLCBuZXRkZXZfZGJnKCkgc2VlbXMgbW9yZSBh
cHByb3ByaWF0ZS4gQW5kIGFzIEkgcmVwbGllZCBiZWZvcmUsIEkgdGhpbmsNCiFmZXAtPmxpbmsg
bWF5YmUgbW9yZSBhcHByb3ByaWF0ZSB0aGFuICFzcGVlZC4gV2hhdCBkbyB5b3UgdGhpbms/DQoN
Cj4gVGhpcyBhbHNvIGNvbWVzIGJhY2sgdG8gbXkgcXVlc3Rpb24gYWJvdXQgd2hhdCBzaG91bGQg
aGFwcGVuIHdpdGggYSBUQw0KPiBjb25maWd1cmF0aW9uIHdoaWNoIHdvcmtzIGZpbmUgZm9yIDEw
MDBCYXNlVCwgYnV0IHdpbGwgbm90IHdvcmsgZm9yIDEwQmFzZVQuDQo+IFNob3VsZCB0aGUgZHJp
dmVyIGFjY2VwdCBpdCBvbmx5IGlmIHRoZSBjdXJyZW50IGxpbmsgc3BlZWQgaXMgc3VmZmljaWVu
dD8gU2hvdWxkIGl0DQo+IGFsd2F5cyBhY2NlcHQgaXQsIGFuZCBub3QgcHJvZ3JhbSBpdCBpbnRv
IHRoZSBoYXJkd2FyZSBpZiB0aGUgY3VycmVudCBsaW5rIHNwZWVkDQo+IGRvZXMgbm90IHN1cHBv
cnQgaXQ/DQo+IA0KUGxlYXNlIHNlZSB0aGUgcHJldmlvdXMgcmVwbHkuDQoNCj4gU2luY2Ugd2Ug
YXJlIHRhbGtpbmcgYWJvdXQgaGFyZHdhcmUgYWNjZWxlcmF0aW9uIGhlcmUsIHdoYXQgZG9lcyB0
aGUgcHVyZQ0KPiBzb2Z0d2FyZSB2ZXJzaW9uIGRvPyBJZGVhbGx5IHdlIHdhbnQgdGhlIGFjY2Vs
ZXJhdGVkIHZlcnNpb24gdG8gZG8gdGhlIHNhbWUNCj4gYXMgdGhlIHNvZnR3YXJlIHZlcnNpb24u
DQo+IA0KPiBXZWksIHBsZWFzZSBkaXNhYmxlIGFsbCBjbGV2ZXIgc3R1ZmYgaW4gdGhlIGhhcmR3
YXJlLCBzZXR1cCBhIHB1cmUgc29mdHdhcmUgcWRpc2MNCj4gYW5kIGEgMTBCYXNlVCBsaW5rLiBP
dmVyc3Vic2NyaWJlIHRoZSBsaW5rIGFuZCBzZWUgd2hhdCBoYXBwZW5zLiBEb2VzIG90aGVyDQo+
IHRyYWZmaWMgZ2V0IHN0YXJ2ZWQ/DQo+IA0KDQpTb3JyeSwgSSdtIG5vdCB2ZXJ5IGZhbWlsaWFy
IHdpdGggdGhlIGNvbmZpZ3VyYXRpb24gb2YgcHVyZSBzb2Z0d2FyZSBpbXBsZW1lbnRhdGlvbg0K
b2YgQ0JTLiBJIHRyaWVkIHRvIGNvbmZpZ3VyZSB0aGUgQ0JTIGxpa2UgdGhlIGZvbGxvd2luZy4g
VGhlIGJhbmR3aWR0aCBvZiBxdWV1ZSAxIHdhcw0Kc2V0IHRvIDMwTWJwcy4gQW5kIHRoZSBxdWV1
ZSAyIGlzIHNldCB0byAyME1icHMuIFRoZW4gb25lIHN0cmVhbSB3ZXJlIHNlbnQgdGhlDQpxdWV1
ZSAxIGFuZCB0aGUgcmF0ZSB3YXMgNTBNYnBzLCB0aGUgbGluayBzcGVlZCB3YXMgMUdicHMuIEJ1
dCB0aGUgcmVzdWx0IHNlZW1lZCB0aGF0DQp0aGUgQ0JTIGRpZCBub3QgdGFrZSBlZmZlY3RpdmUu
IEFuZCB0aGUgbGludXggcGFja2V0IGdlbmVyYXRvciB3YXMgdXNlZCB0byBzZW5kIHRoZQ0Kc3Ry
ZWFtLiBXYXMgdGhlcmUgc29tZXRoaW5nIHdyb25nIHdpdGggbXkgY29uZmlndXJhdGlvbj8NCg0K
dGMgcWRpc2MgYWRkIGRldiBldGgwIHBhcmVudCByb290IGhhbmRsZSAxMDAgbXFwcmlvIG51bV90
YyAzIG1hcCAwIDAgMiAxIDAgMCAwIDAgMCBcDQowIDAgMCAwIDAgMCAwIHF1ZXVlcyAxQDAgMUAx
IDFAMiBodyAwDQp0YyBxZGlzYyByZXBsYWNlIGRldiBldGgwIHBhcmVudCAxMDA6MiBjYnMgaWRs
ZXNsb3BlIDMwMDAwIHNlbmRzbG9wZSAtOTcwMDAwIGhpY3JlZGl0IFwNCjEyIGxvY3JlZGl0IC0x
MTMgb2ZmbG9hZCAwDQp0YyBxZGlzYyByZXBsYWNlIGRldiBldGgwIHBhcmVudCAxMDA6MyBjYnMg
aWRsZXNsb3BlIDIwMDAwIHNlbmRzbG9wZSAtOTgwMDAwIGhpY3JlZGl0IFwNCjEyIGxvY3JlZGl0
IC0xMTMgb2ZmbG9hZCAwDQoNCg==
