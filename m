Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB66253A98
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 01:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgHZXRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 19:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgHZXRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 19:17:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCAEC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 16:17:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F362612982996;
        Wed, 26 Aug 2020 16:00:44 -0700 (PDT)
Date:   Wed, 26 Aug 2020 16:17:30 -0700 (PDT)
Message-Id: <20200826.161730.2188402243333115569.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     eric.dumazet@gmail.com, michael.chan@broadcom.com,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net 0/2] net: fix netpoll crash with bnxt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200826194007.1962762-1-kuba@kernel.org>
References: <20200826194007.1962762-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Aug 2020 16:00:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 26 Aug 2020 12:40:05 -0700

> Rob run into crashes when using XDP on bnxt. Upon investigation
> it turns out that during driver reconfig irq core produces
> a warning message when IRQs are requested. This triggers netpoll,
> which in turn accesses uninitialized driver state. Same crash can
> also be triggered on this platform by changing the number of rings.
> 
> Looks like we have two missing pieces here, netif_napi_add() has
> to make sure we start out with netpoll blocked. The driver also
> has to be more careful about when napi gets enabled.
> 
> Tested XDP and channel count changes, the warning message no longer
> causes a crash. Not sure if the memory barriers added in patch 1
> are necessary, but it seems we should have them.

Series applied and queued up for -stable, thanks Jakub.
