Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B461814625B
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 08:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgAWHOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 02:14:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60732 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgAWHOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 02:14:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7DA4R152700;
        Thu, 23 Jan 2020 07:13:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=BOy4K2QWjRBsMDuS+rLwD8ll1XI+QfWWndEhMOblce0=;
 b=ltf6qhyb5gt5ndzPnTqxgkTMbDsZ/ziUkEztgKDGUhLKzypCLsa/+FCQmJqhK6Hfc+Cj
 BPr4N/XqEW1VQs2+x4vUb4qeuxr+E07/odYsHA/5HWZKTFqmQrRXObuzPWXsm1Sg+MBN
 iaCvVjTIk/q1CHF4wqNPxXxHjNqk5l7e0NdHmh5KwLVxOlSVH1hsMrRF5jlWcYk/imWL
 MShHp7GXT4KIQYxO58dAIKNHm7VxnVp5JN5mSQFZ4Gx2/xhFT9u2rVul3JdhVU3AHBdF
 85hSSeTUVV+37y8q2HsOypLN2rkqEtCJsvcgQ7L6nLUkZ29wm2r9lIOArRHYIpuf6KpC KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xkseurgqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:13:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7Dmi0172749;
        Thu, 23 Jan 2020 07:13:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xpq0vtgdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:13:56 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00N7DN0C000935;
        Thu, 23 Jan 2020 07:13:24 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 23:13:22 -0800
Date:   Thu, 23 Jan 2020 10:13:13 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+5af9a90dad568aa9f611@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: KASAN: slab-out-of-bounds Read in __nla_put_nohdr
Message-ID: <20200123071313.GI1847@kadam>
References: <0000000000006370ef059cabac14@google.com>
 <50239085-ff0f-f797-99af-1a0e58bc5e2e@gmail.com>
 <CAM_iQpXqh1ucVST199c72V22zLPujZy-54p=c5ar=Q9bWNq7OA@mail.gmail.com>
 <7056f971-8fae-ce88-7e9a-7983e4f57bb2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7056f971-8fae-ce88-7e9a-7983e4f57bb2@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=841
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230061
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=905 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230061
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 12:33:17PM -0800, Eric Dumazet wrote:
> 
> 
> On 1/22/20 12:27 PM, Cong Wang wrote:
> > On Tue, Jan 21, 2020 at 11:55 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >> em_nbyte_change() sets
> >> em->datalen = sizeof(*nbyte) + nbyte->len;
> >>
> >> But later tcf_em_validate() overwrites em->datalen with the user provide value (em->datalen = data_len; )
> >> which can be bigger than the allocated (kmemdup) space in em_nbyte_change()
> >>
> >> Should net/sched/em_nbyte.c() provide a dump() handler to avoid this issue ?
> > 
> > I think for those who implement ->change() we should leave
> > ->datalen untouched to respect their choices. I don't see why
> > we have to set it twice.
> > 
> >
> 
> Agreed, but we need to audit them to make sure all of them are setting ->datalen
> 

Smatch provides a way to do this sort of search:

$ smdb where tcf_ematch datalen
net/sched/ematch.c             | tcf_em_validate                | (struct tcf_ematch)->datalen | 0-65519
net/sched/ematch.c             | tcf_em_tree_validate           | (struct tcf_ematch)->datalen | 0
net/sched/em_ipt.c             | em_ipt_change                  | (struct tcf_ematch)->datalen | 16-131080
net/sched/em_meta.c            | em_meta_change                 | (struct tcf_ematch)->datalen | 48
net/sched/em_text.c            | em_text_change                 | (struct tcf_ematch)->datalen | 16
net/sched/em_canid.c           | em_canid_change                | (struct tcf_ematch)->datalen | 276-4268
net/sched/em_ipset.c           | em_ipset_change                | (struct tcf_ematch)->datalen | 4
net/sched/em_nbyte.c           | em_nbyte_change                | (struct tcf_ematch)->datalen | 4-4099

It is imperfect...  The main drawback is that it's based on my
allmodconfig which might not include every function.  But always there
are other bugs to be discovered.

regards,
dan carpenter

