Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9D63414F5
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 06:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbhCSFkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 01:40:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36590 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233730AbhCSFkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 01:40:23 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12J5cr7t022725;
        Thu, 18 Mar 2021 22:40:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=/z+RltMLk5wH/MM+dPao6K9T4AJklJ4FJwqY+SM1KWU=;
 b=a0kG7JB89Q+t/yOK7744OfmmcxUmJeYk2LlNvXzrUotru5JnpFTN03HcLJ9n/oVL9HKc
 yMbowj44nldC3BBoKMFvlFGchy7zITMpZhXSgpNIaFWx6YWpXqjHdEl1J0C6BFE3XV1U
 LpuJPdMUj4/ppyL8X62EuINdZlA9cUjU964= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37bs1eru0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Mar 2021 22:40:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 22:40:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXVs3lym4O7go2ShfOFFEoSjQgaBnFCDaC02bVh3SvQKudIdA+N3vGIwd6Dt/IWwNcY4gMGEA8zze9W4egwz2okLxV+eMz+dC5PpTt7YzWnywUl3IyzsfeRX2/yiyNZ6ozDEzCs4jLi4FyjqsF7lH160nrLXdrm2FdFbre9sSRPFWJ8OBiYtZ/i0XZHL6WlpdkMTTAYYL1+7BJT9+zJMd8CBFjy9hXZVP1WGO+Zyj8m0pFDqzlFsx2UevzzhMZFsqC7GHNY+x1Zil6SmZQW0m2mERVX72PwQWQPRgqLiiu69CHjfQ/yzieZL3UUf+DLcKY5iwRMz+3i+nNR9ZVLJrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/z+RltMLk5wH/MM+dPao6K9T4AJklJ4FJwqY+SM1KWU=;
 b=bqVTpnUn2LMbvVqNKKVyzXt6EzEn6bvyOqKvcgDCVzkhSpZpoNwg1NieDheNevbe9dk49IGliyp6QGYQsGaFtQd6oMypDbvwpD0JksahhFqp+kWcizP6KGnHQjdNFOqUyaBEUR9ZTFKiWDJjPbP/8exdPgTTNCFPBnFSV7FtvCANOKUSJKOIOqMhkR6h6ClHPdCfSgxdw3Jm7ylbi/VsQOnM1zXzY/nM1za+MGhCsVMQNISFv6KFdkF0s1gZBHXe98T3waeCdqphOSzrcmKepEL2G6bKpD/bhF4IBbByj6TFtyyLcex0A4e8uxfY7BWaImXr/l+qaL8igyAXY5Q0mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4421.namprd15.prod.outlook.com (2603:10b6:a03:372::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 05:40:07 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 05:40:07 +0000
Date:   Thu, 18 Mar 2021 22:40:05 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 15/15] bpf: selftest: Add kfunc_call test
Message-ID: <20210319054005.xyc46k465wmglgm3@kafai-mbp.dhcp.thefacebook.com>
References: <20210316011336.4173585-1-kafai@fb.com>
 <20210316011510.4181765-1-kafai@fb.com>
 <CAEf4BzaGAbOSGGySyid22bzBbLJuBz+yYK6JmTBzuLYAZv__7Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4BzaGAbOSGGySyid22bzBbLJuBz+yYK6JmTBzuLYAZv__7Q@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:2c43]
X-ClientProxiedBy: BY5PR17CA0023.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::36) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:2c43) by BY5PR17CA0023.namprd17.prod.outlook.com (2603:10b6:a03:1b8::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 05:40:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f8d4c0d-d17a-40e9-4c69-08d8ea99740e
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4421FE1AA5ACAEDD38CFE465D5689@SJ0PR15MB4421.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M+TjS2ZaHMyKj4qJYMneQq4XhrT3QZe+dCDo+rklKyvKD7YqiMXtllLkuXLMtCfLo0itOv8ThZrn+1AP4HZzDNExc6wINN99GCselwPyMgBSWYmsmYOrKK2D1WIrX2zaN6EPcIuAhxEf+jbnjiaAAFuStumqr2dm29Cm/0mzTbXz5niFAsTYgxLkm5TabWvrsnxcypPajiI5RZAM9eA8CCsngoPZm7R9qyhNb/6KlrhGHjTKGL3PVf9KLaIE/wDPD1wVONDWJbRlfTrAb+sgRa001uYKf3b24h2AVdPGClajachcDGOBur3Z410R4OpuJFZYBklt6dhZ1jVumW5JjDanvfY9pN+AW7+xCn3x1agtJIhMScu8uRyWinov82nJ65iiGFWSPeFvVazxVph0KRHgHozz2oOoF6PBBhIYKSXWHU4dANCzbeMdsuBQGbKNj+D4h7WQwTEWcSP87S4AYa5SMbwOF664sonXq857MkOvvfRBDreOCGQ2GtPRsfMCXF2IiZF3Q8nEa1CrDKF5cpZs/Ep70GkRjNlDU1KkD4v0qx6KoXA7W4djPSH4sQ7RWrNR9GYG9Bh3aPmNInrGthMXssz8VGehkCGSCZBOl5whqRlhckfFNkuYBk9bMicW2Kk3ugl8lku3ZPORamodvQwpsiDuxGHVebFvWEEMDbE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(136003)(376002)(396003)(52116002)(5660300002)(86362001)(7696005)(4744005)(186003)(66556008)(1076003)(54906003)(6506007)(83380400001)(55016002)(16526019)(2906002)(66946007)(8936002)(6916009)(9686003)(4326008)(316002)(66476007)(478600001)(8676002)(38100700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?I3yp2qk5Ldg3Ey2zzhdIqTcL0Fs1fVQCJXiQPlH3+7+490UsNOAb7tpwD3l9?=
 =?us-ascii?Q?yCJ9+wabcW6dPgq59Z48iSKu9M8uc1vUR7fUxcNJH2J1UILZ0Kcin2qZF4z+?=
 =?us-ascii?Q?7obtTUrLFneNRr8HkSH4tWbZbBcuFLH3dtxOEdN2cBlNIpmQ88wXEAmiLvQ+?=
 =?us-ascii?Q?QRC2o7e4YqPaeFH8eEpiLqLidcVSIKDFD2TH9lcGSiUzeoTzR9D1huayQ74a?=
 =?us-ascii?Q?kMSfCj7u8gBcA44b9y37EadJXYffWWF3s1T2Z6BB1Yg5q+GcbpQUBBXZR1Jt?=
 =?us-ascii?Q?RxZ4ECHhE9P44AKKyCbSUhAuJExp028qVxlXinz7plYoX1y6GHtBEQoiRKqO?=
 =?us-ascii?Q?/owoNYibSa3tP5iDTQsLhGGpGSts88P2x1ZIgGuW2LEE5mptxrm1rHVMTRBl?=
 =?us-ascii?Q?3lKm2ZUokLaAIJs+Si21lbKR/POvy6QKpAtG22YqJXGB9hj+EM/CTwTxBMTC?=
 =?us-ascii?Q?BW0RQLQkv1AnlOWrBLQFPDiyDw0SCqB+n355o3MsH7x/we68ZpULs9T4cBVK?=
 =?us-ascii?Q?M6Pb7gJ9sO8NeUa48hyPr2YaKj7YKYRzxtoCHICvwdY4uqZljLp+iU+21qTS?=
 =?us-ascii?Q?yHYw8A+67o2707ZF5ZS9fz0mafJ7OM8qGb2lZLYcGIin3Wt9p88hY+n4TY/J?=
 =?us-ascii?Q?YoHJmQ01gwcN1gCm4Ok+6PjI5y1PvXXNtSwrTnrW4z4YBC/3HhvVVI+RTwTC?=
 =?us-ascii?Q?nrT4gKoWBaeF5IzZpiId+vvBENc2UeXOLT/+V23cb6hg/JmxOp/jrg8Cx+IB?=
 =?us-ascii?Q?vh6qHuRvikyEluCMuDOBIR1PGDRPMguyHdqp4r9zMjRYsP+uTWKF+yzIB0jK?=
 =?us-ascii?Q?Wxztq/WhkRHKd4XFpHxFIgJjv+IA86nkh4CUO8xMiNEqC2ffgF1xIojVKiAl?=
 =?us-ascii?Q?aZ/LqQl1jWIuklGEp7Me8hgGA/QKkS4eFLRDN3iyQga5vtBH0/CuNdHUI0Ey?=
 =?us-ascii?Q?mJ4PJkWijyvkAieJW6Exo+Pv25uq7t54Z/Iw8F0Hy9YQaE+dESS7e203Uvii?=
 =?us-ascii?Q?0KVvEqOi+y0gjGrKUf9azluPMSMaPIjJFYzwsr6ilyet6PSbc0npQoZy0Dc0?=
 =?us-ascii?Q?wxgGjrcjPemIJSzT0RvYLIrRGH/kuKWuSuy2LcULAPkrlCJEgju/fOKDrSRq?=
 =?us-ascii?Q?Fjm4o/9RhdbG5rfI4GdfAUauY0wdg1Z5ub72oLEbgRPQDKipM8XE80yvBgvv?=
 =?us-ascii?Q?i2EM3CFsiBpHV1d9ZEkcJo1dahTQzWM1kNDL0SW2yfnPWeBFGCk/iw7rXbrZ?=
 =?us-ascii?Q?1Z/VWbFCWR67iLz3o71dvLwSFNwnElj+sdeN8sZlLlPIbM/GZ8qsXmrx6E3e?=
 =?us-ascii?Q?kagD4Rxb/rnuvBGSnXZwRe8alvJcGnFUb7GBXnEioexyiMWmBevhJdWe4EaO?=
 =?us-ascii?Q?UpY487A=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8d4c0d-d17a-40e9-4c69-08d8ea99740e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 05:40:07.2194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: miF5wUBVcbbh747ZxMZbSwRd4MzNZ1l9zSH9s2OxM7gKKHg/7hjFSgpMv6gvst9x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4421
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_01:2021-03-17,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=974 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 09:21:08PM -0700, Andrii Nakryiko wrote:
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/kfunc_call.c
> > @@ -0,0 +1,61 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2021 Facebook */
> > +#include <test_progs.h>
> > +#include <network_helpers.h>
> > +#include "kfunc_call_test.skel.h"
> > +#include "kfunc_call_test_subprog.skel.h"
> > +
> > +static __u32 duration;
> > +
> 
> you shouldn't need it, you don't use CHECK()s
It was for bpf_prog_test_run().
Just noticed it can take NULL.  will remove in v2.
