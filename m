Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F74A231715
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 03:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgG2BPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 21:15:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42884 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726004AbgG2BPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 21:15:23 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06T18YdP019830;
        Tue, 28 Jul 2020 18:15:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=U2eOvkVVv+TxssH769gAKg1LSWZNcScjILzlJXtDRn8=;
 b=OfZ8WvJ7JEHUSOdHhJm2kMcA4KOczZstI+lkEfL8cjyUePZS8HoYpCfiqTtZuo69owCJ
 ZzcUCSBd5oMVAGUzYARYQCr8q0TI4PN/QCzzipejCXF5DMmf2snqXPnZoVKEr+lbAvP3
 Bwr+5ajl8kTamlgMfalWWJ/aXr3uuo7hTek= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4qs4na6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Jul 2020 18:15:09 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 28 Jul 2020 18:15:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grMUaM8XQe2iKPjib22zUXuRuS1Gktex3FgwIctvwEYv72FMrB0WI5inIC9TAc3PsF8FaVmTj/o+Ei2nDZpbHf8rksAhvlJSeS4XRvwaghn4bmJWvyiAPINXxfQ8srbiKJh7WDuclzpQsmo64sWzu/AUa56Y7aSkHmYZAljI9fixoHLtP4YyXqTvWqY3BDPv4/M2OVWYvPqHTrnozqNpL0ZLISkzdcEjOt7z7lCCTqh7YBUiA812e6IWy8zblc6X/9YW53IxQz/fhvvh4NWo1ZlQy/O17Og6w+GraR70H9VbiFzKE+YOuQ4Hf//c/Jfvq/JtNUvDEABGEpW59Tzltw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2eOvkVVv+TxssH769gAKg1LSWZNcScjILzlJXtDRn8=;
 b=UkLFAijcLtrA445s7nz1c4rVI/prNfqWL1srMbxd+ZJtnodhfSLbuIgcjT+QqlsyD8VdE/ubibaQQbUmgnA8T5ZLVFbUuUNLwH1zj2CibEaV25j8aBaxLrO9crDGO2G3VzpztpLG3+t48UQLAamKRAV8N3/eNzoOUHmPzHT6p1XZrFGCtl3Px8aOY0GAnp0TKiRVP0DIHv9yaap7TafWFqXeZjJbr8+0RUZlad71T4idNB0XBuVQdExYuVEx7tvfU1z0NK6jYsL91WO+BDoqbWCekEPpZ60Igs6T7sB04QFXDfdoZ9Px9s4O8lIXL9mIumAqkD1iSmt9K229vKv9/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2eOvkVVv+TxssH769gAKg1LSWZNcScjILzlJXtDRn8=;
 b=SeOX2UfXqTPOwgEW9uzlRUpEJEepH5p90VoQfOhesV6i82vKHPNIDlVBA0SzUgsfcJNbx2d1ahOcC8VNfjCXeYWeK8T6OTr5SL3Uisl3B3ZSZRA50lq29MDgYarSVmhD4E74ib7I1Mf523I3/HKrj6+QzmnVlf8bOR4h7rYDvHU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3736.namprd15.prod.outlook.com (2603:10b6:610:6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.26; Wed, 29 Jul
 2020 01:15:06 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107%5]) with mapi id 15.20.3216.034; Wed, 29 Jul 2020
 01:15:06 +0000
Date:   Tue, 28 Jul 2020 18:14:59 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <daniel@iogearbox.net>, <ast@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [bpf PATCH 1/3] bpf: sock_ops ctx access may stomp registers in
 corner case
Message-ID: <20200729011459.wix5xadqoir54rod@kafai-mbp.dhcp.thefacebook.com>
References: <159595098028.30613.5464662473747133856.stgit@john-Precision-5820-Tower>
 <159595102637.30613.6373296730696919300.stgit@john-Precision-5820-Tower>
 <20200728172317.zdgkzfrones6pa54@kafai-mbp>
 <5f2090bac65ef_2fe92b13c67445b47d@john-XPS-13-9370.notmuch>
 <20200728211500.zrjzrjg7x2k2gtx2@kafai-mbp>
 <5f20c663a4106_2fe92b13c67445b4a5@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f20c663a4106_2fe92b13c67445b4a5@john-XPS-13-9370.notmuch>
X-ClientProxiedBy: BYAPR05CA0077.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::18) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1ec0) by BYAPR05CA0077.namprd05.prod.outlook.com (2603:10b6:a03:e0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Wed, 29 Jul 2020 01:15:05 +0000
X-Originating-IP: [2620:10d:c090:400::5:1ec0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cab7af4-956d-4555-5fb9-08d8335cd3f9
X-MS-TrafficTypeDiagnostic: CH2PR15MB3736:
X-Microsoft-Antispam-PRVS: <CH2PR15MB37363C58E089878FB688F942D5700@CH2PR15MB3736.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tdIIIhXA7sRpMyRCU5OvrSJ/A0q8JwYJQUNYk9fo6R012YvwVA3mX/7PTlgwDYZJHx1z4xNH+nnCB7+DR7r7q3UX31UDKO2fjN8gO+OlA/kcXcfspHgU2TdnyzwmkD8S9uryIT9roW5xT/314Osv7yIqSHnfNX0eyy2fYHQmJzJQmod3GfxKOzkgTLKPnxw25my+wQDRwo7q/GfWEUggM2qg3kIVfDxkBXc69szi820xbnuHyeURvQpu4WaF+/DpgYslZAMdRFL1ZNywRcGOJx5z2cEvmQoewjJ7G74pkGycL8EK22QB1CEO/6Z3dJ7D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(346002)(376002)(366004)(396003)(86362001)(1076003)(8936002)(4326008)(8676002)(316002)(2906002)(83380400001)(5660300002)(52116002)(6916009)(66556008)(66946007)(66476007)(55016002)(16526019)(186003)(9686003)(6506007)(6666004)(7696005)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: JTszw7BJk1hBvyJmXGxBtvYdowaoMDMl+Z9oysP1HoVKIVuEcESWP9tZ+N2/Bz0sY+vYn0Yk/QHqV/pd8dsqjzyKaZLnHXhTxvoP/4smPbmWS9lcNEMq4IGSQ9Z7FsC3arRJrqfZ6//ciacPjfyLgFIXWrhrtWwUhR5X7A843RttnJDmabnbsHFN0hAcR7svJ2HICUXJ6ZVQej/qh/d1z+xQFI2YnxX9vs/w5i0EjK/TnxWZ4xzWohTgz+vRwDAKdo+4YQP0XfjZGtQh5y2QIhMrckilk0vfxIg+aGHQF3xvsTo1MoRQ9hfXBFbKKfz/9IYtLyAN5ELTXAA1/8s8EY0Qniac9vBiKmTT1/3QEvwj6B2lrtbryU8KxqrmoUtX5Ec5Ahjbcifj7nMvJVEBDOjsyKw7YNyim/amIga4VM1Sg1Db+au+Rm1RMG+rX+93S0jDhVGH1F7PH7ZmUKzwx2oyFWej0auUAflA2tHaB5HU8mumHNsJ3EZMBA7z8c4bI6O6Nyd9MQ7qZJO1+pbJ2A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cab7af4-956d-4555-5fb9-08d8335cd3f9
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 01:15:06.2266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zh3YNGXduOeS1ZIAS1U9eoKzfBH/VokL0jXL8RP4vAZ4FgKbcYokaWRGjH1c0MsE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3736
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_01:2020-07-28,2020-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=1 malwarescore=0
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007290006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 05:44:19PM -0700, John Fastabend wrote:
> Martin KaFai Lau wrote:
> > On Tue, Jul 28, 2020 at 01:55:22PM -0700, John Fastabend wrote:
> > > Martin KaFai Lau wrote:
> > > > On Tue, Jul 28, 2020 at 08:43:46AM -0700, John Fastabend wrote:
> > > > > I had a sockmap program that after doing some refactoring started spewing
> > > > > this splat at me:
> > > > > 
> > > > > [18610.807284] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
> > > > > [...]
> > > > > [18610.807359] Call Trace:
> > > > > [18610.807370]  ? 0xffffffffc114d0d5
> > > > > [18610.807382]  __cgroup_bpf_run_filter_sock_ops+0x7d/0xb0
> > > > > [18610.807391]  tcp_connect+0x895/0xd50
> > > > > [18610.807400]  tcp_v4_connect+0x465/0x4e0
> > > > > [18610.807407]  __inet_stream_connect+0xd6/0x3a0
> > > > > [18610.807412]  ? __inet_stream_connect+0x5/0x3a0
> > > > > [18610.807417]  inet_stream_connect+0x3b/0x60
> > > > > [18610.807425]  __sys_connect+0xed/0x120
> > > > > 
> > > 
> > > [...]
> > > 
> > > > > So three additional instructions if dst == src register, but I scanned
> > > > > my current code base and did not see this pattern anywhere so should
> > > > > not be a big deal. Further, it seems no one else has hit this or at
> > > > > least reported it so it must a fairly rare pattern.
> > > > > 
> > > > > Fixes: 9b1f3d6e5af29 ("bpf: Refactor sock_ops_convert_ctx_access")
> > > > I think this issue dated at least back from
> > > > commit 34d367c59233 ("bpf: Make SOCK_OPS_GET_TCP struct independent")
> > > > There are a few refactoring since then, so fixing in much older
> > > > code may not worth it since it is rare?
> > > 
> > > OK I just did a quick git annotate and pulled out the last patch
> > > there. I didn't go any farther back. The failure is rare and has
> > > the nice property that it crashes hard always. For example I found
> > > it by simply running some of our go tests after doing the refactor.
> > > I guess if it was in some path that doesn't get tested like an
> > > error case or something you might have an ugly surprise in production.
> > > I can imagine a case where tracking this down might be difficult.
> > > 
> > > OTOH the backport wont be automatic past some of those reworks.
> > > 
> > > > 
> > > > > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > > > > ---
> > > > >  net/core/filter.c |   26 ++++++++++++++++++++++++--
> > > > >  1 file changed, 24 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > index 29e34551..c50cb80 100644
> > > > > --- a/net/core/filter.c
> > > > > +++ b/net/core/filter.c
> > > > > @@ -8314,15 +8314,31 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
> > > > >  /* Helper macro for adding read access to tcp_sock or sock fields. */
> > > > >  #define SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ)			      \
> > > > >  	do {								      \
> > > > > +		int fullsock_reg = si->dst_reg, reg = BPF_REG_9, jmp = 2;     \
> > > > >  		BUILD_BUG_ON(sizeof_field(OBJ, OBJ_FIELD) >		      \
> > > > >  			     sizeof_field(struct bpf_sock_ops, BPF_FIELD));   \
> > > > > +		if (si->dst_reg == reg || si->src_reg == reg)		      \
> > > > > +			reg--;						      \
> > > > > +		if (si->dst_reg == reg || si->src_reg == reg)		      \
> > > > > +			reg--;						      \
> > > > > +		if (si->dst_reg == si->src_reg) {			      \
> > > > > +			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, reg,	      \
> > > > > +					  offsetof(struct bpf_sock_ops_kern,  \
> > > > > +				          temp));			      \
> > > > Instead of sock_ops->temp, can BPF_REG_AX be used here as a temp?
> > > > e.g. bpf_convert_shinfo_access() has already used it as a temp also.
> 
> OTOH it looks like we will cause the bpf_jit_blind_insn() to abort on those
> instructions.
You are right.  I think eventually "BPF_JMP_IMM(BPF_JEQ, BPF_REG_AX, 0, ...);"
has to be done here and it is working on an IMM 0.  BPF_REG_AX has the
is_fullsock.

From the bpf_jit_blind_insn(), the "case BPF_JMP | BPF_JEQ  | BPF_K"
will break the above BPF_JMP_IMM.

I think the "temp" approach has to be used as in this patch.

> 
> I'm not sure it matters for performance see'ing we are in a bit of an
> edge case. iirc Daniel wrote that code so maybe its best to see if he has
> any opinions.
> 
> @Daniel, Do you have a preference? If we use REG_RAX it seems the insns
> will be skipped over by bpf_jit_blind_insn otoh its slightly faster I guess
> to skip the load/store.
> 
> > > 
> > > Sure I will roll a v2 I agree that rax is a bit nicer. I guess for
> > > bpf-next we can roll the load over to use rax as well? Once the
> > > fix is in place I'll take a look it would be nice for consistency.
> > Agree that it would be nice to do the same in SOCK_OPS_SET_FIELD() also
> > and this improvement could be done in bpf-next.
> > 
> > > 
> > > > 
> > > > Also, it seems the "sk" access in sock_ops_convert_ctx_access() suffers
> > > > a similar issue.
> > > 
> > > Good catch. I'll fix it up as well. Maybe with a second patch and test.
> > > Patches might be a bit verbose but makes it easier to track the bugs
> > > I think.
> > Thanks for taking care of it!
> 
> 
