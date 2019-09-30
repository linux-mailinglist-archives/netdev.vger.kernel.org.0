Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBFAC26C4
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732394AbfI3Uj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:39:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40586 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731074AbfI3Uj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:39:59 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8UI9NLS019536;
        Mon, 30 Sep 2019 11:18:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=G32pemu8qTtzZj202ld+NA5OPTjbPiWJDVp1eFcSpq8=;
 b=QtNqepTynVBQvQCgks+jXnNbyCxlTN2XWiMUe4N/ReQCbthUlZie0npGpHDEflT7eb2n
 LpbqpL4F/pxWaglUwymYgiVZQ/XpR7i3zq+DOu6v6nfukAxWCtNOdsaSKHNZSVPnI6bU
 3vDKxOdkuQ0gifMcUc3bP9RBSBwqCSQaUA4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vb66dupf6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Sep 2019 11:18:46 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 30 Sep 2019 11:18:45 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 30 Sep 2019 11:18:45 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 30 Sep 2019 11:18:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZY2u4mswCUZdCQeXLKW1ARGiCUNtN8jr5ZPCrU/4jI9mXJUZtcVIriRZo+GJdEVFpWqx9xwJ+nm0iZ06+yGM/Ja/Zi8ny1hsfURBrtBmy5gD1ju8FXdZv6Cd1bLC4dCjGj4Q5H1RgpNRhwF4+8PQKGTRHghmxU57jN2c/L5X49z8JABo8Ycjvoigf8t2CBHWbLHvucqR3AeT4fG2Yci/k3TOAko2tFLq7HlZa7pR8YMsTInYPefg5iBYq/eTR6SOOG2clwNB0FUBKNaayzQmN6zobDtYeNSQeDtKKcyt1B49N5HmArbmCKWJZ3K0vg7WaJrU5+VglI+E6kgotwPLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G32pemu8qTtzZj202ld+NA5OPTjbPiWJDVp1eFcSpq8=;
 b=RKHkj6UXs9BkLhq6RMJG1pJ2Xg067nbTERakcfeqUEzwzRkYPiXTNXjjBU9bPG3C+5DAn5uljLI8neGOW89j5CVYsTkHlIMLryLpGif/NUceZFjHUGIzYcF2lyS88nnKI7HjheH4Ex7Be4X8lLcbU+J/tdB2n05Guduex2JXrbFMUHwGREXS24hQtfBI8akZhSNrgVb899tFUkba9c80WoG0JM6Bo3pKiZp3qnzVXhUDQaAX+irTr9yxNaFe0uKKMXlgD7A+K68jFK9U0VoEsxca/+QGqQ9AaIyEjRvjRUNLd46oaMt7ttHsI3FCx1bXjrZaXBAjir12WHURUvnajA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G32pemu8qTtzZj202ld+NA5OPTjbPiWJDVp1eFcSpq8=;
 b=djbd3KdwK9kLQiuFyToD6iedcAVHHc5dWVvYe+DEVjx+I3q1oDQQgWC48WBXXpC1858KiPc5lqU2UTPZyGzGEN/hfFEKt4xkmle/6IiGQgcgDVZ1IU26IfNPDIzZ5s5IuFgJPcHD5WpulVRGst30NSkvlIaaCzkAuNOvwKAIJPU=
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com (52.132.150.23) by
 MW2PR1501MB2059.namprd15.prod.outlook.com (52.132.150.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Mon, 30 Sep 2019 18:18:43 +0000
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::70c1:f658:218f:9cfa]) by MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::70c1:f658:218f:9cfa%5]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 18:18:43 +0000
From:   Julia Kartseva <hex@fb.com>
To:     Jiri Olsa <jolsa@redhat.com>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "md@linux.it" <md@linux.it>
CC:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: libbpf distro packaging
Thread-Topic: libbpf distro packaging
Thread-Index: AQHVUUC6mSeRtrJxpEmiNjup7x1PAKcGJtMAgAJfWYCAAG7xgIAEG0SAgAIlyQCAAQdFgIA0IB+AgAABjwA=
Date:   Mon, 30 Sep 2019 18:18:43 +0000
Message-ID: <A273A3DB-C63E-488F-BB0C-B7B2AB6D99BE@fb.com>
References: <20190813122420.GB9349@krava>
 <CAEf4BzbG29eAL7gUV+Vyrrft4u4Ss8ZBC6RMixJL_CYOTQ+F2w@mail.gmail.com>
 <FA139BA4-59E5-43C7-8E72-C7B2FC1C449E@fb.com>
 <A770810D-591E-4292-AEFA-563724B6D6CB@fb.com> <20190821210906.GA31031@krava>
 <20190823092253.GA20775@krava> <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
 <20190826064235.GA17554@krava> <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
 <20190828071237.GA31023@krava> <20190930111305.GE602@krava>
In-Reply-To: <20190930111305.GE602@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::1:b9ae]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2046716f-43b6-4461-ff12-08d745d2a0ac
x-ms-traffictypediagnostic: MW2PR1501MB2059:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB2059D8201950C720A33E2FC2C4820@MW2PR1501MB2059.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(346002)(136003)(366004)(396003)(199004)(189003)(54094003)(2501003)(229853002)(6116002)(71200400001)(256004)(14444005)(71190400001)(46003)(4326008)(8936002)(81166006)(81156014)(8676002)(86362001)(6306002)(6512007)(54906003)(110136005)(14454004)(2906002)(316002)(6486002)(2201001)(186003)(6436002)(66946007)(6506007)(99286004)(446003)(53546011)(3480700005)(11346002)(76116006)(4744005)(476003)(305945005)(486006)(5660300002)(66556008)(66476007)(33656002)(64756008)(76176011)(2616005)(36756003)(102836004)(66446008)(478600001)(7116003)(7736002)(6246003)(966005)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2059;H:MW2PR1501MB2059.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J4R/iODCVMXjLY2YRCmIkdzZ0ElHc4o3mF7V/n6ugz/A99kzmS+cgbn9sg/Vn+TS0SmGiI1lTwKfeOmHoi3Uhy+RCt9gtZU1nD1Nx1Zqk9mIPHRYsK12NhEGbsh/WHAfGvTnuMLc4Y1AORz9RliPHsF600tFYxbchI+8dq/hf322kUyMo0CnHOnQVj5i+7TGCZost/UNeaHOtpCHL5DG+NWdgJ6DpEnEgdv4PKk8/StoTUGANRpzDZ6hRH+KG92DSJM2ItU8vBpMMMBThW6QLjTFRBa9K+GPiPTvJUOVu8y1BxR5cx9YKuUH+MfELVFtmqgEOs8+oYWpuv5m9YdXQ6gUZ8g5sJI74L9OQ3znKC95f4sbHCvyVoAewAigRc0IVbZ8Ro8nRS5SdmJDgnf95Bn400t5bCdZCCMRR08r+c3N5ke3npS4lgjbo/4Jq9L4Gi0Gph52VoW9Ef9h0z7WXw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8AAE74D84D2AF409CEC05BD8DBB163C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2046716f-43b6-4461-ff12-08d745d2a0ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 18:18:43.6485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NqRU6ClStsUIpbk3mRfk4H70HnNo6T5Wiolg9esNESrBJG1KbRxzqRP9v5/v11Vq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2059
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_10:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 clxscore=1011 lowpriorityscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmsgeW91IEppcmksIHRoYXQncyBncmVhdCBuZXdzLg0KDQpBZGRpbmcgTWFyY28gRCdJdHJp
Lg0KTWFyY28sIEkgd29uZGVyIGlmIHlvdSBhcmUgT0sgd2l0aCB0aGUgcmF0aW9uYWxlIGZvciBs
aWJicGYgcGFja2FnaW5nDQpmcm9tIEdIIG1pcnJvcj8gQ2FuIHdlIHByb2NlZWQgd2l0aCBzd2l0
Y2hpbmcgRGViaWFuIHBhY2thZ2UgYXMgd2VsbA0KanVzdCBsaWtlIHdlIGRpc2N1c3NlZCBvZmZs
aW5lIGF0IEFTRz8NClRoZSBidWcgcmVwb3J0IGZvciBGZWRvcmE6IFsxXQ0KVGhhbmsgeW91DQoN
ClsxXSBodHRwczovL2J1Z3ppbGxhLnJlZGhhdC5jb20vc2hvd19idWcuY2dpP2lkPTE3NDU0NzgN
Cg0K77u/PiBPbiA5LzMwLzE5LCA0OjEzIEFNLCAiSmlyaSBPbHNhIiA8am9sc2FAcmVkaGF0LmNv
bT4gd3JvdGU6DQo+DQo+IGhleWEsDQo+IEZZSSB3ZSBnb3QgaXQgdGhyb3VnaC4uIHRoZXJlJ3Mg
bGliYnBmLTAuMC4zIGF2YWlsYWJsZSBvbiBmZWRvcmEgMzAvMzEvMzINCj4gSSdsbCB1cGRhdGUg
dG8gMC4wLjUgdmVyc2lvbiBhcyBzb29uIGFzIHRoZXJlJ3MgdGhlIHYwLjAuNSB0YWcgYXZhaWxh
YmxlDQoNCg0K
