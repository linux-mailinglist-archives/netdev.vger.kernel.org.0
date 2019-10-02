Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 435FEC8E60
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfJBQ33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:29:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39966 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbfJBQ32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:29:28 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x92GOVrm009486;
        Wed, 2 Oct 2019 09:29:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ucIlUSGzatolV/CCe86yGBwq3N/RgD63RCaceS12Uy8=;
 b=iu7XR4CQOK3aPN9x4IVnWX8TDbnlg4CVlQk7R/OmLZ/j0r2KWeyxxNlRIkg5OdivwhdU
 1wsHQPs6qvI44fr7UBAb6LOST020OmNge4lmbpKWJqCGcGVH2oM6kQZiBK+jGox60knc
 U8Qj+7lJaunCHfT6MxBI29wX1LGbk24T83Y= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vcen4434t-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Oct 2019 09:29:12 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 2 Oct 2019 09:28:50 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 2 Oct 2019 09:28:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KluBPwH9rLB5ytxKXVL0h58zG2PvZ2zSL6BLQAimv+VPKTef9uk8Un405V8HyvkePA6mFvlN+Pju1ylI8x6WA/vYd3PEzy9l24kCbCuCuX1tY3VpI46n9ABt2lCOsZ49EAme+cG7Yl9Rgs5CYAMxAcd9Sit7Iho8BlJE8/zvAmRY2MGwRHKG/wvtjWDQNV8GnXd6pEIgTwXTOEZVKnja67bMH1X5Tj/Zoq5BFmoDWKCSIcXwqp4qP4qb9+B6mnHdl1hTwkdfvkJS2SlXaR93bdF17s1SJiDl6nvoExJDZ2XfdRP0EhtzS1gicLWBAWmnb/qCC7a1JzQnzYR7tsH6dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ucIlUSGzatolV/CCe86yGBwq3N/RgD63RCaceS12Uy8=;
 b=GOi/QnBsfIVY5SQ0bVm4u28ZHSHPgwgd6svMvMZCsyzrtjntz+FahztmhouhUfZRrLFnN4dsKPXzHZDAqkO9uojQo5eMAnF7btJELGU4whDYW2gSBMWXTyFn7JS6FQ9QNR297sEcN0kfedM78LR0mHZSqY20o/HWBu4vOuqQZpZj4h/VY/eBpz/Sa8ZYngBWw/v5hcTthX51mj1aQEimJc5RHbKzT0aZWmLwVawWEwRGUyl7vlzgbflN81q5GKgwwJr+V1kdIxLkVB35eRyuJdasetJzUxjy/wi7oIg4mGk+mNCFKCgh7EMOnHE3gYBihjIyQWm4vUK3+K04OGKtjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ucIlUSGzatolV/CCe86yGBwq3N/RgD63RCaceS12Uy8=;
 b=Gn6izt4UPUkBmChA+r7D/2dlKOMRZaTFRmsqt0XmTcpqNRqygTpMb1FUdkll22MF47MzRtQoEMER9llj33DSHdQS4DBYPUc2wilBzd6OoL+eW45TkBrXPyrwEvW4RdOrTaoGtD0ZoxHe/N0U0d5Q66GEyfdUu4GQNPhEcYe7oBU=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1294.namprd15.prod.outlook.com (10.175.3.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.18; Wed, 2 Oct 2019 16:28:48 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.022; Wed, 2 Oct 2019
 16:28:48 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
CC:     "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: correct path to include msg +
 path
Thread-Topic: [PATCH bpf-next 2/2] selftests/bpf: correct path to include msg
 + path
Thread-Index: AQHVeRmIJK9O2PZTNUal3Rd8mzrRf6dHiruA
Date:   Wed, 2 Oct 2019 16:28:47 +0000
Message-ID: <CB640650-0E50-49DA-8264-9C02D5B1A7A2@fb.com>
References: <20191002120404.26962-1-ivan.khoronzhuk@linaro.org>
 <20191002120404.26962-3-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20191002120404.26962-3-ivan.khoronzhuk@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::2338]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20f761b2-cb9b-40d9-5b3a-08d747559a2c
x-ms-traffictypediagnostic: MWHPR15MB1294:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB12945BD97E1ECE90DC2073BAB39C0@MWHPR15MB1294.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:497;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(346002)(366004)(376002)(39860400002)(199004)(189003)(52314003)(2616005)(14454004)(6916009)(6512007)(99286004)(478600001)(4326008)(33656002)(76116006)(7736002)(66446008)(5660300002)(66946007)(305945005)(64756008)(66476007)(66556008)(36756003)(6246003)(6116002)(81166006)(81156014)(50226002)(2906002)(446003)(6486002)(46003)(8936002)(11346002)(476003)(8676002)(486006)(316002)(186003)(54906003)(71190400001)(71200400001)(229853002)(14444005)(6506007)(256004)(25786009)(76176011)(6436002)(102836004)(86362001)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1294;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NXjt9iVapFXXgiHMZyWOd6M9s+SfX7k+rjxYbkSybv6D+QFP5WuWbaBVNyBVY5+MaEsUGIOuGTIdAJIM4VLvb3RMnwrj62KpXMu1noyFQYP59tfs8YxRorggpDiE0hCBdXYX5uuicX6B/5XFLIU0ZTOApiuW9V6FLdIovHg61teBg8ngTahbCebE4AkOejs/ShonIo9dpIlixLcv3bai3/WHYBAtwAjQoMWTcgg++2Eb5d9QU0/R6U5GaTEF9R8aopfRoJ8mHxsiOhtecgPB8DnzVxdrkIDNqRV0xEFB37Uq7lqIcB6y2lAowpbCbSAulMQQApkJ0/hqMYbx4A7QiR1Bt1/WXaHi/Z4SekWLRDPfRpNBFItSrGFPqET1k87CPRt8zB7FAqVNS2q4JiCUKwBo89UFQnZFTFgUICaBcnQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2FBD3FC9168DF84BB20AD2196CAD24B3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 20f761b2-cb9b-40d9-5b3a-08d747559a2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 16:28:47.9425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7nXDa9pL4n1WPoJdiow/yjJM7f746sNSbs0rPjXqbhAj4saR7/BuQqQrb3SjzrmvA25quJxq1ZdTLdrxtWyjiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1294
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-02_07:2019-10-01,2019-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 adultscore=0 clxscore=1015 spamscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910020143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gT2N0IDIsIDIwMTksIGF0IDU6MDQgQU0sIEl2YW4gS2hvcm9uemh1ayA8aXZhbi5r
aG9yb256aHVrQGxpbmFyby5vcmc+IHdyb3RlOg0KPiANCj4gVGhlICJwYXRoIiBidWYgaXMgc3Vw
cG9zZWQgdG8gY29udGFpbiBwYXRoICsgcHJpbnRmIG1zZyB1cCB0byAyNCBieXRlcy4NCj4gSXQg
d2lsbCBiZSBjdXQgYW55d2F5LCBidXQgY29tcGlsZXIgZ2VuZXJhdGVzIHRydW5jYXRpb24gd2Fy
bnMgbGlrZToNCj4gDQo+ICINCj4gc2FtcGxlcy9icGYvLi4vLi4vdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvYnBmL2Nncm91cF9oZWxwZXJzLmM6IEluDQo+IGZ1bmN0aW9uIOKAmHNldHVwX2Nncm91
cF9lbnZpcm9ubWVudOKAmToNCj4gc2FtcGxlcy9icGYvLi4vLi4vdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvYnBmL2Nncm91cF9oZWxwZXJzLmM6NTI6MzQ6DQo+IHdhcm5pbmc6IOKAmC9jZ3JvdXAu
Y29udHJvbGxlcnPigJkgZGlyZWN0aXZlIG91dHB1dCBtYXkgYmUgdHJ1bmNhdGVkDQo+IHdyaXRp
bmcgMTkgYnl0ZXMgaW50byBhIHJlZ2lvbiBvZiBzaXplIGJldHdlZW4gMSBhbmQgNDA5Nw0KPiBb
LVdmb3JtYXQtdHJ1bmNhdGlvbj1dDQo+IHNucHJpbnRmKHBhdGgsIHNpemVvZihwYXRoKSwgIiVz
L2Nncm91cC5jb250cm9sbGVycyIsIGNncm91cF9wYXRoKTsNCj4gCQkJCSAgXn5+fn5+fn5+fn5+
fn5+fn5+fg0KPiBzYW1wbGVzL2JwZi8uLi8uLi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYv
Y2dyb3VwX2hlbHBlcnMuYzo1MjoyOg0KPiBub3RlOiDigJhzbnByaW50ZuKAmSBvdXRwdXQgYmV0
d2VlbiAyMCBhbmQgNDExNiBieXRlcyBpbnRvIGEgZGVzdGluYXRpb24NCj4gb2Ygc2l6ZSA0MDk3
DQo+IHNucHJpbnRmKHBhdGgsIHNpemVvZihwYXRoKSwgIiVzL2Nncm91cC5jb250cm9sbGVycyIs
IGNncm91cF9wYXRoKTsNCj4gXn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQo+IHNhbXBsZXMvYnBmLy4uLy4uL3Rvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2JwZi9jZ3JvdXBfaGVscGVycy5jOjcyOjM0Og0KPiB3YXJuaW5nOiDi
gJgvY2dyb3VwLnN1YnRyZWVfY29udHJvbOKAmSBkaXJlY3RpdmUgb3V0cHV0IG1heSBiZSB0cnVu
Y2F0ZWQNCj4gd3JpdGluZyAyMyBieXRlcyBpbnRvIGEgcmVnaW9uIG9mIHNpemUgYmV0d2VlbiAx
IGFuZCA0MDk3DQo+IFstV2Zvcm1hdC10cnVuY2F0aW9uPV0NCj4gc25wcmludGYocGF0aCwgc2l6
ZW9mKHBhdGgpLCAiJXMvY2dyb3VwLnN1YnRyZWVfY29udHJvbCIsDQo+IAkJCQkgIF5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+DQo+IGNncm91cF9wYXRoKTsNCj4gc2FtcGxlcy9icGYvLi4vLi4vdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL2Nncm91cF9oZWxwZXJzLmM6NzI6MjoNCj4gbm90ZTog
4oCYc25wcmludGbigJkgb3V0cHV0IGJldHdlZW4gMjQgYW5kIDQxMjAgYnl0ZXMgaW50byBhIGRl
c3RpbmF0aW9uDQo+IG9mIHNpemUgNDA5Nw0KPiBzbnByaW50ZihwYXRoLCBzaXplb2YocGF0aCks
ICIlcy9jZ3JvdXAuc3VidHJlZV9jb250cm9sIiwNCj4gY2dyb3VwX3BhdGgpOw0KPiAiDQo+IA0K
PiBJbiBvcmRlciB0byBhdm9pZCB3YXJucywgbGV0cyBkZWNyZWFzZSBidWYgc2l6ZSBmb3IgY2dy
b3VwIHdvcmtkaXIgb24NCj4gMjQgYnl0ZXMgd2l0aCBhc3N1bXB0aW9uIHRvIGluY2x1ZGUgYWxz
byAiL2Nncm91cC5zdWJ0cmVlX2NvbnRyb2wiIHRvDQo+IHRoZSBhZGRyZXNzLiBUaGUgY3V0IHdp
bGwgbmV2ZXIgaGFwcGVuIGFueXdheS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEl2YW4gS2hvcm9u
emh1ayA8aXZhbi5raG9yb256aHVrQGxpbmFyby5vcmc+DQoNCg0KQWNrZWQtYnk6IFNvbmcgTGl1
IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+IA0KDQo=
