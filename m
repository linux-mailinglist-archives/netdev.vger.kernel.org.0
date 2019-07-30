Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683747A03B
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 07:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfG3FFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 01:05:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7302 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729058AbfG3FFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 01:05:52 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6U55JLF018690;
        Mon, 29 Jul 2019 22:05:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ipNS/0NtnHM4V5e2HdohyyK76azqaznMzf+z4JM/4Tw=;
 b=gbJ3r4ESt6b1RxkiP/c9LUlqHX0aYTET+tpMtrC4aDV0O7Cr4r05rgXcXLhs8E11QooE
 brRaKAndLeMUeTUgZ+LzyW6R1tNVH9N1H9hhEBYiZemEZAnSdUjzPc4WgrY84sDlSd03
 yH3N5a6yehTVr7VWGsnZfGJnryJeMCW0IG8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u285asab1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Jul 2019 22:05:39 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Jul 2019 22:05:37 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Jul 2019 22:05:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zv4c28OP5yhOrGMA0iTfsR1mx6+iR8uepJyCTrYDNvnh6ZrmyZsaLsD9kEqgxIN/llOb0CEI0j5wQQjc7016XV0iq6ymPEP5WVASrudd5mvkeZco2CkpE3eu3xFb91DvRNlKEvI+neCtPqF86G6qCgr9nqetrqkuDsT2MgpEjW7olQprGPueSlEo875MO7XPouy0b4/l33H1xAOvSAGXsFIhvMZYRdcNJ5Fo6WgvJ5OHV2+E871Fo67zbwMwQmRqB6l8LiHO8umYUkFPxkJMiIJKL1WSF+cyVylPhfE9mnnO3Nr8MeMMzxEdJmKmYEjKvc0qfrS/mM0gFBeR+z1sBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipNS/0NtnHM4V5e2HdohyyK76azqaznMzf+z4JM/4Tw=;
 b=Xb77gM35n0eq0cnu9kH+9hkoAtTbey0Mdd0i7RJ5tlF2PLuvuvHFpPdxWtv43iIrZ6FmnvNv0U6bgCvQuVKAdmrufX4dT1TtNsduicSmvg36546IXIUxT0f7/Bh1rOf0eDJ+d454iGYSaEAy1RPpFwtPkwYDp6Z63kBAB2P3vP1FlsV8rAL2vwpFW9MSOM9gpNWgwizo8X0uQMUwLHatgIm35shlnrRdBt1YsVmDdlTC7xQwmznZmzfGTJkId8RnoyYNSbHWI3sGqY7fhGxpBfOXRCr6CtgHzEV3Y9641HTjQv3b0SY1bNzgy72wUFaN+xJJX3qhwQ4VLFMQajdL9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipNS/0NtnHM4V5e2HdohyyK76azqaznMzf+z4JM/4Tw=;
 b=B5SgRGSaexrMBPZIjRimRM+VDptjQLnK5uRGrmgjU1nWydBdMIEa8s77GM62HRj9zIuIMCBbHXIDkNe/9N4gY4zkCM2SlSuvsLHkdTgDgDI1yGDRj2nJ4vL/G+Rndb5Fu8XFKyGqSylRByHHLbS19ssHPKrzgeQpbG0f6RdNMF4=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1326.namprd15.prod.outlook.com (10.175.4.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 05:05:36 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c%8]) with mapi id 15.20.2136.010; Tue, 30 Jul 2019
 05:05:36 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Arun Parameswaran" <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next 1/2] net: phy: broadcom: set features explicitly
 for BCM54616S
Thread-Topic: [PATCH net-next 1/2] net: phy: broadcom: set features explicitly
 for BCM54616S
Thread-Index: AQHVRm4tZSvvLl002ECU4Omi5U5C86bigvAAgAAZCIA=
Date:   Tue, 30 Jul 2019 05:05:35 +0000
Message-ID: <aff2728d-5db1-50fd-767c-29b355890323@fb.com>
References: <20190730002532.85509-1-taoren@fb.com>
 <20190730033558.GB20628@lunn.ch>
In-Reply-To: <20190730033558.GB20628@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0021.namprd19.prod.outlook.com
 (2603:10b6:300:d4::31) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:a8ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c301771e-0780-42dd-3c02-08d714ab8e7b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1326;
x-ms-traffictypediagnostic: MWHPR15MB1326:
x-microsoft-antispam-prvs: <MWHPR15MB13265CEEE1E8ECB80721A6BAB2DC0@MWHPR15MB1326.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(376002)(396003)(346002)(366004)(199004)(189003)(99286004)(66476007)(14454004)(66946007)(66556008)(4744005)(65806001)(478600001)(31696002)(305945005)(6512007)(64126003)(5660300002)(66446008)(68736007)(86362001)(25786009)(65956001)(4326008)(6246003)(46003)(71200400001)(8936002)(7416002)(8676002)(65826007)(186003)(58126008)(256004)(386003)(6506007)(2906002)(81156014)(81166006)(102836004)(53546011)(52116002)(53936002)(486006)(76176011)(2616005)(11346002)(64756008)(7736002)(446003)(71190400001)(6436002)(54906003)(31686004)(6116002)(229853002)(6486002)(476003)(36756003)(316002)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1326;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: W2ey1eVRP9iFhoLVuno9tdLe1XBKJtTRiSq3rEKEo/WIUh7wfgwD8VAY4mEgcuW8uU6n/kiPKUeePWkueLMLZdxVvDm1UqoPh60FT73rbNsvabXUkCS5L/zuy9ci7jFPwwkdU3d9htH/ZlfqzGsxKpyWS99TwcRUKIv/nBmxOiD6w2xUzNFq7vrwny7/KyAwKxW0CTcyPitTC9Lh5ue+K179z3nHPxq42D0hvMpYlWkj1ZPScLr5RimiL+d09zBuN+AUadO3ufJ8SUV4Vv+U1IqITvShmM1xMAOXSyhWNydPTynsJgBzBcVBzlvSMUeoq8RDss5KCzMN1ALKebArHuZjBSVv6Ccwml+wAusSVsXqCMGCuMDU3ZeNOThtYU+6S4jjQrHQyjOQAfQoGLQLVhnQAFVr8NGnX+qM3sTMsb4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6446B98D09BE5A419A465CBF65FB6773@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c301771e-0780-42dd-3c02-08d714ab8e7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 05:05:36.0019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: taoren@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1326
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=783 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300053
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8yOS8xOSA4OjM1IFBNLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gT24gTW9uLCBKdWwgMjks
IDIwMTkgYXQgMDU6MjU6MzJQTSAtMDcwMCwgVGFvIFJlbiB3cm90ZToNCj4+IEJDTTU0NjE2UyBm
ZWF0dXJlICJQSFlfR0JJVF9GRUFUVVJFUyIgd2FzIHJlbW92ZWQgYnkgY29tbWl0IGRjZGVjZGNm
ZTFmYw0KPj4gKCJuZXQ6IHBoeTogc3dpdGNoIGRyaXZlcnMgdG8gdXNlIGR5bmFtaWMgZmVhdHVy
ZSBkZXRlY3Rpb24iKS4gQXMgZHluYW1pYw0KPj4gZmVhdHVyZSBkZXRlY3Rpb24gZG9lc24ndCB3
b3JrIHdoZW4gQkNNNTQ2MTZTIGlzIHdvcmtpbmcgaW4gUkdNSUktRmliZXINCj4+IG1vZGUgKGRp
ZmZlcmVudCBzZXRzIG9mIE1JSSBDb250cm9sL1N0YXR1cyByZWdpc3RlcnMgYmVpbmcgdXNlZCks
IGxldCdzDQo+PiBzZXQgIlBIWV9HQklUX0ZFQVRVUkVTIiBmb3IgQkNNNTQ2MTZTIGV4cGxpY2l0
bHkuDQo+IA0KPiBIaSBUYW8NCj4gDQo+IFdoYXQgZXhhY3RseSBkb2VzIGl0IGdldCB3cm9uZz8N
Cj4gDQo+ICAgICAgVGhhbmtzDQo+IAlBbmRyZXcNCg0KSGkgQW5kcmV3LA0KDQpCQ001NDYxNlMg
aXMgc2V0IHRvIFJHTUlJLUZpYmVyICgxMDAwQmFzZS1YKSBtb2RlIG9uIG15IHBsYXRmb3JtLCBh
bmQgbm9uZSBvZiB0aGUgZmVhdHVyZXMgKDEwMDBCYXNlVC8xMDBCYXNlVC8xMEJhc2VUKSBjYW4g
YmUgZGV0ZWN0ZWQgYnkgZ2VucGh5X3JlYWRfYWJpbGl0aWVzKCksIGJlY2F1c2UgdGhlIFBIWSBv
bmx5IHJlcG9ydHMgMTAwMEJhc2VYX0Z1bGx8SGFsZiBhYmlsaXR5IGluIHRoaXMgbW9kZS4NCg0K
DQpUaGFua3MsDQoNClRhbw0K
