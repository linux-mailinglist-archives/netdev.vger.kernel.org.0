Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A341430EE
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 18:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgATRpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 12:45:04 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36502 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATRpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 12:45:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KHcUYX053676;
        Mon, 20 Jan 2020 17:42:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=nsNYTKOD1G7P8637WPTXpEBWnVeiNPIbkuT9jeXT0js=;
 b=oJLiW6I6rOgABwklmW9RSbDKKN73DmHgvRle4GX4iIdpR9TRi2WhOeKw3EeFIF8A8Okc
 vtYm178GxljrTMcuf/SEsEY10tbUxSYvDtC8DpOLslO/imbqvXyMzTVmnh2ZuK+H1F6W
 NGpcF2+hs2tNEb0o6ZoVF09knBVEp8h4Vu93EIM6FyxP5F79psmdFsN9VszA7Ynw2ch5
 btcTrqx+lnTHCATaSCGxm2FwR7qI0PR1qcB688PPPQ66WLz4o+Gykfy/stmom5dZExzx
 5BkpQL+7X6JjVfmR7yTW1Yz6AhkRkFUhCM0PZ+YENpackQC55jxv0bApXUOsS7jJ0XuA 5Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xkseu8vmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 17:42:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KHcveQ161458;
        Mon, 20 Jan 2020 17:42:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xmbg8syfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 17:42:50 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00KHgMnn028408;
        Mon, 20 Jan 2020 17:42:25 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 09:42:22 -0800
Date:   Mon, 20 Jan 2020 20:46:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     syzbot <syzbot+6491ea8f6dddbf04930e@syzkaller.appspotmail.com>,
        a@unstable.cc, akpm@linux-foundation.org, allison@lohutok.net,
        arnd@arndb.de, axboe@kernel.dk, b.a.t.m.a.n@lists.open-mesh.org,
        bp@alien8.de, catalin.marinas@arm.com, chris@zankel.net,
        christian@brauner.io, coreteam@netfilter.org, davem@davemloft.net,
        elena.reshetova@intel.com, florent.fourcot@wifirst.fr,
        fw@strlen.de, geert@linux-m68k.org, hare@suse.com,
        heiko.carstens@de.ibm.com, hpa@zytor.com, info@metux.net,
        jcmvbkbc@gmail.com, jeremy@azazel.net, johannes.berg@intel.com,
        kadlec@netfilter.org, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, linux@armlinux.org.uk,
        mareklindner@neomailbox.ch, mingo@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, peterz@infradead.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        viro@zeniv.linux.org.uk, will@kernel.org, x86@kernel.org
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_ext_cleanup
Message-ID: <20200120174615.GE21151@kadam>
References: <000000000000bdb5b2059c865f5c@google.com>
 <000000000000c795fa059c884c21@google.com>
 <20200120131930.pbhbsrm4bk4lq3d7@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200120131930.pbhbsrm4bk4lq3d7@wittgenstein>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001200149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9506 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001200149
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 02:19:31PM +0100, Christian Brauner wrote:
> On Sun, Jan 19, 2020 at 05:35:01PM -0800, syzbot wrote:
> > syzbot has bisected this bug to:
> > 
> > commit d68dbb0c9ac8b1ff52eb09aa58ce6358400fa939
> > Author: Christian Brauner <christian@brauner.io>
> > Date:   Thu Jun 20 23:26:35 2019 +0000
> > 
> >     arch: handle arches who do not yet define clone3
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1456fed1e00000
> > start commit:   09d4f10a net: sched: act_ctinfo: fix memory leak
> > git tree:       net
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=1656fed1e00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1256fed1e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
> > dashboard link: https://syzkaller.appspot.com/bug?extid=6491ea8f6dddbf04930e
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141af959e00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1067fa85e00000
> > 
> > Reported-by: syzbot+6491ea8f6dddbf04930e@syzkaller.appspotmail.com
> > Fixes: d68dbb0c9ac8 ("arch: handle arches who do not yet define clone3")
> > 
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
> This bisect seems bogus.
> 

Yeah.  József Kadlecsik already fixed the bug in a different thread.  It
was reported as seven different bugs so there was a bunch of threads for
it.

regards,
dan carpenter
