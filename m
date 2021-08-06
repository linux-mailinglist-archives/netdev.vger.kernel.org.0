Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F693E2EF3
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 19:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241338AbhHFRmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 13:42:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31938 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231776AbhHFRmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 13:42:42 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 176He60n013127;
        Fri, 6 Aug 2021 10:42:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=EpQ5dncDCCL2psUDYr43tw3+ZyR1afmPgvsjMKTfgVY=;
 b=ogHmaDwAhqQCc+vaJ3J6HeT7gNj4rj6TGtQjRVDzSqAcm83ouxGHmoIxVCLB81UzII1e
 3ejMZKCyjar2L7quCk+SyklAz6WNKq4J/EntveWDKzMv9vq5iVgd/9FzF/yfIJ9wj1fR
 1oAcEf+8Wyzb9Icv2fTyA5zgnbH2F3nTMO8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a8jju7hvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 06 Aug 2021 10:42:12 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 10:42:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrAKmv8lInSBJ6BXvodd+QBimzrURjkQjWiToEs5nJ9mH3p73Ur5hHvnSNwnSqBtxbaVQx4sF7y8e68TVVngb9IvaQ6ncfVIxIA+rQo+tNmxgNCqu3sU4xgTXKdWldqXLkQRO6a8ly4yhssyYtF+ZMl6zIxzwIyUlTrYoKOegt6FldWrRl8KWkqMbMKHtt8V/x2kb6RfwrRd76EWpGuMXWoAMxJMlj/8Wpbe8uCLupiti5QGMmvRMgA/9YTRpl5P2JfxGgyswWYAuve2whb35tJHBgezb2Jj04s1XPmK+3GxdXQhFWJADr5KY8u/WoV78wAJlbSeHkTI4X19twQgWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpQ5dncDCCL2psUDYr43tw3+ZyR1afmPgvsjMKTfgVY=;
 b=kOZoe+7Ffi2larnn1cKX5mK9w+M6HbVLhfQXJd8bFLeelB2wDTQhJTdR6wESzatLhR40r37SKMnjEIHo6UHXrTWJV0NhJedUo0Vf3mX1cqIrcrtnsBaMb/M9pt/zu+SAEgg4a0UfcxEYyipCGCXV3c7FbPy2NNgJSauVhV9usc/y38dGVbdj0FVL9qlTAtXv7jWegtPOe3375r5bl1MiKxfB6WlSVwaneHtqKQMHAZcirhuSnTxdcq99rlfc0sTF5/5562Fq/b0Qih0EKaqtjOG/fkKSb+KNkBbUyaQcwxWsdDuJMsgDFIVS2Iqi7CYdbpB38aquAC+pYe1FagHEyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB4269.namprd15.prod.outlook.com (2603:10b6:805:eb::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Fri, 6 Aug
 2021 17:42:10 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%9]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 17:42:10 +0000
Date:   Fri, 6 Aug 2021 10:42:08 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yonghong Song <yhs@fb.com>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 4/4] bpf: selftests: Add dctcp fallback test
Message-ID: <20210806174208.dhxf2fo7755kdvz7@kafai-mbp>
References: <20210805050119.1349009-1-kafai@fb.com>
 <20210805050144.1352078-1-kafai@fb.com>
 <217393dd-9af6-7e5c-3a02-630dde4b1280@iogearbox.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <217393dd-9af6-7e5c-3a02-630dde4b1280@iogearbox.net>
X-ClientProxiedBy: BYAPR01CA0029.prod.exchangelabs.com (2603:10b6:a02:80::42)
 To SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:b9f0) by BYAPR01CA0029.prod.exchangelabs.com (2603:10b6:a02:80::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 17:42:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27402450-8e98-42ad-4dc7-08d95901844d
X-MS-TrafficTypeDiagnostic: SN6PR15MB4269:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB426925697AD2A001AA66FC7BD5F39@SN6PR15MB4269.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PT455V3xQWYx/JmY1uX0lIsD0Y7DDhSUGXaX6d1+WXpXRiBtQ9kvJtIxRgSpxNu5WPDFcVHMovEsX8vM20FKxeUFlehwqmLnnpl6S2RWN/FQkny3FGATtVQcADzK7j1NJKRK6hqzw3jj1EgmHoeYERehtomHcZLmPXi60MmCcwHHyPyFR7ky9sszOrKH9ASEwyBZxWi+w7vapG5Akhwe25JJiRlvH1Y6f4p2l/rcyPE9a0kdAx3OeZZL+gxfjnQfF0hjE2vNDNlcQbTptYxXOjla2TZcnBm5DoxgymJzKyGB0CmSu8Qc3FAWdxIURal/+C5KXOS1kqmNt/b/03wy6yZExamPq69CLKrZs8O7oCdjRIeWG2txSuYCL9Gi4O1Yz5zLJscpUjVQU4QOY+YawBN5uX8b6Rb19HO2ZUmQoRQTJUR0+lLGEp/HIvgnS2l1HSL8t34oiKE8occf/xqEkyI8YtA1Ue0EGRgKMNQ2fiLfP8pqdKz4puPmtgk1D/9Lsts2/EXg1StEp8J01NCE20vGXY1JAVggAzXTiQhXeunFH7D7ha9kytDZphhe+EGKBk/mR9yK3AX6YM4Tg76Hrf/CePrQ6Pe1vwK6R48pfmBZtW+vg35oA4/OBbOvvH61wI7l01r4l9emmPx/Z/XnDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(66476007)(6916009)(5660300002)(66556008)(316002)(6496006)(54906003)(66946007)(2906002)(83380400001)(33716001)(8676002)(55016002)(9686003)(4326008)(478600001)(86362001)(52116002)(186003)(8936002)(38100700002)(53546011)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?143FvzTf9RsR2cIy9wSryUiOjWA56WSca3bocC/ohdqjYQHOECbzs7+Oc0sq?=
 =?us-ascii?Q?Mng6Lz+EUNErn4bnDmdOdr7VkycbrPn3UR4wnf25hQMiDqOkzM2wcwpgtILT?=
 =?us-ascii?Q?ZkKKBe37KzgIne6lEvEsil7591cuu5nq5Re98clU+hf4YYuoU0z1LHupnBYS?=
 =?us-ascii?Q?6Su8UO2IR6wkbIaSjTnPnLckvWtCYEP+jJN/FWKhxn1Wug/d7Sr1hDI/5utY?=
 =?us-ascii?Q?xw2ig3sM7QlYHDDOZhVMlL50lQSGKB8lRv6U+mMpL3HgzvvYI6Xv0zqJsZs0?=
 =?us-ascii?Q?jUM0Q9JV+BPhy4+0cp6peX7vKizIZZWjHZ0g9IE+2F/cILpIoJB7NTkAwEX4?=
 =?us-ascii?Q?2kih/2Ta+tb5ZagAs8MKl559U3pdsvcmMX8med02cgw0m1h+OP7LR6DvdmEO?=
 =?us-ascii?Q?yQTr4D17sfci7pYtqwgbbozjrmiPpssUVAlvfnZmIDNDswaPfN0N/W9DT2iy?=
 =?us-ascii?Q?JdDtvD4lGSy4HQKg9dHvCPZFugUKuEWUYZ5oyqE6C616X0lYyXPzHRxT+Q28?=
 =?us-ascii?Q?1vwGmojBzBUJNVlTEbw0JPzDQuCKzrmF44xqii4C9KeL4+KGnoMoCRuEyjkw?=
 =?us-ascii?Q?hP3JHb8mRsQt4f8rs7l3eNmGCJ8XhZ0lWA1UijPNHV3yrdfxzQ1FL2iLNEgc?=
 =?us-ascii?Q?OJp/cuxrv2muN3aaoe7CGrcVKzYBCez36wTc7ql6muc70PZy+1x1ywyUUYar?=
 =?us-ascii?Q?OkLWppqiB4Dj75De1Kcl7FMZUx/WssGSs44r6N3xNQ4Ze34ZUGd1KtPAw4Jg?=
 =?us-ascii?Q?sYtTCjibEeAdSxBFNyUGAjg7SKXcjs+vbEcWxxI0kA4vFBKfjGzX3MRGacTO?=
 =?us-ascii?Q?E/N1IwaOLLNHFK7MYY2N0nrSZYnsYg/a3LiE3wYhYxEj1p2Zyd/bK6eFxPC2?=
 =?us-ascii?Q?o76QBbj7qUv0h3Abljl6jX/ir+ekVkwu4iAXNfOe6eXeqAQi8USDi98Oqg5O?=
 =?us-ascii?Q?TIBzpK4FjUg+XkIDQ9F3zuICT29uzwbi9wLYmMU35EJ9k5nCAdYlfVfZ/SzJ?=
 =?us-ascii?Q?e0JsixW8dScwxAfe4Y6LMcIf+OvGM6KQ1UYE1bzsQS0phCq3UYrR+epd289H?=
 =?us-ascii?Q?/iO7wjkn9oA9sq//DHzAU+vcbvlkF0qKVCjQkRsTRBaTnaIKqHAiJksC43HJ?=
 =?us-ascii?Q?3SfIn85qoFoA5Yv1Fk3YcBDtzPkFrmkrolrGoHS4/mio1eddUehjbFNohZ3E?=
 =?us-ascii?Q?QzYQ6zv2z8Ju6sCnaNUU/q1xGUux9paC61fFOa0MWeFPUsTjfanj2Rit73FQ?=
 =?us-ascii?Q?BQe7kBnyJ5n0LF4zOrBcwNRJyUAbMl2jzrkFsyTfHavI4ejUsdq6b8EoUT9d?=
 =?us-ascii?Q?1rvCoW4hLMsu350n7EsO4sqw9ay6nVQ/0jKNEFXUm1l37w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27402450-8e98-42ad-4dc7-08d95901844d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 17:42:10.0856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n4yZrLmAl4NpjoT6mzNo+bKztGYKvIN3/KQWKpXZTunmGG1IYHXK4AfZQiOOJx6x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB4269
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: BI7Be8Ki0nqFbqr8yOxIMLjbwN6XVzgb
X-Proofpoint-GUID: BI7Be8Ki0nqFbqr8yOxIMLjbwN6XVzgb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-06_06:2021-08-06,2021-08-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=871
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108060120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 06:07:01PM +0200, Daniel Borkmann wrote:
> On 8/5/21 7:01 AM, Martin KaFai Lau wrote:
> > This patch makes the bpf_dctcp test to fallback to cubic by
> > using setsockopt(TCP_CONGESTION) when the tcp flow is not
> > ecn ready.
> > 
> > It also checks setsockopt() is not available to release().
> > 
> > The settimeo() from the network_helpers.h is used, so the local
> > one is removed.
> > 
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> [...]
> > diff --git a/tools/testing/selftests/bpf/progs/bpf_dctcp.c b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
> > index fd42247da8b4..48df7ffbefdb 100644
> > --- a/tools/testing/selftests/bpf/progs/bpf_dctcp.c
> > +++ b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
> > @@ -17,6 +17,9 @@
> >   char _license[] SEC("license") = "GPL";
> > +volatile const char fallback[TCP_CA_NAME_MAX];
> > +const char bpf_dctcp[] = "bpf_dctcp";
> > +char cc_res[TCP_CA_NAME_MAX];
> >   int stg_result = 0;
> >   struct {
> > @@ -57,6 +60,23 @@ void BPF_PROG(dctcp_init, struct sock *sk)
> >   	struct dctcp *ca = inet_csk_ca(sk);
> >   	int *stg;
> > +	if (!(tp->ecn_flags & TCP_ECN_OK) && fallback[0]) {
> > +		/* Switch to fallback */
> > +		bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
> > +			       (void *)fallback, sizeof(fallback));
> > +		/* Switch back to myself which the bpf trampoline
> > +		 * stopped calling dctcp_init recursively.
> > +		 */
> > +		bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
> > +			       (void *)bpf_dctcp, sizeof(bpf_dctcp));
> > +		/* Switch back to fallback */
> > +		bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
> > +			       (void *)fallback, sizeof(fallback));
> > +		bpf_getsockopt(sk, SOL_TCP, TCP_CONGESTION,
> > +			       (void *)cc_res, sizeof(cc_res));
> > +		return;
> 
> Is there a possibility where we later on instead of return refetch ca ptr via
> ca = inet_csk_ca(sk) and mangle its struct dctcp fields whereas we're actually
> messing with the new ca's internal fields (potentially crashing the kernel e.g.
> if there was a pointer in the private struct of the new ca that we'd be corrupting)?
Without switching to another tcp-cc,
if the bpf-tcp-cc was buggy (e.g. setting incorrect cwnd), it could also
slow down (or stall) the flow a lot by putting wrong values in its own
icsk_ca_priv.

About the potential pointer value in icsk_ca_priv,
the bpf-tcp-cc can only use the icsk_ca_priv as SCALAR, so switching
to another bpf-tcp-cc should be fine.

If a bpf-tcp-cc is switching to a kernel-tcp-cc, that kernel-tcp-cc
could potentially store a pointer in icsk_ca_priv.  The only case I
know is the tcp_cdg.c when icsk_ca_priv is not large enough and it
has to resort to kcalloc and store this pointer in icsk_ca_priv.
Other kernel-tcp-cc stores its data inline in icsk_ca_priv.
The ICSK_CA_PRIV_SIZE has been increased a few times to
store new data inline instead of doing another kmalloc, so
this should be the common case. [cc: Eric]

It could disallow switching to kernel-tcp-cc but I think
it will just end up too limiting and forcing people
to create a bpf-tcp-cc shell to mimic the kernel-tcp-cc
during fallback.  Considering only very limited kernel-tcp-cc
stores pointer in icsk_ca_priv, how about imposing a white/black
list for bpf_setsockopt(TCP_CONGESTION), e.g. disallow switching
to tcp_cdg?  In the near future,  the tagging feature that
Yonghong is working can be used to tag some specific kernel-tcp-cc's
struct that is switchable from bpf side (which most of them should
be switchable). [cc: Yonghong]

WDYT?

Thanks for the review!
