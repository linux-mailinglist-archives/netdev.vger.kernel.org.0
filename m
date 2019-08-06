Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 781B482A34
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 06:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfHFETw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 00:19:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62152 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725747AbfHFETw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 00:19:52 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x764F5ZX007503;
        Mon, 5 Aug 2019 21:19:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=gVFzZqcraz4VFJVX7aBP/RMuXMY8SuU3reqJTiTJRJ4=;
 b=IXHl9g4ne0Qd/pKoJ0NXFTrpV+QZJKbE3m/YFLwCfld6rHs0n1GG+xKD7EKerdmH9R6m
 3wKKkMPUIWMq87vZWA5OLJCIcmapaDk3yWaBGD29JJNR+t2SFftd/BUuYNY+eqfpLmrp
 rzSQy0EWHnKy7YAFy+MYNSEIwMsDR5IJ4xA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u6w2e8we2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 05 Aug 2019 21:19:31 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 5 Aug 2019 21:19:30 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 5 Aug 2019 21:19:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7sCb6vztw8QLeR1MJ9ptPT507Vmt7UZqVWa0vObKlpx6EZyAycSvvb80usReqYQDNh+S0i9voPdAjp+6l2nwqNdHvuZkAz+PRFjRj8onQfVpaEH6pouhfmhf94cmUAHJxbo7MwJy6wmxxMSazl9dnUtLwUzg+Lwn6/0Z8Fz5t/UKRDRQEFwqKI0aLDW/1EnwSz7rNSsv6kP8xak7pCKMVTwQHHXDm7dDie+6ER9AoZUyrRbEY28YUzfbgojpGFUCNSg+JUPiprIj3hLzy/C9/IHnXNrraHvaL1f81GxY5AfPpEj78MR/lgnPyuvgaYCKSk0yMiFivme6NXYpgk/GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVFzZqcraz4VFJVX7aBP/RMuXMY8SuU3reqJTiTJRJ4=;
 b=Vu8Y+doRzPFwwNWU7GQKq2jEuFtDHRqHe5Zf5JRTqJTICBefzGWAF+q7y3uwz5tPClrVSDZJMOUV8sD/FIRMO2wTptwJc9x/wSYNa1tdUqoq7AdQyk2HjctoFzLLhYAXxY+srV8Dpehxul9ODlVop/zc1l1RZRJgXUNZ10C/yGhPZtbhaJNXKLdOmx0M/gHqmJthjYGs2I6kJO6R6KHvCMS+cMG1Hiqh/418mQRrNwuR/y6o69lyze66aCkuN9RvX1PHueAkW/jbEecVxb0aegWafUGDX/wchylzxoTjn1BSwtBn+/UbzLIcIo8r6B2H2rqTZjzJjAw5VsSy/4yW7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVFzZqcraz4VFJVX7aBP/RMuXMY8SuU3reqJTiTJRJ4=;
 b=X8hreEvRv4xlHQktZz1+vydXnH8C8jnFD08GggNlIOzFjmDTaCIvkLWXKPKFjfung2F586vTA/kew/lAoLEPQywKDGmucVeaVB3FPKk2m2VDsDZgG5JcRsQbS0jlAMuwcxp6VO+xWt8PS2zhUC1owaDuihvy/yCGWPgWt4ZMDXo=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3144.namprd15.prod.outlook.com (20.178.239.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.12; Tue, 6 Aug 2019 04:19:29 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 04:19:29 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 0/2] selftests/bpf: more loop tests
Thread-Topic: [PATCH v2 bpf-next 0/2] selftests/bpf: more loop tests
Thread-Index: AQHVS/0ke57CCkqp8E6eMb+sDfpwtKbthEcA
Date:   Tue, 6 Aug 2019 04:19:29 +0000
Message-ID: <ff86b565-097e-8f1a-c411-7138f429ed79@fb.com>
References: <20190806021744.2953168-1-ast@kernel.org>
In-Reply-To: <20190806021744.2953168-1-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR18CA0032.namprd18.prod.outlook.com
 (2603:10b6:320:31::18) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::5cf1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7fdb66fc-92d5-431b-e2e3-08d71a25460b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3144;
x-ms-traffictypediagnostic: BYAPR15MB3144:
x-microsoft-antispam-prvs: <BYAPR15MB3144BA4C5D25F99805D8874AD3D50@BYAPR15MB3144.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(39860400002)(136003)(366004)(189003)(199004)(186003)(102836004)(6512007)(7736002)(66946007)(2501003)(66476007)(66556008)(64756008)(66446008)(5660300002)(110136005)(256004)(4326008)(11346002)(2616005)(31696002)(86362001)(4744005)(486006)(305945005)(76176011)(446003)(68736007)(6506007)(386003)(53936002)(6436002)(53546011)(46003)(476003)(31686004)(2906002)(8936002)(81156014)(81166006)(14454004)(8676002)(229853002)(52116002)(6116002)(71200400001)(6486002)(99286004)(36756003)(316002)(54906003)(25786009)(71190400001)(478600001)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3144;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RXqBYL/ikY+VOfnxFcAPMjL2SqvF0TZPbotbUyrvEibCSTJyfaFeZcWqCBCXEF9UkiWTu37Eee00C4MJWYdgaUr6eGv5nw4aPnldJZxhvJ/zloLplUT6jV+lxLlpRTdfJD0RJZ+LtPa3vA9PFADkDNoUHYJm/5oVPXP6HnkfN/Ont16fv/s1DFfTGBUDukpox3YcarmxuLPBEqAuN/t9MussI63R6NccnZmzEXNrwIButHft6FdH4LHq4G7lt/UiPQ5Pks2JygeyDXUC4QsfCPntU9HpiUdY5Jphq6Oj+mCZrj/Lg2WnvKYuLtqcucYbMN1it7PC8PT1LSonrvXRRr7k0oRxqB9/IUeIZNYE6RmgkmsAKfjrzxfZwyLtQ4wGnAKjUVBJI1wUCwIuV7uIxHiG9bwgt9/xTVPO+215kos=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDA71DFE3CF75E41853CF2DB3A8AFC27@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fdb66fc-92d5-431b-e2e3-08d71a25460b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 04:19:29.1038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3144
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvNS8xOSA3OjE3IFBNLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+IEFkZCB0
d28gYm91bmRlZCBsb29wIHRlc3RzLg0KPiANCj4gdjEtdjI6IGFkZHJlc3NlZCBmZWVkYmFjayBm
cm9tIFlvbmdob25nLg0KPiANCj4gQWxleGVpIFN0YXJvdm9pdG92ICgyKToNCj4gICAgc2VsZnRl
c3RzL2JwZjogYWRkIGxvb3AgdGVzdCA0DQo+ICAgIHNlbGZ0ZXN0cy9icGY6IGFkZCBsb29wIHRl
c3QgNQ0KDQpMb29rcyBnb29kIHRvIG1lLiBBY2sgZm9yIHRoZSB3aG9sZSBzZXJpZXMuDQpBY2tl
ZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCg0KPiANCj4gICAuLi4vYnBmL3Byb2df
dGVzdHMvYnBmX3ZlcmlmX3NjYWxlLmMgICAgICAgICAgfCAgMiArKw0KPiAgIHRvb2xzL3Rlc3Rp
bmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9sb29wNC5jICAgICB8IDE4ICsrKysrKysrKysrDQo+ICAg
dG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL2xvb3A1LmMgICAgIHwgMzIgKysrKysr
KysrKysrKysrKysrKw0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgNTIgaW5zZXJ0aW9ucygrKQ0KPiAg
IGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvbG9v
cDQuYw0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYv
cHJvZ3MvbG9vcDUuYw0KPiANCg==
