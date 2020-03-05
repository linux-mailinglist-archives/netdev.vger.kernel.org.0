Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0474217AF5C
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 21:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgCEUE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 15:04:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40804 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726079AbgCEUE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 15:04:58 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 025JvnXa025688;
        Thu, 5 Mar 2020 12:04:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Oa5FH78fbGDmnk9EM0WNECixqwVefYP/B/75on/X0xE=;
 b=HuXBGaI+/coN6wl+ZceVZOGnG5lS8OBnGMMNOVptJ2Hr4oN1Nob0JZWs2ahDMErjVQlM
 8orkJJCsFN9YJeYtKW+dcHr3x2QRnhpV0a1Df6PHyMm7Z4CZUY42E9pXGyqgmN03v+Qf
 ssGjUT+kEMQ0bXLZTiNBGHkw5Qi9rjTX2RA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2yk4m89agk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 05 Mar 2020 12:04:42 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 5 Mar 2020 12:04:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSzuL2KHHuc9z3t8fjmSZ8vmI4snE6JIZakAbsP1CzJ4YlxK7aEbsS2rAVEZxhtnW4/teWbQX0Z1XK+9VRKCCiv1JTsXSixbnEmHvtyeVCN1hKRa15VfXcE8l6UGHM+GWo1uLS2n9R0TVC8kYPdm/vv1m28Ppb2pn8AXbXBsYovfAdN+xlYyNA8pQXTOZCyYgD3Fxrk5Vt7ApGlPCAcwnIyUyz0bgc3uajwVM+Rc2vRkLfysmMfTCQaVgoKGTh6SDuqRUH3PvGkLykuv50g8ZdIu8MC6GzAKjaPFJ537puAHmTuTAFYife3hPpJw3J80lWuSgxeC2FIvqdUzhzKJuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oa5FH78fbGDmnk9EM0WNECixqwVefYP/B/75on/X0xE=;
 b=ISRNAopUtzC3Qs9w10BSsm9LXbhUjAkCKI6gdW2IM9ZVF5lfPL2hV5rChF+5ObYtZBGl/e1NsLgRX6RDss1/AoFeyWtJBBCP1IKNNk2brURNDZrZ48KEGQRclGwlnl1kNo3VdYJpaMIlLZhcZZ0hHlnmaaOec/bRrWWMnEsP2fwE9ebnYQRaQvt76NCCmdPrzU8WEVj8gZblstU4Uv/jBR9c7P6z2ZLO+ywPIfSs/7Kojh1VTb0mImfxTegd9OjtN139iYP7bCEJGBFKeDqRVRlnGyzXMHUtGbMzHYAfw3+4BYJwsWlePXWW7G1W+/B9ebukphqrFgGGBsX86Uk30g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oa5FH78fbGDmnk9EM0WNECixqwVefYP/B/75on/X0xE=;
 b=TIwjyzildS+lX9JwhJJfhyb4VVghpVgJmQJIKWiMGkMl3c97ZGU54SoeWvf2p+rV7jnLyVsr9p0yoz6NIc0MS71QmdPtjNMw0wm2e2Tb6+7HDKqjdu5v+Ss/+ZIFHvCnYSaWAQebuExnpdS8AIicZq2cJNfLcwIUyVYh2hgoWFU=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3913.namprd15.prod.outlook.com (2603:10b6:303:42::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Thu, 5 Mar
 2020 20:03:53 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 20:03:53 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "quentin@isovalent.com" <quentin@isovalent.com>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "arnaldo.melo@gmail.com" <arnaldo.melo@gmail.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 0/4] bpftool: introduce prog profile
Thread-Topic: [PATCH v4 bpf-next 0/4] bpftool: introduce prog profile
Thread-Index: AQHV8k/ID7Brhxz/CkyCD9Xa6Igk7Kg4y9qAgAAaOACAAAmkAIAAA6WAgAAC5QCAAXeCAA==
Date:   Thu, 5 Mar 2020 20:03:53 +0000
Message-ID: <8855C490-F3E3-4FEB-B59E-C529667BDC30@fb.com>
References: <20200304180710.2677695-1-songliubraving@fb.com>
 <20200304190807.GA168640@krava> <20200304204158.GD168640@krava>
 <C7C4E8E1-9176-48DC-8089-D4AEDE86E720@fb.com> <20200304212931.GE168640@krava>
 <4C0824FE-37CB-4660-BAE0-0EAE8F6BF8A0@fb.com>
In-Reply-To: <4C0824FE-37CB-4660-BAE0-0EAE8F6BF8A0@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:f61b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58377563-3af9-4b90-fdb8-08d7c140546a
x-ms-traffictypediagnostic: MW3PR15MB3913:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB39135DCA1808606949D7024FB3E20@MW3PR15MB3913.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:612;
x-forefront-prvs: 03333C607F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(189003)(66476007)(64756008)(66446008)(66556008)(6512007)(478600001)(6486002)(66946007)(2906002)(8676002)(186003)(81166006)(8936002)(81156014)(86362001)(4326008)(76116006)(54906003)(53546011)(6506007)(6916009)(36756003)(33656002)(2616005)(71200400001)(5660300002)(316002)(966005);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3913;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DqWtuZYtAwCIvws2aGoo0r1l+F4gZlJNl6dHabF4nt0l7I4E0FDXb4FXqpKBSu0L2xKabb5zGMUe47TJWCwyHk2p7uZ0gfDRHcAJVTtWLYSZCJxY7SL5ICOUg9/+ERhqSeKGy4ByBLqZDJkTu02TMhSSQegEFprfK99IzqnL3LeiCvbmYIJCSUWDlRh+sO8YhdW6nLNppxMtyu+zeYvaF8sK/mmR7KRy1D2YPe/4oix1Q7dN4lxRC4afYY1pHiGeybEMC4mTeeR2eRaLjfEYp5Qzi/K37exoO3SJ6J5ypXtnBDUbhvj7W8KvsKILSW3+L4IUizpIPtpisrOOytjPtRSBZK9Kvs2OEd2nvI9SFuzY3JNBQPcQV2zrbHx0XNyGuPXkK/mluqALTxImpKTHnlcX0PPw/HY1FOck2KnEMWk7UBiU5DJQxyt92nXi25wVSdWmP8KCMEzHK/9sF95j6m236OBCMchIvgivH75BxMqu+2PQQ5ybSwxYff//D/NrcpTUv8JK6r7hP3BsPE+GZw==
x-ms-exchange-antispam-messagedata: nmZLfqGUs5FZA82ki85i4nBrtpRm0WaDI6yrVS2ynsomGIcF8DcB4vQ0SaunhDOJ5WnXyOqW9qn4adI2skTk34C1tr36VvMUPceflKOFY1zQkStY5M/Rcjyn1wN2pYa9q/9xm4kAVeDAHbSWs2oIuCYLUL8vGaeZoF9cimOn2ZhV7Sh48k4qBMz9ry4TX1Mp
Content-Type: text/plain; charset="utf-8"
Content-ID: <177B8180DC73B541B786DD603C25897A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 58377563-3af9-4b90-fdb8-08d7c140546a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 20:03:53.2091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VLA9V1TITBGqhIHwsJZUYv++U0mpJDMu084UR1piDepzU2zj9EwfQEeB+kea0fM/oeRjk9uImOq3k2PTct5CjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3913
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-05_06:2020-03-05,2020-03-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 impostorscore=0 priorityscore=1501
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003050116
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTWFyIDQsIDIwMjAsIGF0IDE6MzkgUE0sIFNvbmcgTGl1IDxzb25nbGl1YnJhdmlu
Z0BmYi5jb20+IHdyb3RlOg0KPiANCj4gDQo+IA0KPj4gT24gTWFyIDQsIDIwMjAsIGF0IDE6Mjkg
UE0sIEppcmkgT2xzYSA8am9sc2FAcmVkaGF0LmNvbT4gd3JvdGU6DQo+PiANCj4+IE9uIFdlZCwg
TWFyIDA0LCAyMDIwIGF0IDA5OjE2OjI5UE0gKzAwMDAsIFNvbmcgTGl1IHdyb3RlOg0KPj4+IA0K
Pj4+IA0KPj4+PiBPbiBNYXIgNCwgMjAyMCwgYXQgMTI6NDEgUE0sIEppcmkgT2xzYSA8am9sc2FA
cmVkaGF0LmNvbT4gd3JvdGU6DQo+Pj4+IA0KPj4+PiBPbiBXZWQsIE1hciAwNCwgMjAyMCBhdCAw
ODowODowN1BNICswMTAwLCBKaXJpIE9sc2Egd3JvdGU6DQo+Pj4+PiBPbiBXZWQsIE1hciAwNCwg
MjAyMCBhdCAxMDowNzowNkFNIC0wODAwLCBTb25nIExpdSB3cm90ZToNCj4+Pj4+PiBUaGlzIHNl
dCBpbnRyb2R1Y2VzIGJwZnRvb2wgcHJvZyBwcm9maWxlIGNvbW1hbmQsIHdoaWNoIHVzZXMgaGFy
ZHdhcmUNCj4+Pj4+PiBjb3VudGVycyB0byBwcm9maWxlIEJQRiBwcm9ncmFtcy4NCj4+Pj4+PiAN
Cj4+Pj4+PiBUaGlzIGNvbW1hbmQgYXR0YWNoZXMgZmVudHJ5L2ZleGl0IHByb2dyYW1zIHRvIGEg
dGFyZ2V0IHByb2dyYW0uIFRoZXNlIHR3bw0KPj4+Pj4+IHByb2dyYW1zIHJlYWQgaGFyZHdhcmUg
Y291bnRlcnMgYmVmb3JlIGFuZCBhZnRlciB0aGUgdGFyZ2V0IHByb2dyYW0gYW5kDQo+Pj4+Pj4g
Y2FsY3VsYXRlIHRoZSBkaWZmZXJlbmNlLg0KPj4+Pj4+IA0KPj4+Pj4+IENoYW5nZXMgdjMgPT4g
djQ6DQo+Pj4+Pj4gMS4gU2ltcGxpZnkgZXJyIGhhbmRsaW5nIGluIHByb2ZpbGVfb3Blbl9wZXJm
X2V2ZW50cygpIChRdWVudGluKTsNCj4+Pj4+PiAyLiBSZW1vdmUgcmVkdW5kYW50IHBfZXJyKCkg
KFF1ZW50aW4pOw0KPj4+Pj4+IDMuIFJlcGxhY2UgdGFiIHdpdGggc3BhY2UgaW4gYmFzaC1jb21w
bGV0aW9uOyAoUXVlbnRpbik7DQo+Pj4+Pj4gNC4gRml4IHR5cG8gX2JwZnRvb2xfZ2V0X21hcF9u
YW1lcyA9PiBfYnBmdG9vbF9nZXRfcHJvZ19uYW1lcyAoUXVlbnRpbikuDQo+Pj4+PiANCj4+Pj4+
IGh1bSwgSSdtIGdldHRpbmc6DQo+Pj4+PiANCj4+Pj4+IAlbam9sc2FAZGVsbC1yNDQwLTAxIGJw
ZnRvb2xdJCBwd2QNCj4+Pj4+IAkvaG9tZS9qb2xzYS9saW51eC1wZXJmL3Rvb2xzL2JwZi9icGZ0
b29sDQo+Pj4+PiAJW2pvbHNhQGRlbGwtcjQ0MC0wMSBicGZ0b29sXSQgbWFrZQ0KPj4+Pj4gCS4u
Lg0KPj4+Pj4gCW1ha2VbMV06IExlYXZpbmcgZGlyZWN0b3J5ICcvaG9tZS9qb2xzYS9saW51eC1w
ZXJmL3Rvb2xzL2xpYi9icGYnDQo+Pj4+PiAJICBMSU5LICAgICBfYnBmdG9vbA0KPj4+Pj4gCW1h
a2U6ICoqKiBObyBydWxlIHRvIG1ha2UgdGFyZ2V0ICdza2VsZXRvbi9wcm9maWxlci5icGYuYycs
IG5lZWRlZCBieSAnc2tlbGV0b24vcHJvZmlsZXIuYnBmLm8nLiBTdG9wLg0KPj4+PiANCj4+Pj4g
b2ssIEkgaGFkIHRvIGFwcGx5IHlvdXIgcGF0Y2hlcyBieSBoYW5kLCBiZWNhdXNlICdnaXQgYW0n
IHJlZnVzZWQgdG8NCj4+Pj4gZHVlIHRvIGZ1enouLiBzbyBzb21lIG9mIHlvdSBuZXcgZmlsZXMg
ZGlkIG5vdCBtYWtlIGl0IHRvIG15IHRyZWUgOy0pDQo+Pj4+IA0KPj4+PiBhbnl3YXkgSSBoaXQg
YW5vdGhlciBlcnJvciBub3c6DQo+Pj4+IA0KPj4+PiAJICBDQyAgICAgICBwcm9nLm8NCj4+Pj4g
CUluIGZpbGUgaW5jbHVkZWQgZnJvbSBwcm9nLmM6MTU1MzoNCj4+Pj4gCXByb2ZpbGVyLnNrZWwu
aDogSW4gZnVuY3Rpb24g4oCYcHJvZmlsZXJfYnBmX19jcmVhdGVfc2tlbGV0b27igJk6DQo+Pj4+
IAlwcm9maWxlci5za2VsLmg6MTM2OjM1OiBlcnJvcjog4oCYc3RydWN0IHByb2ZpbGVyX2JwZuKA
mSBoYXMgbm8gbWVtYmVyIG5hbWVkIOKAmHJvZGF0YeKAmQ0KPj4+PiAJICAxMzYgfCAgcy0+bWFw
c1s0XS5tbWFwZWQgPSAodm9pZCAqKikmb2JqLT5yb2RhdGE7DQo+Pj4+IAkgICAgICB8ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefg0KPj4+PiAJcHJvZy5jOiBJbiBmdW5jdGlv
biDigJhwcm9maWxlX3JlYWRfdmFsdWVz4oCZOg0KPj4+PiAJcHJvZy5jOjE2NTA6Mjk6IGVycm9y
OiDigJhzdHJ1Y3QgcHJvZmlsZXJfYnBm4oCZIGhhcyBubyBtZW1iZXIgbmFtZWQg4oCYcm9kYXRh
4oCZDQo+Pj4+IAkgMTY1MCB8ICBfX3UzMiBtLCBjcHUsIG51bV9jcHUgPSBvYmotPnJvZGF0YS0+
bnVtX2NwdTsNCj4+Pj4gDQo+Pj4+IEknbGwgdHJ5IHRvIGZpZ3VyZSBpdCBvdXQuLiBtaWdodCBi
ZSBlcnJvciBvbiBteSBlbmQNCj4+Pj4gDQo+Pj4+IGRvIHlvdSBoYXZlIGdpdCByZXBvIHdpdGgg
dGhlc2UgY2hhbmdlcz8NCj4+PiANCj4+PiBJIHB1c2hlZCBpdCB0byANCj4+PiANCj4+PiBodHRw
czovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zb25nL2xpbnV4Lmdp
dC90cmVlLz9oPWJwZi1wZXItcHJvZy1zdGF0cw0KPj4gDQo+PiBzdGlsbCB0aGUgc2FtZToNCj4+
IA0KPj4gCVtqb2xzYUBkZWxsLXI0NDAtMDEgYnBmdG9vbF0kIGdpdCBzaG93IC0tb25lbGluZSBI
RUFEIHwgaGVhZCAtMQ0KPj4gCTdiYmRhNWNjYTAwYSBicGZ0b29sOiBmaXggdHlwbyBpbiBiYXNo
LWNvbXBsZXRpb24NCj4+IAlbam9sc2FAZGVsbC1yNDQwLTAxIGJwZnRvb2xdJCBtYWtlIA0KPj4g
CW1ha2VbMV06IEVudGVyaW5nIGRpcmVjdG9yeSAnL2hvbWUvam9sc2EvbGludXgtcGVyZi90b29s
cy9saWIvYnBmJw0KPj4gCW1ha2VbMV06IExlYXZpbmcgZGlyZWN0b3J5ICcvaG9tZS9qb2xzYS9s
aW51eC1wZXJmL3Rvb2xzL2xpYi9icGYnDQo+PiAJICBDQyAgICAgICBwcm9nLm8NCj4+IAlJbiBm
aWxlIGluY2x1ZGVkIGZyb20gcHJvZy5jOjE1NTM6DQo+PiAJcHJvZmlsZXIuc2tlbC5oOiBJbiBm
dW5jdGlvbiDigJhwcm9maWxlcl9icGZfX2NyZWF0ZV9za2VsZXRvbuKAmToNCj4+IAlwcm9maWxl
ci5za2VsLmg6MTM2OjM1OiBlcnJvcjog4oCYc3RydWN0IHByb2ZpbGVyX2JwZuKAmSBoYXMgbm8g
bWVtYmVyIG5hbWVkIOKAmHJvZGF0YeKAmQ0KPj4gCSAgMTM2IHwgIHMtPm1hcHNbNF0ubW1hcGVk
ID0gKHZvaWQgKiopJm9iai0+cm9kYXRhOw0KPj4gCSAgICAgIHwgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIF5+DQo+PiAJcHJvZy5jOiBJbiBmdW5jdGlvbiDigJhwcm9maWxlX3Jl
YWRfdmFsdWVz4oCZOg0KPj4gCXByb2cuYzoxNjUwOjI5OiBlcnJvcjog4oCYc3RydWN0IHByb2Zp
bGVyX2JwZuKAmSBoYXMgbm8gbWVtYmVyIG5hbWVkIOKAmHJvZGF0YeKAmQ0KPj4gCSAxNjUwIHwg
IF9fdTMyIG0sIGNwdSwgbnVtX2NwdSA9IG9iai0+cm9kYXRhLT5udW1fY3B1Ow0KPj4gCSAgICAg
IHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+DQo+PiAJcHJvZy5jOiBJbiBmdW5jdGlv
biDigJhwcm9maWxlX29wZW5fcGVyZl9ldmVudHPigJk6DQo+PiAJcHJvZy5jOjE4MTA6MTk6IGVy
cm9yOiDigJhzdHJ1Y3QgcHJvZmlsZXJfYnBm4oCZIGhhcyBubyBtZW1iZXIgbmFtZWQg4oCYcm9k
YXRh4oCZDQo+PiAJIDE4MTAgfCAgIHNpemVvZihpbnQpLCBvYmotPnJvZGF0YS0+bnVtX2NwdSAq
IG9iai0+cm9kYXRhLT5udW1fbWV0cmljKTsNCj4+IAkgICAgICB8ICAgICAgICAgICAgICAgICAg
IF5+DQo+PiAJcHJvZy5jOjE4MTA6NDI6IGVycm9yOiDigJhzdHJ1Y3QgcHJvZmlsZXJfYnBm4oCZ
IGhhcyBubyBtZW1iZXIgbmFtZWQg4oCYcm9kYXRh4oCZDQo+PiAJIDE4MTAgfCAgIHNpemVvZihp
bnQpLCBvYmotPnJvZGF0YS0+bnVtX2NwdSAqIG9iai0+cm9kYXRhLT5udW1fbWV0cmljKTsNCj4+
IAkgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn4NCj4+
IAlwcm9nLmM6MTgyNToyNjogZXJyb3I6IOKAmHN0cnVjdCBwcm9maWxlcl9icGbigJkgaGFzIG5v
IG1lbWJlciBuYW1lZCDigJhyb2RhdGHigJkNCj4+IAkgMTgyNSB8ICAgZm9yIChjcHUgPSAwOyBj
cHUgPCBvYmotPnJvZGF0YS0+bnVtX2NwdTsgY3B1KyspIHsNCj4+IAkgICAgICB8ICAgICAgICAg
ICAgICAgICAgICAgICAgICBefg0KPj4gCXByb2cuYzogSW4gZnVuY3Rpb24g4oCYZG9fcHJvZmls
ZeKAmToNCj4+IAlwcm9nLmM6MTkwNDoxMzogZXJyb3I6IOKAmHN0cnVjdCBwcm9maWxlcl9icGbi
gJkgaGFzIG5vIG1lbWJlciBuYW1lZCDigJhyb2RhdGHigJkNCj4+IAkgMTkwNCB8ICBwcm9maWxl
X29iai0+cm9kYXRhLT5udW1fY3B1ID0gbnVtX2NwdTsNCj4+IAkgICAgICB8ICAgICAgICAgICAg
IF5+DQo+PiAJcHJvZy5jOjE5MDU6MTM6IGVycm9yOiDigJhzdHJ1Y3QgcHJvZmlsZXJfYnBm4oCZ
IGhhcyBubyBtZW1iZXIgbmFtZWQg4oCYcm9kYXRh4oCZDQo+PiAJIDE5MDUgfCAgcHJvZmlsZV9v
YmotPnJvZGF0YS0+bnVtX21ldHJpYyA9IG51bV9tZXRyaWM7DQo+PiAJICAgICAgfCAgICAgICAg
ICAgICBefg0KPj4gCW1ha2U6ICoqKiBbTWFrZWZpbGU6MTI5OiBwcm9nLm9dIEVycm9yIDENCj4g
DQo+IEkgZ3Vlc3MgeW91IG5lZWQgYSBuZXdlciB2ZXJzaW9uIG9mIGNsYW5nIHRoYXQgc3VwcG9y
dHMgZ2xvYmFsIGRhdGEgaW4gQlBGIHByb2dyYW1zLiANCg0KSGkgSmlyaSwNCg0KSGF2ZSB5b3Ug
Z290IGNoYW5jZSB0byB0ZXN0IHRoaXMgd2l0aCBsYXRlc3QgY2xhbmc/IA0KDQpUaGFua3MsDQpT
b25nDQoNCg==
