Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6352E5296A6
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbiEQBVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 21:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbiEQBVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:21:30 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9F0A444;
        Mon, 16 May 2022 18:21:29 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GIX2c3002117;
        Mon, 16 May 2022 18:21:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9oBcIIM7kB6FWFLIaGHluBHEQY5yt6EgJGzUL4jY1yk=;
 b=BOAymxqXygflPo482fHNe0VGzVpjRi6kw/C6wKNpuSVOZrEtgHBR1xBxUMkWFYkgvs5D
 pVlKWQ4By362X6YPxP4bLOMuXdUlkwl4TpNG0RiYHVvHGp4+0RFhm1BNlH28sGLgFi7G
 D9sMTKj8TyMshHcGOOiIjoLqfnOayov0kcI= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g29hu624j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 18:21:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxxJgbmRYULxVDWd/97T92d60hre0cqpHFOST+Sr9dJHSD4IWfZAD787jMOzbJCDGZpsRd7kp5mPyc99b1PD8HQxJtgQdUTycF/8zNKkbfbDbXXgt0MSJAiVZFlRDIfCAnILQuZvwVT2WvmW8ZjajxHFNv9vndtfxkoI+9I0HEqCn8T0vN6xKdi+Iv9zosqCgzcgl9t5UTk09tEuLKUVl9AMH6posENyqg/N6t1oJcU+Yz5F0AYDU2cPcu3PzqGIvCu8Qwr6NrruL5tppEoZniJ1i7G8DpMAKBCegmQ3vkaRsmxWKagMWiiOV8u4b1VwyltVMMdyZ2kT4w5PAfE+nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9oBcIIM7kB6FWFLIaGHluBHEQY5yt6EgJGzUL4jY1yk=;
 b=mLikRN6zODKggxc5RT79R1IIMCxxBwEOfMTM62LFZBXvRzc3c5hmFhsKnQLpzh3ydEM4KLPS0sSSRf7hhgSfdHj48LQ3nF3Y6xapcVxzhVAI6mhB8GQd0DSAc2KzK3mLZ/tkc3twrSeWiRaTBohFEcZQr4McJo+Ubqmwj6rUyACr/cP0a3KGW4nMJGsqQehDjh7eSiVGxzuRIapX7XUKPxvNIihc4D4CbwNZduN/w9/8BzFTXriToiw82s2jW4AjSSBdPGKsYZvyeHIkyZaE3Yhf01IBTf8d9PT5/CC0Uepao9b5C6rggAvCrJRt5cm+jAArp51mujhMXT6qMFTpLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BN6PR15MB1667.namprd15.prod.outlook.com (2603:10b6:404:11c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 01:20:57 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3%5]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 01:20:57 +0000
Date:   Mon, 16 May 2022 18:20:55 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH bpf-next v4 4/7] selftests/bpf: test bpf_skc_to_mptcp_sock
Message-ID: <20220517012055.loesbaunau2bxbt5@kafai-mbp.dhcp.thefacebook.com>
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
 <20220513224827.662254-5-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513224827.662254-5-mathew.j.martineau@linux.intel.com>
X-ClientProxiedBy: SJ0P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::9) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66820f0c-1a97-4438-cefe-08da37a37ef6
X-MS-TrafficTypeDiagnostic: BN6PR15MB1667:EE_
X-Microsoft-Antispam-PRVS: <BN6PR15MB166772C3B14BD4C7B287F8A7D5CE9@BN6PR15MB1667.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ijn6egRULv2hELJ1NurAM1R2/5kYn2waPv3FQk1X1ALtl8X6YWT9mxgQa0cmb+LhzPpw/lG+lpXb7ONVhLSGUm0XDT4OJtc8OwH8nszRtd+BXbj//A0P+Dp3dmzqID0w+y941srlAJiAN3TsObDKo2+P+i4J5w2R8DzZcnK/bJmVnbn/aBRp6T4w9WbDsHKjl5Crj6nTGJO6Fo3mYPtDp8jLO95YFkgQNWpdMY65CzjT61KEK5Z+9SuuYIl4HzWHixFn090LDs5ZKSXtbxk7R78SoftjjcGUYLQ1TJbB/F5h6gmRbLfVTVC58IF8zO2U5Mg97obmwv0tmRl53iJ/7pNCoC0gQ0BxpGL8h+8po7KwxeWZR8b+Z/pqDdG58mN+TOjNSwSRB0T+lgm26t4Q+ObI2kD+tRLs8ppWtnVMG1A+Ytjxkcve7fhETrt4SqnJJ+eCNNYKPsb9be5ueQYlC1mTV2lAdgmng6uRhQNzIyzVS6YZ/sPjaeSBOAVFFdMUYIIsL2F01rtwfAwRThcAIXkxWhn3tRRIANEvp4EKeRKQQLb0OUh1sbAXlz/TnwLWunOEBKMjTZA7DbpQAy1xZxr80auPzazDtRMVZyoJr25wLzt49eqiqpqTJaqLLyJlcNlHvz0e/NZF64DEJfHHhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(8676002)(4326008)(66556008)(66476007)(38100700002)(1076003)(86362001)(5660300002)(8936002)(186003)(6506007)(6486002)(6512007)(9686003)(52116002)(2906002)(508600001)(110136005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2iM0MoNcrhcpE7S6F7Rz6B9goNQ3RVBggXn/dg4WTvnNpEGGCa/AOjwdMYgK?=
 =?us-ascii?Q?SRUaY9R/nqv66JJgh2qGD9msdcmmRNfsxbomv+YMtKVAugbiKbIQWss7ji7G?=
 =?us-ascii?Q?jJEyhnsM3ErRO7ywlOe1I4vf3CcNoov6Ob2sHdBl/p/SM2dVlmsthMRhf4/i?=
 =?us-ascii?Q?dRD1zvo680PHNgy6+IWtDO5SyIoFzp2vfJZymbsHBK5JVQjhN7UxUXV4lBR1?=
 =?us-ascii?Q?BG09s5C2g7n59G+jNsjXE9qNjnfpy8q37ProM/6YN+8APCt6yFE7rYmnK9Q1?=
 =?us-ascii?Q?uMB2tR/JEmnPwvWL0Lrmj9V5QSmgj3ULGe/vo4/1CAQ3XpXThEV5191viuXd?=
 =?us-ascii?Q?Nk2c70Qk6KvGji4/7wf6fuhitVJvMRkp+S3Ayy3jUBaiN/bZik1ZDG/NdEPx?=
 =?us-ascii?Q?FF5lnvnRBRFWazKNmlfmcp2/1uLGSUCWJDWFMSUnIjzyG631z1TmPEY6COUE?=
 =?us-ascii?Q?ZLCGRK+rwBkHwBCcaIVN6s7GolPKhBk2cNdx0sAYEKz7z4r5gQDD3+sEUuaL?=
 =?us-ascii?Q?0aWrbRNwh/Wj+qNZP6ieSKO4LH/JY57sjVGN2XDp3A04KVcKAfUddaeYX539?=
 =?us-ascii?Q?JCrbj9EggdzfyVeVRJV/3QL5AyxB9zqk7CxdgESfrw4jh9dyGFlOq/8N0GSX?=
 =?us-ascii?Q?qt9J8w7v0UiSq7mD56tWrVW5QvSKAaTEosgecRg4VkiuFkmTDgX0f+oX+M2z?=
 =?us-ascii?Q?CmwC4jRN+0C+kZ5PX8y3sr3N4HosNn/5oFeaeNxg1NbrEvjGGmVHe7p2MPHh?=
 =?us-ascii?Q?v+J10PAEerXo59hhAgB0AQNb6SIJokv34PJWxxGMBHVFLx1NDGUOl/c7GEd8?=
 =?us-ascii?Q?JySD+pNn0bK3gGRtAz/a+nLvIvdyR6McmJ2l5AZCkKm3DGFNN8g50V4UbngX?=
 =?us-ascii?Q?AsZtRbgmHTm3c/Imf6uAgCecKeEAeGx03dG7jPX9ORKzVcTRtDhURDoPAviY?=
 =?us-ascii?Q?XWn/8dokCWOBlSMSCZSZYgV24aB4oQDPTOhqxht4s7akKAzSlEOGLtfBmvSY?=
 =?us-ascii?Q?tAeZf6FW5LpRNskI0+DmRCcgazdDhZRMdgcIoeYoHgck2bHgukgRTF6CIW9k?=
 =?us-ascii?Q?MIrmiSKOmLl2SXnN40KmN2f//scYa+X0ZPiLyg1IxeFTAfgfaP9QRUtNvzqj?=
 =?us-ascii?Q?WiysFtWtmuNXjuYthhyMVGnXmbeBAxYzPHhsFEvFufHtfzaH7GyrwcamSe+5?=
 =?us-ascii?Q?n0vYK6vR31hbU+YeVmQvWjuBpwyjSA994GzITHe5UcVPwLCu0JMCwHPWvF8Z?=
 =?us-ascii?Q?9q0Pbol0quTZPujhbem0tL/X2WJlvsYa3Mqjmp6wPi4ZN2gm8frNQwvN0HtF?=
 =?us-ascii?Q?ZpsVcRLF6BmntZEDH96jH8JOmdp4PW5CIUfgL3SPKw4MVZI+BYsKDfYuZysk?=
 =?us-ascii?Q?KPedWkuKpfcQ0XUZu0Jv047RmC1D2uxx2Z3EhwK61I9jI2rIL2/TdtQbvjlA?=
 =?us-ascii?Q?pPCFEr4LM/YUNRfnOH8xNOUE4EXyADV4EJmYlHmDgIquJhDmbEUvrW9qdhkF?=
 =?us-ascii?Q?o9v4U4MmuTx2zLKALwsnYSNh7Gl4LCHs6bZaYMPgLz0oT/aB5EckjTFYYMDP?=
 =?us-ascii?Q?cPjdyheB2gy/Z0hEs6hvzMkC7zACp6HadcQIpHrAF/E5sFP31uue8UJYC2gi?=
 =?us-ascii?Q?6rYRWPLJOFwVsX7hc9sPFro9FXe+WFMgz1VV1sn7wcfrwoW2s+sphB3jAOvS?=
 =?us-ascii?Q?Gk3KFIVxRV5I0PhiDVf6S86dQqy38CmLj9D88VO1oW5kmZEO9FNp9L3Qj6qs?=
 =?us-ascii?Q?dihfM+x9Cc2OiUNDJ9/Tx+PZJ+f0mTE=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66820f0c-1a97-4438-cefe-08da37a37ef6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 01:20:57.7054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5TJ6VCUDFr0R9uyoVlJ+q3lyKrx5iphHQ0TYteX/yBx8uq8sCISiv2zmZGAk3GoY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1667
X-Proofpoint-ORIG-GUID: Ksc8mLl9AHYx9KOoaya-R99cnqkIGHJE
X-Proofpoint-GUID: Ksc8mLl9AHYx9KOoaya-R99cnqkIGHJE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_16,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:48:24PM -0700, Mat Martineau wrote:
[ ... ]
> diff --git a/tools/testing/selftests/bpf/progs/mptcp_sock.c b/tools/testing/selftests/bpf/progs/mptcp_sock.c
> index bc09dba0b078..3feb7ff578e2 100644
> --- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
> +++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
> @@ -7,6 +7,7 @@
>  #include "bpf_tcp_helpers.h"
>  
>  char _license[] SEC("license") = "GPL";
> +extern bool CONFIG_MPTCP __kconfig;
>  
>  struct mptcp_storage {
>  	__u32 invoked;
> @@ -24,6 +25,7 @@ SEC("sockops")
>  int _sockops(struct bpf_sock_ops *ctx)
>  {
>  	struct mptcp_storage *storage;
> +	struct mptcp_sock *msk;
>  	int op = (int)ctx->op;
>  	struct tcp_sock *tsk;
>  	struct bpf_sock *sk;
> @@ -41,11 +43,24 @@ int _sockops(struct bpf_sock_ops *ctx)
>  		return 1;
>  
>  	is_mptcp = bpf_core_field_exists(tsk->is_mptcp) ? tsk->is_mptcp : 0;
> -	storage = bpf_sk_storage_get(&socket_storage_map, sk, 0,
> -				     BPF_SK_STORAGE_GET_F_CREATE);
> -	if (!storage)
> -		return 1;
> +	if (!is_mptcp) {
> +		storage = bpf_sk_storage_get(&socket_storage_map, sk, 0,
> +					     BPF_SK_STORAGE_GET_F_CREATE);
> +		if (!storage)
> +			return 1;
> +	} else {
> +		if (!CONFIG_MPTCP)
hmm... how is it possible ?  The above just tested "!is_mptcp".

> +			return 1;
> +
> +		msk = bpf_skc_to_mptcp_sock(sk);
> +		if (!msk)
> +			return 1;
>  
> +		storage = bpf_sk_storage_get(&socket_storage_map, msk, 0,
> +					     BPF_SK_STORAGE_GET_F_CREATE);
> +		if (!storage)
> +			return 1;
> +	}
>  	storage->invoked++;
>  	storage->is_mptcp = is_mptcp;
>  
> -- 
> 2.36.1
> 
