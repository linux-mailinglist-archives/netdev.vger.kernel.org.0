Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540B769A6D
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 20:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbfGOSEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 14:04:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40056 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfGOSEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 14:04:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 73A6114EB38AE;
        Mon, 15 Jul 2019 11:04:15 -0700 (PDT)
Date:   Mon, 15 Jul 2019 11:04:14 -0700 (PDT)
Message-Id: <20190715.110414.440652178176546301.davem@davemloft.net>
To:     lorenzo.bianconi@redhat.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, marek@cloudflare.com
Subject: Re: [PATCH net v3] net: neigh: fix multiple neigh timer scheduling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <552d7c8de6a07e12f7b76791da953e81478138cd.1563134704.git.lorenzo.bianconi@redhat.com>
References: <552d7c8de6a07e12f7b76791da953e81478138cd.1563134704.git.lorenzo.bianconi@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jul 2019 11:04:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Sun, 14 Jul 2019 23:36:11 +0200

> Neigh timer can be scheduled multiple times from userspace adding
> multiple neigh entries and forcing the neigh timer scheduling passing
> NTF_USE in the netlink requests.
> This will result in a refcount leak and in the following dump stack:
 ...
> Fix the issue unscheduling neigh_timer if selected entry is in 'IN_TIMER'
> receiving a netlink request with NTF_USE flag set
> 
> Reported-by: Marek Majkowski <marek@cloudflare.com>
> Fixes: 0c5c2d308906 ("neigh: Allow for user space users of the neighbour table")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
> Changes since v2:
> - remove check_timer flag and run neigh_del_timer directly
> Changes since v1:
> - fix compilation errors defining neigh_event_send_check_timer routine

Applied and queued up for -stable, thanks.
