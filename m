Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F7C1D8AA3
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgERWRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:17:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37574 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728115AbgERWRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 18:17:49 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04IMHNMp032665;
        Mon, 18 May 2020 15:17:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=yfSDMkYrUOAOu7E4zUYaGpMQm1HDmKgIxUZPEo5ta60=;
 b=R/WojyQyqaa0RzqtNm6KnUjFfuDT2hGyX9grJFdlu28Lj83eVbasqQkrB01ywOPwtP+G
 v/mxuqnftVQRmD0gV7+SHEGnV7gfvu/SS0zgz7/ROtfhJZ2qa9ylFsCPnBYs0irAfexB
 AeY3UfnVgqv9ZuCQvCuIIzsjOTA4Qo3mh9k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 312bup00em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 May 2020 15:17:33 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 18 May 2020 15:17:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/OxcjbH3faPh1BQ1NzWNR1Xo359ApVmwYMgkF9clgxLXmge5+O1odlzNliNmjPEdqdyzchSl0XOaBqT+jUWveptxGPhGxebya77SMIVu8/B+Ha/c45dLaVzLX02sW0axbrk6wqyJ2v4u7HUEDhGP0lEoIXGyR0nOunsgFSjXW24vC/lbwpLAvVUCPJqQa8Os0SXd/rOygz/o5kS/Ul4059nxsPFxCJaqQyyT8BNmDy6qmSDCeOyQWcTEbVCxZHgeLt1zmVcaDkD4ccUxA3SXfX7qP1RlPVHHaN0kKCMGThCrcBVvhsSOXk1l5uH6+Gdw04TIbf/v9VmcBN31VnDsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfSDMkYrUOAOu7E4zUYaGpMQm1HDmKgIxUZPEo5ta60=;
 b=RwZMg3CUQNZscIljm7osUuhtgZ5FbJrfxJbja2dh476gzcEPxmFEzzVNIHLBjaWiChTUetjo2Y8heNWLdQQrZSwfw1QuxoHqkng0sZvkqiZHOp2mkbz2kfYdYx/Juizlh6XNi5m4h3a241UsYIBmhwx0CQhgNhc6jqCxcFNq+MBXFuDzZ7wSK4kB7d9NqmFPkMPI+WJJFMs99v5rzF+cEqT1mWXy7KSDCsvao15j0doVKq/o+iIbYFRs+SBzg6iIp94dl7OuAEeBFcTdWhldtAMvylcAgDxHNmZ8aLwfN+w91YpSo9tEsvTSf0I2qWVjTvXKIBgdVisbK1bzADVQPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfSDMkYrUOAOu7E4zUYaGpMQm1HDmKgIxUZPEo5ta60=;
 b=YuohXjwKKSF/rwvZuxr3uir3EDQhutxNNnRhpigb2AClqKXYDrn0QN2S3Qy7Ev/6B/LYsgIn4zU2GfrNmPfJj3VozbnVQZyV7NQx3UuCpNh/6fXDOqd44EE/qbV49Cdt5QYjqWNd8WbKJmu/ip2dUqZViwdZhtm1Ssr/VO43z+c=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB3191.namprd15.prod.outlook.com (2603:10b6:a03:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Mon, 18 May
 2020 22:17:30 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::f9e2:f920:db85:9e34]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::f9e2:f920:db85:9e34%6]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 22:17:30 +0000
Date:   Mon, 18 May 2020 15:17:28 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <ast@kernel.org>, <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <sdf@google.com>
Subject: Re: [PATCH bpf-next 4/4] bpf, testing: add get{peer,sock}name
 selftests to test_progs
Message-ID: <20200518221728.GA49655@rdna-mbp.dhcp.thefacebook.com>
References: <cover.1589813738.git.daniel@iogearbox.net>
 <1b9869b34027bc0722f4217a0b04f1cccccc5c33.1589813738.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1b9869b34027bc0722f4217a0b04f1cccccc5c33.1589813738.git.daniel@iogearbox.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: BY5PR20CA0026.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::39) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:2799) by BY5PR20CA0026.namprd20.prod.outlook.com (2603:10b6:a03:1f4::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Mon, 18 May 2020 22:17:30 +0000
X-Originating-IP: [2620:10d:c090:400::5:2799]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5bfa7ea-553f-4828-8ada-08d7fb794170
X-MS-TrafficTypeDiagnostic: BYAPR15MB3191:
X-Microsoft-Antispam-PRVS: <BYAPR15MB31911B8AE593FDFF77989D33A8B80@BYAPR15MB3191.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AINPZDM08QVsqz3fX/hqdJej18rdhOnrUV62L3hhjl9Pjlmf99XoO/sYhRDNb/UQOsTrUs6qzTgDHWVt1UdeGYKFDmvcq+vAdq7kouhqWu+GxCqRBzS5XegvIWaPjg7WKD88EZlGfIStEjvIPGV1grUtuVle8aW9jp3Qlm/HghAzQHH2BiG8HPI0isnpkrRRsrdqa9AmMrj0O773wLC1hzW8+gvwBQPD+JNbfSThn/fq8881LjR/naPHB2J1K9etUbLHtrwoi3tl7gTV6d3AEmq42IE28tT5DBRvZm76c6ntwDOKbwqWSrWBZz3+3bo27LaT+EVYCdhSFrrJlr3VQ7oqWlXzWVScVCpz8g9SVVPy55ZfhJ8U00pl5cKe8QKllimGBs5M1ad6xtifI+AITzoQsak2rNaQSMtC6YlH8MY7qs0olVFiwMBBk1PRsrx7AxK3AUx5Fuq6DoBs2l8IDDPjxl/sSJTYInob68jq55SlDhZyfbHPXt9F9mi+200S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(366004)(136003)(346002)(376002)(9686003)(8676002)(66946007)(66476007)(66556008)(2906002)(33656002)(478600001)(4326008)(86362001)(5660300002)(6486002)(6496006)(6916009)(16526019)(316002)(8936002)(52116002)(1076003)(186003)(142933001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: j3HPxKH4y0tC+SnVB5+W482LLQQcImh7HFrwU7dtomUioIxelnQy9Jlrv4WjWn6e9QtY4/kDND5PyWcm3xGv8InwCYpJ5ubgG+Id3Ddb1gH7cEKNCULt8rzbfKOCJry2ryeS+n2jKEv2XwK+lFbwfkE0q1d/3VOU5D4FDSVhN0jnWLOwzycNrPmIhODqph/6e8E2EDY4u4N09uveE64ZUgETr3SbKqfOphEbkULps4s/RrbrbRGJ0zu9mD1iS+wJ70vrw8sSvpmf1IbOa8jCCNx0wwZTXw5Wp6eHme2zNf3rNVLKhsqh15zevWkK09xikSCtxKjdeDm55DsFYc8AlrYAKjo5z7mE5hHAjg7fiOl9xLd9YblGhjYK7pNu23A0Z6++rjY0M8SU/1b732Vvpfa9lt3lkSy3/3Ege0qn3YkTEWEqZ2247i8rfdiyuaEd77tPI9wp6Yh+8rHKgFfdL2N9AgHZrBjNGnVi8LSMEpg56rIq3l878BDErXxagJAv94EGc3ta9SnSbXgAT3cy5w==
X-MS-Exchange-CrossTenant-Network-Message-Id: a5bfa7ea-553f-4828-8ada-08d7fb794170
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 22:17:30.5852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HlhZ3mCVWX3vAkXlMui/rUegSKoTdLbW6ndc3s9jzlhJa3ON3SupdBGe+8FpPQk0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3191
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 phishscore=0 clxscore=1015 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> [Mon, 2020-05-18 08:35 -0700]:
> Extend the existing connect_force_port test to assert get{peer,sock}name programs
> as well. The workflow for e.g. IPv4 is as follows: i) server binds to concrete
> port, ii) client calls getsockname() on server fd which exposes 1.2.3.4:60000 to
> client, iii) client connects to service address 1.2.3.4:60000 binds to concrete
> local address (127.0.0.1:22222) and remaps service address to a concrete backend
> address (127.0.0.1:60123), iv) client then calls getsockname() on its own fd to
> verify local address (127.0.0.1:22222) and getpeername() on its own fd which then
> publishes service address (1.2.3.4:60000) instead of actual backend. Same workflow
> is done for IPv6 just with different address/port tuples.
> 
>   # ./test_progs -t connect_force_port
>   #14 connect_force_port:OK
>   Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Andrey Ignatov <rdna@fb.com>
> ---

> --- a/tools/testing/selftests/bpf/network_helpers.c
> +++ b/tools/testing/selftests/bpf/network_helpers.c
> @@ -5,6 +5,8 @@
>  #include <string.h>
>  #include <unistd.h>
>  
> +#include <arpa/inet.h>
> +
>  #include <sys/epoll.h>
>  
>  #include <linux/err.h>
> @@ -35,7 +37,7 @@ struct ipv6_packet pkt_v6 = {
>  	.tcp.doff = 5,
>  };
>  
> -int start_server(int family, int type)
> +int start_server_with_port(int family, int type, int port)

Nit: IMO it's worth to start using __u16 for ports in new places,
especially since this network helper can be adopted by many tests in the
future. I know 4-byte int-s are used for ports even in UAPI, but IMO it
just adds confusion and complicates implementation in both kernel and
user BPF programs.


-- 
Andrey Ignatov
