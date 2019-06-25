Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA9052005
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbfFYAkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:40:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44432 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727283AbfFYAke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 20:40:34 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5P0dikx011430;
        Mon, 24 Jun 2019 17:40:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=gM1JSPTb/LMcMxYIfLZ1YytAbxUMo/MjHgSgMZI7o2I=;
 b=EKDuHOzoRLA/7HH9Cwd1WXiv5E27d0tKzLdETqbrbBDV9c911Tnx4IbU6aRoVMwJxz09
 hdoHvjeJrkpDCAgMnZIrh3JEa3ldP76wevM6VjnDzYE/GlUSGUXkfgqFlUH3p0TFJWDc
 tUk1cCLhmqlrE4YYl2w4b+2/22YrSgzFI8k= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tawbtatmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 17:40:11 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 24 Jun 2019 17:40:10 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 24 Jun 2019 17:40:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gM1JSPTb/LMcMxYIfLZ1YytAbxUMo/MjHgSgMZI7o2I=;
 b=dVNGAZcC0wPANKR0ujy06MZwbYQZkSXh9A4cM+I+dgirkHw3JaRw/u7DkpIm2U//9NNXzA2tLkDtGI9hDBBHt7aMuXopNVDN/SSsYDFhnNayfhydjKFzHdOwo19EhlvVEu42aDXQlO1mzlYNwEUHeb2gbt0FhI97sBWuvBcyQv8=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2535.namprd15.prod.outlook.com (20.179.154.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 00:40:09 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702%7]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 00:40:09 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Andrey Ignatov <rdna@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Takshak Chahande <ctakshak@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Thread-Topic: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Thread-Index: AQHVKIFy6hPwND0Mwky2apMHopnX+aaq33qAgAB9YoCAAAbxAIAAB5SAgAAPW4CAAArHgIAAAXUAgAACSYCAAALNAA==
Date:   Tue, 25 Jun 2019 00:40:09 +0000
Message-ID: <01c2c76b-5a45-aab0-e698-b5a66ab6c2e7@fb.com>
References: <20190621223311.1380295-1-ctakshak@fb.com>
 <6fe292ee-fff0-119c-8524-e25783901167@iogearbox.net>
 <20190624145111.49176d8e@cakuba.netronome.com>
 <20190624221558.GA41600@rdna-mbp.dhcp.thefacebook.com>
 <20190624154309.5ef3357b@cakuba.netronome.com>
 <97b13eb6-43fb-8ee9-117d-a68f9825b866@fb.com>
 <20190624171641.73cd197d@cakuba.netronome.com>
 <6d44d265-7133-d191-beeb-c22dde73993f@fb.com>
 <20190624173005.06430163@cakuba.netronome.com>
In-Reply-To: <20190624173005.06430163@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0172.namprd04.prod.outlook.com
 (2603:10b6:104:4::26) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:d5ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc101ac3-0317-49f6-c946-08d6f905ad18
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2535;
x-ms-traffictypediagnostic: BYAPR15MB2535:
x-microsoft-antispam-prvs: <BYAPR15MB2535AC3A3024F0EAAE3B02C9D7E30@BYAPR15MB2535.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(396003)(366004)(346002)(39860400002)(189003)(199004)(5660300002)(36756003)(66556008)(66446008)(6916009)(73956011)(66946007)(66476007)(64756008)(478600001)(76176011)(14454004)(386003)(186003)(6506007)(102836004)(53546011)(25786009)(4326008)(99286004)(2906002)(52116002)(31686004)(54906003)(316002)(8936002)(68736007)(53936002)(6246003)(7736002)(305945005)(6512007)(81166006)(8676002)(81156014)(6486002)(229853002)(6436002)(6116002)(2616005)(446003)(11346002)(46003)(476003)(86362001)(486006)(71190400001)(71200400001)(256004)(31696002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2535;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QOpIrraKKO1ZLF0k6Tzu9/0Jw1enlaljmcnAxe3hhc6/wlORv0jK2HNn9C28FaSt8R29vn9r1qiNAp7E0gM/oAWKG/UOkyNo/DClBYZFmp38sccB8ajciTHk38VbqLqRuk1YklbIG1jHbpYOeatiOxCSCAxcCdMTrGIVIyKZUdwy5ObwWeXYJxaKAtM9Ooap9HL837PaDD2GmdTICGGOErdH1qJvnl9moj6hgPPZPX8LA+DNoVGpZMQuWciudFZ6eJigAGbLZWGYFFJbDi3tGMrzSOZ2/qU3tpgmrtY57B4BGrkHfWhe6bQ9ZFBdr7JKemUNr2qDHHpIfdiJsFIl3t+FsFVse1qo0SVmMBsBNgOjrJZKSnaZctTWzvZgtjTYeyMMPCr2dK6uUDIJx9ULK1qpYh8CgMH6GfNk1Snymps=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AC1FE662EA04D408253310273FC9B54@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dc101ac3-0317-49f6-c946-08d6f905ad18
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 00:40:09.6817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2535
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=752 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8yNC8xOSA1OjMwIFBNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gVHVlLCAyNSBK
dW4gMjAxOSAwMDoyMTo1NyArMDAwMCwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPj4gT24g
Ni8yNC8xOSA1OjE2IFBNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4+PiBPbiBNb24sIDI0IEp1
biAyMDE5IDIzOjM4OjExICswMDAwLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+Pj4+IEkg
ZG9uJ3QgdGhpbmsgdGhpcyBwYXRjaCBzaG91bGQgYmUgcGVuYWxpemVkLg0KPj4+PiBJJ2QgcmF0
aGVyIHNlZSB3ZSBmaXggdGhlbSBhbGwuDQo+Pj4NCj4+PiBTbyB3ZSBhcmUgZ29pbmcgdG8gYWRk
IHRoaXMgYnJva2VuIG9wdGlvbiBqdXN0IHRvIHJlbW92ZSBpdD8NCj4+PiBJIGRvbid0IHVuZGVy
c3RhbmQuDQo+Pj4gSSdtIGhhcHB5IHRvIHNwZW5kIHRoZSAxNSBtaW51dGVzIHJld3JpdGluZyB0
aGlzIGlmIHlvdSBkb24ndA0KPj4+IHdhbnQgdG8gcGVuYWxpemUgVGFrc2hhay4NCj4+DQo+PiBo
bW0uIEkgZG9uJ3QgdW5kZXJzdGFuZCB0aGUgJ2Jyb2tlbicgcGFydC4NCj4+IFRoZSBvbmx5IGlz
c3VlIEkgc2VlIHRoYXQgaXQgY291bGQgaGF2ZSBiZWVuIGxvY2FsIHZzIGdsb2JhbCwNCj4+IGJ1
dCB0aGV5IGFsbCBzaG91bGQgaGF2ZSBiZWVuIGxvY2FsLg0KPiANCj4gSSBkb24ndCB0aGluayBh
bGwgb2YgdGhlbS4gIE9ubHkgLS1tYXBjb21wYXQgYW5kIC0tYnBmZnMuICBicGZmcyBjb3VsZA0K
PiBiZSBhcmd1ZWQuICBPbiBtYXBjb21wYXQgSSBtdXN0IGhhdmUgbm90IHJlYWQgdGhlIHBhdGNo
IGZ1bGx5LCBJIHdhcw0KPiB1bmRlciB0aGUgaW1wcmVzc2lvbiBpdHMgYSBnbG9iYWwgbGliYnBm
IGZsYWcgOigNCj4gDQo+IC0tanNvbiwgLS1wcmV0dHksIC0tbm9tb3VudCwgLS1kZWJ1ZyBhcmUg
Z2xvYmFsIGJlY2F1c2UgdGhleSBhZmZlY3QNCj4gZ2xvYmFsIGJlaGF2aW91ciBvZiBicGZ0b29s
LiAgVGhlIGRpZmZlcmVuY2UgaGVyZSBpcyB0aGF0IHdlIGJhc2ljYWxseQ0KPiBhZGQgYSBzeXNj
YWxsIHBhcmFtZXRlciBhcyBhIGdsb2JhbCBvcHRpb24uDQoNCnN1cmUuIEkgb25seSBkaXNhZ3Jl
ZWQgYWJvdXQgbm90IHRvdWNoaW5nIG9sZGVyIGZsYWdzLg0KLS1lZmZlY3RpdmUgc2hvdWxkIGJl
IGxvY2FsLg0KSWYgZm9sbG93IHVwIHBhdGNoIG1lYW5zIDkwJSByZXdyaXRlIHRoZW4gcmV2ZXJ0
IGlzIGJldHRlci4NCklmIGl0J3MgMTAlIGZpeHVwIHRoZW4gaXQncyBkaWZmZXJlbnQgc3Rvcnku
DQoNClRha3NoYWssDQpjb3VsZCB5b3UgY2hlY2sgd2hpY2ggd2F5IGlzIGNsZWFuZXI/IFJldmVy
dCBhbmQgbmV3IHBhdGNoIG9yIGZvbGxvdyB1cCBmaXg/DQpCdXQgYnBmdG9vbCBkb2Vzbid0IGhh
dmUgYSB3YXkgdG8gZG8gbG9jYWwsIG5vPw0Kc28gaXQncyBraW5kYSBuZXcgZmVhdHVyZSBhbmQg
b3RoZXIgZmxhZ3Mgc2hvdWxkIGJlY29tZSBsb2NhbCB0b28uDQpoZW5jZSBpdCBmZWVscyBtb3Jl
IGxpa2UgZm9sbG93IHVwLiBKdXN0IG15IC4wMg0K
