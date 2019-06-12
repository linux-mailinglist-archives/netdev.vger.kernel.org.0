Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB9D448C7
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbfFMRLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:11:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55324 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729146AbfFLW0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 18:26:14 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5CMMKWq028243;
        Wed, 12 Jun 2019 15:25:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=z6e94y2YKHB2Dvm/K1xCHvzcpjbT1SzWkvI7+DHVtnI=;
 b=KhGDukNgBSvrCF2uMMOxlUbGa5NCIepHkz1P4PmOWMSZmt7fGqpSXVrs81eox7A6P310
 rMz6CIpVCE8u7qwkD7KcgvAsxpBZFuISfF4Ljj/1osMBpTSjdAgxhKkRZhRGiUS1UsYA
 d8lO9LOT9yEBTo7vHGUOKM9OVzogbXRrhpw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2t356215ah-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Jun 2019 15:25:51 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 12 Jun 2019 15:25:49 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 12 Jun 2019 15:25:49 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 12 Jun 2019 15:25:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6e94y2YKHB2Dvm/K1xCHvzcpjbT1SzWkvI7+DHVtnI=;
 b=X4mwPTsrUQ3GcwMu9LYEOoDQVvuN3+T0l0DEbIp9mzdNgHArp4uNrsJu8GCJtPWRyx6xol7LwJK1CBNcSMSaGkTYydRHnEvE5K5ug9b0NYlHGB/qvHY5dbDmHKfvDbe7XB2a8axv6ddJx98C7E3oI19VwuqJfo78y9xmvc17/Ug=
Received: from SN6PR15MB2512.namprd15.prod.outlook.com (52.135.66.25) by
 SN6PR15MB2271.namprd15.prod.outlook.com (52.135.65.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 12 Jun 2019 22:25:47 +0000
Received: from SN6PR15MB2512.namprd15.prod.outlook.com
 ([fe80::6077:6c8d:6f63:6494]) by SN6PR15MB2512.namprd15.prod.outlook.com
 ([fe80::6077:6c8d:6f63:6494%5]) with mapi id 15.20.1965.017; Wed, 12 Jun 2019
 22:25:47 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Martin Lau <kafai@fb.com>
CC:     Stanislav Fomichev <sdf@fomichev.me>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: Add test for SO_REUSEPORT_DETACH_BPF
Thread-Topic: [PATCH bpf-next 2/2] bpf: Add test for SO_REUSEPORT_DETACH_BPF
Thread-Index: AQHVIVHaEYjyGQrSF0mXM1zpnaQpr6aYb/6AgAAZkQCAAATLgP//jDcAgAB7lgCAAALBAA==
Date:   Wed, 12 Jun 2019 22:25:47 +0000
Message-ID: <64cf5b03-bb3e-ee4d-932e-46433bd0ecdb@fb.com>
References: <20190612190536.2340077-1-kafai@fb.com>
 <20190612190539.2340343-1-kafai@fb.com> <20190612195917.GB9056@mini-arch>
 <20190612213046.e7tkduk5nfuv5s6a@kafai-mbp.dhcp.thefacebook.com>
 <20190612214757.GC9056@mini-arch>
 <3045141f-298c-59ae-41a7-d8bc79048786@fb.com>
 <20190612221549.7rmv56yjg7a64zad@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190612221549.7rmv56yjg7a64zad@kafai-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0014.namprd08.prod.outlook.com
 (2603:10b6:a03:100::27) To SN6PR15MB2512.namprd15.prod.outlook.com
 (2603:10b6:805:25::25)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:70be]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9faee9e-236e-4d43-b3f8-08d6ef84eaa9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN6PR15MB2271;
x-ms-traffictypediagnostic: SN6PR15MB2271:
x-microsoft-antispam-prvs: <SN6PR15MB2271DE0AD649FD403E797F93D7EC0@SN6PR15MB2271.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(39860400002)(396003)(136003)(366004)(189003)(199004)(11346002)(53546011)(446003)(54906003)(476003)(53936002)(99286004)(46003)(52116002)(37006003)(2616005)(486006)(386003)(66946007)(4326008)(6246003)(14454004)(6862004)(6116002)(66476007)(73956011)(66556008)(76176011)(316002)(66446008)(25786009)(64756008)(68736007)(6512007)(31686004)(478600001)(71200400001)(6636002)(71190400001)(2906002)(6436002)(256004)(229853002)(102836004)(6486002)(186003)(8936002)(14444005)(86362001)(5660300002)(305945005)(81166006)(81156014)(36756003)(8676002)(31696002)(7736002)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR15MB2271;H:SN6PR15MB2512.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UH96DSUIn2AEA2h3QhXTUF4SilacTK166vDq2tIxb/EUxkf0CNl0QkC8GQgg5hOZQ3rBVVSgutgGs/Ie1EqIl013q/VQU0172sPTFKfcDWdEkSVpZWlewVN7WudNj0um/amR6l5WdKMP93UEjiorL5Q4rtet8TR8vWBzEGGy9ufz5gJgILFMcQv6FDu0+I0ju/yXdGQoySDsnH8X/kFBk7A+z7Z8yELyqixNPegiX7cCrz6z6yBB98RUMRUapdkBhVAFbRoIYNi1Ltvy/GTdFEGeYIlRUMBG4RCi9UtyGbj4DsL5fFMmIREUp2GvAsVLAy4gQILZ9fdxbJR6l41RvKK3VCdKZ6dfslXkGiyKAmvD3qyMHdA7yleQD5ZYJ7BfaUrzLO7C0KmQFpWeowEW3yfOM4rbkEni6DVca/wKZos=
Content-Type: text/plain; charset="utf-8"
Content-ID: <57D72ADA43835D47A1C8F3B93868D8E4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d9faee9e-236e-4d43-b3f8-08d6ef84eaa9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 22:25:47.5343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2271
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=728 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8xMi8xOSAzOjE1IFBNLCBNYXJ0aW4gTGF1IHdyb3RlOg0KPiBPbiBXZWQsIEp1biAxMiwg
MjAxOSBhdCAwMjo1MzozNVBNIC0wNzAwLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+PiBP
biA2LzEyLzE5IDI6NDcgUE0sIFN0YW5pc2xhdiBGb21pY2hldiB3cm90ZToNCj4+Pj4+PiBDRkxB
R1MgKz0gLVdhbGwgLU8yIC1JJChBUElESVIpIC1JJChMSUJESVIpIC1JJChCUEZESVIpIC1JJChH
RU5ESVIpICQoR0VORkxBR1MpIC1JLi4vLi4vLi4vaW5jbHVkZSBcDQo+Pj4+Pj4gKwkgIC1JLi4v
Li4vLi4vLi4vdXNyL2luY2x1ZGUvICBcDQo+Pj4+PiBXaHkgbm90IGNvcHkgaW5sdWRlL3VhcGkv
YXNtLWdlbmVyaWMvc29ja2V0LmggaW50byB0b29scy9pbmNsdWRlDQo+Pj4+PiBpbnN0ZWFkPyBX
aWxsIHRoYXQgd29yaz8NCj4+Pj4gU3VyZS4gSSBhbSBvayB3aXRoIGNvcHkuICBJIGRvbid0IHRo
aW5rIHdlIG5lZWQgdG8gc3luYyB2ZXJ5IG9mdGVuLg0KPj4+PiBEbyB5b3Uga25vdyBob3cgdG8g
ZG8gdGhhdCBjb25zaWRlcmluZyBtdWx0aXBsZSBhcmNoJ3Mgc29ja2V0LmgNCj4+Pj4gaGF2ZSBi
ZWVuIGNoYW5nZWQgaW4gUGF0Y2ggMT8NCj4+PiBObywgSSBkb24ndCBrbm93IGhvdyB0byBoYW5k
bGUgYXJjaCBzcGVjaWZpYyBzdHVmZi4gSSBzdWdnZXN0IHRvIGNvcHkNCj4+PiBhc20tZ2VuZXJp
YyBhbmQgaGF2ZSBpZmRlZnMgaW4gdGhlIHRlc3RzIGlmIHNvbWVvbmUgY29tcGxhaW5zOi0pDQo+
IEl0IGlzIG5vdCB2ZXJ5IG5pY2UgYnV0IEkgYW0gb2sgd2l0aCB0aGF0IGFsc28uICBJdCBpcyB0
aGUgb25seQ0KPiBhcmNoIEkgY2FuIHRlc3QgOykNCj4gDQo+Pj4NCj4+Pj4gSXMgY29weSBiZXR0
ZXI/DQo+Pj4gRG9lc24ndCAuLi8uLi8uLi8uLi91c3IvaW5jbHVkZSBwcm92aWRlIHRoZSBzYW1l
IGhlYWRlcnMgd2UgaGF2ZSBpbg0KPj4+IHRvb2xzL2luY2x1ZGUvdWFwaT8gSWYgeW91IGFkZCAt
SS4uLy4uLy4uLy4uL3Vzci9pbmNsdWRlLCB0aGVuIGlzIHRoZXJlDQo+Pj4gYSBwb2ludCBvZiBo
YXZpbmcgY29waWVzIHVuZGVyIHRvb2xzL2luY2x1ZGUvdWFwaT8gSSBkb24ndCByZWFsbHkNCj4+
PiBrbm93IHdoeSB3ZSBrZWVwIHRoZSBjb3BpZXMgdW5kZXIgdG9vbHMvaW5jbHVkZS91YXBpIHJh
dGhlciB0aGFuIGluY2x1ZGluZw0KPj4+IC4uLy4uLy4uL3Vzci9pbmNsdWRlIGRpcmVjdGx5Lg0K
Pj4NCj4+IGZvciBvdXQtb2Ytc3JjIGJ1aWxkcyAuLi8uLi8uLi8uLi91c3IvaW5jbHVkZS8gZGly
ZWN0b3J5IGRvZXNuJ3QgZXhpc3QuDQo+IElzIG91dC1vZi1zcmMgYnVpbGQgbW9zdGx5IGZvciBs
aWJicGY/DQo+IG9yIHNlbGZ0ZXN0cy9icGYgYWxzbyByZXF1aXJlcyBvdXQtb2Ytc3JjIGJ1aWxk
Pw0KDQpvdXQtb2Ytc3JjIGZvciBrZXJuZWwuDQpJbiBteSBzZXR1cDoNCiQgcHdkIC1QDQouLi4u
L2JwZi1uZXh0L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZg0KJCBscyAuLi8uLi8uLi8uLi91
c3IvaW5jbHVkZS8NCmxzOiBjYW5ub3QgYWNjZXNzIC4uLy4uLy4uLy4uL3Vzci9pbmNsdWRlLzog
Tm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQ0KJCBscyAuLi8uLi8uLi8uLi9ibGRfeDY0L3Vzci9p
bmNsdWRlLw0KYXNtICBhc20tZ2VuZXJpYyAgZHJtICBsaW51eCAgbWlzYyAgbXRkICByZG1hICBz
Y3NpICBzb3VuZCAgdmlkZW8gIHhlbg0KDQoNCg==
