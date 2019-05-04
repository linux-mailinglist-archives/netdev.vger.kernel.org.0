Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3AE61373C
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 06:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfEDEKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 00:10:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55786 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfEDEKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 00:10:48 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F1A014D84551;
        Fri,  3 May 2019 21:10:29 -0700 (PDT)
Date:   Sat, 04 May 2019 00:10:25 -0400 (EDT)
Message-Id: <20190504.001025.1191902881190952783.davem@davemloft.net>
To:     wenbin.zeng@gmail.com
Cc:     viro@zeniv.linux.org.uk, bfields@fieldses.org, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        wenbinzeng@tencent.com, dsahern@gmail.com,
        nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 2/3] netns: add netns_evict into netns_operations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1556692945-3996-3-git-send-email-wenbinzeng@tencent.com>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
        <1556692945-3996-3-git-send-email-wenbinzeng@tencent.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 21:10:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenbin Zeng <wenbin.zeng@gmail.com>
Date: Wed,  1 May 2019 14:42:24 +0800

> The newly added netns_evict() shall be called when the netns inode being
> evicted. It provides another path to release netns refcounts, previously
> netns_put() is the only choice, but it is not able to release all netns
> refcount, for example, a rpc client holds two netns refcounts, these
> refcounts are supposed to be released when the rpc client is freed, but
> the code to free rpc client is normally triggered by put() callback only
> when netns refcount gets to 0, specifically:
>     refcount=0 -> cleanup_net() -> ops_exit_list -> free rpc client
> But netns refcount will never get to 0 before rpc client gets freed, to
> break the deadlock, the code to free rpc client can be put into the newly
> added netns_evict.
> 
> Signed-off-by: Wenbin Zeng <wenbinzeng@tencent.com>

Acked-by: David S. Miller <davem@davemloft.net>
