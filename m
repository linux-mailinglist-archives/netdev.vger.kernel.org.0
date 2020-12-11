Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0162D720F
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 09:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437019AbgLKInm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 03:43:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41338 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436999AbgLKImt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 03:42:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BB8Zk9N131897;
        Fri, 11 Dec 2020 08:41:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jOZGvC2+sBPwkyav1Ks8v0XF2DBjWUZAKHKMuRwXt5Q=;
 b=flG1t/X8psmwXy0jbhlVLTenFLzXaP3KXFU8hi2poepGHNBdSHyBPe1fG9aBG2DuveXK
 rnk3W7bwV1cZKcy8NAxj4SCj4BaS0JDvRNQxLXSPyYPLTgYZVEogXFiiUrj9dqs3h9sh
 j8QpuZ/1+BjK37pAc97cxO5DGgWGalK5Z0BXrqE6MHq8hF9K953iUKByGIrJPDh9Yg/y
 0P6W7JWbJ1pwmp0DlO8hKTv4uq0HJes+e7NFbf4HqSAOrWR1NpEvk7HNhMQU6HAryVFU
 9twDrvGwv7ZQva1LccywZ0GRHJOR2L0ZB7uPYadJmhr3yupLoGAlLPmgGplYCJaW6IHK 9A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35825mhd84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Dec 2020 08:41:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BB8Tseq010489;
        Fri, 11 Dec 2020 08:41:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 358m53jbwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 08:41:54 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BB8fpGR020184;
        Fri, 11 Dec 2020 08:41:51 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Dec 2020 00:41:50 -0800
Date:   Fri, 11 Dec 2020 11:41:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     kbuild@lists.01.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, lkp@intel.com,
        kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net-next 3/4] sch_htb: Stats for offloaded HTB
Message-ID: <20201211084141.GQ2789@kadam>
References: <20201210082851.GL2767@kadam>
 <7d1a6afe-d084-bdbd-168a-3bcb88910e2d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d1a6afe-d084-bdbd-168a-3bcb88910e2d@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9831 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012110054
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9831 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012110054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 05:07:28PM +0200, Maxim Mikityanskiy wrote:
> On 2020-12-10 10:28, Dan Carpenter wrote:
> > Hi Maxim,
> > 
> > 
> > url:    https://github.com/0day-ci/linux/commits/Maxim-Mikityanskiy/HTB-offload/20201210-000703
> > base:
> > https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
> > afae3cc2da100ead3cd6ef4bb1fb8bc9d4b817c5
> > config: i386-randconfig-m021-20201209 (attached as .config)
> > compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > smatch warnings:
> > net/sched/sch_htb.c:1310 htb_dump_class_stats() error: we previously assumed 'cl->leaf.q' could be null (see line 1300)
> > 
> > vim +1310 net/sched/sch_htb.c
> > 
> > ^1da177e4c3f415 Linus Torvalds        2005-04-16  1289  static int
> > 87990467d387f92 Stephen Hemminger     2006-08-10  1290  htb_dump_class_stats(struct Qdisc *sch, unsigned long arg, struct gnet_dump *d)
> > ^1da177e4c3f415 Linus Torvalds        2005-04-16  1291  {
> > ^1da177e4c3f415 Linus Torvalds        2005-04-16  1292  	struct htb_class *cl = (struct htb_class *)arg;
> > 1e0ac0107df684e Maxim Mikityanskiy    2020-12-09  1293  	struct htb_sched *q = qdisc_priv(sch);
> > 338ed9b4de57c4b Eric Dumazet          2016-06-21  1294  	struct gnet_stats_queue qs = {
> > 338ed9b4de57c4b Eric Dumazet          2016-06-21  1295  		.drops = cl->drops,
> > 3c75f6ee139d464 Eric Dumazet          2017-09-18  1296  		.overlimits = cl->overlimits,
> > 338ed9b4de57c4b Eric Dumazet          2016-06-21  1297  	};
> > 6401585366326fc John Fastabend        2014-09-28  1298  	__u32 qlen = 0;
> > ^1da177e4c3f415 Linus Torvalds        2005-04-16  1299
> > 5dd431b6b92c0db Paolo Abeni           2019-03-28 @1300  	if (!cl->level && cl->leaf.q)
> >                                                                                    ^^^^^^^^^^
> > Check for NULL
> 
> Well, I don't think this is real... I don't see any possibility how
> cl->leaf.q can be NULL for a leaf class. However, I'll add a similar check
> below anyway.
> 

Another option is to remove this check if it's really impossible.

regards,
dan carpenter

