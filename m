Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DA03B9C26
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 08:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhGBG0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 02:26:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39708 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229542AbhGBG0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 02:26:42 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 1626Ncgj006837;
        Thu, 1 Jul 2021 23:23:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=4AJaQMUHhKzOdTh+Wfr2+fQLoywU7NT/K6vczlos0pw=;
 b=nQ6dhzTAoBJD7oE1YVycwEL6pZrYVUX6iLyoKiHrrbBxllBEytCLhc9QpgW3+ACW8TSt
 4Ulsz3WovFw1lv8EgDVYXw9YnbXF+qz8HbuE9uwI3M/JWxg2Q+i+ivI62v7y520rZBFe
 bvVFeQ34AHusxWnGSLkTvZ8e4n65BxwLeO0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 39gt4j404t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 01 Jul 2021 23:23:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 23:23:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NHXBmMcNPN0wFM0DPkJh9L5gt2mBOLKFVNYf1aDAcVIjCDEqq10ztV/C0SEeClSt+EsQmyhX9WxMN+AQ5PfYwfcC4EBxpurltZci5hUOZNt8B124vaxJ1vq/yTfN6qMBQWL5qliPU2NqG2sYaTAa3ggZvZRKVglrMZ04nhDcDUGyoCtgyT1QGEn2KRS81teB5UIxS3S0wfFDjw25bjObHMNJ0JJecJ3/+X7xyShIWfuI2aabxPPwGFlmg695t4WloQvMu5t36AI3FxPS4C78xkq72gEUwyYG3glgV4RHoA6FJhJv5Bzb9Qva8Dj+omNdgcvp6lte/0yMmEs2lMaLOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AJaQMUHhKzOdTh+Wfr2+fQLoywU7NT/K6vczlos0pw=;
 b=dK5SGaChrr/kuSXmLEFqafuCylAFbyuf5aol8NuJ9XAbCwVVWCFxqGPK+I/HYkaf4woW1we9pZCsUqADkrkffsKbx2B3kxYg8Wxn0n1Vhg9+u07PZStYqgkoXZm8wwSTYqtPt7J9wHGLXv17AsupVSC0MMuJSAcjLnGAMndAU2z4o77xF7yYOVGKlW9A66clFNLzG0YEIEnqvPxiR7+OzW7nx9p6jx6zvCHjE+WPk1puvZbh4IOI8dimmlVUi7gk0J9uwAKHCmub1/Vb0KgdHeq74ayXAUBX7lnBqN+B6bBmEJMEueL+oRWKNOo8ZvdeOVGK+I3f1sEG44vv1VNSng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB5047.namprd15.prod.outlook.com (2603:10b6:806:1da::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Fri, 2 Jul
 2021 06:23:47 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%7]) with mapi id 15.20.4287.024; Fri, 2 Jul 2021
 06:23:47 +0000
Date:   Thu, 1 Jul 2021 23:23:43 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <davem@davemloft.net>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 2/9] bpf: Add map side support for bpf timers.
Message-ID: <20210702062343.dblrnycfwzjch6py@kafai-mbp.dhcp.thefacebook.com>
References: <20210701192044.78034-1-alexei.starovoitov@gmail.com>
 <20210701192044.78034-3-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210701192044.78034-3-alexei.starovoitov@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:6d89]
X-ClientProxiedBy: CO2PR18CA0058.namprd18.prod.outlook.com
 (2603:10b6:104:2::26) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:6d89) by CO2PR18CA0058.namprd18.prod.outlook.com (2603:10b6:104:2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21 via Frontend Transport; Fri, 2 Jul 2021 06:23:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39c56faa-af46-4f69-c0b2-08d93d21f342
X-MS-TrafficTypeDiagnostic: SA1PR15MB5047:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB5047E687A493821946ADD941D51F9@SA1PR15MB5047.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nMZLZL1hEom9gcwPZPvAqT6sgAgZhzTf2/5p4IQloDE1dAXJ3wNZ7IHn2VyOh+n2dB/g9cWik8KOF7JUMnu2BGx/CMakZ9eDre2F4kUaN9/PWPMt6O4vzLPl16/HEwe2CVaQ2OnXJ5X+cLNpwpyq0Jkma5vOdUDpI/XBMZY08Ck9CpnB9ir4vdK+3O3opHFIlbz6BDzCxbSHLQdKs+zUpNggh7jWJsVEibw3DXoGoMTWrGtAb5nU6G9IBi+v9sffNH863BEUTu0wxoRXrd70MM1YB4SQ+Vk902g7CyLynRo+7JevoPdJxf+bZxQQf2fxKlb2bMEuUty7jZ0SOuw/ugeTxoOZp1GtdvFmT2nbf2r+SimTpiIMOKcZbfkcPCLmsRYzddVczozBinWcCVpSZijpPfwKOu9TFtz8PRG6N1fOwy1FLLnAXpAwwPr8KpP/0EYYWGDAYBOUqsuXldCzBGep1Ab9r0c6KPdD6C2c7BeQqiZPSCE9njztd+VPQ5x4xqdU2l0p70lJpzNrdjrJpcJlqmRN/khh3/a7NZqRnh68cf0IBBZ/7GyiShTdObnQmlPAGy6DsVZG5gfcg7SLnD6zCAQfKvPoEgJ+tg3T5iMERjyeWt63sWeSXsWDyWUbqoiPl3aasxrSVuGZ6PnVwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(66556008)(8676002)(316002)(66476007)(4326008)(9686003)(86362001)(2906002)(1076003)(66946007)(6916009)(5660300002)(55016002)(186003)(6666004)(6506007)(52116002)(478600001)(38100700002)(7696005)(8936002)(16526019)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rUBp5yQU1vXUeWjSSUW3SCw6uYzd/r8Txz6H7dOnwyXDdEXtIirxLJecM8nO?=
 =?us-ascii?Q?alFJM9ElEvQ8zZq+JcPTGtDrIfDqL8UpqZ6XlnbrMlTETbgYGuo+u13ae2s5?=
 =?us-ascii?Q?t8vrDywsbNnJoM//dz+WLyfS47joV6otibv3BxfXcnhLxHAu66qnZ2EkdnJZ?=
 =?us-ascii?Q?E/OS4Ihdj6tXMOWP7Qn6YfNWZktcNJbQp09kSBFt6/HgWwpiHfMx2RN1YBPp?=
 =?us-ascii?Q?XLZQQMS2s/Pi/yYYXwp0aNKr5g/u65HML9p8yWmA8YBKvy5HiCHSLATaHiJf?=
 =?us-ascii?Q?Zmru8ANLPXcuxQlIK8Y4lB9Y+8h12rRZI+sHSoBSvemD5yf2VM33rwZezCDa?=
 =?us-ascii?Q?wtTtsG1CkzxOAj1X8O01M5ZY5a8iVweievnHY4CfNjaliQceXGc67Po6n+Lt?=
 =?us-ascii?Q?yFdU1VXMYWO1+Cd62PJpc0PGl8tTOtmXNUUTcnCGAuSqrgI+2LXX57jUmTOI?=
 =?us-ascii?Q?h7iPwF1xrYXpXjwdtvFaF8sOcXqzwnw2eJfokAr0TOw7AbqcKRbIg+d9Ix05?=
 =?us-ascii?Q?3c3p8pX7rVX5r2AsRBtM/VRp7VYPVMvhBmaj9PDLoaxPTpOFhadzbvrVP6Sn?=
 =?us-ascii?Q?e5ee2/t1qi8M2FsvCeL1zAcu1+9prt6Fhm8NrMBv8kXJI0IihZse2eneaG6I?=
 =?us-ascii?Q?0vlNeH9s0wBRG+NK+UWi3ryqUFEIViVAfVMHj6GzdfiL/BIicJNJIYgVxtBB?=
 =?us-ascii?Q?cM6ggcU827HumOYp+5X9KrgHzJipefe4cDkgumV6lg73rYw1zMfLlUfXaCi4?=
 =?us-ascii?Q?oqG3EqBksUrD/wdwCbAsfqq6VqVsGebIF1X7ARBSaB1HGzuPDF0tA4jis2/W?=
 =?us-ascii?Q?Td2AgUbiMVPJ4ISMwHuTtncG4elEc1yOsU2M3UN1IQJGsdbIMxXPFtE4/HqC?=
 =?us-ascii?Q?N+zpCfTbEk7VI2tc9P5UKXlTb+cgp4Du50K3i1nNBIlFLh6Dv/i2ME0sYQ/x?=
 =?us-ascii?Q?e9vi5Xm5iUc+W1Cvxw8Y8qSyR9SC9YGCUMjFEK5XHZYiGhKUnXi3PVpvGwIR?=
 =?us-ascii?Q?MKKEhvTz5eO4+EeAZQNQOyp+gMmil8tgfY3SnmKndnuquPZAibOrvEs28Si3?=
 =?us-ascii?Q?tyCxeJO1quVhm52wHyzB8jKeLW1xUHdsqmuA40pw5nTAI1W88rs31UjRMiGQ?=
 =?us-ascii?Q?OmHy/fXrXeAIbb44/QOTK6fzcgPfdrxOXZphudrvp7Ztma6L8/9Snn6IwtV3?=
 =?us-ascii?Q?T/2JmC4C+9qXj5ptE53flowIK2gQ2G/PsR8cvdYF8Of4M2k6sUdn1GULfdB/?=
 =?us-ascii?Q?u3gMtk0twVGUJsROGDe9dqk81dRpoBcQvYqPqT7NPqjAdPSqzoMeSNd8O2Yq?=
 =?us-ascii?Q?J5cNaYtP5j9auDfI8eE/yQCgCXls8vGJ7vYiDv+Zm/A5FQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39c56faa-af46-4f69-c0b2-08d93d21f342
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 06:23:47.6209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AAm2KVZt0YWEZb9ApulCkPkFpCilbmNo5iy5Im35MQ2oZ83BNBJxhKDznpS0UZt1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5047
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: NCxMV33haGXyK4ZbeMYg4h_zZ5c63JcP
X-Proofpoint-ORIG-GUID: NCxMV33haGXyK4ZbeMYg4h_zZ5c63JcP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-01_15:2021-07-01,2021-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=930 clxscore=1015 mlxscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107020035
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 12:20:37PM -0700, Alexei Starovoitov wrote:
[ ... ]

> +static void htab_free_prealloced_timers(struct bpf_htab *htab)
> +{
> +	u32 num_entries = htab->map.max_entries;
> +	int i;
> +
> +	if (likely(!map_value_has_timer(&htab->map)))
> +		return;
> +	if (htab_has_extra_elems(htab))
> +		num_entries += num_possible_cpus();
> +
> +	for (i = 0; i < num_entries; i++) {
> +		struct htab_elem *elem;
> +
> +		elem = get_htab_elem(htab, i);
> +		bpf_timer_cancel_and_free(elem->key +
> +					  round_up(htab->map.key_size, 8) +
> +					  htab->map.timer_off);
> +		cond_resched();
> +	}
> +}
> +
[ ... ]

> +static void htab_free_malloced_timers(struct bpf_htab *htab)
> +{
> +	int i;
> +
> +	for (i = 0; i < htab->n_buckets; i++) {
> +		struct hlist_nulls_head *head = select_bucket(htab, i);
> +		struct hlist_nulls_node *n;
> +		struct htab_elem *l;
> +
> +		hlist_nulls_for_each_entry(l, n, head, hash_node)
It is called from map_release_uref() which is not under rcu.
Either a bucket lock or rcu_read_lock is needed here.

Another question, can prealloc map does the same thing
like here (i.e. walk the buckets) during map_release_uref()?
