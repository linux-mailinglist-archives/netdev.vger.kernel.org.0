Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB26A54EA78
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 22:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiFPUAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 16:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiFPUAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 16:00:06 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFC65A17A;
        Thu, 16 Jun 2022 13:00:04 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GIf8TY018417;
        Thu, 16 Jun 2022 12:59:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=PUNOJsxx57y9hdKcuwD9DVJY/WGq/GA6f95mL+5swRc=;
 b=KmWO0ZSSXT4xuvoQWJaF5bD8f+yLS/I7kZJ9Slqe63lFBmZGbYzg/ehsQWsQaC9ZU4UI
 2G605Zxu66ZZ3lWiIB8nvuKWaeFyKpTkwkr2TGQ0IoomjJ3LHg20d3N+9UT8DCk99Z8C
 RyR1lAzx8QsX/ohKQXD5qALkURyNSDYDY3Q= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gqktgvxcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Jun 2022 12:59:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7SvJJHr0jkEEE8X7sGhvtX76N9/LmUP7srqVdbpFm+GrpCqJJTjnN4IleWfZMqYB7DK8rnlMj8FybTWdUuq4lMvRazju1+GV/7c+kqYY6bG/oFkc9c1Sh17dGVQQbiagD01LXTEmhY7WBufvTHN6AmBsvtJxT5PgeKmwk/Pjp/OSSPsDdHW89PwFT4V/vY+3LFdlWqTthmoX20k991evcixz5Bi9SE1waA90BJ1GLTbtLsIfd4OzdgcHPe3wAd6tM92NmtZS+vNVoE6fZYu7wPzZiRlWJHwcVBn1yo7y/RX8w+xR0bKAdeFUvmme+qjhr4hhnl/el7GzvRL+pN8Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PUNOJsxx57y9hdKcuwD9DVJY/WGq/GA6f95mL+5swRc=;
 b=iQg7BeFvqeTHm414SKykFJV58OoyjU6nB5sY/AIP7C8O2jjitGYCf/+ULHTswmZautehKUVBcKud7GIkuvTiDKhPS0eGJxAGs3dFYXXm1jJ+ZMWM4PBIWZg8GKSO36jh+xRzIKlKpXYPyhnqh1i4v0icP/WHkFgQJxD0Xd4QfdG5sWQLS7gLMu3ngbm2firbfqdJUxER9leFt+52sLTUdWg9xXRHxj9rRkcYYIlQfeSzvDjhBSHHYDKsLOtxwh94v9QRzoZrwiHQSWAPnQu0x0wZ6VnlRHuUNLvvmIxyqFRDZRAisD6E3ANtLn0xNYNrTXJ16CpybS3oGzgvob6E/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BN8PR15MB2993.namprd15.prod.outlook.com (2603:10b6:408:83::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 19:59:46 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.015; Thu, 16 Jun 2022
 19:59:46 +0000
Date:   Thu, 16 Jun 2022 12:59:44 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [PATCH bpf-next v9 02/10] bpf: convert cgroup_bpf.progs to hlist
Message-ID: <20220616195944.dev72axh7prwnfh7@kafai-mbp>
References: <20220610165803.2860154-1-sdf@google.com>
 <20220610165803.2860154-3-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610165803.2860154-3-sdf@google.com>
X-ClientProxiedBy: SJ0PR03CA0186.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::11) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96aa0532-1473-4a5b-7f50-08da4fd2c32b
X-MS-TrafficTypeDiagnostic: BN8PR15MB2993:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB29930AB9456ED9E12DF90C93D5AC9@BN8PR15MB2993.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vnyuNYzrVnbbsc2re9O7P3bWHKgDB11fBBJjtJ+ht/i8cFEfC6OSfVgyzpv+m01s2wNpeRYDLnFYyRW4Iv7z+Twea3WdZPLNLsmucbjjfSh0GzY5pl1AC18nyBSWYAMl5iOsQT6NpSj85V6nlS+cjzUNYt4rejDkfm1hLBazrwjlY1v6Ld9L3L+J4XYLLez7h7b/uW6/ZtpqYzuTV3SJhVGTtACId4Xtz0B8cYwT6ux4OV5r+JW+37Jmj7rFvo3mkcaUGpwv8wDyafboGIt74/MmHYFaB19ZZR5eblSnDa7J/1YalygqjYi73hcTGpcDPaC8lX60KlR+6GvDnwXn6GEgh87MeYtLXr9xr6KOnyMWNqJzk/cfQLGx0oVQ5zyuX1hz6DxfKXrVSiNjihho1dS9BvbKJL8nB5n3zFHKktXKpn1ox5+MFe/2zVBcs8yurjL0ToAdDDlmoq1PywkWJzOUnfjOsULMjHIDFC5GoyF7MgLbv/CCQWpCPoRt1HZvaWP8ZkCQk8xPIfJuPqRlOQH4CEkUrNTaCtrJhz6S9gBcROy3pOAIZXmYNmpIU1KjNM6s231iC3C25qP9Kmrdr5tVGLTdECgTA27jFeZ6ihAmDH3lfu1jiVQknf1RQK+ys5tkSs5Ly5VAwFxAXAEYu6z+dVKX28knpqFcIP7DoeI8qs+JQ3jhZ5keHisqKX7r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(5660300002)(2906002)(86362001)(38100700002)(6506007)(9686003)(6512007)(498600001)(6486002)(1076003)(66556008)(186003)(66946007)(8676002)(4326008)(66476007)(33716001)(316002)(8936002)(52116002)(6916009)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zj8EUOMzaaeFIPQxJfkvymMSmW4uD/BRQZEWVn+R+eJO6S/3CuHRnXFsKB4a?=
 =?us-ascii?Q?ySvzH+oJfMmS33EdBjMpk7LzyKPirNg6gKcz/LKb5l5vW5nvBmYfp1NSwENA?=
 =?us-ascii?Q?qu73VBhdtDgy4jOeLPtC0ai+YEpphLTh3qtj5lTFvZE1/jiYLOcuUMeR1p6S?=
 =?us-ascii?Q?37Zwjj2bMhJK2AYBHQTEsbbWjGrT1F7lzmsGZ9HIcHBkOf3VOpFPl5mUtJAn?=
 =?us-ascii?Q?1kdEjTUg6qJvyaCnngmlA9Xfcd69+0be+kfvobOtv1m0a/mInRuTLiT05N0C?=
 =?us-ascii?Q?DYqr3zd9xStc84CyoptoBNNj4ndS/ADmmnq1T7ofZa6JdpeizSAvPKtWXVWd?=
 =?us-ascii?Q?jNaA8i7TkQQmGkH9ESdQBoO3Jt3leybIPJLA5l3Pczw0EOt714yupCLE4YQ8?=
 =?us-ascii?Q?1HL5St1Uo8Yodm4p0dl/cTuiknrl3GRASZFKvj7FjEkkVNTyTRNdAHGxbx5J?=
 =?us-ascii?Q?fvU/pmHcb/QRxvjCgB3F3toVPuDRghfBjBUZIv/t/0NJePe2Sl9EA8SMbZch?=
 =?us-ascii?Q?ax7BDqdoy11Qfyc4o90C2SgcJJriD7+Vt7NKPtLF4imNqcBU9qZFxy8ipl1K?=
 =?us-ascii?Q?nqWet1Jh1xcCJ/k/roqo2SE2F26rS/0NxNAiihJZueM5cVYNHFhobAAgwU29?=
 =?us-ascii?Q?QzoOu6jjl0ejd+009EewMjEXAhegrsUB+H4d96EZorPXMOOXDn055xEyvi4r?=
 =?us-ascii?Q?o5KTxxO90St9IhnTIJq3IPdbSV+AyAk/9waQWjAOYfP9MG9yui4NtBWmwu98?=
 =?us-ascii?Q?mcx2MxArtxGPW55Zk8DkGvEyD5P75+/HDpXV2nNV6mUvvu0hqs55vPKiKSKN?=
 =?us-ascii?Q?sBKUkMk/knvXRTOWU45NdFIwT9XdLoN/iHYxpLkkQMga4BfImQ3vWTvs7vQJ?=
 =?us-ascii?Q?xuk+/6DiirtF5mT7WVwWPP12bUBWgcgJWHcS3WnGKKsm+1hwOnEPMQfmyMfD?=
 =?us-ascii?Q?2U22w3qLhZ0zVQAJtf+9k/8Fi9ULVs8XsHpJGbOOubUqM/8iLiWMyVx2ST3N?=
 =?us-ascii?Q?PdUBskHFnSDg1WYiAKlZHB+W8FOA0O38I3MnVkjnUN66AwiytgIAuDv/AffC?=
 =?us-ascii?Q?BKV7K3nh+dbrVYlZs0sez3fAOkcG0HjdgoRhkxeAmOg11xTucy1tR9JY4ViT?=
 =?us-ascii?Q?THTs1SFzzRBPdozfVC9HMXwXSGmMwRZXSuxz6ZTQaEeqy2zhoY0X/PLlvxTM?=
 =?us-ascii?Q?3Ne5VE9tQt68hXSNHa9gqpdEnZzsrsbl67Ry/jpdloNWDUQabzA6F89ViDmH?=
 =?us-ascii?Q?4luxT+CADxrTAOyLfFFeFmtgNIS93puCNn0YH9WSbqNzR+TvG4kGguiAGb7X?=
 =?us-ascii?Q?Hv/bPiZvi+EpGepHX0egBwr32WoxBCcSG4VonteX/O40lPxHXMrj+6wZQWoc?=
 =?us-ascii?Q?6AGtWJC1JGhXhCKkbfEkQtQ7cW6yzYRGgM2G97bLIXURX10WI8fsqocWAD0W?=
 =?us-ascii?Q?WoNIPm1t6lkIVLUzBSpPJerXAp46bmWwQgVLuWrUAys0BpgC+48xTt3VA4vk?=
 =?us-ascii?Q?gbt7WNh48KIGUzMnB6lY63HUL0E2cjWmgzDR0mHq83gZYLT2JliSVUzeeVN/?=
 =?us-ascii?Q?H1399wjQYz5eTIM5cRauEZKtoQ25UX4RgaM9W+oKHhr0y3nw06ID7R2koJnI?=
 =?us-ascii?Q?ZZDrAThL72QcPCU3sNfTgVM1NzBtJ7hipMsGqJQ2fMBsJEmUSBgcB7uIffhW?=
 =?us-ascii?Q?6XAPu/sIfIkgXP4zeLXHvbHRpnLcH+KcOYQ85hdVgv+HlsfwSmY9PtCwEVUy?=
 =?us-ascii?Q?wIuH05yLFV9RDEiH4de0ABVvoMWulv8=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96aa0532-1473-4a5b-7f50-08da4fd2c32b
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 19:59:46.3886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 35pckijD0wz1anGpEIrNCMfcq/a+hRT4RCt60w4D8TFRIMNOFxlraK9QyE79lv+5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2993
X-Proofpoint-ORIG-GUID: ZHPM0flLYygCrDL1-FWsBQ4QBlMEckl-
X-Proofpoint-GUID: ZHPM0flLYygCrDL1-FWsBQ4QBlMEckl-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_18,2022-06-16_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 09:57:55AM -0700, Stanislav Fomichev wrote:
> This lets us reclaim some space to be used by new cgroup lsm slots.
> 
> Before:
> struct cgroup_bpf {
> 	struct bpf_prog_array *    effective[23];        /*     0   184 */
> 	/* --- cacheline 2 boundary (128 bytes) was 56 bytes ago --- */
> 	struct list_head           progs[23];            /*   184   368 */
> 	/* --- cacheline 8 boundary (512 bytes) was 40 bytes ago --- */
> 	u32                        flags[23];            /*   552    92 */
> 
> 	/* XXX 4 bytes hole, try to pack */
> 
> 	/* --- cacheline 10 boundary (640 bytes) was 8 bytes ago --- */
> 	struct list_head           storages;             /*   648    16 */
> 	struct bpf_prog_array *    inactive;             /*   664     8 */
> 	struct percpu_ref          refcnt;               /*   672    16 */
> 	struct work_struct         release_work;         /*   688    32 */
> 
> 	/* size: 720, cachelines: 12, members: 7 */
> 	/* sum members: 716, holes: 1, sum holes: 4 */
> 	/* last cacheline: 16 bytes */
> };
> 
> After:
> struct cgroup_bpf {
> 	struct bpf_prog_array *    effective[23];        /*     0   184 */
> 	/* --- cacheline 2 boundary (128 bytes) was 56 bytes ago --- */
> 	struct hlist_head          progs[23];            /*   184   184 */
> 	/* --- cacheline 5 boundary (320 bytes) was 48 bytes ago --- */
> 	u8                         flags[23];            /*   368    23 */
> 
> 	/* XXX 1 byte hole, try to pack */
> 
> 	/* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
> 	struct list_head           storages;             /*   392    16 */
> 	struct bpf_prog_array *    inactive;             /*   408     8 */
> 	struct percpu_ref          refcnt;               /*   416    16 */
> 	struct work_struct         release_work;         /*   432    72 */
> 
> 	/* size: 504, cachelines: 8, members: 7 */
> 	/* sum members: 503, holes: 1, sum holes: 1 */
> 	/* last cacheline: 56 bytes */
> };
> 
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
Reviewed-by: Martin KaFai Lau <kafai@fb.com>
