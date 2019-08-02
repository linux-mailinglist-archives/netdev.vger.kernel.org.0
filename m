Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7213F80181
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 22:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406903AbfHBUAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 16:00:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52434 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403882AbfHBUAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 16:00:30 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x72K007F028146;
        Fri, 2 Aug 2019 13:00:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=u96Gto278oZlbBmp/f1Ox4q7CyoNZDyyccejoVV0Mdo=;
 b=Ts5zSVnbOqXZSpn77RyNDhhPcUlMFQZP+vdUs7MGtUP1MEBSRBvkaaTmvl8uCzvTwnrI
 haLUa0b+/NiBX9/YOga2OE58Hi9Xza012DjXWpzM8gn5b8PWmXFpKZilNITWy3owHSBK
 1ElRg5vvWufMBKCpNgYi381lREMICm8F0as= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u4s2tgpcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 02 Aug 2019 13:00:08 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 2 Aug 2019 13:00:06 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 2 Aug 2019 13:00:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKa0BC2KpwZDzva7ggi49Y4wz+VzjV2+z5KrYwdxyBsmIbYm6eJoesju3c1aWFVTJNS+XiuSa53NIboyLIh931J6Si7+ae2RjhP/7VsyoBvdaG7mERfr5wY8u5AyizMoRyreCWxZ1sRiZWk6ntU/vAIB5jcdW9pV9iPaKiHDuQF0Lix67DcsV/N02zL5RZX1mNTbqaJoVVxGxaZYemi8tzL7uhA+SPXltGEqAgHYNf5HpLXj/cQujYXeyO5UGn7qKTdDu7E3oWkW8pvi39pGClONr/iWcZSTWev6tVpU9LScQbunKc+bOwG7eF8OLPe0UrjpF/vCHkLJaF1yeMMeug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u96Gto278oZlbBmp/f1Ox4q7CyoNZDyyccejoVV0Mdo=;
 b=avbbcJxMq92Qpg/E0Yitjh2xOFPwa45g9ST03g6FmOMqG5+I7hXzOirQBx48nRjLuKgtPvIijfZGCqJOSH5KcPW5Sx1qL9uzNZKiSJv4zOy51ZWqYmOzc7DS/1td+Cw2GvhuuF9O/wywqpGDYaCl26b30CwLiILw7EMxwPEnIqopy6+30sx23850fQyGU3CnFsyG56G/xSiPRpJqqYYqmZBrFuisyoyknmXv5nnC1ialxGyWXHtfDvWdmMq49librdlDU6uJx+mc2p4thLOjBFUr/M58uAjhUflld4HVUaUZdIvUSQWR9V8n91wu2aUwKD+tFUsPltYdFVlRfee0Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u96Gto278oZlbBmp/f1Ox4q7CyoNZDyyccejoVV0Mdo=;
 b=EYn6KNwdvg7LmPmNhrY6AZuQ3BIe8Jif6fCPfjFM3DFsE3cu4UHmJEcNCOsjfh+8MY3lyvhdTcF6oCeWQe3m4raCsZZKoOKiGQWa8eILgcVwViYGR4NvORfE5II42t3JYkrswmUiZEjncgUvcZciI75VHYvMs0UKAZ6L40XH/OI=
Received: from CY4PR15MB1479.namprd15.prod.outlook.com (10.172.162.17) by
 CY4PR15MB1254.namprd15.prod.outlook.com (10.172.180.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Fri, 2 Aug 2019 20:00:05 +0000
Received: from CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::79a3:6a7a:1014:a5e4]) by CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::79a3:6a7a:1014:a5e4%8]) with mapi id 15.20.2115.005; Fri, 2 Aug 2019
 20:00:05 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: test_progs: drop extra
 trailing tab
Thread-Topic: [PATCH bpf-next 3/3] selftests/bpf: test_progs: drop extra
 trailing tab
Thread-Index: AQHVSVYoIIzFWR3kYEGMcL/Po6YU/KboRv+A
Date:   Fri, 2 Aug 2019 19:59:50 +0000
Message-ID: <39681786-4967-e40c-1a30-00dfa09dc481@fb.com>
References: <20190802171710.11456-1-sdf@google.com>
 <20190802171710.11456-4-sdf@google.com>
In-Reply-To: <20190802171710.11456-4-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0073.namprd04.prod.outlook.com
 (2603:10b6:301:3a::14) To CY4PR15MB1479.namprd15.prod.outlook.com
 (2603:10b6:903:100::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::e445]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcdcaa4a-5305-4d95-4a38-08d71783fa02
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1254;
x-ms-traffictypediagnostic: CY4PR15MB1254:
x-microsoft-antispam-prvs: <CY4PR15MB125428C035922067010246EDC6D90@CY4PR15MB1254.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:147;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(346002)(366004)(376002)(189003)(199004)(446003)(53546011)(65826007)(53936002)(76176011)(66476007)(6512007)(66946007)(64756008)(110136005)(31686004)(66446008)(5660300002)(6486002)(6436002)(8676002)(58126008)(2201001)(25786009)(229853002)(65806001)(81166006)(81156014)(7736002)(4326008)(64126003)(66556008)(52116002)(6506007)(31696002)(71200400001)(6246003)(54906003)(11346002)(68736007)(2501003)(386003)(476003)(14454004)(65956001)(8936002)(256004)(186003)(71190400001)(316002)(46003)(305945005)(486006)(102836004)(6666004)(478600001)(14444005)(2616005)(6116002)(99286004)(4744005)(86362001)(2906002)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1254;H:CY4PR15MB1479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YO4aqLXoqZQD0d2CQzXuq0AKj+gplPgs0H5ez5/Il8me141Y45MEdbC0YWa+LmYEAc/uBn/qMOz+JC/Y/V/FleWTpFAx1gXEZT10Zs6ZigS0w7G8i24OqeNaywtAoQAr4m3JkKUi5TnOhzsQt3EMHKQ0EF/+tt8Q7PvSD8T1dLaQDfclLgmyHp5zs3aNepxXIgo7zE0lGdOnF2/tpkPkVK7TniPS07UrK5R/jJ2IitvwgVjGQ1xeC2zpAURRs6TEDGU06UwOfkkXc9y5t5I7OYr2CC1cg1afT1bw/jvNtw96EXHxixhhDzyh/YU2HkoGNlsyHnOSFA1Xd9inCXPT3R8m0ZT5CylFjguHWNMgiMpdznl0MSfXfRWwI0voJhsA3SdqXsnJDQCmUFj8E2T1zYf7VYbQv4ezYMoD0W3Ef6k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <01087623C782AF43B7CDC750498695C5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bcdcaa4a-5305-4d95-4a38-08d71783fa02
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 19:59:50.0172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: andriin@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1254
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-02_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=958 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908020212
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA4LzIvMTkgMTA6MTcgQU0sIFN0YW5pc2xhdiBGb21pY2hldiB3cm90ZToNCj4gU21hbGwg
KHVuKXJlbGF0ZWQgY2xlYW51cC4NCj4NCj4gQ2M6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBm
Yi5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFN0YW5pc2xhdiBGb21pY2hldiA8c2RmQGdvb2dsZS5j
b20+DQo+IC0tLQ0KQWNrZWQtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQo+
ICB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9wcm9ncy5jIHwgMiArLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+DQo+IGRpZmYgLS1n
aXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9wcm9ncy5jIGIvdG9vbHMvdGVz
dGluZy9zZWxmdGVzdHMvYnBmL3Rlc3RfcHJvZ3MuYw0KPiBpbmRleCA3MWM3MTcxNjJhYzguLjQ3
NzUzOWQwYWRlYiAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rl
c3RfcHJvZ3MuYw0KPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9wcm9n
cy5jDQo+IEBAIC0yNzksNyArMjc5LDcgQEAgZW51bSBBUkdfS0VZUyB7DQo+ICAJQVJHX1ZFUklG
SUVSX1NUQVRTID0gJ3MnLA0KPiAgCUFSR19WRVJCT1NFID0gJ3YnLA0KPiAgfTsNCj4gLQkNCj4g
Kw0KPiAgc3RhdGljIGNvbnN0IHN0cnVjdCBhcmdwX29wdGlvbiBvcHRzW10gPSB7DQo+ICAJeyAi
bnVtIiwgQVJHX1RFU1RfTlVNLCAiTlVNIiwgMCwNCj4gIAkgICJSdW4gdGVzdCBudW1iZXIgTlVN
IG9ubHkgIiB9LA0K
