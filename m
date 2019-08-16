Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFE68F87B
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 03:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfHPBdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 21:33:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38370 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725983AbfHPBdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 21:33:42 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7G1SoYr000981;
        Thu, 15 Aug 2019 18:33:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=fIrsq94L/1wAbCI5I9aRmz13IsQINNqkgBKczsAP8JU=;
 b=aWjXeq2k/w8iHm0DCpTGD3/MJCMhyO1TK59ciS/kbMk3jwunPGX9zTNT/GRdmxAR80fG
 po+M8wcyquqAA2K2X9synExFSxJHFOeo4y5hD2tt3+z1vvXw0Np+iwYblshr+DPrh4Yr
 m1s7231TAgPW102cC2IjRDFi9Dmu7qxMh8s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2udej319wc-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 15 Aug 2019 18:33:26 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 15 Aug 2019 18:33:23 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 15 Aug 2019 18:33:07 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 15 Aug 2019 18:33:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O678nCr+kj3xW5jhuap2VGHoQL8Y2n3VqtG/fUq/WNSGt3CM1hgITmzeWjq4LDQvYssSA8xS9BL/PIX/EBa/4XigwvNBzJnX9yJWaGN1gJ8zXcJjJn2XfL3Tbc+e8HSQ5uhKEu19/h49ThjvM4YPys4TzQEBvdvDp32ahpz5WQi2D3QUcJ6zGp4bmLgdGE9Qbt+peJtuETxCMk6d8t7fkUPyysaBYPOgXvLv/a0R/92NaGmdbkC/AtMYjr+pjhWi6EYf2y1jsKgg0TAg9EaXoxqVb43nka1q1q0LDDJ0nnEx+SC22nLSqX1u7DrZ5MbBExq/U8qun6zkidOXT3kdOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIrsq94L/1wAbCI5I9aRmz13IsQINNqkgBKczsAP8JU=;
 b=GYGlp2y4yr78XW1YCQnxLB5CeoMp6LPgx8HOo3lYYm8uFnwDn7CX4eJEksPzLaEoLvtxOSY65XuIN81iJHkFo/iA0p8scnv6mLNVS4OzlRsTVyOPj4qbtnIReMz0GhotE0qc02n409oXOGKwBJMnLLMjJ4lrOhFeG1mVxgHf78w4/P8NZJ0DldQnTz2dLS4JFq0Y/klPazjECKHxxXC29TvbZItrwezCXtl/cBdjGVKg+eqa/8gTJHLmlu8Uso2go32LNGF4MwlrSRdvsS5ptisXS11r0KqbMCxMbRxVL4xGoNmYbs0jNo+00JJumndxoVS/zrVnNcLXWkyoCU7eOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIrsq94L/1wAbCI5I9aRmz13IsQINNqkgBKczsAP8JU=;
 b=exsx1RUWihMnHA/zD4AnhXLuUyHH5iAnm90F+l6nZGEUq5tLseeILQ2MFbggCIebLxycQu+edZlOsWjmafcCxxiOI//ESTB7xCFps9raPFDLOSawmAeN8A0+CGur1AcdSF27TnWxeO2dlQWuKW0vt/jmwuuGFNkkkZQ1oChUaCA=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1742.namprd15.prod.outlook.com (10.174.100.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Fri, 16 Aug 2019 01:33:04 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.022; Fri, 16 Aug 2019
 01:33:04 +0000
From:   Tao Ren <taoren@fb.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v7 3/3] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
Thread-Topic: [PATCH net-next v7 3/3] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
Thread-Index: AQHVUJ5qOj7KTUEtsUuopmpFoA8EiKb842IAgAAgdoA=
Date:   Fri, 16 Aug 2019 01:33:04 +0000
Message-ID: <c19e18d8-96b1-32f9-a3fc-cee87aa55018@fb.com>
References: <20190811234016.3674056-1-taoren@fb.com>
 <d45d609b-60ea-760d-31f4-51afa379c55a@gmail.com>
In-Reply-To: <d45d609b-60ea-760d-31f4-51afa379c55a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0059.namprd17.prod.outlook.com
 (2603:10b6:300:93::21) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:70f6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c3eac59-c64d-4b5d-c964-08d721e9aeba
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1742;
x-ms-traffictypediagnostic: MWHPR15MB1742:
x-microsoft-antispam-prvs: <MWHPR15MB1742ACCDB6483DFA021408F6B2AF0@MWHPR15MB1742.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(136003)(346002)(366004)(189003)(199004)(476003)(6506007)(386003)(7416002)(71190400001)(53546011)(14454004)(76176011)(65826007)(316002)(53936002)(7736002)(2201001)(486006)(86362001)(446003)(2906002)(6116002)(305945005)(52116002)(25786009)(8936002)(102836004)(11346002)(58126008)(6246003)(186003)(110136005)(31686004)(64126003)(2616005)(46003)(71200400001)(6436002)(66476007)(256004)(66446008)(6486002)(8676002)(66946007)(99286004)(229853002)(64756008)(6512007)(5660300002)(66556008)(81156014)(36756003)(31696002)(478600001)(2501003)(81166006)(65956001)(65806001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1742;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NpDdpRfIwGBKhxCFWi8WEDvfIvCbYwBAv1rz+Vr/KbJgiz1+khEu4c1S2K885ygKP3TlmYjsUOT9Viqyh7cnxUCS17HLESWE6wrZBonW2uk4eUIkqX0wm/UAz4K7Jc98cZamfqmBv0Rhrd+4hY77y5dpxsCi70MiBb/9bTRlMzGsRGu07xtzUduFlLacuAo0KcqM4DzoPxCDJu5yrqN/z5oSkXyk90oGSRtQsgmmzMHTEypvLIIVVyQbMXSEBnEYjO965BlPq+fbN+AQZ2YIMMleUd2lUZ1A1/u+g7dHDh7MwgF4N0nSqBOQH/4WMDm/tBnwJMRfuLesW2My9by4Hy3zbPf2Z+cfx5u7bEM0aOxFB2755DFa4E5lYCcxUtNZeAl8t5tEYgM23G1octpojRbdbuitqAjbsWOgJyV9xus=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <207D60D65642274D90FDCDBD0ED2BDA3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c3eac59-c64d-4b5d-c964-08d721e9aeba
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 01:33:04.1136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: StRes9ubzQsq0WI+LsXNOemTmHwqu1Af5A8TLynv/e9a0ONrVrXmoHLOVL5Noi28
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1742
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-15_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=932 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160013
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8xNS8xOSA0OjM2IFBNLCBGbG9yaWFuIEZhaW5lbGxpIHdyb3RlOg0KPiBPbiA4LzExLzE5
IDQ6NDAgUE0sIFRhbyBSZW4gd3JvdGU6DQo+PiBUaGUgQkNNNTQ2MTZTIFBIWSBjYW5ub3Qgd29y
ayBwcm9wZXJseSBpbiBSR01JSS0+MTAwMEJhc2UtWCBtb2RlLCBtYWlubHkNCj4+IGJlY2F1c2Ug
Z2VucGh5IGZ1bmN0aW9ucyBhcmUgZGVzaWduZWQgZm9yIGNvcHBlciBsaW5rcywgYW5kIDEwMDBC
YXNlLVgNCj4+IChjbGF1c2UgMzcpIGF1dG8gbmVnb3RpYXRpb24gbmVlZHMgdG8gYmUgaGFuZGxl
ZCBkaWZmZXJlbnRseS4NCj4+DQo+PiBUaGlzIHBhdGNoIGVuYWJsZXMgMTAwMEJhc2UtWCBzdXBw
b3J0IGZvciBCQ001NDYxNlMgYnkgY3VzdG9taXppbmcgMw0KPj4gZHJpdmVyIGNhbGxiYWNrcywg
YW5kIGl0J3MgdmVyaWZpZWQgdG8gYmUgd29ya2luZyBvbiBGYWNlYm9vayBDTU0gQk1DDQo+PiBw
bGF0Zm9ybSAoUkdNSUktPjEwMDBCYXNlLUtYKToNCj4+DQo+PiAgIC0gcHJvYmU6IHByb2JlIGNh
bGxiYWNrIGRldGVjdHMgUEhZJ3Mgb3BlcmF0aW9uIG1vZGUgYmFzZWQgb24NCj4+ICAgICBJTlRF
UkZfU0VMWzE6MF0gcGlucyBhbmQgMTAwMFgvMTAwRlggc2VsZWN0aW9uIGJpdCBpbiBTZXJERVMg
MTAwLUZYDQo+PiAgICAgQ29udHJvbCByZWdpc3Rlci4NCj4+DQo+PiAgIC0gY29uZmlnX2FuZWc6
IGNhbGxzIGdlbnBoeV9jMzdfY29uZmlnX2FuZWcgd2hlbiB0aGUgUEhZIGlzIHJ1bm5pbmcgaW4N
Cj4+ICAgICAxMDAwQmFzZS1YIG1vZGU7IG90aGVyd2lzZSwgZ2VucGh5X2NvbmZpZ19hbmVnIHdp
bGwgYmUgY2FsbGVkLg0KPj4NCj4+ICAgLSByZWFkX3N0YXR1czogY2FsbHMgZ2VucGh5X2MzN19y
ZWFkX3N0YXR1cyB3aGVuIHRoZSBQSFkgaXMgcnVubmluZyBpbg0KPj4gICAgIDEwMDBCYXNlLVgg
bW9kZTsgb3RoZXJ3aXNlLCBnZW5waHlfcmVhZF9zdGF0dXMgd2lsbCBiZSBjYWxsZWQuDQo+Pg0K
Pj4gTm90ZTogQkNNNTQ2MTZTIFBIWSBjYW4gYWxzbyBiZSBjb25maWd1cmVkIGluIFJHTUlJLT4x
MDBCYXNlLUZYIG1vZGUsIGFuZA0KPj4gMTAwQmFzZS1GWCBzdXBwb3J0IGlzIG5vdCBhdmFpbGFi
bGUgYXMgb2Ygbm93Lg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IFRhbyBSZW4gPHRhb3JlbkBmYi5j
b20+DQo+IA0KPj4gLQkJcmVnID0gYmNtX3BoeV9yZWFkX3NoYWRvdyhwaHlkZXYsIEJDTTU0ODJf
U0hEX01PREUpOw0KPj4gLQkJYmNtX3BoeV93cml0ZV9zaGFkb3cocGh5ZGV2LCBCQ001NDgyX1NI
RF9NT0RFLA0KPj4gLQkJCQkgICAgIHJlZyB8IEJDTTU0ODJfU0hEX01PREVfMTAwMEJYKTsNCj4+
ICsJCXJlZyA9IGJjbV9waHlfcmVhZF9zaGFkb3cocGh5ZGV2LCBCQ001NFhYX1NIRF9NT0RFKTsN
Cj4+ICsJCWJjbV9waHlfd3JpdGVfc2hhZG93KHBoeWRldiwgQkNNNTRYWF9TSERfTU9ERSwNCj4+
ICsJCQkJICAgICByZWcgfCBCQ001NFhYX1NIRF9NT0RFXzEwMDBCWCk7DQo+IA0KPiBUaGlzIGNv
dWxkIGhhdmUgYmVlbiBhIHNlcGFyYXRlIHBhdGNoLCBidXQgdGhpcyBsb29rcyByZWFzb25hYmxl
IHRvIG1lDQo+IGFuZCB0aGlzIGlzIGNvcnJlY3Qgd2l0aCB0aGUgZGF0YXNoZWV0LCB0aGFua3Mg
VGFvLg0KPiANCj4gUmV2aWV3ZWQtYnk6IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21h
aWwuY29tPg0KDQpUaGFuayB5b3UgRkxvcmlhbi4NCg0KSXQgaXMgZ3JlYXQgZXhwZXJpZW5jZSB3
b3JraW5nIHdpdGggeW91IGFsbCB0byBmaWd1cmUgb3V0IHJvb3QgY2F1c2UgYW5kIHdvcmsgb3V0
IHRoZSBwYXRjaGVzLCBhbmQgSSByZWFsbHkgYXBwcmVjaWF0ZSBpdC4NCg0KDQpDaGVlcnMsDQoN
ClRhbw0K
