Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12AC0B275D
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 23:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389824AbfIMVen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 17:34:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2392 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387637AbfIMVem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 17:34:42 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8DLYAgS023456;
        Fri, 13 Sep 2019 14:34:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=AmTfHPl3zKHlwjYe8llbDM2hT14u3/aBGSn2/a3ehN4=;
 b=kfSLY9/fSKdwAlkdQw0+OsIuFDS6ZEvOC830kAKCLKwtTPctoJ3ijurmDo5/s6Ff6JhW
 Q3qMf+ZidCq7XEguJLN4UMAlW+HLAJyEPpYlM3VOaEub2oMv+cSotc8fYUvAi4LU0EXU
 jblm+n3eoSmG/V2hnMHwJDgwJTA0ql0ENrs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uytcqe020-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Sep 2019 14:34:15 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Sep 2019 14:33:59 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 14:33:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hes7G1d4HBAn1OanyCmP6YTug1UBxT4sl/UxO8QfOntEh1c7KNLXHdeyD8NmXrIs3x0Mq+HuBHhwAT08N7ffxX8FZLPKBA9B5fxPgJO5r6y/xvFNqlEuG93LF5Fuu2M5jVKNEH0yY4mo7cNLJ1LyJqqc1TkMGhwhrN7H+t4Vhw2IIdeFpFfRuqFq9hCSbslJ0RRjp+aRVpSbPdVLvU/3PMVmsm8qO1AFepGFtTzDvj5oQm/wgGffJckfwjXGmjBFJNxnGii3HPyXsL29pvmthdJRZQL2GVqGDDZgi3yYu6lPCqHB0kyWHO31Qj+82OdJQpkRMNywjYRR3IUnbK3F/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmTfHPl3zKHlwjYe8llbDM2hT14u3/aBGSn2/a3ehN4=;
 b=H3cNvXf0NNXQ2rjaLM+9Hge5sc7P4+KrMfUw8kAsxbIWgj7V9nuh5F9LrXCKLw6dYBgkwZRZQGEC9WDPxBz/69ZZkWgt2IWbAnoO11zYHS1E+6eSX/tlBjdafdNS43/tXTMYGmzB1aY59W/2ITx54/WNWzRTUp3p+mPy8ha+ArNAD2FBd/RKHj6raZ9cj5lRKw2pQCajR0eYH9huJRXrbM2YVn18mMkmHSuZvmCAfLzBMhtJ1BgABzX2LiTuDCW8Dlx4QHvwZQW5ZUjBEaRf7Mg/8xYHqs2Ei8v8qxD/HQcX2sY1j6R+RMuJUK11Flr1eXscRWEc5X7JcvzEOsGQUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmTfHPl3zKHlwjYe8llbDM2hT14u3/aBGSn2/a3ehN4=;
 b=EkXDfbRnt30B9gv73xWyZJK5bu0RFDYFlBuFPZ7Qd4BfNMZ2XhMkOK5xxEa9w8kRxsaQza0eKTNiLyz1DEGZKaj+607Indjlc3QHtLh2oi6ZznSGEyVcj6Ed2OAqBac956W+CHIq+NnjwumJUol4K/RvUMufG0Rz3AnzGma9kr0=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2421.namprd15.prod.outlook.com (52.135.197.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Fri, 13 Sep 2019 21:33:58 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2263.021; Fri, 13 Sep 2019
 21:33:58 +0000
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
Subject: Re: [PATCH bpf-next 07/11] samples: bpf: add makefile.prog for
 separate CC build
Thread-Topic: [PATCH bpf-next 07/11] samples: bpf: add makefile.prog for
 separate CC build
Thread-Index: AQHVZ8P7nMNMcmhFgkmUzoWLsT6rwqcqJloA
Date:   Fri, 13 Sep 2019 21:33:58 +0000
Message-ID: <1720c5a5-5c64-46a3-be2f-56b59614f82a@fb.com>
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
 <20190910103830.20794-8-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190910103830.20794-8-ivan.khoronzhuk@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR18CA0036.namprd18.prod.outlook.com
 (2603:10b6:320:31::22) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::ec5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b57c368a-a62c-4468-e9e8-08d7389215d8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2421;
x-ms-traffictypediagnostic: BYAPR15MB2421:
x-microsoft-antispam-prvs: <BYAPR15MB2421A10F4A5DEF7759BDCB35D3B30@BYAPR15MB2421.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(346002)(39860400002)(376002)(199004)(189003)(6246003)(5660300002)(66556008)(64756008)(316002)(102836004)(7416002)(52116002)(478600001)(11346002)(446003)(76176011)(2616005)(476003)(386003)(6506007)(8936002)(86362001)(2201001)(25786009)(486006)(31696002)(186003)(54906003)(110136005)(7736002)(305945005)(53546011)(14454004)(99286004)(46003)(8676002)(81156014)(81166006)(31686004)(14444005)(256004)(6116002)(71200400001)(71190400001)(6486002)(229853002)(6436002)(36756003)(53936002)(2501003)(6512007)(66946007)(4326008)(66476007)(2906002)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2421;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 92uGh3MQb2IQzwAI5bibV+IDrqkxy11x/Q3hw9szNdpx1oLAVWOpBT6xgugJVdjLXnmEQ1j6b4GGSuhBFQvai/DeOhJFaDje0vnQlQxrqyeUstnNWiEwTz63X57Ezv07IFFiJ0zkWkd2Lki5cYsntm7ocTt8+jYq77Si2TRhzVHwFOQ+lJisX9AmRrfF6/vF+tSIJk88d77P5BaaPSLcD7yhEp1EGK8Ga5gFkDeK43M7+T3qGQ01aKzEnZFja5nlkKNx2MFf6KjfiU+F1e7IB+mxfzF4N16ZHC7pdUDSbr97+afyyRXwG5waslc1pCeYjRHdAnv5OzChmV/saQk59K6X5Wo6R5cfDcOO84hGhyL0cD6C2eKOA0t0EVQA8Z61RXVT43etKXomezQBkl+Kh5IQ0LXfajgOoItwDmOhI/w=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB454A36118DD34993C9DF88CC3AC185@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b57c368a-a62c-4468-e9e8-08d7389215d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 21:33:58.2240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ghxaWA6+3eNquBKvSJFnnfCaTXn3flTeJEBhcSa2xBQxYTwkeQ5SrLIwCrMSNnRv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2421
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_10:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909130214
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTAvMTkgMTE6MzggQU0sIEl2YW4gS2hvcm9uemh1ayB3cm90ZToNCj4gVGhlIG1h
a2VmaWxlLnByb2cgaXMgYWRkZWQgb25seSwgd2lsbCBiZSB1c2VkIGluIHNhbXBsZS9icGYvTWFr
ZWZpbGUNCj4gbGF0ZXIgaW4gb3JkZXIgdG8gc3dpdGNoIGNyb3NzLWNvbXBpbGluZyBvbiBDQyBm
cm9tIEhPU1RDQy4NCj4gDQo+IFRoZSBIT1NUQ0MgaXMgc3VwcG9zZWQgdG8gYnVpbGQgYmluYXJp
ZXMgYW5kIHRvb2xzIHJ1bm5pbmcgb24gdGhlIGhvc3QNCj4gYWZ0ZXJ3YXJkcywgaW4gb3JkZXIg
dG8gc2ltcGxpZnkgYnVpbGQgb3Igc28sIGxpa2UgImZpeGRlcCIgb3IgZWxzZS4NCj4gSW4gY2Fz
ZSBvZiBjcm9zcyBjb21waWxpbmcgImZpeGRlcCIgaXMgZXhlY3V0ZWQgb24gaG9zdCB3aGVuIHRo
ZSByZXN0DQo+IHNhbXBsZXMgc2hvdWxkIHJ1biBvbiB0YXJnZXQgYXJjaC4gSW4gb3JkZXIgdG8g
YnVpbGQgYmluYXJpZXMgZm9yDQo+IHRhcmdldCBhcmNoIHdpdGggQ0MgYW5kIHRvb2xzIHJ1bm5p
bmcgb24gaG9zdCB3aXRoIEhPU1RDQywgbGV0cyBhZGQNCj4gTWFrZWZpbGUucHJvZyBmb3Igc2lt
cGxpY2l0eSwgaGF2aW5nIGRlZmluaXRpb24gYW5kIHJvdXRpbmVzIHNpbWlsYXINCj4gdG8gb25l
cywgdXNlZCBpbiBzY3JpcHQvTWFrZWZpbGUuaG9zdC4gVGhpcyBhbGxvd3MgbGF0ZXIgYWRkDQo+
IGNyb3NzLWNvbXBpbGF0aW9uIHRvIHNhbXBsZXMvYnBmIHdpdGggbWluaW11bSBjaGFuZ2VzLg0K
DQpTbyB0aGlzIGlzIHJlYWxseSBNYWtlZmlsZS5ob3N0IG9yIE1ha2VmaWxlLnVzZXIsIHJpZ2h0
Pw0KSW4gQlBGLCAncHJvZycgY2FuIHJlZmVycyB0byB1c2VyIHByb2cgb3IgYnBmIHByb2cuDQpU
byBhdm9pZCBhbWJpZ3VpdHksIG1heWJlIE1ha2VmaWxlLmhvc3Q/DQoNCj4gDQo+IE1ha2VmaWxl
LnByb2cgY29udGFpbnMgb25seSBzdHVmZiBuZWVkZWQgZm9yIHNhbXBsZXMvYnBmLCBwb3RlbnRp
YWxseQ0KPiBjYW4gYmUgcmV1c2VkIGFuZCBleHRlbmRlZCBmb3Igb3RoZXIgcHJvZyBzZXRzIGxh
dGVyIGFuZCBub3cgbmVlZGVkDQoNCldoYXQgZG8geW91IG1lYW4gJ2V4dGVuZGVkIGZvciBvdGhl
ciBwcm9nIHNldHMnPyBJIGFtIHdvbmRlcmluZyB3aGV0aGVyDQp3ZSBjb3VsZCBqdXN0IGluY2x1
ZGUgJ3NjcmlwdHMvTWFrZWZpbGUuaG9zdCc/IEhvdyBoYXJkIGl0IGlzPw0KDQo+IG9ubHkgZm9y
IHVuYmxvY2tpbmcgdHJpY2t5IHNhbXBsZXMvYnBmIGNyb3NzIGNvbXBpbGF0aW9uLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogSXZhbiBLaG9yb256aHVrIDxpdmFuLmtob3JvbnpodWtAbGluYXJvLm9y
Zz4NCj4gLS0tDQo+ICAgc2FtcGxlcy9icGYvTWFrZWZpbGUucHJvZyB8IDc3ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA3NyBpbnNl
cnRpb25zKCspDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IHNhbXBsZXMvYnBmL01ha2VmaWxlLnBy
b2cNCj4gDQo+IGRpZmYgLS1naXQgYS9zYW1wbGVzL2JwZi9NYWtlZmlsZS5wcm9nIGIvc2FtcGxl
cy9icGYvTWFrZWZpbGUucHJvZw0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAw
MDAwMDAwMDAuLjM3ODE5OTliOTE5Mw0KPiAtLS0gL2Rldi9udWxsDQo+ICsrKyBiL3NhbXBsZXMv
YnBmL01ha2VmaWxlLnByb2cNCj4gQEAgLTAsMCArMSw3NyBAQA0KPiArIyBTUERYLUxpY2Vuc2Ut
SWRlbnRpZmllcjogR1BMLTIuMA0KPiArIyA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiArIyBCdWlsZGlu
ZyBiaW5hcmllcyBvbiB0aGUgaG9zdCBzeXN0ZW0NCj4gKyMgQmluYXJpZXMgYXJlIG5vdCB1c2Vk
IGR1cmluZyB0aGUgY29tcGlsYXRpb24gb2YgdGhlIGtlcm5lbCwgYW5kIGludGVuZGVudA0KPiAr
IyB0byBiZSBidWlsZCBmb3IgdGFyZ2V0IGJvYXJkLCB0YXJnZXQgYm9hcmQgY2FuIGJlIGhvc3Qg
b2ZjLiBBZGRlZCB0byBidWlsZA0KPiArIyBiaW5hcmllcyB0byBydW4gbm90IG9uIGhvc3Qgc3lz
dGVtLg0KPiArIw0KPiArIyBPbmx5IEMgaXMgc3VwcG9ydGVkLCBidXQgY2FuIGJlIGV4dGVuZGVk
IGZvciBDKysuDQoNClRoZSBhYm92ZSBjb21tZW50IGlzIG5vdCBuZWVkZWQuDQpzYW1wbGVzL2Jw
Zi8gb25seSBoYXZlIEMgbm93LiBJIGFtIHdvbmRlcmluZyB3aGV0aGVyIHlvdXIgYmVsb3cgc2Ny
aXB0cyANCmNhbiBiZSBzaW1wbGlmaWVkLCBlLmcuLCByZW1vdmluZyBjeHhvYmpzLg0KDQo+ICsj
DQo+ICsjIFNhbXBsZSBzeW50YXggKHNlZSBEb2N1bWVudGF0aW9uL2tidWlsZC9tYWtlZmlsZXMu
cnN0IGZvciByZWZlcmVuY2UpDQo+ICsjIHByb2dzLXkgOj0geHNrX2V4YW1wbGUNCj4gKyMgV2ls
bCBjb21waWxlIHhkcHNvY2tfZXhhbXBsZS5jIGFuZCBjcmVhdGUgYW4gZXhlY3V0YWJsZSBuYW1l
ZCB4c2tfZXhhbXBsZQ0KPiArIw0KPiArIyBwcm9ncy15ICAgIDo9IHhkcHNvY2sNCj4gKyMgeGRw
c29jay1vYmpzIDo9IHhkcHNvY2tfMS5vIHhkcHNvY2tfMi5vDQo+ICsjIFdpbGwgY29tcGlsZSB4
ZHBzb2NrXzEuYyBhbmQgeGRwc29ja18yLmMsIGFuZCB0aGVuIGxpbmsgdGhlIGV4ZWN1dGFibGUN
Cj4gKyMgeGRwc29jaywgYmFzZWQgb24geGRwc29ja18xLm8gYW5kIHhkcHNvY2tfMi5vDQo+ICsj
DQo+ICsjIEluaGVyaXRlZCBmcm9tIHNjcmlwdHMvTWFrZWZpbGUuaG9zdA0KPiArIw0KPiArX19w
cm9ncyA6PSAkKHNvcnQgJChwcm9ncy15KSkNCj4gKw0KPiArIyBDIGNvZGUNCj4gKyMgRXhlY3V0
YWJsZXMgY29tcGlsZWQgZnJvbSBhIHNpbmdsZSAuYyBmaWxlDQo+ICtwcm9nLWNzaW5nbGUJOj0g
JChmb3JlYWNoIG0sJChfX3Byb2dzKSwgXA0KPiArCQkJJChpZiAkKCQobSktb2JqcykkKCQobSkt
Y3h4b2JqcyksLCQobSkpKQ0KPiArDQo+ICsjIEMgZXhlY3V0YWJsZXMgbGlua2VkIGJhc2VkIG9u
IHNldmVyYWwgLm8gZmlsZXMNCj4gK3Byb2ctY211bHRpCTo9ICQoZm9yZWFjaCBtLCQoX19wcm9n
cyksXA0KPiArCQkgICAkKGlmICQoJChtKS1jeHhvYmpzKSwsJChpZiAkKCQobSktb2JqcyksJCht
KSkpKQ0KPiArDQo+ICsjIE9iamVjdCAoLm8pIGZpbGVzIGNvbXBpbGVkIGZyb20gLmMgZmlsZXMN
Cj4gK3Byb2ctY29ianMJOj0gJChzb3J0ICQoZm9yZWFjaCBtLCQoX19wcm9ncyksJCgkKG0pLW9i
anMpKSkNCj4gKw0KPiArcHJvZy1jc2luZ2xlCTo9ICQoYWRkcHJlZml4ICQob2JqKS8sJChwcm9n
LWNzaW5nbGUpKQ0KPiArcHJvZy1jbXVsdGkJOj0gJChhZGRwcmVmaXggJChvYmopLywkKHByb2ct
Y211bHRpKSkNCj4gK3Byb2ctY29ianMJOj0gJChhZGRwcmVmaXggJChvYmopLywkKHByb2ctY29i
anMpKQ0KPiArDQo+ICsjIyMjIw0KPiArIyBIYW5kbGUgb3B0aW9ucyB0byBnY2MuIFN1cHBvcnQg
YnVpbGRpbmcgd2l0aCBzZXBhcmF0ZSBvdXRwdXQgZGlyZWN0b3J5DQo+ICsNCj4gK19wcm9nY19m
bGFncyAgID0gJChQUk9HU19DRkxBR1MpIFwNCj4gKyAgICAgICAgICAgICAgICAgJChQUk9HQ0ZM
QUdTXyQoYmFzZXRhcmdldCkubykNCj4gKw0KPiArIyAkKG9ianRyZWUpLyQob2JqKSBmb3IgaW5j
bHVkaW5nIGdlbmVyYXRlZCBoZWFkZXJzIGZyb20gY2hlY2tpbiBzb3VyY2UgZmlsZXMNCj4gK2lm
ZXEgKCQoS0JVSUxEX0VYVE1PRCksKQ0KPiAraWZkZWYgYnVpbGRpbmdfb3V0X29mX3NyY3RyZWUN
Cj4gK19wcm9nY19mbGFncyAgICs9IC1JICQob2JqdHJlZSkvJChvYmopDQo+ICtlbmRpZg0KPiAr
ZW5kaWYNCj4gKw0KPiArcHJvZ2NfZmxhZ3MgICAgPSAtV3AsLU1ELCQoZGVwZmlsZSkgJChfcHJv
Z2NfZmxhZ3MpDQo+ICsNCj4gKyMgQ3JlYXRlIGV4ZWN1dGFibGUgZnJvbSBhIHNpbmdsZSAuYyBm
aWxlDQo+ICsjIHByb2ctY3NpbmdsZSAtPiBFeGVjdXRhYmxlDQo+ICtxdWlldF9jbWRfcHJvZy1j
c2luZ2xlIAk9IENDICAkQA0KPiArICAgICAgY21kX3Byb2ctY3NpbmdsZQk9ICQoQ0MpICQocHJv
Z2NfZmxhZ3MpICQoUFJPR1NfTERGTEFHUykgLW8gJEAgJDwgXA0KPiArCQkkKFBST0dTX0xETElC
UykgJChQUk9HTERMSUJTXyQoQEYpKQ0KPiArJChwcm9nLWNzaW5nbGUpOiAkKG9iaikvJTogJChz
cmMpLyUuYyBGT1JDRQ0KPiArCSQoY2FsbCBpZl9jaGFuZ2VkX2RlcCxwcm9nLWNzaW5nbGUpDQo+
ICsNCj4gKyMgTGluayBhbiBleGVjdXRhYmxlIGJhc2VkIG9uIGxpc3Qgb2YgLm8gZmlsZXMsIGFs
bCBwbGFpbiBjDQo+ICsjIHByb2ctY211bHRpIC0+IGV4ZWN1dGFibGUNCj4gK3F1aWV0X2NtZF9w
cm9nLWNtdWx0aQk9IExEICAkQA0KPiArICAgICAgY21kX3Byb2ctY211bHRpCT0gJChDQykgJChw
cm9nY19mbGFncykgJChQUk9HU19MREZMQUdTKSAtbyAkQCBcDQo+ICsJCQkgICQoYWRkcHJlZml4
ICQob2JqKS8sJCgkKEBGKS1vYmpzKSkgXA0KPiArCQkJICAkKFBST0dTX0xETElCUykgJChQUk9H
TERMSUJTXyQoQEYpKQ0KPiArJChwcm9nLWNtdWx0aSk6ICQocHJvZy1jb2JqcykgRk9SQ0UNCj4g
KwkkKGNhbGwgaWZfY2hhbmdlZCxwcm9nLWNtdWx0aSkNCj4gKyQoY2FsbCBtdWx0aV9kZXBlbmQs
ICQocHJvZy1jbXVsdGkpLCAsIC1vYmpzKQ0KPiArDQo+ICsjIENyZWF0ZSAubyBmaWxlIGZyb20g
YSBzaW5nbGUgLmMgZmlsZQ0KPiArIyBwcm9nLWNvYmpzIC0+IC5vDQo+ICtxdWlldF9jbWRfcHJv
Zy1jb2Jqcwk9IENDICAkQA0KPiArICAgICAgY21kX3Byb2ctY29ianMJPSAkKENDKSAkKHByb2dj
X2ZsYWdzKSAtYyAtbyAkQCAkPA0KPiArJChwcm9nLWNvYmpzKTogJChvYmopLyUubzogJChzcmMp
LyUuYyBGT1JDRQ0KPiArCSQoY2FsbCBpZl9jaGFuZ2VkX2RlcCxwcm9nLWNvYmpzKQ0KPiANCg==
