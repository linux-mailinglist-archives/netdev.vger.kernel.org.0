Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6BA2D927F
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 06:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbgLNFNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 00:13:34 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:38940 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726058AbgLNFNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 00:13:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607922745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WYz7eFBA5t1QZrNCirMbbA/evj82nD5oKztzWvBESTk=;
        b=b5tB/EjDDf6godlw2QLUqrYTWnePeKyTsmVbeG+U5fHnD9QqWmvkPXY7Dm96QsskqYkGVp
        /WBDFvfOlZ9a6yi5/ciuG53RSqkHtINizZbieBjZJN9GMZesfx0xWX8UbdqqhE7Pmp06Ek
        849tC+Ry309o3Z2YbJ1zKSbIVRpnbUA=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2051.outbound.protection.outlook.com [104.47.1.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-25-9Kr7xWs0OZCKvh1teibUXQ-1; Mon, 14 Dec 2020 06:12:23 +0100
X-MC-Unique: 9Kr7xWs0OZCKvh1teibUXQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VjVheQvfqSkJozN57W/K4mi42GPxDmG463D6k5mxN40w8ncVyTYvqDHzzXgG047EttlhwXzJH/uHMXbt0pavClIbg+PWFRM7AtOBlg5HAAOJG0eZc9tIGauPsQ8M8fMdo5+pCFht3/BWLJh8lWegqcJL8JA7HGrYJ9ZYm9TwsZ7GMicSWy0sYuao6bu8voISOWDtYLT9Iku7n54uXFytHAH02mxe1hRDOSwzZjps5PvqzUuKuxyiFb/4Zb/l8wt+EeFRcxbCziJl+77AAMPmFeh/zKWaVbsPVzgTr/DCDJoGREwU4J8ZpUB21Gsv8DE+26WgcQs9ChQ7IVaEMMgojw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYz7eFBA5t1QZrNCirMbbA/evj82nD5oKztzWvBESTk=;
 b=IEvv4omLEo+9Yovhs/X+nJYJ2A5si9vh3vfWpQYe/zEngcFEwZU/kj6+pXi7uEgE8vUzRq/F5o9BrSOO/JUMVlul0hM5KgnerY3eus685ZZ662cz3OTh14m7ZsBhz7OfsO078fx7Jfq2vCtF0CytstCnK18H355eRszK6e/XuaF6t7glSovSpqVqu4t0w684mmHTPyXbbDJnkcE31w51eCASfDm/60RQvbV6wre8H5OLCVVy8L+NpcfsgRqq1smDGUipBQPD+QkegH1NN94EEmpnDjWEVfbic5QgaYrHGf3oJUfIbQF/neA8UcOKSTjfL4R/IqYMVlncb1+FoQKKPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com (2603:10a6:8:b::12)
 by DB8PR04MB6474.eurprd04.prod.outlook.com (2603:10a6:10:10c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Mon, 14 Dec
 2020 05:12:22 +0000
Received: from DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313]) by DB3PR0402MB3641.eurprd04.prod.outlook.com
 ([fe80::80c9:1fa3:ae84:7313%6]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 05:12:22 +0000
Date:   Mon, 14 Dec 2020 13:12:12 +0800
From:   Gary Lin <glin@suse.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        andreas.taschner@suse.com
Subject: Re: [PATCH] bpf,x64: pad NOPs to make images converge more easily
Message-ID: <X9b0LHBvj4UDGIwe@GaryWorkstation>
References: <20201211081903.17857-1-glin@suse.com>
 <CAEf4BzbJRf-+_GE4r2+mk0FjT96Qszx3ru9wEfieP_zr6p6dOw@mail.gmail.com>
 <a9a00c89-3716-2296-d0d9-bba944e2cd82@iogearbox.net>
 <CAADnVQKr9XYS3ijsiFiEH3sUAx-HjqkzybSZ379SLkyiXBkNhQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKr9XYS3ijsiFiEH3sUAx-HjqkzybSZ379SLkyiXBkNhQ@mail.gmail.com>
X-Originating-IP: [60.251.47.115]
X-ClientProxiedBy: AM0PR01CA0175.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::44) To DB3PR0402MB3641.eurprd04.prod.outlook.com
 (2603:10a6:8:b::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from GaryWorkstation (60.251.47.115) by AM0PR01CA0175.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 05:12:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f13b9efd-8e3f-43dc-3390-08d89feed6c0
X-MS-TrafficTypeDiagnostic: DB8PR04MB6474:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6474C93FA846F4E486965BFEA9C70@DB8PR04MB6474.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KgLLfFhVj0x99XT8QJvQZxJSd3Z21i5U1CEv8kIN6T325S4AXtSvQ71OYypFzz50dbnQjEhLgUs8XrVqBAN1J/NM3V4Hliyata2KuRkl3ZBaJ+4UDmezo18zFVK1IU3zshcQFfrcb0RUMV0JWxXCQGMAczCGyZieBvNhluPXTCxPckWv0uZ4v/dybDXGs/NP6xJZXbe4/I19Zd3YQHhqhSJzwCgvTxCqgaC9nKWsa5qlzKYrqs8UbVjYxjjTLNlogx3ObdUxtGQLlweSvfK9kgTc1AxTaMCAfgbytUvUACi/AmSn6ZKZLFAzLrQ6LHxhTTJYb1N8hcMI0GufWn/5oQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB3PR0402MB3641.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39850400004)(346002)(376002)(2906002)(6496006)(4326008)(66476007)(66946007)(6916009)(8676002)(66556008)(8936002)(5660300002)(52116002)(55236004)(956004)(478600001)(83380400001)(54906003)(33716001)(6666004)(316002)(53546011)(107886003)(26005)(9686003)(55016002)(86362001)(186003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?erJOyHgAwewAU8S7Csx/ygQSLp8BGNjmT9xKqZHGRz+ke2jeZ0Nn+GpFyD/Y?=
 =?us-ascii?Q?NuW3bNg8K6MDgJM9bWX7FKPYcUxDo70SXE26lZZNqmcS6JCnbgBR9NuQ/jm1?=
 =?us-ascii?Q?Wt/T+HPmBeYZbpGOKPsM0plt7A47ETW9wGgqfZndSBPRPQ4p1qRwf+rz9t3o?=
 =?us-ascii?Q?uzXgXe79YxW/zBJZRTBihuuwxQO2aS7HSZ/4xzqI7oEnBZSb8BwmNXqn4SbM?=
 =?us-ascii?Q?Ntfw+YN6Ec4aNW4CB2kbZiDbwX+VE6OmFAxMpk5qrCSgDy+2V/3auognwscY?=
 =?us-ascii?Q?OvEtfJv6dB7ysRyEC4gqBnp50jQ6dPGBNrHjziblHdho+CJupvlqsh8TJBKX?=
 =?us-ascii?Q?8o/M49m50H2MIuHCzRmcmatHSTGP5Rg74hzLJZoEucH/UKETx+RIhk4sF9O/?=
 =?us-ascii?Q?WOJI5gQoBw9kSx6beU0PoJlvPPAYFMjMd/Ux+A0fXs0X+oJl/HspYsutZhbg?=
 =?us-ascii?Q?wuLMJqbg85VlXYZYvCAaWmPV1KFmPcCaM/sxcb6FmqqNOdgkazMIh6tNNse4?=
 =?us-ascii?Q?MDL+EOnvqxq0+KWUsXMtDLkdqBFAhjmsZkguqjk+842aGln//jHJuvmtONB5?=
 =?us-ascii?Q?h+CWbh8LPxQIl39TusRf5q1M8rXAo4mpplRSG/pcb6Nsm2nuXSwAfBr+JRZj?=
 =?us-ascii?Q?ZJKAh/101jGqVCLwml9x9uXmHXjIc55j8hOHpLk28oZ/rs+o4NrgXuhbKeZW?=
 =?us-ascii?Q?eO3gxqwxRhIa/jjW1frusJavvoozWuZeD6UbxWYPyE8/FJ80fAb2Nr5zFIVD?=
 =?us-ascii?Q?XcWNqDBtSy2XbIf+WGbu5rlhbKezxiJk8xmDyOxKDEUty6+U9ph1GOtSvXsS?=
 =?us-ascii?Q?uSDwtROazVPsiy+/rkHRgvwKnCLk+EkZ9PB65OBZmWwexyXT6K/g6ThsS/Yl?=
 =?us-ascii?Q?RSodSA9MGwtQcxPFjKy63TLsXoiTuySjAOeHvIov/6kLNa4hT/KEQQpsRliG?=
 =?us-ascii?Q?LTKnWjssChWgRQgl3Xd2vJ8FuiMUEAyMlnB31tr9iHJdLFpLMItnJxsscTk1?=
 =?us-ascii?Q?mTnw?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: DB3PR0402MB3641.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 05:12:22.5978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: f13b9efd-8e3f-43dc-3390-08d89feed6c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uICTeUjLVquilsZ0rJxHYiLNlBxMAvcWI26WGGDpJZULSaUzFa6XDlHdhEtNOfxX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6474
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 06:24:47PM -0800, Alexei Starovoitov wrote:
> On Fri, Dec 11, 2020 at 1:13 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >> +                       }
> > >>   emit_jmp:
> > >>                          if (is_imm8(jmp_offset)) {
> > >> +                               if (jmp_padding)
> > >> +                                       cnt += emit_nops(&prog, INSN_SZ_DIFF - 2);
> 
> Could you describe all possible numbers of bytes in padding?
> Is it 0, 2, 4 ?
> Would be good to add warn_on_once to make sure the number
> of nops is expected.
> 
For the conditional jumps, it could be 0 or 4. As for nop jumps, it may be
0, 2, or 5. For the pure jumps, 0 or 3. Will add the warning in the next
version.

> > >>   struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> > >>   {
> > >>          struct bpf_binary_header *header = NULL;
> > >> @@ -1981,6 +1997,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
> > >>          struct jit_context ctx = {};
> > >>          bool tmp_blinded = false;
> > >>          bool extra_pass = false;
> > >> +       bool padding = prog->padded;
> > >
> > > can this ever be true on assignment? I.e., can the program be jitted twice?
> >
> > Yes, progs can be passed into the JIT twice, see also jit_subprogs(). In one of
> > the earlier patches it would still potentially change the image size a second
> > time which would break subprogs aka bpf2bpf calls.
> 
> Right. I think memorized padded flag shouldn't be in sticky bits
> of the prog structure.
> It's only needed between the last pass and extra pass for bpf2bpf calls.
> I think it would be cleaner to keep it in struct x64_jit_data *jit_data.
> 
Okay, jit_data is surely a better place for the flag.

> As others have said the selftests are must have.
> Especially for bpf2bpf calls where one subprog is padded.
> 
Will try to craft some test cases for this patch in v2.

Gary Lin

