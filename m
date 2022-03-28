Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01CB4E9FBF
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 21:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245682AbiC1TZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 15:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239671AbiC1TZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 15:25:51 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6D2522F7;
        Mon, 28 Mar 2022 12:24:10 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22SGICTg016471;
        Mon, 28 Mar 2022 12:24:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=olXc0Kx8os06IAjIPcS3haqRAVbjvT8Kv0dLXq/r5UQ=;
 b=jCBuBe6uGmmgv498dz3AvGKYX2inHPFRvLBmqWYHv7yzYGp+qBJHOKvoe0FgAY4VnZVw
 TyZU6vBhol2zh/bnHjzyinKz68M1hB7u5gaXXoD0edbG52caQGeTMU0WS7jp9CtCsjsm
 hm7ZixWzfztEgmyVGxoBDyBgchnjquSzjT4= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f1xvgw13k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 12:24:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUfRupd12dJKcnceK0XrZKH8L1ACVVcJAx2Sq7gKTTizg4/siiGV/vNnXRvzjexw1yRPEBxMKjyNyI/S1hrMMfUNwZhNnhTpdAargqQb5kR31ALXKPLLv+Nb90tLvLCfJea98FBZPvEXBd6j4igYmfpBJ5yYdFPvyB0Fzff2Nwd0S3bZZZHndKOtEdrGPdct203r3XvGAcXStQl9zZVkKjp7ep8nL/uRFM0vKyQkokvQflOehR04vBpFXxWx+einePXILfhNqy/DKNU9ooZmYB7ctbxxf9Ji+FZBTCwZTmVr4RhU16OpQPVIiI0zCxtIrtuXHyTBQND+4evANHrLzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olXc0Kx8os06IAjIPcS3haqRAVbjvT8Kv0dLXq/r5UQ=;
 b=UhX6RhKPNsLHXvuoVG5d/R+N7JCzwDHFLt9Bnyl5oehpV+vhh2LgIM+U57fLhUOVqz0oWOYXvxfqHqIxZ3hZlperZOnVmowl9RPBwUiEdWWUj900wjIjrPetyQvdbia3FJtqsQf+cu4x6x0OVfPlU8KLqfQUvwE+eg9/NExNM3iAS3fNVJ75IqacT+TLapNyzzE+Snxuhsg+Kimpi7uyR+GAfSBpF+dj+XHhN1tnj8Ck/k4K8HE/dPz5PmVoBjBzXwhCmdCP3W4iWxIMcRTpOnNg2Igur2rq2ezqgndwy8Dt9eE0LaheUwZ7Hpj9/4uqnHr4Fy9tqMbWwhpY9+///Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH7PR15MB5256.namprd15.prod.outlook.com (2603:10b6:510:13b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Mon, 28 Mar
 2022 19:24:06 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::58c9:859d:dc03:3bb4%3]) with mapi id 15.20.5102.022; Mon, 28 Mar 2022
 19:24:06 +0000
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
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: BUG: Bad page state in process systemd-udevd (was: [PATCH v9
 bpf-next 1/9] x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with
 HAVE_ARCH_HUGE_VMAP)
Thread-Topic: BUG: Bad page state in process systemd-udevd (was: [PATCH v9
 bpf-next 1/9] x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with
 HAVE_ARCH_HUGE_VMAP)
Thread-Index: AQHYQUHPn1C8bdt0C0ua951gurnjtazTCmuAgAFPq4CAAAPWgIAA0lUA
Date:   Mon, 28 Mar 2022 19:24:06 +0000
Message-ID: <44B009D1-2BF8-4C69-9F09-B0F553A48B78@fb.com>
References: <20220204185742.271030-1-song@kernel.org>
 <20220204185742.271030-2-song@kernel.org>
 <14444103-d51b-0fb3-ee63-c3f182f0b546@molgen.mpg.de>
 <7edcd673-decf-7b4e-1f6e-f2e0e26f757a@molgen.mpg.de>
 <7F597B8E-72B3-402B-BD46-4C7F13A5D7BD@fb.com>
 <4a49a98a-d958-8e48-10eb-24bb220e24ed@molgen.mpg.de>
In-Reply-To: <4a49a98a-d958-8e48-10eb-24bb220e24ed@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50099255-03e2-4480-0422-08da10f0867e
x-ms-traffictypediagnostic: PH7PR15MB5256:EE_
x-microsoft-antispam-prvs: <PH7PR15MB5256E21C5B4495FDD419EEBEB31D9@PH7PR15MB5256.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XS709tXaFHXobXSn9fNn9F8VRm/JCxmqeiQs+VDey+33WUqYgjzH9QjMmfM+itezWVL4ibqNz5nCo0oVRvmjxR87AfJfmkPExcfqqSMUnrk8kMarJ9l/8vgnzGpWgSSe4W7RPTer15gbmXW7rCkmqqSdADBO8NTeLDerjZGJejWN5/hxB6GWejWF847ixsW0knjOEHn0mgX4//sDhKIMnhSGADMLp8Z5WkIwTzbkA5FOBamQP+koJSH88jmpF5b66Rs+c0BOmI/gvHwhsU6checuLp42Rcmcamz5ayLZe2ZAPiof4jieb34HQJOjlbrrrEo3WrxTq88xdzozFTroT2WHQE6OutU6DoWYd0CBUOY/YM2gpS4OK3fYP/ug91T2x6YiILm3Oy3xR6C3Vl/j2G7x8mqKq2UjqhmebN9H0HcqYKzPVpjsU8sBOw6Y4ZHWxZkQIBfmD21sVOpgj6OnEB99/9txpB5RQ2Q/+DKKoGLUNMmdz7Go9ahp7aoY7AfQQYhYELXE3nwIhGBxv2JyhoutMxQu408dEN+H+TO1kS8r/L7aNoZjdXnI6q8eH92VfmN+HLjIaConvLH1BMtN+LuePX/5Hcoucgfn4RvuC7IuaL+UooTQfrrarIxKRAI77F33zGYoI98JEXtIwHFjnjHzc1tF/OBSE4xg9KFSdAj2R9mBwgCoee1Hifmwg971GmQmaXul8mUCBYkKtppCaMh6rR0soCNbN6pSdw+oVXexrIwtsV1kACVP99s6d65zX5ljjgnDxlXuok9KvnRXcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(4326008)(5660300002)(64756008)(66446008)(38100700002)(2906002)(66476007)(8676002)(86362001)(2616005)(6486002)(186003)(76116006)(36756003)(66946007)(6916009)(316002)(508600001)(6506007)(71200400001)(91956017)(54906003)(6512007)(38070700005)(66556008)(8936002)(83380400001)(7416002)(53546011)(122000001)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2ZvSlVURnFTRDkwU01LK3VXa3hqb1JadFBla1BaTUQ0cGVMVTVHcElVSnJm?=
 =?utf-8?B?bFN1WVBMc1pVZlJJOTZkc1VxV29DV3JJSXJza2x5Q1RId3hNKzZTdHhlVDh0?=
 =?utf-8?B?TWVzRHR3OVRJaTliSEgwMDViOW1RWDhFNzU0MjRIQjBaOVRsbjBPSkJWSFIw?=
 =?utf-8?B?SlJ2c1lZTzlrdFVXUmRTZ1FyVGVzckV1UThMYUxUcitwbzgxODc3MVgzSnBy?=
 =?utf-8?B?TkdkKzRPRFlNeWlZVUU5R01sbnhud3VKbnpsaWdUNnNQSlJwRmNLVGFXOUwx?=
 =?utf-8?B?cnA1QWRQVUFZVEI3OVovY1ZyTDB3ZFlxZDZ2QmE4TW9KcCtNSnFneS83UHZ6?=
 =?utf-8?B?NnZubXRHbmZnK05qSHBib0lzZ1BjZ2UrcHJnUXFzUit2eE9QMi9xS1pzS3RQ?=
 =?utf-8?B?a3RxT011d0liZ0hYK0RIdHFVWkJrWWJQMU13L1R5cU1YSEpzaFBRSXNPazFn?=
 =?utf-8?B?S1o4N0hNOGFkYVpXZzFOblJ0K0dtQUVoRGJieFN5elNleU9DWGg0Q3dreHJk?=
 =?utf-8?B?OGI2RXNQRkVxKytzeTlzZnBjSnp5MFQ3TGZqZzFsbTMydzdIemZFKzgzODdK?=
 =?utf-8?B?Q29ndEcrU29kRFQrZ0kxaHNXTUVaTTU5ZjhtRUY4YUZzYVgrTUFKTWY0VFh3?=
 =?utf-8?B?K2tYNVh2NWZuUTBPaVRmYktBZ0FTbzExU2JOcll3OFlCeHBzRjZnK3VQU1NK?=
 =?utf-8?B?WU5remdrR2ZjUUd2Y0VaZWRBb25hWitjWXV3c3lldjB2Ly8wN2F1Y1ZJSnlT?=
 =?utf-8?B?elV0TFlWNDFWUkFvK2x3OTIrZG1UMDNVd0F4dU1DelJvQWZnTjNoTjV6cjVL?=
 =?utf-8?B?Z3o1M2NyanlmSVdXRHg0Mk1ULzBhZG1oUjYvNW9xS0l0eTJGcUMwcXpHVFdz?=
 =?utf-8?B?OHlOZDNtZjI4S3o5eHBOcjI2ejd5cXNFYmtRNTEwNEM3RHZteUFzMWtJOWxk?=
 =?utf-8?B?SzFMOUN0T2N0SU9iNmd1UG1YS1VyYlBPelRnQWNhVW85bEM0b2NDY09hdGp2?=
 =?utf-8?B?M054cERzZWVxL09WUFlSU0sya2tXb2hxWnlMNEdla3EwNERQbXo4Z24wV2Fs?=
 =?utf-8?B?dHhQampCRWlOMGlnaUNpVE03bUJEWVVOZG5LbDJxVmVjTDIvUWI3L1V6SzNz?=
 =?utf-8?B?YzZYaTFzN01rNGs0WVVGZUw4YzNQWTh0anZTdndKN1hOTGx6emg1ajV0MkVD?=
 =?utf-8?B?b0VYeVFINGU4MXRkMlI4bEwwZVltZ0IrdFRsTXM0b2x3SDNJblRuc2Fzdml4?=
 =?utf-8?B?d1JOSmhXcUxqOEVBcW1QdktCQjlXTmJSY3RFQmQveUhYelFSRGF4K3VNc0dT?=
 =?utf-8?B?ZDBEWDJMZmh5Vno2SnR6TDZXWkdQZ1NTdDRkYmtQUkFmTnlJTTM2WEREYmo2?=
 =?utf-8?B?eVUrZWVyQjVIOVEzL29PYzRDVDZWUHVTcjI1QmtsY2hJZ3ZKNkptaUpvMUU3?=
 =?utf-8?B?ZDZaY00zVWplUzAwZFRnb2tvU0drb3J5aXcxY3NFa3gzcUdqMGZMUjB4MjNv?=
 =?utf-8?B?dUdoSEpGTUNRTTMwV0E1R0dTNjh6ZHkwMGlITUtKS2tNUWFHcDlqZVBGRHp2?=
 =?utf-8?B?L09SRExwbFlNWUc4Rm5xZy90b1JDSTM1aWJiVXlKMlFWTDVCZnhnSVJIR3B4?=
 =?utf-8?B?KzVoNkNlbDRHdURDK0x1dHU3YVhsNnF1RVlVay83WXRDMVZ3YnlNVnNlUGhZ?=
 =?utf-8?B?cmNYV1ZXVEZMenNhNzFGQWlKK2pqbU5lTFVkZEF1Ti8raEx5Ny9oWGlVTlVq?=
 =?utf-8?B?bEhNRUNIbThTaHh1TWFnRkkrOHorTlZpQzQ2eVY4bGl5R0ZBamcyTE1EOHoy?=
 =?utf-8?B?Q29Ma2FMc2VJbk1CYnhrTVJPWnZjOXJIbUFnRDZpSGV3a0lKMkxXWWFDU0Fn?=
 =?utf-8?B?NmZoNzA5bFA2eVRjQWlrSDAyMlYzWEZVRElwS1pxTkp0VXVFWjFJeCsrMlkr?=
 =?utf-8?B?RG1OM3V0RmdYVUZqZHdOa0Q2SmY3Z2JSNFUyUXJCUjl3Njc5R2V4M0wwdEdL?=
 =?utf-8?Q?BaYkwGznLXkO76orWOx/1jwd5z1q2k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <697A8248866A454A9D32141B12967A29@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50099255-03e2-4480-0422-08da10f0867e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 19:24:06.0009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TO8hQzDCkFm8CVmeIvqZmqy53jVI5RURivYq4dj79JZPg///IiziSmwJpipH+Gecf8PowmqXeaPbdvlNirpkKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5256
X-Proofpoint-ORIG-GUID: 4uryHX4QqAzHumKiENUvxBiYl1Cc23uC
X-Proofpoint-GUID: 4uryHX4QqAzHumKiENUvxBiYl1Cc23uC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_09,2022-03-28_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTWFyIDI3LCAyMDIyLCBhdCAxMTo1MSBQTSwgUGF1bCBNZW56ZWwgPHBtZW56ZWxA
bW9sZ2VuLm1wZy5kZT4gd3JvdGU6DQo+IA0KPiBEZWFyIFNvbmcsDQo+IA0KPiANCj4gQW0gMjgu
MDMuMjIgdW0gMDg6Mzcgc2NocmllYiBTb25nIExpdToNCj4+IFRoYW5rcyBQYXVsIGZvciBoaWdo
bGlnaHRpbmcgdGhlIGlzc3VlLg0KPiANCj4gVGhhbmsgeW91IGZvciBnZXR0aW5nIGJhY2sgdG8g
bWUgc28gcXVpY2tseS4NCj4gDQo+PiArIFJpY2ssIHdobyBoaWdobGlnaHRlZCBzb21lIHBvdGVu
dGlhbCBpc3N1ZXMgd2l0aCB0aGlzLiAoYWxzbyBhdHRhY2hlZA0KPj4gdGhlIHN0YWNrIHRyYWNl
KS4NCj4gDQo+IEkgYWxyZWFkeSBoYWQgYWRkZWQgaGltLCBidXQgZm9yZ290IHRvIGRvY3VtZW50
IGl0IGluIHRoZSBtZXNzYWdlLiBTb3JyeSBmb3IgdGhhdC4NCj4gDQo+Pj4gT24gTWFyIDI3LCAy
MDIyLCBhdCAzOjM2IEFNLCBQYXVsIE1lbnplbCA8cG1lbnplbEBtb2xnZW4ubXBnLmRlPiB3cm90
ZToNCj4gDQo+Pj4gQW0gMjYuMDMuMjIgdW0gMTk6NDYgc2NocmllYiBQYXVsIE1lbnplbDoNCj4+
Pj4gI3JlZ3pib3QgaW50cm9kdWNlZDogZmFjNTRlMmJmYjViZTJiMGJiZjExNWZlODBkNDVmNTlm
ZDc3MzA0OA0KPj4+PiAjcmVnemJvdCB0aXRsZTogQlVHOiBCYWQgcGFnZSBzdGF0ZSBpbiBwcm9j
ZXNzIHN5c3RlbWQtdWRldmQNCj4+PiANCj4+Pj4gQW0gMDQuMDIuMjIgdW0gMTk6NTcgc2Nocmll
YiBTb25nIExpdToNCj4+Pj4+IEZyb206IFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BmYi5jb20+
DQo+Pj4+PiANCj4+Pj4+IFRoaXMgZW5hYmxlcyBtb2R1bGVfYWxsb2MoKSB0byBhbGxvY2F0ZSBo
dWdlIHBhZ2UgZm9yIDJNQisgcmVxdWVzdHMuDQo+Pj4+PiBUbyBjaGVjayB0aGUgZGlmZmVyZW5j
ZSBvZiB0aGlzIGNoYW5nZSwgd2UgbmVlZCBlbmFibGUgY29uZmlnDQo+Pj4+PiBDT05GSUdfUFRE
VU1QX0RFQlVHRlMsIGFuZCBjYWxsIG1vZHVsZV9hbGxvYygyTUIpLiBCZWZvcmUgdGhlIGNoYW5n
ZSwNCj4+Pj4+IC9zeXMva2VybmVsL2RlYnVnL3BhZ2VfdGFibGVzL2tlcm5lbCBzaG93cyBwdGUg
Zm9yIHRoaXMgbWFwLiBXaXRoIHRoZQ0KPj4+Pj4gY2hhbmdlLCAvc3lzL2tlcm5lbC9kZWJ1Zy9w
YWdlX3RhYmxlcy8gc2hvdyBwbWQgZm9yIHRoaWUgbWFwLg0KPj4+Pj4gDQo+Pj4+PiBTaWduZWQt
b2ZmLWJ5OiBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPg0KPj4+Pj4gLS0tDQo+Pj4+
PiAgIGFyY2gveDg2L0tjb25maWcgfCAxICsNCj4+Pj4+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspDQo+Pj4+PiANCj4+Pj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9LY29uZmlnIGIv
YXJjaC94ODYvS2NvbmZpZw0KPj4+Pj4gaW5kZXggNmZkZGI2MzI3MWQ5Li5lMGUwZDAwY2YxMDMg
MTAwNjQ0DQo+Pj4+PiAtLS0gYS9hcmNoL3g4Ni9LY29uZmlnDQo+Pj4+PiArKysgYi9hcmNoL3g4
Ni9LY29uZmlnDQo+Pj4+PiBAQCAtMTU5LDYgKzE1OSw3IEBAIGNvbmZpZyBYODYNCj4+Pj4+ICAg
ICAgIHNlbGVjdCBIQVZFX0FMSUdORURfU1RSVUNUX1BBR0UgICAgICAgIGlmIFNMVUINCj4+Pj4+
ICAgICAgIHNlbGVjdCBIQVZFX0FSQ0hfQVVESVRTWVNDQUxMDQo+Pj4+PiAgICAgICBzZWxlY3Qg
SEFWRV9BUkNIX0hVR0VfVk1BUCAgICAgICAgaWYgWDg2XzY0IHx8IFg4Nl9QQUUNCj4+Pj4+ICsg
ICAgc2VsZWN0IEhBVkVfQVJDSF9IVUdFX1ZNQUxMT0MgICAgICAgIGlmIEhBVkVfQVJDSF9IVUdF
X1ZNQVANCj4+Pj4+ICAgICAgIHNlbGVjdCBIQVZFX0FSQ0hfSlVNUF9MQUJFTA0KPj4+Pj4gICAg
ICAgc2VsZWN0IEhBVkVfQVJDSF9KVU1QX0xBQkVMX1JFTEFUSVZFDQo+Pj4+PiAgICAgICBzZWxl
Y3QgSEFWRV9BUkNIX0tBU0FOICAgICAgICAgICAgaWYgWDg2XzY0DQo+Pj4+IFRlc3RpbmcgTGlu
dXPigJkgY3VycmVudCBtYXN0ZXIgYnJhbmNoLCBMaW51eCBsb2dzIGNyaXRpY2FsIG1lc3NhZ2Vz
IGxpa2UgYmVsb3c6DQo+Pj4+ICAgICBCVUc6IEJhZCBwYWdlIHN0YXRlIGluIHByb2Nlc3Mgc3lz
dGVtZC11ZGV2ZCAgcGZuOjEwMmUwMw0KPj4+PiBJIGJpc2VjdGVkIHRvIHlvdXIgY29tbWl0IGZh
YzU0ZTJiZmI1ICh4ODYvS2NvbmZpZzogc2VsZWN0DQo+Pj4+IEhBVkVfQVJDSF9IVUdFX1ZNQUxM
T0Mgd2l0aCBIQVZFX0FSQ0hfSFVHRV9WTUFQKS4NCj4+PiBTb3JyeSwgSSBmb3JnZXQgdG8gbWVu
dGlvbiwgdGhhdCB0aGlzIGlzIGEgMzItYml0IChpNjg2KSB1c2Vyc3BhY2UsDQo+Pj4gYnV0IGEg
NjQtYml0IExpbnV4IGtlcm5lbCwgc28gaXQgbWlnaHQgYmUgdGhlIHNhbWUgaXNzdWUgYXMNCj4+
PiBtZW50aW9uZWQgaW4gY29tbWl0IGVlZDFmY2VlNTU2ZiAoeDg2OiBEaXNhYmxlDQo+Pj4gSEFW
RV9BUkNIX0hVR0VfVk1BTExPQyBvbiAzMi1iaXQgeDg2KSwgYnV0IGRpZG7igJl0IGZpeCB0aGUg
aXNzdWUgZm9yDQo+Pj4gNjQtYml0IExpbnV4IGtlcm5lbCBhbmQgMzItYml0IHVzZXJzcGFjZS4N
Cj4+IEkgd2lsbCBsb29rIG1vcmUgaW50byB0aGlzIHRvbW9ycm93LiBUbyBjbGFyaWZ5LCB3aGF0
IGlzIHRoZSAzMi1iaXQNCj4+IHVzZXIgc3BhY2UgdGhhdCB0cmlnZ2VycyB0aGlzPyBJcyBpdCBz
eXN0ZW1kLXVkZXZkPyBJcyB0aGUgc3lzdGVtZA0KPj4gYWxzbyBpNjg2Pw0KPiANCj4gWWVzLCBl
dmVyeXRoaW5nIOKAkyBhbHNvIHN5c3RlbWQg4oCTIGlzIGk2ODYuIFlvdSBjYW4gYnVpbGQgYSAz
Mi1iaXQgVk0gaW1hZ2Ugd2l0aCBncm1sLWRlYm9vdHN0cmFwIFsxXToNCj4gDQo+ICAgIHN1ZG8g
REVCT09UU1RSQVA9bW1kZWJzdHJhcCB+L3NyYy9ncm1sLWRlYm9vdHN0cmFwL2dybWwtZGVib290
c3RyYXAgLS12bSAtLXZtZmlsZSAtLXZtc2l6ZSAzRyAtLXRhcmdldCAvZGV2L3NobS9kZWJpYW4t
MzIuaW1nIC1yIHNpZCAtLWFyY2ggaTY4NiAtLWZpbGVzeXN0ZW0gZXh0NA0KPiANCj4gVGhlbiBy
dW4gdGhhdCB3aXRoIFFFTVUsIGJ1dCBwYXNzIHRoZSA2NC1iaXQgTGludXgga2VybmVsIHRvIFFF
TVUgZGlyZWN0bHkgd2l0aCB0aGUgc3dpdGNoZXMgYC1rZXJuZWxgIGFuZCBgLWFwcGVuZGAsIG9y
IGluc3RhbGwgdGhlIGFtZDY0IExpbnV4IGtlcm5lbCBpbnRvIHRoZSBEZWJpYW4gVk0gaW1hZ2Ug
b3IgdGhlIHBhY2thZ2UgY3JlYXRlZCB3aXRoIGBtYWtlIGJpbmRlYi1wa2dgIHdpdGggYGRwa2cg
LWkg4oCmYC4NCg0KVGhhbmtzIGZvciB0aGVzZSBpbmZvcm1hdGlvbiENCg0KSSB0cmllZCB0aGUg
Zm9sbG93aW5nLCBidXQgY291bGRuJ3QgcmVwcm9kdWNlIHRoZSBpc3N1ZS4gDQoNCnN1ZG8gLi9n
cm1sLWRlYm9vdHN0cmFwIC0tdm0gLS12bWZpbGUgLS12bXNpemUgM0cgLS10YXJnZXQgLi4vZGVi
aWFuLTMyLmltZyAtciBzaWQgLS1hcmNoIGkzODYgLS1maWxlc3lzdGVtIGV4dDQNCg0KTm90ZTog
cy9pNjg2L2kzODYvLiBBbHNvIEkgcnVuIHRoaXMgb24gRmVkb3JhLCBzbyBJIGRpZG4ndCBzcGVj
aWZ5IERFQk9PVFNUUkFQLiANCg0KVGhlbiBJIHJ1biBpdCB3aXRoDQoNCnFlbXUtc3lzdGVtLXg4
Nl82NCBcDQogIC1ib290IGQgLi9kZWJpYW4tMzIuaW1nIC1tIDEwMjQgLXNtcCA0IFwNCiAgLWtl
cm5lbCAuL2J6SW1hZ2UgXA0KICAtbm9ncmFwaGljIC1hcHBlbmQgJ3Jvb3Q9L2Rldi9zZGExIHJv
IGNvbnNvbGU9dHR5UzAsMTE1MjAwJw0KDQpUaGUgVk0gYm9vdHMgZmluZS4gVGhlIGNvbmZpZyBi
ZWluZyB1c2VkIGlzIHg4Nl82NF9kZWZjb25maWcgKyANCkNPTkZJR19EUk1fRkJERVZfRU1VTEFU
SU9OLiANCg0KSSB3b25kZXIgd2hldGhlciB0aGlzIGlzIGNhdXNlZCBieSBkaWZmZXJlbnQgY29u
ZmlnIG9yIGRpZmZlcmVudCBpbWFnZS4NCkNvdWxkIHlvdSBwbGVhc2Ugc2hhcmUgeW91ciBjb25m
aWc/DQoNClRoYW5rcywNClNvbmcNCg0KUFM6IEkgY291bGRuJ3QgZmlndXJlIG91dCB0aGUgcm9v
dCBwYXNzd29yZCBvZiB0aGUgaW1hZ2UsIC0tcGFzc3dvcmQgDQpvcHRpb24gb2YgZ3JtbC1kZWJv
b3RzdHJhcCBkb2Vzbid0IHNlZW0gdG8gd29yay4gDQoNCg==
