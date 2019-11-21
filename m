Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6B51057C4
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 18:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKURBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 12:01:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34386 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbfKURBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 12:01:42 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALH0OwN008086;
        Thu, 21 Nov 2019 09:01:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XkPNy3vF8GU18VWADsRJWbm/cHzIhmBvFzdjvJtNB6Q=;
 b=OQwzTqDx+bja9LCiOB/+8uyYAfpMKTvS4em97XPGL4EZAcZZFteCu+H4mSxr3cKWI4zL
 HF2GtPbt1l54dQZdGnrItzJKiW7DOpYetbS1qFPmFFt/quwezH5V0LrVFmt8vcE6hUtI
 bJaB9SygTWk6HleheXkfsV+782jog0Vs2ng= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wdjunxsdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 09:01:25 -0800
Received: from prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 21 Nov 2019 09:01:24 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx01.TheFacebook.com (2620:10d:c081:6::15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 21 Nov 2019 09:01:24 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 21 Nov 2019 09:01:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DssuhyzvsqNclKf4PhYLVHFFaW31YRu5JQY7LWgHqmjHL5oXzsdfcqVkIX4yFB6+dtK7eEc4j090MTY6Iqn9OzCstO1JxpBzD5PAeIvf8TidRY9Zvhd9uP/k/2Fd1ZIq+7AVj9a7XcFSkX8+RpTqQgttuBddC688wQOGEknOD1toKPWq6S/CQRaN/OVH+qUYfjCbYKbTdNGXlWugjPKwxxgFHOWklxFVTZHTj8fFGF66hBp58nrTl5d5ZOR/GLCUu1dJZt8326bGqX4WueFKc1XSvRBBgjOr7102g15fSpY5v0qG3V5A91RRXlg8KDN3oFScMDRt9mucLdB9upy/YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XkPNy3vF8GU18VWADsRJWbm/cHzIhmBvFzdjvJtNB6Q=;
 b=GFNYiyNVqd4kWc4OuuaAqy3Ufdo4qmTQbW7CDG21SzZuK/9/EMECl2P+saot+JrU4o/aR/bLlJSVDoJnXJcum67/UeLruDvKyosCUy9W31+arIHCrNTOJjPd0OvqAkb8q9q/+TKcID0irUlCCjnfJnZCgRoooh8PPc+Lpw7MzeStUPFSQImmq1LPsQ89FhtRHRPf1o91WdpP/YxEcFq6nkySI627XD5aZqwl275iOwzduWufJON8WHWao1eWkYp7WOy7hZX8fKppPEunXkdrSxwRpzTYse04vIA2BdZi+DEgV7hECWM9VcX7yII9MMLapW5F719MRHVsxb7kRJsAqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XkPNy3vF8GU18VWADsRJWbm/cHzIhmBvFzdjvJtNB6Q=;
 b=ghB1lMConwJpHwxfBUU2Ts/gUZm3xLnrLp+hfFBkbH/K07ZJc9IUrJQlUCnhHN27ILWjfSUzbTA59ibc+HJlwDLzJTjo4qQweDJxGPspxQaHNDtghyXW8CLxeHJvsNW+GnbD+Z7A3HTumqC2ywEDXOuQkDvBvmuSc2urFTmU0wE=
Received: from CY4PR15MB1479.namprd15.prod.outlook.com (10.172.162.17) by
 CY4PR15MB1191.namprd15.prod.outlook.com (10.172.180.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Thu, 21 Nov 2019 17:01:22 +0000
Received: from CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::5cd:5069:d3ca:fe29]) by CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::5cd:5069:d3ca:fe29%4]) with mapi id 15.20.2451.031; Thu, 21 Nov 2019
 17:01:22 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Olsa <jolsa@redhat.com>,
        "Network Development" <netdev@vger.kernel.org>
Subject: Re: test failures after merge
Thread-Topic: test failures after merge
Thread-Index: AQHVoDvgrAoS/WewZ0O9O8koITzm66eV1YMAgAAEnAA=
Date:   Thu, 21 Nov 2019 17:01:22 +0000
Message-ID: <8f39ba41-483a-5285-007c-525770ba9ee0@fb.com>
References: <CAADnVQJ8NN3YV3Dws_V0gAiM21dH0=UDw6G=2O0OhYQ7Jj1CuA@mail.gmail.com>
 <CAADnVQJF3H=8_wLZOcC0jyOL-YsJ7-T5WpiiNA7XvvLOHfhCmA@mail.gmail.com>
In-Reply-To: <CAADnVQJF3H=8_wLZOcC0jyOL-YsJ7-T5WpiiNA7XvvLOHfhCmA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0011.namprd14.prod.outlook.com
 (2603:10b6:301:4b::21) To CY4PR15MB1479.namprd15.prod.outlook.com
 (2603:10b6:903:100::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2855]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a079fdeb-7e55-4833-ada8-08d76ea46fcb
x-ms-traffictypediagnostic: CY4PR15MB1191:
x-microsoft-antispam-prvs: <CY4PR15MB119102918E6902847B68AF05C64E0@CY4PR15MB1191.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(65956001)(6512007)(76176011)(2616005)(58126008)(3480700005)(5660300002)(52116002)(36756003)(11346002)(316002)(446003)(46003)(6246003)(4744005)(71190400001)(6116002)(6486002)(478600001)(65806001)(229853002)(8936002)(81156014)(71200400001)(99286004)(110136005)(86362001)(6506007)(53546011)(81166006)(102836004)(8676002)(386003)(305945005)(31696002)(66446008)(64756008)(31686004)(186003)(256004)(66946007)(66476007)(66556008)(14454004)(7736002)(25786009)(6436002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1191;H:CY4PR15MB1479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8dYYaGVt9gHM0Xg/dkQPI9gYY3DjGA99BnRs6tIBgf7fnDi3Vu2bihJAZTcvtHpICuERq/PkLTJGkk/ITiSqV417xoGHOxaH0bKvGd92J9zCPhOwKHiD+BeWGcLtBtAKdwhzbi1LZDi60scvD1R8piNSb48kwwZD78mmWplPjXIb5J9O1G3PKAa0+aeVrChFPz641dtJI1GJmJnFeP3b8oVhr0/iJhabJ9Xum9rxIgaaQ+WIufQdNAJloaBald/DsK2zVaTxL802oNqfXDWx/qXFBSo0Qaui+shjrU1EwMeHwftACwY7JRisl9pIl0lJGiyuOsreFoksxBYRRxhZEwk9Ke6Px+4qREqb8c1bHmkms2snqA4LG0Mhwn7EiipW7q1khyBZmmbKmYOC8/D7c9cHgaBegjI+QL8VwwAzYiX9uIvUFqJ24h4iAuZhnH49
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B44C90B66B5274CB56358DD3B1CD362@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a079fdeb-7e55-4833-ada8-08d76ea46fcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 17:01:22.7564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zWebglYABLUclDINKBEVgyT5SGvA8UFDocZvlbJOJJLREJCj8sNJl7ui9bnukJdd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1191
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_04:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 mlxscore=0 clxscore=1011 impostorscore=0 mlxlogscore=715
 bulkscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911210148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMjEvMTkgODo0NCBBTSwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPiBPbiBXZWQs
IE5vdiAyMCwgMjAxOSBhdCAxMToxNyBQTSBBbGV4ZWkgU3Rhcm92b2l0b3YNCj4gPGFsZXhlaS5z
dGFyb3ZvaXRvdkBnbWFpbC5jb20+IHdyb3RlOg0KPj4NCj4+IEhpIEFuZHJpaSwNCj4+DQo+PiBh
ZnRlciBicGYtbmV4dCBnb3QgbWVyZ2VkIGludG8gbmV0LW5leHQgbmV3IGZhaWx1cmVzIGFwcGVh
cmVkOg0KPj4gLi90ZXN0X3Byb2dzIC1uIDUvMQ0KPj4gdGVzdF9jb3JlX3JlbG9jOkZBSUw6Y2hl
Y2tfcmVzdWx0IG91dHB1dCBieXRlICMwOiBFWFAgMHgwMSBHT1QgMHgwMQ0KPj4gQ291bGQgeW91
IHBsZWFzZSB0YWtlIGEgbG9vaz8NCj4+IFRoYW5rcyENCj4gDQo+IEkgYmlzZWN0ZWQgYW5kIHR1
cm5lZCBvdXQgaXQgd2FzIGNhdXNlZCBieSBhdWRpdCBwYXRjaC4NCj4gRm9yIHNvbWUgcmVhc29u
IHRoZSB0ZXN0IGlzIHN0YWJsZSB3aXRoIGF1ZGl0Y3RsIC1lIDANCj4gYW5kIHJhbmRvbWx5IGZh
aWxzIHdoZW4gYXVkaXQgaXMgb24uDQo+IA0KDQpDYW4geW91IHJ1biBpdCB3aXRoIC12diBhbmQg
c2VuZCBtZSBmdWxsIG91dHB1dCwganVzdCBpbiBjYXNlIEkgY2FuJ3QgDQpyZXByb2R1Y2UgaGVy
ZSAocmVidWlsZGluZyBrZXJuZWwgYXQgdGhlIG1vbWVudCk/DQo=
