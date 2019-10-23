Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C723BE100C
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 04:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388931AbfJWCeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 22:34:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1414 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729994AbfJWCep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 22:34:45 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9N2U03b006102;
        Tue, 22 Oct 2019 19:34:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gC4eJhqibP7ZuyoOLrQ0sfEhEduC2L7x3XIp8Ats5oY=;
 b=q83X/GDV2CBejFwYKdzHngpJMZuMMRMmoXjAujTgc5xcz4Sg2qcrs8LwXMgALxajly+C
 Swv4iIynLE6UQd7u3mktYiP44yW+roy1w79orQR6ruW5O4dTKeMNvl/QY+BeLFlNyDyQ
 xs21KkCfQYYJOAo4jPtcQ8gDVnd7cIkGv+U= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vt9th8yg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Oct 2019 19:34:30 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 22 Oct 2019 19:34:28 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 22 Oct 2019 19:34:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NW/JCf7r3GFNrZW8c7wBoM8oDVlWHp14QoIS/dBzb9m+O8kUgGPQrWkJc2z4R7VZ/wCuzFxmTpIxX6nV5VYCeY1TizUwTraT3IB0LxNFeo/Ycun7qLD5/JtQdPS1TUEn9Nybh8dcEt0mSja51jzQMc24E7W/a2lbKXP2c3FJx9wtZP4wIsGckuu2JMTzwxZtjVEdBw/ef5gnm1d3B5iwczai0mB0U/RA+v0dbisVQ2o4Bu1yIJCGltycuDj+U7EyN0YT0aEiqDp3rRu+MC5zzUHQkX6Kk19AmZaGEKVpnN7aWOR0kufZnFPZQuXV+o75nR6JY37wh3OgxZDscF5s6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gC4eJhqibP7ZuyoOLrQ0sfEhEduC2L7x3XIp8Ats5oY=;
 b=nJu2jGrp7+IPljQY+zea2L1td5ZfYWkRKQmzSg58nlfY7AXalJObxAWSRy4gHZvesTleeWIFCP+SM/GTVkvaXUlHOTVUmmmsYyINC6ewXNM9dUnul+B5BGob281ia4kXGoZUl7SkKmFMEu00+SlMHYFDiKEz9DMU6LLW5YdIWuMjZHoQNvZG8Jci+L0k4s1hYIiE7N4Ml72yodaOoK31oM/qEKb95DxSsfXuzPcwwdFMaV/djLGpX1DjWyBo35HG/jgbmEyi8x89UkZ9xtXg3Gru2beuSgJehfswc1zk5j8VTXEVznqnR/RvyrUAwZS+Ncm8h3P037KlrtBhIdYY3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gC4eJhqibP7ZuyoOLrQ0sfEhEduC2L7x3XIp8Ats5oY=;
 b=X06longveOWkLMuhjOXRcoQe8QMgVq+MgNr3gMYfps7zLjXnIBO0naaFb3euMzojiMGl3Gf2IC4hMxdaFXnf4masPB9Ly0bS/c6DtO+GmFBI1Ff0T0zGxT09q2om/aTwa1ZR3fquPrlmWwigsoUD1SLlF3gYHEUInTY0m2nuGho=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3254.namprd15.prod.outlook.com (20.179.59.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Wed, 23 Oct 2019 02:34:27 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2387.019; Wed, 23 Oct 2019
 02:34:27 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Prabhakar Kushwaha <prabhakar.pkin@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: Linux-5.4: bpf: test_core_reloc_arrays.o: Segmentation fault with
 llc -march=bpf
Thread-Topic: Linux-5.4: bpf: test_core_reloc_arrays.o: Segmentation fault
 with llc -march=bpf
Thread-Index: AQHViUIqi4sk0mO0YEWOHQh6nT3c5adngjuA
Date:   Wed, 23 Oct 2019 02:34:26 +0000
Message-ID: <6fddbb7c-50e4-2d1f-6f88-1d97107e816f@fb.com>
References: <8080a9a2-82f1-20b5-8d5d-778536f91780@gmail.com>
In-Reply-To: <8080a9a2-82f1-20b5-8d5d-778536f91780@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0073.namprd04.prod.outlook.com
 (2603:10b6:301:3a::14) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::b6b9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 220c1ff0-7206-4bc9-b8b9-08d7576185cc
x-ms-traffictypediagnostic: BYAPR15MB3254:
x-ms-exchange-purlcount: 5
x-microsoft-antispam-prvs: <BYAPR15MB325433407846A71C4114919BD36B0@BYAPR15MB3254.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:222;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(346002)(366004)(136003)(396003)(189003)(199004)(53754006)(31686004)(25786009)(2201001)(478600001)(966005)(86362001)(486006)(5660300002)(31696002)(76176011)(46003)(66446008)(66946007)(476003)(64756008)(66476007)(66556008)(386003)(52116002)(2616005)(6506007)(99286004)(53546011)(11346002)(102836004)(6246003)(446003)(186003)(6512007)(6306002)(71190400001)(36756003)(6116002)(6436002)(229853002)(81166006)(8676002)(81156014)(6486002)(110136005)(8936002)(7736002)(14454004)(256004)(14444005)(305945005)(2906002)(2501003)(316002)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3254;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hVXhbsTGzJ+I+WRFZP08tDQcfYa6x1lp2ZXEQzym9dQIrQlouJ1t0YvTvcL17Msp3kc3901LD1MdO9Drjp7AFGYdwNI+W9YmflM2sRlJcpzGCRrz73MXeIwJ2vFfrduEfxrtnWJNqNmyN72/z8WXCJRHkjRsNqxBJdlAUxMShXQixigN/KoUwsBWq3Ah90s2z1VcaomCXiPIS8R1H/xQOs6qeiK7wLJgewr5nVpYav1KZyucJtoSO+EzSEa2o+oPgANmzwm2g+DPchRt8OOJghAtEs5sLCZxy+3LU/0im53QJgu4wIO2VwwVV3bLO17YCWZxWFy2dwhFURyVVL3+UXe1sKMrgA8beX7j8cyIf7xqHXBGARoOKV5gBThU9rPpP24RnLCLtdY0YZI1F2dXT47q0nnFeQsIu8/ni+heevHIWCKWkVGHar8PCZLyIXfwaiYVNbFZa5LkrRsuFtUYX4NB7McE3d+3n9CdtIVZkOc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3560B218AAC0214ABB6DF2E9B8A4617B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 220c1ff0-7206-4bc9-b8b9-08d7576185cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 02:34:26.5974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7CT9k2rei+qHfXC8uZzst1zOPUvwSBwhri9rTLJKXUCHgCM+46rXAiOs9b0N8mbH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3254
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-23_01:2019-10-22,2019-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 adultscore=0 clxscore=1011 spamscore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910230023
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzIyLzE5IDY6MzUgUE0sIFByYWJoYWthciBLdXNod2FoYSB3cm90ZToNCj4gDQo+
ICAgQWRkaW5nIG90aGVyIG1haWxpbmcgbGlzdCwgZm9sa3MuLi4NCj4gDQo+IEhpIEFsbCwNCj4g
DQo+IEkgYW0gdHJ5aW5nIHRvIGJ1aWxkIGtzZWxmdGVzdCBvbiBMaW51eC01LjQgb24gdWJ1bnR1
IDE4LjA0LiBJIGluc3RhbGxlZA0KPiBMTFZNLTkuMC4wIGFuZCBDbGFuZy05LjAuMCBmcm9tIGJl
bG93IGxpbmtzIGFmdGVyIGZvbGxvd2luZyBzdGVwcyBmcm9tDQo+IFsxXSBiZWNhdXNlIG9mIGRp
c2N1c3Npb24gWzJdDQoNCkNvdWxkIHlvdSB0cnkgbGF0ZXN0IGxsdm0gdHJ1bmsgKHByZS1yZWxl
YXNlIDEwLjAuMCk/DQpMTFZNIDkuMC4wIGhhcyBzb21lIGNvZGVzIGZvciBDT1JFLCBidXQgaXQg
aXMgbm90IGZ1bGx5IHN1cHBvcnRlZCBhbmQNCmhhcyBzb21lIGJ1Z3Mgd2hpY2ggYXJlIG9ubHkg
Zml4ZWQgaW4gTExWTSAxMC4wLjAuIFdlIGludGVuZCB0byBtYWtlDQpsbHZtIDEwIGFzIHRoZSBv
bmUgd2UgY2xhaW0gd2UgaGF2ZSBzdXBwb3J0LiBJbmRlZWQgQ09SRSByZWxhdGVkDQpjaGFuZ2Vz
IGFyZSBtb3N0bHkgYWRkZWQgZHVyaW5nIDEwLjAuMCBkZXZlbG9wbWVudCBwZXJpb2QuDQoNCj4g
DQo+ICAgaHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNB
X19yZWxlYXNlcy5sbHZtLm9yZ185LjAuMF9sbHZtLTJEOS4wLjAuc3JjLnRhci54eiZkPUR3SUNh
USZjPTVWRDBSVHRObFRoM3ljZDQxYjNNVXcmcj1EQThlMUI1cjA3M3ZJcVJyRno3TVJBJm09c2tr
Z2I5cFpGSXVKUkc5SlFOVWNPbnNpTkJvWWVEeEVncm1TdGJGWDRxcyZzPWZDazFNWUl5d1lfV2NK
VTZNbFRxR1Q1S0xMWTk1YjVEaE5NSndTeFV2XzgmZT0NCj4gICBodHRwczovL3VybGRlZmVuc2Uu
cHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX3JlbGVhc2VzLmxsdm0ub3JnXzkuMC4w
X2NsYW5nLTJEdG9vbHMtMkRleHRyYS0yRDkuMC4wLnNyYy50YXIueHomZD1Ed0lDYVEmYz01VkQw
UlR0TmxUaDN5Y2Q0MWIzTVV3JnI9REE4ZTFCNXIwNzN2SXFSckZ6N01SQSZtPXNra2diOXBaRkl1
SlJHOUpRTlVjT25zaU5Cb1llRHhFZ3JtU3RiRlg0cXMmcz0yLVpGVk5zX00wdjZDVC1vVXBVdk5S
eF9VSGpNc3dXUGhLOVhOaXVxTGNrJmU9DQo+ICAgaHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9p
bnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19yZWxlYXNlcy5sbHZtLm9yZ185LjAuMF9jZmUtMkQ5
LjAuMC5zcmMudGFyLnh6JmQ9RHdJQ2FRJmM9NVZEMFJUdE5sVGgzeWNkNDFiM01VdyZyPURBOGUx
QjVyMDczdklxUnJGejdNUkEmbT1za2tnYjlwWkZJdUpSRzlKUU5VY09uc2lOQm9ZZUR4RWdybVN0
YkZYNHFzJnM9QzRpX0Q1QUtUTFRUMGNZZ0h5U2l5LVNPSXVZQ1d2dXN4bEFOajBOckdMWSZlPQ0K
PiANCj4gTm93LCBpIGFtIHRyeWluZyB3aXRoIGxsYyAtbWFyY2g9YnBmLCB3aXRoIHRoaXMgc2Vn
bWVudGF0aW9uIGZhdWx0IGlzDQo+IGNvbWluZyBhcyBiZWxvdzoNCj4gDQo+IGdjYyAtZyAtV2Fs
bCAtTzIgLUkuLi8uLi8uLi9pbmNsdWRlL3VhcGkgLUkuLi8uLi8uLi9saWINCj4gLUkuLi8uLi8u
Li9saWIvYnBmIC1JLi4vLi4vLi4vLi4vaW5jbHVkZS9nZW5lcmF0ZWQgLURIQVZFX0dFTkhEUg0K
PiAtSS4uLy4uLy4uL2luY2x1ZGUgLURicGZfcHJvZ19sb2FkPWJwZl9wcm9nX3Rlc3RfbG9hZA0K
PiAtRGJwZl9sb2FkX3Byb2dyYW09YnBmX3Rlc3RfbG9hZF9wcm9ncmFtICAgIHRlc3RfZmxvd19k
aXNzZWN0b3IuYw0KPiAvdXNyL3NyYy90b3ZhcmRzL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2JwZi90ZXN0X3N0dWIubw0KPiAvdXNyL3NyYy90b3ZhcmRzL2xpbnV4L3Rvb2xzL3Rlc3Rp
bmcvc2VsZnRlc3RzL2JwZi9saWJicGYuYSAtbGNhcCAtbGVsZg0KPiAtbHJ0IC1scHRocmVhZCAt
bw0KPiAvdXNyL3NyYy90b3ZhcmRzL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90
ZXN0X2Zsb3dfZGlzc2VjdG9yDQo+IGdjYyAtZyAtV2FsbCAtTzIgLUkuLi8uLi8uLi9pbmNsdWRl
L3VhcGkgLUkuLi8uLi8uLi9saWINCj4gLUkuLi8uLi8uLi9saWIvYnBmIC1JLi4vLi4vLi4vLi4v
aW5jbHVkZS9nZW5lcmF0ZWQgLURIQVZFX0dFTkhEUg0KPiAtSS4uLy4uLy4uL2luY2x1ZGUgLURi
cGZfcHJvZ19sb2FkPWJwZl9wcm9nX3Rlc3RfbG9hZA0KPiAtRGJwZl9sb2FkX3Byb2dyYW09YnBm
X3Rlc3RfbG9hZF9wcm9ncmFtDQo+IHRlc3RfdGNwX2NoZWNrX3N5bmNvb2tpZV91c2VyLmMNCj4g
L3Vzci9zcmMvdG92YXJkcy9saW51eC90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9z
dHViLm8NCj4gL3Vzci9zcmMvdG92YXJkcy9saW51eC90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9i
cGYvbGliYnBmLmEgLWxjYXAgLWxlbGYNCj4gLWxydCAtbHB0aHJlYWQgLW8NCj4gL3Vzci9zcmMv
dG92YXJkcy9saW51eC90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF90Y3BfY2hlY2tf
c3luY29va2llX3VzZXINCj4gZ2NjIC1nIC1XYWxsIC1PMiAtSS4uLy4uLy4uL2luY2x1ZGUvdWFw
aSAtSS4uLy4uLy4uL2xpYg0KPiAtSS4uLy4uLy4uL2xpYi9icGYgLUkuLi8uLi8uLi8uLi9pbmNs
dWRlL2dlbmVyYXRlZCAtREhBVkVfR0VOSERSDQo+IC1JLi4vLi4vLi4vaW5jbHVkZSAtRGJwZl9w
cm9nX2xvYWQ9YnBmX3Byb2dfdGVzdF9sb2FkDQo+IC1EYnBmX2xvYWRfcHJvZ3JhbT1icGZfdGVz
dF9sb2FkX3Byb2dyYW0gICAgdGVzdF9saXJjX21vZGUyX3VzZXIuYw0KPiAvdXNyL3NyYy90b3Zh
cmRzL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X3N0dWIubw0KPiAvdXNy
L3NyYy90b3ZhcmRzL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9saWJicGYuYSAt
bGNhcCAtbGVsZg0KPiAtbHJ0IC1scHRocmVhZCAtbw0KPiAvdXNyL3NyYy90b3ZhcmRzL2xpbnV4
L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X2xpcmNfbW9kZTJfdXNlcg0KPiAoY2xh
bmcgLUkuIC1JLi9pbmNsdWRlL3VhcGkgLUkuLi8uLi8uLi9pbmNsdWRlL3VhcGkNCj4gLUkvdXNy
L3NyYy90b3ZhcmRzL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi8uLi91c3IvaW5j
bHVkZQ0KPiAtRF9fVEFSR0VUX0FSQ0hfYXJtNjQgLWcgLWlkaXJhZnRlciAvdXNyL2xvY2FsL2lu
Y2x1ZGUgLWlkaXJhZnRlcg0KPiAvdXNyL2xvY2FsL2xpYi9jbGFuZy85LjAuMC9pbmNsdWRlIC1p
ZGlyYWZ0ZXINCj4gL3Vzci9pbmNsdWRlL2FhcmNoNjQtbGludXgtZ251IC1pZGlyYWZ0ZXIgL3Vz
ci9pbmNsdWRlDQo+IC1Xbm8tY29tcGFyZS1kaXN0aW5jdC1wb2ludGVyLXR5cGVzIC1PMiAtdGFy
Z2V0IGJwZiAtZW1pdC1sbHZtIFwNCj4gLWMgcHJvZ3MvdGVzdF9jb3JlX3JlbG9jX2FycmF5cy5j
IC1vIC0gfHwgZWNobyAiY2xhbmcgZmFpbGVkIikgfCBcDQo+IGxsYyAtbWFyY2g9YnBmIC1tY3B1
PXByb2JlICAtZmlsZXR5cGU9b2JqIC1vDQo+IC91c3Ivc3JjL3RvdmFyZHMvbGludXgvdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3RfY29yZV9yZWxvY19hcnJheXMubw0KPiBTdGFjayBk
dW1wOg0KPiAwLiBQcm9ncmFtIGFyZ3VtZW50czogbGxjIC1tYXJjaD1icGYgLW1jcHU9cHJvYmUg
LWZpbGV0eXBlPW9iaiAtbw0KPiAvdXNyL3NyYy90b3ZhcmRzL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2JwZi90ZXN0X2NvcmVfcmVsb2NfYXJyYXlzLm8NCj4gMS4gUnVubmluZyBwYXNz
ICdGdW5jdGlvbiBQYXNzIE1hbmFnZXInIG9uIG1vZHVsZSAnPHN0ZGluPicuDQo+IDIuIFJ1bm5p
bmcgcGFzcyAnQlBGIEFzc2VtYmx5IFByaW50ZXInIG9uIGZ1bmN0aW9uICdAdGVzdF9jb3JlX2Fy
cmF5cycNCj4gIzAgMHgwMDAwYWFhYWM2MThkYjA4IGxsdm06OnN5czo6UHJpbnRTdGFja1RyYWNl
KGxsdm06OnJhd19vc3RyZWFtJikNCj4gKC91c3IvbG9jYWwvYmluL2xsYysweDE1MmViMDgpDQo+
IFNlZ21lbnRhdGlvbiBmYXVsdA0KPiBNYWtlZmlsZToyNjA6IHJlY2lwZSBmb3IgdGFyZ2V0DQo+
ICcvdXNyL3NyYy90b3ZhcmRzL2xpbnV4L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0
X2NvcmVfcmVsb2NfYXJyYXlzLm8nDQo+IGZhaWxlZA0KPiBtYWtlWzFdOiAqKioNCj4gWy91c3Iv
c3JjL3RvdmFyZHMvbGludXgvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3RfY29yZV9y
ZWxvY19hcnJheXMub10NCj4gRXJyb3IgMTM5DQo+IA0KPiBUbyBhZGQgbW9yZSBkZXRhaWxzLA0K
PiBDb21tZW50aW5nIGZvbGxvd2luZyBsaW5lcyBpbiBicGYvcHJvZ3MvdGVzdF9jb3JlX3JlbG9j
X2FycmF5cy5jDQo+IHJlbW92ZXMgdGhlIHNlZ21lbnRhdGlvbiBmYXVsdC4NCj4gDQo+IC0tLSBh
L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy90ZXN0X2NvcmVfcmVsb2NfYXJyYXlz
LmMNCj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3RfY29yZV9y
ZWxvY19hcnJheXMuYw0KPiBAQCAtNDEsMTUgKzQxLDE0IEBAIGludCB0ZXN0X2NvcmVfYXJyYXlz
KHZvaWQgKmN0eCkNCj4gICAgICAgICAgaWYgKEJQRl9DT1JFX1JFQUQoJm91dC0+YTIsICZpbi0+
YVsyXSkpDQo+ICAgICAgICAgICAgICAgICAgcmV0dXJuIDE7DQo+ICAgICAgICAgIC8qIGluLT5i
WzFdWzJdWzNdICovDQo+IC0gICAgICAgaWYgKEJQRl9DT1JFX1JFQUQoJm91dC0+YjEyMywgJmlu
LT5iWzFdWzJdWzNdKSkNCj4gLSAgICAgICAgICAgICAgIHJldHVybiAxOw0KPiArLy8gICAgIGlm
IChCUEZfQ09SRV9SRUFEKCZvdXQtPmIxMjMsICZpbi0+YlsxXVsyXVszXSkpDQo+ICsvLyAgICAg
ICAgICAgICByZXR1cm4gMTsNCj4gICAgICAgICAgLyogaW4tPmNbMV0uYyAqLw0KPiAgICAgICAg
ICBpZiAoQlBGX0NPUkVfUkVBRCgmb3V0LT5jMWMsICZpbi0+Y1sxXS5jKSkNCj4gICAgICAgICAg
ICAgICAgICByZXR1cm4gMTsNCj4gICAgICAgICAgLyogaW4tPmRbMF1bMF0uZCAqLw0KPiAtICAg
ICAgIGlmIChCUEZfQ09SRV9SRUFEKCZvdXQtPmQwMGQsICZpbi0+ZFswXVswXS5kKSkNCj4gLSAg
ICAgICAgICAgICAgIHJldHVybiAxOw0KPiAtDQo+ICsvLyAgICAgaWYgKEJQRl9DT1JFX1JFQUQo
Jm91dC0+ZDAwZCwgJmluLT5kWzBdWzBdLmQpKQ0KPiArLy8gICAgICAgICAgICAgcmV0dXJuIDE7
DQo+ICAgICAgICAgIHJldHVybiAwOw0KPiAgIH0NCj4gDQo+IEl0IGxvb2tzIHRvIGJlIHNvbWV0
aGluZyByZWxhdGVkIGxsYyBhbmQgbW9yZSB0aGFuIDEgZGltZW5zaW9uIGFycmF5Lg0KPiBoYXMg
YW55b25lIGZhY2VkIHN1Y2ggZXJyb3IuDQo+IA0KPiBQbGVhc2Ugc3VnZ2VzdCEhDQo+IA0KPiAt
LXByYWJoYWthcihwaykNCj4gDQo+IFsxXQ0KPiBodHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2lu
dC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX3N0YWNrb3ZlcmZsb3cuY29tX3F1ZXN0aW9uc180NzI1
NTUyNl9ob3ctMkR0by0yRGJ1aWxkLTJEdGhlLTJEbGF0ZXN0LTJEY2xhbmctMkR0aWR5JmQ9RHdJ
Q2FRJmM9NVZEMFJUdE5sVGgzeWNkNDFiM01VdyZyPURBOGUxQjVyMDczdklxUnJGejdNUkEmbT1z
a2tnYjlwWkZJdUpSRzlKUU5VY09uc2lOQm9ZZUR4RWdybVN0YkZYNHFzJnM9VGRNSE9sOS1pZDdM
aV9YV0ZuclRlZmRLOHlQVU8xTlVZcjd1OUFKZGcxRSZlPQ0KPiANCj4gWzJdIGh0dHBzOi8vdXJs
ZGVmZW5zZS5wcm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRwcy0zQV9fd3d3Lm1haWwtMkRhcmNo
aXZlLmNvbV9uZXRkZXYtNDB2Z2VyLmtlcm5lbC5vcmdfbXNnMzE1MDk2Lmh0bWwmZD1Ed0lDYVEm
Yz01VkQwUlR0TmxUaDN5Y2Q0MWIzTVV3JnI9REE4ZTFCNXIwNzN2SXFSckZ6N01SQSZtPXNra2di
OXBaRkl1SlJHOUpRTlVjT25zaU5Cb1llRHhFZ3JtU3RiRlg0cXMmcz1nWVNfQ2ZCbEFRRzRnRDNQ
eENFZzgyYTV2QkYyaHBaanZ2bVhGYUtPcGhZJmU9DQo+IA0KPiANCj4gTGludXggdG9wLWNvbW1p
dA0KPiAtLS0tLS0tLS0tLS0tLS0tDQo+IGNvbW1pdCBiYzg4Zjg1YzZjMDkzMDZiZDIxOTE3ZTFh
ZTI4MjA1ZTljZDc3NWE3IChIRUFEIC0+IG1hc3RlciwNCj4gb3JpZ2luL21hc3Rlciwgb3JpZ2lu
L0hFQUQpDQo+IEF1dGhvcjogQmVuIERvb2tzIDxiZW4uZG9va3NAY29kZXRoaW5rLmNvLnVrPg0K
PiBEYXRlOiAgIFdlZCBPY3QgMTYgMTI6MjQ6NTggMjAxOSArMDEwMA0KPiANCj4gICAgICBrdGhy
ZWFkOiBtYWtlIF9fa3RocmVhZF9xdWV1ZV9kZWxheWVkX3dvcmsgc3RhdGljDQo+IA0KPiAgICAg
IFRoZSBfX2t0aHJlYWRfcXVldWVfZGVsYXllZF93b3JrIGlzIG5vdCBleHBvcnRlZCBzbw0KPiAg
ICAgIG1ha2UgaXQgc3RhdGljLCB0byBhdm9pZCB0aGUgZm9sbG93aW5nIHNwYXJzZSB3YXJuaW5n
Og0KPiANCj4gICAgICAgIGtlcm5lbC9rdGhyZWFkLmM6ODY5OjY6IHdhcm5pbmc6IHN5bWJvbA0K
PiAnX19rdGhyZWFkX3F1ZXVlX2RlbGF5ZWRfd29yaycgd2FzIG5vdCBkZWNsYXJlZC4gU2hvdWxk
IGl0IGJlIHN0YXRpYz8NCj4gDQo+ICAgICAgU2lnbmVkLW9mZi1ieTogQmVuIERvb2tzIDxiZW4u
ZG9va3NAY29kZXRoaW5rLmNvLnVrPg0KPiAgICAgIFNpZ25lZC1vZmYtYnk6IExpbnVzIFRvcnZh
bGRzIDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4NCj4gDQo=
