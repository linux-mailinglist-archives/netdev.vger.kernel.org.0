Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575306775E4
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 08:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjAWH5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 02:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjAWH5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 02:57:50 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2073.outbound.protection.outlook.com [40.107.12.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992D6B777;
        Sun, 22 Jan 2023 23:57:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTXxtZMvTnEP9T8JgPBIokcAHIPtFuoMRG7ZD144aQ0gPJ1mVxG2UJ+XX5vcGwpBKIIw5gMJPKp6yK0h3hovrrh1DvaGmuuG3dpaSEOzbWzj3fhwibzuJcdbe6WCKTx/uBR4uyYz4TxbLPFXGbeFCkZP9bLodlKCOY1+asVcFZ1z8pzmTxl24yxjWcn425EPJBdqlPZO13QHBtjRiBU7V+2DE+sHGV4Cj42XNkCLyKQqi7QYpIN4mxX2bG/ug1xLeIWDx/YuB244VrNf2v3EZi+EPnnOY0aPX7lx6T79Y9e0Xgavz52HWTKlUPpmnv7m6rvXyil2YCDjsFaJ5t0BpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ekrNsPLzuZQ5FDKC6+uBf8nVSZ+nq913ZKr8VI47Z+I=;
 b=aVCw7Vth5JmyrO3T9HTWR3djA6DzsLO8gupCfYhuhocxSfd4xQnUhJCAx/JkrydzvzE5MxxUhebP9eWjtbl0JSQDg2E2tqzrVONS34mRS/YGFSRVO4v35n1QYC+Gjjz2xTtJZvqyD7VaR+8NZx289md3V5vHn1JmbftInjL9dkX3CQE4iJTTowTNuk+/9pZkUbTaVMiIWBbRARanQgoi32BBNI0zt1vbooW94LnVLAcKtdjT/1A8wt5Uj3DKAYWeku1gzDuAXTuMN7Dc0frRGcVsvklQngyWBxyNkcNuJTFihpC6JEoQa8tzNf3d7IEjrC17LsreHcZH/r439w0FPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekrNsPLzuZQ5FDKC6+uBf8nVSZ+nq913ZKr8VI47Z+I=;
 b=X4ogYoNvWcFkh/TrQ9JiSnIz8cTlq2cxWuSDKQ4hO3jL3sQmdKfKAf2qEqvC99XVjkyE7ZW8fhb2w1EOgNehnK2DQMWoCJ5hF43pvd79CIqEOwlezLPcwRnS96e/TJnHnfJ49hNQjPhJlwmLe4YwBzAKZqq3VdrYU216s9Pi2DuK9YaByCjDMv4UJelHSkh+DcQzTHgwb2xZGUynn/V1m3QM5iczFB3OwWII160mVXUd9nXlT88C4WS9B/8mKNXLWKMPZCIVoIaiPpIzZmrUtpEwZOgbi0FpZJD8jIHh0kYQPOTIQypLHAQ7jQJ2cEzMv9gFh3wcMnKtsneRMOV7AQ==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB2303.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:13::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 07:57:46 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 07:57:46 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Quentin Monnet <quentin@isovalent.com>,
        Tonghao Zhang <tong@infragraf.org>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Hao Luo <haoluo@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <song@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Hou Tao <houtao1@huawei.com>,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>
Subject: Re: [bpf-next v2] bpf: drop deprecated bpf_jit_enable == 2
Thread-Topic: [bpf-next v2] bpf: drop deprecated bpf_jit_enable == 2
Thread-Index: AQHZILjtdiBl24vDM0uhRRtlAlrCCa6QG7gAgAFsaoCABDtogIAMZLqAgAAhWICAAES8AIAALWIAgAAB/YCAAARNAIAABCAAgAANJACACOwHgA==
Date:   Mon, 23 Jan 2023 07:57:46 +0000
Message-ID: <26e09ae3-dc7a-858d-c15c-7c2ff080d36d@csgroup.eu>
References: <20230105030614.26842-1-tong@infragraf.org>
 <ea7673e1-40ec-18be-af89-5f4fd0f71742@csgroup.eu>
 <71c83f39-f85f-d990-95b7-ab6068839e6c@iogearbox.net>
 <5836b464-290e-203f-00f2-fc6632c9f570@csgroup.eu>
 <147A796D-12C0-482F-B48A-16E67120622B@infragraf.org>
 <0b46b813-05f2-5083-9f2e-82d72970dae2@csgroup.eu>
 <0792068b-9aff-d658-5c7d-086e6d394c6c@csgroup.eu>
 <C811FC00-CE38-4227-B2E8-4CD8989D8B94@infragraf.org>
 <4ab9aafe-6436-b90d-5448-f74da22ddddb@csgroup.eu>
 <376f9737-f9a4-da68-8b7f-26020021613c@isovalent.com>
 <21b09e52-142d-92f5-4f8b-e4190f89383b@csgroup.eu>
 <43e6cd9f-ac54-46da-dba9-d535a2a77207@isovalent.com>
In-Reply-To: <43e6cd9f-ac54-46da-dba9-d535a2a77207@isovalent.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|MR1P264MB2303:EE_
x-ms-office365-filtering-correlation-id: 6efdb49a-0d61-49e4-2a95-08dafd1783a9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GEyMmlccyBp8Rhm+o+byKUL25z2b2tmqc0Bf500goj7i6M8Cwhr0id6/Y9nXC+9T9e2ZM2Md0vl4l/8KCJdCpk0q71oKwMOsawzfm39DQPfGc9mU+xoUwR+NFF6UGubnEpRq/K4KjCDc7ucbuT0KPXjUCfNo35KOKhM3KgNs+B+NpMKCX/NBx6tBMdXpJcT3Ng4LOXlTFY4aEIscsEZH+5fT/AXkJxA03cK4Zsm+B45GmrAsJ/n/BMKXlfPj/tjYBwFqVzDJsUbB7sUJ3eGaRp//D2s3XMNFR0b/RpXow1n7Ti6HMZdtD8aOfi1X4dKEJ8it9lk7Ri0/SQq1lXhWETlL4mGcQQH4Nm7pA8Dj68SywShfZKAbaS39wXZsCToWzo5eDb+RSaT3aRWjAH6YHgmxqH9DpYJAYzOJwb3RdsGR8jGhOBmaFTI9FshTzmdimLeI/DwkZjMuHzkcYoG46aUFc94r449U9mkj6CTdcr5DE44B6GX+0iBL9sH8a/7RiUaBKR7ipKAwOeHuw+Ow01nh6S+1kulEnAMN+QSMw504Qn33gxFaiGhC8YvpSkzRnwns4tSrC+1rIoBUdV2TtddUAVKBcbUGLkNRrN1LZnX4jNKgDjDvG364QtgtEa/4QzaFCBTJhZ4ebxBNDLdW74yENcaudfUkStsizS79iW4083h5vDc3mvR9dvpTeCyMhEldvKWkUcFASDXJxwS4uF245+RGvLYsZfUQdCnTggFTKG2Imwr4LHh5NCytukjiwQe2hztJ3fgevRb5zHn9qg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39850400004)(346002)(366004)(376002)(451199015)(122000001)(83380400001)(31696002)(38100700002)(38070700005)(86362001)(2906002)(44832011)(5660300002)(4744005)(41300700001)(7416002)(8936002)(4326008)(8676002)(186003)(6506007)(6512007)(26005)(2616005)(54906003)(66946007)(76116006)(66556008)(66476007)(66446008)(64756008)(316002)(110136005)(91956017)(478600001)(6486002)(71200400001)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2NTV1poeTMrUFg4R0FVK0JKaDlHYXE0UXZVQUp0WW1xSVdyUDlBcjlKTUZS?=
 =?utf-8?B?WFgwUlJlMWJ1ejh6blhQSi9IdDgwdlRMWmpaYnFQcGExbFhGcUZGeEdNbElt?=
 =?utf-8?B?WGNvMGJmK3ppVkJEaUJCRzFQVTdMNnBLcC9qMjRoZjZxeUZSVVlPcHFmdmRN?=
 =?utf-8?B?bUlaNFVnaTU5NXhxcDlOWkRHeFZ1N2FzZWt3d1NneEU1czZTdmNuWnpaRHF0?=
 =?utf-8?B?Smh1U3VCWW1wdlRqRWhJQlF0MkcrWEJ4Q3MyZW05RERpUjNBR3ZzWnQrY0lm?=
 =?utf-8?B?c1dtS0FHaDdTNm81RVpnN3RibjZ3WmVBdVF4bVpzUjgrbklqYVZ5Mm8vSVd5?=
 =?utf-8?B?eGw1Ymh0UmJPY1dyK3NwbjdkcmNPZzJuVnVzVmx4YzEwU2F6Z2FyK2cwTTFn?=
 =?utf-8?B?QUdkanpNcDFncW5RaWpPQWpteW96YTFwZDlRNTVPWklzVXRobjJoNFg4Qjdp?=
 =?utf-8?B?d21YblFkYmdESlQ1Mk5LRjlKQ1Uvc3dBajRmbm1ReDhqS1l1U3huN013bUVU?=
 =?utf-8?B?OS9VRGhobEEvZnBQdzBsV2RaajlYdHZqVno4MHpzLzFDTHVkNjZJUGI3aE5h?=
 =?utf-8?B?aW94TE9BRWlMN2l6UitTSVE1a2Iwd1QzaFpjejlhclV5QUdkWUJMd1V2OWtz?=
 =?utf-8?B?UUFhbnNiR0pvSVdvbzd4blFEWkR6cU1USmt1NHJ6RG1oUmZGQjJNMHZlSkZL?=
 =?utf-8?B?eC9tMnRLK0xwT1IySXBxSUp0dDRHNDZpM01iNVdiblgvUUdPbTNrdEhRcW1x?=
 =?utf-8?B?bE8zUUJQR0ZubE4wS2hnVjQwQ0VEVThTY2pXYm9aWk9NeHZ6NWUzRlRuZm5u?=
 =?utf-8?B?RCs0Y1BDT3IwWU82L3J3OWVXczJHblBvczFJNERWdE5LSkpPTTF5ZnNmb1Vr?=
 =?utf-8?B?cEg5T09RT2l5VEdOalo1b2pMNm44QnRUMmpnc1FFY3I0dzdrZ0k5d2JXeC91?=
 =?utf-8?B?Y01UQlpoQk5jcktZRS93S0JrYlhpUEtmNFhSNVduRVN6WnFpb1RJVHJjRStO?=
 =?utf-8?B?V1liTmZkOVpOVUtwbjlyekhLenozNVBnc3QxTnp2dGJyKzlhaDQ2UFRUSjNs?=
 =?utf-8?B?U2pZeFEzVjN0Vzl5ZFk1NkZsU0VCM3RPRGt1OGJNMTFFdVViVzZXbHk5aWJJ?=
 =?utf-8?B?RVdld01Xd3VFY1JEV3BFT1RxZUhoZ1R5L1hYRjNmOUFCb3pQZ2ZqTldRZkpX?=
 =?utf-8?B?Ym1ab2p3WFd4NTR4T2VGek9yK201S05FUGRxTVVhZGMxQjZvWGxlOXFWT0Iv?=
 =?utf-8?B?Mk1sRlBzRzFXUXBHRTNJZW9NZFdnTmppSTlVR1FXc1Erdi9LbVBZK0tLQUh3?=
 =?utf-8?B?cXRodGpNUUNabmEwQVlwMmVYaWtINExlVEZ5RGFpUVBtQllEYVNpdnhaaWhT?=
 =?utf-8?B?RG1tZHlqVkd4T1VwSE1NUkRldzNjZnJ5YWt6Nk5kZytWdWRZQkVqb2FPendw?=
 =?utf-8?B?UVgxWFFvUWlURW9ybm04dHQ1M3VQOXRRanVoMm5MM1ZrcStsd01oZEhiNDUv?=
 =?utf-8?B?djJieExnOFBRTUlKZUpWdjNJbVZpZU1MdFF6KzlkTlpBYno2Zzk1TWZ5WXJh?=
 =?utf-8?B?cVJ5b2ZRYTUzR2pQT0NqK00yeE56MUJ5RHB6elF4T2Fnd3JIa2pUaXNKSjMw?=
 =?utf-8?B?czk5eXNvUHFJdXZxU0lTQkR2TUJOSGprQnFIWlBsZVgrdjd0d3BSSnJIZzQx?=
 =?utf-8?B?ZDRDUWRqblJWaEUvYVl2VUFaMHVXWDdTYzcvbEhUeGx5N1k4UitUSFk3K21N?=
 =?utf-8?B?cEVhR2xOM0Q0UzQ3SGtLYUdocXhwdVNNTEZuL3RibTJkcnBKMDVPcVBTbVJa?=
 =?utf-8?B?dVk0S1BCakRwUmR3RUxnL2RQNUJwY1R3alpvVWZaOHcrUEhVN2UxMGNDZXBs?=
 =?utf-8?B?aVVtRlZ3YkRmL2QzaXExZ3NTdWdXR3VNdy9ZaWY2eTg4Y3pzUFo3QWFSZG9Q?=
 =?utf-8?B?UWx1RmtsUEduNWZ3RGNkTysxYWVhVjJSSmM5K08vUW5WNnZwc1VSMjJhTFg4?=
 =?utf-8?B?bk9yaWNxNUVkTnlWM1R1MDl1TnI0a1NDeTdhU0dLUkpiZHJsMjl3MnlZV2VJ?=
 =?utf-8?B?MXBVQk9yUm50WFZsTCtvK1N5MWRaM1c2OWFjZFQ5OXYzWTM1YSt4SHRGVktN?=
 =?utf-8?B?WlpIckZ1MHVlRXNZV2EwNjRmSUFsQkdpb2V6NjJBTC96TWIrcHI1cnRrNXA0?=
 =?utf-8?B?N1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D1CF5D57D46D74297A686DF500C2E95@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6efdb49a-0d61-49e4-2a95-08dafd1783a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 07:57:46.0854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CbEAltlgKkMk1DrqT4QQSxLVMX8EaG5btntFbWCx+DH55FHLy6BE0/U7O7bVCoHjRwvU6cDPj9H1vWd+LmZc/PuMg4lfpx+C1a261XfZ734=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB2303
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDE3LzAxLzIwMjMgw6AgMTY6NDIsIFF1ZW50aW4gTW9ubmV0IGEgw6ljcml0wqA6DQo+
IA0KPiBJbiB0aGUgbWVhbnRpbWUsIHlvdSBjb3VsZCBkaXNhYmxlIHRoZSB1c2Ugb2Ygc2tlbGV0
b25zIGluIGJwZnRvb2wsIGJ5DQo+IHJlbW92aW5nICJjbGFuZy1icGYtY28tcmUiIGZyb20gRkVB
VFVSRV9URVNUUyBmcm9tIHRoZSBNYWtlZmlsZS4gWW91DQo+IHNob3VsZCBnZXQgYSBmdW5jdGlv
bmFsIGJpbmFyeSwgd2hpY2ggd291bGQgb25seSBtaXNzIGEgZmV3IGZlYXR1cmVzDQo+IChuYW1l
bHksIHByaW50aW5nIHRoZSBwaWRzIG9mIHByb2dyYW1zIGhvbGRpbmcgcmVmZXJlbmNlcyB0byBC
UEYNCj4gcHJvZ3JhbXMsIGFuZCB0aGUgImJwZnRvb2wgcHJvZyBwcm9maWxlIiBjb21tYW5kKS4N
Cg0KT2ssIHdpdGggImNsYW5nLWJwZi1jby1yZSIgcmVtb3ZlZCwgYnBmdG9vbCBkb2Vzbid0IGNv
bXBsYWluLg0KDQpIb3dldmVyLCBkb2VzIGl0IHdvcmsgYXQgYWxsID8NCg0KSSBzdGFydGVkIGEg
J3RjcGR1bXAnLCBJIGNvbmZpcm1lZCB3aXRoICcgYnBmX2ppdF9lbmFibGUgPT0gMicgdGhhdCBh
IA0KQlBGIGppdHRlZCBwcm9ncmFtIGlzIGNyZWF0ZWQgYnkgdGNwZHVtcC4NCg0KJ2JwdG9vbCBw
cm9nIHNob3cnIGFuZCAnYnBmdG9vbCBwcm9nIGxpc3QnIHJldHVybnMgbm8gcmVzdWx0Lg0KDQpD
aHJpc3RvcGhlDQo=
