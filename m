Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A21552394
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbiFTSJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245064AbiFTSIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:08:36 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0643E180;
        Mon, 20 Jun 2022 11:08:34 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KFIDNN016653;
        Mon, 20 Jun 2022 11:08:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=BCjGVk63kkk1k86W3TygJ0WtlRxch+bQcTvlWEawgqU=;
 b=Y8+8qWIYnvO1wKxHNtESd/2TXWhGZVpyd8ihWVcJbd+U8i9RhrjoGSCbtprdLykEvgKP
 bMcJqH24iaIYVK1RjF4mj28B5o6erfRd5Hz+OMUXIlESxSgJBQha5fpn5FVRlvIWIxve
 2BypnySyvq1aAXppLjwv6hHpMtCrdTF/qco= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gsc7wtfjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 11:08:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/HGWTJ8T8VrDXKCohkAqkE0OdKI3BqT4AgqpCtAc7kxPEP3hPCexZxhe8/tE7Eram1erId3X4YNE0KOPXbqNQia0syq2C5t6+xhwN3UDaMzIfkv+8mOh3amev43qs3XjYYDIJBQFPW3Xl27aiCxwSDG7DTK368hOw6+xSKVY2LdzSlo+MPBgzV8TRLrdPIdqxG1+8yHIN+iVzQO5WvTyfTqrDWyw0xYBZF+jqwW7Je2qRZVRqTKt7eEtqg0o5U/gKM1G5wOecsJ4zVcW8Nsbzf1ZETGNnE7tASHxjpq0hiFu8DlK8vehQXiSL69RzvBvfio1A0fCVg7tn8iyCxcrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCjGVk63kkk1k86W3TygJ0WtlRxch+bQcTvlWEawgqU=;
 b=BAn2cEMhk3KiQKaT7HAlw04A5eEKLxBb/Gy52mQLUL+f1DyJ3bHZ87uUjC56D8iwvyd3zO/EXdTD6HCJ86Wsa7viXubLS12GwZorJlDTN1H0NZnEcFnbbCcaXVa5bnVNxuWcKvHdq09YvO31LHADKFvr9l2xdZUMimXQNbMvujzu9MiQXLlwQ758t/HtBQ+0noUL6JpWuKP+osqGvYMAvezjUFhEYDB/v/U35v25IFBXkoB2a+ZQj/gCHbwnkARrn0YDEQiL59t2SEI8s5XqvVMLtgB/ToYBT1uwEY53eNxtruGmwN7b8VUEaEcC3CeqkRALowGuha36eywjECXrgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BLAPR15MB3779.namprd15.prod.outlook.com (2603:10b6:208:27c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Mon, 20 Jun
 2022 18:08:10 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.022; Mon, 20 Jun 2022
 18:08:10 +0000
Date:   Mon, 20 Jun 2022 11:08:08 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     =?utf-8?Q?J=C3=B6rn-Thorben?= Hinz <jthinz@mailbox.tu-berlin.de>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 3/5] selftests/bpf: Test a BPF CC writing
 sk_pacing_*
Message-ID: <20220620180808.4a3saky4pd7ge7zn@kafai-mbp>
References: <20220614104452.3370148-1-jthinz@mailbox.tu-berlin.de>
 <20220614104452.3370148-4-jthinz@mailbox.tu-berlin.de>
 <20220617210425.xpeyxd4ahnudxnxb@kafai-mbp>
 <629bc069dd807d7ac646f836e9dca28bbc1108e2.camel@mailbox.tu-berlin.de>
 <e4390345-df3b-5ece-3464-83ff8c1992ce@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e4390345-df3b-5ece-3464-83ff8c1992ce@fb.com>
X-ClientProxiedBy: SJ0PR13CA0132.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::17) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a45f1970-80dc-4100-b575-08da52e7d5aa
X-MS-TrafficTypeDiagnostic: BLAPR15MB3779:EE_
X-Microsoft-Antispam-PRVS: <BLAPR15MB3779FB4E00A993846C3150A9D5B09@BLAPR15MB3779.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AV8+9p15QBhSHui1pKYtSjsaS23q+7MZE95XDmCfOMHIIdaaUhWJwiktT2AJQUTvkOEM/KTnZCaOVMYBS9u3j+dcnQENCeaNLfAMYjxL3UatdXjWl5TpSyDdD9KgwGjFjZ/B7kSPzzq8LcLTR+JibAg3k2VmIcEBOcoiVKaJdDn/dZjuC2uwGgtl0jpFoh55mlbLitY+BAYHxuv7TvigyVy+flnkiY5ZBI/aq2sx29Kb+fDfkm93kIN1d4ZQSCgPDDqpJMCktiOhASyYjpIsOvYjI6z6+AqwTaywHazzxJYJlK1BRe2sbOekn6cO2LtKVG7AGt56NMzE1sBOPe1U9b0IZMrcwBVJKGX6yMzhI2531RV42XZnXajCducphS34REh3JOPk9x+CqVdUSmDMByWZLjE3qm3ZfNhqTjdJLyfdbmT97UcCSwGwzLi1p+gfOF+wNhb0b1aXXdDlDpvf7rJ8f8hTXWmkVLNDEo/jkJBcK3+a3mufNvmiV8danTcKy/5+SNiLf6olbv33zytj2FjLPl77ma70QqmpWdTCGR7Fl8Hepe3cPggVkhuwVJN/w2HCD2x1xqyQXKNu1CCAPNriXERjMfJ74fAd3iGKKnGYiI7cSaw9ofboV7Nz31fB1rhVXIaHrVUQ+PcBWgg5eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(1076003)(186003)(6506007)(9686003)(52116002)(6512007)(41300700001)(38100700002)(86362001)(110136005)(8676002)(33716001)(8936002)(54906003)(6486002)(478600001)(316002)(6636002)(66946007)(2906002)(66476007)(66556008)(5660300002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clUrK1ZSK2EzKzkzaXNsQmdteHo3MTFWMGZrTlBJeXU4OUtMVldVVi9pZWh3?=
 =?utf-8?B?blluNXluS3pqeU1kc2tIN1R6RWtQMlJadVFwcm12cngyYW8zMkRCcmkrVjc2?=
 =?utf-8?B?eW0vMEpwWjduM0I1Q0k4RmlOR2dwaXVjS09hUDJkbXNqMmVCN3d3THdhMW9r?=
 =?utf-8?B?SEhIdndMTFRXSHptemVLMUcxOW9tVUt5eWJZVkFqWUxOejNaN1RjU3NmdHVM?=
 =?utf-8?B?L1ZJWk5kQnBYNDFOU1pMb3o4ZGRNbW9IWVFCcjUvRklwSXFrTUUvTXY0b1Jl?=
 =?utf-8?B?NEtGV1FIWnd3TVNZTFJYNmZ4ampGNGtReWhPMHFoZmF6bWROcjhTaGpCcjRB?=
 =?utf-8?B?TU1wVGk1RWZhbU9wZGtBbzdhWFU4MmdZV2RHdmJJWVZvTEt4bG5WN01pZ3ZH?=
 =?utf-8?B?cWJDbG1MVjQ4Y0wwZ05Cc0ROTUh4NEQrb094TEFMY2FZN0dpSVZDNU1XVnhl?=
 =?utf-8?B?VDc1dGdaeHNnRDRsN1VscmJwY0hsdjU4U2dpTmVyNS9tZDVLZ0RoUnUzZXBj?=
 =?utf-8?B?eHZ3U0JSR3lERU9QcDd5R0lDSTVOTkxoZHdMYjlOVlpoM2RINEZlSmhQZkk1?=
 =?utf-8?B?OWMzM3hWZ3kyOHE4VDBNLy9IMm9JZ3Jma0NsM2h0dll6V1FrMkZOL3B4SDk5?=
 =?utf-8?B?TmdwTzYwTDBrV1l1R3Y0UStRd1J4WWlCRkVJN2ZDVzJYSXIxOUlUWUVzTUpB?=
 =?utf-8?B?cktCbDlML2J3WUlDdlVhamIxWXRUZjFVZWo0akhEbFkwR004cGhHU0g3YWIy?=
 =?utf-8?B?WUVVc0IyWHZJdkp2aTdnb3ptNVRGZ2FSVjZmTkl1R0UyN0twT3AvcG1HaXlO?=
 =?utf-8?B?MTFyTHlkcXVXK2RDMXV1TWlEL3orV3FxV1Q1VzFobEo2Vyt0MXc3Y1FXcWxj?=
 =?utf-8?B?ZWlyYXpsV21mbStqYzRnTmtJTFdNZWYwTkh2aGxwSTV4UUNyanZqZmRoWkFu?=
 =?utf-8?B?YW52R0VPSFNMeFlrT1dnWk9UeUhYOW9TVll2T2N3N0s2UFY4QmdTMmV1aHQ4?=
 =?utf-8?B?L2NMd0tHdUxnenVCdGpoRVZIMEwrN2RUUGFheUtLbXYxZEZ2eGM5YmhSQzY1?=
 =?utf-8?B?bklFTFdFY3BIMngzRUZYRVVZdFlNQ2RyOHlxVGNaL0laQytGZTlpcFowSDc4?=
 =?utf-8?B?UzBXRjdUME9rQ0Z3TU5DYWxzYXBaU2w3RzExdG1vZEJnUGpqemhEaVlrSTha?=
 =?utf-8?B?NnA5dVhxcno5K2NHREpicis2UjkxQlUrWXR2cmlOUVFtU3J5Z0pJZEorZUFN?=
 =?utf-8?B?SklRTXIrOGJuS1kvUW93T1MvNlppWjlvUkNGTTZzSmdRSGwxVWtOdVU3TTFs?=
 =?utf-8?B?VEkzc0FNdU9nQkRMeFVDMzdQejZtUUVlYWtLM2Z5b2w3RG9kbWhwVkJxVDZ4?=
 =?utf-8?B?MFp0dzNwejYyOGhwS2lVbys4N3UzNExnWUhFeDBPMXJvQ3hMRXVZMmU5b1dr?=
 =?utf-8?B?dk82enVvdkxmNVdlOHAwKzZieWNxVWtxaG94RkNhUWZEQTUyU3F1VTZhZnJl?=
 =?utf-8?B?dXVaMDgzSEVmM2pRMzRmTEpTaFo2L1RKSHpYQ0lEVFAyZkFlRDd3eXIxaHN0?=
 =?utf-8?B?Vm00eDZ2SmFpOGp0dWVEYnZiWEFWaTNWb25xckkrV2R3dTJKTXJSQjRWQUtK?=
 =?utf-8?B?Uk9zUDdGcVpPcVRKMHRFVUdtWTJ2NDR3bnhKM1ZieUhrZ3JNWWhRUjlVMURa?=
 =?utf-8?B?ZGVyaTlPeGFXVzhDMVUyblYvc1EyMmpVQ3NlR2N3aWJkTmU2N0FlY3N3T21F?=
 =?utf-8?B?ZWlxbUoxaW5kVWQ1TGVTSERRa3ZQN1VnVGdocndqZXEyWTZBMGZ6Tm1lRVRl?=
 =?utf-8?B?N2JKRjdINjBRYUhheHh0bUU5VXhkR2wyT1FpNEZTeWNnSk55ZmxEaHI5ck9W?=
 =?utf-8?B?QWp3b2ZIeDYveHJrQWFDUm5obE8wVW1PYVNUZkk3T0hFOHFmaHZ1L1BtcjV5?=
 =?utf-8?B?S3cxTkJlWUNWcDFrOS9HMmZnUUI0LzFSRTBFUVdsQkFxOE8yQUtOVFA5cVYv?=
 =?utf-8?B?RTYzSStsN0hwcGdRR2JOUkVEMXpWcGRXSU1xZCtEMzJDbGdVSS9uRXY1aUR2?=
 =?utf-8?B?TzV4NnB3dHNIUDlGaTdITDdLQmFNMXF5L2hXSUVORjRLa2NPbGNoUHBjTjdL?=
 =?utf-8?B?WVUyKzUvV0o4akdZZW5leHlodXdUS0RlTlVtNXU2VU1DZ1Yrb3pKTnp0TjN0?=
 =?utf-8?B?Q3ZScnpLam9DaTlyTTd1VUtYSHoyWllEWVpFTVZTSWRCNnZsSmRvYVhyTmJH?=
 =?utf-8?B?VEN1ZjFBRGEwaVFSNUxUVy9rVWdDdVhxSHp2bVVBRW9ObjdLUkZYdUQ1Q1h5?=
 =?utf-8?B?ODZMZVREaTBMME9YVnFTQktkQnNFd0RGZDVZV2hvS0U1TUVSdTdxUlFuNU9r?=
 =?utf-8?Q?B55avcK5kpstOqFk=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a45f1970-80dc-4100-b575-08da52e7d5aa
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 18:08:10.3566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PKY2l1mevB3qa65pf5tLfS54FN+ud7uJT17TkAkIpKzautZOCL/z2wLRQ+9h2+xi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3779
X-Proofpoint-GUID: vkqlfvKpThLAqGEX6UUlAbsc1oF2hDKN
X-Proofpoint-ORIG-GUID: vkqlfvKpThLAqGEX6UUlAbsc1oF2hDKN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 09:06:13AM -0700, Yonghong Song wrote:
[ ... ]
> > > > a/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
> > > > b/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
> > > > new file mode 100644
> > > > index 000000000000..43447704cf0e
> > > > --- /dev/null
> > > > +++ b/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
> > > > @@ -0,0 +1,60 @@
> > > > +// SPDX-License-Identifier: GPL-2.0
> > > > +
> > > > +#include "vmlinux.h"
> > > > +
> > > > +#include <bpf/bpf_helpers.h>
> > > > +#include <bpf/bpf_tracing.h>
> > > > +
> > > > +char _license[] SEC("license") = "GPL";
> > > > +
> > > > +#define USEC_PER_SEC 1000000UL
> > > > +
> > > > +#define min(a, b) ((a) < (b) ? (a) : (b))
> > > > +
> > > > +static inline struct tcp_sock *tcp_sk(const struct sock *sk)
> > > > +{
> > > This helper is already available in bpf_tcp_helpers.h.
> > > Is there a reason not to use that one and redefine
> > > it in both patch 3 and 4?  The mss_cache and srtt_us can be added
> > > to bpf_tcp_helpers.h.  It will need another effort to move
> > > all selftest's bpf-cc to vmlinux.h.
> > I fully agree it’s not elegant to redefine tcp_sk() twice more.
> > 
> > It was between either using bpf_tcp_helpers.h and adding and
> > maintaining additional struct members there. Or using the (as I
> > understood it) more “modern” approach with vmlinux.h and redefining the
> > trivial tcp_sk(). I chose the later. Didn’t see a reason not to slowly
> > introduce vmlinux.h into the CA tests.
> > 
> > I had the same dilemma for the algorithm I’m implementing: Reuse
> > bpf_tcp_helpers.h from the kernel tree and extend it. Or use vmlinux.h
> > and copy only some of the (mostly trivial) helper functions. Also chose
> > the later here.
> > 
> > While doing the above, I also considered extracting the type
> > declarations from bpf_tcp_helpers.h into an, e.g.,
> > bpf_tcp_types_helper.h, keeping only the functions in
> > bpf_tcp_helpers.h. bpf_tcp_helpers.h could have been a base helper for
> > any BPF CA implementation then and used with either vmlinux.h or the
> > “old-school” includes. Similar to the way bpf_helpers.h is used. But at
> > that point, a bpf_tcp_types_helper.h could have probably just been
> > dropped for good and in favor of vmlinux.h. So I didn’t continue with
> > that.
I think a trimmed down bpf_tcp_helpers.h + vmlinux.h is good.  Basically
what Yonghong has suggested.  Not sure what you meant by 'old-school' includes.
I don't think it needs a new bpf_tcp_types_helper.h also. 

I think it makes sense to remove everything from bpf_tcp_helpers.h
that is already available from vmlinux.h.  bpf_tcp_helpers.h
should only have some macros and helpers left.  Then move
bpf_dctcp.c, bpf_cubic.c, and a few others under progs/ to
use vmlinux.h.  I haven't tried but it should be doable
from a quick look at bpf_cubic.c and bpf_dctcp.c.

I agree it is better to directly use the struct tcp_sock, inet_connection_sock,
inet_sock... from the vmlinux.h.  However, bpf_tcp_helpers.h does not
only have the struct and enum defined in the kernel.  It has some
helpers and macros (e.g. TCP_CONG_NEEDS_ECN, TCP_ECN_*) that are missing
from vmlinux.h.  These are actually used by the realistic bpf-tcp-cc like
bpf_cubic.c and bpf_dctcp.c.

The simple test in this patch is not a fully implemented bpf-tcp-cc and
it only needs to duplicate the tcp_sk() helper which looks ok at the beginning.
Later, this simple test will be copied-and-pasted to create another test.
These new tests may then need to duplicate more helpers and macros.
It was what I meant it needs separate patches to migrate all bpf-tcp-cc
tests to vmlinux.h.  Otherwise, when they are migrated to vmlinux.h later,
we have another pattern of tests that can be cleared up to remove
these helpers/macros duplication.

I don't mind to keep a duplicate tcp_sk() in this set for now
if you can do a follow up to move all bpf-tcp-cc tests
to this path (vmlinux.h + a trimmed down bpf_tcp_helpers.h) and then
remove the tcp_sk() duplication here.  This will be very useful.

> > 
> > Do you insist to use bpf_tcp_helpers.h instead of vmlinux.h? Or could
> > the described split into two headers make sense after all?
> 
> I prefer to use vmlinux.h. Eventually we would like to use vmlinux.h
> for progs which include bpf_tcp_healpers.h. Basically remove the struct
> definitions in bpf_tcp_helpers.h and replacing "bpf.h, stddef.h, tcp.h ..."
> with vmlinux.h. We may not be there yet, but that is the goal.
> 
> > 
> > (Will wait for your reply here before sending a v4.)
