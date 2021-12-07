Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD0646B1E5
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 05:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbhLGEfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 23:35:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6616 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233659AbhLGEfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 23:35:38 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B737qat024098;
        Mon, 6 Dec 2021 20:32:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Dmemsg3oc9tarM13UdrTY6aylQVP48K/ZKOY8PdXhuk=;
 b=qSje0IpsFR1/WR4Yc7Tbw1qIKZDgLNblzmK7OKpbOm+/LFz+8o6VmBi5eaEsESPz6Gc4
 9y4P+EhwHWBuEfZWOU/SRj5vk40BnQn9novnB6M+72/wqNVSjcYd6cA7/G1n9DjMTNoK
 YBxq9B5wqVLvEYwlas/uIBAonW0fBIlSA+0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3csyecravu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 06 Dec 2021 20:32:08 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 20:32:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMKeIwLnD8Wwvf+ztp1zIpSQrR//Hc0xAX3SUQR6Fjl+W6hUWVGTWIFYoRRQcEKEHTmxOtZfY7nP/ECvYY89+LQXT6JpLF8MXXkjrNazH0NFtNQ4JK9cwEjBm9CvA9yGN9eGiura48v3gb58WLk+uQnTGPuM8V4z+MPy45iho1L7iM3bPaaItJnrFDLVlWxivGxyMFWHWwMeKh/D7e4UWGM6JXoYHqSeSunsBFwC5CGQnSQWNAHac3RN81YurckoaNRYxulESquWIgXbiWcUpa/liBzXw5EElKWrI6o4H1IKpRBITQRup3gEc2OT5DDfrwoc98qRCABxVP5Ow7PTBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dmemsg3oc9tarM13UdrTY6aylQVP48K/ZKOY8PdXhuk=;
 b=maeOGd7sLqPr1Xh9ZwXUmCPoWvW0XwAaLrzTELwnZfH+QY7J/a/XKTfuPovVp3Icq4S6+s2gfT1fPHgmodby27olRv/ruX8IP77I544gIIlB70aZbWmnxsxcrQt7Z/f5TS/pYRINVPfe4z7qgTdCmLMs+jBbtvcQ7WKfxMN7DP/UDL9VZVpkNypBXHVMnmxGMbWRE5fhppZWUrB3DY5gcoGDoAqYb4cM/3ZTr+v7CqWkXdF1bAunpguLY3e6XnIh3w7EvZVE/2b5c0PgPS96IuUH9yGzdRbV0lbjExmCHNiUsP79Su8I7iuokDIyS4tVP35NPdwZZPgEfBnAAND1bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5063.namprd15.prod.outlook.com (2603:10b6:806:1de::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Tue, 7 Dec
 2021 04:32:06 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%4]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 04:32:06 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH bpf-next] perf/bpf_counter: use bpf_map_create instead of
 bpf_create_map
Thread-Topic: [PATCH bpf-next] perf/bpf_counter: use bpf_map_create instead of
 bpf_create_map
Thread-Index: AQHX6vYzhWKFIoT0wkePQg16MtlXfawmUPOAgAAf5QA=
Date:   Tue, 7 Dec 2021 04:32:06 +0000
Message-ID: <3221CDA7-F2EF-404A-9289-14F9DF6D01DA@fb.com>
References: <20211206230811.4131230-1-song@kernel.org>
 <CAEf4BzbaBcySm3bVumBTrkHMmVDWEVxckdVKvUk=4j9HhSsmBA@mail.gmail.com>
In-Reply-To: <CAEf4BzbaBcySm3bVumBTrkHMmVDWEVxckdVKvUk=4j9HhSsmBA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d4f203e-797f-4cae-a038-08d9b93a864c
x-ms-traffictypediagnostic: SA1PR15MB5063:EE_
x-microsoft-antispam-prvs: <SA1PR15MB506311F9D4EA8FE070FADDF9B36E9@SA1PR15MB5063.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dyl4UCE6w2vJzfKou3LBTnqZ2W/xSDZ9XvSRMBWuO9SP5m83AOm3slCgLMvURRFtrHniBAC5bfOJyyRsDkxFTA4COVtcJVkkOGhn4dn8oLquM7kuKpV0iQlqtDNaxtOt0BJXfd5jMv8rdQcF0SbgpzhEI+TPbktDvpru3rRKay0SrXVbFbd02sa/cCk+GJUmDy3PqnX08BMHu+IQJMAKAuNLz0BDrTnCefdSVs/7eQCFmG45R49/uf+Uq6jnfXjdYi8wfNxuY8zaL1uQRtJC/cS4wO9vUwU6hrVU04wI7RRweUpMC7hc+QQM/OoMV0+caaaAiTPz2qkhSJzghWZq7XBnB0mXpHS2ezrN0+6oUKTCy/7eZ9B+9whbWDtTNrGej+cydX/4F/hlmtrKoSt1eP4oVJsoZVXgN5Z//2P/pPzahHjT3aw1RFr9/ELcfFOeqrt3w/y5Q0+F5IrsQHnqvUrOsZ2DHetjcZSwn3c6xQ3MGjNytPJ+JOVBvNw5Nq+6afSW24NfIYAy66vddUBGgv8waZCTG0qbOmv+XezePdlA+bNtysmxLjAn5H2MIPszbHG3dyzr0UVxnXbQn0px2nMUN6Zb5wXb9Axe0ZCYv2wIP8Vc3KspIt1+6DGMovT9X36AygHVRQijlSF92GmfZ6c/8uiOCBYifIcqalJUaMZYXbAUAB1fGkkbg3En3Q9HQ+E6ubNRIqJJHCKTuvlNQTdIarlJwOHBDyPbDbmZDN1dr/B4cTh0rhfrSTjEvH6E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(83380400001)(4326008)(508600001)(53546011)(33656002)(186003)(54906003)(316002)(2616005)(6506007)(8676002)(71200400001)(38100700002)(6512007)(36756003)(8936002)(5660300002)(6486002)(38070700005)(76116006)(66556008)(64756008)(66946007)(6916009)(66446008)(91956017)(66476007)(122000001)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHFxK0lDRHRoUWNEMnBmMkFmYnpmMHdFVWpoNTVFL0QxWGYzbWtGTnNBRGN4?=
 =?utf-8?B?ZUpOYXJYc0dDQ1ZUSUV1dTZqdjhzVUhqYVNXdUlHTC9RM3dSMnZMa3Y4OHdi?=
 =?utf-8?B?QkJEOUUvVnNIWmZ2K21UK1MwbUVuL0FGSWw4ZFY5cmJ6T3pUS2p6amhBTEFr?=
 =?utf-8?B?TjNNNWN3U1FpNU1Jd0E5dXNSV3JDQTJlWU54SnJ2ME9wN2lhdUJ5R0JLVm56?=
 =?utf-8?B?YkQ4R20xT0ZjVkJpUEZ2MFNxSkdMVDRvejdVYU41L0NyMVVnMjVSNWFjb3R5?=
 =?utf-8?B?aXJXMHZ6d2dJLzA5RU5mY2lqcW83K3NWdkV1R2NLWWo0aUVnYmdmOEx4a25S?=
 =?utf-8?B?NGV4MFREbTZ5UXIveng0SjZWZWhKSDUxdWV4YjFXUXVTaUxsRmxyU1JvelF5?=
 =?utf-8?B?NU5MZURhaGdBd0JWb1dSaUZnU1J4ZW1GTGtiMmhSODRlalQ4UTI5d3hWTW5k?=
 =?utf-8?B?OXpMT2NpYThaZnhlL01QcTE2M3hPcVhCZG1tdjZRb2xtTm5wKzBWME1QZHNJ?=
 =?utf-8?B?QWdSaVpTRDFYQS81d1NlS2JaaWdGa1RRYTV4MWk0QVpiNFM3b2JYWTlPWkZD?=
 =?utf-8?B?eTdCTDdiZUlDc2UvV05GSTJaV093cW8zdnBUejA4eHZKeGdWajBDaDNkUHAx?=
 =?utf-8?B?YWx1VHVVeC9ISTQ3b0NUdmwyamhOeGFrOXRNdEdHaFhmMzZ1WjliZld3R1ZF?=
 =?utf-8?B?Q3hhOU83aXhwUXZFemg0eWRrQ2dobnVFNnRWOS8vcWlXQ3NZdVNUSVQ0REpK?=
 =?utf-8?B?bXI5L3B3RWF6QkNIaWo4Z2JJemYwNGJFYXZwS3lmYVc5U3VyV2pLSmdpaHBS?=
 =?utf-8?B?dElOamgxWStuZ29lNW5mb2VwamZvbE56UHFJQk4wbTllNW45TU5adVFzODlX?=
 =?utf-8?B?QmtJQnRueWZpOWV0UDVmU1Z1Q3JaZHFuaVpTVDFZOEtTWmVjaGtHVUYxMU9Q?=
 =?utf-8?B?czBHcXNMWks0dkJFdjFycVNEaFZhN3NFWTdBSDJjM2FJZk5uRTVnOGQwdWdi?=
 =?utf-8?B?eE82QkR1V1BXRUlMYzRJSWl2TFFoZjdNcjloUmUvekdOd2pTVEE0YzQ4d1lO?=
 =?utf-8?B?Y0VFWHRvcEFXZzl6dlY0TGRRNFFYQmNQdkdWT2tpQk9GazJ3YkpJRnhQTVBI?=
 =?utf-8?B?UDkzeG8xWVdDanQxd1lMeU5OUXFzYkFSSFZDMDhjOGVVTlNMNzliNW9hemp5?=
 =?utf-8?B?TDlKMk1taDY5eFFBVHY1eFo2VjlhTHNoeUN1QVg3ck1EbWxiWjU5RE9uUExl?=
 =?utf-8?B?ZndFa3R2UkNobW9MbHhFZ2l5SHVnUTNmVGtuWWhUT2lhQ0FVZm03SlBEeW9j?=
 =?utf-8?B?L2Z3VnVZLzNSWFF6RVJTOWJtZXAwYmxJK1ZSMXFHb2dHR0VaUzVTRmY3S2VO?=
 =?utf-8?B?aiswNU5GbFVPeEJUMFRpdVFuTjVWNUF3TnIyOVBteWZJTUdaWDZScXVaL0Zl?=
 =?utf-8?B?ZlJYbDFNZ2NoRndqeDZaV29KRFR0NXBBZmtUWlNLZ0NJa0M5ZjRWWVVmclov?=
 =?utf-8?B?MjJwTW50YkN0WVFwQUhLTTN1S1dJdmx1S082ckpRWUcrMEd0V3lPNE9rSGUv?=
 =?utf-8?B?MXBDdVh3ZEFSaHRKc0VFaDFMeGpHU01RRWI5UGw4Q0F3RmFIOFBJTHJ2TXFi?=
 =?utf-8?B?ckp5UG80OUgvSHJLbktieGdGa1NpSDZvenlPYmhEVWIwNlpnTTdTdmFZR085?=
 =?utf-8?B?T1p0MHl5SVJKSmp0cE5IYU9ndFFOeFIwSWdxRDRyQkl2TEdXU2RmMEt4N01r?=
 =?utf-8?B?REttNlIzdEtxUUtwbG1vUUpDd3hlc2VpNy9ER1RvUnNrUHVqTElZSWtGbTc2?=
 =?utf-8?B?YmtQYmZCQUZ1NnJaYkh0NzdPWUhGbzlVTGNOQVFMclBiY2VMc3hVb21zZHF2?=
 =?utf-8?B?Y2lHUlJqRWhZOHF2MnE5YUlhdmJ1ZlpnWEhYZktBOENzV3BrWjV2Mml3a3lU?=
 =?utf-8?B?RFdKczRpTVl4aE40M3UzOWJFcno3N3p5TWJEbmFZYXFSRXM5RnprSFhvcE42?=
 =?utf-8?B?Y0xtOVpjc1AyajNBZXVIQkprdDY5L05sWlhRa2JhRDBMZVVndnJBK1loTmtL?=
 =?utf-8?B?eHBld3QzVjhQay9MOXE1RURQYnBGcnRHSW9haktLYU1KTHVQT3pxd3FFRkJS?=
 =?utf-8?B?RjY5UDdIMDlON204NktRREY2K3JZYXVtb0xTWFl4UERIYS9TVyt3ZlBCNWFs?=
 =?utf-8?B?TnBJMEFXdHk4SDVmV2w4cWNvaXpza0ZRR0hhblFMMWJPa0o4Y01lOFIxc3Mv?=
 =?utf-8?B?MjZaaHNtc2JwS3VSMnNpZUxIUktnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <51A383B3EC3CBA49AC1525406CFFF860@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d4f203e-797f-4cae-a038-08d9b93a864c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 04:32:06.0542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aT1WxGvmQ/IKYA3qI7w+GqlWpOroGozuJjWOLcqBwhqDGtISktvtHn9Phq1jS02hC+szTO07sjXPmb49OoQm+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5063
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: sjtd6SMyUxKbnsoBYBMxSfGEFrTEhKOk
X-Proofpoint-GUID: sjtd6SMyUxKbnsoBYBMxSfGEFrTEhKOk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_01,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=999
 phishscore=0 suspectscore=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112070025
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gRGVjIDYsIDIwMjEsIGF0IDY6MzcgUE0sIEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlp
Lm5ha3J5aWtvQGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBNb24sIERlYyA2LCAyMDIxIGF0
IDM6MDggUE0gU29uZyBMaXUgPHNvbmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+PiANCj4+IGJwZl9j
cmVhdGVfbWFwIGlzIGRlcHJlY2F0ZWQuIFJlcGxhY2UgaXQgd2l0aCBicGZfbWFwX2NyZWF0ZS4N
Cj4+IA0KPj4gRml4ZXM6IDk5MmM0MjI1NDE5YSAoImxpYmJwZjogVW5pZnkgbG93LWxldmVsIG1h
cCBjcmVhdGlvbiBBUElzIHcvIG5ldyBicGZfbWFwX2NyZWF0ZSgpIikNCj4gDQo+IFRoaXMgaXMg
bm90IGEgYnVnIGZpeCwgaXQncyBhbiBpbXByb3ZlbWVudC4gU28gSSBkb24ndCB0aGluayAiRml4
ZXM6ICINCj4gaXMgd2FycmFudGVkIGhlcmUsIHRiaC4NCg0KSSBnb3QgY29tcGlsYXRpb24gZXJy
b3JzIGJlZm9yZSB0aGlzIGNoYW5nZSwgbGlrZQ0KDQp1dGlsL2JwZl9jb3VudGVyLmM6IEluIGZ1
bmN0aW9uIOKAmGJwZXJmX2xvY2tfYXR0cl9tYXDigJk6DQp1dGlsL2JwZl9jb3VudGVyLmM6MzIz
OjM6IGVycm9yOiDigJhicGZfY3JlYXRlX21hcOKAmSBpcyBkZXByZWNhdGVkOiBsaWJicGYgdjAu
Nys6IHVzZSBicGZfbWFwX2NyZWF0ZSgpIGluc3RlYWQgWy1XZXJyb3I9ZGVwcmVjYXRlZC1kZWNs
YXJhdGlvbnNdDQogICBtYXBfZmQgPSBicGZfY3JlYXRlX21hcChCUEZfTUFQX1RZUEVfSEFTSCwN
CiAgIF5+fn5+fg0KSW4gZmlsZSBpbmNsdWRlZCBmcm9tIHV0aWwvYnBmX2NvdW50ZXIuaDo3LA0K
ICAgICAgICAgICAgICAgICBmcm9tIHV0aWwvYnBmX2NvdW50ZXIuYzoxNToNCi9kYXRhL3VzZXJz
L3NvbmdsaXVicmF2aW5nL2tlcm5lbC9saW51eC1naXQvdG9vbHMvbGliL2JwZi9icGYuaDo5MTox
Njogbm90ZTogZGVjbGFyZWQgaGVyZQ0KIExJQkJQRl9BUEkgaW50IGJwZl9jcmVhdGVfbWFwKGVu
dW0gYnBmX21hcF90eXBlIG1hcF90eXBlLCBpbnQga2V5X3NpemUsDQogICAgICAgICAgICAgICAg
Xn5+fn5+fn5+fn5+fn4NCmNjMTogYWxsIHdhcm5pbmdzIGJlaW5nIHRyZWF0ZWQgYXMgZXJyb3Jz
DQptYWtlWzRdOiAqKiogWy9kYXRhL3VzZXJzL3NvbmdsaXVicmF2aW5nL2tlcm5lbC9saW51eC1n
aXQvdG9vbHMvYnVpbGQvTWFrZWZpbGUuYnVpbGQ6OTY6IHV0aWwvYnBmX2NvdW50ZXIub10gRXJy
b3IgMQ0KbWFrZVs0XTogKioqIFdhaXRpbmcgZm9yIHVuZmluaXNoZWQgam9icy4uLi4NCm1ha2Vb
M106ICoqKiBbL2RhdGEvdXNlcnMvc29uZ2xpdWJyYXZpbmcva2VybmVsL2xpbnV4LWdpdC90b29s
cy9idWlsZC9NYWtlZmlsZS5idWlsZDoxMzk6IHV0aWxdIEVycm9yIDINCm1ha2VbMl06ICoqKiBb
TWFrZWZpbGUucGVyZjo2NjU6IHBlcmYtaW4ub10gRXJyb3IgMg0KbWFrZVsxXTogKioqIFtNYWtl
ZmlsZS5wZXJmOjI0MDogc3ViLW1ha2VdIEVycm9yIDINCm1ha2U6ICoqKiBbTWFrZWZpbGU6NzA6
IGFsbF0gRXJyb3IgMg0KDQpEbyB3ZSBwbGFuIHRvIHJlbW92ZSBicGZfY3JlYXRlX21hcCBpbiB0
aGUgZnV0dXJlPyBJZiBub3QsIHdlIGNhbiBwcm9iYWJseSBqdXN0DQphZGQgJyNwcmFnbWEgR0ND
IGRpYWdub3N0aWMgaWdub3JlZCAiLVdkZXByZWNhdGVkLWRlY2xhcmF0aW9ucyInIGNhbiBjYWxs
IGl0IGRvbmU/IA0KDQo+IA0KPj4gU2lnbmVkLW9mZi1ieTogU29uZyBMaXUgPHNvbmdAa2VybmVs
Lm9yZz4NCj4+IC0tLQ0KPj4gdG9vbHMvcGVyZi91dGlsL2JwZl9jb3VudGVyLmMgfCA0ICsrLS0N
Cj4+IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+PiAN
Cj4+IGRpZmYgLS1naXQgYS90b29scy9wZXJmL3V0aWwvYnBmX2NvdW50ZXIuYyBiL3Rvb2xzL3Bl
cmYvdXRpbC9icGZfY291bnRlci5jDQo+PiBpbmRleCBjMTdkNGE0M2NlMDY1Li5lZDE1MGE5YjNh
MGMwIDEwMDY0NA0KPj4gLS0tIGEvdG9vbHMvcGVyZi91dGlsL2JwZl9jb3VudGVyLmMNCj4+ICsr
KyBiL3Rvb2xzL3BlcmYvdXRpbC9icGZfY291bnRlci5jDQo+PiBAQCAtMzIwLDEwICszMjAsMTAg
QEAgc3RhdGljIGludCBicGVyZl9sb2NrX2F0dHJfbWFwKHN0cnVjdCB0YXJnZXQgKnRhcmdldCkN
Cj4+ICAgICAgICB9DQo+PiANCj4+ICAgICAgICBpZiAoYWNjZXNzKHBhdGgsIEZfT0spKSB7DQo+
PiAtICAgICAgICAgICAgICAgbWFwX2ZkID0gYnBmX2NyZWF0ZV9tYXAoQlBGX01BUF9UWVBFX0hB
U0gsDQo+PiArICAgICAgICAgICAgICAgbWFwX2ZkID0gYnBmX21hcF9jcmVhdGUoQlBGX01BUF9U
WVBFX0hBU0gsIE5VTEwsDQo+IA0KPiBJIHRoaW5rIHBlcmYgaXMgdHJ5aW5nIHRvIGJlIGxpbmth
YmxlIHdpdGggbGliYnBmIGFzIGEgc2hhcmVkIGxpYnJhcnksDQo+IHNvIG9uIHNvbWUgb2xkZXIg
dmVyc2lvbnMgb2YgbGliYnBmIGJwZl9tYXBfY3JlYXRlKCkgd29uJ3QgYmUgKHlldCkNCj4gYXZh
aWxhYmxlLiBTbyB0byBtYWtlIHRoaXMgd29yaywgSSB0aGluayB5b3UnbGwgbmVlZCB0byBkZWZp
bmUgeW91cg0KPiBvd24gd2VhayBicGZfbWFwX2NyZWF0ZSBmdW5jdGlvbiB0aGF0IHdpbGwgdXNl
IGJwZl9jcmVhdGVfbWFwKCkuDQoNCkhtbS4uLiBJIGRpZG4ndCBrbm93IHRoZSBwbGFuIHRvIGxp
bmsgbGliYnBmIGFzIHNoYXJlZCBsaWJyYXJ5LiBJbiB0aGlzIGNhc2UsIA0KbWF5YmUgdGhlICNw
cmFnbWEgc29sdXRpb24gaXMgcHJlZmVycmVkPyANCg0KVGhhbmtzLA0KU29uZw0KDQo=
