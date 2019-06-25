Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA64D55997
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfFYVBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:01:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53180 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726009AbfFYVBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:01:07 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5PKtDpA015002;
        Tue, 25 Jun 2019 14:00:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WvcjthRjL4FWsx608qG1Joz1LIM/hkQXeuIz3X6hFWE=;
 b=nBPGwte9OIUzLVxTmrPWsezsbGe/07+6Q5TKZWutIbL5GvBWBnyvOrIfiqkhPRkJgicq
 vprUeKC87JLmCZ+Wkym+CKlbeFmt3QB5h2MgOJS/Wfran8dkpBO726Ze31yzhqORfsIL
 8gIf9tm/DSVPi+YdeFMAMwyMIEFForxB3fM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2tbpv812jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 14:00:44 -0700
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 25 Jun 2019 14:00:11 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 25 Jun 2019 14:00:11 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 25 Jun 2019 14:00:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvcjthRjL4FWsx608qG1Joz1LIM/hkQXeuIz3X6hFWE=;
 b=GgepuINEg1hML1GDntfRc8zeh1apOD0Eu/ZGwnlCnru399cFEQqDwWFBn4bQOOKJp/nevAEi21sFxpxCttNggVYkYeLAkkEBwJqZy93SemcE/3G0Pr1aWVJCR82p8p8c4q/BtZwc9GOl8Ftc81hOR3rYm/8PTWQgGdtc4+NsroI=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3302.namprd15.prod.outlook.com (20.179.58.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Tue, 25 Jun 2019 21:00:10 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702%7]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 21:00:10 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>,
        Song Liu <songliubraving@fb.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/4] sys_bpf() access control via /dev/bpf
Thread-Topic: [PATCH bpf-next 0/4] sys_bpf() access control via /dev/bpf
Thread-Index: AQHVK4MdyAZ0Ka1YIEmBVlfa/Cpneaas2J6AgAACRQA=
Date:   Tue, 25 Jun 2019 21:00:10 +0000
Message-ID: <59e56064-354c-d6b9-101a-c698976e6723@fb.com>
References: <20190625182303.874270-1-songliubraving@fb.com>
 <20190625205155.GD10487@mini-arch>
In-Reply-To: <20190625205155.GD10487@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0073.namprd19.prod.outlook.com
 (2603:10b6:320:1f::11) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [199.201.64.139]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 739b3c13-72d0-4fec-ccd2-08d6f9b01c19
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3302;
x-ms-traffictypediagnostic: BYAPR15MB3302:
x-microsoft-antispam-prvs: <BYAPR15MB3302FEF9F9B4981BC8C60165D7E30@BYAPR15MB3302.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(366004)(346002)(376002)(396003)(199004)(189003)(68736007)(52116002)(6246003)(71200400001)(4326008)(54906003)(81166006)(8676002)(102836004)(81156014)(7736002)(86362001)(110136005)(305945005)(14444005)(8936002)(186003)(2616005)(316002)(478600001)(71190400001)(256004)(26005)(53936002)(25786009)(476003)(486006)(11346002)(446003)(6506007)(5660300002)(99286004)(36756003)(66066001)(386003)(53546011)(31696002)(229853002)(6486002)(6512007)(76176011)(2906002)(73956011)(6116002)(6636002)(3846002)(66556008)(64756008)(66446008)(66476007)(66946007)(31686004)(6436002)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3302;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: St7lr8V/KF76eTPeIn8bIFue2mJllOPvZB4mU+ZDvlXVjS65atNolyi7K7cnmLVAkStfNChn6vYbDUYOfalPYJG8GoDmnAN3Tl4raSTLkHWIrh9vviG8FVZULWs5MH3qhh1HFOUTCO7f2VY9b7FCUnbgzipX2Z6Co5mZGty9WqdOrDBKk9TpkeWvWSxi+N+1i+MEUFTev2l7KJUkcTsfEc0R4mp3uZ+A0eyRwJbNE5QPs+nzshSsR5HxDOJicjuehx8aM6f25SWQHGUFF/wevB315cQ9SVOPfxgeJhPJFGtTzctFFrXeXWdIEfoHG2O2wilJ1PhIJYiTOFTHg/Y1v3DUqleCBc8oBFBFw/wjwGHDajxUet8W87d00r139lRZNqZyN9EF2PzuxP9WL6fz4lS62ZgJPAUS1b4RmvIcV0Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B3D0DFE1B9A654F97769629C0B1E06A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 739b3c13-72d0-4fec-ccd2-08d6f9b01c19
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 21:00:10.3625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3302
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=973 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8yNS8xOSAxOjUxIFBNLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+IE9uIDA2LzI1
LCBTb25nIExpdSB3cm90ZToNCj4+IEN1cnJlbnRseSwgbW9zdCBhY2Nlc3MgdG8gc3lzX2JwZigp
IGlzIGxpbWl0ZWQgdG8gcm9vdC4gSG93ZXZlciwgdGhlcmUgYXJlDQo+PiB1c2UgY2FzZXMgdGhh
dCB3b3VsZCBiZW5lZml0IGZyb20gbm9uLXByaXZpbGVnZWQgdXNlIG9mIHN5c19icGYoKSwgZS5n
Lg0KPj4gc3lzdGVtZC4NCj4+DQo+PiBUaGlzIHNldCBpbnRyb2R1Y2VzIGEgbmV3IG1vZGVsIHRv
IGNvbnRyb2wgdGhlIGFjY2VzcyB0byBzeXNfYnBmKCkuIEENCj4+IHNwZWNpYWwgZGV2aWNlLCAv
ZGV2L2JwZiwgaXMgaW50cm9kdWNlZCB0byBtYW5hZ2UgYWNjZXNzIHRvIHN5c19icGYoKS4NCj4+
IFVzZXJzIHdpdGggYWNjZXNzIHRvIG9wZW4gL2Rldi9icGYgd2lsbCBiZSBhYmxlIHRvIGFjY2Vz
cyBtb3N0IG9mDQo+PiBzeXNfYnBmKCkgZmVhdHVyZXMuIFRoZSB1c2UgY2FuIGdldCBhY2Nlc3Mg
dG8gc3lzX2JwZigpIGJ5IG9wZW5pbmcgL2Rldi9icGYNCj4+IGFuZCB1c2UgaW9jdGwgdG8gZ2V0
L3B1dCBwZXJtaXNzaW9uLg0KPj4NCj4+IFRoZSBwZXJtaXNzaW9uIHRvIGFjY2VzcyBzeXNfYnBm
KCkgaXMgbWFya2VkIGJ5IGJpdCBUQVNLX0JQRl9GTEFHX1BFUk1JVFRFRA0KPj4gaW4gdGFza19z
dHJ1Y3QuIER1cmluZyBmb3JrKCksIGNoaWxkIHdpbGwgbm90IGluaGVyaXQgdGhpcyBiaXQuDQo+
IDJjOiBpZiB3ZSBhcmUgZ29pbmcgdG8gaGF2ZSBhbiBmZCwgSSdkIHZvdGUgZm9yIGEgcHJvcGVy
IGZkIGJhc2VkIGFjY2Vzcw0KPiBjaGVja3MgaW5zdGVhZCBvZiBhIHBlci10YXNrIGZsYWcsIHNv
IHdlIGNhbiBkbzoNCj4gCWlvY3RsKGZkLCBCUEZfTUFQX0NSRUFURSwgdWF0dHIsIHNpemVvZih1
YXR0cikpDQo+IA0KPiAoYW5kIHBhc3MgdGhpcyBmZCBhcm91bmQpDQo+IA0KPiBJIGRvIHVuZGVy
c3RhbmQgdGhhdCBpdCBicmVha3MgY3VycmVudCBhc3N1bXB0aW9ucyB0aGF0IGxpYmJwZiBoYXMs
DQo+IGJ1dCBtYXliZSB3ZSBjYW4gZXh0ZW5kIF94YXR0ciB2YXJpYW50cyB0byBhY2NlcHQgb3B0
aW5hbCBmZCAoYW5kIHRyeQ0KPiB0byBmYWxsYmFjayB0byBzeXNjdGwgaWYgaXQncyBhYnNlbnQv
bm90IHdvcmtpbmcpPw0KDQpib3RoIG9mIHRoZXNlIGlkZWFzIHdlcmUgZGlzY3Vzc2VkIGF0IGxz
Zm1tIHdoZXJlIHlvdSB3ZXJlIHByZXNlbnQuDQpJJ20gbm90IHN1cmUgd2h5IHlvdSdyZSBicmlu
ZyBpdCB1cCBhZ2Fpbj8NCg==
