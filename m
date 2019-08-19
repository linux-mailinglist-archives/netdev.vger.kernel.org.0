Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D07C49509D
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 00:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbfHSWSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 18:18:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17778 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728014AbfHSWSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 18:18:24 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7JMHqUx006306;
        Mon, 19 Aug 2019 15:18:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=OD7FuCh+1Qqz0gGIoRRUpSB+9QMTvI7MqaKyGgozLAQ=;
 b=HnZE4+rb83/Y1hBgJCjm062UyIJSvDc8P+p5SVzA3lbz4dyhWypuPou7uxsvkFED0jvb
 dbyHJpAqAR14u8/CfXz/7vCAQ5BRWJt6MYfD2mDQhqBK6J0Lu5lv1av58tQGmDbEDTue
 WIjjz9OLxxcBJKujr5d7ZqH/62G//H+flEY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ug45p82p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 19 Aug 2019 15:18:08 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 19 Aug 2019 15:18:08 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 19 Aug 2019 15:18:07 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 19 Aug 2019 15:18:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfQB8eBcwVAefnAzFTqkX28b6v06zf9413ZaeLlUG+jzF4meKoxJ65oXKR1V/PsKqqayZu2wwHcKbaiKzA/CehQ/miaOBeq5GAWMadEPKwoUpZDUax4SIyBRw1bUdLHF54EJVN2slDrwy9C9M/jED75XOaJVU1sM1/2TCATGqvtH6yQsdO+8rbImXGx4ER9sRUGnE9W0n5FaP3BJ6GCWGBOCM1JF8uxvwN+NertjdP8UyhJgnqLgUuU6hsSwkwOrMzKZCQCmyBgJ6Kqj57TXnEd3N4tTZJ8pfrSxyyNPUwyasw77And1ctVacSAjNq8jJ2MDmDotNUgJ+dG3XtX25Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OD7FuCh+1Qqz0gGIoRRUpSB+9QMTvI7MqaKyGgozLAQ=;
 b=F4lQg9jy6TE+8NDHx9In1fsnW8YYC5Z67xyRuFTz8VNxgQ4Z70hPYjTBddLFE/yGrStHpCT3QCfHcI1evhL85+fTSWT/9hg1XWV8LuFn4M8uqZO3QU7WyXBdfvHpj9WgH4wMuZJExOTzpNsQJdMNY4ZoMhFNcWzGrBlUVjzYgaiko8UHkDid+/7whGecRNzrG6j9Nwsg/ecGLK+SyVo6O33TcoqUWZCl9uv2MCZ/HkoSbowSeCjIdz/sI/QS0gh7e3jB/CLXo4gHmdM70iCUJ/bq1r8j67zLExluIzbWDA0HVi1UUBUHDo98Atl1X5szdummsRZz12ByK3zzQw4sqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OD7FuCh+1Qqz0gGIoRRUpSB+9QMTvI7MqaKyGgozLAQ=;
 b=VWiVsGDU41Taut4NJwunmswkZHjQrFm4Nh3hbnosBq/PNo1b5NqoT4zlWXuEuw8RWLftbgNNiW25rwqx1uJd2bxszmpp54CnNYNjgNKgXS06OxS0WvceoUit1s1OC/lI+Tn4kZ81K/nHdkpic9L8w+o2nFJLsLC5gSexKjmykps=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1535.namprd15.prod.outlook.com (10.173.234.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 19 Aug 2019 22:18:07 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 22:18:06 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v7 2/3] net: phy: add support for clause 37
 auto-negotiation
Thread-Topic: [PATCH net-next v7 2/3] net: phy: add support for clause 37
 auto-negotiation
Thread-Index: AQHVUJ5sDC2N3IVmSU23JGeEcwfh/acDFrMA
Date:   Mon, 19 Aug 2019 22:18:06 +0000
Message-ID: <3af5d897-7f97-a223-2d7b-56e09b83dcb5@fb.com>
References: <20190811234010.3673592-1-taoren@fb.com>
In-Reply-To: <20190811234010.3673592-1-taoren@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:301:39::36) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:cf6e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd81c9ea-4cb8-486c-0328-08d724f31c41
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1535;
x-ms-traffictypediagnostic: MWHPR15MB1535:
x-microsoft-antispam-prvs: <MWHPR15MB15350F7D170833EADB724C73B2A80@MWHPR15MB1535.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(346002)(136003)(376002)(39860400002)(199004)(189003)(6246003)(25786009)(76176011)(64756008)(66476007)(52116002)(6486002)(14454004)(66556008)(478600001)(66446008)(65826007)(53936002)(2906002)(6116002)(66946007)(229853002)(31686004)(6506007)(102836004)(386003)(53546011)(446003)(14444005)(5660300002)(31696002)(256004)(7736002)(2501003)(305945005)(65806001)(316002)(65956001)(2201001)(71190400001)(71200400001)(86362001)(64126003)(99286004)(186003)(486006)(81156014)(81166006)(110136005)(8676002)(8936002)(36756003)(6512007)(6436002)(11346002)(476003)(7416002)(58126008)(46003)(2616005)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1535;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ifXWbhg7cuDvHpgDNISOGUTT0T6YzL4AnBJFVV5BixcDoUJu9un0XzkVEVAr6dy+pjGDRIhjCcHEX/gWZnBwzXterQ64dNBkSt+6aGqKsbOjr3HES6e5C0gWqlTNKYZEh/6p7wEcxObD695dcf7RJa3jMv+wZgcj07fr1EMRV/YAA9S1/F1ko4s6szCKufr6ou5vSSlew1YYdq2px5hzvNNtSjzMUUPDT4cT0D6Vh8BANy2dcW42u9WFxxc18wQVpZXdFiE4UM8a9HmCple/P+RTHvN3wgHjljEGE1MbrYtuIutQU8+QqWdBOZZ9tXX5X0eTjOZqTajZuv/favcMiE3gvndZnNhJYf9fJ63j8AATZBtk5C/EbiDW9YuHPAvg6EmZHlE2txWQJKPJD8OLjykNVWdBdC812ZflX7HRJag=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <98D39938919260468B5ABC54AF8F97D6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bd81c9ea-4cb8-486c-0328-08d724f31c41
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 22:18:06.7819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xbEaxMf6qeUW1LcCTMZ/ecClvQMpP9qG7mumLBA86UlyahYDVNzoLhyP/VydqwkJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1535
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-19_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908190220
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8xMS8xOSA0OjQwIFBNLCBUYW8gUmVuIHdyb3RlOg0KPiBGcm9tOiBIZWluZXIgS2FsbHdl
aXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPg0KPiANCj4gVGhpcyBwYXRjaCBhZGRzIHN1cHBvcnQg
Zm9yIGNsYXVzZSAzNyAxMDAwQmFzZS1YIGF1dG8tbmVnb3RpYXRpb24uDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPg0KPiBTaWduZWQt
b2ZmLWJ5OiBUYW8gUmVuIDx0YW9yZW5AZmIuY29tPg0KDQpBIGtpbmQgcmVtaW5kZXI6IGNvdWxk
IHNvbWVvbmUgaGVscCB0byByZXZpZXcgdGhlIHBhdGNoIHdoZW4geW91IGhhdmUgYmFuZHdpZHRo
Pw0KDQoNCkNoZWVycywNCg0KVGFvDQoNCj4gLS0tDQo+ICBDaGFuZ2VzIGluIHY3Og0KPiAgIC0g
VXBkYXRlICJpZiAoQVVUT05FR19FTkFCTEUgIT0gcGh5ZGV2LT5hdXRvbmVnKSIgdG8NCj4gICAg
ICJpZiAocGh5ZGV2LT5hdXRvbmVnICE9IEFVVE9ORUdfRU5BQkxFKSIgc28gY2hlY2twYXRjaC5w
bCBpcyBoYXBweS4NCj4gIENoYW5nZXMgaW4gdjY6DQo+ICAgLSBhZGQgIlNpZ25lZC1vZmYtYnk6
IFRhbyBSZW4gPHRhb3JlbkBmYi5jb20+Ig0KPiAgQ2hhbmdlcyBpbiB2MS12NToNCj4gICAtIG5v
dGhpbmcgY2hhbmdlZC4gSXQncyBnaXZlbiB2NSBqdXN0IHRvIGFsaWduIHdpdGggdGhlIHZlcnNp
b24gb2YNCj4gICAgIHBhdGNoIHNlcmllcy4NCj4gDQo+ICBkcml2ZXJzL25ldC9waHkvcGh5X2Rl
dmljZS5jIHwgMTM5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICBpbmNs
dWRlL2xpbnV4L3BoeS5oICAgICAgICAgIHwgICA1ICsrDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDE0
NCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L3BoeV9k
ZXZpY2UuYyBiL2RyaXZlcnMvbmV0L3BoeS9waHlfZGV2aWNlLmMNCj4gaW5kZXggMjUyYTcxMmQx
YjJiLi4zMDFhNzk0YjI5NjMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9waHlfZGV2
aWNlLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvcGh5L3BoeV9kZXZpY2UuYw0KPiBAQCAtMTYxNyw2
ICsxNjE3LDQwIEBAIHN0YXRpYyBpbnQgZ2VucGh5X2NvbmZpZ19hZHZlcnQoc3RydWN0IHBoeV9k
ZXZpY2UgKnBoeWRldikNCj4gIAlyZXR1cm4gY2hhbmdlZDsNCj4gIH0NCj4gIA0KPiArLyoqDQo+
ICsgKiBnZW5waHlfYzM3X2NvbmZpZ19hZHZlcnQgLSBzYW5pdGl6ZSBhbmQgYWR2ZXJ0aXNlIGF1
dG8tbmVnb3RpYXRpb24gcGFyYW1ldGVycw0KPiArICogQHBoeWRldjogdGFyZ2V0IHBoeV9kZXZp
Y2Ugc3RydWN0DQo+ICsgKg0KPiArICogRGVzY3JpcHRpb246IFdyaXRlcyBNSUlfQURWRVJUSVNF
IHdpdGggdGhlIGFwcHJvcHJpYXRlIHZhbHVlcywNCj4gKyAqICAgYWZ0ZXIgc2FuaXRpemluZyB0
aGUgdmFsdWVzIHRvIG1ha2Ugc3VyZSB3ZSBvbmx5IGFkdmVydGlzZQ0KPiArICogICB3aGF0IGlz
IHN1cHBvcnRlZC4gIFJldHVybnMgPCAwIG9uIGVycm9yLCAwIGlmIHRoZSBQSFkncyBhZHZlcnRp
c2VtZW50DQo+ICsgKiAgIGhhc24ndCBjaGFuZ2VkLCBhbmQgPiAwIGlmIGl0IGhhcyBjaGFuZ2Vk
LiBUaGlzIGZ1bmN0aW9uIGlzIGludGVuZGVkDQo+ICsgKiAgIGZvciBDbGF1c2UgMzcgMTAwMEJh
c2UtWCBtb2RlLg0KPiArICovDQo+ICtzdGF0aWMgaW50IGdlbnBoeV9jMzdfY29uZmlnX2FkdmVy
dChzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPiArew0KPiArCXUxNiBhZHYgPSAwOw0KPiAr
DQo+ICsJLyogT25seSBhbGxvdyBhZHZlcnRpc2luZyB3aGF0IHRoaXMgUEhZIHN1cHBvcnRzICov
DQo+ICsJbGlua21vZGVfYW5kKHBoeWRldi0+YWR2ZXJ0aXNpbmcsIHBoeWRldi0+YWR2ZXJ0aXNp
bmcsDQo+ICsJCSAgICAgcGh5ZGV2LT5zdXBwb3J0ZWQpOw0KPiArDQo+ICsJaWYgKGxpbmttb2Rl
X3Rlc3RfYml0KEVUSFRPT0xfTElOS19NT0RFXzEwMDBiYXNlWF9GdWxsX0JJVCwNCj4gKwkJCSAg
ICAgIHBoeWRldi0+YWR2ZXJ0aXNpbmcpKQ0KPiArCQlhZHYgfD0gQURWRVJUSVNFXzEwMDBYRlVM
TDsNCj4gKwlpZiAobGlua21vZGVfdGVzdF9iaXQoRVRIVE9PTF9MSU5LX01PREVfUGF1c2VfQklU
LA0KPiArCQkJICAgICAgcGh5ZGV2LT5hZHZlcnRpc2luZykpDQo+ICsJCWFkdiB8PSBBRFZFUlRJ
U0VfMTAwMFhQQVVTRTsNCj4gKwlpZiAobGlua21vZGVfdGVzdF9iaXQoRVRIVE9PTF9MSU5LX01P
REVfQXN5bV9QYXVzZV9CSVQsDQo+ICsJCQkgICAgICBwaHlkZXYtPmFkdmVydGlzaW5nKSkNCj4g
KwkJYWR2IHw9IEFEVkVSVElTRV8xMDAwWFBTRV9BU1lNOw0KPiArDQo+ICsJcmV0dXJuIHBoeV9t
b2RpZnlfY2hhbmdlZChwaHlkZXYsIE1JSV9BRFZFUlRJU0UsDQo+ICsJCQkJICBBRFZFUlRJU0Vf
MTAwMFhGVUxMIHwgQURWRVJUSVNFXzEwMDBYUEFVU0UgfA0KPiArCQkJCSAgQURWRVJUSVNFXzEw
MDBYSEFMRiB8IEFEVkVSVElTRV8xMDAwWFBTRV9BU1lNLA0KPiArCQkJCSAgYWR2KTsNCj4gK30N
Cj4gKw0KPiAgLyoqDQo+ICAgKiBnZW5waHlfY29uZmlnX2VlZV9hZHZlcnQgLSBkaXNhYmxlIHVu
d2FudGVkIGVlZSBtb2RlIGFkdmVydGlzZW1lbnQNCj4gICAqIEBwaHlkZXY6IHRhcmdldCBwaHlf
ZGV2aWNlIHN0cnVjdA0KPiBAQCAtMTcyNiw2ICsxNzYwLDU0IEBAIGludCBnZW5waHlfY29uZmln
X2FuZWcoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4gIH0NCj4gIEVYUE9SVF9TWU1CT0wo
Z2VucGh5X2NvbmZpZ19hbmVnKTsNCj4gIA0KPiArLyoqDQo+ICsgKiBnZW5waHlfYzM3X2NvbmZp
Z19hbmVnIC0gcmVzdGFydCBhdXRvLW5lZ290aWF0aW9uIG9yIHdyaXRlIEJNQ1INCj4gKyAqIEBw
aHlkZXY6IHRhcmdldCBwaHlfZGV2aWNlIHN0cnVjdA0KPiArICoNCj4gKyAqIERlc2NyaXB0aW9u
OiBJZiBhdXRvLW5lZ290aWF0aW9uIGlzIGVuYWJsZWQsIHdlIGNvbmZpZ3VyZSB0aGUNCj4gKyAq
ICAgYWR2ZXJ0aXNpbmcsIGFuZCB0aGVuIHJlc3RhcnQgYXV0by1uZWdvdGlhdGlvbi4gIElmIGl0
IGlzIG5vdA0KPiArICogICBlbmFibGVkLCB0aGVuIHdlIHdyaXRlIHRoZSBCTUNSLiBUaGlzIGZ1
bmN0aW9uIGlzIGludGVuZGVkDQo+ICsgKiAgIGZvciB1c2Ugd2l0aCBDbGF1c2UgMzcgMTAwMEJh
c2UtWCBtb2RlLg0KPiArICovDQo+ICtpbnQgZ2VucGh5X2MzN19jb25maWdfYW5lZyhzdHJ1Y3Qg
cGh5X2RldmljZSAqcGh5ZGV2KQ0KPiArew0KPiArCWludCBlcnIsIGNoYW5nZWQ7DQo+ICsNCj4g
KwlpZiAocGh5ZGV2LT5hdXRvbmVnICE9IEFVVE9ORUdfRU5BQkxFKQ0KPiArCQlyZXR1cm4gZ2Vu
cGh5X3NldHVwX2ZvcmNlZChwaHlkZXYpOw0KPiArDQo+ICsJZXJyID0gcGh5X21vZGlmeShwaHlk
ZXYsIE1JSV9CTUNSLCBCTUNSX1NQRUVEMTAwMCB8IEJNQ1JfU1BFRUQxMDAsDQo+ICsJCQkgQk1D
Ul9TUEVFRDEwMDApOw0KPiArCWlmIChlcnIpDQo+ICsJCXJldHVybiBlcnI7DQo+ICsNCj4gKwlj
aGFuZ2VkID0gZ2VucGh5X2MzN19jb25maWdfYWR2ZXJ0KHBoeWRldik7DQo+ICsJaWYgKGNoYW5n
ZWQgPCAwKSAvKiBlcnJvciAqLw0KPiArCQlyZXR1cm4gY2hhbmdlZDsNCj4gKw0KPiArCWlmICgh
Y2hhbmdlZCkgew0KPiArCQkvKiBBZHZlcnRpc2VtZW50IGhhc24ndCBjaGFuZ2VkLCBidXQgbWF5
YmUgYW5lZyB3YXMgbmV2ZXIgb24gdG8NCj4gKwkJICogYmVnaW4gd2l0aD8gIE9yIG1heWJlIHBo
eSB3YXMgaXNvbGF0ZWQ/DQo+ICsJCSAqLw0KPiArCQlpbnQgY3RsID0gcGh5X3JlYWQocGh5ZGV2
LCBNSUlfQk1DUik7DQo+ICsNCj4gKwkJaWYgKGN0bCA8IDApDQo+ICsJCQlyZXR1cm4gY3RsOw0K
PiArDQo+ICsJCWlmICghKGN0bCAmIEJNQ1JfQU5FTkFCTEUpIHx8IChjdGwgJiBCTUNSX0lTT0xB
VEUpKQ0KPiArCQkJY2hhbmdlZCA9IDE7IC8qIGRvIHJlc3RhcnQgYW5lZyAqLw0KPiArCX0NCj4g
Kw0KPiArCS8qIE9ubHkgcmVzdGFydCBhbmVnIGlmIHdlIGFyZSBhZHZlcnRpc2luZyBzb21ldGhp
bmcgZGlmZmVyZW50DQo+ICsJICogdGhhbiB3ZSB3ZXJlIGJlZm9yZS4NCj4gKwkgKi8NCj4gKwlp
ZiAoY2hhbmdlZCA+IDApDQo+ICsJCXJldHVybiBnZW5waHlfcmVzdGFydF9hbmVnKHBoeWRldik7
DQo+ICsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gK0VYUE9SVF9TWU1CT0woZ2VucGh5X2MzN19j
b25maWdfYW5lZyk7DQo+ICsNCj4gIC8qKg0KPiAgICogZ2VucGh5X2FuZWdfZG9uZSAtIHJldHVy
biBhdXRvLW5lZ290aWF0aW9uIHN0YXR1cw0KPiAgICogQHBoeWRldjogdGFyZ2V0IHBoeV9kZXZp
Y2Ugc3RydWN0DQo+IEBAIC0xODY0LDYgKzE5NDYsNjMgQEAgaW50IGdlbnBoeV9yZWFkX3N0YXR1
cyhzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPiAgfQ0KPiAgRVhQT1JUX1NZTUJPTChnZW5w
aHlfcmVhZF9zdGF0dXMpOw0KPiAgDQo+ICsvKioNCj4gKyAqIGdlbnBoeV9jMzdfcmVhZF9zdGF0
dXMgLSBjaGVjayB0aGUgbGluayBzdGF0dXMgYW5kIHVwZGF0ZSBjdXJyZW50IGxpbmsgc3RhdGUN
Cj4gKyAqIEBwaHlkZXY6IHRhcmdldCBwaHlfZGV2aWNlIHN0cnVjdA0KPiArICoNCj4gKyAqIERl
c2NyaXB0aW9uOiBDaGVjayB0aGUgbGluaywgdGhlbiBmaWd1cmUgb3V0IHRoZSBjdXJyZW50IHN0
YXRlDQo+ICsgKiAgIGJ5IGNvbXBhcmluZyB3aGF0IHdlIGFkdmVydGlzZSB3aXRoIHdoYXQgdGhl
IGxpbmsgcGFydG5lcg0KPiArICogICBhZHZlcnRpc2VzLiBUaGlzIGZ1bmN0aW9uIGlzIGZvciBD
bGF1c2UgMzcgMTAwMEJhc2UtWCBtb2RlLg0KPiArICovDQo+ICtpbnQgZ2VucGh5X2MzN19yZWFk
X3N0YXR1cyhzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPiArew0KPiArCWludCBscGEsIGVy
ciwgb2xkX2xpbmsgPSBwaHlkZXYtPmxpbms7DQo+ICsNCj4gKwkvKiBVcGRhdGUgdGhlIGxpbmss
IGJ1dCByZXR1cm4gaWYgdGhlcmUgd2FzIGFuIGVycm9yICovDQo+ICsJZXJyID0gZ2VucGh5X3Vw
ZGF0ZV9saW5rKHBoeWRldik7DQo+ICsJaWYgKGVycikNCj4gKwkJcmV0dXJuIGVycjsNCj4gKw0K
PiArCS8qIHdoeSBib3RoZXIgdGhlIFBIWSBpZiBub3RoaW5nIGNhbiBoYXZlIGNoYW5nZWQgKi8N
Cj4gKwlpZiAocGh5ZGV2LT5hdXRvbmVnID09IEFVVE9ORUdfRU5BQkxFICYmIG9sZF9saW5rICYm
IHBoeWRldi0+bGluaykNCj4gKwkJcmV0dXJuIDA7DQo+ICsNCj4gKwlwaHlkZXYtPmR1cGxleCA9
IERVUExFWF9VTktOT1dOOw0KPiArCXBoeWRldi0+cGF1c2UgPSAwOw0KPiArCXBoeWRldi0+YXN5
bV9wYXVzZSA9IDA7DQo+ICsNCj4gKwlpZiAocGh5ZGV2LT5hdXRvbmVnID09IEFVVE9ORUdfRU5B
QkxFICYmIHBoeWRldi0+YXV0b25lZ19jb21wbGV0ZSkgew0KPiArCQlscGEgPSBwaHlfcmVhZChw
aHlkZXYsIE1JSV9MUEEpOw0KPiArCQlpZiAobHBhIDwgMCkNCj4gKwkJCXJldHVybiBscGE7DQo+
ICsNCj4gKwkJbGlua21vZGVfbW9kX2JpdChFVEhUT09MX0xJTktfTU9ERV9BdXRvbmVnX0JJVCwN
Cj4gKwkJCQkgcGh5ZGV2LT5scF9hZHZlcnRpc2luZywgbHBhICYgTFBBX0xQQUNLKTsNCj4gKwkJ
bGlua21vZGVfbW9kX2JpdChFVEhUT09MX0xJTktfTU9ERV8xMDAwYmFzZVhfRnVsbF9CSVQsDQo+
ICsJCQkJIHBoeWRldi0+bHBfYWR2ZXJ0aXNpbmcsIGxwYSAmIExQQV8xMDAwWEZVTEwpOw0KPiAr
CQlsaW5rbW9kZV9tb2RfYml0KEVUSFRPT0xfTElOS19NT0RFX1BhdXNlX0JJVCwNCj4gKwkJCQkg
cGh5ZGV2LT5scF9hZHZlcnRpc2luZywgbHBhICYgTFBBXzEwMDBYUEFVU0UpOw0KPiArCQlsaW5r
bW9kZV9tb2RfYml0KEVUSFRPT0xfTElOS19NT0RFX0FzeW1fUGF1c2VfQklULA0KPiArCQkJCSBw
aHlkZXYtPmxwX2FkdmVydGlzaW5nLA0KPiArCQkJCSBscGEgJiBMUEFfMTAwMFhQQVVTRV9BU1lN
KTsNCj4gKw0KPiArCQlwaHlfcmVzb2x2ZV9hbmVnX2xpbmttb2RlKHBoeWRldik7DQo+ICsJfSBl
bHNlIGlmIChwaHlkZXYtPmF1dG9uZWcgPT0gQVVUT05FR19ESVNBQkxFKSB7DQo+ICsJCWludCBi
bWNyID0gcGh5X3JlYWQocGh5ZGV2LCBNSUlfQk1DUik7DQo+ICsNCj4gKwkJaWYgKGJtY3IgPCAw
KQ0KPiArCQkJcmV0dXJuIGJtY3I7DQo+ICsNCj4gKwkJaWYgKGJtY3IgJiBCTUNSX0ZVTExEUExY
KQ0KPiArCQkJcGh5ZGV2LT5kdXBsZXggPSBEVVBMRVhfRlVMTDsNCj4gKwkJZWxzZQ0KPiArCQkJ
cGh5ZGV2LT5kdXBsZXggPSBEVVBMRVhfSEFMRjsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gMDsN
Cj4gK30NCj4gK0VYUE9SVF9TWU1CT0woZ2VucGh5X2MzN19yZWFkX3N0YXR1cyk7DQo+ICsNCj4g
IC8qKg0KPiAgICogZ2VucGh5X3NvZnRfcmVzZXQgLSBzb2Z0d2FyZSByZXNldCB0aGUgUEhZIHZp
YSBCTUNSX1JFU0VUIGJpdA0KPiAgICogQHBoeWRldjogdGFyZ2V0IHBoeV9kZXZpY2Ugc3RydWN0
DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3BoeS5oIGIvaW5jbHVkZS9saW51eC9waHku
aA0KPiBpbmRleCA0NjJiOTBiNzNmOTMuLjgxYTI5MjE1MTJlZSAxMDA2NDQNCj4gLS0tIGEvaW5j
bHVkZS9saW51eC9waHkuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L3BoeS5oDQo+IEBAIC0xMDc3
LDYgKzEwNzcsMTEgQEAgaW50IGdlbnBoeV9zdXNwZW5kKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlk
ZXYpOw0KPiAgaW50IGdlbnBoeV9yZXN1bWUoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldik7DQo+
ICBpbnQgZ2VucGh5X2xvb3BiYWNrKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYsIGJvb2wgZW5h
YmxlKTsNCj4gIGludCBnZW5waHlfc29mdF9yZXNldChzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2
KTsNCj4gKw0KPiArLyogQ2xhdXNlIDM3ICovDQo+ICtpbnQgZ2VucGh5X2MzN19jb25maWdfYW5l
ZyhzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KTsNCj4gK2ludCBnZW5waHlfYzM3X3JlYWRfc3Rh
dHVzKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpOw0KPiArDQo+ICBzdGF0aWMgaW5saW5lIGlu
dCBnZW5waHlfbm9fc29mdF9yZXNldChzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPiAgew0K
PiAgCXJldHVybiAwOw0KPiANCg==
