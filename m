Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4272143BA97
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbhJZTWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:22:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38100 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233551AbhJZTWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 15:22:04 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QFXF56025856;
        Tue, 26 Oct 2021 12:19:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=V8tS16xkBhPZbysHmyfh1/yLR7z+HY1gnHzk5tGKhdA=;
 b=lVxviE8OWD4hbHjwOMOpvDJZ7f5gsCRq3Qa/lG/kGz9ElOexlDlF2LAoVkLP3nBear9n
 0t4RIkS3Pf2mqucsGl0BDwnDoSqO16vquTRTbOn5vDBy9BWJc8dvP60S7gSFOzLxDJ7C
 vQKMmBzWfG6P44JY9h1jWCrOXFZtVrFC0hI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bx4e7qr9x-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 26 Oct 2021 12:19:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 26 Oct 2021 12:19:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dn14NpNZwZ3pdiuXS2rr1ByHdMebdPX+BKYmYWlRp/gxFU3V6kfB5mmkycogIxdvcvfYPBTamUPhBAcu92QY2H10XrTnwVIP3k6RISuBCd84vKwetGFU/WoNthnxXgYlpRkQCyjJlLFMnPqcIt2jKZYKFLk29U0rp5MYoQR6qvZ4nx5YoP31ojL4nPdonLt3IZV/80diQVzMRQSjsh4bnlf58dE/oLYzpQS+K0g6jVtPLuI3R0ZuXteNMR1AIOIcSs+Qe+m/9236h9jPoA0PkG5WzM6o7AZYd4JI+6vOsBz2qiopxGtxMppl7zoha7MMqu+6AlmkCTgqDmikV/R/ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8tS16xkBhPZbysHmyfh1/yLR7z+HY1gnHzk5tGKhdA=;
 b=TACvpy5byJ61yfKpndr8Mh4RoFvIY/G36UtGE/G0O07lLhrarW7J5QqmIp9FVHIwp0O7VRG2e2ZtflNqZIkFGqU3l46wHk/KLAT0vtgBfRFsxPD6nye+wrM3YMKgOlGALfEsV6xTjyxlg8tJ+a1lUQDVCD895+0ilPuqnFyS1zywa8WJ/hFovsjjtzarluNt9XABNQwy9ZONPugTvYpGvjTBVPLgQvDaxf09foeRv9dTu5Y6EVytiGExhefMQrRcIc40FTyyzUOAI7UoXZu4l20cpO+0rxI8tzP8XEBXS958JhiPUKR45V8F3aP4PhG0BQCL49W78D8cNekUFK8jZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3758.namprd15.prod.outlook.com (2603:10b6:806:81::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 19:19:36 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%7]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 19:19:36 +0000
Date:   Tue, 26 Oct 2021 12:19:33 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Tejun Heo <tj@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpf: Move BPF_MAP_TYPE for INODE_STORAGE and
 TASK_STORAGE outside of CONFIG_NET
Message-ID: <20211026191933.as4tk6vclw4q2fsg@kafai-mbp.dhcp.thefacebook.com>
References: <YXG1cuuSJDqHQfRY@slm.duckdns.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YXG1cuuSJDqHQfRY@slm.duckdns.org>
X-ClientProxiedBy: MW4PR03CA0347.namprd03.prod.outlook.com
 (2603:10b6:303:dc::22) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:bf3a) by MW4PR03CA0347.namprd03.prod.outlook.com (2603:10b6:303:dc::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Tue, 26 Oct 2021 19:19:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a72ebb2-bf7e-4e91-3aef-08d998b58ca8
X-MS-TrafficTypeDiagnostic: SA0PR15MB3758:
X-Microsoft-Antispam-PRVS: <SA0PR15MB3758CCD48DC3797F9F80FF18D5849@SA0PR15MB3758.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lVmX198THfHSvMuLyjWiNKUBikTjqWLh0gr6TEpM7kBIHlKy3K1hsToV7PkKg5h5zO9py//NK1qyatOHOnnX2JjFA2sFpOxGtfiLaNF25WjAdgtlo1ssazu2dH6cCqJY+Cg2HQuE1es0G+6mnuUunYJ12VZeYM6gT49qoH9tytk++s+g7f9BZ1StjPegsTki1zLPsapJf4058vMBcGH//NqykFOgBcO3OhvYmwM6G3WuRlcqIcQt8eOz34sg29DjSuObucaozBEkyt72G3MQS2QOLlKf3+nv1PuE2Y8NOo1IyMISvMscieFVIoxjkl+B0x1zNHZulG5es3McggdGMp9d4MaNUeuvO6KDTFyyeGJZk192vxQ7OFCurwHvb/sCHcSvFYDVocWwq5fcBCFNK8m25YDu96zMMd3ZnwmE4K5PHcneUYm7F4KgZv4bPVjuABxE46iGh/eUxcxAJH2SxBezUpukCgrIR1H3eDQQzZ6thzLOvHutHSeAujKlnRslku5EuVbDxPH/gyf+9U28PfhrxuH/CbZvLW2cpO3ByD16AnLBvc3jOE/nVxARnhXjxELUg8l/vFAx22dWSB52pzgpGIX66zgDXhYFElbdjg5htLTTATmGUBmovHqjvTJ31qEpescN7fZra4SEqufYxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(8676002)(4326008)(66556008)(2906002)(66476007)(1076003)(186003)(508600001)(66946007)(5660300002)(6916009)(83380400001)(38100700002)(4744005)(9686003)(316002)(55016002)(54906003)(86362001)(6506007)(52116002)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3i9jxJnLUhE92/mBoKCiMpkLJW7F2pEaZA0HmAoNKNfCkDan78cdStWbfmFT?=
 =?us-ascii?Q?NE80XexN6OWR80ipt5jnI0NaA4p09hNdUOohuYFfRj4FUAm0ZCBhlo6z1FPK?=
 =?us-ascii?Q?LKuk1Rg1dj1wACua38Tr8AUOlE0OVEHcWguPc8HRdH4kBhRMaAaZFUcCIGWs?=
 =?us-ascii?Q?GabGb9fY8fSvM5bjVemlQsjDfgkZt7Juv7YA3p4PDGtCZEOLQLN/y9hDYmnQ?=
 =?us-ascii?Q?oLuJaEvzk6CKgVUV1yQtLm3AoqZKzmuqwK7dCSruRRkYzip/hUn/N9TLytEN?=
 =?us-ascii?Q?QdCpPIxz9UquqTrSz5Z4B7PjFYimHW38IlGs4Q83ZHoU1L/5/ZYfbdggKDS0?=
 =?us-ascii?Q?5azMvdPndBXHVyLX7rKngXFGXMxySlvMnDgH/3SOMBfuGXIJT4cr/avThFRW?=
 =?us-ascii?Q?jtlzRZjRVLvLhLhM+By4RPEf1JlS9l3KzzH3qi/5xpsMKPlvGFYVJ5VNic3i?=
 =?us-ascii?Q?zMMi0O21TcmgXaw+pKvszHzDyP8QV3RxyO1gdLgG7FiCrVBOSTc0JNQGexIt?=
 =?us-ascii?Q?wZWGtygolu0zYNodBx6CR+Ob3y8+xDxsR2UUlCgOLDmV2JXfXF9HbhcjNmAb?=
 =?us-ascii?Q?wQ7PhLhNgGgZmp9KIDGFvoY1DJ3ZcOCyU574OSNqCEi6tEoNrUjinjyfdQf4?=
 =?us-ascii?Q?P7hglHe7vE3fQ1sywANMoZYQzCg5zUVHwTWf0SYKcdlWjCUzrhC1PrSTNCgC?=
 =?us-ascii?Q?3KZZSBrWID3Jkk1l+o3YfCVg/l9hyxzm1wcBUlwi0Ua1c2fG98lgaS4NYa+S?=
 =?us-ascii?Q?dR5vn6KZU6sGyad/FW83NzCqE6tluXiUojrCHcJ566uhac45T6cAwxEAl8LY?=
 =?us-ascii?Q?/hHnEljQHPQZVrPGAXcmUbP5kTYGBHLr0FdKgA3rjFx0BLIFuYzu9RFiuBLO?=
 =?us-ascii?Q?qJ0QCucBgE+fz0Q9A15BCHO9ooUfrKRrjQ9B6bTY35YA5jmsNJt/NXtpfyRz?=
 =?us-ascii?Q?mr5tbNf8wDaeLkBtyiNT4JiwEqAG+QpPCZmKqYDncEhd+d0YiQSZkHbA3wKJ?=
 =?us-ascii?Q?+JAon3WxCWkuswq+4Kifdem7BtTxcw5HfosXUxcSexK5E75rTPxatz5mAAry?=
 =?us-ascii?Q?7/BV3apdK4kyW1jO6k1tS9JIqSNLMsh30HmFq2jQXz7D1tBqhoj3qVT8iodZ?=
 =?us-ascii?Q?USKixkokyF1mhm/ps51TQJSPY7YgkEpNwnEs0A2M3Fi8Gs6HRN1WqbsWcIPX?=
 =?us-ascii?Q?N9G6otcOCRhrwkqm0FD8b5pMN0zqFAtLo6Lk3AVaRVZIbQBtlLjzThrxMoVH?=
 =?us-ascii?Q?WXvbOMh9uGLzduvudYT1pGLOsDbYbPtRbaXFDPoPyEUzs3qcKakzrUQDrbe7?=
 =?us-ascii?Q?KXfWD4y+1zHIeWT+jzjKgb6o7T67i3619r2Yh4nBv70caFaxdYlE5f0DBR3j?=
 =?us-ascii?Q?oMdPJO+u2oNW5KxtR+5ure8+kBD15ySp6+RSiIMpntj2n0r2R0Hq9aKZYZjB?=
 =?us-ascii?Q?gFQHY3AR/5UJY7I7O2ISuiCUVkO4bUyAaftU/JJMXtJvr0UeCBJXWjRrrj9v?=
 =?us-ascii?Q?zVIkkBnucIsveKXCcHe0lWOR+39nnoB0BYDPS4NG1UXm3azH7NFjAQbpgg8M?=
 =?us-ascii?Q?3VTErudPItM4PqXAXjN3gputQt8VKsqUkkKmbKzI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a72ebb2-bf7e-4e91-3aef-08d998b58ca8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 19:19:36.7905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: We6wZbPadr9cFmgutR0PoVveYJ//Pj4TXNs5xcTZxh844dBWwWiFSE1ksHEw7cFi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3758
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: nSglMvK-7EylXlC8Be6FpqurTEG_vTVe
X-Proofpoint-ORIG-GUID: nSglMvK-7EylXlC8Be6FpqurTEG_vTVe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_05,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 mlxscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=780
 phishscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110260107
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 08:46:10AM -1000, Tejun Heo wrote:
> bpf_types.h has BPF_MAP_TYPE_INODE_STORAGE and BPF_MAP_TYPE_TASK_STORAGE
> declared inside #ifdef CONFIG_NET although they are built regardless of
> CONFIG_NET. So, when CONFIG_BPF_SYSCALL && !CONFIG_NET, they are built
> without the declarations leading to spurious build failures and not
> registered to bpf_map_types making them unavailable.
> 
> Fix it by moving the BPF_MAP_TYPE for the two map types outside of
> CONFIG_NET.
Acked-by: Martin KaFai Lau <kafai@fb.com>
