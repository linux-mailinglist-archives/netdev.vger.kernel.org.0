Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8802CE585
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgLDCG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:06:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13362 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726026AbgLDCG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 21:06:59 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0B425w0N006558;
        Thu, 3 Dec 2020 18:06:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=DN/zxUzY85N4IzhrDLkD7VobDaEBHH78HMhLtTum3GA=;
 b=dFFo1AxfqtGfvHlUqzjubJcbz88pvPnDpzmOdGWWrd+vfxtVk1mS8Fd6DgkcU6Z4F/d/
 kJSsrHAvFWeC1rpxraWrelQlZBP8o8A3Ac862OoKZe+ev5+U48HYZ9NRjWlU6hKHnnbV
 45rG4rVAX2AiHcWHzTRvW35+SRfoKZTB/ck= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 357682adym-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 03 Dec 2020 18:06:02 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 18:05:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lP97A7EhV3FoE+/t7+07YieJBu+SuBXRW+hulN5OHuGFtmxCCS4qGqjlSEvODaWfGAOgUJTtRLp5jdeqEeqCgNQvpLaqad+hvKp2a4AwymO2SFUvlRfmEHnZDMKEmj3Uz2spuVR9A/TB9u3YBBVcmPBp8M/cJkh1cIz5IqAXULzgR3EEo9r7aJRQru0UbT2Ms6LfAuedd+txIUOTIg7eN+N72q0K7w5KVccJOvFQFEl+Sjg5zrOaCOcRpKs6eCIl2/nKEJN6tJosvosY2nDKI8Qa9b+TR8skse26PYc2XtCQt9UefKgxM1Ocu5zkugwyfBt/D81kZP1x+C0PATg/rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DN/zxUzY85N4IzhrDLkD7VobDaEBHH78HMhLtTum3GA=;
 b=UBvBOM8dZQ2LnvyEqqU9k4Ld0Pks8m7SPOclcZvzwdeCo4cVLzNTJBuqqYqlLCj/6hATHCoKtZqGxvMr6VsyxX6/F5k2obUSydd3+/bb3QuHI9yobHDsOrMZT4rjfxS8zjOjy9OoI9xOaVMJOPIUDTkYDXmXysBioqj+hYnXrQl9utq1ctJs0EjZlCOi1MDGIQXbQK9MLoYGNipJk3Wb4d+LsXa76lp5bsyJXN3oO6RLsadlnpsM7FJ1c0H5+H0ahHMDgC7E+Qrus4Tm/RbWLx9UgZafi44j8gqhKi4bKugMDUSniycxBu4DzkE8YXKV4jOQnwO5AtprNyolnJLuSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DN/zxUzY85N4IzhrDLkD7VobDaEBHH78HMhLtTum3GA=;
 b=ec71Wvm7IwiMv/zDDEXCwmuCFRdWWGSMnGO1u2WVAnCaVHy7Gm5JitAbmstmneuK+nBkkSZ+Sw2SNKC2gdvtShqKr2uBIonkEv7f5JduxleQ/BylYK1bRUAMLD5cDFCe8UJZapczdSYMvTZSjH/MJ9jIq1tuNBw1PPxsgbWbSUc=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2821.namprd15.prod.outlook.com (2603:10b6:a03:15d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Fri, 4 Dec
 2020 02:05:58 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.020; Fri, 4 Dec 2020
 02:05:58 +0000
Date:   Thu, 3 Dec 2020 18:05:51 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Florent Revest <revest@chromium.org>
CC:     <bpf@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <yhs@fb.com>, <andrii@kernel.org>,
        <kpsingh@chromium.org>, <revest@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 6/6] bpf: Test bpf_sk_storage_get in tcp
 iterators
Message-ID: <20201204020551.egjexugorxumgarv@kafai-mbp.dhcp.thefacebook.com>
References: <20201202205527.984965-1-revest@google.com>
 <20201202205527.984965-6-revest@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202205527.984965-6-revest@google.com>
X-Originating-IP: [2620:10d:c090:400::5:4ddc]
X-ClientProxiedBy: MWHPR2001CA0003.namprd20.prod.outlook.com
 (2603:10b6:301:15::13) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:4ddc) by MWHPR2001CA0003.namprd20.prod.outlook.com (2603:10b6:301:15::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 02:05:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a103bc10-4649-4977-2d28-08d897f923fc
X-MS-TrafficTypeDiagnostic: BYAPR15MB2821:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2821CCE487AF912F2C2BC935D5F10@BYAPR15MB2821.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BcWQGez4I5jLqw+K4/3rl0OtsDaP2RfsOW93cBTOijrf9hA63Y9beWVPG2EIF56JEPOVxY3QyTr0UCe5dOdXXDWE9Nz++nzzmyHzzstKowNtsD2kRdalCYif4eaBKNkQJ8el0RiWvk32Sh/YBIo3CgsmPAqZOpQY0hf6zoyebgCZJrDGQqYDWHbvGdwGyiOwneqBlNTgTQOgJnksga3yW9mLJS7NverowpwTXdgs/wMQVbvvRShi702fHDekRmLHWPyfOHMsA1O8Qo1peefcPfUXsAisbWFg+Fugh9GdaB2J1MVE0V6Atr3bWPeICLeZZnviicJ/7blcl8yyXtSrsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(376002)(396003)(366004)(55016002)(66946007)(3716004)(8676002)(16526019)(8936002)(66556008)(66476007)(316002)(6916009)(186003)(9686003)(7416002)(6506007)(83380400001)(7696005)(52116002)(478600001)(4326008)(86362001)(2906002)(1076003)(6666004)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?32lIqBZuAf+/dgl/ShldzVjU/tMWW9ms8uIIO4LQo2mAjabpublZ47Ki7Bra?=
 =?us-ascii?Q?R39ooNtLrtuSM8ovk3qC0Mz4Qb6Gl6BHZoflhjcsCQipS4Hq586QYNik3LFD?=
 =?us-ascii?Q?WCPQI/LGARDenfm26KAKqav66LB7HA8SWSIAFV8pSuhIPGmUKMNzM40bUACh?=
 =?us-ascii?Q?sCbeBnHLRNaM8biKNMZJev5FDbkuAbiv9aP0mCJc+WohVcniZSIwzIkYOcS0?=
 =?us-ascii?Q?7agYsCZ/4R35ZNgVT+r+5ifrUFLuCmUrhYuXLpeaSMlq248Au9hQW1fbSbDV?=
 =?us-ascii?Q?TrCdo0oJO2TSCpxRrUAcuKPnvLsD0rcdqwHZLYR+BMYjvApR3V+QtfUt1TXk?=
 =?us-ascii?Q?GhyPR3sX8znM5DvdKv9QDDvsIq0zSaxWHIkUuEtzVp67mLXE+WAC5VFRg0uA?=
 =?us-ascii?Q?G0a6ZH9V0W1l3OIHX2/KLA/eDpNicDiIZLJ3NiFATyS9SwdevjT0HvVSZVoU?=
 =?us-ascii?Q?yLUpTvw5TPxv327jrG2IwJ/nh1F1IZCjOcY4szHw34I1WF2Z6mWqJD1usPXU?=
 =?us-ascii?Q?whKG3zuqbYPMqv3lnLgAgYDccsWiw9fD3GXTCGIOcKPlmX1s6+MLgmeaItje?=
 =?us-ascii?Q?ItVvRApg92+4aeNiTHIMML6SdaYyv92lGGm/OhMnH1ke47D3+bEIH/jn+CKt?=
 =?us-ascii?Q?XOMlMd/SMZBpj8jzi/ItKPs/8W1defCxT/6P30hhIt3mJ4/Y+q8JO0V+tFg/?=
 =?us-ascii?Q?viQbX+M09uLITswIvLHvgi/dC66ekSvNKFr7raDtHCnAuXJXz/QTkORwB1Sp?=
 =?us-ascii?Q?3ZwwiSZrVswtqFr0UozGZmJ9vqB1WElW5kpZzcRCd5VSHAACCyatA+721wc3?=
 =?us-ascii?Q?uMGqg8rBjqh3qlkdOb46hZbNGJiM+lqiLPyBliskWVW/0uSVARMNyDn49+Jr?=
 =?us-ascii?Q?Ayh7/5L8+7lFdruYUGjlaQtmVxBfOjeMQX2dnVjShuwgkONBZjJuc0ICtIon?=
 =?us-ascii?Q?jl7aEtJRC92zKMv58k38ybyj/2G+93ukalhuu/kK5PnoPSpSk1N5b71J8+uI?=
 =?us-ascii?Q?t2NwA6+SU0HEu906TXBLNfb0AQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a103bc10-4649-4977-2d28-08d897f923fc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 02:05:58.1593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xpkvACnzEACG0uj4C5zAwGioDD9yznGKfz1EHEjbd6ou/qdH5dENlHtf56JdUhTC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2821
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_15:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 bulkscore=0 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 mlxlogscore=999 suspectscore=1 lowpriorityscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040010
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 09:55:27PM +0100, Florent Revest wrote:
> This extends the existing bpf_sk_storage_get test where a socket is
> created and tagged with its creator's pid by a task_file iterator.
> 
> A TCP iterator is now also used at the end of the test to negate the
> values already stored in the local storage. The test therefore expects
> -getpid() to be stored in the local storage.
> 
> Signed-off-by: Florent Revest <revest@google.com>
> Acked-by: Yonghong Song <yhs@fb.com>
> ---
>  .../selftests/bpf/prog_tests/bpf_iter.c        | 13 +++++++++++++
>  .../progs/bpf_iter_bpf_sk_storage_helpers.c    | 18 ++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> index 9336d0f18331..b8362147c9e3 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
> @@ -978,6 +978,8 @@ static void test_bpf_sk_storage_delete(void)
>  /* This creates a socket and its local storage. It then runs a task_iter BPF
>   * program that replaces the existing socket local storage with the tgid of the
>   * only task owning a file descriptor to this socket, this process, prog_tests.
> + * It then runs a tcp socket iterator that negates the value in the existing
> + * socket local storage, the test verifies that the resulting value is -pid.
>   */
>  static void test_bpf_sk_storage_get(void)
>  {
> @@ -994,6 +996,10 @@ static void test_bpf_sk_storage_get(void)
>  	if (CHECK(sock_fd < 0, "socket", "errno: %d\n", errno))
>  		goto out;
>  
> +	err = listen(sock_fd, 1);
> +	if (CHECK(err != 0, "listen", "errno: %d\n", errno))
> +		goto out;

		goto close_socket;

> +
>  	map_fd = bpf_map__fd(skel->maps.sk_stg_map);
>  
>  	err = bpf_map_update_elem(map_fd, &sock_fd, &val, BPF_NOEXIST);
> @@ -1007,6 +1013,13 @@ static void test_bpf_sk_storage_get(void)
>  	      "map value wasn't set correctly (expected %d, got %d, err=%d)\n",
>  	      getpid(), val, err);
The failure of this CHECK here should "goto close_socket;" now.

Others LGTM.

Acked-by: Martin KaFai Lau <kafai@fb.com>

>  
> +	do_dummy_read(skel->progs.negate_socket_local_storage);
> +
> +	err = bpf_map_lookup_elem(map_fd, &sock_fd, &val);
> +	CHECK(err || val != -getpid(), "bpf_map_lookup_elem",
> +	      "map value wasn't set correctly (expected %d, got %d, err=%d)\n",
> +	      -getpid(), val, err);
> +
>  close_socket:
>  	close(sock_fd);
>  out:
