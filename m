Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3EE335D3C1
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 01:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243892AbhDLXPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 19:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241881AbhDLXPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 19:15:23 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF93BC061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 16:15:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 799E54D254D0A;
        Mon, 12 Apr 2021 16:15:02 -0700 (PDT)
Date:   Mon, 12 Apr 2021 16:14:58 -0700 (PDT)
Message-Id: <20210412.161458.652699519749470159.davem@davemloft.net>
To:     mst@redhat.com
Cc:     weiwan@google.com, netdev@vger.kernel.org, kuba@kernel.org,
        willemb@google.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210412183141-mutt-send-email-mst@kernel.org>
References: <20210129002136.70865-1-weiwan@google.com>
        <20210412180353-mutt-send-email-mst@kernel.org>
        <20210412183141-mutt-send-email-mst@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 12 Apr 2021 16:15:02 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 12 Apr 2021 18:33:45 -0400

> On Mon, Apr 12, 2021 at 06:08:21PM -0400, Michael S. Tsirkin wrote:
>> OK I started looking at this again. My idea is simple.
>> A. disable callbacks before we try to drain skbs
>> B. actually do disable callbacks even with event idx
>> 
>> To make B not regress, we need to
>> C. detect the common case of disable after event triggering and skip the write then.
>> 
>> I added a new event_triggered flag for that.
>> Completely untested - but then I could not see the warnings either.
>> Would be very much interested to know whether this patch helps
>> resolve the sruprious interrupt problem at all ...
>> 
>> 
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Hmm a slightly cleaner alternative is to clear the flag when enabling interrupts ...
> I wonder which cacheline it's best to use for this.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Please make a fresh new submission if you want to use this approach, thanks.

