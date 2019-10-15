Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A683D7D36
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 19:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730519AbfJORQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 13:16:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52296 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726277AbfJORQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 13:16:51 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9FH4ZbQ029680;
        Tue, 15 Oct 2019 10:16:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=qyWkK/Dq1quiJGlMeyUigbbCaiHeFz7tF0BrIAtAqUk=;
 b=gDe3bvmSvwXkNfllDOO8XCScKO+K9rRU+CL1QKHGo6/CPi8zJPjHbxFCsKwcX4Vx1ICH
 PppxQVFtuxAXUMnftW6NlGDj3wzlx0WqZZtVnunO0Ipi6yILHusEIAYt+AyPTF0pQC30
 dANZkIPaz4aiNbbYk42DNoe28xVlykZuWlE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vmtaje74m-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Oct 2019 10:16:27 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 10:16:27 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 15 Oct 2019 10:16:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kc0OzP4iVEaahBSMP6y+qiXSNC8faFJ2ltc/INPX3m0InqtCFc441AmCLZ6MbbSxZhWeWGwxl2qTJ6WJfTedeiFDLcWIime38JpJPQ+zWxP8GIrJ96iQ3RcBQopSG/wU6j5c7evIyHXZo6iYmSHAGJ4n/NrCxxgp/hV2raykRMVE2RzOyLyOWXMfsJDNyU4LDysFDYndHmoTg/ng98OWhcuxhqBaPvan7vwaA34CFGs5UH842asr0IIlQKG17DkC6OERhPiDIrd4SabGli0SxsqCEWk9OItK+FX6PiwAN9v9bgapkHEzAyeb7Ybe/x9YfiXLXRLgPbWUOYtZBhFYwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyWkK/Dq1quiJGlMeyUigbbCaiHeFz7tF0BrIAtAqUk=;
 b=JAUaNdWenr2fkgRV0P0mp5EeKx+uZUOYVMqgfVnDrQCS6JCl+rhw41xg1AAHFyfMRc5FATq2el0MFLXmaYKNkwaqccF1Wkc8HDILomNUolkvrmIMIij1RvZxiDzVde/RdRqU79tUaaWeSFwTr1Ev0psDHljxUwTP1OL0zk+iJUTVxbt5LNIDBToRPmpA726XQgR7jcPK64UlVJMF7V68+sZIID/BOdR+mNmeCLzu6jiZmi5Ec9Sx2H+DY0IVVFCE5FAmCWl7FKQ1FIBxTLnAktOWPNOVLsF4/l+8nYARZKWELJhrG2bb0Cv1OyHnEYeP9ezrRCeE38J8rsiZXAX1AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyWkK/Dq1quiJGlMeyUigbbCaiHeFz7tF0BrIAtAqUk=;
 b=k/zavtcIS8S/HcWr/e+UqP2esoFQTUUhiUk4WayzJgjv951UqGmeLX+LmQTodhQ4BGhGyJsGak+7S/S8jygGJNn99vyt0bOthdiTJispg9a5j+6fLmRX9TXo+DjLguGyOF035rjeXjK4pYO+QufZqyUvtLXbVnKdOb/1fofrFpg=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1455.namprd15.prod.outlook.com (10.173.234.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 15 Oct 2019 17:16:26 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::24c9:a1ce:eeeb:9246]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::24c9:a1ce:eeeb:9246%10]) with mapi id 15.20.2347.023; Tue, 15 Oct
 2019 17:16:26 +0000
From:   Tao Ren <taoren@fb.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v8 2/3] net: phy: add support for clause 37
 auto-negotiation
Thread-Topic: [PATCH net-next v8 2/3] net: phy: add support for clause 37
 auto-negotiation
Thread-Index: AQHVZ1Bi3JE3p3zeEkCydFApWQwsCKcrP8IAgDDqJoA=
Date:   Tue, 15 Oct 2019 17:16:26 +0000
Message-ID: <61e33434-c315-b80a-68bc-f0fe8f5029e7@fb.com>
References: <20190909204906.2191290-1-taoren@fb.com>
 <20190914141752.GC27922@lunn.ch>
In-Reply-To: <20190914141752.GC27922@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0043.namprd11.prod.outlook.com
 (2603:10b6:300:115::29) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:5adb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e13085c-34cc-4f08-9b3d-08d7519368ed
x-ms-traffictypediagnostic: MWHPR15MB1455:
x-microsoft-antispam-prvs: <MWHPR15MB14551E3A7A2BC164C257C66BB2930@MWHPR15MB1455.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(346002)(136003)(396003)(376002)(189003)(199004)(7736002)(186003)(305945005)(6436002)(11346002)(31686004)(71200400001)(6916009)(46003)(71190400001)(53546011)(6506007)(386003)(102836004)(6246003)(6512007)(8936002)(7416002)(2906002)(14454004)(446003)(86362001)(476003)(66446008)(64756008)(66556008)(66946007)(65806001)(478600001)(65956001)(6486002)(4326008)(66476007)(486006)(99286004)(256004)(6116002)(2616005)(76176011)(52116002)(36756003)(229853002)(81156014)(81166006)(8676002)(31696002)(25786009)(54906003)(316002)(5660300002)(4744005)(58126008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1455;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BBlb4bvU9dxUgh+R1ZVvwRnfNRNVMiOuIJt1zhnc5r5AdjfBnU5Qg50pG9xvMA093AZEjH8iaNXUm1xmtvrGzFe9ogGADnWQ8I7/v3nJZkI0UP6mTU6XuTo+tmMRO3+EVZtB5Y9+A6oj6O88bsyoAyzSjDNz30ibK44cKYIEZ4tkGmL1L+TU+xvum4TkCHwvOKRAbbz1TtrVr1P2ONx8rAZcgW15LeffW+FjOC/WUyuDswJC6dHVgaSgL7yDaG/3C/oJo3v4we7cg4zj90QhAkPtVQ+f+4Zf/zmQFx3k7M4rRSVEd75G2Nbw0js+es75DB4WDqMoOdQcsshkrDEW1FWW3Rlk/j4LRssiU4VqrcjqtfrKWArH+cCRmdrtk4w/avXL3OAEs8LvaUZZtnL4q/dwO9U4CLiecmTgaHo5Fbo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E73689495437C46B6B26A8885D1A147@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e13085c-34cc-4f08-9b3d-08d7519368ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 17:16:26.2387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gd4/EQVecEVEQ8WBGDvna7q+em79zd0e5lLh/taV8Z3uiM52fC0FVVhJgZz6g1Vs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1455
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-15_06:2019-10-15,2019-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 mlxlogscore=955 suspectscore=0 bulkscore=0 clxscore=1011 impostorscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910150147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCkNhbiB5b3UgcGxlYXNlIGFwcGx5IHRoZSBwYXRjaCBzZXJpZXMgdG8gbmV0
LW5leHQgdHJlZSB3aGVuIHlvdSBoYXZlIGJhbmR3aWR0aD8gQWxsIHRoZSAzIHBhdGNoZXMgYXJl
IHJldmlld2VkLg0KDQoNClRoYW5rcywNCg0KVGFvDQoNCk9uIDkvMTQvMTkgNzoxNyBBTSwgQW5k
cmV3IEx1bm4gd3JvdGU6DQo+IE9uIE1vbiwgU2VwIDA5LCAyMDE5IGF0IDAxOjQ5OjA2UE0gLTA3
MDAsIFRhbyBSZW4gd3JvdGU6DQo+PiBGcm9tOiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFA
Z21haWwuY29tPg0KPj4NCj4+IFRoaXMgcGF0Y2ggYWRkcyBzdXBwb3J0IGZvciBjbGF1c2UgMzcg
MTAwMEJhc2UtWCBhdXRvLW5lZ290aWF0aW9uLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEhlaW5l
ciBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBUYW8g
UmVuIDx0YW9yZW5AZmIuY29tPg0KPj4gVGVzdGVkLWJ5OiBSZW7DqSB2YW4gRG9yc3QgPG9wZW5z
b3VyY2VAdmRvcnN0LmNvbT4NCj4gDQo+IFJldmlld2VkLWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3
QGx1bm4uY2g+DQo+IA0KPiAgICAgQW5kcmV3DQo+IA0K
