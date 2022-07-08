Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE2356B209
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 07:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237176AbiGHExG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 00:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbiGHExF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 00:53:05 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E47876E82;
        Thu,  7 Jul 2022 21:53:04 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KPo8Q010705;
        Thu, 7 Jul 2022 21:53:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=DLEjmIuVS4gygwTvw3p7yxZCG3TheaX1umPVX+/UdBU=;
 b=jgRE+s0qSPlc+1BTzmXJCohuelO1tAX4A6mqSj13V+MkArhS0sbMSKXEKQBN/EuuHwSK
 prJQfXCE9Q3PNSIED8Td1ZcWvIBeJPtuuUM5h9wQ7nrua4K1FWE4etcmN6n2MfKmmA5q
 qPMdQEXPJ34YYtrrtk6mD6O5lfMuxLdVVdw= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h5ashp1ch-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 21:53:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtONAhz1SJ3rsqzkJT1lsAYuwJVi6EudWZD0zIm7/EfGwgKh7slEoMUM9w7hErr59MROPtsFUky7pDhb0BgpsbshkK410/ismSUCcvyywTCRm9S7cr1ABHfLR8WAwTrpLpRBohQbSYIBoN9CJQQQMzdy/4rbHlHlnRc/tzbd9JY3RuHfY+tKluviAakXJy3E273mEKHp0vRnxic/iW/PswiNvSJOzOy+U1z/IxkGdYQiZJ8JnMx4MbCcuTRYkmGvEZuvPTVKxAAPozX5M22Peoxqp/8VXPm4Z1xuLrqq44O1xd9J2U/5hp4nqbChauKUR4qP3hipjqFCeXBXoTYO6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLEjmIuVS4gygwTvw3p7yxZCG3TheaX1umPVX+/UdBU=;
 b=aSc+tTxH18hrrKEEYhwnfsOiI7W9Bx8VWUrBcikecpWs6HouPov/QzCvziSEABTUC5NLOMoHax0FYGza9uUo334iorH4S5FHhFXvPoju7ASZLqyMskgkY0BQ0FJUCqkCb3wtF0XxUHK19SdCL0RXK/EM3gs1x4IDJvFjxuxIg7g3SkTlT7X2JWuXwhIl2Tay1I2Xb453WX7OapfLOKPEww/OkyzOMzWYYULPSYnJa8pjzbSS6u8HGNM7lbT5ubilOxatbha7febehj7i0kVgJIXMMc1wDelcwHiHOleVwxAaynO6ftvRYFZemGzeq77tIf1P/TGl/uJdvVl12WcYYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB2923.namprd15.prod.outlook.com (2603:10b6:5:138::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Fri, 8 Jul
 2022 04:53:00 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e8cd:89e9:95b6:e19a%7]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 04:53:00 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Pu Lehui <pulehui@huawei.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: Re: [PATCH bpf-next] samples: bpf: Fix cross-compiling error about
 bpftool
Thread-Topic: [PATCH bpf-next] samples: bpf: Fix cross-compiling error about
 bpftool
Thread-Index: AQHYkga7HcKsl6ueBUOt13UUFx+YDK1zRwcAgAB+u4CAAAdSgIAAHBAA
Date:   Fri, 8 Jul 2022 04:53:00 +0000
Message-ID: <892F3434-8DB2-438B-8A1A-314F39A2B4BD@fb.com>
References: <20220707140811.603590-1-pulehui@huawei.com>
 <FDFF5B78-F555-4C55-96D3-B7B3FAA8E84F@fb.com>
 <c357fa1a-5160-ed85-19bf-51f3c188d56e@huawei.com>
 <d44f8faf-06df-6fdf-0adf-2abbdf9c9a49@huawei.com>
In-Reply-To: <d44f8faf-06df-6fdf-0adf-2abbdf9c9a49@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 560a1a47-b29b-4826-d116-08da609dbc16
x-ms-traffictypediagnostic: DM6PR15MB2923:EE_
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A7OfpM8/CHs1LX6aepAc3LHd7gc+Eptnk+YjNfWjSdONRpcvF2M2pv0ugBSoHO0Sukt5wYuH7WHPiTaqR6q/kDo33GIQnCh23u83f/cq3bYTXKOxKHBntbzAVyd5tYH3DqdVT+04qmGAEf5fep+oy7gEKzq+3M7/+dk210prkrCV9+3mmjJEZRHZTjDk/urNy2hkewCznoWHiLVBDUc49ZvwR8SAYaB/6ckFUto/nxL+Q7Ozo9aqd8OrNM60/5mKMatOftE1n9zk+aJV8LcszRvjwJTNDgxz0tofyZFCnMIv8jiO4NWPUbpHZ9XKXhypNBO3o34gpw5e9YWMFxulG0n64BllisXk7jeH4D9Z5+7jswDIr48gQWwsv1aPNF885HT810LDB4v2rZm8qZpfYf3jHKgO4IsaieO9TU9F+fCIoUak/ZT6HwnCT0ucJ4YHJMbv7bMpEej5upp1Q2D8bnAeaIq+v9LWb4sKYaM+YjGA/daPPdfOKq2mRwATg+Bl9MlWU0lZppA7aANQRqOrQBEXFnrK5nKPNQ43R3bTKhnUcXfq5m/1Nb+jTq3S15+M0p+TPb8K/qime1Mfhv4ChL5wTWQsWHHEqWSYrdnnFVrF1hY4IU7Ij4ec3LbNm6t/195R1zyQtTvwS7Jk79mERvyQ/bnIYLso/9Ejr0y6YaezxnWveCp7yXCRBbWRfKHQe+w8RPJ+7+kh1PaAZq8Wq81I1pAvesxZ+9zMg0bYtOQ+9Dnvc7mmAmokYFy+gf53bZhbl4Bg6z7Vt4qdxBEhOASFd9v6GNROoamFp9Cf++AgYp3xI93Rg1GeuoIAAeXndCaRa5MYthV8ddQN2PfzXpr/RkuDD7il4IXJ2+XXF+Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(64756008)(5660300002)(6916009)(316002)(54906003)(8936002)(38070700005)(66476007)(83380400001)(66946007)(122000001)(4326008)(6512007)(91956017)(86362001)(8676002)(38100700002)(186003)(71200400001)(66446008)(6486002)(478600001)(76116006)(53546011)(2616005)(66556008)(2906002)(33656002)(6506007)(41300700001)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vxxIEnvkQ7pVOp+wYwmJj7MRdR8xY1xuIMQKxnvwPwhVQ0psvCfozFNOVs9L?=
 =?us-ascii?Q?ZIpWeaCk0SkIW/XvgiIgyBOlvi6iNWQpFURU2SMwXEOXCl3wph6CqLqhOrcP?=
 =?us-ascii?Q?xKIimaMSPj6j3ZynAcd1H6On9nK2nebOV1omrhGTIuWIfMTfeQDkUbxwvWf1?=
 =?us-ascii?Q?i2yxC9dc9GGIOFvvA0l29AJLcKpQTxljExyacG2tK2mKy6OhYGAu6pJF7FOk?=
 =?us-ascii?Q?7YpOqw+OWYbNaejpQbTMe7iXJmfDzUyNEtRGXUclvbTfpUv0DYiBGFE/2DN7?=
 =?us-ascii?Q?IFwmcaWaEryKCi8RBjcKbwj2472eW4O8RwCebJ93Bea6n1hBkjGCREk1oMNl?=
 =?us-ascii?Q?yoKQfD8CW/tjPxdSfZS+MpKTvLFrho/E7UJK74kNPqdnlmjD9mW5r182cMTV?=
 =?us-ascii?Q?6cMSxMKIllcg71+GOzd2syvBgamS9xAQkkCv4YWGkqwxX7dFDribR2jpOsvi?=
 =?us-ascii?Q?LT0JcLzV4sSbrh2YiCZN3rOj2288uRT/+Z49JzgTeXTRkDKldTVF8vNEJ/L5?=
 =?us-ascii?Q?1S/Wop6yrn1ck21VT1XQezb6Ndat0TytNhgRMzU38DA8L+L4bfK49u/ndEPq?=
 =?us-ascii?Q?cfpncWFhBWM9tPGpXJA2NBhbvM2Ij8ljA6qjgUl8ih0JNm4eHPgPRE+tYBo3?=
 =?us-ascii?Q?AaEXGm3RKsj9L4MlqVcL/tl5cAVogQtzr/i4Wt0GaPsLsVtskbnFLrC7Uq8J?=
 =?us-ascii?Q?XBTO83165BuPUgTnsoLxV0t840ny8ZozgKUu6reuqIYBXyyXpEhO6tskbK8B?=
 =?us-ascii?Q?lMpZdYQC8B8cZLM6l/5aNPU3HD5zbetNRvGKCSQ9W2/21BA56nz9mND3QT+V?=
 =?us-ascii?Q?1z7e7YP4YkPLuIyt+oZtd+3NN3my0OlHllyUC/Jy4gYjw++LPs/mDET/lc+L?=
 =?us-ascii?Q?EGvYIzYo9WAdkcM4ftJyqst96DUzihbxtx6ovuC7DvkId57wReuV65U+y/mc?=
 =?us-ascii?Q?rWHqXoFjmBmUdl2O+af+zPAKOfoL3X3IOlPE4EH01oBTO8m/1j4BLGZogAFS?=
 =?us-ascii?Q?nza9/Q/Ev4j4RsV2p5s+s1VMppIo4diig8spRIUSajxvKXIRCK5Xl1vA47dq?=
 =?us-ascii?Q?KU4Y62G9J538m0JiSpG/NUQbYF8OvQsBEY0LwNS4XcM9XBnbD1VKTKQ7YBWy?=
 =?us-ascii?Q?D0FWXJe+BtlLZ5bAN90u66haBfIX+3iipoqkM9vsEoDAieHx+w+Ilk20IOH7?=
 =?us-ascii?Q?N7ZDV6F+tuXrGzJU082B6bmg7kpH7kUdEbL3IDMWB2LYKubczXdqPDdFRs0M?=
 =?us-ascii?Q?DAqgNkX+q/H864GKM5Xhc3yG9MvJud+ooLRmP1mUpjDdtZ1L2KAZ5Yo0eU3e?=
 =?us-ascii?Q?HRbOMSQRAZUbix3NcKjiMWdinA02FjyTVZKB+0OpypE9UWFTVxK7jrzgMFoG?=
 =?us-ascii?Q?t++J3FqMUeVK3auGvVMgh/Dln6tc3Q5WxpeSNSdfeYhbgb1DAbdfpJCa35hB?=
 =?us-ascii?Q?kvcmbmj+hg+6Ndsmv6SXK4qrUXO6NqKiY6o2EaFpQYJriyIKXxLwhDdwpoIx?=
 =?us-ascii?Q?KUlVRCV6OP5iqla/idVjXqobD7zgZ1W5zNj7CEU1y8ZaUWf+H6GxaaL4LBJ2?=
 =?us-ascii?Q?gTSO7fo+ZApoFO2c3o1jT6WPJW/WzqJf2w/nZ5W4uq/kO6sXlpRx5/tnNhC7?=
 =?us-ascii?Q?gQ+W0Asn3UQltseFOgnykbM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <105BEE8BFB98144F8837F3BCCDF21E1A@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 560a1a47-b29b-4826-d116-08da609dbc16
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 04:53:00.7452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LpFGiF82ewlwq+7Suo2PX0rwzBm260NCyJvADNRPKhGzQD4RmxupR2jfObVfe6pvCmy3Y6PzFIiFE60LUJQL8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2923
X-Proofpoint-ORIG-GUID: Mns6QwECa1Q8RmfSQaJOy771CG3XvdZR
X-Proofpoint-GUID: Mns6QwECa1Q8RmfSQaJOy771CG3XvdZR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_04,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 7, 2022, at 8:12 PM, Pu Lehui <pulehui@huawei.com> wrote:
> 
> 
> 
> On 2022/7/8 10:46, Pu Lehui wrote:
>> On 2022/7/8 3:12, Song Liu wrote:
>>> 
>>> 
>>>> On Jul 7, 2022, at 7:08 AM, Pu Lehui <pulehui@huawei.com> wrote:
>>>> 
>>>> Currently, when cross compiling bpf samples, the host side
>>>> cannot use arch-specific bpftool to generate vmlinux.h or
>>>> skeleton. We need to compile the bpftool with the host
>>>> compiler.
>>>> 
>>>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
>>>> ---
>>>> samples/bpf/Makefile | 8 ++++----
>>>> 1 file changed, 4 insertions(+), 4 deletions(-)
>>>> 
>>>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>>>> index 5002a5b9a7da..fe54a8c8f312 100644
>>>> --- a/samples/bpf/Makefile
>>>> +++ b/samples/bpf/Makefile
>>>> @@ -1,4 +1,5 @@
>>>> # SPDX-License-Identifier: GPL-2.0
>>>> +-include tools/scripts/Makefile.include
>>> 
>>> Why do we need the -include here?
>>> 
>> HOSTLD is defined in tools/scripts/Makefile.include, we need to add it.
>> And for -include, mainly to resolve some conflicts:
>> 1. If workdir is kernel_src, then 'include tools/scripts/Makefile.include' is fine when 'make M=samples/bpf'.
>> 2. Since the trick in samples/bpf/Makefile:
>> # Trick to allow make to be run from this directory
>> all:
>> $(MAKE) -C ../../ M=$(CURDIR) BPF_SAMPLES_PATH=$(CURDIR)
>> If workdir is samples/bpf, the compile process will first load the Makefile in samples/bpf, then change workdir to kernel_src and load the kernel_src's Makefile. So if we just add 'include tools/scripts/Makefile.include', then the first load will occur error for not found the file, so we add -include to skip the first load.
> 
> sorry, correct the reply, so we add -include to skip the 'tools/scripts/Makefile.include' file on the fisrt load.


Thanks for the explanation. 

Acked-by: Song Liu <song@kernel.org>

> 
>>> Thanks,
>>> Song
>>> 
>>>> 
>>>> BPF_SAMPLES_PATH ?= $(abspath $(srctree)/$(src))
>>>> TOOLS_PATH := $(BPF_SAMPLES_PATH)/../../tools
>>>> @@ -283,11 +284,10 @@ $(LIBBPF): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OU
>>>> BPFTOOLDIR := $(TOOLS_PATH)/bpf/bpftool
>>>> BPFTOOL_OUTPUT := $(abspath $(BPF_SAMPLES_PATH))/bpftool
>>>> BPFTOOL := $(BPFTOOL_OUTPUT)/bpftool
>>>> -$(BPFTOOL): $(LIBBPF) $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
>>>> +$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
>>>> $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ \
>>>> -  OUTPUT=$(BPFTOOL_OUTPUT)/ \
>>>> -  LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/ \
>>>> -  LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/
>>>> +  ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD) \
>>>> +  OUTPUT=$(BPFTOOL_OUTPUT)/
>>>> 
>>>> $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
>>>> $(call msg,MKDIR,$@)
>>>> -- 
>>>> 2.25.1
>>>> 
>>> 
>>> .
>>> 
>> .

