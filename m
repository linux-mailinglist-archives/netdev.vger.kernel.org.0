Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306556F11C
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 02:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfGUA0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 20:26:40 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48930 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbfGUA0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 20:26:40 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hozgF-0001k4-W7; Sun, 21 Jul 2019 02:26:24 +0200
Date:   Sun, 21 Jul 2019 02:26:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Wenwen Wang <wang6495@umn.edu>
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:ETHERNET BRIDGE" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: ebtables: compat: fix a memory leak bug
Message-ID: <20190721002623.27wac36rkwa5v5lg@breakpoint.cc>
References: <1563625366-3602-1-git-send-email-wang6495@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563625366-3602-1-git-send-email-wang6495@umn.edu>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wenwen Wang <wang6495@umn.edu> wrote:
> From: Wenwen Wang <wenwen@cs.uga.edu>
> 
> In compat_do_replace(), a temporary buffer is allocated through vmalloc()
> to hold entries copied from the user space. The buffer address is firstly
> saved to 'newinfo->entries', and later on assigned to 'entries_tmp'. Then
> the entries in this temporary buffer is copied to the internal kernel
> structure through compat_copy_entries(). If this copy process fails,
> compat_do_replace() should be terminated. However, the allocated temporary
> buffer is not freed on this path, leading to a memory leak.
> 
> To fix the bug, free the buffer before returning from compat_do_replace().
> 
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>

Reviewed-by: Florian Westphal <fw@strlen.de>
