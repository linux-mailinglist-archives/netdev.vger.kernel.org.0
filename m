Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 489F8D1F23
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 05:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732759AbfJJDzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 23:55:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11642 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbfJJDzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 23:55:22 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9A3t7Ac020929;
        Wed, 9 Oct 2019 20:55:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Jny8/slMj12R7f5mj1ok99BuND+3QGZDIi0TyrG+TtQ=;
 b=cbx6/ocpfAsSTJut+XmKNevExbJcEg7toi1TARUAgpCetEYsYUHeHaoO99CP7RBjaonW
 oyKtTG+t7N8C9G6wTOsOt4Vob1Xu5qV3gYWPkd9NETFWwQGtnaYYRfTM2YD/8hBnVOTQ
 oalusJcIms1mDuLpi1/tfnYo2EV2ZTsFh0E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vhnsj9rbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Oct 2019 20:55:06 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 9 Oct 2019 20:54:47 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 9 Oct 2019 20:54:47 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 9 Oct 2019 20:54:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZbKF0lFCAfChu1S+yd+4X2gcI55g6bsT7d7TOY2hnncgf2pTwkUyFioj2u7uzO4XN879/gaOZhF0Guyc4PQKJ+RzV/xwNl0Oqz8EA4aLY7kF9B7XpBfLB4rA7Y059OjYh8TvkwPKW8I1+bFG6PlBQ/4OQg7JK5FkB9RRppuhszq8Ay1XvKFkud6jXD1zv8mV3BtnI0/94/ZnfSKaaBPWb9HclsEgnpR/kj5ToTdGalRjMRSofZydMrgZsfIFVW59n9TirEzRNr1nIzx6sArPqWuDv+K9paCTLpPoSgh9OEEGNCUhkGIzgVOyVAXkz/cgdfalRzO84yWI7fn6NEhHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jny8/slMj12R7f5mj1ok99BuND+3QGZDIi0TyrG+TtQ=;
 b=R7h+WAy2pmSPenm4x9q1QeYiq4oatCkI+4kN0bJ/YtGwPRDAiLgmkD+/NfsjkpdnMXvQvvPGVinfXgbxSnXiUBiSRmODoy/7TWYwne0050J3FcG74YgKg3HeT33VUm62hhncxmim/i5HgZp2Cun3G47k6avNo5atLr3iB1DtccFeyuVyVU3dkIHyJdOisYEip+3i/TeuvTCUI0VwMJYJ7dm8IT66/w2WSkjSzuzxTRUyah8obe0RkRE2/e9jWaDJA9Deg3+F0yBUP/DoOAFhm65UEHKjit5Z6eu1pkpQDLp6lYZNQ2p8KNB4BNqLNsqs7XdBvt0RmOeKnmraZ51zVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jny8/slMj12R7f5mj1ok99BuND+3QGZDIi0TyrG+TtQ=;
 b=G+uxzzH/zScC59MrWRw8eODR0YqcVGIvcxqZamIPF0ls+w629YGdK4623UE0FSVTOegwmG1BNTnCjxkqkMsw1kH3WTyDmgwUrEBR4eYnHuAVOO8XZHKYgIvAQrQKD3Cd82JyedkOzbqQ3xGOH3rbBJx4RE5sFSu5JW3uDIvo8gM=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3029.namprd15.prod.outlook.com (20.178.238.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Thu, 10 Oct 2019 03:54:46 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.026; Thu, 10 Oct 2019
 03:54:46 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 05/10] bpf: implement accurate raw_tp context
 access via BTF
Thread-Topic: [PATCH bpf-next 05/10] bpf: implement accurate raw_tp context
 access via BTF
Thread-Index: AQHVezo5sKYubhk6UEK1EwMR6IEna6dP6i6AgAHDRACAAAiTgIAAE1WAgAF9F4A=
Date:   Thu, 10 Oct 2019 03:54:45 +0000
Message-ID: <9911e078-9408-4943-e069-fae0a56423e4@fb.com>
References: <20191005050314.1114330-1-ast@kernel.org>
 <20191005050314.1114330-6-ast@kernel.org>
 <CAEf4BzZvZ_gseRgaJb-fXJ-M=0c71PebQLbDH50BL5fCK6yZ1g@mail.gmail.com>
 <b1d49ded-6d16-9476-ac70-89371ba7c709@fb.com>
 <CAEf4BzYUoGb2k9MwbyDpfm1p6+mbbSc_t4rcM6TKZ-Q2VaGxpw@mail.gmail.com>
 <CAEf4BzbtBU3pGVUOS-4_0gy50a41+_m4_ROYZNeGTJGpLTJotQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbtBU3pGVUOS-4_0gy50a41+_m4_ROYZNeGTJGpLTJotQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:300:95::22) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::7c62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22d9e33b-f5e6-4bcc-4c02-08d74d3596df
x-ms-traffictypediagnostic: BYAPR15MB3029:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3029E8CFC7B9F4084180EA94D7940@BYAPR15MB3029.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(366004)(376002)(346002)(199004)(189003)(36756003)(7736002)(305945005)(53546011)(6506007)(66476007)(66556008)(64756008)(66446008)(256004)(6436002)(31686004)(6916009)(478600001)(102836004)(66946007)(25786009)(316002)(76176011)(386003)(5660300002)(6116002)(86362001)(2906002)(4326008)(31696002)(81156014)(8676002)(81166006)(6246003)(71190400001)(71200400001)(8936002)(4744005)(6512007)(446003)(14454004)(11346002)(486006)(99286004)(52116002)(229853002)(186003)(46003)(54906003)(2616005)(476003)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3029;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XhrBt0mjdARcbVwIO4oRjixD3RyiT0x0yqiSlLFtTg+T6tc833C61+fE5PxxcmSlIwSYJfjnnq2/5JlngVGvPCbDRfYeFF96K4fArWiSAPLgRPludr99rRPtTRRmAMYjqI8r4fQ01hy7C2+THVdQMi+WMrVTIzaJvOhHBs81Zu2zJMcFvsGzakm5W86r99RONRwfmflJkjIMDGHRg71TFby0ll0qxt+94/SQ+oYSr6kUS4/LA/8HkeWIQK/8ueLETH7c83NyWLYaUP53Uw+/w+FUDq+GMmj1N/lQB4vf8yR1kskBkuAwNyOGrvDhqt5eHGMMchDCboSdyzsQG7nhJTGuTulEyDc9Wj61wmkcNgHRJ73syqmG+WlYNTSMk74L1PP+aSUo4tf/zJuTQKFd3C9aeIC7BUOTlY2WVE1KKM4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A66BC77C256C1A40A0687526DA6EDEA3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d9e33b-f5e6-4bcc-4c02-08d74d3596df
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 03:54:45.8025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2OUXUxfwltxtg34ej6nL+xrWZjIjLzpfj7f3vMs8cWFK7tvRqFM0YdojxMozNox4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3029
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_01:2019-10-08,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 adultscore=0 mlxlogscore=768 impostorscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100034
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvOC8xOSAxMDoxMCBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBmb3JfZWFjaF9t
ZW1iZXIoaSwgdCwgbWVtYmVyKSB7DQo+ICAgICAgaWYgKG1vZmYgKyBtc2l6ZSA8PSBvZmYpDQo+
ICAgICAgICAgIGNvbnRpbnVlOyAvKiBubyBvdmVybGFwIHdpdGggbWVtYmVyLCB5ZXQsIGtlZXAg
aXRlcmF0aW5nICovDQo+ICAgICAgaWYgKG1vZmYgPj0gb2ZmICsgc2l6ZSkNCj4gICAgICAgICAg
YnJlYWs7IC8qIHdvbid0IGZpbmQgYW55dGhpbmcsIGZpZWxkIGlzIGFscmVhZHkgdG9vIGZhciAq
Lw0KPiANCj4gICAgICAvKiBvdmVybGFwcGluZywgcmVzdCBvZiB0aGUgY2hlY2tzICovDQoNCm1h
a2VzIHNlbnNlLiBJJ2xsIHR3ZWFrIHRoZSBjb21tZW50cyBhbmQgY2hlY2tzLg0K
