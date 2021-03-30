Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6365834F0A0
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 20:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbhC3SNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 14:13:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9192 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232492AbhC3SMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 14:12:43 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12UIBBTa019094;
        Tue, 30 Mar 2021 11:12:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=EyRUIuBHNUDC4MpTp5TPHVJV1yvvPaYbBL8TCnei3nE=;
 b=W5G3xZH8jIOhYozS6igWDNRZoKqd6nE9GOb9UZ4G/8wmFjy0pbjhqxIT7ze5IF5UNNIB
 UBzPqNoWLxelgTV9jf8RyDUSJEeJ/AREg+J4ibsuOaoI4Dr7dbwhWG86WI4M7ZS6aIVz
 lejG/uUtKLyRO/yo3xigvn/EEbOn52nM438= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37m89b0c30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Mar 2021 11:12:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 30 Mar 2021 11:12:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPEdzxpJ8vxFJyx3RhtWd0T1llPxdVwFVg+iWdLka+RPxp8VPfOTh9u9ZunZ+UKDlrlJmfhNhpG7oWOD7kyZxSMftVodh3tqwbYIppGt1SzhHP1aukXLSg9HVehO1kKvGaI/uY8sJ95jDAbvyVJ2TUD+9kHVaIk1oilhL4Fw+Nwu9AlN1aJKs+MLi2muqOC6BEZFqyHDg6aLtsJ0gUP0RwfMY47OvncGZ2sJq0bzreQZBTi/6/rDDKueNQ40KzkR1WJPgBvIMKGN8QZWKxxriPt+1+3skiUK7rEYY1/Ct+A6BOUbelFFPmr1j+0pG64h3se0WJD/zIFRO2UtgBlaFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyRUIuBHNUDC4MpTp5TPHVJV1yvvPaYbBL8TCnei3nE=;
 b=Me+chp/LM+KWmqzRvkQL5wxc2DjvVMLIWGHuM0h+Kq2RZYj+91tfukrgzk0avUhY8+C13GPK0zXW8KCDpRh7cjehjAlmIMqts2nWg7MP1Gc55kWdzY5pSz5LESyaYlgnoQJmHIBcthzopX4XP1xJ7PcDc1JGbZSgJBrza07tr1CCGfmZNhj/WknvFTTzb+8P7zdtaQotaLLE1jCmaI012V7KbaF3Mzy4AremRXCiMIgZZXIVAlEq7pYe+QqhDDrAWpDhuAp6vyRNXZI/kzE1pJzya/Pmf/2x2lagxLM63VKUy02fmQivHYG1LiNsRo6V8NaHeKRFKWwshjGa3OBQUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2775.namprd15.prod.outlook.com (2603:10b6:a03:15a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Tue, 30 Mar
 2021 18:12:21 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Tue, 30 Mar 2021
 18:12:21 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Pedro Tammela <pctammela@gmail.com>
CC:     Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: check flags in 'bpf_ringbuf_discard()' and
 'bpf_ringbuf_submit()'
Thread-Topic: [PATCH bpf-next] bpf: check flags in 'bpf_ringbuf_discard()' and
 'bpf_ringbuf_submit()'
Thread-Index: AQHXI+0ig0TIMP/v406/VUGb0CIUpKqbJEwAgAF0HoCAAEAuAA==
Date:   Tue, 30 Mar 2021 18:12:21 +0000
Message-ID: <AA8588A6-70C3-4A00-B081-646F7E981A14@fb.com>
References: <20210328161055.257504-1-pctammela@mojatatu.com>
 <20210328161055.257504-2-pctammela@mojatatu.com>
 <A175BAAD-39B2-4ECE-9BA0-D070E84484FF@fb.com>
 <CAKY_9u0J8gurpOhR9YZceH3N2jJFm=v5VLw3atjo==gTp_-RQg@mail.gmail.com>
In-Reply-To: <CAKY_9u0J8gurpOhR9YZceH3N2jJFm=v5VLw3atjo==gTp_-RQg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8dbe]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76ba5c01-5edf-40aa-80db-08d8f3a75cc7
x-ms-traffictypediagnostic: BYAPR15MB2775:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2775E31DAB0D9C8E56C445D2B37D9@BYAPR15MB2775.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:813;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k+t58ha2Y+RbjnOOTB/2ZufukrPhGfwl9SfW0Nwf68WAPM24qTZLk5rqlIeqQZup1KG16l9hPs3qkjiVrDGu7cT6v4tDSpApUJdb6syGUF4cTmpR0x7rmm1TH8c7jPAbYmShvB7WAsMMdAEDYB4iveWyj/HkNUhHPW9EizXunf1l1enzG1AHQh2kO9kBEiv7QyvR3cP8iEgsCGu5tWL+Q4BPjsxFfhXUm9lWA+q+4pJU4AZAPOIWCFtU3RATUi32UX1kJHudWO7lA25SlAfkXV2X7HOuH/UVfwR8EddzjIOanzmpSm/u9BXxY6kAHj3djAS8bayD/UhQ7HPJrgeqUuKZdolle4VorYAio4OY8/x/SXRUDlLsxh/XxAvgz3eIHjcJUAE7vx5zGG8w4y+5b3TfY2a+zyyZ4j+BtY3+vjZSWblJ+ECPP87EJXif3IhK82tqb/IAcsMNc9h87adwkZED9CwjMMEwVWh/yQe2bDMhGOkmP2x+zAT/9eJYmOBpJjvIbbHYK9Hjya56kNMAeyISFy42LHvcfQrx7s0HOKD66alRw17FkVxDnAdT/xnpPCsbCwOwYesOlmdFAyWwTecXbgLhhIL49cF/Riuv0HEA33yTiuUnG1Vc0sqvmJAesqTFFVm/zwqxDaVGQmHDLUkkvbTH3VH/7hACEQayZLrhaAAdU4YUwzbgNcK/+JUG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(396003)(39860400002)(376002)(7416002)(6506007)(66476007)(6916009)(76116006)(71200400001)(6486002)(66446008)(186003)(478600001)(4326008)(316002)(8676002)(66556008)(83380400001)(2616005)(36756003)(54906003)(33656002)(5660300002)(8936002)(64756008)(38100700001)(86362001)(2906002)(53546011)(6512007)(91956017)(66946007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Tm5VSmhlVS9NQnZOcTkzVUNXMHhtZmtXanFtRXpyY0EvMVNrMkFYdWh4Smt4?=
 =?utf-8?B?RnlGM1pTbS9mTnRaNnExTHRyRDcva1JNRkEwUFdSMGx4RWQyZTFYdnF1STUz?=
 =?utf-8?B?YlpneXhMaTNBMmRmVnBZNDJ5Rjl0VnFlcjJHT0NzZ0ZlMUQzakc5VXhGU1hB?=
 =?utf-8?B?bUxJZjlOei92OWEyZ1ZreFVib256R3d1dWpIaHBidmdGVlpYNHZxMjI3Tit5?=
 =?utf-8?B?amdOWFovb051WXlycjJkQVA0bnpmc0R5bHpYZTlJdEZ3QjdYUjMxOUNoZCtD?=
 =?utf-8?B?YXRES25GL0RBZUlXempOK1gxYUMyMEhZWlUxQkswTWFaczdCNEhSbUNtOVZu?=
 =?utf-8?B?RFdLaTZqZlIrU09CbGRmbHBHZVd0NkdrSDFvR2c4SVJvUElhcEhOV0hpUDlL?=
 =?utf-8?B?M1lOUGNKTzB3cVhIVTZYdDN0SW5ZckRXMGJieXY0SzUwLzNsTEsyQWJwajg5?=
 =?utf-8?B?aDdkWHlTS0JwMTVoRFFIcFA5S2JNSjRuMXV0SU5XY1JlQ0x3ckhUZCtFRDFM?=
 =?utf-8?B?OHpJR1ZMNVlEa0wxemJuZ3E4RWtmbnZGbWtQWmpBYnlZNC95NTdFdG5Fb3d3?=
 =?utf-8?B?eWNkeXdBMjNVMzNMeGNpM1F6cEFkQS9zM3M5SDZhS0xDbjIyL2tLL0Z3Nkgr?=
 =?utf-8?B?R1Z0UXUrQVA3WmcvVFpJTG85TFpKZVdQUW5zM2piUnMwUG00OG5tWXNxZWVr?=
 =?utf-8?B?Szl1OGVneVhkdkJ6R1hYeGRNaGxSMXhoc0oxZCtKVEhRd1NYUVBZTXk2UCtu?=
 =?utf-8?B?U2FpM0dtUG4ySlZlbFRkVy9PYURaWVBuY05Fc1hOdU5aMGl4S1c0N2grOWFJ?=
 =?utf-8?B?RFJRZXVyWXVQVnBFZFhZZE9hV3ZwM3pJWTJnKzBjamFNSUtGOXZuTDFYUXVh?=
 =?utf-8?B?ekM4bGxzUWRmVno3NWxvbkZCYk1lS2N5bEpNUkJwOFlkUTB4a3BTWU4rUGs0?=
 =?utf-8?B?d0c2Zk1mcWFPL2tLbmh0RWh4UjZuNFB4TzV3YTVheWxPZTlXREVyVmdDWjJN?=
 =?utf-8?B?UWYrWHVVUC9TcER5VFhDeVFRd3ZrRi9GazRTM2R6TlhEb2QwM2ltS0NmN3Q5?=
 =?utf-8?B?RGpJNEdYNDhkekRRdkNXeTA3OTZGMWVYRFZpck5idXBHOEFXMHVvTlA4SjQx?=
 =?utf-8?B?Ulc5YVIzT1lTdm4wa21JL2lGd2ZMRmhXUWlwcDBOUE40VFIwSE5WeVJETzdQ?=
 =?utf-8?B?ZzdEZjY0Vk9vbGVLRmI0ZTI5bkp3a2RqakdTclFjcEVZMThIZkg1MkZ2Q1l5?=
 =?utf-8?B?WTFBdlRWMWpOelNIWVA4U2lUS3ZUd3lsU3RpVEx6VmwyRS80N0YzdXZOcURJ?=
 =?utf-8?B?QzkraDZrVWN3SmlnZjdKRGFUQlNWZWdMOXZLWXVWOTUwa0toT1NmY09UZUsv?=
 =?utf-8?B?OE82MjNaOU1nWll1REJMSW95YnZvN21wbDRLVEk1Q2V5eFFQVTFDelcvbUEv?=
 =?utf-8?B?WGJXdGJ2Q25PTGJkZnNMeExVdVZRTHBnUG9UWms1dXMycHVZaUE1R3ZxUzFj?=
 =?utf-8?B?UXUyQStyb095QVVKWitSSTlFb2x5MHgwWTNmUGdGcEtIdXh0UzFaV2JXUGQ1?=
 =?utf-8?B?QUU5WTZUNzZ0N3BDNEtSdnZ2aC9hN3R5d01zd0NaOEZJbHhwdTJBOHNFRHpK?=
 =?utf-8?B?ZStFU3FmOWFGMHNzQ0wxLzZDL2R3aHMvUXdJekNiMkptVEd3VVhPZndldGQv?=
 =?utf-8?B?dGh4ajdxdVBGZExxbXFNV0pSS2NpV0V6NFdLYWdEaVdLeVdVV1phZmYxcUc1?=
 =?utf-8?B?bmZjaDExWlh3akZUa0w2OVBUOUd5UEs3ZmlTaGFRM0MydHdCMm1sa3o2V2Zp?=
 =?utf-8?Q?7OfwveUwPSx8VGJOAeyK2loy0rfs1GnWGKO6s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15701119AE2DFE4EA7F258A81DD81433@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ba5c01-5edf-40aa-80db-08d8f3a75cc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2021 18:12:21.3462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Qon+patEjT2Zwv70fr/GC/lrAfYqwjL/yVQLnTWf7FtdW6ZYhJpyihPvaTdzxwzyBIr8RTDeIsRtL9vrYFjjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2775
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: pzePmPQSQcnec3vYF3_sU1zjAG13U_ID
X-Proofpoint-GUID: pzePmPQSQcnec3vYF3_sU1zjAG13U_ID
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_08:2021-03-30,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 mlxscore=0 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTWFyIDMwLCAyMDIxLCBhdCA3OjIyIEFNLCBQZWRybyBUYW1tZWxhIDxwY3RhbW1l
bGFAZ21haWwuY29tPiB3cm90ZToNCj4gDQo+IEVtIHNlZy4sIDI5IGRlIG1hci4gZGUgMjAyMSDD
oHMgMTM6MTAsIFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+IGVzY3JldmV1Og0KPj4g
DQo+PiANCj4+IA0KPj4+IE9uIE1hciAyOCwgMjAyMSwgYXQgOToxMCBBTSwgUGVkcm8gVGFtbWVs
YSA8cGN0YW1tZWxhQGdtYWlsLmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gVGhlIGN1cnJlbnQgY29k
ZSBvbmx5IGNoZWNrcyBmbGFncyBpbiAnYnBmX3JpbmdidWZfb3V0cHV0KCknLg0KPj4+IA0KPj4+
IFNpZ25lZC1vZmYtYnk6IFBlZHJvIFRhbW1lbGEgPHBjdGFtbWVsYUBtb2phdGF0dS5jb20+DQo+
Pj4gLS0tDQo+Pj4gaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oICAgICAgIHwgIDggKysrKy0tLS0N
Cj4+PiBrZXJuZWwvYnBmL3JpbmdidWYuYyAgICAgICAgICAgfCAxMyArKysrKysrKysrKy0tDQo+
Pj4gdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIHwgIDggKysrKy0tLS0NCj4+PiAzIGZp
bGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPj4+IA0KPj4+
IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggYi9pbmNsdWRlL3VhcGkvbGlu
dXgvYnBmLmgNCj4+PiBpbmRleCAxMDBjYjJlNGMxMDQuLjIzMmI1ZTVkZDA0NSAxMDA2NDQNCj4+
PiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4+PiArKysgYi9pbmNsdWRlL3VhcGkv
bGludXgvYnBmLmgNCj4+PiBAQCAtNDA3Myw3ICs0MDczLDcgQEAgdW5pb24gYnBmX2F0dHIgew0K
Pj4+ICogICAgICAgICAgICBWYWxpZCBwb2ludGVyIHdpdGggKnNpemUqIGJ5dGVzIG9mIG1lbW9y
eSBhdmFpbGFibGU7IE5VTEwsDQo+Pj4gKiAgICAgICAgICAgIG90aGVyd2lzZS4NCj4+PiAqDQo+
Pj4gLSAqIHZvaWQgYnBmX3JpbmdidWZfc3VibWl0KHZvaWQgKmRhdGEsIHU2NCBmbGFncykNCj4+
PiArICogaW50IGJwZl9yaW5nYnVmX3N1Ym1pdCh2b2lkICpkYXRhLCB1NjQgZmxhZ3MpDQo+PiAN
Cj4+IFRoaXMgc2hvdWxkIGJlICJsb25nIiBpbnN0ZWFkIG9mICJpbnQiLg0KPj4gDQo+Pj4gKiAg
ICBEZXNjcmlwdGlvbg0KPj4+ICogICAgICAgICAgICBTdWJtaXQgcmVzZXJ2ZWQgcmluZyBidWZm
ZXIgc2FtcGxlLCBwb2ludGVkIHRvIGJ5ICpkYXRhKi4NCj4+PiAqICAgICAgICAgICAgSWYgKipC
UEZfUkJfTk9fV0FLRVVQKiogaXMgc3BlY2lmaWVkIGluICpmbGFncyosIG5vIG5vdGlmaWNhdGlv
bg0KPj4+IEBAIC00MDgzLDkgKzQwODMsOSBAQCB1bmlvbiBicGZfYXR0ciB7DQo+Pj4gKiAgICAg
ICAgICAgIElmICoqQlBGX1JCX0ZPUkNFX1dBS0VVUCoqIGlzIHNwZWNpZmllZCBpbiAqZmxhZ3Mq
LCBub3RpZmljYXRpb24NCj4+PiAqICAgICAgICAgICAgb2YgbmV3IGRhdGEgYXZhaWxhYmlsaXR5
IGlzIHNlbnQgdW5jb25kaXRpb25hbGx5Lg0KPj4+ICogICAgUmV0dXJuDQo+Pj4gLSAqICAgICAg
ICAgICBOb3RoaW5nLiBBbHdheXMgc3VjY2VlZHMuDQo+Pj4gKyAqICAgICAgICAgICAwIG9uIHN1
Y2Nlc3MsIG9yIGEgbmVnYXRpdmUgZXJyb3IgaW4gY2FzZSBvZiBmYWlsdXJlLg0KPj4+ICoNCj4+
PiAtICogdm9pZCBicGZfcmluZ2J1Zl9kaXNjYXJkKHZvaWQgKmRhdGEsIHU2NCBmbGFncykNCj4+
PiArICogaW50IGJwZl9yaW5nYnVmX2Rpc2NhcmQodm9pZCAqZGF0YSwgdTY0IGZsYWdzKQ0KPj4g
DQo+PiBEaXR0by4gQW5kIHNhbWUgZm9yIHRvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9icGYuaA0K
Pj4gDQo+Pj4gKiAgICBEZXNjcmlwdGlvbg0KPj4+ICogICAgICAgICAgICBEaXNjYXJkIHJlc2Vy
dmVkIHJpbmcgYnVmZmVyIHNhbXBsZSwgcG9pbnRlZCB0byBieSAqZGF0YSouDQo+Pj4gKiAgICAg
ICAgICAgIElmICoqQlBGX1JCX05PX1dBS0VVUCoqIGlzIHNwZWNpZmllZCBpbiAqZmxhZ3MqLCBu
byBub3RpZmljYXRpb24NCj4+PiBAQCAtNDA5NSw3ICs0MDk1LDcgQEAgdW5pb24gYnBmX2F0dHIg
ew0KPj4+ICogICAgICAgICAgICBJZiAqKkJQRl9SQl9GT1JDRV9XQUtFVVAqKiBpcyBzcGVjaWZp
ZWQgaW4gKmZsYWdzKiwgbm90aWZpY2F0aW9uDQo+Pj4gKiAgICAgICAgICAgIG9mIG5ldyBkYXRh
IGF2YWlsYWJpbGl0eSBpcyBzZW50IHVuY29uZGl0aW9uYWxseS4NCj4+PiAqICAgIFJldHVybg0K
Pj4+IC0gKiAgICAgICAgICAgTm90aGluZy4gQWx3YXlzIHN1Y2NlZWRzLg0KPj4+ICsgKiAgICAg
ICAgICAgMCBvbiBzdWNjZXNzLCBvciBhIG5lZ2F0aXZlIGVycm9yIGluIGNhc2Ugb2YgZmFpbHVy
ZS4NCj4+PiAqDQo+Pj4gKiB1NjQgYnBmX3JpbmdidWZfcXVlcnkodm9pZCAqcmluZ2J1ZiwgdTY0
IGZsYWdzKQ0KPj4+ICogICAgRGVzY3JpcHRpb24NCj4+PiBkaWZmIC0tZ2l0IGEva2VybmVsL2Jw
Zi9yaW5nYnVmLmMgYi9rZXJuZWwvYnBmL3JpbmdidWYuYw0KPj4+IGluZGV4IGYyNWI3MTlhYzc4
Ni4uZjc2ZGFmZTI0MjdlIDEwMDY0NA0KPj4+IC0tLSBhL2tlcm5lbC9icGYvcmluZ2J1Zi5jDQo+
Pj4gKysrIGIva2VybmVsL2JwZi9yaW5nYnVmLmMNCj4+PiBAQCAtMzk3LDI2ICszOTcsMzUgQEAg
c3RhdGljIHZvaWQgYnBmX3JpbmdidWZfY29tbWl0KHZvaWQgKnNhbXBsZSwgdTY0IGZsYWdzLCBi
b29sIGRpc2NhcmQpDQo+Pj4gDQo+Pj4gQlBGX0NBTExfMihicGZfcmluZ2J1Zl9zdWJtaXQsIHZv
aWQgKiwgc2FtcGxlLCB1NjQsIGZsYWdzKQ0KPj4+IHsNCj4+PiArICAgICBpZiAodW5saWtlbHko
ZmxhZ3MgJiB+KEJQRl9SQl9OT19XQUtFVVAgfCBCUEZfUkJfRk9SQ0VfV0FLRVVQKSkpDQo+Pj4g
KyAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4+IA0KPj4gV2UgY2FuIG1vdmUgdGhpcyBj
aGVjayB0byBicGZfcmluZ2J1Zl9jb21taXQoKS4NCj4gDQo+IEkgZG9uJ3QgYmVsaWV2ZSB3ZSBj
YW4gYmVjYXVzZSBpbiAnYnBmX3JpbmdidWZfb3V0cHV0KCknIHRoZSBmbGFnDQo+IGNoZWNraW5n
IGluICdicGZfcmluZ2J1Zl9jb21taXQoKScgaXMgYWxyZWFkeQ0KPiB0b28gbGF0ZS4NCg0KSSBz
ZWUuIExldCdzIGtlZXAgaXQgaW4gY3VycmVudCBmdW5jdGlvbnMgdGhlbi4gDQoNClRoYW5rcywN
ClNvbmcNCg0K
