Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E508A123DE6
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 04:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfLRD1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 22:27:49 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30110 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726454AbfLRD1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 22:27:48 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBI3MW1s031020;
        Tue, 17 Dec 2019 19:27:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7i+vH4EqL9jLDE5qESg/FqO7ppQ1iyRhCkntPpWyzXo=;
 b=bOaA1n98J7wAT4AEDCiWbEF0S+ZjfWdVnXXCcdyckRaSylMliAoMxB2kGD8RO48e5O1g
 wCUQuRJ8wWiD3IdKpp+h0XwaueZB0gdgGlJcrm0KtCGaNwzoISJnWE52h0z/q7GWLtyj
 e/ZryHuMosQ1h5QoQXnonCCGy7hfDazXYIw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wy97ugp8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 19:27:35 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 17 Dec 2019 19:27:35 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 19:27:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0XO0UjVHyi0HQ2wcGBPSQWt0IA/JdfWfCz+itss0EzEs9DBmd/JtL1Y/cZ31szZd4VOLlkWvRYOnPPXEV/zgMCudZxO7bCRTv3+Nsoq9h1Yx0Yr2HJWahg1YzvdebwmsTOV61uen5FUXoYOpsl2w34H2EkDoJmVM0ehaarMjxCGodmkNRjElQ6uCk9pGFn2w+eNM0Wf3CE9Wqwc5CNkyacYY9MEIInz4f/eS330wp7Vy990bDsmKE1GjHG88UoYkeNfYkjnTuCR6d4rQd+gDryhHr9BolVkZj4KcN4odg8k+tAn3+JHo/uXDPYhrdN+Pkh2VbrPCBS5ULMzeAS3xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7i+vH4EqL9jLDE5qESg/FqO7ppQ1iyRhCkntPpWyzXo=;
 b=K/5jbpAKQ9Pb5Wcv2UBzqzzbK2LHPAcDp19bAeA7swXFo9B+QJ2wfv19hiPwET1Y3PPgiOdP9ivPplnBh8ymSHAnMNqES6UcRlxXLmFQ3h2d8KWIAfrRIbV91wg35sHTAhBnL1nHMMTVE6UxWsouT17GuVt4ytXluaKFymef02Max+PfbGYgSQfgrRoH1dPdBNYj/l5aFunk+pfqfI4R55bZ3WkAnY6oHPW1N9xe5TW+ahEbrQ0/YRqL6B0Naj6W2Y1X9ktx4UCYr0N/91l2mFDS5NtQMvD59edwfqJoBsEGERmugVBQfOZJ2Zh/JV0Cp8Jc6oW8dIsWhYT8Qyw3rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7i+vH4EqL9jLDE5qESg/FqO7ppQ1iyRhCkntPpWyzXo=;
 b=SlMBcYDflYP9gFztF4DlvwENaWILmMOIyGp+O6doPqG0IJzGOBJBxTOm2R5tTncAOHQgxYgI2X1py9kjqe4mzeMBV1oJrR42G0MoAHm50EH5wLkplPl7Q6GOxoFXgjLPguOk6x4S8pNVcEkYzmaT90uz5fQOQ0RRksMfbBg2uu8=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1498.namprd15.prod.outlook.com (10.173.225.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 03:27:34 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 03:27:34 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Wenbo Zhang <ethercflow@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bgregg@netflix.com" <bgregg@netflix.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v14 2/2] selftests/bpf: test for
 bpf_get_fd_path() from tracepoint
Thread-Topic: [PATCH bpf-next v14 2/2] selftests/bpf: test for
 bpf_get_fd_path() from tracepoint
Thread-Index: AQHVtT4JIehlh30fqEKJbHHzx9GEZqe/O62A
Date:   Wed, 18 Dec 2019 03:27:34 +0000
Message-ID: <aa49d165-46d7-ea02-6e7c-b1bb4bfcff7b@fb.com>
References: <cover.1576629200.git.ethercflow@gmail.com>
 <69db5602f3cb4f17b4f1b26c47db5bf817851ded.1576629200.git.ethercflow@gmail.com>
In-Reply-To: <69db5602f3cb4f17b4f1b26c47db5bf817851ded.1576629200.git.ethercflow@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR18CA0045.namprd18.prod.outlook.com
 (2603:10b6:320:31::31) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::7745]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1207bb1-60f0-4db9-83dd-08d7836a38df
x-ms-traffictypediagnostic: DM5PR15MB1498:
x-microsoft-antispam-prvs: <DM5PR15MB14988D7DEEE07716A8E3C33ED3530@DM5PR15MB1498.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(346002)(376002)(366004)(199004)(189003)(31686004)(110136005)(52116002)(6506007)(8936002)(36756003)(6486002)(6512007)(186003)(53546011)(4326008)(8676002)(2616005)(316002)(81166006)(54906003)(81156014)(2906002)(31696002)(478600001)(5660300002)(66946007)(66446008)(64756008)(66556008)(66476007)(86362001)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1498;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9pkw5LHHjZE/kBuxCtICZIyTtTe8QAwolkU+d5nwMyMiRtgoPLcB6urp0SFO8+YDl5y5pne1f92sotO7+AxXxjnoLrhkDInx+mDii9GFdoGLhAD2HZ5vOg1fSZMst1AqqkGCYg0E2zSO2aSXSrznhdg+PQPnPdLlluZgHu5MBufIx1NSjyz7JzgYc6CkDP4DsJAebcHOI3P2EYTcHGe+TMM6tTy/eMy2yEJ3BdJutLRIPzyhluL0Q0QCOheUhnRiiWIh5rfKSw6Gx1ZxMY+/Xj/PRfuEPp3KXNXK4H//hq2k1SnierhHDf6a1sLZMfpS7iqdrE8n1EbYrswoyUMSbjMc4AxMfQW3RXkTicK/HHGHP8OPxLTdpfkEsttPnA+NF8J0HIPptGsV9lY8Bg/1Xl9y+FbqfK54oe6hiD/tFrsz/6Gp6RfM0ZSO2IMFQdXs
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C75F09DC7D893143B0EBB5CC3854D242@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a1207bb1-60f0-4db9-83dd-08d7836a38df
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 03:27:34.3167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8RsW4q/QXQ7OZrXdXUuWXaBW0fRAszDqWm7zakXTczKVKzAkVLtYjA9TN1YCbmqF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1498
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_05:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=996 lowpriorityscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912180023
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE3LzE5IDQ6NTYgUE0sIFdlbmJvIFpoYW5nIHdyb3RlOg0KPiB0cmFjZSBmc3Rh
dCBldmVudHMgYnkgdHJhY2Vwb2ludCBzeXNjYWxscy9zeXNfZW50ZXJfbmV3ZnN0YXQsIGFuZCBo
YW5kbGUNCj4gZXZlbnRzIG9ubHkgcHJvZHVjZWQgYnkgdGVzdF9maWxlX2ZkX3BhdGgsIHdoaWNo
IGNhbGwgZnN0YXQgb24gc2V2ZXJhbA0KPiBkaWZmZXJlbnQgdHlwZXMgb2YgZmlsZXMgdG8gdGVz
dCBicGZfZmRfZmlsZV9wYXRoJ3MgZmVhdHVyZS4NCj4gDQo+IHY1LT52NjogYWRkcmVzc2VkIEdy
ZWdnIGFuZCBZb25naG9uZydzIGZlZWRiYWNrDQo+IC0gcmVuYW1lIHRvIGdldF9mZF9wYXRoDQo+
IC0gY2hhbmdlIHN5c19lbnRlcl9uZXdmc3RhdF9hcmdzJ3MgZmQgdHlwZSB0byBsb25nIHRvIGZp
eCBpc3N1ZSBvbg0KPiBiaWctZW5kaWFuIG1hY2hpbmVzDQo+IA0KPiB2NC0+djU6IGFkZHJlc3Nl
ZCBBbmRyaWkncyBmZWVkYmFjaw0KPiAtIHBhc3MgTlVMTCBmb3Igb3B0cyBhcyBicGZfb2JqZWN0
X19vcGVuX2ZpbGUncyBQQVJBTTIsIGFzIG5vdCByZWFsbHkNCj4gdXNpbmcgYW55DQo+IC0gbW9k
aWZ5IHBhdGNoIHN1YmplY3QgdG8ga2VlcCB1cCB3aXRoIHRlc3QgY29kZQ0KPiAtIGFzIHRoaXMg
dGVzdCBpcyBzaW5nbGUtdGhyZWFkZWQsIHNvIHVzZSBnZXRwaWQgaW5zdGVhZCBvZiBTWVNfZ2V0
dGlkDQo+IC0gcmVtb3ZlIHVubmVjZXNzYXJ5IHBhcmVucyBhcm91bmQgY2hlY2sgd2hpY2ggYWZ0
ZXIgaWYgKGkgPCAzKQ0KPiAtIGluIGtlcm4gdXNlIGJwZl9nZXRfY3VycmVudF9waWRfdGdpZCgp
ID4+IDMyIHRvIGZpdCBnZXRwaWQoKSBpbg0KPiB1c2Vyc3BhY2UgcGFydA0KPiAtIHdpdGggdGhl
IHBhdGNoIGFkZGluZyBoZWxwZXIgYXMgb25lIHBhdGNoIHNlcmllcw0KPiANCj4gdjMtPnY0OiBh
ZGRyZXNzZWQgQW5kcmlpJ3MgZmVlZGJhY2sNCj4gLSB1c2UgYSBzZXQgb2YgZmQgaW5zdGVhZCBv
ZiBmZHMgYXJyYXkNCj4gLSB1c2UgZ2xvYmFsIHZhcmlhYmxlcyBpbnN0ZWFkIG9mIG1hcHMgKGlu
IHYzLCBJIG1pc3Rha2VubHkgdGhvdWdodCB0aGF0DQo+IHRoZSBicGYgbWFwcyBhcmUgZ2xvYmFs
IHZhcmlhYmxlcy4pDQo+IC0gcmVtb3ZlIHVuY2Vzc2FyeSBnbG9iYWwgdmFyaWFibGUgcGF0aF9p
bmZvX2luZGV4DQo+IC0gcmVtb3ZlIGZkIGNvbXBhcmUgYXMgdGhlIGZzdGF0J3Mgb3JkZXIgaXMg
Zml4ZWQNCj4gDQo+IHYyLT52MzogYWRkcmVzc2VkIEFuZHJpaSdzIGZlZWRiYWNrDQo+IC0gdXNl
IGdsb2JhbCBkYXRhIGluc3RlYWQgb2YgcGVyZl9idWZmZXIgdG8gc2ltcGxpZmllZCBjb2RlDQo+
IA0KPiB2MS0+djI6IGFkZHJlc3NlZCBEYW5pZWwncyBmZWVkYmFjaw0KPiAtIHJlbmFtZSBicGZf
ZmQycGF0aCB0byBicGZfZ2V0X2ZpbGVfcGF0aCB0byBiZSBjb25zaXN0ZW50IHdpdGggb3RoZXIN
Cj4gaGVscGVyJ3MgbmFtZXMNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFdlbmJvIFpoYW5nIDxldGhl
cmNmbG93QGdtYWlsLmNvbT4NCg0KQWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+
DQo=
