Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703DE1C4688
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 21:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgEDTAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 15:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbgEDTAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 15:00:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D11C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 12:00:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E341F120ED551;
        Mon,  4 May 2020 12:00:45 -0700 (PDT)
Date:   Mon, 04 May 2020 12:00:45 -0700 (PDT)
Message-Id: <20200504.120045.2188101121107984298.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, l.dmxcsnsbh@gmail.com
Subject: Re: [Patch net] atm: fix a UAF in lec_arp_clear_vccs()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200501181109.14542-1-xiyou.wangcong@gmail.com>
References: <20200501181109.14542-1-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 12:00:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Fri,  1 May 2020 11:11:08 -0700

> Gengming reported a UAF in lec_arp_clear_vccs(),
> where we add a vcc socket to an entry in a per-device
> list but free the socket without removing it from the
> list when vcc->dev is NULL.
> 
> We need to call lec_vcc_close() to search and remove
> those entries contain the vcc being destroyed. This can
> be done by calling vcc->push(vcc, NULL) unconditionally
> in vcc_destroy_socket().
> 
> Another issue discovered by Gengming's reproducer is
> the vcc->dev may point to the static device lecatm_dev,
> for which we don't need to register/unregister device,
> so we can just check for vcc->dev->ops->owner.
> 
> Reported-by: Gengming Liu <l.dmxcsnsbh@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied.
