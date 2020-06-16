Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4421FA57D
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 03:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgFPBRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 21:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgFPBRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 21:17:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F242FC061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 18:17:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5DC1E12358251;
        Mon, 15 Jun 2020 18:17:02 -0700 (PDT)
Date:   Mon, 15 Jun 2020 18:17:01 -0700 (PDT)
Message-Id: <20200615.181701.1458193855639723291.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, xeb@mail.ru
Subject: Re: [PATCH net] ip6_gre: fix use-after-free in
 ip6gre_tunnel_lookup()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200615150751.21813-1-ap420073@gmail.com>
References: <20200615150751.21813-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 18:17:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Mon, 15 Jun 2020 15:07:51 +0000

> In the datapath, the ip6gre_tunnel_lookup() is used and it internally uses
> fallback tunnel device pointer, which is fb_tunnel_dev.
> This pointer is protected by RTNL. It's not enough to be used
> in the datapath.
> So, this pointer would be used after an interface is deleted.
> It eventually results in the use-after-free problem.
> 
> In order to avoid the problem, the new tunnel pointer variable is added,
> which indicates a fallback tunnel device's tunnel pointer.
> This is protected by both RTNL and RCU.
> So, it's safe to be used in the datapath.
 ...

I'm marking this changes requested because it seems like the feedback Eric
Dumazet provided for the ip_tunnel version of this fix applies here too.

Thank you.
