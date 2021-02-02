Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D76930B8FA
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhBBHw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:52:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhBBHwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 02:52:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1127mtrS081670;
        Tue, 2 Feb 2021 07:51:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3Y7HNwr7hwVxzByk5cPGCIUfvrvL9EP75VZLXwMVsuk=;
 b=LlgwXwLcbzusCXs8ZaG6C0m6COk/TjIEJfgUvT21/VWyqG+zw18xoBGHNbpEu+snI19V
 8Qp6j8dtqpkwa4bhbPKRRspvYQx3wnpJuXl82kAbx4Ik0Nu4ivZQb/W48p3Le7aBj2ir
 McQ4CadLbk4Fl7zdOlwQ2VzeKfRXzHJplBSie8fOm0IUsSuM9hgW5jMEwsc5FM7Nrwz7
 E9InRP+EJPbVbtyGlvZZY1A3B4z2DvaQAoL2n78utgO7a5ZWTb1+wu1NGTkYK/Z3w4qK
 e/HgnMx2nfJ1T2wTITGtjK0Rq3QG4ymKO9NKjUrT5xg3hmUbtIBO0EfuioB6O/YIBgDN aQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36cydksa06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 07:51:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1127pSK4174056;
        Tue, 2 Feb 2021 07:51:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 36dh1nkrwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 07:51:29 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1127pKPn022650;
        Tue, 2 Feb 2021 07:51:20 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Feb 2021 23:51:19 -0800
Date:   Tue, 2 Feb 2021 10:51:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hillf Danton <hdanton@sina.com>, Sasha Levin <sashal@kernel.org>,
        Archie Pusaka <apusaka@chromium.org>
Cc:     syzbot <syzbot+3ed6361bf59830ca9138@syzkaller.appspotmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Miao-chen Chou <mcchou@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: slab-out-of-bounds Read in add_adv_patterns_monitor
Message-ID: <20210202075110.GR2696@kadam>
References: <00000000000076ecf305b9f8efb1@google.com>
 <20210131100154.14452-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210131100154.14452-1-hdanton@sina.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020053
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1011
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sasha, do your stable patch picker scripts look at syzbot fix commands
to select patches to back port?  In this case a bug was fixed while
adding a new feature.  No one noticed the bug fix and there was no Fixes
tag.

On Sun, Jan 31, 2021 at 06:01:54PM +0800, Hillf Danton wrote:
> On Thu, 28 Jan 2021 09:08:24 -0800
> > syzbot found the following issue on:
> > 
> > HEAD commit:    b491e6a7 net: lapb: Add locking to the lapb module
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17ba0f2cd00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=be33d8015c9de024
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3ed6361bf59830ca9138
> > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10628ae8d00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12964b80d00000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+3ed6361bf59830ca9138@syzkaller.appspotmail.com
> > 
> > IPVS: ftp: loaded support on port[0] = 21
> > ==================================================================
> > BUG: KASAN: slab-out-of-bounds in add_adv_patterns_monitor+0x91f/0xa90 net/bluetooth/mgmt.c:4266
> > Read of size 1 at addr ffff888013251b29 by task syz-executor387/8480
> > 
> > CPU: 1 PID: 8480 Comm: syz-executor387 Not tainted 5.11.0-rc4-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:79 [inline]
> >  dump_stack+0x107/0x163 lib/dump_stack.c:120
> >  print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:230
> >  __kasan_report mm/kasan/report.c:396 [inline]
> >  kasan_report.cold+0x79/0xd5 mm/kasan/report.c:413
> >  add_adv_patterns_monitor+0x91f/0xa90 net/bluetooth/mgmt.c:4266
> >  hci_mgmt_cmd net/bluetooth/hci_sock.c:1603 [inline]
> >  hci_sock_sendmsg+0x1b98/0x21d0 net/bluetooth/hci_sock.c:1738
> >  sock_sendmsg_nosec net/socket.c:652 [inline]
> >  sock_sendmsg+0xcf/0x120 net/socket.c:672
> >  sock_write_iter+0x289/0x3c0 net/socket.c:999
> >  call_write_iter include/linux/fs.h:1901 [inline]
> >  new_sync_write+0x426/0x650 fs/read_write.c:518
> >  vfs_write+0x791/0xa30 fs/read_write.c:605
> >  ksys_write+0x1ee/0x250 fs/read_write.c:658
> >  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > RIP: 0033:0x447579
> > Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00
> > RSP: 002b:00007ffe0f4194b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000447579
> > RDX: 0000000000000009 RSI: 0000000020000000 RDI: 0000000000000004
> > RBP: 00000000018e1914 R08: 00000000018e1914 R09: 00007ffe0f4194a0
> > R10: 00007ffe0f4194c0 R11: 0000000000000246 R12: 0000000000000004
> > R13: 0000000000000072 R14: 00000000018e1914 R15: 0000000000000000
> > 
> > Allocated by task 8480:
> >  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
> >  kasan_set_track mm/kasan/common.c:46 [inline]
> >  set_alloc_info mm/kasan/common.c:401 [inline]
> >  ____kasan_kmalloc.constprop.0+0x82/0xa0 mm/kasan/common.c:429
> >  kmalloc include/linux/slab.h:557 [inline]
> >  hci_mgmt_cmd net/bluetooth/hci_sock.c:1508 [inline]
> >  hci_sock_sendmsg+0x9b8/0x21d0 net/bluetooth/hci_sock.c:1738
> >  sock_sendmsg_nosec net/socket.c:652 [inline]
> >  sock_sendmsg+0xcf/0x120 net/socket.c:672
> >  sock_write_iter+0x289/0x3c0 net/socket.c:999
> >  call_write_iter include/linux/fs.h:1901 [inline]
> >  new_sync_write+0x426/0x650 fs/read_write.c:518
> >  vfs_write+0x791/0xa30 fs/read_write.c:605
> >  ksys_write+0x1ee/0x250 fs/read_write.c:658
> >  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> > The buggy address belongs to the object at ffff888013251b20
> >  which belongs to the cache kmalloc-16 of size 16
> > The buggy address is located 9 bytes inside of
> >  16-byte region [ffff888013251b20, ffff888013251b30)
> > The buggy address belongs to the page:
> > page:00000000a4467645 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x13251
> > flags: 0xfff00000000200(slab)
> > raw: 00fff00000000200 ffffea00004ed440 0000000300000003 ffff888010041b40
> > raw: 0000000000000000 0000000080800080 00000001ffffffff 0000000000000000
> > page dumped because: kasan: bad access detected
> > 
> > Memory state around the buggy address:
> >  ffff888013251a00: fb fb fc fc fb fb fc fc 00 00 fc fc fb fb fc fc
> >  ffff888013251a80: 00 00 fc fc 00 00 fc fc fb fb fc fc 00 00 fc fc
> > >ffff888013251b00: 00 00 fc fc 00 01 fc fc fb fb fc fc fa fb fc fc
> >                                   ^
> >  ffff888013251b80: 00 00 fc fc fa fb fc fc fa fb fc fc 00 00 fc fc
> >  ffff888013251c00: fa fb fc fc fa fb fc fc 00 00 fc fc fa fb fc fc
> > ==================================================================
> 
> Fix b139553db5cd ("Bluetooth: Add handler of MGMT_OP_ADD_ADV_PATTERNS_MONITOR")  
> by adding the right-hand buffer boundary check.
> 
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -4238,7 +4238,9 @@ static int add_adv_patterns_monitor(stru
>  
>  	BT_DBG("request for %s", hdev->name);
>  
> -	if (len <= sizeof(*cp) || cp->pattern_count == 0) {
> +	if (len <= sizeof(*cp) || cp->pattern_count == 0 ||
> +	    len < sizeof(*cp) + cp->pattern_count *
> +		    			sizeof(struct mgmt_adv_pattern)) {
>  		err = mgmt_cmd_status(sk, hdev->id,
>  				      MGMT_OP_ADD_ADV_PATTERNS_MONITOR,
>  				      MGMT_STATUS_INVALID_PARAMS);
> 

I think this was already fixed on Jan 22 commit b4a221ea8a1f ("Bluetooth:
advmon offload MSFT add rssi support").

	expected_size += cp->pattern_count * sizeof(struct mgmt_adv_pattern);
	if (len != expected_size) {

Now someone needs to backport it to stable.

regards,
dan carpenter

