Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18953057F0
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S314387AbhAZXGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:06:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56018 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387970AbhAZSTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 13:19:47 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10QIFQ1r032371;
        Tue, 26 Jan 2021 10:18:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=88mLFc56HS4gkcnOGJlavOYMcNHrWbpPxoStL8qNBWw=;
 b=dGel5zWQGdiYWy6c6Xyy4UwHLRUWyAUTkUEAwUH2BTAAklmCI0hwMGYDWwPXBQ9PRjEM
 U7PtTsWVgC54sILwqZhEvWt6FpQ2p7HTO//LDHfCXgUB2JmpRaiOStgA77HEmPPZHT8R
 jfgyDnNhCCJuvAYvh1la9X50SkB5ddWMoTY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3694quwure-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 26 Jan 2021 10:18:48 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 26 Jan 2021 10:18:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OYHz36g/rkmV2F2IvBhQ+X8f2FZqEfID8g6oYiHp0xRp1azx9kfnDQ5A5pnEJtNZ+OOVAu9klAWny66q2el56O1UotlgEftQHRpw0MirOMLu1EJah88z2l7Kr724zIldjieU0cmpuKH/q5BDwunO2NHSOwGuXeTsGLkeqb9u6/kdwwFFg9nHGNxbcKbNGSPEGmJeU9T8QGvbJaJM/LLy34QbVCFOWiEG3akJcaW+zd8pyAfGL9vDNc/udLX2VzrWZUUsLbDo7tLMHK+V9sB6XRWRlV683lbgOSAwbesHAREdsOn+IXCXNTsOcvrN3d9wpbK8emKyrDCB2S0m6sN8OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88mLFc56HS4gkcnOGJlavOYMcNHrWbpPxoStL8qNBWw=;
 b=fK6RwKHo0Dqa+ZGBTpinoH/UhyzkizQHmG6+4HtG9lNOKrf726VrX1qZKgydxOiD6HLEv5wh5DdG7wMxwnBeA85VEz5rBFADm6/L0LXc1z1oyJAexq6BQubl2kcBO9fSJcF95n2GaEJjuXBwM6H4nJ8RQSj5zvaIBcAwTwkms6KbXnF0W1jaJABf4oxr43eXJvWVdCtLLfqB4UsvtE+pQwwqpeAT0z96cYlyScJcAIqL0vJx6Ln9OJpABM8Zp/r8YdjsHqoA+Cfxo6pSCB2Kzs9GqnqnFAYMNNHmmJKu25BPPAEAaGq7OsuvrGcoVrrmAb3bNzPuP+I4Ubw3rqlScg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88mLFc56HS4gkcnOGJlavOYMcNHrWbpPxoStL8qNBWw=;
 b=SBsFYjNQkO61QgOCc9KodE2zdNr8yCQXEV7KvbPz8UEmZ/LyDRRIkpEDmB2ZnzgggOXQoJiLQwX2x9mIGAzavOURyk5AtQRmHriR8YDUKeXtkO6S0OOSAOpwtmQYWdD7TWNsmvc51/NARdGU0LYPV9P3Rvq4TjnSaSA1gyPQoBM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2693.namprd15.prod.outlook.com (2603:10b6:a03:155::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Tue, 26 Jan
 2021 18:18:46 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66%3]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 18:18:46 +0000
Date:   Tue, 26 Jan 2021 10:18:38 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v3 2/2] selftests/bpf: verify that rebinding to
 port < 1024 from BPF works
Message-ID: <20210126181838.boof6nddaazjrfng@kafai-mbp>
References: <20210126165104.891536-1-sdf@google.com>
 <20210126165104.891536-2-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126165104.891536-2-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:694d]
X-ClientProxiedBy: MWHPR12CA0063.namprd12.prod.outlook.com
 (2603:10b6:300:103::25) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:694d) by MWHPR12CA0063.namprd12.prod.outlook.com (2603:10b6:300:103::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 26 Jan 2021 18:18:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77fa29ed-4c23-4000-6705-08d8c226d1fd
X-MS-TrafficTypeDiagnostic: BYAPR15MB2693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2693E365760023F8D7DF4BD4D5BC9@BYAPR15MB2693.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nczWcZ/nJvemymwtqNgtX+TsMmvCcMeH50rM9QSH9fFYEGxICrJEV0SHjjpg9XoXmy7BIqq/GZADwocWDN68lyyvEVFpMTUjp48Is5tq/YtzZFNz2UyUawxps7Xv7d4SqG34BGk/wWXA0oHnfQke/IsoBaQFPBAHiErYKOEeWQegiZSWG0nt+HUbZmgBmJNJgwI/s2G/x+HlhtHeNorXKARmutxv38UV0I/dB1xJX2tnJ2oLJuXGaJ5lifgC0LCeDA7RWexCj08khyaSxTZlByYFTq8iFNxLXoMj64TNgef8fcoyKnmpDxyHTLSAFNSbkWFQ1CwRQxKQtEeN+sA7T4XPsP0DTSJadMwTivsqRtOEy8ecRkPLN4KlB6axCuDU1FiMofeUgWdpdqfRH7fFRN8R6f+7Jm6addl4UChe7rBbxxDTPbl7TDyCOr6aH9y9e47492avXcMsPGgHYlwcsrL/43wPNEVwaEJEsePH2FlenPGHlfYP7P+rACFiKprOuTq52x38EkyNLPxm6wrtSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(396003)(366004)(39860400002)(16526019)(1076003)(5660300002)(186003)(83380400001)(86362001)(66946007)(33716001)(2906002)(8936002)(66556008)(66476007)(4326008)(478600001)(8676002)(9686003)(52116002)(6916009)(6496006)(6666004)(316002)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O9Uq+QaQrmApefVPsmMXv4y87WWsenSuQjpkfu9dpxjUBvPl2OH7vLvyknNU?=
 =?us-ascii?Q?uZWc367RIzM/1czye/nYQRXBVpAUClB52z1OAlfiOr5rCkIcT76U9CsYUyZ1?=
 =?us-ascii?Q?J5OD8nzRZNCBfknLLrgo8/Vu9XrEMpjxAAEVfgIAGa0p9SI/fiR0+W6+moTE?=
 =?us-ascii?Q?Y+OaFk3mQyyx6NTHPmNygznZxxWXIKeUGUQOQX3ZDPoUGG4mw7ugetrwBTfm?=
 =?us-ascii?Q?6TMXA/ob6kS7s8iX+NE52ShD9EYK1uzT4bGyrlGWhEWJ8Qc8G4O8SiH/nEbb?=
 =?us-ascii?Q?w7760uRvFdnUwz6lYJ4WrtGzYBH+QteA2tOctQoMVHIeey7pqqBbe8rwsvUn?=
 =?us-ascii?Q?Zlq3y3pY9puWZKur26NbvdoD016tlhxGBl+r3+THFZaqEVv8CYsNv3tSkxf8?=
 =?us-ascii?Q?1OK82lAKWsxPpAB6WHd6zw6oEZ2TaYiaL2PojjwtDRWFsUr3yUFva6ZyIA2O?=
 =?us-ascii?Q?6GtoyoW1ecdlOhzWSS2VDrXe4GUkuyz6+lm6wFj1ozCQXwLMxvTrEKJ6Lbte?=
 =?us-ascii?Q?Dy7JSZ6gYGQqPYyFixQcwmhELhghP3wrv6w3KpP+Zf4UYBvZirH1QiSQ5Y+G?=
 =?us-ascii?Q?fw+Sgt0s0O2qsRXwF8XVKZSFIZxQnW7Z5AEZxMRKi7bL7vPu8vthAe7DCNZW?=
 =?us-ascii?Q?VWfDwvkcN9c0D71WQmbr6bxoo3Kzaa6UVoaczpoO9awDuriqj++DOM9G1uad?=
 =?us-ascii?Q?ng1uLcWUjGqS3jnGsHnvHqRnWxUM5jBjIVSRhk1s/4dd0ZzSPTfdcenKwB9G?=
 =?us-ascii?Q?fiUITk4sBarzL5Y4qtaD9c0zgblPWH6DeDZqqIbysWmYnjnS5akS6jS3UMNe?=
 =?us-ascii?Q?vs4KC5v/1goOa1MV9Wf97qIBVVHxODKfWk+J1Mz1uMS3iwE0L2EqjCYSeXqx?=
 =?us-ascii?Q?fwaEZNTDZlwzoXcKTV/1n5SA+bK3TNPAZ9AKoPaoMYK5G3WuktV8yhUdVlxH?=
 =?us-ascii?Q?6yUbxwANi+pgElxZFA2C18RMPf3A/yyl+tsJdfnakuSNfzxJlqvriMOzz2X7?=
 =?us-ascii?Q?G8KewCB1Ag5I69Ls1L+6H9gk4l/b04XvsZEfGa1lqq6drrptImvgyUylD3xW?=
 =?us-ascii?Q?tMLTIkUHlA1MAAoRv5yNU+v5wgk0qPkxBlNxLPv7vKYQz6ipx2o=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77fa29ed-4c23-4000-6705-08d8c226d1fd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 18:18:46.2834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pE1aYCMsvLBtH02yyviTW4Dl0tKlQTZpQadt8LLPHzCQk9md2ET8tJX0VKcVaNHr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2693
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-26_10:2021-01-26,2021-01-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101260096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 08:51:04AM -0800, Stanislav Fomichev wrote:
> Return 3 to indicate that permission check for port 111
> should be skipped.
> 

[ ... ]

> +void cap_net_bind_service(cap_flag_value_t flag)
> +{
> +	const cap_value_t cap_net_bind_service = CAP_NET_BIND_SERVICE;
> +	cap_t caps;
> +
> +	caps = cap_get_proc();
> +	if (CHECK(!caps, "cap_get_proc", "errno %d", errno))
> +		goto free_caps;
> +
> +	if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
> +			       flag),
> +		  "cap_set_flag", "errno %d", errno))
> +		goto free_caps;
> +
> +	if (CHECK(cap_set_proc(caps), "cap_set_proc", "errno %d", errno))
> +		goto free_caps;
> +
> +free_caps:
> +	if (CHECK(cap_free(caps), "cap_free", "errno %d", errno))
> +		goto free_caps;
Also mentioned in v2, there is a loop.

> +}
> +
> +void test_bind_perm(void)
> +{
> +	struct bind_perm *skel;
> +	int cgroup_fd;
> +
> +	cgroup_fd = test__join_cgroup("/bind_perm");
> +	if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
> +		return;
> +
> +	skel = bind_perm__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "skel"))
> +		goto close_cgroup_fd;
> +
> +	skel->links.bind_v4_prog = bpf_program__attach_cgroup(skel->progs.bind_v4_prog, cgroup_fd);
> +	if (!ASSERT_OK_PTR(skel, "bind_v4_prog"))
> +		goto close_skeleton;
> +
> +	cap_net_bind_service(CAP_CLEAR);
> +	try_bind(110, EACCES);
> +	try_bind(111, 0);
> +	cap_net_bind_service(CAP_SET);
Instead of always CAP_SET at the end of the test,
it is better to do a cap_get_flag() to save the original value
at the beginning of the test and restore it at the end
of the test.
