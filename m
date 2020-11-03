Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236A82A37F6
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgKCAnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:43:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30248 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725940AbgKCAnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 19:43:10 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A30Peda001343;
        Mon, 2 Nov 2020 16:42:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=DRxxZruROjlwuTPO1YMshJriUD14pvgsR9woQTik72c=;
 b=aNTxxsGzHoqkr9YlCN5h/sAAimc8Yt62xHFMvvuR48Y0vOoNEyrrdcjb7Sq6kY4BEals
 pwOfcSYYkKnjBfqOxeXMK7zOhD6a2YzWWX5qi3aTygZf7mDmWJzKFRyS/43qpPl50bFK
 MMyqLJVmCFi5YpMluxpWL21Z94O6NNZuAXw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34hr3h858m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 16:42:53 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 16:42:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGB+ToLn2TdeYKbmpJgpKY6Smc41NE14fVE4yMe8Xw9sn89e320vt4tWbfpMlZ7laK088OZp/JdUjWDpbbMx0EsiKdBKYwvL1KLSWj4gVF1bsh9UQXju7C+4Zxm5+J77lFjAtTqOPfEFX4DfOGe3zUHlKkj5L5WS/cHys7ew5dtbZsfua6/ioebldoKMHen3G1rBGW0MfHeFiab7iuQuY1BUNO78clFjYib3U4U3PDH5HCYT8lP6FiTC2SxyxppJHcjwh2dg8jrCmlopHciABLl+AVCyYglEOFdzj0SjvAcaPdh4qlDeqaQ8XVEQ8swpVDJ3yadCGqSljnOa+89zag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRxxZruROjlwuTPO1YMshJriUD14pvgsR9woQTik72c=;
 b=dTdJ0hp4qrbRqmlp49CD+rJoHolrSh3LOQCol5gAiJS2VLNmKvBaVgvHUKQypK3mTSug74w6/KIknNBlshfIPZ3Td2FGEhdGUZnzEQVWLhAlnCov90Z8a0j3gJW9DwF6T/xGArwkuZJ8+ml1tFGmmsMyYG7IIUgHaTWJ49yyEjlqMIklIRu/qs2MCkpi6sl/diCpI0Ud6u2rm098QOHSTm9ra15ugZChtDSyFdV5rtvMK5sgir4fLAOshdG8dStF+vKAvSac196CSN+vQn86h7RLHbHclk6tQstnWQu+teexPjMhcioaZOKLwtepuQeRMKeGr5ohPPY6r3W83zSzkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRxxZruROjlwuTPO1YMshJriUD14pvgsR9woQTik72c=;
 b=bnl1DKcHeBqFpS6xN40jtij6H8k6/kZ9VNES/7DIq+qvX06dHG0eM9CPOxA2j+j7HoKY/Og97t8kVaKJasgUJ9e7TC1xnx1GFufyjEKv64PlWYcUdBlDHu8+JS81iOoZnSnzIgrJGJvY9pZoHcx/uEa10ELjcq0WoJl+9nhDxYA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3205.namprd15.prod.outlook.com (2603:10b6:a03:104::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Tue, 3 Nov
 2020 00:42:51 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 00:42:51 +0000
Date:   Mon, 2 Nov 2020 16:42:44 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, <edumazet@google.com>, <brakmo@fb.com>,
        <andrii.nakryiko@gmail.com>, <alexanderduyck@fb.com>
Subject: Re: [bpf-next PATCH v2 3/5] selftests/bpf: Replace EXPECT_EQ with
 ASSERT_EQ and refactor verify_results
Message-ID: <20201103004205.qbyabntlc4yl5vwn@kafai-mbp.dhcp.thefacebook.com>
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417034457.2823.10600750891200038944.stgit@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160417034457.2823.10600750891200038944.stgit@localhost.localdomain>
X-Originating-IP: [2620:10d:c090:400::5:8aa6]
X-ClientProxiedBy: MWHPR12CA0070.namprd12.prod.outlook.com
 (2603:10b6:300:103::32) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8aa6) by MWHPR12CA0070.namprd12.prod.outlook.com (2603:10b6:300:103::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 00:42:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 474ac66b-de28-48d4-33ad-08d87f916494
X-MS-TrafficTypeDiagnostic: BYAPR15MB3205:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB32052A955B4893C4BD9C08B7D5110@BYAPR15MB3205.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jPuQFqGIDwqA4bVvco8xitswYM6YVck+e/Dtxm/JjdX4/U3hWN7sisrySxc5mRH6/kLxkWrtLdoZVZYuJTvybpbthgqdDQtCGB26EQCWgCAqAlxliHmKBSvuOoLqxeWaIRStbhrHCiRDCoMd3nGAPHkfjcraPnTQ9kD/8YJxH/JRhA7ONGEIGNW50fXsAceSht7la1VdFlFTUzIsOTMDEOZBkvnzjLtiolll/SYiqckoISXvajBt/jEv5ifcNnf1M0Pqk0cZ5+Hore1YAyS5x9h9LqTLWhFoHcfozmD+DGMWhp5UxVKCTd5Hks9peXDR0FMuA4Tag3mF8wi4jTd32Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(346002)(39860400002)(136003)(1076003)(83380400001)(9686003)(5660300002)(66556008)(55016002)(86362001)(66476007)(66946007)(6916009)(8936002)(7696005)(52116002)(8676002)(4326008)(2906002)(6506007)(15650500001)(478600001)(16526019)(186003)(6666004)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: DIAwDAoXbqzF1+jy1GwhgCfU+xEJ5J43JPqtNCuU9j7/nyoLm+OcggUo11cgfjdMEfLtolkcOKBZcH950mj98A745nvb2dYIqEK2qmHyrAdohu/jbTDGR7WQ0RpulAHuCWd+20hx6onGZQaALPxU2yBrj5/m9b0x2X6MBuN+S0j7iw9KXFihlDoNQUk8G4W0RE1x993w6Me2Ejmng/qBUXBHhSiEO31uiC2k0YxGXxr5zbf1TrJqdcSt+a3u9qb0/cfxCKaCduYW1Ytqh5MLpmSFFz2lXxlPfuOqbrupsIYPsF3YyEzShKlu7TRPZScAHXpQi8iiEpcoKhLe8Lx0Cdnp3mH4YIpFK9nPDLckaS/ICQ/LivWzIFs5S8v6RX3GuT8saRTO5xxt9SSpMGofX7k7LAaT1XPnhiCTWixOKGWp5M+dJD0yKGKFQ291360EyUW5m1/VUI/2YxewvmPI0gAab+alX4IpFalTl5YAatyyQU2n/FV2AzmgSl8RUu2rKfWdcqWLg/SH9gEdkCMtVFNCg3QQ1VDtNmhXqyYJDrmfJAUOI9zI26UpmE6qJdynv63dK8m4bWY320at9Ns9h7oQIbyiZrciKk999afTWUSh3oha3hyDRDWjQynCCM5zhdPn4Y3L6rmALjg5bZGcyUhTzg35FoR1Q7/1rCKtya4=
X-MS-Exchange-CrossTenant-Network-Message-Id: 474ac66b-de28-48d4-33ad-08d87f916494
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 00:42:51.1582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3aaJfUU1Kx/uHdAcsG/dJTN7puVUi1pPJZL4W8YV2RE7JNusi1CBoMo7Ul7cNz2J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3205
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_16:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 impostorscore=0 suspectscore=1
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 11:52:24AM -0700, Alexander Duyck wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> There is already logic in test_progs.h for asserting that a value is
> expected to be another value. So instead of reinventing it we should just
> make use of ASSERT_EQ in tcpbpf_user.c. This will allow for better
> debugging and integrates much more closely with the test_progs framework.
> 
> In addition we can refactor the code a bit to merge together the two
> verify functions and tie them together into a single function. Doing this
> helps to clean the code up a bit and makes it more readable as all the
> verification is now done in one function.
> 
> Lastly we can relocate the verification to the end of the run_test since it
> is logically part of the test itself. With this we can drop the need for a
> return value from run_test since verification becomes the last step of the
> call and then immediately following is the tear down of the test setup.
> 
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>

> ---
>  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |  114 ++++++++------------
>  1 file changed, 44 insertions(+), 70 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> index 17d4299435df..d96f4084d2f5 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> @@ -10,66 +10,58 @@
>  
>  static __u32 duration;
>  
> -#define EXPECT_EQ(expected, actual, fmt)			\
> -	do {							\
> -		if ((expected) != (actual)) {			\
> -			fprintf(stderr, "  Value of: " #actual "\n"	\
> -			       "    Actual: %" fmt "\n"		\
> -			       "  Expected: %" fmt "\n",	\
> -			       (actual), (expected));		\
> -			ret--;					\
> -		}						\
> -	} while (0)
> -
> -int verify_result(const struct tcpbpf_globals *result)
> -{
> -	__u32 expected_events;
> -	int ret = 0;
> -
> -	expected_events = ((1 << BPF_SOCK_OPS_TIMEOUT_INIT) |
> -			   (1 << BPF_SOCK_OPS_RWND_INIT) |
> -			   (1 << BPF_SOCK_OPS_TCP_CONNECT_CB) |
> -			   (1 << BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB) |
> -			   (1 << BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) |
> -			   (1 << BPF_SOCK_OPS_NEEDS_ECN) |
> -			   (1 << BPF_SOCK_OPS_STATE_CB) |
> -			   (1 << BPF_SOCK_OPS_TCP_LISTEN_CB));
> -
> -	EXPECT_EQ(expected_events, result->event_map, "#" PRIx32);
> -	EXPECT_EQ(501ULL, result->bytes_received, "llu");
> -	EXPECT_EQ(1002ULL, result->bytes_acked, "llu");
> -	EXPECT_EQ(1, result->data_segs_in, PRIu32);
> -	EXPECT_EQ(1, result->data_segs_out, PRIu32);
> -	EXPECT_EQ(0x80, result->bad_cb_test_rv, PRIu32);
> -	EXPECT_EQ(0, result->good_cb_test_rv, PRIu32);
> -	EXPECT_EQ(1, result->num_listen, PRIu32);
> -
> -	/* 3 comes from one listening socket + both ends of the connection */
> -	EXPECT_EQ(3, result->num_close_events, PRIu32);
> -
> -	return ret;
> -}
> -
> -int verify_sockopt_result(int sock_map_fd)
> +static void verify_result(int map_fd, int sock_map_fd)
>  {
> +	__u32 expected_events = ((1 << BPF_SOCK_OPS_TIMEOUT_INIT) |
> +				 (1 << BPF_SOCK_OPS_RWND_INIT) |
> +				 (1 << BPF_SOCK_OPS_TCP_CONNECT_CB) |
> +				 (1 << BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB) |
> +				 (1 << BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB) |
> +				 (1 << BPF_SOCK_OPS_NEEDS_ECN) |
> +				 (1 << BPF_SOCK_OPS_STATE_CB) |
> +				 (1 << BPF_SOCK_OPS_TCP_LISTEN_CB));
> +	struct tcpbpf_globals result = { 0 };
nit. init is not needed.

>  	__u32 key = 0;
> -	int ret = 0;
>  	int res;
>  	int rv;
>  
> +	rv = bpf_map_lookup_elem(map_fd, &key, &result);
> +	if (CHECK(rv, "bpf_map_lookup_elem(map_fd)", "err:%d errno:%d",
> +		  rv, errno))
> +		return;
> +
> +	/* check global map */
> +	CHECK(expected_events != result.event_map, "event_map",
> +	      "unexpected event_map: actual %#" PRIx32" != expected %#" PRIx32 "\n",
> +	      result.event_map, expected_events);
> +
> +	ASSERT_EQ(result.bytes_received, 501, "bytes_received");
> +	ASSERT_EQ(result.bytes_acked, 1002, "bytes_acked");
> +	ASSERT_EQ(result.data_segs_in, 1, "data_segs_in");
> +	ASSERT_EQ(result.data_segs_out, 1, "data_segs_out");
> +	ASSERT_EQ(result.bad_cb_test_rv, 0x80, "bad_cb_test_rv");
> +	ASSERT_EQ(result.good_cb_test_rv, 0, "good_cb_test_rv");
> +	ASSERT_EQ(result.num_listen, 1, "num_listen");
> +
> +	/* 3 comes from one listening socket + both ends of the connection */
> +	ASSERT_EQ(result.num_close_events, 3, "num_close_events");
> +
>  	/* check setsockopt for SAVE_SYN */
> +	key = 0;
nit. not needed.

>  	rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
> -	EXPECT_EQ(0, rv, "d");
> -	EXPECT_EQ(0, res, "d");
> -	key = 1;
> +	CHECK(rv, "bpf_map_lookup_elem(sock_map_fd)", "err:%d errno:%d",
> +	      rv, errno);
> +	ASSERT_EQ(res, 0, "bpf_setsockopt(TCP_SAVE_SYN)");
> +
>  	/* check getsockopt for SAVED_SYN */
> +	key = 1;
>  	rv = bpf_map_lookup_elem(sock_map_fd, &key, &res);
> -	EXPECT_EQ(0, rv, "d");
> -	EXPECT_EQ(1, res, "d");
> -	return ret;
> +	CHECK(rv, "bpf_map_lookup_elem(sock_map_fd)", "err:%d errno:%d",
> +	      rv, errno);
> +	ASSERT_EQ(res, 1, "bpf_getsockopt(TCP_SAVED_SYN)");
>  }
