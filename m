Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1141C7904
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 20:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbgEFSJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 14:09:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15692 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730363AbgEFSJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 14:09:52 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046I9VOu022228;
        Wed, 6 May 2020 11:09:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8UHo9gd7BsaglN5nvEDNO7Ig4fvCRFb3HKQKrNxSOP4=;
 b=gOPsziAvGNfEiCrINNnSlkkJSXwjOGg7ct9ZK0cHYGXx8hlWdWpn6bSIDT3K9NWEhta9
 HAQyWbME0nNigZY1yRJHYtosugPjLNCONGM78e/Pek91iZN1w/X2i4f0BXd6yPnByQLo
 GXOuiAq546eMLKJ0B/4nS2NmzzaaEwOF++c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30s6cmwy4u-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 11:09:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 11:09:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ne6uzbXEp1VcILAnOzvnLmyQtcm6Qs+WsecKUbvnjSdn+NT6K6ykmZVcyYIs9xhKG0OoMXhMIxkHYoTJ0UVorejZPOyF8dBP3J9+jZtSVl4Qw2EbZ3uinZw29wiiuacj66wJec8URard1l2NEGq/EnLfqaTpiIi+3s8OlrBrFPKrDw/YoZVGj8NvrdW2OKoFGz7cnquTVbdVKu2H8vDAgZe9uPUz5NeJFk/Kzaa4M/zUKjGAoiGZ2s26I8TeSxLMUL75cGN3c580OCTUbkxxlbQ/0CA7jVqX1SNMSg/18M/vJPYROuODWv5NKnjz1jgjf1/OsrjC6sWkJvN8wrOuwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UHo9gd7BsaglN5nvEDNO7Ig4fvCRFb3HKQKrNxSOP4=;
 b=Bb55m6Lp4pQAKgoyY2Gm30sNW5r7OH8p6PuiLySgfaV1/yTMSXV0OfMH/PeT2WAKA0hW+VDfA+a2fMjXArhMoznhNUjUNfceMalwwbMujUoapOo1FK+Bje1ATE7sQ1xG30UzLynKN6iHWN5Wd/jSzfVudLThshnczoZJcLH99Qq6PXJA8axFHZ8Rw8EtgdbJ6L9GjI5SB+tYvJaZKQj7QVF1XLATeE8ym+aS6ws6kHVfhaJ8FGUkjfmAmHBDKbvA4nFXCSZkQPXZnqUi2/KYcsJj3/w8DXGXgotdZVvnNX/WeHZqaLQoTlddep/YRuJy2bdPN73KVK2GoW+yRRK5Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UHo9gd7BsaglN5nvEDNO7Ig4fvCRFb3HKQKrNxSOP4=;
 b=ahmuDkktM6cdVL5qpf7CUELznl1ui5Z4rZE8ao3DxgOp0+2FXK2+GcfdeihUClsk6z2G5bTvsuCHC6vIx81I/Mq0R78xpA05b1oP51fD8JD6elYNFrlANBudTiIBI/njTTbNkdq56E0zNV28XXzZm+mYxu4WIc824C2oBtz4ogI=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3980.namprd15.prod.outlook.com (2603:10b6:303:48::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Wed, 6 May
 2020 18:09:11 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 18:09:11 +0000
Date:   Wed, 6 May 2020 11:09:08 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v2 4/5] bpf: allow any port in bpf_bind helper
Message-ID: <20200506180908.p4rze6ibtuogmf5j@kafai-mbp>
References: <20200505202730.70489-1-sdf@google.com>
 <20200505202730.70489-5-sdf@google.com>
 <20200506062342.6tncscx63wz6udby@kafai-mbp>
 <20200506162245.GG241848@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506162245.GG241848@google.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR05CA0054.namprd05.prod.outlook.com
 (2603:10b6:a03:74::31) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:b618) by BYAPR05CA0054.namprd05.prod.outlook.com (2603:10b6:a03:74::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.14 via Frontend Transport; Wed, 6 May 2020 18:09:10 +0000
X-Originating-IP: [2620:10d:c090:400::5:b618]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 462a067f-87ba-4d60-6032-08d7f1e893d7
X-MS-TrafficTypeDiagnostic: MW3PR15MB3980:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3980087E35CA419C31DA35C6D5A40@MW3PR15MB3980.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NJFp7ag5aGiwKaazHo8VTVIVoRrITuJ1uAOrmz0bq69J6Xx49DEAvdZvO+Ezi9nT9i4MW3DWn+RzBMIRVdEBU74D8OstHRKEbBzoUbQ2eBulKYRYTha3NsYNof1RYUBRiphLU3tDcKV8I5N6hUj98sigfSSMG83fGOTw0XagIJXM3/x6Ee3WE79sCe5cpk1ONTsiEM26P6ewqbAcE3WR6bPWuZQ9ZvPQwf9vN/sEd724sc7ViyF9hEgKCguo6YmZXQGhctaOtHh6tCbUj2lhmZotebTvPvvn6Wc8uk8LNnPve6OClnXfOwkXK1HwLU4Ud/ACquR0dL9tQ1ma9712MxkTgm8NcXudsKrrutAVXL6BeNd1lY8mtleIE0u35tjtKF1p7xpTWU3CUGKDfQ0n2tMAx8NalI9e4DPmwEw3gL2LXBPVY97B2xu7tscGbdcLoh/QNElmgu64goAAozJDIu8DtB9Pn3RIzXi6V/ginXE/DqQBIpu8KARl55oFT1Yn2Jyo+6qBP3g6s5DGcxllSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(39860400002)(396003)(346002)(136003)(376002)(33430700001)(8936002)(6496006)(66476007)(186003)(16526019)(33440700001)(55016002)(52116002)(6916009)(86362001)(4326008)(66946007)(33716001)(66556008)(1076003)(9686003)(5660300002)(2906002)(478600001)(316002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: SWOWVsXAEAM7DZ40F9hG3C8/mLLo+6Cb6Uvg7iz4W6AboAfK2Earz6sOZcTzcv5ppP4ZQoAq1kCI7n1k/h0UKEBD82vPArSA8f32I8EwnNjq6ikb/C6KeOeHqRP6wY9hJ2Dmit8Z6RRiSRoMAD21Zb4pjaHsOW1l027/JceChtjOfVbLw6G9sFVvC+g2etQ795F+KAy3oLC4Q0U/grdv728jibwWA6xA/WnoHD46TBugvEmhCozECUPXyDbZo3I9pHhTJIPpLjT0xVzO1hmOG7cX0EsKA1/JFIIRcKiWo173zIGtNj2XqUaAE+CtVNnH2cDD/W+5aAo7a44G5t71zRpDg/W14AkPxkKanyIRWJ/McA9mM+Q9j/zarIM7Z/l6HfcoYaPpardfPITgjoIr8jVA2TU8X0HmiyVPkUoFo1ZLeFsq1PcDKNgzRBmmFnVYcSeIirDNUen1jsjbe+9Chc6mMcqHeKSE3Q9jcWxYAXDBvGtdBhistdP1E2U0gATWCtqkuhWs+ZWlcR4/PSSt36/MjPRV6wS/zvEzQ2Rxd/j2sxyCppGURuvzC9nStnIFoUaOX0zLlTSthxSEvbpuvPoMHGcQhHY20lPnAOH87/zApd4OT9NIXpRiclVdR+maLvzvrYuxvcPMljnqmYil8p87hldNVTNNBE3w4XPddcLUU0WJhGJb8FwjMOrjwtLjUVARpZlgK4U1PWtvnl58fQ06iYrL2lv2GLZLlRPM4szgcqrqbQ9L4EYwSTUKZlV/fE1c10zK17vZubBHN/sewPymVAckVd1GJWgkPEc/4iSfzSFeqZ3YuZhYvpXclP1LUbzX4b8qrhXCnYqdc/xYQw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 462a067f-87ba-4d60-6032-08d7f1e893d7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 18:09:11.5528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cTCalcmy4De4SnfCW+ZQZR2rUh0bj1bBe3p7fy07nVa0hvKYyQSwRo1IYGFmzl87
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3980
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-06_09:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 spamscore=0 suspectscore=3 clxscore=1015
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005060148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 09:22:45AM -0700, sdf@google.com wrote:
> On 05/05, Martin KaFai Lau wrote:
> > On Tue, May 05, 2020 at 01:27:29PM -0700, Stanislav Fomichev wrote:
> > > We want to have a tighter control on what ports we bind to in
> > > the BPF_CGROUP_INET{4,6}_CONNECT hooks even if it means
> > > connect() becomes slightly more expensive. The expensive part
> > > comes from the fact that we now need to call inet_csk_get_port()
> > > that verifies that the port is not used and allocates an entry
> > > in the hash table for it.
> > >
> > > Since we can't rely on "snum || !bind_address_no_port" to prevent
> > > us from calling POST_BIND hook anymore, let's add another bind flag
> > > to indicate that the call site is BPF program.
> > >
> > > v2:
> > > * Update documentation (Andrey Ignatov)
> > > * Pass BIND_FORCE_ADDRESS_NO_PORT conditionally (Andrey Ignatov)
> > >
> > > Cc: Andrey Ignatov <rdna@fb.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  include/net/inet_common.h                     |   2 +
> > >  include/uapi/linux/bpf.h                      |   9 +-
> > >  net/core/filter.c                             |  18 ++-
> > >  net/ipv4/af_inet.c                            |  10 +-
> > >  net/ipv6/af_inet6.c                           |  12 +-
> > >  tools/include/uapi/linux/bpf.h                |   9 +-
> > >  .../bpf/prog_tests/connect_force_port.c       | 104 ++++++++++++++++++
> > >  .../selftests/bpf/progs/connect_force_port4.c |  28 +++++
> > >  .../selftests/bpf/progs/connect_force_port6.c |  28 +++++
> > >  9 files changed, 192 insertions(+), 28 deletions(-)
> > >  create mode 100644
> > tools/testing/selftests/bpf/prog_tests/connect_force_port.c
> > >  create mode 100644
> > tools/testing/selftests/bpf/progs/connect_force_port4.c
> > >  create mode 100644
> > tools/testing/selftests/bpf/progs/connect_force_port6.c
> > >
> > > diff --git a/include/net/inet_common.h b/include/net/inet_common.h
> > > index c38f4f7d660a..cb2818862919 100644
> > > --- a/include/net/inet_common.h
> > > +++ b/include/net/inet_common.h
> > > @@ -39,6 +39,8 @@ int inet_bind(struct socket *sock, struct sockaddr
> > *uaddr, int addr_len);
> > >  #define BIND_FORCE_ADDRESS_NO_PORT	(1 << 0)
> > >  /* Grab and release socket lock. */
> > >  #define BIND_WITH_LOCK			(1 << 1)
> > > +/* Called from BPF program. */
> > > +#define BIND_FROM_BPF			(1 << 2)
> > >  int __inet_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len,
> > >  		u32 flags);
> > >  int inet_getname(struct socket *sock, struct sockaddr *uaddr,
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index b3643e27e264..14b5518a3d5b 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -1994,10 +1994,11 @@ union bpf_attr {
> > >   *
> > >   * 		This helper works for IPv4 and IPv6, TCP and UDP sockets. The
> > >   * 		domain (*addr*\ **->sa_family**) must be **AF_INET** (or
> > > - * 		**AF_INET6**). Looking for a free port to bind to can be
> > > - * 		expensive, therefore binding to port is not permitted by the
> > > - * 		helper: *addr*\ **->sin_port** (or **sin6_port**, respectively)
> > > - * 		must be set to zero.
> > > + * 		**AF_INET6**). It's advised to pass zero port (**sin_port**
> > > + * 		or **sin6_port**) which triggers IP_BIND_ADDRESS_NO_PORT-like
> > > + * 		behavior and lets the kernel reuse the same source port
> > Reading "zero port" and "the same source port" together is confusing.
> Ack, let me try rephrase it a bit to make it more clear.
> 
> > > + * 		as long as 4-tuple is unique. Passing non-zero port might
> > > + * 		lead to degraded performance.
> > Is the "degraded performance" also true for UDP?
> I suppose everything that is "allocating" port at bind time can lead
> to a faster port exhaustion, so UDP should be also affected.
> Although, looking at udp_v4_get_port, it looks less involved than
> its TCP counterpart.
I was mostly curious after taking a quick look in both TCP and UDP.
It does not affect the patch here.  May be something for
optimization later.

From skimming the codes,
I was thinking UDP should be more or less the same since
they have to go through get_port() eventually.

TCP will be degraded from inet_hash_connect() [which seems
to be using the ehash and 4 tuples] to get_port().
