Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CE53C1D3A
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 04:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhGICCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 22:02:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50978 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229637AbhGICCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 22:02:53 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 1691tM0E016177;
        Thu, 8 Jul 2021 18:59:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=rt5loowGf/iBuH9BztgigX4mtZKM+bpMC5J0atXUJlE=;
 b=kjshtQFG0+rSJCgVDYAM2+OTP2xcr1Q8rwQRqH0J/26rigU4txESIXkEBhkgXiRH2XHW
 0v2G+0xlaSrufD31o93mFU7tbzO8aTkEWye14c3N2FdQYegIYWsg7k0d5K9yh9SVbkec
 2ir24Z6vfBoJYYH4vM9g52zN0UbRc9pDzWI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 39navmc3p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 08 Jul 2021 18:59:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 8 Jul 2021 18:59:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iy+BCAG+p5jLB9FlR2ukJMU34ICRAwgCGS5/19vlwiVpmtTSxNlGeXxo+N39E844iweiP8V8IVhVvib2r/OJE57WvHiwoCm8Oo/fhn3SgISG6rTm2orJZb/BWjItXbudH7xFlJMxRGBvnRSsnHkBF7ZJHGKz27bvTm8NfZK+RdzceCJdKFheiNNajCmE3pq5RXlikzF0OBGW/O031Kakx4/Ovaz3QJhv27YpeeQJ4M2jXkA2spVhFmyDoNlOpF7rysfJh8lflbCwhHMRPKibMgh929lrK1wKA95Qi3RldQ2BncdajP1/gqRYKZmnZd4CluVNA9+oXEvWnidoLuwbvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rt5loowGf/iBuH9BztgigX4mtZKM+bpMC5J0atXUJlE=;
 b=Q7LuIfnyrRVLxp+hIPrm4jvghnirA+Bk9XTlCsrzu3O9X61/DxdOCrSJ02BK50hN1AwFClgOFg64wYZibsgdyh4XwUeAWfusWIIW/jGfgiCF3+jf5CAg0G9SOaR8rekm7c1v/O28PvqLjsUrVnbIO6Y1VK5k8cdVrNc5tgVDgRy/Dgc0eGuh5zVPsuxZw9g7d7j7cMJsKpYCovA3NrRhxaMvQOysZnr2QaLE3QcvxO50iNAnEbf3WkgLBHBPbwwXgcPjoPeClvCagVpVODy5gbrFyJlAjm7VPVAoexsP38NMeL8yNW3hjyxTphVb/WaTiT38SBsRT7CsOJx1/L3hzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4612.namprd15.prod.outlook.com (2603:10b6:806:19f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Fri, 9 Jul
 2021 01:59:52 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%7]) with mapi id 15.20.4287.035; Fri, 9 Jul 2021
 01:59:52 +0000
Date:   Thu, 8 Jul 2021 18:59:49 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <davem@davemloft.net>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH v5 bpf-next 00/11] bpf: Introduce BPF timers.
Message-ID: <20210709015949.afjbtppsn54ebdrr@kafai-mbp.dhcp.thefacebook.com>
References: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
X-ClientProxiedBy: BY5PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:a03:180::30) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:552d) by BY5PR13CA0017.namprd13.prod.outlook.com (2603:10b6:a03:180::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.11 via Frontend Transport; Fri, 9 Jul 2021 01:59:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d124b51f-ba6c-482a-cf34-08d9427d3d98
X-MS-TrafficTypeDiagnostic: SA1PR15MB4612:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4612ECA881CBED620FAF10E7D5189@SA1PR15MB4612.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LN06c96tblG+q//k5rL1Xw8d5bbZMx9VmF3TZYcylxRIkfC5pnCJRtzehYQjjPMaqrP5I0u1pb0fIvv1ozPA8YLLM3KP10oL7oNL3V5wUidxJisnWDdUSzwAVRhLYl8is+ABhKiOaImLeLEe7v1cD+IIIJIswRaOuEJgSu9r/DGSOOEjQi3NQh4fOk5bznvbPsX9mp42y/Nf6JC6BEIZxtuyN0T5FxnB7DASglISaSKjmQBglBuIsfZl6KQfkLHUTFQyvxFIx99xTX+8FQKO0ISYobKijKO2cNZoovNkOobok0HqS8p3Upbds69n2NkX4udwEEuyqzt3R6E9uH/CgkHAJs+a7OZmfuSmCVLlGEMBz++p3qBnQLtqZviEQF7oOLpXHr79EFcVyEbC905GN9Jph7ODDr3aLHbUv53frTySiejzgiC2LviAP/A/LkJsZvQA5aXT4/q57VyuE9WY0zlJJ3pjQLj1B33V0bLThzXKIy3Py7/VBGSOkz6j9I53UkJPzNoocOtGgQc+Wdk46Yh1RZx8y9fW/AGxf6JWG1CPy9OiKmaR+7UWlURSFr6pSJvKBWRCsRObR2jMcA8jsxZ48oKqmUx+MKVKbZnhGI1V1I6r8/AuEHQo+IhkHmT67sYvTx9wlkXU2I0oxxLoKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(6916009)(1076003)(66556008)(66476007)(9686003)(52116002)(55016002)(7696005)(316002)(5660300002)(4326008)(66946007)(86362001)(8936002)(6506007)(186003)(8676002)(2906002)(38100700002)(478600001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tgvMrnn7dDRCU79H4q1FyU1ToNrOFov/wxt80EIUzjYSUe+nklrTzvL6AQm5?=
 =?us-ascii?Q?zz6dwlYc8XzTw7vAKg2qgPweH4mRN5IjmAuzqpzNGKMEaEsXMR8tKvfgwONz?=
 =?us-ascii?Q?5qqZAAWul8b78Xj0PdyLY92EqzzWfiKzA3wI8nNvqVWfb/0R+m7jDbUdJUX8?=
 =?us-ascii?Q?Rj0ciWJMR00RE6iWcdI2qMT8iTAp+l1lmw6Gs06WCYq0nh9xS+/tNwzLQMv7?=
 =?us-ascii?Q?i23w/o5FaT9fltXpM2cXf14KWlPELVT/b5302wKi7gkAJLFZSak8VmSYttnm?=
 =?us-ascii?Q?TaorKIH9yKa0P9UbBJ/zNF3MGsztbihTG45D7WdV9FHYIjIAmMN087+9Z6cv?=
 =?us-ascii?Q?ov4Qo6ljd44DIocVvQO6K5YdJg9RWJ9SoElhQXa7FwnMmCQlMLlSiLUhIBDD?=
 =?us-ascii?Q?Ow8gGEW6dSQNV2Jv+03rLZSAZdxoEA0vuBzGanOBixlxzcRFhcqiZooRPAJx?=
 =?us-ascii?Q?Fl4X70qr0lqE0TpCao3GBxYhp55kMyfiCPbLp2c+onH35y+VpIwmPmCdlfnn?=
 =?us-ascii?Q?n8ijgqFxg89mCuEMjz6KWGIPbyd+3SbC6BEI3Xe6FIHUADC1zNIo9p7luC8K?=
 =?us-ascii?Q?riPbxEYaHK6ISDY5v3NPD1XTx68kkfmBkCDdsEUK6nANGsxjsH2InSRsH08l?=
 =?us-ascii?Q?9Sbu51m4ZX7Hr048wzZgQ66bhVjQL8O8btXkbdbvo6FLtPtmKXCI/i8zJ70q?=
 =?us-ascii?Q?9DWmFg+vLDrNhD6s8pLsBX+bGkC1XCPdJU4B8/6MJUr44L8t+VRWpDHgQaVy?=
 =?us-ascii?Q?F7EOEM81r0bRo+kiF76ZncpCejPW/VUyzxjWTQ8Dd9tu1yl4O5g2bx88QzUA?=
 =?us-ascii?Q?BvmeUbA5mN0+FMcuvmt1q5ap7Y38JSbIy49YeMYPV3Pv6tjDf/vNa2usYbvi?=
 =?us-ascii?Q?sejZfBp/pxIkBYjpudAEekcqXFlAH7RjScTCz2RVqMmPZzGZLiRh617d8yV5?=
 =?us-ascii?Q?N39X8/Mc8xc4h9uyv4NO8J1tC23rpLvsEEsBw0HvJuSby21dsR/rUrkAUOd/?=
 =?us-ascii?Q?hzgkWusCaTMjPQjdMIHSfV/CYbWXx123Tq7zrt3r74yDSN7IJmtCO6sDUvEB?=
 =?us-ascii?Q?ufvH+99DvaroSFLZM70OFSsy69DO+BrbEfOtXXyBBhXrohWJY8Q17vVKU7pd?=
 =?us-ascii?Q?sG0qYWNnnYm23MjnOVdOGE1P88+A+ef18Gy/TCexzssvPXJSEIUESqx0Vuos?=
 =?us-ascii?Q?5OG7VKWejtmvvKM8FkN1KatsPYaGnnTyfrLxtJyBtqGncsnp9tIGIhFjFHYm?=
 =?us-ascii?Q?rzTJ/TiOCazAnbXpXYM3SWMPeZ0JFeLGv0VSPI/3JoUFp77vsaxapa715ASx?=
 =?us-ascii?Q?pkkOcOBLB/gqTg1scVk7IkCX+blahfqQc9O59XNliglf1Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d124b51f-ba6c-482a-cf34-08d9427d3d98
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 01:59:52.2739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k4RXczg6fywUbs1Rt5u0nktorRJUke9cPlcf2DoZq8nRlUQGYsiV0iYgTylo+hbc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4612
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: NJdDXiuM9pLUiVtj-83qdxNwkqoJt4dA
X-Proofpoint-GUID: NJdDXiuM9pLUiVtj-83qdxNwkqoJt4dA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-09_01:2021-07-09,2021-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 mlxscore=0 mlxlogscore=723 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107090008
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 06:18:22PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The first request to support timers in bpf was made in 2013 before sys_bpf syscall
> was added. That use case was periodic sampling. It was address with attaching
> bpf programs to perf_events. Then during XDP development the timers were requested
> to do garbage collection and health checks. They were worked around by implementing
> timers in user space and triggering progs with BPF_PROG_RUN command.
> The user space timers and perf_event+bpf timers are not armed by the bpf program.
> They're done asynchronously vs program execution. The XDP program cannot send a
> packet and arm the timer at the same time. The tracing prog cannot record an
> event and arm the timer right away. This large class of use cases remained
> unaddressed. The jiffy based and hrtimer based timers are essential part of the
> kernel development and with this patch set the hrtimer based timers will be
> available to bpf programs.
> 
> TLDR: bpf timers is a wrapper of hrtimers with all the extra safety added
> to make sure bpf progs cannot crash the kernel.
Looked more closely from 1-6.  Left minor comments in patch 4.
The later verifier changes make sense to me but I won't be very useful there.

lgtm overall,

Acked-by: Martin KaFai Lau <kafai@fb.com>
