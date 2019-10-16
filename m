Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D65EFD8689
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391049AbfJPDd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:33:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43994 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730211AbfJPDd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:33:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DFED12B88C22;
        Tue, 15 Oct 2019 20:33:28 -0700 (PDT)
Date:   Tue, 15 Oct 2019 20:33:27 -0700 (PDT)
Message-Id: <20191015.203327.2130838944283050049.davem@davemloft.net>
To:     vinicius.gomes@intel.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, ederson.desouza@intel.com
Subject: Re: [PATCH net v1] sched: etf: Fix ordering of packets with same
 txtime
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191014203822.31741-1-vinicius.gomes@intel.com>
References: <20191014203822.31741-1-vinicius.gomes@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 20:33:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Mon, 14 Oct 2019 13:38:22 -0700

> When a application sends many packets with the same txtime, they may
> be transmitted out of order (different from the order in which they
> were enqueued).
> 
> This happens because when inserting elements into the tree, when the
> txtime of two packets are the same, the new packet is inserted at the
> left side of the tree, causing the reordering. The only effect of this
> change should be that packets with the same txtime will be transmitted
> in the order they are enqueued.
> 
> The application in question (the AVTP GStreamer plugin, still in
> development) is sending video traffic, in which each video frame have
> a single presentation time, the problem is that when packetizing,
> multiple packets end up with the same txtime.
> 
> The receiving side was rejecting packets because they were being
> received out of order.
> 
> Fixes: 25db26a91364 ("net/sched: Introduce the ETF Qdisc")
> Reported-by: Ederson de Souza <ederson.desouza@intel.com>
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Applied and queued up for -stable, thank you.
