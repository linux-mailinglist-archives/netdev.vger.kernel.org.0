Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DEA6094A5
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 18:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiJWQKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 12:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiJWQKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 12:10:05 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A875E28E3D;
        Sun, 23 Oct 2022 09:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:To:From:Cc:
        Content-ID:Content-Description;
        bh=QldR47Fkax5R3uYQN7ZmHe1wprwTKYC0AVcaPhhHSSo=; b=Yu+EUmthuCP/V553ONfIqmMi5K
        ZRdXRp2NAA/VmrCqmc0EBaHA7oPYjobfsU0IMIkes00FbD6yATu6LcaWUpFZ1PICNmoCzm6uPtv5u
        fVH/LKF6pSGg8/jfNqUWwMyzYY6CHX/aLtyjBje8o7SCMy0lcLlGYlWoUCthm01rH57b1hzqnhc4h
        ZHLxfFE3PoaraSripBka7AsPAYYu92owBSmt2dsOMf5EZGptaza1+3yE1HJywEV0MBQ8uImOUNjfJ
        f9U4b+iW4kURGZQENlxIWgT/Tc1SG73TuQu+J6PV41iBR/5abiNq5H9Un67Oz7GSIQbNWRaxus1mI
        ft0UEM7VD1aCZ9o/jJIIzQtC3+MQn95IWRCDI/yNX4LEl8pk2bQiUcMhz01V22to/14IBXjA6Ubpi
        djUXeAOlm+2WbbqWRbPmZTlZiF5iWy5CxSbQ45hiXz/IxtUexhfRRfft9CBFGAxmWMgNXmreyoh7w
        fxg4Mmrt2XQ+Y0os0AGLOH+lNuS4tT51pzMS4ZJMjGS2jQfedVwrpwAhDbQUDucht4ietKie+nzwn
        yMmieZH8BnmxxFrREGZg+k06nBXCSxZmCKs45yFICjcwW5NVypQmDZZLdXPnl0zs6rM9nfAlTnoB0
        1yl0zVwg4hwNIYupn+qrjD3qC7tY3gMh8K/2mCatE=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, edumazet@google.com,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net,
        syzbot <syzbot+9b69b8d10ab4a7d88056@syzkaller.appspotmail.com>
Subject: Re: [syzbot] BUG: corrupted list in p9_fd_cancel (2)
Date:   Sun, 23 Oct 2022 18:09:25 +0200
Message-ID: <1696818.m3pq8b1E1X@silver>
In-Reply-To: <0000000000009763b605ebb1519a@google.com>
References: <0000000000009763b605ebb1519a@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday, October 23, 2022 12:41:34 PM CEST syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d47136c28015 Merge tag 'hwmon-for-v6.1-rc2' of git://git.k..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12f36de2880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4789759e8a6d5f57
> dashboard link: https://syzkaller.appspot.com/bug?extid=9b69b8d10ab4a7d88056
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1076cb7c880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=102eabd2880000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/5664e231e97f/disk-d47136c2.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/9bbe0daa4a04/vmlinux-d47136c2.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9b69b8d10ab4a7d88056@syzkaller.appspotmail.com
> 
> list_del corruption, ffff88802295c4b0->next is LIST_POISON1 (dead000000000100)
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:55!
[...]
> Call Trace:
>  <TASK>
>  __list_del_entry include/linux/list.h:134 [inline]
>  list_del include/linux/list.h:148 [inline]
>  p9_fd_cancel+0x9c/0x230 net/9p/trans_fd.c:703

I only had a short cycle on this yet: so the problem is that the req_list list
head is removed twice, which triggers this warning from [lib/list_debug.c].

Probably moving spin_unlock() call back down to the end of function
p9_conn_cancel() might fix this:

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 56a186768750..409f0da70c52 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -207,8 +207,6 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
                list_move(&req->req_list, &cancel_list);
        }
 
-       spin_unlock(&m->req_lock);
-
        list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
                p9_debug(P9_DEBUG_ERROR, "call back req %p\n", req);
                list_del(&req->req_list);
@@ -216,6 +214,8 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
                        req->t_err = err;
                p9_client_cb(m->client, req, REQ_STATUS_ERROR);
        }
+
+       spin_unlock(&m->req_lock);
 }
 
 static __poll_t

spin_unlock() was recently moved up a bit to fix a dead lock, however that
dead lock happened with a lock on client level, meanwhile it was converted
into a lock on connection level.

The question is whether that would fix this for good and not just move it,
because there are a bunch of list removal calls that don't check for the
request state or something to prevent a double removal at other places.

Best regards,
Christian Schoenebeck



