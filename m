Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7CA4EA33D
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 00:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiC1Wrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 18:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiC1Wrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 18:47:33 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738961342E0;
        Mon, 28 Mar 2022 15:45:48 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22SKVsGM012260;
        Mon, 28 Mar 2022 14:57:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=x04Ys9FyDqZQWN8uIKacW0EeCNyGXRCg2OlDLpviuZI=;
 b=jyL7IF5d0skOMcpbHZAqwQrAZGxYdDS/s6VE+AIVJIicaVzD/u93jXsTgh+QdJou09fK
 1Utl04npP72+YprCH5Y9zLvWWFTjY93jSZ6pY3wgNPLftsdQeSLt+QTJCak2hDqZD83c
 L8/DooWeW+tA2sRKN9zTHr1yL3+tyGoBbAE= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f20nswuhg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 14:57:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y824OCI4+WqumBrqWa/y14MJ4lyAXoC5rcRL440DjBar/uQHLKo8ZDmYdpu1kMGEhKgNWz7HmL83PltOwffP9qm9E/htPdTypQzL36e0hS50+VEQP47hDklE7KA7d4Jobz5se/mbouTf9PPgdutwLukUZJRwk0u4oEX0QPYWXviURhIKwtyzKXvfhOQmo3wT6n5mBiUQdqWQhqSe4vkWu8lLZx5RD4K8teW+UJXqCW/OKRZ49wz24a0lHgiaAbgiAwyuDzj39ACUjxnSOw50e7223A0nlaxQNA2qPaXF/xCaQqY7M3R7J4L89SZ3Nhg/YkHT0GpazEYZBQ6UfNj+9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x04Ys9FyDqZQWN8uIKacW0EeCNyGXRCg2OlDLpviuZI=;
 b=Q9XDD93H0Vb+wMQL3tdOCQd14gh9fiz5c2xXOqgDpER2tBZ21Y0hVc7p0v6j0Y97OCoMgvHCJSG9E7raSQdxVFE+PFzh61ccW4F4RQX8lm/bzkbctIFjB/4rxPkSvxdX0DN3CSZIJitwipdDBUpcL5q5S/hi6BzpPpF3swdIJOdmWOMBHYzfjKLgLsZZEsZgCdnrcvnGLg+DE6XmxZXMPFBo9OD9Aw60GNT78sjl7q3740xFSvReKGsEAIIx8D94k4HHI5t0pm5tmhvRsSUtb6j5lEGERD4apT7me7ejRaEavA4z8tHiTkysugT6BYFGeOaBH9v4Yn/Thzgdk+xK/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM5PR1501MB2104.namprd15.prod.outlook.com (2603:10b6:4:a3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.22; Mon, 28 Mar
 2022 21:57:41 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4%3]) with mapi id 15.20.5102.022; Mon, 28 Mar 2022
 21:57:41 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     Rick P Edgecombe <rick.p.edgecombe@intel.com>,
        Song Liu <song@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "iii@linux.ibm.com" <iii@linux.ibm.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
Subject: Re: BUG: Bad page state in process systemd-udevd (was: [PATCH v9
 bpf-next 1/9] x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with
 HAVE_ARCH_HUGE_VMAP)
Thread-Topic: BUG: Bad page state in process systemd-udevd (was: [PATCH v9
 bpf-next 1/9] x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with
 HAVE_ARCH_HUGE_VMAP)
Thread-Index: AQHYQUHPn1C8bdt0C0ua951gurnjtazTCmuAgAFPq4CAAAPWgIAA0lUAgAAOGACAABzSgA==
Date:   Mon, 28 Mar 2022 21:57:41 +0000
Message-ID: <1474E0D9-879C-4BBC-BB45-E6F0792DD490@fb.com>
References: <20220204185742.271030-1-song@kernel.org>
 <20220204185742.271030-2-song@kernel.org>
 <14444103-d51b-0fb3-ee63-c3f182f0b546@molgen.mpg.de>
 <7edcd673-decf-7b4e-1f6e-f2e0e26f757a@molgen.mpg.de>
 <7F597B8E-72B3-402B-BD46-4C7F13A5D7BD@fb.com>
 <4a49a98a-d958-8e48-10eb-24bb220e24ed@molgen.mpg.de>
 <44B009D1-2BF8-4C69-9F09-B0F553A48B78@fb.com>
 <cc77b58d-657e-b9d9-b1cf-9b72973c1623@molgen.mpg.de>
In-Reply-To: <cc77b58d-657e-b9d9-b1cf-9b72973c1623@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20bf7873-682c-4e2b-5893-08da1105fb4b
x-ms-traffictypediagnostic: DM5PR1501MB2104:EE_
x-microsoft-antispam-prvs: <DM5PR1501MB2104B7C5917C67BDE6CD4A11B31D9@DM5PR1501MB2104.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O9o278KNgB9Rk2nfogJC85ZP1wDQeB3qaB0n4PSSsJiRWP4h4wYLidsmEyQEfRwZH08VEN7lBId0J/6oYSr38DaeVoFaHEQUjjCo6+/dBNh3tDlCjtxjejGO/SlKrpc7AM4KscIFBQ92nvZtHjKDkn63o1x8zQ1znYQ/q/jEZVAmqfWsrX8S3iZ0B0FuxzT7Rb1MDlA7zZU65W0UAkGeGkIlRaOJpBL9qF0JlIAI/XqihkMefFYAPMBRzOzHYZdb+KaYT/C7RvQtYNvGoGQm8ophrvwRX9MQNxkOzU1+iXxf6DiBKBiy5YNq79dImIOMGVv3Gi159oSR/ZYfI3Vb4dOlOG7sBmXbp6udUIHNc2BmxS/LK88bT4myC8YVjPMLDxJ3e68dJcnbiLRirFzZ7WjqFvlxOxBbFnb2zMypIUg3BL2PUlWeauvnlTo0J8EHBExetsFl5NkvTm6/1FQax6rfPnEul/y5NWiXRUphyW2Cv8UowHVQRrd6k9Epv01+Cy+XEYY86aTe78DUSQHAzn8T7mN5/2Rp0cVVMexxyNSObXs49cMTSF3Uk0aJuHjYrt28bSeyInd+xVSDA49OS+xPCL+j8fc4ubXvVD9ijIBSsWDfz886+kRNEIUN6Tq4jcb6Fh7jo6AJKm46R1sV9+mHyHEoit3y+XIHTOs88sX0/YKQm0KGNFZ1hWgKyO5LJmhlzb2wvmvwZyRTm3CYX94WXvZdtw+wQHnRBjqsYLgPmA+bSMESqImTrfkmcLIHutj+UnbGmSaXabyCVaiR0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(2906002)(186003)(38100700002)(122000001)(8936002)(6916009)(54906003)(66476007)(64756008)(6486002)(76116006)(8676002)(66946007)(66446008)(66556008)(91956017)(7416002)(2616005)(316002)(86362001)(5660300002)(4326008)(71200400001)(36756003)(6512007)(38070700005)(53546011)(83380400001)(6506007)(33656002)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHQwcG4vQzA2Qy9SVVY4YnNmZWlFMDgrSW9hV3JOMjV4ZHNsTWpRVFpwcU9N?=
 =?utf-8?B?b1dXNnZ1WWcxNElPVmp3dHJzRnBveks1VzZqWGwveXliMlRBTWd3OElOWndZ?=
 =?utf-8?B?N1hpeXd6TTVjUDhhNEM3Rm55MmdlU0F0OXRXU0ZHM1E5dS9zeVFqTFpjWExB?=
 =?utf-8?B?Tk1iNUJDWDBnMnlNaTk4NlpUODBhb3l5QlBZUHVrYm1uc0JoZDA5ZmlZT21Y?=
 =?utf-8?B?YXc5TUk4RUdJaXFVZHZHK2J3eElsak8xTkVCTmRHZ2lZOUNhL2VKU2hNVnpZ?=
 =?utf-8?B?M2NMY0NhbjNwcHAwdFppdUx4TTkyUlowNFpUdEhvZTFxUG9iMENaWXM3UXRk?=
 =?utf-8?B?R0FkVlFpUlJVdFFxdkg0b3ZTbngwT09mTnE4MnZNVDZKVks3d0JaTVNialgv?=
 =?utf-8?B?cU5mVGtjLy9VaFdjNi82NHlnVnltWlBYeitVdm5Ec0RLTHF4dDUxeEs5L2VZ?=
 =?utf-8?B?THBzdGQ2Q245ZmVXS2U3ZUFKT2tHYzBpblNmSnhqNHJDRU81OUZidGJsQ3Zh?=
 =?utf-8?B?cHA3NDRmV2tCVUpvRG5oL29RZXZqNUdiVVBLVTZYcFpIa2pNMHN4d2gxYlY1?=
 =?utf-8?B?dk5QN0lvbWV4OU1BZi85bWpvdDlFV0pzT2UwL1JsZ296UHlVWUJMdTJRWjRS?=
 =?utf-8?B?TGN0SzIyQ25pSWk4UnVrYnNORjE0UUcrL3liNW5PSnpMTTg1QUtDdzFXMUNo?=
 =?utf-8?B?YTFmNUdPdUZKZlh2cnlLblJrSjFFc0JvV1RhZER0SHFiV1hGenZqbjlGNHpv?=
 =?utf-8?B?clIyUjJVdkwvVmNnTERycHV6dG5KWUtmb1dqZ3dtdTFNWkZFOUVJTWs5bzI1?=
 =?utf-8?B?OTNnbzFlZXc4U1Z2MXJyMjY0QUNGTFFBbGkzWnk0eVA1ZjlUTGhTd0FWR2dp?=
 =?utf-8?B?OXh0SDAzSmZ1Z3FEKzdMdzgvcTRZaTA3Nm9OaGNUZHg4cVhoMEFVZTlCL2Mx?=
 =?utf-8?B?aDVPWUFMck9wRDdtNW9FWWhWWmhRTVBhaVZHS1hvZnlDajN3VVpsWndFdUJt?=
 =?utf-8?B?bWhRbXRrWGNFa0tvK1FuaTNVUGo5eE1KbWdxaUlqYnlIUi9YeFVkcnhrTHBV?=
 =?utf-8?B?MWxFamp6bjZaY0VDT0tZS2w3OUR6TVcyb3pDTHdBWFBqY1ZneWlvUWFQL0U4?=
 =?utf-8?B?WTlkYlFNZ1pjTitZZnRGMTVIajJzUktlY0lwR01abW0rZVpLRUFIeFRnQ3dV?=
 =?utf-8?B?WkhuTXZRYzJFQmZIWjdnYkdDOTlNUndwN29jT01BYVlndE9ud09HUkl1djg5?=
 =?utf-8?B?cTJTVmRFU1pSMy9RaHo1TjdsYjNlalpQb0N5bkJVdkdoZkdDbjZZWHNSUzl1?=
 =?utf-8?B?YWlwcU1yWXVsUXhva2JWZm1EM1cvUzlJYUhoV01kWG8rU3E0Rk5MZmE0YWpQ?=
 =?utf-8?B?SFJJYndnbFpiSDFvVlBSaWVWS0pJMEFVeFAycmNVc0VZMnVzLy9YSFpFZmNn?=
 =?utf-8?B?WFFqa2YxeS9ZV2ljVkY1ckZ4dVZUeXhVcnB0ZE5saFJRenFMaUcyNzlLdnVJ?=
 =?utf-8?B?eDVTRjA3NWx1U3YwQzFOMTh4UGRRYkEwelF5T0tVa3dPcVRXcHhtNnZScTdU?=
 =?utf-8?B?MFJwTWR0TFJjQmV6Z01BWmlaelZWMjljUm9QTGdhRVUwd3g5ODVpMkExa2tL?=
 =?utf-8?B?ZWd6UnFlZENSRFUzb1pQVHBIVnQvK21scXNHdjRQaGgxSFN4VlhST2srSTRJ?=
 =?utf-8?B?TFE1WmJPYWpFcXRkeWhIWGRqd0RLdWowdk4xeHc2d0pHSUx2VEtDdkNIWkFj?=
 =?utf-8?B?RnJzSjlSa3BJaXdlU3lzWmQ4VXdzRE5XdjRETWNzUVczeVFORFBqWm84anlw?=
 =?utf-8?B?ekZDa2tqRHdudnR4eU5Rb2NQQ2EwbHBjTEgrNklpMzV4cW92Mnd3OUZ0eVZJ?=
 =?utf-8?B?L3J5bVpTdTVlVDBTdjQwLy91ZzlJa3FCR3Q1WXJJdXJKbFg0dkhsMXhOQWVo?=
 =?utf-8?B?ODBZZHNFcDY5WjJhNjhOSFcrK0tmV0FDSExqU0Nrc0dxb2hFOWxEZWhzOThO?=
 =?utf-8?B?cWFmMHp5M3ZYMFMrcDhqQzZoTGZkTWtaNjl6MXJCa0ZuMEZBWk1LS1lSNTFT?=
 =?utf-8?B?ZkYvQm9IK0UzSFJNeVJqTkg0bytKUW4wL1dMZDFUakZPSnN3NlZPV0RjaldN?=
 =?utf-8?B?MFN4SlhoMU9yRzdNeE9ZWk00ZEpGWCsxc3hncjJORFdKRE14OUZoSE54RmdP?=
 =?utf-8?B?cWJtL0dkRFlNaW1mRG8yMEdxL1hjWFg2aVZRMUJldnp6ZXRKQlpJNTI5Szdo?=
 =?utf-8?B?RnhveGk0ZE9VdUxDYk9VM3BPaDhjQ0Zwckk3dk5rTDZzRjA5UHFXVTlFTFJE?=
 =?utf-8?B?RURXY05WUVZBU2NTQWd0YncraiszS3ZWNG5ZRnd5M0g5RkVZbkVnOHFwYVhp?=
 =?utf-8?Q?TZBTJY8QRTV4DzJcSkkoWrhcHSGMa8ksIgOZ4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <150AD2B51E2E0441818796B6E5BAD8A5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20bf7873-682c-4e2b-5893-08da1105fb4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 21:57:41.3936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qyWEpcmTXK2xDoG3dm1dwsFNEvln6LhMDNpkzsHJhLG6w2kwA/JmxaWCZZ8fzVyRAlMA0o02r1Sa1k+qGEb/cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1501MB2104
X-Proofpoint-ORIG-GUID: myTD_dlLR9hmX-aEVhMOsJIQaUAaberx
X-Proofpoint-GUID: myTD_dlLR9hmX-aEVhMOsJIQaUAaberx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_10,2022-03-28_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTWFyIDI4LCAyMDIyLCBhdCAxOjE0IFBNLCBQYXVsIE1lbnplbCA8cG1lbnplbEBt
b2xnZW4ubXBnLmRlPiB3cm90ZToNCj4gDQo+IERlYXIgU29uZywNCj4gDQo+IA0KPiBBbSAyOC4w
My4yMiB1bSAyMToyNCBzY2hyaWViIFNvbmcgTGl1Og0KPiANCj4+PiBPbiBNYXIgMjcsIDIwMjIs
IGF0IDExOjUxIFBNLCBQYXVsIE1lbnplbCA8cG1lbnplbEBtb2xnZW4ubXBnLmRlPiB3cm90ZToN
Cj4gDQo+Pj4gQW0gMjguMDMuMjIgdW0gMDg6Mzcgc2NocmllYiBTb25nIExpdToNCj4gDQo+IFvi
gKZdDQo+IA0KPj4+Pj4gT24gTWFyIDI3LCAyMDIyLCBhdCAzOjM2IEFNLCBQYXVsIE1lbnplbCA8
cG1lbnplbEBtb2xnZW4ubXBnLmRlPiB3cm90ZToNCj4+PiANCj4+Pj4+IEFtIDI2LjAzLjIyIHVt
IDE5OjQ2IHNjaHJpZWIgUGF1bCBNZW56ZWw6DQo+Pj4+Pj4gI3JlZ3pib3QgaW50cm9kdWNlZDog
ZmFjNTRlMmJmYjViZTJiMGJiZjExNWZlODBkNDVmNTlmZDc3MzA0OA0KPj4+Pj4+ICNyZWd6Ym90
IHRpdGxlOiBCVUc6IEJhZCBwYWdlIHN0YXRlIGluIHByb2Nlc3Mgc3lzdGVtZC11ZGV2ZA0KPj4+
Pj4gDQo+Pj4+Pj4gQW0gMDQuMDIuMjIgdW0gMTk6NTcgc2NocmllYiBTb25nIExpdToNCj4+Pj4+
Pj4gRnJvbTogU29uZyBMaXUgPHNvbmdsaXVicmF2aW5nQGZiLmNvbT4NCj4+Pj4+Pj4gDQo+Pj4+
Pj4+IFRoaXMgZW5hYmxlcyBtb2R1bGVfYWxsb2MoKSB0byBhbGxvY2F0ZSBodWdlIHBhZ2UgZm9y
IDJNQisgcmVxdWVzdHMuDQo+Pj4+Pj4+IFRvIGNoZWNrIHRoZSBkaWZmZXJlbmNlIG9mIHRoaXMg
Y2hhbmdlLCB3ZSBuZWVkIGVuYWJsZSBjb25maWcNCj4+Pj4+Pj4gQ09ORklHX1BURFVNUF9ERUJV
R0ZTLCBhbmQgY2FsbCBtb2R1bGVfYWxsb2MoMk1CKS4gQmVmb3JlIHRoZSBjaGFuZ2UsDQo+Pj4+
Pj4+IC9zeXMva2VybmVsL2RlYnVnL3BhZ2VfdGFibGVzL2tlcm5lbCBzaG93cyBwdGUgZm9yIHRo
aXMgbWFwLiBXaXRoIHRoZQ0KPj4+Pj4+PiBjaGFuZ2UsIC9zeXMva2VybmVsL2RlYnVnL3BhZ2Vf
dGFibGVzLyBzaG93IHBtZCBmb3IgdGhpZSBtYXAuDQo+Pj4+Pj4+IA0KPj4+Pj4+PiBTaWduZWQt
b2ZmLWJ5OiBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPg0KPj4+Pj4+PiAtLS0NCj4+
Pj4+Pj4gICBhcmNoL3g4Ni9LY29uZmlnIHwgMSArDQo+Pj4+Pj4+ICAgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspDQo+Pj4+Pj4+IA0KPj4+Pj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
S2NvbmZpZyBiL2FyY2gveDg2L0tjb25maWcNCj4+Pj4+Pj4gaW5kZXggNmZkZGI2MzI3MWQ5Li5l
MGUwZDAwY2YxMDMgMTAwNjQ0DQo+Pj4+Pj4+IC0tLSBhL2FyY2gveDg2L0tjb25maWcNCj4+Pj4+
Pj4gKysrIGIvYXJjaC94ODYvS2NvbmZpZw0KPj4+Pj4+PiBAQCAtMTU5LDYgKzE1OSw3IEBAIGNv
bmZpZyBYODYNCj4+Pj4+Pj4gICAgICAgc2VsZWN0IEhBVkVfQUxJR05FRF9TVFJVQ1RfUEFHRSAg
ICAgICAgaWYgU0xVQg0KPj4+Pj4+PiAgICAgICBzZWxlY3QgSEFWRV9BUkNIX0FVRElUU1lTQ0FM
TA0KPj4+Pj4+PiAgICAgICBzZWxlY3QgSEFWRV9BUkNIX0hVR0VfVk1BUCAgICAgICAgaWYgWDg2
XzY0IHx8IFg4Nl9QQUUNCj4+Pj4+Pj4gKyAgICBzZWxlY3QgSEFWRV9BUkNIX0hVR0VfVk1BTExP
QyAgICAgICAgaWYgSEFWRV9BUkNIX0hVR0VfVk1BUA0KPj4+Pj4+PiAgICAgICBzZWxlY3QgSEFW
RV9BUkNIX0pVTVBfTEFCRUwNCj4+Pj4+Pj4gICAgICAgc2VsZWN0IEhBVkVfQVJDSF9KVU1QX0xB
QkVMX1JFTEFUSVZFDQo+Pj4+Pj4+ICAgICAgIHNlbGVjdCBIQVZFX0FSQ0hfS0FTQU4gICAgICAg
ICAgICBpZiBYODZfNjQNCj4+Pj4+PiBUZXN0aW5nIExpbnVz4oCZIGN1cnJlbnQgbWFzdGVyIGJy
YW5jaCwgTGludXggbG9ncyBjcml0aWNhbCBtZXNzYWdlcyBsaWtlIGJlbG93Og0KPj4+Pj4+ICAg
ICBCVUc6IEJhZCBwYWdlIHN0YXRlIGluIHByb2Nlc3Mgc3lzdGVtZC11ZGV2ZCAgcGZuOjEwMmUw
Mw0KPj4+Pj4+IEkgYmlzZWN0ZWQgdG8geW91ciBjb21taXQgZmFjNTRlMmJmYjUgKHg4Ni9LY29u
ZmlnOiBzZWxlY3QNCj4+Pj4+PiBIQVZFX0FSQ0hfSFVHRV9WTUFMTE9DIHdpdGggSEFWRV9BUkNI
X0hVR0VfVk1BUCkuDQo+Pj4+PiBTb3JyeSwgSSBmb3JnZXQgdG8gbWVudGlvbiwgdGhhdCB0aGlz
IGlzIGEgMzItYml0IChpNjg2KSB1c2Vyc3BhY2UsDQo+Pj4+PiBidXQgYSA2NC1iaXQgTGludXgg
a2VybmVsLCBzbyBpdCBtaWdodCBiZSB0aGUgc2FtZSBpc3N1ZSBhcw0KPj4+Pj4gbWVudGlvbmVk
IGluIGNvbW1pdCBlZWQxZmNlZTU1NmYgKHg4NjogRGlzYWJsZQ0KPj4+Pj4gSEFWRV9BUkNIX0hV
R0VfVk1BTExPQyBvbiAzMi1iaXQgeDg2KSwgYnV0IGRpZG7igJl0IGZpeCB0aGUgaXNzdWUgZm9y
DQo+Pj4+PiA2NC1iaXQgTGludXgga2VybmVsIGFuZCAzMi1iaXQgdXNlcnNwYWNlLg0KPj4+PiBJ
IHdpbGwgbG9vayBtb3JlIGludG8gdGhpcyB0b21vcnJvdy4gVG8gY2xhcmlmeSwgd2hhdCBpcyB0
aGUgMzItYml0DQo+Pj4+IHVzZXIgc3BhY2UgdGhhdCB0cmlnZ2VycyB0aGlzPyBJcyBpdCBzeXN0
ZW1kLXVkZXZkPyBJcyB0aGUgc3lzdGVtZA0KPj4+PiBhbHNvIGk2ODY/DQo+Pj4gDQo+Pj4gWWVz
LCBldmVyeXRoaW5nIOKAkyBhbHNvIHN5c3RlbWQg4oCTIGlzIGk2ODYuIFlvdSBjYW4gYnVpbGQg
YSAzMi1iaXQgVk0gaW1hZ2Ugd2l0aCBncm1sLWRlYm9vdHN0cmFwIFsxXToNCj4+PiANCj4+PiAg
ICBzdWRvIERFQk9PVFNUUkFQPW1tZGVic3RyYXAgfi9zcmMvZ3JtbC1kZWJvb3RzdHJhcC9ncm1s
LWRlYm9vdHN0cmFwIC0tdm0gLS12bWZpbGUgLS12bXNpemUgM0cgLS10YXJnZXQgL2Rldi9zaG0v
ZGViaWFuLTMyLmltZyAtciBzaWQgLS1hcmNoIGk2ODYgLS1maWxlc3lzdGVtIGV4dDQNCj4+PiAN
Cj4+PiBUaGVuIHJ1biB0aGF0IHdpdGggUUVNVSwgYnV0IHBhc3MgdGhlIDY0LWJpdCBMaW51eCBr
ZXJuZWwgdG8gUUVNVSBkaXJlY3RseSB3aXRoIHRoZSBzd2l0Y2hlcyBgLWtlcm5lbGAgYW5kIGAt
YXBwZW5kYCwgb3IgaW5zdGFsbCB0aGUgYW1kNjQgTGludXgga2VybmVsIGludG8gdGhlIERlYmlh
biBWTSBpbWFnZSBvciB0aGUgcGFja2FnZSBjcmVhdGVkIHdpdGggYG1ha2UgYmluZGViLXBrZ2Ag
d2l0aCBgZHBrZyAtaSDigKZgLg0KPj4gVGhhbmtzIGZvciB0aGVzZSBpbmZvcm1hdGlvbiENCj4+
IEkgdHJpZWQgdGhlIGZvbGxvd2luZywgYnV0IGNvdWxkbid0IHJlcHJvZHVjZSB0aGUgaXNzdWUu
DQo+PiBzdWRvIC4vZ3JtbC1kZWJvb3RzdHJhcCAtLXZtIC0tdm1maWxlIC0tdm1zaXplIDNHIC0t
dGFyZ2V0IC4uL2RlYmlhbi0zMi5pbWcgLXIgc2lkIC0tYXJjaCBpMzg2IC0tZmlsZXN5c3RlbSBl
eHQ0DQo+PiBOb3RlOiBzL2k2ODYvaTM4Ni8uIEFsc28gSSBydW4gdGhpcyBvbiBGZWRvcmEsIHNv
IEkgZGlkbid0IHNwZWNpZnkgREVCT09UU1RSQVAuDQo+PiBUaGVuIEkgcnVuIGl0IHdpdGgNCj4+
IHFlbXUtc3lzdGVtLXg4Nl82NCBcDQo+PiAgIC1ib290IGQgLi9kZWJpYW4tMzIuaW1nIC1tIDEw
MjQgLXNtcCA0IFwNCj4+ICAgLWtlcm5lbCAuL2J6SW1hZ2UgXA0KPj4gICAtbm9ncmFwaGljIC1h
cHBlbmQgJ3Jvb3Q9L2Rldi9zZGExIHJvIGNvbnNvbGU9dHR5UzAsMTE1MjAwJw0KPj4gVGhlIFZN
IGJvb3RzIGZpbmUuIFRoZSBjb25maWcgYmVpbmcgdXNlZCBpcyB4ODZfNjRfZGVmY29uZmlnICsN
Cj4+IENPTkZJR19EUk1fRkJERVZfRU1VTEFUSU9OLg0KPj4gSSB3b25kZXIgd2hldGhlciB0aGlz
IGlzIGNhdXNlZCBieSBkaWZmZXJlbnQgY29uZmlnIG9yIGRpZmZlcmVudCBpbWFnZS4NCj4+IENv
dWxkIHlvdSBwbGVhc2Ugc2hhcmUgeW91ciBjb25maWc/DQo+IA0KPiBTb3JyeSwgZm9yIGxlYWRp
bmcgeW91IG9uIHRoZSB3cm9uZyBwYXRoLiBJIGFjdHVhbGx5IGp1c3Qgd2FudGVkIHRvIGhlbHAg
Z2V0dGluZyBhIDMyLWJpdCB1c2Vyc3BhY2Ugc2V0IHVwIHF1aWNrbHkuIEkgaGF2ZW7igJl0IHRy
aWVkIHJlcHJvZHVjaW5nIHRoZSBpc3N1ZSBpbiBhIFZNLCBhbmQgdXNlZCBvbmx5IHRoZSBBU1VT
IEYyQTg1LU0gUFJPLg0KPiANCj4gQm9vdGluZyB0aGUgc3lzdGVtIHdpdGggYG5vbW9kZXNldGAs
IEkgZGlkbuKAmXQgc2VlIHRoZSBlcnJvci4gTm8gaWRlYSBpZiBpdOKAmXMgcmVsYXRlZCB0byBm
cmFtZWJ1ZmZlciBoYW5kbGluZyBvciBzcGVjaWZpYyB0byBBTUQgZ3JhcGhpY3MgZGV2aWNlLg0K
DQpJIGd1ZXNzIHRoaXMgb25seSBoYXBwZW5zIG9uIHNwZWNpZmljIGhhcmR3YXJlIGFuZCBjb25m
aWd1cmF0aW9uLiANCkxldCBtZSBzZWUgd2hhdCdzIHRoZSBiZXN0IHdheSB0byBub3QgYWxsb2Nh
dGUgaHVnZSBwYWdlcyBmb3IgdGhpcw0KY2FzZS4gDQoNClRoYW5rcywNClNvbmcNCg0KPiANCj4+
IFBTOiBJIGNvdWxkbid0IGZpZ3VyZSBvdXQgdGhlIHJvb3QgcGFzc3dvcmQgb2YgdGhlIGltYWdl
LCAtLXBhc3N3b3JkDQo+PiBvcHRpb24gb2YgZ3JtbC1kZWJvb3RzdHJhcCBkb2Vzbid0IHNlZW0g
dG8gd29yay4NCj4gDQo+IEhtbSwgSSB0aG91Z2h0IGl04oCZcyBhc2tpbmcgeW91IGR1cmluZyBp
bnN0YWxsLCBidXQgSSBoYXZlbuKAmXQgZG9uZSBpdCBpbiBhIHdoaWxlLg0KPiANCj4gDQo+IEtp
bmQgcmVnYXJkcywNCj4gDQo+IFBhdWwNCg0K
