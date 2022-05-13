Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57847525C00
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 09:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377603AbiEMG6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 02:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377653AbiEMG6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 02:58:38 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90059.outbound.protection.outlook.com [40.107.9.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90CB2A7C06;
        Thu, 12 May 2022 23:58:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXSlOK1LuBthGJ8Uiw9mFN0TEdv7KvHJrYmxiftiA7ucU+saauu1W2vjkRILcYmG28po8rkHph4y88/GWqdozd8CA/qWWu2m3oOll2MN6bUdksi7ur5y7/ye4XWMQDr2/68p+q7eWRw7ZQKicPO3Me3Pn8RwgW+Zdy3mqyq5dmF1KG30ZiRqYLjLbCL1ZWFfsWEyHl2/U1C1ShYId7SewyF9Yg9kQyllLlGVryS2Yp0YuAKujiYEjsQ51qJua6hagtrMFZ+EoptyEdcCbPnpxYiyrDoT9z45HwFObgiCc3b1hRzr/bexJ6J5dPTChUTQlM7vQ6JLvj7SUnlIk6WRKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rz72kLOrl7Z/s8Zv0a4PsJfrc/xm5MEbhqZ8lDyX6X0=;
 b=JS3dHH8oSIeFbjdwslE9BYFuJwbK8dpmK77D9XYKGKIAAxjMeHCocrXG4OQsXVK1/pcfVnZjXUtAbxgweZ456XHrPK736k29/LNKkphGBRj0emH0qA+AJ4sTzQr8ErVPFzEeZXy28Iem60MohUgaLkhTDZbhn6MaifQUcTqxt7NZWPWJSt2+8V70jUkVGQhvTQbLXp7FvL/VuDo6MP/Az1mCgO5uOkQXXoyWuDwwvGABsi1c8/4LyGdSnZJozSCbxcTcs0rfN3IXDfcHx3zEEDUcwweo9mY9+0CZ2Q+7wkTJxYBPfmxe4MFUKBH43DCydmkY9Kt68TuRei7eD17Tyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB2111.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1b2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Fri, 13 May
 2022 06:58:28 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ad4e:c157:e9ac:385d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ad4e:c157:e9ac:385d%6]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 06:58:28 +0000
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
        Jordan Niethe <jniethe5@gmail.com>
Subject: Re: [PATCH 4/5] bpf ppc32: add support for BPF_ATOMIC bitwise
 operations
Thread-Topic: [PATCH 4/5] bpf ppc32: add support for BPF_ATOMIC bitwise
 operations
Thread-Index: AQHYZdRrIu81WxSiFkilXOKuzUjZdK0cYgiA
Date:   Fri, 13 May 2022 06:58:28 +0000
Message-ID: <54d45d24-2514-4b4a-8483-4f662c371322@csgroup.eu>
References: <20220512074546.231616-1-hbathini@linux.ibm.com>
 <20220512074546.231616-5-hbathini@linux.ibm.com>
In-Reply-To: <20220512074546.231616-5-hbathini@linux.ibm.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cb65add-8ecc-4831-2112-08da34adfbe9
x-ms-traffictypediagnostic: PR1P264MB2111:EE_
x-microsoft-antispam-prvs: <PR1P264MB2111E2AF3286505371A0B694EDCA9@PR1P264MB2111.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sPuVIbhD1dw4ZM2PNfkCUnQBvaSvt010wEL15q9VmQsnQcywSWxdIVt8a4qsb1iIsDzna5fb6jltz95rWVHlcntwptTTxlG9rIXVJ6Pt162s27QCs/JLjkc+sGCYSYzPpugVWcDDf4W6G9KQNEVjmqUvFzfMx2sAmALK+TfWLrfvZCfHSHcP/8m+88mNLaIT6cb1Sja9mr1FGhFNTvI4MCFWCLoiFj1jcMh3LQDvKeNiTQxu2J0suF7J1oQjNngZl4MwL3cLW64UgDwbg1ttaIrRGGczmo2suBEDARPY9VUceyWlEToix5BzWgICm99xEPbJWX80lXMqcAL5oE2nES0uUWd56zaDYDsLoKIysG8cJG0bxplw/RK85qVGl3VKTlog1tVDbPUuDOKnXPUdJhP33N9tqFHjBvD3MPHu1S+HCcB5hckNt+oSr5Pdg02ozYeioqUtk69pKJXoIf72Ks4OWpY6E/b3e525/sCMDvJoh766jgKIYOQRREqbXUU0Zbdg5QKrakACys1gB29G05HRfvvkUThbeBkLb35lpTnx7tQvdLFWnNMRTqPE7pD8jF5oOkBRgg89y04s4tB+bOreGzuq7OLjCxRThzxD6y23wSAzXrluTtYlOdUrukjgv4mbSnnfbLYKwMP/w/IJVWRQGRrvp0CnnVWLu/leOdv/RqblatahFcoIaaKTCZeNyyv8ENrW0IQE13+2b6w2gx5WIEDYvxqjxq2V0RJ2cN8gMOXzEHFmjROGmLE9/oNhGiaTsm9vVLbf85bx8XgJHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(110136005)(7416002)(54906003)(8936002)(83380400001)(71200400001)(186003)(31686004)(6506007)(6512007)(36756003)(26005)(2616005)(66574015)(316002)(38070700005)(38100700002)(122000001)(86362001)(6486002)(31696002)(2906002)(508600001)(44832011)(66476007)(66556008)(66446008)(64756008)(8676002)(76116006)(91956017)(66946007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWMxUldsQ3k0c0JCOVJVblRRcHRza2NpaTVKN04vSU53bDFuYTlTR0pEZWlv?=
 =?utf-8?B?V05ydHBqUXVMcE1RbXRlM1FVcDhzTzU5bmtxSklaWFdyN2oyMndjOFZNRnBW?=
 =?utf-8?B?Ukw1T3UvSy9KQythR2lKTWlGZEJ6cmZFd1lFZHJaLzhZM3pVczBXWThpcUlB?=
 =?utf-8?B?SGpTOFBJNHhzbzdXTkR1d3ZHYmFuVkFPOFdpRlR0cnFXK3NLa0VocC9UZDVX?=
 =?utf-8?B?cUxSUlRrS3ZORUxUaE9rL1RQdkdUU1VYN29JUFFsNXplMkFLSWw5cjNWcExl?=
 =?utf-8?B?aVprRWNNNVZvNjRZbjEvMHljSlh4eTZ5NlFTRGFqSmZwSWQrellRb0pzeU1P?=
 =?utf-8?B?MGp0b2hDNk1PbVNPVHNhNFhHT29IVWdMRXZNYnNyQVJLcSthdXoyR2FMT1Yw?=
 =?utf-8?B?TUlEdmlsdUxnWkVCZmhmai9wU1NqcE5oMG9mOFFCa09MUjY1am1WUGhEdlY1?=
 =?utf-8?B?d2pnbm55RWJBQ1E0YzlzZWlYQ2VNeFVueU1wNzl1cTN5TGpPek15TmtuTTdR?=
 =?utf-8?B?S3Bza3VkQTFLQzdSRTEzTzRLK2NaRThRVHpHWElBM3RtUEgxODNPOWQzbUJT?=
 =?utf-8?B?UllZSHBlYzhQaTJHL1UvdEtQL0JYK0d2MFFQT0RHbndiajEvVFJSNWZQb1Bi?=
 =?utf-8?B?LzI5SlllcnR3MU5TQVBJY2hCd0I4UmUwQnkvNmpFSW5MUmxqVTZGYmIwUmFC?=
 =?utf-8?B?aGxOV0NHM1psOENBaDM5eU9XLy85OHU5YzJWejY3NDFCeURmb3FxKzAxdDZC?=
 =?utf-8?B?UkhnVzBEdEtOUmtJL1RrWVhPWkJjNGhoMFZjQWs3T3YxRkVvSTg0SWhlZXYz?=
 =?utf-8?B?NXIvQUZ4UnNNMXVwTWVIMnFqR1JNYzJzYXVpNXF2WEM0TEI2cE5IWDk2OFhZ?=
 =?utf-8?B?WjgrZXdNeDNEZkY3MlU0UTJhYXpJN05BeEZtSHl0dG9DbGZ5b2NQVEhLdVh1?=
 =?utf-8?B?WVVLV1pReGNSYjRuYzE4dkwxd2NUNHl5cGtDNkxaYXVaYW8yKzJZV1J0ci8y?=
 =?utf-8?B?K3V3UGpvRnBQMFRKSGRRcHYvbHM4cGNhYWd2ZElkRncxK1o3QVBZaDVKaUp4?=
 =?utf-8?B?bEhiMUR4c3lSeHFWekt1TDU1Vmh4dUtGb053Z0NZR1QvY1ZUelFOTE82Sm42?=
 =?utf-8?B?M3J3REk4bWpLdytnWDlBSUNLSVZnNExGLzMzTG5LMmNoN01icEQ5WnJ4aklO?=
 =?utf-8?B?Y2ZZckpTbGxzVUw2cG5ZUUtRUmFMRVp2Y0JLQlQwY1NtdlJhYXBMV3pwTFlL?=
 =?utf-8?B?MS9SWk9OOEVoNTFiUjdhRjR2U1ZpNklTQmJ2WmxDMVVqT3B6SVdJRzBnTFpo?=
 =?utf-8?B?aU9pQ2MrYnRaTmg5SWVqQjRTNkErcUFKdm9lUENWb1RRbkhZRUpNeGROWWlF?=
 =?utf-8?B?YzZCaDR1TU40bkJkNzRrbmZ6SjQwVEdPRmlDU0hpUzhRWFA4aVRqQXoxN2JQ?=
 =?utf-8?B?RHhUOHBqTndtU0tMTlY5aEFvUE54THJZN0w5eW5UZUQ4ZmtjRmczaDlITm4w?=
 =?utf-8?B?dHRLYjN5UUk0V2ZnVFJDUzlTd01GZ3Q3WTErUGNzbGhoZjZ3ajNheTN3SU15?=
 =?utf-8?B?N2pRaWhjYzU1TVh2UlAwb25TcDIvTUIzelIzQ0hYZjUxMjJZMTlteWxaT3lu?=
 =?utf-8?B?blpQOFYzWG5BOEdSNVk4UkIzUTdCSFFYR2d6MUpubGlPaURoZWRYNE5mZG1V?=
 =?utf-8?B?cWlKN0JBWjAwZ1VXZVllQXl4TS8wV1BweFZpSmRqcUVzdjhqVkRSN0NrR0FF?=
 =?utf-8?B?a29CRUZpczNRSjRvb2RIN3NPMFJ5T0I3dSswUFFFcjBFaEFlQkZBSVh2YzRT?=
 =?utf-8?B?UUNWRmlOWHJ3elZCaEFNZVNNZE1wbnFPSXpLdHBBYTdhdEFhVzA1aEdZQVFH?=
 =?utf-8?B?ejQ3TjNTbE9iNUZSbXQ2UTVxWmgrblR1MmdOemp4Rmk0aXJ2RHVNaFVQKy9I?=
 =?utf-8?B?VkZlTFVvUENtbUh1L3JjbkY0MU5XcWpJdlJMcU1aN2Z5cFVUL0hvZ2NFSFQ3?=
 =?utf-8?B?NXY4VkFnaXBjdFhCdWhUSldGYU83SzdSTmxUTkZVRGttVm9lUm1TS3lKb2N6?=
 =?utf-8?B?a1dzYWJTbDNDeUJiSEdrV1FxK3FkZTcrQzNQSEhnb3R5RStHTnU0SXZ3OGRE?=
 =?utf-8?B?T3M0TW1nYytIQnU0QUtDU0NiUUVKV0s5Tk1rVHNHTm4yY0xBSFcrWHpBTzZI?=
 =?utf-8?B?NE9SSjRLbkpsTkMzQTAyU0VkeW9ya2Z3YnJpaHVBSGJUazZCT1lsWXFiSW1M?=
 =?utf-8?B?TXBSSnRTZDNiM0xsL0hsaFN0MDVtQlFGOFdLK2IvL3VlVHlWVkpWQTMvNzRL?=
 =?utf-8?B?YU1ERFlvNlpMN2RnTC82ZmV4YjFDWWVDZ1RGdU9VZyt4ZmJQaUk5RkFkdUt3?=
 =?utf-8?Q?0p0ZkvrEELfcOIq1l0UrckoQE2dC7dJnVaT7j?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E07A36F398EE245845AFC57D7D9B241@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb65add-8ecc-4831-2112-08da34adfbe9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 06:58:28.6536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NB5Ux5/vTOHaLjDg2OLjkynsYjwQOChJjtnBGVP3+K7Ya0Vkub+CdSAQ2U3EDffEwI2YfzbSA9TdIV2BFnEYzi8CqqNqivtYdlzsb06OEX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB2111
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDEyLzA1LzIwMjIgw6AgMDk6NDUsIEhhcmkgQmF0aGluaSBhIMOpY3JpdMKgOg0KPiBB
ZGRpbmcgaW5zdHJ1Y3Rpb25zIGZvciBwcGMzMiBmb3INCj4gDQo+IGF0b21pY19hbmQNCj4gYXRv
bWljX29yDQo+IGF0b21pY194b3INCj4gYXRvbWljX2ZldGNoX2FkZA0KPiBhdG9taWNfZmV0Y2hf
YW5kDQo+IGF0b21pY19mZXRjaF9vcg0KPiBhdG9taWNfZmV0Y2hfeG9yDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBIYXJpIEJhdGhpbmkgPGhiYXRoaW5pQGxpbnV4LmlibS5jb20+DQo+IC0tLQ0KPiAg
IGFyY2gvcG93ZXJwYy9uZXQvYnBmX2ppdF9jb21wMzIuYyB8IDQ1ICsrKysrKysrKysrKysrKysr
KysrKy0tLS0tLS0tLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMzEgaW5zZXJ0aW9ucygrKSwgMTQg
ZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL25ldC9icGZfaml0
X2NvbXAzMi5jIGIvYXJjaC9wb3dlcnBjL25ldC9icGZfaml0X2NvbXAzMi5jDQo+IGluZGV4IGU0
NmVkMWU4YzZjYS4uNTYwNGFlMWI2MGFiIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3Bvd2VycGMvbmV0
L2JwZl9qaXRfY29tcDMyLmMNCj4gKysrIGIvYXJjaC9wb3dlcnBjL25ldC9icGZfaml0X2NvbXAz
Mi5jDQo+IEBAIC03OTgsMjUgKzc5OCw0MiBAQCBpbnQgYnBmX2ppdF9idWlsZF9ib2R5KHN0cnVj
dCBicGZfcHJvZyAqZnAsIHUzMiAqaW1hZ2UsIHN0cnVjdCBjb2RlZ2VuX2NvbnRleHQgKg0KPiAg
IAkJICogQlBGX1NUWCBBVE9NSUMgKGF0b21pYyBvcHMpDQo+ICAgCQkgKi8NCj4gICAJCWNhc2Ug
QlBGX1NUWCB8IEJQRl9BVE9NSUMgfCBCUEZfVzoNCj4gLQkJCWlmIChpbW0gIT0gQlBGX0FERCkg
ew0KPiAtCQkJCXByX2Vycl9yYXRlbGltaXRlZCgiZUJQRiBmaWx0ZXIgYXRvbWljIG9wIGNvZGUg
JTAyeCAoQCVkKSB1bnN1cHBvcnRlZFxuIiwNCj4gLQkJCQkJCSAgIGNvZGUsIGkpOw0KPiAtCQkJ
CXJldHVybiAtRU5PVFNVUFA7DQo+IC0JCQl9DQo+IC0NCj4gLQkJCS8qICoodTMyICopKGRzdCAr
IG9mZikgKz0gc3JjICovDQo+IC0NCj4gICAJCQlicGZfc2V0X3NlZW5fcmVnaXN0ZXIoY3R4LCB0
bXBfcmVnKTsNCj4gICAJCQkvKiBHZXQgb2Zmc2V0IGludG8gVE1QX1JFRyAqLw0KPiAgIAkJCUVN
SVQoUFBDX1JBV19MSSh0bXBfcmVnLCBvZmYpKTsNCj4gKwkJCXRtcF9pZHggPSBjdHgtPmlkeCAq
IDQ7DQo+ICAgCQkJLyogbG9hZCB2YWx1ZSBmcm9tIG1lbW9yeSBpbnRvIHIwICovDQo+ICAgCQkJ
RU1JVChQUENfUkFXX0xXQVJYKF9SMCwgdG1wX3JlZywgZHN0X3JlZywgMCkpOw0KPiAtCQkJLyog
YWRkIHZhbHVlIGZyb20gc3JjX3JlZyBpbnRvIHRoaXMgKi8NCj4gLQkJCUVNSVQoUFBDX1JBV19B
REQoX1IwLCBfUjAsIHNyY19yZWcpKTsNCj4gLQkJCS8qIHN0b3JlIHJlc3VsdCBiYWNrICovDQo+
IC0JCQlFTUlUKFBQQ19SQVdfU1RXQ1goX1IwLCB0bXBfcmVnLCBkc3RfcmVnKSk7DQo+IC0JCQkv
KiB3ZSdyZSBkb25lIGlmIHRoaXMgc3VjY2VlZGVkICovDQo+IC0JCQlQUENfQkNDX1NIT1JUKENP
TkRfTkUsIChjdHgtPmlkeCAtIDMpICogNCk7DQo+ICsJCQlzd2l0Y2ggKGltbSkgew0KPiArCQkJ
Y2FzZSBCUEZfQUREOg0KPiArCQkJY2FzZSBCUEZfQUREIHwgQlBGX0ZFVENIOg0KPiArCQkJCUVN
SVQoUFBDX1JBV19BREQoX1IwLCBfUjAsIHNyY19yZWcpKTsNCj4gKwkJCQlnb3RvIGF0b21pY19v
cHM7DQo+ICsJCQljYXNlIEJQRl9BTkQ6DQo+ICsJCQljYXNlIEJQRl9BTkQgfCBCUEZfRkVUQ0g6
DQo+ICsJCQkJRU1JVChQUENfUkFXX0FORChfUjAsIF9SMCwgc3JjX3JlZykpOw0KPiArCQkJCWdv
dG8gYXRvbWljX29wczsNCj4gKwkJCWNhc2UgQlBGX09SOg0KPiArCQkJY2FzZSBCUEZfT1IgfCBC
UEZfRkVUQ0g6DQo+ICsJCQkJRU1JVChQUENfUkFXX09SKF9SMCwgX1IwLCBzcmNfcmVnKSk7DQo+
ICsJCQkJZ290byBhdG9taWNfb3BzOw0KPiArCQkJY2FzZSBCUEZfWE9SOg0KPiArCQkJY2FzZSBC
UEZfWE9SIHwgQlBGX0ZFVENIOg0KPiArCQkJCUVNSVQoUFBDX1JBV19YT1IoX1IwLCBfUjAsIHNy
Y19yZWcpKTsNCj4gK2F0b21pY19vcHM6DQoNClRoaXMgbG9va3MgbGlrZSBhbiBvZGQgY29uc3Ry
dWN0Lg0KDQpUaGUgZGVmYXVsdCBjYXNlIGRvZXNuJ3QgZmFsbCB0aHJvdWdoLCBzbyB0aGUgYmVs
b3cgcGFydCBjb3VsZCBnbyBhZnRlciANCnRoZSBzd2l0Y2ggYW5kIGFsbCBjYXNlcyBjb3VsZCBq
dXN0IGJyZWFrIGluc3RlYWQgb2YgZ290byBhdG9taWNfb3BzLg0KDQo+ICsJCQkJLyogRm9yIHRo
ZSBCUEZfRkVUQ0ggdmFyaWFudCwgZ2V0IG9sZCBkYXRhIGludG8gc3JjX3JlZyAqLw0KPiArCQkJ
CWlmIChpbW0gJiBCUEZfRkVUQ0gpDQo+ICsJCQkJCUVNSVQoUFBDX1JBV19MV0FSWChzcmNfcmVn
LCB0bXBfcmVnLCBkc3RfcmVnLCAwKSk7DQoNCkkgdGhpbmsgdGhpcyBpcyB3cm9uZy4gQnkgZG9p
bmcgYSBuZXcgTFdBUlggeW91IGtpbGwgdGhlIHJlc2VydmF0aW9uIA0KZG9uZSBieSB0aGUgcHJl
dmlvdXMgb25lLiBJZiB0aGUgZGF0YSBoYXMgY2hhbmdlZCBiZXR3ZWVuIHRoZSBmaXJzdCANCkxX
QVJYIGFuZCBub3csIGl0IHdpbGwgZ28gdW5kZXRlY3RlZC4NCg0KSXQgc2hvdWxkIGJlIGEgTFda
WCBJIGJlbGlldmUuDQoNCkJ1dCB0aGVyZSBpcyBhbm90aGVyIHByb2JsZW06IHlvdSBjbG9iYmVy
IHNyY19yZWcsIHRoZW4gd2hhdCBoYXBwZW5zIGlmIA0KU1RXQ1ggZmFpbHMgYW5kIGl0IGxvb3Bz
IGJhY2sgdG8gdG1wX2lkeCA/DQoNCj4gKwkJCQkvKiBzdG9yZSByZXN1bHQgYmFjayAqLw0KPiAr
CQkJCUVNSVQoUFBDX1JBV19TVFdDWChfUjAsIHRtcF9yZWcsIGRzdF9yZWcpKTsNCj4gKwkJCQkv
KiB3ZSdyZSBkb25lIGlmIHRoaXMgc3VjY2VlZGVkICovDQo+ICsJCQkJUFBDX0JDQ19TSE9SVChD
T05EX05FLCB0bXBfaWR4KTsNCj4gKwkJCQlicmVhazsNCj4gKwkJCWRlZmF1bHQ6DQo+ICsJCQkJ
cHJfZXJyX3JhdGVsaW1pdGVkKCJlQlBGIGZpbHRlciBhdG9taWMgb3AgY29kZSAlMDJ4IChAJWQp
IHVuc3VwcG9ydGVkXG4iLA0KPiArCQkJCQkJICAgY29kZSwgaSk7DQo+ICsJCQkJcmV0dXJuIC1F
T1BOT1RTVVBQOw0KPiArCQkJfQ0KPiAgIAkJCWJyZWFrOw0KPiAgIA0KPiAgIAkJY2FzZSBCUEZf
U1RYIHwgQlBGX0FUT01JQyB8IEJQRl9EVzogLyogKih1NjQgKikoZHN0ICsgb2ZmKSArPSBzcmMg
Ki8=
