Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5122691B5
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgINQd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:33:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37796 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgINPoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:44:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08EFiFC6141963;
        Mon, 14 Sep 2020 15:44:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=eq4LTC2Yd5sfvcCLwppvKF+HmjZnZ6bst/Dh6vKmwQ4=;
 b=RLRAX6BrM34Ih+gjIw+Epxc9xBzMUxjRCzA49x9waBmG5ROyH122zIRNrKiJcl9F4jMG
 o5vlXfAT76qxk9mGooEGm/w6UYM4CCE3WCBuFtR+4iaDo4nWs6vrmB8arGC7QccFXZSe
 VtHLWWOWHlPYBIcfMkraiW/aC9MBB7N2cvKZt3LkD1WKoJbZL147JheLdjJKGzCnX0Ss
 IeoCGLYVBe9oQ4aZyDIr/uu9HrZapDkRL6gUQ2umnPvjwv4HxsI4nQKDZdgQARax9ZdL
 G5UdZXSmS3zQytLdUz5zKalVJIjdKEvbw6goCGJZhgXmGY10EVQtklnmB5CNlCMbejZk Vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33j91d916q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 14 Sep 2020 15:44:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08EFPMNK113211;
        Mon, 14 Sep 2020 15:44:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33h881tn8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 15:44:17 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08EFiDnQ017022;
        Mon, 14 Sep 2020 15:44:14 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Sep 2020 15:44:13 +0000
Date:   Mon, 14 Sep 2020 18:44:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Anmol Karn <anmol.karan123@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: Re: [Linux-kernel-mentees] [PATCH] net: bluetooth: Fix null pointer
 dereference in hci_event_packet()
Message-ID: <20200914154405.GC18329@kadam>
References: <20200910043424.19894-1-anmol.karan123@gmail.com>
 <20200910104918.GF12635@kadam>
 <20200912091028.GA67109@Thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912091028.GA67109@Thinkpad>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009140125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9744 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 12, 2020 at 02:40:28PM +0530, Anmol Karn wrote:
> On Thu, Sep 10, 2020 at 01:49:18PM +0300, Dan Carpenter wrote:
> > On Thu, Sep 10, 2020 at 10:04:24AM +0530, Anmol Karn wrote:
> > > Prevent hci_phy_link_complete_evt() from dereferencing 'hcon->amp_mgr'
> > > as NULL. Fix it by adding pointer check for it.
> > > 
> > > Reported-and-tested-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
> > > Link: https://syzkaller.appspot.com/bug?extid=0bef568258653cff272f 
> > > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > > ---
> > >  net/bluetooth/hci_event.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > > index 4b7fc430793c..871e16804433 100644
> > > --- a/net/bluetooth/hci_event.c
> > > +++ b/net/bluetooth/hci_event.c
> > > @@ -4936,6 +4936,11 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
> > >  		return;
> > >  	}
> > >  
> > > +	if (IS_ERR_OR_NULL(hcon->amp_mgr)) {
> > 
> > It can't be an error pointer.  Shouldn't we call hci_conn_del() on this
> > path?  Try to find the Fixes tag to explain how this bug was introduced.
> > 
> > (Don't rush to send a v2.  The patch requires quite a bit more digging
> > and detective work before it is ready).
> > 
> > > +		hci_dev_unlock(hdev);
> > > +		return;
> > > +	}
> > > +
> > >  	if (ev->status) {
> > >  		hci_conn_del(hcon);
> > >  		hci_dev_unlock(hdev);
> > 
> > regards,
> > dan carpenter
> > 
> 
> Sir,
> 
> I need little advice in continuing with this Patch,
> 
> I have looked into the Bisected logs and the problem occurs from this commit:
> 
> 941992d29447 ("ethernet: amd: use IS_ENABLED() instead of checking for built-in or module")
> 

That's just the patch which made the code testable by syzbot.  It didn't
introduce the bug.

> 
> Here is a diff of patch which i modified from last patch,
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 4b7fc430793c..6ce435064e0b 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -4936,6 +4936,12 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
>                 return;
>         }
> 
> +       if (!hcon->amp_mgr) {
> +               hci_conn_del(hcon);
> +               hci_dev_unlock(hdev);

I have no idea if calling hci_conn_del() is really the correct, thing.
I don't know the code at all.  Anyway, do some research and figure out
for sure what the correct thing is.

Also look for similar bugs in other places where hcon->amp_mgr is
dereferenced.  For example, amp_read_loc_assoc_final_data() seems to
have a similar bug.

regards,
dan carpenter

