Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F411B4D63
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 21:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgDVTdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 15:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725935AbgDVTdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 15:33:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44B4C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 12:33:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09FDC120ED563;
        Wed, 22 Apr 2020 12:32:59 -0700 (PDT)
Date:   Wed, 22 Apr 2020 12:32:59 -0700 (PDT)
Message-Id: <20200422.123259.1847780703992561178.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, trev@larock.ca,
        dsahern@gmail.com
Subject: Re: [PATCH net 0/2] net: Fix looping with vrf, xfrms and qdisc on
 VRF
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200420231352.50855-1-dsahern@kernel.org>
References: <20200420231352.50855-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 12:33:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Mon, 20 Apr 2020 17:13:50 -0600

> From: David Ahern <dsahern@gmail.com>
> 
> Trev reported that use of VRFs with xfrms is looping when a qdisc
> is added to the VRF device. The combination of xfrm + qdisc is not
> handled by the VRF driver which lost track that it has already
> seen the packet.
> 
> The XFRM_TRANSFORMED flag is used by the netfilter code for a similar
> purpose, so re-use for VRF. Patch 1 drops the #ifdef around setting
> the flag in the xfrm output functions. Patch 2 adds a check to
> the VRF driver for flag; if set the packet has already passed through
> the VRF driver once and does not need to recirculated a second time.
> 
> This is a day 1 bug with VRFs; stable wise, I would only take this
> back to 4.14. I have a set of test cases which I will submit to
> net-next.

Series applied and queued up for -stable, thanks David.
