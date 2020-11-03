Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901712A3B41
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 04:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgKCD66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 22:58:58 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47356 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725940AbgKCD66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 22:58:58 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A33tE9P006577;
        Mon, 2 Nov 2020 19:58:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=xgWeFE/E/xfJmf8NCO5IxhPds4niQnk+p0Yb+jFz9Lc=;
 b=Pu85BKrCojN+2kKq/eRgYjYX8pda0yjjosHXEo+X6YkkUCx1U+N5aM513xTkUvdP8gS2
 R2cFn9FFaRMQKFNPKAwMILim94XvJt2dm1re1lS5mFXf9F1/vpRZXOgsnMEXYoLAuff6
 MdaHzeK2XbO12qnsuX+BE2grKZDTRdRTtn+tIRwODRDhJZDyq2HqS6VmvmCFQ8Vb+nFf
 5XQzBNwhkoiJTV3eYh6ucIgNGlhNAQp+H0mQMq7ANYVzTQ5xf0/HslbhUIAdLVz45GB0
 IWtbmLlo4qPuhImZqf14yKTnNLr1CPgMKxL2sjCmXjtBb9nRiFhOBRAEk+8bg5ONfAYr EA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34h59mur13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 19:58:55 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 2 Nov
 2020 19:58:54 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 2 Nov 2020 19:58:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPWAGu2dxvkO/Juh9nSHECQUX01Wl1flNE4+PVq18Q9J6+XWohjGnokx14AqPma3z6A6N/+nGkDaFmSIXq3x+CowFKvjFyLtw6bU377Ov/uzlhuN1/AMrMTQwLFpMeliHm/VGZGFlcBs3LmJqBEC74lAdMb82tsl43uVFF/XfPdM4dY+mw+JJpDIf6zxX05o2KMgcns/Hpf5g+WudPHkBCsGUjaIL+5hHZvwpvaqx5LlIO8OU66xBIVg0N4q9zs+ZWdZW7cWodk0Ck3b41SpJ5YFSUGUwHtuEpPcWQ8uCIp62fnylrAKbIMeRFMqGaRrk+xFiWvdupwYAvvBW3r9aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgWeFE/E/xfJmf8NCO5IxhPds4niQnk+p0Yb+jFz9Lc=;
 b=XkK+dkeBzSPhuClOLlAx/8yV/NtyDXyBzTNXL87PAPq/Ai9DEUi/g+p9CapIIDi1OccG0+RysB6TMhYyeP31utVc98kZm9cTKUL4QMjjN/1ChJIxJ1gAViAmWQiR0WcSB4Xqd5n135Yze907u3dN90h6I4KbsPlUEbYnhyw0C3fLMP81wJ/uO36dMQPl9+wVy0sU2qqFKHazauGsMKzjfZ5l0BV8EzuPzRdQ6PhdFL9lMjD7GzxNIuCZk3YrW0WvQvkwwwzy7UgggspRZl6i+6/JKxErjUDXTbdLzOHKS+MdHgqfOKqfMWxfVYcpOGQT44/EuitvMuqT5q5AvItfLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgWeFE/E/xfJmf8NCO5IxhPds4niQnk+p0Yb+jFz9Lc=;
 b=cZlfhwvOVV0w9k5y16NyXZCr8Lz/FQKRD3gtGfWZcl5NueS7m2Uz1M6+QBrbTVDkEXCy0IALZFEA/nyRZH1+oio9V/b813vkEsEgSZxULwnPqdHqBoua1fJM1AHPLpO6GJz40/0swTdvt3GjnwpGcuOvRhbbADuGgXqtVT5fg7Y=
Received: from BYAPR18MB2679.namprd18.prod.outlook.com (2603:10b6:a03:13c::10)
 by SJ0PR18MB3835.namprd18.prod.outlook.com (2603:10b6:a03:2ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 03:58:53 +0000
Received: from BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a]) by BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a%7]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 03:58:53 +0000
From:   George Cherian <gcherian@marvell.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David Miller" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>
Subject: Re: [net-next PATCH 2/3] octeontx2-af: Add devlink health reporters
 for NPA
Thread-Topic: [net-next PATCH 2/3] octeontx2-af: Add devlink health reporters
 for NPA
Thread-Index: Adaxku1NGFOPgspUTDWHH9cDtRxHTA==
Date:   Tue, 3 Nov 2020 03:58:53 +0000
Message-ID: <BYAPR18MB26799492A423DDB096B05F45C5110@BYAPR18MB2679.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [111.92.87.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: baf85be4-c7b8-4c8b-8ea7-08d87facc7c5
x-ms-traffictypediagnostic: SJ0PR18MB3835:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB38352AD95D68D5DAE7A77CF6C5110@SJ0PR18MB3835.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DvMMmAZkwBKObPixqWlWCoh3mkQ4eb92+RaT98c8lO88lC/i+25j1Cx2vouRqKq3Xuusk3p+r3AIhJEI+GfgKByweWbW7FcYO8D6DuT4eWC8HYbStHX6PeNcIb7S7TkNvcGFQmRXKoyBBhMxWhwp7Jurj9BDBISgib+f/mKxz9JrrGQbcmJMTs6ztLDQH/iHVNm6Wr5wyCGQ0LolVY4RbFK1X7f/Uwg9JgiINXGiTEYa3c0GUqRf5jl7fPvKUjsqQBq/LDILPh1SGX97H70A+DT0XokwH6dE72PYvWUG4+ctur63WbJiI51PGXkRVchyTzF6A4RmHm1lz6WQAJKWkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2679.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(54906003)(76116006)(8936002)(66946007)(86362001)(33656002)(4326008)(8676002)(316002)(52536014)(71200400001)(478600001)(83380400001)(53546011)(186003)(26005)(6506007)(55016002)(5660300002)(66476007)(66556008)(66446008)(64756008)(9686003)(2906002)(7696005)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1qkIba7pBrTqR+el2wpP1rPZbR4GvIGEVv/qwX5I1g8D3ClRfmLHPKbM9yvEaIM+KvggmHUon+6WbLZBbNnW2wMitHAliqcVu/qCsspWeiiUYRInavbYcIUA+cJCOjCRTz2B+vyW1s4Tf1AxyxBtlCe5z7MsScBWBXMH8BozXACQFwxmxbleLM4B/4sBme35618gSbw43wljba1FkdjLQgoiuesfl39wvV2v1OTIwOcaG7WPFiwNnIbSvCFN2EAJ/C4GtWR1v7tbW3XGR7tuUM7Pn249iltN1STnK1VcILz7/FM+VOY3mgxgL/91Dg3ZHRf3sxK3sh8sXbR5cA5LioxlvAcb3D6+MDaKsi+KjdHbccu0B6nqqdvUFYSiSKK9D8a/nPn6NaaAkitpPECUUeKXPfs2UNljrBqT/Bjd0UdekP+nGvlpvRjOnSH8Js6wxtC/xcIjHQJwbdQObA8QrzlXt1rakr6EIRq4Vgthp8cEzA+EgTplJd9HcfgycNw3BIDhQpsI4Au6/R8XMgKhhS8f5yJh9nft2u07mT9BDk9HMWfS3B/a5YxEgGvo54fdHiwLWgwdb2TfRT4pr5u66vPclj67V/IaVZf7Je2O40GGb8OwQz+PsRN+dcliC+cuW9h1U1KfI9Qce+1pC8JuJQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2679.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baf85be4-c7b8-4c8b-8ea7-08d87facc7c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 03:58:53.4601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JfSbgg7e33vHbxOlVJSsmOIzC5zj6vmC8wSG8FhvMW/iTiF+GdiaxOjdYKVk3crQ8hCUjLDvW0blFcYZghPm1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB3835
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_02:2020-11-02,2020-11-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgV2lsbGVtLA0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQoNCj4gLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCj4gRnJvbTogV2lsbGVtIGRlIEJydWlqbiA8d2lsbGVtZGVicnVpam4ua2Vy
bmVsQGdtYWlsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBOb3ZlbWJlciAyLCAyMDIwIDc6MTIgUE0N
Cj4gVG86IEdlb3JnZSBDaGVyaWFuIDxnY2hlcmlhbkBtYXJ2ZWxsLmNvbT4NCj4gQ2M6IE5ldHdv
cmsgRGV2ZWxvcG1lbnQgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBsaW51eC1rZXJuZWwgPGxp
bnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2Vy
bmVsLm9yZz47IERhdmlkIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IFN1bmlsIEtv
dnZ1cmkgR291dGhhbQ0KPiA8c2dvdXRoYW1AbWFydmVsbC5jb20+OyBMaW51IENoZXJpYW4gPGxj
aGVyaWFuQG1hcnZlbGwuY29tPjsNCj4gR2VldGhhc293amFueWEgQWt1bGEgPGdha3VsYUBtYXJ2
ZWxsLmNvbT47IG1hc2FoaXJveUBrZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbbmV0LW5leHQg
UEFUQ0ggMi8zXSBvY3Rlb250eDItYWY6IEFkZCBkZXZsaW5rIGhlYWx0aA0KPiByZXBvcnRlcnMg
Zm9yIE5QQQ0KPiANCj4gT24gTW9uLCBOb3YgMiwgMjAyMCBhdCAxMjowNyBBTSBHZW9yZ2UgQ2hl
cmlhbg0KPiA8Z2VvcmdlLmNoZXJpYW5AbWFydmVsbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gQWRk
IGhlYWx0aCByZXBvcnRlcnMgZm9yIFJWVSBOUEEgYmxvY2suDQo+ID4gT25seSByZXBvcnRlciBk
dW1wIGlzIHN1cHBvcnRlZA0KPiA+DQo+ID4gT3V0cHV0Og0KPiA+ICAjIGRldmxpbmsgaGVhbHRo
DQo+ID4gIHBjaS8wMDAyOjAxOjAwLjA6DQo+ID4gICAgcmVwb3J0ZXIgbnBhDQo+ID4gICAgICBz
dGF0ZSBoZWFsdGh5IGVycm9yIDAgcmVjb3ZlciAwDQo+ID4gICMgZGV2bGluayAgaGVhbHRoIGR1
bXAgc2hvdyBwY2kvMDAwMjowMTowMC4wIHJlcG9ydGVyIG5wYQ0KPiA+ICBOUEFfQUZfR0VORVJB
TDoNCj4gPiAgICAgICAgIFVubWFwIFBGIEVycm9yOiAwDQo+ID4gICAgICAgICBGcmVlIERpc2Fi
bGVkIGZvciBOSVgwIFJYOiAwDQo+ID4gICAgICAgICBGcmVlIERpc2FibGVkIGZvciBOSVgwIFRY
OiAwDQo+ID4gICAgICAgICBGcmVlIERpc2FibGVkIGZvciBOSVgxIFJYOiAwDQo+ID4gICAgICAg
ICBGcmVlIERpc2FibGVkIGZvciBOSVgxIFRYOiAwDQo+ID4gICAgICAgICBGcmVlIERpc2FibGVk
IGZvciBTU086IDANCj4gPiAgICAgICAgIEZyZWUgRGlzYWJsZWQgZm9yIFRJTTogMA0KPiA+ICAg
ICAgICAgRnJlZSBEaXNhYmxlZCBmb3IgRFBJOiAwDQo+ID4gICAgICAgICBGcmVlIERpc2FibGVk
IGZvciBBVVJBOiAwDQo+ID4gICAgICAgICBBbGxvYyBEaXNhYmxlZCBmb3IgUmVzdmQ6IDANCj4g
PiAgIE5QQV9BRl9FUlI6DQo+ID4gICAgICAgICBNZW1vcnkgRmF1bHQgb24gTlBBX0FRX0lOU1Rf
UyByZWFkOiAwDQo+ID4gICAgICAgICBNZW1vcnkgRmF1bHQgb24gTlBBX0FRX1JFU19TIHdyaXRl
OiAwDQo+ID4gICAgICAgICBBUSBEb29yYmVsbCBFcnJvcjogMA0KPiA+ICAgICAgICAgUG9pc29u
ZWQgZGF0YSBvbiBOUEFfQVFfSU5TVF9TIHJlYWQ6IDANCj4gPiAgICAgICAgIFBvaXNvbmVkIGRh
dGEgb24gTlBBX0FRX1JFU19TIHdyaXRlOiAwDQo+ID4gICAgICAgICBQb2lzb25lZCBkYXRhIG9u
IEhXIGNvbnRleHQgcmVhZDogMA0KPiA+ICAgTlBBX0FGX1JWVToNCj4gPiAgICAgICAgIFVubWFw
IFNsb3QgRXJyb3I6IDANCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFN1bmlsIEtvdnZ1cmkgR291
dGhhbSA8c2dvdXRoYW1AbWFydmVsbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogSmVyaW4gSmFj
b2IgPGplcmluakBtYXJ2ZWxsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBHZW9yZ2UgQ2hlcmlh
biA8Z2VvcmdlLmNoZXJpYW5AbWFydmVsbC5jb20+DQo+IA0KPiANCj4gPiArc3RhdGljIGJvb2wg
cnZ1X25wYV9hZl9yZXF1ZXN0X2lycShzdHJ1Y3QgcnZ1ICpydnUsIGludCBibGthZGRyLCBpbnQg
b2Zmc2V0LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgY2hh
ciAqbmFtZSwgaXJxX2hhbmRsZXJfdCBmbikNCj4gPiArew0KPiA+ICsgICAgICAgc3RydWN0IHJ2
dV9kZXZsaW5rICpydnVfZGwgPSBydnUtPnJ2dV9kbDsNCj4gPiArICAgICAgIGludCByYzsNCj4g
PiArDQo+ID4gKyAgICAgICBXQVJOX09OKHJ2dS0+aXJxX2FsbG9jYXRlZFtvZmZzZXRdKTsNCj4g
DQo+IFBsZWFzZSB1c2UgV0FSTl9PTiBzcGFyaW5nbHkgZm9yIGltcG9ydGFudCB1bnJlY292ZXJh
YmxlIGV2ZW50cy4gVGhpcw0KPiBzZWVtcyBsaWtlIGEgYmFzaWMgcHJlY29uZGl0aW9uLiBJZiBp
dCBjYW4gaGFwcGVuIGF0IGFsbCwgY2FuIHByb2JhYmx5IGNhdGNoIGluIGENCj4gbm9ybWFsIGJy
YW5jaCB3aXRoIGEgbmV0ZGV2X2Vyci4gVGhlIHN0YWNrdHJhY2UgaW4gdGhlIG9vcHMgaXMgbm90
IGxpa2VseSB0bw0KPiBwb2ludCBhdCB0aGUgc291cmNlIG9mIHRoZSBub24temVybyB2YWx1ZSwg
YW55d2F5Lg0KT2theSwgd2lsbCBmaXggaXQgaW4gdjIuDQo+IA0KPiA+ICsgICAgICAgcnZ1LT5p
cnFfYWxsb2NhdGVkW29mZnNldF0gPSBmYWxzZTsNCj4gDQo+IFdoeSBpbml0aWFsaXplIHRoaXMg
aGVyZT8gQXJlIHRoZXNlIGZpZWxkcyBub3QgemVyb2VkIG9uIGFsbG9jPyBJcyB0aGlzIGhlcmUg
b25seQ0KPiB0byBzYWZlbHkgY2FsbCBydnVfbnBhX3VucmVnaXN0ZXJfaW50ZXJydXB0cyBvbiBw
YXJ0aWFsIGFsbG9jPyBUaGVuIGl0IG1pZ2h0IGJlDQo+IHNpbXBsZXIgdG8ganVzdCBoYXZlIGp1
bXAgbGFiZWxzIGluIHRoaXMgZnVuY3Rpb24gdG8gZnJlZSB0aGUgc3VjY2Vzc2Z1bGx5DQo+IHJl
cXVlc3RlZCBpcnFzLg0KDQpJdCBzaG91bGRuJ3QgYmUgaW5pdGlhbGl6ZWQgbGlrZSB0aGlzOyBp
dCBpcyB6ZXJvZWQgb24gYWxsb2MuDQpXaWxsIGZpeCBpbiB2Mi4NCj4gDQo+ID4gKyAgICAgICBz
cHJpbnRmKCZydnUtPmlycV9uYW1lW29mZnNldCAqIE5BTUVfU0laRV0sIG5hbWUpOw0KPiA+ICsg
ICAgICAgcmMgPSByZXF1ZXN0X2lycShwY2lfaXJxX3ZlY3RvcihydnUtPnBkZXYsIG9mZnNldCks
IGZuLCAwLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAmcnZ1LT5pcnFfbmFtZVtvZmZz
ZXQgKiBOQU1FX1NJWkVdLCBydnVfZGwpOw0KPiA+ICsgICAgICAgaWYgKHJjKQ0KPiA+ICsgICAg
ICAgICAgICAgICBkZXZfd2FybihydnUtPmRldiwgIkZhaWxlZCB0byByZWdpc3RlciAlcyBpcnFc
biIsIG5hbWUpOw0KPiA+ICsgICAgICAgZWxzZQ0KPiA+ICsgICAgICAgICAgICAgICBydnUtPmly
cV9hbGxvY2F0ZWRbb2Zmc2V0XSA9IHRydWU7DQo+ID4gKw0KPiA+ICsgICAgICAgcmV0dXJuIHJ2
dS0+aXJxX2FsbG9jYXRlZFtvZmZzZXRdOyB9DQo+IA0KPiA+ICtzdGF0aWMgaW50IHJ2dV9ucGFf
aGVhbHRoX3JlcG9ydGVyc19jcmVhdGUoc3RydWN0IHJ2dV9kZXZsaW5rDQo+ID4gKypydnVfZGwp
IHsNCj4gPiArICAgICAgIHN0cnVjdCBkZXZsaW5rX2hlYWx0aF9yZXBvcnRlciAqcnZ1X25wYV9o
ZWFsdGhfcmVwb3J0ZXI7DQo+ID4gKyAgICAgICBzdHJ1Y3QgcnZ1X25wYV9ldmVudF9jbnQgKm5w
YV9ldmVudF9jb3VudDsNCj4gPiArICAgICAgIHN0cnVjdCBydnUgKnJ2dSA9IHJ2dV9kbC0+cnZ1
Ow0KPiA+ICsNCj4gPiArICAgICAgIG5wYV9ldmVudF9jb3VudCA9IGt6YWxsb2Moc2l6ZW9mKCpu
cGFfZXZlbnRfY291bnQpLCBHRlBfS0VSTkVMKTsNCj4gPiArICAgICAgIGlmICghbnBhX2V2ZW50
X2NvdW50KQ0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gLUVOT01FTTsNCj4gPiArDQo+ID4g
KyAgICAgICBydnVfZGwtPm5wYV9ldmVudF9jbnQgPSBucGFfZXZlbnRfY291bnQ7DQo+ID4gKyAg
ICAgICBydnVfbnBhX2hlYWx0aF9yZXBvcnRlciA9IGRldmxpbmtfaGVhbHRoX3JlcG9ydGVyX2Ny
ZWF0ZShydnVfZGwtDQo+ID5kbCwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZydnVfbnBhX2h3X2ZhdWx0X3JlcG9y
dGVyX29wcywNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIDAsIHJ2dSk7DQo+ID4gKyAgICAgICBpZiAoSVNfRVJSKHJ2
dV9ucGFfaGVhbHRoX3JlcG9ydGVyKSkgew0KPiA+ICsgICAgICAgICAgICAgICBkZXZfd2Fybihy
dnUtPmRldiwgIkZhaWxlZCB0byBjcmVhdGUgbnBhIHJlcG9ydGVyLCBlcnIgPSVsZFxuIiwNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgUFRSX0VSUihydnVfbnBhX2hlYWx0aF9yZXBvcnRl
cikpOw0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gUFRSX0VSUihydnVfbnBhX2hlYWx0aF9y
ZXBvcnRlcik7DQo+ID4gKyAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgcnZ1X2RsLT5ydnVf
bnBhX2hlYWx0aF9yZXBvcnRlciA9IHJ2dV9ucGFfaGVhbHRoX3JlcG9ydGVyOw0KPiA+ICsgICAg
ICAgcmV0dXJuIDA7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyB2b2lkIHJ2dV9ucGFfaGVh
bHRoX3JlcG9ydGVyc19kZXN0cm95KHN0cnVjdCBydnVfZGV2bGluaw0KPiA+ICsqcnZ1X2RsKSB7
DQo+ID4gKyAgICAgICBpZiAoIXJ2dV9kbC0+cnZ1X25wYV9oZWFsdGhfcmVwb3J0ZXIpDQo+ID4g
KyAgICAgICAgICAgICAgIHJldHVybjsNCj4gPiArDQo+ID4gKw0KPiA+ICtkZXZsaW5rX2hlYWx0
aF9yZXBvcnRlcl9kZXN0cm95KHJ2dV9kbC0+cnZ1X25wYV9oZWFsdGhfcmVwb3J0ZXIpOw0KPiA+
ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IHJ2dV9oZWFsdGhfcmVwb3J0ZXJzX2NyZWF0ZShz
dHJ1Y3QgcnZ1ICpydnUpIHsNCj4gPiArICAgICAgIHN0cnVjdCBydnVfZGV2bGluayAqcnZ1X2Rs
Ow0KPiA+ICsNCj4gPiArICAgICAgIGlmICghcnZ1LT5ydnVfZGwpDQo+ID4gKyAgICAgICAgICAg
ICAgIHJldHVybiAtRUlOVkFMOw0KPiA+ICsNCj4gPiArICAgICAgIHJ2dV9kbCA9IHJ2dS0+cnZ1
X2RsOw0KPiA+ICsgICAgICAgcmV0dXJuIHJ2dV9ucGFfaGVhbHRoX3JlcG9ydGVyc19jcmVhdGUo
cnZ1X2RsKTsNCj4gDQo+IE5vIG5lZWQgZm9yIGxvY2FsIHZhciBydnVfZGwuIEhlcmUgYW5kIGJl
bG93Lg0KPiANCj4gV2l0aG91dCB0aGF0LCB0aGUgZW50aXJlIGhlbHBlciBpcyBwcm9iYWJseSBu
b3QgbmVlZGVkLg0KDQpUaGlzIGhlbHBlciBpcyBuZWVkZWQgYXMgd2UgYWRkIHN1cHBvcnQgZm9y
IG1vcmUgSFcgYmxvY2tzLg0KDQo+IA0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgdm9pZCBy
dnVfaGVhbHRoX3JlcG9ydGVyc19kZXN0cm95KHN0cnVjdCBydnUgKnJ2dSkgew0KPiA+ICsgICAg
ICAgc3RydWN0IHJ2dV9kZXZsaW5rICpydnVfZGw7DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKCFy
dnUtPnJ2dV9kbCkNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+ICsNCj4gPiArICAg
ICAgIHJ2dV9kbCA9IHJ2dS0+cnZ1X2RsOw0KPiA+ICsgICAgICAgcnZ1X25wYV9oZWFsdGhfcmVw
b3J0ZXJzX2Rlc3Ryb3kocnZ1X2RsKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgc3RhdGljIGludCBy
dnVfZGV2bGlua19pbmZvX2dldChzdHJ1Y3QgZGV2bGluayAqZGV2bGluaywgc3RydWN0DQo+IGRl
dmxpbmtfaW5mb19yZXEgKnJlcSwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjaykgIHsgQEANCj4gPiAtNTMsNyArNDgzLDgg
QEAgaW50IHJ2dV9yZWdpc3Rlcl9kbChzdHJ1Y3QgcnZ1ICpydnUpDQo+ID4gICAgICAgICBydnVf
ZGwtPmRsID0gZGw7DQo+ID4gICAgICAgICBydnVfZGwtPnJ2dSA9IHJ2dTsNCj4gPiAgICAgICAg
IHJ2dS0+cnZ1X2RsID0gcnZ1X2RsOw0KPiA+IC0gICAgICAgcmV0dXJuIDA7DQo+ID4gKw0KPiA+
ICsgICAgICAgcmV0dXJuIHJ2dV9oZWFsdGhfcmVwb3J0ZXJzX2NyZWF0ZShydnUpOw0KPiANCj4g
d2hlbiB3b3VsZCB0aGlzIGJlIGNhbGxlZCB3aXRoIHJ2dS0+cnZ1X2RsID09IE5VTEw/DQoNCkR1
cmluZyBpbml0aWFsaXphdGlvbi4NCg0KUmVnYXJkcywNCi1HZW9yZ2UNCg==
