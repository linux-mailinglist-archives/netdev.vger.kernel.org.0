Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABCFD7DA5
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 19:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388709AbfJORZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 13:25:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10272 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727242AbfJORZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 13:25:50 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9FHNp8s011838;
        Tue, 15 Oct 2019 10:25:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=LKG6iNPY+gQ0bzHcnuka56MjystcRZbrHfaLuqpZDPc=;
 b=R6epf84EpJ1YV2RNqPsL6N+596olhSBQoom3o9VdkR6LmBYlNlHWp3ccJ1OkMd4XwDhv
 c7PpAf7inHdLXBv+gbq+VJCt6KANknKTLl+w4Qlpv2yzkGFyX35ZfHYr9k4Dqq890YkO
 AjnKncGlpFxAVijAw9Lv7LPqy1OY6jWXYy4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vky52k2ba-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 15 Oct 2019 10:25:41 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 15 Oct 2019 10:25:41 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 15 Oct 2019 10:25:40 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 15 Oct 2019 10:25:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XgYzK2GL3EnbW86wyUSNXAk619WDaJBeKMEcsC1iMWZ/q+MAWpXTxipxMxx7BryrkInrio06/kWvcdj0678sqYBQMfUxcaMLAD4HDEaWLLqC0yjrSnncHLazC1lRYXfZnzdq3NatNrr2r+ftjTuq8NxanIAhlJWIoJJCE2tS7AS9q570y4kerETQd5CVSgsEO8s0i7H08EOMo368ft5y+MWLmaQZkISq/dFEDC1b8kfGDrbXIo/KesB2+FB1kW+FA2HIV8vZXwDSuSjhDtoumluqrSBt75iyqDsZDn7T2VKkX/8mdZ1ncvjQTznHAdYJI7jrwdsZeaFNPA/WB5sYoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKG6iNPY+gQ0bzHcnuka56MjystcRZbrHfaLuqpZDPc=;
 b=gZ9PeHVEGq5Pk7C5zQND/+4jQeoBxqVYVzhYOVNQhFDzQ3L3OQZk3xnrJNiGW4qNE8zWvttY76/d9eawffy3KQyYdzTmTu98v1bAbCcwAW7j6L6hjCWKcOJ4H/ij1AT4axnN4HwyCd0QKLILPcYe3b2/RKSTRh1igXBENjzRNqNVicnk7Vr/iy5g1QmQKd+q8DUW9NyJbkHbgbsQfmLbZLv2yhlxUOVsBNI4DrrK+jGCwqb259GjR7hqQVRSesJil2uyGCmbwmWAcmeY9kz9A7Fkdc1eKDPyo4nHZOWbECiuOwOi9VM4aVgkDg6Y0etTDFue9BV1ozE8DLkDe99+vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKG6iNPY+gQ0bzHcnuka56MjystcRZbrHfaLuqpZDPc=;
 b=fcOlSbxhx6bhJ12ar9w6lvW5t/p6vtGWwI7QI1CPePUCZlbGk1BG6Mt6o8S9C7k8nIHeFtU2Aw9DJUl6pv39YE3yyKQOM+8kGDVSEr2yDtrJeqy4+5vgv6OYVw94oTxAmHzqxQdskyo1sz9BnRQh80gspBF50eZ7VdK4hQ2sLfA=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1694.namprd15.prod.outlook.com (10.175.141.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 15 Oct 2019 17:25:40 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::24c9:a1ce:eeeb:9246]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::24c9:a1ce:eeeb:9246%10]) with mapi id 15.20.2347.023; Tue, 15 Oct
 2019 17:25:40 +0000
From:   Tao Ren <taoren@fb.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arun.parameswaran@broadcom.com" <arun.parameswaran@broadcom.com>,
        "justinpopo6@gmail.com" <justinpopo6@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v8 2/3] net: phy: add support for clause 37
 auto-negotiation
Thread-Topic: [PATCH net-next v8 2/3] net: phy: add support for clause 37
 auto-negotiation
Thread-Index: AQHVZ1Bi3JE3p3zeEkCydFApWQwsCKcrP8IAgDB0zoCAAHZqgIAAAMUAgAAAvoA=
Date:   Tue, 15 Oct 2019 17:25:40 +0000
Message-ID: <b6cc685b-cb20-1b6f-21b9-ae0a330a28a1@fb.com>
References: <20190909204906.2191290-1-taoren@fb.com>
 <20190914141752.GC27922@lunn.ch>
 <61e33434-c315-b80a-68bc-f0fe8f5029e7@fb.com>
 <20191015.132013.246221433893437093.davem@davemloft.net>
 <a940d709-65ec-32c7-7181-83da0872acd1@gmail.com>
In-Reply-To: <a940d709-65ec-32c7-7181-83da0872acd1@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0166.namprd04.prod.outlook.com
 (2603:10b6:104:4::20) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:5adb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87689452-40c1-4ed7-0a61-08d75194b32d
x-ms-traffictypediagnostic: MWHPR15MB1694:
x-microsoft-antispam-prvs: <MWHPR15MB169439F6C5F4CD08CC2D2FBBB2930@MWHPR15MB1694.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(376002)(346002)(39860400002)(189003)(199004)(65806001)(446003)(5660300002)(6486002)(65956001)(186003)(31696002)(2616005)(46003)(11346002)(486006)(76176011)(99286004)(229853002)(52116002)(102836004)(53546011)(6506007)(386003)(476003)(6116002)(478600001)(6246003)(86362001)(8936002)(14454004)(7416002)(4326008)(31686004)(2906002)(7736002)(305945005)(25786009)(6512007)(8676002)(54906003)(110136005)(58126008)(4744005)(6436002)(66556008)(316002)(71200400001)(36756003)(71190400001)(256004)(66946007)(81166006)(81156014)(64756008)(66476007)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1694;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zouiC3fXeHQXSQVMBgGyTff9/VFgssiaFAC5DHtgYJGnGhDT5HSx9G7qB29/oRioL2Qrwr53DI2pNshWpSUWQRsLZ2cODBCLI8GV6l5+bP+qgkr33bR5RLCgvAVabTSaa1Ay3prRvMc4KnXN4uk9DuIn4ylCVG9Yv0WAeAJw6n5uCbaagZqAx6ILt5Ub4U+FRmkKA9j26Nz1laIGaNoi4ZlVJUuoWTNCWxJ4OU3E8cKs9u9Ae66nLYLWAGrtsaKCFWmEvPolnNLN82w9wcitbPEw1c/CfUUZP7bBNiYH9nkBUfFDuAs+pZPNOinmEtJtxR4hHUR7MtabmyuStP1TmGVxFSIvwZ2ZFOF/6eCtDTBGyjFVxq5GKd/ewMq71J0hA2c3tqr9iBlkSEwzwklnl6ssptGF9JjbEe1ldRPyGi0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <69BBC53629E78544986562A2266D69D9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 87689452-40c1-4ed7-0a61-08d75194b32d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 17:25:40.0906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 46ZSihSKIkN1b6FCTCplO5IstII7o/gS/jrI3cQPWA6J70BTEec1B7tcTzMSCsSk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1694
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-15_06:2019-10-15,2019-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910150149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTUvMTkgMTA6MjIgQU0sIEZsb3JpYW4gRmFpbmVsbGkgd3JvdGU6DQo+IE9uIDEwLzE1
LzE5IDEwOjIwIEFNLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+PiBGcm9tOiBUYW8gUmVuIDx0YW9y
ZW5AZmIuY29tPg0KPj4gRGF0ZTogVHVlLCAxNSBPY3QgMjAxOSAxNzoxNjoyNiArMDAwMA0KPj4N
Cj4+PiBDYW4geW91IHBsZWFzZSBhcHBseSB0aGUgcGF0Y2ggc2VyaWVzIHRvIG5ldC1uZXh0IHRy
ZWUgd2hlbiB5b3UgaGF2ZQ0KPj4+IGJhbmR3aWR0aD8gQWxsIHRoZSAzIHBhdGNoZXMgYXJlIHJl
dmlld2VkLg0KPj4NCj4+IElmIGl0IGlzIG5vdCBhY3RpdmUgaW4gcGF0Y2h3b3JrIHlvdSBuZWVk
IHRvIHJlcG9zdC4NCj4+DQo+IA0KPiBUYW8sIGNhbiB5b3UgcGljayB1cCB0aGlzIHNlcmllcyBh
bmQgcHJvdmlkZSBhIHByb3BlciBjb3ZlciBsZXR0ZXIgZm9yDQo+IGl0IChnaXQgZm9ybWF0LXBh
dGNoIC0tY292ZXItbGV0dGVyKSB0aGF0IHdheSBpdCBjYW4gYmUgcGlja2VkIHVwIGJ5IERhdmlk
Pw0KDQpTdXJlLiBUaGFuayB5b3UgZm9yIHRoZSBzdWdnZXN0aW9uLiBXaWxsIGRvIGl0Lg0KDQoN
ClRoYW5rcywNCg0KVGFvDQo=
