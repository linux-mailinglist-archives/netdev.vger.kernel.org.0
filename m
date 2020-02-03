Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80CD41502B8
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 09:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgBCIjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 03:39:22 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42356 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgBCIjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 03:39:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0138c3np067675;
        Mon, 3 Feb 2020 08:39:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=lh1h0yHtzO5kI/7xMb6UmPUubBBS5DwI9HPKs5tX72Q=;
 b=p64DxnizsgWHOspKnbq/b5YcvY1r18L37bAHRpY9G0pudaRqmOXnup5CbP3ab4Uz5eul
 J4SM66Vdf50nWAln7YsxuihXWEskwQB7oE32Saaar2SiKuh7jBVcOCF6f5nl6EWzL50s
 6V8lCAvHHonPVNI7MuJoM5ZWjvnPAS2/j/ubQhwdZEqg9x87++sFn2fHa3w/FNGj3q8z
 TtoVEjJQSdH7ZticzzAHCJjfdvZe1yp5NSQTkjzCb5oIJzaRDma0daDjNZYOMOBQsMzo
 j6Qr2AjmReh5oKXjg8i9PMdEM7ce5J1cFcl8Ov3eHHz62870UvpJRJgSV2Xf0bdcRd3v Ew== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xw19q656c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Feb 2020 08:39:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0138YFUB091185;
        Mon, 3 Feb 2020 08:39:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xwkfsrhac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Feb 2020 08:39:07 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0138d35A022392;
        Mon, 3 Feb 2020 08:39:03 GMT
Received: from kadam (/41.210.143.134)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Feb 2020 00:39:03 -0800
Date:   Mon, 3 Feb 2020 11:38:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        "V. Saicharan" <vsaicharan1998@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: sched: prevent a use after free
Message-ID: <20200203083853.GH11068@kadam>
References: <20200131065647.joonbg3wzcw26x3b@kili.mountain>
 <CAM_iQpUYv9vEVpYc-WfMNfCc9QaBzmTYs66-GEfwOKiqOXHxew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUYv9vEVpYc-WfMNfCc9QaBzmTYs66-GEfwOKiqOXHxew@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9519 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002030069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9519 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002030069
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 01, 2020 at 11:38:43AM -0800, Cong Wang wrote:
> On Thu, Jan 30, 2020 at 10:57 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> >
> > The code calls kfree_skb(skb); and then re-uses "skb" on the next line.
> > Let's re-order these lines to solve the problem.
> >
> > Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >  net/sched/sch_fq_pie.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
> > index bbd0dea6b6b9..78472e0773e9 100644
> > --- a/net/sched/sch_fq_pie.c
> > +++ b/net/sched/sch_fq_pie.c
> > @@ -349,9 +349,9 @@ static int fq_pie_change(struct Qdisc *sch, struct nlattr *opt,
> >         while (sch->q.qlen > sch->limit) {
> >                 struct sk_buff *skb = fq_pie_qdisc_dequeue(sch);
> >
> > -               kfree_skb(skb);
> >                 len_dropped += qdisc_pkt_len(skb);
> >                 num_dropped += 1;
> > +               kfree_skb(skb);
> 
> Or even better: use rtnl_kfree_skbs().

Why is that better?

regards,
dan carpenter

