Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EC439EF40
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 09:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFHHN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 03:13:28 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:13122 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229507AbhFHHN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 03:13:27 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1587AUBH006685;
        Tue, 8 Jun 2021 07:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8Rf3OkpQ/y55B7PqlOFiKg7r39sNmWkpDMgsgQ2/TVU=;
 b=swH6Piq9HOsU7zxVOtlaA31X9C6oW9iHrDKFog38TtDvdsHsbiUgn63FdKAJJzwiXp8G
 XR3HaFlIZ4Ed14/2lRxlPwijPuJdaPsT4nS/iYrpMnz5VVuJ3ZYKPMO6DAITUO1qtg32
 88f4ox779g3ydXdrrEkYKsqe5ZDWPrwij+1mXC5KbYoKpezXk+JYFHBZvmGJcBsDQ1Fe
 1Cfv/TyYE0qjZFLHM53rtMpA2iDyqqpM1jJ57xz7ruAmhh4nLM/VfhK56AqYKRjC776g
 T9n6+asbg+3cEwL4qKL3Wy9jHM0dg7Al6bcoXCMYvQ5I69wj+JL+wArhbeoVIEIAxg2B iA== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 391fyr0d5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 07:11:31 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 1587BUft103942;
        Tue, 8 Jun 2021 07:11:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3020.oracle.com with ESMTP id 390k1qr3r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 07:11:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3rU854l7L9t8EwMnqK5uCdHh8e84o8XmjUY8H6sUdZxHC5Z31kho/RirRh2uwLCqLaA7586IB5rUwD91fi4Gzecq/Zn5b9xhAACjfK8OvNFnEtVXwb46VafOFIhI94aBXArSZzYgtgxx3ImjRs+cca3iOj+0d42MIQu4s0XaPn9tmlEKTMp6wRNarnKTSeJ4JdKMMRRqP8wGz2shVuCPcLJUsEmR5f3yIGDjpkaIxmfya01MpEPKGJOfzQucrdt+6Mdp388M/EoKC/GGiQZg9A+GzMI/ac7a1NXkVkz4BR2QFMQcIGWdi+xEWO3590ijnsTyun0AVP4pLzH0emsIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Rf3OkpQ/y55B7PqlOFiKg7r39sNmWkpDMgsgQ2/TVU=;
 b=eDBatVciDo6EO4OR1tORSA9S0mo653CuO5oePatJr/hG/ySyKdEv56bfsj0XxRKuvO4MOzN57QlRwokPZ+KDTl6yBNsKOaHexOUXd282xm8vN7vtZN9818hptFnEAL2wcUdg9ruo9yZ8uaPogQoVGLwSoYZ2/PHxm8apPb/tYXi7XF7qvADODtHaTkYbWHehqRjxePF1K7eAV091XUDPkhbocbupYiZwlfHENAhb2+wwGC69TWaKp7m7FlPfpXJLFjOBKUQP4Lydmna1hSEVtx13mbhrq/RWXVst3F31dSnfLt2uvwx0JNW9Lp/d/+xQTJ/icYEkSlacXxiWHMQ/BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Rf3OkpQ/y55B7PqlOFiKg7r39sNmWkpDMgsgQ2/TVU=;
 b=MwmU8CIdDJbwkyBdgaHXH0ROpWQcKMrrvQ01QpfgTkTMWc5LLdU24Wiw9C5wn5fsWhQaqsgHxoayyX5aCl1wo/n/0JedjTaWSpjRxz5KjvdgK1SkXgXhkOP4p1dGw5EeiXPckjGIIytTNC/r9EjqYuid1+HMYGcOk5rTZFLMiPc=
Received: from CY4PR10MB1989.namprd10.prod.outlook.com (2603:10b6:903:11a::12)
 by CY4PR10MB1719.namprd10.prod.outlook.com (2603:10b6:910:f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Tue, 8 Jun
 2021 07:11:27 +0000
Received: from CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::2cda:5611:238a:17a3]) by CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::2cda:5611:238a:17a3%8]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 07:11:27 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
CC:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com" 
        <syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com>
Subject: Re: [PATCH] net: rds: fix memory leak in rds_recvmsg
Thread-Topic: [PATCH] net: rds: fix memory leak in rds_recvmsg
Thread-Index: AQHXW9UfD2JTNFMMGUKMemxGsyy7VKsJs1MA
Date:   Tue, 8 Jun 2021 07:11:27 +0000
Message-ID: <CF68E17D-CC8A-4B30-9B67-4A0B0047FCE1@oracle.com>
References: <20210607194102.2883-1-paskripkin@gmail.com>
In-Reply-To: <20210607194102.2883-1-paskripkin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.100.0.2.22)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [51.175.204.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 717fc26f-aa13-477a-5457-08d92a4ca1f3
x-ms-traffictypediagnostic: CY4PR10MB1719:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR10MB1719AEAC74072C6D1FC8E2A1FD379@CY4PR10MB1719.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A2s6oXWlKFVR5P4liQuBS0xo/ZK5rqb0EjD2zlZGOyPB/knBbIOHE3obLhz+ghA7lX3junMCohylRvQpiofHU8zcOVvG7+oo42iN9JaUgHrK8WqE3rvuIg0SQCZgLNvqtQq2xODs6h60ZnHITOFMIURXJfXskjAlYZIiNTcItLexeQmnhB9u1+xX+9btwpLFAvzetRdlFzm8kVLJyHUaLUS3kIdUoDkOnv+kyGccCNGVVlMD34T5rP+2HPNO9v6/7cTp+6s0+xogIMIfsmrlFx34mqZqwh8dF/HZrcqgcUGD/XRXq7Vlofi2ofFn5a0Q9dYVCNRsOV04g+u/yq+iQdnqdyzvTP4aQw1UscjNnus0tjW+ENnkc1g1t1yeb1dABzklCGHwPO7Q2kEiVzscMdIjIpzyNHsg+yQH5QmYIE6aEtlsgP3R11Ml/WgHajJd211Am5+Zpduo9KHi8dsCmf1uk4IUd0usajBfHklMTPaNZg3LdzNUqHMIssaLzDjdh1lQtsKkv8cC0S4UVy9ej+IXQGqPaebDuRhRSSnRLfihyBE99Hhxlc0YTMyWGALivrEFD2sPoI3C/JvUh7Ikt9JKH9GGKrJ7M6FbC/biG/CVL1sqLulmHC2FZY12mp+9pcuWTiOSCz6+vzyn3E8fwTe0FoeLztkKHQbjsCM1xgA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1989.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(39860400002)(376002)(346002)(6512007)(8676002)(64756008)(66556008)(26005)(66574015)(66446008)(6506007)(122000001)(53546011)(6486002)(186003)(54906003)(5660300002)(36756003)(316002)(4326008)(38100700002)(6916009)(2616005)(44832011)(478600001)(83380400001)(8936002)(71200400001)(76116006)(66476007)(91956017)(86362001)(2906002)(33656002)(66946007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVZIWEdoTTQ5OVZ1OWlNQUF1ejJGdTh1TlBiK0NhL0dyd3hZRnlSWVpEcmo3?=
 =?utf-8?B?aDdGUlBlckp6ZC9lRXdpLzRPTzZUTC9jMGtra1M3bGcyQWJNT0M1YWVScGZO?=
 =?utf-8?B?YkRxbHZtWVlFT09JaFl0WkptNHlkek44MTM0QjZSWnhZTk14UmZBSnNDSWR0?=
 =?utf-8?B?NVFtVjBRd0oxUjljK0xHZ3llVWczdkFvV2VERm9PdW4vcjdUVzBESVJkVU1y?=
 =?utf-8?B?S3lLVWNLUVFpdmZ3d1FoV0ZGc01uNXFEdXFza2ZHdXhXNmI5QWNkWDBvdUM4?=
 =?utf-8?B?bkRVd29HV1dITDdkWFMxb2JXWi9rRHg4ZWRWakdFOFNSV3hsOGlwbFBaSnNF?=
 =?utf-8?B?NjVrL0tyRVJpUnBCNFp0d3FPbzFqV1BxaDd4VDdDYlljUFFSNjNCL2FadjF5?=
 =?utf-8?B?SDlZSHR1b3FpcklRek1vVm8zblJCd3RMRkhUMVFLdjRpTXBTRkhweEdZUHU4?=
 =?utf-8?B?cUFCcmpNREMvZllrUXBhNmRiY3JyZG5ZcjFxZk9UTHNmSzR2TDhZYUdrbVpa?=
 =?utf-8?B?NnNJVkhvNmpyLy9iQzI1bWs2WHVpK09sbStOWTE2Y0RLeUlXdjFVeFJPWisy?=
 =?utf-8?B?S2xkWjJPRFM2TlJZbTZhUVpJTml5WFFQUG5Nemd3ZVk1ZkRnRjVMYmZPbGJY?=
 =?utf-8?B?MFZEZHJzTE45aG5qeGtlMnVaT1pucnUyWGlmYWJEVXoweURlanFEb0dBWStK?=
 =?utf-8?B?TVVjTjhPMGVWNU9HUHovblRmOGxVbTVrTklJT1lMV2hGVXdoekltOWI0Q2c2?=
 =?utf-8?B?d0ZINWg0SlhycWRGS0pYM0h6UldWbldNUTlmb2JsazRTMjZBV1BXR3Y3WWtY?=
 =?utf-8?B?TWhyRGNtU01aVzRKVWdWeURhQU5hd055bW9pVzkwYmNlSHFtVkFFNUMzN1R0?=
 =?utf-8?B?L1FMbXVNeWZqK2p0VHdlZW9pemYrbDhUWEZYQlNyckJkQ09yczNuSUhoemsv?=
 =?utf-8?B?bDUxcms3M3BDZ04rMnhpM1dCc2V5Y0FHd3EwUjlQejVqbHR5R2V5MjNycHZV?=
 =?utf-8?B?M3NnYms3WnkzeW84aVovOFBLWWQrL1JMLzBwY3NRaWQzUGVmSUVNNDZzdXpT?=
 =?utf-8?B?a0ZRMDBhLzJQTHZ0K25lck9EQXUvWVhycnRJSnpnMDQ4UUo2U0U0Wll6R0t1?=
 =?utf-8?B?N2MvczVLNXBOaVEwNlhEUXVQNWQ3RzVuYzZHaUtOc3V1Ti9DQU1jUDNoUkN5?=
 =?utf-8?B?ZzZaLzNFOEtpR0JNWmZ3WDJPcStOOVBLRXoyU0tzMlk1bk50MmVPTHNiMVoy?=
 =?utf-8?B?WjgxbFppTGFBTkwrajQ5eDhzaVVuVzExVEpmQkVXdXcraVpCbXA0M0t6eUFF?=
 =?utf-8?B?a3F6RFFBR2J5OEhJcDFlaFg4OWxtdEVIZVQwWTd0QVJNMi9makMyd2FLeW1L?=
 =?utf-8?B?TWptU1hpcWliWkxkd0RxaS9MVVMwWGpsbVhLZlpCZE52QmlNSUE0Z25hT1E3?=
 =?utf-8?B?ZkxtUUtrL2x2eGU0b28zdElOS2M1T2c5SEd0cEJqQUlzU1NFSGgzN1dVZE9V?=
 =?utf-8?B?ZWlabHZ2YnVZNHRtZEdmczB3aVBnRzE2Y1lmT21iU0JHTHBEYVczYnphQksr?=
 =?utf-8?B?VnhzdDhrRHhRcTI3K3NhajMxdGxFd2lvWXZuK3VxcU84dzA4Z0NNdm8vVkN5?=
 =?utf-8?B?VFNTTHN3WWUzemt4Mi9uSFVnQ0JNenNRYXA3M0pQeHFyOEpWblFUSGh5Uzds?=
 =?utf-8?B?RnJ2TFlKdk01SWRTaUlQbjQ4MERmVWVvcFNQWnRvOU9xSGlRcFJqcU12aHBi?=
 =?utf-8?B?aS8rdDR4TlpJb1RBRktLMnIxdHZRTGtZeEpoVXRnWElJU2M5cXBIWU5samt5?=
 =?utf-8?B?bXZuUVpSWkxRemR4ZGh4dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC94418B88B132429A0DA7E52DD9BD54@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1989.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 717fc26f-aa13-477a-5457-08d92a4ca1f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 07:11:27.1136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kNTKeJ9gPFRtzBy5H2+zPCpi70XknYN5eFqhXXejKP8XR1Lr2xGJajMLKIFJEjG01aw3bqigjWw5ugZLVT8S0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1719
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080049
X-Proofpoint-ORIG-GUID: o3oWZ-d47dqD7WJY-GfGLj9P-ZoJKdiR
X-Proofpoint-GUID: o3oWZ-d47dqD7WJY-GfGLj9P-ZoJKdiR
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gNyBKdW4gMjAyMSwgYXQgMjE6NDEsIFBhdmVsIFNrcmlwa2luIDxwYXNrcmlwa2lu
QGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBTeXpib3QgcmVwb3J0ZWQgbWVtb3J5IGxlYWsgaW4g
cmRzLiBUaGUgcHJvYmxlbQ0KPiB3YXMgaW4gdW5wdXR0ZWQgcmVmY291bnQgaW4gY2FzZSBvZiBl
cnJvci4NCj4gDQo+IGludCByZHNfcmVjdm1zZyhzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBzdHJ1Y3Qg
bXNnaGRyICptc2csIHNpemVfdCBzaXplLA0KPiAJCWludCBtc2dfZmxhZ3MpDQo+IHsNCj4gLi4u
DQo+IA0KPiAJaWYgKCFyZHNfbmV4dF9pbmNvbWluZyhycywgJmluYykpIHsNCj4gCQkuLi4NCj4g
CX0NCj4gDQo+IEFmdGVyIHRoaXMgImlmIiBpbmMgcmVmY291bnQgaW5jcmVtZW50ZWQgYW5kDQo+
IA0KPiAJaWYgKHJkc19jbXNnX3JlY3YoaW5jLCBtc2csIHJzKSkgew0KPiAJCXJldCA9IC1FRkFV
TFQ7DQo+IAkJZ290byBvdXQ7DQo+IAl9DQo+IC4uLg0KPiBvdXQ6DQo+IAlyZXR1cm4gcmV0Ow0K
PiB9DQo+IA0KPiBpbiBjYXNlIG9mIHJkc19jbXNnX3JlY3YoKSBmYWlsIHRoZSByZWZjb3VudCB3
b24ndCBiZQ0KPiBkZWNyZW1lbnRlZC4gQW5kIGl0J3MgZWFzeSB0byBzZWUgZnJvbSBmdHJhY2Ug
bG9nLCB0aGF0DQo+IHJkc19pbmNfYWRkcmVmKCkgZG9uJ3QgaGF2ZSByZHNfaW5jX3B1dCgpIHBh
aXIgaW4NCj4gcmRzX3JlY3Ztc2coKSBhZnRlciByZHNfY21zZ19yZWN2KCkNCj4gDQo+IDEpICAg
ICAgICAgICAgICAgfCAgcmRzX3JlY3Ztc2coKSB7DQo+IDEpICAgMy43MjEgdXMgICAgfCAgICBy
ZHNfaW5jX2FkZHJlZigpOw0KPiAxKSAgIDMuODUzIHVzICAgIHwgICAgcmRzX21lc3NhZ2VfaW5j
X2NvcHlfdG9fdXNlcigpOw0KPiAxKSArIDEwLjM5NSB1cyAgIHwgICAgcmRzX2Ntc2dfcmVjdigp
Ow0KPiAxKSArIDM0LjI2MCB1cyAgIHwgIH0NCj4gDQo+IEZpeGVzOiBiZGJlNmZiYzZhMmYgKCJS
RFM6IHJlY3YuYyIpDQo+IFJlcG9ydGVkLWFuZC10ZXN0ZWQtYnk6IHN5emJvdCs1MTM0Y2RmMDIx
YzRlZDVhYWE1ZkBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tDQo+IFNpZ25lZC1vZmYtYnk6IFBh
dmVsIFNrcmlwa2luIDxwYXNrcmlwa2luQGdtYWlsLmNvbT4NCg0KVGhhbmsgZm9yIHlvdXIgY29t
bWl0IGFuZCBhbmFseXNlcy4gT25lIHNtYWxsIG5pdCBiZWxvdy4NCg0KPiAtLS0NCj4gbmV0L3Jk
cy9yZWN2LmMgfCAzICsrLQ0KPiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L3Jkcy9yZWN2LmMgYi9uZXQvcmRzL3Jl
Y3YuYw0KPiBpbmRleCA0ZGIxMDlmYjZlYzIuLjNmYTE2YzMzOWJmZSAxMDA2NDQNCj4gLS0tIGEv
bmV0L3Jkcy9yZWN2LmMNCj4gKysrIGIvbmV0L3Jkcy9yZWN2LmMNCj4gQEAgLTcxNCw3ICs3MTQs
NyBAQCBpbnQgcmRzX3JlY3Ztc2coc3RydWN0IHNvY2tldCAqc29jaywgc3RydWN0IG1zZ2hkciAq
bXNnLCBzaXplX3Qgc2l6ZSwNCj4gDQo+IAkJaWYgKHJkc19jbXNnX3JlY3YoaW5jLCBtc2csIHJz
KSkgew0KPiAJCQlyZXQgPSAtRUZBVUxUOw0KPiAtCQkJZ290byBvdXQ7DQo+ICsJCQlnb3RvIG91
dF9wdXQ7DQoNCldvdWxkIGEgc2ltcGxlICJicmVhazsiIGRvIGl0IGhlcmUgYW5kIG5vIG5lZWQg
Zm9yIHRoZSBuZXh0IGh1bms/DQoNCg0KVGh4cywgSMOla29uDQoNCj4gCQl9DQo+IAkJcmRzX3Jl
Y3Ztc2dfemNvb2tpZShycywgbXNnKTsNCj4gDQo+IEBAIC03NDAsNiArNzQwLDcgQEAgaW50IHJk
c19yZWN2bXNnKHN0cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdCBtc2doZHIgKm1zZywgc2l6ZV90
IHNpemUsDQo+IAkJYnJlYWs7DQo+IAl9DQo+IA0KPiArb3V0X3B1dDoNCj4gCWlmIChpbmMpDQo+
IAkJcmRzX2luY19wdXQoaW5jKTsNCj4gDQo+IC0tIA0KPiAyLjMxLjENCj4gDQoNCg==
