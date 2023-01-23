Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CEB6782FE
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 18:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbjAWRYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 12:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbjAWRYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 12:24:39 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BFF2D56
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 09:24:37 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 30NFxFDq003215
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 09:24:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=miBbXQ56ylfeIbUtN36J3/S5ZnFqIkuQ25IsI5emS28=;
 b=EYMZCXGr06Ts3jCRNywf0B3bBgq7FT2sT1KZ3yyc9JgMP6AFHLSzUlAZ0pYP+qP9rWbA
 k0L6KIRG+K7wN9d2Sex5pbxjcVwG+NtAh/dvx0hOvbz47b2qXRidQjFcUWOL8JaDkV5h
 uDTEW17N20gXcVPiQwCPKxnIdyEx7Qgp+cYM1NaQEOY9u7HdHUVPGBDPcSmMWrJalOke
 yVodB7ow6RGZEq9ZqeQRuiwj8n4xgEIxXEh90wRNKCNdPcgfjz1LqXrdQwv66rZci13g
 mycPip5qgWu+Lt7+I7iMDtMi3nXp4DP2nyuu9Hot5/sJDm1YkHoI67/sEJTsZFjVzMdy jg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by m0001303.ppops.net (PPS) with ESMTPS id 3n8cm1k7t5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 09:24:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBr6ST+C8ZTjiToQBKlmvmX1grR/Myg0ZpUY1zNFEUVakeoQ6y6Vo6ZJ6NUdiRFK2mI12DFLsTn6tuweDJLtnCo3uMRDKOWXGZ+a7eNyImdYNj2Q/aR6Lp5425jG6fRhsKQXfU0C8yam6XVaXG1blnaBZhmBerydoCb0NlLJFxaS6GTkC1CWCTRlxIWzBWwvT2sf6FW+IQMaSnGy52GGI4r74LLGPpN+mQidZLqFxph7yidPQ4NT+NZk/p60QX/9Ki3n7EnIXvuoAnYBy8vySi6vgOKQDzQAkBL87SXjtxBntsLiuWRgtGZJOaOh0wo9cFNXe2xed4ifspftNkKZXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miBbXQ56ylfeIbUtN36J3/S5ZnFqIkuQ25IsI5emS28=;
 b=FkCcRaVMNcF3EAaZMDBIlaqIpcycfdSO5IoeHwGOu+AGj1DnwtCcaQT+wTnBf5p3BZ3yfHJDp7qSzLr7b4fYG5bqrr4Ht0Le11AfvMGLl3j1DGkms6J3bTFhvbxf5BvlpsnqmNpJMgERN1DJWmJdFmBCR/uXfajsWjRUJ76dH7uwQJOolARUMx5y1jBxP/x+Juy+8uaJ9c+5U956cVaY2bUdDtufIPSi6vnfCoGjGNpVuWCqzDkK8moYO5hEm0OPO3RbsV+cEL6BuRlnSqn+K3nKHMGJ59KMOPtBvb5Auy691P/vcINS1OiEaL2+kCFq7EY3RA7iC6Nx66SZ1f0xUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BLAPR15MB3874.namprd15.prod.outlook.com (2603:10b6:208:272::10)
 by IA0PR15MB5792.namprd15.prod.outlook.com (2603:10b6:208:400::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 17:24:34 +0000
Received: from BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::207b:48b8:3fbf:1fa]) by BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::207b:48b8:3fbf:1fa%8]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 17:24:33 +0000
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Gal Pressman <gal@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 1/2] mlx5: fix possible ptp queue fifo overflow
Thread-Topic: [PATCH net 1/2] mlx5: fix possible ptp queue fifo overflow
Thread-Index: AQHZLnza/MOTtBC6Vkmawt4udI7hba6sQiIA
Date:   Mon, 23 Jan 2023 17:24:33 +0000
Message-ID: <c73fe66a-2d9a-d675-79bc-09d7f63caa53@meta.com>
References: <20230122161602.1958577-1-vadfed@meta.com>
 <20230122161602.1958577-2-vadfed@meta.com>
In-Reply-To: <20230122161602.1958577-2-vadfed@meta.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR15MB3874:EE_|IA0PR15MB5792:EE_
x-ms-office365-filtering-correlation-id: 4f3dc5ba-9b5d-4f84-6745-08dafd66b1b7
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Oj0IU9ioUJKP0BivjXQjERPD6Lrui3O9tKbt2eHjrb72djZLQFF9pIibv8zDh+lypuElOcWPKJRCvK16ZDQG4kljPp3sSOBvWAhr/zrjva5WX2GKdvZgN6pR94d+UaxPmIEIzmO0CGoKSYPj7upg7hvK4EnR7UlUu6ol30ZFtqjDopJvxQpu6itPxnOr1KTFgaeQX01rFFxv61s9U1uAm8SYOMd0ZC8RIxEp+THGpf+Q/JLkkbyb/o0B1kaHCub0z/gr77tsOgGGLQXZfZA8t93sIkcbHy3FbeH3Eqop9CqEvqX6IOb6qsNVChoCcmFiNXOTkJeIkbSHg9TTbOg3t5oGMvsXDmVmcOZ0e+LvpzNAUg+x7m0mHzjPbvresa5vqiml+EtMqteVTIenEbTO69VIiuzWQCIFdRW5Oa7G2pP/MxEOCet7P+yDecwej+kLDIWexlkkVJsCxknYK48bPc5qYcjsLVyTnADCs0fNfE+JH4ylZofB2cWY76ktruP5khQ1C+UUor9cEiQvGIApfc5D4onWtGb1cdqyJ+rhlZa9ldlaWYTzUwk+WYFS+ImXgqP3EMSGvCvJbOgMVeWKPW0TBurwQEZRTR0EtqFhVFe5vU/omjrJ7d42O+Z3Ez3DEYLrPa8I7c665d/vFVhYoeiNhoSM1SAw5q93P+eU7+72fDdFAk0mskH0e+/9IKAWLuEEcv/77fr40fh5sKb3L4nSrZlGAesWS5eLrn6vUfE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB3874.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(451199015)(83380400001)(54906003)(66446008)(66946007)(91956017)(76116006)(64756008)(66556008)(66476007)(86362001)(8676002)(4326008)(6916009)(316002)(36756003)(53546011)(6506007)(186003)(6512007)(71200400001)(6486002)(478600001)(2616005)(31686004)(38070700005)(8936002)(122000001)(5660300002)(31696002)(2906002)(38100700002)(41300700001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzFVQ1ZjdEowN255clBubjJ3eWJKVU5pYkVobXBNSTNHR1o2SXFWbzhOSFNT?=
 =?utf-8?B?SVlSSzkzcituaTJmZWpCMFMrZXVYYkkrZGZsQ1lZMVcvM2JtRThpeGR6Vk9k?=
 =?utf-8?B?N1VSOWovTjdCOGdFT3VDamNqUEFaeGpKTGtXekJ1cWhLSkxGbUM5aTNrMmxr?=
 =?utf-8?B?RHJQM1BXMXpqMTZ0c3RwaW9yWnIzYzhaaXdwTkttenhuNDR5S1VGcnBBZHI5?=
 =?utf-8?B?TlY5VDM2MnhENEtsNmxoK3F6SS9xZDVMd25EOXFJNkFUM2ZWQmlkcjd5UnZl?=
 =?utf-8?B?eFZNV1A5c2Q1MXVNWGVXSVYwb1QwV3FxSFFnWnFXUk14UjBJckdMRkxrQVB4?=
 =?utf-8?B?WjJ5UmZ2Y0I1UVlBeHJWakx4OTNvSFVzR0dURkViL0NRNlp1cE9XbFFYWDBU?=
 =?utf-8?B?R3VVVXZhc2ZBVGFMZEJhTU05R3Q3SEtpTkszaGkwQTBtVXUyU1ZyVzJ3S3NT?=
 =?utf-8?B?NnB0UVRmZEw2MEdmNmNpR05FU3hiUXlMRllEb2NTLzQ5QXZJNFVVdlhoZ1Fi?=
 =?utf-8?B?YnNiQ3BCV01BbzA0SlQzaVFIWWsrM3ptYjQ1SW5JYlNxVDVTYitkTERlenZl?=
 =?utf-8?B?VVVHd1NHWUNzV0pEK093eXZzUUYwdG5CNGd3d0x5dlZ4UGtmTTBCaGdOVDhX?=
 =?utf-8?B?c3hjdGc4RlZLN0Z2Vm0xOXdCVVNDcWljSmFIcHZCdkVERTRGbi80NXhkVDk4?=
 =?utf-8?B?dzdhM1k1RTFvOGhoekpzOWdlWTg4VzQvUEF3UXk1SlY4dlY2U0dVdFJUZGJZ?=
 =?utf-8?B?TWZlVjVTMFlodUYxYlgzc0FjSFJ6aEYydDdBS2VnWHhLNkQrM0huai9RdEpP?=
 =?utf-8?B?R1RlbkxMSGVxbkdBbzFiUi9xYkhHdUdOcVBLcjY3WGxxNEpCWnJsdVlDYkdM?=
 =?utf-8?B?YTVFQ1R6QTN5MHNtV0NQYmtnSitkU0ZZT2lyOGtza2JsVk1NZGtZWnMwdk56?=
 =?utf-8?B?dGZkeWpMVWRuWXFRNzhoSGVUZW9iNHRZdzlXeWVmTGd5NnhjUU5wTy9ESVhJ?=
 =?utf-8?B?Wml0NGJoYU5IOG1CNHJscUNyWW9OZXBjN3RSMFBRb0tUUlhHTzdZSkpJYm5R?=
 =?utf-8?B?WUhxK1QzazMwRjhqRWNjUU1BR1ppclhUME1KcCtxZjJQT2p2N2Q5L0UvVXgy?=
 =?utf-8?B?Wkc4NDZFZnBNNEo5YTdsTVBTS2RyZklFK3BLam1iWWUyZ3ZDdUU4MkxuUHpz?=
 =?utf-8?B?a1d6Q3BPcUgzQUZXaHpLb0Q0dmxOMEJqWEZQR2xnVkZIbFpSMmQwZWZ4UFYx?=
 =?utf-8?B?SXlBYVdKdWxjY0RLUXFVd1JoaTcrc0VFcnc2ZEdiSlI1TVUrOUJLODc1dTBa?=
 =?utf-8?B?UHp1d2FRb210V3g0am9ScHgrN1hyL0dPdUhNVzY1OHJuU1RCUVZzcmc3WHYz?=
 =?utf-8?B?ZXA2bTFDUTAwNmE3TjhJZnlyV3NyUWpDVk1xcEdHT0REZm5nRzN1MWxWdnFa?=
 =?utf-8?B?eHJsejE0WDUzSEFzdVlnNkVBZkRucDQ2Uys0bjhUQmVMeXJtbEVTbDhZQndm?=
 =?utf-8?B?dFhmSnQ3S2xicHJjK0hzY0hnd05tVU1vNFprcXd4NTVnMHMvbWh6emM0dDh3?=
 =?utf-8?B?dXg3aG9sbnZYa1B4MU9sOVRMK0c0cFJmVlN4K1VmdXZQWXJvUzZlWlY2OXYx?=
 =?utf-8?B?SnBQVzZlbURTK0V3VFR5RUlzQ2NLeDVPb0xyU0xsMjJlS0hRNjlRNG1ZNGJG?=
 =?utf-8?B?bjJZNXFQMXRZM1Y3SnZhaXlaQm5HdE5IcGYvRkwyL2pOQ3dzRldWUkJoaVpk?=
 =?utf-8?B?bVhMdGs3Y2hJbXU4ZUZ3SWc4V3hMZWVIT0pKeDlJcWRHbjdBdXkzMWZPcVJR?=
 =?utf-8?B?bThMQUI1RXI1ZFhjRlU4RjIvanBQWWlnR2JOclBVQ2JqZ3R4WlNEeHZidHky?=
 =?utf-8?B?VlMyemRPa2VxYkRvdCtPc0RQZyt5eDlwYjBKdnBmOWhGM0RoaFlQQytIdkhH?=
 =?utf-8?B?aFBqQ1dwZlpVVEdpZ0xhUTRSMTI5eCthNSs4Tlp3K2JrYmxPd2padFhndzQr?=
 =?utf-8?B?NUdYOWk1U2o3K3VWYVBSbGptRVJRa0hRbnZESlRlajVTb0JHblppQ04xVVJr?=
 =?utf-8?B?LzhiNUIxb0hoWHhDUWc3TW90dklLZjZTTU0wUFN2aGxEbkZMbnlzRGx0UFVN?=
 =?utf-8?B?aFpQbUM5TXYwNTFzbDN3VkhXMXJXSlc3ZnBYSWFlN2FlNjBCRkJ5Mmo4L2Vr?=
 =?utf-8?B?eGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FADC2AC08DC9A549A869408A284E05D6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR15MB3874.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f3dc5ba-9b5d-4f84-6745-08dafd66b1b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 17:24:33.6112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4PSDuVIo6S1Te/LjJPbfZjlhC3PeNY82DgRJgzqZ4kLHGn1Ep9Yy9YAFwtXxEK86
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR15MB5792
X-Proofpoint-GUID: ioxsEmCTYygSfixawTRSunfct05hgMvn
X-Proofpoint-ORIG-GUID: ioxsEmCTYygSfixawTRSunfct05hgMvn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ID4gSGkgVmFkaW0sDQogPg0KDQpIaSBHYWwhDQpZb3VyIG1haWwgZGlkbid0IHNob3cgdXAgaW4g
bXkgbWFpbGJveCBmb3Igc29tZSByZWFzb25zLCBzbyBJIHRyaWVkIHRvIA0KY29uc3RydWN0IGl0
IGJhY2sgZnJvbSBtYWlsaW5nIGxpc3QuIFRoaXMgbWF5IGVuZCB1cCB3aXRoIHNvbWUgc2lkZSAN
CmVmZmVjdHMsIGJ1dCBJIGRpZCBteSBiZXN0IHRvIGF2b2lkIGl0Lg0KDQogPiBPbiAyMi8wMS8y
MDIzIDE4OjE2LCBWYWRpbSBGZWRvcmVua28gd3JvdGU6DQogPj4gRmlmbyBwb2ludGVycyBhcmUg
bm90IGNoZWNrZWQgZm9yIG92ZXJmbG93IGFuZCB0aGlzIGNvdWxkIHBvdGVudGlhbGx5DQogPj4g
bGVhZCB0byBvdmVyZmxvdyBhbmQgZG91YmxlIGZyZWUgdW5kZXIgaGVhdnkgUFRQIHRyYWZmaWMu
DQogPj4NCiA+PiBBbHNvIHRoZXJlIHdlcmUgYWNjaWRlbnRhbCBPT08gY3FlIHdoaWNoIGxlYWQg
dG8gYWJzb2x1dGVseSBicm9rZW4gZmlmby4NCiA+PiBBZGQgY2hlY2tzIHRvIHdvcmthcm91bmQg
T09PIGNxZSBhbmQgYWRkIGNvdW50ZXJzIHRvIHNob3cgdGhlIGFtb3VudCBvZg0KID4+IHN1Y2gg
ZXZlbnRzLg0KID4+DQogPj4gRml4ZXM6IDE5YjQzYTQzMmUzZSAoIm5ldC9tbHg1ZTogRXh0ZW5k
IFNLQiByb29tIGNoZWNrIHRvIGluY2x1ZGUgDQpQVFAtU1EiKQ0KID4NCiA+IElzbid0IDU4YTUx
ODk0OGY2MCAoIm5ldC9tbHg1ZTogQWRkIHJlc2lsaWVuY3kgZm9yIFBUUCBUWCBwb3J0DQogPiB0
aW1lc3RhbXAiKSBtb3JlIGFwcHJvcHJpYXRlPw0KDQpJdCBsb29rcyBsaWtlIHRoZSBidWdzIHdl
cmUgYWN0dWFsbHkgaW50cm9kdWNlZCBieSB0aGUgY29tbWl0IGluIEZpeGVzIA0KZXZlbiB0aG91
Z2ggdGhlIGNvbW1pdCB5b3UgbWVudGlvbmVkIGludHJvZHVjZWQgdGhlIGZlYXR1cmUgaXRzZWxm
LiBCdXQgDQpJIG1pZ2h0IGJlIHdyb25nLCBJJ2xsIHJlY2hlY2sgaXQuDQoNCiA+PiBTaWduZWQt
b2ZmLWJ5OiBWYWRpbSBGZWRvcmVua28gPHZhZGZlZEBtZXRhLmNvbT4NCiA+PiAtLS0NCiA+PiAg
Li4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcHRwLmMgIHwgMjggKysrKysr
KysrKysrKystLS0tLQ0KID4+ICAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bi90eHJ4LmggfCAgNiArKystDQogPj4gIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZW5fc3RhdHMuYyAgICB8ICAyICsrDQogPj4gIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW5fc3RhdHMuaCAgICB8ICAyICsrDQogPj4gIDQgZmlsZXMgY2hhbmdlZCwgMzAgaW5zZXJ0
aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCiA+Pg0KID4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcHRwLmMgDQpiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi9wdHAuYw0KID4+IGluZGV4IDkwM2RlODhiYWI1
My4uMTFhOTllMGYwMGM2IDEwMDY0NA0KID4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbi9wdHAuYw0KID4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbi9wdHAuYw0KID4+IEBAIC04NiwyMCArODYsMzEgQEAgc3Rh
dGljIGJvb2wgbWx4NWVfcHRwX3RzX2NxZV9kcm9wKHN0cnVjdCANCm1seDVlX3B0cHNxICpwdHBz
cSwgdTE2IHNrYl9jYywgdTE2IHNrYg0KID4+ICAJcmV0dXJuIChwdHBzcS0+dHNfY3FlX2N0cl9t
YXNrICYmIChza2JfY2MgIT0gc2tiX2lkKSk7DQogPj4gIH0NCiA+Pg0KID4+IC1zdGF0aWMgdm9p
ZCBtbHg1ZV9wdHBfc2tiX2ZpZm9fdHNfY3FlX3Jlc3luYyhzdHJ1Y3QgbWx4NWVfcHRwc3EgDQoq
cHRwc3EsIHUxNiBza2JfY2MsIHUxNiBza2JfaWQpDQogPj4gK3N0YXRpYyBib29sIG1seDVlX3B0
cF9za2JfZmlmb190c19jcWVfcmVzeW5jKHN0cnVjdCBtbHg1ZV9wdHBzcSANCipwdHBzcSwgdTE2
IHNrYl9jYywgdTE2IHNrYl9pZCkNCiA+PiAgew0KID4+ICAJc3RydWN0IHNrYl9zaGFyZWRfaHd0
c3RhbXBzIGh3dHMgPSB7fTsNCiA+PiAgCXN0cnVjdCBza19idWZmICpza2I7DQogPj4NCiA+PiAg
CXB0cHNxLT5jcV9zdGF0cy0+cmVzeW5jX2V2ZW50Kys7DQogPj4NCiA+PiAtCXdoaWxlIChza2Jf
Y2MgIT0gc2tiX2lkKSB7DQogPj4gLQkJc2tiID0gbWx4NWVfc2tiX2ZpZm9fcG9wKCZwdHBzcS0+
c2tiX2ZpZm8pOw0KID4+ICsJaWYgKHNrYl9jYyA+IHNrYl9pZCB8fCBQVFBfV1FFX0NUUjJJRFgo
cHRwc3EtPnNrYl9maWZvX3BjKSA8IHNrYl9pZCkgew0KID4+ICsJCXB0cHNxLT5jcV9zdGF0cy0+
b29vX2NxZSsrOw0KID4+ICsJCXJldHVybiBmYWxzZTsNCiA+PiArCX0NCiA+DQogPkkgaG9uZXN0
bHkgZG9uJ3QgdW5kZXJzdGFuZCBob3cgdGhpcyBjb3VsZCBoYXBwZW4sIGNhbiB5b3UgcGxlYXNl
DQogPnByb3ZpZGUgbW9yZSBpbmZvcm1hdGlvbiBhYm91dCB5b3VyIGlzc3VlPyBEaWQgeW91IGFj
dHVhbGx5IHdpdG5lc3Mgb29vDQogPmNvbXBsZXRpb25zIG9yIGlzIGl0IGEgdGhlb3JldGljYWwg
aXNzdWU/DQogPldlIGtub3cgcHRwIENRRXMgY2FuIGJlIGRyb3BwZWQgaW4gc29tZSByYXJlIGNh
c2VzICh0aGF0J3MgdGhlIHJlYXNvbiB3ZQ0KID5pbXBsZW1lbnRlZCB0aGlzIHJlc3luYyBmbG93
KSwgYnV0IGNvbXBsZXRpb25zIHNob3VsZCBhbHdheXMgYXJyaXZlDQogPmluLW9yZGVyLg0KDQpJ
IHdhcyBhbHNvIHN1cnByaXNlZCB0byBzZWUgT09PIGNvbXBsZXRpb25zIGJ1dCBpdCdzIHRoZSBy
ZWFsaXR5LiBXaXRoIGEgDQpsaXR0bGUgYml0IG9mIGRlYnVnIEkgZm91bmQgdGhpcyBpc3N1ZToN
Cg0KWzY1NTc4LjIzMTcxMF0gRklGTyBkcm9wIGZvdW5kLCBza2JfY2MgPSAxNDEsIHNrYl9pZCA9
IDE0MA0KWzY1NTc4LjI5MzM1OF0gRklGTyBkcm9wIGZvdW5kLCBza2JfY2MgPSAxNDEsIHNrYl9p
ZCA9IDE0Mw0KWzY1NTc4LjMwMTI0MF0gRklGTyBkcm9wIGZvdW5kLCBza2JfY2MgPSAxNDUsIHNr
Yl9pZCA9IDE0Mg0KWzY1NTc4LjM2NTI3N10gRklGTyBkcm9wIGZvdW5kLCBza2JfY2MgPSAxNzMs
IHNrYl9pZCA9IDE0MQ0KWzY1NTc4LjQyNjY4MV0gRklGTyBkcm9wIGZvdW5kLCBza2JfY2MgPSAx
NzMsIHNrYl9pZCA9IDE0NQ0KWzY1NTc4LjQ4ODA4OV0gRklGTyBkcm9wIGZvdW5kLCBza2JfY2Mg
PSAxNzMsIHNrYl9pZCA9IDE0Ng0KWzY1NTc4LjU0OTQ4OV0gRklGTyBkcm9wIGZvdW5kLCBza2Jf
Y2MgPSAxNzMsIHNrYl9pZCA9IDE0Nw0KWzY1NTc4LjYxMDg5N10gRklGTyBkcm9wIGZvdW5kLCBz
a2JfY2MgPSAxNzMsIHNrYl9pZCA9IDE0OA0KWzY1NTc4LjY3MjMwMV0gRklGTyBkcm9wIGZvdW5k
LCBza2JfY2MgPSAxNzMsIHNrYl9pZCA9IDE0OQ0KDQpJdCByZWFsbHkgc2hvd3MgdGhhdCBDUUUg
YXJlIGNvbWluZyBPT08gc29tZXRpbWVzLg0KDQogPj4gKw0KID4+ICsJd2hpbGUgKHNrYl9jYyAh
PSBza2JfaWQgJiYgKHNrYiA9IA0KbWx4NWVfc2tiX2ZpZm9fcG9wKCZwdHBzcS0+c2tiX2ZpZm8p
KSkgew0KID4+ICAJCWh3dHMuaHd0c3RhbXAgPSBtbHg1ZV9za2JfY2JfZ2V0X2h3dHMoc2tiKS0+
Y3FlX2h3dHN0YW1wOw0KID4+ICAJCXNrYl90c3RhbXBfdHgoc2tiLCAmaHd0cyk7DQogPj4gIAkJ
cHRwc3EtPmNxX3N0YXRzLT5yZXN5bmNfY3FlKys7DQogPj4gIAkJc2tiX2NjID0gUFRQX1dRRV9D
VFIySURYKHB0cHNxLT5za2JfZmlmb19jYyk7DQogPj4gIAl9DQogPj4gKw0KID4+ICsJaWYgKCFz
a2IpIHsNCiA+PiArCQlwdHBzcS0+Y3Ffc3RhdHMtPmZpZm9fZW1wdHkrKzsNCiA+DQogPkhtbSwg
Zm9yIHRoaXMgdG8gaGFwcGVuIHlvdSBuZWVkIF9hbGxfIHB0cCBDUUVzIHRvIGRyb3AgYW5kIHdy
YXBhcm91bmQNCiA+dGhlIFNRPw0KDQpZZXAsIGFuZCB0aGF0J3Mgd2hhdCBJJ3ZlIHNlZW4gYmVm
b3JlIEkgZml4ZWQgbWx4NWVfcHRwX3RzX2NxZV9kcm9wKCkgDQpjaGVjay4gSSBhZGRlZCB0aGlz
IGNvdW50ZXIganVzdCB0byBiZSBzdXJlIEkgd29uJ3QgaGFwcGVuIGFnYWluLg0KDQogPj4gKwkJ
cmV0dXJuIGZhbHNlOw0KID4+ICsJfQ0KID4+ICsNCiA+PiArCXJldHVybiB0cnVlOw0KID4+ICB9
DQogPj4NCiA+PiAgc3RhdGljIHZvaWQgbWx4NWVfcHRwX2hhbmRsZV90c19jcWUoc3RydWN0IG1s
eDVlX3B0cHNxICpwdHBzcSwNCiA+PiBAQCAtMTA5LDcgKzEyMCw3IEBAIHN0YXRpYyB2b2lkIG1s
eDVlX3B0cF9oYW5kbGVfdHNfY3FlKHN0cnVjdCANCm1seDVlX3B0cHNxICpwdHBzcSwNCiA+PiAg
CXUxNiBza2JfaWQgPSBQVFBfV1FFX0NUUjJJRFgoYmUxNl90b19jcHUoY3FlLT53cWVfY291bnRl
cikpOw0KID4+ICAJdTE2IHNrYl9jYyA9IFBUUF9XUUVfQ1RSMklEWChwdHBzcS0+c2tiX2ZpZm9f
Y2MpOw0KID4+ICAJc3RydWN0IG1seDVlX3R4cXNxICpzcSA9ICZwdHBzcS0+dHhxc3E7DQogPj4g
LQlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOw0KID4+ICsJc3RydWN0IHNrX2J1ZmYgKnNrYiA9IE5VTEw7
DQogPj4gIAlrdGltZV90IGh3dHN0YW1wOw0KID4+DQogPj4gIAlpZiAodW5saWtlbHkoTUxYNUVf
UlhfRVJSX0NRRShjcWUpKSkgew0KID4+IEBAIC0xMTgsOCArMTI5LDEwIEBAIHN0YXRpYyB2b2lk
IG1seDVlX3B0cF9oYW5kbGVfdHNfY3FlKHN0cnVjdCANCm1seDVlX3B0cHNxICpwdHBzcSwNCiA+
PiAgCQlnb3RvIG91dDsNCiA+PiAgCX0NCiA+Pg0KID4+IC0JaWYgKG1seDVlX3B0cF90c19jcWVf
ZHJvcChwdHBzcSwgc2tiX2NjLCBza2JfaWQpKQ0KID4+IC0JCW1seDVlX3B0cF9za2JfZmlmb190
c19jcWVfcmVzeW5jKHB0cHNxLCBza2JfY2MsIHNrYl9pZCk7DQogPj4gKwlpZiAobWx4NWVfcHRw
X3RzX2NxZV9kcm9wKHB0cHNxLCBza2JfY2MsIHNrYl9pZCkgJiYNCiA+PiArCSAgICAhbWx4NWVf
cHRwX3NrYl9maWZvX3RzX2NxZV9yZXN5bmMocHRwc3EsIHNrYl9jYywgc2tiX2lkKSkgew0KID4+
ICsJCWdvdG8gb3V0Ow0KID4+ICsJfQ0KID4+DQogPj4gIAlza2IgPSBtbHg1ZV9za2JfZmlmb19w
b3AoJnB0cHNxLT5za2JfZmlmbyk7DQogPj4gIAlod3RzdGFtcCA9IG1seDVlX2NxZV90c190b19u
cyhzcS0+cHRwX2N5YzJ0aW1lLCBzcS0+Y2xvY2ssIA0KZ2V0X2NxZV90cyhjcWUpKTsNCiA+PiBA
QCAtMTI4LDcgKzE0MSw4IEBAIHN0YXRpYyB2b2lkIG1seDVlX3B0cF9oYW5kbGVfdHNfY3FlKHN0
cnVjdCANCm1seDVlX3B0cHNxICpwdHBzcSwNCiA+PiAgCXB0cHNxLT5jcV9zdGF0cy0+Y3FlKys7
DQogPj4NCiA+PiAgb3V0Og0KID4+IC0JbmFwaV9jb25zdW1lX3NrYihza2IsIGJ1ZGdldCk7DQog
Pj4gKwlpZiAoc2tiKQ0KID4+ICsJCW5hcGlfY29uc3VtZV9za2Ioc2tiLCBidWRnZXQpOw0KID4+
ICB9DQogPj4NCiA+PiAgc3RhdGljIGJvb2wgbWx4NWVfcHRwX3BvbGxfdHNfY3Eoc3RydWN0IG1s
eDVlX2NxICpjcSwgaW50IGJ1ZGdldCkNCiA+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3R4cnguaCANCmIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3R4cnguaA0KID4+IGluZGV4IGFlZWQxNjVhMmRlYy4u
MGJkMmRkNjk0ZjA0IDEwMDY0NA0KID4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbi90eHJ4LmgNCiA+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW4vdHhyeC5oDQogPj4gQEAgLTgxLDcgKzgxLDcgQEAgdm9pZCBt
bHg1ZV9mcmVlX3R4cXNxX2Rlc2NzKHN0cnVjdCBtbHg1ZV90eHFzcSAqc3EpOw0KID4+ICBzdGF0
aWMgaW5saW5lIGJvb2wNCiA+PiAgbWx4NWVfc2tiX2ZpZm9faGFzX3Jvb20oc3RydWN0IG1seDVl
X3NrYl9maWZvICpmaWZvKQ0KID4+ICB7DQogPj4gLQlyZXR1cm4gKCpmaWZvLT5wYyAtICpmaWZv
LT5jYykgPCBmaWZvLT5tYXNrOw0KID4+ICsJcmV0dXJuICh1MTYpKCpmaWZvLT5wYyAtICpmaWZv
LT5jYykgPCBmaWZvLT5tYXNrOw0KID4NCiA+V2hhdCBpcyB0aGlzIGNhc3QgZm9yPw0KDQpUbyBw
cm9wZXJseSBjaGVjayB1MTYgb3ZlcmZsb3cgY2FzZXMuICgqZmlmby0+cGMgLSAqZmlmby0+Y2Mp
IGlzIGNhc3RlZCANCnRvIGludCBpZiB3ZSBkb24ndCBwdXQgZXhwbGljaXQgY2FzdCBoZXJlLiBB
bmQgaXQgZWFzaWx5IGVuZHMgdXAgd2l0aCANCm5lZ2F0aXZlIHZhbHVlIHdoaWNoIHdlIGJlIGxl
c3MgdGhhbiBtYXNrIHVudGlsIGZpZm8tPmNjIG92ZXJmbG93cyB0b28uDQoNCiA+PiAgfQ0KID4+
DQogPj4gIHN0YXRpYyBpbmxpbmUgYm9vbA0KID4+IEBAIC0yOTEsMTIgKzI5MSwxNiBAQCB2b2lk
IG1seDVlX3NrYl9maWZvX3B1c2goc3RydWN0IG1seDVlX3NrYl9maWZvIA0KKmZpZm8sIHN0cnVj
dCBza19idWZmICpza2IpDQogPj4gIHsNCiA+PiAgCXN0cnVjdCBza19idWZmICoqc2tiX2l0ZW0g
PSBtbHg1ZV9za2JfZmlmb19nZXQoZmlmbywgKCpmaWZvLT5wYykrKyk7DQogPj4NCiA+PiArCVdB
Uk5fT05DRSgodTE2KSgqZmlmby0+cGMgLSAqZmlmby0+Y2MpID4gZmlmby0+bWFzaywgIiVzIA0K
b3ZlcmZsb3ciLCBfX2Z1bmNfXyk7DQogPg0KID5UaGUgZmlmbyBpcyB0aGUgc2FtZSBzaXplIG9m
IHRoZSBTUSwgaG93IGNhbiBpdCBvdmVyZmxvdz8NCiA+DQoNClRoZXJlIGlzIG9uZSBmaWZvX3B1
c2ggY2FsbCBpbiBtbHg1ZV90eHdxZV9jb21wbGV0ZSBiZWZvcmUgDQptbHg1ZV9za2JfZmlmb19o
YXNfcm9vbSgpIGlzIGNoZWNrZWQsIHNvIGl0IGNhbiBwb3RlbnRpYWxseSBvdmVyZmxvdy4NCg0K
ID4+ICAJKnNrYl9pdGVtID0gc2tiOw0KID4+ICB9DQo=
