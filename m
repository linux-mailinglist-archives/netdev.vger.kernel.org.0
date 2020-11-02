Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDA52A277B
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 10:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgKBJvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 04:51:47 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15710 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727992AbgKBJvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 04:51:46 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A29pYB1002794;
        Mon, 2 Nov 2020 01:51:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=zjJfF5V28gqZ56sE5eHnO9VTLWfFPG7eir7kac9q4CU=;
 b=aHi5PfBAd4MOnM+Iak8jT+8NP0VKGZjQCi1T9bVgaosTmPCBQIdhLY6gHl+2QpaJdCb/
 fEhiMp0SBmkhpDeG9GbC6G0AD5bBl/49tTleDmwqw8g+D0GNhlY/MjMRSgHFmHQsnLE+
 ydMIxP3Jr4UxrPoXjQ+ObniCaEcdO3jx/GBoeN1GV1RrfVa5KU147xawwTylpA4/fWvj
 ZjN8rbX2XJ+YM/L0PVPyLIaAk0ymv1mdnUW8DPBMqEuARZnx9s7k2K8ufvVoZooWs3IA
 oYrb5HGGohHAAIYt0Ho0PxVvo2DsJ8+URPnO7v0AENaF79oZen79wpdZsFpawx9qYG8P Yw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 34h7enpq5n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 01:51:34 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 2 Nov
 2020 01:51:32 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 2 Nov 2020 01:51:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLVZA8xL0hp+Y1Zb6gE9gmaXbFM/fF+S/KwEwPAJOkecXHa4ej8GZAr+sRke/a++jUh4vY+ofCaKWZQ89z2x04wwomEkiorbkB5IQfQyBJlkLjQswK1hFziNL4Jfi/AQm8qwk7pWm2N45IOsqQLWPb2vo5SMiUhtVxOUVj7hXehEDp0fZu621SKJozkSeCwaID6O3IK4xPbjM4hcfMzDjCkxoviDk1uh4m5Yh1fGuR3yoLsqI99V2wprMBQvrlrfGa43yBiYfrFQj2RNqHgQFuo/POqQtWZZhSPZtEg25EAmBHrbFsMWnrEUpLb881U0MZpQfERFLmJPxZ1s7RzpRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjJfF5V28gqZ56sE5eHnO9VTLWfFPG7eir7kac9q4CU=;
 b=lEI5an6eqEht5Vr7b+0CObQjRokniKGRbWJjjNQyjfzlu823j9I1PDzwu8WFZtoba79Fa8Aa6Fr1M4Jturf6P4SctmCkBD7M3vmXZmjIA2Hj2+QRkFY5pWUuYBfQAAIFJRAdVYSiAMe1kodbjpNg4VhqflP+ymMoWQtWukX/zabGb38JtdqGpPMt2hR3ItbNm3wURuR5dJyCwnB8Zku7ZIRPTwTJUrAYsi8MVkUWdkmR5oawt7JoEuf+BXTIpS81rEadis8eT9ry8G086x0lheU2ejmnYTv2+TWccIhkeC2Oe8RKKDJa4HeHRHIlHoit67jLgIk716KMhQY4XwrDig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zjJfF5V28gqZ56sE5eHnO9VTLWfFPG7eir7kac9q4CU=;
 b=Ms1LqZJKphGaEF7vgKeT05hhV2+KTMNORBslIc8h5EAJDYxmhK8pLZbDO+tM3IognHMy9wLQiCCfSHKGX1IzBxt4OeQy+5fJTb/XZ6Ushr6VXTkJrj2lE6cWGdzcHLexSCGg9Qh1Q93kh3KuUknzHjHBcEgX16/L7DO4dTkTpDE=
Received: from BYAPR18MB2791.namprd18.prod.outlook.com (2603:10b6:a03:111::21)
 by BY5PR18MB3409.namprd18.prod.outlook.com (2603:10b6:a03:1af::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Mon, 2 Nov
 2020 09:51:28 +0000
Received: from BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::68cb:a1a3:e1cf:f9d2]) by BYAPR18MB2791.namprd18.prod.outlook.com
 ([fe80::68cb:a1a3:e1cf:f9d2%5]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 09:51:28 +0000
From:   Srujana Challa <schalla@marvell.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Suheil Chandran <schandran@marvell.com>,
        "Narayana Prasad Raju Athreya" <pathreya@marvell.com>
Subject: RE: [EXT] Re: [PATCH v8,net-next,02/12] octeontx2-af: add mailbox
 interface for CPT
Thread-Topic: [EXT] Re: [PATCH v8,net-next,02/12] octeontx2-af: add mailbox
 interface for CPT
Thread-Index: AQHWrTnGmauEeee310SK81XISN0owKmwUwGAgARMNYA=
Date:   Mon, 2 Nov 2020 09:51:28 +0000
Message-ID: <BYAPR18MB279165911FEAC6402C75A754A0100@BYAPR18MB2791.namprd18.prod.outlook.com>
References: <20201028145015.19212-1-schalla@marvell.com>
 <20201028145015.19212-3-schalla@marvell.com>
 <CA+FuTSeLG+WV_Et75trH1kF0ahFpqfe2SvMRfjKk+OYycWktVw@mail.gmail.com>
In-Reply-To: <CA+FuTSeLG+WV_Et75trH1kF0ahFpqfe2SvMRfjKk+OYycWktVw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2409:4070:2086:77f5:9042:7a80:ca40:111a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ee1747b-5678-48b9-6a00-08d87f14decc
x-ms-traffictypediagnostic: BY5PR18MB3409:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB340957B818DF56BC79431497A0100@BY5PR18MB3409.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x+70X3JW23KJ/kIOoHj7Cr7mGoqTbFteRX+qobhLGU49vhPRwGjP//6Wbel1hGMukbWmu3oRBkJU8gPNGQVt4b8fnxvdcBQdI97crIqkugTlm6UYixLgyKvtp3c3jRPn4be6oeP84BSIn2ApUnoNBUeuKGR0936edP7QEdyXOsm5yu0nutrDwzBiBhewGC3yG81p6h8jBKRfoO1Yhfl4b4cm9DoDnTo3PNZ15fx1Suf9AofO49C/GUMX2SqtxAGIz8KXdJQZC5ydFlZYieKCiGPl/+qlSMhEdcUERHT8g2v2Vn4bmPsawLRq+ZFe4ypoT7ztUiv2JfMbGqN58P0g7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2791.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39850400004)(376002)(366004)(107886003)(71200400001)(86362001)(6916009)(53546011)(2906002)(4326008)(6506007)(186003)(8936002)(33656002)(8676002)(9686003)(7696005)(64756008)(83380400001)(52536014)(66446008)(54906003)(316002)(5660300002)(478600001)(15650500001)(76116006)(55016002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: nzXoHQKlQj33H9TRUo6O9Sp+gJXtWqft1Ku5Er6sra7b79lIud1j7nTsO5tGZfd6QQerKUibixRodVDa2uDQvGzYyp+8Zk1ye8rs54DXp8yo7mZjMBP1y/ej84Zt7o8xrWAV9SmmRNhNjqdttJwdPTIf4at1ZF84wOkhCx43J0J/ALd26W5W5eUvJN/u0kbMgw6NQYWEJ/qvHE/5clN6s2pIKIKVWPcXbJYDppI/MX40mC2Kdr8B7voOB8Fv+0cqN7od8BPvaeFev17L5hU+DyudviWEEnKEO073BpXTBjxA3K6QDCsb5iw5rOMBWEkByLZ0fPEnxsbcPceaaQhhZ0XF2piI/2lUxEBWHuuC1KOCSmiSnif4TwOPI+Kt+VN+R6XigOIfHwfVColH7TeoWWGAkLOJ0G8shJVSFt2dNmgJTgZLy+KkqK+Gi5ddpxtildayceahXhS8btftxehzNbsnRek43BN5bz0yx3CiZ7BGaPkV1eK9f6ohlDcOjpUM/5kYKveuhbrjQqU3us1tvOOoYpRpMfW2T+PmIBlbL+tLi2U2eBv5WsmWBs7PQYmWzJyxfqtI0/hDDvskkAw39i4b2pQQyaNs4dbc7muRTAtqh5y34E5jT5/GMjIPa9YD0pU7hLfpLka2uPcfSmOfpfDQLoPGDQA+iH0MKnZ6CBpgfC9tZwiLdJO98sq/ii+mqMCPr0T/JkTlTmWFEHpHwQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2791.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee1747b-5678-48b9-6a00-08d87f14decc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 09:51:28.6377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KAiFzdUbWw9dGWDvEEGRlvr/gjYfkjH8GU5h7QLEUuOrGJv0zMFPDr5mBtBLbtgt5Cu7hB2+866VaDMOD6w6FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3409
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_03:2020-10-30,2020-11-02 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBXZWQsIE9jdCAyOCwgMjAyMCBhdCAxMDo0NCBQTSBTcnVqYW5hIENoYWxsYSA8c2NoYWxs
YUBtYXJ2ZWxsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBPbiBPY3Rlb25UWDIgU29DLCB0aGUgYWRt
aW4gZnVuY3Rpb24gKEFGKSBpcyB0aGUgb25seSBvbmUgd2l0aCBhbGwNCj4gPiBwcml2aWxpZ2Vz
IHRvIGNvbmZpZ3VyZSBIVyBhbmQgYWxsb2MgcmVzb3VyY2VzLCBQRnMgYW5kIGl0J3MgVkZzDQo+
ID4gaGF2ZSB0byByZXF1ZXN0IEFGIHZpYSBtYWlsYm94IGZvciBhbGwgdGhlaXIgbmVlZHMuIFRo
aXMgcGF0Y2ggYWRkcw0KPiA+IGEgbWFpbGJveCBpbnRlcmZhY2UgZm9yIENQVCBQRnMgYW5kIFZG
cyB0byBhbGxvY2F0ZSByZXNvdXJjZXMNCj4gPiBmb3IgY3J5cHRvZ3JhcGh5Lg0KPiA+DQo+ID4g
U2lnbmVkLW9mZi1ieTogU3VoZWlsIENoYW5kcmFuIDxzY2hhbmRyYW5AbWFydmVsbC5jb20+DQo+
ID4gU2lnbmVkLW9mZi1ieTogU3J1amFuYSBDaGFsbGEgPHNjaGFsbGFAbWFydmVsbC5jb20+DQo+
ID4gLS0tDQo+ID4gIC4uLi9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9NYWtlZmlsZSAg
ICB8ICAgMyArLQ0KPiA+ICAuLi4vbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL2FmL21i
b3guaCAgfCAgMzMgKysrDQo+ID4gIC4uLi9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIv
YWYvcnZ1LmMgICB8ICAgMiArLQ0KPiA+ICAuLi4vbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9u
dHgyL2FmL3J2dS5oICAgfCAgIDEgKw0KPiA+ICAuLi4vZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250
eDIvYWYvcnZ1X2NwdC5jICAgfCAyMjkgKysrKysrKysrKysrKysrKysrDQo+ID4gIC4uLi9ldGhl
cm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9ydnVfcmVnLmggICB8ICA2MyArKysrLQ0KPiA+ICA2
IGZpbGVzIGNoYW5nZWQsIDMyMyBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPiA+ICBj
cmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIv
YWYvcnZ1X2NwdC5jDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
YXJ2ZWxsL29jdGVvbnR4Mi9hZi9ydnVfcmVnLmgNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
YXJ2ZWxsL29jdGVvbnR4Mi9hZi9ydnVfcmVnLmgNCj4gPiBpbmRleCA3Y2E1OTliOTczYzAuLjgw
N2IxYzFhOWQ4NSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxs
L29jdGVvbnR4Mi9hZi9ydnVfcmVnLmgNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
YXJ2ZWxsL29jdGVvbnR4Mi9hZi9ydnVfcmVnLmgNCj4gPiBAQCAtNDI5LDEyICs0MjksNjMgQEAN
Cj4gPiAgI2RlZmluZSBUSU1fQUZfTEZfUlNUICAgICAgICAgICAgICAgICAgKDB4MjApDQo+ID4N
Cj4gPiAgLyogQ1BUICovDQo+ID4gLSNkZWZpbmUgQ1BUX0FGX0NPTlNUQU5UUzAgICAgICAgICAg
ICAgICgweDAwMDApDQo+ID4gLSNkZWZpbmUgQ1BUX1BSSVZfTEZYX0NGRyAgICAgICAgICAgICAg
ICgweDQxMDAwKQ0KPiA+IC0jZGVmaW5lIENQVF9QUklWX0xGWF9JTlRfQ0ZHICAgICAgICAgICAo
MHg0MzAwMCkNCj4gPiAtI2RlZmluZSBDUFRfQUZfUlZVX0xGX0NGR19ERUJVRyAgICAgICAgICAg
ICAgICAoMHg0NTAwMCkNCj4gPiAtI2RlZmluZSBDUFRfQUZfTEZfUlNUICAgICAgICAgICAgICAg
ICAgKDB4NDQwMDApDQo+ID4gLSNkZWZpbmUgQ1BUX0FGX0JMS19SU1QgICAgICAgICAgICAgICAg
ICgweDQ2MDAwKQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9DT05TVEFOVFMwICAgICAgICAgICAgICAg
KDB4MDAwMCkNCj4gPiArI2RlZmluZSBDUFRfQUZfQ09OU1RBTlRTMSAgICAgICAgICAgICAgICgw
eDEwMDApDQo+ID4gKyNkZWZpbmUgQ1BUX0FGX0RJQUcgICAgICAgICAgICAgICAgICAgICAoMHgz
MDAwKQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9FQ08gICAgICAgICAgICAgICAgICAgICAgKDB4NDAw
MCkNCj4gPiArI2RlZmluZSBDUFRfQUZfRkxUWF9JTlQoYSkgICAgICAgICAgICAgICgweGEwMDB1
bGwgfCAodTY0KShhKSA8PCAzKQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9GTFRYX0lOVF9XMVMoYSkg
ICAgICAgICAgKDB4YjAwMHVsbCB8ICh1NjQpKGEpIDw8IDMpDQo+ID4gKyNkZWZpbmUgQ1BUX0FG
X0ZMVFhfSU5UX0VOQV9XMUMoYSkgICAgICAoMHhjMDAwdWxsIHwgKHU2NCkoYSkgPDwgMykNCj4g
PiArI2RlZmluZSBDUFRfQUZfRkxUWF9JTlRfRU5BX1cxUyhhKSAgICAgICgweGQwMDB1bGwgfCAo
dTY0KShhKSA8PCAzKQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9QU05YX0VYRShhKSAgICAgICAgICAg
ICAgKDB4ZTAwMHVsbCB8ICh1NjQpKGEpIDw8IDMpDQo+ID4gKyNkZWZpbmUgQ1BUX0FGX1BTTlhf
RVhFX1cxUyhhKSAgICAgICAgICAoMHhmMDAwdWxsIHwgKHU2NCkoYSkgPDwgMykNCj4gPiArI2Rl
ZmluZSBDUFRfQUZfUFNOWF9MRihhKSAgICAgICAgICAgICAgICgweDEwMDAwdWxsIHwgKHU2NCko
YSkgPDwgMykNCj4gPiArI2RlZmluZSBDUFRfQUZfUFNOWF9MRl9XMVMoYSkgICAgICAgICAgICgw
eDExMDAwdWxsIHwgKHU2NCkoYSkgPDwgMykNCj4gPiArI2RlZmluZSBDUFRfQUZfRVhFWF9DVEwy
KGEpICAgICAgICAgICAgICgweDEyMDAwdWxsIHwgKHU2NCkoYSkgPDwgMykNCj4gPiArI2RlZmlu
ZSBDUFRfQUZfRVhFWF9TVFMoYSkgICAgICAgICAgICAgICgweDEzMDAwdWxsIHwgKHU2NCkoYSkg
PDwgMykNCj4gPiArI2RlZmluZSBDUFRfQUZfRVhFX0VSUl9JTkZPICAgICAgICAgICAgICgweDE0
MDAwKQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9FWEVYX0FDVElWRShhKSAgICAgICAgICAgKDB4MTYw
MDB1bGwgfCAodTY0KShhKSA8PCAzKQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9JTlNUX1JFUV9QQyAg
ICAgICAgICAgICAgKDB4MTcwMDApDQo+ID4gKyNkZWZpbmUgQ1BUX0FGX0lOU1RfTEFURU5DWV9Q
QyAgICAgICAgICAoMHgxODAwMCkNCj4gPiArI2RlZmluZSBDUFRfQUZfUkRfUkVRX1BDICAgICAg
ICAgICAgICAgICgweDE5MDAwKQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9SRF9MQVRFTkNZX1BDICAg
ICAgICAgICAgKDB4MWEwMDApDQo+ID4gKyNkZWZpbmUgQ1BUX0FGX1JEX1VDX1BDICAgICAgICAg
ICAgICAgICAoMHgxYjAwMCkNCj4gPiArI2RlZmluZSBDUFRfQUZfQUNUSVZFX0NZQ0xFU19QQyAg
ICAgICAgICgweDFjMDAwKQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9FWEVfREJHX0NUTCAgICAgICAg
ICAgICAgKDB4MWQwMDApDQo+ID4gKyNkZWZpbmUgQ1BUX0FGX0VYRV9EQkdfREFUQSAgICAgICAg
ICAgICAoMHgxZTAwMCkNCj4gPiArI2RlZmluZSBDUFRfQUZfRVhFX1JFUV9USU1FUiAgICAgICAg
ICAgICgweDFmMDAwKQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9FWEVYX0NUTChhKSAgICAgICAgICAg
ICAgKDB4MjAwMDB1bGwgfCAodTY0KShhKSA8PCAzKQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9FWEVf
UEVSRl9DVEwgICAgICAgICAgICAgKDB4MjEwMDApDQo+ID4gKyNkZWZpbmUgQ1BUX0FGX0VYRV9E
QkdfQ05UWChhKSAgICAgICAgICAoMHgyMjAwMHVsbCB8ICh1NjQpKGEpIDw8IDMpDQo+ID4gKyNk
ZWZpbmUgQ1BUX0FGX0VYRV9QRVJGX0VWRU5UX0NOVCAgICAgICAoMHgyMzAwMCkNCj4gPiArI2Rl
ZmluZSBDUFRfQUZfRVhFX0VQQ0lfSU5CWF9DTlQoYSkgICAgICgweDI0MDAwdWxsIHwgKHU2NCko
YSkgPDwgMykNCj4gPiArI2RlZmluZSBDUFRfQUZfRVhFX0VQQ0lfT1VUQlhfQ05UKGEpICAgICgw
eDI1MDAwdWxsIHwgKHU2NCkoYSkgPDwgMykNCj4gPiArI2RlZmluZSBDUFRfQUZfRVhFWF9VQ09E
RV9CQVNFKGEpICAgICAgICgweDI2MDAwdWxsIHwgKHU2NCkoYSkgPDwgMykNCj4gPiArI2RlZmlu
ZSBDUFRfQUZfTEZYX0NUTChhKSAgICAgICAgICAgICAgICgweDI3MDAwdWxsIHwgKHU2NCkoYSkg
PDwgMykNCj4gPiArI2RlZmluZSBDUFRfQUZfTEZYX0NUTDIoYSkgICAgICAgICAgICAgICgweDI5
MDAwdWxsIHwgKHU2NCkoYSkgPDwgMykNCj4gPiArI2RlZmluZSBDUFRfQUZfQ1BUQ0xLX0NOVCAg
ICAgICAgICAgICAgICgweDJhMDAwKQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9QRl9GVU5DICAgICAg
ICAgICAgICAgICAgKDB4MmIwMDApDQo+ID4gKyNkZWZpbmUgQ1BUX0FGX0xGWF9QVFJfQ1RMKGEp
ICAgICAgICAgICAoMHgyYzAwMHVsbCB8ICh1NjQpKGEpIDw8IDMpDQo+ID4gKyNkZWZpbmUgQ1BU
X0FGX0dSUFhfVEhSKGEpICAgICAgICAgICAgICAoMHgyZDAwMHVsbCB8ICh1NjQpKGEpIDw8IDMp
DQo+ID4gKyNkZWZpbmUgQ1BUX0FGX0NUTCAgICAgICAgICAgICAgICAgICAgICAoMHgyZTAwMHVs
bCkNCj4gPiArI2RlZmluZSBDUFRfQUZfWEVYX1RIUihhKSAgICAgICAgICAgICAgICgweDJmMDAw
dWxsIHwgKHU2NCkoYSkgPDwgMykNCj4gPiArI2RlZmluZSBDUFRfUFJJVl9MRlhfQ0ZHICAgICAg
ICAgICAgICAgICgweDQxMDAwKQ0KPiA+ICsjZGVmaW5lIENQVF9QUklWX0FGX0lOVF9DRkcgICAg
ICAgICAgICAgKDB4NDIwMDApDQo+ID4gKyNkZWZpbmUgQ1BUX1BSSVZfTEZYX0lOVF9DRkcgICAg
ICAgICAgICAoMHg0MzAwMCkNCj4gPiArI2RlZmluZSBDUFRfQUZfTEZfUlNUICAgICAgICAgICAg
ICAgICAgICgweDQ0MDAwKQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9SVlVfTEZfQ0ZHX0RFQlVHICAg
ICAgICAgKDB4NDUwMDApDQo+ID4gKyNkZWZpbmUgQ1BUX0FGX0JMS19SU1QgICAgICAgICAgICAg
ICAgICAoMHg0NjAwMCkNCj4gPiArI2RlZmluZSBDUFRfQUZfUlZVX0lOVCAgICAgICAgICAgICAg
ICAgICgweDQ3MDAwKQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9SVlVfSU5UX1cxUyAgICAgICAgICAg
ICAgKDB4NDcwMDgpDQo+ID4gKyNkZWZpbmUgQ1BUX0FGX1JWVV9JTlRfRU5BX1cxUyAgICAgICAg
ICAoMHg0NzAxMCkNCj4gPiArI2RlZmluZSBDUFRfQUZfUlZVX0lOVF9FTkFfVzFDICAgICAgICAg
ICgweDQ3MDE4KQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9SQVNfSU5UICAgICAgICAgICAgICAgICAg
KDB4NDcwMjApDQo+ID4gKyNkZWZpbmUgQ1BUX0FGX1JBU19JTlRfVzFTICAgICAgICAgICAgICAo
MHg0NzAyOCkNCj4gPiArI2RlZmluZSBDUFRfQUZfUkFTX0lOVF9FTkFfVzFTICAgICAgICAgICgw
eDQ3MDMwKQ0KPiA+ICsjZGVmaW5lIENQVF9BRl9SQVNfSU5UX0VOQV9XMUMgICAgICAgICAgKDB4
NDcwMzgpDQo+ID4gKw0KPiA+ICsjZGVmaW5lIENQVF9BRl9MRl9DVEwyX1NISUZUIDMNCj4gPiAr
I2RlZmluZSBDUFRfQUZfTEZfU1NPX1BGX0ZVTkNfU0hJRlQgMzINCj4gPg0KPiA+ICAjZGVmaW5l
IE5QQ19BRl9CTEtfUlNUICAgICAgICAgICAgICAgICAgKDB4MDAwNDApDQo+IA0KPiBNb3N0IG9m
IHRoZXNlIGFyZSBub3QgcmVsYXRlZCB0byB0aGlzIHBhdGNoLiBVc2VkIG9ubHkgaW4gdGhlDQo+
IGZvbGxvdy1vbiBkZWJ1ZyBpbnRlcmZhY2Ugb25lPw0KDQpBZGRlZCBhbGwgaGFyZHdhcmUgQ1BU
IEFGIHJlZ2lzdGVyIGRlZmluZXMgaGVyZS4gSSB3aWxsIGFkZCB0aGlzDQpwb2ludCB0byB0aGUg
cGF0Y2ggZGVzY3JpcHRpb24gaW4gbmV4dCB2ZXJzaW9uLg0KVGhhbmtzLg0K
