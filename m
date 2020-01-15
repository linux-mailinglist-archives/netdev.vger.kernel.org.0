Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED9513CD1E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 20:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbgAOTaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 14:30:15 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28844 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725999AbgAOTaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 14:30:14 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00FJRQjY030068;
        Wed, 15 Jan 2020 11:30:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6tL51HUWwt1fR/kCMXZP9ibKtgflwGZEHpcElxhFVOw=;
 b=LXQk4M+UgnqhK6TPDTo5l/WdVuQzmr+sx6YkYdEsSsTQRz9618n/Wzde0JDZw7O8DE8N
 WDrcBDmYKsdLSZXjQE8oR2wuW+LvQFHn7zSVPY9ARpo/QHMZXv/sAWRr7ijYod4YAFmK
 CvBL0X1j6c2FZEdsAQ5YlRM4raPkjbymvXI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2xj5pt93s5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Jan 2020 11:30:00 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 15 Jan 2020 11:29:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kXSs33Wbutc3WNPTBoLsGqsyO9Mwcu9Het8v7yOsseV3x1gIp/CUVnr0ek67yNpp0dpaVzXioAmrOB/mxt2sm6YvWRAd4iGAGnMwRVcb7gtPsksiSjgLEDQYCWsJ4xhaZddGHKCYrA4Ov/lv+5BQYjA3nc83sn3EvTcCoiLpj/hXjU2FnUt0xTOXQRaVsd4GOmSwUvJQi2O7yICYtxYwqpzceOsiwsXkqAHMf8mDagFIKONkXtKSoOxbXQ0VjirtcpjzChEE4xa3nN3fr00jVKvXn1PlHHEsK+fsLvpnIvbqA36euSQwW4lMFwWVvoTv4UXB4EnN0KGZw6XcqV5y5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tL51HUWwt1fR/kCMXZP9ibKtgflwGZEHpcElxhFVOw=;
 b=TUuXyEQfqVqAKylYQR8diBNEWEddyocGA9d7oHUdNGWYYOyMRWXZ8tkw2mv/cAP4Q24kfe1VF+H1N4bbv1FLHgmutH1yz613BWHoAACAsOeQ4do3+FvUdzbYjB7osXsqw+6pUkIUBo/eY/fKob48ECHQpZWMhnGSrkY/6UiqinFTX1QmY9p81moge6f6UNmzw2neYHD7ph1bGQbfqXisVbAptTwNDYA//JQHsDCJhxJDCNfpa2rAdDYNU7f+PGo/o2zRbOtmjjvdNaCc/DI2ArnRCk/EjE485dkzwfzuQWJywI1y1vndyXrxKAS8s364T+8JmvaEnITyNT3C5orCWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tL51HUWwt1fR/kCMXZP9ibKtgflwGZEHpcElxhFVOw=;
 b=I/1ZblcEMdM4aCy6fZQuxlMRl8m4FAvDUskrl8YqBkN5munVJOxqXP6oZQsv/LAJC/x34gmQ1Thw/3V2U9qKLJRCmRH5XyHV5xp4mslI1Ipi0eC82TWFdJTgMKieMVVI2YfcALHG0tCpSvbDrebdGwas02S4ewRTCypyxHFu3o8=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB2380.namprd15.prod.outlook.com (20.176.68.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Wed, 15 Jan 2020 19:29:57 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::1d74:b392:183e:c8c2]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::1d74:b392:183e:c8c2%6]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 19:29:57 +0000
Received: from MacBook-Pro-52.local (2620:10d:c090:200::2:a3ec) by MWHPR14CA0044.namprd14.prod.outlook.com (2603:10b6:300:12b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Wed, 15 Jan 2020 19:29:56 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH v2 bpf-next] libbpf: support .text sub-calls relocations
Thread-Topic: [PATCH v2 bpf-next] libbpf: support .text sub-calls relocations
Thread-Index: AQHVy9or8lWMceNptE2+ChMCbmw5Ig==
Date:   Wed, 15 Jan 2020 19:29:57 +0000
Message-ID: <ea3953ba-6ee2-d565-c8ed-be3e32c9d70f@fb.com>
References: <20200115190856.2391325-1-andriin@fb.com>
In-Reply-To: <20200115190856.2391325-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0044.namprd14.prod.outlook.com
 (2603:10b6:300:12b::30) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:a3ec]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e400f0c8-3472-4a24-d525-08d799f14df8
x-ms-traffictypediagnostic: DM6PR15MB2380:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR15MB23804EC7B0752F997E912BF1D3370@DM6PR15MB2380.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(376002)(366004)(346002)(39860400002)(189003)(199004)(66446008)(52116002)(6486002)(2616005)(31696002)(110136005)(6506007)(66556008)(5660300002)(53546011)(316002)(8676002)(54906003)(66946007)(86362001)(66476007)(4326008)(8936002)(478600001)(36756003)(71200400001)(6512007)(81156014)(966005)(81166006)(64756008)(31686004)(16526019)(2906002)(186003)(142923001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2380;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YAJZlTHZbzjUUW4NPCiyG58PdpdsF7pvN12KirsZ3ZUWB6ZEhtXbTpsvJWLUMTv8U/rNsJiKQuOKLL+VmcnJw0bsH7HzV3GvnjxVHHUji1tm/LWOvmH1y9QMZ8Fl/XIzVVJlJe45cLjuILuvDCq4jWQVz9ibBlYfFSCvYYKl+UTM57TFoOXNFbo7/x+PNANDlDZsqOVVskJUqALViSwdGFZE8O2zFiITmOuXQoutY8vzoNj0b/jNwXMT1mNakg9k6c5IwsRDlHGqTO2wcwrnlMzoYxWQdB6qgKDOm/ON+rn/kHP+X2Qz93yg4bAs5vzlQa5sFaxqGXBgducILhc/3m2a9ln9P6L6xv1bNAJsaMpp2Sj0aq9EA6xyOYED4PZGS+oWc76h4wAmrqlBpR8CiRl1WFBIsSHz+28of2Oavh9ZXEwMNXoFvA4u8keUQEQgxNmJZX0g8P8Kv/1/ZJ5vrYsLRhXbsoX01q7OSt3rJYSEDy9A++hE+wLZx0dNzmTa/3uluSLak9FBECRfBMkDDw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <1309A7A24943B94083DCF2366311430B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e400f0c8-3472-4a24-d525-08d799f14df8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 19:29:57.2064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZBwzWXmFPhsrmHprfB1JUHwKTTDBzetnJrUbe1rCjSbsp+mabUrSL/6Cse8jPJdm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2380
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-15_02:2020-01-15,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001150149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvMTUvMjAgMTE6MDggQU0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gVGhlIExM
Vk0gcGF0Y2ggaHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBz
LTNBX19yZXZpZXdzLmxsdm0ub3JnX0Q3MjE5NyZkPUR3SUJBZyZjPTVWRDBSVHRObFRoM3ljZDQx
YjNNVXcmcj1EQThlMUI1cjA3M3ZJcVJyRno3TVJBJm09UHcyQmxqcWcxRDV6UFZITm1HNVc3TVRM
X2p4UF9teWZPT0M0Ty1ZU3BfTSZzPVNVbTJZX3VnaDVOVy1QOEllazI2M3NVTHZ1ZWJpUFN6V3d0
SjlKMVozMzAmZT0gIG1ha2VzIExMVk0gZW1pdCBmdW5jdGlvbiBjYWxsDQo+IHJlbG9jYXRpb25z
IHdpdGhpbiB0aGUgc2FtZSBzZWN0aW9uLiBUaGlzIGluY2x1ZGVzIGEgZGVmYXVsdCAudGV4dCBz
ZWN0aW9uLA0KPiB3aGljaCBjb250YWlucyBhbnkgQlBGIHN1Yi1wcm9ncmFtcy4gVGhpcyB3YXNu
J3QgdGhlIGNhc2UgYmVmb3JlIGFuZCBzbyBsaWJicGYNCj4gd2FzIGFibGUgdG8gZ2V0IGEgd2F5
IHdpdGggc2xpZ2h0bHkgc2ltcGxlciBoYW5kbGluZyBvZiBzdWJwcm9ncmFtIGNhbGwNCj4gcmVs
b2NhdGlvbnMuDQo+IA0KPiBUaGlzIHBhdGNoIGFkZHMgc3VwcG9ydCBmb3IgLnRleHQgc2VjdGlv
biByZWxvY2F0aW9ucy4gSXQgbmVlZHMgdG8gZW5zdXJlDQo+IGNvcnJlY3Qgb3JkZXIgb2YgcmVs
b2NhdGlvbnMsIHNvIGRvZXMgdHdvIHBhc3NlczoNCj4gLSBmaXJzdCwgcmVsb2NhdGUgLnRleHQg
aW5zdHJ1Y3Rpb25zLCBpZiB0aGVyZSBhcmUgYW55IHJlbG9jYXRpb25zIGluIGl0Ow0KPiAtIHRo
ZW4gcHJvY2VzcyBhbGwgdGhlIG90aGVyIHByb2dyYW1zIGFuZCBjb3B5IG92ZXIgcGF0Y2hlZCAu
dGV4dCBpbnN0cnVjdGlvbnMNCj4gZm9yIGFsbCBzdWItcHJvZ3JhbSBjYWxscy4NCj4gDQo+IHYx
LT52MjoNCj4gLSBicmVhayBlYXJseSBvbmNlIC50ZXh0IHByb2dyYW0gaXMgcHJvY2Vzc2VkLg0K
PiANCj4gQ2M6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo+IENjOiBBbGV4ZWkgU3Rhcm92
b2l0b3YgPGFzdEBrZXJuZWwub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa28g
PGFuZHJpaW5AZmIuY29tPg0KDQpUaGFua3MgZm9yIHRoZSBxdWljayBmaXghDQpBY2tlZC1ieTog
WW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCg==
