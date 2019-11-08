Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108CEF4D63
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbfKHNmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:42:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56742 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727437AbfKHNmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 08:42:06 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8DZiLU026551;
        Fri, 8 Nov 2019 05:41:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=M2TXtfJxGqI43AFOAJCbA+hgIZUGY6eo366Jk6n8AxI=;
 b=T5Ep5cXggV3n+p+s+KeTR/dYtcQ7+KUDg6S0A9VWZF2GZmiHT2t8/TyqcyE50nJtISR7
 BFMzXzZ23fYaFSLXPm79PYhmLSPZrJOxkTbEVHr4kHFh0rm4pOpfXwaw1aLz8pY138sj
 yCsdME3gnYtsGxtWimVgkA/qpihJ/IIL+sA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41ujk8f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 Nov 2019 05:41:45 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 05:41:43 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 05:41:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILMfYKDRgBjnPK6TRSGm2jCxUTHnkOdNFJRJ8y6OYDR/uX591lm87AmovaUgn5AsaRBshq/5jyMIx+RYvQIwLuZEozc/A2iyz7x6/Lqh+bAFtXf7ABe1wgm/h3ysh51CECP+KxfStvBB7Y+DKMnFw8TqftyMkN8Y4fsxjAlBkpvqx+P2lliDmzWv1jjiiFnk9428rjo0vBeMEtoVjH3X7xz2rPa2VDc3hjW/IXV/3qq/epeLU2bLS1oV7PCYmhd3PPDUEJAGnZkt8+8MecGggdVrLIjWMewUFh0HalrHyGzwCJr6VkOyDlwj41CWo0Qy372BOmLMciIPmTxYG7XvjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2TXtfJxGqI43AFOAJCbA+hgIZUGY6eo366Jk6n8AxI=;
 b=Ldsydmlu0oIfYMYylJcTCdBBI+LFy0DACgdPJWVOn/4zLlU4z1jYB7Y+1NVr64sM4q3j1VXCSCGhwYd5Bk9Z+6Q3BW+5VUxXxUSb31YkP+3k7C5wnl3WrwmmqUknjCH+eh3dUOsvC7HP2PXorsNZm9Xll/7UvGcqUyrRw9f0toWth/rjNrfdfPhWEwC1OMPNHjRZf21BxfHaEDcg9nOWp2TSwXviQFHHuL4r2unnfcAxjC2/fXM+QrLJN3oQ1YvcXPeBHDi65RI4DyhPqOwH7BTk7W9JIJ0o6yfVKJjO7RzJTUWFaT5Krt1UCvbm+j7Pb8iXuCqZC8tlqIRaOf5aLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2TXtfJxGqI43AFOAJCbA+hgIZUGY6eo366Jk6n8AxI=;
 b=YUvqmuIHGP/Vaj8o66kxj7krq9E6MOSsTSwzWvn79+ChwtU5LlvyohQ5g5JXDNDOvzwTrNElD/95L3BDpSJ4/y9Lj9jLNFGmog0Uy+f2Elw0qmrKTiz00djZlqgfuCqYQV6Z4ySVpWTAk8NEpnHHTjQRqPwdVHIPpRhtvwEQT+c=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3446.namprd15.prod.outlook.com (20.179.57.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Fri, 8 Nov 2019 13:41:42 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 13:41:42 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
Thread-Topic: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
Thread-Index: AQHVlf98WlPtScUlMU6IdXfmoHd8+aeA/SMAgAAGwoCAAESZAA==
Date:   Fri, 8 Nov 2019 13:41:42 +0000
Message-ID: <59d3af80-a781-9765-4d01-4c8006cd574f@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-3-ast@kernel.org>
 <20191108091156.GG4114@hirez.programming.kicks-ass.net>
 <20191108093607.GO5671@hirez.programming.kicks-ass.net>
In-Reply-To: <20191108093607.GO5671@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0030.namprd11.prod.outlook.com
 (2603:10b6:300:115::16) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a68e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 073409d6-6dec-4a04-e501-08d76451634d
x-ms-traffictypediagnostic: BYAPR15MB3446:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB34462D7CCA136606E849B94BD77B0@BYAPR15MB3446.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(39860400002)(376002)(136003)(346002)(189003)(199004)(66946007)(229853002)(81156014)(99286004)(6246003)(14454004)(46003)(102836004)(86362001)(8936002)(305945005)(5660300002)(486006)(76176011)(31686004)(66446008)(7736002)(4326008)(446003)(81166006)(11346002)(478600001)(64756008)(66556008)(66476007)(6512007)(186003)(36756003)(2616005)(476003)(54906003)(31696002)(110136005)(25786009)(6436002)(316002)(256004)(6486002)(53546011)(6506007)(71190400001)(71200400001)(6116002)(52116002)(2906002)(8676002)(386003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3446;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lbe5ORXEFp91iSbNk4KDgOX6Tk8i6rddNt3nyCo32FRueoaaoiymyPMeq8zkEFip1tYRefIkiyFWSTH0Ed9jWBy6nkxvru4EYXZbSbBCNpWXB1mCx6r8DPbwqjN43VyiLCYXZaqEhdba31og9IWhPglbiejCjqcYphMSd2Kf5UnsZOMQoPGTiWqPkN6UgKZIU/PNd18oCCiP8vrRmOLFahV6UXpAZ/uDN/X4zTgTon4b5teXUOPSUZwT22HTrCHp7OQRSlI8VMT2AARq/tjeSfnzt5QtZoT0NqNFqvF6SQNNk9MeBe/0vJ3vEXesbaCfd4Ng0NhuXfw038gtM9XdfmdxfdlrRq9XgZuXId9eWvJ4vUPzcXS2tgwvAIURa2M5VP83pd4CvkykVEhoqOvV2ANj06g1ATWtyl/du2uFxHORG+7Bt0pOrW3K6ybi50iA
Content-Type: text/plain; charset="utf-8"
Content-ID: <7667BE2BD447EB43A4B1F5CEA865B63F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 073409d6-6dec-4a04-e501-08d76451634d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 13:41:42.0930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6dBKHTs2wt9HoJkySC6PEZFr0QqUVK6ngmEZEW+PWoyan3FGXdLqk+7Au93g9yM2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3446
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_04:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvOC8xOSAxOjM2IEFNLCBQZXRlciBaaWpsc3RyYSB3cm90ZToNCj4gT24gRnJpLCBOb3Yg
MDgsIDIwMTkgYXQgMTA6MTE6NTZBTSArMDEwMCwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+PiBP
biBUaHUsIE5vdiAwNywgMjAxOSBhdCAxMDo0MDoyM1BNIC0wODAwLCBBbGV4ZWkgU3Rhcm92b2l0
b3Ygd3JvdGU6DQo+Pj4gQWRkIGJwZl9hcmNoX3RleHRfcG9rZSgpIGhlbHBlciB0aGF0IGlzIHVz
ZWQgYnkgQlBGIHRyYW1wb2xpbmUgbG9naWMgdG8gcGF0Y2gNCj4+PiBub3BzL2NhbGxzIGluIGtl
cm5lbCB0ZXh0IGludG8gY2FsbHMgaW50byBCUEYgdHJhbXBvbGluZSBhbmQgdG8gcGF0Y2gNCj4+
PiBjYWxscy9ub3BzIGluc2lkZSBCUEYgcHJvZ3JhbXMgdG9vLg0KPj4NCj4+IFRoaXMgdGhpbmcg
YXNzdW1lcyB0aGUgdGV4dCBpcyB1bnVzZWQsIHJpZ2h0PyBUaGF0IGlzbid0IHNwZWxsZWQgb3V0
DQo+PiBhbnl3aGVyZS4gVGhlIGltcGxlbWVudGF0aW9uIGlzIHZlcnkgbXVjaCB1bnNhZmUgdnMg
Y29uY3VycmVudCBleGVjdXRpb24NCj4+IG9mIHRoZSB0ZXh0Lg0KPiANCj4gQWxzbywgd2hhdCBO
T1AvQ0FMTCBpbnN0cnVjdGlvbnMgd2lsbCB5b3UgYmUgaGlqYWNraW5nPyBJZiB5b3UncmUNCj4g
cGxhbm5pbmcgb24gdXNpbmcgdGhlIGZlbnRyeSBub3BzLCB0aGVuIHdoYXQgZW5zdXJlcyB0aGlz
IGFuZCBmdHJhY2UNCj4gZG9uJ3QgdHJhbXBsZSBvbiBvbmUgYW5vdGhlcj8gU2ltaWxhciBmb3Ig
a3Byb2Jlcy4NCj4gDQo+IEluIGdlbmVyYWwsIHdoYXQgZW5zdXJlcyBldmVyeSBpbnN0cnVjdGlv
biBvbmx5IGhhcyBhIHNpbmdsZSBtb2RpZmllcj8NCg0KTG9va3MgbGlrZSB5b3UgZGlkbid0IGJv
dGhlciByZWFkaW5nIGNvdmVyIGxldHRlciBhbmQgbWlzc2VkIGEgbW9udGgNCm9mIGRpc2N1c3Np
b25zIGJldHdlZW4gbXkgYW5kIFN0ZXZlbiByZWdhcmRpbmcgZXhhY3RseSB0aGlzIHRvcGljDQp0
aG91Z2ggeW91IHdlcmUgZGlyZWN0bHkgY2MtZWQgaW4gYWxsIHRocmVhZHMgOigNCnRsZHIgZm9y
IGtlcm5lbCBmZW50cnkgbm9wcyBpdCB3aWxsIGJlIGNvbnZlcnRlZCB0byB1c2UgDQpyZWdpc3Rl
cl9mdHJhY2VfZGlyZWN0KCkgd2hlbmV2ZXIgaXQncyBhdmFpbGFibGUuDQpGb3IgYWxsIG90aGVy
IG5vcHMsIGNhbGxzLCBqdW1wcyB0aGF0IGFyZSBpbnNpZGUgQlBGIHByb2dyYW1zIEJQRiBpbmZy
YQ0Kd2lsbCBjb250aW51ZSBtb2RpZnlpbmcgdGhlbSB0aHJvdWdoIHRoaXMgaGVscGVyLg0KRGFu
aWVsJ3MgdXBjb21pbmcgYnBmX3RhaWxfY2FsbCgpIG9wdGltaXphdGlvbiB3aWxsIHVzZSB0ZXh0
X3Bva2UgYXMgd2VsbC4NCg0KID4gSSdtIHZlcnkgdW5jb21mb3J0YWJsZSBsZXR0aW5nIHJhbmRv
bSBicGYgcHJvZ2xldHMgcG9rZSBhcm91bmQgaW4gdGhlDQprZXJuZWwgdGV4dC4NCg0KMS4gVGhl
cmUgaXMgbm8gc3VjaCB0aGluZyBhcyAncHJvZ2xldCcuIFBsZWFzZSBkb24ndCBpbnZlbnQgbWVh
bmluZ2xlc3MgDQpuYW1lcy4NCjIuIEJQRiBwcm9ncmFtcyBoYXZlIG5vIGFiaWxpdHkgdG8gbW9k
aWZ5IGtlcm5lbCB0ZXh0Lg0KMy4gQlBGIGluZnJhIHRha2luZyBhbGwgbmVjZXNzYXJ5IG1lYXN1
cmVzIHRvIG1ha2Ugc3VyZSB0aGF0IHBva2luZw0Ka2VybmVsJ3MgYW5kIEJQRiBnZW5lcmF0ZWQg
dGV4dCBpcyBzYWZlLg0KSWYgeW91IHNlZSBzcGVjaWZpYyBpc3N1ZSBwbGVhc2Ugc2F5IHNvLiBX
ZSdsbCBiZSBoYXBweSB0byBhZGRyZXNzDQphbGwgaXNzdWVzLiBCZWluZyAndW5jb21mb3J0YWJs
ZScgaXMgbm90IGNvbnN0cnVjdGl2ZS4NCg0KDQoNCg==
