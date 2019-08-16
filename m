Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D73FE904C5
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 17:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfHPPh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 11:37:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13082 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727217AbfHPPh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 11:37:27 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x7GFavaY030903;
        Fri, 16 Aug 2019 08:37:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=J5KQQbFQpVgV4a3+U600up8dhPZ74CYFNS2VRc/+nnE=;
 b=XU94jvfS8Xcepguu1I/o2wlzSpzPqSbQdnuIAzUYhuxFCCUQF3Oz3XnJGJxmzieeajkF
 6cQsMTxvwzCZvhoXikbTg0O0mLA9popWN+tLXzPmWGwg3yD6eIxW6YcP+gE1ZOTmt5mP
 mI5LC2hiad/N6olkfNWqJ+UVtbUh7QoY0Og= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2uduus8ugt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Aug 2019 08:37:03 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 16 Aug 2019 08:37:02 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 16 Aug 2019 08:37:02 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 16 Aug 2019 08:37:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcKDNfuDQZTRSAwo8EocE9MxPlDPHdOy699BOTvv9D9QHazJ1RpfsCsroS6E8sXAWXxTplOYv0f4xGSt00szK6k1ha9Zy8Oyw0JE55tiN6LId8e8kF/56Kk4Yyp/eLIQVhNV8qLOz4IhXiXOeXeqOUt0JgTFRh1ikEUsM1sGku0QWRMrdZWoptZ7QbdyR48t3AOqFjKZuogBNbEAeyOzxR8pxrLd15rlDjYj2O7VfQ3Bq/l5B/kWqQKekI8OXAw1vpI2bwe8HA7cphKfG9VBbpPjQlbhJVOfJQrPAbtVsTAW8BtgBBBbHH4Cmhlmx76RoE0t4hDnS3BSeYwYKiUNbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5KQQbFQpVgV4a3+U600up8dhPZ74CYFNS2VRc/+nnE=;
 b=P/ZffBJ29OPzkAXusUUMwQmgR/mPGrdG3ovw64ab1Nx2Y/FMxAngXq4BTaZmv+gn5y5z647njCIWmn6rrBhX3AhvGTUWHl1D0ahXfo3Ig4TBZ0x0Z4X2mDhfxPjoxECR6JjaVnQQC6GdA8OlV3zzqPVekbhCOgDDsBOFHVJLxa1zjVcovk8i93xNM6WoOYPhxzykSTGoyMqR5alnLsN+yYZ4JG3jvUJvJKD9G9g5aT9BcewmjOgNwvDCuMGlUeint185/6rbqs6zn6e8pn8a09fvOT38tjgIa/BKZH7895fMybiZ4EIEsEhCuGI5nW6liF7A4agVG9EV/kmbbISWjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5KQQbFQpVgV4a3+U600up8dhPZ74CYFNS2VRc/+nnE=;
 b=Tx9C61yNai8Y6imxfKFBcY2+PIyQAUR/uinCSjAge3fn16CeETelUQWPeCLhe/QO0iXWxKVDvPRMCwj7M995NShrMQF/oF+EaCECVFxro3Lkc84xuwwpWJPhlltaM2L7IljKP/QuKWmi6p1Q/21GZaUeu5a2M5bVjuBxs1niODk=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2773.namprd15.prod.outlook.com (20.179.158.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Fri, 16 Aug 2019 15:37:01 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2157.022; Fri, 16 Aug 2019
 15:37:01 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] libbpf: remove zc variable as it is not used
Thread-Topic: [PATCH bpf-next] libbpf: remove zc variable as it is not used
Thread-Index: AQHVVB0UBQbuYhcu2kKGSGpprEAG2Kb96KYA
Date:   Fri, 16 Aug 2019 15:37:00 +0000
Message-ID: <f3a8ea34-bd70-8ab8-9739-bb086643fa44@fb.com>
References: <1565951171-14439-1-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1565951171-14439-1-git-send-email-magnus.karlsson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR12CA0041.namprd12.prod.outlook.com
 (2603:10b6:301:2::27) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:9590]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae2f9833-153b-402b-f0da-08d7225f94ae
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2773;
x-ms-traffictypediagnostic: BYAPR15MB2773:
x-microsoft-antispam-prvs: <BYAPR15MB277360AF5D34C4EFB4346AFED3AF0@BYAPR15MB2773.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(39860400002)(366004)(136003)(376002)(189003)(199004)(25786009)(256004)(2201001)(7736002)(6116002)(71200400001)(71190400001)(99286004)(8936002)(5660300002)(31696002)(2906002)(478600001)(14454004)(6512007)(11346002)(6436002)(8676002)(486006)(102836004)(476003)(186003)(81156014)(53936002)(2501003)(316002)(6486002)(66556008)(76176011)(53546011)(2616005)(46003)(6246003)(229853002)(66446008)(66946007)(66476007)(386003)(64756008)(86362001)(305945005)(6506007)(52116002)(36756003)(4326008)(81166006)(446003)(31686004)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2773;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NaiEtgGFl9BWf2c59NvCDQvkTxEDmVSjty06Iut1bNYHpUSNDe4XSUVm6W3Hw3xRx5MU2Q96eV0RUU2b26PAJdiCSZN6FIlzf4oFLp9l2VapavLSSm1YlCgXxlD8liPBJPWNZ/bCqCwD4r+zQm3k2ou2CrJ1U/gU8ofj8Q0wzodMeYxn0sNpBeWVKpk0hq3CMF5IayVzqBw6D1+y9FXLJNa8Ww/HDey7zeYmY9dxGzVfSRtHUgKN1rBzFNtAiv2VrKuZqZ8tlCbTx3dcwC//SIvXNb2etr3680AnmkOGe1D+T+ovtDJUZbv2u+Y6gJ2S3dW7XWkwcAjlZjbFaLkVgG3PnnTZq+fof9IhxBXdKjnfWepnt60Q7AfK0SWyvIZo7nlJKM5sM/4RuySfH9wzpjG5BZPjtDvvewCxLtc0c+c=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E7CA108C07F944DB180F95A8534CC03@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ae2f9833-153b-402b-f0da-08d7225f94ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 15:37:01.0033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E/SU3EmKx8BpzjRsEpr86pC87uaqIeC81pGqZp9NXFdhiqrCMtwZjoj0niUNTUxl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2773
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMTYvMTkgMzoyNiBBTSwgTWFnbnVzIEthcmxzc29uIHdyb3RlOg0KPiBUaGUgemMg
aXMgbm90IHVzZWQgaW4gdGhlIHhzayBwYXJ0IG9mIGxpYmJwZiwgc28gbGV0IHVzIHJlbW92ZSBp
dC4gTm90DQo+IGdvb2QgdG8gaGF2ZSBkZWFkIGNvZGUgbHlpbmcgYXJvdW5kLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogTWFnbnVzIEthcmxzc29uIDxtYWdudXMua2FybHNzb25AaW50ZWwuY29tPg0K
PiBSZXBvcnRlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4gPiAtLS0NCj4gICB0b29s
cy9saWIvYnBmL3hzay5jIHwgMyAtLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMyBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS90b29scy9saWIvYnBmL3hzay5jIGIvdG9vbHMvbGliL2Jw
Zi94c2suYw0KPiBpbmRleCA2ODBlNjMwLi45Njg3ZGE5IDEwMDY0NA0KPiAtLS0gYS90b29scy9s
aWIvYnBmL3hzay5jDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYveHNrLmMNCj4gQEAgLTY1LDcgKzY1
LDYgQEAgc3RydWN0IHhza19zb2NrZXQgew0KPiAgIAlpbnQgeHNrc19tYXBfZmQ7DQo+ICAgCV9f
dTMyIHF1ZXVlX2lkOw0KPiAgIAljaGFyIGlmbmFtZVtJRk5BTVNJWl07DQo+IC0JYm9vbCB6YzsN
Cj4gICB9Ow0KPiAgIA0KPiAgIHN0cnVjdCB4c2tfbmxfaW5mbyB7DQo+IEBAIC02MDgsOCArNjA3
LDYgQEAgaW50IHhza19zb2NrZXRfX2NyZWF0ZShzdHJ1Y3QgeHNrX3NvY2tldCAqKnhza19wdHIs
IGNvbnN0IGNoYXIgKmlmbmFtZSwNCj4gICAJCWdvdG8gb3V0X21tYXBfdHg7DQo+ICAgCX0NCj4g
ICANCj4gLQl4c2stPnpjID0gb3B0cy5mbGFncyAmIFhEUF9PUFRJT05TX1pFUk9DT1BZOw0KDQpT
aW5jZSBvcHRzLmZsYWdzIHVzYWdlIGlzIHJlbW92ZWQuIERvIHlvdSB0aGluayBpdCBtYWtlcyBz
ZW5zZSB0bw0KcmVtb3ZlDQogICAgICAgICBvcHRsZW4gPSBzaXplb2Yob3B0cyk7DQogICAgICAg
ICBlcnIgPSBnZXRzb2Nrb3B0KHhzay0+ZmQsIFNPTF9YRFAsIFhEUF9PUFRJT05TLCAmb3B0cywg
Jm9wdGxlbik7DQogICAgICAgICBpZiAoZXJyKSB7DQogICAgICAgICAgICAgICAgIGVyciA9IC1l
cnJubzsNCiAgICAgICAgICAgICAgICAgZ290byBvdXRfbW1hcF90eDsNCiAgICAgICAgIH0NCmFz
IHdlbGwgc2luY2Ugbm9ib2R5IHRoZW4gdXNlcyBvcHRzPw0KDQo+IC0NCj4gICAJaWYgKCEoeHNr
LT5jb25maWcubGliYnBmX2ZsYWdzICYgWFNLX0xJQkJQRl9GTEFHU19fSU5ISUJJVF9QUk9HX0xP
QUQpKSB7DQo+ICAgCQllcnIgPSB4c2tfc2V0dXBfeGRwX3Byb2coeHNrKTsNCj4gICAJCWlmIChl
cnIpDQo+IA0K
