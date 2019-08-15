Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45BF28F788
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 01:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387720AbfHOXUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 19:20:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7160 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731922AbfHOXUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 19:20:18 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7FNK4M1022921;
        Thu, 15 Aug 2019 16:20:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=HXL8Amq4HIBrgJm+yjAOcskRNrxOUrE00wAmAadIaIg=;
 b=X/azAbIjWLRdFLoG+jGkO+BJll99TYi7LHQuFH5JDF2NO3OdLU5dwoXb3lhSJuHCump3
 X23rvIB4Ur0DwIeybZvlrzE3Fm5gG62EEGdbLJeozupkibfnVBYq8FOOoolS3rExIGi6
 kO84tP5TrTUUSnyK2JQGzafmWkHlKuou/oc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2udemsrmq7-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 15 Aug 2019 16:20:08 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 15 Aug 2019 16:19:49 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 15 Aug 2019 16:19:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzPU2NreAiNVNAfAjZggew7ezLFr34oEt0AllAihR76Ii47aVIyQ/fKIPXgeErRE5UbEreO50mhY1hvQ8NeVkkNNvqaLxsGt7dIO3BJ9ZL+7MobHAB9x1fI/0GzQ5XdICoqLejT6GnIkALqvETvwNe5g1vunsmcByZ+HUjeTud8m+ohacaAQ8APyH8tb5aCtbxlqDqHIA/bDPj9zWFPCBITXQWxWzYtKx8XzV5FQJHwLst1K4h0UdexBI/17NodaiReqAqem9w9B8woei99C3hYjXRLN5N23fVl2YONNl4LmYQJbz5oTcOZx6MyZcMRW6CZkNyvTo+2L8zU1Azb+Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXL8Amq4HIBrgJm+yjAOcskRNrxOUrE00wAmAadIaIg=;
 b=hcqomFymrKgEDTudPuP5PMrLgxBsjF7T9U47J7E7mR1NhMs5U5k/uXZcW88XMpCHI1Cqm17B3/pN7sYT3JmYC8cVXLVCXQ5sjw7QGx026Zy44N+W7H/gXtw9O9v83UzcVEmkTZGcgaUTzzFsJeqdyUpIdWWXT+BmpyABkRej6x858lGaJ4DwHxP9lXEEGg22UiurONiQmbVAlgYb9WmBRatNrPdtFCkza8K86Q+hujp8yEs5PdPt/uUKEwAT+7XwTADXIGJJByHUqP5DabHbyfrwZP81bhA0fiIZUFNRBqvXgxBYP5pd5pG/ZrLMsRc0qad01M9AhzVKZ+NeybKW2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXL8Amq4HIBrgJm+yjAOcskRNrxOUrE00wAmAadIaIg=;
 b=JS7mDC559VaBTALJ4bOaOXtlE4NhHNj69Cfx/4OAFs3IE1ScAJuw5WJY5rWodaSPLQpG7a423RUN9pGMzEAeluU9vGLYikorjIppore+9B/43G0IJP1ccHb9E/1eKAUjZIEkzZsvtq070Yxt6Cu4zITzImY01VtBnTeu5zBCypI=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1856.namprd15.prod.outlook.com (10.174.255.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 15 Aug 2019 23:19:30 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 23:19:30 +0000
From:   Tao Ren <taoren@fb.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v7 3/3] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
Thread-Topic: [PATCH net-next v7 3/3] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
Thread-Index: AQHVUJ5qOj7KTUEtsUuopmpFoA8EiKb8Z2AAgAB1/ICAAAEqgA==
Date:   Thu, 15 Aug 2019 23:19:29 +0000
Message-ID: <d481e56e-cf6d-ffd2-e6c5-71e0c29ac8b7@fb.com>
References: <20190811234016.3674056-1-taoren@fb.com>
 <fee3faa1-2de1-b480-983e-07f4587f2f79@fb.com>
 <CA+h21hr-uiCAQTXerg8ScKhnVhT15pM70m_Jw_f=gZrt1DCRkw@mail.gmail.com>
In-Reply-To: <CA+h21hr-uiCAQTXerg8ScKhnVhT15pM70m_Jw_f=gZrt1DCRkw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0069.namprd07.prod.outlook.com
 (2603:10b6:a03:60::46) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:70f6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2cb6e340-e5a3-4abb-c46c-08d721d705ef
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1856;
x-ms-traffictypediagnostic: MWHPR15MB1856:
x-microsoft-antispam-prvs: <MWHPR15MB18566722AD8C0A28480D5C65B2AC0@MWHPR15MB1856.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(136003)(39860400002)(346002)(189003)(199004)(486006)(25786009)(81156014)(6116002)(6486002)(66946007)(446003)(86362001)(81166006)(7416002)(476003)(2616005)(66446008)(64756008)(66556008)(66476007)(53546011)(6506007)(386003)(6436002)(11346002)(99286004)(1411001)(6916009)(52116002)(76176011)(305945005)(5660300002)(7736002)(6246003)(4326008)(102836004)(2906002)(36756003)(229853002)(71190400001)(58126008)(8936002)(6512007)(71200400001)(54906003)(31686004)(14454004)(53936002)(316002)(31696002)(65956001)(186003)(256004)(64126003)(65806001)(65826007)(46003)(478600001)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1856;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JpSN2EhXYlp0IZoouEFqhAzwRPrYnjGTQCXy0AH5z0Soz8g3eEU694W6g1BeKj17r1vi5SLc7hichJYuYbFsw6vkeNar5eHnWrO9/ByIc1fNtWghEsg2Dtf8H+x6fF7SGYy+CRTV45soPcVy2vqVzvG/03YedBWuFOEdcfiTXQ1CS3lHL07Bi49NIEAqT9h5wMv3kXrjmUAMQnR26tYNuSXIjsDv1utaPH9S4TvmQ/fIHxYMW8Arfob3lUrK///Pyq8s4VpuUXYLdPcARA1kyvhvX/CY2rHIu3Lr5jBSHv/wYIz+E0cuutzLNfFzAxXps6AD34Y0oYKBKXgLF+fKyEb02VozLx6qp70GXSUUdVGG0I0O09FJfGFbz9shm1QalfK1eLlPPch5SPiQnBU65ue9gXUcQLXcq+qqxbUDqOg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <19C99019696A7E4DA76E3696B2A9CCB3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cb6e340-e5a3-4abb-c46c-08d721d705ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 23:19:29.9878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0gSbmeQYNb+Necv7/A9nDfYdukhmSgkcZi1n7GZUUYzxhqDuT9DQNd021Q1glZmq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1856
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-15_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=653 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908150223
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8xNS8xOSA0OjE1IFBNLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+IEhpIFRhbywNCj4g
DQo+IE9uIEZyaSwgMTYgQXVnIDIwMTkgYXQgMDI6MTMsIFRhbyBSZW4gPHRhb3JlbkBmYi5jb20+
IHdyb3RlOg0KPj4NCj4+IEhpIEFuZHJldyAvIEZsb3JpYW4gLyBIZWluZXIgLyBWbGFkaW1pciwN
Cj4+DQo+PiBBbnkgZnVydGhlciBzdWdnZXN0aW9ucyBvbiB0aGUgcGF0Y2ggc2VyaWVzPw0KPj4N
Cj4+DQo+PiBUaGFua3MsDQo+Pg0KPj4gVGFvDQo+Pg0KPj4gT24gOC8xMS8xOSA0OjQwIFBNLCBU
YW8gUmVuIHdyb3RlOg0KPj4+IFRoZSBCQ001NDYxNlMgUEhZIGNhbm5vdCB3b3JrIHByb3Blcmx5
IGluIFJHTUlJLT4xMDAwQmFzZS1YIG1vZGUsIG1haW5seQ0KPj4+IGJlY2F1c2UgZ2VucGh5IGZ1
bmN0aW9ucyBhcmUgZGVzaWduZWQgZm9yIGNvcHBlciBsaW5rcywgYW5kIDEwMDBCYXNlLVgNCj4+
PiAoY2xhdXNlIDM3KSBhdXRvIG5lZ290aWF0aW9uIG5lZWRzIHRvIGJlIGhhbmRsZWQgZGlmZmVy
ZW50bHkuDQo+Pj4NCj4+PiBUaGlzIHBhdGNoIGVuYWJsZXMgMTAwMEJhc2UtWCBzdXBwb3J0IGZv
ciBCQ001NDYxNlMgYnkgY3VzdG9taXppbmcgMw0KPj4+IGRyaXZlciBjYWxsYmFja3MsIGFuZCBp
dCdzIHZlcmlmaWVkIHRvIGJlIHdvcmtpbmcgb24gRmFjZWJvb2sgQ01NIEJNQw0KPj4+IHBsYXRm
b3JtIChSR01JSS0+MTAwMEJhc2UtS1gpOg0KPj4+DQo+Pj4gICAtIHByb2JlOiBwcm9iZSBjYWxs
YmFjayBkZXRlY3RzIFBIWSdzIG9wZXJhdGlvbiBtb2RlIGJhc2VkIG9uDQo+Pj4gICAgIElOVEVS
Rl9TRUxbMTowXSBwaW5zIGFuZCAxMDAwWC8xMDBGWCBzZWxlY3Rpb24gYml0IGluIFNlckRFUyAx
MDAtRlgNCj4+PiAgICAgQ29udHJvbCByZWdpc3Rlci4NCj4+Pg0KPj4+ICAgLSBjb25maWdfYW5l
ZzogY2FsbHMgZ2VucGh5X2MzN19jb25maWdfYW5lZyB3aGVuIHRoZSBQSFkgaXMgcnVubmluZyBp
bg0KPj4+ICAgICAxMDAwQmFzZS1YIG1vZGU7IG90aGVyd2lzZSwgZ2VucGh5X2NvbmZpZ19hbmVn
IHdpbGwgYmUgY2FsbGVkLg0KPj4+DQo+Pj4gICAtIHJlYWRfc3RhdHVzOiBjYWxscyBnZW5waHlf
YzM3X3JlYWRfc3RhdHVzIHdoZW4gdGhlIFBIWSBpcyBydW5uaW5nIGluDQo+Pj4gICAgIDEwMDBC
YXNlLVggbW9kZTsgb3RoZXJ3aXNlLCBnZW5waHlfcmVhZF9zdGF0dXMgd2lsbCBiZSBjYWxsZWQu
DQo+Pj4NCj4+PiBOb3RlOiBCQ001NDYxNlMgUEhZIGNhbiBhbHNvIGJlIGNvbmZpZ3VyZWQgaW4g
UkdNSUktPjEwMEJhc2UtRlggbW9kZSwgYW5kDQo+Pj4gMTAwQmFzZS1GWCBzdXBwb3J0IGlzIG5v
dCBhdmFpbGFibGUgYXMgb2Ygbm93Lg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogVGFvIFJlbiA8
dGFvcmVuQGZiLmNvbT4NCj4+PiAtLS0NCj4gDQo+IFRoZSBwYXRjaHNldCBsb29rcyBnb29kIHRv
IG1lLiBIb3dldmVyIEkgYW0gbm90IGEgbWFpbnRhaW5lci4NCj4gSWYgaXQgaGVscHMsDQo+IA0K
PiBBY2tlZC1ieTogVmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4NCg0KVGhhbmsg
eW91IFZsYWRpbWlyIQ0KDQoNCkNoZWVycywNCg0KVGFvDQo=
