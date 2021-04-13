Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198FD35E3AD
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241597AbhDMQUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:20:10 -0400
Received: from mx07-001d1705.pphosted.com ([185.132.183.11]:4878 "EHLO
        mx07-001d1705.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229776AbhDMQUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:20:09 -0400
X-Greylist: delayed 535 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2021 12:20:08 EDT
Received: from pps.filterd (m0209327.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13DG9Q98028144;
        Tue, 13 Apr 2021 16:19:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=t0YlqeHiODZMJlM6OZrChjvpWjHfrBr/u+OsqAboLH0=;
 b=SbxQTm3OlWJTRR/YlrMjABLNQf34gp0CFyBN+t9q2MprIO61hfBwsx8+da0MevmsKVMX
 K5cN9EUlLNaQK5fLmDIs3x7nuuOBd+Aj0ZlqFpHMJ8W6fWJg6eKdfyfjJX9AeQ1F6eyE
 iILK1RmuBdIntxLFhbkzCeTmzXAipmLdRVQqFQxVoY3Eu+0WLMW75i3uhOg03n8WMH3Y
 1nYLtfEQRG4u4DgnHOe8/O/mppO+6uqQtU+pGddbpgnttUiztwH9GzzBBn93HumZyPDy
 iJ+MJMqvrDNNWWdI+EOXhIo0BRwa5/ZFpH5a1hsFOEbilracpa/KeXYRDBenH7CRWD8J bA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx08-001d1705.pphosted.com with ESMTP id 37u2w3a53p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 16:19:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqRB8vD9K1cOcXpzJYxOQTXVI0zrPquES+02MkBWRXnu0NQXI8YPYCf8LUX66P/SBdONlCWv0AqpbU+rSwShdL/LQUchD+uohY7V6pWJAW2vuDJjygu1Cw2rba+DUVl5IwflJiamaJ7j/5xd96ygJYyP1l1uv8ba5s5O+WhmA/AePs3wS9Xqjbm7LJAauCAmYyoE6sFPvp5w6ZTKzyuKwHZe+VzsOz+hZIIPm89bZzEASpBtcXLr2+zE1D0RhzXlhUI0CEpvcxNhgWncbM87Rf6D3ZbiZ5dBrFY0JlOkrUfh/piEBRepJOqHM+DjZroR6lVQkEo2isMWtCSmo1Ld7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0YlqeHiODZMJlM6OZrChjvpWjHfrBr/u+OsqAboLH0=;
 b=X+Pp1YShGK/Ko7qOD6biWX67DVD7ctCdIIu7XUcxgPb7U0ZEW+BYPUjfA4HlAi8WjBF/aGyGrllmqMt3ShcVWzVuVn73vti29/RWPZq1oRMDzHkKR7Brvc4/p8f5PfSzVkCMUIa+nBotL7Yjixqb0f3/uzNqHMVClwT2s5/bVBNQyOGC0s+zpuFaAImtUJwtQC1a+KhG+pJE+IXYP33HuVmYPJk2TPjd2q2Jk1/3s8Bvn9hzSdHqYQ/6UgvjrgjDLqMoit6QpPBTgeomj4tir+dYguVNRlmSESK7RIgxu/W7qpQYGrCkmx8BN5TeWS0iV7EKtJh5bCyhjelLcyvBlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from BN7PR13MB2499.namprd13.prod.outlook.com (2603:10b6:406:ac::18)
 by BN8PR13MB2611.namprd13.prod.outlook.com (2603:10b6:408:81::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6; Tue, 13 Apr
 2021 16:19:21 +0000
Received: from BN7PR13MB2499.namprd13.prod.outlook.com
 ([fe80::24ab:22c1:7c5f:2ca6]) by BN7PR13MB2499.namprd13.prod.outlook.com
 ([fe80::24ab:22c1:7c5f:2ca6%7]) with mapi id 15.20.3999.016; Tue, 13 Apr 2021
 16:19:21 +0000
From:   <Tim.Bird@sony.com>
To:     <alexei.starovoitov@gmail.com>
CC:     <yang.lee@linux.alibaba.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <linux-kselftest@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] selftests/bpf: use !E instead of comparing with NULL
Thread-Topic: [PATCH] selftests/bpf: use !E instead of comparing with NULL
Thread-Index: AQHXMErV8JcfI63Nok6Yi06yGd1P+6qyj46AgAAONpCAAAGCAIAAAGSg
Date:   Tue, 13 Apr 2021 16:19:21 +0000
Message-ID: <BN7PR13MB2499152182E86AD94A3B0E22FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
References: <1618307549-78149-1-git-send-email-yang.lee@linux.alibaba.com>
 <CAADnVQJmsipci_ou6OOFGC6O9z935jFw4+pe7YQvvh2=eCoarQ@mail.gmail.com>
 <BN7PR13MB24996213858443821CA7E400FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
 <CAADnVQJJ03L5H11P0NYNC9kYy=YkQdWrbpytB2Jps8AuxgamFA@mail.gmail.com>
In-Reply-To: <CAADnVQJJ03L5H11P0NYNC9kYy=YkQdWrbpytB2Jps8AuxgamFA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=sony.com;
x-originating-ip: [136.175.96.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e509fc5-1b84-410c-2425-08d8fe97e572
x-ms-traffictypediagnostic: BN8PR13MB2611:
x-microsoft-antispam-prvs: <BN8PR13MB2611AA15C2F9F77379EF795EFD4F9@BN8PR13MB2611.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u3fb7mzdt9dyPrhPyUVacR8r/grUyg8Qn1rQ6xp3Gsgg/eUAv7a0AnBGMK3m91vCZxqsX5zVlK1fMUvr5bZoGgtrKT7KfaW1U256vCKTBFJctPvOphj3R5yNMY9Kcg8LxYaCjrV13Ki2BPmGoMf8KyYt0PQ7y+WE4ssPAi+3LE/eunnasqNnm4/Gt9ivhRsSki1qw+lGbfAnP7eSZmIx84OLQYBSYOSsM5qC15fBHk2mjvkdL6ZGmN45Tu+xhMRafsAJXTwaC8uoudiV292swTrbJDIfEuAWK1raIiLvzy3o3+B5J2f1XaADSQUToHFo0sfp3KsnrOiGfHNu6tIC5n2I+E5liN/zEBKEEtLeF9iSCWViBvoDKnji8viwzeyBgSdsh/+LJESMfqCtdKZRbhj0PMFX/SCKt7o8p5vzjXfNyag0Td6dTrvTRSXM2NPUHgcGc5hyJRjx5YCg0jWY6WpbJLIVsMswiv/hskx26ZiZYAOOPi2/ls4gMovNigfHhFU2pe17Xzi1v10uDgWpQifIDpenPHU6Tk9WWx0u6f0nsC2sa3pj09ALh8bMR3swHO0kcSZ/1zQZ25FBdtbnZVYdJlTH6Sj7gJbKgwhk1Y4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR13MB2499.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(186003)(2906002)(66946007)(4326008)(53546011)(6916009)(5660300002)(86362001)(33656002)(9686003)(83380400001)(55016002)(7416002)(52536014)(316002)(76116006)(71200400001)(54906003)(6506007)(8676002)(38100700002)(64756008)(66446008)(66556008)(66476007)(122000001)(26005)(7696005)(478600001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?V1h0R1FvNVdmSmNQNEtHY1hhZU9kdmpDUEhZdU1TVjVmNlhTNEFJcTdzQkR4?=
 =?utf-8?B?VkpZNXdCR1c3cGR0NE9hd3BqMFVxWTZtUDRiMGdLOU0yQmNtTDI3QzlYVVBH?=
 =?utf-8?B?b1dyai9wckRSbzMrSFZjZnBPYUdRcy9odDNxR2ZHUHN0Qk5NbGxjQnExMUhT?=
 =?utf-8?B?aS9LT0hwTmtKVVN3VjBCdHRWVHlQNnRTeE9nWkw3czZiWmcxVklKZUpjSkxU?=
 =?utf-8?B?ZTJYblc0WG5CNnBUMmF4WE5LT0Eyd3NETGV1MG5ZT3dkK002ekdaY2JOblkv?=
 =?utf-8?B?WlpyYlRwVGtnYlhWei9ObXh6S2JUMFhjTkRrbE5KZ2QvTFQvNTl6azN1T0pn?=
 =?utf-8?B?NGJLS081bml6VkpFdUFYM0IwZmphMlVMbTRQbm1IaldlTTNZSFQzRCtkNHVK?=
 =?utf-8?B?MXZGMDFLYkxLbjhCbmFaaXNVamdQUDVPZEdlSDVQdHhrQlpJUVlFSHlpK0F0?=
 =?utf-8?B?OFB5eGgvSll6QmprVmd3T0dvbHhscnJPQzVLZkR0OHFTdk5tYXNnNlQ2aFV0?=
 =?utf-8?B?enpWZDg0K1FNTVhwU1Bhek5GVm5xRFp1SHdXeXYyam16cGl4YzdJckM0eEJv?=
 =?utf-8?B?YW1iQkdZMW5UR2VkNUtvYVp1UnRzK3FkWGJJUEVaMlFaVU5ycEgxSkRueU9L?=
 =?utf-8?B?WDkveDRpYVNEZVB0NGtKelIwNUlvYWYxb0JTdU9DSkVLQmlNTjc0eW8rc3Ex?=
 =?utf-8?B?MS8vblhmUk8xYUkya1JTRmZjVkpkdEp1bDNlSU1RK2lKR0NaZkcyc2Y0K09Y?=
 =?utf-8?B?Skc4TFhUcmpyZWFqY2hlSlJMdmpJd284MHgzT3o4UHl5Wmo3UVZDRTNlcm51?=
 =?utf-8?B?WHRBT1Z2ZUJrNEY5TnFOWFBkeXJTcURjVURIYlhBVm9BaWhnenJVaEIxd0Mv?=
 =?utf-8?B?SnZsdmhnYXhrVU41OSsvN1Y2Q3BZbDFsallhYkxPUG0zMzN1YkorUWVkc3pP?=
 =?utf-8?B?VW1SK0s1cDM2dDFFcnh1Tk1teUhTVC9TUDlYdjdjdXRsSW1nT2c2Z3NMd1JY?=
 =?utf-8?B?NTZFb2tiQU1GYmZYMWZFK2dSOGM3RVVyeEFqR0RhSDZjdlJtWGtBWVFtbmlO?=
 =?utf-8?B?SEpHS2t6WW1JS2FVSHE2b05iUTJ3cFIwakEycHN6VVR6MzJvRVJJSHM5eXFx?=
 =?utf-8?B?Sk5kNmFsdDkvcGJZTUExRVdQa0lrbkVmMGI5ZnExNXdUQTJ2Z2dJTlBxcjJT?=
 =?utf-8?B?QXRvL1ZnbzFtU1NacFJBZ0xnN0hiTVJaeXRuUm9XVzBHZGZ6M0hWdnVQMDg3?=
 =?utf-8?B?RkQ0RmFKMTVrV3g1eHhEQm4yMmZCZUJZZ24wVjVzZ29sT3p6b0F1VWt2YlF1?=
 =?utf-8?B?dVd6N1dhQm5YLzFmMW52dEh4TGM2bUMzY3JacmVDZ1BBKzVyV21qNkdlZU1F?=
 =?utf-8?B?ZFgrenFZSkowcmUxaUNYL0NYOGF5amp2c24wWDJUbEhBcHJLdFA5U3FOREZa?=
 =?utf-8?B?YldRNnRpRU1jajEwZDVqNzhKZmFXNFZBSVVEYXlZQ3ZGbStqSC9sd2YrNVhi?=
 =?utf-8?B?dzVQYU1TSmgrVEdFcTFCR2xPbHZHWnBadnJOZjJoaUhqVWI0NWdOQWpMakNK?=
 =?utf-8?B?bTdWMzE3OVlZcXZVSU9EREFlbVV4MS9ZQXE1aGRFMmhvb3RsUHUrVzN5SGVn?=
 =?utf-8?B?QjZFWkpzQlZRdmRpRmNJTi83YlBkVFZxclBwR2MwY2lFUG9MV2drU1F1Y25G?=
 =?utf-8?B?ZWFWcEdSc3EwUHp6NFhvZW5BdUxYVkJEYXJSby8zdzBnQjNWQ1I5dDBQRjNV?=
 =?utf-8?Q?kI/Cpi7kNLsG+N7ookoeD64iottQKB2o0ZHdGVN?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR13MB2499.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e509fc5-1b84-410c-2425-08d8fe97e572
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 16:19:21.4765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WErho+mXB+hUUPdRE85NSZXKP8tQE6QXuFGFTikRtNAW0TRtG70VMBAjJ4ktsLQVk9Z9EMSYKWY0P4To8DoccA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR13MB2611
X-Proofpoint-ORIG-GUID: 9-WieRdSnN7Rt19__ndTSacKrOzrq3-r
X-Proofpoint-GUID: 9-WieRdSnN7Rt19__ndTSacKrOzrq3-r
X-Sony-Outbound-GUID: 9-WieRdSnN7Rt19__ndTSacKrOzrq3-r
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_09:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGV4ZWkgU3Rhcm92b2l0b3Yg
PGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+DQo+IA0KPiBPbiBUdWUsIEFwciAxMywgMjAy
MSBhdCA5OjEwIEFNIDxUaW0uQmlyZEBzb255LmNvbT4gd3JvdGU6DQo+ID4NCj4gPg0KPiA+DQo+
ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogQWxleGVpIFN0YXJv
dm9pdG92IDxhbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwuY29tPg0KPiA+ID4NCj4gPiA+IE9uIFR1
ZSwgQXByIDEzLCAyMDIxIGF0IDI6NTIgQU0gWWFuZyBMaSA8eWFuZy5sZWVAbGludXguYWxpYmFi
YS5jb20+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBGaXggdGhlIGZvbGxvd2luZyBjb2NjaWNo
ZWNrIHdhcm5pbmdzOg0KPiA+ID4gPiAuL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9n
cy9wcm9maWxlci5pbmMuaDoxODk6Ny0xMTogV0FSTklORw0KPiA+ID4gPiBjb21wYXJpbmcgcG9p
bnRlciB0byAwLCBzdWdnZXN0ICFFDQo+ID4gPiA+IC4vdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMv
YnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oOjM2MTo3LTExOiBXQVJOSU5HDQo+ID4gPiA+IGNvbXBh
cmluZyBwb2ludGVyIHRvIDAsIHN1Z2dlc3QgIUUNCj4gPiA+ID4gLi90b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9icGYvcHJvZ3MvcHJvZmlsZXIuaW5jLmg6Mzg2OjE0LTE4OiBXQVJOSU5HDQo+ID4g
PiA+IGNvbXBhcmluZyBwb2ludGVyIHRvIDAsIHN1Z2dlc3QgIUUNCj4gPiA+ID4gLi90b29scy90
ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvcHJvZmlsZXIuaW5jLmg6NDAyOjE0LTE4OiBXQVJO
SU5HDQo+ID4gPiA+IGNvbXBhcmluZyBwb2ludGVyIHRvIDAsIHN1Z2dlc3QgIUUNCj4gPiA+ID4g
Li90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvcHJvZmlsZXIuaW5jLmg6NDMzOjct
MTE6IFdBUk5JTkcNCj4gPiA+ID4gY29tcGFyaW5nIHBvaW50ZXIgdG8gMCwgc3VnZ2VzdCAhRQ0K
PiA+ID4gPiAuL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9maWxlci5pbmMu
aDo1MzQ6MTQtMTg6IFdBUk5JTkcNCj4gPiA+ID4gY29tcGFyaW5nIHBvaW50ZXIgdG8gMCwgc3Vn
Z2VzdCAhRQ0KPiA+ID4gPiAuL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9m
aWxlci5pbmMuaDo2MjU6Ny0xMTogV0FSTklORw0KPiA+ID4gPiBjb21wYXJpbmcgcG9pbnRlciB0
byAwLCBzdWdnZXN0ICFFDQo+ID4gPiA+IC4vdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3By
b2dzL3Byb2ZpbGVyLmluYy5oOjc2Nzo3LTExOiBXQVJOSU5HDQo+ID4gPiA+IGNvbXBhcmluZyBw
b2ludGVyIHRvIDAsIHN1Z2dlc3QgIUUNCj4gPiA+ID4NCj4gPiA+ID4gUmVwb3J0ZWQtYnk6IEFi
YWNpIFJvYm90IDxhYmFjaUBsaW51eC5hbGliYWJhLmNvbT4NCj4gPiA+ID4gU2lnbmVkLW9mZi1i
eTogWWFuZyBMaSA8eWFuZy5sZWVAbGludXguYWxpYmFiYS5jb20+DQo+ID4gPiA+IC0tLQ0KPiA+
ID4gPiAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oIHwg
MjIgKysrKysrKysrKystLS0tLS0tLS0tLQ0KPiA+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDExIGlu
c2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQ0KPiA+ID4gPg0KPiA+ID4gPiBkaWZmIC0tZ2l0
IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oIGIvdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oDQo+ID4gPiA+IGlu
ZGV4IDQ4OTZmZGY4Li5hMzMwNjZjIDEwMDY0NA0KPiA+ID4gPiAtLS0gYS90b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9icGYvcHJvZ3MvcHJvZmlsZXIuaW5jLmgNCj4gPiA+ID4gKysrIGIvdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oDQo+ID4gPiA+IEBAIC0x
ODksNyArMTg5LDcgQEAgc3RhdGljIElOTElORSB2b2lkIHBvcHVsYXRlX2FuY2VzdG9ycyhzdHJ1
Y3QgdGFza19zdHJ1Y3QqIHRhc2ssDQo+ID4gPiA+ICAjZW5kaWYNCj4gPiA+ID4gICAgICAgICBm
b3IgKG51bV9hbmNlc3RvcnMgPSAwOyBudW1fYW5jZXN0b3JzIDwgTUFYX0FOQ0VTVE9SUzsgbnVt
X2FuY2VzdG9ycysrKSB7DQo+ID4gPiA+ICAgICAgICAgICAgICAgICBwYXJlbnQgPSBCUEZfQ09S
RV9SRUFEKHBhcmVudCwgcmVhbF9wYXJlbnQpOw0KPiA+ID4gPiAtICAgICAgICAgICAgICAgaWYg
KHBhcmVudCA9PSBOVUxMKQ0KPiA+ID4gPiArICAgICAgICAgICAgICAgaWYgKCFwYXJlbnQpDQo+
ID4gPg0KPiA+ID4gU29ycnksIGJ1dCBJJ2QgbGlrZSB0aGUgcHJvZ3MgdG8gc3RheSBhcyBjbG9z
ZSBhcyBwb3NzaWJsZSB0byB0aGUgd2F5DQo+ID4gPiB0aGV5IHdlcmUgd3JpdHRlbi4NCj4gPiBX
aHk/DQo+ID4NCj4gPiA+IFRoZXkgbWlnaHQgbm90IGFkaGVyZSB0byBrZXJuZWwgY29kaW5nIHN0
eWxlIGluIHNvbWUgY2FzZXMuDQo+ID4gPiBUaGUgY29kZSBjb3VsZCBiZSBncm9zc2x5IGluZWZm
aWNpZW50IGFuZCBldmVuIGJ1Z2d5Lg0KPiA+IFRoZXJlIHdvdWxkIGhhdmUgdG8gYmUgYSByZWFs
bHkgZ29vZCByZWFzb24gdG8gYWNjZXB0DQo+ID4gZ3Jvc3NseSBpbmVmZmljaWVudCBhbmQgZXZl
biBidWdneSBjb2RlIGludG8gdGhlIGtlcm5lbC4NCj4gPg0KPiA+IENhbiB5b3UgcGxlYXNlIGV4
cGxhaW4gd2hhdCB0aGF0IHJlYXNvbiBpcz8NCj4gDQo+IEl0J3Mgbm90IHRoZSBrZXJuZWwuIEl0
J3MgYSB0ZXN0IG9mIGJwZiBwcm9ncmFtLg0KVGhhdCBkb2Vzbid0IGFuc3dlciB0aGUgcXVlc3Rp
b24gb2Ygd2h5IHlvdSBkb24ndCB3YW50IGFueSBjaGFuZ2VzLg0KDQpXaHkgd291bGQgd2Ugbm90
IHVzZSBrZXJuZWwgY29kaW5nIHN0eWxlIGd1aWRlbGluZXMgYW5kIHF1YWxpdHkgdGhyZXNob2xk
cyBmb3INCnRlc3RpbmcgY29kZT8gIFRoaXMgKmlzKiBnb2luZyBpbnRvIHRoZSBrZXJuZWwgc291
cmNlIHRyZWUsIHdoZXJlIGl0IHdpbGwgYmUNCm1haW50YWluZWQgYW5kIHVzZWQgYnkgb3RoZXIg
ZGV2ZWxvcGVycy4NCiAtLSBUaW0NCg0KDQo=
