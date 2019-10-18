Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8DE9DCBDB
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502168AbfJRQss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:48:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405911AbfJRQsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:48:47 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9IGm64H021092;
        Fri, 18 Oct 2019 09:48:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4iKM3Bg5yBv9BPh66fLxysuD37RyqbVM+X47dR0qHEM=;
 b=cg7UOSVhYpIX2UCuD+3oMlr1jaCgC72HUtJI1nQAGx3uxF+ZEluKy87CZKEMOrKQuzo7
 DEqdi2Dqpnoyf6DDxQqdD4LqnrJGdZCZB2FjDsj7TedK4j2CBYoRif8EcErIpJYBxhPA
 cG9U7ueS+QrqYFrnl28gmd5OAMbRzTBdjis= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vqeungsb8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Oct 2019 09:48:35 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 18 Oct 2019 09:48:27 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 09:48:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8tMAdG8o3a2e96DjlV3yw77yRdPZw803ASOLf9jVl2wRv3Hy1QF6tBUmfynWSPVVZKzoheEz7ltI+4zdzow6SirSdpqkda5LRwuQNppdIXij7WyBg+XdnPXsUVwDAkTikHRG6FZZS7kopUUh7GztRbWqX8UZozmdwGCLyYJ18Uuus4x8rDbx3zgyYgU0aJgw/R1MPExOpHPcqaOrR67XuYZGsqUCSU5QCY1ESotNALUZu2i+pQ0KGsixJm3CTDHzEUKlwijkJHHW0fTgvFs3M89YynVJmoj34SrtlOOV92yyNz7puOSM59dgSueWsFrGavPTY6VdAoOZXEAvUKvvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4iKM3Bg5yBv9BPh66fLxysuD37RyqbVM+X47dR0qHEM=;
 b=XAawA2CNwaMWVj6z3TMv/2pMVgwPFDZEeaarNvKtPR571rdgUO2Hqze2RDGUYIJmR/9M5RhZvgszDsrF+3gWfZ+L2LdkKYUJOrK2zv43Cn8Hj8XOQX9maZFiQQ5cS/TgG2LhoMS72EENEcKq1Gdc4K+4ZQDGkKH2aDRbULYd/jhhfUlwBomRp9wdmjclyK782V8Mz2kCPTxMpJpuuGhmaSNoK3tAURVgpc/w4hQR+OrRG3ln+o74K/mKRO60kksaeV0ElAZ0UJ4VJ/YPZU9WVRHA4xCE8dKfrglvo7hu1G3IJCVCM9gQa+ms4ee7ngup431IL5G9ytNfS2mPF0X0Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4iKM3Bg5yBv9BPh66fLxysuD37RyqbVM+X47dR0qHEM=;
 b=IVqx2WyuK8rI8K2vawE1rXWpX4gDCAcf8v1C2QpxDKF3blxhcqlAwrphZD73wKIAhVmJdymBh3h8YTWQeE6lDplbdkzhmBCUuLBN23Tu/ssNKN49XJztx0qN7uvdLkQckqFcvBySf9kVY7w9s0orciy3WiYBH8oVS3qi0lqtbqc=
Received: from CY4PR15MB1479.namprd15.prod.outlook.com (10.172.162.17) by
 CY4PR15MB1205.namprd15.prod.outlook.com (10.172.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 18 Oct 2019 16:48:26 +0000
Received: from CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::39aa:ec42:e834:f1a9]) by CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::39aa:ec42:e834:f1a9%4]) with mapi id 15.20.2347.023; Fri, 18 Oct 2019
 16:48:26 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH] bpftool: Try to read btf as raw data if elf read fails
Thread-Topic: [PATCH] bpftool: Try to read btf as raw data if elf read fails
Thread-Index: AQHVhZ+Wi4WoVSgMDkyIfCRXDb092KdgnHaA
Date:   Fri, 18 Oct 2019 16:48:25 +0000
Message-ID: <d8620b04-346a-11eb-000f-34d0f9f0cd51@fb.com>
References: <20191018103404.12999-1-jolsa@kernel.org>
In-Reply-To: <20191018103404.12999-1-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0058.namprd15.prod.outlook.com
 (2603:10b6:101:1f::26) To CY4PR15MB1479.namprd15.prod.outlook.com
 (2603:10b6:903:100::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:ae05]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b9e01a8-10b6-44b4-c997-08d753eafebb
x-ms-traffictypediagnostic: CY4PR15MB1205:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB12054A6EEA3D8C1C11B05031C66C0@CY4PR15MB1205.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(346002)(39860400002)(376002)(199004)(189003)(256004)(2616005)(4326008)(386003)(53546011)(6486002)(476003)(486006)(6506007)(6116002)(64756008)(66476007)(66556008)(478600001)(66446008)(86362001)(186003)(65806001)(66946007)(102836004)(52116002)(76176011)(65956001)(71190400001)(2906002)(99286004)(71200400001)(46003)(7736002)(36756003)(14454004)(31696002)(6246003)(25786009)(11346002)(6512007)(6436002)(316002)(8936002)(8676002)(446003)(81156014)(31686004)(81166006)(305945005)(5660300002)(229853002)(58126008)(54906003)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1205;H:CY4PR15MB1479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LqKxHdzq71Jtlz6eNpdGP8T5NBQi8/KrTo91ESbvEqAPuyioBT740ERkdJmmLrnNMvmGmgL0aerjkBODF4DGoj5jWU8C0fbbqJ7k437KcIhR6QonFIIZL90Cmi36QMlRdlQ0V2x4YFoKF3mwDyzEFyL+QQD5iCMbCgZjf3Licbq+gt/XQV7QbRYXqW06FfsIjIg9nQyvxA+qRumBFDtkMs5fW8nYVAwrlCuNiI+WJcEqEeC/fWsqh4MgD4iXf1aG/exjPSZ+koi+S3CyTBa4VHM8nIrR5ZqSSNZd69KyPy85gHnzqqm7IC+xt11vLXzE+Q2Lqh/YTuOfQ0XH0TMRr8YfZLkJU04nUnBTgOWKI4hK5B8oqU/bT67dIWcmbcsCFLgEfDCpC8Rehf9wSquSvEGVsMsO5gFkHWdfOL0j5H0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A14C60956F096040B8B4B29FFB652815@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9e01a8-10b6-44b4-c997-08d753eafebb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 16:48:26.0425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eBA7G3e4t/XLmySpRl9aNssP18/EEqUPtlN71+wNSW7kNXSaHmtXOHg6TAdT1Ps0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1205
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_04:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 clxscore=1011
 spamscore=0 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910180153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTgvMTkgMzozNCBBTSwgSmlyaSBPbHNhIHdyb3RlOg0KPiBUaGUgYnBmdG9vbCBpbnRl
cmZhY2Ugc3RheXMgdGhlIHNhbWUsIGJ1dCBub3cgaXQncyBwb3NzaWJsZQ0KPiB0byBydW4gaXQg
b3ZlciBCVEYgcmF3IGRhdGEsIGxpa2U6DQoNCk9oLCBncmVhdCwgSSBoYWQgc2ltaWxhciBwYXRj
aCBsYXlpbmcgYXJvdW5kIGZvciBhIHdoaWxlLCBuZXZlciBnb3QgdG8gDQpjbGVhbmluZyBpdCB1
cCwgdGhvdWdoLCBzbyB0aGFua3MgZm9yIHBpY2tpbmcgdGhpcyB1cCENCg0KPiANCj4gICAgJCBi
cGZ0b29sIGJ0ZiBkdW1wIGZpbGUgL3N5cy9rZXJuZWwvYnRmL3ZtbGludXgNCj4gICAgbGliYnBm
OiBmYWlsZWQgdG8gZ2V0IEVIRFIgZnJvbSAvc3lzL2tlcm5lbC9idGYvdm1saW51eA0KDQpXZSBz
aG91bGQgaW1wbGVtZW50IHRoaXMgc28gdGhhdCB3ZSBkb24ndCBnZXQgYW4gZXh0cmEgbG9nIG91
dHB1dCB3aXRoIA0KZXJyb3JzLiBJJ3ZlIGJlZW4gdGhpbmtpbmcgYWJvdXQgY2hlY2tpbmcgZmly
c3QgZmV3IGJ5dGVzIG9mIHRoZSBmaWxlLiANCklmIHRoYXQgbWF0Y2hlcyBCVEZfTUFHSUMsIHRo
ZW4gdHJ5IHRvIHBhcnNlIGl0IGFzIHJhdyBCVEYsIG90aGVyd2lzZSANCnBhcnNlIGFzIEVMRiB3
LyBCVEYuIERvZXMgaXQgbWFrZSBzZW5zZT8NCg0KPiAgICBbMV0gSU5UICcoYW5vbiknIHNpemU9
NCBiaXRzX29mZnNldD0wIG5yX2JpdHM9MzIgZW5jb2Rpbmc9KG5vbmUpDQo+ICAgIFsyXSBJTlQg
J2xvbmcgdW5zaWduZWQgaW50JyBzaXplPTggYml0c19vZmZzZXQ9MCBucl9iaXRzPTY0IGVuY29k
aW5nPShub25lKQ0KPiAgICBbM10gQ09OU1QgJyhhbm9uKScgdHlwZV9pZD0yDQo+IA0KPiBJJ20g
YWxzbyBhZGRpbmcgZXJyIGluaXQgdG8gMCBiZWNhdXNlIEkgd2FzIGdldHRpbmcgdW5pbml0aWFs
aXplZA0KPiB3YXJuaW5ncyBmcm9tIGdjYy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEppcmkgT2xz
YSA8am9sc2FAa2VybmVsLm9yZz4NCj4gLS0tDQo+ICAgdG9vbHMvYnBmL2JwZnRvb2wvYnRmLmMg
fCA0NyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLQ0KPiAgIDEgZmls
ZSBjaGFuZ2VkLCA0MiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL3Rvb2xzL2JwZi9icGZ0b29sL2J0Zi5jIGIvdG9vbHMvYnBmL2JwZnRvb2wvYnRmLmMN
Cj4gaW5kZXggOWE5Mzc2ZDFkM2RmLi4xMDBmYjdlMDIzMjkgMTAwNjQ0DQo+IC0tLSBhL3Rvb2xz
L2JwZi9icGZ0b29sL2J0Zi5jDQo+ICsrKyBiL3Rvb2xzL2JwZi9icGZ0b29sL2J0Zi5jDQo+IEBA
IC0xMiw2ICsxMiw5IEBADQo+ICAgI2luY2x1ZGUgPGxpYmJwZi5oPg0KPiAgICNpbmNsdWRlIDxs
aW51eC9idGYuaD4NCj4gICAjaW5jbHVkZSA8bGludXgvaGFzaHRhYmxlLmg+DQo+ICsjaW5jbHVk
ZSA8c3lzL3R5cGVzLmg+DQo+ICsjaW5jbHVkZSA8c3lzL3N0YXQuaD4NCj4gKyNpbmNsdWRlIDx1
bmlzdGQuaD4NCj4gICANCj4gICAjaW5jbHVkZSAiYnRmLmgiDQo+ICAgI2luY2x1ZGUgImpzb25f
d3JpdGVyLmgiDQo+IEBAIC0zODgsNiArMzkxLDM1IEBAIHN0YXRpYyBpbnQgZHVtcF9idGZfYyhj
b25zdCBzdHJ1Y3QgYnRmICpidGYsDQo+ICAgCXJldHVybiBlcnI7DQo+ICAgfQ0KPiAgIA0KPiAr
c3RhdGljIHN0cnVjdCBidGYgKmJ0Zl9fcGFyc2VfcmF3KGNvbnN0IGNoYXIgKmZpbGUpDQo+ICt7
DQo+ICsJc3RydWN0IGJ0ZiAqYnRmID0gRVJSX1BUUigtRUlOVkFMKTsNCj4gKwlfX3U4ICpidWYg
PSBOVUxMOw0KPiArCXN0cnVjdCBzdGF0IHN0Ow0KPiArCUZJTEUgKmY7DQo+ICsNCj4gKwlpZiAo
c3RhdChmaWxlLCAmc3QpKQ0KPiArCQlyZXR1cm4gYnRmOw0KPiArDQo+ICsJZiA9IGZvcGVuKGZp
bGUsICJyYiIpOw0KPiArCWlmICghZikNCj4gKwkJcmV0dXJuIGJ0ZjsNCj4gKw0KPiArCWJ1ZiA9
IG1hbGxvYyhzdC5zdF9zaXplKTsNCj4gKwlpZiAoIWJ1ZikNCj4gKwkJZ290byBlcnI7DQo+ICsN
Cj4gKwlpZiAoKHNpemVfdCkgc3Quc3Rfc2l6ZSAhPSBmcmVhZChidWYsIDEsIHN0LnN0X3NpemUs
IGYpKQ0KPiArCQlnb3RvIGVycjsNCj4gKw0KPiArCWJ0ZiA9IGJ0Zl9fbmV3KGJ1Ziwgc3Quc3Rf
c2l6ZSk7DQo+ICsNCj4gK2VycjoNCj4gKwlmcmVlKGJ1Zik7DQo+ICsJZmNsb3NlKGYpOw0KPiAr
CXJldHVybiBidGY7DQo+ICt9DQo+ICsNCj4gICBzdGF0aWMgaW50IGRvX2R1bXAoaW50IGFyZ2Ms
IGNoYXIgKiphcmd2KQ0KPiAgIHsNCj4gICAJc3RydWN0IGJ0ZiAqYnRmID0gTlVMTDsNCj4gQEAg
LTM5Nyw3ICs0MjksNyBAQCBzdGF0aWMgaW50IGRvX2R1bXAoaW50IGFyZ2MsIGNoYXIgKiphcmd2
KQ0KPiAgIAlfX3UzMiBidGZfaWQgPSAtMTsNCj4gICAJY29uc3QgY2hhciAqc3JjOw0KPiAgIAlp
bnQgZmQgPSAtMTsNCj4gLQlpbnQgZXJyOw0KPiArCWludCBlcnIgPSAwOw0KPiAgIA0KPiAgIAlp
ZiAoIVJFUV9BUkdTKDIpKSB7DQo+ICAgCQl1c2FnZSgpOw0KPiBAQCAtNDY4LDEwICs1MDAsMTUg
QEAgc3RhdGljIGludCBkb19kdW1wKGludCBhcmdjLCBjaGFyICoqYXJndikNCj4gICAJCWJ0ZiA9
IGJ0Zl9fcGFyc2VfZWxmKCphcmd2LCBOVUxMKTsNCj4gICAJCWlmIChJU19FUlIoYnRmKSkgew0K
PiAgIAkJCWVyciA9IFBUUl9FUlIoYnRmKTsNCj4gLQkJCWJ0ZiA9IE5VTEw7DQo+IC0JCQlwX2Vy
cigiZmFpbGVkIHRvIGxvYWQgQlRGIGZyb20gJXM6ICVzIiwNCj4gLQkJCSAgICAgICphcmd2LCBz
dHJlcnJvcihlcnIpKTsNCj4gLQkJCWdvdG8gZG9uZTsNCj4gKwkJCWlmIChlcnIgPT0gLUxJQkJQ
Rl9FUlJOT19fRk9STUFUKQ0KPiArCQkJCWJ0ZiA9IGJ0Zl9fcGFyc2VfcmF3KCphcmd2KTsNCj4g
KwkJCWlmIChJU19FUlIoYnRmKSkgew0KPiArCQkJCWJ0ZiA9IE5VTEw7DQo+ICsJCQkJLyogRGlz
cGxheSB0aGUgb3JpZ2luYWwgZXJyb3IgdmFsdWUuICovDQo+ICsJCQkJcF9lcnIoImZhaWxlZCB0
byBsb2FkIEJURiBmcm9tICVzOiAlcyIsDQo+ICsJCQkJICAgICAgKmFyZ3YsIHN0cmVycm9yKGVy
cikpOw0KPiArCQkJCWdvdG8gZG9uZTsNCj4gKwkJCX0NCj4gICAJCX0NCj4gICAJCU5FWFRfQVJH
KCk7DQo+ICAgCX0gZWxzZSB7DQo+IA0KDQo=
