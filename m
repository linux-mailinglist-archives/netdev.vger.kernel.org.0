Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B9921E4C5
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgGNAsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgGNAsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:48:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7016C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 17:48:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 429F712986332;
        Mon, 13 Jul 2020 17:48:07 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:48:06 -0700 (PDT)
Message-Id: <20200713.174806.2063718715603167772.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, xiyou.wangcong@gmail.com,
        ap420073@gmail.com
Subject: Re: [PATCH net] net: dsa: link interfaces with the DSA master to
 get rid of lockdep warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200713174227.p6owrtgyccxfbuj5@skbuf>
References: <20200713173049.wzo7e2rpbtfbwdxd@skbuf>
        <20200713173319.zjmqjzqmjcxw6gyf@skbuf>
        <20200713174227.p6owrtgyccxfbuj5@skbuf>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 17:48:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon, 13 Jul 2020 20:42:27 +0300

> One difference from VLAN is that in that case, the entire
> register_vlan_device() function runs under RTNL.
> When those bugs that you talk about are found, who starts using the
> network interface too early? User space or someone else? Would RTNL be
> enough to avoid that?

As soon as the notifier is emitted by register_netdev(), userspace
like components such as NetworkManager can and do ifup the device
immediately.
