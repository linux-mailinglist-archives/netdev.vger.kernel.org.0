Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8F41A518
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 00:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbfEJWNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 18:13:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58690 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727943AbfEJWNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 18:13:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C53DB133E9747;
        Fri, 10 May 2019 15:13:33 -0700 (PDT)
Date:   Fri, 10 May 2019 15:13:33 -0700 (PDT)
Message-Id: <20190510.151333.266788690200661708.davem@davemloft.net>
To:     wenbin.zeng@gmail.com
Cc:     bfields@fieldses.org, viro@zeniv.linux.org.uk, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        wenbinzeng@tencent.com, dsahern@gmail.com,
        nicolas.dichtel@6wind.com, willy@infradead.org,
        edumazet@google.com, jakub.kicinski@netronome.com,
        tyhicks@canonical.com, chuck.lever@oracle.com, neilb@suse.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] netns: add netns_evict into netns_operations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557470163-30071-3-git-send-email-wenbinzeng@tencent.com>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
        <1557470163-30071-1-git-send-email-wenbinzeng@tencent.com>
        <1557470163-30071-3-git-send-email-wenbinzeng@tencent.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 May 2019 15:13:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenbin Zeng <wenbin.zeng@gmail.com>
Date: Fri, 10 May 2019 14:36:02 +0800

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
