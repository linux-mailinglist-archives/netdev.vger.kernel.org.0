Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD8828821C
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 08:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbgJIG1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 02:27:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20922 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726501AbgJIG1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 02:27:32 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0996P8g3015217;
        Thu, 8 Oct 2020 23:27:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=i2olofHl+JN9+TCJ01OTQspWOR840MBrq33MmZcsQ/A=;
 b=aEE0gWANC2IkMS6vU0QS+h3KdB7IKtIVfrc8irvzo6BoUR3GgsuYc/TRY8Pf2Jcc4ffy
 GscljRoEPBh9ElxTmwPp3oP+MYXeyLR/MouKiQubUvtEv4uXwB7FYwJvVqVuRA9ZqYlj
 mw3eDN2AFap8eCxRa2pLyADRCeZu59aLrTo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3429gpa4em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 08 Oct 2020 23:27:15 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 8 Oct 2020 23:27:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAk1EkKdc42mvt1HQ9OGZe/6bQZ7gquoIBtojbRRel3tE+TuWeJES7NWsOqkPM0iTSlUmYGJQyMheCcmlXP+qzr0U/dA+G9aPm1yznVi/OXbMXiww6q8PdXCkBCaK18QEh2c5mIjc5RbO/70W8mX1oqSFq+bf8WQc3cWm2tIsGMuS1MV10+bVrGpDc9coSCgWJb9uCgblK8US59p4pWy2Bl5tBVeGjozJe5otUUa89rQ/e/tRT5hFrsiTdlVRuOUOAmZ0Zpxo3+hKpr9+F0T0Zy7FkCylTWlo9AqWRm8OAyOTGgrMfMXGp0My06F9y0cSrUXwVNaqev417EXb14Mrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGqduL8Liz0kkgnEShtopQOYdJbYvYeKHYBJ6zQQdsU=;
 b=YYN+nswDvDivxb3DYQgG+V0SRLL1ceWuZWSt/6vvUDZjrJ8G3zymstj3bTL0wLE2po0Y/8HOzz0/wzy3Xq0O600YIcBdqXGX480U5020ziu71NPjJRKEgM+bicrJ6kLJss/nwpwQ/vxIe03gkBXZPpyfuBzLifW7B6+rfq5bK/zUfcbOWyZEoM7vUcLyrTBTc4E2F54Eyk/87R0Woe0CyQcX4Oih7tpeg+7ybCU82MT6AqrGmhFfxR60qZ485pyJj3UQKh4S/uw6N/PEJS8zLCsYV8uGsW71KSY08ce3rLIp0w+eIBoLWg0BD9y0l+n9B4MpzopNh4IiQyR4fH/K4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGqduL8Liz0kkgnEShtopQOYdJbYvYeKHYBJ6zQQdsU=;
 b=fnPVu9n7ujCmumM7Oq+rLZSr1TU1gTdTp4GHyKE7O69gxZKZEIQj0p3zgUBEAEBeR6JGlGOSD2Mngv1V9MQbX3h4IV1uk+SwZi57ZmREqi7pjj1yMNIfXBD9iCycCrBMSoncLHP9VluLML+2Ig4yxY/EYMU52SmhiUMVxoajHXk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2773.namprd15.prod.outlook.com (2603:10b6:a03:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 9 Oct
 2020 06:27:13 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 06:27:13 +0000
Subject: Re: [PATCH bpf-next] bpf: add tcp_notsent_lowat bpf setsockopt
To:     "Nikita V. Shirokov" <tehnerd@tehnerd.com>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
References: <20201009050839.222847-1-tehnerd@tehnerd.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f32bfccf-c659-e82e-08c2-f863eb267610@fb.com>
Date:   Thu, 8 Oct 2020 23:27:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <20201009050839.222847-1-tehnerd@tehnerd.com>
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:68ff]
X-ClientProxiedBy: CO1PR15CA0104.namprd15.prod.outlook.com
 (2603:10b6:101:21::24) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1844] (2620:10d:c090:400::5:68ff) by CO1PR15CA0104.namprd15.prod.outlook.com (2603:10b6:101:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22 via Frontend Transport; Fri, 9 Oct 2020 06:27:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a9b420a-cfdd-4846-6d14-08d86c1c5b96
X-MS-TrafficTypeDiagnostic: BYAPR15MB2773:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2773D618FC8C533A02E772D0D3080@BYAPR15MB2773.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s24VHaOPGpYyTpLsTMTDrGxFlngLJTxQVyJDO59D41tMiq/VCnpO2koanQwx4vwEv2+FsK9qBPS78n+J62aR3gDQZ9yF+99dEiIrYS6hq1lwdqbCb5l/qrbsmN9iAu5KN1cZBe1LXcXPpRDahCnCkOn4OUQpN2GglraLmDMsgKrtkeLtFFbbImQAAOZi1Q9bmFBvdt7b7VYlTRIHjW3ZaD1WA+UNKQltbO+i7+/h0ev4DgIMgcmjVQQ/Xy578KnRkVqGrhf2tiAnPcke5oICWsyYX9g7qzwcmBz23xI8Rw+Vo7ag86Sfn6n+9ejn+dJdljNfOtFXBmsa6WE0xID48+PJKhJ0xQha6Ek5CyhsJkK4sOzmRg943A0YmCvIzcB7Ose31t6lc0b2Ohlj3lbxBIwCFY/xGV/DZFXUmrTDSU71sG41bOZRzHpV03syFtB1nS6fcw1EyveRtqYilXpYHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(39860400002)(136003)(396003)(54906003)(36756003)(52116002)(6486002)(53546011)(186003)(16526019)(4326008)(5660300002)(2906002)(66556008)(66476007)(2616005)(8936002)(31686004)(66946007)(8676002)(83080400001)(83380400001)(316002)(478600001)(86362001)(31696002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: gACKVjPWVQ2wlVHSYNVQGF2uZxNUsxD5Bs+Lou/zHIw3VoU8dO7mSWcv/tuz5HXTmoHhvUbjHm4Cm1MqwgRwJ4UlKBlvqLq+N4+cb2HjC7lvoLWgPNWoctloco3vwuYKAUB+g3+5nbRyxpjSx88XySUk1GTm2avYs117NAfcwGbTmmJv1g5zQix9mC02Vt2b3vezu9wI8VKcutd6IbSWF8FZ5+66Utevx3VRI7zP9L+rZC8FBCcLG3lqzHa6lbkcUB8w+L54xlzsReOwtx/o0GqAXqW5r4I+Nt2SXTbCPSr4d7DhFWa9Qp77UltySlez74lHpTjGxOILiSeo8uiwCS215cPJsi8IWh72X9jhJPp6Wh9O8cyw4O1pFcHbEgZ4iAQuYC4l3s6tUW/OzqazFap6p2clOubxLbKDlZlFVr4XU2qt1+IeQVu3QmAkqPjhXeGONrVi36wxyv8N6wknV+9B2JhZqMZ3Q/AZJjng0jIFbG7UunxjUJOkLohe7XpPPJhAuQKFxQpqYmWOYHD/NGk/7ksFJdg+NclAqyTmdGNfZXoiWFB9Gkt0jPRCfuOpvXwStNzjAeTqU1WYmYFlevAI3Ay3aQMsO1rKfb5130i8yllGNEA6WBy4nMjhDPcFOteuKkFXYqfiid2xTkWM98ThmTFHTehl174V2KkkW6s5dzAfY3dsFfRXcaOWHni8
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a9b420a-cfdd-4846-6d14-08d86c1c5b96
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 06:27:12.7722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gd6RQOC6RRDv+csIuhl5lGTqXOVLjsXNM4yq8TqwvdU1yKRYEP4o1Rdn0B6mWtGu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2773
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_02:2020-10-09,2020-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 clxscore=1011 bulkscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010090046
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/20 10:08 PM, Nikita V. Shirokov wrote:
> Adding support for TCP_NOTSENT_LOWAT sockoption
> (https://lwn.net/Articles/560082/ ) in tcpbpf
> 
> Signed-off-by: Nikita V. Shirokov <tehnerd@tehnerd.com>
> ---
>   include/uapi/linux/bpf.h                          |  2 +-
>   net/core/filter.c                                 |  4 ++++
>   tools/testing/selftests/bpf/progs/connect4_prog.c | 15 +++++++++++++++
>   3 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index d83561e8cd2c..42d2df799397 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1698,7 +1698,7 @@ union bpf_attr {
>    * 		  **TCP_CONGESTION**, **TCP_BPF_IW**,
>    * 		  **TCP_BPF_SNDCWND_CLAMP**, **TCP_SAVE_SYN**,
>    * 		  **TCP_KEEPIDLE**, **TCP_KEEPINTVL**, **TCP_KEEPCNT**,
> - * 		  **TCP_SYNCNT**, **TCP_USER_TIMEOUT**.
> + *		  **TCP_SYNCNT**, **TCP_USER_TIMEOUT**, **TCP_NOTSENT_LOWAT**.
>    * 		* **IPPROTO_IP**, which supports *optname* **IP_TOS**.
>    * 		* **IPPROTO_IPV6**, which supports *optname* **IPV6_TCLASS**.
>    * 	Return
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 05df73780dd3..5da44b11e1ec 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4827,6 +4827,10 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>   				else
>   					icsk->icsk_user_timeout = val;
>   				break;
> +			case TCP_NOTSENT_LOWAT:
> +				tp->notsent_lowat = val;
> +				sk->sk_write_space(sk);
> +				break;

This looks good to me. It is the same as in do_tcp_setsockopt().

>   			default:
>   				ret = -EINVAL;
>   			}
> diff --git a/tools/testing/selftests/bpf/progs/connect4_prog.c b/tools/testing/selftests/bpf/progs/connect4_prog.c
> index b1b2773c0b9d..b10e7fbace7b 100644
> --- a/tools/testing/selftests/bpf/progs/connect4_prog.c
> +++ b/tools/testing/selftests/bpf/progs/connect4_prog.c
> @@ -128,6 +128,18 @@ static __inline int set_keepalive(struct bpf_sock_addr *ctx)
>   	return 0;
>   }
>   
> +static __inline int set_notsent_lowat(struct bpf_sock_addr *ctx)
> +{
> +	int lowat = 65535;
> +
> +	if (ctx->type == SOCK_STREAM) {
> +		if (bpf_setsockopt(ctx, SOL_TCP, TCP_NOTSENT_LOWAT, &lowat, sizeof(lowat)))

In my build system, I hit a compilation error.

progs/connect4_prog.c:137:36: error: use of undeclared identifier 
'TCP_NOTSENT_LOWAT'
                 if (bpf_setsockopt(ctx, SOL_TCP, TCP_NOTSENT_LOWAT, 
&lowat, sizeof(lowat)))

TCP_NOTSENT_LOWAT is included in /usr/include/linux/tcp.h. But this file
includes netinet/tcp.h and it contains some same symbol definitions as
linux/tcp.h so I can include both.

Adding the following can fix the issue

#ifndef TCP_NOTSENT_LOWAT
#define TCP_NOTSENT_LOWAT       25
#endif

Not sure where TCP_NOTSENT_LOWAT is defined in your system.

> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
>   SEC("cgroup/connect4")
>   int connect_v4_prog(struct bpf_sock_addr *ctx)
>   {
> @@ -148,6 +160,9 @@ int connect_v4_prog(struct bpf_sock_addr *ctx)
>   	if (set_keepalive(ctx))
>   		return 0;
>   
> +	if (set_notsent_lowat(ctx))
> +		return 0;
> +
>   	if (ctx->type != SOCK_STREAM && ctx->type != SOCK_DGRAM)
>   		return 0;
>   	else if (ctx->type == SOCK_STREAM)
> 
