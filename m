Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEB845E979
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 09:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353317AbhKZIkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 03:40:09 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:31072 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359813AbhKZIiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 03:38:08 -0500
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AQ3dTHM017869;
        Fri, 26 Nov 2021 00:34:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=d7G6hNo3T4DPOVtdN+vIHzMFnq+vhzvnqeyxZ97O0gM=;
 b=f2ySXK+yoyjEJw8sSpz1kZvhLdd+FlvdnVE9FKwZtJNiMMxS3xo6/HMcT6eKwqiLFl+x
 RzvcDYNeKKTnXWBxZ3MV787Yimgd2pG7YrY16vTvoGLWVbaSzJohstYSn5DcFzXp+NHG
 x92dlTbDtSYEH5HbAn1jrD32kXZJvYO+6c2dcSSicwzb2Vul2WjIdZc3dnTR+llGbWCA
 xa+RKV9AXzfwlbXl5BMXB3OnNJj7WKPF8aSiNrouY5pVj82DKEJYywSrTPianIlfET5i
 PFH+R/zdzA2/eZUuntkn7gc91p6eKaJ4GkxwPSe2XlzeXNeVae1UtoihRFwnujbDP8HL eg== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3cjqv80d2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 00:34:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=miQau6wYcHdy3YRisI0in8/hGLR3+A/ZKKYcZ6eQwvCkQzopkXPQGtbVdhqQhPqymkG4Ujn+3FZtFQ5MbmgUrm3AJ1M3fHN7Evk4AFQ/tKcRAPQQtlq4y5e+p9xLv/OPzhx4nJH5YPxGxZt6iMtg3T7va4D5+K1rsMTLuFWUjLKZbbVUdyZwxOmI5fTbojxhLgYqgdpfBYIxDnMnJPsUlR9a8+I6/Lco+w4+vk4sEdwQLNzeJPMgsT86JM9yZBKLNmtArpQtLIG91u7EnEoeioUyHorlmEbOxf8RWldJXKPAT+ZNYYs65Cj8e0J4dogS08J9E32WaV1VUrTVPcuCdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7G6hNo3T4DPOVtdN+vIHzMFnq+vhzvnqeyxZ97O0gM=;
 b=fMf16vNCr4gLgLcMBgIYVaw/Ke2P1jzQtzYhhKJ9f2GoBoTKu+ut3Yv8ooJGzQgDjmuYxXxjpsu55Az7UZUd6XQ3bY/ZUbBhB2Y4efnjeQIycSzwf+3o0+/fhOJxCVvhXvr3ZrG68UVX1doCYbwtTazO3Xv6yEJNtJ5iURhRBeuUxNcK4u6rPhOzCpWl2u+VZX7Xda0ad2CwChTIOgxwHl9bfvMy+I+NcRWC5nCUQnvgk8c4tBXQspI2r0AgkJCStz4nqarfaEi13ntX7xa8nf7Vut9ixlKJTexw5eG9OHzPZc0JpVz7weF/8L8CzM6bm55QrT4OBE+9iRZq4rt3vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by CH2PR02MB6200.namprd02.prod.outlook.com (2603:10b6:610:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Fri, 26 Nov
 2021 08:34:03 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::c549:4f6b:774b:d63b]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::c549:4f6b:774b:d63b%4]) with mapi id 15.20.4713.027; Fri, 26 Nov 2021
 08:34:02 +0000
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     David Howells <dhowells@redhat.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
Thread-Topic: [PATCH 1/2] rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
Thread-Index: AQHX4UDY1O7JuQXbQ0m2zNbO9YIezqwVKJCAgABNzwCAAAfYgA==
Date:   Fri, 26 Nov 2021 08:34:02 +0000
Message-ID: <C11C128D-905C-4406-B144-F1F4ED70647C@nutanix.com>
References: <20211125192727.74360e85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <163776465314.1844202.9057900281265187616.stgit@warthog.procyon.org.uk>
 <2790423.1637913956@warthog.procyon.org.uk>
In-Reply-To: <2790423.1637913956@warthog.procyon.org.uk>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d99d910-759c-4525-665b-08d9b0b7806e
x-ms-traffictypediagnostic: CH2PR02MB6200:
x-microsoft-antispam-prvs: <CH2PR02MB62008F9249E66A7CD57ED23680639@CH2PR02MB6200.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kwLk7smjvtswEtx6K7agSGAgcDSDj/xQHbBnFA8P2E2a5Yoj3rVMyC60vwExQJdBgNzkX1yHMpOPdwEbVlDyCG3VmZDdg3NW1RxHc33EmO0sD1QPlyoIeTj1sbfoEX8sM9SbI8Q/MdX+emw+K1Pd0HF9ME0a1pi4hRiwXG+a3L3gnKGxc93cjEd8RyBLqNx6NkOYhDaSqkHCIbBZwR642L8b7FvNu4DKz3ixgsFi0Tj3C9RgrQGa4z+Qa8+9E9uz0kC1hxFjfrV362KELNWBCjmEXSi/o/xadbYM9fphPA7a+g2VxhxoNitHiIq5wVXiEovXjWGQqUZTn1ZrFP5gjW86RrtVcX91tccVzJN32TErps/neLsT7G0NeuLLJBTx4heutRMbeSqpeX1aVHE7xieOq4i7zPXT8UP0m60May0+ZAQdmSIxvfG30FmEUDhm93RjpdmD8pb3W9YM1MPEGsj2s5Lj0DDaY2bu35fANhtW59+mhgzNDOggkbJbmKxoqOU/QAuRZln8spmeKl0Atlao0LQCCT5fk9+FBnFlnA7BOXnvTDbvxW01zkI68dREh7T8c+Lz0mlEztAzh5nn51FxdKp6qmDbs0GfOMemuZ0md8/phLIaEw38dMjmJ//04a9Vq8uqs/3EZnpgRjJ5eByEgimV4dWxqG7pTOyb3YizXtilqnDH0hXaRnosPrb4PaUz7wQUvryLIUJcsxbnVO9OGQbWDnhGtchLgeL9iEk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(2906002)(6512007)(8676002)(38070700005)(66946007)(66476007)(8936002)(64756008)(71200400001)(86362001)(36756003)(4326008)(2616005)(91956017)(76116006)(33656002)(26005)(186003)(44832011)(53546011)(66446008)(54906003)(38100700002)(5660300002)(122000001)(6506007)(508600001)(316002)(4744005)(66556008)(6916009)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzdYOFJmcVVYN1RvZU1mMklpNk1mY2F4VnR4ZU5WS29Fd0xFQ21MRUpLOUMr?=
 =?utf-8?B?L2dQOXIrTC9hTitUbFM2WWhnVTlVVy8vdkN2S0VnV0puWUVMQmxjSVZtY0NQ?=
 =?utf-8?B?S2FuZkdFOUVHV3NydlY1TnMrT2huNWt3V0J6MVhVOERtSlVHbFRtWWQ5WXM4?=
 =?utf-8?B?RGRaQVh4SjlmQ28veGlZOW9Ubk8xZmlDU0p4dXhBUkNsbS9yT2E2akk1TjAw?=
 =?utf-8?B?alprQndUQ21kYnB2YjRhWENmS0dmR2hmdlVFY28vbmVERTJaVERmMGU2bG05?=
 =?utf-8?B?ZnZXMHloT3dCREttb056NHNuUFFRSWduVWQ2Z3FmeHRZSXZxZFZucGhWbHpp?=
 =?utf-8?B?ak9UUTBwSkd0b2VNUkJucGdpTTVSRnFEbWR4Q0ZHOWowZFpIcEZjWkZHbG9N?=
 =?utf-8?B?YkZsbTUxa21KeE5iWXJvNUNTV1NmUm9QWG5BbU9OVCtHbFVDYXZ0ekl3N2hH?=
 =?utf-8?B?cWhWVnhTcGlZS0xCT013cUlkNkpJc0R3UTRzMDJCRnVLcElZNlk3ZWhHNzBQ?=
 =?utf-8?B?eWY1OEpPNjU2eENyQjdlVUhGWVVGUWd0ZDhZUnU2NkltNmJRREcwd1R4RUVr?=
 =?utf-8?B?RjNpTnErWmh4dmdLNnpvV05JbWtaZS9WRTZ6ZzFCTkxKem5kNzF3MUhvRFcr?=
 =?utf-8?B?WVZocUV1VzRERWtlZjVNdHJRMnkzSGQ4Y1E2K0JZZngwdkMvOXgvMStzcUdQ?=
 =?utf-8?B?V3IrbTYzdjNOV3hJTHc5UnF1c0VkdE1rQUtVd2taUWdYc3hQWm1xS2MyTWxC?=
 =?utf-8?B?NDYwK2dXK0JLaWFGaEI1STYyWXpycDZDVHpZeTRTaVpDOCtsYVNLbFBWM0lO?=
 =?utf-8?B?cVZMWUJVYXZjWkpiWS9ldFhJcmRWeG9GcS9wQjY0WFF4cmthREtaVnNvN0pI?=
 =?utf-8?B?K2NvWGgySU9QUHo2NGFiK3doemJURXhaRE1CWXJmVTFxOCsxcHRTa0plRERl?=
 =?utf-8?B?QUdhZlJNcGhtb214QWk0MjM1N0dTblBKSjVKMytOcUgzKzBrQXdGZG5rNVVR?=
 =?utf-8?B?OWRBVVlPMnRLc09tU1VqRXVTYi8wNnhQektsbjhnUzVpSzlsanM1eFNzT2lF?=
 =?utf-8?B?Rm0va1l4Si9YZ2JscmUzTkIrUVoxTnMwcVNhK1dSMlYxNXVybE40dVBJRnFZ?=
 =?utf-8?B?WWZLTFIwNkdlRHlMZDdIQXorSGRqTHRZb3lFSk84YmhtVkxLVTUvOXlIT2Ji?=
 =?utf-8?B?NExiRW1kb25pWUpCS0VsN1ZNRmo3Ti92UXgvQUtMQUR6cWtvS0s2bWVoemVr?=
 =?utf-8?B?cUtzWGVPUG5Od0crcENsWGlVeGh0ZlUzbDZOVDRJaU55eGRRREt5N0E0dXBt?=
 =?utf-8?B?aml3a29qdUc3M2owV2ZDamh0emxxTTVidVBiT2YwZ2VrVC93YnBKMThCRVZp?=
 =?utf-8?B?a3BlMWRjOHRsdENFSm9qNmJhRDlZeTNyZlEvZ1pXemsreU5TR2kvZGVSWmFW?=
 =?utf-8?B?YlJSZTdoWkxLNWNSVWw0eW11eHkrYW1ReGw1N1hvUURhMmFKQkk4ZHBIV3NQ?=
 =?utf-8?B?anpDdzVHRmVxcGVqMlo5ZHF2a283NnZob1pta01GV3A0d3dScEw1RlU3YVJo?=
 =?utf-8?B?ZUZjM0oyTEtKVHJCTWhUNFFmOGdNUEVIQW9zc25WdXJxalBBYmdvek8vRThC?=
 =?utf-8?B?N2NGeEcvc2hXYm1IbkZVbXZBV2FlRFQvMUxudXFVcHBURWJUREtDNjhDWU1l?=
 =?utf-8?B?ZFp2WjNScEhYRTlpVkRkU0d0K0VSOUMxcUpLdVlENDJxckpXOC9vaXBYdWtN?=
 =?utf-8?B?eXkrV1poNXo5QmxTOFNITytpV05CMXZFbUdwWllJdFlBWExOTEk4ZTRkN0ta?=
 =?utf-8?B?K0NIQVd3WStLSSt5YnRZdVJBU0FUR0tRVEw3VzNrK0JHZ2FielVLOTlScjBX?=
 =?utf-8?B?SGVHTytOam5NclF1Z0dsellzWnhFMDlVY3R6ZStqNFNQaldRdDlEWjAxdEJI?=
 =?utf-8?B?V0ppSFdUMzJSSzR0ZllsMXpLazFiRWM5cWl2TDdWeFU5ejhNakgwWW0xYUVo?=
 =?utf-8?B?TTVmTTQrQU9tR0ZKMkNJdlhBd3N5WXBESUx4UVlFRWVJaDZQN2dyczZXTEh6?=
 =?utf-8?B?eFMxNmRWTTNYeCtGT3Bkb091L0VnL09scTBOVFdrZTA0UWVLeEU2YWhsT1Ro?=
 =?utf-8?B?Skwza0x5UHM5c2lKM0VYNm4zNmkzU1RodXBtb3prTUh3OXc2cjJHNTZLNWtm?=
 =?utf-8?B?OWxpQmJWemw4K2c5MTRSMkcybGxBRkwwaS9WczFSVGlwUnRGVDBadXRLd1VN?=
 =?utf-8?B?dTA5em9ETTQ4anF6cU1TZG5FL2NnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDED0C5BE397414082777794B7E566C4@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d99d910-759c-4525-665b-08d9b0b7806e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 08:34:02.8693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CT5Kkh15SdA+uudAtrKq0lzZT9DuTRNlqGGmCWjsEBrJ+rbVJYHByRZmpvE9+xWHSKRLTMHRH952q+YAK48CEx09azxP/0FO9SkonTNZlx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6200
X-Proofpoint-ORIG-GUID: nDp5EX72iGn2OcxVSQ7A6sIvAkHoHW8s
X-Proofpoint-GUID: nDp5EX72iGn2OcxVSQ7A6sIvAkHoHW8s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-26_02,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTm92IDI2LCAyMDIxLCBhdCAxNzowNSwgRGF2aWQgSG93ZWxscyA8ZGhvd2VsbHNA
cmVkaGF0LmNvbT4gd3JvdGU6DQo+IA0KPiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3Jn
PiB3cm90ZToNCj4gDQo+PiBBcmUgdGhlc2Ugc3VwcG9zZWQgdG8gZ28gdG8gbmV0PyBUaGV5IGFy
ZSBhZGRyZXNzZWQgVG86IHRoZSBhdXRob3IuDQo+IA0KPiBJJ20gaG9waW5nIHRoZSBhdXRob3Ig
cmVjaGVja3MvcmV2aWV3cyB0aGVtLiAgSSBjb21tZW50ZWQgb24gaGlzIG9yaWdpbmFsDQo+IHN1
Ym1pc3Npb24gdGhhdCBJIHRob3VnaHQgdGhleSBjb3VsZCBiZSBkb25lIHNsaWdodGx5IGRpZmZl
cmVudGx5Lg0KPiANCg0KVGhhbmtzLCBJ4oCZdmUgdGVzdGVkIHRoZW0gd2l0aCBteSBlbnZpcm9u
bWVudC4gTG9va3MgZ29vZC4NCg0KRWlpY2hp
