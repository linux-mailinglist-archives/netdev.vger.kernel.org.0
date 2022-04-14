Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18B65003C9
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 03:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236293AbiDNBrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 21:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiDNBrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 21:47:53 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10091.outbound.protection.outlook.com [40.107.1.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764BF22BEB;
        Wed, 13 Apr 2022 18:45:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Io40tu3UZavdcOIob2Q7inR3kNEdxd/h+pIe/BET2Ku6nlbW8ZPOdUOfaK8Ele+/3L3hvIzrDgEO/bvheJfW/kYhbRqGrNyHCRiIlr8JkjPWU5y1h9qb/Kac4fmo4EA8EazSVI0WTle3a5C4ztqqhbWgjF1Ikh0gKzkf267Oh5HyfGdZXAMiJsm7AgoHpE80bVnMMTRShWvcPQy4ex0GVdjGZG5EfGiIIwoUgEIkXKWdZhfmeog9nSmqcCzSLsTjc6x8GXVJzlzkG8S8CtbgIGJgidnld4cs3z62Be+fASSP9VHSwZwRX6irGGoruXsaDfI3fqg+HUixC+SieOFiNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFFd97Pw/gMN1wGgG2kTBJbxl+3ERDDKIl8jIpmwa1U=;
 b=hdT2IAG5bGFAXTh5p04LmvOS8KmMWddwdcjWtz0R9GEmhX3kIJy5naLaJyGTmUxqUS1Rq5FTveeWIVsqhCsLjuzzi7wTSnH/WV33H17hEpqs5NckFtrRDc/2w3WNU/KDOR5KQoCohsJp3hiCNuelf6jBYkA4PnmCrDT7hFBpjRDvJ/K0B3pcMETnRvS8mYpSgzv38T30EpoVYXoS+mmGqy66rtdUTcp/TYFUjRjKNej55Q1ZZnsHGC5cMBBcsV3pnL33t3/ki9RYE2LjQa4b2z2OP9HUpP5BbfXuf27xOG75rDSV2ZGZzIJ5Zk8S1qnYrpJ3e8Cp+JWojN6islazAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFFd97Pw/gMN1wGgG2kTBJbxl+3ERDDKIl8jIpmwa1U=;
 b=GymMdkUc0lAjJfwAPkghN0+do12DL3kb/aZsUZHLqpECMaWGEqvCZ8aL9oStSvX3Mw/vBnf1Day7b6fvWzSwMZphLskw/CzQ6hWXmsm/2igouv8VpwJ5EQ9EOQEFbVLfERfqEQFNBrzoOgh66yqInwRXrWD5TSsGQah4mVGG+fg=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by PA4PR03MB6959.eurprd03.prod.outlook.com (2603:10a6:102:f0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Thu, 14 Apr
 2022 01:45:28 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82%3]) with mapi id 15.20.5144.030; Thu, 14 Apr 2022
 01:45:28 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tobias@waldekranz.com" <tobias@waldekranz.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Thread-Topic: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Thread-Index: AQHYTlsZ5PP7ok0nLUG60UBEzGR+wazuLqKAgAB3SYA=
Date:   Thu, 14 Apr 2022 01:45:28 +0000
Message-ID: <20220414014527.gex5tlufyj4hm5di@bang-olufsen.dk>
References: <20220411210406.21404-1-luizluca@gmail.com>
 <20220412105018.gjrswtwrgjyndev4@bang-olufsen.dk>
 <CAJq09z53MZ6g=+tfwRU-N5BV5GcPSB5n0=+zj-cXOegMrq6g=A@mail.gmail.com>
In-Reply-To: <CAJq09z53MZ6g=+tfwRU-N5BV5GcPSB5n0=+zj-cXOegMrq6g=A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28f4353f-0242-48f8-0bb8-08da1db873e5
x-ms-traffictypediagnostic: PA4PR03MB6959:EE_
x-microsoft-antispam-prvs: <PA4PR03MB6959DF30AF804C8BDB67856083EF9@PA4PR03MB6959.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u9vaFybT6Czpl/30Br2uf9AIwlcMnTC4vaBzDSk4+eiTm/yFt3EAoQQsYrlAUXjBrdl7Hm7sAixoolRh42qjd0amBO72lZup5K2pklep0yZSaqIBfTbsEeuTLqGghbYDlkefdaTHhhmcFz4TREyuZdYPIIkFx3ToH+gFGaWDbltNQmwIzUb+39UnCE3M+jU/1htf/bJMcvY3Wo2VsGAaobKX/KLWZIypCv8rUvh9OxSFZVt2sjzC959LfbRCr8EyPquwQLzDbybjX7Jrn2er5eLIxhGmsQUVqNw66Sic6QAE+koauYoZi3pNooDd3lxc6GvtL8P3poZwmEiPKviG07JQUeHSzumj3czM7V16p0A3w9v7LhHKj0D3ZOO27virBaZX/6XaJvwuDbYSY76/t39uhxDGa90TQMxYR0O6MdTtYK47VlVPw0PRIErKhOr3lUSCem5j+w/ExnwNJRi/JkZJmWIZS1yOhHMuzwzANpxFgtMAerQ0SnVso9pycYci1qODnI0A4L5eXrq4Ue0u4fBQJ4URspr0X0N6di6oLC1C4bZRAK2epm9cEcAWrlpEeydbBpBm5J/NFF7zYuiXNNdiX11Rje6b2H2SHUhDmlsHQ8vXPMstVc82Qa12f4pz4XNMhWjuY0nhIGWZ1FslAGW/NHfEvrHWEqqUqaDT9hIJgFr+OeM58IRBERWScfOAuSSIhCGKsxYe6PAUhhH4FA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(316002)(54906003)(6506007)(1076003)(85202003)(36756003)(2906002)(508600001)(186003)(26005)(122000001)(38100700002)(6916009)(83380400001)(38070700005)(2616005)(85182001)(8976002)(8936002)(66476007)(64756008)(66446008)(66556008)(4326008)(8676002)(7416002)(76116006)(5660300002)(66946007)(86362001)(91956017)(6486002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MVIzZFdqTzdNeHBuMEtwYW5mT0tTQkxIRHd5YWFNLzV1MDZQWHBSWlRPQUlx?=
 =?utf-8?B?V1l1TUU2emg4dlJ5NUV5bUxxVEpROGhEdi85cWdJMElBRS9kaUlyNGhCWkI2?=
 =?utf-8?B?U1FyMUg3Q2RTdVZtazFIWjhvM21XNFlpV2hkYmNzL285TXFwZ2pQQm5xVy8v?=
 =?utf-8?B?UTMzbDhnOU9iNlpUZnZJOUpZRTY3R3p6Q0JWUlRnalV2ZDhQMkM3UnRmUlRX?=
 =?utf-8?B?YXZWTGt3WmM4cXliazJzRU9PdVg4RVV0QkR5MFlBNXFJWnMxK1dXRnVCYWty?=
 =?utf-8?B?NW1DMnpLaVRPZnhjekNoMmdtN0orSkNQeFpUQmxkNXJyazM5cHJ1UEFoNWpj?=
 =?utf-8?B?aXBab2t6dnFoQ3JJRTVOOWtMWlN5N1RKM1lUWThQMkxDdHNRQTRxeUVlRm5R?=
 =?utf-8?B?L2pzVDhWblBYejZJUS92TUhnMklwc0Jlei9aWlorQmlMakhYZzZPNFdQL3pt?=
 =?utf-8?B?cXdJRzJaK2Z5cW4zZzVObm1PODVINm1YRUVFQTNkcEpqM3loMmZ3SGhrQ3Nw?=
 =?utf-8?B?Tk13V0ZtdmVONjA5M0trNmY1bUZ2YjVidmFRc0lrOXh2N0NKRXNNZGVKZVYx?=
 =?utf-8?B?ZHFNU3p4TURsMVhZa1BjWnVEUUd6TldPeDMyYmIxMEJxaElWeXVDMXE3RGp5?=
 =?utf-8?B?bDBuTVhZcFhvL3NjQkwyclZlQTFQRkEyQkhOSW1SSk5DVjlVa1d1aWNNREU5?=
 =?utf-8?B?WWlkUlJlbzBRN0RyOU1pZzZGOUdBMjV5TmxnN1FteXBVTW9RQU5RcmZ3bmhI?=
 =?utf-8?B?L0Rzcy9uQzBJcEpOK2VZVXVZZjdyb1JwclZ4WW9BWXlDVFp5SUxXRjBUZmg4?=
 =?utf-8?B?NzFZTlhPMzJXTW9EdURDeU5oZE5oeVhITE45MzdMRURhaUJQMVpacFoxMDRr?=
 =?utf-8?B?cUMxRGg5dm03RXhySFBDWG1IMHNuVXIxV3ZKZzFRY2p2Q0oxdEVmRCtFbkFQ?=
 =?utf-8?B?cHdTaDlqN3Axb3dCa3FsalJGM0d5QXNyTXlLMnpHOE13LzgwcHppSWRTYmN4?=
 =?utf-8?B?MS96M1F5WTFqem0rK3RXcUlkU2FaQmxFQXpRSklIQ29tMlcwSGxYK0ZTSndB?=
 =?utf-8?B?NUFDd20wSmJaSlVuR1U5V1VTaUd1NDAxZk9FRTFZZXl1eGpXRzRNVW52Z3R4?=
 =?utf-8?B?UjJLWDBTM0tDMEM5RU5RdUpURHYyd3pYdzgzYVh5ZUNrZ1cwVFlGNW83ZERE?=
 =?utf-8?B?RU43SmhnVnI3d3J6NTRORVZvMU9iNDlhd1VST2VjN1BmT3RVUVRqUnkzbURn?=
 =?utf-8?B?NUV2Nko4TXRBVlJtVzRhaXFsNWxPZ3ZMRGMvdWpYRXh2TW5qbnBjT29vRzRP?=
 =?utf-8?B?blU5WThYdjZCdEFZYUxzMkhxV3QrZEY4R0pUV0poaHlmUE10M0xFLytFejhr?=
 =?utf-8?B?OThrZ3ZyUmxFcEVBOE5TLy9JSXI1SFlmODE5aXNUQVNEUnpEN05qU1Z6aUc3?=
 =?utf-8?B?YndBQzNYT0ZMdmQzK0E4cHZuUm9NTVJ4MVIzOHEwSC9BbVNja1RDNUplbkU4?=
 =?utf-8?B?cXkxUnJIZjJWd2wrR1JISk5PMXlRMXg0WVRKTFFXK2dBeDRoYlhLQSt5RHI4?=
 =?utf-8?B?UHYzcURRMTFSVFVLenZwZHRoL0ZNMUhNdnlNcmN2ZTJoNTNRYjk2aDN1by83?=
 =?utf-8?B?MGxRcENld2xkRWlyZ3QrVXZOY1hkTXVsMjk3TUYxc0h2U0VWQ2VGWVduSFR3?=
 =?utf-8?B?b2krVGdnKzltWkVBVUQ5WXdNS0lGSDRMWk8xMDUyRFNwK3J1MDZ3R1N1emRY?=
 =?utf-8?B?dDg4R0R2RGtCVmIxTG5ZVm1jcjFRR0toWVZZU2VXaW1udHg2Y3h5a0JWNDNz?=
 =?utf-8?B?cUZsYjkvOFNwT2Y3QURYUjdUMDcyaFg4MFU2RmpvVXMzZFZPSUJLVVI1Q21n?=
 =?utf-8?B?dGIxUnNOUGo5dG1VOGN3WndRNnZDbnpITVRBdUtWVHhNcTBTUFdWcFB0QnFF?=
 =?utf-8?B?dkliTE40Tk1kR2l2dmJzcGV5RldlSDh6dC81aC8vekdkaVQ4ekU2M3owZlB6?=
 =?utf-8?B?di8wR3J5RUZVVm1YLzdBemFLaG9GblVXM2ZXTlFYK3ozNmIrUndnUFdRenht?=
 =?utf-8?B?ZVFvNzZHN2hCbmcrOHBQM1JUcjNYY0RNWVAzQzdhTlVTRmVGeUprTnZxOTV2?=
 =?utf-8?B?a1JTcEpHQy8wSVJIMVk1NlZBQ2RWYTRqMDhxamN2VmV6RFdEdHREbFk3aXVP?=
 =?utf-8?B?QTB1TjdtL3E4T0NkeFBtSmFaQi8waW81U1M2N1ZJVEVCcmdIajMreS9acDZ4?=
 =?utf-8?B?RlVTRHU0cmFBNHY3N0grREVaRFJIVThVd0NFR25KczQvVDJ3MW92by8ybE13?=
 =?utf-8?B?cS9IcFl6WFU4RThZUjlCcXc5dW5JRUhNS3NTaUhvMHZBclplWXJyU05Jdmty?=
 =?utf-8?Q?4LFVgLY+tdsFhMek=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1C87B40CDDCDC45A4ADDDF0D92F196E@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f4353f-0242-48f8-0bb8-08da1db873e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 01:45:28.1143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zV0Pol4vexQKHsdpzOXGbJjR7TOtPS0LbgH8o0zIDsE1LyZSNtsnMzmfwqAhUDPpbm8pZJIxK2ad8X2pRa86XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB6959
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBBcHIgMTMsIDIwMjIgYXQgMDM6Mzg6MzFQTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gPiBPbiBNb24sIEFwciAxMSwgMjAyMiBhdCAwNjowNDowN1BN
IC0wMzAwLCBMdWl6IEFuZ2VsbyBEYXJvcyBkZSBMdWNhIHdyb3RlOg0KPiA+ID4gUlRMODM2N1JC
LVZCIHdhcyBub3QgbWVudGlvbmVkIGluIHRoZSBjb21wYXRpYmxlIHRhYmxlLCBub3IgaW4gdGhl
DQo+ID4gPiBLY29uZmlnIGhlbHAgdGV4dC4NCj4gPiA+DQo+ID4gPiBUaGUgZHJpdmVyIHN0aWxs
IGRldGVjdHMgdGhlIHZhcmlhbnQgYnkgaXRzZWxmIGFuZCBpZ25vcmVzIHdoaWNoDQo+ID4gPiBj
b21wYXRpYmxlIHN0cmluZyB3YXMgdXNlZCB0byBzZWxlY3QgaXQuIFNvLCBhbnkgY29tcGF0aWJs
ZSBzdHJpbmcgd2lsbA0KPiA+ID4gd29yayBmb3IgYW55IGNvbXBhdGlibGUgbW9kZWwuDQo+ID4N
Cj4gPiBUaGlzIGlzIG5vdCBxdWl0ZSB0cnVlOiBhIGNvbXBhdGlibGUgc3RyaW5nIG9mIHJlYWx0
ZWsscnRsODM2NnJiIHdpbGwgc2VsZWN0IHRoZQ0KPiA+IG90aGVyIHN1YmRyaXZlciwgYXNzdW1p
bmcgaXQgaXMgYXZhaWxhYmxlLg0KPiANCj4gWWVzLCBob3cgYWJvdXQ6DQo+IA0KPiBUaGUgc3Ry
aW5nIChubyBtYXR0ZXIgd2hpY2ggb25lKSBpcyBjdXJyZW50bHkgb25seSB1c2VkIHRvIHNlbGVj
dCB0aGUNCj4gc3ViZHJpdmVyLiBUaGVuLCB0aGUgc3ViZHJpdmVyDQo+IHdpbGwgaWdub3JlIHdo
aWNoIGNvbXBhdGlibGUgc3RyaW5nIHdhcyB1c2VkIGFuZCBpdCB3aWxsIGRldGVjdCB0aGUNCj4g
dmFyaWFudCBieSBpdHNlbGYgdXNpbmcgdGhlDQo+IGNoaXAgaWQvdmVyc2lvbiByZXR1cm5lZCBi
eSB0aGUgZGV2aWNlLg0KPiANCj4gcnRsODM2N3JiIGNoaXAgSUQvdmVyc2lvbiBvZiB0aGUgJzY3
UkIgaXMgYWxyZWFkeSBpbmNsdWRlZCBpbiB0aGUNCj4gZHJpdmVyIGFuZCBpbiB0aGUgZHQtYmlu
ZGluZ3MuDQo+IA0KPiA+IEJlc2lkZXMgdGhhdCBzbWFsbCBpbmFjY3VyYWN5LCBJIHRoaW5rIHlv
dXIgZGVzY3JpcHRpb24gaXMgbWlzc2luZyBvbmUgY3J1Y2lhbA0KPiA+IGJpdCBvZiBpbmZvcm1h
dGlvbiwgd2hpY2ggaXMgdGhhdCB0aGUgY2hpcCBJRC92ZXJzaW9uIG9mIHRoZSAnNjdSQiBpcyBh
bHJlYWR5DQo+ID4gaW5jbHVkZWQgaW4gdGhlIGRyaXZlci4gT3RoZXJ3aXNlIGl0IHJlYWRzIGFz
IHRob3VnaCB0aGUgJzY3UkIgaGFzIHRoZSBzYW1lIElEDQo+ID4gYXMgb25lIG9mIHRoZSBhbHJl
YWR5LXN1cHBvcnRlZCBjaGlwcyAoJzY1TUIgb3IgJzY3UykuDQo+ID4gV2l0aCB0aGUgYWJvdmUg
Y2xhcmlmaWNhdGlvbnM6DQo+ID4NCj4gPiBSZXZpZXdlZC1ieTogQWx2aW4g4pS8w6FpcHJhZ2Eg
PGFsc2lAYmFuZy1vbHVmc2VuLmRrPg0KDQpXaGlsZSB0aGUgY29kZSBpcyBPSywgb24gc2Vjb25k
IHRob3VnaHQgSSB0aGluayBiYXNlZCBvbiBBbmRyZXcncyBwb2ludHMgaW4gdGhlDQpvdGhlciBz
dWJ0aHJlYWQgdGhhdCB3ZSBhcmUgYmV0dGVyIG9mZiB3aXRob3V0IHRoaXMgcGF0Y2guDQoNCktp
bmQgcmVnYXJkcywNCkFsdmlu
