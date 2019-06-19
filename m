Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAA34C2FC
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 23:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbfFSV35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 17:29:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40824 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfFSV35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 17:29:57 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 375FD14771132;
        Wed, 19 Jun 2019 14:29:56 -0700 (PDT)
Date:   Wed, 19 Jun 2019 17:29:55 -0400 (EDT)
Message-Id: <20190619.172955.2027826462085142095.davem@davemloft.net>
To:     mka@chromium.org
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        alexander.h.duyck@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dianders@chromium.org
Subject: Re: [PATCH] net/ipv4: fib_trie: Avoid cryptic ternary expressions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190618211440.54179-1-mka@chromium.org>
References: <20190618211440.54179-1-mka@chromium.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 14:29:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>
Date: Tue, 18 Jun 2019 14:14:40 -0700

> empty_child_inc/dec() use the ternary operator for conditional
> operations. The conditions involve the post/pre in/decrement
> operator and the operation is only performed when the condition
> is *not* true. This is hard to parse for humans, use a regular
> 'if' construct instead and perform the in/decrement separately.
> 
> This also fixes two warnings that are emitted about the value
> of the ternary expression being unused, when building the kernel
> with clang + "kbuild: Remove unnecessary -Wno-unused-value"
> (https://lore.kernel.org/patchwork/patch/1089869/):
> 
> CC      net/ipv4/fib_trie.o
> net/ipv4/fib_trie.c:351:2: error: expression result unused [-Werror,-Wunused-value]
>         ++tn_info(n)->empty_children ? : ++tn_info(n)->full_children;
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>

Applied to net-next, thanks.
