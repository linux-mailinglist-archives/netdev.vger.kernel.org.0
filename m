Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F33A121970
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfLPSwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:52:19 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19954 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbfLPSwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:52:18 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBGIpQd6011923;
        Mon, 16 Dec 2019 10:52:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=egEU1FtquOPB87Wp2VFDOyvjd22xTqBj6yUGwpDfuIc=;
 b=TomobyIzOW4cRHNoZFXWg4D7hZl5GoTiiNXyvhS3gQLxj0bmkm65Pl8UBfwSC+wMyqs4
 RTq1M6hT0j4VI7gaslRwX5ZaGHKcwP2hapv2R0Im8LdE+XA1O12MANGOecqSVftvA4TX
 qmrvfdGClUVhFn/i8JnI/MLhYybu8dSQRVk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wwtq143wj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Dec 2019 10:52:04 -0800
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 16 Dec 2019 10:52:03 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 16 Dec 2019 10:52:03 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Dec 2019 10:52:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5qaMJr2ARkG8WD4jifoeVZmOpcLibq43VYeMdTpqobeXn/Ec6n5LinuOlGdCcXOZViS+dWiJNSdLP14KR0ICs3nQNZd8/BgrtIz7nNnFuATgFW5g74uym49TncJwkel8azoiFR5w+VZ33Rrzq0yyxBsl+dm/HlVAq08CgFujaGlYQV2Nd8xiJ7Et/Niq5heApW+qkTIqUVoVgaWzO8IGM65qW1P8jeZ+jH9uSKrYYqT+ldR++jxFHBJLQmogFUR0Ji5lcAVHC9JQOdbsITtA+efYovzOPV3UL/jg3LjTqHyGy0zlyouHr+yVWUaWDWB8gHf/+R3yBHXf4bnrCOxbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egEU1FtquOPB87Wp2VFDOyvjd22xTqBj6yUGwpDfuIc=;
 b=DMhI8OoeSdqaAfPjqls2+RIbma7GovhhakVuz9o4J/eacEUin06TVOfTZ2uP/5yO2LcnXQUEYYlAYmCEj1xHDWW+3gSaXDoNJAZ3GMBfCw4uteDGYwA9fDiIXSkgEok7GFURzSMyfcHTDabaM+UmgwyQcrk2Up0paUmx95iKCavi8JJPVhNPdHOkJ/0RklB8DjDGX7ltIOjDUuP6WPIsvup4PZG0ewpAGL9Twhw4S0MIWFJMtTypi26WppSWRLmV9tw2g+yXbdNaEIYNsFhIMO5TMRK+6zRQTQIHltoysKPLBxU4vLmmXVanVgtcWKlxYl88boY5zxag8Rf6v6X/AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egEU1FtquOPB87Wp2VFDOyvjd22xTqBj6yUGwpDfuIc=;
 b=HfyxikmEVOi4AWGoMSX5ZVFpZT2lsB0Z1w6Kk2I6brQU3Psr/sg1r2XCTT/gSzaU92iQdLF965GUoFmTE5OkAfQDCJqEJH2IAuTkTyfGOruuz9P8a+VzZSFLEaveeT/2rNLtAQom/qs+v2wuTI5ePC4O7U9/CKfNXveJeFrMmUA=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1596.namprd15.prod.outlook.com (10.173.223.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.14; Mon, 16 Dec 2019 18:52:02 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 18:52:02 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf: fix missing prog untrack in release_maps
Thread-Topic: [PATCH bpf] bpf: fix missing prog untrack in release_maps
Thread-Index: AQHVtDDAvIPdWApw4US7DAzKvUhlsKe9G2mA
Date:   Mon, 16 Dec 2019 18:52:02 +0000
Message-ID: <31a08a1a-a6cb-d216-c954-e06abd230000@fb.com>
References: <1c2909484ca524ae9f55109b06f22b6213e76376.1576514756.git.daniel@iogearbox.net>
In-Reply-To: <1c2909484ca524ae9f55109b06f22b6213e76376.1576514756.git.daniel@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0013.namprd19.prod.outlook.com
 (2603:10b6:300:d4::23) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::dd8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53158528-30af-4d8c-00df-08d7825909a9
x-ms-traffictypediagnostic: DM5PR15MB1596:
x-microsoft-antispam-prvs: <DM5PR15MB1596A8E704EE9E51615B240AD3510@DM5PR15MB1596.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(366004)(39860400002)(376002)(189003)(199004)(6512007)(2616005)(66946007)(110136005)(36756003)(66476007)(53546011)(66556008)(2906002)(64756008)(66446008)(54906003)(4744005)(6486002)(4326008)(8936002)(6506007)(71200400001)(186003)(5660300002)(81156014)(81166006)(86362001)(478600001)(31696002)(31686004)(52116002)(316002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1596;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1SPEXBPRJ3pOTK9g9ijRDYtuW/Z3GXPNl87enlpgY8hw63qiOwyG5aNiGBPytze8wcVJWUfnNm43OlRCZgeKq15J3mVNqiqeXfj97ajBotP/33Q0IT3C6epyLmaLqoTWk60BfW6LH+w9VkpZ9MgTBioA/2iFQbIOVFhQnkW6J/lfAe0thst87Bjbv1BWux97JxEGQlNmTGBQtyRuqYVPTVDahvKI3MSQiB1S5TrIwEu0ojN4PAVftGkQxv+DmvFWg6M5SmhDioxmoOEmTTr+xSqDQVQPGRRwwPcRDoUsB4LkMHnBymoJMAAR9lfjDxECVEgxocfrjkzWuvSYn9b+NTILUyE04Ck/aoBTk20uOAmd5W0b0yzsaR4HRplZxT6TIA3Hfpv64D+4SgDK4HBMS+y6BapJTXNUWQy123PLBEcCaHRjUO1tawLfRAcVVmke
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <17D687A4200111468ECA8FC4BBE35782@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 53158528-30af-4d8c-00df-08d7825909a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 18:52:02.4684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BXkO9jVWe7RaqqtkYEvNcWtWfci9FQ99xXnA6MObY128W3qqJeIIUy2/1GfkS3gO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1596
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-16_07:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0 mlxlogscore=931
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912160159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE2LzE5IDg6NDkgQU0sIERhbmllbCBCb3JrbWFubiB3cm90ZToNCj4gQ29tbWl0
IGRhNzY1YTJmNTk5MyAoImJwZjogQWRkIHBva2UgZGVwZW5kZW5jeSB0cmFja2luZyBmb3IgcHJv
ZyBhcnJheQ0KPiBtYXBzIikgd3JvbmdseSBhc3N1bWVkIHRoYXQgaW4gY2FzZSBvZiBwcm9nIGxv
YWQgZXJyb3JzLCB3ZSdyZSBjbGVhbmluZw0KPiB1cCBhbGwgcHJvZ3JhbSB0cmFja2luZyB2aWEg
YnBmX2ZyZWVfdXNlZF9tYXBzKCkuDQo+IA0KPiBIb3dldmVyLCBpdCBjYW4gaGFwcGVuIHRoYXQg
d2UncmUgc3RpbGwgYXQgdGhlIHBvaW50IHdoZXJlIHdlIGRpZG4ndCBjb3B5DQo+IG1hcCBwb2lu
dGVycyBpbnRvIHRoZSBwcm9nJ3MgYXV4IHNlY3Rpb24gc3VjaCB0aGF0IGVudi0+cHJvZy0+YXV4
LT51c2VkX21hcHMNCj4gaXMgc3RpbGwgemVybywgcnVubmluZyBpbnRvIGEgVUFGLiBJbiBzdWNo
IGNhc2UsIHRoZSB2ZXJpZmllciBoYXMgc2ltaWxhcg0KPiByZWxlYXNlX21hcHMoKSBoZWxwZXIg
dGhhdCBkcm9wcyByZWZlcmVuY2VzIHRvIHVzZWQgbWFwcyBmcm9tIGl0cyBlbnYuDQo+IA0KPiBD
b25zb2xpZGF0ZSB0aGUgcmVsZWFzZSBjb2RlIGludG8gX19icGZfZnJlZV91c2VkX21hcHMoKSBh
bmQgY2FsbCBpdCBmcm9tDQo+IGFsbCBzaWRlcyB0byBmaXggaXQuDQo+IA0KPiBGaXhlczogZGE3
NjVhMmY1OTkzICgiYnBmOiBBZGQgcG9rZSBkZXBlbmRlbmN5IHRyYWNraW5nIGZvciBwcm9nIGFy
cmF5IG1hcHMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBEYW5pZWwgQm9ya21hbm4gPGRhbmllbEBpb2dl
YXJib3gubmV0Pg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCg==
