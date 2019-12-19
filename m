Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B445125A0E
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 04:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfLSDpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 22:45:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32836 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbfLSDpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 22:45:08 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJ3ir7g015108;
        Wed, 18 Dec 2019 19:44:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dAazp6f7mtjFd7KEFveGPjUvNpsldULqX79/4eD8TgU=;
 b=kv9Ey5cMlGkNl5gz9EHCY2DV5xqR/NEWTz0ieH/C1GVDjvRX2sCwUj5rvEdlZkVvLXfc
 0BS5hDUeq3r9q3UUIF+iN4myIkat0VocyhO9OszoJ+9qD30YN/A+q03XDc7co02niUw6
 v4H9801EVJgFoAxBQcyYsK1hMdZw3gyotyM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2wysvht5mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Dec 2019 19:44:53 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 18 Dec 2019 19:44:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0YhQRZvw8ww6+KmgpvobpODTm3aH0yC03XMpNd+prUKo3/aMpdIkPEUyMLIULP/EENq6MOS5pGMM4vybaZdIoMBw2fFw93mM4/hHN/dR8tWfF3q1BLkcwrZ9v8NyHGkglb4QDVaghmM9HdizNJ96DG6/eI26fJFP2ifONnMj2mz/zvsBJOzblA+S4GB5ACl69SDKHqZkh6TbbQtaEMQq4AyAwIfC+NgFh3YJTBthy+ALK2ayKU9BGacmaIKLjR79c/p5E9ukJ/eCurj5tqbDt8ZedlyvfaKEZtSQaek4ZL3JO9dP0dJWTdNIstAG1oNJ80L5Kt16sHae2dIsykhPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAazp6f7mtjFd7KEFveGPjUvNpsldULqX79/4eD8TgU=;
 b=B/hizZ74coSmyZm1A5CGnLU/y61Sl/V3P05Ctsu/sTOD80vc28LbI4mMQV3XbaZw0eKl7oiwTx5RbX2exbPBgT2YPipfr0es8lyZIrK5JMN8qrtneI8lthcMTJeGPRzfIcFqroud3tJjhtJug/0hlbVfLlVYejNSHw6YpCL5Sst6jI7XJ2ckCannZ3uOFbrfwDkpofYXzncE+3Rg7ic3NhHS45LwS33BTH5piJvhM0zPz8FRwdjzpNNAEDixK28u8B6xv3JndSOA3PMUWpYBaTMjeXAU65MirbNykMETgQfbvkonf6bH+4quOkmBlBEbL8QdBC0VaoqdL8eVHIzzVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAazp6f7mtjFd7KEFveGPjUvNpsldULqX79/4eD8TgU=;
 b=cPga2yJuepUXaKwJWWIviBefFVoZ7BWNulPHZCMJCxbzKsNoHRWB/5/KKI00v8nuAy5mtNVYn9sl5/J7MPXXWahUKoE8VOCcPWiF6uyHR1n/KMe4yoe9qX3mu+jUdsfp0YjFn5cD6EZKsncFZCSWXqPH8eknSVOAju1lQeBxAco=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1370.namprd15.prod.outlook.com (10.173.219.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Thu, 19 Dec 2019 03:44:51 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 03:44:51 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe
Thread-Topic: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe
Thread-Index: AQHVthC1EMfl5X282UKV597SrRW4aqfA0R0A
Date:   Thu, 19 Dec 2019 03:44:51 +0000
Message-ID: <ace251bb-9918-bd7e-1c54-f3645e5a80eb@fb.com>
References: <20191219020442.1922617-1-ast@kernel.org>
In-Reply-To: <20191219020442.1922617-1-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0093.namprd15.prod.outlook.com
 (2603:10b6:101:21::13) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::ae24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c20d5ce0-f2f8-4644-eb5f-08d78435cd7a
x-ms-traffictypediagnostic: DM5PR15MB1370:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB137009F4C723C3264ED15507D3520@DM5PR15MB1370.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(136003)(346002)(396003)(376002)(189003)(199004)(81156014)(2616005)(8936002)(8676002)(2906002)(36756003)(81166006)(316002)(110136005)(54906003)(4744005)(86362001)(31686004)(186003)(31696002)(6486002)(478600001)(5660300002)(53546011)(6512007)(4326008)(66556008)(64756008)(66446008)(66946007)(6506007)(66476007)(52116002)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1370;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yUvh6Ce/ElXkumvT05urtNsozbwCll+jN/elw0n5DJVBlq9tqrEq6JijCpBy/kAYLuYgohS4X9hI2OrSs1Rc8G5zEL1WYLquiO76N5O+NJgBopphP7IlMc3yeSNMZfXmckP887W1BX/kuOe4b+N6LZzv/CpLTP2tTWK0SouOZ+UqZ3cfyfxDvLEKxHEpn8fEkVgl6cf1Zb2iy6Luy/CK16TAbth2w8LYWrnkEexB+q69wxrG5e1ITVlhTQ4rKgen9WaQKkkEbIdg05F+spwCvw1jFhLJAAXJ4kZCH+gKb1wJvMU/8p81uAmE9yQmLIhP+qf6kzzzAUCQlPoqAZaAwXMFBv1eV4+Fx93f8gpnZr+lVu5Mt/qkdqZzc2MBudyTisTrD+xnk27UozRuYrWZwIbF8fUtJJxbj9LCQm/RlCweWULbhyH7gV4YY5pajRc+
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6D5233AC5359E4D87930D725411706D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c20d5ce0-f2f8-4644-eb5f-08d78435cd7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 03:44:51.5161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N8HQj46rmg36+Jv9TqHlOxwYJDL9pEnsq4MBOtN7JwcfsvPGApmifNeGY8peUnOL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1370
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0
 mlxlogscore=939 phishscore=0 suspectscore=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190028
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE4LzE5IDY6MDQgUE0sIEFsZXhlaSBTdGFyb3ZvaXRvdiB3cm90ZToNCj4gRml4
IHR3byBpc3N1ZXMgaW4gdGVzdF9hdHRhY2hfcHJvYmU6DQo+IDEuIGl0IHdhcyBub3QgYWJsZSB0
byBwYXJzZSAvcHJvYy9zZWxmL21hcHMgYmV5b25kIHRoZSBmaXJzdCBsaW5lLA0KPiAgICAgc2lu
Y2UgJXMgbWVhbnMgcGFyc2Ugc3RyaW5nIHVudGlsIHdoaXRlIHNwYWNlLg0KPiAyLiBvZmZzZXQg
aGFzIHRvIGJlIGFjY291bnRlZCBmb3Igb3RoZXJ3aXNlIHVwcm9iZWQgYWRkcmVzcyBpcyBpbmNv
cnJlY3QuDQo+IA0KPiBGaXhlczogMWU4NjExYmJkZmM5ICgic2VsZnRlc3RzL2JwZjogYWRkIGtw
cm9iZS91cHJvYmUgc2VsZnRlc3RzIikNCj4gU2lnbmVkLW9mZi1ieTogQWxleGVpIFN0YXJvdm9p
dG92IDxhc3RAa2VybmVsLm9yZz4NCg0KQWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5j
b20+DQo=
