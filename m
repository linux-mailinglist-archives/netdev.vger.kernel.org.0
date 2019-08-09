Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8981E87139
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfHIFGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:06:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50666 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725879AbfHIFGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:06:22 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7950K5n021410;
        Thu, 8 Aug 2019 22:06:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7JyPT7n9xNbl+nbu0undww+t6BFn8DfqjUG+rodTVlA=;
 b=hqk5Lz9l6vXksq7w1xn4MolMYENormSnwnn/c/SK+GuZyANuYoQ3FxYvQDOBfszQHXeG
 VC65JKJ/exe94TYQpa1pl0/1wiKK6D/U1bdKTHuU2w0PSNEl3a4O9xGKD54yKojkr1k7
 5CTmcIbFNqO9JU30iN/BLd0/jTzybHPmikM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u8x54rpth-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 22:06:03 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 8 Aug 2019 22:06:02 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 8 Aug 2019 22:06:01 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Aug 2019 22:06:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfV3pdcQAM3ptI2jKTqktdOaxqGr50v23b5qQV6cYGCI5iTKJHjky3yOpf6/m4M6hBsOgT4pgh2oR5UfJU/PeVX0COvXZb0FFrVxAs1BBu2/aPABA1vRkRW1PSSlkHl17oSUExfNVhp8gir37aDcHHlHwlBuFmOFqBvBEouwJkaBU8mCclbM1zVzCyXUa+qZYwWyUSqRv8X/u5nf48hQZwl8kFXuqSF5Ge8nEY3rI1Yz44wCmPyyG9xP98l9aRPIcPmP5HZrgVezw6WpM1boSGGqNCH8AAhb3lNVy0lm60NX6upu/6D5tMU8DiMgkkYi/tBatMiUUi3ZJ/HILaguqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JyPT7n9xNbl+nbu0undww+t6BFn8DfqjUG+rodTVlA=;
 b=dx/Zv4BrJKlw/lzIiIE5Cd0m3jaYxUj9mUttI5DS8UIJUyaRTzX83eocRbpbyYgcMaBLD72mgwk2OsSgnD/MEedeBvSUoCQESSZVo5jTQ9thrH5aG6w+gvWljPgYH+xMnhaQqWf0MJy2Aoft7OeGr3zIrRfFPDG02gD9dMkx3hmbw7umkNA2fskX7T4zIxHVcAkDaIbbsvdDs36y7wX1/AcIHfaWkGSkTloZULbpUiZh0JtHcRRFIvJA8v6jnJco1slgcQoyNAA5GdnGKztIXABFoWMibN3vj369Dwgq8xZtasiLqNTmBFXf1bkPGFvVRTjrRTOnUo7D7gWjMlS7ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JyPT7n9xNbl+nbu0undww+t6BFn8DfqjUG+rodTVlA=;
 b=O3IR8ER6SIzc5U52PkTMc88WnzcQBtnPcOiA70YishO32CImtlQkZQjFBcykoRRd1RpI45MG89/jbQniBWBmSsjpnAivzlwkOzWz5RrdhSQdtz548ysImP/XQrTZWbsvEabQLs6+I0OyUWZFNYGF3wkoZIgUdD9AAbMfiWEB09Q=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1742.namprd15.prod.outlook.com (10.174.100.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Fri, 9 Aug 2019 05:06:01 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.015; Fri, 9 Aug 2019
 05:06:00 +0000
From:   Tao Ren <taoren@fb.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v5 2/3] net: phy: add support for clause 37
 auto-negotiation
Thread-Topic: [PATCH net-next v5 2/3] net: phy: add support for clause 37
 auto-negotiation
Thread-Index: AQHVTm8RhewcCGyi/kCgzuyicgXqEqbyQ2OA
Date:   Fri, 9 Aug 2019 05:06:00 +0000
Message-ID: <ace7964a-86ac-5c7b-1a9e-3c40e567c78f@fb.com>
References: <20190808234816.4189789-1-taoren@fb.com>
 <CA+h21hpcmpXZZrN6NYwAMhqrOKK2oGq27iiRiDBFT-zAvvZfWA@mail.gmail.com>
In-Reply-To: <CA+h21hpcmpXZZrN6NYwAMhqrOKK2oGq27iiRiDBFT-zAvvZfWA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0150.namprd04.prod.outlook.com (2603:10b6:104::28)
 To MWHPR15MB1216.namprd15.prod.outlook.com (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::89dc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 337331c6-ce70-4797-2ffa-08d71c874556
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1742;
x-ms-traffictypediagnostic: MWHPR15MB1742:
x-microsoft-antispam-prvs: <MWHPR15MB1742BE29325DC290952A06E8B2D60@MWHPR15MB1742.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(346002)(366004)(376002)(39860400002)(189003)(199004)(46003)(86362001)(8936002)(6246003)(25786009)(53936002)(6916009)(71190400001)(71200400001)(64126003)(31696002)(14454004)(6116002)(256004)(2906002)(2616005)(4326008)(476003)(6486002)(6436002)(486006)(11346002)(5660300002)(31686004)(305945005)(7736002)(446003)(64756008)(66476007)(65826007)(4744005)(7416002)(65806001)(316002)(36756003)(66446008)(66556008)(102836004)(386003)(58126008)(54906003)(53546011)(6506007)(66946007)(1411001)(76176011)(478600001)(65956001)(99286004)(6512007)(52116002)(8676002)(229853002)(186003)(81166006)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1742;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mYzBj7c7ufpq19d1aodcEPzJq8BqNa6yJSl9+WZnkrAWJnRKYmEj2MdkLPJ4D7kmf2iwC4qdS4hs+Z/YIvqHCdlBtZyDTvP0d0zmjdsG5hQkoUWbUKySiB9ExCIZOCcJMmk5U1hige8sVi6HLdy1lSFt1/iSBKz8mHit0NvLLvT4HwEm1CQGb1ypscm6LkRwJA0KsRTkDSsA/ddessIlkuELaaZ0RWoYUR8YXJLsjp+HZNDPMEo84m3POgCnkuA429Tb9+YiaMkXEuqkAyl0/aBN4Jf65Xq4dVsrNfYX0KQ4tnEpepWvSbTayap0SQQ2r7V/klV6E1UAHr58Qnr7oGxEy0XFPq7pEn6cSQq5MwSoiR/shDpCSPnNzz9uP/EYLbDxUJhMz7lt/xuWMa0wYPGjdDbeamE2GgHybmGPlPs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B199D0818D0D084CB48A88EE0A0907A5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 337331c6-ce70-4797-2ffa-08d71c874556
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 05:06:00.8052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ALeQ1BRIMqRoFGGrcESrcBNxwEs62fM2Q0TZNG7FY3SxSV3ihp0+7cCM2FtY8sox
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1742
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=865 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC84LzE5IDk6NTggUE0sIFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4gT24gRnJpLCA5IEF1
ZyAyMDE5IGF0IDAyOjQ4LCBUYW8gUmVuIDx0YW9yZW5AZmIuY29tPiB3cm90ZToNCj4+DQo+PiBG
cm9tOiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPg0KPj4NCj4+IFRoaXMg
cGF0Y2ggYWRkcyBzdXBwb3J0IGZvciBjbGF1c2UgMzcgMTAwMEJhc2UtWCBhdXRvLW5lZ290aWF0
aW9uLg0KPj4gSXQncyBjb21waWxlLXRlc3RlZCBvbmx5IGFzIEkgZG9uJ3QgaGF2ZSBmaWJlciBl
cXVpcG1lbnQuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogSGVpbmVyIEthbGx3ZWl0IDxoa2FsbHdl
aXQxQGdtYWlsLmNvbT4NCj4+IC0tLQ0KPiANCj4gVGhpcyBuZWVkcyB5b3VyIHNpZ25lZC1vZmYt
YnkgYXMgd2VsbC4NCg0KSSBzZWUuIEkgZGlkbid0IHVuZGVyc3RhbmQgc2lnbmVkLW9mZi1ieSBj
b3JyZWN0bHkgYW5kIHJlbW92ZWQgbXlzZWxmIGZyb20gdGhlIGxpc3QgZXhwbGljaXRseS4gQWRk
aW5nIGl0IGJhY2sgbm93Li4NCg0KDQpUaGFua3MsDQoNClRhbw0K
