Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA703105AFB
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfKUURR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:17:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60694 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUURR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:17:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALKEbjE061861;
        Thu, 21 Nov 2019 20:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VXCOimzgvVy9KqhSDIxCVNWugmykimsVTHYCDeSsKHs=;
 b=eekO0u0SQlqpWrXPvS+FY2HW0Apsk31ygvow3cpbRhqS5OLGVb33b/6stY7qURXz6CSA
 9ytPFwZ3KemwlteFWMkND0HjRwxWjE0UwZP2pmDxyRS7I93sw5g1GG+0ncNwKIzrZsC+
 fQgz8hpy74Y4IkXN6Nv/9R2tQod0nIaadLfJcV2UtyxvGODhyeb1+oiYapwXn5b4bvPV
 biezNGpmIhScJQT+ve8fk8barYDiOXjrazE7ooDmKKuSXkr0+MP9gxmRKrktPfEzIW0T
 v3Ey7e3NiJilfX9NeoBbMOZ3KVQUK0BrSaBZ4w5ArCkm8msZPWR+UojdYwD7+jgEX+TJ mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wa9rqxmyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 20:14:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALKDHXn046274;
        Thu, 21 Nov 2019 20:14:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wd46yybg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 20:14:53 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xALKEicM028952;
        Thu, 21 Nov 2019 20:14:46 GMT
Received: from kadam (/41.210.146.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Nov 2019 12:14:43 -0800
Date:   Thu, 21 Nov 2019 23:14:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     syzbot <syzbot+3967c1caf256f4d5aefe@syzkaller.appspotmail.com>
Cc:     alsa-devel@alsa-project.org, davem@davemloft.net,
        dccp@vger.kernel.org, gerrit@erg.abdn.ac.uk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        perex@perex.cz, syzkaller-bugs@googlegroups.com, tiwai@suse.com,
        tiwai@suse.de, Eric Dumazet <edumazet@google.com>
Subject: Re: KASAN: use-after-free Read in ccid_hc_tx_delete
Message-ID: <20191121201433.GD617@kadam>
References: <000000000000de3c7705746dcbb7@google.com>
 <0000000000002c243a0597dc8d9d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000002c243a0597dc8d9d@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911210168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911210168
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 07:00:00AM -0800, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit f04684b4d85d6371126f476d3268ebf6a0bd57cf
> Author: Dan Carpenter <dan.carpenter@oracle.com>
> Date:   Thu Jun 21 08:07:21 2018 +0000
> 
>     ALSA: lx6464es: Missing error code in snd_lx6464es_create()
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10dd11cae00000
> start commit:   eb6cf9f8 Merge tag 'arm64-fixes' of git://git.kernel.org/p..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=12dd11cae00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=14dd11cae00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c8970c89a0efbb23
> dashboard link: https://syzkaller.appspot.com/bug?extid=3967c1caf256f4d5aefe
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11022ccd400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124581db400000
> 
> Reported-by: syzbot+3967c1caf256f4d5aefe@syzkaller.appspotmail.com
> Fixes: f04684b4d85d ("ALSA: lx6464es: Missing error code in
> snd_lx6464es_create()")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

This crash isn't related to my commit, it's seems something specific to
DCCP.

My guess is that the fix is probably something like this.  The old sk
and the new sk re-use the same newdp->dccps_hc_rx/tx_ccid pointers.
The first sk destructor frees it and that causes a use after free when
the second destructor tries to free it.

But I don't know DCCP code at all so I might be totally off and I
haven't tested this at all...  It was just easier to write a patch than
to try to explain in words.  Maybe we should clone the ccid instead of
setting it to NULL.  Or I might be completely wrong.

---
 net/dccp/minisocks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dccp/minisocks.c b/net/dccp/minisocks.c
index 25187528c308..4cbfcccbbbbb 100644
--- a/net/dccp/minisocks.c
+++ b/net/dccp/minisocks.c
@@ -98,6 +98,8 @@ struct sock *dccp_create_openreq_child(const struct sock *sk,
 		newdp->dccps_timestamp_echo = dreq->dreq_timestamp_echo;
 		newdp->dccps_timestamp_time = dreq->dreq_timestamp_time;
 		newicsk->icsk_rto	    = DCCP_TIMEOUT_INIT;
+		newdp->dccps_hc_rx_ccid     = NULL;
+		newdp->dccps_hc_tx_ccid     = NULL;
 
 		INIT_LIST_HEAD(&newdp->dccps_featneg);
 		/*
-- 
2.11.0




