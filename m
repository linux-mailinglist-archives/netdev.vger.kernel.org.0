Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E111613B0CE
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 18:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgANR0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 12:26:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54682 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726270AbgANR0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 12:26:37 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00EHLs1L025159;
        Tue, 14 Jan 2020 09:26:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ggbzzuHfmqLqnNhgIEIUTrmM7sTRoqxqpua9bQ5rBO4=;
 b=kCR69HTiiVs7bmjlhX3V2ykSHsDbHkSYY+UGZJFN4Cp6E8XG9oe0mG7ymGKv5JEJgH6H
 7IDptmRg5CU9ppRXpZ4h/StWUf/9XmbrojhnumOqcQLJcdHOR/9puvmjTzj92r1okEvb
 3Zd7590OHBovZsfkurA3rBtYgBubsnoV/1E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhd7r1j48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Jan 2020 09:26:19 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Jan 2020 09:25:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjlnkAzROtYeRx6dVZAgAQy6+o5OjAsVPCrKmkL2DZGhuR9Mmx7s+i1E/nhl7YQmsidXM8yCxnDRIqGhQAskbcZzhVB9OSG2y4tH5FXc7nhFgg6S/v1A8b/BD83bcvLtjbHggyM+4wwuj3mjhiNbeLzyZWTgzbEmQJ/G9HkSlSlDWF3oHuoBFUzWjoCrfSuczjZqte0bhqcvhpyQbvd/AoPoEZhfu5O5/0YNWkWl13kjqwA8ey+HlMNSEqzSzacih3KZTZjuVtdiQJKL+SsCZjk2a7S7RLSPRVsh8IiSiUuzm0/VlfQK1YZCXzmFRYLwCAdz92QAAjUpmAxaE+UzYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggbzzuHfmqLqnNhgIEIUTrmM7sTRoqxqpua9bQ5rBO4=;
 b=jWzCLhSd6/COn+Nb1s14ufsKG27+WO2yAuvdXelKcP0qJ+QATNi5a2HIZw3/IHkUvatO14R9AAUbWBXptRgz9auUWVbfet+lKXpp5cO7Z0OWG+uVKcm4K3oIB+UHA5XbZ8dZfTY2+ebDk3CchiTtDA//Rbb2DNL3a58yAbKP7MWj2FLL7f+tP6+48xQXGUCrd/MGgK/9nK4bx8cj5DTLgSJdiosaXWpED0njR54WJixZ1+92tBof8IbJ7IkAvOxtq4A/0o/0hWSHgPV7b0TVigDT2URenWCiiPazWUrfJJDCWdnpxQ7ENlBVBaR6RFFXwFLVQQBJRUDSSl1TXor/rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggbzzuHfmqLqnNhgIEIUTrmM7sTRoqxqpua9bQ5rBO4=;
 b=QqdJ8OUMes2P+cNThDZC6B/LLSfDz+pNaum0SKJjzcPqZD/eKC2Amfig2TTytls7zz1Bm1inaQWjFx6dYsapkWOlqDU6eVZA0ejqdAKY/qkCoPaWVz2IKto1LNBAdk/THe/SWUHq+pZs7wrMQOvmxeJAZsp5Ghvh5iF5/mQQqOI=
Received: from CH2PR15MB3621.namprd15.prod.outlook.com (52.132.231.95) by
 CH2PR15MB3624.namprd15.prod.outlook.com (52.132.229.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Tue, 14 Jan 2020 17:25:43 +0000
Received: from CH2PR15MB3621.namprd15.prod.outlook.com
 ([fe80::f85f:99be:50ab:2aa9]) by CH2PR15MB3621.namprd15.prod.outlook.com
 ([fe80::f85f:99be:50ab:2aa9%7]) with mapi id 15.20.2623.015; Tue, 14 Jan 2020
 17:25:43 +0000
Received: from [IPv6:2620:10d:c081:1131::1467] (2620:10d:c090:180::f7d5) by MWHPR17CA0061.namprd17.prod.outlook.com (2603:10b6:300:93::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.12 via Frontend Transport; Tue, 14 Jan 2020 17:25:41 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Jiri Olsa <jolsa@redhat.com>, Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 5/6] tools/bpf: add runqslower tool to
 tools/bpf
Thread-Topic: [PATCH v2 bpf-next 5/6] tools/bpf: add runqslower tool to
 tools/bpf
Thread-Index: AQHVyeON9FYoL/PNJ0OiETEd9NDI/6fqJ3YAgABECQA=
Date:   Tue, 14 Jan 2020 17:25:42 +0000
Message-ID: <d13fff52-e262-aadf-25cb-7166cb334be5@fb.com>
References: <20200113073143.1779940-1-andriin@fb.com>
 <20200113073143.1779940-6-andriin@fb.com> <20200114132208.GC170376@krava>
In-Reply-To: <20200114132208.GC170376@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0061.namprd17.prod.outlook.com
 (2603:10b6:300:93::23) To CH2PR15MB3621.namprd15.prod.outlook.com
 (2603:10b6:610:11::31)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f7d5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b07948b7-f40d-4b88-2827-08d79916c816
x-ms-traffictypediagnostic: CH2PR15MB3624:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR15MB36242F951CED7281D4F5D2D9D7340@CH2PR15MB3624.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(39860400002)(346002)(396003)(366004)(189003)(199004)(81166006)(81156014)(8676002)(36756003)(2616005)(52116002)(31696002)(53546011)(6636002)(110136005)(54906003)(316002)(16526019)(31686004)(71200400001)(86362001)(66446008)(2906002)(478600001)(8936002)(186003)(66556008)(4744005)(66946007)(6486002)(4326008)(64756008)(5660300002)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR15MB3624;H:CH2PR15MB3621.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dyylqo3KlEtPHMvUrcny3fBHQFPa1my2amKlN1RGKMrZHg6h+1hRDecVqCt4pKPNTKFx1sIOKL9cV5jO1YaIFUNlskURFJRkHbKS+nh4MX33ZR683/cjVfcOjUEM87JtUM9g7ss/8QeowgZHFb5/aDSEhz5Tm31ZglAs1+9f7pdanUKJsUnaSVsiVhBzM50P7uYbn6WmYzDeKw6GxKywoqLcDKmmdhvGmux2aa5y13HIxO2FJzVAy8YEDh7l74rKKgIkbZgAeydAA722FpqqCRWJS2CGQuJafYn2x2G+SzbuiOuvxqaMbA3eB/mPwKotNZS+2pQQZcj7hSJTBFCAnqJcK4SQMtJpITCO5qUKXPoqBIquQErViICB0ne7n1hpSJBAUyjqH8tK0DHCOzmAEsXvJNRUzK4SSGmS+kwSY1MsD3xgJa1tBwMDuijt7+4E
Content-Type: text/plain; charset="utf-8"
Content-ID: <A84B7C6619115942875D274A3BB98502@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b07948b7-f40d-4b88-2827-08d79916c816
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 17:25:42.9275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jVMaqVn1ToOHvtnU1rRPiIW9nptPX6+wb2lL5arxn/R/h+VnJ7kefUu8gStOm3Pu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3624
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_04:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 spamscore=0 mlxlogscore=880 lowpriorityscore=0 clxscore=1011 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001140140
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8xNC8yMCA1OjIyIEFNLCBKaXJpIE9sc2Egd3JvdGU6DQo+IE9uIFN1biwgSmFuIDEyLCAy
MDIwIGF0IDExOjMxOjQyUE0gLTA4MDAsIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gDQo+IFNO
SVANCj4gDQo+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvYnBmL3J1bnFzbG93ZXIvTWFrZWZpbGUgYi90
b29scy9icGYvcnVucXNsb3dlci9NYWtlZmlsZQ0KPj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4+
IGluZGV4IDAwMDAwMDAwMDAwMC4uZjEzNjNhZThlNDczDQo+PiAtLS0gL2Rldi9udWxsDQo+PiAr
KysgYi90b29scy9icGYvcnVucXNsb3dlci9NYWtlZmlsZQ0KPj4gQEAgLTAsMCArMSw4MCBAQA0K
Pj4gKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IChMR1BMLTIuMSBPUiBCU0QtMi1DbGF1c2Up
DQo+PiArT1VUUFVUIDo9IC5vdXRwdXQNCj4+ICtDTEFORyA6PSBjbGFuZw0KPj4gK0xMQyA6PSBs
bGMNCj4+ICtMTFZNX1NUUklQIDo9IGxsdm0tc3RyaXANCj4+ICtERUZBVUxUX0JQRlRPT0wgOj0g
JChPVVRQVVQpL3NiaW4vYnBmdG9vbA0KPj4gK0JQRlRPT0wgPz0gJChERUZBVUxUX0JQRlRPT0wp
DQo+PiArTElCQlBGX1NSQyA6PSAkKGFic3BhdGggLi4vLi4vbGliL2JwZikNCj4+ICtDRkxBR1Mg
Oj0gLWcgLVdhbGwNCj4+ICsNCj4+ICsjIFRyeSB0byBkZXRlY3QgYmVzdCBrZXJuZWwgQlRGIHNv
dXJjZQ0KPj4gK0tFUk5FTF9SRUwgOj0gJChzaGVsbCB1bmFtZSAtcikNCj4+ICtpZm5lcSAoIiQo
d2lsZGNhcmQgL3N5cy9rZW5lcmwvYnRmL3ZtbGludXgpIiwiIikNCj4gDQo+IHMva2VuZXJsL2tl
cm5lbC8NCg0KZWFnbGUgZXllIQ0KSSBmaXhlZCB1cCBpbiB0aGUgdHJlZS4gVGhhbmtzIQ0K
