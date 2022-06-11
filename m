Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5684C5476E3
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 19:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiFKReP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 13:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiFKReO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 13:34:14 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90089.outbound.protection.outlook.com [40.107.9.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F43B3F8B6;
        Sat, 11 Jun 2022 10:34:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhWJyXYnPaumtKpfsO3t8yFGyvBXbciSm6olnEBoaGLXnxO2+bddtF6Yn3lgS3OKsY8qEUfBJySMNLOpD8SBUC0jnXJUzQTh/b8+CkNoM9lERegG/nmpSv0whmRCoBKRSfuQ8nYkMvtJAbee0zdZsJJFSoRA8w/skEeTbaEeWVbAeByfitCgS8RgI93VsEyIAiCVW1A3ayIbQbYlIOPvMCD8acn0x1rLYaDVR5MtV1XxsUOFLh/AmwAmsq/wPSt9CJN0HDUm3YJPtbutO8f83/EAQdXQTJ8N/zmXF+CoKTP+op+Tl/tJUIwu+ve+mLISOWxlzEr3CuUsFt5TpLzKRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h3QdjV12gy/vMBaxMJ2P8R1xYT3+l9M4nCqG+AuA0W4=;
 b=DKcW/jHI2SuVNJz4zm2RZgkUC0MYaktF9Po7fAPGte9ruqSHgCCb+9QGc0MmPp94+oKuEPacoAsIg3o5VwSLeOa8mGhoGk2ubnLIBQnxU/Skh5HMWgNHYSAq40Val9cUdTreb6IaovYVYMSFtlLQZN97c3Ax7vFKKkjwrTWqkeJwr8/eE3hI2I4edWzsXJx+6mK5+2plS5UlmU7yDBo9/xd7MZFIMfww2GAR3LKKbGFfUVh7LtGvm2MyW9I3JLl0DZqazzHxZ5xzexAhM3tgqRGp6JJ99YAVXo7blXRx8mydaxhnBJhrExzqI/JG+nYqcv/U1c43h3ptg7dTNjNFHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h3QdjV12gy/vMBaxMJ2P8R1xYT3+l9M4nCqG+AuA0W4=;
 b=D4uHSG6z98BhjhatHUCPdpM5urLgsbDvGx7irOK2Ky+ioceIpg2i2YugFaz3dtV3mNDj2DE54QFPTcoit9UX1oP0n4wOALPM9cjvIYetg+6LWJ45Kn9dOZSCG9wAzvX6Ynu5tMdteomza5GtgXmB48z6aAiyXIu4jwCRGrLA87xc+RFTdfP75nBTEGlG6B/Wvwbvi3rOcs9YJyQcIbCzZbOq9bSQomfZ7MRs4h2PbLMc7mAFspcN4mbee2dI6fIUvl8JO5edhfLQK0jpGXSgfmSKNhLl8sz+xbblp6hAXwlwzza5bdysvk9oB8YJGqlXDyEt7GMANCvazepDyVeN7w==
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3d::7) by
 MR1P264MB3107.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3c::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.11; Sat, 11 Jun 2022 17:34:09 +0000
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::958f:a26:4984:ffd7]) by MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::958f:a26:4984:ffd7%7]) with mapi id 15.20.5332.016; Sat, 11 Jun 2022
 17:34:09 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Hari Bathini <hbathini@linux.ibm.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
CC:     Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jordan Niethe <jniethe5@gmail.com>,
        Russell Currey <ruscur@russell.cc>
Subject: Re: [PATCH v2 5/5] bpf ppc32: Add instructions for atomic_[cmp]xchg
Thread-Topic: [PATCH v2 5/5] bpf ppc32: Add instructions for atomic_[cmp]xchg
Thread-Index: AQHYfOKiP0Kmxh1HNUmQDTasHboavq1KeSSA
Date:   Sat, 11 Jun 2022 17:34:09 +0000
Message-ID: <f09b59ee-c965-a140-4d03-723830cba66d@csgroup.eu>
References: <20220610155552.25892-1-hbathini@linux.ibm.com>
 <20220610155552.25892-6-hbathini@linux.ibm.com>
In-Reply-To: <20220610155552.25892-6-hbathini@linux.ibm.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11f5fa5c-9391-472a-0c7e-08da4bd0977e
x-ms-traffictypediagnostic: MR1P264MB3107:EE_
x-microsoft-antispam-prvs: <MR1P264MB3107A439F1DC51959D907C06EDA99@MR1P264MB3107.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 12LBXLhLAWUux6qv9IBKYP+g/ni07qRH3JjrloaPOzSvL1C2Piwyy2uDZck+uar8g3gfkkgs4IbV/NKKfsTGiepB7aKcWnonTlWWWpC+BqG0w9NEF9gDRonUSavOX2gQu0DuFyseuvy+79UWiyEsGkUDVIanAnAb/6OWqI6Q16KeUl0eRq0cAxHeqVKwOxrxVPUTv4q6SOkfO27AEyuutI9KjXzklVybrc6Ms5YrAvPRQn9vHuUwZgOCzVwnUvPqW0yPvOU4nQuGhAUXRw17sUv4XWANZhHCLSGlhjDinhJMiuwjiyt1JxU2tf/EWDdsflwBgapBTikDSIJDPNYhTdqiN9zuJXl5ZlOUMWA0noC6EN84Xm2cBXHn9wFwCLUTuMKa0c3tsa5+qiq+UBxbgIhg3qq0o2BT13y2mmSfeA63uycMQTbRu9cCcIcU51wn6MzOXlfcRF1TtfLMOLyRa4FkL8EIsutVlyxsv07rjYOw92Qd3aE1Z5wW4mfZvIbITUSxjFiy0OeFs2tdbapuc8SZFl8eg+ot8xxIcAISdbEDD5lR/m7QVDDE+Q9QBzFh9b/v0s+X8JWTShtAGGZZi979WpYTPirLwTIkGimodcHozddPQnqknAD9gDVTMQICpc5m6Eyqa6sVyGu8sVOFJrd4ZpZxtXY6XzXjwxSPgBrSQ8Gf7Y+Y/r5Tk8fEwu5aHiUFZP+PPcaiUC8+lgnzMWsmnxitw2fKU3VxUwB3rlbiyxf1Ug8ixuK98f+S26j/LPPDKjQtR7nAvF2sP8/Oxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(8676002)(7416002)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(4326008)(6486002)(6512007)(508600001)(5660300002)(8936002)(91956017)(44832011)(71200400001)(26005)(38070700005)(2906002)(36756003)(316002)(31686004)(38100700002)(186003)(54906003)(122000001)(110136005)(83380400001)(86362001)(6506007)(31696002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eE83N0FCbnl1OHNYcExFZVV5cmZ6d2JhZkFTbm10OStzMS83SFdLcDk3em5a?=
 =?utf-8?B?QURuWWhFT24wNXRhVW8zMC9rbEU0cjlBeFZZTVVKWmExS2txcjV2NkR0ejNB?=
 =?utf-8?B?MUd0bURGZjhIWStRMXdjWnB6djRWeU5jYThwLzdFTHJ6ZXVGY20wb0J4aTZo?=
 =?utf-8?B?STNxNFg1L1Z1VFIxT3FOVG5PSHBaaWo3QnZvSUlxSXhRS0VEVm5QYTdJd20w?=
 =?utf-8?B?OURXQXFObTA1UUtibjZ2T3ZOWFpRdWhpamtaVmErQjlTNXJHSDRvS1FtY3M2?=
 =?utf-8?B?K2ZUcFNYaEZ6MjkxREhSYmRvVDlGTENtbGtJVjJVRkpoN0RJTEFxeDVKdjRt?=
 =?utf-8?B?ZHF5dWRHdnFuRXNKTmRiRUZxZDZFeVlPZE1RY3JYUEFqSDA5c21ZdllEZEhq?=
 =?utf-8?B?WTY0LzIzTkNrVUVoNk5sSGZlbnpqUkExbE9XVXVvOGM0Q0swcElTcENFWEdl?=
 =?utf-8?B?TnBnT3V5UWNGelZSNTBVM1FBejNxRkZTRmlSeXJud3B3Y1I4SW93VkdLVWdq?=
 =?utf-8?B?Yi9vNDBSM3Q3bTVRLzJqZktZeFl5UkpTdFV3Q3lhL3kyN0tkU1RHR3lOMGFC?=
 =?utf-8?B?b0JHV3dVWjBJNnVTSjlOenU0c1hvcEVJdDcxTnp6ZmYreEg4ejNNM3QzalNW?=
 =?utf-8?B?ajNaQnVmSHVzckVnVjZtaitKZ2RjWU9Xb0NiMVhEZFFUU1MvWDlSQUhnMDBS?=
 =?utf-8?B?WVYveG1CMndid092emkyVWxTemhvdkFNZHM1OFRlTm9nVjRqdENUSXVFc01E?=
 =?utf-8?B?Qmd2cVh2anZneXBpeFR4bUlHVHkyMUoxKzhoYncvcHZONmNIMyt3SktiZzN1?=
 =?utf-8?B?bzIxQWhZLzhQb2lMbjNydWJNUTNLZVpqaFVRN0E5ZGIxbHcxbTZ1RkZpSlRP?=
 =?utf-8?B?c2xQK1VkdDBSOGcwM0dnMmxkaTlRRTlpakI1RG10L01LcHlmNjByOWR0QjZX?=
 =?utf-8?B?ekkrMWxJQVV1ZmI2dkdmV3pMM3dLQ2ZMTWZTemFRVCtvT1dwUDQxY0FzbTFt?=
 =?utf-8?B?bnFyMkh0TElob2FCUjF3V1ozNi9jdGFLTmVPZXlUbGEzL3V0QjZKWU1TYlFN?=
 =?utf-8?B?byt4cWxxejkwTjVydjdGNzBRbmZzWmt5bjZ5S2N2bFppYVp1b1FNSm1RZWV6?=
 =?utf-8?B?NVUzZm1rSUU3Qk5ZcG5adnlubDdMYkJBL1pKM1h2aWVRWEQvZTBVUWl0S0wx?=
 =?utf-8?B?bEY1YnhLb1VRbmk3OFdYZk9FSmZqU0hJZllaUU5LZXhxSDZ3UlRLcGhxd2dQ?=
 =?utf-8?B?RG1YOVBXeHQxUmtYRnlMRjlDNWpXVGlVQ2thNFFLbWVSSDVIWmFMZUd3Q1V2?=
 =?utf-8?B?TFI3YWViKzlZRXV0ZEtKQ3gxRnBrR0xhM2RKc0pwdkJ4NU5XWFBKMkluOHNa?=
 =?utf-8?B?NnNjVWk3QkJ5VzZ2bW1ZT09pamwyYUxaaW9oVW9wV01ZUEtDeEVtQVlZeVg2?=
 =?utf-8?B?cGZvb2crY1dhUW5yb3A2ZjdmZTFjRXYxTzlNWWNPMVBuYUp4akdmY1pQRG90?=
 =?utf-8?B?YWx3dlREbVBxc3JXaERQK1h1eDNabHhTc2ZoM3c1UnEwVFVxbVhOb2JTZVlI?=
 =?utf-8?B?UXV3RDE4UnFxZHRIcjdQL1RlbjRLMTZxeXRPdi92dkNDKzluemVKZytXK0xM?=
 =?utf-8?B?TUVYVmZVbnhWQVRia3owWGZXT0VNYVNEOS9ESGFub0FCbkFTS3hObjRiVFpZ?=
 =?utf-8?B?ajNObWhmTjhlUkg3RWl4eFBFMG1OTFh1Wk9LUkp5R0xycFpndEFLNkdacjNJ?=
 =?utf-8?B?c0ozUDVsUWFzUG1TTkJMUWthTU5EUmkwd29sdDRwTlBPQXo3RTJVTXVJZjhD?=
 =?utf-8?B?UHNXNlRCM3VJYkZHY2lXbmZ6L0pybGZ6WE5XNTExa0NXZ09TUDlDSURHZ2Yr?=
 =?utf-8?B?UEpUSndzbzIwbDUvSUhCUURjMURqVndJTEh0TUtiZ2tySHFwaUlNNW1HZnNk?=
 =?utf-8?B?SEEyTzFEa1NNU2tzS3g1TFgwNk5GSjJkdEZrMlJnQkc4N0JlQVFpVXBrTC9M?=
 =?utf-8?B?RXluRjlFZ3BNQkppbG5sU2Vtenk1aEJCTUdPd1Z1dFpScHo4cm5FME8yR3lM?=
 =?utf-8?B?SEd4QjVZNlhaOFlreDZQS2J4RzNKcU9HUFdFQ1NkaU45OVN1SDZqQzFWejRF?=
 =?utf-8?B?K0krZ29pRnJFb1QyNVo0WjV2VFd0WWFBcmc1OTg1M2EvNjYwM1hFR1gxQTkx?=
 =?utf-8?B?anVqWVZHaWFZWWpqbFY0STRVVGlCMVdkTHdxdlNDb1lwM1FDUEJTT1d2cW0v?=
 =?utf-8?B?eDhIM1hXVVZpY2YwdHFicHNvSTJuRGFJU2lZTFRPK3I5SlJON0tUMkRPVWpq?=
 =?utf-8?B?eGFkLzYvdHFCclBaMTltelNMaTdITHdLTXlkUExMUVBqYThvKy82Vkl5Rm9S?=
 =?utf-8?Q?cGNeZq3nfIvZlKkAtVG2rmltopBZOrDVsVpXd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E52B2CA47083E04A96200B53D803DF9E@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f5fa5c-9391-472a-0c7e-08da4bd0977e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2022 17:34:09.2622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tvQ0iZ6Q52ItIoB+qx53+c4IjQz4E1Cj0dyBr1IbaTmBWr46zVuuHTaHPrncIv5SI0Efcx2WF2UOGBTcpgrulVN189+X3KyEyc7PgZLOjZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3107
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDEwLzA2LzIwMjIgw6AgMTc6NTUsIEhhcmkgQmF0aGluaSBhIMOpY3JpdMKgOg0KPiBU
aGlzIGFkZHMgdHdvIGF0b21pYyBvcGNvZGVzIEJQRl9YQ0hHIGFuZCBCUEZfQ01QWENIRyBvbiBw
cGMzMiwgYm90aA0KPiBvZiB3aGljaCBpbmNsdWRlIHRoZSBCUEZfRkVUQ0ggZmxhZy4gIFRoZSBr
ZXJuZWwncyBhdG9taWNfY21weGNoZw0KPiBvcGVyYXRpb24gZnVuZGFtZW50YWxseSBoYXMgMyBv
cGVyYW5kcywgYnV0IHdlIG9ubHkgaGF2ZSB0d28gcmVnaXN0ZXINCj4gZmllbGRzLiBUaGVyZWZv
cmUgdGhlIG9wZXJhbmQgd2UgY29tcGFyZSBhZ2FpbnN0ICh0aGUga2VybmVsJ3MgQVBJDQo+IGNh
bGxzIGl0ICdvbGQnKSBpcyBoYXJkLWNvZGVkIHRvIGJlIEJQRl9SRUdfUjAuIEFsc28sIGtlcm5l
bCdzDQo+IGF0b21pY19jbXB4Y2hnIHJldHVybnMgdGhlIHByZXZpb3VzIHZhbHVlIGF0IGRzdF9y
ZWcgKyBvZmYuIEpJVCB0aGUNCj4gc2FtZSBmb3IgQlBGIHRvbyB3aXRoIHJldHVybiB2YWx1ZSBw
dXQgaW4gQlBGX1JFR18wLg0KPiANCj4gICAgQlBGX1JFR19SMCA9IGF0b21pY19jbXB4Y2hnKGRz
dF9yZWcgKyBvZmYsIEJQRl9SRUdfUjAsIHNyY19yZWcpOw0KPiANCj4gU2lnbmVkLW9mZi1ieTog
SGFyaSBCYXRoaW5pIDxoYmF0aGluaUBsaW51eC5pYm0uY29tPg0KPiAtLS0NCj4gDQo+IENoYW5n
ZXMgaW4gdjI6DQo+ICogTW92ZWQgdmFyaWFibGUgZGVjbGFyYXRpb24gdG8gYXZvaWQgbGF0ZSBk
ZWNsYXJhdGlvbiBlcnJvciBvbg0KPiAgICBzb21lIGNvbXBpbGVycy4NCj4gKiBUcmllZCB0byBt
YWtlIGNvZGUgcmVhZGFibGUgYW5kIGNvbXBhY3QuDQo+IA0KPiANCj4gICBhcmNoL3Bvd2VycGMv
bmV0L2JwZl9qaXRfY29tcDMyLmMgfCAyNSArKysrKysrKysrKysrKysrKysrKysrLS0tDQo+ICAg
MSBmaWxlIGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL25ldC9icGZfaml0X2NvbXAzMi5jIGIvYXJjaC9wb3dl
cnBjL25ldC9icGZfaml0X2NvbXAzMi5jDQo+IGluZGV4IDI4ZGM2YTFhOGYyZi4uNDNmMWM3NmQ0
OGNlIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3Bvd2VycGMvbmV0L2JwZl9qaXRfY29tcDMyLmMNCj4g
KysrIGIvYXJjaC9wb3dlcnBjL25ldC9icGZfaml0X2NvbXAzMi5jDQo+IEBAIC0yOTcsNiArMjk3
LDcgQEAgaW50IGJwZl9qaXRfYnVpbGRfYm9keShzdHJ1Y3QgYnBmX3Byb2cgKmZwLCB1MzIgKmlt
YWdlLCBzdHJ1Y3QgY29kZWdlbl9jb250ZXh0ICoNCj4gICAJCXUzMiBheF9yZWcgPSBicGZfdG9f
cHBjKEJQRl9SRUdfQVgpOw0KPiAgIAkJdTMyIHRtcF9yZWcgPSBicGZfdG9fcHBjKFRNUF9SRUcp
Ow0KPiAgIAkJdTMyIHNpemUgPSBCUEZfU0laRShjb2RlKTsNCj4gKwkJdTMyIHNhdmVfcmVnLCBy
ZXRfcmVnOw0KPiAgIAkJczE2IG9mZiA9IGluc25baV0ub2ZmOw0KPiAgIAkJczMyIGltbSA9IGlu
c25baV0uaW1tOw0KPiAgIAkJYm9vbCBmdW5jX2FkZHJfZml4ZWQ7DQo+IEBAIC03OTksNiArODAw
LDkgQEAgaW50IGJwZl9qaXRfYnVpbGRfYm9keShzdHJ1Y3QgYnBmX3Byb2cgKmZwLCB1MzIgKmlt
YWdlLCBzdHJ1Y3QgY29kZWdlbl9jb250ZXh0ICoNCj4gICAJCSAqIEJQRl9TVFggQVRPTUlDIChh
dG9taWMgb3BzKQ0KPiAgIAkJICovDQo+ICAgCQljYXNlIEJQRl9TVFggfCBCUEZfQVRPTUlDIHwg
QlBGX1c6DQo+ICsJCQlzYXZlX3JlZyA9IF9SMDsNCj4gKwkJCXJldF9yZWcgPSBzcmNfcmVnOw0K
PiArDQo+ICAgCQkJYnBmX3NldF9zZWVuX3JlZ2lzdGVyKGN0eCwgdG1wX3JlZyk7DQo+ICAgCQkJ
YnBmX3NldF9zZWVuX3JlZ2lzdGVyKGN0eCwgYXhfcmVnKTsNCj4gICANCj4gQEAgLTgyOSw2ICs4
MzMsMjEgQEAgaW50IGJwZl9qaXRfYnVpbGRfYm9keShzdHJ1Y3QgYnBmX3Byb2cgKmZwLCB1MzIg
KmltYWdlLCBzdHJ1Y3QgY29kZWdlbl9jb250ZXh0ICoNCj4gICAJCQljYXNlIEJQRl9YT1IgfCBC
UEZfRkVUQ0g6DQo+ICAgCQkJCUVNSVQoUFBDX1JBV19YT1IoX1IwLCBfUjAsIHNyY19yZWcpKTsN
Cj4gICAJCQkJYnJlYWs7DQo+ICsJCQljYXNlIEJQRl9DTVBYQ0hHOg0KPiArCQkJCS8qDQo+ICsJ
CQkJICogUmV0dXJuIG9sZCB2YWx1ZSBpbiBCUEZfUkVHXzAgZm9yIEJQRl9DTVBYQ0hHICYNCj4g
KwkJCQkgKiBpbiBzcmNfcmVnIGZvciBvdGhlciBjYXNlcy4NCj4gKwkJCQkgKi8NCj4gKwkJCQly
ZXRfcmVnID0gYnBmX3RvX3BwYyhCUEZfUkVHXzApOw0KPiArDQo+ICsJCQkJLyogQ29tcGFyZSB3
aXRoIG9sZCB2YWx1ZSBpbiBCUEZfUkVHXzAgKi8NCj4gKwkJCQlFTUlUKFBQQ19SQVdfQ01QVyhi
cGZfdG9fcHBjKEJQRl9SRUdfMCksIF9SMCkpOw0KPiArCQkJCS8qIERvbid0IHNldCBpZiBkaWZm
ZXJlbnQgZnJvbSBvbGQgdmFsdWUgKi8NCj4gKwkJCQlQUENfQkNDX1NIT1JUKENPTkRfTkUsIChj
dHgtPmlkeCArIDMpICogNCk7DQo+ICsJCQkJZmFsbHRocm91Z2g7DQo+ICsJCQljYXNlIEJQRl9Y
Q0hHOg0KPiArCQkJCXNhdmVfcmVnID0gc3JjX3JlZzsNCg0KSSdtIGEgYml0IGxvc3QsIHdoZW4g
c2F2ZV9yZWcgaXMgc3JjX3JlZywgZG9uJ3Qgd2UgZXhwZWN0IHRoZSB1cHBlciBwYXJ0IA0KKGll
IHNyY19yZWcgLSAxKSB0byBiZSBleHBsaWNpdGVseSB6ZXJvaXNlZCA/DQoNCj4gKwkJCQlicmVh
azsNCj4gICAJCQlkZWZhdWx0Og0KPiAgIAkJCQlwcl9lcnJfcmF0ZWxpbWl0ZWQoImVCUEYgZmls
dGVyIGF0b21pYyBvcCBjb2RlICUwMnggKEAlZCkgdW5zdXBwb3J0ZWRcbiIsDQo+ICAgCQkJCQkJ
ICAgY29kZSwgaSk7DQo+IEBAIC04MzYsMTUgKzg1NSwxNSBAQCBpbnQgYnBmX2ppdF9idWlsZF9i
b2R5KHN0cnVjdCBicGZfcHJvZyAqZnAsIHUzMiAqaW1hZ2UsIHN0cnVjdCBjb2RlZ2VuX2NvbnRl
eHQgKg0KPiAgIAkJCX0NCj4gICANCj4gICAJCQkvKiBzdG9yZSBuZXcgdmFsdWUgKi8NCj4gLQkJ
CUVNSVQoUFBDX1JBV19TVFdDWChfUjAsIHRtcF9yZWcsIGRzdF9yZWcpKTsNCj4gKwkJCUVNSVQo
UFBDX1JBV19TVFdDWChzYXZlX3JlZywgdG1wX3JlZywgZHN0X3JlZykpOw0KPiAgIAkJCS8qIHdl
J3JlIGRvbmUgaWYgdGhpcyBzdWNjZWVkZWQgKi8NCj4gICAJCQlQUENfQkNDX1NIT1JUKENPTkRf
TkUsIHRtcF9pZHgpOw0KPiAgIA0KPiAgIAkJCS8qIEZvciB0aGUgQlBGX0ZFVENIIHZhcmlhbnQs
IGdldCBvbGQgZGF0YSBpbnRvIHNyY19yZWcgKi8NCj4gICAJCQlpZiAoaW1tICYgQlBGX0ZFVENI
KSB7DQo+IC0JCQkJRU1JVChQUENfUkFXX01SKHNyY19yZWcsIGF4X3JlZykpOw0KPiArCQkJCUVN
SVQoUFBDX1JBV19NUihyZXRfcmVnLCBheF9yZWcpKTsNCj4gICAJCQkJaWYgKCFmcC0+YXV4LT52
ZXJpZmllcl96ZXh0KQ0KPiAtCQkJCQlFTUlUKFBQQ19SQVdfTEkoc3JjX3JlZ19oLCAwKSk7DQo+
ICsJCQkJCUVNSVQoUFBDX1JBV19MSShyZXRfcmVnIC0gMSwgMCkpOyAvKiBoaWdoZXIgMzItYml0
ICovDQo+ICAgCQkJfQ0KPiAgIAkJCWJyZWFrOw0KPiAgIA==
