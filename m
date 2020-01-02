Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDCB12EA1B
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 19:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgABS4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 13:56:43 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6784 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727951AbgABS4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 13:56:42 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 002IqZhs008348;
        Thu, 2 Jan 2020 10:56:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=PN6Ey2Usone41hog2N5ThwwMNZdc9RzobwGcqx5jMHo=;
 b=YSKX/O3bs5CvfKjyPLQYAeX1cQ+9WiuPkP3VlpTORBID5z7FWR4zHjVdgkFaob83TlSu
 6fEtYZ5m+kSx2uiJtAMm5HvgTOJYu8MQ09IP7ipd9/wp+rBSrx79OSqCSo9nUGZel3yE
 4pFSsMvzFmc9ZS7lnoacTApHp2q3N/CXk4M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 2x9ddw20vf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 02 Jan 2020 10:56:22 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 2 Jan 2020 10:56:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4J8xKLmdOXR1jpq+lziyFaYVPTjmehskmoc34HZxaRMqMn9bUklhDrmd+8ko1945QnhAxGoaw+rVear+vdXJC4p2dVu1mSTWVRq63nCinO5vf1ATtGeUuulsc76M7GzIF9UPCI03e0DJpcVrNQHMARsepbLByD9k6RbUTOV4TayeQo7IUBU+r4GqlbJiJDFfl/xRkggWwPpvQP5qvG7ScX+/x3ts4hQ8iAc3TUOC2i4AoelhW//trv1WfCqaA+MNQyFMaojsTncrpzzWayZDiHzF3+6hSFVRMPWbEXydc3sCk1BcwfLFGznt7/Zkmfd0Rg1j5JjlT5CqAtfStSj+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PN6Ey2Usone41hog2N5ThwwMNZdc9RzobwGcqx5jMHo=;
 b=OfF9lD9BQ6+I17eYcWCD64Rb4ypW+FjSVuMYyERt2rI5MBpeBBhgjwDt+pqYx8ciVaV0EgAn3zm/xtQxEONh5zN033ZGOtPuMP5Ddu1yIYVdAx2gJENsX+NKoKblQIimPX2laqxBrPiokMMtziwFXuOF7ApGFLEeeORKLGJa0y/WMCHGNk8/XC0kZB9ZG5atE7hiwsUWXMjeFWd8Ma+c4g4fPzwTvQDjogFB498GXDPPDqM7rR3y1w3IvVv+gj4bdFjfx3IurTWcsSFAi1LbYQffeQqUwx1NR3+bbTDz0pwNbQpzawWzzLyefHXH6wYCyiaom4YQac1753m1N8wPRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PN6Ey2Usone41hog2N5ThwwMNZdc9RzobwGcqx5jMHo=;
 b=ZapIHTBvTQ9BFclvxyMmx7n+qAkm62GJfUHN/Pek0uQnm8CJwi5JKBOxo6KCeBWWn/dI3VquGPZA1bpe5NpnzGb+EjfiOSgzS3s92BzTNKVachpOZi/PcYUlSoUZUQ6xGczD272gG+fRd5gq+Qm5ahEp4xr5itrfnxwDQn1kOts=
Received: from MWHPR15MB1597.namprd15.prod.outlook.com (10.173.234.137) by
 MWHPR15MB1166.namprd15.prod.outlook.com (10.175.9.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Thu, 2 Jan 2020 18:56:20 +0000
Received: from MWHPR15MB1597.namprd15.prod.outlook.com
 ([fe80::cdbf:b63c:437:4dd2]) by MWHPR15MB1597.namprd15.prod.outlook.com
 ([fe80::cdbf:b63c:437:4dd2%8]) with mapi id 15.20.2602.010; Thu, 2 Jan 2020
 18:56:19 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     David Miller <davem@davemloft.net>
CC:     "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Subject: Re: [net-next PATCH] net/ncsi: Fix gma flag setting after response
Thread-Topic: [net-next PATCH] net/ncsi: Fix gma flag setting after response
Thread-Index: AQHVvQcvq4Utc53XEUy7GF5JxeUuH6fTrS4AgAOPSYA=
Date:   Thu, 2 Jan 2020 18:56:19 +0000
Message-ID: <6494F283-FC28-459D-B9DE-494FC8D0CAFA@fb.com>
References: <20191227224349.2182366-1-vijaykhemka@fb.com>
 <20191230.203442.69341487993928315.davem@davemloft.net>
In-Reply-To: <20191230.203442.69341487993928315.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:c7d7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 398c147b-7e82-4914-fcd4-08d78fb57455
x-ms-traffictypediagnostic: MWHPR15MB1166:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB11662112745547E686009690DD200@MWHPR15MB1166.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0270ED2845
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(376002)(396003)(136003)(346002)(199004)(189003)(33656002)(8676002)(54906003)(8936002)(86362001)(81156014)(81166006)(6486002)(6512007)(186003)(6506007)(66946007)(2616005)(4326008)(36756003)(2906002)(76116006)(66446008)(66556008)(66476007)(5660300002)(478600001)(316002)(64756008)(4744005)(6916009)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1166;H:MWHPR15MB1597.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qxt5YeVTn9Ce1Ky/siLMq/MsyquVvAZ0UpWh64nIjRRJPO7OJXdjlMEaNHjsP3QW14d5UZkvBi5Zvs+NQczA6qy6NeILMnEK/R0fl2GcafHbMb4q5eryvbWKavU9H9aCY+RYDqeMJm0RWs80rpHrOJ9BnNxPWOXAcANc4kL2Tm5f8nInG8QJaRaPB93l6n5oOAM1eEnMr9W4dz9G7E3u78T5yadFYiaSTrXt0EfBCYLRXMxI71LW+/hnfzIu2ZBNKC3uBuGphd/pFqWLmxiA/bp+07Z+1LvzGD4MJRGCT6c9Tkn5uqVq00Q7KrwaPAmvpA0JTKY7vegh20d5kdwXDSL9CO4GqUt2KGIEsXNkfAEtmEpzhNoEZSC4HESbDLBWOtVKnDFsNjAEpOvdVnRYZNhDhRxfemI4GYf2eGUrJaZftF9Q3mt46gU+X3GAp+Q/
Content-Type: text/plain; charset="utf-8"
Content-ID: <B719112A30903F44A2A457110E14A65F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 398c147b-7e82-4914-fcd4-08d78fb57455
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2020 18:56:19.8320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7tqQs5xyVSm7PuKDhGqjMnmpOTedtZRWbcA45fpFJh9YfifOFPJIqjU1QmgSo2z4C1GnssaA/ZHLULW3cMaKbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1166
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-02_06:2020-01-02,2020-01-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=777
 spamscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 suspectscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001020154
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDEyLzMwLzE5LCA4OjM0IFBNLCAiRGF2aWQgTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldD4gd3JvdGU6DQoNCiAgICBGcm9tOiBWaWpheSBLaGVta2EgPHZpamF5a2hlbWthQGZi
LmNvbT4NCiAgICBEYXRlOiBGcmksIDI3IERlYyAyMDE5IDE0OjQzOjQ5IC0wODAwDQogICAgDQog
ICAgPiBnbWFfZmxhZyB3YXMgc2V0IGF0IHRoZSB0aW1lIG9mIEdNQSBjb21tYW5kIHJlcXVlc3Qg
YnV0IGl0IHNob3VsZA0KICAgID4gb25seSBiZSBzZXQgYWZ0ZXIgZ2V0dGluZyBzdWNjZXNzZnVs
IHJlc3BvbnNlLiBNb3Zpbm5nIHRoaXMgZmxhZw0KICAgID4gc2V0dGluZyBpbiBHTUEgcmVzcG9u
c2UgaGFuZGxlci4NCiAgICA+IA0KICAgID4gVGhpcyBmbGFnIGlzIHVzZWQgbWFpbmx5IGZvciBu
b3QgcmVwZWF0aW5nIEdNQSBjb21tYW5kIG9uY2UNCiAgICA+IHJlY2VpdmVkIE1BQyBhZGRyZXNz
Lg0KICAgID4gDQogICAgPiBTaWduZWQtb2ZmLWJ5OiBWaWpheSBLaGVta2EgPHZpamF5a2hlbWth
QGZiLmNvbT4NCiAgICANCiAgICBBcHBsaWVkLg0KVGhhbmtzIERhdmlkDQogICAgDQoNCg==
