Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCB32534F7
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHZQdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgHZQdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:33:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E96AC061574;
        Wed, 26 Aug 2020 09:33:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 534181359D96A;
        Wed, 26 Aug 2020 09:16:46 -0700 (PDT)
Date:   Wed, 26 Aug 2020 09:33:29 -0700 (PDT)
Message-Id: <20200826.093329.96316850316598868.davem@davemloft.net>
To:     aranea@aixah.de
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] veth: Initialize dev->perm_addr
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200826162901.4js4u5u2whusp4l4@vega>
References: <20200826152000.ckxrcfyetdvuvqum@vega>
        <20200826.082857.584544823490249841.davem@davemloft.net>
        <20200826162901.4js4u5u2whusp4l4@vega>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Aug 2020 09:16:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mira Ressel <aranea@aixah.de>
Date: Wed, 26 Aug 2020 16:29:01 +0000

> On Wed, Aug 26, 2020 at 08:28:57AM -0700, David Miller wrote:
>> From: Mira Ressel <aranea@aixah.de>
>> Date: Wed, 26 Aug 2020 15:20:00 +0000
>> 
>> > I'm setting the peer->perm_addr, which would otherwise be zero, to its
>> > dev_addr, which has been either generated randomly by the kernel or
>> > provided by userland in a netlink attribute.
>> 
>> Which by definition makes it not necessarily a "permanent address" and
>> therefore is subject to being different across boots, which is exactly
>> what you don't want to happen for automatic address generation.
> 
> That's true, but since veth devices aren't backed by any hardware, I
> unfortunately don't have a good source for a permanent address. The only
> inherently permanent thing about them is their name.
> 
> People who use the default eui64-based address generation don't get
> persistent link-local addresses for their veth devices out of the box
> either -- the EUI64 is derived from the device's dev_addr, which is
> randomized by default.
> 
> If that presents a problem for anyone, they can configure their userland
> to set the dev_addr to a static value, which handily fixes this problem
> for both address generation algorithms.
> 
> I'm admittedly glancing over one problem here -- I'm only setting the
> perm_addr during device creation, whereas userland can change the
> dev_addr at any time. I'm not sure if it'd make sense here to update the
> perm_addr if the dev_addr is changed later on?

We are talking about which parent device address to inherit from, you
have choosen to use dev_addr and I am saying you should use perm_addr.

Can you explain why this isn't clear?
