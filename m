Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3CCA138DD1
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 10:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgAMJ3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 04:29:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35876 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgAMJ3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 04:29:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00D9S6vc118764;
        Mon, 13 Jan 2020 09:29:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=rk5u8L6wRMK1AGNiB+kNPMk8Q8W00RDcw7ifTsL/9as=;
 b=nlKWV3eTOHgW0MXu7mATwZ052y9HMkO5W8Cr5S8DRJ0X2mlQmb5VTOa+2fXcxljx39NO
 i+MfCT01edsAbzMOvB0Q+1YcOg6Ktm+3B270Sg7Lg0QEfWrEqL8jYAeBKy3rEqzWDLl+
 xi4gvvhsq6vz45/fmwc+Lg+aqZ7enxov6toQ5izJrYJJWtZro4xtJZIGeU2JIuAq8F2X
 OYYYIFHyjI/7Nv2o0s/zoadlPx/BjKRvcklIITo7cVvLdc2JWBNR7/gZHSxWGQ73iFQg
 rBc3Mew4ZOQq5G04zMmebbRoleRbiKAH9NtrdbUozbTuZdDsEYpbcwJYx0RaGfH/6ee9 mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74rwpp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 09:29:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00D9TEvj015587;
        Mon, 13 Jan 2020 09:29:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xfqvq4665-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 09:29:19 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00D9STPe002615;
        Mon, 13 Jan 2020 09:28:29 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 01:28:28 -0800
Date:   Mon, 13 Jan 2020 12:28:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Justin Capella <justincapella@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        syzbot <syzbot+34b582cf32c1db008f8e@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Cody Schuffelen <schuffelen@google.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 cfg80211_wext_siwrts
Message-ID: <20200113092820.GB9510@kadam>
References: <00000000000073b469059bcde315@google.com>
 <b5d74ce6b6e3c4b39cfac7df6c2b65d0a43d4416.camel@sipsolutions.net>
 <CAMrEMU_a9evtp26tYB6VUxznmSmH98AmpP8xnejQr5bGTgE+8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMrEMU_a9evtp26tYB6VUxznmSmH98AmpP8xnejQr5bGTgE+8g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9498 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001130080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9498 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001130080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That's the wrong ops struct?  I think I was looking at the "previous
report" that Johannes mentioned where it was crashing because
virt_wifi doesn't implement a set_wiphy_params function.

Smatch says there are two other drivers, the libertas and ipw2x00 which
don't have a set_wiphy_params function either.  But maybe those handle
it a different way.

drivers/net/wireless/marvell/libertas/cfg.c | (null)                         | (struct cfg80211_ops)->set_wiphy_params | 0
drivers/net/wireless/virt_wifi.c | (null)                         | (struct cfg80211_ops)->set_wiphy_params | 0
drivers/net/wireless/intel/ipw2x00/libipw_module.c | (null)                         | (struct cfg80211_ops)->set_wiphy_params | 0

regards,
dan carpenter

On Fri, Jan 10, 2020 at 09:23:57PM -0800, Justin Capella wrote:
> I noticed pfifo_qdisc_ops is exported as default_qdisc_ops is it
> possible this is how rdev->ops is NULL
> 
> Seems unlikely, but thought I'd point it out.
> 
> 
> On Fri, Jan 10, 2020 at 11:13 AM Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> > On Fri, 2020-01-10 at 11:11 -0800, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    2f806c2a Merge branch 'net-ungraft-prio'
> > > git tree:       net
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=1032069ee00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=5c90cac8f1f8c619
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=34b582cf32c1db008f8e
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > >
> > > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > It's quite likely also in virt_wifi, evidently that has some issues.
> >
> > Cody, did you take a look at the previous report by any chance?
> >
> > johannes
> >
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/CAMrEMU_a9evtp26tYB6VUxznmSmH98AmpP8xnejQr5bGTgE%2B8g%40mail.gmail.com.
