Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAC881370B
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 04:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfEDCgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 22:36:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50046 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726326AbfEDCgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 22:36:04 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x442QuKh010095;
        Fri, 3 May 2019 19:35:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=N/e7aIr7pOl4CTZRLuJdTWl01aQIzY0XwMPnpTmtVB0=;
 b=aqNTwgVjvn79Ex+2rcTzcJAhGA83APJdfE44rk8de7pXHcFW2wWWOwvA3q53PGkevJMp
 bADsxdhdqncTlEWrVbVCe9OUBKkqYtvHu+OKvG0q6UuPL+6rHjmRRCFDRgNjlFP00bKd
 HbsRDU2pH/j91JYbtBPdj6xbMYHnEEINHlY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2s8vwjgrty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 03 May 2019 19:35:43 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 3 May 2019 19:35:42 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 3 May 2019 19:35:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/e7aIr7pOl4CTZRLuJdTWl01aQIzY0XwMPnpTmtVB0=;
 b=IVu1Dr5EXezx2DYlV60Qqhhp+cUNVhoPKkSlrbNKS5QRnNAQYVIO3FqL0aYHYuaPbS2vignT+XmFLYP8M+tHwcRIe7S1NWwzfoulIdHtpmT+2fuUjyua6QuU/ijAhAFa/OGix3ZOCaqvZ3hxh6n5bKCbkO0dbtuyrYliIRfD7kE=
Received: from BYAPR15MB2311.namprd15.prod.outlook.com (52.135.197.145) by
 BYAPR15MB2760.namprd15.prod.outlook.com (20.179.157.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.12; Sat, 4 May 2019 02:35:41 +0000
Received: from BYAPR15MB2311.namprd15.prod.outlook.com
 ([fe80::d0cd:ad09:6bf5:7e06]) by BYAPR15MB2311.namprd15.prod.outlook.com
 ([fe80::d0cd:ad09:6bf5:7e06%6]) with mapi id 15.20.1856.012; Sat, 4 May 2019
 02:35:41 +0000
From:   Lawrence Brakmo <brakmo@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>
CC:     netdev <netdev@vger.kernel.org>, Martin Lau <kafai@fb.com>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH v2 bpf-next 5/7] bpf: sysctl for probe_on_drop
Thread-Topic: [PATCH v2 bpf-next 5/7] bpf: sysctl for probe_on_drop
Thread-Index: AQHU6ntMBPt++Bc1k02B9em4sME2AKYyd80AgAAOKYCAJ3PaAA==
Date:   Sat, 4 May 2019 02:35:40 +0000
Message-ID: <BAD306FE-4C97-49E8-9CB8-20891B0E8C0E@fb.com>
References: <20190404001250.140554-1-brakmo@fb.com>
 <20190404001250.140554-6-brakmo@fb.com>
 <CADVnQynFtNiQxsRNx7phxsxgSRXowFag1=qbw0WrHyWHOnZ7Lw@mail.gmail.com>
 <1c827078-f462-0bbd-e03d-1c3d07ec593b@gmail.com>
In-Reply-To: <1c827078-f462-0bbd-e03d-1c3d07ec593b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.18.0.190414
x-originating-ip: [2620:10d:c090:200::1:d434]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3661045-f2d3-434e-cc15-08d6d0393338
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2760;
x-ms-traffictypediagnostic: BYAPR15MB2760:
x-microsoft-antispam-prvs: <BYAPR15MB27608BD82011E6F07B28BC84A9360@BYAPR15MB2760.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0027ED21E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(346002)(136003)(376002)(396003)(189003)(199004)(11346002)(53546011)(486006)(66476007)(102836004)(6506007)(446003)(83716004)(186003)(6246003)(476003)(2616005)(64756008)(66556008)(110136005)(99286004)(66946007)(91956017)(66446008)(46003)(76116006)(73956011)(8936002)(58126008)(4326008)(25786009)(82746002)(6512007)(256004)(53936002)(7736002)(305945005)(316002)(54906003)(229853002)(68736007)(6116002)(14454004)(2906002)(33656002)(478600001)(6436002)(81156014)(8676002)(81166006)(71200400001)(71190400001)(86362001)(76176011)(36756003)(5660300002)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2760;H:BYAPR15MB2311.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HETKXL/xEfmFyRc6meBlsxnV12LKrN0UlIxpurquuFKsjrSDdBt5U4h0MAVTxmYRlUGTn4lsz3DScSdeww0G+6oVk0G8zlY3wswoOa83zqSgSStyFpN7/ssjUX7WRy0HqxOk/EeY597iIKntq0Fpt4KnMYif8fyt+5cU+FiH9MeZYuQhmAlznhPAVTmESS0vKKdyEqNQjKS7IHWV98ZQ/8235+nJteyJQouMGtcdQuTdyl4thwiHsxqyivB+gEkCMWlQ/d+5sm+htBc5MGewJOhuZNhGnhhBROFJA5AjdakMxbVZ0SXxh1pr13CSigJS0PeDpilFGawxZ0yBL3KPS5fJiyJev+H3O7awsB0cwJahUtZr8RzA2MQZqLfGTdUvhgNoS1BUpYyL6PcOrXL52ozM6tKlPg4slyUFHhe6P94=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66053F60667B6145B4C720927BFD7241@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f3661045-f2d3-434e-cc15-08d6d0393338
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2019 02:35:40.9396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2760
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-04_02:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDQvOC8xOSwgMTA6MDcgQU0sICJFcmljIER1bWF6ZXQiIDxlcmljLmR1bWF6ZXRA
Z21haWwuY29tPiB3cm90ZToNCg0KICAgIA0KICAgIA0KICAgIE9uIDA0LzA4LzIwMTkgMDk6MTYg
QU0sIE5lYWwgQ2FyZHdlbGwgd3JvdGU6DQogICAgPiBPbiBXZWQsIEFwciAzLCAyMDE5IGF0IDg6
MTMgUE0gYnJha21vIDxicmFrbW9AZmIuY29tPiB3cm90ZToNCiAgICA+Pg0KICAgID4+IFdoZW4g
YSBwYWNrZXQgaXMgZHJvcHBlZCB3aGVuIGNhbGxpbmcgcXVldWVfeG1pdCBpbiAgX190Y3BfdHJh
bnNtaXRfc2tiDQogICAgPj4gYW5kIHBhY2tldHNfb3V0IGlzIDAsIGl0IGlzIGJlbmVmaWNpYWwg
dG8gc2V0IGEgc21hbGwgcHJvYmUgdGltZXIuDQogICAgPj4gT3RoZXJ3aXNlLCB0aGUgdGhyb3Vn
aHB1dCBmb3IgdGhlIGZsb3cgY2FuIHN1ZmZlciBiZWNhdXNlIGl0IG1heSBuZWVkIHRvDQogICAg
Pj4gZGVwZW5kIG9uIHRoZSBwcm9iZSB0aW1lciB0byBzdGFydCBzZW5kaW5nIGFnYWluLiBUaGUg
ZGVmYXVsdCB2YWx1ZSBmb3INCiAgICA+PiB0aGUgcHJvYmUgdGltZXIgaXMgYXQgbGVhc3QgMjAw
bXMsIHRoaXMgcGF0Y2ggc2V0cyBpdCB0byAyMG1zIHdoZW4gYQ0KICAgID4+IHBhY2tldCBpcyBk
cm9wcGVkIGFuZCB0aGVyZSBhcmUgbm8gb3RoZXIgcGFja2V0cyBpbiBmbGlnaHQuDQogICAgPj4N
CiAgICA+PiBUaGlzIHBhdGNoIGludHJvZHVjZXMgYSBuZXcgc3lzY3RsLCBzeXNjdGxfdGNwX3By
b2JlX29uX2Ryb3BfbXMsIHRoYXQgaXMNCiAgICA+PiB1c2VkIHRvIHNwZWNpZnkgdGhlIGR1cmF0
aW9uIG9mIHRoZSBwcm9iZSB0aW1lciBmb3IgdGhlIGNhc2UgZGVzY3JpYmVkDQogICAgPj4gZWFy
bGllci4gVGhlIGFsbG93ZWQgdmFsdWVzIGFyZSBiZXR3ZWVuIDAgYW5kIFRDUF9SVE9fTUlOLiBB
IHZhbHVlIG9mIDANCiAgICA+PiBkaXNhYmxlcyBzZXR0aW5nIHRoZSBwcm9iZSB0aW1lciB3aXRo
IGEgc21hbGwgdmFsdWUuDQogICAgDQogICAgVGhpcyBzZWVtcyB0byBjb250cmFkaWN0IG91ciBy
ZWNlbnQgd29yayA/DQogICAgDQogICAgU2VlIHJlY2VudCBZdWNodW5nIHBhdGNoIHNlcmllcyA6
DQogICAgDQogICAgYzFkNTY3NGY4MzEzYjlmOGU2ODNjMjY1ZjFjMDBhMjU4MmNmNWZjNSB0Y3A6
IGxlc3MgYWdncmVzc2l2ZSB3aW5kb3cgcHJvYmluZyBvbiBsb2NhbCBjb25nZXN0aW9uDQogICAg
NTkwZDIwMjZkNjI0MThiYjI3ZGU5Y2E4NzUyNmU5MTMxYzFmNDhhZiB0Y3A6IHJldHJ5IG1vcmUg
Y29uc2VydmF0aXZlbHkgb24gbG9jYWwgY29uZ2VzdGlvbg0KICAgIDk3MjFlNzA5ZmE2OGVmOWI4
NjBjMzIyYjQ3NGNmYmQxZjgyODViMGYgdGNwOiBzaW1wbGlmeSB3aW5kb3cgcHJvYmUgYWJvcnRp
bmcgb24gVVNFUl9USU1FT1VUDQogICAgMDFhNTIzYjA3MTYxOGFiYmM2MzRkMTk1ODIyOWZlM2Jk
MmRmYTVmYSB0Y3A6IGNyZWF0ZSBhIGhlbHBlciB0byBtb2RlbCBleHBvbmVudGlhbCBiYWNrb2Zm
DQogICAgYzdkMTNjOGZhYTc0ZjRlOGVmMTkxZjg4YTI1MmNlZmFiNjgwNWIzOCB0Y3A6IHByb3Bl
cmx5IHRyYWNrIHJldHJ5IHRpbWUgb24gcGFzc2l2ZSBGYXN0IE9wZW4NCiAgICA3YWUxODk3NTlj
YzQ4Y2Y4YjU0YmVlYmZmNTY2ZTlmZDJkNGU3ZDdjIHRjcDogYWx3YXlzIHNldCByZXRyYW5zX3N0
YW1wIG9uIHJlY292ZXJ5DQogICAgN2YxMjQyMmM0ODczZTliMjc0YmMxNTFlYTU5Y2IwY2RmOTQx
NWNmMSB0Y3A6IGFsd2F5cyB0aW1lc3RhbXAgb24gZXZlcnkgc2tiIHRyYW5zbWlzc2lvbg0KICAg
IA0KVGhhbmsgeW91IGZvciBwb2ludGluZyB0aGlzIG91dC4gSSdtIHRha2luZyB0aGlzIHBhdGNo
IG91dCBvZiB0aGUgcGF0Y2hzZXQgYW5kIHdpbGwgcmVjb25zaWRlciBpdC4NCiAgICANCg0K
