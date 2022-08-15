Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFAE95929D0
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 08:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240971AbiHOGrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 02:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiHOGrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 02:47:36 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2041.outbound.protection.outlook.com [40.107.20.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC1D12759
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 23:47:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BiaOg8hR6B8L/6VRVNbe9EKyx5kmUmfx7KLPXwnOVFBL+ui6h8TIzFOH9eSK1WM4Ny+BS4Z78lCTOF34Ux/qUiBYyBmioswtfnGymQWrlwfareaRAFbqR+fRYYgjpyGpWuhy9nVSU5LuG1qao3Fhc4yvYiNSXvYRkrvhMRA/2RiyQrtPRkdhJyHmgkCLsOf/umctABKtrbd/DDVouaj6VWYq3UMp1TxOZxTOL0M4di5rTHFYVdOe/qCKCwXQV3y2j3Vwc3T2yksmvlxMUHnxC7BFG4MDtZCekZR9vUQXbi1nF/AMkCORAseS0SumygvdDP3RLNn3HfvEAQGzHJYF4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JI38xcsjFSSDIqeGG5aYXr8BRC1fa5hn7c1JuG2auig=;
 b=PgYYGNxI6xSfe7hV8XmVvPoIVM+5RzO2L11nXFB8P4ziFP0kfGnG2LmqC4cOMgGjJImCAAzNxGxPBh8LK/+37w3icN7gZrmrRgUgzI/H2jQv1jIAY+/PG8PlgEpM6Kyw3XNrDpP3dErLKqB4MRfrVGNPeTrUeYO8gtvPAaIb/k+AK+U9BmJA2OBK7/vysNgSlhpKyUHeCT/qilxkUdflsV+83FeO3DzFMhZ8OraYR+wchpJ7IwtG8xgoxU+OIAlERbkxc5Dnq4+/ZhtH3srkG3bcUISNpXQ3sowhZ610Lc38XIu8QmXvmUN2d70nGe5bjq6mHtO7Zpj4bj7JX+AMyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JI38xcsjFSSDIqeGG5aYXr8BRC1fa5hn7c1JuG2auig=;
 b=UaMF6v8ps3ugjJMnRo8kmZuRxC8aBatiLpoUMdbkAhPfxx66n3Q0RNxley+e4dbnMcPSETmhdzq3XpDlfh0YdlW51RXqcl247E4+rm0KCwAmnc37nzWXZUWzmoWPZwwODGLqPKgZuBq3WxXgnbtF10gNVqi7XLFNL3shLk69EkQ=
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com (2603:10a6:803:29::11)
 by HE1PR0701MB2251.eurprd07.prod.outlook.com (2603:10a6:3:1d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.14; Mon, 15 Aug
 2022 06:47:32 +0000
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a]) by VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a%5]) with mapi id 15.20.5546.014; Mon, 15 Aug 2022
 06:47:31 +0000
From:   Ferenc Fejes <ferenc.fejes@ericsson.com>
To:     "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>
CC:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "marton12050@gmail.com" <marton12050@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
Thread-Topic: igc: missing HW timestamps at TX
Thread-Index: AQHYmepVJYOkQdQn8k+cRlOb7lKNfK2vsfIA
Date:   Mon, 15 Aug 2022 06:47:31 +0000
Message-ID: <1016fb1e514ff38ebfd22c52e2d848a7e8bc8d1a.camel@ericsson.com>
References: <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
         <87tu6i6h1k.fsf@intel.com>
         <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
         <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
         <87tu7emqb9.fsf@intel.com>
         <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
         <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
         <87tu6i6h1k.fsf@intel.com>
         <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
         <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
         <20220812201654.qx7e37otu32pxnbk@skbuf>
In-Reply-To: <20220812201654.qx7e37otu32pxnbk@skbuf>
Accept-Language: hu-HU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ericsson.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66ccebaf-779b-49ff-7b21-08da7e8a071d
x-ms-traffictypediagnostic: HE1PR0701MB2251:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QiWH8IvduDBGCfqKYGRU8/q/2P3vVfj/940KFJOMb4jFmGowHop+OqNeraXUqS7UwEZUtO92yvoqYButwr5vkI7+TzFy+SvzNwFolBJw/KTbNhTWP9Znd6AG8SHf7OWN+LFOrCaWZY2jB6jURLjZY/QrnhN8OlGjFbftfsVRl90Qf0Su7FUmg7u7KvQ4/pTvGWr4kK1HDsfYhuAxtDcg5PcHOmBbfU4pM/ZEEvJk8dyGDnauK0p5LDIJWB7GaI+0O/cwsvviIyldWR7iPR8rGKpVX1z+752WChYcE2C+eSIJJS3o2LdK6h2fhCGIyj2JSg2hzd7CdSgWyTwLXEsr5n8+B2fMpwIn++6iYmzjYDPrDB7xT0Wle2hmDLyccJPaoHluw3S3t0MJ9Pkn/jDoaG2bDeEcXox15yZDMFPK0UoRP8/mTPVbhvWRf5JG/GeUPypDhVKTjxenV3WxIiLt/1e7wiaISbYxs9UqYoAxwKl1D/4e92JMcw2+IQZQUZd0TbR4z0edD3XFmY43cZdg0c8I9GHN7VrW3bwKODJ7V0vaJk3qER2QHRqP+2gclpi1Qu8t0I1W9sFBD97pcHLO0XcKnQr20PEAZy0iJ1G6RNFASaBCd+2AeWfZWZQlC/iBbp3eYGAuqZaFXg8ASPYQXUsO2V76MU+G8vejSu8y7oyhRGQIqeP5TxyClwsUXHyktt6RPEtPTx6ZZvFdFmNllj1i6Dba9dEYYuvACqvs9ZQ0gCmmfR/0jtsWr/WhKT6Wo3mGaZTg2GWhMzK2ilIHDQwnb+qmsQZizTbqpkhQk/EsPXNJGOfyy2iq+lArCeGV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB4080.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(316002)(83380400001)(6506007)(6512007)(6486002)(54906003)(6916009)(44832011)(2906002)(8936002)(36756003)(86362001)(38070700005)(82960400001)(5660300002)(4326008)(122000001)(38100700002)(2616005)(186003)(26005)(41300700001)(478600001)(71200400001)(76116006)(66946007)(66446008)(64756008)(91956017)(66556008)(66476007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkJ2SzJDbWtWUTN1Z05oOXd4Z0NZTmJIaXpvaEk5T1FYcGFRT3JVaHRiek1I?=
 =?utf-8?B?NU5XS2M1aldOQVYrV1Y1Q25TYUI3VWhVL1M2SHd3MUFBNlpkTUFTNHhta2NB?=
 =?utf-8?B?L1FDeE40R1M5Z0ZqMzlVT2ZIV1lLZm8wdFR2M3lOOVFGOS8zeUxZTU9oZGgy?=
 =?utf-8?B?c21aVUhhbVllY1ZONDlyVEJSb0RGMGd4QVZHRGVHbVpGSS96ZGZLWG1KZ1Fa?=
 =?utf-8?B?ZkhZb3U4Q3BDeHZqTkFFdUtYWGx3dEtENWZkTCtZd3NiRFkxS09kRmt2bGFU?=
 =?utf-8?B?emhKcCt6SzBKQy94aGR5QUh4ZGUyN29kcFZld0haeVFscmhnSy9kb0VPNDcy?=
 =?utf-8?B?Q0g4MnA2Zmt0Rnh2UU5BV3lqczFkLzNyMmZVOGdsY2VmdW5Dam8zRzA1Z1lE?=
 =?utf-8?B?UDhlc3dBK0w5SGhPMFJBVkcxV2NwMHpYQ3gyU2lCNkFxRDFDaU5PT3BLYVc4?=
 =?utf-8?B?NFFBeHJsaXlFTEtnOFFqOWRSOHFmUmJxSUJZWno5UVFxZU1lenVrdjV5bGxj?=
 =?utf-8?B?WkkvQm9WRyszNTJGTkxrUVM4Nzg2NlFUOUVUSlVCYndTOVA1U0F4NEhmd2V2?=
 =?utf-8?B?a0R2dU5lZ3NVUnhiN3VPUkR6djl4TUpMT2NWdkZHaHJhMmVmQ3FzdmsvanFM?=
 =?utf-8?B?aGdnbXh0QVhpTnd0TjRQclBsd3ROQzZWUGxaQmZYZ2lqS2M5ZVd6c0diMHVY?=
 =?utf-8?B?NktLOHFGeUkrZHlKc3FkNU1KWlVVUXZYNnNzYXovUFNWaDVzNkZkQ010UG9F?=
 =?utf-8?B?YnRLREh5ZStCVHNoSjFVZzg2TWNhV0x6bG1GVS92SlMzNDQ0SnJzdFJFNU05?=
 =?utf-8?B?MVN3MXZxNkpDV1Nzc0JWMFNVZnBsUDVVcnFUVU51K3E2SU1xakpIMEkvbVhN?=
 =?utf-8?B?TG14ZktpQ3QvMWJBT0lOT0d4cjl1Y0dsazByQkh5NDMrM1Y2Q2dyaW5IOTN6?=
 =?utf-8?B?Y08zTW9veHlPb0NTci9XekVXNFZHM2tkc3lFcEJ0MENhcFp6NVhKMFNtUkdj?=
 =?utf-8?B?TU1FbU9RSjhSWTRsWkYwQ2RVSVRlM2ZJMUJaZ0Z0ZE04dktkR3VoU0NCb0JY?=
 =?utf-8?B?L0RJcGpEdGF2aHZUNldQcjVsWEVNUGd1RjFZMDhCbjFDY214SmI5UzBLYUVV?=
 =?utf-8?B?RmpXa1ZnOEZGbjB6eTJ3bmRDVzQwOHBKUk4zTmFrVk9uaWZqc0tJODRUa3p3?=
 =?utf-8?B?YzlFTDhuaVNoVi84VDZVamtIU25mQ0FQdzhEd2xhTGxhRXB0dVFIR3dVSWU3?=
 =?utf-8?B?MTk2M1JFTmdneUJpc0dWcDZwaktjdEZONTlkQVFvVGM3V0ZHNDREeHh4NzJE?=
 =?utf-8?B?VERrSzJCQ1AzOXJPdTBlbkhFNDJqYVdSdDgvSEVKbEFMRWRGN2tHQXhvTDZ3?=
 =?utf-8?B?Y0d6ZmszSmJreTZHSlhFbWpKWURPZjBNd05idE92MTkzbFhLODBkUytUV0ho?=
 =?utf-8?B?K09Pdzd5RGxvdno0Smhub01nZ3R1TisrM09iWmg2QS9UQ2pJQzFlVEk5ekw2?=
 =?utf-8?B?TlRtVkFKa0w2bHgrMENGZm1DZ1dDaGR4SWRITTBVZnF4SExWY3RQNVZVejht?=
 =?utf-8?B?YkhhN2dja2d5UjU1S1VncU9zWGpUeE9ZSTlEZWNwc3lwd05NcXd2ZkhiNUdY?=
 =?utf-8?B?VkI1SDVYY1RBWnIrUWhRc2prajJldW45SmY3SG5HM1RXS0RzeVFnOGVZbVFS?=
 =?utf-8?B?Zmg1MXQ5ZXhNbnJRaEV5SEN3VU5IaWtWeVQ5eUh0dVJoYUliUFZxYzJ4eGlY?=
 =?utf-8?B?OVdDZW5sdXhrbUFncmpHN1NFa1lhVjRsTzZFNDc1ZVZSZjVFMmpaTWE3RE8v?=
 =?utf-8?B?QTVRTHphY05ia0ZJam4veWV6ZkNTbU95Q1hWeHJ4bG9LenpEaFNDRHVENENv?=
 =?utf-8?B?blJraHBaaU11M042L1lPdWgxMThzUisybUwxSW43ZnR5SjFPcXBSV3ZrbThV?=
 =?utf-8?B?TWlLckNDN001d1RyZlNoWVA5R1BIWE1RcHV1c0NSWjdtVkdLSFNoTFFtS0g2?=
 =?utf-8?B?citRQjhaQVZiRDJQNS8vcGtxQTZLM0kxZ2pxcnRDTXMzTndTb2Y1S0FzbWFk?=
 =?utf-8?B?dmZTZGJ0c3cvaGV5V3dnOXlzVitXOCs4bXFSMnI0aDlmWVZnZ29HTklWWEkr?=
 =?utf-8?B?dWtGcUtyazQwdFVhUlAzUjR2SGc4eXBrTlRFY2ZKZER6RzBYcmxxL292T3o0?=
 =?utf-8?B?QWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B754F07F2BD62B449F36DCB19044317F@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB4080.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66ccebaf-779b-49ff-7b21-08da7e8a071d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2022 06:47:31.5993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I30CBvURxU8VvxH0sUymh+7+3brkHps4J3kfIovgt0i33eUUsNbTiByPIDYBv5q3qQTMan1AQhOjAOq2r2Zh05FhjFABP4ZF6KCPWQS9fjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0701MB2251
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIhDQoNClRoYW5rIHlvdSBmb3IgdGhlIHJlcGx5IQ0KDQpPbiBGcmksIDIwMjIt
MDgtMTIgYXQgMjA6MTYgKzAwMDAsIFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4gSGkgRmVyZW5j
LA0KPiANCj4gT24gRnJpLCBBdWcgMTIsIDIwMjIgYXQgMDI6MTM6NTJQTSArMDAwMCwgRmVyZW5j
IEZlamVzIHdyb3RlOg0KPiA+IEV0aHRvb2wgYWZ0ZXIgdGhlIG1lYXN1cmVtZW50Og0KPiA+IGV0
aHRvb2wgLVMgZW5wM3MwIHwgZ3JlcCBod3RzdGFtcA0KPiA+IMKgwqDCoMKgIHR4X2h3dHN0YW1w
X3RpbWVvdXRzOiAxDQo+ID4gwqDCoMKgwqAgdHhfaHd0c3RhbXBfc2tpcHBlZDogNDE5DQo+ID4g
wqDCoMKgwqAgcnhfaHd0c3RhbXBfY2xlYXJlZDogMA0KPiA+IA0KPiA+IFdoaWNoIGlzIGlubGlu
ZSB3aXRoIHdoYXQgdGhlIGlzb2Nocm9uIHNlZS4NCj4gPiANCj4gPiBCdXQgdGhhdHMgb25seSBo
YXBwZW5zIGlmIEkgZm9yY2luZ2x5IHB1dCB0aGUgYWZmaW5pdHkgb2YgdGhlDQo+ID4gc2VuZGVy
DQo+ID4gZGlmZmVyZW50IENQVSBjb3JlIHRoYW4gdGhlIHB0cCB3b3JrZXIgb2YgdGhlIGlnYy4g
SWYgdGhvc2UgcnVubmluZw0KPiA+IG9uDQo+ID4gdGhlIHNhbWUgY29yZSBJIGRvZXNudCBsb3N0
IGFueSBIVyB0aW1lc3RhbSBldmVuIGZvciAxMCBtaWxsaW9uDQo+ID4gcGFja2V0cy4gV29ydGgg
dG8gbWVudGlvbiBhY3R1YWxseSBJIHNlZSBtYW55IGxvc3QgdGltZXN0YW1wIHdoaWNoDQo+ID4g
Y29uZnVzZWQgbWUgYSBsaXR0bGUgYml0IGJ1dCB0aG9zZSBhcmUgbG9zdCBiZWNhdXNlIG9mIHRo
ZSBzbWFsbA0KPiA+IE1TR19FUlJRVUVVRS4gV2hlbiBJIGluY3JlYXNlZCB0aGF0IGZyb20gZmV3
IGtieXRlcyB0byAyMCBtYnl0ZXMgSQ0KPiA+IGdvdA0KPiA+IGV2ZXJ5IHRpbWVzdGFtcCBzdWNj
ZXNzZnVsbHkuDQo+IA0KPiBJIGhhdmUgemVybyBrbm93bGVkZ2Ugb2YgSW50ZWwgaGFyZHdhcmUu
IFRoYXQgYmVpbmcgc2FpZCwgSSd2ZSBsb29rZWQNCj4gYXQNCj4gdGhlIGRyaXZlciBmb3IgYWJv
dXQgNSBtaW51dGVzLCBhbmQgdGhlIGRlc2lnbiBzZWVtcyB0byBiZSB0aGF0IHdoZXJlDQo+IHRo
ZSB0aW1lc3RhbXAgaXMgbm90IGF2YWlsYWJsZSBpbiBiYW5kIGZyb20gdGhlIFRYIGNvbXBsZXRp
b24gTkFQSSBhcw0KPiBwYXJ0IG9mIEJEIHJpbmcgbWV0YWRhdGEsIGJ1dCByYXRoZXIsIGEgVFgg
dGltZXN0YW1wIGNvbXBsZXRlIGlzDQo+IHJhaXNlZCwNCj4gYW5kIHRoaXMgcmVzdWx0cyBpbiBp
Z2NfdHN5bmNfaW50ZXJydXB0KCkgYmVpbmcgY2FsbGVkLiBIb3dldmVyIHRoZXJlDQo+IGFyZSAy
IHBhdGhzIGluIHRoZSBkcml2ZXIgd2hpY2ggY2FsbCB0aGlzLCBvbmUgaXMgaWdjX21zaXhfb3Ro
ZXIoKQ0KPiBhbmQNCj4gdGhlIG90aGVyIGlzIGlnY19pbnRyX21zaSgpIC0gdGhpcyBsYXR0ZXIg
b25lIGlzIGFsc28gdGhlIGludGVycnVwdA0KPiB0aGF0DQo+IHRyaWdnZXJzIHRoZSBuYXBpX3Nj
aGVkdWxlKCkuIEl0IHdvdWxkIGJlIGludGVyZXN0aW5nIHRvIHNlZSBleGFjdGx5DQo+IHdoaWNo
IE1TSS1YIGludGVycnVwdCBpcyB0aGUgb25lIHRoYXQgdHJpZ2dlcnMgaWdjX3RzeW5jX2ludGVy
cnVwdCgpLg0KPiANCj4gSXQncyBhbHNvIGludGVyZXN0aW5nIHRvIHVuZGVyc3RhbmQgd2hhdCB5
b3UgbWVhbiBwcmVjaXNlbHkgYnkNCj4gYWZmaW5pdHkNCj4gb2YgaXNvY2hyb24uIEl0IGhhcyBh
IG1haW4gdGhyZWFkICh1c2VkIGZvciBQVFAgbW9uaXRvcmluZyBhbmQgZm9yIFRYDQo+IHRpbWVz
dGFtcHMpIGFuZCBhIHB0aHJlYWQgZm9yIHRoZSBzZW5kaW5nIHByb2Nlc3MuIFRoZSBtYWluIHRo
cmVhZCdzDQo+IGFmZmluaXR5IGlzIGNvbnRyb2xsZWQgdmlhIHRhc2tzZXQ7IHRoZSBzZW5kZXIg
dGhyZWFkIHZpYSAtLWNwdS1tYXNrLg0KDQpJIGp1c3QgcGxheWVkIHdpdGggdGhvc2UgYSBsaXR0
bGUuIExvb2tzIGxpa2UgdGhlIC0tY3B1LW1hc2sgdGhlIG9uZSBpdA0KaGVscHMgaW4gbXkgY2Fz
ZS4gRm9yIGV4YW1wbGUgSSBjaGVja2VkIHRoZSBDUFUgY29yZSBvZiB0aGUNCmlnY19wdHBfdHhf
d29yazoNCg0KIyBicGZ0cmFjZSAtZSAna3Byb2JlOmlnY19wdHBfdHhfd29yayB7IHByaW50Zigi
JWRcbiIsIGNwdSk7IGV4aXQoKTsgfScNCkF0dGFjaGluZyAxIHByb2JlLi4uDQowDQoNCkxvb2tz
IGxpa2UgaXRzIHJ1bm5pbmcgb24gY29yZSAwLCBzbyBJIHJ1biB0aGUgaXNvY2hybzoNCnRhc2tz
ZXQgLWMgMCBpc29jaHJvbiAuLi4gLS1jcHUtbWFzayAkKCgxIDw8IDApKSAtIG5vIGxvc3QgdGlt
ZXN0YW1wcw0KdGFza3NldCAtYyAxIGlzb2Nocm9uIC4uLiAtLWNwdS1tYXNrICQoKDEgPDwgMCkp
IC0gbm8gbG9zdCB0aW1lc3RhbXBzDQp0YXNrc2V0IC1jIDAgaXNvY2hyb24gLi4uIC0tY3B1LW1h
c2sgJCgoMSA8PCAxKSkgLSBsb3NpbmcgdGltZXN0YW1wcw0KdGFza3NldCAtYyAxIGlzb2Nocm9u
IC4uLiAtLWNwdS1tYXNrICQoKDEgPDwgMSkpIC0gbG9zaW5nIHRpbWVzdGFtcHMNCg0KPiBJcyBp
dCB0aGUgKnNlbmRlciogdGhyZWFkIHRoZSBvbmUgd2hvIG1ha2VzIHRoZSBUWCB0aW1lc3RhbXBz
IGJlDQo+IGF2YWlsYWJsZSBxdWlja2VyIHRvIHVzZXIgc3BhY2UsIHJhdGhlciB0aGFuIHRoZSBt
YWluIHRocmVhZCwgd2hvDQo+IGFjdHVhbGx5IGRlcXVldWVzIHRoZW0gZnJvbSB0aGUgZXJyb3Ig
cXVldWU/IElmIHNvLCBpdCBtaWdodCBiZQ0KPiBiZWNhdXNlDQo+IHRoZSBUWCBwYWNrZXRzIHdp
bGwgdHJpZ2dlciB0aGUgVFggY29tcGxldGlvbiBpbnRlcnJ1cHQsIGFuZCB0aGlzDQo+IHdpbGwN
Cj4gYWNjZWxlcmF0ZSB0aGUgcHJvY2Vzc2luZyBvZiB0aGUgVFggdGltZXN0YW1wcy4gSSdtIHVu
Y2xlYXIgd2hhdA0KPiBoYXBwZW5zDQo+IHdoZW4gdGhlIHNlbmRlciB0aHJlYWQgcnVucyBvbiBh
IGRpZmZlcmVudCBDUFUgY29yZSB0aGFuIHRoZSBUWA0KPiB0aW1lc3RhbXAgdGhyZWFkLg0KDQpX
ZWxsIEkgaGF2ZSBubyBjbHVlIHVuZm9ydHVuYXRlbHkgYnV0IHlvdXIgdGhlb3J5IG1ha2VzIHNl
bnNlLiBWaW5pY2l1cw0KbWlnaHQgaGVscCB1cyBvdXQgaGVyZS4NCg0KPiANCj4gWW91ciBuZWVk
IHRvIGluY3JlYXNlIHRoZSBTT19SQ1ZCVUYgaXMgYWxzbyBpbnRlcmVzdGluZy4gS2VlcCBpbiBt
aW5kDQo+IHRoYXQgaXNvY2hyb24gYXQgdGhhdCBzY2hlZHVsaW5nIHByaW9yaXR5IGFuZCBwb2xp
Y3kgaXMgYSBDUFUgaG9nLA0KPiBhbmQNCj4gdGhhdCBpZ2NfdHN5bmNfaW50ZXJydXB0KCkgY2Fs
bHMgc2NoZWR1bGVfd29yaygpIC0gd2hpY2ggdXNlcyB0aGUNCj4gc3lzdGVtDQo+IHdvcmtxdWV1
ZSB0aGF0IHJ1bnMgYXQgYSB2ZXJ5IGxvdyBwcmlvcml0eSAodGhpcyBiZWdzIHRoZSBxdWVzdGlv
biwNCj4gaG93DQo+IGRvIHlvdSBrbm93IGhvdyB0byBtYXRjaCB0aGUgQ1BVIG9uIHdoaWNoIGlz
b2Nocm9uIHJ1bnMgd2l0aCB0aGUgQ1BVDQo+IG9mDQo+IHRoZSBzeXN0ZW0gd29ya3F1ZXVlPyku
IFNvIGlzb2Nocm9uLCBoaWdoIHByaW9yaXR5LCBjb21wZXRlcyBmb3IgQ1BVDQo+IHRpbWUgd2l0
aCBpZ2NfcHRwX3R4X3dvcmsoKSwgbG93IHByaW9yaXR5LiBPbmUgcHJvZHVjZXMgZGF0YSwgb25l
DQo+IGNvbnN1bWVzIGl0OyBxdWV1ZXMgYXJlIGJvdW5kIHRvIGdldCBmdWxsIGF0IHNvbWUgcG9p
bnQuDQoNCk1heWJlIHRoaXMgaXMgd2hhdCBoZWxwcyBpbiBteSBjYXNlPyBXaXRoIGZ1bmNjb3Vu
dCB0cmFjZXIgSSBjaGVja2VkDQp0aGF0IHdoZW4gdGhlIHNlbmRlciB0aHJlYWQgYW5kIGlnY19w
dHBfdHhfd29yayBydW5uaW5nIG9uIHRoZSBzYW1lDQpjb3JlLCB0aGUgd29ya2VyIGNhbGxlZCBl
eGFjdGx5IGFzIG1hbnkgdGltZXMgYXMgbWFueSBwYWNrZXRzIEkgc2VudC4NCg0KSG93ZXZlciBp
ZiB0aGUgd29ya2VyIHJ1bm5pbmcgb24gZGlmZmVyZW50IGNvcmUsIGZ1bmNjb3VudCBzaG93IHNv
bWUNCnJhbmRvbSBudW1iZXIgKGxlc3MgdGhhbiB0aGUgcGFja2V0cyBzZW50KSBhbmQgaW4gdGhh
dCBjYXNlIEkgYWxzbyBsb3N0DQp0aW1lc3RhbXBzLg0KDQpJJ20gbm90IHN1cmUgd2hhdCBoYXBw
ZW5pbmcgaGVyZSwgbWF5YmUgdGhlICJkZWZlcnJlZCIgc2NoZWR1bGluZyBvZg0KdGhlIHdvcmtl
ciBzb21ldGltZXMgdG9vIHNsb3cgdG8gZW5xdWV1ZSBldmVyeSB0aW1lc3RhbXAgaW50byB0aGUg
ZXJyb3INCnF1ZXVlPyBBbmQgYmVjYXVzZSBJIGZvcmNlIGJvdGggdGhlIHNlbmRlciBhbmQgd29y
a2VyIHRvIHRoZSBzYW1lIGNvcmUsDQp0aGV5IGV4ZWN1dGVkIGluIG9yZGVyIChteSBzeXN0ZW0g
cHJldHR5IG11Y2ggaWRsZSBvdGhlciB0aGFuIHRoZXNlDQpwcm9jZXNzZXMpIGludHJvZHVjaW5n
IHNvbWUgc29ydCBvZiB0aHJvdHRobGluZyB0byB0aGUgdGltZXN0YW1wDQpwcm9jZXNzaW5nPw0K
DQo+IE9uIHRoZSBvdGhlciBoYW5kLCBvdGhlciBkcml2ZXJzIHVzZSB0aGUgcHRwX2F1eF9rd29y
a2VyKCkgdGhhdCB0aGUNCj4gUFRQDQo+IGNvcmUgY3JlYXRlcyBzcGVjaWZpY2FsbHkgZm9yIHRo
aXMgcHVycG9zZS4gSXQgaXMgYSBkZWRpY2F0ZWQga3RocmVhZA0KPiB3aG9zZSBzY2hlZHVsaW5n
IHBvbGljeSBhbmQgcHJpb3JpdHkgY2FuIGJlIGFkanVzdGVkIHVzaW5nIGNocnQuIEkNCj4gdGhp
bmsNCj4gaXQgd291bGQgYmUgaW50ZXJlc3RpbmcgdG8gc2VlIGhvdyB0aGluZ3MgYmVoYXZlIHdo
ZW4geW91IHJlcGxhY2UNCj4gc2NoZWR1bGVfd29yaygpIHdpdGggcHRwX3NjaGVkdWxlX3dvcmtl
cigpLg0KDQpJIHdpbGwgdHJ5IHRvIHRha2UgYSBsb29rIGludG8gdGhhdC4gQW55d2F5LCB0aGFu
ayB5b3UgZm9yIHRoZQ0KaW5zaWdodHMsIEknbSBoYXBweSB3aXRoIHRoZSB3YXkgaG93IGl0IHdv
cmtzIG5vdyAoYXQgbGVhc3QgSSBjYW4gZG8gbXkNCmV4cGVyaW1lbnRzIHdpdGggdGhhdCkuDQoN
CkJlc3QsDQpGZXJlbmMNCg0K
