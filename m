Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1FF1C4665
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgEDSvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726334AbgEDSvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:51:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BEDC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 11:51:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C0D1111F5F61A;
        Mon,  4 May 2020 11:51:12 -0700 (PDT)
Date:   Mon, 04 May 2020 11:51:11 -0700 (PDT)
Message-Id: <20200504.115111.2011826515282537226.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com
Subject: Re: [PATCH net-next V2] net: sched: fallback to qdisc noqueue if
 default qdisc setup fail
From:   David Miller <davem@davemloft.net>
In-Reply-To: <158824694174.2180470.8094886910962590764.stgit@firesoul>
References: <158824694174.2180470.8094886910962590764.stgit@firesoul>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 11:51:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Thu, 30 Apr 2020 13:42:22 +0200

> Currently if the default qdisc setup/init fails, the device ends up with
> qdisc "noop", which causes all TX packets to get dropped.
> 
> With the introduction of sysctl net/core/default_qdisc it is possible
> to change the default qdisc to be more advanced, which opens for the
> possibility that Qdisc_ops->init() can fail.
> 
> This patch detect these kind of failures, and choose to fallback to
> qdisc "noqueue", which is so simple that its init call will not fail.
> This allows the interface to continue functioning.
> 
> V2:
> As this also captures memory failures, which are transient, the
> device is not kept in IFF_NO_QUEUE state.  This allows the net_device
> to retry to default qdisc assignment.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Applied, thanks.
