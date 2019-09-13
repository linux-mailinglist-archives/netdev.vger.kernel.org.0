Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02ADB277A
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 23:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbfIMVqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 17:46:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18302 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731368AbfIMVqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 17:46:14 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8DLjmdv002109;
        Fri, 13 Sep 2019 14:45:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=uqZQOptCQboyYDEEJtmi984DfSamYJpgC0gBAfs3nk0=;
 b=BqnCUV/+rnYQbnpYuOIrEehqZDkotBqMx90Uh5dMNjaaUUUAnUgMzcFU+v7oYPro0i6x
 ZSx8e+LyXX/W3dxPMEMN5sp5A7pdnDILoRfMMp4poWwQojIdnH8wWUQBUDSyYIhFebui
 l6UvZe9ekupzRCHyehyHQkBv6xBL8jswMO4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2v0ev4sa1u-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Sep 2019 14:45:48 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 14:45:32 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 14:45:32 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 14:45:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqPDzWqLU3BadZMjtm7yf78GGtysyzWvYyBYl2lHn4ubiOFkRpml6gUdK2moUqbW1kCXtBOow2vG2oByGxBG/o0IIg2NUd+X65byjwy+klUwKJh771VjQzGx6V7CEwR7YWo4xK5BPxkW9N4OQq8WXh/30uQ4nCD20/z5kDTWmF4KLyeZK19zuU2TmxTDVF44dv51ePtKAzm+oRgoCTFNGWeJyFK6COqsVCoe/0E4L4sbsNd8KPrKEKqY+083TzKezwQL9CBJHgFPa7tRGEWhMjV7A9eDdNTWdHqA2MR85hZtVhKH4qgcD0+ScDfhS+1VzNAS/V0jvjg0/1755Rzi7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqZQOptCQboyYDEEJtmi984DfSamYJpgC0gBAfs3nk0=;
 b=Bia2Wvg7FZLslX6fQJk0PP3fimVJ/JVXfj7cOziIyDmwVf4bxWD+Qw46+PXJ+FTlT0ze/DLG2dmp/gQIQ8OHsfNo/JErhdpm7t+3WX24AwbfnVKFHQe0boqzDPkwiHhbnsSBAIrGgxe6ifA0sWAzdFsYp2rJA9KSVtxMWRmrDf82yfQcvQH/PRwLY51Ofn/yoX9gF05YGPnNxTbdCiEGbY1udYaUmzwSJxAPEjeCLFz7o9LW4J4Myw3Puz7Ia5fjZuTxqEXwWic29T4iYW44UwwD1Vmlioqm2v9CjglqZuV31Uo5b9McBhG+Jinl6Ln4duA9mAPvmryuB1vglSozaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqZQOptCQboyYDEEJtmi984DfSamYJpgC0gBAfs3nk0=;
 b=b8VB8UAkLOddKltq1XhOnynCVwrOg3XbRX9tK7oqlRLkuEJHL7zsAbTZsdPe7E4q99TuoPUckRf3mzzQoAA3LAEBWOVemml55cQ5kEZm6CSf8TkJp81sWyZ+L5QjRXMhKRKrK3iQnhOKu2AQbtuA31pA6JdnH+MzW4Iw9OT9IA0=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2790.namprd15.prod.outlook.com (20.179.158.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Fri, 13 Sep 2019 21:45:31 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2263.021; Fri, 13 Sep 2019
 21:45:31 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH bpf-next 11/11] samples: bpf: makefile: add sysroot
 support
Thread-Topic: [PATCH bpf-next 11/11] samples: bpf: makefile: add sysroot
 support
Thread-Index: AQHVZ8PyRYUBCRRgOEm7qm2VNIx5W6cqKZSA
Date:   Fri, 13 Sep 2019 21:45:31 +0000
Message-ID: <e967744b-0286-d92f-9fc8-70f5759cc4a1@fb.com>
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
 <20190910103830.20794-12-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190910103830.20794-12-ivan.khoronzhuk@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR01CA0027.prod.exchangelabs.com (2603:10b6:300:101::13)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::ec5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75d5263a-344c-4a23-93ce-08d73893b2ed
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BYAPR15MB2790;
x-ms-traffictypediagnostic: BYAPR15MB2790:
x-microsoft-antispam-prvs: <BYAPR15MB2790A878AA2D8ED959F5593BD3B30@BYAPR15MB2790.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(6512007)(2906002)(478600001)(66556008)(305945005)(110136005)(66476007)(6486002)(81156014)(8676002)(6436002)(66446008)(54906003)(486006)(86362001)(256004)(2501003)(71200400001)(71190400001)(316002)(476003)(7416002)(36756003)(14454004)(76176011)(99286004)(7736002)(31686004)(64756008)(31696002)(2201001)(5660300002)(4326008)(25786009)(52116002)(81166006)(6116002)(66946007)(8936002)(229853002)(102836004)(386003)(53546011)(186003)(6506007)(446003)(11346002)(2616005)(53936002)(6246003)(46003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2790;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zUhGC0ptyy1Y7XBNYXErEPPlc25WmQJXYQraG5w5MfUuXgO7zdZHCHJ+K67GvCWgGj8105pE4/6m+ZBaKvtytpKtgQv2ZfigJwG6sePv+CRetZmHX/NTe2wQjtnhpUpeuyHmYOD89Be2ILySFOBKibI+ZIEFREXvGs/LKhvYDwuPHtOx8pXN/rDQC0TnxEP+qVkVX53sT4CGInSAJOwDK2qOX4J8qwckyviFJD4yhAeDV2M9mCaoKpkYSX/ALt6nPjkfOnYyLf8+Fun71bCO8mtDSWCyPWmaGzSpIa19r2zmnuJ3qtpviyUvFr3AZcOygpnjUtyDq+xRQoZUZce4mq3pntybdOT/2ihFYY+5bJtv4zOfKwJ84dpb2ZEyU+5AhHn2Bvh4kJzxYyJA3l1eXCwnINO6V5Pkg9ULoA32x/g=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB5331D465EAA34EB931FE05D808F6CD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 75d5263a-344c-4a23-93ce-08d73893b2ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 21:45:31.1545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eVT5WK0z7jT8scVHNQFm8ZtIYHiYxghZSJWQ8KLcgnZvW6xsFF+Q42u90M6XfiyJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2790
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_10:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909130216
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTAvMTkgMTE6MzggQU0sIEl2YW4gS2hvcm9uemh1ayB3cm90ZToNCj4gQmFzaWNh
bGx5IGl0IG9ubHkgZW5hYmxlcyB0aGF0IHdhcyBhZGRlZCBieSBwcmV2aW91cyBjb3VwbGUgZml4
ZXMuDQo+IEZvciBzdXJlLCBqdXN0IG1ha2UgdG9vbHMvaW5jbHVkZSB0byBiZSBpbmNsdWRlZCBh
ZnRlciBzeXNyb290DQo+IGhlYWRlcnMuDQo+IA0KPiBleHBvcnQgQVJDSD1hcm0NCj4gZXhwb3J0
IENST1NTX0NPTVBJTEU9YXJtLWxpbnV4LWdudWVhYmloZi0NCj4gbWFrZSBzYW1wbGVzL2JwZi8g
U1lTUk9PVD0icGF0aC90by9zeXNyb290Ig0KPiANCj4gU3lzcm9vdCBjb250YWlucyBjb3JyZWN0
IGxpYnMgaW5zdGFsbGVkIGFuZCBpdHMgaGVhZGVycyBvZmMuDQo+IFVzZWZ1bCB3aGVuIHdvcmtp
bmcgd2l0aCBORkMgb3IgdmlydHVhbCBtYWNoaW5lLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSXZh
biBLaG9yb256aHVrIDxpdmFuLmtob3JvbnpodWtAbGluYXJvLm9yZz4NCj4gLS0tDQo+ICAgc2Ft
cGxlcy9icGYvTWFrZWZpbGUgICB8ICA1ICsrKysrDQo+ICAgc2FtcGxlcy9icGYvUkVBRE1FLnJz
dCB8IDEwICsrKysrKysrKysNCj4gICAyIGZpbGVzIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKykN
Cj4gDQo+IGRpZmYgLS1naXQgYS9zYW1wbGVzL2JwZi9NYWtlZmlsZSBiL3NhbXBsZXMvYnBmL01h
a2VmaWxlDQo+IGluZGV4IDRlZGM1MjMyY2ZjMS4uNjhiYTc4ZDFkYmJlIDEwMDY0NA0KPiAtLS0g
YS9zYW1wbGVzL2JwZi9NYWtlZmlsZQ0KPiArKysgYi9zYW1wbGVzL2JwZi9NYWtlZmlsZQ0KPiBA
QCAtMTc3LDYgKzE3NywxMSBAQCBpZmVxICgkKEFSQ0gpLCBhcm0pDQo+ICAgQ0xBTkdfRVhUUkFf
Q0ZMQUdTIDo9ICQoRF9PUFRJT05TKQ0KPiAgIGVuZGlmDQo+ICAgDQo+ICtpZmRlZiBTWVNST09U
DQo+ICtjY2ZsYWdzLXkgKz0gLS1zeXNyb290PSR7U1lTUk9PVH0NCj4gK1BST0dTX0xERkxBR1Mg
Oj0gLUwke1NZU1JPT1R9L3Vzci9saWINCj4gK2VuZGlmDQo+ICsNCj4gICBjY2ZsYWdzLXkgKz0g
LUkkKG9ianRyZWUpL3Vzci9pbmNsdWRlDQo+ICAgY2NmbGFncy15ICs9IC1JJChzcmN0cmVlKS90
b29scy9saWIvYnBmLw0KPiAgIGNjZmxhZ3MteSArPSAtSSQoc3JjdHJlZSkvdG9vbHMvdGVzdGlu
Zy9zZWxmdGVzdHMvYnBmLw0KPiBkaWZmIC0tZ2l0IGEvc2FtcGxlcy9icGYvUkVBRE1FLnJzdCBi
L3NhbXBsZXMvYnBmL1JFQURNRS5yc3QNCj4gaW5kZXggNWYyN2U0ZmFjYTUwLi43ODZkMGFiOThl
OGEgMTAwNjQ0DQo+IC0tLSBhL3NhbXBsZXMvYnBmL1JFQURNRS5yc3QNCj4gKysrIGIvc2FtcGxl
cy9icGYvUkVBRE1FLnJzdA0KPiBAQCAtNzQsMyArNzQsMTMgQEAgc2FtcGxlcyBmb3IgdGhlIGNy
b3NzIHRhcmdldC4NCj4gICBleHBvcnQgQVJDSD1hcm02NA0KPiAgIGV4cG9ydCBDUk9TU19DT01Q
SUxFPSJhYXJjaDY0LWxpbnV4LWdudS0iDQo+ICAgbWFrZSBzYW1wbGVzL2JwZi8gTExDPX4vZ2l0
L2xsdm0vYnVpbGQvYmluL2xsYyBDTEFORz1+L2dpdC9sbHZtL2J1aWxkL2Jpbi9jbGFuZw0KPiAr
DQo+ICtJZiBuZWVkIHRvIHVzZSBlbnZpcm9ubWVudCBvZiB0YXJnZXQgYm9hcmQgKGhlYWRlcnMg
YW5kIGxpYnMpLCB0aGUgU1lTUk9PVA0KPiArYWxzbyBjYW4gYmUgc2V0LCBwb2ludGluZyBvbiBG
UyBvZiB0YXJnZXQgYm9hcmQ6DQo+ICsNCj4gK2V4cG9ydCBBUkNIPWFybTY0DQo+ICtleHBvcnQg
Q1JPU1NfQ09NUElMRT0iYWFyY2g2NC1saW51eC1nbnUtIg0KPiArbWFrZSBzYW1wbGVzL2JwZi8g
U1lTUk9PVD1+L3NvbWVfc2RrL2xpbnV4LWRldmtpdC9zeXNyb290cy9hYXJjaDY0LWxpbnV4LWdu
dQ0KPiArDQo+ICtTZXR0aW5nIExMQyBhbmQgQ0xBTkcgaXMgbm90IG5lY2Vzc2FyaWx5IGlmIGl0
J3MgaW5zdGFsbGVkIG9uIEhPU1QgYW5kIGhhdmUNCj4gK2luIGl0cyB0YXJnZXRzIGFwcHJvcHJp
YXRlIGFyY2ggdHJpcGxlICh1c3VhbGx5IGl0IGhhcyBzZXZlcmFsIGFyY2hlcykuDQoNCllvdSBo
YXZlIHZlcnkgZ29vZCBkZXNjcmlwdGlvbiBhYm91dCBob3cgdG8gYnVpbGQgYW5kIHRlc3QgaW4g
Y292ZXIgDQpsZXR0ZXIuIENvdWxkIHlvdSBpbmNsdWRlIHRob3NlIGluc3RydWN0aW9ucyBoZXJl
IGFzIHdlbGw/IFRoaXMgd2lsbA0KaGVscCBrZWVwIGEgcmVjb3JkIHNvIGxhdGVyIHBlb3BsZSBj
YW4gdHJ5L3Rlc3QgaWYgbmVlZGVkLg0K
