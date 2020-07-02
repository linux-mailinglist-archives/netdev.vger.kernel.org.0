Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198E6211B91
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 07:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgGBFcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 01:32:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62190 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726003AbgGBFcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 01:32:10 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0625Tqtn024669;
        Wed, 1 Jul 2020 22:31:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=l6M67IPA0CFv74YQqISbW1ESVsUnaukGol58cHJVRik=;
 b=oqJ6oQG6Cit1+5IxEeWehYok8j+/Z7uQ/EVaPoQzL4PzA8V97BzdSihpM7BWU0jpe7O2
 VcYmO9UPhgJ1QlyuKJC+r+8QIaY2iJpjQ5zY3T+fQyCe9CsS7yxZs7g4jL3DP8/bYPAx
 DTN1v94Kdd5MT3Cxm0/4k3mF4BTecVi4RH4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31x3xh5hhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 01 Jul 2020 22:31:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 22:31:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkyIQT7LoOpWVhMA14pmvWQnAs/sVeNfPGeMUWTLZK1j8jPP3QpRR/Jiqssq19rxTrIehQ8w9xUSD2riNgrDEUwZ7suRQlwlYXEVcyeS1kssWBWQNXDidVkM3L2yBzy5TwymLwBTKw1rAon4+kiR8vJ/D/uKIKmoCcVIFSzvYMLHJvdgXvhNeuWSlZSnm4WcyWpkkTuC2pqg1FB5aEG9C1p1r5xkVuUaSbcDGaomSYF++7f17lxBkiUeNQHs8UOENcXT5lNzG27tlLFChwTPcCLMHzxy9+h4+RGMSOktlB/DXHKUGwE+eQzuPKt1vZAf0J7weGwPDomDiXp9msJaTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6M67IPA0CFv74YQqISbW1ESVsUnaukGol58cHJVRik=;
 b=jVqu1QeNLDGdY0uyrxHFoY6zsFmpFcXpswUOoYhz5C2fXII3S64wacanINUhojAb5HIv19y1ZMvP5DeMmZvOiv+/Hs4xOzWQtU4xaqf12Y4WB1akkfI9ItkRUUx1IPHAMG3fBxLw+iyDILsGigDG2t+HnUEaLiV4iDdcRGYL4MyTmsFlRHYW7xBAoOZDLwXvK0ZRSFVjTIthgrlmSaSFOBcU/U595dQ8nf88CRCiinR9M5x5AizrL5VKm3016zRSwVebgYlPUQFXYeg5WPFGj+Z8nSysHBT5tRs0UArcnUuJUffkq/yGRLE6v6RrPLxBlBqVenY/R0doq5k0Pi1KJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6M67IPA0CFv74YQqISbW1ESVsUnaukGol58cHJVRik=;
 b=K98rk+c3x3JaGJl0Bar2DqixhthYHzXCsaOLQDrJt1Ae+crIXgg148UPuE74nG+wTUNI2PGA3GNzed954ze4kHUKUGRaLyywkGa0TgXd1uHouB5IHotDGZWP+VXFqeu3zYRflwWDxuyiNuHKJ8cEcor7TDFbjS7oLQYIJkUViZs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3607.namprd15.prod.outlook.com (2603:10b6:610:a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Thu, 2 Jul
 2020 05:31:50 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107%5]) with mapi id 15.20.3131.028; Thu, 2 Jul 2020
 05:31:50 +0000
Date:   Wed, 1 Jul 2020 22:31:46 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH bpf-next 04/10] bpf: tcp: Allow bpf prog to write and
 parse BPF TCP header option
Message-ID: <20200702053146.myn2ctvm2l2lsi76@kafai-mbp.dhcp.thefacebook.com>
References: <20200626175501.1459961-1-kafai@fb.com>
 <20200626175526.1461133-1-kafai@fb.com>
 <20200628182427.qt7vpjohwkxvixfi@ast-mbp.dhcp.thefacebook.com>
 <20200629003448.hstswzhn4eakv36f@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200629003448.hstswzhn4eakv36f@kafai-mbp.dhcp.thefacebook.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::20) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:cdb4) by BY5PR03CA0010.namprd03.prod.outlook.com (2603:10b6:a03:1e0::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Thu, 2 Jul 2020 05:31:48 +0000
X-Originating-IP: [2620:10d:c090:400::5:cdb4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 176981ed-b9a5-4144-e51f-08d81e4937a9
X-MS-TrafficTypeDiagnostic: CH2PR15MB3607:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR15MB3607380D452E3E80F1C50575D56D0@CH2PR15MB3607.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0jvz7mySx6kahKzxofPfjXL2hcNhq570O1oWCQ6Q8cnIR0Vu9v0nR0Er/5O+8VV1B6Q0XyP3klaUXzDciOckqNsFaFgHp6YNUhrB4WkEdpTI5luknQOmh47ZfypjHI/6JIRC4+EfiNcBi10uwyZHlkLdfy3aIJemynv6v3Rm/LIibSbstOZvneGdNH0UT22KRHK/HUF7MkQE0fYU8LV5Kt76iGdw2K4gSDKgJ2WFGBC2hT2OWvEJbwqrt2Ptl5QwFavcoJLFbkrHFRCvYuCbU05rstJSBXCSiyHOsTFOCAKK0snJo6B3iMJqvLHwqoxF0Jl7KUkLq+KvsJhhzVNfRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(136003)(366004)(376002)(346002)(6916009)(1076003)(478600001)(9686003)(55016002)(5660300002)(83380400001)(8676002)(8936002)(66476007)(66556008)(66946007)(2906002)(7696005)(52116002)(86362001)(4326008)(6506007)(316002)(186003)(54906003)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: e1P6oq4zap8erhQX3r66vgHLa6mHmqZEOkovj1fIOiWhywlHllbqpVMZe/7b0eBP8X9jdsZdjeTzVZH7WajAXbXdR0AVyTJa3DR41dwwXEU58Sq/txwyNuQ4R3TE88JQmZ5CNJkOeYTbgJ3CJLvmjA/FWTJq0NnkdMXyW36LKcck6kJrmmKkiFgJfasj2eAEVNGN2b9x+nfMyYju11FDNa76eOBrQAbgUh+w9GtsP27YP6MI1db4mSZllO5OGZbTeompsr4v2RBduz0hwDiknntWjSz3xDCAzV6W2ayKhHCoWHrflrG5aRww+AJRy0okRnLqmCe5GHw/M9fu4HK/MEekMrAu/K9nJ3gVQBAEj/7Y1jX8nId09yXI/7pmou8HS3SXK/6Dvwzt92/nnflXVYFeeZ5AZNiQcNc+cL7qXzjYl320q5HYQ0qovQEVRG5IYZfz6fiKSQutHgLwlie907QbBnsuTqReZej75RzJ/ZhWs4HCYK7DyewsFVm/RkiwdKU91xAsnQyi7K9CnnC85A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 176981ed-b9a5-4144-e51f-08d81e4937a9
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 05:31:49.7826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N+rsuaqAJLp9jOZBgPBv/Z3nskWMMA8efm9lladcPS1dCSO/AtVAjoP37AHCBZji
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3607
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_02:2020-07-01,2020-07-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 mlxscore=0 impostorscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020041
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 28, 2020 at 05:34:48PM -0700, Martin KaFai Lau wrote:
> On Sun, Jun 28, 2020 at 11:24:27AM -0700, Alexei Starovoitov wrote:
> > On Fri, Jun 26, 2020 at 10:55:26AM -0700, Martin KaFai Lau wrote:
> > > 
> > > Parsing BPF Header Option
> > > ─────────────────────────
> > > 
> > > As mentioned earlier, the received SYN/SYNACK/ACK during the 3WHS
> > > will be available to some specific CB (e.g. the *_ESTABLISHED_CB)
> > > 
> > > For established connection, if the kernel finds a bpf header
> > > option (i.e. option with kind:254 and magic:0xeB9F) and the
> > > the "PARSE_HDR_OPT_CB_FLAG" flag is set,  the
> > > bpf prog will be called in the "BPF_SOCK_OPS_PARSE_HDR_OPT_CB" op.
> > > The received skb will be available through sock_ops->skb_data
> > > and the bpf header option offset will also be specified
> > > in sock_ops->skb_bpf_hdr_opt_off.
> > 
> > TCP noob question:
> > - can tcp header have two or more options with the same kind and magic?
> > I scanned draft-ietf-tcpm-experimental-options-00.txt and it seems
> > it's not prohibiting collisions.
> > So should be ok?
> I also think it is ok.  Regardless of kind, the kernel's tcp_parse_options()
> seems to be ok on duplication also.
> 
> > Why I'm asking... I think existing bpf_sock_ops style of running
> > multiple bpf progs is gonna be awkward to use.
> > Picking the max of bpf_reserve_hdr_opt() from many calls and let
> > parent bpf progs override children written headers feels a bit hackish.
> > I feel the users will thank us if we design the progs to be more
> > isolated and independent somehow.
> > I was thinking may be each bpf prog will bpf_reserve_hdr_opt()
> > and bpf_store_hdr_opt() into their own option?
> > Then during option writing side the tcp header will have two or more
> > options with the same kind and magic.
> > Obviously it creates a headache during parsing. Which bpf prog
> > should be called for each option?
> > 
> > I suspect tcp draft actually prefers all options to have unique kind+magic.
> > Can we add an attribute to prog load time that will request particular magic ?
> > Then only that _one_ program will be called for the given kind+magic.
> > We can still have multiple progs attached to a cgroup (likely root cgroup)
> > and different progs will take care of parsing and writing their own option.
> > cgroup attaching side can make sure that multi progs have different magics.
> Interesting idea.
> 
> If the magic can be specified at load time,
> may be extend this for the "length" requirement too.  At load time,
> both magic and length should be specified.  The total length can
> be calculated during the attach time.  That will avoid making
> an extra call to bpf prog to learn the length.
> 
> If we don't limit magic, I think we should discuss if we need to limit the
> kind to 254 too.  How about we allow user to write any option kind?  That can
> save 2 byte magic from the limited TCP option spaces.  At load
> time, we can definitely reject the kind that the kernel is already
> writing, e.g. timestamp, sack...etc.
I have thought more about allowing only one kind per bpf prog at load time.

I think it is not ideal for some common cases in 3WHS.  For example,
when rolling/testing out a newer option to replace the old one,
the bpf@server may want to see if client supports option-A or option-B
from the SYN and then reply SYNACK accordingly with either option-A
or option-B.  It will be easier if it allows one bpf prog to make
the decision instead of having two bpf progs (one for option-A and one
for option-B) and may require these two bpf progs to co-ordinate with
each other.  The option length will not be static also.

The prog load attribute can be extended to take >1 kinds or may be
some arraymap convention can be used to do this.  However,
I am not sure that worths it considering most of the usecases is only
in 3WHS and checking for kind duplication in runtime may not be too bad
considering the TCP option space is only 40bytes and the option
has to be 4 bytes aligned.

I am thinking to allow the bpf prog to write multiple option kinds
and check for kind uniqueness at runtime.  That will include
checking the options already written by the kernel.  In SYN, there are
usually 4 options: mss, sackOK, TS, and wscale.

The bpf_store_hdr_opt API will be changed to:

long bpf_store_hdr_opt(struct bpf_sock_ops *skops, u8 kind, const void *from, u32 len, u64 flags)

It writes one _complete_ option at a time and "u8 kind" is required.
No offset is needed because it does not allow going back to rewrite
something that has already been written.

Thoughts?
