Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B78FDCCE5
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 19:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505569AbfJRRfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 13:35:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48836 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2502519AbfJRRfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 13:35:02 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9IHYeYD025166;
        Fri, 18 Oct 2019 10:34:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=pW6JNp7wgc4TBXpm8VV0baBOFYQPIpG7zUcdrMwcdBY=;
 b=IiAR+8oyxYwuclC47hvHtvWDy616/3cZMtY7fKo0adGvBzJNOxmloW77lG/pKjDD5ogP
 Zu9tTvumr1hpq7rN9qzoM/AFaeJ/h/rxnV/IeEW8NIBe4vJROIBlpOXGnsELNiUer4bb
 uIyl9VgR0iTiMHQ1y6rUlwjwIXwmkai3+Yk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vqc4esn50-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 10:34:58 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 10:34:40 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 10:34:40 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 10:34:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jNcVhz9h49HxMuQOsv1nP/6Ty1uvPpweeTsh2E9pHNXbu0a4pWNkIMVwrie37R/ZkX4FnMNVoITUVv9LtJnbs+SbCQuUCUqqWPisb5tjLsD206NmQRBensLVoaLnG3qnt+8CeAd5Jtvwi7sVCLernscfYNa/7mZxjCCtp9B9z73ixHwI1uSMQxZ+wM/0ROwQlQ9kFzjo0A6QmlYuzoN+xk9GrB3yqvb+agq2xgU928x6AV6QHwIKlBRzStBXRIvcGKpnlhEZEuJn8fkxlcQH4k86zX3+c89YVJic22wr/rww1fLW30RQrL+4YgYoFZUKePpjTEz9LNX0ujdPYauV2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pW6JNp7wgc4TBXpm8VV0baBOFYQPIpG7zUcdrMwcdBY=;
 b=W9xeiOYI1DNk16iNtyFfwmnHeGK++4m2FR1JqQ0xhcW+9VSOlOlOJHgqmWUeUNLBoPn2nPd8bMwj7eVPJZk7S4hUoYDG7+CBX6O02iVp9rAjCeCRqfqMcHR/k9B0nJv4w3jZI8cd16u3yhMkn2dIBo8J+oG5FCibdXYcshImfB37Mp09dhWqPpGPKx6dKXb8PRg08SSrx86sMgZT6RD5I6oqbBNqmpO2ccLGlHlcSA0kUQpMWJ88Y4ZEoQDpF7V9Ejz5EwVRsgWPJfLVFWy5XPO75qEtNerz6yOE2qYFB8OAL24OaHsfBVQRM2ZqXXIFdq5sWe00L88jSbXEuyigRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pW6JNp7wgc4TBXpm8VV0baBOFYQPIpG7zUcdrMwcdBY=;
 b=jYrzKPT6RfMHh97imEHpPBvC0oNWoVTSMXh0agDwWFeAJhLikqMKZjbla30yZSEXCGOE45lWDmC097nbXond0JFB+/Xf+1szTSf3z9SyLr8O+Rc40t3h+3kEEFidruJOsoHot16MjD3fERwa+51HqGi6bJLA0uWZ5yGMLG8bQcE=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3208.namprd15.prod.outlook.com (20.179.58.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Fri, 18 Oct 2019 17:34:39 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 17:34:39 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v14 5/5] bpf_helpers_doc.py: Add struct bpf_pidns_info to
 known types
Thread-Topic: [PATCH v14 5/5] bpf_helpers_doc.py: Add struct bpf_pidns_info to
 known types
Thread-Index: AQHVhPuxzngVWSI2Lk+jzNF0Twb/pKdgqqcA
Date:   Fri, 18 Oct 2019 17:34:39 +0000
Message-ID: <95a999b5-77de-8509-73bb-3058683c8866@fb.com>
References: <20191017150032.14359-1-cneirabustos@gmail.com>
 <20191017150032.14359-6-cneirabustos@gmail.com>
In-Reply-To: <20191017150032.14359-6-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1201CA0024.namprd12.prod.outlook.com
 (2603:10b6:301:4a::34) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3455]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d948c4a-a18c-478d-f145-08d753f173b9
x-ms-traffictypediagnostic: BYAPR15MB3208:
x-microsoft-antispam-prvs: <BYAPR15MB320811E574BB2F6B8874D0F6D36C0@BYAPR15MB3208.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:303;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(136003)(376002)(39860400002)(189003)(199004)(102836004)(53546011)(8936002)(31696002)(486006)(6486002)(186003)(6512007)(8676002)(76176011)(52116002)(81156014)(81166006)(46003)(99286004)(86362001)(229853002)(6246003)(4326008)(2501003)(478600001)(386003)(6436002)(36756003)(6506007)(110136005)(305945005)(14454004)(31686004)(25786009)(7736002)(316002)(5660300002)(446003)(476003)(66946007)(2906002)(66446008)(256004)(11346002)(66476007)(54906003)(64756008)(66556008)(6116002)(4744005)(2616005)(71190400001)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3208;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UGP9WUAzTbG82y5EI066jMS1M2hEeU+wbwCZhVWDxtQpniZ1T72Eg3RCici8SdfEGdo0YhrMywAVvMAK9ULq8I5Eos/5MVKAy908vmkAkrCYyu85ZXLQgUSlsZOStSD4qK5T6ltZl0DmDYU+ujUbvdc8YLAdRoU1DTf0kEHYjH2BO29LMY5MF1lWvSStsbrpSSsye1BGueKNP40wUD7Jp0Lqb4OL/4wguw1xzyL+uq0LHb/Lh0BLkqMhGEBDMUjbkFPNQzLjeF3o/lbqVEeqIpLvZ4Akev10f8Nk0UpoOjkArCsKw0+IxYmjpUzOnQuzEJ9U1C0Opu/uJt/o7+reI04embysUvUIll7xBOm9vg9/QRItceGmQu2nWqyHXqO/CCgxZCxidJy/TuT0Ei47eCVE2IUmjkOrFtX9U/FwDQk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6DC7686C1DEB9748B431AD31FF5517DB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d948c4a-a18c-478d-f145-08d753f173b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 17:34:39.1992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tp4wiLTW6fuZcjDQhGkUuk80FglFLhSFtHT3VBrTMKXGrtu7t1cyn3/oDAvAgh2/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3208
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_04:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=880 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910180159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzE3LzE5IDg6MDAgQU0sIENhcmxvcyBOZWlyYSB3cm90ZToNCj4gQWRkIHN0cnVj
dCBicGZfcGlkbnNfaW5mbyB0byBrbm93biB0eXBlcw0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2Fy
bG9zIE5laXJhIDxjbmVpcmFidXN0b3NAZ21haWwuY29tPg0KPiAtLS0NCj4gICBzY3JpcHRzL2Jw
Zl9oZWxwZXJzX2RvYy5weSB8IDEgKw0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL3NjcmlwdHMvYnBmX2hlbHBlcnNfZG9jLnB5IGIvc2NyaXB0
cy9icGZfaGVscGVyc19kb2MucHkNCj4gaW5kZXggN2RmOWNlNTk4ZmY5Li5kNDJlYjE4NTgxMGYg
MTAwNzU1DQo+IC0tLSBhL3NjcmlwdHMvYnBmX2hlbHBlcnNfZG9jLnB5DQo+ICsrKyBiL3Njcmlw
dHMvYnBmX2hlbHBlcnNfZG9jLnB5DQo+IEBAIC00NTAsNiArNDUwLDcgQEAgY2xhc3MgUHJpbnRl
ckhlbHBlcnMoUHJpbnRlcik6DQo+ICAgICAgICAgICAgICAgJ3N0cnVjdCBza19yZXVzZXBvcnRf
bWQnLA0KPiAgICAgICAgICAgICAgICdzdHJ1Y3Qgc29ja2FkZHInLA0KPiAgICAgICAgICAgICAg
ICdzdHJ1Y3QgdGNwaGRyJywNCj4gKyAgICAgICAgICAgICdzdHJ1Y3QgYnBmX3BpZG5zX2luZm8n
LA0KDQpsb29rcyBsaWtlIHRoZSBuYW1lcyBhcmUgc29ydGVkLiBwbGVhc2UgcHV0IGl0IGludG8g
YXBwcm9wcmlhdGUgcGxhY2UuDQoNCj4gICAgICAgfQ0KPiAgICAgICBtYXBwZWRfdHlwZXMgPSB7
DQo+ICAgICAgICAgICAgICAgJ3U4JzogJ19fdTgnLA0KPiANCg==
