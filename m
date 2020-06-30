Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8E320EA2F
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgF3A34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727860AbgF3A34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:29:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB88C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:29:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97321127BE247;
        Mon, 29 Jun 2020 17:29:55 -0700 (PDT)
Date:   Mon, 29 Jun 2020 17:29:54 -0700 (PDT)
Message-Id: <20200629.172954.2096977916313984108.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next 0/6] MPTCP: improve fallback to TCP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1593461586.git.dcaratti@redhat.com>
References: <cover.1593461586.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jun 2020 17:29:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Mon, 29 Jun 2020 22:26:19 +0200

> there are situations where MPTCP sockets should fall-back to regular TCP:
> this series reworks the fallback code to pursue the following goals:
> 
> 1) cleanup the non fallback code, removing most of 'if (<fallback>)' in
>    the data path
> 2) improve performance for non-fallback sockets, avoiding locks in poll()
> 
> further work will also leverage on this changes to achieve:
> 
> a) more consistent behavior of gestockopt()/setsockopt() on passive sockets
>    after fallback
> b) support for "infinite maps" as per RFC8684, section 3.7
> 
> the series is made of the following items:
> 
> - patch 1 lets sendmsg() / recvmsg() / poll() use the main socket also
>   after fallback
> - patch 2 fixes 'simultaneous connect' scenario after fallback. The
>   problem was present also before the rework, but the fix is much easier
>   to implement after patch 1
> - patch 3, 4, 5 are clean-ups for code that is no more needed after the
>   fallback rework
> - patch 6 fixes a race condition between close() and poll(). The problem
>   was theoretically present before the rework, but it became almost
>   systematic after patch 1

Series applied to net-next, thank you.
