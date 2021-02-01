Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96CC30B1A9
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbhBAUly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:41:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60396 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhBAUlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 15:41:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111KZ114134483;
        Mon, 1 Feb 2021 20:41:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=fV6Quf9kQvwXyX/v5c4i6eaDUrT9HUWO4W2e3lgH0fY=;
 b=VEdrEyc+B42D9oCPGuJLhzvp+U7z9zT0pUwa4/VnnC+o/hREjNFgggeEcx9uRuQ7rPtx
 e89vi/WKI3rniI2Gl77Mlsyexxnm0JhYuFi4Z/VbDVYDLGehpN+Qy0Go+8vkPpIagotW
 kGH5RQYEkjwZPF47CNRdjYUj9BDuERxbBmWbM8FbWsh7JaucsdiG5dxcua89giSbL2Rw
 X49VmtpeczcFoxZIMBSTEQ0Zr8OJOVmw9YGEWAbkEWyb2NE6+D925Gpqa9HozU9DDM38
 CQDVcPexaZIklu52nROXzSb9CsD++ytiDDi/bPXc3j1jId665V04yurWTzGqCFc0kFNy mA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36cydkqf4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Feb 2021 20:41:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111Ke91E005120;
        Mon, 1 Feb 2021 20:41:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 36dh7qakbg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Feb 2021 20:40:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8g/+b9chBb4rN1DcfC/IPd0UBOgu1TgvIeaQySzjcPCDx9rx/kjgF7ar/3V1Inxch8PxZ0lIKNb6UAzXWu7ihtEIHKfsa1dERY5k+xeQ3dIZEI/kPEdEu/+/adpicLXvSxLC1N8k+EkKBDaIMyuaXwLhHySqRSNRHBG/EJzwoYXjjeR83IVFLXYYp+it6Q+a/Xzszg8T68fH6Aet89znOc6CSrxlR0AYpMmLLi2WDr4HE6YEhqIY+jH+pFs6/h8cNy8dPljRX6Oxn2+XDouJNSwPW595zjDurJRh2Uptq0jDAxecd8DTSbElQGRdiVISCsawe7aQ6Y4pPtld+uZeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fV6Quf9kQvwXyX/v5c4i6eaDUrT9HUWO4W2e3lgH0fY=;
 b=YDPPAYyRmGh+1estgiCJKOXyEE5LOigc+nXCTfmK1PJkp8H9A5lIwLUTjGm40+Xzre0zRfJjcj28dvGWO3/vgaZXKRurASVmJape0QcPpxiyEo9b7+XdDH0H3Dq1ui51XHY1YHmHyaYD7nuRYC+Ww4Kxdo8wWUPdVmNXVe/kFaoH8KxTI7UMnu3R3F66kQL+XEFoB0DhX0qd1GtRMFq0uvwzYxKV1DKkZnNQ5gEeX3QOU/mexrXZScK/6tmAvP2xsamyFZTJBJ8kcgrEnyUUahdaAlUiwraXkRIVpmix7ri8CO8wwgrPZ5UgYFfnwrlEXkZT61tiqFiwvlYOLb7i8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fV6Quf9kQvwXyX/v5c4i6eaDUrT9HUWO4W2e3lgH0fY=;
 b=V9vHGbFYgOjzPTbgzEQKWfz9Y/eDeyBDFQa3YkPlpyYK79c/DfBW93aO7yZEOxlwMdT8yZn/Ntp+VYxCzqBtty2/coPX/0QQGJmpXC5I4PdjQEnmHSC3KRUncp5vTX49NKbqnXGz8E+CKqkRdMYcLDkubxmwfVE45995IwVB00Q=
Received: from BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25)
 by SJ0PR10MB4527.namprd10.prod.outlook.com (2603:10b6:a03:2d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Mon, 1 Feb
 2021 20:40:57 +0000
Received: from BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::61fd:7c42:26e6:1e15]) by BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::61fd:7c42:26e6:1e15%3]) with mapi id 15.20.3805.027; Mon, 1 Feb 2021
 20:40:57 +0000
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     Sabyrzhan Tasbolatov <snovitoll@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzbot+1bd2b07f93745fa38425@syzkaller.appspotmail.com" 
        <syzbot+1bd2b07f93745fa38425@syzkaller.appspotmail.com>
Subject: Re: [PATCH] net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS
Thread-Topic: [PATCH] net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS
Thread-Index: AQHW+NqLnw+LuENFMkK8+445f0nrag==
Date:   Mon, 1 Feb 2021 20:40:57 +0000
Message-ID: <F5DF708C-0235-4D21-AF7A-4C4CC37462EB@oracle.com>
References: <20210201203233.1324704-1-snovitoll@gmail.com>
In-Reply-To: <20210201203233.1324704-1-snovitoll@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [69.181.241.203]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0827d93-95aa-4a14-97ff-08d8c6f1adb5
x-ms-traffictypediagnostic: SJ0PR10MB4527:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR10MB4527523F51C48D540863666293B69@SJ0PR10MB4527.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xm1TYGTPYvZB1bTOegxGe5YilEYOFLIbIgDiv9MJz0ag/kz09SANqh4rz1f3Hxf9E8eYGonrd2DjXGBdKy7B3w1csCbTmr/MeXBuY2opmAlZkoAfzawyrrTWgXIkFETWmXcXvibz85dtuabgczGGdrwbUInoJVnTHVkH8rxYvkj+kEKxqVbe1L4mH4xgYqaMIhSe6JKjlZOi3A8rLr6iGu6rCHWO2SmnE0jAWmvGC6ebsMHnt7nAnxAa60w/ZDS5lSdQuCXXLknSHa7tJZ99zXFI7uKPYbvIcZKy07LIIQVVxZLpZ2u5d6VtgTzwqiM9lvrZaTb7j7et6rUySvDxLDlMdFvv6kUrOItmGWilUTwE2hQQpAl8TjKP1W0VenA8iGjqi43VUKuocrJGmB3Q/Vyi0cgKG+M6pWmoeYQMmlBMkLiim7iXksnqfyQdk7K3kmlKnaigQJVKT+K4VaGqx2NTxoy5dlUR/T0oWoAD21ZpLb1475Fkv21LWzV7mZNcVbAtj6pDbP9gwkNCwz0I8spqTOdXG24+iP8g/fgfLPwU9pYh+cxKZXulo7264pfZUqt40+Xn1OdjX2Wh3mOXfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(39860400002)(396003)(136003)(33656002)(83380400001)(478600001)(8676002)(36756003)(53546011)(6486002)(2906002)(6512007)(26005)(6506007)(4326008)(86362001)(76116006)(316002)(44832011)(66946007)(186003)(2616005)(66476007)(71200400001)(66556008)(64756008)(5660300002)(6916009)(8936002)(54906003)(66446008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Znd0RmJ2aWhXNi9wdks4SUQ1QmJZSDM4S2U0ZEl3OGZIRk1HTDhNbnYwYm9C?=
 =?utf-8?B?RC9scmlNdHlYbDVsQ2tUaFZ4M0QwYVRCZWFYbWZrUE1DeHlNdG9hTjRpdnRz?=
 =?utf-8?B?cVprU2JxdTZYdmo5dU12Q2VSWTlnclpRWmNrZS9XczhQTllieFRCeDNYYWtL?=
 =?utf-8?B?OHdtd3loY0hqUlZ4RzNCU1lMZ3AwVkRPUHcxY0YwVUxRY1F2Wms2SWRGTklx?=
 =?utf-8?B?WU8rMnNocERBeDVPVGpld1NoclQ2V3d0dnVPYUtZRjhSeXB4Q2owdS9ZbStt?=
 =?utf-8?B?RE56UG5rOHR2c0R4RDhsR09SaDBuL082b3JRN2cvdjJZL2ZndmhkOEFON0E5?=
 =?utf-8?B?VEtubmI5UGM3OGN2c2V6cUc1OXFDRHRsRWFUL2kzL1pQWVFwUmJTSVVJZ3U5?=
 =?utf-8?B?a08wdUtuQjlwVWhRL2hnZk1WYnREeU5ISXE1Vk5Nb0tmd2hmb2FCU3FBQmpV?=
 =?utf-8?B?L0hjNlFPbGdIR0t6TjUzNm9BZC9zWXhVRTJ2OFFuRkRPTENMSC9IeEN0QkR4?=
 =?utf-8?B?MmU5N2R4U0RBOHV0YnhhWnpFaVpvcysvTGE0MWFPL0h5amp1cVllL0I3VjlC?=
 =?utf-8?B?eGJ1VmJGY045T2g4UHViQW1sMmZLR1Z4aThObHBxTk05NlQ1QitJRUFhek02?=
 =?utf-8?B?a3ZxNmNFYncxUVZLMnFWOG5GbjQ0UmNHQUZrdjAzdVhFN2lsUjZOS1hkSGdH?=
 =?utf-8?B?MXF3SzFzakRocDRuTXIveGw0SU9nYWlIK0dKeTlRc1NHR0JPNXFWZU1DTUta?=
 =?utf-8?B?SE80RGtCRlNMQnJSOHB0UUtVUG9QVjBsSEx6MnYxcVcwN052U05PRUtYZjAz?=
 =?utf-8?B?SEF0bWV0ZEVzSjY4cmlDVURYSTdKcGNDSmkzY3RRdFR4a0M2bm5iODVLRmlj?=
 =?utf-8?B?eTF6OWxmUzloQk9lbzE3SUJreGFSZ3BqTkxPdXowV2hncnlFR0hMZXdSMjdt?=
 =?utf-8?B?Tlc4RE5NRHdVRkRvcGFxT0NLeEhCbmlWVDFaS3E1ZWpFa3Q2Rm5CWkdIOUdT?=
 =?utf-8?B?UVRuY0ZqT3liVndNSnJHVW1TbE1JdEJpMjFpWEdnWFZXenRvckRkS2JlMkNL?=
 =?utf-8?B?MmorSWhtSFBRdE0wOXVpSWxlak9oUWZtRDVXR1JCQUNFcU5ITGVCaUhXZmpL?=
 =?utf-8?B?UkRmV0pveUdtZXlxK0NhL2hQaHZmZ1poY0VUZWhlaTdyZGRkUzJVV1lUWW5S?=
 =?utf-8?B?bGNYUkUzRHBMbVBHTElvVUhRbitFdHA3d2x5emV3WitmczVMcWIvTDhrUXE0?=
 =?utf-8?B?Y1FPQk1IYWNQdlBOQ0prUVl5V0RKeUhsRE1OUHRaT2htaDl2SDdkVkw4UWUv?=
 =?utf-8?B?YnlMS0xUdEJlVjVkU1NZVk9zMmhNM1Q4ekJuUHpCejg0UkhLSlJCbm96cTVs?=
 =?utf-8?B?SkJpclRmR080Z0pXbWlaTERCSFZxTEQvZ1U0SG5JVlVFUFNMRm8vTTUrUDdq?=
 =?utf-8?B?NUpLT3Z2RjFzNVB6VmVYZnkvVW5tMXVPUHJlSGtnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8726D7EF88ACB84D8BBA20EA5E6BF5E1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0827d93-95aa-4a14-97ff-08d8c6f1adb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2021 20:40:57.5163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /T+splASi+32mQDmeTOwf3EEaDySseRjSlB7zezk2M2pN7Pr4KT8tAb142Xf1OsMzHMjAT3xWfy152xSdx2jnMgV13581exLix0KUowgLHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4527
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010113
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1011
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRmViIDEsIDIwMjEsIGF0IDEyOjMyIFBNLCBTYWJ5cnpoYW4gVGFzYm9sYXRvdiA8c25vdml0
b2xsQGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBzeXpib3QgZm91bmQgV0FSTklORyBpbiByZHNf
cmRtYV9leHRyYV9zaXplIFsxXSB3aGVuIFJEU19DTVNHX1JETUFfQVJHUw0KPiBjb250cm9sIG1l
c3NhZ2UgaXMgcGFzc2VkIHdpdGggdXNlci1jb250cm9sbGVkDQo+IDB4NDAwMDEgYnl0ZXMgb2Yg
YXJncy0+bnJfbG9jYWwsIGNhdXNpbmcgb3JkZXIgPj0gTUFYX09SREVSIGNvbmRpdGlvbi4NCj4g
DQo+IFRoZSBleGFjdCB2YWx1ZSAweDQwMDAxIGNhbiBiZSBjaGVja2VkIHdpdGggVUlPX01BWElP
ViB3aGljaCBpcyAweDQwMC4NCj4gU28gZm9yIGtjYWxsb2MoKSAweDQwMCBpb3ZlY3Mgd2l0aCBz
aXplb2Yoc3RydWN0IHJkc19pb3ZlYykgPSAweDEwDQo+IGlzIHRoZSBjbG9zZXN0IGxpbWl0LCB3
aXRoIDB4MTAgbGVmdG92ZXIuDQo+IA0KPiBTYW1lIGNvbmRpdGlvbiBpcyBjdXJyZW50bHkgZG9u
ZSBpbiByZHNfY21zZ19yZG1hX2FyZ3MoKS4NCj4gDQo+IFsxXSBXQVJOSU5HOiBtbS9wYWdlX2Fs
bG9jLmM6NTAxMQ0KPiBbLi5dDQo+IENhbGwgVHJhY2U6DQo+IGFsbG9jX3BhZ2VzX2N1cnJlbnQr
MHgxOGMvMHgyYTAgbW0vbWVtcG9saWN5LmM6MjI2Nw0KPiBhbGxvY19wYWdlcyBpbmNsdWRlL2xp
bnV4L2dmcC5oOjU0NyBbaW5saW5lXQ0KPiBrbWFsbG9jX29yZGVyKzB4MmUvMHhiMCBtbS9zbGFi
X2NvbW1vbi5jOjgzNw0KPiBrbWFsbG9jX29yZGVyX3RyYWNlKzB4MTQvMHgxMjAgbW0vc2xhYl9j
b21tb24uYzo4NTMNCj4ga21hbGxvY19hcnJheSBpbmNsdWRlL2xpbnV4L3NsYWIuaDo1OTIgW2lu
bGluZV0NCj4ga2NhbGxvYyBpbmNsdWRlL2xpbnV4L3NsYWIuaDo2MjEgW2lubGluZV0NCj4gcmRz
X3JkbWFfZXh0cmFfc2l6ZSsweGIyLzB4M2IwIG5ldC9yZHMvcmRtYS5jOjU2OA0KPiByZHNfcm1f
c2l6ZSBuZXQvcmRzL3NlbmQuYzo5MjggW2lubGluZV0NCj4gDQo+IFJlcG9ydGVkLWJ5OiBzeXpi
b3QrMWJkMmIwN2Y5Mzc0NWZhMzg0MjVAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNvbQ0KPiBTaWdu
ZWQtb2ZmLWJ5OiBTYWJ5cnpoYW4gVGFzYm9sYXRvdiA8c25vdml0b2xsQGdtYWlsLmNvbT4NCj4g
4oCUDQpMb29rcyBmaW5lIGJ5IG1lLg0KQWNrZWQtYnk6IFNhbnRvc2ggU2hpbGlta2FyIDxzYW50
b3NoLnNoaWxpbWthckBvcmFjbGUuY29tPg0KDQo=
