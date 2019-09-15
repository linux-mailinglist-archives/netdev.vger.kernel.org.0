Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C4BB2E97
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 08:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfIOGPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 02:15:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2560 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726167AbfIOGPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 02:15:54 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8F6AE6i000891;
        Sat, 14 Sep 2019 23:15:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=a9BHm7LQ7D86DcssRjdBO23bqjxkbSCbFSzbzZJKYqU=;
 b=FQQhywHXIQ6G1STEDTU/8YNtOXXCFj7raeRAGKudeiFNWa4f0gw3GZRVcRwxOmGHoJM8
 FHKheCu5rEw1REG6owenTXYQDfwv4+hVI/ZvmXX1WvtPz650QZuOREsSdS4rXfA30AGu
 7l0EAqrjqfcn67fCiBypqSdlBbL9W6qpjb0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2v0v8atrx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 14 Sep 2019 23:15:33 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 14 Sep 2019 23:15:32 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 14 Sep 2019 23:15:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BcGoTj8lD9sYLwFkHKnnNNaNTwVgABtgWubrLB8spdiEKMklwrIw+lI1Z/kGFZFNJoxxLJ+JzNMJpzqlJM2PZqsuaya2pr1mTqUFokNPZX9JF9y2pVyhNLa16wqYymLXGMsHBTq3eQyhMqXRHt+BAvn+po3WDYimSI76ticDy/bZWOCpm/3iY8m88XIlHtr+gjkIDoymGwT7OTe2o6lWmrqU9k7aDpjYV8bknaIaAVipvmA0Fb+/AN6NKGShEmLY447S/VTqmhaO/5Z3/I9ATiPUfcdfPKa7cfhhB1O3lyJGLk1bX11HANdLY9lgrP0MPBEmgY5jgKyDkxWK9Zzb6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9BHm7LQ7D86DcssRjdBO23bqjxkbSCbFSzbzZJKYqU=;
 b=I6BOZ3fzQA35beH+i+QjnkEV8jDGw/w2VteGaZV1qN17EXKgYU18Prch3h4ghvmtbUNERp3hJGCdN3xO2p++pDxZXhXZNGiQAY2f9ygSiU3nd1s85/Lwdb99A9D+oXe/LwzWznEf8SG/G0rfJeFUzOYhvJ0qkL3sZnwvag7q9/oJFv099XyNGJ6wD+BrIHg9+Tds90BNi6JAoKuhZG4jTQh3kKlGrWysdgHavRcRGyA9PVdJPoYgJwwdre4gL1jmfY1EpBQh8FaNH0TIUOh3+VL5GWmeljJCoIEYTdOhDBQ6wqkmc70r87Rn0w7I3JKttFwhIQscFapZ0gMGi7kFhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9BHm7LQ7D86DcssRjdBO23bqjxkbSCbFSzbzZJKYqU=;
 b=TtUiShQd+vUkMilC9bHEImwJuFsq0fh6d7NIGRSBHGawmstMFsyUGbQ/lrFAgfeQcwv7gMBC3hOBZ2WUihKlSOm7QR26fe82P6rPPmioVTsB0p+P28wCGyn2O6/1b5+/kW7PCjTDurA14ffMWPEBUBDk84boOUvmp12xiFGrbPI=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1806.namprd15.prod.outlook.com (10.174.255.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Sun, 15 Sep 2019 06:15:30 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2980:5c7f:8dde:174a]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2980:5c7f:8dde:174a%9]) with mapi id 15.20.2263.021; Sun, 15 Sep 2019
 06:15:30 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v8 2/3] net: phy: add support for clause 37
 auto-negotiation
Thread-Topic: [PATCH net-next v8 2/3] net: phy: add support for clause 37
 auto-negotiation
Thread-Index: AQHVZ1Bi3JE3p3zeEkCydFApWQwsCKcrP8IAgAELiYA=
Date:   Sun, 15 Sep 2019 06:15:30 +0000
Message-ID: <f18aece7-f554-751a-dcfb-f897a196a732@fb.com>
References: <20190909204906.2191290-1-taoren@fb.com>
 <20190914141752.GC27922@lunn.ch>
In-Reply-To: <20190914141752.GC27922@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:300:117::14) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::7bb3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f36ccd1-b0a8-44a5-70c4-08d739a41beb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1806;
x-ms-traffictypediagnostic: MWHPR15MB1806:
x-microsoft-antispam-prvs: <MWHPR15MB1806FABFD02E0967EA96049DB28D0@MWHPR15MB1806.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-forefront-prvs: 01613DFDC8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(39860400002)(136003)(396003)(346002)(199004)(189003)(65956001)(65806001)(64756008)(66476007)(66446008)(66556008)(4744005)(66946007)(5660300002)(71190400001)(256004)(6436002)(6486002)(2616005)(71200400001)(52116002)(305945005)(7416002)(478600001)(58126008)(14454004)(102836004)(186003)(7736002)(386003)(229853002)(6506007)(76176011)(46003)(316002)(53546011)(54906003)(446003)(4326008)(31696002)(6116002)(476003)(99286004)(2906002)(11346002)(31686004)(6246003)(6916009)(36756003)(8676002)(6512007)(8936002)(486006)(81166006)(81156014)(86362001)(53936002)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1806;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1J7/ZGyWThGBjjjOyPbdc2RaSZUuS/ZO7FQSQe1UNm6IlLTj61l9I+Q2DEXUDljBu7YOgv5dwZ8Vh87oGdaY9U9ywnaLFHd2t1elbiVQsj4kJkg7WAfOxxQWb2/6dXHoSLzsxn4HZFgd1H6C3O+C5P18PBEG5Dp0gSBYZneO6HnQuZrFoJP4aEA6aAPGyJwHLySjsbPFUt5933Eb6/SGZfCdC5V6NapH1L6HjkV0+nOvKH3WQkcN1lZiL2Q/iDldUnkXeQSwkIcs1nA1B0Rxhf3eFckR/Sgkwb4RObNWU3wBVXhjpI7GEBeCoLLJ2QYBThB+X9TxZ9dNtt09Z7Ur2s9K2+K+enG/dOtV5duQ9YwMQ4M+NTNv3GmFad93h+12VPZGktCaFF/KEA51bb/U4QsijGSTO1acpL5wdPsv2PY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <19698D688129664786101BD59921B40C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f36ccd1-b0a8-44a5-70c4-08d739a41beb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2019 06:15:30.5257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A/YjFhRQRV0+Y2EFAq/XtjHiJ+NBVHA8rLeG7g1zfDuU2ZR1mAK5Py3BcGpvfMbC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1806
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-15_03:2019-09-11,2019-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 adultscore=0 mlxlogscore=832 priorityscore=1501 malwarescore=0 bulkscore=0
 spamscore=0 clxscore=1011 suspectscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909150067
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS8xNC8xOSA3OjE3IEFNLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gT24gTW9uLCBTZXAgMDks
IDIwMTkgYXQgMDE6NDk6MDZQTSAtMDcwMCwgVGFvIFJlbiB3cm90ZToNCj4+IEZyb206IEhlaW5l
ciBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+DQo+Pg0KPj4gVGhpcyBwYXRjaCBhZGRz
IHN1cHBvcnQgZm9yIGNsYXVzZSAzNyAxMDAwQmFzZS1YIGF1dG8tbmVnb3RpYXRpb24uDQo+Pg0K
Pj4gU2lnbmVkLW9mZi1ieTogSGVpbmVyIEthbGx3ZWl0IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4N
Cj4+IFNpZ25lZC1vZmYtYnk6IFRhbyBSZW4gPHRhb3JlbkBmYi5jb20+DQo+PiBUZXN0ZWQtYnk6
IFJlbsOpIHZhbiBEb3JzdCA8b3BlbnNvdXJjZUB2ZG9yc3QuY29tPg0KPiANCj4gUmV2aWV3ZWQt
Ynk6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gDQo+ICAgICBBbmRyZXcNCg0KVGhh
bmtzIGEgbG90LCBBbmRyZXcuDQoNCg0KQ2hlZXJzLA0KDQpUYW8NCg==
