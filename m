Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FD02B5554
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731005AbgKPXrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:47:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbgKPXrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 18:47:12 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 186A42463F;
        Mon, 16 Nov 2020 23:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605570431;
        bh=qILH6AzmCoPX2IGtt7Qd5/PdLqvcWKBHIeVayxdHahQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JuKa+x6YCFGuwYJZxKcJwr5lbUlUtJMBQcAMdE+w2t5tKUI/urxs+t8f9frikKAGp
         IQIgznr4oKOUvCBwY6LZcUY6Ud3yGOYVaqhlrmmASveK0z6nmIduZDII3fnBbfV4xT
         kIV44t2AtyoYgrU1cumudwR5fukZdlNNSMz4Z69I=
Date:   Mon, 16 Nov 2020 15:47:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Yunjian Wang <wangyunjian@huawei.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: Have netpoll bring-up DSA management interface
Message-ID: <20201116154710.20627867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d2dbb984-604a-ecbd-e717-2e9942fdbdaa@gmail.com>
References: <20201019171746.991720-1-f.fainelli@gmail.com>
        <20201019200258.jrtymxikwrijkvpq@skbuf>
        <58b07285-bb70-3115-eb03-5e43a4abeae6@gmail.com>
        <20201019211916.j77jptfpryrhau4z@skbuf>
        <20201020181247.7e1c161b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a8d38b5b-ae85-b1a8-f139-ae75f7c01376@gmail.com>
        <d2dbb984-604a-ecbd-e717-2e9942fdbdaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 15:20:37 -0800 Florian Fainelli wrote:
> >> Florian for you patch specifially - can't we use
> >> netdev_for_each_lower_dev()?  
> > 
> > Looks like I forgot to respond here, yes we could do that because we do
> > call netdev_upper_dev_link() in net/dsa/slave.c. Let me re-post with
> > that done.  
> 
> I remember now there was a reason for me to "open code" this, and this
> is because since the patch is intended to be a bug fix, I wanted it to
> be independent from: 2f1e8ea726e9 ("net: dsa: link interfaces with the
> DSA master to get rid of lockdep warnings")
> 
> which we would be depending on and is only two-ish releases away. Let me
> know if you prefer different fixes for different branches.

Ah, makes sense, we can apply this and then clean up in net-next. Just
mention that in the commit message. FWIW you'll need to repost anyway
once the discussion with Vladimir is resolved, because this is in the
old patchwork instance :)
