Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D937956BB97
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 16:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238420AbiGHOOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 10:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238427AbiGHOOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 10:14:50 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9ED1C939;
        Fri,  8 Jul 2022 07:14:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3DVSqwr8oHoRw6/7Jh5lbsxBFtETJkNgJg/H4Qkhmgn0zJ3A2pf0T9yzyteDcsPujGh4E+41PjgqJrJrf/bHCa3phXFE+fGQ3iXtQ63O2144sjb2FBC3u8U2HR78q2QYsloLNzbIqasn5H/bts3qLQxuoIh8/mIt/ZChPdCmS/XAtSj6t1Meba2HM8xzM4tWep29j9VdK8D0Emv4mV5q1q4iZwkjsgWdGaXBFWvGfrT3FHKyAaDmd9VtCl35SHDch8LiRCQiis1ToDcWKATHGs3orVTVm31m9fucPDYPmNmv0zLJcm18j6/Rp/U4T/ODwF5dGMvmggony+E4jTdqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GUCZcJe8hm9Ykm6SPCBrktT/ailqLzoWTY7RxneDYgI=;
 b=nu3Rw/ThWN5ui+WdNrg8uR/27mwX8CPj6ACV5H9UUz3n5w6GF+mSkMX01mMXjwWinO7ToKcpI1UjUOPx1CDJ8/4d4Fej6Pa/yQTY2FKcFjQT3soCKcIngwBTlTyZC8Knm3Bq1BuP9EEn0pMGSPnYeAP3KdjnEGzpHQPPvu7E6m5spLxm+M7tPBBzFzkwJEbzargJKWpqY1n9yeolngaEUCq3iNbw5X/uz/PofHqrVyOtU9qoszl9+IRiL2LCYFv5UgPGGZ5Et7A2UyQiC6XoC810LqS4PAEjsQzxgti9rc7HSmozgKQ4gQ/Lrh7fjZWhoG9Y/AtW1ErQsYpa3AsJCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GUCZcJe8hm9Ykm6SPCBrktT/ailqLzoWTY7RxneDYgI=;
 b=hmyHYCRFiBYBSnoBt5Q/ype+KrhmHRrcd1hJvAcnhNhDEC6mKv58KWPm1mbjDB2CsQeDxNDLizmThnEe1vYZBfwkTG6XwFjyB1uhjLl84BaGYdhi8WkGfPYnYu6/UgOww14O+461XcczKt5+Vqd+8IwhVSyCLtFO5zEtykQzbFOE0i1WaGlbT3E9MQqUarWSlzswg1TlD9xiWnJH26jkL/ERPrhJ0SYsqWzApt9feiXbqIr4c3cTSEhAEiTbhL7ciSU26WkjGkj9gE0DEZo60zD9iEsXVg7JN3d2WU7OVrN+WXtpCT5eHSqmozdqcDSmim1x1yb2lQOHoCGcnQ6GSQ==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by CH2PR12MB3848.namprd12.prod.outlook.com (2603:10b6:610:16::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Fri, 8 Jul
 2022 14:14:44 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548%7]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 14:14:44 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH net-next 3/5] tls: rx: add sockopt for enabling optimistic
 decrypt with TLS 1.3
Thread-Topic: [PATCH net-next 3/5] tls: rx: add sockopt for enabling
 optimistic decrypt with TLS 1.3
Thread-Index: AQHYkMtJSbc4WU7gQ0K4AHtBPhA+fq10iIyA
Date:   Fri, 8 Jul 2022 14:14:44 +0000
Message-ID: <b111828e6ac34baad9f4e783127eba8344ac252d.camel@nvidia.com>
References: <20220705235926.1035407-1-kuba@kernel.org>
         <20220705235926.1035407-4-kuba@kernel.org>
In-Reply-To: <20220705235926.1035407-4-kuba@kernel.org>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b71a91f-3a1d-4920-1f6a-08da60ec34e3
x-ms-traffictypediagnostic: CH2PR12MB3848:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hh8a9i2hRK4FuoMTxrBP4W5sL5NBQZtG0RkfXQBoaSuuG6/bIT5NMOSLbzTZVhQKArAIbp2pGUMMM1Tu3ydggiW03VRL0zEA1s8Hs59ElDHeqDJTfhIOKRRftX93zGdMzT/GbftbB8wRuiZCcbcqtjDeAbfLyXNFsNKOphKX0VOubmWV0ReSwIU4DHQacPE3C9wOo9ITznJ3WXzYX5pWENP92nfPgxmgBTIw6/dOVg03GDI/D5RVd7rAbTSCf8CiLAxgWkqYv4Y6IhkcyYj8P0bxcIDt1ZZygOzrrZvYswBmxdtG2+ZfGtdIXTfDs7XAoAaBoBJPhpgGWxC+JhQdSuZbXFKlJYCRwRIq6KPty0Yrp0KJTeILDKc8iVjodis6qxNxh8FeMybIs4+uwo50/lGIGEXNwfb4MFFDmF6LJaHmt4TmuM3bTTNoEyQntOyMmzDAQNFCfmY7mYXI1Xub6gdPGXSm55nEyG6I/XHRE2G/oOpr4oRbpK9rMkX3MwIknru1hj09QTpeMW52iA0t4p4Tn1PXKYuhvONF9RuMdX3K8/Udc1kM10ASaJ8sWAWm1KcJ5TmwQqj3pO2b9A+8H4a7cOWUw8Ui/U3UTRHhF6RF9ptZIzSmicUziO7K8WOpSFcwe4TRx8ZOJkN9K20Bt0WeGQSvHAYgpDVZ1eIES9vVdFIY9EWgvQtH56BxJ39jduRCOSHcjIUB5gQkkkxD8dA1bZVkftoIUTKlQJLVCncEEHGUPRPL9NGgNK6gDBcWM8TjXb6t496LoB9+8H3J1aaH673tWZ02Wk7S7vsqZh2qu2RhIalZYl+HmJa/uqXN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(186003)(91956017)(71200400001)(110136005)(66556008)(54906003)(66446008)(64756008)(66946007)(4326008)(8676002)(76116006)(66476007)(83380400001)(6512007)(6506007)(107886003)(2616005)(36756003)(86362001)(38100700002)(316002)(478600001)(2906002)(5660300002)(8936002)(122000001)(41300700001)(6486002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b0F6VmdqUTNlSjhqYVdWQ296empzVnBCbFR5bkczcUN6K29YcFE5OWMvbEIx?=
 =?utf-8?B?cTgxT2k5eWsvZzFYVjc0S0g2RXdOUEhrUkdXOHVaZkZMU1hUbVY5SWdyV2xL?=
 =?utf-8?B?RndzZm5oR0VTTTcrdXZTMFppOVlkRDdOa0RTa2x4Z3l6MUZxelFveVdGK2JW?=
 =?utf-8?B?azdIK1p3ZFRjMy9iVm9sOGtDVHhTT24rcEtWOE0wSUpMQkw0RU94MDlFZXll?=
 =?utf-8?B?R051R01HNGtXZGVLenREZ2VLYmM5TGl6dEwzYld6VWhaN01BMzBzaHlFdEZD?=
 =?utf-8?B?NVZBSWpCejdESHhhdnVlL1Nucmc3Ymh5YmN3eTZ5c0RiZFIyRGVwMnpKcGJl?=
 =?utf-8?B?YSt1Q3l1ZW1uUml5VUtVQ0FOa2NWUGpkcUZOVEYvREFHYk5sTVFCTWVWcUF0?=
 =?utf-8?B?dWRGYW1OTmxkdzVkQzQwckRpU0N5WE5JQXpGVlVNT0E5U01lc0JHZlY3N2JP?=
 =?utf-8?B?NXlpMGFEQVdzU3ZWZ0t5QjdlMDVCbGF0Yk9zNjV1OHFlQTJKQWpGcUZ0L2s5?=
 =?utf-8?B?M0hTdklaQ09aSUhWQ1pobTdZZGRhTzhMK0UxOVJRZDJ4M2R0bVVZQzVFTERS?=
 =?utf-8?B?cnJONzRTd3YwWlcydEIwQjRKSTgvd1hVdGNRK0JoelRkeW1UZS9NK1JLVUJ1?=
 =?utf-8?B?RUxpY0JZTW1hM0lZdGI5b0FIM2pNdzZKOVZleDhrUUd1emxFUnMvSnFOUG5S?=
 =?utf-8?B?REFLS1dRK3Qxb0RleDRTQVNpZVY1ekIyb0E3eGVIcUFhb1BpSlZWekcyTEMz?=
 =?utf-8?B?SzY3Mzl3TU5rcUZ2STZLdFNDbHlTNkZlV05PV2RNL0NNOFlKWmJ5Y1dDWldS?=
 =?utf-8?B?Q3NSb3VRSTRxbmhzQzQ1cCtmQmpKVi8rc2F4U2NNdTh5MlNqZ0tjQnY5SVN5?=
 =?utf-8?B?OFNDOGk4MzVqakxXL1hEUHgrandUdTFLWW5yRmxuUWxWTitjSUpsTFFUZkt1?=
 =?utf-8?B?VFh6a2ZCWXhHeUtKWEV6ZGplQUNXdHVvaExGcHZuam9qWjVFR2xaTFUvTW9U?=
 =?utf-8?B?dTFxNWxlZW4zUzhCZUlMVy9mZ1ZJd0Zja2VCTCtYYVhRR3dPQWVMb3JTUlNw?=
 =?utf-8?B?bW1USm5nc0JXNWNiMzRRMmNzMGVQNnA2dCtubGlIeG1QMXBrVFdoZUNjekNu?=
 =?utf-8?B?SlVXWmVENW5JMGRUN0hHbTFMU2plMDlkbUhkSDRNRjA4L0QxWndmNyt0Q3hx?=
 =?utf-8?B?S2dGNGpuRXFIL2ZoMGJwcjRPRXRHRlBjeFYxQzY0bEdyaXhxNlNGNit3UmNt?=
 =?utf-8?B?NDF5Z2JxVncvNk9xZVVEWHBicThJa0lraWdtNDAyV2ZqaFgyK2J2RzEzUXN0?=
 =?utf-8?B?azRrUk1xU3RSbmtna3pVOUhlWVd2ZS9GTWFGNGhiR3hVdTlTU0JVQXNOQXlh?=
 =?utf-8?B?Ymp2aWRwcUpSQjRIaVNzMzVSZnYwaERicmI1NVpOc20rbXIwZmZBT1dqL0p3?=
 =?utf-8?B?bjBHdmx3aVUzOWdJM0hQWCtocUxpOURobnkvZWdaVFB1NDZLaHRhQ2pKZ29o?=
 =?utf-8?B?S291M3hCMzQ2ei9HRHFCN3Z5cDBQa3hWUHFhUFBuelFWZS9Ydm01Mm9uckda?=
 =?utf-8?B?QzYxdm0veU5MdUFRVmJMVzRLdHU4aFhjTkhHbEpKQXJzOVlORXozNFhLNjJN?=
 =?utf-8?B?ZktyalVsdFd3VkNKd3F1NFdCOE1OZThiZVRUblFmK1dUNllERFVkVFVpNlFM?=
 =?utf-8?B?TlJ6RnpSQ3NHMUhEQmR2Vk5RTkluMlVGeHhSanBmeVJKaWFJdnZnSVBwRHVa?=
 =?utf-8?B?SWMrK2F0dlhjR1N3TEZpNFRnQ211cUMvQ1VoczVkV1hXSnRFaHVzK3hhN1l5?=
 =?utf-8?B?dEtFbUtQdkNRRVpEY0Z4VU0rZjYyOWI3MTNjQ2NldnBLZHVwU2FPcGt1Snpx?=
 =?utf-8?B?ejV1bDdkTUljWUdHSTNRVGViL2xaS0Q5SFlCY0NHa3N1VkN4czNnc2pqV1RD?=
 =?utf-8?B?NzlnZjMvUGpNOFBlZ2VXcmt6KzE1T2tvandrcGFJeGRzTEtsMDFtZHFFMDFh?=
 =?utf-8?B?QnBHVXBBbzdwa2xGaDlTeFhodVp0bDVSVGx1SmVPRjA2Mk9DQ2UrZkdwckx1?=
 =?utf-8?B?RXBUSXFWSTRBNlgvbUpSTHNCVDFtbUYzUitaY2ZuVE9NekhHRXltMlhYTDlU?=
 =?utf-8?B?aG5lUEIvY2IvbTY5Nisra1MzR0Z0TXVmcjBJc243MGhhT0Vub1k4UzYyeXBs?=
 =?utf-8?B?RHVGLzNyUDg2NzBiSHZnaENiRVBGTVFhSVZ5czVxMWlWNXQvd2hPNjBaZGZN?=
 =?utf-8?B?NDdkYjdyM3IyYnRUMjVKeHFYZ2p3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <801E7967356D244CB73B17BE1CA617F7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b71a91f-3a1d-4920-1f6a-08da60ec34e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 14:14:44.1726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MmISiJ310SIoco1tatPFVGNRy6uRcM4R5SLfDpbbSLjy+I1M52CBSSri0f7e+Y6/55q7UZAqKAfj8HrtvbvXsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3848
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA3LTA1IGF0IDE2OjU5IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gZGlmZiAtLWdpdCBhL25ldC90bHMvdGxzX21haW4uYyBiL25ldC90bHMvdGxzX21haW4uYw0K
PiBpbmRleCAyZmZlZGU0NjNlNGEuLjFiM2VmYzk2ZGIwYiAxMDA2NDQNCj4gLS0tIGEvbmV0L3Rs
cy90bHNfbWFpbi5jDQo+ICsrKyBiL25ldC90bHMvdGxzX21haW4uYw0KPiBAQCAtNTMzLDYgKzUz
MywzNyBAQCBzdGF0aWMgaW50IGRvX3Rsc19nZXRzb2Nrb3B0X3R4X3pjKHN0cnVjdCBzb2NrICpz
aywgY2hhciBfX3VzZXIgKm9wdHZhbCwNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4gIA0KPiArc3Rh
dGljIGludCBkb190bHNfZ2V0c29ja29wdF9ub19wYWQoc3RydWN0IHNvY2sgKnNrLCBjaGFyIF9f
dXNlciAqb3B0dmFsLA0KPiArCQkJCSAgICBpbnQgX191c2VyICpvcHRsZW4pDQo+ICt7DQo+ICsJ
c3RydWN0IHRsc19jb250ZXh0ICpjdHggPSB0bHNfZ2V0X2N0eChzayk7DQo+ICsJdW5zaWduZWQg
aW50IHZhbHVlOw0KPiArCWludCBlcnIsIGxlbjsNCj4gKw0KPiArCWlmIChjdHgtPnByb3RfaW5m
by52ZXJzaW9uICE9IFRMU18xXzNfVkVSU0lPTikNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ICsN
Cj4gKwlpZiAoZ2V0X3VzZXIobGVuLCBvcHRsZW4pKQ0KPiArCQlyZXR1cm4gLUVGQVVMVDsNCj4g
KwlpZiAobGVuIDwgc2l6ZW9mKHZhbHVlKSkNCj4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+ICsNCj4g
Kwlsb2NrX3NvY2soc2spOw0KPiArCWVyciA9IC1FSU5WQUw7DQo+ICsJaWYgKGN0eC0+cnhfY29u
ZiA9PSBUTFNfU1cgfHwgY3R4LT5yeF9jb25mID09IFRMU19IVykNCj4gKwkJdmFsdWUgPSBjdHgt
PnJ4X25vX3BhZDsNCj4gKwlyZWxlYXNlX3NvY2soc2spOw0KPiArCWlmIChlcnIpDQo+ICsJCXJl
dHVybiBlcnI7DQoNCkJ1ZzogYWx3YXlzIHJldHVybnMgLUVJTlZBTCBoZXJlLCBiZWNhdXNlIGl0
J3MgYXNzaWduZWQgYSBmZXcgbGluZXMNCmFib3ZlIHVuY29uZGl0aW9uYWxseS4NCg0KPiArDQo+
ICsJaWYgKHB1dF91c2VyKHNpemVvZih2YWx1ZSksIG9wdGxlbikpDQo+ICsJCXJldHVybiAtRUZB
VUxUOw0KPiArCWlmIChjb3B5X3RvX3VzZXIob3B0dmFsLCAmdmFsdWUsIHNpemVvZih2YWx1ZSkp
KQ0KPiArCQlyZXR1cm4gLUVGQVVMVDsNCj4gKw0KPiArCXJldHVybiAwOw0KPiArfQ0KPiANCg0K
PiBkaWZmIC0tZ2l0IGEvbmV0L3Rscy90bHNfcHJvYy5jIGIvbmV0L3Rscy90bHNfcHJvYy5jDQo+
IGluZGV4IGZlZWNlYjBlNGNiNC4uMGMyMDAwMDBjYzQ1IDEwMDY0NA0KPiAtLS0gYS9uZXQvdGxz
L3Rsc19wcm9jLmMNCj4gKysrIGIvbmV0L3Rscy90bHNfcHJvYy5jDQo+IEBAIC0xOCw2ICsxOCw3
IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc25tcF9taWIgdGxzX21pYl9saXN0W10gPSB7DQo+ICAJ
U05NUF9NSUJfSVRFTSgiVGxzUnhEZXZpY2UiLCBMSU5VWF9NSUJfVExTUlhERVZJQ0UpLA0KPiAg
CVNOTVBfTUlCX0lURU0oIlRsc0RlY3J5cHRFcnJvciIsIExJTlVYX01JQl9UTFNERUNSWVBURVJS
T1IpLA0KPiAgCVNOTVBfTUlCX0lURU0oIlRsc1J4RGV2aWNlUmVzeW5jIiwgTElOVVhfTUlCX1RM
U1JYREVWSUNFUkVTWU5DKSwNCj4gKwlTTk1QX01JQl9JVEVNKCJUbHNEZWNyeXB0UmV0cnkiLCBM
SU5VWF9NSU5fVExTREVDUllQVFJFVFJZKSwNCj4gIAlTTk1QX01JQl9TRU5USU5FTA0KPiAgfTsN
Cj4gIA0KPiBkaWZmIC0tZ2l0IGEvbmV0L3Rscy90bHNfc3cuYyBiL25ldC90bHMvdGxzX3N3LmMN
Cj4gaW5kZXggMmJhYzU3Njg0NDI5Li43NTkyYjY1MTk5NTMgMTAwNjQ0DQo+IC0tLSBhL25ldC90
bHMvdGxzX3N3LmMNCj4gKysrIGIvbmV0L3Rscy90bHNfc3cuYw0KPiBAQCAtMTYwMSw2ICsxNjAx
LDcgQEAgc3RhdGljIGludCBkZWNyeXB0X3NrYl91cGRhdGUoc3RydWN0IHNvY2sgKnNrLCBzdHJ1
Y3Qgc2tfYnVmZiAqc2tiLA0KPiAgCWlmICh1bmxpa2VseShkYXJnLT56YyAmJiBwcm90LT52ZXJz
aW9uID09IFRMU18xXzNfVkVSU0lPTiAmJg0KPiAgCQkgICAgIGRhcmctPnRhaWwgIT0gVExTX1JF
Q09SRF9UWVBFX0RBVEEpKSB7DQo+ICAJCWRhcmctPnpjID0gZmFsc2U7DQo+ICsJCVRMU19JTkNf
U1RBVFMoc29ja19uZXQoc2spLCBMSU5VWF9NSU5fVExTREVDUllQVFJFVFJZKTsNCj4gIAkJcmV0
dXJuIGRlY3J5cHRfc2tiX3VwZGF0ZShzaywgc2tiLCBkZXN0LCBkYXJnKTsNCj4gIAl9DQoNCkkg
cmVjYWxsIHlvdSBwbGFubmVkIHRvIGhhdmUgdHdvIGNvdW50ZXJzOg0KDQo+IFlvdSBoYXZlIGEg
cG9pbnQgYWJvdXQgdGhlIG1vcmUgc3BlY2lmaWMgY291bnRlciwgbGV0IG1lIGFkZCBhDQo+IGNv
dW50ZXIgZm9yIE5vUGFkIGJlaW5nIHZpb2xhdGVkICh0YWlsID09IDApIGFzIHdlbGwgYXMgdGhl
IG92ZXJhbGwNCj4gImRlY3J5cHRpb24gaGFwcGVuZWQgdHdpY2UiIGNvdW50ZXIuDQoNCkRpZCB5
b3UgZGVjaWRlIHRvIHN0aWNrIHdpdGggb25lPw0K
