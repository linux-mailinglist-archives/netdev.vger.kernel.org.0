Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097B612E9F8
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 19:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgABSec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 13:34:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61764 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727951AbgABSec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 13:34:32 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 002IQchS007420;
        Thu, 2 Jan 2020 10:34:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Ulprcnv7rwXr+y4nJdO2Dk29tcySHCghSH1SP0ocGig=;
 b=VCMkAdxzZFzeV8uDR0T1AiAoFK8zxhp8HB2BCADJ+pGjCZ99kI7M9ePhhnTVw5nLxyph
 dRIT9Id3XBwIYvs4gfkvUnOWpRIfHCJ8iqaHdwOq21J//HE7YorXWKJ4ZSL0HoSbci3W
 aoHcA0c9QakpGFUBTGsikOMuWrKgo5Rp4Z4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2x9au7tbjf-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 02 Jan 2020 10:34:15 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 2 Jan 2020 10:33:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EwICbuHeq7X1Oyh1Tgb/tFr+l5XEuWcNYFIC3VKEh5uYT7Xqc4KGMZGvx5nkzivbbZBpW7pyOfAAhRA1nvlXUAx5X8rhCVNHg5yF3tzEXO4iddOKeywyRNQG7coyS1BAOM4vibOKMiQgQEnxkgZD9S9JvDiD7sfGrIqKz1OQcfDpVIih/U8s+FNqL2YLC04zd3LIvvrPCQg/7HMDUnHlJ9xG0MUWx3wzVpkIHP7D5AHA0IfBM5IPypXQPVX0W84IHElJhtzVs8l0atfxqoZA9pNm+c9hmA4Uo+6BYvDYD23A/bjVPjxYlLgmekbAEnEwYvakAJDV3i4qyd3Qt7MxiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ulprcnv7rwXr+y4nJdO2Dk29tcySHCghSH1SP0ocGig=;
 b=YLiahWfbYYeewQNt4mMZFKeZxdyQHP69D4Jlr8/5bjIJszVbeO9XWYaxiooMG2Skv21C7OEk1O8fOT6Pq9fgymzwQhmf9zBPHgM5r/y/8MSDmSWD0hoEglXeM7Yrm2DjVWE/1yqkiQXL/S/F/HnpL78I6eHFV99nYfMRhDdvHBlBf9O67MA+9VSiI2SHn/Tq4K012hu16ajvRQUTJQv6G4ncry699qhtYBKB4ly2gUmptwMtXpCfcdvXFLtOUM4f6v7gkc5WVIABGHC6a89EaCnQb1/yY8I54nL17KQcl5pziNYip03nkWD9i4dG4xa/MRMO6YPmbOkC/WWYfkPbQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ulprcnv7rwXr+y4nJdO2Dk29tcySHCghSH1SP0ocGig=;
 b=YBBvlChP3KWxmvaQvTSQDGH4+e0UrtGzXCLY3t7xe91Bd/urhTuevFIigIV7Qq2FhLtUnUjLzg92yH65qyLspuHAdaNcSNqsmMRnXf2aGFjtBQ9QZP/6m1p/+J+pcwARVzQZWfHsjx1BtJpop0nbSc4qU2uEw/L/hXOIoPnWwic=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1658.namprd15.prod.outlook.com (10.175.107.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Thu, 2 Jan 2020 18:33:45 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b%11]) with mapi id 15.20.2581.014; Thu, 2 Jan 2020
 18:33:45 +0000
Received: from MacBook-Pro-52.local (2620:10d:c090:200::89dc) by MWHPR20CA0003.namprd20.prod.outlook.com (2603:10b6:300:13d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.10 via Frontend Transport; Thu, 2 Jan 2020 18:33:44 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Martin Lau <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Topic: [PATCH bpf-next v3 06/11] bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS
Thread-Index: AQHVwZsqFDEVdfynOEiSQDFaLex+FQ==
Date:   Thu, 2 Jan 2020 18:33:45 +0000
Message-ID: <75ae88e8-7c88-fea6-5505-1d96748a614d@fb.com>
References: <20191231062037.280596-1-kafai@fb.com>
 <20191231062050.281712-1-kafai@fb.com>
In-Reply-To: <20191231062050.281712-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0003.namprd20.prod.outlook.com
 (2603:10b6:300:13d::13) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::89dc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edd91c95-55ab-40e7-91f6-08d78fb24cd0
x-ms-traffictypediagnostic: DM5PR15MB1658:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB165896FB8BFD99B3AEFD02B3D3200@DM5PR15MB1658.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0270ED2845
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(366004)(376002)(136003)(396003)(189003)(199004)(43544003)(36756003)(64756008)(6506007)(53546011)(66476007)(478600001)(4326008)(16526019)(31686004)(6512007)(6486002)(66946007)(186003)(66556008)(66446008)(71200400001)(81166006)(81156014)(31696002)(86362001)(316002)(2906002)(8936002)(54906003)(5660300002)(8676002)(52116002)(2616005)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1658;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DgnJbyr/Ri/TpkfPGcXKLLCyduh+RCIwHw8NJ2YaAssRDuslOWVEkoS3SYFefi4uwjkb+FrMex9Umhz3F8crPVyiJTp0z0TK+Ycc2B9qiRD89rJa4Hq4GH2l8VcEeNnpf9IsERYlVXcmMxzgnSPjdLkDNCV3XSKkaeoig7gX6oVpKHxztYmZF67zONhzoKbRB5HwrtrjRxZ6zn51mqv+99AqCjzDPsWqbRxCOiEOtfS+Ab4Y+cBA4OtgK7kZMdc4C5PlOW1kcoAgDvZIJs1JUhjQWgtljFxz69XGRgxxa9bp+y+R52SQNizEkrgVzE8RJXh89Mbin8f5s88P0+qtjN/cC42ARxbxmsBEoBwBdAJ1/xbNJl4g9w+M/jKayeLkSDPaJjbpdgw8lkxz5yEJF9doZpq/BK5HbIIdZYrLxLX0om4oCX+MHH6p1pFQPCHdbo94tr7K0JTIACWE9fr+aoIaflAL4p30+66TGoI4apdL6Yu7XxRfcsksl5ab7BWX
Content-Type: text/plain; charset="utf-8"
Content-ID: <42C995CE6EDFC84BBE8026DEB2083299@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: edd91c95-55ab-40e7-91f6-08d78fb24cd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2020 18:33:45.3811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TG8Am1HCSqfWEZB8qViG4O5omfpj2+Q57bBXvvHupTovuBtm6z5SadYpJJMDgbvI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1658
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2020-01-02_06:2020-01-02,2020-01-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001020153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzMwLzE5IDEwOjIwIFBNLCBNYXJ0aW4gS2FGYWkgTGF1IHdyb3RlOg0KPiBUaGUg
cGF0Y2ggaW50cm9kdWNlcyBCUEZfTUFQX1RZUEVfU1RSVUNUX09QUy4gIFRoZSBtYXAgdmFsdWUN
Cj4gaXMgYSBrZXJuZWwgc3RydWN0IHdpdGggaXRzIGZ1bmMgcHRyIGltcGxlbWVudGVkIGluIGJw
ZiBwcm9nLg0KPiBUaGlzIG5ldyBtYXAgaXMgdGhlIGludGVyZmFjZSB0byByZWdpc3Rlci91bnJl
Z2lzdGVyL2ludHJvc3BlY3QNCj4gYSBicGYgaW1wbGVtZW50ZWQga2VybmVsIHN0cnVjdC4NCj4g
DQo+IFRoZSBrZXJuZWwgc3RydWN0IGlzIGFjdHVhbGx5IGVtYmVkZGVkIGluc2lkZSBhbm90aGVy
IG5ldyBzdHJ1Y3QNCj4gKG9yIGNhbGxlZCB0aGUgInZhbHVlIiBzdHJ1Y3QgaW4gdGhlIGNvZGUp
LiAgRm9yIGV4YW1wbGUsDQo+ICJzdHJ1Y3QgdGNwX2Nvbmdlc3Rpb25fb3BzIiBpcyBlbWJiZWRl
ZCBpbjoNCj4gc3RydWN0IGJwZl9zdHJ1Y3Rfb3BzX3RjcF9jb25nZXN0aW9uX29wcyB7DQo+IAly
ZWZjb3VudF90IHJlZmNudDsNCj4gCWVudW0gYnBmX3N0cnVjdF9vcHNfc3RhdGUgc3RhdGU7DQo+
IAlzdHJ1Y3QgdGNwX2Nvbmdlc3Rpb25fb3BzIGRhdGE7ICAvKiA8LS0ga2VybmVsIHN1YnN5c3Rl
bSBzdHJ1Y3QgaGVyZSAqLw0KPiB9DQo+IFRoZSBtYXAgdmFsdWUgaXMgInN0cnVjdCBicGZfc3Ry
dWN0X29wc190Y3BfY29uZ2VzdGlvbl9vcHMiLg0KPiBUaGUgImJwZnRvb2wgbWFwIGR1bXAiIHdp
bGwgdGhlbiBiZSBhYmxlIHRvIHNob3cgdGhlDQo+IHN0YXRlICgiaW51c2UiLyJ0b2JlZnJlZSIp
IGFuZCB0aGUgbnVtYmVyIG9mIHN1YnN5c3RlbSdzIHJlZmNudCAoZS5nLg0KPiBudW1iZXIgb2Yg
dGNwX3NvY2sgaW4gdGhlIHRjcF9jb25nZXN0aW9uX29wcyBjYXNlKS4gIFRoaXMgInZhbHVlIiBz
dHJ1Y3QNCj4gaXMgY3JlYXRlZCBhdXRvbWF0aWNhbGx5IGJ5IGEgbWFjcm8uICBIYXZpbmcgYSBz
ZXBhcmF0ZSAidmFsdWUiIHN0cnVjdA0KPiB3aWxsIGFsc28gbWFrZSBleHRlbmRpbmcgInN0cnVj
dCBicGZfc3RydWN0X29wc19YWVoiIGVhc2llciAoZS5nLiBhZGRpbmcNCj4gInZvaWQgKCppbml0
KSh2b2lkKSIgdG8gInN0cnVjdCBicGZfc3RydWN0X29wc19YWVoiIHRvIGRvIHNvbWUNCj4gaW5p
dGlhbGl6YXRpb24gd29ya3MgYmVmb3JlIHJlZ2lzdGVyaW5nIHRoZSBzdHJ1Y3Rfb3BzIHRvIHRo
ZSBrZXJuZWwNCj4gc3Vic3lzdGVtKS4gIFRoZSBsaWJicGYgd2lsbCB0YWtlIGNhcmUgb2YgZmlu
ZGluZyBhbmQgcG9wdWxhdGluZyB0aGUNCj4gInN0cnVjdCBicGZfc3RydWN0X29wc19YWVoiIGZy
b20gInN0cnVjdCBYWVoiLg0KPiANCj4gUmVnaXN0ZXIgYSBzdHJ1Y3Rfb3BzIHRvIGEga2VybmVs
IHN1YnN5c3RlbToNCj4gMS4gTG9hZCBhbGwgbmVlZGVkIEJQRl9QUk9HX1RZUEVfU1RSVUNUX09Q
UyBwcm9nKHMpDQo+IDIuIENyZWF0ZSBhIEJQRl9NQVBfVFlQRV9TVFJVQ1RfT1BTIHdpdGggYXR0
ci0+YnRmX3ZtbGludXhfdmFsdWVfdHlwZV9pZA0KPiAgICAgc2V0IHRvIHRoZSBidGYgaWQgInN0
cnVjdCBicGZfc3RydWN0X29wc190Y3BfY29uZ2VzdGlvbl9vcHMiIG9mIHRoZQ0KPiAgICAgcnVu
bmluZyBrZXJuZWwuDQo+ICAgICBJbnN0ZWFkIG9mIHJldXNpbmcgdGhlIGF0dHItPmJ0Zl92YWx1
ZV90eXBlX2lkLA0KPiAgICAgYnRmX3ZtbGludXhfdmFsdWVfdHlwZV9pZCBzIGFkZGVkIHN1Y2gg
dGhhdCBhdHRyLT5idGZfZmQgY2FuIHN0aWxsIGJlDQo+ICAgICB1c2VkIGFzIHRoZSAidXNlciIg
YnRmIHdoaWNoIGNvdWxkIHN0b3JlIG90aGVyIHVzZWZ1bCBzeXNhZG1pbi9kZWJ1Zw0KPiAgICAg
aW5mbyB0aGF0IG1heSBiZSBpbnRyb2R1Y2VkIGluIHRoZSBmdXJ0dXJlLA0KPiAgICAgZS5nLiBj
cmVhdGlvbi1kYXRlL2NvbXBpbGVyLWRldGFpbHMvbWFwLWNyZWF0b3IuLi5ldGMuDQo+IDMuIENy
ZWF0ZSBhICJzdHJ1Y3QgYnBmX3N0cnVjdF9vcHNfdGNwX2Nvbmdlc3Rpb25fb3BzIiBvYmplY3Qg
YXMgZGVzY3JpYmVkDQo+ICAgICBpbiB0aGUgcnVubmluZyBrZXJuZWwgYnRmLiAgUG9wdWxhdGUg
dGhlIHZhbHVlIG9mIHRoaXMgb2JqZWN0Lg0KPiAgICAgVGhlIGZ1bmN0aW9uIHB0ciBzaG91bGQg
YmUgcG9wdWxhdGVkIHdpdGggdGhlIHByb2cgZmRzLg0KPiA0LiBDYWxsIEJQRl9NQVBfVVBEQVRF
IHdpdGggdGhlIG9iamVjdCBjcmVhdGVkIGluICgzKSBhcw0KPiAgICAgdGhlIG1hcCB2YWx1ZS4g
IFRoZSBrZXkgaXMgYWx3YXlzICIwIi4NCj4gDQo+IER1cmluZyBCUEZfTUFQX1VQREFURSwgdGhl
IGNvZGUgdGhhdCBzYXZlcyB0aGUga2VybmVsLWZ1bmMtcHRyJ3MNCj4gYXJncyBhcyBhbiBhcnJh
eSBvZiB1NjQgaXMgZ2VuZXJhdGVkLiAgQlBGX01BUF9VUERBVEUgYWxzbyBhbGxvd3MNCj4gdGhl
IHNwZWNpZmljIHN0cnVjdF9vcHMgdG8gZG8gc29tZSBmaW5hbCBjaGVja3MgaW4gInN0X29wcy0+
aW5pdF9tZW1iZXIoKSINCj4gKGUuZy4gZW5zdXJlIGFsbCBtYW5kYXRvcnkgZnVuYyBwdHJzIGFy
ZSBpbXBsZW1lbnRlZCkuDQo+IElmIGV2ZXJ5dGhpbmcgbG9va3MgZ29vZCwgaXQgd2lsbCByZWdp
c3RlciB0aGlzIGtlcm5lbCBzdHJ1Y3QNCj4gdG8gdGhlIGtlcm5lbCBzdWJzeXN0ZW0uICBUaGUg
bWFwIHdpbGwgbm90IGFsbG93IGZ1cnRoZXIgdXBkYXRlDQo+IGZyb20gdGhpcyBwb2ludC4NCj4g
DQo+IFVucmVnaXN0ZXIgYSBzdHJ1Y3Rfb3BzIGZyb20gdGhlIGtlcm5lbCBzdWJzeXN0ZW06DQo+
IEJQRl9NQVBfREVMRVRFIHdpdGgga2V5ICIwIi4NCj4gDQo+IEludHJvc3BlY3QgYSBzdHJ1Y3Rf
b3BzOg0KPiBCUEZfTUFQX0xPT0tVUF9FTEVNIHdpdGgga2V5ICIwIi4gIFRoZSBtYXAgdmFsdWUg
cmV0dXJuZWQgd2lsbA0KPiBoYXZlIHRoZSBwcm9nIF9pZF8gcG9wdWxhdGVkIGFzIHRoZSBmdW5j
IHB0ci4NCj4gDQo+IFRoZSBtYXAgdmFsdWUgc3RhdGUgKGVudW0gYnBmX3N0cnVjdF9vcHNfc3Rh
dGUpIHdpbGwgdHJhbnNpdCBmcm9tOg0KPiBJTklUIChtYXAgY3JlYXRlZCkgPT4NCj4gSU5VU0Ug
KG1hcCB1cGRhdGVkLCBpLmUuIHJlZykgPT4NCj4gVE9CRUZSRUUgKG1hcCB2YWx1ZSBkZWxldGVk
LCBpLmUuIHVucmVnKQ0KPiANCj4gVGhlIGtlcm5lbCBzdWJzeXN0ZW0gbmVlZHMgdG8gY2FsbCBi
cGZfc3RydWN0X29wc19nZXQoKSBhbmQNCj4gYnBmX3N0cnVjdF9vcHNfcHV0KCkgdG8gbWFuYWdl
IHRoZSAicmVmY250IiBpbiB0aGUNCj4gInN0cnVjdCBicGZfc3RydWN0X29wc19YWVoiLiAgVGhp
cyBwYXRjaCB1c2VzIGEgc2VwYXJhdGUgcmVmY250DQo+IGZvciB0aGUgcHVyb3NlIG9mIHRyYWNr
aW5nIHRoZSBzdWJzeXN0ZW0gdXNhZ2UuICBBbm90aGVyIGFwcHJvYWNoDQo+IGlzIHRvIHJldXNl
IHRoZSBtYXAtPnJlZmNudCBhbmQgdGhlbiAic2hvdyIgKGkuZS4gZHVyaW5nIG1hcF9sb29rdXAp
DQo+IHRoZSBzdWJzeXN0ZW0ncyB1c2FnZSBieSBkb2luZyBtYXAtPnJlZmNudCAtIG1hcC0+dXNl
cmNudCB0byBmaWx0ZXIgb3V0DQo+IHRoZSBtYXAtZmQvcGlubmVkLW1hcCB1c2FnZS4gIEhvd2V2
ZXIsIHRoYXQgd2lsbCBhbHNvIHRpZSBkb3duIHRoZQ0KPiBmdXR1cmUgc2VtYW50aWNzIG9mIG1h
cC0+cmVmY250IGFuZCBtYXAtPnVzZXJjbnQuDQo+IA0KPiBUaGUgdmVyeSBmaXJzdCBzdWJzeXN0
ZW0ncyByZWZjbnQgKGR1cmluZyByZWcoKSkgaG9sZHMgb25lDQo+IGNvdW50IHRvIG1hcC0+cmVm
Y250LiAgV2hlbiB0aGUgdmVyeSBsYXN0IHN1YnN5c3RlbSdzIHJlZmNudA0KPiBpcyBnb25lLCBp
dCB3aWxsIGFsc28gcmVsZWFzZSB0aGUgbWFwLT5yZWZjbnQuICBBbGwgYnBmX3Byb2cgd2lsbCBi
ZQ0KPiBmcmVlZCB3aGVuIHRoZSBtYXAtPnJlZmNudCByZWFjaGVzIDAgKGkuZS4gZHVyaW5nIG1h
cF9mcmVlKCkpLg0KPiANCj4gSGVyZSBpcyBob3cgdGhlIGJwZnRvb2wgbWFwIGNvbW1hbmQgd2ls
bCBsb29rIGxpa2U6DQo+IFtyb290QGFyY2gtZmItdm0xIGJwZl0jIGJwZnRvb2wgbWFwIHNob3cN
Cj4gNjogc3RydWN0X29wcyAgbmFtZSBkY3RjcCAgZmxhZ3MgMHgwDQo+IAlrZXkgNEIgIHZhbHVl
IDI1NkIgIG1heF9lbnRyaWVzIDEgIG1lbWxvY2sgNDA5NkINCj4gCWJ0Zl9pZCA2DQo+IFtyb290
QGFyY2gtZmItdm0xIGJwZl0jIGJwZnRvb2wgbWFwIGR1bXAgaWQgNg0KPiBbew0KPiAgICAgICAg
ICAidmFsdWUiOiB7DQo+ICAgICAgICAgICAgICAicmVmY250Ijogew0KPiAgICAgICAgICAgICAg
ICAgICJyZWZzIjogew0KPiAgICAgICAgICAgICAgICAgICAgICAiY291bnRlciI6IDENCj4gICAg
ICAgICAgICAgICAgICB9DQo+ICAgICAgICAgICAgICB9LA0KPiAgICAgICAgICAgICAgInN0YXRl
IjogMSwNCj4gICAgICAgICAgICAgICJkYXRhIjogew0KPiAgICAgICAgICAgICAgICAgICJsaXN0
Ijogew0KPiAgICAgICAgICAgICAgICAgICAgICAibmV4dCI6IDAsDQo+ICAgICAgICAgICAgICAg
ICAgICAgICJwcmV2IjogMA0KPiAgICAgICAgICAgICAgICAgIH0sDQo+ICAgICAgICAgICAgICAg
ICAgImtleSI6IDAsDQo+ICAgICAgICAgICAgICAgICAgImZsYWdzIjogMiwNCj4gICAgICAgICAg
ICAgICAgICAiaW5pdCI6IDI0LA0KPiAgICAgICAgICAgICAgICAgICJyZWxlYXNlIjogMCwNCj4g
ICAgICAgICAgICAgICAgICAic3N0aHJlc2giOiAyNSwNCj4gICAgICAgICAgICAgICAgICAiY29u
Z19hdm9pZCI6IDMwLA0KPiAgICAgICAgICAgICAgICAgICJzZXRfc3RhdGUiOiAyNywNCj4gICAg
ICAgICAgICAgICAgICAiY3duZF9ldmVudCI6IDI4LA0KPiAgICAgICAgICAgICAgICAgICJpbl9h
Y2tfZXZlbnQiOiAyNiwNCj4gICAgICAgICAgICAgICAgICAidW5kb19jd25kIjogMjksDQo+ICAg
ICAgICAgICAgICAgICAgInBrdHNfYWNrZWQiOiAwLA0KPiAgICAgICAgICAgICAgICAgICJtaW5f
dHNvX3NlZ3MiOiAwLA0KPiAgICAgICAgICAgICAgICAgICJzbmRidWZfZXhwYW5kIjogMCwNCj4g
ICAgICAgICAgICAgICAgICAiY29uZ19jb250cm9sIjogMCwNCj4gICAgICAgICAgICAgICAgICAi
Z2V0X2luZm8iOiAwLA0KPiAgICAgICAgICAgICAgICAgICJuYW1lIjogWzk4LDExMiwxMDIsOTUs
MTAwLDk5LDExNiw5OSwxMTIsMCwwLDAsMCwwLDAsMA0KPiAgICAgICAgICAgICAgICAgIF0sDQo+
ICAgICAgICAgICAgICAgICAgIm93bmVyIjogMA0KPiAgICAgICAgICAgICAgfQ0KPiAgICAgICAg
ICB9DQo+ICAgICAgfQ0KPiBdDQo+IA0KPiBNaXNjIE5vdGVzOg0KPiAqIGJwZl9zdHJ1Y3Rfb3Bz
X21hcF9zeXNfbG9va3VwX2VsZW0oKSBpcyBhZGRlZCBmb3Igc3lzY2FsbCBsb29rdXAuDQo+ICAg
IEl0IGRvZXMgYW4gaW5wbGFjZSB1cGRhdGUgb24gIip2YWx1ZSIgaW5zdGVhZCByZXR1cm5pbmcg
YSBwb2ludGVyDQo+ICAgIHRvIHN5c2NhbGwuYy4gIE90aGVyd2lzZSwgaXQgbmVlZHMgYSBzZXBh
cmF0ZSBjb3B5IG9mICJ6ZXJvIiB2YWx1ZQ0KPiAgICBmb3IgdGhlIEJQRl9TVFJVQ1RfT1BTX1NU
QVRFX0lOSVQgdG8gYXZvaWQgcmFjZXMuDQo+IA0KPiAqIFRoZSBicGZfc3RydWN0X29wc19tYXBf
ZGVsZXRlX2VsZW0oKSBpcyBhbHNvIGNhbGxlZCB3aXRob3V0DQo+ICAgIHByZWVtcHRfZGlzYWJs
ZSgpIGZyb20gbWFwX2RlbGV0ZV9lbGVtKCkuICBJdCBpcyBiZWNhdXNlDQo+ICAgIHRoZSAiLT51
bnJlZygpIiBtYXkgcmVxdWlyZXMgc2xlZXBhYmxlIGNvbnRleHQsIGUuZy4NCj4gICAgdGhlICJ0
Y3BfdW5yZWdpc3Rlcl9jb25nZXN0aW9uX2NvbnRyb2woKSIuDQo+IA0KPiAqICJjb25zdCIgaXMg
YWRkZWQgdG8gc29tZSBvZiB0aGUgZXhpc3RpbmcgInN0cnVjdCBidGZfZnVuY19tb2RlbCAqIg0K
PiAgICBmdW5jdGlvbiBhcmcgdG8gYXZvaWQgYSBjb21waWxlciB3YXJuaW5nIGNhdXNlZCBieSB0
aGlzIHBhdGNoLg0KPiANCj4gQWNrZWQtYnk6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IE1hcnRpbiBLYUZhaSBMYXUgPGthZmFpQGZiLmNvbT4NCg0K
QWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo=
