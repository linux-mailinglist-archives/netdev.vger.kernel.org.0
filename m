Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0FB2DA596
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 02:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbgLOBbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 20:31:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4236 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729840AbgLOBbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 20:31:07 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BF1L4id022102;
        Mon, 14 Dec 2020 17:29:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=1Xi1cNs+oXUfwP4v5xQUEvHsNYccfkQ1KnNGhU/7K7s=;
 b=c/LrUeYxuy1oBIZXwgnOb/W9K5iFEhhGB9legW8Tqg3aN2ln6iDgGEQYNQ1rYX4p67bY
 kEyQqX8t4YLSGPv97zOmB9jpEeukrJwYw7aGSlE01VFXLYE7yYTKcrGkH7CJCS600Kni
 R1PD9T+63IIXPuoHTu393J54Ar3prT/KxAw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35df0e8bky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Dec 2020 17:29:51 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Dec 2020 17:29:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJqgRdAnHuYhmMXkkmGWC8Nbd1wNhfHB84YeZrjLDKDo2L5rTr4VCzz/t+9iD8wS526ZTuK2o3e57edhEcAHtQ/nEdbIYIIk9lQpcSQwrF3ufKF+ysbR597DnD47ZYAAn3LD3DJVPyZXmVwetYZdGIJsTXCYk4u1TNQ5e3KuhqmgZ4pLxbW7UqDV4pf8wZocFolVgQRW7WqVvhIb0Y+Z/OBPaDfU20YSO63lPMbKVl6wfNxYmOv0PwMpzSp1c/aiMLmLyuq5MJMiO0wokgwh7CIOEuejkBdb+TyOpExUUrU+Mkw6Y36ls0czDzcQkw+kA9sgn9hA+TT0k0EUr0F2Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Xi1cNs+oXUfwP4v5xQUEvHsNYccfkQ1KnNGhU/7K7s=;
 b=gkFkdtlCPNd/3R4CfrNhxd3yuicGyRPtdEDq+GYHp1brYx/RlprjaY7lxdDU/LF3QLJdzwDCB+XLoet6m5ufwhM4VRpqny3+gfSFWv39VkWzrd7lI0ZmvzdDwHKit3xFDtXqx1rP5juYwwIc6EeiClggYePwWkVPxTCJbWuKptSysb7NhkQwLcQVQsw5Xw30AQplasWkr+f+y7Twx5LvmZU9hDr0pxjLgKaYYShcaIRmB5jRo/w9efLa47ij3vcw/jq3De9Z0PPFJS+fxkNrJo+CiRuIt0MATMZ5ftlUMjIeuRnxQBV/WskmLRn2kCkTvGRdxYtwAu2gyCgwGhxIXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Xi1cNs+oXUfwP4v5xQUEvHsNYccfkQ1KnNGhU/7K7s=;
 b=VHrIW//VWX+W++pGcpPT23d1QNP7Z1mSdlangKlbFcbKtY/gRa0i1kFX0rU2udgA/eaWFSLxQnEEt+4rN2dGBJR8FlFpWsCNTinqEz3AtIFgj0cLHla8yqxE/6uHr5U4/cFPPbCfunzFJSe5gZnhsn/kpG6ed2bqWQENjnwmHUA=
Authentication-Results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2631.namprd15.prod.outlook.com (2603:10b6:a03:150::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Tue, 15 Dec
 2020 01:29:48 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396%6]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 01:29:48 +0000
Date:   Mon, 14 Dec 2020 17:29:43 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 bpf-next tree
Message-ID: <20201215012943.GA3079589@carbon.DHCP.thefacebook.com>
References: <20201204202005.3fb1304f@canb.auug.org.au>
 <20201215072156.1988fabe@canb.auug.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215072156.1988fabe@canb.auug.org.au>
X-Originating-IP: [2620:10d:c090:400::5:7945]
X-ClientProxiedBy: MW2PR16CA0068.namprd16.prod.outlook.com
 (2603:10b6:907:1::45) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:7945) by MW2PR16CA0068.namprd16.prod.outlook.com (2603:10b6:907:1::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 01:29:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 638ce62e-b73c-421b-0533-08d8a098e93e
X-MS-TrafficTypeDiagnostic: BYAPR15MB2631:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2631C72C44F49E86C57CFA8FBEC60@BYAPR15MB2631.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZEkMENeNdQueZz8oAWNk9EpWDYRGEA62kVGxaoN1sJIEbhdfXezfbTouuAWFVyL3WBW5KtvaE++M1VIG5KBflGigyMZKlbScVYwvpTn3WGy3t6ruYcHN+789NlMTbxQ1CvOr46ZDFRfQPDFSWLJVTAypVCFco6lQuhQDdaINu7sNrBisrZQDOMfug9sFXtQ6gFoFTk8w2BbnfSd70sr/Z+KI9ORN69tfd0gBLO54Vu3r/NGwEdajOafLE5uVPO4OZI9UfvDunV3Ys/5inHSnhY/72XI5Vf/UXacxfhaSv3yQ8dppBSzI9LcYxc9aaH0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(136003)(110136005)(186003)(66946007)(54906003)(16526019)(1076003)(33656002)(4326008)(5660300002)(6666004)(83380400001)(8936002)(2906002)(55016002)(7696005)(8676002)(53546011)(66556008)(52116002)(508600001)(9686003)(66476007)(7416002)(86362001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4irI0piKlrHTS2HFNSrqCyWGMLqLdkjwWjgTGe4uw+dPUQisIosww7xiljYh?=
 =?us-ascii?Q?Ra6sORzHGmoLMjfv++dklI7ilYMxb8uKCiSDfMR9+uXzr7kyjxeERR/DCaFB?=
 =?us-ascii?Q?UAhug0+AJnZ8t2ktxByvH91UN+vy7aF04EaF+3VYUwpOv3VZV4RX31Q8U9ze?=
 =?us-ascii?Q?4Zp/NgzR5lw8wwIMA7KefKaZTrLZmesIBgz0LBmapqmt3GwzrzX7YbWtNR8C?=
 =?us-ascii?Q?kprVA9BJ7NcsZfOV5PQiRj/ZCLriCZFhes4y1+30pX8FxDkafHvhYd7XlODR?=
 =?us-ascii?Q?ilA9TVuslWPqQF2NiYzUeviEwvIMvavWzVMSpldaKPM7zDJ4Fz85Cq45SPpm?=
 =?us-ascii?Q?J3sMdQaFTP9lZNxnrkGAa5iXKLurySIeGIoW4u3r4b0xz0yqXA0AvVzjgHTC?=
 =?us-ascii?Q?z5FNmffDYLSjxs3f5BIaECaMlFAObbmPnXdGnGRa4Nyz9uy7DFmWVyBheBaL?=
 =?us-ascii?Q?ka6FWhLNoAFHMZaqkbKBxEE8UolbRyqdpFo5eSxHD20jRsxFk+vXIb5DFBuf?=
 =?us-ascii?Q?ebFA155IWu7FDiX6gfiPkOzOGm03cs5luC094OPmiI/RDk6i3fG35omuZmPF?=
 =?us-ascii?Q?fRi9n/Vl3DC3uZG9TAxIl3WXGzl8GRSHeNtH9/yO2WThkLc1JoZfEx8kPdjL?=
 =?us-ascii?Q?VheQCvOclw5uuwXgnxHIBfLVhEo8/3CZOzBmKxO9LBewnUMt3RQLDpeCj6Z9?=
 =?us-ascii?Q?R5XgIpgE48cjhBdfw0lbHozZ+3bcqIBqgVnKzxNS6VjusaCBWUzmbps9m0LB?=
 =?us-ascii?Q?VAzsvhFwknQ41ofBD2WOnIwmeJLPNaL48JGJE4zTcEHDVJWRvup3BYbuqKpr?=
 =?us-ascii?Q?EAFXwwAq4DcbZwXnqrqq0dapp2Oh8h4Wg19cMh1va6d0NJc5u3BNOlrSWZ+G?=
 =?us-ascii?Q?Ht/uYl8FML403PEnOkOT06kzG1VK0gbwiT10ugk973hIaS6UUNq580xF6MM3?=
 =?us-ascii?Q?7/N9yBDkuvu/7J2ysN9RjTm1rORFvqvG1dUcLK8kdMLyBZqjmNyYJ2Y2EAt8?=
 =?us-ascii?Q?vPZatDpHH7yfQ4K4BONV0LmEew=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 01:29:48.0955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 638ce62e-b73c-421b-0533-08d8a098e93e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPT57OEa6FbD9w4nP3ViAGAncsV/NYDfaCqiP0ftAjWk8ZPuX2qcian5kbp+Y3fT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2631
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_13:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1011 spamscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150004
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 07:21:56AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> On Fri, 4 Dec 2020 20:20:05 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next merge of the akpm-current tree got conflicts in:
> > 
> >   include/linux/memcontrol.h
> >   mm/memcontrol.c
> > 
> > between commit:
> > 
> >   bcfe06bf2622 ("mm: memcontrol: Use helpers to read page's memcg data")
> > 
> > from the bpf-next tree and commits:
> > 
> >   6771a349b8c3 ("mm/memcg: remove incorrect comment")
> >   c3970fcb1f21 ("mm: move lruvec stats update functions to vmstat.h")
> > 
> > from the akpm-current tree.
> > 
> > I fixed it up (see below - I used the latter version of memcontrol.h)
> > and can carry the fix as necessary. This is now fixed as far as
> > linux-next is concerned, but any non trivial conflicts should be
> > mentioned to your upstream maintainer when your tree is submitted for
> > merging.  You may also want to consider cooperating with the maintainer
> > of the conflicting tree to minimise any particularly complex conflicts.
> > 
> > I also added this merge fix patch:
> > 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Fri, 4 Dec 2020 19:53:40 +1100
> > Subject: [PATCH] fixup for "mm: move lruvec stats update functions to vmstat.h"
> > 
> > conflict against "mm: memcontrol: Use helpers to read page's memcg data"
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  mm/memcontrol.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 6f5733779927..3b6db4e906b5 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -851,16 +851,17 @@ void __mod_lruvec_page_state(struct page *page, enum node_stat_item idx,
> >  			     int val)
> >  {
> >  	struct page *head = compound_head(page); /* rmap on tail pages */
> > +	struct mem_cgroup *memcg = page_memcg(head);
> >  	pg_data_t *pgdat = page_pgdat(page);
> >  	struct lruvec *lruvec;
> >  
> >  	/* Untracked pages have no memcg, no lruvec. Update only the node */
> > -	if (!head->mem_cgroup) {
> > +	if (!memcg) {
> >  		__mod_node_page_state(pgdat, idx, val);
> >  		return;
> >  	}
> >  
> > -	lruvec = mem_cgroup_lruvec(head->mem_cgroup, pgdat);
> > +	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> >  	__mod_lruvec_state(lruvec, idx, val);
> >  }
> >  
> > -- 
> > 2.29.2
> > 
> > -- 
> > Cheers,
> > Stephen Rothwell
> > 
> > diff --cc include/linux/memcontrol.h
> > index 320369c841f5,ff02f831e7e1..000000000000
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > diff --cc mm/memcontrol.c
> > index 7535042ac1ec,c9a5dce4343d..000000000000
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@@ -2880,9 -2984,9 +2975,9 @@@ static void cancel_charge(struct mem_cg
> >   
> >   static void commit_charge(struct page *page, struct mem_cgroup *memcg)
> >   {
> >  -	VM_BUG_ON_PAGE(page->mem_cgroup, page);
> >  +	VM_BUG_ON_PAGE(page_memcg(page), page);
> >   	/*
> > - 	 * Any of the following ensures page->mem_cgroup stability:
> > + 	 * Any of the following ensures page's memcg stability:
> >   	 *
> >   	 * - the page lock
> >   	 * - LRU isolation
> > @@@ -6977,11 -7012,10 +6997,10 @@@ void mem_cgroup_migrate(struct page *ol
> >   		return;
> >   
> >   	/* Page cache replacement: new page already charged? */
> >  -	if (newpage->mem_cgroup)
> >  +	if (page_memcg(newpage))
> >   		return;
> >   
> > - 	/* Swapcache readahead pages can get replaced before being charged */
> >  -	memcg = oldpage->mem_cgroup;
> >  +	memcg = page_memcg(oldpage);
> >   	if (!memcg)
> >   		return;
> >   
> 
> Just a reminder that this conflict still exists.  Commit bcfe06bf2622
> is now in the net-next tree.

Thanks, Stephen!

I wonder if it's better to update these 2 commits in the mm tree to avoid
conflicts?

Basically split your fix into two and merge it into mm commits.
The last chunk in the patch should be merged into "mm/memcg: remove incorrect comment".
And the rest into "mm: move lruvec stats update functions to vmstat.h".

Andrew, what do you think?

Thanks!
