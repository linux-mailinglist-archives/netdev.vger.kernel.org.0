Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF82A1D0674
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 07:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgEMFls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 01:41:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45004 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728097AbgEMFls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 01:41:48 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04D5cxqC010618;
        Tue, 12 May 2020 22:41:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=a6pwy2EQzzDQ8kvkNCZfM5xS+LovCArF21TiDbsqC2c=;
 b=OKbKIG4YWLzs0DG4kphYcSRoPY4uYvE56bLgg6FzKOU/sLeNgEVKUtINp/Pn5XWtejfk
 r65+6k2diKk8AqAqMfEey3JQysKnwFIclnB8RzRh2zlvCLoh1j9pQf4L93GNq1JEhjOC
 c16OwfnM397KljbrNpAmBwACdePNIbcyrro= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x22wkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 22:41:25 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 22:41:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3aYqgdMwIutBdiS6UK1xsIPyzDOPB+I/1OJ4Fvn4QwzJZdBDEpYoWZv22zEmk5sOem33jrs1RbGwoQWbdc+4cW7yU/5l6JQCgRlrR0RhtJE2IywcXDj/79K8QT8qWd6AwlAaGL46/8W8hS4wRDVGIJE5JBYqU37PbKq5gmoqX4mdEIn2TDA3v77TurkgYEEIbxpIB8CwXITbMyusGk+FstTFehyOfWxQoFCB81OYIOmSteYJiIevI6mSbQYQ7aaQIoiXStHR8eXgTAbRVjEtWRVlGO3dqPVJfpYSAFVGu5JqdWDhFKmkZN1HsaMH7uaFKY3gGd5Y/sWNAa806h5eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6pwy2EQzzDQ8kvkNCZfM5xS+LovCArF21TiDbsqC2c=;
 b=RSavTdXm24VxHZhnHXVSD/L/hhe6apJCIMFDrClPekDBQwyR2ngdGopBzQxnEerLWLF355BjXLmqwOQ98eExU2qlEzQ+dZTzykiTrboHRliLMLCYxner5K0S1ziRTbsSYJCMp3bRY7rye8lI+G/p60nbc0rEYZ4WgPBchoUEBO2ZAuYY2fhaRnMPObtv4QpNzOqoSRGaZJkiAEFHkY5dbQlHZXVMWtrbl2oD/bukWt3zMXwOKdcWWYUxp0w5kJkmcJYojukaGomJ1U9eFj2lk+Wk+MGwqVQSzV1cuHcZKannAoxnWy14/wFUTkJ9GmwtlNlTCxbIIKHkK9WcE+LQ1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6pwy2EQzzDQ8kvkNCZfM5xS+LovCArF21TiDbsqC2c=;
 b=K5zorTjyt2ss3/yOz/8Qm0/RUU3w++ZAg8lgTTcuGItOkKURmCckDHRwi+fmoxgKii1uPQG1LcoR46Xg+3OwaMdp2GBeOAeXr2l+GOdkNBDGttGsyOVeWLl3gDW38/pzH6zhcGJTdaFwNiOppzcTPywB5cNut2dIk0rfV8k5OjA=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3522.namprd15.prod.outlook.com (2603:10b6:a03:1b5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Wed, 13 May
 2020 05:41:23 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::71cb:7c2e:b016:77b6]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::71cb:7c2e:b016:77b6%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 05:41:23 +0000
Date:   Tue, 12 May 2020 22:41:21 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <dccp@vger.kernel.org>, <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v2 02/17] bpf: Introduce SK_LOOKUP program type
 with a dedicated attach point
Message-ID: <20200513054121.qztevjyfkc2ltcvp@kafai-mbp.dhcp.thefacebook.com>
References: <20200511185218.1422406-1-jakub@cloudflare.com>
 <20200511185218.1422406-3-jakub@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511185218.1422406-3-jakub@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY3PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:254::6) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f3b6) by BY3PR05CA0001.namprd05.prod.outlook.com (2603:10b6:a03:254::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11 via Frontend Transport; Wed, 13 May 2020 05:41:22 +0000
X-Originating-IP: [2620:10d:c090:400::5:f3b6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 955f1934-1ed9-4017-c90e-08d7f700453e
X-MS-TrafficTypeDiagnostic: BY5PR15MB3522:
X-Microsoft-Antispam-PRVS: <BY5PR15MB3522DED05F3270739CA77FE9D5BF0@BY5PR15MB3522.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sn9xv2I2LnvbUi6FwHIRKffqqoMhV3szjCplwxACPIYJQ+z7BR+dmccoIqBZnDm2UIMwIysDm/aB0TleQdMLKn7Dxbck/pltox/7RL8e4vKyRFbS18dHj2dRHnAxoLod/koOZJywPuTVnB0urGu0g/37nH6ElnyLWJBplV4iPvdZ/hYd47hQ4mccH/pdGVarO9LY+gOiKL01H0mN5s7vb1vlSF8JMXi/t/dCm6Dj4S6g35IGm22W7auaxXV5ZiIlZC7gPia1HJa1jyQgbzEEwybru7xiJ2WIz6uPx/NQj0GHXdiBHZdT9xuNdIMIjwyGQh9k0qENt2P+lZvg3mzQ8Lff7fdaKTlT/KG9V6JoIQAJurcP7dT36Sc3PdMT5LUfoQgcYvXh9LHF/tQS2Rt9l4KKGVxCvb78dXQF0qp0s4Rh3EiBe+Dr4Wseu6hh6YQ4IfxRSrW139REhxqUqXe5A3UkpywG4EPW0nxd2sZJsYaGVboEwJR7d3wQN6R41ylUbXCC+1C686BiuT6LctxyMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(136003)(346002)(376002)(396003)(33430700001)(2906002)(55016002)(33440700001)(54906003)(7416002)(316002)(66946007)(4326008)(66476007)(478600001)(8676002)(1076003)(66556008)(6916009)(86362001)(8936002)(6506007)(5660300002)(52116002)(7696005)(16526019)(9686003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: lOERxOtIIqGh/fZcUfOrzEGI0YabomeAQmvxpZEJqCZgtzSNN9Lr3VFcLO1/a8LAwtz6Luz6GgY/n2VxNBOdWa343z5CS40XaCu6+405RpYiBiaVTG6HmDZ39iDOaWe8gZBlHAe0KP6IP3AQraVf/L62Cf94REXcd2Y5l18TmZH6RFygLKoQbcjNvtpZjZHRYobZf+mIK+YzovyMepzypIvkCArF9ypowXpAMpV/n1zI+6hXgJ5lHtebKoB+Lt9cbn58vwyea0JllwNINP1UnqpuipsR0GzbMuuyBk/rbwRDpL58YA/64Luv5obbbcSXlmkJpCGbKpRcfFNOZZRPD17fd354dOsEXBh5rwgnRGXy4+aFIrTL4f0KYV5wP3eRnnWWxrEACd8MFGaDFhsNFZqtcrgPKqkSeAh08xwnimfC5/z99h1WeC8m0CX0oCmBoxjLULFtzbhipQQXZ9Y2m4rvLcuDFt0fKkpzg3zE2VVptj56ZEbYZFxA+SVTWoYQKPyJEByt/47ygphYsKCQkA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 955f1934-1ed9-4017-c90e-08d7f700453e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 05:41:23.7573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 72NAuXwGYEOapRsT+j3Zt6PFRlMCWBvxfvdTcpokDvWUYk3BvXalhW3WyVzPg7tC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3522
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_01:2020-05-11,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=787 cotscore=-2147483648
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 08:52:03PM +0200, Jakub Sitnicki wrote:

[ ... ]

> +BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
> +	   struct sock *, sk, u64, flags)
The SK_LOOKUP bpf_prog may have already selected the proper reuseport sk.
It is possible by looking up sk from sock_map.

Thus, it is not always desired to do lookup_reuseport() after sk_assign()
in patch 5.  e.g. reuseport_select_sock() just uses a normal hash if
there is no reuse->prog.

A flag (e.g. "BPF_F_REUSEPORT_SELECT") can be added here to
specifically do the reuseport_select_sock() after sk_assign().
If not set, reuseport_select_sock() should not be called.

> +{
> +	if (unlikely(flags != 0))
> +		return -EINVAL;
> +	if (unlikely(sk_is_refcounted(sk)))
> +		return -ESOCKTNOSUPPORT;
> +
> +	/* Check if socket is suitable for packet L3/L4 protocol */
> +	if (sk->sk_protocol != ctx->protocol)
> +		return -EPROTOTYPE;
> +	if (sk->sk_family != ctx->family &&
> +	    (sk->sk_family == AF_INET || ipv6_only_sock(sk)))
> +		return -EAFNOSUPPORT;
> +
> +	/* Select socket as lookup result */
> +	ctx->selected_sk = sk;
> +	return 0;
> +}
> +
