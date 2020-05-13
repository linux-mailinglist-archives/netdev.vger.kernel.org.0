Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D161D1D17
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390049AbgEMSLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:11:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32958 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732488AbgEMSLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:11:48 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DI5HIH003765;
        Wed, 13 May 2020 11:11:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=GFL72UA5MNoXjrI2alkZ7ejlAKYjbQkL2vVt4FhysM4=;
 b=fEgv/hRd9XcUU0X/l/1IQFSkMWLez4i7OnX0OJaBfx8jn0dyV1vCOXP9dl3n3jS6XdDf
 99y3DBJiQ2n7NgFY3XgN/QD+AkLKx+WumIUvdnMrlnZpyEkGb4ZTNKbf4zNtgZWzhtrj
 d4UVvb6/eTWf2NjhZiAm6fIN293pKRe8Nj0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x6xdj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 May 2020 11:11:24 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 11:11:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vl+ve8IuNO//2Wd5mZc6F1Vavq/GM+Y2QshXVgrOfgRO54WoElXsHynYKQI+8dX0QcNukIB4BiCqcxoIwgVF4Fpu0C1jfCL/nLt6WBRM2r0iWf2iF8rY6kp6DM4Sr6F08k0sPo6IRFRwairbDhk8yygD64YpuhvdZKnYFDONCCXUB22l8kuh4cwendyRz4qk4EUbDEzyGIRWz73JyHzClTJ6+36sSlPOCB4Q6ndRnWMMzzHfIZ3XqR/oH2+FM4LyW3McC2aawAnSypsFDMoZlwookSObQQnpCgIir+yDzhZ/WsjzcHYlf+MUNsSoS/pnJLsadDVfvghEkm64xipl3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFL72UA5MNoXjrI2alkZ7ejlAKYjbQkL2vVt4FhysM4=;
 b=RfdMDIBuHR6amDp7WDH7yNDerQgK5zJxlWfOFNveNsv4jZZBmy//fj+w6BLHGlwWJWULrvtkQFg6KnmZDhbKHZi7x8sGxqoe1dDQPJQ7jmGTnrK2j9d+hvZ3cJWEXBWU75/I3erCEq3aTSxHgbLY2GfItxoo/2j7r1ex/jHGnRyvxv57M0pDIBnu4/gwbj6lQ22fYGGYcsmVauFpMcWL1oiAHwdOCo1lWxcBDVwfZ1RttCEHlUClB0J9nieHRTiSUbMeDnLGJmUDPnTAD6k93sR3oRPWooTBsQpbuTo2aFLkDD185qkHRhA1F78WDdbD2SVZWmgS8MyyUIj5TKPchg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFL72UA5MNoXjrI2alkZ7ejlAKYjbQkL2vVt4FhysM4=;
 b=H9lo52nBXXlIEiSKnBFAgQH2wj6mLp3fUZd7qKrw85Qx5bTR4UYNX1do0TBia3dHfrqjRCme8Z9J7AgsEp+8M8S9YSxNztRLrxViLrul2kLsyx5FV3SNwM+lXfpzpeBGoJJsgybaoKGy5rzgghuBFTUMxXTh3WiKl0/ajGIlq/I=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3668.namprd15.prod.outlook.com (2603:10b6:a03:1fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.35; Wed, 13 May
 2020 18:10:22 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::71cb:7c2e:b016:77b6]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::71cb:7c2e:b016:77b6%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 18:10:22 +0000
Date:   Wed, 13 May 2020 11:10:20 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <dccp@vger.kernel.org>, <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v2 02/17] bpf: Introduce SK_LOOKUP program type
 with a dedicated attach point
Message-ID: <20200513181020.dmj3fg3dbvuzl626@kafai-mbp.dhcp.thefacebook.com>
References: <20200511185218.1422406-1-jakub@cloudflare.com>
 <20200511185218.1422406-3-jakub@cloudflare.com>
 <20200513054121.qztevjyfkc2ltcvp@kafai-mbp.dhcp.thefacebook.com>
 <87wo5fucnu.fsf@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo5fucnu.fsf@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:a03:80::14) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:64df) by BYAPR11CA0037.namprd11.prod.outlook.com (2603:10b6:a03:80::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Wed, 13 May 2020 18:10:21 +0000
X-Originating-IP: [2620:10d:c090:400::5:64df]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e347cef-9301-442b-2520-08d7f768e714
X-MS-TrafficTypeDiagnostic: BY5PR15MB3668:
X-Microsoft-Antispam-PRVS: <BY5PR15MB36680A491146CBD11F88BB76D5BF0@BY5PR15MB3668.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GvPe4vmHXTRRtsOgqAeYCLm5Kz8nWCSJXm+8Uupb6ixMYaqIwb09oHeyyyUU8hJjnlet4iXXv3FVLFKfPmEqkyXCbl0kj3PDTj1Vl/2Q0L1J4SU2vDgUzqbRgeeb2wQtV+tuIC8nuT5nwW9O/0xiHPe/Tzeq1VDJGDdSejaoVitJxXhmKD2DtGCwlNajl1JNbkDxq5u7lVs6cYkmEPuQwADfv4jXJ0Rsa+JBFt46LEqpYApfhuY3cVdEfAbAdelDBvOLuMt530pTwUu68JrqHXA6uiug66cZOEe2N5Fnh0UuV0HfS/QY3Y9SDNEXWC3hSdUJ1bgDiuVxs8tcxSgRkC3VNPPxXbIE9pxZzIJPqI1Z/qWogPZz2L32edz7ePe1h725z1yqw6ZrXzsWjzTv9zhtd+EmBK+GtRLsy7LJZJFyE6vnK580YnDGdnfDyyPzeaEJw2Cp5pAvdx8WHFLadgNNXA5TuwE37YCDw9XxJ9BwuPvmkdvl/FoEpbeHlJ60MpDJe5Gez8qTT4XA2DgF5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(346002)(39860400002)(366004)(376002)(396003)(33430700001)(7416002)(54906003)(16526019)(2906002)(53546011)(4326008)(5660300002)(6506007)(316002)(7696005)(52116002)(8936002)(8676002)(9686003)(86362001)(1076003)(55016002)(66476007)(66556008)(66946007)(186003)(6916009)(33440700001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: iYQkyGS+IqoQED4CeFHQcl469VTCmK+zi55yL6mfJ5CR8+zPmMsrBj8kOTnnsN7iZCrZkEWu4pPIKWgdnal4hJmJPpyrxX8LbEv3Fcc/AqlDMGw1/Th8p/hVPLg+1aJTY7bGcbKIkDWeD8A4axM6MqTgLCvyK8s5Fvz/rjfMtzQ7Mv+L61fcUfVnrlcid/JCeSYyBDyX6NRIsxpBI0ZWpwziuSrKqgiYBD5MbPEJrJB0S20xWx5jSTEX75Ae/sErxVfVk3IjkI5LGSfwhNPkbtr+QDpx3NYLk1j8JoFpX1jMSS/ykx9MacHulQo4y2rodApwmiEj/PTOwkAOPgCW5QgYMpQEZcddJetebXOjVMxfbGTgkuf/jwUHSYczSeYq5jHJ5BweQBBhnUucQMqlRJ2J2uYO/7BwXSyMM/qHJs/pAlREPv0rtisVh3vIDkpicqXaO09OhLXedhlzIk83JyAV+vh6LLXBTy+1ZFRIhS+hAgey43vMy61rDsQAc9EaUfK+CLWquOVe6/Wzsw6W6A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e347cef-9301-442b-2520-08d7f768e714
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 18:10:22.5229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZIOa3NsIC7qyfzNiThyAtBN7U/JnsRPzthNRhLZnuDUJDE2Mk2C6HpnW+El1Q7F8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3668
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_08:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 cotscore=-2147483648 lowpriorityscore=0 spamscore=0 adultscore=0
 impostorscore=0 mlxlogscore=981 priorityscore=1501 bulkscore=0
 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130154
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 04:34:13PM +0200, Jakub Sitnicki wrote:
> On Wed, May 13, 2020 at 07:41 AM CEST, Martin KaFai Lau wrote:
> > On Mon, May 11, 2020 at 08:52:03PM +0200, Jakub Sitnicki wrote:
> >
> > [ ... ]
> >
> >> +BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
> >> +	   struct sock *, sk, u64, flags)
> > The SK_LOOKUP bpf_prog may have already selected the proper reuseport sk.
> > It is possible by looking up sk from sock_map.
> >
> > Thus, it is not always desired to do lookup_reuseport() after sk_assign()
> > in patch 5.  e.g. reuseport_select_sock() just uses a normal hash if
> > there is no reuse->prog.
> >
> > A flag (e.g. "BPF_F_REUSEPORT_SELECT") can be added here to
> > specifically do the reuseport_select_sock() after sk_assign().
> > If not set, reuseport_select_sock() should not be called.
> 
> That's true that in addition to steering connections to different
> services with SK_LOOKUP, you could also, in the same program,
> load-balance among sockets belonging to one service.
> 
> So skipping the reuseport socket selection, if sk_lookup already did
> load-balancing sounds useful.
> 
> Thinking about our use-case, I think we would always pass
> BPF_F_REUSEPORT_SELECT to sk_assign() because we either (i) know that
> application is using reuseport and want it manage the load-balancing
> socket group by itself, or (ii) don't know if application is using
> reuseport and don't want to break expected behavior.
Thanks for the explanation.

> 
> IOW, we'd like reuseport selection to run by default because application
> expects it to happen if it was set up. OTOH, the application doesn't
> have to be aware that there is sk_lookup attached (we can put one of its
> sockets in sk_lookup SOCKMAP when systemd activates it).
> 
> Beacuse of that I'd be in favor of having a flag for sk_assign() that
> disables reuseport selection on demand.
> 
> WDYT?
Sure, it is hard to comment which use case is more common than
another to take the default ;)
I think there are use caes for both, so no strong opinion on this ;)
