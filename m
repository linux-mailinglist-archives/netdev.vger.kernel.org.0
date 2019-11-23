Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46141107E6F
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 13:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfKWM4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 07:56:55 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38777 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfKWM4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 07:56:55 -0500
Received: by mail-qt1-f196.google.com with SMTP id 14so11321823qtf.5;
        Sat, 23 Nov 2019 04:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KxjUDkEnjpmFkDqh7wFCMnPl1djOk7qGEqwwagwnFm8=;
        b=ozIrx/uy39uboJmsuuIE+Tik0wskfGHwPR8k9OJ4WZfkETIKUVccKEAmTRwFCM0BAp
         UKyTCs+x826s21lKqHIYrBLebaBMjTHpmvqx7AaIJZq6nuft8pEeF2mwkCFKADhCbF90
         C0l9K5RI2t3oGWPyVUZkHAs/M06Qdv2mECELkQ81uiUPRRuBhDqNNP+skmw+SayIqCXo
         C6LmzGKXkNZm4gaI2Qnj6rtXjKY9U5Kqnc69+EN8OEFfmDDsZb6g6eb6sUF9DVj0zfJ1
         zRzO9B9+xXDRmtsrpwVFyMqCh8Po044Vmam8Y8i5UAivQxGDWWGflXQg4UDlV14TOOSI
         miTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KxjUDkEnjpmFkDqh7wFCMnPl1djOk7qGEqwwagwnFm8=;
        b=eOzX2r6QlGqEJt6QDRY3T7baLaL+he6Mhe0/EbdSHG8SZbP3ueVbP9hSN/tR//4OQp
         800KPY53CG43IcSscMmDa9nYxT203iPVRJ49bOQEwG/KqHaQimlKwP3Wl3vwg7YQ1VUf
         u0Ut3d4GyScTsZrtcBQyQbvQtL20FiZz+8btP1/4fipiMqLNGSlkUtAtjxmQFxfv1EPb
         fFeZVmKqXzHxEGT6cKk2w5NiFXSFik5/5bnLqUhc3hGeSJr/Iw391Exfb9vU7XOjFir7
         gnPawJiQXumiDirEo/fj5/WMik3lozS8RTcufDlPuC+sx98e2Lm/4zjvlgV5f41uoqik
         96pQ==
X-Gm-Message-State: APjAAAUYvRgV/PEFsC4px6A2tyIv+nq8p2sY9rcaoIRWuqqFlyrybuyz
        TK30xKMtwmMuxbH1T132iBk=
X-Google-Smtp-Source: APXvYqzS8n4z4gzndr5YXMs2OpYJklujxGZV0GzOhDsUOGWp09U8p5x6xUU5vbrtR5tcdE0NhYBPfw==
X-Received: by 2002:ac8:1087:: with SMTP id a7mr20000354qtj.274.1574513814058;
        Sat, 23 Nov 2019 04:56:54 -0800 (PST)
Received: from localhost.localdomain ([177.220.176.157])
        by smtp.gmail.com with ESMTPSA id b185sm367765qkg.45.2019.11.23.04.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 04:56:53 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 49E0EC4DB7; Sat, 23 Nov 2019 09:56:50 -0300 (-03)
Date:   Sat, 23 Nov 2019 09:56:50 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: cache netns in sctp_ep_common
Message-ID: <20191123125650.GH388551@localhost.localdomain>
References: <f7ecea746b9238b1c996b51c41b5306e00a3d403.1574481409.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7ecea746b9238b1c996b51c41b5306e00a3d403.1574481409.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 11:56:49AM +0800, Xin Long wrote:
> This patch is to fix a data-race reported by syzbot:
> 
>   BUG: KCSAN: data-race in sctp_assoc_migrate / sctp_hash_obj
> 
>   write to 0xffff8880b67c0020 of 8 bytes by task 18908 on cpu 1:
>     sctp_assoc_migrate+0x1a6/0x290 net/sctp/associola.c:1091
>     sctp_sock_migrate+0x8aa/0x9b0 net/sctp/socket.c:9465
>     sctp_accept+0x3c8/0x470 net/sctp/socket.c:4916
>     inet_accept+0x7f/0x360 net/ipv4/af_inet.c:734
>     __sys_accept4+0x224/0x430 net/socket.c:1754
>     __do_sys_accept net/socket.c:1795 [inline]
>     __se_sys_accept net/socket.c:1792 [inline]
>     __x64_sys_accept+0x4e/0x60 net/socket.c:1792
>     do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
>     entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
>   read to 0xffff8880b67c0020 of 8 bytes by task 12003 on cpu 0:
>     sctp_hash_obj+0x4f/0x2d0 net/sctp/input.c:894
>     rht_key_get_hash include/linux/rhashtable.h:133 [inline]
>     rht_key_hashfn include/linux/rhashtable.h:159 [inline]
>     rht_head_hashfn include/linux/rhashtable.h:174 [inline]
>     head_hashfn lib/rhashtable.c:41 [inline]
>     rhashtable_rehash_one lib/rhashtable.c:245 [inline]
>     rhashtable_rehash_chain lib/rhashtable.c:276 [inline]
>     rhashtable_rehash_table lib/rhashtable.c:316 [inline]
>     rht_deferred_worker+0x468/0xab0 lib/rhashtable.c:420
>     process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
>     worker_thread+0xa0/0x800 kernel/workqueue.c:2415
>     kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
>     ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
> 
> It was caused by rhashtable access asoc->base.sk when sctp_assoc_migrate
> is changing its value. However, what rhashtable wants is netns from asoc
> base.sk, and for an asoc, its netns won't change once set. So we can
> simply fix it by caching netns since created.
> 
> Fixes: d6c0256a60e6 ("sctp: add the rhashtable apis for sctp global transport hashtable")
> Reported-by: syzbot+e3b35fe7918ff0ee474e@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
