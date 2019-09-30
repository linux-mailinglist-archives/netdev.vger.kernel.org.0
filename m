Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199B2C2587
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbfI3Q4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:56:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62330 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729022AbfI3Q4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 12:56:22 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8UGsCUo027963;
        Mon, 30 Sep 2019 09:56:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=A8UORBH6rJEbkTr12KKZEQIjQN/Y4Vy7JG5rVPqNuRo=;
 b=NhWp4T8HAIe2yPyaAThXnKaWiJok5YJzeUS8fIqipR4Ph2aHtxitJ2vwzMv077YlVNnd
 uHhYzuYjfEp2VJUs3M3OlJMx5SDtITFraE9cocB6l4wlq7Ej6A78mtPjWO47IYPsxm+X
 tFeE0yukONv6qUilABr5Wbyjw3c0DERjLCk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2va310stwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Sep 2019 09:56:08 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 30 Sep 2019 09:56:06 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 30 Sep 2019 09:56:06 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 30 Sep 2019 09:56:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6Tb/nlHXSPTWPW6Y+WIjSZTQHLmUE9o4fnjiuEkQqUKutWoXZbZLrIx4eJTL1vSV9c5bzMlifAI8BMNMjS9vV9xji3IWxPj95xwgDjNekbh+0nF99wMg+KwxFBDrWHLQOnUWKhM5X6dwALo4nkWNSKcdQrqqtOV8g2B+trkUiXNXtg4nw3ViimAQz5hTj+NFdjZxLOc5PfoFm5hI4aDVZCy69M82gprWeGU1+YEqH8ZRKlZLwCaLsArJgjSiJ6cauFkjUufyoK/kH0tRyAkPWWuiZQNSh+O0hIHhqNlhkevXPE5KE0PdLC6k68E2vNFcWQqX+7QGwkGT2kwmArsXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8UORBH6rJEbkTr12KKZEQIjQN/Y4Vy7JG5rVPqNuRo=;
 b=agc2agi3yFuM7Dp0J11QF2HI0QzpbAwngvq7dt43GFHP9YfW88f5wZ6XaSQB5Kq6cC+2+E2C3V4bL49kVHsHIHDcZfVVLHNNL67ji1D2iDBoPm+HzxgclnOmeUdhQxUQooaD9OVOMo4WAocHvZxCgNUNISRlWl7Czt2aFu1osRVVyAPpT11rIdzhuXXh5xhTXj7C046lcbNV7mmyef6axOLNLDjFjhiPfmEzRAxuWaR4EuSZsO+5g97ZN2qaccsz2K2zSggTGkQYgSDSmHhmbQeBe5rRsjbMu/IDHRFFUN9xofdCpydZ+XMeI2raBvRWAvkkxQmznYw8Iyo5zxiI1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8UORBH6rJEbkTr12KKZEQIjQN/Y4Vy7JG5rVPqNuRo=;
 b=eDnr8jiqCGaL9RtNQvTC07OVf04DPtaSyrUwb9rmOPvfHtFNSO50tpudxzRAdCikQxnWuTg/cPPR4A6bK5qplPF/6ys2olkxLMoKX+UKr1ttfDlFU2cSukfkMXsqL7rH/tDXT1w9SsCWUupP81pDC4hEO2YuOJ8C0pkHuOqBG/c=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2615.namprd15.prod.outlook.com (20.179.155.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Mon, 30 Sep 2019 16:56:05 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::7576:ddf9:dad2:1027]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::7576:ddf9:dad2:1027%7]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 16:56:05 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Kevin Laatz <kevin.laatz@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf v3] libbpf: handle symbol versioning properly for
 libbpf.a
Thread-Topic: [PATCH bpf v3] libbpf: handle symbol versioning properly for
 libbpf.a
Thread-Index: AQHVd64YLYIdRqSxu0GBXOXvzbZnyqdEcIUA
Date:   Mon, 30 Sep 2019 16:56:05 +0000
Message-ID: <a508b199-d6b9-26ee-a3f6-2012c9fdde37@fb.com>
References: <20190930162922.2169975-1-yhs@fb.com>
 <b23d1e1f-6912-33eb-e7d7-c1e47015cb4c@fb.com>
In-Reply-To: <b23d1e1f-6912-33eb-e7d7-c1e47015cb4c@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0032.namprd02.prod.outlook.com
 (2603:10b6:301:74::45) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:8503]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ef82cf8-a75f-4826-b70c-08d745c714ff
x-ms-traffictypediagnostic: BYAPR15MB2615:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB26154283FE9D0A1BD08AC446D3820@BYAPR15MB2615.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(31696002)(2501003)(6116002)(14454004)(229853002)(25786009)(86362001)(486006)(6486002)(446003)(31686004)(476003)(99286004)(46003)(6512007)(256004)(6436002)(11346002)(2616005)(71190400001)(71200400001)(2201001)(6246003)(5660300002)(110136005)(8936002)(4326008)(66446008)(186003)(54906003)(478600001)(64756008)(102836004)(52116002)(76176011)(66556008)(2906002)(305945005)(66476007)(66946007)(7736002)(81166006)(8676002)(6506007)(53546011)(386003)(316002)(81156014)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2615;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PMKAAHBTqm2q6maspdDVvPfk/gUNqCKFFWB92tmx03HS3dXaugm8iPS1UJEwhXjuPIJfgsl2U876dVgkiDreu/iiD0jXPVupdNbXlYPcKUEZ15yS76p4Lihb9rRC46IJBvSKqoapyCJ00SmIpQ4D/lsECs0vHlpIbseWRCGCKKjT58hzdH0grVAqOgfOEMEafEzyS/nqEYaGNjF/aRfGtCzabLcPmGhVVKhEnWulojo3lsc4Eyt9mPtNbHZhE+NdMgPV6EAmVnIOmAVHIv2OUzsJjRFRBefaR/sQzT119YtYWt2o4On8M1vi0D1XWBN1THIR70s4JIMm+R505oPocEKZZwL3y63ZT8OlK6XKd4GwU+0GrnmKHv3LfvPbO7iJA0ofcnWupoizRZgk7QphXv5BgLRLlG18EEyKL5SjPkE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E3468B355F90B478ECF1A62BAFA5E31@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ef82cf8-a75f-4826-b70c-08d745c714ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 16:56:05.1144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gIjCwcQAFuVpG9oMd7K4BcuJclDtQ41ixfkYBYnzO6EYgZO/Bgqd90BvvKqBp1h8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2615
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_10:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=899 malwarescore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMzAvMTkgOTo0MiBBTSwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPiBPbiA5
LzMwLzE5IDk6MjkgQU0sIFlvbmdob25nIFNvbmcgd3JvdGU6DQo+PiArT0xEX1ZFUlNJT04oeHNr
X3VtZW1fX2NyZWF0ZV92MF8wXzIsIHhza191bWVtX19jcmVhdGUsIExJQkJQRl8wLjAuMikNCj4+
ICtORVdfVkVSU0lPTih4c2tfdW1lbV9fY3JlYXRlX3YwXzBfNCwgeHNrX3VtZW1fX2NyZWF0ZSwg
TElCQlBGXzAuMC40KQ0KPiANCj4gaG93IHRoaXMgd2lsbCBsb29rIHdoZW4geWV0IGFub3RoZXIg
dmVyc2lvbiBvZiB0aGlzIGZ1bmN0aW9uIGlzDQo+IGludHJvZHVjZWQsIHNheSBpbiAwLjAuNiA/
DQo+IA0KPiBPTERfVkVSU0lPTih4c2tfdW1lbV9fY3JlYXRlX3YwXzBfMiwgeHNrX3VtZW1fX2Ny
ZWF0ZSwgTElCQlBGXzAuMC4yKQ0KPiBPTERfVkVSU0lPTih4c2tfdW1lbV9fY3JlYXRlX3YwXzBf
NCwgeHNrX3VtZW1fX2NyZWF0ZSwgTElCQlBGXzAuMC40KQ0KPiBORVdfVkVSU0lPTih4c2tfdW1l
bV9fY3JlYXRlX3YwXzBfNiwgeHNrX3VtZW1fX2NyZWF0ZSwgTElCQlBGXzAuMC42KQ0KDQpZZXMu
DQoNCj4gDQo+IDAuMC40IHdpbGwgYmUgcmVuYW1lZCB0byBPTERfIGFuZCB0aGUgbGF0ZXN0IGFk
ZGl0aW9uIE5FV18gPw0KDQpSaWdodC4NCg0KPiBUaGUgbWFjcm8gbmFtZSBmZWVscyBhIGJpdCBj
b25mdXNpbmcuIE1heSBiZSBpbnN0ZWFkIG9mIE5FV18NCj4gY2FsbCBpdCBDVVJSRU5UXyA/IG9y
IERFRkFVTFRfID8NCj4gTkVXXyB3aWxsIGJlY29tZSBub3Qgc28gJ25ldycgZmV3IG1vbnRocyBm
cm9tIG5vdy4NCg0KUmlnaHQuIEFmdGVyIGEgZmV3IG1vbnRocywgdGhlIHZlcnNpb24gbnVtYmVy
IG1heSBpbmRlZWQgYmUNCmJlaGluZCB0aGUgbGliYnBmIHZlcnNpb25zLi4uLiAiY3VycmVudCIg
bWF5IG5vdCBiZSBjdXJyZW50IC4uLi4NCkxldCBtZSB1c2UgREVGQVVMVCB0aGVuLiBIb3cgYWJv
dXQgdXNpbmcNCiAgICBDT01QQVRfVkVSU0lPTiguLi4pDQpmb3Igb2xkIHZlcnNpb25zLCBhbmQg
dXNpbmcNCiAgICBERUZBVUxUX1ZFUlNJT04oLi4uKQ0KZm9yIHRoZSBuZXcgdmVyc2lvbj8NCg==
