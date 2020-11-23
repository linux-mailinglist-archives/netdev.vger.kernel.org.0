Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3070D2C13E7
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730773AbgKWSwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 13:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729298AbgKWSwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 13:52:54 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9357E20657;
        Mon, 23 Nov 2020 18:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606157574;
        bh=kawMhCYvPZP6hiOaiX8l6x/qN2tGGJWcbbyPOIIFaO8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zv2qioxlAl6YuA96BOhylOJBeWU8j07RNPwZXIdu9KbSh6jyNIUV8m32Wy4WSaIZk
         ateIxAXBXiIOWSxQarpGMxjqRsCL7LS9YAB8GWSWER1E8osRzffSZapN4bsme+v9SW
         lMvUh9mM2HbeuFhdwQ9MaGy5cv//9QuqK48vC4Bo=
Date:   Mon, 23 Nov 2020 10:52:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit@kernel.org>, Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: netconsole deadlock with virtnet
Message-ID: <20201123105252.1c295138@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123093128.701cf81b@gandalf.local.home>
References: <20201117102341.GR47002@unreal>
        <20201117093325.78f1486d@gandalf.local.home>
        <X7SK9l0oZ+RTivwF@jagdpanzerIV.localdomain>
        <X7SRxB6C+9Bm+r4q@jagdpanzerIV.localdomain>
        <93b42091-66f2-bb92-6822-473167b2698d@redhat.com>
        <20201118091257.2ee6757a@gandalf.local.home>
        <20201123110855.GD3159@unreal>
        <20201123093128.701cf81b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 09:31:28 -0500 Steven Rostedt wrote:
> On Mon, 23 Nov 2020 13:08:55 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> 
> >  [   10.028024] Chain exists of:
> >  [   10.028025]   console_owner --> target_list_lock --> _xmit_ETHER#2  
> 
> Note, the problem is that we have a location that grabs the xmit_lock while
> holding target_list_lock (and possibly console_owner).

Well, it try_locks the xmit_lock. Does lockdep understand try-locks?

(not that I condone the shenanigans that are going on here)
