Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDEC2639B9
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgIJCA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:00:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38172 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729941AbgIJBpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 21:45:41 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08A0NWbw005118;
        Wed, 9 Sep 2020 17:29:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=jzoqKIjDfnCWYGwiludD0kx/Ll1qTuL1mtpjiG6ZYlU=;
 b=kjGVPqafGkl+okP7Us0RQrMSrIKgWcyJFI8ztK2aYe5mFf5prh9uqECDmlQj7QTtUFaN
 p12YmoXciz9E2aPfMXSejped7D7t37jthWEQkB41GsLfAaqPcZwe+F3vuZXrNbT9NJ7X
 jOKW8KTHQ3D3WLlVif3yld/Wcy3RZneAYtw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 33exvhuhxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Sep 2020 17:29:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Sep 2020 17:29:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEOTtl2tZCnumHoJj52vApPfBPtPDCsRxaCqwKjkhdTW8QsmH5wmuoR8NvntgEUttTwx5mAmOqp0kUY187MTjDxryFIEze3yC6+oNYyJulHXHfRvm7Ag42viiFcCPTBttEamJJJxCHhWAG+/nv89Laa6H/Z3Oy6rYwIruDXxuc/AwHNjJNjgj6vEsgckJCB7Lfi3gjkg/ecENuq3CTzt0poc4+UnasupQNMkpTbpPhKbGvIx9PO1CnO+677fOEs92prt6CRM8zLZ8gko00A5CM8AbSqr+wb8zgs+07jdHVBOmhfNp/wlxvLIOBfq/YrSlrYyBQWsrmi9vzx4LcAaNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzoqKIjDfnCWYGwiludD0kx/Ll1qTuL1mtpjiG6ZYlU=;
 b=hPyRJxKWwfw3QD7SqG7iGxlXFJ8Qv4P6kbSVBwq9hrRxxEnpHljkWFMAYDeIuoV9+f0na25vEeUCMKGzDr+aYWxyiLjHcSfSqvNEXR0/P//DcUwq10kX0mXWjVPdVpPEGIOAVrxpwVb4youTZ1ViyM7bnORcVHuowWtE28oL4tQuvn3RdLABoAiLjltV2APcoVnw76m2V8/4pyrgN3OTF4l3p25SmeYPJOKc/XGyHQyW0Z1xXTBggRK1eJ07e1AfdUWzPMRT6wmDEAZvAUg3Wzl7f2nQ8/t7NjMccY6zeWWSiRC7JVk/9KzEbBQP1ZtQBsfSiMHQg3otnuNCbc1JsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jzoqKIjDfnCWYGwiludD0kx/Ll1qTuL1mtpjiG6ZYlU=;
 b=ilyTbhlMCl2lT8MVUHeZpjvcdMuDw2u96CaIqkqxNtGhHA4b5ORzer1n2M5LGghIouqQz+/NY8MlSMaaFA/invzcALNZ+LeQSAeEG3XwOM4zBi6PIFSNSmrz8TAORDsbE+mgK2fbcKD0Wee6sYogQQdbHEVn+RtBwmQmebwrehc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2328.namprd15.prod.outlook.com (2603:10b6:a02:8b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Thu, 10 Sep
 2020 00:29:14 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3370.016; Thu, 10 Sep 2020
 00:29:14 +0000
Date:   Wed, 9 Sep 2020 17:29:06 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Neal Cardwell <ncardwell@google.com>
CC:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Subject: Re: [PATCH net-next 3/4] tcp: simplify tcp_set_congestion_control():
 always reinitialize
Message-ID: <20200910002906.v7sl6pfpaphrwntc@kafai-mbp.dhcp.thefacebook.com>
References: <20200909181556.2945496-1-ncardwell@google.com>
 <20200909181556.2945496-4-ncardwell@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909181556.2945496-4-ncardwell@google.com>
X-ClientProxiedBy: MW2PR16CA0005.namprd16.prod.outlook.com (2603:10b6:907::18)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f23a) by MW2PR16CA0005.namprd16.prod.outlook.com (2603:10b6:907::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Thu, 10 Sep 2020 00:29:11 +0000
X-Originating-IP: [2620:10d:c090:400::5:f23a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e519f72-8637-471a-07b1-08d855208a92
X-MS-TrafficTypeDiagnostic: BYAPR15MB2328:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB232899C641D0152CF28A27ABD5270@BYAPR15MB2328.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +cRfNLt8G0YvwUmUYhgZaYbjejQ5CT9/rVD2arbLzflnWqVSEzZX45lq7hVswsm1PQzw3AjizQrCWDIeq+FqBtXqeh7mLrRu4T0Q2o4QVYlDULo2FtE0t9uizP8X+HdkFuSRd1WudIHHT5FLKalpFy8mJ8uipioSp286QbcUa257gjwG6IjHk7WMBpllaOTNydtPkhI2rb+13Q7Y7HCQokdyYP5IKWX0ctx3AlCMR/5qinQhRFDIivfc32cckVqjHqWPcOPMkXHrVZ8HvWoQjVGbp+ze43qwUXeUtKDMUd4r4kJccpHOJh6aBGvxc50gW4otlyEQXkCMQtmDr7lqag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(366004)(346002)(136003)(5660300002)(54906003)(7696005)(16526019)(55016002)(6506007)(8936002)(52116002)(8676002)(9686003)(4326008)(6916009)(66476007)(66946007)(66556008)(83380400001)(316002)(186003)(6666004)(86362001)(2906002)(1076003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 28lLeIuwnj6WG2h7GgpsuSokvSNqC0L9GR7zbjl/ljGlAOBCr17rQVWxop9CZb8jUXShsKk54Cjv02m9wJ4WP9OkHitnO4Xh1Rd7ncGahOggHGxoOymouWRKFEuA1SUONiPjjcETAbpTSoVOA9UNAGHaP2LkWSmZgLvR8dnn2u7WFM5QNmrh56exB38iWGL2aPnPNMsTYhNKkQWlXiZYUMAwo/2rab5ayI3M2uQFeGF4t5K9xfxRmLQQK4NQj0epwCf0ERQ1LucMaOuK01dVNeRY/QTrgBcOUTmrKTP3G2XJRyonARvzRa/Hibpn7FU/Rr7cNuPJUa3YRTrT3gengTix6NhAHcp0IoxFs201zL0gwRdPYwU6xhgIUl28c2J0mOdg/TWC28aPVoP+ujeB0tY22CB37w+JNzJiMZlZpWMsJezJsJaUfmJpAdygxSMq8blUldwJFFwiMgEy7PD4vA9S4tAQbKKtO1/hVJcY6q2v4EBCj+zWVKgGjcP+xTIOF3PZDRK/+oUqMe3DjEZAuJvGkewQfG1VWBUVhoneuZZWqKfHSYCoo2UZnX/PdAH3hONocMi5oZ8SLkP8VHeOf2helf/NaXCumkL4C2v37L7bBY08SC7oiQETH3mtZVAKZp8B5jubiNuYC3lAW21eUFhkehlGyNyiHzi9yZ1dynU=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e519f72-8637-471a-07b1-08d855208a92
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 00:29:13.9837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sj23I7/j7B0QErPfx9xBRbzYhvKd4TxTlvETBvK3ZKXUnre2XpQoqwcThaFNcwbL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2328
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-09_17:2020-09-09,2020-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=1 clxscore=1011
 adultscore=0 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009100001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 02:15:55PM -0400, Neal Cardwell wrote:
> Now that the previous patches ensure that all call sites for
> tcp_set_congestion_control() want to initialize congestion control, we
> can simplify tcp_set_congestion_control() by removing the reinit
> argument and the code to support it.
> 
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Acked-by: Kevin Yang <yyd@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Lawrence Brakmo <brakmo@fb.com>
> ---
>  include/net/tcp.h   |  2 +-
>  net/core/filter.c   |  3 +--
>  net/ipv4/tcp.c      |  2 +-
>  net/ipv4/tcp_cong.c | 11 ++---------
>  4 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index e85d564446c6..f857146c17a5 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1104,7 +1104,7 @@ void tcp_get_available_congestion_control(char *buf, size_t len);
>  void tcp_get_allowed_congestion_control(char *buf, size_t len);
>  int tcp_set_allowed_congestion_control(char *allowed);
>  int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
> -			       bool reinit, bool cap_net_admin);
> +			       bool cap_net_admin);
>  u32 tcp_slow_start(struct tcp_sock *tp, u32 acked);
>  void tcp_cong_avoid_ai(struct tcp_sock *tp, u32 w, u32 acked);
>  
> diff --git a/net/core/filter.c b/net/core/filter.c
> index b26c04924fa3..0bd0a97ee951 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4451,8 +4451,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>  			strncpy(name, optval, min_t(long, optlen,
>  						    TCP_CA_NAME_MAX-1));
>  			name[TCP_CA_NAME_MAX-1] = 0;
> -			ret = tcp_set_congestion_control(sk, name, false,
> -							 true, true);
> +			ret = tcp_set_congestion_control(sk, name, false, true);
>  		} else {
>  			struct inet_connection_sock *icsk = inet_csk(sk);
>  			struct tcp_sock *tp = tcp_sk(sk);
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 7360d3db2b61..e58ab9db73ff 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3050,7 +3050,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
>  		name[val] = 0;
>  
>  		lock_sock(sk);
> -		err = tcp_set_congestion_control(sk, name, true, true,
> +		err = tcp_set_congestion_control(sk, name, true,
>  						 ns_capable(sock_net(sk)->user_ns,
>  							    CAP_NET_ADMIN));
>  		release_sock(sk);
> diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
> index d18d7a1ce4ce..a9b0fb52a1ec 100644
> --- a/net/ipv4/tcp_cong.c
> +++ b/net/ipv4/tcp_cong.c
> @@ -341,7 +341,7 @@ int tcp_set_allowed_congestion_control(char *val)
>   * already initialized.
>   */
>  int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
> -			       bool reinit, bool cap_net_admin)
> +			       bool cap_net_admin)
>  {
>  	struct inet_connection_sock *icsk = inet_csk(sk);
>  	const struct tcp_congestion_ops *ca;
> @@ -365,15 +365,8 @@ int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
>  	if (!ca) {
>  		err = -ENOENT;
>  	} else if (!load) {
nit.

I think this "else if (!load)" case can be completely removed and simply
allow it to fall through to the last
"else { tcp_reinit_congestion_control(sk, ca); }" .

> -		const struct tcp_congestion_ops *old_ca = icsk->icsk_ca_ops;
> -
>  		if (bpf_try_module_get(ca, ca->owner)) {
> -			if (reinit) {
> -				tcp_reinit_congestion_control(sk, ca);
> -			} else {
> -				icsk->icsk_ca_ops = ca;
> -				bpf_module_put(old_ca, old_ca->owner);
> -			}
> +			tcp_reinit_congestion_control(sk, ca);
>  		} else {
>  			err = -EBUSY;
>  		}
> -- 
> 2.28.0.526.ge36021eeef-goog
> 
