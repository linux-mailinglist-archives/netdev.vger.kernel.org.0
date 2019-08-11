Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6BB894FA
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 01:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfHKXzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 19:55:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14272 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726055AbfHKXzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 19:55:05 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x7BNrgJN002871;
        Sun, 11 Aug 2019 16:54:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+YwEQLeOT8xMx9CvQbEGzelOeDNScQnC1eWPGBxHtK0=;
 b=WOR0z3bsV8qZpT77ULbjpAhZajy+LNp3ZmMyn23G7qZDuX9Z/gH2LtKL/NdHm6Dt/vYs
 8v5M0qbFpSjmKI1ImgN71SXYFHyj26DiY2KZqmihaiHB5PrTDka5nhaSujcI2V7nSXrm
 zDii5FtrrYvSPwAXjV+u4tRmfpdJkGfWYW8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2uamdf94bd-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 11 Aug 2019 16:54:41 -0700
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 11 Aug 2019 16:54:40 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 11 Aug 2019 16:54:40 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sun, 11 Aug 2019 16:54:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbhSeR+dDSZobl1uVNP/fedZ+WM6QdIo8lUjXKZA1bIj+/yI/e5/eG+wSM7fN/XgFt2DKVUQkl3S0uiF/ECkeppel7AtM7B8OiDz/Ac1mJHzmEi5o9Ly5ylO7EGwT1pZZZ97Y91GEs7ZtyKOLA1xyaXBOs/fjOMkYGeQ0QYt5QSaxvRXW3L1ovYyIVoCWlqEvASR1BFAK1Onwwryo+6WhoYUD+7BOeco+GbHDRuyRYuMzIujXS09sGd9pZrCsG1WffdoKsx59PT8nwW6QQF2wAdSD8dNVmuIQtao13dZWzQfw/r+x4406YWGKXLLRFX1U9nYjjeha2ACoAsY9HcHgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YwEQLeOT8xMx9CvQbEGzelOeDNScQnC1eWPGBxHtK0=;
 b=ITQOY+OINBbZDaCXIugiNIXldqnevjjj2G5fKg7hvW8l4ViD5dv9aKkSe5v+NcLC2VZWcSlr0/b4mc6X84tGyn4R4c17ATEaCCIN3RZjkd5irBHt3zE7LfCpkhbTeFd9kB7VR7f0VnQ63kedI7BrN4B+oMHIY4NYIK5DshaE1sXihOxAyxK1Ie04seq8pE5iqEZXVw+aodl2iKk5JxDGrRnsyvUkJz/DWfqxDU+YUJMdRz5ChwCkk8rexQu/tLxqmbvKLdML0NzIVt2jutElj5bTJekGcDFuWiBuT0n6W1IGICYj0fq31ZPx8ElGaQSQvRlFHIeG8K2mSiyQAini9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YwEQLeOT8xMx9CvQbEGzelOeDNScQnC1eWPGBxHtK0=;
 b=Jha1Pcg5vzr5kIDrHfQ1RClaotSGFt5hsh9yNAM1RjUKCFA4AD+K4nab14Aw7ymxvDyncLrRE2p2Ysedr8wsCu0s1eYHdLI7SnK5G+PBvz+DR5JJ+SioyKlway23ir5093HGgvP6dDL10FBA7bM5UbmehTLA8QATf2exhT84yY8=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2583.namprd15.prod.outlook.com (20.179.155.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Sun, 11 Aug 2019 23:54:23 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2157.020; Sun, 11 Aug 2019
 23:54:23 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v2 2/4] bpf: support cloning sk storage on
 accept()
Thread-Topic: [PATCH bpf-next v2 2/4] bpf: support cloning sk storage on
 accept()
Thread-Index: AQHVTs0IGXUdimmB1UOP5x8Id4H8K6b2opUA
Date:   Sun, 11 Aug 2019 23:54:23 +0000
Message-ID: <87d0a0e3-a704-b3ab-454c-408d6c464097@fb.com>
References: <20190809161038.186678-1-sdf@google.com>
 <20190809161038.186678-3-sdf@google.com>
In-Reply-To: <20190809161038.186678-3-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR01CA0026.prod.exchangelabs.com (2603:10b6:300:101::12)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f361]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32ad7394-b07e-467f-16a2-08d71eb73c15
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2583;
x-ms-traffictypediagnostic: BYAPR15MB2583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2583D527F1965C5E91AC4B13D3D00@BYAPR15MB2583.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:177;
x-forefront-prvs: 0126A32F74
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(366004)(346002)(39860400002)(199004)(189003)(66556008)(53936002)(66446008)(66946007)(31686004)(64756008)(316002)(478600001)(229853002)(7736002)(186003)(76176011)(8936002)(14454004)(8676002)(81156014)(81166006)(6512007)(110136005)(66476007)(6116002)(305945005)(54906003)(6486002)(6436002)(2906002)(36756003)(2201001)(86362001)(25786009)(52116002)(486006)(2501003)(71190400001)(71200400001)(46003)(14444005)(446003)(476003)(2616005)(11346002)(99286004)(4326008)(102836004)(558084003)(6246003)(53546011)(6506007)(386003)(31696002)(5660300002)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2583;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5GZfl6429CV+mKinVaOeh08HQaIqBVu5oNYJ+hFNPOSNFEaEl+6n3UZQfrJ7gsl+aPpSnt1OqxysvCR6WzlP8oyD5LiYw4T82FKxFwoUAwtigcwdqVsW96hBcyGPgS+gjcxbwgcuoCrl3AvLVfEeOwpNTwlwBpZAHL7zjjs3AzjKqTt7b6Ru4nJ9vJyQrvaBsFNghUY0VGFzQm7Sqp9MejOfTucmOUtAQ/CeNZ3EnNgqSfqryFgYzpMzZ0cEl38Fgn+V7ul6Tqm6npI8QmBi4Mnxx0uX7yP8WEyD9C16Ihgc0zRWOcv2Wmv3bssakBCUcaybUAMgZpFyVPHOD8OdZWr+V0kqdXdOr85Mezh6Fg0cclhraxXvXqLv4bOLgTP5hS6BpdlvjJiMlmWMZjk/tN1moADwF+TGBEuI5kxqIGw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <60607958635022489D81FE89389D9DD7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 32ad7394-b07e-467f-16a2-08d71eb73c15
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2019 23:54:23.3637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hrXSspXWIvdAC4Pw3GEdEdKqjqb2ZmKhzXdc093bEv5Kl9O8anYmIEJLyRZBbSxg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2583
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-11_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=659 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908110267
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvOS8xOSA5OjEwIEFNLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+IEFkZCBu
ZXcgaGVscGVyIGJwZl9za19zdG9yYWdlX2Nsb25lIHdoaWNoIG9wdGlvbmFsbHkgY2xvbmVzIHNr
IHN0b3JhZ2UNCj4gYW5kIGNhbGwgaXQgZnJvbSBza19jbG9uZV9sb2NrLg0KPiANCj4gQ2M6IE1h
cnRpbiBLYUZhaSBMYXUgPGthZmFpQGZiLmNvbT4NCj4gQ2M6IFlvbmdob25nIFNvbmcgPHloc0Bm
Yi5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFN0YW5pc2xhdiBGb21pY2hldiA8c2RmQGdvb2dsZS5j
b20+DQoNCkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0K
