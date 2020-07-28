Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A805F23147B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 23:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbgG1VPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 17:15:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61204 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729145AbgG1VPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 17:15:20 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06SLCxkJ007752;
        Tue, 28 Jul 2020 14:15:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ubPSljGBAFR+wU+/KO5FUuqK1FRPEVKFpwVIEoci+Jk=;
 b=rntZ8xFJLPHOtbi7L0kS2Cy8X0GUVTL5+FOvEJdl8zrUgIMxoIB0FLv8OZ2WktMJb3NU
 1OEq9Eev5w/aDSepurGS1ViW30ks3LDxSLUsbz1/sytMvcUgbuETYW+poS8JSDTDaQNk
 cguoIGhmUwAyRbiB++tcGrBteclpWH/d1qA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32juqwg09p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Jul 2020 14:15:05 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 28 Jul 2020 14:15:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEbAXizs8WalKnMbR8yWzv2xSnE7ND70KPqNrrtNglICAbp5FWUxUo4aAeka/DBywr/WHzlgvCyIP5ZmEsq2Gws6xFlrukwij9IcVXLakMXrgim+QDlFYuZJQlFCSIiuACTr4+3iD33W8mv8DaLKN3pUodh5vaXHXQ/gbr8XKQvJ1cqoIFugNE32Xe5X3ttmsF+GVeovJ/NYi5Ti1s1KNLzMPGtuwW2Y+acdnHt8Jkr7e8n+uZS9NjwedxjQniDfXRU6qOUlR+5SVD8YhwbOoFfzIXiHdoI9jebcqBRQUNRqAxNzoOPWH0VstB1+qqQ3864j1m7lO7MQBAzPZQbNyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubPSljGBAFR+wU+/KO5FUuqK1FRPEVKFpwVIEoci+Jk=;
 b=f1aC2L2Z8YJrIHUbTgGS4CEgizB4eH4qQTmmkrJYPl/w2YbWbh/ltlt6uRw6fwNEcR6bnLEBPzEfwRGne8Ghdl3xZwBvkFyk+tVdAsVkQ85wi6FFI20/2ub0u6oSupxLCTsf3A5lNv/qA0CspZommsL/QzPCwObzuGznrXqysYhX+2GZ8WzHUcikwtk2uhx3afq6OdxofDOUOQ+0pq6xA7RYXqAjQAtnWEwSAiKD7wADysGtRl5S64OXViGx2QtpCBc1qXDfcuDZMPwMj9X5/NDZDV49/gPOrfsfOFDgG+0c/W5lBOhUroz+6immcmGjvtdfpS1cSgwdi8zDmb79DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubPSljGBAFR+wU+/KO5FUuqK1FRPEVKFpwVIEoci+Jk=;
 b=AIPWXqoMcfhjqhiKxAyLLBgZXBbuRPN1L8CY+rJrso+nlnSvvF+HTZv3BLOaBBwI1nmpGC1bi5IFB+9Xg5hw0hOlQNIYLBWv1HgIMshbqWTPRah6VdKVLNisfW3lMSQ/jb5BxYPpLr7Bqx+8kqfA/q5LO5VLLNgyKAJVYMxgW8o=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3640.namprd15.prod.outlook.com (2603:10b6:610:7::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 21:15:03 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 21:15:03 +0000
Date:   Tue, 28 Jul 2020 14:15:00 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <daniel@iogearbox.net>, <ast@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [bpf PATCH 1/3] bpf: sock_ops ctx access may stomp registers in
 corner case
Message-ID: <20200728211500.zrjzrjg7x2k2gtx2@kafai-mbp>
References: <159595098028.30613.5464662473747133856.stgit@john-Precision-5820-Tower>
 <159595102637.30613.6373296730696919300.stgit@john-Precision-5820-Tower>
 <20200728172317.zdgkzfrones6pa54@kafai-mbp>
 <5f2090bac65ef_2fe92b13c67445b47d@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f2090bac65ef_2fe92b13c67445b47d@john-XPS-13-9370.notmuch>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:1ec0) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24 via Frontend Transport; Tue, 28 Jul 2020 21:15:02 +0000
X-Originating-IP: [2620:10d:c090:400::5:1ec0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aea8b655-22dd-4543-d03d-08d8333b4b00
X-MS-TrafficTypeDiagnostic: CH2PR15MB3640:
X-Microsoft-Antispam-PRVS: <CH2PR15MB364063A57F8C25F88E0DBF12D5730@CH2PR15MB3640.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W6crlwi1KXjDy8ARY5nJ7IK/T0RTi0jlcOZuWP+p56DrE0erP1OFyXveuPBGVo0XFKO4DdD6P4mFPqGmxxSOaNO6Lfez5G6Q2sjlovmeGBi2sc7x7auGJKlfQ0s8Mj0GqgvDHfCz6ObHv8YoZMibYr5Qx+vqRD6WfMwfGdOYq5NR52E66DFTcV6PUW6/SlZlrRMnO3v3b4npaEljZftryBreaKbzTGlKg0yNllT7jIRR/L5V0QrdcPLC5UxNUQ/qWWVvqAEfq4fDxzTMGIQe8kg5aWP39SutrhSB0lI7CtdAx5WyCrO07DRT1cqGDiu1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(396003)(136003)(366004)(346002)(39860400002)(186003)(16526019)(5660300002)(52116002)(1076003)(66556008)(66476007)(86362001)(66946007)(478600001)(9686003)(316002)(8936002)(83380400001)(4326008)(2906002)(33716001)(6496006)(8676002)(6916009)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: XdDlUDY1WiUJH06BGX4MIHK82u7a8nTxeI4BnQhAsqwMLJ9FpmlctXW/hH4UVN2ww7oqDMJUptHsM7sqQ/BB0PdcAmSxpuJ3bWMdbiI8kNGAv0zlmS8DyqT2Q/KcZXR/PHOoSq9UNxrFy6lZrk+mAro3dl2QQcGrvrPFiFvJOvyLFdBGNOOwe7XUK17JnOsPfJQPzh1vq2tQBPsJxkIru/zzjehijJNEK/65LKxNzzWUdUTIEF2he1WsXdXvA3dzVX+POVD7UpYYQO3B/iVqdTXpUQBi8oT+zsdPWama0bZGZUAd0fXbbA1ngBYwymReC3go0LAFYkT8mEH2+YR4j9fNZNRzNT3ZcnmdQ6dUkedWvQYbrlO4Xw2+pL56HEBhmwLL2FBebI49lZoUBX/9UsGtUKxeOZnwfu7MNlo1QLK+sf+M9NWFzuJdRbyvKYvHQzxJqOHG77JIaDPGu9x4RRwAwYYAv3nfAi58Q9AU8xaNYnF1gb4/FynWgdY/qT1rZx2bL5I4BQg76rZ40HOGSw==
X-MS-Exchange-CrossTenant-Network-Message-Id: aea8b655-22dd-4543-d03d-08d8333b4b00
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 21:15:02.9895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3r+P9c7EIXJtW7TkJeLeL7N72xx19nK12/UH/hR6IZm5ak8T8AC9A9qH07+CeBgD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3640
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_17:2020-07-28,2020-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0 impostorscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007280150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 01:55:22PM -0700, John Fastabend wrote:
> Martin KaFai Lau wrote:
> > On Tue, Jul 28, 2020 at 08:43:46AM -0700, John Fastabend wrote:
> > > I had a sockmap program that after doing some refactoring started spewing
> > > this splat at me:
> > > 
> > > [18610.807284] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
> > > [...]
> > > [18610.807359] Call Trace:
> > > [18610.807370]  ? 0xffffffffc114d0d5
> > > [18610.807382]  __cgroup_bpf_run_filter_sock_ops+0x7d/0xb0
> > > [18610.807391]  tcp_connect+0x895/0xd50
> > > [18610.807400]  tcp_v4_connect+0x465/0x4e0
> > > [18610.807407]  __inet_stream_connect+0xd6/0x3a0
> > > [18610.807412]  ? __inet_stream_connect+0x5/0x3a0
> > > [18610.807417]  inet_stream_connect+0x3b/0x60
> > > [18610.807425]  __sys_connect+0xed/0x120
> > > 
> 
> [...]
> 
> > > So three additional instructions if dst == src register, but I scanned
> > > my current code base and did not see this pattern anywhere so should
> > > not be a big deal. Further, it seems no one else has hit this or at
> > > least reported it so it must a fairly rare pattern.
> > > 
> > > Fixes: 9b1f3d6e5af29 ("bpf: Refactor sock_ops_convert_ctx_access")
> > I think this issue dated at least back from
> > commit 34d367c59233 ("bpf: Make SOCK_OPS_GET_TCP struct independent")
> > There are a few refactoring since then, so fixing in much older
> > code may not worth it since it is rare?
> 
> OK I just did a quick git annotate and pulled out the last patch
> there. I didn't go any farther back. The failure is rare and has
> the nice property that it crashes hard always. For example I found
> it by simply running some of our go tests after doing the refactor.
> I guess if it was in some path that doesn't get tested like an
> error case or something you might have an ugly surprise in production.
> I can imagine a case where tracking this down might be difficult.
> 
> OTOH the backport wont be automatic past some of those reworks.
> 
> > 
> > > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > > ---
> > >  net/core/filter.c |   26 ++++++++++++++++++++++++--
> > >  1 file changed, 24 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index 29e34551..c50cb80 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -8314,15 +8314,31 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
> > >  /* Helper macro for adding read access to tcp_sock or sock fields. */
> > >  #define SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ)			      \
> > >  	do {								      \
> > > +		int fullsock_reg = si->dst_reg, reg = BPF_REG_9, jmp = 2;     \
> > >  		BUILD_BUG_ON(sizeof_field(OBJ, OBJ_FIELD) >		      \
> > >  			     sizeof_field(struct bpf_sock_ops, BPF_FIELD));   \
> > > +		if (si->dst_reg == reg || si->src_reg == reg)		      \
> > > +			reg--;						      \
> > > +		if (si->dst_reg == reg || si->src_reg == reg)		      \
> > > +			reg--;						      \
> > > +		if (si->dst_reg == si->src_reg) {			      \
> > > +			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, reg,	      \
> > > +					  offsetof(struct bpf_sock_ops_kern,  \
> > > +				          temp));			      \
> > Instead of sock_ops->temp, can BPF_REG_AX be used here as a temp?
> > e.g. bpf_convert_shinfo_access() has already used it as a temp also.
> 
> Sure I will roll a v2 I agree that rax is a bit nicer. I guess for
> bpf-next we can roll the load over to use rax as well? Once the
> fix is in place I'll take a look it would be nice for consistency.
Agree that it would be nice to do the same in SOCK_OPS_SET_FIELD() also
and this improvement could be done in bpf-next.

> 
> > 
> > Also, it seems the "sk" access in sock_ops_convert_ctx_access() suffers
> > a similar issue.
> 
> Good catch. I'll fix it up as well. Maybe with a second patch and test.
> Patches might be a bit verbose but makes it easier to track the bugs
> I think.
Thanks for taking care of it!
