Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC553F318E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 15:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389590AbfKGOdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 09:33:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2760 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388873AbfKGOdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 09:33:20 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7EPmaH029816;
        Thu, 7 Nov 2019 06:33:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7eGEF0speLCar6nF55wmkg4EDfYpCQcLhDXHErIXyIc=;
 b=V2GSWhY7nZ2hLlOElFgi4S99lNDnblN2kY/yN8V/Iphvqm3Qs2/gQTyQB893Vp5WLJE4
 8L8quIwHnrQ+M26rXRh6/l+XWsqaAkpttKCAqnO9rEmMY+w00HW5ufpu44HN/JQBdCgR
 2BvTMdkyYmuYtElJL78YNeShi5+s60fSQNE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41un5g4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 06:33:06 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 06:33:04 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 06:33:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YlHVzervkyUg/AjV7H65ofY6vQIEsIUJyksbjMp0vUOoaGqqEdZ2o5QmMbmyLv/uXPAaEh096qq8yQ90CByMI3NkeN000hZXjp2vxOtCnqKCtnSWta1mlePA2T4Zlky6UtjD2PDs3RulbUSBN72KSndHZPGWYycSEeuV0ZwNeOH3yVIE0gLDR2RigVazRqlptFfqVKu/juLAs70bVxVnflRkWaW8nMRiXj1LcOjM2EZOcRA0SOyMajTtmzSmeN6MdwZ/GZF2CPp+E5OhGlHIhzJOLfHpFQMOz1ZitUaH0je7Eg0K3Z1vnHWPP3FSAU2EX05ImDnS9CxX2+E/rzfiiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eGEF0speLCar6nF55wmkg4EDfYpCQcLhDXHErIXyIc=;
 b=NIGElKMXFuzlQbYJmE3f9kQFPD3pGb4a/u52oZoycz7iq8MDbIdZuMxDhKPOJV8oyTPTvRp9lqaXsCHRN/QAqcX0qv0Y07kuE7IMWzYj2uLpMJrS8GP1TaGOWQmYFkA+CHaNp25sQY2Dh+Mhz+JGKKK1eJwcfHz8xd2YQ1OgdXzUfH3oMTLc/KVU9OHetXEhnkwQC9p/UcpSj7aQyIUKIwEX0iNnoWIPnn4MQyvdVJ23bJQytp09MtC93DfZaDcZSBVcUkL5A923YGFDx2K/Vd+TDSsSFudUCJfbScqgXGIowHr1q4E86zWMI7NWyb8V8sFwLi3lGcogZ63dWyUOMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eGEF0speLCar6nF55wmkg4EDfYpCQcLhDXHErIXyIc=;
 b=WziahQuQk23WeipcCojWwBaZkjnPz0Nn9OqVyavxebOc8bND7d/MIGAjxFtOYuPyDF+YDCwquOZNMWWDmRlydY7udlDobBON5Nbgn1FTAefkfgvmccfaw35PSxcukcpJAcOxdEQBJJrjnOS5BKeQsJVpOYzi7PHjd1vCiW69Hs0=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2934.namprd15.prod.outlook.com (20.178.237.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 14:33:02 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 14:33:02 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 16/17] libbpf: Add support for attaching BPF
 programs to other BPF programs
Thread-Topic: [PATCH v2 bpf-next 16/17] libbpf: Add support for attaching BPF
 programs to other BPF programs
Thread-Index: AQHVlS7okFsRz36wwEG/RQIIDat4vad/xiOA
Date:   Thu, 7 Nov 2019 14:33:02 +0000
Message-ID: <c7d729d9-dbb0-b976-6364-030384cb8bf9@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-17-ast@kernel.org>
In-Reply-To: <20191107054644.1285697-17-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0108.namprd05.prod.outlook.com
 (2603:10b6:104:1::34) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::8f70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d64af640-6834-4e24-ac6a-08d7638f64e8
x-ms-traffictypediagnostic: BYAPR15MB2934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2934DD37A81572134D61D7B9D7780@BYAPR15MB2934.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(71200400001)(386003)(6506007)(6246003)(52116002)(316002)(76176011)(4744005)(53546011)(2501003)(102836004)(6116002)(5660300002)(486006)(110136005)(81156014)(476003)(6512007)(81166006)(46003)(31696002)(25786009)(229853002)(99286004)(186003)(6436002)(6486002)(11346002)(54906003)(66946007)(256004)(66476007)(36756003)(2616005)(66556008)(4326008)(446003)(2906002)(31686004)(478600001)(7736002)(86362001)(8936002)(305945005)(5024004)(8676002)(14454004)(71190400001)(64756008)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2934;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2cmp6Gz5wGxjagNt7Kp6Mt/9HCT4dRwUFwWLlDegYZQzv2BQUL1FWS3VDsbND3Xu63PQFFPM2s/WtMFPgY/O8OMOm8ClsHAzTU8iSS0ZybF59iI8doD7fYC9O9xeStanT7GCpJLUfBkOv6QPfnlUuNjIBBVlCkIx5XHisgxSQ3wTJIzm4us9N2HyydrK5u+sUrd3+8jvhYwork5OZWLXy8Fw44F16MVdF7WoQRkAmuu7l+qsolTI2kRg1jwhkgmbvaLyPRtmllqUeauGrOu4TnvVI6xKjCkKFjIv0gGBAOlX5Ijaks+kGS94j6+FMtTm6ebBcqphXlKRVVcxYZmJhshD2iei6y+TVUeVmY6U4Mxx5Ya4q9sXZ3kPaUx0BqsjzmGcbZeZqp83DEDeWX3haUIBlcNtksQxQb+ze92zRbij5UekkrsgfO7hxwZi/wZC
Content-Type: text/plain; charset="utf-8"
Content-ID: <22DBEEA290DF8F41AA29DD301927C8A6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d64af640-6834-4e24-ac6a-08d7638f64e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 14:33:02.4465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xw2yp7qwwTGZJM0ZqsLJRgTXmPIOFQR9v6L7DVpAM6rmIKlbRjY/v9nYJDEleI1h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2934
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_05:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 mlxscore=0 spamscore=0 suspectscore=0 impostorscore=0 mlxlogscore=845
 lowpriorityscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvNi8xOSA5OjQ2IFBNLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+IEBAIC0zOTI0
LDYgKzM5NjUsMTQgQEAgX19icGZfb2JqZWN0X19vcGVuKGNvbnN0IGNoYXIgKnBhdGgsIGNvbnN0
IHZvaWQgKm9ial9idWYsIHNpemVfdCBvYmpfYnVmX3N6LA0KPiAgIAkJYnBmX3Byb2dyYW1fX3Nl
dF90eXBlKHByb2csIHByb2dfdHlwZSk7DQo+ICAgCQlicGZfcHJvZ3JhbV9fc2V0X2V4cGVjdGVk
X2F0dGFjaF90eXBlKHByb2csIGF0dGFjaF90eXBlKTsNCj4gICAJCWlmIChwcm9nX3R5cGUgPT0g
QlBGX1BST0dfVFlQRV9UUkFDSU5HKSB7DQo+ICsJCQlpZiAoYXR0YWNoX3Byb2dfZmQpIHsNCj4g
KwkJCQllcnIgPSBsaWJicGZfZ2V0X3Byb2dfYnRmX2lkKGF0dGFjaF9wcm9nX2ZkLCBwcm9nLT5z
ZWN0aW9uX25hbWUgKyA2KTsNCj4gKwkJCQlpZiAoZXJyID4gMCkgew0KPiArCQkJCQlidGZfaWQg
PSBlcnI7DQo+ICsJCQkJCWVyciA9IDA7DQo+ICsJCQkJCXByb2ctPmF0dGFjaF9wcm9nX2ZkID0g
YXR0YWNoX3Byb2dfZmQ7DQo+ICsJCQkJfQ0KPiArCQkJfSBlbHNlDQo+ICAgCQkJZXJyID0gbGli
YnBmX2F0dGFjaF9idGZfaWRfYnlfbmFtZShwcm9nLT5zZWN0aW9uX25hbWUsDQoNCmZvcmdvdCB0
byBzcXVhc2ggc21hbGwgY2xlYW51cCBoZXJlIGxhc3QgbmlnaHQuDQpwbHMgaWdub3JlIHRoaXMg
cGFydGljdWxhciBwYXRjaC4NCg==
