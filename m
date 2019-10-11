Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848C5D4A0B
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbfJKVpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:45:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42536 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727197AbfJKVps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 17:45:48 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9BLXRsj006423;
        Fri, 11 Oct 2019 14:44:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=CuuDL2YZiDI/uSGl4NWytfpGCfSyeb96qmyqLjJYhIU=;
 b=c4ubCPf3xCaDivBcBSgS94TH+pDKehszSFDz4ySkbiIxEjMm0WlTuAjgJlww0TUWq1Iu
 gk2ssWT5OtNwrukTizNn2lsIwAPB/C+k77rkT8svBv4XG4N9EakPLT7mOTyGLKsjjp2x
 y1g0q9va34LwKe/If5YSSgA2fX5cHGDa2xM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vjwwg98md-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 14:44:11 -0700
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 14:44:10 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 14:44:10 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 11 Oct 2019 14:44:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mejjs4pEs62pjzsW5FPK+pgR1h/9xfI2oLH4btRKkfycoDMsE7UyBvIf7/1MqNAS9QtCqq7caTcn2BcyZmidKEaNtzR56rD2AyUaHGIxN0lyY17r6kOs6XC3Vie5XiqYhod+VmHEguLVgJL+/VJMHfkZD0D5RAYUMoIZVZ2mPK6QDXiEsWQEba5xBRn0P8vaL49vzGGgpiXZ3wowrGzr0JbTnwsXElelnulfUOSBOOUoKPJIZIIYhIxBJxHY+1+L67go4o/y2L/J0InnPPk5kzu708Wta29UJW/7KQlIVIAp8jGwoLK9dfM4BRf4PLBcybq0HsxvHJhTrZ2QlR7vDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuuDL2YZiDI/uSGl4NWytfpGCfSyeb96qmyqLjJYhIU=;
 b=OrwzATCVaZF8+g209kJMKxFnKZ6OVSWcaj/DbYgtXvVH+TRX9aZwbia11zFBYCV1UKXP4H7ZNZRK4lqpyxySXt/SNUZz3cu054KMX05xjuq4f4tubJ3Znq9W4bPCxFO5q5RJbfXgJzaXTH9W/voZ2aJDS2eMKhDerFC3YcWJkIptPTdgMaRbtYzLRKqRTy7EXbeGERtCe4EmKpIv0FpE+VJ2VbmFEsGm3sD72IPmQP9k5IKLvtTSI5Y7IVVENvYLoXgfHyHbbZ0J7OJS+fH/8LWtjHw8gbxmFwvzmOnhROGVJhLArsyyTm3OuhLY0Qxlz1WSp9OK+QWvTt8GpEYd5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuuDL2YZiDI/uSGl4NWytfpGCfSyeb96qmyqLjJYhIU=;
 b=iMiMZBn60Z6sXiXWtwqOD0rtIZvXhd6ZTkpZLcitAfqHmDAEInlwSFdQbyzsOkAea/cx1SKmd0rEqCy5j87WzcjwKXQUnSPQdy8nX+ISkh6fdHuh4gJ36i6yFmHvP00LQEHo9IMjEvfrzisTq/yCcFVx868Zv2LNIlLINgExBrI=
Received: from BY5PR15MB3636.namprd15.prod.outlook.com (52.133.252.91) by
 BY5PR15MB3652.namprd15.prod.outlook.com (52.133.253.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.25; Fri, 11 Oct 2019 21:28:36 +0000
Received: from BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c]) by BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c%4]) with mapi id 15.20.2347.016; Fri, 11 Oct 2019
 21:28:36 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joel Stanley <joel@jms.id.au>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Subject: Re: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
Thread-Topic: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
Thread-Index: AQHVaCL3HHZ/0IxjZ0GB2KAMVKzdAqcld28AgAEYWwCAK1ZcgIACEkcAgAD6PQCAAL1kgA==
Date:   Fri, 11 Oct 2019 21:28:36 +0000
Message-ID: <AD92CCF8-91B2-4EA1-9915-812D701E9CFA@fb.com>
References: <20190910213734.3112330-1-vijaykhemka@fb.com>
 <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
 <CACPK8XcS4iKfKigPbPg0BFbmjbT-kdyjiPDXjk1k5XaS5bCdAA@mail.gmail.com>
 <95e215664612c0487808c02232852ef2188c95a5.camel@kernel.crashing.org>
 <AF7B985F-6E42-4CD4-B3D0-4B9EA42253C9@fb.com>
 <158fa0872643089750b3797fd2f78ba18eaf488c.camel@kernel.crashing.org>
In-Reply-To: <158fa0872643089750b3797fd2f78ba18eaf488c.camel@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:f03f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f32f8c0-b6f0-4276-c8b8-08d74e91f9b8
x-ms-traffictypediagnostic: BY5PR15MB3652:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3652F02075E889D93F6F05E9DD970@BY5PR15MB3652.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(39860400002)(366004)(396003)(136003)(199004)(189003)(446003)(6116002)(6486002)(7736002)(71190400001)(71200400001)(14454004)(186003)(305945005)(76176011)(8676002)(11346002)(8936002)(4744005)(6246003)(256004)(6512007)(4326008)(81166006)(81156014)(46003)(54906003)(110136005)(36756003)(2616005)(2906002)(476003)(99286004)(316002)(478600001)(6436002)(5660300002)(102836004)(7416002)(86362001)(229853002)(6506007)(486006)(66946007)(91956017)(66476007)(64756008)(25786009)(76116006)(66446008)(33656002)(4001150100001)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR15MB3652;H:BY5PR15MB3636.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wanMVQkG+acHU9ols1i55DMntEK+83UXVXROUhT15zhb9gwJBXyDFEC6tSssaHTJQpznC255lmVS1PIiWUJXgoSKf59eotvRs/jcwry8BAz8rn8VspBo7Sx6cG1/8187MYV6H9AgxZw7uqQqowouej7fnSsVWz0tD5tWNbXKrcdYKQ9YgxBhbmckt2w+vIvhYImIhzmcUPO64MqWp6AtVnNUzdh6m+0fVtyq6ifAjl4QRya8wz9wsgoe/kAybFbZWZjLg+4fdUO4EWLJcEp7y+BNbw6sSG9w4e5ClIoTr7kx8Ofhm2tzIpLRrdLXbRgV9qoAmV7/EnjzJu5BY+3Wl4qt0gCokIdmxPNjzVRKnkPWLu+bRGIDp9J8KeIONePzFgwLHUV1BQJCoe5o8CLs0yRtTXl9gmaNljmwAHARVgI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B7407B9191CBD498371EA3025D7F0A1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f32f8c0-b6f0-4276-c8b8-08d74e91f9b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 21:28:36.1606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NbBi2QFsQiDpLMite05JGu0PNJ3QB3vnow61o9dg4Ga7CPUwR19sBOS4MedahgFmc0OrqMaQOQ/Qx03xpDyeVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3652
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_11:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=965
 suspectscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 adultscore=0 phishscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910110174
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDEwLzEwLzE5LCA4OjExIFBNLCAiQmVuamFtaW4gSGVycmVuc2NobWlkdCIgPGJl
bmhAa2VybmVsLmNyYXNoaW5nLm9yZz4gd3JvdGU6DQoNCiAgICBPbiBUaHUsIDIwMTktMTAtMTAg
YXQgMTk6MTUgKzAwMDAsIFZpamF5IEtoZW1rYSB3cm90ZToNCiAgICA+ICAgICBBbnkgbmV3cyBv
biB0aGlzID8gQVNUMjQwMCBoYXMgbm8gSFcgY2hlY2tzdW0gbG9naWMgaW4gSFcsIEFTVDI1MDAN
CiAgICA+ICAgICBzaG91bGQgd29yayBmb3IgSVBWNCBmaW5lLCB3ZSBzaG91bGQgb25seSBzZWxl
Y3RpdmVseSBkaXNhYmxlIGl0IGZvcg0KICAgID4gICAgIElQVjYuDQogICAgPiANCiAgICA+IEJl
biwgSSBoYXZlIGFscmVhZHkgc2VudCB2MiBmb3IgdGhpcyB3aXRoIHJlcXVlc3RlZCBjaGFuZ2Ug
d2hpY2ggb25seSBkaXNhYmxlIA0KICAgID4gZm9yIElQVjYgaW4gQVNUMjUwMC4gSSBjYW4gc2Vu
ZCBpdCBhZ2Fpbi4NCiAgICANCiAgICBJIGRpZG4ndCBzZWUgaXQsIGRpZCB5b3UgQ0MgbWUgPyBJ
IG1haW50YWluIHRoYXQgZHJpdmVyLi4uDQoNCkxldCBtZSBzZW5kIGFnYWluIHZpYSBnaXQgc2Vu
ZC1lbWFpbC4NCiAgICANCiAgICBDaGVlcnMsDQogICAgQmVuLg0KICAgIA0KICAgIA0KICAgIA0K
DQo=
