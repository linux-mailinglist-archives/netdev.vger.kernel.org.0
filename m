Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8CE4DD269
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 02:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiCRBZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 21:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiCRBZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 21:25:29 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26DE24ED9C;
        Thu, 17 Mar 2022 18:24:11 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 22I0xVm8020721;
        Thu, 17 Mar 2022 18:23:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=/iUMoIO3GjPLFfi8G33uImyfKLke8gxuS7AqqfhVT/I=;
 b=U8SMoxjhMJ0+L6aT5NhQF/3PbZZlVWQoS3pvzKxyCrpiDa8JD8CR9kHXIblZZHsOMlUT
 OBU8x7qJtCbvJB4pIvSzqOp2KdCoSTyjsRvTHi923V2pE7bXJtQwVfZMQEsxuTxM/l8L
 e3wHWb9+Gb7qp+Peds9rmHt4tr+GGNf8kDI= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by m0001303.ppops.net (PPS) with ESMTPS id 3evg10r33j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Mar 2022 18:23:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wnk5qgutotutVhjV2TIBXPs67exjeQhw7222mCQ/L1ynrLw+f2PCjeUJiKs0DanXdCE3FO77J0sy3+pnKYR9S3OOw/QXcMTaQQPv0IlAoYYk3tc/YLYiREAgF9Hy4Thhhbod4aMrQOQcBGeAI8zMZ2nspjR6SG/SPCX6Wl3TL8S2HdpyhlF9Zrmk1ZoGrDLq93CA9wMi/XsuiQmdfcx7EmyjUhYxHZnGacqMWDsFlQoKzv5eryDPC1joSTuarcbyQ6dit3GLUpgPcV3MNmcVx9bTGL2moTAzp6hfEgxzAhwh/EZj8x/nb2wR2EmGhoCfrDYQ89ZCe/YMBwHQ5b266Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/iUMoIO3GjPLFfi8G33uImyfKLke8gxuS7AqqfhVT/I=;
 b=fQGsjxbp8x5SHO5XiZc3FL/W8xmQFRtNHftITMsM4JYwLJziDEMvH/NWpyUivMDNEfVLB+E+zMppBkUX87sFgRtOKNpCDsOS2LFNk0ovxSVDKdIX6eyXHD6Jo3GO7PP6L8xE48dPkih6R3dcTXzzlbGBR1dPmOV8lJInBNHitdU6P+ekRxOeuKWbCWAngjaexLGsIxAysyU5r951+kEg/BydmuailFWGVHKO5j+CScyfSlYxicvE1oT5lhqc7x9RYMb4t2NQ65HYD4D2XwPinYVA1WOWlhI5yGX8Quyru3Em5/0CYLnVul5WyJc3H7bJ2Yt5VplxiE7PbdEqKDTgwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by CH2PR15MB3686.namprd15.prod.outlook.com (2603:10b6:610:1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Fri, 18 Mar
 2022 01:23:54 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca%3]) with mapi id 15.20.5081.017; Fri, 18 Mar 2022
 01:23:54 +0000
Date:   Thu, 17 Mar 2022 18:23:51 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH bpf-next 0/3] Make 2-byte access to
 bpf_sk_lookup->remote_port endian-agnostic
Message-ID: <20220318012351.fc52oconw6juljod@kafai-mbp.dhcp.thefacebook.com>
References: <20220317165826.1099418-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317165826.1099418-1-jakub@cloudflare.com>
X-ClientProxiedBy: MWHPR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:300:115::23) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60dffafc-01ed-49a9-d5db-08da087df791
X-MS-TrafficTypeDiagnostic: CH2PR15MB3686:EE_
X-Microsoft-Antispam-PRVS: <CH2PR15MB368600F357220D4C64D2ADA7D5139@CH2PR15MB3686.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V2upxrNo70fKyvAaJqr0+c+dOOYb+0/q+ekktOW9s3qrC18Jb3N1hzT+Po5H1MwbPLtiD5azijoADs0lNcJITtPaN2qpzNMwK07xv9MJu6BRfI31Nq9PCU6ShdRKGPM4B8gDIvjZv37FVdGWDOVJrH8VOAlUGIKWnoQ0y9Igg3bEWbT2zV8P6BrHbhVI+si6KOlJndXNkZGU1hBjGkjX6dkWzk/UprkfrgdCZnZOBfD8XGMDr+GI/7qgPSSs5SW6BdZwqkUvJYf+AGxjPLpeB2zeYC/jPWgOZL9kffFXx0J9qiX/p5UPiR6H5WNC/qm5ABpHggks1yziuxRD3auhTIP1iDxGqoW/pvove9ei/sNWcJ8KDQ25QIcQxZnxUK7OP7VF9St6xwM0QZuHs2EPZNhcsLs17Ui+m+YvdD95gXoO1dSCFx0ExtCO9soVlooXC9W3Sq/l4QtkoW8oiI827qIkrzEeqy0LRydMALNiGd9AoSkISGWqZyBY0fFrcuVfL/fNcx5oI4W4ARKu0rPVqc6sH7cbfANF/DSs6hsGyLB7jmbyEjC82wVY/cGApdZTnLUZszxiLkcdi4VveXoTwUwfaab2ZNyDQRaRyi1YiHlWtEzjRVQZUr7hcLxWtb1svvG4m2DwSCpnxGitPBZ95C9K9c6BnP9q+T7aVvovX00aWnWto8HXU/X7jLZ3w8LkiJ4doAu/xgsKy1YpEGcqSKySlmcW+B1ag82BGZehxfY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(38100700002)(8676002)(86362001)(66556008)(6916009)(4326008)(9686003)(6512007)(66946007)(54906003)(52116002)(2906002)(316002)(6666004)(508600001)(8936002)(6506007)(1076003)(186003)(7416002)(966005)(6486002)(66476007)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j3rCnVUZF1NXFvsaLytrFggyfxdT5BYUQsC4uNyyAFPzVZsQKpPijnLqRAWF?=
 =?us-ascii?Q?U7y+YGAqV2wsS3rIPDj0wZsHiSLJylNoTnWk+8A46lVN7eGn3XurNNmdcwC3?=
 =?us-ascii?Q?WpPjseHLeU8B//K/9j1flBuKtejj/yP8EWusnganVcq4M5rEQtKMVl7iEp7E?=
 =?us-ascii?Q?+P/es1GoQ3eBSOhjk2nlUgEANoQGY88kNUKtDMwHdjHa62JSKEFWjimxBEq9?=
 =?us-ascii?Q?BItAzsHQz51OjcP8kF5oIORKiCG+cFWYY9e/BzZkuhb0IVDyd/IZCLcSuQmh?=
 =?us-ascii?Q?Kh7vqF3704A/OY8gkQD8nv6aqRScktiQHMFTCwndgEu8xzipKROTivDCCbDJ?=
 =?us-ascii?Q?mmgdTEcVjyhnxJXQ10Y7OMaUId+oGC6wrVMiaqCpjJ6b5BvDhQkf7oAZkJ5M?=
 =?us-ascii?Q?aDuZZLU+WS1mb20z4gHPwINexRYt7UsNi5Q7WkWf4jTs8/fPUBp1BFCGemOY?=
 =?us-ascii?Q?xt/9vau2sDAO9oK+8Y59e8P7Bke0UTcncQiFQIL+g9pWmn14/tVv1kLXl4lF?=
 =?us-ascii?Q?ld2kn0guxKy+ydQDYuvmO85eZZZPJnZB8z+brjAle3UczgvSy2CC+RW4WlDh?=
 =?us-ascii?Q?7kbF334qIfCEnqAFQW2E8JjB3n4IRM2QCgoQrxcx95+IVoxa9e+bECU+SzBH?=
 =?us-ascii?Q?Yh766VEXaiDNKXYWAAg1ZDNgPT0hYAAi3fJmwfpnRk6RpIMtMbdZtMlUekat?=
 =?us-ascii?Q?1TrnRGHKsw8IWMCwrG92fOPNe2AWF/YNWP4kT2B5yRTEreDgW4vfeWJVytBU?=
 =?us-ascii?Q?I93PBCc9iRspEu1HF1EHqKXBBI4JeVBZLFA5i9izlbgHNnipKfDBDa/IHWAc?=
 =?us-ascii?Q?lM6UwMsqxax5UdlytWXRq05NXyQtc/bowypO3lWe/JJeoEV6/7qO0n5zz2XV?=
 =?us-ascii?Q?dg2WImPZN46Hwh+MIWDk1CCVWuK0tIatzkB3Yc8m8AkqlJW81b72u418tOzq?=
 =?us-ascii?Q?8puW/XkMpG/1KVdPWm4kIDwjatkJa8/vdMSXuUqjBxdxa3DNzS7vfTuPHNDq?=
 =?us-ascii?Q?qMfZk6X0Fr9+TICWrc+uionNZ7I6EFnGPxz/mKnMmubxG6mybknlkDnZ0M3r?=
 =?us-ascii?Q?LUPiVcmzuJs/TgqIdyNScb5rsUM4WWslM4YLa/G+I6vUfmiRAhc6S+3opbVn?=
 =?us-ascii?Q?lHvBuLtJU4QfiWhA1kGEq/9wc9qwJdHniVgbvAlZtGpifRR5890SdSAryHkZ?=
 =?us-ascii?Q?XIjm25NKvP6v14J9+/WNw675SsVErFa2TMi6O1B9EPhUzDDUfI8vGquc2U0T?=
 =?us-ascii?Q?Mdepp2YUIBGvcPH8BDBVB95kLq9bG4puHpWnJvHrBpRIMnizt7ilLzXJo5sG?=
 =?us-ascii?Q?Z3y0L9PcPrRGfDN+1g/2CSy7y/QYCWTDvqulAdxA44qn0/Nh1SrrT/fCNSHz?=
 =?us-ascii?Q?4oTjhQ14OX/LcE7q6YYX/nE0uUAjGELkmgETxR4KOKyXKHxZ3m3Texa4d218?=
 =?us-ascii?Q?V1rM6yGt4pFYSQJeiLDwHrHx2H1PKnxjFqulknmRD9NSWqW74j9YNg=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60dffafc-01ed-49a9-d5db-08da087df791
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 01:23:54.4747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hefH3tHINVWmu1/EF4U6grbyc1rNOTJNzcKAMWONn0FV1g4h7T8y7hfY31jw7Syn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3686
X-Proofpoint-GUID: hNebt8K2ogcxHCo6WHm_HbMyFV6Mtlgo
X-Proofpoint-ORIG-GUID: hNebt8K2ogcxHCo6WHm_HbMyFV6Mtlgo
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-17_07,2022-03-15_01,2022-02-23_01
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 05:58:23PM +0100, Jakub Sitnicki wrote:
> This patch set is a result of a discussion we had around the RFC patchset from
> Ilya [1]. The fix for the narrow loads from the RFC series is still relevant,
> but this series does not depend on it. Nor is it required to unbreak sk_lookup
> tests on BE, if this series gets applied.
> 
> To summarize the takeaways from [1]:
> 
>  1) we want to make 2-byte load from ctx->remote_port portable across LE and BE,
>  2) we keep the 4-byte load from ctx->remote_port as it is today - result varies
>     on endianess of the platform.
> 
> [1] https://lore.kernel.org/bpf/20220222182559.2865596-2-iii@linux.ibm.com/
For the set,

Acked-by: Martin KaFai Lau <kafai@fb.com>
