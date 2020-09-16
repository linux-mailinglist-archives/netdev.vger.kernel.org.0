Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E65D26B751
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgIPAVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:21:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15984 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727300AbgIPAVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 20:21:32 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08G0BLiO012193;
        Tue, 15 Sep 2020 17:21:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=hfd7VxNVeFBhVtbvFrSwZQ89yCKtAWwdahB4dYa84A0=;
 b=nMR5Iokksx0Pq4FF0/k0dXUuhBZlyTitkt92eGV8KSdVHX61ZS16GwbUdgd/HaW2nO2G
 +dkr48DfD2E9ri9NgNClcwbvJcp4LKv1ODjswwwEW80tFuVlCDH5c1hbUeYriB3arcMc
 +K3FTGq43Ky0YuGmYJV020/dzB1b+7xC+Hc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33k5q60pct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Sep 2020 17:21:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 17:21:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwWAOKulJUmG1XUkChtSFVHXpttLhcXI+qmEtqiF70h/cUQyQoFMcZCw4hLCLYT2ePU7u3LiT0NZojckdgTfTwY4qWkN+LbI6el8+VAV6Ndy80CukbKDT1ruPVYXvnU7I65HVIuXzClNlexUfm6pa/WiRNrd0CrQSOm2V5iGoWypBzdauv9u7R16o/cbY1VCcD1JygQBgvSFyOtycxZIjxTXSfj0Y/g8i/uwu1JsPPLR86ysj8ZGn3o+GuNoMfpAHTdttLew8/iqEQDPCeLsO17TCdCY0fadTVEwgkM941/L0sWA4f487SeOZ0KI7ZE5YBT8GMaTm16gd/stkz3BSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfd7VxNVeFBhVtbvFrSwZQ89yCKtAWwdahB4dYa84A0=;
 b=Ff2IQ3BZ5SxX5IHl1JdjhnBS/ucCaYKqNqDR1xfK5xpEyp+2G3FDQXELHsKNVUfbbzK1dWLXl6m6BjJcTdSXvcbT8UwCd5GhA5PS1zJGMlGyK8zBRiWc3TJUs9O5TiSGZJNvE+F7TNuei0L5oCjlk3ozficCA1h2yAyrv3ftcYsrv5VnATZcNYdi0+fBzuEdsXtn5Af0jx4DG56pPRf4lg0VyUAIWO2H1+tIK5RGBDM+xb+D1ovH+nMeMKgwpQ2X7X7a9bJVgex6m7Aou7pUnIDCbWJ0AYZIYQ/iYYjPvSTQNJe7GIADnIozot5V3dEynFLiNq+hrDGPKwFBYp+0+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfd7VxNVeFBhVtbvFrSwZQ89yCKtAWwdahB4dYa84A0=;
 b=VpK2yZPjy7JIsSwP98xpKUKpgQ6i2WtLR5lX9RQfEFeBy7yt/ZUQ+Awhc7QWsugqirp424ro0iqEotEF/kBLp8WWth3SuGSREht4LmsX/RuO6PPzM3VPOC3zDb+rByaA40X+o3XSa6Mx7JrICTjULN2imT8UKP04d6G6SFZvsAo=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2647.namprd15.prod.outlook.com (2603:10b6:a03:153::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 16 Sep
 2020 00:21:02 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 00:21:02 +0000
Date:   Tue, 15 Sep 2020 17:20:55 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>, <yhs@fb.com>
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: merge most of test_btf into
 test_progs
Message-ID: <20200916002033.vmn5bensn6r47t4x@kafai-mbp>
References: <20200915014341.2949692-1-andriin@fb.com>
 <20200915233750.imml2qj6p72olga4@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915233750.imml2qj6p72olga4@ast-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: MWHPR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:300:16::23) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:30e3) by MWHPR13CA0013.namprd13.prod.outlook.com (2603:10b6:300:16::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.6 via Frontend Transport; Wed, 16 Sep 2020 00:21:01 +0000
X-Originating-IP: [2620:10d:c090:400::5:30e3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3ce2bd5-8032-4d47-58f1-08d859d664b8
X-MS-TrafficTypeDiagnostic: BYAPR15MB2647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2647BA2BC99CC036A3149B40D5210@BYAPR15MB2647.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cv7hUumVYVE1LtHdnH5ikaoaMG0o82uKTOMbumKR99Di1QKUJVdz6FTjWiudDvXm/jq6seqiETNEHvtU5pMsEiXaD2KCC5LIcP2tQuXDTcgTKuC4jJbbb6RVJVrxqj0u9A6yysYIaJ5UPYzVQJGsV5fFia98OoxKuhaEPTfvdgi8muItv0CXGnFcLUVIG/27SvSi0VgrjB/7xlxdOSWYrff2rG2aTjNisqDtQAMok3pcBKbGSb3mpKK7uWryCxfPBn5jsP9Y/jRuuHwkTyS3nDOIT8f+l+zL20gj518tr0KjB8cI4Hb9slXbLLdQlbn3OjKqZ9m2PxbyriKAnMqlhbky0DCvA7yAcz00qpCEX5DopUaIkcPsjL7p7KQ95xmj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(39860400002)(376002)(396003)(186003)(16526019)(8936002)(9686003)(55016002)(1076003)(52116002)(6496006)(478600001)(66946007)(2906002)(33716001)(316002)(86362001)(4326008)(8676002)(83380400001)(5660300002)(6916009)(6666004)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yRUqmNQqVQxgW03adMBQHUiT8DhAXrLrNisAGDn983xHiTImvl2sEY7OeRfhYhE+dmOKtN6iw3pNlM9Vk++JnylE0lLfAo6ub2zKlygerpA9+0J6fQllfb3SHSe0Lx4v4seyhJDtqFWt1yxj1gBbyLhWY1bZsvS3GoYunjq7bCynrWVy+0JToIy88+T8NcrtZTDNUqoeFuliPBKol4rYNPNBEl+l0qd4gJBYm6HQKdXjnYpvI90xBvmCCTUx6+JjF4PAwx8fvdlzeDkQlHg8lBJIHruHh1e0RUekkFINYd7JUyL8xjOEmG9S5kUFLO+12FJDONzEukXT18tuhVTAuO6m3HuAI0wRN06bWlINSQ+pIodqLjMo3JtKEcjbmWDdF2NekimL9x6WfRJwI1rDcFDojIGAtUZFUlQ+V4Hv1fZ2QiAFH6AE5NlprEmfIDQnaC7snYmzea/dLbJEtfoTfZI1uefPbIevZkNkXUzDlWQu5Of4JhzoIJHKQ0bx4bWRf6M0PpTQwoIJ5NPDeeM/58FDN7mO7XoSfb+Y894KdVUQ2IJwIQWsswdaHgHoD/4zMo94hOb39Syt3Grt5GPFm413iqHegpUImKoZRTdcbMPZWyKmW53Nl5tiifE5lIiUH0E2SV+hCm1AoIYFr7RM8nxkml+vOpuoaMPUHlZRRwA=
X-MS-Exchange-CrossTenant-Network-Message-Id: e3ce2bd5-8032-4d47-58f1-08d859d664b8
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 00:21:02.2860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x2p56La+vLdFOAmJnj1yy+4MQ0zBactVkcRB3BeJK2J+z0q7H+8LkXyp/Dw4+Nk8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2647
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_14:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 suspectscore=1 malwarescore=0 impostorscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 04:37:50PM -0700, Alexei Starovoitov wrote:
> On Mon, Sep 14, 2020 at 06:43:41PM -0700, Andrii Nakryiko wrote:
> > Move almost 200 tests from test_btf into test_progs framework to be exercised
> > regularly. Pretty-printing tests were left alone and renamed into
> > test_btf_pprint because they are very slow and were not even executed by
> > default with test_btf.
> 
> I think would be good to run them by default.
> The following trivial tweak makes them fast:
> diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selftests/bpf/test_btf.c
> index c75fc6447186..589afd4f0e47 100644
> --- a/tools/testing/selftests/bpf/test_btf.c
> +++ b/tools/testing/selftests/bpf/test_btf.c
> @@ -4428,7 +4428,7 @@ static struct btf_raw_test pprint_test_template[] = {
>         .value_size = sizeof(struct pprint_mapv),
>         .key_type_id = 3,       /* unsigned int */
>         .value_type_id = 16,    /* struct pprint_mapv */
> -       .max_entries = 128 * 1024,
> +       .max_entries = 128,
>  },
> 
>  {
> @@ -4493,7 +4493,7 @@ static struct btf_raw_test pprint_test_template[] = {
>         .value_size = sizeof(struct pprint_mapv),
>         .key_type_id = 3,       /* unsigned int */
>         .value_type_id = 16,    /* struct pprint_mapv */
> -       .max_entries = 128 * 1024,
> +       .max_entries = 128,
>  },
> 
>  {
> @@ -4564,7 +4564,7 @@ static struct btf_raw_test pprint_test_template[] = {
>         .value_size = sizeof(struct pprint_mapv),
>         .key_type_id = 3,       /* unsigned int */
>         .value_type_id = 16,    /* struct pprint_mapv */
> -       .max_entries = 128 * 1024,
> +       .max_entries = 128,
>  },
> 
> Martin,
> do you remember why you picked such large numbers of entries
> for the test?
It has been a while.  iirc, I think there was no particular reason but
there was only one pprint test and then a few had been added since
then.

> If I read the code correctly smaller number doesn't reduce the test coverage.
Indeed.  Please go ahead to reduce the max_entries.  Sorry for the pain.

> 
> > All the test_btf tests that were moved are modeled as proper sub-tests in
> > test_progs framework for ease of debugging and reporting.
> > 
> > No functional or behavioral changes were intended, I tried to preserve
> > original behavior as close to the original as possible. `test_progs -v` will
> > activate "always_log" flag to emit BTF validation log.
> > 
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > 
> > v1->v2:
> >  - pretty-print BTF tests were renamed test_btf -> test_btf_pprint, which
> >    allowed GIT to detect that majority of  test_btf code was moved into
> >    prog_tests/btf.c; so diff is much-much smaller;
> 
> Thanks. I hope with addition to pprint test the diff will be even smaller.
> I think it's worth to investigate why they're failing if moved to test_progs.
> I think they're the only tests that exercise seq_read logic.
> Clearly the bug:
> [   25.960993] WARNING: CPU: 2 PID: 1995 at kernel/bpf/hashtab.c:717 htab_map_get_next_key+0x7fc/0xab0
> is still there.
> If pprint tests were part of test_progs we would have caught that earlier.
> 
> Yonghong,
> please take a look at that issue.
