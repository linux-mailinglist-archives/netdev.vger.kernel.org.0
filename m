Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800B6E3A5F
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 19:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394055AbfJXRtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 13:49:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1862 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392609AbfJXRtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 13:49:51 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9OHmi88018750;
        Thu, 24 Oct 2019 10:49:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=wywgU+kSR9ueF/AtREBHoBN9SJQhFeygVcKTUoNnW48=;
 b=ashK3zwv/Hk9PgJExFSHs5kByGNqTvzImUeASZxxq2DkTcFvplK4LOaugSDh3HcJLEGt
 gGt+/8CJcvM+hLd4XTP2KhCTdBUUzaNanXTFixm+A8SVBdS/D7cu3ccZ0/4NFxq/mXnr
 EYtQ5IRQXK8EIfklhTVNHh+HNNQTpRaEgaM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vtyd6vsmp-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 24 Oct 2019 10:49:30 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 24 Oct 2019 10:49:27 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 24 Oct 2019 10:49:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVF3iCUfz9p6flVZIdv01sj4QtgNByknhPEcxHVzbH1JIqNTVxve9HQbySi0RZrmh8wHA6ng4JPwNzDMRDNWMTycy4Gwu6atdmwV5eD6AwHx3JBgYY5D8DvLS1oW6BZuDQgkibWxEm5jiFh6XGQg7sUNak0T8zhIp282hWfpVGvl3SadaARTwvEACdZxwQxFc8D3MYl7DKEl7+0TVroQFC4/99IdUdIIsnz+zvZhwo5wovWABMRr/7P2LQZjzDSuWVrugFmmo10EmLUdLotC+FrJ4ExKB3AhVW8Dz0WmTg2ZpCha1F7uitBE5V9qpv13RUc61xIwtU9KAsXEvV8jUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wywgU+kSR9ueF/AtREBHoBN9SJQhFeygVcKTUoNnW48=;
 b=nqHMWUk4om+EoQ+S209hyeWsDit1hfJEvLTP1KtaFbnFjDaTo4SvOsmI9LbaIANZ56NMzr2UvzvF1ZoU0EG9yooVd32IU0/JKc4h6BSWPmi9Cy0jSc6WRPP6aiINLzZgsyeVhTDCIKOSmXgtb7zXhj+3buatgudDxv/xnFmnCZuoC769xvDwirUhwtR2kmSj2uc+OOn63EzdJxbhxXlG//S4+AUpg5jtj56ZTTTKsjetrBtCbMufaCV75A5X5xlANWuVLpLPbZ7H8OXZNXWxd3nAaF8X/m/XCasZ4Gyk4Dt0bomttwt8f9DyclRCtYiUl99lmgyt8WzWUjl2T5ZIdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wywgU+kSR9ueF/AtREBHoBN9SJQhFeygVcKTUoNnW48=;
 b=jmBh8JWKordjrxBfKI9MboPNiP7ZFycaOxNEnxJr/tC2vBxedLV41/ndVUbLYCDjPa2VFLXDBAurFmfRdGc3SE9T8hyWk2hi5sRMYtTHdmaDdHV33NadDvMUTC2Uwno3TdREpcz6chWNwW1UxFMLt4cB3sYhARPrA9FLAHFRVpA=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3030.namprd15.prod.outlook.com (20.178.238.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Thu, 24 Oct 2019 17:49:26 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2387.021; Thu, 24 Oct 2019
 17:49:26 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Prabhakar Kushwaha <prabhakar.pkin@gmail.com>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: Linux-5.4: bpf: test_core_reloc_arrays.o: Segmentation fault with
 llc -march=bpf
Thread-Topic: Linux-5.4: bpf: test_core_reloc_arrays.o: Segmentation fault
 with llc -march=bpf
Thread-Index: AQHVioSri4sk0mO0YEWOHQh6nT3c5adqEbOA
Date:   Thu, 24 Oct 2019 17:49:26 +0000
Message-ID: <5d2cf6b8-a634-62ea-0b80-1d499aa3c693@fb.com>
References: <8080a9a2-82f1-20b5-8d5d-778536f91780@gmail.com>
 <C47F20A9-D34A-43C9-AAB5-6F125C73FA16@linux.ibm.com>
In-Reply-To: <C47F20A9-D34A-43C9-AAB5-6F125C73FA16@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0029.namprd11.prod.outlook.com
 (2603:10b6:300:115::15) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:fbde]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7492dcc-add7-4fd0-3cfc-08d758aa82fb
x-ms-traffictypediagnostic: BYAPR15MB3030:
x-ms-exchange-purlcount: 3
x-microsoft-antispam-prvs: <BYAPR15MB30301BFC548CE825F9E24D4BD36A0@BYAPR15MB3030.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:277;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(366004)(39860400002)(376002)(346002)(53754006)(199004)(189003)(31696002)(66946007)(6116002)(66556008)(66476007)(110136005)(476003)(54906003)(11346002)(446003)(5660300002)(2616005)(14444005)(256004)(8676002)(6486002)(71190400001)(46003)(229853002)(81156014)(81166006)(7736002)(305945005)(316002)(71200400001)(6512007)(14454004)(186003)(76176011)(6506007)(99286004)(6306002)(53546011)(386003)(478600001)(8936002)(966005)(25786009)(36756003)(31686004)(6436002)(102836004)(66446008)(64756008)(486006)(2906002)(4326008)(6246003)(52116002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3030;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J1KauhaVyl9JTS327JKfhnFTKeFpKt3hRdtidD3gi3Nygzn8HJockj8esqLEN7W/RcFKkXm6/yQym0Acmk15HXpK58nrzDsBuc7tgBbfcuP8bHeKjTtxmvu+E+SL1hsxL9Z9JM+4tskaoIAt9Q3ddSyBnMs2zv3tknFry8R7XzjwDqOoSht5Sve+SJQTxfxKa8mP0CJLV50hQrv/BZWai0gUPMGuSxCNoK93ijZm9VQsEEHd8mmYSgI9NZsTdII+yrEXvNJ6KyY67oaWATNbBMrIXbEr9xaKX65b1BKV0alg4IKTc4L4scnAVXDVTRKNzSrApBlB9T3Mawhvce2MZXt0gGhO1vanxd1tMXo8e2kO2mDeqcW/QxTwkdb3LbHRaJuzEprK2beflNCA82x6EBsPSHTmqygxWywGDqqM4InYzhQCjgViK75Jq4hulIuXCdGqPNQgiHOJZ6wwDF38IA4cgU94Ovy5JZjAaHtpjxw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4FCD0868026AF7439A33200236D55B89@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c7492dcc-add7-4fd0-3cfc-08d758aa82fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 17:49:26.3611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u2jfMN0jdAWCKlTdlL/YKhCz5dd+pUcIp28R7pe6f8MmiOa5LzXp/f1xuTnDDnTW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3030
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-24_10:2019-10-23,2019-10-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910240166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzI0LzE5IDk6MDQgQU0sIElseWEgTGVvc2hrZXZpY2ggd3JvdGU6DQo+PiBBbSAy
My4xMC4yMDE5IHVtIDAzOjM1IHNjaHJpZWIgUHJhYmhha2FyIEt1c2h3YWhhIDxwcmFiaGFrYXIu
cGtpbkBnbWFpbC5jb20+Og0KPj4NCj4+DQo+PiBBZGRpbmcgb3RoZXIgbWFpbGluZyBsaXN0LCBm
b2xrcy4uLg0KPj4NCj4+IEhpIEFsbCwNCj4+DQo+PiBJIGFtIHRyeWluZyB0byBidWlsZCBrc2Vs
ZnRlc3Qgb24gTGludXgtNS40IG9uIHVidW50dSAxOC4wNC4gSSBpbnN0YWxsZWQNCj4+IExMVk0t
OS4wLjAgYW5kIENsYW5nLTkuMC4wIGZyb20gYmVsb3cgbGlua3MgYWZ0ZXIgZm9sbG93aW5nIHN0
ZXBzIGZyb20NCj4+IFsxXSBiZWNhdXNlIG9mIGRpc2N1c3Npb24gWzJdDQo+Pg0KPj4gaHR0cHM6
Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19yZWxlYXNlcy5s
bHZtLm9yZ185LjAuMF9sbHZtLTJEOS4wLjAuc3JjLnRhci54eiZkPUR3SUZBZyZjPTVWRDBSVHRO
bFRoM3ljZDQxYjNNVXcmcj1EQThlMUI1cjA3M3ZJcVJyRno3TVJBJm09c2U4cFY2T2xEQWVGMmc1
aUVBdlNCMnFoTEJKR1BhSEFEdjNOUVZORng2VSZzPUl6QnhOaEF2Y0lMZkFEX1hjU0I3dDBzNi1C
LXdGWTNUQm9WR0g2V2hSSzgmZT0NCj4+IGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50LmNv
bS92Mi91cmw/dT1odHRwcy0zQV9fcmVsZWFzZXMubGx2bS5vcmdfOS4wLjBfY2xhbmctMkR0b29s
cy0yRGV4dHJhLTJEOS4wLjAuc3JjLnRhci54eiZkPUR3SUZBZyZjPTVWRDBSVHRObFRoM3ljZDQx
YjNNVXcmcj1EQThlMUI1cjA3M3ZJcVJyRno3TVJBJm09c2U4cFY2T2xEQWVGMmc1aUVBdlNCMnFo
TEJKR1BhSEFEdjNOUVZORng2VSZzPUtrakNqV21fcTJpTWZGaDUwclRLdEZxUUVNYlJCVmhUOU9o
OEtNZmd3VzQmZT0NCj4+IGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50LmNvbS92Mi91cmw/
dT1odHRwcy0zQV9fcmVsZWFzZXMubGx2bS5vcmdfOS4wLjBfY2ZlLTJEOS4wLjAuc3JjLnRhci54
eiZkPUR3SUZBZyZjPTVWRDBSVHRObFRoM3ljZDQxYjNNVXcmcj1EQThlMUI1cjA3M3ZJcVJyRno3
TVJBJm09c2U4cFY2T2xEQWVGMmc1aUVBdlNCMnFoTEJKR1BhSEFEdjNOUVZORng2VSZzPVR2a045
c2I1clNCNUJOeEpQMjdVbUNzZk5Ic1JRZGFWZUFuQmExVGt5ak0mZT0NCj4+DQo+PiBOb3csIGkg
YW0gdHJ5aW5nIHdpdGggbGxjIC1tYXJjaD1icGYsIHdpdGggdGhpcyBzZWdtZW50YXRpb24gZmF1
bHQgaXMNCj4+IGNvbWluZyBhcyBiZWxvdzoNCj4+DQo+PiBnY2MgLWcgLVdhbGwgLU8yIC1JLi4v
Li4vLi4vaW5jbHVkZS91YXBpIC1JLi4vLi4vLi4vbGliDQo+PiAtSS4uLy4uLy4uL2xpYi9icGYg
LUkuLi8uLi8uLi8uLi9pbmNsdWRlL2dlbmVyYXRlZCAtREhBVkVfR0VOSERSDQo+PiAtSS4uLy4u
Ly4uL2luY2x1ZGUgLURicGZfcHJvZ19sb2FkPWJwZl9wcm9nX3Rlc3RfbG9hZA0KPj4gLURicGZf
bG9hZF9wcm9ncmFtPWJwZl90ZXN0X2xvYWRfcHJvZ3JhbSAgICB0ZXN0X2Zsb3dfZGlzc2VjdG9y
LmMNCj4+IC91c3Ivc3JjL3RvdmFyZHMvbGludXgvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBm
L3Rlc3Rfc3R1Yi5vDQo+PiAvdXNyL3NyYy90b3ZhcmRzL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzL2JwZi9saWJicGYuYSAtbGNhcCAtbGVsZg0KPj4gLWxydCAtbHB0aHJlYWQgLW8NCj4+
IC91c3Ivc3JjL3RvdmFyZHMvbGludXgvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3Rf
Zmxvd19kaXNzZWN0b3INCj4+IGdjYyAtZyAtV2FsbCAtTzIgLUkuLi8uLi8uLi9pbmNsdWRlL3Vh
cGkgLUkuLi8uLi8uLi9saWINCj4+IC1JLi4vLi4vLi4vbGliL2JwZiAtSS4uLy4uLy4uLy4uL2lu
Y2x1ZGUvZ2VuZXJhdGVkIC1ESEFWRV9HRU5IRFINCj4+IC1JLi4vLi4vLi4vaW5jbHVkZSAtRGJw
Zl9wcm9nX2xvYWQ9YnBmX3Byb2dfdGVzdF9sb2FkDQo+PiAtRGJwZl9sb2FkX3Byb2dyYW09YnBm
X3Rlc3RfbG9hZF9wcm9ncmFtDQo+PiB0ZXN0X3RjcF9jaGVja19zeW5jb29raWVfdXNlci5jDQo+
PiAvdXNyL3NyYy90b3ZhcmRzL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0
X3N0dWIubw0KPj4gL3Vzci9zcmMvdG92YXJkcy9saW51eC90b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9icGYvbGliYnBmLmEgLWxjYXAgLWxlbGYNCj4+IC1scnQgLWxwdGhyZWFkIC1vDQo+PiAvdXNy
L3NyYy90b3ZhcmRzL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X3RjcF9j
aGVja19zeW5jb29raWVfdXNlcg0KPj4gZ2NjIC1nIC1XYWxsIC1PMiAtSS4uLy4uLy4uL2luY2x1
ZGUvdWFwaSAtSS4uLy4uLy4uL2xpYg0KPj4gLUkuLi8uLi8uLi9saWIvYnBmIC1JLi4vLi4vLi4v
Li4vaW5jbHVkZS9nZW5lcmF0ZWQgLURIQVZFX0dFTkhEUg0KPj4gLUkuLi8uLi8uLi9pbmNsdWRl
IC1EYnBmX3Byb2dfbG9hZD1icGZfcHJvZ190ZXN0X2xvYWQNCj4+IC1EYnBmX2xvYWRfcHJvZ3Jh
bT1icGZfdGVzdF9sb2FkX3Byb2dyYW0gICAgdGVzdF9saXJjX21vZGUyX3VzZXIuYw0KPj4gL3Vz
ci9zcmMvdG92YXJkcy9saW51eC90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9zdHVi
Lm8NCj4+IC91c3Ivc3JjL3RvdmFyZHMvbGludXgvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBm
L2xpYmJwZi5hIC1sY2FwIC1sZWxmDQo+PiAtbHJ0IC1scHRocmVhZCAtbw0KPj4gL3Vzci9zcmMv
dG92YXJkcy9saW51eC90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9saXJjX21vZGUy
X3VzZXINCj4+IChjbGFuZyAtSS4gLUkuL2luY2x1ZGUvdWFwaSAtSS4uLy4uLy4uL2luY2x1ZGUv
dWFwaQ0KPj4gLUkvdXNyL3NyYy90b3ZhcmRzL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2JwZi8uLi91c3IvaW5jbHVkZQ0KPj4gLURfX1RBUkdFVF9BUkNIX2FybTY0IC1nIC1pZGlyYWZ0
ZXIgL3Vzci9sb2NhbC9pbmNsdWRlIC1pZGlyYWZ0ZXINCj4+IC91c3IvbG9jYWwvbGliL2NsYW5n
LzkuMC4wL2luY2x1ZGUgLWlkaXJhZnRlcg0KPj4gL3Vzci9pbmNsdWRlL2FhcmNoNjQtbGludXgt
Z251IC1pZGlyYWZ0ZXIgL3Vzci9pbmNsdWRlDQo+PiAtV25vLWNvbXBhcmUtZGlzdGluY3QtcG9p
bnRlci10eXBlcyAtTzIgLXRhcmdldCBicGYgLWVtaXQtbGx2bSBcDQo+PiAtYyBwcm9ncy90ZXN0
X2NvcmVfcmVsb2NfYXJyYXlzLmMgLW8gLSB8fCBlY2hvICJjbGFuZyBmYWlsZWQiKSB8IFwNCj4+
IGxsYyAtbWFyY2g9YnBmIC1tY3B1PXByb2JlICAtZmlsZXR5cGU9b2JqIC1vDQo+PiAvdXNyL3Ny
Yy90b3ZhcmRzL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X2NvcmVfcmVs
b2NfYXJyYXlzLm8NCj4+IFN0YWNrIGR1bXA6DQo+PiAwLiBQcm9ncmFtIGFyZ3VtZW50czogbGxj
IC1tYXJjaD1icGYgLW1jcHU9cHJvYmUgLWZpbGV0eXBlPW9iaiAtbw0KPj4gL3Vzci9zcmMvdG92
YXJkcy9saW51eC90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9jb3JlX3JlbG9jX2Fy
cmF5cy5vDQo+PiAxLiBSdW5uaW5nIHBhc3MgJ0Z1bmN0aW9uIFBhc3MgTWFuYWdlcicgb24gbW9k
dWxlICc8c3RkaW4+Jy4NCj4+IDIuIFJ1bm5pbmcgcGFzcyAnQlBGIEFzc2VtYmx5IFByaW50ZXIn
IG9uIGZ1bmN0aW9uICdAdGVzdF9jb3JlX2FycmF5cycNCj4+ICMwIDB4MDAwMGFhYWFjNjE4ZGIw
OCBsbHZtOjpzeXM6OlByaW50U3RhY2tUcmFjZShsbHZtOjpyYXdfb3N0cmVhbSYpDQo+PiAoL3Vz
ci9sb2NhbC9iaW4vbGxjKzB4MTUyZWIwOCkNCj4+IFNlZ21lbnRhdGlvbiBmYXVsdA0KPiANCj4g
SGksDQo+IA0KPiBGV0lXIEkgY2FuIGNvbmZpcm0gdGhhdCB0aGlzIGlzIGhhcHBlbmluZyBvbiBz
MzkwIHRvbyB3aXRoIGxsdm0tcHJvamVjdA0KPiBjb21taXQgOTUwYjgwMGM0NTFmLg0KPiANCj4g
SGVyZSBpcyB0aGUgcmVkdWNlZCBzYW1wbGUgdGhhdCB0cmlnZ2VycyB0aGlzICh3aXRoIC1tYXJj
aD1icGYNCj4gLW1hdHRyPSthbHUzMik6DQo+IA0KPiBzdHJ1Y3QgYiB7DQo+ICAgIGludCBlOw0K
PiB9IGM7DQo+IGludCBmKCkgew0KPiAgICByZXR1cm4gX19idWlsdGluX3ByZXNlcnZlX2ZpZWxk
X2luZm8oYy5lLCAwKTsNCj4gfQ0KPiANCj4gVGhpcyBpcyBjb21waWxlZCBpbnRvOg0KPiANCj4g
MEIgICAgICBiYi4wICglaXItYmxvY2suMCk6DQo+IDE2QiAgICAgICAlMDpncHIgPSBMRF9pbW02
NCBAImI6MDowJDA6MCINCj4gMzJCICAgICAgICR3MCA9IENPUFkgJTA6Z3ByLCBkZWJ1Zy1sb2Nh
dGlvbiAhMTc7IDEtRS5jOjU6Mw0KPiA0OEIgICAgICAgUkVUIGltcGxpY2l0IGtpbGxlZCAkdzAs
IGRlYnVnLWxvY2F0aW9uICExNzsgMS1FLmM6NTozDQo+IA0KPiBhbmQgdGhlbiBCUEZJbnN0cklu
Zm86OmNvcHlQaHlzUmVnIGNob2tlcyBvbiBDT1BZLCBzaW5jZSAkdzAgYW5kICUwIGFyZQ0KPiBp
biBkaWZmZXJlbnQgcmVnaXN0ZXIgY2xhc3Nlcy4NCg0KSWx5YSwNCg0KVGhhbmtzIGZvciByZXBv
cnRpbmcuIEkgY2FuIHJlcHJvZHVjZSB0aGUgaXNzdWUgd2l0aCBsYXRlc3QgdHJ1bmsuDQpJIHdp
bGwgaW52ZXN0aWdhdGUgYW5kIGZpeCB0aGUgcHJvYmxlbSBzb29uLg0KDQpZb25naG9uZw0KDQo+
IA0KPiBJJ20gY3VycmVudGx5IGJpc2VjdGluZywgYW5kIGFsc28gY2hlY2tpbmcgd2hldGhlciBz
dXBwb3J0aW5nIGFzeW1tZXRyaWMNCj4gY29waWVzIChsaWtlIFg4NiBkb2VzIGluIENvcHlUb0Zy
b21Bc3ltbWV0cmljUmVnKSB3b3VsZCByZXNvbHZlIHRoYXQuDQo+IA0KPiBCZXN0IHJlZ2FyZHMs
DQo+IElseWENCj4gDQo=
