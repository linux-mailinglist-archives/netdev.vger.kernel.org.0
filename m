Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79245179B22
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 22:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388456AbgCDVkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 16:40:12 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65276 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729144AbgCDVkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 16:40:12 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 024LdQVj021437;
        Wed, 4 Mar 2020 13:39:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nug/K0A8SK8SBjpD67hhY/w7qq7Q70NBJKylfLVvgdg=;
 b=J7Sc9oi9YhInjUTAhiUX0ooANsIRZ0kEJo1CCXtisRqWySQfOEtNXPMy51t1gDDroTwd
 t1gR8oG5jtxtNditWOU9nECypNWfdapoBe3t+mBo7p2MggulRfFxmZhgyWLZXdG2oSZg
 2MshYEy3tDWji7wumTKVMjNVKNXCvMEi4ms= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yjjnurhwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 04 Mar 2020 13:39:56 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 4 Mar 2020 13:39:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/+N4wuHGbrLOHxAsl3RIkgA6w95OGYIT+JWr7sq+VBK8bDIuiWN0oMqPgqXWS+Ohn8ts11FxkqB3JnVtgl78qdy5ELcgMrIAZsu9GRs7uzXD0rsAd98UKjmwu3cNchB6WTCa5xN1zmWmYhTNaIR0KC61uCNdNgSddWLNydwp1rxT93kLIHEvBxbJEUkuCoJNq+pLdFTQTxit/SYgO4uXEFCIBGy1YN9P2CaW3bLm/IV+9tE4I69bQstwH9HQd1sEP3167jQHbQohqyMyW8ivfMrpxdx1vnUYbQpQTIFTd3sMsnoZbGGDq6EFGfrgtSUOwmwgKOWhmUWLLK0pl+l/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nug/K0A8SK8SBjpD67hhY/w7qq7Q70NBJKylfLVvgdg=;
 b=hYApKGbuEJ1TM7SsiUjvqse5ufKssyEXgpgcPKBX1/IYVIRNvcy4o0V1WExwnvb3tZ932jNgDl/rtBqDc9lMdTT7g1fbAl/v0sbr29Tdn5eqpZQTT4RJODoMuo7kSD8+AWYga4x9D0accWDu5AldqyBl25z8uKx1SZ16oEhCyPTSVL1YtjsJEwG/KEkrLCR79NvwsJ2Ek4CHtGPA3JZe1i7NYYWzWdLbLzbqgHUgXlOnN7ecVQJzTVC5j4rtBJ73SDxM37RwzURIw3ILtVK2nbgs+ydRv5clTLt1QwpAX5ZNsj2ZdQ1hqemHq9bgy0MEwqk89nVySU+NLfsgPNyWMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nug/K0A8SK8SBjpD67hhY/w7qq7Q70NBJKylfLVvgdg=;
 b=IAqQVNWY6W0ShxS9CgzfiHvFbLQGhw1yPhvsb7jQ7LiI1nFOUNGG0XXz2EtkTKJQIMRtbkhchpkhyjEeVgtQKsB5ULgZqWxVJJ3vqEAUGzMMb7tZfQBo6ENC/opSPv5Ofs5IrhgfcZiOD3L4EfP2g67fd757lpLDYtnqc+VhMI8=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3993.namprd15.prod.outlook.com (2603:10b6:303:4e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Wed, 4 Mar
 2020 21:39:53 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2772.019; Wed, 4 Mar 2020
 21:39:53 +0000
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
Thread-Index: AQHV8k/ID7Brhxz/CkyCD9Xa6Igk7Kg4y9qAgAAaOACAAAmkAIAAA6WAgAAC5QA=
Date:   Wed, 4 Mar 2020 21:39:52 +0000
Message-ID: <4C0824FE-37CB-4660-BAE0-0EAE8F6BF8A0@fb.com>
References: <20200304180710.2677695-1-songliubraving@fb.com>
 <20200304190807.GA168640@krava> <20200304204158.GD168640@krava>
 <C7C4E8E1-9176-48DC-8089-D4AEDE86E720@fb.com> <20200304212931.GE168640@krava>
In-Reply-To: <20200304212931.GE168640@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:4f8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08ac709e-01f1-43e9-31cf-08d7c0849323
x-ms-traffictypediagnostic: MW3PR15MB3993:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB3993C1D8DD75720217B0525BB3E50@MW3PR15MB3993.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:462;
x-forefront-prvs: 0332AACBC3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(136003)(346002)(396003)(39860400002)(189003)(199004)(2616005)(54906003)(33656002)(36756003)(6506007)(53546011)(6916009)(5660300002)(316002)(71200400001)(966005)(186003)(66946007)(6512007)(2906002)(478600001)(66556008)(6486002)(66446008)(66476007)(81166006)(76116006)(4326008)(86362001)(81156014)(8676002)(8936002)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3993;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BKsLJwcghPv2MSb9rtp6TAvbcADNTZHlUwF2FLJZpS1G0XhBC6DsCzMCkPdTo7S04TT3Bykpw5EQNiia0pV4UgrLfQ/WQ9pTyXwlUgMcBpCcNSvqHwa07r/INadjdiUUF1uA5dpokBrMfOxU7s7iMcw4fHMVzttY7Q93HeBviMpDo/6weK8extMlWiKL4dWIkikbig4EkZADxnZhQkfg0+VUhLC25gb9v9Z8yYF4IRdNyyGkFmt3ynfinQ/1bePuXhQwGhuiZYQh1GcUcSejlRZ+oAMl8QmAgLPDPawZ5hfkBisIlsdA8V9tpCbDJNa1SsLJBANjS33+IcsHGN/M9QUO71KtVm9qnMRcwq8hb1gnPfaqS2Bs4gyhGRpJIGse5DdbM+FmCBDDA7nuhESwDItWn07lbhc1yj4ruFRfeevubUpAD/a10/WLwKh5wP3ZrZrDRaQ/GyMziNFeZDM6pcq78YJFUFOdhCJK6O5wU/Q1mmuuyOVYil1XelyTxX2eXTyfYBgZ5nZOMDakHZYYRA==
x-ms-exchange-antispam-messagedata: fYNA9GIcwbdsa1DrSFqzqJ5B1auqdULJIqWB3oTV31ti6SSM0NI0oCnOo1caiWGmqfqbXY3YmObTWriVoS/BAEHv2Be1zVzy3+rF3Ue5eHpsb5ydGYNhfnTFh27hT1e3em2VlV6XF0xh6ZxY311laSOBwszMyHo6SyJ+lWiAJJDFL9GqTtf6UxakbVyezpez
Content-Type: text/plain; charset="utf-8"
Content-ID: <347D4D270A1F3541A9F1BE1846AA1F5D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 08ac709e-01f1-43e9-31cf-08d7c0849323
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2020 21:39:53.0289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l5kVbrY73MdCLasfkDD790c3boMgmmPzmuIcHLHKtuFuwg7zRVsz7ozqvhrD75WfcFKJXdSZLY5jhCYADzXGpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3993
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-04_09:2020-03-04,2020-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 adultscore=0 clxscore=1015 spamscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003040138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTWFyIDQsIDIwMjAsIGF0IDE6MjkgUE0sIEppcmkgT2xzYSA8am9sc2FAcmVkaGF0
LmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIE1hciAwNCwgMjAyMCBhdCAwOToxNjoyOVBNICsw
MDAwLCBTb25nIExpdSB3cm90ZToNCj4+IA0KPj4gDQo+Pj4gT24gTWFyIDQsIDIwMjAsIGF0IDEy
OjQxIFBNLCBKaXJpIE9sc2EgPGpvbHNhQHJlZGhhdC5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IE9u
IFdlZCwgTWFyIDA0LCAyMDIwIGF0IDA4OjA4OjA3UE0gKzAxMDAsIEppcmkgT2xzYSB3cm90ZToN
Cj4+Pj4gT24gV2VkLCBNYXIgMDQsIDIwMjAgYXQgMTA6MDc6MDZBTSAtMDgwMCwgU29uZyBMaXUg
d3JvdGU6DQo+Pj4+PiBUaGlzIHNldCBpbnRyb2R1Y2VzIGJwZnRvb2wgcHJvZyBwcm9maWxlIGNv
bW1hbmQsIHdoaWNoIHVzZXMgaGFyZHdhcmUNCj4+Pj4+IGNvdW50ZXJzIHRvIHByb2ZpbGUgQlBG
IHByb2dyYW1zLg0KPj4+Pj4gDQo+Pj4+PiBUaGlzIGNvbW1hbmQgYXR0YWNoZXMgZmVudHJ5L2Zl
eGl0IHByb2dyYW1zIHRvIGEgdGFyZ2V0IHByb2dyYW0uIFRoZXNlIHR3bw0KPj4+Pj4gcHJvZ3Jh
bXMgcmVhZCBoYXJkd2FyZSBjb3VudGVycyBiZWZvcmUgYW5kIGFmdGVyIHRoZSB0YXJnZXQgcHJv
Z3JhbSBhbmQNCj4+Pj4+IGNhbGN1bGF0ZSB0aGUgZGlmZmVyZW5jZS4NCj4+Pj4+IA0KPj4+Pj4g
Q2hhbmdlcyB2MyA9PiB2NDoNCj4+Pj4+IDEuIFNpbXBsaWZ5IGVyciBoYW5kbGluZyBpbiBwcm9m
aWxlX29wZW5fcGVyZl9ldmVudHMoKSAoUXVlbnRpbik7DQo+Pj4+PiAyLiBSZW1vdmUgcmVkdW5k
YW50IHBfZXJyKCkgKFF1ZW50aW4pOw0KPj4+Pj4gMy4gUmVwbGFjZSB0YWIgd2l0aCBzcGFjZSBp
biBiYXNoLWNvbXBsZXRpb247IChRdWVudGluKTsNCj4+Pj4+IDQuIEZpeCB0eXBvIF9icGZ0b29s
X2dldF9tYXBfbmFtZXMgPT4gX2JwZnRvb2xfZ2V0X3Byb2dfbmFtZXMgKFF1ZW50aW4pLg0KPj4+
PiANCj4+Pj4gaHVtLCBJJ20gZ2V0dGluZzoNCj4+Pj4gDQo+Pj4+IAlbam9sc2FAZGVsbC1yNDQw
LTAxIGJwZnRvb2xdJCBwd2QNCj4+Pj4gCS9ob21lL2pvbHNhL2xpbnV4LXBlcmYvdG9vbHMvYnBm
L2JwZnRvb2wNCj4+Pj4gCVtqb2xzYUBkZWxsLXI0NDAtMDEgYnBmdG9vbF0kIG1ha2UNCj4+Pj4g
CS4uLg0KPj4+PiAJbWFrZVsxXTogTGVhdmluZyBkaXJlY3RvcnkgJy9ob21lL2pvbHNhL2xpbnV4
LXBlcmYvdG9vbHMvbGliL2JwZicNCj4+Pj4gCSAgTElOSyAgICAgX2JwZnRvb2wNCj4+Pj4gCW1h
a2U6ICoqKiBObyBydWxlIHRvIG1ha2UgdGFyZ2V0ICdza2VsZXRvbi9wcm9maWxlci5icGYuYycs
IG5lZWRlZCBieSAnc2tlbGV0b24vcHJvZmlsZXIuYnBmLm8nLiAgU3RvcC4NCj4+PiANCj4+PiBv
aywgSSBoYWQgdG8gYXBwbHkgeW91ciBwYXRjaGVzIGJ5IGhhbmQsIGJlY2F1c2UgJ2dpdCBhbScg
cmVmdXNlZCB0bw0KPj4+IGR1ZSB0byBmdXp6Li4gc28gc29tZSBvZiB5b3UgbmV3IGZpbGVzIGRp
ZCBub3QgbWFrZSBpdCB0byBteSB0cmVlIDstKQ0KPj4+IA0KPj4+IGFueXdheSBJIGhpdCBhbm90
aGVyIGVycm9yIG5vdzoNCj4+PiANCj4+PiAJICBDQyAgICAgICBwcm9nLm8NCj4+PiAJSW4gZmls
ZSBpbmNsdWRlZCBmcm9tIHByb2cuYzoxNTUzOg0KPj4+IAlwcm9maWxlci5za2VsLmg6IEluIGZ1
bmN0aW9uIOKAmHByb2ZpbGVyX2JwZl9fY3JlYXRlX3NrZWxldG9u4oCZOg0KPj4+IAlwcm9maWxl
ci5za2VsLmg6MTM2OjM1OiBlcnJvcjog4oCYc3RydWN0IHByb2ZpbGVyX2JwZuKAmSBoYXMgbm8g
bWVtYmVyIG5hbWVkIOKAmHJvZGF0YeKAmQ0KPj4+IAkgIDEzNiB8ICBzLT5tYXBzWzRdLm1tYXBl
ZCA9ICh2b2lkICoqKSZvYmotPnJvZGF0YTsNCj4+PiAJICAgICAgfCAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXn4NCj4+PiAJcHJvZy5jOiBJbiBmdW5jdGlvbiDigJhwcm9maWxl
X3JlYWRfdmFsdWVz4oCZOg0KPj4+IAlwcm9nLmM6MTY1MDoyOTogZXJyb3I6IOKAmHN0cnVjdCBw
cm9maWxlcl9icGbigJkgaGFzIG5vIG1lbWJlciBuYW1lZCDigJhyb2RhdGHigJkNCj4+PiAJIDE2
NTAgfCAgX191MzIgbSwgY3B1LCBudW1fY3B1ID0gb2JqLT5yb2RhdGEtPm51bV9jcHU7DQo+Pj4g
DQo+Pj4gSSdsbCB0cnkgdG8gZmlndXJlIGl0IG91dC4uIG1pZ2h0IGJlIGVycm9yIG9uIG15IGVu
ZA0KPj4+IA0KPj4+IGRvIHlvdSBoYXZlIGdpdCByZXBvIHdpdGggdGhlc2UgY2hhbmdlcz8NCj4+
IA0KPj4gSSBwdXNoZWQgaXQgdG8gDQo+PiANCj4+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L3NvbmcvbGludXguZ2l0L3RyZWUvP2g9YnBmLXBlci1wcm9n
LXN0YXRzDQo+IA0KPiBzdGlsbCB0aGUgc2FtZToNCj4gDQo+IAlbam9sc2FAZGVsbC1yNDQwLTAx
IGJwZnRvb2xdJCBnaXQgc2hvdyAtLW9uZWxpbmUgSEVBRCB8IGhlYWQgLTENCj4gCTdiYmRhNWNj
YTAwYSBicGZ0b29sOiBmaXggdHlwbyBpbiBiYXNoLWNvbXBsZXRpb24NCj4gCVtqb2xzYUBkZWxs
LXI0NDAtMDEgYnBmdG9vbF0kIG1ha2UgDQo+IAltYWtlWzFdOiBFbnRlcmluZyBkaXJlY3Rvcnkg
Jy9ob21lL2pvbHNhL2xpbnV4LXBlcmYvdG9vbHMvbGliL2JwZicNCj4gCW1ha2VbMV06IExlYXZp
bmcgZGlyZWN0b3J5ICcvaG9tZS9qb2xzYS9saW51eC1wZXJmL3Rvb2xzL2xpYi9icGYnDQo+IAkg
IENDICAgICAgIHByb2cubw0KPiAJSW4gZmlsZSBpbmNsdWRlZCBmcm9tIHByb2cuYzoxNTUzOg0K
PiAJcHJvZmlsZXIuc2tlbC5oOiBJbiBmdW5jdGlvbiDigJhwcm9maWxlcl9icGZfX2NyZWF0ZV9z
a2VsZXRvbuKAmToNCj4gCXByb2ZpbGVyLnNrZWwuaDoxMzY6MzU6IGVycm9yOiDigJhzdHJ1Y3Qg
cHJvZmlsZXJfYnBm4oCZIGhhcyBubyBtZW1iZXIgbmFtZWQg4oCYcm9kYXRh4oCZDQo+IAkgIDEz
NiB8ICBzLT5tYXBzWzRdLm1tYXBlZCA9ICh2b2lkICoqKSZvYmotPnJvZGF0YTsNCj4gCSAgICAg
IHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+DQo+IAlwcm9nLmM6IEluIGZ1
bmN0aW9uIOKAmHByb2ZpbGVfcmVhZF92YWx1ZXPigJk6DQo+IAlwcm9nLmM6MTY1MDoyOTogZXJy
b3I6IOKAmHN0cnVjdCBwcm9maWxlcl9icGbigJkgaGFzIG5vIG1lbWJlciBuYW1lZCDigJhyb2Rh
dGHigJkNCj4gCSAxNjUwIHwgIF9fdTMyIG0sIGNwdSwgbnVtX2NwdSA9IG9iai0+cm9kYXRhLT5u
dW1fY3B1Ow0KPiAJICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn4NCj4gCXBy
b2cuYzogSW4gZnVuY3Rpb24g4oCYcHJvZmlsZV9vcGVuX3BlcmZfZXZlbnRz4oCZOg0KPiAJcHJv
Zy5jOjE4MTA6MTk6IGVycm9yOiDigJhzdHJ1Y3QgcHJvZmlsZXJfYnBm4oCZIGhhcyBubyBtZW1i
ZXIgbmFtZWQg4oCYcm9kYXRh4oCZDQo+IAkgMTgxMCB8ICAgc2l6ZW9mKGludCksIG9iai0+cm9k
YXRhLT5udW1fY3B1ICogb2JqLT5yb2RhdGEtPm51bV9tZXRyaWMpOw0KPiAJICAgICAgfCAgICAg
ICAgICAgICAgICAgICBefg0KPiAJcHJvZy5jOjE4MTA6NDI6IGVycm9yOiDigJhzdHJ1Y3QgcHJv
ZmlsZXJfYnBm4oCZIGhhcyBubyBtZW1iZXIgbmFtZWQg4oCYcm9kYXRh4oCZDQo+IAkgMTgxMCB8
ICAgc2l6ZW9mKGludCksIG9iai0+cm9kYXRhLT5udW1fY3B1ICogb2JqLT5yb2RhdGEtPm51bV9t
ZXRyaWMpOw0KPiAJICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIF5+DQo+IAlwcm9nLmM6MTgyNToyNjogZXJyb3I6IOKAmHN0cnVjdCBwcm9maWxlcl9icGbi
gJkgaGFzIG5vIG1lbWJlciBuYW1lZCDigJhyb2RhdGHigJkNCj4gCSAxODI1IHwgICBmb3IgKGNw
dSA9IDA7IGNwdSA8IG9iai0+cm9kYXRhLT5udW1fY3B1OyBjcHUrKykgew0KPiAJICAgICAgfCAg
ICAgICAgICAgICAgICAgICAgICAgICAgXn4NCj4gCXByb2cuYzogSW4gZnVuY3Rpb24g4oCYZG9f
cHJvZmlsZeKAmToNCj4gCXByb2cuYzoxOTA0OjEzOiBlcnJvcjog4oCYc3RydWN0IHByb2ZpbGVy
X2JwZuKAmSBoYXMgbm8gbWVtYmVyIG5hbWVkIOKAmHJvZGF0YeKAmQ0KPiAJIDE5MDQgfCAgcHJv
ZmlsZV9vYmotPnJvZGF0YS0+bnVtX2NwdSA9IG51bV9jcHU7DQo+IAkgICAgICB8ICAgICAgICAg
ICAgIF5+DQo+IAlwcm9nLmM6MTkwNToxMzogZXJyb3I6IOKAmHN0cnVjdCBwcm9maWxlcl9icGbi
gJkgaGFzIG5vIG1lbWJlciBuYW1lZCDigJhyb2RhdGHigJkNCj4gCSAxOTA1IHwgIHByb2ZpbGVf
b2JqLT5yb2RhdGEtPm51bV9tZXRyaWMgPSBudW1fbWV0cmljOw0KPiAJICAgICAgfCAgICAgICAg
ICAgICBefg0KPiAJbWFrZTogKioqIFtNYWtlZmlsZToxMjk6IHByb2cub10gRXJyb3IgMQ0KDQpJ
IGd1ZXNzIHlvdSBuZWVkIGEgbmV3ZXIgdmVyc2lvbiBvZiBjbGFuZyB0aGF0IHN1cHBvcnRzIGds
b2JhbCBkYXRhIGluIEJQRiBwcm9ncmFtcy4gDQoNClRoYW5rcywNClNvbmc=
