Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D0ADCC61
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 19:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505226AbfJRRLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 13:11:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23088 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388005AbfJRRLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 13:11:32 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9IH6KWu023644;
        Fri, 18 Oct 2019 10:11:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=TVyeICVnQQ3+qs0ZIiOpnyp5ceXWmIMTILSPkM5A57o=;
 b=MJe0Z2lxBXCrddNNtiVG4teuNfogLrVHn1FhRbumuxUK9zbiIJcH3XLs463HROX+npr9
 RSLQ7wysVl7P3BMZL3hvdjhtmJlZ8kQV0lkGbFsh3EMJQRD8H+eu6n6xeQm7UCjWITTG
 Vny4leT4KNOZj7yD+2GaSxtMp+xiWCX4eyY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vqhgjr0pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 10:11:30 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 10:11:29 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 10:11:28 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 10:11:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCDjX51SolZ+YbrOpaSxvJK7nk7Yt4HOvSkVZ5dytIGIcLZyBL0yZvorNgh+U73dqI8stYT/Zo5HcW+yRnmsxvemKAzK0aiJKQA30HrBWfxz4xyGO09w04GkMXc/Ik5BETR7eIK3wc2rdfkeTiEla/Q/AtkQGmfG/t0D/nKoHawwoxAdJYDP18YkrZ0oJ0Y2iVhJsbO5Dpacsp4hc5qN/Mk8ioFTVLL7KVrMFSQRDpcjZOy6/54lQ2XT8JlRvKgLVdmpbVpshJpKVXHCWw5Tq9KEG2VJUI+4DG4qKzk+xViw85T5aFIxtnCvHyuePNguu2lchuIhEtZmJMcZBGwXFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVyeICVnQQ3+qs0ZIiOpnyp5ceXWmIMTILSPkM5A57o=;
 b=H/gyFoCuGBlGiAzLnTf9vevujIQZjly/IyvwBJoZ8X9wIBb452E1W+dqnv5nUiSLunZ92llFM9Gc9KoI6a/foN3MG30uxoquayEo6kj8tuQXgXDI4mbPQdCRoOBjfObwqvgtt+I66CwZHU0gkTlcl7RgcY5+LeuFlLViIPzs/ia1t+Uyh/HdY7sWpJQBeXdyaDhpb/mmjOaBZ8GK92MLoXMRrybvl55kFaG6GWawgSkNbRcnSIZFrxHXnTYiSZRUjSeXjHWJsHz7GGum40nLXEOvt60oSD2vZhwgBBx6tsC0tMBVucIO26bRLqnmk4kBmtO4KY6bvaV3ZotpjDL+gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVyeICVnQQ3+qs0ZIiOpnyp5ceXWmIMTILSPkM5A57o=;
 b=KWIIz+IuSgjYNT4DTSPqBXNFmQDifZoxkn4Ex3kwpuKCb/2tBtjz1Z1QS0DdIZVoFIdjb/aX+LjW/pRy47nCYPhYR/shckXYj9Gsx7+E+EiwmuqewgFAcImbhd3lL/zzhpvmUlu2q78WFyfbzDXY4pUzMfWtIRT9K+i/cb4XXG0=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3157.namprd15.prod.outlook.com (20.179.58.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 18 Oct 2019 17:11:27 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 17:11:27 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v14 3/5] tools: Added bpf_get_ns_current_pid_tgid helper
Thread-Topic: [PATCH v14 3/5] tools: Added bpf_get_ns_current_pid_tgid helper
Thread-Index: AQHVhPu8iod1iSkvt0edwqoA0KvBw6dgpCwA
Date:   Fri, 18 Oct 2019 17:11:27 +0000
Message-ID: <c208faaf-8cfe-1641-ad9a-61d293232d7c@fb.com>
References: <20191017150032.14359-1-cneirabustos@gmail.com>
 <20191017150032.14359-4-cneirabustos@gmail.com>
In-Reply-To: <20191017150032.14359-4-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0006.namprd11.prod.outlook.com
 (2603:10b6:301:1::16) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3455]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d09f7b2-c61f-4d1f-7f34-08d753ee361a
x-ms-traffictypediagnostic: BYAPR15MB3157:
x-microsoft-antispam-prvs: <BYAPR15MB315726EEFC9C547ACBB5A827D36C0@BYAPR15MB3157.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(346002)(376002)(396003)(39860400002)(199004)(189003)(110136005)(6486002)(46003)(36756003)(486006)(6116002)(11346002)(86362001)(31696002)(2906002)(25786009)(14454004)(186003)(4326008)(102836004)(478600001)(446003)(2616005)(54906003)(476003)(386003)(6506007)(316002)(53546011)(31686004)(6512007)(14444005)(66446008)(6246003)(256004)(64756008)(66556008)(66946007)(71200400001)(71190400001)(52116002)(76176011)(66476007)(8676002)(305945005)(7736002)(2501003)(6436002)(99286004)(81166006)(81156014)(8936002)(5660300002)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3157;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E+vRfX51WKszIrxDE/uhFvwTaLZOIYSMEC/v5fH1FJtVaTVZcdBQ82xAHZzKXDkqhMYiRZU/Vgj3EFk/YdX9WKAkFwPLLu1cFWBL9E+y5gSXvhgboWvCZclSa/m+j6SQhVB45zmagDdJoM0CVo08TlQ1K7PDT9J4+L0zzBMROoBtYItaXyI1c0eRj/PiQKdr0o3jfVD9OYQHHKGOvGBq7k/LevtfpccuU5QPyMFA73Zj6YQxhwOK95ECbZBhB5sP6jbJCb3vHjEXi1V2b8EdXIrvGDXFftKkCJ9CGCz35XEEstcU6oQ+qUWBR/OCb7NeF0kbDq7HLbWXFKzOIUEBVbkGbP/w/dkukxZ85p2bx8Xnb19ffClwEcmc14dN0LVX+oDXTqSGdQvUuAY5pbevTF2FyEr6Wi4dSGVQOZoAwOc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FBDDB3E921AA3A43BF5A4F58065A1A8F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d09f7b2-c61f-4d1f-7f34-08d753ee361a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 17:11:27.3791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4h9TqRDKmxDIwYZunCLYz9QXjuj6WsJ/7KjN2FbO9qpMabFtr8TV6B+3RdqH04S6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3157
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_04:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910180156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzE3LzE5IDg6MDAgQU0sIENhcmxvcyBOZWlyYSB3cm90ZToNCj4gc3luYyB0b29s
cy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggdG8gaW5jbHVkZSBuZXcgaGVscGVyLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQ2FybG9zIE5laXJhIDxjbmVpcmFidXN0b3NAZ21haWwuY29tPg0KPiAt
LS0NCj4gICB0b29scy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggfCAyMCArKysrKysrKysrKysr
KysrKysrLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIGIv
dG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+IGluZGV4IGE2NWMzYjBjNjkzNS4uYTE3
NTgzYWU5YWEzIDEwMDY0NA0KPiAtLS0gYS90b29scy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgN
Cj4gKysrIGIvdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+IEBAIC0yNzUwLDYgKzI3
NTAsMTkgQEAgdW5pb24gYnBmX2F0dHIgew0KPiAgICAqCQkqKi1FT1BOT1RTVVBQKioga2VybmVs
IGNvbmZpZ3VyYXRpb24gZG9lcyBub3QgZW5hYmxlIFNZTiBjb29raWVzDQo+ICAgICoNCj4gICAg
KgkJKiotRVBST1RPTk9TVVBQT1JUKiogSVAgcGFja2V0IHZlcnNpb24gaXMgbm90IDQgb3IgNg0K
PiArICoNCj4gKyAqIHU2NCBicGZfZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWQodTY0IGRldiwgdTY0
IGlubywgc3RydWN0IGJwZl9waWRuc19pbmZvICpuc2RhdGEsIHUzMiBzaXplKQ0KPiArICoJRGVz
Y3JpcHRpb24NCj4gKyAqCQlSZXR1cm5zIDAgb24gc3VjY2VzcywgdmFsdWVzIGZvciAqcGlkKiBh
bmQgKnRnaWQqIGFzIHNlZW4gZnJvbSB0aGUgY3VycmVudA0KPiArICoJCSpuYW1lc3BhY2UqIHdp
bGwgYmUgcmV0dXJuZWQgaW4gKm5zZGF0YSouDQo+ICsgKg0KPiArICoJCU9uIGZhaWx1cmUsIHRo
ZSByZXR1cm5lZCB2YWx1ZSBpcyBvbmUgb2YgdGhlIGZvbGxvd2luZzoNCj4gKyAqDQo+ICsgKgkJ
KiotRUlOVkFMKiogaWYgZGV2IGFuZCBpbnVtIHN1cHBsaWVkIGRvbid0IG1hdGNoIGRldl90IGFu
ZCBpbm9kZSBudW1iZXINCj4gKyAqICAgICAgICAgICAgICB3aXRoIG5zZnMgb2YgY3VycmVudCB0
YXNrLCBvciBpZiBkZXYgY29udmVyc2lvbiB0byBkZXZfdCBsb3N0IGhpZ2ggYml0cy4NCj4gKyAq
DQo+ICsgKgkJKiotRU5PRU5UKiogaWYgL3Byb2Mvc2VsZi9ucyBkb2VzIG5vdCBleGlzdHMuDQoN
ClRoZSBzYW1lIHJldHVybiB0eXBlIGFuZCBkZXNjcmlwdGlvbiBjaGFuZ2VzIGFzIHN1Z2dlc3Rl
ZCBpbiBteQ0KcHJldmlvdXMgY29tbWVudC4NCg0KPiArICoNCj4gICAgKi8NCj4gICAjZGVmaW5l
IF9fQlBGX0ZVTkNfTUFQUEVSKEZOKQkJXA0KPiAgIAlGTih1bnNwZWMpLAkJCVwNCj4gQEAgLTI4
NjIsNyArMjg3NSw4IEBAIHVuaW9uIGJwZl9hdHRyIHsNCj4gICAJRk4oc2tfc3RvcmFnZV9nZXQp
LAkJXA0KPiAgIAlGTihza19zdG9yYWdlX2RlbGV0ZSksCQlcDQo+ICAgCUZOKHNlbmRfc2lnbmFs
KSwJCVwNCj4gLQlGTih0Y3BfZ2VuX3N5bmNvb2tpZSksDQo+ICsJRk4odGNwX2dlbl9zeW5jb29r
aWUpLCAgICAgICAgICBcDQo+ICsJRk4oZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWQpLA0KPiAgIA0K
PiAgIC8qIGludGVnZXIgdmFsdWUgaW4gJ2ltbScgZmllbGQgb2YgQlBGX0NBTEwgaW5zdHJ1Y3Rp
b24gc2VsZWN0cyB3aGljaCBoZWxwZXINCj4gICAgKiBmdW5jdGlvbiBlQlBGIHByb2dyYW0gaW50
ZW5kcyB0byBjYWxsDQo+IEBAIC0zNjEzLDQgKzM2MjcsOCBAQCBzdHJ1Y3QgYnBmX3NvY2tvcHQg
ew0KPiAgIAlfX3MzMglyZXR2YWw7DQo+ICAgfTsNCj4gICANCj4gK3N0cnVjdCBicGZfcGlkbnNf
aW5mbyB7DQo+ICsJX191MzIgcGlkOw0KPiArCV9fdTMyIHRnaWQ7DQo+ICt9Ow0KPiAgICNlbmRp
ZiAvKiBfVUFQSV9fTElOVVhfQlBGX0hfXyAqLw0KPiANCg==
