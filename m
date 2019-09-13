Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3719B2710
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 23:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388982AbfIMVM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 17:12:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37914 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388430AbfIMVM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 17:12:28 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8DL8XKB006551;
        Fri, 13 Sep 2019 14:12:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Zeb1pA+O1j1Huoaw/l2xP0kbqF3BDFBQb+rAvDiXLbY=;
 b=qUO8bDvf/PLE9sl8svGwCIrg43R9C9poT/zt/LfWPCbNn3qIU+OQEko36h/8sGiqr/0t
 kWXQTwX5GlSEBJTSn9ALyUZOShR1lr8XSKb1eKB4gmzX9OHCr2cboQVMqljaNiX1HvR6
 u0AjNTg2gMMk/KYuc4sT1n20+719nCYqOLo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2v0ehf18dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Sep 2019 14:12:03 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Sep 2019 14:12:02 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 14:12:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGInd5+OgRsa38oYyHxfn0AKAcAHm3Pgev/S2dR4uAOuZxa8+uWpQ4PgjfR3mxGl0B7lBLG/Gb7FCo7JPna++iMPJPEMqtVf3tAKrLeIsU3341UQm1LXa3WvvsZLmMc2DpfUwY2RhwMo2FBAZ+FyzzEL73YI72wUHs/CVMivaaYTkoL3CKc6E6ms9VLs/uPVP9h0GMkMNT5TSScFRK0n2bOKY6h6kRYYm70mWcgit0C7hbTbDm3n5NX85UevaRnWx7u60v4sRsnyeqghdDRjXDsUAHKEx3ypgJiIyCITwGI2yjEkqcOz0XuAMYkx9IJGskgsbBR0VWPMuNPoTjomlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zeb1pA+O1j1Huoaw/l2xP0kbqF3BDFBQb+rAvDiXLbY=;
 b=D2n6NN9/NE1LtT4t0QImatQLvtNzfVTEVvFxr5yRRnM6X0ccHkU4x14soY15YM5mO9NiuXDw2KAWEkrulhtGmpCPDY9Gn0SCCfFV77DUVm4UqcxbuE1Q4Z5ZXuM3T3jcu4AdNwbEol5M57gaufNpWLuEALoIu2H2r5A9zlkNik14WSEV6IUc+17jrKTKPW26w9qpCiYEF9841a4XRk9r2fPtdmdwVmy4jnRziJFb/NfI4+T2UBUvS+rjM7XtrJaVwgsO/1ysGVIPLw51oKZwDlh2U9q5p8n4ZixCn4vMjfX5+E4zvwLTtkQnMmXbzZeesShukM7FtMPrkP5VUFLJ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zeb1pA+O1j1Huoaw/l2xP0kbqF3BDFBQb+rAvDiXLbY=;
 b=lUSzbunB2sv9ub3ByUnENWoelYt6a28efAPUea/ShgmPzx6u8Rbcj9SBknoyxtM9dnNzP1w3mlYzbaxcZJqOa4doY8mCKHBBelHkuS4ja+WXyqDNOq8WEsVnAa1ijvccBkxZcbyBQupl3HxoG4gjHrIrTqrhcRr8eMme45e/uYo=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2887.namprd15.prod.outlook.com (20.178.206.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Fri, 13 Sep 2019 21:12:01 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2263.021; Fri, 13 Sep 2019
 21:12:01 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH bpf-next 05/11] samples: bpf: makefile: use D vars from
 KBUILD_CFLAGS to handle headers
Thread-Topic: [PATCH bpf-next 05/11] samples: bpf: makefile: use D vars from
 KBUILD_CFLAGS to handle headers
Thread-Index: AQHVZ8PziWr/UVryq0m06Eabu047jKcqIDkA
Date:   Fri, 13 Sep 2019 21:12:01 +0000
Message-ID: <97ca4228-145a-2449-b4ba-8e79380a54f4@fb.com>
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
 <20190910103830.20794-6-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190910103830.20794-6-ivan.khoronzhuk@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0063.namprd22.prod.outlook.com
 (2603:10b6:301:5e::16) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::ec5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71246443-36e6-4c34-47c5-08d7388f04d8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2887;
x-ms-traffictypediagnostic: BYAPR15MB2887:
x-microsoft-antispam-prvs: <BYAPR15MB28879B1DDDA066A1E430010ED3B30@BYAPR15MB2887.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:983;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(376002)(136003)(366004)(396003)(39860400002)(346002)(199004)(189003)(478600001)(53546011)(256004)(6506007)(2616005)(386003)(71200400001)(71190400001)(99286004)(5660300002)(86362001)(2201001)(31696002)(46003)(54906003)(186003)(316002)(110136005)(102836004)(76176011)(446003)(11346002)(476003)(486006)(25786009)(52116002)(4326008)(305945005)(7736002)(6116002)(2906002)(36756003)(66476007)(66556008)(64756008)(66446008)(66946007)(6246003)(229853002)(53936002)(6486002)(8676002)(6512007)(81166006)(31686004)(6436002)(2501003)(14454004)(81156014)(7416002)(8936002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2887;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iLBW2rz5Q+DdConauGXZyKgh4pHlc9yfN+yyIlttTfC1W/aRYuAd1tEMZGv1vjl7P/rPkY3l20o8gyuPOYuahtX3eydAfFIrnP10ViO2P2LJ72RbGAEKwkUsrHwhO9h1cqOR/PT/jHOBgNNESqrL4ExWaVESFDzCKQ3CJgKGU2Ds3YaI7C0Ja3Vh1Msri6nXyl3ms9vFJMB1An2CA1WnL8+O+OOaWe9dUmLtsymfxrcQIUcii3kfYTMorpFH7o5Ek3iBqD7pJzW62FFUwx9FsIgZg//TAkRjvecnG94HVy91dFXsrBivZO5Nhv+HNZr491CWRXm3R6DEi8j+p2FhkKSZivmRnYWXRXgKlLD7NOY0/vmjjIKzqlk60+u6hz75dzj85s7iUfKpujZU+crV6EnHXSjwJTfhLiOEjLYJLHk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <73E16539182A3C4989B6317B1C064729@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 71246443-36e6-4c34-47c5-08d7388f04d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 21:12:01.0485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ly+o7+n5jGnMVivNQOILqyk6iNI5KFQm/SpztTVn3XJMPNK5uZTv29clqE4To3BT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2887
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_10:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909130211
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTAvMTkgMTE6MzggQU0sIEl2YW4gS2hvcm9uemh1ayB3cm90ZToNCj4gVGhlIGtl
cm5lbCBoZWFkZXJzIGFyZSByZXVzZWQgZnJvbSBzYW1wbGVzIGJwZiwgYW5kIGF1dG9jb25mLmgg
aXMgbm90DQo+IGVub3VnaCB0byByZWZsZWN0IGNvbXBsZXRlIGFyY2ggY29uZmlndXJhdGlvbiBm
b3IgY2xhbmcuIEJ1dCBDTEFORy1icGYNCj4gY21kcyBhcmUgc2Vuc2l0aXZlIGZvciBhc3NlbWJs
ZXIgcGFydCB0YWtlbiBmcm9tIGxpbnV4IGhlYWRlcnMgYW5kIC1EDQo+IHZhcnMsIHVzdWFsbHkg
dXNlZCBpbiBDRkxBR1MsIHNob3VsZCBiZSBjYXJlZnVsbHkgYWRkZWQgZm9yIGVhY2ggYXJjaC4N
Cj4gRm9yIHRoYXQsIGZvciBDTEFORy1icGYsIGxldHMgZmlsdGVyIHRoZW0gb25seSBmb3IgYXJt
IGFyY2ggYXMgaXQNCj4gZGVmaW5pdGVseSByZXF1aXJlcyBfX0xJTlVYX0FSTV9BUkNIX18gdG8g
YmUgc2V0LCBidXQgaWdub3JlIGZvcg0KPiBvdGhlcnMgdGlsbCBpdCdzIHJlYWxseSBuZWVkZWQu
IEZvciBhcm0sIC1EX19MSU5VWF9BUk1fQVJDSF9fIGlzIG1pbg0KPiB2ZXJzaW9uIHVzZWQgYXMg
aW5zdHJ1Y3Rpb24gc2V0IHNlbGVjdG9yLiBJbiBhbm90aGVyIGNhc2UgZXJyb3JzDQo+IGxpa2Ug
IlNNUCBpcyBub3Qgc3VwcG9ydGVkIiBmb3IgYXJtIGFuZCBidW5jaCBvZiBvdGhlciBlcnJvcnMg
YXJlDQo+IGlzc3VlZCByZXN1bHRpbmcgdG8gaW5jb3JyZWN0IGZpbmFsIG9iamVjdC4NCj4gDQo+
IExhdGVyIERfT1BUSU9OUyBjYW4gYmUgdXNlZCBmb3IgZ2NjIHBhcnQuDQo+IC0tLQ0KPiAgIHNh
bXBsZXMvYnBmL01ha2VmaWxlIHwgOSArKysrKysrKysNCj4gICAxIGZpbGUgY2hhbmdlZCwgOSBp
bnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvc2FtcGxlcy9icGYvTWFrZWZpbGUgYi9z
YW1wbGVzL2JwZi9NYWtlZmlsZQ0KPiBpbmRleCA4ZWNjNWQwYzJkNWIuLjY0OTJiN2U2NWMwOCAx
MDA2NDQNCj4gLS0tIGEvc2FtcGxlcy9icGYvTWFrZWZpbGUNCj4gKysrIGIvc2FtcGxlcy9icGYv
TWFrZWZpbGUNCj4gQEAgLTE4NSw2ICsxODUsMTUgQEAgSE9TVExETElCU19tYXBfcGVyZl90ZXN0
CSs9IC1scnQNCj4gICBIT1NUTERMSUJTX3Rlc3Rfb3ZlcmhlYWQJKz0gLWxydA0KPiAgIEhPU1RM
RExJQlNfeGRwc29jawkJKz0gLXB0aHJlYWQNCj4gICANCj4gKyMgU3RyaXAgYWxsIGV4cGV0IC1E
IG9wdGlvbnMgbmVlZGVkIHRvIGhhbmRsZSBsaW51eCBoZWFkZXJzDQo+ICsjIGZvciBhcm0gaXQn
cyBfX0xJTlVYX0FSTV9BUkNIX18gYW5kIHBvdGVudGlhbGx5IG90aGVycyBmb3JrIHZhcnMNCj4g
K0RfT1BUSU9OUyA9ICQoc2hlbGwgZWNobyAiJChLQlVJTERfQ0ZMQUdTKSAiIHwgc2VkICdzL1tb
OmJsYW5rOl1dL1xuL2cnIHwgXA0KPiArCXNlZCAnL14tRC8hZCcgfCB0ciAnXG4nICcgJykNCj4g
Kw0KPiAraWZlcSAoJChBUkNIKSwgYXJtKQ0KPiArQ0xBTkdfRVhUUkFfQ0ZMQUdTIDo9ICQoRF9P
UFRJT05TKQ0KPiArZW5kaWYNCg0KRG8geW91IG5lZWQgdGhpcyBmb3IgbmF0aXZlIGNvbXBpbGF0
aW9uPw0KDQpzbyBhcm02NCBjb21waWxhdGlvbiBkb2VzIG5vdCBuZWVkIHRoaXM/DQpJZiBvbmx5
IC1EX19MSU5VWF9BUk1fQVJDSF9fIGlzIG5lZWRlZCwgbWF5YmUganVzdA0Kd2l0aA0KICAgIENM
QU5HX0VYVFJBX0NGTEFHUyA6PSAtRF9fTElOVVhfQVJNX0FSQ0hfXw0KT3RoZXJ3aXNlLCBwZW9w
bGUgd2lsbCB3b25kZXIgd2hldGhlciB0aGlzIGlzIG5lZWRlZCBmb3INCm90aGVyIGFyY2hpdGVj
dHVyZXMuIE9yIGp1c3QgZG8NCiAgICBDTEFOR19FWFRSQV9DRkxBR1MgOj0gJChEX09QVElPTlMp
DQpmb3IgYWxsIGNyb3NzIGNvbXBpbGF0aW9uPw0KDQo+ICsNCj4gICAjIEFsbG93cyBwb2ludGlu
ZyBMTEMvQ0xBTkcgdG8gYSBMTFZNIGJhY2tlbmQgd2l0aCBicGYgc3VwcG9ydCwgcmVkZWZpbmUg
b24gY21kbGluZToNCj4gICAjICBtYWtlIHNhbXBsZXMvYnBmLyBMTEM9fi9naXQvbGx2bS9idWls
ZC9iaW4vbGxjIENMQU5HPX4vZ2l0L2xsdm0vYnVpbGQvYmluL2NsYW5nDQo+ICAgTExDID89IGxs
Yw0KPiANCg==
