Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B17325A86
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 01:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhBZAE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 19:04:56 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18250 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232471AbhBZAEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 19:04:46 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PNvtDK012864;
        Thu, 25 Feb 2021 16:03:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=fW9Hctt1GnyfCrHxWtp/DDNz1skECV0K8bYsAgTUE0U=;
 b=G0kgRsbpQO4FD9lQA07/M2iXTw8RBca8NWqQwCYzSS/EheS87mmuVOqa60kXcV4s8rXU
 KcbzHv84JnhLIy2JcP3QvZw+VGzIr3L+IMOaT22DkQo88yOZBqm1DGXzjHLmAImy9s8u
 he4HPXtbdIgp7ZHTmo5LLN76Z9DtbicRnCs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36xkfm0us2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Feb 2021 16:03:52 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Feb 2021 16:03:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mx9HwRmfxNB6wyKFCY63JNpbfpwwRCsFgZZx2XXJ/UfowKziX92VGETQeOt7vgMSQSjiyWgAZFU+p2p9XTx1izPFHtXPA9S/MaEcI7Z0FWqLRy4zqVFRuLw+KQ14k6l/HIak/DCiM4yEwZtmtmuT1fPhj0YGUqZhTPGeBQl5W5widJ64Y+hrd21BChIyvG3Rxio9xFE3lY5uRz0udt1R+FHni7BilmfVnlRFu7OAGbGREpDskEYq4+KqbLp7tbVOiLQsDQ6JXv+/Vp8J8Ki1RvnoosJ0kwXUyhwH7h/gl8YncrWppSM2xs/B/bURBk18yQacRVETMSNXJ7jDsiMGWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fW9Hctt1GnyfCrHxWtp/DDNz1skECV0K8bYsAgTUE0U=;
 b=QDNVzWGZWZVKfoVwrbetrh6OXMLuw/oZRrtx65xmOrdx+JKNf667La6UGpY9uofyjdAFX1OaVNL2T8oTvpSBYBfnIHJI4ShIbwmmkhqviMnFfPP/ueM6t5ezKctpzAbynu7cNcsCZmBT93vBr5JQuuRmsiUrvATU45VCzg8c9I3qOSz9hkZKG72pDwQPJtF1cpMV/TzzDYNujh0CZLjoR3mDVqOL9xei8Gj/y89sMcNXRpENlOyYq48wND/hbA6UzT6k9FH/wwka23OlQYGYM7yJmSmZEFCef1uskECW8D9eqm89285qYE404T4EAU+GYDH0VfBa+wvLKCUp+zh0+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3569.namprd15.prod.outlook.com (2603:10b6:a03:1ff::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Fri, 26 Feb
 2021 00:03:47 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 00:03:47 +0000
Date:   Thu, 25 Feb 2021 16:03:44 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <peterz@infradead.org>
Subject: Re: [PATCH v6 bpf-next 0/6] bpf: enable task local storage for
 tracing programs
Message-ID: <20210226000344.a6aud7aaimrc6wzt@kafai-mbp.dhcp.thefacebook.com>
References: <20210225234319.336131-1-songliubraving@fb.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210225234319.336131-1-songliubraving@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:fa88]
X-ClientProxiedBy: MWHPR12CA0059.namprd12.prod.outlook.com
 (2603:10b6:300:103::21) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:fa88) by MWHPR12CA0059.namprd12.prod.outlook.com (2603:10b6:300:103::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 00:03:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95d911f4-1853-4e75-fadd-08d8d9e9fd20
X-MS-TrafficTypeDiagnostic: BY5PR15MB3569:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3569C3014653564171749C79D59D9@BY5PR15MB3569.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I0+x+ldA33+iiC7YwC3+vF8N6oF71C/X9bIvpdZgPac5hhvJFslhK0Mpzqb1D/DXaBnn8jMeuuv/IHH3J5OSD5qmg2+Ci//Cza+3xVsaZ+Ckj3upZURE02dbh9h8g/TO3zQda0RfcpbUIP8o0k8bCzaZYYsSrs1jmVl2gv91YFyxNNMp5HUNHmx5tEQHih0DlECfOLiJOlGxj5PcnrBuKzCMyMrg576K7HxwZzw8WAu+cXn6owE7m2VDfaUDOVLHaeGV983LcHTJpKQvTADLCD+q7KVzxVIZtkjQIvPAGpgiNXO9lu8H8QrS3cBADqvNtSN4C7m2TE/IaAn4UczlCr2klzh8FDiMAq315IfuacH1WCvSp9YVVi9f7DYPbudGV+/fTqkgH6RiANgtDDsWlCQZVqZstnEffRiEm2TqFGLUKL4E3Zi5juWFrOfNB8UnJyuclv3TYrdoiEWawdlJXi023d7aH15RvPvms3SV3TX6XYgGQVkFwK4jztjvb6WjgW40KkR498TntLazbYQzyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(376002)(136003)(346002)(4326008)(4744005)(86362001)(8936002)(66556008)(83380400001)(5660300002)(2906002)(478600001)(316002)(6636002)(52116002)(186003)(1076003)(16526019)(55016002)(9686003)(7696005)(6506007)(6862004)(8676002)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5SLEa14uRFS7hMDmZ4D1JJPc8vdQi/tx1oG+iprrCcsbYru2lpvqEx29yMWl?=
 =?us-ascii?Q?SpqFKpVvZHh6pUJRWv1s9z3oihWtFuCfA8E2PDKEEDpc2xU5G5hUOMghqOjn?=
 =?us-ascii?Q?hoc5Pi5zDLtnoJaSi4x+E2wg6pwaJCqd5oobKHBWxhkjNJx0NFQKLwRRJM4c?=
 =?us-ascii?Q?ANPLxOaEl/LfRx/fS9327Vp+7A7GYzc+zkNuYNTTovtEw4Um513fH0mJkjdf?=
 =?us-ascii?Q?ymgiYeggYJ4lO3fi8fPqvGoa7f4Tq9vkiQGuX/0k3iBR5r8wsWC3vscTRu1F?=
 =?us-ascii?Q?2ziXOCDHda1IyMt6U5sC+10ad9RgC6RpWkJ8QiPY3PpNK0bLso+NHFSq1wxL?=
 =?us-ascii?Q?oUNHi0fjixmjZfT6/UfaiEPw4XsOjhGXy7UZWJcVzL6AkHWiHcDwWQMh+Zl/?=
 =?us-ascii?Q?6rY0ji/DS9lXPib6eij2Ol5xDkk9WMx0Z957h9gceQm/HF1QrVGe+axc1tnt?=
 =?us-ascii?Q?owOPwpEFr8hw3pFHxCXjQOi0D4Ed/7gBy1NBtykQxp/UE2Nr3KWMQLVFgIWi?=
 =?us-ascii?Q?lbTtpfSt12Y0AYIU/9QXcaQ+0c7pjR+ZTsTSYVz3Olzd8o3xvOKvJrMYgNQE?=
 =?us-ascii?Q?lZL9uzf4C/2AaqEa4s8ntGBnttpODx0muqg7bh1nzDJbHXqYKLXo8GGXe4Lj?=
 =?us-ascii?Q?HP9fmBunltQaUAdAueM/oYQwkhRyax5QNUFSlevJa7aantWGO/S7h0ceUv3l?=
 =?us-ascii?Q?L2D/bkokb7J3lHDnlFdE8CP9tHnrfifu3YhmCWNg/nCNf/AqSmxT1U5w5kzq?=
 =?us-ascii?Q?WyY0l+XPgtkHvikMvac1KB2xAZGEzHBL77cQgynuSVNDK6SbQpsae77kQnPS?=
 =?us-ascii?Q?eV3Fo+UkCSstGpGLNs0CnfX52fSBAyKDgg95TcCVzd/2j4RDC09PkSnHGEfg?=
 =?us-ascii?Q?unDYbZU9OQtQIBQf3NGiB0b8F56ZlH8bWq9kOTYvPmfkLnAXQHsyvWpAnJDg?=
 =?us-ascii?Q?/+UqIS4s5b6OtVgb5+uoApfZNNJ+eF31lNpMKQebTyEd9FCk0B3d5nc8GH9v?=
 =?us-ascii?Q?dURX8jxP+0i3dNGcpSzONchRVZsK+Mc/sU8mNQ8MK8t1QfEFA7SVmWF6yzQJ?=
 =?us-ascii?Q?Blo3uEmeExUKX+ZD4t6G/qzOieLvHiCPbUGTRI/2thlqxBpwN6oYZB2XKrwI?=
 =?us-ascii?Q?ZhSgs+QMscQBogt/+oZwcBdL/jb93Hae+KeTwoLn5YA0G0dj/MM5JrNqbD8A?=
 =?us-ascii?Q?Q9IIB7BsR6VSxSJtR/uwPlHiY1WctYvPBjipcTRy+VY9BGzu9Y9rXBb/oiT/?=
 =?us-ascii?Q?hGsrFnsZyfrGwcrKMScZRn0i8FPaUQHGsdZbjp/5eT45FOydRtVd3AdSedJY?=
 =?us-ascii?Q?L1SzVOCBkfuN1h1P+QlvnAYgomwUGiSOxlQRkh+l6qxbDAk5ua0ACCZj1q8K?=
 =?us-ascii?Q?LaHyIIo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95d911f4-1853-4e75-fadd-08d8d9e9fd20
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 00:03:47.2778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R7KasNzkGzhI3iY5HrRhSS4x4S3e6vzadn4SQsVPZjHaH7IRjHjKY4qJnN67Fte5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3569
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_15:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=717 phishscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102250183
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 03:43:13PM -0800, Song Liu wrote:
> This set enables task local storage for non-BPF_LSM programs.
> 
> It is common for tracing BPF program to access per-task data. Currently,
> these data are stored in hash tables with pid as the key. In
> bcc/libbpftools [1], 9 out of 23 tools use such hash tables. However,
> hash table is not ideal for many use case. Task local storage provides
> better usability and performance for BPF programs. Please refer to 6/6 for
> some performance comparison of task local storage vs. hash table.
Thanks for the patches.

Acked-by: Martin KaFai Lau <kafai@fb.com>
