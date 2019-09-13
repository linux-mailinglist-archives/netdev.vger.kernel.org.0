Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B258B28AA
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 00:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404213AbfIMWuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 18:50:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14058 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404146AbfIMWuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 18:50:22 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8DMgqZv029646;
        Fri, 13 Sep 2019 15:49:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=BO80nIXH7tvz9sfpeO/smw4GxrnUGqSTb77BAhBLMJM=;
 b=C+nq7XBJbWcn+M05VPMAfjY+UzEZCO1Eb8qMmXbl0qALHEoHr92RDC9UWI2LjShRvtLH
 EfUjSn9Xj8gBTWnb7IQhA7wlEohLWR908OU0fDsSzJG7e2FPworOYRTe1ubvXQ4SlQP9
 G+UKbTW3xq2m0t8m2E/NwcPTLd4ndeKgX8A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2uytctxcb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Sep 2019 15:49:57 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Sep 2019 15:49:56 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Sep 2019 15:49:56 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 15:49:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFtPJAdKY7LMJIl8bnZFtasyNbdV6DBEAjyXjn3LKMcp4oCScQGLXglCDl2sJr0s9AbDhc2aeD4X5nXDIehGPOfzfzpvqgi5zO9MX0uRxXMGeRIhfP903bb9xllMX2vd6xcHfGNufE7IovVKrfEZg9Sr8IXQBmh89BIrmYt3iljsRhefUu7aY0DIHSnLBByRWWkwhjscIUgM2bhvzQ6A3pBuXXEb7/PJoJqUCFOXwJz5CjRIJrA9mulOd+nB2/yN5tGhK0nDMaJTcj+f5i32iep+xZn7lM6s0BcUqOGNF9hznQ1OqU+GzIXTGvTT7piwWnvSQ5CCk0S2kXd4Q4rWAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BO80nIXH7tvz9sfpeO/smw4GxrnUGqSTb77BAhBLMJM=;
 b=NdMMnChKQcZKo1rQYj9z2q2Bsk5bUiSx+cWXlJESPdJK5B+lrUbERVMg+oMFy/FC4VfPBXg+rjlK9P+FZiOZUiXs9bDAPYZUl5MPdd5lv9gq2zu/7TsEZgtyobLEqcLv4rq/n13tdz8SDA4v7kGEqETKvgIiBI7TO8yVgsIRdvg3HSDbLPwWjDd0a7wpwHorKacxD00zCCyENjy10r8BD7DheJ6wIxOuvI1ipq+hijGMzoY43Exz43BwE55tM7dPQNfhmJ/QsOUJRJSpNDLStUi8UT3jyB6M3KUwyMDfTc+0M7xQ19hs2Rim3bNwyLhIjQJblpsEHoJYKa5oeh9CIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BO80nIXH7tvz9sfpeO/smw4GxrnUGqSTb77BAhBLMJM=;
 b=eAdzXkUcd/4DXlzTcwNwIRn2IuBW+OITm1OXdD7MbkwhGOK9tAxpYgQsVme1VAABWVzk6eOLhcM9eUVLxa9fV1VHiNjjSX3W7icKNcuZbXuDywNlT+v5GUuZq/soj7WutuHOAweh+Ha9CywWW4ji7asghBbxrDUTxw+DnUNHICc=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2261.namprd15.prod.outlook.com (52.135.199.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Fri, 13 Sep 2019 22:49:55 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2263.021; Fri, 13 Sep 2019
 22:49:55 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Kevin Laatz <kevin.laatz@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>
CC:     "bruce.richardson@intel.com" <bruce.richardson@intel.com>,
        "ciara.loftus@intel.com" <ciara.loftus@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] libbpf: add xsk_umem__adjust_offset
Thread-Topic: [PATCH bpf-next] libbpf: add xsk_umem__adjust_offset
Thread-Index: AQHVaYEJ2LVtNebDt0+l8dcM9k6L/qcqOBkA
Date:   Fri, 13 Sep 2019 22:49:55 +0000
Message-ID: <2c14280f-a361-7d36-ffb0-02c2046fa3a1@fb.com>
References: <20190912072840.20947-1-kevin.laatz@intel.com>
In-Reply-To: <20190912072840.20947-1-kevin.laatz@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0038.namprd14.prod.outlook.com
 (2603:10b6:300:12b::24) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::ec5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d791b307-912d-4c2b-9b92-08d7389cb230
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2261;
x-ms-traffictypediagnostic: BYAPR15MB2261:
x-microsoft-antispam-prvs: <BYAPR15MB2261224AB1FC2BA84BFF6D7ED3B30@BYAPR15MB2261.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(346002)(366004)(376002)(189003)(199004)(8676002)(316002)(4326008)(7416002)(99286004)(71200400001)(52116002)(71190400001)(76176011)(6116002)(6436002)(305945005)(7736002)(66476007)(6512007)(66556008)(66946007)(186003)(6246003)(53936002)(446003)(66446008)(386003)(2616005)(53546011)(5660300002)(102836004)(229853002)(6486002)(54906003)(14444005)(46003)(11346002)(64756008)(6506007)(14454004)(110136005)(256004)(476003)(478600001)(2906002)(25786009)(36756003)(31686004)(2201001)(81156014)(81166006)(8936002)(86362001)(31696002)(2501003)(486006)(101420200001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2261;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: q1fc4s0Zb7iguNx93lIJRasWz3dso9KaQwRWsdgao8ebNRNR5NW4j1xoSTAblsnd9/42sT7qzm1M8LiDffF6vaQwY63eGqugx+XmLRSN2F6Q7/tHZReLA3fPpeBN6HO6612bdWVgQ/1Dqz5mAza066i2h64gNXUY8IqA71dkku985rwmacXEPrvQa9iiT84yDsHRbBvmPcyEe1WmrS4ua3Kg8ymVme4naXiGnNZl4B3PxUxo300NMtmbjB35GP7u6rhFa/5ZQsPziKbY2yk9jtkFW98PWjPRcNmWvel9thDq1FOXiQ94MFPLc54TEeTP7gxtR6aZc02l4COYF16lCcRXt0ar1hqmO2TGigOus4ToTzSxb9C1QScKopwfrYFwc7gdarIHnVoHdeqtDav5zU0Qs/ZPwbCEi/fjI8cCP6o=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4455D98F9C35243A23743AB2E803447@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d791b307-912d-4c2b-9b92-08d7389cb230
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 22:49:55.4156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lbWpcmaLwh1V8HeBYcLQCQgzA2noBMdQMie870UqMtLG8Pm2JMnSHjFuxbja6DIt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2261
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_10:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 adultscore=0
 clxscore=1011 impostorscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909130222
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTIvMTkgODoyOCBBTSwgS2V2aW4gTGFhdHogd3JvdGU6DQo+IEN1cnJlbnRseSwg
eHNrX3VtZW1fYWRqdXN0X29mZnNldCBleGlzdHMgYXMgYSBrZXJuZWwgaW50ZXJuYWwgZnVuY3Rp
b24uDQo+IFRoaXMgcGF0Y2ggYWRkcyB4c2tfdW1lbV9fYWRqdXN0X29mZnNldCB0byBsaWJicGYg
c28gdGhhdCBpdCBjYW4gYmUgdXNlZA0KPiBmcm9tIHVzZXJzcGFjZS4gVGhpcyB3aWxsIHRha2Ug
dGhlIHJlc3BvbnNpYmlsaXR5IG9mIHByb3Blcmx5IHN0b3JpbmcgdGhlDQo+IG9mZnNldCBhd2F5
IGZyb20gdGhlIGFwcGxpY2F0aW9uLCBtYWtpbmcgaXQgbGVzcyBlcnJvciBwcm9uZS4NCj4gDQo+
IFNpbmNlIHhza191bWVtX19hZGp1c3Rfb2Zmc2V0IGlzIGNhbGxlZCBvbiBhIHBlci1wYWNrZXQg
YmFzaXMsIHdlIG5lZWQgdG8NCj4gaW5saW5lIHRoZSBmdW5jdGlvbiB0byBhdm9pZCBhbnkgcGVy
Zm9ybWFuY2UgcmVncmVzc2lvbnMuICBJbiBvcmRlciB0bw0KPiBpbmxpbmUgeHNrX3VtZW1fX2Fk
anVzdF9vZmZzZXQsIHdlIG5lZWQgdG8gYWRkIGl0IHRvIHhzay5oLiBVbmZvcnR1bmF0ZWx5DQo+
IHRoaXMgbWVhbnMgdGhhdCB3ZSBjYW4ndCBkZXJlZmVyZW5jZSB0aGUgeHNrX3VtZW1fY29uZmln
IHN0cnVjdCBkaXJlY3RseQ0KPiBzaW5jZSBpdCBpcyBkZWZpbmVkIG9ubHkgaW4geHNrLmMuIFdl
IHRoZXJlZm9yZSBhZGQgYW4gZXh0cmEgQVBJIHRvIHJldHVybg0KPiB0aGUgZmxhZ3MgZmllbGQg
dG8gdGhlIHVzZXIgZnJvbSB0aGUgc3RydWN0dXJlLCBhbmQgaGF2ZSB0aGUgaW5saW5lDQo+IGZ1
bmN0aW9uIHVzZSB0aGlzIGZsYWdzIGZpZWxkIGRpcmVjdGx5Lg0KDQpDb3VsZCB5b3UgYWRkIGFu
IGV4YW1wbGUgKGVpdGhlciBpbiBzYW1wbGVzL2JwZiBvciBpbiANCnRvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzL2JwZikgdG8gdXNlIHhza191bWVtX19hZGp1c3Rfb2Zmc2V0KCk/IFRoaXMgd2lsbCAN
Cm1ha2UgaXQNCmVhc2llciB0byBjaGVjayB3aGV0aGVyIHRoZSBpbnRlcmZhY2UgaXMgYXBwcm9w
cmlhdGUgb3Igbm90IGFuZA0Kd2hhdCBpcyB0aGUgcGVyZm9ybWFuY2UgaW1wbGljYXRpb24gYXMg
eW91IHN0YXRlZCBpbiB0aGUgYWJvdmUuDQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEtldmluIExh
YXR6IDxrZXZpbi5sYWF0ekBpbnRlbC5jb20+DQo+IC0tLQ0KPiAgIHRvb2xzL2xpYi9icGYvbGli
YnBmLm1hcCB8ICAxICsNCj4gICB0b29scy9saWIvYnBmL3hzay5jICAgICAgfCAgNSArKysrKw0K
PiAgIHRvb2xzL2xpYi9icGYveHNrLmggICAgICB8IDE0ICsrKysrKysrKysrKysrDQo+ICAgMyBm
aWxlcyBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMv
bGliL2JwZi9saWJicGYubWFwIGIvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+IGluZGV4IGQw
NGM3Y2I2MjNlZC4uNzYwMzUwYzliODFjIDEwMDY0NA0KPiAtLS0gYS90b29scy9saWIvYnBmL2xp
YmJwZi5tYXANCj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+IEBAIC0xODksNCAr
MTg5LDUgQEAgTElCQlBGXzAuMC40IHsNCj4gICBMSUJCUEZfMC4wLjUgew0KPiAgIAlnbG9iYWw6
DQo+ICAgCQlicGZfYnRmX2dldF9uZXh0X2lkOw0KPiArCQl4c2tfdW1lbV9fZ2V0X2ZsYWdzOw0K
PiAgIH0gTElCQlBGXzAuMC40Ow0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi94c2suYyBi
L3Rvb2xzL2xpYi9icGYveHNrLmMNCj4gaW5kZXggODQyYzRmZDU1ODU5Li5hNDI1MGE3MjFlYTYg
MTAwNjQ0DQo+IC0tLSBhL3Rvb2xzL2xpYi9icGYveHNrLmMNCj4gKysrIGIvdG9vbHMvbGliL2Jw
Zi94c2suYw0KPiBAQCAtODQsNiArODQsMTEgQEAgaW50IHhza19zb2NrZXRfX2ZkKGNvbnN0IHN0
cnVjdCB4c2tfc29ja2V0ICp4c2spDQo+ICAgCXJldHVybiB4c2sgPyB4c2stPmZkIDogLUVJTlZB
TDsNCj4gICB9DQo+ICAgDQo+ICtfX3UzMiB4c2tfdW1lbV9fZ2V0X2ZsYWdzKHN0cnVjdCB4c2tf
dW1lbSAqdW1lbSkNCj4gK3sNCj4gKwlyZXR1cm4gdW1lbS0+Y29uZmlnLmZsYWdzOw0KPiArfQ0K
PiArDQo+ICAgc3RhdGljIGJvb2wgeHNrX3BhZ2VfYWxpZ25lZCh2b2lkICpidWZmZXIpDQo+ICAg
ew0KPiAgIAl1bnNpZ25lZCBsb25nIGFkZHIgPSAodW5zaWduZWQgbG9uZylidWZmZXI7DQo+IGRp
ZmYgLS1naXQgYS90b29scy9saWIvYnBmL3hzay5oIGIvdG9vbHMvbGliL2JwZi94c2suaA0KPiBp
bmRleCA1ODRmNjgyMGE2MzkuLmJmNzgyZmFjYjI3NCAxMDA2NDQNCj4gLS0tIGEvdG9vbHMvbGli
L2JwZi94c2suaA0KPiArKysgYi90b29scy9saWIvYnBmL3hzay5oDQo+IEBAIC0xODMsOCArMTgz
LDIyIEBAIHN0YXRpYyBpbmxpbmUgX191NjQgeHNrX3VtZW1fX2FkZF9vZmZzZXRfdG9fYWRkcihf
X3U2NCBhZGRyKQ0KPiAgIAlyZXR1cm4geHNrX3VtZW1fX2V4dHJhY3RfYWRkcihhZGRyKSArIHhz
a191bWVtX19leHRyYWN0X29mZnNldChhZGRyKTsNCj4gICB9DQo+ICAgDQo+ICsvKiBIYW5kbGUg
dGhlIG9mZnNldCBhcHByb3ByaWF0ZWx5IGRlcGVuZGluZyBvbiBhbGlnbmVkIG9yIHVuYWxpZ25l
ZCBtb2RlLg0KPiArICogRm9yIHVuYWxpZ25lZCBtb2RlLCB3ZSBzdG9yZSB0aGUgb2Zmc2V0IGlu
IHRoZSB1cHBlciAxNi1iaXRzIG9mIHRoZSBhZGRyZXNzLg0KPiArICogRm9yIGFsaWduZWQgbW9k
ZSwgd2Ugc2ltcGx5IGFkZCB0aGUgb2Zmc2V0IHRvIHRoZSBhZGRyZXNzLg0KPiArICovDQo+ICtz
dGF0aWMgaW5saW5lIF9fdTY0IHhza191bWVtX19hZGp1c3Rfb2Zmc2V0KF9fdTMyIHVtZW1fZmxh
Z3MsIF9fdTY0IGFkZHIsDQo+ICsJCQkJCSAgICBfX3U2NCBvZmZzZXQpDQo+ICt7DQo+ICsJaWYg
KHVtZW1fZmxhZ3MgJiBYRFBfVU1FTV9VTkFMSUdORURfQ0hVTktfRkxBRykNCj4gKwkJcmV0dXJu
IGFkZHIgKyAob2Zmc2V0IDw8IFhTS19VTkFMSUdORURfQlVGX09GRlNFVF9TSElGVCk7DQo+ICsJ
ZWxzZQ0KPiArCQlyZXR1cm4gYWRkciArIG9mZnNldDsNCj4gK30NCj4gKw0KPiAgIExJQkJQRl9B
UEkgaW50IHhza191bWVtX19mZChjb25zdCBzdHJ1Y3QgeHNrX3VtZW0gKnVtZW0pOw0KPiAgIExJ
QkJQRl9BUEkgaW50IHhza19zb2NrZXRfX2ZkKGNvbnN0IHN0cnVjdCB4c2tfc29ja2V0ICp4c2sp
Ow0KPiArTElCQlBGX0FQSSBfX3UzMiB4c2tfdW1lbV9fZ2V0X2ZsYWdzKHN0cnVjdCB4c2tfdW1l
bSAqdW1lbSk7DQo+ICAgDQo+ICAgI2RlZmluZSBYU0tfUklOR19DT05TX19ERUZBVUxUX05VTV9E
RVNDUyAgICAgIDIwNDgNCj4gICAjZGVmaW5lIFhTS19SSU5HX1BST0RfX0RFRkFVTFRfTlVNX0RF
U0NTICAgICAgMjA0OA0KPiANCg==
