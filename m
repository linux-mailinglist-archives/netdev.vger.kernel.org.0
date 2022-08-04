Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C0F589519
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 02:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbiHDAEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 20:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239037AbiHDAEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 20:04:42 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0DB43300;
        Wed,  3 Aug 2022 17:04:41 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273FIn8t025745;
        Wed, 3 Aug 2022 17:04:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=x+ZDFDo+/flxOR7y0UKKmHVzJkE2uJmMrhPRam3yhMA=;
 b=oKgbCjJhvKXZ1n0YIhjotsYES0zILEAwa3oFg8I6oTnL+YdmrU67qICmnNTJ7l1C+xDb
 A0kKYsC0fdUHlOaiRz7vl5/Fy9Q+TTmIbXWoy0sYzMzmT/jv7FouRYSKynqiJ5GxXhVz
 gwI01Gib+zaibrl1gU0YHYG8bbclxg1wThE= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hpy32np94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 17:04:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V7FYtF2B2MSVQM1IlRJdP49BXrrG1eeNCo4YifCLp7WZo1v7EeV8ODWIk1YPXLdfoS9K/UaQoqSiI0YfHP9TTNQRSpucNBhf9iM9LMn7C+KW8KgRwqNJeMCaAkYxKLcU+GlWBiORam3jcXUTYJGgXc32gJPVzVpJEuHR9dK8nyy6AITA/LO1u3S0HO8+B5XRi9kI2HBkvw2lZ8tlHUJaKRpG89l8k9O6RPchJYowtv73ay4z5PJfkjsvDT+lOet6sSIawpZwHTBFtmCyNH2UPP/Z1KZcgzGa6VeaPfh6dV9XK/zzzjiAqlZIF5QbuhNr3gpRMM3N1ftIK2C3BkMjaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+ZDFDo+/flxOR7y0UKKmHVzJkE2uJmMrhPRam3yhMA=;
 b=KH9tVSEdKD0fhJXgVMEx5gwTC3aL6BtWnHm/jlWzM7bRPde0nP8lGa1Zmo54euNTmXHNLX3noX9rEXVebnqO4I1p4uB3ZM7P6yi9ZRax9OPXr+1/0fxiE5UUwVALf8BlMJWBSc748+9d4YcDsUt2e+lEsR3VaWj3XUqD7J3O5/px6HXyDqB0yU7hDV5Nrm/8/YAR3NDGWr5u1FIpvfwJIamSQf4dPd/52wcrreiOkfBoxUiqX3hji3n7k7zBfeX6al+Jfb/QCnIRJkETVz0vPS74aO2+2lF8yBWSfW1JMPh4vcslCBAfNrM/vntZ8AjUMeubfEEf9AlaYNAm52JMdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BYAPR15MB2197.namprd15.prod.outlook.com (2603:10b6:a02:8e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 00:04:20 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::5455:4e3f:a5a2:6a9e%4]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 00:04:19 +0000
Date:   Wed, 3 Aug 2022 17:04:17 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     sdf@google.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 bpf-next 15/15] selftests/bpf: bpf_setsockopt tests
Message-ID: <20220804000417.gmaqry4ecgjlpcvf@kafai-mbp.dhcp.thefacebook.com>
References: <20220803204601.3075863-1-kafai@fb.com>
 <20220803204736.3082620-1-kafai@fb.com>
 <YusFLu+OvcAIq1xr@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YusFLu+OvcAIq1xr@google.com>
X-ClientProxiedBy: BYAPR11CA0041.namprd11.prod.outlook.com
 (2603:10b6:a03:80::18) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f565b960-78be-4454-d7da-08da75ace105
X-MS-TrafficTypeDiagnostic: BYAPR15MB2197:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VAq0G5PzYBD0U4ztGM+V7QgBsihSh7HER97/ouVgR2VC9qYvTKG0AgtwyBKBkxpS6Azx1A6ViB5QYN3Bk9WgoI/Q/PNNZxT4b1yueS8Od5DHf3b/P3/iCD6kC6IFRNWpLK+iV20okQilkmuaagM8TOeI40FB4lwHZ36+cnUmse0w/pe/S+J0uHZUGyBWbYesK9M57Aj8EvxMCpMWZ9Vign28Huyzq/069yUtKHLcGyDDEMbPspaCr82hEWfCtOcEh+V8HLc/zjVOoidCoSpGxlUmjmYlrc/GSaQWgsuYAYhHOE/QyrKENEHVZjrN/dQp2ZXzYah0DGri0OQ4A0VBBHwl+4YrlXg2TpQU9Y/DY3mvUny0SI4aVeiEiIvgehzMTrf4lvnxaydI4XLXfS1Iq4Ta0Wy0VHAT/nIaO8HBnGBtfKfopm6eYg6kvl+w7Kq1Q/bkGbzb5jXfJATdIS0WPB7EiIv4DSGwrUiOc0OocqpsewsYoDflGpfl6icWxeRyvNyAvG1kt7Xz4Sd/O/2gbhDB3lZw3aXSe2VE3AUxdzETBrqXaA4smdg1SAIEHM5VToektizMtNVSReuRYSbCt6Nab8OI9OcSSgPUSO/evGUQvFiwhQ6wDNPWveOqaQueY6qzKzQxFDxe04DkOUeGhGnz06tkEnH3rk1K9H49L+udGkl5bJR4WCBFI7aLPCEBpyhI+OZtREuRuYKi5pW+5kkB/EWH2b7CafevIN4zXko2a8710Z/Ei3tM8WwwE5OC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(38100700002)(6506007)(6512007)(52116002)(1076003)(41300700001)(186003)(6486002)(478600001)(9686003)(6916009)(66946007)(8676002)(316002)(54906003)(66556008)(7416002)(4326008)(8936002)(66476007)(86362001)(83380400001)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cw53nQsHISM00EkSDwooD9XJfbRXTseq4WdqGIV+wL6rC1vxDMvw9MY6B5IN?=
 =?us-ascii?Q?Ufsjbivd7eJlBsKkBLvYoZNcwAqVPzNdUIAxb/HkvXcJl+uhpD7tg5E3NYa6?=
 =?us-ascii?Q?YITE8RamdrCbGiNtY23PFSlarh95fuixABWpgJhWd7BVzcuqbOA437R0kThb?=
 =?us-ascii?Q?JyidBjRXFgBdYlKi4n25IcxEq6ELe9oFoQryqkVjQO6WpotS4rTPfChGTusn?=
 =?us-ascii?Q?bBugGIjHqNOzYiDo892+OqPR8512p+MbbJroAPAuIQWLudjxg+MJKp33fFcs?=
 =?us-ascii?Q?jdu+YigTL1rqx/vhEnIIErwEOOZqx+u+CqMjxgAH4YJliAS0+IU43/Kj/Xkt?=
 =?us-ascii?Q?94FBkrowj8jWyEYlfKmKl91YQV5mQOJ2ATxettEtmj+/2W1wNVkERPzfV4B2?=
 =?us-ascii?Q?UqOQ9MMzV3ZggUdxjnv0l9xKQ2hHl0IFITh4XXB6osuZH0zj5aDuvjbExaPY?=
 =?us-ascii?Q?5WjreEsoNqR8YZRsUPl7UAb2o6KpyEMqrMEkxppD/BXn6m4rQRx9b+LwwoZa?=
 =?us-ascii?Q?igGoQU8UZJLVDTcOjqJ2hIWXbf6sFNvLX/22tFcda2xcWeqmwpgtVuBfhMPU?=
 =?us-ascii?Q?FN2v5ahD7MfEOt9ZgVCFAF8Gkf65exWqv3cc976ujcI5XT0tmK1TVNYGhCp9?=
 =?us-ascii?Q?7aVf+4jtRwWGB3WLssiKSyhqgHUaQVt3+xi30odmsRNaYAT4otPF3Rf4mRRZ?=
 =?us-ascii?Q?UydTsWcLUMGIhuGX4WQvt1/hWGTvPSggsq2+F1OcJM8Ozqn1ZDFLZTxXJ7mM?=
 =?us-ascii?Q?1EFFbXbqtWVhSlA8Fm8bKHaQXWX62tmJcNZzfQYICDCfTUg/2lUCzJAtoXA0?=
 =?us-ascii?Q?e2d9sbayLoTPhImxVYndH36fRYc5RandMRc0K6qUs2zwaeC2vmCjZ3e+fELE?=
 =?us-ascii?Q?ZjeByXdX/sm64GkRAx+kW1Adpaum2okb8X6tqlVaHQrEvpjawP6S4iUCdnHA?=
 =?us-ascii?Q?8zk7tCw4ot7Wjnhrp08lAyxMz0Wl5it0l5mZd7jtWgn/FiScAM6OBIkh6gYI?=
 =?us-ascii?Q?ximWz5ul+Qd5l5++FjabP9odYWuA1ZnHH40fIirlJgIXitmtX09mlnWZsh4K?=
 =?us-ascii?Q?yHLqV/VJzomEBnu5aMy3kZuZEDbRUOGOcKw0VhcKAE1qzVrR9TViTQfZd94w?=
 =?us-ascii?Q?t33wCZB2T4L3UcXmU5EaQm1eWaV8g/7QvzPB3kw5h+ikujZbz+sd65qyhgLd?=
 =?us-ascii?Q?sp2P2tD6qVETjHEmwBh33WDzPZXP8sD2NgLst6octeFBRmBGddCQCP9Wr7ve?=
 =?us-ascii?Q?NbnHRaTF9L9i7p1hr9CwrlB7fHUa5j6K1pMhyJlo6XbzzQuNa9b9E5sbRK7E?=
 =?us-ascii?Q?Oy7YSyCF3Y+CMuRKmQNR9+OMUrYx5fNkw2UxR908/bGr6BMPbYhuK5Y/XBdJ?=
 =?us-ascii?Q?HsRgdV6G5wppECOFTgpZmK41/srZiSSkqzyZUrk3dMP7GQ/EnmZBUBmpv9xJ?=
 =?us-ascii?Q?21QCFtrhHhfRDmcWyqyclMrqVNtAbgY6xXWHyherMsO6nfymrcz+aPyUPlQZ?=
 =?us-ascii?Q?ToC+S6o3ZIuKnI3gdB8Wp6M9Pdj6Ig2k4s88mIPDqG9MstnDa8+sfRZyz8aF?=
 =?us-ascii?Q?MIiL8/fb8HUsCgt85LkGZmDiYDICwW7/3Ej+qMmb5QrrcHfyDd03wm+y1+T/?=
 =?us-ascii?Q?Qw=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f565b960-78be-4454-d7da-08da75ace105
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 00:04:19.8614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MblA9LAeYkn7aGcuRk5VPHDUcSJ/laU3t7rGmzLSNVQ1D5QHfG1AQycIAG0n7Q4G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2197
X-Proofpoint-ORIG-GUID: 3bw78H5QnszAEEHhBU5BExojpPP49MkP
X-Proofpoint-GUID: 3bw78H5QnszAEEHhBU5BExojpPP49MkP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_07,2022-08-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 04:30:54PM -0700, sdf@google.com wrote:
> > +struct sock_common {
> > +	unsigned short	skc_family;
> > +	unsigned long	skc_flags;
> > +	unsigned char	skc_reuse:4;
> > +	unsigned char	skc_reuseport:1;
> > +	unsigned char	skc_ipv6only:1;
> > +	unsigned char	skc_net_refcnt:1;
> > +} __attribute__((preserve_access_index));
> > +
> > +struct sock {
> > +	struct sock_common	__sk_common;
> > +	__u16			sk_type;
> > +	__u16			sk_protocol;
> > +	int			sk_rcvlowat;
> > +	__u32			sk_mark;
> > +	unsigned long		sk_max_pacing_rate;
> > +	unsigned int		keepalive_time;
> > +	unsigned int		keepalive_intvl;
> > +} __attribute__((preserve_access_index));
> > +
> > +struct tcp_options_received {
> > +	__u16 user_mss;
> > +} __attribute__((preserve_access_index));
> 
> I'm assuming you're not using vmlinux here because it doesn't bring
> it most of the defines? Should we add missing stuff to bpf_tracing_net.h
> instead?
Ah, actually my first attempt was to use vmlinux.h and had
all defines ready for addition to bpf_tracing_net.h. 

However, I hit an issue in reading bitfield.  It is why the
bitfield in the tcp_sock below is sandwiched between __u32.
I think it is likely LLVM and/or CO-RE related. Yonghong is
helping to investigate it.

In the mean time, I define those mini struct here.
Once the bitfield issue is resolved, we can go back to
use vmlinux.h.

> 
> > +struct ipv6_pinfo {
> > +	__u16			recverr:1,
> > +				sndflow:1,
> > +				repflow:1,
> > +				pmtudisc:3,
> > +				padding:1,
> > +				srcprefs:3,
> > +				dontfrag:1,
> > +				autoflowlabel:1,
> > +				autoflowlabel_set:1,
> > +				mc_all:1,
> > +				recverr_rfc4884:1,
> > +				rtalert_isolate:1;
> > +}  __attribute__((preserve_access_index));
> > +
> > +struct inet_sock {
> > +	/* sk and pinet6 has to be the first two members of inet_sock */
> > +	struct sock		sk;
> > +	struct ipv6_pinfo	*pinet6;
> > +} __attribute__((preserve_access_index));
> > +
> > +struct inet_connection_sock {
> > +	__u32			  icsk_user_timeout;
> > +	__u8			  icsk_syn_retries;
> > +} __attribute__((preserve_access_index));
> > +
> > +struct tcp_sock {
> > +	struct inet_connection_sock	inet_conn;
> > +	struct tcp_options_received rx_opt;
> > +	__u8	save_syn:2,
> > +		syn_data:1,
> > +		syn_fastopen:1,
> > +		syn_fastopen_exp:1,
> > +		syn_fastopen_ch:1,
> > +		syn_data_acked:1,
> > +		is_cwnd_limited:1;
> > +	__u32	window_clamp;
> > +	__u8	nonagle     : 4,
> > +		thin_lto    : 1,
> > +		recvmsg_inq : 1,
> > +		repair      : 1,
> > +		frto        : 1;
> > +	__u32	notsent_lowat;
> > +	__u8	keepalive_probes;
> > +	unsigned int		keepalive_time;
> > +	unsigned int		keepalive_intvl;
> > +} __attribute__((preserve_access_index));
> > +
> > +struct socket {
> > +	struct sock *sk;
> > +} __attribute__((preserve_access_index));
> > +
> > +struct loop_ctx {
> > +	void *ctx;
> > +	struct sock *sk;
> > +};
> > +
> > +static int __bpf_getsockopt(void *ctx, struct sock *sk,
> > +			    int level, int opt, int *optval,
> > +			    int optlen)
> > +{
> > +	if (level == SOL_SOCKET) {
> > +		switch (opt) {
> > +		case SO_REUSEADDR:
> > +			*optval = !!(sk->__sk_common.skc_reuse);
> > +			break;
> > +		case SO_KEEPALIVE:
> > +			*optval = !!(sk->__sk_common.skc_flags & (1UL << 3));
> > +			break;
> > +		case SO_RCVLOWAT:
> > +			*optval = sk->sk_rcvlowat;
> > +			break;
> 
> What's the idea with the options above? Why not allow them in
> bpf_getsockopt instead?
I am planning to refactor the bpf_getsockopt also,
so trying to avoid adding more dup code at this point
while they can directly be read from sk through PTR_TO_BTF_ID.

btw, since we are on bpf_getsockopt(), do you still see a usage on
bpf_getsockopt() for those 'integer-value' optnames that can be
easily read from the sk pointer ?

> 
> > +		case SO_MARK:
> > +			*optval = sk->sk_mark;
> > +			break;
> 
> SO_MARK should be handled by bpf_getsockopt ?
Good point, will remove SO_MARK case.

Thanks for the review!
