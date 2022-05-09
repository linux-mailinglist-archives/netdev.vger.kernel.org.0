Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCE15203D3
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239785AbiEIR47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiEIR45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:56:57 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E632C4787;
        Mon,  9 May 2022 10:53:02 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249Ejt3i016803;
        Mon, 9 May 2022 10:52:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=t0kGiO06/PBqIfc8GUyTvd7/vS4F9JcevXDIUpmf5ew=;
 b=gG051gtx76/PykROONMBB6TR5wzEK9iO9tAr/aYLd844iIo7L4B1ZRKiAJAau4P7VA4I
 vFdBXiNt3z9NDC+ri8neWfHHWZQkscSV0jlepu11IMwqnSrLY5zHTKRratXjEmQsBIP1
 XA+pJfMGCVTpJ/NNH+A2chC0NFCxA8Y4kQ4= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fwnvs2dhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 10:52:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqpqEKMUYwvEd8JqoLfjnVDQqerhcERb1zyIcxkkxfCqgH+OyUNwlXt6hsgF5yfTxOgZRFir+Z2kZDlgIHKwb/rtvYvXII3Yi/5/ZOVya35uYZ6Wr3qF+l6NN+fc6n4ykpzOOG7tFy3N327j75cjzG6TCTxnrFJVNxak2jKmfCKzeq4KNmEsSrIZPdbKFZxWaqWZzL2qEehnfvbaV7SGMemM+SIkRCEOo2QLHH8mmvc5ZAUFiRYHyWO9LMIsk+PGHi/RE/YyYHdXWtkRQvwgETZTIXYBANfz5uBhwSZG/elqZvGELRmjTPGi0mTNmKK4/wcN6FNnS84w/lPpmDzDCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0kGiO06/PBqIfc8GUyTvd7/vS4F9JcevXDIUpmf5ew=;
 b=aZ9Lr8z5x657TlaH9FbqoN8GWjwb0SJZdBxJ/lH868gPU6c2GOciOFXLQ9XTqJaL3YuDo0SL/SBLhmJAiSB4fiOaq1VLw2SJP99x0eehY629h3pJEJszlTMFAHtxhGf42eWJjOHGlc43D7w3lntibTuu93TqEhCZyWZuVtOfa5M7NHVe6j5mXqargCB0K2a1+s6thXi5XTA8Sg6RnCYY0Y+nMzEPE9sBq3Luo14DyRiNXa8nm7oyL6iuUnGg5ScyAyQLVkGUn6m8HwRdi0a5M5Nq2EAH88ak/h8gqvlO7QPDKRWHAp8RvxEhwb8CPiLD3IAQOPkUUIK1p0yhhyKq4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by PH0PR15MB4990.namprd15.prod.outlook.com (2603:10b6:510:c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 17:52:45 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::fd7d:7e89:37f4:1714]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::fd7d:7e89:37f4:1714%5]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 17:52:45 +0000
Date:   Mon, 9 May 2022 10:52:42 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next] bpf: Remove unused parameter from
 find_kfunc_desc_btf()
Message-ID: <20220509175242.3zgihomxteagixfa@kafai-mbp.dhcp.thefacebook.com>
References: <20220505070114.3522522-1-ytcoode@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505070114.3522522-1-ytcoode@gmail.com>
X-ClientProxiedBy: BYAPR06CA0050.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::27) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36914222-3126-4988-49b1-08da31e4b8e5
X-MS-TrafficTypeDiagnostic: PH0PR15MB4990:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB4990118D47FF0EF26B64E709D5C69@PH0PR15MB4990.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z4ocEqfjZPBVZkOOg8R95whOuFBMFrqG6HGFz8SeGN8RmnMrLsH7T4hPlgyYDWJyfc3HEVTAmjO16VaNhkxl4NP9Sl16l1T8viWDhYU2rV0G2DePxegyBXDKWtgdySViT3acwlyEuQeYedikUpIXCV3BatsGKaaUWBIsuW4yoqSzBDvApZURlqn7CUw7n+M8Kj0f0wbAE3Rkg2vWZYNH5uRLqmDm8vbmD91yDuLl+oIt43iVFqFiF554+yhyP5QiGpC0xXL1y4a/LRwW3d23Akd3/ZW1BB7Iu2cT2q1FdmbXctb4PDJ3in1N50CB5a6tWfRDiGPbAwMUNqco8enSkyD1ECeDei4gA6OOMmlsUUuFPQo4DGXiG33eDyHn7uKAFkdxRf1fZpni9hFeU4TiuiyV0CUI2iYLkTHGBSD2unls9h/LWz/3aOUA1acliC3W/8ceKW2syNJFwkfBafYtFuewwaH3P/2IGQw/zWCcjUtlzgWMHnvJhd/qYOIa25WPp03kOP7NayvmF1LkDvzDperep+xNTuMX+aBrex/U9mmO0Ic7wP9CwHoNzKjG4jQmXLMFcwqUj73OrVsURU5yL8e7WCVdZMdcFeN3sKwZjXVwkAYbAwO7sMUciCND7aqhv3rN6CWOJpHAB8KdfN3YKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(9686003)(6486002)(6512007)(86362001)(1076003)(6506007)(186003)(52116002)(6666004)(2906002)(5660300002)(316002)(4744005)(6916009)(4326008)(8676002)(66476007)(54906003)(66946007)(66556008)(38100700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cAvK5UXLBOvanHmcWGj788I6JA0+1l+IqW3z1uRwfXQEL5ozTIScpT+R9pgT?=
 =?us-ascii?Q?jQA3CBWI56eXgrBvFyI0Ddh3jMgAnIDA51GkOqCYQKXJrYENHTAQCP5lchUm?=
 =?us-ascii?Q?rLeTReV7m5+9IVoB7HbbWEonguF2eQA5+sKMD9l3p4XrIpAcA4RDjIyMons1?=
 =?us-ascii?Q?PKiI1rrlsvdV1uMKalydI5YDkaP7cnRLuOkyZ+x7MCNYm2LQCN5yx8yDjKIY?=
 =?us-ascii?Q?M7lLHxnP/fkXxNjJFV7xoTAbs/DFyFmmQwa5AzUcPODUAsYjbU1HkSScyG/u?=
 =?us-ascii?Q?84kmwOIF4JDBOBTypt/L0KqjX1PVrpjA9vXqAlSHMXM5iplqoUhVPtJgwPbV?=
 =?us-ascii?Q?Kz6dTTp1veBTp0RJy8FZufaqJHd79H6inZWsjwUiQHsNfqMG0RmZFWpm8o5h?=
 =?us-ascii?Q?9+hMa+d00whpDQpcMWOV8jy0EKtYSSv67sRw0g7K3pAr/gnonQW5s7pMcVmk?=
 =?us-ascii?Q?MgntSnMJv22KvO3djLKxBjK98A3l84OFYWXLESyqLLQRj/04M1tHrkD4JX2S?=
 =?us-ascii?Q?uHqJr0bbfAx7lcQzOBbtnf/ahbGMm2hTCjLie7wmPAFLLes1V/yQzcIGkFHT?=
 =?us-ascii?Q?zwkxQmqRY9pDMimWzBbrznbXXvodZIDt5v+rpV+FwGWj4sHwXPgDhf5ePTwf?=
 =?us-ascii?Q?YhkzhrgDSXFJWXwz59EFDQo48wV1KHZBh0tQiWGyFl07euwjM22vTjfTXCmg?=
 =?us-ascii?Q?fxcaeZzIdCY9/4Dyt8n5KS5DlIQf2AilBQ3IllzLr3jZlu4micCOeBNtidiG?=
 =?us-ascii?Q?QzbekxQACfLCn4dYAV7vTA184aqpgID4yVV47QSyak8X7UD/mRBqlvFViNQG?=
 =?us-ascii?Q?kz5ZrURzcDG+DeLTbrLrJ1dN3yU3fGixEnX3G5Pg9dPEL+L5CsNNHOgztSnD?=
 =?us-ascii?Q?SP0YeB5A8hyWudziitJCZ/GJFXtWiKYmBYqzQj9OYT1IxhEHFFzARJMYUuKw?=
 =?us-ascii?Q?j6H4hYJ+zqglB9b5MA35k+td0fq0Va4ZHD3/c1xkwbeFLojum71H82zHMJ7C?=
 =?us-ascii?Q?QCZ66d/FI3lbMvyQhTlneq3j5DoQ29/G02fbvecbi7kvfs2Vgb3mgQ11f7o6?=
 =?us-ascii?Q?3Z3toGdE98W7sBlJ9DmXjaosS7kEBeB2EjhXWUolU6AjvY7ROcyfPgGzkNQu?=
 =?us-ascii?Q?FTpTyVFUCxzsDVF+/0vra0gIXQiVPykOuw1+ZgpBCsKuxfXMcDIHQz+9geJP?=
 =?us-ascii?Q?gnIFYzHqrcz2yy+c9GOfwKeVZoyydRp/LRBMUyK4SYULXe4Vmo8cDeSMEnyy?=
 =?us-ascii?Q?M8h8xuxLLP1A25nKWcFWbqcXSCTbsaZJPsWlWVzT0zvQgBJug4JeQIFBkKqM?=
 =?us-ascii?Q?Yuc7OMT5GgXnWY8r9jOWy7q1skbfa4IKCXHzk/tJTp0HbWzsg0QUQI/qcU6r?=
 =?us-ascii?Q?AwoK2xXR8BA0ao72Z4uFdwcg0wtLBoKXcD7E30EgVQd1bxVTn8MXdikBdSml?=
 =?us-ascii?Q?sVRS+zQU14fjk2vcjyUxqS61yqn2ZDB3j0NatbBUgeo6G+6X5VER5OCTYc3s?=
 =?us-ascii?Q?1GyCd8RD0+WNcOa0PVsCMnguRSn2EIQS7w4/nW8/nYtioRiI5wDnmyaNTQvx?=
 =?us-ascii?Q?50U2AhCkqnX0g7ARwNRXdkoEzzkR9cDoJPCbRpljOiiGLXx/AjW6SKkdvIzh?=
 =?us-ascii?Q?7FaHUHJmB3eA/quMtlr8HqPSlWmH8tSy9iDxJiQT52ibJP70SvX9Y6wSZlbT?=
 =?us-ascii?Q?jthIfRBfpb0VzECJl5sIGbqsCq4s2Xk0MQ+f1PVsv3NFrFNoA0YQkU9sUkQl?=
 =?us-ascii?Q?UMb9r5VxhH2S3YUUAEZwfiKPSsGoU5I=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36914222-3126-4988-49b1-08da31e4b8e5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 17:52:45.3341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oZ0hRKTmxMstnzVOUR/VZVKLmF9JC+zZSe6TRWvHlocZ9fdkwKrUOpGzv5Z5YqXn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4990
X-Proofpoint-GUID: wK_inCUE9Rg6RKP7a9AbOQCKKDxwGgjl
X-Proofpoint-ORIG-GUID: wK_inCUE9Rg6RKP7a9AbOQCKKDxwGgjl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_05,2022-05-09_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 03:01:14PM +0800, Yuntao Wang wrote:
> The func_id parameter in find_kfunc_desc_btf() is not used, get rid of it.
> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Although it is a bpf-next material, it is still useful to have a Fixes tag
such that the reviewer can quickly understand how the current code got here.

Fixes: 2357672c54c3 ("bpf: Introduce BPF support for kernel module function calls")
Acked-by: Martin KaFai Lau <kafai@fb.com>
