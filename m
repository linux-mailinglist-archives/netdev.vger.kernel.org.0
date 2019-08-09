Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAC6885B6
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbfHIWQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:16:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4070 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726078AbfHIWQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 18:16:44 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79MAD7Y029339;
        Fri, 9 Aug 2019 15:16:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=SaLB17UQAS+WnHOzJGrxGm8aUSHBz+aZ1gS1748JKr4=;
 b=IXmhVvgz2YJ42+VWqfaxkkMfzYnx3O1g0WnScAt0iEtyIQkjyvFu24CRyNBQWPntfUiN
 FJITIvP11RL8EXLvRMS5T1/r63RHQH+E7KIrzt6e2RBpCvx07pRLng1zUR87Wn7l8nS7
 M20rHp1dOCBn12WDpg6gPYJNQKDtxK9DrsY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u9d5jh7rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 09 Aug 2019 15:16:33 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 9 Aug 2019 15:16:32 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 9 Aug 2019 15:16:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IiFvaCb8W3d0NrJPzobcICX156pql9xUH9+P8V+wKcE9fXNlSaYAsFC9mE4jEhjo8162bZRUt9JXLNiKtEFtjcOw8MPvUyMu/H++BGAn0fxVhGhAQkV7BTfXitz7b2Oq4Haez97CF6LuBrGXV2DB/d3yq8Rlm3gRTQKs5al5uhx/Dot8qO1V3k26od8gs/4MjUPBBqfu77Io/EgbIdBXiXoQG/gRtFKqRqp6+IhWQvncfhwwgmjDRy7lPUMiGbjjgKOko7QEyN8n841NoaMaYalxCTRl+vjRstFGMK524lBq57j7jBjRvo4kpT5qa6Q4UCT7Xe89yIzY49ByDl1WHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SaLB17UQAS+WnHOzJGrxGm8aUSHBz+aZ1gS1748JKr4=;
 b=Eedwnu7QbqXe1ihDCJuz8mptoZNqjX92K1FrVPXBAjCDbfC5K1p3yWzkRILmrOvxTO4ZH6ZJY++TaUyjXmbzqi+WkWuz1aUbGP17Sbg8huVQtXx+3APiy5XD2MveHwuTSr8/m+tvC03c9ZwcDVi9H5akmlAGUfV4cb03jA+LJLWz2QP5hHJrFZSiYvuchIOhZv4/Z8Y/ptlmY52jN7ZTHfewfu8AmjeijuPGr07Q43YsIf6U8Nc/B0Dfk+GFv8+kteeiJC0C+UmqVGx8+gWp/FeyqGtqjGttgdbRwNSfpkRfgIoQsJwWLhewrST/Rj22tFUU6l7ocvDydue2eks8Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SaLB17UQAS+WnHOzJGrxGm8aUSHBz+aZ1gS1748JKr4=;
 b=jPuyQuRiKeN6Wft5rdA+dJTSkx2XAM3l/JwfC7GeI+lGdscBpj+Dyh0Uohwi6PGU2NIqpNEjAgqa2oKCzM3MU5nag59ayAcvMUFVxx7Y1EvDvM16QWrE0pf1RQbUrhn3I7zeCv24OdBxxSdR2wWaRSXMcSB6t+7he0duGytWNq0=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1149.namprd15.prod.outlook.com (10.175.3.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Fri, 9 Aug 2019 22:16:30 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:16:30 +0000
From:   Tao Ren <taoren@fb.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [Potential Spoof] Re: [PATCH net-next v6 3/3] net: phy: broadcom:
 add 1000Base-X support for BCM54616S
Thread-Topic: [Potential Spoof] Re: [PATCH net-next v6 3/3] net: phy:
 broadcom: add 1000Base-X support for BCM54616S
Thread-Index: AQHVTnXbR0omRCjy/0G0ZEtUvAlu56bzQySAgAAJTAD//4/tAIAAgh+AgAAExgA=
Date:   Fri, 9 Aug 2019 22:16:30 +0000
Message-ID: <a2c54cdd-51c9-49a6-3fe8-be6983dc8736@fb.com>
References: <20190809054411.1015962-1-taoren@fb.com>
 <97cd059c-d98e-1392-c814-f3bd628e6366@gmail.com>
 <e556dd17-ef85-3c61-bc08-17db02d9a5dc@fb.com>
 <8f0e172b-575c-dab8-b695-c33dfc78fa8f@fb.com>
 <d398ca57-575c-6e88-49a5-bf49cddfa2f0@gmail.com>
In-Reply-To: <d398ca57-575c-6e88-49a5-bf49cddfa2f0@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0048.namprd02.prod.outlook.com
 (2603:10b6:301:60::37) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:e1ee]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5173dfc-12de-4a34-8ed3-08d71d173aaf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1149;
x-ms-traffictypediagnostic: MWHPR15MB1149:
x-microsoft-antispam-prvs: <MWHPR15MB1149288C55DC38894D246408B2D60@MWHPR15MB1149.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(376002)(366004)(396003)(39860400002)(199004)(189003)(305945005)(6436002)(25786009)(14454004)(81166006)(46003)(8676002)(316002)(110136005)(64126003)(7416002)(6486002)(5660300002)(58126008)(8936002)(81156014)(65956001)(65806001)(6512007)(36756003)(6246003)(64756008)(66446008)(66946007)(66476007)(71200400001)(53936002)(66556008)(71190400001)(76176011)(2906002)(478600001)(446003)(99286004)(11346002)(2201001)(52116002)(65826007)(6506007)(53546011)(486006)(14444005)(31696002)(256004)(31686004)(186003)(386003)(86362001)(102836004)(2501003)(6116002)(476003)(2616005)(229853002)(7736002)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1149;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: u8CbTASGjyCSfN6ajVJPjTccRfpmg6rt1Ni7NTvHD0gAnRAXGlHw3mfLYY8r2ri1Aa+gTcuafIlP+GnPuZc3LGGtVQWTIAKyTmCF8wXWrOY/2ZVQnd6d9/pCmzGhx/kg8OaaOwPHGpb3SP4S+5hUnHYTbdOjP+F6ZfdAbCZDb1jxgEFm1UA7zQdAkuLjBzfcuBnBYi2ULWKo7sMcwMAF142KWjcnG88j6wswGrg29NldTMyJR8AFAGgW9oGsOYHephfxH4111GlrAzvtcFBFqNYrBWawJ9sSeVpDdYRZXo9viMRqGCmL5EtOrWewTtBqmNAiu5KFNflNjH01ejrKC8tzdj9hdrz3Jk6VFU3g+Vq58a8rspaiKsCrpfH3KMidIHAsPIuQM+qVIP7JAyTAaFG0HaEVRg5uGsC4iE9Z5wg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4BF245E96ABE541B6AA18483512B02F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a5173dfc-12de-4a34-8ed3-08d71d173aaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:16:30.5250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fb6rVp6RuXg9tNyzSf1acD9Eto0VWs4hsLzWkK6NLiHrZVNH3ZOiCytNAhghiU31
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1149
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090215
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC85LzE5IDI6NTkgUE0sIEhlaW5lciBLYWxsd2VpdCB3cm90ZToNCj4gT24gMDkuMDguMjAx
OSAyMzoxMywgVGFvIFJlbiB3cm90ZToNCj4+IE9uIDgvOS8xOSAxOjU0IFBNLCBUYW8gUmVuIHdy
b3RlOg0KPj4+IEhpIEhlaW5lciwNCj4+Pg0KPj4+IE9uIDgvOS8xOSAxOjIxIFBNLCBIZWluZXIg
S2FsbHdlaXQgd3JvdGU6DQo+Pj4+IE9uIDA5LjA4LjIwMTkgMDc6NDQsIFRhbyBSZW4gd3JvdGU6
DQo+Pj4+PiBUaGUgQkNNNTQ2MTZTIFBIWSBjYW5ub3Qgd29yayBwcm9wZXJseSBpbiBSR01JSS0+
MTAwMEJhc2UtS1ggbW9kZSAoZm9yDQo+Pj4+PiBleGFtcGxlLCBvbiBGYWNlYm9vayBDTU0gQk1D
IHBsYXRmb3JtKSwgbWFpbmx5IGJlY2F1c2UgZ2VucGh5IGZ1bmN0aW9ucw0KPj4+Pj4gYXJlIGRl
c2lnbmVkIGZvciBjb3BwZXIgbGlua3MsIGFuZCAxMDAwQmFzZS1YIChjbGF1c2UgMzcpIGF1dG8g
bmVnb3RpYXRpb24NCj4+Pj4+IG5lZWRzIHRvIGJlIGhhbmRsZWQgZGlmZmVyZW50bHkuDQo+Pj4+
Pg0KPj4+Pj4gVGhpcyBwYXRjaCBlbmFibGVzIDEwMDBCYXNlLVggc3VwcG9ydCBmb3IgQkNNNTQ2
MTZTIGJ5IGN1c3RvbWl6aW5nIDMNCj4+Pj4+IGRyaXZlciBjYWxsYmFja3M6DQo+Pj4+Pg0KPj4+
Pj4gICAtIHByb2JlOiBwcm9iZSBjYWxsYmFjayBkZXRlY3RzIFBIWSdzIG9wZXJhdGlvbiBtb2Rl
IGJhc2VkIG9uDQo+Pj4+PiAgICAgSU5URVJGX1NFTFsxOjBdIHBpbnMgYW5kIDEwMDBYLzEwMEZY
IHNlbGVjdGlvbiBiaXQgaW4gU2VyREVTIDEwMC1GWA0KPj4+Pj4gICAgIENvbnRyb2wgcmVnaXN0
ZXIuDQo+Pj4+Pg0KPj4+Pj4gICAtIGNvbmZpZ19hbmVnOiBjYWxscyBnZW5waHlfYzM3X2NvbmZp
Z19hbmVnIHdoZW4gdGhlIFBIWSBpcyBydW5uaW5nIGluDQo+Pj4+PiAgICAgMTAwMEJhc2UtWCBt
b2RlOyBvdGhlcndpc2UsIGdlbnBoeV9jb25maWdfYW5lZyB3aWxsIGJlIGNhbGxlZC4NCj4+Pj4+
DQo+Pj4+PiAgIC0gcmVhZF9zdGF0dXM6IGNhbGxzIGdlbnBoeV9jMzdfcmVhZF9zdGF0dXMgd2hl
biB0aGUgUEhZIGlzIHJ1bm5pbmcgaW4NCj4+Pj4+ICAgICAxMDAwQmFzZS1YIG1vZGU7IG90aGVy
d2lzZSwgZ2VucGh5X3JlYWRfc3RhdHVzIHdpbGwgYmUgY2FsbGVkLg0KPj4+Pj4NCj4+Pj4+IFNp
Z25lZC1vZmYtYnk6IFRhbyBSZW4gPHRhb3JlbkBmYi5jb20+DQo+Pj4+PiAtLS0NCj4+Pj4+ICBD
aGFuZ2VzIGluIHY2Og0KPj4+Pj4gICAtIG5vdGhpbmcgY2hhbmdlZC4NCj4+Pj4+ICBDaGFuZ2Vz
IGluIHY1Og0KPj4+Pj4gICAtIGluY2x1ZGUgSGVpbmVyJ3MgcGF0Y2ggIm5ldDogcGh5OiBhZGQg
c3VwcG9ydCBmb3IgY2xhdXNlIDM3DQo+Pj4+PiAgICAgYXV0by1uZWdvdGlhdGlvbiIgaW50byB0
aGUgc2VyaWVzLg0KPj4+Pj4gICAtIHVzZSBnZW5waHlfYzM3X2NvbmZpZ19hbmVnIGFuZCBnZW5w
aHlfYzM3X3JlYWRfc3RhdHVzIGluIEJDTTU0NjE2Uw0KPj4+Pj4gICAgIFBIWSBkcml2ZXIncyBj
YWxsYmFjayB3aGVuIHRoZSBQSFkgaXMgcnVubmluZyBpbiAxMDAwQmFzZS1YIG1vZGUuDQo+Pj4+
PiAgQ2hhbmdlcyBpbiB2NDoNCj4+Pj4+ICAgLSBhZGQgYmNtNTQ2MTZzX2NvbmZpZ19hbmVnXzEw
MDBieCgpIHRvIGRlYWwgd2l0aCBhdXRvIG5lZ290aWF0aW9uIGluDQo+Pj4+PiAgICAgMTAwMEJh
c2UtWCBtb2RlLg0KPj4+Pj4gIENoYW5nZXMgaW4gdjM6DQo+Pj4+PiAgIC0gcmVuYW1lIGJjbTU0
ODJfcmVhZF9zdGF0dXMgdG8gYmNtNTR4eF9yZWFkX3N0YXR1cyBzbyB0aGUgY2FsbGJhY2sgY2Fu
DQo+Pj4+PiAgICAgYmUgc2hhcmVkIGJ5IEJDTTU0ODIgYW5kIEJDTTU0NjE2Uy4NCj4+Pj4+ICBD
aGFuZ2VzIGluIHYyOg0KPj4+Pj4gICAtIEF1dG8tZGV0ZWN0IFBIWSBvcGVyYXRpb24gbW9kZSBp
bnN0ZWFkIG9mIHBhc3NpbmcgRFQgbm9kZS4NCj4+Pj4+ICAgLSBtb3ZlIFBIWSBtb2RlIGF1dG8t
ZGV0ZWN0IGxvZ2ljIGZyb20gY29uZmlnX2luaXQgdG8gcHJvYmUgY2FsbGJhY2suDQo+Pj4+PiAg
IC0gb25seSBzZXQgc3BlZWQgKG5vdCBpbmNsdWRpbmcgZHVwbGV4KSBpbiByZWFkX3N0YXR1cyBj
YWxsYmFjay4NCj4+Pj4+ICAgLSB1cGRhdGUgcGF0Y2ggZGVzY3JpcHRpb24gd2l0aCBtb3JlIGJh
Y2tncm91bmQgdG8gYXZvaWQgY29uZnVzaW9uLg0KPj4+Pj4gICAtIHBhdGNoICMxIGluIHRoZSBz
ZXJpZXMgKCJuZXQ6IHBoeTogYnJvYWRjb206IHNldCBmZWF0dXJlcyBleHBsaWNpdGx5DQo+Pj4+
PiAgICAgZm9yIEJDTTU0NjE2IikgaXMgZHJvcHBlZDogdGhlIGZpeCBzaG91bGQgZ28gdG8gZ2V0
X2ZlYXR1cmVzIGNhbGxiYWNrDQo+Pj4+PiAgICAgd2hpY2ggbWF5IHBvdGVudGlhbGx5IGRlcGVu
ZCBvbiB0aGlzIHBhdGNoLg0KPj4+Pj4NCj4+Pj4+ICBkcml2ZXJzL25ldC9waHkvYnJvYWRjb20u
YyB8IDU0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tDQo+Pj4+PiAgaW5j
bHVkZS9saW51eC9icmNtcGh5LmggICAgfCAxMCArKysrKy0tDQo+Pj4+PiAgMiBmaWxlcyBjaGFu
Z2VkLCA1OCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPj4+Pj4NCj4+Pj4+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9waHkvYnJvYWRjb20uYyBiL2RyaXZlcnMvbmV0L3BoeS9icm9h
ZGNvbS5jDQo+Pj4+PiBpbmRleCA5MzdkMDA1OWU4YWMuLmZiZDc2YTMxYzE0MiAxMDA2NDQNCj4+
Pj4+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9icm9hZGNvbS5jDQo+Pj4+PiArKysgYi9kcml2ZXJz
L25ldC9waHkvYnJvYWRjb20uYw0KPj4+Pj4gQEAgLTM4Myw5ICszODMsOSBAQCBzdGF0aWMgaW50
IGJjbTU0ODJfY29uZmlnX2luaXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4+Pj4+ICAJ
CS8qDQo+Pj4+PiAgCQkgKiBTZWxlY3QgMTAwMEJBU0UtWCByZWdpc3RlciBzZXQgKHByaW1hcnkg
U2VyRGVzKQ0KPj4+Pj4gIAkJICovDQo+Pj4+PiAtCQlyZWcgPSBiY21fcGh5X3JlYWRfc2hhZG93
KHBoeWRldiwgQkNNNTQ4Ml9TSERfTU9ERSk7DQo+Pj4+PiAtCQliY21fcGh5X3dyaXRlX3NoYWRv
dyhwaHlkZXYsIEJDTTU0ODJfU0hEX01PREUsDQo+Pj4+PiAtCQkJCSAgICAgcmVnIHwgQkNNNTQ4
Ml9TSERfTU9ERV8xMDAwQlgpOw0KPj4+Pj4gKwkJcmVnID0gYmNtX3BoeV9yZWFkX3NoYWRvdyhw
aHlkZXYsIEJDTTU0WFhfU0hEX01PREUpOw0KPj4+Pj4gKwkJYmNtX3BoeV93cml0ZV9zaGFkb3co
cGh5ZGV2LCBCQ001NFhYX1NIRF9NT0RFLA0KPj4+Pj4gKwkJCQkgICAgIHJlZyB8IEJDTTU0WFhf
U0hEX01PREVfMTAwMEJYKTsNCj4+Pj4+ICANCj4+Pj4+ICAJCS8qDQo+Pj4+PiAgCQkgKiBMRUQx
PUFDVElWSVRZTEVELCBMRUQzPUxJTktTUERbMl0NCj4+Pj4+IEBAIC00NTEsMTIgKzQ1MSw0NCBA
QCBzdGF0aWMgaW50IGJjbTU0ODFfY29uZmlnX2FuZWcoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRl
dikNCj4+Pj4+ICAJcmV0dXJuIHJldDsNCj4+Pj4+ICB9DQo+Pj4+PiAgDQo+Pj4+PiArc3RhdGlj
IGludCBiY201NDYxNnNfcHJvYmUoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4+Pj4+ICt7
DQo+Pj4+PiArCWludCB2YWwsIGludGZfc2VsOw0KPj4+Pj4gKw0KPj4+Pj4gKwl2YWwgPSBiY21f
cGh5X3JlYWRfc2hhZG93KHBoeWRldiwgQkNNNTRYWF9TSERfTU9ERSk7DQo+Pj4+PiArCWlmICh2
YWwgPCAwKQ0KPj4+Pj4gKwkJcmV0dXJuIHZhbDsNCj4+Pj4+ICsNCj4+Pj4+ICsJLyogVGhlIFBI
WSBpcyBzdHJhcHBlZCBpbiBSR01JSSB0byBmaWJlciBtb2RlIHdoZW4gSU5URVJGX1NFTFsxOjBd
DQo+Pj4+PiArCSAqIGlzIDAxYi4NCj4+Pj4+ICsJICovDQo+Pj4+PiArCWludGZfc2VsID0gKHZh
bCAmIEJDTTU0WFhfU0hEX0lOVEZfU0VMX01BU0spID4+IDE7DQo+Pj4+PiArCWlmIChpbnRmX3Nl
bCA9PSAxKSB7DQo+Pj4+PiArCQl2YWwgPSBiY21fcGh5X3JlYWRfc2hhZG93KHBoeWRldiwgQkNN
NTQ2MTZTX1NIRF8xMDBGWF9DVFJMKTsNCj4+Pj4+ICsJCWlmICh2YWwgPCAwKQ0KPj4+Pj4gKwkJ
CXJldHVybiB2YWw7DQo+Pj4+PiArDQo+Pj4+PiArCQkvKiBCaXQgMCBvZiB0aGUgU2VyRGVzIDEw
MC1GWCBDb250cm9sIHJlZ2lzdGVyLCB3aGVuIHNldA0KPj4+Pj4gKwkJICogdG8gMSwgc2V0cyB0
aGUgTUlJL1JHTUlJIC0+IDEwMEJBU0UtRlggY29uZmlndXJhdGlvbi4NCj4+Pj4+ICsJCSAqIFdo
ZW4gdGhpcyBiaXQgaXMgc2V0IHRvIDAsIGl0IHNldHMgdGhlIEdNSUkvUkdNSUkgLT4NCj4+Pj4+
ICsJCSAqIDEwMDBCQVNFLVggY29uZmlndXJhdGlvbi4NCj4+Pj4+ICsJCSAqLw0KPj4+Pj4gKwkJ
aWYgKCEodmFsICYgQkNNNTQ2MTZTXzEwMEZYX01PREUpKQ0KPj4+Pj4gKwkJCXBoeWRldi0+ZGV2
X2ZsYWdzIHw9IFBIWV9CQ01fRkxBR1NfTU9ERV8xMDAwQlg7DQo+Pj4+PiArCX0NCj4+Pj4+ICsN
Cj4+Pj4+ICsJcmV0dXJuIDA7DQo+Pj4+PiArfQ0KPj4+Pj4gKw0KPj4+Pj4gIHN0YXRpYyBpbnQg
YmNtNTQ2MTZzX2NvbmZpZ19hbmVnKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+Pj4+PiAg
ew0KPj4+Pj4gIAlpbnQgcmV0Ow0KPj4+Pj4gIA0KPj4+Pj4gIAkvKiBBbmVnIGZpcnNseS4gKi8N
Cj4+Pj4+IC0JcmV0ID0gZ2VucGh5X2NvbmZpZ19hbmVnKHBoeWRldik7DQo+Pj4+PiArCWlmIChw
aHlkZXYtPmRldl9mbGFncyAmIFBIWV9CQ01fRkxBR1NfTU9ERV8xMDAwQlgpDQo+Pj4+PiArCQly
ZXQgPSBnZW5waHlfYzM3X2NvbmZpZ19hbmVnKHBoeWRldik7DQo+Pj4+PiArCWVsc2UNCj4+Pj4+
ICsJCXJldCA9IGdlbnBoeV9jb25maWdfYW5lZyhwaHlkZXYpOw0KPj4+Pj4gIA0KPj4+Pg0KPj4+
PiBJJ20ganVzdCB3b25kZXJpbmcgd2hldGhlciBpdCBuZWVkcyB0byBiZSBjb25zaWRlcmVkIHRo
YXQgMTAwYmFzZS1GWA0KPj4+PiBkb2Vzbid0IHN1cHBvcnQgYXV0by1uZWdvdGlhdGlvbi4gSSBz
dXBwb3NlIEJNU1IgcmVwb3J0cyBhbmVnIGFzDQo+Pj4+IHN1cHBvcnRlZCwgdGhlcmVmb3JlIHBo
eWxpYiB3aWxsIHVzZSBhbmVnIHBlciBkZWZhdWx0Lg0KPj4+PiBOb3Qgc3VyZSB3aG8gY291bGQg
c2V0IDEwMEJhc2UtRlggbW9kZSB3aGVuLCBidXQgbWF5YmUgYXQgdGhhdCBwbGFjZQ0KPj4+PiBh
bHNvIHBoeWRldi0+YXV0b25lZyBuZWVkcyB0byBiZSBjbGVhcmVkLiBEaWQgeW91IHRlc3QgMTAw
QmFzZS1GWCBtb2RlPw0KPj4+DQo+Pj4gSSdtIGRvdWJ0aW5nIGlmIDEwMEJhc2UtRlggd29ya3Mu
IEJlc2lkZXMgYXV0by1uZWdvdGlhdGlvbiwgMTAwQmFzZS1GWCBDb250cm9sL1N0YXR1cyByZWdp
c3RlcnMgYXJlIGRlZmluZWQgaW4gc2hhZG93IHJlZ2lzdGVyIGluc3RlYWQgb2YgTUlJX0JNQ1Ig
YW5kIE1JSV9CTVNSLg0KPj4+DQo+Pj4gVW5mb3J0dW5hdGVseSBJIGRvbid0IGhhdmUgZW52aXJv
bm1lbnQgdG8gdGVzdCAxMDBCYXNlLUZYIGFuZCB0aGF0J3Mgd2h5IEkgb25seSBtYWtlIGNoYW5n
ZXMgd2hlbiB0aGUgUEhZIGlzIHdvcmtpbmcgaW4gMTAwMFggbW9kZS4NCj4+DQo+PiBJIGNhbiBw
cmVwYXJlIGEgcGF0Y2ggZm9yIDEwMEJhc2UtRlggYmFzZWQgb24gbXkgdW5kZXJzdGFuZGluZyBv
ZiBiY201NDYxNnMgZGF0YXNoZWV0LCBidXQgdGhlIHBhdGNoIHdvdWxkIGJlIGp1c3QgY29tcGls
ZS10ZXN0ZWQgDQo+Pg0KPiBTdXBwb3J0IGZvciAxMDAwQmFzZS1YIHNob3VsZCBiZSBzdWZmaWNp
ZW50LiBCZXN0IG1lbnRpb24gdGhlIG1pc3Npbmcgc3VwcG9ydCBmb3INCj4gMTAwQmFzZS1GWCBp
biB0aGUgY29tbWl0IG1lc3NhZ2UgYW5kIGF0IGEgc3VpdGVkIHBsYWNlIGluIHRoZSBkcml2ZXIg
Y29kZS4NCg0KTWFrZSBzZW5zZS4gV2lsbCBkbyBpdCBzb29uLg0KDQoNClRoYW5rcywNCg0KVGFv
DQo=
