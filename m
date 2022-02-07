Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7944AC873
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbiBGSWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 13:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239549AbiBGSRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:17:32 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1940C0401D9;
        Mon,  7 Feb 2022 10:17:31 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 217H9aex020908;
        Mon, 7 Feb 2022 10:17:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=hUaFnvivYwaThXya2RDo6qokhj4BNqGfojzv6SfiUCE=;
 b=oZCxR1IXRalZ7bldbMSTsTH2Nfd7cHk2NLpkCcDhyWgnhhSrV8MeWKrjWXkdlkO0vjbn
 DHc6vt6AXKWJHp2UeRT+KarLmF1tGeoUhF+q9MH7pewKXnQg9t4xebMckFE0/O46cNFx
 Vtz80dod5p0E0KZqufSkkTgWVNETTiw/lg8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e36b5h7rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Feb 2022 10:17:06 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Feb 2022 10:17:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SswYev/GZYm+MC4pe1DN+R3gkOoA5AGRLdtXhX1bJsCCqzm/0Di4Zbfs2A4oRBk82uvxz+5PUqtbFQ9QjZ1iWVcZl0S6PGy7cc2mNLi2hvzSqBev2U3rzOCFetw+dmqmpvF/XYljBydStaFMvvtr4nRskBQ09MBrxOUdt5JNGORqiIOG+NhwSvhq0cEHlOcEz8hq85Is3zDW5rnZag5/ouSU6kgmPnRUQdEkN9u/gFVvejqHqXjd3byqe/j3x+FTtaQRetiqt8g1rm/7ftZY+sSXMJ6wfTBA7zfLJlvxjUWnMdW+zZP+CGUWEa8OV29hc2QJXY8usEm3RD3n/GGAZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUaFnvivYwaThXya2RDo6qokhj4BNqGfojzv6SfiUCE=;
 b=nkIB+4aekabV0r7o5G3tWdkbDVDkrHyUFsK/cfgLWseI9Cvt2hw2KNcSb314vaDoXwgqr5U8853WZJL9fVQNx2Wq1UtmjN10r0eUVlq205Fv7MDlcUGesGtgDIjUMRmDb02978u0KTZ2nPI5XH33t0T7k615HZoBs0xapzZHeOyBWtkbtQs0YyC6PVHQQ0TRDHN/jP+2S4/judpmDyTNYtl3vFWRQqb6zW9o8Z/2YnwKx/I8G7nXre7jdZux4oLlDpWiYysb5s5gUnMQrvseXHZjCkpDpRq/A3vsrRzRMVnBvRuLAib7t7B3xYvpx8VqYiHkdtOIUyMrkqMVNCRxUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB4284.namprd15.prod.outlook.com (2603:10b6:5:1f8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Mon, 7 Feb
 2022 18:17:04 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0%6]) with mapi id 15.20.4951.019; Mon, 7 Feb 2022
 18:17:04 +0000
Message-ID: <bc45d372-91cf-a909-aa8b-4daa755e758f@fb.com>
Date:   Mon, 7 Feb 2022 10:17:00 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v4 1/2] selftests/bpf: do not export subtest as
 standalone test
Content-Language: en-US
To:     Hou Tao <hotforest@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
References: <20220206043107.18549-1-houtao1@huawei.com>
 <20220206043107.18549-2-houtao1@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220206043107.18549-2-houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR19CA0051.namprd19.prod.outlook.com
 (2603:10b6:300:94::13) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c9ff4af-de8d-4134-f1cc-08d9ea660af1
X-MS-TrafficTypeDiagnostic: DM6PR15MB4284:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB4284F019FC590CE90D378E1AD32C9@DM6PR15MB4284.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bRCh/42ATiJFRhq5tumszCIGm9HaJvXgc/WuwBfG945gkOUp6vuBDHvOV4GkQw5ZO74VUCgznhSEUEUsFh20xbFaYxtlpLvRYf+VydhuWvrz0XS1hyzRJQA85fDQmp41chTuQbKRHpkcs9X7EhxITCJK42uNnf8fqcTZ+75PJ9P+r3VyDX32m/fYAI3fMxc2q8bUhI4RW0eVwvhN/N5eez+PYzkzAgqjXMdQzemEKeVNr2DanqeXutlm1SUVP9OC5rdHpOpKFeJNngsv9dtc2QMDQtb0bzcxGwewaJ1hmntr3qzYprLuQqR6gMuACJ2hA6XgJ8BoBBrkyo8B4gE1RLUFmBTeSRem0jNnw/eu87mNgsa5iij9601EdaUdYMqywbu/L2eAXIB8z0q1qkMFhhVn/H7oJk2miL15JLwiTycirrVCV769YjWI7xJMpXMqxDg8cw46CtSKJM5/m4iDDTfk0iVWZeMQtFXiX8SsRfJanmrWC/wJrBy+pRJbd3Y/7mfC64Zgrl1hjpO49itbhhHXtRMwIxN1rcuuB8W2wRgS+bDBwLN0YbrjlTLPR5MVIise9U3BdTRXduOimEts3m0rT6takVMZYhm2fDn3m8+tUQJi4oxU9LJ/3Vr6YYIvrTekyblNbX7eDXuDa/fB6b81/clIhTEflbMhmGDXCGVsRcO+u0zsVMKSCrWbG2Ma+a/01E5KH14bDKqe2FlWmgc2RZf1yab0gzXV8EA/y7UeEQkBXdoK9LaEPch8frMJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(110136005)(36756003)(316002)(86362001)(31696002)(6506007)(6512007)(83380400001)(52116002)(53546011)(66556008)(66476007)(8936002)(8676002)(4326008)(66946007)(31686004)(6486002)(6666004)(508600001)(186003)(38100700002)(2616005)(7416002)(5660300002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3p3ajJzekNybDJtU2RGczJ5cmVSY3FIUFRzblNJY0VvVjFaUFg2T1lZMDRo?=
 =?utf-8?B?NzBSa1Z5YTQrNTZzd0NBc2VNdC9Dam5GOS94UGFNa0ZFQnJIZ1BVZFYxc2hk?=
 =?utf-8?B?TVhtK0Jwck8yTVRyOWxyRHh5WWJtRVA2TThLM0gyMnVpWVRSNkJLWWZTSGlh?=
 =?utf-8?B?WCtoeHNMWW1zU2VibXpCb2M3REg4WlZXNzV6c2J5aW9KTGRNMmZHVHNIR2Zp?=
 =?utf-8?B?VDUzZWpJSVpDYXpIWHJ0bzVscUxKNHg0NWlBMUt4WlR4QjRBZDY3NTdhdWRH?=
 =?utf-8?B?N3pqYVo4N2JqRElwa3E2UklYUG5VNHZFZ201WmNib0VZNXdzTE1VS3RQT3RZ?=
 =?utf-8?B?RlBUc2JWMnlwWWZyR3dvQi9tdEVVSjVRTDhGcURJYU9CUmxjczRjYmVGQndz?=
 =?utf-8?B?Q2dJSUI1dmxSdVpoWHkvaFRkREhya2NoeThpRWo1eGVMM0ppL3p5dktvbndj?=
 =?utf-8?B?TG9qdkpNMkJMNnR1RXFKTks2V1kwbVg4VDNEemJiTGhHeEc3NUdyZGdvZDdy?=
 =?utf-8?B?KzlIbTAzdmo0L2M5VmxXbldZcUFtZGdITnNxMm85WnNZSnA1K25WT1NYOTV5?=
 =?utf-8?B?b2k3Z3VQZE9DckhLcU1OODRJM2hnTzYrNjRsM0szeXJqSzMxaFUxUnBpOXh2?=
 =?utf-8?B?by85TXEzSTVyNEFsZ1F0TVBSZ0hrZWNQL2YvMTkreGIydmJVUGJWTk9neXVt?=
 =?utf-8?B?UmpGTFVaNUtqVFN0K0RMNVlYem9qNWxpdEtpTVhWSEgrQzNVZUJYRjZjQld6?=
 =?utf-8?B?RC8rcCthVDAyc29oMnczV0l5MVltalJqQ2gwM3V4aE9zU3FkdHVLMFdHWjNB?=
 =?utf-8?B?VjF4eUFGc21XY3VjM1F5WFltR2VnWDFFNG1Ib1NEaFNQL3pPNVBqaldCWit6?=
 =?utf-8?B?aFNZTjNvZncydGE1N01qeUVPbmxxTVRBTUZENnkyVUNyOXExc2pPVWtXVUhB?=
 =?utf-8?B?Zys2UWhBd0U1N1gwZ1JZQ0VGL0FkU1JGalVhMldERStsdysxM3J6cS9vL2sz?=
 =?utf-8?B?WDNMYVRxdFVkTERWeGNFbFdVQ3NvZWU5eW5hZG9IQlVTTThPL3ArUjZXVC8w?=
 =?utf-8?B?WkEyNVBVY2djTkdac0lCWU5ORGxKTU1vdEUzcGQ3Ulhyd0MzdGJvc3dQQmdO?=
 =?utf-8?B?UlhmMmdmeC85RmRxc20rc2llTS90YlBnUEduY3VHWnNZeW9ZQkpvNlNOL0ox?=
 =?utf-8?B?UEZTdU5oTllHeEwrYmVndG95YjUzRkFTV3RzaEdReVlHbHFHbHdtMlRtSEdp?=
 =?utf-8?B?eHVaRkVra1Y3MERqME5kTEJUSEZyRnpkY0wvc1dFUnU0Z1pXc0ZzY29iR2NT?=
 =?utf-8?B?YkFISnZVV25URVpjTzZKZ2RJcU1MY3BXcXRNVE5tSE5IMDBxTThRbVBLOVNG?=
 =?utf-8?B?WlFCT3JIZE1HTjE3MHlSZU55RzlxeHcxU09POXdVM0dRaUdoRExtb2JzUHZj?=
 =?utf-8?B?UlF6UUpXNUhoSWVoSmp5RFdmN1E2dU1GWkRJOUtKM1B5TDROMlBRQ2xOWEg4?=
 =?utf-8?B?VkJBcTdVOCtCeVVaMUhucSs0SmZFditDMHE4Mm1UUXhUY3Y1VG1IN1JrT1li?=
 =?utf-8?B?V0JmVXZrNWN1ZGU3Rk1GWGtqclZuQ1ZRZEFoaTQwQjJhdlF3SkJpNzBON1E2?=
 =?utf-8?B?N0E1U25mWmg2bkNXMWFCLzVkc2xyVjdBL3F3NDUvUzVuWHR1VTJ3WWxvcjFK?=
 =?utf-8?B?YUtKUUZ0RDZFSlhxcE5DdXIrNmV4amsvR0JWQXRpbDFNak96U1R1YnFkNlJq?=
 =?utf-8?B?VlhvZXR0NWNvYTBMckZ0OVdUandmMFFCajg1V3hHK1MrUmc3YzhYWmsybTFN?=
 =?utf-8?B?TGVlTGdjUlcvQVJ4cEVRMUFZYVpjdmYzOXlMYjF4UDdoQTZZejhOZ0NJOTZW?=
 =?utf-8?B?cXVlL2k3LzBDbmRhRENFbWJwcFp5WkJra1c1aysvR3JVTGo4VFg1M3I3VnlJ?=
 =?utf-8?B?eXpBb3prNnVYc3FSemxzMEVyVnB5WjVvZ1lRSERHbzF1Q3ZXWDE0ZWd4TnZE?=
 =?utf-8?B?UFR1Y0llQlNzVlp2Tm1zSUE2Wk5Zdi82NlZOalBmU3AreDQrM3dsUE8vUFNh?=
 =?utf-8?B?QjNxSXhQclM4bFJTazdsYS9PR01qRjVuMkpMY1JKelozdkVVK3JEay9MNkY3?=
 =?utf-8?B?NVUzbDVVSE9TbUhPTUtKbndoWU9XNDJIRlRnV3lTWXg4Smw3NkVWeG9aQXBZ?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c9ff4af-de8d-4134-f1cc-08d9ea660af1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 18:17:04.2546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qeJqNJX2ypbYqrTQ1NCRVLYBZvm2noz4GMqLZhtrCcQZm0JEDqTxTmr8MCwqZvLr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4284
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 0iwIFjmnnzMb_i1lmzHB21sdCLWs6EoB
X-Proofpoint-GUID: 0iwIFjmnnzMb_i1lmzHB21sdCLWs6EoB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 spamscore=0 mlxscore=0
 clxscore=1011 lowpriorityscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202070112
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/5/22 8:31 PM, Hou Tao wrote:
> Two subtests in ksyms_module.c are not qualified as static, so these
> subtests are exported as standalone tests in tests.h and lead to
> confusion for the output of "./test_progs -t ksyms_module".
> 
> By using the following command:
> 
>    grep "^void \(serial_\)\?test_[a-zA-Z0-9_]\+(\(void\)\?)" \
>        tools/testing/selftests/bpf/prog_tests/*.c | \
> 	awk -F : '{print $1}' | sort | uniq -c | awk '$1 != 1'
> 
> Find out that other tests also have the similar problem, so fix
> these tests by marking subtests in these tests as static. For
> xdp_adjust_frags.c, there is just one subtest, so just export
> the subtest directly.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>   tools/testing/selftests/bpf/prog_tests/ksyms_module.c      | 4 ++--
>   tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c  | 6 ------
>   tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c   | 4 ++--
>   tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c | 4 ++--
>   tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c | 2 +-
>   5 files changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> index ecc58c9e7631..a1ebac70ec29 100644
> --- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> @@ -6,7 +6,7 @@
>   #include "test_ksyms_module.lskel.h"
>   #include "test_ksyms_module.skel.h"
>   
> -void test_ksyms_module_lskel(void)
> +static void test_ksyms_module_lskel(void)
>   {
>   	struct test_ksyms_module_lskel *skel;
>   	int err;
> @@ -33,7 +33,7 @@ void test_ksyms_module_lskel(void)
>   	test_ksyms_module_lskel__destroy(skel);
>   }
>   
> -void test_ksyms_module_libbpf(void)
> +static void test_ksyms_module_libbpf(void)
>   {
>   	struct test_ksyms_module *skel;
>   	int err;
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
> index 134d0ac32f59..fc2d8fa8dac5 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
> @@ -102,9 +102,3 @@ void test_xdp_update_frags(void)
>   out:
>   	bpf_object__close(obj);
>   }
> -
> -void test_xdp_adjust_frags(void)
> -{
> -	if (test__start_subtest("xdp_adjust_frags"))
> -		test_xdp_update_frags();
> -}

I suggest keep test_xdp_adjust_frags and mark
test_xdp_update_frags as static function, and
this is also good for future extension.
It is confusing that test_xdp_update_frags
test in file xdp_adjust_frags.c. Typical
prog_tests/ test has {test,serial_test}_<TEST> test
with file name <TEST>.c file.

[...]
