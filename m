Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFDF55B8A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfFYWsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:48:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12152 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726362AbfFYWsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:48:37 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5PMgfsc000893;
        Tue, 25 Jun 2019 15:48:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=o2UkOG8Syr7ODGXv5E5rhUKyvfMQ8dGI/QiEFOuiot8=;
 b=rMPPRlaxS1rhp4chzutdhMjxbCN1JEHh2i1IZO7K9KrDFmlyPQ4xAd0DqbfvO4m7LWMW
 kqqi35WGOULtM0Nutj912vlAz3DtlNJBhnHoqgoqMCEQfM8jmDt+sHXIPVpZc6e3qKav
 LcNAVy8c6PPBzv+R6iL6cuI1YbC0dVqO7Jw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tbrn78xuu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 15:48:14 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 25 Jun 2019 15:48:00 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 25 Jun 2019 15:48:00 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 25 Jun 2019 15:48:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o2UkOG8Syr7ODGXv5E5rhUKyvfMQ8dGI/QiEFOuiot8=;
 b=sQYUr2CZuVTFCqpRS7oUuyizD1k+oPi9eiBBuIQyB6yK9hGb7krIR6eYtaW6+vHEbKu4MF1TdiPIeD2FzCI1Iu7A2F5fuZ9JN/gGni1NlNN7IGW2X0kdQKO8Q9lnRXlZsLq/5XHv8nLbWcIp9+LCOUmbIlStHlAynQFxojRL14E=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2470.namprd15.prod.outlook.com (52.135.200.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Tue, 25 Jun 2019 22:47:59 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702%7]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 22:47:58 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
CC:     Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/4] sys_bpf() access control via /dev/bpf
Thread-Topic: [PATCH bpf-next 0/4] sys_bpf() access control via /dev/bpf
Thread-Index: AQHVK4MdyAZ0Ka1YIEmBVlfa/Cpneaas2J6AgAACRQCAAAWGAIAAGJ6A
Date:   Tue, 25 Jun 2019 22:47:58 +0000
Message-ID: <40059e14-7ce0-3d32-8092-698f72612ff3@fb.com>
References: <20190625182303.874270-1-songliubraving@fb.com>
 <20190625205155.GD10487@mini-arch>
 <59e56064-354c-d6b9-101a-c698976e6723@fb.com>
 <20190625211948.GE10487@mini-arch>
In-Reply-To: <20190625211948.GE10487@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2001CA0007.namprd20.prod.outlook.com
 (2603:10b6:301:15::17) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:ec57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 330441b3-dce5-4a80-43bd-08d6f9bf2b7d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2470;
x-ms-traffictypediagnostic: BYAPR15MB2470:
x-microsoft-antispam-prvs: <BYAPR15MB2470721C3FAAF75FB9670DDBD7E30@BYAPR15MB2470.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(366004)(136003)(346002)(376002)(189003)(199004)(256004)(8936002)(4326008)(31696002)(6916009)(86362001)(25786009)(478600001)(36756003)(14444005)(71200400001)(2616005)(6486002)(186003)(5660300002)(53936002)(66556008)(71190400001)(52116002)(68736007)(11346002)(31686004)(76176011)(46003)(6116002)(6436002)(386003)(102836004)(6506007)(53546011)(66446008)(305945005)(54906003)(64756008)(66946007)(7736002)(6512007)(99286004)(2906002)(316002)(476003)(486006)(229853002)(81166006)(446003)(73956011)(8676002)(14454004)(66476007)(81156014)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2470;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DgJQwtiGq9z0RIbdXe9XzSTu0L3chTv4iJovM0+0+Gg06spoU+66z9fMHUGc9Lf45rfYztGcWo8PjlSLCas0ZzoCqadzvZa1tj2BCLTJQHQmkzn9oRwbBEsYPJ2XvzpBRmyGZ0EdRO7nd/g0aWkg6ZRlCoN+yIv653KfvrscQCOURgdqtOKE/m6H6jPvLJ0Mq60d+3EiPG2H1DEMYj+3phuD58qtl7IXmHAryDyoqKJToYzQuSI1AlUQ6nafSgRepAFfFaLan44y3ToZe7gvj+FedSImmY+kWeLYcOXRsJmYO2WZi/W8DM1ZT18S4JGKN6Qn6zKVqrMIU1E2b+ChLA+O3COvT61Kmq5tsGjbd6U3PNYgo9needgMSYxgSlZlTgViBcXQNVR7vdMVcK98UUtAEIbEwzAKe+zA38zhQ8s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3EA49012FE604418C66BD425747D44E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 330441b3-dce5-4a80-43bd-08d6f9bf2b7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 22:47:58.8280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2470
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250182
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8yNS8xOSAyOjE5IFBNLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+IE9uIDA2LzI1
LCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+PiBPbiA2LzI1LzE5IDE6NTEgUE0sIFN0YW5p
c2xhdiBGb21pY2hldiB3cm90ZToNCj4+PiBPbiAwNi8yNSwgU29uZyBMaXUgd3JvdGU6DQo+Pj4+
IEN1cnJlbnRseSwgbW9zdCBhY2Nlc3MgdG8gc3lzX2JwZigpIGlzIGxpbWl0ZWQgdG8gcm9vdC4g
SG93ZXZlciwgdGhlcmUgYXJlDQo+Pj4+IHVzZSBjYXNlcyB0aGF0IHdvdWxkIGJlbmVmaXQgZnJv
bSBub24tcHJpdmlsZWdlZCB1c2Ugb2Ygc3lzX2JwZigpLCBlLmcuDQo+Pj4+IHN5c3RlbWQuDQo+
Pj4+DQo+Pj4+IFRoaXMgc2V0IGludHJvZHVjZXMgYSBuZXcgbW9kZWwgdG8gY29udHJvbCB0aGUg
YWNjZXNzIHRvIHN5c19icGYoKS4gQQ0KPj4+PiBzcGVjaWFsIGRldmljZSwgL2Rldi9icGYsIGlz
IGludHJvZHVjZWQgdG8gbWFuYWdlIGFjY2VzcyB0byBzeXNfYnBmKCkuDQo+Pj4+IFVzZXJzIHdp
dGggYWNjZXNzIHRvIG9wZW4gL2Rldi9icGYgd2lsbCBiZSBhYmxlIHRvIGFjY2VzcyBtb3N0IG9m
DQo+Pj4+IHN5c19icGYoKSBmZWF0dXJlcy4gVGhlIHVzZSBjYW4gZ2V0IGFjY2VzcyB0byBzeXNf
YnBmKCkgYnkgb3BlbmluZyAvZGV2L2JwZg0KPj4+PiBhbmQgdXNlIGlvY3RsIHRvIGdldC9wdXQg
cGVybWlzc2lvbi4NCj4+Pj4NCj4+Pj4gVGhlIHBlcm1pc3Npb24gdG8gYWNjZXNzIHN5c19icGYo
KSBpcyBtYXJrZWQgYnkgYml0IFRBU0tfQlBGX0ZMQUdfUEVSTUlUVEVEDQo+Pj4+IGluIHRhc2tf
c3RydWN0LiBEdXJpbmcgZm9yaygpLCBjaGlsZCB3aWxsIG5vdCBpbmhlcml0IHRoaXMgYml0Lg0K
Pj4+IDJjOiBpZiB3ZSBhcmUgZ29pbmcgdG8gaGF2ZSBhbiBmZCwgSSdkIHZvdGUgZm9yIGEgcHJv
cGVyIGZkIGJhc2VkIGFjY2Vzcw0KPj4+IGNoZWNrcyBpbnN0ZWFkIG9mIGEgcGVyLXRhc2sgZmxh
Zywgc28gd2UgY2FuIGRvOg0KPj4+IAlpb2N0bChmZCwgQlBGX01BUF9DUkVBVEUsIHVhdHRyLCBz
aXplb2YodWF0dHIpKQ0KPj4+DQo+Pj4gKGFuZCBwYXNzIHRoaXMgZmQgYXJvdW5kKQ0KPj4+DQo+
Pj4gSSBkbyB1bmRlcnN0YW5kIHRoYXQgaXQgYnJlYWtzIGN1cnJlbnQgYXNzdW1wdGlvbnMgdGhh
dCBsaWJicGYgaGFzLA0KPj4+IGJ1dCBtYXliZSB3ZSBjYW4gZXh0ZW5kIF94YXR0ciB2YXJpYW50
cyB0byBhY2NlcHQgb3B0aW5hbCBmZCAoYW5kIHRyeQ0KPj4+IHRvIGZhbGxiYWNrIHRvIHN5c2N0
bCBpZiBpdCdzIGFic2VudC9ub3Qgd29ya2luZyk/DQo+Pg0KPj4gYm90aCBvZiB0aGVzZSBpZGVh
cyB3ZXJlIGRpc2N1c3NlZCBhdCBsc2ZtbSB3aGVyZSB5b3Ugd2VyZSBwcmVzZW50Lg0KPj4gSSdt
IG5vdCBzdXJlIHdoeSB5b3UncmUgYnJpbmcgaXQgdXAgYWdhaW4/DQo+IERpZCB3ZSBhY3R1YWxs
eSBzZXR0bGUgb24gYW55dGhpbmc/IEluIHRoYXQgY2FzZSBmZWVsIGZyZWUgdG8gaWdub3JlIG1l
LA0KPiBtYXliZSBJIG1pc3NlZCB0aGF0LiBJIHJlbWVtYmVyIHRoZXJlIHdlcmUgcHJvcy9jb25z
IGZvciBib3RoIGltcGxlbWVudGF0aW9ucy4NCg0KeWVzLiBUaGF0IHdhcyBteSB1bmRlcnN0YW5k
aW5nIGZyb20gbHNmbW0uDQpXaGljaCB3YXM6DQoxLiByZXBsaWNhdGluZyBhbGwgY29tbWFuZHMg
dmlhIGlvY3RsIGlzIG5vdCBnb2luZyB0byB3b3JrLg0KICAgQWxzbyBpb2N0bCBjYW5ub3QgcmV0
dXJuIGZkLg0KMi4gYWRkaW5nIGZkIHRvIGFsbCBzdHJ1Y3RzIGluc2lkZSBicGZfYXR0ciBpcyBh
IGJpZyBjaHVybiBvbiB1YXBpLg0KICAgYWxsIGZ1dHVyZSBzdHJ1Y3RzIHdvdWxkIG5lZWQgdG8g
aGF2ZSB0aGlzIGV4dHJhIGZkIGFzIHdlbGwuDQogICBJIGRvbid0IGxpa2UgdGhhdCBraW5kIG9m
IGNydXRjaCB0byBiZSBjYXJyaWVkIG92ZXIgYW5kIG92ZXIgYWdhaW4uDQoNClRoZSBvbmx5IHRo
aW5nIHdlIGNhbiBjb25zaWRlciBpbnN0ZWFkIG9mIGlvY3RsIGlzIHRvIGFkZCBzaW5nbGUNCm5l
dyBjb21tYW5kIGZvciBicGYgc3lzY2FsbCB0aGF0IHdpbGwgdGFrZSB0aGF0IGZkIGFuZCBhcHBs
eQ0KdGhlIGF0dHJpYnV0ZSB0byB0YXNrIHN0cnVjdC4NCmlvY3RsIG9uIHRoYXQgZmQgb3IgbmV3
IGNvbW1hbmQgbG9vayBlcXVpdmFsZW50IHRvIG1lLg0K
