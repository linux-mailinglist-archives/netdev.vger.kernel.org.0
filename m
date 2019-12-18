Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E65241257D2
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 00:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfLRXfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 18:35:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14098 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbfLRXfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 18:35:55 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBINZdre017719;
        Wed, 18 Dec 2019 15:35:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=PcoyL4uPZFUcvFJu1o//d8ZG/sSBcP1VMLFn3wYNw+0=;
 b=AGxKmEtikAzoh/7OEaxZB7VFo+CApRti3q+O7qZGC384W5elhrjhOIUK5oPRr7zYQeo9
 2WA1Wgfkgx4e5TFYJc9E2UfDFMjBAYDbO6w22EiMH8vSpJ3ZWXGHUL0zdOWLQuykNqxB
 5HrMb63Ffz64YpMqmoTKB7hD63wZA3psH40= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2wy61t6j5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Dec 2019 15:35:39 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 18 Dec 2019 15:35:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fv1YGlzj2nDMa58y3ZZNdgZ7NB5nakjAVgolnywRCvS1Ig14sTaCtyjbu1VG2y01GxVoxWwhNgL5PYA0hQt0aVsnOjUGw4XrdyLYmW4LiyUwg2W8wDvNeQxPOLjgGhduJ6YZOu+Yq8RDm5bStOxBtJtq2c6zr4X/0PpFQC/W/IzUdBnaSjUS/wUXAQaZYqhgjXpDKORUIfBDs9+cumVh+XHgBLSWZILtsI+Do5jeOyWSl9X39DyGSPfKravJyA83WzHxg94aVifoH9BCXdaSdR5ZEdR4D6q8HqAJ6/CK2r7ijW8eqNNLM5ov9YTzTn9H+M8Oo8m88CwBKyQ+Bp2D3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcoyL4uPZFUcvFJu1o//d8ZG/sSBcP1VMLFn3wYNw+0=;
 b=BQ0vzvq/DxVXDDtKQ4VYmMXbDixmRch+ThpEZjMwWphD82AEezF+klYYs2ajba94YUYOEimGQrO3sEfJtxM/rruOZFDIKA7GhSxpT7yErV4y5tLV3kVeiW6bBpUPj51RiE0UoFFq9A1ej6M9UWR6Vl2tzKpktm3xkXearpdfymL15qivaYsi6rJbprDsWPwsA478GA9rJ3PGHhVur+Kfc7lkNflb6oYD6s+Ao8CbKU8UGguX7xdulKnyXWar5HXw6xY6dla0q/C8ibfVUouIMwm30pLknWUZBAQCNySUf0Eb77pQw78ajNwVFgqBXU8MpnHCL9NxyKlTbF4bWomL1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcoyL4uPZFUcvFJu1o//d8ZG/sSBcP1VMLFn3wYNw+0=;
 b=bCaTlXMcfd6vjoCMZhKKM21vDyEMPMp41juI/kKSgvp6iDTj0Cbl5lEz75uI63GwwKxudL042o6ip/r74vH6OSDah5+8liWkgZZfp6zYpRm7XcU5Rcvgi9kcxPbfxzuMF1j/U/xJKwhuLVFOmMhMADvqbUL2Ml0oErrh/8WmvgY=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1674.namprd15.prod.outlook.com (10.175.111.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 23:35:03 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 23:35:03 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpftool: work-around rst2man conversion bug
Thread-Topic: [PATCH bpf-next] bpftool: work-around rst2man conversion bug
Thread-Index: AQHVtfvFdG9maJpGtUqoLFWYlcsFrQ==
Date:   Wed, 18 Dec 2019 23:35:03 +0000
Message-ID: <bc49104a-01a7-8731-e811-53a6c9861a48@fb.com>
References: <20191218221707.2552199-1-andriin@fb.com>
In-Reply-To: <20191218221707.2552199-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0141.namprd04.prod.outlook.com (2603:10b6:104::19)
 To DM5PR15MB1675.namprd15.prod.outlook.com (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:31e6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a23e4519-1a0a-41f6-2072-08d78412e7be
x-ms-traffictypediagnostic: DM5PR15MB1674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1674A23FB61A24EFD755EC5ED3530@DM5PR15MB1674.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39860400002)(366004)(376002)(346002)(199004)(189003)(186003)(54906003)(110136005)(4326008)(81156014)(6506007)(2616005)(6512007)(53546011)(6486002)(52116002)(86362001)(5660300002)(36756003)(81166006)(316002)(2906002)(31686004)(66476007)(66946007)(71200400001)(478600001)(31696002)(66556008)(64756008)(8936002)(8676002)(66446008)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1674;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l8MiOQ2qjKmqSTot4CIV4oczBeYX1ZxEjErJzjxtkQkYc7KRHQ4MhCNJmQ+khzxPPRDHked8e87AxM2paj7OGQ/DF9R9gklaGN7j5mLxp62sxymWr7Esv81K8/k/WcfIw6+VWbnjKSBNBib3D5iRWRlsSoEh8E0n0R7KiPp5wxpEtmq1R1utD156xvTA6P89BGx6H1kLZFxUd7HOZg4G8YybEDhbx+IPINGmqom199aIqjT2e5fuat22WqOcJOdzarrnOrhyJkvplDL0DjYS4Zv6bwGzEyJJsW28Sd8o7AJ3Wgqs5d8H8GhfbRikwAN1NxCFRnKtN086XlCFN8o+uYViBqSHhirHHC3RM/JnQYdi2KGOyE3tR378Ld1imNsCut1OvC1t7ZeH1ATpBUVx6IIZOuGb+49ed6qzBI+syMXW4pvZSSNGPeDsCx/nNTS86zh4J2Vi/o5mmPFRSa9vX3ssS1dkski3eXFeExc1OcF3GdITp05xv1UtAQeNtkAh
Content-Type: text/plain; charset="utf-8"
Content-ID: <091AEE07A3FC634E9F6A839D127E668F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a23e4519-1a0a-41f6-2072-08d78412e7be
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 23:35:03.0108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xoI6/dKWzA3ENYKNsCkZhpmuzGBa4bmnNoRLCQojPL7fPb9CusSS9lrYVvmYl2P+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1674
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180174
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE4LzE5IDI6MTcgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gV29yay1h
cm91bmQgd2hhdCBhcHBlYXJzIHRvIGJlIGEgYnVnIGluIHJzdDJtYW4gY29udmVydGlvbiB0b29s
LCB1c2VkIHRvDQo+IGNyZWF0ZSBtYW4gcGFnZXMgb3V0IG9mIHJlU3RydWN0dXJlVGV4dC1mb3Jt
YXR0ZWQgZG9jdW1lbnRzLiBJZiB0ZXh0IGxpbmUNCj4gc3RhcnRzIHdpdGggZG90LCByc3QybWFu
IHdpbGwgcHV0IGl0IGluIHJlc3VsdGluZyBtYW4gZmlsZSB2ZXJiYXRpbS4gVGhpcw0KPiBzZWVt
cyB0byBjYXVzZSBtYW4gdG9vbCB0byBpbnRlcnByZXQgaXQgYXMgYSBkaXJlY3RpdmUvY29tbWFu
ZCAoZS5nLiwgYC5ic2ApLCBhbmQNCj4gc3Vic2VxdWVudGx5IG5vdCByZW5kZXIgZW50aXJlIGxp
bmUgYmVjYXVzZSBpdCdzIHVucmVjb2duaXplZCBvbmUuDQo+IA0KPiBFbmNsb3NlICcueHh4JyB3
b3JkcyBpbiBleHRyYSBmb3JtYXR0aW5nIHRvIHdvcmsgYXJvdW5kLg0KPiANCj4gRml4ZXM6IGNi
MjFhYzU4ODU0NiAoImJwZnRvb2w6IEFkZCBnZW4gc3ViY29tbWFuZCBtYW5wYWdlIikNCj4gUmVw
b3J0ZWQtYnk6IEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+DQo+IFNpZ25lZC1v
ZmYtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQo+IC0tLQ0KPiAgIHRvb2xz
L2JwZi9icGZ0b29sL0RvY3VtZW50YXRpb24vYnBmdG9vbC1nZW4ucnN0IHwgMTUgKysrKysrKyst
LS0tLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS90b29scy9icGYvYnBmdG9vbC9Eb2N1bWVudGF0aW9uL2Jw
ZnRvb2wtZ2VuLnJzdCBiL3Rvb2xzL2JwZi9icGZ0b29sL0RvY3VtZW50YXRpb24vYnBmdG9vbC1n
ZW4ucnN0DQo+IGluZGV4IGI2YTExNGJmOTA4ZC4uODZhODdkYTk3ZDBiIDEwMDY0NA0KPiAtLS0g
YS90b29scy9icGYvYnBmdG9vbC9Eb2N1bWVudGF0aW9uL2JwZnRvb2wtZ2VuLnJzdA0KPiArKysg
Yi90b29scy9icGYvYnBmdG9vbC9Eb2N1bWVudGF0aW9uL2JwZnRvb2wtZ2VuLnJzdA0KPiBAQCAt
MTEyLDEzICsxMTIsMTQgQEAgREVTQ1JJUFRJT04NCj4gICANCj4gICAJCSAgSWYgQlBGIG9iamVj
dCBoYXMgZ2xvYmFsIHZhcmlhYmxlcywgY29ycmVzcG9uZGluZyBzdHJ1Y3RzDQo+ICAgCQkgIHdp
dGggbWVtb3J5IGxheW91dCBjb3JyZXNwb25kaW5nIHRvIGdsb2JhbCBkYXRhIGRhdGEgc2VjdGlv
bg0KPiAtCQkgIGxheW91dCB3aWxsIGJlIGNyZWF0ZWQuIEN1cnJlbnRseSBzdXBwb3J0ZWQgb25l
cyBhcmU6IC5kYXRhLA0KPiAtCQkgIC5ic3MsIC5yb2RhdGEsIGFuZCAuZXh0ZXJuIHN0cnVjdHMv
ZGF0YSBzZWN0aW9ucy4gVGhlc2UNCj4gLQkJICBkYXRhIHNlY3Rpb25zL3N0cnVjdHMgY2FuIGJl
IHVzZWQgdG8gc2V0IHVwIGluaXRpYWwgdmFsdWVzIG9mDQo+IC0JCSAgdmFyaWFibGVzLCBpZiBz
ZXQgYmVmb3JlICoqZXhhbXBsZV9fbG9hZCoqLiBBZnRlcndhcmRzLCBpZg0KPiAtCQkgIHRhcmdl
dCBrZXJuZWwgc3VwcG9ydHMgbWVtb3J5LW1hcHBlZCBCUEYgYXJyYXlzLCBzYW1lDQo+IC0JCSAg
c3RydWN0cyBjYW4gYmUgdXNlZCB0byBmZXRjaCBhbmQgdXBkYXRlIChub24tcmVhZC1vbmx5KQ0K
PiAtCQkgIGRhdGEgZnJvbSB1c2Vyc3BhY2UsIHdpdGggc2FtZSBzaW1wbGljaXR5IGFzIGZvciBC
UEYgc2lkZS4NCj4gKwkJICBsYXlvdXQgd2lsbCBiZSBjcmVhdGVkLiBDdXJyZW50bHkgc3VwcG9y
dGVkIG9uZXMgYXJlOiAqLmRhdGEqLA0KPiArCQkgICouYnNzKiwgKi5yb2RhdGEqLCBhbmQgKi5r
Y29uZmlnKiBzdHJ1Y3RzL2RhdGEgc2VjdGlvbnMuDQo+ICsJCSAgVGhlc2UgZGF0YSBzZWN0aW9u
cy9zdHJ1Y3RzIGNhbiBiZSB1c2VkIHRvIHNldCB1cCBpbml0aWFsDQo+ICsJCSAgdmFsdWVzIG9m
IHZhcmlhYmxlcywgaWYgc2V0IGJlZm9yZSAqKmV4YW1wbGVfX2xvYWQqKi4NCj4gKwkJICBBZnRl
cndhcmRzLCBpZiB0YXJnZXQga2VybmVsIHN1cHBvcnRzIG1lbW9yeS1tYXBwZWQgQlBGDQo+ICsJ
CSAgYXJyYXlzLCBzYW1lIHN0cnVjdHMgY2FuIGJlIHVzZWQgdG8gZmV0Y2ggYW5kIHVwZGF0ZQ0K
PiArCQkgIChub24tcmVhZC1vbmx5KSBkYXRhIGZyb20gdXNlcnNwYWNlLCB3aXRoIHNhbWUgc2lt
cGxpY2l0eQ0KPiArCQkgIGFzIGZvciBCUEYgc2lkZS4NCg0KU3RpbGwgZG9lcyBub3QgbG9vayBy
aWdodC4NCg0KQWZ0ZXIgYnVpbGQsIEkgZGlkIGBtYW4gLi9icGZ0b29sLWdlbi44YCwgYW5kIEkg
Z290IHRoZSBmb2xsb3dpbmcsDQoNCiAgICAgICAgICAgICAgICAgIHNwb25kaW5nIHRvIGdsb2Jh
bCBkYXRhIGRhdGEgc2VjdGlvbiBsYXlvdXQgd2lsbCBiZSANCmNyZWF0ZWQuIEN1cnJlbnRseSBz
dXBwb3J0ZWQgb25lcw0KICAgICAgICAgICAgICAgICAgYXJlOiAuZGF0YSwgZGF0YSBzZWN0aW9u
cy9zdHJ1Y3RzIGNhbiBiZSB1c2VkIHRvIHNldCANCnVwIGluaXRpYWwgdmFsdWVzIG9mICB2YXJp
YWJsZXMsDQoNCi5ic3MsIC5yb2RhdGEgLmtjb25maWcgZXRjLiBhcmUgbWlzc2luZy4gSSBhbSB1
c2luZzoNCg0KLWJhc2gtNC40JCBtYW4gLS12ZXJzaW9uDQptYW4gMi42LjMNCg0KPiAgIA0KPiAg
IAkqKmJwZnRvb2wgZ2VuIGhlbHAqKg0KPiAgIAkJICBQcmludCBzaG9ydCBoZWxwIG1lc3NhZ2Uu
DQo+IA0K
