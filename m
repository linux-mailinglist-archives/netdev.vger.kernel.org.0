Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1552A3046F
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfE3V6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:58:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60932 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbfE3V6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:58:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E3D3314DB7824;
        Thu, 30 May 2019 14:53:22 -0700 (PDT)
Date:   Thu, 30 May 2019 14:53:22 -0700 (PDT)
Message-Id: <20190530.145322.336585862282292373.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net-gro: fix use-after-free read in
 napi_gro_frags()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529223610.141253-1-edumazet@google.com>
References: <20190529223610.141253-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 14:53:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 29 May 2019 15:36:10 -0700

> If a network driver provides to napi_gro_frags() an
> skb with a page fragment of exactly 14 bytes, the call
> to gro_pull_from_frag0() will 'consume' the fragment
> by calling skb_frag_unref(skb, 0), and the page might
> be freed and reused.
> 
> Reading eth->h_proto at the end of napi_frags_skb() might
> read mangled data, or crash under specific debugging features.
 ...
> Fixes: a50e233c50db ("net-gro: restore frag0 optimization")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks.
