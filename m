Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5995F123DE4
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 04:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfLRD13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 22:27:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36704 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726402AbfLRD12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 22:27:28 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBI3QfdE027550;
        Tue, 17 Dec 2019 19:27:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tXId3qF0RrcD0tdz6TUAD+IC+q6fHcYb54PKjOnEDdk=;
 b=aOrZm6nBTaVeXCIqvvPHvjCAlMjU9NOYinFtnIkWs6bccaknBM+k2P+w/gJhGJk6je7u
 nqPjR9PSQtw0a28w6NXuyTKRSSGASE57PO2l/tAy85BkfkAmdfxYnZxx/+dGTRMlF0Of
 ST5KNuUDf1Gpe53pUwtWfTsI+dcI7HxJKCM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxhkr6xpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 19:27:12 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 17 Dec 2019 19:27:11 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 19:27:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/6pKVdGhDgna1Rc4GJnveriQN+kBQ+a/kv1YiYayg/ZgSc5PdmPBLywexo8SNv/LM0Z4IRV2x7n1JW9cBc9iGNwFeV5OoaWikH6x1TkktoQoRhr1sagvfeUesBXRnQ1j7M6lMKyegZF99+A3168cKuo1MVHblb/iOiwf7htu4NhTx9dozolUaFQPUt7VHQsS3W8FlxosPM1m1X4iHIsbd/pXVxq93Zgf3R9XkhYy0v/6RS0u68r1XwxxDrQ6Ld5xCHNe/WmQRHL14QRHMoiRLJ/CgDbC03NCp2GE2jG4RdepG1nvQ78ddE0T+uk/uIiigdLTXXK3RCWK1N7c5cM1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXId3qF0RrcD0tdz6TUAD+IC+q6fHcYb54PKjOnEDdk=;
 b=DfB+XRDYtO+vL/dEayJZtYQSEr1cG5b0jK6K711zO1R/dOMq2c0c5UjdCXqIrP1KQmmhA8o0plavziKcmwidXzmKp/7TkCt1Ni8i/Ora0QurRbreOEVNwdVPT4yycJpPnVEOY+GM6C53HJ4iMLhoD3vtEjBPtYXNGexmYLzJzYFI3h0qhQCvpQyEoutGpvCdS6xqYiejy/C3wnpdEqzoo3XRyerN3xxSB8EVwNuGBaN311tML+Z1NWsLllG8P6dT6fQMhwDZKGWM0Au2W59GKD4BYB0MbnSXt6HHOL6UZOH8TEg4xaZnllOplxAlzWFNwBhI5dcurQH7hV31BRuaVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXId3qF0RrcD0tdz6TUAD+IC+q6fHcYb54PKjOnEDdk=;
 b=F0a0AT1s0uWeyL14fGIXAt846ompshHEBQYctZUuLPi7Y96mO4Lu5Njd2HXD5jL2sfH/8IRtX2WtaVaSe3sLXtyuY9zkEANAOP34wkJH/LFTudFWlhd0hoyQ0J231UKDF6jhefOkIkoTsSa0Mg8jVHtaZv5hcittBOaRQ28eBII=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1498.namprd15.prod.outlook.com (10.173.225.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 03:27:10 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 03:27:10 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Wenbo Zhang <ethercflow@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bgregg@netflix.com" <bgregg@netflix.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v14 1/2] bpf: add new helper get_fd_path for
 mapping a file descriptor to a pathname
Thread-Topic: [PATCH bpf-next v14 1/2] bpf: add new helper get_fd_path for
 mapping a file descriptor to a pathname
Thread-Index: AQHVtT4Q3/Swxm39u0up0fsbmQh1YKe/O48A
Date:   Wed, 18 Dec 2019 03:27:09 +0000
Message-ID: <4e09844f-8904-5d84-c25d-6fc0cf60b8b7@fb.com>
References: <cover.1576629200.git.ethercflow@gmail.com>
 <7464919bd9c15f2496ca29dceb6a4048b3199774.1576629200.git.ethercflow@gmail.com>
In-Reply-To: <7464919bd9c15f2496ca29dceb6a4048b3199774.1576629200.git.ethercflow@gmail.com>
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
x-ms-office365-filtering-correlation-id: f06510e7-2b41-4161-f957-08d7836a2a46
x-ms-traffictypediagnostic: DM5PR15MB1498:
x-microsoft-antispam-prvs: <DM5PR15MB1498EB71506333A6066F6D87D3530@DM5PR15MB1498.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(346002)(376002)(366004)(199004)(189003)(31686004)(110136005)(52116002)(6506007)(8936002)(36756003)(966005)(6486002)(6512007)(186003)(53546011)(4326008)(8676002)(2616005)(316002)(81166006)(54906003)(81156014)(2906002)(31696002)(478600001)(5660300002)(66946007)(66446008)(64756008)(66556008)(66476007)(86362001)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1498;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PgBhD61VnXlRgkH3iDpJpDzkXyj2LOmp5U5qaFMiJxVVtH6TALWhHownHPj3ALC/h6vf/ReY5lGkv3+tdODecbfpvEwu3OwY5eO5MGz6J+vYj/gIMierDxzKe9LdIND2wzOvTLTtv5t0n0ZO8eac3a6UtTxKiOSEaD2V+KtTN1rhlVw9EKBB928gFX4fkUvOt6nVNESgLQxG/tgdiQSnx5Rcjqj8P1ftPiIcYeWeTpI6Qyjm1TW33EgLVhrhBdSvZ65caM0dQxp25eaKLddehbB9Aml3TsPjlWDabQSxy6pHHD4ajuDjE7vKMsKsynU1Aqkwp3nvQZ7rqVviHDkvnYv7qZ9UiRUYkpPB753KbMUkZnWhIZj6+LZzGsP2oehRzA/4Cw7/r+rcWfvuqZ1fZsaFIMCNzP+KGevT8bF9dt6p/13yHprPMVm65G6p+4leJRdSsRAMJ4g7LDiLe/1DYHpscjmXlT71X1dlEhhn0vM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A590AB1BDF8CB646B82AC18EF49EDF1B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f06510e7-2b41-4161-f957-08d7836a2a46
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 03:27:09.9159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zEEgpTYF7B1O1nJYcOTCbhGxAg31orG74Af2n8+gmPQ0f/KbzK2EYS8C1XPcajEO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1498
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_05:2019-12-17,2019-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912180024
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE3LzE5IDQ6NTYgUE0sIFdlbmJvIFpoYW5nIHdyb3RlOg0KPiBXaGVuIHBlb3Bs
ZSB3YW50IHRvIGlkZW50aWZ5IHdoaWNoIGZpbGUgc3lzdGVtIGZpbGVzIGFyZSBiZWluZyBvcGVu
ZWQsDQo+IHJlYWQsIGFuZCB3cml0dGVuIHRvLCB0aGV5IGNhbiB1c2UgdGhpcyBoZWxwZXIgd2l0
aCBmaWxlIGRlc2NyaXB0b3IgYXMNCj4gaW5wdXQgdG8gYWNoaWV2ZSB0aGlzIGdvYWwuIE90aGVy
IHBzZXVkbyBmaWxlc3lzdGVtcyBhcmUgYWxzbyBzdXBwb3J0ZWQuDQo+IA0KPiBUaGlzIHJlcXVp
cmVtZW50IGlzIG1haW5seSBkaXNjdXNzZWQgaGVyZToNCj4gDQo+ICAgIGh0dHBzOi8vZ2l0aHVi
LmNvbS9pb3Zpc29yL2JjYy9pc3N1ZXMvMjM3DQo+IA0KPiB2MTMtPnYxNDogYWRkcmVzc2VkIFlv
bmdob25nIGFuZCBEYW5pZWwncyBmZWVkYmFjaw0KPiAtIGZpeCB0aGlzIGhlbHBlcidzIGRlc2Ny
aXB0aW9uIHRvIGJlIGNvbnNpc3RlbnQgd2l0aCBjb21tZW50cyBpbiBkX3BhdGgNCj4gLSBmaXgg
ZXJyb3IgaGFuZGxpbmcgbG9naWMgZmlsbCB6ZXJvZXMgbm90ICcwJ3MNCj4gDQo+IHYxMi0+djEz
OiBhZGRyZXNzZWQgQnJlbmRhbiBhbmQgWW9uZ2hvbmcncyBmZWVkYmFjaw0KPiAtIHJlbmFtZSB0
byBnZXRfZmRfcGF0aA0KPiAtIHJlZmFjdG9yIGNvZGUgJiBjb21tZW50IHRvIGJlIGNsZWFyZXIg
YW5kIG1vcmUgY29tcGxpYW50DQo+IA0KPiB2MTEtPnYxMjogYWRkcmVzc2VkIEFsZXhlaSdzIGZl
ZWRiYWNrDQo+IC0gb25seSBhbGxvdyB0cmFjZXBvaW50cyB0byBtYWtlIHN1cmUgaXQgd29uJ3Qg
ZGVhZCBsb2NrDQo+IA0KPiB2MTAtPnYxMTogYWRkcmVzc2VkIEFsIGFuZCBBbGV4ZWkncyBmZWVk
YmFjaw0KPiAtIGZpeCBtaXNzaW5nIGZwdXQoKQ0KPiANCj4gdjktPnYxMDogYWRkcmVzc2VkIEFu
ZHJpaSdzIGZlZWRiYWNrDQo+IC0gc2VuZCB0aGlzIHBhdGNoIHRvZ2V0aGVyIHdpdGggdGhlIHBh
dGNoIHNlbGZ0ZXN0cyBhcyBvbmUgcGF0Y2ggc2VyaWVzDQo+IA0KPiB2OC0+djk6DQo+IC0gZm9y
bWF0IGhlbHBlciBkZXNjcmlwdGlvbg0KPiANCj4gdjctPnY4OiBhZGRyZXNzZWQgQWxleGVpJ3Mg
ZmVlZGJhY2sNCj4gLSB1c2UgZmdldF9yYXcgaW5zdGVhZCBvZiBmZGdldF9yYXcsIGFzIGZkZ2V0
X3JhdyBpcyBvbmx5IHVzZWQgaW5zaWRlIGZzLw0KPiAtIGVuc3VyZSB3ZSdyZSBpbiB1c2VyIGNv
bnRleHQgd2hpY2ggaXMgc2FmZSBmb3QgdGhlIGhlbHAgdG8gcnVuDQo+IC0gZmlsdGVyIHVubW91
bnRhYmxlIHBzZXVkbyBmaWxlc3lzdGVtLCBiZWNhdXNlIHRoZXkgZG9uJ3QgaGF2ZSByZWFsIHBh
dGgNCj4gLSBzdXBwbGVtZW50IHRoZSBkZXNjcmlwdGlvbiBvZiB0aGlzIGhlbHBlciBmdW5jdGlv
bg0KPiANCj4gdjYtPnY3Og0KPiAtIGZpeCBtaXNzaW5nIHNpZ25lZC1vZmYtYnkgbGluZQ0KPiAN
Cj4gdjUtPnY2OiBhZGRyZXNzZWQgQW5kcmlpJ3MgZmVlZGJhY2sNCj4gLSBhdm9pZCB1bm5lY2Vz
c2FyeSBnb3RvIGVuZCBieSBoYXZpbmcgdHdvIGV4cGxpY2l0IHJldHVybnMNCj4gDQo+IHY0LT52
NTogYWRkcmVzc2VkIEFuZHJpaSBhbmQgRGFuaWVsJ3MgZmVlZGJhY2sNCj4gLSByZW5hbWUgYnBm
X2ZkMnBhdGggdG8gYnBmX2dldF9maWxlX3BhdGggdG8gYmUgY29uc2lzdGVudCB3aXRoIG90aGVy
DQo+IGhlbHBlcidzIG5hbWVzDQo+IC0gd2hlbiBmZGdldF9yYXcgZmFpbHMsIHNldCByZXQgdG8g
LUVCQURGIGluc3RlYWQgb2YgLUVJTlZBTA0KPiAtIHJlbW92ZSBmZHB1dCBmcm9tIGZkZ2V0X3Jh
dydzIGVycm9yIHBhdGgNCj4gLSB1c2UgSVNfRVJSIGluc3RlYWQgb2YgSVNfRVJSX09SX05VTEwg
YXMgZF9wYXRoIGV0aGVyIHJldHVybnMgYSBwb2ludGVyDQo+IGludG8gdGhlIGJ1ZmZlciBvciBh
biBlcnJvciBjb2RlIGlmIHRoZSBwYXRoIHdhcyB0b28gbG9uZw0KPiAtIG1vZGlmeSB0aGUgbm9y
bWFsIHBhdGgncyByZXR1cm4gdmFsdWUgdG8gcmV0dXJuIGNvcGllZCBzdHJpbmcgbGVuZ3RoDQo+
IGluY2x1ZGluZyBOVUwNCj4gLSB1cGRhdGUgdGhpcyBoZWxwZXIgZGVzY3JpcHRpb24ncyBSZXR1
cm4gYml0cy4NCj4gDQo+IHYzLT52NDogYWRkcmVzc2VkIERhbmllbCdzIGZlZWRiYWNrDQo+IC0g
Zml4IG1pc3NpbmcgZmRwdXQoKQ0KPiAtIG1vdmUgZmQycGF0aCBmcm9tIGtlcm5lbC9icGYvdHJh
Y2UuYyB0byBrZXJuZWwvdHJhY2UvYnBmX3RyYWNlLmMNCj4gLSBtb3ZlIGZkMnBhdGgncyB0ZXN0
IGNvZGUgdG8gYW5vdGhlciBwYXRjaA0KPiAtIGFkZCBjb21tZW50IHRvIGV4cGxhaW4gd2h5IHVz
ZSBmZGdldF9yYXcgaW5zdGVhZCBvZiBmZGdldA0KPiANCj4gdjItPnYzOiBhZGRyZXNzZWQgWW9u
Z2hvbmcncyBmZWVkYmFjaw0KPiAtIHJlbW92ZSB1bm5lY2Vzc2FyeSBMT0NLRE9XTl9CUEZfUkVB
RA0KPiAtIHJlZmFjdG9yIGVycm9yIGhhbmRsaW5nIHNlY3Rpb24gZm9yIGVuaGFuY2VkIHJlYWRh
YmlsaXR5DQo+IC0gcHJvdmlkZSBhIHRlc3QgY2FzZSBpbiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9icGYNCj4gDQo+IHYxLT52MjogYWRkcmVzc2VkIERhbmllbCdzIGZlZWRiYWNrDQo+IC0gZml4
IGJhY2t3YXJkIGNvbXBhdGliaWxpdHkNCj4gLSBhZGQgdGhpcyBoZWxwZXIgZGVzY3JpcHRpb24N
Cj4gLSBmaXggc2lnbmVkLW9mZiBuYW1lDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBXZW5ibyBaaGFu
ZyA8ZXRoZXJjZmxvd0BnbWFpbC5jb20+DQoNCkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNA
ZmIuY29tPg0KDQo=
