Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A48F3EACE8
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 00:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbhHLWHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 18:07:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43430 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230089AbhHLWHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 18:07:39 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17CM77Ud018635;
        Thu, 12 Aug 2021 15:07:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=rVU6+ZDzJ61pXvvZ4TjzK3rPE4nJvgXdkKYqHmWZLpI=;
 b=qwVJdYJDv1pUvs5f46zJIpycKGGEF9muvt+tWhKm3nPO2p3mDL5XlfMDlHQeQdQvTTZP
 zhRVWTVjw45tsbQ1TxfCdUK4cBfyLRk/OO7BiLknIgBDz8rMo+nkM5bvU3PkRG19Dggc
 /1P5mH0BABWivayM+52klm/A8djDO4dBBYM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3acy4pdc9f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 12 Aug 2021 15:07:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 12 Aug 2021 15:06:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVPqO9HRXJpF9Jor17LBej9eWxDBGcOdbC7HaP+t3j4hyrJcywse2Zc3LQMemqCEZaUizPeCkPAL1ACAi+vqLh5cwsRHTVmACFc9V0XBa9MMvAH1Oqb1EiLFIGwewlTmLOjv5ifgihYLjsYxb/+2wJN6uh2h+CsLLmqDzuB+KNdKY/Jv5wWc9B8tDRr24vhn1/xBMiuP5qAazGMePEN0yT4aPY+/soUeSz1IXBvwCwjHsbTubKSU7AZMkn2+YOrX7d6gBW0VOy5XwXzoVQgAH99bArZMog+oS0kGFAbHkWSXHFlzuf1BTYoThzFMpO/L8UFe4E60Lf1CIBK7wyt3wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rVU6+ZDzJ61pXvvZ4TjzK3rPE4nJvgXdkKYqHmWZLpI=;
 b=cnYM6d7EfZ1/iYrexZOmClEevTHZec/B1CQ3YbisNH7mXQDtTEGRH8Z7ZwWOwSc2O43775x1iMFuAeHRzra0kHs9o5bruxjfy5EUrDt9YvEbgKpnow1EYJCl05FJbCqO7o86OmJMiHYi5U65uDenF0JYct4ubx0hpv5GsTq5awXp3lU7pMAfkI0GIooWIf23U9AG8+Z5dti2zzdvSoytKhHIkSxtiZj8Ch+tcG0haa1LaeBw9z6dNkiRbIA/Ut8hLHoEVENjrJpYu3krbOMbDmcUMEXwi73o1oJe1a9B3ROp7C58SYrq+XreiqeKTweAadjQhGc0HjBQj6yGXUbwOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BY5PR15MB4786.namprd15.prod.outlook.com (2603:10b6:a03:1ff::27)
 by BYAPR15MB4117.namprd15.prod.outlook.com (2603:10b6:a02:c1::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Thu, 12 Aug
 2021 22:06:14 +0000
Received: from BY5PR15MB4786.namprd15.prod.outlook.com
 ([fe80::43:a229:564f:9a79]) by BY5PR15MB4786.namprd15.prod.outlook.com
 ([fe80::43:a229:564f:9a79%7]) with mapi id 15.20.4415.017; Thu, 12 Aug 2021
 22:06:14 +0000
From:   Jonathan Lemon <bsd@fb.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH net-next 1/3] ptp: ocp: Fix uninitialized variable warning
 spotted by clang.
Thread-Topic: [PATCH net-next 1/3] ptp: ocp: Fix uninitialized variable
 warning spotted by clang.
Thread-Index: AQHXjt8jM/UGFQNC706i0kuecRVa+KtwbJwAgAACLYA=
Date:   Thu, 12 Aug 2021 22:06:14 +0000
Message-ID: <09073BD9-9334-494A-802E-4907CF0F0470@fb.com>
References: <20210811183133.186721-1-jonathan.lemon@gmail.com>
        <20210811183133.186721-2-jonathan.lemon@gmail.com>
 <20210812145826.6d795954@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210812145826.6d795954@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0abad0c7-55e4-42be-feb8-08d95ddd66c5
x-ms-traffictypediagnostic: BYAPR15MB4117:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB41175D7073C725A725B5AC99C4F99@BYAPR15MB4117.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cJ5xVggsU5a2reI/jPv+4z+J5XtmV/vjd03eb1e3oktZJCdETBH2J3T0UMhSZeBgBlNlj7L+Jk0v9Ne4i+v+KqftCCquQFTuLwOtakLDJNG3Uo/lBdMIWsUbjOumZi6Jdrb3u/GfhshIZMCn77xGoBNGOtWebMV9jUIQAU/tkQAskFSndTj9J2BkyVYVGVeI0x6ZHI4gtQFEyqjYpEa1t7mMHfja3EAfFUGLoKbVGppel4/z+qwtCwFlYJjaNBMqE1TSYffTqXaPKbejmhk8LlvCAoZ7p6az7wIn+SP6iTKwxgfIafkRgFaveCnEauEOTKrQvMDD5rbckbjbr+E8eR6e/a12kZMq5YcPqofmTFNCaieXHme2SX1SyKur4RIj+ibYadxYclykU5bs4af3ji+3Az1uD1MBYFJlW74Z6jBfWE0iHD2sQ3AxvyoEjiL14As9I/24do3cu7Fp1x9MIFEHwKT8xcjbqfQKKx0WWQ486dsg4W/C6+trj9ku9ViliG2mwHhJhR375gQkZtKiCUfn6bXcz0vLwU+VH9jDwnjnYpYk5CeWzYv1m/3B373q49BFee7mVJL8L2oSbOAEQ0TIhMTHmhVDf8byCkyKUTQb6oWRsyxWYFdUnV3B/2hLqtgKsHB3kHOKJdYydjZ3Q8XsQumKQnEabBCNA4U4aUxIVX29i1TMMUti3EWDUMt/uQAYLuoxTtp4wSFO6ESO+9gmBAD7P5u7yXLJVVR3ips=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB4786.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(8936002)(6486002)(8676002)(2906002)(4326008)(6916009)(54906003)(2616005)(86362001)(83380400001)(36756003)(53546011)(6506007)(33656002)(186003)(66476007)(478600001)(66556008)(6512007)(91956017)(5660300002)(71200400001)(38100700002)(122000001)(64756008)(66446008)(38070700005)(76116006)(316002)(66946007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVJPVC82YlZDTmprRjcxdlAyMXM0WlI0T0kvTmd3ZXk5bGpnNDFQNUV4a0o0?=
 =?utf-8?B?SnZBNk1ybTFVT2ZYeTl1SmpvREV1MXlFdXZMMnJCaDhRMDdaYm1pVlJCMnJk?=
 =?utf-8?B?b1pnOW8rcXhrb2R4UFYrYkhLb25aSGJVVTN3MEpKUVFKYmFCbnVNZzhJNTNm?=
 =?utf-8?B?ZHZLalZkSFEzQzQ4OEwreHNJY0cyV21NZGNMd2lDaUNxK0FLOGhvNlk2Wm5R?=
 =?utf-8?B?enluU3E1bUN3aVIycTltejhTL3FwM2NKMTI5R1VVdzVYcHpOc3BKemRMZHBW?=
 =?utf-8?B?TjRrUVlHNDR4U3d0NWRkQ0NxN0RHMkxDaUpIa3crS3dyQUJwM2tJWHUraUM1?=
 =?utf-8?B?MzZyTmxITHR5ZzlvWUx5QXhQcFdiaks1WDZJUTkyOExOemxONVp3UUV0dmZi?=
 =?utf-8?B?dTBQSmdvaUpzd2JrM2Z5Tit4ekkxaU9GN2JaUmtaOUtyb1RBT3FFQ3VVMjhk?=
 =?utf-8?B?ZjE0Ylo2cWJBSk9xeVNESjljSDI4SlBmZXM5THpZSjdVOVhrNjFmTTVHRWlq?=
 =?utf-8?B?ajVVZGJEcVVDM1kweGhGWTV1M1FWaFV5KzZZUmI1bytDaUVFUExSejJ6TXg2?=
 =?utf-8?B?cUQvUzAwYVhSalRvTHJtSllIbEZEQ01vMlp1WnJlY0VOclVNVTczbCtZamNp?=
 =?utf-8?B?a0NsUXZDb29Ka0c5YlJWWENCbWF5RWFBT1B6cVpEbHkrdDJhdnVmU0xFWU9l?=
 =?utf-8?B?T3YxMTFTaHpPb0dNcWZhbFhvR0gyMUlXU0ZBY25EbThFdEd0Yzd1blhHN2pZ?=
 =?utf-8?B?SHZZSVNRWnZYaDM5MXNPUUtqOENQZWRyY1hrQTdJamVGRjBsVzQ1SkNUVHFn?=
 =?utf-8?B?SmQ1L2RUaml2RTZlNFZyZFNiUDZ4VHlyL29Ia241VUFrdVBmWEgzVWdsY3or?=
 =?utf-8?B?WnZkNFJPdEdwK3VmVjhqWERpRXU3Vjd4SHZya1ZEOTNlUnJmdnZEbWdqdUls?=
 =?utf-8?B?Tk5CcGFrZEY2Nll2R1JRdmIweDN3d3dJNGpMUkFFbGlza0RqR0dBTWhVRzNN?=
 =?utf-8?B?V1A1ZWV3Ni93MVpDWVVveGp0RjYweExubERCZlBFek0wbUJvK1FOTmpTNjVw?=
 =?utf-8?B?T0x4eUEyOWFJNVUxWkZ4MC8vbWVWY0o0SXA1TVdGYmFEbWFFMmJqL2NQY1JX?=
 =?utf-8?B?TkVnYjJSMEEydmVla1Z2TVc5SFNzV0p2d1VodTB1dTlqOFhTdit3Z0VMMFpJ?=
 =?utf-8?B?ZnVScEJCUjVmbXVIRmNvdnJQbGZWQ0lpT0ZSVWk2a2VqTFMxUGgrSTBBV252?=
 =?utf-8?B?QTFwczVxSHUxODVHcGFxdHBOZTZ0SlhBV3VNcURPeGMxdE50aUtDVmVGVmNN?=
 =?utf-8?B?bnJuNkZPY2pjc1E0MG8vMDVhMW9KbEtoTS9TMFo0K1IwdVpuUWhKd28xU3NE?=
 =?utf-8?B?dGtCK3luQkNnMnZHY0VBRWt2U2JrTU01aEg3RUQ0ZTJKaldDYXBuN2UrOFF1?=
 =?utf-8?B?YlNvdGo1MmlBQ210RjZFVDJJRjFMSVNjbi9zVy82eWJuSmdFVW1iK055Z1M4?=
 =?utf-8?B?MnA3Nk1OTWY2bG85MXJzSk5oajlxbzFmYUxCUVUzWG1VeEVsZ0Z4d1puR3ZD?=
 =?utf-8?B?YmxSMmtnb3ZjNHo4Z1lSQkpRaGQ3ZG55bVhlL0ZQTXJkc09KRkVZd3ZjemE1?=
 =?utf-8?B?QWNOVHg1SFpETEU0QUJ0TWlaMm04UVpPZVpVY0ZTdVlUUHo3eEk2L0NIRStl?=
 =?utf-8?B?L3V2SmZQMEd2YnAwYVlMSjJMakV6Q21GWDcwZW1sRFk2aHRZTVM1Zktja1Y2?=
 =?utf-8?B?dDdmNjcxVDRIbXVSemw1S0d0SVQ4Q3Z2aVRDdG9VTWcyRWpzdm9Qb1oxMlRC?=
 =?utf-8?B?U1ZVaHNtaHRNOVdqL1dsMlJiZXFBNDZ4eXZ2UWFwMFFlbFJ1elcrSVVLc2xK?=
 =?utf-8?Q?kQsK6RdkmREnn?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB4786.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0abad0c7-55e4-42be-feb8-08d95ddd66c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 22:06:14.1783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +jGGzvXoeUSgBv7PEDEGTsaA1qZan8wMJWFd7WSZf+8xzYyBm/ktQk/JKnCnfzpu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4117
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 6pivoVc_Ya8ihq8nMi7OwWI2iuzcYVqU
X-Proofpoint-ORIG-GUID: 6pivoVc_Ya8ihq8nMi7OwWI2iuzcYVqU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-12_06:2021-08-12,2021-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 malwarescore=0
 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0 impostorscore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108120140
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IE9uIEF1ZyAxMiwgMjAyMSwgYXQgMjo1OCBQTSwgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2Vy
bmVsLm9yZz4gd3JvdGU6DQo+IA0KPiDvu79PbiBXZWQsIDExIEF1ZyAyMDIxIDExOjMxOjMxIC0w
NzAwIEpvbmF0aGFuIExlbW9uIHdyb3RlOg0KPj4gSWYgYXR0ZW1wdGluZyB0byBmbGFzaCB0aGUg
ZmlybXdhcmUgd2l0aCBhIGJsb2Igb2Ygc2l6ZSAwLA0KPj4gdGhlIGVudGlyZSB3cml0ZSBsb29w
IGlzIHNraXBwZWQgYW5kIHRoZSB1bmluaXRpYWxpemVkIGVycg0KPj4gaXMgcmV0dXJuZWQuICBG
aXggYnkgc2V0dGluZyB0byAwIGZpcnN0Lg0KPj4gDQo+PiBBbHNvIHJlbW92ZSBhIG5vdy11bnVz
ZWQgZXJyb3IgaGFuZGxpbmcgc3RhdGVtZW50Lg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBKb25h
dGhhbiBMZW1vbiA8am9uYXRoYW4ubGVtb25AZ21haWwuY29tPg0KPj4gLS0tDQo+PiBkcml2ZXJz
L3B0cC9wdHBfb2NwLmMgfCA0ICstLS0NCj4+IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMyBkZWxldGlvbnMoLSkNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvcHRwL3B0cF9v
Y3AuYyBiL2RyaXZlcnMvcHRwL3B0cF9vY3AuYw0KPj4gaW5kZXggOTJlZGY3NzJmZWVkLi45YjJi
YTA2ZWJmOTcgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL3B0cC9wdHBfb2NwLmMNCj4+ICsrKyBi
L2RyaXZlcnMvcHRwL3B0cF9vY3AuYw0KPj4gQEAgLTc2Myw3ICs3NjMsNyBAQCBwdHBfb2NwX2Rl
dmxpbmtfZmxhc2goc3RydWN0IGRldmxpbmsgKmRldmxpbmssIHN0cnVjdCBkZXZpY2UgKmRldiwN
Cj4+ICAgIHNpemVfdCBvZmYsIGxlbiwgcmVzaWQsIHdyb3RlOw0KPj4gICAgc3RydWN0IGVyYXNl
X2luZm8gZXJhc2U7DQo+PiAgICBzaXplX3QgYmFzZSwgYmxrc3o7DQo+PiAtICAgIGludCBlcnI7
DQo+PiArICAgIGludCBlcnIgPSAwOw0KPj4gDQo+PiAgICBvZmYgPSAwOw0KPj4gICAgYmFzZSA9
IGJwLT5mbGFzaF9zdGFydDsNCj4+IEBAIC04NDcsOCArODQ3LDYgQEAgcHRwX29jcF9kZXZsaW5r
X2luZm9fZ2V0KHN0cnVjdCBkZXZsaW5rICpkZXZsaW5rLCBzdHJ1Y3QgZGV2bGlua19pbmZvX3Jl
cSAqcmVxLA0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJsb2FkZXIiLA0K
Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJ1Zik7DQo+PiAgICAgICAgfQ0K
Pj4gLSAgICAgICAgaWYgKGVycikNCj4+IC0gICAgICAgICAgICByZXR1cm4gZXJyOw0KPiANCj4g
TG9va3MgbGlrZSBhbiBhY2NpZGVudGFsIGNoYW5nZSwgYnV0IGl0J3MgbWVudGlvbmVkIGluIHRo
ZSBjb21taXQgbG9nPw0KDQpZZXMsIGludGVudGlvbmFsLCBJIHNwb3R0ZWQgdGhpcyBOT1Agd2hl
biBmaXhpbmcgdGhlIGNvbXBpbGVyIHdhcm5pbmcuIA0K4oCUIA0KSm9uYXRoYW4g
