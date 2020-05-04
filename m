Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2E81C432E
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730337AbgEDRpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:45:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31872 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730328AbgEDRpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:45:49 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 044HXBho029127;
        Mon, 4 May 2020 10:45:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DTxB3HrY7S3knEkdkDEdBT1xhDEqRDvlUHZa/2GAMUU=;
 b=HWHCFDgwpZeyW6OkaJROE8f8rLEHdGg9I1kzvZp4iv7ZHl6oETvoEuhKNvZmFKDxilKV
 PQWCBiK/ahA5AE2a9TEWIc8GWia6uUYGa5lzJLG0PGPLu+Yhn1t9U/7osCdphQ3orLLF
 Wf+P7pnz1T4HC8RaPgiAL6d+R3fMqZgAUTk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30tfp5adnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 04 May 2020 10:45:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 4 May 2020 10:45:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtbCawZ2IAetsPpgsIxWW0bsjCh4fDLXriiABpTbG8L6xsUVvfzefOAnu7yiIZ4bkQ98FFEBjKTHAgithzaYL5Vfcx1W40bPuhDAWanxW/aGesIcpJB+9vHBRzPb1mk3nW9ZJ3/UhO38alGPIEMa6yXpOi8dFERAhvRgE6L7tzTC3/13GFA2euQKRgpG9FojpfSAyww+8WxX6RAkUQzDhGFsKeVT6D3uw0+IDBfh6JCqmJMzx9WiUGns2879rdBeBCgNnEMP8m3I1IjCgVq+rQNU+CnxDGAAao3ECBbh1lft2nWb7uiDcXzUtWovT1VeRGElFC8+5GRAoaeJpZ3+mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTxB3HrY7S3knEkdkDEdBT1xhDEqRDvlUHZa/2GAMUU=;
 b=FdeqoJ+H7UUJjyPbcqiFipJ0BzLXZ1DEs1O5cp2Nl1MBf5xdXyF7GnrMXu1iCQ+EMb2EIh6ER8/4I+IGWKGrVB9MtDaVRRuP4COwXrRGKz0KTyJba5lD79WVxQMueN+nb1efhJCkwx+s+MRDqN1TKLmerENiDDYUwH6b5xgVvCb++tgE76hCzQetEr0+oIUNL/wcmLU+5tsKaDLf7UCQb2ldQzmNIqyEpFRMCYWhItOdTBwU9OK1FNQR3l6rApIUSD19Ss6k4aV/nSHijwJzp6Xjnw+oVbv7kAnL9Ha+KSVsW9LR7OCwPeFrPa2Q3XP+YlZF5w2KbUOVjX7PE/hjdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTxB3HrY7S3knEkdkDEdBT1xhDEqRDvlUHZa/2GAMUU=;
 b=cB9woWlz4MWBx+SCCXVbCT4zcJmi8jLFa76+DVMoT0IVCf1zNAWQI6mi4hIgmTd+1D/kKQk115P56tcZtLgzCJuTswI20cYQGzAM8y1y6QfZBgKOpf/riMTTSylDE1itp1v7T39w5ZPfgtDouoZiCN16nfTtEUHSyRXToDBvo0A=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYASPR01MB0067.namprd15.prod.outlook.com (2603:10b6:a03:4c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Mon, 4 May
 2020 17:45:32 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2%7]) with mapi id 15.20.2958.030; Mon, 4 May 2020
 17:45:32 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        "Network Development" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v9 bpf-next 2/3] libbpf: add support for command
 BPF_ENABLE_STATS
Thread-Topic: [PATCH v9 bpf-next 2/3] libbpf: add support for command
 BPF_ENABLE_STATS
Thread-Index: AQHWHr8f5zklsZg9ZUaDxkLTs7EJcaiVOw2AgAL/EIA=
Date:   Mon, 4 May 2020 17:45:32 +0000
Message-ID: <19614603-D8E5-49E9-AB70-A022A409EF03@fb.com>
References: <20200430071506.1408910-1-songliubraving@fb.com>
 <20200430071506.1408910-3-songliubraving@fb.com>
 <CAADnVQK-Zo19Z1Gdaq9MYE_9GmyrCuOFbz873D4uCvvVSp0j0w@mail.gmail.com>
In-Reply-To: <CAADnVQK-Zo19Z1Gdaq9MYE_9GmyrCuOFbz873D4uCvvVSp0j0w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:117f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a621f4b2-603d-4569-03e3-08d7f052f164
x-ms-traffictypediagnostic: BYASPR01MB0067:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYASPR01MB00679A7F94FB66E81F377A35B3A60@BYASPR01MB0067.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03932714EB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TiUMbnTOVYeePc6f7zdkzyz2V3YGzsUQLr4pfdFECShcNigLCPBaU6cLK0c74wrwSxWKh5/na7ex5FQEnZCJO9KkWsJVzDIV0CNi6Vv5IZgyfhzxWjFMpFoBnqLevxnF8QGWzUDlihEEjeL2LX3Ag1qRBQBkrho8XMrqzLnXVGxX36yO29DN3ZFfweiE/Zu5cnI2jVN5Cu75i8l6m98PUJmeeXfxPRpYZb1DHXpXSpigg1VJs+ABN03nPbekTewI8Ge1AP9UAZfxDqNqHUtNqFs81h0AdYLN4j94qekMHmzyGNzxB/Vo+RRTyj/SA/54VqQ1ToIN8dZzlFc64cCtIQfAKtN5KCeuYSgFVoQRwMha3HBlWpFoZe1UkjclnrgMgt0LFBRuSV4Xb7A9gAAziODbn0Ax11EdBkT1FKaMbJCrmFRQtvsFeTii05ERCWIK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(39860400002)(396003)(346002)(366004)(6486002)(2906002)(5660300002)(4326008)(186003)(478600001)(8676002)(316002)(8936002)(2616005)(53546011)(36756003)(71200400001)(6506007)(54906003)(76116006)(86362001)(66946007)(64756008)(66446008)(6916009)(33656002)(66556008)(66476007)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OcGgFwTmM3tJxXdehZUtNg+BGT4JpicS0+NfnEwUWJErhGEvbAbcjkHGGaHIAf5ptOSmSWPpePbCOnAELHz4b2gXCyOrNueqmTlErXbhFymvs+Y/9rdK70+zpnWVOlPEF7jOuW5EtoSOihJo+bv/snHILA6b6zVaScQpH2Exs0v8pK1vCy8AV3qsUkekJvi9CuisEy4sfYhwvEWo1aHjMK9x2GvRm+ydDttQjXkO/U+fmZeq2EcvT3ZEfiSQbHM0KDczz1PPBRfwJhZZeKZvNksQDKrqQ4CLXXeIhGmvtOxcU560KkRi9cTDF61VQiJYYOUzDTzyFolp54Eid9kdc/9hbVBF+PxOV/cFmUv8Wd5EBPW4QXp8IYCZcmnAFQj/IFLBdTl9XSSCgc8dik6AYmuXvOxLNg5njIXj77I+eFGXIrkox/evx40nRdQyiJxhspfVRyvLY6PlMbAChISiY3hcEOaAx9KDRI2GaTVyQVOcU91qvNjj7SIOWhj6DNAV/NrZxJVUpW+jVgm3BMs5n66oRU+lRhaGY8sdUfLdRF8VWt4BhdlVpB/hoOUmpVR3Df76KAWT4ljRaz3zPdpCEn3Lorusc7nNJ0d8d/aH/dvAO3sEQ+zMLhs1h7mwYGVk4RreRglEgf9hx1cuw0xUgq5IlnYIXMkteDOYkdLoTcSTvf3BQ5bbERJLzjFaL16XUEZF7vZB4JGM0+Z+FKAgDBBGmz1iHwpnT3ExTSDOLkrpM0GjL73B+cYRk0Q6poM+Q6uPx2xHkjwajXKok9U8uXZWHBEp8WwVoeXa4Kcs1MPXvwmjopE+Vb8KHrImd6T9a/YgqFaoftUgBJ5epxmLag==
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BCB0DD750795045AB8B14DD5EA24612@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a621f4b2-603d-4569-03e3-08d7f052f164
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2020 17:45:32.2253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x3wlXsb8Q7ne1Xvpq+O5tlPe8hlAZLPw4scz5Ia0czEpkG1kXJzGZ3Q4PcY5/D/Q8iDEwy/0NR/RyNJMn4EEZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYASPR01MB0067
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_11:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 clxscore=1015 lowpriorityscore=0
 phishscore=0 adultscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTWF5IDIsIDIwMjAsIGF0IDE6MDAgUE0sIEFsZXhlaSBTdGFyb3ZvaXRvdiA8YWxl
eGVpLnN0YXJvdm9pdG92QGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUaHUsIEFwciAzMCwg
MjAyMCBhdCAxMjoxNSBBTSBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPiB3cm90ZToN
Cj4+IA0KPj4gYnBmX2VuYWJsZV9zdGF0cygpIGlzIGFkZGVkIHRvIGVuYWJsZSBnaXZlbiBzdGF0
cy4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogU29uZyBMaXUgPHNvbmdsaXVicmF2aW5nQGZiLmNv
bT4NCj4gLi4uDQo+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9icGYuaCBiL3Rvb2xzL2xp
Yi9icGYvYnBmLmgNCj4+IGluZGV4IDMzNWI0NTdiM2EyNS4uMTkwMWIyNzc3ODU0IDEwMDY0NA0K
Pj4gLS0tIGEvdG9vbHMvbGliL2JwZi9icGYuaA0KPj4gKysrIGIvdG9vbHMvbGliL2JwZi9icGYu
aA0KPj4gQEAgLTIzMSw2ICsyMzEsNyBAQCBMSUJCUEZfQVBJIGludCBicGZfbG9hZF9idGYodm9p
ZCAqYnRmLCBfX3UzMiBidGZfc2l6ZSwgY2hhciAqbG9nX2J1ZiwNCj4+IExJQkJQRl9BUEkgaW50
IGJwZl90YXNrX2ZkX3F1ZXJ5KGludCBwaWQsIGludCBmZCwgX191MzIgZmxhZ3MsIGNoYXIgKmJ1
ZiwNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgX191MzIgKmJ1Zl9sZW4sIF9f
dTMyICpwcm9nX2lkLCBfX3UzMiAqZmRfdHlwZSwNCj4+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgX191NjQgKnByb2JlX29mZnNldCwgX191NjQgKnByb2JlX2FkZHIpOw0KPj4gK0xJ
QkJQRl9BUEkgaW50IGJwZl9lbmFibGVfc3RhdHMoZW51bSBicGZfc3RhdHNfdHlwZSB0eXBlKTsN
Cj4gDQo+IEkgc2VlIG9kZCB3YXJuaW5nIGhlcmUgd2hpbGUgYnVpbGRpbmcgc2VsZnRlc3RzDQo+
IA0KPiBJbiBmaWxlIGluY2x1ZGVkIGZyb20gcnVucXNsb3dlci5jOjEwOg0KPiAuLi4vdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rvb2xzL2luY2x1ZGUvYnBmL2JwZi5oOjIzNDozODoNCj4g
d2FybmluZzog4oCYZW51bSBicGZfc3RhdHNfdHlwZeKAmSBkZWNsYXJlZCBpbnNpZGUgcGFyYW1l
dGVyIGxpc3Qgd2lsbCBub3QNCj4gYmUgdmlzaWJsZSBvdXRzaWRlIG9mIHRoaXMgZGVmaW5pdGlv
biBvciBkZWNsYXJhdGlvbg0KPiAgMjM0IHwgTElCQlBGX0FQSSBpbnQgYnBmX2VuYWJsZV9zdGF0
cyhlbnVtIGJwZl9zdGF0c190eXBlIHR5cGUpOw0KPiANCj4gU2luY2UgdGhpcyB3YXJuaW5nIGlz
IHByaW50ZWQgb25seSB3aGVuIGJ1aWxkaW5nIHJ1bnFzbG93ZXINCj4gYW5kIHRoZSByZXN0IG9m
IHNlbGZ0ZXN0cyBhcmUgZmluZSwgSSdtIGd1ZXNzaW5nDQo+IGl0J3MgYSBtYWtlZmlsZSBpc3N1
ZSB3aXRoIG9yZGVyIG9mIGluY2x1ZGVzPw0KPiANCj4gQW5kcmlpLCBjb3VsZCB5b3UgcGxlYXNl
IHRha2UgYSBsb29rID8NCj4gTm90IHVyZ2VudC4gSnVzdCBmbGFnZ2luZyBmb3IgdmlzaWJpbGl0
eS4NCg0KVGhlIGZvbGxvd2luZyBzaG91bGQgZml4IGl0LiANCg0KVGhhbmtzLA0KU29uZw0KDQo9
PT09PT09PT09PT09PT09PT09PT09PT09PT0gODwgPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09DQoNCkZyb20gNDg1YzI4YzhlMmNiY2MyMmFhOGZjZGE4MmY4ZjU5OTQxMWZhYTc1NSBNb24g
U2VwIDE3IDAwOjAwOjAwIDIwMDENCkZyb206IFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5j
b20+DQpEYXRlOiBNb24sIDQgTWF5IDIwMjAgMTA6MzY6MjYgLTA3MDANClN1YmplY3Q6IFtQQVRD
SCBicGYtbmV4dF0gcnVucXNsb3dlcjogaW5jbHVkZSBwcm9wZXIgdWFwaS9icGYuaA0KDQpydW5x
c2xvd2VyIGRvZXNuJ3Qgc3BlY2lmeSBpbmNsdWRlIHBhdGggZm9yIHVhcGkvYnBmLmguIFRoaXMg
Y2F1c2VzIHRoZQ0KZm9sbG93aW5nIHdhcm5pbmc6DQoNCkluIGZpbGUgaW5jbHVkZWQgZnJvbSBy
dW5xc2xvd2VyLmM6MTA6DQouLi4vdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rvb2xzL2lu
Y2x1ZGUvYnBmL2JwZi5oOjIzNDozODoNCndhcm5pbmc6ICdlbnVtIGJwZl9zdGF0c190eXBlJyBk
ZWNsYXJlZCBpbnNpZGUgcGFyYW1ldGVyIGxpc3Qgd2lsbCBub3QNCmJlIHZpc2libGUgb3V0c2lk
ZSBvZiB0aGlzIGRlZmluaXRpb24gb3IgZGVjbGFyYXRpb24NCiAgMjM0IHwgTElCQlBGX0FQSSBp
bnQgYnBmX2VuYWJsZV9zdGF0cyhlbnVtIGJwZl9zdGF0c190eXBlIHR5cGUpOw0KDQpGaXggdGhp
cyBieSBhZGRpbmcgLUkgdG9vbHMvaW5jbHVkL3VhcGkgdG8gdGhlIE1ha2VmaWxlLg0KDQpSZXBv
cnRlZC1ieTogQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4NClNpZ25lZC1vZmYt
Ynk6IFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+DQotLS0NCiB0b29scy9icGYvcnVu
cXNsb3dlci9NYWtlZmlsZSB8IDMgKystDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvdG9vbHMvYnBmL3J1bnFzbG93ZXIvTWFr
ZWZpbGUgYi90b29scy9icGYvcnVucXNsb3dlci9NYWtlZmlsZQ0KaW5kZXggOGE2ZjgyZTU2YTI0
Li43MjJhMjlhOTg4Y2QgMTAwNjQ0DQotLS0gYS90b29scy9icGYvcnVucXNsb3dlci9NYWtlZmls
ZQ0KKysrIGIvdG9vbHMvYnBmL3J1bnFzbG93ZXIvTWFrZWZpbGUNCkBAIC04LDcgKzgsOCBAQCBC
UEZUT09MID89ICQoREVGQVVMVF9CUEZUT09MKQ0KIExJQkJQRl9TUkMgOj0gJChhYnNwYXRoIC4u
Ly4uL2xpYi9icGYpDQogQlBGT0JKIDo9ICQoT1VUUFVUKS9saWJicGYuYQ0KIEJQRl9JTkNMVURF
IDo9ICQoT1VUUFVUKQ0KLUlOQ0xVREVTIDo9IC1JJChPVVRQVVQpIC1JJChCUEZfSU5DTFVERSkg
LUkkKGFic3BhdGggLi4vLi4vbGliKQ0KK0lOQ0xVREVTIDo9IC1JJChPVVRQVVQpIC1JJChCUEZf
SU5DTFVERSkgLUkkKGFic3BhdGggLi4vLi4vbGliKSAgICAgICAgXA0KKyAgICAgICAtSSQoYWJz
cGF0aCAuLi8uLi9pbmNsdWRlL3VhcGkpDQogQ0ZMQUdTIDo9IC1nIC1XYWxsDQoNCiAjIFRyeSB0
byBkZXRlY3QgYmVzdCBrZXJuZWwgQlRGIHNvdXJjZQ0KLS0NCjIuMjQuMQ0KDQo=
