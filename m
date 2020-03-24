Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D99571904A9
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgCXEwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:52:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56382 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgCXEwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:52:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DC450157A57E8;
        Mon, 23 Mar 2020 21:52:52 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:52:51 -0700 (PDT)
Message-Id: <20200323.215251.2231810044873788090.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     kuba@kernel.org, netdev@vger.kernel.org, andrew@lunn.ch,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] ethtool: fix reference leak in some *_SET
 handlers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200322212421.4A8B1E0FD3@unicorn.suse.cz>
References: <20200322212421.4A8B1E0FD3@unicorn.suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:52:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Sun, 22 Mar 2020 22:24:21 +0100 (CET)

> Andrew noticed that some handlers for *_SET commands leak a netdev
> reference if required ethtool_ops callbacks do not exist. A simple
> reproducer would be e.g.
> 
>   ip link add veth1 type veth peer name veth2
>   ethtool -s veth1 wol g
>   ip link del veth1
> 
> Make sure dev_put() is called when ethtool_ops check fails.
> 
> v2: add Fixes tags
> 
> Fixes: a53f3d41e4d3 ("ethtool: set link settings with LINKINFO_SET request")
> Fixes: bfbcfe2032e7 ("ethtool: set link modes related data with LINKMODES_SET request")
> Fixes: e54d04e3afea ("ethtool: set message mask with DEBUG_SET request")
> Fixes: 8d425b19b305 ("ethtool: set wake-on-lan settings with WOL_SET request")
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Applied, thanks Michal.
