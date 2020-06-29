Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD4D20CB36
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 02:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgF2AfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 20:35:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9498 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726395AbgF2AfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 20:35:18 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05T0UiOB009534;
        Sun, 28 Jun 2020 17:34:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=iKqUgPcpO2XHMfcfOycFKY79ekYyXKpwil/Yt4RkuRY=;
 b=dBT4DI5SzgDMg9DzgaQB+gKcrirFg1SSEmQAhLlH4s8105f8+97RlLuBm8xc5zX80+yL
 +KwSJJKbL4o5JwztTEpjGJZ1BCv9kY4uwZOyJNfI+oq8OSj6ehUSvXRG8Izex0RN0CkX
 O7MAndl9xtS89VZI9Rn5S/Xom7t11Kqk4t0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31xny225kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 28 Jun 2020 17:34:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 28 Jun 2020 17:34:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDNBn5Z3ueLZdiwA6TAPEBAgtMBHRCCKNoL7kXhnVNKcTDSuCc48+uPEsEnNVMPgEEHRfvSflYJVav8H5+539vV2BmLZMWfVPmO8By88RFQuRYQK2lz7DS1rhVRMDsbRHiGR000/57faCHYe2MSmp/ERYkt2FY9i+dGWtxQLMwxZx/zZ1SRy5iw3oALfNGxyQDWeVFna5hDQ4LzpfA8/sopVOVwxQUzkRcE/of33ON8zSH6wyDszyfdVwY2NqjlWFUZNj5sWvO25cLp7yalEyYMQgIUgFJb4XUy3B9pjPjs9rt6XXjC77dGvVHe9gYWtDn8dgsbKGtAbWftQ6vjd7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKqUgPcpO2XHMfcfOycFKY79ekYyXKpwil/Yt4RkuRY=;
 b=mLIDq3fEONpXH8fmD+U18ITnJO2PLVAOkRKsFjKBAutmrF/3JeClF1PwhKRmCtQp53naaLeiBoxbhNv6LOCwjTKGfvJoyJJpie3PWrCvBNuQX9D/FcPd2kN3B4X8LnQ6JRuVjHScsumtKEkjfrt/b5bG9OQ0RJXX8tT66ZU6sEbfqJk0uZ56p7uAxvy6cFGeitC8S0SmXPexgdEZmj4GqT2mP7II4m05EStWVa+9q0CJgQTKcOg3tIObiQX77RqgySrAdFhkGcjhAp5SCuD+ex9WKzm6ZgrTtr8XsHsR6dBuLN3mC21AQN3Rd5odtS366WgHE5sHqiiiEIdXEDhagw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKqUgPcpO2XHMfcfOycFKY79ekYyXKpwil/Yt4RkuRY=;
 b=jG302lu782Z/7RinFpUVOqEp071yyZhFBTYTEQD3r/CCM/6qrZymm/iABh4ISuaara9Y++UZD25GqSp6wL8vUhbcOgtOjxqKtIvChpFNfCAP0sbx+8XawDt3KAZdtkQg5qTCVO31MEmCmw9O9qpF1k/JBflO86R/Mn4M6u9fdSs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3606.namprd15.prod.outlook.com (2603:10b6:610:2::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Mon, 29 Jun
 2020 00:34:51 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107%5]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 00:34:51 +0000
Date:   Sun, 28 Jun 2020 17:34:48 -0700
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
Message-ID: <20200629003448.hstswzhn4eakv36f@kafai-mbp.dhcp.thefacebook.com>
References: <20200626175501.1459961-1-kafai@fb.com>
 <20200626175526.1461133-1-kafai@fb.com>
 <20200628182427.qt7vpjohwkxvixfi@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200628182427.qt7vpjohwkxvixfi@ast-mbp.dhcp.thefacebook.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::40) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:807c) by BY5PR03CA0030.namprd03.prod.outlook.com (2603:10b6:a03:1e0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23 via Frontend Transport; Mon, 29 Jun 2020 00:34:50 +0000
X-Originating-IP: [2620:10d:c090:400::5:807c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6445e82b-41e8-4c8c-fe3b-08d81bc43c1e
X-MS-TrafficTypeDiagnostic: CH2PR15MB3606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR15MB360630AAD13C1838CD4E3FECD56E0@CH2PR15MB3606.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 044968D9E1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e5B1OSMbGV4tDVeCpU0WPMKL6cWwqVqmy/wZG2Cp3S0Pev0TIh2gAziNFgCL4Wzs2KOrjRgMP99cC0wGEXdX3zVKQmlNkgCQgSfFCGijuH3pkRmm6/1GCm4rOa3OdduUSZF0aznEpepWtbCjGQeqsDU3LHIVDozgq3Oot2If1U0Z8Eio1y0USj35PLHEVsLKULqN6vYNNewrGuSrxFdgoSZcXtFPYM9lFq0mL+z5M7LJOXBjWOy4UYj04p5XzvFd8HtYP77fLGpJMHd/cNY6esEk9zWgxm1EiXZGZrdf4RYd100C8CsdVwZp+/xvHge8pqAmAcJ4V6TE9U79HuGIbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(39860400002)(136003)(366004)(346002)(7696005)(2906002)(52116002)(83380400001)(66476007)(66946007)(16526019)(186003)(66556008)(55016002)(9686003)(316002)(86362001)(478600001)(6916009)(8936002)(4326008)(1076003)(5660300002)(8676002)(54906003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 7sFnN/4vcjyKw61Fhl51njNjC9mOaCAuTRuAVJqYh961vcCsUFwx3yHOUJGbiET4t5PeJJ74lI+uuJwTZZv/ZklfkOuuF7BgX3BPZ128NE/P0wdsGPftgYKNPUQ+uFqvJr8XuiY2Pv77M8UHy4C5AD6lJlcTUvc8m9xzpfWmjQb5SvIeP1xll13DkCccQrHTDPCht+FWzoaJ00gZNHCk3qDwyocmQMww6ITeVbRVOOGhXvF9udYbkc3og0EIuTYKUtwkaMP2J1rQSsWOnhVdeJnPF2KrdthG6NSDn4B8CuGmrUpN4Gtn0FpuEyPqry57R62o/wZZOD6LooKLIErPc6LHfKq31c+RI+ZqXyUJrNuy/i8/Tla9KlZHGn3pE3LVwSOnmTZluO2DgIU/mcPjN1mHt6lJWFNu3ECathlBAi5rBqhx4CuQzPVfw1iZrPtVQYwwlDct5bpm2WsSgad7TiaUsciRTUKwMR3Sg9ES+xJwZ7xnGk+rCoBYGxts5mY1YWyKk41m8WsUaEZ4yjc23w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6445e82b-41e8-4c8c-fe3b-08d81bc43c1e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2020 00:34:51.1657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jzZUUS4sup/qNK6PCR6haUnemI/xN7Jac65I9xXSa9tH3g28nQcod9ibhD/EGHa8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3606
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-28_11:2020-06-26,2020-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 cotscore=-2147483648
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 clxscore=1015 mlxlogscore=999 adultscore=0 suspectscore=0
 bulkscore=0 impostorscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006290001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 28, 2020 at 11:24:27AM -0700, Alexei Starovoitov wrote:
> On Fri, Jun 26, 2020 at 10:55:26AM -0700, Martin KaFai Lau wrote:
> > 
> > Parsing BPF Header Option
> > ─────────────────────────
> > 
> > As mentioned earlier, the received SYN/SYNACK/ACK during the 3WHS
> > will be available to some specific CB (e.g. the *_ESTABLISHED_CB)
> > 
> > For established connection, if the kernel finds a bpf header
> > option (i.e. option with kind:254 and magic:0xeB9F) and the
> > the "PARSE_HDR_OPT_CB_FLAG" flag is set,  the
> > bpf prog will be called in the "BPF_SOCK_OPS_PARSE_HDR_OPT_CB" op.
> > The received skb will be available through sock_ops->skb_data
> > and the bpf header option offset will also be specified
> > in sock_ops->skb_bpf_hdr_opt_off.
> 
> TCP noob question:
> - can tcp header have two or more options with the same kind and magic?
> I scanned draft-ietf-tcpm-experimental-options-00.txt and it seems
> it's not prohibiting collisions.
> So should be ok?
I also think it is ok.  Regardless of kind, the kernel's tcp_parse_options()
seems to be ok on duplication also.

> Why I'm asking... I think existing bpf_sock_ops style of running
> multiple bpf progs is gonna be awkward to use.
> Picking the max of bpf_reserve_hdr_opt() from many calls and let
> parent bpf progs override children written headers feels a bit hackish.
> I feel the users will thank us if we design the progs to be more
> isolated and independent somehow.
> I was thinking may be each bpf prog will bpf_reserve_hdr_opt()
> and bpf_store_hdr_opt() into their own option?
> Then during option writing side the tcp header will have two or more
> options with the same kind and magic.
> Obviously it creates a headache during parsing. Which bpf prog
> should be called for each option?
> 
> I suspect tcp draft actually prefers all options to have unique kind+magic.
> Can we add an attribute to prog load time that will request particular magic ?
> Then only that _one_ program will be called for the given kind+magic.
> We can still have multiple progs attached to a cgroup (likely root cgroup)
> and different progs will take care of parsing and writing their own option.
> cgroup attaching side can make sure that multi progs have different magics.
Interesting idea.

If the magic can be specified at load time,
may be extend this for the "length" requirement too.  At load time,
both magic and length should be specified.  The total length can
be calculated during the attach time.  That will avoid making
an extra call to bpf prog to learn the length.

If we don't limit magic, I think we should discuss if we need to limit the
kind to 254 too.  How about we allow user to write any option kind?  That can
save 2 byte magic from the limited TCP option spaces.  At load
time, we can definitely reject the kind that the kernel is already
writing, e.g. timestamp, sack...etc.

When a tcp pkt is received at an established sk, this patch decides
if there is 0xeB9F option before calling into bpf prog.  That needs
to be adjusted as well.  It could be changed to: call into bpf prog
if there is option "kind" that the kernel cannot handle and the
PARSE_HDR_CB_FLAGS is set.

> Saving multiple bpf_hdr_opt_off in patch 2 for different magics becomes
> problematic. So clearly the implementation complexity shots through the roof
> with above proposal, but it feels more flexible and more user friendly?
> Not a strong opinion. The feature is great as-is.
If we go with the above route that multiple cgroup-bpf has multiple
kinds (or magics),  each of them has to parse the tcphdr to figure
out where is its own kind (or magic).  The intention of providing
bpf_hdr_opt_off in this patch is mostly for bpf-prog convenience only.
I think having it work nicer in multi bpf prog is the proper trade off.
