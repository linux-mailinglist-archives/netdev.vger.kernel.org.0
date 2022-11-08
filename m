Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A202620589
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 02:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbiKHBDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 20:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiKHBDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 20:03:33 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AD31FCFB;
        Mon,  7 Nov 2022 17:03:32 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A80V6MG008279;
        Mon, 7 Nov 2022 17:03:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=oa/km0r3cwyfevpWQkWDC8u3M/DKojuu7uUnCY/pa18=;
 b=VfBhBp+JH5a7A5w3wVLXU37vKNY/9IAw5d2sknL8+8p2YtJTgxiV4PEq+e87QdPT18O+
 b5CJDUoNOzooWyPUOyBU+EEOjyLwuOhdaRFE8wbh0FeNH1kgCtVT/xMC/wi4xamV/EWd
 UnCRchPzcT+Mej9Ex79KT69gHA93rU/DZM9w4YmJUPWIEf+uqAJkK2Ca2uN2DQgteCsy
 tdAIOManudDhqySfW74AmThK4RqcqvgCR+04RZExOqGJ1iUffMeFl2K1+kFRXiKR8uxJ
 x/dVpT3tIN2iztaI9ao9xVKe8FkgzFdrhc52FO8vHp+VDAb9tBjOZmydzxX0XltWxdXd zg== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kqcmqr7hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 17:03:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzQGv0bzsKfVO7UaYcChfXMBwl4ZLi1pwSGBzdJGPdTCW22Id7nYqEamXAZbE90IdmPVzxjsO+ffNukWJrJ5gPkmbr9BwKriHW0UlI1zw6TgoZWTlrCSkfBCELdg5mZ2T2ufJMZ7/FYRE0PtOvMErfkhikiTaaQqmEaSOMkhx0QNdGf1B4levUa2ujiiFAnuapxUVLIMoj5VqpkPMolrxMiBX3EGYySB6VGcLXTc5Ux82PTqxGa2BCCbs38i6PaYv8nRfoFhhI8lFEMdBi7FDHQNe1sekKrcNjHtorPDvYh4CPOh0Ikm8occVyDOs4PclTxZ44N24aqYjAVP2B3iKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oa/km0r3cwyfevpWQkWDC8u3M/DKojuu7uUnCY/pa18=;
 b=QrbJexpRtUoNzyNSS4qE0w4IhpOmK1ny0H6isrqK0L+yGzjWASpoUxc9r6/gh0Xusy2mBRgGIh4ri4r8CikjTdwEc0oHG0lp5nKZV2o1FAnQs59wxOHdL6L1ufKQ5IJ+uDWss9qc60H3l3aljdxwsphymA2GRiBfvjrnpDWM/wbTPCfdzVzbsr5wlGC02eKAwBKv5G5fJlQR++d35PNJdyCJu4xwXjCh11BTQxtF/UVSjDBHDc9fb24E5d1qp/58215kklS+SycoyGcoK7idkbyG+hdB3GR6BZvFZ0CPkDR2g2yoIdg5E/Kczy/S23ugUdH1danMLVWYxO3tSdgLgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ0PR15MB5178.namprd15.prod.outlook.com (2603:10b6:a03:426::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Tue, 8 Nov
 2022 01:03:11 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3%4]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 01:03:11 +0000
Message-ID: <95ef48cc-fc12-74d4-702f-45754c508a85@meta.com>
Date:   Mon, 7 Nov 2022 17:03:09 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: Add hwtstamp field for the sockops
 prog
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
References: <20221107230420.4192307-1-martin.lau@linux.dev>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20221107230420.4192307-1-martin.lau@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0100.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::41) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SJ0PR15MB5178:EE_
X-MS-Office365-Filtering-Correlation-Id: eb5cfa8c-2f72-4dfe-6103-08dac12501dc
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VOzrSqZ1Tr/Hx7y129cIyQ+H9wYvPpe3RTmaFITjLc7GQ1Gh4xJl+i5JLmS+08o27M4XbpD0Ks1tID69yrrAirLi+9zixtkKYjIX9uZRYh6K9Cdm4ZKK9zWhv1UMzi3iW55gQntOjOCW013KpEuJT6Px9hI+2u6GISZ2GXz2Qy9N8CtWoNtirDgka/y9BccxL/6/m226yIkjh7KBoYuIwPJuUXVASJL4+5LkFYV+KR5MEuRZj01EdkafyJj1/JTBTjUJNkfUJ+vy1w315IAcNfuaVnJbZrbpY88BtiVh5ge7VV9+WdBnRAZbfXhNQL3ELncJzKgacHXhDvXzWKan/l1XtoMLHRL4O2ukIp0NaXdq4PCmz8t2fPsR41lcLZJEpvZEtKxqOSH53mdv8T30J1poLWVDCARY4Bg/F6XutqU8TG9fupt1H1AHAN7dnM1cIt7FjzBaGybkohvX8mbFEgDWySE+0v1iQ/cilcYYr5Yc6GrACIN0kbdm1Fo7ZBs8La9/96+Z+2NACjFBquATwSAdh3jItMawQzwGtZ6LSGpU3N4qHjQHP9hRPeKvZde/6azTp3mC7eo/Rwn/zX0zv0IPDsAHXaGPLEDiqlw944UmHbmW966pZkDrMLsH3bIhAFOgqnjNcooyH1dsFIKscxNU8oTmSLwGPfZQW21FKekhECoPzWBcb5k5+uT/QsEbjl5wM1W91GHg8F7UyMfGxVKQ3uAT/2Mp8935d4lMDpdutoFGyrcz6YBf8M4GVSB0uNw6TZyNOGgiP8bHSuttIXdWKdxEPCzBu8t2AnEvZAc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(451199015)(2906002)(66946007)(66476007)(66556008)(8676002)(4326008)(83380400001)(6506007)(53546011)(107886003)(478600001)(31696002)(86362001)(6486002)(186003)(2616005)(36756003)(54906003)(6512007)(5660300002)(38100700002)(31686004)(316002)(8936002)(41300700001)(4744005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVRmZFcrdkdEdW9EK1ZGNkc1bVNOTC9QWG00ay9INUF6RXFwR3Y0dXFoR1lq?=
 =?utf-8?B?QzNzWkIzY05icWJzS05CbExLN0REVlNxZGN0d2cvKzZRU2FPKzFBR3haWmUx?=
 =?utf-8?B?ZjBIcHM0OFZ3cDcvUk5XWlZGRnhsVlloVk5kS010RmpLdm84OVVMRGZLbnF5?=
 =?utf-8?B?SGlsZjB2YzF2cmIySVRYV21qNWg4dzRyZUNKTkdIcHRkYjZiYmNGVXczUkla?=
 =?utf-8?B?QzNFeVQwQ25GaHJBaHU3allCcHJpYXpjcXh3aHdvMG5zT08xVlhMNW5sdWU2?=
 =?utf-8?B?MVorRkRGRlpzREJPUkFOWWZhTVMwNm5LeTJNYllpaFhWK01Za01kUmYrZFEv?=
 =?utf-8?B?RXorN0JMbStsWWZmV3p5ZFUwRktPR2Fldk55Tnpkd0xLYSszbGRsdXY2cEU1?=
 =?utf-8?B?ai84dVJ0eGZMT2N2UGpEUVBrbktuM2dlWXBOR2R4ZUV0d0VHbjZxTnBNcnF1?=
 =?utf-8?B?cHlkbkVkVXVyUG44Y3pZdW5oOHhRbHh3ZFBibm94RW01TkVGY1RZbUczcFN5?=
 =?utf-8?B?ZVdlWWJiTElYdVYvcTZwSXFJZTBMZ2luQTVHQ2g3ZXZ6YlhSOStyQ1Rod3J6?=
 =?utf-8?B?L3hCLzVmVGRGUjhiSlUySWVWdERtQUcvV1V0TS9nRXpIOHB0T1VYK3M3bE5s?=
 =?utf-8?B?dlhrNEtNZFVETk5MaTVMVmYyd0xYRm9kOERZeW9NUVQ0WGNER1RtNHkwQVZo?=
 =?utf-8?B?Uk1GVGoxUzBtU21nNTVFb1dyWmxyZlEvaUs2bGpnc1lQNU1LNGZRMUdGajZV?=
 =?utf-8?B?YkxwU2hJMXFJbzU1Rm9DZ2xxNEZmaEJneG51ckd3cW1TRzV6L1M2ai9WTDZa?=
 =?utf-8?B?UkhVbXJZV0JvOG02aDZBTVRrbUJhbFZKZXBZelZiNzlWOHp4NkUyaVJVVVpP?=
 =?utf-8?B?K3M4SUpWQ085Mjh1TzZ5L3NEZWFDUG11aHE4UTdtTVF4OVNyZy94SXhIOEMx?=
 =?utf-8?B?VnpEeCt5TFpnSEtISWkyZVUrVHo2UVBwc3BLdUpjeDlqOXh5cHMzTi9vamZk?=
 =?utf-8?B?Q3djVnhTKyswRkpyZjU4emNXaVJxaXdRTWZ6VmtPYy9KanRaUzBJUC83R0I4?=
 =?utf-8?B?bFV5R3R0RFdaWmFYK2JYTVROeUNBU0NYTmprRDJjTDNZTDhTUS9FM3dEeHUz?=
 =?utf-8?B?aldTSzY4MDV3eERwNUI0T0tIdVZUMklyR1dGS2x0Y2t4NGwxOG5DK0lNa0o1?=
 =?utf-8?B?RHlObFdpK0FjUkt2bzFNOTR2SHFVTmFyU0M3TzZ2WjUwTkQ5QTlrMDJod01G?=
 =?utf-8?B?dXlxNy9PcVptOHZLS3Fnb0pMZXZhVDdteFdhM0JtdFVUbVR0OUpOZzl1Y1JO?=
 =?utf-8?B?YXR1VGtxWHBMS2pzVjFqM3FPM3JuZ1QwMDkxa0x1V0xrRVJubDF6WTNKWlF2?=
 =?utf-8?B?SkgvMllVMDdKQzdSbmVpemZqbS9EUS9CMW1ITEtzbW9JM1R0MDBYeUIwb2Jy?=
 =?utf-8?B?ODBMcm1iaDFOQ0c5OUs4NC9MSzNXTjJCQjFnQ1ZnMjJKcmZvd3JyQUVzTjh1?=
 =?utf-8?B?a0RuU1lITjlRR1RMMHJYL3kzYmMwT0l2cUI4MzBjTy9NUStsOHF5Wm9aUUll?=
 =?utf-8?B?dHg0VW9pVDVnMzFYVW0zRkNHNmJDU2NBMUkyK0R6bkkvQmVJR0EyMmtYNEFL?=
 =?utf-8?B?R1FTWW9RV1lIRFFiZi9OYWVJUTFHM01vbXo1R2FiVThabFl6L0JMM2YvOEpG?=
 =?utf-8?B?T20wbGlsSnNzSzNaU1JlUm9abGtsWlVuYjBXaWt3QWRCNk1VblF1V09JK0RL?=
 =?utf-8?B?MzB1cHRaK1dPeXhBb3pRM1N5TnJGeFpSMGRSSk91aEhTM2dvYWhwY21idjRu?=
 =?utf-8?B?OWNtUlFya1VPWWU4blVDdE5oYkowVGhXSWRxeVl4cG9yMEJHTnVKOEhINjlu?=
 =?utf-8?B?ZmJ1dXl0RjdxTFhzV3ZGeEdCUDI2THlaOXQ5Uks1c1hwTlZyUHd3QlQrRXJY?=
 =?utf-8?B?WTFVZDQveHJSUTdqRGpmVExhL0pHbE9PcE9yUEFCZzNvajZGcGpBRjFmQzlG?=
 =?utf-8?B?aUdmZlN1YTZPUEY1MVFQTmFXRHYwUTdRLzJiMVZaem5zM1d0T3huZVp1TTd4?=
 =?utf-8?B?NFZMbFZWbDk1VjIrV0kvelBxVHRkMlYydWp3UDdSNnBMQlI1eUdlNm5nMU42?=
 =?utf-8?B?RUFNV3pFNlVScFpxb0hDKzZDRVcvbmQ5NEIvK1VEUm4vZXBKV3VhUDVaUGlR?=
 =?utf-8?B?Y3c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb5cfa8c-2f72-4dfe-6103-08dac12501dc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 01:03:11.7392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pHbz8SR6RN+cwQZO287Ey4erLH2rHgo/SqJUMCOK3m4MAPv1rw/d9pXT2eGrtjcH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB5178
X-Proofpoint-GUID: A4sf3kmv_ApsdOjs2wFzrRwdLOCmuXuN
X-Proofpoint-ORIG-GUID: A4sf3kmv_ApsdOjs2wFzrRwdLOCmuXuN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/7/22 3:04 PM, Martin KaFai Lau wrote:
> From: Martin KaFai Lau <martin.lau@kernel.org>
> 
> The bpf-tc prog has already been able to access the
> skb_hwtstamps(skb)->hwtstamp.  This set extends the same hwtstamp
> access to the sockops prog.
> 
> v2:
> - Fixed the btf_dump selftest which depends on the
>    last member of 'struct bpf_sock_ops'.
> 
> Martin KaFai Lau (3):
>    bpf: Add hwtstamp field for the sockops prog
>    selftests/bpf: Fix incorrect ASSERT in the tcp_hdr_options test
>    selftests/bpf: Test skops->skb_hwtstamp
> 
>   include/uapi/linux/bpf.h                      |  1 +
>   net/core/filter.c                             | 39 +++++++++++++++----
>   tools/include/uapi/linux/bpf.h                |  1 +
>   .../selftests/bpf/prog_tests/btf_dump.c       |  4 +-
>   .../bpf/prog_tests/tcp_hdr_options.c          |  6 ++-
>   .../bpf/progs/test_misc_tcp_hdr_options.c     |  4 ++
>   6 files changed, 43 insertions(+), 12 deletions(-)

LGTM for the whole series:
Acked-by: Yonghong Song <yhs@fb.com>
