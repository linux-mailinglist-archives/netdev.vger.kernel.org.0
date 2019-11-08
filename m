Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86A82F4000
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 06:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfKHFbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 00:31:45 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62914 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725765AbfKHFbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 00:31:44 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA85Teid013431;
        Thu, 7 Nov 2019 21:31:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=07OGHsoqd2L7lZtdOKZyCp1GiwT+worjTRxNMXfaHyU=;
 b=JOqzqNc2CIkE6U3otmW5Rz3TokbPcM9bCbl5LEkrkmksZtZ7J9m/m0RP4q0/UL3XKbW2
 P8K9gzkAdmYPjvrZYFsD/C/ETyL/iP16ZX0J7dIEhHcI/d+N52upXe2RgrSsfhI/8tk1
 Z6OzhSn86yNyDcNRhZeCP617EzuJmtRXZwg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2w4ujf9rxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 21:31:25 -0800
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 21:31:25 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 21:31:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPImslTQlOT9jK+YCQ7U+kNbJJH6I9HOMPsyAsOXgn7d7mUyz6exOSu4Cd70pFSQc6sgf0lbIY4UXZaxohmmHu3D66KTEtkkx7gWFZsRHBw9x2O3JJQavbS3hrH+JFD7UBDQyh/b5/mkuNaG7tfmqtjzhoj7arDg/oS83QuxV29TA4zWelOjxC1Meb1I5/c7GzvvU+scIhE926YwUsxg6reT9QCgQv/qIWD6vNKcTJFhXzOJtq/c9Thl8xjvwCO7jrHnHncEvd0GTD8KZ00SHVg+UeX0I0xFtpW8IiiEJ107oz8hcDBlbQB8eCLu+zMs11cMeRI80XWTmYArIp9XWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07OGHsoqd2L7lZtdOKZyCp1GiwT+worjTRxNMXfaHyU=;
 b=XzfSfmyUCXKDou5ZfENTm4sqcz2xG7ayoeHqc9mrFLqmI9BC+KkTOyKr/VztVbbW+E+HEL6wXw9hebhrkUpbgwxC97PI14DT5BKKks+Udp+0Xz77hamJacCVmoGZp3tuI0tvMSxz01Q7jA0joYvfM4D6d5v+1swyBp9Fx2J5cv4AH24qwz3vgcREQvBnpa0eE7vnhMv5KOVL00MLboAy7zvz0SGFGA6fsvjyhSWnVrM93VPtoVau+nN2Ov88Az8ZbWI43/mJVdkmS0lMwDsmqVJOP+H5k0wX/lcrEfzLQq4AwvrDmJF54ZMVD4v2Levim8cylG1b8f8KWJDe9cwUkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07OGHsoqd2L7lZtdOKZyCp1GiwT+worjTRxNMXfaHyU=;
 b=L5U6jJKaicguZrjl7kngAdT3oUx0vvRvTiXKWLk4fxR2avWY3c+J4fpAWu9bSb6dJPuMdF3aq+YxBe0Yc4XHMbBd+Elw05oAI65LJIqXftOpX4v65hP013jacT3GiSgpFmKpKUqrm+eTL8NQBhWjPGFwar09r8zpoKN4gc3tr2E=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2806.namprd15.prod.outlook.com (20.179.158.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 05:31:23 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 05:31:23 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 12/17] bpf: Fix race in
 btf_resolve_helper_id()
Thread-Topic: [PATCH v2 bpf-next 12/17] bpf: Fix race in
 btf_resolve_helper_id()
Thread-Index: AQHVlS7vYUYGh6xIWEOpJeXnrzpCvaeAvC0AgAAE9QA=
Date:   Fri, 8 Nov 2019 05:31:23 +0000
Message-ID: <b51f14fc-8561-0a53-f5ef-f2497e2c66c2@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-13-ast@kernel.org>
 <CAEf4BzZ0Brfa+8yA5-J=T2nFmk55TQBsfSygXFOX3dmKt3rFGw@mail.gmail.com>
In-Reply-To: <CAEf4BzZ0Brfa+8yA5-J=T2nFmk55TQBsfSygXFOX3dmKt3rFGw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0096.namprd22.prod.outlook.com
 (2603:10b6:301:5e::49) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::fc4a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5359afc-178e-4e32-14fd-08d7640ce494
x-ms-traffictypediagnostic: BYAPR15MB2806:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2806B1A39C820E847C250301D77B0@BYAPR15MB2806.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(366004)(136003)(396003)(199004)(189003)(8936002)(476003)(486006)(81156014)(6246003)(99286004)(46003)(6486002)(6512007)(256004)(6436002)(11346002)(14444005)(446003)(186003)(478600001)(31686004)(76176011)(71200400001)(386003)(25786009)(6506007)(53546011)(102836004)(52116002)(2906002)(7736002)(71190400001)(8676002)(31696002)(4326008)(5660300002)(36756003)(86362001)(66556008)(2616005)(305945005)(66946007)(110136005)(14454004)(64756008)(316002)(66476007)(66446008)(229853002)(54906003)(6116002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2806;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RNS92kbFHi9J1sD3fnEDHWuITrUjt3QWfhhqdM0OEJGI2/Rhc6xYevUwWJi7X1zWOG7hjnsZg97mKoAcW0K9cJ+FBcJ+DF1rFFwueLCsu9OAv4Rol4eBc6ZTNr64ke/wEc5og/caF91ndZszHBvguXm5Cfp6cNdlaX3PeRhJB+2kwNfrDLYaoqVfHxEzpJDlDckgR99rY/mkK47mYjHpOP6AQoxYlF/4kztqqbq4AcUX+3IKs5HyB+XbnXYnV2Z2LOm3rvIgC/2FnTwup4LgmQUWlC1hGCQfMd8bDqFQ+8AQ0+BKw+zCSbKsavWTUKIMiL6PDDnuEsGPSPMNeCiAy3fbxsuEdhLlMJCJnh0fdCrTroZJoVnUULGdn2mw5cGDSAuxpdBcxrFBR/bhmi9dfyyfyYxrlasPFvv+Z0Kb+DRsT8huGLY/3iPbTLA46bir
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8352E0A583FFC40BE9A68AA546D9532@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f5359afc-178e-4e32-14fd-08d7640ce494
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 05:31:23.6607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LNBPML8b2wWwsFo+pRnu4gGuxFkoQ/WzBlOwzXe6dbb56/G9xD+ojYAQqPwzfbux
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2806
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 bulkscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvNy8xOSA5OjEzIFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IE9uIFdlZCwgTm92
IDYsIDIwMTkgYXQgOTo0OCBQTSBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFzdEBrZXJuZWwub3JnPiB3
cm90ZToNCj4+DQo+PiBidGZfcmVzb2x2ZV9oZWxwZXJfaWQoKSBjYWNoaW5nIGxvZ2ljIGlzIHJh
Y3ksIHNpbmNlIHVuZGVyIHJvb3QgdGhlIHZlcmlmaWVyDQo+PiBjYW4gdmVyaWZ5IHNldmVyYWwg
cHJvZ3JhbXMgaW4gcGFyYWxsZWwuIEZpeCBpdCB3aXRoIGV4dHJhIHNwaW5fbG9jay4NCj4+DQo+
PiBGaXhlczogYTc2NThlMWE0MTY0ICgiYnBmOiBDaGVjayB0eXBlcyBvZiBhcmd1bWVudHMgcGFz
c2VkIGludG8gaGVscGVycyIpDQo+PiBTaWduZWQtb2ZmLWJ5OiBBbGV4ZWkgU3Rhcm92b2l0b3Yg
PGFzdEBrZXJuZWwub3JnPg0KPj4gLS0tDQo+PiAgIGluY2x1ZGUvbGludXgvYnBmLmggICB8ICAz
ICsrLQ0KPj4gICBrZXJuZWwvYnBmL2J0Zi5jICAgICAgfCAzNCArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKystDQo+PiAgIGtlcm5lbC9icGYvdmVyaWZpZXIuYyB8ICA2ICstLS0tLQ0K
Pj4gICAzIGZpbGVzIGNoYW5nZWQsIDM2IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+
Pg0KPiANCj4gWy4uLl0NCj4gDQo+PiArICAgICAgIC8qIG9rIHRvIHJhY2UgdGhlIHNlYXJjaC4g
VGhlIHJlc3VsdCBpcyB0aGUgc2FtZSAqLw0KPj4gKyAgICAgICByZXQgPSBfX2J0Zl9yZXNvbHZl
X2hlbHBlcl9pZChsb2csIGZuLT5mdW5jLCBhcmcpOw0KPj4gKyAgICAgICBpZiAoIXJldCkgew0K
Pj4gKyAgICAgICAgICAgICAgIGJwZl9sb2cobG9nLCAiQlRGIHJlc29sdXRpb24gYnVnXG4iKTsN
Cj4+ICsgICAgICAgICAgICAgICByZXR1cm4gLUVGQVVMVDsNCj4+ICsgICAgICAgfQ0KPj4gKyAg
ICAgICBzcGluX2xvY2soJmJ0Zl9yZXNvbHZlX2xvY2spOw0KPj4gKyAgICAgICBpZiAoKmJ0Zl9p
ZCkgew0KPj4gKyAgICAgICAgICAgICAgIHJldCA9ICpidGZfaWQ7DQo+PiArICAgICAgICAgICAg
ICAgZ290byBvdXQ7DQo+PiArICAgICAgIH0NCj4+ICsgICAgICAgKmJ0Zl9pZCA9IHJldDsNCj4+
ICtvdXQ6DQo+PiArICAgICAgIHNwaW5fdW5sb2NrKCZidGZfcmVzb2x2ZV9sb2NrKTsNCj4gDQo+
IElzIHRoaXMgcmFjZSBhIHByb2JsZW0/IERvZXMgaXQgY2F1c2UgYW55IGlzc3Vlcz8gR2l2ZW4g
dGhhdCBldmVuIGlmDQo+IHlvdSBkbyBwYXJhbGxlbCByZXNvbHV0aW9ucyBhdCB0aGUgc2FtZSB0
aW1lLCB0aGV5IGFsbCB3aWxsIGhhdmUgdG8NCj4gcmVzdWx0IGluIHRoZSBzYW1lIGJ0Zl9pZCwg
c28ganVzdCBzZXR0aW5nIGl0IHVuY29uZGl0aW9uYWxseSBtdWx0aXBsZQ0KPiB0aW1lcyB3aXRo
b3V0IGxvY2tpbmcgc2hvdWxkIGJlIG9rLCBubz8gTWF5YmUgV1JJVEVfT05DRSwgYnV0IG5vdCBz
dXJlDQo+IHdoeSBhbGwgdGhlIHdheSB0byBzcGlubG9jay4NCg0KSG1tLiBJbmRlZWQuIExldCBt
ZSBzd2l0Y2ggdG8gUkVBRF9PTkNFL1dSSVRFX09OQ0UuDQo=
