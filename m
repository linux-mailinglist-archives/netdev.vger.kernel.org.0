Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47B752C2EC
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 21:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241706AbiERSzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 14:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241698AbiERSze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 14:55:34 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403B1230200;
        Wed, 18 May 2022 11:55:33 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IHDVUo014469;
        Wed, 18 May 2022 11:55:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Y4fXA3SqzN/AtYvCKUWjmfX9QgZiDHvvv+NW5g+TU18=;
 b=eVpZiByMARwEkKNWlglyOv3JRXBUGOJN3MXf6Pk9y/6Ok5SbZdUeJ36SGa3rpncGL5Yh
 qWEPwlHLXj2OWzuYPVDD7y017RsV7mvjGH+6JIfC0luBrV5XNZXyLtY53ezud1I4Coyk
 sRURtbAFflrb8pqIw3izNFbU3YqQxJdLzuA= 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2176.outbound.protection.outlook.com [104.47.73.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g3yq0efn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 11:55:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SgUOkrh2ZSjepNOOu+784zQR87Lgv2Ny3iDB6mwkbHBSsjkdxnEfZnrrdbrop6fMdkk8W7H5kfX+7yr1HmRPCA+zcmQ6/i4ZdXQFXpKebt6txrDSs8LIdW4tZHSCr9Vqi+czco1ooN2+jM9880Yk1gkuHO8nL0BpTCkeV9K9aJj20KYCD9N14a5CGzNx3wTezD+jQjMasMTSlwxHLZL/cZo22jw4c0bK7BrTU1g8ECTcuZvH3E478qukvAcDpVJEvFtaf07jy5xom6HX3LqynyltQda3AU+/Cxw22+B/X5xtyiqhYBZHe48LcqRDwgUfv7xhFyQ31F8FEi0bD1Nu1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y4fXA3SqzN/AtYvCKUWjmfX9QgZiDHvvv+NW5g+TU18=;
 b=XB8/b+fRe+pSPB0i+c762716X0gyUpSBU2ifNGcKMt9KkiR3p3E0U4EgKRYHnvqiv4pdLdYamm92PZploetB+J1M4pbIFdJWN2o1EMeaOMwvraM9WjltoBjTQ9bvxrYXWaSU3K3ogJcSPIFn5oErE1BiDIkFZEmTV8pRP3cacGR1rdTE8mJIxTYCXKZF6xXD+UAMUr1P/LH/ghJzIOCR/HTsSt/kEjHwoXI7gJOprfUEIj62WuCx4A1Geyw5Hb1siOtQ8XiNe0AQ/2pLBIfe3byAhtPG6VehscBPcOEOb/LebEKTypVg4VlG1zPwgAfzKtNXiirbhVq3ofz0N4E7NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN6PR15MB1698.namprd15.prod.outlook.com (2603:10b6:405:4f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 18:55:05 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 18:55:05 +0000
Message-ID: <1e426140-d374-5bfc-89f8-37df9ead26ba@fb.com>
Date:   Wed, 18 May 2022 11:55:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v3 bpf-next 5/5] selftests/bpf: add selftest for
 bpf_xdp_ct_add and bpf_ct_refresh_timeout kfunc
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
References: <cover.1652870182.git.lorenzo@kernel.org>
 <e95abdd9c6fa1fa97f3ca60e8eb06799784e671a.1652870182.git.lorenzo@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <e95abdd9c6fa1fa97f3ca60e8eb06799784e671a.1652870182.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0170.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fec70019-5464-49bb-4277-08da38ffec13
X-MS-TrafficTypeDiagnostic: BN6PR15MB1698:EE_
X-Microsoft-Antispam-PRVS: <BN6PR15MB1698EABD04D88CE5ED5F2702D3D19@BN6PR15MB1698.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: We9NRwQ3O2vIqk/FiYv5xmfsimGq/sEZ4fUUWYxLnV0hS5oHOTdiA3+0ahf16LPo5RhSuQg+wHWYwH9ftuBsQCmaDH0H/R2AxbCQJDRk1ZEmFooUw2eVWeB9gLcuPV5fgoQpApRTYwxWjLM+kF4lVhyrmhVl/gM/go4ImlKXw9tA5GsFd+45MnNZ3f/JwdcCA/sT6p2Z7GAaP8zDBhsy19UA9LNK64diXIy8fIMU1Sx8uChXxGfNDjwc8AD4z0uluF/Hsk8bG5A2toTvAhDF8RfG6j8TFkywaZFYrr+D6Z+ai3NKPGgnGijgH9c+6IDqxuTZSrsjP54dEzcMVqaQjgq/mTDhuJ7tGelggIeicvzEq4frbB6AMHpDCABpm0lcVg/DDvG00oNUYHFSE/eF1Er8lVZhWRjHgyMoAEtm1FmUlRkef3xhA641prBZXgHzODq2oBeGua69A8qMID1uCDWScRobHHPz5dtLhkHGhH9rC+2y4Y/zoQtQogZdpD/AHW9LLDOVxBuW4Fnk7PTwe4VaMgFtNpta4f+yTbIUpF84WLrA4P7vDyY1N41v7u4C5lFiOY/P0LksQpd14TVNvXp7UvP6RbkxwG/3jWfr68tFX8T0oDUksj+AbsePgl/7IZqAp91lDyfW2ZANN45MxwWlRVK8zQMvrvppm8LGl7co7vXMMhpgnVDWtbSCt78M4pMiL5QxBGEs2CotV4pTa1VKev7Y605lzzk5XxDrZYqT3l1GPvx5Ocrxx59/X+x/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(2616005)(6512007)(6486002)(508600001)(186003)(52116002)(53546011)(6506007)(83380400001)(4326008)(36756003)(31686004)(8676002)(316002)(66476007)(66556008)(66946007)(86362001)(31696002)(5660300002)(2906002)(7416002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmNJcXhGQmFoa0g0Z2l5U0NoZkVtQmt4TmtWdVNwaFpwWVdCSGZIOERmSGsz?=
 =?utf-8?B?MU9PSmJtZDNGdTA2d1ZNVUJoTW1TV0s2Y0FwRUJVQWNCN3dkcUFlM3JPR1kz?=
 =?utf-8?B?WThJaGJtKzFxYWZqbzAwSmJSUXZOTWM2NmhSaHRnK3pDSGlhalpzU2xVbzZo?=
 =?utf-8?B?a3VZY2pCd01RVkgxYXFtRTRIUjNVL2EwNE4vamluYlR4bDZVdTB6UDVVbU93?=
 =?utf-8?B?YzdjR3ROQnpmdTZpY3lSeHl5WlVZZ3o3dlFWRi9oYkxVWEVQWExwSVp3MnFW?=
 =?utf-8?B?RzYyeHg1L1RkOE1GV21zaEo0bHVGb3hIUjVFTzJ0KzE1TFAwNkVVamdadGtO?=
 =?utf-8?B?QkEyYzgxck11bitvanZOSk13cDRGYmlXSSs3amNWTGxMWHpRWVQvZDNZdm40?=
 =?utf-8?B?UTQyUHNTcHltWk8wR2I5TlYxOEtadWJXRitBaXh6NFhOSkZiN25IYTEzNm9Q?=
 =?utf-8?B?eHdFSzBQWmNrWWNlYUZGREFoWi96TFk4TjBLelBJcVAyZU5GeUJMS05zc09V?=
 =?utf-8?B?NTZYM295Z3M3YlpIL1UrUS9wdHhLcVRiRVExT2tDTXNmdU0wUXJGREJ2Y0Z6?=
 =?utf-8?B?eW1uU01td1ptODFxQUltb09hZ0NoVFZhQlc4bVB1WG4xbHNyTHNLTTVZOEJY?=
 =?utf-8?B?OGM2c3dvNUFxdFlhQ2xXZnBiMDZsQitqMmFTaXM4WTJGUUxtU3ZIMVhQckpL?=
 =?utf-8?B?SzdMOUdoV1ppcFNPbm0vZFhvQStXcGZUKzNiMnEyN09MMVRCTTVEaFFid3A4?=
 =?utf-8?B?ZmpqdDE3SjhEVXVWUnNETzZkZTRRYnhPSXhXQTUxNFNGM080eU93U1BuT1dL?=
 =?utf-8?B?RkdXNmtCRlVpK2VaM2VXcHFZMEs3eGdMSUVSLzR1UkNFU0crTmdxMTlqaWsv?=
 =?utf-8?B?L0UxKy90WkxIT0pNWDhoY0xscEpWUlc0VDF6dmhZb3NlUlpSZ0Q2NnRGN1Y3?=
 =?utf-8?B?RHlCMHF3NlVhcGVPa25FemVER001cjZISW1vVFJWR1hsMkZGN0lRUDN0b0Z4?=
 =?utf-8?B?aXVOT3RYbmE1QlRvZFFkRkhSbGNKS215dG1Dbk52VVRZL3Y4a0psSzJxcDU4?=
 =?utf-8?B?TlJEdHVsQnRVVnNYWjNya2svTTRoS1QyeU9PU2RoQlJRVWh3b0NIVlZUWm8x?=
 =?utf-8?B?aUd4UXhQaWZCZWRhVWs4aTg4aFcxQjZDbmpTUzIra2M2bkIweWxyaUdVRThQ?=
 =?utf-8?B?QzFsZURmQnI5TVE3c050MDBjMHdPTnlHeUo3RnNRM0tmaXN0TFA0VW45NFox?=
 =?utf-8?B?MGR3Sm1CM001WDhtRko2Y3BMNlI1eFRTUHJYMEJmd1Y1dXFUUXlWN1FrWW1u?=
 =?utf-8?B?djlXL28wU3R3SUI1WXE3NkxjTWhpVmljc201T1pDdkFpMXJwUitWd2NOYzg2?=
 =?utf-8?B?WE5wNjVDTFBHNkdYTHJJVlhMcm1jd0dOMXRid3pMc0hPRHpUOTl2Wk5JVmtR?=
 =?utf-8?B?cExmU2cySHBIeCsrWUF5ZzdCd2I1eHMvZWp3TmM0M2hkTGJ6bGZlK1JRcFUz?=
 =?utf-8?B?UWYwT3V4RWE5dHg2RU9ObjYrSlY4Ynlta1lNWTg3TUkwQVI0eDk1K3dZWld5?=
 =?utf-8?B?Nm1NOUNmNTl6Z3BzbDlCeUJJZ1NwWlFPS1cxQkxBVWNodjM0dTRLNm9WVlE5?=
 =?utf-8?B?dEpQcGF1MFJVVzhWU3VnY2NvNmlERlBvVDJtUXpQaE43dGNXN2ZBZnFCMkFF?=
 =?utf-8?B?NWhaV2hXdzRON3NNVnFrV25kTzVvdmhaT2xnalhNVnlRUUZ3dTQrcWR5bVNl?=
 =?utf-8?B?M0wwVHB3MUJiUEp4SlBMYUhIY0JRNkxSVmN6bWIxNnJPK29VUG9PNk1ZMU1P?=
 =?utf-8?B?MFFLQ0Z5SzhXNDJlZlNrWjlGSUVGQWx1bXJaeDgvZzIrUFRhdUllNVZibnU1?=
 =?utf-8?B?enBtL3d2QXl3TSt0bVhJaUw2Q2w5Tkw3T2JlN21NME5jWjdNL1cyb2wzd1VY?=
 =?utf-8?B?VWo3MzBId0tRbVFtUFp1TUNvZk1WTnkwWHhEeDdVcGpOei9IeXhUbkxRRWNC?=
 =?utf-8?B?ZW9lc2VKQ0tPSW9KT3FBNG9ydTkyWk9OWlo1Mi9aRm10eFpyWG11MVpqU2FC?=
 =?utf-8?B?c1Jjcm1DQUNDV2YxRWwvNXQ3OHZsZDN3ZEUzZDFqckh1NElndGlaWmpaQUFs?=
 =?utf-8?B?UlkzejJteWZDSlJQVjBkNTNYcy9KNFRGdDEvb204SXhXU2ZIK0hvNVd4NkUv?=
 =?utf-8?B?NWpwY2pzNzBpOWJkWm1BbzJHdXZISUVmNGFtbm5YRUI0cmNueXQ3MEtUcFZ4?=
 =?utf-8?B?ZHJvSnRGR0IraVFSMkd0b0R4M3pDN2lpSXZsU1BIMUdVVTdwSk9QTmd5U21h?=
 =?utf-8?B?VG9jRWRqNW80cHl2aWZqU09qOGZ0T1J0QzJNZDdzM3hpRXpRTlZpYTNqWUpo?=
 =?utf-8?Q?K++k+OSLlmTKbnP4=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec70019-5464-49bb-4277-08da38ffec13
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 18:55:05.7191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s3Nsanq+Y+l2eLUOzwRmwNPRqX2rjgpfqSAXpAePCRFLPpT8WZ+OhQsVj2hQrbL2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1698
X-Proofpoint-GUID: F43r2SXnI1ZvXNR2tEjbqqylCtw66vu_
X-Proofpoint-ORIG-GUID: F43r2SXnI1ZvXNR2tEjbqqylCtw66vu_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/22 3:43 AM, Lorenzo Bianconi wrote:
> Introduce selftests for the following kfunc helpers:
> - bpf_xdp_ct_add
> - bpf_skb_ct_add
> - bpf_ct_refresh_timeout
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   .../testing/selftests/bpf/prog_tests/bpf_nf.c |  4 ++
>   .../testing/selftests/bpf/progs/test_bpf_nf.c | 72 +++++++++++++++----
>   2 files changed, 64 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> index dd30b1e3a67c..be6c5650892f 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> @@ -39,6 +39,10 @@ void test_bpf_nf_ct(int mode)
>   	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
>   	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
>   	ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT, "Test EAFNOSUPPORT for invalid len__tuple");
> +	ASSERT_EQ(skel->bss->test_add_entry, 0, "Test for adding new entry");
> +	ASSERT_EQ(skel->bss->test_succ_lookup, 0, "Test for successful lookup");

The default value for test_add_entry/test_succ_lookup are 0. So even if 
the program didn't execute, the above still succeeds. So testing with
a non-default value (0) might be a better choice.

> +	ASSERT_TRUE(skel->bss->test_delta_timeout > 9 && skel->bss->test_delta_timeout <= 10,
> +		    "Test for ct timeout update");

ASSERT_TRUE(skel->bss->test_delta_timeout == 10, ...)? Could you add 
some comments on why the value should be 10. It is not obvious by
inspecting the code.

>   end:
>   	test_bpf_nf__destroy(skel);
>   }
> diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> index f00a9731930e..361430dde3f7 100644
> --- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> +++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> @@ -1,6 +1,7 @@
>   // SPDX-License-Identifier: GPL-2.0
>   #include <vmlinux.h>
>   #include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
>   
>   #define EAFNOSUPPORT 97
>   #define EPROTO 71
> @@ -8,6 +9,8 @@
>   #define EINVAL 22
>   #define ENOENT 2
>   
> +extern unsigned long CONFIG_HZ __kconfig;
> +
>   int test_einval_bpf_tuple = 0;
>   int test_einval_reserved = 0;
>   int test_einval_netns_id = 0;
> @@ -16,6 +19,9 @@ int test_eproto_l4proto = 0;
>   int test_enonet_netns_id = 0;
>   int test_enoent_lookup = 0;
>   int test_eafnosupport = 0;
> +int test_add_entry = 0;
> +int test_succ_lookup = 0;
> +u32 test_delta_timeout = 0;
>   
>   struct nf_conn;
>   
> @@ -26,31 +32,40 @@ struct bpf_ct_opts___local {
>   	u8 reserved[3];
>   } __attribute__((preserve_access_index));
>   
> +struct nf_conn *bpf_xdp_ct_add(struct xdp_md *, struct bpf_sock_tuple *, u32,
> +			       struct bpf_ct_opts___local *, u32) __ksym;
>   struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tuple *, u32,
>   				  struct bpf_ct_opts___local *, u32) __ksym;
> +struct nf_conn *bpf_skb_ct_add(struct __sk_buff *, struct bpf_sock_tuple *, u32,
> +			       struct bpf_ct_opts___local *, u32) __ksym;
>   struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
>   				  struct bpf_ct_opts___local *, u32) __ksym;
>   void bpf_ct_release(struct nf_conn *) __ksym;
> +void bpf_ct_refresh_timeout(struct nf_conn *, u32) __ksym;
>   
>   static __always_inline void
> -nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
> -				   struct bpf_ct_opts___local *, u32),
> +nf_ct_test(struct nf_conn *(*look_fn)(void *, struct bpf_sock_tuple *, u32,
> +				      struct bpf_ct_opts___local *, u32),
> +	   struct nf_conn *(*add_fn)(void *, struct bpf_sock_tuple *, u32,
> +				     struct bpf_ct_opts___local *, u32),
>   	   void *ctx)
>   {
>   	struct bpf_ct_opts___local opts_def = { .l4proto = IPPROTO_TCP, .netns_id = -1 };
>   	struct bpf_sock_tuple bpf_tuple;
>   	struct nf_conn *ct;
> +	int err;
>   
>   	__builtin_memset(&bpf_tuple, 0, sizeof(bpf_tuple.ipv4));
>   
> -	ct = func(ctx, NULL, 0, &opts_def, sizeof(opts_def));
> +	ct = look_fn(ctx, NULL, 0, &opts_def, sizeof(opts_def));
>   	if (ct)
>   		bpf_ct_release(ct);
>   	else
>   		test_einval_bpf_tuple = opts_def.error;
>   
>   	opts_def.reserved[0] = 1;
> -	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
> +	ct = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> +		     sizeof(opts_def));
>   	opts_def.reserved[0] = 0;
>   	opts_def.l4proto = IPPROTO_TCP;
>   	if (ct)
> @@ -59,21 +74,24 @@ nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
>   		test_einval_reserved = opts_def.error;
>   
>   	opts_def.netns_id = -2;
> -	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
> +	ct = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> +		     sizeof(opts_def));
>   	opts_def.netns_id = -1;
>   	if (ct)
>   		bpf_ct_release(ct);
>   	else
>   		test_einval_netns_id = opts_def.error;
>   
> -	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def) - 1);
> +	ct = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> +		     sizeof(opts_def) - 1);
>   	if (ct)
>   		bpf_ct_release(ct);
>   	else
>   		test_einval_len_opts = opts_def.error;
>   
>   	opts_def.l4proto = IPPROTO_ICMP;
> -	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
> +	ct = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> +		     sizeof(opts_def));
>   	opts_def.l4proto = IPPROTO_TCP;
>   	if (ct)
>   		bpf_ct_release(ct);
> @@ -81,37 +99,67 @@ nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
>   		test_eproto_l4proto = opts_def.error;
>   
>   	opts_def.netns_id = 0xf00f;
> -	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
> +	ct = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> +		     sizeof(opts_def));
>   	opts_def.netns_id = -1;
>   	if (ct)
>   		bpf_ct_release(ct);
>   	else
>   		test_enonet_netns_id = opts_def.error;
>   
> -	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
> +	ct = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> +		     sizeof(opts_def));
>   	if (ct)
>   		bpf_ct_release(ct);
>   	else
>   		test_enoent_lookup = opts_def.error;
>   
> -	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1, &opts_def, sizeof(opts_def));
> +	ct = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1, &opts_def,
> +		     sizeof(opts_def));
>   	if (ct)
>   		bpf_ct_release(ct);
>   	else
>   		test_eafnosupport = opts_def.error;
> +
> +	bpf_tuple.ipv4.saddr = bpf_get_prandom_u32(); /* src IP */
> +	bpf_tuple.ipv4.daddr = bpf_get_prandom_u32(); /* dst IP */
> +	bpf_tuple.ipv4.sport = bpf_htons(bpf_get_prandom_u32()); /* src port */
> +	bpf_tuple.ipv4.dport = bpf_htons(bpf_get_prandom_u32()); /* dst port */

Since it is already random number, bpf_htons is not needed here.
bpf_endian.h can also be removed.

> +
> +	ct = add_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
> +		    sizeof(opts_def));
> +	if (ct) {
> +		struct nf_conn *ct_lk;
> +
> +		ct_lk = look_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4),
> +				&opts_def, sizeof(opts_def));
> +		if (ct_lk) {
> +			/* update ct entry timeout */
> +			bpf_ct_refresh_timeout(ct_lk, 10000);
> +			test_delta_timeout = ct_lk->timeout - bpf_jiffies64();
> +			test_delta_timeout /= CONFIG_HZ;
> +			bpf_ct_release(ct_lk);
> +		} else {
> +			test_succ_lookup = opts_def.error;
> +		}
> +		bpf_ct_release(ct);
> +	} else {
> +		test_add_entry = opts_def.error;
> +		test_succ_lookup = opts_def.error;
> +	}
>   }
>   
[...]
