Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D3E323354
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 22:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhBWVes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 16:34:48 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4326 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233166AbhBWVek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 16:34:40 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NLNr1t000516;
        Tue, 23 Feb 2021 13:33:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=I0CzqscYbwyVHpaoNLHXAa9wbtIvGHiOrYCUNEE1auM=;
 b=TbBcL1Jh73sr++qxCLJ7jo+BdqYhtiBh/OwajeqwNgv9vCpo93ENTcVatldgZY6UTO7O
 6phKTGNn5LMd/gkURlZWw2dEKW321HqSfWKLDgsFRwuo/Rgy0uBHrrKM3c9oBrfxcZ4A
 cD9gV0BZW1XPFiuk8Zrksat7f4Edq51fuwU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36vx7aktwb-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Feb 2021 13:33:40 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Feb 2021 13:33:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBEDQNXBQT8IwijdVdoiRy+rwB14qJ1GtsoTWtDngYYiEzThjv/cTITi3+S46Junk3fKy2SDvyNoDJr7WhtRjCjRubLx+bVklVM8K8diIWDzCZrOraZv6gYT0DuOfZaOznxOGoWYdH312NamAsJzmGG4gZyCTWsqut82AOsbybqb3y4/dKXFnfCPfAoqeDjJSaswdEzognhPI3onmZMPh8E5BxxXnHSY146nor9zSwYJz0e38eVyqUOkXQe9sLyWaWzaUcehde4g6MmRvxlbkrXe/L4DhN7xw1uOPy1d0KYnwGRb1aecY048C8OZBEg7VU7lvRjndpwQBucM0uRaRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0CzqscYbwyVHpaoNLHXAa9wbtIvGHiOrYCUNEE1auM=;
 b=Lf2fYXt0nyxoYilzPqCPcBIQxDJmjQg7iHVE1U856CJNHgDo1nOjhmNcPt9lR3fYIKdvgBcboeHwJU/HH4ZZs/ahl3JsIPFwBCQwFtl1B7c8GRlwesHHiCnFIFK7R2cXTVDLqzYXeWBV58gKdMBCSx9E55TD/vSU+CK4FxUfB+VOyaUsKfA01mBLIfYMUThjqidQSTzkXdCsaA9M3SQexHRRnNTBUA0DT2xeulFAkBbgfBFoNbX6oCD/x4W1zma+jF3sbbqkveDFp8ON3tyc65RnN8DTDhNo/39C3DvsI9U7pejb3BKkShuSAoKDXLxqOsoCEtW2f1oivDlHweFLqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3189.namprd15.prod.outlook.com (2603:10b6:a03:103::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Tue, 23 Feb
 2021 21:33:31 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3868.032; Tue, 23 Feb 2021
 21:33:31 +0000
Date:   Tue, 23 Feb 2021 13:33:28 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <peterz@infradead.org>, Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH v4 bpf-next 6/6] bpf: runqslower: use task local storage
Message-ID: <20210223213328.muxp4vaexg7ahtmn@kafai-mbp.dhcp.thefacebook.com>
References: <20210223012014.2087583-1-songliubraving@fb.com>
 <20210223012014.2087583-7-songliubraving@fb.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210223012014.2087583-7-songliubraving@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:512c]
X-ClientProxiedBy: MW2PR16CA0043.namprd16.prod.outlook.com
 (2603:10b6:907:1::20) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:512c) by MW2PR16CA0043.namprd16.prod.outlook.com (2603:10b6:907:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 23 Feb 2021 21:33:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c14ac379-c8c7-4f1c-4440-08d8d842aa66
X-MS-TrafficTypeDiagnostic: BYAPR15MB3189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB31891B5C3BEAF6AD13C7C061D5809@BYAPR15MB3189.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Acby/fWT0M5mQ6wLN4drfkGF+tAw1xUpyPGRxKdDuQAC972m9FeUJ1YcA+vsPAlfMXAHGwDJlwFUe+4hRcpuDSuzR5FeTisz3Nc6ezHLHQWHUnmPBV4SCZHYmN1vAEatUIe+J6w5JQ43ZITzYQywR5oOILhoze/hWVy2yINED+KxELNQJ/hjY2dhNqcOPjHXnGR3DLQs/bbn5ybt4RXC7bOAeviG0BwN+fS0fz0zKIMDhQZQlBpubCarO2gBxI+/K6EzL402w+EVsryFtODbEOAy8Z5u4d8+P/W+QW12tOlCG7vs412wJfk2Habk1jQRlBhITIU9Ho355r3ZqdRyYB/D40W4RJChfPCRWP6qRE9D0lwksdsQURVAmY40nMsqjVvBmPjl5pFvflAP5dBj1xkLNRdDYoQbnQSKauZQFegbaasTyNnxi92372iKBfz+gfxZi8cCBMU0UMpMifbz4FD8ISqgjb5BDb0JUZmgGL0cBOTSjq5zMNuKF8aGFVkHh1h8Whsf8RDR42xrPY+dQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(136003)(346002)(478600001)(66556008)(8676002)(1076003)(52116002)(7696005)(2906002)(4744005)(6862004)(6636002)(66946007)(5660300002)(66476007)(8936002)(9686003)(86362001)(6506007)(316002)(55016002)(186003)(16526019)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eF2mxIU/TxsvChoS90AZijmMCK3XlNGx8xRud+NJqZGn4vlxJgRSvNeq6VNV?=
 =?us-ascii?Q?kiia1gm27e9MHLbOrbYU0LgtUmGkmnHyYmGbnY+w3yRrxV5IfoWkyT4rMcYl?=
 =?us-ascii?Q?Bf1c9Z2BNB9STaN0Gt5dnSNtIJQA6f3athF0+6ZM8yp07QVQG9wEViPHVPyf?=
 =?us-ascii?Q?o+keaWdya3ZC3XRkTlztZ8D6ZWjWaG9yAw3u+jLyudas4IXu+Kgel/BQzXid?=
 =?us-ascii?Q?BFGFi+aNnzSO8pGPFNPvpBM/UVbOB4HrIvAElDWMEW5zUutdn8QF+1+9+5UF?=
 =?us-ascii?Q?E/CsP6BRnPjxvqNNfCbV56rOm9UO0yvKgNCdmrcmAaB5JrdmyDgz/RQz8jDH?=
 =?us-ascii?Q?8ROddP717ZoL/1dhYZ0PIuLdQJXdNxV9XTwp+Bvu4u3imbYosOIFQIVUBGS8?=
 =?us-ascii?Q?sPhZiJtjFksp4ssn5AmnX+UGRXuvcTZWPfZD+R+IGJO9CpFQ8T2LaCsO07CM?=
 =?us-ascii?Q?aXcb96BAq8BXBNuv38HTqMThOrj1KPGrMI9krQyJY96dav9WTTH1ToXdCjwW?=
 =?us-ascii?Q?V3ejhjAQwg0hy/w2Q7d4z4RTkDVG42x+kGFVNMYvF/N7VFhJwot225PDnuLM?=
 =?us-ascii?Q?dFM9lQpx+xmw9uPNFSzsNh6Tc3BksiERsn6lIPFbJkN42ADZ/Y9NcIetif0b?=
 =?us-ascii?Q?RqxLGGmE27I2Uq7LxNAfYFpqJ4yNRTm0rJNZqlBnB4n7h5nouaz7u8+6ZDXT?=
 =?us-ascii?Q?pDePlmOc751H90daeGBOkaCFbzsGzLvQ72wLrjGFndhM+rfh/+8QpFRVjHCT?=
 =?us-ascii?Q?9XJpsAWPk+sElwtJCuM9Iiu5iNmW13pUQRNLQ1SHuOxHJfcWf2ZY6LQbOFXa?=
 =?us-ascii?Q?cRFa3NFq99cnXnTE9ouDPhA9Sxihyn49hnJC8KPmGedvEspjs0bqpF24hcRi?=
 =?us-ascii?Q?Cu11XaMEe9OrhNrQPo5o1lG7bOaPPgVzTqsD+6/wBD1uDmEsE1PP42oTd4KD?=
 =?us-ascii?Q?oBWZ88tigwq3Vvi7599Ge6QYgx4zthFkzOgrbkINXjvZO5vx3Ep5RS0qGlMw?=
 =?us-ascii?Q?dQxSwQHHiAuilknoAd0E414Z1yIcL5Rvd/hSr3MePPL8gxBnx/7xsLULZIaV?=
 =?us-ascii?Q?7AC33RrjYIUoCBIjWwhYPK8EQNzVm98fRDvfQ26/ojfspEj2sjxAptl3Hu+u?=
 =?us-ascii?Q?yvcLzATK0WkPRihHiwaPv8CZVGGvUd3iS79I7uU6CYfm/Rmj4U5h+c78oeB7?=
 =?us-ascii?Q?UJHSG+IKxBN/Mpc5Zda2AyL7puhiJhi0DgLGLBq0tFq67GQNmzpVERIhK0dp?=
 =?us-ascii?Q?aXq1xOcjXQfnVycMdZrBX+X6hcjzCwCA/n3FVeSivGZfLVfDKyuaJcQPSo+j?=
 =?us-ascii?Q?Vv+ktuGb+fFTpFlbPCPU5evjJdhfscGphdTFyJUr5/WgM6ANZuqd4a0EFHVk?=
 =?us-ascii?Q?z7iLo6g=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c14ac379-c8c7-4f1c-4440-08d8d842aa66
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 21:33:31.2694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+rnTjKDWJ7usoXWrKUGPyCCzIUYMpdlxlDacZyF8b4iZx7F4wGBpyakaFCC/JR9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3189
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_11:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 mlxlogscore=751 phishscore=0 impostorscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230181
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 05:20:14PM -0800, Song Liu wrote:
> Replace hashtab with task local storage in runqslower. This improves the
> performance of these BPF programs. The following table summarizes average
> runtime of these programs, in nanoseconds:
> 
>                           task-local   hash-prealloc   hash-no-prealloc
> handle__sched_wakeup             125             340               3124
> handle__sched_wakeup_new        2812            1510               2998
> handle__sched_switch             151             208                991
Nice!  The required code change is also minimal.
