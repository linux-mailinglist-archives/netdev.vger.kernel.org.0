Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D605132DF7
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 19:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgAGSG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 13:06:59 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43438 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728366AbgAGSG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 13:06:59 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 007I5gGo022263;
        Tue, 7 Jan 2020 10:06:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=qfDk0lQY3SnoK3Kq1BN4ddSOgSvUNi+U/l7oms2sw9w=;
 b=STlZuwthY9dOeBs5xOjZ4ddJ+hM1tz3jHU3v2c+vO7orpO+OtPAZDfXszb/RFIL0b/Mv
 TkWkJiV8m77sxz3FnzkHRnvxa6HELArYOUW9YLW+jw+1TVHXSCNkpXBXdvShMeZmA6tT
 adzjMTWElOPD2vJyGbWWcPyM4rVQoiDd4r4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xbb4vmx2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 07 Jan 2020 10:06:38 -0800
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 7 Jan 2020 10:06:37 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 7 Jan 2020 10:06:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jkl5pWa7JQiP7fYlciDQI2RiK0aZxumbCHvp73R/+spIoHbF/SCjvIi9WxR1zDAmeAF9uC5bVfMJGjk8QMLH4Rnd22zty4Epb583KHDcp8O5SNbv6q2AUiwcCix51admezDTbo9IMwxRPi8AIeoKyjzFQNO+aIL2/Q6j1RRbzKxa/8MpX9dXLNJQGsAer6Q9D3vppfZkdnNMxX04aiESiljtC0oVy1JwHriydoR0ewCRNZJVRnQE10OYMPWjSuNOOv/U2Nbu/HsxzvLGUw7F+rRFaJe0Ps5gaQe+oW2HKnf/QuxJykiW39bdDsnlxsm11VCqbKZNILEw54f+FCID0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfDk0lQY3SnoK3Kq1BN4ddSOgSvUNi+U/l7oms2sw9w=;
 b=BFNAbWCuqxT4lruwJO95ttg33eTJsLauYF/4AUKkU46RxV0GczZeF4fdsoKoj+XmUfvh1AQF4BZjQfvSOfUrlmzP3rsJq/Yo/DvO8y7JCrZ7qfZKAWLX571CdfTxRUztlzmQ3YXdaxSyY8dyMLu/2tmCqUqZMKcWOA+5++kZokABWPH56qFGHJh3ZxcJ4XfQuCRObq0ETv1UfJ6gm4/Ozm3bh2coLKyU1sVvWYssjXde+2C3pX8bhhWYdzW3Vb8Xb0x+w0jlHFGuNtIoj6nW/PrushBHhUeK2S1I+56AYTvxyPI6nhfuJ74f+VrcrxER8eFXb0K/0t1K9bQKAAZTDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfDk0lQY3SnoK3Kq1BN4ddSOgSvUNi+U/l7oms2sw9w=;
 b=NAvhEad+4mVJ8vqR+QkzHNtSL4OHgU8+rOeloY63afm5z7v6NB/Ce3LTmDAjng9dE+nryHUiVm0Dah9Vb15/CSSjoDs0uuL3pFTNEUP6QJnwcB/X6iYL4ZAvgwe0naJUTrVvsQT5sPZ6jbXdMuCrmYAk+Lkwg59xr8zZ8JFBsSs=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1179.namprd15.prod.outlook.com (10.173.215.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 18:06:36 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b%11]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 18:06:36 +0000
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::1:2af9) by CO2PR05CA0104.namprd05.prod.outlook.com (2603:10b6:104:1::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.4 via Frontend Transport; Tue, 7 Jan 2020 18:06:34 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>
CC:     Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 02/11] bpf: add generic support for lookup and
 lookup_and_delete batch ops
Thread-Topic: [PATCH v3 bpf-next 02/11] bpf: add generic support for lookup
 and lookup_and_delete batch ops
Thread-Index: AQHVsHMkVh4m3HefgkGiZrFDkJ92tKe3zdyAgCceqACAALz4gA==
Date:   Tue, 7 Jan 2020 18:06:35 +0000
Message-ID: <19539914-f405-456d-37c5-fa25e0c672e4@fb.com>
References: <20191211223344.165549-1-brianvv@google.com>
 <20191211223344.165549-3-brianvv@google.com>
 <a2ce5033-fa75-c17b-ee97-8a7dcb67ab61@fb.com>
 <CABCgpaV47WD7wYG85pinv80JaNP7ZzqWM7JMnpKuJJaaadKR_w@mail.gmail.com>
In-Reply-To: <CABCgpaV47WD7wYG85pinv80JaNP7ZzqWM7JMnpKuJJaaadKR_w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0104.namprd05.prod.outlook.com
 (2603:10b6:104:1::30) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:2af9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be6fbe75-d107-44d4-aa76-08d7939c55b3
x-ms-traffictypediagnostic: DM5PR15MB1179:
x-microsoft-antispam-prvs: <DM5PR15MB11797481EA2041B75C3AE3E3D33F0@DM5PR15MB1179.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(39860400002)(346002)(136003)(199004)(189003)(54906003)(316002)(2616005)(6916009)(2906002)(66946007)(4326008)(6512007)(66556008)(66446008)(66476007)(64756008)(8936002)(86362001)(71200400001)(53546011)(7416002)(6506007)(36756003)(186003)(6486002)(81156014)(16526019)(31686004)(8676002)(478600001)(5660300002)(52116002)(31696002)(81166006)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1179;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LNOiPgeTLl2sHfwzgO0cyQ5a88k6TdGCGVTDnX2bGRZp1vvGRI07mp4EQ4JdwwEHFEyQ4T9kVCygmc0yNCuwvoDQ0SEQzoEiFy8v5MtdKWoVEsbMo8htilHAJXJDAp8IpKZ7Ef4YY86vQImTa0OtChSlelQebH29Csx7yJ79vciMlCUT+MTL2q+lRJ0eNsURjzO7P58F3ekrtI0xExK2WNAuBU3+6WRkAi0ohWOamxFdQR3zbrjlTYiunFexbaskOx4LARwtGfnf5Y2DBCjbKQjKrxjw/D361eEanQdO9EL+3f2iOlRYHSYcvuMjd4LJoZ9WvhDX7ZN4m8pbbsaB04hUgvjqMgpfIcw0N5u+VUNbicfos5w87Mv+akRb9kkLFhYs/r8sV44af78BmfGXZQ6d0khUOwjZSJ1v6c2XdAtbENQ5NgjcnmeWFf0QUjtRcV77xCcqn1QY/f3V9xT8hlTPJoOxlrHV3wAIzWP20nMYZ2EbguyZ0USLkAizcqwQ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8979D0B1A5A8364A90804B6E4596FBBE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: be6fbe75-d107-44d4-aa76-08d7939c55b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 18:06:35.9882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8mxu0cL6TrzZWtB2M9JKCs/toEeWyKqLN2NCDrQVcefXl8I8zyMre1+bq/i8tDyo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1179
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-07_06:2020-01-07,2020-01-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001070143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvNi8yMCAxMDo1MCBQTSwgQnJpYW4gVmF6cXVleiB3cm90ZToNCj4gT24gRnJpLCBE
ZWMgMTMsIDIwMTkgYXQgMTE6MjYgQU0gWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4gd3JvdGU6
DQo+Pg0KPj4NCj4+DQo+PiBPbiAxMi8xMS8xOSAyOjMzIFBNLCBCcmlhbiBWYXpxdWV6IHdyb3Rl
Og0KPj4+IFRoaXMgY29tbWl0IGludHJvZHVjZXMgZ2VuZXJpYyBzdXBwb3J0IGZvciB0aGUgYnBm
X21hcF9sb29rdXBfYmF0Y2ggYW5kDQo+Pj4gYnBmX21hcF9sb29rdXBfYW5kX2RlbGV0ZV9iYXRj
aCBvcHMuIFRoaXMgaW1wbGVtZW50YXRpb24gY2FuIGJlIHVzZWQgYnkNCj4+PiBhbG1vc3QgYWxs
IHRoZSBicGYgbWFwcyBzaW5jZSBpdHMgY29yZSBpbXBsZW1lbnRhdGlvbiBpcyByZWx5aW5nIG9u
IHRoZQ0KPj4+IGV4aXN0aW5nIG1hcF9nZXRfbmV4dF9rZXksIG1hcF9sb29rdXBfZWxlbSBhbmQg
bWFwX2RlbGV0ZV9lbGVtDQo+Pj4gZnVuY3Rpb25zLiBUaGUgYnBmIHN5c2NhbGwgc3ViY29tbWFu
ZHMgaW50cm9kdWNlZCBhcmU6DQo+Pj4NCj4+PiAgICAgQlBGX01BUF9MT09LVVBfQkFUQ0gNCj4+
PiAgICAgQlBGX01BUF9MT09LVVBfQU5EX0RFTEVURV9CQVRDSA0KPj4+DQo+Pj4gVGhlIFVBUEkg
YXR0cmlidXRlIGlzOg0KPj4+DQo+Pj4gICAgIHN0cnVjdCB7IC8qIHN0cnVjdCB1c2VkIGJ5IEJQ
Rl9NQVBfKl9CQVRDSCBjb21tYW5kcyAqLw0KPj4+ICAgICAgICAgICAgX19hbGlnbmVkX3U2NCAg
IGluX2JhdGNoOyAgICAgICAvKiBzdGFydCBiYXRjaCwNCj4+PiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICogTlVMTCB0byBzdGFydCBmcm9tIGJlZ2lubmluZw0K
Pj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKi8NCj4+PiAg
ICAgICAgICAgIF9fYWxpZ25lZF91NjQgICBvdXRfYmF0Y2g7ICAgICAgLyogb3V0cHV0OiBuZXh0
IHN0YXJ0IGJhdGNoICovDQo+Pj4gICAgICAgICAgICBfX2FsaWduZWRfdTY0ICAga2V5czsNCj4+
PiAgICAgICAgICAgIF9fYWxpZ25lZF91NjQgICB2YWx1ZXM7DQo+Pj4gICAgICAgICAgICBfX3Uz
MiAgICAgICAgICAgY291bnQ7ICAgICAgICAgIC8qIGlucHV0L291dHB1dDoNCj4+PiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogaW5wdXQ6ICMgb2Yga2V5L3Zh
bHVlDQo+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqIGVs
ZW1lbnRzDQo+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAq
IG91dHB1dDogIyBvZiBmaWxsZWQgZWxlbWVudHMNCj4+PiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICovDQo+Pj4gICAgICAgICAgICBfX3UzMiAgICAgICAgICAg
bWFwX2ZkOw0KPj4+ICAgICAgICAgICAgX191NjQgICAgICAgICAgIGVsZW1fZmxhZ3M7DQo+Pj4g
ICAgICAgICAgICBfX3U2NCAgICAgICAgICAgZmxhZ3M7DQo+Pj4gICAgIH0gYmF0Y2g7DQo+Pj4N
Cj4+PiBpbl9iYXRjaC9vdXRfYmF0Y2ggYXJlIG9wYXF1ZSB2YWx1ZXMgdXNlIHRvIGNvbW11bmlj
YXRlIGJldHdlZW4NCj4+PiB1c2VyL2tlcm5lbCBzcGFjZSwgaW5fYmF0Y2gvb3V0X2JhdGNoIG11
c3QgYmUgb2Yga2V5X3NpemUgbGVuZ3RoLg0KPj4+DQo+Pj4gVG8gc3RhcnQgaXRlcmF0aW5nIGZy
b20gdGhlIGJlZ2lubmluZyBpbl9iYXRjaCBtdXN0IGJlIG51bGwsDQo+Pj4gY291bnQgaXMgdGhl
ICMgb2Yga2V5L3ZhbHVlIGVsZW1lbnRzIHRvIHJldHJpZXZlLiBOb3RlIHRoYXQgdGhlICdrZXlz
Jw0KPj4+IGJ1ZmZlciBtdXN0IGJlIGEgYnVmZmVyIG9mIGtleV9zaXplICogY291bnQgc2l6ZSBh
bmQgdGhlICd2YWx1ZXMnIGJ1ZmZlcg0KPj4+IG11c3QgYmUgdmFsdWVfc2l6ZSAqIGNvdW50LCB3
aGVyZSB2YWx1ZV9zaXplIG11c3QgYmUgYWxpZ25lZCB0byA4IGJ5dGVzDQo+Pj4gYnkgdXNlcnNw
YWNlIGlmIGl0J3MgZGVhbGluZyB3aXRoIHBlcmNwdSBtYXBzLiAnY291bnQnIHdpbGwgY29udGFp
biB0aGUNCj4+PiBudW1iZXIgb2Yga2V5cy92YWx1ZXMgc3VjY2Vzc2Z1bGx5IHJldHJpZXZlZC4g
Tm90ZSB0aGF0ICdjb3VudCcgaXMgYW4NCj4+PiBpbnB1dC9vdXRwdXQgdmFyaWFibGUgYW5kIGl0
IGNhbiBjb250YWluIGEgbG93ZXIgdmFsdWUgYWZ0ZXIgYSBjYWxsLg0KPj4+DQo+Pj4gSWYgdGhl
cmUncyBubyBtb3JlIGVudHJpZXMgdG8gcmV0cmlldmUsIEVOT0VOVCB3aWxsIGJlIHJldHVybmVk
LiBJZiBlcnJvcg0KPj4+IGlzIEVOT0VOVCwgY291bnQgbWlnaHQgYmUgPiAwIGluIGNhc2UgaXQg
Y29waWVkIHNvbWUgdmFsdWVzIGJ1dCB0aGVyZSB3ZXJlDQo+Pj4gbm8gbW9yZSBlbnRyaWVzIHRv
IHJldHJpZXZlLg0KPj4+DQo+Pj4gTm90ZSB0aGF0IGlmIHRoZSByZXR1cm4gY29kZSBpcyBhbiBl
cnJvciBhbmQgbm90IC1FRkFVTFQsDQo+Pj4gY291bnQgaW5kaWNhdGVzIHRoZSBudW1iZXIgb2Yg
ZWxlbWVudHMgc3VjY2Vzc2Z1bGx5IHByb2Nlc3NlZC4NCj4+Pg0KPj4+IFN1Z2dlc3RlZC1ieTog
U3RhbmlzbGF2IEZvbWljaGV2IDxzZGZAZ29vZ2xlLmNvbT4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBC
cmlhbiBWYXpxdWV6IDxicmlhbnZ2QGdvb2dsZS5jb20+DQo+Pj4gU2lnbmVkLW9mZi1ieTogWW9u
Z2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCj4+PiAtLS0NCj4+PiAgICBpbmNsdWRlL2xpbnV4L2Jw
Zi5oICAgICAgfCAgMTEgKysrDQo+Pj4gICAgaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIHwgIDE5
ICsrKysrDQo+Pj4gICAga2VybmVsL2JwZi9zeXNjYWxsLmMgICAgIHwgMTcyICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPj4+ICAgIDMgZmlsZXMgY2hhbmdlZCwgMjAy
IGluc2VydGlvbnMoKykNCj4+IFsuLi5dDQo+Pj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9icGYvc3lz
Y2FsbC5jIGIva2VybmVsL2JwZi9zeXNjYWxsLmMNCj4+PiBpbmRleCAyNTMwMjY2ZmE2NDc3Li43
MDhhYTg5ZmUyMzA4IDEwMDY0NA0KPj4+IC0tLSBhL2tlcm5lbC9icGYvc3lzY2FsbC5jDQo+Pj4g
KysrIGIva2VybmVsL2JwZi9zeXNjYWxsLmMNCj4+PiBAQCAtMTIwNiw2ICsxMjA2LDEyMCBAQCBz
dGF0aWMgaW50IG1hcF9nZXRfbmV4dF9rZXkodW5pb24gYnBmX2F0dHIgKmF0dHIpDQo+Pj4gICAg
ICAgIHJldHVybiBlcnI7DQo+Pj4gICAgfQ0KPj4+DQo+Pj4gKyNkZWZpbmUgTUFQX0xPT0tVUF9S
RVRSSUVTIDMNCj4+PiArDQo+Pj4gK3N0YXRpYyBpbnQgX19nZW5lcmljX21hcF9sb29rdXBfYmF0
Y2goc3RydWN0IGJwZl9tYXAgKm1hcCwNCj4+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBjb25zdCB1bmlvbiBicGZfYXR0ciAqYXR0ciwNCj4+PiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB1bmlvbiBicGZfYXR0ciBfX3VzZXIgKnVhdHRyLA0KPj4+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJvb2wgZG9fZGVsZXRlKQ0KPj4+ICt7
DQo+Pj4gKyAgICAgdm9pZCBfX3VzZXIgKnViYXRjaCA9IHU2NF90b191c2VyX3B0cihhdHRyLT5i
YXRjaC5pbl9iYXRjaCk7DQo+Pj4gKyAgICAgdm9pZCBfX3VzZXIgKnVvYmF0Y2ggPSB1NjRfdG9f
dXNlcl9wdHIoYXR0ci0+YmF0Y2gub3V0X2JhdGNoKTsNCj4+PiArICAgICB2b2lkIF9fdXNlciAq
dmFsdWVzID0gdTY0X3RvX3VzZXJfcHRyKGF0dHItPmJhdGNoLnZhbHVlcyk7DQo+Pj4gKyAgICAg
dm9pZCBfX3VzZXIgKmtleXMgPSB1NjRfdG9fdXNlcl9wdHIoYXR0ci0+YmF0Y2gua2V5cyk7DQo+
Pj4gKyAgICAgdm9pZCAqYnVmLCAqcHJldl9rZXksICprZXksICp2YWx1ZTsNCj4+PiArICAgICB1
MzIgdmFsdWVfc2l6ZSwgY3AsIG1heF9jb3VudDsNCj4+PiArICAgICBib29sIGZpcnN0X2tleSA9
IGZhbHNlOw0KPj4+ICsgICAgIGludCBlcnIsIHJldHJ5ID0gTUFQX0xPT0tVUF9SRVRSSUVTOw0K
Pj4NCj4+IENvdWxkIHlvdSB0cnkgdG8gdXNlIHJldmVyc2UgQ2hyaXN0bWFzIHRyZWUgc3R5bGUg
ZGVjbGFyYXRpb24gaGVyZT8NCj4gDQo+IEFDSw0KPj4NCj4+PiArDQo+Pj4gKyAgICAgaWYgKGF0
dHItPmJhdGNoLmVsZW1fZmxhZ3MgJiB+QlBGX0ZfTE9DSykNCj4+PiArICAgICAgICAgICAgIHJl
dHVybiAtRUlOVkFMOw0KPj4+ICsNCj4+PiArICAgICBpZiAoKGF0dHItPmJhdGNoLmVsZW1fZmxh
Z3MgJiBCUEZfRl9MT0NLKSAmJg0KPj4+ICsgICAgICAgICAhbWFwX3ZhbHVlX2hhc19zcGluX2xv
Y2sobWFwKSkNCj4+PiArICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KPj4+ICsNCj4+PiAr
ICAgICB2YWx1ZV9zaXplID0gYnBmX21hcF92YWx1ZV9zaXplKG1hcCk7DQo+Pj4gKw0KPj4+ICsg
ICAgIG1heF9jb3VudCA9IGF0dHItPmJhdGNoLmNvdW50Ow0KPj4+ICsgICAgIGlmICghbWF4X2Nv
dW50KQ0KPj4+ICsgICAgICAgICAgICAgcmV0dXJuIDA7DQo+Pj4gKw0KPj4+ICsgICAgIGJ1ZiA9
IGttYWxsb2MobWFwLT5rZXlfc2l6ZSArIHZhbHVlX3NpemUsIEdGUF9VU0VSIHwgX19HRlBfTk9X
QVJOKTsNCj4+PiArICAgICBpZiAoIWJ1ZikNCj4+PiArICAgICAgICAgICAgIHJldHVybiAtRU5P
TUVNOw0KPj4+ICsNCj4+PiArICAgICBlcnIgPSAtRUZBVUxUOw0KPj4+ICsgICAgIGZpcnN0X2tl
eSA9IGZhbHNlOw0KPj4+ICsgICAgIGlmICh1YmF0Y2ggJiYgY29weV9mcm9tX3VzZXIoYnVmLCB1
YmF0Y2gsIG1hcC0+a2V5X3NpemUpKQ0KPj4+ICsgICAgICAgICAgICAgZ290byBmcmVlX2J1ZjsN
Cj4+PiArICAgICBrZXkgPSBidWY7DQo+Pj4gKyAgICAgdmFsdWUgPSBrZXkgKyBtYXAtPmtleV9z
aXplOw0KPj4+ICsgICAgIGlmICghdWJhdGNoKSB7DQo+Pj4gKyAgICAgICAgICAgICBwcmV2X2tl
eSA9IE5VTEw7DQo+Pj4gKyAgICAgICAgICAgICBmaXJzdF9rZXkgPSB0cnVlOw0KPj4+ICsgICAg
IH0NCj4+PiArDQo+Pj4gKyAgICAgZm9yIChjcCA9IDA7IGNwIDwgbWF4X2NvdW50Oykgew0KPj4+
ICsgICAgICAgICAgICAgaWYgKGNwIHx8IGZpcnN0X2tleSkgew0KPj4+ICsgICAgICAgICAgICAg
ICAgICAgICByY3VfcmVhZF9sb2NrKCk7DQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgIGVyciA9
IG1hcC0+b3BzLT5tYXBfZ2V0X25leHRfa2V5KG1hcCwgcHJldl9rZXksIGtleSk7DQo+Pj4gKyAg
ICAgICAgICAgICAgICAgICAgIHJjdV9yZWFkX3VubG9jaygpOw0KPj4+ICsgICAgICAgICAgICAg
ICAgICAgICBpZiAoZXJyKQ0KPj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFr
Ow0KPj4+ICsgICAgICAgICAgICAgfQ0KPj4+ICsgICAgICAgICAgICAgZXJyID0gYnBmX21hcF9j
b3B5X3ZhbHVlKG1hcCwga2V5LCB2YWx1ZSwNCj4+PiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBhdHRyLT5iYXRjaC5lbGVtX2ZsYWdzLCBkb19kZWxldGUpOw0KPj4+ICsN
Cj4+PiArICAgICAgICAgICAgIGlmIChlcnIgPT0gLUVOT0VOVCkgew0KPj4+ICsgICAgICAgICAg
ICAgICAgICAgICBpZiAocmV0cnkpIHsNCj4+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICByZXRyeS0tOw0KPj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0K
Pj4+ICsgICAgICAgICAgICAgICAgICAgICB9DQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgIGVy
ciA9IC1FSU5UUjsNCj4+PiArICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+Pj4gKyAgICAg
ICAgICAgICB9DQo+Pj4gKw0KPj4+ICsgICAgICAgICAgICAgaWYgKGVycikNCj4+PiArICAgICAg
ICAgICAgICAgICAgICAgZ290byBmcmVlX2J1ZjsNCj4+PiArDQo+Pj4gKyAgICAgICAgICAgICBp
ZiAoY29weV90b191c2VyKGtleXMgKyBjcCAqIG1hcC0+a2V5X3NpemUsIGtleSwNCj4+PiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgbWFwLT5rZXlfc2l6ZSkpIHsNCj4+PiArICAgICAg
ICAgICAgICAgICAgICAgZXJyID0gLUVGQVVMVDsNCj4+PiArICAgICAgICAgICAgICAgICAgICAg
Z290byBmcmVlX2J1ZjsNCj4+PiArICAgICAgICAgICAgIH0NCj4+PiArICAgICAgICAgICAgIGlm
IChjb3B5X3RvX3VzZXIodmFsdWVzICsgY3AgKiB2YWx1ZV9zaXplLCB2YWx1ZSwgdmFsdWVfc2l6
ZSkpIHsNCj4+PiArICAgICAgICAgICAgICAgICAgICAgZXJyID0gLUVGQVVMVDsNCj4+PiArICAg
ICAgICAgICAgICAgICAgICAgZ290byBmcmVlX2J1ZjsNCj4+PiArICAgICAgICAgICAgIH0NCj4+
PiArDQo+Pj4gKyAgICAgICAgICAgICBwcmV2X2tleSA9IGtleTsNCj4+PiArICAgICAgICAgICAg
IHJldHJ5ID0gTUFQX0xPT0tVUF9SRVRSSUVTOw0KPj4+ICsgICAgICAgICAgICAgY3ArKzsNCj4+
PiArICAgICB9DQo+Pj4gKw0KPj4+ICsgICAgIGlmICghZXJyKSB7DQo+Pj4gKyAgICAgICAgICAg
ICByY3VfcmVhZF9sb2NrKCk7DQo+Pj4gKyAgICAgICAgICAgICBlcnIgPSBtYXAtPm9wcy0+bWFw
X2dldF9uZXh0X2tleShtYXAsIHByZXZfa2V5LCBrZXkpOw0KPj4+ICsgICAgICAgICAgICAgcmN1
X3JlYWRfdW5sb2NrKCk7DQo+Pj4gKyAgICAgfQ0KPj4+ICsNCj4+PiArICAgICBpZiAoZXJyKQ0K
Pj4+ICsgICAgICAgICAgICAgbWVtc2V0KGtleSwgMCwgbWFwLT5rZXlfc2l6ZSk7DQo+Pg0KPj4g
U28gaWYgYW55IGVycm9yIGhhcHBlbnMgZHVlIHRvIGFib3ZlIG1hcF9nZXRfbmV4dF9rZXkoKSBv
ciBlYXJsaWVyDQo+PiBlcnJvciwgdGhlIG5leHQgImJhdGNoIiByZXR1cm5lZCB0byB1c2VyIGNv
dWxkIGJlICIwIi4gV2hhdCBzaG91bGQNCj4+IHVzZXIgc3BhY2UgaGFuZGxlIHRoaXM/IFVsdGlt
YXRlbHksIHRoZSB1c2VyIHNwYWNlIG5lZWRzIHRvIHN0YXJ0DQo+PiBmcm9tIHRoZSBiZWdpbm5p
bmcgYWdhaW4/DQo+Pg0KPj4gV2hhdCBJIG1lYW4gaXMgaGVyZSBob3cgd2UgY291bGQgZGVzaWdu
IGFuIGludGVyZmFjZSBzbyB1c2VyDQo+PiBzcGFjZSwgaWYgbm8gLUVGQVVMVCBlcnJvciwgY2Fu
IHN1Y2Nlc3NmdWxseSBnZXQgYWxsIGVsZW1lbnRzDQo+PiB3aXRob3V0IGR1cGxpY2F0aW9uLg0K
Pj4NCj4+IE9uZSB3YXkgdG8gZG8gaGVyZSBpcyBqdXN0IHJldHVybiAtRUZBVUxUIGlmIHdlIGNh
bm5vdCBnZXQNCj4+IHByb3BlciBuZXh0IGtleS4gQnV0IG1heWJlIHdlIGNvdWxkIGhhdmUgYmV0
dGVyIG1lY2hhbmlzbQ0KPj4gd2hlbiB3ZSB0cnkgdG8gaW1wbGVtZW50IHdoYXQgdXNlciBzcGFj
ZSBjb2RlcyB3aWxsIGxvb2sgbGlrZS4NCj4gDQo+IEkgd2FzIHRoaW5raW5nIHRoYXQgaW5zdGVh
ZCBvZiB1c2luZyB0aGUgIm5leHQga2V5IiBhcyBhIHRva2VuIHdlDQo+IGNvdWxkIHVzZSB0aGUg
bGFzdCB2YWx1ZSBzdWNjZXNzZnVsbHkgY29waWVkIGFzIHRoZSB0b2tlbiwgdGhhdCB3YXkNCj4g
dXNlciBzcGFjZSBjb2RlIHdvdWxkIGFsd2F5cyBiZSBhYmxlIHRvIHN0YXJ0L3JldHJ5IGZyb20g
dGhlIGxhc3QNCj4gcHJvY2Vzc2VkIGVudHJ5LiBEbyB5b3UgdGhpbmsgdGhpcyB3b3VsZCB3b3Jr
Pw0KDQpZZXMsIHRoaXMgc2hvdWxkIHdvcmsuDQoNCg0KPj4NCj4+PiArDQo+Pj4gKyAgICAgaWYg
KChjb3B5X3RvX3VzZXIoJnVhdHRyLT5iYXRjaC5jb3VudCwgJmNwLCBzaXplb2YoY3ApKSB8fA0K
Pj4+ICsgICAgICAgICAgICAgICAgIChjb3B5X3RvX3VzZXIodW9iYXRjaCwga2V5LCBtYXAtPmtl
eV9zaXplKSkpKQ0KPj4+ICsgICAgICAgICAgICAgZXJyID0gLUVGQVVMVDsNCj4+PiArDQo+Pj4g
K2ZyZWVfYnVmOg0KPj4+ICsgICAgIGtmcmVlKGJ1Zik7DQo+Pj4gKyAgICAgcmV0dXJuIGVycjsN
Cj4+PiArfQ0KPj4+ICsNCj4+IFsuLi5dDQo=
