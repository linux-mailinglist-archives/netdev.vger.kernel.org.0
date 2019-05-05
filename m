Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E201414B
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfEEREX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:04:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52564 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEEREX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:04:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 668DA14D9DA90;
        Sun,  5 May 2019 10:04:22 -0700 (PDT)
Date:   Sun, 05 May 2019 10:04:21 -0700 (PDT)
Message-Id: <20190505.100421.2250762717881638194.davem@davemloft.net>
To:     viro@zeniv.linux.org.uk
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC] folding socket->wq into struct socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190502163223.GW23075@ZenIV.linux.org.uk>
References: <20190502163223.GW23075@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:04:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>
Date: Thu, 2 May 2019 17:32:23 +0100

> it appears that we might take freeing the socket itself to the
> RCU-delayed part, along with socket->wq.  And doing that has
> an interesting benefit - the only reason to do two separate
> allocation disappears.

I'm pretty sure we looked into RCU freeing the socket in the
past but ended up not doing so.

I think it had to do with the latency in releasing sock related
objects.

However, I might be confusing "struct socket" with "struct sock"
