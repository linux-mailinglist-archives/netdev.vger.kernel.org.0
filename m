Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A404835E404
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345660AbhDMQdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:33:33 -0400
Received: from mx07-001d1705.pphosted.com ([185.132.183.11]:16038 "EHLO
        mx07-001d1705.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238649AbhDMQdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:33:31 -0400
Received: from pps.filterd (m0209329.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13DGW3oB029673;
        Tue, 13 Apr 2021 16:32:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=me5BXxMAos/UbROy55F4u1E8W1XDNcsGOFZJzr6WtNI=;
 b=GlfnrjBARsUx4XwlWfoGmyj5ji4ytxQ9ck5SCefPBMOUJjMqJgA06CRGftoMF8H1piUM
 Mp5gCb2vwJ7lP1l1R9sbXh91RnmWjZVqyTHkXI0G4cOSWdXktCYFLwU3sGo50AikjXS/
 2iCM0DAlGI6oC0tEb/B+VCJIWqryI+8FWFkpQtH4DoSiyPd8jhzhXCwfOAVrlKTIZ9tJ
 lAi7bKZolW+hxTFdsFolXfoqMrGagmnEdE+uIUYgUbxgCCCTw01eRfZhZdWrcO/kG4fL
 vASvkUPBnLj9ePlQpyQyeaSxWGQVkbHvg9nnMEmP8AarlkV8kpTQURykln3G4w4m4LgL mA== 
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2053.outbound.protection.outlook.com [104.47.37.53])
        by mx08-001d1705.pphosted.com with ESMTP id 37u2p0t5df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 16:32:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CT7OIsDCDrC45OEXaxqFhGfvKa0NpE0/pZLV+et5IHf/5+MXCtu1IlhEsJFrfr5iW4B6yz3QGYbEQ1dXfwn6XDTJDoxXPv1ZeHf7EUluwwbaryBKPCzHx25zMKjI/VwWcnuWvUfvkW0+0pP9oB61Gh8lOAdxvx79UjMfKIDQW/7YP/kMNH/gzPqoq2rjOzlOqbFiN01C/0UGOXD4WCYE7PCrBo3n9Tjym9xXLi9AV6q5o/zzWCe0WtZpd5JaTXW3uRbTRxo0UjiLUU4QqdhsGGl+M6m0J9tTdjCe+l0l2rPzWpl8CaHeHkG3HPAvrSK+ivjqP8HWTmmc+IyXbLTuyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=me5BXxMAos/UbROy55F4u1E8W1XDNcsGOFZJzr6WtNI=;
 b=Z8jdt3pDdlY6p9uVdSxzDGb/a69ArwtcHKlx8APeAurO5J50YLBFNjSMADV02W1BvUF1Yij8Vs+8O382oWS4y/2mwo5FNe0Fz/QtOcyot0/ts8Ac+c6E3WZ/C5yD8sB9A8Mwm9COsP+p4gueN3lBPZqxrqALFquE7YV7yuz8SFmA31HAMNUT33gI1yhZ4D3Lc25wMvLXYIVdKrkYzH2WEzx2bOcUSLKNq6j2bDh7+aizCkECAphlJYDyuFVUh/BVjq7ma7fzVCN4/6FE9Q0/9+Za1ZWfvBu6GGsTBCkAVKUI7yt7EDlxMxjMWgLmh0vYumbceH+JAYIoIDY54rAJ0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from BN7PR13MB2499.namprd13.prod.outlook.com (2603:10b6:406:ac::18)
 by BN6PR13MB0994.namprd13.prod.outlook.com (2603:10b6:404:22::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8; Tue, 13 Apr
 2021 16:32:37 +0000
Received: from BN7PR13MB2499.namprd13.prod.outlook.com
 ([fe80::24ab:22c1:7c5f:2ca6]) by BN7PR13MB2499.namprd13.prod.outlook.com
 ([fe80::24ab:22c1:7c5f:2ca6%7]) with mapi id 15.20.3999.016; Tue, 13 Apr 2021
 16:32:37 +0000
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
Thread-Index: AQHXMErV8JcfI63Nok6Yi06yGd1P+6qyj46AgAAONpCAAAGCAIAAAGSggAADW4CAAACiYA==
Date:   Tue, 13 Apr 2021 16:32:37 +0000
Message-ID: <BN7PR13MB2499EF2A7B6F043FE4E62D51FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
References: <1618307549-78149-1-git-send-email-yang.lee@linux.alibaba.com>
 <CAADnVQJmsipci_ou6OOFGC6O9z935jFw4+pe7YQvvh2=eCoarQ@mail.gmail.com>
 <BN7PR13MB24996213858443821CA7E400FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
 <CAADnVQJJ03L5H11P0NYNC9kYy=YkQdWrbpytB2Jps8AuxgamFA@mail.gmail.com>
 <BN7PR13MB2499152182E86AD94A3B0E22FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
 <CAADnVQKjVDLBCLMzXoAQhJ5a+rZ1EKqc3dyYqpeG9M2KzGREMA@mail.gmail.com>
In-Reply-To: <CAADnVQKjVDLBCLMzXoAQhJ5a+rZ1EKqc3dyYqpeG9M2KzGREMA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=sony.com;
x-originating-ip: [136.175.96.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 476dda61-ae4a-4bd0-debd-08d8fe99bf9e
x-ms-traffictypediagnostic: BN6PR13MB0994:
x-microsoft-antispam-prvs: <BN6PR13MB099429C7043903AA0576D707FD4F9@BN6PR13MB0994.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fjrqyXYhdlXLUqrhQumLs/5pF8fHt+PWpZrG1oeman+No//kn3o0woiCsEqAo7WkfNVpa0q0iDEXLtSSBdj0/nn539YF9Hk4cPwng5y2/TBhNhHQSx6U1/3LMliTC2YHQM9Ox1tHb86k6OdWCZ07LJ4HVdeGxJDwLF3Q0aAi64cBNerstedE7ydDPSZwT+n14u91AMC/hxhSweIbIoQ5EriBun+zYn7lKTuTCTGwVQY038/PAExMUTUJe3aCRpHAsuCQhD+Y7g3+8rEvWjY29KZmX3zxaISzkenIe3+NSu+r/DWqmuI0mKCXiPkNAhc4mCaY6wSYFohABpaemnaDgH9cFG5eSwW3Ero6598KdizHzf93DYNsuNPJgPR87MB6a4SxoDd7gxWGJup/0mliTcA6PmTUsfJRyiA8Ouszn0TXROOYwvy5m1kZ16yU0432B+hMGlUK5kVBHEPjr4ZR246Gb99kj+P0DZ01LJFAnJiXe3cjdSssdjydCVQpK5E7ftpZoyBVTeUgQQmSd8MmNhf+FZ6YxF3Y+6uVD8AgVcSyE0XXTZyuuuYCelQ82nveS6pRQ1ikYy4tfZt3bhprULegtorDQj4NEBmCJ48p3/s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR13MB2499.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(7416002)(8936002)(83380400001)(122000001)(6506007)(26005)(55016002)(33656002)(66556008)(52536014)(76116006)(4326008)(54906003)(8676002)(86362001)(6916009)(186003)(2906002)(9686003)(71200400001)(5660300002)(316002)(53546011)(38100700002)(64756008)(7696005)(478600001)(66946007)(66446008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RkVTM3V3SFBUUzkvcEREZ29XUHZ2U251clZLM0d0Vy9NSk1mNWx4RlV2ckgv?=
 =?utf-8?B?Q1luVkdQbnJVZ0lNTnUxOU8vdUdWZVhzTkRXV3ExRVUwWU5sNU5nNDNYZmlN?=
 =?utf-8?B?Y3BweEJ1azRUZUFzOHE2M2F2cDY5NEoreUxRWGZDMEgxTDFkMW9sNEVFd1FF?=
 =?utf-8?B?VkFlMFZ0SldxdmJIYnl0Nnl6ejZvaTNKZ0pRUytUVUp4K1FRVGx4SFJoY1VR?=
 =?utf-8?B?dHZuVDlRdlVvT3k0VUtZV0JKeFpsVXgwalRxNHUza1JHVjFObGlRSG15blVv?=
 =?utf-8?B?UGM3RmI4ZE12ajBHMkRSL1doeDdoM3V2QUFWc3p0Sjh6aVBMa29PTGZYcmVS?=
 =?utf-8?B?bkhWNkNNczdnSG9FVkptbWpLa3pVUWVNRjRwWHBJL1pCQWpkTnFKMUQzeTlk?=
 =?utf-8?B?NEN3dm9iYVEwN3JjWVlaemVxampVRnh1WjlQaVVIenpBRmplQjR6RTlMYWhB?=
 =?utf-8?B?UXZUeEtXZ1h0Q1RlVlJhUDBlei9FNHFNZ011NVdnTkNYQVVqeHVMNnJuVEFz?=
 =?utf-8?B?Q0VpaWdNaTJwbVR3Y1RlMjJGMnNkdSt1OC84Q2xyMkQrZGJ4T0V5bThrb01q?=
 =?utf-8?B?a0cydVFxcmF2dXJvY1NpOWF4SWdoNnFuTDZVZWFSb2I2SVpTOG13dWtybmY3?=
 =?utf-8?B?Q1l5ekV1a0dJQXVFS2VsODUvWit5b3h2c0c5UzlwUjY5UWJQU3JaUGgxeTJO?=
 =?utf-8?B?RGtyR1libm90dnRvNUdtYncrZkdWdVRNOGcvRnpRODZhNXM5SnB3ZzBOSXhz?=
 =?utf-8?B?UW4ySXlCcmhmT3g0TzdPRzFnWVZOeUxBY0hJZ0daVXFSN1ZaVERpUkYyNXg3?=
 =?utf-8?B?bjFwemZUNlVOZTRUeWJaYUN1c2hyMGplcndtOXY2S3ZlL01DUThhU3U2cGY0?=
 =?utf-8?B?Y0ord0JaM3V2cmNCc01ja3NCSTVkV0prMGhabmJ2ZFhZTGJkTlpKVmxIalNu?=
 =?utf-8?B?SFdPa0JIdTJoU25peWpVNHE3TlovSVRidDluWVVlR2Z5c1hKa3JhelBtTHBa?=
 =?utf-8?B?OUZSbURWWHBqbWhwM240bEVjdUZ3Qm9zYVdOc01pZHNmWjRIUlVTckNkQ1p3?=
 =?utf-8?B?NHV2b0ozcUFaZHJGZkFDWGRHZmsybmJnbVEyMEk5S3pic3VESXRKcUhZSnBm?=
 =?utf-8?B?UUFlbDllY2paZUZYMkhvc21iWkFDOEMyYzRlNmtsUHpwVmdzaDhCNFJrZGsy?=
 =?utf-8?B?Z2Yxa0dqalp4TWY4N05XV0dTdFk4bkxtNjVkQ29SamVHLzJBQ3hUbkZPWEgy?=
 =?utf-8?B?R3YyUnVBUXJPUUEwZlRZM3VkWDdnZ3duMVRaVUkrUEZ4VEE4Z29YYUNOakFT?=
 =?utf-8?B?bWdWaUNFWmdXdnRSMVlYaWJNanR0K1NCQ0hZeEhQNGRQYTVYczZCbmFZdVo0?=
 =?utf-8?B?cDRzcHhZRjVQbkVTTXFEZlRWWDNkeDVTajI2d1BtRXlQOWlsamxlb0FPLzR1?=
 =?utf-8?B?QUpUdTNvbThLb2hOQkRXaEhOUmtIWEJSOFFIN0x5TFJ1TFZmYkQvTGF2TVlG?=
 =?utf-8?B?WWJQWVZySkpySkVUNjZoOU55MklnL1YrU3pCRFdaeTZtN01TUWw4S1F4eWhh?=
 =?utf-8?B?cUtQamRQUkc3RE1yQzFNZEpBRURIdWRqd1JqNVl3R2QyejNMczlIbjlMaUlH?=
 =?utf-8?B?a0N6enJTM0VOUzlqSVU4dG9SVmZnSU5XR1d0cFhGKzN3bjdyKzFrZzNsUkc5?=
 =?utf-8?B?M25wSlhnL2FYNjVKSWhVZUpLWEdKeFpjOHMwTTVBT3I1Znl2US9ZdmV1VWJU?=
 =?utf-8?Q?dVCxSerMOGK4GbKTYoW+husfrZnPbidkw1D00RU?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR13MB2499.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 476dda61-ae4a-4bd0-debd-08d8fe99bf9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 16:32:37.0357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mGaraqTy7t7Gm1xkqjbcVy/8tyT83gx9A7Zc8fbDMC0JYCCQbyiXEczN1lhsvW9xLHrzq4kKTeqdwXekhcHKYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB0994
X-Proofpoint-GUID: Fg_BlxgZzpIMZEKEoXLF4P9wYffO7DkZ
X-Proofpoint-ORIG-GUID: Fg_BlxgZzpIMZEKEoXLF4P9wYffO7DkZ
X-Sony-Outbound-GUID: Fg_BlxgZzpIMZEKEoXLF4P9wYffO7DkZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_09:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGV4ZWkgU3Rhcm92b2l0b3Yg
PGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+DQo+IA0KPiBPbiBUdWUsIEFwciAxMywgMjAy
MSBhdCA5OjE5IEFNIDxUaW0uQmlyZEBzb255LmNvbT4gd3JvdGU6DQo+ID4NCj4gPiA+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFs
ZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+DQo+ID4gPg0KPiA+ID4gT24gVHVlLCBBcHIgMTMs
IDIwMjEgYXQgOToxMCBBTSA8VGltLkJpcmRAc29ueS5jb20+IHdyb3RlOg0KPiA+ID4gPg0KPiA+
ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4g
PiA+ID4gRnJvbTogQWxleGVpIFN0YXJvdm9pdG92IDxhbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwu
Y29tPg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gT24gVHVlLCBBcHIgMTMsIDIwMjEgYXQgMjo1MiBB
TSBZYW5nIExpIDx5YW5nLmxlZUBsaW51eC5hbGliYWJhLmNvbT4gd3JvdGU6DQo+ID4gPiA+ID4g
Pg0KPiA+ID4gPiA+ID4gRml4IHRoZSBmb2xsb3dpbmcgY29jY2ljaGVjayB3YXJuaW5nczoNCj4g
PiA+ID4gPiA+IC4vdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmlu
Yy5oOjE4OTo3LTExOiBXQVJOSU5HDQo+ID4gPiA+ID4gPiBjb21wYXJpbmcgcG9pbnRlciB0byAw
LCBzdWdnZXN0ICFFDQo+ID4gPiA+ID4gPiAuL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9w
cm9ncy9wcm9maWxlci5pbmMuaDozNjE6Ny0xMTogV0FSTklORw0KPiA+ID4gPiA+ID4gY29tcGFy
aW5nIHBvaW50ZXIgdG8gMCwgc3VnZ2VzdCAhRQ0KPiA+ID4gPiA+ID4gLi90b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9icGYvcHJvZ3MvcHJvZmlsZXIuaW5jLmg6Mzg2OjE0LTE4OiBXQVJOSU5HDQo+
ID4gPiA+ID4gPiBjb21wYXJpbmcgcG9pbnRlciB0byAwLCBzdWdnZXN0ICFFDQo+ID4gPiA+ID4g
PiAuL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9maWxlci5pbmMuaDo0MDI6
MTQtMTg6IFdBUk5JTkcNCj4gPiA+ID4gPiA+IGNvbXBhcmluZyBwb2ludGVyIHRvIDAsIHN1Z2dl
c3QgIUUNCj4gPiA+ID4gPiA+IC4vdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3By
b2ZpbGVyLmluYy5oOjQzMzo3LTExOiBXQVJOSU5HDQo+ID4gPiA+ID4gPiBjb21wYXJpbmcgcG9p
bnRlciB0byAwLCBzdWdnZXN0ICFFDQo+ID4gPiA+ID4gPiAuL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2JwZi9wcm9ncy9wcm9maWxlci5pbmMuaDo1MzQ6MTQtMTg6IFdBUk5JTkcNCj4gPiA+ID4g
PiA+IGNvbXBhcmluZyBwb2ludGVyIHRvIDAsIHN1Z2dlc3QgIUUNCj4gPiA+ID4gPiA+IC4vdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oOjYyNTo3LTExOiBX
QVJOSU5HDQo+ID4gPiA+ID4gPiBjb21wYXJpbmcgcG9pbnRlciB0byAwLCBzdWdnZXN0ICFFDQo+
ID4gPiA+ID4gPiAuL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9maWxlci5p
bmMuaDo3Njc6Ny0xMTogV0FSTklORw0KPiA+ID4gPiA+ID4gY29tcGFyaW5nIHBvaW50ZXIgdG8g
MCwgc3VnZ2VzdCAhRQ0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFJlcG9ydGVkLWJ5OiBBYmFj
aSBSb2JvdCA8YWJhY2lAbGludXguYWxpYmFiYS5jb20+DQo+ID4gPiA+ID4gPiBTaWduZWQtb2Zm
LWJ5OiBZYW5nIExpIDx5YW5nLmxlZUBsaW51eC5hbGliYWJhLmNvbT4NCj4gPiA+ID4gPiA+IC0t
LQ0KPiA+ID4gPiA+ID4gIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9maWxl
ci5pbmMuaCB8IDIyICsrKysrKysrKysrLS0tLS0tLS0tLS0NCj4gPiA+ID4gPiA+ICAxIGZpbGUg
Y2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pDQo+ID4gPiA+ID4gPg0K
PiA+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9n
cy9wcm9maWxlci5pbmMuaCBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9m
aWxlci5pbmMuaA0KPiA+ID4gPiA+ID4gaW5kZXggNDg5NmZkZjguLmEzMzA2NmMgMTAwNjQ0DQo+
ID4gPiA+ID4gPiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvcHJvZmls
ZXIuaW5jLmgNCj4gPiA+ID4gPiA+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9w
cm9ncy9wcm9maWxlci5pbmMuaA0KPiA+ID4gPiA+ID4gQEAgLTE4OSw3ICsxODksNyBAQCBzdGF0
aWMgSU5MSU5FIHZvaWQgcG9wdWxhdGVfYW5jZXN0b3JzKHN0cnVjdCB0YXNrX3N0cnVjdCogdGFz
aywNCj4gPiA+ID4gPiA+ICAjZW5kaWYNCj4gPiA+ID4gPiA+ICAgICAgICAgZm9yIChudW1fYW5j
ZXN0b3JzID0gMDsgbnVtX2FuY2VzdG9ycyA8IE1BWF9BTkNFU1RPUlM7IG51bV9hbmNlc3RvcnMr
Kykgew0KPiA+ID4gPiA+ID4gICAgICAgICAgICAgICAgIHBhcmVudCA9IEJQRl9DT1JFX1JFQUQo
cGFyZW50LCByZWFsX3BhcmVudCk7DQo+ID4gPiA+ID4gPiAtICAgICAgICAgICAgICAgaWYgKHBh
cmVudCA9PSBOVUxMKQ0KPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICAgIGlmICghcGFyZW50KQ0K
PiA+ID4gPiA+DQo+ID4gPiA+ID4gU29ycnksIGJ1dCBJJ2QgbGlrZSB0aGUgcHJvZ3MgdG8gc3Rh
eSBhcyBjbG9zZSBhcyBwb3NzaWJsZSB0byB0aGUgd2F5DQo+ID4gPiA+ID4gdGhleSB3ZXJlIHdy
aXR0ZW4uDQo+ID4gPiA+IFdoeT8NCj4gPiA+ID4NCj4gPiA+ID4gPiBUaGV5IG1pZ2h0IG5vdCBh
ZGhlcmUgdG8ga2VybmVsIGNvZGluZyBzdHlsZSBpbiBzb21lIGNhc2VzLg0KPiA+ID4gPiA+IFRo
ZSBjb2RlIGNvdWxkIGJlIGdyb3NzbHkgaW5lZmZpY2llbnQgYW5kIGV2ZW4gYnVnZ3kuDQo+ID4g
PiA+IFRoZXJlIHdvdWxkIGhhdmUgdG8gYmUgYSByZWFsbHkgZ29vZCByZWFzb24gdG8gYWNjZXB0
DQo+ID4gPiA+IGdyb3NzbHkgaW5lZmZpY2llbnQgYW5kIGV2ZW4gYnVnZ3kgY29kZSBpbnRvIHRo
ZSBrZXJuZWwuDQo+ID4gPiA+DQo+ID4gPiA+IENhbiB5b3UgcGxlYXNlIGV4cGxhaW4gd2hhdCB0
aGF0IHJlYXNvbiBpcz8NCj4gPiA+DQo+ID4gPiBJdCdzIG5vdCB0aGUga2VybmVsLiBJdCdzIGEg
dGVzdCBvZiBicGYgcHJvZ3JhbS4NCj4gPiBUaGF0IGRvZXNuJ3QgYW5zd2VyIHRoZSBxdWVzdGlv
biBvZiB3aHkgeW91IGRvbid0IHdhbnQgYW55IGNoYW5nZXMuDQo+ID4NCj4gPiBXaHkgd291bGQg
d2Ugbm90IHVzZSBrZXJuZWwgY29kaW5nIHN0eWxlIGd1aWRlbGluZXMgYW5kIHF1YWxpdHkgdGhy
ZXNob2xkcyBmb3INCj4gPiB0ZXN0aW5nIGNvZGU/ICBUaGlzICppcyogZ29pbmcgaW50byB0aGUg
a2VybmVsIHNvdXJjZSB0cmVlLCB3aGVyZSBpdCB3aWxsIGJlDQo+ID4gbWFpbnRhaW5lZCBhbmQg
dXNlZCBieSBvdGhlciBkZXZlbG9wZXJzLg0KPiANCj4gYmVjYXVzZSB0aGUgd2F5IHRoZSBDIGNv
ZGUgaXMgd3JpdHRlbiBtYWtlcyBsbHZtIGdlbmVyYXRlIGEgcGFydGljdWxhcg0KPiBjb2RlIHBh
dHRlcm4gdGhhdCBtYXkgbm90IGJlIHNlZW4gb3RoZXJ3aXNlLg0KPiBMaWtlIHJlbW92aW5nICdp
ZicgYmVjYXVzZSBpdCdzIHVzZWxlc3MgdG8gaHVtYW5zLCBidXQgbm90IHRvIHRoZSBjb21waWxl
cg0KPiB3aWxsIGNoYW5nZSBnZW5lcmF0ZWQgY29kZSB3aGljaCBtYXkgb3IgbWF5IG5vdCB0cmln
Z2VyIHRoZSBiZWhhdmlvcg0KPiB0aGUgcHJvZyBpbnRlbmRzIHRvIGNvdmVyLg0KPiBJbiBwYXJ0
aWN1bGFyIHRoaXMgcHJvZmlsZXIuaW5jLmggdGVzdCBpcyBjb21waWxlZCB0aHJlZSBkaWZmZXJl
bnQgd2F5cyB0bw0KPiBtYXhpbWl6ZSBjb2RlIGdlbmVyYXRpb24gZGlmZmVyZW5jZXMuDQo+IEl0
IG1heSBub3QgYmUgY2hlY2tpbmcgZXJyb3IgcGF0aHMgaW4gc29tZSBjYXNlcyB3aGljaCBjYW4g
YmUgY29uc2lkZXJlZA0KPiBhIGJ1ZywgYnV0IHRoYXQncyB0aGUgaW50ZW5kZWQgYmVoYXZpb3Ig
b2YgdGhlIEMgY29kZSBhcyBpdCB3YXMgd3JpdHRlbi4NCj4gU28gaXQgaGFzIG5vdGhpbmcgdG8g
ZG8gd2l0aCAicXVhbGl0eSBvZiBrZXJuZWwgY29kZSIuDQo+IGFuZCBpdCBzaG91bGQgbm90IGJl
IHVzZWQgYnkgZGV2ZWxvcGVycy4gSXQncyBuZWl0aGVyIHNhbXBsZSBub3IgZXhhbXBsZS4NCg0K
T2sgLSBpbiB0aGlzIGNhc2UgaXQgbG9va3MgbGlrZSBhIHByb2dyYW0sIGJ1dCBpdCBpcyBlc3Nl
bnRpYWxseSB0ZXN0IGRhdGEgKGZvciB0ZXN0aW5nDQp0aGUgY29tcGlsZXIpLiAgVGhhbmtzIGZv
ciB0aGUgZXhwbGFuYXRpb24uDQogLS0gVGltDQoNCg==
