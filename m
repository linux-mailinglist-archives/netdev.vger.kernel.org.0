Return-Path: <netdev+bounces-4927-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68CF670F375
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:51:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 241A81C20BEA
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B46EC8DD;
	Wed, 24 May 2023 09:51:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C23C2F1
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:51:25 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2095.outbound.protection.outlook.com [40.107.92.95])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281F1196
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 02:51:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MdEuD05KITtFDVIzUvA3dY5TCa1a1TACuBWvJBdbeSGaUxb1bbQ0Q8zsu0p3K/5qWLwqlosKyYXMMhvlKbL3CLiGWHvtXrdzLdVqn2EcZiLk72MsfhKdBiM4Sbqpj/vMRcCzC0F+blG7I8F+cJJ/aE5YqTd6GQTRa5Dklm1To/PxUDkNa2ZuCzrTsM1Pd0jv3t/9lwAj1U+JlHZt+N2BekCucv2dn7wuuMNyUXKPh6my28K9HTnjD6iGpRcxhuN1SjznPv4/lnUtdG+OFMdaSeqGRztDzbhNBpzJ2Kn6bjrtSjhGO40Jr2gyfghv1hLrei9L5bUWLn7w3JQhTaMHCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J4Ct30uwyPIYwU0G8v8tFQApsU5VrMn74kN+VdQSkNs=;
 b=k68/QJkUFOSz/bzKf5I7bqn48eYFs/ynN6yVwwxvFprEfiETWBaHIkj+TmmNLi8bvzi03oZq2oNNrCUSYzx6uszVnCKcBp2E4wJNQAFieBTXOMuMj9TV5EbAwUyl0wBpIZQRYt2DH5gX5C136RAemHxywP98XEK396TeFcgdu8RjdckzypkD601hW40BB7HRTDS8Ym8bMuGA+nclU27YWCXEc6gbeH/pQFLA1bwD63gX8Dma7Pza2pZWdbQWlSFp1yhcXZcr+MHhqjdp4LrYA+Leb0oJVNXaaMFHxgpBT0bD6bjqwuMEVCOJUKYUL5l7MSGdaTO+eslhhvI1cBfIqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J4Ct30uwyPIYwU0G8v8tFQApsU5VrMn74kN+VdQSkNs=;
 b=Ac53JzNJi24e3xWLggTi/7OteQ9M8SwEHcaKm39b4eLf0M7Id3lTMTaGzO8qnuzxXn9bx9d+mBTaRcYkFBeJDqSIiyEgPofrGmHy1BK/ZpX69vXw0b5MMCghUmwYFeCXTFJkw6UcygSK1dqkRDG3KYc9lIB8wYk96hDgGulBs+I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5566.namprd13.prod.outlook.com (2603:10b6:510:128::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 09:51:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 09:51:18 +0000
Date: Wed, 24 May 2023 11:51:12 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Cambda Zhu <cambda@linux.alibaba.com>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Jack Yang <mingliang@linux.alibaba.com>
Subject: Re: [PATCH net v1] tcp: Return user_mss for TCP_MAXSEG in
 CLOSE/LISTEN state if user_mss set
Message-ID: <ZG3eEKyI7TZIqfwG@corigine.com>
References: <20230524083350.54197-1-cambda@linux.alibaba.com>
 <FB0C4E1D-1558-4EFC-BCC4-E6E8C6F01B7A@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FB0C4E1D-1558-4EFC-BCC4-E6E8C6F01B7A@linux.alibaba.com>
X-ClientProxiedBy: AS4P191CA0031.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:657::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5566:EE_
X-MS-Office365-Filtering-Correlation-Id: b46993e3-bb7a-4ba2-9b3d-08db5c3c6c26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7SLFYV1uPvQMrbWrYmGUUCXimPglmVN04a+ODGbDC3Rkkq9wC1Q3G8UPyKXeDgSRF9zQrqPfKfiVVo2pueVrGQxyOS9sKkKRoJPy74DRMZ3I4Dx2ySCEXX3geeHZxWrWvOhdYNf5CDhdT3TdXbD/WQjLC34oQtie+9y3PohdjDvBEuhutbat3KqQXHJXXPs7DvuTp/6A98ZZcMeiJ1Q5v3IitHas2YDlBlmwx7EWAh8hzypmz5i/chTVTaIIwCAVtrkgmmMRK5N7qhBpOCrUznmY1pbZkAXwEUGLKx6cmV2YSQKaDCMn2mA2f0wPuKbRgZekvzkLcaAuvTwu0uuAR9Xf7xR24p90p0jK+8FypH9Urfamo/izZ6+WDjfq2n0li4+FzAPaGrq8p8DUsvWCxwfPglESI8BD5kwgC0YWxTenPODsth1Y4XxG0ICDQ7k1acf/gHEkJDaycr4FJNHPJGC16o6My/56iHxep7rT5hx047z/+4BMNK2UDwEtnBY8asSyqUoz5FZ+hV5VRXD8MSBsMisJptBwFgMxXbe0kQpRcFyq2uxYJAOWgPB1oPUM2IHOuLJJ9mS5WFq8IK+kWA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(39840400004)(376002)(396003)(136003)(451199021)(8936002)(8676002)(2906002)(316002)(66476007)(4326008)(66946007)(66556008)(6916009)(5660300002)(44832011)(41300700001)(36756003)(86362001)(53546011)(6506007)(6512007)(186003)(38100700002)(6486002)(966005)(83380400001)(2616005)(6666004)(54906003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bJxmEzvJzitpIFvv0ydjXgr2DR5TcpMYnNFiJ4cib9FPWKE0pRXmJiF4V3M3?=
 =?us-ascii?Q?d1f4+GMRb862NBQDeZ3DaIBuI3DNFV10D2ALtB10yKqVzXgs/+ptTYT9KwbC?=
 =?us-ascii?Q?4Xoaqzv1q5lnBx5Jw6LaU+CVgq91S/7DZs0iZ26SFWFdFRLlb6DfoZaOJnZm?=
 =?us-ascii?Q?lOnsEO9xelJ9/cT7rBIoaPFGqJoUOE/qRxtr5aQJR2bRvzqTIsGOGLRZwKMA?=
 =?us-ascii?Q?Fx5/C2y50QLCCuTma/kyxXDUeulUHQ10yEBJHqEDrYCnxOsOJsvY/JZ+HvDW?=
 =?us-ascii?Q?QMgqPGE2onulaxOCWLGKWPaGoJQSkec+oqdZ4qU8gFlDO9mWyk2lvROpIGcQ?=
 =?us-ascii?Q?mo8yMTuC7VKnExmxssXGoEwamkNEn8bzKrrYCVik4RDiQCvRDlgGlaP9SHVW?=
 =?us-ascii?Q?tzpxXlyx7go3YzlTMbZStg6dmUKnpSdzdMy4lgxX/AUpAeMIyA4SHLjjxfTx?=
 =?us-ascii?Q?ZrPOaM1QPAw/BJHicmZ3imMT5BIIZDyoaV5SaxxLQ0dzTVFQMHCDX/qQQQs8?=
 =?us-ascii?Q?nB5bYMxVXle1/RqoW5L08nV7bbXp6WbW4i5cHNkpP8imLavmFTCc45N4z65G?=
 =?us-ascii?Q?L4dQaOSnVJdPQ2UTa23MCdtvowzpunqSgye09WUBpv28GzM9uvAvsVxdUFte?=
 =?us-ascii?Q?mSUTWWIUCy/uzjrdZ27s1lSPAq6SQnjZutbT58Wa3U0DnYNx2nCqcYay/DfE?=
 =?us-ascii?Q?TplkmJ3lGNGZyqcXSeiTTnYxhDR0MMopf/KOka2I44RpymBTD5omyJC2IzUj?=
 =?us-ascii?Q?CygtHuaHU9w90Ia4ySivr1qouNKJBBb86jDE7Yqp41NpAHeo875Bs+nZC8zP?=
 =?us-ascii?Q?ULOa2NYWdQe+5BjfwJDv4d+SvI2DKgufj8aOzt5M2Hs5sZj8VHJaSLypx81H?=
 =?us-ascii?Q?AFRZTKfKJ/7euqMhw590azr0YYECG5kTquv2Be794BytFcyTEs+aIctSfM59?=
 =?us-ascii?Q?sz96IpODY3ejmhLstBDhBlp7uo1ohMY5OmmWMxS6vL6oaBNYGuGF8L9zmKEf?=
 =?us-ascii?Q?c4Q+mjAuYXahoyrf83VFyM1Ei+RgeJxH6sMYX/5fYZz483IckMMbpw8CHLQC?=
 =?us-ascii?Q?lsCr6EdK5w12lpDXe8xi6dZ1VtTT97oxsGe3D9ybuFyrpNCurKgE/ZdrIF5c?=
 =?us-ascii?Q?wqs7+/GDGNBJwcChWWsCIsFmkMCQ/sE9EIFa2XbQdhliGCaBlxyviVYuKXRU?=
 =?us-ascii?Q?xDVlkgTW+G+Tig6QnSqVOjXNGgpevLbffp4S6tX9K3ge/r5NQ3nj0GVwXtaP?=
 =?us-ascii?Q?xlbvXOWEw+ec/1wbdDCaVQBbhhY+BlHRbrAndv1+TQUpH/9p0+I6e+G03zvB?=
 =?us-ascii?Q?H3t4lU9hnwtnZHTFYyZbpG5vA5FOGpnR/msGzYdn3WYhGs7zAca1+Bh936Kj?=
 =?us-ascii?Q?vxzHUPg6GqTVyvX+F9yOFaqwhkIZpG0jvhI4lcfIK0vmnA1RLHT3uzmEDdel?=
 =?us-ascii?Q?l2JUMwvivO8hwnJ8kaaEXoZvs0+U5Wx6khX94Thuvci2gVST6ngz9hnWMIrI?=
 =?us-ascii?Q?fVKugJl6oiVS0Jxm7Y+pfasMAv8jMcV0PwbcRlmQRFdPdHJWVp6YpTMttLop?=
 =?us-ascii?Q?6mCBiFQ3vSsyDp21qBe1ZBjChavEV/2MokmkbDRSrTCiwGuqDAhiw7i/WzBZ?=
 =?us-ascii?Q?LQsQC6wwjzGMPNHmqWsiFEvBMK+fVEo2/opoINu8u7yGhuWHSxZqW0Na2p5r?=
 =?us-ascii?Q?gTEYNg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b46993e3-bb7a-4ba2-9b3d-08db5c3c6c26
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 09:51:18.8003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y3BvWdcxw1P2hPVv2ESB3ieNc/H5wAot1eC6Zh5trkPgW898f+0XHd9AStJnWjoqDOxYMsh1b+SaX5rYJqROMW+pAQTW2MXvMTi/fKQuNbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5566
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 05:10:54PM +0800, Cambda Zhu wrote:
> 
> > On May 24, 2023, at 16:33, Cambda Zhu <cambda@linux.alibaba.com> wrote:
> > 
> > This patch replaces the tp->mss_cache check in getting TCP_MAXSEG
> > with tp->rx_opt.user_mss check for CLOSE/LISTEN sock. Since
> > tp->mss_cache is initialized with TCP_MSS_DEFAULT, checking if
> > it's zero is probably a bug.
> > 
> > With this change, getting TCP_MAXSEG before connecting will return
> > default MSS normally, and return user_mss if user_mss is set.
> > 
> > Fixes: 0c409e85f0ac ("Import 2.3.41pre2")
> > Reported-by: Jack Yang <mingliang@linux.alibaba.com>
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Link: https://lore.kernel.org/netdev/CANn89i+3kL9pYtkxkwxwNMzvC_w3LNUum_2=3u+UyLBmGmifHA@mail.gmail.com/#t
> > Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> > Link: https://lore.kernel.org/netdev/14D45862-36EA-4076-974C-EA67513C92F6@linux.alibaba.com/
> > ---
> > v1:
> > - Return default MSS if user_mss not set for backwards compatibility.
> > - Send patch to net instead of net-next, with Fixes tag.
> > - Add Eric's tags.
> > ---
> > net/ipv4/tcp.c | 3 ++-
> > 1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 4d6392c16b7a..3e01a58724b8 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -4081,7 +4081,8 @@ int do_tcp_getsockopt(struct sock *sk, int level,
> > switch (optname) {
> > case TCP_MAXSEG:
> > val = tp->mss_cache;
> > - if (!val && ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
> > + if (tp->rx_opt.user_mss &&
> > +    ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
> > val = tp->rx_opt.user_mss;
> > if (tp->repair)
> > val = tp->rx_opt.mss_clamp;
> > -- 
> > 2.16.6
> 
> I see netdev/verify_fixes check failed for the commit 0c409e85f0ac ("Import 2.3.41pre2").
> The commit is from:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> Should I remove the Fixes tag?

Hi Cambda Zhu,

AFAIK, that is a tree of historical versions that predate git history,
which began with version v2.6.12-rc2.

If this is a fix for a but ghat has been present since before v2.6.12-rc2
then I think standard practice is to use the initial commit of
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

That is:

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

N.B.: I did not check to see if the bug you are fixing has been present
since then. But in any case, the fixes tag in your patch is not correct.

-- 
pw-bot: cr


