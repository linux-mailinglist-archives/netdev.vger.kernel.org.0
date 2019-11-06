Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C309F2086
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 22:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfKFVTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 16:19:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18368 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726798AbfKFVTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 16:19:02 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA6LDvb8013064;
        Wed, 6 Nov 2019 13:18:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=g2ZCTMKcoUEjIMBpIH8gji0ZK9gvJmgt+ax1sGvdnzc=;
 b=XhRpSp7uGFs7ALiJFwMlrC+jWWC3spKSB9rdum/uoQQasFbPa+/rrerp1L7BTNwrwqlM
 +dXxLWBF23GxAyw+7IRjps3/JkGMec4i3wULJTPaoEz08vElQ+xzKkLf8d0JBTfVprTQ
 nnDwJ/ZdjmqJyrJsjlPrTb6FfQIk2rWGWeU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2w41w1hchy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 Nov 2019 13:18:49 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 6 Nov 2019 13:18:49 -0800
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 6 Nov 2019 13:18:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIc9f5DtzI1r4yHbt11PNnaCsYZtki8zCGL4yoaVpAF+D7PIzL2SuAZ/3cqrOS8drGjPBuDdD+xGQSb2S1z4N9Q5YZaH9sfpHikwAFoZvJNR4IILanFWjXMIPMZmMuu8vS6+GH8eVFMQjyM2NYsYJVDTaCgweP4Zy9YQE+1JcPdeddooa/NDqVcySMOV7s4kq6U25qdoVKjnWU5rD6X/tTH75dGLeM9f+EJDgZRP4PIKloiSyTd2TevElq4O2YFxb2bAgwKCBM2YgN+BrlUVj9qYyfG3nRT/vKG6OZ6Oh4IY8l8fwWpyV3s/oUmdMZP/9QeFpUHRiMENTraoLyZ5KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2ZCTMKcoUEjIMBpIH8gji0ZK9gvJmgt+ax1sGvdnzc=;
 b=N6TaupdOsG5M3spU5EaEO2gW6NeW47Scgq62qDh8X3u9ZRbbkEYi6adY9ib49EGs/aGc34v6fTXpuLw+pQLQjoR7d9qXhKs0xjdgLH1DJR7qn1r3HQiWkSMWQ1QAvlCwmmVc0/wUZssLbTuiT3+uxjhuePxpTnL1+mNzEXpplf2Ws7GJl2tBpoV0iLCQBuT99TcMuCqUpExoC1F1unj2PzO8f2Q16drQHFuPeIn2IiDJZU4F6KelhRkrcZRStHB4NL6huRU9JE3f40+ziIPsEgnEGANVbv8evSj2qBM8dD7msSzMxVkdx96tC56EBaChjBr8pCVhHUY1cJKYLiGyGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2ZCTMKcoUEjIMBpIH8gji0ZK9gvJmgt+ax1sGvdnzc=;
 b=D8OQCneMLN1PXdKgQaPvlHvXwsxVFhfsaSDEwuTc4ivxkGz5dT9UsX0s8/JiKCv+Tc0JSrseuIjoxPWRJ/seY+jbjVPOmRctHGlAFhQRHzZs8PAYYb9Nh+lW2IGc3M2qymz4je7CFVMDUgn1R/rE/slcMXFdU52gEBKEm/R+sOo=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3432.namprd15.prod.outlook.com (20.179.59.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Wed, 6 Nov 2019 21:18:48 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2408.025; Wed, 6 Nov 2019
 21:18:48 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: simplify BPF_CORE_READ_BITFIELD_PROBED
 usage
Thread-Topic: [PATCH bpf-next] libbpf: simplify BPF_CORE_READ_BITFIELD_PROBED
 usage
Thread-Index: AQHVlN7mdqeCPuu5akK2gbR1A6tGyad+pcwA
Date:   Wed, 6 Nov 2019 21:18:47 +0000
Message-ID: <bdc51aac-6d39-13a6-f50e-8fca3d329b4b@fb.com>
References: <20191106201500.2582438-1-andriin@fb.com>
In-Reply-To: <20191106201500.2582438-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1601CA0016.namprd16.prod.outlook.com
 (2603:10b6:300:da::26) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:5052]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40d93f70-ca91-4e21-62c6-08d762fee987
x-ms-traffictypediagnostic: BYAPR15MB3432:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB34323268557082BE8405D12FD3790@BYAPR15MB3432.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(39860400002)(396003)(366004)(199004)(189003)(53546011)(102836004)(6506007)(52116002)(46003)(6486002)(186003)(229853002)(386003)(76176011)(99286004)(6512007)(25786009)(2616005)(11346002)(66946007)(36756003)(6436002)(66556008)(64756008)(66446008)(2906002)(6246003)(66476007)(6116002)(81156014)(8676002)(81166006)(2501003)(486006)(5660300002)(478600001)(476003)(14454004)(31686004)(2201001)(86362001)(4326008)(446003)(316002)(110136005)(54906003)(14444005)(256004)(71200400001)(8936002)(71190400001)(7736002)(305945005)(31696002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3432;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QZO8AChug4OlQu9vVdNuTNGxALMvN6Rn7VBGPJLMJ7rOj9HC0GeZ/tGCEX8di4OJwsPaYx9kDrK0hmxCB4g8NhpvNfdqjKeyNwM2ndvSHFZVii+09xOmpTZA4wJjk+VGB5JalMQPc9n1Ew3HtgCopdoCVNOL4Ozqtrrv7DvyxQlMaQPH4P8kUjUYROZ90FObN6X8tYexMdPGmaFEUq9+vpQELh73vij+rngM+2eNSbT/ylG7fB6vtKbBmBQqo7eRss5gyfYbz4gg4wIgevrxzX8mWfDOiQq3Wjn8Z/NbHbgBU2jIONo1lEkDQiPkPO+wsCeHh2x6K2c0Vqycn7DtrFGwsCjAWPtvbUxnpP0oNvJqqP4s7+zRT/hKc0B4ZyicTfGO/OCQ5ZrRSy+Ym32YqL+nAdJSPkzNVbGAsP0+/YLC6xZD5RLw5HKTThbiZRVp
Content-Type: text/plain; charset="utf-8"
Content-ID: <52B723A96D5EB048AAE0E012744178C3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d93f70-ca91-4e21-62c6-08d762fee987
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 21:18:47.8801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9OPQf0BqVXgbKw9syAATld4fsAbFqj122amrvCyfR/keemYfGHInOr2HM3ehQ2+w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3432
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_07:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911060208
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzYvMTkgMTI6MTUgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gU3RyZWFt
bGluZSBCUEZfQ09SRV9SRUFEX0JJVEZJRUxEX1BST0JFRCBpbnRlcmZhY2UgdG8gZm9sbG93DQo+
IEJQRl9DT1JFX1JFQURfQklURklFTEQgKGRpcmVjdCkgYW5kIEJQRl9DT1JFX1JFQUQsIGluIGdl
bmVyYWwsIGkuZS4sIGp1c3QNCj4gcmV0dXJuIHJlYWQgcmVzdWx0IG9yIDAsIGlmIHVuZGVybHlp
bmcgYnBmX3Byb2JlX3JlYWQoKSBmYWlsZWQuDQo+IA0KPiBJbiBwcmFjdGljZSwgcmVhbCBhcHBs
aWNhdGlvbnMgcmFyZWx5IGNoZWNrIGJwZl9wcm9iZV9yZWFkKCkgcmVzdWx0LCBiZWNhdXNlDQo+
IGl0IGhhcyB0byBhbHdheXMgd29yayBvciBvdGhlcndpc2UgaXQncyBhIGJ1Zy4gU28gcHJvcGFn
YXRpbmcgaW50ZXJuYWwNCj4gYnBmX3Byb2JlX3JlYWQoKSBlcnJvciBmcm9tIHRoaXMgbWFjcm8g
aHVydHMgdXNhYmlsaXR5IHdpdGhvdXQgcHJvdmlkaW5nIHJlYWwNCj4gYmVuZWZpdHMgaW4gcHJh
Y3RpY2UuIFRoaXMgcGF0Y2ggZml4ZXMgdGhlIGlzc3VlIGFuZCBzaW1wbGlmaWVzIHVzYWdlLA0K
PiBub3RpY2VhYmxlIGV2ZW4gaW4gc2VsZnRlc3QgaXRzZWxmLg0KDQpBZ3JlZWQuIFRoaXMgd2ls
bCBiZSBjb25zaXN0ZW50IHdpdGggZGlyZWN0IHJlYWQgd2hlcmUNCnJldHVybmluZyB2YWx1ZSB3
aWxsIGJlIDAgaWYgYW55IGZhdWx0IGhhcHBlbnMuDQoNCkluIHJlYWxseSByYXJlIGNhc2VzLCBp
ZiB1c2VyIHdhbnQgdG8gZGlzdGluZ3Vpc2ggZ29vZCB2YWx1ZSAwIGZyb20NCmJwZl9wcm9iZV9y
ZWFkKCkgcmV0dXJuaW5nIGVycm9yLCBhbGwgYnVpbGRpbmcgbWFjcm9zIGFyZSBpbiB0aGUgaGVh
ZGVyDQpmaWxlLCB1c2VyIGNhbiBoYXZlIGEgY3VzdG9tIHNvbHV0aW9uLiBCdXQgbGV0IHVzIGhh
dmUgQVBJIHdvcmsNCmZvciBjb21tb24gdXNlIGNhc2Ugd2l0aCBnb29kIHVzYWJpbGl0eS4NCg0K
PiANCj4gQ2M6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEFu
ZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQoNCkFja2VkLWJ5OiBZb25naG9uZyBTb25n
IDx5aHNAZmIuY29tPg0KDQoNCj4gLS0tDQo+ICAgdG9vbHMvbGliL2JwZi9icGZfY29yZV9yZWFk
LmggICAgICAgICAgICAgICAgIHwgMjcgKysrKysrKystLS0tLS0tLS0tLQ0KPiAgIC4uLi9wcm9n
cy90ZXN0X2NvcmVfcmVsb2NfYml0ZmllbGRzX3Byb2JlZC5jICB8IDE5ICsrKysrLS0tLS0tLS0N
Cj4gICAyIGZpbGVzIGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDI4IGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvYnBmX2NvcmVfcmVhZC5oIGIvdG9vbHMv
bGliL2JwZi9icGZfY29yZV9yZWFkLmgNCj4gaW5kZXggMTE0NjFiMjYyM2IwLi43MDA5ZGM5MGUw
MTIgMTAwNjQ0DQo+IC0tLSBhL3Rvb2xzL2xpYi9icGYvYnBmX2NvcmVfcmVhZC5oDQo+ICsrKyBi
L3Rvb2xzL2xpYi9icGYvYnBmX2NvcmVfcmVhZC5oDQo+IEBAIC0zOSwzMiArMzksMjcgQEAgZW51
bSBicGZfZmllbGRfaW5mb19raW5kIHsNCj4gICAjZW5kaWYNCj4gICANCj4gICAvKg0KPiAtICog
RXh0cmFjdCBiaXRmaWVsZCwgaWRlbnRpZmllZCBieSBzcmMtPmZpZWxkLCBhbmQgcHV0IGl0cyB2
YWx1ZSBpbnRvIHU2NA0KPiAtICogKnJlcy4gQWxsIHRoaXMgaXMgZG9uZSBpbiByZWxvY2F0YWJs
ZSBtYW5uZXIsIHNvIGJpdGZpZWxkIGNoYW5nZXMgc3VjaCBhcw0KPiArICogRXh0cmFjdCBiaXRm
aWVsZCwgaWRlbnRpZmllZCBieSBzLT5maWVsZCwgYW5kIHJldHVybiBpdHMgdmFsdWUgYXMgdTY0
Lg0KPiArICogQWxsIHRoaXMgaXMgZG9uZSBpbiByZWxvY2F0YWJsZSBtYW5uZXIsIHNvIGJpdGZp
ZWxkIGNoYW5nZXMgc3VjaCBhcw0KPiAgICAqIHNpZ25lZG5lc3MsIGJpdCBzaXplLCBvZmZzZXQg
Y2hhbmdlcywgdGhpcyB3aWxsIGJlIGhhbmRsZWQgYXV0b21hdGljYWxseS4NCj4gICAgKiBUaGlz
IHZlcnNpb24gb2YgbWFjcm8gaXMgdXNpbmcgYnBmX3Byb2JlX3JlYWQoKSB0byByZWFkIHVuZGVy
bHlpbmcgaW50ZWdlcg0KPiAgICAqIHN0b3JhZ2UuIE1hY3JvIGZ1bmN0aW9ucyBhcyBhbiBleHBy
ZXNzaW9uIGFuZCBpdHMgcmV0dXJuIHR5cGUgaXMNCj4gICAgKiBicGZfcHJvYmVfcmVhZCgpJ3Mg
cmV0dXJuIHZhbHVlOiAwLCBvbiBzdWNjZXNzLCA8MCBvbiBlcnJvci4NCj4gICAgKi8NCj4gLSNk
ZWZpbmUgQlBGX0NPUkVfUkVBRF9CSVRGSUVMRF9QUk9CRUQoc3JjLCBmaWVsZCwgcmVzKSAoewkJ
ICAgICAgXA0KPiAtCXVuc2lnbmVkIGxvbmcgbG9uZyB2YWw7CQkJCQkJICAgICAgXA0KPiArI2Rl
ZmluZSBCUEZfQ09SRV9SRUFEX0JJVEZJRUxEX1BST0JFRChzLCBmaWVsZCkgKHsJCQkgICAgICBc
DQo+ICsJdW5zaWduZWQgbG9uZyBsb25nIHZhbCA9IDA7CQkJCQkgICAgICBcDQo+ICAgCQkJCQkJ
CQkJICAgICAgXA0KPiAtCSpyZXMgPSAwOwkJCQkJCQkgICAgICBcDQo+IC0JdmFsID0gX19DT1JF
X0JJVEZJRUxEX1BST0JFX1JFQUQocmVzLCBzcmMsIGZpZWxkKTsJCSAgICAgIFwNCj4gLQlpZiAo
IXZhbCkgewkJCQkJCQkgICAgICBcDQo+IC0JCSpyZXMgPDw9IF9fQ09SRV9SRUxPKHNyYywgZmll
bGQsIExTSElGVF9VNjQpOwkJICAgICAgXA0KPiAtCQl2YWwgPSBfX0NPUkVfUkVMTyhzcmMsIGZp
ZWxkLCBSU0hJRlRfVTY0KTsJCSAgICAgIFwNCj4gLQkJaWYgKF9fQ09SRV9SRUxPKHNyYywgZmll
bGQsIFNJR05FRCkpCQkJICAgICAgXA0KPiAtCQkJKnJlcyA9ICgobG9uZyBsb25nKSpyZXMpID4+
IHZhbDsJCSAgICAgIFwNCj4gLQkJZWxzZQkJCQkJCQkgICAgICBcDQo+IC0JCQkqcmVzID0gKCh1
bnNpZ25lZCBsb25nIGxvbmcpKnJlcykgPj4gdmFsOwkgICAgICBcDQo+IC0JCXZhbCA9IDA7CQkJ
CQkJICAgICAgXA0KPiAtCX0JCQkJCQkJCSAgICAgIFwNCj4gKwlfX0NPUkVfQklURklFTERfUFJP
QkVfUkVBRCgmdmFsLCBzLCBmaWVsZCk7CQkJICAgICAgXA0KPiArCXZhbCA8PD0gX19DT1JFX1JF
TE8ocywgZmllbGQsIExTSElGVF9VNjQpOwkJCSAgICAgIFwNCj4gKwlpZiAoX19DT1JFX1JFTE8o
cywgZmllbGQsIFNJR05FRCkpCQkJCSAgICAgIFwNCj4gKwkJdmFsID0gKChsb25nIGxvbmcpdmFs
KSA+PiBfX0NPUkVfUkVMTyhzLCBmaWVsZCwgUlNISUZUX1U2NCk7ICBcDQo+ICsJZWxzZQkJCQkJ
CQkJICAgICAgXA0KPiArCQl2YWwgPSB2YWwgPj4gX19DT1JFX1JFTE8ocywgZmllbGQsIFJTSElG
VF9VNjQpOwkJICAgICAgXA0KPiAgIAl2YWw7CQkJCQkJCQkgICAgICBcDQo+ICAgfSkNCj4gICAN
Cj4gICAvKg0KPiAtICogRXh0cmFjdCBiaXRmaWVsZCwgaWRlbnRpZmllZCBieSBzcmMtPmZpZWxk
LCBhbmQgcmV0dXJuIGl0cyB2YWx1ZSBhcyB1NjQuDQo+ICsgKiBFeHRyYWN0IGJpdGZpZWxkLCBp
ZGVudGlmaWVkIGJ5IHMtPmZpZWxkLCBhbmQgcmV0dXJuIGl0cyB2YWx1ZSBhcyB1NjQuDQo+ICAg
ICogVGhpcyB2ZXJzaW9uIG9mIG1hY3JvIGlzIHVzaW5nIGRpcmVjdCBtZW1vcnkgcmVhZHMgYW5k
IHNob3VsZCBiZSB1c2VkIGZyb20NCj4gICAgKiBCUEYgcHJvZ3JhbSB0eXBlcyB0aGF0IHN1cHBv
cnQgc3VjaCBmdW5jdGlvbmFsaXR5IChlLmcuLCB0eXBlZCByYXcNCj4gICAgKiB0cmFjZXBvaW50
cykuDQo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVz
dF9jb3JlX3JlbG9jX2JpdGZpZWxkc19wcm9iZWQuYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2JwZi9wcm9ncy90ZXN0X2NvcmVfcmVsb2NfYml0ZmllbGRzX3Byb2JlZC5jDQo+IGluZGV4IGEz
ODFmOGFjMjQxOS4uZTQ2NmUzYWI3ZGU0IDEwMDY0NA0KPiAtLS0gYS90b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9jb3JlX3JlbG9jX2JpdGZpZWxkc19wcm9iZWQuYw0KPiAr
KysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvdGVzdF9jb3JlX3JlbG9jX2Jp
dGZpZWxkc19wcm9iZWQuYw0KPiBAQCAtMzcsMTEgKzM3LDYgQEAgc3RydWN0IGNvcmVfcmVsb2Nf
Yml0ZmllbGRzX291dHB1dCB7DQo+ICAgCWludDY0X3QJCXMzMjsNCj4gICB9Ow0KPiAgIA0KPiAt
I2RlZmluZSBUUkFOU0ZFUl9CSVRGSUVMRChpbiwgb3V0LCBmaWVsZCkJCQkJXA0KPiAtCWlmIChC
UEZfQ09SRV9SRUFEX0JJVEZJRUxEX1BST0JFRChpbiwgZmllbGQsICZyZXMpKQkJXA0KPiAtCQly
ZXR1cm4gMTsJCQkJCQlcDQo+IC0Jb3V0LT5maWVsZCA9IHJlcw0KPiAtDQo+ICAgU0VDKCJyYXdf
dHJhY2Vwb2ludC9zeXNfZW50ZXIiKQ0KPiAgIGludCB0ZXN0X2NvcmVfYml0ZmllbGRzKHZvaWQg
KmN0eCkNCj4gICB7DQo+IEBAIC00OSwxMyArNDQsMTMgQEAgaW50IHRlc3RfY29yZV9iaXRmaWVs
ZHModm9pZCAqY3R4KQ0KPiAgIAlzdHJ1Y3QgY29yZV9yZWxvY19iaXRmaWVsZHNfb3V0cHV0ICpv
dXQgPSAodm9pZCAqKSZkYXRhLm91dDsNCj4gICAJdWludDY0X3QgcmVzOw0KPiAgIA0KPiAtCVRS
QU5TRkVSX0JJVEZJRUxEKGluLCBvdXQsIHViMSk7DQo+IC0JVFJBTlNGRVJfQklURklFTEQoaW4s
IG91dCwgdWIyKTsNCj4gLQlUUkFOU0ZFUl9CSVRGSUVMRChpbiwgb3V0LCB1YjcpOw0KPiAtCVRS
QU5TRkVSX0JJVEZJRUxEKGluLCBvdXQsIHNiNCk7DQo+IC0JVFJBTlNGRVJfQklURklFTEQoaW4s
IG91dCwgc2IyMCk7DQo+IC0JVFJBTlNGRVJfQklURklFTEQoaW4sIG91dCwgdTMyKTsNCj4gLQlU
UkFOU0ZFUl9CSVRGSUVMRChpbiwgb3V0LCBzMzIpOw0KPiArCW91dC0+dWIxID0gQlBGX0NPUkVf
UkVBRF9CSVRGSUVMRF9QUk9CRUQoaW4sIHViMSk7DQo+ICsJb3V0LT51YjIgPSBCUEZfQ09SRV9S
RUFEX0JJVEZJRUxEX1BST0JFRChpbiwgdWIyKTsNCj4gKwlvdXQtPnViNyA9IEJQRl9DT1JFX1JF
QURfQklURklFTERfUFJPQkVEKGluLCB1YjcpOw0KPiArCW91dC0+c2I0ID0gQlBGX0NPUkVfUkVB
RF9CSVRGSUVMRF9QUk9CRUQoaW4sIHNiNCk7DQo+ICsJb3V0LT5zYjIwID0gQlBGX0NPUkVfUkVB
RF9CSVRGSUVMRF9QUk9CRUQoaW4sIHNiMjApOw0KPiArCW91dC0+dTMyID0gQlBGX0NPUkVfUkVB
RF9CSVRGSUVMRF9QUk9CRUQoaW4sIHUzMik7DQo+ICsJb3V0LT5zMzIgPSBCUEZfQ09SRV9SRUFE
X0JJVEZJRUxEX1BST0JFRChpbiwgczMyKTsNCj4gICANCj4gICAJcmV0dXJuIDA7DQo+ICAgfQ0K
PiANCg==
