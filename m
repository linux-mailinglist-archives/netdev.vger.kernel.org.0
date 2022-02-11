Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C804B227B
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344220AbiBKJyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:54:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbiBKJyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:54:18 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60125.outbound.protection.outlook.com [40.107.6.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F043AE6F
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 01:54:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L08i4hbpBB05mvZtmKHnOUs87JFI6/0FxFVG412Dr0kjvYnCXnskxQkO5oqxup8ewh4+Wu25lFHJl84MHQ/Ixj4dsy+bMIUrEW4mUb5ewYiZb9IcZa4mCJ1y4JK6tUYFnRJfrqd2tK4eUG4hZDccFtTyoyhyZlpz0oB8u4t9bXIHWrzwimzbW4uyAxfeF/t8lN3dgdtSrsK0aZENkv3aXIoAL/OcLtK13olR2yWtWTZwsxrvxxBI5ITQUU1SCzOZnVHqnDW2mouvEzTVRxLheRDGp8pbf4DQCEHHApj250F+ijJxJDkK2ITwx7CovT7IyvO14or+/XIUTtz0TC5H0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61s93TTbhc+6hxLsCDDKZFNJ3iFS+yulLYZQS9ZrXqE=;
 b=mwfYh/WpgIaZzfgfRjDl//6OACy1+Cezc0IQaYbDfxfIzE9wSvcNsyczzT32+r2rfgsHCjo2qHNJDKAQpnjmr/0uPe1tQVPuelPkqRLR5rew9RhxNsWgJJ4x92tAS+mC+Hjx2EtRUMXDEX2Ap2XgqdZX68fLK0wi7tyK6ZdYmccG5+NWMjwByVez/FxATvEplUnSbSUdzZDwL5GBg3Grp3pWdSY851T8GR2+ikGc+KCp9QP9oayVJ8jKkFBbZDbMV+CxqAceXG8WyhGbKwVrWWFBM6za0exHG/d6kGrGjUvBsW3w3GDy1yyErOL7Sg+REtCeYmM/V6km8CzHDNRGMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61s93TTbhc+6hxLsCDDKZFNJ3iFS+yulLYZQS9ZrXqE=;
 b=rozK62kn4yLIc+9CkjTwh4mjfb5gbvsHD+tnENPkL2b2DL7RB+a9EH+eLun8sEZH/l2x+MaxGJVXp0YeX1jVTKweJysvOpJpbaDgzLAchSuK40wayoyf9hOHIiciQNgsbKRDfWQ5DJs3F2PxygU3fOUJimvlGAL1iylqOvsNt0E=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AS8PR03MB7784.eurprd03.prod.outlook.com (2603:10a6:20b:406::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Fri, 11 Feb
 2022 09:54:14 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7%4]) with mapi id 15.20.4975.015; Fri, 11 Feb 2022
 09:54:14 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH net-next] net: dsa: realtek: realtek-mdio: reset before
 setup
Thread-Topic: [PATCH net-next] net: dsa: realtek: realtek-mdio: reset before
 setup
Thread-Index: AQHYHwZAb1BodMcgWU25hJrj7CHadA==
Date:   Fri, 11 Feb 2022 09:54:14 +0000
Message-ID: <87a6exwwxl.fsf@bang-olufsen.dk>
References: <20220211051403.3952-1-luizluca@gmail.com>
In-Reply-To: <20220211051403.3952-1-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Fri, 11 Feb 2022 02:14:04 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92d762d1-8e45-40ec-e3ff-08d9ed44765a
x-ms-traffictypediagnostic: AS8PR03MB7784:EE_
x-microsoft-antispam-prvs: <AS8PR03MB778439DF39A1EA2E169AA66083309@AS8PR03MB7784.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vZRaaiJhVdZs9imnQW9IhdNLEHC4ilpGnDYslMyDWqUCD6ciwjiUiAaQ4SU9gAeY6lgriAWv0SFtXMELzpHSbecTlow7EFmFs0Rhxfd93z8hQXdqxzycG2FjOzutiSWcdw36d6kfNHZFODePJ66SR7TMUF5uN9qnVhYUOcrfCjj87nMKCltoA5UqrVMzx0isi6aMyfVGILqYflDIfgOZnUfLmEcpqKpxN5mWHIevtBKHjmMB2UoRcqeL3uDsdXyd6qRYSytiMukzdudUZWSZYNNwEl/2XSXJA67YmWWBBQ7xpE/XX3TAhVwsD+82tNQfnsVy6+gFDXwf14U4L2AwrpaWmhqna63/+Z7Ys4YA3E/VBsasMzg3lKOAt2pTSwjnTo1TSUh8pq6jBRVi2FqJh5yNYvWz4+IEq48JsDa7KJ6xAMS8mRc7/GcdtdWYgskoKJ49oVmJbtu+HN66+dy9SpJj0IOUVHASJpEPutITrRoX20q+X+7jgHeAF3RteONPDSC5QDIkL6c4C4XRSE1BGOQ539jic64u2DFyvhu5B16qLMwoXawlTFE48ECX8Ie2O5LIPwH2/xSy4el32qPLBBUuKlQnzbI34AWbDMiew1zOTyeRzh7ge0RUEL9umIN1Kd3aHg3r/TQyxu38KxJyZpIFei2VnWNcLGTUL+aB2dhG5DkUpVe6e0BJAVqnnVPr7g2TId9bisS/6lZJ1zBKug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(316002)(122000001)(83380400001)(66574015)(6916009)(54906003)(6512007)(186003)(6506007)(2616005)(2906002)(71200400001)(38070700005)(508600001)(6486002)(8676002)(38100700002)(86362001)(8936002)(5660300002)(85202003)(36756003)(4326008)(7416002)(8976002)(91956017)(85182001)(66556008)(76116006)(66476007)(66946007)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZjFZOHpWdm9ibE1QUk9odGp0Yyt4RVlqZlBBTzBSZFBqU2JZRGp3MTdsbDVn?=
 =?utf-8?B?djlFL3lsTHFkSlcvUThwTWdtUnVmTVV6ekNsUDVzdjRnWWd2OFBJbE5UY2VJ?=
 =?utf-8?B?Z3NpVjJQZVJqNzR3MTUwSm45VGxaVStmSnZBVjZjSlFQZkpxUHFFSUd5TzdP?=
 =?utf-8?B?VzNoMnczYkNwL1JlSU5NMnJZd2hZckM3VFMzdnpBOFZlTjU5KzdhQi9PcDNB?=
 =?utf-8?B?VVZnQ3d5T3pIUlIxUU9XNkZWZnpIMEtpSDh4cCtHQ3JkQysyMnRHQVhHM1Q4?=
 =?utf-8?B?TElEOGdUelQyeHEzN0lxYWV6VWl0UXlhdXpBRHhhdUJoV0U3Z21xT2theGlJ?=
 =?utf-8?B?NTZNUkZWU2pBdXgycjRtRG1CYVZwb2d6blg2M00vMVN0QVM3NmlkN21pSXZF?=
 =?utf-8?B?bXFWd2lKNGduOWV1Tm00TjZ4eW5VV0JGZFQyTjNHNjJXNnQ4ZTJiUDh4bkVC?=
 =?utf-8?B?WkJadXViTEhhV1ZCQzRscm40ZHdiMk9TRU9mTFVlbERXaERmd2JlbFZPYVVZ?=
 =?utf-8?B?bkNGMzZueXBGc0N4TEYzU2ZvbXZJb0hWUDZpZHA4c2FvNGM4TklQeWh2UndP?=
 =?utf-8?B?eWdLb0NVQnRPMlgyTzBMcVZWYmRySG1sbEREZml0TU5mRjlLMHRKMDdKTStU?=
 =?utf-8?B?L054N2FKUVcyOHZpbVN4SWtoSkRaNVlTbE1HZ1VtNVo0ZXdJS1ExNzZiUE5K?=
 =?utf-8?B?Z3BPOUtQZVBDNU1VajhIdTYraWowWTg3MFgwMUtFZHlNUmo4dkpVZjBUVXJO?=
 =?utf-8?B?QXFiaWZaK3V0NGdicVZqdHJlRmpBZVFDSnd2QjRZMGxzbjRIaldXRUppaGlr?=
 =?utf-8?B?SU4xL3hiczZLdEFnWHowUHA5TTFZM3h1U1AwM2c1NTNuMFN3alc5S0dNdGFt?=
 =?utf-8?B?cFlUMXJsVUJaSFNKbUNEWkdnbWErWTZKYWVvR2dLTy8ydmYraEZNQ2ZuR3l1?=
 =?utf-8?B?S3VKMnZjdktzOCtpMHNyMnliSjNWTWpad2VlRVo4UzJyWU5EN3Q2aTNwV1ZX?=
 =?utf-8?B?NWRjYi9yZ2RkTGwxUEpPSDUxUVA5R1dIVm1yajZvaE5HV1l0UW1GaGo2OHdX?=
 =?utf-8?B?bjhPQ2tKUStQek8xUE9UMTNLeUt3Q0pGa041YUI2ekQydXhGUS9iYzBEVVp0?=
 =?utf-8?B?VXZCZW12R2gwQU1lL2psYnA3TDcwa1h6cTMzS3Btc240aUI4SWVjclFHcm5C?=
 =?utf-8?B?Q3JReERFL041b1dXcXZ3aHJGdTVMY3ZQUHM3OFJEcS9hWUNNV2NZcDd6YlhU?=
 =?utf-8?B?WTVXdXF2dzBNaHd2eks2bkNFWTF0K3JCelA5R1ozTmNqR3RrY2pkWHk2WnpD?=
 =?utf-8?B?em5YZVFDYjRXZlpXZjVDS1YxdlovUVZlR01PMmtEcXVoZTZLTjBRa0tmUUcv?=
 =?utf-8?B?TVBBWXdXcEVVK1dPVlZ3VmJoMHREcVltMGdKNjdtdVNYOWRXMVkycDBhNFdk?=
 =?utf-8?B?VHZ4UTBmeGxCUjhtRktwaXNaMkI1OTY3OGZESEZ0OTNtN083ZlAwSzQxMFdx?=
 =?utf-8?B?ZFgralJIbzJLa3FZeml4Z2lFRXk3NEFyUkdacmtVOXZTY25ZVnpLVTRiVVlu?=
 =?utf-8?B?N0NLOUFWQW5rZ09uMno5T09iVUlkS25rRzg3UzJFQXdjNHFuYTJzU29keTVm?=
 =?utf-8?B?VVV1Q044WVF1Wk1pWERWRW1QcW5XMVFzVHpEbk81UUpGcThIRHYxZDJIWUdw?=
 =?utf-8?B?a1p2SE8xWUJsTW5PTEw2cXlwSUJXQ0tKR3pGcFQ4c2FYNGRiY0ZHbDFuc1pL?=
 =?utf-8?B?R202bEpUd2NwbjAxSUFuQzAyS1hZZE5VVi9aT3FJNGxsaVdsandwbjhrdWtF?=
 =?utf-8?B?K3RDZDJjdlFEOVNDZVVOUWVzTDhVSEYwS3lwY29lTDJTVGR4K0VUSnRldGZu?=
 =?utf-8?B?SWZSZDkzZERCbEdCcmNPUE5PTjJLTHRPRlAwWnV6S0d4M0tTc3B1OEQxNlRJ?=
 =?utf-8?B?RFB1QXpGdHE3TVVSTXI1TXRUbStNZGhqRTZEei9sRjdoa0g1MDFFVFY5TThF?=
 =?utf-8?B?eUpEejh2eS9rY1c0dkhOV2J3ajJ4TCtjRmZ0dmZFWnlHV2ZTcUR5UmhNNk54?=
 =?utf-8?B?VlFMNFFJY2czQ1NnWEVzbEg5SzdNMVVER3QyeDlsTERvUGIyNDB2Nks4VENG?=
 =?utf-8?B?MGRJYjc0MklPT3VpOVp2cW9oTDNKbDZZZUhVOVltT0ZNZTZyYnhqWWdaRHJh?=
 =?utf-8?Q?8E0jkXv9vYfWKkQ1KSLERlM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <914947995BACA5409F9E5168530F0A59@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d762d1-8e45-40ec-e3ff-08d9ed44765a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 09:54:14.7925
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gcTRvro26EqtSFw/M6BqoY2D5VuDSP+vBPSMcsFR/RbDAmkQlCqj0WsYwDcvy8tMVp741EIfyn5IIKj9RKQc3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7784
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cml0ZXM6DQoN
Cj4gU29tZSBkZXZpY2VzLCBsaWtlIHRoZSBzd2l0Y2ggaW4gQmFuYW5hIFBpIEJQSSBSNjQgb25s
eSBzdGFydHMgdG8gYW5zd2VyDQo+IGFmdGVyIGEgSFcgcmVzZXQuIEl0IGlzIHRoZSBzYW1lIHJl
c2V0IGNvZGUgZnJvbSByZWFsdGVrLXNtaS4NCj4NCj4gUmVwb3J0ZWQtYnk6IEZyYW5rIFd1bmRl
cmxpY2ggPGZyYW5rLXdAcHVibGljLWZpbGVzLmRlPg0KPiBTaWduZWQtb2ZmLWJ5OiBMdWl6IEFu
Z2VsbyBEYXJvcyBkZSBMdWNhIDxsdWl6bHVjYUBnbWFpbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVy
cy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRlay1tZGlvLmMgfCAxOSArKysrKysrKysrKysrKysrKysr
DQo+ICBkcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLXNtaS5jICB8ICA2ICsrLS0tLQ0K
PiAgZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRlay5oICAgICAgfCAgOSArKysrKystLS0N
Cj4gIDMgZmlsZXMgY2hhbmdlZCwgMjcgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCj4N
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0ZWstbWRpby5jIGIv
ZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRlay1tZGlvLmMNCj4gaW5kZXggZTZlM2MxNzY5
MTY2Li43OGI0MTlhNmNiMDEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVr
L3JlYWx0ZWstbWRpby5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0ZWst
bWRpby5jDQo+IEBAIC0xNTIsNiArMTUyLDIxIEBAIHN0YXRpYyBpbnQgcmVhbHRla19tZGlvX3By
b2JlKHN0cnVjdCBtZGlvX2RldmljZSAqbWRpb2RldikNCj4gIAkvKiBUT0RPOiBpZiBwb3dlciBp
cyBzb2Z0d2FyZSBjb250cm9sbGVkLCBzZXQgdXAgYW55IHJlZ3VsYXRvcnMgaGVyZSAqLw0KPiAg
CXByaXYtPmxlZHNfZGlzYWJsZWQgPSBvZl9wcm9wZXJ0eV9yZWFkX2Jvb2wobnAsICJyZWFsdGVr
LGRpc2FibGUtbGVkcyIpOw0KPiAgDQo+ICsJLyogQXNzZXJ0IHRoZW4gZGVhc3NlcnQgUkVTRVQg
Ki8NCj4gKwlwcml2LT5yZXNldCA9IGRldm1fZ3Bpb2RfZ2V0X29wdGlvbmFsKGRldiwgInJlc2V0
IiwgR1BJT0RfT1VUX0hJR0gpOw0KPiArCWlmIChJU19FUlIocHJpdi0+cmVzZXQpKSB7DQo+ICsJ
CWRldl9lcnIoZGV2LCAiZmFpbGVkIHRvIGdldCBSRVNFVCBHUElPXG4iKTsNCj4gKwkJcmV0dXJu
IFBUUl9FUlIocHJpdi0+cmVzZXQpOw0KPiArCX0NCj4gKw0KPiArCWlmIChwcml2LT5yZXNldCkg
ew0KDQpncGlvZF9zZXRfdmFsdWUgc2VlbXMgdG9sZXJhbnQgb2YgYSBOVUxMIGdwaW9fZGVzYyBw
b2ludGVyLCBidXQgcGVyaGFwcw0KeW91IHdvdWxkIGxpa2UgdG8gYWRkIHRoZSBzYW1lIGlmIHN0
YXRlbWVudCB0byByZWFsdGVrLXNtaSBzbyB0aGF0IGl0DQpkb2Vzbid0IHByZXRlbmQgdG8gcmVz
ZXQgdGhlIGNoaXAgd2hlbiB0aGUgcmVzZXQgR1BJTyBpcyBhYnNlbnQ/DQoNCj4gKwkJZGV2X2lu
Zm8oZGV2LCAiYXNzZXJ0ZWQgUkVTRVRcbiIpOw0KPiArCQltc2xlZXAoUkVBTFRFS19IV19TVE9Q
X0RFTEFZKTsNCj4gKwkJZ3Bpb2Rfc2V0X3ZhbHVlKHByaXYtPnJlc2V0LCAwKTsNCj4gKwkJbXNs
ZWVwKFJFQUxURUtfSFdfU1RBUlRfREVMQVkpOw0KPiArCQlkZXZfaW5mbyhkZXYsICJkZWFzc2Vy
dGVkIFJFU0VUXG4iKTsNCj4gKwl9DQo+ICsNCj4gIAlyZXQgPSBwcml2LT5vcHMtPmRldGVjdChw
cml2KTsNCj4gIAlpZiAocmV0KSB7DQo+ICAJCWRldl9lcnIoZGV2LCAidW5hYmxlIHRvIGRldGVj
dCBzd2l0Y2hcbiIpOw0KPiBAQCAtMTgzLDYgKzE5OCwxMCBAQCBzdGF0aWMgdm9pZCByZWFsdGVr
X21kaW9fcmVtb3ZlKHN0cnVjdCBtZGlvX2RldmljZSAqbWRpb2RldikNCj4gIAlpZiAoIXByaXYp
DQo+ICAJCXJldHVybjsNCj4gIA0KPiArCS8qIGxlYXZlIHRoZSBkZXZpY2UgcmVzZXQgYXNzZXJ0
ZWQgKi8NCj4gKwlpZiAocHJpdi0+cmVzZXQpDQo+ICsJCWdwaW9kX3NldF92YWx1ZShwcml2LT5y
ZXNldCwgMSk7DQo+ICsNCj4gIAlkc2FfdW5yZWdpc3Rlcl9zd2l0Y2gocHJpdi0+ZHMpOw0KDQpX
b3VsZG4ndCB5b3UgcHJlZmVyIHRvIHJlc2V0IHRoZSBjaGlwIGFmdGVyIGRzYV91bnJlZ2lzdGVy
X3N3aXRjaCgpPw0KDQpPdGhlcndpc2U6DQoNClJldmlld2VkLWJ5OiBBbHZpbiDFoGlwcmFnYSA8
YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQoNCj4gIA0KPiAgCWRldl9zZXRfZHJ2ZGF0YSgmbWRpb2Rl
di0+ZGV2LCBOVUxMKTsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3Jl
YWx0ZWstc21pLmMgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLXNtaS5jDQo+IGlu
ZGV4IGE4NDliNWNiYjRlNC4uY2FkYTUzODZmNmEyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC9kc2EvcmVhbHRlay9yZWFsdGVrLXNtaS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFs
dGVrL3JlYWx0ZWstc21pLmMNCj4gQEAgLTQzLDggKzQzLDYgQEANCj4gICNpbmNsdWRlICJyZWFs
dGVrLmgiDQo+ICANCj4gICNkZWZpbmUgUkVBTFRFS19TTUlfQUNLX1JFVFJZX0NPVU5UCQk1DQo+
IC0jZGVmaW5lIFJFQUxURUtfU01JX0hXX1NUT1BfREVMQVkJCTI1CS8qIG1zZWNzICovDQo+IC0j
ZGVmaW5lIFJFQUxURUtfU01JX0hXX1NUQVJUX0RFTEFZCQkxMDAJLyogbXNlY3MgKi8NCj4gIA0K
PiAgc3RhdGljIGlubGluZSB2b2lkIHJlYWx0ZWtfc21pX2Nsa19kZWxheShzdHJ1Y3QgcmVhbHRl
a19wcml2ICpwcml2KQ0KPiAgew0KPiBAQCAtNDI2LDkgKzQyNCw5IEBAIHN0YXRpYyBpbnQgcmVh
bHRla19zbWlfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIAkJZGV2X2Vy
cihkZXYsICJmYWlsZWQgdG8gZ2V0IFJFU0VUIEdQSU9cbiIpOw0KPiAgCQlyZXR1cm4gUFRSX0VS
Uihwcml2LT5yZXNldCk7DQo+ICAJfQ0KPiAtCW1zbGVlcChSRUFMVEVLX1NNSV9IV19TVE9QX0RF
TEFZKTsNCj4gKwltc2xlZXAoUkVBTFRFS19IV19TVE9QX0RFTEFZKTsNCj4gIAlncGlvZF9zZXRf
dmFsdWUocHJpdi0+cmVzZXQsIDApOw0KPiAtCW1zbGVlcChSRUFMVEVLX1NNSV9IV19TVEFSVF9E
RUxBWSk7DQo+ICsJbXNsZWVwKFJFQUxURUtfSFdfU1RBUlRfREVMQVkpOw0KPiAgCWRldl9pbmZv
KGRldiwgImRlYXNzZXJ0ZWQgUkVTRVRcbiIpOw0KPiAgDQo+ICAJLyogRmV0Y2ggTURJTyBwaW5z
ICovDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLmggYi9k
cml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLmgNCj4gaW5kZXggZWQ1YWJmNmNiM2Q2Li5l
N2QzZTFiY2Y4YjggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0
ZWsuaA0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLmgNCj4gQEAgLTUs
MTQgKzUsMTcgQEANCj4gICAqIENvcHlyaWdodCAoQykgMjAwOS0yMDEwIEdhYm9yIEp1aG9zIDxq
dWhvc2dAb3BlbndydC5vcmc+DQo+ICAgKi8NCj4gIA0KPiAtI2lmbmRlZiBfUkVBTFRFS19TTUlf
SA0KPiAtI2RlZmluZSBfUkVBTFRFS19TTUlfSA0KPiArI2lmbmRlZiBfUkVBTFRFS19IDQo+ICsj
ZGVmaW5lIF9SRUFMVEVLX0gNCj4gIA0KPiAgI2luY2x1ZGUgPGxpbnV4L3BoeS5oPg0KPiAgI2lu
Y2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L2dwaW8v
Y29uc3VtZXIuaD4NCj4gICNpbmNsdWRlIDxuZXQvZHNhLmg+DQo+ICANCj4gKyNkZWZpbmUgUkVB
TFRFS19IV19TVE9QX0RFTEFZCQkyNQkvKiBtc2VjcyAqLw0KPiArI2RlZmluZSBSRUFMVEVLX0hX
X1NUQVJUX0RFTEFZCQkxMDAJLyogbXNlY3MgKi8NCj4gKw0KPiAgc3RydWN0IHJlYWx0ZWtfb3Bz
Ow0KPiAgc3RydWN0IGRlbnRyeTsNCj4gIHN0cnVjdCBpbm9kZTsNCj4gQEAgLTE0Miw0ICsxNDUs
NCBAQCB2b2lkIHJ0bDgzNjZfZ2V0X2V0aHRvb2xfc3RhdHMoc3RydWN0IGRzYV9zd2l0Y2ggKmRz
LCBpbnQgcG9ydCwgdWludDY0X3QgKmRhdGEpOw0KPiAgZXh0ZXJuIGNvbnN0IHN0cnVjdCByZWFs
dGVrX3ZhcmlhbnQgcnRsODM2NnJiX3ZhcmlhbnQ7DQo+ICBleHRlcm4gY29uc3Qgc3RydWN0IHJl
YWx0ZWtfdmFyaWFudCBydGw4MzY1bWJfdmFyaWFudDsNCj4gIA0KPiAtI2VuZGlmIC8qICBfUkVB
TFRFS19TTUlfSCAqLw0KPiArI2VuZGlmIC8qICBfUkVBTFRFS19IICov
