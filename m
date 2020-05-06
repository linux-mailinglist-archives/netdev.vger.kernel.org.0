Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5791C68D9
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgEFGYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:24:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57496 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbgEFGYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:24:05 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04669O8W019593;
        Tue, 5 May 2020 23:23:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=OzmW7mL6shxD1+WRptcgO6TYL/GdogSRTENte/IYWIs=;
 b=HvDva51Z0J/9OZ3hPV4k5vV05VVYbHSCAvdnSlekeGZw4haYSBYMJ6G1uYizf8DB6X7S
 fPJXFU558EFNFrx184Og0n4g2nM87Ds4QDzIy34dPjRGSlHSyaKmaBxMCVb9Lw6naS15
 Mc9jdBM1KkHs+8VILB9a6QJ2P3Cd0XLLTYw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30s6cmttwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 23:23:47 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 23:23:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X10VZaCNtR9kP4/S8LEqDjW1XUyyVKClgeA8X86TAFrGbA8+5R88bUbUb576BpVwPBXBjC1V/ec58uTU0VCCVHnH0LSItsKQPp/JyWo9zQH0VK+9DGT6nD0AnrW/DMaJfG6Zpf5ekXLfxXMYUEJqprR58v22PYJU1YCkbGrKxnjlzMfU8K2wLVSqVfCKEdtQ0x6yw8R6OKOoj3anPsD9Braz8Jy/GZ2lKcGNZbbm6n9ivrSHkzUeuR3aScDrOZAspM2gucz+IcF617gdvz6GYoxDMvwZ8d1TtxOlMDSpF2+gAZMxw/Djp9Lh+R3W90u+WstVEgurCpZbq2PwPrwhCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzmW7mL6shxD1+WRptcgO6TYL/GdogSRTENte/IYWIs=;
 b=YGuuIiYSqHwcQ4a1wLZlR011tNLgiqSqrx1lfoRT9G/XAfZY4LjCpO+fkzJXVVAWdpjHn2XopL8tJPDXLkJPcdmiEZTPO533nLjRv5lvR2WH0L9dhzvYekrPh3xTP8Wd4hfCKMaHj/kU2r0LjubQchEAlurii277osZfVwIEIHwjdBfT2cuPODWCBVZzlflnhBID1vRnbTwi1ujb1ZQphPsRGAil1wBMchZqjyt4ZFUQGfd76m5Cc4lS3PhWRe50ESXT+4a3LX9qPeXnGhHT/YYHkHg3v2Xg+uvwA3wKHk0nOotXl/Fnry3aAydkIdQ7kllRfFjNdXXXxeCPe3sG4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzmW7mL6shxD1+WRptcgO6TYL/GdogSRTENte/IYWIs=;
 b=G/0ZY6IyqsPBSikKd5mDubhV6c0fI1JhUepUM8aZ/GyjSQiJbEy9GRP8cnFzyNY7oB7oOsf+KTHiE7ddh9JQennIEqCf59U75ogc6DmovxCuZcEcLPI4QciVi6PPxGlZYgKrPJOv8YnyJCO+Ah4ivzAs45+KjKsLx1xlWev/dJk=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB4027.namprd15.prod.outlook.com (2603:10b6:303:4f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Wed, 6 May
 2020 06:23:45 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 06:23:45 +0000
Date:   Tue, 5 May 2020 23:23:42 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v2 4/5] bpf: allow any port in bpf_bind helper
Message-ID: <20200506062342.6tncscx63wz6udby@kafai-mbp>
References: <20200505202730.70489-1-sdf@google.com>
 <20200505202730.70489-5-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505202730.70489-5-sdf@google.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR07CA0090.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::31) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:2b23) by BYAPR07CA0090.namprd07.prod.outlook.com (2603:10b6:a03:12b::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Wed, 6 May 2020 06:23:43 +0000
X-Originating-IP: [2620:10d:c090:400::5:2b23]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8024b94b-4a8f-4db8-1a35-08d7f186071a
X-MS-TrafficTypeDiagnostic: MW3PR15MB4027:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB4027E319251F39327E86AC93D5A40@MW3PR15MB4027.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DkzuibDxD1sphrf6alCtc+d1UKzxvUkTQFRzDyQor2q++9g4qEtDYOn3++aTnwMn8FWP9u5hP7R1yiP4GtfmQ51Rc32iXae/YMMHAXzxpbMG375P2sPHdL5Op1pryQbv5ZAwngIs7uwQL9G6Z6IhthejU+4mEqRmJqcCc7V1e6ikA6wuvaquKzMpp5uLbduAnbOKg9jq7u7qRzljpLs0QXlQn122sYQEnohakTajwJXbZDPOGkHfFwfi+NgHs0Mpcu7GfAVK9U6qo//G57/iuh692MG2+ydF1SWY4X00+OzW0QFsEwIHJH5dgEJeyVJHLkCTJiTABCKPxKfuOs4vXbpIV3Bo77JGNbrrkibBGji6/b963yE6ewiPPwOGmFu9BBKG+Hs+cNPKLDjmZdH4zkbqMDGp5KxpR2aRoRw17m8FTW4uFbz2yTKfGxRSkdogGZLpIA7/0jRlPHdg0p0J90NHpZj4RqkNdqLEB8MlScSuKa298z6/IGDo/EBn3elmSHzKIzpeIRJKlVVRTD9MJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(366004)(396003)(376002)(346002)(33430700001)(9686003)(478600001)(33716001)(33440700001)(8676002)(186003)(16526019)(55016002)(66556008)(66476007)(5660300002)(1076003)(66946007)(6496006)(8936002)(6916009)(2906002)(52116002)(316002)(4326008)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: t1bsKZsX7tamDcK41bwbHFg3C5MwA+W6vvrO6SApdBUz8Ql/CF5AMgKZrmu2kZ4KORPrW23RWf+6/c9ryp+GKa5rp2mOhdS9aO8bExetOv5lij4iSsz/HyQX+fsBGAqDJnmJcUmAZW7b+wl0CQdde4UnE2yYXqIlQ8l6MgBkXmxBmQj9Ye7f3upia1pXKOpwtNfi/OphcxjJAXz2flxSuqizv936UWH6Rvy86V7X+xABNh4hDoYuJnneAutOe1mCuWPWYSH8S9f/IxzAKUZIHmKLpiy8AbXySQ/L/DpqSnFSOY+klCXkQI3JweLYGAdBOaQPz27wahScvPiQxFYrXmwbi52StoNas9sb1cbJuPm3vcbD9b+iw0sX3372FF3sG37Rz5XGcPfTULiTUwlVt/kabRAztiUNvbtAZtZkiw3C+7fpFfpGx7VvxZ1CmD9EMvcaWKYd/fBskW5dUkqfj/KuOXOA2JnvP5cWsDRPu40Vr6DBdy2VscU+RE6hBD2hEh0oqZy7ow1wLI1e+je6FYY6ozgNbOn8ZUOp5MUZWORcgEug/z9FQMp/meuPFuAiFlvyBS/siSCH+/dB09NiyB30bAoV+VeJcq5PnX8CV03fj2uQmOGQOzWELYFSncsStU6oPB8V3i+BamY9urJTA7HqyUk+QMKIa+s2P4/xOpLCwXFkyNim4H7XwF4hiIR+zSU8oB7lC7gk4byg1U7iyvWmcp5Fw0PJG2QJEJfx+CzIKewXQ58gPCIiFErEy7Zzdq4FDWNVPuLWz3ZlVx+rdkOodoLSzP7ncyXUqIbnJq8lR0/u8r4v96OfmsW0IsHCssdepMeHs1jXl2fAS17Hrg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8024b94b-4a8f-4db8-1a35-08d7f186071a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 06:23:44.8693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WIEPxZvysuaBq0rrHfPpp7LBZt/Jui6eTEB6W0uDtEsxBRmLdBwubzHduYZ8HuFK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4027
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_01:2020-05-04,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 spamscore=0 suspectscore=2 clxscore=1015
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005060047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 01:27:29PM -0700, Stanislav Fomichev wrote:
> We want to have a tighter control on what ports we bind to in
> the BPF_CGROUP_INET{4,6}_CONNECT hooks even if it means
> connect() becomes slightly more expensive. The expensive part
> comes from the fact that we now need to call inet_csk_get_port()
> that verifies that the port is not used and allocates an entry
> in the hash table for it.
> 
> Since we can't rely on "snum || !bind_address_no_port" to prevent
> us from calling POST_BIND hook anymore, let's add another bind flag
> to indicate that the call site is BPF program.
> 
> v2:
> * Update documentation (Andrey Ignatov)
> * Pass BIND_FORCE_ADDRESS_NO_PORT conditionally (Andrey Ignatov)
> 
> Cc: Andrey Ignatov <rdna@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/net/inet_common.h                     |   2 +
>  include/uapi/linux/bpf.h                      |   9 +-
>  net/core/filter.c                             |  18 ++-
>  net/ipv4/af_inet.c                            |  10 +-
>  net/ipv6/af_inet6.c                           |  12 +-
>  tools/include/uapi/linux/bpf.h                |   9 +-
>  .../bpf/prog_tests/connect_force_port.c       | 104 ++++++++++++++++++
>  .../selftests/bpf/progs/connect_force_port4.c |  28 +++++
>  .../selftests/bpf/progs/connect_force_port6.c |  28 +++++
>  9 files changed, 192 insertions(+), 28 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/connect_force_port.c
>  create mode 100644 tools/testing/selftests/bpf/progs/connect_force_port4.c
>  create mode 100644 tools/testing/selftests/bpf/progs/connect_force_port6.c
> 
> diff --git a/include/net/inet_common.h b/include/net/inet_common.h
> index c38f4f7d660a..cb2818862919 100644
> --- a/include/net/inet_common.h
> +++ b/include/net/inet_common.h
> @@ -39,6 +39,8 @@ int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
>  #define BIND_FORCE_ADDRESS_NO_PORT	(1 << 0)
>  /* Grab and release socket lock. */
>  #define BIND_WITH_LOCK			(1 << 1)
> +/* Called from BPF program. */
> +#define BIND_FROM_BPF			(1 << 2)
>  int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
>  		u32 flags);
>  int inet_getname(struct socket *sock, struct sockaddr *uaddr,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b3643e27e264..14b5518a3d5b 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1994,10 +1994,11 @@ union bpf_attr {
>   *
>   * 		This helper works for IPv4 and IPv6, TCP and UDP sockets. The
>   * 		domain (*addr*\ **->sa_family**) must be **AF_INET** (or
> - * 		**AF_INET6**). Looking for a free port to bind to can be
> - * 		expensive, therefore binding to port is not permitted by the
> - * 		helper: *addr*\ **->sin_port** (or **sin6_port**, respectively)
> - * 		must be set to zero.
> + * 		**AF_INET6**). It's advised to pass zero port (**sin_port**
> + * 		or **sin6_port**) which triggers IP_BIND_ADDRESS_NO_PORT-like
> + * 		behavior and lets the kernel reuse the same source port
Reading "zero port" and "the same source port" together is confusing.

> + * 		as long as 4-tuple is unique. Passing non-zero port might
> + * 		lead to degraded performance.
Is the "degraded performance" also true for UDP?

>   * 	Return
>   * 		0 on success, or a negative error in case of failure.
>   *

[ ... ]

> diff --git a/tools/testing/selftests/bpf/prog_tests/connect_force_port.c b/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
> new file mode 100644
> index 000000000000..97104e6410b6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/connect_force_port.c
> @@ -0,0 +1,104 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <test_progs.h>
> +#include "cgroup_helpers.h"
> +#include "network_helpers.h"
> +
> +static int verify_port(int family, int fd, int expected)
> +{
> +	struct sockaddr_storage addr;
> +	socklen_t len = sizeof(addr);
> +	__u16 port;
> +
> +
> +	if (getsockname(fd, (struct sockaddr *)&addr, &len)) {
> +		log_err("Failed to get server addr");
> +		return -1;
> +	}
> +
> +	if (family == AF_INET)
> +		port = ((struct sockaddr_in *)&addr)->sin_port;
> +	else
> +		port = ((struct sockaddr_in6 *)&addr)->sin6_port;
> +
> +	if (ntohs(port) != expected) {
> +		log_err("Unexpected port %d, expected %d", ntohs(port),
> +			expected);
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int run_test(int cgroup_fd, int server_fd, int family)
> +{
> +	struct bpf_prog_load_attr attr = {
> +		.prog_type = BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
> +	};
> +	struct bpf_object *obj;
> +	int expected_port;
> +	int prog_fd;
> +	int err;
> +	int fd;
> +
> +	if (family == AF_INET) {
> +		attr.file = "./connect_force_port4.o";
> +		attr.expected_attach_type = BPF_CGROUP_INET4_CONNECT;
> +		expected_port = 22222;
> +	} else {
> +		attr.file = "./connect_force_port6.o";
> +		attr.expected_attach_type = BPF_CGROUP_INET6_CONNECT;
> +		expected_port = 22223;
> +	}
> +
> +	err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
> +	if (err) {
> +		log_err("Failed to load BPF object");
> +		return -1;
> +	}
> +
> +	err = bpf_prog_attach(prog_fd, cgroup_fd, attr.expected_attach_type,
> +			      0);
> +	if (err) {
> +		log_err("Failed to attach BPF program");
> +		goto close_bpf_object;
> +	}
> +
> +	fd = connect_to_fd(family, server_fd);
> +	if (fd < 0) {
> +		err = -1;
> +		goto close_bpf_object;
> +	}
> +
> +	err = verify_port(family, fd, expected_port);
> +
> +	close(fd);
> +
> +close_bpf_object:
> +	bpf_object__close(obj);
> +	return err;
> +}
> +
> +void test_connect_force_port(void)
> +{
> +	int server_fd, cgroup_fd;
> +
> +	cgroup_fd = test__join_cgroup("/connect_force_port");
> +	if (CHECK_FAIL(cgroup_fd < 0))
> +		return;
> +
> +	server_fd = start_server_thread(AF_INET);
> +	if (CHECK_FAIL(server_fd < 0))
> +		goto close_cgroup_fd;
> +	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET));
> +	stop_server_thread(server_fd);
> +
> +	server_fd = start_server_thread(AF_INET6);
> +	if (CHECK_FAIL(server_fd < 0))
> +		goto close_cgroup_fd;
> +	CHECK_FAIL(run_test(cgroup_fd, server_fd, AF_INET6));
> +	stop_server_thread(server_fd);
Thanks for testing both v6 and v4.

The UDP path should be tested also.

