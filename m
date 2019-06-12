Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE9141F5A
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 10:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731405AbfFLIiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 04:38:02 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34485 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731305AbfFLIiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 04:38:01 -0400
Received: by mail-pg1-f193.google.com with SMTP id p10so2686148pgn.1;
        Wed, 12 Jun 2019 01:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y8/ijoFBBzQUZdRc/nUXq7hK8svsxDXIeuuqHmcmAoc=;
        b=GV8TEQCOh5B4AGAP4tVJ15uzu8M39Wc0WW7bu2C6P5Rtl76Ovvve3sgrMqocaEHev6
         dUiyDVb1JqMO9ZUAibNmvQckUpvpzXafikTakq8w03J4NEILhdG+NAe4F2b7KoAhxR2+
         FV6CvFVcPymNDRbhKK/ZixiDCdWWNgIaMJVnUwpl0Czeznd8DN12Hdx+vw3xH/n//rH7
         wpqJhbWxGIpJECiWbS1VYIJXa1os513IPOtSoVBwNMWj6+/FaEqsme+w/3eQsoi+5Qtn
         nRtaicoiLZXLqtZqEwufrArEFDaY6kczPQDSeYmGOD3gZqGC3jCywGJv19FA/Kk993ch
         DVhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y8/ijoFBBzQUZdRc/nUXq7hK8svsxDXIeuuqHmcmAoc=;
        b=of4sEah5RtI157FvgKhVUMq4SQYBUtIAFFsOrY85gjC8SpRl+90YZVgzH2ptkv6K8P
         YIHWTIL1V/A7TymY6emLWmwEtwf0tYA0gHHCc50vzVzBN+T99HWHTBJlb7M47KbSEmYL
         PZazYiwgeKADi3K9iEi780RqD2oTgk0MmPVdKx3MQw0Y/ag3IsgnckOkgjUqcAuVhWJ1
         m+n1BeHScllN2dqpAKOYUp6lsdaSUr9W6vgf5GX9XsfPtkDAkoaWfUj5CJsNChYUW+ne
         sFBeeR/J0UKdMw4Pjw/aqtaa6z3/3QrfPMdKyniyhQGrFsT5DZLlYTLR0cxo4ve1pcTV
         dwaQ==
X-Gm-Message-State: APjAAAWN3gKCJlh03C4mgwgvqahbJqrzj8vWLdFM3Hq8ZtId2HR9l7q2
        rX/IEsF2E/sBgQ1eb5yirWM=
X-Google-Smtp-Source: APXvYqy8L6j92Kf5NlJ2DVY+WZ0swRdlLmRjdsE+S274zspfnrqzgl5GDm0qE16TzxsroAFMgJQdlA==
X-Received: by 2002:a17:90a:ad86:: with SMTP id s6mr7022055pjq.42.1560328680781;
        Wed, 12 Jun 2019 01:38:00 -0700 (PDT)
Received: from bridge.tencent.com ([119.28.31.106])
        by smtp.gmail.com with ESMTPSA id c11sm7108896pgg.2.2019.06.12.01.37.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 01:37:59 -0700 (PDT)
Date:   Wed, 12 Jun 2019 16:37:55 +0800
From:   Wenbin Zeng <wenbin.zeng@gmail.com>
To:     "J. Bruce Fields" <bfields@fieldses.org>
Cc:     viro@zeniv.linux.org.uk, davem@davemloft.net, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        wenbinzeng@tencent.com, dsahern@gmail.com,
        nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2 0/3] auth_gss: netns refcount leaks when
 use-gss-proxy==1
Message-ID: <20190612083755.GA27776@bridge.tencent.com>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
 <1557470163-30071-1-git-send-email-wenbinzeng@tencent.com>
 <20190515010331.GA3232@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515010331.GA3232@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 09:03:31PM -0400, J. Bruce Fields wrote:
> Whoops, I was slow to test these.  I'm getting failuring krb5 nfs
> mounts, and the following the server's logs.  Dropping the three patches
> for now.
My bad, I should have found it earlier. Thank you for testing it, Bruce.

I figured it out, the problem that you saw is due to the following code:
the if-condition is incorrect here because sn->gssp_clnt==NULL doesn't mean
inexistence of 'use-gss-proxy':

-static __net_exit void rpcsec_gss_exit_net(struct net *net)
+static void rpcsec_gss_evict_net(struct net *net)
 {
-       gss_svc_shutdown_net(net);
+       struct sunrpc_net *sn = net_generic(net, sunrpc_net_id);
+
+       if (sn->gssp_clnt)
+               gss_svc_shutdown_net(net);
 }

Simply using the original logic in rpcsec_gss_exit_net() should be fine,
i.e.:

-static __net_exit void rpcsec_gss_exit_net(struct net *net)
+static void rpcsec_gss_evict_net(struct net *net)
 {
        gss_svc_shutdown_net(net);
 }

I'm going to submit v3 soon.

Wenbin.

> 
> --b.
> 
> [   40.894408] remove_proc_entry: removing non-empty directory 'net/rpc', leaking at least 'use-gss-proxy'
> [   40.897352] WARNING: CPU: 2 PID: 31 at fs/proc/generic.c:683 remove_proc_entry+0x17d/0x190
> [   40.899373] Modules linked in: nfsd nfs_acl lockd grace auth_rpcgss sunrpc
> [   40.901335] CPU: 2 PID: 31 Comm: kworker/u8:1 Not tainted 5.1.0-10733-g4f10d1cb695e #2220
> [   40.903759] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20180724_192412-buildhw-07.phx2.fedoraproject.org-1.fc29 04/01/2014
> [   40.906972] Workqueue: netns cleanup_net
> [   40.907828] RIP: 0010:remove_proc_entry+0x17d/0x190
> [   40.908904] Code: 52 82 48 85 c0 48 8d 90 48 ff ff ff 48 0f 45 c2 48 8b 93 a8 00 00 00 4c 8b 80 d0 00 00 00 48 8b 92 d0 00 00 00 e8 a7 24 dc ff <0f> 0b e9 52 ff ff ff e8 a7 21 dc ff 0f 1f 80 00 00 00 00 0f 1f 44
> [   40.912689] RSP: 0018:ffffc90000123d80 EFLAGS: 00010282
> [   40.913495] RAX: 0000000000000000 RBX: ffff888079f96e40 RCX: 0000000000000000
> [   40.914747] RDX: ffff88807fd24e80 RSI: ffff88807fd165b8 RDI: 00000000ffffffff
> [   40.916107] RBP: ffff888079f96ef0 R08: 0000000000000000 R09: 0000000000000000
> [   40.917253] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88807cd76d68
> [   40.918508] R13: ffffffffa0057000 R14: ffff8880683db200 R15: ffffffff82970240
> [   40.919642] FS:  0000000000000000(0000) GS:ffff88807fd00000(0000) knlGS:0000000000000000
> [   40.920956] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   40.921867] CR2: 00007f9d70010cb8 CR3: 000000007cc5c006 CR4: 00000000001606e0
> [   40.923044] Call Trace:
> [   40.923364]  sunrpc_exit_net+0xcc/0x190 [sunrpc]
> [   40.924069]  ops_exit_list.isra.0+0x36/0x70
> [   40.924713]  cleanup_net+0x1cb/0x2c0
> [   40.925182]  process_one_work+0x219/0x620
> [   40.925780]  worker_thread+0x3c/0x390
> [   40.926312]  ? process_one_work+0x620/0x620
> [   40.927015]  kthread+0x11d/0x140
> [   40.927430]  ? kthread_park+0x80/0x80
> [   40.927822]  ret_from_fork+0x3a/0x50
> [   40.928281] irq event stamp: 11688
> [   40.928780] hardirqs last  enabled at (11687): [<ffffffff811225fe>] console_unlock+0x41e/0x590
> [   40.930319] hardirqs last disabled at (11688): [<ffffffff81001b2c>] trace_hardirqs_off_thunk+0x1a/0x1c
> [   40.932123] softirqs last  enabled at (11684): [<ffffffff820002c5>] __do_softirq+0x2c5/0x4c5
> [   40.933657] softirqs last disabled at (11673): [<ffffffff810bf970>] irq_exit+0x80/0x90
> 
