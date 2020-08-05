Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6147323C4C1
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 06:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgHEErx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 00:47:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8764 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725809AbgHEErv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 00:47:51 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0754lWDH012851;
        Tue, 4 Aug 2020 21:47:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hrsffR96zbuOCQwuTTlGY0vngC6JwkZOhiVY9DK5z+k=;
 b=pzuRfaVecbSytyZEjQNAekBme2jY4dGg6B030TbZdfJ4BV9pgFwdK/cdjP72XXgHdLe4
 Gbif8X5TYf4Jh+h1z8USlw3sxdc6YpFSvKdcTfXzbMtO6vzhk+n/9dZ5DiUtZ0JxriYY
 PX9fncyGcAAy+xOlcaJ77Ksea5hjIcp7bcM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 32n81ygbut-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 04 Aug 2020 21:47:34 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 4 Aug 2020 21:47:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grWVAI0SQEwKrI/hNNin/8GRBbVujGD4DcU3RK2z5EpKYJqUQOea9dHdnpd94GNiJOB8NDruI3XEYWbs5Q+VvEhLqHZmVJqE+hawI8BeL+a4F0jNlwp2Y74HRV6ZgOTkcVdR2tgFuMf/8uhCP2zXGZmQ0g2kekRJBS1guhy53vr1Ql7smBEgV0fHM+6HcKPcj8gIowtXXDCQ6nERfJfrNObNKD/Kkmj5QVtJC1QUg7nHZXn9SjRJhxePYhf1yjCXWxrw2LErThsJysX6733w5TegbIgRhxu4ruz00043xAtFmGlStFNuDDjWRe+5t6NVPc4fyijBKl1HexhafL/ItA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrsffR96zbuOCQwuTTlGY0vngC6JwkZOhiVY9DK5z+k=;
 b=HvzhJVMzB/z66UFX8u4L0vJ2ktwNpgs+R2zxgaa0vqoxKbBxU7dNH8RTMSN4UOt7HiNapzHCOH4rFDJl7IiG1jwAkmWx6VUvDNhPgcX0IJNgqqg7iXOIbOuRxgagxUWskXa5Q/v8SbpsQNHDTuzWEiisXFhjsbGlDJJ+ZJJcl0BPepT0dNqP1fTkChNeWuQk6nwMgpYY9g4mJalWjGpqW6WxHNg4EIoVnD3e1WTxodSOa5scbGv3292hAspqN+tFBj8Axi3hf8v8qrl92TbaCGr4gy/Sxuhn0mEdLiXtJEBf3N3cxZT6V85xpStkORZU1Y8Lqkb9tN0T/MowQ1Q0rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrsffR96zbuOCQwuTTlGY0vngC6JwkZOhiVY9DK5z+k=;
 b=c9LvLmxzIeF39wj/p/XQTFQ7OahmFEFG/qjaIWSbHWsba/4MvEBGmAGXieKYqYDnMr7IjFeh0e5k5/8sAqhMe6wz3ICR9MjlJgGv+8uGOlcdUhtsvX8fGvwc6EstY1Yy3ZgmbrNsMmgm9P3jSVcwXSKjBHytvcEIT5rljwOj4Qo=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3189.namprd15.prod.outlook.com (2603:10b6:a03:103::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Wed, 5 Aug
 2020 04:47:30 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.022; Wed, 5 Aug 2020
 04:47:30 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: add benchmark for uprobe vs.
 user_prog
Thread-Topic: [PATCH bpf-next 5/5] selftests/bpf: add benchmark for uprobe vs.
 user_prog
Thread-Index: AQHWZ+C4z/mDZUCS20yCUvtKcPb5ZakloXcAgAAxPICAAAZdgIACmfGAgABTZwCAADDfgA==
Date:   Wed, 5 Aug 2020 04:47:30 +0000
Message-ID: <AF9D0E8C-0AA5-4BE4-90F4-946FABAB63FD@fb.com>
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-6-songliubraving@fb.com>
 <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
 <DDCD362E-21D3-46BF-90A6-8F3221CBB54E@fb.com>
 <CAEf4BzY5RYMM6w8wn3qEB3AsuKWv-TMaD5NVFj=YqbCW4DLjqA@mail.gmail.com>
 <7384B583-EE19-4045-AC72-B6FE87C187DD@fb.com>
 <CAEf4BzaiJnCu14AWougmxH80msGdOp4S8ZNmAiexMmtwUM_2Xg@mail.gmail.com>
In-Reply-To: <CAEf4BzaiJnCu14AWougmxH80msGdOp4S8ZNmAiexMmtwUM_2Xg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8f7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ddb98acc-33db-4902-3dcb-08d838faa913
x-ms-traffictypediagnostic: BYAPR15MB3189:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB318963B40DC3DE9F2A113AF0B34B0@BYAPR15MB3189.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C9n48whrxOMxAU7ioAwJ07mH4YJsj/itPx2h12w4ogqgnNNyOXZESdSpTevy8Yvb7o9va/9tQnXGu/C4iwuj3GCSieUZAewZuEo2tbXqV2v1AItUeTkw9DbpQGYJLWLv5zWLszXG0QZM0IDjgMSIB+Wj1HMzVO2Bh6U+/N4rhmlnwUNwkO0LXf6bV2bK6oHnY81t0MHteATH6IblV0EqmZIr6K7N38ubgMRZlawA0wn/+yv8ueGYi12fA5hDbRhwEaJnw0WEUN/O+LN28C9SH+L/Yd2mPRgl3mSI7vGhxthtznTmv95N06Iw/LJ4nOd7MVnbrkzz6IDnK8T/OzVmzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(478600001)(8936002)(54906003)(71200400001)(83380400001)(316002)(66446008)(4326008)(76116006)(8676002)(66946007)(66556008)(66476007)(33656002)(86362001)(6486002)(64756008)(6916009)(186003)(53546011)(6506007)(6512007)(5660300002)(2906002)(2616005)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PGNcBIlSVKsmXBht5HxESJc8dllVNmEYxgScsixNF8JQbw9+MexCIaeI0unQD4eukblvDjwAcb0vq6bfkjSi7jcDjQZ27l5NhrVxVIchBqhfwCdxLMYXbPpakBOxdmLvTdiLaiYXePbAUENBTTpDkTQcMvw63GhKAm+jdPnCK/8IybGDg7xJya1+8NLkhs6xI1hdOFT1P0lWs07pmvSsTAYMFxeEB3hKV9JdAmtlsalGzNsPrks5dyZ8+P2G5uXFFA1FM/xMoTUU4NTSEw3hiryFvF4xRWzQKUdtAky6nqNhK6VONfW39r2kws6exsftYm7caAcBz6eQfREDsIjEn3IcwbeS95Zfjj2yGj2yIxjYTEjh6HAFSSpiCaUfI3sOSWdAJDqNcRQJKTlgA7Hrl2rfTAu+GUk7QINvMPOyXQ7TzGECvfqQy8O0xnC5ik1F2zBzZNZBqiYMcsHl81jCpd6kxYEucRpxOHnHCOvgX0XrCwfyhK0Vi6/+H4Achm0SKNCJYYlyVHn7vdJ0WJbfFsVzjPwctPgO1AP9F6XzPzt/TCGPh20BsRrBUV/ytUHYVTnLiqJXhwE7rDt6qgxc0o8z7y/FjFwKdNDhz7eD/PrB/HIn92ufcpVvyW33thw+i3CCOoPJrmDwf9/7cpZo/2r9Dd2IZSUp+VQQA5T2n/E=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F51D96CEADAC9438221606FAD42CF84@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddb98acc-33db-4902-3dcb-08d838faa913
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2020 04:47:30.0956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m3ZB7XBav+LxAKhl1dPA1YjwEVOuBCVAlH6TRIIEcJ+MvPEzeLU6byTqPLsIDFTg9yafvoeZDMlZi7AkBIEbKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3189
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_04:2020-08-03,2020-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 suspectscore=0
 impostorscore=0 adultscore=0 clxscore=1015 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008050042
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gQXVnIDQsIDIwMjAsIGF0IDY6NTIgUE0sIEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlp
Lm5ha3J5aWtvQGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEF1ZyA0LCAyMDIwIGF0
IDI6MDEgUE0gU29uZyBMaXUgPHNvbmdsaXVicmF2aW5nQGZiLmNvbT4gd3JvdGU6DQo+PiANCj4+
IA0KPj4gDQo+Pj4gT24gQXVnIDIsIDIwMjAsIGF0IDEwOjEwIFBNLCBBbmRyaWkgTmFrcnlpa28g
PGFuZHJpaS5uYWtyeWlrb0BnbWFpbC5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IE9uIFN1biwgQXVn
IDIsIDIwMjAgYXQgOTo0NyBQTSBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPiB3cm90
ZToNCj4+Pj4gDQo+Pj4+IA0KPj4+Pj4gT24gQXVnIDIsIDIwMjAsIGF0IDY6NTEgUE0sIEFuZHJp
aSBOYWtyeWlrbyA8YW5kcmlpLm5ha3J5aWtvQGdtYWlsLmNvbT4gd3JvdGU6DQo+Pj4+PiANCj4+
Pj4+IE9uIFNhdCwgQXVnIDEsIDIwMjAgYXQgMTo1MCBBTSBTb25nIExpdSA8c29uZ2xpdWJyYXZp
bmdAZmIuY29tPiB3cm90ZToNCj4+Pj4+PiANCj4+Pj4+PiBBZGQgYSBiZW5jaG1hcmsgdG8gY29t
cGFyZSBwZXJmb3JtYW5jZSBvZg0KPj4+Pj4+IDEpIHVwcm9iZTsNCj4+Pj4+PiAyKSB1c2VyIHBy
b2dyYW0gdy9vIGFyZ3M7DQo+Pj4+Pj4gMykgdXNlciBwcm9ncmFtIHcvIGFyZ3M7DQo+Pj4+Pj4g
NCkgdXNlciBwcm9ncmFtIHcvIGFyZ3Mgb24gcmFuZG9tIGNwdS4NCj4+Pj4+PiANCj4+Pj4+IA0K
Pj4+Pj4gQ2FuIHlvdSBwbGVhc2UgYWRkIGl0IHRvIHRoZSBleGlzdGluZyBiZW5jaG1hcmsgcnVu
bmVyIGluc3RlYWQsIGUuZy4sDQo+Pj4+PiBhbG9uZyB0aGUgb3RoZXIgYmVuY2hfdHJpZ2dlciBi
ZW5jaG1hcmtzPyBObyBuZWVkIHRvIHJlLWltcGxlbWVudA0KPj4+Pj4gYmVuY2htYXJrIHNldHVw
LiBBbmQgYWxzbyB0aGF0IHdvdWxkIGFsc28gYWxsb3cgdG8gY29tcGFyZSBleGlzdGluZw0KPj4+
Pj4gd2F5cyBvZiBjaGVhcGx5IHRyaWdnZXJpbmcgYSBwcm9ncmFtIHZzIHRoaXMgbmV3IF9VU0VS
IHByb2dyYW0/DQo+Pj4+IA0KPj4+PiBXaWxsIHRyeS4NCj4+Pj4gDQo+Pj4+PiANCj4+Pj4+IElm
IHRoZSBwZXJmb3JtYW5jZSBpcyBub3Qgc2lnbmlmaWNhbnRseSBiZXR0ZXIgdGhhbiBvdGhlciB3
YXlzLCBkbyB5b3UNCj4+Pj4+IHRoaW5rIGl0IHN0aWxsIG1ha2VzIHNlbnNlIHRvIGFkZCBhIG5l
dyBCUEYgcHJvZ3JhbSB0eXBlPyBJIHRoaW5rDQo+Pj4+PiB0cmlnZ2VyaW5nIEtQUk9CRS9UUkFD
RVBPSU5UIGZyb20gYnBmX3Byb2dfdGVzdF9ydW4oKSB3b3VsZCBiZSB2ZXJ5DQo+Pj4+PiBuaWNl
LCBtYXliZSBpdCdzIHBvc3NpYmxlIHRvIGFkZCB0aGF0IGluc3RlYWQgb2YgYSBuZXcgcHJvZ3Jh
bSB0eXBlPw0KPj4+Pj4gRWl0aGVyIHdheSwgbGV0J3Mgc2VlIGNvbXBhcmlzb24gd2l0aCBvdGhl
ciBwcm9ncmFtIHRyaWdnZXJpbmcNCj4+Pj4+IG1lY2hhbmlzbXMgZmlyc3QuDQo+Pj4+IA0KPj4+
PiBUcmlnZ2VyaW5nIEtQUk9CRSBhbmQgVFJBQ0VQT0lOVCBmcm9tIGJwZl9wcm9nX3Rlc3RfcnVu
KCkgd2lsbCBiZSB1c2VmdWwuDQo+Pj4+IEJ1dCBJIGRvbid0IHRoaW5rIHRoZXkgY2FuIGJlIHVz
ZWQgaW5zdGVhZCBvZiB1c2VyIHByb2dyYW0sIGZvciBhIGNvdXBsZQ0KPj4+PiByZWFzb25zLiBG
aXJzdCwgS1BST0JFL1RSQUNFUE9JTlQgbWF5IGJlIHRyaWdnZXJlZCBieSBvdGhlciBwcm9ncmFt
cw0KPj4+PiBydW5uaW5nIGluIHRoZSBzeXN0ZW0sIHNvIHVzZXIgd2lsbCBoYXZlIHRvIGZpbHRl
ciB0aG9zZSBub2lzZSBvdXQgaW4NCj4+Pj4gZWFjaCBwcm9ncmFtLiBTZWNvbmQsIGl0IGlzIG5v
dCBlYXN5IHRvIHNwZWNpZnkgQ1BVIGZvciBLUFJPQkUvVFJBQ0VQT0lOVCwNCj4+Pj4gd2hpbGUg
dGhpcyBmZWF0dXJlIGNvdWxkIGJlIHVzZWZ1bCBpbiBtYW55IGNhc2VzLCBlLmcuIGdldCBzdGFj
ayB0cmFjZQ0KPj4+PiBvbiBhIGdpdmVuIENQVS4NCj4+Pj4gDQo+Pj4gDQo+Pj4gUmlnaHQsIGl0
J3Mgbm90IGFzIGNvbnZlbmllbnQgd2l0aCBLUFJPQkUvVFJBQ0VQT0lOVCBhcyB3aXRoIHRoZSBV
U0VSDQo+Pj4gcHJvZ3JhbSB5b3UndmUgYWRkZWQgc3BlY2lmaWNhbGx5IHdpdGggdGhhdCBmZWF0
dXJlIGluIG1pbmQuIEJ1dCBpZg0KPj4+IHlvdSBwaW4gdXNlci1zcGFjZSB0aHJlYWQgb24gdGhl
IG5lZWRlZCBDUFUgYW5kIHRyaWdnZXIga3Byb2JlL3RwLA0KPj4+IHRoZW4geW91J2xsIGdldCB3
aGF0IHlvdSB3YW50LiBBcyBmb3IgdGhlICJub2lzZSIsIHNlZSBob3cNCj4+PiBiZW5jaF90cmln
Z2VyKCkgZGVhbHMgd2l0aCB0aGF0OiBpdCByZWNvcmRzIHRocmVhZCBJRCBhbmQgZmlsdGVycw0K
Pj4+IGV2ZXJ5dGhpbmcgbm90IG1hdGNoaW5nLiBZb3UgY2FuIGRvIHRoZSBzYW1lIHdpdGggQ1BV
IElELiBJdCdzIG5vdCBhcw0KPj4+IGF1dG9tYXRpYyBhcyB3aXRoIGEgc3BlY2lhbCBCUEYgcHJv
Z3JhbSB0eXBlLCBidXQgc3RpbGwgcHJldHR5IHNpbXBsZSwNCj4+PiB3aGljaCBpcyB3aHkgSSdt
IHN0aWxsIGRlY2lkaW5nIChmb3IgbXlzZWxmKSB3aGV0aGVyIFVTRVIgcHJvZ3JhbSB0eXBlDQo+
Pj4gaXMgbmVjZXNzYXJ5IDopDQo+PiANCj4+IEhlcmUgYXJlIHNvbWUgYmVuY2hfdHJpZ2dlciBu
dW1iZXJzOg0KPj4gDQo+PiBiYXNlICAgICAgOiAgICAxLjY5OCDCsSAwLjAwMU0vcw0KPj4gdHAg
ICAgICAgIDogICAgMS40NzcgwrEgMC4wMDFNL3MNCj4+IHJhd3RwICAgICA6ICAgIDEuNTY3IMKx
IDAuMDAxTS9zDQo+PiBrcHJvYmUgICAgOiAgICAxLjQzMSDCsSAwLjAwME0vcw0KPj4gZmVudHJ5
ICAgIDogICAgMS42OTEgwrEgMC4wMDBNL3MNCj4+IGZtb2RyZXQgICA6ICAgIDEuNjU0IMKxIDAu
MDAwTS9zDQo+PiB1c2VyICAgICAgOiAgICAxLjI1MyDCsSAwLjAwME0vcw0KPj4gZmVudHJ5LW9u
LWNwdTogICAgMC4wMjIgwrEgMC4wMTFNL3MNCj4+IHVzZXItb24tY3B1OiAgICAwLjMxNSDCsSAw
LjAwMU0vcw0KPj4gDQo+IA0KPiBPaywgc28gYmFzaWNhbGx5IGFsbCBvZiByYXdfdHAsdHAsa3By
b2JlLGZlbnRyeS9mZXhpdCBhcmUNCj4gc2lnbmlmaWNhbnRseSBmYXN0ZXIgdGhhbiBVU0VSIHBy
b2dyYW1zLiBTdXJlLCB3aGVuIGNvbXBhcmVkIHRvDQo+IHVwcm9iZSwgdGhleSBhcmUgZmFzdGVy
LCBidXQgbm90IHdoZW4gZG9pbmcgb24tc3BlY2lmaWMtQ1BVIHJ1biwgaXQNCj4gc2VlbXMgKGp1
ZGdpbmcgZnJvbSB0aGlzIHBhdGNoJ3MgZGVzY3JpcHRpb24sIGlmIEknbSByZWFkaW5nIGl0DQo+
IHJpZ2h0KS4gQW55d2F5cywgc3BlZWQgYXJndW1lbnQgc2hvdWxkbid0IGJlIGEgcmVhc29uIGZv
ciBkb2luZyB0aGlzLA0KPiBJTU8uDQo+IA0KPj4gVGhlIHR3byAib24tY3B1IiB0ZXN0cyBydW4g
dGhlIHByb2dyYW0gb24gYSBkaWZmZXJlbnQgQ1BVIChzZWUgdGhlIHBhdGNoDQo+PiBhdCB0aGUg
ZW5kKS4NCj4+IA0KPj4gInVzZXIiIGlzIGFib3V0IDI1JSBzbG93ZXIgdGhhbiAiZmVudHJ5Ii4g
SSB0aGluayB0aGlzIGlzIG1vc3RseSBiZWNhdXNlDQo+PiBnZXRwZ2lkKCkgaXMgYSBmYXN0ZXIg
c3lzY2FsbCB0aGFuIGJwZihCUEZfVEVTVF9SVU4pLg0KPiANCj4gWWVzLCBwcm9iYWJseS4NCj4g
DQo+PiANCj4+ICJ1c2VyLW9uLWNwdSIgaXMgbW9yZSB0aGFuIDEweCBmYXN0ZXIgdGhhbiAiZmVu
dHJ5LW9uLWNwdSIsIGJlY2F1c2UgSVBJDQo+PiBpcyB3YXkgZmFzdGVyIHRoYW4gbW92aW5nIHRo
ZSBwcm9jZXNzICh2aWEgc2NoZWRfc2V0YWZmaW5pdHkpLg0KPiANCj4gSSBkb24ndCB0aGluayB0
aGF0J3MgYSBnb29kIGNvbXBhcmlzb24sIGJlY2F1c2UgeW91IGFyZSBhY3R1YWxseQ0KPiB0ZXN0
aW5nIHNjaGVkX3NldGFmZmluaXR5IHBlcmZvcm1hbmNlIG9uIGVhY2ggaXRlcmF0aW9uIHZzIElQ
SSBpbiB0aGUNCj4ga2VybmVsLCBub3QgYSBCUEYgb3ZlcmhlYWQuDQo+IA0KPiBJIHRoaW5rIHRo
ZSBmYWlyIGNvbXBhcmlzb24gZm9yIHRoaXMgd291bGQgYmUgdG8gY3JlYXRlIGEgdGhyZWFkIGFu
ZA0KPiBwaW4gaXQgb24gbmVjZXNzYXJ5IENQVSwgYW5kIG9ubHkgdGhlbiBCUEYgcHJvZ3JhbSBj
YWxscyBpbiBhIGxvb3AuDQo+IEJ1dCBJIGJldCBhbnkgb2YgZXhpc3RpbmcgcHJvZ3JhbSB0eXBl
cyB3b3VsZCBiZWF0IFVTRVIgcHJvZ3JhbS4NCj4gDQo+PiANCj4+IEZvciB1c2UgY2FzZXMgdGhh
dCB3ZSB3b3VsZCBsaWtlIHRvIGNhbGwgQlBGIHByb2dyYW0gb24gc3BlY2lmaWMgQ1BVLA0KPj4g
dHJpZ2dlcmluZyBpdCB2aWEgSVBJIGlzIGEgbG90IGZhc3Rlci4NCj4gDQo+IFNvIHRoZXNlIHVz
ZSBjYXNlcyB3b3VsZCBiZSBuaWNlIHRvIGV4cGFuZCBvbiBpbiB0aGUgbW90aXZhdGlvbmFsIHBh
cnQNCj4gb2YgdGhlIHBhdGNoIHNldC4gSXQncyBub3QgcmVhbGx5IGVtcGhhc2l6ZWQgYW5kIGl0
J3Mgbm90IGF0IGFsbCBjbGVhcg0KPiB3aGF0IHlvdSBhcmUgdHJ5aW5nIHRvIGFjaGlldmUuIEl0
IGFsc28gc2VlbXMsIGRlcGVuZGluZyBvbiBsYXRlbmN5DQo+IHJlcXVpcmVtZW50cywgaXQncyB0
b3RhbGx5IHBvc3NpYmxlIHRvIGFjaGlldmUgY29tcGFyYWJsZSByZXN1bHRzIGJ5DQo+IHByZS1j
cmVhdGluZyBhIHRocmVhZCBmb3IgZWFjaCBDUFUsIHBpbm5pbmcgZWFjaCBvbmUgdG8gaXRzIGRl
c2lnbmF0ZWQNCj4gQ1BVIGFuZCB0aGVuIHVzaW5nIGFueSBzdWl0YWJsZSB1c2VyLXNwYWNlIHNp
Z25hbGluZyBtZWNoYW5pc20gKGENCj4gcXVldWUsIGNvbmR2YXIsIGV0YykgdG8gYXNrIGEgdGhy
ZWFkIHRvIHRyaWdnZXIgQlBGIHByb2dyYW0gKGZlbnRyeSBvbg0KPiBnZXRwZ2lkKCksIGZvciBp
bnN0YW5jZSkuDQoNCkkgZG9uJ3Qgc2VlIHdoeSB1c2VyIHNwYWNlIHNpZ25hbCBwbHVzIGZlbnRy
eSB3b3VsZCBiZSBmYXN0ZXIgdGhhbiBJUEkuDQpJZiB0aGUgdGFyZ2V0IGNwdSBpcyBydW5uaW5n
IHNvbWV0aGluZywgdGhpcyBnb25uYSBhZGQgdHdvIGNvbnRleHQgDQpzd2l0Y2hlcy4gDQoNCj4g
SSBiZXQgaW4gdGhpcyBjYXNlIHRoZSAgcGVyZm9ybWFuY2Ugd291bGQgYmUNCj4gcmVhbGx5IG5p
Y2UgZm9yIGEgbG90IG9mIHByYWN0aWNhbCB1c2UgY2FzZXMuIEJ1dCB0aGVuIGFnYWluLCBJIGRv
bid0DQo+IGtub3cgZGV0YWlscyBvZiB0aGUgaW50ZW5kZWQgdXNlIGNhc2UsIHNvIHBsZWFzZSBw
cm92aWRlIHNvbWUgbW9yZQ0KPiBkZXRhaWxzLg0KDQpCZWluZyBhYmxlIHRvIHRyaWdnZXIgQlBG
IHByb2dyYW0gb24gYSBkaWZmZXJlbnQgQ1BVIGNvdWxkIGVuYWJsZSBtYW55DQp1c2UgY2FzZXMg
YW5kIG9wdGltaXphdGlvbnMuIFRoZSB1c2UgY2FzZSBJIGFtIGxvb2tpbmcgYXQgaXMgdG8gYWNj
ZXNzDQpwZXJmX2V2ZW50IGFuZCBwZXJjcHUgbWFwcyBvbiB0aGUgdGFyZ2V0IENQVS4gRm9yIGV4
YW1wbGU6DQoJMC4gdHJpZ2dlciB0aGUgcHJvZ3JhbQ0KCTEuIHJlYWQgcGVyZl9ldmVudCBvbiBj
cHUgeDsNCgkyLiAob3B0aW9uYWwpIGNoZWNrIHdoaWNoIHByb2Nlc3MgaXMgcnVubmluZyBvbiBj
cHUgeDsNCgkzLiBhZGQgcGVyZl9ldmVudCB2YWx1ZSB0byBwZXJjcHUgbWFwKHMpIG9uIGNwdSB4
LiANCg0KSWYgd2UgZG8gdGhlc2Ugc3RlcHMgaW4gYSBCUEYgcHJvZ3JhbSBvbiBjcHUgeCwgdGhl
IGNvc3QgaXM6DQoJQS4wKSB0cmlnZ2VyIEJQRiB2aWEgSVBJOw0KCUEuMSkgcmVhZCBwZXJmX2V2
ZW50IGxvY2FsbHk7DQoJQS4yKSBsb2NhbCBhY2Nlc3MgY3VycmVudDsNCglBLjMpIGxvY2FsIGFj
Y2VzcyBvZiBwZXJjcHUgbWFwKHMpLiANCg0KSWYgd2UgY2FuIG9ubHkgZG8gdGhlc2Ugb24gYSBk
aWZmZXJlbnQgQ1BVLCB0aGUgY29zdCB3aWxsIGJlOg0KCUIuMCkgdHJpZ2dlciBCUEYgbG9jYWxs
eTsNCglCLjEpIHJlYWQgcGVyZl9ldmVudCB2aWEgSVBJOw0KCUIuMikgcmVtb3RlIGFjY2VzcyBj
dXJyZW50IG9uIGNwdSB4Ow0KCUIuMykgcmVtb3RlIGFjY2VzcyBwZXJjcHUgbWFwKHMpLCBvciB1
c2Ugbm9uLXBlcmNwdSBtYXAoMikuIA0KDQpDb3N0IG9mIChBLjAgKyBBLjEpIGlzIGFib3V0IHNh
bWUgYXMgKEIuMCArIEIuMSksIG1heWJlIGEgbGl0dGxlIGhpZ2hlcg0KKHN5c19icGYoKSwgdnMu
IHN5c19nZXRwZ2lkKCkpLiBCdXQgQS4yIGFuZCBBLjMgd2lsbCBiZSBzaWduaWZpY2FudGx5IA0K
Y2hlYXBlciB0aGFuIEIuMiBhbmQgQi4zLiANCg0KRG9lcyB0aGlzIG1ha2Ugc2Vuc2U/IA0KDQoN
Ck9UT0gsIEkgZG8gYWdyZWUgd2UgY2FuIHRyaWdnZXIgYnBmdHJhY2UgQkVHSU4vRU5EIHdpdGgg
c3lzX2dldHBnaWQoKSANCm9yIHNvbWV0aGluZyBzaW1pbGFyLiANCg0KVGhhbmtzLA0KU29uZw==
