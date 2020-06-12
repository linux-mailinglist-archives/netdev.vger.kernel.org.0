Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A3E1F75BC
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 11:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgFLJLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 05:11:01 -0400
Received: from nautica.notk.org ([91.121.71.147]:36412 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgFLJLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 05:11:01 -0400
Received: by nautica.notk.org (Postfix, from userid 1001)
        id BC650C009; Fri, 12 Jun 2020 11:10:59 +0200 (CEST)
Date:   Fri, 12 Jun 2020 11:10:44 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] 9p/trans_fd: Fix concurrency del of req_list in
 p9_fd_cancelled/p9_read_work
Message-ID: <20200612091044.GA11129@nautica>
References: <20200612090833.36149-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200612090833.36149-1-wanghai38@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Hai wrote on Fri, Jun 12, 2020:
> p9_read_work and p9_fd_cancelled may be called concurrently.
> In some cases, req->req_list may be deleted by both p9_read_work
> and p9_fd_cancelled.
> 
> We can fix it by ignoring replies associated with a cancelled
> request and ignoring cancelled request if message has been received
> before lock.
> 
> Fixes: 60ff779c4abb ("9p: client: remove unused code and any reference to "cancelled" function")
> Reported-by: syzbot+77a25acfa0382e06ab23@syzkaller.appspotmail.com
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Thanks! looks good to me, I'll queue for 5.9 as well unless you're in a
hurry.
-- 
Dominique
