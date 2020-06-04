Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03951EEDE3
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 00:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgFDWpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 18:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgFDWpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 18:45:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F41C08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 15:45:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6D77120477C4;
        Thu,  4 Jun 2020 15:45:35 -0700 (PDT)
Date:   Thu, 04 Jun 2020 15:45:35 -0700 (PDT)
Message-Id: <20200604.154535.1521879275039168496.davem@davemloft.net>
To:     jbenc@redhat.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] geneve: change from tx_error to tx_dropped on
 missing metadata
From:   David Miller <davem@davemloft.net>
In-Reply-To: <66009f71a08cba878fbdf86ca8dd137cdf19eaac.1591175373.git.jbenc@redhat.com>
References: <66009f71a08cba878fbdf86ca8dd137cdf19eaac.1591175373.git.jbenc@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 15:45:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>
Date: Wed,  3 Jun 2020 11:12:14 +0200

> If the geneve interface is in collect_md (external) mode, it can't send any
> packets submitted directly to its net interface, as such packets won't have
> metadata attached. This is expected.
> 
> However, the kernel itself sends some packets to the interface, most
> notably, IPv6 DAD, IPv6 multicast listener reports, etc. This is not wrong,
> as tunnel metadata can be specified in routing table (although technically,
> that has never worked for IPv6, but hopefully will be fixed eventually) and
> then the interface must correctly participate in IPv6 housekeeping.
> 
> The problem is that any such attempt increases the tx_error counter. Just
> bringing up a geneve interface with IPv6 enabled is enough to see a number
> of tx_errors. That causes confusion among users, prompting them to find
> a network error where there is none.
> 
> Change the counter used to tx_dropped. That better conveys the meaning
> (there's nothing wrong going on, just some packets are getting dropped) and
> hopefully will make admins panic less.
> 
> Signed-off-by: Jiri Benc <jbenc@redhat.com>

Seems reasonable, applied, thanks Jiri.
